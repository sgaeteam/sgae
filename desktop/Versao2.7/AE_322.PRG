*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_322                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Cheques Recebidos           ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 04/02/2003                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   RETURN
ENDIF

SELECT 5
IF NetUse("DBCX","CAIXA")            /* Arquivo de Caixa */
   SET INDEX TO DBICX3
ELSE
   DelDbfNtx(); RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Arquivo de Pagamentos */
   SET INDEX TO DBIPAG2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE322"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "22"
SET KEY -1 TO Mostra()
wPerIni:=wPerFim:=CTOD('')
WHILE .T.
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Perกodo")
   Telas(12,20,14,55,1,YCOREDIT,.T.,"Cheques Recebidos")
   @ 13,22 SAY " Perกodo:" GET wPerIni PICT "@D" VALID !EMPTY(wPerIni)
   @ 13,43                 GET wPerFim PICT "@D" VALID (LASTKEY()==K_UP).OR.wPerFim>=wPerIni
   @ 13,41 SAY "a"
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()==K_ESC; Rest_Tela(); EXIT; ENDIF
   Mensagem()
   /* Localizar Periodo */
   PAGAR->(DBSEEK(DTOS(wPerIni),.T.))
   IF PAGAR->DTVCTO<=wPerFim
      aDbf:={}
      AADD(aDbf,{"MATRIC"  ,"C", 05,0})
      AADD(aDbf,{"ALUNO"   ,"C", 50,0})
      AADD(aDbf,{"DTVCTO"  ,"D", 08,0})
      AADD(aDbf,{"DOC"     ,"C", 10,0})
      AADD(aDbf,{"BANCO"   ,"C", 15,0})
      AADD(aDbf,{"VALOR_C" ,"N", 12,2})
      AADD(aDbf,{"DESTINO" ,"C", 40,0})
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
      INDEX ON DTOS(dtvcto) TO (cArq1)

      ALUNOS->(DBSETORDER(1))
      /* Alimentar arquivo temporario */
      WHILE PAGAR->DTVCTO>=wPerIni.AND.PAGAR->DTVCTO<=wPerFim.AND.!PAGAR->(EOF())
         IF CAIXA->(DBSEEK(PAGAR->NLAN))
            IF EMPTY(CAIXA->OK).AND.PAGAR->VALOR_C>0.00.AND.SUBS(CAIXA->DOC,1,1)#"A"
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->MATRIC  WITH PAGAR->MATRIC,;
                       (cArq1)->ALUNO   WITH TAluno(PAGAR->MATRIC),;
                       (cArq1)->DTVCTO  WITH PAGAR->DTVCTO,;
                       (cArq1)->DOC     WITH PAGAR->DOC   ,;
                       (cArq1)->BANCO   WITH PAGAR->BANCO ,;
                       (cArq1)->VALOR_C WITH PAGAR->VALOR_C
            ENDIF
         ENDIF
         PAGAR->(DBSKIP())
      ENDDO
      (cArq1)->(DBCOMMIT()); (cArq1)->(DBGOTOP())
      IF !(cArq1)->(EOF())
         DispPagto()
      ELSE
         Aviso("Nฦo h  pendncia de Pagamento...",,3)
      ENDIF

      /* Apagar Arquivo Temporario */
      DBCLOSEAREA(10)
      ERASE (cArq1)+".DBF"
      ERASE (cArq1)+".NTX"
   ENDIF
   Rest_Tela()
ENDDO
DBCLOSEALL(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Display em Tela dos Pagamentos ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION DispPagto()
  LOCAL corant:=SETCOLOR(), oBr, oCol, oDia:=0
  SETCOLOR(YCORGERAL); LinhaMsg(10)
  SELECT (cArq1); DBGOTOP()
  Telas(2,0,22,79,1,YCORGERAL,.F.)
  oBr:=TBROWSEDB(3,1,21,78)
  oBr:headSep:="ฤยฤ"
  oBr:colSep:= " ณ "

  oCol:=TBCOLUMNNEW("Dt.Vcto.",{|| DTVCTO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Aluno",{|| TRANSFORM(ALUNO,"@!S25")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR_C,"@E 9,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Nง CH",{|| DOC})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Banco",{|| TRANSFORM(BANCO,"@S10")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Destino",{|| DESTINO})
  oBr:addColumn(oCol)

  oBr:Freeze=1
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
            Gera_TXT("RECCH.TXT")
            CabRel("CHEQUES RECEBIDOS")
            @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
            Compr_On()
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
*                              XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/9999 XXXXXXXXXX  9,999.99  XXXXXXXXXXXXXXX _____________
*                              23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*                                      1         2         3         4         5         6         7         8         9        10
            @ PROW()+1,02 SAY REPLICATE("-",100)
            nValor_c:=0.00
            WHILE !(cArq1)->(EOF())
               Compr_On()
               @ PROW()+1,02 SAY (cArq1)->ALUNO   PICT "@!S40"
               @ PROW()  ,43 SAY (cArq1)->DTVCTO  PICT "@D"
               @ PROW()  ,54 SAY (cArq1)->DOC     PICT "@!"
               @ PROW()  ,66 SAY (cArq1)->VALOR_C PICT "@E 9,999.99"
               @ PROW()  ,76 SAY (cArq1)->BANCO
               @ PROW()  ,92 SAY REPLIC("_",15)
               nValor_c += (cArq1)->VALOR_C
               (cArq1)->(DBSKIP())
               IF PROW()>=57.AND.!EOF()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,68 SAY "Continua..."
                  EJECT; CabRel("CHEQUES RECEBIDOS")
                  @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                  Compr_On()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,02 SAY "ALUNO                                    DATA VCTO. Nง CH/AUT.     VALOR  BANCO           DESTINO"
                  @ PROW()+1,02 SAY REPLICATE("-",100)
               ENDIF
            ENDDO
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "T O T A L  --->"
            @ PROW()  ,65 SAY nValor_c PICT "@E 99,999.99"
            Compr_Off()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp recch.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE RECCH.TXT
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
