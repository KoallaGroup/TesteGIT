#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT010ALT			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de Entrada para gravar hora da altera��o no cadastro de produtos		  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _MT010ALT()

	reclock("SB1",.F.)
	
//	SB1->B1__DTALT 	:= date()
//	SB1->B1__HRALT	:= time()
	
	msUnlock()
	
return