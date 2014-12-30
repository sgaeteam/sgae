CREATE DATABASE  IF NOT EXISTS `sgaedb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `sgaedb`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: localhost    Database: sgaedb
-- ------------------------------------------------------
-- Server version	5.1.73-community

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `contato`
--

DROP TABLE IF EXISTS `contato`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `contato` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `telCelular` varchar(15) NOT NULL,
  `telComercial` varchar(15) DEFAULT NULL,
  `telResidencial` varchar(15) DEFAULT NULL,
  `telOutro` varchar(15) DEFAULT NULL,
  `fax` varchar(15) DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  `site` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `contato`
--

LOCK TABLES `contato` WRITE;
/*!40000 ALTER TABLE `contato` DISABLE KEYS */;
INSERT INTO `contato` VALUES (1,'(71) 9999-9999','(71) 8888-8888','(71) 7777-7777','(71) 6666-6666','(71) 5555-5555','laurodefreitas@laurodefreitas.com','www.autoescolalaurodefreitas.com'),(2,'(71) 9999-9999','(71) 8888-8888','(71) 7777-7777','(71) 6666-6666','(71) 5555-5555','aluno@aluno.com.br','www.aluno.com.br'),(3,'(71) 9999-9999','(71) 8888-8888','(71) 7777-7777','(71) 6666-6666',NULL,'progressoae@progresso.com',NULL),(4,'(11) 1111-1111','(11) 1111-1111','(11) 1111-1111','(11) 1111-1111',NULL,'mmaciel@tj.ba.gov.br',NULL),(5,'(22) 2222-2222','(22) 2222-3232','(22) 2222-2222','(21) 3213-1232',NULL,'dsadsadda@gmail.com',NULL),(6,'(33) 3333-3333','(33) 3333-3333','(33) 3333-3333','(33) 3333-3333',NULL,'aaaaaaaaa@gmail.com',NULL);
/*!40000 ALTER TABLE `contato` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-30 18:41:08