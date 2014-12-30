*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_144                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Turmas de Aulas Teoricas                 ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 01/11/2005                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela

DBCLOSEALL()
SELECT 2
IF NetUse("DBESCA","ESCALA")        /* Escalas */
   SET INDEX TO DBIESCA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar a escala!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 18
IF NetUse("DBGRADE","GRADE")        /* Grade */
   SET INDEX TO DBIGRAD1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar a Grade!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 17
IF !NetUse("DBPARM")                /* Parametros */
   DBCLOSEALL(); RETURN
ENDIF

SELECT 12
IF NetUse("DBFERI","FERIADO")       /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 15
IF NetUse("DBSALA","SALA")          /* Sala de aula */
   SET INDEX TO DBISALA1
ELSE
   DBCLOSEALL(); RETURN
ENDIF
IF EOF()
   Aviso(" necess rio cadastrar a sala!")
   DBCLOSEALL(); RETURN
ENDIF

SELECT 3
IF NetUse("DBFREQ","FREQUENCIA")    /* Frequencia Aulas Teoricas */
   SET INDEX TO DBIFREQ1,DBIFREQ2,DBIFREQ3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 1
IF NetUse("DBTURMA","TURMA")        /* Turma */
   SET INDEX TO DBITURM3, DBITURM1,DBITURM2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE144";LinhaMsg(2); ProgName(cPrg)
msg:="^INS^-Inclui ^ENTER^-Altera ^DEL^-Exclui ^F10^-Adia Turma"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,2,19,76,1,YCOREDIT,.T.,"Turmas de Aulas Teขricas")
Linha23(msg)
oBr:=TBROWSEDB(5,3,18,75)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Turma"        ,{|| TURMA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Escala"       ,{|| PegaEscala(ESCALA)})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Hor rio"      ,{|| ESCALA->HORARIO})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Turno"        ,{|| IF(TURNO="1","Manhฦ",IF(TURNO="2","Tarde",IF(TURNO="3","Noite",SPACE(5))))})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Inicio"       ,{|| DTINIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Trmino"      ,{|| DTFIM})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Sala"         ,{|| SALA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Grade"        ,{|| CODGRA})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Alunos"       ,{|| USO_N})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Repos."       ,{|| USO_R})
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
      SET KEY -1 TO Mostra()
      nReg_Ant := RECNO()
      Telas(16,2,19,76,c_nBorda,YCOREDIT,.T.," Inclusฦo ")
      @ 17,03 SAY "Sala Turno Turma Escala Grade  Inกcio      Trmino"
*                   99    9   XXXXX   99    99    99/99/9999  99/99/9999
*                  34567890123456789012345678901234567890123456789012345678901234567890
*                         1         2         3         4         5         6         7
      vTurno:=SPACE(1);vSala:=vEscala:=vCodGra:=SPACE(2);vTurma:=SPACE(5)
      vDtInic:=vDtFim:=CTOD("")
      @ 18,04 GET vSala    PICT "99"   WHEN TeclaFuncao(.T.) VALID !EMPTY(vSala).OR.Pesquisa(15,1,vSala,"Sala Nฦo Cadastrada!")
      @ 18,10 GET vTurno   PICT "9"    WHEN TeclaFuncao().AND.HTela(9) VALID VTela(9)
      @ 18,14 GET vTurma   PICT "@!"   WHEN TeclaFuncao()    VALID (LASTKEY()==K_UP).OR.!EMPTY(vTurma).AND.TTurma(vTurno+vTurma,"I")
      @ 18,22 GET vEscala  PICT "99"   WHEN TeclaFuncao(.T.) VALID (LASTKEY()==K_UP).OR.Pesquisa(2,1,vEscala,"Escala Nฦo Cadastrada!")
      @ 18,28 GET vCodGra  PICT "99"   WHEN TeclaFuncao()    VALID (LASTKEY()==K_UP).OR.Pesquisa(18,1,vCodGra,"Grade Nฦo Cadastrada!")
      @ 18,34 GET vDtInic  PICT "@D"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vDtInic)
      @ 18,46 GET vDtFim   PICT "@D"   VALID (LASTKEY()==K_UP).OR.vDtFim>=DtInic
      SETCURSOR(1); READ; SETCURSOR(0)

      IF LASTKEY()#K_ESC.AND.Confirma("Confirma Inclusฦo ?")
         GravaTurma()
         WHILE !NetApp(); ENDDO
         TURMA->NTURMA     := DBPARM->NTURMA
         TURMA->TURNO      := vTurno
         TURMA->TURMA      := vTurma
         TURMA->ESCALA     := vEscala
         TURMA->CODGRA     := vCodGra
         TURMA->CODCUR     := GRADE->CODCUR
         TURMA->SALA       := vSala
         TURMA->DTINIC     := vDtInic
         TURMA->DTFIM      := vDtFim
         TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
         ProcOk("Incluกdo",.T.)
      ELSE
         GO nReg_Ant
      ENDIF
      Rest_Tela(); Linha23(msg)
      oBr:refreshAll()
   ELSEIF ( tecla == K_DEL )
      Exclui(msg); oBr:refreshAll(); oBr:gotop()
   ELSEIF ( tecla == K_F10 )   // Adiar Turma
      nReg_Ant := RECNO()

      DBGOTOP()
      IF EOF()
         Aviso("Nฦo h  registro de turma a ser adiado !",,2)
         Linha23(msg)
      ELSE
         GO nReg_Ant
         SETCOLOR(YCOREDIT)
         Telas(16,2,19,76,1,YCOREDIT,.T.," Adiamento de Turma ")
         @ 17,03 SAY "Data Inกcio     Data Trmino"
