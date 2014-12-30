*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : EB_334                           vrs 001 ณ
*ณ FINALIDADE     : Listagem de Vendas de Livros             ณ
*ณ PROGRAMADOR    : VITOR A. SMITH FREIRE - NETCOM           ณ
*ณ DATA CRIACAO   : 29/07/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"TITULO"    ,"C", 50,0})
AADD(aDbf,{"CODLIVRO"  ,"C", 08,0})
AADD(aDbf,{"VENDA"     ,"N", 06,0})
AADD(aDbf,{"OFERTAS"   ,"N", 06,0})
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
INDEX ON TITULO TO (cArq1)

SELECT 5
IF NetUse("DBLIVRO","LIVRO")        /* Cadastro de Livros */
   SET INDEX TO DBILIV2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBMOV","MOVIMENTO")      /* Cadastro da Movimentaao de Vendas */
   SET INDEX TO DBIMOV3
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Arquivo de Movimenta”es Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("EB334"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "34"

Quadro(18,3,20,34,1,YCOREDIT,.T.,,.T.)
wDevice:=" "; wPerIni:=wPerFim:=CTOD("")
WHILE .T.
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
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออออออออธ
*ณ Calcular Vendas de Livros no Periodo ณ
*ิออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION CalcTotVendas()
   Aguarde("Calculando...")
   SELECT LIVRO
   WHILE !LIVRO->(EOF())
      cCodLivro:=LIVRO->CODLIVRO
      MOVIMENTO->(DBSEEK(LIVRO->CODLIVRO+DTOS(wPerIni),.T.))
      nVenda:=nDevolucao:=0
      WHILE MOVIMENTO->CODLIVRO==cCodLivro .AND. MOVIMENTO->DATAMOV <= wPerFim
         IF MOVIMENTO->TIPOMOV=='SV' .OR. MOVIMENTO->TIPOMOV=='SN' .OR. ;
            MOVIMENTO->TIPOMOV=='VS' .OR. MOVIMENTO->TIPOMOV=='NS' .OR. ;
            MOVIMENTO->TIPOMOV=='RV'
            nVenda+=MOVIMENTO->QUANT
         ELSEIF MOVIMENTO->TIPOMOV='SO'
            nDevolucao+=MOVIMENTO->QUANT
         ENDIF
         MOVIMENTO->(DBSKIP())
      ENDDO
      (cArq1)->(NetApp())
      REPLACE (carq1)->TITULO    WITH LIVRO->TITULO,;
              (carq1)->CODLIVRO  WITH LIVRO->CODLIVRO,;
              (carq1)->VENDA     WITH nVenda,;
              (carq1)->OFERTAS   WITH nDevolucao
      (cArq1)->(DBUNLOCK())
      LIVRO->(DBSKIP())
   ENDDO
   Aguarde()
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse das Vendas              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowVendas()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   LinhaMsg(10)
   SELECT (cArq1); DBGOTOP()
   Telas(3,5,5,75,1,YCOREDIT,.T.)
   @ 04,07 SAY "Perกodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,5,18,75,1,YCOREDIT,.T.,"Vendas e Ofertas de Livros")
   oBr:=TBROWSEDB(7,6,17,74)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCOREDIT

   oCol:=TBCOLUMNNEW("Tกtulo"       ,{|| TRANSFORM(TITULO,"@S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cขdigo"       ,{|| TRANSFORM(CODLIVRO,"@R 9999999-X")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Qtd.Venda"    ,{|| TRANSFORM(VENDA,"@E 999,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Qtd.Ofertas"  ,{|| TRANSFORM(OFERTAS,"@E 999,999")})
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
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออออออออออออธ
*ณ Imprimir Lista de Vendas                ณ
*ิอออออออออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpVendas()
   LOCAL nTotVendas:=nTotDevolv:=0

   SET DEVI TO PRINT; SETPRC(0,0)
   SELECT (cArq1); DBGOTOP()
   pg:=0
   CabRel("RELATORIO DE VENDAS E OFERTAS NO PERIODO")
   @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Compr_On()
   @ PROW()+1,02 SAY REPLICATE("-",90)
   @ PROW()+1,02 SAY "TITULO                                              CODIGO       VENDAS       OFERTAS"
*                     XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX  99999999-A   999,999      999,999
*                     23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                             1         2         3         4         5         6         7         8         9
   @ PROW()+1,02 SAY REPLICATE("-",90)
   WHILE !EOF()
      @ PROW()+1,02 SAY TITULO
      @ PROW()  ,54 SAY CODLIVRO  PICT "@R 9999999-A"
      @ PROW()  ,67 SAY VENDA     PICT "@E 999,999"
      @ PROW()  ,80 SAY OFERTAS   PICT "@E 999,999"
      nTotVendas += VENDA
      nTotDevolv += DEVOLUCAO
      DBSKIP()
      IF PROW()>=57.AND.!EOF()
         EJECT; CabRel("RELATORIO DE VENDAS E OFERTAS NO PERIODO")
         Compr_On()
         @ PROW()+1,02 SAY REPLICATE("-",90)
         @ PROW()+1,02 SAY "TITULO                                                CODIGO    QTD.VENDA   QTD.DEVOLU"
         @ PROW()+1,02 SAY REPLICATE("-",90)
      ENDIF
   ENDDO
   @ PROW()+1,02 SAY REPLICATE("-",90)
   @ PROW()+1,02 SAY "T O T A L    --------->"
   @ PROW()  ,67 SAY nTotVendas PICT "@E 999,999"
   @ PROW()  ,80 SAY nTotDevolv PICT "@E 999,999"
   @ 62,00 SAY "* * * Final de Relatorio * * *"; EJECT
   Compr_Off()
   SET DEVICE TO SCREEN
   RETURN
