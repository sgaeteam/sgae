*уммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╦
*Ё PROGRAMA       : AE_FUNC                          vrs 001 Ё
*Ё VRS 001        : Implantacao                              Ё
*Ё FINALIDADE     : Funcoes Genericas do Sistema             Ё
*Ё PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           Ё
*Ё DATA CRIACAO   : 26/10/1993                               Ё
*Ё OBSERVACOES    : Compilar com os parametros /N /W /A /M   Ё
*тммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╬
#include "INKEY.CH"
#include "SETCURS.CH"
#include "COMMAND.CH"
#include "FILEIO.CH"
#include "FILEMAN.CH"
#include "MEMOEDIT.CH"

MEMVAR nCall, cPrg, vetor, indice, handle_gr, continuac, handle_ler, bloc
MEMVAR buffers, tam_arq, transf, bytes_lid, bytes_grav, marca_fim, cont_disco
MEMVAR handle_cab, nova_lin, arq_cab, str_cab, cbuffer, marc_fim
MEMVAR YCORBARRA, YCORGERAL, YCOREDIT, YCORMENU, YCORAVISO, tecla

*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       AVISO SONORO DE PROCESSAMENTO                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Beep(modo)
   IF modo = 1          /* Processamento mal sucedido */
      TONE(87.3,1); TONE(87.3,4)
   ELSEIF modo = 2      /* Processamento bem sucedido */
      TONE(1612.6,.5); TONE(1323.4,7)
   ELSEIF modo = 3      /* Falha de acesso ao Sistema */
      TONE(1200,1); TONE(670,2)
   ENDIF
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё           ROTINA DE EXIBICAO DE MODULOS DE HELP DO SISTEMA                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Help(op, mod, chamadas, msg1, msg2)
   LOCAL chave, tela, arq, cursor, cor
   LOCAL cTela:=SAVESCREEN(23,0,23,79)

   IF chamadas == 1
      RETURN NIL
   ELSE
      cursor := SETCURSOR()
      chave  := op + mod
      cor    := SETCOLOR()
      arq    := SELECT()
      SETCURSOR(0)

      SELECT 20
      IF NetUse("HELP.HLP","HELP")
         SET INDEX TO HLP
      ELSE
         DBCLOSEAREA(); RETURN NIL
      ENDIF
      IF DBSEEK(chave)
         nCall := 1
         Telas(5,10,19,70,1,YCORAVISO,.T.,"Ajuda")
         SETCOLOR(YCORAVISO)
         Mensagem("Use as teclas "+CHR(24)+","+CHR(25)+", PGUP, PGDN,"+;
                  "CTRL PGUP, CTRL PGDN para Movimentar","[Esc] Finaliza Ajuda")
         MEMOEDIT(_FIELD->descricao,6,11,18,69,.F.)
         IF LASTKEY()==K_ESC
            nCall := 0
         ENDIF
         Rest_Tela()
         Mensagem(msg1,msg2)
      ELSE
         Aviso("Ajuda NгO dispon║vel! Tecle algo...")
      ENDIF
      SELECT (arq); SETCOLOR(cor); SETCURSOR(cursor)
   ENDIF
   RESTSCREEN(23,0,23,79,cTela)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё            ROTINA DE CHECAGEM DE CONEXAO COM IMPRESSORA                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkImpr()
   LOCAL var1 := var2 := var3 := .T.

   corant := SETCOLOR()
   tela   := SAVESCREEN(16,55,20,78)
   SETCURSOR(0)

   Quadro(16,57,19,76,1,"N/W",.T.)
   SETCOLOR("N/W")
   WHILE .T.
      tecla := INKEY()
      WHILE tecla # 0 .AND. tecla # K_ENTER .AND. tecla # K_ESC
         tecla := INKEY()
      ENDDO

      IF ISPRINTER()
         IF var1
            @ 17,58 SAY " <     > Imprime  "
            @ 18,58 SAY " <ESC>   Abandona "
            SETCOLOR("*N/W")
            @ 17,60 SAY "ENTER"
            SETCOLOR( "N/W" )
            var1 := .F.
            var2 := .T.
         ENDIF
         IF tecla = K_ENTER
            EXIT
         ENDIF
      ELSE
         IF var2
            @ 17,58 SAY " Impressora...    "
            SETCOLOR("*N/W")
            @ 18,58 SAY " Nфo Conectada.   "
            SETCOLOR("N/W")
            var1 := .T.
            var2 := .F.
         ENDIF
      ENDIF
      IF tecla = K_ESC
         var3 := .F.
         EXIT
      ENDIF
   ENDDO
   SETCOLOR(corant)
   RESTSCREEN(16,55,20,78,tela)
   RETURN(var3)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA PARA INFORMAR IMPRESSAO DE RELATORIO                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION MsgImp(pInter)
   DEFAULT pInter TO .T.
   corant  := SETCOLOR()
   telaImp := SAVESCREEN(16,55,20,78)
   SETCOLOR("N/W")
   Quadro(16,57,IF(pInter,19,18),76,1,"N/W",.T.)
   SETCOLOR("N*/W")
   @ 17,58 SAY " Imprimindo...    "
   IF pInter
      SETCOLOR("N/W")
      @ 18,58 SAY " <ESC> Interrompe "
   ENDIF
   SETCOLOR(corant)
   RETURN(telaImp)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA PARA RESTAURAR MENSAGEM IMPRIMINDO...                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION TiraMsgImp(tela)
   RESTSCREEN(16,55,20,78,tela)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE FORMATACAO DE IMPRESSAO                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Negrito_Off() ; ?CHR(19)+CHR(18); RETURN
PROCEDURE Negrito()     ; CHR(19); RETURN
PROCEDURE Pulo()        ; CHR(12); RETURN
PROCEDURE Largo()       ; CHR(14); RETURN
PROCEDURE Normal()      ; CHR(18); RETURN
PROCEDURE Denso_96()    ; CHR(17); RETURN
PROCEDURE Denso_120()   ; CHR(16); RETURN
PROCEDURE Denso_140()   ; CHR(15); RETURN
PROCEDURE Denso_160()   ; CHR(20); RETURN

PROCEDURE IMP_Exp()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(27)+"W"+CHR(1)
   SET PRINTER OFF
   SET CONSOLE ON
RETURN
*
PROCEDURE IMP_Enor()
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(27)+"W"+CHR(0)
   SET PRINTER OFF
   SET CONSOLE ON
RETURN
*
PROCEDURE Compr_Off()     /* Comprimido Desligado - Normal */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wCompr_Off.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Compr_On()      /* Comprimido Ligado */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wCompr_On.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Expand_On()     /* Expandido Ligado */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wExpandOn.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Expand_Off()    /* Expandido Desligado */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? &wExpandOff.
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE ExpMed_On()     /* Ligar Meio-Expandido */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? wExpand_Med
   SET PRINTER OFF
   SET CONSOLE ON
   RETURN
