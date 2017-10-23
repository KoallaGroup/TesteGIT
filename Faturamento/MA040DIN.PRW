#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MA040DIN			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da inclusao no cadastro de vendedores			 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function _MA040DIN()

	reclock("SA3",.F.)  

//	SA3->A3__DTINCL	:= date()
//	SA3->A3__HRINCL	:= time()
		
	msUnlock()
	
return