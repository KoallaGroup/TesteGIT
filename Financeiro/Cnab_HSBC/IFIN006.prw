#Include "RwMake.Ch"

/*
�����������������������������������������������������������������������������
���Programa  � AFIN006  �Autor  � MZM - MICROSIGA    � Data �  12/09/07   ���
�����������������������������������������������������������������������������
���Desc.     � Incrementa o parametro contador de registros por lote.     ���
���          �                                                            ���
�����������������������������������������������������������������������������
���Uso       �  Layout do Cnab Pagto Modelo 2( HSBC_PAG.2pe )             ���
���          �  Header de Lote - Posi��o 018-023                          ���
�����������������������������������������������������������������������������
*/

User Function IFIN006()

Local _cReturn := ""

DBSELECTAREA("SX6")
DBSETORDER(1)          
DBSEEK(XFILIAL("SX6")+"MV_QTDREGL")
RecLock("SX6",.F.)
       SX6->X6_CONTEUD := SOMA1(SX6->X6_CONTEUD)
dbUnlock()

Return(_cReturn)