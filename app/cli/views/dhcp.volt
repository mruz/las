{# /etc/dhcpd.conf #}
authoritative;
boot-unknown-clients off;
ddns-update-style=ad-hoc;

shared-network LAS-{{ lan.interface }} {
    subnet {{ lan.subnetwork }} netmask {{ networks__mask(lan.mask) }} {
        default-lease-time 3600;
        max-lease-time 3600;
        range {{ str_replace('-', ' ', lan.DHCP) }};
        
        option routers {{ lan.IP|long2ip }};
        option domain-name-servers {{ wan.DNS }};
        option domain-name "las";
        
        {# Boot from LAN, PXE server #}
        filename "pxelinux.0";
        next-server {{ lan.IP|long2ip }};
        
        {# Define ACTIVE hosts #}
        {% for device in devices %}
            host {{ device.name }} { hardware ethernet {{ device.MAC }}; fixed-address {{ device.IP|long2ip }}; }
        {% endfor %}
    }
}