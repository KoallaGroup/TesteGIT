#include "rwmake.ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³AFAT003   ºAutor  ³ MZM - MICROSIGA    º Data ³  12/09/07   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      º±±
±±º          ³ Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³ ZOLLERN                                                    º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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


