*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_212                           vrs 001 ≥
*≥ VRS 001        : Implantacao                              ≥
*≥ FINALIDADE     : Registrar Marcaá∆o de Aulas              ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ≥
*≥ DATA CRIACAO   : 11/07/2002                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"DTAULA" ,"D", 08,0})    /* Cod. Instrutor      */
AADD(aDbf,{"CODINST","C", 04,0})    /* Cod. Instrutor      */
AADD(aDbf,{"CODVEIC","C", 02,0})    /* Cod. Veiculo        */
AADD(aDbf,{"HORA07" ,"C", 01,0})    /* 07 horas            */
AADD(aDbf,{"HORA08" ,"C", 01,0})    /* 08 horas            */
AADD(aDbf,{"HORA09" ,"C", 01,0})    /* 09 horas            */
AADD(aDbf,{"HORA10" ,"C", 01,0})    /* 10 horas            */
AADD(aDbf,{"HORA11" ,"C", 01,0})    /* 11 horas            */
AADD(aDbf,{"HORA12" ,"C", 01,0})    /* 12 horas            */
AADD(aDbf,{"HORA13" ,"C", 01,0})    /* 13 horas            */
AADD(aDbf,{"HORA14" ,"C", 01,0})    /* 14 horas            */
AADD(aDbf,{"HORA15" ,"C", 01,0})    /* 15 horas            */
AADD(aDbf,{"HORA16" ,"C", 01,0})    /* 16 horas            */
AADD(aDbf,{"HORA17" ,"C", 01,0})    /* 17 horas            */
AADD(aDbf,{"HORA18" ,"C", 01,0})    /* 18 horas            */
AADD(aDbf,{"HORA19" ,"C", 01,0})    /* 19 horas            */
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
INDEX ON DTOS(dtaula) TO (cArq1)

