*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏f
*≥ PROGRAMA       : AE_110                           vrs 001 ≥
*≥ VRS 001        : Implantacao                              ≥
*≥ FINALIDADE     : Matricula de Alunos                      ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ≥
*≥ DATA CRIACAO   : 06/01/1996                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"
#include "COMMAND.CH"

PROCEDURE AE_110(wOp)
DBCLOSEALL()

SELECT 14
IF NetUse("DBVEIC","VEICULO")         /* Ve°culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF VEICULO->(EOF())
   Aviso("Vocà precisa definir cadastrando os ve°culos primeiro",,3)
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO STATUS="A"

SELECT 12
IF NetUse("DBCURSO","CURSO")          /* Cursos */
   SET INDEX TO DBICUR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso("ê necess†rio cadastrar os cursos!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF NetUse("DBSD","SALDOS")            /* Saldos */
   SET INDEX TO DBISD1
   DBGOBOTTOM()
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF (SALDOS->DATA-1)==cDtSys.AND.wOp=2
   Aviso("Matr°cula n∆o pode ser efetuada - Caixa Fechado",,3)
   DBCLOSEALL(); RETURN
ENDIF

SELECT 16
IF NetUse("DBEXAM","EXAME")           /* Exames de Direáao */
   SET INDEX TO DBIEXAM1,DBIEXAM2
ELSE
   RETURN
ENDIF

SELECT 22
IF NetUse("DBCERT","CERTIF")          /* Certificados */
   SET INDEX TO DBICERT1,DBICERT2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBPEND","PENDENCIA")       /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 8
IF NetUse("DBREQ","REQ")              /* Requerimentos */
   SET INDEX TO DBIREQ1
ELSE
   RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")             /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBPROG","AULAS")           /* Programaá∆o de Aulas Praticas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3,DBIPRO4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBPAG","PAGAR")            /* Pagamentos de Alunos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF !NetUse("DBPARM")                  /* Parametros */
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBALU","ALUNO")            /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

PUBLIC wParcelas
cPrg:="AE110"; ProgName(cPrg)
cOpHelp1 := "1"; cOpHelp2 := "10"
PUBLIC xVeiculo:=SPACE(2); xDtPrev:=xDtPrev1:=cDtSys; xHora:=xHora1:=SPACE(4)
LinhaMsg(2)
SET KEY -1 TO Mostra()
WHILE .T.
   lNovo := lDeleta := lAchou := .F.
   xCPF:=SPACE(11); wMatr:=SPACE(5); vNome:=wAlu:= SPACE(50)
    
   SETCOLOR(YCOREDIT)
   IF wOp==1
      Telas(19,3,21,22,1,YCOREDIT,.T.)
      Mensagem("Informe N£mero da Matr°cula")
      @ 20,05 SAY "Matr°cula:" GET wMatr PICT "@K 99999" WHEN TeclaFuncao(.T.)
   ELSEIF wOp==2
      Telas(18,3,21,71,1,YCOREDIT,.T.)
      Mensagem("Informe o CPF do Aluno")
      @ 19,05 SAY "Nome do Aluno:" GET vNome PICT "@!" //VALID !EMPTY(vNome)
      @ 20,05 SAY "N£mero CPF/MF:" GET xCPF  PICT "@R 999.999.999-99" VALID LASTKEY()=K_UP.OR.EMPTY(xCPF).OR.ChkCPF(xCPF)
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC.OR.EMPTY(IF(wOp==1,wMatr,vNome+xCPF)); EXIT; ENDIF
   Rest_Tela()

   SELECT ALUNO
   IF wOp==2   /* Matricula */
      IF !EMPTY(xCPF)
         ALUNO->(DBSETORDER(4))
         lAchou:=DBSEEK(xCPF)
      ELSE
         ALUNO->(DBSETORDER(2))
         lAchou:=DBSEEK(vNome)
      ENDIF
   ELSE
      ChkPend(wMatr)  // Verifica pendencia
      ChkPReq(wMatr)  // Verifica pendencia de requerimento
      ALUNO->(DBSETORDER(1))
      lAchou:=DBSEEK(wMatr)
      xCPF:=ALUNO->CPF
   ENDIF
   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   IF wOp==2.AND.lAchou; wNome:=ALUNO->NOME; ENDIF
   IF wOp==2.AND.!lAchou; wNome:=vNome; wCpf:= xCPF; ENDIF
   IF wOp==1; vNome:=wNome; ENDIF

   IF lAchou
      Telas(2,3,21,76,1,YCOREDIT,.T.,"Matr°cula de Alunos")
      /* Display do Codigo */
      @ 03,65 SAY wMatric COLOR YCORREALCE
      IF ALUNO->RESULTADO=="X"
         Aviso("CrÇditos cancelados por vencimento do contrato.")
      ENDIF
   ELSE
      IF wOp==1
         Aviso("Matr°cula n∆o localizada...!",,3); LOOP
      ENDIF
      Telas(2,3,21,76,1,YCOREDIT,.T.,"Matr°cula de Alunos")
      wDtInscr:=cDtSys; wCateg:="AB"; wTurnoFR:=wTurnoFC:="MTN";wNacional="BRASILEIRA"
      wCivil:="S";wOrgao:="SSPBA";wUF_Nat:=wUF:="BA";wCidade:="SALVADOR       "
   ENDIF
   lAltera:=.F.

   LimpaLinhaMsg()
   IF wOp=1
      @ 03,05 SAY "Nome Aluno.:"  GET wNome PICT "@!S34" WHEN nNivel>=7.AND.!EOF().AND.wOp#2.AND.lAchou.AND.TeclaFuncao()
   ELSEIF wOp=2
      @ 03,05 SAY "Nome Aluno.:"  GET wNome PICT "@!S34" VALID !EMPTY(wNome)
   ENDIF
   @ 03,53 SAY "Matr°cula.:"

   @ 04,05 SAY "Inscriá∆o..:"  GET wDtInscr   PICT "@D"    WHEN nNivel>=5
   @ 04,32 SAY "Categoria:"    GET wCateg     PICT "!!"    VALID wCateg$"AB|A |B |AC|BC|C "
   @ 04,53 SAY "Data.Nasc.:"   GET wDtNas     PICT "@D"    //VALID LASTKEY()==K_UP.OR.!EMPTY(wDtNas).AND.wDtNas<cDtSys.AND.IF(CalcIdade(cDtSys,wDtNas)<18,Lef(Aviso("Menor de Idade")),.T.)

   @ 05,05 SAY "Hab(S/N)/Nr:"  GET wApto      PICT "!"     VALID LASTKEY()==K_UP.OR.wApto$"SN "
   @ 05,20                     GET wHabilita
   @ 05,32 SAY "Categoria:"    GET wCateg2    PICT "@!"
   @ 05,53 SAY "Vencimento:"   GET wVctoCat2

   @ 06,05 SAY "CFC Te¢rico:"  GET wCFCT      PICT "@!"
   @ 06,31 SAY "Etiqueta.:"    GET wETQT      PICT "@!"
   @ 06,54 SAY "C¢digo:"       GET wCODT      PICT "@!"
   @ 07,05 SAY "CFC Pr†tico:"  GET wCFCP      PICT "@!"
   @ 07,31 SAY "Etiqueta.:"    GET wETQP      PICT "@!"
   @ 07,54 SAY "C¢digo:"       GET wCODP      PICT "@!"

   @ 08,05 SAY "RENACH(1)..:"  GET wRENACH    PICT "@!"
   @ 08,31 SAY "RENACH(2):"    GET wRENACH2   PICT "@!"
   @ 08,53 SAY "RENACH(3).:"   GET wRENACH3   PICT "@!"

   @ 09,05 SAY "Nß RG......:"  GET wRG        PICT "@!"
   @ 09,31 SAY "Org∆o....:"    GET wOrgao     PICT "@R !!!/!!"
   @ 09,53 SAY "Expediá∆o.:"   GET wExped     PICT "@D"

   @ 10,05 SAY "Nß CPF.....:"  GET wCPF       PICT "@R 999.999.999-99" WHEN nNivel>=5.AND.wOp=1
   @ 10,49 SAY "Fone Res.:"    GET wFone_r    PICT "@R 99 9999-9999"
   @ 10,73 GET wTurnoFR        PICT "!!!"     VALID wTurnoFR $ "MTN/MT /M  /T  /N  /MN /TN /   "

   @ 11,05 SAY "Tel/Recados:"  GET wContato   PICT "@!"
   @ 11,49 SAY "Fone Coml:"    GET wFone_c    PICT "@R 99 9999-9999"
   @ 11,73 GET wTurnoFC        PICT "!!!"     VALID wTurnoFC $ "MTN/MT /M  /T  /N  /MN /TN /   "

   @ 12,05 SAY "E-Mail.....:"  GET wEmail
   @ 12,49 SAY "Celular..:"    GET wCelular   PICT "@R 9999-9999"

   @ 13,05 SAY "Nome do Pai:"  GET wFilia_P   PICT "@!"
   @ 14,05 SAY "Nome da M∆e:"  GET wFilia_M   PICT "@!"

   @ 15,05 SAY "Natural de.:"  GET wNatural   PICT "@!S27"
   @ 15,49 SAY "UF/Provin:"    GET wUF_Nat    PICT "!!"

   @ 16,05 SAY "Nacionalid.:"  GET wNacional  PICT "@!"
   @ 16,29 SAY "Civil:"        GET wCivil     PICT "!"   WHEN HTela(1) VALID VTela(1)
   @ 16,39 SAY "Sexo:"         GET wSexo      PICT "!"   VALID LASTKEY()==K_UP.OR.wSexo$"MF"
   @ 16,49 SAY "Profiss∆o:"    GET wProf      PICT "@!S15"

   @ 17,05 SAY "Endereáo...:"  GET wEndereco  PICT "@!S58"

   @ 18,05 SAY "Bairro.....:"  GET wBairro    PICT "@!"
   @ 18,39 SAY "UF..:"         GET wUF        PICT "!!"  VALID ChkUF(wUF)
   @ 18,49 SAY "Cidade...:"    GET wCidade    PICT "@!S15"

   @ 19,05 SAY "Ponto Ref..:"  GET wPRef      PICT "@!"
   @ 19,49 SAY "CEP......:"    GET wCEP       PICT "@R 99.999-999"

