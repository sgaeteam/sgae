*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_300                           vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Imprimir Relat¢rios do Sistema           ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE -  VIRTUAL          ³
*³ DATA CRIACAO   : 31/10/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

Telas(2,36,18,51,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "3"; cOpHelp2 := "00"
   ProgName("AE300")

   @ 08,36 SAY "Ã"+REPL("Ä",14)+"´"
   @ 12,36 SAY "Ã"+REPL("Ä",14)+"´"
   @ 16,36 SAY "Ã"+REPL("Ä",14)+"´"
   @ 03,37 PROMPT " Cadastrais  " MESSAGE Msg("Relat¢rios Cadastrais")
   @ 04,37 PROMPT " Pagamentos  " MESSAGE Msg("Relat¢rio de Pagamentos Pendentes e Efetuados")
   @ 05,37 PROMPT " Programa‡Æo " MESSAGE Msg("Relat¢rio de Programa‡Æo de Instrutores e Alunos")
   @ 06,37 PROMPT " Mala Direta " MESSAGE Msg("Imprimir Etiquetas")
   @ 07,37 PROMPT " Custos      " MESSAGE Msg("Relat¢rio de Custos de Manuten‡Æo de Ve¡culos")
   @ 09,37 PROMPT " Extratos    " MESSAGE Msg("Extratos de Conta Corrente")
   @ 10,37 PROMPT " 2¦ Via Docs. " MESSAGE Msg("Emite segunda via de documentos")
   @ 11,37 PROMPT " Horas Vagas  " MESSAGE Msg("Hor rios Vagos de Ve¡culos")
   @ 13,37 PROMPT " Hora Extra   " MESSAGE Msg("Relat¢rio Mensal de Horas Extras de Instrutores Pr ticos")
   @ 14,37 PROMPT " Estat¡sticos " MESSAGE Msg("Relat¢rio Estat¡sticos")
   @ 15,37 PROMPT " Gerenciais  " MESSAGE Msg("Relat¢rio Gerenciais")
   @ 17,37 PROMPT " DETRAN      " MESSAGE Msg("Relat¢rios exigidos pelo DETRAN")
   MENU TO nMenu_3

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_3 = 0
      Rest_Tela(); LinhaMsg(1); RETURN
   ELSEIF nMenu_3 = 1
      Telas(3,51,7,65,1,YCORMENU,.T.)
      tela31 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 04,52 PROMPT " Alunos      " MESSAGE Msg("Lista de Alunos")
         @ 05,52 PROMPT " Instrutores " MESSAGE Msg("Lista de Instrutores")
         @ 06,52 PROMPT " Ve¡culos    " MESSAGE Msg("Lista de Ve¡culos")
         MENU TO nMenu_31

         IF nMenu_31 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_31 = 1
            IF Acesso(1); AE_310(); ENDIF
         ELSEIF nMenu_31 = 2
            IF Acesso(1); AE_311(); ENDIF
         ELSEIF nMenu_31 = 3
            IF Acesso(1); AE_312(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela31)
      ENDDO
   ELSEIF nMenu_3 = 2
      Telas(4,51,8,63,1,YCORMENU,.T.)
      tela31 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 05,52 PROMPT " Efetuados " MESSAGE Msg("Pagamentos Efetuados")
         @ 06,52 PROMPT " Pendentes " MESSAGE Msg("Pagamentos Pendentes")
         @ 07,52 PROMPT " Cheques   " MESSAGE Msg("Cheques Recebidos")
         MENU TO nMenu_31

         IF nMenu_31 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_31 = 1
            IF Acesso(5); AE_320(); ENDIF
         ELSEIF nMenu_31 = 2
            IF Acesso(5); AE_321(); ENDIF
         ELSEIF nMenu_31 = 3
            IF Acesso(5); AE_322(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela31)
      ENDDO
   ELSEIF nMenu_3 = 3
      Telas(5,51,9,63,1,YCORMENU,.T.)
      tela31 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 06,52 PROMPT " Aluno     " MESSAGE Msg("Programa‡Æo por Aluno")
         @ 07,52 PROMPT " Instrutor " MESSAGE Msg("Programa‡Æo por Instrutor")
         @ 08,52 PROMPT " Exames    " MESSAGE Msg("Programa‡Æo de Exames")
         MENU TO nMenu_31

         IF nMenu_31 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_31 = 1
            IF Acesso(3); AE_330(); ENDIF
         ELSEIF nMenu_31 = 2
            IF Acesso(3); AE_331(); ENDIF
         ELSEIF nMenu_31 = 3
            IF Acesso(3); AE_332(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela31)
      ENDDO
   ELSEIF nMenu_3 = 4
      Telas(6,51,9,66,1,YCORMENU,.T.)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 07,52 PROMPT " Alunos       " MESSAGE Msg("Etiqueta de Alunos")
         @ 08,52 PROMPT " Fornecedores " MESSAGE Msg("Etiqueta de Fornecedores")
         MENU TO nMenu_37

         IF nMenu_37 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_37 = 1
            IF Acesso(3); AE_341(); ENDIF
         ELSEIF nMenu_37 = 2
             IF Acesso(3); AE_342(); ENDIF
         ENDIF
      ENDDO
   ELSEIF nMenu_3 = 5
      Telas(7,51,10,63,1,YCORMENU,.T.)
      tela37 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 08,52 PROMPT " Sint‚tico " MESSAGE Msg("Relat¢rio Resumido dos Consumos")
         @ 09,52 PROMPT " Anal¡tico " MESSAGE Msg("Relat¢rio Geral de Lan‡amento de Consumos")
         MENU TO nMenu_37

         IF nMenu_37 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_37 = 1
            IF Acesso(3); AE_350(); ENDIF
         ELSEIF nMenu_37 = 2
            IF Acesso(3); AE_351(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela37)
      ENDDO
   ELSEIF nMenu_3 = 6
      Telas(8,51,11,62,1,YCORMENU,.T.)
      tela37 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 09,52 PROMPT " Conta    " MESSAGE Msg("Extrato da Conta Corrente")
         @ 10,52 PROMPT " Por Item " MESSAGE Msg("Extrato simplificado por Item")
         MENU TO nMenu_37

         IF nMenu_37 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_37 = 1
            IF Acesso(3); AE_371(); ENDIF
         ELSEIF nMenu_37 = 2
            IF Acesso(3); AE_372(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela37)
      ENDDO
   ELSEIF nMenu_3 = 7
      IF Acesso(3); AE_380(); ENDIF   // 2a via documentos
   ELSEIF nMenu_3 = 8
      IF Acesso(3); AE_390(); ENDIF
   ELSEIF nMenu_3 = 9
      IF Acesso(3); AE_391(); ENDIF
   ELSEIF nMenu_3 = 10
      Telas(14,51,21,69,1,YCORMENU,.T.)
      tela03 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 15,52 PROMPT " Atividades      " MESSAGE Msg("Relat¢rio Mensal de Atividades")
         @ 16,52 PROMPT " Aulas           " MESSAGE Msg("Relat¢rio Aulas Ministradas")
         @ 17,52 PROMPT " Certificados    " MESSAGE Msg("Certificados Emitidos no periodo")
         @ 18,52 PROMPT " Matriculas      " MESSAGE Msg("Matriculas por periodo")
         @ 19,52 PROMPT " Aniversariantes " MESSAGE Msg("Aniversariantes no periodo")
         @ 20,52 PROMPT " Exames          " MESSAGE Msg("Relat¢rio de Resultados de Exames no DETRAN")
         MENU TO nMenu_03

         IF nMenu_03 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_03 = 1
            IF Acesso(3); AE_301(); ENDIF
         ELSEIF nMenu_03 = 2
            IF Acesso(3); AE_302(); ENDIF
         ELSEIF nMenu_03 = 3
            IF Acesso(3); AE_303(); ENDIF
         ELSEIF nMenu_03 = 4
            IF Acesso(3); AE_304(); ENDIF
         ELSEIF nMenu_03 = 5
            IF Acesso(3); AE_305(); ENDIF
         ELSEIF nMenu_03 = 6
            Aviso("Em desenvolvimento...",,2)
*            IF Acesso(3); AE_306(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela03)
      ENDDO
   ELSEIF nMenu_3 = 11
      Telas(15,51,19,69,1,YCORMENU,.T.)
      tela11 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 16,52 PROMPT " Meio de Procura " MESSAGE Msg("Relat¢rio de Meios de Procura do Curso")
         @ 17,52 PROMPT " Pesq. Automovel " MESSAGE Msg("Relat¢rio de Pesquisa de Acesso de Alunos a Automovel")
         @ 18,52 PROMPT " *************** " MESSAGE Msg("Relat¢rio ainda a definir")
         MENU TO nMenu_11

         IF nMenu_11 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_11 = 1
            IF Acesso(3); AE_361(); ENDIF
         ELSEIF nMenu_11 = 2
            IF Acesso(3); AE_362(); ENDIF
         ELSEIF nMenu_11 = 3
            Aviso("Em desenvolvimento...",,2)
*           IF Acesso(3); AE_363(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela11)
      ENDDO
   ELSEIF nMenu_3 = 12
      Telas(17,51,19,66,1,YCORMENU,.T.)
      tela03 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 18,52 PROMPT " Certificados " MESSAGE Msg("Certificados Emitidos Sequencia")
         MENU TO nMenu_03

         IF nMenu_03 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_03 = 1
            IF Acesso(3); AE_381(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela03)
      ENDDO
   ENDIF
ENDDO
