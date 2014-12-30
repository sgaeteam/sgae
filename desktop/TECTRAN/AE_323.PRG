*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_323                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio Despesas por item              ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/05/2009                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario (Analitico)
aDbf:={}
AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item de caixa            */
AADD(aDbf,{"CONTA"    ,"C",   07,0}) /* Conta 9.9.9.9.999        */
AADD(aDbf,{"DOC"      ,"C",   10,0}) /* Documento                */
AADD(aDbf,{"OK"       ,"C",   02,0}) /* Confirmacao recebimento  */
AADD(aDbf,{"NF"       ,"C",   06,0}) /* Numero da Nota Fiscal    */
AADD(aDbf,{"BANCO"    ,"C",   15,0}) /* Nome do Banco            */
AADD(aDbf,{"HIST"     ,"C",   50,0}) /* Histขrico                */
AADD(aDbf,{"TIPO"     ,"C",   01,0}) /* Crdito ou Dbito        */
AADD(aDbf,{"DTMOV"    ,"D",   08,0}) /* Data do Movimento        */
AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Documento        */
AADD(aDbf,{"VALOR"    ,"N",   10,2}) /* Valor total              */
AADD(aDbf,{"VLR_D"    ,"N",   10,2}) /* Valor em dinheiro        */
AADD(aDbf,{"VLR_C"    ,"N",   10,2}) /* Valor em cheque          */
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
INDEX ON item_cx TO (cArq1)

