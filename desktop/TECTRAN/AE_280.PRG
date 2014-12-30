*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_280                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Lan‡amento de Consumos de Ve¡culos       ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 17/12/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 1
IF NetUse("DBLCON")                /* Arq.Lan‡amento de Consumos */
   SET INDEX TO DBILCON1,DBILCON2,DBILCON3
ELSE
   RETURN
ENDIF

SELECT 2
IF NetUse("DBRCON","RESUMO")      /* Arq.Resumo de Consumos */
   SET INDEX TO DBIRCON1,DBIRCON2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBTCON","TABCON")       /* Tabela de Consumos */
   SET INDEX TO DBICON1,DBICON2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")      /* Cadastro de Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
SET FILTER TO STATUS="A"
VEICULO->(DBGOTOP())

SELECT DBLCON

cOpHelp1 := "2"; cOpHelp2 := "80"
cPrg:="AE280";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,05,15,74,1,YCOREDIT,.T.,"Lan‡amento de Consumos")
Linha23(msg)
oBr:=TBROWSEDB(5,6,14,73)
oBr:headSep:="ÄÂÄ"
oBr:colSep:= " ³ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Data",{|| DATACON})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Ve¡c.",{|| CODVEIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Descri‡Æo",{|| DESCR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR,"@E 999,999.99")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Consumo",{|| TRANSFORM(TConsumo(CODCON),"@S15")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Favorecido",{|| FAVOR})
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
SET FILTER TO
RETURN NIL
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Incluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Inclui(msg)
   LOCAL nReg_Ant := RECNO()
   SET KEY -1 TO Mostra()
   Telas(11,1,18,78,c_nBorda,YCOREDIT,.T.," InclusÆo ")
   @ 12,3 SAY "        Ve¡culo:"
   @ 13,3 SAY "Data do Consumo:"
   @ 14,3 SAY "Tipo do Consumo:"
   @ 15,3 SAY "     Favorecido:"
   @ 16,3 SAY "      Descri‡Æo:"
   @ 17,3 SAY "          Valor:"
   wVei:=vCodCon:=SPACE(3);vDescr:=vFavor:=SPACE(30);vValor:=0.00;vDataCon:=CTOD("")
   @ 12,20 GET wVei     PICT "999" VALID !EMPTY(wVei).AND.;
     Pesquisa(4,1,wVei,"Ve¡culo NÆo Cadastrado").AND.TDescr(4,1,12,24,wVei,"MARCA",,"Ve¡culo NÆo Cadastrado")
   @ 13,20 GET vDataCon PICT "@D" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDataCon)
   @ 14,20 GET vCodCon  PICT "99" VALID (LASTKEY()==K_UP).OR.!EMPTY(vCodCon).AND.TDescr(3,1,14,23,vCodCon,"DESCR",,"C¢digo NÆo Cadastrado").AND.TLanca(wVei+DTOS(vDataCon)+vCodCon)
   @ 15,20 GET vFavor   PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vFavor)
   @ 16,20 GET vDescr   PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,20 GET vValor   PICT "@E 999,999.99" VALID (LASTKEY()==K_UP).OR.!EMPTY(vValor)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      GO nReg_Ant
      Rest_Tela(); Linha23(msg)
      RETURN(.T.)
   ENDIF

   IF LASTKEY()#K_ESC.AND.Confirma("Confirma InclusÆo ?")
      WHILE !NetApp(); ENDDO
      DBLCON->CODVEIC := wVei
      DBLCON->FAVOR   := vFavor
      DBLCON->VALOR   := vValor
      DBLCON->DATACON := vDataCon
      DBLCON->CODCON  := vCodCon
      DBLCON->DESCR   := vDescr
      DBLCON->(DBUNLOCK()); DBLCON->(DBCOMMIT())

      /* Lan‡ar no Resumo */
      IF !RESUMO->(DBSEEK(wVei+vCodCon+SUBS(DTOC(vDataCon),4,2)+SUBS(DTOC(vDataCon),7,2)))
         WHILE !RESUMO->(NetApp()); ENDDO
         REPLACE RESUMO->CODVEIC WITH wVei,;
                 RESUMO->MESANO  WITH SUBS(DTOC(vDataCon),4,2)+SUBS(DTOC(vDataCon),7,4),;
                 RESUMO->CODCON  WITH vCodCon,;
                 RESUMO->VALOR   WITH vValor
      ELSE
         WHILE !RESUMO->(NetLReg()); ENDDO
         REPLACE RESUMO->VALOR WITH RESUMO->VALOR + vValor
      ENDIF
      RESUMO->(DBUNLOCK()); RESUMO->(DBCOMMIT())
      ProcOk("Incluido",.T.)
   ELSE
      GO nReg_Ant
   ENDIF
   Rest_Tela(); Linha23(msg)
