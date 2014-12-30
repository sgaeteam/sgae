*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_241                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Recebimento de Servi‡os                  ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 27/11/1997                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
SELECT 14
IF NetUse("DBVEIC","VEICULO")        /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF VEICULO->(EOF())
   Aviso("Vocˆ precisa definir cadastrando os ve¡culos primeiro",,3)
   DBCLOSEALL(); RETURN
ENDIF

SELECT 9
IF NetUse("DBEXAM","EXAME")          /* Exames de Dire‡ao */
   SET INDEX TO DBIEXAM1, DBIEXAM2,DBIEXAM3, DBIEXAM4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBPEND","PENDENCIA")      /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 8
IF NetUse("DBREQ","REQ")             /* Requerimentos */
   SET INDEX TO DBIREQ1
ELSE
   RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")            /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF !NetUse("DBPARM")                 /* Parametros */
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Pagamentos de Alunos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

zTela:=LEN(Telas)
cPrg:="AE241";ProgName("AE241"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "41"
SET KEY -1 TO Mostra()
wData:=CTOD(""); wMatric:=SPACE(5); wResp:=" "
PUBLIC xVeiculo:=SPACE(3); xDtPrev:=xDtPrev1:=cDtSys; xHora:=xHora1:=SPACE(4)
WHILE .T.
   wNome:=SPACE(50)
   SETCOLOR(YCOREDIT)
   Telas(2,1,22,78,1,YCOREDIT,.T.,"Pagamento de Servi‡os")
   @ 03,02 SAY "Aluno ? (S/N)" GET wResp PICT "!" VALID wResp $ "SN"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   IF wResp=="N"
      @ 04,02 SAY "Nome:" GET wNome PICT "@!" VALID !EMPTY(wNome)
   ELSE
      Mensagem("Informe Matr¡cula do Aluno")
      @ 04,02 SAY "Matr¡cula:" GET wMatric PICT "99999" WHEN TeclaFuncao(.T.);
        VALID TDescr(3,1,4,17,wMatric,"NOME",["@S40"],"Aluno NÆo Localizado")
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF wResp=="S"
      wNome:=ALUNO->NOME
      ChkPend(wMatric)  // Verifica pendencia diversas
      ChkPReq(wMatric)  // Verifica pendencia de requerimento
   ENDIF
   wCarro:=wTaxa:=wLaudo:=wValor:=wReexa:=wTransf:=wOutros:=wManual:=wAulasT:=0.00
   wObs1:=SPACE(67); wServico:=wTipo:=SPACE(50);wOptou:=" "; wDtInscr:=cDtSys
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
   wTit7:=wTit8:=wTit9:=wTit10:=wTit11:=SPACE(25); wNF:=SPACE(6)
   xMatric:=wMatric

   WHILE .T.
      @ 06,02 SAY "Laudo Reexame Aluguel Manual Renov. 2¦ Via Outros Descri‡Æo       Total R$"
*                  9,999 9,999   9,999   999    9,999  999    9,999  XXXXXXXXXXxxxxx 99,999"
*                  2345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7
      @ 07,02 GET wLaudo  PICT "@E 9,999"
      @ 07,08 GET wReexa  PICT "@E 9,999"  WHEN TeclaFuncao()
      @ 07,16 GET wCarro  PICT "@E 9,999"  WHEN TeclaFuncao(.T.) VALID LASTKEY()==K_UP.OR.RCarro(wCarro,.T.)
      @ 07,24 GET wManual PICT "@E 999"
      @ 07,31 GET wTransf PICT "@E 9,999"
      @ 07,38 GET wTaxa   PICT "@E 999"    WHEN TeclaFuncao()
      @ 07,45 GET wOutros PICT "@E 9,999"
      @ 07,52 GET wTipo   PICT "@!S15"
      @ 07,68 GET wValor  PICT "@E 99,999" WHEN Let(wValor:=wLaudo+wCarro+wTaxa+wReexa+wTransf+wManual+wOutros).AND..F. //VALID LASTKEY()==K_UP.OR.!EMPTY(wValor)

      @ 08,02 SAY "Parc. Esp‚cie CH/Cart. Doc.       Data       Bco/Adm    Titular (terceiros)"
*                        999,999 999,999  xxxxxxxxxx 99/99/9999 xxxxxxxxxx xxxxxxxxxx
*                  2345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7
      @ 09,02 SAY "Ent:"
      @ 10,02 SAY "1¦ :"
      @ 11,02 SAY "2¦ :"
      @ 12,02 SAY "3¦ :"
      @ 13,02 SAY "4¦ :"
      @ 14,02 SAY "5¦ :"
      @ 15,02 SAY "6¦ :"
      @ 16,02 SAY "7¦ :"
      @ 17,02 SAY "8¦ :"
      @ 18,02 SAY "9¦ :"
      @ 19,02 SAY "10¦:"

      @ 09,08 GET wValor_D  PICT "@E 9999.99" VALID LASTKEY()#K_ESC
      @ 09,16 GET wValor_P1 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
      @ 09,25 GET wDoc1     PICT "@!"         WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
      @ 09,36 GET wDia1     PICT "@D"         WHEN wValor_P1#0.00.OR.wValor_D#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=cDtSys.AND.wDia1<=cDtSys+50
      @ 09,47 GET wBanco1   PICT "@!S10"      WHEN wValor_P1#0.00
      @ 09,58 GET wTit1     PICT "@!S15"      WHEN wValor_P1#0.00

      @ 10,16 GET wValor_P2 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 10,25 GET wDoc2     PICT "@!"         WHEN wValor_P2#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc2).AND.LASTKEY()#K_ESC
      @ 10,36 GET wDia2     PICT "@D"         WHEN wValor_P2#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia2).AND.wDia2>wDia1.AND.wDia2<=cDtSys+100.AND.Let(wBanco2:=wBanco1)
      @ 10,47 GET wBanco2   PICT "@!S10"      WHEN wValor_P2#0.00.AND.Let(wTit2:=wTit1)
      @ 10,58 GET wTit2     PICT "@!S15"      WHEN wValor_P2#0.00

      @ 11,16 GET wValor_P3 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 11,25 GET wDoc3     PICT "@!"         WHEN wValor_P3#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc3).AND.LASTKEY()#K_ESC
      @ 11,36 GET wDia3     PICT "@D"         WHEN wValor_P3#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia3).AND.wDia3>wDia2.AND.wDia3<=cDtSys+150.AND.Let(wBanco3:=wBanco2)
      @ 11,47 GET wBanco3   PICT "@!S10"      WHEN wValor_P3#0.00.AND.Let(wTit3:=wTit1)
      @ 11,58 GET wTit3     PICT "@!S15"      WHEN wValor_P3#0.00

      @ 12,16 GET wValor_P4 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 12,25 GET wDoc4     PICT "@!"         WHEN wValor_P4#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc4).AND.LASTKEY()#K_ESC
      @ 12,36 GET wDia4     PICT "@D"         WHEN wValor_P4#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia4).AND.wDia4>wDia3.AND.wDia4<=cDtSys+200.AND.Let(wBanco4:=wBanco3)
      @ 12,47 GET wBanco4   PICT "@!S10"      WHEN wValor_P4#0.00.AND.Let(wTit4:=wTit1)
      @ 12,58 GET wTit4     PICT "@!S15"      WHEN wValor_P4#0.00

      @ 13,16 GET wValor_P5 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 13,25 GET wDoc5     PICT "@!"         WHEN wValor_P5#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc5).AND.LASTKEY()#K_ESC
      @ 13,36 GET wDia5     PICT "@D"         WHEN wValor_P5#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia5).AND.wDia5>wDia4.AND.wDia5<=cDtSys+250.AND.Let(wBanco5:=wBanco4)
      @ 13,47 GET wBanco5   PICT "@!S10"      WHEN wValor_P5#0.00.AND.Let(wTit5:=wTit1)
      @ 13,58 GET wTit5     PICT "@!S15"      WHEN wValor_P5#0.00

      @ 14,16 GET wValor_P6 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 14,25 GET wDoc6     PICT "@!"         WHEN wValor_P6#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc6).AND.LASTKEY()#K_ESC
      @ 14,36 GET wDia6     PICT "@D"         WHEN wValor_P6#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia6).AND.wDia6>wDia5.AND.wDia6<=cDtSys+300.AND.Let(wBanco6:=wBanco5)
      @ 14,47 GET wBanco6   PICT "@!S10"      WHEN wValor_P6#0.00.AND.Let(wTit6:=wTit1)
      @ 14,58 GET wTit6     PICT "@!S15"      WHEN wValor_P6#0.00

      @ 15,16 GET wValor_P7 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 15,25 GET wDoc7     PICT "@!"         WHEN wValor_P7#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc7).AND.LASTKEY()#K_ESC
      @ 15,36 GET wDia7     PICT "@D"         WHEN wValor_P7#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia7).AND.wDia7>wDia6.AND.wDia7<=cDtSys+350.AND.Let(wBanco7:=wBanco6)
      @ 15,47 GET wBanco7   PICT "@!S10"      WHEN wValor_P7#0.00.AND.Let(wTit7:=wTit1)
      @ 15,58 GET wTit7     PICT "@!S15"      WHEN wValor_P7#0.00

      @ 16,16 GET wValor_P8 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 16,25 GET wDoc8     PICT "@!"         WHEN wValor_P8#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc8).AND.LASTKEY()#K_ESC
      @ 16,36 GET wDia8     PICT "@D"         WHEN wValor_P8#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia8).AND.wDia8>wDia7.AND.wDia8<=cDtSys+400.AND.Let(wBanco8:=wBanco7)
      @ 16,47 GET wBanco8   PICT "@!S10"      WHEN wValor_P8#0.00.AND.Let(wTit8:=wTit1)
      @ 16,58 GET wTit8     PICT "@!S15"      WHEN wValor_P8#0.00
                                            
      @ 17,16 GET wValor_P9 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 17,25 GET wDoc9     PICT "@!"         WHEN wValor_P9#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc9).AND.LASTKEY()#K_ESC
      @ 17,36 GET wDia9     PICT "@D"         WHEN wValor_P9#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia9).AND.wDia9>wDia8.AND.wDia9<=cDtSys+450.AND.Let(wBanco9:=wBanco8)
      @ 17,47 GET wBanco9   PICT "@!S10"      WHEN wValor_P9#0.00.AND.Let(wTit9:=wTit1)
      @ 17,58 GET wTit9     PICT "@!S15"      WHEN wValor_P9#0.00

      @ 18,16 GET wValor_P10 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 18,25 GET wDoc10     PICT "@!"         WHEN wValor_P10#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc10).AND.LASTKEY()#K_ESC
      @ 18,36 GET wDia10     PICT "@D"         WHEN wValor_P10#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia10).AND.wDia10>wDia9.AND.wDia10<=cDtSys+500.AND.Let(wBanco10:=wBanco9)
      @ 18,47 GET wBanco10   PICT "@!S10"      WHEN wValor_P10#0.00.AND.Let(wTit10:=wTit1)
      @ 18,58 GET wTit10     PICT "@!S15"      WHEN wValor_P10#0.00

      @ 19,16 GET wValor_P11 PICT "@E 9999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 19,25 GET wDoc11     PICT "@!"         WHEN wValor_P11#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc11).AND.LASTKEY()#K_ESC
      @ 19,36 GET wDia11     PICT "@D"         WHEN wValor_P11#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia11).AND.wDia11>wDia10.AND.wDia11<=cDtSys+550.AND.Let(wBanco11:=wBanco10)
      @ 19,47 GET wBanco11   PICT "@!S10"      WHEN wValor_P11#0.00.AND.Let(wTit11:=wTit1)
      @ 19,58 GET wTit11     PICT "@!S15"      WHEN wValor_P11#0.00

      @ 20,02 SAY "Serv: " GET wServico PICT "@!"
      @ 21,02 SAY "Obs.: " GET wObs1    PICT "@!"

      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF
      IF (wValor_D+wValor_P1+wValor_P2+wValor_P3+wValor_P4)#wValor
         Aviso("Valor diferencia do Total...",,3); LOOP
      ENDIF
      IF EMPTY(wValor_P1).AND.EMPTY(wValor_D)
         wDoc1:=SPACE(10); wBanco1:=SPACE(15); wDia1:=CTOD("")
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
      IF EMPTY(wValor_P7)
         wDoc7:=SPACE(10); wBanco7:=SPACE(15); wDia7:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P8)
         wDoc8:=SPACE(10); wBanco8:=SPACE(15); wDia8:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P9)
         wDoc9:=SPACE(10); wBanco9:=SPACE(15); wDia9:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P10)
         wDoc10:=SPACE(10); wBanco10:=SPACE(15); wDia10:=CTOD("")
      ENDIF
      IF EMPTY(wValor_P11)
         wDoc11:=SPACE(10); wBanco11:=SPACE(15); wDia11:=CTOD("")
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

      IF Confirma("Confirma Pagamento ?")
         /* Movimento de Caixa */
         lServ:=lObs1:=""
         IF wTransf>0.00; lServ += "RC,"; lObs1+= "RENOVACAO CONTRATO,"; ENDIF
         IF wCarro>0.00;  lServ += "CE,"; lObs1+= "CARRO PARA EXAME,"; ENDIF
         IF wTaxa>0.00;   lServ += "TS,"; lObs1+= "TAXA 2a. VIA,"; ENDIF
         IF wOutros>0.00; lServ += "OU,"; lObs1+= wTipo; ENDIF
         IF wManual>0.00; lServ += "MD,"; lObs1+= "MANUAL TEORICO,"; ENDIF

         // Liberar aluno para marcacao de aulas praticas
         IF wTransf>0.00
            WHILE !ALUNO->(NetLReg()); ENDDO
            REPLACE ALUNO->LIB WITH "S"
            ALUNO->(DBUNLOCK()); ALUNO->(DBCOMMIT())
         ENDIF

         RegPagParc()

         IF Confirma("Imprime Recibo ?")
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpRecibo2(wMatric)
               WHILE Confirma("Outra C¢pia do Recibo ?")
                  ImpRecibo2(wMatric)
               ENDDO
               TiraMsgImp(cAviso)
               WaitMsg("Fim de ImpressÆo, tecle algo...")
            ENDIF
         ENDIF

         /* Gravar na lista de exames */
         IF wCarro>0.00
            WHILE !EXAME->(NetApp()); ENDDO
            REPLACE EXAME->DTVCTO    WITH wDia1       ,;
                    EXAME->NOME      WITH ALUNO->NOME ,;
                    EXAME->MATRIC    WITH wMatric     ,;
                    EXAME->CARRO     WITH wCarro      ,;
                    EXAME->CODVEIC   WITH xVeiculo    ,;
                    EXAME->CODINST   WITH VEICULO->CODINST,;
                    EXAME->VEZ       WITH "1"         ,;
                    EXAME->DTEXAME   WITH xDtPrev     ,;
                    EXAME->HORA      WITH xHora       ,;
                    EXAME->DTEXAME1  WITH xDtPrev1    ,;
                    EXAME->HORA1     WITH xHora1      ,;
                    EXAME->RENACH    WITH ALUNO->RENACH,;
                    EXAME->RESULTADO WITH "9"
            EXAME->(DBUNLOCK()); EXAME->(DBCOMMIT())
         ENDIF
         EXIT
      ENDIF
   ENDDO
   Rest_Tela(2)
