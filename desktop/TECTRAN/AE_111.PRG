*ีอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออธ
*ณ PROGRAMA       : AE_111                           vrs 001 ณ
*ณ VRS 001        : Implantacao                              ณ
*ณ FINALIDADE     : Registro de Certificados de Alunos       ณ
*ณ PROGRAMADOR    : VITOR A.SMITH FREIRE - VIRTUAL           ณ
*ณ DATA CRIACAO   : 04/05/2001                               ณ
*ิอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออพ
#include "INKEY.CH"
#include "COMMAND.CH"

LOCAL corant:=SETCOLOR(), oBr, oCol, vTela, oBr1, oCol1, vTela2

DBCLOSEALL()
SELECT 6
IF NetUse("DBPEND","PENDENCIA")        /* Pendencias de aluno */
   SET INDEX TO DBIPEND1
ELSE
   DBCLOSEALL(); RETURN
ENDIF

SELECT 8
IF NetUse("DBREQ","REQ")             /* Requerimentos */
   SET INDEX TO DBIREQ1
ELSE
   RETURN
ENDIF

SELECT 1
IF NetUse("DBALU","ALUNO")             /* Alunos */
   SET INDEX TO DBIALU1,DBIALU2,DBIALU3,DBIALU4
ELSE
   DBCLOSEALL(); RETURN
ENDIF
                        
SELECT 2
IF NetUse("DBCERT","CERTIF")           /* Certificados */
   SET INDEX TO DBICERT1,DBICERT2,DBICER01,DBICER02,DBICER03
ELSE
   DBCLOSEALL(); RETURN
ENDIF

cPrg:="AE111"; LinhaMsg(2); ProgName(cPrg)
msg:="^ENTER^-Registra/Altera ^F2^-Consulta"

vTela:=SAVESCREEN(2,0,24,79); Area_Dados()
SETCOLOR(YCOREDIT)
Telas(4,5,17,75,1,YCOREDIT,.T.,"Expediฦo de Certificados")
Telas(17,5,19,75,1,YCOREDIT,.T.,"Pesquisa")
Linha23(msg)
PRIVATE cBuffer:=""
oBr:=TBROWSEDB(5,6,16,74)
oBr:headSep:="ฤยฤ"
oBr:colSep:= " ณ "
oBr:colorspec:=YCOREDIT

oCol:=TBCOLUMNNEW("Matrกcula"    ,{|| MATRIC})
oBr:addColumn(oCol)
oCol:=TBCOLUMNNEW("Aluno"        ,{|| NOME})
oBr:addColumn(oCol)

WHILE .T.
   WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
   tecla := INKEY()
   IF ( tecla == K_ESC )
      EXIT
   ELSEIF ( tecla == K_F1 )    // Ajuda
      Help(EVAL({||cOphelp1 }),EVAL({||cOphelp2 }),nCall,cHmsg1,cHmsg2)
   ELSEIF ( tecla == K_F2 )    // Pesquisa
      Mostra()
      cBuffer := ""
   ELSEIF ( tecla == K_F4 )    // Calculadora
      Calculadora(calc_lin,calc_col,YCORMENU)
   ELSEIF ( tecla == K_F5 )    // Calendario
      Calendary(@cale_lin,@cale_col,@m_date)
   ELSEIF ( tecla == K_ENTER )
      ChkPend(CERTIF->MATRIC)  // Verifica pendencia
      ChkPReq(CERTIF->MATRIC)  // Verifica pendencia de requerimento
      IF Acesso(3); Altera(msg); oBr:refreshAll(); ENDIF
   ELSEIF tecla>=32.AND.tecla<=127.OR.tecla==K_BS.OR.tecla==K_CTRL_L
      SmartSeek(UPPER(CHR(tecla)),18,6,60)
      oBr:refreshall()
   ELSE
      ProcKey(oBr,tecla)
   ENDIF
ENDDO
SETCOLOR(corant); Rest_Tela(2)
RESTSCREEN(2,0,24,79,vTela)
RETURN
*ีออออออออออออออออออออออออออออออธ
*ณ Alterar Dados no Browse      ณ
*ิออออออออออออออออออออออออออออออพ
STATIC FUNCTION Altera(msg)
   LOCAL nReg_Ant := RECNO(), lAlt := .F.

   DBGOTOP()
   IF EOF()
      Aviso("Nฦo h  registro a ser Alterado !",,2)
      Linha23(msg)
      RETURN(lAlt)
   ENDIF
   GO nReg_Ant

   Mensagem("Altere os campos necess rios")
   SETCOLOR(YCOREDIT)
   Telas(3,3,21,76,1,YCOREDIT,.T.,"Dados dos Certificados")

   FOR a = 1 TO FCOUNT()
       xVar  := "w"+FIELDNAME(a)
       &xVar := FIELDGET(a)
   NEXT
   ALUNO->(DBSEEK(wMatric))

   EditaGet("A")
   SETCURSOR(1); READ; SETCURSOR(0)

   IF LASTKEY()#K_ESC.AND.UPDATED()
      IF Confirma("Confirma Alteraฦo ?")
         wUser:=cUsuario
         GO nReg_Ant
         WHILE !NetLReg(); ENDDO
         FOR a = 1 TO FCOUNT()
             xVar  := "w"+FIELDNAME(a)
             FIELDPUT(a,&xVar)
         NEXT
         DBUNLOCK(); DBCOMMITALL()
         ProcOk("Alterado",.T.)
         lAlt := .T.
      ENDIF
   ENDIF
   Rest_Tela(); GO nReg_Ant; Linha23(msg); SETKEY(K_F2,NIL)
   RETURN(lAlt)
