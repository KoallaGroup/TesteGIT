#Include "RwMake.Ch"

/*
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篜rograma  � AFIN006  篈utor  � MZM - MICROSIGA    � Data �  12/09/07   罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篋esc.     � Incrementa o parametro contador de registros por lote.     罕�
北�          �                                                            罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北篣so       �  Layout do Cnab Pagto Modelo 2( HSBC_PAG.2pe )             罕�
北�          �  Header de Lote - Posi玢o 018-023                          罕�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
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