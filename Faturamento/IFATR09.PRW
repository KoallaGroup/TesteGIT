
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATR09				| 	Dezembro de 2014									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de Pedido de Venda													|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFATR09(_cPedido, _cFilial)    
	    
	local _aArea := GetArea()
    local _cPerg := "IFATR09" 

	if empty(_cPedido) .and. empty(_cFilial)
		AjustSX1(_cPerg)
	
		If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
			Return
		EndIf
		cParms := MV_PAR01+";"+MV_PAR02
	else
		cParms := _cPedido+";"+_cFilial
	endif                    
	
	//alert (cParms)
	
	x:="1;0;1;IFATR09" 
	         
	CallCrys("IFATR09",cParms, x)
	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
	
	PutSx1(_cPerg,"01","Numero do Pedido"," "," ","mv_ch1","C",06,0,0,"G","" ,"","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"02","Filial do Pedido"," "," ","mv_ch2","C",02,0,0,"G","" ,"","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	RestArea (_aArea)

Return(_cPerg)                                                                                                     
