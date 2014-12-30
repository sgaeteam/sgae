*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_IMPR                          vrs 003 ณ
*ณ VRS 003        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Configurar Impressoras                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 04/01/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

FUNCTION ConfigImpr(arq,prg,t,l,b,r,moldura)
   DEFAULT t       TO 8
   DEFAULT l       TO 28
   DEFAULT b       TO 17
   DEFAULT r       TO 47
   DEFAULT moldura TO 1

   aPrint := { {"Epson LX/FX/LQ","CHR(14)","CHR(20)","CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Citizen 200","CHR(27)+'W'+CHR(1)","CHR(27)+'W'+CHR(0)","CHR(27)+CHR(15)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Rima Itautec","CHR(14)","CHR(20)","CHR(30)+CHR(52)","CHR(18)","CHR(30)+'O'"},;
               {"Elgin","CHR(27)+'[Ow'","CHR(27)+'[3w'","CHR(27)+'[7w'","CHR(27)+'[3w'","CHR(27)+'[7w'+CHR(27)+'[Ow'"},;
               {"Elebra","CHR(14)","CHR(20)","CHR(30)+CHR(52)","CHR(18)","CHR(15)+CHR(14)"},;
               {"Diversos","CHR(14)","CHR(20)","CHR(17)","CHR(18)","CHR(19)"} ,;
               {"HP","CHR(27)+CHR(38)+CHR(107)+CHR(48)+CHR(83)","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)","CHR(27)+CHR(38)+CHR(107)+CHR(50)+CHR(83)","CHR(27)+CHR(40)+CHR(115)+CHR(35)+CHR(54)","CHR(27)+'&l8c'"} }

   USE (arq) NEW
   IF prg # NIL
      ProgName(prg)
   ENDIF
   
   Telas(t,l,b,r,moldura,YCORMENU,.T.)
   WHILE .T.
      SETCURSOR(0)
      SETCOLOR(YCORMENU)
      @ t+1,l+1 PROMPT "   Epson          " MESSAGE Msg("LX, FX e LQ")
      @ t+2,l+1 PROMPT "   Rima Padrฦo    " MESSAGE Msg("Okidata, XT180, XT250 ,XT300...")
      @ t+3,l+1 PROMPT "   Rima Itautec   " MESSAGE Msg("XT180, ML391...")
      @ t+4,l+1 PROMPT "   Elgin          " MESSAGE Msg("Amlia 250, EEnnn, Lady 90...")
      @ t+5,l+1 PROMPT "   Elebra         " MESSAGE Msg("M“nica, Emกlia Plus")
      @ t+6,l+1 PROMPT "   Universal      " MESSAGE Msg("Diversos")
      @ t+7,l+1 PROMPT "   HP             " MESSAGE Msg("HP")
      @ t+8,l+1 PROMPT "   Outras         " MESSAGE Msg("Lasers, Jato de Tinta, LED ou Fusฦo Trmica (fabricantes diversos)")
      MENU TO nMenu_56

      IF nMenu_56 = 0
         Rest_Tela()
         DBCLOSEALL()
         RETURN
      ENDIF

      IF nMenu_56 > 0 .AND. nMenu_56 < 8
         Grv_Imp(nMenu_56)
      ELSEIF nMenu_56 = 8
         tela := SAVESCREEN(2,0,24,79)
         Area_Dados()
         Quadro(8,10,18,65,1,YCOREDIT,.T.,"Impressora do Usu rio",.T.)
         SETCOLOR(YCOREDIT)
         Atrib_Var()

         SETCURSOR(1)
         @ 09,12 SAY "Consulte o manual do fabricante e informe:"
         @ 11,12 SAY "Impressora.........: "GET wImpressora VALID !EMPTY(wImpressora)
         @ 12,12 SAY "Ativa Expandido....: "GET wExpandOn   PICT "@S30"
         @ 13,12 SAY "Desativa Expandido.: "GET wExpandOff  PICT "@S30"
         @ 14,12 SAY "Ativa Condensado...: "GET wCompr_On   PICT "@S30"
         @ 15,12 SAY "Desativa Condensado: "GET wCompr_Off  PICT "@S30"
         @ 16,12 SAY "Impr.Meio Expandida: "GET wExpand_Med PICT "@S30"
         @ 17,12 SAY "Conexฦo USB (S/N)..: "GET wUSB        PICT "!"   VALID wUSB $"SN"
         READ
         SETCURSOR(0)

         IF LASTKEY() # 27
            IF NetLReg()
               REPLACE _FIELD->IMPRESSORA WITH wImpressora ,;
                       _FIELD->EXPANDON   WITH wExpandOn   ,;
                       _FIELD->EXPANDOFF  WITH wExpandOff  ,;
                       _FIELD->COMPR_ON   WITH wCompr_On   ,;
                       _FIELD->COMPR_OFF  WITH wCompr_Off  ,;
                       _FIELD->EXPAND_MED WITH wExpand_Med ,;
                       _FIELD->USB        WITH wUSB
               ProcOk("Configurado",.T.)
            ENDIF
         ENDIF
         RESTSCREEN(2,0,24,79,tela)
      ENDIF
   ENDDO
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Gravaao da Configuraao     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Grv_Imp(vetor)
   IF NetLReg()
      REPLACE _FIELD->IMPRESSORA WITH aPrint[vetor,1],;
              _FIELD->EXPANDON   WITH aPrint[vetor,2],;
              _FIELD->EXPANDOFF  WITH aPrint[vetor,3],;
              _FIELD->COMPR_ON   WITH aPrint[vetor,4],;
              _FIELD->COMPR_OFF  WITH aPrint[vetor,5],;
              _FIELD->EXPAND_MED WITH aPrint[vetor,6],;
              _FIELD->USB        WITH wUSB
      Atrib_Var()
      ProcOk("Configurado",.T.)
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Atribuiao das Vari veis     ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE Atrib_Var()
  wImpressora := _FIELD->IMPRESSORA
  wExpandOn   := _FIELD->EXPANDON
  wExpandOff  := _FIELD->EXPANDOFF
  wCompr_On   := _FIELD->COMPR_ON
  wCompr_Off  := _FIELD->COMPR_OFF
  wExpand_Med := _FIELD->EXPAND_MED
  wUSB        := _FIELD->USB
  RETURN