// Gerar Arquivo Temporario (Sinttico)
aDbf:={}
AADD(aDbf,{"ITEM_CX"  ,"C",   04,0}) /* Item de caixa            */
AADD(aDbf,{"VALOR"    ,"N",   10,2}) /* Valor total              */
AADD(aDbf,{"VLR_D"    ,"N",   10,2}) /* Valor em dinheiro        */
AADD(aDbf,{"VLR_C"    ,"N",   10,2}) /* Valor em cheque          */
AADD(aDbf,{"FATIA"    ,"N",   06,2}) /* Percentual da despesa    */
WHILE .T.
   sHour:=TIME()
   cArq2:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq2+".DBF")
      DBCREATE(cArq2,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 11
NetUse(cArq2,,"E")
INDEX ON item_cx TO (cArq2)

SELECT 1
IF NetUse("DBITEM","ITEM")           /* Arquivo de Itens de Caixa */
   SET INDEX TO DBITEM1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")            /* Arquivo de Caixa */
   SET INDEX TO DBICX1
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE323";ProgName("AE323"); LinhaMsg(2)
SET KEY -1 TO Mostra()

WHILE .T.
   wPerIni:=wPerFim:=CTOD("")
   vtot:=0
   SETCOLOR(YCOREDIT)
   Telas(16,3,20,30,1,YCOREDIT,.T.)
   @ 17,05 SAY "*** Despesas ***"
   @ 18,05 SAY "Data Inicial:" GET wPerIni PICT "@D" WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
   @ 19,05 SAY "Data Final  :" GET wPerFim PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni.AND.wPerFim<=DATE()
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   CAIXA->(DBSEEK(DTOS(wPerIni),.T.))
   IF CAIXA->DTMOV<=wPerFim
      /* Alimentar arquivo temporario */
      Aguarde("Calculando...")
      WHILE CAIXA->DTMOV>=wPerIni.AND.CAIXA->DTMOV<=wPerFim.AND.!CAIXA->(EOF())
         IF CAIXA->TIPO=="D"
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->ITEM_CX WITH CAIXA->ITEM_CX  ,;
                    (cArq1)->CONTA   WITH CAIXA->CONTA    ,;
                    (cArq1)->DOC     WITH CAIXA->DOC      ,;
                    (cArq1)->OK      WITH CAIXA->OK       ,;
                    (cArq1)->NF      WITH CAIXA->NF       ,;
                    (cArq1)->BANCO   WITH CAIXA->BANCO    ,;
                    (cArq1)->HIST    WITH CAIXA->HIST     ,;
                    (cArq1)->TIPO    WITH CAIXA->TIPO     ,;
                    (cArq1)->DTMOV   WITH CAIXA->DTMOV    ,;
                    (cArq1)->DATA    WITH CAIXA->DATA     ,;
                    (cArq1)->VALOR   WITH CAIXA->VALOR    ,;
                    (cArq1)->VLR_D   WITH CAIXA->VLR_D    ,;
                    (cArq1)->VLR_C   WITH CAIXA->VLR_C

            // Acumular
            IF !(cArq2)->(DBSEEK(CAIXA->ITEM_CX))
               (cArq2)->(DBAPPEND())
               REPLACE (cArq2)->ITEM_CX WITH CAIXA->ITEM_CX
            ENDIF
            REPLACE (cArq2)->VALOR WITH (cArq2)->VALOR+CAIXA->VALOR ,;
                    (cArq2)->VLR_D WITH (cArq2)->VLR_D+CAIXA->VLR_D ,;
                    (cArq2)->VLR_C WITH (cArq2)->VLR_C+CAIXA->VLR_C
         ENDIF
         CAIXA->(DBSKIP())
      ENDDO
      Aguarde()
      (cArq1)->(DBCOMMIT()); (cArq2)->(DBCOMMIT())
      IF !(cArq1)->(EOF())
         DispDesp()
      ELSE
         Aviso("Nฦo h  registro de despesas no perกodo informado!",,3)
      ENDIF

      /* Apagar Arquivos Temporarios */
      DBCLOSEAREA(10)
      ERASE (cArq1)+".DBF"
      ERASE (cArq1)+".NTX"
      DBCLOSEAREA(11)
      ERASE (cArq2)+".DBF"
      ERASE (cArq2)+".NTX"
   ELSE
      Aviso("Nฦo h  registro de despesas no perกodo informado!",,3)
   ENDIF
   Rest_Tela()
ENDDO
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Display em Tela das Despesas   ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION DispDesp()
  LOCAL corant:=SETCOLOR(), oBr, oCol, oDia:=0
  SETCOLOR(YCORGERAL); Linha23("^ESC^-Retorna ^F9^-Imprimir Analกtico ^F10^-Imprimir Sinttico",24)
  SELECT (cArq1); DBGOTOP()
  Telas(2,0,22,79,1,YCORGERAL,.F.)
  oBr:=TBROWSEDB(3,1,21,78)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Dt.Mov."   ,{|| DTMOV})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Item"      ,{|| ITEM_CX})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Histขrico" ,{|| TRANSFORM(HIST,"@!S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Valor"     ,{|| TRANSFORM(VALOR,"@E 9,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Espcie"   ,{|| TRANSFORM(VLR_D,"@E 9,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Cheque"    ,{|| TRANSFORM(VLR_C,"@E 9,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Banco"     ,{|| BANCO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("NF"        ,{|| NF})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Doc"       ,{|| DOC})
  oBr:addColumn(oCol)

  oBr:Freeze=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  /* Imprimir Analitico */
         IF ChkImpr()
            (cArq1)->(DBGOTOP())
            cAviso := MsgImp()
            pg:=0; continua:=.T.
            Gera_TXT("RECCH.TXT")
            CabRel("CHEQUES RECEBIDOS")
            @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
            Compr_On()
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
*                              XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/9999 XXXXXXXXXX  9,999.99  XXXXXXXXXXXXXXX _____________
*                              23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*                                      1         2         3         4         5         6         7         8         9        10
            @ PROW()+1,02 SAY REPLICATE("-",100)
            nValor_c:=0.00
            WHILE !(cArq1)->(EOF())
               Compr_On()
               @ PROW()+1,02 SAY (cArq1)->ALUNO   PICT "@!S40"
               @ PROW()  ,43 SAY (cArq1)->DTVCTO  PICT "@D"
               @ PROW()  ,54 SAY (cArq1)->DOC     PICT "@!"
               @ PROW()  ,66 SAY (cArq1)->VALOR_C PICT "@E 9,999.99"
               @ PROW()  ,76 SAY (cArq1)->BANCO
               @ PROW()  ,92 SAY REPLIC("_",15)
               nValor_c += (cArq1)->VALOR_C
               (cArq1)->(DBSKIP())
               IF PROW()>=57.AND.!EOF()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,68 SAY "Continua..."
                  EJECT; CabRel("CHEQUES RECEBIDOS")
                  @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                  Compr_On()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
                  @ PROW()+1,02 SAY REPLICATE("-",100)
               ENDIF
            ENDDO
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "T O T A L  --->"
            @ PROW()  ,65 SAY nValor_c PICT "@E 99,999.99"
            Compr_Off()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp recch.txt 80 pre/sel
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE RECCH.TXT
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSEIF ( tecla == K_F10 )  /* Imprimir Sinttico */
         IF ChkImpr()
            (cArq1)->(DBGOTOP())
            cAviso := MsgImp()
            pg:=0; continua:=.T.
            Gera_TXT("RECCH.TXT")
            CabRel("CHEQUES RECEBIDOS")
            @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
            Compr_On()
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
*                              XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/9999 XXXXXXXXXX  9,999.99  XXXXXXXXXXXXXXX _____________
*                              23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*                                      1         2         3         4         5         6         7         8         9        10
            @ PROW()+1,02 SAY REPLICATE("-",100)
            nValor_c:=0.00
            WHILE !(cArq1)->(EOF())
               Compr_On()
               @ PROW()+1,02 SAY (cArq1)->ALUNO   PICT "@!S40"
               @ PROW()  ,43 SAY (cArq1)->DTVCTO  PICT "@D"
               @ PROW()  ,54 SAY (cArq1)->DOC     PICT "@!"
               @ PROW()  ,66 SAY (cArq1)->VALOR_C PICT "@E 9,999.99"
               @ PROW()  ,76 SAY (cArq1)->BANCO
               @ PROW()  ,92 SAY REPLIC("_",15)
               nValor_c += (cArq1)->VALOR_C
               (cArq1)->(DBSKIP())
               IF PROW()>=57.AND.!EOF()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,68 SAY "Continua..."
                  EJECT; CabRel("CHEQUES RECEBIDOS")
                  @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                  Compr_On()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
                  @ PROW()+1,02 SAY REPLICATE("-",100)
               ENDIF
            ENDDO
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "T O T A L  --->"
            @ PROW()  ,65 SAY nValor_c PICT "@E 99,999.99"
            Compr_Off()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp recch.txt 80 pre/sel
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE RECCH.TXT
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL

