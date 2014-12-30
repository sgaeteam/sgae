*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_303                           vrs 001 ³
*³ FINALIDADE     : Estatisticos                             ³
*³ PROGRAMADOR    : Certificados Expedidos                   ³
*³ DATA CRIACAO   : 31/01/2001                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"CLASSE"   ,"C",   01,0}) /* Teorico ou Pratico        */
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Aluno                     */
AADD(aDbf,{"CERTIF"   ,"C",   10,0}) /* Numero do Certificado     */
AADD(aDbf,{"VIA"      ,"C",   01,0}) /* Numero da Via             */
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
INDEX ON classe+nome TO (cArq1)

SELECT 1
IF NetUse("DBCERT","CERTIF")             /* Certificados */
   SET INDEX TO DBICERT1
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE303"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "01"

Quadro(13,20,17,55,1,YCOREDIT,.T.,,.T.)
wDtInic:=wDtFim:=CTOD(""); wDevice:=" "
SETCOLOR(YCOREDIT)
@ 14,22 SAY "Per¡odo:            a"
@ 15,20 SAY "Ã"+REPLI("Ä",34)+"´"

WHILE .T.
   nCert:=nCTeor:=nCPratC:=nCPratM:=0
   @ 14,31 GET wDtInic PICT "@D" VALID !EMPTY(wDtInic)
   @ 14,44 GET wDtFim  PICT "@D" VALID (LASTKEY()==K_UP).OR.wDtFim>=wDtInic
   @ 16,22 SAY "Sa¡da:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   Aguarde("Pesquisando...")
   CERTIF->(DBGOTOP())
   WHILE !CERTIF->(EOF())
      lVia1:=lVia2:=lVia3:=.F.
      IF !EMPTY(CERTIF->DTEM1).OR.!EMPTY(CERTIF->DTEM11).OR.!EMPTY(CERTIF->DTEM111)
         IF (lVia1:=CERTIF->DTEM1>=wDtInic.AND.CERTIF->DTEM1<=wDtFim).OR.;
            (lVia2:=CERTIF->DTEM11>=wDtInic.AND.CERTIF->DTEM11<=wDtFim).OR.;
            (lVia3:=CERTIF->DTEM111>=wDtInic.AND.CERTIF->DTEM111<=wDtFim)

            // Certificado Teorico
            nCert++
            nCTeor++

            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME    WITH CERTIF->NOME   ,;
                    (cArq1)->CERTIF  WITH CERTIF->CERTIF1,;
                    (cArq1)->VIA     WITH IF(lVia1,"1",IF(lVia2,"2","3")),;
                    (cArq1)->CLASSE  WITH "T"
         ENDIF
      ENDIF

      IF !EMPTY(CERTIF->DTEM2).OR.!EMPTY(CERTIF->DTEM22).OR.!EMPTY(CERTIF->DTEM222)
         IF (lVia1:=CERTIF->DTEM2>=wDtInic.AND.CERTIF->DTEM2<=wDtFim).OR.;
            (lVia2:=CERTIF->DTEM22>=wDtInic.AND.CERTIF->DTEM22<=wDtFim).OR.;
            (lVia3:=CERTIF->DTEM222>=wDtInic.AND.CERTIF->DTEM222<=wDtFim)

            // Certificado Pratico Carro
            nCert++
            nCPratC++
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME    WITH CERTIF->NOME   ,;
                    (cArq1)->CERTIF  WITH CERTIF->CERTIF2,;
                    (cArq1)->VIA     WITH IF(lVia1,"1",IF(lVia2,"2","3")),;
                    (cArq1)->CLASSE  WITH "P"
         ENDIF
      ENDIF

      IF !EMPTY(CERTIF->DTEM3).OR.!EMPTY(CERTIF->DTEM33).OR.!EMPTY(CERTIF->DTEM333)
         IF (lVia1:=CERTIF->DTEM3>=wDtInic.AND.CERTIF->DTEM3<=wDtFim).OR.;
            (lVia2:=CERTIF->DTEM33>=wDtInic.AND.CERTIF->DTEM33<=wDtFim).OR.;
            (lVia3:=CERTIF->DTEM333>=wDtInic.AND.CERTIF->DTEM333<=wDtFim)

            // Certificado Pratico Moto
            nCert++
            nCPratC++
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME    WITH CERTIF->NOME   ,;
                    (cArq1)->CERTIF  WITH CERTIF->CERTIF3,;
                    (cArq1)->VIA     WITH IF(lVia1,"1",IF(lVia2,"2","3")),;
                    (cArq1)->CLASSE  WITH "P"
         ENDIF
      ENDIF
      CERTIF->(DBSKIP())
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
   LOCAL nCert:=0, xClasse:=" "
   Gera_TXT("CERTIF.TXT"); SETPRC(0,0)
   (cArq1)->(DBGOTOP()); xClasse:=(cArq1)->CLASSE
   @ PROW()+1,05 SAY PADC("CERTIFICADOS "+IF((cArq1)->CLASSE="P","PRATICOS","TEORICOS")+" EMITIDOS",75)
   @ PROW()+2,05 SAY "Periodo: "+DTOC(wDtInic)+" a "+DTOC(wDtFim)
   @ PROW()+1,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ PROW()+1,05 SAY "³    N O M E   D O   A L U N O                       ³  CERTIFICADO ³"
   @ PROW()+1,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
