*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_362                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Relatorio pesquisa de automovel          ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 20/04/2005                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"

DBCLOSEALL()
// Gerar Arquivo Temporario
aDbf:={}
AADD(aDbf,{"NOME"    ,"C", 50,0})
AADD(aDbf,{"FONE_R"  ,"C", 10,0})
AADD(aDbf,{"FONE_C"  ,"C", 10,0})
AADD(aDbf,{"CELULAR" ,"C", 08,0})
AADD(aDbf,{"ENDERECO","C", 50,0})
AADD(aDbf,{"BAIRRO"  ,"C", 20,0})
AADD(aDbf,{"CIDADE"  ,"C", 30,0})
AADD(aDbf,{"UF"      ,"C", 02,0})
AADD(aDbf,{"CEP"     ,"C", 08,0})
AADD(aDbf,{"EMAIL"   ,"C", 30,0})
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
INDEX ON NOME TO (cArq1)

SELECT 1
IF NetUse("DBALU","ALUNO")         /* Cadastro de Alunos */
   SET INDEX TO DBIALU3           // data de inscricao
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE362";ProgName("AE362"); LinhaMsg(2)
cOpHelp1 := "3"; cOpHelp2 := "62"
msg1:="^ESC^-Sair"
vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)

WHILE .T.
   Telas(4,3,19,76,1,YCOREDIT,.T.,"Pesquisa - Automขvel")
   wPerIni:=wPerFim:=CTOD("");wAuto:=" "
   v1:=v2:=v3:=v4:=vtot:=0
   SETCOLOR(YCOREDIT)
   @ 05,05 SAY "*** Matrกcula ***"
   @ 06,05 SAY "Data Inicial.:" GET wPerIni PICT "@D" WHEN TeclaFuncao() VALID LASTKEY()==K_UP.OR.!EMPTY(wPerIni)
   @ 07,05 SAY "Data Final...:" GET wPerFim PICT "@D" VALID LASTKEY()==K_UP.OR.wPerFim>=wPerIni.AND.wPerFim<=DATE()
   @ 08,05 SAY "Item Pesquisa:" GET wAuto   PICT "9"  WHEN HTela(13) VALID IF(LASTKEY()==K_UP,Let(Rest_Tela()),.F.).OR.VTela(13)
   @ 09,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 10,05 SAY "Alunos:"
   @ 11,05 SAY "฿฿฿฿฿฿฿"
   @ 12,05 SAY "     1. Com e-mail............>"
   @ 13,05 SAY "     2. Com fone residencial..>"
   @ 14,05 SAY "     3. Com fone comercial....>"
   @ 15,05 SAY "     4. Com celular...........>"
   @ 16,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 17,05 SAY "     5. TOTAL.................>"
   SETCURSOR(1); READ; SETCURSOR(0)
   IF LASTKEY()==K_ESC; EXIT; ENDIF

   Aguarde("Selecionando...")
   ALUNO->(DBSEEK(wPerIni))
   IF ALUNO->(EOF()); ALUNO->(DBGOTOP()); ENDIF
   WHILE !ALUNO->(EOF())
      IF ALUNO->DTINSCR>=wPerIni.AND.ALUNO->DTINSCR<=wPerFim
         IF ALUNO->AUTO==wAuto
            (cArq1)->(DBAPPEND())
            REPLACE (cArq1)->NOME     WITH ALUNO->NOME      ,;
                    (cArq1)->FONE_R   WITH ALUNO->FONE_R    ,;
                    (cArq1)->FONE_C   WITH ALUNO->FONE_C    ,;
                    (cArq1)->CELULAR  WITH ALUNO->CELULAR   ,;
                    (cArq1)->ENDERECO WITH ALUNO->ENDERECO  ,;
                    (cArq1)->BAIRRO   WITH ALUNO->BAIRRO    ,;
                    (cArq1)->CIDADE   WITH ALUNO->CIDADE    ,;
                    (cArq1)->UF       WITH ALUNO->UF        ,;
                    (cArq1)->CEP      WITH ALUNO->CEP       ,;
                    (cArq1)->EMAIL    WITH ALUNO->EMAIL
            (cArq1)->(DBCOMMIT())

            IF !EMPTY(ALUNO->EMAIL)
               ++v1  // com email
            ENDIF
            IF !EMPTY(ALUNO->FONE_R)
               ++v2  // com telefone residencial
            ENDIF
            IF !EMPTY(ALUNO->FONE_C)
               ++v3  // com telefone comercial
            ENDIF
            IF !EMPTY(ALUNO->CELULAR)
               ++v4  // com telefone celular
            ENDIF
            ++vtot
         ENDIF
      ENDIF
      ALUNO->(DBSKIP())
   ENDDO
   Aguarde()

   @ 12,38 SAY v1   PICT "@E 99,999"
   @ 13,38 SAY v2   PICT "@E 99,999"
   @ 14,38 SAY v3   PICT "@E 99,999"
   @ 15,38 SAY v4   PICT "@E 99,999"
   @ 17,38 SAY vTot PICT "@E 99,999"
   INKEY(0)

   (cArq1)->(DBGOTOP())
   BrowLista()
   (cArq1)->(__DBZAP())
   Rest_Tela()
