#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : MT340B2   			 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         										      |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada para gravação do campo Z15_TPINVE como liberado, após a gravação do SB2  |
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
         