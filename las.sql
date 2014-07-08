-- phpMyAdmin SQL Dump
-- version 4.1.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 07, 2014 at 09:24 AM
-- Server version: 5.5.33-MariaDB
-- PHP Version: 5.4.20

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `las`
--

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE IF NOT EXISTS `clients` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `tariff_id` smallint(4) unsigned NOT NULL,
  `fullName` varchar(32) NOT NULL,
  `address` varchar(256) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

CREATE TABLE IF NOT EXISTS `devices` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL,
  `network_id` smallint(2) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `type` smallint(2) unsigned NOT NULL DEFAULT '1',
  `IP` int(10) unsigned NOT NULL,
  `MAC` varchar(17) DEFAULT NULL,
  `lastActive` int(10) DEFAULT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `firewalls`
--

CREATE TABLE IF NOT EXISTS `firewalls` (
  `id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `content` text NOT NULL,
  `description` text,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `firewalls`
--

INSERT INTO `firewalls` (`id`, `name`, `content`, `description`, `status`, `date`) VALUES
(1, 'LAS-main', '{# LAS-main #}\r\necho 1 > /proc/sys/net/ipv4/ip_forward\r\n\r\n{# Clear the filter table #}\r\n{{ ipt }} -F\r\n{{ ipt }} -X\r\n\r\n{# Clear the nat table #}\r\n{{ ipt }} -t nat -F\r\n{{ ipt }} -t nat -X\r\n\r\n{# Clear the mangle table #}\r\n{{ ipt }} -t mangle -F\r\n{{ ipt }} -t mangle -X\r\n\r\n{# Reset the counters #}\r\n{{ ipt }} -Z\r\n{{ ipt }} -t nat -Z\r\n{{ ipt }} -t mangle -Z\r\n\r\n{# Clear the queues #}\r\n{{ ipt }} -t filter -F FORWARD\r\n{{ tc }} qdisc del dev {{ lan.interface }} root >/dev/null\r\n{{ tc }} qdisc del dev {{ wan.interface }} root >/dev/null\r\n\r\n{# Set default policy #}\r\n{{ ipt }} -P INPUT DROP\r\n{{ ipt }} -P FORWARD DROP\r\n{{ ipt }} -P OUTPUT DROP\r\n\r\n{# Allow for loopback traffic #}\r\n{{ ipt }} -A INPUT -i lo -j ACCEPT\r\n{{ ipt }} -A OUTPUT -o lo -j ACCEPT\r\n\r\n{# Allow ICMP packets #}\r\n{{ ipt }} -A INPUT -p icmp --icmp-type echo-request -j ACCEPT\r\n{{ ipt }} -A OUTPUT -p icmp --icmp-type echo-request -j ACCEPT\r\n\r\n{# Nat table, chains for prerouting deny, msg, redirect #}\r\n{{ ipt }} -t nat -N LAS-NAT-DENY-PRE\r\n{{ ipt }} -t nat -N LAS-NAT-MSG-PRE\r\n{{ ipt }} -t nat -N LAS-NAT-REDIRECT-PRE\r\n\r\n{# Mangle table, chains for forward download, upload #}\r\n{{ ipt }} -t mangle -N LAS-MANGLE-DOWNLOAD\r\n{{ ipt }} -t mangle -N LAS-MANGLE-UPLOAD\r\n{{ ipt }} -t mangle -N LAS-MANGLE-ALIEN\r\n\r\n{# Filter table, chains for forward deny, msg, allow, alien #}\r\n{{ ipt }} -N LAS-FILTER-DENY\r\n{{ ipt }} -N LAS-FILTER-MSG\r\n{{ ipt }} -N LAS-FILTER-ALLOW\r\n{{ ipt }} -N LAS-FILTER-ALLOW-NEW\r\n{{ ipt }} -N LAS-FILTER-ALIEN\r\n\r\n{# Filter table, chains for input, output #}\r\n{{ ipt }} -N LAS-FILTER-INPUT\r\n{{ ipt }} -N LAS-FILTER-OUTPUT\r\n\r\n{# Nat table, chains for postrouting alien, redirect #}\r\n{{ ipt }} -t nat -N LAS-NAT-ALLOW-POST\r\n{{ ipt }} -t nat -N LAS-NAT-ALIEN-POST\r\n{{ ipt }} -t nat -N LAS-NAT-REDIRECT-POST\r\n\r\n{# Apply chains #}\r\n{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-DENY-PRE\r\n{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-MSG-PRE\r\n{{ ipt }} -t nat -A PREROUTING -j LAS-NAT-REDIRECT-PRE\r\n{{ ipt }} -t mangle -A FORWARD -i {{ wan.interface }} -o {{ lan.interface }} -j LAS-MANGLE-DOWNLOAD\r\n{{ ipt }} -t mangle -A FORWARD -i {{ lan.interface }} -o {{ wan.interface }} -j LAS-MANGLE-UPLOAD\r\n{{ ipt }} -t mangle -A FORWARD -j LAS-MANGLE-ALIEN\r\n{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-ALLOW-POST\r\n{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-ALIEN-POST\r\n{{ ipt }} -t nat -A POSTROUTING -j LAS-NAT-REDIRECT-POST\r\n\r\n{# Download tariffs #}\r\n{{ tc }} qdisc add dev {{ lan.interface }} root handle 1:0 htb\r\n{{ tc }} class add dev {{ lan.interface }} parent 1: classid 1:1 htb rate 990mbit ceil 990mbit\r\n{{ tc }} class add dev {{ lan.interface }} parent 1:1 classid 1:2 htb rate {{ wan.download }}{{ settings.bitRate }}\r\n\r\n{# Upload tariffs #}\r\n{{ tc }} qdisc add dev {{ wan.interface }} root handle 1: htb\r\n{{ tc }} class add dev {{ wan.interface }} parent 1: classid 1:1 htb rate 990mbit ceil 990mbit\r\n{{ tc }} class add dev {{ wan.interface }} parent 1:1 classid 1:2 htb rate {{ wan.upload }}{{ settings.bitRate }}\r\n\r\n{% for tariff in tariffs %}\r\n    {# Download #}\r\n    {{ tc }} class add dev {{ lan.interface }} parent 1:2 classid 1:1{{ tariff.priority }} htb rate {{ tariff.downloadRate ~ settings.bitRate }} ceil {{ tariff.downloadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ EOL }}\r\n    {{ tc }} filter add dev {{ lan.interface }} parent 1:0 prio {{ tariff.priority }} protocol ip handle 1{{ tariff.priority }} fw flowid 1:1{{ tariff.priority }}{{ EOL }}\r\n    {{ tc }} qdisc add dev {{ lan.interface }} parent 1:1{{ tariff.priority }} handle 1{{ tariff.priority }}: sfq perturb 10\r\n    \r\n    {# Subclasses for tariff #}\r\n    {% if settings.enableQos %}\r\n        {% for priority, qos in services__priority(null) %}\r\n            {{ tc }} class add dev {{ lan.interface }} parent 1:1{{ tariff.priority }} classid 1:1{{ tariff.priority }}{{ priority }} htb rate {{ qos[''rate'']/100*tariff.downloadRate ~ settings.bitRate }} ceil {{ qos[''ceil'']/100*tariff.downloadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ priority }}{{ EOL }}\r\n            {{ tc }} filter add dev {{ lan.interface }} parent 1:0 prio {{ tariff.priority }}{{ priority }} protocol ip handle 1{{ tariff.priority }}{{ priority }} fw flowid 1:1{{ tariff.priority }}{{ priority }}{{ EOL }}\r\n            {{ tc }} qdisc add dev {{ lan.interface }} parent 1:1{{ tariff.priority }}{{ priority }} handle 1{{ tariff.priority }}{{ priority }}: sfq perturb 10\r\n        {% endfor %}\r\n    {% endif %}\r\n\r\n    {# Upload #}\r\n    {{ tc }} class add dev {{ wan.interface }} parent 1:2 classid 1:1{{ tariff.priority }} htb rate {{ tariff.uploadRate ~ settings.bitRate }} ceil {{ tariff.uploadCeil ~ settings.bitRate }} prio {{ tariff.priority }}{{ EOL }}\r\n    {{ tc }} filter add dev {{ wan.interface }} parent 1:0 prio {{ tariff.priority }} protocol ip handle 1{{ tariff.priority }} fw flowid 1:1{{ tariff.priority }}{{ EOL }}\r\n    {{ tc }} qdisc add dev {{ wan.interface }} parent 1:1{{ tariff.priority }} handle 1{{ tariff.priority }}: sfq perturb 10\r\n{% endfor %}\r\n\r\n{# Redirects #}\r\n{% for redirect in redirects %}\r\n    {% set device = redirect.getDevice() %}\r\n    {{ ipt }} -t nat -A LAS-NAT-REDIRECT-PRE -d {{ wan.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? ''tcp'' : ''udp'' }} --dport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? '':'' ~ redirect.externalEndingPort : '''' }} -j DNAT --to {{ device.IP|long2ip }} --sport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? '':'' ~ redirect.internalEndingPort : '''' }}{{ EOL }}\r\n    {{ ipt }} -t nat -A LAS-NAT-REDIRECT-POST -d {{ device.IP|long2ip }} -p {{ redirect.type == redirects__TCP() ? ''tcp'' : ''udp'' }} --dport {{ redirect.internalStartingPort }}{{ redirect.internalEndingPort ? '':'' ~ redirect.internalEndingPort : '''' }} -j SNAT --to {{ wan.IP|long2ip }} --sport {{ redirect.externalStartingPort }}{{ redirect.externalEndingPort ? '':'' ~ redirect.externalEndingPort : '''' }}{{ EOL }}\r\n{% endfor %}\r\n\r\n{# Input #}\r\n{{ ipt }} -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT\r\n{{ ipt }} -A INPUT -j LAS-FILTER-INPUT\r\n{{ ipt }} -A INPUT -m state --state INVALID -j DROP\r\n{{ ipt }} -A INPUT -j LOG --log-prefix "DROP_INPUT " --log-tcp-options --log-ip-options --log-tcp-sequence\r\n\r\n{# Output #}\r\n{{ ipt }} -A OUTPUT -m state --state ESTABLISHED,RELATED -j ACCEPT\r\n{{ ipt }} -A OUTPUT -j LAS-FILTER-OUTPUT\r\n{{ ipt }} -A OUTPUT -m state --state INVALID -j DROP\r\n{{ ipt }} -A OUTPUT -j LOG --log-prefix "DROP_OUTPUT " --log-tcp-options --log-ip-options --log-tcp-sequence\r\n\r\n{# Forward #}\r\n{{ ipt }} -A FORWARD -j LAS-FILTER-DENY\r\n{{ ipt }} -A FORWARD -j LAS-FILTER-MSG\r\n{{ ipt }} -A FORWARD -j LAS-FILTER-ALLOW\r\n{{ ipt }} -A FORWARD -j LAS-FILTER-ALLOW-NEW\r\n{{ ipt }} -A FORWARD -j LAS-FILTER-ALIEN\r\n{{ ipt }} -A FORWARD -m state --state INVALID -j DROP\r\n{{ ipt }} -A FORWARD -j LOG --log-prefix "DROP_FORWARD " --log-tcp-options --log-ip-options --log-tcp-sequence\r\n\r\n{# Allow to Internet #}\r\n{{ ipt }} -t nat -A LAS-NAT-ALLOW-POST -m mark --mark ! 999 -s {{ lan.subnetwork|long2ip }}{{ lan.mask }} -o {{ wan.interface }} -j SNAT --to {{ wan.IP|long2ip }}\r\n\r\n{# Alien #}\r\n{{ ipt }} -t mangle -A LAS-MANGLE-ALIEN -j MARK --set-mark 999\r\n{{ ipt }} -A LAS-FILTER-ALIEN -p udp --dport 53 -j ACCEPT\r\n{{ ipt }} -A LAS-FILTER-ALIEN -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT\r\n{{ ipt }} -t nat -A LAS-NAT-ALIEN-POST -m mark --mark 999 -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}\r\n\r\n{# Active clients #}\r\n{% for client in clients.filter(las__filter(''status'', ''=='', clients__ACTIVE())) %}\r\n    {% set tariff = client.getTariff() %}\r\n\r\n    {# Client''s ACTIVE devices #}\r\n    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}\r\n        {{ ipt }} -t mangle -A LAS-MANGLE-DOWNLOAD -d {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}\r\n        {{ ipt }} -t mangle -A LAS-MANGLE-UPLOAD -s {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}\r\n\r\n        {# Allow for established and related packets #}\r\n        {{ ipt }} -A LAS-FILTER-ALLOW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state ESTABLISHED,RELATED -j ACCEPT\r\n\r\n        {# Apply default services #}\r\n        {% for service in services %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ service.IP|long2ip : ''''}}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Apply client''s services #}\r\n        {% for service in client.getServices("status=" ~ services__ACTIVE()) %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ device.IP|long2ip : ''''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Apply device''s services #}\r\n        {% for service in device.getServices("status=" ~ services__ACTIVE()) %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ device.IP|long2ip : ''''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Default rule #}\r\n        {{ ipt }} -A LAS-FILTER-ALLOW-NEW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }}{{ service.string ? '' -m string --string "'' ~ service.string ~ ''" --algo kmp'' : '''' }} -m state --state NEW -j ACCEPT\r\n    {% endfor %}\r\n{% endfor %}\r\n\r\n{# Run LAS-allow partial firewall #}\r\n{{ partial(''LAS-allow'') }}\r\n\r\n{# Run LAS-msg partial firewall #}\r\n{{ partial(''LAS-msg'') }}\r\n\r\n{# Run LAS-deny partial firewall #}\r\n{{ partial(''LAS-deny'') }}', '', 4, '2014-07-03 12:49:08'),
(3, 'LAS-deny', '{# LAS-deny #}\r\n{# Denied clients/devices #}\r\n{{ ipt }} -t nat -F LAS-NAT-DENY-PRE\r\n{{ ipt }} -t filter -F LAS-FILTER-DENY\r\n{% for client in clients.filter(las__filter(''status'', ''=='', clients__DISCONNECTED())) %}\r\n    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}\r\n        {{ ipt }} -t filter -A LAS-FILTER-DENY -m mac --mac-source {{ device.MAC }} -p udp --dport 53 -j ACCEPT\r\n        {{ ipt }} -t filter -A LAS-FILTER-DENY -m mac --mac-source {{ device.MAC }} -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT\r\n        {{ ipt }} -t nat -A LAS-NAT-DENY-PRE -m mac --mac-source {{ device.MAC }} -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}\r\n    {% endfor %}\r\n{% endfor %}', '', 4, '2014-06-29 14:06:11'),
(4, 'LAS-msg', '{# LAS-message #}\r\n{# Messages/reminders #}\r\n{{ ipt }} -t nat -F LAS-NAT-MSG-PRE\r\n{{ ipt }} -t filter -F LAS-FILTER-MSG\r\n{% for client in clients.filter(las__filter(''status'', ''=='', clients__INDEBTED())) %}\r\n    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}\r\n        {{ ipt }} -t filter -A LAS-FILTER-MSG -m mac --mac-source {{ device.MAC }} -p udp --dport 53 -j ACCEPT\r\n        {{ ipt }} -t filter -A LAS-FILTER-MSG -m mac --mac-source {{ device.MAC }} -p tcp -m multiport --dport ! 80,53,{{ settings.port }} -j REJECT\r\n        {{ ipt }} -t nat -A LAS-NAT-MSG-PRE -m mac --mac-source {{ device.MAC }} -p tcp --dport 80 -j DNAT --to {{ lan.IP|long2ip }}:{{ settings.port }}{{ EOL }}\r\n    {% endfor %}\r\n{% endfor %}', '', 4, '2014-06-29 14:08:21'),
(5, 'DHCP', 'echo "\r\n{# /etc/dhcpd.conf #}\r\nauthoritative;\r\nboot-unknown-clients off;\r\nddns-update-style=ad-hoc;\r\n\r\nshared-network LAS-{{ lan.interface }} {\r\n    subnet {{ lan.subnetwork }} netmask {{ networks__mask(lan.mask) }} {\r\n        default-lease-time 3600;\r\n        max-lease-time 3600;\r\n        range {{ str_replace(''-'', '' '', lan.DHCP) }};\r\n        \r\n        option routers {{ lan.IP|long2ip }};\r\n        option domain-name-servers {{ wan.DNS }};\r\n        option domain-name "las";\r\n        \r\n        {# Boot from LAN, PXE server #}\r\n        filename \\"pxelinux.0\\";\r\n        next-server {{ lan.IP|long2ip }};\r\n        \r\n        {# Define ACTIVE hosts #}\r\n        {% for device in devices %}\r\n            host {{ device.name }} { hardware ethernet {{ device.MAC }}; fixed-address {{ device.IP|long2ip }}; }\r\n        {% endfor %}\r\n    }\r\n}"> /var/tmp/dhcpd.conf', '', 4, '2014-06-29 15:20:23'),
(6, 'LAS-allow', '{# LAS-allow #}\r\n{{ ipt }} -t nat -F LAS-NAT-DENY-PRE\r\n{{ ipt }} -t filter -F LAS-FILTER-DENY\r\n\r\n{# Active clients/devices #}\r\n{% for client in clients.filter(las__filter(''status'', ''=='', clients__ACTIVE())) %}\r\n    {% set tariff = client.getTariff() %}\r\n\r\n    {# Client''s ACTIVE devices #}\r\n    {% for device in client.getDevices("status=" ~ devices__ACTIVE()) %}\r\n        {{ ipt }} -t mangle -A LAS-MANGLE-DOWNLOAD -d {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}\r\n        {{ ipt }} -t mangle -A LAS-MANGLE-UPLOAD -s {{ device.IP|long2ip }} -j MARK --set-mark 1{{ tariff.priority }}{{ EOL }}\r\n\r\n        {# Allow for established and related packets #}\r\n        {{ ipt }} -A LAS-FILTER-ALLOW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state ESTABLISHED,RELATED -j ACCEPT\r\n\r\n        {# Apply default services #}\r\n        {% for service in services %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ service.IP|long2ip : ''''}}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Apply client''s services #}\r\n        {% for service in client.getServices("status=" ~ services__ACTIVE()) %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ device.IP|long2ip : ''''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Apply device''s services #}\r\n        {% for service in device.getServices("status=" ~ services__ACTIVE()) %}\r\n            {{ ipt }} -A LAS-FILTER-ALLOW-NEW{{ service.direction ? '' -'' ~ services__direction(service.direction, ''rule'') ~ '' '' ~ device.IP|long2ip : ''''}} -m mac --mac-source {{ device.MAC }}{{ service.direction ? '' -p '' ~ services__direction(service.direction) : '''' }}{{ service.portDirection ? '' --'' ~ services__portDirection(service.portDirection, ''rule'') ~ '' '' ~ service.startingPort ~ (service.endingPort ? '':'' ~ service.endingPort : '''') : '''' }}{{ service.lengthMin or service.lengthMax ? '' -m length --length '' ~ (service.lengthMin ? service.lengthMin * 1000 : '''') ~ '':'' ~ (service.lengthMax ? service.lengthMax * 1000 : '''') : '''' }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }} -m state --state NEW -j ACCEPT\r\n        {% endfor %}\r\n\r\n        {# Default rule #}\r\n        {{ ipt }} -A LAS-FILTER-ALLOW-NEW -s {{ device.IP|long2ip }} -m mac --mac-source {{ device.MAC }}{{ tariff.limit ? '' -m limit --limit '' ~ tariff.limit ~ ''/s'' : '''' }}{{ service.string ? '' -m string --string "'' ~ service.string ~ ''" --algo kmp'' : '''' }} -m state --state NEW -j ACCEPT\r\n    {% endfor %}\r\n{% endfor %}', '', 1, '2014-07-03 12:53:45');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE IF NOT EXISTS `messages` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(10) DEFAULT '0',
  `title` varchar(64) DEFAULT NULL,
  `content` text NOT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `networks`
--

CREATE TABLE IF NOT EXISTS `networks` (
  `id` smallint(2) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `interface` varchar(8) NOT NULL,
  `subnetwork` int(10) unsigned NOT NULL,
  `type` smallint(1) NOT NULL DEFAULT '1',
  `IP` int(10) unsigned NOT NULL,
  `mask` varchar(3) NOT NULL,
  `gateway` int(10) unsigned NOT NULL,
  `DNS` varchar(100) DEFAULT NULL,
  `DHCP` varchar(100) DEFAULT NULL,
  `download` int(10) NOT NULL DEFAULT '0',
  `upload` int(10) NOT NULL DEFAULT '0',
  `description` varchar(1024) DEFAULT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE IF NOT EXISTS `payments` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(11) unsigned NOT NULL,
  `amount` float NOT NULL,
  `description` text,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `redirects`
--

CREATE TABLE IF NOT EXISTS `redirects` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `device_id` int(10) unsigned NOT NULL,
  `name` varchar(32) NOT NULL,
  `type` smallint(1) NOT NULL DEFAULT '1',
  `externalStartingPort` smallint(5) unsigned DEFAULT NULL,
  `externalEndingPort` smallint(5) unsigned DEFAULT NULL,
  `internalStartingPort` smallint(5) unsigned DEFAULT NULL,
  `internalEndingPort` smallint(5) unsigned DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE IF NOT EXISTS `roles` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_name` (`name`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=3 ;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`) VALUES
(1, 'login', 'Login privileges, granted after account confirmation'),
(2, 'admin', 'Administrative user, has access to everything.');

-- --------------------------------------------------------

--
-- Table structure for table `roles_users`
--

CREATE TABLE IF NOT EXISTS `roles_users` (
  `user_id` int(10) unsigned NOT NULL,
  `role_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`user_id`,`role_id`),
  KEY `fk_role_id` (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE IF NOT EXISTS `services` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `client_id` int(10) unsigned NOT NULL DEFAULT '0',
  `device_id` int(10) unsigned NOT NULL DEFAULT '0',
  `IP` int(10) unsigned DEFAULT NULL,
  `string` varchar(128) DEFAULT NULL,
  `name` varchar(32) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `chain` smallint(1) unsigned NOT NULL,
  `protocol` smallint(1) DEFAULT NULL,
  `direction` smallint(1) unsigned DEFAULT NULL,
  `portDirection` smallint(1) unsigned DEFAULT NULL,
  `startingPort` varchar(16) DEFAULT NULL,
  `endingPort` smallint(5) unsigned DEFAULT NULL,
  `lengthMin` int(10) unsigned DEFAULT NULL,
  `lengthMax` int(10) unsigned DEFAULT NULL,
  `priority` smallint(1) unsigned NOT NULL DEFAULT '3',
  `sorting` smallint(5) unsigned NOT NULL DEFAULT '100',
  `status` smallint(1) unsigned NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE IF NOT EXISTS `settings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(64) NOT NULL,
  `type` smallint(1) NOT NULL,
  `options` text,
  `value` text,
  `category` varchar(32) NOT NULL,
  `status` smallint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=31 ;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `name`, `type`, `options`, `value`, `category`, `status`) VALUES
(1, 'bitRate', 5, '{"kbit":"kb/s","mbit":"Mb/s"}', 'mbit', 'general', 1),
(2, 'currency', 5, '{"EUR":"EUR","GBP":"GBP","PLN":"PLN","USD":"USD"}', 'PLN', 'payments', 1),
(3, 'port', 1, NULL, '81', 'general', 1),
(4, 'iptables', 1, NULL, '/usr/sbin/iptables', 'general', 1),
(5, 'tc', 1, NULL, '/usr/sbin/tc', 'general', 1),
(6, 'highestRate', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '70', 'qos', 1),
(7, 'highestCeil', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '100', 'qos', 1),
(8, 'highRate', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '10', 'qos', 1),
(9, 'highCeil', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '100', 'qos', 1),
(10, 'mediumRate', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '10', 'qos', 1),
(11, 'mediumCeil', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '95', 'qos', 1),
(12, 'lowRate', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '5', 'qos', 1),
(13, 'lowCeil', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '95', 'qos', 1),
(14, 'lowestRate', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '5', 'qos', 1),
(15, 'lowestCeil', 5, '{"1":1,"2":2,"3":3,"4":4,"5":5,"6":6,"7":7,"8":8,"9":9,"10":10,"11":11,"12":12,"13":13,"14":14,"15":15,"16":16,"17":17,"18":18,"19":19,"20":20,"21":21,"22":22,"23":23,"24":24,"25":25,"26":26,"27":27,"28":28,"29":29,"30":30,"31":31,"32":32,"33":33,"34":34,"35":35,"36":36,"37":37,"38":38,"39":39,"40":40,"41":41,"42":42,"43":43,"44":44,"45":45,"46":46,"47":47,"48":48,"49":49,"50":50,"51":51,"52":52,"53":53,"54":54,"55":55,"56":56,"57":57,"58":58,"59":59,"60":60,"61":61,"62":62,"63":63,"64":64,"65":65,"66":66,"67":67,"68":68,"69":69,"70":70,"71":71,"72":72,"73":73,"74":74,"75":75,"76":76,"77":77,"78":78,"79":79,"80":80,"81":81,"82":82,"83":83,"84":84,"85":85,"86":86,"87":87,"88":88,"89":89,"90":90,"91":91,"92":92,"93":93,"94":94,"95":95,"96":96,"97":97,"98":98,"99":99,"100":100}', '90', 'qos', 1),
(26, 'defaultClass', 1, NULL, '5', 'qos', 1),
(27, 'enableQos', 3, NULL, '1', 'qos', 1),
(28, 'realTime', 3, NULL, '0', 'general', 1),
(29, 'debugCmd', 3, NULL, '0', 'general', 1),
(30, 'rootPassword', 2, NULL, 'OBXmZ4oTaO+/ohtZyDDgi072UOh+buq0pZgc9wnWdtA8rxBENYzLe6KcuWgQ+xsv2FuKuQuo6aUlrqnx+M0DyQ==', 'general', 1);

-- --------------------------------------------------------

--
-- Table structure for table `tariffs`
--

CREATE TABLE IF NOT EXISTS `tariffs` (
  `id` smallint(4) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `amount` float NOT NULL DEFAULT '0',
  `priority` smallint(2) unsigned NOT NULL DEFAULT '50',
  `uploadRate` float unsigned NOT NULL DEFAULT '0',
  `uploadCeil` float unsigned NOT NULL DEFAULT '0',
  `downloadRate` float unsigned NOT NULL DEFAULT '0',
  `downloadCeil` float unsigned NOT NULL DEFAULT '0',
  `limit` int(10) unsigned NOT NULL DEFAULT '0',
  `status` smallint(1) NOT NULL DEFAULT '0',
  `date` datetime(6) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `tasks`
--

CREATE TABLE IF NOT EXISTS `tasks` (
  `id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL,
  `when` varchar(64) NOT NULL,
  `type` smallint(1) NOT NULL DEFAULT '1',
  `firewall_id` smallint(4) NOT NULL DEFAULT '0',
  `next` int(10) DEFAULT NULL,
  `description` varchar(1024) DEFAULT NULL,
  `status` smallint(1) unsigned NOT NULL DEFAULT '0',
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `tasks`
--

INSERT INTO `tasks` (`id`, `name`, `when`, `type`, `firewall_id`, `next`, `description`, `status`, `date`) VALUES
(1, 'Main', '@reboot', 1, 1, 0, '', 1, '2014-06-28 14:37:48'),
(2, 'Payment', '0 6 1 * *', 3, 0, 0, '', 1, '2014-06-28 14:22:13'),
(3, 'Cut off', '0 7 1 * *', 2, 0, 0, '', 1, '2014-06-28 14:23:35'),
(4, 'Ping', '*/10 * * * *', 4, 0, 0, '', 1, '2014-06-28 14:24:32'),
(5, 'Deny', '*/5 * * * *', 1, 3, 0, '', 1, '2014-06-28 14:26:51'),
(6, 'Msg', '*/15 * * * *', 1, 4, 0, '', 1, '2014-06-28 14:28:07'),
(7, 'Config', '@reboot', 1, 5, 0, '', 1, '2014-06-29 09:55:01');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `email` varchar(254) NOT NULL,
  `username` varchar(32) NOT NULL DEFAULT '',
  `password` varchar(64) NOT NULL,
  `logins` int(10) unsigned NOT NULL DEFAULT '0',
  `last_login` int(10) unsigned DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_username` (`username`),
  UNIQUE KEY `uniq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Table structure for table `user_tokens`
--

CREATE TABLE IF NOT EXISTS `user_tokens` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `user_id` int(11) unsigned NOT NULL,
  `user_agent` varchar(40) NOT NULL,
  `token` varchar(40) NOT NULL,
  `created` int(10) unsigned NOT NULL,
  `expires` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `uniq_token` (`token`),
  KEY `fk_user_id` (`user_id`),
  KEY `expires` (`expires`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `roles_users`
--
ALTER TABLE `roles_users`
  ADD CONSTRAINT `roles_users_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `roles_users_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_tokens`
--
ALTER TABLE `user_tokens`
  ADD CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
