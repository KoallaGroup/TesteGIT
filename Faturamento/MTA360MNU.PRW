#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : MTA360MNU			  		| 	Março de 2014									|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Programa criado para filtrar de acordo com o segmento	   					  	|
|-----------------------------------------------------------------------------------------------|
*/

user Function MTA360MNU()

local _cSegto := ""

if funname() == 'MATA360'
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto := SZ1->Z1_SEGISP
	else
		_cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])
	endif
	
	if _cSegto <> '0'
		dbSelectArea("SE4")
		set filter to &("E4__SEGISP == '" + _cSegto + "' .Or. E4__SEGISP == '" + PADR('0',TamSX3("Z1_SEGISP")[1]) + "' ")
	endif
endif

return
