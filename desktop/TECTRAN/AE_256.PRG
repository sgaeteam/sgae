*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_256                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Faturas Pagas                            ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 18/09/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NDOC"    ,"C", 06,0})
AADD(aDbf,{"COD_CF"  ,"C", 04,0})
AADD(aDbf,{"DTEMISS" ,"D", 08,0})
AADD(aDbf,{"DTAPAG"  ,"D", 08,0})
AADD(aDbf,{"DTPAG"   ,"D", 08,0})
AADD(aDbf,{"VLR_PAG" ,"N", 12,2})
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
INDEX ON DTOS(DTPAG)        TO (cArq1)
INDEX ON COD_CF+DTOS(DTPAG) TO AT000000
SET INDEX TO (cArq1), AT000000

SELECT 2
IF Netuse("DBFORN","FORNECEDOR")      /* Fornecedores */
   SET INDEX TO DBIFOR1,DBIFOR2
ELSE
   DelDbfNtx(); FERASE("AT000000.NTX"); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAGA","PAGAR")           /* Contas a Pagar */
   SET INDEX TO DBIPG5,DBIPG3,DBIPG1,DBIPG4,DBIPG2
ELSE
   DelDbfNtx(); FERASE("AT000000.NTX"); RETURN
ENDIF

ProgName("AE256"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "56"

*dPer:=cDtSys-90                /* Faturas pagas ate 90 dias atr s */
*PAGAR->(DBSEEK(DTOS(dPer)),.T.)

/* Alimentar o Arquivo temporario */
Aguarde("Localizando Contas...")
*WHILE PAGAR->DTAPAG>=dPer.AND.!PAGAR->(EOF())
WHILE !PAGAR->(EOF())
  IF PAGAR->(DTPAG) # CTOD("")
     (cArq1)->(DBAPPEND())
     REPLACE (cArq1)->NDOC    WITH PAGAR->NDOC   ,;
             (cArq1)->COD_CF  WITH PAGAR->COD_CF ,;
             (cArq1)->DTEMISS WITH PAGAR->DTEMISS,;
             (cArq1)->DTAPAG  WITH PAGAR->DTAPAG ,;
             (cArq1)->DTPAG   WITH PAGAR->DTPAG  ,;
             (cArq1)->VLR_PAG WITH PAGAR->VLR_PAG,;
             (cArq1)->OBS     WITH PAGAR->OBS
  ENDIF
  PAGAR->(DBSKIP())
ENDDO
Aguarde()

SELECT (cArq1); DBGOTOP()
IF EOF()
   Aviso("Nฦo h  Faturas Pagas...",,3)
   DelDbfNtx(); FERASE("AT000000.NTX"); RETURN
ENDIF

LimpaLinhaMsg(24)
Mensagem("Comandos:   -Imprime Lista")
@ 23,38 SAY "I" COLOR YCORTECLAS
BrowFat(); Mensagem()
DelDbfNtx(); FERASE("AT000000.NTX"); RETURN
*ีอออออออออออออออออออออออออออออออออธ
*ณ Browse das Faturas Pagas        ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowFat()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   Area_Dados(); SETCOLOR(YCOREDIT)
   Telas(4,3,20,75,1,YCOREDIT,.T.,"ด Faturas Pagas ร")
   oBr:=TBROWSEDB(5,4,19,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oCol:=TBCOLUMNNEW("Favorecido",{|| TRANSFORM(PegaForn(COD_CF),"@S30") })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fatura Nง" ,{|| NDOC })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Emissฦo"   ,{|| DTEMISS })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Vencimento",{|| DTAPAG })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Pagamento" ,{|| DTPAG })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor Pago",{|| TRANSFORM(VLR_PAG,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oBr:Freeze:=1

   WHILE .T.
      WHILE !(oBr:stabilize()); ENDDO
      tecla := INKEY(0)
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
         LimpaLinhaMsg(24)
         Mensagem("Comandos:   -Imprime Lista")
         @ 23,38 SAY "I" COLOR YCORTECLAS
      ELSEIF (tecla == 73 .OR. tecla == 105)  /* Imprimir Lista */
         Telas(14,3,16,30,1,YCOREDIT,.T.,"ด Perกodo ร")
         wPerIni:=wPerFim:=CTOD("")
         @ 15,16 SAY "a"
         @ 15,05 GET wPerIni PICT "@D" VALID !EMPTY(wPerIni)
         @ 15,18 GET wPerFim PICT "@D" VALID wPerFim>=wPerIni
         SETCURSOR(1); READ; SETCURSOR(0)

         IF LASTKEY()#K_ESC.AND.ChkImpr()
            IF ImpDupPagas()
            ENDIF
            DBSEEK(DTOS(CTOD("")),.T.)
         ENDIF
         Rest_Tela()
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออออธ
*ณ Posiciona no Inicio da Condicao ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoTop(searcher)
   DBSEEK(searcher)
   RETURN NIL
