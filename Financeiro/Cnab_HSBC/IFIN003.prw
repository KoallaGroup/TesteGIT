#include "rwmake.ch"

/*
�����������������������������������������������������������������������������
���Programa  �AFAT003   �Autor  � MZM - MICROSIGA    � Data �  12/09/07   ���
�����������������������������������������������������������������������������
���Desc.     � PROGRAMA PARA O CONTROLE DO NUMERO DE LOTES DO SISPAG      ���
���          � Devera ser criado o parametro MV_LTCNABP TIPO NUMERICO     ���
�����������������������������������������������������������������������������
���Uso       � ZOLLERN                                                    ���
�����������������������������������������������������������������������������
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


