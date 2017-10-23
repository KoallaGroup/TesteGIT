#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MA050TTS			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar hora da inclusão no cadastro de transportadoras  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function _MA050TTS()

	reclock("SA4",.f.)

	if Inclui
//		SA4->A4__DTINCL := date()
//		SA4->A4__HRINCL	:= time()
	endif
	
	if Altera
//		SA4->A4__DTALT 	:= date()
//		SA4->A4__HRALT	:= time()
	endif
	
	msUnlock()
	
return