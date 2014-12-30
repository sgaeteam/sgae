*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_350                           vrs 001 ณ
*ณ FINALIDADE     : Relatorio de Consumos de Veกculos        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 18/12/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Veiculo        */
AADD(aDbf,{"CODCON"   ,"C",   02,0}) /* Codigo do Consumo        */
AADD(aDbf,{"CONSUMO"  ,"C",   30,0}) /* Descricao do Consumo     */
AADD(aDbf,{"VALOR"    ,"N",   09,2}) /* Valor Consumido          */
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
INDEX ON codcon TO (cArq1)

SELECT 3
IF NetUse("DBTCON","TABCON")       /* Tabela de Consumos */
   SET INDEX TO DBICON1,DBICON2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")      /* Cadastro de Veกculos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBRCON","RESUMO")      /* Arq.Resumo de Consumos */
   SET INDEX TO DBIRCON2,DBIRCON1
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE350"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "50"

Telas(10,20,17,52,1,YCOREDIT,.T.)
wOp1:=wOp2:=wDevice:=" ";wPini:=wPfim:=SPACE(6);wVei:=SPACE(2)
SETCOLOR(YCOREDIT)
@ 11,22 SAY "(   )  Individual"
@ 12,22 SAY "(   )  Geral"
@ 13,22 SAY "Perกodo:         a"
@ 14,22 SAY "Veกculo: 99"
@ 15,20 SAY "ร"+REPLI("ฤ",31)+"ด"

SET KEY -1 TO Mostra()
WHILE .T.
   Mensagem("Marque com um X para Selecionar. Informe mes/ano consumo");SETCOLOR(YCOREDIT)
   @ 11,24 GET wOp1  PICT "!" WHEN EMPTY(wOp2) VALID wOp1 $ "X "
   @ 12,24 GET wOp2  PICT "!" WHEN EMPTY(wOp1) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X"
   @ 13,31 GET wPini PICT "@R 99/9999" VALID (LASTKEY()==K_UP).OR.TPini(wPini)
   @ 13,41 GET wPfim PICT "@R 99/9999" VALID (LASTKEY()==K_UP).OR.TPini(wPfim).AND.TPer(wPini,wPfim)
   @ 14,31 GET wVei  PICT "99" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.) VALID !EMPTY(wVei)
   @ 16,22 SAY "Saกda:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   IF RESUMO->(DBSEEK(wPini,.T.))
      IF CTOD("01/"+SUBS(RESUMO->MESANO,1,2)+"/"+SUBS(RESUMO->MESANO,3,4))>CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,3,4))
         Aviso("Nฦo houve movimento de consumo neste perกodo.",,3); LOOP
      ENDIF

      IF wDevice=="I"
         IF ChkImpr()
            cAviso := MsgImp()
            ImpRel()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
         BrowCad()
      ENDIF
   ELSE
      Aviso("Nฦo houve movimento de consumo neste perกodo.",,3)
   ENDIF
ENDDO
RELEASE continua, nPg
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpRel()
   Gera_TXT("CONSUMO.TXT"); SETPRC(0,0)
   pg := 0; continua := .T.
   CabRel()
   IF !EMPTY(wOp1)    /* Individual */
      WHILE CTOD("01/"+SUBS(RESUMO->MESANO,1,2)+"/"+SUBS(RESUMO->MESANO,3,2))<=CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,3,2));
         .AND. !RESUMO->(EOF())
         IF RESUMO->CODVEIC==wVei
            IF !(cArq1)->(DBSEEK(RESUMO->CODCON))
               TABCON->(DBSEEK(RESUMO->CODCON))
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                       (cArq1)->VALOR   WITH RESUMO->VALOR,;
                       (cArq1)->CODCON  WITH RESUMO->CODCON
            ELSE
               REPLACE (cArq1)->VALOR   WITH (cArq1)->VALOR+RESUMO->VALOR
            ENDIF
         ENDIF
         RESUMO->(DBSKIP())
      ENDDO
   ELSE    /* Geral */
      WHILE CTOD("01/"+SUBS(RESUMO->MESANO,1,2)+"/"+SUBS(RESUMO->MESANO,3,2))<=CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,3,2));
         .AND. !RESUMO->(EOF())
         IF !(cArq1)->(DBSEEK(RESUMO->CODCON))
            TABCON->(DBSEEK(RESUMO->CODCON))
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                    (cArq1)->VALOR   WITH RESUMO->VALOR,;
                    (cArq1)->CODCON  WITH RESUMO->CODCON
         ELSE
            REPLACE (cArq1)->VALOR   WITH (cArq1)->VALOR+RESUMO->VALOR
         ENDIF
         RESUMO->(DBSKIP())
      ENDDO
   ENDIF
   (cArq1)->(DBGOTOP()); xSomaTot:=0.00
   WHILE !(cArq1)->(EOF())
      Compr_On()
      Cab_ESC(01,002,(cArq1)->CONSUMO)
      Cab_ESC(00,034,(cArq1)->VALOR,["@E 999,999.99"])
      xSomaTot += (cArq1)->VALOR
      (cArq1)->(DBSKIP())
   ENDDO
   IF continua
      @ PROW()+1,002 SAY REPLICATE("_",130)
      @ PROW()+1,002 SAY "T O T A L   ---->"
      @ PROW()  ,034 SAY xSomaTot PICT "@E 999,999.99"
      EJECT
   ENDIF
   Compr_Off()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp consumo.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CONSUMO.TXT
   (cArq1)->(__DBZAP())
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY DATE()
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "RELATORIO DE CUSTOS DE MANUTENCAO DO VEICULO"
   @ PROW()+2,002 SAY "PERIODO: "+SUBS(ExtMes(CTOD("01/"+SUBS(wPini,1,2)+"/"+SUBS(wPini,4,4))),1,3)+"/"+SUBS(wPini,3,4)+;
     " a "+SUBS(ExtMes(CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,4,4))),1,3)+"/"+SUBS(wPfim,3,4)
   Compr_On()
   VEICULO->(DBSEEK(wVei))
   @ PROW()+2,002 SAY IF(!EMPTY(wOp1),"VEICULO:","TODOS OS VEICULOS")
   @ PROW()  ,011 SAY IF(!EMPTY(wOp1),VEICULO->MARCA,"")
   @ PROW()+1,002 SAY REPLICATE("_",130)
   @ PROW()+1,002 SAY "CONSUMO                              VALOR"
   @ PROW()+1,002 SAY REPLICATE("_",130)
   RETURN
