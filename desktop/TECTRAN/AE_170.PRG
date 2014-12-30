*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_170                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Itens de Caixa - Tesouraria    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE                     ณ
*ณ DATA CRIACAO   : 20/02/1995                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 2
IF !NetUse("DBPARM")            /* Parametros */
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBITEM","ITEM")      /* Itens de Caixa */
   SET INDEX TO DBITEM1,DBITEM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "70"
cPrg:="AE170";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,2,19,76,1,YCOREDIT,.T.,"Cadastro de Itens de Caixa")
Linha23(msg)
oBr:=TBROWSEDB(5,3,18,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Cขdigo"       ,{|| ITEM_CX})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Item"         ,{|| DESCR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("C/D"          ,{|| CD})
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
      SET KEY -1 TO Mostra()
      nReg_Ant := RECNO()
      Telas(16,2,19,76,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
      @ 17,03 SAY "Cขdigo Descriฦo do Item                   C/D"
*                   9999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxx  X
*                  34567890123456789012345678901234567890123456789012345678901234567890
*                         1         2         3         4         5         6         7
      vItem_cx:=STRZERO(VAL(DBPARM->ITEM_CX)+1,4);vDescr:=SPACE(35);vCD:="D"
      @ 18,04 GET vItem_cx PICT "9999" WHEN .F.
      @ 18,10 GET vDescr   PICT "@!"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
      @ 18,47 GET vCD      PICT "!"    VALID (LASTKEY()==K_UP).OR.vCD$"CD"
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         IF TItem(vItem_cx,.F.)
            vItem_cx:=STRZERO(VAL(DBPARM->ITEM_CX)+1,4)
         ENDIF
         WHILE !NetApp(); ENDDO
         ITEM->ITEM_CX   := vItem_cx
         ITEM->DESCR     := vDescr
         ITEM->CD        := vCD
         ITEM->(DBUNLOCK()); ITEM->(DBCOMMIT())

         // Atualiza Parametros
         DBPARM->(DBGOTOP())
         WHILE !DBPARM->(NetLReg()); ENDDO
         REPLACE DBPARM->ITEM_CX WITH STRZERO(VAL(DBPARM->ITEM_CX)+1,4)
         DBPARM->(DBUNLOCK()); DBPARM->(DBCOMMIT())

         ProcOk("Incluกdo",.T.)
      ELSE
         GO nReg_Ant
      ENDIF
      Rest_Tela(); Linha23(msg)
      oBr:refreshAll()
   ELSEIF ( tecla == K_DEL )
*     Nao pode excluir se existir lancamento no arq. dbcx
*      Exclui(msg); oBr:refreshAll(); oBr:gotop()
   ELSEIF ( tecla == K_ENTER )
      nReg_Ant := RECNO(); lAlt := .F.

      DBGOTOP()
      IF EOF()
         Aviso("Nฦo h  registro a ser Alterado !",,2)
         Linha23(msg)
      ELSE
         GO nReg_Ant
         SET KEY -1 TO Mostra()
         SETCOLOR(YCOREDIT)
         Telas(16,2,19,76,1,YCOREDIT,.T.," Alteraฦo ")
         @ 17,03 SAY "Cขdigo Descriฦo do Item                   C/D"
         vItem_cx := ITEM_CX
         vDescr   := DESCR
         vCD      := CD
         @ 18,04 GET vItem_cx PICT "9999" WHEN .F.
         @ 18,10 GET vDescr   PICT "@!"   VALID !EMPTY(vDescr)
         @ 18,47 GET vCD      PICT "!"    VALID (LASTKEY()==K_UP).OR.vCD$"CD"
         SETCURSOR(1); READ; SETCURSOR(0)

         IF LASTKEY()#K_ESC.AND.UPDATED()
            IF Confirma("Confirma Alteraฦo ?")
               GO nReg_Ant
               WHILE !ITEM->(NetLReg()); ENDDO
               REPLACE ITEM->DESCR   WITH vDescr ,;
                       ITEM->CD      WITH vCD
               ITEM->(DBUNLOCK()); ITEM->(DBCOMMIT())
               ProcOk("Alterado",.T.)
               lAlt := .T.
            ENDIF
         ENDIF
      ENDIF
      Rest_Tela(); GO nReg_Ant; Linha23(msg)
      oBr:refreshAll()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
Rest_Tela(); Linha23(msg); RESTSCREEN(2,0,24,79,vTela); SETCOLOR(corant)
RETURN
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
   WHILE !NetLReg(); ENDDO
   DBDELETE(); DBUNLOCK(); DBCOMMIT()
   Aguarde(); Linha23(msg)
   RETURN(.T.)
