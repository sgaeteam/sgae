*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_257                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Ficha Financeira (Devedores) Ctas.Receb. ณ
*ณ PROGRAMADOR    : VITOR SMITH FREIRE                       ณ
*ณ DATA CRIACAO   : 22/07/1998                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()

// Gerar Arquivo Temporario
aDbf:={}
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"RAZAO"   ,"C", 50,0})
AADD(aDbf,{"NDOC"    ,"C", 06,0})
AADD(aDbf,{"COD_CF"  ,"C", 04,0})
AADD(aDbf,{"DTEMISS" ,"D", 08,0})
AADD(aDbf,{"DTAPAG"  ,"D", 08,0})
AADD(aDbf,{"VLR_APAG","N", 12,2})
AADD(aDbf,{"OBS"     ,"C", 50,0})
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON DTOS(DTAPAG) TO (cArq1)

SELECT 2
IF Netuse("DBFORN","FORNECEDOR")      /* Fornecedores */
   SET INDEX TO DBIFOR1,DBIFOR2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAGA","PAGAR")           /* Contas a Pagar */
   SET INDEX TO DBIPG5,DBIPG3,DBIPG1,DBIPG4,DBIPG2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE257"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "57"

LimpaLinhaMsg(24)
SET KEY -1 TO Mostra()
wPerIni:=wPerFim:=CTOD(""); wCod_cf:=SPACE(4); wOp1:=wOp2:=" "

