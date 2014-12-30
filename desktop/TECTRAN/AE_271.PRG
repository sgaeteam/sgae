*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_271                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Movimento de Caixa                       ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ³
*³ DATA CRIACAO   : 02/04/1998                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

PROCEDURE AE_271(pOp)
DBCLOSEALL()
aDbf := {}
AADD(aDbf,{"NLAN"     ,"C",   12,0}) /* Numero do Lancamento     */
AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item de caixa            */
AADD(aDbf,{"CONTA"    ,"C",   07,0}) /* Conta Contabil           */
AADD(aDbf,{"OK"       ,"C",   02,0}) /* Libercao                 */
AADD(aDbf,{"NF"       ,"C",   08,0}) /* NF                       */
AADD(aDbf,{"DOC"      ,"C",   10,0}) /* Documento                */
AADD(aDbf,{"BANCO"    ,"C",   15,0}) /* Nome do Banco            */
AADD(aDbf,{"SERV"     ,"C",   30,0}) /* descricao do servico     */
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula                */
AADD(aDbf,{"HIST"     ,"C",   50,0}) /* Hist¢rico                */
AADD(aDbf,{"TIPO"     ,"C",   01,0}) /* Cr‚dito ou D‚bito        */
AADD(aDbf,{"DTMOV"    ,"D",   08,0}) /* Data do Movimento        */
AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Documento        */
AADD(aDbf,{"VALOR"    ,"N",   09,2}) /* Valor                    */
AADD(aDbf,{"VLR_D"    ,"N",   09,2}) /* Valor em dinheiro        */
AADD(aDbf,{"VLR_C"    ,"N",   09,2}) /* Valor em cheque          */
AADD(aDbf,{"USER"     ,"C",   30,0}) /* Operador                 */
AADD(aDbf,{"SALDO"    ,"N",   08,2}) /* Valor                    */
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
INDEX ON DTOS(dtmov) TO (cArq1)

SELECT 4
IF NetUse("DBITEM","ITEM")            /* Itens de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 12
IF NetUse("DBPLANO","PLANO")          /* Plano de Contas */
   SET INDEX TO DBIPLAN1,DBIPLAN2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF !NetUse("DBPARM")                  /* Parametros */
   DelDbfNtx(); RETURN
ENDIF
* nNlan := DBPARM->NLAN

SELECT 6
IF NetUse("DBSD","SALDOS")            /* Saldos */
   SET INDEX TO DBISD1
   DBGOBOTTOM()
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")             /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNOS")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")            /* Pagamentos de alunos */
   SET INDEX TO DBIPAG3,DBIPAG1,DBIPAG2,DBIPAG4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE271"; ProgName(cPrg); LinhaMsg(2)
