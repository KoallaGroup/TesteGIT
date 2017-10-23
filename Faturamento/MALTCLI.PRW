#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MALTCLI			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da alteração no cadastro de cliente		  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _MALTCLI()

	reclock("SA1",.F.)
	
//	SA1->A1__DTALT := date()
//	SA1->A1__HRALT	:= time()
	
	msUnlock()
	
return