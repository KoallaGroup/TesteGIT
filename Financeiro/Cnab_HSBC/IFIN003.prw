#include "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矨FAT003   篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      罕�
北�          � Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       � ZOLLERN                                                    罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

USER FUNCTION IFIN003()

DBSELECTAREA("SX6")
DBSETORDER(1)
DBSEEK(XFILIAL("SX6")+"MV_QTDEREG")
RecLock("SX6",.F.)
       SX6->X6_CONTEUD := ""
dbUnlock()

DBSELECTAREA("SX6")
DBSETORDER(1)
DBSEEK(XFILIAL("SX6")+"MV_LTCNABP")
RecLock("SX6",.F.)
       SX6->X6_CONTEUD := ""
dbUnlock()

RETURN("0000")                               


