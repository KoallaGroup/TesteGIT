#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IFATA08			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         											|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Programa para gravação do Status dos Pedidos									 		|
|-------------------------------------------------------------------------------------------------------|
*/

user Function IFATA08()

local _aArea 		:= getArea()
private cCadastro	:= "Cadastro de Tipos de Pedidos"
private aRotina		:= {{"Visualizar"	,"axVisual"		,0,2},;
						{"Incluir"		,"U_IFATA08A()"	,0,3},;
						{"Alterar"		,"U_IFATA08B()"	,0,4},;
						{"Excluir"		,"U_IFATA08C()"	,0,5}}

mBrowse(6,1,22,75,"SZM")

restArea(_aArea)

return


user Function IFATA08A()

lRet := .F.

axInclui("SZM",,,,,,'lRet := .T.')

if lRet
	if reclock("SZM", .F.)
//		SZM->ZM_DTINCL	:= date()
//		SZM->ZM_HRINCL	:= time()
		MsUnlock()
	endif
endif

return

user Function IFATA08B()

lRet := .F.

axAltera("SZM",SZM->(RECNO()),3,,,,,'lRet := .T.')

if lRet
	if reclock("SZM", .F.)
//		SZM->ZM_DTALT	:= date()
//		SZM->ZM_HRALT	:= time()
	endif
endif

return


user Function IFATA08C()

axDeleta("SZM",SZM->(RECNO()),4)

if reclock("SZM", .F.)
//	SZM->ZM_DTALT	:= date()
//	SZM->ZM_HRALT	:= time()
endif

return
