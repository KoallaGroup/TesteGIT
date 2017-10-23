#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : VALSEGTO			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Validação do segmento 														  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function VALSEGTO(_cValor)
          
	local _aArea := getArea()
	local _lRet  := .T.
    
	dbSelectArea("SZ7")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ7")+_cValor)
		msgAlert("Segmento não cadastrado !!")
		_lRet := .F.
	endif

	restarea(_aArea)

return _lRet
