*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_430                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Manutenฦo dos Arquivos do Sistema       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 03/01/1994                               ณ
*ณ ATUALIZACAO    : 17/12/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

Telas(7,52,10,64,1,YCORMENU,.T.)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"; cOpHelp2 := "30"
   ProgName("AE430"); LinhaMsg(2)

   @ 08,53 PROMPT " Organizar " MESSAGE Msg("Reorganizar Arquivos do Sistema")
   @ 09,53 PROMPT " Compactar " MESSAGE Msg("Eliminar Registros que foram Excluidos")
   MENU TO nMenu_5c

   IF nMenu_5c = 0
      Rest_Tela(); RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_5c = 1
      LimpaLinhaMsg(24)
      IF Acesso(5); OrgArq(); ENDIF
   ELSEIF nMenu_5c = 2
      LimpaLinhaMsg(24)
      IF Acesso(9); CompacArq(); ENDIF
   ENDIF
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Organizar Arquivos           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE OrgArq()
   LOCAL nUser:=37, cTela:=SAVESCREEN(2,0,24,79), cor:=SETCOLOR(), nTermom:=0

   DBCLOSEALL()
   Area_Dados()
   Termom("Organizando os Bancos de Dados",0,nUser)
   Mensagem("Reconstruindo Arquivo de Ajuda...")
   IF NetUse("HELP.HLP","HELP")
      SET INDEX TO HLP
