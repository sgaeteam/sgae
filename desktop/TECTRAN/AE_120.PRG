*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_120                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Instrutores                    ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 03/02/2001                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 20
IF !NetUse("DBPARM")                  /* Parametros */
   RETURN
ENDIF

SELECT 14
IF NetUse("DBVEIC","VEICULO")         /* Veกculos */
   SET INDEX TO DBIVEI2,DBIVEI1,DBIVEI3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBPROG","AULAS")           /* Progr Aulas Praticas */
   SET INDEX TO DBIPRO3,DBIPRO2,DBIPRO1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST2,DBINST1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "20"
cPrg:="AE120"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Inativar ^F10^-Reativar"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,17,75,1,YCOREDIT,.T.,"Cadastro de Instrutores")
Telas(17,5,19,75,1,YCOREDIT,.T.,"Pesquisa")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,16,74)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Matr."        ,{|| CODINST})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Status"       ,{|| IF(STATUS="A","Ativo  ",IF(STATUS="I","Inativo",SPACE(7)))})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Nome"         ,{|| TRANSFORM(NOME,"@S30")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Tipo"         ,{|| PegaCategInst(CATEG)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fone"         ,{|| FONE_R})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Celular"      ,{|| TRANSFORM(CELULAR,"@R 9999-9999")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("H/A Prog.(P)" ,{|| CHP})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("H/A Prog.(T)" ,{|| CHT})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ult.Data (P)" ,{|| ULTDTP})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ult.Data (T)" ,{|| ULTDTT})
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
   ELSEIF ( tecla == K_F10 )
      IF !EMPTY(INSTRUTOR->CODINST).AND.INSTRUTOR->STATUS#"A"
         IF Acesso(9).AND.Confirma("Deseja REATIVAR instrutor ?")
            Aguarde("Reativando...")
            WHILE !INSTRUTOR->(NetLReg()); ENDDO
            REPLACE INSTRUTOR->STATUS WITH "A"
            INSTRUTOR->(DBUNLOCK()); INSTRUTOR->(DBCOMMIT())
            Aguarde(); oBr:refreshAll()
         ENDIF
      ELSEIF INSTRUTOR->STATUS=="A"
         Aviso("Instrutor j  est  ATIVO !",,3)
      ELSE
         Aviso("Nฦo h  registro para REATIVAR !",,3)
      ENDIF
   ELSEIF ( tecla == K_INS )
      IF Acesso(5); Inclui(msg); oBr:refreshAll(); ENDIF
   ELSEIF ( tecla == K_DEL )
      IF Acesso(9)
         IF INSTRUTOR->STATUS=="A"
            Aviso("Esta operaฦo desvincula os alunos deste Instrutor")
            Exclui(msg); oBr:refreshAll(); oBr:up(); oBr:down()
         ELSE
            Aviso("Instrutor j  se encontra INATIVO !",,3)
         ENDIF
      ENDIF
   ELSEIF ( tecla == K_F2 )   // Consulta dados
      IF Acesso(1); Altera(msg,.F.); oBr:refreshAll(); ENDIF
   ELSEIF ( tecla == K_ENTER )
      IF Acesso(5); Altera(msg,.T.); oBr:refreshAll(); ENDIF
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),18,6,60)
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela(2)
RESTSCREEN(2,0,24,79,vTela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := INSTRUTOR->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(4,5,19,75,1,YCOREDIT,.T.,"Inclusฦo de Instrutor")
   wCodInst:= STRZERO(VAL(DBPARM->CODINST)+1,4)
   xCodInst := wCodInst
   WHILE .T.
      INSTRUTOR->(DBGOBOTTOM()); INSTRUTOR->(DBSKIP())
      FOR a = 1 TO INSTRUTOR->(FCOUNT())
          xVar  := "w"+INSTRUTOR->(FIELDNAME(a))
          &xVar := INSTRUTOR->(FIELDGET(a))
      NEXT
      wCidade  := "SALVADOR"+SPACE(22)
      wUF      := "BA"
      wCodInst := xCodInst

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         /* Gravar no arquivo de parametros */
         DBPARM->(DBGOTOP())
         IF DBPARM->(EOF()); DBPARM->(NetApp()); ENDIF
         WHILE !DBPARM->(NetLReg()); ENDDO
         wCodInst := STRZERO(VAL(DBPARM->CODINST)+1,4)
         REPLACE DBPARM->CODINST WITH wCodInst
         DBPARM->(DBUNLOCK())

         // Gravar no arquivo de Instrutores
         wStatus:="A"
         WHILE !INSTRUTOR->(NetApp()); ENDDO
         FOR a = 1 TO INSTRUTOR->(FCOUNT())
             xVar  := "w"+INSTRUTOR->(FIELDNAME(a))
             INSTRUTOR->(FIELDPUT(a,&xVar))
         NEXT
         INSTRUTOR->(DBUNLOCK()); INSTRUTOR->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outro Instrutor ?"); EXIT; ENDIF
         SCROLL(5,6,18,74,0)
         xCodInst := wCodInst
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Altera(msg,pLibera)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(4,5,19,75,1,YCOREDIT,.T.,IF(pLibera,"Alteraฦo","Consulta")+" Dados do Instrutor")

   wCodInst := INSTRUTOR->CODINST
   FOR a = 1 TO INSTRUTOR->(FCOUNT())
       xVar  := "w"+INSTRUTOR->(FIELDNAME(a))
       &xVar := INSTRUTOR->(FIELDGET(a))
   NEXT

   EditaGet("A")
   SETCURSOR(1)
   IF pLibera
      READ; SETCURSOR(0)
   ELSE
      Mensagem("Tecle algo para retornar...")
      SETCURSOR(0)
      GetList:={}
      INKEY(0); CHR(27)
   ENDIF

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !INSTRUTOR->(NetLReg()); ENDDO
         FOR a = 1 TO INSTRUTOR->(FCOUNT())
             xVar  := "w"+INSTRUTOR->(FIELDNAME(a))
             INSTRUTOR->(FIELDPUT(a,&xVar))
         NEXT
         INSTRUTOR->(DBUNLOCK()); INSTRUTOR->(DBCOMMIT())

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ELSE
      IF LEN(Telas)==5; Rest_Tela(); ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := INSTRUTOR->(RECNO()), lExcl := .F.

   INSTRUTOR->(DBGOTOP())
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma DESLIGAMENTO do instrutor ?")
      SET KEY -1 TO Mostra()
      nReg := INSTRUTOR->(RECNO())
      Telas(4,5,19,75,1,YCOREDIT,.T.,"Desligamento de Instrutor com Transferncia de Alunos")
      wCodInst := INSTRUTOR->CODINST ; xCodInst := wCodInst; xCateg := INSTRUTOR->CATEG

      nQtde:=NrAluAssoc(wCodInst)   // Conta nr. alunos associados ao instrutor
      TDescr(1,2,6,37,xCodInst,"NOME",["@S30"])
      WHILE .T.
         @ 06,07 SAY "A) Instrutor Desligado.:" GET xCodInst PICT "@!"   WHEN .F.
         @ 07,07 SAY "B) Instrutor Substituto:" GET wCodInst PICT "9999" WHEN nQtde>0.AND.TeclaFuncao(.T.) ;
           VALID !EMPTY(wCodInst).AND.Pesquisa(1,2,wCodInst,"Instrutor nฦo Cadastrado!").AND.TDescr(1,2,7,37,wCodInst,"NOME",["@S30"])
         @ 09,07 SAY "Quantidade de Alunos:"
         @ 10,07 SAY "   A) Associados.......:" GET nQtde    PICT "@E 9,999" WHEN .F.
         @ 11,07 SAY "   B) Transferidos.....:"
         SETCURSOR(1); READ; SETCURSOR(0); TeclaFuncao()

         IF LASTKEY()#K_ESC
            IF nQtde=0
               IF Confirma("Confirma DESLIGAMENTO ?")
                  // Inativar veiculo associado ao instrutor
                  VEICULO->(DBSEEK(xCodInst))
                  WHILE VEICULO->CODINST==xCodInst.AND.!VEICULO->(EOF())
                     WHILE !VEICULO->(NetLReg()); ENDDO
                     REPLACE VEICULO->STATUS  WITH "I" ,;
                             VEICULO->CODINST WITH SPACE(4)
                     VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())
                     VEICULO->(DBSKIP())
                  ENDDO

                  // Mudar status do instrutor
                  INSTRUTOR->(DBGOTO(nReg))
                  WHILE !INSTRUTOR->(NetLReg()); ENDDO
                  REPLACE INSTRUTOR->STATUS WITH "I"
                  INSTRUTOR->(DBUNLOCK()); INSTRUTOR->(DBCOMMIT())
                  Aguarde()
                  AvisoS("Operaฦo realizada com Sucesso! Tecle algo...","N/G"); EXIT
               ELSE
                  Aviso("Operaฦo nฦo realizada - Instrutor Mantido!")
               ENDIF
            ELSE
               IF wCodInst#xCodInst
                  IF INSTRUTOR->STATUS=="A"
                     IF Confirma("Transfere Alunos para novo Instrutor ?")
                        Aguarde("Transferindo...")
                        // Transfere aulas a partir de hoje

