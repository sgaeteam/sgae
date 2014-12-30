*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_320                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Pagamentos Efetuados        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBALU","ALUNOS")           /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Arquivo de Pagamentos */
   SET INDEX TO DBIPAG3
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE320"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "20"
SET KEY -1 TO Mostra()
wPerIni:=wPerFim:=CTOD('')
WHILE .T.
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Perกodo de Vencimentos")
   Telas(12,20,14,55,1,YCOREDIT,.T.,"Pagamentos Efetuados")
   @ 13,22 SAY " Perกodo:" GET wPerIni PICT "@D" VALID !EMPTY(wPerIni)
   @ 13,43                 GET wPerFim PICT "@D" VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni
   @ 13,41 SAY "a"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   Mensagem()
   /* Localizar Periodo */
   PAGAR->(DBSEEK(DTOS(wPerIni),.T.))
   IF PAGAR->DTPGTO<=wPerFim
      aDbf:={}
      AADD(aDbf,{"MATR"     ,"C",   05,0})
      AADD(aDbf,{"ALUNO"    ,"C",   50,0})
      AADD(aDbf,{"DTVCTO"   ,"D",   08,0})
      AADD(aDbf,{"DTPGTO"   ,"D",   08,0})
      AADD(aDbf,{"DTINSCR"  ,"D",   08,0})
      AADD(aDbf,{"JUROS"    ,"N",   10,2})
      AADD(aDbf,{"VALOR_C"  ,"N",   10,2})
      AADD(aDbf,{"VALOR_D"  ,"N",   10,2})
      AADD(aDbf,{"VALOR_P"  ,"N",   10,2})
      AADD(aDbf,{"DOC"      ,"C",   10,0})
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
      INDEX ON DTOS(dtpgto)+aluno TO (cArq1)

      ALUNOS->(DBSETORDER(1))
      /* Alimentar arquivo temporario */
      WHILE PAGAR->DTPGTO>=wPerIni.AND.PAGAR->DTPGTO<=wPerFim.AND.!PAGAR->(EOF())
         IF !EMPTY(PAGAR->DTPGTO)
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->MATR    WITH PAGAR->MATRIC,;
                    (cArq1)->ALUNO   WITH IF(PAGAR->MATRIC=="99999",PAGAR->NOME,TAluno(PAGAR->MATRIC)),;
                    (cArq1)->DTINSCR WITH ALUNOS->DTINSCR,;
                    (cArq1)->DTVCTO  WITH PAGAR->DTVCTO,;
                    (cArq1)->DTPGTO  WITH PAGAR->DTPGTO,;
                    (cArq1)->JUROS   WITH PAGAR->JUROS,;
                    (cArq1)->VALOR_C WITH PAGAR->VALOR_C,;
                    (cArq1)->VALOR_D WITH PAGAR->VALOR_D,;
                    (cArq1)->VALOR_P WITH PAGAR->VALOR_P,;
                    (cArq1)->DOC     WITH PAGAR->DOC
         ENDIF
         PAGAR->(DBSKIP())
      ENDDO
      (cArq1)->(DBCOMMIT())
      DispPagto()

      /* Apagar Arquivo Temporario */
      DBCLOSEAREA(10)
      ERASE (cArq1)+".DBF"
      ERASE (cArq1)+".NTX"
   ELSE
      Aviso("Nฦo houve pagamento neste perกodo...",,3)
   ENDIF
   Rest_Tela()
ENDDO
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Display em Tela dos Pagamentos ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION DispPagto()
  LOCAL corant:=SETCOLOR(), oBr, oCol
  SETCOLOR(YCORGERAL); LinhaMsg(10)
  SELECT (cArq1); DBGOTOP()
  Telas(2,0,22,79,1,YCORGERAL,.F.)
  oBr:=TBROWSEDB(3,1,21,78)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Matr."     ,{|| MATR})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno"     ,{|| TRANSFORM(ALUNO,"@!S35")})
  oBr:addColumn(oCol)