*
PROCEDURE Imp_Graf()      /* Impressao Grafica */
   SET CONSOLE OFF
   SET PRINTER ON
   ?? CHR(6)
   SET PRINTER OFF
   SET CONSOLE ON
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё            ROTINA DE CANCELAMENTO DE IMPRESSAO PELO USUARIO               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Escprint(Tam_Form)
   PRIVATE tecla
   tecla := INKEY()
   WHILE tecla # 0 .AND. tecla # K_ESC
      tecla := INKEY()
   ENDDO
   IF tecla == K_ESC
      corantiga := SETCOLOR()
      SET DEVICE TO SCREEN
      SET CONSOLE ON
      TONE(500,5)
      SET CONSOLE OFF
      SETCOLOR("N*/W")
      @ 17,58 SAY " Pausa...       "
      INKEY(0)
      IF LASTKEY() == K_ESC
         SET DEVICE TO PRINT
         Compr_On()
         Imp_Cancel(Tam_Form)
         Compr_Off()
         SET CONSOLE ON
         SETCOLOR(corantiga)
         RETURN .F.
      ENDIF
      @ 17,58 SAY " Imprimindo...  "
      SETCOLOR(corantiga)
   ENDIF
   SET DEVICE TO PRINT
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE MENSAGEM DE CANCELAMENTO DE IMPRESSAO          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Imp_Cancel(Tam_Form)
   DEFAULT Tam_Form TO 80
   @ PROW()+1,00 SAY REPLICATE("*",Tam_Form)
   Centro(PROW()+1,"I M P R E S S A O   I N T E R R O M P I D A   P E L O   U S U A R I O",0,Tam_Form)
   @ PROW()+1,00 SAY REPLICATE("*",Tam_Form)
   EJECT
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                CENTRALIZAR MENSAGENS NA TELA OU IMPRESSORA                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Centro(linha,texto,l,r,cor)
   IF EMPTY(l).AND.EMPTY(r)
      tam := 80
      @ linha,INT((tam - LEN(texto))/2) SAY texto COLOR cor
   ELSE
      tam := ((r-l)/2) + l
      @ linha,INT(tam - (LEN(texto)/2)) SAY texto COLOR cor
   ENDIF
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  RODAR NODOSIMP
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE RodaNoDos(pArq)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp (pArq+".txt") 80 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE (pArq)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE GERACAO DE ARQUIVO TEXTO PARA IMPRESSAO        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Gera_TXT(pArq)
   SET PRINT TO (pArq)
   SET DEVI TO PRINT
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE IMPRESSAO DO ARQUIVO TEXTO GERADO              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Fim_TXT()
   SET PRINT OFF
   SET PRINTER TO
   SET DEVICE TO SCREEN
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                      EXIBIR MENSAGEM NA LINHA 23                          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Mensagem(texto)
   LOCAL corant := SETCOLOR()
   SETCOLOR(YCORMENU)
   @ 23,00 CLEAR TO 23,79
   IF texto # NIL
      Centro(23,texto,,,YCORMENU)
   ENDIF
   SETCOLOR(corant)
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       PEDIR CONFIRMACAO DE OPCOES                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Confirma(texto,default)
   LOCAL les,ces,largjan,telavelha
   DEFAULT default TO .F.

   confirm := .F.
   IF LASTKEY() = K_DEL
      Opcao := 2
   ENDIF

   largjan := LEN(texto)+2
   IF largjan < 16
      largjan := 16
   ENDIF

   ces       := (80-largjan)/2
   les       := 19
   telavelha := SAVESCREEN(les,0,les+4,79)
   corant    := SETCOLOR()
   cornova   := "N/W,W+/N"

   Sombra( les, ces, les+3, ces+LargJan, c_nLado )
   SETCOLOR(cornova)
   @ les,ces CLEAR TO les+3,ces+largjan
   @ les,ces TO les+3,ces+largjan DOUBLE
   @ les+1,ces+2 SAY texto
   coluna := (largjan-9)/2

   IF default
      @ les+2,ces+coluna   PROMPT " Nфo "
      @ les+2,ces+coluna+6 PROMPT " Sim "
      MENU TO Opcao
      IF Opcao == 2
         confirm := .T.
      ENDIF
   ELSE
      @ les+2,ces+coluna   PROMPT " Sim "
      @ les+2,ces+coluna+6 PROMPT " Nфo "
      MENU TO Opcao
      IF Opcao == 1
         confirm := .T.
      ENDIF
   ENDIF
   SETCOLOR(corant)
   RESTSCREEN(les,0,les+4,79,telavelha)
   RETURN(confirm)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       ENVIAR MENSAGEM DE ERRO (AVISO)                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Aviso(texto,cor,tempo)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR(), areamsg:=SAVESCREEN(23,0,23,79)
   DEFAULT cor   TO YCORAVISO
   DEFAULT tempo TO 0
   SETCOLOR(cor)
   SETCURSOR(0)
   @ 23,00 CLEAR TO 23,79
   Beep(1)
   Centro(23,texto)
   INKEY(tempo)
   Mensagem()
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RESTSCREEN(23,0,23,79,areamsg)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       ENVIAR MENSAGEM DE SUCESSO (AVISO)                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION AvisoS(texto,cor,tempo)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR(), areamsg:=SAVESCREEN(23,0,23,79)
   DEFAULT cor   TO YCORAVISO
   DEFAULT tempo TO 0
   SETCOLOR(cor)
   SETCURSOR(0)
   @ 23,00 CLEAR TO 23,79
   Beep(2)
   Centro(23,texto)
   INKEY(tempo)
   Mensagem()
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RESTSCREEN(23,0,23,79,areamsg)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё          ROTINA DE MOSTRAGEM EM TELA OU IMPRESSORA DE CAMPOS MEMO         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Prdevice(pVar,pTam,pTab)
   LOCAL tela := SAVESCREEN(2,0,24,79), cCorAntes := SETCOLOR()
   SETCOLOR(YCOREDIT)
   SETCURSOR(3)
   IF LEN(pVar) > 64000
      Aviso("Relat╒rio muito grande para ser listado em tela.",,3)
   ELSE
      @ 2,0,22,79 BOX "         "
      Mensagem("["+CHR(24)+CHR(25)+" PgUp PgDn] Movimentar  [Home] Esquerda  [End] Direita [Esc] Finaliza",YCORAVISO)
      MEMOEDIT(pVar,2,0,22,79,.F.,"",pTam,pTab)
      SETCOLOR(cCorAntes)
      @ 02,00,22,79 BOX "╟╟╟╟╟╟╟╟╟" COLOR YCORGERAL
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   SETCOLOR(cCorAntes)
   SETCURSOR(0)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                    ROTINA DE CONSULTA DE DBF (BROWSE)                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Consulta(nDbf,nInd,Cab1,Cab2,Camp1,Camp2,Retorno,sombra,Masc1,Masc2,Cab3,Camp3,Masc3)
   LOCAL nLinhas, nN, Coluna
   LOCAL Tab, lSup, lInf, cEsq, cDir, v1, v2, tela := SAVESCREEN(2,0,24,79)
   LOCAL corAnterior  := SETCOLOR()
   LOCAL nSelectAntes := SELECT()
   LOCAL nOrderAntes  := INDEXORD()
   
   PRIVATE cBuffer := "", tecla

   DBSELECTAREA( nDbf )
   DBSETORDER( nInd )
   DEFAULT sombra TO .F.
   v1 := IF(VALTYPE(&Camp1)=="N",STR(&Camp1),&Camp1)
   IF Camp2 #  NIL
      v2 := IF(VALTYPE(&Camp2)=="N",STR(&Camp2),&Camp2)
   ELSE
      v2 := ""
   ENDIF
   IF Camp3 #  NIL
      v3 := IF(VALTYPE(&Camp3)=="N",STR(&Camp3),&Camp3)
   ELSE
      v3 := ""
   ENDIF

   lSup    := 03
   cDir    := 74
   cEsq    := 74 - (IF(VALTYPE(v1)=="D",8,LEN(v1))+IF(VALTYPE(v2)=="D",8,LEN(v2))+IF(VALTYPE(v3)=="D",8,LEN(v3))+3)
   nLinhas := 0
     
   DBGOTOP()
   FOR nn := 1 TO 20
     IF !(BOF() .AND. EOF())
        nLinhas++
     ENDIF
     DBSKIP()
     IF EOF() .OR. nLinhas > 9
        EXIT
     ENDIF
   NEXT

   IF nLinhas <> 0
      IF nLinhas > 9
         lInf := 18
      ELSE
         lInf := lSup + 03 + nLinhas
      ENDIF
      Tab := TBROWSEDB(lSup+1, cEsq+1, lInf-1, (cDir-1)+3)
      Quadro(lSup,cEsq,lInf,cDir+3,,YCOREDIT,,"Pesquisa")
      Quadro(lInf,cEsq,lInf+2,cDir+3,,YCOREDIT,.T.)
      Tab:HEADSEP   := CHR(194)+CHR(196)
      Tab:COLORSPEC := (YCOREDIT)

      Coluna := TBCOLUMNNEW(Cab1,FIELDBLOCK(Camp1))
      IF TYPE(Camp1)=="N"
         Coluna:COLORBLOCK := {|CAMPO| IF(CAMPO>=0,{3,4},{5,6})}
      ENDIF
      Coluna:COLSEP := CHR(179)
      Tab:ADDCOLUMN(Coluna)
      IF Masc1#nil
         COLUNA:picture:=Masc1
      ENDIF

      IF Cab2 <> NIL
         Coluna := TBCOLUMNNEW(Cab2,FIELDBLOCK(Camp2))
         Coluna:COLSEP := CHR(179)
         Tab:ADDCOLUMN(Coluna)
         IF Masc2#nil
            COLUNA:picture:=Masc2
         ENDIF
      ENDIF

      IF Cab3 <> NIL
         Coluna := TBCOLUMNNEW(Cab3,FIELDBLOCK(Camp3))
         Coluna:COLSEP := CHR(179)
         Tab:ADDCOLUMN(Coluna)
         IF Masc3#nil
            COLUNA:picture:=Masc3
         ENDIF
      ENDIF
   ELSE
      Aviso("Banco de Dados Vazio",YCORAVISO,2)
      SETCURSOR(1)
      DBSELECTAREA(nSelectAntes)
      SET ORDER TO nOrderAntes
      SETCOLOR(CorAnterior)
      RETURN .T.
   ENDIF

   IF sombra
      Sombra(lSup,cEsq,lInf,cDir+3,1)
   ENDIF

   DBGOTOP()
*  IF !EMPTY(ctipomov)
*     DBSEEK(ctipomov)
*     Tab:gobottomblock = {||goto_bott(ctipomov)}
*     Tab:gotopblock = {||goto_top(ctipomov)}
*     Tab:skipblock = {|n| move_pointer(n, ctipomov, {|n| TIPOMOV})}
*  ENDIF
   Tab:refreshall()
   Tab:FREEZE := 1
   WHILE .T.
      SETCURSOR(0)
      WHILE !Tab:STABILIZE();ENDDO
      tecla := INKEY(0)
      IF tecla == K_UP
         Tab:up()
      ELSEIF tecla == K_DOWN
         Tab:down()
      ELSEIF tecla == K_RIGHT
         Tab:right()
      ELSEIF tecla == K_LEFT
         Tab:left()
      ELSEIF tecla == K_PGUP
         Tab:pageup()
      ELSEIF tecla == K_PGDN
         Tab:pagedown()
      ELSEIF tecla == K_CTRL_PGUP
         Tab:gotop()
      ELSEIF tecla == K_CTRL_PGDN
         Tab:gobottom()
      ELSEIF tecla == K_ESC .OR. tecla == K_ENTER
         RESTSCREEN(2,0,24,79,tela)
         SETCURSOR(1)
         IF tecla == K_ENTER
            cNomeVar   := READVAR()
            &cNomeVar. := &Retorno.
            IF cPrg#"AE290"
               KEYBOARD &Retorno. //+ CHR(13)
            ENDIF
         ENDIF
         DBSELECTAREA(nSelectAntes)
         SET ORDER TO nOrderAntes
         SETCOLOR(CorAnterior)
         RETURN .T.
      ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
         SmartSeek(UPPER(CHR(tecla)),lInf+1,cEsq,cDir-cEsq-1)
         Tab:refreshall()
      ENDIF
   ENDDO
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                ROTINA DE AUXILIO DA CONSULTA DE DBF (BROWSE)              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION SmartSeek(c,nLinha,nColuna,Masc)
   LOCAL Reg_Atual := RECNO()
   IF tecla == K_CTRL_L
      cBuffer := ""
      @ nLinha,nColuna+1 SAY SPACE(Masc)
      RETURN NIL
   ENDIF
   IF ASC(c) == K_BS
      cBuffer := LEFT(cBuffer,LEN(cBuffer)-1)
   ELSE
      IF VALTYPE(c) == "N"
         c := STR(c,1)
      ENDIF
      cBuffer += c
      IF !DBSEEK(cBuffer)
         DBGOTO(Reg_Atual)
      ENDIF
   ENDIF
   IF LEN(cBuffer)<Masc
      @ nLinha,nColuna+1 SAY cBuffer+SPACE(1)
   ENDIF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё         ROTINA DE MOSTRAGEM DE % ARQUIVO ORGANIZADO (TERMOMETRO)          Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Termom(cTitulo, Lidos, Final)
   LOCAL nCentro, cTermvazio
   LOCAL nProporcao := ROUND(100.00/final,2)
   LOCAL nPercent   := ROUND(lidos/final*100,2)
   LOCAL cCor       := SETCOLOR()
   LOCAL lStat_Cons := SET(_SET_CONSOLE,.T.)
   LOCAL lStat_Dev  := SET(_SET_DEVICE,"SCREEN")

   cTitulo    := "╢ "+cTitulo+" ц"

   IF nPercent < nProporcao
      nCentro    = (40-LEN(cTitulo))/2+20
      cTermvazio = REPLICATE("╠",40)
      Quadro(15,18,17,61,1,YCOREDIT,,,.T.)
      SETCOLOR(YCOREDIT)
      @ 15,nCentro SAY cTitulo
      @ 17,28 SAY "╢"+SPACE(20)+"ц"
      @ 16,19 CLEAR TO 16,60
      @ 17,29 CLEAR TO 17,48
      @ 16,20 SAY cTermvazio
      @ 17,38 SAY "Executados"
   ENDIF

   @ 16,20 SAY REPLICATE("ш",nPercent/2.50) COLOR "W/W"
   @ 17,30 SAY nPercent PICTURE "@E 999.9%" COLOR YCOREDIT

   SETCOLOR(cCor)
   SET(_SET_CONSOLE,lStat_Cons)
   SET(_SET_DEVICE,lStat_Dev)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                 ROTINA DE CALCULO DO ULTIMO DIA DO MES                    Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION FimMes(data)
   LOCAL dia, mes, ano, final
   ano = YEAR(data)
   mes = MONTH(data) + 1
   dia = '01'
   IF mes = 13
      ano++
      mes = 1
   ENDIF
   ano   = STR(ano-1900,2)
   mes   = STR(mes,2)
   final = CTOD(dia+"/"+mes+"/"+ano)
   RETURN(final-1)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        ROTINA DE EXPANSAO DE JANELA                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION JanelaExp(nLinSup, nColSup, nLinInf, nColInf, nTipo, nSombra)
   LOCAL Tela_Ant := SAVESCREEN(nLinSup, nColSup, nLinInf, nColInf)
   LOCAL odd, tlsct
   PRIVATE t,l,b,r

   nLinSup := INT(nLinSup)
   nLinInf := INT(nLinInf)
   nColSup := INT(nColSup)
   nColInf := INT(nColInf)
   
   tlsct   := 0
   t       := (nLinSup+nLinInf)/2-1
   l       := (nColSup+nColInf)/2-1
   odd     := .F.
   b       := t + 1
   r       := l + 1

   WHILE .T.
      odd = !odd
      IF odd
         IF t > nLinSup
            t--
            IF t < nLinSup
               t := nLinSup
            ENDIF
         ENDIF
         IF b < nLinInf
            b++
            IF b > nLinInf
               b := nLinInf
            ENDIF
         ENDIF
      ENDIF
      IF l > nColSup
         l--
         IF l < nColSup
            l := nColSup
         ENDIF
      ENDIF
      IF r < nColInf
         r++
         IF r > nColInf
            r := nColInf
         ENDIF
      ENDIF
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX nTipo
      IF t = nLinSup .AND. l = nColSup .AND. b = nLinInf .AND. r = nColInf
         EXIT
      ENDIF
   ENDDO
   IF nSombra <> NIL
      Sombra(t,l,b,r,1)
   ENDIF
   RETURN Tela_Ant
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        ROTINA DE SOMBREAMENTO                             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Sombra(ls,cs,li,ci,lado)
   LOCAL sombra1, sombra2, lsombra
   DEFAULT lado TO 1
   IF lado = 2
      sombra1 := SAVESCREEN(ls+1, cs-2, li+1, cs-1)
      sombra2 := SAVESCREEN(li  , cs  , li+1, ci-2)
   ELSE
      sombra1 := SAVESCREEN(ls+1, ci+1, li+1, ci+2)
      sombra2 := SAVESCREEN(li,   cS+2, li+1, ci)
   ENDIF
   sombra1 := TRANSFORM(sombra1,REPLICATE("X"+CHR(1),(li-ls+1)*2))
   lsombra := (ci-cs-1)
   sombra2 := LEFT(sombra2,lsombra*2)+TRANSFORM(SUBSTR(sombra2,lsombra*2+1,lsombra*2),;
              REPLICATE("X"+CHR(1),lsombra))
   RESTSCREEN(ls+1,IF(lado==2,cs-2,ci+1),li+1,IF(lado==2,cs-1,ci+2),sombra1)
   RESTSCREEN(li,IF(lado==2,cs,cs+2), li+1,IF(lado==2,ci-2,ci),sombra2)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     LOGOTIPO EMPRESA - DIREITOS AUTORAIS                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
