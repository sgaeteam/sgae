*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_342                           vrs 001 ≥
*≥ VRS 001        : Implantacao                              ≥
*≥ FINALIDADE     : ETIQUETAS de Fornecedores                ≥
*≥ PROGRAMADOR    : VITOR FREIRE - VIRTUAL SYSTEM            ≥
*≥ DATA CRIACAO   : 21/11/1996                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"

PUBLIC continua:=.T.
SET CENTURY ON
DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf, { "CODEMP"  ,"C", 04, 0 } )
AADD(aDbf, { "RAZAO"   ,"C", 50, 0 } )
AADD(aDbf, { "ENDERECO","C", 50, 0 } )
AADD(aDbf, { "BAIRRO"  ,"C", 20, 0 } )
AADD(aDbf, { "CIDADE"  ,"C", 30, 0 } )
AADD(aDbf, { "UF"      ,"C", 02, 0 } )
AADD(aDbf, { "CEP"     ,"C", 08, 0 } )
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf); RELEASE aDbf; EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON razao TO (cArq1)

SELECT 1
IF NetUse("DBEMP","EMPRESA")
   SET INDEX TO DBIEMP1
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOBOTTOM()
wNumFim := EMPRESA->CODEMP
wNumInic:= "0001"

ProgName("AE342"); LinhaMsg(2)
Telas(16,3,20,43,1,YCOREDIT,.T.)
WHILE .T.
   (cArq1)->(__DBZAP())
   SETCOLOR(YCOREDIT)
   cEscolha:=" "
   @ 17,04 SAY "Faixa ou Seleá∆o (F/S)?:" GET cEscolha PICT "!" VALID !EMPTY(cEscolha).AND.cEscolha$"FS"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT EMPRESA
   IF cEscolha=="F"
      @ 18,04 SAY "Nß Inicial.............:" GET wNumInic PICT "9999" VALID !EMPTY(wNumInic)
      @ 19,04 SAY "Nß Final...............:" GET wNumFim  PICT "9999" VALID VAL(wNumFim)>=VAL(wNumInic)
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      DBSEEK(wNumInic,.T.)
      IF !EOF()
         IF TImp380().AND.ChkImpr()
            cAviso := MsgImp()
            SET DEVI TO PRINT; SETPRC(0,0)
            Cab380(4,00,"")
            WHILE continua.AND.CODEMP<=wNumFim.AND.!EOF()
               wNome2:=wEndereco2:=SPACE(50)
               wBairro2:=SPACE(20)
               wCidade2:=SPACE(30)
               wUF2:=SPACE(2)
               wCEP2:=SPACE(8)

               wRazao1:=    RAZAO
               wEndereco1:= ENDERECO
               wBairro1:=   BAIRRO
               wCidade1:=   CIDADE
               wUF1:=       UF
               wCEP1:=      CEP

               DBSKIP()
               IF EMPRESA->CODEMP<=wNumFim.AND.!EOF()
                  wRazao2:=    RAZAO
                  wEndereco2:= ENDERECO
                  wBairro2:=   BAIRRO
                  wCidade2:=   CIDADE
                  wUF2:=       UF
                  wCEP2:=      CEP
               ENDIF
               Compr_On()
               IF !EMPTY(wRazao1)
                  Cab380(1,00,wRazao1)
                  Cab380(0,00,wRazao1)
                  IF !EMPTY(wRazao2)
                     Cab380(0,60,wRazao2)
                     Cab380(0,60,wRazao2)
                  ENDIF
                  Cab380(1,00,wEndereco1)
                  IF !EMPTY(wRazao2)
                     Cab380(0,60,wEndereco2)
                  ENDIF
                  Cab380(1,00,RTRIM(wBairro1)+" - "+RTRIM(wCidade1)+"/"+wUF1)
                  IF !EMPTY(wRazao2)
                     Cab380(0,60,RTRIM(wBairro2)+" - "+RTRIM(wCidade2)+"/"+wUF2)
                  ENDIF
                  Cab380(1,00,"CEP: "+TRANSFORM(wCEP1,"@R 99.999-999"))
                  IF !EMPTY(wRazao2)
                     Cab380(0,60,"CEP: "+TRANSFORM(wCEP2,"@R 99.999-999"))
                  ENDIF
                  Cab380(2,00,"")
               ENDIF
               DBSKIP()
            ENDDO
            Compr_Off(); EJECT
            SET DEVI TO SCREEN
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impress∆o! Tecle algo...")
         ENDIF
      ENDIF
   ELSE
      SELECT (cArq1)
      LinhaMsg(12)
      SETCOLOR(YCOREDIT)
      Telas(5,2,17,76,1,YCOREDIT,.T.,"Etiquetas Selecionadas")
      msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

      oBr:=TBROWSEDB(6,3,16,75)
      oBr:headSep:="ƒ¬ƒ"
      oBr:colSep:= " ≥ "

      oCol:=TBCOLUMNNEW("Empresa",{|| (cArq1)->CODEMP})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Raz∆o",{|| TRANSFORM((cArq1)->RAZAO,"@S30")})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Endereáo",{|| (cArq1)->ENDERECO})
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
         ELSEIF ( tecla == K_F6 )     /* Inclui */
            Telas(8,5,10,23,1,YCOREDIT,.T.,"Inclus∆o")
            wCodEmp:=0
            WHILE .T.
               @ 09,06 SAY "C¢digo:" GET wCodEmp PICT "9999" VALID !EMPTY(wCodEmp)
               SETCURSOR(1); READ; SETCURSOR(0)
               IF LASTKEY()==K_ESC; EXIT; ENDIF

               IF EMPRESA->(DBSEEK(STRZERO(wCodEmp,4)))
                  IF (cArq1)->(DBSEEK(EMPRESA->RAZAO))
                     Aviso("Empresa j† informado...",,3)
                  ELSE
                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->CODEMP   WITH STRZERO(wCodEmp,4),;
                             (cArq1)->RAZAO    WITH EMPRESA->RAZAO,;
                             (cArq1)->ENDERECO WITH EMPRESA->ENDERECO,;
                             (cArq1)->BAIRRO   WITH EMPRESA->BAIRRO,;
                             (cArq1)->CIDADE   WITH EMPRESA->CIDADE,;
                             (cArq1)->UF       WITH EMPRESA->UF,;
                             (cArq1)->CEP      WITH EMPRESA->CEP
                     ProcOk("Incluido",.T.)
                     wCodEmp++
                  ENDIF
               ELSE
                  Aviso("Empresa n∆o cadastrada...",,3)
               ENDIF
            ENDDO
            Rest_Tela()
            oBr:Refreshall()
         ELSEIF ( tecla == K_ALT_E)   /* Exclui */
            IF !EMPTY((cArq1)->CODEMP)
               (cArq1)->(DBDELETE())
               oBr:Refreshall()
            ELSE
               Aviso("N∆o h† registro a ser Exclu°do...",,3)
            ENDIF
         ELSEIF ( tecla == K_F9)   /* IMPRIME */
            IF LASTKEY()#K_ESC.AND.TImp380().AND.ChkImpr()
               cAviso := MsgImp(.F.)
               SET DEVI TO PRINT; SETPRC(0,0)
               DBGOTOP()
               Cab380(4,00,"")
               WHILE continua.AND.!EOF()
                  wRazao2:=wEndereco2:=SPACE(50)
                  wBairro2:=SPACE(20)
                  wCidade2:=SPACE(30)
                  wUF2:=SPACE(2)
                  wCEP2:=SPACE(8)

                  wNome1:=    RAZAO
                  wEndereco1:= ENDERECO
                  wBairro1:=   BAIRRO
                  wCidade1:=   CIDADE
                  wUF1:=       UF
                  wCEP1:=      CEP

                  DBSKIP()
                  IF !EOF()
                     wNome2:=    RAZAO
                     wEndereco2:= ENDERECO
                     wBairro2:=   BAIRRO
                     wCidade2:=   CIDADE
                     wUF2:=       UF
                     wCEP2:=      CEP
                  ENDIF
                  Compr_On()
                  IF !EMPTY(wNome1)
                     Cab380(1,00,wNome1)
                     Cab380(0,00,wNome1)
                     IF !EMPTY(wNome2)
                        Cab380(0,60,wNome2)
                        Cab380(0,60,wNome2)
                     ENDIF
                     Cab380(1,00,wEndereco1)
                     IF !EMPTY(wNome2)
                        Cab380(0,60,wEndereco2)
                     ENDIF
                     Cab380(1,00,RTRIM(wBairro1)+" - "+RTRIM(wCidade1)+"/"+wUF1)
                     IF !EMPTY(wNome2)
                        Cab380(0,60,RTRIM(wBairro2)+" - "+RTRIM(wCidade2)+"/"+wUF2)
                     ENDIF
                     Cab380(1,00,"CEP: "+TRANSFORM(wCEP1,"@R 99.999-999"))
                     IF !EMPTY(wNome2)
                        Cab380(0,60,"CEP: "+TRANSFORM(wCEP2,"@R 99.999-999"))
                     ENDIF
                     Cab380(2,00,"")
                  ENDIF
                  DBSKIP()
               ENDDO
               Compr_Off(); EJECT
               SET DEVI TO SCREEN
               TiraMsgImp(cAviso)
               WaitMsg("Fim de Impress∆o! Tecle algo...")
            ENDIF
         ELSE
            ProcKey(oBr,tecla)
         ENDIF
      ENDDO
      Rest_Tela()
   ENDIF
ENDDO
Rest_Tela()
DelDbfNtx(); RETURN
