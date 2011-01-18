CREATE TABLE `apiloggings` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `single_access_token` varchar(255) DEFAULT NULL,
  `tabelle` varchar(255) DEFAULT NULL,
  `ip` varchar(255) DEFAULT NULL,
  `timestamp` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