STATIC FUNCTION Logotipo()
#ifdef DEMO
   PUBLIC cRazao := "Empresa Demonstra┤фo"
#endif
   CLEAR SCREEN
   SETCOLOR("G+/N")
   @ 0,0 SAY cRazao1 + SPACE(80 - LEN(cRazao1))
   SETCOLOR(YCORMENU)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     SETUP DO AMBIENTE DE TRABALHO                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Abertura()
   Logotipo()
   Area_Menu()
   Area_Dados()
   SET( 4, IF(__SETCENTURY(), "dd/mm/yyyy", "dd/mm/yyyy") )
   SET( _SET_EPOCH, 2000 )
   SET WRAP ON
   SET DATE BRITISH
   SET DELETED ON
   SET BELL OFF
   SET SCOREBOARD OFF
   SET CURSOR OFF
   SET CONFIRM OFF
   SET STATUS OFF
   SET ESCAPE ON
   SET MESSAGE TO 23
   SET EXCLUSIVE OFF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PREENCHIMENTO DA AREA DE DADOS                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Area_Dados()
   @ 02,00,22,79 BOX "╟╟╟╟╟╟╟╟╟" COLOR YCORGERAL
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PREENCHIMENTO DA AREA DE MENU                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Area_Menu()
   @ 01,00 SAY SPACE(80) COLOR YCORMENU
   @ 23,00 SAY SPACE(80) COLOR YCORMENU
   @ 24,00 SAY SPACE(80) COLOR YCORMENU
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       NAVEGAR ENTRE OPCOES                                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE cEsquerda()
   KEYBOARD CHR(27)+CHR(19)+CHR(13)
   RETURN
*
PROCEDURE cDireita()
   KEYBOARD CHR(27)+CHR(4)+CHR(13)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     USUARIO E VERSAO DO SISTEMA                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION QuadroGeral(pTitulo)
   LOCAL tam, corant := SETCOLOR()
   SETCOLOR("W+/N")
   IF pTitulo = NIL
      @ 0,60 SAY SPACE(19)
   ELSE
      tam = LEN(TRIM(pTitulo))
      @ 0,80-tam SAY pTitulo
   ENDIF
   SETCOLOR(corant)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        MONTAR QUADRO DE OPCOES                            Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Telas(t,l,b,r,tipo,cor,sombra,pTitulo)
   DEFAULT tipo   TO 1
   DEFAULT sombra TO .F.

   IF TYPE("TELAS") # "A"   //SE .T. ,NAO EXISTE A MATRIZ
      PUBLIC TELAS := {}    //CRIA UMA MATRIZ "TELAS" VAZIA
   ENDIF
   AADD(Telas,{t,l-2,b+1,r+2,SAVESCREEN(t,l-2,b+1,r+2)})

   cStilo := aBorda[tipo]

   IF sombra
      Sombra(t,l,b,r,c_nLado)
   ENDIF
   IF cor # NIL
      corant := SETCOLOR()
      SETCOLOR(cor)
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX cStilo
      SETCOLOR(corant)
   ELSE
      SCROLL(t,l,b,r,0)
      @ t,l,b,r BOX aBorda[tipo]
   ENDIF
   IF pTitulo # NIL
      pTitulo2:= " "+pTitulo+" "
      pTitulo := "╢ "+pTitulo+" ц"
      Centro(t,pTitulo,l,r,cor)
      Centro(t,pTitulo2,l,r,YCORAVISO)
   ENDIF
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                RESTAURAR QUADROS MONTADOS NA FUNCAO TELAS                 Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Rest_Tela(pQuant)
   LOCAL ult:=LEN(Telas)
   DEFAULT pQuant TO 1

   FOR n = 1 TO pQuant
       RESTSCREEN(Telas[ult,1],Telas[ult,2],Telas[ult,3],Telas[ult,4],Telas[ult,5])
       ASIZE(Telas,ult-1)
       ult := LEN(Telas)
   NEXT
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       AVISO PARA AGUARDAR PROCESSAMENTO                   Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Aguarde(texto)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR()
   SETCURSOR(0); SETCOLOR("R+/W")
   IF texto==NIL
      ImplodBox()
   ELSE
      nCol := 76 - LEN(texto)
      ExplodBox(19,nCol,21,77)
      @ 20,nCol+01 SAY texto COLOR "R+*/W"
      TONE(1300,1.5)
   ENDIF
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                          ROTINA DE AVISO DE I/O                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE ProcOk(texto,pmodo)
   LOCAL corant := SETCOLOR(), cursor := SETCURSOR()
   DEFAULT pmodo TO .F.

   IF texto # NIL
      PUBLIC telaOK := SAVESCREEN(2,0,24,79)
      SETCURSOR(0); SETCOLOR(YCOREDIT)
      nCol := 76 - LEN(texto)
      Quadro(19,nCol,21,77,1,YCOREDIT,.T.,,.T.)
      @ 20,nCol+01 SAY texto
      TONE(1300,1.5)
      IF pmodo
         INKEY(1.5)
         RESTSCREEN(2,0,24,79,telaOK)
         RELEASE telaOk
      ENDIF
   ELSE
      RESTSCREEN(2,0,24,79,telaOK)
      RELEASE telaOk
   ENDIF
   SETCURSOR(cursor)
   SETCOLOR(corant)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA DE DESENHAR QUADROS COM MOLDURAS                     Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Quadro(t,l,b,r,tipo,cor,cheio,texto,sombra)
   DEFAULT tipo   TO 1
   DEFAULT sombra TO .F.
   DEFAULT cheio  TO .F.
   DEFAULT cor    TO "N/W"

   corant := SETCOLOR()
   cStilo := aBorda[tipo]

   IF cheio    /* Limpa o fundo do Box */
      cStilo += CHR(32)
   ENDIF

   IF cor # "N/W"
      DISPBOX(t,l,b,r,cStilo,cor)
   ELSE
      DISPBOX(t,l,b,r,aBorda[tipo],cor)
   ENDIF

   IF sombra
      Sombra(t,l,b,r,c_nLado)
   ENDIF

   IF texto # NIL
*     SETCOLOR(cor)
      Centro(t,texto,l,r,cor)
   ENDIF
   SETCOLOR(corant)
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                   ROTINA DE FINALIZACAO DO SISTEMA                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Saida()
   LOCAL cResSim, cResNao, LinhaMem := SAVESCREEN(23,00,24,79)
   LOCAL lVarSai := .T.

   TelaAntes := SAVESCREEN(13,13,22,66)

   cCorNova := "N/W"
   SETCOLOR(YCORAVISO)
   JanelaExp(13,15,21,64,c_nBorda,.T.)

   @ 15,35 SAY "Aten┤фo!" COLOR STUFF(YCORAVISO,2,1,"*")
   @ 17,18 SAY "Voce solicitou a Sa║da do Sistema SAA "+cVrs+"(v)"
   cResSim := CHR(16)+" Sim "+CHR(17)
   cResNao := CHR(16)+" Nфo "+CHR(17)
   SETCOLOR(cCorNova)
   @ 19,31 SAY "  Sim  "
   @ 19,41 SAY "  Nфo  "
   TelaSim := SAVESCREEN(19,31,19,37)
   TelaNao := SAVESCREEN(19,41,19,47)
   escolha := .T.

   WHILE .T.
      IF escolha
         @ 19,31 GET cResSim
      ELSE
         @ 19,41 GET cResNao
      ENDIF
      CLEAR GETS
      INKEY(0)
      IF (LASTKEY()==K_ENTER .AND. escolha) .OR. (LASTKEY()== 83 .OR. LASTKEY()== 115)
         lVarSai := .T.
         EXIT
      ELSEIF LASTKEY()== K_ESC .OR. LASTKEY()== 78 .OR. ;
             LASTKEY()== 110 .OR. LASTKEY()== K_ENTER
         lVarSai := .F.
         EXIT
      ELSEIF LASTKEY()== 19 .OR. LASTKEY()== 4
         IF escolha
            RESTSCREEN(19,31,19,37,TelaSim)
            escolha := .F.
         ELSE
            RESTSCREEN(19,41,19,47,TelaNao)
            escolha := .T.
         ENDIF
      ENDIF
   ENDDO
   SETCOLOR(YCORMENU)
   RESTSCREEN(13,13,22,66,TelaAntes)
   RESTSCREEN(23,00,24,79,LinhaMem)
   RETURN(lVarSai)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA EXIBI─AO DE MENSAGENS OP─OES DOS MENUS               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Msg(texto,p)
   texto += SPACE(80 - LEN(texto))
   IF p<>NIL
      @ 23,00 SAY texto COLOR YCORMENU
      RETURN("")
   ENDIF
   RETURN(texto)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  VISUALIZAR BANCO DE DADOS ESTILO BROWSE                  Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Browser(area,ordem,t,l,b,r,cabec,campo,pic,ativa,sombra,pTitulo,msg)
   LOCAL corant := SETCOLOR()
   PUBLIC Bmsg, Bativa, BQtdMax
   DEFAULT ativa TO .F.

   Bmsg   := msg
   Bativa := ativa

   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF

   Quadro(t-1,l-1,b+1,r+1,1,YCOREDIT,,pTitulo,sombra)

   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   SETCOLOR(YCOREDIT)
   SETCURSOR(0)
   DBEDIT(t,l,b,r,campo,"Processa",pic,cabec,"д","Ё")
   SETCOLOR(corant)
   RELEASE Bmsg, Bativa, BQtdMax
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                        PROCESSAR TECLA PRESSIONADA                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Processa(modo)
   IF modo == 1 .OR. modo == 2
      TONE(125,0)
   ELSEIF modo == 4
      IF ( LASTKEY() == K_F2 )
         Ajuda()
      ELSEIF ( LASTKEY() == K_F6 )
         IF Bativa
            SETKEY(K_INS,{||SETCURSOR(IF(READINSERT(!Insere()),1,2))})
            IF Incluir(IF(Bmsg==NIL,NIL,Bmsg))
               SETKEY(K_INS,NIL)
               RETURN(2)
            ENDIF
            SETKEY(K_INS,NIL)
         ENDIF
      ELSEIF ( LASTKEY() == K_ALT_E )
         IF Bativa
            IF Excluir(IF(Bmsg==NIL,NIL,Bmsg))
               RETURN(2)
            ENDIF
         ENDIF
      ELSEIF ( LASTKEY() == K_RETURN )
         IF Bativa
            SETKEY(K_INS,{||SETCURSOR(IF(READINSERT(!Insere()),1,2))})
            IF Alterar(IF(Bmsg==NIL,NIL,Bmsg))
               SETKEY(K_INS,NIL)
               RETURN(2)
            ENDIF
            SETKEY(K_INS,NIL)
         ENDIF
      ELSEIF ( LASTKEY() == K_ESC )
         GO TOP
         RETURN(0)
      ELSE
         RETURN(1)
      ENDIF
   ENDIF
   RETURN(1)
