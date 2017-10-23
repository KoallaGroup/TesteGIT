#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA410 	 		  		| 	Fevereiro de 2015					 				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para Validacao da tela toda no Pedido de Venda				    |
|-----------------------------------------------------------------------------------------------|	
*/

User Function MTA410()

Local _aArea 	:= GetArea() 
Local aAreaSC6	:= SC6->( GetArea() )  
Local _nPTMK := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6__TMKITE" })
Local _nPITE := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_ITEM" })
Local _nPPRD := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO" })
Local _nQTDL := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_QTDLIB" }) 
Local _nQTDV := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_QTDVEN" })

For nx := 1 To Len(aCols)
	If !Empty(aCols[nx][_nPTMK]) .And. (aCols[nx][_nPITE] <> aCols[nx][_nPTMK])
		aCols[nx][_nPITE] := aCols[nx][_nPTMK]
	EndIf  
	
	//If INCLUI .Or. ALTERA	
	//	aCols[nx][_nQTDL] := aCols[nx][_nQTDV]
	//EndIf
	
Next

RestArea(aAreaSC6)
RestArea(_aArea)

Return .T. 