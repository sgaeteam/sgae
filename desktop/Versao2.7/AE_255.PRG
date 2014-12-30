*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_255                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Faturas a Pagar em Atraso                ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 18/09/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 2
IF Netuse("DBFORN","FORNECEDOR")      /* Fornecedores */
   SET INDEX TO DBIFOR1,DBIFOR2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAGA","PAGAR")           /* Contas a Pagar */
   SET INDEX TO DBIPG5,DBIPG3,DBIPG1,DBIPG4,DBIPG2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE255"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "55"
LimpaLinhaMsg(24)
Mensagem("Comandos:   -Imprime Lista")
@ 23,38 SAY "I" COLOR YCORTECLAS
BrowFat(); Mensagem()
RETURN
*ีอออออออออออออออออออออออออออออออออธ
*ณ Browse das Faturas em Atraso    ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowFat()
   LOCAL corant:=SETCOLOR(), oBr, oCol

*  DBSEEK(DTOS(CTOD("")),.T.)
   DBSEEK(DTOS(CTOD("")))
   IF DTAPAG>=cDtSys.OR.EOF()
      Aviso("Nenhuma Fatura em Atraso! Tecle algo..."); RETURN NIL
   ENDIF
   Area_Dados(); SETCOLOR(YCOREDIT)
   Telas(4,3,20,75,1,YCOREDIT,.T.,"ด Faturas a Pagar em Atraso ร")
   oBr:=TBROWSEDB(5,4,19,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "

   oBr:gotopblock    = {|| GotoTop(DTOS(CTOD("")))}
   oBr:gobottomblock = {|| GotoBott(DTOS(CTOD(""))+DTOS(cDtSys+1))}
   oBr:skipblock     = {|n| MovePointer(n,DTOS(CTOD(""))+DTOS(cDtSys+1),{|| DTOS(DTPAG)+DTOS(DTAPAG+1)})}

   oCol:=TBCOLUMNNEW("Fatura Nง" ,{|| NDOC })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Favorecido",{|| PegaForn(COD_CF) })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Emissฦo"   ,{|| DTEMISS })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Vencimento",{|| DTAPAG })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor"     ,{|| TRANSFORM(VLR_APAG,"@E 999,999,999.99")})
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
         IF ChkImpr()
            IF ImpDupAtraso()
            ENDIF
            DBSEEK(DTOS(CTOD("")),.T.)
         ENDIF
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
STATIC FUNCTION ImpDupAtraso()
   LOCAL lCabec:=.T., nTotal:=0.00
   continua:=.T.; pg:=0

   IF !(lAchou:=DBSEEK(DTOS(CTOD(''))))
      Aviso("Nฦo h  Faturas em Atraso...",,3)
   ELSE
      cAviso := MsgImp()
   ENDIF
   SET DEVICE TO PRINT; SETPRC(0,0)
   WHILE continua.AND.!EOF()
      IF lCabec; CabRel262(); lCabec:=.F.; ENDIF
      IF DTAPAG<cDtSys.AND.EMPTY(DTPAG)
         Cab_ESC(01,002,NDOC,"[999999]")
         Cab_ESC(00,010,PegaForn(COD_CF),"[@!S40]")
         Cab_ESC(00,051,DTEMISS,"[@D]")
         Cab_ESC(00,062,DTAPAG,"[@D]")
         Cab_ESC(00,072,VLR_APAG,"[@E 999,999,999.99]")
         Cab_ESC(00,088,OBS,"[@S40]")
         nTotal += VLR_APAG
      ENDIF
      DBSKIP()
      IF PROW()>57 .AND. !EOF()
         EJECT; lCabec:=.T.
      ENDIF
   ENDDO
   IF continua.AND.lAchou
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
   RETURN lAchou
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel262()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY cDtSys
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE FATURAS A PAGAR EM ATRASO"
   @ PROW()  ,002 SAY "LISTA DE FATURAS A PAGAR EM ATRASO"
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("-",130)
   @ PROW()+1,02 SAY "FATURA  FAVORECIDO                               EMISSAO  VENCIMENTO   VALOR LIQUIDO  OBSERVACOES"
*                     999999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/99   99/99/99  999,999,999.99  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx
*                   01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                             1         2         3         4         5         6         7         8         9        10        11        12        13
   @ PROW()+1,002 SAY REPLICATE("-",130)
   RETURN
