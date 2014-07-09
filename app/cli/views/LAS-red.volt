{# LAS-red #}
{# Clear the chains #}
{{ ipt }} -t nat -F lasRedNPre
{{ ipt }} -t nat -F lasRedNPos

{# Add new port redirections #}
{% for redirect in redirects %}
    {% set device = redirect.getDevice() %}
    {{ ipt }} -t nat -A lasRedNPre -d {{ wan.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? 'tcp' : 'udp' }} --dport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? ':' ~ redirect.externalEndingPort : '' }} -j DNAT --to {{ device.IP|long2ip }} --sport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? ':' ~ redirect.internalEndingPort : '' }}{{ EOL }}
    {{ ipt }} -t nat -A lasRedNPos -d {{ device.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? 'tcp' : 'udp' }} --dport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? ':' ~ redirect.internalEndingPort : '' }} -j SNAT --to {{ wan.IP|long2ip }} --sport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? ':' ~ redirect.externalEndingPort : '' }}{{ EOL }}
{% endfor %}