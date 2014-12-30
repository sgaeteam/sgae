*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_130                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Cadastrar Ve¡culos                       ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 06/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 20
IF !NetUse("DBPARM")                  /* Tabela de Parametros */
   RETURN
ENDIF

SELECT 3
IF NetUse("DBPROG","AULAS")           /* Programa‡Æo de Aulas Praticas */
   SET INDEX TO DBIPRO3,DBIPRO2,DBIPRO1
ELSE
   RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO INSTRUTOR->CATEG=="1".OR.INSTRUTOR->CATEG=="3"
IF INSTRUTOR->(EOF())
   Aviso(" preciso cadastrar os instrutores primeiro",,3)
   SET FILTER TO
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBVEIC","VEICULO")         /* Ve¡culos */
   SET INDEX TO DBIVEI3,DBIVEI1,DBIVEI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "20"
cPrg:="AE130"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui ^F7^-Reativar"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,17,75,1,YCOREDIT,.T.,"Cadastro de Ve¡culos")
Telas(17,5,19,75,1,YCOREDIT,.T.,"Pesquisa")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,16,74)
oBr:headSep:="ÄÂÄ"
oBr:colSep:= " ³ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("C¢d."         ,{|| CODVEIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Status"       ,{|| IF(STATUS=="A","Ativo  ",IF(STATUS="I","Inativo",SPACE(7)))})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ve¡culo"      ,{|| TRANSFORM(MARCA,"@S18")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Placa"        ,{|| TRANSFORM(PLACA,"@R XXX-9999")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Instrutor"    ,{|| TRANSFORM(PegaInst(CODINST),"@S20")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("KM Inicio"    ,{|| TRANSFORM(KMINI,"@E 999999.9")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("KM Atual"     ,{|| TRANSFORM(KMATU,"@E 999999.9")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("KM Rodados"   ,{|| TRANSFORM(KMATU-KMINI,"@E 999999.9")})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()==0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_F7 )
      IF !EMPTY(VEICULO->CODVEIC)
         IF VEICULO->STATUS=="I"
            IF Confirma("Deseja Reativar Ve¡culo ?")
               WHILE !VEICULO->(NetLReg()); ENDDO
               REPLACE VEICULO->STATUS  WITH "A"      ,;
                       VEICULO->CODINST WITH SPACE(4)
               VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())
               ProcOk("Reativado",.T.)
               oBr:refreshAll()
            ENDIF
         ELSE
            Aviso("Ve¡culo j  se encontra ATIVO")
         ENDIF
      ENDIF
   ELSEIF ( tecla == K_INS )
      Inclui(msg); oBr:refreshAll()
   ELSEIF ( tecla == K_DEL )
      IF Acesso(9)
         Aviso("Esta opera‡Æo elimina os lan‡amentos que envolve este Veiculo!")
         Exclui(msg); oBr:refreshAll(); oBr:gotop()
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      Altera(msg); oBr:refreshAll()
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),18,6,60)
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela(2)
RESTSCREEN(2,0,24,79,vTela)
SET FILTER TO; DBCLOSEALL(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Incluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := VEICULO->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(4,5,19,75,1,YCOREDIT,.T.,"InclusÆo de Ve¡culo")
   wCodVeic:= STRZERO(VAL(DBPARM->CODVEIC)+1,3)
   xCodVeic:= wCodVeic
   WHILE .T.
      VEICULO->(DBGOBOTTOM()); VEICULO->(DBSKIP())
      FOR a = 1 TO VEICULO->(FCOUNT())
          xVar  := "w"+VEICULO->(FIELDNAME(a))
          &xVar := VEICULO->(FIELDGET(a))
      NEXT
      wCodVeic:= xCodVeic
      wStatus := "A"

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma InclusÆo ?")
         /* Gravar no arquivo de parametros */
         DBPARM->(DBGOTOP())
         IF DBPARM->(EOF()); DBPARM->(NetApp()); ENDIF
         WHILE !DBPARM->(NetLReg()); ENDDO
         wCodVeic := STRZERO(VAL(DBPARM->CODVEIC)+1,3)
         REPLACE DBPARM->CODVEIC WITH wCodVeic
         DBPARM->(DBUNLOCK())

         // Gravar no arquivo de Veiculos
         wNome:=INSTRUTOR->NOME
         WHILE !VEICULO->(NetApp()); ENDDO
         FOR a = 1 TO VEICULO->(FCOUNT())
             xVar  := "w"+VEICULO->(FIELDNAME(a))
             VEICULO->(FIELDPUT(a,&xVar))
         NEXT
         VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outro Ve¡culo ?"); EXIT; ENDIF
         SCROLL(5,6,18,74,0)
         xCodVeic := wCodVeic
      ELSE
         VEICULO->(DBGOTO(nReg_Ant)); EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
   RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Alterar Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := VEICULO->(RECNO()), lAlt := .F.

   VEICULO->(DBGOTOP())
   IF VEICULO->(EOF())
      Aviso("NÆo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   VEICULO->(DBGOTO(nReg_Ant))

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(4,5,19,75,1,YCOREDIT,.T.,"Altera‡Æo Dados do Ve¡culo")

   wCodVeic := VEICULO->CODVEIC
   FOR a = 1 TO VEICULO->(FCOUNT())
       xVar  := "w"+VEICULO->(FIELDNAME(a))
       &xVar := VEICULO->(FIELDGET(a))
   NEXT

   wCodInstAnt:=wCodInst
   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera‡Æo ?")
         VEICULO->(DBGOTO(nReg_Ant))
         wNome:=INSTRUTOR->NOME
         WHILE !VEICULO->(NetLReg()); ENDDO
         FOR a = 1 TO VEICULO->(FCOUNT())
             xVar  := "w"+VEICULO->(FIELDNAME(a))
             VEICULO->(FIELDPUT(a,&xVar))
         NEXT
         VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())

         /* Alterar a programa‡Æo para novo instrutor */
         IF wCodInstAnt#wCodInst
            AULAS->(DBSETORDER(1))
            Aguarde("Transferindo aulas para novo instrutor...")
            AULAS->(DBSEEK(wCodVeic+DTOS(DATE()),.T.))
            WHILE AULAS->CODVEIC==wCodVeic.AND.!AULAS->(EOF())
               WHILE !AULAS->(NetLReg()); ENDDO
               REPLACE AULAS->CODINST WITH wCodInst
               AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
               AULAS->(DBSKIP())
            ENDDO
            Aguarde()
         ENDIF

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); VEICULO->(DBGOTO(nReg_Ant)); Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Excluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := VEICULO->(RECNO()), lExcl := .F.

   VEICULO->(DBGOTOP())
   IF VEICULO->(EOF())
      Aviso("NÆo h  registro a ser Inativado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   VEICULO->(DBGOTO(nReg_Ant))

   IF Confirma("Confirma Inatividade do VEICULO ?")
      IF AULAS->(DBSEEK(VEICULO->CODVEIC+DTOS(DATE()),.T.))
         Aviso("Este ve¡culo possui alunos com aulas marcadas.")
      ELSE
         Aguarde("Inativado...")
         WHILE !VEICULO->(NetLReg()); ENDDO
         REPLACE VEICULO->STATUS WITH "I"
         VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())
         Aguarde()
      ENDIF
      Linha23(msg)
   ENDIF
   RETURN(.T.)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Editar campos de dados       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC PROCEDURE EditaGet(pOp)
   LOCAL wKmRoda:=0.0
   IF pOp=="A"
      TDescr(2,1,7,23,wCodInst,"NOME")
      wKmRoda:=wKmatu-wKmini
   ENDIF
   @ 05,07 SAY "Ve¡culo..:"      GET wMarca    PICT "@!" VALID !EMPTY(wMarca)
   @ 06,07 SAY "Placa....:"      GET wPlaca    PICT "@R !!!-9999" WHEN TeclaFuncao()
   @ 07,07 SAY "Instrutor:"      GET wCodInst  PICT "9999" WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.TDescr(2,1,7,23,wCodInst,"NOME",,"C¢digo NÆo Localizado")
   @ 08,05 SAY "Ã"+REPL("Ä",69)+"´"
   @ 09,07 SAY "Quilometragem"
   @ 10,07 SAY "ßßßßßßßßßßßßß"
   @ 11,07 SAY "Inicial..:"      GET wKmini    PICT "@E 999,999.9" WHEN TeclaFuncao()
   @ 12,07 SAY "Atual....:"      GET wKmatu    PICT "@E 999,999.9" VALID LASTKEY()==K_UP.OR.wKmatu>=wKmini.AND.Let(wKmRoda:=wKmatu-wKmini)
   @ 13,07 SAY "Rodados..:"      GET wKmRoda   PICT "@E 999,999.9" WHEN .F.
   @ 14,05 SAY "Ã"+REPL("Ä",69)+"´"
   IF wStatus=="A"
      @ 15,20 SAY "Ativo" COLOR YCORREALCE
   ELSE
      @ 15,20 SAY "Inativo" COLOR YCORREALCE
   ENDIF
   @ 15,07 SAY "Situa‡Æo.:"      GET wStatus   PICT "!" WHEN .F.
   RETURN
