*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_311                           vrs 001 ณ
*ณ FINALIDADE     : Lista de Instrutores                     ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 21/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 1
IF NetUse("DBINST","INSTRUTOR")         /* Instrutores */
   SET INDEX TO DBINST1, DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Instrutores Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF

ProgName("AE311"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "11"

Quadro(12,20,17,50,1,YCOREDIT,.T.,,.T.)
wOp1:=wOp2:=wDevice:=" "
SETCOLOR(YCOREDIT)
@ 13,22 SAY "(   )  Por Cขdigo"
@ 14,22 SAY "(   )  Por Nome"
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

   IF !EMPTY(wOp1)
      DBSETORDER(1)
   ELSEIF !EMPTY(wOp2)
      DBSETORDER(2)
   ENDIF

   DBGOTOP()
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
ENDDO
RELEASE continua, nPg
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpRel()
   Gera_TXT("RELINST.TXT"); SETPRC(0,0)
   nQuant   := pg := 0
   continua := .T.
   CabRel311()
   WHILE continua .AND. !EOF()
      Compr_On()
      Cab_ESC(01,002,"CODIGO  :")
      Cab_ESC(00,012,CODINST)
      Cab_ESC(00,020,"NOME:")
      Cab_ESC(00,026,NOME)
      Cab_ESC(00,100,"STATUS:")
      Cab_ESC(00,108,IF(STATUS="A","ATIVO","INATIVO"))

*     Cab_ESC(01,002,REPLI("-",130))
      Cab_ESC(01,002,"ENDERECO:")
      Cab_ESC(00,012,ENDERECO)
      Cab_ESC(00,100,"CIDADE:")
      Cab_ESC(00,108,CIDADE)

      Cab_ESC(01,002,"BAIRRO  :")
      Cab_ESC(00,012,BAIRRO)
      Cab_ESC(00,055,"CEP   :")
      Cab_ESC(00,063,CEP)
      Cab_ESC(00,100,"ESTADO:")
      Cab_ESC(00,108,UF)

      Cab_ESC(01,002,"CPF/MF  :")
      Cab_ESC(00,012,CPF,"[@R 999.999.999-99]")
      Cab_ESC(00,055,"RG    :")
      Cab_ESC(00,063,RG)
      Cab_ESC(00,100,"CATEG.:")
      Cab_ESC(00,108,IF(CATEG="1","PRATICO",IF(CATEG="2","TEORICO",IF(CATEG="3","TEORICO/PRATICO","NAO INFORMADO"))))

      Cab_ESC(01,002,"ADMISSAO:")
      Cab_ESC(00,012,DTADM,"[@D]")
      Cab_ESC(00,055,"CTPS  :")
      Cab_ESC(00,063,CTPS)
      Cab_ESC(00,100,"SERIE :")
      Cab_ESC(00,108,SERIE)

      Cab_ESC(01,002,"C.N.H.  :")
      Cab_ESC(00,012,CNH)
      Cab_ESC(00,055,"FONE  :")
      Cab_ESC(00,063,FONE_R,"[@R (99) 9999-9999]")
      Cab_ESC(00,099,"CELULAR:")
      Cab_ESC(00,108,CELULAR,"[@R (99) 9999-9999]")
      Cab_ESC(01,002,REPL("=",130))
      DBSKIP()
      nQuant++
      IF nQuant==7 .AND. !EOF()
         EJECT ; CabRel311()
         nQuant := 0
      ENDIF
   ENDDO
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp relinst.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE RELINST.TXT
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Cabealho                    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE CabRel311()
   pg++
   Compr_Off()
   @ PROW()+1,002 SAY cRazao
   @ PROW()+1,070 SAY DATE()
   @ PROW()+1,071 SAY "Pag.:"+STRZERO(pg,4)
   @ PROW()+1,002 SAY "LISTA DE INSTRUTORES"
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
HABILIT.: XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX             FONE     : (999) 999-9999                   CELULAR: (999) 999-9999
=================================================================================================================================
*/
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad()
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Cขdigo"    ,{|| TRANSFORM(CODINST,"9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Status"    ,{|| IF(STATUS="A","Ativo  ",IF(STATUS="I","Inativo",SPACE(7)))})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Instrutor" ,{|| TRANSFORM(NOME,"@!S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endereo"  ,{|| TRANSFORM(ENDERECO,"@!S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Cidade/UF" ,{|| CIDADE+"-"+UF})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Bairro"    ,{|| BAIRRO })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CEP"       ,{|| TRANSFORM(CEP,"@R 99.999-999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CPF/MF"    ,{|| TRANSFORM(CPF,"@R 999.999.999-99")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("RG"        ,{|| RG })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("CNH"       ,{|| CNH })
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone"      ,{|| TRANSFORM(FONE_R,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Celular"   ,{|| TRANSFORM(CELULAR,"@R (99) 9999-9999")})
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
