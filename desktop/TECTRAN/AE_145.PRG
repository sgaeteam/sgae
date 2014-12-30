*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_145                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastro de Salas                        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/02/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 15
IF NetUse("DBSALA","SALA")         /* Salas */
   SET INDEX TO DBISALA1
ELSE
   RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "45"
cPrg:="AE145";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,2,20,77,1,YCOREDIT,.T.,"Cadastro de Salas/Vagas")
Linha23(msg)
oBr:=TBROWSEDB(5,3,19,76)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Sala"        ,{|| SALA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Mat/Repos"   ,{|| STR(VAGA_M,2)+"/"+STR(VAGAR_M,2)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ves/Repos"   ,{|| STR(VAGA_V,2)+"/"+STR(VAGAR_V,2)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Not/Repos"   ,{|| STR(VAGA_N,2)+"/"+STR(VAGAR_N,2)})
oBr:addColumn(oCol)

SET KEY -1 TO Mostra()
WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_INS )
      IF Acesso(5)
         Inclui(msg); oBr:refreshAll()
      ENDIF
   ELSEIF ( tecla == K_DEL )
      IF Acesso(5)
         Exclui(msg); oBr:refreshAll(); oBr:gotop()
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      IF Acesso(5)
         Altera(msg); oBr:refreshAll()
      ENDIF
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   Telas(16,2,20,77,c_nBorda,YCOREDIT,.T.," Inclusฦo Vagas")
   @ 17,03 SAY "         Matutino      Vespertino       Noturno"
   @ 18,03 SAY "Sala   Normal Repos.  Normal Repos.   Normal Repos."
*               99       99    99       99    99        99    99
*               3456789012345678901234567890123456789012345678901234567890123456789
*                      1         2         3         4         5         6
   vSala:=SPACE(2);vVaga_M:=vVaga_V:=vVaga_N:=vVagar_M:=vVagar_V:=vVagar_N:=0
   @ 19,03 GET vSala    PICT "99" VALID !EMPTY(vSala).AND.TSala(vSala)
   @ 19,12 GET vVaga_M  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_M>=0
   @ 19,18 GET vVagar_M PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_M>=0
   @ 19,27 GET vVaga_V  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_V>=0
   @ 19,33 GET vVagar_V PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_V>=0
   @ 19,43 GET vVaga_N  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_N>=0
   @ 19,49 GET vVagar_N PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_N>=0
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
      WHILE !NetApp(); ENDDO
      SALA->SALA    := vSala
      SALA->VAGA_M  := vVaga_M
      SALA->VAGAR_M := vVagar_M
      SALA->VAGA_V  := vVaga_V
      SALA->VAGAR_V := vVagar_V
      SALA->VAGA_N  := vVaga_N
      SALA->VAGAR_N := vVagar_N
      SALA->(DBUNLOCK()); SALA->(DBCOMMIT())
      ProcOk("Incluido",.T.)
   ELSE
      GO nReg_Ant
   ENDIF
   Rest_Tela(); Linha23(msg)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SETCOLOR(YCOREDIT)
   Telas(16,2,20,77,1,YCOREDIT,.T.," Alteraฦo Vagas")
   @ 17,03 SAY "         Matutino      Vespertino       Noturno"
   @ 18,03 SAY "Sala   Normal Repos.  Normal Repos.   Normal Repos."
   vSala    := SALA
   vVaga_M  := VAGA_M
   vVagar_M := VAGAR_M
   vVaga_V  := VAGA_V
   vVagar_V := VAGAR_V
   vVaga_N  := VAGA_N
   vVagar_N := VAGAR_N

   @ 19,03 GET vSala    PICT "99" WHEN .F.
   @ 19,12 GET vVaga_M  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_M>=0
   @ 19,18 GET vVagar_M PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_M>=0
   @ 19,27 GET vVaga_V  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_V>=0
   @ 19,33 GET vVagar_V PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_V>=0
   @ 19,43 GET vVaga_N  PICT "99" VALID (LASTKEY()==K_UP).OR.vVaga_N>=0
   @ 19,49 GET vVagar_N PICT "99" VALID (LASTKEY()==K_UP).OR.vVagar_N>=0
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !SALA->(NetLReg()); ENDDO
         REPLACE SALA->VAGA_M  WITH vVaga_M  ,;
                 SALA->VAGA_V  WITH vVaga_V  ,;
                 SALA->VAGA_N  WITH vVaga_N  ,;
                 SALA->VAGAR_M WITH vVagar_M ,;
                 SALA->VAGAR_V WITH vVagar_V ,;
                 SALA->VAGAR_N WITH vVagar_N
         SALA->(DBUNLOCK()); SALA->(DBCOMMIT())
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   // Verificar se a sala possui designacao de aulas para alunos
   Aviso("Em desenvolvimento...")
*     IF Confirma("Confirma Exclusฦo ?")
*        Aguarde("Eliminando...")
*        WHILE !SALA->(NetLReg()); ENDDO
*        SALA->(DBDELETE()); SALA->(DBUNLOCK()); SALA->(DBCOMMIT())
*        Aguarde(); Linha23(msg)
*     ENDIF
*     Aguarde()
   Linha23(msg)
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Sala    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TSala(pVar)
   IF (lRet:=SALA->(DBSEEK(pVar)))
      Aviso("Sala j  existente...",,3)
   ENDIF
   RETURN(!lRet)
