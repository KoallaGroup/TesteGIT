#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MT360GRV			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de Entrada para gravar hora da altera��o no cadastro de condi�oes de pagamento 	|
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