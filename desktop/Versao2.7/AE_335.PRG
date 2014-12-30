*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : EB_335                           vrs 001 ณ
*ณ FINALIDADE     : Fechamento de Caixa                      ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 11/09/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"VEND_V"  ,"N", 12,2})
AADD(aDbf,{"QVEND_V" ,"N", 06,0})
AADD(aDbf,{"PERC_V"  ,"N", 06,2})
AADD(aDbf,{"VEND_P"  ,"N", 12,2})
AADD(aDbf,{"QVEND_P" ,"N", 06,0})
AADD(aDbf,{"PERC_P"  ,"N", 06,2})
AADD(aDbf,{"OFERTA"  ,"N", 12,2})
AADD(aDbf,{"QOFERTA" ,"N", 06,0})
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

SELECT 5
IF NetUse("DBLIVRO","LIVRO")        /* Cadastro de Livros */
   SET INDEX TO DBILIV1,DBILIV2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBTSAI","SAIDA")         /* Cadastro de Saidas de Material */
   SET INDEX TO DBISAI1
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

SELECT 2
IF NetUse("DBCLI","CLIENTE")        /* Cadastro de Clientes */
   SET INDEX TO DBICLI1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBMOV","MOVIMENTO")      /* Cadastro da Movimentaao de Material */
   SET INDEX TO DBIMOV4
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Arquivo de Movimenta”es Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("EB335"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "35"

Quadro(18,3,20,34,1,YCOREDIT,.T.,,.T.)
wDevice:=" "; wPerIni:=wPerFim:=CTOD("")
WHILE .T.
   /* Inicializar variaveis */
   nVendInt:=nVendIntV:=nVendIntP:=nVendOfer:=0.00
   nQVIntV:=nQVIntP:=nQOferta:=0

   SETCOLOR(YCOREDIT)
   @ 19,23 SAY "a"
   @ 19,05 SAY "Perกodo:" GET wPerIni PICT "@D" VALID (LASTKEY()==K_UP).OR.!EMPTY(wPerIni)
   @ 19,25                GET wPerFim PICT "@D" VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni
   SETCURSOR(1); READ; SETCURSOR(0)

   Mensagem()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   CalcTotVendas()
   BrowVendas()
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Calcular Vendas de Livros no Periodo ณ
*ิออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION CalcTotVendas()
   LOCAL tela:=SAVESCREEN(0,0,24,79)

   Aguarde("Calculando...")
   SELECT MOVIMENTO
   /* Saidas por Nota de Venda D-1 a Vista */
   DBSEEK("NS"+DTOS(wPerIni),.T.)
   IF DATAMOV<=wPerFim
      WHILE TIPOMOV=="NS".AND.DATAMOV>=wPerIni.AND.DATAMOV<=wPerFim
         (cArq1)->(DBAPPEND())
         IF SAIDA->(DBSEEK("NS"+MOVIMENTO->NF+MOVIMENTO->COD_CF))
            nVendInt += QUANT * VLUNIT
            IF SAIDA->DTEMISS==SAIDA->DTVCTO
               /* Venda a Vista */
               nVendIntV += QUANT * VLUNIT
               nQVIntV   += QUANT
               REPLACE (cArq1)->VEND_V  WITH (cArq1)->VEND_V + (QUANT * VLUNIT),;
                       (cArq1)->QVEND_V WITH (cArq1)->QVEND_V + QUANT
            ELSE
               /* Venda a Prazo */
               nVendIntP += QUANT * VLUNIT
               nQVIntP   += QUANT
               REPLACE (cArq1)->VEND_P  WITH (cArq1)->VEND_P + (QUANT * VLUNIT),;
                       (cArq1)->QVEND_P WITH (cArq1)->QVEND_P + QUANT
            ENDIF
         ENDIF
         DBSKIP()
      ENDDO
   ENDIF

   /* Saidas por Oferta */
   DBSEEK("SO"+DTOS(wPerIni),.T.)
   IF DATAMOV<=wPerFim
      WHILE TIPOMOV=="SO".AND.DATAMOV>=wPerIni.AND.DATAMOV<=wPerFim
         (cArq1)->(DBAPPEND())
         nVendOfer += QUANT * VLUNIT
         nQOferta  += QUANT
         REPLACE (cArq1)->OFERTA  WITH (cArq1)->OFERTA + (QUANT * VLUNIT),;
                 (cArq1)->QOFERTA WITH (cArq1)->QOFERTA + QUANT
         DBSKIP()
      ENDDO
   ENDIF
   Aguarde()
   DBCOMMITALL()

   Area_Dados(); Telas(8,6,16,65,1,YCOREDIT,.T.)
   DispVendas()
   WaitMsg(,.F.)
   Rest_Tela()
   RESTSCREEN(0,0,24,79,tela)
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse das Vendas              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowVendas()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   LinhaMsg(10)
   SELECT (cArq1); DBGOTOP()
   Telas(3,5,5,75,1,YCOREDIT,.T.)
   @ 04,07 SAY "Perกodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,5,18,75,1,YCOREDIT,.T.,"Tabela de Fechamento de Caixa")
   oBr:=TBROWSEDB(7,6,17,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCOREDIT

   oCol:=TBCOLUMNNEW("Venda Vista",{|| TRANSFORM(VEND_V,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Quant."     ,{|| TRANSFORM(QVEND_V,"@E 999,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("% Vista"    ,{|| TRANSFORM(PERC_V,"@E 999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Venda Prazo",{|| TRANSFORM(VEND_P,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Quant."     ,{|| TRANSFORM(QVEND_P,"@E 999,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("% Prazo"    ,{|| TRANSFORM(PERC_P,"@E 999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Ofertas"    ,{|| TRANSFORM(OFERTA,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Quant."     ,{|| TRANSFORM(QOFERTA,"@E 999,999")})
   oBr:addColumn(oCol)

   oBr:Freeze=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F1 )
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
      ELSEIF ( tecla == K_F4 )
         Calculadora(calc_lin,calc_col,YCORMENU)
      ELSEIF ( tecla == K_F5 )
         Calendary(@cale_lin,@cale_col,@m_date)
      ELSEIF ( tecla == K_F8 )    /* Imprimir */
         IF ChkImpr()
            cAviso := MsgImp()
            ImpVendas()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso, tecle algo...")
            Mensagem()
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออออออออออออธ
*ณ Imprimir Resultados                     ณ
*ิอออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION DispVendas()
   @ 08,06 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฟ"
   @ 09,06 SAY "ณ    Vendas     ณ  Quantidades  ณ      Valores     ณ   %   ณ"
   @ 10,06 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤด"
   @ 11,06 SAY "ณ   A Vista     ณ               ณ                  ณ       ณ"
   @ 12,06 SAY "ณ   A Prazo     ณ               ณ                  ณ       ณ"
   @ 13,06 SAY "ณ   Ofertas     ณ               ณ                  ณ       ณ"
   @ 14,06 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤด"
   @ 15,06 SAY "ณ  T O T A L    ณ               ณ                  ณ 100,00ณ"
   @ 16,06 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤู"
*               6789012345678901234567890123456789012345678901234567890123456789012
*                   1         2         3         4         5         6         7
   nTotVend := nVendIntV + nVendIntP + nVendOfer
   @ 11,27 SAY nQVIntV                    PICT "@E 999,999"
   @ 11,41 SAY nVendIntV                  PICT "@E 999,999,999.99"
   @ 11,59 SAY (nVendIntV/nTotVend)*100   PICT "@E 999.99"
   @ 12,27 SAY nQVIntP                    PICT "@E 999,999"
   @ 12,41 SAY nVendIntP                  PICT "@E 999,999,999.99"
   @ 12,59 SAY (nVendIntP/nTotVend)*100   PICT "@E 999.99"
   @ 13,27 SAY nQOferta                   PICT "@E 999,999"
   @ 13,41 SAY nVendOfer                  PICT "@E 999,999,999.99"
   @ 13,59 SAY (nVendOfer/nTotVend)*100   PICT "@E 999.99"
   @ 15,27 SAY (nQVIntV+nQVIntP+nQOferta) PICT "@E 999,999"
   @ 15,41 SAY nTotVend                   PICT "@E 999,999,999.99"
   RETURN NIL
*ีอออออออออออออออออออออออออออออออออออออออออธ
*ณ Imprimir Lista de Vendas                ณ
*ิอออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpVendas()
   SET DEVI TO PRINT; SETPRC(0,0)
   SELECT (cArq1); DBGOTOP()
   pg:=0; continua:=.T.
   CabRel("RELATORIO DE FECHAMENTO DE CAIXA")
   Compr_On()
   @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   DispVendas()
   Compr_Off()
   SET DEVICE TO SCREEN
   RETURN
