#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M020INC			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de Entrada para gravar hora da inclus�o no cadastro de fornecedores	  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _M020INC()

	reclock("SA2",.f.)
	
//	SA2->A2__DTINCL := date()
//	SA2->A2__HRINCL	:= time()
	
	msUnlock()
	
return