#Include "Protheus.ch"
#include "Rwmake.ch"
/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MA103OPC			  		| 		Agosto de 2014				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descri��o : Inclus�o de A��o Relacionada aos dados complementares de importa��o na Nota de Entrada	|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function MA103OPC()
Local aRet := {}

aAdd(aRet,{'Nota Fiscal Importa��o','U_ICOMP05()', 0, 4})	

Return(aRet)
                                               
