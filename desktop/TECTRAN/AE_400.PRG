*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_400                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Auxiliar o Sistema (Utilit rios)         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 18/02/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC lAlterado := .F.

Telas(2,52,6,68,1,YCORMENU,.T.)
WHILE .T.
   LinhaMsg(2)
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "4"; cOpHelp2 := "00"
   ProgName("AE400")

   @ 03,53 PROMPT " Configuraไes " MESSAGE Msg("Configuraไes do Sistema")
   @ 04,53 PROMPT " Disco         " MESSAGE Msg("Copiar/Recuperar Arquivos do Sistema em Disquete")
   @ 05,53 PROMPT " Manutenฦo    " MESSAGE Msg("Manutenฦo dos Arquivos Indices")
   MENU TO nMenu_5

   IF nMenu_5 = 0
      Rest_Tela(); LinhaMsg(1)
      IF lAlterado ; Area_Dados() ; RELEASE lAlterado ; ENDIF
      RETURN
   ENDIF
   SETKEY(K_LEFT,NIL); SETKEY(K_RIGHT,NIL)

   IF nMenu_5 = 1
      IF Acesso(5); AE_410(); ENDIF
   ELSEIF nMenu_5 = 2
      IF Acesso(5); AE_420(); ENDIF
   ELSEIF nMenu_5 = 3
      IF Acesso(5); AE_430(); ENDIF
   ENDIF
ENDDO
