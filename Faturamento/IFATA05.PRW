#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFATA05			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para Classificação de Clientes											 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFATA05()
             
	local _aArea 	:= getArea()
    private cCadastro	:= "Cadastro de Classificação de Clientes"    
    private aRotina	:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","U_IFATA05A()",0,3},;
						{"Alterar","U_IFATA05B()",0,4},;
						{"Excluir","U_IFATA05C()",0,5}}

	mBrowse(6,1,22,75,"SZH")
	
	restArea(_aArea)

return


user Function IFATA05A()
    
	lRet := .F.
	
	axInclui("SZH",,,,,,'lRet := .T.')      
	
	if lRet
		if reclock("SZH", .F.)
//			SZH->ZH_DTINCL	:= date()
//			SZH->ZH_HRINCL	:= time()		
		endif
	endif	

return

user Function IFATA05B()

	lRet := .F.

	axAltera("SZH",SZH->(RECNO()),3,,,,,'lRet := .T.')
	
	if lRet
		if reclock("SZH", .F.)
//			SZH->ZH_DTALT	:= date()
//			SZH->ZH_HRALT	:= time()		
		endif
	endif	

return


user Function IFATA05C()

	axDeleta("SZH",SZH->(RECNO()),4)
	
	if reclock("SZH", .F.)
//		SZH->ZH_DTALT	:= date()
//		SZH->ZH_HRALT	:= time()		
	endif

return