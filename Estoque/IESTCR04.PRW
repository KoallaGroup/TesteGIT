#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTCR04				| 	Março de 2015	   									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de Pedidos Aguardando Materiais										|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTCR04()    
	    
	local _aArea := GetArea()
    local _cPerg := "IESTCR04" 
    
	AjustSX1(_cPerg)
	
	if !pergunte(_cPerg)
		return      
	endif
	
	if MV_PAR03 < 3
		_cSeg := "'" + alltrim(str(MV_PAR03)) + "'"
	else
		_cSeg := "'1','2'"
	endif

	cParms := MV_PAR01 + ";" + MV_PAR02 + ";" + _cSeg + ";" + MV_PAR04

	x:="1;0;1;IESTCR04" 
	CallCrys("IESTCR04", cParms, x)
	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	local _aArea := GetArea()
	local aPergs := {}
	
	Aadd(aPergs,{"Pedido de"	,"","","mv_ch1","C",06,0,0,"C","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Pedido até"	,"","","mv_ch2","C",06,0,0,"C","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Segmento"		,"","","mv_ch3","C",01,0,0,"C","","MV_PAR03","Bike","","","","","Auto","","","","","Ambos","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Filial"		,"","","mv_ch4","C",TamSx3("D2_FILIAL")[1]	,0,0,"G","Vazio() .OR. existCpo('SM0',cEmpAnt+MV_PAR04)" 	,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SM0" 	,"","","",""})

	AjustaSx1(_cPerg,aPergs)
	
	RestArea (_aArea)

Return(_cPerg)                                                                                                     
