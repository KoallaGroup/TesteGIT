#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA040MNU			  		| 	Mar�o de 2014									|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Inclus�o de A��o em A��es Relacionadas do cadastro de vendedor	   				|
|-----------------------------------------------------------------------------------------------|	
*/

user Function MTA040MNU()

	local aButton := {}
	
	aadd(aRotina,{'Vendedor x Transportador'				,'U_IFATA06()' , 0 , 4,0,NIL})	
//	aadd(aRotina,{'Vendedor x Transportadora x Redespacho'	,'U_IFATA07()' , 0 , 2,0,NIL})   		// comentado em 18/08/14 por Rog�rio

return aButton