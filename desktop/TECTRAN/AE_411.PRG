*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : EB_411                           vrs 001 ณ
*ณ VRS 001        : Desenvolvimento                          ณ
*ณ FINALIDADE     : Configurao de Usu rios do Sistema      ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 01/03/1994                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL tela := SAVESCREEN(2,0,24,79), cCorant := SETCOLOR()

IF NetUse("USUARIO.SYS","USER")
   SET INDEX TO USUARIO
ELSE
   DBCLOSEALL(); RETURN
ENDIF
DBSEEK("NET4")

ProgName("EB411"); Area_Dados()
Quadro(7,13,12,65,1,YCOREDIT,.T.,"Usu rio do Sistema",.T.)
SETCOLOR(YCOREDIT)
SET(_SET_CONFIRM,.T.)
WHILE .T.
   cUser := SPACE(30)
   @ 09,15 SAY "Usu rio Anterior : "+USER->REGISTRO
   @ 10,15 SAY "Novo Usu rio     :"GET cUser PICT "@!" VALID TUser(cUser)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY() == K_ESC; EXIT; ENDIF

   IF UPDATED()
      IF Confirma("Confirma Alterao ? ")
         WHILE !(USER->(NetLReg())); ENDDO
         REPLACE USER->REGISTRO WITH cUser
         cUsuario := cUser
         UNLOCK; DBCOMMIT()
         ProcOk("Alterado",.F.)
         EXIT
      ENDIF
   ENDIF
ENDDO
SET(_SET_CONFIRM,.F.)
SETCOLOR(cCorant)
RESTSCREEN(2,0,24,79,tela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Entrada do Usuario    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TUser(pUser)
   IF EMPTY(pUser)
      Aviso("Campo Obrigatขrio!",,2); RETURN .F.
   ENDIF
   RETURN .T.
