#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFATA03			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para gravação de Tipo de Pedidos										 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFATA03()
             
	local _aArea 	:= getArea()
    private cCadastro	:= "Cadastro de Tipos de Pedidos"    
    private aRotina	:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","U_IFATA03A()",0,3},;
						{"Alterar","U_IFATA03B()",0,4},;
						{"Excluir","U_IFATA03C()",0,5}}

	mBrowse(6,1,22,75,"SZF")
	
	restArea(_aArea)

return


user Function IFATA03A()
    
	lRet := .F.
	
	axInclui("SZF",,,,,,'lRet := .T.')      
	
	if lRet
		if reclock("SZF", .F.)
//			SZF->ZF_DTINCL	:= date()
//			SZF->ZF_HRINCL	:= time()		
			MsUnlock()
		endif
	endif	

return

user Function IFATA03B()

	lRet := .F.

	axAltera("SZF",SZF->(RECNO()),3,,,,,'lRet := .T.')
	
	if lRet
		if reclock("SZF", .F.)
//			SZF->ZF_DTALT	:= date()
//			SZF->ZF_HRALT	:= time()		
		endif
	endif	

return


user Function IFATA03C()

	axDeleta("SZF",SZF->(RECNO()),4)
	
	if reclock("SZF", .F.)
//		SZF->ZF_DTALT	:= date()
//		SZF->ZF_HRALT	:= time()		
	endif

return