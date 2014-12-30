*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_231                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Resultados de Exames no DETRAN           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 23/05/2003                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
/* Criar Arquivo Tempor rio */
aDbf:={}
AADD(aDbf,{"MATRIC"    , "C", 05,0})  /* Matricula do Aluno */
AADD(aDbf,{"EXAME"     , "C", 01,0})  /* Tipo do Exame L=legislacao e P=pratico */
AADD(aDbf,{"CATEG"     , "C", 01,0})  /* Categoria */
AADD(aDbf,{"RENACH"    , "C", 12,0})  /* Numero do RENACH */
AADD(aDbf,{"DATA"      , "D", 08,0})  /* Data do Exame */
AADD(aDbf,{"HORA"      , "C", 04,0})  /* Hora do Exame */
AADD(aDbf,{"RESULTADO" , "C", 01,0})  /* Resultado do Exame A=Apto I=Inapto R=Remarcado */
AADD(aDbf,{"TIPO"      , "C", 01,0})  /* Tipo do Lancamento E=Exame R=Reforco */
AADD(aDbf,{"OBS"       , "C", 50,0})  /* Observacoes */
AADD(aDbf,{"DATALAN"   , "D", 08,0})  /* Data do Registro */
AADD(aDbf,{"USER"      , "C", 20,0})  /* Operador */
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
INDEX ON DTOS(DATA) TO (cArq1)

SELECT 5
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBRES","EXAME")            /* Cadastro de Exames */
   SET INDEX TO DBIRES1,DBIRES2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE231"; ProgName("AE231"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "31"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
