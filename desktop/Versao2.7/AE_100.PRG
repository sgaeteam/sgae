*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_100                           vrs 001 ³
*³ VRS 001        : Desenvolvimento                          ³
*³ FINALIDADE     : Menu de Cadastro                         ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 09/08/1994                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

Telas(2,7,19,22,1,YCORMENU,.T.)
LinhaMsg(2)
WHILE .T.
   SETCURSOR(0)
   SETCOLOR(YCORMENU)
   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

   cOpHelp1 := "1"; cOpHelp2 := "00"
   ProgName("AE100")

   @ 10,07 SAY "Ã"+REPL("Ä",14)+"´"
   @ 17,07 SAY "Ã"+REPL("Ä",14)+"´"
   @ 03,08 PROMPT " Alunos      " MESSAGE Msg("Cadastrar/Atualizar Alunos")
   @ 04,08 PROMPT " Instrutores  " MESSAGE Msg("Cadastrar/Atualizar Instrutores")
   @ 05,08 PROMPT " C.Pr tico   " MESSAGE Msg("Controle de Cursos Pr ticos")
   @ 06,08 PROMPT " C.Te¢rico   " MESSAGE Msg("Controle de Cursos Te¢ricos")
   @ 07,08 PROMPT " Feriados     " MESSAGE Msg("Cadastrar/Atualizar Feriados")
   @ 08,08 PROMPT " Pre‡os       " MESSAGE Msg("Cadastrar/Atualizar Tabela de Pre‡os de Servi‡os")
   @ 09,08 PROMPT " Mensagens    " MESSAGE Msg("Cadastrar/Atualizar Mensagem Impresso na Programa‡Æo de Aulas")
   @ 11,08 PROMPT " Financeiro  " MESSAGE Msg("Cadastrar/Atualizar Controle Financeiro Cont bil")
   @ 12,08 PROMPT " Cta. Corrente" MESSAGE Msg("Cadastrar/Atualizar Contas Correntes em Bancos")
   @ 13,08 PROMPT " Estoque      " MESSAGE Msg("Cadastrar/Atualizar Estoque")
   @ 14,08 PROMPT " Fornecedor   " MESSAGE Msg("Cadastrar/Atualizar Fornecedores")
   @ 15,08 PROMPT " ***********  " MESSAGE Msg("")
   @ 16,08 PROMPT " Tab.Consumos " MESSAGE Msg("Cadastrar/Atualizar Tabela de Consumos")
   @ 18,08 PROMPT " Senhas      " MESSAGE Msg("Cadastrar/Atualizar Senhas de Acesso")
   MENU TO nMenu_2

   IF nMenu_2 = 0
      Rest_Tela(); LinhaMsg(1); RETURN
   ENDIF

   SETKEY(K_LEFT,NIL)
   SETKEY(K_RIGHT,NIL)

   IF nMenu_2 = 1
      Telas(3,22,10,39,1,YCORMENU,.T.)
      tela44 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 04,23 PROMPT " Cons/Alt/Exclui" MESSAGE Msg("Consultar, Alterar ou Excluir Alunos")
         @ 05,23 PROMPT " Matr¡cula      " MESSAGE Msg("Matricular Alunos")
         @ 06,23 PROMPT " Certificados  " MESSAGE Msg("Certificados Expedidos aos Alunos")
         @ 07,23 PROMPT " LADV           " MESSAGE Msg("Controle de LADV")
         @ 08,23 PROMPT " Pendˆncias     " MESSAGE Msg("Pendˆncias de Alunos")
         @ 09,23 PROMPT " Requerimentos " MESSAGE Msg("Requerimentos de Alunos")
         MENU TO nMenu_44

         IF nMenu_44 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_44 >= 1 .AND. nMenu_44 <=2
            IF Acesso(3); AE_110(nMenu_44); ENDIF
         ELSEIF nMenu_44 = 3
            Telas(6,39,10,51,1,YCORMENU,.T.)
            tela34 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 07,40 PROMPT " Expedi‡Æo " MESSAGE Msg("Certificados expedidos aos alunos")
               @ 08,40 PROMPT " Consulta  " MESSAGE Msg("Consulta de certificados expedidos")
               @ 09,40 PROMPT " ImpressÆo " MESSAGE Msg("ImpresÆo de certificados")
               MENU TO nMenu_34

               IF nMenu_34 = 0
                  LinhaMsg(1); Rest_Tela(); EXIT
               ELSEIF nMenu_34 == 1
                  IF Acesso(3); AE_111(); ENDIF
               ELSEIF nMenu_34 == 2
                  IF Acesso(3); AE_113(); ENDIF
               ELSEIF nMenu_34 == 3
                  IF Acesso(3); AE_114(); ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela34)
            ENDDO
         ELSEIF nMenu_44 = 4
            IF Acesso(3); AE_112(); ENDIF
         ELSEIF nMenu_44 = 5
            IF Acesso(3); AE_115(); ENDIF
         ELSEIF nMenu_44 = 6
            Telas(9,39,13,56,1,YCORMENU,.T.)
            tela54 := SAVESCREEN(0,0,24,79)
            LinhaMsg(2)
            WHILE .T.
               SETCOLOR(YCORMENU)
               @ 10,40 PROMPT " Registro/Cons. " MESSAGE Msg("Registro de Requerimentos e Consulta")
               @ 11,40 PROMPT " Consulta Setor " MESSAGE Msg("Consultas por Setor")
               @ 12,40 PROMPT " Cons. Situa‡Æo " MESSAGE Msg("Consultas por Situa‡Æo")
               MENU TO nMenu_54

               IF nMenu_54 = 0
                  LinhaMsg(1); Rest_Tela(); EXIT
               ELSEIF nMenu_54 == 1
                  IF Acesso(3); AE_116(); ENDIF
               ELSEIF nMenu_54 == 2
                  IF Acesso(3); AE_117(); ENDIF
               ELSEIF nMenu_54 == 3
                  Aviso("Em breve estar  dispon¡vel...")
