*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_304                           vrs 001 ≥
*≥ FINALIDADE     : Estatisticos                             ≥
*≥ PROGRAMADOR    : Matriculas por periodo                   ≥
*≥ DATA CRIACAO   : 15/06/2004                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Nß da matricula            */
AADD(aDbf,{"ALUNO"    ,"C",   50,0}) /* Aluno                      */
AADD(aDbf,{"DTINSCR"  ,"D",   08,0}) /* Data da matricula          */
AADD(aDbf,{"VALOR"    ,"N",   10,2}) /* Valor Pago Matricula       */
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
INDEX ON aluno TO (cArq1)

SELECT 1
IF NetUse("DBALU","ALUNOS")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU3
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE304"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "01"

Quadro(13,20,18,55,1,YCOREDIT,.T.,,.T.)
wDtInic:=wDtFim:=CTOD(""); wDevice:=" "; wValor:=0.00
SETCOLOR(YCOREDIT)
@ 14,22 SAY "Per°odo:            a"
@ 15,20 SAY "√"+REPLI("ƒ",34)+"¥"

WHILE .T.
   nMatric:=nMatrTot:=nAprov1:=nAprov2:=nCertif1:=nCertif2:=nReprov:=nDesiste:=0
   @ 14,31 GET wDtInic PICT "@D" VALID !EMPTY(wDtInic)
   @ 14,44 GET wDtFim  PICT "@D" VALID (LASTKEY()==K_UP).OR.wDtFim>=wDtInic
   @ 16,22 SAY "Valor M°nimo:" GET wValor  PICT "@E 99,999.99"
   @ 17,22 SAY "Sa°da.......:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   SET SOFTSEEK ON
   ALUNOS->(DBSEEK(DTOS(wDtInic),.T.))
   SET SOFTSEEK OFF
   IF ALUNOS->(EOF())
      Aviso("N∆o h† alunos matriculados neste per°odo!"); LOOP
   ENDIF

   Aguarde("Calculando...")
   WHILE ALUNOS->DTINSCR>=wDtInic.AND.ALUNOS->DTINSCR<=wDtFim.AND.!ALUNOS->(EOF())
      IF ALUNOS->VALOR>=wValor
         nMatric++
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->MATRIC   WITH ALUNOS->MATRIC  ,;
                 (cArq1)->ALUNO    WITH ALUNOS->NOME    ,;
                 (cArq1)->DTINSCR  WITH ALUNOS->DTINSCR ,;
                 (cArq1)->VALOR    WITH ALUNOS->VALOR
      ENDIF
      nMatrTot++
      ALUNOS->(DBSKIP())
   ENDDO
   Aguarde()

   IF wDevice=="I"
      IF ChkImpr()
         cAviso := MsgImp()
         ImpRel()
         TiraMsgImp(cAviso)
         WaitMsg("Fim de Impress∆o, tecle algo...")
      ENDIF
   ELSE
      Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
      BrowCad()
   ENDIF
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Relatorio                    ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION ImpRel()
   LOCAL nTotal:=(cArq1)->(LASTREC())
   Gera_TXT("RELMATR.TXT"); SETPRC(0,0)
   (cArq1)->(DBGOTOP())
   @ PROW()+3,05 SAY PADC("ALUNOS MATRICULADOS",75)
   IF MONTH(wDtInic)==MONTH(wDtFim).AND.YEAR(wDtInic)==YEAR(wDtFim)
      @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4),75)
   ELSE
      @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4)+" a "+UPPER(ExtMes(wDtFim))+"/"+STR(YEAR(wDtFim),4),75)
   ENDIF
   @ PROW()+1,05 SAY "⁄ƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø"
   @ PROW()+1,05 SAY "≥ Nr. ≥         N O M E   D O   A L U N O            ≥ MATR.≥   DATA   ≥"
   @ PROW()+1,05 SAY "√ƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥"
*                       999   XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXX  99999 99/99/9999
*                     56789012345678901234567890123456789012345678901234567890123456789012345678
*                          1         2         3         4         5         6         7
   nNr:=0
   WHILE !(cArq1)->(EOF())
      @ PROW()+1,05 SAY "≥"
      @ PROW()  ,07 SAY STRZERO(++nNr,3)
      @ PROW()  ,11 SAY "≥"
      @ PROW()  ,13 SAY (cArq1)->ALUNO   PICT "@S45"
      @ PROW()  ,58 SAY "≥"
      @ PROW()  ,60 SAY (cArq1)->MATRIC
      @ PROW()  ,65 SAY "≥"
      @ PROW()  ,66 SAY (cArq1)->DTINSCR PICT "@D"
      @ PROW()  ,76 SAY "≥"
      (cArq1)->(DBSKIP())
      IF !(cArq1)->(EOF()).AND.PROW()>57
         @ PROW()+1,05 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         @ PROW()+3 ,05 SAY PADC("ALUNOS MATRICULADOS",75)
         IF MONTH(wDtInic)==MONTH(wDtFim).AND.YEAR(wDtInic)==YEAR(wDtFim)
            @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4),75)
         ELSE
            @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4)+" a "+UPPER(ExtMes(wDtFim))+"/"+STR(YEAR(wDtFim),4),75)
         ENDIF
         @ PROW()+1,05 SAY "⁄ƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒø"
         @ PROW()+1,05 SAY "≥ Nr. ≥         N O M E   D O   A L U N O            ≥ MATR.≥   DATA   ≥"
         @ PROW()+1,05 SAY "√ƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒ¥"
      ENDIF
   ENDDO
   @ PROW()+1,05 SAY "√ƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒ¥"
   @ PROW()+1,05 SAY "≥ TOTAL DE ALUNOS MATRICULADOS                       ≥"
*                     567890123456789012345678901234567890123456789012345678901234567890123456789
*                          1         2         3         4         5         6         7
   @ PROW()  ,64 SAY nNr PICT "@E 99,999"
   @ PROW()  ,76 SAY "≥"
   @ PROW()+1,05 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
   @ PROW()+3,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp relmatr.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE RELMATR.TXT
   RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Browse do Cadastro             ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCORGERAL)
   Telas(2,0,19,79,1,YCORGERAL,.F.,"ALUNOS MATRICULADOS EM "+DTOC(wDtInic)+" a "+DTOC(wDtFim))
   Telas(20,0,22,79,1,YCORGERAL,.F.)
   @ 21,05 SAY "ALUNOS MATRICULADOS->              ALUNOS REGISTRADOS->"
   @ 21,27 SAY nMatric  PICT "@E 99,999"
   @ 21,62 SAY nMatrTot PICT "@E 99,999"
   oBr:=TBROWSEDB(3,1,18,78)
   oBr:headSep:="ƒ¬ƒ"
   oBr:colSep:= " ≥ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Matr°cula"    ,{|| MATRIC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aluno"        ,{|| ALUNO})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Data"         ,{|| DTINSCR})
   oBr:addColumn(oCol)
   IF nNivel>=5
      oCol:=TBCOLUMNNEW("Valor"     ,{|| TRANSFORM(VALOR,"@R 9,999.99")})
      oBr:addColumn(oCol)
   ENDIF

*  oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  // Imprime
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpRel()
            WHILE Confirma("Outra C¢pia ?")
               ImpRel()
            ENDDO
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress∆o, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(2)
  RETURN NIL
