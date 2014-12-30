*уммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╦
*Ё PROGRAMA       : AE_381                           vrs 001 Ё
*Ё FINALIDADE     : Relatorios exigidos pelo DETRAN          Ё
*Ё PROGRAMADOR    : Certificados e Etiquetas Expedidos       Ё
*Ё DATA CRIACAO   : 17/03/2005                               Ё
*тммммммммммммммммммммммммммммммммммммммммммммммммммммммммммм╬
#include "INKEY.CH"
#include "COMMAND.CH"

PRIVATE lTeor, lCarro, lMoto, lPrat

DBCLOSEALL()
aDbf:={}
AADD(aDbf,{"TIPO"     ,"C",   01,0}) /* Tipo do relatorio         */
AADD(aDbf,{"CAT"      ,"C",   01,0}) /* Categoria do relatorio    */
AADD(aDbf,{"NOME"     ,"C",   50,0}) /* Aluno                     */
AADD(aDbf,{"CERTIF"   ,"C",   08,0}) /* Numero do Certificado     */
AADD(aDbf,{"DTEMISS"  ,"D",   08,0}) /* Data Emissao Certificado  */
AADD(aDbf,{"RG"       ,"C",   10,0}) /* Numero do RG              */
AADD(aDbf,{"CPF"      ,"C",   11,0}) /* Numero da CPF             */
AADD(aDbf,{"ETIQ"     ,"C",   11,0}) /* Numero da etiqueta        */
AADD(aDbf,{"RENACH"   ,"C",   10,0}) /* Numero do RENACH          */
AADD(aDbf,{"CODET"    ,"C",   06,0}) /* Codigo da etiqueta        */
AADD(aDbf,{"OBS"      ,"C",   04,0}) /* 2a e 3a vias              */
WHILE .T.
   sHour:=TIME()
   cArq1:="AT"+LEFT(sHour,2)+SUBS(sHour,4,2)+RIGHT(sHour,2)
   IF !FILE(cArq1+".DBF")
      DBCREATE(cArq1,aDbf)
      EXIT
   ENDIF
ENDDO
SELECT 10
NetUse(cArq1,,"E")
INDEX ON tipo+cat+certif TO (cArq1)

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
INDEX ON tipo+etiq TO (cArq2)

SELECT 2
IF NetUse("DBALU","ALUNO")               /* Alunos */
   SET INDEX TO DBIALU1
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

SELECT 1
IF NetUse("DBCERT","CERTIF")             /* Certificados */
   SET INDEX TO DBICERT1
ELSE
   DelDbfNtx(); DelDbfNtx2(); RETURN
ENDIF

IF EOF()
   Aviso("Cadastro de Alunos Vazio!",,3); DBCLOSEALL(); RETURN
ENDIF
ProgName("AE381"); LinhaMsg(2)

Quadro(9,11,17,60,1,YCOREDIT,.T.,,.T.)
wCTini:=wCTfim:=wCPCini:=wCPCfim:=wCPMini:=wCPMfim:=SPACE(11); wDevice:=wOrd1:=wOrd2:=" ";wMesAno:=SPACE(6)
SETCOLOR(YCOREDIT)
@ 10,12 SAY "Ordem: ( ) Certificado  ( ) Etiqueta"
@ 11,12 SAY "Mes/Ano..: "
@ 12,12 SAY "Numera┤фo:             a             (Te╒rico)"
@ 13,12 SAY "Numera┤фo:             a             (Carro  )"
@ 14,12 SAY "Numera┤фo:             a             (Moto   )"
@ 15,11 SAY "ц"+REPLI("д",48)+"╢"

