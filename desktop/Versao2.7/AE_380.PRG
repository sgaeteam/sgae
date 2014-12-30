*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_380                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : 2¦ Via de Documentos                     ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ³
*³ DATA CRIACAO   : 25/11/1997                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"DATA"   ,"D", 08,0}) /* Data do Exame    */
AADD(aDbf,{"HORA"   ,"C", 04,0}) /* Hora Prevista    */
AADD(aDbf,{"REALIZ" ,"C", 02,0}) /* Aula Realizada   */
AADD(aDbf,{"INSTRUT","C", 15,0}) /* Instrutor        */
AADD(aDbf,{"VEICULO","C", 15,0}) /* Veiculo          */
AADD(aDbf,{"EMBARQ" ,"C", 01,0}) /* Local Embarque   */
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

SELECT 12
IF NetUse("DBCURSO","CURSO")          /* Cursos */
   SET INDEX TO DBICUR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF !NetUse("DBPARM")                  /* Parametros */
   DelDbfNtx(); RETURN
ENDIF

SELECT 6
IF NetUse("DBPAG","PAGAR")            /* Pagamentos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 14
IF NetUse("DBVEIC","VEICULO")         /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2,DBIVEI3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")             /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")            /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE380"; ProgName(cPrg); LinhaMsg(2)

Telas(11,20,15,50,1,YCOREDIT,.T.)
wOp1:=wOp2:=wOp3:=" "
SETCOLOR(YCOREDIT)
@ 12,22 SAY "(   )  Recibo         "
@ 13,22 SAY "(   )  Ficha Matr¡cula"
@ 14,22 SAY "(   )  Contrato       "

PUBLIC xVeiculo:=SPACE(2); xDtPrev:=xDtPrev1:=DATE(); xHora:=xHora1:=SPACE(4)
SET KEY -1 TO Mostra()
WHILE .T.
   Mensagem("Marque com um X para Selecionar");SETCOLOR(YCOREDIT)
   @ 12,24 GET wOp1 PICT "!" VALID wOp1 $ "X "
   @ 13,24 GET wOp2 PICT "!" VALID (LASTKEY()==K_UP).OR.wOp2 $ "X "
   @ 14,24 GET wOp3 PICT "!" VALID (LASTKEY()==K_UP).OR.wOp3 $ "X "
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   wValor_P1:=wValor_P2:=wValor_P3:=wValor_P4:=wValor_P5:=wValor_D:=wCarro:=wTaxa:=wValor:=0.00
   wDoc1:=wDoc2:=wDoc3:=wDoc4:=wDoc5:=SPACE(10); wObs1:=SPACE(67); wServico:=SPACE(50)
   wBanco1:=wBanco2:=wBanco3:=wBanco4:=wBanco5:=SPACE(15);wNF:=SPACE(6)
   wdia1:=cDtSys; wdia2:=wdia3:=wDia4:=wDia5:=CTOD("");wOptou:=" "; wAulasT:=wAulas:=0
   wTit1:=wTit2:=wTit3:=wTit4:=wTit5:=SPACE(25); wNom:="     "; wVia:="2"

   SETCOLOR(YCOREDIT)
   Telas(4,3,7,68,1,YCOREDIT,.T.,"ImpressÆo de 2¦ Via")
   Mensagem("Informe a Matr¡cula do Aluno")
   @ 05,05 SAY "Matr¡cula:" GET wNom  PICT "99999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wNom).AND.TDescr(3,1,5,22,wNom,"NOME",["@S40"],"Matr¡cula NÆo Localizada")
   @ 06,05 SAY "N§ da Via:" GET wVia  PICT "9"    WHEN TeclaFuncao() VALID !EMPTY(wVia)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   xMatric:=wNom
   wMatric:=wNom
   wRENACH:=ALUNO->RENACH
   wDtInscr:=ALUNO->DTINSCR
   wRG:=ALUNO->RG
   wCateg:=ALUNO->CATEG
   wNome:=ALUNO->NOME
   wEndereco:=ALUNO->ENDERECO
   wAuto:=ALUNO->AUTO
   wPesq:=ALUNO->PESQ
   xCodCur:=SPACE(2)
   IF ConfPgto("Forma de Pagamento ?")
      wParcelas:=0 ; wDia1 := cDtSys
      Parcelamento(.f.)
      IF !EMPTY(wOp2)
         IF Confirma("Imprime Ficha de Matr¡cula ?")
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpFichaMat()
               WHILE Confirma("Outra C¢pia ?")
                  ImpFichaMat()
               ENDDO
               TiraMsgImp(cAviso)
               WaitMsg("Fim de ImpressÆo, tecle algo...")
            ENDIF
         ENDIF
      ENDIF
      IF !EMPTY(wOp3)
         IF Confirma("Imprime Contrato ?")
            IF ChkImpr()
               cAviso := MsgImp(.F.)
               ImpContrato()
               WHILE Confirma("Outra C¢pia ?")
                  ImpContrato()
               ENDDO
               TiraMsgImp(cAviso)
               WaitMsg("Fim de ImpressÆo, tecle algo...")
            ENDIF
         ENDIF
      ENDIF
   ELSE
      wParcelas:=0 ; wDia1 := cDtSys
      Telas(4,5,20,44,1,YCOREDIT,.T.,"Pagamento … Vista")
      WHILE .T.
         @ 05,07 SAY "Aulas Pr ticas:" GET wAulas  PICT "99"
         @ 06,07 SAY "Aulas Te¢ricas:" GET wAulasT PICT "99" //VALID LASTKEY()=K_UP.OR.CheckAulas(wAulas,wAulasT)
         @ 07,07 SAY "Nota Fiscal...:" GET wNF
         @ 08,07 SAY "Carro p/Exame.:" GET wCarro PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.RCarro(wCarro)
         @ 09,07 SAY "Servi‡os......:" GET wTaxa  PICT "@E 9,999,999.99" VALID LASTKEY()==K_UP.OR.Let(wValor:=wCarro+wTaxa)
         @ 10,07 SAY "Vlr. Total R$.:" GET wValor PICT "@E 9,999,999.99" WHEN .F.
         @ 11,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
         @ 12,05 SAY "³  Dinheiro  ³    Cheque / CartÆo      ³"
         @ 13,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
         @ 14,05 SAY "³R$          ³R$         ³N§           ³"
         @ 15,05 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
         @ 16,05 SAY "³Banco:                                ³"
         @ 17,05 SAY "³Data :                                ³"
         @ 18,05 SAY "³Obs:                                  ³"
         @ 19,05 SAY "³Sv‡:                                  ³"
         @ 20,05 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
         @ 14,09 GET wValor_D  PICT "@E 9,999.99" VALID LASTKEY()#K_ESC
         @ 14,22 GET wValor_P1 PICT "@E 9,999.99" VALID LASTKEY()==K_UP.OR.LASTKEY()#K_ESC.AND.IF(EMPTY(wValor_D),!EMPTY(wValor_P1),.T.)
         @ 14,34 GET wDoc1     PICT "@!"    WHEN wValor_P1#0.00 VALID LASTKEY()==K_UP.OR.!EMPTY(wDoc1).AND.LASTKEY()#K_ESC
         @ 16,13 GET wBanco1   PICT "@!S31" WHEN wValor_P1#0.00
         @ 17,13 GET wDia1     PICT "@D"    WHEN wValor_P1#0.00 VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1).AND.wDia1>=DATE().AND.wDia1<=DATE()+10
         @ 18,11 GET wObs1     PICT "@!S33"
         @ 19,11 GET wServico  PICT "@!S33"
         SETCURSOR(1); READ; SETCURSOR(0)
         IF (wValor_D+wValor_P1)#wValor
            Aviso("Valor diferencia do Total...",,3); LOOP
         ENDIF
         IF Confirma("Confirma Pagamento ?")
            IF !EMPTY(wOp1)
               IF Confirma("Imprime Recibo ?")
                  IF ChkImpr()
                     cAviso := MsgImp(.F.)
                     ImpRecibo(wMatric)
*                    WHILE Confirma("Outra C¢pia ?")
*                       ImpRecibo(wMatric)
*                    ENDDO
                     TiraMsgImp(cAviso)
                     WaitMsg("Fim de ImpressÆo, tecle algo...")
                  ENDIF
               ENDIF
            ENDIF
            IF !EMPTY(wOp2)
               IF Confirma("Imprime Ficha de Matr¡cula ?")
                  IF ChkImpr()
                     cAviso := MsgImp(.F.)
                     ImpFichaMat()
                     WHILE Confirma("Outra C¢pia ?")
                        ImpFichaMat()
                     ENDDO
                     TiraMsgImp(cAviso)
                     WaitMsg("Fim de ImpressÆo, tecle algo...")
                  ENDIF
               ENDIF
            ENDIF
            IF !EMPTY(wOp3)
               IF Confirma("Imprime Contrato ?")
                  IF ChkImpr()
                     cAviso := MsgImp(.F.)
                     ImpContrato()
                     WHILE Confirma("Outra C¢pia ?")
                        ImpContrato()
                     ENDDO
                     TiraMsgImp(cAviso)
                     WaitMsg("Fim de ImpressÆo, tecle algo...")
                  ENDIF
               ENDIF
            ENDIF

            /* Movimento de Caixa */
            Aguarde("Gravando recebimento...")
            IF !EMPTY(wValor_D).AND.!EMPTY(wValor_P1)
               FOR f = 1 TO 2
                  xNLan:=GravaLan()

                  WHILE !CAIXA->(NetApp()); ENDDO
                  REPLACE CAIXA->HIST   WITH "2¦ Via "+ALUNO->NOME ,;
                          CAIXA->TIPO   WITH "C"                 ,;
                          CAIXA->NLAN   WITH xNLan,;
                          CAIXA->DTMOV  WITH DATE(),;
                          CAIXA->DATA   WITH wDia1 ,;
                          CAIXA->NF     WITH wNF ,;
                          CAIXA->DOC    WITH IF(f=2,wDoc1,""),;
                          CAIXA->MATRIC WITH ALUNO->MATRIC,;
                          CAIXA->VALOR  WITH IF(f=1,wValor_D,wValor_P1),;
                          CAIXA->BANCO  WITH IF(f=2,wBanco1,""),;
                          CAIXA->SERV   WITH IF(f=2,wServico,""),;
                          CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                          CAIXA->USER   WITH cUsuario
               NEXT
            ELSE
               xNLan:=GravaLan()

               WHILE !CAIXA->(NetApp()); ENDDO
               REPLACE CAIXA->HIST   WITH "2¦ Via "+ALUNO->NOME ,;
                       CAIXA->DOC    WITH wDoc1               ,;
                       CAIXA->NF     WITH wNF                 ,;
                       CAIXA->TIPO   WITH "C"                 ,;
                       CAIXA->NLAN   WITH xNLan               ,;
                       CAIXA->DTMOV  WITH DATE()              ,;
                       CAIXA->DATA   WITH wDia1               ,;
                       CAIXA->VALOR  WITH wValor_D+wValor_P1  ,;
                       CAIXA->BANCO  WITH wBanco1             ,;
                       CAIXA->SERV   WITH wServico            ,;
                       CAIXA->MATRIC WITH ALUNO->MATRIC       ,;
                       CAIXA->OBS1   WITH IF(wCarro>0.00,"INCLUI TAXA DE CARRO PARA EXAME",wObs1),;
                       CAIXA->USER   WITH cUsuario
            ENDIF
            CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())

            WHILE !PAGAR->(NetApp()); ENDDO
            REPLACE PAGAR->MATRIC  WITH ALUNO->MATRIC,;
                    PAGAR->PARCELA WITH "01",;
                    PAGAR->NF      WITH wNF  ,;
                    PAGAR->NOME    WITH wNome,;
                    PAGAR->DOC     WITH wDoc1,;
                    PAGAR->BANCO   WITH wBanco1,;
                    PAGAR->DTPGTO  WITH cDtSys,;
                    PAGAR->DTVCTO  WITH wDia1,;
                    PAGAR->VALOR_D WITH wValor_D,;
                    PAGAR->VALOR_C WITH wValor_P1,;
                    PAGAR->VALOR_P WITH wValor_D+wValor_P1,;
                    PAGAR->NLAN    WITH xNLan,;
                    PAGAR->OBS1    WITH wObs1,;
                    PAGAR->SERVICO WITH wServico
            PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
            Aguarde()
            Rest_Tela(); EXIT
         ENDIF
      ENDDO
   ENDIF
   Rest_Tela()
ENDDO
RELEASE xVeiculo,xDtPrev,xHora,xLocal
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
