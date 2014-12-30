*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_INIC                          vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tela de Apresentacao Logotipo e Senha    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 18/02/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

LOCAL s := m := n := 0, col := 11

PUBLIC cVrs := "2.8"

// Logotipo de Apresentaฦo
PUBLIC xRazao  := "COOPERATIVA DE TECNOLOGIA DE TRถNSITO E DE SA้DE"
PUBLIC cRazao  := "TECTRAN"
PUBLIC cRazao1 := "TECTRAN COOP.TEC.DE TRANSITO E DE SAUDE"
PUBLIC cEnder1 := "Av.Tancredo Neves, n๘ 274, Bloco A, sl/713 a 715"
PUBLIC cEnder2 := "C.Emp.Iguatemi Salvador/BA"
PUBLIC cEnder3 := "Fones: 3018-9574/9573/9570"
PUBLIC cCGC_MF := "CNPJ: 05.115.111/0001-67 - Inscr.Estadual: ISENTO"

PUBLIC fSystem := "Sistema Integrado para CFCs "+cVrs
PUBLIC fRazao  := "Virtual System Inform tica"
PUBLIC fEnder  := "Email: vitor.freire1@gmail.com.br - Suporte"
PUBLIC fFones  := "(71) 9106-5520 8721-7040 3378-7008"

// Impressora
PUBLIC wExpandOn, wExpandOff, wCompr_On, wCompr_Off, wExpand_Med, wImpressora, xpg:=0, wUSB

// Cores
PUBLIC YCORGERAL,YCORAVISO,YCOREDIT,YCORMENU,YCORREALCE,YCORBARRA,YCORTECLAS,YCORGET

// Usuario
PUBLIC lTm, cChave, cTempo := TIME(), cUsuario, nNivel, cPrg:="", cArq1; cDtSys:=DATE()
PUBLIC wTime1, lRotAut:=.F.

// Help
PUBLIC cOphelp1, cOphelp2, cHmsg1 := cHmsg2 := '', nCall := 0

// Miscelania
PUBLIC calc_lin, calc_col, cale_lin, cale_col, corrente, atual, m_date
PUBLIC zNLan,zReq
SET DATE BRITISH
SET( 4, IF(__SETCENTURY(), "dd/mm/yyyy", "dd/mm/yyyy") )

SETCURSOR(0)
cCorAnt := SETCOLOR()
CLS

a7  = "       ฿฿฿฿฿฿฿฿฿฿\        ฿฿฿฿฿฿฿\            ฿฿฿฿฿฿฿\   (tm)"
a8  = "    ฿฿฿฿฿฿฿฿฿฿฿฿฿฿\    ฿฿฿฿฿฿฿฿฿฿฿\        ฿฿฿฿฿฿฿฿฿฿฿\"
a9  = "  ฿฿฿฿฿฿\            ฿฿฿฿฿\   ฿฿฿฿฿\     ฿฿฿฿฿\   ฿฿฿฿฿\"
a10 = "  ฿฿฿฿฿\            ฿฿฿฿฿\     ฿฿฿฿฿\   ฿฿฿฿฿\     ฿฿฿฿฿\"
a11 = "   ฿฿฿฿฿฿฿฿฿฿฿฿\   ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿\  ฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿\"
a12 = "           ฿฿฿฿฿\  ฿฿฿฿฿\      ฿฿฿฿฿\  ฿฿฿฿฿\      ฿฿฿฿฿\"
a13 = "฿฿฿฿\      ฿฿฿฿฿\  ฿฿฿฿฿\      ฿฿฿฿฿\  ฿฿฿฿฿\      ฿฿฿฿฿\"
a14 = " ฿฿฿฿฿฿฿฿฿฿฿฿฿฿\    ฿฿฿฿฿\    ฿฿฿฿฿\    ฿฿฿฿฿\    ฿฿฿฿฿\"
a15 = "   ฿฿฿฿฿฿฿฿฿฿\        ฿฿฿฿\  ฿฿฿฿\        ฿฿฿฿\  ฿฿฿฿\"