WHILE .T.
   Telas(15,3,21,38,1,YCOREDIT,.T.); SETCOLOR(YCOREDIT)
   Mensagem("Informe Fornecedor e o Perกodo")
   @ 20,25 SAY "a"
   @ 18,03 SAY "ร"+REPL("ฤ",34)+"ด"
   @ 16,05 SAY "(   )  Pagos  "
   @ 17,05 SAY "(   )  a Pagar"
   @ 16,07 GET wOp1 PICT "!" WHEN EMPTY(wOp2) VALID wOp1 $ "X "
   @ 17,07 GET wOp2 PICT "!" WHEN EMPTY(wOp1) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X"
   @ 19,05 SAY "Fornecedor:" GET wCod_cf PICT "9999" WHEN TeclaFuncao(.T.);
     VALID EMPTY(wCod_cf).OR.Pesquisa(2,1,wCod_cf,"Fornecedor Nฦo Localizado")
   @ 20,05 SAY "Perกodo:" GET wPerIni PICT "@D"  VALID !EMPTY(wPerIni)
   @ 20,27                GET wPerFim PICT "@D"  VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni.OR.EMPTY(wPerFim)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Rest_Tela()
   IF LASTKEY()<>K_ESC
      Linha23("Comandos:  ^I^-Imprime ^ENTER^-Altera Informaฦo",23)
      wPerFim:=IF(EMPTY(wPerFim),cDtSys,wPerFim)
      /* Procurar dados informados */
      IF EMPTY(wPerIni)
         PAGAR->(DBSETORDER(4))
         IF !PAGAR->(DBSEEK(wCod_cf))
            IF EMPTY(wOp1)
               Aviso("Nฦo h  pagamentos feitos a este FORNECEDOR")
            ELSE
               Aviso("Nฦo h  nada a PAGAR para este FORNECEDOR")
            ENDIF
         ELSE
            WHILE PAGAR->COD_CF==wCod_cf.AND.!PAGAR->(EOF())
               IF !EMPTY(wOp1)
                  IF !EMPTY(PAGAR->DTPAG)
                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                             (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                             (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                             (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                             (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                             (cArq1)->OBS      WITH PAGAR->OBS
                  ENDIF
               ELSEIF !EMPTY(wOp2)
                  IF PAGAR->(DTPAG)==CTOD("")
                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                             (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                             (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                             (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                             (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                             (cArq1)->OBS      WITH PAGAR->OBS
                  ENDIF
               ENDIF
               PAGAR->(DBSKIP())
            ENDDO
         ENDIF
      ELSE
         IF !EMPTY(wOp1)
            PAGAR->(DBSETORDER(5))
            PAGAR->(DBSEEK(DTOS(wPerIni),.T.))
            IF PAGAR->DTPAG<=wPerFim
               WHILE PAGAR->DTPAG<=wPerFim.AND.!PAGAR->(EOF())
                  IF EMPTY(wCod_cf)
                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                             (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                             (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                             (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                             (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                             (cArq1)->OBS      WITH PAGAR->OBS
                  ELSE
                     IF PAGAR->COD_CF==wCod_cf
                        (cArq1)->(DBAPPEND())
                        REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                                (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                                (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                                (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                                (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                                (cArq1)->OBS      WITH PAGAR->OBS
                     ENDIF
                  ENDIF
                  PAGAR->(DBSKIP())
               ENDDO
            ELSE
               Aviso("Nฦo houve pagamento deste FORNECEDOR neste perกodo")
            ENDIF
         ELSEIF !EMPTY(wOp2)
            IF EMPTY(wCod_cf)
               PAGAR->(DBSETORDER(2))
               Aguarde("Procurando Registros...")
               SET SOFTSEEK ON
               PAGAR->(DBSEEK(DTOS(wPerIni),.T.))
               SET SOFTSEEK OFF
               WHILE PAGAR->DTAPAG>=wPerIni.AND.PAGAR->DTAPAG<=wPerFim.AND.!PAGAR->(EOF())
                 IF EMPTY(PAGAR->DTPAG)
                    (cArq1)->(DBAPPEND())
                    REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                            (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                            (cArq1)->RAZAO    WITH PegaForn(PAGAR->COD_CF) ,;
                            (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                            (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                            (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                            (cArq1)->OBS      WITH PAGAR->OBS
                 ENDIF
                 PAGAR->(DBSKIP())
               ENDDO
               Aguarde()
            ELSE
               PAGAR->(DBSETORDER(4))
               PAGAR->(DBSEEK(wCod_cf+DTOS(wPerIni),.T.))
               IF PAGAR->DTAPAG<=wPerFim
                  WHILE PAGAR->COD_CF==wCod_cf.AND.PAGAR->DTAPAG<=wPerFim.AND.!PAGAR->(EOF())
                    (cArq1)->(DBAPPEND())
                    REPLACE (cArq1)->NDOC     WITH PAGAR->NDOC   ,;
                            (cArq1)->COD_CF   WITH PAGAR->COD_CF ,;
                            (cArq1)->DTEMISS  WITH PAGAR->DTEMISS,;
                            (cArq1)->DTAPAG   WITH PAGAR->DTAPAG  ,;
                            (cArq1)->VLR_APAG WITH PAGAR->VLR_APAG,;
                            (cArq1)->OBS      WITH PAGAR->OBS
                    PAGAR->(DBSKIP())
                  ENDDO
               ELSE
                  Aviso("Nฦo h  pendncia de pagamento para este FORNECEDOR neste perกodo")
               ENDIF
            ENDIF
         ENDIF
      ENDIF

      SELECT (cArq1); DBGOTOP()
      Telas(2,0,5,79,1,YCOREDIT,.F.)
      @ 03,02 SAY "FORNECEDOR.: "+IF(EMPTY(wCod_cf),"TODOS",FORNECEDOR->RAZAO)
      @ 04,02 SAY "Perกodo....: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
      Telas(5,0,22,79,1,YCOREDIT,.F.,IF(!EMPTY(wOp1)," Pagos "," a Pagar "))
      oBr:=TBROWSEDB(6,1,21,78)
      oBr:headSep:="ฤยฤ"
      oBr:colSep:= " ณ "
      oBr:colorspec = YCOREDIT

      oCol:=TBCOLUMNNEW("NF"            ,{|| NDOC})
      oBr:addColumn(oCol)
      IF !EMPTY((cArq1)->RAZAO)
         oCol:=TBCOLUMNNEW("FORNECEDOR" ,{|| TRANSFORM(FORNECEDOR,"@S20")})
         oBr:addColumn(oCol)
      ENDIF
      oCol:=TBCOLUMNNEW(IF(EMPTY(wOp1),"Dt.Vcto.","Dt.Pgto."),{|| IF(EMPTY(wOp1),DTAPAG,DTPAG)})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW(IF(EMPTY(wOp1),"A Pagar","Pago"),{|| TRANSFORM(IF(EMPTY(wOp1),VLR_APAG,VLR_PAG),"@E 999,999,999.99")})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Emissฦo"    ,{|| DTEMISS})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Observaฦo" ,{|| OBS})
      oBr:addColumn(oCol)

      oBr:Freeze=2
      WHILE .T.
         WHILE NEXTKEY()=0 .AND. !(oBr:stabilize()); ENDDO
         tecla := INKEY()
         IF ( tecla == K_ESC )
            EXIT
         ELSEIF ( tecla == K_F1 )
            Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
         ELSEIF ( tecla == K_F4 )
            Calculadora(calc_lin,calc_col,YCORMENU)
         ELSEIF ( tecla == K_F5 )
            Calendary(@cale_lin,@cale_col,@m_date)
         ELSEIF ( tecla == 73 .OR. tecla == 105)
            IF ChkImpr()
               cAviso := MsgImp()
               ImpFicha()
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impressฦo, tecle algo...")
               Mensagem()
            ENDIF
         ELSEIF ( tecla == K_F2 )
            Ajuda()
         ELSE
            ProcKey(oBr,tecla)
         ENDIF
      ENDDO
      Rest_Tela(2)
   ELSE
      EXIT
   ENDIF
   (cArq1)->(__dbzap())
ENDDO
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออธ
*ณ Imprimir Ficha Financeira  ณ
*ิออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpFicha()
   LOCAL lCabec:=.T., lEntrou:=.F.
   LOCAL nTotLiq:=nTotPag:=nTotCor:=0.00
   continua:=.T.; pg:=0

   DBGOTOP()
   SET DEVICE TO PRINT; SETPRC(0,0)
   WHILE !EOF()
      lEntrou:=.T.
      IF lCabec; CabRel263(); lCabec:=.F.; ENDIF
      lAchou:=.T.
      Cab_ESC(1,02,NDOC,"[999999]")
      IF EMPTY(wCod_cf)
         Cab_ESC(0,09,FORNECEDOR,"[@!S27]")
         Cab_ESC(0,37,SUBS(DTOC(DTAREC),1,6)+SUBS(DTOC(DTAREC),9,2),"[@D]")
         Cab_ESC(0,46,SUBS(DTOC(DTREC),1,6)+SUBS(DTOC(DTREC),9,2),"[@D]")
         Cab_ESC(0,57,VLR_AREC,"[@E 999,999.99]")
         Cab_ESC(0,70,VLR_REC,"[@E 999,999.99]")
      ELSE
         IF !EMPTY(wOp1)
            Cab_ESC(0,09,SUBS(DTOC(DTEMISS),1,6)+SUBS(DTOC(DTEMISS),9,2),"[@D]")
            Cab_ESC(0,18,SUBS(DTOC(DTAREC),1,6)+SUBS(DTOC(DTAREC),9,2),"[@D]")
            Cab_ESC(0,27,SUBS(DTOC(DTREC),1,6)+SUBS(DTOC(DTREC),9,2),"[@D]")
            Cab_ESC(0,37,VLR_AREC,"[@E 999,999.99]")
            Cab_ESC(0,50,VLR_REC,"[@E 999,999.99]")
            Cab_ESC(0,61,JurCorr(DTAREC,IF(!EMPTY(DTREC),DTREC,cDtSys),VLR_AREC,FORNECEDOR->MORA),"[@E 999,999.99]")
         ELSEIF !EMPTY(wOp2)
            Cab_ESC(0,09,SUBS(DTOC(DTEMISS),1,6)+SUBS(DTOC(DTEMISS),9,2),"[@D]")
            Cab_ESC(0,18,SUBS(DTOC(DTAREC),1,6)+SUBS(DTOC(DTAREC),9,2),"[@D]")
            Cab_ESC(0,28,VLR_AREC,"[@E 999,999.99]")
            Cab_ESC(0,41,JurCorr(DTAREC,IF(!EMPTY(DTREC),DTREC,cDtSys),VLR_AREC,FORNECEDOR->MORA),"[@E 999,999.99]")
            Cab_ESC(0,54,VLR_AREC+JurCorr(DTAREC,IF(!EMPTY(DTREC),DTREC,cDtSys),VLR_AREC,FORNECEDOR->MORA),"[@E 999,999.99]")
         ENDIF
      ENDIF
      nTotLiq  += VLR_AREC
      nTotPag  += VLR_REC
      nTotCor  += JurCorr(DTAREC,IF(!EMPTY(DTREC),DTREC,cDtSys),VLR_AREC,FORNECEDOR->MORA)
      DBSKIP()
      IF PROW()>57 .AND. !EOF()
         Cab_ESC(01,02,REPL("=",78))
         Cab_ESC(01,02,"A TRANSPORTAR ---->")
         IF EMPTY(wCod_cf)
            Cab_ESC(0,57,nTotLiq,"[@E 999,999.99]")
            Cab_ESC(0,70,nTotPag,"[@E 999,999.99]")
         ELSE
            IF !EMPTY(wOp1)
               Cab_ESC(0,37,nTotLiq,"[@E 999,999.99]")
               Cab_ESC(0,50,nTotPag,"[@E 999,999.99]")
               Cab_ESC(0,61,nTotCor,"[@E 999,999.99]")
            ELSEIF !EMPTY(wOp2)
               Cab_ESC(0,28,nTotLiq,"[@E 999,999.99]")
               Cab_ESC(0,41,nTotCor,"[@E 999,999.99]")
               Cab_ESC(0,54,nTotLiq+nTotCor,"[@E 999,999.99]")
            ENDIF
         ENDIF
         EJECT; lCabec:=.T.
      ENDIF
   ENDDO
   IF continua.AND.lEntrou
      Cab_ESC(01,02,REPL("=",78))
      Cab_ESC(01,02,"T O T A L  ------->")
      IF EMPTY(wCod_cf)
         Cab_ESC(0,55,nTotLiq,"[@E 999,999.99]")
         Cab_ESC(0,68,nTotPag,"[@E 999,999.99]")
      ELSE
         IF !EMPTY(wOp1)
            Cab_ESC(0,37,nTotLiq,"[@E 999,999.99]")
            Cab_ESC(0,50,nTotPag,"[@E 999,999.99]")
            Cab_ESC(0,61,nTotCor,"[@E 999,999.99]")
         ELSEIF !EMPTY(wOp2)
            Cab_ESC(0,28,nTotLiq,"[@E 999,999.99]")
            Cab_ESC(0,41,nTotCor,"[@E 999,999.99]")
            Cab_ESC(0,54,nTotLiq+nTotCor,"[@E 999,999.99]")
         ENDIF
      ENDIF
      EJECT
   ENDIF
   SET DEVICE TO SCREEN
   RETURN lAchou
*ีออออออออออออออออออออออออออออออออออธ
*ณ Calcular Juros Compostos         ณ
*ิออออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE JurCorr(pDtVct,pDtPag,pValor,pJuros)
   nAtraso := pDtPag-pDtVct
   IF nAtraso>0
      nVlrJur := (((((pJuros/30)/100)+1)^IF(nAtraso<0,0,nAtraso))*pValor)-pValor
   ELSE
      nVlrJur := 0.00
   ENDIF
   RETURN(nVlrJur)
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel263()
   CabRel("RELATORIO FINANCEIRO - "+IF(!EMPTY(wOp1),"PAGOS","A PAGAR"))
   @ PROW()+1,02 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   IF !EMPTY(wCod_cf)
      @ PROW()+2,02 SAY "Fornecedor : "+FORNECEDOR->RAZAO
      @ PROW()+1,02 SAY "Endereo   : "+FORNECEDOR->ENDERECO
      @ PROW()+1,02 SAY "Bairro     : "+FORNECEDOR->BAIRRO
      @ PROW()  ,35 SAY "Cidade     : "+RTRIM(FORNECEDOR->CIDADE)+"/"+FORNECEDOR->UF
      @ PROW()+1,02 SAY "C.N.P.J.   : "+TRANSFORM(FORNECEDOR->CGC,"@R 99.999.999/9999-99")
      @ PROW()  ,35 SAY "I.Estadual : "+FORNECEDOR->INSC
   ENDIF
   @ PROW()+1,02 SAY REPLICATE("-",78)
   IF !EMPTY(wCod_cf)
      IF !EMPTY(wOp1)
         @ PROW()+1,02 SAY "FATURA EMISSAO   VCTO.    PAGTO.   VL.COBRADO  VL.RECEBIDO   CORRECAO"
*                           999999 99/99/99 99/99/99 99/99/99  999,999.99   999,999.99 999,999.99
*                           234567890123456789012345678901234567890123456789012345678901234567890123456789
*                                   1         2         3         4         5         6         7
      ELSEIF !EMPTY(wOp2)
         @ PROW()+1,02 SAY "FATURA EMISSAO   VCTO.    VL.FATURA      CORRECAO   VL.COBRADO"
*                           999999 99/99/99 99/99/99  999,999.99   999,999.99   999,999.99
*                           234567890123456789012345678901234567890123456789012345678901234567890123456789
*                                   1         2         3         4         5         6         7
      ENDIF
   ELSE
      @ PROW()+1,02 SAY "FATURA FORNECEDOR                    VCTO.   PAGTO.    VALOR COB.   VALOR PAGO"
*                        999999 XXXXXXXXXXxxxxxxxxxxXXXXXXX 99/99/99 99/99/99   999,999.99   999,999.99
*                      01234567890123456789012345678901234567890123456789012345678901234567890123456789
*                                1         2         3         4         5         6         7
   ENDIF
   @ PROW()+1,02 SAY REPLICATE("-",78)
   RETURN
