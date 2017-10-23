#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT010INC			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da alteração no cadastro de produtos		  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _MT010INC()

	reclock("SB1",.F.)
	
//	SB1->B1__DTINCL	:= date()
//	SB1->B1__HRINCL	:= time()
	
	msUnlock()
	
return