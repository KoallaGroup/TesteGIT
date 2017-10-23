#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IESTA06			  		| 	Abril de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         											|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Programa para gravação do Status no Cadastro das Embalagens						 		|
|-------------------------------------------------------------------------------------------------------|
*/

user Function IESTA06()

local _aArea 		:= getArea()
private cCadastro	:= "Cadastro de Tipos de Pedidos"
private aRotina		:= {{"Visualizar"	,"axVisual"		,0,2},;
						{"Incluir"		,"U_IESTA06A()"	,0,3},;
						{"Alterar"		,"U_IESTA06B()"	,0,4},;
						{"Excluir"		,"U_IESTA06C()"	,0,5}}

mBrowse(6,1,22,75,"SZS")

restArea(_aArea)

return


user Function IESTA06A()

lRet := .F.

axInclui("SZS",,,,,,'lRet := .T.')

if lRet
	if reclock("SZS", .F.)
//		SZS->ZS_DTINCL	:= date()
//		SZS->ZS_HRINCL	:= time()
		MsUnlock()
	endif
endif

return

user Function IESTA06B()

lRet := .F.

axAltera("SZS",SZS->(RECNO()),3,,,,,'lRet := .T.')

if lRet
	if reclock("SZS", .F.)
//		SZS->ZS_DTALT	:= date()
//		SZS->ZS_HRALT	:= time()
	endif
endif

return


user Function IESTA06C()

axDeleta("SZS",SZS->(RECNO()),4)

if reclock("SZS", .F.)
//	SZS->ZS_DTALT	:= date()
//	SZS->ZS_HRALT	:= time()
endif

return