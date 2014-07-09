{# LAS-alien #}
{# Clear the chains #}
{{ ipt }} -t mangle -F lasAlienMFor
{{ ipt }} -t nat -F lasAlienNPos

{# Alien devices #}
{{ ipt }} -t mangle -A lasAlienMFor -j MARK --set-mark 999
{{ ipt }} -A lasAlienFFor -p udp --dport 53 -j ACCEPT
{{ ipt }} -A lasAlienFFor -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT
{{ ipt }} -t nat -A lasAlienNPos -m mark --mark 999 -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}