*                       Fazer apos definicao dos registros de programacao pratica
*                       Registrar historico de migracao dos alunos

                        AULAS->(DBSEEK(wCodVeic+DTOS(DATE()),.T.))
                        WHILE AULAS->CODVEIC==wCodVeic.AND.!AULAS->(EOF())
                           WHILE !AULAS->(NetLReg()); ENDDO
                           REPLACE AULAS->CODINST WITH wCodInst
                           AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
                           AULAS->(DBSKIP())
                        ENDDO

                        // Inativar veiculo associado ao instrutor
                        VEICULO->(DBSEEK(xCodInst))
                        WHILE VEICULO->CODINST==xCodInst.AND.!VEICULO->(EOF())
                           WHILE !VEICULO->(NetLReg()); ENDDO
                           REPLACE VEICULO->STATUS  WITH "I" ,;
                                   VEICULO->CODINST WITH SPACE(4)
                           VEICULO->(DBUNLOCK()); VEICULO->(DBCOMMIT())
                           VEICULO->(DBSKIP())
                        ENDDO

                        // Mudar status do instrutor
                        INSTRUTOR->(DBGOTO(nReg))
                        WHILE !INSTRUTOR->(NetLReg()); ENDDO
                        REPLACE INSTRUTOR->STATUS WITH "I"
                        INSTRUTOR->(DBUNLOCK()); INSTRUTOR->(DBCOMMIT())
                        Aguarde()
                        AvisoS("Operaฦo realizada com Sucesso! Tecle algo...","N/G"); EXIT
                     ELSE
                        Aviso("Operaฦo nฦo realizada - Instrutor Mantido!")
                     ENDIF
                  ELSE
                     Aviso("Operaฦo nฦo realizada - Instrutor INATIVO!"); EXIT
                  ENDIF
               ELSE
                  Aviso("Operaฦo nฦo realizada - Instrutor Mantido!"); EXIT
               ENDIF
            ENDIF
         ELSE
            EXIT
         ENDIF
      ENDDO
      INSTRUTOR->(DBSETORDER(1))
      Linha23(msg); Rest_Tela(); SETKEY(K_F2,NIL)
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet(pOp)
   IF pOp=="A"; TipoInst(wCateg); ENDIF
   @ 05,07 SAY "Instrutor:"      GET wNome     PICT "@!" VALID !EMPTY(wNome).AND.TProf(wNome,pOp)
   @ 06,07 SAY "Endereo.:"      GET wEndereco PICT "@!"
   @ 07,07 SAY "Bairro...:"      GET wBairro   PICT "@!"
   @ 07,39 SAY "Cidade:"         GET wCidade   PICT "@!S25"
   @ 08,07 SAY "Estado...:"      GET wUF       PICT "!!"
   @ 08,39 SAY "CEP...:"         GET wCEP      PICT "@R 99999-999"
   @ 09,07 SAY "Fone Res.:"      GET wFone_r
   @ 09,39 SAY "Tipo..:"         GET wCateg    PICT "X" WHEN HTela(8) VALID VTela(8).AND.Let(TipoInst(wCateg))
   @ 10,07 SAY "Celular..:"      GET wCelular  PICT "@R 9999-9999"
   @ 11,05 SAY "ร"+REPL("ฤ",69)+"ด"
   @ 12,07 SAY "Documentos Pessoais"
   @ 13,07 SAY "฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿"
   @ 14,07 SAY "C.N.H. nง:"      GET wCNH      PICT "99999999999"       WHEN wCateg=="1".OR.wCateg=="3" VALID LASTKEY()==K_UP.OR.!EMPTY(wCNH)
   @ 15,07 SAY "CPF......:"      GET wCPF      PICT "@R 999.999.999-99" VALID (LASTKEY()==K_UP).OR.ChkCPF(wCPF)
   @ 16,07 SAY "RG.......:"      GET wRG       PICT "@!"
   @ 16,39 SAY "Orgao.:"         GET wOrgao    PICT "@!"
   @ 17,07 SAY "CTPS.....:"      GET wCTPS     PICT "@!"
   @ 17,39 SAY "Srie.:"         GET wSerie    PICT "@!"
   @ 18,07 SAY "Admissao.:"      GET wDtAdm    PICT "@D" //VALID LASTKEY()==K_UP.OR.!EMPTY(wDtAdm).AND.wDtAdm<=cDtSys
   RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Nome j  Cadastrado    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TProf(pNome,pOp)
  LOCAL nReg:=INSTRUTOR->(RECNO()); lRet:=.F.
  IF (lRet:=INSTRUTOR->(DBSEEK(pNome)))
     Aviso("Instrutor j  Cadastrado!")
     IF pOp=="A"
        IF Confirma("Deseja Alterar os Dados ?")
           lRet:=.F.
        ENDIF
     ENDIF
  ENDIF
  RETURN(!lRet)
