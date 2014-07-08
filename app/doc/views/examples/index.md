### 6. Examples {#examples}
***

#### Examples firewall usage:
##### Get clients, get client's devices, run cmd for each device
```

	{# Find active clients #}
	{% set clients = clients__find("status=" ~ clients__ACTIVE()) %}

	{# Do sth for each users with ACTIVE status #}
	{% for client in clients %}
	    {# Get user's devices and do sht in the loop #}
	    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}
	        {{ ipt }} -A FORWARD -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }} -m state --state NEW -j ACCEPT
	    {% endfor %}
	{% endfor %}

```

|                           |                  |
| :------------------------ | ---------------: |
| 5. [Admin panel](./admin) |                  |
| [Home](../doc)            | [Top](#examples) |