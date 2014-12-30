*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_220                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cancelamento de Aulas                    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"OK"    ,"C",   01,0}) /* Presente S/N     */
AADD(aDbf,{"MATRIC","C",   05,0}) /* Matric do Aluno  */
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
INDEX ON matric TO (cArq1)

SELECT 6
IF NetUse("DBFREQ","TEORICA")       /* Frequencias Teขricas */
   SET INDEX TO DBIFREQ2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBTURMA","TURMA")        /* Tabela de Turmas */
   SET INDEX TO DBITURM1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBDISC","DISCIPLINA")    /* Tabela de Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBINST","INSTRUTOR")     /* Instrutores */
   SET INDEX TO DBINST1, DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO TIPO1="2"

SELECT 2
IF NetUse("DBFERI","FERIADO")       /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF
        
SELECT 1
IF NetUse("DBALU","ALUNOS")         /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE232"; ProgName("AE233"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "20"
SET KEY -1 TO Mostra()
wData:=cDtSys;wTurma:=SPACE(10)
wInst:=SPACE(4);wDisc:=SPACE(2)

WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(4,3,7,75,1,YCOREDIT,.T.,"Cancelamento de Aulas Teขricas")
   Mensagem("Informe cขdigo da Turma e Data da Aula")
   @ 05,05 SAY " Turma:" GET wTurma PICT "@!" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wTurma).AND.Pesquisa(5,1,wTurma,"Turma Nฦo Cadastrada!")
   @ 06,05 SAY "  Data:" GET wData PICT "@D"  WHEN TeclaFuncao();
     VALID LASTKEY()==K_UP.OR.!EMPTY(wData).AND.TData(wData)
   @ 05,25 SAY "  Instrutor:" GET wInst PICT "@!"  WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.!EMPTY(wInst).AND.Pesquisa(3,1,wInst,"Nฦo  Instrutor Torico!").AND.;
     TDescr(3,1,5,43,wInst,"NOME",["@S25"])
   @ 06,25 SAY " Disciplina:" GET wDisc PICT "@!" ; 
     VALID LASTKEY()==K_UP.OR.!EMPTY(wDisc).AND.Pesquisa(4,1,wDisc,"Disciplina Nฦo Cadastrada!").AND.;
     TDescr(4,1,6,41,wDisc,"DESCR")
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF TEORICA->(DBSEEK(wTurma+DTOS(wData)+wDisc+wInst))
      WHILE TEORICA->TURMA==wTurma.AND.TEORICA->DATA==wData.AND.;
            TEORICA->CODINST==wInst.AND.TEORICA->DISCIPLINA==wDisc
         IF !("CANCELADO" $ TEORICA->STATUS)
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->OK     WITH " ",;
                    (cArq1)->MATRIC WITH TEORICA->MATRIC
         ENDIF
         TEORICA->(DBSKIP())
      ENDDO
      LinhaMsg(13)
      Baixa()
   ELSE
      Aviso("Nฦo h  Aula Teorica para esta turma, disciplina e instrutor nesta data...",,3)
   ENDIF
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ                                ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION Baixa()
  LOCAL lMudou:=.F.
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(7,3,19,75,1,YCOREDIT,.T.)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(8,4,18,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Cancelado",{|| OK})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno",{|| TAluno(MATRIC)})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF Confirma("Lista de Alunos Cancelados OK ?")
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
                TEORICA->(DBSEEK( wTurma + DTOS(wData) + wDisc + wInst + (cArq1)->MATRIC ))
                IF (cArq1)->OK == "X"
                   WHILE !TEORICA->(NetLReg()); ENDDO
                   REPL TEORICA->STATUS WITH "CANCELADO      "
                   TEORICA->(DBUNLOCK())
                ELSE
                   WHILE !TEORICA->(NetLReg()); ENDDO
                   REPL TEORICA->STATUS WITH "               "
                   TEORICA->(DBUNLOCK())
                ENDIF
                (cArq1)->(DBSKIP())
           ENDDO
           EXIT
        ELSE
           IF Confirma("Deseja Sair da Lista ?")
              EXIT
           ENDIF            
        ENDIF
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F6 .OR. tecla == K_F7 )
        (cArq1)->(DBGOTOP())
        WHILE !(cArq1)->(EOF())
           REPL (cArq1)->OK WITH IF(tecla == K_F6," ","X")
           (cArq1)->(DBSKIP())
        ENDDO
        (cArq1)->(DBGOTOP())
        oBr:Refreshall()
     ELSEIF ( tecla == K_ENTER )
        lMudou:=.T.
        REPLACE (cArq1)->OK WITH IF((cArq1)->OK==" ","X"," ")
        oBr:Refreshall()
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
