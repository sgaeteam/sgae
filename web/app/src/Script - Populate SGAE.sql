/**
 * Script populate
 */

/* Caso as tabelas jÃ¡ existam, executar a limpeza abaixo */

/* Populando a tabela sgaedb.Perfil */

INSERT INTO `sgaedb`.`Perfil`
(`nome`,
`descricao`,
`sigla`)
VALUES
(
'Administrador', 
'Coordenadores e Analistas',
'ADM'
);

INSERT INTO `sgaedb`.`Perfil`
(`nome`,
`descricao`,
`sigla`)
VALUES
(
'Diretor', 
'Diretores e/ou Gerentes',
'DIR'
);

INSERT INTO `sgaedb`.`Perfil`
(`nome`,
`descricao`,
`sigla`)
VALUES
(
'Supervisor', 
'Supervisores e Apoio',
'SUP'
);

INSERT INTO `sgaedb`.`Perfil`
(`nome`,
`descricao`,
`sigla`)
VALUES
(
'Operador', 
'Operadores',
'OPR'
);

INSERT INTO `sgaedb`.`Perfil`
(`nome`,
`descricao`,
`sigla`)
VALUES
(
'Usuário', 
'Usuários públicos ou Recepção para informações',
'USR'
);

/* Populando a tabela sgaedb.Plano */

INSERT INTO `sgaedb`.`Plano`
(`nome`,
`descricao`,
`valor`)
VALUES
(
'Básico', 
'Pacote: Caixa', 
'119.9'
);

INSERT INTO `sgaedb`.`Plano`
(`nome`,
`descricao`,
`valor`)
VALUES
(
'Plus', 
'Pacote: Caixa/Expedição/Simulado', 
'139.9'
);

INSERT INTO `sgaedb`.`Plano`
(`nome`,
`descricao`,
`valor`)
VALUES
(
'Premium', 
'Pacote: Caixa/Expedição/Simulado/Contas a Pagar/Contas a Receber', 
'159.9'
);

INSERT INTO `sgaedb`.`Plano`
(`nome`,
`descricao`,
`valor`)
VALUES
(
'Gold', 
'Pacote: Caixa/Expedição/Simulado/Contas a Pagar/Contas a Receber/Patrimônio/Cont?bil', 
'189.9'
);

/* Populando a tabela sgaedb.TipoUnidade */

INSERT INTO `sgaedb`.`TipoUnidade`
(`nome`)
VALUES
(
'Matriz'
);

INSERT INTO `sgaedb`.`TipoUnidade`
(`nome`)
VALUES
(
'Filial'
);

/*Populando orgão emissor*/

insert into sgaedb.orgao_emissor(descricao,sigla) values('Secretaria de Segurança Pública','SSP');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Enfermagem','COREN');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Administração','CRA');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Assistentes Sociais','CRAS');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Biblioteconomia','CRB');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Contabilidade','CRC');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Estatística','CRE');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Engenharia Arquitetura e Agronomia','CREA');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Corretores de Imóveis','CRECI');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Fisioterapia e Terapia Ocupacional','CREFIT');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Farmácia','CRF');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Medicina','CRM');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Nutrição','CRN');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Odontologia','CRO');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Psicologia','CRP');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Profissionais de Relações Públicas','CRPRE');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Química','CRQ');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Representantes Comerciais','CRRC');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Conselho Regional de Medicina Veterinária','CRMV');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Polícia Federal','DPF');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Documentos Estrangeiros','EST');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Carteira de Identidade Classista','I CLA');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Ministério da Aeronáutica','MAE');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Ministério do Exército','MEX');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Ministério da Marinha','MMA');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Ordem dos Advogados do Brasil','OAB');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Ordens dos Músicos do Brasil','OMB');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Instituto de Identificação Félix Pacheco','IFP');
insert into sgaedb.orgao_emissor(descricao,sigla) values('Outros Emissores','OUT');

/*Popula estado*/
insert into sgaedb.estado(descricao,sigla) values('Acre','AC');
insert into sgaedb.estado(descricao,sigla) values('Alagoas','AL');
insert into sgaedb.estado(descricao,sigla) values('Amapá','AP');
insert into sgaedb.estado(descricao,sigla) values('Amazonas','AM');
insert into sgaedb.estado(descricao,sigla) values('Bahia','BA');
insert into sgaedb.estado(descricao,sigla) values('Ceará','CE');
insert into sgaedb.estado(descricao,sigla) values('Distrito Federal','DF');
insert into sgaedb.estado(descricao,sigla) values('Espírito Santo','ES');
insert into sgaedb.estado(descricao,sigla) values('Goiás','GO');
insert into sgaedb.estado(descricao,sigla) values('Maranhão','MA');
insert into sgaedb.estado(descricao,sigla) values('Mato Grosso','MT');
insert into sgaedb.estado(descricao,sigla) values('Mato Grosso do Sul','MS');
insert into sgaedb.estado(descricao,sigla) values('Minas Gerais','MG');
insert into sgaedb.estado(descricao,sigla) values('Pará','PA');
insert into sgaedb.estado(descricao,sigla) values('Paraná','PR');
insert into sgaedb.estado(descricao,sigla) values('Pernambuco','PE');
insert into sgaedb.estado(descricao,sigla) values('Piauí','PI');
insert into sgaedb.estado(descricao,sigla) values('Rio de Janeiro','RJ');
insert into sgaedb.estado(descricao,sigla) values('Rio Grande do Norte','RN');
insert into sgaedb.estado(descricao,sigla) values('Santa Catarina','SC');
insert into sgaedb.estado(descricao,sigla) values('Rorâima','RR');
insert into sgaedb.estado(descricao,sigla) values('Rondônia','RO');
insert into sgaedb.estado(descricao,sigla) values('Rio Grande do Sul','RS');
insert into sgaedb.estado(descricao,sigla) values('São Paulo','SP');
insert into sgaedb.estado(descricao,sigla) values('Sergipe','SE');
insert into sgaedb.estado(descricao,sigla) values('Tocantins','TO');

