*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_223                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Desmarca‡Æo de Aulas                     ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL vTela

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"SEL"      ,"C",   01,0}) /* Selecao              */
AADD(aDbf,{"NUMERO"   ,"C",   02,0}) /* Numero da Aula       */
AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Treino       */
AADD(aDbf,{"HORA"     ,"C",   04,0}) /* Hora Prevista        */
AADD(aDbf,{"INSTRUT"  ,"C",   15,0}) /* Cod. Instrutor       */
AADD(aDbf,{"VEICULO"  ,"C",   15,0}) /* Cod. Veiculo         */
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C¢digo do Instrutor  */
AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* C¢digo do Ve¡culo    */
AADD(aDbf,{"USER"     ,"C",   25,0}) /* Nome do Usuario      */
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

SELECT 6
IF NetUse("DBPEND","PENDENCIA")      /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 5
IF NetUse("DBINST","INSTRUTOR")      /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 21
IF NetUse("DBDESM","DESMARCA")       /* Desmarca‡Æo de Aulas */
   SET INDEX TO DBIDES1,DBIDES2,DBIDES3,DBIDES4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")          /* Programa‡Æo de Aulas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE223";ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "23"

msg1:="^ESC^-Sair"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,19,76,1,YCOREDIT,.T.,"Desmarca‡Æo de Aulas Pr ticas")

SET KEY -1 TO Mostra()
wMatr:=SPACE(5)

WHILE .T.
   Mensagem("Informe matr¡cula do Aluno"); Linha23(msg1)
   @ 05,05 SAY "Aluno..:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,5,21,wMatr,"NOME",["@S40"],"Aluno NÆo Localizado")
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   ChkPend(wMatr)  // Verifica pendencia

   // Montar arquivo temporario
   AULAS->(DBSEEK(wMatr))
   WHILE AULAS->MATRIC==wMatr.AND.!AULAS->(EOF())
      IF !AULAS->COBRADA .AND. !AULAS->STATUS .AND. AULAS->DATA >= (cDtSys+1)
         PegaInst(AULAS->CODINST)
         PegaVeic(AULAS->CODVEIC)
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NUMERO  WITH AULAS->NUMERO    ,;
                 (cArq1)->DATA    WITH AULAS->DATA      ,;
                 (cArq1)->HORA    WITH AULAS->HORA      ,;
                 (cArq1)->CODINST WITH AULAS->CODINST   ,;
                 (cArq1)->CODVEIC WITH AULAS->CODVEIC   ,;
                 (cArq1)->INSTRUT WITH INSTRUTOR->NOME  ,;
                 (cArq1)->VEICULO WITH VEICULO->MARCA
         (cArq1)->(DBCOMMIT())
      ENDIF
      AULAS->(DBSKIP())
   ENDDO
   Browse()
   (cArq1)->(__DBZAP())
   Mensagem()
ENDDO
Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Browse de aulas em aberto      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE Browse()

SELECT (cArq1); DBGOTOP()
msg:="^ESC^-Voltar  ^ENTER^-Sel/Canc. ^F9^-Imprime ^F10^-Confirmar Sele‡Æo"
Telas(6,3,19,76,1,YCOREDIT,.T.,"aulas programadas")
Linha23(msg)
oBr:=TBROWSEDB(7,4,18,75)
oBr:headSep:="ÄÂÄ"
oBr:colSep:= " ³ "

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
oCol:=TBCOLUMNNEW("Ve¡culo"  ,{|| TRANSFORM(PegaVeic(CODVEIC),"@S15")})
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
   ELSEIF ( tecla == K_F9 )  // Imprime
      Aviso("Em desenvolvimento...")
