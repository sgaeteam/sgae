*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : RC_263                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Ficha Financeira                         ณ
*ณ PROGRAMADOR    : VITOR SMITH FREIRE                       ณ
*ณ DATA CRIACAO   : 26/06/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBCLI","CLIENTE")        /* Cadastro de Clientes */
   SET INDEX TO DBICLI1,DBICLI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBREC","RECEBER")       /* Arquivo de Contas a Receber */
   SET INDEX TO DBIREC1,DBIREC2,DBIREC3,DBIREC4,DBIREC5
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBSETORDER(2)

cPrg:="RC263"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "63"

LimpaLinhaMsg(24)
Linha23("Comandos:  ^I^-Imprime Lista   ^P^-Pesquisa",23)
SET KEY -1 TO Mostra()
BrowFat(); Mensagem()
RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse das Faturas             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowFat()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   PRIVATE cCodCli:=SPACE(4)
   DBSETORDER(2)
   DBGOTOP()
   IF EOF()
      Aviso("Nenhuma Fatura cadastrada! Tecle algo..."); RETURN NIL
   ENDIF

   zchave:=CTOD('')
   Area_Dados(); SETCOLOR(YCOREDIT)
   Telas(4,3,20,75,1,YCOREDIT,.T.,"ด Faturas a Receber/Pagas ร")
   oBr:=TBROWSEDB(5,4,19,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oBr:gotopblock    := {|| GotoTop(zchave:=CTOD(''))}
   oBr:gobottomblock := {|| GotoBott(zchave:=CTOD('31/12/99'))}
*   oBr:skipblock     := {|n| MovePointer(n, zchave,{|| DTAREC},cCodCli,{|| COD_CF})}

   oBr:cargo:=0
   oCol:=TBCOLUMNNEW("Fatura Nง"     ,{|| NDOC })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cliente"       ,{|| COD_CF+' '+PegaCliente(COD_CF) })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Emissฦo"       ,{|| DTEMISS })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Vencimento"    ,{|| DTAREC })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor Liquido" ,{|| TRANSFORM(VLR_AREC,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Data Pagamento",{|| DTREC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor Pago"    ,{|| TRANSFORM(VLR_REC,"@E 999,999,999.99")})
   oBr:addColumn(oCol)

   oBr:Freeze:=1
   WHILE .T.
      WHILE !(oBr:stabilize());ENDDO
      tecla := INKEY(0)
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
         LimpaLinhaMsg(24)
         Linha23("Comandos:  ^I^-Imprime Lista   ^P^-Pesquisa",23)
      ELSEIF (tecla == 73 .OR. tecla == 105)  /* Imprimir Lista */
         SET KEY -1 TO Mostra()
         wPerIni:=wPerFim:=CTOD(""); wCod_cf:=SPACE(4); wOp1:=wOp2:=" "

         Telas(15,3,21,37,1,YCOREDIT,.T.); SETCOLOR(YCOREDIT)
         Mensagem("Informe Cliente <ENTER> para todos, e o Perกodo")
         @ 20,24 SAY "a"
         @ 18,03 SAY "ร"+REPL("ฤ",33)+"ด"
         @ 16,05 SAY "(   )  Recebidos"
         @ 17,05 SAY "(   )  a Receber"
         @ 16,07 GET wOp1 PICT "!" WHEN EMPTY(wOp2) VALID wOp1 $ "X "
         @ 17,07 GET wOp2 PICT "!" WHEN EMPTY(wOp1) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X"
         @ 19,05 SAY "Cliente:" GET wCod_cf PICT "9999" WHEN TeclaFuncao(.T.);
           VALID IF(EMPTY(wCod_cf),.T.,Pesquisa(3,1,wCod_cf,"Cliente Nฦo Localizado"))
         @ 20,05 SAY "Perกodo:" GET wPerIni PICT "@D"   WHEN TeclaFuncao() VALID (LASTKEY()==K_UP).OR.!EMPTY(wPerIni)
         @ 20,26                GET wPerFim PICT "@D"   VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni
         SETCURSOR(1); READ; SETCURSOR(0)

         TeclaFuncao(); Rest_Tela()
         IF LASTKEY()<>K_ESC
            IF ChkImpr()
               IF ImpFicha()
                  TiraMsgImp(cAviso)
                  WaitMsg("Fim de Impressฦo, tecle algo...")
               ENDIF
            ENDIF
         ENDIF
         SELECT RECEBER
         DBSETORDER(1); DBGOTOP()
         SETKEY(K_F2,NIL)
         LimpaLinhaMsg(24)
         Linha23("Comandos:  ^I^-Imprime Lista   ^P^-Pesquisa",23)
      ELSEIF (tecla == 80 .OR. tecla == 112 )   /* Procura por codigo de cliente ou por data de vencimento */
         nRecno:=Pesq_Fatura()
*        obr:gotop()
*        oBr:refreshall()
         WHILE !(oBr:stabilize());ENDDO
         RECEBER->(DBGOTO(nrecno))
*        RECEBER->(DBSETORDER(2))
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
*     oBr:refreshall()
  ENDDO
  SETCOLOR(corant)
  Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออออธ
*ณ Posiciona no Inicio da Condicao ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoTop(searcher)
   DBSEEK(DTOS(searcher),.T.)
   RETURN NIL
*ีอออออออออออออออออออออออออออออออออธ
*ณ Posiciona no Final da Condicao  ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoBott(searcher)
  DBSEEK(DTOS(searcher),.T.)
  /*
   IF !EOF()
      SKIP
   ELSE
      SKIP -1
   ENDIF
  */
   RETURN NIL
*ีออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ Move para o registro que satisfaz a Condicao ณ
*ิออออออออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION MovePointer(pSaltos,pDadoPesq,pChavePesq,pCampPesq,pCodPesq)
   LOCAL num_skipped := 0,norder

   norder:=RECEBER->(INDEXORD())
   IF norder=5      /* Ordem de data do pagamento+data do vencimento  */
      zsearcher := pDadoPesq
      d_key_cb  := pChavePesq
   ELSEIF norder=2  /* Ordem de data do pagamento */
      zsearcher := pDadoPesq
      d_key_cb  := pChavePesq
   ELSEIF norder=4  /* Ordem de codigo do cliente + data do pagamento */
      zsearcher := pCampPesq
      d_key_cb  := pCodPesq
   ENDIF

   IF EOF()
   ELSEIF pSaltos = 0
      SKIP 0
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. num_skipped != pSaltos;
                   .AND. IF(norder=1,.T.,EVAL(d_key_cb) = zsearcher)
         IF pSaltos > 0
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
      ELSEIF norder=2  .AND. EVAL(d_key_cb) # zsearcher
         IF pSaltos > 0
            SKIP -1
            num_skipped--
         ELSE
            SKIP
            num_skipped++
         ENDIF
      ENDIF
   ENDIF
   RETURN num_skipped
*ีออออออออออออออออออออออออธ
*ณ Pesquisar Fatura       ณ
*ิออออออออออออออออออออออออพ
STATIC FUNCTION Pesq_Fatura()
   LOCAL cnf:=SPACE(6),cord:=1,ctipo:=SPACE(1),nrec:=RECNO(),nOrderAnt:=INDEXORD()

   GETLIST:={}
   ccodcli:=SPACE(4); ddat_vencto:=CTOD('')
   Telas(19,2,21,50,c_nBorda,YCOREDIT,.T.)
   @ 20,04 SAY "Pesquisa por: (C)liente (D)ata (F)atura" GET ctipo PICT '!' VALID ctipo$'DCF'
   SETCURSOR(1);READ;SETCURSOR(0)

   Rest_Tela()
   IF LASTKEY()=K_ESC; RETURN(RECEBER->(RECNO())); ENDIF

   IF ctipo='C'
*     SELECT CLIENTE; DBSETORDER(2)           /* Nome */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY "Cliente:" GET cCodCli PICT '9999' WHEN TeclaFuncao(.T.);
        VALID !EMPTY(cCodCli).AND.Pesquisa(3,1,cCodCli,"Cliente Nฦo Cadastrado")
      SETCURSOR(1); READ; SETCURSOR(0)

      TeclaFuncao()
      IF LASTKEY()==K_ESC
         SELECT CLIENTE; DBSETORDER(1)
         SELECT RECEBER; DBSETORDER(nOrderAnt)
         Rest_Tela()
         RETURN RECEBER->(RECNO())
      ENDIF
      cCodCli:=STRZERO(VAL(cCodCli),4)

      SELECT RECEBER; DBSETORDER(4)               /* Cod.Cliente + Dt.Pgto */
      IF !DBSEEK(ccodcli)
         Aviso("Nฦo h  Duplicatas para este Cliente")
         RECEBER->(DBGOTO(nrec))
         RECEBER->(DBSETORDER(2))
      ENDIF
      CLIENTE->(DBSETORDER(1))
   ELSEIF ctipo='D'
      RECEBER->(DBSETORDER(5))                    /* Dt.Pgto + Dt.Vcto */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY 'Data:' GET ddat_vencto PICT '@D'
      SETCURSOR(1);READ;SETCURSOR(0)

      IF LASTKEY()==K_ESC; DBSETORDER(nOrderAnt); Rest_Tela(); RETURN(RECEBER->(RECNO())); ENDIF
      IF !EMPTY(ddat_vencto).AND.!RECEBER->(DBSEEK(DTOS(ddat_vencto)))
         Aviso("Nenhuma Fatura para esta Data")
         RECEBER->(DBGOTO(nrec))
      ENDIF
   ELSE
      RECEBER->(DBSETORDER(3))                    /* No. Fatura */
      Telas(19,2,21,19,c_nBorda,YCOREDIT,.T.)
      @ 20,04 SAY 'Fatura:' GET cnf PICT '999999' VALID !EMPTY(cnf)
      SETCURSOR(1);READ;SETCURSOR(0)

      IF LASTKEY()==K_ESC; DBSETORDER(nOrderAnt); Rest_Tela(); RETURN(RECEBER->(RECNO())); ENDIF
      cnf:=STRZERO(VAL(cnf),6)
      IF !RECEBER->(DBSEEK(cnf))
         Aviso("Fatura nฦo Cadastrada")
         RECEBER->(DBSETORDER(1))
         RECEBER->(DBGOTO(nrec))
      ENDIF
      RECEBER->(DBSETORDER(1))
   ENDIF
   Rest_Tela()
   RETURN RECEBER->(RECNO())
*ีออออออออออออออออออออออออออออธ
*ณ Imprimir Ficha Financeira  ณ
*ิออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpFicha()
   LOCAL lCabec:=.T., lEntrou:=.F.
   LOCAL nTotLiq:=nTotPag:=0.00
   continua:=.T.; pg:=0

   IF !EMPTY(wCod_cf)
      DBSETORDER(4)
      lAchou:= DBSEEK(wCod_cf)
      xCond := "continua.AND.COD_CF==wCod_cf.AND.DTAREC<=wPerFim"
   ELSE
      DBSETORDER(5)
      lAchou:=DBSEEK(DTOS(CTOD(''))+DTOS(wPerIni),.T.)
      xCond := "continua.AND.DTAREC<=wPerFim"

      IF DTVCTO>wPerFim
         Aviso("Nฦo h  Faturas neste perกodo..."); RETURN .F.
      ELSE
         IF lAchou; cAviso := MsgImp(); ENDIF
      ENDIF
   ENDIF

   SET DEVICE TO PRINT; SETPRC(0,0)
   WHILE &xCond..AND.!EOF()
      IF !EMPTY(wOp1)
         IF DTREC==CTOD("")
            DBSKIP(); LOOP
         ENDIF
      ELSEIF !EMPTY(wOp2)
         IF DTREC#CTOD("")
            DBSKIP(); LOOP
         ENDIF
      ENDIF

      lEntrou:=.T.
      IF lCabec; CabRel263(); lCabec:=.F.; ENDIF
      lAchou:=.T.
      Cab_ESC(01,002,NDOC,"[999999]")
      IF EMPTY(wCodCli)
         Cab_ESC(00,009,PegaCliente(COD_CF),"[@!S30]")
         Cab_ESC(00,040,DTEMISS,"[@D]")
         Cab_ESC(00,050,DTAREC,"[@D]")
         Cab_ESC(00,060,DTREC,"[@D]")
         Cab_ESC(00,069,VLR_AREC,"[@E 999,999,999.99]")
         Cab_ESC(00,085,CONTA,"[@R 999-!!!!!!!-!!!!!!!!!!!!!]")
         Cab_ESC(00,114,VLR_REC,"[@E 999,999,999.99]")
      ELSE
         Cab_ESC(00,010,DTEMISS,"[@D]")
         Cab_ESC(00,020,DTAREC,"[@D]")
         Cab_ESC(00,030,DTREC,"[@D]")
         Cab_ESC(00,039,VLR_AREC,"[@E 999,999,999.99]")
         Cab_ESC(00,055,CONTA,"[@R 999-!!!!!!!-!!!!!!!!!!!!!]")
         Cab_ESC(00,084,VLR_REC,"[@E 999,999,999.99]")
      ENDIF
      nTotLiq += VLR_AREC
      nTotPag += VALORPAGO
      DBSKIP()
      IF PROW()>57 .AND. !EOF()
         EJECT; lCabec:=.T.
      ENDIF
   ENDDO
   IF continua.AND.lEntrou
      Cab_ESC(01,002,REPL("=",130))
      Cab_ESC(01,002,"T O T A L  ------->")
      IF EMPTY(wCodCli)
         Cab_ESC(00,069,nTotLiq,"[@E 999,999,999.99]")
         Cab_ESC(00,114,nTotPag,"[@E 999,999,999.99]")
      ELSE
         Cab_ESC(00,039,nTotLiq,"[@E 999,999,999.99]")
         Cab_ESC(00,084,nTotPag,"[@E 999,999,999.99]")
      ENDIF
      @ 62,00 SAY "* * * Final de Relatorio * * *"; EJECT
   ENDIF
   Compr_Off()
   SET DEVICE TO SCREEN
   RETURN lAchou
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel263()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY cDtSys
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "RELATORIO DE FICHA FINANCEIRA"
   @ PROW()  ,002 SAY "RELATORIO DE FICHA FINANCEIRA"
   @ PROW()  ,050 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   IF !EMPTY(wCod_cf)
      @ PROW()+2,002 SAY "Cliente: "+CLIENTE->NOME
   ENDIF
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("-",130)
   IF !EMPTY(wCod_cf)
      @ PROW()+1,02 SAY "FATURA  EMISSAO     VCTO.    PAGTO.   VALOR LIQUIDO  BCO/AGENCIA/CONTA                VALOR PAGO"
*                        999999  99/99/99  99/99/99  99/99/99 999,999,999.99  999/!!!!!!!/!!!!!!!!!!!!!    999,999,999.99
*                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                                1         2         3         4         5         6         7         8         9        10        11        12        13
   ELSE
      @ PROW()+1,02 SAY "FATURA CLIENTE                        EMISSAO     VCTO.    PAGTO.   VALOR LIQUIDO  BCO/AGENCIA/CONTA                VALOR PAGO"
*                        999999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 99/99/99  99/99/99  99/99/99 999,999,999.99  999/!!!!!!!/!!!!!!!!!!!!!    999,999,999.99
*                      01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                                1         2         3         4         5         6         7         8         9        10        11        12        13
   ENDIF
   @ PROW()+1,002 SAY REPLICATE("-",130)
   RETURN
