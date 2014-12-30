*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_115                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Registro de Pendencia de Alunos          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 23/07/2005                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL vTela

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"DTREG"    ,"D",   08,0}) /* Data do Registro     */
AADD(aDbf,{"HREG"     ,"C",   04,0}) /* Hora do Registro     */
AADD(aDbf,{"DTOK"     ,"D",   08,0}) /* Data da Baixa        */
AADD(aDbf,{"DESCR1"   ,"C",   60,0}) /* Descricao            */
AADD(aDbf,{"DESCR2"   ,"C",   60,0}) /* Descricao            */
AADD(aDbf,{"DESCR3"   ,"C",   60,0}) /* Descricao            */
AADD(aDbf,{"BAIXA"    ,"C",   01,0}) /* Condicao da Baixa    */
AADD(aDbf,{"USER"     ,"C",   20,0}) /* Nome do Usuario      */
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
INDEX ON DTOS(dtreg)+hreg TO (cArq1) DESCEND

SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPEND","PENDENCIA")      /* Cadastro de Pendencias */
   SET INDEX TO DBIPEND1
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE115";ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "1"; cOpHelp2 := "15"

msg1:="^ESC^-Sair"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,19,76,1,YCOREDIT,.T.,"Pendncias de Aluno")

SET KEY -1 TO Mostra()
wMatr:=SPACE(5)

WHILE .T.
   Mensagem("Informe matrกcula do Aluno"); Linha23(msg1)
   @ 05,05 SAY "Aluno..:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,5,21,wMatr,"NOME",["@S40"],"Aluno Nฦo Localizado")
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   // Montar arquivo temporario
   PENDENCIA->(DBSEEK(wMatr))
   WHILE PENDENCIA->MATRIC==wMatr.AND.!PENDENCIA->(EOF())
      (cArq1)->(DBAPPEND())
      REPLACE (cArq1)->DTREG   WITH PENDENCIA->DTREG ,;
              (cArq1)->HREG    WITH PENDENCIA->HREG  ,;
              (cArq1)->DTOK    WITH PENDENCIA->DTOK  ,;
              (cArq1)->DESCR1  WITH PENDENCIA->DESCR1,;
              (cArq1)->DESCR2  WITH PENDENCIA->DESCR2,;
              (cArq1)->DESCR3  WITH PENDENCIA->DESCR3,;
              (cArq1)->BAIXA   WITH IF(PENDENCIA->BAIXA,"*"," "),;
              (cArq1)->USER    WITH PENDENCIA->USER
      (cArq1)->(DBCOMMIT())
      PENDENCIA->(DBSKIP())
   ENDDO
   Browse()
   (cArq1)->(__DBZAP())
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
msg:="^ESC^-Voltar  ^INS^-Inclui ^ENTER^-Baixa ^F9^-Imprime"
Telas(6,3,19,76,1,YCOREDIT,.T.)
Linha23(msg)
oBr:=TBROWSEDB(7,4,18,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Baixa"    ,{|| BAIXA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Dt.Reg"   ,{|| DTREG})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Hora"     ,{|| TRANSFORM(HREG,"@R 99:99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Dt.Ok"    ,{|| DTOK})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pendncia",{|| DESCR1})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pendncia",{|| DESCR2})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pendncia",{|| DESCR3})
oBr:addColumn(oCol)
IF nNivel>=5
   oCol:=TBCOLUMNNEW("Usu rio"  ,{|| USER})
   oBr:addColumn(oCol)
ENDIF

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
   ELSEIF ( tecla == K_INS )
      RegPend()
      oBr:refreshall()
   ELSEIF ( tecla == K_ENTER )
      PENDENCIA->(DBSEEK(wMatr+DTOS((cArq1)->DTREG)+(cArq1)->HREG))
      WHILE !PENDENCIA->(NetlReg()); ENDDO()
      REPLACE PENDENCIA->BAIXA WITH (cArq1)->(IF(EMPTY((cArq1)->BAIXA),.T.,.F.))
      REPLACE PENDENCIA->DTOK  WITH cDtSys
      PENDENCIA->(DBCOMMIT())

      REPLACE (cArq1)->BAIXA WITH (cArq1)->(IF(EMPTY((cArq1)->BAIXA),"*"," "))
      REPLACE (cArq1)->DTOK  WITH cDtSys
      (cArq1)->(DBCOMMIT())
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
Rest_Tela();RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Registro da Pendencia          ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE RegPend()
Telas(15,3,19,76,1,YCOREDIT,.T.,"Descriฦo da Pendncia")
WHILE .T.
   PENDENCIA->(DBGOBOTTOM()); PENDENCIA->(DBSKIP())
   FOR a = 1 TO PENDENCIA->(FCOUNT())
       xVar  := "w"+PENDENCIA->(FIELDNAME(a))
       &xVar := PENDENCIA->(FIELDGET(a))
   NEXT

   @ 16,05 GET wDescr1    PICT "@!" VALID !EMPTY(wDescr1)
   @ 17,05 GET wDescr2    PICT "@!"
   @ 18,05 GET wDescr3    PICT "@!"
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF Confirma("Confirma Registro ?")
      /* Gravar no arquivo principal */
      wMatric  := wMatr
      wHReg    := SUBS(TIME(),1,2)+SUBS(TIME(),4,2)
      wDtReg   := cDtSys
      wBaixa   := .F.
      wUser    := cUsuario
      WHILE !PENDENCIA->(NetApp()); ENDDO()
      FOR a = 1 TO PENDENCIA->(FCOUNT())
          xVar  := "w"+PENDENCIA->(FIELDNAME(a))
          PENDENCIA->(FIELDPUT(a,&xVar))
      NEXT
      PENDENCIA->(DBCOMMIT())

      /* Gravar no arquivo temporario */
      (cArq1)->(DBAPPEND())
      wBaixa := " "
      FOR a = 1 TO (cArq1)->(FCOUNT())
          xVar  := "w"+(cArq1)->(FIELDNAME(a))
          (cArq1)->(FIELDPUT(a,&xVar))
      NEXT
      (cArq1)->(DBCOMMIT())

      ProcOk("Registro da Pendncia efetuada com Sucesso!",.T.)
      EXIT
   ENDIF
ENDDO
Rest_Tela();RETURN
