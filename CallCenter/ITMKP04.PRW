#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKP04			  		| 	Janeiro de 2015 				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi									 		|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Funcao para popular o produto automatico na transferencia de chamados			|	
|               Esta funao esta dentro da consulta padrao TMKSU0								|
|-----------------------------------------------------------------------------------------------|
*/

USER FUNCTION ITMKP04 
Local _lRet		:= .T.
Local _cDepto	:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")

If FunName() == "TMKA510A"
	cProduto := "1000"  
EndIf



Return _lRet