*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_151                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Tabela de Pre‡os                         ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 03/02/2001                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 2
IF NetUse("DBCATEG","CATEGORIA")       /* Categoria Veicular */
   SET INDEX TO DBICAT1
ELSE
   RETURN
ENDIF

SELECT 12
IF NetUse("DBPLANO","PLANO")           /* Plano de Contas */
   SET INDEX TO DBIPLAN1,DBIPLAN2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPRECO","PRECO")           /* Tabela de Pre‡os */
   SET INDEX TO DBIPREC2, DBIPREC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE151"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,19,75,1,YCOREDIT,.T.,"Tabela de Pre‡os/Servi‡os")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,18,74)
oBr:headSep:="ÄÂÄ"
oBr:colSep:= " ³ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("C¢d."         ,{|| CODSERV})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Descri‡Æo"    ,{|| TRANSFORM(DESCR,"@S30")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Vlr.Unit."    ,{|| TRANSFORM(VLUNIT,"@E 9,999.99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Te"           ,{|| AULAS_T})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pr"           ,{|| AULAS_P})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ctg"          ,{|| IDCAT})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Cont bil"     ,{|| TRANSFORM(CONTA,"@R 9.9.9.9.999")})
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
      IF !EMPTY(PRECO->CODSERV)
         IF Acesso(9); Exclui(msg); oBr:refreshAll(); oBr:gotop(); ENDIF
      ELSE
         Aviso("NÆo h  registro a ser excluido")
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      IF !EMPTY(PRECO->CODSERV)
         IF Acesso(5); Altera(msg); oBr:refreshAll(); ENDIF
      ELSE
         Aviso("NÆo h  registro a ser alterado")
      ENDIF
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),18,6,60)
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DBCLOSEALL(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Incluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := PRECO->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(14,5,19,75,1,YCOREDIT,.T.,"InclusÆo de Servi‡os")
   WHILE .T.
      PRECO->(DBGOBOTTOM()); PRECO->(DBSKIP())
      FOR a = 1 TO PRECO->(FCOUNT())
          xVar  := "w"+PRECO->(FIELDNAME(a))
          &xVar := PRECO->(FIELDGET(a))
      NEXT

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma InclusÆo ?")
         // Gravar no arquivo de Servi‡os
         WHILE !PRECO->(NetApp()); ENDDO
         FOR a = 1 TO PRECO->(FCOUNT())
             xVar  := "w"+PRECO->(FIELDNAME(a))
             PRECO->(FIELDPUT(a,&xVar))
         NEXT
         PRECO->(DBUNLOCK()); PRECO->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Cadastrar outro Servi‡o ?"); EXIT; ENDIF
         SCROLL(16,6,18,74,0)
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
   RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Alterar Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("NÆo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(14,5,19,75,1,YCOREDIT,.T.,"Altera‡Æo Dados do Servi‡o")

   FOR a = 1 TO PRECO->(FCOUNT())
       xVar  := "w"+PRECO->(FIELDNAME(a))
       &xVar := PRECO->(FIELDGET(a))
   NEXT

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera‡Æo ?")
         GO nReg_Ant
         WHILE !PRECO->(NetLReg()); ENDDO
         FOR a = 1 TO PRECO->(FCOUNT())
             xVar  := "w"+PRECO->(FIELDNAME(a))
             PRECO->(FIELDPUT(a,&xVar))
         NEXT
         PRECO->(DBUNLOCK()); PRECO->(DBCOMMIT())

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Excluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := PRECO->(RECNO()), lExcl := .F.

   PRECO->(DBGOTOP())
   IF EOF()
      Aviso("NÆo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma ExclusÆo do Servi‡o ?")
      Aguarde("Eliminando...")

      WHILE !PRECO->(NetLReg()); ENDDO
      PRECO->(DBDELETE()); PRECO->(DBUNLOCK()); PRECO->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Editar campos de dados       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE EditaGet(pOp)
   @ 15,07 SAY "C¢digo.....:"  GET wCodServ  PICT "@!" WHEN pOp=="I" VALID !EMPTY(wCodServ).AND.TExist(wCodServ)
   @ 15,33 SAY "Servi‡o..:"    GET wDescr    PICT "@!"               VALID LASTKEY()==K_UP.OR.!EMPTY(wDescr)
   @ 16,07 SAY "Cont bil...:"  GET wConta    PICT "@R 9.9.9.9.999"   VALID !EMPTY(wConta).AND.Pesquisa(12,1,wConta,"Conta nÆo Cadastrada!").AND.Let(wHist:=PLANO->DESCR)
   @ 16,33 SAY "Hist¢rico:"    GET wHist     PICT "@!"               WHEN .F.
   @ 17,07 SAY "Vl.Unit rio:"  GET wVlunit   PICT "@E 9,999.99"      VALID LASTKEY()==K_UP.OR.!EMPTY(wVlunit)
   @ 17,33 SAY "Categoria:"    GET wIDCat    PICT "!"                VALID !EMPTY(wIDCat).AND.Pesquisa(2,1,wIdCat,"Categoria nÆo Cadastrada!").AND.TDescr(2,1,17,46,wIdCat,"DESCR","[@S25]")
   @ 18,07 SAY "Te¢rica....:"  GET wAulas_T  PICT "99"
   @ 18,33 SAY "Pr tica..:"    GET wAulas_P  PICT "99"
   RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar Codigo j  Existe      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION TExist(pVar)
  LOCAL nReg:=PRECO->(RECNO()); lRet:=.F.
  PRECO->(DBSETORDER(2))
  IF (lRet:=PRECO->(DBSEEK(pVar)))
     Aviso("Servi‡o j  Cadastrado!")
  ENDIF
  PRECO->(DBSETORDER(1))
  RETURN(!lRet)