*
*
PROCEDURE Ajuda()
   LOCAL tela := SAVESCREEN(5,0,20,31)
   LOCAL corant := SETCOLOR()

   SETCOLOR(YCOREDIT)
   @ 5,0 CLEAR TO 19,29
   Quadro(5,0,19,29,1,YCOREDIT,,"Ajuda",.T.)

   @ 06,01 SAY "      sobe uma linha"
   @ 07,01 SAY "      desce uma linha"
   @ 08,01 SAY "PgDn   avanca uma pagina"
   @ 09,01 SAY "PgUp   retorna uma pagina"
   @ 10,01 SAY "^PgDn  final do arquivo"
   @ 11,01 SAY "^PgUp  inicio do arquivo"
   @ 12,01 SAY CHR(26)+"      avanca coluna"
   @ 13,01 SAY CHR(27)+"      retorna coluna"
   @ 14,01 SAY "Home   prim. coluna na tela"
   @ 15,01 SAY "End    ultima coluna na tela"
   @ 16,01 SAY "^Home  coluna inicial"
   @ 17,01 SAY "^End   coluna final"
   @ 18,01 SAY "Esc    encerra"
   INKEY(0)
   SETCOLOR(corant)
   RESTSCREEN(5,0,20,31,tela)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA INSER─AO NA LEITURA DE DADOS DIGITADOS               Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Insere(lNovo)
