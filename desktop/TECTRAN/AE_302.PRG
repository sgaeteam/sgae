*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_302                           vrs 001 ณ
*ณ FINALIDADE     : Estatisticos Aulas por professor         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 31/01/2001                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Cขdigo do Instrutor        */
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Instrutor         */
AADD(aDbf,{"HH"       ,"N",   05,0}) /* Qtde de Horas / Aulas      */
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

SELECT 1
IF NetUse("DBALU","ALUNOS")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU3
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE302"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "01"

Quadro(13,20,17,55,1,YCOREDIT,.T.,,.T.)
wDtInic:=wDtFim:=CTOD(""); wDevice:=" "
SETCOLOR(YCOREDIT)
@ 14,22 SAY "Perกodo:            a"
@ 15,20 SAY "ร"+REPLI("ฤ",34)+"ด"

WHILE .T.
   nMatric:=nAprov1:=nAprov2:=nCertif1:=nCertif2:=nReprov:=nDesiste:=0
   @ 14,31 GET wDtInic PICT "@D" VALID !EMPTY(wDtInic)
   @ 14,44 GET wDtFim  PICT "@D" VALID (LASTKEY()==K_UP).OR.wDtFim>=wDtInic
   @ 16,22 SAY "Saกda:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   SET SOFTSEEK ON
   ALUNOS->(DBSEEK(DTOS(wDtInic),.T.))
   SET SOFTSEEK OFF
   IF ALUNOS->(EOF())
      Aviso("Nฦo h  alunos matriculados neste perกodo!"); LOOP
   ENDIF

   Aguarde("Calculando...")
   WHILE ALUNOS->DTINSCR>=wDtInic.AND.ALUNOS->DTINSCR<=wDtFim.AND.!ALUNOS->(EOF())
      nMatric++
      IF !EMPTY(ALUNOS->DTAPROV1)
         nAprov1++
      ENDIF
      IF !EMPTY(ALUNOS->DTAPROV2)
         nAprov2++
      ENDIF
      IF !EMPTY(ALUNOS->DTAPROV1).AND.!EMPTY(ALUNOS->DTAPROV2)
         nReprov++
      ENDIF
      IF !EMPTY(ALUNOS->CERTIF1)
         nCertif1++
      ENDIF
      IF !EMPTY(ALUNOS->CERTIF2)
         nCertif2++
      ENDIF
      ALUNOS->(DBSKIP())
   ENDDO
   Aguarde()

   (cArq1)->(DBAPPEND())
   REPLACE (cArq1)->MATRIC   WITH nMatric,;
           (cArq1)->APROV1   WITH nAprov1,;
           (cArq1)->APROV2   WITH nAprov2,;
           (cArq1)->CERTIF1  WITH nCertif1,;
           (cArq1)->CERTIF2  WITH nCertif2,;
           (cArq1)->REPROV   WITH nReprov,;
           (cArq1)->DESISTE  WITH nDesiste

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
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpRel()
   Gera_TXT("AULAPROF.TXT"); SETPRC(0,0)
   @ PROW()+16,05 SAY PADC("RELATORIO MENSAL DE ATIVIDADES",75)
   @ PROW()+4,05 SAY PADC("MES/ANO",75)
   @ PROW()+1,05 SAY PADC(UPPER(ExtMes(wDtInic))+"/"+STR(YEAR(wDtInic),4)+" a "+UPPER(ExtMes(wDtFim))+"/"+STR(YEAR(wDtFim),4),75)
   @ PROW()+4,15 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
   @ PROW()+1,15 SAY "ณ        N  O  M  E             ณ  QTDE. H/AULAณ"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Alunos Matriculados           ณ              ณ"
   @ PROW()  ,52 SAY nMatric PICT "@E 99,999"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Alunos Aprovados (Teorica)    ณ              ณ"
   @ PROW()  ,52 SAY nAprov1 PICT "@E 99,999"
   @ PROW()+1,15 SAY "ณ Alunos Aprovados (Pratica)    ณ              ณ"
   @ PROW()  ,52 SAY nAprov2 PICT "@E 99,999"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Alunos Reprovados             ณ              ณ"
   @ PROW()  ,52 SAY nReprov PICT "@E 99,999"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Alunos Desistentes            ณ              ณ"
   @ PROW()  ,52 SAY nDesiste PICT "@E 99,999"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Alunos Transferidos           ณ              ณ"
   @ PROW()  ,52 SAY nDesiste-nDesiste PICT "@E 99,999"
   @ PROW()+1,15 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
   @ PROW()+1,15 SAY "ณ Certificados Emitidos(Teorico)ณ              ณ"
   @ PROW()  ,52 SAY nCertif1 PICT "@E 99,999"
   @ PROW()+1,15 SAY "ณ Certificados Emitidos(Pratico)ณ              ณ"
   @ PROW()  ,52 SAY nCertif2 PICT "@E 99,999"
   @ PROW()+1,15 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"
   @ PROW()+3,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp aulaprof.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE AULAPROF.TXT
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SELECT (cArq1)
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.,"ATIVIDADES EM "+DTOC(wDtInic)+" a "+DTOC(wDtFim))
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Matrกculas"   ,{|| TRANSFORM(MATRIC,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aprovados (Teorico)",{|| TRANSFORM(APROV1,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Aprovados (Pratico)",{|| TRANSFORM(APROV2,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Reprovados"   ,{|| TRANSFORM(REPROV,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certif. (Teorico)" ,{|| TRANSFORM(CERTIF1,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certif. (Pratico)" ,{|| TRANSFORM(CERTIF2,"@E 99,999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Desistentes"  ,{|| TRANSFORM(DESISTE,"@E 99,999")})
   oBr:addColumn(oCol)

   oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  // Imprime
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpRel()
            WHILE Confirma("Outra Cขpia ?")
               ImpRel()
            ENDDO
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
