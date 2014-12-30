*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_252                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cancelamento de Pagamento de Fatura      ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 02/07/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NDOC" ,"C", 06,0})
AADD(aDbf,{"NF"   ,"C", 06,0})
AADD(aDbf,{"VLR"  ,"N", 12,2})
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
INDEX ON NDOC+NF TO (cArq1)

SELECT 5
IF NetUse("DBMOVBCO","CONTA")        /* Movimentacao Bancaria */
   SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBITEM","ITEM")            /* Itens de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBBANCO","BANCO")          /* Bancos */
   SET INDEX TO DBIBCO1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF Netuse("DBFORN","FORNECEDOR")      /* Fornecedores */
   SET INDEX TO DBIFOR1,DBIFOR2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAGA","PAGAR")           /* Faturas a Pagar */
   SET INDEX TO DBIPG3,DBIPG2,DBIPG1,DBIPG4,DBIPG5
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("AE252"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "51"

SET KEY -1 TO Mostra()
WHILE .T.
   Telas(19,3,21,23,1,YCOREDIT,.T.)
   SETCOLOR(YCOREDIT)
   nCodEmp:=0

   Mensagem("Informe Cขdigo do Fornecedor")
   @ 20,05 SAY "Fornecedor:" GET nCodEmp PICT "@K 9999" VALID;
     Pesquisa(2,1,STRZERO(nCodEmp,4),"Fornecedor Nฦo Cadastrado!")
   SETCURSOR(1); READ; SETCURSOR(0)
   
   Rest_Tela()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT FORNECEDOR
   FOR a=1 TO FCOUNT()
       Var  := "w"+FIELDNAME(a)
       &Var := FIELDGET(a)
   NEXT
   cCodEmp:=STRZERO(nCodEmp,4)

   Telas(4,6,21,73,1,YCOREDIT,.T.,"Cancelamento de Pagamento")
   @ 05,25 SAY "- "+TRANSFORM(FORNECEDOR->RAZAO,"@S45") COLOR YCORREALCE

   @ 05,08 SAY "Fornecedor:"     GET cCodEmp   PICT "9999"
   @ 06,08 SAY "  Endereo:"     GET wEndereco
   @ 07,08 SAY " Municกpio:"     GET wCidade
   @ 07,53 SAY "Estado:"         GET wUF                   
   @ 08,08 SAY "       CGC:"     GET wCGC      PICT "@R 99.999.999/9999-99"
   @ 08,45 SAY "Inscr.Estadual:" GET wINSC     PICT "@S11"
   @ 09,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   SELECT PAGAR; DBGOBOTTOM(); DBSKIP()
   FOR a=1 TO FCOUNT()
       Var  := "w"+FIELDNAME(a)
       &Var := FIELDGET(a)
   NEXT
   wValor:=0.00
   EditaFat(); CLEAR GETS

   /* Alimentar Arquivo temporario */
   PAGAR->(DBSEEK(cCodEmp))
   WHILE PAGAR->COD_CF==cCodEmp.AND.!PAGAR->(EOF())
      IF PAGAR->DTPAG#CTOD("")    /* Somente faturas pagas */
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NDOC WITH PAGAR->NDOC,;
                 (cArq1)->NF   WITH PAGAR->NF,;
                 (cArq1)->VLR  WITH PAGAR->VLR_APAG
      ENDIF
      PAGAR->(DBSKIP())
   ENDDO

   WHILE .T.
      Novo:=Deleta:=lAchou:=l_f2:=.F.; cNFat:=0; cNF:=SPACE(6)

      SETCOLOR(YCOREDIT)
      Mensagem("Informe Nฃmero da Fatura e Nota Fiscal")
      @ 10,08 SAY " Nง Fatura:" GET cNFat PICT "999999" WHEN TeclaFuncao(.T.) VALID MFat().AND.(lAchou:=ChkFatura())
      @ 10,30 SAY "Nota Fiscal:"GET cNF   PICT "999999" VALID LASTKEY()=K_UP.OR.Pesquisa(1,1,cCodEmp+cNFat+cNF,"Nota nฦo pertence a esta Fatura!")
      SETCURSOR(1); READ; SETCURSOR(0)
   
      IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

      SELECT PAGAR
      FOR a=1 TO FCOUNT()
          Var  := "w"+FIELDNAME(a)
          &Var := FIELDGET(a)
      NEXT
      wNDoc:=cNFat; wNF:=cNF
      IF lAchou
         TDescr(4,1,12,26,wItem_cx,"DESCR")
      ENDIF
      
      EditaFat(); GetList:={}

      IF EMPTY(wDtPag)
         Aviso("Fatura est  em Aberto...")
      ELSE
         IF Confirma("Confirma Cancelamento ? ")
            Aguarde("Gravando Informaไes")
            /* Estornar Lancamento no Movimento Bancario */
            IF CONTA->(DBSEEK(PAGAR->CONTA+PAGAR->NDOC))
               WHILE !CONTA->(NetApp()); ENDDO
               REPLACE CONTA->CONTA   WITH PAGAR->CONTA,;
                       CONTA->NUMDOC  WITH PAGAR->NDOC,;
                       CONTA->DATMOV  WITH cDtSys,;
                       CONTA->DATDOC  WITH PAGAR->DATDOC,;
                       CONTA->ITEM_CX WITH PAGAR->ITEM_CX,;
                       CONTA->DSCLAN  WITH "ESTORNO DE PAGAMENTO",;
                       CONTA->FAVOR   WITH PAGAR->FAVOR,;
                       CONTA->TIPOLAN WITH "C",;
                       CONTA->VALOR   WITH PAGAR->VALPG
               CONTA->(DBUNLOCK()); CONTA->(DBCOMMIT())

               /* Repor o Saldo Bancario */
               BANCO->(DBSEEK(PAGAR->CONTA))
               WHILE !BANCO->(NetLReg()); ENDDO
               REPLACE BANCO->SALDO WITH BANCO->SALDO + PAGAR->VALPG
               BANCO->(DBUNLOCK()); BANCO->(DBCOMMIT())
            ENDIF

            /* Zerar os Valores Pagos */
            WHILE !PAGAR->(NetLReg()); ENDDO
            REPLACE PAGAR->DTPAG   WITH CTOD(""),;
                    PAGAR->DESC    WITH 0.00,;
                    PAGAR->JURD    WITH 0.00,;
                    PAGAR->VLRJUR  WITH 0.00,;
                    PAGAR->VLRDESC WITH 0.00,;
                    PAGAR->VLR_PAG WITH 0.00,;
                    PAGAR->VALPG   WITH 0.00,;
                    PAGAR->OBS     WITH SPACE(50),;
                    PAGAR->FORMA   WITH " "
            PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())

            /* Eliminar Fatura do Arquivo Temporario */
            (cArq1)->(DBDELETE())
            Aguarde()
         ENDIF
      ENDIF
      SELECT PAGAR; DBGOBOTTOM(); DBSKIP()
      FOR a=1 TO FCOUNT()
          Var  := "w"+FIELDNAME(a)
          &Var := FIELDGET(a)
      NEXT
      EditaFat(); CLEAR GETS; SCROLL(12,26,12,72)
   ENDDO
   (cArq1)->(__DBZAP())     /* Limpar o arquivo temporario */
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
