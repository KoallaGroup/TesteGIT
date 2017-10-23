#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M410VRES			 		  		| 	Fevereiro de 2015					 		|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi											|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para Validacao da ELIMINACAO DE RESIDUOS do Pedido de Venda	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function M410VRES()

Local _aArea 	:= GetArea() 
Local aAreaSC5	:= SC5->( GetArea() )
Local lRet		:= .T.

If (!Empty(Alltrim(SC5->C5__NUMSUA)))
	Help( Nil, Nil, "SEMPERMISSAO", Nil, "Pedido gerado pelo Call Center, rotina nao pode ser executada!", 1, 0 ) 
	lRet := .F.
EndIf

RestArea(aAreaSC5)
RestArea(_aArea)

Return lRet