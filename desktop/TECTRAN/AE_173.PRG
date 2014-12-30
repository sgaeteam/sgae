*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_173                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Contas de Movimento de Caixa   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 17/08/1999                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela
SELECT 5
IF NetUse("DBCX","CAIXA")            /* Caixa */
   SET INDEX TO DBICX4,DBICX2,DBICX3,DBICX1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBSD","SALDOS")           /* Saldos */
   SET INDEX TO DBISD1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPLANO","PLANO")         /* Plano de Contas */
   SET INDEX TO DBIPLAN1,DBIPLAN2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE173"; ProgName(cPrg)

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,3,20,76,1,YCOREDIT,.T.,"Cadastro do Plano de Contas")
Linha23("^INS^-Inclui  ^ENTER^-Altera  ^DEL^-Exclui ^F9^-Imprime")
oBr:=TBROWSEDB(5,4,19,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Conta"    ,{|| TRANSFORM(CONTA,"@R 9.9.9.9.999")})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("CL"       ,{|| CLASS})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("C/D"      ,{|| OPER})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("TP"       ,{|| TIPO})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Descriฦo",{|| DESCR})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Taxa %"   ,{|| TRANSFORM(TAXA,"@R 99.99")})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F4 )   // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )   // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_INS )
      Inclui(); oBr:refreshAll()
   ELSEIF ( tecla == K_F9 )
      IF !EOF()
         IF ChkImpr()
            cAviso := MsgImp()
            ImpPlano()
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         Aviso("Nฦo h  contas para impressฦo!",,3)
      ENDIF
   ELSEIF ( tecla == K_DEL )
      IF Exclui()
         oBr:refreshAll()
         oBr:down()
         oBr:up()
      ELSE
         Aviso("Registro Mantido!!",,3)
      ENDIF
   ELSEIF ( tecla == K_ENTER )
      IF Altera()
         oBr:refreshAll()
      ENDIF
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
STATIC FUNCTION Inclui()
   LOCAL nReg_Ant := RECNO()
   Telas(14,1,17,78,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
   @ 15,03 SAY "Conta       Class C/D Tipo  Descriฦo                       Taxa"
*               9.9.9.9.999   x    x   x    XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 99.99
*               3456789012345678901234567890123456789012345678901234567890123456789
*                      1         2         3         4         5         6
   WHILE .T.
      vConta:=SPACE(5);vTipo:=vOper:=vClass:=" ";vDescr:=SPACE(30);vTaxa:=0.00
      @ 16,03 GET vConta   PICT "@R 9.9.9.9.999" VALID !EMPTY(vConta).AND.TConta(vConta)
      @ 16,17 GET vClass   PICT "!"              VALID (LASTKEY()==K_UP).OR.vClass $ "TA"
      @ 16,22 GET vOper    PICT "!"              VALID (LASTKEY()==K_UP).OR.vOper  $ "CD"
      @ 16,26 GET vTipo    PICT "!"              VALID (LASTKEY()==K_UP).OR.vTipo  $ "PATR"
      @ 16,31 GET vDescr   PICT "@!"             VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
      @ 16,62 GET vTaxa    PICT "@!" WHEN vTipo=="T" //VALID (LASTKEY()==K_UP).OR.!EMPTY(vTaxa)
      SETCURSOR(1); READ; SETCURSOR(0)

      /* Tipo:  P = Principal     Classe: T = Titulo
                A = Analitica             A = Analitica
                T = Titulo
                R = Resultado
      */

      TeclaFuncao()
      IF LASTKEY()==K_ESC
         GO nReg_Ant
         Rest_Tela()
         RETURN(.T.)
      ENDIF

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         /* Gravar no arquivo de saldos dos estabelecimentos */
         ESTAB->(DBGOTOP())
         WHILE !ESTAB->(EOF())
            IF !SALDOS->(DBSEEK(ESTAB->CODEST+vConta))
               WHILE !SALDOS->(NetApp()); ENDDO
               REPLACE SALDOS->CODEST   WITH ESTAB->CODEST,;
                       SALDOS->CONTA    WITH vConta
            ENDIF
            ESTAB->(DBSKIP())
         ENDDO

         /* Gravar no Arq. contas de movimento de caixa */
         WHILE !NetApp(); ENDDO
         PLANO->CONTA   := vConta
         PLANO->OPER    := vOper
         PLANO->TIPO    := vTipo
         PLANO->CLASS   := vClass
         PLANO->DESCR   := vDescr
         PLANO->TAXA    := vTaxa
         PLANO->(DBUNLOCK()); PLANO->(DBCOMMIT())

         ProcOk("Incluido",.T.)
      ELSE
         GO nReg_Ant; EXIT
      ENDIF
   ENDDO
   Rest_Tela()
   RETURN NIL
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Altera()
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Alterado !",,2)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   SETCOLOR(YCOREDIT)
   Telas(14,1,17,78,1,YCOREDIT,.T.," Alteraฦo ")
   @ 15,03 SAY "Conta       Class C/D Tipo  Descriฦo                       Taxa"
   vConta   := CONTA
   vOper    := OPER
   vTipo    := TIPO
   vClass   := CLASS
   vDescr   := DESCR
   vTaxa    := TAXA

   @ 16,03 GET vConta   PICT "@R 9.9.9.9.999" WHEN .F.
   @ 16,17 GET vClass   PICT "!"          VALID (LASTKEY()==K_UP).OR.vClass $ "TA"
   @ 16,22 GET vOper    PICT "!"          VALID (LASTKEY()==K_UP).OR.vOper $ "CD"
   @ 16,26 GET vTipo    PICT "!"          VALID (LASTKEY()==K_UP).OR.vTipo $ "PATR"
   @ 16,31 GET vDescr   PICT "@!"         VALID (LASTKEY()==K_UP).OR.!EMPTY(vDescr)
   @ 16,62 GET vTaxa    PICT "@!"         WHEN vTipo=="T" //VALID (LASTKEY()==K_UP).OR.!EMPTY(vTaxa)
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         GO nReg_Ant
         WHILE !PLANO->(NetLReg()); ENDDO
         REPLACE PLANO->CLASS   WITH vClass ,;
                 PLANO->OPER    WITH vOper  ,;
                 PLANO->TIPO    WITH vTipo  ,;
                 PLANO->DESCR   WITH vDescr ,;
                 PLANO->TAXA    WITH vTaxa
         PLANO->(DBUNLOCK()); PLANO->(DBCOMMIT())
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Excluir Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Exclui()
   LOCAL nReg_Ant := RECNO(), lExcl := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Eliminado !",,2)
      RETURN(lExcl)
   ENDIF
   GO nReg_Ant

   /* Verifica se houve movimento j  fechado */
   ESTAB->(DBGOTOP()); lConf:=.F.
   WHILE !ESTAB->(EOF())
      IF CAIXA->(DBSEEK(ESTAB->CODEST+PLANO->CONTA+"S"))
         Aviso("Movimento j  fechado. Conta nฦo pode ser eliminada!"); RETURN(.F.)
      ENDIF
      ESTAB->(DBSKIP())
   ENDDO

   Aviso("Esta operaฦo eliminar  todo o movimento de, cada estabelecimento, desta conta")

   IF Confirma("Confirma Exclusฦo da Conta?")
      Aguarde("Eliminando...")

      ESTAB->(DBGOTOP()); lConf:=.F.
      WHILE !ESTAB->(EOF())
         IF SALDOS->(DBSEEK(ESTAB->CODEST+PLANO->CONTA))
            /* Eliminar conta do arq de saldos dos estabelecimentos */
            WHILE !SALDOS->(NetLReg()); ENDDO
            SALDOS->(DBDELETE()); SALDOS->(DBUNLOCK()); SALDOS->(DBCOMMIT())

            /* Eliminar no movimento de caixa */
            IF CAIXA->(DBSEEK(ESTAB->CODEST+PLANO->CONTA))
               WHILE CAIXA->CODEST==ESTAB->CODEST.AND.CAIXA->CONTA==PLANO->CONTA.AND.!CAIXA->(EOF())
                  CAIXA->(DBDELETE()); CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
                  CAIXA->(DBSKIP())
               ENDDO
            ENDIF
         ENDIF
         ESTAB->(DBSKIP())
      ENDDO

      /* Eliminar conta movimento de caixa */
      WHILE !PLANO->(NetLReg()); ENDDO
      PLANO->(DBDELETE()); PLANO->(DBUNLOCK()); PLANO->(DBCOMMIT())

      Aguarde()
   ENDIF
   RETURN(.T.)
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da Conta   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TConta(pConta)
   IF (lRet:=DBSEEK(pConta))
      Aviso("Conta j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
*ีออออออออออออออออออออออออออออออธ
*ณ Relatorio do Plano de Contas ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE ImpPlano()
   LOCAL zConta:=SUBS(PLANO->CONTA,1,1)
   pg:=0
   Gera_TXT("PLANO.TXT"); SETPRC(0,0)
   CabRel("PLANO DE CONTAS")
   @ PROW()+1,02 SAY REPLICATE("ฤ",75)

   PLANO->(DBGOTOP())
   WHILE !PLANO->(EOF())
      IF PROW()>=57.AND.!PLANO->(EOF())
         Compr_Off()
         @ PROW()+1,02 SAY REPLICATE("ฤ",75)
         @ PROW()+1,02 SAY "Continua..."
         EJECT; CabRel("PLANO DE CONTAS")
         @ PROW()+1,02 SAY REPLICATE("ฤ",75)
      ENDIF
      Compr_On()
      IF SUBS(PLANO->CONTA,1,1) # zConta
         @ PROW()+1,05 SAY " "
         zConta:=SUBS(PLANO->CONTA,1,1)
      ENDIF
      @ PROW()+1,05 SAY PLANO->CONTA PICT "@R 9.9.9.9.999"
      IF LEN(ALLTRIM(PLANO->CONTA))==7
         nCol:=14+LEN(ALLTRIM(PLANO->CONTA))
      ELSE
         nCol:=13+LEN(ALLTRIM(PLANO->CONTA))
      ENDIF
      @ PROW(),nCol SAY PLANO->DESCR
      @ PROW(),57   SAY IF(PLANO->CLASS=="T","Titulo","Analitica")
      @ PROW(),70   SAY IF(PLANO->TIPO=="T","Tributaria",IF(PLANO->TIPO=="A","Adm.",IF(PLANO->TIPO=="R","Receita",IF(SUBS(PLANO->CONTA,1,1)=="1","Ativo","Passivo" ))))
      PLANO->(DBSKIP())
   ENDDO
   Compr_Off()
   @ PROW()+1,02 SAY REPLICATE("ฤ",75)
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp plano.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE PLANO.TXT
   RETURN
*       CONTA        DESCRICAO                                  TIPO         CLASSIFICACAO
*       9.9.9.9.999  XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX             Titulo       Administrativa
*       9.9.999      XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX            Analitica    Tributaria
*       9.9.999      XXXXXXXXXXxxxxxxxxxxXXXXXXXXXX                      Receita
*       567890123456789012345678901234567890123456789012345678901234567890123456789
*            1         2         3         4         5         6         7
