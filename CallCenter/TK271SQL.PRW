#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK271SQL			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para filtrar de acordo com o segmento			  				|
|-----------------------------------------------------------------------------------------------|
*/

user Function TK271SQL()

local _aArea 	:= getArea()
local _cRet		:= ""
Local _cSegto 	:= ""
Local _cSegGrp	:= ""

dbSelectArea("SZ1")
dbSetOrder(1)
if dbSeek(xFilial("SZ1")+__cUserId)
	_cSegto := SZ1->Z1_SEGISP
else
	_cSegto := '0'
endif

if alltrim(_cSegto) <> '0'

	_cRet := "UA__SEGISP = '" + _cSegto + "' "

	dbSelectArea("SA1")                                  
	set filter to &("SA1->A1__SEGISP == '" + _cSegto + "' ")
			
	dbSelectArea("SB1")		
//	set filter to &("Posicione('SBM',1,xFilial('SBM')+SB1->B1_GRUPO,'BM__SEGISP') == '" + _cSegto + "' .Or. SB1->B1__SEGISP == '" + _cSegto + "' ")
	set filter to &("SB1->B1__SEGISP == '" + _cSegto + "' ")	

endif

restarea(_aArea)
return _cRet