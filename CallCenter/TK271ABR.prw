#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK271ABR 		  		| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Ponto de Entrada para possibilitar alteracao/inclusao/exclusao de atendimento	|
|-----------------------------------------------------------------------------------------------|
*/

User Function TK271ABR()
	Local lRet := .T.
	Local cStatPed 	:= '1'
	 
	if(SUA->UA_OPER == '1' .AND. (!INCLUI .AND. ALTERA)) 
		if(alltrim(SUA->UA__STATUS) <> cStatPed)
			lRet := .F.
			alert("Pedido dever� ser reativado atrav�s da op��o Reabertura de Pedido")
		EndIf
	EndIf
	
Return lRet