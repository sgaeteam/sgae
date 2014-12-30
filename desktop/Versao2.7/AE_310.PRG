*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_310                           vrs 001 ณ
*ณ FINALIDADE     : Lista de Alunos                          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 09/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Nome do Aluno            */
AADD(aDbf,{"MATRIC"   ,"C",   05,0}) /* Matricula do Aluno       */
AADD(aDbf,{"ENDERECO" ,"C",   50,0}) /* Endereo Residencial     */
AADD(aDbf,{"CIDADE"   ,"C",   30,0})
AADD(aDbf,{"BAIRRO"   ,"C",   20,0})
AADD(aDbf,{"UF"       ,"C",   02,0})
AADD(aDbf,{"CEP"      ,"C",   08,0})
AADD(aDbf,{"CPF"      ,"C",   11,0})
AADD(aDbf,{"RG"       ,"C",   10,0})
AADD(aDbf,{"FONE_R"   ,"C",   10,0}) /* Telefone residencial     */
AADD(aDbf,{"FONE_C"   ,"C",   10,0}) /* Telefone comercial       */
AADD(aDbf,{"CELULAR"  ,"C",   08,0}) /* Telefone pessoal         */
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
INDEX ON nome TO (cArq1)

SELECT 2
IF NetUse("DBPROG","AULAS")         /* Cadastro de Programcao */
   SET INDEX TO DBIPRO1,DBIPRO2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBALU","ALUNOS")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU2