linha = 15
SETCOLOR("G/N")
@ 01,00 TO 18,79 DOUBLE
@ 18,00 TO 24,79 DOUBLE
@ 18,00 SAY CHR(204)
@ 18,79 SAY CHR(185)

SET DELETED ON
xSistema :="          SISTEMA DE ACOMPANHAMENTO DE AULAS       "
xTam     := LEN(xSistema)

SETCOLOR("N/W")
   @ 02,16 SAY xSistema
#ifdef DEMO
   @ 03,16 SAY xSis_Demo
#else
   @ 03,16 SAY PADC(xRazao,xTam)
#endif
SETCOLOR("B+")

WHILE .T.
   linha     = LTRIM(STR(linha))
   titulo    = a&linha.
   linha     = VAL(linha)
   linha_aux = 7
   WHILE linha > linha_aux
      @ linha_aux-1,1 SAY SPACE(78)
      @ linha_aux,col SAY titulo
      INKEY(0.05)
      linha_aux++
   ENDDO
   @ linha-1,1 SAY SPACE(78)

   DO CASE
      CASE linha >= 7 .AND. linha <= 9
           SETCOLOR("W+")
      CASE linha > 9 .AND. linha <= 12
           SETCOLOR("GR+")
      CASE linha > 12
           SETCOLOR("B+")
   ENDCASE
   @ linha,col SAY titulo
   linha--
   IF linha < 7
      EXIT
   ENDIF
ENDDO

SETCOLOR(cCorAnt)
@ 19,01,23,78 BOX "ฑฑฑฑฑฑฑฑฑ"
SETCOLOR("W/W")
JanelaExp(19,13,23,61,"        ",.T.)
SETCOLOR("N/W")
@ 19,15 SAY fRazao
@ 20,15 SAY fEnder
@ 21,15 SAY fFones

GeraConfig()          /* Gerar/Ler Arquivos de Configuraฦo do Sistema */
GeraSys()             /* Gerar Arquivos de Controle do Sistema */
YCORGET:=RIGHT(RTRIM(YCOREDIT),7)
lTm   := .F.
nCont := 1
WHILE .T.
   DBCLOSEALL()
   SELECT 1
   IF NetUse("USUARIO.SYS","USER")
      SET INDEX TO USUARIO
   ELSE
      DBCLOSEALL()
      Autor(.F.)         /* Termino Anormal */
   ENDIF

   SETCOLOR("N/W")
   @ 23,15 SAY "Chave :"
   @ 23,38 SAY "Senha :"

   SETCURSOR(1)
   WHILE .T.
      SETCOLOR("N/W")
      cChave := cSenha := ""
      @ 23,24 SAY "["+SPACE(4)+"]"
      @ 23,47 SAY "["+SPACE(6)+"]"

      cChave := Test_Entry(23,25,4,cChave,"CH")
      IF DBSEEK(cChave)
         IF !EMPTY(cChave)
            lAchou_Chave := .T.
         ELSE
            lAchou_Chave := .F.
         ENDIF
      ELSE
         lAchou_Chave := .F.
      ENDIF

      SETCOLOR(",N/N")
      cSenha := Test_Entry(23,48,6,cSenha,"PW","N/W")
      IF LASTKEY() # K_TAB
         IF USER->SENHA == Codifica(cSenha)
            IF !EMPTY(cSenha)
               lAchou_Senha := .T.
            ELSE
               lAchou_Senha := .F.
            ENDIF
         ELSE
            lAchou_Senha := .F.
         ENDIF
         EXIT
      ELSE
         SETPOS(23,25)
      ENDIF
   ENDDO
   SETCURSOR(0)
   IF LASTKEY() # K_ESC
      IF nCont > 3
         Beep(3)
         SETCOLOR("W+/R")
         ImplodBox()
         ExplodBox(19,1,23,78)
         SETCOLOR("W+/R*")
         Centro(21,"Sem Autorizaฦo. Acesso Negado !!!",2,78)
         INKEY(3)
         SETCOLOR(cCorAnt)
         CLS
         QOUT(fSystem)
         QOUT(fEnder)
         QOUT(fFones)
         QOUT("")
         SETCURSOR(1)
         QUIT
      ENDIF
      IF (!lAchou_Chave .AND. lAchou_Senha)  .OR. ;
         (lAchou_Chave  .AND. !lAchou_Senha) .OR. ;
         (!lAchou_Chave .AND. !lAchou_Senha)
         SAVE SCREEN
         Beep(3)
         SETCOLOR("W+/R")
         ImplodBox()
         ExplodBox(19,1,23,78)
         @ 21,25 SAY "Usu rio nฦo Cadastrado..." COLOR "W+/R*"
         INKEY(2)
         SETCOLOR(cCorAnt)
         RESTORE SCREEN
      ELSEIF lAchou_Chave .AND. lAchou_Senha
         telainic:=SAVESCREEN(0,0,24,79)
         SELECT USER
         cUsuario := USUARIO
         nNivel   := NIVEL
         AE_000()   /* Programa Principal */
         nCont  := 1
         RESTSCREEN(0,0,24,79,telainic)
      ENDIF
   ELSE
