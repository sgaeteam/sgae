*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : RC_370                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Contrato de Prestacao de Servico         ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 30/10/1997                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()

ProgName("RC370"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "70"
SET KEY -1 TO Mostra()
cPrg:="RC370"
wNome:=SPACE(55); wEndereco1:=wEndereco2:=SPACE(73)
wAulasP:=wAulasT:=wValor:=wDinheiro:=wPredatado:=0
wdia1:=wdia2:=wdia3:="  /  /  "
wOptou:=" "
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(9,5,17,75,1,YCOREDIT,.T.," Contratante ")
   @ 10,07 SAY "    Nome:"           GET wNome      PICT "@!"    VALID !EMPTY(wNome)
   @ 11,07 SAY "Endereco:"           GET wEndereco1 PICT "@!S55" VALID LASTKEY()=K_UP.OR.!EMPTY(wEndereco1)
   @ 12,07 SAY "         "           GET wEndereco2 PICT "@!S55"
   @ 13,07 SAY "Aulas Pr ticas:"     GET wAulasP    PICT "99"    VALID LASTKEY()=K_UP.OR.!EMPTY(wAulasP)
   @ 13,37 SAY "Aulas Te¢ricas:"     GET wAulasT    PICT "99"    VALID LASTKEY()=K_UP.OR.!EMPTY(wAulasT)
   @ 14,07 SAY "Valor:"              GET wValor     PICT "@R 9,999.99" VALID LASTKEY()=K_UP.OR.!EMPTY(wValor)
   @ 15,07 SAY "Cheque(s):"
   @ 15,20 SAY "1§:"                 GET wdia1      PICT "99/99/99" VALID LASTKEY()=K_UP.OR.!EMPTY(wDia1)
   @ 15,34 SAY "2§:"                 GET wdia2      PICT "99/99/99" VALID LASTKEY()=K_UP.OR.!EMPTY(wDia2)
   @ 15,48 SAY "3§:"                 GET wdia3      PICT "99/99/99" VALID LASTKEY()=K_UP.OR.!EMPTY(wDia3)
   @ 16,07 SAY "Optou Carteira:"     GET wOptou     PICT "!"        VALID LASTKEY()=K_UP.OR.wOptou $ "SN"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   IF ChkImpr()
     cAviso := MsgImp()
     ImpContrato()
     TiraMsgImp(cAviso)
     WaitMsg("Fim de Impress„o, tecle algo...")
     Mensagem()
   ENDIF
   Rest_Tela()
ENDDO
RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Contrato              ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION ImpContrato()
   LOCAL linha1:=linha2:=""
   Gera_TXT("CTRATOPS.TXT"); SETPRC(0,0)
   pg := 0
   Expand_On()
   @ PROW()+3,00 SAY PADC("CONTRATO DE PRESTA€AO",40)
   @ PROW()  ,00 SAY PADC("CONTRATO DE PRESTA€AO",40)
   @ PROW()+1,00 SAY PADC("DE SERVI€OS",40)
   @ PROW()  ,00 SAY PADC("DE SERVI€OS",40)
   Expand_Off()
   @ PROW()+9,03 SAY "O CFC PROGRESSO LTDA, estabelecida nesta Capital, na RUA GOIAS, n§ 47,"
*                   1234567890123456789012345678901234567890123456789012345678901234567890123456789
*                            1         2         3         4         5         6         7
   @ PROW()+1,03 SAY "CASA, 1§ ANDAR, Pituba, doravante   denominada  C O N T R A T A D A   e"
   @ PROW()+1,03 SAY ALLTRIM(wNome)+REPL("_",66-LEN(ALLTRIM(wNome)))+" sito …,"
   @ PROW()+1,03 SAY ALLTRIM(wEndereco1)+REPL("_",73-LEN(ALLTRIM(wEndereco1)))
   IF !EMPTY(wEndereco2)
      @ PROW()+1,03 SAY wEndereco2
   ENDIF
   @ PROW()+1,03 SAY "doravante denominado CONTRATANTE, tˆm justo e contratado o seguinte:"

   @ PROW()+2,03 SAY "CLAUSULA PRIMEIRA -"
   @ PROW()  ,03 SAY "CLAUSULA PRIMEIRA -"
   @ PROW()  ,03 SAY "                     A CONTRATADA   se   obriga   a  prestar  servi‡os  de"
   @ PROW()+1,03 SAY "aprendizagem para motorista, com "+STR(wAulasP,2)+" aulas  praticas e "+STR(wAulasT,2)+" aulas te¢ricas com"
   @ PROW()+1,03 SAY "dura‡ao de 50 minutos, sendo 10 minutos destinados  ao  percurso  de ida e"
   @ PROW()+1,03 SAY "volta ao local de treinamento, totalizando 1 hora."

   @ PROW()+2,03 SAY "CLAUSULA SEGUNDA  -"
   @ PROW()  ,03 SAY "CLAUSULA SEGUNDA  -"
      @ PROW()  ,03 SAY "                     O CONTRATANTE, pagar   pelos servi‡os prestados, a"
   @ PROW()+1,03 SAY "importƒncia de R$ "+STR(wValor)+" ("

   Imp_Extenso(wValor,LINHA1,LINHA2)

   @ PROW()+1,03 SAY "neste ato ou cheques predatados para os  dias "+wDia1+", "+wDia2+", "+wDia3
   @ PROW()+1,03 SAY "ou no cartao.O CONTRATANTE "+IF(wOptou=="N","NAO ","")+"optou em utilizar os servi‡os da CONTRATADA"
   @ PROW()+1,03 SAY "para tramita‡ao da documenta‡ao destinada a obten‡ao da Carteira  de Habi-"
   @ PROW()+1,03 SAY "lita‡ao junto ao DETRAN."
   IF wOptou=="S"
      @ PROW()+1,03 SAY "O CONTRATANTE dever  fornecer a documenta‡ao necess ria  e exigida pelo"
      @ PROW()+1,03 SAY "pelo ¢rgao."
   ENDIF

   @ PROW()+2,03 SAY "CLAUSULA TERCEIRA -"
   @ PROW()  ,03 SAY "CLAUSULA TERCEIRA -"
   @ PROW()  ,03 SAY "                    Se obriga o CONTRATANTE a seguir  e cumprir  todas  as"
   @ PROW()+1,03 SAY "normas de trƒnsito e de seguran‡a passadas pela CONTRATADA, devendo, obri-"
   @ PROW()+1,03 SAY "gatoriamente,usar o cinto de seguran‡a, sapato ou tˆnis, bem como observar"
   @ PROW()+1,03 SAY "todas as orienta‡oes do instrutor, sob  pena  de  responder  pelas  multas"
   @ PROW()+1,03 SAY "advindas."

   @ PROW()+2,03 SAY "CLAUSULA QUARTA   -"
   @ PROW()  ,03 SAY "CLAUSULA QUARTA   -"
   @ PROW()  ,03 SAY "                    No ato da matr¡cula e do pagamento, o  CONTRATANTE re-"
   @ PROW()+1,03 SAY "ceber  a programa‡ao de aulas, onde constarao  dia  e  hora destinadas  ao"
   @ PROW()+1,03 SAY "treinamento, bem como o local destinado ao  visto  do  instrutor, que ser "
   @ PROW()+1,03 SAY "aposto ap¢s cada aula. Em caso de perda ou  extravio  da  programa‡ao ser "
   @ PROW()+1,03 SAY "cobrada taxa administrativa para emissao da segunda via."

   @ PROW()+2,03 SAY "CLAUSULA QUINTA   -"
   @ PROW()  ,03 SAY "CLAUSULA QUINTA   -"
   @ PROW()  ,03 SAY "                    Os dias previamente designados  para instru‡ao e trei-"
   @ PROW()+1,03 SAY "namento s¢ poderao ser remarcadas com antecedˆncia  m¡nima de 24 horas,ca-"
   @ PROW()+1,03 SAY "so contr rio, a aula ser  considerada como dada, nao  tendo, o CONTRATANTE"
   @ PROW()+1,03 SAY "direito a reposi‡ao ou remarca‡ao, nem devolu‡ao  da quantia paga, uma vez"
   @ PROW()+1,03 SAY "que a CONTRATADA est  destinando o hor rio e o instrutor  para  aquele dia"
   @ PROW()+1,03 SAY "prefixado, deixando de atender outros clientes."

   @ PROW()+2,03 SAY "CLAUSULA SEXTA    -"
   @ PROW()  ,03 SAY "CLAUSULA SEXTA    -"
   @ PROW()  ,03 SAY "                    O CONTRATANTE dever  concluir o curso no  prazo m ximo"
   @ PROW()+1,03 SAY "de 90 (noventa) dias a partir da matr¡cula, sob penas da CLAUSULA SETIMA."

   @ PROW()+2,03 SAY "CLAUSULA SETIMA   -"
   @ PROW()  ,03 SAY "CLAUSULA SETIMA   -"
   @ PROW()  ,03 SAY "                    Em caso de desistˆncia o CONTRATANTE far  juz  … devo-"
   @ PROW()+1,03 SAY "lu‡ao de 80% (Oitenta por Cento) do valor pago proporcionalmente ao n£mero"
   @ PROW()+1,03 SAY "de aulas dadas, observando o disposto na CLAUSULA QUINTA."

   EJECT

   @ PROW()+2,03 SAY "CLAUSULA OITAVA   -"
   @ PROW()  ,03 SAY "CLAUSULA OITAVA   -"
   @ PROW()  ,03 SAY "                    As aulas te¢ricas serao ministradas  na  sede  da Auto"
   @ PROW()+1,03 SAY "Escola, …s ter‡as, quartas e quintas-feiras, nos hor rios de: 10:00, 11:00"
   @ PROW()+1,03 SAY "16:00, 17:00 e 18:00 horas."

   @ PROW()+2,03 SAY "CLAUSULA NONA     -"
   @ PROW()  ,03 SAY "CLAUSULA NONA     -"
   @ PROW()  ,03 SAY "                    Fica eleito o Foro da Comarca de Salvador para dirimir"
   @ PROW()+1,03 SAY "quaisquer d£vidas oriundas do presente Contrato."

   @ PROW()+3,25 SAY "Salvador, "+SUBS(DTOC(DATE()),1,2)+" de "+ExtMes(DATE())+" de "+STR(YEAR(DATE()),4)
   @ PROW()+4,03 SAY REPL("Ä",50)
   @ PROW()+1,03 SAY "CONTRATANTE"
   @ PROW()+4,03 SAY REPL("Ä",50)
   @ PROW()+1,03 SAY "CONTRATADA"
   @ PROW()+4,03 SAY "TESTEMUNHAS"
   @ PROW()+3,03 SAY REPL("Ä",50)
   @ PROW()+3,03 SAY REPL("Ä",50)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp ctratops.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CTRATOPS.TXT
RETURN NIL