/* Populando a tabela sgaedb.Endereco */
INSERT INTO `sgaedb`.`Endereco`
(`logradouro`,
`numero`,
`bairro`,
`cidade`,
`estado`,
`cep`)
VALUES
(
'R. Maria Bonifácio Santos',
'3257',
'Estrada do Coco',
'Lauro de Freitas',
5,
'42.700-000'
);

INSERT INTO `sgaedb`.`Endereco`
(`logradouro`,
`numero`,
`bairro`,
`cidade`,
`estado`,
`cep`)
VALUES
(
'Av. Antônio Carlos Magalhães',
'480',
'Itaigara',
'Salvador',
5,
'41.825-000'
);

INSERT INTO `sgaedb`.`Endereco`
(`logradouro`,
`numero`,
`bairro`,
`cidade`,
`estado`,
`cep`)
VALUES
(
'Av. Manoel Dias da Silva',
'1892',
'Pituba',
'Salvador',
5,
'41.825-000'
);

/* Populando a tabela sgaedb.Cliente */
INSERT INTO `sgaedb`.`Cliente`
(
`razaoSocial`,
`nomeFantasia`,
`cnpj`,
`diaVencimento`)
VALUES
(
'Lauro Ensinamentos LTDA',
'CFC Lauro de Freitas',
'33014556000196',
2
);

/* Populando a tabela sgaedb.Contato */

INSERT INTO `sgaedb`.`Contato`
(`telCelular`,
`telComercial`,
`telResidencial`,
`telOutro`,
`fax`,
`email`,
`site`)
VALUES
('(71) 9999-9999',
 '(71) 8888-8888', 
 '(71) 7777-7777', 
 '(71) 6666-6666',
 '(71) 5555-5555',
 'laurodefreitas@laurodefreitas.com',
'www.autoescolalaurodefreitas.com'
);

INSERT INTO `sgaedb`.`Contato`
(`telCelular`,
`telComercial`,
`telResidencial`,
`telOutro`,
`fax`,
`email`,
`site`)
VALUES
('(71) 9999-9999',
 '(71) 8888-8888', 
 '(71) 7777-7777', 
 '(71) 6666-6666',
 '(71) 5555-5555', 
 'aluno@aluno.com.br', 
 'www.aluno.com.br'
);

INSERT INTO `sgaedb`.`Contato`
(`telCelular`,
`telComercial`,
`telResidencial`,
`telOutro`,
`fax`,
`email`,
`site`)
VALUES
('(71) 9999-9999',
 '(71) 8888-8888', 
 '(71) 7777-7777', 
 '(71) 6666-6666',
 '(71) 5555-5555',
 'progressoae@progresso.com', 
 'www.progressoae.com.br'
);


/* Populando a tabela sgaedb.Unidade */

INSERT INTO `sgaedb`.`Unidade`
(`Contato_id`,
`Endereco_id`,
`TipoUnidade_id`,
`Plano_id`,
`Cliente_id`,
`nome`
)
VALUES
(
1,
1,
1,
1,
1,
'Matriz'
);


INSERT INTO `sgaedb`.`Unidade`
(`Contato_id`,
`Endereco_id`,
`TipoUnidade_id`,
`Plano_id`,
`Cliente_id`,
`nome`
)
VALUES
(
2,
2,
2,
1,
1,
'Filial 1'
);

/*Populando usuario*/

INSERT INTO `sgaedb`.`usuario` (`cpf`, `nome`, `email`, `senha`, `ativo`, `Cliente_id`, `Perfil_id`) VALUES ('11111111111', 'Moacir Maciel Neto', 'moacirmn@gmail.com', '7322f0064311a4f55af85b5b76e697bd', 'S', '1', '1');
INSERT INTO `sgaedb`.`usuario` (`cpf`, `nome`, `email`, `senha`, `ativo`, `Cliente_id`, `Perfil_id`) VALUES ('22222222222', 'Marcelo Zacarias', 'mzsilva@gmail.com', '1814191a493707a95013dd1cecd97bf7', 'S', '1', '1');
INSERT INTO `sgaedb`.`usuario` (`cpf`, `nome`, `email`, `senha`, `ativo`, `Cliente_id`, `Perfil_id`) VALUES ('33333333333', 'Vitor Smith', 'vsmith@gmail.com', '630138a05841ea8c38882a33b7f42ea5', 'S', '1', '1');

/*Populando aluno*/
INSERT INTO `sgaedb`.`aluno`
(`cpf`,
`dtInscricao`,
`dtNascimento`,
`mae`,
`nome`,
`pai`,
`rgExp`,
`rgNum`,
`rgOrg`,
`valido`,
`Unidade_id`,
matricula,
Contato_Id,
Endereco_id)
VALUES
('111.111.111-11',
sysdate(),
curdate(),
'Ana Maria',
'Moacir Maciel Neto',
'José Maria',
1,
'0941324702',
1,
'S',
1,
'UND001MAT000001',
3,
3
);


COMMIT;