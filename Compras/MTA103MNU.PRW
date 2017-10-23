#include "protheus.ch"
#include "Rwmake.ch"
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MA103BUT			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Inclusão de Ação Relacionada no menu de Nota de Entrada						  	|
|-----------------------------------------------------------------------------------------------|	
*/
user Function MA103BUT()
	
	local aButton := {}
	
	if ! Inclui .and. ! Altera
	
		Aadd( aButton, {"EDIT", { || U_ICOMA02() },"Alterar Data Nota" } )
		Aadd( aButton, {"EDIT", { || U_ICOMA03("SF1",SF1->(RECNO()),4) },"Virada de TES" } )
	
	endif

return aButton