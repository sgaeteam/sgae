*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_305                           vrs 001 ³
*³ FINALIDADE     : Estatisticos                             ³
*³ PROGRAMADOR    : Aniversariantes                          ³
*³ DATA CRIACAO   : 15/06/2004                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* N§ da matricula            */
AADD(aDbf,{"ALUNO"    ,"C",   50,0}) /* Aluno                      */
AADD(aDbf,{"DTANIV"   ,"C",   04,0}) /* Dia/mes Aniversario        */
AADD(aDbf,{"FONE_R"   ,"C",   10,0}) /* Fone residencial           */
AADD(aDbf,{"FONE_C"   ,"C",   10,0}) /* Fone comercial             */
AADD(aDbf,{"CELULAR"  ,"C",   08,0}) /* Celular                    */
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
INDEX ON dtaniv+aluno TO (cArq1)

SELECT 4
IF NetUse("DBPROG","AULAS")            /* Arquivo de Programa‡Æo de Aulas */
   SET INDEX TO DBIPRO1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBALU","ALUNOS")           /* Cadastro de Alunos */
   INDEX ON SUBS(DTOC(DTNAS),1,2)+SUBS(DTOC(DTNAS),4,2) TO DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE305"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "01"

Quadro(13,20,17,45,1,YCOREDIT,.T.,,.T.)
wDtInic:=SPACE(4); wDevice:=" "
SETCOLOR(YCOREDIT)
@ 14,22 SAY "Dia/Mˆs:       "
@ 15,20 SAY "Ã"+REPLI("Ä",24)+"´"

WHILE .T.
   @ 14,31 GET wDtInic PICT "@R 99/99" VALID !EMPTY(wDtInic)
   @ 16,22 SAY "Sa¡da:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   SET SOFTSEEK ON
   ALUNOS->(DBSEEK(wDtInic,.T.))
   SET SOFTSEEK OFF
   IF ALUNOS->(EOF())
      Aviso("NÆo h  alunos aniversariando na data informada."); LOOP
   ENDIF

   Aguarde("Pesquisando...")
   xCond:="SUBS(DTOC(ALUNOS->DTNAS),1,2)=LEFT(wDtInic,2).AND.SUBS(DTOC(ALUNOS->DTNAS),4,2)=RIGHT(wDtinic,2)"
   WHILE !ALUNOS->(EOF())
      IF (&xCond)
         // Verificar se aluno ainda ‚ ativo
         IF AlunoAtivo(ALUNOS->MATRIC)
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->MATRIC   WITH ALUNOS->MATRIC  ,;
                    (cArq1)->ALUNO    WITH ALUNOS->NOME    ,;
                    (cArq1)->DTANIV   WITH SUBS(DTOC(ALUNOS->DTNAS),1,2)+SUBS(DTOC(ALUNOS->DTNAS),4,2),;
                    (cArq1)->FONE_R   WITH ALUNOS->FONE_R  ,;
                    (cArq1)->FONE_C   WITH ALUNOS->FONE_C  ,;
                    (cArq1)->CELULAR  WITH ALUNOS->CELULAR
         ENDIF
      ENDIF
      ALUNOS->(DBSKIP())
   ENDDO
   Aguarde()

   IF wDevice=="I"
      IF ChkImpr()
         cAviso := MsgImp()
         ImpRel()
         TiraMsgImp(cAviso)
         WaitMsg("Fim de ImpressÆo, tecle algo...")
      ENDIF
   ELSE
      Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
      BrowCad()
   ENDIF
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Relatorio                    ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION ImpRel()
   LOCAL nTotal:=(cArq1)->(LASTREC())
   Gera_TXT("ANIVER.TXT"); SETPRC(0,0)
   (cArq1)->(DBGOTOP())
   @ PROW()+1,05 SAY PADC("ALUNOS ANIVERSARIANTES",75)
   @ PROW()+3,05 SAY PADC("DIA/MES",75)
   @ PROW()+1,05 SAY PADC(UPPER(ExtMes(CTOD(LEFT(wDtInic,2)+"/"+RIGHT(wDtInic,2)+"/"+STR(YEAR(DATE()),4))))+"/"+STR(YEAR(DATE()),4),75)
   @ PROW()+3,05 SAY "ÚÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ PROW()+1,05 SAY "³ Nr. ³         N O M E   D O   A L U N O            ³  ANIVERSARIO ³"
   @ PROW()+1,05 SAY "ÃÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
*                             XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXX                                                  99/99
*                     56789012345678901234567890123456789012345678901234567890123456789012345
*                          1         2         3         4         5         6         7
   nNr:=0
   WHILE !(cArq1)->(EOF())
      @ PROW()+1,05 SAY "³"
      @ PROW()  ,07 SAY STRZERO(++nNr,3)
      @ PROW()  ,11 SAY "³"
      @ PROW()  ,13 SAY ALUNO  PICT "@S44"
      @ PROW()  ,58 SAY "³"
      @ PROW()  ,61 SAY DTANIV PICT "@R 99/99"
      @ PROW()  ,73 SAY "³"
      (cArq1)->(DBSKIP())
      IF !(cArq1)->(EOF()).AND.PROW()>57
         @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         @ PROW()+3 ,05 SAY PADC("ALUNOS ANIVERSARIANTES",75)
         @ PROW()+4,05 SAY PADC("DIA/MES",75)
         @ PROW()+1,05 SAY PADC(UPPER(ExtMes(CTOD(LEFT(wDtInic,2)+RIGHT(wDtInic,2)+STR(YEAR(DATE()),4))))+"/"+STR(YEAR(DATE()),4),75)
         @ PROW()+3,05 SAY "ÚÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
         @ PROW()+1,05 SAY "³ Nr. ³         N O M E   D O   A L U N O            ³   MATRICULA  ³"
         @ PROW()+1,05 SAY "ÃÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
      ENDIF
   ENDDO
   @ PROW()+1,05 SAY "ÃÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
   @ PROW()+1,05 SAY "³                            ANIVERSARIANTES ->      ³"
*                     567890123456789012345678901234567890123456789012345678901234567890123456789
*                          1         2         3         4         5         6         7
   @ PROW()  ,64 SAY nNr PICT "@E 99,999"
   @ PROW()  ,73 SAY "³"
   @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ PROW()+3,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp aniver.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE ANIVER.TXT
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Browse do Cadastro             ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCORGERAL)
   Telas(2,0,19,79,1,YCORGERAL,.F.,"ALUNOS ANIVERSARIANTES EM "+LEFT(wDtInic,2)+"/"+RIGHT(wDtInic,2))
   Telas(20,0,22,79,1,YCORGERAL,.F.)
   @ 21,05 SAY "TOTAL DE ALUNOS ->"
   @ 21,26 SAY LASTREC() PICT "@E 99,999"
   oBr:=TBROWSEDB(3,1,18,78)
   oBr:headSep:="ÄÂÄ"
   oBr:colSep:= " ³ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Dt.Aniv"      ,{|| LEFT(DTANIV,2)+"/"+RIGHT(DTANIV,2)})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matr¡cula"    ,{|| MATRIC})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aluno"        ,{|| TRANSFORM(ALUNO,"@S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Resid."  ,{|| TRANSFORM(FONE_R,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Coml."   ,{|| TRANSFORM(FONE_C,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Celular"      ,{|| TRANSFORM(CELULAR,"@R 9999-9999")})
   oBr:addColumn(oCol)

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
            WaitMsg("Fim de ImpressÆo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(2)
  RETURN NIL
