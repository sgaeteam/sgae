*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_331                           vrs 001 ≥
*≥ VRS 001        : Implantacao                              ≥
*≥ FINALIDADE     : Relatorio Programaá∆o do Instrutor       ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ≥
*≥ DATA CRIACAO   : 08/01/1996                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NUMERO","C", 02,0}) /* Numero da Aula       */
AADD(aDbf,{"MATRIC","C", 05,0}) /* Matricula do Aluno   */
AADD(aDbf,{"ALUNO" ,"C", 50,0}) /* Nome do Aluno        */
AADD(aDbf,{"HORA"  ,"C", 04,0}) /* Hora Prevista        */
AADD(aDbf,{"DTCONT","D", 07,0}) /* Data da desmarcacao  */
AADD(aDbf,{"EMBARQ","C", 25,0}) /* Local de Embarque    */
AADD(aDbf,{"OBS"   ,"C", 12,0}) /* Observacao           */
AADD(aDbf,{"SIT"   ,"C", 01,0}) /* Situacao             */
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
INDEX ON hora TO (cArq1)

SELECT 30
IF NetUse("DBCP","CP")               /* Conteudo Programatico */
   SET INDEX TO DBICP1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Ve°culos */
   SET INDEX TO DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Alunos */
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
SET FILTER TO INSTRUTOR->STATUS=="A" .AND. (INSTRUTOR->CATEG="1".OR.INSTRUTOR->CATEG="3")

