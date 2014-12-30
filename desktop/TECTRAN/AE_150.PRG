*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_150                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Cadastrar Tabela de Infraไes            ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - NETCOM            ณ
*ณ DATA CRIACAO   : 06/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol
LOCAL tela := SAVESCREEN(2,0,24,79)

DBCLOSEALL()
SELECT 1
IF NetUse("DBFALT","FALTAS")         /* Infraไes Veiculares */
   SET INDEX TO DBIFAL1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE150";ProgName(cPrg)
SETCOLOR(YCOREDIT); Area_Dados()
Linha23("^ESC^-Retorna  ^INS^-Inclui  ^DEL^-Exclui")
Telas(4,2,21,76,1,YCOREDIT,.T.,"Infraไes Veiculares")

oBr:=TBROWSEDB(5,3,20,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "

oCol:=TBCOLUMNNEW("Grau/Item"            ,{|| GRAU+" - "+ITEM})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Infraฦo (Parte)"     ,{|| SUBS(DESCR,1,60)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Infraฦo (Completo)"  ,{|| DESCR })
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F2 )
      Ajuda()
   ELSEIF ( tecla == K_INS )     /* Inclui */
      Telas(8,5,10,66,1,YCOREDIT,.T.,"Inclusฦo")
      WHILE .T.
         xGrau:=xItem:=SPACE(1); xDescr:=SPACE(70)
         @ 09,07 SAY "Grau:"     GET xGrau  PICT "9"     VALID !EMPTY(xGrau)
         @ 09,15 SAY "Item:"     GET xItem  PICT "!"     VALID LASTKEY()==K_UP.OR.!EMPTY(xItem).AND.TCad(xGrau+xItem)
         @ 09,23 SAY "Infraฦo:" GET xDescr PICT "@!S33" VALID LASTKEY()==K_UP.OR.!EMPTY(xDescr)
         SETCURSOR(1); READ; SETCURSOR(0)
         IF LASTKEY()==K_ESC; EXIT; ENDIF
         WHILE !FALTAS->(NetApp()); ENDDO
         REPLACE FALTAS->GRAU  WITH xGrau,;
                 FALTAS->ITEM  WITH xItem,;
                 FALTAS->DESCR WITH xDescr
         FALTAS->(DBUNLOCK()); FALTAS->(DBCOMMIT())
      ENDDO
      Rest_Tela()
      oBr:Refreshall()
   ELSEIF ( tecla == K_DEL)   /* Exclui */
      IF !EMPTY(GRAU)
         WHILE !FALTAS->(NetLReg()); ENDDO
         FALTAS->(DBDELETE())
         FALTAS->(DBUNLOCK()); FALTAS->(DBCOMMIT())
         oBr:Refreshall()
      ELSE
         Aviso("Nฦo h  registro a ser Excluกdo...",,3)
      ENDIF
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela()
RESTSCREEN(2,0,24,79,tela)
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Item j  Cadastrado    ณ
*ิออออออออออออออออออออออออออออออพ
FUNCTION TCad(pVar)
  LOCAL nReg:=RECNO()
  IF FALTAS->(DBSEEK(pVar))
     Aviso("Infraฦo j  Cadastrada...",,3); GO nReg; RETURN .F.
  ENDIF
  GO nReg
  RETURN .T.

