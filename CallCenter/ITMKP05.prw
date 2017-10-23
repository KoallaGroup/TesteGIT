#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKP05			  		| 	Março de 2015 				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi									 					|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Funcao para popular o Limite de Crédito do cliente com base no parametro		|	
|               MV_CREDCLI, que define se o limite é calculado por cliente ou loja				|
|				Função chamada por gatilho pelos campos PA3_CODCLI e PA3_LOJA					|
|-----------------------------------------------------------------------------------------------|
*/

User Function ITMKP05()
Local _aArea 	:= GetArea()
Local _aAreaSA1 := SA1->(GetArea())
Local nLim		:= 0
Local cChave 	:= xFilial("SA1") + SA1->A1_COD         

If(GetMV("MV_CREDCLI") == "L")
	nLim := SA1->A1_LC //(SA1->A1_LC - SA1->A1_SALDUP - SA1->A1_SALPEDL)
Else
	SA1->(DbSetOrder(1))
	SA1->(DbSeek(cChave))
	While cChave == (xFilial("SA1") + SA1->A1_COD)
		nLiM += SA1->A1_LC
		SA1->(DbSkip())
	EndDo
EndIf

RestArea(_aAreaSA1)
RestArea(_aArea)

Return nLim