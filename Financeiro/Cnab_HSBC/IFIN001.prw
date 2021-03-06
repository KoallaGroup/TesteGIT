#include "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矨FIN001   篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      罕�
北�          � Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       � ZOLLERN                                                    罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

USER FUNCTION IFIN001()
Private _nLote  := GETMV("MV_LTCNABP")

_nLote := _nLote + 1	

_nLote := STRZERO(_nLote,4)       

DBSELECTAREA("SX6")
DBSETORDER(1)
DBSEEK(XFILIAL("SX6")+"MV_LTCNABP")
RecLock("SX6",.F.)
       SX6->X6_CONTEUD := _nLote
dbUnlock()

RETURN(_nLote)