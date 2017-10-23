#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM07			  		| 	Setembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para produto através de uma expressao						  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM07()
	Local nX           	:= 0, _nAcao := 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "B1_COD"
	Local nFreeze      	:= 000
	Local nMax         	:= 99999
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
	
	aFieldTit 		:= 				{"Código Produto" 	,"Desc Prod"}
	aAlterFields  	:= _aFields := 	{"B1_COD" 			,"B1_DESC"}
	
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
	
	AADD( _aHeader, { "Recno WT", "B1_REC_WT", "", 09, 0,,, "N", "SB1", "V"} )
	
	//Insere produtos caso exista
	AADD(_aCols,{space(TamSX3("B1_COD")[1]) 		,;
				space(TamSX3("B1_DESC")[1])			,;
				""									,;
				.F.									})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Produto" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	if funname() == 'TMKA271'
		oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)), 'TMKA271')},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	else
		oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)), '')},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	endif
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	//CriaCols(upper(alltrim(_cFilter)), '')
	
    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()} //{|| _nAcao := 1, U_IGENM07B()}
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM07A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
	If _nAcao == 1	
    	DbSelectArea("SB1")
    	DbSetOrder(1)
    	DbSeek(xFilial("SB1") + cCodigo)
	EndIf

Return cCodigo


user function IGENM07A()
	CCADASTRO := "Produtos"
	DbSelectArea("SB1")
	DbGoTo(_acols[oGetD:nAt][3])
	//posicione("SB1",1,xFilial("SB1")+_acols[oGetD:nAt][1],"B1_COD")
	AxVisual("SB1",_acols[oGetD:nAt][3],2)
return


user function IGENM07B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo


Static Function CriaCols(_cFilter, _cFuncao)
Local _cFiltro := Separa(Alltrim(_cFilter),"%")
	
    _cSegto := u_setsegto()
	
	_cQuery := "SELECT  SB1.B1_COD, "
	_cQuery += "		SB1.B1_DESC, " 
	_cQuery += "		SB1.B1_GRUPO, " 
	_cQuery += "		SB1.R_E_C_N_O_ RECNO, "  
	_cQuery += "		SB1.B1_MSBLQL " 
	_cQuery += "FROM " + retSqlName("SB1") + "  SB1 "
	_cQuery += "WHERE SB1.D_E_L_E_T_ = ' ' "
	
	For nx := 1 To Len(_cFiltro)
	   _cQuery += "  AND (upper(SB1.B1_DESC) LIKE '%" + Upper(_cFiltro[nx]) + "%' OR upper(SB1.B1_COD) LIKE '%" + Upper(_cFiltro[nx]) + "%') "
	Next
	if alltrim(_cSegto) <> '0'
		_cQuery += "  AND (SB1.B1__SEGISP = '" + _cSegto + "' Or SB1.B1__SEGISP = '0') "
	endif
	_cQuery += "  AND SB1.B1_MSBLQL <> '1' "
	_cQuery += "ORDER BY SB1.B1_DESC "
	TCQUERY _cQuery NEW ALIAS "TRB_SB1"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SB1")
	dbGoTop()
	While (!EOF())
		_lCond := .T.
/*		if _cFuncao == 'TMKA271'
			if ! TRB_SB1->B1_GRUPO $ U_IESTA08()
				_lCond := .F.
			endif	
		endif*/
		if _lCond
			AADD(_aCols,{TRB_SB1->B1_COD 		,;
						TRB_SB1->B1_DESC		,;
						TRB_SB1->RECNO			,;
						iif(TRB_SB1->B1_MSBLQL == '1',.T.,.F.)})
		endif		
		dbSkip()
	EndDo

	if  (TRB_SB1->(BOF()) .AND. TRB_SB1->(EOF()))
		AADD(_aCols,{space(TamSX3("B1_COD")[1]) 		,;
					space(TamSX3("B1_DESC")[1])			,;
					""									,;
					.F.									})
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SB1->(dbCloseArea())
	                              
return