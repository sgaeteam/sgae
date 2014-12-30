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
-- Table structure for table `orgao_emissor`
--

DROP TABLE IF EXISTS `orgao_emissor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `orgao_emissor` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(255) NOT NULL,
  `sigla` varchar(8) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `orgao_emissor`
--

LOCK TABLES `orgao_emissor` WRITE;
/*!40000 ALTER TABLE `orgao_emissor` DISABLE KEYS */;
INSERT INTO `orgao_emissor` VALUES (1,'Secretaria de Segurança Pública','SSP'),(2,'Conselho Regional de Enfermagem','COREN'),(3,'Conselho Regional de Administração','CRA'),(4,'Conselho Regional de Assistentes Sociais','CRAS'),(5,'Conselho Regional de Biblioteconomia','CRB'),(6,'Conselho Regional de Contabilidade','CRC'),(7,'Conselho Regional de Estatística','CRE'),(8,'Conselho Regional de Engenharia Arquitetura e Agronomia','CREA'),(9,'Conselho Regional de Corretores de Imóveis','CRECI'),(10,'Conselho Regional de Fisioterapia e Terapia Ocupacional','CREFIT'),(11,'Conselho Regional de Farmácia','CRF'),(12,'Conselho Regional de Medicina','CRM'),(13,'Conselho Regional de Nutrição','CRN'),(14,'Conselho Regional de Odontologia','CRO'),(15,'Conselho Regional de Psicologia','CRP'),(16,'Conselho Regional de Profissionais de Relações Públicas','CRPRE'),(17,'Conselho Regional de Química','CRQ'),(18,'Conselho Regional de Representantes Comerciais','CRRC'),(19,'Conselho Regional de Medicina Veterinária','CRMV'),(20,'Polícia Federal','DPF'),(21,'Documentos Estrangeiros','EST'),(22,'Carteira de Identidade Classista','I CLA'),(23,'Ministério da Aeronáutica','MAE'),(24,'Ministério do Exército','MEX'),(25,'Ministério da Marinha','MMA'),(26,'Ordem dos Advogados do Brasil','OAB'),(27,'Ordens dos Músicos do Brasil','OMB'),(28,'Instituto de Identificação Félix Pacheco','IFP'),(29,'Outros Emissores','OUT');
/*!40000 ALTER TABLE `orgao_emissor` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-30 18:41:06
