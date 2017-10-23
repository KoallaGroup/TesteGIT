#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFINA08			  		| 	Junho de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi										         		|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Status do Titulo                        										 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFINA08()
             
	local _aArea 	:= getArea()
    private cCadastro	:= "Cadastro do Status do Título"    
    private aRotina	:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","U_IFINA08A()",0,3},;
						{"Alterar","U_IFINA08B()",0,4},;
						{"Excluir","U_IFINA08C()",0,5}}

	mBrowse(6,1,22,75,"SZU")
	
	restArea(_aArea)

return


user Function IFINA08A()
    
	lRet := .F.
	
	axInclui("SZU",,,,,,'lRet := .T.')      

return

user Function IFINA08B()

	lRet := .F.

	axAltera("SZU",SZU->(RECNO()),3,,,,,'lRet := .T.')

return


user Function IFINA08C()

	axDeleta("SZU",SZU->(RECNO()),4)
	
return