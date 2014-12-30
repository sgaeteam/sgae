*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ PROGRAMA       : AE_000                           vrs 001 ≥
*≥ VRS 001        : Desenvolvimento                          ≥
*≥ FINALIDADE     : Menu Principal                           ≥
*≥ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ≥
*≥ DATA CRIACAO   : 09/08/1994                               ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
#include "INKEY.CH"
#include "BOX.CH"
#include "FILEIO.CH"
#include "COMMAND.CH"

LOCAL nHandle
calc_lin := 2
cale_lin := 1
calc_col := 0
cale_col := -1
corrente := atual := 0.0000
m_date   := cDtSys
c_nLado  := c_nBorda := c_wBorda := 1

aBorda   := { "⁄ƒø≥Ÿƒ¿≥", "’Õ∏≥æÕ‘≥", "÷ƒ∑∫Ωƒ”∫", ;
              "⁄ƒ∑∫ºÕ‘≥", "…Õ∏≥Ÿƒ”∫", "…Õª∫ºÕ»∫", ;
              "€ﬂ€ﬁ€‹€›", "‹‹‹€€‹€€", "…Õª∫ºÕ»∫±" }

aCor     := { "N",  "B",   "G",   "BG", "R",  "RB", ;
              "GR", "W",   "N+",  "B+", "G+", "BG+", ;
              "R+", "RB+", "GR+", "W+" }

SETCURSOR(0)
Abertura()
cCorant := SETCOLOR()

// Criacao dos Arquivos de Trabalho
lCria := Cria_Arqs()

IF !lCria
   Finalizar()
ENDIF
SELECT 1
IF !NetUse("DBPARM")               /* Tabela de Parametros */
   DBCLOSEALL(); RETURN
ENDIF
IF DATE() > DBPARM->DTTEST
   WHILE !DBPARM->(NetLReg()); ENDDO
   REPLACE DBPARM->DTTEST WITH DATE(),;
           DBPARM->REX    WITH .F.
   DBPARM->(DBUNLOCK())
ELSE
   IF cDtSys # DBPARM->DTTEST
      WHILE !DBPARM->(NetLReg()); ENDDO
      REPLACE DBPARM->DTTEST WITH cDtSys,;
              DBPARM->REX    WITH .F.
      DBPARM->(DBUNLOCK())
   ENDIF
ENDIF

SELECT 50
USE SCE.CFG ALIAS SCE        /* Configuracoes */
wUSB:=_FIELD->USB
SCE->(DBCLOSEAREA())

IF DBPARM->DTSIS >= DBPARM->DTVALID .OR. DATE() >= DBPARM->DTVALID
   aLib:={"ANTARES","DELTA","SIRIUS","ORION","LEAO","CALIXTO","VIRGO","ONIX",;
          "VEGA","OMEGA","LITIUM","PHOBOS"}
   DiaContrato:= "11"
   xLib:=aLib[MONTH(DATE())]
   Aviso("Data de Validade do Sistema Expirada. Contactar Suporte!")
   vLib:=SPACE(10)

   IF nNivel>=9
      // Entrada da Data de Operaá∆o
      SETCOLOR(YCOREDIT)
      Telas(10,25,14,52,1,YCOREDIT,.T.,"Data de Hoje")
      @ 11,27 SAY ExtDia(DATE())+" "+DTOC(DATE()) COLOR YCOREDIT
      @ 12,27 SAY "Nova Data: " GET cDtSys PICT "@D" VALID !EMPTY(cDtSys)
      @ 13,27 SAY "Senha Lib: " GET vLib   PICT "@!" VALID !EMPTY(vLib)
      SETCURSOR(1); READ; SETCURSOR(0); Rest_Tela()
      IF ALLTRIM(vLib)#xLib
         DBCLOSEALL()
         Beep(3)
         SETCOLOR("W+/R")
         ImplodBox()
         ExplodBox(19,1,23,78)
         SETCOLOR("W+/R*")
         Centro(21,"Sem Autorizaá∆o. Acesso Negado !!!",2,78)
         INKEY(3)
         SETCOLOR(cCorAnt)
         CLS
         QOUT(fSystem)
         QOUT(fEnder)
         QOUT(fFones)
         QOUT("")
         SETCURSOR(1)
         QUIT
      ELSE
         WHILE !DBPARM->(NetLReg()); ENDDO
         dDtValid := DATE()+30
         dDtValid := CTOD(DiaContrato+SUBS(DTOC(dDtValid),3,8))
         REPLACE DBPARM->DTVALID WITH dDtValid
         REPLACE DBPARM->DTSIS   WITH DATE()
         DBPARM->(DBUNLOCK())
      ENDIF
   ELSE
      DBCLOSEALL()
      Beep(3)
      SETCOLOR("W+/R")
      ImplodBox()
      ExplodBox(19,1,23,78)
      SETCOLOR("W+/R*")
      Centro(21,"Sem Autorizaá∆o. Acesso Negado !!!",2,78)
      INKEY(3)
      SETCOLOR(cCorAnt)
      CLS
      QOUT(fSystem)
      QOUT(fEnder)
      QOUT(fFones)
      QOUT("")
      SETCURSOR(1)
      QUIT
   ENDIF
