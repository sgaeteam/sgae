*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_IMPR                          vrs 003 ≥
*≥ VRS 003        : Desenvolvimento                          ≥
*≥ FINALIDADE     : Configurar Impressoras                   ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ≥
*≥ DATA CRIACAO   : 04/01/1994                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"
#include "COMMAND.CH"

FUNCTION ConfigImpr(arq,prg,t,l,b,r,moldura)
   DEFAULT t       TO 8
   DEFAULT l       TO 28
   DEFAULT b       TO 17
   DEFAULT r       TO 47
   DEFAULT moldura TO 1

   aPrint := { {"Epson LX/FX/LQ","CHR(14)","CHR(20)","CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Citizen 200","CHR(27)+'W'+CHR(1)","CHR(27)+'W'+CHR(0)","CHR(27)+CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Rima Itautec","CHR(14)","CHR(20)","CHR(30)+CHR(52)","CHR(18)","CHR(30)+'O'"},;
               {"Elgin","CHR(27)+'[Ow'","CHR(27)+'[3w'","CHR(27)+'[7w'","CHR(27)+'[3w'","CHR(27)+'[7w'+CHR(27)+'[Ow'"},;
               {"Elebra","CHR(14)","CHR(20)","CHR(30)+CHR(52)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Diversos","CHR(14)","CHR(20)","CHR(17)","CHR(18)","CHR(19)"} ,;
               {"HP","CHR(27)+CHR(38)+CHR(107)+CHR(48)+CHR(83)","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)","CHR(27)+CHR(38)+CHR(107)+CHR(50)+CHR(83)","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)","CHR(27)+'&l8c'"} }

   USE (arq) NEW
   IF prg # NIL
      ProgName(prg)
   ENDIF
   
   Telas(t,l,b,r,moldura,YCORMENU,.T.)
   WHILE .T.
      SETCURSOR(0)
      SETCOLOR(YCORMENU)
      @ t+1,l+1 PROMPT "   Epson          " MESSAGE Msg("LX, FX e LQ")
      @ t+2,l+1 PROMPT "   Rima Padr∆o    " MESSAGE Msg("Okidata, XT180, XT250 ,XT300...")
      @ t+3,l+1 PROMPT "   Rima Itautec   " MESSAGE Msg("XT180, ML391...")
      @ t+4,l+1 PROMPT "   Elgin          " MESSAGE Msg("AmÇlia 250, EEnnn, Lady 90...")
      @ t+5,l+1 PROMPT "   Elebra         " MESSAGE Msg("Mìnica, Em°lia Plus")
      @ t+6,l+1 PROMPT "   Universal      " MESSAGE Msg("Diversos")
      @ t+7,l+1 PROMPT "   HP             " MESSAGE Msg("HP")
      @ t+8,l+1 PROMPT "   Outras         " MESSAGE Msg("Lasers, Jato de Tinta, LED ou Fus∆o TÇrmica (fabricantes diversos)")
      MENU TO nMenu_56

      IF nMenu_56 = 0
         Rest_Tela()
         DBCLOSEALL()
         RETURN
      ENDIF

      IF nMenu_56 > 0 .AND. nMenu_56 < 8
         Grv_Imp(nMenu_56)
      ELSEIF nMenu_56 = 8
         tela := SAVESCREEN(2,0,24,79)
         Area_Dados()
         Quadro(8,10,18,65,1,YCOREDIT,.T.,"Impressora do Usu†rio",.T.)
         SETCOLOR(YCOREDIT)
         Atrib_Var()

         SETCURSOR(1)
         @ 09,12 SAY "Consulte o manual do fabricante e informe:"
         @ 11,12 SAY "Impressora.........: "GET wImpressora VALID !EMPTY(wImpressora)
         @ 12,12 SAY "Ativa Expandido....: "GET wExpandOn   PICT "@S30"
         @ 13,12 SAY "Desativa Expandido.: "GET wExpandOff  PICT "@S30"
         @ 14,12 SAY "Ativa Condensado...: "GET wCompr_On   PICT "@S30"
         @ 15,12 SAY "Desativa Condensado: "GET wCompr_Off  PICT "@S30"
         @ 16,12 SAY "Impr.Meio Expandida: "GET wExpand_Med PICT "@S30"
         @ 17,12 SAY "Conex∆o USB (S/N)..: "GET wUSB        PICT "!"   VALID wUSB $"SN"
         READ
         SETCURSOR(0)

         IF LASTKEY() # 27
            IF NetLReg()
               REPLACE _FIELD->IMPRESSORA WITH wImpressora ,;
                       _FIELD->EXPANDON   WITH wExpandOn   ,;
                       _FIELD->EXPANDOFF  WITH wExpandOff  ,;
                       _FIELD->COMPR_ON   WITH wCompr_On   ,;
                       _FIELD->COMPR_OFF  WITH wCompr_Off  ,;
                       _FIELD->EXPAND_MED WITH wExpand_Med ,;
                       _FIELD->USB        WITH wUSB
               ProcOk("Configurado",.T.)
            ENDIF
         ENDIF
         RESTSCREEN(2,0,24,79,tela)
      ENDIF
   ENDDO
   RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Gravaáao da Configuraáao     ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC PROCEDURE Grv_Imp(vetor)
   IF NetLReg()
      REPLACE _FIELD->IMPRESSORA WITH aPrint[vetor,1],;
              _FIELD->EXPANDON   WITH aPrint[vetor,2],;
              _FIELD->EXPANDOFF  WITH aPrint[vetor,3],;
              _FIELD->COMPR_ON   WITH aPrint[vetor,4],;
              _FIELD->COMPR_OFF  WITH aPrint[vetor,5],;
              _FIELD->EXPAND_MED WITH aPrint[vetor,6],;
              _FIELD->USB        WITH wUSB
      Atrib_Var()
      ProcOk("Configurado",.T.)
   ENDIF
   RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Atribuiáao das Vari†veis     ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC PROCEDURE Atrib_Var()
  wImpressora := _FIELD->IMPRESSORA
  wExpandOn   := _FIELD->EXPANDON
  wExpandOff  := _FIELD->EXPANDOFF
  wCompr_On   := _FIELD->COMPR_ON
  wCompr_Off  := _FIELD->COMPR_OFF
  wExpand_Med := _FIELD->EXPAND_MED
  wUSB        := _FIELD->USB
  RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Contrato              ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ImpContrato(pCurso)
   LOCAL linha1:=linha2:="",xCol:=8

   /* Dados do Curso */
   CURSO->(DBSEEK(pCurso))

   Gera_TXT("CONTR.TXT"); SETPRC(0,0)
   @ PROW()+3,xCol   SAY Largo()+" "
   @ PROW()+1,xCol-8 SAY Negrito()+PADC(xRazao,65)
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()+1,xCol-4 SAY Denso_96()+PADC(cEnder1,80)
   @ PROW()+1,xCol-4 SAY PADC(cEnder3,80)
   @ PROW()+2,xCol-8 SAY Largo()+PADC("CONTRATO DE PRESTAÄ«O DE SERVIÄOS",65)
