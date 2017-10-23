#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTCR03				| 	Outubro de 2014										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de custo dos produtos vendidos										|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTCR03()    
	    
	local _aArea := GetArea()
    local _cPerg := "IESTCR03"

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) 	// Carrega as Perguntas do SX1
		Return
	EndIf
	
	cParms := MV_PAR01 + ";"
	cParms += MV_PAR02 + ";"
	cParms += MV_PAR03 + ";"
	cParms += MV_PAR04 + ";"
	cParms += MV_PAR05 + ";"
	cParms += MV_PAR06 + ";"
	cParms += MV_PAR07 + ";"
	cParms += MV_PAR08 + ";"
	cParms += dtos(MV_PAR09) + ";"
	cParms += dtos(MV_PAR10) + ";"
	cParms += dtos(MV_PAR11) + ";"
	cParms += dtos(MV_PAR12) + ";"
	cParms += Alltrim(Str(MV_PAR13)) + ";"
	cParms += Alltrim(Str(MV_PAR14)) + ";"
	cParms += Alltrim(Str(MV_PAR15)) + ";"
	cParms += Alltrim(Str(MV_PAR16)) + ";"
	x:="1;0;1;IESTCR03" 

	CallCrys("IESTCR03",cParms, x)

	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
	
	PutSx1(_cPerg,"01","Filial"		  				," "," ","mv_ch1" ,"C",02,0,0,"G","" ,"SM0","","","mv_par01","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"02","Grupo de"	  				," "," ","mv_ch2" ,"C",04,0,0,"G","" ,"SBM","","","mv_par02","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"03","Grupo ate"	  				," "," ","mv_ch3" ,"C",04,0,0,"G","" ,"SBM","","","mv_par03","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"04","Marca de"	  				," "," ","mv_ch4" ,"C",04,0,0,"G","" ,"SZ5","","","mv_par04","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"05","Marca ate"	  				," "," ","mv_ch5" ,"C",04,0,0,"G","" ,"SZ5","","","mv_par05","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"06","Segmento"	  				," "," ","mv_ch6" ,"C",02,0,0,"G","" ,"SZ7","","","mv_par06","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"07","Ítem de"	  				," "," ","mv_ch7" ,"C",15,0,0,"G","" ,"SB1","","","mv_par07","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"08","Ítem ate"	  				," "," ","mv_ch8" ,"C",15,0,0,"G","" ,"SB1","","","mv_par08","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"09","Período 1 de" 				," "," ","mv_ch9" ,"D",08,0,0,"C","" ,""   ,"","","mv_par09",""	 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"10","Período 1 até"				," "," ","mv_ch10","D",08,0,0,"C","" ,""   ,"","","mv_par10","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"11","Período 2 de" 				," "," ","mv_ch11","D",08,0,0,"C","" ,""   ,"","","mv_par11","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"12","Período 2 até"				," "," ","mv_ch12","D",08,0,0,"C","" ,""   ,"","","mv_par12","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
    PutSx1(_cPerg,"13","Imprim. Qtd. Zero?"			," "," ","mv_ch13","N",01,0,0,"C","" ,""   ,"","","mv_par13","SIM"  ,"" ,"" ,"","NÃO"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"14","Somente Negativos?"			," "," ","mv_ch14","N",01,0,0,"C","" ,""   ,"","","mv_par14","SIM"  ,"" ,"" ,"","NÃO"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"15","Agrupa Itens ?"				," "," ","mv_ch15","N",01,0,0,"C","" ,""   ,"","","mv_par15","SIM"  ,"" ,"" ,"","NÃO"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"16","Saldo do Prod a Considerar"	," "," ","mv_ch16","N",01,0,0,"C","" ,""   ,"","","mv_par16","Atual","" ,"" ,"","Fechamento"   	,"" ,"" ,"" ,"","","","","","","","","","","","")

	RestArea (_aArea)

Return(_cPerg)                                                                                                     
