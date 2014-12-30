*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_330                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Relatorio Programa‡Æo de Aluno           ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NUMERO" ,"C",  02,0}) /* Numero da Aula   */
AADD(aDbf,{"DATA"   ,"D",  08,0}) /* Data do Exame    */
AADD(aDbf,{"LOCAL"  ,"C",  15,0}) /* Local Embarque   */
AADD(aDbf,{"HORA"   ,"C",  04,0}) /* Hora Prevista    */
AADD(aDbf,{"REALIZ" ,"C",  05,0}) /* Aula Realizada   */
AADD(aDbf,{"INSTRUT","C",  15,0}) /* Instrutor        */
AADD(aDbf,{"VEICULO","C",  15,0}) /* Veiculo          */
AADD(aDbf,{"EMBARQ" ,"C",  01,0}) /* Local Embarque   */
AADD(aDbf,{"NOVA"   ,"C",  01,0}) /* Novas Aulas      */
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

SELECT 30
IF NetUse("DBCP","CP")               /* Conteudo Programatico */
   SET INDEX TO DBICP1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 7
IF !NetUse("DBPARM")                 /* Parametros */
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")            /* Caixa */
   SET INDEX TO DBICX1,DBICX2,DBICX3,DBICX4
ELSE
   DelDbfNtx(); RETURN
ENDIF
        
SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")      /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")          /* Programa‡Æo de Aulas Praticas */
   SET INDEX TO DBIPRO1,DBIPRO2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE330";ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "30"
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT); wNom:=SPACE(5); wVia:="2"; wTxa:=0.00
   Telas(4,3,8,68,1,YCOREDIT,.T.,"Relat¢rio de Programa‡Æo de Alunos")
   Mensagem("Informe a Matr¡cula do Aluno")
   @ 05,05 SAY "Matr¡cula:" GET wNom PICT "99999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wNom).AND.TDescr(3,1,5,22,wNom,"NOME",["@S40"],"Matr¡cula NÆo Localizada")
   @ 06,05 SAY "N§ da Via:" GET wVia PICT "9"     WHEN TeclaFuncao() VALID !EMPTY(wVia)
   @ 07,05 SAY "Valor R$ :" GET wTxa PICT "@E 999.99"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   lPendente:=.F.
   IF AULAS->(DBSEEK(wNom))
      WHILE AULAS->MATRIC==wNom.AND.!AULAS->(EOF())
*        IF !AULAS->COBRADA
            /* Alimentar arq. tempor rio */
            lPendente:=.T.
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->DATA    WITH AULAS->DATA,;
                    (cArq1)->NUMERO  WITH AULAS->NUMERO,;
                    (cArq1)->HORA    WITH AULAS->HORA,;
                    (cArq1)->REALIZ  WITH IF(AULAS->COBRADA,"Ok",IF(AULAS->STATUS,"Falta",SPACE(5))),;
                    (cArq1)->INSTRUT WITH AULAS->CODINST,;
                    (cArq1)->VEICULO WITH AULAS->CODVEIC,;
                    (cArq1)->LOCAL   WITH AULAS->LOCAL,;
                    (cArq1)->EMBARQ  WITH AULAS->EMBARQ,;
                    (cArq1)->NOVA    WITH "S"