*ีออออออออออออออออออออออออออออออออธ
*ณ Mostrar tipo do instrutor      ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC PROCEDURE TipoInst(pVar)
   @ 09,49 SAY "                 "    COLOR YCOREDIT
   IF pVar=="1"
      @ 09,49 SAY "Pr tico"           COLOR YCOREDIT
   ELSEIF pVar=="2"
      @ 09,49 SAY "Teขrico"           COLOR YCOREDIT
   ELSEIF pVar=="3"
      @ 09,49 SAY "Pr tico e Teขrico" COLOR YCOREDIT
   ENDIF
   RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Contar nr alunos associados    ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION NrAluAssoc(pVar)
  LOCAL nQtde:=0,fMat
  AULAS->(DBSETORDER(2))
  SET SOFTSEEK ON
  IF AULAS->(DBSEEK(pVar+DTOS(DATE()),.T.))
     fMat := AULAS->MATRIC
     nQtde++
     WHILE AULAS->CODINST==pVar.AND.!AULAS->(EOF())
        IF AULAS->MATRIC # fMat    // Mudou de aluno - matricula
           fMat := AULAS->MATRIC
           nQtde++
        ENDIF
        AULAS->(DBSKIP())
     ENDDO
  ENDIF
  SET SOFTSEEK OFF
  AULAS->(DBSETORDER(1))
  RETURN(nQtde)