*                 IF Acesso(3); AE_118(); ENDIF
               ENDIF
               RESTSCREEN(0,0,24,79,tela54)
            ENDDO
         ENDIF
      ENDDO
   ELSEIF nMenu_2 = 2
      IF Acesso(5); AE_120(); ENDIF
   ELSEIF nMenu_2 = 3
      Telas(5,22,10,35,1,YCORMENU,.T.)
      tela44 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 06,23 PROMPT " Ve¡culos   " MESSAGE Msg("Cadastrar/Atualizar Ve¡culos")
         @ 07,23 PROMPT " Categorias " MESSAGE Msg("Cadastrar/Atualizar Categorias")
         @ 08,23 PROMPT " Conte£do P." MESSAGE Msg("Cadastrar/Atualizar Conte£do Program tico")
         @ 09,23 PROMPT " Infra‡äes  " MESSAGE Msg("Cadastrar/Atualizar Infra‡äes Veiculares")
         MENU TO nMenu_44

         IF nMenu_44 = 0
            LinhaMsg(1); EXIT
         ELSEIF nMenu_44 == 1
            IF Acesso(5); AE_130(); ENDIF
         ELSEIF nMenu_44 == 2
            IF Acesso(9); AE_152(); ENDIF
         ELSEIF nMenu_44 == 3
            IF Acesso(5); AE_147(); ENDIF
         ELSEIF nMenu_44 == 4
            IF Acesso(5); AE_150(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela44)
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_2 = 4
      Telas(6,22,13,37,1,YCORMENU,.T.)
      tela44 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 07,23 PROMPT " Cursos       " MESSAGE Msg("Atualizar Tabela de Cursos")
         @ 08,23 PROMPT " Disciplinas  " MESSAGE Msg("Atualizar Tabela de Disciplinas")
         @ 09,23 PROMPT " Escalas      " MESSAGE Msg("Atualizar Tabela de Escalas")
         @ 10,23 PROMPT " Turmas       " MESSAGE Msg("Atualizar Turmas")
         @ 11,23 PROMPT " Salas/Vagas  " MESSAGE Msg("Atualizar Tabela de Salas/Vagas")
         @ 12,23 PROMPT " Grade        " MESSAGE Msg("Atualizar Grade de Distribui‡Æo das Disciplinas")
         MENU TO nMenu_44

         IF nMenu_44 = 0
            LinhaMsg(1); EXIT
         ELSEIF nMenu_44 == 1
            IF Acesso(5); AE_141(); ENDIF
         ELSEIF nMenu_44 == 2
            IF Acesso(5); AE_142(); ENDIF
         ELSEIF nMenu_44 == 3
            IF Acesso(5); AE_143(); ENDIF
         ELSEIF nMenu_44 == 4
            IF Acesso(5); AE_144(); ENDIF
         ELSEIF nMenu_44 == 5
            IF Acesso(5); AE_145(); ENDIF
         ELSEIF nMenu_44 == 6
            IF Acesso(5); AE_146(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela44)
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_2 = 5
      IF Acesso(5); AE_140(); ENDIF
   ELSEIF nMenu_2 = 6
      IF Acesso(5); AE_151(); ENDIF
   ELSEIF nMenu_2 = 7
      IF Acesso(5); AE_160(); ENDIF
   ELSEIF nMenu_2 = 8
      Telas(11,22,16,37,1,YCORMENU,.T.)
      tela44 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 12,23 PROMPT " Itens Caixa  " MESSAGE Msg("Cadastrar/Atualizar Itens de Caixa")
         @ 13,23 PROMPT " Cont bil     " MESSAGE Msg("Cadastrar/Atualizar Plano de Contas")
         @ 14,23 PROMPT " Bancos       " MESSAGE Msg("Cadastrar/Atualizar Bancos Oficiais")
         @ 15,23 PROMPT " Adm. Cartäes " MESSAGE Msg("Cadastrar/Atualizar Administradoras de Cartäes de Cr‚dito")
         MENU TO nMenu_44

         IF nMenu_44 = 0
            LinhaMsg(1); EXIT
         ELSEIF nMenu_44 == 1
            IF Acesso(5); AE_170(); ENDIF
         ELSEIF nMenu_44 == 2
            IF Acesso(5); AE_173(); ENDIF
         ELSEIF nMenu_44 == 3
            IF Acesso(5); AE_171(); ENDIF
         ELSEIF nMenu_44 == 4
            IF Acesso(5); AE_172(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela44)
      ENDDO
      Rest_Tela()
   ELSEIF nMenu_2 = 9
      IF Acesso(5); AE_180(); ENDIF
   ELSEIF nMenu_2 = 10
      Aviso("Em desenvolvimento...")
