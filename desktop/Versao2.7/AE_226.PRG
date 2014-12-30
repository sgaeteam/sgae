*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_226                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Consulta de Aulas desmarcadas            ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/07/2002                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NUMERO"   ,"C",   02,0}) /* Numero da Aula       */
AADD(aDbf,{"CODINST"  ,"C",   04,0}) /* C¢digo do Instrutor  */
AADD(aDbf,{"CODVEIC"  ,"C",   02,0}) /* C¢digo do Ve¡culo    */
AADD(aDbf,{"DATA"     ,"D",   08,0}) /* Data do Treino       */
AADD(aDbf,{"HORA"     ,"C",   04,0}) /* Hora Prevista        */
AADD(aDbf,{"MOTIVO"   ,"C",   50,0}) /* Motivo               */
AADD(aDbf,{"CONTATO"  ,"C",   20,0}) /* Contato              */
AADD(aDbf,{"GRAU"     ,"C",   20,0}) /* Grau Afinidade       */
AADD(aDbf,{"DTCONT"   ,"D",   08,0}) /* Data do contato      */
AADD(aDbf,{"HCONT"    ,"C",   04,0}) /* Hora do contato      */
AADD(aDbf,{"PROTOCOLO","C",   08,0}) /* Numero do Protocolo  */
AADD(aDbf,{"STATUS"   ,"L",   01,0}) /* Remarcada ou nao     */
AADD(aDbf,{"USER"     ,"C",   25,0}) /* Nome do Usuario      */
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
INDEX ON DTOS(DATA) TO (cArq1)

SELECT 6
IF NetUse("DBPEND","PENDENCIA")        /* Arquivo de Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")        /* Cadastro de Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")              /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")    /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 21
IF NetUse("DBDESM","DESMARCA")          /* Arquivo de Desmarca‡Æo de Aulas */
   SET INDEX TO DBIDES1,DBIDES2,DBIDES3,DBIDES4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE223";ProgName("AE226")
