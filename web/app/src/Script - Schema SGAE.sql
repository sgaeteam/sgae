DROP TABLE IF EXISTS `sgaedb`.`Usuario`;
DROP TABLE IF EXISTS `sgaedb`.`Perfil`;
DROP TABLE IF EXISTS `sgaedb`.`Pagamento`;
DROP TABLE IF EXISTS `sgaedb`.`Aluno`;
DROP TABLE IF EXISTS `sgaedb`.`Unidade`;
DROP TABLE IF EXISTS `sgaedb`.`Cliente`;
DROP TABLE IF EXISTS `sgaedb`.`Contato`;
DROP TABLE IF EXISTS `sgaedb`.`Endereco`;
DROP TABLE IF EXISTS `sgaedb`.`Plano`;
DROP TABLE IF EXISTS `sgaedb`.`TipoUnidade`;
DROP TABLE IF EXISTS `sgaedb`.`Estado`;
DROP TABLE IF EXISTS `sgaedb`.`Orgao_Emissor`;

DROP SCHEMA IF EXISTS `sgaedb`;

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

CREATE SCHEMA IF NOT EXISTS `sgaedb` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin ;
USE `sgaedb` ;

-- -----------------------------------------------------
-- Table `sgaedb`.`Contato`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Contato` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `telCelular` VARCHAR(15) NOT NULL ,
  `telComercial` VARCHAR(15) NULL ,
  `telResidencial` VARCHAR(15) NULL ,
  `telOutro` VARCHAR(15) NULL ,
  `fax` VARCHAR(15) NULL ,
  `email` VARCHAR(50) NULL ,
  `site` VARCHAR(50) NULL ,
  PRIMARY KEY (`id`) )
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Estado`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Estado` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `descricao` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_general_ci' NOT NULL ,
  `sigla` VARCHAR(2) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `descricao_UNIQUE` (`descricao` ASC) ,
  UNIQUE INDEX `sigla_UNIQUE` (`sigla` ASC) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Endereco`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Endereco` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `logradouro` VARCHAR(50) NOT NULL ,
  `numero` VARCHAR(10) NOT NULL ,
  `bairro` VARCHAR(30) NOT NULL ,
  `cidade` VARCHAR(45) NOT NULL ,
  `estado` INT NOT NULL ,
  `cep` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_Endereco_Estado_idx` (`estado` ASC) ,
  CONSTRAINT `fk_Endereco_Estado`
    FOREIGN KEY (`estado` )
    REFERENCES `sgaedb`.`Estado` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`TipoUnidade`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`TipoUnidade` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `nome` VARCHAR(10) NOT NULL ,
  PRIMARY KEY (`id`) )
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Plano`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Plano` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `nome` VARCHAR(45) NOT NULL ,
  `descricao` VARCHAR(255) NOT NULL ,
  `valor` DOUBLE NOT NULL ,
  PRIMARY KEY (`id`) )
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Cliente`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Cliente` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `razaoSocial` VARCHAR(100) NOT NULL ,
  `nomeFantasia` VARCHAR(45) NOT NULL ,
  `cnpj` VARCHAR(14) NOT NULL ,
  `diaVencimento` INT NOT NULL ,
  PRIMARY KEY (`id`) )
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Unidade`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Unidade` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `Contato_id` BIGINT NOT NULL ,
  `Endereco_id` BIGINT NOT NULL ,
  `TipoUnidade_id` INT NOT NULL ,
  `Plano_id` INT NOT NULL ,
  `Cliente_id` INT NOT NULL ,
  `nome` VARCHAR(45) NOT NULL ,
  INDEX `fk_Unidade_Contato_idx` (`Contato_id` ASC) ,
  INDEX `fk_Unidade_Endereco_idx` (`Endereco_id` ASC) ,
  INDEX `fk_Unidade_TipoUnidade_idx` (`TipoUnidade_id` ASC) ,
  INDEX `fk_Unidade_Plano_idx` (`Plano_id` ASC) ,
  INDEX `fk_Unidade_Cliente_idx` (`Cliente_id` ASC) ,
  PRIMARY KEY (`id`) ,
  CONSTRAINT `fk_Unidade_Contato`
    FOREIGN KEY (`Contato_id` )
    REFERENCES `sgaedb`.`Contato` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Unidade_Endereco`
    FOREIGN KEY (`Endereco_id` )
    REFERENCES `sgaedb`.`Endereco` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Unidade_TipoUnidade`
    FOREIGN KEY (`TipoUnidade_id` )
    REFERENCES `sgaedb`.`TipoUnidade` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Unidade_Plano`
    FOREIGN KEY (`Plano_id` )
    REFERENCES `sgaedb`.`Plano` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Unidade_Cliente`
    FOREIGN KEY (`Cliente_id` )
    REFERENCES `sgaedb`.`Cliente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Orgao_Emissor`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Orgao_Emissor` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `descricao` VARCHAR(255) NOT NULL ,
  `sigla` VARCHAR(8) NOT NULL ,
  PRIMARY KEY (`id`) )
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Aluno`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Aluno` (
  `id` BIGINT NOT NULL AUTO_INCREMENT ,
  `cpf` VARCHAR(255) NOT NULL ,
  `dtInscricao` DATETIME NULL ,
  `dtNascimento` DATE NULL ,
  `mae` VARCHAR(255) NULL ,
  `nome` VARCHAR(255) NOT NULL ,
  `pai` VARCHAR(255) NULL ,
  `rgExp` INT NULL ,
  `rgNum` VARCHAR(255) NULL ,
  `rgOrg` INT NULL ,
  `valido` VARCHAR(1) NOT NULL ,
  `Unidade_id` INT(11) NOT NULL ,
  `matricula` VARCHAR(15) NOT NULL ,
  `Endereco_id` BIGINT NOT NULL ,
  `Contato_id` BIGINT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_Aluno_Unidade_idx` (`Unidade_id` ASC) ,
  UNIQUE INDEX `UQ_ALUNO_MATRICULA` (`matricula` ASC) ,
  INDEX `fk_Aluno_Orgao_Emissor_idx` (`rgOrg` ASC) ,
  INDEX `fk_Aluno_Estado_Org_Exp_idx` (`rgExp` ASC) ,
  INDEX `fk_Aluno_Endereco` (`Endereco_id` ASC) ,
  INDEX `fk_Aluno_Contato` (`Contato_id` ASC) ,
  CONSTRAINT `fk_Aluno_Unidade`
    FOREIGN KEY (`Unidade_id` )
    REFERENCES `sgaedb`.`Unidade` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Aluno_Orgao_Emissor`
    FOREIGN KEY (`rgOrg` )
    REFERENCES `sgaedb`.`Orgao_Emissor` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Aluno_Estado_Org_Exp`
    FOREIGN KEY (`rgExp` )
    REFERENCES `sgaedb`.`Estado` (`id` )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Aluno_Endereco`
    FOREIGN KEY (`Endereco_id` )
    REFERENCES `sgaedb`.`Endereco` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Aluno_Contato`
    FOREIGN KEY (`Contato_id` )
    REFERENCES `sgaedb`.`Contato` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Pagamento`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Pagamento` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `dtPagamento` DATETIME NOT NULL ,
  `Cliente_id` INT NOT NULL ,
  PRIMARY KEY (`id`) ,
  INDEX `fk_Pagamento_Cliente_idx` (`Cliente_id` ASC) ,
  CONSTRAINT `fk_Pagamento_Cliente`
    FOREIGN KEY (`Cliente_id` )
    REFERENCES `sgaedb`.`Cliente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Perfil`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Perfil` (
  `id` INT NOT NULL AUTO_INCREMENT ,
  `nome` VARCHAR(45) NOT NULL ,
  `descricao` VARCHAR(255) NOT NULL ,
  `sigla` VARCHAR(3) NOT NULL ,
  PRIMARY KEY (`id`) ,
  UNIQUE INDEX `UQ_PERFIL_SIGLA` (`sigla` ASC) )
AUTO_INCREMENT = 1
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


-- -----------------------------------------------------
-- Table `sgaedb`.`Usuario`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `sgaedb`.`Usuario` (
  `cpf` VARCHAR(11) NOT NULL ,
  `nome` VARCHAR(255) NOT NULL ,
  `email` VARCHAR(100) NULL ,
  `senha` VARCHAR(50) NOT NULL ,
  `ativo` VARCHAR(1) NOT NULL DEFAULT 'S' ,
  `Cliente_id` INT NOT NULL ,
  `Perfil_id` INT NOT NULL ,
  PRIMARY KEY (`cpf`) ,
  INDEX `fk_Usuario_Cliente_idx` (`Cliente_id` ASC) ,
  INDEX `fk_Usuario_Perfil_idx` (`Perfil_id` ASC) ,
  CONSTRAINT `fk_Usuario_Cliente`
    FOREIGN KEY (`Cliente_id` )
    REFERENCES `sgaedb`.`Cliente` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT,
  CONSTRAINT `fk_Usuario_Perfil`
    FOREIGN KEY (`Perfil_id` )
    REFERENCES `sgaedb`.`Perfil` (`id` )
    ON DELETE NO ACTION
    ON UPDATE RESTRICT)
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

USE `sgaedb` ;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

