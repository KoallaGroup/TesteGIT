#include "rwmake.ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  矨FAT002   篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      罕�
北�          � Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       � ZOLLERN                                                    罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
*/

USER FUNCTION IFIN002()

Private _nQTDE := GETMV("MV_QTDEREG")
Private _nLOTE := GETMV("MV_LTCNABP")

_nQTDE := _nQTDE + 1	

_nQTDE := STRZERO(_nQTDE,4)       

DBSELECTAREA("SX6")
DBSETORDER(1)
DBSEEK(XFILIAL("SX6")+"MV_QTDEREG")
RecLock("SX6",.F.)
       SX6->X6_CONTEUD := _nQTDE
dbUnlock()

RETURN(_nLote)