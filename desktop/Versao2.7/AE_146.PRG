*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_146                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Grade de Distribuiao Disciplinar        ณ
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
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar os cursos!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar os instrutores!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 13
IF NetUse("DBDISC","DISCIPLINA")      /* Disciplinas */
   SET INDEX TO DBIDISC1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar as disciplinas!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 18
IF NetUse("DBGRADE","GRADE")          /* Grade */
   SET INDEX TO DBIGRAD1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cOpHelp1 := "1"; cOpHelp2 := "46"
cPrg:="AE146";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui ^F10^-Simulado"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,2,6,76,1,YCOREDIT,.T.,"Grade de Distribuiฦo Disciplinar")
Telas(6,2,19,76,1,YCOREDIT,.T.)
xCodCur:=SPACE(2)
WHILE .T.
   SET KEY -1 TO Mostra()
   @ 05,04 SAY "Curso: " GET xCodCur PICT "99" WHEN TeclaFuncao(.T.) VALID !EMPTY(xCodCur).AND.;
     Pesquisa(2,1,xCodCur,"Cขdigo do Curso nฦo Localizado!").AND.TDescr(2,1,5,15,xCodCur,"DESCR")
   SETCURSOR(1); READ; SETCURSOR(0)
   TeclaFuncao()
   IF LASTKEY()==K_ESC
      Rest_Tela(2); Linha23(msg); RESTSCREEN(2,0,24,79,vTela); SETCOLOR(corant)
      DBCLOSEALL(); RETURN
   ENDIF
   SET FILTER TO
   GRADE->(DBCLEARFILTER())
   GRADE->(DBSETFILTER({||CODCUR=xCodCur}, [CODCUR=xCodCur])); GRADE->(DBGOTOP())
   DISCIPLINA->(DBSETFILTER({||CODCUR=xCodCur}, [CODCUR=xCodCur])); DISCIPLINA->(DBGOTOP())
   SETKEY(K_F2,NIL)
   BrowGrade()
   DISCIPLINA->(DBCLEARFILTER())
   SET FILTER TO
ENDDO
*ีออออออออออออออออออออออออออออออธ
*ณ Browse das Grade de Aulas    ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE BrowGrade()
   Linha23(msg)
   oBr:=TBROWSEDB(7,3,18,75)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec:=YCOREDIT

   oCol:=TBCOLUMNNEW("Grade"        ,{|| CODGRA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("N๘Aula"       ,{|| NAULA})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Sim./Disciplina",{|| SIMULADO+"  "+TRANSFORM(PegaDisc(CODCUR+CODDIS),"@S25")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Dia"           ,{|| NDIA})
   oBr:addColumn(oCol)
*  oCol:=TBCOLUMNNEW("Hor rio"      ,{|| HORARIO})
*  oBr:addColumn(oCol)
*  oCol:=TBCOLUMNNEW("Prof.Titular" ,{|| PegaInst(CODINST)})
*  oBr:addColumn(oCol)

   SET KEY -1 TO Mostra()
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
         SET KEY -1 TO Mostra()
         nReg_Ant := RECNO()
         Telas(16,2,19,76,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
         @ 17,03 SAY "Grade Disciplina          Dia Aula"
*        @ 17,03 SAY "Grade Disciplina Dia Aula Hor rio       Prof.Titular"
*                      99   XX LEGISLACAO       99  99   99:99 a 99:99 9999 FULANO DE TALXXXXXXX
*                     34567890123456789012345678901234567890123456789012345678901234567890
*                            1         2         3         4         5         6         7
         vCodGra:=SPACE(2);vNAula:=vNDia:=vCodDis:=SPACE(2);vCodInst:=SPACE(4);vHorario:=SPACE(13)
         @ 18,04 GET vCodGra  PICT "99"   VALID !EMPTY(vCodGra)
         @ 18,09 GET vCodDis  PICT "!!"   VALID (LASTKEY()==K_UP).OR.(Pesquisa(13,1,xCodCur+vCodDis,"Disciplina Nฦo Cadastrada!").AND.TDescr(13,1,18,10,xCodCur+vCodDis,"DESCR",["@S16"]))
         @ 18,29 GET vNDia    PICT "99"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vNDia).AND.VAL(vNDia)>0
         @ 18,33 GET vNAula   PICT "99"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vNAula).AND.TCurso(vCodGra+xCodCur+vNDia+vCodDis+vNAula,"I")
*        @ 18,32 GET vHorario PICT "99:99XXX99:99"  VALID (LASTKEY()==K_UP).OR.!EMPTY(vHorario)
*        @ 18,46 GET vCodInst PICT "9999" VALID (LASTKEY()==K_UP).OR.Pesquisa(3,1,vCodInst,"Instrutor Nฦo Cadastrado!").AND.TDescr(3,1,18,49,vCodInst,"NOME",["@S20"])
         SETCURSOR(1); READ; SETCURSOR(0)

         IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
            WHILE !NetApp(); ENDDO
            GRADE->CODCUR     := xCodCur
            GRADE->CURSO      := CURSO->DESCR
            GRADE->CODGRA     := vCodGra
            GRADE->CODDIS     := vCodDis
            GRADE->NDIA       := vNDia
            GRADE->NAULA      := vNAula
