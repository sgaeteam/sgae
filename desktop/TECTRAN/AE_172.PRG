*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_172                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tabela de Adm. Cartไes de Crdito        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/02/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 1
IF NetUse("DBACC","CARTAO")       /* Tabela de Adm. Cartไes de Crdito */
   SET INDEX TO DBIACC1
ELSE
   RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "72"
LinhaMsg(2); ProgName("AE172")
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,10,17,69,1,YCOREDIT,.T.,"Adm. Cartไes de Crdito")
Linha23(msg)
oBr:=TBROWSEDB(5,11,16,68)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Cขd."           ,{|| CODCARD})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Administradora" ,{|| DESCR})
oBr:addColumn(oCol)

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
      Inclui(msg); oBr:refreshAll()
   ELSEIF ( tecla == K_DEL )
      Exclui(msg); oBr:refreshAll(); oBr:gotop()
   ELSEIF ( tecla == K_ENTER )
      Altera(msg); oBr:refreshAll()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   Telas(15,10,18,69,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
   vCodigo:=SPACE(2);vDescr:=SPACE(20)
   @ 16,12 SAY "Cขdigo...:" GET vCodigo  PICT "99" VALID !EMPTY(vCodigo).AND.TCartao(vCodigo)
   @ 17,12 SAY "Descriฦo:" GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
      WHILE !NetApp(); ENDDO
      CARTAO->CODCARD := vCodigo
      CARTAO->DESCR   := vDescr
      CARTAO->(DBUNLOCK()); CARTAO->(DBCOMMIT())
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
   Telas(15,10,18,69,1,YCOREDIT,.T.," Alteraฦo ")
   vCodigo  := CODCARD
   vDescr   := DESCR

   @ 16,12 SAY "Cขdigo...:" GET vCodigo  PICT "99"   WHEN .F.
   @ 17,12 SAY "Descriฦo:" GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !CARTAO->(NetLReg()); ENDDO
         REPLACE CARTAO->CODCARD WITH vCodigo,;
                 CARTAO->DESCR   WITH vDescr
         CARTAO->(DBUNLOCK()); CARTAO->(DBCOMMIT())
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

   Aviso("Esta operaฦo eliminar  qualquer referncia a este cartฦo!")
   IF Confirma("Confirma Exclusฦo do Cartฦo ?")
      Aguarde("Eliminando...")

      WHILE !NetLReg(); ENDDO
      DBDELETE(); DBUNLOCK(); DBCOMMIT()
      Aguarde()
   ENDIF
   Linha23(msg)
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia do CARTAO  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCARTAO(pCod)
   IF (lRet:=DBSEEK(pCod))
      Aviso("CARTวO j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
