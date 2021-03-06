#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IGENM26			  		| 	Junho de 2016					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves Oliveira - Anadi		         								|
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Fun��o para verificar o segmento do usu�rio									  	|
|-----------------------------------------------------------------------------------------------|
*/

user function IGENM26()	// #Execblock("IGENM26",.F.,.F.)

local _aArea 	:= getArea()
local _cSegto	:= ""

dbSelectArea("SZ1")
dbSetOrder(1)
if dbSeek(xFilial("SZ1")+__cUserId)
	_cSegto := SZ1->Z1_SEGISP
endif

If Val(_cSegto) != 0
	_cSegto := "SBM->BM__SEGISP == '" + _cSegto + "' "
Else
	_cSegto := "SBM->BM__SEGISP == '" + PADR(Alltrim(Str(Val(_cSegUsr))),TamSX3("Z1_SEGISP")[1]) + "' "
EndIf

restarea(_aArea)

return _cSegto
