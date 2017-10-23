/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA410I 	 		  		| 	Fevereiro de 2015					 				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para Validacao da tela toda no Pedido de Venda				    |
|-----------------------------------------------------------------------------------------------|	
*/

User Function MTA410I()

Local _aArea 	:= GetArea() 
Local aAreaSC6	:= SC6->( GetArea() )  

Local _nQTDL := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_QTDLIB" }) 
Local _nQTDV := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_QTDVEN" })

//For nx := 1 To Len(aCols)

//	If INCLUI .Or. ALTERA	
//		aCols[nx][_nQTDL] := aCols[nx][_nQTDV]
//	EndIf
	
//Next

RestArea(aAreaSC6)
RestArea(_aArea)

Return .T.    