*  @ 20,05 SAY "Pesquisa...:"  GET wAuto      PICT "!"   WHEN HTela(13) VALID IF(LASTKEY()==K_UP,Let(Rest_Tela()),.F.).OR.VTela(13)
   @ 20,05 SAY "Marketing..:"  GET wPesq      PICT "!"   WHEN HTela(14) VALID IF(LASTKEY()==K_UP,Let(Rest_Tela()),.F.).OR.VTela(14)
   @ 20,25 SAY "Qual ?:"       GET wOutro     PICT "@!"  WHEN wPesq="0"

   IF EOF()
      IF Acesso(3)
         SETCURSOR(1); READ; SETCURSOR(0)
         msg   := "Confirma os Dados ? "
         lNovo := .T.
      ELSE
         CLEAR GETS
         Rest_Tela(); LOOP
      ENDIF
   ELSE
      IF nNivel==1
         Mensagem("Tecle algo para continuar..."); INKEY(0)
         CLEAR GETS
         Rest_Tela(); LOOP
      ENDIF
      DeleAltera()
      IF LASTKEY()==K_ENTER
         IF Acesso(3)
            SETCURSOR(1); READ; SETCURSOR(0)
            msg     := "Confirma Alteraá∆o ? "
            lAltera := .T.
         ELSE
            KEYBOARD CHR(27); READ
         ENDIF
      ELSEIF LASTKEY()==K_DEL
         IF Acesso(5)
            CLEAR GETS
            msg     := "Confirma a Exclus∆o ? "
            lDeleta := .T.
         ELSE
            KEYBOARD CHR(27); READ
         ENDIF
      ENDIF
   ENDIF
   IF LASTKEY() <> K_ESC
      IF Confirma(msg)
         IF lDeleta
            CERTIF->(DBSEEK(wMatric))
            WHILE !CERTIF->(NetLReg()); ENDDO
            CERTIF->(DBDELETE()); CERTIF->(DBUNLOCK())

            IF PAGAR->(DBSEEK(wMatric))
               WHILE PAGAR->MATRIC==wMatric.AND.!PAGAR->(EOF())
                  IF EMPTY(PAGAR->DTPGTO)
                     IF PAGAR->DTVCTO <= cDtSys //DATE()
                        Aviso("Aluno com Pagamento Pendente")
                        IF Confirma("Exclui assim mesmo ?")
                           EXIT
                        ELSE
                           Rest_Tela(); DBCLOSEALL(); RETURN
                        ENDIF
                     ENDIF
                  ENDIF
                  PAGAR->(DBSKIP())
               ENDDO
               Aguarde("Excluindo...")
               /* Eliminar pagamentos efetuados */
               PAGAR->(DBSEEK(wMatric))
               WHILE PAGAR->MATRIC==wMatric.AND.!PAGAR->(EOF())
                  WHILE !PAGAR->(NetLReg()); ENDDO
                  PAGAR->(DBDELETE()); PAGAR->(DBUNLOCK())
                  PAGAR->(DBSKIP())
               ENDDO
               /* Eliminar movimento no caixa */
               CAIXA->(DBSETORDER(2))
               CAIXA->(DBSEEK(wMatric))
               WHILE CAIXA->MATRIC==wMatric
                   WHILE !CAIXA->(NetLReg()); ENDDO
                   CAIXA->(DBDELETE()); CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
                   CAIXA->(DBSKIP())
               ENDDO
               /* Eliminar toda a programacao do aluno */
               AULAS->(DBSEEK(wMatric))
               WHILE AULAS->MATRIC==wMatric.AND.!AULAS->(EOF())
                  WHILE !AULAS->(NetLReg()); ENDDO
                  AULAS->(DBDELETE()); AULAS->(DBUNLOCK())
                  AULAS->(DBSKIP())
               ENDDO
               DBCOMMITALL(); Aguarde()
            ENDIF
            WHILE !NetLReg(); ENDDO
            DBDELETE(); DBUNLOCK()
         ELSE
            wEmail:=LOWER(wEmail)
            IF lAltera.AND.vNome#wNome
               CERTIF->(DBSEEK(wMatric))
               WHILE !CERTIF->(NetLReg()); ENDDO
               REPLACE CERTIF->NOME WITH wNome
               CERTIF->(DBUNLOCK()); CERTIF->(DBCOMMIT())
            ENDIF
            IF lNovo
               WHILE !NetApp(); ENDDO
               SELECT DBPARM; DBGOTOP()
               IF EOF(); NetApp(); ENDIF
               IF NetLReg()
                  wMatric := STRZERO(VAL(MATRIC)+1,5)
                  xMatric := wMatric
                  FIELD->MATRIC := wMatric
               ENDIF
               SELECT ALUNO
            ENDIF
            IF EMPTY(wFone_r)
               wTurnoFR:=SPACE(3)
            ENDIF
            IF EMPTY(wFone_c)
               wTurnoFC:=SPACE(3)
            ENDIF
            WHILE !NetLReg(); ENDDO
            FOR a = 1 TO FCOUNT()
                xVar  := "w"+FIELDNAME(a)
                FIELDPUT(a,&xVar)
            NEXT
            DBUNLOCKALL(); DBCOMMIT()

            IF lNovo
               /* Gravar na lista de certificados */
               WHILE !CERTIF->(NetApp()); ENDDO
               REPLACE CERTIF->MATRIC WITH wMatric ,;
                       CERTIF->NOME   WITH wNome
               CERTIF->(DBUNLOCK()); CERTIF->(DBCOMMIT())

               wValor_P1:=wValor_P2:=wValor_P3:=wValor_P4:=wValor_P5:=wValor_P6:=wValor_D:=wCarro:=wTaxa:=0.00
               wDoc1:=wDoc2:=wDoc3:=wDoc4:=wDoc5:=wDoc6:=SPACE(10); wObs1:=SPACE(67); wServico:=SPACE(50)
               wBanco1:=wBanco2:=wBanco3:=wBanco4:=wBanco5:=wBanco6:=SPACE(15);wNF:=SPACE(6)
               wdia1:=cDtSys; wdia2:=wdia3:=wDia4:=wDia5:=wDia6:=CTOD("");wOptou:=" "; wAulasT:=0
               wTit1:=wTit2:=wTit3:=wTit4:=wTit5:=wTit6:=SPACE(25);xCodCur:=SPACE(2)
               IF ConfPgto("Forma de Pagamento ?")
                  Parcelamento()
               ELSE
                  Avista()
               ENDIF

               // Gravar na lista de exames
               IF wCarro>0.00
                  WHILE !EXAME->(NetApp()); ENDDO
                  REPLACE EXAME->DTVCTO    WITH wDia1       ,;
                          EXAME->NOME      WITH ALUNO->NOME ,;
                          EXAME->MATRIC    WITH wMatric     ,;
                          EXAME->CARRO     WITH wCarro      ,;
                          EXAME->CODVEIC   WITH xVeiculo    ,;
                          EXAME->CODINST   WITH wCodInst    ,;
                          EXAME->VEZ       WITH "1"         ,;
                          EXAME->DTEXAME   WITH xDtPrev     ,;
                          EXAME->HORA      WITH xHora       ,;
                          EXAME->DTEXAME1  WITH xDtPrev1    ,;
                          EXAME->HORA1     WITH xHora1      ,;
                          EXAME->RENACH    WITH wRENACH     ,;
                          EXAME->RESULTADO WITH "9"
                  EXAME->(DBUNLOCK()); EXAME->(DBCOMMIT())
               ENDIF

               IF Confirma("Imprime Ficha de Matr°cula ?")
                  IF ChkImpr()
                     cAviso := MsgImp(.F.)
                     ImpFichaMat()
                     WHILE Confirma("Outra C¢pia da Ficha ?")
                        ImpFichaMat()
                     ENDDO
                     TiraMsgImp(cAviso)
                     WaitMsg("Fim de Impress∆o, tecle algo...")
                  ENDIF
               ENDIF
               IF Confirma("Imprime Contrato ?")
                  IF ChkImpr()
                     cAviso := MsgImp()
                     ImpContrato()
                     WHILE Confirma("Outra C¢pia do Contrato ?")
                        ImpContrato()
                     ENDDO
                     TiraMsgImp(cAviso)
                     WaitMsg("Fim de Impress∆o, tecle algo...")
                  ENDIF
               ENDIF

               Rest_Tela()
               @ 03,65 SAY wMatric COLOR YCORREALCE
               Mensagem("Tecle algo para continuar..."); INKEY(0)
*              DBUNLOCK(); DBCOMMITALL()
*              SETKEY(K_F2,NIL); Rest_Tela()
*              KEYB CHR(4)+CHR(13)
*              IF wAulasT>0
*                 TelaTurmas()      /* Seleá∆o da turma             */
*                 DBCLOSEALL()
*                 AE_211(xMatric)   /* Programacao Te¢rica do Aluno */
*              ENDIF
*              DBCLOSEALL()
*              RETURN
            ENDIF
            DBUNLOCKALL(); DBCOMMITALL()
         ENDIF
      ENDIF
   ELSE
      CLEAR GETS
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
   ENDIF
   Rest_Tela()
