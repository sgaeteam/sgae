*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_391                           vrs 001 ≥
*≥ VRS 001        : Implantacao                              ≥
*≥ FINALIDADE     : Relatorio Horas Extras por Instrutor     ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ≥
*≥ DATA CRIACAO   : 08/10/2000                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"CODINST","C", 04,0}) /* C¢d.Instrutor     */
AADD(aDbf,{"ALUNO"  ,"C", 50,0}) /* Nome do Aluno     */
AADD(aDbf,{"DATA"   ,"D", 08,0}) /* Data da Aula      */
AADD(aDbf,{"HORA"   ,"C", 04,0}) /* Hora Prevista     */
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
INDEX ON codinst+DTOS(data) TO (cArq1)

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Cadastro de Ve°culos */
   SET INDEX TO DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBPROG","AULAS")        /* Arquivo de Programaá∆o de Aulas */
   SET INDEX TO DBIPRO1,DBIPRO2,DBIPRO3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")      /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBEXTRA","EXTRA")         /* Horas Extras de Instrutores */
   SET INDEX TO DBIEXT1
ELSE
   DelDbfNtx(); RETURN
ENDIF

ProgName("AE391"); cOpHelp1 := "3"; cOpHelp2 := "91"
wPerIni:=DATE()-30; wPerFim:=DATE(); wNom:=SPACE(4)
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT); wDevice:="T"; LinhaMsg(2)
   Telas(4,3,8,68,1,YCOREDIT,.T.,"Relat¢rio de Horas Extras de Instrutores")
   Mensagem("Informe a Matr°cula do Instrutor")
   @ 05,05 SAY "Matr°cula:" GET wNom    PICT "9999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wNom).AND.TDescr(2,1,5,21,wNom,"NOME",["@S40"],"Matr°cula N∆o Localizada")
   @ 06,05 SAY "  Per°odo:" GET wPerIni PICT "@D"   WHEN TeclaFuncao() VALID !EMPTY(wPerIni)
   @ 06,27 SAY "a"          GET wPerFim PICT "@D"                      VALID wPerFim>=wPerIni.AND.wPerFim<=DATE()
   @ 07,05 SAY "    Sa°da:" GET wDevice PICT "!"    WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Mensagem()
   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   SET SOFTSEEK ON
   IF EXTRA->(DBSEEK(wNom+DTOS(wPerIni)),.T.)
      Aguarde("Pesquisando...")
      WHILE EXTRA->CODINST==wNom.AND.!EXTRA->(EOF())
         IF EXTRA->DATA>=wPerIni.AND.EXTRA->DATA<=wPerFim
            /* Alimentar arq. tempor†rio */
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->ALUNO  WITH EXTRA->ALUNO,;
                    (cArq1)->DATA   WITH EXTRA->DATA,;
                    (cArq1)->HORA   WITH EXTRA->HORA
         ENDIF
         EXTRA->(DBSKIP())
      ENDDO
      Aguarde()
      IF wDevice=="I"
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpExtraInstr()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress∆o, tecle algo...")
         ENDIF
      ELSE
         ExtraInst()
      ENDIF
      (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   ELSE
      Aviso("N∆o h† Horas Extras deste Instrutor...",,3)
   ENDIF
   SET SOFTSEEK OFF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Relatorio de Horas Extras ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION ImpExtraInstr()
  Gera_TXT("HREXTRA.TXT"); SETPRC(0,0)
  Compr_Off()
  Cab_391()

  (cArq1)->(DBGOTOP())
  wData:=(cArq1)->DATA;lFlag:=.T.;nTot:=0; nDN:=nSab:=0
  WHILE !(cArq1)->(EOF())
     IF wData#(cArq1)->DATA.OR.lFlag
        IF !lFlag; @ PROW()+1,05 SAY REPLICATE("ƒ",75); ENDIF
        @ PROW()+1,05 SAY (cArq1)->DATA
        wData:=(cArq1)->DATA;lFlag:=.F.;nTot++
     ELSE
        @ PROW()+1,05 SAY " "
        nTot++
     ENDIF
     IF DOW((cArq1)->DATA)==7    // Sabado
        nSab++
     ELSEIF DOW((cArq1)->DATA)#1.AND.DOW((cArq1)->DATA)#7  // Dias Normais
        nDN++
     ENDIF
     @ PROW(),16 SAY (cArq1)->ALUNO
     @ PROW(),67 SAY (cArq1)->HORA   PICT "@R 99:99"
     (cArq1)->(DBSKIP())
     IF PROW()>57
        @ PROW()+1,05 SAY REPLICATE("ƒ",75)
        @ PROW()+1,05 SAY "Continua..."
        EJECT;Cab_391()
     ENDIF
  ENDDO
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  @ PROW()+1,05 SAY " "
  @ PROW()+1,05 SAY "⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¬ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø"
  @ PROW()+1,05 SAY "≥    Dias Normais     ≥     Sabados      ≥       Total      ≥"
  @ PROW()+1,05 SAY "√ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ≈ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥"
  @ PROW()+1,05 SAY "≥                     ≥                  ≥                  ≥"
  @ PROW()  ,14 SAY nDN  PICT "@E 999"
  @ PROW()  ,35 SAY nSab PICT "@E 999"
  @ PROW()  ,55 SAY nTot PICT "@E 9,999"
  @ PROW()+1,05 SAY "¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¡ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ"
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp hrextra.txt 80 pre
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE HREXTRA.TXT
  RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Cabecalho do Relatorio             ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION Cab_391()
  @ PROW()+1,05 SAY UPPER(cRazao1)
  @ PROW()+1,05 SAY cEnder1
  @ PROW()+1,05 SAY cEnder3
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  @ PROW()+1,05 SAY PADC("** RELATORIO DE HORAS EXTRAS EM "+DTOC(wPerIni)+" a "+DTOC(wPerFim)+" ***",75)
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  @ PROW()+1,05 SAY "     Data: "+DTOC(DATE())
  @ PROW()  ,27 SAY "Hora: "+TIME()
  @ PROW()+1,05 SAY " Operador: "+cUsuario
  @ PROW()+1,05 SAY "Instrutor: "+INSTRUTOR->NOME
  @ PROW()  ,65 SAY "Matricula: "+wNom
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  @ PROW()+1,05 SAY "DATA       ALUNO                                              HORA"
*                    99/99/9999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 99:99
*                    5678901234567890123456789012345678901234567890123456789012345678901234567890
*                         1         2         3         4         5         6         7         8
  @ PROW()+1,05 SAY REPLICATE("ƒ",75)
  RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Browse Estat°stico do Instrutor ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
STATIC FUNCTION Estat_Inst()
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(7,3,19,68,1,YCOREDIT,.T.); LinhaMsg(7)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
* @ 07,05 SAY wDat PICT "@D"
* @ 07,13 SAY "- "+INSTRUTOR->NOME

  oBr:=TBROWSEDB(8,4,18,67)
  oBr:headSep:="ƒ¬ƒ"
  oBr:colSep:= " ≥ "

  oCol:=TBCOLUMNNEW("Data"    ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"    ,{|| TRANSFORM(HORA,"@R 99:00")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno"   ,{|| TRANSFORM(ALUNO,"@S30")})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F9 )     /* Imprimir */
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpExtraInstr()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de Impress∆o, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Programaá∆o em Tela            ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
stati FUNCTION ExtraInst()
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(7,3,19,68,1,YCOREDIT,.T.); LinhaMsg(7)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
* @ 07,05 SAY wDat PICT "@D"
* @ 07,13 SAY "- "+INSTRUTOR->NOME

  oBr:=TBROWSEDB(8,4,18,67)
  oBr:headSep:="ƒ¬ƒ"
  oBr:colSep:= " ≥ "

  oCol:=TBCOLUMNNEW("Aluno"   ,{|| TRANSFORM(ALUNO,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data"    ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"    ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F8 )     /* Imprimir */
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           ImpExtraInstr()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de Impress∆o, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
