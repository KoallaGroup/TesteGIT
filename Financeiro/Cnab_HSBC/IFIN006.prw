#Include "RwMake.Ch"

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºPrograma  ³ AFIN006  ºAutor  ³ MZM - MICROSIGA    º Data ³  12/09/07   º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºDesc.     ³ Incrementa o parametro contador de registros por lote.     º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ºUso       ³  Layout do Cnab Pagto Modelo 2( HSBC_PAG.2pe )             º±±
±±º          ³  Header de Lote - Posição 018-023                          º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
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