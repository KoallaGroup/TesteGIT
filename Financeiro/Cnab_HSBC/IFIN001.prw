#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
���Programa  �AFIN001   �Autor  � MZM - MICROSIGA    � Data �  12/09/07   ���
�����������������������������������������������������������������������������
���Desc.     � PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      ���
���          � Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     ���
�����������������������������������������������������������������������������
���Uso       � ZOLLERN                                                    ���
�����������������������������������������������������������������������������
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