SELECT 5
IF NetUse("DBFERI","FERIADO")      /* Cadastro de Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 14
IF NetUse("DBVEIC","VEICULO")      /* Cadastro de Ve°culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF
IF VEICULO->(EOF())
   Aviso("Vocà precisa definir cadastrando os ve°culos primeiro",,3)
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")        /* Arquivo de Programaá∆o de Aulas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")    /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE212"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "12"
SET KEY -1 TO Mostra(); xDias:=30; xData:=wData:=cDtSys
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(3,2,5,76,1,YCOREDIT,.T.,"Marcaá∆o de Aulas Pr†ticas")
   @ 04,04 SAY "Dias a visualizar:" GET xDias PICT "999" VALID !EMPTY(xDias)
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   // Localizar programacao para o dia atual
   Aguarde("Pesquisando...")
   AULAS->(DBSETORDER(4))
   AULAS->(DBSEEK(DTOS(xData)))
   nCont:=0
   WHILE wData<(xData+xDias).AND.!AULAS->(EOF())
      // Verificar se data e feriado
      IF !FERIADO->(DBSEEK(SUBS(DTOC(wData),4,2)+SUBS(DTOC(wData),4,2))).AND.DOW(wData)#1
         INSTRUTOR->(DBGOTOP())
         WHILE !INSTRUTOR->(EOF())
            // Checar se instrutor esta ativo
            IF INSTRUTOR->STATUS
               VEICULO->(DBSETORDER(2))
               VEICULO->(DBSEEK(INSTRUTOR->CODINST))
               /* Alimentar arq. tempor†rio */
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->DTAULA  WITH wData              ,;
                       (cArq1)->CODINST WITH INSTRUTOR->CODINST ,;
                       (cArq1)->CODVEIC WITH VEICULO->CODVEIC
               nReg:=AULAS->(RECNO())
               FOR i = 7 TO 19
                  zHora:=STRZERO(i,2)
                  IF !AULAS->(DBSEEK(DTOS(wData)+zHora+INSTRUTOR->CODINST))
                     REPLACE (cArq1)->HORA&zHora. WITH "v"
                  ENDIF
               NEXT
               AULAS->(DBGOTO(nReg))
            ENDIF
            INSTRUTOR->(DBSKIP())
         ENDDO
      ENDIF
      AULAS->(DBSKIP())
      wData++
      nCont++
   ENDDO
   Aguarde()
   Marcacao(); LinhaMsg(2)
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela(LEN(telas)-3)
ENDDO
SETKEY(K_F2,NIL); Rest_Tela(LEN(telas)-3)
DelDbfNtx(); RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Programaá∆o das Datas          ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION Marcacao()
  PUBLIC nSel
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(5,2,19,76,1,YCOREDIT,.T.," Quadro de Marcaá∆o "); LinhaMsg(8)
  Telas(19,2,21,76,1,YCOREDIT,.T.)

  @ 20,05 SAY "Hor†rios Selecionados: "
  @ 20,43 SAY "Hor†rios Dispon°veis: "
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(6,3,18,75)
  oBr:headSep:="ƒ¬ƒ"
  oBr:colSep:= " ≥ "

  oCol:=TBCOLUMNNEW("DTAULA"    ,{|| DTAULA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Veiculo"   ,{|| TRANSFORM(TNomVeic(CODVEIC,.T.),"@S10")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Instrutor" ,{|| SUBS(PegaInst(CODINST),1,AT(" ",PegaInst(CODINST))-1)+SPACE(5)})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("07"        ,{|| HORA07})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("08"        ,{|| HORA08})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("09"        ,{|| HORA09})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("10"        ,{|| HORA10})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("11"        ,{|| HORA11})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("12"        ,{|| HORA12})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("13"        ,{|| HORA13})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("14"        ,{|| HORA14})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("15"        ,{|| HORA15})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("16"        ,{|| HORA16})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("17"        ,{|| HORA17})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("18"        ,{|| HORA18})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("19"        ,{|| HORA19})
  oBr:addColumn(oCol)

  oBr:Freeze=1
  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     lRotAut:=.F.
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F3 ) /* Reativar aula Faltada */
        IF Acesso(5)
           IF Confirma("Estornar aula Faltada ?")
              IF AULAS->(DBSEEK(wCod+DTOS((cArq1)->DATA)+(cArq1)->HORA))
                 WHILE !AULAS->(NetLReg()); ENDDO
                 REPLACE AULAS->STATUS WITH .F.
                 AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
              ENDIF
              REPLACE (cArq1)->REALIZ WITH SPACE(4)
              oBr:Refreshall()
           ENDIF
        ENDIF
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F12   )  /* Prox. Hora Livre */
        ChkProx()
     ELSEIF ( tecla == K_DEL   )  /* Exclus∆o  */
        IF EMPTY((cArq1)->DATA)
           Aviso("N∆o h† registro a ser Exclu°do...",,3); LOOP
        ENDIF
        IF RTRIM((cArq1)->REALIZ)#"Ok"
           IF Confirma("Confirma Exclus∆o da Aula ?")
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
              (cArq1)->(DBGOTO(lPosRec))
              lMarcou:=.T.
           ENDIF
        ENDIF
     ELSEIF ( tecla == K_ENTER )  /* Alteraá∆o */
        IF EMPTY((cArq1)->DATA)
           Aviso("N∆o h† registro a ser Alterado...",,3); LOOP
        ENDIF
        IF RTRIM((cArq1)->REALIZ)="Falta"
           Aviso("Registro n∆o pode ser Alterado...",,3); LOOP
        ELSEIF RTRIM((cArq1)->REALIZ)="Ok"
           Aviso("Aula j† Realizada...",,3); LOOP
        ELSE
           xData:=xDataAnt:=(cArq1)->DATA; xHora:=xHoraAnt:=(cArq1)->HORA; wVei:=(cArq1)->VEICULO; wEmbarq:=(cArq1)->EMBARQ; wLocal:=(cArq1)->LOCAL
           SETCOLOR(YCOREDIT)
           Telas(13,22,17,63,1,YCOREDIT,.T.,"Alteraá∆o")
           @ 14,25 SAY "Ve°culo:"  GET wVei    PICT "99"    WHEN TeclaFuncao(.T.) VALID !EMPTY(wVei).AND.Pesquisa(14,1,wVei,"Ve°culo nao Cadastrado!")
           @ 15,24 SAY "Embarque:" GET wEmbarq PICT "!"     WHEN TeclaFuncao().AND.HTela(3) VALID VTela(3)
           @ 16,25 SAY "  Local:"  GET wLocal  PICT "@!S15" WHEN wEmbarq=="O"
           @ 15,37 SAY "Data:"     GET xData   PICT "@D"    VALID LASTKEY()==K_UP.OR.!EMPTY(xData).AND.xData>=cDtSys.AND.TData(xData)
           @ 15,54 SAY "Hora:"     GET xHora   PICT "99"    VALID LASTKEY()==K_UP.OR.IF(xData#xDataAnt.OR.xHora#xHoraAnt,TVaga(xData,xHora,wVei,wEmbarq,xDataAnt,xHoraAnt),.T.)
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

              /* Alterar no Arq. Tempor†rio */
              REPLACE (cArq1)->DATA    WITH xData,;
                      (cArq1)->HORA    WITH STRZERO(VAL(xHora),2),;
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
  Rest_Tela()
  RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Programaá∆o do Aluno≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION ImpProgAluno(pVia,pRot)
  DEFAULT pVia TO "1"
  DEFAULT pRot TO .F.
  Gera_TXT("MARCAULA.TXT"); SETPRC(0,0)
  @ PROW()  ,00 SAY cRazao
  @ PROW()+1,00 SAY cEnder1+cEnder2
  @ PROW()+1,00 SAY cEnder3
  @ PROW()+1,00 SAY REPLICATE("-",80)
  @ PROW()+1,00 SAY PADC("** PROGRAMACAO DE AULAS **",80)
  @ PROW()+1,00 SAY REPLICATE("-",80)
  @ PROW()+1,00 SAY "     Data: "+DTOC(cDtSys)
  @ PROW()  ,27 SAY "Hora: "+TIME()
  @ PROW()  ,45 SAY "CPF: "+ALUNO->CPF
  @ PROW()  ,65 SAY "RG: "+ALUNO->RG
  @ PROW()+1,00 SAY " Operador: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
  @ PROW()  ,64 SAY "      VIA: "+pVia+"¶"
  @ PROW()+1,00 SAY "    Aluno: "+ALUNO->NOME
  @ PROW()  ,64 SAY "Matricula: "+ALUNO->MATRIC
  @ PROW()+1,00 SAY REPLICATE("-",80)
  @ PROW()+1,00 SAY "DATA     HORA  INSTRUTOR  VEICULO                       LOCAL       VISTO INSTR."
  @ PROW()+1,00 SAY REPLICATE("-",80)
  (cArq1)->(DBGOTOP())
  WHILE !(cArq1)->(EOF())
     IF pRot
        IF RTRIM((cArq1)->REALIZ)#"Ok".AND.RTRIM((cArq1)->REALIZ)#"Falta".OR.(cArq1)->NOVA=="S"
            @ PROW()+1,00 SAY SUBS(DTOC((cArq1)->DATA),1,6)+SUBS(DTOC((cArq1)->DATA),9,2) PICT "@D"
            @ PROW()  ,09 SAY (cArq1)->HORA+":00"
            @ PROW()  ,15 SAY SUBS(TNomInst(RTRIM((cArq1)->INSTRUT)),1,AT(" ",TNomInst(RTRIM((cArq1)->INSTRUT)))-1) PICT "@S10"
            @ PROW()  ,26 SAY TNomVeic((cArq1)->VEICULO) PICT "@S30"
            @ PROW()  ,56 SAY IF((cArq1)->EMBARQ=="E","ESCOLA",IF((cArq1)->EMBARQ=="O",(cArq1)->LOCAL,IF((cArq1)->EMBARQ=="P","PCA.NS LUZ","RESIDENCIA"))) PICT "@S11"
            @ PROW()  ,68 SAY REPLICATE("-",11)
            @ PROW()+1,00 SAY " "
        ENDIF
     ELSE
        @ PROW()+1,00 SAY SUBS(DTOC((cArq1)->DATA),1,6)+SUBS(DTOC((cArq1)->DATA),9,2) PICT "@D"
        @ PROW()  ,09 SAY (cArq1)->HORA+":00"
        @ PROW()  ,15 SAY SUBS(TNomInst(RTRIM((cArq1)->INSTRUT)),1,AT(" ",TNomInst(RTRIM((cArq1)->INSTRUT)))-1) PICT "@S10"
        @ PROW()  ,26 SAY TNomVeic((cArq1)->VEICULO) PICT "@S30"
        @ PROW()  ,56 SAY IF((cArq1)->EMBARQ=="E","ESCOLA",IF((cArq1)->EMBARQ=="O",(cArq1)->LOCAL,IF((cArq1)->EMBARQ=="P","PCA.NS LUZ","RESIDENCIA"))) PICT "@S11"
        IF RTRIM((cArq1)->REALIZ)=="Ok"
           @ PROW()  ,68 SAY "REALIZADA"
        ELSEIF RTRIM((cArq1)->REALIZ)=="Falta"
           @ PROW()  ,68 SAY "FALTA"
        ELSE
           @ PROW()  ,68 SAY REPLICATE("-",11)
        ENDIF
        @ PROW()+1,00 SAY " "
     ENDIF
     IF PROW()>=56.AND.!(cArq1)->(EOF())
        EJECT
        @ PROW()  ,00 SAY cRazao
        @ PROW()+1,00 SAY cEnder1+cEnder2
        @ PROW()+1,00 SAY cEnder3
        @ PROW()+1,00 SAY REPLICATE("-",80)
        @ PROW()+1,00 SAY PADC("** PROGRAMACAO DE AULAS **",80)
        @ PROW()+1,00 SAY REPLICATE("-",80)
        @ PROW()+1,00 SAY "     Data: "+DTOC(cDtSys)
        @ PROW()  ,27 SAY "Hora: "+TIME()
        @ PROW()  ,45 SAY "CPF: "+ALUNO->CPF
        @ PROW()  ,65 SAY "RG: "+ALUNO->RG
        @ PROW()+1,00 SAY " Operador: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
        @ PROW()  ,64 SAY "      VIA: "+pVia+"¶"
        @ PROW()+1,00 SAY "    Aluno: "+ALUNO->NOME
        @ PROW()  ,64 SAY "Matricula: "+ALUNO->MATRIC
        @ PROW()+1,00 SAY REPLICATE("-",80)
        @ PROW()+1,00 SAY "DATA     HORA  INSTRUTOR  VEICULO                       LOCAL       VISTO INSTR."
        @ PROW()+1,00 SAY REPLICATE("-",80)
     ENDIF
     (cArq1)->(DBSKIP())
  ENDDO
  @ PROW()+1,00 SAY REPLICATE("-",78)
  @ PROW()+1,00 SAY PADC(RTRIM(DBPARM->MSG),80)
  @ PROW()+1,00 SAY REPLICATE("-",78)
  @ PROW()+1,05 SAY "ATENÄAO    - Em caso de desistància ser† cobrada  uma taxa equivalente a"
  @ PROW()+1,05 SAY "             30% (trinta por cento) sobre o valor total do curso."
  @ PROW()+1,05 SAY "           - Desmarcaá∆o de aulas somente com 24 h de antecedància nos"
  @ PROW()+1,05 SAY "             dias £teis. A n∆o observÉncia desta implicar† na cobranáa"
  @ PROW()+1,05 SAY "             de reposiá∆o da aula."
  @ PROW()+2,05 SAY "OBSERVAÄAO - A duraá∆o total Ç de 50 minutos."
  @ PROW()+1,05 SAY "           - S¢ Ç permitido o treinamento com uso de sapato ou tànis."
  @ PROW()+1,05 SAY "           - Remarcaá∆o de aulas somente no escrit¢rio e com apresenta-"
  @ PROW()+1,05 SAY "             á∆o da programaá∆o."
  @ PROW()+1,05 SAY "           - Nenhum exame ou aula podera ser marcado por telefone."
  @ PROW()+1,05 SAY "           - Cobramos taxa administrativa para emiss∆o de 2¶ Via."
  @ PROW()+1,05 SAY "           - Solicitar Certificado ap¢s conclus∆o do curso pr†tico."
  @ PROW()+1,05 SAY "           - Desmarcar aulas para Segunda somente ate 12:00h do S†bado."
  @ PROW()+1,05 SAY " "
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp marcaula.txt 80 pre
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE MARCAULA.TXT
  RETURN NIL