*   @ PROW()+1,xCol-8 SAY Normal()+PADC("MATRICULA Nß "+Negrito()+ALUNO->MATRIC,70)
*   @ PROW()+1,05 SAY PADC("EMISS«O :"+DTOC(DATE()),65)
*   @ PROW()+1,05 SAY PADC("VALIDADE:"+DTOC(CTOD(SUBS(DTOC(cDtSys),1,5)+"/"+RIGHT(STRZERO(YEAR(cDtSys)+1,4),2))),65)

   @ PROW()+3,xCol-1 SAY Normal()+"CONTRATANTE:"
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()  ,xCol-1 SAY "____________"
   @ PROW()+2,xCol   SAY Denso_96()+"NOME........: "+ALUNO->NOME
   @ PROW()+1,xCol   SAY "CPF.........: "+IF(!EMPTY(ALUNO->CPF),TRANSFORM(ALUNO->CPF,"@R 999.999.999-99")," ")
   @ PROW()  ,xCol+2 SAY "RG: "+IF(!EMPTY(ALUNO->RG),ALUNO->RG,"________________")
   @ PROW()+1,xCol   SAY "ENDEREÄO....: "+ALLTRIM(ALUNO->ENDERECO)
   @ PROW()+1,xCol   SAY "            : "+ALLTRIM(ALUNO->BAIRRO)+", "+ALLTRIM(ALUNO->CIDADE)+"-"+ALUNO->UF
   @ PROW()+1,xCol   SAY "MATRICULA Nß: "+ALUNO->MATRIC
   @ PROW()  ,xCol+8 SAY "EMISS«O : "+DTOC(DATE())
   @ PROW()  ,xCol+3 SAY "VALIDADE: "+DTOC(CTOD(SUBS(DTOC(cDtSys),1,5)+"/"+RIGHT(STRZERO(YEAR(cDtSys)+1,4),2)))

   @ PROW()+3,xCol-1 SAY Normal()+Negrito()+"CONTRATADA:"
   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
   @ PROW()  ,xCol-1 SAY "___________"
   @ PROW()+2,xCol   SAY Denso_96()+"RAZ«O SOCIAL: "+xRazao
   @ PROW()+1,xCol   SAY "ENDEREÄO....: "+Denso_96()+UPPER(cEnder1)
   @ PROW()+1,xCol   SAY "            : "+UPPER(cEnder2)
   @ PROW()+1,xCol   SAY "CNPJ........: "+SUBS(cCGC_MF,7,18)

