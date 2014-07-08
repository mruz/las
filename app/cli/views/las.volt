{# LAS-main #}
echo 1 > /proc/sys/net/ipv4/ip_forward

{# Clear the filter table #}
{{ ipt }} -F
{{ ipt }} -X

{# Clear the nat table #}
{{ ipt }} -t nat -F
{{ ipt }} -t nat -X

{# Clear the mangle table #}
{{ ipt }} -t mangle -F
{{ ipt }} -t mangle -X

{# Reset the counters #}
{{ ipt }} -Z
{{ ipt }} -t nat -Z
{{ ipt }} -t mangle -Z

{# Clear the queues #}
{{ ipt }} -t filter -F FORWARD
{{ tc }} qdisc del dev {{ lan.interface }} root >/dev/null
{{ tc }} qdisc del dev {{ wan.interface }} root >/dev/null

{# Set default policy #}
{{ ipt }} -P INPUT DROP
{{ ipt }} -P FORWARD DROP
{{ ipt }} -P OUTPUT DROP

{# Allow for loopback traffic #}
{{ ipt }} -A INPUT -i lo -j ACCEPT
{{ ipt }} -A OUTPUT -o lo -j ACCEPT

{# Allow ICMP packets #}
{{ ipt }} -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
{{ ipt }} -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT

{# Nat table, chains for prerouting deny, msg, redirect #}
{{ ipt }} -t nat -N LAS-NAT-DENY-PRE
{{ ipt }} -t nat -N LAS-NAT-MSG-PRE
{{ ipt }} -t nat -N LAS-NAT-REDIRECT-PRE

{# Mangle table, chains for forward download, upload #}
{{ ipt }} -t mangle -N LAS-MANGLE-DOWNLOAD
{{ ipt }} -t mangle -N LAS-MANGLE-UPLOAD
{{ ipt }} -t mangle -N LAS-MANGLE-ALIEN

{# Filter table, chains for forward deny, msg, allow, alien #}
{{ ipt }} -N LAS-FILTER-DENY
{{ ipt }} -N LAS-FILTER-MSG
{{ ipt }} -N LAS-FILTER-ALLOW
{{ ipt }} -N LAS-FILTER-ALLOW-NEW
{{ ipt }} -N LAS-FILTER-ALIEN

{# Filter table, chains for input, output #}
{{ ipt }} -N LAS-FILTER-INPUT
{{ ipt }} -N LAS-FILTER-OUTPUT

{# Nat table, chains for postrouting alien, redirect #}
{{ ipt }} -t nat -N LAS-NAT-ALLOW-POST
{{ ipt }} -t nat -N LAS-NAT-ALIEN-POST
{{ ipt }} -t nat -N LAS-NAT-REDIRECT-POST

{# Apply chains #}
{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-DENY-PRE
{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-MSG-PRE
{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-REDIRECT-PRE
{{ ipt }} -t mangle -A FORWARD -i {{ wan.interface }} -o {{ lan.interface }} -j LAS-MANGLE-DOWNLOAD
{{ ipt }} -t mangle -A FORWARD -i {{ lan.interface }} -o {{ wan.interface }} -j LAS-MANGLE-UPLOAD
{{ ipt }} -t mangle -A FORWARD -j LAS-MANGLE-ALIEN
{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-ALLOW-POST
{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-ALIEN-POST
{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-REDIRECT-POST

{# Download tariffs #}
{{ tc }} qdisc add dev {{ lan.interface }} root handle 1:0 htb
{{ tc }} class add dev {{ lan.interface }} parent 1: classid 1:1 htb rate 990mbit ceil 990mbit
{{ tc }} class add dev {{ lan.interface }} parent 1:1 classid 1:2 htb rate {{ wan.download }}{{ settings.bitRate }}

{# Upload tariffs #}
{{ tc }} qdisc add dev {{ wan.interface }} root handle 1: htb
{{ tc }} class add dev {{ wan.interface }} parent 1: classid 1:1 htb rate 990mbit ceil 990mbit
{{ tc }} class add dev {{ wan.interface }} parent 1:1 classid 1:2 htb rate {{ wan.upload }}{{ settings.bitRate }}

{% for tariff in tariffs %}
    {# Download #}
    {{ tc }} class add dev {{ lan.interface }} parent 1:2 classid 1:1{{ tariff.priority }} htb rate {{ tariff.downloadRate ~ settings.bitRate }} ceil {{ tariff.downloadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ EOL }}
    {{ tc }} filter add dev {{ lan.interface }} parent 1:0 prio {{ tariff.priority }} protocol ip handle 1{{ tariff.priority }} fw flowid 1:1{{ tariff.priority }}{{ EOL }}
    {{ tc }} qdisc add dev {{ lan.interface }} parent 1:1{{ tariff.priority }} handle 1{{ tariff.priority }}: sfq perturb 10
    
    {# Subclasses for tariff #}
    {% if settings.enableQos %}
        {% for priority, qos in services__priority(null) %}
            {{ tc }} class add dev {{ lan.interface }} parent 1:1{{ tariff.priority }} classid 1:1{{ tariff.priority }}{{ priority }} htb rate {{ qos['rate']/100*tariff.downloadRate ~ settings.bitRate }} ceil {{ qos['ceil']/100*tariff.downloadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ priority }}{{ EOL }}
            {{ tc }} filter add dev {{ lan.interface }} parent 1:0 prio {{ tariff.priority }}{{ priority }} protocol ip handle 1{{ tariff.priority }}{{ priority }} fw flowid 1:1{{ tariff.priority }}{{ priority }}{{ EOL }}
            {{ tc }} qdisc add dev {{ lan.interface }} parent 1:1{{ tariff.priority }}{{ priority }} handle 1{{ tariff.priority }}{{ priority }}: sfq perturb 10
        {% endfor %}
    {% endif %}

    {# Upload #}
    {{ tc }} class add dev {{ wan.interface }} parent 1:2 classid 1:1{{ tariff.priority }} htb rate {{ tariff.uploadRate ~ settings.bitRate }} ceil {{ tariff.uploadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ EOL }}
    {{ tc }} filter add dev {{ wan.interface }} parent 1:0 prio {{ tariff.priority }} protocol ip handle 1{{ tariff.priority }} fw flowid 1:1{{ tariff.priority }}{{ EOL }}
    {{ tc }} qdisc add dev {{ wan.interface }} parent 1:1{{ tariff.priority }} handle 1{{ tariff.priority }}: sfq perturb 10
{% endfor %}

{# Redirects #}
{% for redirect in redirects %}
    {% set device = redirect.getDevice() %}
    {{ ipt }} -t nat -A LAS-NAT-REDIRECT-PRE -d {{ wan.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? 'tcp' : 'udp' }} --dport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? ':' ~ redirect.externalEndingPort : '' }} -j DNAT --to {{ device.IP|long2ip }} --sport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? ':' ~ redirect.internalEndingPort : '' }}{{ EOL }}
    {{ ipt }} -t nat -A LAS-NAT-REDIRECT-POST -d {{ device.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? 'tcp' : 'udp' }} --dport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? ':' ~ redirect.internalEndingPort : '' }} -j SNAT --to {{ wan.IP|long2ip }} --sport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? ':' ~ redirect.externalEndingPort : '' }}{{ EOL }}
{% endfor %}

{# Input #}
{{ ipt }} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
{{ ipt }} -A INPUT -j LAS-FILTER-INPUT
{{ ipt }} -A INPUT -m state --state INVALID -j DROP
{{ ipt }} -A INPUT -j LOG --log-prefix "DROP_INPUT " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Output #}
{{ ipt }} -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
{{ ipt }} -A OUTPUT -j LAS-FILTER-OUTPUT
{{ ipt }} -A OUTPUT -m state --state INVALID -j DROP
{{ ipt }} -A OUTPUT -j LOG --log-prefix "DROP_OUTPUT " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Forward #}
{{ ipt }} -A FORWARD -j LAS-FILTER-DENY
{{ ipt }} -A FORWARD -j LAS-FILTER-MSG
{{ ipt }} -A FORWARD -j LAS-FILTER-ALLOW
{{ ipt }} -A FORWARD -j LAS-FILTER-ALLOW-NEW
{{ ipt }} -A FORWARD -j LAS-FILTER-ALIEN
{{ ipt }} -A FORWARD -m state --state INVALID -j DROP
{{ ipt }} -A FORWARD -j LOG --log-prefix "DROP_FORWARD " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Allow to Internet #}
{{ ipt }} -t nat -A LAS-NAT-ALLOW-POST -m mark --mark ! 999 -s {{ lan.subnetwork|long2ip }}{{ lan.mask }} -o {{ wan.interface }} -j SNAT --to {{ wan.IP|long2ip }}

{# Alien #}
{{ ipt }} -t mangle -A LAS-MANGLE-ALIEN -j MARK --set-mark 999
{{ ipt }} -A LAS-FILTER-ALIEN -p udp --dport 53 -j ACCEPT
{{ ipt }} -A LAS-FILTER-ALIEN -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT
{{ ipt }} -t nat -A LAS-NAT-ALIEN-POST -m mark --mark 999 -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}

{# Active clients #}
{% for client in clients.filter(las__filter('status', '==', clients__ACTIVE())) %}
    {% set tariff = client.getTariff() %}

    {# Client's ACTIVE devices #}
    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
        {{ ipt }} -t mangle -A LAS-MANGLE-DOWNLOAD -d {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}
        {{ ipt }} -t mangle -A LAS-MANGLE-UPLOAD -s {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}

        {# Allow for established and related packets #}
        {{ ipt }} -A LAS-FILTER-ALLOW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }} -m state --state ESTABLISHED,RELATED -j ACCEPT

        {# Apply default services #}
        {% for service in services %}
            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ service.IP|long2ip : ''}}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }} -m state --state NEW -j ACCEPT
        {% endfor %}

        {# Apply client's services #}
        {% for service in client.getServices("status=" ~ services__ACTIVE()) %}
            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ device.IP|long2ip : ''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }} -m state --state NEW -j ACCEPT
        {% endfor %}

        {# Apply device's services #}
        {% for service in device.getServices("status=" ~ services__ACTIVE()) %}
            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ device.IP|long2ip : ''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }} -m state --state NEW -j ACCEPT
        {% endfor %}

        {# Default rule #}
        {{ ipt }} -A LAS-FILTER-ALLOW-NEW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }}{{ service.string ? ' -m string --string "' ~ service.string ~ '" --algo kmp' : '' }} -m state --state NEW -j ACCEPT
    {% endfor %}
{% endfor %}

