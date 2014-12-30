CREATE DATABASE  IF NOT EXISTS `sgaedb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `sgaedb`;
-- MySQL dump 10.13  Distrib 5.6.13, for Win32 (x86)
--
-- Host: 127.0.0.1    Database: sgaedb
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

--
-- Table structure for table `cliente`
--

DROP TABLE IF EXISTS `cliente`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `cliente` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `razaoSocial` varchar(100) NOT NULL,
  `nomeFantasia` varchar(45) NOT NULL,
  `cnpj` varchar(14) NOT NULL,
  `diaVencimento` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `cliente`
--

LOCK TABLES `cliente` WRITE;
/*!40000 ALTER TABLE `cliente` DISABLE KEYS */;
INSERT INTO `cliente` VALUES (1,'Lauro Ensinamentos LTDA','CFC Lauro de Freitas','33014556000196',2);
/*!40000 ALTER TABLE `cliente` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `endereco`
--

DROP TABLE IF EXISTS `endereco`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `endereco` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `logradouro` varchar(50) NOT NULL,
  `numero` varchar(10) NOT NULL,
  `bairro` varchar(30) NOT NULL,
  `cidade` varchar(45) NOT NULL,
  `estado` int(11) NOT NULL,
  `cep` varchar(10) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Endereco_Estado_idx` (`estado`),
  CONSTRAINT `fk_Endereco_Estado` FOREIGN KEY (`estado`) REFERENCES `estado` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `endereco`
--

LOCK TABLES `endereco` WRITE;
/*!40000 ALTER TABLE `endereco` DISABLE KEYS */;
INSERT INTO `endereco` VALUES (1,'R. Maria Bonifácio Santos','3257','Estrada do Coco','Lauro de Freitas',5,'42.700-000'),(2,'Av. Antônio Carlos Magalhães','480','Itaigara','Salvador',5,'41.825-000'),(3,'Av. Manoel Dias da Silva','1892','Pituba','Salvador',5,'41.825-000'),(4,'rua 1','10','centro','salvador',1,'22.222-222'),(5,'fdsfeewf','dsfewre','dfasdffsdfadsf','dsfsdfsdf',1,'32.233-232'),(6,'we we we we we ','12','wewewew','wqeqweqweqwe',1,'33.333-333');
/*!40000 ALTER TABLE `endereco` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `estado`
--

DROP TABLE IF EXISTS `estado`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `estado` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) NOT NULL,
  `sigla` varchar(2) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `descricao_UNIQUE` (`descricao`),
  UNIQUE KEY `sigla_UNIQUE` (`sigla`)
) ENGINE=InnoDB AUTO_INCREMENT=27 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `estado`
--

LOCK TABLES `estado` WRITE;
/*!40000 ALTER TABLE `estado` DISABLE KEYS */;
INSERT INTO `estado` VALUES (1,'Acre','AC'),(2,'Alagoas','AL'),(3,'Amapá','AP'),(4,'Amazonas','AM'),(5,'Bahia','BA'),(6,'Ceará','CE'),(7,'Distrito Federal','DF'),(8,'Espírito Santo','ES'),(9,'Goiás','GO'),(10,'Maranhão','MA'),(11,'Mato Grosso','MT'),(12,'Mato Grosso do Sul','MS'),(13,'Minas Gerais','MG'),(14,'Pará','PA'),(15,'Paraná','PR'),(16,'Pernambuco','PE'),(17,'Piauí','PI'),(18,'Rio de Janeiro','RJ'),(19,'Rio Grande do Norte','RN'),(20,'Santa Catarina','SC'),(21,'Rorâima','RR'),(22,'Rondônia','RO'),(23,'Rio Grande do Sul','RS'),(24,'São Paulo','SP'),(25,'Sergipe','SE'),(26,'Tocantins','TO');
/*!40000 ALTER TABLE `estado` ENABLE KEYS */;
UNLOCK TABLES;

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

--
-- Table structure for table `pagamento`
--

