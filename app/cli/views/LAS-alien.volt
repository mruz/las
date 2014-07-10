{# LAS-alien #}
{# Clear the chains #}
{{ ipt }} -t mangle -F lasAlienMFor
{{ ipt }} -t filter -F lasAlienFFor
{{ ipt }} -t nat -F lasAlienNPre

{# Alien devices #}
{{ ipt }} -t mangle -A lasAlienMFor -j MARK --set-mark 999
{{ ipt }} -A lasAlienFFor -m mark --mark 999 -p udp --dport 53 -j ACCEPT
{{ ipt }} -A lasAlienFFor -m mark --mark 999 -p tcp -m multiport ! --dport 80,53,{{ settings.port }} -j REJECT
{{ ipt }} -t nat -A lasAlienNPre -m mark --mark 999 -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}