*      Autor(lTm)
       QUIT
   ENDIF
   nCont++
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Teste Entrada de Chave/Senha ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION Test_Entry(lin,col,nDigitos,Password,cTeste,cor)
   LOCAL nContador := 1
   SETPOS(lin,col)
   WHILE nContador <= nDigitos .AND. LASTKEY() # 27
      tecla = 0
      WHILE tecla = 0 .AND. tecla # K_ESC
        tecla := INKEY()
      ENDDO
      IF LASTKEY() # K_ESC
         TONE(30,.01)
         IF cTeste == "PW"
            @ lin,col SAY 'þ' COLOR cor
         ELSE
            @ lin,col SAY UPPER(CHR(tecla)) COLOR "N/W"
         ENDIF
         col++
      ENDIF
      IF LASTKEY() == K_BS .AND. cPrg#"AE191" .AND. cPrg#"AE192"
         IF cTeste == "CH"
            col := 25
         ELSE
            col := 48
         ENDIF
         nContador := 0
         Password  := ""
         @ lin,col SAY SPACE(nDigitos) COLOR "N/W"
         SETPOS(lin,col)
      ELSEIF LASTKEY() == K_ENTER .OR. LASTKEY() == K_TAB
         EXIT
      ELSE
         Password += UPPER(CHR(tecla))
      ENDIF
      nContador++
   ENDDO
   RETURN(Password)
