*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_PROC                          vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Procedimentos Auxiliares                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 09/08/1994                               ณ
*ณ ATUALIZACAO    : 22/02/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

*ีออออออออออออออออออออออออออออออธ
*ณ Programaฦo Manual           ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Incluir(msg)
   LOCAL nReg_Ant := RECNO(), lInc := .F.

   IF VALTYPE(cArq1)=="L"; cArq1:=""; ENDIF
   SETCOLOR(YCOREDIT)
   cArea := ALIAS()
   IF cArea=="USER"
      Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
      @ 17,3 SAY "Chave   :"
      @ 18,3 SAY "Usu rio :"
      @ 19,3 SAY "Senha   :"
   ENDIF

   DBGOBOTTOM()
   WHILE .T.
      IF cArea=="USER"
         cMsg_Aux := "Senha"
         cCod3    := SPACE(4)
         cSetor   := SPACE(30)
         cSenha   := ""
         Mensagem("Preencha com o Nฃmero da Chave")
         @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)

      SELECT (cArea)
      IF LASTKEY() == K_ESC
         GO nReg_Ant; EXIT
      ENDIF

      IF !DBSEEK (cCod3)
         WHILE .T.
            IF cArea=="USER"
               Mensagem("Preencha com o Nome do Usu rio")
               cMsg_Aux := "Usu rio"
               @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
               SETCURSOR(1); READ; SETCURSOR(0)

               SET ORDER TO 1
               IF LASTKEY() == K_ESC
                  GO nReg_Ant
                  Rest_Tela(); Mensagem(msg)
                  RETURN(lInc)
               ENDIF

               LOCATE FOR ALLTRIM(USER->USUARIO) == ALLTRIM(cSetor)
               IF FOUND()
                  Aviso(cMsg_Aux+" j  Cadastrado",YCORAVISO,2)
                  LOOP
               ENDIF
            ENDIF
            EXIT
         ENDDO

         IF cArea=="USER"
            Mensagem("Informe a Senha com 6 dกgitos")
            cSenha := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF Confirma("Confirma Inclusฦo ?")
               IF NetApp()
                  lInc := .T.
                  REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                          _FIELD->USUARIO  WITH cSetor,;
                          _FIELD->SENHA    WITH Codifica(cSenha)
                  UNLOCK
                  DBCOMMITALL()
                  ProcOk("Gravado",.T.)
               ENDIF
               EXIT
            ENDIF
         ENDIF
      ELSE
         Aviso(cMsg_Aux+" j  Existente",YCORAVISO,2)
         LOOP
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela()
   Mensagem(msg)
   SETCURSOR(0)
   RETURN(lInc)
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Alterar(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   IF VALTYPE(cArq1)=="L"; cArq1:=""; ENDIF
   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser alterado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   cArea := ALIAS()
   SETCOLOR(YCOREDIT)
   IF cArea=="USER"
      IF cPrg=="AE192"
         IF CHAVE=="NET4"
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF
         cCod3  := _FIELD->NIVEL
         cSetor := ""

         IF nNivel==5
            IF cCod3 >= nNivel
               Aviso("Alteraฦo nฦo Autorizada...",,1.5)
               Mensagem(msg)
               RETURN(lAlt)
            ENDIF
         ENDIF

         Telas(16,2,18,39,c_nBorda,YCOREDIT,.T.," Alteraฦo ")
         @ 17,3 SAY "Nกvel   :"
      ELSE
         // Tentativa de alteracao de chave de outro usuario
         IF cChave # CHAVE
            Aviso("Acesso Negado...",,1.5)
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         cCod3 := _FIELD->CHAVE
         IF cCod3=="NET4"
            Aviso("Este registro NO pode ser alterado!. Tecle algo...")
            Mensagem(msg)
            RETURN(lAlt)
         ENDIF

         Telas(16,2,20,39,c_nBorda,YCOREDIT,.T.," Alteraฦo ")
         cSetor := _FIELD->USUARIO
         cSenha := ""
         @ 17,3 SAY "Chave   :"
         @ 18,3 SAY "Usu rio :"
         @ 19,3 SAY "Senha   :"
      ENDIF
   ENDIF

   cCod3_Ant  := cCod3
   cSetor_Ant := cSetor
   lMudou     := .F.

   WHILE .T.
      IF cArea=="USER"
         IF cPrg=="AE192"
            Mensagem("Informe o Nกvel de Acesso do Usu rio")
            @ 17,13 GET cCod3 PICT "9" COLOR YCOREDIT VALID TNivel(cCod3)
         ELSE
            cMsg_Aux := "Chave"
            @ 17,13 GET cCod3  PICT "@!"
            @ 18,13 GET cSetor PICT "@!S25"
            CLEAR GETS
            Mensagem("Preencha com a Nova Chave do Usu rio")
            @ 17,13 GET cCod3 PICT "@!" VALID !EMPTY(cCod3) COLOR YCOREDIT
         ENDIF
      ENDIF
      SETCURSOR(1); READ; SETCURSOR(0)
      SELECT (cArea)

      IF LASTKEY() == K_ESC; EXIT; ENDIF

      IF cCod3 # cCod3_Ant
         IF DBSEEK (cCod3)
            Aviso(cMsg_Aux+" j  Cadastrado.",YCORAVISO,2)
            GO nReg_Ant
            cCod3  := cCod3_Ant
            lMudou := .F.
            LOOP
         ELSE
            GO nReg_Ant
            lMudou := .T.
         ENDIF
      ENDIF

      WHILE .T.
        IF cArea=="USER"
           IF cPrg=="AE192"; EXIT; ENDIF
           Mensagem("Preencha com o Nome do Usu rio")
           cMsg_Aux := "Usu rio"
           @ 18,13 GET cSetor PICT "@!S25" VALID !EMPTY(cSetor) COLOR YCOREDIT
           SETCURSOR(1); READ; SETCURSOR(0)

           IF LASTKEY() == K_ESC
              SET ORDER TO 1
              GO nReg_Ant
              Rest_Tela(); Mensagem(msg)
              RETURN(lAlt)
           ENDIF

           IF cSetor # cSetor_Ant
              SET ORDER TO 1
              LOCATE FOR ALLTRIM(USER->USUARIO)==ALLTRIM(cSetor)
              IF FOUND()
                 Aviso(cMsg_Aux+" j  Cadastrado",YCORAVISO,2)
                 GO nReg_Ant
                 LOOP
              ELSE
                 GO nReg_Ant
                 lMudou := .T.
              ENDIF
           ENDIF
         ENDIF
         EXIT
      ENDDO

      IF cArea=="USER"
         IF cPrg=="AE192"
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Alteraฦo ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->NIVEL WITH cCod3
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Alterado",.T.)
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ELSE
            Mensagem("Informe a Senha com 6 dกgitos")
            cPassAnt := Codifica(_FIELD->SENHA)
            cSenha   := Test_Entry(19,13,6,cSenha,"PW",YCOREDIT)
            IF LASTKEY()==K_ESC .OR. LASTKEY()==K_TAB
               Rest_Tela()
               Mensagem(msg)
               SETCURSOR(0)
               RETURN(.F.)
            ENDIF
            IF cSenha # cPassAnt ; lMudou := .T. ; ENDIF
            IF UPDATED() .OR. lMudou
               IF Confirma("Confirma Alteraฦo ?")
                  IF NetLReg()
                     lAlt := .T.
                     REPLACE _FIELD->CHAVE    WITH cCod3 ,;
                             _FIELD->USUARIO  WITH cSetor,;
                             _FIELD->SENHA    WITH Codifica(cSenha)
                     UNLOCK
                     DBCOMMITALL()
                     ProcOk("Alterado",.T.)
                  ENDIF
                  EXIT
               ENDIF
            ELSEIF !UPDATED() .AND. !lMudou
               EXIT
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   SET ORDER TO 1
   Rest_Tela(); Mensagem(msg)
   GO nReg_Ant
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Excluir(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser eliminado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF ALIAS()=="USER"
      wChave := _FIELD->CHAVE
      IF nNivel < 5
         IF cChave==wChave
            Aviso("Usu rio est  ativo! Registro Mantido.",YCORAVISO,3)
         ELSE
            Aviso("Usu rio nฦo Autorizado! Tecle algo...")
         ENDIF
      ELSEIF nNivel >= 5
         IF cChave==wChave
            Aviso("Usu rio est  ativo! Registro Mantido.",YCORAVISO,3)
         ELSEIF cChave # wChave .AND. NIVEL > nNivel
            Aviso("Acesso Negado...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL == nNivel
            Aviso("Exclusฦo Negada...",,1.5)
         ELSEIF cChave # wChave .AND. NIVEL < nNivel
            IF wChave=="NET4"
               Aviso("Usu rio NO pode ser Excluกdo! Tecle algo...")
            ELSE
               IF NetLReg()
                  lExcl := .T.
                  DBDELETE(); UNLOCK
               ENDIF
            ENDIF
         ENDIF
      ENDIF
   ELSE
      IF NetLReg()
         lExcl := .T.
         DBDELETE(); UNLOCK
      ENDIF
   ENDIF
   IF lExcl ; ProcOk("Eliminado",.T.) ; ENDIF
   Mensagem(msg)
   RETURN(lExcl)
*ีออออออออออออออออออออออออออออออธ
*ณ Localizar Registro no Browse ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Localizar(msg)
   LOCAL nReg_Ant := RECNO(), lLoc := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Localizado !",YCORAVISO,2)
      Mensagem(msg)
      RETURN(lLoc)
   ENDIF
   GO nReg_Ant

   cArea  := ALIAS()
   cOrdem := INDEXORD()
   SETCOLOR(YCOREDIT)
   Telas(16,8,19,60,c_nBorda,YCOREDIT,.T.)
   MsgTela(16,10," Localizar ")
   WHILE .T.
      pChave := SPACE(50)
      @ 18,10 SAY "Tกtulo:" GET pChave PICT "@!S41"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC.OR.EMPTY(pChave); EXIT; ENDIF

      lLoc:=Pesquisa(cArea,cOrdem,ALLTRIM(pChave),"Registro nฦo Localizado!")
      IF !lLoc
         GO nReg_Ant
      ELSE
         EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   RETURN(lLoc)
*ีออออออออออออออออออออออออออออออธ
*ณ Auxilio de Entrada de Dados  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION HTela(nPar)
   SETCURSOR(0)
   IF nPar==1
      Telas(13,38,18,58,1,YCORAVISO,.T.)
      @ 14,39 SAY "S - Solteiro(a)"   COLOR YCORAVISO
      @ 15,39 SAY "C - Casado(a)"     COLOR YCORAVISO
      @ 16,39 SAY "D - Desquitado(a)" COLOR YCORAVISO
      @ 17,39 SAY "V - Viฃvo(a)"      COLOR YCORAVISO
   ELSEIF nPar==2
      Telas(12,51,15,62,1,YCORAVISO,.T.)
      @ 13,52 SAY "S - Sim "   COLOR YCORAVISO
      @ 14,52 SAY "N - Nฦo "   COLOR YCORAVISO
   ELSEIF nPar==3
      Telas(12,51,17,66,1,YCORAVISO,.T.)
      @ 13,52 SAY "E - Escola"     COLOR YCORAVISO
      @ 14,52 SAY "R - Residncia" COLOR YCORAVISO
      @ 15,52 SAY "P - Pa.NS Luz" COLOR YCORAVISO
      @ 16,52 SAY "O - Outros"     COLOR YCORAVISO
   ELSEIF nPar==4
      Telas(14,25,18,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "C - Carteira" COLOR YCORAVISO
      @ 16,26 SAY "B - Banco"    COLOR YCORAVISO
      @ 17,26 SAY "O - Outros"   COLOR YCORAVISO
   ELSEIF nPar==5
      Telas(18,25,21,41,1,YCORAVISO,.T.)
      @ 19,26 SAY "T - Tela"       COLOR YCORAVISO
      @ 20,26 SAY "I - Impressora" COLOR YCORAVISO
   ELSEIF nPar==6
      Telas(14,25,18,41,1,YCORAVISO,.T.)
      @ 15,26 SAY "D - Dinheiro"    COLOR YCORAVISO
      @ 16,26 SAY "C - Cheque"      COLOR YCORAVISO
      @ 17,26 SAY "A - Dinh/Cheque" COLOR YCORAVISO
   ELSEIF nPar==7
      Telas(14,25,17,41,1,YCORAVISO,.T.)
      @ 15,26 SAY "P - Pr tico"     COLOR YCORAVISO
      @ 16,26 SAY "S - Sinais"      COLOR YCORAVISO
   ELSEIF nPar==8
      Telas(14,25,18,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "1 - Pr tico"     COLOR YCORAVISO
      @ 16,26 SAY "2 - Teขrico"     COLOR YCORAVISO
      @ 17,26 SAY "3 - Ambos"       COLOR YCORAVISO
   ELSEIF nPar==9
      Telas(14,25,19,39,1,YCORAVISO,.T.)
      @ 15,26 SAY "1 - Manhฦ"       COLOR YCORAVISO
      @ 16,26 SAY "2 - Tarde"       COLOR YCORAVISO
      @ 17,26 SAY "3 - Noite"       COLOR YCORAVISO
      @ 18,26 SAY "4 - Integral"    COLOR YCORAVISO
   ELSEIF nPar==10
      Telas(12,51,18,66,1,YCORAVISO,.T.)
      @ 13,52 SAY "1 - Apto"       COLOR YCORAVISO
      @ 14,52 SAY "2 - Inapto"     COLOR YCORAVISO
      @ 15,52 SAY "3 - Remarcado"  COLOR YCORAVISO
      @ 16,52 SAY "4 - Faltou"     COLOR YCORAVISO
      @ 17,52 SAY "9 - S/Exame"    COLOR YCORAVISO
   ELSEIF nPar==11
      Telas(15,10,18,25,1,YCORAVISO,.T.)
      @ 16,12 SAY "E - Exame"      COLOR YCORAVISO
      @ 17,12 SAY "R - Reforo"    COLOR YCORAVISO
   ELSEIF nPar==12
      Telas(12,20,16,29,1,YCORAVISO,.T.)
      @ 13,22 SAY "1ฆ Via"  COLOR YCORAVISO
      @ 14,22 SAY "2ฆ Via"  COLOR YCORAVISO
      @ 15,22 SAY "Troca "  COLOR YCORAVISO
   ELSEIF nPar==13
      Telas(7,25,13,63,1,YCORAVISO,.T.)
      @ 08,26 SAY "1 - Tem carro com seguro"            COLOR YCORAVISO
      @ 09,26 SAY "2 - Tem carro sem seguro"            COLOR YCORAVISO
      @ 10,26 SAY "3 - Nฦo tem carro, quer comprar"     COLOR YCORAVISO
      @ 11,26 SAY "4 - Nฦo tem carro, nฦo pode comprar" COLOR YCORAVISO
      @ 12,26 SAY "5 - Tem carro, mas quer trocar"      COLOR YCORAVISO
   ELSEIF nPar==14
      Telas(7,25,18,47,1,YCORAVISO,.T.,"Fonte Marketing")
      @ 08,26 SAY "1 - Indicaฦo"  COLOR YCORAVISO
      @ 09,26 SAY "2 - Panfleto"   COLOR YCORAVISO
      @ 10,26 SAY "3 - โnibus"     COLOR YCORAVISO
      @ 11,26 SAY "4 - Telelista"  COLOR YCORAVISO
      @ 12,26 SAY "5 - Editel"     COLOR YCORAVISO
      @ 13,26 SAY "6 - Outdoor"    COLOR YCORAVISO
      @ 14,26 SAY "7 - Internet"   COLOR YCORAVISO
      @ 15,26 SAY "8 - TV/R dio"   COLOR YCORAVISO
      @ 16,26 SAY "9 - Jornal"     COLOR YCORAVISO
      @ 17,26 SAY "0 - Outro"      COLOR YCORAVISO
   ELSEIF nPar==15
      Telas(7,25,15,47,1,YCORAVISO,.T.,"Setor")
      @ 08,26 SAY "0 - Todos"      COLOR YCORAVISO
      @ 09,26 SAY "1 - Recepฦo"   COLOR YCORAVISO
      @ 10,26 SAY "2 - Secretaria" COLOR YCORAVISO
      @ 11,26 SAY "3 - Financeiro" COLOR YCORAVISO
      @ 12,26 SAY "4 - Administ."  COLOR YCORAVISO
      @ 13,26 SAY "5 - Supervisฦo" COLOR YCORAVISO
      @ 14,26 SAY "6 - Diretoria"  COLOR YCORAVISO
   ELSEIF nPar==16
      Telas(7,25,15,47,1,YCORAVISO,.T.,"Setor")
      @ 08,26 SAY "1 - Resolvido"     COLOR YCORAVISO
      @ 09,26 SAY "2 - Nฦo Resolvido" COLOR YCORAVISO
      @ 10,26 SAY "3 - Pendente"      COLOR YCORAVISO
   ENDIF
   SETCURSOR(1)
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Testar tecla digitada Auxilioณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION VTela(nPar)
  LOCAL lOk:=.F.
  IF nPar==1
     lOk:=IF(wCivil $ "SCDV",.T.,.F.)
  ELSEIF nPar==2
     lOk:=IF(wSN $ "SN",.T.,.F.)
  ELSEIF nPar==3
     lOk:=IF(wEmbarq $ "ERPO",.T.,.F.)
  ELSEIF nPar==4
     lOk:=IF(wCobranca $ "CBO",.T.,.F.)
  ELSEIF nPar==5
     lOk:=IF(wDevice $ "TI",.T.,.F.)
  ELSEIF nPar==6
     lOk:=IF(wForma $ "DCA",.T.,.F.)
  ELSEIF nPar==7
     lOk:=IF(wTipo $ "PS",.T.,.F.)
  ELSEIF nPar==8
     lOk:=IF(wCateg $ "123",.T.,.F.)
  ELSEIF nPar==9
     lOk:=IF(vTurno $ "1234",.T.,.F.)
  ELSEIF nPar==10
     lOk:=IF(wResultado $ "12349",.T.,.F.)
  ELSEIF nPar==11
     lOk:=IF(wTipo $ "ER",.T.,.F.)
  ELSEIF nPar==12
     lOk:=IF(wSit $ "12T",.T.,.F.)
  ELSEIF nPar==13
     lOk:=IF(wAuto $ "12345",.T.,.F.)
  ELSEIF nPar==14
     lOk:=IF(wPesq $ "1234567890",.T.,.F.)
  ELSEIF nPar==15
     IF SUBS(xSetor,1,1) $ "0123456" .OR. SUBS(xSetor,2,1) $ "0123456" .OR. SUBS(xSetor,3,1) $ "0123456"
        lOk:=.T.
     ELSE
        lOk:=.F.
     ENDIF
  ELSEIF nPar==16
     lOk:=IF(xPrazo $ "123",.T.,.F.)
  ENDIF
  IF lOk;Rest_Tela();ENDIF
  RETURN lOk
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Arquivo Temporario   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION DelDbfNtx()
   DBCLOSEALL()
   fDbf1:=cArq1+".DBF"
   fNtx1:=cArq1+".NTX"
   ERASE (fDbf1); ERASE (fNtx1)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Arquivo Temporario   ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION DelDbfNtx2()
   DBCLOSEALL()
   fDbf2:=cArq2+".DBF"
   fNtx2:=cArq2+".NTX"
   ERASE (fDbf2); ERASE (fNtx2)
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Nome do Programa em Execuฦo ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE ProgName(prg)
   @ 01,00 SAY prg COLOR "W/R"
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Exibe linha Msg p/teclas funcณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION LinhaMsg(modo)
   LOCAL corant := SETCOLOR()
   DEFAULT modo TO 1
   IF modo == 1
      Linha23("^ESC^-Saกda ^F4^-Calculadora ^F5^-Calend rio",24)
   ELSEIF modo==2
      Linha23("^ESC^-Retorna ^F4^-Calculadora ^F5^-Calend rio",24)
   ELSEIF modo==3
      Linha23("^ESC^-Finaliza ^^-Movimentaฦo ^ENTER^-Altera",24)
   ELSEIF modo==4
      Linha23("^ESC^-Retorna  ^F2^-Altera ^F6^-Inclui ^ALT+E^-Exclui",24)
   ELSEIF modo==5
      Linha23("^ESC^-Abandona ^^-Cor da Letra  ^<- ->^-Cor do Fundo  ^ENTER^-Confirma",24)
   ELSEIF modo==6
      Linha23("^ESC^-Cancela",24)
   ELSEIF modo==7
      Linha23("^ESC^-Retorna ^F4^-Calculadora ^F5^-Calend rio ^F9^-Imprime",24)
   ELSEIF modo==8
      Linha23("^ESC^-Volta ^F6^-Marca ^F8^-Vende+Aulas  ^F9^-Imprime ^F11^-Pesquisa Vagas",24)
   ELSEIF modo==9
      Linha23("^ESC^-Retorna  ^ENTER^-Efetua Pagamento  ^INS^-Inclui Pagamento",24)
   ELSEIF modo==10
      Linha23("^ESC^-Retorna ^F9^-Imprimir",24)
   ELSEIF modo==11
      Linha23("^ESC^-Retorna ^ENTER^-Registra Aula",24)
   ELSEIF modo==12
      Linha23("^ESC^-Retorna ^F2^-Ajuda ^F6^-Inclui ^ALT+E^-Exclui ^F9^-Imprime",24)
   ELSEIF modo==13
      Linha23("^ESC^-Retorna ^ENTER^-Marca/Desmarca ^F6^-Todos Canc ^F7^-Todos Ok",24)
   ENDIF
   SETCOLOR(corant)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho de Relatorios      ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE CabRel(pTexto,lPg)
   DEFAULT lPg TO .T.
   IF lPg; xpg++; ENDIF
   @ PROW()+1,05 SAY UPPER(cRazao1)
   @ PROW()+2,05 SAY pTexto
   @ PROW()+1,05 SAY "Data..: "+DTOC(DATE())
   IF lPg
      @ PROW()+1,05 SAY "Pagina:"+STRZERO(xpg,4)
   ENDIF
   @ PROW()+1,05 SAY ""
   RETURN
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome do Aluno     ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaAluno(pCod)
   ALUNO->(DBSEEK(pCod))
   RETURN(ALUNO->NOME)
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome do Instrutor ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaInst(pCod)
   INSTRUTOR->(DBSEEK(pCod))
   RETURN(INSTRUTOR->NOME)
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome da Escala    ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaEscala(pCod)
   ESCALA->(DBSEEK(pCod))
   RETURN(ESCALA->DESCR)
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome do Curso     ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaCurso(pCod)
   CURSO->(DBSEEK(pCod))
   RETURN(CURSO->DESCR)
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome da Disciplinaณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaDisc(pCod)
   DISCIPLINA->(DBSEEK(pCod))
   RETURN(DISCIPLINA->DESCR)
*ีออออออออออออออออออออออออออออออออธ
*ณ Capturar Codigo do Instrutor   ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION TCodInst(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->CODINST)
*ีออออออออออออออออออออออออออออออออธ
*ณ Capturar Marca do Veiculo      ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION TNomVeic(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->MARCA)
*ีออออออออออออออออออออออออออออออออธ
*ณ Capturar Placa do Veiculo      ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION PegaPlaca(pCod)
   VEICULO->(DBSETORDER(1))
   VEICULO->(DBSEEK(pCod))
   RETURN(VEICULO->PLACA)
*ีออออออออออออออออออออออออออออออออธ
*ณ Capturar Nome do Instrutor     ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION TNomInst(pCod)
   INSTRUTOR->(DBSETORDER(1))
   INSTRUTOR->(DBSEEK(pCod))
   RETURN(INSTRUTOR->NOME)
*ีอออออออออออออออออออออออออธ
*ณ Verifica Exist. do Item ณ
*ิอออออออออออออออออออออออออพ
FUNCTION TItem(pCod,lCond)
   DEFAULT lCond TO .T.
   ITEM->(DBSETORDER(1))
   IF lCond
      IF !ITEM->(DBSEEK(pCod))
         Aviso("Item Nฦo Cadastrado...",,3); RETURN .F.
      ENDIF
   ELSE
      IF ITEM->(DBSEEK(pCod))
         Aviso("Item j  Cadastrado...",,3); RETURN .F.
      ENDIF
   ENDIF
   RETURN(.T.)
*ีอออออออออออออออออออออออออธ
*ณ Pega Descr. do Item     ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaItem(pCod)
   ITEM->(DBSETORDER(1))
   ITEM->(DBSEEK(pCod))
   RETURN(ITEM->DESCR)
*ีออออออออออออออออออออออออออออออออธ
*ณ Verificar No da Fatura         ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION ChkFatura()
   IF l_f2
      cNF:= (carq1)->NF
      KEYBOARD CHR(K_ENTER)
      RETURN .T.
   ELSE
      RETURN Pesquisa(1,1,cCodEmp+cNFat,"Fatura Nฦo Cadastrada!")
   ENDIF
*ีออออออออออออออออออออออออออออออออธ
*ณ Testar se F2 foi pressionada   ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION TF2()
   IF l_f2
      cNF:= (carq1)->NF
      KEYBOARD CHR(K_ENTER)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Verificar Existencia de Movim. ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION ChkMov()
   IF CONTA->(DBSEEK(wConta+wNumDoc))
      Aviso("Documento j  Lanado no Movimento...",,3); RETURN .F.
   ENDIF
   RETURN .T.
*ีอออออออออออออออออออออออออธ
*ณ Pegar Nome do Fornecedorณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaForn(pCod)
   FORNECEDOR->(DBSEEK(pCod))
   RETURN(FORNECEDOR->RAZAO)
*ีอออออออออออออออออออออออออธ
*ณ Pegar Infraฦo          ณ
*ิอออออออออออออออออออออออออพ
FUNCTION PegaInfra(pCod)
   INFRACAO->(DBSEEK(pCod))
   RETURN(INFRACAO->DESCR)
*ีออออออออออออออออออออออออออออออธ
*ณ Checar se h  aulas pendentes ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TAulaPend()
  IF ALUNO->PENDENTE>0
     Aviso("Aluno tem aula(s) pendente(s)...",,3); RETURN .F.
  ENDIF
  RETURN .T.
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Pegar Nome do Veiculo                ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION PegaVeic(pVar)
  VEICULO->(DBSEEK(pVar))
  RETURN(VEICULO->MARCA)
*ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
*ณ                       PEDIR CONFIRMACAO DE OPCOES DE PAGAMENTO            ณ
*ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
FUNCTION ConfPgto(texto)
   LOCAL les,ces,largjan,telavelha

   confirm := .F.
   IF LASTKEY() = K_DEL
      Opcao := 2
   ENDIF

   largjan := LEN(texto)+8
   IF largjan < 16
      largjan := 16
   ENDIF

   ces       := (80-largjan)/2-5
   les       := 19
   telavelha := SAVESCREEN(les,0,les+4,79)
   corant    := SETCOLOR()
   cornova   := "N/W,W+/N"

   Sombra( les, ces, les+3, ces+LargJan, c_nLado )
   SETCOLOR(cornova)
   @ les,ces CLEAR TO les+3,ces+largjan
   @ les,ces TO les+3,ces+largjan DOUBLE
   @ les+1,ces+5 SAY texto
   coluna := (largjan-21)/2

   @ les+2,ces+coluna    PROMPT " Parcelado "
   @ les+2,ces+coluna+13 PROMPT "  A Vista  "
   MENU TO Opcao
   IF Opcao == 1
      confirm := .T.
   ENDIF
   SETCOLOR(corant)
   RESTSCREEN(les,0,les+4,79,telavelha)
   RETURN(confirm)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Pegar Nome do Operador/Usuario       ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION PegaUser(pVar)
  nCompl:=SPACE(20-LEN(SUBS(USER,1,AT(" ",USER)-1)))
  cNomUs:=SUBS(pVar,1,AT(" ",pVar)-1)+nCompl
  RETURN(cNomUs)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Identificar se Aluno  Ativo         ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION AlunoAtivo(pMatr)
   AULAS->(DBSEEK(pMatr))
   WHILE AULAS->MATRIC==pMatr.AND.AULAS->(!EOF())
      IF !AULAS->COBRADA.AND.!AULAS->STATUS
         RETURN(.T.)
      ENDIF
      AULAS->(DBSKIP())
   ENDDO
   RETURN(.F.)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Verificar prazo do Contrato          ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION ChkPrazo(pMatr)
   LOCAL xPrazo:=90; xTempo:=xNovoPrazo:=0; xLib:="N"

   ALUNO->(DBSEEK(pMatr))
   IF ALUNO->MARCADA=0
      IF ALUNO->LIB#"S"
         xTempo := DATE() - ALUNO->DTINSCR
         IF xTempo > (xPrazo+ALUNO->PRAZO)
            Aviso("Prazo para marcaฦo de aulas pr ticas expirado em "+ALLTRIM(STR(xTempo-(90+ALUNO->PRAZO)))+" dias",,3)
            IF nNivel=9
               Telas(13,15,16,55,1,YCOREDIT,.T.)
               xNovoPrazo:=ALUNO->PRAZO
               @ 14,17 SAY "Prazo prorrogado por (dias):" GET xNovoPrazo PICT "999"
               @ 15,17 SAY "Liberado - Taxa Paga (S/N) :" GET xLib       PICT "!" VALID LASTKEY()=K_UP.OR.xLib$"SN"
               SETCURSOR(1); READ; SETCURSOR(0)
               WHILE !ALUNO->(NetLReg()); ENDDO
               REPLACE ALUNO->PRAZO WITH xNovoPrazo,;
                       ALUNO->LIB   WITH xLib
               ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
               Rest_Tela()
               IF xLib="N".OR.xNovoPrazo=0
                  RETURN(.F.)
               ENDIF
               RETURN(.T.)
            ENDIF
            RETURN(.F.)
         ENDIF
      ENDIF
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Idade               ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CalcIdade(pHoje,pDtNas)
   IF MONTH(pDtNas) = MONTH(pHoje)
      IF DAY(pDtNas) <= DAY(pHoje)
         pIdade := YEAR(pHoje) - YEAR(pDtNas)
      ELSE
         pIdade := YEAR(pHoje) - YEAR(pDtNas)-1
      ENDIF
   ELSE
      IF MONTH(pDtNas) < MONTH(pHoje)
         pIdade := YEAR(pHoje) - YEAR(pDtNas)
      ELSE
         pIdade := YEAR(pHoje) - YEAR(pDtNas)-1
      ENDIF
   ENDIF
   RETURN(pIdade)
*ีออออออออออออออออออออออออออออออธ
*ณ Calcular Horario             ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION CalcHora(pTempo)
   LOCAL pHora:=pMin:=pHoraFim:=pAdic:=0
   IF VAL(LEFT(pTempo,2))>=18
      // Horario noturno
      pAdic:=45
   ELSE
      // Horario diurno
      pAdic:=50
   ENDIF
   pHora := VAL(LEFT(pTempo,2))
   pMin  := VAL(RIGHT(pTempo,2))
   IF (pAdic+pMin) >=60
      pHora := pHora+1
      pMin  := (pAdic+pMin)-60
   ELSE
      pMin := pMin + pAdic
   ENDIF
   pHoraFim := STRZERO(pHora,2)+":"+STRZERO(pMin,2)
   RETURN(pHoraFim)
*ีออออออออออออออออออออออออออออออออออออธ
*ณ Checar Baixa de Pendencia de Aluno ณ
*ิออออออออออออออออออออออออออออออออออออพ
PROCEDURE ChkPend(pMatr)
  Aguarde("Verificando Pendncias...")
  PENDENCIA->(DBSEEK(pMatr))
  WHILE PENDENCIA->MATRIC==pMatr.AND.!PENDENCIA->(EOF())
     IF !PENDENCIA->BAIXA
        Aguarde()
        Aviso("Aluno possui pendncia para providncia.")
        RETURN
     ENDIF
     PENDENCIA->(DBSKIP())
  ENDDO
  Aguarde()
  RETURN
*ีออออออออออออออออออออออออออออออออออออธ
*ณ Checar Pendencia de requerimento   ณ
*ิออออออออออออออออออออออออออออออออออออพ
PROCEDURE ChkPReq(pMatr)
  Aguarde("Verificando Pendncias...")
  REQ->(DBSEEK(pMatr))
  WHILE REQ->MATRIC==pMatr.AND.!REQ->(EOF())
     IF !REQ->SITUACAO#"1"
        Aguarde()
        Aviso("Aluno possui pendncia de requerimento.")
        RETURN
     ENDIF
     REQ->(DBSKIP())
  ENDDO
  Aguarde()
  RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Pegar Categoria do Instrutor ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION PegaCategInst(pCod)
   LOCAL cRet:=""
   IF INSTRUTOR->CATEG=="1"
      cRet := "Pr tico"
   ELSEIF INSTRUTOR->CATEG=="2"
      cRet := "Teขrico"
   ELSEIF INSTRUTOR->CATEG=="3"
      cRet := "Ambos  "
   ENDIF
   RETURN(cRet)
*ีออออออออออออออออออออออออออออออธ
*ณ Calcula tam. do nome+sobrenomณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TamNome(pNome)
   LOCAL pos1:=pos2:=nTam:=0,xTexto

   pos1   := AT(" ",pNome)
   xTexto := SUBS(pNome,pos1+1)
   pos2   := AT(" ",xTexto)
   nTam   := pos1+pos2-1
   RETURN(nTam)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar se  feriado          ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TFeriado(pData)
   LOCAL lRet:=.F.
   lRet:=FERIADO->(DBSEEK(SUBS(DTOC(pData),4,2)+LEFT(DTOC(pData),2)))
   RETURN(lRet)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar se dia  o da escala  ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TEscala(pData,pEscala)
   LOCAL lRet:=.F.

   ESCALA->(DBSEEK(pEscala))
   IF DOW(pData)==1       // Domingo
      IF !EMPTY(ESCALA->DOM); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==2   // Segunda
      IF !EMPTY(ESCALA->SEG); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==3   // Tera
      IF !EMPTY(ESCALA->TER); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==4   // Quarta
      IF !EMPTY(ESCALA->QUA); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==5   // Quinta
      IF !EMPTY(ESCALA->QUI); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==6   // Sexta
      IF !EMPTY(ESCALA->SEX); lRet:=.T.; ENDIF
   ELSEIF DOW(pData)==7   // S bado
      IF !EMPTY(ESCALA->SAB); lRet:=.T.; ENDIF
   ENDIF
   RETURN(lRet)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Gravar Numero do Lancamento          ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION GravaLan()
  zNLan := STRZERO(VAL(DBPARM->NLAN)+1,12)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->NLAN == zNLan
     zNLan := STRZERO(VAL(zNLan)+1,12)
  ENDIF
  REPLACE DBPARM->NLAN WITH zNLan
  DBPARM->(DBUNLOCK())
  RETURN(zNLan)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Gravar Numero da Turma               ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION GravaTurma()
  zNTurma := STRZERO(VAL(DBPARM->NTURMA)+1,6)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->NTURMA == zNTurma
     zNTurma := STRZERO(VAL(zNTurma)+1,6)
  ENDIF
  REPLACE DBPARM->NTURMA WITH zNTurma
  DBPARM->(DBUNLOCK())
  RETURN(zNTurma)
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Gravar Controle de recibos           ณ
*ิออออออออออออออออออออออออออออออออออออออพ
PROCEDURE Controle()
  zCR := STRZERO(VAL(DBPARM->CR)+1,5)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->CR == zCR
     zCR := STRZERO(VAL(zCR)+1,5)
  ENDIF
  REPLACE DBPARM->CR WITH zCR
  DBPARM->(DBUNLOCK())
  RETURN
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Gravar Numero do Requerimento        ณ
*ิออออออออออออออออออออออออออออออออออออออพ
FUNCTION GravaReq()
  zReq := LEFT(DBPARM->REQ,2)+STRZERO(VAL(RIGHT(DBPARM->REQ,5))+1,5)
  WHILE !DBPARM->(NetLReg()); ENDDO
  IF DBPARM->REQ == zReq
     zReq := LEFT(DBPARM->REQ,2)+STRZERO(VAL(RIGHT(DBPARM->REQ,5))+1,5)
  ENDIF
  REPLACE DBPARM->REQ WITH zReq
  DBPARM->(DBUNLOCK())
  RETURN(zReq)
*ีออออออออออออออออออออออออออออออออธ
*ณ Gravar Requerimentos - temp.   ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE GrvReq()
   (cArq1)->(DBAPPEND())
   REPLACE (cArq1)->REQ      WITH REQ->REQ     ,;
           (cArq1)->DATA     WITH REQ->DATA    ,;
           (cArq1)->HORA     WITH REQ->HORA    ,;
           (cArq1)->USER     WITH REQ->USER    ,;
           (cArq1)->NOME     WITH REQ->NOME    ,;
           (cArq1)->PRAZO    WITH REQ->PRAZO   ,;
           (cArq1)->MATRIC   WITH REQ->MATRIC  ,;
           (cArq1)->ASS1     WITH REQ->ASS1    ,;
           (cArq1)->ASS2     WITH REQ->ASS2    ,;
           (cArq1)->ASS3     WITH REQ->ASS3    ,;
           (cArq1)->RECOM1   WITH REQ->RECOM1  ,;
           (cArq1)->RECOM2   WITH REQ->RECOM2  ,;
           (cArq1)->SITUACAO WITH REQ->SITUACAO,;
           (cArq1)->SETOR1   WITH REQ->SETOR1  ,;
           (cArq1)->SETOR2   WITH REQ->SETOR2  ,;
           (cArq1)->SETOR3   WITH REQ->SETOR3
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Gravar Requerimentos - Aux.    ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE GrvReqD()
   (cArq2)->(DBAPPEND())
   REPLACE (cArq2)->REQ      WITH REQD->REQ     ,;
           (cArq2)->DATA     WITH REQD->DATA    ,;
           (cArq2)->HORA     WITH REQD->HORA    ,;
           (cArq2)->USER     WITH REQD->USER    ,;
           (cArq2)->PRAZO    WITH REQD->PRAZO   ,;
           (cArq2)->RESULT1  WITH REQD->RESULT1 ,;
           (cArq2)->RESULT2  WITH REQD->RESULT2 ,;
           (cArq2)->RESULT3  WITH REQD->RESULT3 ,;
           (cArq2)->SETOR    WITH REQD->SETOR   ,;
           (cArq2)->ENCAM1   WITH REQD->ENCAM1  ,;
           (cArq2)->ENCAM2   WITH REQD->ENCAM2  ,;
           (cArq2)->ENCAM3   WITH REQD->ENCAM3
   RETURN
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Identificar o Sexo do Aluno          ณ
*ิออออออออออออออออออออออออออออออออออออออพ
PROCEDURE Sexo(pVar)
   xIDSexo:=RIGHT(SUBS(pVar,1,AT(" ",pVar)-1),1)
   IF xIDSexo=="A".OR.xIDSexo=="E"
      RETURN("F")
   ELSE
      RETURN("M")
   ENDIF
