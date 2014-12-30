*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_160                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Gravar Mensagem do Carn                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), vTela

DBCLOSEALL()
SELECT 1
IF !NetUse("DBPARM")                  /* Parametros */
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "40"
cPrg:="AE160"; LinhaMsg(2); ProgName(cPrg)
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,10,20,69,1,YCOREDIT,.T.,"Mensagens e Avisos")
WHILE .T.
   wMsg_Cup := DBPARM->MSG_CUP
   wAvs_Cup := DBPARM->AVS_CUP
   wMsg_Rec := DBPARM->MSG_REC
   wAvs_Rec := DBPARM->AVS_REC
   wMsg_Lpa := DBPARM->MSG_LPA
   wAvs_Lpa := DBPARM->AVS_LPA
   wMsg_Mtr := DBPARM->MSG_MTR
   wAvs_Mtr := DBPARM->AVS_MTR
   @ 05,12 SAY "Cupom Matrกcula"
   @ 06,12 SAY "    þ Mensagem:" GET wMsg_Cup PICT "@!S40"
   @ 07,12 SAY "    þ Aviso...:" GET wAvs_Cup PICT "@!S40"
   @ 08,10 SAY "ร"+REPL("ฤ",58)+"ด"
   @ 09,12 SAY "Recibos Diversos"
   @ 10,12 SAY "    þ Mensagem:" GET wMsg_Rec PICT "@!S40"
   @ 11,12 SAY "    þ Aviso...:" GET wAvs_Rec PICT "@!S40"
   @ 12,10 SAY "ร"+REPL("ฤ",58)+"ด"
   @ 13,12 SAY "Lista de Presena"
   @ 14,12 SAY "    þ Mensagem:" GET wMsg_Lpa PICT "@!S40"
   @ 15,12 SAY "    þ Aviso...:" GET wAvs_Lpa PICT "@!S40"
   @ 16,10 SAY "ร"+REPL("ฤ",58)+"ด"
   @ 17,12 SAY "Ficha de Matrกcula"
   @ 18,12 SAY "    þ Mensagem:" GET wMsg_Mtr PICT "@!S40"
   @ 19,12 SAY "    þ Aviso...:" GET wAvs_Mtr PICT "@!S40"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF UPDATED().AND.Confirma("Grava Mensagens ?")
      DBPARM->(DBGOTOP())
      IF DBPARM->(EOF())
         WHILE !DBPARM->(NetApp()); ENDDO
      ELSE
         WHILE !DBPARM->(NetLReg()); ENDDO
      ENDIF
      REPLACE DBPARM->MSG_CUP WITH wMsg_Cup ,;
              DBPARM->AVS_CUP WITH wAvs_Cup ,;
              DBPARM->MSG_REC WITH wMsg_Rec ,;
              DBPARM->AVS_REC WITH wAvs_Rec ,;
              DBPARM->MSG_LPA WITH wMsg_Lpa ,;
              DBPARM->AVS_LPA WITH wAvs_Lpa ,;
              DBPARM->MSG_MTR WITH wMsg_Mtr ,;
              DBPARM->AVS_MTR WITH wAvs_Mtr
      DBPARM->(DBUNLOCK())
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DBCLOSEALL(); RETURN
