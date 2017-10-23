#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM09			  		| 	Outubro de 2014				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para fornecedores através de uma expressao					  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM09()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "A2_COD"
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
	
	aFieldTit 		:= 				{"Código" 	,"Fornecedor",	"Loja",		"Nome Fantasia",	"Estado"}
	aAlterFields  	:= _aFields := 	{"A2_COD" 	,"A2_NOME",		"A2_LOJA", 	"A2_NREDUZ",		"A2_EST"}
	
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
	
	AADD( _aHeader, { "Recno WT", "A2_REC_WT", "", 09, 0,,, "N", "SA2", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("A2_COD")[1]) 		,;
				space(TamSX3("A2_NOME")[1])			,;
				space(TamSX3("A2_LOJA")[1])			,;
				space(TamSX3("A2_NREDUZ")[1])		,;
				space(TamSX3("A2_EST")[1])			,;
				""									,;
				.F.									})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Fornecedores" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)

    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM09B()
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM09A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo

                                     
user function IGENM09A()
	CCADASTRO := "Fornecedores"
	posicione("SA2",1,xFilial("SA2")+_acols[oGetD:nAt][1]+_acols[oGetD:nAt][3],"A2_COD")
	AxVisual("SA2",_acols[oGetD:nAt][6],2)
return


user function IGENM09B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo


Static Function CriaCols(_cFilter)
    _cSegto := u_setsegto()
	
	_cQuery := "SELECT  SA2.A2_COD, "
	_cQuery += "		SA2.A2_NOME, " 
	_cQuery += "		SA2.A2_LOJA, " 
	_cQuery += "		SA2.A2_NREDUZ, " 
	_cQuery += "		SA2.A2_EST, " 
	_cQuery += "		SA2.R_E_C_N_O_ RECNO, "  
	_cQuery += "		SA2.A2_MSBLQL " 
	_cQuery += "FROM " + retSqlName("SA2") + "  SA2 "
	_cQuery += "WHERE SA2.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND (upper(SA2.A2_NOME) LIKE '%" + _cFilter + "%' OR upper(SA2.A2_COD) LIKE '%" + _cFilter + "%') "
	_cQuery += "  AND SA2.A2_MSBLQL <> '1' "
	if alltrim(_cSegto) <> '0'
		_cQuery += "  AND (SA2.A2__SEGISP = '" + _cSegto + "' Or SA2.A2__SEGISP = '0') "
	endif
	_cQuery += "ORDER BY SA2.A2_NOME "
	TCQUERY _cQuery NEW ALIAS "TRB_SA2"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SA2")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SA2->A2_COD,;
					TRB_SA2->A2_NOME,;
					TRB_SA2->A2_LOJA,;
					TRB_SA2->A2_NREDUZ,;
					TRB_SA2->A2_EST,;
					TRB_SA2->RECNO,;
					iif(TRB_SA2->A2_MSBLQL == '1',.T.,.F.)})
		dbSkip()
	EndDo

	if  (TRB_SA2->(BOF()) .AND. TRB_SA2->(EOF()))
	
		AADD(_aCols,{space(TamSX3("A2_COD")[1]) 		,;
					space(TamSX3("A2_NOME")[1])			,;
					space(TamSX3("A2_LOJA")[1])			,;
					space(TamSX3("A2_NREDUZ")[1])		,;
					space(TamSX3("A2_EST")[1])			,;
					""									,;
					.F.									})

	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SA2->(dbCloseArea())
	                              
return