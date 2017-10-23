#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : TMK150EXC			 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         										      |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada p/ impedir a exclusão do pedido e do orçamento de vendas no Call Center  |
|---------------------------------------------------------------------------------------------------------|
*/

User Function TMK150EXC()

local aArea := getArea()

private lRet := .F.

MsgAlert("Pedido não pode ser Excluído.")

RestArea(aArea)

Return lRet 


User Function TMK150VLD()

local aArea := getArea()

private lRet := .F.

MsgAlert("Cotacao não pode ser Excluída.")

RestArea(aArea)

Return lRet
