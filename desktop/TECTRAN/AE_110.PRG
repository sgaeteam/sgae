*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
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
IF NetUse("DBPAG","PAGAR")            /*Pagamentos de Alunos */
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
PUBLIC xVeiculo:=SPACE(3); xDtPrev:=xDtPrev1:=cDtSys; xHora:=xHora1:=SPACE(4)
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

               /* Inicializacao Variaveis */
               wValor_P1:=wValor_P2:=wValor_P3:=wValor_P4:=wValor_P5:=wValor_P6:=;
               wValor_P7:=wValor_P8:=wValor_P9:=wValor_P10:=wValor_P11:=;
               wValor_D:=wCarro:=wTaxa:=0.00
               wDoc1:=wDoc2:=wDoc3:=wDoc4:=wDoc5:=wDoc6:=;
               wDoc7:=wDoc8:=wDoc9:=wDoc10:=wDoc11:=SPACE(10)
               wBanco1:=wBanco2:=wBanco3:=wBanco4:=wBanco5:=wBanco6:=;
               wBanco7:=wBanco8:=wBanco9:=wBanco10:=wBanco11:=SPACE(15)
               wdia1:=cDtSys; wdia2:=wdia3:=wDia4:=wDia5:=wDia6:=;
               wdia7:=wdia8:=wdia9:=wDia10:=wDia11:=CTOD("")
               wTit1:=wTit2:=wTit3:=wTit4:=wTit5:=wTit6:=;
               wTit7:=wTit8:=wTit9:=wTit10:=wTit11:=SPACE(25)
               xCodCur:=SPACE(2); wOptou:=" "; wAulasT:=0
               wObs1:=SPACE(67); wServico:=SPACE(50); wNF:=SPACE(6)

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
                     ImpContrato(xCodCur)
                     WHILE Confirma("Outra C¢pia do Contrato ?")
                        ImpContrato(xCodCur)
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
*              KEYB CHR(4)+CHR(13)
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
   Cab_ESC(1,05,"E.Civil..:")
   Cab_ESC(0,16,IF(ALUNO->CIVIL="S","SOLTEIRO",IF(ALUNO->CIVIL="C","CASADO",IF(ALUNO->CIVIL="D","DESQUITADO",IF(ALUNO->CIVIL="V","VIUVO","NAO INFORMADO")))))
   Cab_ESC(1,05,"E-MAIL...:")
   Cab_ESC(0,16,ALUNO->EMAIL)
   Cab_ESC(1,05,"FONE RES.:")
   Cab_ESC(0,16,ALUNO->FONE_R,"[@R (99) 9999-9999]")
   Cab_ESC(1,35,"FONE COM.:")
   Cab_ESC(0,46,ALUNO->FONE_C,"[@R (99) 9999-9999]")
   Cab_ESC(1,05,"FONE CEL.:")
   Cab_ESC(0,16,ALUNO->CELULAR,"[@R (99) 9999-9999]")
   Cab_ESC(1,35,"RECADOS..:")
   Cab_ESC(0,46,ALUNO->CONTATO)
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
         ELSEIF SUBS(wDoc6,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P6,7,2)+" No. "+SUBS(wDoc6,3)+" "+wBanco6+" "+DTOC(wDia6)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P6,7,2)+" No. "+wDoc6+" "+wBanco6+" "+DTOC(wDia6)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc7)
         IF SUBS(wDoc7,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P7,7,2)+" Autorizaá∆o No. "+SUBS(wDoc7,2)+" "+wBanco7
         ELSEIF SUBS(wDoc7,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P7,7,2)+" No. "+SUBS(wDoc7,3)+" "+wBanco7+" "+DTOC(wDia7)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P7,7,2)+" No. "+wDoc7+" "+wBanco7+" "+DTOC(wDia7)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc8)
         IF SUBS(wDoc8,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P8,7,2)+" Autorizaá∆o No. "+SUBS(wDoc8,2)+" "+wBanco8
         ELSEIF SUBS(wDoc8,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P8,7,2)+" No. "+SUBS(wDoc8,3)+" "+wBanco8+" "+DTOC(wDia8)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P8,7,2)+" No. "+wDoc8+" "+wBanco8+" "+DTOC(wDia8)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc9)
         IF SUBS(wDoc9,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P9,7,2)+" Autorizaá∆o No. "+SUBS(wDoc9,2)+" "+wBanco9
         ELSEIF SUBS(wDoc9,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P9,7,2)+" No. "+SUBS(wDoc9,3)+" "+wBanco9+" "+DTOC(wDia9)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P9,7,2)+" No. "+wDoc9+" "+wBanco9+" "+DTOC(wDia9)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc10)
         IF SUBS(wDoc10,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P10,7,2)+" Autorizaá∆o No. "+SUBS(wDoc10,2)+" "+wBanco10
         ELSEIF SUBS(wDoc10,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P10,7,2)+" No. "+SUBS(wDoc10,3)+" "+wBanco10+" "+DTOC(wDia10)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P10,7,2)+" No. "+wDoc10+" "+wBanco10+" "+DTOC(wDia10)
         ENDIF
      ENDIF
      IF !EMPTY(wDoc11)
         IF SUBS(wDoc11,1,1)=="A"
            @ PROW()+2,10 SAY "-> Cart∆o Credito R$ "+STR(wValor_P11,7,2)+" Autorizaá∆o No. "+SUBS(wDoc11,2)+" "+wBanco11
         ELSEIF SUBS(wDoc11,1,2)=="NP"
            @ PROW()+2,10 SAY "-> Nota Promiss.  R$ "+STR(wValor_P11,7,2)+" No. "+SUBS(wDoc11,3)+" "+wBanco11+" "+DTOC(wDia11)
         ELSE
            @ PROW()+2,10 SAY "-> Cheque PrÇ     R$ "+STR(wValor_P11,7,2)+" No. "+wDoc11+" "+wBanco10+" "+DTOC(wDia11)
         ENDIF
      ENDIF
   ENDIF
   RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Rotina de Pagamento Parcelado ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