SELECT 21
IF NetUse("DBDESM","DESMARCA")       /* Desmarcaá∆o de Aulas */
   SET INDEX TO DBIDES2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")          /* Programaá∆o de Aulas Praticas */
   SET INDEX TO DBIPRO2
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE331";ProgName(cPrg)
wDat:=IF(DOW(DATE()+1)==7,DATE()+2,DATE()+1); wNom:=SPACE(4)
SET KEY -1 TO Mostra()
WHILE .T.
   SETCOLOR(YCOREDIT); wDevice:="T"; LinhaMsg(2)
   Telas(4,3,8,75,1,YCOREDIT,.T.,"Relat¢rio de Programaá∆o de Instrutores Pr†ticos")
   Mensagem("Informe o Codigo do Instrutor")
   @ 05,05 SAY "Instrutor:" GET wNom    PICT "9999" WHEN TeclaFuncao(.T.);
     VALID !EMPTY(wNom).AND.TDescr(2,1,5,21,wNom,"NOME",["@S40"],"Matr°cula N∆o Localizada")
   @ 06,05 SAY "     Data:" GET wDat    PICT "@D"   WHEN TeclaFuncao() VALID !EMPTY(wDat)
   @ 07,05 SAY "    Sa°da:" GET wDevice PICT "!"    WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao(); Mensagem()
   IF LASTKEY()==K_ESC
      IF LEN(Telas)==4; Rest_Tela(); ENDIF
      EXIT
   ENDIF
   lTemVeic:=.F.

   IF AULAS->(DBSEEK(wNom+DTOS(wDat)))  //Codigo do instrutor+data da aula
      WHILE AULAS->CODINST==wNom.AND.!AULAS->(EOF())
         IF VEICULO->(DBSEEK(wNom))
            WHILE !VEICULO->(EOF())
               IF VEICULO->STATUS=="A"
                  lTemVeic:=.T.; EXIT
               ENDIF
               VEICULO->(DBSKIP())
            ENDDO
         ENDIF
         IF AULAS->DATA==wDat
            IF lTemVeic
               IF AULAS->CODVEIC==VEICULO->CODVEIC //.AND.!AULAS->STATUS
                  /* Alimentar arq. tempor†rio */
                  (cArq1)->(DBAPPEND())
                  REPLACE (cArq1)->ALUNO  WITH TAluno(AULAS->MATRIC),;
                          (cArq1)->MATRIC WITH AULAS->MATRIC,;
                          (cArq1)->NUMERO WITH AULAS->NUMERO,;
                          (cArq1)->HORA   WITH AULAS->HORA,;
                          (cArq1)->SIT    WITH IF(!AULAS->STATUS,"N","F"),;
                          (cArq1)->EMBARQ WITH IF(AULAS->EMBARQ=="E","ESCOLA",IF(AULAS->EMBARQ=="O",AULAS->LOCAL,IF(AULAS->EMBARQ=="P","PCA NS LUZ","RESIDENCIA")))
               ENDIF
            ELSE
               /* Alimentar arq. tempor†rio */
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->ALUNO  WITH TAluno(AULAS->MATRIC),;
                       (cArq1)->MATRIC WITH AULAS->MATRIC,;
                       (cArq1)->NUMERO WITH AULAS->NUMERO,;
                       (cArq1)->HORA   WITH AULAS->HORA,;
                       (cArq1)->SIT    WITH IF(!AULAS->STATUS,"N","F"),;
                       (cArq1)->EMBARQ WITH IF(AULAS->EMBARQ=="E","ESCOLA",IF(AULAS->EMBARQ=="O",AULAS->LOCAL,IF(AULAS->EMBARQ=="P","PCA NS LUZ","RESIDENCIA")))
            ENDIF
         ENDIF
         AULAS->(DBSKIP())
      ENDDO

      // Horarios desmarcados
      IF DESMARCA->(DBSEEK(wNom+DTOS(wDat)))
         VEICULO->(DBSEEK(wNom))
         WHILE DESMARCA->CODINST==wNom.AND.!DESMARCA->(EOF())
            IF DESMARCA->DATA==wDat
               IF DESMARCA->CODVEIC==VEICULO->CODVEIC
                  /* Alimentar arq. tempor†rio */
                  (cArq1)->(DBAPPEND())
                  REPLACE (cArq1)->ALUNO  WITH TAluno(DESMARCA->MATRIC),;
                          (cArq1)->MATRIC WITH DESMARCA->MATRIC,;
                          (cArq1)->NUMERO WITH DESMARCA->NUMERO,;
                          (cArq1)->HORA   WITH DESMARCA->HORA,;
                          (cArq1)->DTCONT WITH DESMARCA->DTCONT,;
                          (cArq1)->SIT    WITH "D"
               ENDIF
            ENDIF
            DESMARCA->(DBSKIP())
         ENDDO
      ENDIF

      IF wDevice=="I"
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpProgInstr()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress∆o, tecle algo...")
         ENDIF
      ELSE
         ProgInst()
      ENDIF
      (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   ELSE
      Aviso("N∆o h† Programaá∆o para este Instrutor...",,3)
   ENDIF
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Imprimir Programaá∆o do Instrutor≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ImpProgInstr()
  Gera_TXT("PROGINST.TXT"); SETPRC(0,0)
  Compr_On()
  @ PROW()+1,05 SAY UPPER(cRazao1)
  @ PROW()+1,05 SAY cEnder3
  @ PROW()+1,05 SAY REPLICATE("-",125)
  @ PROW()+1,05 SAY PADC("** PROGRAMACAO AULAS PRATICAS EM "+DTOC(wDat)+" ***",125)
  @ PROW()+1,05 SAY REPLICATE("-",125)
  @ PROW()+1,05 SAY "Data.....: "+IF(nNivel==9,DTOC(wDat-1),DTOC(DATE()))
  @ PROW()  ,58 SAY "Operador.: "+cUsuario
  @ PROW() ,100 SAY "Hora.....: "+TIME()
  @ PROW()+1,05 SAY "Instrutor: "+INSTRUTOR->NOME
  @ PROW() ,100 SAY "Matricula: "+wNom
  IF EMPTY(VEICULO->MARCA)
     @ PROW()+1,05 SAY "Veiculo..: NAO ASSOCIADO AO INSTRUTOR"
  ELSE
     @ PROW()+1,05 SAY "Veiculo..: "+VEICULO->MARCA
  ENDIF
  Compr_On()
  @ PROW()+1,05 SAY REPLICATE("-",125)
  @ PROW()+1,05 SAY "HORA  AULA NOME DO ALUNO                                  ASSINATURA COMPLETA DO ALUNO                     ASS.INSTRUTOR"
*                    99:99 99a. XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx    ----------__________----------__________-----   ---------__________-----
*                    56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                         1         2         3         4         5         6         7         8         9        10        11        12        13

  @ PROW()+1,05 SAY REPLICATE("-",125)

  vMarca := VEICULO->MARCA
  IF SUBS(vMarca,1,4)=="MOTO"
     vCateg:="A"
  ELSE
     vCateg:="B"
  ENDIF

  (cArq1)->(DBGOTOP())
  WHILE !(cArq1)->(EOF())
     Compr_On()
     IF CP->(DBSEEK((cArq1)->NUMERO+vCateg))
        vCP := CP->CP
     ELSE
        vCp := "REFORCO"
     ENDIF

     @ PROW()+1,05 SAY (cArq1)->HORA PICT "@R 99:99"
     @ PROW()  ,11 SAY (cArq1)->NUMERO+"a."
     @ PROW()  ,16 SAY (cArq1)->ALUNO  PICT "@S40"
     IF (cArq1)->SIT=="D"
        @ PROW(),101 SAY "** DESMARCADA EM "+DTOC((cArq1)->DTCONT) +" **"
     ELSE
*        @ PROW()  ,43 SAY (cArq1)->EMBARQ PICT "@S10"
        @ PROW(), 60 SAY REPLICATE("_",45)
        @ PROW(),113 SAY REPLICATE("_",15)
     ENDIF
     @ PROW()+1,05 SAY "CONTEUDO: "+vCP
     @ PROW()+1,05 SAY " "
     (cArq1)->(DBSKIP())
  ENDDO
  @ PROW()+1,05 SAY REPLICATE("=",125)
  @ PROW()+1,05 SAY PADC("INSERCOES DE AULAS FORA DA PROGRAMACAO",125)
  @ PROW()+1,05 SAY REPLICATE("-",125)
    @ PROW()+1,05 SAY "HORA  AULA NOME DO ALUNO                                  ASSINATURA COMPLETA DO ALUNO                     ASS.INSTRUTOR"
  @ PROW()+1,05 SAY REPLICATE("-",125)
  FOR i = 1 TO 3
*    @ PROW()+1,05 SAY "HORA  AULA NOME DO ALUNO                                           ASSINATURA DO ALUNO                        ASS.INSTRUTOR"
     @ PROW()+2,05 SAY "____:____  _______________________________________     __________________________________________________   __________________"
*                       99:99 99a. XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
*                                  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 
*                       56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                            1         2         3         4         5         6         7         8         9        10        11        12        13
  NEXT

  @ PROW()+2,05 SAY "HORARIO SAIDA   DA GARAGEM ______ hs    KMS _________ VISTO _______       **************** ABASTECIMENTO ******************"
  @ PROW()+1,05 SAY "HORARIO CHEGADA DA GARAGEM ______ hs    KMS _________ VISTO _______       LITROS ______  KMS ______  VALOR R$ _________,___"
  @ PROW()+1,05 SAY "                                                                          GNV(M3)______  KMS ______  VALOR R$ _________,___"
  @ PROW()+1,05 SAY "                                                                          DATA: ____/____/_____      HORA:    _____:_____"
  @ PROW()+2,05 SAY "OBS: EM CASO DE HORARIO VAGO, FAVOR RETORNAR PARA A AUTO-ESCOLA E COLOCAR A CHAVE NO QUADRO"
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp PROGINST.TXT 80 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE PROGINST.TXT
  RETURN NIL
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Programaá∆o em Tela            ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
FUNCTION ProgInst()
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(7,3,18,75,1,YCOREDIT,.T.); LinhaMsg(7)
  Telas(18,3,20,75,1,YCOREDIT,.T.); LinhaMsg(7)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")
  @ 19,05 SAY "N = Normal,  D = Desmarcada, F = Falta"
* @ 07,05 SAY wDat PICT "@D"
* @ 07,13 SAY "- "+INSTRUTOR->NOME

  oBr:=TBROWSEDB(8,4,17,75)
  oBr:headSep:="ƒ¬ƒ"
  oBr:colSep:= " ≥ "

  oCol:=TBCOLUMNNEW("Sit."    ,{|| SIT})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"    ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno"   ,{|| TRANSFORM(ALUNO,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Embarque",{|| TRANSFORM(EMBARQ,"@S15")})
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
           ImpProgInstr()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de Impress∆o, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(2)
  RETURN