*ีออออออออออออออออออออออออออออออออธ
*ณ Tela de Turmas com vagas disp. ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION TelaTurmas(pOpen)
   LOCAL corant:=SETCOLOR(), oBr2, oCol2, vTela
   DEFAULT pOpen TO .T.
   IF pOpen
      SELECT 13
      IF NetUse("DBESCA","ESCALA")        /* Escalas */
         SET INDEX TO DBIESCA1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 12
      IF NetUse("DBFERI","FERIADO")       /* Feriados */
         SET INDEX TO DBIFER1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 11
      IF NetUse("DBSALA","SALA")          /* Salas */
         SET INDEX TO DBISALA1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 9
      IF NetUse("DBFREQ","FREQUENCIA")    /* Frequencia de Aulas Teขricas */
         SET INDEX TO DBIFREQ1,DBIFREQ2
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 8
      IF NetUse("DBGRADE","GRADE")        /* Grade Disciplinar */
         SET INDEX TO DBIGRAD1
      ELSE
         DBCLOSEALL(); RETURN
      ENDIF

      SELECT 7
      IF NetUse("DBTURMA","TURMA")        /* Turmas */
         SET INDEX TO DBITURM3,DBITURM1,DBITURM2
      ELSE
         DBCLOSEALL(); RETURN
      ENDIF
   ELSE
      SELECT TURMA; DBGOTOP()
   ENDIF

   msg:="Opไes อ (^ENTER^) Seleciona/Deseleciona Turma"
   lSel:=.F.
   Telas(4,5,17,74,1,YCOREDIT,.T.,"Turmas Disponกveis")
   Linha23(msg)
   oBr2:=TBROWSEDB(5,6,16,73)
   oBr2:headSep:="ฤยฤ"
   oBr2:colSep:= " ณ "
   oBr2:colorspec:=YCOREDIT

   oCol2:=TBCOLUMNNEW("Sel"          ,{|| SEL})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Turma"        ,{|| TURMA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Turno"        ,{|| IF(TURNO="1","Manhฦ",IF(TURNO="2","Tarde",IF(TURNO="3","Noite",SPACE(5))))})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Escala"       ,{|| PegaEscala(ESCALA)})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Grade"        ,{|| CODGRA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Inicio"       ,{|| DTINIC})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Trmino"      ,{|| DTFIM})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Sala"         ,{|| SALA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Uso"          ,{|| USO_N})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Uso Rep."     ,{|| USO_R})
   oBr2:addColumn(oCol2)

   nVagas:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr2:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         lSel:=.F.
         TURMA->(DBGOTOP())
         Aguarde("Gerando grade de frequncia...")
         WHILE !TURMA->(EOF())
            IF !EMPTY(TURMA->SEL)
               lSel:=.T.

               // Localiza 1๘ dia de aula da grade
               GRADE->(DBSEEK(TURMA->CODGRA+TURMA->CODCUR+"01"))
               xData  :=TURMA->DTINIC
               dDtFim :=TURMA->DTFIM
               xDia   :=GRADE->NDIA

               WHILE GRADE->CODGRA==TURMA->CODGRA.AND.GRADE->CODCUR==TURMA->CODCUR
                  // Testar feriados
                  IF TFeriado(xData)
                     xData := xData + 1; LOOP
                  ELSE
                     // Testar se dia  valido na escala
                     IF TEscala(xData,TURMA->ESCALA)
                        /* Gerar arquivo de frequencia */
                        WHILE !FREQUENCIA->(NetApp()); ENDDO
                        REPLACE FREQUENCIA->MATRIC   WITH xMatric         ,;
                                FREQUENCIA->CODCUR   WITH GRADE->CODCUR   ,;
                                FREQUENCIA->CODDIS   WITH GRADE->CODDIS   ,;
                                FREQUENCIA->CODINST  WITH GRADE->CODINST  ,;
                                FREQUENCIA->DATA     WITH xData           ,;
                                FREQUENCIA->HORARIO  WITH GRADE->HORARIO  ,;
                                FREQUENCIA->TURNO    WITH TURMA->TURNO    ,;
                                FREQUENCIA->NTURMA   WITH TURMA->NTURMA   ,;
                                FREQUENCIA->SIMULADO WITH GRADE->SIMULADO ,;
                                FREQUENCIA->NAULA    WITH GRADE->NAULA    ,;
                                FREQUENCIA->USER     WITH cUsuario
                        FREQUENCIA->(DBCOMMIT())
                     ELSE
                        xData := xData + 1; LOOP
                     ENDIF
                  ENDIF
                  GRADE->(DBSKIP())
                  IF GRADE->NDIA # xDia
                     xDia  := GRADE->NDIA
                     xData := xData + 1
                  ENDIF
               ENDDO

               IF (xData-1) > dDtFim
                  Aviso("Data de trmino do curso  inferior ao gerado...")
               ENDIF

               // Diminuir o numero de vagas da turma
               WHILE !TURMA->(NetLReg()); ENDDO
               REPLACE TURMA->SEL   WITH SPACE(1)
               REPLACE TURMA->USO_N WITH TURMA->USO_N + 1
               TURMA->(DBUNLOCK())
            ENDIF
            TURMA->(DBSKIP())
         ENDDO
         Aguarde()
         IF lSel
            EXIT
         ELSE
            Aviso("Voc precisa selecionar uma turma com vaga!")
         ENDIF
      ELSEIF ( tecla == K_F1 )   // Ajuda
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
      ELSEIF ( tecla == K_F4 )   // Calculadora
         Calculadora(calc_lin,calc_col,YCORMENU)
      ELSEIF ( tecla == K_F5 )   // Calendario
         Calendary(@cale_lin,@cale_col,@m_date)
      ELSEIF ( tecla == K_ENTER )
         // Verificar se tem vaga
         SALA->(DBSEEK(TURMA->SALA))
         IF TURMA->TURNO="1"       // Manhฦ
            nVagas := SALA->VAGA_M - TURMA->USO_N
         ELSEIF TURMA->TURNO="2"   // Tarde
            nVagas := SALA->VAGA_V - TURMA->USO_N
         ELSEIF TURMA->TURNO="3"   // Noite
            nVagas := SALA->VAGA_N - TURMA->USO_N
         ENDIF

         IF nVagas>=1
            nReg:=TURMA->(RECNO())
            WHILE !TURMA->(NetLReg()); ENDDO
            REPLACE TURMA->SEL WITH IF(EMPTY(TURMA->SEL),"*"," ")
            TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
            TURMA->(DBGOTOP())
            WHILE !TURMA->(EOF())
               WHILE !TURMA->(NetLReg()); ENDDO
               IF TURMA->(RECNO())#nReg
                  REPLACE TURMA->SEL WITH SPACE(1)
               ENDIF
               TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
               TURMA->(DBSKIP())
            ENDDO
            TURMA->(DBGOTO(nReg))
            oBr2:refreshAll()
         ELSE
            Aviso("Turma nฦo tem vaga disponกvel!")
         ENDIF
      ELSE
         ProcKey(oBr2,tecla)
      ENDIF
   ENDDO
   SETCOLOR(corant); Rest_Tela()
   RESTSCREEN(2,0,24,79,vTela)
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Rotina de Aluguel Carro Exame  ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION RCarro(pVar,pRot)
   DEFAULT pRot TO .F.
   IF pRot
      wCateg := ALUNO->CATEG
      wRG    := ALUNO->RG
      wRENACH:= ALUNO->RENACH
   ENDIF
   PUBLIC xLocal:="P€A GENERAL OSORIO, 33, FINAL DE LINHA DA RIBEIRA"
   IF pVar>0.00
      GetList:={}
      Telas(10,35,17,78,1,YCOREDIT,.T.)
      IF !EMPTY(xVeiculo)
         TDescr(14,1,11,53,xVeiculo,"MARCA",["@S20"])
      ENDIF
      @ 11,37 SAY "Veกculo....:" GET xVeiculo  PICT "999"      WHEN TeclaFuncao(.T.);
        VALID Pesquisa(14,1,xVeiculo,"Veกculo Nฦo Cadastrado!").AND.TDescr(14,1,11,53,xVeiculo,"MARCA",["@S20"])
*     @ 12,37 SAY "Dt.Prevista:" GET xDtPrev   PICT "@D"       WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(xDtPrev)
*     @ 12,64 SAY "Hora:"        GET xHora     PICT "@R 99:99"
      @ 13,37 SAY "Local Exame:" GET xLocal    PICT "@!S25"
      @ 14,37 SAY "RENACH nง..:" GET wRENACH   WHEN .F.
      SETCURSOR(1); READ; SETCURSOR(0)
      wCodInst:=VEICULO->CODINST
      IF LASTKEY()==K_ESC; Rest_Tela(); RETURN(.F.); ENDIF
      Rest_Tela()
   ENDIF
   RETURN(.T.)
