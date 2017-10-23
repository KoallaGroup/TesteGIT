#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMR09				| 	Dezembro de 2014									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório de Pedido de Compra													|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMR09(_cPedido, _cFilial)    
	    
	local _aArea := GetArea()
    local _cPerg := "ICOMR09" 
    
    default _cPedido := ""
    default _cFilial := ""

	AjustSX1(_cPerg)

    if funName() == 'MATA121' .Or. funName() == 'MATA120' 
        cParms := SC7->C7_FILIAL+";"+SC7->C7_NUM
    else
    	if !empty(_cPedido) .And. !empty(_cFilial)
    	   cParms := _cFilial+";"+_cPedido
    	Else
    		If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
    			Return
    		EndIf
    		cParms := MV_PAR01+";"+MV_PAR02
    		
			//ADICIONADO POR RAFAEL DOMINGUES EM 03/07/15
			DbSelectArea("SC7")
			DbSetOrder(1)
			DbSeek(MV_PAR01+MV_PAR02)
			    		
    	EndIf
	endif
	
	if posicione("SA2",1,xFilial("SA2")+SC7->C7_FORNECE+SC7->C7_LOJA,"A2_EST") == 'EX'
		x:="1;0;1;ICOMCR14" 
		CallCrys("ICOMCR14",cParms, x)         	// importado
	else
		x:="1;0;1;ICOMCR09" 
		CallCrys("ICOMCR09",cParms, x)			// nacional
	endif
	
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	Local aHelpPor	:= {}
	
	PutSx1(_cPerg,"01","Filial do Pedido"," "," ","mv_ch1","C",02,0,0,"G","" ,"","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"02","Numero do Pedido"," "," ","mv_ch2","C",06,0,0,"G","" ,"","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	RestArea (_aArea)

Return(_cPerg)                                                                                                     
