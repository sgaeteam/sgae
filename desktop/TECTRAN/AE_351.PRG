*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_351                           vrs 001 ณ
*ณ FINALIDADE     : Relatorio Analitico dos Consumos         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 24/01/1997                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"DATACON"  ,"D",   08,0}) /* Data do Consumo          */
AADD(aDbf,{"DESCR"    ,"C",   30,0}) /* Descricao do Lanamento  */
AADD(aDbf,{"FAVOR"    ,"C",   30,0}) /* Descricao do Favorecido  */
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
INDEX ON DTOS(datacon) TO (cArq1)

SELECT 5
IF NetUse("DBINST","INSTRUTOR")         /* Cadastro de Instrutores */
   SET INDEX TO DBINST1
ELSE
   DelDbfNtx(); RETURN
ENDIF

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
IF NetUse("DBLCON","CONSUMO")      /* Arq.Lanamento de Consumos */
   SET INDEX TO DBILCON2,DBILCON1
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE351"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "51"

Telas(12,20,17,54,1,YCOREDIT,.T.)
wOp1:=wOp2:=wDevice:=" ";wPini:=wPfim:=CTOD("");wVei:=SPACE(2)
SETCOLOR(YCOREDIT)
@ 13,22 SAY "Perกodo:          a"
@ 14,22 SAY "Veกculo: 99"
@ 15,20 SAY "ร"+REPLI("ฤ",33)+"ด"

SET KEY -1 TO Mostra()
WHILE .T.
   Mensagem("Informe os Campos");SETCOLOR(YCOREDIT)
   @ 13,31 GET wPini PICT "@D" VALID (LASTKEY()==K_UP).OR.!EMPTY(wPini)
   @ 13,42 GET wPfim PICT "@D" VALID (LASTKEY()==K_UP).OR.wPini<=wPfim.AND.wPfim<=DATE()
   @ 14,31 GET wVei  PICT "99" VALID !EMPTY(wVei)
   @ 16,22 SAY "Saกda:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   CONSUMO->(DBSEEK(DTOS(wPini),.T.))
   IF CONSUMO->DATACON>wPfim
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
ENDDO
RELEASE continua, nPg
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpRel()
   Gera_TXT("CONSUMO1.TXT"); SETPRC(0,0)
   pg := 0; continua := .T.
   WHILE CONSUMO->DATACON<=wPfim.AND.!CONSUMO->(EOF())
      IF CONSUMO->CODVEIC==wVei
         TABCON->(DBSEEK(CONSUMO->CODCON))
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                 (cArq1)->VALOR   WITH CONSUMO->VALOR,;
                 (cArq1)->DATACON WITH CONSUMO->DATACON,;
                 (cArq1)->FAVOR   WITH CONSUMO->FAVOR,;
                 (cArq1)->DESCR   WITH CONSUMO->DESCR
      ENDIF
      CONSUMO->(DBSKIP())
   ENDDO
   (cArq1)->(DBGOTOP()); xSomaTot:=0.00
   CabRel()
   WHILE !(cArq1)->(EOF())
      Compr_On()
      Cab_ESC(01,002,(cArq1)->DATACON)
      Cab_ESC(00,011,(cArq1)->DESCR)
      Cab_ESC(00,042,(cArq1)->VALOR,["@E 999,999.99"])
      Cab_ESC(00,054,(cArq1)->CONSUMO)
      Cab_ESC(00,086,(cArq1)->FAVOR)
      xSomaTot += (cArq1)->VALOR
      IF PROW()>57.AND.!(cArq1)->(EOF())
         @ PROW()+1,002 SAY REPLICATE("-",128)
         @ PROW()+1,002 SAY "S U B T O T A L   ---->"
         @ PROW()  ,042 SAY xSomaTot PICT "@E 999,999.99"
         EJECT; CabRel()
      ENDIF
      (cArq1)->(DBSKIP())
   ENDDO
   IF continua
      @ PROW()+1,002 SAY REPLICATE("_",128)
      @ PROW()+1,002 SAY "T O T A L   ---->"
      @ PROW()  ,042 SAY xSomaTot PICT "@E 999,999.99"
      EJECT
   ENDIF
   Compr_Off()
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp consumo1.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CONSUMO1.TXT
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
   @ PROW()  ,002 SAY "RELATORIO DE CUSTOS DE MANUTENCAO DO VEICULO"
   @ PROW()+2,002 SAY "PERIODO: "+ExtMes(wPini)+"/"+SUBS(DTOC(wPini),7,2)+" a "+ExtMes(wPfim)+"/"+SUBS(DTOC(wPfim),7,2)
   Compr_On()
   VEICULO->(DBSEEK(wVei))
   INSTRUTOR->(DBSEEK(VEICULO->CODINST))
   @ PROW()+2,002 SAY VEICULO->MARCA
   @ PROW()  ,050 SAY "Instrutor -> "+INSTRUTOR->NOME
   @ PROW()+1,002 SAY REPLICATE("-",128)
   @ PROW()+1,002 SAY "DATA     DESCRICAO                           VALOR  CONSUMO                         FAVORECIDO"
*                      99/99/99 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 999,999.99  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
*                      23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                              1         2         3         4         5         6         7         8         9        10        11        12
   @ PROW()+1,002 SAY REPLICATE("-",128)
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol

   Aguarde("Calculando...")
   WHILE CONSUMO->DATACON<=wPfim.AND.!CONSUMO->(EOF())
      IF CONSUMO->CODVEIC==wVei
         TABCON->(DBSEEK(CONSUMO->CODCON))
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->CONSUMO WITH TABCON->DESCR,;
                 (cArq1)->VALOR   WITH CONSUMO->VALOR,;
                 (cArq1)->DATACON WITH CONSUMO->DATACON,;
                 (cArq1)->FAVOR   WITH CONSUMO->FAVOR,;
                 (cArq1)->DESCR   WITH CONSUMO->DESCR
      ENDIF
      CONSUMO->(DBSKIP())
   ENDDO
   Aguarde()

   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.)
   VEICULO->(DBSEEK(wVei))
   @ 03,02 SAY "VEICULO: "+VEICULO->MARCA
   oBr:=TBROWSEDB(4,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Data",{|| DATACON})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Descriฦo",{|| DESCR})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR,"@E 999,999.99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Consumo",{|| CONSUMO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Favorecido",{|| FAVOR})
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
