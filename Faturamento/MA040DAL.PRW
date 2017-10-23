#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MA040DAL			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da alteração no cadastro de vendedores			 	|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function _MA040DAL()

	reclock("SA3",.F.)  

//	SA3->A3__DTALT	:= date()
//	SA3->A3__HRALT	:= time()
		
	msUnlock()
	
return