ENDDO
RELEASE xVeiculo,xDtPrev,xDtPrev1,xHora,xHora1,xLocal,wParcelas
SETKEY(K_F2,NIL); Rest_Tela()
DBCLOSEALL(); RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Recibo              ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ImpRecibo(pMat)
  LOCAL linha1:=linha2:=""
  Gera_TXT("AE110.TXT")
  @ PROW()+1,05 SAY cRazao
  @ PROW()+1,05 SAY cEnder1
  @ PROW()+1,05 SAY cEnder2
  @ PROW()+1,05 SAY cEnder3
  @ PROW()+1,05 SAY cCGC_MF
  Controle()
  @ PROW()+1,05 SAY "# "+DBPARM->CR+pMat+" #"
  @ PROW()+3,05 SAY PADC("** R E C I B O **",70)
  @ PROW()+2,64 SAY "R$ "+TRANSFORM(wValor,"@E 999.99")
  @ PROW()+3,00 SAY "        Recebemos do(a) Sr(a). "+RTRIM(wNome)+" "+REPL("/",47-LEN(RTRIM(wNome)))

  tValor:=Extenso(wValor)
  @ PROW()+2,05 SAY "a importancia de R$ "+ALLTRIM(TRANSFORM(wValor,"@E 999.99"))+"("+tValor+")"
  IF !EMPTY(wAulasT).AND.EMPTY(wAulas)
     @ PROW()+2,05 SAY "referente ao pagamento de "+STR(wAulasT,2)+" hs/aula TEORICAS, na forma abaixo discriminada:"
  ELSEIF EMPTY(wAulasT).AND.!EMPTY(wAulas)
     @ PROW()+2,05 SAY "referente ao pagamento de "+STR(wAulas,2)+" aula(s) PRATICAS, na forma abaixo discriminada:"
  ELSEIF !EMPTY(wAulasT).AND.!EMPTY(wAulas)
     @ PROW()+2,05 SAY "referente ao pagamento de "+STR(wAulasT,2)+" aula(s) TEORICAS, e "+STR(wAulas,2)+" aula(s) PRATICAS"
     @ PROW()+2,05 SAY "na forma abaixo discriminada:"
  ELSEIF EMPTY(wAulasT).AND.EMPTY(wAulas)
     @ PROW()+2,05 SAY "referente aos pagamentos de SERVICOS abaixo discriminados:"
  ENDIF

  ImpResFormPag()  // Resumo da forma de pagamento

  IF wCarro>0.00
     @ PROW()+3,05 SAY "***** INCLUSO A TAXA DO VEICULO ******"