ENDDO
Rest_Tela(LEN(Telas)-zTela)
RELEASE xVeiculo,xDtPrev,xDtPrev1,xHora,xHora1,xLocal
SETKEY(K_F2,NIL)
DBCLOSEALL(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Recibo              ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION ImpRecibo2(pMat)
  Gera_TXT("RECIBO2.TXT")
  @ PROW()+1,05 SAY cRazao
  @ PROW()+1,05 SAY cEnder1
  @ PROW()+1,05 SAY cEnder2+" "+cEnder3
  @ PROW()+1,05 SAY cCGC_MF
  Controle()
  @ PROW()+1,05 SAY "# "+DBPARM->CR+pMat+" #"
  @ PROW()+4,05 SAY PADC("** R E C I B O **",70)
  @ PROW()+3,64 SAY "R$ "+ALLTRIM(STR(wValor))
  @ PROW()  ,64 SAY "R$ "+ALLTRIM(STR(wValor))
  @ PROW()+4,00 SAY "        RECEBEMOS DO(A) SR(A). "+RTRIM(wNome)+REPL("/",43-LEN(RTRIM(wNome)))
  @ PROW()+2,05 SAY "A QUANTIA SUPRA REFERENTE AO PAGAMENTO DOS SEGUINTES SERVI€OS:"
  @ PROW()+1,00 SAY ""
  IF wLaudo>0.00; @ PROW()+1,15 SAY "- LAUDO E LICEN€A DE APRENDIZAGEM"; ENDIF
  IF wCarro>0.00; @ PROW()+1,15 SAY "- CARRO PARA EXAME PRATICO"; ENDIF
  IF wOutros>0.00;@ PROW()+1,15 SAY "- "+wTipo; ENDIF
  IF wTaxa>0.00;  @ PROW()+1,15 SAY "- MARCA€AO DE EXAME NO DETRAN"; ENDIF
  IF wReexa>0.00; @ PROW()+1,15 SAY "- LAUDO DE REEXAME"; ENDIF
  IF wTransf>0.00;@ PROW()+1,15 SAY "- RENOVACAO DE CONTRATO"; ENDIF
  IF wManual>0.00;@ PROW()+1,15 SAY "- MANUAL (MATERIAL DIDATICO)"; ENDIF
  @ PROW()+2,05 SAY "PELA QUAL DAMOS TOTAL QUITACAO."

  IF SUBS(wDoc1,1,1)=="A"  /* Cartao */
     @ PROW()+1,05 SAY "Cartao de Cred.R$ "+STR(wValor_P1,7,2)+" Autorizacao No. "+SUBS(wDoc1,2)
  ELSE
     IF wParcelas=0
        @ PROW()+1,05 SAY "Cheque … Vista R$ "+STR(wValor_P1,7,2)+" No. "+wDoc1+" "+wBanco1+" "+DTOC(wDia1)
     ELSE
        IF (EMPTY(wValor_D).AND.!EMPTY(wValor_P1)).OR.(!EMPTY(wValor_D).AND.!EMPTY(wValor_P1))
           @ PROW()+1,05 SAY "Cheque … Vista R$ "+STR(wValor_P1,7,2)+" No. "+wDoc1+" "+wBanco1+" "+DTOC(wDia1)
        ENDIF
        IF !EMPTY(wValor_P2)
           IF SUBS(wDoc2,1,1)=="A"  /* Cartao */
              @ PROW()+1,05 SAY "Cartao de Cred.R$ "+STR(wValor_P2,7,2)+" Autorizacao No. "+SUBS(wDoc2,2)+" "+wBanco2
           ELSE
              @ PROW()+1,05 SAY "Cheque Pr‚-Dat.R$ "+STR(wValor_P2,7,2)+" No. "+wDoc2+" "+wBanco2+" "+DTOC(wDia2)
           ENDIF
        ENDIF
        IF !EMPTY(wDoc3)
           IF SUBS(wDoc2,1,1)=="A"  /* Cartao */
              @ PROW()+1,05 SAY "Cartao de Cred.R$ "+STR(wValor_P3,7,2)+" Autorizacao No. "+SUBS(wDoc3,2)+" "+wBanco3
           ELSE
              @ PROW()+1,05 SAY "Cheque Pr‚-Dat.R$ "+STR(wValor_P3,7,2)+" No. "+wDoc3+" "+wBanco3+" "+DTOC(wDia3)
           ENDIF
        ENDIF
        IF !EMPTY(wDoc4)
           IF SUBS(wDoc2,1,1)=="A"  /* Cartao */
              @ PROW()+1,05 SAY "Cartao de Cred.R$ "+STR(wValor_P4,7,2)+" Autorizacao No. "+SUBS(wDoc4,2)+" "+wBanco4
           ELSE
              @ PROW()+1,05 SAY "Cheque Pr‚-Dat.R$ "+STR(wValor_P4,7,2)+" No. "+wDoc4+" "+wBanco4+" "+DTOC(wDia4)
           ENDIF
        ENDIF
     ENDIF
  ENDIF

  IF !EMPTY(wCarro)
     @ PROW()+2,05 SAY "DIREITO A CARRO OU MOTO PARA EXAME"
     @ PROW()+1,05 SAY "Previsao(1): "+DTOC(xDtPrev)+" as "+TRANSFORM(xHora,"@R 99:99")
     @ PROW()+1,05 SAY "Previsao(2): "+DTOC(xDtPrev1)+" as "+TRANSFORM(xHora1,"@R 99:99")
     @ PROW()+1,05 SAY "Local......: "+xLocal
     @ PROW()+1,05 SAY "Veiculo....: "+ALLTRIM(VEICULO->MARCA)
     @ PROW()+2,05 SAY "Documentos Necess rios: "
     @ PROW()+1,05 SAY "    - RG (original)"
     @ PROW()+1,05 SAY "    - N§ RENACH"
     @ PROW()+1,05 SAY "    - Licen‡a (LADV)"
     @ PROW()+2,05 SAY "** ATENCAO ** Ligar um dia antes para confirmar o teste"
  ENDIF
  IF !EMPTY(wServico) .OR. !EMPTY(wObs1)
     @ PROW()+2,05 SAY "SERVI€OS...: "+wServico
     @ PROW()+1,05 SAY "OBSERVA€åES: "+wObs1
  ENDIF
  @ PROW()+4,05 SAY PADR("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),80)
  @ PROW()+3,05 SAY REPL("_",LEN(xRazao))
  @ PROW()+1,05 SAY xRazao
  @ PROW()+1,LEN(xRazao)/2+5 SAY "Tesouraria"
  @ PROW()+1,05 SAY " "
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp RECIBO2.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE RECIBO2.TXT

*  RodaNoDos("recibo2.txt")
  RETURN NIL
