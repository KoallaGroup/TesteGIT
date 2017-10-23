#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ITMKA17  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Chama consulta específica acionado pelo produto no pedido de     |
|          | vendas no call Center, aparecendo as consultas padrão normal ou  |
|          | de brinde de acordo com o Tipo de Pedido                         |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/


User Function ITMKA17()

Local aArea		:= GetArea()
Local cTpPedido := Posicione("SZF",1,xFilial("SZF")+M->UA__TIPPED,"ZF_BRINDE")
Local lRet		:= .T.
Local cCodRet	:= ""

If cTpPedido == "1"
	lRet := ConPad1(,,,"SB1GPB",cCodRet,, .F.)
Else
	lRet := ConPad1(,,,"PRT",,, .F.)
EndIf

cCodRet := SB1->B1_COD

RestArea(aArea)

Return cCodRet
