*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_140                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Tabela de Feriados             ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol
LOCAL tela := SAVESCREEN(2,0,24,79)

DBCLOSEALL()
SELECT 1
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "40"
cPrg:="AE140"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,19,75,1,YCOREDIT,.T.,"Cadastro de Feriados")
Linha23(msg)

oBr:=TBROWSEDB(5,6,18,74)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Dia/Mes"  ,{|| TRANSFORM(RIGHT(DIAMES,2)+LEFT(DIAMES,2),"@R 99/99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Tipo"     ,{|| IF(TIPO=="M","Mขvel","Fixo ")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Feriado"  ,{|| DESCR})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_INS )
      IF Acesso(5); Inclui(msg); oBr:refreshAll(); ENDIF
   ELSEIF ( tecla == K_DEL )
      IF Acesso(5); Exclui(msg); oBr:refreshAll(); oBr:up(); oBr:down(); ENDIF
   ELSEIF ( tecla == K_ENTER )
      IF Acesso(5); Altera(msg); oBr:refreshAll(); ENDIF
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := FERIADO->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(16,5,19,75,1,YCOREDIT,.T.,"Inclusฦo de Feriado")
   WHILE .T.
      FERIADO->(DBGOBOTTOM()); FERIADO->(DBSKIP())
      FOR a = 1 TO FERIADO->(FCOUNT())
          xVar  := "w"+FERIADO->(FIELDNAME(a))
          &xVar := FERIADO->(FIELDGET(a))
      NEXT

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         // Gravar no arquivo de Feriados
         wDiaMes:=RIGHT(wDiaMes,2)+LEFT(wDiaMes,2)
         WHILE !FERIADO->(NetApp()); ENDDO
         FOR a = 1 TO FERIADO->(FCOUNT())
             xVar  := "w"+FERIADO->(FIELDNAME(a))
             FERIADO->(FIELDPUT(a,&xVar))
         NEXT
         FERIADO->(DBUNLOCK()); FERIADO->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outro Feriado ?"); EXIT; ENDIF
         SCROLL(17,6,18,74,0)
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
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
   Telas(16,5,19,75,1,YCOREDIT,.T.,"Alteraฦo Dados do Feriado")

   FOR a = 1 TO FERIADO->(FCOUNT())
       xVar  := "w"+FERIADO->(FIELDNAME(a))
       &xVar := FERIADO->(FIELDGET(a))
   NEXT
   wDiaMes:=RIGHT(wDiaMes,2)+LEFT(wDiaMes,2)

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         wDiaMes:=RIGHT(wDiaMes,2)+LEFT(wDiaMes,2)
         WHILE !FERIADO->(NetLReg()); ENDDO
         FOR a = 1 TO FERIADO->(FCOUNT())
             xVar  := "w"+FERIADO->(FIELDNAME(a))
             FERIADO->(FIELDPUT(a,&xVar))
         NEXT
         FERIADO->(DBUNLOCK()); FERIADO->(DBCOMMIT())

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
   LOCAL nReg_Ant := FERIADO->(RECNO()), lExcl := .F.

   FERIADO->(DBGOTOP())
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma Exclusฦo do FERIADO ?")
      Aguarde("Eliminando...")

      WHILE !FERIADO->(NetLReg()); ENDDO
      FERIADO->(DBDELETE()); FERIADO->(DBUNLOCK()); FERIADO->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet(pOp)
   @ 17,07 SAY "Dia/Mes:"  GET wDiaMes PICT "@R 99/99" VALID ;
        (!EMPTY(LEFT(wDiaMes,2)).AND.!EMPTY(RIGHT(wDiaMes,2))).AND.;
        VAL(LEFT(wDiaMes,2))>=1.AND.VAL(LEFT(wDiaMes,2))<=31  .AND.;
        VAL(RIGHT(wDiaMes,2))>=1.AND.VAL(RIGHT(wDiaMes,2))<=12.AND.;
        IF(pOp=="I",TFeri(RIGHT(wDiaMes,2)+LEFT(wDiaMes,2)),.T.)
   @ 17,35 SAY "Tipo:"     GET wTipo   PICT "!"     VALID LASTKEY()==K_UP.OR.wTipo $ "MF"
   @ 17,43 SAY "M=Mขvel F=Fixo"
   @ 18,07 SAY "Feriado:"  GET wDescr  PICT "@!"    VALID LASTKEY()==K_UP.OR.!EMPTY(wDescr)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Feriado j  Existente  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TFeri(pVar)
  LOCAL lRet:=.F.
  IF (lRet:=FERIADO->(DBSEEK(pVar)))
     Aviso("Feriado j  Cadastrado!")
  ENDIF
  RETURN(!lRet)
