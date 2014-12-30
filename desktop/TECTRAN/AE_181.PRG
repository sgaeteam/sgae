*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_181                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Fornecedores                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 03/02/2001                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 20
IF !NetUse("DBPARM")                   /* Parametros */
   RETURN
ENDIF

SELECT 1
IF NetUse("DBFORN","FORNECEDOR")       /* Fornecedores */
   SET INDEX TO DBIFOR2,DBIFOR1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "83"
cPrg:="AE181"; LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,17,75,1,YCOREDIT,.T.,"Cadastro de Fornecedores")
Telas(17,5,19,75,1,YCOREDIT,.T.,"Pesquisa")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,16,74)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("CNPJ/CPF"     ,{|| IF(EMPTY(FORNECEDOR->CNPJ),TRANSFORM(FORNECEDOR->CPF,"@R 999.999.999-99"),TRANSFORM(FORNECEDOR->CNPJ,"@R 99.999.999/9999-99"))})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Razฦo Social" ,{|| TRANSFORM(NOME,"@S45")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Contato"      ,{|| TRANSFORM(CONTATO,"@S20")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fone 1"       ,{|| FONE1})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fone 2"       ,{|| FONE2})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fax"          ,{|| FAX1})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Pagamento"    ,{|| TRANSFORM(CONTATO2,"@S20")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("CNPJ/CPF"     ,{|| IF(EMPTY(CNPJ2),TRANSFORM(CPF,"@R 999.999.999-99"),TRANSFORM(CNPJ2,"@R 99.999.999/9999-99"))})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fone 1"       ,{|| FONE3})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fone 2"       ,{|| FONE4})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Fax"          ,{|| FAX2})
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
      IF Acesso(9)
*        Aviso("Esta operaฦo elimina todos os lanamentos do fornecedor!")
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
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Incluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := FORNECEDOR->(RECNO())

   SET KEY -1 TO Mostra()
   Mensagem("Informe os campos necess rios")

   Telas(4,5,19,75,1,YCOREDIT,.T.,"Inclusฦo de Fornecedores")
   wCodFor := STRZERO(VAL(DBPARM->CODFOR)+1,4)
   xCodFor := wCodFor
   WHILE .T.
      FORNECEDOR->(DBGOBOTTOM()); FORNECEDOR->(DBSKIP())
      FOR a = 1 TO FORNECEDOR->(FCOUNT())
          xVar  := "w"+FORNECEDOR->(FIELDNAME(a))
          &xVar := FORNECEDOR->(FIELDGET(a))
      NEXT
      wCodFor := xCodFor

      EditaGet("I")
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         /* Gravar no arquivo de parametros */
         DBPARM->(DBGOTOP())
         IF DBPARM->(EOF()); DBPARM->(NetApp()); ENDIF
         WHILE !DBPARM->(NetLReg()); ENDDO
         wCodFor := STRZERO(VAL(DBPARM->CODFOR)+1,4)
         REPLACE DBPARM->CODFOR WITH wCodFor
         DBPARM->(DBUNLOCK())

         // Gravar no arquivo de FORNECEDORs
         WHILE !FORNECEDOR->(NetApp()); ENDDO
         FOR a = 1 TO FORNECEDOR->(FCOUNT())
             xVar  := "w"+FORNECEDOR->(FIELDNAME(a))
             FORNECEDOR->(FIELDPUT(a,&xVar))
         NEXT
         FORNECEDOR->(DBUNLOCK()); FORNECEDOR->(DBCOMMIT())

         ProcOk("Incluido",.T.)
         IF !Confirma("Deseja Cadastrar outro Fornecedor ?"); EXIT; ENDIF
         SCROLL(5,6,18,74,0)
         xCodFor := wCodFor
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela(); Linha23(msg); SETKEY(K_F2,NIL)
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

   SET KEY -1 TO Mostra()
   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(4,5,19,75,1,YCOREDIT,.T.,"Alteraฦo Dados do Fornecedor")

   wCodFor := FORNECEDOR->CODFOR
   FOR a = 1 TO FORNECEDOR->(FCOUNT())
       xVar  := "w"+FORNECEDOR->(FIELDNAME(a))
       &xVar := FORNECEDOR->(FIELDGET(a))
   NEXT

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !FORNECEDOR->(NetLReg()); ENDDO
         FOR a = 1 TO FORNECEDOR->(FCOUNT())
             xVar  := "w"+FORNECEDOR->(FIELDNAME(a))
             FORNECEDOR->(FIELDPUT(a,&xVar))
         NEXT
         FORNECEDOR->(DBUNLOCK()); FORNECEDOR->(DBCOMMIT())

         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := FORNECEDOR->(RECNO()), lExcl := .F.

   FORNECEDOR->(DBGOTOP())
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma Exclusฦo do Fornecedor ?")
      Aguarde("Eliminando...")

      WHILE !FORNECEDOR->(NetLReg()); ENDDO
      FORNECEDOR->(DBDELETE()); FORNECEDOR->(DBUNLOCK()); FORNECEDOR->(DBCOMMIT())
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet(pOp)
   @ 05,07 SAY "Nome.....:"      GET wNome      PICT "@!" VALID !EMPTY(wNome)
   @ 06,07 SAY "Endereo.:"      GET wEndereco  PICT "@!"
   @ 07,07 SAY "Bairro...:"      GET wBairro    PICT "@!"
   @ 07,39 SAY "Cidade:"         GET wCidade    PICT "@!"
   @ 08,07 SAY "Estado...:"      GET wUF        PICT "!!"
   @ 08,39 SAY "CEP...:"         GET wCEP       PICT "@R 99999-999"
   @ 09,07 SAY "CNPJ/MF..:"      GET wCNPJ      PICT "@R 99.999.999/9999-99" VALID EMPTY(wCNPJ).OR.ChkCGC(wCNPJ)
   @ 09,39 SAY "CPF/MF:"         GET wCPF       PICT "@R 999.999.999-99"     WHEN EMPTY(wCNPJ) VALID (LASTKEY()==K_UP).OR.ChkCPF(wCPF)
   @ 10,07 SAY "Fone (1).:"      GET wFone1
   @ 10,32 SAY "(2):"            GET wFone2
   @ 10,51 SAY "Fax....:"        GET wFax1
   @ 11,07 SAY "Contato..:"      GET wContato
   @ 11,51 SAY "Celular:"        GET wCelular1
   @ 12,05 SAY "ร"+REPL("ฤ",69)+"ด"
   @ 13,07 SAY "Pagamento:"      GET wPagamento PICT "@!"
   @ 14,07 SAY "Bairro...:"      GET wBairro2   PICT "@!"
   @ 14,39 SAY "Cidade:"         GET wCidade2   PICT "@!"
   @ 15,07 SAY "Estado...:"      GET wUF2       PICT "!!"
   @ 15,39 SAY "CEP...:"         GET wCEP2      PICT "@R 99999-999"
   @ 16,07 SAY "CNPJ/MF..:"      GET wCNPJ2     PICT "@R 99.999.999/9999-99" VALID EMPTY(wCNPJ2).OR.ChkCGC(wCNPJ2)
   @ 17,07 SAY "Fone (1).:"      GET wFone3
   @ 17,32 SAY "(2):"            GET wFone4
   @ 17,51 SAY "Fax....:"        GET wFax2
   @ 18,07 SAY "Contato..:"      GET wContato2
   @ 18,51 SAY "Celular:"        GET wCelular2
   RETURN
