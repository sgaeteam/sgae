*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_240                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Pagamento de aulas e servicos            ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

SET DELE ON
DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"NLAN"     ,"C",   12,0})   /* Numero do Lancamento         */
AADD(aDbf,{"PARCELA"  ,"C",   02,0})
AADD(aDbf,{"DTVCTO"   ,"D",   08,0})
AADD(aDbf,{"DTPGTO"   ,"D",   08,0})
AADD(aDbf,{"DTPGANT"  ,"D",   08,0})
AADD(aDbf,{"OK"       ,"C",   02,0})
AADD(aDbf,{"VALOR_P"  ,"N",   08,2})
AADD(aDbf,{"VALOR_D"  ,"N",   08,2})
AADD(aDbf,{"VALOR_C"  ,"N",   08,2})
AADD(aDbf,{"DOC"      ,"C",   10,0})
AADD(aDbf,{"BANCO"    ,"C",   15,0})
AADD(aDbf,{"TITULAR"  ,"C",   25,0})
AADD(aDbf,{"OBS1"     ,"C",   67,0})
AADD(aDbf,{"OBS2"     ,"C",   50,0})
AADD(aDbf,{"SERVICO"  ,"C",   50,0})
AADD(aDbf,{"DTFAVOR"  ,"D",   08,0})
AADD(aDbf,{"FAVOR"    ,"C",   25,0})
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
INDEX ON DTOS(DTVCTO) TO (cArq1)

SELECT 6
IF NetUse("DBPEND","PENDENCIA")      /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 7
IF !NetUse("DBPARM")                 /* Parametros */
   DelDbfNtx(); RETURN
ENDIF
* nNlan := DBPARM->NLAN

SELECT 5
IF NetUse("DBCX","CAIXA")            /* Caixa */
   SET INDEX TO DBICX2,DBICX1,DBICX3,DBICX4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 3
IF NetUse("DBALU","ALUNO")           /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Pagamentos de Alunos */
   SET INDEX TO DBIPAG1,DBIPAG2,DBIPAG3,DBIPAG4
ELSE
   DelDbfNtx(); RETURN
ENDIF

cPrg:="AE240"; ProgName(cPrg); LinhaMsg(2)
cOpHelp1 := "2"; cOpHelp2 := "40"
SET KEY -1 TO Mostra()
wData:=CTOD(""); wMatr:=SPACE(5)
*WHILE .T.
   SETCOLOR(YCOREDIT)
   Telas(4,3,6,75,1,YCOREDIT,.T.,"Pagamento de Aulas")
   Mensagem("Informe Matrกcula do Aluno")
   @ 05,05 SAY "Matrกcula:" GET wMatr PICT "99999" WHEN TeclaFuncao(.T.);
     VALID TDescr(3,1,5,22,wMatr,"NOME",["@S40"],"Aluno Nฦo Localizado")
   SETCURSOR(1); READ; SETCURSOR(0)

   TeclaFuncao()
   IF LASTKEY()==K_ESC
      SETKEY(K_F2,NIL); Rest_Tela()
      DelDbfNtx(); RETURN
   ENDIF
   ChkPend(wMatr)  // Verifica pendencia

   IF PAGAR->(DBSEEK(wMatr))
      /* Alimentar o Arquivo Temporario */
      WHILE PAGAR->MATRIC==wMatr.AND.!PAGAR->(EOF())
         (cArq1)->(DBAPPEND())
         REPLACE (cArq1)->NLAN     WITH PAGAR->NLAN    ,;
                 (cArq1)->PARCELA  WITH PAGAR->PARCELA ,;
                 (cArq1)->DTVCTO   WITH PAGAR->DTVCTO  ,;
                 (cArq1)->DTPGTO   WITH PAGAR->DTPGTO  ,;
                 (cArq1)->DTPGANT  WITH PAGAR->DTPGTO  ,;
                 (cArq1)->OK       WITH PAGAR->OK      ,;
                 (cArq1)->VALOR_P  WITH PAGAR->VALOR_P ,;
                 (cArq1)->VALOR_D  WITH PAGAR->VALOR_D ,;
                 (cArq1)->VALOR_C  WITH PAGAR->VALOR_C ,;
                 (cArq1)->DOC      WITH PAGAR->DOC     ,;
                 (cArq1)->BANCO    WITH PAGAR->BANCO   ,;
                 (cArq1)->TITULAR  WITH PAGAR->TITULAR ,;
                 (cArq1)->DTFAVOR  WITH PAGAR->DTFAVOR ,;
                 (cArq1)->FAVOR    WITH PAGAR->FAVOR   ,;
                 (cArq1)->SERVICO  WITH PAGAR->SERVICO ,;
                 (cArq1)->OBS1     WITH PAGAR->OBS1    ,;
                 (cArq1)->OBS2     WITH PAGAR->OBS2
         PAGAR->(DBSKIP())
      ENDDO
      LinhaMsg(9)
      Pagto()
   ELSE
      Aviso("Nฦo houve parcelamento no pagamento deste aluno...",,3)
      IF Confirma("Deseja registrar Pagamento ?")
         LinhaMsg(9)
         Pagto()
      ENDIF
   ENDIF
   (cArq1)->(__DBZAP())  /* Limpar o arquivo temporario */
