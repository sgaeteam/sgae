*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_147                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Tabela de Conteudo Programatico          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 01/04/2004                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()

SELECT 2
IF NetUse("DBCATEG","CATEG")
   SET INDEX TO DBICAT1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 31
IF NetUse("DBCP","CP")       /* Tabela de Conteudo Pratico */
   SET INDEX TO DBICP2,DBICP1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "47"
cPrg:="AE147";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,20,76,1,YCOREDIT,.T.,"Conteฃdo Program tico - Aulas Pr ticas")
Linha23(msg)
oBr:=TBROWSEDB(5,4,19,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Aula"                 ,{|| AULA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Cat."                 ,{|| CATEG})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Conteฃdo Program tico",{|| TRANSFORM(CP,"@S55")})
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
   SET KEY -1 TO Mostra()
   Telas(16,3,20,76,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
   vCateg:=" ";vCodigo:=SPACE(2);vDescr1:=SPACE(33);vDescr2:=SPACE(32)
   @ 17,04 SAY "Categoria:" GET vCateg   PICT "!"  WHEN TeclaFuncao(.T.) VALID Pesquisa(2,1,vCateg,"Categoria Nฦo Cadastrada!")
   @ 17,19 SAY "Aula:"      GET vCodigo  PICT "99" WHEN TeclaFuncao(.F.) VALID !EMPTY(vCodigo).AND.TCP(vCateg+vCodigo)
   @ 18,04 SAY "Conteฃdo :" GET vDescr1  PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr1)
   @ 19,04 SAY "         :" GET vDescr2  PICT "@!"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
      WHILE !NetApp(); ENDDO
      CP->AULA := STRZERO(VAL(vCodigo),2)
      CP->CATEG:= vCateg
      CP->CP   := vDescr1+vDescr2
      CP->(DBUNLOCK()); CP->(DBCOMMIT())
      ProcOk("Incluido",.T.)
   ELSE
      GO nReg_Ant
   ENDIF
   Rest_Tela(); SETKEY(K_F2,NIL); Linha23(msg)
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
   Telas(16,3,20,76,1,YCOREDIT,.T.," Alteraฦo ")
   vCodigo  := AULA
   vCateg   := CATEG
   vDescr1  := SUBS(CP,1,33)
   vDescr2  := SUBS(CP,34)

   @ 17,04 SAY "Categoria:" GET vCateg   PICT "!"  WHEN .F.
   @ 17,19 SAY "Aula:"      GET vCodigo  PICT "99" WHEN .F.
   @ 18,04 SAY "Conteฃdo :" GET vDescr1  PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr1)
   @ 19,04 SAY "         :" GET vDescr2  PICT "@!"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !CP->(NetLReg()); ENDDO
         REPLACE CP->AULA  WITH vCodigo,;
                 CP->CATEG WITH vCateg ,;
                 CP->CP    WITH vDescr1+vDescr2
         CP->(DBUNLOCK()); CP->(DBCOMMIT())
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
   WHILE !NetLReg(); ENDDO
   DBDELETE(); DBUNLOCK(); DBCOMMIT()
   Aguarde(); Linha23(msg)
   RETURN(.T.)
* ออออออออออออออออออออออออออออออ
*ณ Testar Existencia do Conteudoณ
* ออออออออออออออออออออออออออออออ
STATIC FUNCTION TCP(pCod)
   IF (lRet:=DBSEEK(pCod))
      Aviso("Aula desta Categoria j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
