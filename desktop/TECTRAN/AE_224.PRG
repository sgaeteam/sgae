*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_224                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Remarcaฦo de Aulas                      ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL vTela

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"SEL"      ,"C",  01,0}) /* Selecao              */
AADD(aDbf,{"NUMERO"   ,"C",  02,0}) /* Numero da Aula       */
AADD(aDbf,{"DATA"     ,"D",  08,0}) /* Data da Aula         */
AADD(aDbf,{"HORA"     ,"C",  04,0}) /* Hora da Aula         */
AADD(aDbf,{"INSTRUT"  ,"C",  15,0}) /* Cod. Instrutor       */
AADD(aDbf,{"VEICULO"  ,"C",  15,0}) /* Cod. Veiculo         */
AADD(aDbf,{"CODINST"  ,"C",  04,0}) /* Cod. Instrutor       */
AADD(aDbf,{"CODVEIC"  ,"C",  02,0}) /* Cod. Veiculo         */
AADD(aDbf,{"MOTIVO"   ,"C",  50,0}) /* Motivo               */
AADD(aDbf,{"CONTATO"  ,"C",  20,0}) /* Contato              */
AADD(aDbf,{"GRAU"     ,"C",  20,0}) /* Grau Afinidade       */
AADD(aDbf,{"DTCONT"   ,"D",  08,0}) /* Data do contato      */
AADD(aDbf,{"HCONT"    ,"C",  04,0}) /* Hora do contato      */
AADD(aDbf,{"PROTOCOLO","C",  08,0}) /* Numero do Protocolo  */
AADD(aDbf,{"USER"     ,"C",  25,0}) /* Operador             */
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
INDEX ON DTOS(data)+hora TO (cArq1)

SELECT 21
IF NetUse("DBDESM","DESMARCA")      /* Aulas desmarcadas */
   SET INDEX TO DBIDES4,DBIDES1,DBIDES2,DBIDES3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 16
