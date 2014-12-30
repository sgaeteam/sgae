*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_261                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lanar Faturas a Receber                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 20/06/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 4
IF NetUse("DBBANCO","BANCO")        /* Cadastro de Bancos */
   SET INDEX TO DBIBCO1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBITEM","ITEM")          /* Cadastro de Itens de Fluxo de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBCLI","CLIENTE")       /* Cadastro de Clientes */
   SET INDEX TO DBICLI1,DBICLI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBREC","RECEBER")       /* Arquivo de Contas a Receber */
   SET INDEX TO DBIREC2,DBIREC3,DBIREC1,DBIREC4,DBIREC5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "2"; cOpHelp2 := "61"
LinhaMsg(2); ProgName("AE261")
SET KEY -1 TO Mostra()
WHILE .T.
   lNovo := lDeleta := lAchou := .F.
   wNFat := SPACE(6)
    
   SETCOLOR(YCOREDIT)
   Telas(19,3,21,24,1,YCOREDIT,.T.)
   Mensagem("Informe o Nฃmero da Fatura")
   @ 20,05 SAY "Fatura Nง:" GET wNFat PICT "@!K 99999A" WHEN TeclaFuncao(.T.);
     VALID VAL(wNFat)>0
   SETCURSOR(1); READ; SETCURSOR(0)

   Rest_Tela()
   IF LASTKEY()==K_ESC.OR.EMPTY(wNFat); EXIT; ENDIF

   RECEBER->(DBSETORDER(2))
   wNFat := STRZERO(VAL(wNFat),5)+SUBS(wNFat,6,1)
   lAchou:=DBSEEK(wNFat)
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   wNDoc := wNFat

   Telas(7,6,18,72,1,YCOREDIT,.T.,"Cadastro de Faturas a Receber")
   IF lAchou
      TDescr(2,1,9,26,wCod_cf,"NOME","[@S43]")
      TDescr(3,1,10,26,wItem_cx,"DESCR")
      TDescr(4,1,11,47,wConta,"TITULAR","[@S23]")
   ENDIF

   LimpaLinhaMsg()
   @ 16,06 SAY "ร"+REPL("ฤ",65)+"ด"
   @ 08,08 SAY "  Fatura Nง:" GET wNDoc     PICT "99999A" WHEN .F. //VALID !EMPTY(wNDoc).AND.TFatRec(wNDoc)
   @ 09,08 SAY "    Cliente:" GET wCod_cf   PICT "9999"   WHEN TeclaFuncao(.T.);
     VALID (LASTKEY()==K_UP).OR.!EMPTY(wCod_cf).AND.TCli(wCod_cf).AND.TDescr(2,1,9,26,wCod_cf,"NOME","[@S43]")
   @ 10,08 SAY "       Item:" GET wItem_cx  PICT "9999"   VALID (LASTKEY()==K_UP).OR.;
     !EMPTY(wItem_cx).AND.TItem(wItem_cx).AND.TDescr(3,1,10,26,wItem_cx,"DESCR")
   @ 11,08 SAY "   Cobrana:" GET wCobranca PICT "@!"     WHEN HTela(4) VALID VTela(4).AND.LASTKEY()#K_ESC
   @ 12,08 SAY "      Conta:" GET wConta    PICT "@R 999/!!!!!!!/!!!!!!!!!!!!!" WHEN wCobranca=="B".AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.!EMPTY(wConta).AND.TConta(wConta).AND.TDescr(4,1,12,47,wConta,"TITULAR","[@S23]")
   @ 13,08 SAY "    Emissฦo:" GET wDtEmiss  PICT "@D"     WHEN TeclaFuncao()
   @ 14,08 SAY " Vencimento:" GET wDtaRec   PICT "@D"     VALID (LASTKEY()==K_UP).OR.!EMPTY(wDtaRec).AND.wDtaRec>=wDtEmiss
   @ 15,08 SAY "Vlr.Liquido:" GET wVlr_aRec PICT "@E 999,999,999.99" VALID wVlr_aRec>0.00
   @ 17,08 SAY "Observaไes:" GET wObs      PICT "@!"

   IF DTREC#CTOD("")
      Aviso("Fatura j  dado Baixa.. <Tecle algo>"); GetList:={}; Rest_Tela(); LOOP
   ENDIF

   IF EOF()
      IF Acesso(3)
         SETCURSOR(1); READ; SETCURSOR(0)
         msg   := "Confirma os Dados ? "
         lNovo := .T.
      ELSE
         CLEAR GETS
         Rest_Tela(); LOOP
      ENDIF
   ELSE
      IF nNivel==1
         WaitMsg("Tecle algo para continuar...",.F.)
         CLEAR GETS
         Rest_Tela(); LOOP
      ENDIF
      DeleAltera()
      IF LASTKEY()==K_ENTER
         IF Acesso(3)
            SETCURSOR(1); READ; SETCURSOR(0)
            msg     := "Confirma Alteraฦo ? "
            lAltera := .T.
         ELSE
            KEYBOARD CHR(27); READ
         ENDIF
      ELSEIF LASTKEY()==K_DEL
         IF Acesso(5)
            CLEAR GETS
            msg     := "Confirma a Exclusฦo ? "
            lDeleta := .T.
         ELSE
            KEYBOARD CHR(27); READ
         ENDIF
      ENDIF
   ENDIF
   IF LASTKEY() <> K_ESC
      IF Confirma(msg)
         IF lDeleta
            WHILE !NetLReg(); ENDDO
            DBDELETE(); UNLOCK
            ProcOk("Eliminado",.T.)
         ELSE
            IF lNovo
               WHILE !NetApp(); ENDDO
               ProcOk("Gravado",.T.)
            ELSE
               ProcOk("Alterado",.T.)
            ENDIF
            WHILE !NetLReg(); ENDDO
            FOR a = 1 TO FCOUNT()
                xVar  := "w"+FIELDNAME(a)
                FIELDPUT(a,&xVar)
            NEXT
            UNLOCK; DBCOMMITALL()
         ENDIF
      ENDIF
   ELSE
      CLEAR GETS
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Conta   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TConta(pConta)
   IF !(lRet:=BANCO->(DBSEEK(pConta)))
      Aviso("Conta Inexistente...",,3)
   ENDIF
   RETURN(lRet)