*     IF Acesso(5); AE_171(); ENDIF
   ELSEIF nMenu_2 = 11
      IF Acesso(5); AE_181(); ENDIF
   ELSEIF nMenu_2 = 12
*     IF Acesso(5); AE_182(); ENDIF
   ELSEIF nMenu_2 = 13
      IF Acesso(5); AE_183(); ENDIF
   ELSEIF nMenu_2 = 14
      Telas(17,22,20,33,1,YCORMENU,.T.)
      tela44 := SAVESCREEN(0,0,24,79)
      LinhaMsg(2)
      WHILE .T.
         SETCOLOR(YCORMENU)
         @ 18,23 PROMPT " Usu rios " MESSAGE Msg("Cadastrar/Atualizar Tabela de Senhas/Usu rio")
         @ 19,23 PROMPT " Acessos  " MESSAGE Msg("Atualizar N¡veis de Acesso de Usu rios")
         MENU TO nMenu_44

         IF nMenu_44 = 0
            LinhaMsg(1); Rest_Tela(); EXIT
         ELSEIF nMenu_44 = 1
            IF Acesso(3); AE_191(); ENDIF
         ELSEIF nMenu_44 = 2
            IF Acesso(9); AE_192(); ENDIF
         ENDIF
         RESTSCREEN(0,0,24,79,tela44)
      ENDDO
   ENDIF
ENDDO