WHILE .T.
   Mensagem("Marque um X para selecionar")
   nCert:=nCTeor:=nCertC:=nCertM:=nCPratC:=nCPratM:=0
   @ 10,20 GET wOrd1   PICT "!" WHEN EMPTY(wOrd2) VALID wOrd1$" X"
   @ 10,37 GET wOrd2   PICT "!" WHEN EMPTY(wOrd1) VALID LASTKEY()==K_UP.OR.!EMPTY(wOrd2).AND.wOrd2$" X"
   @ 11,23 GET wMesAno PICT "@R 99/9999" WHEN !EMPTY(wOrd1) VALID LASTKEY()==K_UP.OR.!EMPTY(wMesAno)
   @ 12,23 GET wCTini  PICT "@!"
   @ 12,37 GET wCTfim  PICT "@!"
   @ 13,23 GET wCPCini PICT "@!"
   @ 13,37 GET wCPCfim PICT "@!"
   @ 14,23 GET wCPMini PICT "@!"
   @ 14,37 GET wCPMfim PICT "@!"
   @ 16,12 SAY "Sa║da:" GET wDevice PICT "!" WHEN HTela(5) VALID VTela(5)
   SETCURSOR(1); READ; SETCURSOR(0)

   Mensagem()
   IF LASTKEY()==K_ESC
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   lPrat := .F.
   IF !EMPTY(wCTini).AND.!EMPTY(wCPCini).AND.EMPTY(wCPMini)
      lTeor  := .T.
      lCarro := .T.
      lMoto  := .F.
   ELSEIF !EMPTY(wCTini).AND.EMPTY(wCPCini).AND.EMPTY(wCPMini)
      lTeor  := .T.
      lCarro := .F.
      lMoto  := .F.
   ELSEIF !EMPTY(wCTini).AND.EMPTY(wCPCini).AND.!EMPTY(wCPMini)
      lTeor  := .T.
      lCarro := .F.
      lMoto  := .T.
   ELSEIF EMPTY(wCTini).AND.!EMPTY(wCPCini).AND.!EMPTY(wCPMini)
      lTeor  := .F.
      lCarro := .T.
      lMoto  := .T.
      lPrat  := .T.
   ELSEIF EMPTY(wCTini).AND.!EMPTY(wCPCini).AND.EMPTY(wCPMini)
      lTeor  := .F.
      lCarro := .T.
      lMoto  := .F.
   ELSEIF EMPTY(wCTini).AND.EMPTY(wCPCini).AND.!EMPTY(wCPMini)
      lTeor  := .F.
      lCarro := .F.
      lMoto  := .T.
   ELSEIF !EMPTY(wCTini).AND.!EMPTY(wCPCini).AND.!EMPTY(wCPMini)
      lTeor  := .T.
      lCarro := .T.
      lMoto  := .T.
   ELSEIF EMPTY(wCTini).AND.EMPTY(wCPCini).AND.EMPTY(wCPMini)
      IF LEN(Telas)==3; Rest_Tela(); ENDIF
      EXIT
   ENDIF

   Aguarde("Pesquisando...")
   IF !EMPTY(wOrd1).AND.EMPTY(wOrd2)
      CERTIF->(DBGOTOP())
      WHILE !CERTIF->(EOF())
         IF !EMPTY(wCTini)
            IF STRZERO(MONTH(CERTIF->DTEM1),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM1),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM11),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM11),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM111),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM111),4)==RIGHT(wMesAno,4)

               // Certificado Teorico
               nCert++
               nCTeor++
               ALUNO->(DBSEEK(CERTIF->MATRIC))

               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->TIPO    WITH "1"             ,; // Teorico
                       (cArq1)->CAT     WITH IF(RIGHT(CERTIF->CERTIF1,2)=="I ","1",IF(RIGHT(CERTIF->CERTIF1,2)=="T ","2","3")),;
                       (cArq1)->NOME    WITH CERTIF->NOME    ,;
                       (cArq1)->CERTIF  WITH CERTIF->CERTIF1 ,;
                       (cArq1)->RG      WITH ALUNO->RG       ,;
                       (cArq1)->CPF     WITH ALUNO->CPF      ,;
                       (cArq1)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq1)->ETIQ    WITH CERTIF->ETIQ1   ,;
                       (cArq1)->CODET   WITH CERTIF->CODETQ1

               // 2a via
               IF STRZERO(MONTH(CERTIF->DTEM11),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM11),4)==RIGHT(wMesAno,4);
                  .AND. EMPTY(CERTIF->CERT_T2)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ11   ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ11 ,;
                          (cArq1)->OBS    WITH "2a V"
               ENDIF
               // 3a via
               IF STRZERO(MONTH(CERTIF->DTEM111),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM111),4)==RIGHT(wMesAno,4)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ111   ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ111 ,;
                          (cArq1)->OBS    WITH "3a V"
               ENDIF

               // 2o certificado teorico
               IF STRZERO(MONTH(CERTIF->DTEM11),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM11),4)==RIGHT(wMesAno,4);
                  .AND.!EMPTY(CERTIF->CERT_T2)

                  (cArq1)->(DBAPPEND())
                  REPLACE (cArq1)->TIPO    WITH "1"             ,; // Teorico
                          (cArq1)->CAT     WITH IF(RIGHT(CERTIF->CERT_T2,2)=="I ","1",IF(RIGHT(CERTIF->CERT_T2,2)=="T ","2","3")),;
                          (cArq1)->NOME    WITH CERTIF->NOME    ,;
                          (cArq1)->CERTIF  WITH CERTIF->CERT_T2 ,;
                          (cArq1)->RG      WITH ALUNO->RG       ,;
                          (cArq1)->CPF     WITH ALUNO->CPF      ,;
                          (cArq1)->RENACH  WITH ALUNO->RENACH   ,;
                          (cArq1)->ETIQ    WITH CERTIF->ETIQ11  ,;
                          (cArq1)->CODET   WITH CERTIF->CODETQ11
               ENDIF
            ENDIF
         ENDIF

         IF !EMPTY(wCPCini)
            IF STRZERO(MONTH(CERTIF->DTEM2),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM2),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM22),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM22),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM222),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM222),4)==RIGHT(wMesAno,4)

               // Certificado Pratico Carro
               nCertC++
               nCPratC++
               ALUNO->(DBSEEK(CERTIF->MATRIC))

               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->TIPO    WITH "2"             ,; // Pratico carro
                       (cArq1)->CAT     WITH "1"             ,; // para diferenciar categoria
                       (cArq1)->NOME    WITH CERTIF->NOME    ,;
                       (cArq1)->CERTIF  WITH CERTIF->CERTIF2 ,;
                       (cArq1)->RG      WITH ALUNO->RG       ,;
                       (cArq1)->CPF     WITH ALUNO->CPF      ,;
                       (cArq1)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq1)->ETIQ    WITH CERTIF->ETIQ2   ,;
                       (cArq1)->CODET   WITH CERTIF->CODETQ2
               // 2a via
               IF STRZERO(MONTH(CERTIF->DTEM22),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM22),4)==RIGHT(wMesAno,4)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ22   ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ22 ,;
                          (cArq1)->OBS    WITH "2a V"
               ENDIF
               // 3a via
               IF STRZERO(MONTH(CERTIF->DTEM222),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM222),4)==RIGHT(wMesAno,4)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ222   ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ222 ,;
                          (cArq1)->OBS    WITH "3a V"
               ENDIF
            ENDIF
         ENDIF

         IF !EMPTY(wCPMini)
            IF STRZERO(MONTH(CERTIF->DTEM3),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM3),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM33),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM33),4)==RIGHT(wMesAno,4).OR.;
               STRZERO(MONTH(CERTIF->DTEM333),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM333),4)==RIGHT(wMesAno,4)

               // Certificado Pratico Moto
               nCertM++
               nCPratM++
               ALUNO->(DBSEEK(CERTIF->MATRIC))
               (cArq1)->(DBAPPEND())
               REPLACE (cArq1)->TIPO    WITH "3"             ,; // Pratico moto
                       (cArq1)->CAT     WITH "1"             ,; // para diferenciar categoria
                       (cArq1)->NOME    WITH CERTIF->NOME    ,;
                       (cArq1)->CERTIF  WITH CERTIF->CERTIF3 ,;
                       (cArq1)->RG      WITH ALUNO->RG       ,;
                       (cArq1)->CPF     WITH ALUNO->CPF      ,;
                       (cArq1)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq1)->ETIQ    WITH CERTIF->ETIQ3   ,;
                       (cArq1)->CODET   WITH CERTIF->CODETQ3
               // 2a via
               IF STRZERO(MONTH(CERTIF->DTEM33),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM33),4)==RIGHT(wMesAno,4)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ33   ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ33 ,;
                          (cArq1)->OBS    WITH "2a V"
               ENDIF
               // 3a via
               IF STRZERO(MONTH(CERTIF->DTEM333),2)==LEFT(wMesAno,2).AND.STRZERO(YEAR(CERTIF->DTEM333),4)==RIGHT(wMesAno,4)
                  REPLACE (cArq1)->ETIQ   WITH CERTIF->ETIQ333  ,;
                          (cArq1)->CODET  WITH CERTIF->CODETQ333,;
                          (cArq1)->OBS    WITH "3a V"
               ENDIF
            ENDIF
         ENDIF
         CERTIF->(DBSKIP())
      ENDDO
   ELSE
      CERTIF->(DBGOTOP())
      WHILE !CERTIF->(EOF())
         IF !EMPTY(wCTini)
            IF (SUBS(CERTIF->ETIQ1,3)>=RTRIM(SUBS(wCTini,3)).AND.SUBS(CERTIF->ETIQ1,3)<=RTRIM(SUBS(wCTfim,3))).OR.;
               (SUBS(CERTIF->ETIQ11,3)>=RTRIM(SUBS(wCTini,3)).AND.SUBS(CERTIF->ETIQ11,3)<=RTRIM(SUBS(wCTfim,3))).OR.;
               (SUBS(CERTIF->ETIQ111,3)>=RTRIM(SUBS(wCTini,3)).AND.SUBS(CERTIF->ETIQ111,3)<=RTRIM(SUBS(wCTfim,3)))

               // Certificado Teorico
               nCert++
               nCTeor++
               ALUNO->(DBSEEK(CERTIF->MATRIC))

               (cArq2)->(DBAPPEND())
               REPLACE (cArq2)->TIPO    WITH "1"             ,; // Teorico
                       (cArq2)->CAT     WITH IF(RIGHT(CERTIF->CERTIF1,2)=="I ","1",IF(RIGHT(CERTIF->CERTIF1,2)=="T ","2","3")),;
                       (cArq2)->NOME    WITH CERTIF->NOME    ,;
                       (cArq2)->CERTIF  WITH CERTIF->CERTIF1 ,;
                       (cArq2)->RG      WITH ALUNO->RG       ,;
                       (cArq2)->CPF     WITH ALUNO->CPF      ,;
                       (cArq2)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq2)->ETIQ    WITH CERTIF->ETIQ1   ,;
                       (cArq2)->CODET   WITH CERTIF->CODETQ1
            ENDIF
         ENDIF

         IF !EMPTY(wCPCini)
            IF (SUBS(CERTIF->ETIQ2,3)>=RTRIM(SUBS(wCPCini,3)).AND.SUBS(CERTIF->ETIQ2,3)<=RTRIM(SUBS(wCPCfim,3))).OR.;
               (SUBS(CERTIF->ETIQ22,3)>=RTRIM(SUBS(wCPCini,3)).AND.SUBS(CERTIF->ETIQ22,3)<=RTRIM(SUBS(wCPCfim,3))).OR.;
               (SUBS(CERTIF->ETIQ222,3)>=RTRIM(SUBS(wCPCini,3)).AND.SUBS(CERTIF->ETIQ222,3)<=RTRIM(SUBS(wCPCfim,3)))

               // Certificado Pratico Carro
               nCertC++
               nCPratC++
               ALUNO->(DBSEEK(CERTIF->MATRIC))

               (cArq2)->(DBAPPEND())
               REPLACE (cArq2)->TIPO    WITH "2"             ,; // Pratico carro
                       (cArq2)->CAT     WITH "1"             ,;
                       (cArq2)->NOME    WITH CERTIF->NOME    ,;
                       (cArq2)->CERTIF  WITH CERTIF->CERTIF2 ,;
                       (cArq2)->RG      WITH ALUNO->RG       ,;
                       (cArq2)->CPF     WITH ALUNO->CPF      ,;
                       (cArq2)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq2)->ETIQ    WITH CERTIF->ETIQ2   ,;
                       (cArq2)->CODET   WITH CERTIF->CODETQ2
            ENDIF
         ENDIF

         IF !EMPTY(wCPMini)
            IF (SUBS(CERTIF->ETIQ3,3)>=RTRIM(SUBS(wCPMini,3)).AND.SUBS(CERTIF->ETIQ3,3)<=RTRIM(SUBS(wCPMfim,3))).OR.;
               (SUBS(CERTIF->ETIQ33,3)>=RTRIM(SUBS(wCPMini,3)).AND.SUBS(CERTIF->ETIQ33,3)<=RTRIM(SUBS(wCPMfim,3))).OR.;
               (SUBS(CERTIF->ETIQ333,3)>=RTRIM(SUBS(wCPMini,3)).AND.SUBS(CERTIF->ETIQ333,3)<=RTRIM(SUBS(wCPMfim,3)))

               // Certificado Pratico Moto
               nCertM++
               nCPratM++
               ALUNO->(DBSEEK(CERTIF->MATRIC))
               (cArq2)->(DBAPPEND())
               REPLACE (cArq2)->TIPO    WITH "3"             ,; // Pratico moto
                       (cArq2)->CAT     WITH "1"             ,;
                       (cArq2)->NOME    WITH CERTIF->NOME    ,;
                       (cArq2)->CERTIF  WITH CERTIF->CERTIF3 ,;
                       (cArq2)->RG      WITH ALUNO->RG       ,;
                       (cArq2)->CPF     WITH ALUNO->CPF      ,;
                       (cArq2)->RENACH  WITH ALUNO->RENACH   ,;
                       (cArq2)->ETIQ    WITH CERTIF->ETIQ3   ,;
                       (cArq2)->CODET   WITH CERTIF->CODETQ3
            ENDIF
         ENDIF
         CERTIF->(DBSKIP())
      ENDDO
   ENDIF
   Aguarde()

   IF wDevice=="I"
      IF ChkImpr()
         cAviso := MsgImp()
         IF !EMPTY(wOrd1)
            ImpRel()
            WHILE Confirma("Outra C╒pia ?")
              ImpRel()
            ENDDO
         ELSE
            ImpRel2()
            WHILE Confirma("Outra C╒pia ?")
              ImpRel2()
            ENDDO
         ENDIF
         TiraMsgImp(cAviso)
         WaitMsg("Fim de Impressфo, tecle algo...")
      ENDIF
   ELSE
      Mensagem(CHR(27)+CHR(18)+CHR(26)+" Movimentar"); LimpaLinhaMsg(24)
      BrowCad(wOrd1,wOrd2)
   ENDIF
   (cArq1)->(__DBZAP())
   (cArq2)->(__DBZAP())