ENDDO
Rest_Tela()
RESTSCREEN(2,0,24,79,vTela)
DelDbfNtx(); RETURN
*ีออออออออออออออออออออออออออออออออธ
*ณ Browse do Extrato              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION BrowLista()
   LOCAL corant:=SETCOLOR(), oBr, oColn,nreg, nSdAntes:=0.00

   SELECT (cArq1); DBGOTOP()
   IF EOF()
      Aviso("Nao houveram matriculas neste perกodo..."); RETURN .F.
   ENDIF

   LinhaMsg(10)
   Telas(2,0,5,79,1,YCOREDIT,.F.)
   @ 03,02 SAY "Alunos Selecionados ("+cPesq()+")"
   @ 04,02 SAY "Perกodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   Telas(5,0,22,79,1,YCOREDIT,.F.,"Alunos")
   oBr:=TBROWSEDB(6,1,21,78)
   oBr:headSep:="ฤยฤ"
   oBr:colSep:= " ณ "
   oBr:colorspec = YCOREDIT

   oCol:=TBCOLUMNNEW("Nome"      ,{|| TRANSFORM(NOME,"@S30")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Res"  ,{|| TRANSFORM(FONE_R,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Fone Coml" ,{|| TRANSFORM(FONE_C,"@R (99) 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Celular"   ,{|| TRANSFORM(CELULAR,"@R 9999-9999")})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("e-mail"    ,{|| LOWER(EMAIL)})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Endereo"  ,{|| ENDERECO})
   oBr:addColumn(oCol)

   WHILE .T.
     WHILE NEXTKEY()=0 .AND. !(oBr:stabilize()); ENDDO
     tecla := INKEY()
     IF ( tecla == K_ESC )
        EXIT
     ELSEIF ( tecla == K_F1 )
        Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
     ELSEIF ( tecla == K_F4 )
        Calculadora(calc_lin,calc_col,YCORMENU)
     ELSEIF ( tecla == K_F5 )
        Calendary(@cale_lin,@cale_col,@m_date)
     ELSEIF ( tecla == K_F9 )
        IF ChkImpr()
           cAviso := MsgImp()
           ImpExtrato()
           TiraMsgImp(cAviso)
           WaitMsg("Fim de Impresso, tecle algo...")
           Mensagem()
        ENDIF
     ELSEIF ( tecla == K_F2 )
        Ajuda()
     ELSE
        ProcKey(oBr,tecla)
     ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(2)
  RETURN NIL
*ีออออออออออออออออออออออออออออออออธ
*ณ Grupo de pesquisa              ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION cPesq()
  IF wAuto=="1"
     cTexto:="Tem carro com seguro"
  ENDIF
  IF wAuto=="2"
     cTexto:="Tem carro sem seguro"
  ENDIF
  IF wAuto=="3"
     cTexto:="Nฦo tem carro, quer comprar"
  ENDIF
  IF wAuto=="4"
     cTexto:="Nฦo tem carro, nฦo pode comprar"
  ENDIF
  IF wAuto=="5"
     cTexto:="Tem carro, mas quer trocar"
  ENDIF
  RETURN(cTexto)
*ีออออออออออออออออออออออออออออออออธ
*ณ Imprimir Extrato               ณ
*ิออออออออออออออออออออออออออออออออพ
STATIC FUNCTION ImpExtrato()
   LOCAL nReg:=RECNO()
   Gera_TXT("PESQAUTO.TXT"); SETPRC(0,0)
   SELECT (cArq1); DBGOTOP()
   pg:=0; continua:=.T.
   CabRel("LISTAGEM DE MATRICULA POR MEIO DE PROCURA")
   @ PROW()+1,02 SAY "Periodo: "+DTOC(wPerIni)+" a "+DTOC(wPerFim)
   @ PROW()+1,02 SAY REPLICATE("-",78)
   @ PROW()+1,02 SAY "ORIGEM           QTDE       %"
*                     XXXXXXXXXXXXXXX  99.999   999.99
*                     234567890123456789012345678901234567890123456789012345678901234567890123456789
*                             1         2         3         4         5         6         7
   @ PROW()+1,02 SAY REPLICATE("-",78); ntotal:=0
   WHILE continua.AND.!EOF()
      @ PROW()+1,02 SAY ORIGEM   PICT "@!"
      @ PROW()  ,19 SAY QTDE     PICT "@E 99,999"
      @ PROW()  ,28 SAY FATIA    PICT "@E 999.99"
      ntotal += QTDE
      DBSKIP()
   ENDDO
   IF continua
      @ PROW()+1,02 SAY REPLICATE("-",78)
      @ PROW()+1,05 SAY "TOTAL >> "
      @ PROW()  ,19 SAY ntotal  PICT "@E 99,999"
      EJECT
   ENDIF
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp pesqauto.txt 80 pre
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE PQESQAUTO.TXT
   GO nReg
   RETURN NIL
