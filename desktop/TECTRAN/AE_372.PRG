*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : RC_372                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Extrato de Conta Corrente Por Item       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 21/11/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"DESCR"   ,"C", 35,0})
AADD(aDbf,{"TIPOLAN" ,"C", 01,0})
AADD(aDbf,{"VALOR"   ,"N", 12,2})
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
INDEX ON DESCR+TIPOLAN TO (cArq1)

SELECT 3
IF NetUse("DBITEM","ITEM")          /* Cadastro de Historico */
   SET INDEX TO DBITEM1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBMOVBCO","MOVBANCO")    /* Cadastro de Movimentacao Bancaria */
   SET INDEX TO DBIMOVB2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBBANCO","BANCO")         /* Cadastro de Bancos */
   SET INDEX TO DBIBCC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBGOTOP()
IF EOF()
   Aviso("No h  contas cadastradas...",,3); DBCLOSEALL(); RETURN
ENDIF

ProgName("RC372"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "72"
SET KEY -1 TO Mostra()
WHILE .T.
   cPrg:="RC290"
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Nฃmero da Conta")
   Mostra()
   vConta:=BANCO->CONTA
   Mensagem()
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   wPerIni:=wPerFim:=CTOD("")

   Mensagem("Informe a Senha de Acesso")
   SET CONFIRM ON
   Telas(19,3,21,10,1,YCOREDIT,.T.,"Senha"); nVezes:=1; lOk:=.F.
   WHILE nVezes<4
      xSenha:=""
      xSenha:=Test_Entry(20,5,4,xSenha,"PW","N/W")
      IF LASTKEY()==K_ESC; EXIT; ENDIF
      IF BANCO->SENHA#Codifica(xSenha)
         Aviso("Senha Inv lida...")
      ELSEIF BANCO->SENHA==Codifica(xSenha)
         Rest_Tela(); lOk:=.T.; EXIT
      ENDIF
      @ 20,5 SAY SPACE(4) COLOR "N/W"
      nVezes++
   ENDDO
   Mensagem()
   SET CONFIRM OFF
   IF LASTKEY()==K_ESC; Rest_Tela(); LOOP; ENDIF
   IF !lOk
      Aviso("Usu rio no Autorizado...",,3)
      Rest_Tela(); EXIT
   ENDIF

   Telas(17,3,20,26,1,YCOREDIT,.T.)
   WHILE .T.
      @ 18,05 SAY "Dt.Inicio:" GET wPerIni PICT "@D" WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
      @ 19,05 SAY " Dt.Final:" GET wPerFim PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni.AND.wPerFim<=DATE()
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      Aguarde("Calculando...")
      MOVBANCO->(DBSEEK(vConta)); nSaldo:=BANCO->SALDO
      WHILE MOVBANCO->CONTA==vConta.AND.!MOVBANCO->(EOF())
         IF MOVBANCO->DATMOV>=wPerIni.AND.MOVBANCO->DATMOV<=wPerFim
            ITEM->(DBSEEK(MOVBANCO->ITEM_CX))
            IF !(cArq1)->(DBSEEK(ITEM->DESCR+MOVBANCO->TIPOLAN))
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->DESCR   WITH ITEM->DESCR,;
                       (cArq1)->TIPOLAN WITH MOVBANCO->TIPOLAN,;
                       (cArq1)->VALOR   WITH MOVBANCO->VALOR
            ELSE
               REPLACE (cArq1)->VALOR   WITH (cArq1)->VALOR+MOVBANCO->VALOR
            ENDIF
         ENDIF
         MOVBANCO->(DBSKIP())
      ENDDO
      Aguarde()
      BrowExtrato()
      (cArq1)->(__DBZAP())
   ENDDO
   Rest_Tela()
ENDDO
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Extrato              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowExtrato()
   LOCAL corant:=SETCOLOR(), oBr, oColn,nreg, nSdAntes:=0.00

   SELECT (cArq1); DBGOTOP()
   IF EOF()
      Aviso("No houve movimentao neste perกodo..."); RETURN .F.
   ENDIF

   LinhaMsg(10)
   Telas(2,0,5,79,1,YCOREDIT,.F.)
   @ 03,02 SAY "Extrato de Conta Corrente por Item"
   @ 04,02 SAY "Perกodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,0,22,79,1,YCOREDIT,.F.,"ด Histขricos ร")
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec = YCOREDIT

   oCol:=TBCOLUMNNEW("Descrio",{|| DESCR})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Tipo",{|| IF(TIPOLAN=="D","DESPESA","RECEITA")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Total",{|| TRANSFORM(VALOR,"@E 99,999,999.99")})
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
            ImpExtrato()
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
*ณ Imprimir Extrato               ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpExtrato()
   LOCAL nReg:=RECNO()
   SET DEVI TO PRINT; SETPRC(0,0)
   SELECT (cArq1); DBGOTOP(); vSaldo:=BANCO->SALDO
   pg:=0; continua:=.T.
   CabRel("EXTRATO DE CONTA CORRENTE POR ITEM")
   @ PROW()+1,02 SAY "Titular:"
   @ PROW()  ,11 SAY BANCO->TITULAR
   @ PROW()  ,11 SAY BANCO->TITULAR
   @ PROW()+1,02 SAY "  Conta: "+SUBS(BANCO->CONTA,11)
   @ PROW()+1,02 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   @ PROW()+1,02 SAY REPLICATE("-",78)
   @ PROW()+1,02 SAY "DESCRICAO                        TIPO              TOTAL"
*                     XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX   XXXXXXX   99,999,999.99
*                     234567890123456789012345678901234567890123456789012345678901234567890123456789
*                             1         2         3         4         5         6         7
   @ PROW()+1,02 SAY REPLICATE("-",78); nCreditos:=nDebitos:=0.00
   WHILE continua.AND.!EOF()
      wtipo:=IF((cArq1)->TIPOLAN=="D","DESPESA","RECEITA")
      IF (cArq1)->TIPOLAN=="D"
         nDebitos += VALOR
      ELSE
         nCreditos += VALOR
      ENDIF
      @ PROW()+1,02 SAY DESCR    PICT "@!"
      @ PROW()  ,35 SAY wtipo
      @ PROW()  ,45 SAY VALOR    PICT "@E 999,999,999.99"
      DBSKIP()
      IF PROW()>=57.AND.!EOF()
         EJECT; CabRel("EXTRATO DE CONTA CORRENTE POR ITEM")
         @ PROW()+1,02 SAY REPLICATE("-",78)
         @ PROW()+1,02 SAY "DESCRICAO                        TIPO              TOTAL"
         @ PROW()+1,02 SAY REPLICATE("-",78)
      ENDIF
   ENDDO
   IF continua
      @ PROW()+1,02 SAY REPLICATE("-",78)
      @ PROW()+1,10 SAY "TOTAL DEBITOS  >> "
      @ PROW()  ,28 SAY nDebitos  PICT "@E 999,999,999.99"
      @ PROW()+1,10 SAY "TOTAL CREDITOS >> "
      @ PROW()  ,28 SAY nCreditos PICT "@E 999,999,999.99"
      @ 62,00 SAY "* * * Fim de Relatorio * * *"; EJECT
   ENDIF
   SET DEVICE TO SCREEN
   GO nReg
   RETURN NIL
