#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M460FIL 			  		| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar os produtos									  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function M460FIL ()    
//_cQuery := " C9_FILIAL == '" + xFilial("SC9") + "' .And. C9__QTDMHA == C9_QTDLIB " --comentado para nao travar os testes. Jorge
_cQuery := " C9_FILIAL == '" + xFilial("SC9") + "' "
   
Return _cQuery