SET KEY -1 TO Mostra()
wPerI:=wPerF:=cDtSys;nSaldAnt := 0.00
WHILE .T.
   nTotEnt:=nTotSai:=nTotCard:=nTotCHv:=nTotEsp:=nTotCHp:=nSaldo:=0.00
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Per¡odo")
   Telas(18,5,20,39,1,YCOREDIT,.T.,"Movimenta‡Æo")
   @ 19,06 SAY " Per¡odo:" GET wPerI PICT "@D" VALID !EMPTY(wPerI)
   @ 19,25 SAY "a "        GET wPerF PICT "@D" VALID LASTKEY()==K_UP.OR.wPerF>=wPerI
   SETCURSOR(1); READ; SETCURSOR(0)
   Rest_Tela()
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   Mensagem()

   IF !CAIXA->(DBSEEK(DTOS(wPerI),.T.))
      IF CAIXA->DTMOV > wPerF
         Aguarde()
         Aviso("NÆo houve movimento neste per¡odo",,3)
      ENDIF
   ENDIF

   /* Carregar Arq. Temporario */
   IF pOp=2
      nSaldAnt := 0.00
      WHILE CAIXA->DTMOV>=wPerI .AND. CAIXA->DTMOV<=wPerF
         IF CAIXA->USER == cUsuario
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->MATRIC  WITH CAIXA->MATRIC  ,;
                    (cArq1)->OK      WITH CAIXA->OK      ,;
                    (cArq1)->NLAN    WITH CAIXA->NLAN    ,;
                    (cArq1)->ITEM_CX WITH CAIXA->ITEM_CX ,;
                    (cArq1)->CONTA   WITH CAIXA->CONTA   ,;
                    (cArq1)->DOC     WITH LTRIM(CAIXA->DOC),;
                    (cArq1)->HIST    WITH CAIXA->HIST    ,;
                    (cArq1)->NF      WITH CAIXA->NF      ,;
                    (cArq1)->TIPO    WITH CAIXA->TIPO    ,;
                    (cArq1)->DTMOV   WITH CAIXA->DTMOV   ,;
                    (cArq1)->DATA    WITH CAIXA->DATA    ,;
                    (cArq1)->VALOR   WITH CAIXA->VALOR   ,;
                    (cArq1)->VLR_D   WITH CAIXA->VLR_D   ,;
                    (cArq1)->VLR_C   WITH CAIXA->VLR_C   ,;
                    (cArq1)->SERV    WITH CAIXA->SERV    ,;
                    (cArq1)->BANCO   WITH CAIXA->BANCO   ,;
                    (cArq1)->USER    WITH CAIXA->USER
            
            IF (cArq1)->NF#"ESTORNO"
               IF (cArq1)->TIPO=="D"
                  nTotSai += (cArq1)->VALOR
               ELSE
                  IF SUBS((cArq1)->DOC,1,1)=="A"
                     /* Cartao */
                     nTotCard += (cArq1)->VLR_C
                  ELSE
                     IF SUBS((cArq1)->DOC,1,2)=="NP"
                        /* Nota Promissoria */
                        nTotProm += (cArq1)->VLR_C
                     ENDIF
                     nTotEsp += (cArq1)->VLR_D
                     nTotCHp  += (cArq1)->VLR_C
                  ENDIF
               ENDIF 
            ENDIF
         ENDIF
         CAIXA->(DBSKIP())
      ENDDO
   ELSE
      /* Carregar Arq. Temporario
         Localizar o saldo do primeiro dia do periodo */
      IF !SALDOS->(DBSEEK(DTOS(wPerI)))
         Aviso("Caixa do dia "+DTOC(wPerI-1)+" ainda nÆo foi fechado!",,2)
      ENDIF
      nSaldAnt := SALDOS->SALDO
      Aguarde("Lendo o movimento...")
      IF !CAIXA->(DBSEEK(DTOS(wPerI),.T.))
         IF CAIXA->DTMOV > wPerF
            Aguarde()
            Aviso("NÆo houve movimento neste per¡odo",,3)
            SALDOS->(DBGOTOP())
            WHILE !SALDOS->(EOF())
               IF SALDOS->DATA <=wPerF
                  WHILE SALDOS->DATA <=wPerF .AND. !SALDOS->(EOF())
                     nSaldAnt := SALDOS->SALDO
                     SALDOS->(DBSKIP())
                  ENDDO
                  EXIT
               ENDIF
               IF SALDOS->(EOF()); EXIT; ENDIF
               SALDOS->(DBSKIP())
            ENDDO
         ENDIF
      ELSE
         /* Procura o saldo anterior */
         IF SALDOS->(DBSEEK(DTOS(wPerI),.T.))
            nSaldAnt := SALDOS->SALDO
         ELSE
            SALDOS->(DBGOTOP())
            WHILE !SALDOS->(EOF())
               IF SALDOS->DATA <=wPerF
                  WHILE SALDOS->DATA <=wPerF .AND. !SALDOS->(EOF())
                     nSaldAnt := SALDOS->SALDO
                     SALDOS->(DBSKIP())
                  ENDDO
                  EXIT
               ENDIF
               IF SALDOS->(EOF()); EXIT; ENDIF
               SALDOS->(DBSKIP())
            ENDDO
         ENDIF
      ENDIF

      WHILE CAIXA->DTMOV>=wPerI .AND. CAIXA->DTMOV<=wPerF
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->MATRIC  WITH CAIXA->MATRIC  ,;
                 (cArq1)->OK      WITH CAIXA->OK      ,;
                 (cArq1)->NLAN    WITH CAIXA->NLAN    ,;
                 (cArq1)->ITEM_CX WITH CAIXA->ITEM_CX ,;
                 (cArq1)->CONTA   WITH CAIXA->CONTA   ,;
                 (cArq1)->DOC     WITH LTRIM(CAIXA->DOC),;
                 (cArq1)->HIST    WITH CAIXA->HIST    ,;
                 (cArq1)->NF      WITH CAIXA->NF      ,;
                 (cArq1)->TIPO    WITH CAIXA->TIPO    ,;
                 (cArq1)->DTMOV   WITH CAIXA->DTMOV   ,;
                 (cArq1)->DATA    WITH CAIXA->DATA    ,;
                 (cArq1)->VALOR   WITH CAIXA->VALOR   ,;
                 (cArq1)->VLR_D   WITH CAIXA->VLR_D   ,;
                 (cArq1)->VLR_C   WITH CAIXA->VLR_C   ,;
                 (cArq1)->SERV    WITH CAIXA->SERV    ,;
                 (cArq1)->BANCO   WITH CAIXA->BANCO   ,;
                 (cArq1)->USER    WITH CAIXA->USER
         IF (cArq1)->NF # "ESTORNO"
            IF (cArq1)->TIPO=="D"
               nTotSai += (cArq1)->VALOR
               nSaldo  -= (cArq1)->VALOR
            ELSE
               IF SUBS((cArq1)->DOC,1,1)=="A"
                  /* Cartao */
                  nTotCard += (cArq1)->VLR_C
               ELSE
                  // Cheques
                  IF (cArq1)->DATA>cDtSys // Pre-datado
                     nTotCHp += (cArq1)->VLR_C
                  ELSE
                     nTotCHv += (cArq1)->VLR_C
                     nSaldo  += (cArq1)->VLR_C + (cArq1)->VLR_D
                  ENDIF
               ENDIF
               nTotEsp += (cArq1)->VLR_D
            ENDIF
         ENDIF  
         CAIXA->(DBSKIP())
      ENDDO
   ENDIF
   nTotEnt := nTotEsp + nTotCHv + nTotCHp

   // Traz o saldo da leitura anterior
   IF nSaldAnt > 0.00
      nSaldo += nSaldAnt
   ELSEIF nSaldAnt < 0.00
      nSaldo -= nSaldAnt
   ENDIF

   Aguarde()
   LancaMov(pOp)
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
ENDDO
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Browse de Lan‡amentos          ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION LancaMov(pOp)
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(3,3,15,74,1,YCOREDIT,.T.,"Movimento de Caixa em "+DTOC(wPerI)+" a "+DTOC(wPerF))
  Telas(15,3,20,74,1,YCOREDIT,.T.,"Totais")
  Linha23("^ENTER^-Libera Pg ^INS^-Inclui ^DEL^-Estorno ^F9^-Imprime ^F11^-Fecha Caixa",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(4,4,14,73)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "
  @ 16,04 SAY "Esp‚cie  R$ "
  @ 17,04 SAY "CH.Vista R$ "
  @ 18,04 SAY "CH.Prazo R$ "
  @ 19,04 SAY "Cartäes  R$ "
  @ 16,16 SAY nTotEsp  PICT "@E 99,999.99"
  @ 17,16 SAY nTotCHv  PICT "@E 99,999.99"
  @ 18,16 SAY nTotCHp  PICT "@E 99,999.99"
  @ 19,16 SAY nTotCard PICT "@E 99,999.99"

  @ 16,45 SAY "Entradas (*) R$ "
  @ 17,45 SAY "Sa¡das       R$ "
  @ 18,45 SAY "Sd.Anterior  R$ "
  @ 19,45 SAY "Saldo Atual  R$ "
  @ 16,62 SAY nTotEnt  PICT "@E 99,999.99"
  @ 17,62 SAY nTotSai  PICT "@E 99,999.99"
  @ 18,62 SAY nSaldAnt PICT "@E 99,999.99"
  @ 19,62 SAY nSaldo   PICT "@E 99,999.99"

  oCol:=TBCOLUMNNEW("Lib."       ,{|| OK})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Matr."      ,{|| MATRIC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hist¢rico"  ,{|| TRANSFORM(HIST,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Vcto"    ,{|| DATA})  // Vcto do documento
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("C/D"        ,{|| TIPO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Total"      ,{|| TRANSFORM(VALOR,"@E 99,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Esp‚cie"    ,{|| TRANSFORM(VLR_D,"@E 99,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Cheque"     ,{|| TRANSFORM(VLR_C,"@E 99,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("NF"         ,{|| NF})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Documento"  ,{|| DOC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Banco"      ,{|| BANCO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Item"       ,{|| PegaItem(ITEM_CX)})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Operador"   ,{|| USER})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF pOp=1
           /* Gravar todos os resultados */
           Aguarde("Atualizando a Movimenta‡Æo...")
           CAIXA->(DBSETORDER(3))
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
              IF !CAIXA->(DBSEEK((cArq1)->NLAN))
                 WHILE !CAIXA->(NetApp()); ENDDO
                 REPLACE CAIXA->MATRIC  WITH (cArq1)->MATRIC  ,;
                         CAIXA->NLAN    WITH (cArq1)->NLAN    ,;
                         CAIXA->ITEM_CX WITH (cArq1)->ITEM_CX ,;
                         CAIXA->CONTA   WITH (cArq1)->CONTA   ,;
                         CAIXA->OK      WITH (cArq1)->OK      ,;
                         CAIXA->NF      WITH (cArq1)->NF      ,;
                         CAIXA->DOC     WITH (cArq1)->DOC     ,;
                         CAIXA->HIST    WITH (cArq1)->HIST    ,;
                         CAIXA->TIPO    WITH (cArq1)->TIPO    ,;
                         CAIXA->DTMOV   WITH (cArq1)->DTMOV   ,;
                         CAIXA->DATA    WITH (cArq1)->DATA    ,;
                         CAIXA->VALOR   WITH (cArq1)->VALOR   ,;
                         CAIXA->VLR_D   WITH (cArq1)->VLR_D   ,;
                         CAIXA->VLR_C   WITH (cArq1)->VLR_C   ,;
                         CAIXA->USER    WITH (cArq1)->USER
                 CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
              ELSE
                 IF (cArq1)->OK=="Pg"
                    WHILE !CAIXA->(NetLReg()); ENDDO
                    REPLACE CAIXA->OK WITH (cArq1)->OK
                    CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
                 ENDIF
              ENDIF
              (cArq1)->(DBSKIP())
           ENDDO
           CAIXA->(DBSETORDER(1))
           Aguarde()
        ENDIF
        EXIT
     ELSEIF ( tecla == K_F11 )
        IF wPerI==wPerF
           /* Gravar o Saldo em Caixa */
           IF !SALDOS->(DBSEEK(DTOS(wPerI+1)))
              IF Confirma("** ATEN€AO ** Realiza Fechamento de Caixa ?")
                 WHILE !SALDOS->(NetApp()); ENDDO
                 REPLACE SALDOS->SALDO WITH nSaldo ,;
                         SALDOS->DATA  WITH wPerI+1
                 SALDOS->(DBUNLOCK()); SALDOS->(DBCOMMIT())
                 ProcOk("Fechamento realizado com Sucesso!",.T.)
              ENDIF
           ELSE
              Aviso("Fechamento j  realizado",,2)
           ENDIF
        ELSE
           Aviso("Fechamento somente di rio...",,3)
        ENDIF
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_ENTER)     /* Liberar pagamento */
        IF pOp=1
           IF EMPTY((cArq1)->DATA)
              Aviso("NÆo h  registro a ser Liberado...",,3); LOOP
           ELSEIF (cArq1)->NF = "ESTORNO" .OR. (cArq1)->OK = "Es"
              Aviso("Estorno não pode ser Liberado...",,3); LOOP
           ELSE
              IF (cArq1)->OK=="Pg"
                 Aviso("Registro j  Liberado!")
              ELSE
                 IF Acesso(9).AND.Confirma("Confirma Libera‡Æo ?")
                    REPLACE (cArq1)->OK WITH "Pg"

                    /* Gravar no arquivo de pagamento */
                    PAGAR->(DBSETORDER(4))
                    IF PAGAR->(DBSEEK((cArq1)->NLAN))
                       WHILE !PAGAR->(NetLReg()); ENDDO
                       REPLACE PAGAR->OK WITH "Pg"
                       PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
                       PAGAR->(DBSETORDER(1))
                    ELSE
                       Aviso("NÆo achei no pagamento individual !")
                    ENDIF
                    oBr:Refreshall()
                 ENDIF
              ENDIF
           ENDIF
        ELSE
           Aviso("Libera‡Æo nÆo permitida!")
        ENDIF
     ELSEIF ( tecla == K_INS )     /* Incluir Lan‡amento */
        IF Acesso(5)
            // Permite incluir apenas se for selecionado um dia
            IF wPerI==wPerF
               SALDOS->(DBGOBOTTOM())
               IF wPerF # cDtSys
                  Aviso("InclusÆo nÆo permitida para data retroativa",,3); LOOP
               ENDIF
               IF (SALDOS->DATA-1)==cDtSys
                  Aviso("Caixa j  se encontra fechado!",,3); LOOP
               ENDIF
               Telas(10,3,20,74,1,YCOREDIT,.T.,"InclusÆo - Caixa")
               SETCOLOR(YCOREDIT)
               xHist:=SPACE(50); xTipo:="D"; xValor:=xVlr_d:=xVlr_c:=0.00
               xdata:=cDtSys; xNF:=SPACE(8);xItem_cx:=SPACE(4);wConta:=SPACE(7)
               @ 11,05 SAY "Data do Movimento:" GET xData    PICT "@D"   WHEN .F.
               @ 12,05 SAY "Ctrle. Fiscal NF.:" GET xNF      PICT "@!"
               @ 13,05 SAY "Item de Caixa....:" GET xItem_cx PICT "9999" VALID LASTKEY()==K_UP.OR.!EMPTY(xItem_cx);
                 .AND.Pesquisa(4,1,xItem_cx,"Item nÆo Cadastrado!").AND.TDescr(4,1,13,29,xItem_cx,"DESCR",,"Item NÆo Cadastrado").AND.Let(xTipo:=ITEM->CD)
               @ 14,05 SAY "Conta Cont bil...:" GET wConta   PICT "@R 9.9.9.9.999" //VALID LASTKEY()==K_UP.OR.!EMPTY(wConta);
//                 .AND.Pesquisa(12,1,wConta,"Conta nÆo Cadastrada!").AND.TDescr(12,1,14,35,wConta,"DESCR",,"Conta NÆo Cadastrada").AND.Let(xHist:=PLANO->DESCR).AND.Let(xTipo:=PLANO->OPER)
               @ 15,05 SAY "Hist¢rico........:" GET xHist    PICT "@!"   VALID LASTKEY()==K_UP.OR.!EMPTY(xHist)
               @ 16,05 SAY "Opera‡Æo (C/D)...:" GET xTipo    PICT "!"    WHEN .F.
               @ 17,05 SAY "Valor Dinheiro R$:" GET xVlr_d   PICT "@E 99999.99"
               @ 18,05 SAY "Valor Cheque   R$:" GET xVlr_c   PICT "@E 99999.99"  VALID LASTKEY()==K_UP.OR.(!EMPTY(xVlr_c).OR.!EMPTY(xVlr_d)).AND.Let(xValor:=xVlr_d+xVlr_c)
               @ 19,05 SAY "Valor Total    R$:" GET xValor   PICT "@E 99999.99" WHEN .F.
               SETCURSOR(1); READ; SETCURSOR(0)
               IF LASTKEY()#K_ESC
                  IF Confirma("Confirma Lan‡amento ?")
                     ProcOk("Incluido",.T.)

                     zNLan := GravaLan()

                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->HIST    WITH xHist    ,;
                             (cArq1)->NLAN    WITH zNLan    ,;
                             (cArq1)->NF      WITH xNF      ,;
                             (cArq1)->ITEM_CX WITH xItem_cx ,;
                             (cArq1)->CONTA   WITH wConta   ,;
                             (cArq1)->TIPO    WITH xTipo    ,;
                             (cArq1)->DTMOV   WITH cDtSys   ,;
                             (cArq1)->DATA    WITH xData    ,;
                             (cArq1)->VLR_D   WITH xVlr_d   ,;
                             (cArq1)->VLR_C   WITH xVlr_c   ,;
                             (cArq1)->VALOR   WITH xValor   ,;
                             (cArq1)->USER    WITH cUsuario

                     IF xTipo=="D"
                        nTotSai += (cArq1)->VALOR
                        nSaldo  -= (cArq1)->VALOR
                     ELSEIF xTipo=="C"
                        nTotEnt += (cArq1)->VALOR
                        nSaldo  += (cArq1)->VALOR
                     ENDIF
                  ENDIF
               ENDIF
               SETCOLOR(YCOREDIT); Rest_Tela(); (cArq1)->(DBGOTOP())
               @ 16,62 SAY nTotEnt  PICT "@E 99,999.99"
               @ 17,62 SAY nTotSai  PICT "@E 99,999.99"
               @ 19,62 SAY nSaldo   PICT "@E 99,999.99"
               oBr:Refreshall()
            ELSE
               Aviso("Lan‡amento somente faixa de um dia.",,3)
            ENDIF
        ENDIF
     ELSEIF ( tecla == K_DEL )  /* Estornar */
        IF Acesso(5)
           IF EMPTY((cArq1)->DATA)
              Aviso("NÆo h  registro a ser Estornado...",,3); LOOP
           ENDIF
           IF (cArq1)->NF="ESTORNO"
              Aviso("Lançamento já foi Estornado !",,3); LOOP
           ENDIF
           IF Acesso(9).AND.Confirma("Confirma Estorno ?")
              lPosRec:=RECNO()
              IF (cArq1)->TIPO=="C"
*                 Aviso("NÆo pode ser excluido Cr‚dito"); LOOP
                 nTotEnt -= (cArq1)->VALOR
              ELSEIF (cArq1)->TIPO=="D"
                 nTotSai -= (cArq1)->VALOR
                 nSaldo  += (cArq1)->VALOR
              ENDIF

              /* Gravar no arquivo temporário o estorno */
              REPLACE (cArq1)->NF WITH "ESTORNO",;
                      (cArq1)->OK WITH "Es"

              /* Incluir o estorno no arquivo de movimento de caixa */
              CAIXA->(DBSETORDER(3))
              IF CAIXA->(DBSEEK((cArq1)->NLAN))
                 WHILE !CAIXA->(NetLReg()); ENDDO
                 REPLACE CAIXA->NF WITH "ESTORNO" ,;
                         CAIXA->NF WITH "Es"
                 CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
*                 CAIXA->(DBDELETE()); CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
              ENDIF
              CAIXA->(DBSETORDER(1))

*              (cArq1)->(DBDELETE()); (cArq1)->(__DBPACK())
              oBr:Refreshall(); (cArq1)->(DBGOTO(lPosRec))
*              (cArq1)->(DBGOTO(lPosRec-1))
           ELSE
              Aviso("Sem privil‚gio para Estornar...",,3); LOOP
           ENDIF
           @ 16,62 SAY nTotEnt  PICT "@E 99,999.99"
           @ 17,62 SAY nTotSai  PICT "@E 99,999.99"
           @ 19,62 SAY nSaldo   PICT "@E 99,999.99"
           oBr:Refreshall()
        ENDIF
     ELSEIF ( tecla == K_F9 )     /* Imprimir */
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpExtrato()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de ImpressÆo, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(2)
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Extrato de Mov. de Caixa       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE ImpExtrato()
   xpg:=0; continua:=.T.
   Gera_TXT("MOVCX.TXT"); SETPRC(0,0)
   CabRel("MOVIMENTO DE CAIXA",,3)
   @ PROW()+1,05 SAY "Per¡odo: "+DTOC(wPerI)+" a "+DTOC(wPerF)
   Compr_On()
   @ PROW()+1,05 SAY REPLICATE("-",128)
   @ PROW()+1,05 SAY "DATA         MATR.  HISTORICO                             DOC.       BANCO/SERVICO          ENTRADAS     SAIDAS       SALDO"
*                     99/99/9999   99999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxx XXXXXXXXXX XXXXXXXXXXxxxxxxxxxx  99,999.99  99,999.99   99,999.99
*                     56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                          1         2         3         4         5         6         7         8         9        10        11        12        13
   @ PROW()+1,05 SAY REPLICATE("-",128)

   SELECT (cArq1)
   lPrim  := .T.; nTotDin:=nTotCHp:=nTotProm:=nTotCard:=0.00
   xSaldo := nSaldAnt

   ComporSaldo(lPrim)
   @ PROW()+1,018 SAY "SALDO ANTERIOR TRANSPORTADO  ***********>"
   @ PROW()  ,119 SAY nSaldant PICT "@E 99,999.99"

   (cArq1)->(DBGOTOP())
   xdt:=(cArq1)->DTMOV; aUsu:={}
   WHILE continua.AND.!(cArq1)->(EOF())
      IF xdt#(cArq1)->DTMOV
         @ PROW()+1,05 SAY REPLICATE("-",128)
         @ PROW()+1,05 SAY (cArq1)->DTMOV
         xdt:=(cArq1)->DTMOV
      ELSE
         @ PROW()+1,05 SAY (cArq1)->DTMOV
      ENDIF

      IF (cArq1)->NF # "ESTORNO"
         // Acumula totais
         IF (cArq1)->TIPO="C"
            nTotDin += (cArq1)->VLR_D
            IF SUBS((cArq1)->DOC,1,1)=="A"
               nTotCard += (cArq1)->VLR_C
            ELSEIF (cArq1)->DATA>cDtSys // Pre-datado
               nTotCHp += (cArq1)->VLR_C
            ELSE
*              nTotCHv += (cArq1)->VLR_C
            ENDIF
         ENDIF
      ENDIF

      Compr_On()
      @ PROW()  ,018 SAY (cArq1)->MATRIC
      @ PROW()  ,025 SAY SUBS((cArq1)->HIST,1,36)
      @ PROW()  ,063 SAY (cArq1)->DOC   PICT "@S10"
      @ PROW()  ,074 SAY (cArq1)->BANCO PICT "@S20"
      @ PROW()  ,IF((cArq1)->TIPO=="C",96,108) SAY (cArq1)->VALOR PICT "@E 99,999.99"
      @ PROW()  ,120 SAY (cArq1)->SALDO PICT "@E 99,999.99"
*     @ PROW()  ,120 SAY SUBS((cArq1)->USER,1,AT(" ",(cArq1)->USER)-1)
      IF (cArq1)->NF=="ESTORNO"
         @ PROW()+1,000 SAY "**ESTORNO**"
      ENDIF
      @ PROW()+1,000 SAY " "

      IF SUBS((cArq1)->HIST,37)#SPACE(13)
         @ PROW(),024 SAY SUBS((cArq1)->HIST,37)
      ENDIF
      IF !EMPTY((cArq1)->SERV)
         @ PROW(),063 SAY (cArq1)->SERV PICT "@S10"
      ENDIF
      IF SUBS((cArq1)->DOC,1,1)="A"
         @ PROW(),073 SAY "CARTAO DE CREDITO"
      ELSEIF SUBS((cArq1)->DOC,1,2)="NP"
         @ PROW(),073 SAY "NOTA PROMISSORIA"
      ELSEIF (cArq1)->DATA>cDtSys // Pre-datado
         @ PROW(),073 SAY "CHEQUE PRE-DATADO"
      ENDIF

      IF PROW()>=58.AND.!(cArq1)->(EOF())
         EJECT; CabRel("MOVIMENTO DE CAIXA",,3)
         Compr_Off()
         @ PROW()+1,05 SAY REPLICATE("-",128)
         Compr_On()
         @ PROW()+1,05 SAY "DATA         MATR.  HISTORICO                             DOC.       BANCO/SERVICO          ENTRADAS     SAIDAS       SALDO"
         @ PROW()+1,05 SAY REPLICATE("-",128)
      ENDIF
      xdt:=(cArq1)->DTMOV
      lEncontra:=.F.

      // Preenchimento dos vetores
      IF (cArq1)->TIPO=="C"
         FOR i = 1 TO LEN(aUsu)
            IF ASCAN(aUsu[i],(cArq1)->USER)#0
               lEncontra:=.T.
               IF SUBS((cArq1)->DOC,1,1)=="A"
                  AFILL(aUsu,{(cArq1)->USER,(cArq1)->VLR_D+aUsu[i,2],aUsu[i,3],aUsu[i,4],(cArq1)->VLR_C+aUsu[i,5],(cArq1)->VALOR+aUsu[i,6]},i,1)
               ELSEIF (cArq1)->DATA>cDtSys // Pre-datado
                  AFILL(aUsu,{(cArq1)->USER,(cArq1)->VLR_D+aUsu[i,2],aUsu[i,3],(cArq1)->VLR_C+aUsu[i,4],aUsu[i,5],(cArq1)->VALOR+aUsu[i,6]},i,1)
               ELSE
                  AFILL(aUsu,{(cArq1)->USER,(cArq1)->VLR_D+aUsu[i,2],(cArq1)->VLR_C+aUsu[i,3],aUsu[i,4],aUsu[i,5],(cArq1)->VALOR+aUsu[i,6]},i,1)
               ENDIF
            ENDIF
         NEXT
         IF !lEncontra
            IF SUBS((cArq1)->DOC,1,1)="A" // Cartao
               AADD(aUsu,{(cArq1)->USER,(cArq1)->VLR_D,0.00,0.00,(cArq1)->VLR_C,(cArq1)->VALOR})
            ELSEIF (cArq1)->DATA>cDtSys // Pre-datado
               AADD(aUsu,{(cArq1)->USER,(cArq1)->VLR_D,0.00,(cArq1)->VLR_C,0.00,(cArq1)->VALOR})
            ELSE
               AADD(aUsu,{(cArq1)->USER,(cArq1)->VLR_D,(cArq1)->VLR_C,0.00,0.00,(cArq1)->VALOR})
            ENDIF
         ENDIF
      ENDIF

      (cArq1)->(DBSKIP())
   ENDDO
   IF continua
      IF PROW()>=60
         EJECT; CabRel("MOVIMENTO DE CAIXA (Continua‡Æo)",,3); Compr_off()
      ENDIF

      @ PROW()+1,005 SAY REPLICATE("-",128)
      Compr_On()
      @ PROW()+1,005 SAY "T O T A L   =======> R$ "
      @ PROW()  ,095 SAY nTotEnt PICT "@E 99,999.99"
      @ PROW()  ,107 SAY nTotSai PICT "@E 99,999.99"
      @ PROW()  ,119 SAY nSaldo  PICT "@E 99,999.99"

      @ PROW()+1,005 SAY REPLICATE("-",128)
      @ PROW()+2,005 SAY "TOTAL EM DINHEIRO R$ "
      @ PROW()  ,025 SAY  nTotDin  PICT "@E 99,999.99"
      @ PROW()+1,005 SAY "TOTAL CH. VISTA   R$ "
      @ PROW()  ,025 SAY  nTotCHv   PICT "@E 99,999.99"
      @ PROW()+1,005 SAY "TOTAL CH. PRAZO   R$ "
      @ PROW()  ,025 SAY  nTotCHp   PICT "@E 99,999.99"
      @ PROW()+1,005 SAY "TOTAL EM CARTAO   R$ "
      @ PROW()  ,025 SAY  nTotCard PICT "@E 99,999.99"
*     @ PROW()+1,005 SAY "TOTAL PROMISSORIA R$ "
*     @ PROW()  ,025 SAY  nTotProm PICT "@E 99,999.99"
      @ PROW()+2,005 SAY "Conferido por: ___________________"
      @ PROW()+2,005 SAY "(CREDITO - DEBITO) ---> "
      @ PROW()  ,033 SAY nTotEnt-nTotSai PICT "@E 99,999.99"
      IF PROW()+12>64; EJECT; ENDIF
      @ PROW()+2,005 SAY " ------------------------------- RESUMO DAS RECEITAS  [ R$ ] -------------------------------- "
      @ PROW()+1,005 SAY "|       U  S  U  A  R  I  O       | ESPECIE  | CH.VISTA | CH.PRAZO  |   CARTAO   |   TOTAL   |"
      @ PROW()+1,005 SAY "|---------------------------------|----------|----------|-----------|------------|-----------|"
*                                                             99,999.99  99,999.99  99,999.99    99,999.99   999,999.99
*                         5678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678
*                              1         2         3         4         5         6         7         8         9
      ASORT(aUsu)
      FOR d = 1 TO LEN(aUsu)
          @ PROW()+1,05 SAY "|"+aUsu[d,1]
          @ PROW()  ,39 SAY "|"
          @ PROW()  ,41 SAY aUsu[d,2]  PICT "@E 99,999.99"
          @ PROW()  ,50 SAY "|"
          @ PROW()  ,52 SAY aUsu[d,3]  PICT "@E 99,999.99"
          @ PROW()  ,61 SAY "|"
          @ PROW()  ,63 SAY aUsu[d,4]  PICT "@E 99,999.99"
          @ PROW()  ,72 SAY "|"
          @ PROW()  ,77 SAY aUsu[d,5]  PICT "@E 99,999.99"
          @ PROW()  ,86 SAY "|"
          @ PROW()  ,88 SAY aUsu[d,6]  PICT "@E 999,999.99"
          @ PROW()  ,98 SAY "|"
      NEXT

      @ PROW()+1,05 SAY "|---------------------------------|----------|----------|----------|-------------|-----------|"
      @ PROW()+1,05 SAY "|          T  O  T  A  L          |"
      @ PROW()  ,41 SAY nTotDin  PICT "@E 99,999.99"
      @ PROW()  ,50 SAY "|"
      @ PROW()  ,52 SAY nTotCHv  PICT "@E 99,999.99"
      @ PROW()  ,61 SAY "|"
      @ PROW()  ,63 SAY nTotCHp  PICT "@E 99,999.99"
      @ PROW()  ,72 SAY "|"
      @ PROW()  ,77 SAY nTotCard PICT "@E 99,999.99"
      @ PROW()  ,86 SAY "|"
      @ PROW()  ,88 SAY nTotDin+nTotCHp+nTotCard+nTotCHv PICT "@E 999,999.99"
      @ PROW()  ,98 SAY "|"
      @ PROW()+1,05 SAY " --------------------------------------------------------------------------------------------"
      @ PROW()+1,05 SAY " "
   ENDIF
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp MOVCX.TXT 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE MOVCX.TXT
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Compor Saldo Anterior          ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE ComporSaldo(lPrim)
   (cArq1)->(DBGOTOP())
   WHILE !(cArq1)->(EOF())
      IF SUBS((cArq1)->DOC,1,1)#"A" .AND. SUBS((cArq1)->DOC,1,2)#"NP"
         IF (cArq1)->TIPO=="C"
            IF (cArq1)->DATA>cDtSys // Pre-datado
               IF lPrim
                  REPLACE (cArq1)->SALDO WITH nSaldant
               ELSE
                  REPLACE (cArq1)->SALDO WITH xSaldo
               ENDIF
            ELSE
               IF lPrim
                  IF nSaldAnt > 0.00
                     REPLACE (cArq1)->SALDO WITH (cArq1)->VALOR+nSaldant
                  ELSEIF nSaldAnt < 0.00
                     REPLACE (cArq1)->SALDO WITH (cArq1)->VALOR-nSaldant
                  ELSE
                     REPLACE (cArq1)->SALDO WITH (cArq1)->VALOR
                  ENDIF
               ELSE
                  REPLACE (cArq1)->SALDO WITH xSaldo+(cArq1)->VALOR
               ENDIF
               xSaldo += (cArq1)->VALOR
            ENDIF
         ELSE
            IF lPrim
               IF nSaldAnt > 0.00
                  REPLACE (cArq1)->SALDO WITH SaldAnt-(cArq1)->VALOR
               ELSEIF nSaldAnt < 0.00
                  REPLACE (cArq1)->SALDO WITH ((cArq1)->VALOR+nSaldant)*-1
               ELSE
                  REPLACE (cArq1)->SALDO WITH (cArq1)->VALOR
               ENDIF
            ELSE
               REPLACE (cArq1)->SALDO WITH xSaldo-(cArq1)->VALOR
            ENDIF
            xSaldo -= (cArq1)->VALOR
         ENDIF
         lPrim:=.F.
      ELSE
         REPLACE (cArq1)->SALDO WITH xSaldo
      ENDIF
      (cArq1)->(DBSKIP())
   ENDDO
   RETURN
