

#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT410ACE			 		  		| 	Fevereiro de 2015					 		|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para Validacao das movimentacoes do Pedido de Venda   			|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT410ACE()

Local _aArea 	:= GetArea() 
Local aAreaSC5	:= SC5->( GetArea() )
Local lRet		:= .T.

If (!Empty(Alltrim(SC5->C5__NUMSUA))) .And. FunName() == "MATA410"
	If (ParamIxb[1] == 4) .OR. (ParamIxb[1] == 1) .OR. (ParamIxb[1] == 3)  
		Help( Nil, Nil, "SEMPERMISSAO", Nil, "Pedido gerado pelo Call Center, nao e permitido realizar esta acao!", 1, 0 ) 
		lRet := .F.
	EndIf
EndIf

RestArea(aAreaSC5)
RestArea(_aArea)

Return lRet