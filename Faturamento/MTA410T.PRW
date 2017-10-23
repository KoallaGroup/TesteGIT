#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA410T	 		  		| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar campo C9__FILIAL ao liberar pedido (automatico)	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MTA410T()        
Local _aArea 	:= GetArea() 
Local aAreaSC6	:= SC6->( GetArea() )    
Local _aAreaSC9 := SC9->(GetArea())
//Local _cFilial	:= SC5->C5__FILIAL
/*Desabilitado - Jorge H - Setembro/2014
DbSelectArea("SC9")
DbSetOrder(1)  //C9_FILIAL+C9_PEDIDO+C9_ITEM+C9_SEQUEN+C9_PRODUTO
DbGoTop()
If DbSeek(xFilial("SC9") + SC5->C5_NUM)
	While !Eof() .And. xFilial("SC5") + SC5->C5_NUM == xFilial("SC9") + SC9->C9_PEDIDO
		if reclock("SC9", .F.)
			SC9->C9__FILIAL	:= _cFilial
			MsUnlock()
		endif
        DbSkip()
	EndDo
EndIf
*/          
/*
//Gravar itens do SC6 iguais aos itens do TMK(SUB)
	For nx := 1 To Len(aCols)
		If !Empty(aCols[nx][105]) .And. (aCols[nx][1] <> aCols[nx][105])
			aCols[nx][1] := aCols[nx][105]
		EndIf
	Next
*/
RestArea( aAreaSC6 )  
RestArea(_aAreaSC9)
RestArea(_aArea)

Return 