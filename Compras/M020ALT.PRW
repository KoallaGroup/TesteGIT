#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M020ALT			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de Entrada para gravar hora da altera��o no cadastro de fornecedor	  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _M020ALT()

	reclock("SA2",.F.)
	
//	SA2->A2__DTALT 	:= date()
//	SA2->A2__HRALT	:= time()
	
	msUnlock()
	
return