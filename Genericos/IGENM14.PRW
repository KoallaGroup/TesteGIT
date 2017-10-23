#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM14			  		| 	Outubro de 2014				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para fornecedores através de uma expressao					  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM14()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "E4_COD"
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
	
	aFieldTit 		:= 				{"Código" 	,"Condição","Descrição"}
	aAlterFields  	:= _aFields := 	{"E4_CODIGO","E4_COND",	"E4_DESCRI"}
	
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
	
	AADD( _aHeader, { "Recno WT", "E4_REC_WT", "", 09, 0,,, "N", "SE4", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("E4_CODIGO")[1]) 		,;
				space(TamSX3("E4_COND")[1])			,;
				space(TamSX3("E4_DESCRI")[1])			,;
				""									,;
				.F.									})
	
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Condição de Pagamento" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)

    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM14B()
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM14A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	
	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return cCodigo

                                     
user function IGENM14A()
	CCADASTRO := "Condição de Pagamento"
	posicione("SE4",1,xFilial("SE4")+_acols[oGetD:nAt][1],"E4_CODIGO")
	AxVisual("SE4",_acols[oGetD:nAt][4],2)
return


user function IGENM14B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo


Static Function CriaCols(_cFilter)
    _cSegto := u_setsegto()
	
	_cQuery := "SELECT  SE4.E4_CODIGO, "
	_cQuery += "		SE4.E4_COND, " 
	_cQuery += "		SE4.E4_DESCRI,
	_cQuery += "		SE4.R_E_C_N_O_ RECNO "  
	_cQuery += "FROM " + retSqlName("SE4") + "  SE4 "
	_cQuery += "WHERE SE4.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND (upper(SE4.E4_COND) LIKE '%" + _cFilter + "%' OR upper(SE4.E4_CODIGO) LIKE '%" + _cFilter + "%' OR upper(SE4.E4_DESCRI) LIKE '%" + _cFilter + "%') "
	if alltrim(_cSegto) <> '0'
//		_cQuery += "  AND SE4.E4__SEGISP = '" + _cSegto + "' "
	endif
	_cQuery += "ORDER BY SE4.E4_DESCRI "
	TCQUERY _cQuery NEW ALIAS "TRB_SE4"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SE4")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SE4->E4_CODIGO,;
					TRB_SE4->E4_COND,;
					TRB_SE4->E4_DESCRI,;
					TRB_SE4->RECNO,;
					.F.})
		dbSkip()
	EndDo

	if  (TRB_SE4->(BOF()) .AND. TRB_SE4->(EOF()))
	
		AADD(_aCols,{space(TamSX3("E4_CODIGO")[1]) 		,;
					space(TamSX3("E4_COND")[1])			,;
					space(TamSX3("E4_DESCRI")[1])			,;
					""									,;
					.F.									})

	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SE4->(dbCloseArea())
	                              
return