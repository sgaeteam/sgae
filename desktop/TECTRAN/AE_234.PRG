*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_222                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Transferˆncia de Aulas Teoricas          ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()

SELECT 6
IF NetUse("DBFREQ","TEORICA")         /* Arquivo de Frequencias Te¢ricas */
   SET INDEX TO DBIFREQ2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("DBTURMA","TURMA")        /* Tabela de Turmas */
   SET INDEX TO DBITURM1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBDISC","DISCIPLINA")       /* Tabela de Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBINST","INSTRUTOR")       /* Cadastro de Instrutores */
   SET INDEX TO DBINST1, DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO TIPO1="2"

SELECT 2
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
        
SELECT 1
IF NetUse("DBALU","ALUNOS")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE234"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "22"
SET KEY -1 TO Mostra()
wData:=cDtSys;wTurma:=SPACE(10)
wInst:=SPACE(4);wDisc:=SPACE(2)
wDataNova:=cDtSys;wTurmaNova:=SPACE(10)
WHILE .T.
   xData:=CTOD(""); xHora:=SPACE(2)
   SETCOLOR(YCOREDIT)
   Telas(4,3,7,75,1,YCOREDIT,.T.,"Transferencia de Aulas Te¢ricas")
   Mensagem("Informe c¢digo da Turma e Data da Aula")
   @ 05,05 SAY "      Turma:" GET wTurma PICT "@!" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wTurma).AND.Pesquisa(5,1,wTurma,"Turma NÆo Cadastrada!")
   @ 06,05 SAY "       Data:" GET wData PICT "@D"  WHEN TeclaFuncao();
     VALID LASTKEY()==K_UP.OR.!EMPTY(wData).AND.TData(wData)
   @ 05,30 SAY "  Instrutor:" GET wInst PICT "@!"  WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.!EMPTY(wInst).AND.Pesquisa(3,1,wInst,"NÆo ‚ Instrutor T‚orico!").AND.;
     TDescr(3,1,5,48,wInst,"NOME",["@S25"])
   @ 06,30 SAY " Disciplina:" GET wDisc PICT "@!" ; 
     VALID LASTKEY()==K_UP.OR.!EMPTY(wDisc).AND.Pesquisa(4,1,wDisc,"Disciplina NÆo Cadastrada!").AND.;
     TDescr(4,1,6,46,wDisc,"DESCR",["@S25"])
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   IF !TEORICA->(DBSEEK(wTurma+DTOS(wData)+wDisc+wInst))
      Aviso("NÆo h  aula para esta turma e disciplina nesta data..."+DTOC(wData),,3)
      Rest_Tela()
      LOOP
   ENDIF

   Telas(7,3,10,75,1,YCOREDIT,.T.)
   @ 07,03 SAY "Ã"+REPL("Ä",71)+"´"
   @ 08,05 SAY " Nova Turma:" GET wTurmaNova PICT "@!" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wTurma).AND.Pesquisa(5,1,wTurma,"Turma NÆo Cadastrada!")
   @ 09,05 SAY "  Nova Data:" GET wDataNova  PICT "@D"  WHEN TeclaFuncao();
     VALID LASTKEY()==K_UP.OR.!EMPTY(wDataNova).AND.TData(wDataNova)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(2); EXIT; ENDIF
   
   nReg:=TEORICA->(RECNO())
   IF !TEORICA->(DBSEEK(wTurmaNova+DTOS(wDataNova)+wDisc))
      Aviso("ATENCÇO: Turma Nova nÆo tem Aula nessa Data Nova!")
      Rest_Tela(2); LOOP
   ENDIF
   TEORICA->(DBGOTO(nReg))

   WHILE TEORICA->TURMA==wTurma.AND.TEORICA->DATA==wData.AND.;
         TEORICA->CODINST==wInst.AND.TEORICA->DISCIPLINA==wDisc

      //Grava o proximo Registro, para depois que atualizar o indice voltar
      TEORICA->(DBSKIP())
      nReg:=TEORICA->(RECNO())
      TEORICA->(DBSKIP(-1))

      WHILE !TEORICA->(NetLReg()); ENDDO
      REPLACE TEORICA->TURMA with wTurmaNova
      REPLACE TEORICA->DATA  with wDataNova
      TEORICA->(DBUNLOCK())

      TEORICA->(DBGOTO(nReg))
      TEORICA->(DBSKIP())
   ENDDO
   ProcOk("Transferido",.T.)
   Rest_Tela(2)
ENDDO
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