cOpHelp1 := "2"; cOpHelp2 := "26"
SET KEY -1 TO Mostra()
wData:=CTOD(""); wMatr:=SPACE(5)
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(4,3,6,75,1,YCOREDIT,.T.,"Consulta de Aulas Desmarcadas")
   Mensagem("Informe Matr¡cula do Aluno")
   @ 05,05 SAY "Matr¡cula:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,5,22,wMatr,"NOME",["@S40"],"Aluno NÆo Localizado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   ChkPend(wMatr)  // Verifica pendencia
   IF DESMARCA->(DBSEEK(wMatr))
      /* Alimentar o Arquivo Temporario */
      WHILE DESMARCA->MATRIC==wMatr.AND.!DESMARCA->(EOF())
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NUMERO    WITH DESMARCA->NUMERO   ,;
                 (cArq1)->CODINST   WITH DESMARCA->CODINST  ,;
                 (cArq1)->CODVEIC   WITH DESMARCA->CODVEIC  ,;
                 (cArq1)->DATA      WITH DESMARCA->DATA     ,;
                 (cArq1)->HORA      WITH DESMARCA->HORA     ,;
                 (cArq1)->MOTIVO    WITH DESMARCA->MOTIVO   ,;
                 (cArq1)->CONTATO   WITH DESMARCA->CONTATO  ,;
                 (cArq1)->GRAU      WITH DESMARCA->GRAU     ,;
                 (cArq1)->DTCONT    WITH DESMARCA->DTCONT   ,;
                 (cArq1)->HCONT     WITH DESMARCA->HCONT    ,;
                 (cArq1)->PROTOCOLO WITH DESMARCA->PROTOCOLO,;
                 (cArq1)->STATUS    WITH DESMARCA->STATUS   ,;
                 (cArq1)->USER      WITH DESMARCA->USER
         DESMARCA->(DBSKIP())
      ENDDO
      BrowDesm()
   ELSE
      Aviso("NÆo houveram desmarcacoes registradas para este aluno...",,3)
   ENDIF
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Browse das Desmarcacoes        ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
PROCEDURE BrowDesm()
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(6,3,19,75,1,YCOREDIT,.T.)
  Linha23("^ENTER^-Visualiza Motivo")
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(7,4,18,74)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "

  oCol:=TBCOLUMNNEW("Sit."        ,{|| IF(STATUS,"Rem","   ")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data Prev."  ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"        ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aula"        ,{|| NUMERO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Desmarc." ,{|| DTCONT})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"        ,{|| TRANSFORM(HCONT,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Protocolo"   ,{|| TRANSFORM(PROTOCOLO,"@R 999999/99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Motivo"      ,{|| TRANSFORM(MOTIVO,"@S20")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Responsavel" ,{|| CONTATO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Afinidade"   ,{|| GRAU})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Instrutor"   ,{|| PegaInst(CODINST)})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Veiculo"     ,{|| TNomVeic(CODVEIC)})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Operador"    ,{|| USER})
  oBr:addColumn(oCol)

  oBr:Freeze=1
  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F9)
        IF ChkImpr()
           nReg:=(cArq1)->(RECNO())
           cAviso := MsgImp(.F.)
           (cArq1)->(DBGOTOP())
           ImpDesm()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de ImpressÆo, tecle algo...")
           SELECT (cArq1); GO nReg
           oBr:Refreshcurrent()
        ENDIF
     ELSEIF ( tecla == K_ENTER)
        Telas(17,3,19,75,1,YCOREDIT,.T.,"Motivo")
        @ 18,5 SAY MOTIVO
        INKEY(0)
        ResT_Tela()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Imprimir Desmarca‡Æo do Aluno³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE ImpDesm()
  Gera_TXT("DESALU.TXT"); SETPRC(0,0)
  @ PROW()  ,10 SAY cRazao+" "+cEnder3+" Ramal: 5 (Aula Pr tica)"
  @ PROW()+1,05 SAY PADC("***** DESMARCA€ÇO DE AULAS PRµTICAS *****",125)
  @ PROW() ,110 SAY "Usuario: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
  @ PROW()+1,05 SAY REPLICATE("-",128)
  Compr_On()
  @ PROW()+1,05 SAY "Aluno.: "+ALUNO->NOME
  @ PROW()  ,90 SAY "Matricula: "+ALUNO->MATRIC
  @ PROW()+1,05 SAY "CPF/MF: "
  @ PROW()  ,13 SAY ALUNO->CPF PICT "@R 999.999.999-99"
  @ PROW()  ,40 SAY "RG: "+ALUNO->RG
  @ PROW()+1,05 SAY REPLICATE("-",128)
  @ PROW()+1,05 SAY "SIT DATA     HORA  AULA DT.DESM. HORA  PROTOCOLO MOTIVO               RESPONSAVEL/AFINIDADE                   VEICULO"
*                        99/99/99 99:99  99  99/99/99 99:99 999999/99 XXXXXXXXXXxxxxxxxxxx XXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxx
*                    56789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
*                         1         2         3         4         5         6         7         8         9        10        11        12        13
  @ PROW()+1,05 SAY REPLICATE("-",128)
  (cArq1)->(DBGOTOP())
  WHILE !(cArq1)->(EOF())
     @ PROW()+1,005 SAY IF(STATUS,"Rem","   ")
     @ PROW()  ,009 SAY DATA
     @ PROW()  ,018 SAY HORA       PICT "@R 99:99"
     @ PROW()  ,025 SAY NUMERO
     @ PROW()  ,029 SAY DTCONT
     @ PROW()  ,038 SAY HCONT      PICT "@R 99:99"
     @ PROW()  ,044 SAY PROTOCOLO  PICT "@R 999999/99"
     @ PROW()  ,054 SAY MOTIVO
     @ PROW()  ,075 SAY CONTATO+"/"+GRAU
     @ PROW()  ,115 SAY TNomVeic(CODVEIC)

     IF PROW()>=56.AND.!(cArq1)->(EOF())
        EJECT
        @ PROW()  ,10 SAY cRazao+" "+cEnder3+" Ramal: 5 (Aula Pr tica)"
        @ PROW()+1,05 SAY PADC("***** DESMARCA€ÇO DE AULAS PRµTICAS *****",125)
        @ PROW() ,110 SAY "Usuario: "+SUBS(cUsuario,1,AT(" ",cUsuario)-1)
        @ PROW()+1,05 SAY REPLICATE("-",128)
        Compr_On()
        @ PROW()+1,05 SAY "Aluno.: "+ALUNO->NOME
        @ PROW()  ,90 SAY "Matricula: "+ALUNO->MATRIC
        @ PROW()+1,05 SAY "CPF/MF: "
        @ PROW()  ,13 SAY ALUNO->CPF PICT "@R 999.999.999-99"
        @ PROW()  ,40 SAY "RG: "+ALUNO->RG
        @ PROW()+1,05 SAY REPLICATE("-",128)
        @ PROW()+1,05 SAY "SIT DATA     HORA  AULA DT.DESM. HORA  PROTOCOLO MOTIVO               RESPONSAVEL/AFINIDADE                   VEICULO"
        @ PROW()+1,05 SAY REPLICATE("-",128)
     ENDIF
     (cArq1)->(DBSKIP())
  ENDDO
  @ PROW()+1,05 SAY REPLICATE("-",128)
  Compr_Off()
  Fim_TXT()
  SAVESCREEN(0,0,24,79)
  RUN nodosimp DESALU.TXT 96 pre/sel
  RESTSCREEN(0,0,24,79,0)
  DELETE FILE DESALU.TXT
  RETURN
