*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_363                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio Financeiro (caixa)             ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 26/08/2010                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

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
AADD(aDbf,{"HIST"     ,"C",   50,0}) /* Histขrico                */
AADD(aDbf,{"TIPO"     ,"C",   01,0}) /* Crdito ou Dbito        */
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

ProgName("AE363"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "63"
SET KEY -1 TO Mostra()
wPerIni:=wPerFim:=CTOD('')
WHILE .T.
   nTotEnt:=nTotSai:=nTotCard:=nTotCHv:=nTotEsp:=nTotCHp:=nSaldo:=0.00

   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Perกodo do Movimento")
   Telas(12,20,14,55,1,YCOREDIT,.T.,"Movimento Financeiro")
   @ 13,22 SAY " Perกodo:" GET wPerIni PICT "@D" VALID !EMPTY(wPerIni)
   @ 13,43                 GET wPerFim PICT "@D" VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni
   @ 13,41 SAY "a"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   Mensagem()

   /* Localizar Periodo */
   IF !CAIXA->(DBSEEK(DTOS(wPerI),.T.))
      IF CAIXA->DTMOV > wPerF
         Aguarde()
         Aviso("Nฦo houve movimento financeiro neste perกodo",,3)
         Rest_tela(); LOOP
      ENDIF
   ENDIF

   /*
      Carregar Arq. Temporario
      Localizar o saldo do primeiro dia do periodo
   */
   nSaldAnt := SALDOS->SALDO
   Aguarde("Lendo o movimento...")
   IF !CAIXA->(DBSEEK(DTOS(wPerI),.T.))
      IF CAIXA->DTMOV > wPerF
         Aguarde()
         Aviso("Nฦo houve movimento neste perกodo",,3)
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
      CAIXA->(DBSKIP())
   ENDDO
   nTotEnt := nTotEsp + nTotCHv + nTotCHp

   // Traz o saldo da leitura anterior
   IF nSaldAnt > 0.00
      nSaldo += nSaldAnt
   ELSEIF nSaldAnt < 0.00
      nSaldo -= nSaldAnt
   ENDIF

   Aguarde()
   Financeiro()
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */

   Rest_Tela()
ENDDO
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Tela Financeira do Periodo     ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Financeiro()
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(3,3,15,74,1,YCOREDIT,.T.,"Movimento Financeiro em "+DTOC(wPerI)+" a "+DTOC(wPerF))
  Telas(15,3,20,74,1,YCOREDIT,.T.,"Totais")
  Linha23("^F8^-Filtro ^F9^-Imprime",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(4,4,14,73)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "
  @ 16,04 SAY "Espcie  R$ "
  @ 17,04 SAY "CH.Vista R$ "
  @ 18,04 SAY "CH.Prazo R$ "
  @ 19,04 SAY "Cartไes  R$ "
  @ 16,16 SAY nTotEsp  PICT "@E 99,999.99"
  @ 17,16 SAY nTotCHv  PICT "@E 99,999.99"
  @ 18,16 SAY nTotCHp  PICT "@E 99,999.99"
  @ 19,16 SAY nTotCard PICT "@E 99,999.99"

  @ 16,45 SAY "Entradas (*) R$ "
  @ 17,45 SAY "Saกdas       R$ "
  @ 18,45 SAY "Sd.Anterior  R$ "
  @ 19,45 SAY "Saldo Atual  R$ "
  @ 16,62 SAY nTotEnt  PICT "@E 99,999.99"
  @ 17,62 SAY nTotSai  PICT "@E 99,999.99"
  @ 18,62 SAY nSaldAnt PICT "@E 99,999.99"
  @ 19,62 SAY nSaldo   PICT "@E 99,999.99"

  oCol:=TBCOLUMNNEW("Matr."      ,{|| MATRIC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Histขrico"  ,{|| TRANSFORM(HIST,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Vcto"    ,{|| DATA})  // Vcto do documento
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("C/D"        ,{|| TIPO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Total"      ,{|| TRANSFORM(VALOR,"@E 99,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Espcie"    ,{|| TRANSFORM(VLR_D,"@E 99,999.99")})
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
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F9 )     /* Imprimir */
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpExtrato()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de Impressฦo, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(2)
  RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Extrato Financeiro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpExtrato()
   xpg:=0; continua:=.T.
   Gera_TXT("MOVEX.TXT"); SETPRC(0,0)
   CabRel("MOVIMENTO FINANCEIRO",,3)
   @ PROW()+1,05 SAY "Perกodo: "+DTOC(wPerI)+" a "+DTOC(wPerF)
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

      // Acumula totais
      IF (cArq1)->TIPO="C"
         nTotDin += (cArq1)->VLR_D
         IF SUBS((cArq1)->DOC,1,1)=="A"
            nTotCard += (cArq1)->VLR_C
         ELSEIF (cArq1)->DATA>cDtSys // Pre-datado
            nTotCHp += (cArq1)->VLR_C
         ELSE
*           nTotCHv += (cArq1)->VLR_C
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
         EJECT; CabRel("MOVIMENTO DE CAIXA (Continuaฦo)",,3); Compr_off()
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
   RUN nodosimp MOVEX.TXT 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE MOVEX.TXT
   RETURN