*        ENDIF
         AULAS->(DBSKIP())
      ENDDO
      IF lPendente
         IF wTxa>0.00
            /* Movimento de Caixa */
            GravaLan()

            WHILE !CAIXA->(NetApp()); ENDDO
            REPLACE CAIXA->HIST   WITH ALUNO->NOME ,;
                    CAIXA->TIPO   WITH "C"         ,;
                    CAIXA->NLAN   WITH zNLan,;
                    CAIXA->DTMOV  WITH DATE() ,;
                    CAIXA->DATA   WITH DATE() ,;
                    CAIXA->BANCO  WITH "2a. VIA PROGRAM",;
                    CAIXA->MATRIC WITH wNom ,;
                    CAIXA->USER   WITH cUsuario ,;
                    CAIXA->VLR_D  WITH wTxa ,;
                    CAIXA->VALOR  WITH wTxa
         ENDIF
         cAviso := MsgImp(.F.)
         IF wTxa#0.00
            IF Confirma("Imprime Recibo ?")
               IF ChkImpr()
                  ImpRecVia2()
               ENDIF
            ENDIF
         ENDIF
         IF ChkImpr()
            ImpProgAluno(wVia,.T.)
            TiraMsgImp(cAviso)
            WaitMsg("Fim de ImpressÆo, tecle algo...")
         ENDIF
         (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
      ELSE
         IF LASTKEY()#K_ESC
            Aviso("NÆo h  Programa‡Æo em aberto deste Aluno...",,3)
         ENDIF
      ENDIF
   ELSE
      Aviso("NÆo h  Programa‡Æo para este Aluno...",,3)
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Recibo 2 VIA        ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION ImpRecVia2()
  Gera_TXT("2VRECIBO.TXT"); SETPRC(0,0)
* Compr_Off()
  @ PROW()+1,05 SAY cRazao
  @ PROW()+1,05 SAY cEnder1
  @ PROW()+1,05 SAY cEnder2
  @ PROW()+1,05 SAY cEnder3
  @ PROW()+1,05 SAY cCGC_MF
  @ PROW()+5,05 SAY PADC("** R E C I B O **",70)
  @ PROW()+3,64 SAY "R$ "+ALLTRIM(STR(wTxa))
  @ PROW()+4,00 SAY "        RECEBEMOS DO(A) SR(A). "+RTRIM(ALUNO->NOME)+REPL("*",43-LEN(RTRIM(ALUNO->NOME)))
  @ PROW()+2,05 SAY "A QUANTIA SUPRA REFERENTE AO PAGAMENTO DE TAXA DE EMISSAO DE 2a. VIA DE"
  @ PROW()+2,05 SAY "PROGRAMACAO DE AULAS CONFORME CLAUSULA QUARTA  DO CONTRATO DE PRESTACAO"
  @ PROW()+2,05 SAY "DE SERVICOS ORA FIRMADO."
  @ PROW()+5,05 SAY PADR("Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+ExtMes(DATE())+" de "+STR(YEAR(DATE()),4),80)
  @ PROW()+3,05 SAY REPL("_",LEN(xRazao))
  @ PROW()+1,05 SAY xRazao
  @ PROW()+5,05 SAY "ATENCAO    - Em caso de desistencia sera cobrada  uma taxa equivalente a"
  @ PROW()+1,05 SAY "             20% (vinte por cento) sobre o valor total do curso."
  @ PROW()+1,05 SAY "           - Desmarcacao de aulas somente com 24 horas de antecedencia."
  @ PROW()+1,05 SAY "           - Remarcacao  de  aula  faltada, somente  com apresentacao do"
  @ PROW()+1,05 SAY "             ATESTADO MEDICO no maximo de ate 48 hs."
  @ PROW()+2,05 SAY "OBSERVACAO - A duracao: 50 minutos de aula pratica  e  10 minutos para o"
  @ PROW()+1,05 SAY "             percurso do instrutor ate o local do treinamento."
  @ PROW()+2,05 SAY "INFORMAMOS QUE:"
  @ PROW()+1,00 SAY "           - S¢ ‚ permitido o treinamento com uso de sapato ou tenis."
  @ PROW()+1,00 SAY "           - Aulas Te¢ricas: (no mesmo endere‡o - sala 206)"
  @ PROW()+1,00 SAY "           - Cobramos taxa administrativa para emissao de 2¦ Via."
  @ PROW()+4,05 SAY "_______________________"
  @ PROW()+1,05 SAY "      De acordo        "
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp 2VRECIBO.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE 2VRECIBO.TXT
  RETURN NIL
