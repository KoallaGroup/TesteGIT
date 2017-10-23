#Include "Protheus.ch"
#include "Rwmake.ch"
/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MA103OPC			  		| 		Agosto de 2014				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Inclusão de Ação Relacionada aos dados complementares de importação na Nota de Entrada	|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function MA103OPC()
Local aRet := {}

aAdd(aRet,{'Nota Fiscal Importação','U_ICOMP05()', 0, 4})	

Return(aRet)
                                               
