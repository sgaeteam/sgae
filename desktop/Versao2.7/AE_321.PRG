*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_321                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio de Pagamentos Pendentes        ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VISYS             ณ
*ณ DATA CRIACAO   : 08/01/1996                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
SELECT 3
IF NetUse("DBALU","ALUNOS")          /* Cadastro de Alunos */
   SET INDEX TO DBIALU1,DBIALU2
ELSE
   RETURN
ENDIF

SELECT 1
IF NetUse("DBPAG","PAGAR")           /* Arquivo de Pagamentos */
   SET INDEX TO DBIPAG2
ELSE
   DBCLOSEALL(); RETURN
ENDIF

ProgName("AE321"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "21"
SET KEY -1 TO Mostra()
wPerIni:=wPerFim:=CTOD('')
WHILE .T.
   SETCOLOR(YCOREDIT)
   Mensagem("Informe o Perกodo")
   Telas(12,20,14,55,1,YCOREDIT,.T.,"Pagamentos Pendentes")
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
      AADD(aDbf,{"MATRIC" ,"C", 05,0})
      AADD(aDbf,{"ALUNO"  ,"C", 50,0})
      AADD(aDbf,{"DTVCTO" ,"D", 08,0})
      AADD(aDbf,{"DOC"    ,"C", 10,0})
      AADD(aDbf,{"BANCO"  ,"C", 15,0})
      AADD(aDbf,{"VALOR_C","N", 12,2})
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
         IF EMPTY(PAGAR->DTPGTO).AND.PAGAR->DTVCTO<=wPerFim
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->MATRIC  WITH PAGAR->MATRIC,;
                    (cArq1)->ALUNO   WITH TAluno(PAGAR->MATRIC),;
                    (cArq1)->DTVCTO  WITH PAGAR->DTVCTO,;
                    (cArq1)->DOC     WITH PAGAR->DOC   ,;
                    (cArq1)->BANCO   WITH PAGAR->BANCO ,;
                    (cArq1)->VALOR_C WITH PAGAR->VALOR_C
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

  oCol:=TBCOLUMNNEW("Aluno",{|| TRANSFORM(ALUNO,"@!S35")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Dt.Vcto.",{|| DTVCTO})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Atraso",{|| TRANSFORM(IF(DATE()-DTVCTO<=0,oDia,(DATE()-DTVCTO)),"999")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Valor",{|| TRANSFORM(VALOR_C,"@E 99,999,999.99")})
  oBr:addColumn(oCol)
  oCol:=TBCOLUMNNEW("Banco",{|| BANCO})
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
            Gera_TXT("RECPEND.TXT")
            CabRel("PAGAMENTOS PENDENTES A RECEBER")
            @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
            Compr_On()
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "MAT. ALUNO                                    DT.VCTO. ATRASO Nง CH/AUT.         VALOR  BANCO"
*                              9999 XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxx 99/99/99  999   XXXXXXXXXX  9,999,999.99  XXXXXXXXXXXXXXX
*                              23456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345
*                                      1         2         3         4         5         6         7         8         9        10
            @ PROW()+1,02 SAY REPLICATE("-",100)
            nValor_c:=0.00
            WHILE !(cArq1)->(EOF())
               Compr_On()
               @ PROW()+1,02 SAY (cArq1)->MATRIC  PICT "@!"
               @ PROW()  ,07 SAY (cArq1)->ALUNO   PICT "@!S40"
               @ PROW()  ,48 SAY (cArq1)->DTVCTO  PICT "@D"
               IF (DATE()-DTVCTO) > 0
                  @ PROW()  ,58 SAY DATE()-DTVCTO PICT "999"
               ELSE
                  @ PROW()  ,58 SAY "PRE"
               ENDIF
               @ PROW()  ,64 SAY (cArq1)->DOC     PICT "@!"
               @ PROW()  ,76 SAY (cArq1)->VALOR_C PICT "@E 9,999,999.99"
               @ PROW()  ,90 SAY (cArq1)->BANCO
               nValor_c += (cArq1)->VALOR_C
               (cArq1)->(DBSKIP())
               IF PROW()>=57.AND.!EOF()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,68 SAY "Continua..."
                  EJECT; CabRel("PAGAMENTOS PENDENTES A RECEBER")
                  @ PROW()+2,02 SAY "Periodo : "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
                  Compr_On()
                  @ PROW()+1,02 SAY REPLICATE("-",100)
                  @ PROW()+1,02 SAY "MAT. ALUNO                                    DT.VCTO. ATRASO Nง CH/AUT.         VALOR  DEPOSITO"
                  @ PROW()+1,02 SAY REPLICATE("-",100)
               ENDIF
            ENDDO
            @ PROW()+1,02 SAY REPLICATE("-",100)
            @ PROW()+1,02 SAY "T O T A L  --->"
            @ PROW()  ,76 SAY nValor_c PICT "@E 9,999,999.99"
            Compr_Off()
            Fim_TXT()
            SAVESCREEN(0,0,24,79)
            RUN nodosimp recpend.txt 80 pre
            RESTSCREEN(0,0,24,79,0)
            DELETE FILE RECPEND.TXT
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressฦo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela()
  RETURN NIL