ELSE
   IF DATE()#DBPARM->DTSIS
      WHILE !DBPARM->(NetLReg()); ENDDO
      REPLACE DBPARM->DTSIS WITH DBPARM->DTSIS + 1
      DBPARM->(DBUNLOCK())
   ENDIF
   IF DBPARM->DTVALID - DBPARM->DTSIS <= 5
      Aviso("Sistema ir† bloquear em caso de n∆o pagamento em "+STR(DBPARM->DTVALID - DATE(),2)+" dia(s)")
   ENDIF
   IF nNivel>=9
      // Entrada da Data de Operaá∆o
      SETCOLOR(YCOREDIT)
      Telas(10,25,13,52,1,YCOREDIT,.T.,"Data de Hoje")
      @ 11,27 SAY ExtDia(DATE())+" "+DTOC(DATE()) COLOR YCOREDIT
      @ 12,27 SAY "Nova Data: " GET cDtSys PICT "@D" VALID !EMPTY(cDtSys)
      SETCURSOR(1); READ; SETCURSOR(0); Rest_Tela()
   ELSE
      cDtSys := DBPARM->DTTEST
   ENDIF
ENDIF

SETKEY(K_F1,{||Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)})

QuadroGeral("SAA - Vers∆o "+cVrs)
@ 00,50 SAY "<"+SUBS(cUsuario,1,AT(" ",cUsuario)-1)+">" COLOR YCORAVISO
@ 01,70 SAY cDtSys PICT "@D" COLOR YCORBARRA
LinhaMsg(1)

WHILE .T.
   SETCOLOR(YCORMENU)
   SETKEY(K_F4,{|| Calculadora(calc_lin,calc_col,YCORMENU)})
   SETKEY(K_F5,{|| Calendary(@cale_lin,@cale_col,@m_date)})
   SETKEY(K_LEFT ,NIL)
   SETKEY(K_RIGHT,NIL)

   cOpHelp1 := "0"
   cOpHelp2 := "00"
   cPrg     := "AE000"

   ProgName(cPrg)
   @ 01,07 PROMPT " Cadastro "     MESSAGE Msg("Cadastrar Alunos, Instrutores e Ve°culos")
   @ 01,20 PROMPT " Movimentaá∆o " MESSAGE Msg("Programaá∆o de Aulas e Pagamentos")
   @ 01,36 PROMPT " Relat¢rios "   MESSAGE Msg("Listagens Diversas")
   @ 01,52 PROMPT " Utilit†rios "  MESSAGE Msg("Rotinas Diversas")
   MENU TO nMenu_1

   IF nMenu_1 == 0
      IF Saida()
         Finalizar(); RETURN
      ENDIF
   ENDIF

   SETKEY(K_LEFT ,{|| cEsquerda()})
   SETKEY(K_RIGHT,{|| cDireita()})

#ifdef DEMO
   IF DATE()>=CTOD("30/04/97")
      CLS
      SETCOLOR("N/W")
      JanelaExp(0,0,11,79,1)
      @ 01,02 SAY fSystem
      @ 02,02 SAY "Vers∆o Demonstraá∆o - Todos os Direitos Reservados"
      @ 03,02 SAY "Data               "+DTOC(DATE())
      @ 04,02 SAY "Hora               "+TIME()
      @ 07,02 SAY "Vendas e Consultas: "+fEnder
      @ 08,02 SAY "                    Salvador-Bahia"
      @ 09,02 SAY "             "+fFones
      SETCOLOR("")
      @ 11,00 SAY ""
      QUIT
   ENDIF
#endif

   IF nMenu_1 == 1
      AE_100()
   ELSEIF nMenu_1 == 2
      AE_200()
   ELSEIF nMenu_1 == 3
      AE_300()
   ELSEIF nMenu_1 == 4
      AE_400()
   ENDIF
ENDDO
*’ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕ∏
*≥ Finalizaá∆o do Sistema       ≥
*‘ÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕÕæ
PROCEDURE Finalizar()
   SETKEY(K_F1,NIL)
   SETKEY(K_F4,NIL)
   SETKEY(K_F5,NIL)
   DBCLOSEALL()

   SELECT 1
   IF NetUse("USUARIO.SYS","USER")
      SET INDEX TO USUARIO
   ELSE
      DBCLOSEALL(); RETURN
   ENDIF
   DBSEEK("VSYS")
   IF _FIELD->REG_DEL >= 50
      IF NetLReg()
         REPLACE _FIELD->REG_DEL WITH 0
         DBUNLOCK()
      ENDIF
      CompacArq()     /* Compactar Arquivos */
   ENDIF

   SELECT 2
   IF !NetUse("DBPARM")
      DBCLOSEALL(); RETURN
   ENDIF

   // Numeracao do requerimento
   IF YEAR(DBPARM->DATA) # YEAR (DATE())
      WHILE !DBPARM->(NetLReg()); ENDDO
      REPLACE DBPARM->DATA WITH DATE() ,;
              DBPARM->REQ  WITH SUBS(DTOC(DATE()),9,2)+"00000"
      DBPARM->(DBUNLOCK())
   ENDIF

   IF !DBPARM->REX
      IF Confirma("Deseja Compactar Arquivo de Resultado de Exames ?")
         WHILE !DBPARM->(NetLReg()); ENDDO
         REPLACE DBPARM->REX WITH .T.
         DBPARM->(DBUNLOCK())

         IF NetUse("DBRES",,"E")            /* Cadastro de Exames */
            SET INDEX TO DBIRES1,DBIRES2
         ELSE
            DBCLOSEALL(); RETURN
         ENDIF
         Aguarde("Compactando arquivos...")
         DBRES->(__DBPACK()); DBCLOSEALL()
         IF NetUse("USUARIO.SYS","USER")
            SET INDEX TO USUARIO
         ELSE
            DBCLOSEALL(); RETURN
         ENDIF
      ENDIF
   ENDIF
   RELEASE zNLAN,zReq
   RETURN
//   Autor(.F.)         /* Termino Normal */
