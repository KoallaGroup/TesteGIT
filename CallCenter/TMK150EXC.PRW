#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : TMK150EXC			 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves Oliveira - Anadi	         										      |
|---------------------------------------------------------------------------------------------------------|
|	Descri��o : Ponto de entrada p/ impedir a exclus�o do pedido e do or�amento de vendas no Call Center  |
|---------------------------------------------------------------------------------------------------------|
*/

User Function TMK150EXC()

local aArea := getArea()

private lRet := .F.

MsgAlert("Pedido n�o pode ser Exclu�do.")

RestArea(aArea)

Return lRet 


User Function TMK150VLD()

local aArea := getArea()

private lRet := .F.

MsgAlert("Cotacao n�o pode ser Exclu�da.")

RestArea(aArea)

Return lRet
