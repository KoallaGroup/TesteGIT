#include "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AFAT002   ºAutor  ³ MZM - MICROSIGA    º Data ³  12/09/07   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      º±±
±±º          ³ Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ ZOLLERN                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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