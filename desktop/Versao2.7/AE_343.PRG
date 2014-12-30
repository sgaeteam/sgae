*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_343                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Etiqueta Aniversariantes do Mes          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 31/10/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

PUBLIC continua := .T., nPg := 0

DBCLOSEALL()
SELECT 2
IF !NetUse("DBPARM")
   RETURN
ENDIF

SELECT 1
IF NetUse("SOCIOS")
   SET INDEX TO DBISOCA6
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("GC343")
Telas(17,03,20,66,1,YCOREDIT,.T.)
WHILE .T.
   SETCURSOR(1)
   SETCOLOR(YCOREDIT)
   wDtAniv := SPACE(2) ; wMsgAniv := DBPARM->MSGANIV
   @ 18,05 SAY "Mes Aniv.:" GET wDtAniv  PICT "99"
   @ 19,05 SAY " Mensagem:" GET wMsgAniv PICT "@!S50"
   READ
   IF LASTKEY()==K_ESC .OR. EMPTY(wDtAniv)
      EXIT
   ENDIF

   SELECT SOCIOS
   IF DBSEEK(wDtAniv)
      IF Confirma("Imprimir Mala Direta ? ")
         IF TestImp().AND.ChkImpr()
            cAviso := MsgImp()
            Imp343()
            TiraMsgImp(cAviso)
            Beep(2)
            Mensagem("Fim de Impresso! Tecle algo...")
            INKEY(0)
            Mensagem()
            SELECT DBPARM
            IF NetLReg()
               FIELD->MSGANIV := wMsgAniv
            ENDIF
         ENDIF
      ENDIF
   ELSE
      Aviso("No existe Sขcio aniversariando neste dia",,3)
   ENDIF
ENDDO
Rest_Tela()
SETKEY(K_F2,NIL)
SETCURSOR(0)
RELEASE continua, nPg
DBCLOSEALL()
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Imprimir Mala Direta         ณ
*ิออออออออออออออออออออออออออออออพ
PROCEDURE Imp343()
   wDtAniv := SUBS(wDtAniv,3,2)+SUBS(wDtAniv,1,2)
   SET DEVI TO PRINT
   SETPRC(0,0)
   Imp_Compri()
   WHILE SUBS(DTOC(DATNAS),4,2)==wDtAniv.AND.continua.AND.!EOF()
      wNome1 := NOME     ; wNome2 := SPACE(50) ; wNome3 := SPACE(50)
      wEnd1  := ENDERECO ; wEnd2  := SPACE(60) ; wEnd3  := SPACE(60)
      wMsg1  := wMsgAniv ; wMsg2  := SPACE(50) ; wMsg3  := SPACE(50)
      DBSKIP()
      IF SUBS(DTOC(DATNAS),4,2)==wDtAniv
         wNome2 := NOME
         wEnd2  := ENDERECO
         wMsg2  := wMsgAniv
         DBSKIP()
         IF SUBS(DTOC(DATNAS),4,2)==wDtAniv
            wNome3 := NOME
            wEnd3  := ENDERECO
            wMsg3  := wMsgAniv
         ENDIF
      ENDIF
      Cab110ET(1,002,wNome1)
      Cab110ET(0,065,wNome2)
      Cab110ET(0,128,wNome3)
      Cab110ET(1,002,wEnd1)
      Cab110ET(0,065,wEnd2)
      Cab110ET(0,128,wEnd3)
      Cab110ET(1,002,wMsg1)
      Cab110ET(0,065,wMsg2)
      Cab110ET(0,128,wMsg3)
      @ PROW()+4,000 SAY ""
      DBSKIP()
   ENDDO
   Imp_Normal()
   SET DEVICE TO SCREEN
   RETURN