PROCEDURE Parcelamento(pValve)
   DEFAULT pValve TO .T.
   Telas(3,0,22,78,1,YCOREDIT,.T.,"Parcelamento")
   @ 06,00 SAY "√"+REPL("ƒ",77)+"¥"
   @ 19,00 SAY "√"+REPL("ƒ",77)+"¥"

   WHILE .T.
      @ 04,02 SAY "Curso               Te¢ricas  Pr†ticas  nß NF   Exame   Serviáos  Total R$"
*     @ 05,02 SAY "xxxxxxxxxxXXXXXXXXXX   99       99      999999  999,99  99999,99  999999,99"
*                  2345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7
      @ 04,09 GET xCodCur PICT "99" WHEN TeclaFuncao(.T.) VALID Pesquisa(12,1,xCodCur,"C¢digo do Curso n∆o Localizado!");
              .AND.TDescr(12,1,5,00,xCodCur,"DESCR").AND.Let(wAulasT:=CURSO->TEORICA).AND.Let(wAulas:=CURSO->PRATICA)
      @ 05,25 GET wAulasT PICT "99"
      @ 05,34 GET wAulas  PICT "99"
      @ 05,42 GET wNF
      @ 05,50 GET wCarro PICT "@E 999.99" VALID LASTKEY()==K_UP.OR.RCarro(wCarro)
      @ 05,58 GET wTaxa  PICT "@E 999999.99" VALID LASTKEY()==K_UP.OR.Let(wValor:=wCarro+wTaxa)
      @ 05,68 GET wValor PICT "@E 999999.99" WHEN .F.

      @ 07,02 SAY "Parc. EspÇcie CH/Cart. Doc.       Data       Bco/Adm    Titular (terceiros)"
