/* Eliminar Duplicidade de Hor rios */
SELE 2
USE DBALU INDEX DBIALU1

SELE 1
USE DBPROG
INDEX ON MATRIC+DTOS(DATA)+HORA TO X
DBGOTOP()
WHILE !EOF()
  cdata=DATA; chora=HORA; cmatric=MATRIC
  DBSKIP()
  IF DATA==cdata.AND.HORA==chora.AND.MATRIC==cmatric.AND.!DELETED()
*    DBALU->(DBSEEK(cmatric))
*    cnome=DBALU->NOME
*    SET DEVI TO PRINT
*    @ PROW()+1,001 SAY cmatric+" "+cnome+" "+DTOC(cdata)+" "+chora
*    SET DEVI TO SCREEN
     DBPROG->(DBDELETE())
  ENDIF
ENDDO
