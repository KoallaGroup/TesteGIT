#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM11			  		| 	Outubro de 2014				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para grupo de fornecedores através de uma expressao			  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM11()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "ZX5_CODIGO"
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
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
	aFieldTit 		:= 				{"Codigo" 		,"Fornecedor"}
	aAlterFields  	:= _aFields := 	{"ZX5_CODIGO" 	,"ZX5_DSCITE"}
	
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
	
	AADD( _aHeader, { "Recno WT", "ZX5_REC_WT", "", 09, 0,,, "N", "ZX5", "V"} )

	
	AADD(_aCols,{space(TamSX3("ZX5_CODIGO")[1]) ,;
				space(TamSX3("ZX5_DSCITE")[1])	,;
				""								,;
				.F.	})
	
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Grupo de Fornecedores" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)

    @ 188,210 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM11B()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo

                                     
user function IGENM11B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo


Static Function CriaCols(_cFilter)
    _cSegto := u_setsegto()
	
	_cQuery := "SELECT  ZX5.ZX5_CODIGO, "
	_cQuery += "		ZX5.ZX5_DSCITE, " 
	_cQuery += "		ZX5.R_E_C_N_O_ RECNO "  
	_cQuery += "FROM " + retSqlName("ZX5") + "  ZX5 "
	_cQuery += "WHERE ZX5.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND ZX5.ZX5_GRUPO = '000001' "
	_cQuery += "  AND (upper(ZX5.ZX5_CODIGO) LIKE '%" + _cFilter + "%' OR upper(ZX5.ZX5_DSCITE) LIKE '%" + _cFilter + "%') "
	if alltrim(_cSegto) <> '0'
//		_cQuery += "  AND ZX5.ZX5_SEGISP = '" + _cSegto + "' "
	endif
	_cQuery += "ORDER BY ZX5.ZX5_DSCITE "
	TCQUERY _cQuery NEW ALIAS "TRB_ZX5"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_ZX5")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_ZX5->ZX5_CODIGO,;
					TRB_ZX5->ZX5_DSCITE,;
					TRB_ZX5->RECNO,;
					.F.})
		dbSkip()
	EndDo

	if  (TRB_ZX5->(BOF()) .AND. TRB_ZX5->(EOF()))
	
		AADD(_aCols,{space(TamSX3("ZX5_CODIGO")[1]) 		,;
					space(TamSX3("ZX5_DSCITE")[1])			,;
					""									,;
					.F.									})
	
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_ZX5->(dbCloseArea())
	                              
return