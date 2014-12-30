*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ PROGRAMA       : AE_220                           vrs 001 ³
*³ VRS 001        : Implantacao                              ³
*³ FINALIDADE     : Lan‡amento de Aulas Praticas             ³
*³ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ³
*³ DATA CRIACAO   : 08/01/1996                               ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
#include "INKEY.CH"

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"LFALTA"  ,"L",   01,0}) /* Falta Confirmada */
AADD(aDbf,{"OK"      ,"C",   01,0}) /* Aula Executada   */
AADD(aDbf,{"CODINST" ,"C",   04,0}) /* C¢d.Instrutor    */
AADD(aDbf,{"HORA"    ,"C",   04,0}) /* Hora Prevista    */
AADD(aDbf,{"ALUNO"   ,"C",   50,0}) /* Nome do Aluno    */
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON hora TO (cArq1)

SELECT 11
IF NetUse("DBEXTRA","EXTRA")          /* Horas Extras de Instrutores */
   SET INDEX TO DBIEXT1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 5
IF NetUse("DBFERI","FERIADO")         /* Feriados */
   SET INDEX TO DBIFER1
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 4
IF NetUse("DBVEIC","VEICULO")         /* Ve¡culos */
   SET INDEX TO DBIVEI1,DBIVEI2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO STATUS="A"

SELECT 3
IF NetUse("DBALU","ALUNOS")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 2
IF NetUse("DBINST","INSTRUTOR")       /* Instrutores */
   SET INDEX TO DBINST1,DBINST2
ELSE
   DelDbfNtx(); RETURN
ENDIF
SET FILTER TO INSTRUTOR->STATUS="A".AND.(INSTRUTOR->CATEG="1".OR.INSTRUTOR->CATEG="3")

SELECT 1
IF NetUse("DBPROG","AULAS")           /* Programa‡Æo de Aulas */
   SET INDEX TO DBIPRO2,DBIPRO1,DBIPRO3,DBIPRO4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE220"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "20"
