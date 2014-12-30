*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_ARQ                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Gerar Arquivos do Sistema                ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 05/12/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION Cria_Arqs()
   LOCAL nFalta := nTermom := 0 , aDbf

   // Arquivo HELP
   IF !FILE("HELP.HLP")
      aDbf := {}
      AADD(aDbf,{"CODIGO",   "C",    1,0})
      AADD(aDbf,{"SUBCODIGO","C",    2,0})
      AADD(aDbf,{"DESCRICAO","M",   10,0})
      Mensagem("Criando o Arquivo HELP...")
      DBCREATE("HELP.HLP",aDbf)
   ENDIF

   // Cadastro de Cursos
   IF !FILE("DBCURSO.DBF")
      aDbf := {}
      AADD(aDbf,{"CODCUR"  , "C", 02,0})    /* Codigo do curso          */
      AADD(aDbf,{"DESCR"   , "C", 20,0})    /* Nome do cursos           */
      AADD(aDbf,{"TEORICA" , "N", 02,0})    /* Qtde de aulas teoricas   */
      AADD(aDbf,{"PRATICA" , "N", 02,0})    /* Qtde de aulas praticas   */
      Mensagem("Criando Cadastro de Cursos...")
      DBCREATE("DBCURSO",aDbf)
   ENDIF

   // Cadastro de turmas */
   IF !FILE("DBTURMA.DBF")
      aDbf := {}
      AADD(aDbf,{"SEL"       , "C", 01,0})  /* Turma selecionada        */
      AADD(aDbf,{"TURNO"     , "C", 01,0})  /* Turno                    */
      AADD(aDbf,{"TURMA"     , "C", 05,0})  /* Nome da turma            */
      AADD(aDbf,{"NTURMA"    , "C", 06,0})  /* Numero da turma          */
      AADD(aDbf,{"ESCALA"    , "C", 02,0})  /* Escala                   */
      AADD(aDbf,{"CODGRA"    , "C", 02,0})  /* Codigo da grade          */
      AADD(aDbf,{"CODCUR"    , "C", 02,0})  /* Codigo do curso          */
      AADD(aDbf,{"DTINIC"    , "D", 08,0})  /* Data do inicio           */
      AADD(aDbf,{"DTFIM"     , "D", 08,0})  /* Data do final            */
      AADD(aDbf,{"SALA"      , "C", 02,0})  /* Sala                     */
      AADD(aDbf,{"USO_N"     , "N", 02,0})  /* Qtde vagas utiliz.normal */
      AADD(aDbf,{"USO_R"     , "N", 02,0})  /* Qtde vagas utiliz.repos. */
      Mensagem("Criando o Cadastro de Turmas...")
      DBCREATE("DBTURMA",aDbf)
   ENDIF

   // Tabela de Frequencia de Aulas Teoricas */
   IF !FILE("DBFREQ.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno       */
      AADD(aDbf,{"TURNO"     , "C", 01,0})  /* Turno                    */
      AADD(aDbf,{"NTURMA"    , "C", 06,0})  /* Numero da turma          */
      AADD(aDbf,{"CODCUR"    , "C", 02,0})  /* Codigo do curso          */
      AADD(aDbf,{"NAULA"     , "C", 02,0})  /* Numero da aula           */
      AADD(aDbf,{"CODDIS"    , "C", 02,0})  /* Codigo de disciplina     */
      AADD(aDbf,{"CODINST"   , "C", 04,0})  /* Codigo do instrutor      */
      AADD(aDbf,{"DATA"      , "D", 08,0})  /* Data da aulas            */
      AADD(aDbf,{"SIMULADO"  , "C", 01,0})  /* Simulado                 */
      AADD(aDbf,{"HORARIO"   , "C", 13,0})  /* Horario da aula          */
      AADD(aDbf,{"DTREP"     , "D", 08,0})  /* Data da reposicao        */
      AADD(aDbf,{"FALTA"     , "C", 01,0})  /* Aula faltada             */
      AADD(aDbf,{"PAGO"      , "C", 01,0})  /* Aula de reposicao paga   */
      AADD(aDbf,{"USER"      , "C", 25,0})
      Mensagem("Criando o Arq. Freqˆncia (Aulas Te¢ricas)...")
      DBCREATE("DBFREQ",aDbf)
   ENDIF

   // Tabela de Disciplinas
   IF !FILE("DBDISC.DBF")
      aDbf := {}
      AADD(aDbf,{"CODCUR" , "C", 02,0})
      AADD(aDbf,{"CODDIS" , "C", 02,0})
      AADD(aDbf,{"DESCR"  , "C", 30,0})
      AADD(aDbf,{"CH"     , "N", 02,0}) /* Carga Horaria Total */
      Mensagem("Criando o Cadastro de Disciplinas...")
      DBCREATE("DBDISC",aDbf)
   ENDIF

   // Tabela de Escalas
   IF !FILE("DBESCA.DBF")
      aDbf := {}
      AADD(aDbf,{"ESCALA" , "C", 02,0}) /* Codigo da escala       */
      AADD(aDbf,{"HORARIO", "C", 13,0}) /* Horario da Escala      */
      AADD(aDbf,{"DESCR"  , "C", 15,0}) /* Descricao da escala    */
      AADD(aDbf,{"SEG"    , "C", 01,0}) /* Segunda                */
      AADD(aDbf,{"TER"    , "C", 01,0}) /* Terca                  */
      AADD(aDbf,{"QUA"    , "C", 01,0}) /* Quarta                 */
      AADD(aDbf,{"QUI"    , "C", 01,0}) /* Quinta                 */
      AADD(aDbf,{"SEX"    , "C", 01,0}) /* Sexta                  */
      AADD(aDbf,{"SAB"    , "C", 01,0}) /* Sabado                 */
      AADD(aDbf,{"DOM"    , "C", 01,0}) /* Domingo                */
      AADD(aDbf,{"DIAS"   , "C", 02,0})
      Mensagem("Criando a Tabela de Escalas...")
      DBCREATE("DBESCA",aDbf)
   ENDIF

   // Tabela de Salas
   IF !FILE("DBSALA.DBF")
      aDbf := {}
      AADD(aDbf,{"SALA"   , "C", 02,0}) /* Codigo/Nome/Numero da sala      */
      AADD(aDbf,{"VAGA_M" , "N", 02,0}) /* Quatidade de vagas matutino     */
      AADD(aDbf,{"VAGA_V" , "N", 02,0}) /* Quatidade de vagas vespertino   */
      AADD(aDbf,{"VAGA_N" , "N", 02,0}) /* Quatidade de vagas noturno      */
      AADD(aDbf,{"VAGAR_M", "N", 02,0}) /* Qtde vagas reposicao matutino   */
      AADD(aDbf,{"VAGAR_V", "N", 02,0}) /* Qtde vagas reposicao vespertino */
      AADD(aDbf,{"VAGAR_N", "N", 02,0}) /* Qtde vagas reposicao noturno    */
      Mensagem("Criando o Cadastro de Salas...")
      DBCREATE("DBSALA",aDbf)
   ENDIF

   // Grade de Distribui‡Æo de Aulas Teoricas
   IF !FILE("DBGRADE.DBF")
      aDbf := {}
      AADD(aDbf,{"CODGRA"    , "C", 02,0}) /* Codigo da Grade          */
      AADD(aDbf,{"CODCUR"    , "C", 02,0}) /* Codigo do Curso          */
      AADD(aDbf,{"NDIA"      , "C", 02,0}) /* Sequencia do dia         */
      AADD(aDbf,{"CURSO"     , "C", 15,0}) /* Nome do curso (f2)       */
      AADD(aDbf,{"CODDIS"    , "C", 02,0}) /* Codigo da Disciplina     */
      AADD(aDbf,{"NAULA"     , "C", 02,0}) /* Numero da aula           */
      AADD(aDbf,{"HORARIO"   , "C", 13,0}) /* Horario da Aula          */
      AADD(aDbf,{"CODINST"   , "C", 04,0}) /* Codigo do Instrutor      */
      AADD(aDbf,{"SIMULADO"  , "C", 01,0}) /* Aula com simulado        */
      Mensagem("Criando Grade de Distribui‡Æo das Aulas Te¢ricas...")
      DBCREATE("DBGRADE",aDbf)
   ENDIF

   // Arquivo Tabela de Feriados
   IF !FILE("DBFERI.DBF")
      aDbf := {}
      AADD(aDbf,{"DIAMES"  ,"C",   04,0}) /* Dia e mes do feriado           */
      AADD(aDbf,{"TIPO"    ,"C",   01,0}) /* Tipo do feriado M=movel F=Fixo */
      AADD(aDbf,{"DESCR"   ,"C",   30,0}) /* Descri‡Æo do feriado           */
      Mensagem("Criando o Arquivo de Parƒmetros...")
      DBCREATE("DBFERI.DBF",aDbf)
   ENDIF

   // Arquivo de Parametros
   IF !FILE("DBPARM.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Codigo do Cliente           */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do Instrutor         */
      AADD(aDbf,{"CODFOR"   ,"C",   04,0}) /* Codigo do Fornecedor        */
      AADD(aDbf,{"CODCLI"   ,"C",   04,0}) /* Codigo do Cliente           */
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Veiculo           */
      AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item do Fluxo de Caixa      */
      AADD(aDbf,{"MSG"      ,"C",   40,0}) /* Mensagem do Cupom Inscri‡Æo */
      AADD(aDbf,{"REQ"      ,"C",   07,0}) /* Numero do requerimento      */
      AADD(aDbf,{"DTVALID"  ,"D",   08,0}) /* Data validade do sistema    */
      AADD(aDbf,{"DTSIS"    ,"D",   08,0}) /* Controle de data do sistema */
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data para controle de ano   */
      AADD(aDbf,{"NLAN"     ,"C",   12,0}) /* Numero do Ultimo Lancamento */
      AADD(aDbf,{"NTURMA"   ,"C",   06,0}) /* Numero da turma             */
      AADD(aDbf,{"CR"       ,"C",   05,0}) /* Controle de Recibos         */
      AADD(aDbf,{"DTTEST"   ,"D",   08,0}) /* Data de testes              */
      AADD(aDbf,{"REX"      ,"L",   01,0}) /* Faltas em exames praticos   */
      AADD(aDbf,{"MSG_CUP"  ,"C",   50,0}) /* Mensagem no cupom fiscal    */
      AADD(aDbf,{"MSG_REC"  ,"C",   50,0}) /* Mensagem no recibo          */
      AADD(aDbf,{"MSG_LPA"  ,"C",   50,0}) /* Mensagem na programacao     */
      AADD(aDbf,{"MSG_MTR"  ,"C",   50,0}) /* Mensagem na ficha matricula */
      AADD(aDbf,{"AVS_CUP"  ,"C",   50,0}) /* Aviso    no cupom fiscal    */
      AADD(aDbf,{"AVS_REC"  ,"C",   50,0}) /* Aviso    no recibo          */
      AADD(aDbf,{"AVS_LPA"  ,"C",   50,0}) /* Aviso    na programacao     */
      AADD(aDbf,{"AVS_MTR"  ,"C",   50,0}) /* Aviso    na ficha matricula */
      Mensagem("Criando o Arquivo de Parƒmetros...")
      DBCREATE("DBPARM.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Alunos
   IF !FILE("DBALU.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula do Aluno       */
      AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Cliente          */
      AADD(aDbf,{"DTINSCR"  ,"D",   08,0}) /* Data da Inscri‡Æo        */
      AADD(aDbf,{"CATEG"    ,"C",   02,0}) /* Categoria a habilitar    */
      AADD(aDbf,{"HABILITA" ,"C",   11,0}) /* Numero habilitacao       */
      AADD(aDbf,{"CATEG2"   ,"C",   01,0}) /* Categoria habilitada     */
      AADD(aDbf,{"VCTOCAT2" ,"D",   08,0}) /* Data vencimento da CNH   */
      AADD(aDbf,{"CPF"      ,"C",   11,0})
      AADD(aDbf,{"RG"       ,"C",   10,0})
      AADD(aDbf,{"ORGAO"    ,"C",   05,0})
      AADD(aDbf,{"EXPED"    ,"D",   08,0}) /* Data de Expedi‡ao        */
      AADD(aDbf,{"FILIA_P"  ,"C",   50,0}) /* Filia‡Æo Pai             */
      AADD(aDbf,{"FILIA_M"  ,"C",   50,0}) /* Filia‡Æo MÆe             */
      AADD(aDbf,{"NACIONAL" ,"C",   10,0}) /* Nacionalidade            */
      AADD(aDbf,{"NATURAL"  ,"C",   30,0}) /* Naturalidade             */
      AADD(aDbf,{"UF_NAT"   ,"C",   02,0}) /* Estado Naturalidade      */
      AADD(aDbf,{"CIVIL"    ,"C",   01,0}) /* Estado Civil             */
      AADD(aDbf,{"DTNAS"    ,"D",   08,0}) /* Data de Nascimento       */
      AADD(aDbf,{"RENACH"   ,"C",   10,0}) /* numero do RENACH         */
      AADD(aDbf,{"RENACH2"  ,"C",   10,0}) /* numero do RENACH 2       */
      AADD(aDbf,{"RENACH3"  ,"C",   10,0}) /* numero do RENACH 3       */
      AADD(aDbf,{"ENDERECO" ,"C",   60,0}) /* Endere‡o Residencial     */
      AADD(aDbf,{"BAIRRO"   ,"C",   20,0})
      AADD(aDbf,{"CIDADE"   ,"C",   30,0})
      AADD(aDbf,{"UF"       ,"C",   02,0})
      AADD(aDbf,{"CEP"      ,"C",   08,0})
      AADD(aDbf,{"PROF"     ,"C",   20,0}) /* ProfissÆo                */
      AADD(aDbf,{"FONE_R"   ,"C",   10,0}) /* Telefone residencial     */
      AADD(aDbf,{"FONE_C"   ,"C",   10,0}) /* Telefone comercial       */
      AADD(aDbf,{"CELULAR"  ,"C",   08,0}) /* Telefone pessoal         */
      AADD(aDbf,{"APTO"     ,"C",   01,0}) /* Habilitado pela escola   */
      AADD(aDbf,{"CFCT"     ,"C",   10,0}) /* CFC teorico              */
      AADD(aDbf,{"CFCP"     ,"C",   10,0}) /* CFC pratico              */
      AADD(aDbf,{"ETQT"     ,"C",   11,0}) /* Etiqueta origem teorico  */
      AADD(aDbf,{"CODT"     ,"C",   11,0}) /* codigo da etiqueta teo   */
      AADD(aDbf,{"ETQP"     ,"C",   11,0}) /* Etiqueta origem pratico  */
      AADD(aDbf,{"CODP"     ,"C",   11,0}) /* codigo da etiqueta prat  */
      AADD(aDbf,{"CONTATO"  ,"C",   23,0}) /* Telefone de contato      */
      AADD(aDbf,{"VALOR"    ,"N",   10,2}) /* Valor Total das Aulas    */
      AADD(aDbf,{"AULAS"    ,"N",   02,0}) /* Quantidade de Aulas      */
      AADD(aDbf,{"PENDENTE" ,"N",   02,0}) /* Qtde de Aulas Pendentes  */
      AADD(aDbf,{"DESMARC"  ,"N",   02,0}) /* Qtde de Aulas Desmarcadas*/
      AADD(aDbf,{"RESULTADO","C",   01,0}) /* Aprova‡Æo nas Aulas      */
      AADD(aDbf,{"MARCADA"  ,"N",   02,0}) /* Qtde de Aulas Marcadas   */
      AADD(aDbf,{"OBSERVA"  ,"C",   01,0}) /* Observacao Condicao aluno*/
      AADD(aDbf,{"PESQ"     ,"C",   01,0}) /* Meio de procura          */
      AADD(aDbf,{"OUTRO"    ,"C",   30,0}) /* Outro meio de procura    */
      AADD(aDbf,{"EMAIL"    ,"C",   30,0}) /* e-mail eletronico        */
      AADD(aDbf,{"AUTO"     ,"C",   01,0}) /* Pesquisa de veiculo      */
      AADD(aDbf,{"PRAZO"    ,"N",   03,0}) /* Prazo                    */
      AADD(aDbf,{"LIB"      ,"C",   01,0}) /* Liberacao                */
      AADD(aDbf,{"TURNOFR"  ,"C",   03,0}) /* Turno fone contato resid */
      AADD(aDbf,{"TURNOFC"  ,"C",   03,0}) /* Turno fone contato coml  */
      AADD(aDbf,{"SEXO"     ,"C",   01,0}) /* Sexo do(a) Aluno(a)      */
      AADD(aDbf,{"PREF"     ,"C",   25,0}) /* Ponto de referencia      */
      AADD(aDbf,{"LADV"     ,"C",   08,0}) /* Numero do LADV (novo)    */
      AADD(aDbf,{"LADVEMISS","D",   08,0}) /* Data da emissao LADV     */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do instrutor LADV */
      AADD(aDbf,{"LADVENT"  ,"D",   08,0}) /* Data entrega do LADV     */
      AADD(aDbf,{"LADVLIV"  ,"C",   04,0}) /* Livro do LADV            */
      AADD(aDbf,{"LADVPAG"  ,"C",   02,0}) /* Pagina do LADV           */
      Mensagem("Criando o Cadastro de Alunos...")
      DBCREATE("DBALU.DBF",aDbf)
   ENDIF

   // Arquivo de Certificados
   IF !FILE("DBCERT.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"     ,"C",   05,0}) /* Matricula do Aluno       */
      AADD(aDbf,{"NOME"       ,"C",   50,0}) /* Nome do Aluno            */
      AADD(aDbf,{"CERTIF1"    ,"C",   10,0}) /* Certificado teorico      */
      AADD(aDbf,{"CERTIF2"    ,"C",   10,0}) /* Certificado pratico (C)  */
      AADD(aDbf,{"CERTIF3"    ,"C",   10,0}) /* Certificado pratico (M)  */
      AADD(aDbf,{"PERI_T"     ,"D",   08,0}) /* Periodo inicial teorico  */
      AADD(aDbf,{"PERF_T"     ,"D",   08,0}) /* Periodo final teorico    */
      AADD(aDbf,{"PERI_P"     ,"D",   08,0}) /* Per.inic.pratico Carro   */
      AADD(aDbf,{"PERF_P"     ,"D",   08,0}) /* Per.final pratico Carro  */
      AADD(aDbf,{"PERI_P1"    ,"D",   08,0}) /* Per.inic.pratico Moto    */
      AADD(aDbf,{"PERF_P1"    ,"D",   08,0}) /* Per.final pratico Moto   */
      AADD(aDbf,{"DTEM1"      ,"D",   08,0}) /* Data da Emissao   (T)    */
      AADD(aDbf,{"DTEM11"     ,"D",   08,0}) /*                          */
      AADD(aDbf,{"DTEM111"    ,"D",   08,0}) /*                          */
      AADD(aDbf,{"DTEM2"      ,"D",   08,0}) /* Data da Emissao   (PC)   */
      AADD(aDbf,{"DTEM22"     ,"D",   08,0}) /*                          */
      AADD(aDbf,{"DTEM222"    ,"D",   08,0}) /*                          */
      AADD(aDbf,{"DTEM3"      ,"D",   08,0}) /* Data da Emissao   (PM)   */
      AADD(aDbf,{"DTEM33"     ,"D",   08,0}) /*                          */
      AADD(aDbf,{"DTEM333"    ,"D",   08,0}) /*                          */
      AADD(aDbf,{"LIV_T1"     ,"C",   04,0}) /* Livro certif. teorico    */
      AADD(aDbf,{"LIV_T11"    ,"C",   04,0}) /*                          */
      AADD(aDbf,{"LIV_T111"   ,"C",   04,0}) /*                          */
      AADD(aDbf,{"LIV_P2"     ,"C",   04,0}) /* Livro certif. pratico (C)*/
      AADD(aDbf,{"LIV_P22"    ,"C",   04,0}) /*                          */
      AADD(aDbf,{"LIV_P222"   ,"C",   04,0}) /*                          */
      AADD(aDbf,{"LIV_P3"     ,"C",   04,0}) /* Livro certif. pratico (M)*/
      AADD(aDbf,{"LIV_P33"    ,"C",   04,0}) /*                          */
      AADD(aDbf,{"LIV_P333"   ,"C",   04,0}) /*                          */
      AADD(aDbf,{"PAG_T1"     ,"C",   02,0}) /* Pagina certif. teorico   */
      AADD(aDbf,{"PAG_T11"    ,"C",   02,0}) /*                          */
      AADD(aDbf,{"PAG_T111"   ,"C",   02,0}) /*                          */
      AADD(aDbf,{"PAG_P2"     ,"C",   02,0}) /* Pagina certif. prat. (C) */
      AADD(aDbf,{"PAG_P22"    ,"C",   02,0}) /*                          */
      AADD(aDbf,{"PAG_P222"   ,"C",   02,0}) /*                          */
      AADD(aDbf,{"PAG_P3"     ,"C",   02,0}) /* Pagina certif. prat. (M) */
      AADD(aDbf,{"PAG_P33"    ,"C",   02,0}) /*                          */
      AADD(aDbf,{"PAG_P333"   ,"C",   02,0}) /*                          */
      AADD(aDbf,{"ETIQ1"      ,"C",   11,0}) /* Etiqueta 1               */
      AADD(aDbf,{"ETIQ11"     ,"C",   11,0}) /*                          */
      AADD(aDbf,{"ETIQ111"    ,"C",   11,0}) /*                          */
      AADD(aDbf,{"ETIQ2"      ,"C",   11,0}) /* Etiqueta 2               */
      AADD(aDbf,{"ETIQ22"     ,"C",   11,0}) /*                          */
      AADD(aDbf,{"ETIQ222"    ,"C",   11,0}) /*                          */
      AADD(aDbf,{"ETIQ3"      ,"C",   11,0}) /* Etiqueta 3               */
      AADD(aDbf,{"ETIQ33"     ,"C",   11,0}) /*                          */
      AADD(aDbf,{"ETIQ333"    ,"C",   11,0}) /*                          */
      AADD(aDbf,{"CODETQ1"    ,"C",   06,0}) /* Cod. Etiqueta 1          */
      AADD(aDbf,{"CODETQ11"   ,"C",   06,0}) /*                          */
      AADD(aDbf,{"CODETQ111"  ,"C",   06,0}) /*                          */
      AADD(aDbf,{"CODETQ2"    ,"C",   06,0}) /* Cod. Etiqueta 2          */
      AADD(aDbf,{"CODETQ22"   ,"C",   06,0}) /*                          */
      AADD(aDbf,{"CODETQ222"  ,"C",   06,0}) /*                          */
      AADD(aDbf,{"CODETQ3"    ,"C",   06,0}) /* Cod. Etiqueta 3          */
      AADD(aDbf,{"CODETQ33"   ,"C",   06,0}) /*                          */
      AADD(aDbf,{"CODETQ333"  ,"C",   06,0}) /*                          */
      AADD(aDbf,{"OBS1"       ,"C",   40,0}) /* Observacoes              */
      AADD(aDbf,{"OBS2"       ,"C",   40,0}) /*                          */
      AADD(aDbf,{"OBS3"       ,"C",   40,0}) /*                          */
      AADD(aDbf,{"USER"       ,"C",   30,0}) /* Nome do Usuario          */
      Mensagem("Criando o Cadastro de Certificados...")
      DBCREATE("DBCERT.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Instrutores
   IF !FILE("DBINST.DBF")
      aDbf := {}
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do Instrutor         */
      AADD(aDbf,{"CATEG"    ,"C",   01,0}) /* Categoria do instrutor      */
      AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Instrutor           */
      AADD(aDbf,{"ENDERECO" ,"C",   50,0})
      AADD(aDbf,{"BAIRRO"   ,"C",   20,0})
      AADD(aDbf,{"CIDADE"   ,"C",   30,0})
      AADD(aDbf,{"UF"       ,"C",   02,0})
      AADD(aDbf,{"CEP"      ,"C",   08,0})
      AADD(aDbf,{"CPF"      ,"C",   11,0})
      AADD(aDbf,{"RG"       ,"C",   11,0}) /* Carteira de Identidade      */
      AADD(aDbf,{"ORGAO"    ,"C",   07,0}) /* Orgao Emissor               */
      AADD(aDbf,{"CTPS"     ,"C",   07,0}) /* Carteira Profissional       */
      AADD(aDbf,{"SERIE"    ,"C",   04,0}) /* Serie da CTPS               */
      AADD(aDbf,{"CNH"      ,"C",   11,0}) /* Carteira de Habilitacao     */
      AADD(aDbf,{"FONE_R"   ,"C",   10,0}) /* Telefone residencial        */
      AADD(aDbf,{"CELULAR"  ,"C",   08,0}) /* Celular                     */
      AADD(aDbf,{"DTADM"    ,"D",   08,0}) /* Data AdmissÆo               */
      AADD(aDbf,{"STATUS"   ,"C",   01,0}) /* Status do Instrutor         */
      AADD(aDbf,{"CHP"      ,"N",   04,0}) /* Carga Horaria Prog.(Pratica)*/
      AADD(aDbf,{"CHT"      ,"N",   04,0}) /* Carga Horaria Prog.(Teorica)*/
      AADD(aDbf,{"ULTDTP"   ,"D",   08,0}) /* Ultima data Prog.(Pratica)  */
      AADD(aDbf,{"ULTDTT"   ,"D",   08,0}) /* Ultima data Prog.(Teorica)  */
      Mensagem("Criando Cadastro de Instrutores...")
      DBCREATE("DBINST.DBF",aDbf)
   ENDIF

   // Arquivo Cadastro de Ve¡culos
   IF !FILE("DBVEIC.DBF")
      aDbf := {}
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Ve¡culo      */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do Instrutor    */
      AADD(aDbf,{"NOME"     ,"C",   40,0}) /* Nome do instrutor      */
      AADD(aDbf,{"PLACA"    ,"C",   07,0}) /* Placa Policial         */
      AADD(aDbf,{"MARCA"    ,"C",   20,0}) /* Marca do Ve¡culo       */
      AADD(aDbf,{"KMINI"    ,"N",   08,1}) /* Quilometragem Inicial  */
      AADD(aDbf,{"KMATU"    ,"N",   08,1}) /* Quilometragem Atual    */
      AADD(aDbf,{"STATUS"   ,"C",   01,0}) /* Status do Veiculo      */
      Mensagem("Criando Cadastro de Ve¡culos...")
      DBCREATE("DBVEIC.DBF",aDbf)
   ENDIF

   // Tabela de Categorias
   IF !FILE("DBCATEG.DBF")
      aDbf := {}
      AADD(aDbf,{"IDCAT"  , "C", 01,0})  /* C¢digo da Categoria      */
      AADD(aDbf,{"DESCR"  , "C", 30,0})  /* Descri‡Æo                */
      Mensagem("Criando Tabela de Categorias...")
      DBCREATE("DBCATEG",aDbf)
   ENDIF

   // Arquivo de Pagamentos de Alunos
   IF !FILE("DBPAG.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matr¡cula do Aluno     */
      AADD(aDbf,{"NF"       ,"C",   06,0}) /* Numero da NF           */
      AADD(aDbf,{"NLAN"     ,"C",   12,0}) /* Numero do Lancamento   */
      AADD(aDbf,{"OK"       ,"C",   01,0}) /* Libera Pagamento       */
      AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Aluno          */
      AADD(aDbf,{"PARCELA"  ,"C",   02,0}) /* Parcela do Pagamento   */
      AADD(aDbf,{"DOC"      ,"C",   10,0}) /* Numero do Cheque       */
      AADD(aDbf,{"BANCO"    ,"C",   15,0}) /* Nome do Banco          */
      AADD(aDbf,{"TITULAR"  ,"C",   25,0}) /* Titular do cheque      */
      AADD(aDbf,{"DTVCTO"   ,"D",   08,0}) /* Data do Vencimento     */
      AADD(aDbf,{"DTPGTO"   ,"D",   08,0}) /* Data do Pagamento      */
      AADD(aDbf,{"JUROS"    ,"N",   10,2}) /* Acr‚scimo Atraso pgto. */
      AADD(aDbf,{"VALOR_P"  ,"N",   10,2}) /* Valor Pago             */
      AADD(aDbf,{"VALOR_D"  ,"N",   10,2}) /* Valor em Dinheiro      */
      AADD(aDbf,{"VALOR_C"  ,"N",   10,2}) /* Valor em Cheque        */
      AADD(aDbf,{"SERVICO"  ,"C",   50,0}) /* Servicos               */
      AADD(aDbf,{"OBS1"     ,"C",   67,0}) /* Observa‡Æo             */
      AADD(aDbf,{"OBS2"     ,"C",   67,0}) /* Pendencia              */
      AADD(aDbf,{"DTFAVOR"  ,"D",   08,0}) /* data de saida do cheque*/
      AADD(aDbf,{"FAVOR"    ,"C",   25,0}) /* Favorecido             */
      Mensagem("Criando a Tabela de Pagamento de Alunos...")
      DBCREATE("DBPAG.DBF",aDbf)
   ENDIF

   // Arquivo de Programa‡Æo de Aulas Praticas
   IF !FILE("DBPROG.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matr¡cula do Aluno   */
      AADD(aDbf,{"NUMERO"   ,"C",   02,0}) /* Numero da Aula       */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C¢digo do Instrutor  */
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* C¢digo do Ve¡culo    */
      AADD(aDbf,{"EMBARQ"   ,"C",   01,0}) /* Local de Embarque    */
      AADD(aDbf,{"LOCAL"    ,"C",   15,0}) /* Local de Embarque    */
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Exame        */
      AADD(aDbf,{"HORA"     ,"C",   04,0}) /* Hora Prevista        */
      AADD(aDbf,{"COBRADA"  ,"L",   01,0}) /* Aula Cobrada         */
      AADD(aDbf,{"STATUS"   ,"L",   01,0}) /* Aula Cancelada       */
      AADD(aDbf,{"USER"     ,"C",   30,0}) /* Nome do Usuario      */
      Mensagem("Criando a Tabela de Programa‡Æo de Aulas Pr ticas...")
      DBCREATE("DBPROG.DBF",aDbf)
   ENDIF

   // Arquivo de Desmarca‡Æo de Aulas
   IF !FILE("DBDESM.DBF")
      aDbf := {}
      AADD(aDbf,{"DTMOV"    ,"D",   08,0}) /* Data do movimento    */
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matr¡cula do Aluno   */
      AADD(aDbf,{"NUMERO"   ,"C",   02,0}) /* Numero da Aula       */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C¢digo do Instrutor  */
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* C¢digo do Ve¡culo    */
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Treino       */
      AADD(aDbf,{"HORA"     ,"C",   02,0}) /* Hora Prevista        */
      AADD(aDbf,{"MOTIVO"   ,"C",   50,0}) /* Motivo               */
      AADD(aDbf,{"CONTATO"  ,"C",   20,0}) /* Contato              */
      AADD(aDbf,{"GRAU"     ,"C",   20,0}) /* Grau Afinidade       */
      AADD(aDbf,{"DTCONT"   ,"D",   08,0}) /* Data do contato      */
      AADD(aDbf,{"HCONT"    ,"C",   04,0}) /* Hora do contato      */
      AADD(aDbf,{"PROTOCOLO","C",   08,0}) /* Numero do protocolo  */
      AADD(aDbf,{"OBS"      ,"C",   50,0}) /* Observacoes          */
      AADD(aDbf,{"STATUS"   ,"L",   01,0}) /* Remarcada            */
      AADD(aDbf,{"USER"     ,"C",   30,0}) /* Nome do Usuario      */
      Mensagem("Criando o Arq. de Desmarca‡Æo de Aulas...")
      DBCREATE("DBDESM.DBF",aDbf)
   ENDIF

   // Arquivo Tabela de Infra‡äes
   IF !FILE("DBFALT.DBF")
      aDbf := {}
      AADD(aDbf,{"GRAU"     ,"C",   01,0}) /* Grau da Falta        */
      AADD(aDbf,{"ITEM"     ,"C",   01,0}) /* Item da Falta        */
      AADD(aDbf,{"DESCR"    ,"C",   70,0}) /* Descri‡Æo da Falta   */
      Mensagem("Criando a Tabela de Infra‡äes no Trƒnsito...")
      DBCREATE("DBFALT.DBF",aDbf)
   ENDIF

   // Tabela de Bancos (Financeiro)
   IF !FILE("DBBCO.DBF")
      aDbf := {}
      AADD(aDbf,{"CODBCO"  ,"C",   03,0}) /* C¢digo do Banco              */
      AADD(aDbf,{"DESCR"   ,"C",   20,0}) /* Descri‡Æo do Banco           */
      Mensagem("Criando Tabela de Bancos...")
      DBCREATE("DBBCO",aDbf)
   ENDIF

   // Tabela Adm. Cartäes de Cr‚dito (Financeiro)
   IF !FILE("DBACC.DBF")
      aDbf := {}
      AADD(aDbf,{"CODCARD" , "C", 02,0})
      AADD(aDbf,{"TAXA"    , "N", 05,2}) /* Taxa % de desconto da operadora */
      AADD(aDbf,{"DESCR"   , "C", 20,0})
      Mensagem("Criando Tabela Adm.Cartäes de Cr‚dito...")
      DBCREATE("DBACC",aDbf)
   ENDIF

   // Arquivo de Resultado da Prova de Dire‡Æo Veicular
   IF !FILE("DBAVAL.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matr¡cula do Aluno   */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C¢digo do Instrutor  */
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* C¢digo do Ve¡culo    */
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data da Prova        */
      AADD(aDbf,{"GRAU"     ,"C",   01,0}) /* Grau da Falta        */
      AADD(aDbf,{"ITEM"     ,"C",   01,0}) /* Item da Falta        */
      Mensagem("Criando o Arquivo de Avalia‡Æo do Aluno...")
      DBCREATE("DBAVAL.DBF",aDbf)
   ENDIF

   // Tabela de Pre‡os de Servi‡os
   IF !FILE("DBPRECO.DBF")
      aDbf := {}
      AADD(aDbf,{"CONTA"    ,"C",   07,0}) /* Conta Contabil                */
      AADD(aDbf,{"CODSERV"  ,"C",   03,0}) /* C¢digo do Servi‡o             */
      AADD(aDbf,{"DESCR"    ,"C",   30,0}) /* Descri‡Æo do Servi‡o          */
      AADD(aDbf,{"HIST"     ,"C",   30,0}) /* Historico da Conta Contabil   */
      AADD(aDbf,{"VLUNIT"   ,"N",   07,2}) /* Valor Unit rio do Servi‡o     */
      AADD(aDbf,{"IDCAT"    ,"C",   01,0}) /* Categoria pertinente          */
      AADD(aDbf,{"AULAS_T"  ,"N",   02,0}) /* Total de Aulas Teoricas       */
      AADD(aDbf,{"AULAS_P"  ,"N",   02,0}) /* Total de Aulas Praticas       */
      Mensagem("Criando Tabela de Pre‡os de Servi‡os...")
      DBCREATE("DBPRECO",aDbf)
   ENDIF

   // Tabela de Plano de Contas
   IF !FILE("DBPLANO.DBF")
      aDbf := {}
      AADD(aDbf,{"CONTA"  , "C", 07,0})  /* Conta 9.9.9.9.999               */
      AADD(aDbf,{"TIPO"   , "C", 01,0})  /* A=Adm T=Trib R=Receita          */
      AADD(aDbf,{"CLASS"  , "C", 01,0})  /* Classificacao da Conta          */
      AADD(aDbf,{"OPER"   , "C", 01,0})  /* Operacao Credito ou Debito      */
      AADD(aDbf,{"DESCR"  , "C", 30,0})
      AADD(aDbf,{"TAXA"   , "N", 05,2})  /* Taxa de recolhimento tributario */
      Mensagem("Criando o Cadastro de Plano de Contas...")
      DBCREATE("DBPLANO",aDbf)
   ENDIF

   // Arquivo de Contas Correntes
   IF !FILE("DBBANCO.DBF")
      nTermom++
      aDbf := {}
      AADD(aDbf,{"CONTA"  , "C", 23,0})
      AADD(aDbf,{"TITULAR", "C", 30,0})
      AADD(aDbf,{"SALDO"  , "N", 14,2})
      AADD(aDbf,{"SENHA"  , "C", 04,0})
      Mensagem("Criando o Cadastro de Bancos...")
      DBCREATE("DBBANCO",aDbf)
   ENDIF

   IF !FILE("DBMOVBCO.DBF")
      aDbf := {}
      AADD(aDbf,{"CONTA"    ,"C",   23,0}) /* Numero da Conta Corrente */
      AADD(aDbf,{"NUMDOC"   ,"C",   06,0}) /* Numero do Documento      */
      AADD(aDbf,{"DATMOV"   ,"D",   08,0}) /* Data do Movimento        */
      AADD(aDbf,{"DATDOC"   ,"D",   08,0}) /* Data do Documento        */
      AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Codigo Item de Consumo   */
      AADD(aDbf,{"DSCLAN"   ,"C",   40,0}) /* Descri‡Æo do Lancamento  */
      AADD(aDbf,{"FAVOR"    ,"C",   40,0}) /* Favorecido               */
      AADD(aDbf,{"TIPOLAN"  ,"C",   01,0}) /* Tipo do Lancamento       */
      AADD(aDbf,{"VALOR"    ,"N",   12,2}) /* Valor do Lancamento      */
      AADD(aDbf,{"VALORDH"  ,"N",   12,2}) /* Valor em Dinheiro        */
      Mensagem("Criando o Arquivo de Movimenta‡Æo Banc ria...")
      DBCREATE("DBMOVBCO.DBF",aDbf)
   ENDIF

   // Tabela de Itens de Caixa
   IF !FILE("DBITEM.DBF")
      nTermom++
      aDbf := {}
      AADD(aDbf,{"ITEM_CX", "C", 04,0})
      AADD(aDbf,{"DESCR"  , "C", 35,0})
      AADD(aDbf,{"CD"     , "C", 01,0})
      Mensagem("Criando o Cadastro de Itens...")
      DBCREATE("DBITEM",aDbf)
   ENDIF

   // Arquivo Contas a Pagar
   IF !FILE("DBPAGA.DBF")
      aDbf := {}
      AADD(aDbf,{"NDOC"     ,"C",   06,0}) /* Numero do Documento           */
      AADD(aDbf,{"NF"       ,"C",   06,0}) /* Numero da Nota Fiscal         */
      AADD(aDbf,{"COD_CF"   ,"C",   04,0}) /* Codigo do Cliente/Fornecedor  */
      AADD(aDbf,{"CONTA"    ,"C",   23,0}) /* Codigo da Banco/Agencia/Conta */
      AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item de Caixa                 */
      AADD(aDbf,{"DTPAG"    ,"D",   08,0}) /* Data do Pagamento             */
      AADD(aDbf,{"DTEMISS"  ,"D",   08,0}) /* Data de Emissao do Documento  */
      AADD(aDbf,{"DTAPAG"   ,"D",   08,0}) /* Data a Pagar                  */
      AADD(aDbf,{"DESC"     ,"N",   06,2}) /* Percentual do Desconto        */
      AADD(aDbf,{"JURD"     ,"N",   06,2}) /* Juros Diarios                 */
      AADD(aDbf,{"VLRJUR"   ,"N",   12,2}) /* Valor do Juros                */
      AADD(aDbf,{"VLRDESC"  ,"N",   12,2}) /* Valor Desconto                */
      AADD(aDbf,{"VLR_PAG"  ,"N",   12,2}) /* Valor Pago                    */
      AADD(aDbf,{"VLR_APAG" ,"N",   12,2}) /* Valor a Pagar                 */
      AADD(aDbf,{"VALPG"    ,"N",   12,2}) /* Valor Total a Pagar           */
      AADD(aDbf,{"OBS"      ,"C",   50,2}) /* Observacoes                   */
      AADD(aDbf,{"FORMA"    ,"C",   01,2}) /* Forma de Pagamento            */
      Mensagem("Criando o Arquivo de Contas a Receber...")
      DBCREATE("DBPAGA.DBF",aDbf)
   ENDIF

   // Arquivo Tipos de Consumo para Ve¡culos
   IF !FILE("DBTCON.DBF")
      aDbf := {}
      AADD(aDbf,{"TIPOCON"  ,"C",   02,0}) /* Tipo do Consumo        */
      AADD(aDbf,{"DESCR"    ,"C",   30,0}) /* Descri‡Æo do Consumo   */
      Mensagem("Criando o Arquivo Tipos de Consumo...")
      DBCREATE("DBTCON.DBF",aDbf)
   ENDIF

   // Arquivo Resumo de Consumo dos Ve¡culos
   IF !FILE("DBRCON.DBF")
      aDbf := {}
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Veiculo      */
      AADD(aDbf,{"MESANO"   ,"C",   06,0}) /* Mes/Ano do Consumo     */
      AADD(aDbf,{"CODCON"   ,"C",   02,0}) /* Codigo do Consumo      */
      AADD(aDbf,{"VALOR"    ,"N",   09,2}) /* Valor do Consumo       */
      Mensagem("Criando o Arquivo Resumo de Consumo...")
      DBCREATE("DBRCON.DBF",aDbf)
   ENDIF

  // Arquivo de Lan‡amento de Consumos de Ve¡culos
   IF !FILE("DBLCON.DBF")
      aDbf := {}
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do  Veiculo      */
      AADD(aDbf,{"FAVOR"    ,"C",   30,0}) /* Favorecido              */
      AADD(aDbf,{"DESCR"    ,"C",   30,0}) /* Descri‡Æo do Lan‡amento */
      AADD(aDbf,{"VALOR"    ,"N",   09,2}) /* Valor do Lan‡amento     */
      AADD(aDbf,{"CODCON"   ,"C",   02,0}) /* Codigo do Cosumo        */
      AADD(aDbf,{"DATACON"  ,"D",   08,0}) /* Data do Consumo         */
      AADD(aDbf,{"CTRLAULAS","N",   02,0}) /* Aulas (Controle Comb.)  */
      Mensagem("Criando o Arquivo Lan‡amento de Consumos...")
      DBCREATE("DBLCON.DBF",aDbf)
   ENDIF

   // Arquivo Exame Pratico
   IF !FILE("DBEXAM.DBF")
      aDbf := {}
      AADD(aDbf,{"DTVCTO"   ,"D",   08,0}) /* Data do Vencimento          */
      AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Aluno               */
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula do aluno          */
      AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do Instrutor         */
      AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Ve¡culo           */
      AADD(aDbf,{"VEZ"      ,"C",   01,0}) /* Vez que aluno faz o exame   */
      AADD(aDbf,{"DTEXAME"  ,"D",   08,0}) /* Data do Exame Pr tico       */
      AADD(aDbf,{"HORA"     ,"C",   04,0}) /* Hora do Exame               */
      AADD(aDbf,{"DTEXAME1" ,"D",   08,0}) /* Data do Exame Pr tico       */
      AADD(aDbf,{"HORA1"    ,"C",   04,0}) /* Hora do Exame               */
      AADD(aDbf,{"OBS"      ,"C",   30,0}) /* Observa‡äes                 */
      AADD(aDbf,{"CARRO"    ,"N",   10,2}) /* Valor do Aluguel do Carro   */
      AADD(aDbf,{"RENACH"   ,"C",   10,0}) /* N£mero do RENACH            */
      AADD(aDbf,{"ETIQ"     ,"C",   11,0}) /* N£mero da Etiqueta          */
      AADD(aDbf,{"RESULTADO","C",   01,0}) /* Situa‡ao do Exame           */
      Mensagem("Criando o Cadastro de Exames...")
      DBCREATE("DBEXAM.DBF",aDbf)
   ENDIF

   // Arquivo Movimento de Caixa
   IF !FILE("DBCX.DBF")
      aDbf := {}
      AADD(aDbf,{"NLAN"     ,"C",   12,0}) /* Numero do Lancamento     */
      AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item de caixa            */
      AADD(aDbf,{"CONTA"    ,"C",   07,0}) /* Conta 9.9.9.9.999        */
      AADD(aDbf,{"DOC"      ,"C",   10,0}) /* Documento                */
      AADD(aDbf,{"OK"       ,"C",   02,0}) /* Confirmacao recebimento  */
      AADD(aDbf,{"NF"       ,"C",   07,0}) /* Numero da Nota Fiscal    */
      AADD(aDbf,{"BANCO"    ,"C",   15,0}) /* Nome do Banco            */
      AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula                */
      AADD(aDbf,{"HIST"     ,"C",   50,0}) /* Hist¢rico                */
      AADD(aDbf,{"TIPO"     ,"C",   01,0}) /* Cr‚dito ou D‚bito        */
      AADD(aDbf,{"DTMOV"    ,"D",   08,0}) /* Data do Movimento        */
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Documento        */
      AADD(aDbf,{"VALOR"    ,"N",   10,2}) /* Valor total              */
      AADD(aDbf,{"VLR_D"    ,"N",   10,2}) /* Valor em dinheiro        */
      AADD(aDbf,{"VLR_C"    ,"N",   10,2}) /* Valor em cheque          */
      AADD(aDbf,{"SERV"     ,"C",   50,0}) /* Descricao do servico     */
      AADD(aDbf,{"OBS1"     ,"C",   67,0}) /* Observacoes              */
      AADD(aDbf,{"USER"     ,"C",   30,0}) /* Operador                 */
      Mensagem("Criando o Arquivo de Caixa...")
      DBCREATE("DBCX.DBF",aDbf)
   ENDIF

   // Arquivo de Saldos
   IF !FILE("DBSD.DBF")
      aDbf := {}
      AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Fechamento       */
      AADD(aDbf,{"SALDO"    ,"N",   12,2}) /* Saldo na Data            */
      Mensagem("Criando o Arquivo de Caixa...")
      DBCREATE("DBSD.DBF",aDbf)
   ENDIF

   // Fornecedores
   IF !FILE("DBFORN.DBF")
      aDbf := {}
      AADD(aDbf,{"CODFOR"   ,"C",   06,0}) /* Codigo do Fornecedor        */
      AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Cliente             */
      AADD(aDbf,{"ENDERECO" ,"C",   50,0})
      AADD(aDbf,{"BAIRRO"   ,"C",   20,0})
      AADD(aDbf,{"CIDADE"   ,"C",   15,0})
      AADD(aDbf,{"UF"       ,"C",   02,0})
      AADD(aDbf,{"CEP"      ,"C",   08,0})
      AADD(aDbf,{"CNPJ"     ,"C",   14,0})
      AADD(aDbf,{"IE"       ,"C",   15,0})
      AADD(aDbf,{"CPF"      ,"C",   11,0})
      AADD(aDbf,{"FONE1"    ,"C",   12,0})
      AADD(aDbf,{"FONE2"    ,"C",   12,0})
      AADD(aDbf,{"FAX1"     ,"C",   12,0})
      AADD(aDbf,{"CONTATO"  ,"C",   25,0}) /* Contato                     */
      AADD(aDbf,{"CELULAR1" ,"C",   09,0})
      AADD(aDbf,{"PAGAMENTO","C",   50,0}) /* Endere‡o de Pagamento       */
      AADD(aDbf,{"BAIRRO2"  ,"C",   20,0})
      AADD(aDbf,{"CIDADE2"  ,"C",   15,0})
      AADD(aDbf,{"UF2"      ,"C",   02,0})
      AADD(aDbf,{"CEP2"     ,"C",   08,0})
      AADD(aDbf,{"CNPJ2"    ,"C",   14,0})
      AADD(aDbf,{"FONE3"    ,"C",   12,0})
      AADD(aDbf,{"FONE4"    ,"C",   12,0})
      AADD(aDbf,{"FAX2"     ,"C",   12,0})
      AADD(aDbf,{"CONTATO2" ,"C",   25,0}) /* Contato Cobran‡a            */
      AADD(aDbf,{"CELULAR2" ,"C",   09,0})
      Mensagem("Criando o Cadastro de Fornecedores...")
      DBCREATE("DBFORN.DBF",aDbf)
   ENDIF

   // Arquivo Horas Extras de Instrutor
   IF !FILE("DBEXTRA.DBF")
      aDbf := {}
      AADD(aDbf,{"CODINST","C", 04,0}) /* C¢d.Instrutor     */
      AADD(aDbf,{"ALUNO"  ,"C", 50,0}) /* Nome do Aluno     */
      AADD(aDbf,{"DATA"   ,"D", 08,0}) /* Data da Aula      */
      AADD(aDbf,{"HORA"   ,"C", 02,0}) /* Hora Prevista     */
      Mensagem("Criando o Cadastro de Horas Extras...")
      DBCREATE("DBEXTRA.DBF",aDbf)
   ENDIF

   // Cadastro de Resultados de Exames
   IF !FILE("DBRES.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno */
      AADD(aDbf,{"EXAME"     , "C", 01,0})  /* Tipo do Exame L=legislacao e P=pratico */
      AADD(aDbf,{"CATEG"     , "C", 01,0})  /* Categoria */
      AADD(aDbf,{"RENACH"    , "C", 12,0})  /* numero do RENACH */
      AADD(aDbf,{"DATA"      , "D", 08,0})  /* Data do Exame */
      AADD(aDbf,{"HORA"      , "C", 04,0})  /* Hora do Exame */
      AADD(aDbf,{"RESULTADO" , "C", 01,0})  /* Resultado do Exame A=Apto I=Inapto */
      AADD(aDbf,{"TIPO"      , "C", 01,0})  /* Tipo do Lancamento E=Exame R=Reforco */
      AADD(aDbf,{"OBS"       , "C", 50,0})  /* Observacoes */
      AADD(aDbf,{"DATALAN"   , "D", 08,0})  /* Data do Registro */
      AADD(aDbf,{"USER"      , "C", 20,0})  /* Operador */
      Mensagem("Criando Resultados de Exames...")
      DBCREATE("DBRES",aDbf)
   ENDIF

   // Cadastro de Entrega de LADVs
   IF !FILE("DBLADV.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno */
      AADD(aDbf,{"NUM"       , "C", 08,0})  /* NUmero da LADV */
      AADD(aDbf,{"EMISSAO"   , "D", 08,0})  /* Data da Emissao */
      AADD(aDbf,{"CODINST"   , "C", 04,0})  /* Codigo do Instrutor */
      AADD(aDbf,{"LIVRO"     , "C", 04,0})
      AADD(aDbf,{"PAGINA"    , "C", 02,0})
      AADD(aDbf,{"ENTREGA"   , "D", 08,0})  /* Data da entrega do LADV */
      AADD(aDbf,{"SIT"       , "C", 06,0})  /* Situacao da LADV */
      AADD(aDbf,{"OBS"       , "C", 50,0})  /* Observacoes */
      AADD(aDbf,{"USER"      , "C", 20,0})  /* Operador */
      Mensagem("Criando Dados de LADV...")
      DBCREATE("DBLADV",aDbf)
   ENDIF

   // Cadastro de Conteudo Pratico
   IF !FILE("DBCP.DBF")
      aDbf := {}
      AADD(aDbf,{"AULA"      , "C", 02,0})  /* Numero da Aula        */
      AADD(aDbf,{"CATEG"     , "C", 01,0})  /* Categoria do Veiculo  */
      AADD(aDbf,{"CP"        , "C", 70,0})  /* Conteudo da Aula      */
      Mensagem("Criando Dados de Conteudo Pratico...")
      DBCREATE("DBCP",aDbf)
   ENDIF

   // Cadastro de Pendencias de alunos
   IF !FILE("DBPEND.DBF")
      aDbf := {}
      AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula */
      AADD(aDbf,{"HREG"      , "C", 04,0})  /* Hora do registro */
      AADD(aDbf,{"DTREG"     , "D", 08,0})  /* Data do Registro */
      AADD(aDbf,{"DTOK"      , "D", 08,0})  /* Data da Baixa */
      AADD(aDbf,{"DESCR1"    , "C", 60,0})  /* Descricao da Pendencia 1 */
      AADD(aDbf,{"DESCR2"    , "C", 60,0})  /* Descricao da Pendencia 2 */
      AADD(aDbf,{"DESCR3"    , "C", 60,0})  /* Descricao da Pendencia 3 */
      AADD(aDbf,{"BAIXA"     , "L", 01,0})  /* Condicao da baixa */
      AADD(aDbf,{"USER"      , "C", 20,0})  /* Operador */
      Mensagem("Criando Dados de Conteudo Pratico...")
      DBCREATE("DBPEND",aDbf)
   ENDIF

   // Arquivo de Requerimento de Alunos
   IF !FILE("DBREQ.DBF")
      aDbf := {}
      AADD(aDbf,{"REQ"        ,"C",   07,0}) /* Numero do Requerimento   */
      AADD(aDbf,{"DATA"       ,"D",   08,0}) /* Data do Requerimento     */
      AADD(aDbf,{"HORA"       ,"C",   04,0}) /* Hora do requerimento     */
      AADD(aDbf,{"USER"       ,"C",   20,0}) /* Atendente                */
      AADD(aDbf,{"PRAZO"      ,"D",   08,0}) /* Data para providencia    */
      AADD(aDbf,{"MATRIC"     ,"C",   05,0}) /* Matricula do Aluno       */
      AADD(aDbf,{"NOME"       ,"C",   40,0}) /* Nome do requerente       */
      AADD(aDbf,{"ASS1"       ,"C",   70,0}) /* Assunto                  */
      AADD(aDbf,{"ASS2"       ,"C",   70,0}) /* Assunto                  */
      AADD(aDbf,{"ASS3"       ,"C",   70,0}) /* Assunto                  */
      AADD(aDbf,{"RECOM1"     ,"C",   70,0}) /* Recomeda‡Æo              */
      AADD(aDbf,{"RECOM2"     ,"C",   70,0}) /* Recomeda‡Æo              */
      AADD(aDbf,{"SITUACAO"   ,"C",   01,0}) /* 1-Resolvido 2-nao resolvido 3-Pendente */
      AADD(aDbf,{"SETOR1"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
      AADD(aDbf,{"SETOR2"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
      AADD(aDbf,{"SETOR3"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
      Mensagem("Criando o Cadastro de Requerimento...")
      DBCREATE("DBREQ.DBF",aDbf)
   ENDIF

   // Arquivo de Requerimento - Detalhes
   IF !FILE("DBREQD.DBF")
      aDbf := {}
      AADD(aDbf,{"REQ"        ,"C",   07,0}) /* Numero do Requerimento    */
      AADD(aDbf,{"DATA"       ,"D",   08,0}) /* Data do Retorno           */
      AADD(aDbf,{"HORA"       ,"C",   04,0}) /* Hora do Retorno           */
      AADD(aDbf,{"USER"       ,"C",   20,0}) /* Atendente                 */
      AADD(aDbf,{"PRAZO"      ,"D",   08,0}) /* Prazo da ultima provid.   */
      AADD(aDbf,{"RESULT1"    ,"C",   70,0}) /* Resultado                 */
      AADD(aDbf,{"RESULT2"    ,"C",   70,0})
      AADD(aDbf,{"RESULT3"    ,"C",   70,0})
      AADD(aDbf,{"SETOR"      ,"C",   01,0}) /* Setor encaminhou/resolveu */
      AADD(aDbf,{"ENCAM1"     ,"C",   01,0}) /* Setor de encaminhamento   */
      AADD(aDbf,{"ENCAM2"     ,"C",   01,0})
      AADD(aDbf,{"ENCAM3"     ,"C",   01,0})
      Mensagem("Criando o Cadastro de Requerimento - Detalhes...")
      DBCREATE("DBREQD.DBF",aDbf)
   ENDIF

   Mensagem()
   OrgNtx()
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Organizar Indices            ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE OrgNtx()
   LOCAL nFalta := nTermom := 0 , aDbf
   // Arquivos Indices
   aArq_Ntx := { "HLP", "DBIALU1", "DBIALU2", "DBIALU3", "DBIALU4",;
                        "DBINST1", "DBINST2",;
                        "DBIVEI1", "DBIVEI2" ,"DBIVEI3",;
                        "DBICAT1",;
                        "DBIBCO1",;
                        "DBIACC1",;
                        "DBIFER1", "DBIFAL1",;
                        "DBIAVA1", "DBIAVA2",;
                        "DBIFOR1", "DBIFOR2",;
                        "DBICUR1",;
                        "DBIDISC1",;
                        "DBIESCA1",;
                        "DBISALA1",;
                        "DBITURM1","DBITURM2","DBITURM3",;
                        "DBIGRAD1",;
                        "DBIFREQ1","DBIFREQ2","DBIFREQ3",;
                        "DBIPRO1", "DBIPRO2", "DBIPRO3", "DBIPRO4",;
                        "DBIDES1", "DBIDES2", "DBIDES3", "DBIDES4",;
                        "DBIREQ1", "DBIREQ2", "DBIREQ3", "DBIREQ4",;
                        "DBIREQD1",;
                        "DBIPEND1",;
                        "DBIEXT1" ,;
                        "DBIRES1", "DBIRES2",;
                        "DBILADV1",;
                        "DBICERT1","DBICERT2","DBICER01","DBICER02","DBICER03",;
                        "DBITEM1", "DBITEM2",;
                        "DBIPREC1","DBIPREC2",;
                        "DBIPLAN1","DBIPLAN2",;
                        "DBIPAG1", "DBIPAG2", "DBIPAG3", "DBIPAG4",;
                        "DBIBCC1",;
                        "DBIMOVB1","DBIMOVB2","DBIMOVB3","DBIMOVB4","DBIMOVB5",;
                        "DBIPG1"  ,"DBIPG2",  "DBIPG3",  "DBIPG4",  "DBIPG5",;
                        "DBICON1", "DBICON2", "DBIRCON1","DBIRCON2","DBILCON1",;
                        "DBILCON2","DBILCON3",;
                        "DBICX1",  "DBICX2",  "DBICX3",  "DBICX4",;
                        "DBISD1",;
                        "DBIEXAM1","DBIEXAM2","DBIEXAM3","DBIEXAM4",;
                        "DBICP1"  ,"DBICP2"}

   FOR i = 1 TO LEN(aArq_Ntx)
       IF !FILE(aArq_Ntx[i]+".NTX")
          nFalta++
       ENDIF
   NEXT

   IF nFalta > 0
      tela2 := SAVESCREEN(2,0,22,79)
      Termom("Criando os Indices dos Arquivos",0,nFalta)

      IF !FILE("HLP.NTX")
         nTermom++
         IF NetUse("HELP.HLP","HELP","E")
            INDEX ON codigo + subcodigo TO HLP
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIALU1.NTX")
         nTermom++
         IF NetUse("DBALU",,"E")
            INDEX ON matric TO DBIALU1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIALU2.NTX")
         nTermom++
         IF NetUse("DBALU",,"E")
            INDEX ON nome TO DBIALU2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIALU3.NTX")
         nTermom++
         IF NetUse("DBALU",,"E")
            INDEX ON DTOS(dtinscr) TO DBIALU3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIALU4.NTX")
         nTermom++
         IF NetUse("DBALU",,"E")
            INDEX ON CPF TO DBIALU4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBINST1.NTX")
         nTermom++
         IF NetUse("DBINST",,"E")
            INDEX ON codinst TO DBINST1
            Termom("",nTermom,nFalta)
          ENDIF
      ENDIF
      IF !FILE("DBINST2.NTX")
         nTermom++
         IF NetUse("DBINST",,"E")
            INDEX ON nome TO DBINST2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      ************************************************************
      IF !FILE("DBICUR1.NTX")
         nTermom++
         IF NetUse("DBCURSO",,"E")
            INDEX ON codcur TO DBICUR1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIDISC1.NTX")
         nTermom++
         IF NetUse("DBDISC",,"E")
            INDEX ON codcur+coddis TO DBIDISC1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIESCA1.NTX")
         nTermom++
         IF NetUse("DBESCA",,"E")
            INDEX ON escala TO DBIESCA1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBISALA1.NTX")
         nTermom++
         IF NetUse("DBSALA",,"E")
            INDEX ON sala TO DBISALA1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBITURM1.NTX")
         nTermom++
         IF NetUse("DBTURMA",,"E")
            INDEX ON turno+turma TO DBITURM1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBITURM2.NTX")
         nTermom++
         IF NetUse("DBTURMA",,"E")
            INDEX ON turno+nturma TO DBITURM2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBITURM3.NTX")
         nTermom++
         IF NetUse("DBTURMA",,"E")
            INDEX ON DTOS(dtinic) TO DBITURM3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIGRAD1.NTX")
         nTermom++
         IF NetUse("DBGRADE",,"E")
            INDEX ON codgra+codcur+ndia+naula+coddis TO DBIGRAD1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIFREQ1.NTX")
         nTermom++
         IF NetUse("DBFREQ",,"E")
            INDEX ON matric+DTOS(data)+codcur+naula TO DBIFREQ1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIFREQ2.NTX")
         nTermom++
         IF NetUse("DBFREQ",,"E")
            INDEX ON matric+codcur+naula+coddis TO DBIFREQ2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIFREQ3.NTX")
         nTermom++
         IF NetUse("DBFREQ",,"E")
            INDEX ON nturma+matric+naula TO DBIFREQ3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      ****************************************************
      IF !FILE("DBIBCO1.NTX")
         nTermom++
         IF NetUse("DBBCO",,"E")
            INDEX ON codbco TO DBIBCO1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIACC1.NTX")
         nTermom++
         IF NetUse("DBACC",,"E")
            INDEX ON codcard TO DBIACC1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIVEI1.NTX")
         nTermom++
         IF NetUse("DBVEIC",,"E")
            INDEX ON codveic TO DBIVEI1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIVEI2.NTX")
         nTermom++
         IF NetUse("DBVEIC",,"E")
            INDEX ON codinst TO DBIVEI2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIVEI3.NTX")
         nTermom++
         IF NetUse("DBVEIC",,"E")
            INDEX ON nome TO DBIVEI3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBICAT1.NTX")
         nTermom++
         IF NetUse("DBCATEG",,"E")
            INDEX ON idcat TO DBICAT1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPAG1.NTX")
         nTermom++
         IF NetUse("DBPAG",,"E")
            INDEX ON matric+parcela+DTOS(dtvcto) TO DBIPAG1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPAG2.NTX")
         nTermom++
         IF NetUse("DBPAG",,"E")
            INDEX ON DTOS(dtvcto)+matric TO DBIPAG2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPAG3.NTX")
         nTermom++
         IF NetUse("DBPAG",,"E")
            INDEX ON DTOS(dtpgto) TO DBIPAG3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPAG4.NTX")
         nTermom++
         IF NetUse("DBPAG",,"E")
            INDEX ON NLAN TO DBIPAG4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPRO1.NTX")
         nTermom++
         IF NetUse("DBPROG",,"E")
            INDEX ON matric+DTOS(data)+hora+embarq TO DBIPRO1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPRO2.NTX")
         nTermom++
         IF NetUse("DBPROG",,"E")
            INDEX ON codinst+DTOS(data)+hora+embarq TO DBIPRO2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPRO3.NTX")
         nTermom++
         IF NetUse("DBPROG",,"E")
            INDEX ON codveic+DTOS(data)+hora+embarq TO DBIPRO3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPRO4.NTX")
         nTermom++
         IF NetUse("DBPROG",,"E")
            INDEX ON DTOS(data)+hora+codinst TO DBIPRO4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIDES1.NTX")
         nTermom++
         IF NetUse("DBDESM",,"E")
            INDEX ON matric+DTOS(data)+hora TO DBIDES1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIDES2.NTX")
         nTermom++
         IF NetUse("DBDESM",,"E")
            INDEX ON codinst+DTOS(data)+hora TO DBIDES2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIDES3.NTX")
         nTermom++
         IF NetUse("DBDESM",,"E")
            INDEX ON codveic+DTOS(data)+hora TO DBIDES3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIDES4.NTX")
         nTermom++
         IF NetUse("DBDESM",,"E")
            INDEX ON matric+protocolo TO DBIDES4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIFER1.NTX")
         nTermom++
         IF NetUse("DBFERI",,"E")
            INDEX ON diames TO DBIFER1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIFAL1.NTX")
         nTermom++
         IF NetUse("DBFALT",,"E")
            INDEX ON grau+item TO DBIFAL1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIAVA1.NTX")
         nTermom++
         IF NetUse("DBAVAL",,"E")
            INDEX ON DTOS(data) TO DBIAVA1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIAVA2.NTX")
         nTermom++
         IF NetUse("DBAVAL",,"E")
            INDEX ON matric TO DBIAVA2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIBCC1.NTX")
         nTermom++
         IF NetUse("DBBANCO",,"E")
            INDEX ON conta TO DBIBCC1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIMOVB1.NTX")
         nTermom++
         IF NetUse("DBMOVBCO",,"E")
            INDEX ON CONTA+NUMDOC+DESCEND(DTOS(DATMOV)) TO DBIMOVB1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIMOVB2.NTX")
         nTermom++
         IF NetUse("DBMOVBCO",,"E")
            INDEX ON CONTA+ITEM_CX+DTOS(DATMOV) TO DBIMOVB2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIMOVB3.NTX")
         nTermom++
         IF NetUse("DBMOVBCO",,"E")
            INDEX ON CONTA+TIPOLAN+DTOS(DATMOV) TO DBIMOVB3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIMOVB4.NTX")
         nTermom++
         IF NetUse("DBMOVBCO",,"E")
            INDEX ON CONTA+DESCEND(DTOS(DATMOV)) TO DBIMOVB4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIMOVB5.NTX")
         nTermom++
         IF NetUse("DBMOVBCO",,"E")
            INDEX ON CONTA+DESCEND(DTOS(DATDOC)) TO DBIMOVB5
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBITEM1.NTX")
         nTermom++
         IF NetUse("DBITEM",,"E")
            INDEX ON item_cx TO DBITEM1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBITEM2.NTX")
         nTermom++
         IF NetUse("DBITEM",,"E")
            INDEX ON descr TO DBITEM2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPG1.NTX")
         nTermom++
         IF NetUse("DBPAGA",,"E")
            INDEX ON item_cx+cod_cf+DTOS(dtapag)+DTOS(dtpag) TO DBIPG1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPG2.NTX")
         nTermom++
         IF NetUse("DBPAGA",,"E")
            INDEX ON DTOS(dtapag) TO DBIPG2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPG3.NTX")
         nTermom++
         IF NetUse("DBPAGA",,"E")
            INDEX ON cod_cf+ndoc+nf TO DBIPG3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPG4.NTX")
         nTermom++
         IF NetUse("DBPAGA",,"E")
            INDEX ON cod_cf+DTOS(dtpag) TO DBIPG4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPG5.NTX")
         nTermom++
         IF NetUse("DBPAGA",,"E")
            INDEX ON DTOS(dtpag)+DTOS(dtapag) TO DBIPG5
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIFOR1.NTX")
         nTermom++
         IF NetUse("DBFORN",,"E")
            INDEX ON codfor TO DBIFOR1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIFOR2.NTX")
         nTermom++
         IF NetUse("DBFORN",,"E")
            INDEX ON nome TO DBIFOR2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBICON1.NTX")
         nTermom++
         IF NetUse("DBTCON",,"E")
            INDEX ON tipocon TO DBICON1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICON2.NTX")
         nTermom++
         IF NetUse("DBTCON",,"E")
            INDEX ON descr TO DBICON2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIRCON1.NTX")
         nTermom++
         IF NetUse("DBRCON",,"E")
            INDEX ON codveic+codcon+mesano TO DBIRCON1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIRCON2.NTX")
         nTermom++
         IF NetUse("DBRCON",,"E")
            INDEX ON mesano+codveic+codcon TO DBIRCON2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBILCON1.NTX")
         nTermom++
         IF NetUse("DBLCON",,"E")
            INDEX ON codveic+DTOS(datacon)+codcon TO DBILCON1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBILCON2.NTX")
         nTermom++
         IF NetUse("DBLCON",,"E")
            INDEX ON DTOS(datacon)+codveic+codcon TO DBILCON2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBILCON3.NTX")
         nTermom++
         IF NetUse("DBLCON",,"E")
            INDEX ON codcon TO DBILCON3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPREC1.NTX")
         nTermom++
         IF NetUse("DBPRECO",,"E")
            INDEX ON codserv TO DBIPREC1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPREC2.NTX")
         nTermom++
         IF NetUse("DBPRECO",,"E")
            INDEX ON descr TO DBIPREC2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPLAN1.NTX")
         nTermom++
         IF NetUse("DBPLANO",,"E")
            INDEX ON conta TO DBIPLAN1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIPLAN2.NTX")
         nTermom++
         IF NetUse("DBPLANO",,"E")
            INDEX ON descr TO DBIPLAN2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBICX1.NTX")
         nTermom++
         IF NetUse("DBCX",,"E")
            INDEX ON DTOS(DTMOV)+tipo TO DBICX1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICX2.NTX")
         nTermom++
         IF NetUse("DBCX",,"E")
            INDEX ON matric+tipo+DTOS(dtmov) TO DBICX2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICX3.NTX")
         nTermom++
         IF NetUse("DBCX",,"E")
            INDEX ON nlan TO DBICX3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICX4.NTX")
         nTermom++
         IF NetUse("DBCX",,"E")
            INDEX ON item_cx+DTOS(dtmov) TO DBICX4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBISD1.NTX")
         nTermom++
         IF NetUse("DBSD",,"E")
            INDEX ON DTOS(DATA) TO DBISD1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIEXAM1.NTX")
         nTermom++
         IF NetUse("DBEXAM",,"E")
            INDEX ON matric+DTOS(dtexame) TO DBIEXAM1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIEXAM2.NTX")
         nTermom++
         IF NetUse("DBEXAM",,"E")
            INDEX ON DTOS(dtexame)+hora+nome TO DBIEXAM2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIEXAM3.NTX")
         nTermom++
         IF NetUse("DBEXAM",,"E")
            INDEX ON nome+DTOS(dtexame) TO DBIEXAM3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIEXAM4.NTX")
         nTermom++
         IF NetUse("DBEXAM",,"E")
            INDEX ON DTOS(dtexame)+hora+nome TO DBIEXAM4 DESCEND
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIEXT1.NTX")
         nTermom++
         IF NetUse("DBEXTRA",,"E")
            INDEX ON codinst+DTOS(data) TO DBIEXT1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIRES1.NTX")
         nTermom++
         IF NetUse("DBRES",,"E")
            INDEX ON matric+exame+categ+DTOS(data) TO DBIRES1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIRES2.NTX")
         nTermom++
         IF NetUse("DBRES",,"E")
            INDEX ON exame+DTOS(data) TO DBIRES2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBILADV1.NTX")
         nTermom++
         IF NetUse("DBLADV",,"E")
            INDEX ON matric+DTOS(emissao) TO DBILADV1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBICERT1.NTX")
         nTermom++
         IF NetUse("DBCERT",,"E")
            INDEX ON matric TO DBICERT1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICERT2.NTX")
         nTermom++
         IF NetUse("DBCERT",,"E")
            INDEX ON nome TO DBICERT2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICER01.NTX")
         nTermom++
         IF NetUse("DBCERT",,"E")
            INDEX ON certif1 TO DBICER01
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICER02.NTX")
         nTermom++
         IF NetUse("DBCERT",,"E")
            INDEX ON certif2 TO DBICER02
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICER03.NTX")
         nTermom++
         IF NetUse("DBCERT",,"E")
            INDEX ON certif3 TO DBICER03
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBICP1.NTX")
         nTermom++
         IF NetUse("DBCP",,"E")
            INDEX ON aula+categ TO DBICP1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBICP2.NTX")
         nTermom++
         IF NetUse("DBCP",,"E")
            INDEX ON categ+aula TO DBICP2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIPEND1.NTX")
         nTermom++
         IF NetUse("DBPEND",,"E")
            INDEX ON matric+DTOS(dtreg)+hreg TO DBIPEND1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIREQ1.NTX")
         nTermom++
         IF NetUse("DBREQ",,"E")
            INDEX ON matric+DTOS(data)+hora TO DBIREQ1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIREQ2.NTX")
         nTermom++
         IF NetUse("DBREQ",,"E")
            INDEX ON nome TO DBIREQ2
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIREQ3.NTX")
         nTermom++
         IF NetUse("DBREQ",,"E")
            INDEX ON situacao+DTOS(data)+hora TO DBIREQ3
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF
      IF !FILE("DBIREQ4.NTX")
         nTermom++
         IF NetUse("DBREQ",,"E")
            INDEX ON req TO DBIREQ4
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      IF !FILE("DBIREQD1.NTX")
         nTermom++
         IF NetUse("DBREQD",,"E")
            INDEX ON req+DTOS(data)+hora TO DBIREQD1
            Termom("",nTermom,nFalta)
         ENDIF
      ENDIF

      INKEY(.5)
      RESTSCREEN(2,0,22,79,tela2)
      DBCLOSEALL()
      WaitMsg("Opera‡Æo Efetuada com Sucesso..")
   ENDIF
   RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Cria‡Æo Arq. de Sistema      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE GeraSys()
   IF !FILE("USUARIO.SYS")
      aDbf := {}
      AADD(aDbf,{"USUARIO" , "C", 30,0 })
      AADD(aDbf,{"CHAVE"   , "C", 04,0 })
      AADD(aDbf,{"SENHA"   , "C", 06,0 })
      AADD(aDbf,{"NIVEL",    "N", 01,0 })
      AADD(aDbf,{"REG_DEL" , "N", 02,0 })
      AADD(aDbf,{"REGISTRO", "C", 30,0 })
      DBCREATE("USUARIO.SYS",aDbf)
      IF NetUse("USUARIO.SYS","USER")
         IF NetApp()
            _FIELD->USUARIO := "VIRTUAL"
            _FIELD->CHAVE   := "VSYS"
            _FIELD->SENHA   := Codifica("FASTER")
            _FIELD->NIVEL   := 9
            _FIELD->REG_DEL := 0
            _FIELD->REGISTRO:= "MATRIZ"
            UNLOCK
         ENDIF
      ENDIF
   ENDIF
   IF !FILE("USUARIO.NTX")
      IF NetUse("USUARIO.SYS","USER")
         INDEX ON chave TO USUARIO
      ENDIF
   ENDIF
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Cria‡Æo Arq. de Configura‡Æo ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE GeraConfig()
   LOCAL aDbf := {}

   IF !FILE("SCE.CFG")
      AADD( aDbf,{ "CORGERAL"  , "C", 30, 0 } )
      AADD( aDbf,{ "COREDIT"   , "C", 30, 0 } )
      AADD( aDbf,{ "CORMENU"   , "C", 30, 0 } )
      AADD( aDbf,{ "CORAVISO"  , "C", 30, 0 } )
      AADD( aDbf,{ "CORBARRA"  , "C", 30, 0 } )
      AADD( aDbf,{ "CORREALCE" , "C", 30, 0 } )
      AADD( aDbf,{ "CORTECLAS" , "C", 30, 0 } )
      AADD( aDbf,{ "IMPRESSORA", "C", 20, 0 } )
      AADD( aDbf,{ "EXPANDON"  , "C", 40, 0 } )
      AADD( aDbf,{ "EXPANDOFF" , "C", 40, 0 } )
      AADD( aDbf,{ "COMPR_ON"  , "C", 40, 0 } )
      AADD( aDbf,{ "COMPR_OFF" , "C", 40, 0 } )
      AADD( aDbf,{ "EXPAND_MED", "C", 40, 0 } )
      AADD( aDbf,{ "USB"       , "C", 01, 0 } )
      DBCREATE("SCE.CFG",aDbf)
      IF NetUse("SCE.CFG","SCECFG")
         IF NetApp()
            REPLACE _FIELD->CORGERAL   WITH "BG /B  ",;
                    _FIELD->COREDIT    WITH "N  /BG ,N  /W  ,,,N  /BG ",;
                    _FIELD->CORMENU    WITH "N  /BG ,N  /W  ",;
                    _FIELD->CORAVISO   WITH "W  /R+ ,W  /N  ",;
                    _FIELD->CORBARRA   WITH "N  /W  ",;
                    _FIELD->CORREALCE  WITH "W+ /BG ",;
                    _FIELD->CORTECLAS  WITH "W+ /BG ",;
                    _FIELD->IMPRESSORA WITH "Epson LX/FX/LQ",;
                    _FIELD->EXPANDON   WITH "CHR(14)"    ,;
                    _FIELD->EXPANDOFF  WITH "CHR(20)"    ,;
                    _FIELD->COMPR_ON   WITH "CHR(15)"    ,;
                    _FIELD->COMPR_OFF  WITH "CHR(18)"    ,;
                    _FIELD->EXPAND_MED WITH "CHR(15)+CHR(14)",;
                    _FIELD->USB        WITH "N"
            DBCLOSEAREA()
         ENDIF
         UNLOCK ALL
      ENDIF
   ENDIF
   IF NetUse("SCE.CFG","SCECFG")
      YCORGERAL   := _FIELD->CORGERAL
      YCORMENU    := SUBSTR(_FIELD->CORMENU,1,7)+","+SUBSTR(_FIELD->CORBARRA,1,7)
      YCORBARRA   := _FIELD->CORBARRA
      YCORREALCE  := _FIELD->CORREALCE
      YCOREDIT    := _FIELD->COREDIT
      YCORAVISO   := _FIELD->CORAVISO
      YCORTECLAS  := _FIELD->CORTECLAS
      wImpressora := _FIELD->IMPRESSORA
      wExpandOn   := _FIELD->EXPANDON
      wExpandOff  := _FIELD->EXPANDOFF
      wCompr_On   := _FIELD->COMPR_ON
      wCompr_Off  := _FIELD->COMPR_OFF
      wExpand_Med := _FIELD->EXPAND_MED
      DBCLOSEAREA()
      UNLOCK ALL
   ENDIF
   RETURN
