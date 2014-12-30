*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_332                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Exames                      ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 03/01/1998                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"DTVCTO"   ,"D",   08,0}) /* Data do Vencimento          */
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Aluno               */
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula do aluno          */
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Codigo do Instrutor         */
AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* Codigo do Veกculo           */
AADD(aDbf,{"VEZ"      ,"C",   01,0}) /* Vez que aluno faz o exame   */
AADD(aDbf,{"DTEXAME"  ,"D",   08,0}) /* Data do Exame Pr tico       */
AADD(aDbf,{"HORA"     ,"C",   04,0}) /* Hora do Exame               */
AADD(aDbf,{"DTEXAME1" ,"D",   08,0}) /* Data do Exame Pr tico       */
AADD(aDbf,{"HORA1"    ,"C",   04,0}) /* Hora do Exame               */
AADD(aDbf,{"OBS"      ,"C",   30,0}) /* Observaไes                 */
AADD(aDbf,{"CARRO"    ,"N",   10,2}) /* Valor do Aluguel do Carro   */
AADD(aDbf,{"RENACH"   ,"C",   10,0}) /* Nฃmero do RENACH            */
AADD(aDbf,{"ETIQ"     ,"C",   11,0}) /* Nฃmero da Etiqueta          */
AADD(aDbf,{"RESULTADO","C",   01,0}) /* Situaao do Exame           */
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
INDEX ON DTOS(dtexame) TO (cArq1)

SELECT 4
IF NetUse("DBVEIC","VEICULO")           /* Cadastro de Veกculos */
   SET INDEX TO DBIVEI1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")         /* Cadastro de Instrutores */
   SET INDEX TO DBINST1, DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO TIPO="1"

SELECT 1
IF NetUse("DBPAG","PAGAR")              /* Arquivo de Pagamentos */
   SET INDEX TO DBIPAG2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")              /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBEXAM","EXAME")             /* Cadastro de Exames de Direao */
   SET INDEX TO DBIEXAM4,DBIEXAM1,DBIEXAM3,DBIEXAM2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SETCOLOR(YCOREDIT)
