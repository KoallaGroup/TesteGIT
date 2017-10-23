#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : MT340B2   			 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves Oliveira - Anadi	         										      |
|---------------------------------------------------------------------------------------------------------|
|	Descri��o : Ponto de entrada para grava��o do campo Z15_TPINVE como liberado, ap�s a grava��o do SB2  |
|---------------------------------------------------------------------------------------------------------|
*/

User Function MT340B2

	local _aArea := getArea()
	
	dbSelectArea("Z15")
	dbSetOrder(1)
	if dbSeek(xFilial("Z15")+SB2->B2_COD)
		reclock("Z15", .F.)
	else
		reclock("Z15", .T.)
	endif
	Z15->Z15_FILIAL	:= xFilial("Z15")
	Z15->Z15_COD	:= SB2->B2_COD
	Z15->Z15_TPINVE	:= '1'
	        
	Z15->(msUnlock())               
	
	restarea(_aArea)
	
Return   
         