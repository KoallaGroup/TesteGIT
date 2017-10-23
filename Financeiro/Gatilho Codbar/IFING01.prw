#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFING01			  		| 	Março de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi					   											|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para tratar loja de clientes do CNAB									 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function IFING01(_nTipo)
Local _aArea 	:= GetArea() 
Local _aAreaSA1 := SA1->(GetArea())
Local _cRet		:= ""
                         
Do Case
	Case _nTipo = 1
		_cRet := IIF(SA1->A1_LOJA != SA1->A1__LJACOB .AND. !Empty(SA1->A1__LJACOB),Posicione("SA1",1,xFilial("SA1") + SA1->A1_COD + SA1->A1__LJACOB,"A1_END"),SA1->A1_END)
	Case _nTipo = 2
		_cRet := IIF(SA1->A1_LOJA != SA1->A1__LJACOB .AND. !Empty(SA1->A1__LJACOB),Posicione("SA1",1,xFilial("SA1") + SA1->A1_COD + SA1->A1__LJACOB,"A1_BAIRRO"),SA1->A1_BAIRRO)
	Case _nTipo = 3
		_cRet := IIF(SA1->A1_LOJA != SA1->A1__LJACOB .AND. !Empty(SA1->A1__LJACOB),Posicione("SA1",1,xFilial("SA1") + SA1->A1_COD + SA1->A1__LJACOB,"A1_CEP"),SA1->A1_CEP)
	Case _nTipo = 4
		_cRet := IIF(SA1->A1_LOJA != SA1->A1__LJACOB .AND. !Empty(SA1->A1__LJACOB),Posicione("SA1",1,xFilial("SA1") + SA1->A1_COD + SA1->A1__LJACOB,"A1_MUN"),SA1->A1_MUN)
	Case _nTipo = 5
		_cRet := IIF(SA1->A1_LOJA != SA1->A1__LJACOB .AND. !Empty(SA1->A1__LJACOB),Posicione("SA1",1,xFilial("SA1") + SA1->A1_COD + SA1->A1__LJACOB,"A1_EST"),SA1->A1_EST)
EndCase

RestArea(_aAreaSA1)
RestArea(_aArea)

Return _cRet