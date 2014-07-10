### 6. Examples {#examples}
- [Default firewalls](#default)
- [Loop over each item in a sequence](#loop)
***

#### Default firewalls {#default}
The source code for the [default firewalls](examples/default).
***

#### Loop over each item in a sequence {#loop}
 Get clients, get client's devices, run cmd for each device
```django
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

|                           |                       |
| :------------------------ | --------------------: |
| 5. [Admin panel](./admin) | 7. [Update](./update) |
| [Home](../doc)            | [Top](#examples)      |