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
|	Descri��o : Relat�rio de custo dos produtos vendidos										|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IESTCR03()    
	    
	local _aArea := GetArea()
    local _cPerg := "IESTCR03"

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) 	// Carrega as Perguntas do SX1
		Return
	EndIf
	   
	If Empty(MV_PAR02)
		MV_PAR02 := "0"
	EndIf

	If mv_par06 == "0 "
		mv_par06 := '  '
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
	PutSx1(_cPerg,"06","Segmento"	  				," "," ","mv_ch6" ,"C",02,0,0,"G","!Vazio() .and. ExistCpo('SZ7',MV_PAR06) ","SZ7","","","mv_par06","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"07","�tem de"	  				," "," ","mv_ch7" ,"C",15,0,0,"G","" ,"SB1","","","mv_par07","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"08","�tem ate"	  				," "," ","mv_ch8" ,"C",15,0,0,"G","" ,"SB1","","","mv_par08","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"09","Per�odo 1 de" 				," "," ","mv_ch9" ,"D",08,0,0,"C","" ,""   ,"","","mv_par09",""	 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"10","Per�odo 1 at�"				," "," ","mv_ch10","D",08,0,0,"C","" ,""   ,"","","mv_par10","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"11","Per�odo 2 de" 				," "," ","mv_ch11","D",08,0,0,"C","" ,""   ,"","","mv_par11","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"12","Per�odo 2 at�"				," "," ","mv_ch12","D",08,0,0,"C","" ,""   ,"","","mv_par12","" 	,"" ,"" ,"","" 				,"" ,"" ,"" ,"","","","","","","","","","","","")	
    PutSx1(_cPerg,"13","Imprim. Qtd. Zero?"			," "," ","mv_ch13","N",01,0,0,"C","" ,""   ,"","","mv_par13","SIM"  ,"" ,"" ,"","N�O"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"14","Somente Negativos?"			," "," ","mv_ch14","N",01,0,0,"C","" ,""   ,"","","mv_par14","SIM"  ,"" ,"" ,"","N�O"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"15","Agrupa Itens ?"				," "," ","mv_ch15","N",01,0,0,"C","" ,""   ,"","","mv_par15","SIM"  ,"" ,"" ,"","N�O"   		,"" ,"" ,"" ,"","","","","","","","","","","","")
    PutSx1(_cPerg,"16","Saldo do Prod a Considerar"	," "," ","mv_ch16","N",01,0,0,"C","" ,""   ,"","","mv_par16","Atual","" ,"" ,"","Fechamento"   	,"" ,"" ,"" ,"","","","","","","","","","","","")

	RestArea (_aArea)

Return(_cPerg)                                                                                                     