* oCol:=TBCOLUMNNEW("Dt.Vcto."  ,{|| DTVCTO})
* oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Pag."   ,{|| DTPGTO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Vlr.Pago"  ,{|| TRANSFORM(VALOR_P,"@E 99,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Juros"     ,{|| TRANSFORM(JUROS,"@E 9,999.99")})
  oBr:addColumn(oCol)

  oBr:Freeze=2
   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  /* Imprimir */
         IF ChkImpr()
            (cArq1)->(DBGOTOP())
            cAviso := MsgImp()
            pg:=0; continua:=.T.
            Gera_TXT("RECEITAS.TXT")
            CabRel("PAGAMENTOS EFETUADOS")
            Compr_Off()
            @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
            Compr_On()
            @ PROW()+1,01 SAY REPLICATE("-",128)
            @ PROW()+1,02 SAY "MAT.  ALUNO                                                DT.PAGTO.    JUROS   CH/Cartao  Dinheiro   Nr. DOCUM.  TIPO"
*                              99999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX   99/99/99  9,999.99   99,999.99  99,999.99  999999999   Matricula
*                              234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                                      1         2         3         4         5         6         7         8         9        10        11        12        13
            @ PROW()+1,01 SAY REPLICATE("-",128)
            nJuros:=nValor_d:=nValor_c:=0.00
            WHILE !(cArq1)->(EOF())
               Compr_On()
               @ PROW()+1,02 SAY (cArq1)->MATR    PICT "99999"
               @ PROW()  ,08 SAY (cArq1)->ALUNO   PICT "@!S40"
               @ PROW()  ,61 SAY (cArq1)->DTPGTO  PICT "@D"
               @ PROW()  ,71 SAY (cArq1)->JUROS   PICT "@E 9,999.99"
               @ PROW()  ,82 SAY (cArq1)->VALOR_C PICT "@E 99,999.99"
               @ PROW()  ,93 SAY (cArq1)->VALOR_D PICT "@E 99,999.99"
               IF EMPTY((cArq1)->DOC).OR.SUBS((cArq1)->DOC,1,1)=="S"
                  @ PROW(),104 SAY "DINHEIRO"
               ELSEIF SUBS((cArq1)->DOC,1,1)=="A"
                  @ PROW(),104 SAY "CARTAO"
               ELSE
                  @ PROW(),104 SAY (cArq1)->DOC
               ENDIF
               IF DATE()-(cArq1)->DTINSCR<3.AND.(SUBS((cArq1)->DOC,1,1)=="A".OR.SUBS((cArq1)->DOC,1,1)=="S")
                  @ PROW(),116 SAY "Matricula"
               ELSEIF DATE()-(cArq1)->DTINSCR>=3.AND.SUBS((cArq1)->DOC,1,1)=="S"
                  @ PROW(),116 SAY "Servico"
               ELSEIF DATE()-(cArq1)->DTINSCR>=3.AND.SUBS((cArq1)->DOC,1,1)=="A"
                  @ PROW(),116 SAY "Outros"
               ELSE
                  @ PROW(),116  SAY "PRE"
               ENDIF
               nJuros   += (cArq1)->JUROS
               nValor_d += (cArq1)->VALOR_D
               nValor_c += (cArq1)->VALOR_C
               (cArq1)->(DBSKIP())
               IF PROW()>=57.AND.!EOF()
                  EJECT; CabRel("PAGAMENTOS EFETUADOS")
                  Compr_Off()
                  @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                  Compr_On()
                  @ PROW()+1,01 SAY REPLICATE("-",128)
                  @ PROW()+1,02 SAY "MAT.  ALUNO                                                DT.PAGTO.    JUROS   CH/Cartao  Dinheiro   Nr. DOCUM.  TIPO"
                  @ PROW()+1,01 SAY REPLICATE("-",128)
               ENDIF
            ENDDO
            Compr_On()
            @ PROW()+1,01 SAY REPLICATE("-",128)
            @ PROW()+1,02 SAY "T O T A L  =====>"
            @ PROW()  ,71 SAY nJuros   PICT "@E 9,999.99"
            @ PROW()  ,82 SAY nValor_c PICT "@E 99,999.99"
            @ PROW()  ,93 SAY nValor_d PICT "@E 99,999.99"
            @ PROW()+3,04 SAY "Conferido por: ___________________"
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp receitas.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE RECEITAS.TXT
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
