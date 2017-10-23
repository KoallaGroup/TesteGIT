#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM08			  		| 	Setembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta padrão para clientes através de uma expressao						  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function IGENM08()
	Local nX           	:= 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "A1_COD"
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
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
	aFieldTit 		:= 				{"Código" 	,"Cliente",	"Loja",		"Estado", "Nome Fantasia"	}
	aAlterFields  	:= _aFields := 	{"A1_COD" 	,"A1_NOME",	"A1_LOJA", 	"A1_EST","A1_NREDUZ"		}
	
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
	
	AADD( _aHeader, { "Recno WT", "A1_REC_WT", "", 09, 0,,, "N", "SA1", "V"} )
	
	//Insere clientes caso exista
	AADD(_aCols,{space(TamSX3("A1_COD")[1]) 		,;
				space(TamSX3("A1_NOME")[1])			,;
				space(TamSX3("A1_LOJA")[1])			,;
				space(TamSX3("A1_EST")[1])          ,;
				space(TamSX3("A1_NREDUZ")[1])		,;				
				""									,;
				.F.									})
	
	//DEFINE MSDIALOG oDlg TITLE "Identificacao do Produto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
	DEFINE MSDIALOG oDlg TITLE "Pesquisa de Clientes" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oGetD := TSay():New( 009,004,{||"Contem expressao"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)

//	oGetD := TGet():New( 007,052,{|u| If(PCount()>0,_cFilter  :=u,_cFilter)} ,ODlg,,,"",,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
	
	@ 007,052 MsGet _cFilter Size 150,010 of ODlg PIXEL VALID (CriaCols(upper(alltrim(_cFilter))))
	
	
	oGetD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,;
	cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	
    @ 188,140 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM08B()
    @ 188,210 Button oButton PROMPT "Visualizar" SIZE 40,10   OF oDlg PIXEL ACTION U_IGENM08A()
    @ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| U_IGENM08B()}
	oDlg:lCentered := .T.
	oDlg:Activate()    
	
	RestArea(cAliasOrg)
	posicione("SA1",1,xFilial("SB1")+_acols[oGetD:nAt][1]+_acols[oGetD:nAt][3],"A1_COD")
Return cCodigo


user function IGENM08A()
	CCADASTRO := "Clientes"
	posicione("SA1",1,xFilial("SB1")+_acols[oGetD:nAt][1]+_acols[oGetD:nAt][3],"A1_COD")
	AxVisual("SA1",_acols[oGetD:nAt][3],2)
return


user function IGENM08B()
	cCodigo := _acols[oGetD:nAt][1]
	cLoja 	:= _acols[oGetD:nAt][3]
	
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial("SA1")+cCodigo+cLoja)
	
	oDlg:End()
return cCodigo


user function IGENM08C(_cFilter)
	if !empty(_cFilter)
		CriaCols(upper(alltrim(_cFilter)))
	endif	
return .T.            


user function IGENM08D()
return cLoja


Static Function CriaCols(_cFilter)
    _cSegto := u_setsegto()
	
	_cQuery := "SELECT  SA1.A1_COD, "
	_cQuery += "		SA1.A1_NOME, " 
	_cQuery += "		SA1.A1_LOJA, " 
	_cQuery += "		SA1.A1_NREDUZ, " 
	_cQuery += "		SA1.A1_EST, " 
	_cQuery += "		SA1.R_E_C_N_O_ RECNO, "  
	_cQuery += "		SA1.A1_MSBLQL " 
	_cQuery += "FROM " + retSqlName("SA1") + "  SA1 "
	_cQuery += "WHERE SA1.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND (upper(SA1.A1_NOME) LIKE '%" + _cFilter + "%' OR upper(SA1.A1_COD) LIKE '%" + _cFilter + "%') "
	if alltrim(_cSegto) <> '0'
		_cQuery += "  AND (SA1.A1__SEGISP = '" + _cSegto + "' Or SA1.A1__SEGISP = '0' Or SA1.A1__SEGISP = ' ') "
	endif
	_cQuery += "  AND SA1.A1_MSBLQL <> '1' "
	_cQuery += "ORDER BY SA1.A1_NOME,SA1.A1_COD,SA1.A1_LOJA "
	TCQUERY _cQuery NEW ALIAS "TRB_SA1"  	                                                          
	
    _aCols :={}

	dbSelectArea("TRB_SA1")
	dbGoTop()
	While (!EOF())
		AADD(_aCols,{TRB_SA1->A1_COD,;
					TRB_SA1->A1_NOME,;
					TRB_SA1->A1_LOJA,;
					TRB_SA1->A1_EST,;
					TRB_SA1->A1_NREDUZ,;					
					TRB_SA1->RECNO,;
					iif(TRB_SA1->A1_MSBLQL == '1',.T.,.F.)})
		dbSkip()
	EndDo

	if  (TRB_SA1->(BOF()) .AND. TRB_SA1->(EOF()))
	
		AADD(_aCols,{space(TamSX3("A1_COD")[1]) 		,;
					space(TamSX3("A1_NOME")[1])			,;
					space(TamSX3("A1_LOJA")[1])			,;
                    space(TamSX3("A1_EST")[1])          ,;
					space(TamSX3("A1_NREDUZ")[1])		,;
					""									,;
					.F.									})

	    aAlterFields  	:= _aFields := 	{"A1_COD" 	,"A1_NOME",	"A1_LOJA", 	"A1_EST", "A1_NEDUZ"}
		
	EndIf

	oGetD:aCols := _aCols
	oGetD:nAt := Len(_aCols)
	
	oDlg:Refresh()

   	TRB_SA1->(dbCloseArea())
	                              
return