*     REINDEX
      INDEX ON codigo + subcodigo TO HLP
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Senhas...")
   IF NetUse("USUARIO.SYS","USER","E")
      SET INDEX TO USUARIO
      INDEX ON chave TO USUARIO
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Alunos...")
   IF NetUse("DBALU",,"E")
      SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
      INDEX ON matric         TO DBIALU1
      INDEX ON nome           TO DBIALU2
      INDEX ON DTOS(dtinscr)  TO DBIALU3
      INDEX ON CPF            TO DBIALU4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Instrutores...")
   IF NetUse("DBINST",,"E")
      SET INDEX TO DBINST1,DBINST2
      INDEX ON codinst TO DBINST1
      INDEX ON nome    TO DBINST2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Escalas...")
   IF NetUse("DBESCA",,"E")
      SET INDEX TO DBIESCA1
      INDEX ON escala TO DBIESCA1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Turmas...")
   IF NetUse("DBTURMA",,"E")
      SET INDEX TO DBITURM1
      INDEX ON turno+turma  TO DBITURM1
      Termom("",++nTermom,nUser)
   ENDIF
   IF NetUse("DBTURMA",,"E")
      SET INDEX TO DBITURM2
      INDEX ON turno+nturma TO DBITURM2
      Termom("",++nTermom,nUser)
   ENDIF
   IF NetUse("DBTURMA",,"E")
      SET INDEX TO DBITURM3
      INDEX ON turno+nturma TO DBITURM3
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Disciplinas...")
   IF NetUse("DBDISC",,"E")
      SET INDEX TO DBIDISC1
      INDEX ON coddis TO DBIDISC1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Frequencia...")
   IF NetUse("DBFREQ",,"E")
      SET INDEX TO DBIFREQ1,DBIFREQ2,DBIFREQ3
      INDEX ON matric+DTOS(data)+codcur+naula TO DBIFREQ1
      INDEX ON matric+codcur+naula+coddis     TO DBIFREQ2
      INDEX ON nturma+matric+naula            TO DBIFREQ3
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Distribuiฦo...")
   IF NetUse("DBGRADE",,"E")
      SET INDEX TO DBIGRAD1
      INDEX ON codgra+codcur+ndia+naula+coddis TO DBIGRAD1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Veกculos...")
   IF NetUse("DBVEIC",,"E")
      SET INDEX TO DBIVEI1,DBIVEI2
      INDEX ON codveic TO DBIVEI1
      INDEX ON codinst TO DBIVEI2
      INDEX ON nome    TO DBIVEI3
      Termom("",++nTermom,nUser)
   ENDIF

   IF NetUse("DBCATEG",,"E")
      SET INDEX TO DBICAT1
      INDEX ON idcat   TO DBICAT1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Pagamentos...")
   IF NetUse("DBPAG",,"E")
      SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
      INDEX ON matric+parcela+DTOS(dtvcto) TO DBIPAG1
      INDEX ON DTOS(dtvcto)+matric         TO DBIPAG2
      INDEX ON DTOS(dtpgto)                TO DBIPAG3
      INDEX ON NLAN                        TO DBIPAG4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Programaฦo de Aulas...")
   IF NetUse("DBPROG",,"E")
      SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
      INDEX ON matric+DTOS(data)+hora +embarq TO DBIPRO1
      INDEX ON codinst+DTOS(data)+hora+embarq TO DBIPRO2
      INDEX ON codveic+DTOS(data)+hora+embarq TO DBIPRO3
      INDEX ON DTOS(data)+hora+codisnt        TO DBIPRO4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Desmarcaฦo de Aulas...")
   IF NetUse("DBDESM",,"E")
      SET INDEX TO DBIDES1,DBIDES2,DBIDES3,DBIDES4
      INDEX ON matric+DTOS(data)+hora  TO DBIDES1
      INDEX ON codinst+DTOS(data)+hora TO DBIDES2
      INDEX ON codveic+DTOS(data)+hora TO DBIDES3
      INDEX ON matric+protocolo        TO DBIDES4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Feriados...")
   IF NetUse("DBFERI",,"E")
      SET INDEX TO DBIFER1
      INDEX ON DTOS(data) TO DBIFER1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Tabela de Preos...")
   IF NetUse("DBPRECO",,"E")
      SET INDEX TO DBIPREC1,DBIPREC2
      INDEX ON codserv TO DBIPREC1
      INDEX ON descr   TO DBIPREC2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Plano de Contas...")
   IF NetUse("DBPLANO",,"E")
      SET INDEX TO DBIPLAN1,DBIPLAN2
      INDEX ON conta TO DBIPLAN1
      INDEX ON descr TO DBIPLAN2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Tabela de Infraฦo no Trnsito...")
   IF NetUse("DBFALT",,"E")
      SET INDEX TO DBIFAL1
      INDEX ON grau+item TO DBIFAL1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Avaliaฦo do Aluno...")
   IF NetUse("DBAVAL",,"E")
      SET INDEX TO DBIAVA1,DBIAVA2
      INDEX ON DTOS(data) TO DBIAVA1
      INDEX ON matric     TO DBIAVA2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Contas Correntes...")
   IF NetUse("DBBANCO",,"E")
      SET INDEX TO DBIBCC1
      INDEX ON conta TO DBIBCC1
      Termom("",++nTermom,nUser)
   ENDIF
   IF NetUse("DBMOVBCO",,"E")
      SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
      INDEX ON conta+numdoc+DESCEND(DTOS(datmov)) TO DBIMOVB1
      INDEX ON conta+item_cx+DTOS(datmov)  TO DBIMOVB2
      INDEX ON conta+tipolan+DTOS(datmov)  TO DBIMOVB3
      INDEX ON conta+DESCEND(DTOS(datmov)) TO DBIMOVB4
      INDEX ON conta+DESCEND(DTOS(datdoc)) TO DBIMOVB5
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Itens...")
   IF NetUse("DBITEM",,"E")
      SET INDEX TO DBITEM1, DBITEM2
      INDEX ON item_cx TO DBITEM1
      INDEX ON descr   TO DBITEM2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Contas a Pagar...")
   IF NetUse("DBPAGA",,"E")
      SET INDEX TO DBIPG1, DBIPG2, DBIPG3, DBIPG4, DBIPG5
      INDEX ON item_cx+cod_cf+DTOS(dtapag)+DTOS(dtpag) TO DBIPG1
      INDEX ON DTOS(dtapag) TO DBIPG2
      INDEX ON cod_cf+ndoc+nf TO DBIPG3
      INDEX ON cod_cf+DTOS(dtpag) TO DBIPG4
      INDEX ON DTOS(dtpag)+DTOS(dtapag) TO DBIPG5
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Fornecedores...")
   IF NetUse("DBFORN",,"E")
      SET INDEX TO DBIFOR1, DBIFOR2
      INDEX ON codfor TO DBIFOR1
      INDEX ON nome   TO DBIFOR2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo Tabela de Consumos...")
   IF NetUse("DBTCON",,"E")
      SET INDEX TO DBICON1, DBICON2
      INDEX ON tipocon TO DBICON1
      INDEX ON descr   TO DBICON2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo Resumo de Consumos...")
   IF NetUse("DBRCON",,"E")
      SET INDEX TO DBIRCON1,DBIRCON2
      INDEX ON codveic+codcon+mesano TO DBIRCON1
      INDEX ON mesano+codveic+codcon TO DBIRCON2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo Lanamento de Consumos...")
   IF NetUse("DBLCON",,"E")
      SET INDEX TO DBILCON1, DBILCON2, DBILCON3
      INDEX ON codveic+DTOS(datacon)+codcon TO DBILCON1
      INDEX ON DTOS(datacon)+codveic+codcon TO DBILCON2
      INDEX ON codcon                       TO DBILCON3
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Caixa...")
   IF NetUse("DBCX",,"E")
      SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
      INDEX ON DTOS(dtmov)+tipo        TO DBICX1
      INDEX ON matric+tipo+DTOS(dtmov) TO DBICX2
      INDEX ON nlan                    TO DBICX3
      INDEX ON item_cx+DTOS(dtmov)     TO DBICX4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Saldo...")
   IF NetUse("DBSD",,"E")
      SET INDEX TO DBISD
      INDEX ON DTOS(DATA) TO DBISD1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Horas Extra...")
   IF NetUse("DBEXTRA",,"E")
      SET INDEX TO DBIEXT1
      INDEX ON codinst+DTOS(data) TO DBIEXT1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Resumos...")
   IF NetUse("DBRES",,"E")
      SET INDEX TO DBIRES1,DBIRES2
      INDEX ON matric+exame+categ+DTOS(data) TO DBIRES1
      INDEX ON exame+DTOS(data) TO DBIRES2
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de LADVs...")
   IF NetUse("DBLADV",,"E")
      SET INDEX TO DBILADV1
      INDEX ON matric+DTOS(emissao) TO DBILADV1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Certificados...")
   IF NetUse("DBCERT",,"E")
      SET INDEX TO DBICERT1,DBICERT2,DBICER01,DBICER02,DBICER03
      INDEX ON matric  TO DBICERT1
      INDEX ON nome    TO DBICERT2
      INDEX ON certif1 TO DBICER01
      INDEX ON certif2 TO DBICER02
      INDEX ON certif3 TO DBICER03
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Pendncias...")
   IF NetUse("DBPEND",,"E")
      SET INDEX TO DBIPEND1
      INDEX ON matric+DTOS(dtreg)+hreg TO DBIPEND1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Arquivo de Requerimentos...")
   IF NetUse("DBREQ",,"E")
      SET INDEX TO DBIREQ1,DBIREQ2,DBIREQ3,DBIREQ4
      INDEX ON matric+DTOS(data)+hora   TO DBIREQ1
      INDEX ON nome                     TO DBIREQ2
      INDEX ON situacao+DTOS(data)+hora TO DBIREQ3
      INDEX ON req                      TO DBIREQ4
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Detalhes de Requerimento...")
   IF NetUse("DBREQ",,"E")
      SET INDEX TO DBIREQD1
      INDEX ON req+DTOS(data)+hora TO DBIREQD1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Cadastro de Contas Correntes...")
   IF NetUse("DBBANCO",,"E")
      SET INDEX TO DBIBCC1
      INDEX ON conta TO DBIBCC1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Cadastro de Bancos...")
   IF NetUse("DBBCO",,"E")
      SET INDEX TO DBIBCO1
      INDEX ON codbco TO DBIBCO1
      Termom("",++nTermom,nUser)
   ENDIF

   Mensagem("Reconstruindo Cadastro de Adm.Cartไes Crdito...")
   IF NetUse("DBACC",,"E")
      SET INDEX TO DBIACC1
      INDEX ON codcard TO DBIACC1
      Termom("",++nTermom,nUser)
   ENDIF

   WaitMsg("Organizaฦo Efetuada com Sucesso...")
   RESTSCREEN(2,0,24,79,cTela)
   SETCOLOR(cor); DBCLOSEALL()
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Compactar Arquivos           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE CompacArq()
   LOCAL nUser:= 33, cTela := SAVESCREEN(2,0,24,79), cor := SETCOLOR()

   DBCLOSEALL()
   Area_Dados()
   Termom("Compactando os Bancos de Dados",0,nUser)

   Mensagem("Compactando o Arquivo de Alunos...")
   IF NetUse("DBALU",,"E")
      SET INDEX TO DBIALU1,DBIALU2,DBIALU3.DBIALU4
      PACK
      Termom("",1,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Instrutores...")
   IF NetUse("DBINST",,"E")
      SET INDEX TO DBINST1,DBINST2
      PACK
      Termom("",2,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Veกculos...")
   IF NetUse("DBVEIC",,"E")
      SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
      PACK
      Termom("",3,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Feriados...")
   IF NetUse("DBFERI",,"E")
      SET INDEX TO DBIFER1
      PACK
      Termom("",4,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Pagamentos...")
   IF NetUse("DBPAG",,"E")
      SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
      PACK
      Termom("",5,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Programaฦo de Aulas...")
   IF NetUse("DBPROG",,"E")
      SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
      PACK
      Termom("",6,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Senhas...")
   IF NetUse("USUARIO.SYS","USER","E")
      SET INDEX TO USUARIO
      PACK
      Termom("",7,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Infraไes...")
   IF NetUse("DBFALT",,"E")
      SET INDEX TO DBIFAL1
      PACK
      Termom("",8,nUser)
   ENDIF

   Mensagem("Compactando a Avaliaฦo de Alunos...")
   IF NetUse("DBAVAL",,"E")
      SET INDEX TO DBIAVA1,DBIAVA2
      PACK
      Termom("",9,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Contas Correntes...")
   IF NetUse("DBBANCO",,"E")
      SET INDEX TO DBIBCC1
      PACK
      Termom("",10,nUser)
   ENDIF
   IF NetUse("DBMOVBCO",,"E")
      SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
      PACK
      Termom("",11,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Itens...")
   IF NetUse("DBITEM",,"E")
      SET INDEX TO DBITEM1,DBITEM2
      PACK
      Termom("",12,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Contas a Receber...")
   IF NetUse("DBREC",,"E")
      SET INDEX TO DBIREC1,DBIREC2,DBIREC3,DBIREC4,DBIREC5
      PACK
      Termom("",13,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Contas a Pagar...")
   IF NetUse("DBPAGA",,"E")
      SET INDEX TO DBIPG1,DBIPG2,DBIPG3,DBIPG4,DBIPG5
      PACK
      Termom("",14,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Fornecedores...")
   IF NetUse("DBFORN",,"E")
      SET INDEX TO DBIFOR1,DBIFOR2
      PACK
      Termom("",15,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Consumos...")
   IF NetUse("DBTCON",,"E")
      SET INDEX TO DBICON1,DBICON2
      PACK
      Termom("",16,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Resumos...")
   IF NetUse("DBRCON",,"E")
      SET INDEX TO DBIRCON1,DBIRCON2
      PACK
      Termom("",17,nUser)
   ENDIF


   Mensagem("Compactando o Arquivo de Lanamento de Consumos...")
   IF NetUse("DBLCON",,"E")
      SET INDEX TO DBILCON1,DBILCON2,DBILCON3
      PACK
      Termom("",18,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Caixa...")
   IF NetUse("DBCX",,"E")
      SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
      PACK
      Termom("",19,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Salas...")
   IF NetUse("DBSALA",,"E")
      SET INDEX TO DBISALA1
      PACK
      Termom("",20,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Escalas...")
   IF NetUse("DBESCA",,"E")
      SET INDEX TO DBIESCA1
      PACK
      Termom("",21,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Distribuiฦo...")
   IF NetUse("DBGRADE",,"E")
      SET INDEX TO DBIGRAD1
      PACK
      Termom("",22,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Disciplinas...")
   IF NetUse("DBDISC",,"E")
      SET INDEX TO DBIDISC1
      PACK
      Termom("",23,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Cursos...")
   IF NetUse("DBCUR",,"E")
      SET INDEX TO DBICUR1
      PACK
      Termom("",24,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Turmas...")
   IF NetUse("DBTURMA",,"E")
      SET INDEX TO DBITURM1,DBITURM2,DBITURM3
      PACK
      Termom("",25,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Requerimentos...")
   IF NetUse("DBREQ",,"E")
      SET INDEX TO DBIREQ1,DBIREQ2,DBIREQ3,DBIREQ4,DBIREQ5
      PACK
      Termom("",26,nUser)
   ENDIF

   Mensagem("Compactando Detalhes de Requerimento...")
   IF NetUse("DBREQD",,"E")
      SET INDEX TO DBIREQD1
      PACK
      Termom("",27,nUser)
   ENDIF

   Mensagem("Compactando a Tabela de Preos...")
   IF NetUse("DBPRECO",,"E")
      SET INDEX TO DBIPREC1,DBIPREC2
      PACK
      Termom("",28,nUser)
   ENDIF

   Mensagem("Compactando o Plano de Contas...")
   IF NetUse("DBPLANO",,"E")
      SET INDEX TO DBIPLAN1,DBIPLAN2
      PACK
      Termom("",29,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Categorias...")
   IF NetUse("DBCATEG",,"E")
      SET INDEX TO DBICAT1
      PACK
      Termom("",30,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Bancos...")
   IF NetUse("DBBCO",,"E")
      SET INDEX TO DBIBCO1
      PACK
      Termom("",31,nUser)
   ENDIF

   Mensagem("Compactando o Arquivo de Adm.Cartไes Crdito...")
   IF NetUse("DBACC",,"E")
      SET INDEX TO DBIACC1
      PACK
      Termom("",32,nUser)
   ENDIF

   WaitMsg("Compactaฦo Efetuada com Sucesso...")
   RESTSCREEN(2,0,24,79,cTela)
   SETCOLOR(cor); DBCLOSEALL()
   RETURN
