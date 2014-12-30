*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_142                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tabela de Disciplinas                    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/02/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 2
IF NetUse("DBCURSO","CURSO")          /* Cursos */
   SET INDEX TO DBICUR1
ELSE
   RETURN
ENDIF
IF EOF()
   Aviso("Voc deve cadastrar primeiro os cursos!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 13
IF NetUse("DBDISC","DISCIPLINA")      /* Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "42"
cPrg:="AE142"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui  ^ENTER^-Altera  ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,7,6,71,1,YCOREDIT,.T.,"Cadastro de Disciplinas")
Telas(6,7,19,71,1,YCOREDIT,.T.)
xCodCur:=SPACE(2)
WHILE .T.
   SET KEY -1 TO Mostra()
   @ 05,09 SAY "Curso: " GET xCodCur PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(xCodCur).AND.;
     Pesquisa(2,1,xCodCur,"Cขdigo do Curso nฦo Localizado!").AND.TDescr(2,1,5,20,xCodCur,"DESCR")
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC
      Rest_Tela(2); Linha23(msg); RESTSCREEN(2,0,24,79,vTela); SETCOLOR(corant)
      DBCLOSEALL(); RETURN
   ENDIF
   SET FILTER TO
   DISCIPLINA->(DBCLEARFILTER())
   DISCIPLINA->(DBSETFILTER({||CODCUR=xCodCur}, [CODCUR=xCodCur])); DISCIPLINA->(DBGOTOP())
   SETKEY(K_F2,NIL)
   BrowDis()
   DISCIPLINA->(DBCLEARFILTER())
   SET FILTER TO
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Browse das Disciplinas       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE BrowDis()
   Linha23(msg)
   oBr:=TBROWSEDB(7,8,18,70)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCOREDIT

   oCol:=TBCOLUMNNEW("Disciplinas"   ,{|| CODDIS+"-"+DESCR})
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
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   Telas(16,7,19,71,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
   @ 17,09 SAY "Cขd. Descriฦo"
*               99   XXXXXXXXXXxxxxxxxxxxXXXXX
*               9012345678901234567890123456789012345678901234567890123456789
*                1         2         3         4         5         6
   vCodigo:=SPACE(2);vDescr:=SPACE(25)
   @ 18,09 GET vCodigo  PICT "99"  VALID !EMPTY(vCodigo).AND.TCurso(xCodCur+vCodigo)
   @ 18,14 GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ELSE
      IF Confirma("Confirma Inclusฦo ?")
         WHILE !NetApp(); ENDDO
         DISCIPLINA->CODCUR  := xCodCur
         DISCIPLINA->CODDIS  := vCodigo
         DISCIPLINA->DESCR   := vDescr
         DISCIPLINA->(DBUNLOCK()); DISCIPLINA->(DBCOMMIT())
         ProcOk("Incluido",.T.)
      ELSE
         GO nReg_Ant
      ENDIF
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
   Telas(16,7,19,71,1,YCOREDIT,.T.," Alteraฦo ")
   @ 17,09 SAY "Cขd. Descriฦo"
   vCodigo  := CODDIS
   vDescr   := DESCR

   @ 18,09 GET vCodigo  PICT "99"  WHEN .F.
   @ 18,14 GET vDescr   PICT "@!"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !DISCIPLINA->(NetLReg()); ENDDO
         REPLACE DISCIPLINA->CODDIS  WITH vCodigo,;
                 DISCIPLINA->DESCR   WITH vDescr
         DISCIPLINA->(DBUNLOCK()); DISCIPLINA->(DBCOMMIT())
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   IF LEN(Telas)==6; Rest_Tela(); ENDIF
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

   Aviso("Analisando impacto desta operaฦo no sistema...")
*  /* Eliminar Disciplina */
*  WHILE !NetLReg(); ENDDO
*  DBDELETE(); DBUNLOCK(); DBCOMMIT()

   Aguarde(); Linha23(msg)
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Discipl.ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCurso(pCod)
   IF (lRet:=DBSEEK(pCod))
      Aviso("Disciplina j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
