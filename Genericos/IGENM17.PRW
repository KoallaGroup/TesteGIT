#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM17			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi							  				|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Padrao de Motivos de Visita no Teleatendimento	   					  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM17()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "ZD_COD"
	Local nFreeze      	:= 000
	Local nMax         	:= 9999
	Local cFieldOk     	:= "AllwaysTrue"
	Local cSuperDel    	:= ""
	Local cDelOk       	:= "AllwaysFalse"
	Local aAlterGDa    	:= {}
	Local cAliasOrg		:= GetArea()
	Local aFieldTit 	:= {}
	Local aAlterFields  := {}
	Local _aFields 		:= {}
	Local _cFilter		:= Space(30)
	Static cCodigo		:= ""
	Static cLoja		:= ""
	
	If !MsgYesNo("Deseja informar o motivo da visita?")
	   Return
	EndIf
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
	aFieldTit 		:= 				{"Código" 	,"Descricao"}
	aAlterFields  	:= _aFields := 	{"ZD_COD" 	,"ZD_DESC"}
	
	//Array com os campos que é permitida alteração.
	//aAlterGDa := aAlterFields
	
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
	
	AADD( _aHeader, { "Recno WT", "ZD_REC_WT", "", 09, 0,,, "N", "SZD", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("ZD_COD")[1]) 		,;
				space(TamSX3("ZD_DESC")[1])			,;
				""									,;
				.F.									})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Motivos de visita Teleatendimento" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	
	@ 007,052 MsGet _cFilter Size 150,010 of ODlg PIXEL VALID (CriaCols(upper(alltrim(_cFilter))))
	
	
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	CriaCols(upper(alltrim(_cFilter)))
	
    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM17B()
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM17A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| U_IGENM17B()}
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo


user function IGENM17A()
	CCADASTRO := "Tabelas de Motivos Atendimento"
	posicione("SZD",1,xFilial("SZD")+_acols[oGetD:nAt][1],"ZD_COD")
	AxVisual("SZD",_acols[oGetD:nAt][3],2)
return


user function IGENM17B()
	cCodigo := _acols[oGetD:nAt][1]
	
	dbSelectArea("SZD")
	dbSetOrder(1)
	dbSeek(xFilial("SZD")+cCodigo)
	
	dbSelectArea("Z23")
	reclock("Z23", .T.)
	Z23->Z23_FILIAL	 := xFilial("Z23")
	Z23->Z23_DATA	 := Date()
	Z23->Z23_HORA	 := Time()
	Z23->Z23_USER	 := __cUserID
	Z23->Z23_LOGIN	 := cUsername 
	Z23->Z23_NUSER	 := UsrFullName(__cUserID) 
	Z23->Z23_CODZD	 := SZD->ZD_COD
	Z23->Z23_DESCZD  := SZD->ZD_DESC
	Z23->Z23_CODCLI  := SA1->A1_COD
	Z23->Z23_LOJA    := SA1->A1_LOJA
 	Z23->(msUnlock())  
	                                                         	
	oDlg:End() 
	
return cCodigo


Static Function CriaCols(_cFilter)
    //_cSegto := u_setsegto()
	
	_cQuery := "SELECT  SZD.ZD_COD, "
	_cQuery += "		SZD.ZD_DESC, " 
	_cQuery += "		SZD.R_E_C_N_O_ RECNO "  
	_cQuery += " FROM " + retSqlName("SZD") + "  SZD "
	_cQuery += " WHERE SZD.D_E_L_E_T_ = ' ' "
	If !Empty(_cFilter)
	   _cQuery += "  AND (upper(SZD.ZD_DESC) LIKE '%" + _cFilter + "%' OR upper(SZD.ZD_COD) LIKE '%" + _cFilter + "%') "
	EndIf
	_cQuery += "  AND SZD.ZD_TIPO = 'TA' "
	_cQuery += "ORDER BY SZD.ZD_COD,SZD.ZD_DESC "
	TCQUERY _cQuery NEW ALIAS "TRB_SZD"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SZD")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SZD->ZD_COD,;
					TRB_SZD->ZD_DESC,;
					TRB_SZD->RECNO,;
					.F.})
		dbSkip()
	EndDo

	If  (TRB_SZD->(BOF()) .AND. TRB_SZD->(EOF()))
	
		AADD(_aCols,{space(TamSX3("ZD_COD")[1]) 		,;
					space(TamSX3("ZD_DESC")[1])			,;
					""									,;
					.T.									})

		aAlterFields  	:= _aFields := 	{"ZD_COD" 	,"ZD_DESC"}
		
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	oGetD:Refresh()
	
	oDlg:Refresh()

   	TRB_SZD->(dbCloseArea())
	                              
return