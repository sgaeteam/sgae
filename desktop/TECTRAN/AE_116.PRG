*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_116                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Requerimentos diversos                   ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 08/08/2005                               ณ
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
AADD(aDbf,{"ASS1"       ,"C",   70,0}) /* Assunto                  */
AADD(aDbf,{"ASS2"       ,"C",   70,0}) /* Assunto                  */
AADD(aDbf,{"ASS3"       ,"C",   70,0}) /* Assunto                  */
AADD(aDbf,{"RECOM1"     ,"C",   70,0}) /* Recomendacao             */
AADD(aDbf,{"RECOM2"     ,"C",   70,0}) /* Recomendacao             */
AADD(aDbf,{"SITUACAO"   ,"C",   01,0}) /* 1-Resolvido 2-nao resolvido 3-Pendente */
AADD(aDbf,{"SETOR1"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
AADD(aDbf,{"SETOR2"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
AADD(aDbf,{"SETOR3"     ,"C",   01,0}) /* 1-Recepcao 2-Secretaria 3-Financeiro 4-Adm 5-Diretoria 6-Supervisao 9-Todos */
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
INDEX ON matric+DTOS(data)+hora TO (cArq1)

aDbf := {}
AADD(aDbf,{"REQ"        ,"C",   07,0}) /* Numero do Requerimento   */
AADD(aDbf,{"DATA"       ,"D",   08,0}) /* Data do Retorno          */
AADD(aDbf,{"HORA"       ,"C",   04,0}) /* Hora do Retorno          */
AADD(aDbf,{"USER"       ,"C",   20,0}) /* Atendente                */
AADD(aDbf,{"PRAZO"      ,"D",   08,0}) /* Prazo da ultima provid.  */
AADD(aDbf,{"RESULT1"    ,"C",   70,0}) /* Descricao do resultado   */
AADD(aDbf,{"RESULT2"    ,"C",   70,0})
AADD(aDbf,{"RESULT3"    ,"C",   70,0})
AADD(aDbf,{"SETOR"      ,"C",   01,0}) /* Setor encaminhou/resolveu */
AADD(aDbf,{"ENCAM1"     ,"C",   01,0}) /* Setor de encaminhamento   */
AADD(aDbf,{"ENCAM2"     ,"C",   01,0})
AADD(aDbf,{"ENCAM3"     ,"C",   01,0})

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

SELECT 7
IF !NetUse("DBPARM")                 /* Parametros */
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF
nReq := DBPARM->REQ

SELECT 1
IF NetUse("DBALU","ALUNO")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

SELECT 2
IF NetUse("DBREQD","REQD")           /* Detalhes de Requerimento */
   SET INDEX TO DBIREQD1
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

SELECT 3
IF NetUse("DBREQ","REQ")             /* Requerimentos */
   SET INDEX TO DBIREQ1,DBIREQ2,DBIREQ3,DBIREQ4
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

cPrg:="AE116";ProgName(cPrg); LinhaMsg(2)
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SET KEY -1 TO Mostra()
WHILE .T.
   wPerI:=wPerF:=cDtSys
   wMatr:=SPACE(5); wResp:="S";wNome:=SPACE(40)
   SETCOLOR(YCOREDIT); Telas(3,3,5,75,1,YCOREDIT,.T.,"Requerimentos")
   @ 04,05 SAY "Aluno ? (S/N)" GET wResp PICT "!" VALID wResp $ "SN"
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   SCROLL(4,5,4,35,0)
   IF wResp=="N"
      @ 04,05 SAY "Nome:" GET wNome PICT "@!" VALID !EMPTY(wNome)
   ELSE

      @ 04,05 SAY "Matrกcula:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
        VALID TDescr(1,1,4,22,wMatr,"NOME",["@S40"],"Aluno Nฦo Localizado")
   ENDIF
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF

   /* Carregar Dados para o Arq. Temporario */
   Aguarde("Lendo registros...")
   IF wResp=="N"
      REQ->(DBSETORDER(2))
      IF REQ->(DBSEEK(wNome))
         WHILE REQ->NOME==wNome
            GrvReq()
            REQ->(DBSKIP())
         ENDDO
      ENDIF
   ELSE
      REQ->(DBSETORDER(1))
      IF REQ->(DBSEEK(wMatr))
         WHILE REQ->MATRIC==wMatr
            GrvReq()
            REQ->(DBSKIP())
         ENDDO
      ENDIF
   ENDIF
   Aguarde()
   LancaMov()
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
   Rest_Tela()
ENDDO
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); DelDbfNtx2(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse de Dados - Principal    ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION LancaMov()
  LOCAL lInc:=.F.

  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(5,3,17,75,1,YCOREDIT,.T.)
  Telas(17,3,20,75,1,YCOREDIT,.T.,"Quantidades")
  Linha23("^INS^-Registra ^F7^-Histขrico",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(6,4,16,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "
  @ 18,05 SAY "Total       >"
  @ 19,05 SAY "Resolvidos  >"
*  @ 18,16 SAY nTotEnt  PICT "@E 99,999.99"
*  @ 19,16 SAY nTotSai  PICT "@E 99,999.99"
  @ 18,40 SAY "Pendentes   >"
  @ 19,40 SAY "S/Resultado >"
*  @ 18,60 SAY nSaldAnt PICT "@E 99,999.99"
*  @ 19,60 SAY nSaldo   PICT "@E 99,999.99"

  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"       ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Situaฦo"   ,{|| IF(SITUACAO="1","Ok  ",IF(SITUACAO="2","NRes",IF(SITUACAO="3","Pend",SPACE(4))))})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Atendente"  ,{|| USER})
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

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF lInc
           /* Gravar todos os resultados */
           Aguarde("Atualizando os dados...")
           REQ->(DBSETORDER(1))
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
              IF !REQ->(DBSEEK((cArq1)->REQ))
                 WHILE !REQ->(NetApp()); ENDDO
                 REPLACE REQ->MATRIC   WITH (cArq1)->MATRIC  ,;
                         REQ->REQ      WITH (cArq1)->REQ     ,;
                         REQ->DATA     WITH (cArq1)->DATA    ,;
                         REQ->HORA     WITH (cArq1)->HORA    ,;
                         REQ->USER     WITH (cArq1)->USER    ,;
                         REQ->PRAZO    WITH (cArq1)->PRAZO   ,;
                         REQ->MATRIC   WITH (cArq1)->MATRIC  ,;
                         REQ->NOME     WITH (cArq1)->NOME    ,;
                         REQ->ASS1     WITH (cArq1)->ASS1    ,;
                         REQ->ASS2     WITH (cArq1)->ASS2    ,;
                         REQ->ASS3     WITH (cArq1)->ASS3    ,;
                         REQ->RECOM1   WITH (cArq1)->RECOM1  ,;
                         REQ->RECOM2   WITH (cArq1)->RECOM2  ,;
                         REQ->SITUACAO WITH (cArq1)->SITUACAO,;
                         REQ->SETOR1   WITH (cArq1)->SETOR1  ,;
                         REQ->SETOR2   WITH (cArq1)->SETOR2  ,;
                         REQ->SETOR3   WITH (cArq1)->SETOR3
                 REQ->(DBUNLOCK()); REQ->(DBCOMMIT())
              ENDIF
              (cArq1)->(DBSKIP())
           ENDDO
           REQ->(DBSETORDER(1))
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
     ELSEIF ( tecla == K_F7 )      /* Visualizar Histขrico */
        /* Carregar Dados para o Arq. Temporario (2) */
        Aguarde("Gerando Histขrico...")
        REQD->(DBSEEK((cArq1)->REQ))
        WHILE REQD->REQ==(cArq1)->REQ
           GrvReqD()
           REQD->(DBSKIP())
        ENDDO
        Aguarde()
        ReqHist()
     ELSEIF ( tecla == K_INS )     /* Incluir requerimento */
        IF Acesso(3)
           SETCOLOR(YCOREDIT)
           xContTela:=LEN(Telas)
           Telas(9,3,21,75,1,YCOREDIT,.T.,"Inclusฦo de Requerimento")
           xData:=DATE();xHora:=SUBS(TIME(),1,5);xPrazo:=xData+2
           xAss1:=xAss2:=xAss3:=xReco1:=xReco2:=SPACE(70);xSituacao:=xSetor:=SPACE(3)
           @ 10,04 SAY "Data...:" GET xData  PICT "@D"   WHEN .F.
           @ 11,04 SAY "Hora...:" GET xHora  PICT "@!"   WHEN .F.
           @ 12,04 SAY "Setores:" GET xSetor PICT "999"  WHEN HTela(15) VALID VTela(15)
           @ 13,04 SAY "Prazo..:" GET xPrazo PICT "@D"   VALID xPrazo>=xData
           @ 14,04 SAY "Assunto:"
           @ 15,04 GET xAss1  PICT "@!"  VALID !EMPTY(xAss1)
           @ 16,04 GET xAss2  PICT "@!"
           @ 17,04 GET xAss3  PICT "@!"
           @ 18,04 SAY "Recomendaฦo:"
           @ 19,04 GET xReco1 PICT "@!"
           @ 20,04 GET xReco2 PICT "@!"

           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              xHora:=SUBS(TIME(),1,5)
              @ 11,04 SAY "Hora...:" GET xHora  PICT "@!" WHEN .F.
              CLEAR GETS
              IF Confirma("Confirma Lanamento ?")
                 // Grava nr. do requerimento
                 GravaReq()

                 (cArq1)->(DBAPPEND())
                 REPLACE (cArq1)->REQ      WITH DBPARM->REQ ,;
                         (cArq1)->DATA     WITH xData  ,;
                         (cArq1)->HORA     WITH LEFT(xHora,2)+RIGHT(xHora,2),;
                         (cArq1)->MATRIC   WITH wMatr  ,;
                         (cArq1)->NOME     WITH IF(wResp="S",ALUNO->NOME,wNome),;
                         (cArq1)->SETOR1   WITH SUBS(xSetor,1,1) ,;
                         (cArq1)->SETOR2   WITH SUBS(xSetor,2,1) ,;
                         (cArq1)->SETOR3   WITH SUBS(xSetor,3,1) ,;
                         (cArq1)->SITUACAO WITH "2"    ,;
                         (cArq1)->PRAZO    WITH xPrazo ,;
                         (cArq1)->ASS1     WITH xAss1  ,;
                         (cArq1)->ASS2     WITH xAss2  ,;
                         (cArq1)->ASS3     WITH xAss3  ,;
                         (cArq1)->RECOM1   WITH xReco1 ,;
                         (cArq1)->RECOM2   WITH xReco2 ,;
                         (cArq1)->USER     WITH cUsuario
                 ProcOk("Incluกdo",.T.); lInc:=.T.
*                nPend++
              ENDIF
           ENDIF
           xContTela:= LEN(Telas)-xContTela
           SETCOLOR(YCOREDIT); Rest_Tela(xContTela); (cArq1)->(DBGOTOP())
*          @ 18,16 SAY nTotEnt  PICT "@E 99,999.99"
*          @ 19,16 SAY nTotSai  PICT "@E 99,999.99"
*          @ 19,60 SAY nSaldo   PICT "@E 99,999.99"
           oBr:Refreshall()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela(2)
  RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse de Dados - Auxiliar     ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ReqHist()
  LOCAL lInc:=.F.

  SELECT (cArq2); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(5,3,20,75,1,YCOREDIT,.T.)
  Linha23("^ENTER^-Detalhes",24)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(6,4,19,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Data"       ,{|| DATA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Hora"       ,{|| TRANSFORM(HORA,"@R 99:99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Prazo"      ,{|| PRAZO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Atendente"  ,{|| USER})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Retorno"    ,{|| RESULT1})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Retorno (Continuaฦo 1)"   ,{|| RESULT2})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Retorno (Continuaฦo 2)"   ,{|| RESULT3})
  oBr:addColumn(oCol)

  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
