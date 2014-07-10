-- phpMyAdmin SQL Dump
-- version 4.1.8
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Jul 10, 2014 at 05:07 PM
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
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

--
-- Dumping data for table `firewalls`
--

INSERT INTO `firewalls` (`id`, `name`, `content`, `description`, `status`, `date`) VALUES
(1, 'DHCP', '{# DHCP #}\r\n{# Create your own config or copy and paste the default /doc/examples/default#DHCP #}', '', 3, '2014-07-10 16:48:46'),
(2, 'LAS-main', '{# LAS-main #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-main #}', '', 3, '2014-07-10 16:50:32'),
(3, 'LAS-deny', '{# LAS-deny #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-deny #}', '', 3, '2014-07-10 16:51:28'),
(4, 'LAS-allow', '{# LAS-allow #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-allow #}', '', 3, '2014-07-10 16:51:55'),
(5, 'LAS-msg', '{# LAS-msg #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-msg #}', '', 3, '2014-07-10 16:52:46'),
(6, 'LAS-red', '{# LAS-red #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-red #}', '', 3, '2014-07-10 16:53:09'),
(7, 'LAS-alien', '{# LAS-alien #}\r\n{# Create your own firewall or copy and paste the default /doc/examples/default#LAS-alien #}', '', 3, '2014-07-10 16:53:32');

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
(27, 'enableQos', 3, NULL, '0', 'qos', 1),
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
(1, 'Main', '@reboot', 1, 2, 0, '', 1, '2014-07-10 16:58:46'),
(2, 'Payment', '0 6 1 * *', 3, 0, 0, '', 1, '2014-06-28 14:22:13'),
(3, 'Cut off', '0 7 1 * *', 2, 0, 0, '', 1, '2014-06-28 14:23:35'),
(4, 'Ping', '*/10 * * * *', 4, 0, 0, '', 1, '2014-06-28 14:24:32'),
(5, 'Deny', '*/5 * * * *', 1, 3, 0, '', 1, '2014-06-28 14:26:51'),
(6, 'Msg', '*/15 * * * *', 1, 5, 0, '', 1, '2014-07-10 16:59:03'),
(7, 'Config', '@reboot', 1, 1, 0, '', 1, '2014-07-10 16:59:08');

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