ENDDO
RELEASE continua, nPg, lTeor, lCarro, lMoto
DelDbfNtx(); DelDbfNtx2(); RETURN
*умммммммммммммммммммммммммммммм╦
*Ё Relatorio Geral              Ё
*тмммммммммммммммммммммммммммммм╬
STATIC FUNCTION ImpRel()
   LOCAL nCert:=0
   Gera_TXT("RCERTIF.TXT"); SETPRC(0,0)
   xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
   (cArq1)->(DBGOTOP())

   Compr_On()
   IF (cArq1)->TIPO=="1"
      @ PROW()+1,05 SAY "зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
      @ PROW()+1,05 SAY "Ё    T E O R I C O S                                                                      Ё"
   ELSEIF (cArq1)->TIPO=="2"
      @ PROW()+1,05 SAY "зддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
      @ PROW()+1,05 SAY "Ё    P R A T I C O S  (CARRO)                                                             Ё"
   ELSEIF (cArq1)->TIPO=="3"
     @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
     @ PROW()+1,05 SAY "Ё    P R A T I C O S  (MOTO)                                                               Ё"
   ENDIF
   @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
   @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
   @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
*                       XXXXXXXX    XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 999.999.999-99 XXXXXXXXXXX
*                     567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7         8         9        10        11        12        13
   WHILE !(cArq1)->(EOF())
      IF (cArq1)->TIPO=="1" // Teorico
         @ PROW()+1,07 SAY (cArq1)->CERTIF
         @ PROW()  ,19 SAY (cArq1)->NOME
         @ PROW()  ,70 SAY (cArq1)->CPF    PICT "@R 999.999.999-99"
         @ PROW()  ,85 SAY (cArq1)->ETIQ
         @ PROW()  ,97 SAY (cArq1)->OBS
      ENDIF
      IF !(cArq1)->(EOF()).AND.PROW()>=57.AND.(cArq1)->TIPO=="1"
         @ PROW()+1,05 SAY REPLICATE("-",96)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
         @ PROW()+1,05 SAY "Ё    T E O R I C O S                                                                       Ё"
         @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
         @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
         @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
      ENDIF
      IF (cArq1)->TIPO=="2" // Pratico carro
         IF lTeor.AND.lCarro
            @ PROW()+1,05 SAY REPLICATE("-",96)
            @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
            EJECT
            xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
            @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
            @ PROW()+1,05 SAY "Ё    P R A T I C O S  (CARRO)                                                              Ё"
            @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
            @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
            @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
            lCarro:=.F.
         ENDIF

         @ PROW()+1,07 SAY (cArq1)->CERTIF
         @ PROW()  ,19 SAY (cArq1)->NOME
         @ PROW()  ,70 SAY (cArq1)->CPF    PICT "@R 999.999.999-99"
         @ PROW()  ,85 SAY (cArq1)->ETIQ
         @ PROW()  ,97 SAY (cArq1)->OBS
      ENDIF
      IF !(cArq1)->(EOF()).AND.PROW()>=57.AND.(cArq1)->TIPO=="2"
         @ PROW()+1,05 SAY REPLICATE("-",96)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
         @ PROW()+1,05 SAY "Ё    P R A T I C O S  (CARRO)                                                              Ё"
         @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
         @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
         @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
      ENDIF
      IF (cArq1)->TIPO=="3" // Pratico moto
         IF (lTeor.AND.lMoto) .OR. (lPrat.AND.lMoto)
            @ PROW()+1,05 SAY REPLICATE("-",96)
            @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
            EJECT
            xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
            @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
            @ PROW()+1,05 SAY "Ё    P R A T I C O S  (MOTO)                                                               Ё"
            @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
            @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
            @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
            lMoto:=.F.
         ENDIF
         @ PROW()+1,07 SAY (cArq1)->CERTIF
         @ PROW()  ,19 SAY (cArq1)->NOME
         @ PROW()  ,70 SAY (cArq1)->CPF    PICT "@R 999.999.999-99"
         @ PROW()  ,85 SAY (cArq1)->ETIQ
         @ PROW()  ,97 SAY (cArq1)->OBS
      ENDIF
      IF !(cArq1)->(EOF()).AND.PROW()>=57.AND.(cArq1)->TIPO=="3"
         @ PROW()+1,05 SAY REPLICATE("-",96)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©"
         @ PROW()+1,05 SAY "Ё    P R A T I C O S  (MOTO)                                                               Ё"
         @ PROW()+1,05 SAY "цдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд╢"
         @ PROW()+1,05 SAY "Ё Nr.CERTIF.  NOME DO ALUNO                                      CPF            ETIQUETA   Ё"
         @ PROW()+1,05 SAY "юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды"
      ENDIF
      (cArq1)->(DBSKIP())
   ENDDO
   @ PROW()+1,05 SAY REPLICATE("-",96)
   @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   @ PROW()+1,05 SAY " "
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp rcertif.txt 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE RCERTIF.TXT
   RETURN
