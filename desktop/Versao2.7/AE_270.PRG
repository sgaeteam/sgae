*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_270                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Fechamento de Caixa         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 22/11/1997                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Arquivo de Pagamentos */
   SET INDEX TO DBIPAG3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE270"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "70"
SET KEY -1 TO Mostra()
wDin:=wCH:=wCard:=wVDin:=wVCH:=wTot:=wCHPr:=0.00
WHILE .T.
   SETCOLOR(YCOREDIT)
   Mensagem("Informe Valores para o Fechamento")
   Telas(08,20,16,55,1,YCOREDIT,.T.,"Fechamento Di rio - "+DTOC(cDtSys))
   Telas(16,20,18,55,1,YCOREDIT,.T.)
   @ 09,22 SAY "Dinheiro... R$:" GET wDin  PICT "@E 99,999.99" WHEN SomaTot()
   @ 10,22 SAY "Cheques.....R$:" GET wCH   PICT "@E 99,999.99" WHEN SomaTot()
   @ 11,22 SAY "Cheques Pr.R$:" GET wCHPr PICT "@E 99,999.99" WHEN SomaTot()
   @ 12,22 SAY "Cartไes.....R$:" GET wCard PICT "@E 99,999.99" WHEN SomaTot()
   @ 13,22 SAY "Vales"
   @ 14,22 SAY "   Dinheiro R$:" GET wVDin PICT "@E 99,999.99" WHEN SomaTot()
   @ 15,22 SAY "   Cheques  R$:" GET wVCH  PICT "@E 99,999.99" VALID LASTKEY()==K_UP.OR.SomaTot()
   @ 17,22 SAY "T O T A L   R$:" GET wTot  PICT "@E 99,999.99" WHEN .F.
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC; Rest_Tela(2); EXIT; ENDIF
   Mensagem()
   /* Localizar Periodo */
   IF !PAGAR->(DBSEEK(DTOS(cDtSys)))
      Aviso("Nฦo houve movimento de caixa hoje",,3)
   ELSE
      nDin:=nCH:=nCard:=nPre:=nTot:=0.00
      /* Alimentar totalizadores */
      WHILE PAGAR->DTPGTO=cDtSys.AND.!PAGAR->(EOF())
         IF SUBS(PAGAR->DOC,1,1)=="A"
            nCard += PAGAR->VALOR_C
            IF PAGAR->VALOR_D>0.00
               nDin += PAGAR->VALOR_D
               nTot += PAGAR->VALOR_D
            ENDIF
         ELSE
            IF PAGAR->DTVCTO#PAGAR->DTPGTO.AND.!EMPTY(PAGAR->DOC)
               /* Cheque Pr-Datado */
               nPre += PAGAR->VALOR_C
               nDin += PAGAR->VALOR_D
            ELSE
               nCh  += PAGAR->VALOR_C
               nDin += PAGAR->VALOR_D
            ENDIF
            nTot += (PAGAR->VALOR_C + PAGAR->VALOR_D)
         ENDIF
         PAGAR->(DBSKIP())
      ENDDO
      IF (nTot-nCard)#wTot
         IF Confirma("Valores nฦo conferem! Imprime ?")
            ImpFecha()
         ENDIF
      ELSE
         ImpFecha()
      ENDIF
   ENDIF
   Rest_Tela(2)
ENDDO
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Soma total do fechamento       ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION SomaTot()
  wTot := wDin + wCH + wCard + wVDin + wVCH + wCHPr
  @ 17,38 SAY wTot PICT "@E 99,999.99"
  RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Impressao do Resumo do Fecham. ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpFecha()
  LOCAL xDinheiro, xCheques, xTot
  IF ChkImpr()
     xDinheiro := IF((nDin-wVDin)<0,(nDin-wVDin)*-1,(nDin-wVDin))
     xCheques  := IF((nCH-wVCH)<0,(nCH-wVCH)*-1,(nCH-wVCH))
     xTot      := xDinheiro+xCheques+wVDin+wVCH+wCHPr
     cAviso := MsgImp()
     pg:=0; continua:=.T.
     Gera_TXT("CAIXA.TXT")
     CabRel("FECHAMENTO DE CAIXA")
     @ PROW()+1,02 SAY REPLICATE("-",78)
     @ PROW()+1,04 SAY "Dinheiro.........R$"
     @ PROW()  ,25 SAY xDinheiro PICT "@E 99,999.99"
     @ PROW()+1,04 SAY "Cheques..........R$ "
     @ PROW()  ,25 SAY xCheques  PICT "@E 99,999.99"
     @ PROW()+1,04 SAY "Cheques Pre-Dat..R$ "
     @ PROW()  ,25 SAY nPre      PICT "@E 99,999.99"
     @ PROW()+1,04 SAY "Vales (Dinheiro).R$ "
     @ PROW()  ,25 SAY  wVDin    PICT "@E 99,999.99"
     @ PROW()+1,04 SAY "      (Cheques) .R$ "
     @ PROW()  ,25 SAY  wVCH     PICT "@E 99,999.99"
     @ PROW()+1,04 SAY "ฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ"
     @ PROW()+1,04 SAY "T O T A L........R$ "
     @ PROW()  ,25 SAY  xTot     PICT "@E 99,999.99"
     @ PROW()+2,04 SAY "Cartไes..........R$ "
     @ PROW()  ,25 SAY  nCard    PICT "@E 99,999.99"
     @ PROW()+5,04 SAY "Conferido por: ___________________"
     Fim_TXT()
     SAVESCREEN(0,0,24,79)
     RUN nodosimp caixa.txt 80 pre
     RESTSCREEN(0,0,24,79,0)
     DELETE FILE CAIXA.TXT
     TiraMsgImp(cAviso)
     WaitMsg("Fim de Impressฦo, tecle algo...")
  ENDIF
  RETURN
