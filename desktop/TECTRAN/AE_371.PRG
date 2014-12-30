*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_371                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Extrato de Conta Corrente                ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 16/11/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NUMDOC"  ,"C", 06,0})
AADD(aDbf,{"DATMOV"  ,"D", 08,0})
AADD(aDbf,{"DATDOC"  ,"D", 08,0})
AADD(aDbf,{"DSCLAN"  ,"C", 50,0})
AADD(aDbf,{"FAVOR"   ,"C", 40,0})
AADD(aDbf,{"TIPOLAN" ,"C", 01,0})
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
INDEX ON DESCEND(DTOS(datdoc)) TO (cArq1)

SELECT 2
IF NetUse("DBMOVBCO","MOVBANCO")    /* Cadastro de Movimentacao Bancaria */
   SET INDEX TO DBIMOVB5,DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4
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

ProgName("AE371"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "71"
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
      Aviso("Usu rio nฦo Autorizado...",,3)
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
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NUMDOC  WITH MOVBANCO->NUMDOC,;
                    (cArq1)->DATMOV  WITH MOVBANCO->DATMOV,;
                    (cArq1)->FAVOR   WITH MOVBANCO->FAVOR,;
                    (cArq1)->DATDOC  WITH MOVBANCO->DATDOC,;
                    (cArq1)->DSCLAN  WITH MOVBANCO->DSCLAN,;
                    (cArq1)->TIPOLAN WITH MOVBANCO->TIPOLAN,;
                    (cArq1)->VALOR   WITH MOVBANCO->VALOR,;
                    (cArq1)->SALDO   WITH nSaldo
         ENDIF
         IF MOVBANCO->DATMOV<=DATE()
            IF MOVBANCO->TIPOLAN=="D"
               nSaldo += MOVBANCO->VALOR
            ELSEIF MOVBANCO->TIPOLAN=="C"
               nSaldo -= MOVBANCO->VALOR
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
      Aviso("Nฦo houve movimentaฦo neste perกodo..."); RETURN .F.
   ENDIF

   LinhaMsg(10)
   Telas(2,0,5,79,1,YCOREDIT,.F.)
   @ 03,02 SAY "Extrato de Conta Corrente"
   @ 04,02 SAY "Perกodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,0,22,79,1,YCOREDIT,.F.,"ด Lanamentos ร")
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec = YCOREDIT

   oCol:=TBCOLUMNNEW("Data",{|| DATMOV})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Doc.",{|| NUMDOC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Favorecido",{|| TRANSFORM(FAVOR,"@S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("C/D",{|| TIPOLAN})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR,"@E 9,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Saldo",{|| TRANSFORM(SALDO,"@E 99,999.99") })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Histขrico",{|| DSCLAN})
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
      ELSEIF ( tecla == K_F9 )
         IF ChkImpr()
            cAviso := MsgImp()
            ImpExtrato()
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
  SETCOLOR(corant); Rest_Tela(); Rest_Tela()
  RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Kardex                ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpExtrato()
   LOCAL nReg:=RECNO()
   Gera_TXT("EXTRATO.TXT"); SETPRC(0,0)
   SELECT (cArq1); DBGOTOP(); vSaldo:=SALDO
   pg:=0; continua:=.T.
   CabRel("EXTRATO DE CONTA CORRENTE")
   @ PROW()+1,02 SAY "Titular:"
   @ PROW()  ,11 SAY BANCO->TITULAR
   @ PROW()+1,02 SAY "  Conta: "+SUBS(BANCO->CONTA,11)
   @ PROW()+1,02 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Compr_On()
   @ PROW()+1,02 SAY REPLICATE("-",124)
   @ PROW()+1,02 SAY "DATA       DOC.   HISTORICO                                FAVORECIDO                              C/D     VALOR      SALDO"
*                     99/99/9999 999999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx X   9,999.99  99,999.99
*                     23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                             1         2         3         4         5         6         7         8         9        10        11        12        13
   @ PROW()+1,02 SAY REPLICATE("-",124)
   WHILE continua.AND.!EOF()
      @ PROW()+1,02 SAY DATMOV   PICT "@D"
      @ PROW()  ,13 SAY NUMDOC   PICT "999999"
      @ PROW()  ,20 SAY DSCLAN   PICT "@!"
      @ PROW()  ,61 SAY FAVOR    PICT "@!"
      @ PROW() ,102 SAY TIPOLAN  PICT "!"
      @ PROW() ,106 SAY VALOR    PICT "@E 9,999.99"
      @ PROW() ,116 SAY SALDO    PICT "@E 99,999.99"
      DBSKIP()
      IF PROW()>=57.AND.!EOF()
         EJECT; CabRel("EXTRATO DE CONTA CORRENTE")
         @ PROW()+1,02 SAY REPLICATE("-",124)
         @ PROW()+1,02 SAY "DATA       DOC.   HISTORICO                                FAVORECIDO                              C/D     VALOR      SALDO"
         @ PROW()+1,02 SAY REPLICATE("-",124)
      ENDIF
   ENDDO
   IF continua
      @ PROW()+1,02 SAY REPLICATE("-",124)
      @ PROW()+1,93 SAY "Saldo Atual >> "
      @ PROW() ,116 SAY vSaldo PICT "@E 99,999.99"
   ENDIF
   Compr_Off()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp extrato.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE EXTRATO.TXT
   GO nReg
   RETURN NIL
