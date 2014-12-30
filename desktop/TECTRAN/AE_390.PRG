*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_390                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Hor rios Vagos              ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 28/03/1998                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBFERI","FERIADO")      /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 2
IF NetUse("DBVEIC","VEICULO")      /* Veกculos */
   SET INDEX TO DBIVEI3,DBIVEI1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPROG","AULAS")        /* Programaฦo de Aulas Praticas */
   SET INDEX TO DBIPRO3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE390"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "90"
SET KEY -1 TO Mostra()
wPer:=DATE()
WHILE .T.
   SETCOLOR(YCOREDIT)
   Mensagem("Informe a Data")
   Telas(12,18,14,39,1,YCOREDIT,.T.,"Horas Vagas")
   @ 13,20 SAY "Data:" GET wPer PICT "@D" VALID !EMPTY(wPer)
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   Mensagem()

   IF !FERIADO->(DBSEEK(DTOS(wPer))).AND.DOW(wPer)#1.AND.ChkImpr()
      cAviso := MsgImp()
      pg:=0; nTotHoras:=0; continua:=.T.
      Gera_TXT("HRVAGA.TXT")
      VEICULO->(DBGOTOP())
      CabRel("HORARIOS VAGOS EM "+DTOC(wPer))
      @ PROW()+1,05 SAY REPLICATE("ฤ",70)
      @ PROW()+1,05 SAY "INSTRUTOR            VEICULO           HORARIOS"
*                        XXXXXXXXXXxxxxxxxxxx XXXXXXXXXXxxxxxxx 99:99 99:99 99:99 99:99 99:99
*                        56789012345678901234567890123456789012345678901234567890123456789012345678
*                             1         2         3         4         5         6         7
      @ PROW()+1,05 SAY REPLICATE("ฤ",70)
      WHILE !VEICULO->(EOF())
         IF VEICULO->STATUS="A"
            IF AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(wPer)))
               // Calcular tamanho do nome+sobrenome
               xLetras:=TamNome(VEICULO->NOME)
               @ PROW()+1,05 SAY SUBS(VEICULO->NOME,1,xLetras) PICT "@S20"
               @ PROW()  ,26 SAY VEICULO->MARCA PICT "@S17"
               IF DOW(wPer)==7  /* S bado */
                  nQtdeAula:=5
               ELSE
                  nQtdeAula:=13
               ENDIF
               nPos:=44
               aHora := { "0700","0755","0850","0945","1040","1135","1230",;
                          "1325","1420","1515","1610","1705","1800" }
               FOR i = 1 TO nQtdeAula
                  IF nPos=74
                     nPos:=44
                     IF !AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(wPer)+aHora[i]))
                        @ PROW()+1,00 SAY ""
                     ENDIF
                  ENDIF
                  IF !AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(wPer)+aHora[i]))
                     @ PROW(),nPos SAY aHora[i] PICT "@R 99:99"
                     nTotHoras++
                     nPos += 6
                  ENDIF
               NEXT
               @ PROW()+1,05 SAY REPLICATE("-",70)
            ENDIF
            IF PROW()>=60.AND.!VEICULO->(EOF())
               EJECT
               CabRel("HORARIOS VAGOS EM "+DTOC(wPer))
               @ PROW()+1,05 SAY REPLICATE("ฤ",70)
               @ PROW()+1,05 SAY "INSTRUTOR            VEICULO           HORARIOS"
               @ PROW()+1,05 SAY REPLICATE("ฤ",70)
            ENDIF
         ENDIF
         VEICULO->(DBSKIP())
      ENDDO
      @ PROW()+2,05 SAY "TOTAL DE HORAS VAGAS -->"
      @ PROW()  ,43 SAY nTotHoras PICT "999"
      Fim_TXT()
      SAVESCREEN(0,0,24,79)
      RUN nodosimp HRVAGA.TXT 80 pre/sel
      RESTSCREEN(0,0,24,79,0)
      DELETE FILE HRVAGA.TXT
      TiraMsgImp(cAviso)
      WaitMsg("Fim de Impressฦo, tecle algo...")
   ELSE
      Aviso("Esta data  feriado ou sem expediente...",,3)
   ENDIF
   Rest_Tela()
ENDDO
DBCLOSEALL(); RETURN
