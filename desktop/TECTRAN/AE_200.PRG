*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ÿPROGRAMA      ÿ:ÿAE_200                           vrs 001ÿ³
*³ÿVRS 001   ÿÿÿÿÿ:ÿDesenvolvimento                          ³
*³ÿFINALIDADEÿÿÿÿÿ:ÿMenu de Movimenta‡Æo                     ³
*³ÿPROGRAMADORÿÿÿÿ:ÿVITOR A.SMITH FREIRE - VIRTUALÿÿÿÿÿÿÿÿÿÿ ³
*³ÿDATA CRIACAOÿÿÿ:ÿ17/12/1996ÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿÿ ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

Telas(2,20,16,41,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "2"; cOpHelp2 := "00"
   ProgName("AE200")

   @ 07,20 SAY "Ã"+REPL("Ä",20)+"´"
   @ 10,20 SAY "Ã"+REPL("Ä",20)+"´"
   @ 12,20 SAY "Ã"+REPL("Ä",20)+"´"
   @ 14,20 SAY "Ã"+REPL("Ä",20)+"´"
   @ 03,21 PROMPT " Programa‡Æo Aulas " MESSAGE Msg("Registrar Programa‡Æo de Aulas")
   @ 04,21 PROMPT " Aulas Pr ticas    " MESSAGE Msg("Manuten‡Æo de Aulas")
   @ 05,21 PROMPT " Aulas Te¢ricas    " MESSAGE Msg("Manuten‡Æo de Aulas")
   @ 06,21 PROMPT " Resultados Exames " MESSAGE Msg("Registrar Resultados da Avalia‡Æo do Aluno no DETRAN")
   @ 08,21 PROMPT " Pagamentos        " MESSAGE Msg("Registrar Pagamentos de Aulas e Servi‡os")
   @ 09,21 PROMPT " Caixa             " MESSAGE Msg("Fechamento e Movimento de Caixa")
   @ 11,21 PROMPT " Lan‡amento/Bancos  " MESSAGE Msg("Lan‡amento em Conta Corrente")
   @ 13,21 PROMPT " Contas a Pagar    " MESSAGE Msg("Lan‡amento de Contas a Receber")
   @ 15,21 PROMPT " Controle Ve¡culos  " MESSAGE Msg("Lan‡amento de Dados Veiculares")
   MENU TO nMenu_3

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_3 = 0
      Rest_Tela(); LinhaMsg(1); RETURN
   ENDIF

   IF nMenu_3 = 1
      Telas(3,41,6,52,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 04,42 PROMPT " Pr ticas " MESSAGE Msg("Programa‡Æo de Aulas Pr ticas")
         @ 05,42 PROMPT " Te¢ricas " MESSAGE Msg("Programa‡Æo de Aulas Te¢ricas")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
            IF Acesso(3); AE_210(); ENDIF
         ELSEIF nMenu_22 = 2
            IF Acesso(3); AE_211(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 2
      Telas(4,41,11,57,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 05,42 PROMPT " Lan‡amento    " MESSAGE Msg("Lan‡amento de Aulas Efetuadas")
         @ 06,42 PROMPT " Transferˆncia " MESSAGE Msg("Transferir Aulas")
         @ 07,42 PROMPT " Desmarca‡Æo   " MESSAGE Msg("Desmarcar Aulas")
         @ 08,42 PROMPT " Remarca‡Æo    " MESSAGE Msg("Remarcar Aulas")
         @ 09,42 PROMPT " Pendentes     " MESSAGE Msg("Aulas Pendentes")
         @ 10,42 PROMPT " Consultas     " MESSAGE Msg("Consultas de aulas desmarcadas")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
            IF Acesso(3); AE_220(); ENDIF
         ELSEIF nMenu_22 = 2
            IF Acesso(3); AE_222(); ENDIF
         ELSEIF nMenu_22 = 3
            IF Acesso(3); AE_223(); ENDIF
         ELSEIF nMenu_22 = 4
            IF Acesso(3); AE_224(); ENDIF
         ELSEIF nMenu_22 = 5
            IF Acesso(3); AE_225(); ENDIF
         ELSEIF nMenu_22 = 6
            IF Acesso(3); AE_226(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 3
      Telas(5,41,7,54,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 06,42 PROMPT " Lan‡amento " MESSAGE Msg("Lan‡amento de Aulas Te¢ricas")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
           IF Acesso(3); AE_232(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 4
      Telas(5,41,8,54,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 06,42 PROMPT " Legisla‡Æo " MESSAGE Msg("Acompanhamento dos Exames de Legisla‡Æo")
         @ 07,42 PROMPT " Pr tico    " MESSAGE Msg("Acompanhamento dos Exames Pr ticos no DETRAN")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
            IF Acesso(3); AE_231(); ENDIF
         ELSEIF nMenu_22 = 2
            IF Acesso(3); AE_237(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 5
      Telas(7,41,10,52,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 08,42 PROMPT " Aulas   " MESSAGE Msg("Pagamento de Aulas")
         @ 09,42 PROMPT " Servi‡os" MESSAGE Msg("Pagamento de Servi‡os")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
            IF Acesso(3); AE_240(); ENDIF
         ELSEIF nMenu_22 = 2
            IF Acesso(3); AE_241(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 6
      Telas(9,41,12,52,1,YCORMENU,.T.)
      tela22 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 10,42 PROMPT " Geral   " MESSAGE Msg("Caixa Geral")
         @ 11,42 PROMPT " Individ." MESSAGE Msg("Caixa Individual")
         MENU TO nMenu_22

         IF nMenu_22 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_22 = 1
            IF Acesso(9); AE_271(nMenu_22); ENDIF
         ELSEIF nMenu_22 = 2
            IF Acesso(3); AE_271(nMenu_22); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela22)
      ENDDO
   ELSEIF nMenu_3 = 7
      IF Acesso(3); AE_290(); ENDIF
   ELSEIF nMenu_3 = 8
      Telas(13,41,20,63,1,YCORMENU,.T.)
      tela36 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 14,42 PROMPT " Lan‡ar Faturas     " MESSAGE Msg("Registrar Faturas a serem Pagas")
         @ 15,42 PROMPT " Baixa de Pagamento " MESSAGE Msg("Registrar Baixa de Pagamento de Faturas")
         @ 16,42 PROMPT " Cancelar Pagamento " MESSAGE Msg("Cancelamento de Pagamento de Fatura")
         @ 17,42 PROMPT " Contas em Atraso   " MESSAGE Msg("ImpressÆo de Faturas/Contas em Atraso")
         @ 18,42 PROMPT " Contas Pagas       " MESSAGE Msg("ImpressÆo de Faturas/Contas Pagas")
         @ 19,42 PROMPT " Contas a Pagar     " MESSAGE Msg("ImpressÆo de Faturas a Pagar")
         MENU TO nMenu_36

         IF nMenu_36 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_36 = 1
            IF Acesso(3); AE_250(); ENDIF
         ELSEIF nMenu_36 = 2
            IF Acesso(3); AE_251(); ENDIF
         ELSEIF nMenu_36 = 3
            IF Acesso(3); AE_252(); ENDIF
         ELSEIF nMenu_36 = 4
            IF Acesso(3); AE_255(); ENDIF
         ELSEIF nMenu_36 = 5
            IF Acesso(3); AE_256(); ENDIF
         ELSEIF nMenu_36 = 6
            IF Acesso(3); AE_257(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela36)
      ENDDO
   ELSEIF nMenu_3 = 9
      IF Acesso(5); AE_280(); ENDIF
   ENDIF
ENDDO