/*
Montagem do Lay-Out do Relatorio
        1         2         3         4         5         6         7         8         9        10        11        12        13
234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

PERIODO: XXX/9999 a XXX/9999
---------------------------------------------------------------------------------------------------------------------------------
VEICULO:
=================================================================================================================================
*/
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   Aguarde("Calculando...")
   IF !EMPTY(wOp1)    /* Individual */
      WHILE CTOD("01/"+SUBS(RESUMO->MESANO,1,2)+"/"+SUBS(RESUMO->MESANO,3,4))<=CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,3,4));
         .AND. !RESUMO->(EOF())
         IF RESUMO->CODVEIC==wVei
            IF !(cArq1)->(DBSEEK(RESUMO->CODCON))
               TABCON->(DBSEEK(RESUMO->CODCON))
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                       (cArq1)->VALOR   WITH RESUMO->VALOR,;
                       (cArq1)->CODVEIC WITH RESUMO->CODVEIC,;
                       (cArq1)->CODCON  WITH RESUMO->CODCON
            ELSE
               REPLACE (cArq1)->VALOR   WITH (cArq1)->VALOR+RESUMO->VALOR
            ENDIF
         ENDIF
         RESUMO->(DBSKIP())
      ENDDO
   ELSE    /* Geral */
      WHILE CTOD("01/"+SUBS(RESUMO->MESANO,1,2)+"/"+SUBS(RESUMO->MESANO,3,4))<=CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,3,4));
         .AND. !RESUMO->(EOF())
         IF !(cArq1)->(DBSEEK(RESUMO->CODCON))
            TABCON->(DBSEEK(RESUMO->CODCON))
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                    (cArq1)->VALOR   WITH RESUMO->VALOR,;
                    (cArq1)->CODVEIC WITH RESUMO->CODVEIC,;
                    (cArq1)->CODCON  WITH RESUMO->CODCON
         ELSE
            REPLACE (cArq1)->VALOR   WITH (cArq1)->VALOR+RESUMO->VALOR
         ENDIF
         RESUMO->(DBSKIP())
      ENDDO
   ENDIF
   Aguarde()

   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCOREDIT)
   Telas(2,0,22,79,1,YCOREDIT,.F.)
   IF wOp2=="X"
      @ 03,02 SAY "TODOS OS VEICULOS"
   ELSE
      VEICULO->(DBSEEK(wVei))
      @ 03,02 SAY "VEICULO: "+VEICULO->MARCA
   ENDIF
   @ 03,40 SAY "PERIODO: "+SUBS(ExtMes(CTOD("01/"+SUBS(wPini,1,2)+"/"+SUBS(wPini,4,4))),1,3)+"/"+SUBS(wPini,3,4)+;
     " a "+SUBS(ExtMes(CTOD("01/"+SUBS(wPfim,1,2)+"/"+SUBS(wPfim,4,4))),1,3)+"/"+SUBS(wPfim,3,4)
   @ 04,00 SAY "ร"+REPL("ฤ",78)+"ด"
   oBr:=TBROWSEDB(5,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCOREDIT

   IF wOp2=="X"
      oCol:=TBCOLUMNNEW("Veกculo" ,{|| TRANSFORM(PegaVeic(CODVEIC),"@S20")})
      oBr:addColumn(oCol)
   ENDIF
   oCol:=TBCOLUMNNEW("Consumo" ,{|| CONSUMO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor"   ,{|| TRANSFORM(VALOR,"@E 999,999.99")})
   oBr:addColumn(oCol)

   oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  (cArq1)->(__DBZAP())
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
*ีอออออออออออออออออออออออออออออออออธ
*ณ Testar Periodo Inicial          ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TPini(pPer)
   IF VAL(SUBS(pPer,1,2))>12
      Aviso("Ms Inv lido...",,3); RETURN .F.
   ENDIF
   RETURN .T.
*ีอออออออออออออออออออออออออออออออออธ
*ณ Testar Periodos                 ณ
*ิอออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TPer(pPer1,pPer2)
   pPer1 := CTOD("01/"+SUBS(pPer1,1,2)+"/"+SUBS(pPer1,3,4))
   pPer2 := CTOD("01/"+SUBS(pPer2,1,2)+"/"+SUBS(pPer2,3,4))
   IF pPer1>pPer2
      Aviso("Data final deve ser maior que a inicial...",,3); RETURN .F.
   ENDIF
   RETURN .T.
