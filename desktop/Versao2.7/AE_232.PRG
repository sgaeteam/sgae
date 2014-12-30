*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_232                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Lan‡amento de Aulas Teoricas             ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 01/12/2005                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno       */
AADD(aDbf,{"CODCUR"    , "C", 02,0})  /* Codigo do curso          */
AADD(aDbf,{"CODDIS"    , "C", 02,0})  /* Codigo de disciplina     */
AADD(aDbf,{"DISCIPLINA", "C", 30,0})  /* Nome da disciplina       */
AADD(aDbf,{"CODINST"   , "C", 02,0})  /* Codigo de disciplina     */
AADD(aDbf,{"INSTRUTOR" , "C", 50,0})  /* Nome do instrutor        */
AADD(aDbf,{"DATA"      , "D", 08,0})  /* Data da aulas            */
AADD(aDbf,{"TURNO"     , "C", 01,0})  /* Turno                    */
AADD(aDbf,{"HORARIO"   , "C", 13,0})  /* Horario da aula          */
AADD(aDbf,{"NAULA"     , "C", 02,0})  /* Numero da aula           */
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

SELECT 8
IF NetUse("DBCX","CAIXA")          /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 9
IF NetUse("DBPAG","PAGAR")         /* Pagamentos de Alunos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 18
IF !NetUse("DBPARM")               /* Parametros */
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF NetUse("DBTURMA","TURMA")       /* Turma */
   SET INDEX TO DBITURM1
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
IF NetUse("DBFREQ","TEORICA")      /* Frequencia Aulas Teoricas */
   SET INDEX TO DBIFREQ1,DBIFREQ2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE232"; ProgName(cPrg); LinhaMsg(2)
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SET KEY -1 TO Mostra()
WHILE .T.
   wCod:=DBPARM->MATRIC
   xDtInscr:=CTOD("")
   SETCOLOR(YCOREDIT)
   Telas(3,3,5,78,1,YCOREDIT,.T.,"Lan‡amento de Aulas Te¢ricas")
   Mensagem("Preencha os dados corretamente")
   @ 04,05 SAY "Matr¡cula:" GET wCod PICT "99999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wCod).AND.TDescr(3,1,4,22,wCod,"NOME",["@S40"],"Matr¡cula NÆo Localizada").AND.Let(xDtInscr:=ALUNO->DTINSCR)
   @ 04,57 GET xDtInscr PICT "@D" WHEN .F.
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   lMarcou   := .F.
   wMatric   := wCod
   wNome     := ALUNO->NOME
   TEORICA->(DBSETORDER(1))
   IF TEORICA->(DBSEEK(wCod))
      WHILE TEORICA->MATRIC==wCod.AND.!TEORICA->(EOF())
         /* Alimentar arq. tempor rio */
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->MATRIC     WITH TEORICA->MATRIC    ,;
                 (cArq1)->DATA       WITH TEORICA->DATA      ,;
                 (cArq1)->CODCUR     WITH TEORICA->CODCUR    ,;
                 (cArq1)->CODDIS     WITH TEORICA->CODDIS    ,;
                 (cArq1)->DISCIPLINA WITH PegaDisc(TEORICA->CODCUR+TEORICA->CODDIS),;
                 (cArq1)->CODINST    WITH TEORICA->CODINST   ,;
                 (cArq1)->INSTRUTOR  WITH PegaInst(TEORICA->CODINST),;
                 (cArq1)->HORARIO    WITH TEORICA->HORARIO   ,;
                 (cArq1)->SIMULADO   WITH TEORICA->SIMULADO  ,;
                 (cArq1)->DTREP      WITH TEORICA->DTREP     ,;
                 (cArq1)->NAULA      WITH TEORICA->NAULA     ,;
                 (cArq1)->TURNO      WITH IF(TEORICA->TURNO="1","ManhÆ",IF(TEORICA->TURNO="2","Tarde",IF(TEORICA->TURNO="3","Noite",SPACE(5)))),;
                 (cArq1)->FALTA      WITH TEORICA->FALTA     ,;
                 (cArq1)->PAGO       WITH TEORICA->PAGO      ,;
                 (cArq1)->USER       WITH TEORICA->USER
         IF (cArq1)->FALTA=="*"
            REPLACE (cArq1)->REALIZ WITH "Falta"
         ELSE
            IF (cArq1)->DATA<DATE()
               REPLACE (cArq1)->REALIZ WITH "Ok   "
            ENDIF
         ENDIF
         TEORICA->(DBSKIP())
      ENDDO
   ENDIF
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
  Telas(5,3,20,78,1,YCOREDIT,.T.)
  Linha23("Registrar => ^F6^-Falta ^F7^-Pagamento ^F8^-Reposi‡Æo")

  oBr:=TBROWSEDB(6,4,19,77)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "

  oCol:=TBCOLUMNNEW("Nø"         ,{|| NAULA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Disciplina" ,{|| SIMULADO+TRANSFORM(DISCIPLINA,"@S18")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aula"       ,{|| REALIZ})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Reposi‡Æo"  ,{|| DTREP})
  oBr:addColumn(oCol)
  IF nNivel>=5
     oCol:=TBCOLUMNNEW("Pag"     ,{|| PAGO})
     oBr:addColumn(oCol)
     oCol:=TBCOLUMNNEW("Operador",{|| USER})
     oBr:addColumn(oCol)
  ENDIF

  lRotAlt:=lPagou:=.F.
  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF lRotAlt
           IF Confirma("Todas as informa‡äes estÆo corretas ?")
              /* Gravar as Datas */
              Aguarde("Gravando lan‡amentos...")
              (cArq1)->(DBGOTOP())
              TEORICA->(DBSETORDER(2))
              WHILE !(cArq1)->(EOF())
                 TEORICA->(DBSEEK(wCod+(cArq1)->CODCUR+(cArq1)->NAULA))
                 WHILE !TEORICA->(NetLReg()); ENDDO
                 REPLACE TEORICA->FALTA   WITH (cArq1)->FALTA ,;
                         TEORICA->PAGO    WITH IF((cArq1)->PAGO=="P","*",(cArq1)->PAGO),;
                         TEORICA->USER    WITH (cArq1)->USER
                 TEORICA->(DBUNLOCK()); TEORICA->(DBCOMMIT())

                 IF (cArq1)->PAGO=="P".AND.lPagou
                    // Calcular o valor total da reposi‡Æo
                    IF Confirma("Imprime Recibo ?")
                       IF ChkImpr()
                          wNome  := ALUNO->NOME
                          cAviso := MsgImp(.F.)
                          wValor := 25.00
                          wAulast:= 1
                          wAulas := 0
                          RecRep(wCod)
                          WHILE Confirma("Outra C¢pia ?")
                             RecRep(wCod)
                          ENDDO
                          TiraMsgImp(cAviso)
                          WaitMsg("Fim de ImpressÆo, tecle algo...")
                       ENDIF
                    ENDIF

                    // Gravar pagamentos
                    xNLan:=GravaLan()
                    WHILE !CAIXA->(NetApp()); ENDDO
                    REPLACE CAIXA->HIST   WITH "Rep."+ALUNO->NOME  ,;
                            CAIXA->TIPO   WITH "C"                 ,;
                            CAIXA->NLAN   WITH xNlan               ,;
                            CAIXA->DTMOV  WITH cDtSys              ,;
                            CAIXA->DATA   WITH cDtSys              ,;
                            CAIXA->DOC    WITH DBPARM->CR          ,;
                            CAIXA->MATRIC WITH wCod                ,;
                            CAIXA->VALOR  WITH 25.00               ,;
                            CAIXA->OBS1   WITH "PAGAMENTO DE AULA DE REPOSICAO TEORICA",;
                            CAIXA->USER   WITH cUsuario

                    WHILE !PAGAR->(NetApp()); ENDDO
                    REPLACE PAGAR->MATRIC  WITH wCod               ,;
                            PAGAR->PARCELA WITH "01"               ,;
                            PAGAR->DOC     WITH DBPARM->CR         ,;
                            PAGAR->NOME    WITH ALUNO->NOME        ,;
                            PAGAR->DTPGTO  WITH cDtSys             ,;
                            PAGAR->DTVCTO  WITH cDtSys             ,;
                            PAGAR->VALOR_P WITH 25.00              ,;
                            PAGAR->VALOR_D WITH 25.00              ,;
                            PAGAR->NLAN    WITH xNLan              ,;
                            PAGAR->OBS1    WITH "PAGAMENTO DE AULA DE REPOSICAO TEORICA"
                    PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
                 ENDIF
                 (cArq1)->(DBSKIP())
              ENDDO
              Aguarde()
              TEORICA->(DBSETORDER(1))
           ELSE
              Aviso("Os lan‡amentos realizados serÆo cancelados!",,3)
           ENDIF
        ENDIF
        EXIT
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F6 )    // Falta
        nReg:=(cArq1)->(RECNO())
        IF (cArq1)->DATA<=cDtSys
           IF (cArq1)->FALTA="*"
              Aviso("Aula j  registrada como faltada")
           ELSE
              REPLACE (cArq1)->FALTA  WITH "*"      ,;
                      (cArq1)->USER   WITH cUsuario ,;
                      (cArq1)->REALIZ WITH "Falta"
              lRotAlt:=.T.
           ENDIF
        ELSE
           Aviso("Aula ainda nÆo realizada!",,3)
        ENDIF
        (cArq1)->(DBGOTO(nReg))
        oBr:refreshAll()
     ELSEIF ( tecla == K_F7 )    // Pagamento de reposicao
        nReg:=(cArq1)->(RECNO())
        IF (cArq1)->DATA<=cDtSys
           IF (cArq1)->FALTA="*"
              IF (cArq1)->PAGO=="*".OR.(cArq1)->PAGO=="P"
                 Aviso("Aula de reposi‡Æo j  foi paga!",,3)
              ELSE
                 REPLACE (cArq1)->PAGO WITH "P"      ,;
                         (cArq1)->USER WITH cUsuario
                 lPagou:=lRotAlt:=.T.
              ENDIF
           ELSE
              Aviso("Reposi‡Æo somente para aula faltada!",,3)
           ENDIF
        ELSE
           Aviso("Aula ainda nÆo realizada!",,3)
        ENDIF
        (cArq1)->(DBGOTO(nReg))
        oBr:refreshAll()
     ELSEIF ( tecla == K_F8 )    // Registro de Reposicao
        nReg:=(cArq1)->(RECNO())
        IF (cArq1)->DATA<=cDtSys
           IF (cArq1)->FALTA="*"
              IF (cArq1)->PAGO=="*"
                 IF oBr:colpos==5
                    xVar:=(cArq1)->(FIELDGET(13))
                    @ ROW(),COL() GET xVar PICT "@D" VALID !EMPTY(xVar).AND.xVar<=cDtSys
                    SETCURSOR(1); READ; SETCURSOR(0)
                    IF LASTKEY()#K_ESC.OR.UPDATED()
                       TEORICA->(DBSETORDER(2))
                       TEORICA->(DBSEEK(wCod+(cArq1)->CODCUR+(cArq1)->NAULA))
                       WHILE !TEORICA->(NetLReg()); ENDDO
                       REPLACE TEORICA->DTREP WITH xVar
