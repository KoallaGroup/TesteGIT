#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : F050BROW					| 	Marco de 2015		    											|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Marcus Feixas       																     	|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para filtrar no contas a Pagar somente usuarios que estao no parametro para    |
|               Titulos dos Gestao de Pessoal                                                                   |
|---------------------------------------------------------------------------------------------------------------|	
*/

user function F050BROW()
//----------------------
Local bCondicao 


if  !(__cUserID $  GETMV("MV__USRGPE")) // Somente entra se o Usuario for da Folha
   return 
EndIf                     


bCondicao:= " E2_PREFIXO == 'GPE' "

DbSelectArea("SE2")
DbSetOrder(1)
set filter to &bCondicao

DbGoBottom()

Return   



