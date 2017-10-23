#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | SD1140I  | Autor: | Rubens Cruz - Anadi Consultoria 			| Data: | Mar�o/2015   |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descri��o: | Ponto de entrada na inclus�o de cada item da pr�-nota                               |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function SD1140I() 
Local _aArea 	:= GetArea() 
Local _aAreaSZ3 := SZ3->(GetArea())

//Rubens Cruz - Mar/2015 > Criada rotina para excluir quantidade da SZ3 ao excluir a pr�-nota
	dbSelectArea("SZ3")
	dbSetOrder(5)
	if DbSeek(xFilial("SZ3") + SD1->D1__CODPRO + SD1->D1_PEDIDO + SD1->D1_ITEMPC + SD1->D1_FORNECE + SD1->D1_LOJA)
		if reclock("SZ3", .F.)
			SZ3->Z3_QTDESEM	:= SZ3->Z3_QTDESEM + SD1->D1_QUANT
			SZ3->Z3_VLDESEM := SZ3->Z3_VLDESEM + SD1->D1_TOTAL
			msUnlock()
		endif
	endif

RestArea(_aAreaSZ3)
RestArea(_aArea)

Return