*    @ PROW()+1,05 SAY "Previs∆o: "+DTOC(xDtPrev)+" as "+TRANSFORM(xHora,"@R 99:99")+" ou "+DTOC(xDtPrev1)+" as "+TRANSFORM(xHora1,"@R 99:99")
     @ PROW()+1,02 SAY " ** O exame somente se realizar† nas datas e hor†rios previstos acima"
     @ PROW()+1,02 SAY "    devendo estar, previamente, marcados junto ao DETRAN."
     @ PROW()+1,05 SAY "Local...: "+xLocal
     @ PROW()+1,05 SAY "Ve°culo.: "+ALLTRIM(VEICULO->MARCA)
     @ PROW()+1,05 SAY "Documentos Necess†rios: "
     @ PROW()+1,05 SAY "    - RG (original)"
     @ PROW()+1,05 SAY "    - Nß RENACH"
     @ PROW()+1,05 SAY "    - Licenáa (LADV)"
     @ PROW()+2,05 SAY "** ATENÄAO ** Ligar um dia antes para confirmar o exame"
     @ PROW()+1,05 SAY "              Aluno apto retornar a escola p/pegar certificado."
     @ PROW()+1,05 SAY "              A falta do aluno acarretar† a perda da taxa paga,"
     @ PROW()+1,05 SAY "              bem como comparecer em trajes inadequados."
  ELSE
     @ PROW()+3,05 SAY "*** NAO ESTA INCLUSO A TAXA DO VEICULO ***"
  ENDIF
  IF !EMPTY(wObs1)
     @ PROW()+3,05 SAY "OBSERVACOES: "
     @ PROW()+1,08 SAY wObs1
  ENDIF
  @ PROW()+3,05 SAY PADR("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),80)
  @ PROW()+3,05 SAY REPL("_",LEN(cRazao))
  @ PROW()+1,05 SAY cRazao

  IF !EMPTY(wAulasT)
     @ PROW()+1,45 SAY "INICIO DO CURSO TEORICO"
     @ PROW()+1,45 SAY "____/____/____ AS ______"
     @ PROW()+1,45 SAY "( )MAT. ( )VESP. ( )NOT."
  ENDIF

  @ PROW()+3,05 SAY "  - DURANTE O CURSO TEORICO, PROVIDENCIE, IMEDIATAMENTE, O LAUDO JUNTO"
  @ PROW()+1,05 SAY "    AO DETRAN E O EXAME MEDICO, a fim de evitar atrasos e preju°zos."
  @ PROW()+1,05 SAY "  - Em caso de desistància ser† descontada a taxa equivalente a"
  @ PROW()+1,05 SAY "    20% (vinte por cento) do valor total pago."
  @ PROW()+1,05 SAY "  - Recibo v†lido por 01(um) ano."
  IF !EMPTY(wAulas).AND.EMPTY(wAulasT)
     @ PROW()+1,05 SAY "  - Desmarcaá∆o de aulas somente com 24 horas de antecedància."
     @ PROW()+1,05 SAY "  - REPOSIÄAO de aulas somente mediante pagamento da aula pendente."
     @ PROW()+1,05 SAY "  - S¢ Ç permitido o treinamento com uso de trajes adequados."
  ENDIF
  IF !EMPTY(wAulasT).AND.!EMPTY(wAulas)
     @ PROW()+1,05 SAY "  - Simulado Teorico no ultimo dia de aula."
     @ PROW()+1,05 SAY "  - Hor†rio normal de aula pr†tica. Seg. a Sex. das 7:00 Ös 19:50h"
     @ PROW()+1,05 SAY "    s†bados das 7:00 as 17:00h. 50 minutos."
     @ PROW()+1,05 SAY "  - REPOSICAO de aulas somente mediante pagamento da aula pendente."
     @ PROW()+1,05 SAY "  - As aulas teoricas ser∆o realizadas no mesmo endereáo da sede."
  ELSEIF !EMPTY(wAulasT).AND.EMPTY(wAulas)
     @ PROW()+1,05 SAY "  - Simulado Teorico no ultimo dia de aula."
     @ PROW()+1,05 SAY "  - Hor†rio normal de aula pr†tica. Seg. a Sex. das 7:00 Ös 18:55h"
     @ PROW()+1,05 SAY "    s†bados das 7:00 as 12:30h. 50 minutos."
     @ PROW()+1,05 SAY "  - REPOSICAO de aulas somente mediante pagamento da aula pendente."
     @ PROW()+1,05 SAY "  - As aulas ser∆o realizadas no mesmo endereáo da sede."
  ENDIF
  @ PROW()+3,05 SAY "_______________________"
  @ PROW()+1,05 SAY "      De acordo        "
  @ PROW()+1,05 SAY " "
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp AE110.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE AE110.TXT
  RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Ficha de Matricula           ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ImpFichaMat()
   LOCAL xPesq:=xAuto:=" "
   Gera_TXT("FICHA.TXT")
   continua := .T.
   CabRel("FICHA DE MATRICULA",.F.)
   Cab_ESC(1,05,"Nß "+ALUNO->MATRIC)
   Cab_ESC(0,60,"Oper: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1))
   Cab_ESC(1,05,REPL("-",77))
   Cab_ESC(1,05,"Aluno....:")
   Cab_ESC(0,16,ALUNO->NOME)
   Cab_ESC(1,05,"Pai......:")
   Cab_ESC(0,16,ALUNO->FILIA_P)
   Cab_ESC(1,05,"Mae......:")
   Cab_ESC(0,16,ALUNO->FILIA_M)
   Cab_ESC(1,05,"Natural..:")
   Cab_ESC(0,16,ALUNO->NATURAL)
   Cab_ESC(1,05,"Endereco.:")
   Cab_ESC(0,16,ALUNO->ENDERECO)
   Cab_ESC(1,05,"Bairro...:")
   Cab_ESC(0,16,ALUNO->BAIRRO)
   Cab_ESC(0,40,"Cidade/UF:")
   Cab_ESC(0,51,ALLTRIM(ALUNO->CIDADE)+"/"+ALUNO->UF)
   Cab_ESC(1,05,"CEP......:")
   Cab_ESC(0,16,ALUNO->CEP)
   Cab_ESC(1,05,"RG/Org∆o :")
   Cab_ESC(0,16,ALLTRIM(ALUNO->RG)+"-"+SUBS(ALUNO->ORGAO,1,3)+"/"+SUBS(ALUNO->ORGAO,4)+" Expedida em: "+DTOC(ALUNO->EXPED))
   Cab_ESC(1,05,"CPF......:")
   Cab_ESC(0,16,ALUNO->CPF,"[@R 999.999.999-99]")
   Cab_ESC(1,05,"Dt.Nasc..:")
   Cab_ESC(0,16,ALUNO->DTNAS,"[@D]")
   Cab_ESC(1,05,"E-MAIL...:")
   Cab_ESC(0,16,ALUNO->EMAIL)
   Cab_ESC(1,05,"Profiss∆o:")
   Cab_ESC(0,16,ALUNO->PROF)
   Cab_ESC(1,05,"RENACH...:")
   Cab_ESC(0,16,ALUNO->RENACH)

   Cab_ESC(1,05,"AP.Pr†tica: "+ALUNO->ETQP+"/"+ALUNO->CODP)
   Cab_ESC(0,40,"AT.Te¢rica: "+ALUNO->ETQT+"/"+ALUNO->CODT)
   IF !EMPTY(ALUNO->ETQP)
      Cab_ESC(1,17,"Transferància")
   ENDIF

   Cab_ESC(1,05,"Curso....:")
   Cab_ESC(0,16,CURSO->DESCR)
   Cab_ESC(0,40,"Categ.:")
   Cab_ESC(0,48,ALUNO->CATEG)

   IF wPesq="1"
      xPesq="* Marketing - INDICACAO"
   ELSEIF wPesq="2"
      xPesq="* Marketing - PANFLETO"
   ELSEIF wPesq="3"
      xPesq="* Marketing - ONIBUS"
   ELSEIF wPesq="4"
      xPesq="* Marketing - TELELISTA"
   ELSEIF wPesq="5"
      xPesq="* Marketing - EDITEL"
   ELSEIF wPesq="6"
      xPesq="* Marketing - OUTDOR"
   ELSEIF wPesq="7"
      xPesq="* Marketing - INTERNET"
   ELSEIF wPesq="8"
      xPesq="* Marketing - TV"
   ELSEIF wPesq="9"
      xPesq="* Marketing - RADIO"
   ELSEIF wPesq="0"
      xPesq="* Marketing - OUTROS"
   ENDIF
   IF xAuto#" "
      @ PROW()+2,05 SAY xAuto
   ENDIF
   IF xPesq#" "
      @ PROW()+1,05 SAY xPesq
   ENDIF

   Cab_ESC(1,02,REPL("-",77))
   Cab_ESC(1,05,"CURSO INICIAL COM "+STR(wAulasT,2)+" AULAS TEORICAS")
   Cab_ESC(1,05,"                  "+STR(wAulas,2)+" AULAS PRATICAS")
   IF wCarro#0.00
      Cab_ESC(1,05,"CARRO P/ EXAME")
   ENDIF
   IF wTaxa#0.00
      Cab_ESC(1,05,"TAXA DE SERVIÄO")
   ENDIF
   Cab_ESC(1,02,REPL("-",77))
   Cab_ESC(1,05,"FORMA DE PAGAMENTO")
   Cab_ESC(1,02," ")
   IF wValor_D>0.00
      Cab_ESC(1,05,"Dinheiro.......R$ "+STR(wValor_D,7,2))
   ENDIF

   ImpResFormPag()

*  Cab_ESC(4,05,"RECEBI O MANUAL E O PASSO-A-PASSO DE ORIENTACAO DO CURSO")
   Cab_ESC(3,05,"______________________________________    _________________________________")
   Cab_ESC(1,05,"        ASSINATURA DO ALUNO                   ASSINATURA DIRETOR ENSINO")
   Cab_ESC(2,00,PADC("***** O B S E R V A Ä O E S *****",80))
   Cab_ESC(1,00," ")
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp FICHA.TXT 80 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE FICHA.TXT
RETURN
************************************************
*  Imprimir Resumo da Forma de Pagamento       *
************************************************
PROCEDURE ImpResFormPag()

   IF !EMPTY(wValor_D)
      @ PROW()+2,10 SAY "-> Pagamento em espÇcie R$ "+STR(wValor_D,7,2)
   ENDIF
   IF !EMPTY(wValor_P1)
      IF SUBS(wDoc1,1,1)#"A".AND.SUBS(wDoc1,1,1)#"NP"
         @ PROW()+2,10 SAY "-> Cheque Ö Vista R$ "+STR(wValor_P1,7,2)+" No. "+wDoc1+" "+wBanco1+" "+DTOC(wDia1)
      ELSEIF SUBS(wDoc1,1,1)=="A"
         @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P1,7,2)+" Autorizaá∆o No. "+SUBS(wDoc1,2)+" "+wBanco1
      ELSEIF SUBS(wDoc1,1,2)=="NP"
         @ PROW()+2,10 SAY "-> Nota Promiss. R$ "+STR(wValor_P1,7,2)+" No. "+SUBS(wDoc1,2)+" "+wBanco1+" "+DTOC(wDia1)
      ENDIF
   ENDIF

   IF wParcelas>0
      IF !EMPTY(wValor_P2)
         IF SUBS(wDoc2,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P2,7,2)+" Autorizaá∆o No. "+SUBS(wDoc2,2)+" "+wBanco2
         ELSEIF SUBS(wDoc2,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P2,7,2)+" No. "+SUBS(wDoc2,3)+" "+wBanco2+" "+DTOC(wDia2)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P2,7,2)+" No. "+wDoc2+" "+wBanco2+" "+DTOC(wDia2)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc3)
         IF SUBS(wDoc3,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P3,7,2)+" Autorizaá∆o No. "+SUBS(wDoc3,2)+" "+wBanco3
         ELSEIF SUBS(wDoc3,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P3,7,2)+" No. "+SUBS(wDoc3,3)+" "+wBanco3+" "+DTOC(wDia3)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P3,7,2)+" No. "+wDoc3+" "+wBanco3+" "+DTOC(wDia3)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc4)
         IF SUBS(wDoc4,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P4,7,2)+" Autorizaá∆o No. "+SUBS(wDoc4,2)+" "+wBanco4
         ELSEIF SUBS(wDoc4,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P4,7,2)+" No. "+SUBS(wDoc4,3)+" "+wBanco4+" "+DTOC(wDia4)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P4,7,2)+" No. "+wDoc4+" "+wBanco4+" "+DTOC(wDia4)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc5)
         IF SUBS(wDoc5,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P5,7,2)+" Autorizaá∆o No. "+SUBS(wDoc5,2)+" "+wBanco5
         ELSEIF SUBS(wDoc5,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P5,7,2)+" No. "+SUBS(wDoc5,3)+" "+wBanco5+" "+DTOC(wDia5)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P5,7,2)+" No. "+wDoc5+" "+wBanco5+" "+DTOC(wDia5)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc6)
         IF SUBS(wDoc6,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P6,7,2)+" Autorizaá∆o No. "+SUBS(wDoc6,2)+" "+wBanco6
         ELSEIF SUBS(wDoc5,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P6,7,2)+" No. "+SUBS(wDoc6,3)+" "+wBanco6+" "+DTOC(wDia6)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P6,7,2)+" No. "+wDoc6+" "+wBanco6+" "+DTOC(wDia6)
         ENDIF
      ENDIF
   ENDIF
   RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Contrato              ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ImpContrato()
   LOCAL linha1:=linha2:="",xCol:=8
   Gera_TXT("CONTR.TXT"); SETPRC(0,0)
   @ PROW()+3,xCol   SAY Largo()+" "
   @ PROW()+1,xCol-8 SAY Negrito()+PADC(xRazao,65)
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()+1,xCol-4 SAY Denso_96()+PADC(cEnder1,80)
   @ PROW()+1,xCol-4 SAY PADC(cEnder3,80)
   @ PROW()+2,xCol-8 SAY Largo()+PADC("CONTRATO DE PRESTAÄ«O DE SERVIÄOS",65)
   @ PROW()+1,xCol-8 SAY Normal()+PADC("MATRICULA Nß "+Negrito()+ALUNO->MATRIC,70)
   @ PROW()+1,05 SAY PADC("EMISS«O :"+DTOC(DATE()),65)
   @ PROW()+1,05 SAY PADC("VALIDADE:"+DTOC(CTOD(SUBS(DTOC(cDtSys),1,5)+"/"+RIGHT(STRZERO(YEAR(cDtSys)+1,4),2))),65)

   @ PROW()+3,xCol-1 SAY Normal()+"DADOS DO CONTRATANTE:"
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()  ,xCol-1 SAY "_____________________"
   @ PROW()+2,xCol   SAY Denso_96()+"NOME........: "+ALUNO->NOME
   @ PROW()+1,xCol   SAY "ENDEREÄO....: "+ALLTRIM(ALUNO->ENDERECO)
   @ PROW()+1,xCol   SAY "            : "+ALLTRIM(ALUNO->BAIRRO)+", "+ALLTRIM(ALUNO->CIDADE)+"-"+ALUNO->UF
   @ PROW()+1,xCol   SAY "CPF.........: "+IF(!EMPTY(ALUNO->CPF),TRANSFORM(ALUNO->CPF,"@R 999.999.999-99")," ")
   @ PROW()+1,xCol   SAY "RG..........: "+IF(!EMPTY(ALUNO->RG),ALUNO->RG+", expedido por "+ALUNO->ORGAO+", em "+DTOC(ALUNO->EXPED)," ")

   @ PROW()+3,xCol-1 SAY Normal()+Negrito()+"DADOS DA CONTRATADA:"
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()  ,xCol-1 SAY "____________________"
   @ PROW()+2,xCol   SAY Denso_96()+"RAZ«O SOCIAL: "+xRazao
   @ PROW()+1,xCol   SAY "ENDEREÄO....: "+Denso_96()+UPPER(cEnder1)
   @ PROW()+1,xCol   SAY "            : "+UPPER(cEnder2)
   @ PROW()+1,xCol   SAY "CNPJ/MF.....: "+SUBS(cCGC_MF,7,18)

   @ PROW()+3,xCol-1 SAY Normal()+Negrito()+"VALOR DO CONTRATO:"
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()  ,xCol-1 SAY "__________________"
   @ PROW()+2,xCol   SAY "=> R$ "+ALLTRIM(TRANSFORM(wValor,"@E 9,999.99"))+" ("
   Imp_Extenso(wValor,LINHA1,LINHA)

   @ PROW()+2,xCol   SAY Denso_96()+"As partes tem entre si justo  e  contratados a prestaá∆o de  serviáos abaixo"
   @ PROW()+1,xCol   SAY "discriminados, mediante cl†usulas e condiá‰es adiante pactuadas:"
   @ PROW()+2,xCol   SAY "CLµUSULA PRIMEIRA - DO OBJETO:"
   @ PROW()  ,xCol   SAY "______________________________"
   @ PROW(),PCOL()+1 SAY                                "Ç objeto  do presente contrato a prestaá∆o de"
   @ PROW()+1,xCol   SAY "de serviáo do curso abaixo discriminado exclusivamente, a ser ministrado pe-"
   @ PROW()+1,xCol   SAY "la CONTRATADA, no local, hor†rio e per°odo definidos pela mesma."
   @ PROW()+1,xCol   SAY "PARµGRAFO PRIMEIRO - DO PAGAMENTO:"
   @ PROW()  ,xCol   SAY "__________________________________"
   @ PROW(),PCOL()+1 SAY                                    "O(A) CONTRATANTE pagar† Ö CONTRATADA, pe-"
   @ PROW()+1,xCol   SAY "la prestaá∆o dos serviáos, objeto deste contrato, a importÉncia supra, rela-"
   @ PROW()+1,xCol   SAY "tivo ao curso especifico no comprovante de pagamento emitido pela CONTRATADA"
   @ PROW()+1,xCol   SAY "PARµGRAFO ÈNICO - "
   @ PROW()  ,xCol   SAY "__________________"
   @ PROW(),PCOL()+1 SAY                    "O(A) CONTRATANTE ter†  flexibilidade, oferecida pela CON-"
   @ PROW()+1,xCol   SAY "TRATADA, para reposiá∆o de aula te¢rico-tÇcnico em dias e  hor†rios combina-"
   @ PROW()+1,xCol   SAY "dos, antecipadamente com a administraá∆o do curso de acordo com a disponibi-"
   @ PROW()+1,xCol   SAY "lidade da vaga na turma pretendida pelo(a) CONTRATANTE."
   @ PROW()+1,xCol   SAY "Ser† cobrado um valor adicional para o caso de reposiá∆o  de aulas  te¢rico-"
   @ PROW()+1,xCol   SAY "tÇcnicas, bem como para cada remarcaá∆o  de  prova te¢rica no DETRAN (legis-"
   @ PROW()+1,xCol   SAY "laá∆o, a partir da 2¶ e para marcaá∆o do simulado, conforme tabela."
   @ PROW()+2,xCol   SAY "CLµUSULA SEGUNDA - DA RESPONSABILIDADE DO CONTRATANTE:"
   @ PROW()  ,xCol   SAY "______________________________________________________"
   @ PROW(),PCOL()+1 SAY                                                        "Ç obrigat¢rio ao CON-"
   @ PROW()+1,xCol   SAY "TRATANTE(a) ter 100% de freqÅància no curso matriculado, conforme  determina"
   @ PROW()+1,xCol   SAY "a legislaá∆o vigente."
   @ PROW()+2,xCol   SAY "CLµUSULA TERCEIRA - DA DESIST“NCIA:"
   @ PROW()  ,xCol   SAY "___________________________________"
   @ PROW(),PCOL()+1 SAY                                     "O(A) CONTRATANTE  que  optar em desistir"
   @ PROW()+1,xCol   SAY "do curso no per°odo de 72(setenta e duas)horas ap¢s seu in°cio, ter†  resti-"
   @ PROW()+1,xCol   SAY "tu°do o valor pago, deduzido de  uma  taxa  de 20% (vinte por cento) sobre o"
   @ PROW()+1,xCol   SAY "valor total desembolsado no ato da matr°cula."
   @ PROW()+2,xCol   SAY "CLµUSULA QUARTA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  "Ap¢s a realizaá∆o do  Exame  Te¢rico-TÇcnico no  DETRAN/BA,"
   @ PROW()+1,xCol   SAY "ser† necess†rio que o(a) CONTRATANTE apresente, pessoalmente, o resultado na"
   @ PROW()+1,xCol   SAY "sede da CONTRATADA, no prazo m†ximo de 48h."
   @ PROW()+1,xCol   SAY " "

   EJECT

   @ PROW()+4,xCol   SAY "CLµUSULA QUINTA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  "Aulas Pr†ticas poder∆o ser desmarcadas 24h antes de sua re-"
   @ PROW()+1,xCol   SAY "alizaá∆o, sem o preju°zo para as partes. As mesmas poder∆o ser, tambÇm,  re-"
   @ PROW()+1,xCol   SAY "marcadas, sem quaisquer ìnus, apenas mediante apresentaá∆o  de justificativa"
   @ PROW()+1,xCol   SAY "por escrito, sejam elas: atestado mÇdico ou de trabalho, no prazo de atÇ 72h"
   @ PROW()+2,xCol   SAY "CLµUSULA SEXTA:"
   @ PROW()  ,xCol   SAY "_______________"
   @ PROW(),PCOL()+1 SAY                 "A CONTRATADA cobrar† uma taxa da CONTRATANTE em  caso de uso"
   @ PROW()+1,xCol   SAY "do ve°culo vinculado Ö CONTRATADA, na ocasi∆o da realizaá∆o do exame de pr†-"
   @ PROW()+1,xCol   SAY "tica de direá∆o veicular, conforme tabela em vigor."
   @ PROW()+2,xCol   SAY "CLµUSULA SêTIMA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  "O presente contrato tem o per°odo de validade de 01(um) ano"
   @ PROW()+1,xCol   SAY "passando a vigorar a partir data da assinatura, para a realizaá∆o  de todo o"
   @ PROW()+1,xCol   SAY "curso e ainda para dirimir quaisquer eventualidade no per°odo  da realizaá∆o"
   @ PROW()+1,xCol   SAY "da presente contrataá∆o."
   @ PROW()+2,xCol   SAY "CLµUSULA OITAVA - DO FORO:"
   @ PROW()  ,xCol   SAY "__________________________"
   @ PROW(),PCOL()+1 SAY                            "Fica eleito o foro da Comarca desta Capital, como"
   @ PROW()+1,xCol   SAY "o £nico competente  para dirimir todo  e  qualquer  lit°gio acaso advindo do"
   @ PROW()+1,xCol   SAY "presente instrumento, com expressa ren£ncia de outro  por  mais privilegiado"
   @ PROW()+1,xCol   SAY "que seja."
   @ PROW()+2,xCol   SAY "E, por estarem assim justas e contratadas, as partes assinam o presente ins-"
   @ PROW()+1,xCol   SAY "trumento, em duas (2) vias, de igual teor e para um s¢ fim,  obrigando-se ao"
   @ PROW()+1,xCol   SAY "seu fiel cumprimento por si e por seus  sucessores Ö  produá∆o dos devidos e"
   @ PROW()+1,xCol   SAY "legais efeitos."
   @ PROW()+3,xCol-4 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),80)
   @ PROW()+4,xCol   SAY "__________________________________          ________________________________"
   @ PROW()+1,xCol   SAY "    CONTRATADA - Administraá∆o                 CONTRATANTE (Aluno)"
   @ PROW()+1,xCol   SAY "         (Atendente)"
   @ PROW()+1,xCol   SAY " "