Telas(4,3,6,75,1,YCOREDIT,.T.,"Resultados de Exames de Legislaฦo")
WHILE .T.
   SET KEY -1 TO Mostra()
   SETCOLOR(YCOREDIT); LinhaMsg(2)
   SCROLL(5,22,5,74,0)
   wNom:= SPACE(5); wExame:="L"
   @ 05,05 SAY "Matrกcula:" GET wNom PICT "99999" WHEN TeclaFuncao() VALID !EMPTY(wNom).AND.;
     Pesquisa(3,1,wNom,"Aluno Nฦo Cadastrado").AND.TDescr(3,1,5,22,wNom,"NOME",,"Aluno Nฦo Cadastrado")
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   // Grava dados no arq. temporario
   wMatric:=wNom
   IF DBSEEK(wMatric+wExame)
      WHILE MATRIC==wMatric.AND.EXAME==wExame
         FOR a = 1 TO FCOUNT()
             xVar  := "w"+FIELDNAME(a)
             &xVar := FIELDGET(a)
         NEXT

         (cArq1)->(DBAPPEND())
         FOR a = 1 TO (cArq1)->(FCOUNT())
             xVar  := "w"+(cArq1)->(FIELDNAME(a))
             (cArq1)->(FIELDPUT(a,&xVar))
         NEXT
         WHILE !NetLReg(); ENDDO
         DBDELETE(); DBUNLOCK(); DBSKIP()
      ENDDO
   ENDIF

   BrowRes()
   (cArq1)->(__DBZAP())
   SELECT EXAME
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse de Filtragem            ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE BrowRes()
  msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui ^F6^-Resultado"

  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(6,3,18,75,1,YCOREDIT,.T.)
  Linha23(msg)

  oBr:=TBROWSEDB(7,4,17,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("RENACH"     ,{|| RENACH})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Exame"   ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"       ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Tipo"       ,{|| IF(TIPO="E","Exame  ",IF(TIPO="R","Reforo","       "))})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Resultado"  ,{|| IF(RESULTADO="A","Apto  ",IF(RESULTADO="I","Inapto",IF(RESULTADO="R","Remarc.","       ")))})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Registro",{|| DATALAN})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Observaไes",{|| OBS})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Usu rio"    ,{|| USER})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        Aguarde("Atualizando informaไes...")
        // Gravar dados definitivos
        (cArq1)->(DBGOTOP())
        WHILE !(cArq1)->(EOF())
           FOR a = 1 TO (cArq1)->(FCOUNT())
               xVar  := "w"+(cArq1)->(FIELDNAME(a))
               &xVar := (cArq1)->(FIELDGET(a))
           NEXT
           WHILE !EXAME->(NetApp()); ENDDO
           FOR a = 1 TO EXAME->(FCOUNT())
               xVar  := "w"+EXAME->(FIELDNAME(a))
               EXAME->(FIELDPUT(a,&xVar))
           NEXT
           EXAME->(DBUNLOCK()); EXAME->(DBCOMMIT())
           (cArq1)->(DBSKIP())
        ENDDO
        Aguarde()
        EXIT
     ELSEIF ( tecla == K_F4 )   // Calculadora
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )   // Calendario
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F6 )   // Resultado
        IF Acesso(3)
           nReg_Ant := RECNO()
           DBGOTOP()
           IF EOF()
              Aviso("Nฦo h  registro a informar !",,2)
           ELSE
              x1:=x2:=x3:=" "
              Telas(17,3,19,75,1,YCOREDIT,.T.,"Resultado")
              @ 18,05 SAY "( ) Apto     ( ) Inapto  ( ) Remarcado"
              @ 18,06 GET x1 PICT "!" WHEN EMPTY(x2) VALID x1$" X"
              @ 18,19 GET x2 PICT "!" WHEN EMPTY(x1) VALID x2$" X"
              @ 18,31 GET x3 PICT "!" WHEN EMPTY(x1).AND.EMPTY(x2) VALID x3$" X"
              SETCURSOR(1); READ; SETCURSOR(0)
              IF LASTKEY()#K_ESC
                 IF Confirma("Confirma Resultado ?")
                    GO nReg_Ant
                    REPLACE (cArq1)->RESULTADO WITH IF(!EMPTY(x1),"A",IF(!EMPTY(x2),"I","R"))
                    ProcOk("Registrado",.T.)
                 ENDIF
              ENDIF
              Rest_Tela()
           ENDIF
           GO nReg_Ant
           oBr:refreshAll()
        ENDIF
     ELSEIF ( tecla == K_INS )
        IF Acesso(3); Inclui(msg); oBr:refreshAll(); ENDIF
     ELSEIF ( tecla == K_DEL )
        IF Acesso(3); Exclui(msg); oBr:refreshAll(); oBr:up(); oBr:down(); ENDIF
     ELSEIF ( tecla == K_ENTER )
        IF Acesso(3); Altera(msg); oBr:refreshAll(); ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := FERIADO->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(14,3,19,75,1,YCOREDIT,.T.,"Inclusฦo de Exames")
   WHILE .T.
      (cArq1)->(DBGOBOTTOM()); (cArq1)->(DBSKIP())
      FOR a = 1 TO (cArq1)->(FCOUNT())
          xVar  := "w"+(cArq1)->(FIELDNAME(a))
          &xVar := (cArq1)->(FIELDGET(a))
      NEXT
      wRENACH:="BA"+SPACE(10)

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         // Gravar no arquivo de Exames
         wExame   := "L"
         wUser    := cUsuario
         wDataLan := cDtSys
         wMatric  := wNom

         (cArq1)->(DBAPPEND())
         FOR a = 1 TO (cArq1)->(FCOUNT())
             xVar  := "w"+(cArq1)->(FIELDNAME(a))
             (cArq1)->(FIELDPUT(a,&xVar))
         NEXT
         (cArq1)->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outro Exame ?"); EXIT; ENDIF
         SCROLL(17,4,18,74,0)
      ELSE
         IF LEN(Telas)==6; Rest_Tela(); ENDIF
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   Linha23(msg); SETKEY(K_F2,NIL)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(14,3,19,75,1,YCOREDIT,.T.,"Alteraฦo Dados do Exame")

   FOR a = 1 TO (cArq1)->(FCOUNT())
       xVar  := "w"+(cArq1)->(FIELDNAME(a))
       &xVar := (cArq1)->(FIELDGET(a))
   NEXT

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         wUser:=cUsuario
         FOR a = 1 TO (cArq1)->(FCOUNT())
             xVar  := "w"+(cArq1)->(FIELDNAME(a))
             (cArq1)->(FIELDPUT(a,&xVar))
         NEXT
         (cArq1)->(DBCOMMIT())

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := (cArq1)->(RECNO()), lExcl := .F.

   (cArq1)->(DBGOTOP())
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma Exclusฦo do Exame ?")
      Aguarde("Eliminando...")

      (cArq1)->(DBDELETE()); (cArq1)->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet(pOp)
   @ 15,05 SAY "Tipo    RENACH       Dt.Exame   Hora"
   @ 17,05 SAY "Observaไes"
*               X-Exame 999999999999 99/99/9999 99:99
*               5678901234567890123456789012345678901234567890
*                    1         2         3         4         5
   @ 16,05 GET wTipo   PICT "!"            WHEN Htela(11) VALID VTELA(11)
   @ 16,13 GET wRENACH PICT "XXX999999999" WHEN wTipo="E" VALID LASTKEY()==K_UP.OR.!EMPTY(wRENACH)
   @ 16,26 GET wData   PICT "@D"           VALID LASTKEY()==K_UP.OR.!EMPTY(wData)
   @ 16,37 GET wHora   PICT "@R 99:99"     VALID LASTKEY()==K_UP.OR.!EMPTY(wHora)
   @ 18,05 GET wObs    PICT "@!"
   RETURN
