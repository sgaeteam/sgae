*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_222                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Transferˆncia de Aulas                   ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
SELECT 6
IF NetUse("DBPEND","PENDENCIA")        /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF NetUse("DBINST","INSTRUTOR")        /* Instrutores */
   SET INDEX TO DBINST1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO STATUS="A".AND.CATEG="1"

SELECT 5
IF NetUse("DBFERI","FERIADO")          /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 14
IF NetUse("DBVEIC","VEICULO")          /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO STATUS="A"

SELECT 3
IF NetUse("DBALU","ALUNO")             /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")            /* Programa‡Æo de Aulas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE222";ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "22"
SET KEY -1 TO Mostra()
wData:=CTOD(""); wHora:=SPACE(4); wNom:=SPACE(5)
WHILE .T.
   xData:=CTOD(""); xHora:=SPACE(4)
   SETCOLOR(YCOREDIT)
   Telas(8,3,18,68,1,YCOREDIT,.T.,"Transferˆncia de Aulas")
   Mensagem("Informe Matricula do Aluno e Data da Aula")
   
   @ 12,03 SAY "Ã"+REPL("Ä",64)+"´"
   @ 09,05 SAY "Matr¡cula:" GET wNom PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,9,22,wNom,"NOME",["@S40"],"Matr¡cula NÆo Localizada")
   @ 10,05 SAY "Data.....:" GET wData PICT "@D"  WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wData)
   @ 11,05 SAY "Hora.....:" GET wHora PICT "@R 99:99"  VALID LASTKEY()==K_UP.OR.!EMPTY(wHora)
   @ 13,05 SAY "Ve¡culo..:"
   @ 14,05 SAY "Instrutor:"
   @ 15,05 SAY "Embarque.:   Local:"
   @ 16,05 SAY "Nova Data:"
   @ 17,05 SAY "Nova Hora:"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   ChkPend(wNom)  // Verifica pendencia
   IF AULAS->(DBSEEK(wNom+DTOS(wData)+wHora))
      IF !AULAS->COBRADA
         IF !AULAS->STATUS
            wVei:=AULAS->CODVEIC; wEmbarq:=AULAS->EMBARQ; wLocal:=AULAS->LOCAL;wCodinst:=AULAS->CODINST
            @ 13,05 SAY "Ve¡culo..:" GET wVei     PICT "99"   WHEN TeclaFuncao(.T.);
              VALID !EMPTY(wVei).AND.TDescr(14,1,13,22,wVei,"MARCA",,"Ve¡culo NÆo Cadastrado").AND.Let(wCodInst:=VEICULO->CODINST).AND.Let(TDescr(7,1,14,22,wCodInst,"NOME",["@S30"]))
            @ 14,05 SAY "Instrutor:" GET wCodInst PICT "9999" WHEN .F.
            @ 15,05 SAY "Embarque.:" GET wEmbarq  PICT "!"    WHEN TeclaFuncao().AND.HTela(3) VALID VTela(3)
            @ 15,18 SAY "Local:"     GET wLocal   PICT "@!"   WHEN wEmbarq=="O"
            @ 16,05 SAY "Nova Data:" GET xData    PICT "@D";
              VALID LASTKEY()==K_UP.OR.!EMPTY(xData).AND.xData>cDtSys.AND.TData(xData)
            @ 17,05 SAY "Nova Hora:" GET xHora    PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.TVagaAut(xData,xHora)
            SETCURSOR(1); READ; SETCURSOR(0)
            IF LASTKEY()==K_ESC
               IF LEN(Telas)==4; Rest_Tela(); ENDIF
               EXIT
            ENDIF
            IF Confirma("Confirma Novo Hor rio ?")
               AULAS->(DBSEEK(wNom+DTOS(wData)+wHora))
               WHILE !AULAS->(NetLReg()); ENDDO
               REPLACE AULAS->CODVEIC WITH wVei,;
                       AULAS->CODINST WITH TCodInst(wVei),;
                       AULAS->EMBARQ  WITH wEmbarq,;
                       AULAS->LOCAL   WITH wLocal,;
                       AULAS->DATA    WITH xData,;
                       AULAS->HORA    WITH xHora
               AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())

               /* Renumerar as aulas */
               AULAS->(DBSEEK(wNom)); xNum:=1
               WHILE AULAS->MATRIC==wNom
                  WHILE !AULAS->(NetLReg()); ENDDO
                  REPLACE AULAS->NUMERO WITH STRZERO(xNum++,2)
                  AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
                  AULAS->(DBSKIP())
               ENDDO

               ProcOk("Transferido",.T.)
            ENDIF
         ELSE
            Aviso("Aula Cancelada...",,3)
         ENDIF
      ELSE
         Aviso("Aula j  Efetuada...",,3)
      ENDIF
   ELSE
      Aviso("NÆo h  aula para este aluno nesta data e hor rio...",,3)
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DBCLOSEALL(); RETURN
