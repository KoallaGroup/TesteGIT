#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MA030BRW			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar os clientes									  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MA030BRW() 
	
	local _aArea := getArea()
	local _cRet	:= ""
                                  
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto := SZ1->Z1_SEGISP
	else
		_cSegto := '0'
	endif	

	if _cSegto <> '0'
		_cRet := ' SA1->A1__SEGISP == "' + _cSegto + '"'
	endif

	restarea(_aArea)
	
return _cRet