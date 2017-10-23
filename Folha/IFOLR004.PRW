#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFOLR004				| 	Fevereiro de 2015									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de Comissões dos Vendedores											|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFOLR004()    
	    
	local _aArea := GetArea()
    local _cPerg := "IFOLR004" 
    
	AjustSX1(_cPerg)
	
	if !pergunte(_cPerg)
		return
	endif
	
	if MV_PAR03 > 3
		_cSeg := "'" + MV_PAR03 + "'"
	else
		_cSeg := "'1','2'"
	endif

	cParms := dtos(MV_PAR01) + ";" + dtos(MV_PAR02) + ";" + _cSeg

	if MV_PAR04 == 1
		x:="1;0;1;IFOLR004" 
		CallCrys("IFOLR004", cParms, x)
	else
		x:="1;0;1;IFOLR005" 
		CallCrys("IFOLR005", cParms, x)
	endif

	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	local _aArea := GetArea()
	local aPergs := {}
	
	Aadd(aPergs,{"Vendas de"	,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Vendas até"	,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Segmento"		,"","","mv_ch3","C",01,0,0,"C","","MV_PAR03","Bike","","","","","Auto","","","","","Ambos","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Tipo"			,"","","mv_ch4","C",01,0,0,"C","","MV_PAR04","Sintetico","","","","","Analitico","","","","","","","","","","","","","","","","","","","","","","",""})

	AjustaSx1(_cPerg,aPergs)
	
	RestArea (_aArea)

Return(_cPerg)                                                                                                     