**                             TEORICA->USER  WITH cUsuario
                       TEORICA->(DBUNLOCK()); TEORICA->(DBCOMMIT())
                       TEORICA->(DBSETORDER(1))

                       (cArq1)->(FIELDPUT(13,xVar))
                       REPLACE (cArq1)->USER WITH cUsuario
*                       oBr:Refreshall();(cArq1)->(DBGOTO(nReg))
                    ENDIF
                 ENDIF
              ELSE
                 Aviso("Data da reposi‡Æo somente para aula paga!",,3)
              ENDIF
           ELSE
              Aviso("Data da reposi‡Æo somente para aula faltada!",,3)
           ENDIF
        ELSE
           Aviso("Aula ainda nÆo realizada!",,3)
        ENDIF
        (cArq1)->(DBGOTO(nReg))
        oBr:refreshAll()
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(); RELEASE nSel
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Recibo Reposicao    ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION RecRep(pMat)
  LOCAL linha1:=linha2:=""
  SET DEVICE TO PRINT; SETPRC(0,0)
  @ PROW()+1,05 SAY cRazao
  @ PROW()+1,05 SAY cEnder1
  @ PROW()+1,05 SAY cEnder2
  @ PROW()+1,05 SAY cEnder3
  @ PROW()+1,05 SAY cCGC_MF
  Controle()
  @ PROW()+1,05 SAY "# "+DBPARM->CR+pMat+" #"
  Expand_On()
  @ PROW()+3,05 SAY PADC("** R E C I B O **",70)
  @ PROW()+2,64 SAY "R$ "+TRANSFORM(wValor,"@E 999.99")
  Expand_Off()
  @ PROW()+3,00 SAY "        Recebemos do(a) Sr(a). "+RTRIM(wNome)+" "+REPL("/",47-LEN(RTRIM(wNome)))

  tValor:=Extenso(wValor)
  @ PROW()+2,05 SAY "a importancia de R$ "+ALLTRIM(TRANSFORM(wValor,"@E 999.99"))+"("+tValor+")"
  @ PROW()+2,05 SAY "referente ao pagamento de REPOSICAO DE AULA."

  @ PROW()+5,05 SAY PADR("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),80)
  @ PROW()+3,05 SAY REPL("_",LEN(cRazao))
  @ PROW()+1,05 SAY cRazao

  @ PROW()+3,05 SAY "_______________________"
  @ PROW()+1,05 SAY "      De acordo        "
  EJECT
  SET DEVICE TO SCREEN
  RETURN NIL
