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
wPerI:=wPerF:=cDtSys
WHILE .T.
   nTotEnt:=nTotSai:=nTotCard:=nTotProm:=nTotEsp:=nTotCH:=nTotind:=0.00
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
      WHILE CAIXA->DTMOV>=wPerI .AND. CAIXA->DTMOV<=wPerF
         IF CAIXA->USER == cUsuario
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->MATRIC  WITH CAIXA->MATRIC  ,;
                    (cArq1)->OK      WITH CAIXA->OK      ,;
                    (cArq1)->NLAN    WITH CAIXA->NLAN    ,;
                    (cArq1)->ITEM_CX WITH CAIXA->ITEM_CX ,;
                    (cArq1)->CONTA   WITH CAIXA->CONTA   ,;
                    (cArq1)->DOC     WITH CAIXA->DOC     ,;
                    (cArq1)->HIST    WITH CAIXA->HIST    ,;
                    (cArq1)->TIPO    WITH CAIXA->TIPO    ,;
                    (cArq1)->DTMOV   WITH CAIXA->DTMOV   ,;
                    (cArq1)->DATA    WITH CAIXA->DATA    ,;
                    (cArq1)->VALOR   WITH CAIXA->VALOR   ,;
                    (cArq1)->VLR_D   WITH CAIXA->VLR_D   ,;
                    (cArq1)->VLR_C   WITH CAIXA->VLR_C   ,;
                    (cArq1)->SERV    WITH CAIXA->SERV    ,;
                    (cArq1)->BANCO   WITH CAIXA->BANCO   ,;
                    (cArq1)->USER    WITH CAIXA->USER
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
                  nTotCH  += (cArq1)->VLR_C
               ENDIF
            ENDIF
         ENDIF
         CAIXA->(DBSKIP())
      ENDDO
   ELSE
      WHILE CAIXA->DTMOV>=wPerI .AND. CAIXA->DTMOV<=wPerF
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->MATRIC  WITH CAIXA->MATRIC  ,;
                 (cArq1)->OK      WITH CAIXA->OK      ,;
                 (cArq1)->NLAN    WITH CAIXA->NLAN    ,;
                 (cArq1)->ITEM_CX WITH CAIXA->ITEM_CX ,;
                 (cArq1)->CONTA   WITH CAIXA->CONTA   ,;
                 (cArq1)->DOC     WITH CAIXA->DOC     ,;
                 (cArq1)->HIST    WITH CAIXA->HIST    ,;
                 (cArq1)->TIPO    WITH CAIXA->TIPO    ,;
                 (cArq1)->DTMOV   WITH CAIXA->DTMOV   ,;
                 (cArq1)->DATA    WITH CAIXA->DATA    ,;
                 (cArq1)->VALOR   WITH CAIXA->VALOR   ,;
                 (cArq1)->VLR_D   WITH CAIXA->VLR_D   ,;
                 (cArq1)->VLR_C   WITH CAIXA->VLR_C   ,;
                 (cArq1)->SERV    WITH CAIXA->SERV    ,;
                 (cArq1)->BANCO   WITH CAIXA->BANCO   ,;
                 (cArq1)->USER    WITH CAIXA->USER

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
               nTotCH  += (cArq1)->VLR_C
            ENDIF
         ENDIF
         CAIXA->(DBSKIP())
      ENDDO
   ENDIF
   nTotind := nTotEsp + nTotCH + nTotCard
   nTotEnt := nTotInd - nTotCard
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
  Telas(3,3,17,74,1,YCOREDIT,.T.,"Movimento de Caixa em "+DTOC(wPerI)+" a "+DTOC(wPerF))
  Telas(17,3,20,74,1,YCOREDIT,.T.,"Totais")
  Linha23("^ENTER^-Libera Pg ^INS^-Inclui ^DEL^-Exclui ^F9^-Imprime ^F11^-Fecha Caixa",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(4,4,16,73)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "
  @ 18,04 SAY "Esp‚cie  R$ "
  @ 19,04 SAY "Cheques  R$ "
  @ 18,16 SAY nTotEsp  PICT "@E 99,999.99"
  @ 19,16 SAY nTotCH   PICT "@E 99,999.99"
  @ 18,47 SAY "Cartäes R$ "
  @ 19,47 SAY "Total   R$ "
  @ 18,60 SAY nTotCard PICT "@E 99,999.99"
  @ 19,60 SAY nTotInd  PICT "@E 99,999.99"

  oCol:=TBCOLUMNNEW("Lib."       ,{|| OK})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Matr."      ,{|| MATRIC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hist¢rico"  ,{|| TRANSFORM(HIST,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
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
           // Verifica se caixa est  fechado
           SALDOS->(DBGOBOTTOM())
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
//             .AND.Pesquisa(12,1,wConta,"Conta nÆo Cadastrada!").AND.TDescr(12,1,14,35,wConta,"DESCR",,"Conta NÆo Cadastrada").AND.Let(xHist:=PLANO->DESCR).AND.Let(xTipo:=PLANO->OPER)
           @ 15,05 SAY "Hist¢rico........:" GET xHist    PICT "@!"   VALID LASTKEY()==K_UP.OR.!EMPTY(xHist)
           @ 16,05 SAY "Opera‡Æo (C/D)...:" GET xTipo    PICT "!"    WHEN .F.
           @ 17,05 SAY "Valor Dinheiro R$:" GET xVlr_d   PICT "@E 99,999.99"
           @ 18,05 SAY "Valor Cheque   R$:" GET xVlr_c   PICT "@E 99,999.99" VALID Let(xValor:=xVlr_d+xVlr_c)
           @ 19,05 SAY "Valor Total    R$:" GET xValor   PICT "@E 99,999.99" WHEN .F.
           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              IF Confirma("Confirma Lan‡amento ?")
                 ProcOk("Incluido",.T.)

                 GravaLan()

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
                 ELSEIF xTipo=="C"
                    nTotEnt += (cArq1)->VALOR
                 ENDIF
              ENDIF
           ENDIF
           SETCOLOR(YCOREDIT); Rest_Tela(); (cArq1)->(DBGOTOP())
           @ 18,16 SAY nTotEnt  PICT "@E 99,999.99"
           @ 19,16 SAY nTotSai  PICT "@E 99,999.99"
           oBr:Refreshall()
        ENDIF
     ELSEIF ( tecla == K_ALT_E )  /* Excluir  */
        IF Acesso(9)
           IF EMPTY((cArq1)->DATA)
              Aviso("NÆo h  registro a ser Exclu¡do...",,3); LOOP
           ENDIF
           IF Acesso(9).AND.Confirma("Confirma ExclusÆo ?")
              lPosRec:=RECNO()
              IF (cArq1)->TIPO=="C"
                 nTotEnt -= (cArq1)->VALOR
              ELSEIF (cArq1)->TIPO=="D"
                 nTotSai -= (cArq1)->VALOR
              ENDIF
              /* Excluir no arquivo de movimento de caixa */
              CAIXA->(DBSETORDER(3))
              IF CAIXA->(DBSEEK((cArq1)->NLAN))
                 WHILE !CAIXA->(NetLReg()); ENDDO
                 CAIXA->(DBDELETE()); CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
              ENDIF
              CAIXA->(DBSETORDER(1))

              (cArq1)->(DBDELETE()); (cArq1)->(__DBPACK())
              oBr:Refreshall()
              (cArq1)->(DBGOTO(lPosRec-1))
           ENDIF
*          @ 18,16 SAY nTotEnt  PICT "@E 99,999.99"
*          @ 19,16 SAY nTotSai  PICT "@E 99,999.99"
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
   @ PROW()+1,05 SAY "DATA       MATR. HISTORICO                             DOC.       BANCO/SERVICO         ENTRADAS    SAIDAS  USUARIO"
*                     99/99/9999 99999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxx XXXXXXXXXX XXXXXXXXXXxxxxxxxxxx 99,999.99 99,999.99  XXXXXXXXXX
*                     5678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                          1         2         3         4         5         6         7         8         9        10        12        13
   @ PROW()+1,05 SAY REPLICATE("-",128)

   SELECT (cArq1); (cArq1)->(DBGOTOP())
   lPrim:=.T.; nTotDin:=nTotCH:=nTotProm:=nTotCard:=0.00
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

      // Acumula totais
      IF (cArq1)->TIPO="C"
         nTotDin += (cArq1)->VLR_D
         IF SUBS((cArq1)->DOC,1,1)=="A"
            nTotCard += (cArq1)->VLR_C
         ELSE
            nTotCH += (cArq1)->VLR_C
         ENDIF
      ENDIF

      Compr_On()
      @ PROW()  ,016 SAY (cArq1)->MATRIC
      @ PROW()  ,022 SAY SUBS((cArq1)->HIST,1,36)
      @ PROW()  ,060 SAY (cArq1)->DOC   PICT "@S10"
      @ PROW()  ,071 SAY (cArq1)->BANCO PICT "@S20"
      @ PROW()  ,IF((cArq1)->TIPO=="C",92,102) SAY (cArq1)->VALOR PICT "@E 99,999.99"
      @ PROW()  ,123 SAY SUBS((cArq1)->USER,1,AT(" ",(cArq1)->USER)-1)
      @ PROW()+1,000 SAY " "

      IF SUBS((cArq1)->HIST,37)#SPACE(13)
         @ PROW(),022 SAY SUBS((cArq1)->HIST,37)
      ENDIF
      IF !EMPTY((cArq1)->SERV)
         @ PROW(),060 SAY (cArq1)->SERV PICT "@S10"
      ENDIF
      IF SUBS((cArq1)->DOC,1,1)="A"
         @ PROW(),071 SAY "CARTAO DE CREDITO"
      ENDIF

      IF PROW()>=58.AND.!(cArq1)->(EOF())
         EJECT; CabRel("MOVIMENTO DE CAIXA",,3)
         Compr_Off()
         @ PROW()+1,05 SAY REPLICATE("-",128)
         Compr_On()
         @ PROW()+1,05 SAY "DATA       MATR. HISTORICO                             DOC.       BANCO/SERVICO         ENTRADAS    SAIDAS  USUARIO"
         @ PROW()+1,05 SAY REPLICATE("-",128)
      ENDIF
      xdt:=(cArq1)->DTMOV
      lEncontra:=.F.
      IF (cArq1)->TIPO=="C"
         FOR i = 1 TO LEN(aUsu)
            IF (nElem:=ASCAN(aUsu[i],(cArq1)->USER))#0
               lEncontra:=.T.
               IF aUsu[i,2]==NIL
                  aUsu[i,2]:= 0.00
               ENDIF
               IF aUsu[i,3]==NIL
                  aUsu[i,3]:= 0.00
               ENDIF
               IF aUsu[i,4]==NIL
                  aUsu[i,4]:= 0.00
               ENDIF

               IF SUBS((cArq1)->DOC,1,1)="A"
                  AFILL(aUsu,{(cArq1)->USER,(cArq1)->VLR_D+aUsu[i,2],,(cArq1)->VLR_C+aUsu[i,4],(cArq1)->VALOR+aUsu[i,5]},i,1)
               ELSE
                  AFILL(aUsu,{(cArq1)->USER,(cArq1)->VLR_D+aUsu[i,2],(cArq1)->VLR_C+aUsu[i,3],,(cArq1)->VALOR+aUsu[i,5]},i,1)
               ENDIF
            ENDIF
         NEXT
      ENDIF
      IF (cArq1)->TIPO=="C"
         IF !lEncontra
*           AADD(aUsu,{"",0.00,0.00,0.00,0.00})
            IF SUBS((cArq1)->DOC,1,1)="A"
               AADD(aUsu,{(cArq1)->USER,(cArq1)->VLR_D,0.00,(cArq1)->VLR_C,(cArq1)->VALOR})
            ELSE
               AADD(aUsu,{(cArq1)->USER,(cArq1)->VLR_D,(cArq1)->VLR_C,0.00,(cArq1)->VALOR})
            ENDIF
         ENDIF
      ENDIF

      (cArq1)->(DBSKIP())
   ENDDO
   IF continua
      IF PROW()>=60
         EJECT; CabRel("MOVIMENTO DE CAIXA (Continuacao)",,3); Compr_off()
      ENDIF

      @ PROW()+1,005 SAY REPLICATE("-",128)
      Compr_On()
      @ PROW()+1,005 SAY "T O T A L   =======> R$ "
      @ PROW()  ,092 SAY nTotEnt PICT "@E 99,999.99"
      @ PROW()  ,103 SAY nTotSai PICT "@E 99,999.99"
      @ PROW()+1,005 SAY REPLICATE("-",128)
      @ PROW()+2,005 SAY "TOTAL EM DINHEIRO R$ "
      @ PROW()  ,025 SAY  nTotDin  PICT "@E 99,999.99"
      @ PROW()+1,005 SAY "TOTAL EM CHEQUE   R$ "
      @ PROW()  ,025 SAY  nTotCH   PICT "@E 99,999.99"
      @ PROW()+1,005 SAY "TOTAL EM CARTAO   R$ "
      @ PROW()  ,025 SAY  nTotCard PICT "@E 99,999.99"
      @ PROW()+2,005 SAY "Conferido por: ___________________"
      @ PROW()+2,005 SAY "(CREDITO - DEBITO) ---> "
      @ PROW()  ,033 SAY nTotEnt-nTotSai PICT "@E 99,999.99"
      IF PROW()+16>58; EJECT; ENDIF
      @ PROW()+2,005 SAY " -----------------------------------------------------[ R$ ]------------------ "
      @ PROW()+1,005 SAY "|       U  S  U  A  R  I  O       | ESPECIE  | CHEQUE   |  CARTAO  |  TOTAL   |"
      @ PROW()+1,005 SAY "|---------------------------------|----------|----------|----------|----------|"

*                                                             99,999.99  99,999.99  99,999.99 999,999.99
*                         56789012345678901234567890123456789012345678901234567890123456789012345678901234567
*                              1         2         3         4         5         6         7         8
      ASORT(aUsu)
      FOR d = 1 TO LEN(aUsu)
          @ PROW()+1,05 SAY "|"+aUsu[d,1]
          @ PROW()  ,39 SAY "|"
          @ PROW()  ,41 SAY aUsu[d,2]  PICT "@E 99,999.99"
          @ PROW()  ,50 SAY "|"
          @ PROW()  ,52 SAY aUsu[d,3]  PICT "@E 99,999.99"
          @ PROW()  ,61 SAY "|"
          @ PROW()  ,63 SAY aUsu[d,4]  PICT "@E 999,999.99"
          @ PROW()  ,72 SAY "|"
          @ PROW()  ,73 SAY aUsu[d,5]  PICT "@E 999,999.99"
          @ PROW()  ,83 SAY "|"
      NEXT

      @ PROW()+1,05 SAY "|---------------------------------|----------|----------|----------|----------|"
      @ PROW()+1,05 SAY "|          T  O  T  A  L          |"
      @ PROW()  ,41 SAY nTotDin  PICT "@E 99,999.99"
      @ PROW()  ,50 SAY "|"
      @ PROW()  ,52 SAY nTotCH   PICT "@E 99,999.99"
      @ PROW()  ,61 SAY "|"
      @ PROW()  ,63 SAY nTotCard PICT "@E 99,999.99"
      @ PROW()  ,72 SAY "|"
      @ PROW()  ,73 SAY nTotDin+nTotCH+nTotCard PICT "@E 999,999.99"
      @ PROW()  ,83 SAY "|"
      @ PROW()+1,05 SAY " ----------------------------------------------------------------------------- "
      @ PROW()+1,05 SAY " "
   ENDIF
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp MOVCX.TXT 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE MOVCX.TXT
   RETURN