ProgName("AE332"); Linha23("^ENTER^-Alterar ^F7^-Aluno ^F9^-Extrato ^F10^-Listagem  ^F2^-Pesquisa")
cOpHelp1 := "3"; cOpHelp2 := "32"
Telas(3,2,20,77,1,YCOREDIT,.T.,"Exames de Direao Veicular")
oBr:=TBROWSEDB(4,3,19,76)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Aluno"    ,{|| TRANSFORM(NOME,"@S30")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("RENACH"   ,{|| RENACH})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Vez"      ,{|| VEZ})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Data"     ,{|| DTEXAME})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Hora"     ,{|| TRANSFORM(HORA,"@R 99:99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Instrutor",{|| TRANSFORM(TInst(CODINST,5,4),"@S10")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Carro"    ,{|| TRANSFORM(PegaVeic(CODVEIC),"@S10")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Resultado",{|| TResult(RESULTADO)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Valor"    ,{|| TRANSFORM(CARRO,"@E 99,999.99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("OBS"      ,{|| OBS})
oBr:addColumn(oCol)

oBr:Freeze=1
WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF tecla == K_ENTER
      SET KEY -1 TO Mostra()
      IF EMPTY(EXAME->NOME)
         Aviso("Nฦo h  registro a ser Alterado...",,3); LOOP
      ENDIF
      FOR a = 1 TO EXAME->(FCOUNT())
          xVar  := "w"+EXAME->(FIELDNAME(a))
          &xVar := EXAME->(FIELDGET(a))
      NEXT
      wDescrRes:=""
      Telas(4,3,12,72,1,YCOREDIT,.T.,"Alteraฦo de Exame")
      TDescr(2,1,8,23,wCodInst,"NOME",["@S25"])
      TDescr(4,1,9,23,wCodVeic,"MARCA")
      wDescrRes:=TResult(wResultado)
      @ 10,25 SAY wDescrRes COLOR YCORREALCE

      @ 05,05 SAY "Nome Aluno:" GET wNome      PICT "@!"   VALID !EMPTY(wNome)
      @ 06,05 SAY "RENACH....:" GET wRENACH    PICT "@!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wRENACH)
      @ 07,05 SAY "Vez.......:" GET wVez       PICT "9"    VALID LASTKEY()==K_UP.OR.!EMPTY(wVez)
      @ 07,30 SAY "Data:"       GET wDtExame   PICT "@D"   VALID LASTKEY()==K_UP.OR.!EMPTY(wDtExame)
      @ 07,50 SAY "Hora:"       GET wHorario   PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.!EMPTY(wHorario)
*     @ 07,05 SAY "Identidade:" GET wRG        PICT "@!"   WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wRG)
      @ 08,05 SAY "Instrutor.:" GET wCodInst   PICT "9999" WHEN TeclaFuncao(.T.);
        VALID LASTKEY()==K_UP.OR.TDescr(2,1,8,23,wCodInst,"NOME",["@S25"],"Instrutor Nao Cadastrado")
      @ 09,05 SAY "Veกculo...:" GET wCodveic   PICT "99"   WHEN TeclaFuncao(.T.);
        VALID LASTKEY()==K_UP.OR.TDescr(4,1,9,23,wCodVeic,"MARCA",,"Veกculo Nao Cadastrado")
      @ 10,05 SAY "Resultado.:" GET wResultado PICT "9"    WHEN TeclaFuncao().AND.HTela(10) VALID VTela(10)
      @ 11,05 SAY "Observaฦo:" GET wObs       PICT "@!"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()#K_ESC.AND.UPDATED().AND.Confirma("Confirma Alteraไes ?")
         WHILE !EXAME->(NetLReg()); ENDDO
         FOR a = 1 TO EXAME->(FCOUNT())
             xVar  := "w"+EXAME->(FIELDNAME(a))
             EXAME->(FIELDPUT(a,&xVar))
         NEXT
         EXAME->(DBUNLOCK()); EXAME->(DBCOMMIT())

         /* Gravar no cadastro de alunos */
         IF ALUNO->(DBSEEK(wMatric))
            IF ALUNO->RENACH#wRenach
               IF Confirma("Altera nง do RENACH ?")
                  WHILE !ALUNO->(NetLReg()); ENDDO
                  REPLACE ALUNO->RENACH WITH wRenach
                  ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
               ENDIF
            ENDIF
         ENDIF
         oBr:Refreshall()
      ENDIF
      Rest_Tela(LEN(Telas)-3)
   ELSEIF tecla == K_F2               // Pesquisa Aluno
      nReg:=EXAME->(RECNO())
      Telas(17,3,19,72,1,YCOREDIT,.T.,"Pesquisa Aluno")
      wNome:=SPACE(50)
      SET EXACT OFF
      @ 18,05 SAY "Nome Aluno:" GET wNome PICT "@!" VALID !EMPTY(wNome).AND.Pesquisa2(5,3,wNome,"Aluno Nao Cadastrado para Exame")
      SETCURSOR(1); READ; SETCURSOR(0)
      SET EXACT ON
      IF LASTKEY()==K_ESC
         EXAME->(DBGOTO(nReg))
      ENDIF
      Rest_Tela()
      oBr:Refreshall()
   ELSEIF tecla == K_F7               // Extrato por Aluno
      SET KEY -1 TO Mostra()
      wMatricula:=SPACE(4)
      SETCOLOR(YCOREDIT)
      Telas(3,2,20,77,1,YCOREDIT,.T.,"Extrato por Aluno")
      @ 04,03 SAY "Matrกcula:" GET wMatricula PICT "9999" VALID !EMPTY(wMatricula).AND.TDescr(5,2,4,21,wMatricula,"NOME",,"Aluno sem registro de pagamento!")
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()#K_ESC
         WHILE EXAME->MATRIC==wMatricula.AND.!EXAME->(EOF())
            FOR a = 1 TO EXAME->(FCOUNT())
                xVar  := "w"+EXAME->(FIELDNAME(a))
                &xVar := EXAME->(FIELDGET(a))
            NEXT

            (cArq1)->(DBAPPEND())
            FOR a = 1 TO (cArq1)->(FCOUNT())
                xVar  := "w"+(cArq1)->(FIELDNAME(a))
                (cArq1)->(FIELDPUT(a,&xVar))
            NEXT

            EXAME->(DBSKIP())
         ENDDO
         TelaAlu()
         (cArq1)->(__DBZAP())
      ENDIF
      Rest_Tela()
      Linha23("^ENTER^-Alterar ^F6^-Incluir ^DEL^-Exluir ^F9/F10^-Relatขrios ^F7^-Aluno")
   ELSEIF tecla == K_F6               // Incluir
      EXAME->(DBGOBOTTOM()); EXAME->(DBSKIP())
      FOR a = 1 TO EXAME->(FCOUNT())
          xVar  := "w"+EXAME->(FIELDNAME(a))
          &xVar := EXAME->(FIELDGET(a))
      NEXT

      SET KEY -1 TO Mostra()
      SETCOLOR(YCOREDIT)
      Telas(4,3,13,68,1,YCOREDIT,.T.,"Inclusฦo de Exame")
      @ 05,05 SAY "Nome Aluno:" GET wNome      PICT "@!"   VALID !EMPTY(wNome)
      @ 06,05 SAY "RENACH....:" GET wRENACH    PICT "@!"   VALID LASTKEY()==K_UP.OR.!EMPTY(wRENACH)
      @ 07,05 SAY "Vez.......:" GET wVez       PICT "9"
      @ 07,30 SAY "Data:"       GET wDtExame   PICT "@D"   VALID LASTKEY()==K_UP.OR.!EMPTY(wDtExame)
      @ 07,50 SAY "Hora:"       GET wHorario   PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.!EMPTY(wHorario)
*     @ 07,05 SAY "Identidade:" GET wRG        PICT "@!"   WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wRG)
      @ 08,05 SAY "Instrutor.:" GET wCodInst   PICT "9999" WHEN TeclaFuncao(.T.);
        VALID LASTKEY()==K_UP.OR.TDescr(2,1,8,23,wCodInst,"NOME",["@S25"],"Instrutor Nao Cadastrado")
      @ 09,05 SAY "Veกculo...:" GET wCodveic   PICT "99"   WHEN TeclaFuncao(.T.);
        VALID LASTKEY()==K_UP.OR.TDescr(4,1,9,23,wCodVeic,"MARCA",,"Veกculo Nao Cadastrado")
      @ 10,05 SAY "Valor R$..:" GET wCarro     PICT "@E 99,999.99" WHEN TeclaFuncao()
      @ 11,05 SAY "Resultado.:" GET wResultado PICT "9"    WHEN TeclaFuncao().AND.HTela(10) VALID VTela(10)
      @ 12,05 SAY "Observaฦo:" GET wObs       PICT "@!"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusao ?")
         WHILE !EXAME->(NetApp()); ENDDO
         FOR a = 1 TO EXAME->(FCOUNT())
             xVar  := "w"+EXAME->(FIELDNAME(a))
             EXAME->(FIELDPUT(a,&xVar))
         NEXT
         oBr:Refreshall()
      ENDIF
      Rest_Tela()
   ELSEIF ( tecla == K_DEL ) /* Excluir */
      IF EXAME->(EOF())
         Aviso("Nฦo h  registro a ser Excluกdo...",,3); LOOP
      ENDIF
      IF Confirma("Confirma Exclusao ?")
         WHILE !EXAME->(NetLReg()); ENDDO
         EXAME->(DBDELETE()); EXAME->(DBCOMMIT())
         oBr:Up(); oBr:Down(); oBr:Refreshall()
      ENDIF
   ELSEIF ( tecla == K_F10 )  /* Listagem dos Exames */
      Telas(10,3,13,30,1,YCOREDIT,.T.,"Listagem Exame de Rua")
      wDtExame:=CTOD(""); wHora:="0700"
      @ 11,05 SAY "Data:" GET wDtExame   PICT "@D"       VALID !EMPTY(wDtExame)
      @ 12,05 SAY "Hora:" GET wHora      PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.!EMPTY(wHora)
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()#K_ESC
         EXAME->(DBSETORDER(4))
         IF EXAME->(DBSEEK(DTOS(wDtExame)+wHora))
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpListaExame()
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impressฦo, tecle algo...")
            ENDIF
         ELSE
            Aviso("Nฦo h  exames para este hor rio nesta data!")
         ENDIF
         EXAME->(DBSETORDER(1))
      ENDIF
      EXAME->(DBGOTOP())
      Rest_Tela(); oBr:Refreshall()
   ELSEIF ( tecla == K_F9 )  /* Imprimir */
      SET KEY -1 TO Mostra()
      SETCOLOR(YCOREDIT)
      Telas(10,3,13,68,1,YCOREDIT,.T.,"Lista Geral - Resultados")
      wCodInst:=SPACE(4); wPerIni:=wPerFim:=CTOD("")
      @ 11,05 SAY "Instrutor:" GET wCodInst   PICT "9999" WHEN TeclaFuncao(.T.);
        VALID LASTKEY()==K_UP.OR.IF(EMPTY(wCodInst),.T.,TDescr(2,1,11,21,wCodInst,"NOME",["@S25"],"Instrutor Nao Cadastrado"))
      @ 12,05 SAY "Perกodo..:" GET wPerIni    PICT "@D"   VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
      @ 12,27 SAY "a"          GET wPerFim    PICT "@D"   VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni
      SETCURSOR(1); READ; SETCURSOR(0)
      TeclaFuncao()
      IF LASTKEY()#K_ESC
         SELECT EXAME
         nReg:=EXAME->(RECNO())
         SET SOFTSEEK ON
         IF !EMPTY(wCodInst)
            EXAME->(DBSETORDER(4)); EXAME->(DBGOTOP())
            EXAME->(DBSEEK(wCodInst+DTOS(wPerIni),.T.))
            IF EXAME->DTEXAME <= wPerFim
               IF ChkImpr()
                  cAviso := MsgImp(.F.)
                  ImpPorRes(.F.)
                  TiraMsgImp(cAviso)
                  WaitMsg("Fim de Impressฦo, tecle algo...")
               ENDIF
            ELSE
               Aviso("Nao houve alunos para este instrutor neste perกodo!")
            ENDIF
         ELSE
            EXAME->(DBSETORDER(1)); EXAME->(DBGOTOP())
            EXAME->(DBSEEK(DTOS(wPerIni),.T.))
            IF EXAME->DTEXAME <= wPerFim
               IF ChkImpr()
                  cAviso := MsgImp(.F.)
                  EXAME->(DBGOTOP())
                  ImpPorRes(.T.)
                  TiraMsgImp(cAviso)
                  WaitMsg("Fim de Impressฦo, tecle algo...")
               ENDIF
            ELSE
               Aviso("Nao houve alunos com exames neste perกodo!")
            ENDIF
         ENDIF
         SET SOFTSEEK OFF
         EXAME->(DBSETORDER(1))
         EXAME->(DBGOTO(nReg))
      ENDIF
      Rest_Tela(); oBr:Refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela(LEN(Telas)-2)
RETURN NIL
*ีออออออออออออออออออออออออออออออออออธ
*ณ Imprimir Listagem                ณ
*ิออออออออออออออออออออออออออออออออออพ
PROCEDURE ImpListaExame()
  LOCAL vHora, nTotAluno:=0
  Gera_TXT("EXAMES.TXT"); SETPRC(0,0)
  Compr_Off()
  @ PROW()+1,00 SAY PADC(UPPER(cRazao1),80)
  @ PROW()+1,00 SAY PADC("LISTA DE PRESENCA - EXAME DE RUA",80)
  @ PROW()+3,00 SAY PADC("** RELACAO DE EXAME DE PRATICO EM "+DTOC(wDtExame)+" AS "+SUBS(wHora,1,2)+":"+SUBS(wHora,3)+" **",80)
  WHILE EXAME->DTEXAME==wDtExame.AND.EXAME->HORA==wHora.AND.!EXAME->(EOF())
     @ PROW()+2,08 SAY "Instrutor -> "+TInst(EXAME->CODINST,5,4)
     @ PROW()+1,08 SAY REPL("ฤ",65)
     @ PROW()+1,08 SAY "VEZ          CANDIDATO               N. RENACH     ASS.ALUNO"
*                       890123456789012345678901234567890123456789012345678901234567890123456789
*                         1         2         3         4         5         6         7
     @ PROW()+1,08 SAY REPL("ฤ",65)
     @ PROW()+1,08 SAY EXAME->VEZ+IF(EXAME->VEZ="1","ง","ฆ")
     @ PROW()  ,12 SAY EXAME->NOME PICT "@S30"
     @ PROW()  ,45 SAY EXAME->RENACH
     @ PROW()  ,59 SAY "______________"
     IF !EMPTY(EXAME->OBS)
        @ PROW()+1,08 SAY EXAME->OBS
        @ PROW()+1,08 SAY ""
     ENDIF
     IF PROW()>57
        EJECT
        @ PROW()+3,00 SAY PADC("** RELACAO DE EXAME DE PRATICO EM "+DTOC(wDtExame)+" AS "+SUBS(wHora,1,2)+":"+SUBS(wHora,3)+" **",80)
        @ PROW()+2,08 SAY "Instrutor -> "+TInst(EXAME->CODINST,5,4)
        @ PROW()+1,08 SAY REPL("ฤ",65)
        @ PROW()+1,08 SAY "VEZ          CANDIDATO               N. RENACH   ASS.ALUNO"
*                          890123456789012345678901234567890123456789012345678901234567890123456789
*                            1         2         3         4         5         6         7
        @ PROW()+1,08 SAY REPL("ฤ",65)
     ENDIF
     nTotAluno++
     IF !EXAME->(EOF())
        @ PROW()+1,08 SAY ""
     ENDIF
     EXAME->(DBSKIP())
  ENDDO
  @ PROW()+1,08 SAY REPL("ฤ",65)
  @ PROW()+1,08 SAY "TOTAL DE ALUNOS ==> "+RTRIM(STR(nTotaluno))
  @ PROW()+3,08 SAY PADR("Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+ExtMes(DATE())+" de "+STR(YEAR(DATE()),4),80)
  @ PROW()+3,08 SAY REPL("_",LEN(xRazao))
  @ PROW()+1,08 SAY xRazao
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp EXAMES.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE EXAMES.TXT
  RETURN
*ีออออออออออออออออออออออออออออออออออธ
*ณ Imprimir por Resultados          ณ
*ิออออออออออออออออออออออออออออออออออพ
PROCEDURE ImpPorRes(pSel)
  LOCAL vHora, nTotAlu:=nApto:=nInap:=nRema:=nFalt:=nSExa:=0
  Gera_TXT("RESULEX.TXT"); SETPRC(0,0)
  Compr_Off()
  @ PROW()+1,00 SAY PADC(xRazao+" - RANKING",80)
  IF !pSel
     @ PROW()+3,00 SAY PADC("** LISTA DE SITUACAO DE ALUNOS POR PROFESSOR **",80)
     @ PROW()+2,08 SAY "Instrutor -> "+TInst(EXAME->CODINST,5,4)
     @ PROW()+1,08 SAY "Periodo   -> "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
     @ PROW()+1,08 SAY REPL("ฤ",70)
     @ PROW()+1,08 SAY "DATA       ALUNO                                         SITUACAO"
*                       99/99/9999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXX Apto
*                       890123456789012345678901234567890123456789012345678901234567890123456789
*                         1         2         3         4         5         6         7
     @ PROW()+1,08 SAY REPL("ฤ",70)
     xData:=EXAME->DTEXAME; nNum:=0; lPrim:=.T.
     WHILE !EXAME->(EOF())
        IF EXAME->DTEXAME >= wPerIni .AND. EXAME->DTEXAME <= wPerFim
           IF EXAME->CODINST==wCodInst
              IF EXAME->RESULTADO=="1"      // Apto
                 nApto++
              ELSEIF EXAME->RESULTADO=="2"  // Inaptos
                 nInap++
              ELSEIF EXAME->RESULTADO=="3"  // Remarcado
                 nRema++
              ELSEIF EXAME->RESULTADO=="4"  // Faltou
                 nFalt++
              ELSEIF EXAME->RESULTADO=="9"  // Sem exame
                 nSExa++
              ENDIF
              nPula:=1
              IF EXAME->DTEXAME#xData.OR.lPrim
                 @ PROW()+1,08 SAY EXAME->DTEXAME
                 xData:=EXAME->DTEXAME; lPrim:=.F.; nPula:=0
              ENDIF
              @ PROW()+nPula,19 SAY EXAME->NOME PICT "@S45"
              @ PROW()      ,65 SAY TResult(EXAME->RESULTADO)
              IF PROW()>=55
                 @ PROW()+1,08 SAY REPL("ฤ",70)
                 @ PROW()+1,08 SAY "Continua..."
                 EJECT
                 @ PROW()+3,00 SAY PADC("** LISTA DE SITUACAO DE ALUNOS POR PROFESSOR **",80)
                 @ PROW()+2,08 SAY "Instrutor -> "+TInst(EXAME->CODINST,5,4)
                 @ PROW()+1,08 SAY "Periodo   -> "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                 @ PROW()+1,08 SAY REPL("ฤ",70)
                 @ PROW()+1,08 SAY "DATA       ALUNO                                         SITUACAO"
                 @ PROW()+1,08 SAY REPL("ฤ",70)
                 lPrim:=.T.
              ENDIF
           ENDIF
        ENDIF
        EXAME->(DBSKIP())
     ENDDO
     @ PROW()+1,08 SAY REPL("ฤ",65)
     IF PROW()>55; EJECT; ENDIF
     @ PROW()+1,08 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
     @ PROW()+1,08 SAY "ณ Aptos          ณ"
     @ PROW()  ,28 SAY nApto PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Inaptos        ณ"
     @ PROW()  ,28 SAY nInap PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Remarcados     ณ"
     @ PROW()  ,28 SAY nRema PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Faltaram       ณ"
     @ PROW()  ,28 SAY nFalt PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Sem Exame      ณ"
     @ PROW()  ,28 SAY nSExa PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
     @ PROW()+1,08 SAY "ณ   T O T A L    ณ"
     @ PROW()  ,27 SAY (nApto+nInap+nRema+nFalt+nSExa) PICT "@E 999,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"      
     @ PROW()+3,08 SAY PADR("Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+ExtMes(DATE())+" de "+STR(YEAR(DATE()),4),80)
     @ PROW()+3,08 SAY REPL("_",LEN(xRazao))
     @ PROW()+1,08 SAY xRazao
     EJECT
  ELSE
     @ PROW()+3,08 SAY PADC("** RESULTADO GERAL DE EXAMES DE DIRECAO **",72)
     @ PROW()+2,08 SAY "Periodo -> "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
     @ PROW()+1,08 SAY REPL("ฤ",70)
     @ PROW()+1,08 SAY "DATA       ALUNO                                         SITUACAO"
*                       99/99/9999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXX Apto
*                       890123456789012345678901234567890123456789012345678901234567890123456789
*                         1         2         3         4         5         6         7
     @ PROW()+1,08 SAY REPL("ฤ",70)
     xData:=EXAME->DTEXAME; nNum:=0; lPrim:=.T.
     WHILE !EXAME->(EOF())
        IF EXAME->DTEXAME >= wPerIni .AND. EXAME->DTEXAME <= wPerFim
           IF EXAME->RESULTADO=="1"      // Apto
              nApto++
           ELSEIF EXAME->RESULTADO=="2"  // Inaptos
              nInap++
           ELSEIF EXAME->RESULTADO=="3"  // Remarcado
              nRema++
           ELSEIF EXAME->RESULTADO=="4"  // Faltou
              nFalt++
           ELSEIF EXAME->RESULTADO=="9"  // Sem exame
              nSExa++
           ENDIF
           nPula:=1
           IF EXAME->DTEXAME#xData.OR.lPrim
              @ PROW()+1,08 SAY EXAME->DTEXAME
              xData:=EXAME->DTEXAME; lPrim:=.F.; nPula:=0
           ENDIF
           @ PROW()+nPula,19 SAY EXAME->NOME PICT "@S45"
           @ PROW()      ,65 SAY TResult(EXAME->RESULTADO)
           IF PROW()>=55
              @ PROW()+1,08 SAY REPL("ฤ",70)
              @ PROW()+1,08 SAY "Continua..."
              EJECT
              @ PROW()+3,08 SAY PADC("** RESULTADO GERAL DE EXAMES DE DIRECAO **",72)
              @ PROW()+1,08 SAY "Periodo -> "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
              @ PROW()+1,08 SAY REPL("ฤ",70)
              @ PROW()+1,08 SAY "DATA        ALUNO                                         SITUACAO"
              @ PROW()+1,08 SAY REPL("ฤ",70)
              lPrim:=.T.
           ENDIF
        ENDIF
        EXAME->(DBSKIP())
     ENDDO
     @ PROW()+1,08 SAY REPL("ฤ",65)
     IF PROW()>55; EJECT; ENDIF
     @ PROW()+1,08 SAY "ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤยฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ"
     @ PROW()+1,08 SAY "ณ Aptos          ณ"
     @ PROW()  ,28 SAY nApto PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Inaptos        ณ"
     @ PROW()  ,28 SAY nInap PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Remarcados     ณ"
     @ PROW()  ,28 SAY nRema PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Faltaram       ณ"
     @ PROW()  ,28 SAY nFalt PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ณ Sem Exame      ณ"
     @ PROW()  ,28 SAY nSExa PICT "@E 99,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "รฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤลฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤด"
     @ PROW()+1,08 SAY "ณ   T O T A L    ณ"
     @ PROW()  ,27 SAY (nApto+nInap+nRema+nFalt+nSExa) PICT "@E 999,999"
     @ PROW()  ,41 SAY "ณ"
     @ PROW()+1,08 SAY "ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤมฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู"      
     @ PROW()+3,08 SAY PADR("Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+ExtMes(DATE())+" de "+STR(YEAR(DATE()),4),80)
     @ PROW()+3,08 SAY REPL("_",LEN(xRazao))
     @ PROW()+1,08 SAY xRazao
  ENDIF
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp RSULEX.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE RSULEX.TXT
  RETURN
*ีออออออออออออออออออออออออออออออออออธ
*ณ Pegar o status do resultado      ณ
*ิออออออออออออออออออออออออออออออออออพ
FUNCTION TResult(pVar)
  IF     pVar=="1"; wDescrRes:="Apto     "
  ELSEIF pVar=="2"; wDescrRes:="Inapto   "
  ELSEIF pVar=="3"; wDescrRes:="Remarcado"
  ELSEIF pVar=="4"; wDescrRes:="Faltou   "
  ELSEIF pVar=="9"; wDescrRes:="S/Exame  "
  ELSE
     wDescrRes:="         "
  ENDIF
  RETURN(wDescrRes)
*ีออออออออออออออออออออออออออออออออออธ
*ณ Tela de Browse de Alunos         ณ
*ิออออออออออออออออออออออออออออออออออพ
STATIC FUNCTION TelaAlu()
  LOCAL oBr1, oCol1

  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(5,2,20,77,1,YCOREDIT,.T.)
* Linha23("^ESC^-Retorna ^ENTER^-Altera ^F6^-Inclui ^ALT+E^-Exclui ^F9^-Imprime ^F11^-Fecha Caixa",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr1:=TBROWSEDB(6,3,19,76)
  oBr1:headSep:="ฤยฤ"
  oBr1:colSep:= " ณ "

  oCol1:=TBCOLUMNNEW("RENACH"   ,{|| RENACH})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Vez"      ,{|| VEZ})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Data"     ,{|| DTEXAME})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Hora"     ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Instrutor",{|| TRANSFORM(TInst(CODINST,5,4),"@S10")})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Carro"    ,{|| TRANSFORM(PegaVeic(CODVEIC),"@S10")})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Resultado",{|| TResult(RESULTADO)})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Valor"    ,{|| TRANSFORM(CARRO,"@E 99,999.99")})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("OBS"      ,{|| OBS})
  oBr1:addColumn(oCol1)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr1:stabilize(); ENDDO
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
     ELSE
        ProcKey(oBr1,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
