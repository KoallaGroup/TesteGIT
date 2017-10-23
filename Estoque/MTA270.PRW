
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA270			  		| 	Outubro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada executado após a Inclusão, Alteração e Exclusão de 			|
|				registros de inventário														  	|
|-----------------------------------------------------------------------------------------------|	
*/


user function MTA270()
	local nOpc := PARAMIXB[1]   
	local _aArea := getArea()
	
	if nOpc == 3 .or. nOpc == 4

		dbSelectArea("Z15")
		dbSetOrder(1)
		        
		if dbSeek(xFilial("Z15")+SB7->B7_COD)
			reclock("Z15", .F.)
		else
			reclock("Z15", .T.)
		endif
		Z15->Z15_FILIAL	:= xFilial("Z15")
		Z15->Z15_COD	:= SB7->B7_COD
		Z15->Z15_TPINVE	:= SB7->B7__TPINVE
		Z15->(msUnlock())  
		
	endif
	
	restarea(_aArea)
return 