#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK271ABR 		  		| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para possibilitar alteracao/inclusao/exclusao de atendimento	|
|-----------------------------------------------------------------------------------------------|
*/

User Function TK271ABR()
	Local lRet := .T.
	Local cStatPed 	:= '1'
	 
	if(SUA->UA_OPER == '1' .AND. (!INCLUI .AND. ALTERA)) 
		if(alltrim(SUA->UA__STATUS) <> cStatPed)
			lRet := .F.
			alert("Pedido deverá ser reativado através da opção Reabertura de Pedido")
		EndIf
	EndIf
	
Return lRet