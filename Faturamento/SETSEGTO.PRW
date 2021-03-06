#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : SETSEGTO			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Fun��o para verificar o segmento do usu�rio									  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function SETSEGTO()
          
	local _aArea := getArea()

	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto := SZ1->Z1_SEGISP
	else
		_cSegto := '0'
	endif

	restarea(_aArea)

return _cSegto