*ีอออออออออออออออออออออออออออออออออธ
*ณ Posiciona no Final da Condicao  ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GotoBott(searcher)
   LOCAL save_soft
   /* Recuperar o status anterior do SoftSeek */
   save_soft = SET(_SET_SOFTSEEK, .T.)
   DBSEEK(searcher)
   DBSKIP(-1)
   SET(_SET_SOFTSEEK, save_soft)
   RETURN NIL
*ีออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ Move para o registro que satisfaz a Condicao ณ
*ิออออออออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION MovePointer(nSalto,pPesquisa,pChave)
   LOCAL nQtdSkip := 0

   IF EOF()
   ELSEIF nSalto = 0
      DBSKIP(0)
   ELSE
      WHILE !EOF() .AND. !BOF() .AND. nQtdSkip # nSalto .AND.;
            EVAL(pChave) < pPesquisa
         IF nSalto > 0
            DBSKIP()
            nQtdSkip++
         ELSE
            DBSKIP(-1)
            nQtdSkip--
         ENDIF
      ENDDO

      IF EOF()
         DBSKIP(-1)
         nQtdSkip--
      ELSEIF BOF()
         nQtdSkip++
         DBSKIP()
         DBSKIP(-1)
      ELSEIF EVAL(pChave) >= pPesquisa
         IF nSalto > 0
            DBSKIP(-1)
            nQtdSkip--
         ELSE
            DBSKIP()
            nQtdSkip++
         ENDIF
      ENDIF
   ENDIF
   RETURN nQtdSkip
*ีออออออออออออออออออออออออออออธ
*ณ Imprimir Faturas em Atraso ณ
*ิออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpDupPagas()
   LOCAL lCabec:=.T., nTotal:=0.00
   continua:=.T.; pg:=0

   DBSEEK(wPerIni,.T.)
   IF !EOF().AND.DTPAG<=wPerFim
      cAviso := MsgImp()
      SET DEVICE TO PRINT; SETPRC(0,0)
      WHILE continua.AND.DTPAG>=wPerIni.AND.DTPAG<=wPerFim.AND.!EOF()
         IF lCabec; CabRel262(); lCabec:=.F.; ENDIF
         IF !EMPTY(DTPAG)
            Cab_ESC(01,002,NDOC,"[999999]")
            Cab_ESC(00,010,PegaForn(COD_CF),"[@!S40]")
            Cab_ESC(00,051,DTEMISS,"[@D]")
            Cab_ESC(00,062,DTPAG,"[@D]")
            Cab_ESC(00,072,VLR_PAG,"[@E 999,999,999.99]")
            Cab_ESC(00,088,OBS,"[@S40]")
            nTotal += VLR_PAG
         ENDIF
         DBSKIP()
         IF PROW()>57 .AND. !EOF()
            EJECT; lCabec:=.T.
         ENDIF
      ENDDO
      IF continua
         Cab_ESC(01,002,REPL("=",130))
         Cab_ESC(01,002,"TOTAL ====>")
         Cab_ESC(00,072,nTotal,"[@E 999,999,999.99]")
         @ 62,00 SAY "* * * Final de Relatorio * * *"; EJECT
      ENDIF
      Compr_Off()
      SET DEVICE TO SCREEN
      TiraMsgImp(cAviso)
      WaitMsg("Fim de Impressฦo, tecle algo...")
      LimpaLinhaMsg(24)
      Mensagem("Comandos:   -Imprime Lista")
      @ 23,38 SAY "I" COLOR YCORTECLAS
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel262()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY cDtSys
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE FATURAS PAGAS"
   @ PROW()  ,002 SAY "LISTA DE FATURAS PAGAS"
   @ PROW()+1,002 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("-",130)
   @ PROW()+1,02 SAY "FATURA  FAVORECIDO                               EMISSAO  VENCIMENTO   VALOR LIQUIDO  OBSERVACOES"
*                     999999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/99   99/99/99  999,999,999.99  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx
*                   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                             1         2         3         4         5         6         7         8         9        10        11        12        13
   @ PROW()+1,002 SAY REPLICATE("-",130)
   RETURN
