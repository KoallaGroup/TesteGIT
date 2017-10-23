
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATR01				| 	Junho de 2014										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório GNRE																	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFATR01()    
	    
	local _aArea := GetArea()
    local _cPerg := "IFATR01"

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
		Return
	EndIf

	cParms := MV_PAR01+";"+MV_PAR02+";"+MV_PAR03+";"+MV_PAR04 
	x:="1;0;1;IFATR01" 
	         
	CallCrys("IFATR01",cParms, x)
	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
	
	PutSx1(_cPerg,"01","Nota Fiscal de"," "," ","mv_ch1","C",06,0,0,"G","" ,"","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"02","Nota Fiscal ate"," "," ","mv_ch2","C",06,0,0,"G","" ,"","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"03","Série de"," "," ","mv_ch3","C",06,0,0,"G","" ,"","","","mv_par03","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"04","Série ate"," "," ","mv_ch4","C",06,0,0,"G","" ,"","","","mv_par04","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	RestArea (_aArea)

Return(_cPerg)