*  Rest_Tela()
*ENDDO
SETKEY(K_F2,NIL); Rest_Tela()
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Programaฦo de Pagamentos      ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION Pagto()
  LOCAL lMudou:=.F., lInclui:=.F.

  SELECT (cArq1); DBGOTOP()
  SETCOLOR(YCOREDIT)
  Telas(6,3,19,75,1,YCOREDIT,.T.)
  msg := Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar")

  oBr:=TBROWSEDB(7,4,18,74)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Pendncias"  ,{|| TRANSFORM(OBS2,"@30")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Lib"         ,{|| OK})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Par"         ,{|| PARCELA})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Servios"    ,{|| TRANSFORM(SERVICO,"@S45")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Vlr.Pago"    ,{|| TRANSFORM(VALOR_P,"@E 9,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Vcto."       ,{|| DTVCTO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Nง CH/Aut."  ,{|| DOC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Banco"       ,{|| TRANSFORM(BANCO,"@S10")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Pagto."      ,{|| DTPGTO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Titular"     ,{|| TRANSFORM(TITULAR,"@S15")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Observaไes" ,{|| TRANSFORM(OBS1,"@S35")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Data Saกda"  ,{|| DTFAVOR})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Favorecido"  ,{|| FAVOR})
  oBr:addColumn(oCol)

* oBr:Freeze=1
  WHILE .T.
     WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        IF lMudou.AND.Confirma("Confirma Lanamentos ?")
           (cArq1)->(DBGOTOP())
           WHILE !(cArq1)->(EOF())
              /* Atualizacao do movimento de caixa */
              PAGAR->(DBSETORDER(4))
              IF !PAGAR->(DBSEEK((cArq1)->NLAN))
                 IF lInclui
                    GravaLan()
                    xNLan:=DBPARM->NLAN

                    WHILE !CAIXA->(NetApp()); ENDDO
                    REPLACE CAIXA->NLAN   WITH xNLAN            ,;
                            CAIXA->DOC    WITH (cArq1)->DOC     ,;
                            CAIXA->BANCO  WITH (cArq1)->BANCO   ,;
                            CAIXA->MATRIC WITH wMatr            ,;
                            CAIXA->HIST   WITH ALUNO->NOME      ,;
                            CAIXA->TIPO   WITH "C"              ,;
                            CAIXA->DATA   WITH cDtSys           ,;
                            CAIXA->OBS1   WITH (cArq1)->OBS1    ,;
                            CAIXA->USER   WITH cUsuario

                    WHILE !PAGAR->(NetApp()); ENDDO
                    REPLACE PAGAR->NLAN    WITH xNLAN            ,;
                            PAGAR->MATRIC  WITH wMatr            ,;
                            PAGAR->PARCELA WITH (cArq1)->PARCELA ,;
                            PAGAR->DTPGTO  WITH (cArq1)->DTPGTO  ,;
                            PAGAR->DTVCTO  WITH (cArq1)->DTVCTO  ,;
                            PAGAR->OK      WITH (cArq1)->OK      ,;
                            PAGAR->VALOR_P WITH (cArq1)->VALOR_P ,;
                            PAGAR->VALOR_C WITH (cArq1)->VALOR_C ,;
                            PAGAR->VALOR_D WITH (cArq1)->VALOR_D ,;
                            PAGAR->BANCO   WITH (cArq1)->BANCO   ,;
                            PAGAR->DOC     WITH (cArq1)->DOC     ,;
                            PAGAR->TITULAR WITH (cArq1)->TITULAR ,;
                            PAGAR->DTFAVOR WITH (cArq1)->DTFAVOR ,;
                            PAGAR->FAVOR   WITH (cArq1)->FAVOR   ,;
                            PAGAR->SERVICO WITH (cArq1)->SERVICO ,;
                            PAGAR->OBS1    WITH (cArq1)->OBS1    ,;
                            PAGAR->OBS2    WITH (cArq1)->OBS2
                    PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())
                 ENDIF
              ELSE
                 WHILE !PAGAR->(NetlReg()); ENDDO
                 REPLACE PAGAR->DTPGTO  WITH (cArq1)->DTPGTO  ,;
                         PAGAR->PARCELA WITH (cArq1)->PARCELA ,;
                         PAGAR->DTPGTO  WITH (cArq1)->DTPGTO  ,;
                         PAGAR->DTVCTO  WITH (cArq1)->DTVCTO  ,;
                         PAGAR->OK      WITH (cArq1)->OK      ,;
                         PAGAR->VALOR_P WITH (cArq1)->VALOR_P ,;
                         PAGAR->VALOR_C WITH (cArq1)->VALOR_C ,;
                         PAGAR->VALOR_D WITH (cArq1)->VALOR_D ,;
                         PAGAR->BANCO   WITH (cArq1)->BANCO   ,;
                         PAGAR->DOC     WITH (cArq1)->DOC     ,;
                         PAGAR->TITULAR WITH (cArq1)->TITULAR ,;
                         PAGAR->DTFAVOR WITH (cArq1)->DTFAVOR ,;
                         PAGAR->FAVOR   WITH (cArq1)->FAVOR   ,;
                         PAGAR->SERVICO WITH (cArq1)->SERVICO ,;
                         PAGAR->OBS1    WITH (cArq1)->OBS1    ,;
                         PAGAR->OBS2    WITH (cArq1)->OBS2
                 PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())

                 /* Procurar mov. de caixa para alteracao de data e valor */
                 CAIXA->(DBSETORDER(3))
                 CAIXA->(DBSEEK((cArq1)->NLAN))
                 WHILE !CAIXA->(NetlReg()); ENDDO
              ENDIF
              REPLACE CAIXA->DTMOV WITH (cArq1)->DTPGTO,;
                      CAIXA->VALOR WITH (cArq1)->VALOR_P,;
                      CAIXA->OK    WITH "Pg",;
                      CAIXA->OBS1  WITH (cArq1)->OBS1
              CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
              PAGAR->(DBSETORDER(1))
              CAIXA->(DBSETORDER(1))
              (cArq1)->(DBSKIP())
           ENDDO
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
     ELSEIF ( tecla == K_DEL ) /* Excluir Pagamento */
        IF (cArq1)->(EOF()).OR.(cArq1)->(BOF())
           Aviso("Nao h  registro a ser eliminado...",,3)
        ELSE
           IF Acesso(9).AND.Confirma("Confirma Exclusฦo ?")
              PAGAR->(DBSETORDER(4))
              IF PAGAR->(DBSEEK((cArq1)->NLAN))
                 WHILE !PAGAR->(NetLReg()); ENDDO
                 PAGAR->(DBDELETE()); PAGAR->(DBUNLOCK()); PAGAR->(DBCOMMIT())

                 /* Eliminar no Movimento de Caixa */
                 IF CAIXA->(DBSEEK(wMatr+"C"+DTOS((cArq1)->DTVCTO)))
                    WHILE !CAIXA->(NetLReg()); ENDDO
                    CAIXA->(DBDELETE()); CAIXA->(DBUNLOCK()); CAIXA->(DBCOMMIT())
                 ENDIF
                 (cArq1)->(DBDELETE()); (cArq1)->(DBGOTOP())
                 ProcOk("Excluido!",.T.)
                 oBr:refreshall(); oBr:down()
              ELSE
                 Aviso("Arquivo Corrompido-Informe Suporte * Registro Mantido!")
              ENDIF
           ENDIF
        ENDIF
     ELSEIF ( tecla == K_INS )   /* Inclui Pagamento */
        IF Acesso(5)
           Telas(8,3,20,55,1,YCOREDIT,.T.)
           wDtPgto :=(cArq1)->DTPGTO; wDtVcto :=(cArq1)->DTVCTO
           wValor_D:=(cArq1)->VALOR_D; wValor_C:=(cArq1)->VALOR_C; wValor_P:=(cArq1)->VALOR_P
           wParcela:=0; wDoc:=SPACE(10); wOBS1:=SPACE(50); wBanco:=SPACE(15)
           @ 09,05 SAY "Nง Parcela....:" GET wParcela PICT "99" VALID !EMPTY(wParcela)
           @ 10,05 SAY "Dt. Vencimento:" GET wDtVcto  PICT "@D"
           @ 11,05 SAY "Dt. Pagamento.:" GET wDtPgto  PICT "@D"
           @ 14,05 SAY "Vlr. Dinheiro.." GET wValor_D PICT "@E 9,999,999.99" ;
             VALID Let(wValor_P:=wValor_D+wValor_C).AND.DispTot()
           @ 15,05 SAY "Vlr. Cheque...:" GET wValor_C PICT "@E 9,999,999.99" ;
             VALID Let(wValor_P:=wValor_D+wValor_C).AND.DispTot()
           @ 16,05 SAY "N๘ documento..:" GET wDoc     PICT "@!" WHEN !EMPTY(wValor_C)
           @ 17,05 SAY "Banco.........:" GET wBanco   PICT "@!S30" WHEN !EMPTY(wValor_C)
           @ 18,05 SAY "Observaไes...:" GET wOBS1    PICT "@!S30"
           @ 19,05 SAY "Vlr.TOTAL PAGO:" GET wValor_P PICT "@E 9,999,999.99" WHEN .F.
           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              IF Confirma("Confirma Inclusฦo ?")
                 (cArq1)->(DBAPPEND())
                 REPLACE (cArq1)->PARCELA WITH STRZERO(wParcela,2),;
                         (cArq1)->DTPGTO  WITH wDtPgto,;
                         (cArq1)->DTPGANT WITH wDtPgto,;
                         (cArq1)->DTVCTO  WITH wDtVcto,;
                         (cArq1)->VALOR_P WITH IF(EMPTY(wDtPgto),0.00,wValor_P),;
                         (cArq1)->VALOR_D WITH wValor_D,;
                         (cArq1)->VALOR_C WITH wValor_C,;
                         (cArq1)->DOC     WITH wDoc,;
                         (cArq1)->BANCO   WITH wBanco,;
                         (cArq1)->OBS1    WITH wOBS1
                 (cArq1)->(DBCOMMIT())
                 oBr:refreshall(); lMudou:=.T.; lInclui:=.T.
              ENDIF
           ENDIF
           Rest_Tela()
        ENDIF
     ELSEIF ( tecla == K_ENTER ) /* Altera Pagamento */
        IF Acesso(5)
           Telas(9,3,20,55,1,YCOREDIT,.T.)
           wDtPgto :=(cArq1)->DTPGTO;  wDtVcto :=(cArq1)->DTVCTO;  wObs1:=(cArq1)->OBS1
           wValor_D:=(cArq1)->VALOR_D; wValor_C:=(cArq1)->VALOR_C; wValor_P:=(cArq1)->VALOR_P
           wFavor  :=(cArq1)->FAVOR;   wDtFavor:=(cArq1)->DTFAVOR; wObs2:=(cArq1)->OBS2
           wServico:=(cArq1)->SERVICO
           @ 10,05 SAY "Dt. Vencimento:" GET wDtVcto  PICT "@D" WHEN .F.
           @ 11,05 SAY "Dt. Pagamento.:" GET wDtPgto  PICT "@D"
           @ 12,05 SAY "Vlr. Dinheiro.:" GET wValor_D PICT "@E 9,999,999.99" WHEN nNivel=9.OR.!EMPTY(wDtPgto);
             VALID Let(wValor_P:=wValor_D+wValor_C).AND.DispTot()
           @ 13,05 SAY "Vlr. Cheque...:" GET wValor_C PICT "@E 9,999,999.99" WHEN nNivel=9.OR.!EMPTY(wDtPgto);
             VALID Let(wValor_P:=wValor_D+wValor_C).AND.DispTot()
           @ 13,35 SAY "Entrega:"        GET wDtFavor PICT "@D"
           @ 14,05 SAY "Favorecido....:" GET wFavor   PICT "@!"
           @ 15,05 SAY "Servio.......:" GET wServico PICT "@!S33"
           @ 16,05 SAY "Pendncia.....:" GET wObs2    PICT "@!S33"
           @ 17,05 SAY "Observaไes...:" GET wObs1    PICT "@!S33"
           @ 18,03 SAY "ร"+REPL("ฤ",51)+"ด"
           @ 19,05 SAY "Valor TOTAL   :" GET wValor_P PICT "@E 9,999,999.99" WHEN .F.
           SETCURSOR(1); READ; SETCURSOR(0)
           IF LASTKEY()#K_ESC
              IF Confirma(IF(EMPTY(wDtPgto),"Confirma Cancelamento do Pagamento ?","Confirma Pagamento ?"))
                 REPLACE (cArq1)->DTPGTO   WITH wDtPgto,;
                         (cArq1)->DTFAVOR  WITH wDtFavor,;
                         (cArq1)->FAVOR    WITH wFavor,;
                         (cArq1)->OBS1     WITH wObs1,;
                         (cArq1)->OBS2     WITH wObs2,;
                         (cArq1)->SERVICO  WITH wServico,;
                         (cArq1)->OK       WITH IF(EMPTY(wDtPgto),"  ","Pg"),;
                         (cArq1)->VALOR_P  WITH IF(EMPTY(wDtPgto),0.00,wValor_P),;
                         (cArq1)->VALOR_D  WITH wValor_D,;
                         (cArq1)->VALOR_C  WITH wValor_C
                 (cArq1)->(DBCOMMIT())
                 oBr:refreshall(); lMudou:=.T.
              ENDIF
           ENDIF
           Rest_Tela()
        ENDIF
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  Rest_Tela()
  RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Display do Total               ณ
*ิออออออออออออออออออออออออออออออออพ
FUNCTION DispTot()
   @ 19,21 SAY wValor_P PICT "@E 9,999,999.99"
   RETURN .T.
