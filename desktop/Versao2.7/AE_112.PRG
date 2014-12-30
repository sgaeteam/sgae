*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_112                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Registro de LADV                         ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 04/05/2001                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela, oBr1, oCol1, vTela2

DBCLOSEALL()
SELECT 2
IF NetUse("DBINST","INSTRUTOR")       /* Cadastro de Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO STATUS="A".AND. CATEG="1".OR.CATEG="3"
IF INSTRUTOR->(EOF())
   Aviso("Voc precisa cadastrar os instrutores primeiro",,3)
   DBCLOSEALL(); RETURN
ENDIF

SELECT 6
IF NetUse("DBPEND","PENDENCIA")        /* Arquivo de Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 8
IF NetUse("DBREQ","REQ")             /* Requerimentos */
   SET INDEX TO DBIREQ1
ELSE
   RETURN
ENDIF

SELECT 3
IF NetUse("DBLADV","LADV")             /* LADV */
   SET INDEX TO DBILADV1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBALU","ALUNO")             /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "12"
cPrg:="AE112"; LinhaMsg(2); ProgName(cPrg)
msg:="^ENTER^-Seleciona ^F2^-Consulta"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,20,76,1,YCOREDIT,.T.,"Entradas e Entrega de LADV")
Telas(18,3,20,76,1,YCOREDIT,.T.,"Pesquisa")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,4,17,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Matr."   ,{|| MATRIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Aluno"   ,{|| NOME})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )   // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F2 )   // Pesquisa
      Mostra()
      cBuffer := ""
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_ENTER )  // Seleciona
      IF Acesso(3)
         LADV->(DBSEEK(ALUNO->MATRIC))
         SeleAluno(msg)
         oBr:refreshAll()
         Linha23("^ENTER^-Seleciona ^F2^-Consulta")
      ENDIF
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),19,6,60)
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela(2)
RESTSCREEN(2,0,24,79,vTela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Browse do Aluno Selecionado  ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION SeleAluno(msg)
  LOCAL oBr1, oCol1

  SELECT LADV
  SET FILTER TO MATRIC==ALUNO->MATRIC
  SETCOLOR(YCOREDIT)
  Telas(4,3,20,76,1,YCOREDIT,.T.," Histขrico LADV ")
  Linha23("^ESC^-Retorna ^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui")

  @ 05,05 SAY "Aluno:" GET ALUNO->NOME WHEN .F.
  CLEAR GETS
  @ 06,03 SAY "ร"+REPL("ฤ",72)+"ด"
  ChkPend(ALUNO->MATRIC)  // Verifica pendencia
  ChkPReq(ALUNO->MATRIC)  // Verifica pendencia de requerimento
  oBr1:=TBROWSEDB(7,4,19,75)
  oBr1:headSep:="ฤยฤ"
  oBr1:colSep:= " ณ "

  oCol1:=TBCOLUMNNEW("Nง LADV"    ,{|| NUM})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Emissฦo"    ,{|| EMISSAO})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Sit."       ,{|| SIT})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Instrutor"  ,{|| TRANSFORM(PegaInst(CODINST),"@S30")})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Livro"      ,{|| LIVRO})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("P g."       ,{|| PAGINA})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Entrega"    ,{|| ENTREGA})
  oBr1:addColumn(oCol1)
  oCol1:=TBCOLUMNNEW("Observaไes",{|| OBS})
  oBr1:addColumn(oCol1)
  IF nNivel>=5
     oCol1:=TBCOLUMNNEW("Usu rio" ,{|| USER})
     oBr1:addColumn(oCol1)
  ENDIF

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr1:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        SET FILTER TO
        LADV->(DBGOTOP())
        SELECT ALUNO
        Rest_Tela()
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_INS )  // Inclusao LADV
        nReg:=LADV->(RECNO())
        SET KEY -1 TO Mostra()
        Telas(6,3,20,76,1,YCOREDIT,.T.,"Inclusฦo de LADV")
        LADV->(DBGOBOTTOM()); LADV->(DBSKIP())
        FOR a = 1 TO LADV->(FCOUNT())
           xVar  := "w"+LADV->(FIELDNAME(a))
           &xVar := LADV->(FIELDGET(a))
        NEXT
        wSit:="1"

        EditaGet()
        SETCURSOR(1); READ; SETCURSOR(0)
        IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
           WHILE !LADV->(NetApp()); ENDDO
           wSit:=IF(wSit=="1","1ฆ Via",IF(wSit=="2","2ฆ Via","Troca "))
           REPLACE LADV->MATRIC    WITH ALUNO->MATRIC ,;
                   LADV->NUM       WITH wNum          ,;
                   LADV->CODINST   WITH wCodInst      ,;
                   LADV->LIVRO     WITH wLivro        ,;
                   LADV->PAGINA    WITH wPagina       ,;
                   LADV->EMISSAO   WITH wEmissao      ,;
                   LADV->ENTREGA   WITH wEntrega      ,;
                   LADV->SIT       WITH wSit          ,;
                   LADV->OBS       WITH wObs          ,;
                   LADV->USER      WITH cUsuario
           LADV->(DBUNLOCK()); LADV->(DBCOMMIT())
           ProcOk("Incluido",.T.)
           oBr1:refreshall()
        ELSE
           LADV->(DBGOTO(nReg))
        ENDIF
        Rest_Tela(); SETKEY(K_F2,NIL)
        DBGOTOP()
     ELSEIF ( tecla == K_ENTER )
        SET KEY -1 TO Mostra()
        IF Acesso(3)
           IF EOF()
              Aviso("Nฦo h  registro a ser Alterado !",,2)
              LOOP
           ENDIF

           SET KEY -1 TO Mostra()
           Mensagem("Altere os campos necess rios")
           SETCOLOR(YCOREDIT)
           Telas(6,3,20,76,1,YCOREDIT,.T.,"Dados do LADV")

           FOR a = 1 TO LADV->(FCOUNT())
               xVar  := "w"+LADV->(FIELDNAME(a))
               &xVar := LADV->(FIELDGET(a))
           NEXT
           wSit:=IF(wSit=="1ฆ Via","1",IF(wSit=="2ฆ Via","2","3"))

           EditaGet()
           SETCURSOR(1); READ; SETCURSOR(0)

           IF LASTKEY()#K_ESC.AND.UPDATED()
              IF Confirma("Confirma Alteraฦo ?")
                 wSit:=IF(wSit=="1","1ฆ Via",IF(wSit=="2","2ฆ Via","Troca "))
                 WHILE !LADV->(NetLReg()); ENDDO
                 REPLACE LADV->CODINST   WITH wCodInst  ,;
                         LADV->LIVRO     WITH wLivro    ,;
                         LADV->PAGINA    WITH wPagina   ,;
                         LADV->EMISSAO   WITH wEmissao  ,;
                         LADV->ENTREGA   WITH wEntrega  ,;
                         LADV->SIT       WITH wSit      ,;
                         LADV->OBS       WITH wObs      ,;
                         LADV->USER      WITH cUsuario
                 LADV->(DBUNLOCK()); LADV->(DBCOMMIT())

                 ProcOk("Alterado",.T.)
                 oBr1:refreshall()
              ENDIF
           ENDIF
           Rest_Tela()
        ENDIF
        SETKEY(K_F2,NIL)
     ELSEIF ( tecla == K_DEL )
        IF Acesso(3)
           IF EOF()
              Aviso("Nฦo h  registro a ser Excluido !",,2)
              LOOP
           ENDIF

           IF Confirma("Confirma Exclusฦo ?")
              WHILE !LADV->(NetLReg()); ENDDO
              LADV->(DBDELETE()); LADV->(DBUNLOCK()); LADV->(DBCOMMIT())

              ProcOk("Excluido",.T.)
              lAlt := .T.
           ENDIF
           oBr1:refreshall(); oBr1:up(); oBr1:down()
        ENDIF
     ELSE
        ProcKey(oBr1,tecla)
     ENDIF
  ENDDO
  RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet()
   @ 07,05 SAY "Dados do Documento LADV"
   @ 08,05 SAY "฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿"
   @ 09,05 SAY "Nง LADV...:" GET wNum        VALID !EMPTY(wNum)
   @ 10,05 SAY "Emissฦo...:" GET wEmissao    PICT "@D"
   @ 11,05 SAY "Instrutor.:" GET wCodInst    PICT "9999" WHEN TeclaFuncao(.T.);
     VALID LASTKEY()==K_UP.OR.EMPTY(wCodInst).OR.TDescr(2,1,11,23,wCodInst,"NOME",,"Instrutor Nฦo Localizado")
   @ 12,05 SAY "Livro.....:" GET wLivro
   @ 13,05 SAY "P gina....:" GET wPagina
   @ 14,05 SAY "Entrega...:" GET wEntrega    PICT "@D"
   @ 15,05 SAY "Situaฦo..:" GET wSit        PICT "!"  WHEN HTela(12) VALID VTela(12)
   @ 16,05 SAY "Observaฦo:" GET wObs        PICT "@!"
   RETURN
