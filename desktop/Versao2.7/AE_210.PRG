*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_210                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Registrar Programa‡Æo de Aulas           ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NUMERO" ,"C", 02,0}) /* Numero da Aula   */
AADD(aDbf,{"LOCAL"  ,"C", 25,0}) /* Local Embarque   */
AADD(aDbf,{"DATA"   ,"D", 08,0}) /* Data do Exame    */
AADD(aDbf,{"HORA"   ,"C", 04,0}) /* Hora Prevista    */
AADD(aDbf,{"REALIZ" ,"C", 05,0}) /* Aula Realizada   */
AADD(aDbf,{"INSTRUT","C", 15,0}) /* Cod. Instrutor   */
AADD(aDbf,{"VEICULO","C", 15,0}) /* Cod. Veiculo     */
AADD(aDbf,{"CODINST","C", 04,0}) /* Cod. instrutor   */
AADD(aDbf,{"PLACA"  ,"C", 07,0}) /* Placa do Veiculo */
AADD(aDbf,{"EMBARQ" ,"C", 01,0}) /* Local Embarque   */
AADD(aDbf,{"NOVA"   ,"C", 01,0}) /* Novas Aulas      */
AADD(aDbf,{"USER"   ,"C", 30,0}) /* Operador         */
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
INDEX ON DTOS(data)+hora+veiculo+embarq TO (cArq1)

SELECT 14
IF NetUse("DBVEIC","VEICULO")         /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DelDbfNtx(); RETURN
ENDIF
IF VEICULO->(EOF())
   Aviso("Vocˆ precisa definir cadastrando os ve¡culos primeiro",,3)
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO STATUS="A"

SELECT 12
IF NetUse("DBCURSO","CURSO")          /* Cursos */
   SET INDEX TO DBICUR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar os cursos!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 30
IF NetUse("DBCP","CP")                /* Conteudo Programatico Pratico */
   SET INDEX TO DBICP1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 8
IF NetUse("DBCX","CAIXA")             /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 18
IF !NetUse("DBPARM")                  /* Parametros */
   DelDbfNtx(); RETURN
ENDIF

SELECT 17
IF NetUse("DBREQ","REQ")              /* Requerimentos */
   SET INDEX TO DBIREQ1
ELSE
   RETURN
ENDIF

SELECT 16
IF NetUse("DBPEND","PENDENCIA")       /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBPAG","PAGAR")            /* Pagamentos de Alunos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBFERI","FERIADO")         /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")            /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")           /* Programa‡Æo de Aulas Praticas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE210"; ProgName(cPrg); LinhaMsg(2)
PUBLIC xVeiculo:=SPACE(2); xDtPrev:=xDtPrev1:=cDtSys; xHora:=xHora1:=SPACE(4)
cOpHelp1 := "2"; cOpHelp2 := "10"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SET KEY -1 TO Mostra()
WHILE .T.
   wCod:= DBPARM->MATRIC; xDtInscr:=CTOD(""); nTotalAu:=0
   SETCOLOR(YCOREDIT)
   Telas(3,3,5,76,1,YCOREDIT,.T.,"Programa‡Æo de Aulas Pr ticas")
   Mensagem("Preencha os dados corretamente")
   @ 04,05 SAY "Matr¡cula:" GET wCod PICT "99999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wCod).AND.TDescr(3,1,4,22,wCod,"NOME",["@S40"],"Matr¡cula NÆo Localizada").AND.Let(xDtInscr:=ALUNO->DTINSCR)
   @ 04,60 GET xDtInscr PICT "@D" WHEN .F.
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   ChkPend(wCod)  // Verifica pendencia
   ChkPReq(wCod)  // Verifica pendencia de requerimento

   lMarcou   := .F.
   wNome     := ALUNO->NOME
   wEndereco := ALUNO->ENDERECO
   wCateg    := ALUNO->CATEG
   wRG       := ALUNO->RG
   wRENACH   := ALUNO->RENACH
   nFaltas   := 0
   AULAS->(DBSETORDER(1))
   IF AULAS->(DBSEEK(wCod))
      WHILE AULAS->MATRIC==wCod.AND.!AULAS->(EOF())
         /* Alimentar arq. tempor rio */
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->DATA    WITH AULAS->DATA,;
                 (cArq1)->NUMERO  WITH AULAS->NUMERO,;
                 (cArq1)->HORA    WITH AULAS->HORA,;
                 (cArq1)->REALIZ  WITH IF(AULAS->COBRADA,"Ok",IF(AULAS->STATUS,"Falta",SPACE(5))),;
                 (cArq1)->INSTRUT WITH AULAS->CODINST,;
                 (cArq1)->CODINST WITH AULAS->CODINST,;
                 (cArq1)->VEICULO WITH AULAS->CODVEIC,;
                 (cArq1)->PLACA   WITH PegaPlaca(AULAS->CODVEIC),;
                 (cArq1)->EMBARQ  WITH AULAS->EMBARQ,;
                 (cArq1)->USER    WITH AULAS->USER,;
                 (cArq1)->LOCAL   WITH AULAS->LOCAL
         IF AULAS->STATUS; nFaltas++; ENDIF
         IF AULAS->COBRADA
            nTotalAu++
         ENDIF
         AULAS->(DBSKIP())
      ENDDO
   ENDIF
   Programacao(); LinhaMsg(2)
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela(LEN(telas)-3)
ENDDO
RELEASE xVeiculo,xDtPrev,xHora
SETKEY(K_F2,NIL); Rest_Tela(LEN(telas)-2)
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Programa‡Æo das Datas          ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION Programacao()
  PUBLIC nSel
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(5,3,18,76,1,YCOREDIT,.T.)
  Linha23("^ESC^-Volta ^F6^-Marca ^F8^-Vende+Aulas ^F9^-Imprime ^F10^-Fones ^F11^-Pesq.Vagas")
  Telas(18,3,21,76,1,YCOREDIT,.T.," Quantidade de Aulas ")

  nCompradas:= ALUNO->AULAS
  nMarcada  := ALUNO->MARCADA
  nPendente := ALUNO->PENDENTE
  nDesmarc  := ALUNO->DESMARC
  nCredSM   := ALUNO->AULAS-(ALUNO->MARCADA+ALUNO->DESMARC)

  DispAulas()
* msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(6,4,17,75)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "

  oCol:=TBCOLUMNNEW("N§"        ,{|| NUMERO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Instrutor" ,{|| TRANSFORM(PegaInst(CODINST),"@S20")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Emb."      ,{|| EMBARQ})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data"      ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"      ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aula"      ,{|| REALIZ})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Veiculo"   ,{|| TRANSFORM(TNomVeic(VEICULO,.T.),"@S20")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Operador"  ,{|| USER})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     lRotAut:=.F.
     IF ( tecla == K_ESC )
        IF (cArq1)->(LASTREC())<(ALUNO->MARCADA+ALUNO->DESMARC)
           IF Confirma("Existem aulas nao marcadas. Aborta ?")
              IF lMarcou
                 /* Gravar as Datas das Novas aulas */
                 AULAS->(DBSETORDER(1))
                 (cArq1)->(DBGOTOP())
                 WHILE !(cArq1)->(EOF())
                    IF RTRIM((cArq1)->REALIZ)#"Ok".AND.;
                       !AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                       WHILE !AULAS->(NetApp()); ENDDO
                       REPLACE AULAS->MATRIC  WITH wCod,;
                               AULAS->CODINST WITH (cArq1)->INSTRUT,;
                               AULAS->CODVEIC WITH (cArq1)->VEICULO,;
                               AULAS->NUMERO  WITH (cArq1)->NUMERO,;
                               AULAS->EMBARQ  WITH (cArq1)->EMBARQ,;
                               AULAS->LOCAL   WITH (cArq1)->LOCAL,;
                               AULAS->DATA    WITH (cArq1)->DATA,;
                               AULAS->HORA    WITH (cArq1)->HORA,;
                               AULAS->USER    WITH cUsuario,;
                               AULAS->COBRADA WITH .F.
                    ENDIF
                    (cArq1)->(DBSKIP())
                 ENDDO
              ENDIF
              EXIT
           ENDIF
        ELSE
           IF lMarcou.OR.lRotAut
              IF Confirma("Todas as informa‡äes estÆo corretas ?")
                 /* Gravar as Datas */
                 AULAS->(DBSETORDER(1))
                 (cArq1)->(DBGOTOP())
                 WHILE !(cArq1)->(EOF())
                    IF RTRIM((cArq1)->REALIZ)#"Ok".AND.;
                       !AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                       WHILE !AULAS->(NetApp()); ENDDO
                       REPLACE AULAS->MATRIC  WITH wCod,;
                               AULAS->CODINST WITH (cArq1)->INSTRUT,;
                               AULAS->CODVEIC WITH (cArq1)->VEICULO,;
                               AULAS->NUMERO  WITH (cArq1)->NUMERO ,;
                               AULAS->EMBARQ  WITH (cArq1)->EMBARQ,;
                               AULAS->LOCAL   WITH (cArq1)->LOCAL,;
                               AULAS->DATA    WITH (cArq1)->DATA,;
                               AULAS->HORA    WITH (cArq1)->HORA,;
                               AULAS->USER    WITH cUsuario,;
                               AULAS->COBRADA WITH .F.
                       AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
                    ELSEIF AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                       WHILE !AULAS->(NetLReg()); ENDDO
                       REPLACE AULAS->CODINST WITH (cArq1)->INSTRUT,;
                               AULAS->CODVEIC WITH (cArq1)->VEICULO,;
                               AULAS->NUMERO  WITH (cArq1)->NUMERO ,;
                               AULAS->EMBARQ  WITH (cArq1)->EMBARQ,;
                               AULAS->DATA    WITH (cArq1)->DATA,;
                               AULAS->USER    WITH cUsuario,;
                               AULAS->HORA    WITH (cArq1)->HORA
                       AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
                    ENDIF
                    (cArq1)->(DBSKIP())
                 ENDDO
              ELSE
                 LOOP
              ENDIF
*              ChkReab()   /* Checar o reabastecimento dos ve¡culos */
           ENDIF
           EXIT
        ENDIF
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F3 ) /* Reativar aula Faltada */
        IF Acesso(5)
           IF Confirma("Estornar aula Faltada ?")
              IF AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                 WHILE !AULAS->(NetLReg()); ENDDO
                 REPLACE AULAS->STATUS   WITH .F.
                 AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
              ENDIF
              WHILE !ALUNO->(NetLReg()); ENDDO
              REPLACE ALUNO->PENDENTE WITH ALUNO->PENDENTE + 1
              ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())

              REPLACE (cArq1)->REALIZ WITH SPACE(4)
              oBr:Refreshall()
           ENDIF
        ENDIF
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F6 )     /* Inclusao Manual */
        /* Verificar prazo do contrato */
        IF ChkPrazo(wCod)
           SET KEY -2 TO PesqVaga()
           xCredSM := ALUNO->AULAS - (ALUNO->MARCADA+ALUNO->DESMARC)
           IF ALUNO->PENDENTE>0.OR.xCredSM>0
              IF xCredSM=0
                 Aviso("NÆo h  Novas aulas a serem marcadas...",,3); LOOP
              ENDIF
              Telas(13,22,17,65,1,YCORMENU,.T.,"InclusÆo Manual")
              SETCOLOR(YCORMENU)
              xData   := CTOD(""); xHora:=SPACE(4); wVei:=SPACE(2); wEmbarq:="E"
              xVezes  := xCredSM
              xMarcou := 0
              wLocal  := SPACE(25)
              FOR u = 1 TO xVezes
                 @ 14,35 SAY STR(u)+"§ aula"
                 @ 14,25 SAY "Ve¡culo:"  GET wVei    PICT "99"    WHEN TeclaFuncao(.T.) VALID !EMPTY(wVei).AND.Pesquisa(14,1,wVei,"Ve¡culo nao Cadastrado!")
                 @ 15,24 SAY "Embarque:" GET wEmbarq PICT "!"     WHEN TeclaFuncao().AND.HTela(3) VALID VTela(3)
                 @ 16,25 SAY "  Local:"  GET wLocal  PICT "@!S15" WHEN wEmbarq=="O"
                 @ 15,37 SAY "Data:"     GET xData   PICT "@D"    VALID LASTKEY()==K_UP.OR.!EMPTY(xData).AND.xData>=cDtSys.AND.TData(xData)
                 @ 15,54 SAY "Hora:"     GET xHora   PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.TVaga(xData,xHora,wVei,wEmbarq).AND.Conflito(wCod+DTOS(xData)+xHora)
                 SETCURSOR(1); READ; SETCURSOR(0)
                 IF LASTKEY()#K_ESC
                    VEICULO->(DBSEEK(wVei))
                    xCodInst:=VEICULO->CODINST
                    ProcOk("Incluido",.T.); lMarcou:=.T.
                    (cArq1)->(DBAPPEND())
                    REPLACE (cArq1)->DATA    WITH xData,;
                            (cArq1)->HORA    WITH xHora,;
                            (cArq1)->INSTRUT WITH xCodInst,;
                            (cArq1)->VEICULO WITH wVei,;
                            (cArq1)->NUMERO  WITH IF(ALUNO->MARCADA==0,STRZERO(u,2),STRZERO(u+ALUNO->MARCADA,2)),;
                            (cArq1)->EMBARQ  WITH wEmbarq,;
                            (cArq1)->LOCAL   WITH wLocal,;
                            (cArq1)->NOVA    WITH IF(ALUNO->AULAS-ALUNO->MARCADA==0.AND.ALUNO->AULAS>0," ","S")
                    xData++; xMarcou++

                    WHILE !ALUNO->(NetLReg()); ENDDO
                    REPLACE ALUNO->PENDENTE WITH ALUNO->PENDENTE + 1
                    ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
                 ELSE
                    IF LEN(Telas)==6; Rest_Tela(); ENDIF
                    IF Confirma("Cancela Hor rios ?",.T.)
                       xNumPend:=(cArq1)->(LASTREC())
                       (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
                       (cArq1)->(DBCOMMIT())
                       lMarcou:=.F.

                       /* Reativar as aulas pendentes */
                       WHILE !ALUNO->(NetLReg()); ENDDO
                       REPLACE ALUNO->PENDENTE WITH ALUNO->PENDENTE - xMarcou
                       ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())

                       /* Realimentar o Arquivo temp. Anterior */
                       AULAS->(DBSETORDER(1))
                       IF AULAS->(DBSEEK(wCod))
                          WHILE AULAS->MATRIC==wCod.AND.!AULAS->(EOF())
                             /* Alimentar arq. tempor rio */
                             (cArq1)->(DBAPPEND())
                             REPLACE (cArq1)->DATA    WITH AULAS->DATA,;
                                     (cArq1)->HORA    WITH AULAS->HORA,;
                                     (cArq1)->REALIZ  WITH IF(AULAS->COBRADA,"Ok",IF(AULAS->STATUS,"Falta",SPACE(5))),;
                                     (cArq1)->INSTRUT WITH AULAS->CODINST,;
                                     (cArq1)->VEICULO WITH AULAS->CODVEIC,;
                                     (cArq1)->NUMERO  WITH AULAS->NUMERO,;
                                     (cArq1)->EMBARQ  WITH AULAS->EMBARQ,;
                                     (cArq1)->USER    WITH cUsuario,;
                                     (cArq1)->LOCAL   WITH AULAS->LOCAL
                             AULAS->(DBSKIP())
                          ENDDO
                       ENDIF
                       EXIT
                    ENDIF
                    u--
                 ENDIF
              NEXT

              nPendente:=xMarcou
              nCredSM  :=nCompradas-(nMarcada+nDesmarc+xMarcou)
              nMarcada :=nMarcada+xMarcou
              DispAulas()

              /* Renumerar as aulas */
              (cArq1)->(DBGOTOP()); xNum:=1
              WHILE !(cArq1)->(EOF())
                 REPLACE (cArq1)->NUMERO WITH STRZERO(xNum++,2)
                 (cArq1)->(DBSKIP())
              ENDDO

              /* Gravar as quantidades de aulas marcadas */
              WHILE !ALUNO->(NetLReg()); ENDDO
              REPLACE ALUNO->MARCADA  WITH (cArq1)->(LASTREC())
              ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())

              SETCOLOR(YCOREDIT); Rest_Tela(); (cArq1)->(DBGOTOP())
              oBr:Refreshall()
           ELSE
              Aviso("Aulas j  marcadas...",,3)
           ENDIF
           SETKEY(K_F3,NIL)
        ENDIF
     ELSEIF ( tecla == K_F8 )     /* Novas Aulas */
        /* Verificar prazo do contrato       */
        /* Checar se foram marcadas as aulas */
        AULAS->(DBSETORDER(1))
        IF Confirma("Deseja incluir novas Aulas ?")
           SETCOLOR(YCOREDIT)
           wAulas:=0; wValor:=0.00; wDtInscr:=cDtSys; xMatric:=ALUNO->MATRIC; wMatric:=xMatric
           wValor_P1:=wValor_P2:=wValor_P3:=wValor_P4:=wValor_P5:=wValor_D:=wCarro:=wTaxa:=0.00
           wDoc1:=wDoc2:=wDoc3:=wDoc4:=wDoc5:=SPACE(10); wObs1:=SPACE(67);wServico:=SPACE(50);wNF:=SPACE(6)
           wBanco1:=wBanco2:=wBanco3:=wBanco4:=wBanco5:=SPACE(15)
           wTit1:=wTit2:=wTit3:=wTit4:=wTit5:=SPACE(25);xCodCur:=SPACE(2)
           wdia1:=cDtSys;wdia2:=wdia3:=wdia4:=wdia5:=CTOD("");wOptou:=" "; wAulasT:=0
           IF ConfPgto("Forma de Pagamento ?")
              Parcelamento()
           ELSE
              Avista()
           ENDIF

           // Gravar na lista de exames
           IF wCarro>0.00
           ENDIF
           Rest_Tela()

           nPendente  := nPendente  + wAulas
           nCompradas := nCompradas + wAulas
           nCredSM    := nCredSM    + wAulas
           DispAulas()
           Aviso("Marque agora as Novas Aulas...")
        ENDIF
     ELSEIF ( tecla == K_F9 )     /* Imprimir */
        Telas(8,8,12,16,1,YCOREDIT,.T.)
        @ 09,09 PROMPT " CARRO "
        @ 10,09 PROMPT " MOTO  "
        @ 11,09 PROMPT " AMBOS "
        MENU TO lRel
        Rest_Tela()
        IF ChkImpr()
           /* Renumerar as aulas */
           (cArq1)->(DBGOTOP()); xNum:=1
           WHILE !(cArq1)->(EOF())
              REPLACE (cArq1)->NUMERO WITH STRZERO(xNum++,2)
              (cArq1)->(DBSKIP())
           ENDDO
           (cArq1)->(DBGOTOP())

           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpProgAluno(,.T.,lRel)
           TiraMsgImp(cAviso)
           WaitMsg("Fim de ImpressÆo, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSEIF ( tecla == K_F10 )  /* Consulta Telefones */
        vTela1:=SAVESCREEN(2,0,24,79)
        SETCOLOR(YCORBARRA)
        Telas(8,18,13,62,1,YCORBARRA,.T.,"Telefones")
        @ 09,20 SAY "Residencial:" GET ALUNO->FONE_R  PICT "@R (99) 9999-9999" COLOR YCORBARRA
        @ 10,20 SAY "Comercial  :" GET ALUNO->FONE_C  PICT "@R (99) 9999-9999" COLOR YCORBARRA
        @ 11,20 SAY "Celular    :" GET ALUNO->CELULAR PICT "@R 9999-9999"      COLOR YCORBARRA
        @ 12,20 SAY "Recados    :" GET ALUNO->CONTATO                          COLOR YCORBARRA
        CLEAR GETS
        INKEY(0); SETCOLOR(YCOREDIT); Rest_tela()
        RESTSCREEN(2,0,24,79,vTela1)
     ELSEIF ( tecla == K_F11 )  /* Pesquisa */
        nReg:=AULAS->(RECNO())  /* Guardar posi‡Æo do ponteiro */
        IF lMarcou /* Se marcou as aulas pendentes */
           /* Gravar as Datas para Atualizar Dados de Pesquisa */
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
              IF RTRIM((cArq1)->REALIZ)#"Ok"
                 WHILE !AULAS->(NetApp()); ENDDO
                 REPLACE AULAS->MATRIC  WITH wCod,;
                         AULAS->CODINST WITH (cArq1)->INSTRUT,;
                         AULAS->CODVEIC WITH (cArq1)->VEICULO,;
                         AULAS->DATA    WITH (cArq1)->DATA,;
                         AULAS->HORA    WITH (cArq1)->HORA,;
                         AULAS->USER    WITH cUsuario,;
                         AULAS->COBRADA WITH .F.
              ENDIF
              (cArq1)->(DBSKIP())
           ENDDO
           AULAS->(DBCOMMIT())
        ENDIF
        AULAS->(DBSETORDER(3))
        SETCOLOR(YCORMENU)
        Telas(14,28,16,60,1,YCORMENU,.T.,"Pesquisa")
        WHILE .T.
           wPer:=cDtSys; wVei:=SPACE(2)
           @ 15,30 SAY "Data:"    GET wPer PICT "@D" WHEN TeclaFuncao() VALID !EMPTY(wPer).AND.wPer>=cDtSys.AND.TData(wPer,.F.)
           @ 15,47 SAY "Veiculo:" GET wVei PICT "99" VALID LASTKEY()==K_UP.OR.!EMPTY(wVei).AND.TeclaFuncao(.T.)
           SETCURSOR(1); READ; SETCURSOR(0)
           TeclaFuncao()
           IF LASTKEY()==K_ESC; EXIT; ENDIF

           aDat:={}; aHora:={}
           FOR n = 1 TO 2
               FOR g = 1 TO 7
                   /* Testar se ‚ feriado */
                   WHILE .T.
                     IF !FERIADO->(DBSEEK(DTOS(wPer))) //.AND.DOW(wPer)#1
                        EXIT
                     ENDIF
                     wPer++
                   ENDDO
                   AADD(aDat,SUBS(DTOC(wPer),1,5))

                   FOR y = 7 TO 18 //IF(DOW(wPer)==7,16,19)
                       /* Testar se hor rio j  est  vago*/
                       IF !AULAS->(DBSEEK(wVei+DTOS(wPer)+STRZERO(y,2)))
                          IF DOW(wPer)>1.AND.DOW(wPer)<7  /* Dias da semana */
                             IF y#13
                                AADD(aHora,STRZERO(y,2))
                             ENDIF
                          ELSE
                             IF y#12
                                AADD(aHora,STRZERO(y,2))
                             ENDIF
                          ENDIF
                       ELSE
                          IF DOW(wPer)>1.AND.DOW(wPer)<7  /* Dias da semana */
                             IF y#13
                                AADD(aHora,"**")
                             ENDIF
                          ELSE
                             IF y#12
                                AADD(aHora,"**")
                             ENDIF
                          ENDIF
                       ENDIF
                   NEXT
                   IF DOW(wPer)==7
                      AADD(aHora,"  "); AADD(aHora,"  ")
                   ENDIF
                   wPer++
               NEXT
           NEXT
           xCor:=SETCOLOR(); SETCOLOR(YCORMENU)
           Telas(5,5,19,76,1,YCORMENU,.T.,"Hor rios Vagos: "+RTRIM(TNomVeic(wVei)))
           @ 06,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 07,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
           @ 08,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 09,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 10,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 11,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 12,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
           @ 13,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 14,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
           @ 15,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 16,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 17,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 18,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
           @ 19,05 SAY "ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"
           /* Quadro 1 */
           nCol:=7
           FOR g = 1 TO 7
               @ 06,nCol SAY aDat[g]
               nCol+=9
           NEXT
           nCol:=6;nLin:=8;n:=0
           FOR i = 1 TO 7
              FOR g = 1+n TO 11*i
                  @ nLin,nCol SAY aHora[g]
                  IF (g+2)<LEN(aHora)
                     @ nLin,nCol+3 SAY aHora[g+1]
                     IF (g+3)<LEN(aHora)
                        IF !(VAL(aHora[g+2])<VAL(aHora[g+1]))
                           IF aHora[g+1]#"  ".AND.aHora[g+2]#"07"
                              @ nLin,nCol+6 SAY aHora[g+2]
                           ENDIF
                        ELSE
                           IF aHora[g+2]=="**"
                              @ nLin,nCol+6 SAY aHora[g+2]
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  nLin++; g+=2
              NEXT
              n+=11
              nCol+=9
              nLin:=8
           NEXT

           /* Quadro 2 */
           nCol:=7
           FOR g = 8 TO 14
               @ 13,nCol SAY aDat[g]
               nCol+=9
           NEXT
           nCol:=6;nLin:=15;n:=0
           FOR i = 1 TO 7
              FOR g = 78+n TO 88+n
                  @ nLin,nCol SAY aHora[g]
                  IF (g+2)<LEN(aHora)
                     @ nLin,nCol+3 SAY aHora[g+1]
                     IF (g+3)<LEN(aHora)
                        IF !(VAL(aHora[g+2])<VAL(aHora[g+1]))
                           IF aHora[g+1]#"  ".AND.aHora[g+2]#"07"
                              @ nLin,nCol+6 SAY aHora[g+2]
                           ENDIF
                        ELSE
                           IF aHora[g+2]=="**"
                              @ nLin,nCol+6 SAY aHora[g+2]
                           ENDIF
                        ENDIF
                     ENDIF
                  ENDIF
                  nLin++; g+=2
              NEXT
              IF (g-LEN(aHora))>1
                 g:=LEN(aHora)
                 @ nLin-1,nCol+3 SAY aHora[g]
              ENDIF
              n+=11
              nCol+=9
              nLin:=15
           NEXT
           INKEY(0)
           Rest_Tela()
        ENDDO
        AULAS->(DBSETORDER(1))
        IF lMarcou
           /* Desgravar datas para posterior grava‡Æo */
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
              IF RTRIM((cArq1)->REALIZ)#"Ok"
                 AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                 WHILE !AULAS->(NetLReg()); ENDDO
                 AULAS->(DBDELETE()); AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
              ENDIF
              (cArq1)->(DBSKIP())
           ENDDO
           AULAS->(DBCOMMIT())
        ENDIF
        AULAS->(DBGOTO(nReg))
        Rest_Tela()
     ELSEIF ( tecla == K_F12   )  /* Prox. Hora Livre */
*       ChkProx()
     ELSEIF ( tecla == K_DEL   )  /* ExclusÆo  */
        IF EMPTY((cArq1)->DATA)
           Aviso("NÆo h  registro a ser Exclu¡do...",,3); LOOP
        ENDIF
        IF RTRIM((cArq1)->REALIZ)#"Ok"
           IF Confirma("Confirma ExclusÆo da Aula ?")
              /* Diminuir das aulas */
              WHILE !ALUNO->(NetLReg()); ENDDO
              REPLACE ALUNO->AULAS    WITH ALUNO->AULAS - 1   ,;
                      ALUNO->PENDENTE WITH ALUNO->PENDENTE - 1,;
                      ALUNO->MARCADA  WITH ALUNO->MARCADA - 1
              ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
              lPosRec:=RECNO()

              /* Procurar na programacao */
              IF AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                 WHILE !AULAS->(NetLReg()); ENDDO
                 AULAS->(DBDELETE()); AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
              ENDIF

              (cArq1)->(DBDELETE()); (cArq1)->(__DBPACK())

              /* Renumerar as aulas */
              (cArq1)->(DBGOTOP()); xNum:=1
              WHILE !(cArq1)->(EOF())
                 REPLACE (cArq1)->NUMERO WITH STRZERO(xNum++,2)
                 (cArq1)->(DBSKIP())
              ENDDO
              oBr:Refreshall()

              nCompradas := nCompradas - 1
              nPendente  := nPendente - 1
              nMarcada   := nMarcada - 1
              DispAulas()
              (cArq1)->(DBGOTO(lPosRec))
              lMarcou:=.T.
           ENDIF
        ENDIF
     ELSEIF ( tecla == K_F12 )    /* Pesquisa Vagas */
        PesqVaga()
     ELSEIF ( tecla == K_ENTER )  /* Altera‡Æo */
        IF EMPTY((cArq1)->DATA)
           Aviso("NÆo h  registro a ser Alterado...",,3); LOOP
        ENDIF
        IF RTRIM((cArq1)->REALIZ)="Falta"
           Aviso("Registro nÆo pode ser Alterado...",,3); LOOP
        ELSEIF RTRIM((cArq1)->REALIZ)="Ok"
           Aviso("Aula j  Realizada...",,3); LOOP
        ELSE
           // Verificar se aluno possui ao menos uma aula marcada
           IF (ALUNO->AULAS - ALUNO->MARCADA) = 0
              Aviso("Altera‡Æo nÆo permitida...",,3); LOOP
           ENDIF
           xData:=xDataAnt:=(cArq1)->DATA; xHora:=xHoraAnt:=(cArq1)->HORA; wVei:=(cArq1)->VEICULO; wEmbarq:=(cArq1)->EMBARQ; wLocal:=(cArq1)->LOCAL
           wVei:=ALLTRIM(wVei)
           SETCOLOR(YCOREDIT)
           Telas(13,22,17,65,1,YCOREDIT,.T.,"Altera‡Æo")
           @ 14,25 SAY "Ve¡culo:"  GET wVei    PICT "99"    WHEN TeclaFuncao(.T.) VALID !EMPTY(wVei).AND.Pesquisa(14,1,wVei,"Ve¡culo nao Cadastrado!")
           @ 15,24 SAY "Embarque:" GET wEmbarq PICT "!"     WHEN TeclaFuncao().AND.HTela(3) VALID VTela(3)
           @ 16,25 SAY "  Local:"  GET wLocal  PICT "@!S15" WHEN wEmbarq=="O"
           @ 15,37 SAY "Data:"     GET xData   PICT "@D"    VALID LASTKEY()==K_UP.OR.!EMPTY(xData).AND.xData>=cDtSys.AND.TData(xData)
           @ 15,54 SAY "Hora:"     GET xHora   PICT "@R 99:99" VALID LASTKEY()==K_UP.OR.IF(xData#xDataAnt.OR.xHora#xHoraAnt,TVaga(xData,xHora,wVei,wEmbarq,xDataAnt,xHoraAnt),.T.)
           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              lRotAut:=.T.
              /* Alterar no Arq. Principal */
              AULAS->(DBSETORDER(3))
              IF AULAS->(DBSEEK(ALLTRIM((cArq1)->VEICULO)+DTOS((cArq1)->DATA)+(cArq1)->HORA+(cArq1)->EMBARQ))
                 WHILE !AULAS->(NetLReg()); ENDDO
                 REPLACE AULAS->CODVEIC WITH wVei,;
                         AULAS->CODINST WITH TCodInst(wVei),;
                         AULAS->EMBARQ  WITH wEmbarq,;
                         AULAS->LOCAL   WITH wLocal,;
                         AULAS->DATA    WITH xDATA,;
                         AULAS->USER    WITH cUsuario,;
                         AULAS->HORA    WITH xHORA
                 AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
              ENDIF
              AULAS->(DBSETORDER(1))

              /* Alterar no Arq. Tempor rio */
              REPLACE (cArq1)->DATA    WITH xData,;
                      (cArq1)->HORA    WITH xHora,;
                      (cArq1)->INSTRUT WITH TCodInst(wVei),;
                      (cArq1)->VEICULO WITH wVei,;
                      (cArq1)->LOCAL   WITH wLocal,;
                      (cArq1)->EMBARQ  WITH wEmbarq

              /* Renumerar aulas */
              (cArq1)->(DBGOTOP()); xNum:=1
              WHILE !(cArq1)->(EOF())
                 REPLACE (cArq1)->NUMERO WITH STRZERO(xNum++,2)
                 (cArq1)->(DBSKIP())
              ENDDO
              (cArq1)->(DBCOMMIT()); oBr:Refreshall()
           ENDIF
           IF !lRotAut.AND.LEN(Telas)==4; Rest_Tela(); ENDIF
           IF LEN(Telas)>=6
              Rest_Tela(2)
           ELSEIF LEN(Telas)==5
              Rest_Tela()
           ENDIF
        ENDIF
        (cArq1)->(DBGOTOP()); oBr:Refreshall()
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  IF ALUNO->DESMARC>0
     Aviso("Aulas a marcar/remarcar => "+STR(ALUNO->DESMARC,2),,3)
  ENDIF
  Rest_Tela(); RELEASE nSel
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar se tem conflito hora  ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION Conflito(pChave)
   LOCAL nOrder:=AULAS->(INDEXORD())
   AULAS->(DBSETORDER(1))
   IF AULAS->(DBSEEK(pChave))
      Aviso("Aluno j  possui aula neste horario!")
      DBSETORDER(nOrder)
      RETURN .F.
   ENDIF
   DBSETORDER(nOrder)
   RETURN(.T.)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar se Data nÆo ‚ feriado ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION TData(pVar,lMsg)
  DEFAULT lMsg TO .T.
*  IF DOW(pVar)==1.OR.FERIADO->(DBSEEK(DTOS(pVar)))
  IF FERIADO->(DBSEEK(DTOS(pVar)))
     Aviso("Esta data ‚ feriado...",,3)
     RETURN .F.
  ENDIF
  IF pVar==cDtSys.AND.cPrg#"AE230".AND.lMsg
     Aviso("** ATEN€ÇO ** Certifique-se do hor rio da aula...",,3)
  ENDIF
  RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar Hora V lida              ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION THora(pVar2)
  IF !(VAL(LEFT(pVar2,2))>=7.AND.VAL(LEFT(pVar2,2))<=22) //.AND.VAL(pVar2)#12.AND.VAL(pVar2)#13)
     Aviso("Hor rio Inv lido...",,3); RETURN .F.
  ENDIF
  RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar se Data e Hora est  vago ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION TVaga(pVar1,pVar2,pVar3,pVar4,pDtAnt,pHoraAnt)
  DEFAULT pDtAnt   TO pVar1
  DEFAULT pHoraAnt TO pVar2
  /* Testar hora v lida */
  IF DOW(pVar1)==7                      /* S bado */
     IF !(VAL(LEFT(pVar2,2))>=6.AND.VAL(LEFT(pVar2,2))<=21) //.AND.VAL(pVar2)#12)
        Aviso("Hor rio Inv lido...",,3); RETURN .F.
     ENDIF
  ELSEIF DOW(pVar1)>1.AND.DOW(pVar1)<7  /* Dias da semana */
     IF !(VAL(LEFT(pVar2,2))>=6.AND.VAL(LEFT(pVar2,2))<=21) //.AND.VAL(pVar2)#12.AND.VAL(pVar2)#13)
        Aviso("Hor rio Inv lido...",,3); RETURN .F.
     ENDIF
  ENDIF

  /* Verificar se hor rio j  foi informado no Arq. Tempor rio */
  nReg:=(cArq1)->(RECNO())
  (cArq1)->(DBGOTOP())
  WHILE !(cArq1)->(EOF())
     IF (cArq1)->VEICULO=pVar3.AND.(cArq1)->DATA=pVar1.AND.(cArq1)->HORA=pVar2
        Aviso("Hor rio j  Informado...",,3); (cArq1)->(DBGOTO(nReg)); RETURN .F.
     ENDIF
     (cArq1)->(DBSKIP())
  ENDDO
  (cArq1)->(DBGOTO(nReg))

  /* Nao altera data e hora da aula */
  IF lRotAut
     IF pDtAnt==pVar1.AND.pHoraAnt==pVar2; RETURN .T.; ENDIF
  ENDIF

  /* Display dos Hor rios Vagos */
  AULAS->(DBSETORDER(3))
  IF AULAS->(DBSEEK(RTRIM(pVar3)+DTOS(pVar1)+pVar2))
     IF !AULAS->STATUS // Se aula na foi faltada
        /* Apresentar tela com hor rios vagos */
        IF DOW(pVar1)>1.AND.DOW(pVar1)<7  /* Dias da semana */
           nTam:=18
        ELSE                              /* S bado */
           nTam:=18
        ENDIF
        aHora:={}; nVet:=1
        FOR y = 7 TO nTam
          IF !AULAS->(DBSEEK(RTRIM(pVar3)+DTOS(pVar1)+STRZERO(y,2)))
             IF nTam==18
                IF y#12.AND.y#13
                   AADD(aHora,STRZERO(y,2))
                ENDIF
             ELSE
                IF y#12
                   AADD(aHora,STRZERO(y,2))
                ENDIF
             ENDIF
          ENDIF
        NEXT
        IF LEN(aHora)==0
           Aviso("NÆo h  hor rio vago nesta data...",,3)
        ELSE
           xCor:=SETCOLOR(); SETCOLOR(YCORMENU)
           Telas(7,5,9+LEN(aHora),21,1,YCORMENU,.T.,"Hor rios Vagos")
           FOR p = 1 TO LEN(aHora)
              @ p+7,12 SAY aHora[p] PICT "99" COLOR YCORMENU
           NEXT
           SETCURSOR(0); INKEY(0); SETCURSOR(1)
           SETCOLOR(xCor)
           Rest_Tela()
        ENDIF
        RETURN .F.
     ENDIF
  ENDIF
  RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar se Sele‡Æo est  completa³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION TSele()
  LOCAL nTot:=0
  IF xAulas==6
     xDia1:=xDia2:=xDia3:=xDia4:=xDia5:=xDia6:="X"
     RETURN .T.
  ENDIF
  IF xDia1="X"; nTot++; ENDIF
  IF xDia2="X"; nTot++; ENDIF
  IF xDia3="X"; nTot++; ENDIF
  IF xDia4="X"; nTot++; ENDIF
  IF xDia5="X"; nTot++; ENDIF
  IF xDia6="X"; nTot++; ENDIF
  IF nTot>=nSel
     RETURN .F.
  ENDIF
  RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Programa‡Æo do Aluno³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION ImpProgAluno(pVia,pRot,pRel)
  DEFAULT pVia TO "1"
  DEFAULT pRot TO .F.
  DEFAULT pRel TO 3
  Gera_TXT("PRGALU.TXT"); SETPRC(0,0)
  @ PROW()  ,10 SAY cRazao+" "+cEnder3+" Ramal: 5 (Aula Pratica)"
  @ PROW()+1,05 SAY PADC("***** PROGRAMACAO DE AULAS PRATICAS *****",80)
  @ PROW() ,110 SAY "Usuario: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
  @ PROW()+1,05 SAY REPLICATE("-",128)
  Compr_On()
  @ PROW()+1,05 SAY "Aluno.: "+ALUNO->NOME
  @ PROW()  ,90 SAY "Matricula: "+ALUNO->MATRIC
  @ PROW()+1,05 SAY "CPF/MF: "
  @ PROW()  ,13 SAY ALUNO->CPF PICT "@R 999.999.999-99"
  @ PROW()  ,40 SAY "RG: "+ALUNO->RG
  @ PROW()  ,90 SAY "Doc.(via): "+pVia+"¦"+" emitida em: "+DTOC(DATE())
  @ PROW()+1,05 SAY "Curso: Inicio: ____/_____/_______   Termino: ____/_____/_______"
  @ PROW()  ,90 SAY "Categoria: "+ALUNO->CATEG
  @ PROW()+1,05 SAY REPLICATE("-",128)
  @ PROW()+1,05 SAY "AULA DATA      INIC. FINAL CONTEUDO   instrutor/veiculo/embarque                        ASSINATURA DO ALUNO   ASSINAT. INSTRUTOR"
*                    99a  99/99/99  99:99 99:99 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx ____________________ ___________________
*                                               XXXXXXXXXXxxxxx xxxxxxxxxxXXXXXXXXXX xxxxxxxxxx
*                    56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                         1         2         3         4         5         6         7         8         9        10        11        12        13
  @ PROW()+1,05 SAY REPLICATE("-",128)
  (cArq1)->(DBGOTOP())
  vMarca:=TNomVeic((cArq1)->VEICULO)
  IF SUBS(vMarca,1,4)=="MOTO"
     vCateg:="A"
  ELSE
     vCateg:="B"
  ENDIF
  WHILE !(cArq1)->(EOF())
     IF pRot
        IF RTRIM((cArq1)->REALIZ)#"Ok".AND.RTRIM((cArq1)->REALIZ)#"Falta".OR.(cArq1)->NOVA=="S"
           vMarca:=TNomVeic((cArq1)->VEICULO)
           IF (pRel=1.and.SUBS(vMarca,1,4)=="MOTO").OR.(pRel=2.and.SUBS(vMarca,1,4)#"MOTO")
              (cArq1)->(DBSKIP())
              LOOP
           ENDIF
           IF CP->(DBSEEK((cArq1)->NUMERO+vCateg))
              vCP := CP->CP
           ELSE
              vCp := "REFORCO"
           ENDIF
           @ PROW()+1,05 SAY (cArq1)->NUMERO
           @ PROW()  ,10 SAY SUBS(DTOC((cArq1)->DATA),1,6)+SUBS(DTOC((cArq1)->DATA),9,2) PICT "@D"
           @ PROW()  ,20 SAY (cArq1)->HORA PICT "@R 99:99"
           @ PROW()  ,26 SAY CalcHora((cArq1)->HORA)
           @ PROW()  ,32 SAY vCP PICT "@S60"
           @ PROW()  ,93 SAY REPLICATE("_",20)
           @ PROW() ,114 SAY REPLICATE("_",19)
           @ PROW()+1,32 SAY SUBS(TNomInst(RTRIM((cArq1)->INSTRUT)),1,AT(" ",TNomInst(RTRIM((cArq1)->INSTRUT)))-1) PICT "@S15"
           @ PROW()  ,48 SAY TNomVeic((cArq1)->VEICULO) PICT "@S20"
           @ PROW()  ,69 SAY IF((cArq1)->EMBARQ=="E","ESCOLA",IF((cArq1)->EMBARQ=="O",(cArq1)->LOCAL,IF((cArq1)->EMBARQ=="P","PCA PITUBA","RESIDENCIA"))) PICT "@S11"
*          @ PROW()+1,00 SAY " "
        ENDIF
     ELSE
        vMarca:=TNomVeic((cArq1)->VEICULO)
        IF (pRel=1.and.SUBS(vMarca,1,4)=="MOTO").OR.(pRel=2.and.SUBS(vMarca,1,4)#"MOTO")
           (cArq1)->(DBSKIP())
           LOOP
        ENDIF

        IF CP->(DBSEEK((cArq1)->NUMERO))
           vCP := CP->CP
        ELSE
           vCp := "REFORCO"
        ENDIF
        @ PROW()+1,05 SAY (cArq1)->NUMERO
        @ PROW()  ,10 SAY SUBS(DTOC((cArq1)->DATA),1,6)+SUBS(DTOC((cArq1)->DATA),9,2) PICT "@D"
        @ PROW()  ,20 SAY (cArq1)->HORA PICT "@R 99:99"
        @ PROW()  ,26 SAY CalcHora((cArq1)->HORA)
        @ PROW()  ,32 SAY vCP PICT "@S60"
        IF RTRIM((cArq1)->REALIZ)=="Ok"
*          @ PROW()  ,88 SAY "REALIZADA"
           @ PROW()  ,87 SAY REPLICATE("Ä",20)
        ELSEIF RTRIM((cArq1)->REALIZ)=="Falta"
           @ PROW()  ,88 SAY "FALTA"
        ELSE
           @ PROW()  ,87 SAY REPLICATE("_",20)
        ENDIF
        @ PROW() ,108 SAY REPLICATE("_",25)
        @ PROW()+1,32 SAY SUBS(TNomInst(RTRIM((cArq1)->INSTRUT)),1,AT(" ",TNomInst(RTRIM((cArq1)->INSTRUT)))-1) PICT "@S15"
        @ PROW()  ,48 SAY TNomVeic((cArq1)->VEICULO) PICT "@S20"
        @ PROW()  ,69 SAY IF((cArq1)->EMBARQ=="E","ESCOLA",IF((cArq1)->EMBARQ=="O",(cArq1)->LOCAL,IF((cArq1)->EMBARQ=="P","PCA PITUBA","RESIDENCIA"))) PICT "@S11"
     ENDIF
     IF PROW()>=56.AND.!(cArq1)->(EOF())
        EJECT
        @ PROW()  ,10 SAY cRazao
*       @ PROW()+1,05 SAY cEnder1+cEnder2
*       @ PROW()+1,05 SAY cEnder3
        @ PROW()+1,110 SAY "Usuario: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
*       @ PROW()+1,05 SAY REPLICATE("-",128)
        @ PROW()+1,05 SAY PADC("***** PROGRAMACAO DE AULAS PRATICAS *****",128)
        @ PROW()+1,05 SAY REPLICATE("-",128)
        @ PROW()+1,05 SAY "Aluno.: "+ALUNO->NOME
        @ PROW()  ,90 SAY "Matricula: "+ALUNO->MATRIC
        @ PROW()+1,05 SAY "CPF/MF: "
        @ PROW()  ,13 SAY ALUNO->CPF PICT "@R 999.999.999-99"
        @ PROW()  ,40 SAY "RG: "+ALUNO->RG
        @ PROW()  ,90 SAY "Doc.(via): "+pVia+"a."
        @ PROW()+1,05 SAY REPLICATE("-",128)
        @ PROW()+1,05 SAY "AULA DATA      INIC. FINAL CONTEUDO   instrutor/veiculo/embarque                        ASSINATURA DO ALUNO   ASSINAT. INSTRUTOR"
        @ PROW()+1,05 SAY REPLICATE("-",128)
     ENDIF
     (cArq1)->(DBSKIP())
  ENDDO

  @ PROW()+1,05 SAY REPLICATE("-",128)
  @ PROW()+1,40 SAY "***** REPOSICAO OU ANTECIPACAO DE AULA *****"
* @ PROW()+2,05 SAY "AULA   DATA    INIC. FINAL INSTRUTOR        VEICULO              LOCAL        ASSINATURA DO ALUNO   ASSINATURA INSTRUTOR"
*                    99a  99/99/99  99:99 99:99 XXXXXXXXXXxxxxx  xxxxxxxxxxXXXXXXXXXX xxxxxxxxxx   ____________________  ____________________
*                    56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                         1         2         3         4         5         6         7         8         9        10        11        12        13
* @ PROW()+1,05 SAY REPLICATE("-",128)
  FOR i = 1 TO 4
     @ PROW()+1,05 SAY STRZERO(i,1)+"a ____/____/____  ___:___  ___:___ *************   ***************   ____________________  ____________________"
  NEXT
  @ PROW()+1,05 SAY REPLICATE("-",128)
* @ PROW()+1,05 SAY PADC(RTRIM(DBPARM->MSG),130)

  Compr_On()
  @ PROW()+1,05 SAY "ATENCAO - Marcacao/Remarcacao de aula ou exame pratico so sera feita atraves de AGENDAMENTO DE HORARIO e PESSOALMENTE. A marca-"
  @ PROW()+1,05 SAY "          cao do exame pratico devera ser feita portando o RG, CPF, ficha com ao menos 15 aulas praticas assinadas pelo instru-"
  @ PROW()+1,05 SAY "          tor com a observacao de apto para exame e a TAXA DO CARRO."
  @ PROW()+1,05 SAY "        - Desmarcacao de aula PRATICA da segunda somente ate as 12 h do s bado e os demais dias com 24h de antecedencia (at‚ …s"
  @ PROW()+1,05 SAY "          17 h). A nao observancia desta, implicara na cobranca de reposi‡ao de aula."
  @ PROW()+1,05 SAY "        - TRAJES PARA TREINAMENTO, SOMENTE CONFORME CONTRATO, portando RG original, LADV ou CNH e ficha de frequencia pratica."
  @ PROW()+1,05 SAY "        - Duracao hora-aula pratica 50 min. dia e 45 min. noite    +----------------------------------------------------------+"
  @ PROW()+1,05 SAY "        - Aula pratica so sera realizada com RG e LADV original.   | ( ) PERMANECER EM TREINAMENTO ATE A DATA DO EXAME        |"
  @ PROW()+1,05 SAY "        - Solicitar Certificado apos conclusao do curso pratico.   |     3( )  4( )  6(  )  8(  )  AULAS para EXAME           |"
  @ PROW()+1,05 SAY "        - ATRASO SUPERIOR A 15 MIN. CONFIGURARA A PERDA DA AULA.   | ( ) INAPTO                                               |"
  @ PROW()+1,05 SAY "                                                                   |     8( )  10(  )  15(  )  20(  )  30(  ) AULAS           |"
  @ PROW()+1,05 SAY REPLICATE("-",128)
  @ PROW()+2,05 SAY "       Assinatura do Aluno                       Assinatura do Diretor de Ensino"
  Compr_Off()
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp PRGALU.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE PRGALU.TXT
  RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar se h  vaga no hor rio    ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION TVagaAut(pVar1,pVar2,pAut)
  LOCAL cOrdemAnt:=AULAS->(INDEXORD())
  DEFAULT pAut TO .F.
  /* Testar hora v lida */
  IF FERIADO->(DBSEEK(DTOS(pVar1)))    /* Feriado */
     RETURN .F.
  ENDIF
  IF DOW(pVar1)==1                     /* Domingo */
     RETURN .T.
  ELSEIF DOW(pVar1)==7                 /* S bado */
     IF !(VAL(LEFT(pVar2,2))>=7.AND.VAL(LEFT(pVar2,2))<=20)  //.AND.VAL(pVar2)#12)
        RETURN .F.
     ENDIF
  ELSEIF DOW(pVar1)>1.AND.DOW(pVar1)<7  /* Dias da semana */
     IF !(VAL(LEFT(pVar2,2))>=7.AND.VAL(LEFT(pVar2,2))<=20)  //.AND.VAL(pVar2)#12.AND.VAL(pVar2)#13)
        RETURN .F.
     ENDIF
  ENDIF
  /* Checar Hor rios Vagos */
  AULAS->(DBSETORDER(3))
  IF AULAS->(DBSEEK(RTRIM(wVei)+DTOS(pVar1)+pVar2))
     IF !pAut; Aviso("Hor rio j  est  ocupado...",,3); ENDIF
     AULAS->(DBSETORDER(cOrdemAnt));RETURN .F.
  ENDIF
  AULAS->(DBSETORDER(cOrdemAnt));RETURN .T.
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Funcao Pesquisa de Horarios     ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION PesqVaga()
  LOCAL pVei:=SPACE(2);pData:=cDtSys
  GetList:={}
  nReg:=AULAS->(RECNO())  /* Guardar posi‡Æo do ponteiro */
  AULAS->(DBSETORDER(3))
  SETCOLOR(YCORMENU)
  Telas(14,28,16,58,1,YCORMENU,.T.,"Pesquisa")
  @ 15,30 SAY "Data:"    GET pData PICT "@D" VALID !EMPTY(pData).AND.pData>=cDtSys.AND.TData(pData,.F.)
  @ 15,46 SAY "Veiculo:" GET pVei  PICT "99" VALID LASTKEY()==K_UP.OR.!EMPTY(pVei).AND.TeclaFuncao(.T.)
  SETCURSOR(1); READ; SETCURSOR(0)

  aDat:={}; aHora:={}
  FOR n = 1 TO 2
      FOR g = 1 TO 7
          /* Testar se ‚ feriado */
          WHILE .T.
            IF !FERIADO->(DBSEEK(DTOS(pData))).AND.DOW(pData)#1
               EXIT
            ENDIF
            pData++
          ENDDO
          AADD(aDat,SUBS(DTOC(pData),1,5))

          FOR y = 7 TO 20 //IF(DOW(pData)==7,16,19)
              /* Testar se hor rio j  est  vago*/
              IF !AULAS->(DBSEEK(pVei+DTOS(pData)+STRZERO(y,2)))
                 IF DOW(pData)>1.AND.DOW(pData)<7  /* Dias da semana */
                    IF y#12.AND.y#13
                       AADD(aHora,STRZERO(y,2))
                    ENDIF
                 ELSE
                    IF y#12
                       AADD(aHora,STRZERO(y,2))
                    ENDIF
                 ENDIF
              ELSE
                 IF DOW(pData)>1.AND.DOW(pData)<7  /* Dias da semana */
                    IF y#12.AND.y#13
                       AADD(aHora,"**")
                    ENDIF
                 ELSE
                    IF y#12
                       AADD(aHora,"**")
                    ENDIF
                 ENDIF
              ENDIF
          NEXT
          IF DOW(pData)==7
             AADD(aHora,"  "); AADD(aHora,"  ")
          ENDIF
          pData++
      NEXT
  NEXT
  xCor:=SETCOLOR(); SETCOLOR(YCORMENU)
  Telas(5,5,19,76,1,YCORMENU,.T.,"Hor rios Vagos: "+RTRIM(TNomVeic(pVei)))
  @ 06,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 07,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
  @ 08,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 09,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 10,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 11,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 12,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
  @ 13,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 14,05 SAY "ÃÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄ´"
  @ 15,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 16,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 17,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 18,05 SAY "³        ³        ³        ³        ³        ³        ³        ³"
  @ 19,05 SAY "ÀÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÙ"
  /* Quadro 1 */
  nCol:=7
  FOR g = 1 TO 7
      @ 06,nCol SAY aDat[g]
      nCol+=9
  NEXT
  nCol:=6;nLin:=8;n:=0
  FOR i = 1 TO 7
     FOR g = 1+n TO 11*i
         @ nLin,nCol   SAY aHora[g]
         IF (g+2)<LEN(aHora)
            @ nLin,nCol+3 SAY aHora[g+1]
            IF (g+3)<LEN(aHora)
               IF !(VAL(aHora[g+2])<VAL(aHora[g+1]))
                  IF aHora[g+1]#"  ".AND.aHora[g+2]#"07"
                     @ nLin,nCol+6 SAY aHora[g+2]
                  ENDIF
               ELSE
                  IF aHora[g+2]=="**"
                     @ nLin,nCol+6 SAY aHora[g+2]
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         nLin++; g+=2
     NEXT
     n+=11
     nCol+=9
     nLin:=8
  NEXT

  /* Quadro 2 */
  nCol:=7
  FOR g = 8 TO 14
      @ 13,nCol SAY aDat[g]
      nCol+=9
  NEXT
  nCol:=6;nLin:=15;n:=0
  FOR i = 1 TO 7
     FOR g = 78+n TO 88+n
         @ nLin,nCol   SAY aHora[g]
         IF (g+2)<LEN(aHora)
            @ nLin,nCol+3 SAY aHora[g+1]
            IF (g+3)<LEN(aHora)
               IF !(VAL(aHora[g+2])<VAL(aHora[g+1]))
                  IF aHora[g+1]#"  ".AND.aHora[g+2]#"07"
                     @ nLin,nCol+6 SAY aHora[g+2]
                  ENDIF
               ELSE
                  IF aHora[g+2]=="**"
                     @ nLin,nCol+6 SAY aHora[g+2]
                  ENDIF
               ENDIF
            ENDIF
         ENDIF
         nLin++; g+=2
     NEXT
     IF (g-LEN(aHora))>1
        g:=LEN(aHora)
        @ nLin-1,nCol+3 SAY aHora[g]
     ENDIF
     n+=11
     nCol+=9
     nLin:=15
  NEXT
  INKEY(0)
  Rest_Tela()
  AULAS->(DBSETORDER(1))
  AULAS->(DBGOTO(nReg))
  Rest_Tela()
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Checar qual Data e Hora mais proxima p/ aula ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION ChkProx()
   LOCAL aVeic:={}
   LOCAL cOrdAnt:=AULAS->(INDEXORD())
   Aguarde("Localizando Horarios...")
   AULAS->(DBSETORDER(3))
   VEICULO->(DBGOTOP())
   WHILE !VEICULO->(EOF())
      pMarca:=RTRIM(VEICULO->MARCA)
      AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(cDtSys),.T.))
      IF AULAS->(EOF())
         AADD(aVeic,{cDtSys,pMarca,"07"})
      ELSE
         i:=7
         WHILE .T.
           pHora:=STRZERO(i,2)
           AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(cDtSys)+pHora))
           i++
         ENDDO
      ENDIF
      VEICULO->(DBSKIP())
   ENDDO
   Aguarde()

   VEICULO->(DBGOTOP())
   WHILE !VEICULO->(EOF())
      AADD(aVeic,VEICULO->MARCA)
      DBSKIP()
   ENDDO
   IF LEN(aVeic)>0
      Telas(6,8,7+LEN(aVeic),48,1,YCOREDIT,.T.,"Pr¢ximo Hor rio Livre")
      FOR g = 1 TO LEN(aVeic)
        @ 6+g,10 SAY aVeic[g] COLOR YCOREDIT
      NEXT
      Rest_Tela()
   ENDIF
   AULAS->(DBSETORDER(cOrdAnt))
   RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Informar quantidades de aulas  ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE DispAulas()
  SETCOLOR(YCOREDIT)
  @ 19,05 SAY "TOTAL    => "+STR(nCompradas,3)
  @ 20,05 SAY "MARCADAS => "+STR(nMarcada,3)
  @ 19,22 SAY "A TREINAR   => "+STR(nPendente,3)
  @ 20,22 SAY "DESMARCADAS => "+STR(nDesmarc,3)
  @ 20,41 SAY "CRED.S/MARC.=> "+STR(nCredSM,3)
  @ 19,60 SAY "DADAS  => "+STR(nTotalAu,3)
  @ 20,60 SAY "FALTAS => "+STR(nFaltas,3)
  RETURN