*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Extrato              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowLista()
   LOCAL corant:=SETCOLOR(), oBr, oColn,nreg, nSdAntes:=0.00

   SELECT (cArq1); DBGOTOP()
   IF EOF()
      Aviso("Nao houveram matriculas neste perกodo..."); RETURN .F.
   ENDIF

   LinhaMsg(10)
   Telas(2,0,5,79,1,YCOREDIT,.F.)
   @ 03,02 SAY "Listagem por Meio de Procura"
   @ 04,02 SAY "Perกodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(6,0,22,79,1,YCOREDIT,.F.,"Meios de Procura")
   oBr:=TBROWSEDB(7,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec = YCOREDIT

   oCol:=TBCOLUMNNEW("Origem"  ,{|| ORIGEM})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Qtde"    ,{|| TRANSFORM(QTDE,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("%"       ,{|| TRANSFORM(FATIA,"@E 999.99")})
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
           WaitMsg("Fim de Impresso, tecle algo...")
           Mensagem()
        ENDIF
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(2)
  RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Extrato               ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpExtrato()
   LOCAL nReg:=RECNO()
   Gera_TXT("DESPESAS.TXT"); SETPRC(0,0)
   SELECT (cArq1); DBGOTOP()
   pg:=0; continua:=.T.
   CabRel("LISTAGEM DE MATRICULA POR MEIO DE PROCURA")
   @ PROW()+1,02 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   @ PROW()+1,02 SAY REPLICATE("-",78)
   @ PROW()+1,02 SAY "ORIGEM           QTDE       %"
*                     XXXXXXXXXXXXXXX  99.999   999.99
*                     234567890123456789012345678901234567890123456789012345678901234567890123456789
*                             1         2         3         4         5         6         7
   @ PROW()+1,02 SAY REPLICATE("-",78); ntotal:=0
   WHILE continua.AND.!EOF()
      @ PROW()+1,02 SAY ORIGEM   PICT "@!"
      @ PROW()  ,19 SAY QTDE     PICT "@E 99,999"
      @ PROW()  ,28 SAY FATIA    PICT "@E 999.99"
      ntotal += QTDE
      DBSKIP()
   ENDDO
   IF continua
      @ PROW()+1,02 SAY REPLICATE("-",78)
      @ PROW()+1,05 SAY "TOTAL >> "
      @ PROW()  ,19 SAY ntotal  PICT "@E 99,999"
      EJECT
   ENDIF
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp despesas.txt 80 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE PROCURA.TXT
   GO nReg
   RETURN NIL
