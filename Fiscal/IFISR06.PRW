#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFISR06				| 	Fevereiro de 2015									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatórios Fundap																|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFISR06()    
	    
	local _aArea := GetArea()
    local _cPerg := "IFISR06" 
    
	AjustSX1(_cPerg)
	
	if !pergunte(_cPerg)
		return
	endif
	
	if MV_PAR03 < 3
		_cSeg := "'" + alltrim(str(MV_PAR03)) + "'"
	else
		_cSeg := "'1','2'"
	endif

	cParms := dtos(MV_PAR01) + ";" + dtos(MV_PAR02) + ";" + _cSeg + ";" + MV_PAR05

	if MV_PAR04 == 2
		x:="1;0;1;IFISCR006" 
		CallCrys("IFISCR006", cParms, x)
	else
		x:="1;0;1;IFISCR007" 
		CallCrys("IFISCR007", cParms, x)
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
	Aadd(aPergs,{"Local"		,"","","mv_ch5","C",TamSx3("UA_FILIAL")[1]  ,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","DLB" ,"","","",""})

	AjustaSx1(_cPerg,aPergs)
	
	RestArea (_aArea)

Return(_cPerg)                                                                                                     
