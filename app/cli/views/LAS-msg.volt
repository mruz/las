{# LAS-msg #}
{# Clear the chains #}
{{ ipt }} -t nat -F lasMsgNPre
{{ ipt }} -t filter -F lasMsgFFor

{# Reminders #}
{% for client in clients.filter(las__filter('status', '==', clients__INDEBTED())) %}
    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
        {{ ipt }} -t filter -A lasMsgFFor -m mac --mac-source {{ device.MAC }} -p udp --dport 53 -j ACCEPT
        {{ ipt }} -t filter -A lasMsgFFor -m mac --mac-source {{ device.MAC }} -p tcp -m multiport ! --dport 80,53,{{ settings.port }} -j REJECT
        {{ ipt }} -t nat -A lasMsgNPre -m mac --mac-source {{ device.MAC }} -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}
    {% endfor %}
{% endfor %}

{# Messages #}
{% for message in messages %}
    {% set client = message.getClient() %}
    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
        {{ ipt }} -t filter -A lasMsgFFor -m mac --mac-source {{ device.MAC }} -p udp --dport 53 -j ACCEPT
        {{ ipt }} -t filter -A lasMsgFFor -m mac --mac-source {{ device.MAC }} -p tcp -m multiport ! --dport 80,53,{{ settings.port }} -j REJECT
        {{ ipt }} -t nat -A lasMsgNPre -m mac --mac-source {{ device.MAC }} -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}
    {% endfor %}
{% endfor %}