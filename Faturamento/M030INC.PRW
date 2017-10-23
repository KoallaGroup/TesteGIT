#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M030INC			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da inclusão no cadastro de cliente		  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _M030INC()

	if PARAMIXB == 1

		reclock("SA1",.f.)
		
//		SA1->A1__DTINCL := date()
//		SA1->A1__HRINCL	:= time()
		
		msUnlock()
		
	endif
		
return