*                       XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX    xxxxxxxxxx
*                     56789012345678901234567890123456789012345678901234567890123456789012345
*                           1         2         3         4         5         6         7
   WHILE !(cArq1)->(EOF())
      IF (cArq1)->VIA=="1" // Sair somente se for 1a via
         nCert++
         @ PROW()+1,05 SAY "³"
         @ PROW()  ,07 SAY (cArq1)->NOME
         @ PROW()  ,58 SAY "³"
         @ PROW()  ,61 SAY (cArq1)->CERTIF
         @ PROW()  ,73 SAY "³"
      ENDIF
      (cArq1)->(DBSKIP())
      IF !(cArq1)->(EOF()).AND.PROW()>=60
         @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         @ PROW()+1,05 SAY PADC("CERTIFICADOS "+IF((cArq1)->CLASSE="P","PRATICOS","TEORICOS")+" EMITIDOS",75)
         @ PROW()+2,05 SAY "Periodo: "+DTOC(wDtInic)+" a "+DTOC(wDtFim)
         @ PROW()+1,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
         @ PROW()+1,05 SAY "³    N O M E   D O   A L U N O                       ³  CERTIFICADO ³"
         @ PROW()+1,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
      ELSE
         IF xClasse # (cArq1)->CLASSE
            IF PROW()>=56
               @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
               @ PROW()+1,05 SAY "Continua..."
               EJECT
               @ PROW()+1,05 SAY PADC("CERTIFICADOS "+IF((cArq1)->CLASSE="P","PRATICOS","TEORICOS")+" EMITIDOS",75)
               @ PROW()+2,05 SAY "Periodo: "+DTOC(wDtInic)+" a "+DTOC(wDtFim)
            ENDIF
            IF xClasse="T"
               @ PROW()+1,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
               @ PROW()+1,05 SAY "³    TOTAL DE CERTIFICADOS TEORICOS EMITIDOS   ->    ³"
               @ PROW()  ,64 SAY nCTeor PICT "@E 99,999"
               @ PROW()  ,73 SAY "³"
               @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
            ELSE
               @ PROW()+1,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
               @ PROW()+1,05 SAY "³    TOTAL DE CERTIFICADOS PRATICOS EMITIDOS   ->    ³"
               @ PROW()  ,64 SAY (nCPratC+nCPratM) PICT "@E 99,999"
               @ PROW()  ,73 SAY "³"
               @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"

               IF !(cArq1)->(EOF())
                  @ PROW()+2,05 SAY PADC("CERTIFICADOS "+IF((cArq1)->CLASSE="P","PRATICOS","TEORICOS")+" EMITIDOS",75)
                  @ PROW()+2,05 SAY "Periodo: "+DTOC(wDtInic)+" a "+DTOC(wDtFim)
                  @ PROW()+1,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
                  @ PROW()+1,05 SAY "³    N O M E   D O   A L U N O                       ³  CERTIFICADO ³"
                  @ PROW()+1,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
               ENDIF
            ENDIF
            xClasse := (cArq1)->CLASSE
         ENDIF
      ENDIF
   ENDDO
   @ PROW()+1,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
   @ PROW()+1,05 SAY "³               TOTAL DE CERTIFICADOS EMITIDOS ->    ³"
   @ PROW()  ,64 SAY nCert PICT "@E 99,999"
   @ PROW()  ,73 SAY "³"
   @ PROW()+1,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
   @ PROW()+3,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp certif.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CERTIF.TXT
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Browse do Cadastro             ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SELECT (cArq1); DBGOTOP()
   SETCOLOR(YCORGERAL)
   Telas(2,0,19,79,1,YCORGERAL,.F.,"CERTIFICADOS EMITIDOS EM "+DTOC(wDtInic)+" a "+DTOC(wDtFim))
   Telas(19,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,18,78)
   @ 20,03 SAY "Certificados =>"
   @ 20,19 SAY nCert
   @ 20,45 SAY "Pr ticos =>"
   @ 21,45 SAY "Te¢ricos =>"
   @ 20,57 SAY (nCPratC+nCPratM)
   @ 21,57 SAY nCTeor
   oBr:headSep:="ÄÂÄ"
   oBr:colSep:= " ³ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Aluno"        ,{|| NOME})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certificado"  ,{|| CERTIF})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Via"          ,{|| VIA})
   oBr:addColumn(oCol)

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