*   SETKEY(K_F2,NIL)
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

   SETCOLOR(YCOREDIT)
   Telas(11,1,18,78,1,YCOREDIT,.T.," Altera‡Æo ")
   @ 12,3 SAY "        Ve¡culo:"
   @ 13,3 SAY "Data do Consumo:"
   @ 14,3 SAY "Tipo do Consumo:"
   @ 15,3 SAY "     Favorecido:"
   @ 16,3 SAY "      Descri‡Æo:"
   @ 17,3 SAY "          Valor:"
   wVei     := wVeiAnt:= DBLCON->CODVEIC
   vDataCon := vDatConAnt := DBLCON->DATACON
   vCodCon  := vCodConAnt := DBLCON->CODCON
   vValor   := vValorAnt := DBLCON->VALOR
   vFavor   := DBLCON->FAVOR
   vDescr   := DBLCON->DESCR
   TDescr(4,1,12,23,wVei,"MARCA")
   TDescr(3,1,14,23,vCodCon,"DESCR")
   @ 12,20 GET wVei     PICT "99" VALID !EMPTY(wVei).AND.TDescr(4,1,12,23,wVei,"MARCA",,"Ve¡culo NÆo Cadastrado")
   @ 13,20 GET vDataCon PICT "@D" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDataCon)
   @ 14,20 GET vCodCon  PICT "99" VALID (LASTKEY()==K_UP).OR.!EMPTY(vCodCon).AND.TDescr(3,1,14,23,vCodCon,"DESCR",,"C¢digo NÆo Cadastrado")
   @ 15,20 GET vFavor   PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vFavor)
   @ 16,20 GET vDescr   PICT "@!" VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 17,20 GET vValor   PICT "@E 999,999.99" VALID (LASTKEY()==K_UP).OR.!EMPTY(vValor)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Altera‡Æo ?")
         GO nReg_Ant
         /* Alterar Dados dos Lan‡amentos */
         WHILE !DBLCON->(NetLReg()); ENDDO
         REPLACE DBLCON->DESCR   WITH vDescr,;
                 DBLCON->FAVOR   WITH vFavor,;
                 DBLCON->CODCON  WITH vCodCon,;
                 DBLCON->DATACON WITH vDataCon,;
                 DBLCON->CODCON  WITH vCodCon,;
                 DBLCON->VALOR   WITH vValor,;
                 DBLCON->CODVEIC WITH wVei
         DBLCON->(DBUNLOCK()); DBLCON->(DBCOMMIT())

         /* Eliminar dados anteriores do Resumo */
         IF RESUMO->(DBSEEK(wVeiAnt+vCodConAnt+SUBS(DTOC(vDatConAnt),4,2)+SUBS(DTOC(vDatConAnt),7,2)))
            WHILE !RESUMO->(NetLReg()); ENDDO
            IF (wVei#wVeiAnt).OR.(vCodCon#vCodConAnt)
               REPLACE RESUMO->VALOR WITH RESUMO->VALOR - vValorAnt
            ELSE
               REPLACE RESUMO->VALOR WITH RESUMO->VALOR + (vValor - vValorAnt)
            ENDIF
            IF RESUMO->VALOR==0.00
               RESUMO->(DBDELETE())
            ENDIF
            RESUMO->(DBUNLOCK()); RESUMO->(DBCOMMIT())
         ENDIF

         /* Atualizar novo dado no Resumo */
         IF !RESUMO->(DBSEEK(wVei+vCodCon+SUBS(DTOC(vDataCon),4,2)+SUBS(DTOC(vDataCon),7,2)))
            WHILE !RESUMO->(NetApp()); ENDDO
            REPLACE RESUMO->CODVEIC WITH wVei,;
                    RESUMO->MESANO  WITH SUBS(DTOC(vDataCon),4,2)+SUBS(DTOC(vDataCon),7,4),;
                    RESUMO->CODCON  WITH vCodCon,;
                    RESUMO->VALOR   WITH vValor
         ELSE
            IF (wVei#wVeiAnt).OR.(vCodCon#vCodConAnt)
               WHILE !RESUMO->(NetLReg()); ENDDO
               REPLACE RESUMO->VALOR WITH RESUMO->VALOR + vValor
               RESUMO->(DBUNLOCK()); RESUMO->(DBCOMMIT())
            ENDIF
         ENDIF
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg)
   RETURN(lAlt)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Excluir Dados no Browse      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION Exclui(msg)
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("NÆo h  registro a ser Eliminado !",,2)
      Linha23(msg)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   IF Confirma("Confirma ExclusÆo ?")
      Aguarde("Eliminando...")

      /* Eliminar a movimenta‡Æo */
      WHILE !DBLCON->(NetLReg()); ENDDO
      DBLCON->(DBDELETE()); DBLCON->(DBUNLOCK()); DBLCON->(DBCOMMIT())

      /* Eliminar do resumo */
      IF RESUMO->(DBSEEK(DBLCON->CODVEIC+DBLCON->CODCON+DBLCON->(SUBS(DTOC(DATACON),4,2))+DBLCON->(SUBS(DTOC(DATACON),7,2))))
         WHILE !RESUMO->(NetLReg()); ENDDO
         REPLACE RESUMO->VALOR WITH RESUMO->VALOR - DBLCON->VALOR
         IF RESUMO->VALOR==0.00
            RESUMO->(DBDELETE())
         ENDIF
         RESUMO->(DBUNLOCK()); RESUMO->(DBCOMMIT())
      ENDIF
      Aguarde(); Linha23(msg)
   ENDIF
   RETURN(.T.)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Testar Existencia do Lan‡amento ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION TLanca(pConta)
   IF (lRet:=DBSEEK(pConta))
      Aviso("Lan‡amento j  Efetuado...",,3)
   ENDIF
   RETURN(!lRet)
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Display da Descri‡Æo do Consumo ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
STATIC FUNCTION TConsumo(pCod)
   TABCON->(DBSEEK(pCod))
   RETURN(TABCON->DESCR)
