#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M460QRY 			  		| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar os produtos									  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function M460QRY ()    
//_cQuery := paramixb[1] + " AND SC9.C9_FILIAL = '" + xFilial("SC9") + "' And SC9.C9__QTDMHA = SC9.C9_QTDLIB "--comentado para nao travar os testes. Jorge
_cQuery := paramixb[1] + " AND SC9.C9_FILIAL = '" + xFilial("SC9") + "' "   
Return _cQuery