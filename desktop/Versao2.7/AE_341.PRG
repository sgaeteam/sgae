*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_341                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : ETIQUETAS                                ณ
*ณ PROGRAMADOR    : VITOR FREIRE - VIRTUAL SYSTEM            ณ
*ณ DATA CRIACAO   : 31/10/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua:=.T.
SET CENTURY ON
DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf, { "MATRIC"  ,"C", 05, 0 } )
AADD(aDbf, { "NOME"    ,"C", 50, 0 } )
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
INDEX ON nome TO (cArq1)

SELECT 1
IF NetUse("DBALU","ALUNOS")
   SET INDEX TO DBIALU1
ELSE
   DelDbfNtx(); RETURN
ENDIF
DBGOBOTTOM()
wNumFim := ALUNOS->MATRIC
wNumInic:= "00001"
wImpress:= "M"

ProgName("AE341"); LinhaMsg(2)
*SET KEY -1 TO Mostra()
Telas(16,3,20,43,1,YCOREDIT,.T.)
WHILE .T.
   (cArq1)->(__DBZAP())
   SETCOLOR(YCOREDIT)
   cEscolha:=" "
   @ 17,04 SAY "Faixa ou Seleฦo (F/S)?:" GET cEscolha PICT "!" VALID !EMPTY(cEscolha).AND.cEscolha$"FS"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   SELECT ALUNOS
   IF cEscolha=="F"
      @ 18,04 SAY "Nง Inicial.............:" GET wNumInic PICT "99999" VALID !EMPTY(wNumInic)
      @ 19,04 SAY "Nง Final...............:" GET wNumFim  PICT "99999" VALID VAL(wNumFim)>=VAL(wNumInic)
      SETCURSOR(1); READ; SETCURSOR(0)
      IF LASTKEY()==K_ESC; EXIT; ENDIF

      DBSEEK(wNumInic,.T.)
      IF !EOF()
         IF TImp380().AND.ChkImpr()
            cAviso := MsgImp(.F.)
            SET DEVI TO PRINT; SETPRC(0,0)
            Cab380(4,00,"")
            WHILE continua.AND.MATRIC<=wNumFim.AND.!EOF()
               wNome2:=wEndereco2:=SPACE(50)
               wBairro2:=SPACE(20)
               wCidade2:=SPACE(30)
               wUF2:=SPACE(2)
               wCEP2:=SPACE(8)

               wNome1:=     NOME
               wEndereco1:= ENDERECO
               wBairro1:=   BAIRRO
               wCidade1:=   CIDADE
               wUF1:=       UF
               wCEP1:=      CEP

               DBSKIP()
               IF ALUNOS->MATRIC<=wNumFim.AND.!EOF()
                  wNome2:=     NOME
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
            WaitMsg("Fim de Impressฦo! Tecle algo...")
         ENDIF
      ENDIF
   ELSE
      SELECT (cArq1)
      LinhaMsg(12)
      SETCOLOR(YCOREDIT)
      Telas(5,2,17,76,1,YCOREDIT,.T.,"Etiquetas Selecionadas")
      msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

      oBr:=TBROWSEDB(6,3,16,75)
      oBr:headSep:="ฤยฤ"
      oBr:colSep:= " ณ "

      oCol:=TBCOLUMNNEW("Matr."   ,{|| (cArq1)->MATRIC})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Nome"    ,{|| TRANSFORM((cArq1)->NOME,"@S30")})
      oBr:addColumn(oCol)
      oCol:=TBCOLUMNNEW("Endereo",{|| (cArq1)->ENDERECO})
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
            Telas(8,5,10,23,1,YCOREDIT,.T.,"Inclusฦo")
            wMatric:=0
            WHILE .T.
               @ 09,06 SAY "Matrกcula:" GET wMatric PICT "99999" VALID !EMPTY(wMatric)
               SETCURSOR(1); READ; SETCURSOR(0)
               IF LASTKEY()==K_ESC; EXIT; ENDIF

               IF ALUNOS->(DBSEEK(STRZERO(wMatric,5)))
                  IF (cArq1)->(DBSEEK(ALUNOS->NOME))
                     Aviso("Aluno j  informado...",,3)
                  ELSE
                     (cArq1)->(DBAPPEND())
                     REPLACE (cArq1)->MATRIC   WITH STRZERO(wMatric,5),;
                             (cArq1)->NOME     WITH ALUNOS->NOME,;
                             (cArq1)->ENDERECO WITH ALUNOS->ENDERECO,;
                             (cArq1)->BAIRRO   WITH ALUNOS->BAIRRO,;
                             (cArq1)->CIDADE   WITH ALUNOS->CIDADE,;
                             (cArq1)->UF       WITH ALUNOS->UF,;
                             (cArq1)->CEP      WITH ALUNOS->CEP
                     ProcOk("Incluido",.T.)
                     wMatric++
                  ENDIF
               ELSE
                  Aviso("Aluno nฦo localizado...",,3)
               ENDIF
            ENDDO
            Rest_Tela()
            oBr:Refreshall()
         ELSEIF ( tecla == K_ALT_E)   /* Exclui */
            IF !EMPTY((cArq1)->MATRIC)
               (cArq1)->(DBDELETE())
               oBr:Refreshall()
            ELSE
               Aviso("Nฦo h  registro a ser Excluกdo...",,3)
            ENDIF
         ELSEIF ( tecla == K_F9)   /* IMPRIME */
            IF LASTKEY()#K_ESC.AND.TImp380().AND.ChkImpr()
               cAviso := MsgImp(.F.)
               SET DEVI TO PRINT; SETPRC(0,0)
               DBGOTOP()
               Cab380(4,00,"")
               WHILE continua.AND.!EOF()
                  wNome2:=wEndereco2:=SPACE(50)
                  wBairro2:=SPACE(20)
                  wCidade2:=SPACE(30)
                  wUF2:=SPACE(2)
                  wCEP2:=SPACE(8)

                  wNome1:=     NOME
                  wEndereco1:= ENDERECO
                  wBairro1:=   BAIRRO
                  wCidade1:=   CIDADE
                  wUF1:=       UF
                  wCEP1:=      CEP

                  DBSKIP()
                  IF !EOF()
                     wNome2:=     NOME
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
               WaitMsg("Fim de Impressฦo! Tecle algo...")
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
*ีออออออออออออออออออออออออออออออธ
*ณ Controle Tecla ESC           ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Cab380(nProw,nPcol,cTexto,cMascara)
   IF continua .AND. (continua := EscPrint())
      IF VALTYPE( cMascara ) = "U"
         @ PROW()+nProw,nPcol SAY cTexto
      ELSE
         @ PROW()+nProw,nPcol SAY cTexto PICT &cMascara.
      ENDIF
   ELSE
      DBGOBOTTOM()
      DBSKIP()
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Impressao Etiqueta    ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TImp380()
   IF Confirma("Faz teste de Impresso ?",.T.).AND.ChkImpr()
      cAviso := MsgImp(.F.)
      SET DEVI TO PRINT
      WHILE .T.
         Compr_On()
         Cab380(1,05,REPL("*",50))
         Cab380(0,60,REPL("*",50))
         Cab380(1,05,REPL("*",50))
         Cab380(0,60,REPL("*",50))
         Cab380(1,05,REPL("*",28)+" "+REPL("*",10)+" "+REPL("*",10))
         Cab380(0,60,REPL("*",28)+" "+REPL("*",10)+" "+REPL("*",10))
         Cab380(2,00,"")
         SET DEVICE TO SCREEN
         TiraMsgImp(cAviso)
         IF !Confirma("Continua o Teste ?")
            SET DEVI TO PRINT; Cab380(3,00,""); SET DEVI TO SCREEN
            EXIT
         ENDIF
         cAviso := MsgImp(.F.)
         SET DEVI TO PRINT
      ENDDO
      Compr_Off()
      SET DEVICE TO SCREEN
      TiraMsgImp(cAviso)
   ENDIF
   RETURN .T.
