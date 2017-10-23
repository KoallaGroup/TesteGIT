#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MT360GRV			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da alteração no cadastro de condiçoes de pagamento 	|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function _MT360GRV()

	reclock("SE4",.F.)  
           
	if Inclui
//		SE4->E4__DTINCL	:= date()
//		SE4->E4__HRINCL	:= time()
	endif
	if Altera
//		SE4->E4__DTALT	:= date()
//		SE4->E4__HRALT	:= time()
	endif
				
	msUnlock()
	
return