DROP TABLE IF EXISTS `pagamento`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pagamento` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `dtPagamento` datetime NOT NULL,
  `Cliente_id` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Pagamento_Cliente_idx` (`Cliente_id`),
  CONSTRAINT `fk_Pagamento_Cliente` FOREIGN KEY (`Cliente_id`) REFERENCES `cliente` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pagamento`
--

LOCK TABLES `pagamento` WRITE;
/*!40000 ALTER TABLE `pagamento` DISABLE KEYS */;
/*!40000 ALTER TABLE `pagamento` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `perfil`
--

DROP TABLE IF EXISTS `perfil`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `perfil` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `sigla` varchar(3) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `UQ_PERFIL_SIGLA` (`sigla`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `perfil`
--

LOCK TABLES `perfil` WRITE;
/*!40000 ALTER TABLE `perfil` DISABLE KEYS */;
INSERT INTO `perfil` VALUES (1,'Administrador','Coordenadores e Analistas','ADM'),(2,'Diretor','Diretores e/ou Gerentes','DIR'),(3,'Supervisor','Supervisores e Apoio','SUP'),(4,'Operador','Operadores','OPR'),(5,'Usuário','Usuários públicos ou Recepção para informações','USR');
/*!40000 ALTER TABLE `perfil` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `plano`
--

DROP TABLE IF EXISTS `plano`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `plano` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(45) NOT NULL,
  `descricao` varchar(255) NOT NULL,
  `valor` double NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `plano`
--

LOCK TABLES `plano` WRITE;
/*!40000 ALTER TABLE `plano` DISABLE KEYS */;
INSERT INTO `plano` VALUES (1,'Basic','Pacote: Caixa',119.9),(2,'Plus','Pacote: Caixa/Expedição/Simulado',139.9),(3,'Premium','Pacote: Caixa/Expedição/Simulado/Contas a Pagar/Contas a Receber',159.9),(4,'Gold','Pacote: Caixa/Expedição/Simulado/Contas a Pagar/Contas a Receber/Patrimônio/Cont?bil',189.9);
/*!40000 ALTER TABLE `plano` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tipounidade`
--

DROP TABLE IF EXISTS `tipounidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tipounidade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(10) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tipounidade`
--

LOCK TABLES `tipounidade` WRITE;
/*!40000 ALTER TABLE `tipounidade` DISABLE KEYS */;
INSERT INTO `tipounidade` VALUES (1,'Matriz'),(2,'Filial');
/*!40000 ALTER TABLE `tipounidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `unidade`
--

DROP TABLE IF EXISTS `unidade`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `unidade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Contato_id` int(11) NOT NULL,
  `Endereco_id` int(11) NOT NULL,
  `TipoUnidade_id` int(11) NOT NULL,
  `Plano_id` int(11) NOT NULL,
  `Cliente_id` int(11) NOT NULL,
  `nome` varchar(45) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_Unidade_Contato_idx` (`Contato_id`),
  KEY `fk_Unidade_Endereco_idx` (`Endereco_id`),
  KEY `fk_Unidade_TipoUnidade_idx` (`TipoUnidade_id`),
  KEY `fk_Unidade_Plano_idx` (`Plano_id`),
  KEY `fk_Unidade_Cliente_idx` (`Cliente_id`),
  CONSTRAINT `fk_Unidade_Cliente` FOREIGN KEY (`Cliente_id`) REFERENCES `cliente` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Unidade_Contato` FOREIGN KEY (`Contato_id`) REFERENCES `contato` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Unidade_Endereco` FOREIGN KEY (`Endereco_id`) REFERENCES `endereco` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Unidade_Plano` FOREIGN KEY (`Plano_id`) REFERENCES `plano` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Unidade_TipoUnidade` FOREIGN KEY (`TipoUnidade_id`) REFERENCES `tipounidade` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `unidade`
--

LOCK TABLES `unidade` WRITE;
/*!40000 ALTER TABLE `unidade` DISABLE KEYS */;
INSERT INTO `unidade` VALUES (1,1,1,1,1,1,'Matriz'),(2,2,2,2,3,1,'Filial 1');
/*!40000 ALTER TABLE `unidade` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `usuario`
--

DROP TABLE IF EXISTS `usuario`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `usuario` (
  `cpf` varchar(11) NOT NULL,
  `nome` varchar(255) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `senha` varchar(50) NOT NULL,
  `ativo` varchar(1) NOT NULL DEFAULT 'S',
  `Cliente_id` int(11) NOT NULL,
  `Perfil_id` int(11) NOT NULL,
  PRIMARY KEY (`cpf`),
  KEY `fk_Usuario_Cliente_idx` (`Cliente_id`),
  KEY `fk_Usuario_Perfil_idx` (`Perfil_id`),
  CONSTRAINT `fk_Usuario_Cliente` FOREIGN KEY (`Cliente_id`) REFERENCES `cliente` (`id`) ON DELETE NO ACTION,
  CONSTRAINT `fk_Usuario_Perfil` FOREIGN KEY (`Perfil_id`) REFERENCES `perfil` (`id`) ON DELETE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `usuario`
--

LOCK TABLES `usuario` WRITE;
/*!40000 ALTER TABLE `usuario` DISABLE KEYS */;
INSERT INTO `usuario` VALUES ('11111111111','Moacir Maciel Neto','moacirmn@gmail.com','7322f0064311a4f55af85b5b76e697bd','S',1,1),('22222222222','Marcelo Zacarias','mzsilva@gmail.com','1814191a493707a95013dd1cecd97bf7','S',1,1),('33333333333','Vitor Smith','vsmith@gmail.com','630138a05841ea8c38882a33b7f42ea5','S',1,1);
/*!40000 ALTER TABLE `usuario` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'sgaedb'
--

--
-- Dumping routines for database 'sgaedb'
--
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-12-30 19:14:30
