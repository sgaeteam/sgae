*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : RC_265                           vrs 001 ณ
*ณ FINALIDADE     : Estorno de Pagamento de Fatura           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 07/07/1995                               ณ
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
IF NetUse("DBCLI","CLIENTE")        /* Cadastro de Clientes */
   SET INDEX TO DBICLI1,DBICLI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBREC","RECEBER")         /* Arquivo de Faturas */
   SET INDEX TO DBIREC5,DBIREC1,DBIREC3,DBIREC4,DBIREC2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="RC265"; ProgName("RC265"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "65"

WHILE .T.
   Telas(19,3,21,21,1,YCOREDIT,.T.)
   SETCOLOR(YCOREDIT)

   cNFF:=SPACE(6)
   Mensagem("Informe Nฃmero da Fatura")
   @ 20,05 SAY "Nota Nง:" GET cNFF PICT "@!K 99999A" VALID TFat(cNFF)
   SETCURSOR(1); READ; SETCURSOR(0)

   Mensagem()
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   IF !EMPTY(DTREC)
      Rest_Tela()
      nValorPago := RECEBER->VLR_AREC
      dDtPgto    := RECEBER->DTAREC
      wCod_cf    := RECEBER->COD_CF
      wConta     := RECEBER->CONTA
      wItem_cx   := RECEBER->ITEM_CX

      SETCOLOR(YCORMENU)
      Telas(10,9,17,69,1,YCORMENU,.T.,"ด Estorno de Fatura ร")
      TDescr(2,1,12,28,wCod_cf,"NOME",["@S37"],,YCORMENU)
      TDescr(4,1,15,49,wConta,"TITULAR",["@S18"],,YCORMENU)
      TDescr(3,1,16,28,wItem_cx,"DESCR",["@S37"],,YCORMENU)
      CLIENTE->(DBSEEK(RECEBER->COD_CF))
      @ 11,11 SAY "Nota Fiscal:" GET cNFF       PICT "999999"
      @ 12,11 SAY "    Cliente:" GET wCod_cf    PICT "9999"
      @ 13,11 SAY "Data Pagto.:" GET dDtPgto    PICT "@D"
      @ 14,11 SAY " Valor Pago:" GET nValorPago PICT "@E 9,999,999,999.99"
      @ 15,11 SAY "   Conta Nง:" GET wConta     PICT "@R !!!-!!!!!!!-!!!!!!!!!!!!!!!"
      @ 16,11 SAY "       Item:" GET wItem_cx   PICT "9999"
      CLEAR GETS

      IF Confirma("Confirma Estorno ?")
         ProcOk("Estornado",.T.)
         IF NetlReg()
            REPLACE DTREC   WITH CTOD(""),;
                    VLR_REC WITH 0.00
            UNLOCK; DBCOMMIT()
         ENDIF
         SCROLL(12,28,12,65)
         SCROLL(16,28,16,65)
         nValorPago := 0.00
         dDtPgto    := CTOD("")
         wNFat      := SPACE(6)
         wCod_cf    := SPACE(4)
         wConta     := SPACE(23)
         wItem_cx   := SPACE(4)
      ENDIF
   ELSE
      Aviso("Fatura em aberto...",,3)
   ENDIF
   Rest_Tela()
ENDDO
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Fatura    ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TFat(pFat)
   RECEBER->(DBSETORDER(3))
   IF !RECEBER->(DBSEEK(pFat))
      Aviso("Fatura nฦo Localizada...",,3); RETURN .F.
   ENDIF
   RETURN .T.
