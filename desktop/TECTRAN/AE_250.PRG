*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_250                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Lancamento de Faturas a Pagar            ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 26/06/1995                               ณ
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

SELECT 3
IF NetUse("DBITEM","ITEM")           /* Cadastro de Itens de Fluxo de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOTOP()
IF EOF()
   Aviso("Voc precisa cadastrar Itens para utilizar esta rotina...")
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF Netuse("DBFORN","FORNECEDOR")      /* Fornecedores */
   SET INDEX TO DBIFOR1,DBIFOR2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAGA","PAGAR")           /* Arquivo de Contas a Pagar */
   SET INDEX TO DBIPG3,DBIPG1,DBIPG2,DBIPG4,DBIPG5
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("AE250"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "50"

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

   Telas(4,6,17,73,1,YCOREDIT,.T.,"Lanamento de Faturas a Pagar")
   @ 05,25 SAY "- "+TRANSFORM(FORNECEDOR->RAZAO,"@S45") COLOR YCORREALCE

   @ 05,08 SAY "Fornecedor:"     GET cCodEmp   PICT "9999"
   @ 06,08 SAY "  Endereo:"     GET wEndereco
   @ 07,08 SAY " Municกpio:"     GET wCidade
   @ 07,53 SAY "Estado:"         GET wUF                   
   @ 08,08 SAY "       CGC:"     GET wCGC      PICT "@R 99.999.999/9999-99"
   @ 08,45 SAY "Inscr.Estadual:" GET wINSC     PICT "@S11"
   @ 09,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   wNDoc:=SPACE(6);wDtEmiss:=wDtaPag:=CTOD("")
   wItem_cx:=SPACE(4);wObs:=SPACE(50);wVlr_aPag:=0.00
   Edita_Fat(); CLEAR GETS

   /* Alimentar Arquivo temporario */
   PAGAR->(DBSEEK(cCodEmp))
   WHILE PAGAR->COD_CF==cCodEmp.AND.!PAGAR->(EOF())
      IF PAGAR->DTPAG==CTOD("")    /* Somente faturas em aberto */
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NDOC WITH PAGAR->NDOC,;
                 (cArq1)->NF   WITH PAGAR->NF,;
                 (cArq1)->VLR  WITH PAGAR->VLR_APAG
      ENDIF
      PAGAR->(DBSKIP())
   ENDDO

   WHILE .T.
      Novo:=Deleta:=lAchou:=l_f2:=.F.
      cNFat:=0; cNF:=SPACE(6)

      SETCOLOR(YCOREDIT)
      Mensagem("Informe Nฃmero da Fatura e Nota Fiscal")
      @ 10,08 SAY " Nง Fatura:" GET cNFat PICT "999999" WHEN TeclaFuncao(.T.);
        VALID !EMPTY(cNFat).AND.MFat().AND.TF2()
      @ 10,30 SAY "Nota Fiscal:"GET cNF   PICT "999999"
      SETCURSOR(1); READ; SETCURSOR(0)
   
      IF LASTKEY()==K_ESC.OR.EMPTY(cNFat); Rest_Tela(); EXIT; ENDIF

      SELECT PAGAR; DBSETORDER(1)
      lAchou:=DBSEEK(cCodEmp+cNFat+cNF)
      IF !NetLReg(); LOOP; ENDIF
      FOR a=1 TO FCOUNT()
          Var  := "w"+FIELDNAME(a)
          &Var := FIELDGET(a)
      NEXT
      wNDoc:=cNFat; wNF:=cNF

      SCROLL(12,25,12,72)
      IF lAchou
         TDescr(3,1,12,25,wItem_cx,"DESCR")
      ENDIF

      Edita_Fat()

      IF EOF()
         SETCURSOR(1); READ; SETCURSOR(0)
         MSG  := "Confirma os Dados ? "
         Novo := .T.
      ELSE
         DeleAltera()
         IF LASTKEY()==K_ENTER
            SETCURSOR(1); READ; SETCURSOR(0)
            MSG    := "Confirma Alteraฦo ? "
            Altera := .T.
         ELSEIF LASTKEY()==K_DEL
            CLEAR GETS
            MSG    := "Confirma a Exclusฦo ? "
            Deleta := .T.
         ENDIF
      ENDIF
      
      IF LASTKEY() <> K_ESC
         IF Confirma(MSG)
            Aguarde("Gravando Informaไes")
            IF Deleta
               DBDELETE()
            ELSE
               IF Novo
                  WHILE !NetApp(); ENDDO
               ENDIF
               FOR a=1 TO FCOUNT()
                   Var := "w"+FIELDNAME(a)
                   FIELDPUT(a,&Var)
               NEXT
               REPLACE COD_CF WITH cCodEmp
            ENDIF
            Aguarde()
            UNLOCK; DBCOMMITALL()
         ENDIF
      ELSE
         CLEAR GETS
      ENDIF
      UNLOCK ALL              // Libera o registro gravado
      wNDoc:=SPACE(6);wDtEmiss:=wDtaPag:=CTOD("")
      wItem_cx:=SPACE(4);wObs:=SPACE(50);wVlr_aPag:=0.00
      Edita_Fat(); CLEAR GETS
      SCROLL(12,25,12,72)
   ENDDO
ENDDO
SETKEY(K_F2,NIL)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Modificar Numero da Fatura     ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE MFat()
   IF VALTYPE(cNFat)=="N"
      cNFat:=STRZERO(cNFat,6)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Informar Dados da Fatura       ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Edita_Fat()
   SETCOLOR(YCOREDIT)
   @ 10,52 SAY "Emissฦo:"           GET wDtEmiss  PICT "@D"     VALID !EMPTY(wDtEmiss).OR.LASTKEY()==K_UP
   @ 11,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   @ 12,08 SAY "      Item:"        GET wItem_cx  PICT "9999"   VALID (LASTKEY()==K_UP).OR.;
     !EMPTY(wItem_cx).AND.TItem(wItem_cx).AND.TDescr(3,1,12,25,wItem_cx,"DESCR")
   @ 13,08 SAY "Vencimento:"        GET wDtaPag   PICT "@D"     VALID !EMPTY(wDtaPag).OR.LASTKEY()==K_UP
   @ 14,08 SAY "Valor Liquido a Pagar..........................>" GET wVlr_aPag PICT "@E 999,999,999.99" VALID !EMPTY(wVlr_aPag).OR.LASTKEY()==K_UP
   @ 15,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   @ 16,08 SAY "Observaฦo:"        GET wObs      PICT "@!"
   RETURN
