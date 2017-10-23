#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATCR13				| 	Abril de 2015										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório Comparativo de Faturamento											|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFATCR13()    
	    
	local _aArea := GetArea()
    local _cPerg := "IFATCR13" 
    
	AjustSX1(_cPerg)
	
	if !pergunte(_cPerg)
		return
	endif
	
	cParms := padl(MV_PAR01,2,"0") + ";" 
	cParms += padl(MV_PAR02,2,"0") + ";" 				
	cParms += alltrim(MV_PAR03) + ";"
	cParms += alltrim(MV_PAR04) + ";"
	cParms += alltrim(MV_PAR05) + ";"
	cParms += alltrim(MV_PAR06) + ";"
	cParms += alltrim(MV_PAR07) + ";"
	cParms += alltrim(MV_PAR08) + ";" 
	
	if MV_PAR10 == 1
		cParms += "S"
	else
		cParms += "N"
	endif

	if MV_PAR09 == 1    
		x:="1;0;1;IFATCR13B" 
	    CallCrys("IFATCR13B", cParms, x)
	else
		x:="1;0;1;IFATCR13" 
	    CallCrys("IFATCR13", cParms, x)

	    sleep(3000)

		x:="1;0;1;IFATCR13C" 
	    CallCrys("IFATCR13C", cParms, x)
	    
	endif
	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	local _aArea := GetArea()
	local aPergs := {}
	
	Aadd(aPergs,{"Mes de"				,"","","mv_ch1","C",02,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Mes até"				,"","","mv_ch2","C",02,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})

	Aadd(aPergs,{"Ano 1"				,"","","mv_ch3","C",04,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ano 2"				,"","","mv_ch4","C",04,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})

	Aadd(aPergs,{"Representante de"		,"","","mv_ch5","C",tamSX3("A3_COD")[1],0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
	Aadd(aPergs,{"Representante até"	,"","","mv_ch6","C",tamSX3("A3_COD")[1],0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})

	Aadd(aPergs,{"Cliente de"	  		,"","","mv_ch7","C",tamSX3("A1_COD")[1],0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA1CLI"	,"","","",""})
	Aadd(aPergs,{"Cliente até" 			,"","","mv_ch8","C",tamSX3("A1_COD")[1],0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SA1CLI"	,"","","",""})

	Aadd(aPergs,{"Tipo de Relatório"	,"","","mv_ch9","C",01,0,0,"C","","MV_PAR09","Sintético","","","","","Analíticco","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Inclui IPI"			,"","","mv_ch10","C",01,0,0,"C","","MV_PAR10","Sim","","","","","Não","","","","","","","","","","","","","","","","","","","","","","",""})


	AjustaSx1(_cPerg,aPergs)
	
	RestArea (_aArea)

Return(_cPerg)                                                                                                     