*     IF ChkImpr()
*        nReg:=(cArq1)->(RECNO())
*        cAviso := MsgImp(.F.)
*        (cArq1)->(DBGOTOP())
*        ImpDesm()
*        TiraMsgImp(cAviso)
*        WaitMsg("Fim de ImpressÆo, tecle algo...")
*        SELECT (cArq1); GO nReg
*        oBr:Refreshcurrent()
*     ENDIF
   ELSEIF ( tecla == K_F10 )
      /* Verificar se houve alguma selecao */
      nReg:=RECNO();lSel:=.F.;nSel:=0
      DBGOTOP()
      WHILE !EOF()
        IF SEL=="X"
           lSel:=.T.;nSel++
        ENDIF
        DBSKIP()
      ENDDO
      IF lSel
         MotDes(nSel); EXIT
      ELSE
         Aviso("Nenhuma sele‡ao foi detectada!",,3)
         DBGOTO(nReg)
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      REPLACE (cArq1)->SEL WITH (cArq1)->(IF(EMPTY((cArq1)->SEL),"X"," "))
      (cArq1)->(DBCOMMIT())
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
Rest_Tela();RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Registro da desmarcacao        ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE MotDes(nSel)
Telas(11,3,19,76,1,YCOREDIT,.T.)
WHILE .T.
   DESMARCA->(DBGOBOTTOM()); DESMARCA->(DBSKIP())
   FOR a = 1 TO DESMARCA->(FCOUNT())
       xVar  := "w"+DESMARCA->(FIELDNAME(a))
       &xVar := DESMARCA->(FIELDGET(a))
   NEXT
   wHCont     := SUBS(TIME(),1,2)+SUBS(TIME(),4,2)
   wProtocolo := SUBS(TIME(),1,2)+SUBS(TIME(),4,2)+SUBS(TIME(),7,2)+STRZERO(nSel,2)

   @ 12,05 SAY "N§ do Protocolo........:" GET wProtocolo PICT "@R 999999/99" WHEN .F.
   @ 13,05 SAY "Motivo da desmarca‡Æo..:" GET wMotivo    PICT "@!S45"    VALID LASTKEY()==K_UP.OR.!EMPTY(wMotivo)
   @ 14,05 SAY "Respons vel pelo Pedido:" GET wContato                   VALID LASTKEY()==K_UP.OR.!EMPTY(wContato)
   @ 15,05 SAY "Grau de Afinidade......:" GET wGrau
   @ 16,05 SAY "Data do Pedido.........:" GET wDtCont    PICT "@D"       VALID LASTKEY()==K_UP.OR.!EMPTY(wDtCont)
   @ 17,05 SAY "Hora do Conhecimento...:" GET wHCont     PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.!EMPTY(wHCont)
   @ 18,05 SAY "Observa‡oes............:" GET wObs       PICT "@!S45"
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF Confirma("Confirma Desmarca‡Æo ?")
      (cArq1)->(DBGOTOP())
      WHILE !(cArq1)->(EOF())
         IF (cArq1)->SEL=="X"
            /* Diminuir pendencias de aulas */
            ALUNOS->(DBSEEK(wMatr))
            WHILE !ALUNOS->(NetlReg()); ENDDO
            REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE - 1,;
                    ALUNOS->DESMARC  WITH ALUNOS->DESMARC  + 1,;
                    ALUNOS->MARCADA  WITH ALUNOS->MARCADA  - 1
            ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())

            /* Gravar no arquivo desmarcacao */
            wMatric  := wMatr
            wCodInst := (cArq1)->CODINST
            wCodVeic := (cArq1)->CODVEIC
            wNumero  := (cArq1)->NUMERO
            wData    := (cArq1)->DATA
            wHora    := (cArq1)->HORA
            wDtMov   := cDtSys
            wUser    := cUsuario
            WHILE !DESMARCA->(NetApp()); ENDDO()
            FOR a = 1 TO DESMARCA->(FCOUNT())
                xVar  := "w"+DESMARCA->(FIELDNAME(a))
                DESMARCA->(FIELDPUT(a,&xVar))
            NEXT

            /* Eliminar da programa‡Æo */
            AULAS->(DBSEEK(wMatr+DTOS((cArq1)->DATA)+(cArq1)->HORA))
            WHILE !AULAS->(NetLReg()); ENDDO
            AULAS->(DBDELETE()); AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())

            /* Renumerar as aulas */
            AULAS->(DBSEEK(wMatr)); xNum:=1
            WHILE AULAS->MATRIC==wMatr
               WHILE !AULAS->(NetLReg()); ENDDO
               REPLACE AULAS->NUMERO WITH STRZERO(xNum++,2)
               AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
               AULAS->(DBSKIP())
            ENDDO
         ENDIF
         (cArq1)->(DBSKIP())
      ENDDO
      ProcOk("Desmarca‡oes efetuadas com Sucesso!",.T.)
      EXIT
   ENDIF
ENDDO
Rest_Tela();RETURN