*     @ 07,02 SAY "..... 999,999 999,999  xxxxxxxxxx 99/99/9999 xxxxxxxxxx xxxxxxxxxx
*                  2345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7
      @ 08,02 SAY "Ent:"
      @ 09,02 SAY "1¶ :"
      @ 10,02 SAY "2¶ :"
      @ 11,02 SAY "3¶ :"
      @ 12,02 SAY "4¶ :"
      @ 13,02 SAY "5¶ :"
      @ 14,02 SAY "6¶ :"
      @ 15,02 SAY "7¶ :"
      @ 16,02 SAY "8¶ :"
      @ 17,02 SAY "9¶ :"
      @ 18,02 SAY "10¶:"
      @ 20,02 SAY "Serviáo:                                                                      ≥"
      @ 21,02 SAY "Obs....:                                                                      ≥"

      @ 08,08 GET wValor_D  PICT "@E 9999.99" VALID LASTKEY()#K_ESC
      @ 08,16 GET wValor_P1 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
      @ 08,25 GET wDoc1     PICT "@!"         WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
      @ 08,36 GET wDia1     PICT "@D"         WHEN wValor_P1#0.00.OR.wValor_D#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=cDtSys.AND.wDia1<=cDtSys+50
      @ 08,47 GET wBanco1   PICT "@!S10"      WHEN wValor_P1#0.00
      @ 08,58 GET wTit1     PICT "@!S15"      WHEN wValor_P1#0.00

      @ 09,16 GET wValor_P2 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 09,25 GET wDoc2     PICT "@!"         WHEN wValor_P2#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc2).AND.LASTKEY()#K_ESC
      @ 09,36 GET wDia2     PICT "@D"         WHEN wValor_P2#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia2).AND.wDia2>wDia1.AND.wDia2<=cDtSys+100.AND.Let(wBanco2:=wBanco1)
      @ 09,47 GET wBanco2   PICT "@!S10"      WHEN wValor_P2#0.00.AND.Let(wTit2:=wTit1)
      @ 09,58 GET wTit2     PICT "@!S15"      WHEN wValor_P2#0.00

      @ 10,16 GET wValor_P3 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 10,25 GET wDoc3     PICT "@!"         WHEN wValor_P3#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc3).AND.LASTKEY()#K_ESC
      @ 10,36 GET wDia3     PICT "@D"         WHEN wValor_P3#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia3).AND.wDia3>wDia2.AND.wDia3<=cDtSys+150.AND.Let(wBanco3:=wBanco2)
      @ 10,47 GET wBanco3   PICT "@!S10"      WHEN wValor_P3#0.00.AND.Let(wTit3:=wTit1)
      @ 10,58 GET wTit3     PICT "@!S15"      WHEN wValor_P3#0.00

      @ 11,16 GET wValor_P4 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 11,25 GET wDoc4     PICT "@!"         WHEN wValor_P4#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc4).AND.LASTKEY()#K_ESC
      @ 11,36 GET wDia4     PICT "@D"         WHEN wValor_P4#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia4).AND.wDia4>wDia3.AND.wDia4<=cDtSys+200.AND.Let(wBanco4:=wBanco3)
      @ 11,47 GET wBanco4   PICT "@!S10"      WHEN wValor_P4#0.00.AND.Let(wTit4:=wTit1)
      @ 11,58 GET wTit4     PICT "@!S15"      WHEN wValor_P4#0.00

      @ 12,16 GET wValor_P5 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 12,25 GET wDoc5     PICT "@!"         WHEN wValor_P5#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc5).AND.LASTKEY()#K_ESC
      @ 12,36 GET wDia5     PICT "@D"         WHEN wValor_P5#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia5).AND.wDia5>wDia4.AND.wDia5<=cDtSys+250.AND.Let(wBanco5:=wBanco4)
      @ 12,47 GET wBanco5   PICT "@!S10"      WHEN wValor_P5#0.00.AND.Let(wTit5:=wTit1)
      @ 12,58 GET wTit5     PICT "@!S15"      WHEN wValor_P5#0.00

      @ 13,16 GET wValor_P6 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 13,25 GET wDoc6     PICT "@!"         WHEN wValor_P6#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc6).AND.LASTKEY()#K_ESC
      @ 13,36 GET wDia6     PICT "@D"         WHEN wValor_P6#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia6).AND.wDia6>wDia5.AND.wDia6<=cDtSys+300.AND.Let(wBanco6:=wBanco5)
      @ 13,47 GET wBanco6   PICT "@!S10"      WHEN wValor_P6#0.00.AND.Let(wTit6:=wTit1)
      @ 13,58 GET wTit6     PICT "@!S15"      WHEN wValor_P6#0.00

      @ 14,16 GET wValor_P7 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 14,25 GET wDoc7     PICT "@!"         WHEN wValor_P7#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc7).AND.LASTKEY()#K_ESC
      @ 14,36 GET wDia7     PICT "@D"         WHEN wValor_P7#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia7).AND.wDia7>wDia6.AND.wDia7<=cDtSys+350.AND.Let(wBanco7:=wBanco6)
      @ 14,47 GET wBanco7   PICT "@!S10"      WHEN wValor_P7#0.00.AND.Let(wTit7:=wTit1)
      @ 14,58 GET wTit7     PICT "@!S15"      WHEN wValor_P7#0.00

      @ 15,16 GET wValor_P8 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 15,25 GET wDoc8     PICT "@!"         WHEN wValor_P8#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc8).AND.LASTKEY()#K_ESC
      @ 15,36 GET wDia8     PICT "@D"         WHEN wValor_P8#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia8).AND.wDia8>wDia7.AND.wDia8<=cDtSys+400.AND.Let(wBanco8:=wBanco7)
      @ 15,47 GET wBanco8   PICT "@!S10"      WHEN wValor_P8#0.00.AND.Let(wTit8:=wTit1)
      @ 15,58 GET wTit8     PICT "@!S15"      WHEN wValor_P8#0.00
                                            
      @ 16,16 GET wValor_P9 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,25 GET wDoc9     PICT "@!"         WHEN wValor_P9#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc9).AND.LASTKEY()#K_ESC
      @ 16,36 GET wDia9     PICT "@D"         WHEN wValor_P9#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia9).AND.wDia9>wDia8.AND.wDia9<=cDtSys+450.AND.Let(wBanco9:=wBanco8)
      @ 16,47 GET wBanco9   PICT "@!S10"      WHEN wValor_P9#0.00.AND.Let(wTit9:=wTit1)
      @ 16,58 GET wTit9     PICT "@!S15"      WHEN wValor_P9#0.00

      @ 17,16 GET wValor_P10 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 17,25 GET wDoc10     PICT "@!"         WHEN wValor_P10#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc10).AND.LASTKEY()#K_ESC
      @ 17,36 GET wDia10     PICT "@D"         WHEN wValor_P10#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia10).AND.wDia10>wDia9.AND.wDia10<=cDtSys+500.AND.Let(wBanco10:=wBanco9)
      @ 17,47 GET wBanco10   PICT "@!S10"      WHEN wValor_P10#0.00.AND.Let(wTit10:=wTit1)
      @ 17,58 GET wTit10     PICT "@!S15"      WHEN wValor_P10#0.00

      @ 18,16 GET wValor_P11 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 18,25 GET wDoc11     PICT "@!"         WHEN wValor_P11#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc11).AND.LASTKEY()#K_ESC
      @ 18,36 GET wDia11     PICT "@D"         WHEN wValor_P11#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia11).AND.wDia11>wDia10.AND.wDia11<=cDtSys+550.AND.Let(wBanco11:=wBanco10)
      @ 18,47 GET wBanco11   PICT "@!S10"      WHEN wValor_P11#0.00.AND.Let(wTit11:=wTit1)
      @ 18,58 GET wTit11     PICT "@!S15"      WHEN wValor_P11#0.00

      @ 20,10 GET wServico  PICT "@!S45"
      @ 21,10 GET wObs1     PICT "@!S45"
      SETCURSOR(1); READ; SETCURSOR(0)
      IF ALLTRIM(STR((wValor_D+wValor_P1+wValor_P2+wValor_P3+wValor_P4+wValor_P5+wValor_P6+wValor_P7+wValor_P8+wValor_P9+wValor_P10+wValor_P11)))#ALLTRIM(STR(wValor))
         Aviso("Valor diferencia do Total...",,3); LOOP
      ENDIF
      IF EMPTY(wValor_D).AND.EMPTY(wValor_P1)
         wDoc1:=SPACE(10); wBanco1:=SPACE(15)
      ELSE
         wParcelas:=1
      ENDIF
      IF EMPTY(wValor_P2)
         wDoc2:=SPACE(10); wBanco2:=SPACE(15); wDia2:=CTOD("")
      ELSE
         wParcelas:=2
      ENDIF
      IF EMPTY(wValor_P3)
         wDoc3:=SPACE(10); wBanco3:=SPACE(15); wDia3:=CTOD("")
      ELSE
         wParcelas:=3
      ENDIF
      IF EMPTY(wValor_P4)
         wDoc4:=SPACE(10); wBanco4:=SPACE(15); wDia4:=CTOD("")
      ELSE
         wParcelas:=4
      ENDIF
      IF EMPTY(wValor_P5)
         wDoc5:=SPACE(10); wBanco5:=SPACE(15); wDia5:=CTOD("")
      ELSE
         wParcelas:=5
      ENDIF
      IF EMPTY(wValor_P6)
         wDoc6:=SPACE(10); wBanco6:=SPACE(15); wDia6:=CTOD("")
      ELSE
         wParcelas:=6
      ENDIF
      IF EMPTY(wValor_P7)
         wDoc7:=SPACE(10); wBanco7:=SPACE(15); wDia7:=CTOD("")
      ELSE
         wParcelas:=7
      ENDIF
      IF EMPTY(wValor_P8)
         wDoc8:=SPACE(10); wBanco8:=SPACE(15); wDia8:=CTOD("")
      ELSE
         wParcelas:=8
      ENDIF
      IF EMPTY(wValor_P9)
         wDoc9:=SPACE(10); wBanco9:=SPACE(15); wDia9:=CTOD("")
      ELSE
         wParcelas:=9
      ENDIF
      IF EMPTY(wValor_P10)
         wDoc10:=SPACE(10); wBanco10:=SPACE(15); wDia10:=CTOD("")
      ELSE
         wParcelas:=10
      ENDIF
      IF EMPTY(wValor_P11)
         wDoc11:=SPACE(10); wBanco11:=SPACE(15); wDia11:=CTOD("")
      ELSE
      wParcelas:=11
      ENDIF

      IF pValve
         WHILE !ALUNO->(NetLReg()); ENDDO
         REPLACE ALUNO->VALOR    WITH ALUNO->VALOR+wValor,;
                 ALUNO->AULAS    WITH ALUNO->AULAS+wAulas
