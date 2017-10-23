#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT120FIL			  		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar de acordo com o segmento	   					  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT120FIL() 
	
	local _aArea := getArea()
	local _cRet	:= ""  
	local _cSegTip := ""
                                  
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto  := SZ1->Z1_SEGISP  
		_cSegTip := SZ1->Z1_SEGTIP
	else 
		_cSegto := '0'
	endif	

	if _cSegto <> '0'
		_cRet := ' SC7->C7__SEGISP == "' + _cSegto + '" '
	endif           
	                                   	
	If _cSegTip == "2"
	    _cRet += IIF(Empty(_cRet),""," .And. ")
		_cRet += "posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE +SC7->C7_LOJA,'A2_EST') == 'EX' "
	Else
	   _cRet += IIF(Empty(_cRet),""," .And. ")
	   _cRet += "posicione('SA2',1,xFilial('SA2')+SC7->C7_FORNECE +SC7->C7_LOJA,'A2_EST') != 'EX' "
	EndIf
		
	restarea(_aArea)
	
return _cRet