*  ImpRecibo(.F.,TALUNO->MATRIC)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp contr.txt 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CONTR.TXT
RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Tela de Turmas com vagas disp. ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION TelaTurmas(pOpen)
   LOCAL corant:=SETCOLOR(), oBr2, oCol2, vTela
   DEFAULT pOpen TO .T.
   IF pOpen
      SELECT 13
      IF NetUse("DBESCA","ESCALA")        /* Escalas */
         SET INDEX TO DBIESCA1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 12
      IF NetUse("DBFERI","FERIADO")       /* Feriados */
         SET INDEX TO DBIFER1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 11
      IF NetUse("DBSALA","SALA")          /* Salas */
         SET INDEX TO DBISALA1
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 9
      IF NetUse("DBFREQ","FREQUENCIA")    /* Frequencia de Aulas Te¢ricas */
         SET INDEX TO DBIFREQ1,DBIFREQ2
      ELSE
         DelDbfNtx(); RETURN
      ENDIF

      SELECT 8
      IF NetUse("DBGRADE","GRADE")        /* Grade Disciplinar */
         SET INDEX TO DBIGRAD1
      ELSE
         DBCLOSEALL(); RETURN
      ENDIF

      SELECT 7
      IF NetUse("DBTURMA","TURMA")        /* Turmas */
         SET INDEX TO DBITURM3,DBITURM1,DBITURM2
      ELSE
         DBCLOSEALL(); RETURN
      ENDIF
   ELSE
      SELECT TURMA; DBGOTOP()
   ENDIF

   msg:="Opá‰es Õ (^ENTER^) Seleciona/Deseleciona Turma"
   lSel:=.F.
   Telas(4,5,17,74,1,YCOREDIT,.T.,"Turmas Dispon°veis")
   Linha23(msg)
   oBr2:=TBROWSEDB(5,6,16,73)
   oBr2:headSep:="ƒ¬ƒ"
   oBr2:colSep:= " ≥ "
   oBr2:colorspec:=YCOREDIT

   oCol2:=TBCOLUMNNEW("Sel"          ,{|| SEL})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Turma"        ,{|| TURMA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Turno"        ,{|| IF(TURNO="1","Manh∆",IF(TURNO="2","Tarde",IF(TURNO="3","Noite",SPACE(5))))})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Escala"       ,{|| PegaEscala(ESCALA)})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Grade"        ,{|| CODGRA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Inicio"       ,{|| DTINIC})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("TÇrmino"      ,{|| DTFIM})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Sala"         ,{|| SALA})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Uso"          ,{|| USO_N})
   oBr2:addColumn(oCol2)
   oCol2:=TBCOLUMNNEW("Uso Rep."     ,{|| USO_R})
   oBr2:addColumn(oCol2)

   nVagas:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr2:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         lSel:=.F.
         TURMA->(DBGOTOP())
         Aguarde("Gerando grade de frequància...")
         WHILE !TURMA->(EOF())
            IF !EMPTY(TURMA->SEL)
               lSel:=.T.

               // Localiza 1¯ dia de aula da grade
               GRADE->(DBSEEK(TURMA->CODGRA+TURMA->CODCUR+"01"))
               xData  :=TURMA->DTINIC
               dDtFim :=TURMA->DTFIM
               xDia   :=GRADE->NDIA

               WHILE GRADE->CODGRA==TURMA->CODGRA.AND.GRADE->CODCUR==TURMA->CODCUR
                  // Testar feriados
                  IF TFeriado(xData)
                     xData := xData + 1; LOOP
                  ELSE
                     // Testar se dia Ç valido na escala
                     IF TEscala(xData,TURMA->ESCALA)
                        /* Gerar arquivo de frequencia */
                        WHILE !FREQUENCIA->(NetApp()); ENDDO
                        REPLACE FREQUENCIA->MATRIC   WITH xMatric         ,;
                                FREQUENCIA->CODCUR   WITH GRADE->CODCUR   ,;
                                FREQUENCIA->CODDIS   WITH GRADE->CODDIS   ,;
                                FREQUENCIA->CODINST  WITH GRADE->CODINST  ,;
                                FREQUENCIA->DATA     WITH xData           ,;
                                FREQUENCIA->HORARIO  WITH GRADE->HORARIO  ,;
                                FREQUENCIA->TURNO    WITH TURMA->TURNO    ,;
                                FREQUENCIA->NTURMA   WITH TURMA->NTURMA   ,;
                                FREQUENCIA->SIMULADO WITH GRADE->SIMULADO ,;
                                FREQUENCIA->NAULA    WITH GRADE->NAULA    ,;
                                FREQUENCIA->USER     WITH cUsuario
                        FREQUENCIA->(DBCOMMIT())
                     ELSE
                        xData := xData + 1; LOOP
                     ENDIF
                  ENDIF
                  GRADE->(DBSKIP())
                  IF GRADE->NDIA # xDia
                     xDia  := GRADE->NDIA
                     xData := xData + 1
                  ENDIF
               ENDDO

               IF (xData-1) > dDtFim
                  Aviso("Data de tÇrmino do curso Ç inferior ao gerado...")
               ENDIF

               // Diminuir o numero de vagas da turma
               WHILE !TURMA->(NetLReg()); ENDDO
               REPLACE TURMA->SEL   WITH SPACE(1)
               REPLACE TURMA->USO_N WITH TURMA->USO_N + 1
               TURMA->(DBUNLOCK())
            ENDIF
            TURMA->(DBSKIP())
         ENDDO
         Aguarde()
         IF lSel
            EXIT
         ELSE
            Aviso("Vocà precisa selecionar uma turma com vaga!")
         ENDIF
      ELSEIF ( tecla == K_F1 )   // Ajuda
         Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
      ELSEIF ( tecla == K_F4 )   // Calculadora
         Calculadora(calc_lin,calc_col,YCORMENU)
      ELSEIF ( tecla == K_F5 )   // Calendario
         Calendary(@cale_lin,@cale_col,@m_date)
      ELSEIF ( tecla == K_ENTER )
         // Verificar se tem vaga
         SALA->(DBSEEK(TURMA->SALA))
         IF TURMA->TURNO="1"       // Manh∆
            nVagas := SALA->VAGA_M - TURMA->USO_N
         ELSEIF TURMA->TURNO="2"   // Tarde
            nVagas := SALA->VAGA_V - TURMA->USO_N
         ELSEIF TURMA->TURNO="3"   // Noite
            nVagas := SALA->VAGA_N - TURMA->USO_N
         ENDIF

         IF nVagas>=1
            nReg:=TURMA->(RECNO())
            WHILE !TURMA->(NetLReg()); ENDDO
            REPLACE TURMA->SEL WITH IF(EMPTY(TURMA->SEL),"*"," ")
            TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
            TURMA->(DBGOTOP())
            WHILE !TURMA->(EOF())
               WHILE !TURMA->(NetLReg()); ENDDO
               IF TURMA->(RECNO())#nReg
                  REPLACE TURMA->SEL WITH SPACE(1)
               ENDIF
               TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
               TURMA->(DBSKIP())
            ENDDO
            TURMA->(DBGOTO(nReg))
            oBr2:refreshAll()
         ELSE
            Aviso("Turma n∆o tem vaga dispon°vel!")
         ENDIF
      ELSE
         ProcKey(oBr2,tecla)
      ENDIF
   ENDDO
   SETCOLOR(corant); Rest_Tela()
   RESTSCREEN(2,0,24,79,vTela)
   RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Rotina de Aluguel Carro Exame  ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION RCarro(pVar,pRot)
   DEFAULT pRot TO .F.
   IF pRot
      wCateg := ALUNO->CATEG
      wRG    := ALUNO->RG
      wRENACH:= ALUNO->RENACH
   ENDIF
   PUBLIC xLocal:="PCA GENERAL OSORIO, 33, FINAL DE LINHA DA RIBEIRA"
   IF pVar>0.00
      GetList:={}
      Telas(10,35,17,78,1,YCOREDIT,.T.)
      IF !EMPTY(xVeiculo)
         TDescr(14,1,11,53,xVeiculo,"MARCA",["@S20"])
      ENDIF
      @ 11,37 SAY "Ve°culo....:" GET xVeiculo  PICT "99"       WHEN TeclaFuncao(.T.);
        VALID Pesquisa(14,1,xVeiculo,"Ve°culo N∆o Cadastrado!").AND.TDescr(14,1,11,53,xVeiculo,"MARCA",["@S20"])
      @ 13,37 SAY "Local Exame:" GET xLocal    PICT "@!S25"
      @ 14,37 SAY "RENACH nß..:" GET wRENACH   WHEN .F.
      SETCURSOR(1); READ; SETCURSOR(0)
      wCodInst:=VEICULO->CODINST
      IF LASTKEY()==K_ESC; Rest_Tela(); RETURN(.F.); ENDIF
      Rest_Tela()
   ENDIF
   RETURN(.T.)
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Rotina de Pagamento Parcelado ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
PROCEDURE Parcelamento(pValve)
   DEFAULT pValve TO .T.
   Telas(3,0,22,78,1,YCOREDIT,.T.,"Parcelamento")
   WHILE .T.
      @ 04,02 SAY "Curso.........:" GET xCodCur PICT "99" WHEN TeclaFuncao(.T.) VALID Pesquisa(12,1,xCodCur,"C¢digo do Curso n∆o Localizado!");
              .AND.TDescr(12,1,4,21,xCodCur,"DESCR").AND.Let(wAulasT:=CURSO->TEORICA).AND.Let(wAulas:=CURSO->PRATICA)
      @ 05,02 SAY "Aulas Te¢ricas:" GET wAulasT PICT "99" 
      @ 06,02 SAY "Aulas Pr†ticas:" GET wAulas  PICT "99"
      @ 07,02 SAY "Nota Fiscal...:" GET wNF
      @ 08,02 SAY "Carro p/Exame.:" GET wCarro PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.RCarro(wCarro)
      @ 09,02 SAY "Serviáos......:" GET wTaxa  PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.Let(wValor:=wCarro+wTaxa)
      @ 10,02 SAY "Valor Total R$:" GET wValor PICT "@E 9,999,999.99" WHEN .F.
      @ 04,63 SAY "≥  5¶ PARCELA  ≥"
      @ 05,63 SAY "√ƒƒƒCH/Cartaoƒƒ¥"
      @ 06,63 SAY "≥              ≥"
      @ 07,63 SAY "≥Nß            ≥"
      @ 08,63 SAY "≥Dt:           ≥"
      @ 09,63 SAY "≥Bco.:         ≥"
      @ 10,63 SAY "≥Tit.:         ≥"
      @ 11,00 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
      @ 12,00 SAY "≥    ENTRADA R$   ≥  1¶ PARCELA  ≥  2¶ PARCELA  ≥  3¶ PARCELA  ≥  4¶ PARCELA  ≥"
      @ 13,00 SAY "√ƒƒDinƒƒƒ¬ƒCH/Carƒ≈ƒƒƒCH/Cartaoƒƒ≈ƒƒƒCH/Cartaoƒƒ≈ƒƒƒCH/Cartaoƒƒ≈ƒƒƒCH/Cartaoƒƒ¥"
      @ 14,00 SAY "≥        ≥        ≥              ≥              ≥              ≥              ≥"
      @ 15,00 SAY "√ƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
      @ 16,00 SAY "≥Nß               ≥Nß            ≥Nß            ≥Nß            ≥Nß            ≥"
      @ 17,00 SAY "≥Data:            ≥Dt:           ≥Dt:           ≥Dt:           ≥Dt:           ≥"
      @ 18,00 SAY "≥Bco.:            ≥Bco.:         ≥Bco.:         ≥Bco.:         ≥Bco.:         ≥"
      @ 19,00 SAY "≥Tit.:            ≥Tit.:         ≥Tit.:         ≥Tit.:         ≥Tit.:         ≥"
      @ 20,00 SAY "≥Svá.:                                                                        ≥"
      @ 21,00 SAY "≥Obs.:                                                                        ≥"
      @ 22,00 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
      @ 14,01 GET wValor_D  PICT "@E 9,999.99" VALID LASTKEY()#K_ESC
      @ 14,10 GET wValor_P1 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
      @ 16,05 GET wDoc1     PICT "@!"          WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
      @ 17,07 GET wDia1     PICT "@D"          WHEN wValor_P1#0.00.OR.wValor_D#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=cDtSys.AND.wDia1<=cDtSys+50
      @ 18,07 GET wBanco1   PICT "@!S10"       WHEN wValor_P1#0.00
      @ 19,07 GET wTit1     PICT "@!S10"       WHEN wValor_P1#0.00
      @ 14,22 GET wValor_P2 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,23 GET wDoc2     PICT "@!"          WHEN wValor_P2#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc2).AND.LASTKEY()#K_ESC
      @ 17,23 GET wDia2     PICT "@D"          WHEN wValor_P2#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia2).AND.wDia2>wDia1.AND.wDia2<=cDtSys+100
      @ 18,25 GET wBanco2   PICT "@!S7"        WHEN wValor_P2#0.00.AND.Let(wTit2:=wTit1)
      @ 19,25 GET wTit2     PICT "@!S7"        WHEN wValor_P2#0.00
      @ 14,38 GET wValor_P3 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,38 GET wDoc3     PICT "@!"          WHEN wValor_P3#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc3).AND.LASTKEY()#K_ESC
      @ 17,37 GET wDia3     PICT "@D"          WHEN wValor_P3#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia3).AND.wDia3>wDia2.AND.wDia3<=cDtSys+150
      @ 18,40 GET wBanco3   PICT "@!S7"        WHEN wValor_P3#0.00.AND.Let(wTit3:=wTit1)
      @ 19,40 GET wTit3     PICT "@!S7"        WHEN wValor_P3#0.00
      @ 14,53 GET wValor_P4 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,52 GET wDoc4     PICT "@!"          WHEN wValor_P4#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc4).AND.LASTKEY()#K_ESC
      @ 17,52 GET wDia4     PICT "@D"          WHEN wValor_P4#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia4).AND.wDia4>wDia3.AND.wDia4<=cDtSys+200
      @ 18,54 GET wBanco4   PICT "@!S7"        WHEN wValor_P4#0.00.AND.Let(wTit4:=wTit1)
      @ 19,54 GET wTit4     PICT "@!S7"        WHEN wValor_P4#0.00
      @ 14,67 GET wValor_P5 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,68 GET wDoc5     PICT "@!"          WHEN wValor_P5#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc5).AND.LASTKEY()#K_ESC
      @ 17,68 GET wDia5     PICT "@D"          WHEN wValor_P5#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia5).AND.wDia5>wDia4.AND.wDia5<=cDtSys+250
      @ 18,68 GET wBanco5   PICT "@!S7"        WHEN wValor_P5#0.00
      @ 19,68 GET wTit5     PICT "@!S7"        WHEN wValor_P5#0.00
      @ 06,67 GET wValor_P6 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 07,68 GET wDoc6     PICT "@!"          WHEN wValor_P6#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc6).AND.LASTKEY()#K_ESC
      @ 08,68 GET wDia6     PICT "@D"          WHEN wValor_P6#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia6).AND.wDia6>wDia5.AND.wDia6<=cDtSys+300
      @ 09,68 GET wBanco6   PICT "@!S7"        WHEN wValor_P6#0.00
      @ 10,68 GET wTit6     PICT "@!S7"        WHEN wValor_P6#0.00
      @ 20,07 GET wServico  PICT "@!S55"
      @ 21,07 GET wObs1     PICT "@!S55"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF ALLTRIM(STR((wValor_D+wValor_P1+wValor_P2+wValor_P3+wValor_P4+wValor_P5+wValor_P6)))#ALLTRIM(STR(wValor))
         Aviso("Valor diferencia do Total...",,3); LOOP
      ENDIF
      IF EMPTY(wValor_D).AND.EMPTY(wValor_P1)
         wDoc1:=SPACE(10); wBanco1:=SPACE(15)
      ENDIF
      IF EMPTY(wValor_P2)
         wDoc2:=SPACE(10); wBanco2:=SPACE(15); wDia2:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P3)
         wDoc3:=SPACE(10); wBanco3:=SPACE(15); wDia3:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P4)
         wDoc4:=SPACE(10); wBanco4:=SPACE(15); wDia4:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P5)
         wDoc5:=SPACE(10); wBanco5:=SPACE(15); wDia5:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P6)
         wDoc6:=SPACE(10); wBanco6:=SPACE(15); wDia6:=CTOD("")
      ENDIF

      wParcelas:=1
      IF (!EMPTY(wValor_D).AND.EMPTY(wValor_P1).AND.EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5))
      ELSEIF (!EMPTY(wValor_D).AND.EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
             .OR.(EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
             .OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5))
         wParcelas:=2
      ELSEIF (EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.EMPTY(wValor_P4).AND.EMPTY(wValor_P5))
         wParcelas:=3
      ELSEIF (EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.EMPTY(wValor_P5))
         wParcelas:=4
      ELSEIF (EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.!EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.!EMPTY(wValor_P5));
         .OR.(!EMPTY(wValor_D).AND.EMPTY(wValor_P1).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4).AND.!EMPTY(wValor_P5))
         wParcelas:=5
      ELSE
         wParcelas:=6
      ENDIF

      IF pValve
         WHILE !ALUNO->(NetLReg()); ENDDO
         REPLACE ALUNO->VALOR    WITH ALUNO->VALOR+wValor,;
                 ALUNO->AULAS    WITH ALUNO->AULAS+wAulas
