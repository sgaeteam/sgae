*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_251                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Baixa de Pagamento                       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
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

SELECT 5
IF NetUse("DBMOVBCO","CONTA")        /* Movimentacao Bancaria */
   SET INDEX TO DBIMOVB1,DBIMOVB2,DBIMOVB3,DBIMOVB4,DBIMOVB5
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBITEM","ITEM")           /* Itens de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBBANCO","BANCO")         /* Cadastro de Bancos */
   SET INDEX TO DBIBCO1
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOTOP()
IF EOF()
   lBancoVazio:=.T.
ELSE
   lBancoVazio:=.F.
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

cPrg:="AE251"; ProgName(cPrg); LinhaMsg(2)
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

   Telas(4,6,21,73,1,YCOREDIT,.T.,"Baixa de Pagamento")
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
   EditaFat(); CLEAR GETS

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
      Novo:=Deleta:=lAchou:=l_f2:=.F.; cNFat:=0; cNF:=SPACE(6)

      SETCOLOR(YCOREDIT)
      Mensagem("Informe Nฃmero da Fatura e Nota Fiscal")
      @ 10,08 SAY " Nง Fatura:" GET cNFat PICT "999999" WHEN TeclaFuncao(.T.) VALID MFat2().AND.(lAchou:=ChkFatura())
      @ 10,30 SAY "Nota Fiscal:"GET cNF   PICT "999999" VALID LASTKEY()=K_UP.OR.Pesquisa(1,1,cCodEmp+cNFat+cNF,"Nota nฦo pertence a esta Fatura!")
      SETCURSOR(1); READ; SETCURSOR(0)
   
      IF LASTKEY()==K_ESC; SCROLL(12,26,12,72); Rest_Tela(); EXIT; ENDIF

      SELECT PAGAR
      FOR a=1 TO FCOUNT()
          Var  := "w"+FIELDNAME(a)
          &Var := FIELDGET(a)
      NEXT
      wNDoc:=cNFat; wNF:=cNF
      IF lAchou
         TDescr(4,1,12,26,wItem_cx,"DESCR")
      ENDIF
      EditaFat()

      IF !EMPTY(wDtPag)
         CLEAR TYPEAHEAD
         Aviso("Fatura com Pagamento Efetuado...")
      ELSE
         IF EOF()
            SETCURSOR(1); READ; SETCURSOR(0)
            MSG  := "Confirma os Dados ? "
            Novo := .T.
         ELSE
            DeleAltera()
            IF LASTKEY()==K_ENTER
               SETCURSOR(1); READ; SETCURSOR(0)
               MSG    := "Confirma Pagamento ? "
               Altera := .T.
            ELSEIF LASTKEY()==K_DEL
               CLEAR GETS
               MSG    := "Confirma Cancelamento ? "
               Deleta := .T.
            ENDIF
         ENDIF
      
         IF LASTKEY() <> K_ESC
            IF Confirma(msg)
               Aguarde("Gravando Informaไes")
               IF Deleta
                  WHILE !NetLReg(); ENDDO
                  PAGAR->(DBDELETE())
               ELSE
                  IF Novo
                     WHILE !PAGAR->(NetApp()); ENDDO
                  ENDIF
                  WHILE !NetLReg(); ENDDO
                  FOR a=1 TO FCOUNT()
                      Var := "w"+FIELDNAME(a)
                      FIELDPUT(a,&Var)
                  NEXT
                  REPLACE PAGAR->COD_CF WITH cCodEmp
                  IF wForma=="D"
                     REPLACE PAGAR->CONTA WITH "EM DINHEIRO"
                  ENDIF
               ENDIF
               Aguarde()
               DBUNLOCKALL(); DBCOMMITALL()
               IF wForma=="C".OR.wForma=="A"
                  DigCH()
               ENDIF
            ENDIF
         ELSE
            IF LEN(Telas)==4; Rest_Tela(); ENDIF
            CLEAR GETS
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
*ีออออออออออออออออออออออออออออออออธ
*ณ Informar Dados da Fatura       ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE EditaFat()
   SETCOLOR(YCOREDIT)
   @ 10,52 SAY "Emissฦo:"           GET wDtEmiss  PICT "@D"     WHEN !lAchou VALID !EMPTY(wDtEmiss).OR.LASTKEY()==K_UP
   @ 11,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   @ 12,08 SAY "      Item:"        GET wItem_cx  PICT "9999"   WHEN !lAchou VALID (LASTKEY()==K_UP).OR.;
     !EMPTY(wItem_cx).AND.TItem(wItem_cx).AND.TDescr(4,1,12,26,wItem_cx,"DESCR")
   @ 13,08 SAY "Vencimento:"        GET wDtaPag   PICT "@D"     WHEN .F.
   @ 13,32 SAY "Forma Pgto:"        GET wForma    PICT "!"      WHEN HTela(6) VALID VTela(6).AND.TestaBanco(wForma,lBancoVazio)
   @ 13,47 SAY "Dt.Pagamento:"      GET wDtPag    PICT "@D"     VALID LASTKEY()==K_UP.OR.!EMPTY(wDtPag).AND.CalcDesc().AND.CalcJur()
   @ 14,08 SAY "Valor Liquido a Pagar..........................>" GET wVlr_aPag PICT "@E 999,999,999.99" VALID LASTKEY()==K_UP.OR.!EMPTY(wVlr_aPag)
   @ 15,08 SAY "Desconto.............................        % >"
   @ 15,46 GET wDesc                PICT "@E 999.99"         VALID CalcDesc()
   @ 15,57 GET wVlrDesc             PICT "@E 999,999,999.99" WHEN EMPTY(wDesc) VALID LASTKEY()==K_UP.OR.TDesc().AND.Let(wVlr_Pag:=wVlr_aPag-wVlrDesc) COLOR YCORREALCE
   @ 15,71 SAY "-"
   @ 16,08 SAY "Valor Lกquido..................................>" GET wVlr_Pag PICT "@E 999,999,999.99" WHEN .F.
   @ 17,08 SAY "Juros Di rios........................        % >"
   @ 17,46 GET wJurd                PICT "@E 999.99"         VALID CalcJur()
   @ 17,57 GET wVlrjur              PICT "@E 999,999,999.99" WHEN .F. COLOR YCORREALCE
   @ 17,71 SAY "+"
   @ 18,08 SAY "VALOR TOTAL A PAGAR............................>" GET wValPg PICT "@E 999,999,999.99" WHEN .F.
   @ 19,06 SAY "ร"+REPLI("ฤ",66)+"ด"
   @ 20,08 SAY "Observaฦo:"        GET wObs      PICT "@!"
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Testar uso do Cheque           ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TestaBanco(pForma,pLog)
   IF pForma=="C".OR.pForma=="A".AND.pLog
      Aviso("Voc precisa cadastrar um banco primeiro...")
      wForma:=SPACE(1); HTela(6)
      RETURN .F.
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Calcular Valor do Desconto     ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION CalcDesc()
   wVlrDesc := (wVlr_aPag*wDesc)/100
   wVlr_Pag   := wVlr_aPag-wVlrDesc
   wValPg     := wVlr_aPag-wVlrDesc+wVlrJur
   @ 15,57 SAY wVlrDesc   PICT "@E 999,999,999.99" COLOR YCORREALCE
   @ 16,57 SAY wVlr_Pag   PICT "@E 999,999,999.99" COLOR YCOREDIT
   @ 18,57 SAY wValPg     PICT "@E 999,999,999.99" COLOR YCOREDIT
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Calcular % de Desconto         ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE TDesc()
   IF EMPTY(wDesc)
      wDesc := (wVlrDesc/wVlr_aPag)*100
      @ 15,46 SAY wDesc PICT "@E 999.99" COLOR YCOREDIT
      CalcDesc()
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Calcular Juros Compostos       ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CalcJur()
   nAtraso := wDtPag-wDtaPag
   IF nAtraso>0
      wVlrJur := ((((wJurd/100)+1)^IF(nAtraso<0,0,nAtraso))*(wVlr_aPag-wVlrDesc))-wVlr_Pag
   ELSE
      wVlrJur := 0.00
   ENDIF
   wValPg := wVlr_aPag-wVlrDesc+wVlrJur
   @ 17,57 SAY wVlrjur PICT "@E 999,999,999.99" COLOR YCORREALCE
   @ 18,57 SAY wValPg  PICT "@E 999,999,999.99" COLOR YCOREDIT
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Digitacao do Cheque            ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION Digch()
   wConta:=SPACE(23); wNumDoc:=SPACE(6); wDscLan:=SPACE(40)
   wVlrCheq:=wValPg; wVlrDinh:=0.00; wDatDoc:=wDtPag
   WHILE .T.
      SETCOLOR(YCORMENU)
      Telas(12,3,IF(wForma="C",19,20),60,1,YCORMENU,.T.,"Digitaฦo Documento")
      TDescr(4,1,(nPos:=ROW()+IF(wForma="C",5,6)),23,wItem_cx,"DESCR",,,YCORMENU)
      IF wForma=="C"; wVlrCheque:=wValPg; ENDIF

      DEVPOS(13,05)
      @ ROW()  ,05 SAY "       Conta:" GET wConta PICT "@R 999/!!!!!!!/!!!!!!!!!!!!!" WHEN TeclaFuncao(.T.);
        VALID !EMPTY(wConta).AND.TConta(wConta)
      @ ROW()+1,05 SAY "   Cheque Nง:" GET wNumDoc  PICT "999999" VALID ChkMov(wForma)
      @ ROW()+1,05 SAY "Valor Cheque:" GET wVlrCheq PICT "@E 999,999,999.99" VALID TForma(wForma)
      IF wForma=="A"
         @ ROW()+1,05 SAY "Vlr.Dinheiro:" GET wVlrDinh PICT "@E 999,999,999.99"
      ENDIF
      @ ROW()+1,05 SAY "Dt.Documento:" GET wDatDoc  PICT "@D"   VALID !EMPTY(wDatDoc)
      @ ROW()+1,05 SAY "Item Consumo:" GET wItem_cx PICT "9999" WHEN .F.
      @ ROW()+1,05 SAY "Pagto Ref. a:" GET wDscLan  PICT "@!"
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()==K_ESC
         Aviso("Informaไes Obrigatขrias...",,3); Rest_Tela(); LOOP
      ENDIF
      // SCROLL(nPos,23,nPos,60)
      IF Confirma("Confirma Pagamento com este Documento ?")
         Aguarde("Gravando Informaไes")
         WHILE !CONTA->(NetApp()); ENDDO
         REPLACE CONTA->CONTA   WITH wConta,;
                 CONTA->NUMDOC  WITH wNumDoc,;
                 CONTA->DATMOV  WITH cDtSys,;
                 CONTA->DATDOC  WITH wDatDoc,;
                 CONTA->ITEM_CX WITH wItem_cx,;
                 CONTA->DSCLAN  WITH wDscLan,;
                 CONTA->FAVOR   WITH FORNECEDOR->RAZAO,;
                 CONTA->TIPOLAN WITH "D",;
                 CONTA->VALOR   WITH wVlrCheq,;
                 CONTA->VALORDH WITH wVlrDinh
         CONTA->(DBUNLOCK()); CONTA->(DBCOMMIT())

         /* Abater no saldo da Conta */
         WHILE !BANCO->(NetLReg()); ENDDO
         REPLACE BANCO->SALDO WITH BANCO->SALDO - wVlrCheq
         BANCO->(DBUNLOCK()); BANCO->(DBCOMMITALL())
         Aguarde(); Rest_Tela(); EXIT
      ENDIF
      Rest_Tela()
   ENDDO
   SETCOLOR(YCOREDIT)
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Testar forma de Pagamento      ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TForma(pForma)
   IF pForma=="A"
      wVlrDinh := wValPg - wVlrCheq
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออออธ
*ณ Modificar Numero da Fatura     ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE MFat2()
   IF VALTYPE(cNFat)=="N"
      cNFat:=STRZERO(cNFat,6)
   ENDIF
   RETURN .T.
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Conta   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TConta(pConta)
   IF (lRet:=DBSEEK(pConta))
      Aviso("Conta j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
