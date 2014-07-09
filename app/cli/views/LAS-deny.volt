{# LAS-deny #}
{# Clear the chains #}
{{ ipt }} -t nat -F lasDenyNPre
{{ ipt }} -t filter -F lasDenyFFor

{# Denied clients/devices #}
{% for client in clients.filter(las__filter('status', '==', clients__DISCONNECTED())) %}
    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
        {{ ipt }} -t filter -A lasDenyFFor -m mac --mac-source {{ device.MAC }} -p udp --dport 53 -j ACCEPT
        {{ ipt }} -t filter -A lasDenyFFor -m mac --mac-source {{ device.MAC }} -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT
        {{ ipt }} -t nat -A lasDenyNPre -m mac --mac-source {{ device.MAC }} -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}
    {% endfor %}
{% endfor %}