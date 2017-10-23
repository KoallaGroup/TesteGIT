#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|	
|	Programa : F100BROW					| 	Marco de 2015		    											|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Marcus Feixas       																     	|
|---------------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para filtrar no movimento bancário somente usuarios que estao no parametro     |
|               Titulos da Contabilidade                                                                        |
|---------------------------------------------------------------------------------------------------------------|	
*/

User function F100BROW()
//----------------------
Local bCondicao 


if  !(__cUserID $  GETMV("MV__USRCTB")) // Somente entra se o Usuario for da Folha
   return 
EndIf                     


bCondicao:= " E5_TIPO == 'GNR' "

DbSelectArea("SE5")
DbSetOrder(1)
set filter to &bCondicao

DbGoBottom()

Return   
