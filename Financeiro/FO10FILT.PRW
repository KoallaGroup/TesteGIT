/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : FO10FILT			  		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi						    							|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de entrada para adicionar condi��es na filtragem dos titulos na tela de   |
|				posi��o do cliente. Atualmente utilizado para desconsiderar NCC nos t�tulos     |
|-----------------------------------------------------------------------------------------------|	
*/

User function FO10FILT()       
Local _cQuery 	:= " E1_TIPO != 'NCC' AND "

Return _cQuery