*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_260                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Baixa de Faturas a Receber               ณ
*ณ PROGRAMADOR    : VITOR SMITH FREIRE                       ณ
*ณ DATA CRIACAO   : 21/06/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 4
IF NetUse("DBBANCO","BANCO")        /* Cadastro de Bancos */
   SET INDEX TO DBIBCO1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBITEM","ITEM")          /* Cadastro de Itens de Fluxo de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBCLI","CLIENTE")        /* Cadastro de Clientes */
   SET INDEX TO DBICLI1,DBICLI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBREC","RECEBER")       /* Arquivo de Contas a Receber */
   SET INDEX TO DBIREC5,DBIREC1,DBIREC3,DBIREC4,DBIREC2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE260"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "60"

LimpaLinhaMsg(24)
Linha23("Comandos: ^I^-Imprime Lista  ^B^-Baixa Fatura  ^P^-Pesquisa",23)
BrowFat(); Mensagem()
RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse das Faturas a Receber   ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowFat()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   PRIVATE cCod_cf:=SPACE(4)
   SETCOLOR(YCOREDIT)

   zchave:=CTOD('01/01/80')
   DBSEEK(DTOS(CTOD('')))
   IF EOF()
      Aviso('Nenhuma Fatura Pendente'); RETURN
   ENDIF
   Area_Dados()
   Telas(4,3,20,75,1,YCOREDIT,.T.,"ด Baixa de Faturas - Contas a Receber ร")
   oBr:=TBROWSEDB(5,4,19,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oBr:gotopblock   := {|| GotoTop(zchave)}
   oBr:gobottomblock:= {|| GotoBott(zchave)}
   oBr:skipblock    := {|n| MovePointer(n, zchave,{|| DTREC},cCod_cf+DTOS(CTOD('')),{|| COD_CF+DTOS(DTREC)})}

   oCol1:=TBCOLUMNNEW("Fatura Nง"    ,{|| NDOC })
   oCol2:=TBCOLUMNNEW("Cliente"      ,{|| COD_CF+' '+PegaCliente(COD_CF)})
*  oCol3:=TBCOLUMNNEW("Conta"        ,{|| TRANSFORM(CONTA,"@R !!!-!!!!!!!-!!!!!!!!!!!!!!!"})
   oCol3:=TBCOLUMNNEW("Item"         ,{|| ITEM_CX })
   oCol4:=TBCOLUMNNEW("Vencimento"   ,{|| DTAREC })
   oCol5:=TBCOLUMNNEW("Valor Liquido",{|| TRANSFORM(VLR_AREC,"@E 999,999,999.99")})
   oCol6:=TBCOLUMNNEW("Observa”es"  ,{|| TRANSFORM(OBS,"@!")})
   oBr:addColumn(oCol1)
   oBr:addColumn(oCol2)
   oBr:addColumn(oCol3)
   oBr:addColumn(oCol4)
   oBr:addColumn(oCol5)
   oBr:addColumn(oCol6)
   oBr:Freeze:=1
   WHILE .T.
      WHILE !oBr:stabilize(); ENDDO
      tecla := INKEY(0)
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
         LimpaLinhaMsg(24)
         Linha23("Comandos: ^I^-Imprime Lista  ^B^-Baixa Fatura  ^P^-Pesquisa",23)
      ELSEIF (tecla == 73 .OR. tecla == 105)   /* Imprimir Lista */
         IF ChkImpr()
            IF ImpFatRec()
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impressฦo, tecle algo...")
               LimpaLinhaMsg(24)
               Linha23("Comandos: ^I^-Imprime Lista  ^B^-Baixa Fatura  ^P^-Pesquisa",23)
            ENDIF
            DBSEEK(DTOS(CTOD("")))
         ENDIF
      ELSEIF (tecla == 66 .OR. tecla == 98)    /* Efetua a Baixa da Fatura */
         nValorPago := RECEBER->VLR_AREC
         dDtPgto    := RECEBER->DTAREC
         wNFat      := RECEBER->NDOC
         wCod_cf    := RECEBER->COD_CF
         wConta     := RECEBER->CONTA
         wItem_cx   := RECEBER->ITEM_CX

         GetList:={}
         SETCOLOR(YCORMENU)
         Telas(13,10,20,68,1,YCORMENU,.T.,"ด Baixa de Fatura ร")
         TDescr(2,1,15,28,wCod_cf,"NOME",["@S37"],,YCORMENU)
         TDescr(3,1,19,28,wItem_cx,"DESCR",["@S37"],,YCORMENU)
         WHILE .T.
            CLIENTE->(DBSEEK(RECEBER->COD_CF))
            @ 14,11 SAY "Nota Fiscal:" GET wNFat      PICT "999999" VALID !EMPTY(wNFat).AND.TFat(wNFat)
            @ 15,11 SAY "    Cliente:" GET wCod_cf    PICT "9999"   WHEN .F.
            @ 16,11 SAY "Data Pagto.:" GET dDtPgto    PICT "@D"     VALID LASTKEY()==K_UP.OR.Chk_Pgto()
            @ 17,11 SAY " Valor Pago:" GET nValorPago PICT "@E 9,999,999,999.99" VALID LASTKEY()==K_UP.OR.Chk_Valor()
            @ 18,11 SAY "   Conta Nง:" GET wConta     PICT "@R !!!-!!!!!!!-!!!!!!!!!!!!!!!" WHEN .F.
            @ 19,11 SAY "       Item:" GET wItem_cx   PICT "@!"     WHEN .F.
            SETCURSOR(1);READ;SETCURSOR(0)

            IF LASTKEY()=K_ESC; EXIT; ENDIF
            IF Confirma("Confirma Pagamento ?")
               IF NetlReg()
                  REPLACE DTREC   WITH dDtPgto,;
                          VLR_REC WITH nValorPago
                  UNLOCK; DBCOMMIT()
               ENDIF
               SCROLL(15,28,15,65)
               SCROLL(19,28,19,65)
               nValorPago := 0.00
               dDtPgto    := CTOD("")
               wNFat      := STRZERO(VAL(wNFat)+1,6)
               wCod_cf    := SPACE(4)
               wConta     := SPACE(23)
               wItem_cx   := SPACE(4)
            ENDIF
         ENDDO
         Rest_Tela(); SETCOLOR(YCOREDIT)
         RECEBER->(DBSETORDER(1))
         DBSEEK(DTOS(CTOD("")))
         oBr:configure()
         oBr:refreshall(); LOOP
      ELSEIF (tecla == 80 .OR. tecla == 112 )  /* Procura por codigo do cliente ou por data de vencimento */
         Pesq_Fatura()
         nRecno:=RECEBER->(RECNO())
         oBr:gotop()
         DBGOTO(nRecno)
         oBr:refreshall()
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
      oBr:refreshCurrent()
  ENDDO
  SETCOLOR(corant)
  Rest_Tela()
  RETURN NIL
*ีออออออออออออออออออออออออออธ
*ณ Checar Data do Pagamento ณ
*ิออออออออออออออออออออออออออพ
STATIC FUNCTION Chk_Pgto()
   LOCAL linha_ant:=SAVESCREEN(23,00,23,79)

   IF EMPTY(dDtPgto); RETURN .F.; ENDIF
   IF dDtPgto>DTAREC
      Aviso("Data do Pagamento maior que a Data do Vencimento",,3)
   ENDIF
   RESTSCREEN(23,00,23,79,linha_ant)
   RETURN .T.
*ีอออออออออออออออออออออออออธ
*ณ Checar Valor sendo Pago ณ
*ิอออออออออออออออออออออออออพ
STATIC FUNCTION Chk_Valor()
   LOCAL linha_ant:=SAVESCREEN(23,00,23,79)

   IF EMPTY(nvalorpago)
      RETURN .F.
   ENDIF
   IF VAL(STR(nvalorpago,13,2)) > VAL(STR(VLR_AREC,13,2))
      Aviso("Valor MAIOR que a Fatura",,3); RETURN .F.
   ELSEIF nvalorpago < VAL(STR(VLR_AREC,13,2))
      Aviso("Valor MENOR que a Fatura",,3); RETURN .F.
   ENDIF
   RESTSCREEN(23,00,23,79,linha_ant)
   RETURN .T.
*ีอออออออออออออออออออออออออออออออออออออออออธ
*ณ Pesquisar Fatura Numero,Nome do Cliente ณ
*ิอออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION Pesq_Fatura()
   LOCAL cnf:=SPACE(6),cord:=1,ctipo:=SPACE(1),nrec:=RECNO(), nOrderAnt:=INDEXORD()

   GetList:={}
   cCod_cf:=SPACE(4); dDat_Vencto:=CTOD('')

   Telas(19,2,21,50,c_nBorda,YCOREDIT,.T.)
   @ 20,04 SAY "Pesquisa por: (C)liente (D)ata (F)atura" GET ctipo PICT "!" VALID ctipo$'DCF'
   SETCURSOR(1); READ; SETCURSOR(0)

   Rest_Tela()
   IF LASTKEY()==K_ESC; RETURN RECEBER->(RECNO()); ENDIF

   IF ctipo="C"
      SELECT CLIENTE; DBSETORDER(2)             /* Nome */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY "Cliente:" GET cCod_cf PICT '@!' VALID !EMPTY(cCod_cf)
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()==K_ESC
         SELECT CLIENTE; DBSETORDER(1)
         SELECT RECEBER;  DBSETORDER(nOrderAnt)
         Rest_Tela()
         RETURN RECEBER->(RECNO())
      ENDIF
      cCod_cf:=STRZERO(VAL(cCod_cf),4)

      SELECT RECEBER; DBSETORDER(2)             /* Cod.Cliente + Dt.Pgto */
      IF !DBSEEK(cCod_cf)
         Aviso("Nฦo h  Fatura(s) contra este Cliente")
         RECEBER->(DBGOTO(nrec))
         RECEBER->(DBSETORDER(1))
      ENDIF
      IF !EMPTY(RECEBER->DTREC) .AND. RECEBER->(FOUND())
         Aviso("Nฦo h  Duplicatas para este Cliente")
         RECEBER->(DBGOTO(nrec))
         RECEBER->(DBSETORDER(1))
      ENDIF
      CLIENTE->(DBSETORDER(1))
   ELSEIF ctipo='D'
      RECEBER->(DBSETORDER(1))                   /* Dt.Pgto + Dt.Vcto */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY 'Data:' GET ddat_vencto PICT '@D'
      SETCURSOR(1);READ;SETCURSOR(0)

      IF LASTKEY()==K_ESC;DBSETORDER(nOrderAnt); Rest_Tela(); RETURN RECEBER->(RECNO()); ENDIF
      IF !EMPTY(ddat_vencto).AND.!RECEBER->(DBSEEK(DTOS(CTOD(''))+DTOS(ddat_vencto)))
         Aviso("Nenhuma Fatura para esta Data")
         RECEBER->(DBGOTO(nrec))
      ENDIF
   ELSE
      RECEBER->(DBSETORDER(3))                    /* No. Fatura */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY 'Fatura:' GET cnf PICT '999999' VALID !EMPTY(cnf)
      SETCURSOR(1);READ;SETCURSOR(0)

      IF LASTKEY()==K_ESC; DBSETORDER(nOrderAnt); Rest_Tela(); RETURN RECEBER->(RECNO()); ENDIF

      cnf:=STRZERO(VAL(cnf),6)
      IF !RECEBER->(DBSEEK(cnf))
         Aviso("Fatura nฦo Cadastrada")
         RECEBER->(DBSETORDER(1))
         RECEBER->(DBGOTO(nrec))
      ELSEIF !EMPTY(RECEBER->DTREC) .AND. RECEBER->(FOUND())
         Aviso("Esta Fatura j  foi Paga")
         RECEBER->(DBSETORDER(1))
         RECEBER->(DBGOTO(nrec))
      ENDIF
      RECEBER->(DBSETORDER(1))
   ENDIF
   Rest_Tela()
   RETURN RECEBER->(RECNO())
*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ Checar se ponteiro atingiu o primeiro registro que satisfaz ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoTop(searcher)
   DBSEEK(DTOS(CTOD('')))
   RETURN NIL
*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ Checar se ponteiro atingiu o ultimo registro que satisfaz ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoBott(searcher)
   DBSEEK(DTOS(searcher),.T.)
   RETURN NIL
*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ Fazer movimentacao dos registros continuar satisfazendo   ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION MovePointer(num_to_skip,pesq_data,chave_data,pesq_cod,chave_cod)
   LOCAL num_skipped := 0,norder
   norder:=RECEBER->(INDEXORD())
   IF norder=1  && Ordem de data do pagamento+data do vencimento
      zsearcher:=pesq_data
      d_key_cb:=chave_data
   ELSEIF norder=2  && Ordem de codigo do cliente + data do pagamento
      zsearcher:=pesq_cod
      d_key_cb:=chave_cod
   ENDIF

   IF eof()
   ELSEIF num_to_skip = 0
      SKIP 0
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. num_skipped != num_to_skip ;
                   .AND. IF(norder=1,EVAL(d_key_cb) < zsearcher,EVAL(d_key_cb) = zsearcher)
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
      ELSEIF IF(norder=1,EVAL(d_key_cb) >= zsearcher,EVAL(d_key_cb) # zsearcher)
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
*ีออออออออออออออออออออออออออออออออออธ
*ณ Imprimir Faturas Baixadas no Dia ณ
*ิออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpFatRec()
   LOCAL lCabec:=.T.
   continua:=.T.; pg:=0

   IF !(lAchou:=DBSEEK(DTOS(cDtSys)))
      Aviso("Nฦo houve Faturas Baixadas hoje...",,3)
   ELSE
      cAviso := MsgImp()
   ENDIF
   SET DEVICE TO PRINT; SETPRC(0,0)
   WHILE continua.AND.!EOF()
      IF lCabec; CabRel260(); lCabec:=.F.; ENDIF
      IF DTREC==cDtSys
         Cab_ESC(01,002,NDOC,"[999999]")
         Cab_ESC(00,010,PegaCliente(COD_CF),"[@!S40]")
         Cab_ESC(00,051,DTAREC,"[@D]")
         Cab_ESC(00,063,DTREC,"[@D]")
         Cab_ESC(00,074,VLR_REC,"[@E 999,999,999.99]")
         Cab_ESC(00,090,LEFT(CONTA,3))
         Cab_ESC(00,097,SUBS(CONTA,4,7))
         Cab_ESC(00,106,RIGHT(CONTA,13))
      ENDIF
      DBSKIP()
      IF PROW()>57 .AND. !EOF()
         EJECT; lCabec:=.T.
      ENDIF
   ENDDO
   IF continua.AND.lAchou
      Cab_ESC(01,002,REPL("=",120))
      @ 62,00 SAY "* * * Final de Relatorio * * *"; EJECT
   ENDIF
   Compr_Off()
   SET DEVICE TO SCREEN
   RETURN lAchou
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel260()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY cDtSys
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE FATURAS BAIXADAS EM "+DTOC(cDtSys)
   @ PROW()  ,002 SAY "LISTA DE FATURAS BAIXADAS EM "+DTOC(cDtSys)
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("-",120)
   @ PROW()+1,02 SAY "Fatura  Cliente                                  Vencimento  Pagamento  Valor Recebido  Banco  Agencia  Conta"
   @ PROW()  ,02 SAY "Fatura  Cliente                                  Vencimento  Pagamento  Valor Recebido  Banco  Agencia  Conta"
*                     999999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/99    99/99/99   999,999,999.99  999    999999   9999999999999
*                   0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                             1         2         3         4         5         6         7         8         9        10        11        12
   @ PROW()+1,002 SAY REPLICATE("-",120)
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Fatura    ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TFat(pFat)
   LOCAL lRet
   RECEBER->(DBSETORDER(3))
   IF (lRet:=RECEBER->(DBSEEK(pFat)))
      nValorPago := RECEBER->VLR_AREC
      dDtPgto    := RECEBER->DTAREC
      wCod_cf    := RECEBER->COD_CF
      wConta     := RECEBER->CONTA
      wItem_cx   := RECEBER->ITEM_CX
      TDescr(2,1,15,28,wCod_cf,"NOME",["@S37"],,YCORMENU)
      TDescr(3,1,19,28,wItem_cx,"DESCR",["@S37"],,YCORMENU)
      @ 15,24 SAY wCod_cf    PICT "9999"                COLOR YCORMENU
      @ 16,24 SAY dDtPgto    PICT "@D"                  COLOR YCORMENU
      @ 17,24 SAY nValorPago PICT "@E 9,999,999,999.99" COLOR YCORMENU
      @ 18,24 SAY wConta     PICT "@R !!!-!!!!!!!-!!!!!!!!!!!!!!!" COLOR YCORMENU
      @ 19,24 SAY wItem_cx   PICT "9999"                COLOR YCORMENU
      IF DTREC#CTOD("")
         Aviso("Fatura j  Baixada...",,3); lRet:=.F.
      ENDIF
   ELSE
      Aviso("Fatura nฦo Localizada...",,3)
   ENDIF
   RETURN(lRet)
