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
{{ tc }} qdisc del dev {{ lan.interface }} root 2>/dev/null
{{ tc }} qdisc del dev {{ wan.interface }} root 2>/dev/null

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
{{ ipt }} -t nat -N lasDenyNPre
{{ ipt }} -t nat -N lasMsgNPre
{{ ipt }} -t nat -N lasRedNPre

{# Mangle table, chains for forward download, upload #}
{{ ipt }} -t mangle -N lasDownMFor
{{ ipt }} -t mangle -N lasUpMFor
{{ ipt }} -t mangle -N lasAlienMFor

{# Filter table, chains for forward deny, msg, allow, alien #}
{{ ipt }} -N lasDenyFFor
{{ ipt }} -N lasMsgFFor
{{ ipt }} -N lasAllowFFor
{{ ipt }} -N lasAlienFFor

{# Filter table, chains for input, output #}
{{ ipt }} -N lasFIn
{{ ipt }} -N lasFOut

{# Nat table, chains for postrouting redirect, allow, alien #}
{{ ipt }} -t nat -N lasRedNPos
{{ ipt }} -t nat -N lasAllowNPos
{{ ipt }} -t nat -N lasAlienNPos

{# Apply chains #}
{{ ipt }} -t nat -A PREROUTING -j lasDenyNPre
{{ ipt }} -t nat -A PREROUTING -j lasMsgNPre
{{ ipt }} -t nat -A PREROUTING -j lasRedNPre

{{ ipt }} -t mangle -A FORWARD -i {{ wan.interface }} -o {{ lan.interface }} -j lasDownMFor
{{ ipt }} -t mangle -A FORWARD -i {{ lan.interface }} -o {{ wan.interface }} -j lasUpMFor
{{ ipt }} -t mangle -A FORWARD -i {{ lan.interface }} -o {{ wan.interface }} -j lasAlienMFor

{{ ipt }} -t nat -A POSTROUTING -j lasRedNPos
{{ ipt }} -t nat -A POSTROUTING -j lasAllowNPos
{{ ipt }} -t nat -A POSTROUTING -j lasAlienNPos

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
    
    {# Qos for download #}
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
    
    {# Qos for upload #}
    {% if settings.enableQos %}
        {% for priority, qos in services__priority(null) %}
            {{ tc }} class add dev {{ wan.interface }} parent 1:1{{ tariff.priority }} classid 1:1{{ tariff.priority }}{{ priority }} htb rate {{ qos['rate']/100*tariff.uploadRate ~ settings.bitRate }} ceil {{ qos['ceil']/100*tariff.uploadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ priority }}{{ EOL }}
            {{ tc }} filter add dev {{ wan.interface }} parent 1:0 prio {{ tariff.priority }}{{ priority }} protocol ip handle 1{{ tariff.priority }}{{ priority }} fw flowid 1:1{{ tariff.priority }}{{ priority }}{{ EOL }}
            {{ tc }} qdisc add dev {{ wan.interface }} parent 1:1{{ tariff.priority }}{{ priority }} handle 1{{ tariff.priority }}{{ priority }}: sfq perturb 10
        {% endfor %}
    {% endif %}
{% endfor %}

{# Input #}
{{ ipt }} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
{{ ipt }} -A INPUT -j lasFIn
{{ ipt }} -A INPUT -m state --state INVALID -j DROP
{{ ipt }} -A INPUT -j LOG --log-prefix "DROP_INPUT " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Output #}
{{ ipt }} -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
{{ ipt }} -A OUTPUT -j lasFOut
{{ ipt }} -A OUTPUT -m state --state INVALID -j DROP
{{ ipt }} -A OUTPUT -j LOG --log-prefix "DROP_OUTPUT " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Forward #}
{{ ipt }} -A FORWARD -m state --state ESTABLISHED,RELATED -j ACCEPT
{{ ipt }} -A FORWARD -j lasDenyFFor
{{ ipt }} -A FORWARD -j lasMsgFFor
{{ ipt }} -A FORWARD -j lasAllowFFor
{{ ipt }} -A FORWARD -j lasAlienFFor
{{ ipt }} -A FORWARD -m state --state INVALID -j DROP
{{ ipt }} -A FORWARD -j LOG --log-prefix "DROP_FORWARD " --log-tcp-options --log-ip-options --log-tcp-sequence

{# Allow to Internet #}
{{ ipt }} -t nat -A lasAllowNPos -m mark --mark ! 999 -s {{ lan.subnetwork|long2ip }}{{ lan.mask }} -o {{ wan.interface }} -j SNAT --to {{ wan.IP|long2ip }}

{# Load partial firewalls #}
{{ partial('LAS-red') }}
{{ partial('LAS-deny') }}
{{ partial('LAS-msg') }}
{{ partial('LAS-allow') }}
{{ partial('LAS-alien') }}