*                     99/99/9999      99/99/9999
*                     3456789012345678901234567890
*                            1         2         3
         vDtInic  := fDtInic := DTINIC
         vDtFim   := fDtFim  := DTFIM
         @ 18,03 GET vDtInic  PICT "@D"   VALID !EMPTY(vDtInic)
         @ 18,19 GET vDtFim   PICT "@D"   VALID (LASTKEY()==K_UP).OR.vDtFim>=DtInic
         SETCURSOR(1); READ; SETCURSOR(0)

         IF LASTKEY()#K_ESC.AND.UPDATED()
            IF Confirma("Confirma Adiamento ?")
               Aguarde("Adiando aulas...")
               FREQUENCIA->(DBSETORDER(3))
               // Localizar alunos da turma
               IF FREQUENCIA->(DBSEEK(TURMA->NTURMA))
                  // Gerar matriz de datas
                  aData := {}; aRegAdia:={}

                  // Localiza 1๘ dia de aula da grade
                  GRADE->(DBSEEK(TURMA->CODGRA+TURMA->CODCUR+"01"))
                  xData  :=vDtInic
                  dDtFim :=vDtFim
                  xDia   :=GRADE->NDIA

                  WHILE GRADE->CODGRA==TURMA->CODGRA.AND.GRADE->CODCUR==TURMA->CODCUR
                     // Testar feriados
                     IF TFeriado(xData)
                        xData := xData + 1; LOOP
                     ELSE
                        // Testar se dia  valido na escala
                        IF TEscala(xData,TURMA->ESCALA)
                           AADD(aData,{xData})
                        ELSE
                           xData := xData + 1; LOOP
                        ENDIF
                     ENDIF
                     GRADE->(DBSKIP())
                     IF GRADE->NDIA # xDia
                        xDia  := GRADE->NDIA
                        xData := xData + 1
                     ENDIF
                  ENDDO

                  GravaTurma(); i=1; vMatric:=FREQUENCIA->MATRIC
                  WHILE FREQUENCIA->NTURMA=TURMA->NTURMA
                     IF FREQUENCIA->MATRIC#vMatric
                        i=1; vMatric := FREQUENCIA->MATRIC
                     ENDIF
                     AADD(aRegAdia,{FREQUENCIA->(RECNO())})
                     WHILE !FREQUENCIA->(NetLReg()); ENDDO
                     REPLACE FREQUENCIA->DATA WITH aData[i,1]
                     FREQUENCIA->(DBUNLOCK()); FREQUENCIA->(DBCOMMIT())
                     FREQUENCIA->(DBSKIP()); i++
                  ENDDO
                  FOR y = 1 TO LEN(aRegAdia)
                     FREQUENCIA->(DBGOTO(aRegAdia[y,1]))
                     WHILE !FREQUENCIA->(NetLReg()); ENDDO
                     REPLACE FREQUENCIA->NTURMA WITH DBPARM->NTURMA
                     FREQUENCIA->(DBUNLOCK()); FREQUENCIA->(DBCOMMIT())
                  NEXT

                  WHILE !TURMA->(NetLReg()); ENDDO
                  REPLACE TURMA->NTURMA WITH DBPARM->NTURMA ,;
                          TURMA->DTINIC WITH vDtInic        ,;
                          TURMA->DTFIM  WITH vDtFim
                  TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
                  FREQUENCIA->(DBSETORDER(1))
                  Aguarde()
               ELSE
                  Aviso("Nฦo houve alunos matriculados nessa turma",,3)
               ENDIF
            ENDIF
         ENDIF
         Rest_Tela(); oBr:refreshAll()
      ENDIF
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
         @ 17,03 SAY "Sala Turno Turma Escala Grade  Inกcio      Trmino"
         vTurno   := fTurno  := TURNO
         vTurma   := fTurma  := TURMA
         vEscala  := fEscala := ESCALA
         vCodGra  := fCodGra := CODGRA
         vSala    := SALA
         vDtInic  := fDtInic := DTINIC
         vDtFim   := fDtFim  := DTFIM
         @ 18,04 GET vSala    PICT "99"   WHEN TeclaFuncao(.T.) VALID !EMPTY(vSala).OR.Pesquisa(15,1,vSala,"Sala Nฦo Cadastrada!")
         @ 18,10 GET vTurno   PICT "9"    WHEN TeclaFuncao().AND.HTela(9) VALID VTela(9)
         @ 18,14 GET vTurma   PICT "@!"   WHEN TeclaFuncao()    VALID (LASTKEY()==K_UP).OR.!EMPTY(vTurma).AND.TTurma(vTurno+vTurma,"A")
         @ 18,22 GET vEscala  PICT "99"   WHEN TeclaFuncao(.T.) VALID (LASTKEY()==K_UP).OR.Pesquisa(2,1,vEscala,"Escala Nฦo Cadastrada!")
         @ 18,28 GET vCodGra  PICT "99"   WHEN TeclaFuncao()    VALID (LASTKEY()==K_UP).OR.Pesquisa(18,1,vCodGra,"Grade Nฦo Cadastrada!")
         @ 18,34 GET vDtInic  PICT "@D"   VALID (LASTKEY()==K_UP).OR.!EMPTY(vDtInic)
         @ 18,46 GET vDtFim   PICT "@D"   VALID (LASTKEY()==K_UP).OR.vDtFim>=DtInic
         SETCURSOR(1); READ; SETCURSOR(0)

         IF LASTKEY()#K_ESC.AND.UPDATED()
            IF Confirma("Confirma Alteraฦo ?")
               lRenova:=.F.
               IF vDtInic#fDtInic.OR.vDtFim#fDtFim
                  lRenova:=Confirma("Renova o n๘ de vagas da sala ?")
                  GravaTurma()
               ENDIF
               GO nReg_Ant
               WHILE !TURMA->(NetLReg()); ENDDO
               REPLACE TURMA->TURMA   WITH vTurma   ,;
                       TURMA->NTURMA  WITH DBPARM->NTURMA ,;
                       TURMA->TURNO   WITH vTurno   ,;
                       TURMA->ESCALA  WITH vEscala  ,;
                       TURMA->CODGRA  WITH vCodGra  ,;
                       TURMA->CODCUR  WITH GRADE->CODCUR ,;
                       TURMA->SALA    WITH vSala    ,;
                       TURMA->DTINIC  WITH vDtInic  ,;
                       TURMA->DTFIM   WITH vDtFim   ,;
                       TURMA->USO_N   WITH IF(lRenova,0,TURMA->USO_N) ,;
                       TURMA->USO_R   WITH IF(lRenova,0,TURMA->USO_R)
               TURMA->(DBUNLOCK()); TURMA->(DBCOMMIT())
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
Rest_Tela(); Linha23(msg); RESTSCREEN(2,0,24,79,vTela); SETCOLOR(corant)
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
*ณ Testar Existencia da TURMA   ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION TTurma(pCod,pOp)
   DBSETORDER(2)
   IF pOp=="A"
      IF vTurno#fTurno.OR.vCodGra#fCodGra.OR.vTurma#fTurma.OR.vEscala#fEscala
         IF (lRet:=DBSEEK(pCod))
            Aviso("Turma j  Existente...",,3)
            RETURN(!lRet)
         ENDIF
      ELSE
         DBSETORDER(1)
         RETURN(.T.)
      ENDIF
   ENDIF
   IF (lRet:=DBSEEK(pCod))
      Aviso("Turma j  Existente...",,3)
   ENDIF
   DBSETORDER(1)
   RETURN(!lRet)
