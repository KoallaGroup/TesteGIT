#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M440STTS	 		  		| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar campo C9__FILIAL ao liberar pedido				  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function M440STTS()        
Local _aArea 	:= GetArea()        
Local _aAreaSC9 := SC9->(GetArea())

U_IRECWMS('SC5')

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
RestArea(_aAreaSC9)
RestArea(_aArea)

Return 