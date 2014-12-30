*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_211                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Programa‡Æo de Aulas Te¢ricas            ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 07/09/1999                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"
#include "COMMAND.CH"

PROCEDURE AE_211(pCod)
DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno       */
AADD(aDbf,{"CODCUR"    , "C", 02,0})  /* Codigo do curso          */
AADD(aDbf,{"CODDIS"    , "C", 02,0})  /* Codigo de disciplina     */
AADD(aDbf,{"DATA"      , "D", 08,0})  /* Data da aulas            */
AADD(aDbf,{"DISCIPLINA", "C", 30,0})  /* Nome da disciplina       */
AADD(aDbf,{"CODINST"   , "C", 02,0})  /* Codigo de disciplina     */
AADD(aDbf,{"INSTRUTOR" , "C", 50,0})  /* Nome do instrutor        */
AADD(aDbf,{"TURNO"     , "C", 05,0})  /* Turno                    */
AADD(aDbf,{"NTURMA"    , "C", 05,0})  /* Nr da turma              */
AADD(aDbf,{"HORARIO"   , "C", 13,0})  /* Horario da aula          */
AADD(aDbf,{"NAULA"     , "C", 02,0})  /* Numero da aula           */
AADD(aDbf,{"SAULA"     , "C", 03,0})  /* Sequencia da aula        */
AADD(aDbf,{"SIMULADO"  , "C", 01,0})  /* Simulado                 */
AADD(aDbf,{"REALIZ"    , "C", 05,0})  /* Aula Realizada           */
AADD(aDbf,{"DTREP"     , "D", 08,0})  /* Data da reposicao        */
AADD(aDbf,{"USER"      , "C", 25,0})
AADD(aDbf,{"FALTA"     , "C", 01,0})  /* Aula faltada             */
AADD(aDbf,{"PAGO"      , "C", 01,0})  /* Aula de reposicao paga   */
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON naula TO (cArq1)

SELECT 18
IF !NetUse("DBPARM")               /* Parametros */
   DelDbfNtx(); RETURN
ENDIF

SELECT 13
IF NetUse("DBESCA","ESCALA")        /* Escalas */
   SET INDEX TO DBIESCA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 11
IF NetUse("DBSALA","SALA")          /* Salas */
   SET INDEX TO DBISALA1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 8
IF NetUse("DBGRADE","GRADE")       /* Grade Disciplinar */
   SET INDEX TO DBIGRAD1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF NetUse("DBTURMA","TURMA")       /* Turma */
   SET INDEX TO DBITURM1,DBITURM2,DBITURM3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBDISC","DISCIPLINA")   /* Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("DBFERI","FERIADO")      /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBINST","INSTRUTOR")    /* Instrutores */
   SET INDEX TO DBINST2,DBINST1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")         /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBFREQ","FREQUENCIA")   /* Frequencia Aulas Teoricas */
   SET INDEX TO DBIFREQ1,DBIFREQ2,DBIFREQ3
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE211"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "10"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SET KEY -1 TO Mostra()
WHILE .T.
   IF EMPTY(pCod)
      wCod:=DBPARM->MATRIC
   ELSE
      wCod:=pCod
   ENDIF
   xDtInscr:=CTOD("")
   SETCOLOR(YCOREDIT)
   Telas(3,3,5,78,1,YCOREDIT,.T.,"Programa‡Æo de Aulas Te¢ricas")
   Mensagem("Preencha os dados corretamente")
   @ 04,05 SAY "Matr¡cula:" GET wCod PICT "99999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wCod).AND.TDescr(3,1,4,22,wCod,"NOME",["@S40"],"Matr¡cula NÆo Localizada").AND.Let(xDtInscr:=ALUNO->DTINSCR)
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   lMarcou   := .F.
   wMatric   := xMatric := wCod
   wNome     := ALUNO->NOME
   wCPF      := ALUNO->CPF
   wRG       := ALUNO->RG
   Grv_Temp()
   ProgTeorica(); LinhaMsg(2)
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela(LEN(Telas)-2)
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Programa‡Æo Teorica            ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE ProgTeorica()
  LOCAL oBr, oCol
  PUBLIC nSel
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  @ 04,57 SAY "Turno: "+(cArq1)->TURNO
  Telas(5,3,20,78,1,YCOREDIT,.T.)
  Linha23("^ESC^-Retorna  ^ENTER^-Alt.Data Aula ^F7^-Turma ^F8^-Turno ^F9^-Imp.Ficha")

  oBr:=TBROWSEDB(6,4,19,77)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "

  oCol:=TBCOLUMNNEW("Nø"         ,{|| NAULA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Disciplina" ,{|| SAULA+" "+TRANSFORM(DISCIPLINA,"@S25")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aula"       ,{|| REALIZ})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Reposi‡Æo"  ,{|| DTREP})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Operador"   ,{|| USER})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     lRotAut:=.F.
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_ENTER )   /* Alterar Data */
        nReg:=(cArq1)->(RECNO())
        IF (cArq1)->DATA<=cDtSys.OR.nNivel=9  // Liberar para nivel 9
           IF (cArq1)->FALTA#"*"
              IF oBr:colpos==3
                 xVar:=CTOD("")
