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

cPrg:="AE241";ProgName("AE241"); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "41"
SET KEY -1 TO Mostra()
wData:=CTOD(""); wMatr:=SPACE(5); wResp:=" "
PUBLIC xVeiculo:=SPACE(2); xDtPrev:=xDtPrev1:=cDtSys; xHora:=xHora1:=SPACE(4)
WHILE .T.
   wNome:=SPACE(50)
   SETCOLOR(YCOREDIT)
   Telas(2,5,5,68,1,YCOREDIT,.T.,"Pagamento de Servi‡os")
   Telas(5,5,21,68,1,YCOREDIT,.T.)
   @ 03,07 SAY "Aluno ? (S/N)" GET wResp PICT "!" VALID wResp $ "SN"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF
   IF wResp=="N"
      @ 04,07 SAY "Nome:" GET wNome PICT "@!" VALID !EMPTY(wNome)
   ELSE
      Mensagem("Informe Matr¡cula do Aluno")
      @ 04,07 SAY "Matr¡cula:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
        VALID TDescr(3,1,4,22,wMatr,"NOME",["@S40"],"Aluno NÆo Localizado")
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF wResp=="S"
      wNome:=ALUNO->NOME
      ChkPend(wMatr)  // Verifica pendencia diversas
      ChkPReq(wMatr)  // Verifica pendencia de requerimento
   ENDIF
   wCarro:=wTaxa:=wLaudo:=wValor:=wReexa:=wTransf:=wOutros:=wManual:=wAulasT:=0.00
   wValor_P1:=wValor_P2:=wValor_P3:=wValor_P4:=wValor_P5:=wValor_D:=0.00
   wDoc1:=wDoc2:=wDoc3:=wDoc4:=wDoc5:=SPACE(10); wObs1:=SPACE(67); wServico:=wTipo:=SPACE(50)
   wBanco1:=wBanco2:=wBanco3:=wBanco4:=wBanco5:=SPACE(15)
   wTit1:=wTit2:=wTit3:=wTit4:=wTit5:=SPACE(25)
   wDia1:=cDtSys; wdia2:=wdia3:=wdia4:=CTOD("");wOptou:=" "; wDtInscr:=cDtSys

   WHILE .T.
