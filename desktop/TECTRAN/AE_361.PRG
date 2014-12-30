*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_361                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio por meio de procura            ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 01/02/2005                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"ORIGEM"  ,"C", 14,0})
AADD(aDbf,{"QTDE"    ,"N", 06,0})
AADD(aDbf,{"FATIA"   ,"N", 06,2})
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
INDEX ON ORIGEM TO (cArq1)

SELECT 1
IF NetUse("DBALU","ALUNO")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU3           // data de inscricao
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE361";ProgName("AE361"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "61"
SET KEY -1 TO Mostra()

WHILE .T.
   GeraMeio()  // Arquivo temporario

   wPerIni:=wPerFim:=CTOD("")
   v1:=v2:=v3:=v4:=v5:=v6:=v7:=v8:=v9:=v10:=vtot:=0
   SETCOLOR(YCOREDIT)
   Telas(16,3,20,30,1,YCOREDIT,.T.)
   @ 17,05 SAY "*** Matrกcula ***"
   @ 18,05 SAY "Data Inicio:" GET wPerIni PICT "@D" WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
   @ 19,05 SAY "Data  Final:" GET wPerFim PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni.AND.wPerFim<=DATE()
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   Aguarde("Selecionando...")
   ALUNO->(DBSEEK(wPerIni))
   IF ALUNO->(EOF()); ALUNO->(DBGOTOP()); ENDIF
   WHILE !ALUNO->(EOF())
      IF ALUNO->DTINSCR>=wPerIni.AND.ALUNO->DTINSCR<=wPerFim
         IF ALUNO->PESQ=="1"
            ++v1
         ELSEIF ALUNO->PESQ=="2"
            ++v2
         ELSEIF ALUNO->PESQ=="3"
            ++v3
         ELSEIF ALUNO->PESQ=="4"
            ++v4
         ELSEIF ALUNO->PESQ=="5"
            ++v5
         ELSEIF ALUNO->PESQ=="6"
            ++v6
         ELSEIF ALUNO->PESQ=="7"
            ++v7
         ELSEIF ALUNO->PESQ=="8"
            ++v8
         ELSEIF ALUNO->PESQ=="9"
            ++v9
         ELSEIF ALUNO->PESQ=="0"
            ++v10
         ENDIF
         ++vtot
      ENDIF
      ALUNO->(DBSKIP())
   ENDDO
   (cArq1)->(DBGOTOP())
   FOR i = 1 to 9
      xVar:= "v" + STRZERO(i,1)
      REPLACE (cArq1)->QTDE  WITH &xVar
      REPLACE (cArq1)->FATIA WITH (&xVar/vtot)*100
      (cArq1)->(DBSKIP())
   NEXT
   REPLACE (cArq1)->QTDE  WITH v10
   REPLACE (cArq1)->FATIA WITH (v10/vtot)*100
   Aguarde()
   BrowLista()
   (cArq1)->(__DBZAP())
   Rest_Tela()
ENDDO
DelDbfNtx(); RETURN
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
   Gera_TXT("PROCURA.TXT"); SETPRC(0,0)
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
   RUN nodosimp procura.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE PROCURA.TXT
   GO nReg
   RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Gerar Meios de Procura         ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION GeraMeio()
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "01. INDICACAO"
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "02. PANFLETO "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "03. ONIBUS   "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "04. TELELISTA"
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "05. EDITEL   "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "06. OUTDOOR  "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "07. INTERNET "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "08. TV/RADIO "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "09. JORNAL   "
  (cArq1)->(DBAPPEND())
  REPLACE (cArq1)->ORIGEM WITH "10. OUTROS   "
RETURN
