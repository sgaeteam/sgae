*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_183                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Tabela de Consumos             ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 17/12/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 3
IF NetUse("DBLCON")                /* Arq.Lanamento de Consumos */
   SET INDEX TO DBILCON3,DBILCON2,DBILCON1
ELSE
   RETURN
ENDIF

SELECT 2
IF NetUse("DBRCON")                /* Arq.Resumo de Consumos */
   SET INDEX TO DBIRCON2,DBIRCON1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBTCON","TABCON")       /* Tabela de Consumos */
   SET INDEX TO DBICON1,DBICON2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "83"
cPrg:="AE183";LinhaMsg(2); ProgName(cPrg)
msg:="Opไes อ (^INS^) Inclui  (^ENTER^) Altera  (^DEL^) Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,10,15,69,1,YCOREDIT,.T.,"Tabela de Consumos")
Linha23(msg)
oBr:=TBROWSEDB(5,11,14,68)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Cขdigo",{|| TIPOCON})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Descriฦo",{|| DESCR})
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
   Telas(14,1,17,78,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
   @ 15,3 SAY "Cขdigo Descriฦo"
   vTipoCon:="  ";vDescr:=SPACE(30)
   @ 16,03 GET vTipoCon PICT "99"  VALID !EMPTY(vTipoCon).AND.TConta(vTipoCon)
   @ 16,10 GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
      WHILE !NetApp(); ENDDO
      TABCON->TIPOCON := vTipoCon
      TABCON->DESCR   := vDescr
      TABCON->(DBUNLOCK()); TABCON->(DBCOMMIT())
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
   Telas(14,1,17,78,1,YCOREDIT,.T.," Alteraฦo ")
   @ 15,3 SAY "Cขdigo Descriฦo"
   vTipoCon := TABCON->TIPOCON
   vDescr   := TABCON->DESCR
   @ 16,03 GET vTipoCon PICT "99" WHEN .F.
   @ 16,10 GET vDescr   PICT "@!" VALID !EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !TABCON->(NetLReg()); ENDDO
         REPLACE TABCON->DESCR WITH vDescr
         TABCON->(DBUNLOCK()); TABCON->(DBCOMMIT())
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

   IF Confirma("Confirma Exclusฦo ?")
      Aguarde("Eliminando...")

      /* Eliminar a movimentaฦo do tipo do consumo */
      DBLCON->(DBSEEK(TABCON->TIPOCON))
      WHILE DBLCON->CODCON==TABCON->TIPOCON.AND.!DBLCON->(EOF())
         WHILE !DBLCON->(NetLReg()); ENDDO
         DBLCON->(DBDELETE()); DBLCON->(DBUNLOCK()); DBLCON->(DBCOMMIT())
         DBLCON->(DBSKIP())
      ENDDO

      /* Eliminar do resumo */
      DBRCON->(DBSEEK(TABCON->TIPOCON))
      WHILE DBRCON->CODCON==TABCON->TIPOCON.AND.!DBRCON->(EOF())
         WHILE !DBRCON->(NetLReg()); ENDDO
         DBRCON->(DBDELETE()); DBRCON->(DBUNLOCK()); DBRCON->(DBCOMMIT())
         DBRCON->(DBSKIP())
      ENDDO

      /* Eliminar Item */
      WHILE !TABCON->(NetLReg()); ENDDO
      TABCON->(DBDELETE()); TABCON->(DBUNLOCK()); TABCON->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Conta   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TConta(pConta)
   IF (lRet:=DBSEEK(pConta))
      Aviso("Cขdigo j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
