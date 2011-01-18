CREATE TABLE `data_unternehmen` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(255) DEFAULT NULL,
  `street` varchar(255) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8;
INSERT INTO `data_unternehmen` VALUES (1,'Firma 1','Straße 1','Ort 1'),(2,'Firma 2','Straße 2','Ort 2'),(3,'Firma 3','Straße 3','Ort 3'),(4,'Firma 4','Straße 4','Ort 4'),(5,'Firma 5','Straße 5','Ort 5'),(6,'Firma 6','Straße 6','Ort 6'),(7,'Firma 7','Straße 7','Ort 7');

INSERT INTO `permissions` VALUES (1,'read','unternehmen','name'),(2,'read','unternehmen','street'),(3,'read','unternehmen','city'),(4,'read','unternehmen','id');

INSERT INTO `users` (id,single_access_token) VALUES (1,'abcd'),(2,'abcde');

INSERT INTO `permissions_users` VALUES (2,2,NULL,NULL),(2,3,NULL,NULL),(1,1,NULL,NULL),(1,2,NULL,NULL),(1,3,NULL,NULL),(1,4,NULL,NULL),(2,4,NULL,NULL);