*     @ 07,07 SAY "Laudo e Licen‡a.:"   GET wLaudo  PICT "@E 9,999.99"
*     @ 08,07 SAY "Laudo de Reexame:"   GET wReexa  PICT "@E 9,999.99" WHEN TeclaFuncao()

      @ 06,07 SAY "Carro para Exame..:" GET wCarro  PICT "@E 9,999.99" WHEN TeclaFuncao(.T.) VALID LASTKEY()==K_UP.OR.RCarro(wCarro,.T.)
      @ 07,07 SAY "Manual Te¢rico....:" GET wManual PICT "@E 9,999.99"
      @ 08,07 SAY "Renova‡Æo Contrato:" GET wTransf PICT "@E 9,999.99"
      @ 06,37 SAY "Outros.....:"        GET wOutros PICT "@E 9,999.99"
      @ 07,37 SAY "Descri‡Æo..:"        GET wTipo   PICT "@!S18"
      @ 08,37 SAY "Taxa 2¦ via:"        GET wTaxa   PICT "@E 9,999.99" WHEN TeclaFuncao()
      @ 09,07 SAY "Total Servi‡os - R$" GET wValor  PICT "@E 9,999.99" WHEN Let(wValor:=wLaudo+wCarro+wTaxa+wReexa+wTransf+wManual+wOutros).AND..F. //VALID LASTKEY()==K_UP.OR.!EMPTY(wValor)
      @ 10,05 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
      @ 11,05 SAY "³    ENTRADA R$   ³  1¦ PARCELA  ³  2¦ PARCELA  ³  3¦ PARCELA  ³"
      @ 12,05 SAY "ÃÄÄDinÄÄÄÂÄCH/CarÄÅÄÄÄCH/CartaoÄÄÅÄÄÄCH/CartaoÄÄÅÄÄÄCH/CartaoÄÄ´"
      @ 13,05 SAY "³        ³        ³              ³              ³              ³"
      @ 14,05 SAY "ÃÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
      @ 15,05 SAY "³N§               ³N§            ³N§            ³N§            ³"
      @ 16,05 SAY "³Data:            ³Dt:           ³Dt:           ³Dt:           ³"
      @ 17,05 SAY "³Bco.:            ³Bco.:         ³Bco.:         ³Bco.:         ³"
      @ 18,05 SAY "³Tit.:            ³Tit.:         ³Tit.:         ³Tit.:         ³"
      @ 19,05 SAY "³Sv‡.:                                                         ³"
      @ 20,05 SAY "³Obs.:                                                         ³"
      @ 21,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
      @ 13,06 GET wValor_D  PICT "@E 9,999.99" VALID LASTKEY()#K_ESC
      @ 13,15 GET wValor_P1 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
      @ 15,10 GET wDoc1     PICT "@!"          WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
      @ 16,12 GET wDia1     PICT "@D"          WHEN wValor_P1#0.00.OR.wValor_D#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=cDtSys.AND.wDia1<=cDtSys+40
      @ 17,12 GET wBanco1   PICT "@!S10"       WHEN wValor_P1#0.00
      @ 18,12 GET wTit1     PICT "@!S10"       WHEN wValor_P1#0.00
      @ 13,27 GET wValor_P2 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 15,28 GET wDoc2     PICT "@!"          WHEN wValor_P2#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc2).AND.LASTKEY()#K_ESC
      @ 16,28 GET wDia2     PICT "@D"          WHEN wValor_P2#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia2).AND.wDia2>wDia1.AND.wDia2<=cDtSys+80
      @ 17,30 GET wBanco2   PICT "@!S7"        WHEN wValor_P2#0.00.AND.Let(wTit2:=wTit1)
      @ 18,30 GET wTit2     PICT "@!S7"        WHEN wValor_P2#0.00
      @ 13,43 GET wValor_P3 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 15,43 GET wDoc3     PICT "@!"          WHEN wValor_P3#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc3).AND.LASTKEY()#K_ESC
      @ 16,42 GET wDia3     PICT "@D"          WHEN wValor_P3#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia3).AND.wDia3>wDia2.AND.wDia3<=cDtSys+120
      @ 17,45 GET wBanco3   PICT "@!S7"        WHEN wValor_P3#0.00.AND.Let(wTit3:=wTit1)
      @ 18,45 GET wTit3     PICT "@!S7"        WHEN wValor_P3#0.00
      @ 13,58 GET wValor_P4 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC
      @ 15,57 GET wDoc4     PICT "@!"          WHEN wValor_P4#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc4).AND.LASTKEY()#K_ESC
      @ 16,57 GET wDia4     PICT "@D"          WHEN wValor_P4#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia4).AND.wDia4>wDia3.AND.wDia4<=cDtSys+100
      @ 17,59 GET wBanco4   PICT "@!S7"        WHEN wValor_P4#0.00.AND.Let(wTit4:=wTit1)
      @ 18,59 GET wTit4     PICT "@!S7"        WHEN wValor_P4#0.00
      @ 19,12 GET wServico  PICT "@!S55"
      @ 20,12 GET wObs1     PICT "@!S55"
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

      IF (!EMPTY(wValor_D).OR.!EMPTY(wValor_P1)).AND.!EMPTY(wValor_P2).AND.EMPTY(wValor_P3).AND.EMPTY(wValor_P4)
         wParcelas:=2
      ELSEIF (!EMPTY(wValor_D).OR.!EMPTY(wValor_P1)).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.EMPTY(wValor_P4)
         wParcelas:=3
      ELSEIF (!EMPTY(wValor_D).OR.!EMPTY(wValor_P1)).AND.!EMPTY(wValor_P2).AND.!EMPTY(wValor_P3).AND.!EMPTY(wValor_P4)
         wParcelas:=4
      ELSE
         wParcelas:=1
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

         FOR i= 1 TO wParcelas
             xNlan:=GravaLan()

             xVcto:=IF(EMPTY(wDia1),cDtSys,wDia1)+(i*30-30)
             WHILE !CAIXA->(NetApp()); ENDDO
             REPLACE CAIXA->HIST   WITH IF(wResp=="N",wNome,ALUNO->NOME),;
                     CAIXA->NLAN   WITH xNLan,;
                     CAIXA->TIPO   WITH "C"                 ,;
                     CAIXA->DTMOV  WITH cDtSys,; //IF(i=1,wDia1,IF(i=2,wDia2,IF(i=3,wDia3,wDia4))),;
                     CAIXA->DATA   WITH IF(i=1,wDia1,IF(i=2,wDia2,IF(i=3,wDia3,wDia4))),;
                     CAIXA->DOC    WITH IF(i=1,wDoc1,IF(i=2,wDoc2,IF(i=3,wDoc3,wDoc4))),;
                     CAIXA->BANCO  WITH lServ ,;
                     CAIXA->SERV   WITH wServico ,;
                     CAIXA->OBS1   WITH lObs1 ,;
                     CAIXA->MATRIC WITH IF(wResp=="S",wMatr,SPACE(5)),;
                     CAIXA->USER   WITH cUsuario

             IF i==1.AND.wValor_D>0.00.AND.wValor_P1==0.00
                REPLACE CAIXA->VALOR WITH wValor_D ,;
                        CAIXA->VLR_D WITH wValor_D
             ELSEIF i==1.AND.wValor_D=0.00.AND.wValor_P1>0.00
                REPLACE CAIXA->VALOR WITH wValor_P1 ,;
                        CAIXA->VLR_C WITH wValor_P1
             ELSEIF i==1.AND.wValor_D>0.00.AND.wValor_P1>0.00
                REPLACE CAIXA->VALOR WITH wValor_D+wValor_P1 ,;
                        CAIXA->VLR_D WITH wValor_D           ,;
                        CAIXA->VLR_C WITH wValor_C
             ELSEIF i==2.AND.wValor_P2>0.00
                REPLACE CAIXA->VALOR WITH wValor_P2
             ELSEIF i==3.AND.wValor_P3>0.00
                REPLACE CAIXA->VALOR WITH wValor_P3
             ELSEIF i==4.AND.wValor_P4>0.00
                REPLACE CAIXA->VALOR WITH wValor_P4
             ENDIF
             CAIXA->(DBCOMMIT())


             WHILE !PAGAR->(NetApp()); ENDDO
             REPLACE PAGAR->MATRIC  WITH IF(wResp=="S",wMatr,"99999"),;
                     PAGAR->PARCELA WITH STRZERO(i,2),;
                     PAGAR->NOME    WITH wNome,;
                     PAGAR->NLAN    WITH xNLan,;
                     PAGAR->DOC     WITH IF(i==1,wDoc1,IF(i==2,wDoc2,IF(i==3,wDoc3,wDoc4))),;
                     PAGAR->BANCO   WITH IF(i==1,wBanco1,IF(i==2,wBanco2,IF(i==3,wBanco3,wBanco4))),;
                     PAGAR->TITULAR WITH IF(i==1,wTit1,IF(i==2,wTit2,IF(i==3,wTit3,wTit4))),;
                     PAGAR->DTVCTO  WITH IF(i==1,wDia1,IF(i=2,wDia2,IF(i=3,wDia3,wDia4))),;
                     PAGAR->VALOR_C WITH IF(i=1,wValor_P1,IF(i=2,wValor_P2,IF(i=3,wValor_P3,wValor_P4)))
             IF i==1
                REPLACE PAGAR->DTPGTO  WITH wDia1,;
                        PAGAR->VALOR_P WITH wValor_P1+wValor_D,;
                        PAGAR->VALOR_D WITH wValor_D,;
                        PAGAR->OBS1    WITH wObs1,;
                        PAGAR->OBS2    WITH lObs1,;
                        PAGAR->SERVICO WITH wServico
             ELSEIF i==2
                REPLACE PAGAR->DTPGTO  WITH wDia2,;
                        PAGAR->VALOR_P WITH wValor_P2,;
                        PAGAR->OBS1    WITH "PAGAMENTO AUTOMATICO"
             ELSEIF i==3
                REPLACE PAGAR->DTPGTO  WITH wDia3,;
                        PAGAR->VALOR_P WITH wValor_P3,;
                        PAGAR->OBS1    WITH "PAGAMENTO AUTOMATICO"
             ELSEIF i==4
                REPLACE PAGAR->DTPGTO  WITH wDia4,;
                        PAGAR->VALOR_P WITH wValor_P4,;
                        PAGAR->OBS1    WITH "CHEQUE PRE-DATADO OU CARTAO"
             ENDIF
             PAGAR->(DBCOMMIT())
         NEXT
         IF Confirma("Imprime Recibo ?")
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpRecibo2(wMatr)
               WHILE Confirma("Outra C¢pia do Recibo ?")
                  ImpRecibo2(wMatr)
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
                    EXAME->MATRIC    WITH wMatr       ,;
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
RELEASE xVeiculo,xDtPrev,xDtPrev1,xHora,xHora1,xLocal
SETKEY(K_F2,NIL); Rest_Tela(2)
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
* IF wLaudo>0.00; @ PROW()+1,15 SAY "- LAUDO E LICEN€A DE APRENDIZAGEM"; ENDIF
  IF wCarro>0.00; @ PROW()+1,15 SAY "- CARRO PARA EXAME PRATICO"; ENDIF
  IF wOutros>0.00;@ PROW()+1,15 SAY "- "+wTipo; ENDIF
  IF wTaxa>0.00;  @ PROW()+1,15 SAY "- MARCA€AO DE EXAME NO DETRAN"; ENDIF
* IF wReexa>0.00; @ PROW()+1,15 SAY "- LAUDO DE REEXAME"; ENDIF
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
     @ PROW()+1,05 SAY "Local......: "+xLocal
     @ PROW()+1,05 SAY "Veiculo....: "+ALLTRIM(VEICULO->MARCA)
     @ PROW()+2,05 SAY "Documentos Necess rios: "
     @ PROW()+1,05 SAY "    - RG (original)"
     @ PROW()+1,05 SAY "    - N§ RENACH"
     @ PROW()+1,05 SAY "    - Licen‡a (LADV)"
     @ PROW()+2,05 SAY "** ATENCAO ** Ligar um dia antes para confirmar o teste"
  ENDIF
  IF !EMPTY(wObs1)
     @ PROW()+2,05 SAY "* OBS: "+wObs1
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
