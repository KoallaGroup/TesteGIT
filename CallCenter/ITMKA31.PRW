#include "topconn.ch"           
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA31			  		| 	Outubro de 2014				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta de Perdas nas vendas do Call Center								  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function ITMKA31()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "ZN_NUM"
	Local nFreeze      	:= 000
	Local nMax         	:= 999
	Local cFieldOk     	:= "AllwaysTrue"
	Local cSuperDel    	:= ""
	Local cDelOk       	:= "AllwaysFalse"
	Local aAlterGDa    	:= {}
	Local cAliasOrg		:= GetArea()
	Local aFieldTit 	:= {}
	Local aAlterFields  := {}
	Local _aFields 		:= {}
	Local cCodigo		:= ""
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	         
	aFieldTit 		:= 				{"Produto"		,"Descrição"	,"Qtde. Perdida","Dt.Cancelamento"	,"Motivo"}
	aAlterFields  	:= _aFields := 	{"ZN_PRODUTO" 	,"B1_DESC"		,"ZN_QUANT"		,"ZN_DTCAN"			,"ZD_DESC"}
	
	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100,  15, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	
	aPosObj := MsObjSize(aInfo, aObjects)	
	
	nUsado:=0
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aFields)
		If SX3->(DbSeek(_aFields[nX]))
			Aadd(_aHeader, {aFieldTit[nx],aAlterFields[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R" /*SX3->X3_CONTEXT*/})
			nUsado:=nUsado+1
		Endif
	Next nX
	
	DEFINE MSDIALOG oDlg TITLE "Ítens Cancelados" From 0,0 To 400,950 OF oMainWnd PIXEL
	
	oGetD:= MsNewGetDados():New(5,3,186,475,nStyle,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
                
	CriaCols()

    @ 188,380 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo

                                     
Static Function CriaCols()

	_cQuery := "SELECT  SZN.ZN_PRODUTO, "
	_cQuery += "		SZN.ZN_QUANT, " 
	_cQuery += "		SZN.ZN_DTCAN, "  
	_cQuery += "		SZD.ZD_DESC, "  
	_cQuery += "		SZN.ZN_DTCAN, "  
	_cQuery += "		SB1.B1_DESC "  
	_cQuery += "FROM " + retSqlName("SZN") + "  SZN "
	_cQuery += "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = ZN_PRODUTO "
	_cQuery += "  										AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += "INNER JOIN " + retSqlName("SZD") + " SZD ON ZD_COD = ZN_MOTIVO "
	_cQuery += "  										AND SZD.D_E_L_E_T_ = ' ' "
	_cQuery += "  										AND SZD.ZD_TIPO = 'IT' "
	_cQuery += "WHERE SZN.D_E_L_E_T_ = ' ' "
	_cQuery += "  AND SZN.ZN_NUM = '" + SUA->UA_NUM + "' "  
	_cQuery += "  AND SZN.ZN_FILIAL = '" + SUA->UA_FILIAL + "' "  
	_cQuery += "ORDER BY SZN.ZN_DTCAN "
	TCQUERY _cQuery NEW ALIAS "TRB_SZN"  	                                                          
	
	TcSetField("TRB_SZN", "ZN_DTCAN", "D")
	
    _aCols :={}
     
	aFieldTit 		:= 				{"Produto"		,"Descrição"	,"Quantidade"	,"Dt.Cancelamento"	,"Motivo"}


	dbSelectArea("TRB_SZN")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SZN->ZN_PRODUTO,;
					TRB_SZN->B1_DESC,;
					TRB_SZN->ZN_QUANT,;
					TRB_SZN->ZN_DTCAN,;
					TRB_SZN->ZD_DESC,;
					.F.})
		dbSkip()
	EndDo

	if  (TRB_SZN->(BOF()) .AND. TRB_SZN->(EOF()))
	
		AADD(_aCols,{space(TamSX3("ZN_PRODUTO")[1]) 		,;
					space(TamSX3("B1_DESC")[1])			,;
					space(TamSX3("ZN_QUANT")[1])			,;
					space(TamSX3("ZN_DTCAN")[1])			,;
					space(TamSX3("ZD_DESC")[1])			,;
					.F.									})
	
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SZN->(dbCloseArea())
	                              
return