*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_113                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Consulta de Certificados                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/07/2004                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

DBCLOSEALL()
SELECT 1
IF NetUse("DBCERT","CERTIF")             /* Certificados */
   SET INDEX TO DBICER01,DBICER02,DBICER03
ELSE
   DelDbfNtx(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "10"
cPrg:="AE113"; LinhaMsg(2); ProgName(cPrg)

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,11,75,1,YCOREDIT,.T.,"Consulta de Certificados")
wOp1:=wOp2:=wOp3:=" ";wCer:=SPACE(8);wEtq:=SPACE(11)
SETCOLOR(YCOREDIT)
@ 05,07 SAY "(   )  Teขrico"
@ 06,07 SAY "(   )  Pr tico (carro)"
@ 07,07 SAY "(   )  Pr tico (moto)"
@ 08,05 SAY "ร"+REPLI("ฤ",69)+"ด"
@ 09,07 SAY "Certificado:"
@ 10,07 SAY "Etiqueta...:"

WHILE .T.
   Mensagem("Marque com um X para Selecionar ESPA€O para limpar");SETCOLOR(YCOREDIT)
   @ 05,09 GET wOp1 PICT "!"  WHEN EMPTY(wOp2).AND.EMPTY(wOp3) VALID wOp1 $ "X "
   @ 06,09 GET wOp2 PICT "!"  WHEN EMPTY(wOp1).AND.EMPTY(wOp3) VALID (LASTKEY()==K_UP).OR.wOp2 $ "X "
   @ 07,09 GET wOp3 PICT "!"  WHEN EMPTY(wOp1).AND.EMPTY(wOp2) VALID (LASTKEY()==K_UP).OR.wOp3 $ "X "
   @ 09,20 GET wCer PICT "@!"
   @ 10,20 GET wEtq PICT "@!"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC
      EXIT
   ENDIF

   IF !EMPTY(wOp1).AND.!EMPTY(wCer)
      DBSETORDER(1)
   ENDIF
   IF !EMPTY(wOp2).AND.!EMPTY(wCer)
      DBSETORDER(2)
   ENDIF
   IF !EMPTY(wOp3).AND.!EMPTY(wCer)
      DBSETORDER(3)
   ENDIF

   Aguarde("Pesquisando...")
   IF !EMPTY(wCer)
      IF CERTIF->(DBSEEK(wCer))
         Aguarde()
         Browcad(1,wOp1,wOp2,wOp3)
      ELSE
         Aguarde()
         Aviso("Cerificado nฦo localizado!")
      ENDIF
   ELSE
      CERTIF->(DBGOTOP())
      IF !EMPTY(wOp1)
         LOCATE FOR ETIQ1=wEtq
         IF CERTIF->(EOF())
            CERTIF->(DBGOTOP())
            LOCATE FOR ETIQ11=wEtq
            IF CERTIF->(EOF())
               CERTIF->(DBGOTOP())
               LOCATE FOR ETIQ111=wEtq
               IF CERTIF->(EOF())
                  Aguarde()
                  Aviso("Etiqueta nฦo localizada!")
               ENDIF
            ELSE
               Aguarde()
               Browcad(2,wOp1,wOp2,wOp3)
            ENDIF
         ELSE
            Aguarde()
            Browcad(2,wOp1,wOp2,wOp3)
         ENDIF
      ELSEIF !EMPTY(wOp2)
         LOCATE FOR ETIQ2=wEtq
         IF CERTIF->(EOF())
            CERTIF->(DBGOTOP())
            LOCATE FOR ETIQ22=wEtq
            IF CERTIF->(EOF())
               CERTIF->(DBGOTOP())
               LOCATE FOR ETIQ222=wEtq
               IF CERTIF->(EOF())
                  Aguarde()
                  Aviso("Etiqueta nฦo localizada!")
               ENDIF
            ELSE
               Aguarde()
               Browcad(2,wOp1,wOp2,wOp3)
            ENDIF
         ELSE
            Aguarde()
            Browcad(2,wOp1,wOp2,wOp3)
         ENDIF
      ELSEIF !EMPTY(wOp3)
         LOCATE FOR ETIQ3=wEtq
         IF CERTIF->(EOF())
            CERTIF->(DBGOTOP())
            LOCATE FOR ETIQ33=wEtq
            IF CERTIF->(EOF())
               CERTIF->(DBGOTOP())
               LOCATE FOR ETIQ333=wEtq
               IF CERTIF->(EOF())
                  Aguarde()
                  Aviso("Etiqueta nฦo localizada!")
               ENDIF
            ELSE
               Aguarde()
               Browcad(2,wOp1,wOp2,wOp3,2)
            ENDIF
         ELSE
            Aguarde()
            Browcad(2,wOp1,wOp2,wOp3)
         ENDIF
      ENDIF
   ENDIF
ENDDO
Rest_Tela()
RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Cadastro             ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowCad(pOpDef,pOp1,pOp2,pOp3)
   LOCAL corant:=SETCOLOR(), oBr, oCol
   SETCOLOR(YCORGERAL)
   Telas(2,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Nome"     ,{|| TRANSFORM(NOME,"@!S40")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Matrกc."  ,{|| TRANSFORM(MATRIC,"99999")})
   oBr:addColumn(oCol)
   IF !EMPTY(pOp1)
      IF pOpDef=1
         oCol:=TBCOLUMNNEW("Certif.Teขrico" ,{|| CERTIF1})
      ELSE
         oCol:=TBCOLUMNNEW("Etq.Teขrico (1ง)" ,{|| ETIQ1})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Teขrico (2ง)" ,{|| ETIQ11})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Teขrico (3ง)" ,{|| ETIQ111})
      ENDIF
   ELSEIF !EMPTY(pOp2)
      IF pOpDef=1
         oCol:=TBCOLUMNNEW("Certif.Carro"   ,{|| CERTIF2})
      ELSE
         oCol:=TBCOLUMNNEW("Etq.Carro (1ง)" ,{|| ETIQ2})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Carro (2ง)" ,{|| ETIQ22})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Carro (3ง)" ,{|| ETIQ222})
      ENDIF
   ELSEIF !EMPTY(pOp3)
      IF pOpDef=1
         oCol:=TBCOLUMNNEW("Certif.Moto"    ,{|| CERTIF3})
      ELSE
         oCol:=TBCOLUMNNEW("Etq.Moto (1ง)" ,{|| ETIQ3})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Moto (2ง)" ,{|| ETIQ33})
         oBr:addColumn(oCol)
         oCol:=TBCOLUMNNEW("Etq.Moto (3ง)" ,{|| ETIQ333})
      ENDIF
   ENDIF
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
