#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFOLR001				| 	Janeiro de 2015										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Extrato de Comissões dos Vendedores												|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFOLR001()    
	    
	local _aArea 	:= GetArea()
    local _cPerg 	:= "IFOLR001"
	local _nRepDe	:= 0
	local _nRepAte	:= 999999
    
	AjustSX1(_cPerg)
	
	if !pergunte(_cPerg)
		return
	endif

	if MV_PAR05 = '1'
		MV_PAR05 := "('1')"		
	elseif MV_PAR05 = '2'
		MV_PAR05 := "('2')"		
	else
		MV_PAR05 := "('1','2')"
	endif

//Colocado tratativa de representante abaixo, pois não retornava o código ao puxar pelo F3, pois estava numérico e agora passado para caracter. Rogério 10/08/15
    
	If Empty(MV_PAR03)
		MV_PAR03 := "0"
	EndIf

	If Empty(MV_PAR04)
		MV_PAR04 := "999999"		
	EndIf
					
	_nRepDe 	:= Val(MV_PAR03)

	_nRepAte	:= Val(MV_PAR04)

///////////
	
	cParms := dtos(MV_PAR01) + ";" + dtos(MV_PAR02) + ";" + alltrim(str(_nRepDe)) + ";" + alltrim(str(_nRepAte)) + ";" + MV_PAR05

	x:="1;0;1;IFOLR001" 
	         
	CallCrys("IFOLR001", cParms, x)
	
	restArea (_aArea)
	
return


Static Function AjustSX1(_cPerg)

	local _aArea := GetArea()
	local aPergs := {}
	
	Aadd(aPergs,{"Vendas de"			,"","","mv_ch1","D",08						,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Vendas até"			,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Representante de"		,"","","mv_ch3","C",TamSx3("A3_COD")[1]		,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
	Aadd(aPergs,{"Representante até"	,"","","mv_ch4","C",TamSx3("A3_COD")[1]		,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
	Aadd(aPergs,{"Segmento"				,"","","mv_ch5","C",TamSx3("A3__SEGISP")[1]	,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})

	//Aadd(aPergs,{"Representante de"		,"","","mv_ch3","N",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
	//Aadd(aPergs,{"Representante até"	,"","","mv_ch4","N",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
	
	AjustaSx1(_cPerg,aPergs)
	
	RestArea (_aArea)

Return(_cPerg)                                                                                                     