*ีออออออออออออออออออออออออออออออธ
*ณ Editar campos de dados       ณ
*ิออออออออออออออออออออออออออออออพ
STATIC PROCEDURE EditaGet(pOp)
   @ 04,05 SAY "Aluno:" GET wNome       WHEN .F.
   @ 05,05 SAY "CPF..:" GET ALUNO->CPF  WHEN .F. PICT "@R 999.999.999-99"
   @ 05,30 SAY "RG:"    GET ALUNO->RG   WHEN .F.
   @ 06,03 SAY "ร"+REPL("ฤ",72)+"ด"
   Centro(6," TEORICO ",3,76)
   @ 07,05 SAY "N๘ Certif.  Perกodo do Curso   Emissฦo    Livro P g Etiqueta    Cขdigo"
*               9999999999  99/99/9999         99/99/9999 9999  99  xxxxxxxxxxx 999999
*               567890123456789012345678901234567890123456789012345678901234567890123456
*                    1         2         3         4         5         6         7
   @ 08,03 SAY "ร"+REPL("ฤ",72)+"ด"
   @ 09,05 GET wCertif1    PICT "@!"
   @ 09,17 GET wPeri_T     PICT "@D"
   @ 10,17 GET wPerf_T     PICT "@D"

   @ 09,36 GET wDtEm1      PICT "@D"
   @ 09,47 GET wLiv_T1     PICT "9999"
   @ 09,53 GET wPag_T1     PICT "99"
   @ 09,57 GET wEtiq1      PICT "@R !!!!!!!!!!!/"
   @ 09,69 GET wCodEtq1    PICT "999999"

   @ 10,36 GET wDtEm11     PICT "@D"
   @ 10,47 GET wLiv_T11  PICT "9999"
   @ 10,53 GET wPag_T11    PICT "99"
   @ 10,57 GET wEtiq11     PICT "@R !!!!!!!!!!!/"
   @ 10,69 GET wCodEtq11   PICT "999999"

   @ 11,36 GET wDtEm111    PICT "@D"
   @ 11,47 GET wLiv_T111 PICT "9999"
   @ 11,53 GET wPag_T111   PICT "99"
   @ 11,57 GET wEtiq111    PICT "@R !!!!!!!!!!!/"
   @ 11,69 GET wCodEtq111  PICT "999999"
   @ 11,05 SAY "Obs.:" GET wObs1 PICT "@!S24"

   @ 12,03 SAY "ร"+REPL("ฤ",72)+"ด"
   Centro(12," PRATICO (Carro) ",3,76)
   @ 13,05 GET wCertif2    PICT "@!"
   @ 13,17 GET wPeri_P     PICT "@D"
   @ 14,17 GET wPerf_P     PICT "@D"

   @ 13,36 GET wDtEm2      PICT "@D"
   @ 13,47 GET wLiv_P2     PICT "9999"
   @ 13,53 GET wPag_P2     PICT "99"
   @ 13,57 GET wEtiq2      PICT "@R !!!!!!!!!!!/"
   @ 13,69 GET wCodEtq2    PICT "999999"

   @ 14,36 GET wDtEm22     PICT "@D"
   @ 14,47 GET wLiv_P22    PICT "9999"
   @ 14,53 GET wPag_P22    PICT "99"
   @ 14,57 GET wEtiq22     PICT "@R !!!!!!!!!!!/"
   @ 14,69 GET wCodEtq22   PICT "999999"

   @ 15,36 GET wDtEm222    PICT "@D"
   @ 15,47 GET wLiv_P222   PICT "9999"
   @ 15,53 GET wPag_P222   PICT "99"
   @ 15,57 GET wEtiq222    PICT "@R !!!!!!!!!!!/"
   @ 15,69 GET wCodEtq222  PICT "999999"
   @ 15,05 SAY "Obs.:" GET wObs2 PICT "@!S24"

   @ 16,03 SAY "ร"+REPL("ฤ",72)+"ด"
   Centro(16," PRATICO (Moto) ",3,76)
   @ 17,05 GET wCertif3    PICT "@!"
   @ 17,17 GET wPeri_P1    PICT "@D"
   @ 18,17 GET wPerf_P1    PICT "@D"

   @ 17,36 GET wDtEm3      PICT "@D"
   @ 17,47 GET wLiv_P3   PICT "9999"
   @ 17,53 GET wPag_P3     PICT "99"
   @ 17,57 GET wEtiq3      PICT "@R !!!!!!!!!!!/"
   @ 17,69 GET wCodEtq3    PICT "999999"

   @ 18,36 GET wDtEm33     PICT "@D"
   @ 18,47 GET wLiv_P33    PICT "9999"
   @ 18,53 GET wPag_P33    PICT "99"
   @ 18,57 GET wEtiq33     PICT "@R !!!!!!!!!!!/"
   @ 18,69 GET wCodEtq33   PICT "999999"

   @ 19,36 GET wDtEm333    PICT "@D"
   @ 19,47 GET wLiv_P333   PICT "9999"
   @ 19,53 GET wPag_P333   PICT "99"
   @ 19,57 GET wEtiq333    PICT "@R !!!!!!!!!!!/"
   @ 19,69 GET wCodEtq333  PICT "999999"

   @ 19,05 SAY "Obs.:" GET wObs3 PICT "@!S24"
   RETURN
