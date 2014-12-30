*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_117                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Requerimento por Setor                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 25/11/2005                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
aDbf := {}
AADD(aDbf,{"REQ"        ,"C",   07,0}) /* Numero do Requerimento   */
AADD(aDbf,{"DATA"       ,"D",   08,0}) /* Data do Requerimento     */
AADD(aDbf,{"HORA"       ,"C",   04,0}) /* Hora do requerimento     */
AADD(aDbf,{"USER"       ,"C",   20,0}) /* Atendente                */
AADD(aDbf,{"PRAZO"      ,"D",   08,0}) /* Data para providencia    */
AADD(aDbf,{"MATRIC"     ,"C",   05,0}) /* Matricula do Aluno       */
AADD(aDbf,{"NOME"       ,"C",   40,0}) /* Nome do requerente       */
AADD(aDbf,{"ASS1"       ,"C",   60,0}) /* Assunto                  */
AADD(aDbf,{"ASS2"       ,"C",   60,0}) /* Assunto                  */
AADD(aDbf,{"ASS3"       ,"C",   60,0}) /* Assunto                  */
AADD(aDbf,{"RECOM1"     ,"C",   60,0}) /* Recomendacao             */
AADD(aDbf,{"RECOM2"     ,"C",   60,0}) /* Recomendacao             */
AADD(aDbf,{"SITUACAO"   ,"C",   01,0}) /* 1-Resolvido 2-nao resolvido 3-Pendente */
AADD(aDbf,{"SETOR1"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
AADD(aDbf,{"SETOR2"     ,"C",   01,0})
AADD(aDbf,{"SETOR3"     ,"C",   01,0})
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
INDEX ON DTOS(data)+hora TO (cArq1)

aDbf := {}
AADD(aDbf,{"REQ"        ,"C",   07,0}) /* Numero do Requerimento   */
AADD(aDbf,{"DATA"       ,"D",   08,0}) /* Data do Retorno          */
AADD(aDbf,{"HORA"       ,"C",   04,0}) /* Hora do Retorno          */
AADD(aDbf,{"PRAZO"      ,"D",   08,0}) /* Prazo da ultima provid.  */
AADD(aDbf,{"RESULT1"    ,"C",   70,0}) /* Retorno resultado        */
AADD(aDbf,{"RESULT2"    ,"C",   70,0})
AADD(aDbf,{"RESULT3"    ,"C",   70,0})
AADD(aDbf,{"USER"       ,"C",   20,0}) /* Atendente                */
AADD(aDbf,{"PENDENTE"   ,"C",   01,0}) /* Situacao retorno         */
AADD(aDbf,{"RESOLVIDO"  ,"C",   01,0}) /* Situacao retorno         */
WHILE .T.
   sHour:=TIME()
   cArq2:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq2+".DBF")
      DBCREATE(cArq2,aDbf)
      RELEASE aDbf
      EXIT
   ENDIF
ENDDO
SELECT 20
NetUse(cArq2,,"E")
INDEX ON req+DTOS(data)+hora TO (cArq2)

SELECT 2
IF NetUse("DBREQD","REQD")           /* Detalhes de Requerimento */
   SET INDEX TO DBIREQD1
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

SELECT 3
IF NetUse("DBREQ","REQ")             /* Requerimentos */
   SET INDEX TO DBIREQ3,DBIREQ1,DBIREQ2,DBIREQ4
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

cPrg:="AE117";ProgName(cPrg); LinhaMsg(2)
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
WHILE .T.
   xSetor:=" "
   SETCOLOR(YCOREDIT); Telas(3,3,5,75,1,YCOREDIT,.T.,"Requerimentos por Setor")
   @ 04,05 SAY "Setor:" GET xSetor PICT "!" WHEN HTela(15) VALID VTela(15)
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; Rest_Tela(2); EXIT; ENDIF

   IF REQ->(DBSEEK("2"))  // Requerimentos nao resolvidos
      Aguarde("Verificando requerimentos...")
      WHILE REQ->SITUACAO=="2".AND.!REQ->(EOF())
         IF xSetor="0"  // Todos os setores
            GrvReq()
         ELSE
            IF REQ->SETOR1==xSetor.OR.REQ->SETOR2==xSetor.OR.REQ->SETOR3==xSetor
               GrvReq()
            ENDIF
         ENDIF
         REQ->(DBSKIP())
      ENDDO
      IF REQ->(DBSEEK("3"))  // Requerimentos pendentes
         WHILE REQ->SITUACAO=="3".AND.!REQ->(EOF())
            IF xSetor="0"  // Todos os setores
               GrvReq()
            ELSE
               IF REQ->SETOR1==xSetor.OR.REQ->SETOR2==xSetor.OR.REQ->SETOR3==xSetor
                  GrvReq()
               ENDIF
            ENDIF
            REQ->(DBSKIP())
         ENDDO
      ENDIF
      Aguarde()
      LancaMov(xSetor)
      (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   ELSE
      Aviso("Nฦo h  requerimentos a este setor!",,3)
   ENDIF
   Rest_Tela()
ENDDO
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); DelDbfNtx2(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Pega Nome do Setor             ณ
*ิออออออออออออออออออออออออออออออออพ
PROCEDURE PegaSetor(pVar)
   LOCAL aSetor,xNome

   IF pVar#"0"
      aSetor:= {"Recepฦo","Secretaria","Financeiro",;
                "Administrativo", "Supervisฦo","Diretoria" }
      xNome := aSetor[VAL(pVar)]
   ELSE
      xNome := "Todos os Setores"
   ENDIF
   RETURN(xNome)
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse de Dados                ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION LancaMov(pVar)
  LOCAL lInc:=.F.,xSetor

  xSetor:=PegaSetor(pVar)
  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(3,3,17,75,1,YCOREDIT,.T.,"Requerimentos - "+xSetor)
  Telas(17,3,20,75,1,YCOREDIT,.T.,"Setores")
  @ 18,05 SAY "1="+PegaSetor("1")
  @ 19,05 SAY "2="+PegaSetor("2")
  @ 18,30 SAY "3="+PegaSetor("3")
  @ 19,30 SAY "4="+PegaSetor("4")
  @ 18,55 SAY "5="+PegaSetor("5")
  @ 19,55 SAY "6="+PegaSetor("6")
  Linha23("^INS^-Registra Retorno ^F9^-Imprime",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(4,4,16,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  IF pVar="0"
     oCol:=TBCOLUMNNEW("Setor"   ,{|| SETOR1+SETOR2+SETOR3})
     oBr:addColumn(oCol)
  ENDIF
  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"       ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Nome"       ,{|| TRANSFORM(NOME,"@S30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Situaฦo"   ,{|| IF(SITUACAO="1","Ok  ",IF(SITUACAO="2","NRes",IF(SITUACAO="3","Pend",SPACE(4))))})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Assunto"    ,{|| ASS1})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Assunto (Continuaฦo 1)"   ,{|| ASS2})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Assunto (Continuaฦo 2)"   ,{|| ASS3})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Recomendaฦo"              ,{|| RECOM1})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Recomendaฦo (Continuaฦo)",{|| RECOM2})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Atendente"  ,{|| USER})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF lInc
           /* Gravar todos os resultados */
           Aguarde("Atualizando os dados...")
           (cArq2)->(DBGOTOP())
           WHILE !(cArq2)->(EOF())
              WHILE !REQD->(NetApp()); ENDDO
              REPLACE REQD->REQ      WITH (cArq2)->REQ     ,;
                      REQD->DATA     WITH (cArq2)->DATA    ,;
                      REQD->HORA     WITH (cArq2)->HORA    ,;
                      REQD->PRAZO    WITH (cArq2)->PRAZO   ,;
                      REQD->RESULT1  WITH (cArq2)->RESULT1 ,;
                      REQD->RESULT2  WITH (cArq2)->RESULT2 ,;
                      REQD->RESULT3  WITH (cArq2)->RESULT3 ,;
                      REQD->USER     WITH (cArq2)->USER
              REQD->(DBUNLOCK()); REQD->(DBCOMMIT())

              // Atualizar situaฦo
              REQ->(DBSETORDER(4))
              REQ->(DBSEEK((cArq2)->REQ))
              WHILE !REQ->(NetLReg()); ENDDO
              REPLACE REQ->SITUACAO WITH IF((cArq2)->PENDENTE="S","3",IF((cArq2)->RESOLVIDO="S","1","2")) ,;
                      REQ->SETOR1   WITH (cArq2)->ENCAM1 ,;
                      REQ->SETOR2   WITH (cArq2)->ENCAM2 ,;
                      REQ->SETOR3   WITH (cArq2)->ENCAM3
              REQ->(DBUNLOCK()); REQ->(DBCOMMIT())
              REQ->(DBSETORDER(1))

              (cArq2)->(DBSKIP())
           ENDDO
           Aguarde()
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
     ELSEIF ( tecla == K_INS )     /* Incluir Retorno */
        IF Acesso(3)
           IF (cArq1)->SITUACAO="1"
              Aviso("Requerimento j  resolvido",,3); LOOP
           ENDIF
           SETCOLOR(YCOREDIT)
           Telas(12,3,21,75,1,YCOREDIT,.T.,"Inclusฦo de Retorno")
           xData:=DATE();xHora:=SUBS(TIME(),1,5);xPrazo:=xData+2;xSetor:=SPACE(3)
           xResult1:=xResult2:=xResult3:=SPACE(70);xPendente:="S";xResolvido:="N"
           @ 13,04 SAY "Data.....:" GET xData    PICT "@D"   WHEN .F.
           @ 14,04 SAY "Hora.....:" GET xHora    PICT "@!"   WHEN .F.
           @ 15,04 SAY "Atendente:" GET cUsuario PICT "@!"   WHEN .F.
           @ 16,04 SAY "Prazo....:" GET xPrazo   PICT "@D"   VALID xPrazo>=xData
           @ 17,04 SAY "Retorno..:"
           @ 18,04 GET xResult1 PICT "@!"   VALID (LASTKEY()==K_UP).OR.!EMPTY(xResult1)
           @ 19,04 GET xResult2 PICT "@!"
           @ 20,04 GET xResult3 PICT "@!"
           @ 14,45 SAY "Pendente  (S/N):" GET xPendente  PICT "!" VALID (LASTKEY()==K_UP).OR.xPendente $"SN"
           @ 15,45 SAY "Resolvido (S/N):" GET xResolvido PICT "!" WHEN xPendente="N" VALID (LASTKEY()==K_UP).OR.xResolvido$"SN"
           @ 16,45 SAY "Setor(es)......:" GET xSetor     PICT "999"  WHEN HTela(15) VALID VTela(15)
           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              xHora:=SUBS(TIME(),1,5)
              @ 15,04 SAY "Hora.....:" GET xHora  PICT "@!" WHEN .F.
              CLEAR GETS
              IF Confirma("Confirma Retorno ?")
                 (cArq2)->(DBAPPEND())
                 REPLACE (cArq2)->REQ       WITH (cArq1)->REQ ,;
                         (cArq2)->DATA      WITH xData        ,;
                         (cArq2)->HORA      WITH LEFT(xHora,2)+RIGHT(xHora,2),;
                         (cArq2)->PRAZO     WITH xPrazo       ,;
                         (cArq2)->RESULT1   WITH xResult1     ,;
                         (cArq2)->RESULT2   WITH xResult2     ,;
                         (cArq2)->RESULT3   WITH xResult3     ,;
                         (cArq2)->PENDENTE  WITH xPendente    ,;
                         (cArq2)->RESOLVIDO WITH xResolvido   ,;
                         (cArq1)->ENCAM1   WITH SUBS(xSetor,1,1) ,;
                         (cArq1)->ENCAM2   WITH SUBS(xSetor,2,1) ,;
                         (cArq1)->ENCAM3   WITH SUBS(xSetor,3,1) ,;
                         (cArq2)->USER      WITH cUsuario
                 REPLACE (cArq1)->SITUACAO WITH IF((cArq2)->PENDENTE="S","3",IF((cArq2)->RESOLVIDO="S","1","2"))
                 ProcOk("Gravado",.T.); lInc:=.T.
              ENDIF
           ENDIF
           SETCOLOR(YCOREDIT); Rest_Tela()
           oBr:Refreshall()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(3)
  RETURN