*                 ALUNO->PENDENTE WITH ALUNO->PENDENTE+wAulas
         ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
      ENDIF
      FOR i= 1 TO wParcelas
         xVcto:=wDtInscr+(i*30-30)
         /* Movimento de Caixa - Entrada */
         IF !EMPTY(wValor_D).AND.!EMPTY(wValor_P1).AND.i=1
            FOR f = 1 TO 2
               xNLan:=GravaLan()

               // Registro de pagamento do caixa
               WHILE !CAIXA->(NetApp()); ENDDO
               REPLACE CAIXA->HIST   WITH "Matr."+ALUNO->NOME ,;
                       CAIXA->TIPO   WITH "C"                 ,;
                       CAIXA->NLAN   WITH xNLan,;
                       CAIXA->DTMOV  WITH cDtSys ,; //IF(f=1,cDtSys,IF(f=2,wDia2,wDia3)),;
                       CAIXA->DATA   WITH IF(f=1,wDia1,IF(f=2,wDia2,wDia3)),;
                       CAIXA->NF     WITH wNF,;
                       CAIXA->DOC    WITH IF(f=2,wDoc1,""),;
                       CAIXA->MATRIC WITH xMatric  ,;
                       CAIXA->VALOR  WITH IF(f=1,wValor_D,wValor_P1),;
                       CAIXA->VLR_D  WITH IF(f=1,wValor_D,0.00),;
                       CAIXA->VLR_C  WITH IF(f=1,0.00,wValor_P1),;
                       CAIXA->BANCO  WITH IF(f=2,wBanco1,""),;
                       CAIXA->SERV   WITH IF(f=2,wServico,""),;
                       CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                       CAIXA->USER   WITH cUsuario
               CAIXA->(DBCOMMIT())

               // Registro de pagamento de alunos
               WHILE !PAGAR->(NetApp()); ENDDO
               REPLACE PAGAR->MATRIC  WITH xMatric,;
                       PAGAR->PARCELA WITH "01",;
                       PAGAR->NOME    WITH wNome,;
                       PAGAR->NF      WITH wNF,;
                       PAGAR->NLAN    WITH xNLan,;
                       PAGAR->DOC     WITH IF(f=2,wDoc1,""),;
                       PAGAR->BANCO   WITH IF(f=2,wBanco1,""),;
                       PAGAR->TITULAR WITH IF(f=1,wTit1,IF(f=2,wTit2,IF(f=3,wTit3,IF(f=4,wTit4,wTit5)))),;
                       PAGAR->DTVCTO  WITH cDtSys,;
                       PAGAR->VALOR_C WITH IF(f=1,wValor_D,wValor_P1),;
                       PAGAR->DTPGTO  WITH IF(f=1.AND.!EMPTY(wValor_D),cDtSys,wDia1),;
                       PAGAR->VALOR_P WITH IF(f=1.AND.!EMPTY(wValor_D),wValor_D,wValor_P1),;
                       PAGAR->OBS1    WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                       PAGAR->OBS1    WITH IF(f=1.AND.!EMPTY(wValor_D),"EM ESPECIE","CH PRE-DATADO OU CARTAO")
               PAGAR->(DBCOMMIT())
            NEXT
         ELSE
            xNLan:=GravaLan()

            WHILE !CAIXA->(NetApp()); ENDDO
            REPLACE CAIXA->HIST   WITH "Matr."+ALUNO->NOME ,;
                    CAIXA->TIPO   WITH "C"                 ,;
                    CAIXA->NLAN   WITH xNLan,;
                    CAIXA->DTMOV  WITH IF(i=1,cDtSys,IF(i=2,wDia2,IF(i=3,wDia3,IF(i=4,wDia4,IF(i=5,wDia5,wDia6))))),;
                    CAIXA->DATA   WITH IF(i=1,wDia1,IF(i=2,wDia2,IF(i=3,wDia3,IF(i=4,wDia4,IF(i=5,wDia5,wDia6))))),;
                    CAIXA->NF     WITH wNF,;
                    CAIXA->DOC    WITH IF(i=1,wDoc1,IF(i=2,wDoc2,IF(i=3,wDoc3,IF(i=4,wDoc4,IF(i=5,wDoc5,wDoc6))))),;
                    CAIXA->VLR_D  WITH IF(!EMPTY(wValor_D).AND.i=1,wValor_D,0.00),;
                    CAIXA->VLR_C  WITH IF(i=1,wValor_P1,IF(i=2,wValor_P2,IF(i=3,wValor_P3,IF(i=4,wValor_P4,IF(i=5,wValor_P5,wValor_P6))))),;
                    CAIXA->MATRIC WITH xMatric  ,;
                    CAIXA->SERV   WITH IF(i=1,wServico,""),;
                    CAIXA->BANCO  WITH IF(i=1,wBanco1,IF(i=2,wBanco2,IF(i=3,wBanco3,IF(i=4,wBanco4,IF(i=5,wBanco5,wBanco6))))),;
                    CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                    CAIXA->USER   WITH cUsuario

            IF i==1.AND.wValor_D>0.00.AND.wValor_P1=0.00
               REPLACE CAIXA->VALOR WITH wValor_D
            ELSEIF i==1.AND.wValor_D=0.00.AND.wValor_P1>0.00
               REPLACE CAIXA->VALOR WITH wValor_P1
            ELSEIF i==1.AND.wValor_D>0.00.AND.wValor_P1>0.00
               REPLACE CAIXA->VALOR WITH wValor_D+wValor_P1
            ELSEIF i==2.AND.wValor_P2>0.00
               REPLACE CAIXA->VALOR WITH wValor_P2
            ELSEIF i==3.AND.wValor_P3>0.00
               REPLACE CAIXA->VALOR WITH wValor_P3
            ELSEIF i==4.AND.wValor_P4>0.00
               REPLACE CAIXA->VALOR WITH wValor_P4
            ELSEIF i==5.AND.wValor_P5>0.00
               REPLACE CAIXA->VALOR WITH wValor_P5
            ELSEIF i==6.AND.wValor_P6>0.00
               REPLACE CAIXA->VALOR WITH wValor_P6
            ENDIF
            CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())

            WHILE !PAGAR->(NetApp()); ENDDO
            REPLACE PAGAR->MATRIC  WITH wMatric,;
                    PAGAR->PARCELA WITH STRZERO(i,2),;
                    PAGAR->NF      WITH wNF,;
                    PAGAR->NOME    WITH wNome,;
                    PAGAR->NLAN    WITH xNLan,;
                    PAGAR->DOC     WITH IF(i==1,wDoc1,IF(i==2,wDoc2,IF(i==3,wDoc3,IF(i==4,wDoc4,IF(i==5,wDoc5,wDoc6))))),;
                    PAGAR->BANCO   WITH IF(i==1,wBanco1,IF(i==2,wBanco2,IF(i==3,wBanco3,IF(i==4,wBanco4,IF(i==5,wBanco5,wBanco6))))),;
                    PAGAR->TITULAR WITH IF(i==1,wTit1,IF(i=2,wTit2,IF(i=3,wTit3,IF(i=4,wTit4,IF(i=5,wTit5,wTit6))))),;
                    PAGAR->DTVCTO  WITH xVcto,;
                    PAGAR->VALOR_C WITH IF(i=1,wValor_P1,IF(i=2,wValor_P2,IF(i=3,wValor_P3,IF(i=4,wValor_P4,IF(i=5,wValor_P5,wValor_P6)))))
            IF i==1
               REPLACE PAGAR->DTPGTO  WITH wDia1,;
                       PAGAR->VALOR_P WITH wValor_P1+wValor_D,;
                       PAGAR->VALOR_D WITH wValor_D,;
                       PAGAR->OBS2    WITH wObs1,;
                       PAGAR->SERVICO WITH wServico
            ELSEIF i==2
               REPLACE PAGAR->DTPGTO  WITH wDia2,;
                       PAGAR->VALOR_P WITH wValor_P2,;
                       PAGAR->OBS2    WITH IF(SUBS(wDoc2,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO")
            ELSEIF i==3
               REPLACE PAGAR->DTPGTO  WITH wDia3,;
                       PAGAR->VALOR_P WITH wValor_P3,;
                       PAGAR->OBS2    WITH IF(SUBS(wDoc3,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO")
            ELSEIF i==4
               REPLACE PAGAR->DTPGTO  WITH wDia4,;
                       PAGAR->VALOR_P WITH wValor_P4,;
                       PAGAR->OBS2    WITH IF(SUBS(wDoc4,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO")
            ELSEIF i==5
               REPLACE PAGAR->DTPGTO  WITH wDia5,;
                       PAGAR->VALOR_P WITH wValor_P5,;
                       PAGAR->OBS2    WITH IF(SUBS(wDoc5,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO")
            ELSEIF i==6
               REPLACE PAGAR->DTPGTO  WITH wDia6,;
                       PAGAR->VALOR_P WITH wValor_P6,;
                       PAGAR->OBS2    WITH IF(SUBS(wDoc6,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO")
            ENDIF
            PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
         ENDIF
      NEXT
      IF Confirma("Imprime Recibo ?")
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpRecibo(xMatric)
            WHILE Confirma("Outra C¢pia ?")
               ImpRecibo(xMatric)
            ENDDO
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress∆o, tecle algo...")
         ENDIF
      ENDIF
      EXIT
   ENDDO
   RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Rotina de pagamento a vista   ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
PROCEDURE Avista(pValve)
   DEFAULT pValve TO .T.

   wParcelas:=0 ; wDia1 := cDtSys
   Telas(3,5,20,44,1,YCOREDIT,.T.,"Pagamento Ö Vista")
   WHILE .T.
      @ 04,07 SAY "Curso.........:" GET xCodCur PICT "99" WHEN TeclaFuncao(.T.) VALID Pesquisa(12,1,xCodCur,"C¢digo do Curso n∆o Localizado!");
             .AND.TDescr(12,1,4,26,xCodCur,"DESCR").AND.Let(wAulasT:=CURSO->TEORICA).AND.Let(wAulas:=CURSO->PRATICA)
      @ 05,07 SAY "Aulas Te¢ricas:" GET wAulasT PICT "99"
      @ 06,07 SAY "Aulas Pr†ticas:" GET wAulas  PICT "99"
      @ 07,07 SAY "Nota Fiscal...:" GET wNF
      @ 08,07 SAY "Carro p/Exame.:" GET wCarro PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.RCarro(wCarro)
      @ 09,07 SAY "Serviáos......:" GET wTaxa  PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.Let(wValor:=wCarro+wTaxa)
      @ 10,07 SAY "Vlr. Total R$.:" GET wValor PICT "@E 9,999,999.99" WHEN .F.
      @ 11,05 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
      @ 12,05 SAY "≥  Dinheiro  ≥    Cheque / Cartao      ≥"
      @ 13,05 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
      @ 14,05 SAY "≥R$          ≥R$         ≥Nß           ≥"
      @ 15,05 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
      @ 16,05 SAY "≥Banco:                                ≥"
      @ 17,05 SAY "≥Data :            Tit.:               ≥"
      @ 18,05 SAY "≥Svá:                                  ≥"
      @ 19,05 SAY "≥Obs:                                  ≥"
      @ 20,05 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
      @ 14,09 GET wValor_D  PICT "@E 9,999.99" VALID LASTKEY()#K_ESC
      @ 14,22 GET wValor_P1 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
      @ 14,34 GET wDoc1     PICT "@!"    WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
      @ 16,13 GET wBanco1   PICT "@!S31" WHEN wValor_P1#0.00
      @ 17,13 GET wDia1     PICT "@D"    WHEN wValor_P1#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=cDtSys.AND.wDia1<=cDtSys+45
      @ 17,30 GET wTit1     PICT "@!S13" WHEN wValor_P1#0.00
      @ 18,11 GET wServico  PICT "@!S33"
      @ 19,11 GET wObs1     PICT "@!S33"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF (wValor_D+wValor_P1)#wValor
         Aviso("Valor diferencia do Total...",,3); LOOP
      ENDIF
      IF Confirma("Confirma Pagamento ?")
         xNLan:=GravaLan()

         /* Movimento de Caixa */
         IF !EMPTY(wValor_D).AND.!EMPTY(wValor_P1)
            FOR f = 1 TO 2
               WHILE !CAIXA->(NetApp()); ENDDO
               REPLACE CAIXA->HIST   WITH "Matr."+ALUNO->NOME  ,;
                       CAIXA->TIPO   WITH "C"                  ,;
                       CAIXA->NLAN   WITH xNLan                ,;
                       CAIXA->DTMOV  WITH cDtSys               ,;
                       CAIXA->DATA   WITH wDia1                ,;
                       CAIXA->NF     WITH wNF                  ,;
                       CAIXA->DOC    WITH IF(f=2,wDoc1,"")     ,;
                       CAIXA->MATRIC WITH xMatric              ,;
                       CAIXA->VALOR  WITH IF(f=1,wValor_D,wValor_P1),;
                       CAIXA->VLR_D  WITH wValor_D             ,;
                       CAIXA->VLR_C  WITH wValor_P1            ,;
                       CAIXA->BANCO  WITH IF(f=2,wBanco1,"")   ,;
                       CAIXA->SERV   WITH IF(f=2,wServico,"")  ,;
                       CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DO CARRO PARA EXAME",wObs1),;
                       CAIXA->USER   WITH cUsuario
            NEXT
         ELSE
            WHILE !CAIXA->(NetApp()); ENDDO
            REPLACE CAIXA->HIST   WITH "Matr."+ALUNO->NOME ,;
                    CAIXA->DOC    WITH wDoc1               ,;
                    CAIXA->NF     WITH wNF                 ,;
                    CAIXA->TIPO   WITH "C"                 ,;
                    CAIXA->NLAN   WITH xNLan               ,;
                    CAIXA->DTMOV  WITH cDtSys              ,;
                    CAIXA->DATA   WITH wDia1               ,;
                    CAIXA->VALOR  WITH wValor_D+wValor_P1  ,;
                    CAIXA->VLR_D  WITH wValor_D            ,;
                    CAIXA->VLR_C  WITH wValor_P1           ,;
                    CAIXA->BANCO  WITH wBanco1             ,;
                    CAIXA->SERV   WITH wServico            ,;
                    CAIXA->MATRIC WITH xMatric             ,;
                    CAIXA->USER   WITH cUsuario            ,;
                    CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DO CARRO PARA EXAME",wObs1)
         ENDIF
         CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())

         WHILE !ALUNO->(NetLReg()); ENDDO
         REPLACE ALUNO->VALOR    WITH ALUNO->VALOR+wValor,;
                 ALUNO->AULAS    WITH ALUNO->AULAS+wAulas,;
                 ALUNO->PENDENTE WITH ALUNO->PENDENTE+wAulas
         ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
         WHILE !PAGAR->(NetApp()); ENDDO
         REPLACE PAGAR->MATRIC  WITH wMatric,;
                 PAGAR->PARCELA WITH "01",;
                 PAGAR->NOME    WITH wNome,;
                 PAGAR->NF      WITH wNF  ,;
                 PAGAR->DOC     WITH wDoc1,;
                 PAGAR->BANCO   WITH wBanco1,;
                 PAGAR->TITULAR WITH wTit1,;
                 PAGAR->DTPGTO  WITH cDtSys,;
                 PAGAR->DTVCTO  WITH wDia1,;
                 PAGAR->VALOR_D WITH wValor_D,;
                 PAGAR->VALOR_C WITH wValor_P1,;
                 PAGAR->VALOR_P WITH wValor_D+wValor_P1,;
                 PAGAR->NLAN    WITH xNLan,;
                 PAGAR->OBS1    WITH wObs1,;
                 PAGAR->SERVICO WITH wServico
         PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
         IF Confirma("Imprime Recibo ?")
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpRecibo(wMatric)
               WHILE Confirma("Outra C¢pia do Recibo ?")
                  ImpRecibo(wMatric)
               ENDDO
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impress∆o, tecle algo...")
            ENDIF
         ENDIF
         EXIT
      ENDIF
   ENDDO
   RETURN
