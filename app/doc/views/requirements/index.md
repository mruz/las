### 2. Requirements {#requirements}
- [Linux](#linux)
- [IPTABLES](#ipt)
- [Web server](#www)
- [PHP 5.4+](#php)
- [Phalcon 1.3.0+](#phalcon)
- [MySQL 5.5+](#mysql)
***

#### Linux {#linux}
Las is system to generate IPTABLES firewall for Linux based system, so we need one of the Linux distribution, [openSUSE](http://opensuse.org) is preferred.
***

#### IPTABLES {#ipt}
Iptables is administration tool for IPv4 packet filtering and NAT. We also needs `tc`, which is used to configure Traffic Control in the Linux kernel.

<br />
![iptables](/img/iptables.jpg "Iptables schema")
***

#### Web server {#www}
We needs Web server to work, [nginx](http://nginx.org) or [apache](http://apache.org) is preferred.
***

#### PHP 5.4+ {#php}
Your host needs to use PHP 5.4 or higher to run Las.
***

#### Phalcon 1.3.0+ {#phalcon}
[Phalcon](http://phalconphp.com) is a web framework implemented as a C extension offering high performance and lower resource consumption. We needs Phalcon 1.3.0 or higher to work.
***

#### MySQL 5.5+ {#mysql}
That very popular database server is available with majority of Linux distributions, [mariaDB](http://mariadb.org) 10.0.0+ is preferred.

|                     |                                   |
| :------------------ | --------------------------------: |
| 1. [About](./about) | 3. [Installation](./installation) |
| [Home](../doc)      |              [Top](#requirements) |