RETURN(SET(_SET_INSERT, lNovo))
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                ENCRIPTAR/DECRIPTAR SENHAS DE ACESSO                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Codifica(senha)
   LOCAL wSenha  := SPACE(0)
   LOCAL cLetra1 := "ABCDEFGHIJKLMNOPQRSTUVXYWZ0123456789"
   LOCAL cLetra2 := CHR(1)  +CHR(2)  +CHR(3)  +CHR(4)  +CHR(5)  +CHR(11) +CHR(9) +CHR(8)+;
                    CHR(7)  +CHR(6)  +CHR(12) +CHR(14) +CHR(15) +CHR(16) +CHR(17)+;
                    CHR(18) +CHR(19) +CHR(25) +CHR(24) +CHR(23) +CHR(22) +CHR(21)+;
                    CHR(20) +CHR(26) +CHR(27) +CHR(28) +CHR(29) +CHR(30) +CHR(31)+;
                    CHR(240)+CHR(238)+CHR(232)+CHR(135)+CHR(287)+CHR(145)+CHR(146)

   FOR x = 1 TO LEN(senha)
       cTecla1 := AT(SUBSTR(senha,x,1),UPPER(cLetra1))
       cTecla2 := AT(SUBSTR(senha,x,1),UPPER(cLetra2))
       IF cTecla1 = 00 .AND. cTecla2 = 00
          wSenha += SUBSTR(UPPER(wSenha),x,1)
       ELSE
          IF cTecla1 # 00
             wSenha += SUBSTR(UPPER(cLetra2),cTecla1,1)
          ELSE
             wSenha += SUBSTR(UPPER(cLetra1),cTecla2,1)
          ENDIF
       ENDIF
   NEXT
   RETURN(UPPER(wSenha))
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PESQUISA DE CHAVE DE INDICE                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Pesquisa(area,ordem,chave,msg1,msg2)
   LOCAL nAreaAntes:=SELECT();nOrdemAntes:=INDEXORD()

   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF
   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   IF DBSEEK(chave)
      IF msg2#NIL; Aviso(msg2,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.T.)
   ELSE
      IF msg1#NIL; Aviso(msg1,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.F.)
   ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA DE CALCULO DE DIGITO VERIFICADOR DE CPF              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkCPF(NumCpf)
   lResultado := .T.
   IF (INKEY()=K_ESC) .OR. (NumCpf = SPACE(11))
      Aviso("CPF em branco...",,3)
      lResultado := .F.
   ELSE
      Total=0
      FOR K=2 to 10
          Total := VAL(SUBSTR(NumCpf,11-K,1))*K + ToTal
      NEXT
      Quoc  := INT(Total/11)
      Resto := Total-(Quoc*11)
      Resto := 11-Resto
      IF Resto > 9
         R1 := 0
      ELSE
         R1 := Resto
      ENDIF
      Total := 0
      FOR K = 2 TO 11
          Total := VAL(SUBSTR(NumCpf,12-K,1))*K + ToTal
      NEXT
      Quoc  := INT(Total/11)
      Resto := Total-(Quoc*11)
      Resto := 11 - Resto
      IF Resto > 9
         R2 := 0
      ELSE
         R2 := Resto
      ENDIF

      DV := STR(R1,1) + STR(R2,1)
      IF DV<>SUBSTR(NumCpf,10,2)
         Aviso("CPF Inv═lido",,3)
         lResultado := .F.
      ENDIF
   ENDIF
   RETURN(lResultado)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё               ROTINA DE CALCULO DE DIGITO VERIFICADOR DE CGC              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkCGC(WCGCC)
   PRIVATE NCGC, NVAL, INC, N, DGT
   NVAL = 0
   INC  = 2
   N    = 12
   NCGC = WCGCC
   WHILE .T.
     FOR I=N TO 1 STEP -1
         NVAL = VAL(SUBSTR(WCGCC,I,1))*INC+NVAL
         INC = INC + 1
         IF INC > 9
            INC = 2
         ENDIF
     NEXT
     DGT = INT(NVAL/11)*11
     DGT = 11-(NVAL - DGT)
     IF DGT > 9
        DGT = 0
     ENDIF
     WCGCC = SUBSTR(WCGCC,1,N) + STR(DGT,1)
     N = N + 1
     IF N = 14
        EXIT
     ENDIF
     NVAL = 0
     INC = 2
   ENDDO
   IF NCGC == WCGCC
      RETURN(.T.)
   ENDIF
   Aviso("C.G.C. Inv═lido",,3)
   RETURN(.F.)
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё             ROTINA DE VERIFICA─AO DE CORROMPIMENTO DO SISTEMA             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Autor(lAbend,lQuit)
   DEFAULT lQuit TO .T.
   SET(_SET_DEVICE,"SCREEN")

   IF !lAbend
      DELETE FILE ABEND.TES
      SETCOLOR("")
      CLS
      SETCOLOR("N/W")
      JanelaExp(0,0,6,79,1)
      @ 01,02 SAY fSystem
      @ 02,02 SAY "Data               "+DTOC(DATE())
      @ 03,02 SAY "Hora               "+TIME()
      @ 04,02 SAY "Tempo de Execu┤фo  "+ELAPTIME(cTempo,TIME())
      @ 05,02 SAY "Status             T┌rmino Normal"
      SETCOLOR("")
      @ 07,00 SAY ""
   ELSE
      SETCURSOR(1)
      SETCOLOR("")
      CLS
      SET(_SET_DEVICE,"PRINTER")
      QOUT(fSystem)
      QOUT("ATEN─гO => T┌rmino com ABEND  (Favor reportar erro ocorrido)")
      QOUT("")
      SET(_SET_DEVICE,"SCREEN")
   ENDIF
   IF lQuit; QUIT; ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                         LIMPAR LINHA DE MENSAGENS                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION LimpaLinhaMsg(pLin)
   DEFAULT pLin TO 23
   CorAntiga := SETCOLOR()
   SETCOLOR(YCORMENU); @ pLin,00 SAY SPACE(80)
   SETCOLOR(CorAntiga)
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     DISPLAY DA TECLA F2 DE PESQUISA                       Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION TeclaFuncao( texto )
   CorAntes := SETCOLOR()
   SETCOLOR(YCORMENU)

   IF texto <> NIL
      @ 23,64 SAY "<  > - Pesquisa"
      SETCOLOR(YCORTECLAS)
      @ 23,65 SAY "F2"
   ELSE
      @ 23,64 SAY "               "
   ENDIF
   SETCOLOR(CorAntes)
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     CONTROLE DA TECLA F2 DE PESQUISA                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Mostra(cProg, nLin, cVar)
*  PRIVATE ctipomov:=SPACE(2)
   IF cProg == "consulta"
      RETURN NIL
   ENDIF
   SAVE SCREEN
   DO CASE
      CASE cPrg="AE111".OR.(cPrg="AE112".AND. cVar # "WCODINST")
           Consulta(1,2,"Aluno","C╒digo","NOME","MATRIC","MATRIC")
      CASE (cPrg="AE110".OR.cPrg="AE116".OR.cPrg="AE235".OR.cPrg="AE236").AND.cVar=="WMATR"
           Consulta(1,2,"Aluno","C╒digo","NOME","MATRIC","MATRIC")
      CASE (cPrg="AE110".OR.cPrg="AE380").AND. cVar=="XCODCUR"
           Consulta(12,1,"C╒d.","Curso","CODCUR","DESCR","CODCUR")
      CASE (cPrg="AE110".OR.cPrg="AE210".OR.cPrg="AE241".OR.cPrg="AE380").AND.cVar=="XVEICULO"
           SET FILTER TO VEICULO->STATUS="A"
           Consulta(14,3,"Instrutor","Ve║culo","NOME","MARCA","CODVEIC")
           SET FILTER TO
      CASE cPrg="AE120".AND. cVar=="WCODINST"
           SET FILTER TO INSTRUTOR->STATUS="A".AND.(INSTRUTOR->CATEG="1".OR.INSTRUTOR->CATEG="3")
           Consulta(1,1,"Instrutor Ativo","C╒digo","NOME","CODINST","CODINST")
           SET FILTER TO
      CASE cPrg="AE130".AND. cVar=="WCOD"
           Consulta(1,3,"Ve║culo","Instrutor","MARCA","NOME","CODVEIC")
      CASE (cPrg="AE130".OR.cPrg="AE306".OR.cPrg="AE112".OR.cPrg=="AE114").AND. (cVar=="WCODINST".OR.cVar=="WLEG".OR.cVar=="WDDEF".OR.cVar=="WPSOS".OR.cVar=="WMAMB".OR.cVar=="WMECA")
           SET FILTER TO INSTRUTOR->STATUS="A".AND.(INSTRUTOR->CATEG="1".OR.INSTRUTOR->CATEG="3")
           Consulta(2,2,"Instrutor Ativo","C╒digo","NOME","CODINST","CODINST")
           SET FILTER TO
      CASE (cPrg="AE142".OR.cPrg="AE146").AND. cVar=="XCODCUR"
           Consulta(2,1,"C╒d.","Curso","CODCUR","DESCR","CODCUR")

      CASE cPrg="AE144".AND. cVar=="VESCALA"
           Consulta(2,1,"Escala","C╒d","DESCR","ESCALA","ESCALA")
*     CASE cPrg="AE144".AND. cVar=="VCODGRA"
*          Consulta(18,1,"Grade","Curso","CODGRA","CURSO","CODGRA")
      CASE cPrg="AE144".AND. cVar=="VSALA"
           Consulta(15,1,"Sala",,"SALA",,"SALA")

      CASE cPrg="AE146" .AND. cVar=="VCODDIS"
           Consulta(13,1,"C╒digo","Disciplina","CODDIS","DESCR","CODDIS")
      CASE cPrg="AE146".AND. cVar=="VCODINST"
           Consulta(3,2,"Matr.","Professor","CODINST","NOME","CODINST")
      CASE cPrg="AE147".AND. cVar=="VCATEG"
           Consulta(2,1,"Categ.","Descri┤фo","IDCAT","DESCR","IDCAT")

      CASE cPrg="AE151".AND. cVar=="WIDCAT"
           Consulta(2,1,"Ctg","Descri┤фo","IDCAT","DESCR","IDCAT")
      CASE (cPrg="AE151".OR.cPrg="AE271").AND. cVar=="WCONTA"
           Consulta(12,1,"Conta","Descri┤фo","CONTA","DESCR","CONTA")

      CASE cPrg="AE170".AND. cVar="WITEM_CX"
           Consulta(1,2,"Item","Descri┤фo","ITEM_CX","DESCR","ITEM_CX")
      CASE cPrg="AE181".AND. cVar="WNOMEEMP"
           Consulta(1,1,"Razфo Social","C╒digo","NOME","CODFOR","NOME")
      CASE cPrg="AE182".AND. cVar="CRAZAO"
           Consulta(1,1,"Cliente","C╒digo","NOME","CODCLI","NOME")
      CASE (cPrg="AE222".OR.cPrg="AE230".OR.cPrg="AE231".OR.cPrg="AE237".OR.cPrg="AE330".OR.cPrg="AE380");
           .AND. cVar=="WNOM"
           Consulta(3,2,"Aluno","C╒digo","NOME","MATRIC","MATRIC")
      CASE (cPrg="AE210".OR.cPrg="AE211".OR.cPrg="AE232").AND. cVar=="WCOD"
           Consulta(3,2,"Aluno","Matr║cula","NOME","MATRIC","MATRIC")
      CASE (cPrg="AE230".OR.cPrg="AE280".OR.cPrg="AE350").AND. cVar=="WVEI"
           SET FILTER TO VEICULO->STATUS="A"
           Consulta(4,1,"Cod","Ve║culo","CODVEIC","MARCA","CODVEIC",,,,"Placa","PLACA","@R XXX-9999")
           SET FILTER TO
      CASE (cPrg="AE210".OR.cPrg="AE224").AND. cVar=="WVEI"
           SET FILTER TO VEICULO->STATUS="A"
           Consulta(14,1,"Ve║culo","Instrutor","MARCA","NOME","CODVEIC")
           SET FILTER TO
      CASE (cPrg="AE210".OR.cPrg="AE220").AND. cVar=="WINS"
           INSTRUTOR->(DBSETFILTER({||STATUS="A".AND.CATEG#"2"}, [STATUS="A".AND.CATEG#"2"])); INSTRUTOR->(DBGOTOP())
           Consulta(2,2,"Instrutor","C╒digo","NOME","CODINST","CODINST")
           INSTRUTOR->(DBCLEARFILTER())
      CASE cPrg="AE220".AND. cVar=="WCODINST"
           SET FILTER TO INSTRUTOR->STATUS="A".AND.(INSTRUTOR->CATEG="1".OR.INSTRUTOR->CATEG="3")
           Consulta(2,2,"Instrutor","C╒digo","NOME","CODINST","CODINST")
           SET FILTER TO
      CASE (cPrg="AE221".OR.cPrg="AE223".OR.cPrg="AE115".OR.cPrg="AE224".OR.cPrg="AE240".OR.cPrg=="AE114").AND. cVar=="WMATR"
           Consulta(3,2,"Aluno","C╒digo","NOME","MATRIC","MATRIC")
      CASE (cPrg="AE241").AND. cVar=="WMATRIC"
           Consulta(3,2,"Aluno","C╒digo","NOME","MATRIC","MATRIC")
      CASE cPrg="AE222".AND. cVar=="WVEI"
           SET FILTER TO VEICULO->STATUS="A"
           Consulta(14,3,"Ve║culo","Instrutor","MARCA","NOME","CODVEIC")
           SET FILTER TO

*     CASE cPrg="AE230".AND. cVar=="XDESCR"
*          Consulta(6,1,"Infra┤фo","Grau","DESCR","GRAU","DESCR")
      CASE (cPrg="AE232".OR.cPrg="AE233".OR.cPrg="AE234".OR.cPrg="AE235".OR.cPrg="AE236").AND.(cVar=="WTURMA".OR.cVar=="WTURMANOVA")
           Consulta(5,1,"Turma","In║cio","TURMA","DTINI","TURMA")
      CASE (cPrg="AE232".OR.cPrg="AE233".OR.cPrg="AE234".OR.cPrg="AE235".OR.cPrg="AE236").AND.cVar=="WINST"
           Consulta(3,1,"Instrutor","C╒digo","NOME","CODINST","CODINST")
      CASE (cPrg="AE232".OR.cPrg="AE233".OR.cPrg="AE234".OR.cPrg="AE235".OR.cPrg="AE236").AND.cVar=="WDISC"
           Consulta(4,1,"Disciplina","C╒digo","DESCR","CODDIS","CODDIS")
      CASE (cPrg="AE250".OR.cPrg="AE251".OR.cPrg="AE252").AND. cVar="NCODEMP"
           Consulta(2,2,"Razфo Social","C╒digo","NOME","CODFOR","CODFOR")
      CASE (cPrg="AE250".OR.cPrg="AE251".OR.cPrg="AE252").AND. cVar="CNFAT"
           l_f2:=.T.
           Consulta(10,1,"Fatura","NF","NDOC","NF","NDOC",,,,"Valor a Pagar","VLR","@E 999,999,999.99")
      CASE cPrg="AE251".AND. cVar="WITEM_CX"
           Consulta(4,2,"Item","Descri┤фo","ITEM_CX","DESCR","ITEM_CX")
      CASE cPrg="AE251".AND. cVar="WCONTA"
           Consulta(3,1,"Bco/Agencia/Conta",,"CONTA",,"CONTA",,"@R 999/!!!!!!!/!!!!!!!!!!!!!",,"Titular","TITULAR")
      CASE cPrg="AE257" .AND. cVar="WCOD_CF"
           Consulta(2,2,"Fornecedor","C╒digo","NOME","CODFOR","CODFOR")
      CASE cPrg="AE261".AND. cVar="WNFAT"
           Consulta(1,2,"Fatura","Dt.a Receber","NDOC","DTAREC","NDOC")
      CASE cPrg="AE261".AND. cVar="WCOD_CF"
           Consulta(2,2,"Cliente","C╒digo","NOME","CODCLI","CODCLI")
      CASE (cPrg="AE261".OR.cPrg="AE250".OR.cPrg="AE290").AND. cVar="WITEM_CX"
           Consulta(3,2,"Item","Descri┤фo","ITEM_CX","DESCR","ITEM_CX")
      CASE cPrg="AE261".AND. cVar="WCONTA"
           Consulta(4,1,"Bco/Agencia/Conta",,"CONTA",,"CONTA",,"@R 999/!!!!!!!/!!!!!!!!!!!!!",,"Titular","TITULAR")

      CASE cPrg="AE271".AND. cVar="XITEM_CX"
           Consulta(4,2,"Item","Descri┤фo","ITEM_CX","DESCR","ITEM_CX")


      CASE cPrg="AE290".AND.cVar="WITEM_CX"
           Consulta(3,2,"Item","Descri┤фo","ITEM_CX","DESCR","ITEM_CX")
      CASE cPrg="AE290"
           Consulta(1,1,"Bco/Agencia/Conta",,"CONTA",,"CONTA",,"@R 999/!!!!!!!/!!!!!!!!!!!!!",,"Titular","TITULAR")
      CASE (cPrg="AE331".OR.cPrg="AE391").AND. cVar=="WNOM"
           Consulta(2,2,"Instrutor","C╒digo","NOME","CODINST","CODINST")
      CASE (cPrg="AE306".AND. cVar=="WCODVEIC")
           Consulta(4,1,"C╒d","Ve║culo","CODVEIC","MARCA","CODVEIC")
      CASE (cPrg="AE332".AND. cVar=="WMATRICULA")
           Consulta(3,2,"Matr.","Aluno","MATRIC","NOME","MATRIC")
   ENDCASE
   RESTORE SCREEN
   RETURN NIL
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                 CONTROLE DE OPERACAOES DELECAO E ALTERACAO                Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION DeleAltera()
   SETCOLOR(YCORMENU); Mensagem(); SETCURSOR(0)
   @ 23,01 SAY "Informe a Opera┤фo.   (     ) Altera   (   ) Exclui       "
   SETCOLOR(YCORTECLAS)
   @ 23,24 SAY "ENTER"; @ 23,41 SAY "DEL"
   WHILE .T.
      INKEY(0)
      IF LASTKEY()==K_ESC.OR.LASTKEY()==K_ENTER.OR.LASTKEY()==K_DEL; EXIT; ENDIF
   ENDDO
   SETCURSOR(1); Mensagem()
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                   DISPLAY DE MENSAGEM AGUARDANDO PROCESSAMENTO            Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
PROCEDURE Aguardar(Par1)
   CorAntes := SETCOLOR()
   ModAnTes := SETCURSOR()

   SETCURSOR( 0 )
   SETCOLOR( "" )
   IF Par1 == NIL
      ImplodBox()
   ELSE
      nCol := 76 - LEN(Par1)
      ExplodBox( 21, nCol, 23, 77 )
      //SETCOLOR("W+*/N")
      SETCOLOR(YCORAVISO)
      @ 22,nCol+01 SAY Par1
      SETCOLOR("")
   ENDIF
   SETCURSOR( ModAntes )
   SETCOLOR( CorAntes )
   RETURN
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                  ROTINA DE CHECAGEM DE ESTADO VALIDO                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION ChkUF(wUF)
   LOCAL aArray := ARRAY(1)
   aArray := {"PA","CE","RN","SP","ES","BA","RS","MG","PR","MS","GO",;
              "RJ","SE","AL","SC","PE","RO","MA","PR","DF","MT","PB",;
              "PI","AM","TO","AC","AP"}
   IF ASCAN(aArray,wUF) <> 0
      RETURN .T.
   ENDIF
   Aviso("Estado Inv═lido",,3)
   RETURN .F.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                          ABERTURA DE ARQUIVO EM REDE                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetUse( Arquivo, Apelido, Modo )
   LOCAL msg, nSeconds
   Msg     := "Nфo Foi Possivel Acessar. Continua Tentando ?"
   Modo    := IF( Modo = NIL, "C", Modo )
   Apelido := IF( Apelido = NIL, Arquivo, Apelido )
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         IF Modo == "E"
            USE ( Arquivo ) ALIAS ( Apelido ) EXCLUSIVE
         ELSE
            USE ( Arquivo ) ALIAS ( Apelido ) SHARED
         ENDIF
         IF ! NETERR()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(msg)
         RETURN .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             INCLUIR REGISTRO EM REDE                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetApp(Arquivo)
   LOCAL msg, nSeconds, SeleAnt := SELECT()
   Msg := "Nфo Foi Possivel Atualizar. Continua Tentando ?"
   IF Arquivo != NIL
      SELECT (Arquivo)
   ENDIF
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         DBAPPEND()
         IF !NETERR()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(MSG)
         RETURN .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             BLOQUEAR ARQUIVO                              Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetLArq()
   LOCAL msg, nSeconds
   Msg := "Nфo Foi Poss║vel Atualizar. Continua Tentando ?"
   WHILE .T.
      nSeconds := 3
      WHILE nSeconds > 0
         IF FLOCK()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(msg)
         Return .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                             BLOQUEAR REGISTRO                             Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION NetLReg()
   LOCAL msg, nSeconds
   Msg := "Nфo Foi Poss║vel Registrar. Continua Tentando ?"
   WHILE .T.
      nSeconds := 2
      WHILE nSeconds > 0
         IF RLOCK()
            RETURN .T.
         ENDIF
         INKEY(0.5)
         nSeconds -= 0.5
      ENDDO
      IF !Confirma(msg)
         Return .F.
      ENDIF
   ENDDO
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                       VERIFICAR ACESSO DE USUARIO                         Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Acesso(pNivel)
   IF nNivel >= pNivel
      RETURN .T.
   ELSE
      Aviso("Usu═rio nфo Autorizado...",,3)
      RETURN .F.
   ENDIF
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                          DESENHAR MENSAGEM DE QUADRO                      Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION MsgTela(nLin,nCol,sTexto,lModo)
   LOCAL nTamStr:=LEN(sTexto)
   lModo:=IF(lModo==NIL,.F.,.T.)
   @ nLin,nCol         SAY sTexto            COLOR YCORAVISO
   @ nLin,nCol+nTamStr SAY "э"               COLOR YCOREDIT
   @ nLin+1,nCol+1     SAY REPL("ъ",nTamStr) COLOR YCOREDIT
   RETURN NIL
*умммммммммммммммммммммммммммммммм╦
*Ё Pesquisar Ponteiro do Browse   Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Goto_Top(searcher)
   DBSEEK(searcher)
   RETURN NIL
*умммммммммммммммммммммммммммммммм╦
*Ё Encontrar registro mais prox.  Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Goto_Bott(searcher)
   LOCAL save_soft
   save_soft = SET(_SET_SOFTSEEK, .T.)
   SEEK SUBSTR(searcher, 1, LEN(searcher) - 1) + ;
        CHR(ASC(SUBSTR(searcher, LEN(searcher))) + 1)
   SKIP -1
   SET(_SET_SOFTSEEK, save_soft)
   RETURN NIL
*умммммммммммммммммммммммммммммммм╦
*Ё Controla ponteiro no Browse    Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Move_Pointer(num_to_skip,SEARCHER,d_key_cb)
   LOCAL num_skipped := 0

   IF EOF()
   ELSEIF num_to_skip = 0
      SKIP 0
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. num_skipped != num_to_skip .AND. EVAL(d_key_cb) = searcher
         IF num_to_skip > 0
            SKIP
            num_skipped++
         ELSE
            SKIP -1
            num_skipped--
         ENDIF
      ENDDO

      IF EOF()
         SKIP -1
         num_skipped--
      ELSEIF BOF()
         num_skipped++
         SKIP
         SKIP -1
      ELSEIF EVAL(d_key_cb) != searcher
         IF num_to_skip > 0
            SKIP -1
            num_skipped--
         ELSE
            SKIP
            num_skipped++
         ENDIF
      ENDIF
   ENDIF
   RETURN num_skipped
*умммммммммммммммммммммммммммммммм╦
*Ё Imprimir Extenso do Valor      Ё
*тмммммммммммммммммммммммммммммммм╬
PROCEDURE Imp_Extenso(pValor)
  texto := ""
  n1:="UM "; n2:="DOIS "; n3:= "TRES "; n4:="QUATRO "; n5:="CINCO "
  n6:="SEIS "; n7:="SETE "; n8:="OITO "; n9:="NOVE "; n10:="DEZ "
  n11:="ONZE "; n12:="DOZE "; n13:="TREZE "; n14:="QUATORZE "; n15:="QUINZE "
  n16:="DEZESSEIS "; n17:="DEZESSETE "; n18:="DEZOITO "; n19:="DEZENOVE "
  n20:="VINTE "; n30:="TRINTA "; n40:="QUARENTA "; n50:="CINQUENTA "
  n60:="SESSENTA "; n70:="SETENTA "; n80:="OITENTA "; n90:="NOVENTA "
  n000:="CEM "; n100:="CENTO "; n200:="DUZENTOS "; n300:="TREZENTOS "
  n400:="QUATROCENTOS "; n500:="QUINHENTOS "; n600:="SEISCENTOS "
  n700:="SETECENTOS "; n800:="OITOCENTOS "; n900:="NOVECENTOS "

  T1 := ""; T2 := "MIL "; T3 := "MILHAO "; T4 := "BILHAO "
  V1 := ""; V2 := "MIL "; V3 := "MILHOES "; V4 := "BILHOES "

  xnumero := STR(INT(pValor),12,0)
  P4 := SUBSTR(xnumero,1,3)
  P3 := SUBSTR(xnumero,4,3)
  P2 := SUBSTR(xnumero,7,3)
  P1 := SUBSTR(xnumero,10,3)
  P0 := STR((pValor - INT(pValor)) * 100,2)
  S4 := VAL(P4 + "000000000.00")
  S3 := VAL(P4 + P3 + "000000.00")
  S2 := VAL(P4 + P3 + P2 + "000.00")
  S1 := VAL(P4 + P3 + P2 + P1 + ".00")
  FOR x := 4 TO 1 STEP -1
      w := ALLTRIM(STR(x))
      IF VAL(P&w) # 0
         num1     := SUBSTR(P&w,1,1)
         num2     := SUBSTR(P&w,2,1)
         num3     := SUBSTR(P&w,3,1)
         lstatus  := IF(num2 # "1",.T.,.F.)
         primeiro := .T.
         IF !EMPTY(num1) .AND. num1 # "0"
            IF num1 = "1" .AND. num2+num3 = "00"
               num1 := "000"
            ELSE
               num1 := num1 + "00"
            ENDIF
            IF pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num1,texto + N&num1)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num1,texto + N&num1)
            ENDIF
            primeiro := .F.
         ENDIF
         IF !EMPTY(num2)  .AND. num2 # "0"
            num2 := IF(lstatus,num2 + "0",num2 + num3)
            IF primeiro .AND. pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num2,texto + N&num2)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num2,texto + N&num2)
            ENDIF
            primeiro := .F.
         ENDIF
         IF !EMPTY(num3) .AND. num3 # "0" .AND. lstatus
            IF primeiro .AND. pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num3,texto + N&num3)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num3,texto + N&num3)
            ENDIF
         ENDIF
         texto := IF(VAL(P&w)=1,texto + T&w,texto + V&w)
      ENDIF
  NEXT
  IF VAL(xnumero) # 0
     IF VAL(xnumero) = 1
        texto := texto + "REAL "
     ELSEIF VAL(P2) = 0 .AND. VAL(P1) = 0
        texto := texto + "DE REAIS "
     ELSE
        texto := texto + "REAIS "
     ENDIF
  ENDIF
  IF VAL(P0) # 0
     num1 := SUBSTR(P0,1,1)
     num2 := SUBSTR(P0,2,1)
     IF !EMPTY(num1) .AND. num1 # "0"
        num1  := IF(num1 # "1",num1 + "0",num1 + num2)
        texto := IF(!EMPTY(texto),texto + "E " + N&num1,texto + N&num1)
     ENDIF
     IF !EMPTY(num2) .AND. num2 # "0" .AND. num1 # "1"
        texto := IF(!EMPTY(texto),texto + "E " + N&num2,texto + N&num2)
     ENDIF
     IF VAL(P0) = 1
        texto := texto + "CENTAVO"
     ELSE
        texto := texto + "CENTAVOS"
     ENDIF
  ENDIF
  tam := final := 44
  IF LEN(texto) > 44
     WHILE SUBSTR(texto,final,1) # " "
        final := final - 1
     ENDDO
     pLin1 := SUBSTR(texto,1,final)
     pLin2 := SUBSTR(texto,final+1,LEN(texto)-final)
  ELSE
     pLin1 := texto
     pLin2 := ""
  ENDIF
  pLin1 := ALLTRIM(pLin1)
  pLin2 := ALLTRIM(pLin2)
  IF LEN(pLin1) < 44 .AND. EMPTY(pLin2)
     pLin1 := pLin1 + REPLICATE("*",44-LEN(pLin1))
  ENDIF
  @ PROW(),PCOL()+1 SAY PLIN1
  IF !EMPTY(pLin2)
    IF LEN(pLin2) < 73
       pLin2 := pLin2 + REPLICATE("*",73-LEN(pLin2))
    ENDIF
    @ PROW()+1,03 SAY PLIN2
  ENDIF
  @ PROW(),PCOL()+1 SAY ")"
RETURN
*умммммммммммммммммммммммммммммммм╦
*Ё Gerar Extenso do Valor         Ё
*тмммммммммммммммммммммммммммммммм╬
PROCEDURE Extenso(pValor)
  texto := ""
  n1:="UM "; n2:="DOIS "; n3:= "TRES "; n4:="QUATRO "; n5:="CINCO "
  n6:="SEIS "; n7:="SETE "; n8:="OITO "; n9:="NOVE "; n10:="DEZ "
  n11:="ONZE "; n12:="DOZE "; n13:="TREZE "; n14:="QUATORZE "; n15:="QUINZE "
  n16:="DEZESSEIS "; n17:="DEZESSETE "; n18:="DEZOITO "; n19:="DEZENOVE "
  n20:="VINTE "; n30:="TRINTA "; n40:="QUARENTA "; n50:="CINQUENTA "
  n15:="QUINZE "
  n25:="VINTE E CINCO "
  n35:="TRINTA E CINCO "
  n45:="QUARENTA E CINCO "
  n55:="CINQUENTA E CINCO "
  n65:="SESSENTA E CINCO "
  n75:="SETENTA E CINCO "
  n85:="OITENTA E CINCO "
  n95:="NOVENTA E CINCO "
  n60:="SESSENTA "; n70:="SETENTA "; n80:="OITENTA "; n90:="NOVENTA "
  n000:="CEM "; n100:="CENTO "; n200:="DUZENTOS "; n300:="TREZENTOS "
  n400:="QUATROCENTOS "; n500:="QUINHENTOS "; n600:="SEISCENTOS "
  n700:="SETECENTOS "; n800:="OITOCENTOS "; n900:="NOVECENTOS "

  T1 := ""; T2 := "MIL "; T3 := "MILHAO "; T4 := "BILHAO "
  V1 := ""; V2 := "MIL "; V3 := "MILHOES "; V4 := "BILHOES "

  xnumero := STR(INT(pValor),12,0)
  P4 := SUBSTR(xnumero,1,3)
  P3 := SUBSTR(xnumero,4,3)
  P2 := SUBSTR(xnumero,7,3)
  P1 := SUBSTR(xnumero,10,3)
  P0 := STR((pValor - INT(pValor)) * 100,2)
  S4 := VAL(P4 + "000000000.00")
  S3 := VAL(P4 + P3 + "000000.00")
  S2 := VAL(P4 + P3 + P2 + "000.00")
  S1 := VAL(P4 + P3 + P2 + P1 + ".00")
  FOR x := 4 TO 1 STEP -1
      w := ALLTRIM(STR(x))
      IF VAL(P&w) # 0
         num1     := SUBSTR(P&w,1,1)
         num2     := SUBSTR(P&w,2,1)
         num3     := SUBSTR(P&w,3,1)
         lstatus  := IF(num2 # "1",.T.,.F.)
         primeiro := .T.
         IF !EMPTY(num1) .AND. num1 # "0"
            IF num1 = "1" .AND. num2+num3 = "00"
               num1 := "000"
            ELSE
               num1 := num1 + "00"
            ENDIF
            IF pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num1,texto + N&num1)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num1,texto + N&num1)
            ENDIF
            primeiro := .F.
         ENDIF
         IF !EMPTY(num2) .AND. num2 # "0"
            num2 := IF(lstatus,num2 + "0",num2 + num3)
            IF primeiro .AND. pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num2,texto + N&num2)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num2,texto + N&num2)
            ENDIF
            primeiro := .F.
         ENDIF
         IF !EMPTY(num3) .AND. num3 # "0" .AND. lstatus
            IF primeiro .AND. pValor > S&w
               texto := IF(!EMPTY(texto),ALLTRIM(texto) + ", " + N&num3,texto + N&num3)
            ELSE
               texto := IF(!EMPTY(texto),texto + "E " + N&num3,texto + N&num3)
            ENDIF
         ENDIF
         texto := IF(VAL(P&w)=1,texto + T&w,texto + V&w)
      ENDIF
  NEXT
  IF VAL(xnumero) # 0
     IF VAL(xnumero) = 1
        texto := texto + "REAL "
     ELSEIF VAL(P2) = 0 .AND. VAL(P1) = 0
        texto := texto + "DE REAIS "
     ELSE
        texto := texto + "REAIS "
     ENDIF
  ENDIF
  IF VAL(P0) # 0
     num1 := SUBSTR(P0,1,1)
     num2 := SUBSTR(P0,2,1)
     IF !EMPTY(num1) .AND. num1 # "0"
        num1  := IF(num1 # "1",num1 + "0",num1 + num2)
        texto := IF(!EMPTY(texto),texto + "E " + N&num1,texto + N&num1)
     ENDIF
     IF !EMPTY(num2) .AND. num2 # "0" .AND. num1 # "1"
        texto := IF(!EMPTY(texto),texto + "E " + N&num2,texto + N&num2)
     ENDIF
     IF VAL(P0) = 1
        texto := texto + "CENTAVO"
     ELSE
        texto := texto + "CENTAVOS"
     ENDIF
  ENDIF
  tam := final := 44
  IF LEN(texto) > 44
     WHILE SUBSTR(texto,final,1) # " "
        final := final - 1
     ENDDO
     pLin1 := SUBSTR(texto,1,final)
     pLin2 := SUBSTR(texto,final+1,LEN(texto)-final)
  ELSE
     pLin1 := texto
     pLin2 := ""
  ENDIF
  pLin1 := ALLTRIM(pLin1)
  pLin2 := ALLTRIM(pLin2)
  IF LEN(pLin1) < 44 .AND. EMPTY(pLin2)
     pLin1 := pLin1 + REPLICATE("*",44-LEN(pLin1))
  ENDIF
  RETURN(PLIN1)
*умммммммммммммммммммммммммммммммм╦
*Ё Mensagem de Espera             Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION WaitMsg(pTexto,pBeep)
   LOCAL tecla:=INKEY(.09), nCursor:=SETCURSOR(); cCorAntes:=SETCOLOR()
   DEFAULT pTexto TO "Pressione qualquer tecla para continuar..."
   DEFAULT pBeep  TO .T.

   Mensagem()
   IF pBeep; Beep(2); ENDIF
   SETCOLOR(YCORMENU); SETCURSOR(0)
   pTexto := SPACE(5) + pTexto + SPACE(5)
   WHILE tecla # K_ENTER
      FOR i = 1 TO 400; NEXT
      pTexto := SUBSTR(pTexto,2,LEN(pTexto)) + SUBSTR(pTexto,1,1)
      @ 23,00 SAY PADC(pTexto,80)
      tecla := INKEY(.09)
      IF tecla # 0
         tecla := K_ENTER
      ENDIF
   ENDDO
   Mensagem()
   SETCURSOR(nCursor); SETCOLOR(cCorAntes)
   RETURN NIL
*умммммммммммммммммммммммммммммммм╦
*Ё Processar Tecla do Browse      Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION ProcKey (oBr,nKey)
   STATIC aKey:= { K_DOWN,       { |oBr| oBr:down() } ,;
                   K_UP,         { |oBr| oBr:up() } ,;
                   K_PGDN,       { |oBr| oBr:pageDown() } ,;
                   K_PGUP,       { |oBr| oBr:pageUp() } ,;
                   K_CTRL_PGUP,  { |oBr| oBr:goTop() } ,;    
                   K_CTRL_PGDN,  { |oBr| oBr:goBottom() } ,;
                   K_RIGHT,      { |oBr| oBr:right() } ,;
                   K_LEFT,       { |oBr| oBr:left() } ,;
                   K_HOME,       { |oBr| oBr:home() } ,;
                   K_END,        { |oBr| oBr:end() } ,;
                   K_CTRL_LEFT,  { |oBr| oBr:panLeft() } ,;
                   K_CTRL_RIGHT, { |oBr| oBr:panRight() } ,;
                   K_CTRL_HOME,  { |oBr| oBr:panHome() } ,;
                   K_CTRL_END,   { |oBr| oBr:panEnd() } }
   LOCAL nI

   nI:=ASCAN(aKey,nKey)
   IF nI!=0
        EVAL(aKey[++nI],oBr)
   ENDIF
   RETURN NIL
*умммммммммммммммммммммммммммммммм╦
*Ё Retorna Verdadeiro             Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Let(); RETURN .T.
*умммммммммммммммммммммммммммммммм╦
*Ё Retorna Falso                  Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Lef(); RETURN .F.
*умммммммммммммммммммммммммммммммм╦
*Ё Linha de mensagens e ajuda     Ё
*тмммммммммммммммммммммммммммммммм╬
FUNCTION Linha23(pTexto,pLinha)
   LOCAL lContCor:=.T., nCol:=1, nPosic
   DEFAULT pLinha TO 23

   @ pLinha,00 SAY SPACE(80) COLOR YCORMENU
   nPosic := AT("^",pTexto)
*  pTexto := RIGHT(pTexto,LEN(pTexto)-nPosic)
   WHILE nPosic<>0
      IF (nPosic:=AT("^",pTexto))<>0
         @ pLinha,nCol SAY SUBS(pTexto,1,nPosic-1) COLOR IF(lContCor,YCORMENU,YCORTECLAS)
         lContCor=!lContCor
         pTexto := RIGHT(pTexto,LEN(pTexto)-(nPosic))
         nCol   += nPosic-1
      ENDIF
   ENDDO
   @ pLinha,nCol SAY pTexto COLOR IF(lContCor,YCORMENU,YCORTECLAS)
   RETURN .T.
*умммммммммммммммммммммммммммммм╦
*Ё Extenso do Mes               Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION ExtMes(sDat)
  LOCAL aMes:={"Janeiro","Fevereiro","Marco","Abril","Maio","Junho",;
               "Julho","Agosto","Setembro","Outubro","Novembro","Dezembro"}
  RETURN aMes[MONTH(sDat)]
*умммммммммммммммммммммммммммммм╦
*Ё Extenso do Dia               Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION ExtDia(pDat)
  LOCAL aDia:={"Domingo","Segunda","Ter┤a","Quarta","Quinta","Sexta","S═bado"}
  RETURN aDia[DOW(pDat)]
*умммммммммммммммммммммммммммммм╦
*Ё Extenso do Dia Resumo        Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION ExtDia2(pDat)
  LOCAL aDia:={"Dom","Seg","Ter","Qua","Qui","Sex","Sab"}
  IF EMPTY(pDat); pDat:=STR(DOW(DATE()),1); ENDIF
  RETURN aDia[VAL(pDat)]
*умммммммммммммммммммммммммммммм╦
*Ё Display de Descricoes        Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION TDescr(pArea,pOrdem,pLin,pCol,pChave,pRet,pMasc,pAviso,pCor,pRet2,pMasc2,pSubTexto)
   LOCAL cArea:=SELECT(),cOrdem:=INDEXORD()
   DEFAULT pSubTexto TO ""
   DEFAULT pMasc  TO ["@!"]
   DEFAULT pMasc2 TO ["@!"]
   DEFAULT pCor   TO YCORREALCE

   SELECT (pArea)
   SET ORDER TO (pOrdem)
   IF !DBSEEK(pChave)
      IF EMPTY(pChave)
         @ pLin,pCol   SAY " "                 COLOR pCor
         @ pLin,pCol+2 SAY &pRet. PICT &pMasc. COLOR pCor
      ELSE
         IF pAviso<>NIL; Aviso(pAviso,,3); ENDIF
      ENDIF
      SELECT(cArea); SET ORDER TO (cOrdem)
      RETURN .F.
   ELSE
      @ pLin,pCol   SAY CHR(26)             COLOR "W+/N*"
      @ pLin,pCol+2 SAY &pRet. PICT &pMasc. COLOR pCor
      IF pRet2#NIL
         @ pLin,pCol+LEN(&pMasc.)-1 SAY pSubTexto COLOR pCor
         @ pLin,pCol+LEN(&pMasc.)+LEN(pSubTexto)-1 SAY &pRet2. PICT &pMasc2. COLOR pCor
      ENDIF
   ENDIF
   SELECT(cArea); SET ORDER TO (cOrdem)
   RETURN .T.
*умммммммммммммммммммммммммммммм╦
*Ё Testar Niveis de Acesso      Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION TNivel(pNivel)
   LOCAL tela := SAVESCREEN(2,0,24,79)
   IF VALTYPE(pNivel)=="N"
      pNivel := STR(pNivel,1)
   ENDIF
   IF !(pNivel $ "1359")
      Quadro(9,14,14,37,1,YCOREDIT,.T.,,.T.)
      @ 10,16 SAY "Consulta........: 1"
      @ 11,16 SAY "Alt/Exc/Incl/Con: 3"
      @ 12,16 SAY "Manuten┤фo......: 5"
      @ 13,16 SAY "Geral...........: 9"
      Aviso("Valores Permitidos: 1, 3, 5 ou 9. Tecle algo...")
      RESTSCREEN(2,0,24,79,tela)
      RETURN .F.
   ENDIF
   RESTSCREEN(2,0,24,79,tela)
   RETURN .T.
*умммммммммммммммммммммммммммммм╦
*Ё Cancelamento de Impressao    Ё
*тмммммммммммммммммммммммммммммм╬
PROCEDURE Cab_ESC(nProw,nPcol,cTexto,cMascara)
   IF Continua
      Continua := EscPrint()
      IF Continua
         IF VALTYPE( cMascara ) = "U"
            @ PROW()+nProw,nPcol SAY cTexto
         ELSE
            @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara
         ENDIF
      ENDIF
   ELSE
      DBGOBOTTOM(); DBSKIP()
   ENDIF
   RETURN
*умммммммммммммммммммммммммммммм╦
*Ё Editar Memo                  Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION EditaMemo(cVar,lse,cse,lid,cid,c_obs,lwrite)
   LOCAL         i,;
                 newcol,;
                 num_lines,;
                 CorAntes:=SETCOLOR()//,;
*                xessa_tela:=SAVESCREEN(lse-1,cse-1,lid,cid)


   PRIVATE       srch_str,;
                 search_active,;
                 init_row,;
                 init_col,;
                 init_rel_row,;
                 init_rel_col,;
                 aBarra

   lWrite   := IF(lWrite=NIL,.T.,lWrite)
   srch_str := SPACE(80)
   cCampo   := MLCOUNT(cVar,50)
   _lse     := lse-1
   _cse     := cse-1
   _lid     := lid
   _cid     := cid

   IF lWrite
      @ 24,00 SAY REPLI(' ',80) COLOR YCORMENU
      @ 24,00 SAY "  -Grava Sai" COLOR YCORMENU
      @ 24,66 SAY "lin     col" COLOR YCORMENU
      @ 24,00 SAY "F3"          COLOR YCORTECLAS
   ENDIF
   @ lse-1,cse SAY PADC(c_obs,cid-cse+1) COLOR YCORAVISO
   SETCOLOR(YCORMENU)

   // Edita Campo Memo
   init_row=1; init_col=0
   init_rel_row=0; init_rel_col=0
   lReentre:=search_active:=.T.
   aBarra:=ScrollBarNew(lse,cse-1,lid,YCORREALCE)
   aBarra:=ScrollBarDisplay(aBarra)

   WHILE lReentre
      search_active:=.F.
      cVar:=MEMOEDIT(cVar,lse,cse,lid,cid,lwrite,"MEdita",,,;
                    init_row,init_col,init_rel_row,init_rel_col)
      IF LASTKEY()<>K_ESC
          cvar:= TRIM(cvar)
      ENDIF
      IF search_active
         new_col=AT(trim(srch_str), SUBSTR(MEMOLINE(INFO,cid-cse+1,init_row), init_col+1))
         IF new_col != 0
            init_col=new_col - 1 + init_col
            init_rel_col=init_col
         ELSE
            num_lines=mlcount(cvar,cid-cse+1)
            new_col=0
            i=init_row + 1
            WHILE new_col == 0 .AND. i <= num_lines
               new_col = AT(TRIM(srch_str),MEMOLINE(cvar,cid-cse+1,i))
               IF new_col=0
                  i++
               ENDIF
            ENDDO
            IF new_col !=0
               init_col=new_col - 1
               init_rel_col=init_col
               init_row=i
               init_relrow=(i-1)%(lid-lse+1)
            ELSE
               Aviso("Texto N└o Encontrado")
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   @ 24,00 SAY SPACE(80) COLOR YCORMENU
   IF LASTKEY()=27
      KEYBOARD CHR(13)
      INKEY(0)
   ENDIF
*  RESTSCREEN(lse-1,cse-1,lid,cid,xessa_tela)
   RETURN .F.
*умммммммммммммммммммммммммммммм╦
*Ё Redefinir Teclas do MEMOEDIT Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION MEdita(modo,nLin,nCol)
   MEMVAR       init_row,;
                init_col,;
                init_rel_row,;
                ini_rel_col,;
                search_active,;
                lse, cse,;
                srch_str,;
                aBarra

   LOCAL        ret_val,;
                save_line,;
                getlist:={}

   LOCAL nRet := .F., nTecla := LASTKEY()
 
   @ 24,70 SAY TRIM(STR(nLin,IF(nLin<100,2,3),0)) COLOR YCORREALCE
   @ 24,78 SAY TRIM(STR(nCol,2,0))                COLOR YCORREALCE
   IF modo==ME_INIT
      nRet:=ME_DEFAULT
   ELSE
      cCampo:=IF(nLin>cCampo,nLin,cCampo)
      aBarra:=ScrollBarUpdate( aBarra, nLin, cCampo )
      IF nTecla==K_F3
         nRet:=K_CTRL_W
         lReentre:=.F.
*     ELSEIF nTecla==K_CTRL_F3
*        init_row=nlin
*        init_col=ncol
*        init_rel_row= row() - lse
*        init_rel_col= col() - cse
*        nRet:=K_CTRL_W
*        lReentre:=.T.
      ELSEIF nTecla==K_ESC
         lReentre:=.F.
*     ELSEIF LASTKEY()==K_ALT_S
*        init_row=nlin
*        init_col=ncol
*        init_rel_row= row() - lse
*        init_rel_col= col() - cse
*        srch_str:=PegTexto()
*        nRet=K_CTRL_W
*        search_active=.T.
      ENDIF
   ENDIF
   RETURN nRet
*умммммммммммммммммммммммммммммм╦
*Ё Pegar Texto                  Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION PegTexto()
   LOCAL sTexto:=SPACE(80), GetList:={},CorAntes:=SETCOLOR(YCOREDIT)
   Telas(20,10,22,65,1,YCOREDIT,.T.)
   @ 21,11 SAY "Pesquisar por" GET sTexto PICT[@S40K] COLOR YCOREDIT
   READMODAL(getlist)
   SETCOLOR(CorAntes)
   Rest_Tela()
   RETURN sTexto
*умммммммммммммммммммммммммммммм╦
*Ё Rolagem da Barra             Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION ScrollBarNew( nTopRow, nTopColumn, nBottomRow,cColorString, nInitPosition )
   LOCAL aScrollBar := ARRAY( TB_ELEMENTS )

   aScrollBar[ TB_ROWTOP ]    := nTopRow
   aScrollBar[ TB_COLTOP ]    := nTopColumn
   aScrollBar[ TB_ROWBOTTOM ] := nBottomRow
   aScrollBar[ TB_COLBOTTOM ] := nTopColumn

   // Set the default color to White on Black if none specified
   IF cColorString == NIL
      cColorString := "W/N"
   ENDIF
   aScrollBar[ TB_COLOR ] := cColorString

   // Set the starting position
   IF nInitPosition == NIL
      nInitPosition := 1
   ENDIF
   aScrollBar[ TB_POSITION ] := nInitPosition

   RETURN ( aScrollBar )
*умммммммммммммммммммммммммммммм╦
*Ё Display da Barra de Rolagem  Ё
*тмммммммммммммммммммммммммммммм╬
FUNCTION ScrollBarDisplay( aScrollBar )
   LOCAL cOldColor
   LOCAL nRow

   cOldColor := SETCOLOR( aScrollBar[ TB_COLOR ] )

   // Draw the arrows
   @ aScrollBar[ TB_ROWTOP ], aScrollBar[ TB_COLTOP ] SAY TB_UPARROW
   @ aScrollBar[ TB_ROWBOTTOM ], aScrollBar[ TB_COLBOTTOM ] SAY TB_DNARROW

   // Draw the background
   FOR nRow := (aScrollBar[ TB_ROWTOP ] + 1) TO (aScrollBar[ TB_ROWBOTTOM ] - 1)
      @ nRow, aScrollBar[ TB_COLTOP ] SAY TB_BACKGROUND
   NEXT
   SETCOLOR( cOldColor )
   RETURN ( aScrollBar )
*умммммммммммммммммммммммммммммм╦
*Ё Redisplay da Barra de RolagemЁ
*тмммммммммммммммммммммммммммммм╬
FUNCTION ScrollBarUpdate( aScrollBar, nCurrent, nTotal, lForceUpdate )
   LOCAL cOldColor
   LOCAL nNewPosition
   LOCAL nScrollHeight := ( aScrollBar[TB_ROWBOTTOM] - 1 ) - ;
                          ( aScrollBar[TB_ROWTOP] )

   IF nTotal < 1
      nTotal := 1
   ENDIF

   IF nCurrent < 1
      nCurrent := 1
   ENDIF

   IF nCurrent > nTotal
      nCurrent := nTotal
   ENDIF

   IF lForceUpdate == NIL
      lForceUpdate := if(nCurrent==1,.T.,.F.)
   ENDIF

   cOldColor := SETCOLOR( aScrollBar[ TB_COLOR ] )

   // Determine the new position
   nNewPosition := ROUND( (nCurrent / nTotal) * nScrollHeight, 0 )

   // Resolve algorythm oversights
   nNewPosition := IF( nNewPosition < 1, 1, nNewPosition )
   nNewPosition := IF( nCurrent == 1, 1, nNewPosition )
   nNewPosition := IF( nCurrent >= nTotal, nScrollHeight, nNewPosition )

   // Overwrite the old position (if different), then draw in the new one
   IF nNewPosition <> aScrollBar[ TB_POSITION ] .OR. lForceUpdate
      @ (aScrollBar[ TB_POSITION ] + aScrollBar[ TB_ROWTOP ]), ;
         aScrollBar[ TB_COLTOP ] SAY TB_BACKGROUND
      @ (nNewPosition + aScrollBar[ TB_ROWTOP ]), aScrollBar[ TB_COLTOP ] SAY ;
        TB_HIGHLIGHT
      aScrollBar[ TB_POSITION ] := nNewPosition
   ENDIF
   SETCOLOR( cOldColor )
   RETURN ( aScrollBar )
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     DISPLAY DA TECLA F? DE FUNCOES                        Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION TeclaServ(pDisp,pTexto,pTecla)
   CorAntes := SETCOLOR()
   SETCOLOR(YCORMENU)

   IF pDisp <> NIL
      @ 23,64 SAY "<  > - "+pTexto
      SETCOLOR(YCORTECLAS)
      @ 23,65 SAY pTecla
   ELSE
      @ 23,64 SAY SPACE(15)
   ENDIF
   SETCOLOR(CorAntes)
   RETURN .T.
*зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
*Ё                     PESQUISA DE CHAVE DE INDICE                           Ё
*юддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
FUNCTION Pesquisa2(area,ordem,chave,msg1,msg2)
   LOCAL nAreaAntes:=SELECT();nOrdemAntes:=INDEXORD()

   IF VALTYPE(area) # "U"
      SELECT(area)
   ENDIF
   IF VALTYPE(ordem) # "U"
      SET ORDER TO ordem
   ELSE
      SET ORDER TO 0
   ENDIF

   IF DBSEEK(ALLTRIM(chave))
      IF msg2#NIL; Aviso(msg2,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.T.)
   ELSE
      IF msg1#NIL; Aviso(msg1,,3); ENDIF
      SELECT(nAreaAntes);DBSETORDER(nOrdemAntes)
      RETURN(.F.)
   ENDIF