IF NetUse("DBPEND","PENDENCIA")     /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBFERI","FERIADO")       /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 14
IF NetUse("DBVEIC","VEICULO")       /* Veกculos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO STATUS="A"

SELECT 3
IF NetUse("DBALU","ALUNO")          /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBINST","INSTRUTOR")     /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO STATUS="A".AND.CATEG="1"

SELECT 1
IF NetUse("DBPROG","AULAS")         /* Programaฦo de Aulas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE224";ProgName("AE224"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "24" 
msg1:="^ESC^-Sair"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,19,76,1,YCOREDIT,.T.,"Remarcaฦo de Aulas Pr ticas")

SET KEY -1 TO Mostra()
wMatr:=SPACE(5); wProt:=SPACE(8)

WHILE .T.
   Mensagem("Informe a Matricula do Aluno"); Linha23(msg1)
   @ 05,05 SAY "Matr.Aluno:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,5,21,wMatr,"NOME",["@S40"],"Aluno Nฦo Localizado")
   @ 06,05 SAY "Protocolo.:" GET wProt PICT "@R 999999/99" WHEN !EMPTY(wMatr)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   ChkPend(wMatr)   // Verifica pendencia
   ChkPrazo(wMatr)  // Verifica prazo do contrato

   // Montar arquivo temporario com aulas desmarcadas em aberto
   IF DESMARCA->(DBSEEK(wMatr+wProt))
      WHILE DESMARCA->MATRIC==wMatr.AND.DESMARCA->PROTOCOLO==wProt.AND.!DESMARCA->(EOF())
         IF !DESMARCA->STATUS    // .t. = remarcada .f. = desmarcada
            PegaInst(DESMARCA->CODINST)
            PegaVeic(DESMARCA->CODVEIC)
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NUMERO     WITH DESMARCA->NUMERO      ,;
                    (cArq1)->DATA       WITH DESMARCA->DATA        ,;
                    (cArq1)->HORA       WITH DESMARCA->HORA        ,;
                    (cArq1)->CODINST    WITH DESMARCA->CODINST     ,;
                    (cArq1)->CODVEIC    WITH DESMARCA->CODVEIC     ,;
                    (cArq1)->MOTIVO     WITH DESMARCA->MOTIVO      ,;
                    (cArq1)->CONTATO    WITH DESMARCA->CONTATO     ,;
                    (cArq1)->GRAU       WITH DESMARCA->GRAU        ,;
                    (cArq1)->DTCONT     WITH DESMARCA->DTCONT      ,;
                    (cArq1)->HCONT      WITH DESMARCA->HCONT       ,;
                    (cArq1)->PROTOCOLO  WITH DESMARCA->PROTOCOLO   ,;
                    (cArq1)->USER       WITH DESMARCA->USER
            (cArq1)->(DBCOMMIT())
         ENDIF
         DESMARCA->(DBSKIP())
      ENDDO
      Browse()
      (cArq1)->(__DBZAP())
   ELSE
      Aviso("Protocolo nฦo encontrado! Tecle algo para continuar...")
   ENDIF
   Mensagem()
ENDDO
Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse de aulas em aberto      ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Browse()

SELECT (cArq1); DBGOTOP()
msg:="^ESC^-Voltar  ^ENTER^-Remarcar"
Telas(7,3,19,76,1,YCOREDIT,.T.,"aulas desmarcadas disponกveis")
Linha23(msg)
oBr:=TBROWSEDB(8,4,18,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Sel"      ,{|| SEL})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Nr."      ,{|| NUMERO})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Data"     ,{|| DATA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Hora"     ,{|| TRANSFORM(HORA,"@R 99:99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Instrutor",{|| TRANSFORM(PegaInst(CODINST),"@S20")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Veกculo"  ,{|| TRANSFORM(PegaVeic(CODVEIC),"@S15")})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_ENTER )
      IF (cArq1)->SEL="*"
         Aviso("Aula j  remarcada!")
      ELSE
         RemAula()
         oBr:refreshall()
      ENDIF
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
Rest_Tela();RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Registro da remarcacao         ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE RemAula()
SET KEY -1 TO Mostra()
Telas(14,3,20,76,1,YCOREDIT,.T.)
WHILE .T.
   xData:=CTOD(""); xHora:=wCodinst:=SPACE(4); wVei:=SPACE(2); wEmbarq:="E"; wLocal:=SPACE(25)

   @ 15,05 SAY "Veกculo..........:" GET wVei       PICT "99"       WHEN TeclaFuncao(.T.) VALID !EMPTY(wVei).AND.;
     TDescr(14,1,15,30,wVei,"MARCA",,"Veiculo inexistente!").AND.Let(wCodInst:=VEICULO->CODINST).AND.Let(TDescr(5,1,16,30,wCodInst,"NOME",["@S25"]))
   @ 16,05 SAY "Instrutor........:" GET wCodInst   PICT "9999"     WHEN .F.
   @ 17,05 SAY "Data.............:" GET xData      PICT "@D"       VALID LASTKEY()==K_UP.OR.!EMPTY(xData).AND.xData>=cDtSys.AND.TData(xData)
   @ 18,05 SAY "Hora.............:" GET xHora      PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.TVagaAut(xData,xHora)
   @ 19,05 SAY "Local de Embarque:" GET wEmbarq    PICT "!"        WHEN TeclaFuncao().AND.HTela(3) VALID VTela(3)
   @ 19,28 GET wLocal                              PICT "@!S20"    WHEN wEmbarq=="O"
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF Confirma("Confirma Remarcaฦo ?")
      Aguarde("Gravando dados...")

      REPLACE (cArq1)->SEL WITH "*"
      (cArq1)->(DBCOMMIT())

      /* Aumentar pendencias de aulas */
      ALUNO->(DBSEEK(wMatr))
      WHILE !ALUNO->(NetlReg()); ENDDO
      REPLACE ALUNO->PENDENTE WITH ALUNO->PENDENTE + 1,;
              ALUNO->DESMARC  WITH ALUNO->DESMARC  - 1,;
              ALUNO->MARCADA  WITH ALUNO->MARCADA  + 1
      ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())

      /* Gravar no arquivo desmarcacao */
      WHILE !AULAS->(NetApp()); ENDDO
      REPLACE AULAS->DATA    WITH xData    ,;
              AULAS->HORA    WITH xHora    ,;
              AULAS->CODINST WITH wCodInst ,;
              AULAS->CODVEIC WITH wVei     ,;
              AULAS->EMBARQ  WITH wEmbarq  ,;
              AULAS->LOCAL   WITH wLocal   ,;
              AULAS->COBRADA WITH .F.      ,;
              AULAS->STATUS  WITH .F.      ,;
              AULAS->MATRIC  WITH wMatr    ,;
              AULAS->USER    WITH cUsuario
      AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())

      /* Gravar Status */
      DESMARCA->(DBSETORDER(2))
      DESMARCA->(DBSEEK(wMatr+DTOS((cArq1)->DATA)+(cArq1)->HORA))
      WHILE !DESMARCA->(NetLReg()); ENDDO
      REPLACE DESMARCA->STATUS WITH .T.
      DESMARCA->(DBSETORDER(1))

      /* Renumerar as aulas */
      AULAS->(DBSEEK(wMatr)); xNum:=1
      WHILE AULAS->MATRIC==wMatr
         WHILE !AULAS->(NetLReg()); ENDDO
         REPLACE AULAS->NUMERO WITH STRZERO(xNum++,2)
         AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
         AULAS->(DBSKIP())
      ENDDO
      Aguarde()
      ProcOk("Remarcaฦo efetuada com Sucesso!",.T.)
      EXIT
   ENDIF
ENDDO
SETKEY(K_F2,NIL);Rest_Tela();RETURN
