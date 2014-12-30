*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_INIC                          vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tela de Apresentacao Logotipo e Senha    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 18/02/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL s := m := n := 0, col := 11

PUBLIC cVrs := "2.7"

// Logotipo de Apresentaฦo
PUBLIC xRazao  := "CENTRO DE FORMA€วO DE CONDUTORES UNIวO LTDA"
PUBLIC cRazao  := "CFC UNIAO LTDA"
PUBLIC cRazao1 := "CFC UNiฦo Ltda"
PUBLIC cEnder1 := "Lad. Ibiama, Centro Coml.San Felipe, 35, Itapua"
PUBLIC cEnder2 := "Salvador-BA"
PUBLIC cEnder3 := "Fones: 71 3375-4034 / 3375-5369"
PUBLIC cCGC_MF := "CNPJ: 15.189.798/0002-10 - Inscr.Estadual: ISENTO"

PUBLIC fSystem := "Sistema Integrado para CFC`s "+cVrs
PUBLIC fRazao  := "Virtual System Informatica"
PUBLIC fEnder  := "Email: vasf@ig.com.br - Tcnico Resp.: Vitor"
PUBLIC fFones  := "Fones: 9987-2480 ๚ 9103-6188 ๚ 8794-9742 ๚ 3432-7642"

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
JanelaExp(19,10,23,64,"        ",.T.)
SETCOLOR("N/W")
@ 19,12 SAY fRazao
@ 20,12 SAY fEnder
@ 21,12 SAY fFones

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