*           GRADE->CODINST    := vCodInst
*           GRADE->HORARIO    := vHorario
            GRADE->(DBUNLOCK()); GRADE->(DBCOMMIT())
            ProcOk("Incluกdo",.T.)
         ELSE
            GO nReg_Ant
         ENDIF
         Rest_Tela(); Linha23(msg)
         oBr:refreshAll()
      ELSEIF ( tecla == K_DEL )
         Exclui(msg); oBr:refreshAll(); oBr:gotop()
      ELSEIF ( tecla == K_F10 )
         WHILE !GRADE->(NetLReg()); ENDDO
         REPLACE GRADE->SIMULADO WITH IF(EMPTY(GRADE->SIMULADO),"*"," ")
         GRADE->(DBUNLOCK()); GRADE->(DBCOMMIT())
         oBr:refreshAll()
      ELSEIF ( tecla == K_ENTER )
         nReg_Ant := RECNO(); lAlt := .F.

         DBGOTOP()
         IF EOF()
            Aviso("Nฦo h  registro a ser Alterado !",,2)
            Linha23(msg)
         ELSE
            GO nReg_Ant
            SET KEY -1 TO Mostra()
            SETCOLOR(YCOREDIT)
            Telas(16,2,19,76,1,YCOREDIT,.T.," Alteraฦo ")
            @ 17,03 SAY "Grade Disciplina          Dia Aula"
*           @ 17,03 SAY "Grade Disciplina    Dia Aula Hor rio       Prof.Titular"
            vNDia    := fNDia   := NDIA
            vCodGra  := fCodGra := CODGRA
            vCodDis  := fCodDis := CODDIS
            vNAula   := fNAula  := NAULA
*           vCodInst := CODINST
*           vHorario := HORARIO
            @ 18,04 GET vCodGra  PICT "99"   VALID !EMPTY(vCodGra)
            @ 18,09 GET vCodDis  PICT "!!"   VALID (LASTKEY()==K_UP).OR.(Pesquisa(13,1,xCodCur+vCodDis,"Disciplina Nฦo Cadastrada!").AND.TDescr(13,1,18,10,xCodCur+vCodDis,"DESCR",["@S16"]))
            @ 18,29 GET vNDia    PICT "99"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vNDia).AND.VAL(vNDia)>0
            @ 18,33 GET vNAula   PICT "99"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vNAula).AND.TCurso(vCodGra+xCodCur+vNDia+vCodDis+vNAula,"A")
*           @ 18,32 GET vHorario PICT "99:99XXX99:99" VALID (LASTKEY()==K_UP).OR.!EMPTY(vHorario)
*           @ 18,46 GET vCodInst PICT "9999" VALID (LASTKEY()==K_UP).OR.Pesquisa(3,1,vCodInst,"Instrutor Nฦo Cadastrado!").AND.TDescr(3,1,18,49,vCodInst,"NOME",["@S25"])
            SETCURSOR(1); READ; SETCURSOR(0)

            IF LASTKEY()#K_ESC.AND.UPDATED()
               IF Confirma("Confirma Alteraฦo ?")
                  GO nReg_Ant
                  WHILE !GRADE->(NetLReg()); ENDDO
                  REPLACE GRADE->CODCUR  WITH xCodCur  ,;
                          GRADE->CODGRA  WITH vCodGra  ,;
                          GRADE->CODDIS  WITH vCodDis  ,;
                          GRADE->NDIA    WITH vNDia    ,;
                          GRADE->NAULA   WITH vNAula
*                         GRADE->CODINST WITH vCodInst ,;
*                         GRADE->HORARIO WITH vHorario
                  GRADE->(DBUNLOCK()); GRADE->(DBCOMMIT())
                  ProcOk("Alterado",.T.)
                  lAlt := .T.
               ENDIF
            ENDIF
         ENDIF
         Rest_Tela(); GO nReg_Ant; Linha23(msg)
         oBr:refreshAll()
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
   ENDDO
   RETURN
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
*ีออออออออออออออออออออออออออออออธ
*ณ Testar Existencia da GRADE   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TCurso(pCod,pOp)
   IF pOp=="A"
      IF vNDia#fNDia.OR.vCodGra#fCodGra.OR.vCodDis#fCodDis.OR.vNAula#fNAula
         IF (lRet:=DBSEEK(pCod))
            Aviso("Grade j  Existente...",,3)
            RETURN(!lRet)
         ENDIF
      ELSE
         RETURN(.T.)
      ENDIF
   ENDIF
   IF (lRet:=DBSEEK(pCod))
      Aviso("Grade j  Existente...",,3)
   ENDIF
   RETURN(!lRet)