*                 xVar:=FIELDGET(oBr:colpos)
                 @ ROW(),COL() GET xVar PICT "@D" VALID !EMPTY(xVar)
                 SETCURSOR(1); READ; SETCURSOR(0)
                 IF LASTKEY()#K_ESC.OR.UPDATED()
                    // Alterar na folha de frequencia
                    FREQUENCIA->(DBSEEK(wMatric+DTOS((cArq1)->DATA)+(cArq1)->CODCUR+(cArq1)->NAULA))
                    WHILE !FREQUENCIA->(NetLReg()); ENDDO
                    REPLACE FREQUENCIA->DATA WITH xVar
                    FREQUENCIA->(DBUNLOCK()); FREQUENCIA->(DBCOMMIT())

                    // Alterar no arq. temporario
                    FIELDPUT(oBr:colpos,xVar)
                    REPLACE (cArq1)->USER WITH cUsuario
                 ENDIF
              ENDIF
           ELSE
              Aviso("Aula faltada. NÆo permitida a altera‡Æo!",,3)
           ENDIF
        ELSE
           Aviso("Aula ainda nÆo realizada!",,3)
        ENDIF
        (cArq1)->(DBGOTO(nReg))
        oBr:refreshAll()
     ELSEIF ( tecla == K_F7 )      /* Trocar Turma */
        IF Confirma("Esta opera‡ao elimina programa‡ao anterior")
           FREQUENCIA->(DBSETORDER(1)); FREQUENCIA->(DBSEEK(wCod))
           WHILE FREQUENCIA->MATRIC==wCod.AND.!FREQUENCIA->(EOF())
              WHILE !FREQUENCIA->(NetLReg()); ENDDO
              FREQUENCIA->(DBDELETE())
              FREQUENCIA->(DBSKIP())
           ENDDO
           FREQUENCIA->(DBCOMMIT())

           xTurno:=(cArq1)->TURNO
           IF xTurno="ManhÆ"
              nTurno=1
           ELSEIF xTurno="Tarde"
              nTurno=2
           ELSEIF xTurno="Noite"
              nTurno=3
           ENDIF

           // Repor a vaga da turma
           TURMA->(DBSETORDER(2))
           TURMA->(DBSEEK(xTurno+(cArq1)->NTURMA))
           WHILE !TURMA->(NetLReg()); ENDDO
           REPLACE TURMA->USO_N WITH TURMA->USO_N - 1
           TURMA->(DBUNLOCK())
           TURMA->(DBSETORDER(1))

           (cArq1)->(__DBZAP())
           TelaTurmas(.F.)
           Grv_Temp()
           SELECT (cArq1)
           INDEX ON naula TO (cArq1)
           (cArq1)->(DBGOTOP())
           oBr:refreshAll()
        ENDIF
     ELSEIF ( tecla == K_F8 )      /* Trocar Turno */
        xTurno:=(cArq1)->TURNO
        IF xTurno="ManhÆ"
           nTurno=1
        ELSEIF xTurno="Tarde"
           nTurno=2
        ELSEIF xTurno="Noite"
           nTurno=3
        ENDIF
        Telas(7,9,11,17,1,YCOREDIT,.T.,"Turno")
        @ 08,10 PROMPT " ManhÆ "
        @ 09,10 PROMPT " Tarde "
        @ 10,10 PROMPT " Noite "
        MENU TO nTurno
        Rest_Tela()

        IF nTurno == 0
           LOOP
        ELSEIF nTurno=1
           xTurno:="1"
        ELSEIF nTurno=2
           xTurno:="2"
        ELSEIF nTurno=3
           xTurno:="3"
        ENDIF

        // Alterar na folha de frequencia
        Aguarde("Aguarde...")
        nReg:=(cArq1)->(RECNO()); (cArq1)->(DBGOTOP())
        FREQUENCIA->(DBSEEK(wMatric+DTOS((cArq1)->DATA)+(cArq1)->CODCUR+"01"))
        WHILE FREQUENCIA->MATRIC==wMatric.AND.FREQUENCIA->CODCUR==(cArq1)->CODCUR
           WHILE !FREQUENCIA->(NetLReg()); ENDDO
           REPLACE FREQUENCIA->TURNO WITH xTurno
           FREQUENCIA->(DBUNLOCK()); FREQUENCIA->(DBCOMMIT())
           FREQUENCIA->(DBSKIP())
        ENDDO

        // Alterar no arq. temporario
        IF xTurno="1"
           xTurno="ManhÆ"
        ELSEIF xTurno="2"
           xTurno="Tarde"
        ELSEIF xTurno="3"
           xTurno="Noite"
        ENDIF
        Aguarde()
        @ 04,57 SAY "Turno: "+xTurno
        (cArq1)->(DBGOTO(nReg))
     ELSEIF ( tecla == K_F9 )      /* Imprimir */
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpProgTeo()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de ImpressÆo, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(); RELEASE nSel
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Programa‡Æo do Aluno³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION ImpProgTeo(pVia)
  DEFAULT pVia TO "1"
  Gera_TXT("PRGTEO.TXT"); SETPRC(0,0)
  @ PROW()+1,05 SAY cRazao1
  @ PROW()+1,05 SAY cEnder1+" "+cEnder2
  @ PROW()+2,05 SAY PADC("** FOLHA DE FREQUENCIA DE AULAS TEORICAS **",75)
  Compr_On()
  @ PROW()+1,05 SAY REPLICATE("-",125)
  @ PROW()+1,05 SAY "Aluno...: "+wNome
  @ PROW() ,116 SAY "Matricula: "+wMatric
  @ PROW()+1,05 SAY "Inicio..:  _____/_____/_____   Termino: _____/_____/_____"
  @ PROW()+1,05 SAY "Inicio..:             Turno:         CPF/MF:                 RG:"
  @ PROW()  ,15 SAY DTOC((cArq1)->DATA)
  @ PROW()  ,34 SAY (cArq1)->TURNO
  @ PROW()  ,49 SAY ALUNO->CPF PICT "@R 999.999.999-99"
  @ PROW()  ,69 SAY ALUNO->RG
