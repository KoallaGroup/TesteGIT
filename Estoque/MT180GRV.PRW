#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MT180GRV			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da alteração no cadastro de complemento de produtos 	|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function _MT180GRV()

	reclock("SB5",.F.)  

	if Inclui	
//		SB5->B5__DTINCL	:= date()
//		SB5->B5__HRINCL	:= time()
	endif
	
	if Altera	
//		SB5->B5__DTALT	:= date()
//		SB5->B5__HRALT	:= time()
	endif
		
	msUnlock()
	
return