ELSE
   DelDbfNtx(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE310"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "10"

Quadro(12,20,17,50,1,YCOREDIT,.T.,,.T.)
wOp1:=wOp2:=wDevice:=" "
SETCOLOR(YCOREDIT)
@ 13,22 SAY "(   )  Em aula  "
@ 14,22 SAY "(   )  Aprovados"
@ 15,20 SAY "ร"+REPLI("ฤ",29)+"ด"

WHILE .T.
   Mensagem("Marque com um X para Selecionar");SETCOLOR(YCOREDIT)
   @ 13,24 GET wOp1 PICT "!" WHEN EMPTY(wOp2) VALID wOp1 $ "X "
   @ 14,24 GET wOp2 PICT "!" WHEN EMPTY(wOp1) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X"
   @ 16,22 SAY "Saกda:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   Aguarde("Pesquisando..."); ALUNOS->(DBGOTOP())
   WHILE !ALUNOS->(EOF())
      IF !EMPTY(wOp1)
         IF ALUNOS->PENDENTE<=0.AND.!EMPTY(ALUNOS->DTAPROV1)
            ALUNOS->(DBSKIP()); LOOP
         ENDIF
      ELSEIF !EMPTY(wOp2)
         IF EMPTY(ALUNOS->DTAPROV1)
            ALUNOS->(DBSKIP()); LOOP
         ENDIF
      ENDIF

      (cArq1)->(DBAPPEND())
      REPLACE (cArq1)->NOME     WITH ALUNOS->NOME,;
              (cArq1)->MATRIC   WITH ALUNOS->MATRIC,;
              (cArq1)->ENDERECO WITH ALUNOS->ENDERECO,;
              (cArq1)->CIDADE   WITH ALUNOS->CIDADE,;
              (cArq1)->BAIRRO   WITH ALUNOS->BAIRRO,;
              (cArq1)->UF       WITH ALUNOS->UF,;
              (cArq1)->CEP      WITH ALUNOS->CEP,;
              (cArq1)->CPF      WITH ALUNOS->CPF,;
              (cArq1)->RG       WITH ALUNOS->RG,;
              (cArq1)->FONE_R   WITH ALUNOS->FONE_R,;
              (cArq1)->FONE_C   WITH ALUNOS->FONE_C,;
              (cArq1)->CELULAR  WITH ALUNOS->CELULAR
      ALUNOS->(DBSKIP())
   ENDDO
   Aguarde()
   (cArq1)->(DBGOTOP())
   IF !(cArq1)->(EOF())
      IF wDevice=="I"
         IF ChkImpr()
            cAviso := MsgImp()
            ImpRel()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
         BrowCad()
      ENDIF
   ELSE
      Aviso("Nฦo h  alunos "+IF(!EMPTY(wOp1),"em aula...","aprovados.."),,3)
   ENDIF
   (cArq1)->(__DBZAP())
ENDDO
RELEASE continua, nPg
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpRel()
   Gera_TXT("RELALU.TXT"); SETPRC(0,0)
   nQuant   := pg := 0
   continua := .T.
   CabRel311()
   WHILE continua .AND. !EOF()
      Compr_On()
      Cab_ESC(01,002,"CODIGO  :")
      Cab_ESC(00,012,MATRIC)
      Cab_ESC(00,012,MATRIC)
      Cab_ESC(00,020,"NOME:")
      Cab_ESC(00,026,NOME)
      Cab_ESC(00,026,NOME)
      Cab_ESC(01,002,REPLI("-",130))
      Cab_ESC(01,002,"ENDERECO:")
      Cab_ESC(00,012,ENDERECO)
      Cab_ESC(00,012,ENDERECO)
      Cab_ESC(00,055,"CIDADE   :")
      Cab_ESC(00,066,CIDADE)
      Cab_ESC(00,066,CIDADE)
      Cab_ESC(00,100,"BAIRRO:")
      Cab_ESC(00,108,BAIRRO)
      Cab_ESC(00,108,BAIRRO)
      Cab_ESC(01,002,"CEP     :")
      Cab_ESC(00,012,CEP)
      Cab_ESC(00,012,CEP)
      Cab_ESC(00,055,"ESTADO   :")
      Cab_ESC(00,066,UF)
      Cab_ESC(00,066,UF)
      Cab_ESC(01,002,"C.P.F.  :")
      Cab_ESC(00,012,CPF,"[@R 999.999.999-99]")
      Cab_ESC(00,012,CPF,"[@R 999.999.999-99]")
      Cab_ESC(00,055,"RG       :")
      Cab_ESC(00,066,RG)
      Cab_ESC(00,066,RG)
      Cab_ESC(01,002,"PROFIS. :")
      Cab_ESC(00,012,PROF)
      Cab_ESC(00,012,PROF)
      Cab_ESC(00,055,"FONE RES.:")
      Cab_ESC(00,066,FONE_R,"[@R (99) 9999-9999]")
      Cab_ESC(00,066,FONE_R,"[@R (99) 9999-9999]")
      Cab_ESC(00,082,"COML.:")
      Cab_ESC(00,089,FONE_C,"[@R (99) 9999-9999]")
      Cab_ESC(00,089,FONE_C,"[@R (99) 9999-9999]")
      Cab_ESC(00,106,"CELULAR:")
      Cab_ESC(00,115,FONE_C,"[@R (99) 9999-9999]")
      Cab_ESC(00,115,FONE_C,"[@R (99) 9999-9999]")
      Cab_ESC(01,002,REPL("=",130))
      DBSKIP()
      nQuant++
      IF nQuant==7 .AND. !EOF()
         EJECT ; CabRel311()
         nQuant := 0
      ENDIF
   ENDDO
   Compr_Off()

   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp relalu.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE RELALU.TXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel311()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY DATE()
   @ PROW()+1,069 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE ALUNOS"+IF(!EMPTY(wOp1)," EM AULA"," APROVADOS")
   Compr_On()
   @ PROW()+1,002 SAY REPLICATE("_",130)
   RETURN                                                                       
/*
Montagem do Lay-Out do Relatorio
        1         2         3         4         5         6         7         8         9        10        11        12        13
234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

CODIGO  : 9999    NOME: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX
---------------------------------------------------------------------------------------------------------------------------------
ENDERECO: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx   CIDADE   : XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX    BAIRRO: XXXXXXXXXXxxxxxxxxxx
CEP     : 99.999-999                                 ESTADO   : XX
C.P.F.  : 999.999.999-99                             RG       : XXXXXXXXXX
PROFIS. : XXXXXXXXXXxxxxxxxxxx                       FONE RES.: (999) 999-9999  COML.: (999) 999-9999  CELULAR: (999) 999-9999
=================================================================================================================================
*/
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SETCOLOR(YCORGERAL)
*   IF wOp2=="X"
      SELECT (cArq1); DBGOTOP()
*   ELSE
*      SELECT ALUNOS; DBGOTOP()
*   ENDIF
   Telas(2,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Nome",{|| TRANSFORM(NOME,"@!S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matrกcula",{|| TRANSFORM(MATRIC,"99999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endereo",{|| TRANSFORM(ENDERECO,"@!S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cidade",{|| CIDADE })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro",{|| BAIRRO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CEP",{|| TRANSFORM(CEP,"@R 99.999-999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("UF",{|| UF })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("C.P.F.",{|| TRANSFORM(CPF,"@R 999.999.999-99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("RG",{|| RG })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Resid.",{|| TRANSFORM(FONE_R,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Coml.",{|| TRANSFORM(FONE_C,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Celular",{|| TRANSFORM(CELULAR,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)

   oBr:freeze:=1
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
