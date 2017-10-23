#include "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AFIN001   ºAutor  ³ MZM - MICROSIGA    º Data ³  12/09/07   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      º±±
±±º          ³ Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ ZOLLERN                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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