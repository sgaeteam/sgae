*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_114                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Impressao de certificados                ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 20/07/2004                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBALU","ALUNOS")             /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBGOBOTTOM(); DBSKIP()

SELECT 2
IF NetUse("DBINST","INSTRUTOR")         /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBCERT","CERTIF")            /* Certificados */
   SET INDEX TO DBICER01,DBICER02,DBICER03
ELSE
   DelDbfNtx(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
cPrg:="AE114"; LinhaMsg(2); ProgName(cPrg)

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,21,75,1,YCOREDIT,.T.,"ImpressÆo de Certificados")

wOp1:=wOp2:=" ";wCer:=SPACE(8);wEtq:=SPACE(11);wMatr:=SPACE(5)
wLiv:=wCodInst:=wLeg:=wDDef:=wPSos:=wMAmb:=wMeca:=SPACE(4)
wPag:=wRod:="  ";wPIn:=wPFi:=CTOD("")

SETCOLOR(YCOREDIT)
@ 05,07 SAY "(   ) Te¢rico    (   ) Pr tico"
@ 06,05 SAY "Ã"+REPLI("Ä",69)+"´"
@ 07,07 SAY "Aluno......:"
@ 08,07 SAY "CPF/MF.....:                          RG....:"
@ 09,05 SAY "Ã"+REPLI("Ä",69)+"´"
@ 10,07 SAY "Certificado:                          Livro.:"
@ 11,07 SAY "Etiqueta...:                          P gina:"
@ 12,07 SAY "Per¡odo....:            a             Rodas.:"
@ 13,05 SAY "Ã"+REPLI("Ä",69)+"´"
@ 14,07 SAY "***** Instrutores *****"
@ 15,07 SAY "  Pr tico  :"
@ 16,07 SAY "  Te¢ricos : 1. Legisla‡Æo  >"
@ 17,07 SAY "             2. D.Defensiva >"
@ 18,07 SAY "             3. P.Socorros  >"
@ 19,07 SAY "             4. M.Ambiente  >"
@ 20,07 SAY "             5. Mecƒnica    >"

SET KEY -1 TO Mostra()
WHILE .T.
   Mensagem("Marque com um X para Selecionar ESPA€O para limpar");SETCOLOR(YCOREDIT)
   @ 05,09 GET wOp1  PICT "!"     WHEN EMPTY(wOp2) VALID wOp1 $ "X "
   @ 05,26 GET wOp2  PICT "!"     WHEN EMPTY(wOp1) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X "
   @ 07,20 GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,7,26,wMatr,"NOME",["@S40"],"Aluno NÆo Localizado")
   @ 08,20 GET ALUNOS->CPF PICT "@R 999.999.999-99" WHEN .F.
   @ 08,53 GET ALUNOS->RG                           WHEN .F.

   @ 10,20 GET wCer PICT "@!"
   @ 11,20 GET wEtq PICT "@!"
   @ 10,53 GET wLiv PICT "@!"
   @ 11,53 GET wPag PICT "@!"

   @ 12,20 GET wPIn PICT "@D"
   @ 12,33 GET wPFi PICT "@D"
   @ 12,53 GET wRod PICT "@!"
   @ 15,20 GET wCodInst  PICT "9999" WHEN !EMPTY(wOp2).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,15,25,wCodInst,"NOME",,"Instrutor NÆo Localizado")

   @ 16,35 GET wLeg  PICT "9999" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,16,39,wLeg,"NOME",["@S30"],"Instrutor NÆo Localizado")
   @ 17,35 GET wDDef PICT "9999" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,17,39,wDDef,"NOME",["@S30"],"Instrutor NÆo Localizado")
   @ 18,35 GET wPSos PICT "9999" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,18,39,wPSos,"NOME",["@S30"],"Instrutor NÆo Localizado")
   @ 19,35 GET wMAmb PICT "9999" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,19,39,wMAmb,"NOME",["@S30"],"Instrutor NÆo Localizado")
   @ 20,35 GET wMeca PICT "9999" WHEN !EMPTY(wOp1).AND.TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,20,39,wMeca,"NOME",["@S30"],"Instrutor NÆo Localizado")

   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      EXIT
   ENDIF



ENDDO
Rest_Tela()
RETURN
