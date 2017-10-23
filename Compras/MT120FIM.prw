#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MT120FIM | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada no termino da gravação do pedido de compras							|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function MT120FIM()
Local _aArea := GetArea(), _aOpc := ParamIxb

//Retira a data de previsão de entrega quando for importação
If (Inclui .Or. Altera) .And. _aOpc[3] == 1
	DbSelectArea("SC7")
	DbSetOrder(1)
	DbGoTop()
	If DbSeek(xFilial("SC7") + _aOpc[2])
		//Limpa a data de entrega quando for pedido de importação
		If Posicione("SA2",1,xFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA,"A2_EST") == "EX"
			
			DbSelectArea("SC7")
			While !Eof() .And. (SC7->C7_FILIAL + SC7->C7_NUM) == (xFilial("SC7") + _aOpc[2])
			
				If SC7->C7__QTEMBA == 0
				     While !Reclock("SC7",.f.)
				     EndDo
				     SC7->C7_DATPRF := CTOD("  /  /  ")
				     MsUnlock()
				EndIf
			
				DbSkip()
			EndDo
			
		EndIf
	EndIf
	
EndIf

Return