SET KEY -1 TO Mostra()
wData:=cDtSys; wIns:=SPACE(4)
WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(4,3,7,68,1,YCOREDIT,.T.,"Lan‡amento de Aulas")
   Mensagem("Informe c¢digo do Instrutor e Data da Aula")
   @ 05,05 SAY "Instrutor:" GET wIns PICT "9999" WHEN TeclaFuncao(.T.);
     VALID TDescr(2,1,5,21,wIns,"NOME",["@S40"],"Instrutor NÆo Localizado")
   @ 06,05 SAY "     Data:" GET wData PICT "@D"  WHEN TeclaFuncao();
     VALID LASTKEY()==K_UP.OR.!EMPTY(wData).AND.TData(wData).AND.wData<=cDtSys
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   IF AULAS->(DBSEEK(wIns+DTOS(wData)))
      WHILE AULAS->CODINST==wIns.AND.AULAS->DATA==wData
         IF wData==cDtSys
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->HORA    WITH AULAS->HORA,;
                    (cArq1)->CODINST WITH AULAS->CODINST,;
                    (cArq1)->ALUNO   WITH TAluno(AULAS->MATRIC),;
                    (cArq1)->OK      WITH IF(AULAS->COBRADA,"X",IF(AULAS->STATUS,"F","X")),;
                    (cArq1)->LFALTA  WITH AULAS->STATUS

            IF AULAS->COBRADA
               /* Aumentar pendencias de aulas */
               ALUNOS->(DBSEEK((cArq1)->AULAS->MATRIC))
               WHILE !ALUNOS->(NetlReg()); ENDDO
               REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE + 1
               ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())
            ENDIF
         ELSE
            IF !AULAS->COBRADA
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->HORA    WITH AULAS->HORA,;
                       (cArq1)->ALUNO   WITH TAluno(AULAS->MATRIC) ,;
                       (cArq1)->CODINST WITH AULAS->CODINST      ,;
                       (cArq1)->OK      WITH IF(AULAS->COBRADA,"X",IF(AULAS->STATUS,"F","X")),;
                       (cArq1)->LFALTA  WITH AULAS->STATUS
            ELSEIF AULAS->COBRADA
               /* Aumentar pendencias de aulas */
               ALUNOS->(DBSEEK((cArq1)->AULAS->MATRIC))
               WHILE !ALUNOS->(NetlReg()); ENDDO
               REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE + 1
               ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())
            ENDIF
         ENDIF
         AULAS->(DBSKIP())
      ENDDO
      /* Display da Programa‡Æo */
      LinhaMsg(11)
      IF !(cArq1)->(EOF())
         Baixa()
      ELSE
         Aviso("Lan‡amentos j  Efetuados...",,3)
      ENDIF
   ELSE
      Aviso("NÆo houve aula realizada por este instrutor nesta data...",,3)
   ENDIF
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
*INSTRUTOR->(DBCLEARFILTER())
DelDbfNtx(); RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Programa‡Æo do Instrutor       ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION Baixa()
  LOCAL lMudou:=.F.
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(7,3,19,68,1,YCOREDIT,.T.)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(8,4,18,67)
  oBr:headSep:="ÄÂÄ"
  oBr:colSep:= " ³ "

  oCol:=TBCOLUMNNEW("Aula" ,{|| OK})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora" ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno",{|| TRANSFORM(ALUNO,"@S45")})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF lMudou
           IF Confirma("Confirma Lan‡amentos ?")
              (cArq1)->(DBGOTOP())
              WHILE !(cArq1)->(EOF())
                 IF (cArq1)->OK=="X"
                    AULAS->(DBSEEK(wIns+DTOS(wData)+(cArq1)->HORA))
                    WHILE !AULAS->(NetlReg()); ENDDO
                    REPLACE AULAS->COBRADA WITH .T.
                    AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())

                    /* Diminuir pendencias de aulas */
                    ALUNOS->(DBSEEK((cArq1)->AULAS->MATRIC))
                    WHILE !ALUNOS->(NetlReg()); ENDDO
                    REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE - 1
                    ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())

                    /* Gravar hora extra */
                    IF DOW(wData)==7 // Sabado
                       IF (cArq1)->HORA="07".OR.(cArq1)->HORA="12".OR.(cArq1)->HORA="13".OR.;
                          (cArq1)->HORA="14".OR.(cArq1)->HORA="15".OR.(cArq1)->HORA="16".OR.;
                          (cArq1)->HORA="17".OR.(cArq1)->HORA="18".OR.(cArq1)->HORA="19"
                          WHILE !EXTRA->(NetApp()); ENDDO
                          REPLACE EXTRA->CODINST  WITH (cArq1)->CODINST ,;
                                  EXTRA->ALUNO    WITH (cArq1)->ALUNO   ,;
                                  EXTRA->DATA     WITH wData            ,;
                                  EXTRA->HORA     WITH (cArq1)->HORA
                          EXTRA->(DBUNLOCK()); EXTRA->(DBCOMMIT())
                       ENDIF
                    ELSE
                       // Dia da Semana
                       IF (cArq1)->HORA="07".OR.(cArq1)->HORA="12".OR.(cArq1)->HORA="13".OR.(cArq1)->HORA="18".OR.(cArq1)->HORA="19"
                          WHILE !EXTRA->(NetApp()); ENDDO
                          REPLACE EXTRA->CODINST  WITH (cArq1)->CODINST ,;
                                  EXTRA->ALUNO    WITH (cArq1)->ALUNO   ,;
                                  EXTRA->DATA     WITH wData            ,;
                                  EXTRA->HORA     WITH (cArq1)->HORA
                          EXTRA->(DBUNLOCK()); EXTRA->(DBCOMMIT())
                       ENDIF
                    ENDIF
                 ELSE
                    IF (cArq1)->OK=="F"
                       /* Gravar hora extra do instrutor que ficou em disposicao */
                       IF DOW(wData)==7 // Sabado
                          IF (cArq1)->HORA="07".OR.(cArq1)->HORA="12".OR.(cArq1)->HORA="13".OR.;
                             (cArq1)->HORA="14".OR.(cArq1)->HORA="15".OR.(cArq1)->HORA="16".OR.;
                             (cArq1)->HORA="17".OR.(cArq1)->HORA="18".OR.(cArq1)->HORA="19"
                             WHILE !EXTRA->(NetApp()); ENDDO
                             REPLACE EXTRA->CODINST  WITH (cArq1)->CODINST ,;
                                     EXTRA->ALUNO    WITH (cArq1)->ALUNO   ,;
                                     EXTRA->DATA     WITH wData            ,;
                                     EXTRA->HORA     WITH (cArq1)->HORA
                             EXTRA->(DBUNLOCK()); EXTRA->(DBCOMMIT())
                          ENDIF
                       ELSE
                          // Dia da Semana
                          IF (cArq1)->HORA="07".OR.(cArq1)->HORA="12".OR.(cArq1)->HORA="13".OR.(cArq1)->HORA="18".OR.(cArq1)->HORA="19"
                             WHILE !EXTRA->(NetApp()); ENDDO
                             REPLACE EXTRA->CODINST  WITH (cArq1)->CODINST ,;
                                     EXTRA->ALUNO    WITH (cArq1)->ALUNO   ,;
                                     EXTRA->DATA     WITH wData            ,;
                                     EXTRA->HORA     WITH (cArq1)->HORA
                             EXTRA->(DBUNLOCK()); EXTRA->(DBCOMMIT())
                          ENDIF
                       ENDIF

                       AULAS->(DBSEEK(wIns+DTOS(wData)+(cArq1)->HORA))
                       WHILE !AULAS->(NetlReg()); ENDDO
                       REPLACE AULAS->STATUS WITH .T.
                       AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())

                       /* Diminuir pendencias de aulas */
                       ALUNOS->(DBSEEK(AULAS->MATRIC))
                       WHILE !ALUNOS->(NetlReg()); ENDDO
                       REPLACE ALUNOS->PENDENTE WITH ALUNOS->PENDENTE - 1
                       ALUNOS->(DBUNLOCK()); ALUNOS->(DBCOMMIT())
                    ELSE
                       AULAS->(DBSEEK(wIns+DTOS(wData)+(cArq1)->HORA))
                       WHILE !AULAS->(NetlReg()); ENDDO
                       REPLACE AULAS->COBRADA WITH .F.
                       AULAS->(DBUNLOCK()); AULAS->(DBCOMMIT())
                    ENDIF
                 ENDIF
                 (cArq1)->(DBSKIP())
              ENDDO
           ENDIF
        ENDIF
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == 70 .OR. tecla == 102 )
       IF (cArq1)->LFALTA
          Aviso("Aula j  registrada com falta!")
       ELSE
          REPLACE (cArq1)->OK WITH IF((cArq1)->OK==" ","F"," ")
          lMudou:=.T.
          oBr:Refreshall()
       ENDIF
     ELSEIF ( tecla == K_ENTER )
        SET KEY -1 TO Mostra()
        IF (cArq1)->LFALTA
           Aviso("Aula j  registrada com falta!")
        ELSE
           lMudou:=.T.
           REPLACE (cArq1)->OK WITH IF((cArq1)->OK==" ","X"," ")

           /* Identificar o instrutor que ministrou a aula se for hora extra */
           IF DOW(wData)==7 // Sabado
              IF (cArq1)->HORA="07".OR.(cArq1)->HORA="12".OR.(cArq1)->HORA="13".OR.;
                 (cArq1)->HORA="14".OR.(cArq1)->HORA="15".OR.(cArq1)->HORA="16".OR.;
                 (cArq1)->HORA="17".OR.(cArq1)->HORA="18".OR.(cArq1)->HORA="19"
                 Telas(7,13,9,68,1,YCOREDIT,.T.,"Hora Extra - Instrutor")
                 wCodInst:= wIns
                 WHILE .T.
                   @ 08,15 GET wCodInst PICT "9999" WHEN TeclaFuncao(.T.);
                     VALID TDescr(2,1,8,21,wCodInst,"NOME",["@S40"],"Instrutor NÆo Localizado")
                   SETCURSOR(1); READ; SETCURSOR(0)

                   TeclaFuncao()
                   IF LASTKEY()==K_ESC; EXIT; ENDIF
                   IF wCodInst#wIns
                      IF Confirma("Confirma Mudan‡a de Instrutor nesta aula ?")
                         REPLACE (cArq1)->CODINST WITH wCodInst
                         EXIT
                      ENDIF
                   ELSE
                      EXIT
                   ENDIF
                 ENDDO
                 Rest_Tela()
              ENDIF
           ELSE
              IF (cArq1)->HORA=="07".OR.(cArq1)->HORA=="12".OR.(cArq1)->HORA=="13".OR.(cArq1)->HORA=="18".OR.(cArq1)->HORA=="19"
                 Telas(7,13,9,68,1,YCOREDIT,.T.,"Hora Extra - Instrutor")
                 wCodInst:= wIns
                 WHILE .T.
                   @ 08,15 GET wCodInst PICT "9999" WHEN TeclaFuncao(.T.);
                     VALID TDescr(2,1,8,21,wCodInst,"NOME",["@S40"],"Instrutor NÆo Localizado")
                   SETCURSOR(1); READ; SETCURSOR(0)

                   TeclaFuncao()
                   IF LASTKEY()==K_ESC; EXIT; ENDIF
                   IF wCodInst#wIns
                      IF Confirma("Confirma Mudan‡a de Instrutor nesta aula ?")
                         REPLACE (cArq1)->CODINST WITH wCodInst
                         EXIT
                      ENDIF
                   ELSE
                      EXIT
                   ENDIF
                 ENDDO
                 Rest_Tela()
              ENDIF
           ENDIF
           oBr:Refreshall()
        ENDIF
        SETKEY(K_F2,NIL)
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
*ÕÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¸
*³ Localizar Nome do Aluno      ³
*ÔÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¾
FUNCTION TAluno(pVar)
  ALUNOS->(DBSEEK(pVar))
  RETURN(ALUNOS->NOME)
