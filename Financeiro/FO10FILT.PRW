/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : FO10FILT			  		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi						    							|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para adicionar condições na filtragem dos titulos na tela de   |
|				posição do cliente. Atualmente utilizado para desconsiderar NCC nos títulos     |
|-----------------------------------------------------------------------------------------------|	
*/

User function FO10FILT()       
Local _cQuery 	:= " E1_TIPO != 'NCC' AND "

Return _cQuery