*умммммммммммммммммммммммммммммм╦
*Ё Relatorio Geral Etiqueta     Ё
*тмммммммммммммммммммммммммммммм╬
STATIC FUNCTION ImpRel2()
   LOCAL nCert:=0
   Gera_TXT("GETIQ.TXT"); SETPRC(0,0)
   xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
   (cArq2)->(DBGOTOP())

   Compr_On()
   IF (cArq2)->TIPO=="1"
      @ PROW()+1,05 SAY "Faixa:"+wCTini+" a "+wCTfim
      @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
      @ PROW()+1,05 SAY "     T E O R I C O S                                                                            "
   ELSEIF (cArq2)->TIPO=="2"
      @ PROW()+1,05 SAY "Faixa:"+wCPCini+" a "+wCPCfim
      @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
      @ PROW()+1,05 SAY "     P R A T I C O S  (CARRO)                                                                   "
   ELSEIF (cArq2)->TIPO=="3"
      @ PROW()+1,05 SAY "Faixa:"+wCPMini+" a "+wCPMfim
      @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
      @ PROW()+1,05 SAY "     P R A T I C O S  (MOTO)                                                                    "
   ENDIF
   @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
   @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
   @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
*                       23/XXXXXXXX     XXXXXXXXXXX XXXXXXXXXXxxxxxxxxxxXXXXXXXXXXxxxxxxxxxxXXXXXXXXXX 999.999.999-99
*                     567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*                          1         2         3         4         5         6         7         8         9        10        11        12        13
   WHILE !(cArq2)->(EOF())
      IF (cArq2)->TIPO=="1" // Teorico
         @ PROW()+1,07 SAY (cArq2)->CERTIF
         @ PROW()  ,23 SAY (cArq2)->ETIQ
         @ PROW()  ,35 SAY (cArq2)->NOME
         @ PROW()  ,86 SAY (cArq2)->CPF    PICT "@R 999.999.999-99"
      ENDIF
      IF !(cArq2)->(EOF()).AND.PROW()>=57.AND.(cArq2)->TIPO=="1"
         @ PROW()+1,05 SAY REPLICATE("-",100)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "Faixa:"+wCTini+" a "+wCTfim
         @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "     T E O R I C O S                                                                            "
         @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
         @ PROW()+1,05 SAY "------------------------------------------------------------------------------------------------"
      ENDIF
      IF (cArq2)->TIPO=="2" // Pratico carro
         IF lTeor.AND.lCarro
            @ PROW()+1,05 SAY REPLICATE("-",100)
            @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
            EJECT
            xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
            @ PROW()+1,05 SAY "Faixa:"+wCPCini+" a "+wCPCfim
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            @ PROW()+1,05 SAY "     P R A T I C O S  (CARRO)                                                                                               "
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            lCarro:=.F.
         ENDIF

         @ PROW()+1,07 SAY (cArq2)->CERTIF
         @ PROW()  ,23 SAY (cArq2)->ETIQ
         @ PROW()  ,35 SAY (cArq2)->NOME
         @ PROW()  ,86 SAY (cArq2)->CPF    PICT "@R 999.999.999-99"
      ENDIF
      IF !(cArq2)->(EOF()).AND.PROW()>=57.AND.(cArq2)->TIPO=="2"
         @ PROW()+1,05 SAY REPLICATE("-",100)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "Faixa:"+wCPCini+" a "+wCPCfim
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "     P R A T I C O S  (CARRO)                                                                "
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
      ENDIF
      IF (cArq2)->TIPO=="3" // Pratico moto
         IF (lTeor.AND.lMoto) .OR. (lPrat.AND.lMoto)
            @ PROW()+1,05 SAY REPLICATE("-",100)
            @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
            EJECT
            xpg:=0; CABCERT("CERTIFICADOS EMITIDOS")
            @ PROW()+1,05 SAY "Faixa:"+wCPMini+" a "+wCPMfim
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            @ PROW()+1,05 SAY "     P R A T I C O S  (MOTO)                                                                 "
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
            @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
            lMoto:=.F.
         ENDIF
         @ PROW()+1,07 SAY (cArq2)->CERTIF
         @ PROW()  ,23 SAY (cArq2)->ETIQ
         @ PROW()  ,36 SAY (cArq2)->NOME
         @ PROW()  ,86 SAY (cArq2)->CPF    PICT "@R 999.999.999-99"
      ENDIF
      IF !(cArq2)->(EOF()).AND.PROW()>=57.AND.(cArq2)->TIPO=="3"
         @ PROW()+1,05 SAY REPLICATE("-",100)
         @ PROW()+1,05 SAY "Continua..."
         EJECT
         CABCERT("CERTIFICADOS EMITIDOS")
         @ PROW()+1,05 SAY "Faixa:"+wCPMini+" a "+wCPMfim
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "     P R A T I C O S  (MOTO)                                                                 "
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
         @ PROW()+1,05 SAY "  N╖ CERTIFICADO  ETIQUETA    NOME DO ALUNO                                      CPF"
         @ PROW()+1,05 SAY "---------------------------------------------------------------------------------------------"
      ENDIF
      (cArq2)->(DBSKIP())
   ENDDO
   @ PROW()+1,05 SAY REPLICATE("-",100)
   @ PROW()+2,05 SAY PADC("Salvador, "+SUBS(DTOC(cDtSys),1,2)+" de "+ExtMes(cDtSys)+" de "+STR(YEAR(cDtSys),4),75)
   @ PROW()+1,05 SAY " "
   Fim_TXT()
   SAVESCREEN(0,0,24,79)
   RUN nodosimp GETIQ.TXT 96 pre/sel
   RESTSCREEN(0,0,24,79,0)
   DELETE FILE GETIQ.TXT
   RETURN
