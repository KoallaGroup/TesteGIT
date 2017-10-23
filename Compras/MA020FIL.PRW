#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MA020FIL			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar os fornecedores								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MA020FIL() 
	
	local _aArea := getArea()
	local _cRet	:= "", _cSegto := ""
                                  
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto := SZ1->Z1_SEGISP
//	else
//		_cSegto := '0'
	endif	

	if _cSegto <> '0'
		_cRet := ' SA2->A2__SEGISP == "' + _cSegto + '" .Or. Alltrim(SA2->A2__SEGISP) == "0" '
	endif

	restarea(_aArea)
	
return _cRet