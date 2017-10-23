#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM12			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Silverio Bastos - Anadi					   								|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para KITS através de uma expressao						  	    |
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM12()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "UG_PRODUTO"
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
	
	aFieldTit 		:= 				{"Produto","Descrição"}
	aAlterFields  	:= _aFields := 	{"UG_PRODUTO","B1_DESC"}
	
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
	
	AADD( _aHeader, { "Recno WT", "UG_REC_WT", "", 09, 0,,, "N", "SUG", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("UG_PRODUTO")[1]),space(TamSX3("B1_DESC")[1]),"",.F.})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Acessorios" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,oDlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	
    @ 188,210 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM12B()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo

user function IGENM12A()
	CCADASTRO := "Produtos"
	posicione("SB1",1,xFilial("SB1")+_acols[oGetD:nAt][1],"UG_PRODUTO")
	AxVisual("SUG",_acols[oGetD:nAt][2],2)
return

user function IGENM12B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo

Static Function CriaCols(_cFilter)
    _cSegto := u_setsegto()

	_cQuery := "SELECT  Distinct SUG.UG_PRODUTO, " 
	_cQuery += "		SB1.B1_DESC, "  
	_cQuery += "		SUG.R_E_C_N_O_ RECNO "  
	_cQuery += "FROM " + retSqlName("SUG") + "  SUG "
	_cQuery += "INNER JOIN "  + retSqlName("SB1") + "  SB1  ON B1_COD = SUG.UG_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "
    _cQuery += "INNER JOIN " + RetSqlName("SU1") + " U1 On U1_FILIAL = '" + xFilial("SU1") + "' And U1_CODACE = UG_CODACE And U1.D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE SUG.D_E_L_E_T_ = ' ' "
	if alltrim(_cSegto) <> '0'
		_cQuery += "  AND SB1.B1__SEGISP = '" + _cSegto + "' "
	endif
	_cQuery += "   AND (upper(SB1.B1_DESC) LIKE '%" + _cFilter + "%' OR upper(SB1.B1_COD) LIKE '%" + _cFilter + "%') "
	_cQuery += "ORDER BY SUG.UG_PRODUTO "
	TCQUERY _cQuery NEW ALIAS "TRB_SUG"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SUG")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SUG->UG_PRODUTO,;
					TRB_SUG->B1_DESC,;
					TRB_SUG->RECNO,.F.})
		dbSkip()
	EndDo

	If  (TRB_SUG->(BOF()) .AND. TRB_SUG->(EOF()))
	
		AADD(_aCols,{space(TamSX3("UG_PRODUTO")[1]), space(TamSX3("B1_DESC")[1]),"",.F.})

		aAlterFields  := _aFields := {"UG_PRODUTO","B1_DESC"}
		MsgInfo("Nenhum registro encontrado")
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt 	:= Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SUG->(dbCloseArea())
	                              
return