*умммммммммммммммммммммммммммммммм╦
*Ё Browse do Cadastro             Ё
*тмммммммммммммммммммммммммммммммм╬
STATIC FUNCTION BrowCad(pOrd)
   LOCAL corant:=SETCOLOR(), oBr, oCol
   IF pOrd=="X"
      SELECT (cArq1)
   ELSE
      SELECT (cArq2)
   ENDIF
   DBGOTOP()
   SETCOLOR(YCORGERAL)
   Telas(2,0,19,79,1,YCORGERAL,.F.,"CERTIFICADOS EMITIDOS")
   Telas(19,0,22,79,1,YCORGERAL,.F.)
   oBr:=TBROWSEDB(3,1,18,78)
   @ 20,03 SAY "Certificados =>"
   @ 20,19 SAY nCert
   @ 20,45 SAY "Pr═ticos =>"
   @ 21,45 SAY "Te╒ricos =>"
   @ 20,57 SAY (nCPratC+nCPratM)
   @ 21,57 SAY nCTeor
   oBr:headSep:="-б-"
   oBr:colSep:= " Ё "
   oBr:colorspec:=YCORGERAL

   oCol:=TBCOLUMNNEW("Aluno"        ,{|| NOME})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Certificado"  ,{|| CERTIF})
   oBr:addColumn(oCol)
   oCol:=TBCOLUMNNEW("Etiqueta"     ,{|| ETIQ})
   oBr:addColumn(oCol)

   WHILE .T.
      WHILE NEXTKEY()=0 .AND. !oBr:stabilize(); ENDDO
      tecla := INKEY()
      IF ( tecla == K_ESC )
         EXIT
      ELSEIF ( tecla == K_F9 )  // Imprime
         IF ChkImpr()
            cAviso := MsgImp(.F.)
            ImpRel()
            WHILE Confirma("Outra C╒pia ?")
               ImpRel()
            ENDDO
            TiraMsgImp(cAviso)
            WaitMsg("Fim de Impressфo, tecle algo...")
         ENDIF
      ELSE
         ProcKey(oBr,tecla)
      ENDIF
  ENDDO
  SETCOLOR(corant); Rest_Tela(2)
  RETURN NIL
*умммммммммммммммммммммммммммммм╦
*Ё Cabe┤alho do Relatorio       Ё
*тмммммммммммммммммммммммммммммм╬
PROCEDURE CabCERT(pTexto,lPg)
   DEFAULT lPg TO .T.
   IF lPg; xpg++; ENDIF
   @ PROW(),05 SAY " "
   Compr_Off()
   @ PROW()+1,05 SAY UPPER(cRazao1)
   @ PROW()+2,05 SAY pTexto
   @ PROW()+1,05 SAY "Mes Ref.: "+LEFT(wMesAno,2)+"/"+RIGHT(wMesAno,4)
   IF lPg
      @ PROW()+1,65 SAY "P═g.:"+STRZERO(xpg,4)
   ENDIF
   @ PROW()+1,05 SAY " "
   Compr_On()
   RETURN