*  @ PROW()+1,05 SAY "Etiqueta:______________________ Livro: __________   Pagina: ______"
  @ PROW()+1,05 SAY REPLICATE("-",125)
  @ PROW()+1,05 SAY "Nø  Disciplina         Data            Assinatura do Aluno                   Assinatura do Instrutor         Data Reposicao"
*                    99  XXXXXXXXXXxxxxxxxx ___/___/___ XXXXXXXXXX----------XXXXXXXXXX-----   ----------XXXXXXXXXX----------XXXXX ____/____/____
*                    Inicio..: 99/99/9999 Turno: Noite   CPF/MF: 999.999.999-99  RG: 4121464646
*                    567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                         1         2         3         4         5         6         7         8         9        10        11        12        13
  @ PROW()+1,05 SAY REPLICATE("-",125)
  (cArq1)->(DBGOTOP())
  WHILE !(cArq1)->(EOF())
     @ PROW()+1,05 SAY (cArq1)->NAULA
     IF !EMPTY((cArq1)->SIMULADO)
        @ PROW(),08 SAY "*"
     ENDIF
     @ PROW()  ,09 SAY (cArq1)->SAULA+ " "+(cArq1)->DISCIPLINA PICT "@S18"
     @ PROW()  ,28 SAY "___/___/___"
*    @ PROW()  ,32 SAY (cArq1)->DATA       PICT "@D"
*    @ PROW()  ,47 SAY "1"
*    @ PROW()  ,40 SAY (cArq1)->HORARIO
     @ PROW()  ,40 SAY REPL("_",35)
     @ PROW()  ,78 SAY REPL("_",35)
     @ PROW() ,114 SAY "____/____/____"
     (cArq1)->(DBSKIP())
  ENDDO
*  @ PROW()+2,09 SAY "Etiqueta:_________________________ Livro: ______________   Pagina: _________"
  @ PROW()+2,09 SAY "Assinatura Diretora de Ensino: _____________________________________________"
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp PRGTEO.TXT 96 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE PRGTEO.TXT
  RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Gravar arq. temporario       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE Grv_Temp()
   FREQUENCIA->(DBSETORDER(1))
   IF FREQUENCIA->(DBSEEK(wCod))
      WHILE FREQUENCIA->MATRIC==wCod.AND.!FREQUENCIA->(EOF())
         /* Alimentar arq. tempor rio */
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->DATA       WITH FREQUENCIA->DATA      ,;
                 (cArq1)->CODCUR     WITH FREQUENCIA->CODCUR    ,;
                 (cArq1)->CODDIS     WITH FREQUENCIA->CODDIS    ,;
                 (cArq1)->DISCIPLINA WITH PegaDisc(FREQUENCIA->CODCUR+FREQUENCIA->CODDIS),;
                 (cArq1)->CODINST    WITH FREQUENCIA->CODINST   ,;
                 (cArq1)->INSTRUTOR  WITH PegaInst(FREQUENCIA->CODINST),;
                 (cArq1)->HORARIO    WITH FREQUENCIA->HORARIO   ,;
                 (cArq1)->REALIZ     WITH IF(FREQUENCIA->FALTA=="*","Falta",IF(FREQUENCIA->DATA<DATE(),"Ok   ",SPACE(5))),;
                 (cArq1)->SIMULADO   WITH FREQUENCIA->SIMULADO  ,;
                 (cArq1)->NAULA      WITH FREQUENCIA->NAULA     ,;
                 (cArq1)->SAULA      WITH FREQUENCIA->SAULA     ,;
                 (cArq1)->NTURMA     WITH FREQUENCIA->NTURMA    ,;
                 (cArq1)->TURNO      WITH IF(FREQUENCIA->TURNO="1","ManhÆ",IF(FREQUENCIA->TURNO="2","Tarde",IF(FREQUENCIA->TURNO="3","Noite",SPACE(5)))),;
                 (cArq1)->USER       WITH FREQUENCIA->USER
         FREQUENCIA->(DBSKIP())
      ENDDO
   ENDIF
   RETURN
