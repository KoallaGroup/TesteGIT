#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATR07				| 	Dezembro de 2014										|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de espelho de DANFE													|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFATR07(_cFilial,_cNum,_cSerie,_cCli,_cLoja) 
Local _aArea	:= GetArea()
Local _aAreaSF2	:= SF2->(GetArea())
Local aPergs	:= {}
Local cPerg	 	:= "IFATR07"
Local lParam	:= .T.

Default _cFilial	:= space(TamSx3("D2_FILIAL")[1])
Default _cNum		:= space(TamSx3("D2_DOC")[1])
Default _cSerie		:= space(TamSx3("D2_SERIE")[1])
Default _cCli		:= space(TamSx3("D2_CLIENTE")[1])
Default _cLoja 		:= space(TamSx3("D2_LOJA")[1])

Aadd(aPergs,{"Filial"		,"","","mv_ch1","C",TamSx3("D2_FILIAL")[1]	,0,0,"G","Vazio() .OR. existCpo('SM0',cEmpAnt+MV_PAR01)" 	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DLB" 	,"","","",""})
Aadd(aPergs,{"Nota Fiscal"	,"","","mv_ch2","C",TamSx3("D2_DOC")[1] 	,0,0,"G",""													,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""	  	,"","","",""})
Aadd(aPergs,{"Serie"		,"","","mv_ch3","C",TamSx3("D2_SERIE")[1]	,0,0,"G",""													,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""    	,"","","",""})
Aadd(aPergs,{"Cliente"		,"","","mv_ch4","C",TamSx3("D2_CLIENTE")[1] ,0,0,"G","Vazio() .OR. ExistCpo('SA1',MV_PAR04)"			,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA1" 	,"","","",""})
Aadd(aPergs,{"Loja"			,"","","mv_ch5","C",TamSx3("D2_LOJA")[1] 	,0,0,"G","Vazio() .OR. ExistCpo('SA1',MV_PAR04+MV_PAR05)"	,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA1LJ"	,"","","",""})
	
AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

lParam	:= ( Empty(_cFilial) .OR. Empty(_cNum) .OR. Empty(_cSerie) .OR. Empty(_cCli) .OR. Empty(_cLoja) )

Pergunte (cPerg,lParam)
   
If !lParam
	MV_PAR01 := _cFilial
	MV_PAR02 := _cNum
	MV_PAR03 := _cSerie
	MV_PAR04 := _cCli
	MV_PAR05 := _cLoja
EndIf

	DbSelectArea("SF2")
	If DbSeek(MV_PAR01+MV_PAR02+MV_PAR03+MV_PAR04+MV_PAR05)
		cParms := MV_PAR01 + ";"
		cParms += MV_PAR02 + ";"
		cParms += MV_PAR03 + ";"
		cParms += MV_PAR04 + ";"
		cParms += MV_PAR05
		
		x:="1;0;1;IFATCR07" 
	
		CallCrys("IFATCR07",cParms, x)
	Else
		Alert("Nota Fiscal não encontrada")
	EndIf                         
	
RestArea(_aArea)	
RestArea(_aAreaSF2)	

Return