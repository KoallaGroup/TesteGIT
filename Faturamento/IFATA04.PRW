#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFATA04			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para gravação de Vias de Transporte									 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFATA04()
             
	local _aArea 	:= getArea()
    private cCadastro	:= "Cadastro de Vias de Transporte"    
    private aRotina	:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","U_IFATA04A()",0,3},;
						{"Alterar","U_IFATA04B()",0,4},;
						{"Excluir","U_IFATA04C()",0,5}}

	mBrowse(6,1,22,75,"SZG")
	
	restArea(_aArea)

return


user Function IFATA04A()
    
	lRet := .F.
	
	axInclui("SZG",,,,,,'lRet := .T.')      
	
	if lRet
		if reclock("SZG", .F.)
//			SZG->ZG_DTINCL	:= date()
//			SZG->ZG_HRINCL	:= time()		
		endif
	endif	

return

user Function IFATA04B()

	lRet := .F.

	axAltera("SZG",SZG->(RECNO()),3,,,,,'lRet := .T.')
	
	if lRet
		if reclock("SZG", .F.)
//			SZG->ZG_DTALT	:= date()
//			SZG->ZG_HRALT	:= time()		
		endif
	endif	

return


user Function IFATA04C()

	axDeleta("SZG",SZG->(RECNO()),4)
	
	if reclock("SZG", .F.)
//		SZG->ZG_DTALT	:= date()
//		SZG->ZG_HRALT	:= time()		
	endif

return