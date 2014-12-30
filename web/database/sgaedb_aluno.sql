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
-- Table structure for table `aluno`
--

DROP TABLE IF EXISTS `aluno`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `aluno` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `cpf` varchar(255) NOT NULL,
  `dtInscricao` datetime DEFAULT NULL,
  `dtNascimento` date DEFAULT NULL,
  `mae` varchar(255) DEFAULT NULL,
  `nome` varchar(255) NOT NULL,
  `pai` varchar(255) DEFAULT NULL,
  `rgExp` int(11) DEFAULT NULL,
  `rgNum` varchar(255) DEFAULT NULL,
  `rgOrg` int(11) DEFAULT NULL,
  `valido` varchar(1) NOT NULL,
  `Unidade_id` int(11) NOT NULL,
  `matricula` varchar(15) NOT NULL,
  `Endereco_id` int(11) NOT NULL,
  `Contato_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_ALUNO_MATRICULA` (`matricula`),
  KEY `fk_Aluno_Unidade_idx` (`Unidade_id`),
  KEY `fk_Aluno_Orgao_Emissor_idx` (`rgOrg`),
  KEY `fk_Aluno_Estado_Org_Exp_idx` (`rgExp`),
  KEY `fk_Aluno_Endereco` (`Endereco_id`),
  KEY `fk_Aluno_Contato` (`Contato_id`),
  CONSTRAINT `fk_Aluno_Contato` FOREIGN KEY (`Contato_id`) REFERENCES `contato` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Aluno_Endereco` FOREIGN KEY (`Endereco_id`) REFERENCES `endereco` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Aluno_Estado_Org_Exp` FOREIGN KEY (`rgExp`) REFERENCES `estado` (`id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_Orgao_Emissor` FOREIGN KEY (`rgOrg`) REFERENCES `orgao_emissor` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Aluno_Unidade` FOREIGN KEY (`Unidade_id`) REFERENCES `unidade` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `aluno`
--

LOCK TABLES `aluno` WRITE;
/*!40000 ALTER TABLE `aluno` DISABLE KEYS */;
INSERT INTO `aluno` VALUES (1,'111.111.111-11','2013-12-02 00:00:00','2013-12-02','Ana Maria','Moacir Maciel Neto','José Maria',1,'0941324702',1,'S',1,'UND001MAT000001',3,3),(2,'222.222.222-22','2014-03-23 20:18:35','2014-03-27','angela','Moacir Maciel Neto 2','julio',1,'111111111111',1,'N',1,'2014C1U1S2',4,4),(3,'222.222.222-22','2014-05-02 00:18:59','2014-05-14','ertreterter t erte wter rew','dfsdfdsafsdfsadfds','efdfrg grg rgwre wer',1,'213213wewqeqw',1,'N',1,'2014C1U1S3',5,5),(4,'111.111.111-11','2014-05-24 00:00:00','2014-05-21',' we we we we we we ','Auto escola','wewewe we e we w',1,'3333333333',1,'S',1,'2014C1U1S4',6,6);
/*!40000 ALTER TABLE `aluno` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-30 18:41:13
