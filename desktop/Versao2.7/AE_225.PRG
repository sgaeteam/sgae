*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_225                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Aulas Pendentes                          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 28/08/1998                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"OK"       ,"C",   01,0}) /* Status de Lanamento de Aulas   */
AADD(aDbf,{"CANC"     ,"C",   01,0}) /* Status de Cancelamento de Aulas */
AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data da Aulas     */
AADD(aDbf,{"HORA"     ,"C",   02,0}) /* Hora da Aulas     */
AADD(aDbf,{"EMBARQ"   ,"C",   01,0}) /* Local de Embarque */
AADD(aDbf,{"ALUNO"    ,"C",   50,0}) /* Nome do Aluno     */
AADD(aDbf,{"VEICULO"  ,"C",   30,0}) /* Nome do Veiculo   */
AADD(aDbf,{"INSTRUTOR","C",   50,0}) /* Nome do Instrutor */
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* Cod. do Instrutor */
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula do Aluno */
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
INDEX ON DTOS(DATA) TO (cArq1)

SELECT 5
IF NetUse("DBFERI","FERIADO")         /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Cadastro de Veกculos */
   SET INDEX TO DBIVEI1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNOS")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")      /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")          /* Arquivo de Programaฦo de Aulas */
   SET INDEX TO DBIPRO3,DBIPRO1,DBIPRO2,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE225"; ProgName("AE225"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "25"
xAnt:=2; xData:=cDtSys-xAnt; lMudou:=.F.

/* Saber se xdata  feriado */
WHILE .T.
   IF FERIADO->(DBSEEK(xData)).OR.DOW(xData)=1
      xAnt++
      xData:=cDtSys-xAnt
   ELSE
      EXIT
   ENDIF
ENDDO

/* Montar Tabela de Alunos com aulas Pendentes */
Aguarde("Procurando Registros...")
VEICULO->(DBGOTOP())
WHILE !VEICULO->(EOF())
  AULAS->(DBSEEK(VEICULO->CODVEIC))
  WHILE AULAS->CODVEIC==VEICULO->CODVEIC.AND.!AULAS->(EOF())
     IF !AULAS->COBRADA.AND.!AULAS->STATUS.AND.AULAS->DATA<=xData
        ALUNOS->(DBSEEK(AULAS->MATRIC))
        INSTRUTOR->(DBSEEK(VEICULO->CODINST))
        (cArq1)->(DBAPPEND())
        REPLACE (cArq1)->DATA      WITH AULAS->DATA     ,;
                (cArq1)->HORA      WITH AULAS->HORA     ,;
                (cArq1)->EMBARQ    WITH AULAS->EMBARQ   ,;
                (cArq1)->ALUNO     WITH ALUNOS->NOME    ,;
                (cArq1)->VEICULO   WITH VEICULO->MARCA  ,;
                (cArq1)->INSTRUTOR WITH INSTRUTOR->NOME ,;
                (cArq1)->CODINST   WITH INSTRUTOR->CODINST,;
                (cArq1)->MATRIC    WITH ALUNOS->MATRIC
        (cArq1)->(DBCOMMIT())
     ENDIF
     AULAS->(DBSKIP())
  ENDDO
  VEICULO->(DBSKIP())
ENDDO
Aguarde()

SELECT (cArq1); DBGOTOP()
SETCOLOR(YCOREDIT)
Telas(4,1,20,76,1,YCOREDIT,.T.,"Aulas Pendentes")
LinhaMsg(13)

oBr:=TBROWSEDB(5,2,19,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Ok"  ,{|| OK})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Canc",{|| CANC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Data",{|| DATA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Matr.",{|| MATRIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Aluno",{|| TRANSFORM(ALUNO,"@S30")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Veกculo",{|| TRANSFORM(VEICULO,"@S15")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Instrutor",{|| TRANSFORM(INSTRUTOR,"@S30")})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      IF lMudou.AND.Confirma("Confirma Lanamentos ?")
         Aguarde("Atualizando...")
         (cArq1)->(DBGOTOP())
         WHILE !(cArq1)->(EOF())
            IF (cArq1)->OK=="X"
               /* Diminuir pendencias de aulas */
               ALUNOS->(DBSEEK((cArq1)->MATRIC))
               WHILE !ALUNOS->(NetlReg()); ENDDO
               REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE - 1
               ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())

               /* Tornar a aula Dada */
               AULAS->(DBSETORDER(2))
               AULAS->(DBSEEK((cArq1)->MATRIC+DTOS((cArq1)->DATA)+(cArq1)->HORA+(cArq1)->EMBARQ))
               WHILE !AULAS->(NetlReg()); ENDDO
               REPLACE AULAS->COBRADA WITH .T.
               AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
               AULAS->(DBSETORDER(1))
            ENDIF
            IF (cArq1)->CANC=="X"
               /* Tornar a aula cancelada */
               AULAS->(DBSETORDER(2))
               AULAS->(DBSEEK((cArq1)->MATRIC+DTOS((cArq1)->DATA)+(cArq1)->HORA+(cArq1)->EMBARQ))
               WHILE !AULAS->(NetlReg()); ENDDO
               REPLACE AULAS->STATUS WITH .T.
               AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
               AULAS->(DBSETORDER(1))
            ENDIF
            (cArq1)->(DBSKIP())
         ENDDO
         Aguarde()
      ENDIF
      EXIT
   ELSEIF ( tecla == K_F1 )
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F2 )
      Ajuda()
   ELSEIF ( tecla == K_F4 )
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_F6 )    /* Marca e Desmarca todos Cancelamento */
      xReg:=(cArq1)->(RECNO())
      (cArq1)->(DBGOTOP())
      WHILE !(cArq1)->(EOF())
         REPLACE (cArq1)->CANC WITH IF((cArq1)->CANC==" ","X"," ")
         (cArq1)->(DBSKIP())
      ENDDO
      lMudou:=.T.
      (cArq1)->(DBGOTO(xReg))
      oBr:Refreshall()
   ELSEIF ( tecla == K_F7 )    /* Marca e Desmarca todos Aula Dada */
      xReg:=(cArq1)->(RECNO())
      (cArq1)->(DBGOTOP())
      WHILE !(cArq1)->(EOF())
         REPLACE (cArq1)->OK WITH IF((cArq1)->OK==" ","X"," ")
         (cArq1)->(DBSKIP())
      ENDDO
      lMudou:=.T.
      (cArq1)->(DBGOTO(xReg))
      oBr:Refreshall()
   ELSEIF ( tecla == K_ENTER )
      IF oBr:colpos()==1
         lMudou:=.T.
         REPLACE (cArq1)->OK WITH IF((cArq1)->OK==" ","X"," ")
      ELSEIF oBr:colpos()==2
         lMudou:=.T.
         REPLACE (cArq1)->CANC WITH IF((cArq1)->CANC==" ","X"," ")
      ENDIF
      oBr:Refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
Rest_Tela()
DelDbfNtx(); RETURN