*   @ PROW()+3,xCol-1 SAY Normal()+Negrito()+"VALOR DO CONTRATO:"
*   @ PROW()  ,xCol+1 SAY CHR(19)+CHR(18)
*   @ PROW()  ,xCol-1 SAY "__________________"
*   @ PROW()+2,xCol   SAY "=> R$ "+ALLTRIM(TRANSFORM(wValor,"@E 9,999.99"))+" ("
*   Imp_Extenso(wValor,LINHA1,LINHA)

*   @ PROW()+2,xCol   SAY Denso_96()+"As partes tem entre si justo  e  contratados a prestaá∆o de  serviáos abaixo"
*   @ PROW()+1,xCol   SAY "discriminados, mediante cl†usulas e condiá‰es adiante pactuadas:"

   @ PROW()+2,xCol   SAY Denso_96()+"O centro de formaá∆o de condutores COOPERATIVA  DE  TECNOLOGIA DE TRANSITO E"
   @ PROW()+1,xCol   SAY            "SAUDE - TECTRAN, por meio de seu  representante legal  abaixo firmado, dora-"
   @ PROW()+1,xCol   SAY            "vante simplesmente CONTRATADA e o aluno, por si e/ou por seu respons†vel le-"
   @ PROW()+1,xCol   SAY            "gal, doravante denominado ALUNO e CONTRATANTE, celebram  o presente contrato"
   @ PROW()+1,xCol   SAY            "mediante as cl†usulas e condiá‰es a seguir pactuadas."

   @ PROW()+2,xCol   SAY "CLµUSULA PRIMEIRA:"
   @ PROW()  ,xCol   SAY "__________________"
   @ PROW(),PCOL()+1 SAY                    " Constitui objeto deste contrato  a  prestaá∆o de serviáo"
   @ PROW()+1,xCol   SAY "de ensino  de CFC - Centro de formaá∆o de Condutores para  o  curso tÇcnico-"
   @ PROW()+1,xCol   SAY "te¢rico   e   pr†tico   de   direá∆o   veicular categorizado  como  educaá∆o"
   @ PROW()+1,xCol   SAY "assistem†tica, no n°vel, hor†rios e per°odos definidos de acordo com o plano"
   @ PROW()+1,xCol   SAY "de curso da CONTRATADA, com  professores  do seu  quadro de ensino, na carga"
   @ PROW()+1,xCol   SAY "hor†ria de "+ALLTRIM(STR(CURSO->TEORICA,2))+" horas aulas te¢ricas e "+ALLTRIM(STR(CURSO->PRATICA,2))+" horas aulas pr†ticas."

   @ PROW()+2,xCol   SAY "CLµUSULA SEGUNDA:"
   @ PROW()  ,xCol   SAY "_________________"
   @ PROW(),PCOL()+1 SAY                   " ê de inteira responsabilidade da CONTRATADA a orientaá∆o"
   @ PROW()+1,xCol   SAY "tÇcnica sobre  a  prestaá∆o  de  serviáos descritos  na  cl†usula anterior,"
   @ PROW()+1,xCol   SAY "precisamente no que  se  refere Ö definiá∆o de datas  para  verificaá‰es de"
   @ PROW()+1,xCol   SAY "aprendizagem  e  eficiància, fixaá∆o  de carga  hor†ria  (tÇcnico-te¢rica e"
   @ PROW()+1,xCol   SAY "pr†tica), indicaá∆o  did†tica alÇm de outras providàncias  que  as atitudes"
   @ PROW()+1,xCol   SAY "exigirem."

   @ PROW()+2,xCol   SAY "CLµUSULA TERCEIRA:"
   @ PROW()  ,xCol   SAY "__________________"
   @ PROW(),PCOL()+1 SAY                    " Em  contra  prestaá∆o  aos  serviáos  de  curso tÇcnico-"
   @ PROW()+1,xCol   SAY "te¢rico, ser† pago pelo CONTRATANTE o valor de R$ "+ALLTRIM(TRANSFORM(wValor,"@E 9,999.99"))
   @ PROW()+1,xCol   SAY "na forma constante do recibo."

   @ PROW()+2,xCol   SAY "CLµUSULA QUARTA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  " O  descumprimento  desta  cl†usula  pelo CONTRATANTE, onde"
   @ PROW()+1,xCol   SAY "torna-se inadimplente, desobriga  o  CONTRATADO  de  fornecer  os  serviáos,"
   @ PROW()+1,xCol   SAY "objeto do presente contrato."
   @ PROW()+1,xCol   SAY " "

   @ PROW()+2,xCol   SAY "CLµUSULA QUINTA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  " Quando a interrupá∆o dos serviáos ocorrer por culpa exclu-"
   @ PROW()+1,xCol   SAY "siva do CONTRATANTE, como a falta de pagametno ou qualquer outro motivo, n∆o"
   @ PROW()+1,xCol   SAY "surgir†  a  obrigaá∆o de repara∆„o por perdas e danos pelo CONTRATADO, muito"
   @ PROW()+1,xCol   SAY "menos devoluá∆o de qualquer valor pago."

   EJECT

   @ PROW()+4,xCol   SAY "CLµUSULA SEXTA:"
   @ PROW()  ,xCol   SAY "_______________"
   @ PROW(),PCOL()+1 SAY                 " Caso o CONTRATANTE abandone ou  deixe de frequentar o curso"
   @ PROW()+1,xCol   SAY "o mesmo fica integralmente respons†vel pelos pagamentos ora pactuados."

   @ PROW()+2,xCol   SAY "CLµUSULA SêTIMA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  " Quando houver pagamento  do serviáo mediante cheques, este"
   @ PROW()+1,xCol   SAY "na data acordada n∆o possuir fundos, dar† o direito Ö CONTRATADA de tomar as"
   @ PROW()+1,xCol   SAY "devidas providàncias legais, inclusive o direito a cobranáa e negativaá∆o do"
   @ PROW()+1,xCol   SAY "do nome do CONTRATANTE junto aos ¢rg∆os de proteá∆o ao  crÇdito, e suspender"
   @ PROW()+1,xCol   SAY "o fornecimento do serviáo, atÇ  a  devida  quitaá∆o da divida. Esta quitaá∆o"
   @ PROW()+1,xCol   SAY "dever† obedecer o prazo de um ano de vigància deste contrato. Caso finde e o"
   @ PROW()+1,xCol   SAY "CONTRATANTE n∆o termine o processo de habilitaá∆o, o contrato ser† rescindido."

   @ PROW()+2,xCol   SAY "CLµUSULA OITAVA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  " Para o serviáo de retirada de RENACH Ç estipulado uma taxa"
   @ PROW()+1,xCol   SAY "pelo ¢rg∆o do DETRAN-BA, bem como a marcaá∆o de exames mÇdicos e psicoteste."
   @ PROW()+1,xCol   SAY "Os valores cobrados  pelo DETRAN-BA  n∆o  possui   qualquer  v°nculo  com  a"
   @ PROW()+1,xCol   SAY "CONTRATADA, devendo o aluno ou CONTRATANTE arcar com estes custos."

   @ PROW()+2,xCol   SAY "CLµUSULA NONA:"
   @ PROW()  ,xCol   SAY "______________"
   @ PROW(),PCOL()+1 SAY                " A remarcaá∆o do exame de legislaá∆o ou pr†tico veicular,caso"
   @ PROW()+1,xCol   SAY "o aluno/CONTRATANTE  por qualquer motivo n∆o obtenha àxito no exame realiza-"
   @ PROW()+1,xCol   SAY "do, ser† cobrada uma taxa de R$ "+ALLTRIM(STR(CURSO->REM_P,6,2))+" referente aos custos administrativos."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA:"
   @ PROW()  ,xCol   SAY "________________"
   @ PROW(),PCOL()+1 SAY                  " Para realizar o exame pr†tico de direá∆o de quatro rodas a"
   @ PROW()+1,xCol   SAY "CONTRATADA cobrar† uma taxa no valor R$ __________ (_______________________)"
   @ PROW()+1,xCol   SAY "e para realizar  exame pr†tico  para  ve°culo  de  duas rodas a taxa ser† no"
   @ PROW()+1,xCol   SAY "valor de  R$ R$ __________ (_______________________), referente  aos  custos"
   @ PROW()+1,xCol   SAY "onerados a CONTRATADA. Contudo, caso  n∆o  haja aprovaá∆o no referido exame,"
   @ PROW()+1,xCol   SAY "ser† novamente cobrado a taxa do ve°culo somada a taxa de remarcaá∆o do exame."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA PRIMEIRA:"
   @ PROW()  ,xCol   SAY "_________________________"
   @ PROW(),PCOL()+1 SAY                           " O n∆o comparecimento do CONTRATANTE as horas aula"
   @ PROW()+1,xCol   SAY "ser† cobrado os respectivos valores de R$ "+ALLTRIM(STR(CURSO->REM_T,6,2))+" para remarcaá∆o  das  aulas"
   @ PROW()+1,xCol   SAY "te¢ricas e R$ "+ALLTRIM(STR(CURSO->REM_PC,6,2))+" para direá∆o veicular (quatro rodas)  e R$ "+ALLTRIM(STR(CURSO->REM_PM,6,2))+" para"
   @ PROW()+1,xCol   SAY "motocicleta, POR AULA, estas referentes a taxas de  remarcaá∆o. Reposiá∆o de"
   @ PROW()+1,xCol   SAY "aulas te¢ricas s¢  ser∆o feitas  em  novas  turmas  abertas pela CONTRATADA,"
   @ PROW()+1,xCol   SAY "respeitando-se o cronograma de aulas."

   EJECT

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA SEGUNDA:"
   @ PROW()  ,xCol   SAY "________________________"
   @ PROW(),PCOL()+1 SAY                          " Fica  isento da taxa de remarcaá∆o de aula o aluno"
   @ PROW()+1,xCol   SAY "CONTRATANTE que apresentar  atestado mÇdico ou comunicaá∆o prÇvia com 24h de"
   @ PROW()+1,xCol   SAY "antecedància."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA TERCEIRA:"
   @ PROW()  ,xCol   SAY "_________________________"
   @ PROW(),PCOL()+1 SAY                           " Ser†  cobrado  pela CONTRATADA uma taxa referente"
   @ PROW()+1,xCol   SAY "ao  simulado  eletrìnico, no  valor de R$ 65,00 (sessenta e cinco reais), em"
   @ PROW()+1,xCol   SAY "raz∆o da portaria 357 do DETRAN-BA, regulamentada pela RES. 358 do CONATRAN,"
   @ PROW()+1,xCol   SAY "a ser realizado na sede da CONTRATADA."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA QUARTA:"
   @ PROW()  ,xCol   SAY "_______________________"
   @ PROW(),PCOL()+1 SAY                         " O cancelamento da matrÌcula  somente ser†  admitido"
   @ PROW()+1,xCol   SAY "atÇ  o 5ß (quinto) dia ap¢s  a  assinatura  do contrato, devendo  ser  feito"
   @ PROW()+1,xCol   SAY "atravÇs de comunicaá∆o por escrito do CONTRATANTE, ficando  retida a taxa de"
   @ PROW()+1,xCol   SAY "30% (trinta por cento) sobre o valor  total  do curso, referente aos  custos"
   @ PROW()+1,xCol   SAY "de credenciamento, dentre outros. Caso  seja  solicitado  o  cancelamento no"
   @ PROW()+1,xCol   SAY "decorrer do processo de habilitaá∆o, ser†  feita uma estimativa proporcional"
   @ PROW()+1,xCol   SAY "do serviáo  prestado, devolvendo  ao CONTRATANTE  o  restante equivalente ao"
   @ PROW()+1,xCol   SAY "serviáo n∆o  prestado. Tal  devoluá~o  s¢ poder† ser feita atÇ  os primeiros"
   @ PROW()+1,xCol   SAY "seis meses de  validade do contrato, ap¢s, a CONTRATADA n∆o terÇ  mais obri-"
   @ PROW()+1,xCol   SAY "gaá∆o contratual  de efetuar qualquer tipo de devoluá∆o,restando t∆o somente"
   @ PROW()+1,xCol   SAY "ao CONTRATANTE, direito Ö prestaá∆o do serviáo."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA QUINTA:"
   @ PROW()  ,xCol   SAY "_______________________"
   @ PROW(),PCOL()+1 SAY                         " N∆o existe  a possibilidade  de  trancamento de ma-"
   @ PROW()+1,xCol   SAY "tr°cula a qualquer tempo durante vigància do contrato."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA SEXTA:"
   @ PROW()  ,xCol   SAY "______________________"
   @ PROW(),PCOL()+1 SAY                        " Se o n£mero  de  alunos  n∆o atender ao limite de 10"
   @ PROW()+1,xCol   SAY "matriculados, findo o per°odo de cancelamento, as turmas poder∆o  ser cance-"
   @ PROW()+1,xCol   SAY "ladas, devolvendo-se ao CONTRATANTE os valores j† pagos."

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA SêTIMA:"
   @ PROW()  ,xCol   SAY "_______________________"
   @ PROW(),PCOL()+1 SAY                         " ê obrigat¢rio ao CONTRATANTE ter 100% de frequància"
   @ PROW()+1,xCol   SAY "cia nos referidos cursos, conforme determina a legislaá∆o vigente. A CONTRA-"
   @ PROW()+1,xCol   SAY "TADA n∆o se responsabiliza por atrasos  ou faltas do CONTRATANTE decorrentes"
   @ PROW()+1,xCol   SAY "de engarrafamentos, passeatas, manifestaá‰es  populares  ou quaisquer outras"
   @ PROW()+1,xCol   SAY "situaá‰es fora de seu controle."

   EJECT

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA OITAVA:"
   @ PROW()  ,xCol   SAY "_______________________"
   @ PROW(),PCOL()+1 SAY                         " Ap¢s o resultado de exame de legislaá∆o  no DETRAN-"
   @ PROW()+1,xCol   SAY "BA o aluno CONTRATANTE dever† comunicar Ö CONTRATADA:"
   @ PROW()+1,xCol   SAY "  A) caso apto, o aluno  dever†  solicitar  a  LADV, mediante a apresentaá∆o"
   @ PROW()+1,xCol   SAY "     deste contrato."
   @ PROW()+1,xCol   SAY "  B) caso inapto, o aluno dever† solicitar a remarcaá∆o do exame de legisla-"
   @ PROW()+1,xCol   SAY "     á∆o, momento em que ser† cobrada a taxa respectiva de R$ _________.    "

   @ PROW()+2,xCol   SAY "CLµUSULA DêCIMA NONA:"
   @ PROW()  ,xCol   SAY "_____________________"
   @ PROW(),PCOL()+1 SAY                       " A parte  que infringir qualquer  cl†usula  contratual"
   @ PROW()+1,xCol   SAY "ficar† respons†vel  por  ressarcir a outra por todas  despesas realizadas, a"
   @ PROW()+1,xCol   SAY "exemplo  de   custas  judiciais, taxas, emolumentos, alÇm   da  cobertura de"
   @ PROW()+1,xCol   SAY "honor†rios advocat°cios no percentual de 20%, em caso de cobranáa extrajudi-"
   @ PROW()+1,xCol   SAY "cial ou judicial."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA:"
   @ PROW()  ,xCol   SAY "__________________"
   @ PROW(),PCOL()+1 SAY                    " O contrato tem como  data  de expiraá∆o o per°odo  de 12"
   @ PROW()+1,xCol   SAY "(doze) meses a contar da data da assinatura, cessando todas as responsabili-"
   @ PROW()+1,xCol   SAY "dades da CONTRATADA no final do presente termo."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA PRIMEIRA:"
   @ PROW()  ,xCol   SAY "___________________________"
   @ PROW(),PCOL()+1 SAY                             " O exame de legislaá∆o  e  de  direá∆o  veicular"
   @ PROW()+1,xCol   SAY "solicitado pela  CONTRATADA dever†  ser  confirmado  pelo CONTRATANTE em atÇ"
   @ PROW()+1,xCol   SAY "48h ap¢s a solicitaá∆o nos hor†rios de 09:00 as 12:00 e das 14:00 Ös 17:00. "
   @ PROW()+1,xCol   SAY "Caso o exame n∆o  seja  realizado  exclusivamente  por culpa do CONTRATANTE,"
   @ PROW()+1,xCol   SAY "ser† cabrada a taxa no valor de R$ 30,00 para a remarcaá∆o do exame e mais o"
   @ PROW()+1,xCol   SAY "valor de R$_________, relativo  aos  custos  administrativos  do  ve°culo. O"
   @ PROW()+1,xCol   SAY "CONTRATANTE poder† consultar todos seus exames atravÇs do sites do DETRAN-BA"
   @ PROW()+1,xCol   SAY "www.detran.ba.gov.br e/ou www.sindautobahia.com.br"

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA SEGUNDA:"
   @ PROW()  ,xCol   SAY "__________________________"
   @ PROW(),PCOL()+1 SAY                            " Caso  o  contratante necessite e queira adquirir"
   @ PROW()+1,xCol   SAY "aulas pr†ticas extras, ser† cobrada por aula pr†tica  de duas rodas o  valor"
   @ PROW()+1,xCol   SAY "de R$ "+ALLTRIM(STR(CURSO->REM_PM,6,2))+" e por aula  pr†tica de quatro  rodas o valor de R$ "+ALLTRIM(STR(CURSO->REM_PC,6,2))+". Por"
   @ PROW()+1,xCol   SAY "qualquer motivo n∆o justificado o CONTRATANTE falte  a aula prÇ-agendada n∆o"
   @ PROW()+1,xCol   SAY "haver† reembolso do valor."

   EJECT

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA TERCEIRA:"
   @ PROW()  ,xCol   SAY "___________________________"
   @ PROW(),PCOL()+1 SAY                             " Caso  o CONTRATANTE  n∆o  consiga, por qualquer"
   @ PROW()+1,xCol   SAY "motivo, terminar o processo de habilitaá∆o dentro do prazo  de  um ano, ser†"
   @ PROW()+1,xCol   SAY "cobrado ao mesmo uma taxa de R$ ________________(                          )"
   @ PROW()+1,xCol   SAY "a t°tulo de termo aditivo do contrato, o qual ser† renovado por mais 6(seis)"
   @ PROW()+1,xCol   SAY "AlÇm destes custos o CONTRATANTE ter† de arcar  com despesas junto Ö CLINICA"
   @ PROW()+1,xCol   SAY "autorizada pelo DETRAN-BA,  necess†rias  Ö  conclus∆o do processo de habili-"
   @ PROW()+1,xCol   SAY "taá∆o, porÇm tais cobranáas n∆o s∆o emanadas da CONTRATADA."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA QUARTA:"
   @ PROW()  ,xCol   SAY "_________________________"
   @ PROW(),PCOL()+1 SAY                           " Quaisquer pertences  do CONTRATANTE esquecidos ou"
   @ PROW()+1,xCol   SAY "deixados no interior da instituiá∆o ou  de ve°culos pertencentes Ö CONTRATA-"
   @ PROW()+1,xCol   SAY "DA, n∆o s∆o de responsabilidade da mesma."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA QUINTA:"
   @ PROW()  ,xCol   SAY "_________________________"
   @ PROW(),PCOL()+1 SAY                           " Obriga-se o CONTRATANTE a respeitar todas as nor-"
   @ PROW(),PCOL()+1 SAY "normas administrativas internas da CONTRATADA, sob  pena  de responsabiliza-"
   @ PROW(),PCOL()+1 SAY "á‰es legais pertinentes."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA SEXTA:"
   @ PROW()  ,xCol   SAY "________________________"
   @ PROW(),PCOL()+1 SAY                          " O CONTRATANTE declara ter tido  prÇvio conhecimen-"
   @ PROW(),PCOL()+1 SAY "mento de todas as cl†usulas do contrato, estando de  pleno acordo com todo o"
   @ PROW(),PCOL()+1 SAY "teor, compactuando-o de forma pessoal e instransfer°vel."

   @ PROW()+2,xCol   SAY "CLµUSULA VIGêSIMA SêTIMA:"
   @ PROW()  ,xCol   SAY "_________________________"
   @ PROW(),PCOL()+1 SAY                           "Fica eleito o foro da Comarca  desta Capital, para"
   @ PROW()+1,xCol   SAY "dirimir quaisquer d£vidas ou lit°gio decorrentes do  presente contrato, pre-"
   @ PROW()+1,xCol   SAY "valecendo  sobre  qualquer outro, por  mais  privilegiado que seja. Justas e"
   @ PROW()+2,xCol   SAY "contratadas, as partes assinam o presente instrumento  em duas vias de igual" 
   @ PROW()+1,xCol   SAY "teor e para um s¢ fim,  obrigando-se ao fiel cumprimento  por  si e por seus"
   @ PROW()+1,xCol   SAY "sucessores Ö  produá∆o dos devidos e legais efeitos."
   @ PROW()+3,xCol-4 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),80)
   @ PROW()+4,xCol   SAY "__________________________________          ________________________________"
   @ PROW()+1,xCol   SAY "      CONTRATADA - TECTRAN                          CONTRATANTE (Aluno)"
   @ PROW()+1,xCol   SAY "    CNPJ 05.115.111/0001-67                        CPF "+TRANSFORM(ALUNO->CPF,"@R 999.999.999-99")
   @ PROW()+1,xCol   SAY " "

*  ImpRecibo(.F.,TALUNO->MATRIC)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp contr.txt 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE CONTR.TXT
RETURN NIL
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
     @ PROW()+2,05 SAY "** ATENÄAO ** Ligar um dia antes para confirmar o teste"
     @ PROW()+1,05 SAY "              Aluno apto no retornar a escola p/pegar certificado."
     @ PROW()+1,05 SAY "              A falta do aluno acarretar† a perda da taxa paga."
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