*                 ALUNO->PENDENTE WITH ALUNO->PENDENTE+wAulas
         ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
      ENDIF

      // Registro de Pagamento parcelado
      RegPagParc()

      IF pValve
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
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Rotina de pagamento parcelado ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
PROCEDURE RegPagParc(pValve)
   FOR i = 1 TO wParcelas
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
                 CAIXA->NF     WITH wNF,;
                 CAIXA->MATRIC WITH xMatric  ,;
                 CAIXA->SERV   WITH IF(i=1,wServico,""),;
                 CAIXA->USER   WITH cUsuario,;
                 CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                 CAIXA->VLR_D  WITH IF(!EMPTY(wValor_D).AND.i=1,wValor_D,0.00)

         IF i == 1
            REPLACE CAIXA->DTMOV WITH cDtSys    ,;
                    CAIXA->DATA  WITH wDia1     ,;
                    CAIXA->DOC   WITH wDoc1     ,;
                    CAIXA->VLR_C WITH wValor_P1 ,;
                    CAIXA->BANCO WITH wBanco1

            IF wValor_D>0.00.AND.wValor_P1=0.00
               REPLACE CAIXA->VALOR WITH wValor_D
            ELSEIF wValor_D=0.00.AND.wValor_P1>0.00
               REPLACE CAIXA->VALOR WITH wValor_P1
            ELSEIF wValor_D>0.00.AND.wValor_P1>0.00
               REPLACE CAIXA->VALOR WITH wValor_D+wValor_P1
            ENDIF
         ELSEIF i == 2
            REPLACE CAIXA->DTMOV WITH wDia2     ,;
                    CAIXA->DATA  WITH wDia2     ,;
                    CAIXA->DOC   WITH wDoc2     ,;
                    CAIXA->VLR_C WITH wValor_P2 ,;
                    CAIXA->BANCO WITH wBanco2   ,;
                    CAIXA->VALOR WITH wValor_P2
         ELSEIF i == 3
            REPLACE CAIXA->DTMOV WITH wDia3     ,;
                    CAIXA->DATA  WITH wDia3     ,;
                    CAIXA->DOC   WITH wDoc3     ,;
                    CAIXA->VLR_C WITH wValor_P3 ,;
                    CAIXA->BANCO WITH wBanco3   ,;
                    CAIXA->VALOR WITH wValor_P3
         ELSEIF i == 4
            REPLACE CAIXA->DTMOV WITH wDia4     ,;
                    CAIXA->DATA  WITH wDia4     ,;
                    CAIXA->DOC   WITH wDoc4     ,;
                    CAIXA->VLR_C WITH wValor_P4 ,;
                    CAIXA->BANCO WITH wBanco4   ,;
                    CAIXA->VALOR WITH wValor_P4
         ELSEIF i == 5
            REPLACE CAIXA->DTMOV WITH wDia5     ,;
                    CAIXA->DATA  WITH wDia5     ,;
                    CAIXA->DOC   WITH wDoc5     ,;
                    CAIXA->VLR_C WITH wValor_P5 ,;
                    CAIXA->BANCO WITH wBanco5   ,;
                    CAIXA->VALOR WITH wValor_P5
         ELSEIF i == 6
            REPLACE CAIXA->DTMOV WITH wDia6     ,;
                    CAIXA->DATA  WITH wDia6     ,;
                    CAIXA->DOC   WITH wDoc6     ,;
                    CAIXA->VLR_C WITH wValor_P6 ,;
                    CAIXA->BANCO WITH wBanco6   ,;
                    CAIXA->VALOR WITH wValor_P6
         ELSEIF i == 7
            REPLACE CAIXA->DTMOV WITH wDia7     ,;
                    CAIXA->DATA  WITH wDia7     ,;
                    CAIXA->DOC   WITH wDoc7     ,;
                    CAIXA->VLR_C WITH wValor_P7 ,;
                    CAIXA->BANCO WITH wBanco7   ,;
                    CAIXA->VALOR WITH wValor_P7
         ELSEIF i == 8
            REPLACE CAIXA->DTMOV WITH wDia8     ,;
                    CAIXA->DATA  WITH wDia8     ,;
                    CAIXA->DOC   WITH wDoc8     ,;
                    CAIXA->VLR_C WITH wValor_P8 ,;
                    CAIXA->BANCO WITH wBanco8   ,;
                    CAIXA->VALOR WITH wValor_P8
         ELSEIF i == 9
            REPLACE CAIXA->DTMOV WITH wDia9     ,;
                    CAIXA->DATA  WITH wDia9     ,;
                    CAIXA->DOC   WITH wDoc9     ,;
                    CAIXA->VLR_C WITH wValor_P9 ,;
                    CAIXA->BANCO WITH wBanco9   ,;
                    CAIXA->VALOR WITH wValor_P9
         ELSEIF i == 10
            REPLACE CAIXA->DTMOV WITH wDia10    ,;
                    CAIXA->DATA  WITH wDia10    ,;
                    CAIXA->DOC   WITH wDoc10    ,;
                    CAIXA->VLR_C WITH wValor_P10,;
                    CAIXA->BANCO WITH wBanco10  ,;
                    CAIXA->VALOR WITH wValor_P10
         ELSEIF i == 11
            REPLACE CAIXA->DTMOV WITH wDia11    ,;
                    CAIXA->DATA  WITH wDia11    ,;
                    CAIXA->DOC   WITH wDoc11    ,;
                    CAIXA->VLR_C WITH wValor_P11,;
                    CAIXA->BANCO WITH wBanco11  ,;
                    CAIXA->VALOR WITH wValor_P11
         ENDIF
         CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())

         WHILE !PAGAR->(NetApp()); ENDDO
         REPLACE PAGAR->MATRIC  WITH wMatric        ,;
                 PAGAR->PARCELA WITH STRZERO(i-1,2) ,;
                 PAGAR->NF      WITH wNF            ,;
                 PAGAR->NOME    WITH wNome          ,;
                 PAGAR->NLAN    WITH xNLan          ,;
                 PAGAR->DTVCTO  WITH xVcto
         IF i==1
            REPLACE PAGAR->DTPGTO  WITH wDia1                 ,;
                    PAGAR->VALOR_P WITH wValor_P1+wValor_D    ,;
                    PAGAR->VALOR_D WITH wValor_D              ,;
                    PAGAR->OBS2    WITH wObs1                 ,;
                    PAGAR->SERVICO WITH wServico              ,;
                    PAGAR->DOC     WITH wDoc1                 ,;
                    PAGAR->BANCO   WITH wBanco1               ,;
                    PAGAR->TITULAR WITH wTit1                 ,;
                    PAGAR->VALOR_C WITH wValor_P1

         ELSEIF i==2
            REPLACE PAGAR->DTPGTO  WITH wDia2,;
                    PAGAR->VALOR_P WITH wValor_P2,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc2,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc2   ,;
                    PAGAR->BANCO   WITH wBanco2 ,;
                    PAGAR->TITULAR WITH wTit2   ,;
                    PAGAR->VALOR_C WITH wValor_P2
         ELSEIF i==3
            REPLACE PAGAR->DTPGTO  WITH wDia3,;
                    PAGAR->VALOR_P WITH wValor_P3,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc3,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc3   ,;
                    PAGAR->BANCO   WITH wBanco3 ,;
                    PAGAR->TITULAR WITH wTit3   ,;
                    PAGAR->VALOR_C WITH wValor_P3
         ELSEIF i==4
            REPLACE PAGAR->DTPGTO  WITH wDia4     ,;
                    PAGAR->VALOR_P WITH wValor_P4 ,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc4,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc4     ,;
                    PAGAR->BANCO   WITH wBanco4   ,;
                    PAGAR->TITULAR WITH wTit4     ,;
                    PAGAR->VALOR_C WITH wValor_P4
         ELSEIF i==5
            REPLACE PAGAR->DTPGTO  WITH wDia5,;
                    PAGAR->VALOR_P WITH wValor_P5,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc5,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc5   ,;
                    PAGAR->BANCO   WITH wBanco5 ,;
                    PAGAR->TITULAR WITH wTit5   ,;
                    PAGAR->VALOR_C WITH wValor_P5
         ELSEIF i==6
            REPLACE PAGAR->DTPGTO  WITH wDia6,;
                    PAGAR->VALOR_P WITH wValor_P6,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc6,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc6   ,;
                    PAGAR->BANCO   WITH wBanco6 ,;
                    PAGAR->TITULAR WITH wTit6   ,;
                    PAGAR->VALOR_C WITH wValor_P6
         ELSEIF i==7
            REPLACE PAGAR->DTPGTO  WITH wDia7,;
                    PAGAR->VALOR_P WITH wValor_P7,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc7,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc7   ,;
                    PAGAR->BANCO   WITH wBanco7 ,;
                    PAGAR->TITULAR WITH wTit7   ,;
                    PAGAR->VALOR_C WITH wValor_P7
         ELSEIF i==8
            REPLACE PAGAR->DTPGTO  WITH wDia8,;
                    PAGAR->VALOR_P WITH wValor_P8,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc8,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc8   ,;
                    PAGAR->BANCO   WITH wBanco8 ,;
                    PAGAR->TITULAR WITH wTit8   ,;
                    PAGAR->VALOR_C WITH wValor_P8
         ELSEIF i==9
            REPLACE PAGAR->DTPGTO  WITH wDia9,;
                    PAGAR->VALOR_P WITH wValor_P9,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc9,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc9   ,;
                    PAGAR->BANCO   WITH wBanco9 ,;
                    PAGAR->TITULAR WITH wTit9   ,;
                    PAGAR->VALOR_C WITH wValor_P9
         ELSEIF i==10
            REPLACE PAGAR->DTPGTO  WITH wDia10      ,;
                    PAGAR->VALOR_P WITH wValor_P10  ,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc10,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc10      ,;
                    PAGAR->BANCO   WITH wBanco10    ,;
                    PAGAR->TITULAR WITH wTit10      ,;
                    PAGAR->VALOR_C WITH wValor_P10
         ELSEIF i==11
            REPLACE PAGAR->DTPGTO  WITH wDia11,;
                    PAGAR->VALOR_P WITH wValor_P11,;
                    PAGAR->OBS2    WITH IF(SUBS(wDoc11,1,1)="A","CARTAO DE CREDITO","CHEQUE PRE-DATADO"),;
                    PAGAR->DOC     WITH wDoc11   ,;
                    PAGAR->BANCO   WITH wBanco11 ,;
                    PAGAR->TITULAR WITH wTit11   ,;
                    PAGAR->VALOR_C WITH wValor_P11
         ENDIF
         PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
      ENDIF
   NEXT
   RETURN
