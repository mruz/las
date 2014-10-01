{# LAS-allow #}
{# Clear the chains #}
{{ ipt }} -t mangle -F lasDownMFor
{{ ipt }} -t mangle -F lasUpMFor
{{ ipt }} -t filter -F lasAllowFFor

{# Active clients/devices #}
{% for client in clients.filter(las__filter('status', 'in', [clients__ACTIVE(), clients__INDEBTED()] )) %}
    {% set tariff = client.getTariff() %}
    
        {% if settings.enableQos %}
            {# Apply default services #}
            {% for service in services %}
                {{ ipt }} -t mangle -A lasQosM{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ service.IP|long2ip : ''}}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }}{{ service.string ? ' -m string --string "' ~ service.string ~ '" --algo kmp' : '' }} -j MARK --set-mark 1{{ tariff.priority ~ service.priority }}{{ EOL }}
            {% endfor %}
        {% endif %}
    
    {# Client's ACTIVE devices #}
    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
        {# Mark the traffic #}
        {% if settings.enableQos %}
            {# Apply client's services #}
            {% for service in client.getServices("status=" ~ services__ACTIVE()) %}
                {{ ipt }} -t mangle -A lasQosM{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ device.IP|long2ip : ''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }}{{ service.string ? ' -m string --string "' ~ service.string ~ '" --algo kmp' : '' }} -j MARK --set-mark 1{{ tariff.priority ~ service.priority }}{{ EOL }}
            {% endfor %}
            
            {# Apply device's services #}
            {% for service in device.getServices("status=" ~ services__ACTIVE()) %}
                {{ ipt }} -t mangle -A lasQosM{{ service.direction ? ' -' ~ services__direction(service.direction, 'rule') ~ ' ' ~ device.IP|long2ip : ''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? ' -p ' ~ services__direction(service.direction) : '' }}{{ service.portDirection ? ' --' ~ services__portDirection(service.portDirection, 'rule') ~ ' ' ~ service.startingPort ~ (service.endingPort ? ':' ~ service.endingPort : '') : '' }}{{ service.lengthMin or service.lengthMax ? ' -m length --length ' ~ (service.lengthMin ? service.lengthMin * 1000 : '') ~ ':' ~ (service.lengthMax ? service.lengthMax * 1000 : '') : '' }}{{ tariff.limit ? ' -m limit --limit ' ~ tariff.limit ~ '/s' : '' }}{{ service.string ? ' -m string --string "' ~ service.string ~ '" --algo kmp' : '' }} -j MARK --set-mark 1{{ tariff.priority ~ service.priority }}{{ EOL }}
            {% endfor %}
        {% else %}
            {{ ipt }} -t mangle -A lasDownMFor -d {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}
            {{ ipt }} -t mangle -A lasUpMFor -s {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}
        {% endif %}

        {# Default rule #}
        {{ ipt }} -A lasAllowFFor -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }} -m state --state NEW -j ACCEPT
    {% endfor %}
{% endfor %}

{# Temporary allow fot the traffic INPUT / OUTPUT #}
{{ ipt }} -A lasFIn -m state --state NEW -j ACCEPT
{{ ipt }} -A lasFOut -m state --state NEW -j ACCEPT