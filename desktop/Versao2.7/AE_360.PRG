*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : EB_360                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Ficha Kardex                             ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 04/05/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NF"      ,"C", 06,0})
AADD(aDbf,{"TIPOMOV" ,"C", 02,0})
AADD(aDbf,{"DATAMOV" ,"D", 08,0})
AADD(aDbf,{"QTDE"    ,"N", 05,0})
AADD(aDbf,{"VALOR"   ,"N", 12,2})
AADD(aDbf,{"SALDO"   ,"N", 12,2})
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
INDEX ON DTOS(datamov) TO (cArq1)

SELECT 8
IF NetUse("DBLIVRO","LIVRO")        /* Cadastro de Livros */
   SET INDEX TO DBILIV1,DBILIV2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 6
IF NetUse("DBMOV","MOVIMENTO")      /* Cadastro da Movimentaao de Material */
   SET INDEX TO DBIMOV3,DBIMOV1
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("EB360"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "60"
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(17,3,21,27,1,YCOREDIT,.T.)
   Mensagem("Informe o Livro e o Perกodo")
   vCodLivro:=SPACE(7)+"A"
   wPerIni:=wPerFim:=CTOD("")

   @ 18,05 SAY "    Livro:" GET vCodLivro PICT "@!R 9999999-A" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(vCodLivro).AND.Pesquisa(8,1,vCodLivro,"Livro No Cadastrado!")
   @ 19,05 SAY "Dt.Inicio:" GET wPerIni   PICT "@D" WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
   @ 20,05 SAY " Dt.Final:" GET wPerFim   PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni
   SETCURSOR(1); READ; SETCURSOR(0)

   Rest_Tela()
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   BrowKardex()
   (cArq1)->(__DBZAP())
ENDDO
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse da Ficha Kardex         ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowKardex()
   LOCAL corant:=SETCOLOR(), oBr, oColn,nreg, nSdAntes:=0.00

   SELECT MOVIMENTO; DBSEEK(vCodLivro)
   IF EOF()
      Aviso("No h  movimento deste Livro neste perกodo..."); RETURN .F.
   ENDIF

   DBSEEK(vCodLivro+DTOS(wPerIni),.T.)
   IF EOF().OR.DATAMOV>wPerFim
      Aviso("No h  movimento deste Livro neste perกodo..."); RETURN .F.
   ENDIF

   LinhaMsg(10)
   Telas(2,0,5,79,1,YCOREDIT,.F.)
   @ 03,02 SAY "  Livro: "+LIVRO->TITULO
   @ 04,02 SAY "Perกodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,0,22,79,1,YCOREDIT,.F.,"ด Ficha Kardex ร")

   /* Calcular o Saldo anterior */
   nSdAntes := LIVRO->SALDO
   WHILE CODLIVRO==vCodLivro
      IF DATAMOV<=wPerFim
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NF      WITH NF,;
                 (cArq1)->TIPOMOV WITH TIPOMOV,;
                 (cArq1)->DATAMOV WITH DATAMOV,;
                 (cArq1)->QTDE    WITH QUANT,;
                 (cArq1)->VALOR   WITH QUANT*VLUNIT
      ENDIF
      nSdAntes += IF("S" $ TIPOMOV,QUANT,QUANT*(-1))
      DBSKIP()
   ENDDO
   DBSEEK(vCodLivro+DTOS(wPerIni),.T.)

   SELECT (cArq1); DBGOTOP()
   REPLACE SALDO WITH nSdAntes
   WHILE !EOF()
      IF "S" $ TIPOMOV
         REPLACE SALDO WITH nSdAntes - QTDE
      ELSE
         REPLACE SALDO WITH nSdAntes + QTDE
      ENDIF
      nSdAntes := SALDO
      DBSKIP()
   ENDDO
   DBGOTOP()

   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec = YCOREDIT

   oCol:=TBCOLUMNNEW("NF",{|| NF})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Tipo Mov.",{|| TIPOMOV})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Data Mov.",{|| DATAMOV})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Quant.",{|| TRANSFORM(QTDE,"@E 999,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR,"@E 999,999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Saldo",{|| TRANSFORM(SALDO,"@E 999,999") })
   oBr:addColumn(oCol)

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
      ELSEIF ( tecla == K_F8 )
         IF ChkImpr()
            cAviso := MsgImp()
            ImpKardex()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impresso, tecle algo...")
            Mensagem()
         ENDIF
      ELSEIF ( tecla == K_F2 )
         Ajuda()
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Kardex                ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpKardex()
   LOCAL nReg:=RECNO()

   SET DEVI TO PRINT; SETPRC(0,0)
   SELECT (cArq1); DBGOTOP()
   pg:=0; continua:=.T.
   CabRel("RELATORIO DE MOVIMENTACAO - KARDEX")
   @ PROW()+1,02 SAY "Livro :"
   @ PROW()  ,10 SAY LIVRO->TITULO
   @ PROW()  ,10 SAY LIVRO->TITULO
   @ PROW()+1,02 SAY REPLICATE("-",78)
   @ PROW()+1,10 SAY "MOVIMENTACAO"
   @ PROW()+1,02 SAY "NF      MOV.    DATA    QUANT.           VALOR     SALDO"
   @ PROW()+1,02 SAY REPLICATE("-",78)
   WHILE continua.AND.!EOF()
      @ PROW()+1,02 SAY NF       PICT "999999"
      @ PROW()  ,10 SAY TIPOMOV
      @ PROW()  ,14 SAY DATAMOV  PICT "@D"
      @ PROW()  ,25 SAY QTDE     PICT "@E 999,999"
      @ PROW()  ,34 SAY VALOR    PICT "@E 999,999,999.99"
      @ PROW()  ,51 SAY SALDO    PICT "@E 999,999"
      DBSKIP()
      IF PROW()>=57.AND.!EOF()
         EJECT; CabRel("RELATORIO DE MOVIMENTACAO - KARDEX")
         @ PROW()+1,02 SAY REPLICATE("-",78)
         @ PROW()+1,10 SAY "MOVIMENTACAO"
         @ PROW()+1,02 SAY "NF      MOV.    DATA    QUANT.           VALOR     SALDO"
         @ PROW()+1,02 SAY REPLICATE("-",78)
      ENDIF
   ENDDO
   IF continua
      @ 62,00 SAY "* * * Final de Relatorio * * *"; EJECT
   ENDIF
   SET DEVICE TO SCREEN
   GO nReg
   RETURN NIL
