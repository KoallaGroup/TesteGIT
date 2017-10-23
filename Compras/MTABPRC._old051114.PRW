#Include 'Protheus.ch' 
#include "fwbrowse.ch"
#include "parmtype.ch"
#include "colors.ch"
#include "fwmvcdef.ch"

#DEFINE _LIDLG	aCoors[1]
#DEFINE _CIDLG	aCoors[2]
#DEFINE _LFDLG	aCoors[3]
#DEFINE _CFDLG	aCoors[4]

//-----------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MTABPRC
Rotina para atualização da tabela de preço
@author Ivan Morelatto Toré
@since 25/09/2014
@version MP10.8, MP11.5

/*/
//-----------------------------------------------------------------------------------------------------------------------
User Function MTABPRC

Local aAreaAtu := GetArea()
Local aAreaSM0 := SM0->( GetArea() )
Local cFilBkp  := cFilAnt

Local nOpcA `	:= 0
Local cTitulo 	:= "Tabela de Preço"

Local oCodFil
Local cCodFil	:= Space( Len( SM0->M0_CODFIL ) )

Local oNomFil
Local cNomFil	:= ""

Local oCodGrp
Local cCodGrp	:= Space( TamSX3( "Z02_GRUPO" )[1] )

Local oNomGrp
Local cNomGrp	:= ""

Local nLoop	:= 0
Local nCntFor	:= 0

Local cPerg	:= "MTABPRC"

Local aButtons := {}

Private oDlgTab
Private oLayer

Private oPanelGrp
Private oPanelFor
Private oPanelDF
Private oPanelPro
Private oPanelDP

Private oPanelAdic
Private oNome
Private cNome := ""

Private oDescricao
Private cDescricao := ""

Private oFolder
Private aCoors       := FWGetDialogSize( oMainWnd )
Private oFontArial	 := TFont():New( "Arial", Nil, 18, , .F. )

Private __nItemAtu__ := 1
Private __nItemPrd__ := 1

Private oListFor
Private aListFor := { { Space( Len( SA2->A2_COD ) ), Space( Len( SA2->A2_LOJA ) ), Space( Len( SA2->A2_NOME ) ), Space( Len( SA2->A2_END ) ) } }

Private oGetZ17
Private aHeadZ17	:= {}
Private aColsZ17	:= {}
Private aRecsZ17	:= {}

Private oGetZ18
Private aHeadZ18	:= {}
Private aColsZ18	:= {}
Private aRecsZ18	:= {}

Private oGetZ19
Private aHeadZ19	:= {}
Private aColsZ19	:= {}
Private aRecsZ19	:= {}

Private oGetZ20
Private aHeadZ20	:= {}
Private aColsZ20	:= {}
Private aRecsZ20	:= {}

ValidSX1( cPerg )

If !Pergunte( cPerg, .T. )
	Return
Endif

aAdd( aButtons, { "RELATORIO", { || MTABOrd() } ,"Ordenar","Ordenar" } )
aAdd( aButtons, { "RELATORIO", { || MTABBrut() } ,"Atu. Prc. Brut","Atu. Prc. Brut" } )
aAdd( aButtons, { "RELATORIO", { || MTABPrec() } ,"Atu. Lis. Prec","Atu. Lis. Prec" } )

cCodFil  := mv_par01
cCodGrp  := mv_par02

DEFINE MSDIALOG oDlgTab TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL
 
oLayer := FWLayer():New()
			
oLayer:Init( oDlgTab, .F. )
			
oLayer:AddLine('LineGrp',15,.F.)

oLayer:AddColumn('ColGrp',100,.T.,'LineGrp')
oLayer:AddWindow('ColGrp','WinGrp','Filial / Grupo Cotação',100,.F.,.F.,,'LineGrp')
			
oLayer:AddLine('LineFor',25,.F.)

oLayer:AddColumn('Col001',80,.T.,'LineFor')
oLayer:AddWindow('Col001','WinFor','Fornecedores',100,.F.,.F.,,'LineFor')
		
oLayer:AddColumn('Col002',20,.T.,'LineFor')
oLayer:AddWindow('Col002','WinDescF','Descontos Fornecedor',100,.F.,.F.,,'LineFor')
			
oLayer:AddLine('LineProd',40,.F.)			

oLayer:AddColumn('Col003',80,.T.,'LineProd')
oLayer:AddWindow('Col003','WinProd','Produtos',100,.F.,.F.,,'LineProd')
			
oLayer:AddColumn('Col004',20,.T.,'LineProd')
oLayer:AddWindow('Col004','WinDescP','Descontos Produto',100,.F.,.F.,,'LineProd')
			
oLayer:AddLine('LineAdic',20,.F.)

oLayer:AddColumn('Col005',100,.T.,'LineAdic')
oLayer:AddWindow('Col005','WinAdic','Dados Adicionais',100,.F.,.F.,,'LineAdic')

// Filial e Grupo de Cotação
oPanelGrp := oLayer:GetWinPanel('ColGrp','WinGrp','LineGrp')

// Filial
@ 007, 010 SAY 'Filial:' FONT oFontArial SIZE 40,20 OF oPanelGrp PIXEL
@ 006, 030 MSGET oCodFil VAR cCodFil PICTURE "@!" F3 'XM0' ;
	VALID VldFil( cCodFil, @oNomFil, @cNomFil ) ;
	WHEN .F. SIZE 50,10 FONT oFontArial OF oPanelGrp PIXEL
@ 007, 090 SAY oNomFil VAR cNomFil FONT oFontArial SIZE 120,20 OF oPanelGrp PIXEL
			
// Grupo de Cotação
@ 007, 220 SAY 'Grupo Cotação:' FONT oFontArial SIZE 60,20 OF oPanelGrp PIXEL
@ 006, 280 MSGET oCodGrp VAR cCodGrp PICTURE "@!" F3 'ZX5COM' ;
	VALID VldGrp( cCodGrp, @oNomGrp, @cNomGrp, @oListFor, @aListFor ) ;
	WHEN .F. SIZE 60,10 FONT oFontArial OF oPanelGrp PIXEL
@ 007, 350 SAY oNomGrp VAR cNomGrp FONT oFontArial SIZE 120,20 OF oPanelGrp PIXEL

// Fornecedores
oPanelFor := oLayer:GetWinPanel('Col001','WinFor','LineFor')
@ 01,01 LISTBOX oListFor FIELDS HEADER "Cod. Fornecedor", "Loja", "Nome", "Endereco" SIZE oPanelFor:nRight/2,oPanelFor:nBottom/2 OF oPanelFor PIXEL
oListFor:SetArray( aListFor )
oListFor:bLine := {|| { aListFor[oListFor:nAt,1], aListFor[oListFor:nAt,2], aListFor[oListFor:nAt,3], aListFor[oListFor:nAt,4] } }
oListFor:Refresh()

If ! VldFil( cCodFil, @oNomFil, @cNomFil ) .or. ! VldGrp( cCodGrp, @oNomGrp, @cNomGrp, @oListFor, @aListFor )
	Return
Endif

// Descontos Fornecedor
oPanelDF := oLayer:GetWinPanel('Col002','WinDescF','LineFor')
For nLoop := 1 To Len( aColsZ17 )
	oGetZ17 := MsNewGetDados():New( 0, 0, oPanelDF:nBottom/2, oPanelDF:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z17_ITEM",,, 9999,,, "U_MTABZ17Del()", oPanelDF, aHeadZ17[nLoop], aColsZ17[nLoop] )
	
	aHeadZ17[nLoop] := oGetZ17:aHeader
	aColsZ17[nLoop] := oGetZ17:aCols
Next nLoop

oGetZ17 := MsNewGetDados():New( 0, 0, oPanelDF:nBottom/2, oPanelDF:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z17_ITEM",,, 9999,,, "U_MTABZ17Del()", oPanelDF, aHeadZ17[oListFor:nAt], aColsZ17[oListFor:nAt] )

// Produtos
oPanelPro := oLayer:GetWinPanel('Col003','WinProd','LineProd')
@001,001 FOLDER oFolder OF oPanelPro PROMPT "Tabela de Preco", "Alteracao de Preco" PIXEL SIZE oPanelPro:nRight/2,oPanelPro:nBottom/2
For nLoop := 1 To Len( aColsZ18 )
	oGetZ18 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[1]:nBottom/2, oFolder:aDialogs[1]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[1], aHeadZ18[nLoop], aColsZ18[nLoop] )
	oGetZ18:oBrowse:bChange := { || AtuDisplay(), ChangeProd() }
		
	aHeadZ18[nLoop] := oGetZ18:aHeader
	aColsZ18[nLoop] := oGetZ18:aCols

	AlignObject( oFolder:aDialogs[1], { oGetZ18:oBrowse }, 1, 1, { 100 } )
Next nLoop

oGetZ18 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[1]:nBottom/2, oFolder:aDialogs[1]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[1], aHeadZ18[oListFor:nAt], aColsZ18[oListFor:nAt] )
oGetZ18:oBrowse:bChange := { || AtuDisplay(), ChangeProd() }
AlignObject( oFolder:aDialogs[1], { oGetZ18:oBrowse }, 1, 1, { 100 } )

// Descontos Produtos
oPanelDP := oLayer:GetWinPanel('Col004','WinDescP','LineProd')
For nLoop := 1 To Len( aColsZ19 )
	For nCntFor := 1 To Len( aColsZ19[nLoop] )
		oGetZ19 := MsNewGetDados():New( 0, 0, oPanelDP:nBottom/2, oPanelDP:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z19_ITEM",,, 9999,,, "U_MTABZ19Del()", oPanelDP, aHeadZ19[nLoop][nCntFor], aColsZ19[nLoop][nCntFor] )
	
		aHeadZ19[nLoop][nCntFor] := oGetZ19:aHeader
		aColsZ19[nLoop][nCntFor] := oGetZ19:aCols
	Next nCntFor
Next nLoop

oGetZ19 := MsNewGetDados():New( 0, 0, oPanelDP:nBottom/2, oPanelDP:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z19_ITEM",,, 9999,,, "U_MTABZ19Del()", oPanelDP, aHeadZ19[oListFor:nAt][1], aColsZ19[oListFor:nAt][1] )

// Dados Adicionais
oPanelAdic := oLayer:GetWinPanel('Col005','WinAdic','LineAdic')
@ 007, 010 SAY 'Nome:' FONT oFontArial SIZE 40,20 OF oPanelAdic PIXEL
@ 007, 035 SAY oNome VAR cNome FONT oFontArial SIZE 120,20 OF oPanelAdic PIXEL

@ 007, 220 SAY 'Descricao:' FONT oFontArial SIZE 60,20 OF oPanelAdic PIXEL
@ 007, 260 SAY oDescricao VAR cDescricao FONT oFontArial SIZE 120,20 OF oPanelAdic PIXEL

ACTIVATE MSDIALOG oDlgTab ON INIT EnchoiceBar( oDlgTab, { || nOpcA := 1, oDlgTab:End() }, { || oDlgTab:End() }, , aButtons )

cFilAnt := cFilBkp

RestArea( aAreaSM0 )
RestArea( aAreaAtu ) 

Return

//-----------------------------------------------------------------------------------------------------------------------
// Troca de fornecedor
//-----------------------------------------------------------------------------------------------------------------------
Static Function ChangeFor

If __nItemAtu__ != oListFor:nAt
	aHeadZ17[__nItemAtu__] := aClone( oGetZ17:aHeader )
	aColsZ17[__nItemAtu__] := aClone( oGetZ17:aCols )

	aHeadZ18[__nItemAtu__] := aClone( oGetZ18:aHeader )
	aColsZ18[__nItemAtu__] := aClone( oGetZ18:aCols )

	aHeadZ19[__nItemAtu__][__nItemPrd__] := aClone( oGetZ19:aHeader )
	aColsZ19[__nItemAtu__][__nItemPrd__] := aClone( oGetZ19:aCols )
Endif

oGetZ17:aHeader	:= aClone( aHeadZ17[oListFor:nAt] )
oGetZ17:aCols 	:= aClone( aColsZ17[oListFor:nAt] )

oGetZ18:aHeader	:= aClone( aHeadZ18[oListFor:nAt] )
oGetZ18:aCols 	:= aClone( aColsZ18[oListFor:nAt] )

oGetZ17:Refresh()
oGetZ18:Refresh()

oGetZ19:aHeader	:= aClone( aHeadZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] )
oGetZ19:aCols 	:= aClone( aColsZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] )

oGetZ19:Refresh()

__nItemAtu__ := oListFor:nAt
__nItemPrd__ := oGetZ18:oBrowse:nAt

AtuDisplay()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Troca de fornecedor
//-----------------------------------------------------------------------------------------------------------------------
Static Function ChangeProd

If __nItemPrd__ != oGetZ18:oBrowse:nAt
	aHeadZ19[__nItemAtu__][__nItemPrd__] := aClone( oGetZ19:aHeader )
	aColsZ19[__nItemAtu__][__nItemPrd__] := aClone( oGetZ19:aCols )
Endif

oGetZ19:aHeader	:= aClone( aHeadZ19[__nItemAtu__][oGetZ18:oBrowse:nAt] )
oGetZ19:aCols 	:= aClone( aColsZ19[__nItemAtu__][oGetZ18:oBrowse:nAt] )

__nItemPrd__ := oGetZ18:oBrowse:nAt

oGetZ19:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Validação do Código da Filial
//-----------------------------------------------------------------------------------------------------------------------
Static Function VldFil( cCodFil, oNomFil, cNomFil )

Local lRetFun := .T.

SM0->( dbSetOrder( 1 ) )
If SM0->( dbSeek( cEmpAnt + cCodFil ) )
	cFilAnt := cCodFil
	cNomFil := AllTrim( SM0->M0_NOME ) + " / " + AllTrim( SM0->M0_FILIAL )
	oNomFil:Refresh()
Else
	lRetFun := .F.
	Help( Nil, Nil, "Help", Nil, "Filial não encontrada", 1, 0 )
Endif

Return lRetFun

//-----------------------------------------------------------------------------------------------------------------------
// Validação do Código do Grupo
//-----------------------------------------------------------------------------------------------------------------------
Static Function VldGrp( cCodGrp, oNomGrp, cNomGrp, oListFor, aListFor )

Local aAreaAtu := GetArea()
Local lRetFun := .T.
Local cQuery	:= ""

aListFor := {}

ZX5->( dbSetOrder( 1 ) )
If ZX5->( dbSeek( xFilial( "ZX5" ) + Space( TamSX3( "ZX5_FILISA" )[1] ) + "000001" + cCodGrp ) )
	cNomGrp := AllTrim( ZX5->ZX5_DSCITE )
	oNomGrp:Refresh()
Else
	lRetFun := .F.
	Help( Nil, Nil, "Help", Nil, "Grupo de Cotação não Encontrado", 1, 0 )
Endif

If lRetFun
	cQuery := "SELECT * " 
	cQuery += "  FROM " + RetSQLName( "Z02" )
	cQuery += " WHERE Z02_FILIAL = '" + xFilial( "Z02" ) + "' "
	cQuery += "	AND Z02_GRUPO  = '" + cCodGrp + "' "
	cQuery += "	AND D_E_L_E_T_ = ' ' "
	
	If Select( "TMP_Z02" ) > 0
		TMP_Z02->( dbCloseArea() )
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_Z02", .T., .F. )
	
	While TMP_Z02->( ! Eof() )
	
		SA2->( dbSetOrder( 1 ) )
		If SA2->( dbSeek( xFilial( "SA2" ) + TMP_Z02->Z02_CODFOR + TMP_Z02->Z02_LOJA ) )
			aAdd( aListFor, { SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME, SA2->A2_END } )
		Endif
		
		TMP_Z02->( dbSkip() )
	End
	
	TMP_Z02->( dbCloseArea() )
	
	If Empty( aListFor )
		aListFor := { { Space( Len( SA2->A2_COD ) ), Space( Len( SA2->A2_LOJA ) ), Space( Len( SA2->A2_NOME ) ), Space( Len( SA2->A2_END ) ) } }
	Else
		CarregaZ17()
		CarregaZ18()
	Endif

	oListFor:SetArray( aListFor )
	oListFor:bLine := {|| { aListFor[oListFor:nAt,1], aListFor[oListFor:nAt,2], aListFor[oListFor:nAt,3], aListFor[oListFor:nAt,4] } }
	oListFor:bChange := {|| ChangeFor() }
	oListFor:Refresh()

Endif

RestArea( aAreaAtu )

Return lRetFun

//-----------------------------------------------------------------------------------------------------------------------
// CarregaZ17
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ17

Local nLoop   := 0
Local nCntFor := 0
Local nOpc  := 3
Local nItem := 0

aColsZ17 := Array( Len( aListFor ) )
aFill( aColsZ17, {} )

aRecsZ17 := Array( Len( aListFor ) )

aHeadZ17 := Array( Len( aListFor ) )
aFill( aHeadZ17, {} )

For nLoop := 1 To Len( aListFor )

	FillGetDados( nOpc,; 
	   				"Z17",; 
	   				1,;
	   				xFilial( "Z17" ) + aListFor[nLoop][1] + aListFor[nLoop][2],;
	   				{ || Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) },;
	   				Nil,;
	   				{ "Z17_FORNEC", "Z17_LOJA" },; 
	   				Nil,;
	   				Nil,; 
	   				Nil,; 
	   				Nil,;
	   				nOpc == 3,;
	   				aHeadZ17[nLoop],;
	   				aColsZ17[nLoop] )

	If ( nAux := GDFieldPos( 'Z17_REC_WT', aHeadZ17[nLoop] ) ) > 0
		aRecsZ17[nLoop] := {}
		For nCntFor := 1 To Len( aColsZ17[nLoop] )
			aAdd( aRecsZ17[nLoop], aColsZ17[nLoop][nCntFor][nAux] )
		Next nCntFor
	Endif
		                                   
	nItem := 0
	Z17->( dbSetOrder( 1 ) )
	Z17->( dbSeek( xFilial( "Z17" ) + aListFor[nLoop][1] + aListFor[nLoop][2] ) )
	While Z17->( !Eof() ) .and. Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) == xFilial( "Z17" ) + aListFor[nLoop][1] + aListFor[nLoop][2]
	
		nItem++
					
		If nItem != 1
			aAdd( aColsZ17[nLoop], Array( Len( aHeadZ17[nLoop] ) + 1 ) )
			For nCntFor := 1 To Len( aHeadZ17[nLoop] )
				If !( "WT" $ aHeadZ17[nLoop][nCntFor][2] )
					aColsZ17[nLoop][nItem][nCntFor] := CriaVar( aHeadZ17[nLoop][nCntFor][2] )
				Endif
			Next nCntFor
		Endif
					
		GDFieldPut( "Z17_ITEM"  , StrZero( nItem, TamSX3( "Z17_ITEM" )[1] )						, nItem, aHeadZ17[nLoop], aColsZ17[nLoop] )
		GDFieldPut( "Z17_DESC"  , Z17->Z17_DESC														, nItem, aHeadZ17[nLoop], aColsZ17[nLoop] )
		aColsZ17[nLoop][nItem][Len( aHeadZ17[nLoop] ) + 1] := .F.
	
		Z17->( dbSkip() )
	End
		
	If Empty( GDFieldGet( "Z17_ITEM", 1, Nil, aHeadZ17[nLoop], aColsZ17[nLoop] ) )
		GDFieldPut( "Z17_ITEM"  , StrZero( 1, TamSX3( "Z17_ITEM" )[1] ), 1, aHeadZ17[nLoop], aColsZ17[nLoop] )
	Endif

Next nLoop

Return

//-----------------------------------------------------------------------------------------------------------------------
// CarregaZ18
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ18

Local aAreaAtu := GetArea()
Local cQuery   := ""
Local nLoop   := 0
Local nCntFor := 0
Local nDescs  := 0
Local nOpc  := 3
Local nItem := 0

Local nPrcBrut := 0
Local nCustF	 := 0
Local nMargem	 := 0
Local nPVenda	 := 0
Local nPIPI	 := 0

Local nLoopList := 0
Local nLoopZ18  := 0

aColsZ18 := Array( Len( aListFor ) )
aFill( aColsZ18, {} )

aRecsZ18 := Array( Len( aListFor ) )

aHeadZ18 := Array( Len( aListFor ) )
aFill( aHeadZ18, {} )

SA5->( dbSetOrder( 1 ) )
SB1->( dbSetOrder( 1 ) )

For nLoop := 1 To Len( aListFor )

	FillGetDados( nOpc,; 
	   				"Z18",; 
	   				1,;
	   				xFilial( "Z18" ) + aListFor[nLoop][1] + aListFor[nLoop][2],;
	   				{ || Z18->( Z18_FILIAL + Z18_FORNEC + Z18_LOJA ) },;
	   				Nil,;
	   				{ "Z18_FORNEC", "Z18_LOJA" },; 
	   				Nil,;
	   				Nil,; 
	   				Nil,; 
	   				Nil,;
	   				nOpc == 3,;
	   				aHeadZ18[nLoop],;
	   				aColsZ18[nLoop] )

	If ( nAux := GDFieldPos( 'Z18_REC_WT', aHeadZ18[nLoop] ) ) > 0
		aRecsZ18[nLoop] := {}
		For nCntFor := 1 To Len( aColsZ18[nLoop] )
			aAdd( aRecsZ18[nLoop], aColsZ18[nLoop][nCntFor][nAux] )
		Next nCntFor
	Endif
	
	cQuery := "SELECT R_E_C_N_O_ RECSA5 "
	cQuery += "  FROM " + RetSQLName( "SA5" )
	cQuery += " WHERE A5_FILIAL  = '" + xFilial( "SA5" ) + "' "
	cQuery += "   AND A5_FORNECE = '" + aListFor[nLoop][1] + "' "
	cQuery += "   AND A5_LOJA    = '" + aListFor[nLoop][2] + "' "
	cQuery += "   AND D_E_L_E_T_ = ' ' "
	
	If Select( "TMP_SA5" ) > 0
		TMP_ZA5->( dbCloseArea() )
	Endif
	
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SA5", .T., .F. )
	
	nItem := 0
	
	While TMP_SA5->( !Eof() )
		                                   
		nItem++
		
		SA5->( dbGoTo( TMP_SA5->RECSA5 ) )
					
		If nItem != 1
			aAdd( aColsZ18[nLoop], Array( Len( aHeadZ18[nLoop] ) + 1 ) )
			For nCntFor := 1 To Len( aHeadZ18[nLoop] )
				If !( "WT" $ aHeadZ18[nLoop][nCntFor][2] )
					aColsZ18[nLoop][nItem][nCntFor] := CriaVar( aHeadZ18[nLoop][nCntFor][2] )
				Endif
			Next nCntFor
		Endif
		
		cQuery := "SELECT AIB_PRCCOM, AIB.R_E_C_N_O_ RECAIB "
		cQuery += "  FROM " + RetSQLName( "AIB" ) + " AIB "
		cQuery += "  JOIN " + RetSQLName( "AIA" ) + " AIA ON AIA_FILIAL = AIB_FILIAL AND AIA_CODFOR = AIB_CODFOR AND AIA_LOJFOR = AIB_LOJFOR AND AIA_CODTAB = AIB_CODTAB AND AIA.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE AIB_FILIAL = '" + xFilial( "AIB" ) + "' "
		cQuery += "   AND AIB_CODFOR = '" + aListFor[nLoop][1] + "' "
		cQuery += "   AND AIB_LOJFOR = '" + aListFor[nLoop][2] + "' "
		cQuery += "   AND AIB_CODPRO = '" + SA5->A5_PRODUTO + "' "
		cQuery += "   AND '" + DtoS( dDataBase ) + "' >= AIA_DATDE "
		cQuery += "   AND ( AIA_DATATE = '" + Space( TamSX3( "AIA_DATATE" )[1] ) + "' OR '" + DtoS( dDataBase ) + "' <= AIA_DATATE ) "
		cQuery += "   AND AIB.D_E_L_E_T_ = ' ' "
	
		If Select( "TMP_AIB" ) > 0
			TMP_AIB->( dbCloseArea() )
		Endif
	
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_AIB", .T., .F. )
		
		If TMP_AIB->( ! Eof() )
			GDFieldPut( "Z18_PBRUTO", TMP_AIB->AIB_PRCCOM	, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
			GDFieldPut( "Z18_IDAIB" , TMP_AIB->RECAIB		, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		Endif
		
		TMP_AIB->( dbCloseArea() )
		
		SB1->( dbSeek( xFilial( "SB1" ) + SA5->A5_PRODUTO ) )
		
		GDFieldPut( "Z18_PROFOR", SA5->A5_CODPRF	, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		GDFieldPut( "Z18_PROISA", SA5->A5_PRODUTO	, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		GDFieldPut( "Z18_PIPI"  , SB1->B1_IPI		, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )

		cQuery := "SELECT DA1_PRCVEN "
		cQuery += "  FROM " + RetSQLName( "DA1" ) + " DA1 "
		cQuery += "  JOIN " + RetSQLName( "DA0" ) + " DA0 ON DA0_FILIAL = DA1_FILIAL AND DA0_CODTAB = DA1_CODTAB AND DA0.D_E_L_E_T_ = ' ' "
		cQuery += " WHERE DA1_FILIAL     = '" + xFilial( "DA1" ) + "' "
		cQuery += "   AND DA1_CODPRO     = '" + SA5->A5_PRODUTO + "' "
		If SM0->M0_CODFIL != "03"
			cQuery += "   AND DA1_ESTADO     = '" + SM0->M0_ESTENT + "' "
		Else
			cQuery += "   AND DA1_ESTADO     = '" + Space( Len( SM0->M0_ESTENT ) ) + "' "
		Endif
		cQuery += "   AND DA0_ATIVO      = '1' "
		cQuery += "   AND DA1_ATIVO      = '1' "
		cQuery += "   AND '" + DtoS( dDataBase ) + "' >= DA0_DATDE "
		cQuery += "   AND ( DA0_DATATE = '" + Space( TamSX3( "DA0_DATATE" )[1] ) + "' OR '" + DtoS( dDataBase ) + "' <= DA0_DATATE ) "
		cQuery += "   AND DA1.D_E_L_E_T_ = ' ' "
		
		If Select( "TMP_DA1" ) > 0
			TMP_DA1->( dbCloseArea() )
		Endif
		
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DA1", .T., .F. )
		
		If TMP_DA1->( ! Eof() )
			nPVenda := TMP_DA1->DA1_PRCVEN
		Else
			nPVenda	:= 0
		Endif
		
		TMP_DA1->( dbCloseArea() )

		GDFieldPut( "Z18_PVENDA" , nPVenda							, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )

		aColsZ18[nLoop][nItem][Len( aHeadZ18[nLoop] ) + 1] := .F.

		TMP_SA5->( dbSkip() )
	
	End 
	
	TMP_SA5->( dbCloseArea() )	
	
Next nLoop

CarregaZ19()

For nLoopList := 1 To Len( aListFor )

	For nLoopZ18 := 1 To Len( aColsZ18[nLoopList] )

		nPrcBrut := GDFieldGet( "Z18_PBRUTO", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		nPIPI	  := GDFieldGet( "Z18_PIPI"  , nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		nPVenda  := GDFieldGet( "Z18_PVENDA", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		
		nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
		
		For nDescs := 1 To Len( aColsZ17[nLoopList] )
			nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, aHeadZ17[nLoopList], aColsZ17[nLoopList] ) / 100 )
		Next nDesc
		
		For nDescs := 1 To Len( aColsZ19[nLoopList][nLoopZ18] )
			nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, aHeadZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18] ) / 100 )
		Next nDesc
				
		GDFieldPut( "Z18_CUSTF" , nCustF, nLoopZ18, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		
		If nCustF != 0
			nMargem := ( ( nPVenda / nCustF ) - 1 ) * 100
		Else
			nMargem := 0
		Endif

		GDFieldPut( "Z18_MARGEM" , nMargem, nLoopZ18, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
	
	Next nLoopZ18

Next nLoopList

RestArea( aAreaAtu )

Return

//-----------------------------------------------------------------------------------------------------------------------
// CarregaZ19
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ19

Local nCntFor := 0
Local nOpc  := 3
Local nItem := 0

Local nLoopList := 0
Local nLoopZ18  := 0

aColsZ19 := Array( Len( aListFor ) )
aFill( aColsZ19, {} )

aRecsZ19 := Array( Len( aListFor ) )
aFill( aRecsZ19, {} )

aHeadZ19 := Array( Len( aListFor ) )
aFill( aHeadZ19, {} )

For nLoopList := 1 To Len( aListFor )

	aColsZ19[nLoopList] := Array( Len( aColsZ18[nLoopList] ) )
	aFill( aColsZ19[nLoopList], {} )
	
	aRecsZ19[nLoopList] := Array( Len( aColsZ18[nLoopList] ) )
	
	aHeadZ19[nLoopList] := Array( Len( aColsZ18[nLoopList] ) )
	aFill( aHeadZ19[nLoopList], {} )
	
	For nLoopZ18 := 1 To Len( aColsZ18[nLoopList] )

		FillGetDados( nOpc,; 
		   				"Z19",; 
		   				1,;
		   				xFilial( "Z19" ) + aListFor[nLoopList][1] + aListFor[nLoopList][2] + GDFieldGet( "Z18_PROISA", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] ),;
		   				{ || Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) },;
		   				Nil,;
		   				{ "Z19_FORNEC", "Z19_LOJA", "Z19_PRODUT" },; 
		   				Nil,;
		   				Nil,; 
		   				Nil,; 
		   				Nil,;
		   				nOpc == 3,;
		   				aHeadZ19[nLoopList][nLoopZ18],;
		   				aColsZ19[nLoopList][nLoopZ18] )

		If ( nAux := GDFieldPos( 'Z19_REC_WT', aHeadZ19[nLoopList][nLoopZ18] ) ) > 0
			aRecsZ19[nLoopList][nLoopZ18] := {}
			For nCntFor := 1 To Len( aColsZ19[nLoopList][nLoopZ18] )
				aAdd( aRecsZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18][nCntFor][nAux] )
			Next nCntFor
		Endif
		                                   
		nItem := 0
		Z19->( dbSetOrder( 1 ) )
		Z19->( dbSeek( xFilial( "Z19" ) + aListFor[nLoopList][1] + aListFor[nLoopList][2] + GDFieldGet( "Z18_PROISA", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] ) ) )
		While Z19->( !Eof() ) .and. Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) == xFilial( "Z19" ) + aListFor[nLoopList][1] + aListFor[nLoopList][2] + GDFieldGet( "Z18_PROISA", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
	
			nItem++
					
			If nItem != 1
				aAdd( aColsZ19[nLoopList][nLoopZ18], Array( Len( aHeadZ19[nLoopList][nLoopZ18] ) + 1 ) )
				For nCntFor := 1 To Len( aHeadZ19[nLoopList][nLoopZ18] )
					If !( "WT" $ aHeadZ19[nLoopList][nLoopZ18][nCntFor][2] )
						aColsZ19[nLoopList][nLoopZ18][nItem][nCntFor] := CriaVar( aHeadZ19[nLoopList][nLoopZ18][nCntFor][2] )
					Endif
				Next nCntFor
			Endif
					
			GDFieldPut( "Z19_ITEM"  , StrZero( nItem, TamSX3( "Z19_ITEM" )[1] )						, nItem, aHeadZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18] )
			GDFieldPut( "Z19_DESC"  , Z19->Z19_DESC														, nItem, aHeadZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18] )
			aColsZ19[nLoopList][nLoopZ18][nItem][Len( aHeadZ19[nLoopList][nLoopZ18] ) + 1] := .F.
		
			Z19->( dbSkip() )
		End
		
		If Empty( GDFieldGet( "Z19_ITEM", 1, Nil, aHeadZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18] ) )
			GDFieldPut( "Z19_ITEM"  , StrZero( 1, TamSX3( "Z19_ITEM" )[1] ), 1, aHeadZ19[nLoopList][nLoopZ18], aColsZ19[nLoopList][nLoopZ18] )
		Endif

	Next nLoopZ18
	
Next nLoopList

Return

//-----------------------------------------------------------------------------------------------------------------------
// Ajusta perguntas
//-----------------------------------------------------------------------------------------------------------------------
Static Function ValidSX1( cPerg )

Local aAreaAtu  := GetArea()
Local aPergs  	:= {}
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cKey    	:= ""
             
aAdd( aPergs, { "Filial"               ,"Filial                   ", "Filial                 ","mv_ch1","C",Len( SM0->M0_CODFIL )   ,0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","XM0","" } )
aAdd( aPergs, { "Grupo Cotacao"        ,"Grupo Cotacao            ", "Grupo Cotacao          ","mv_ch2","C",TamSX3( "Z02_GRUPO" )[1],0,0,"G","","mv_par02","","","","","","","","","","","","","","","","","","","","","","","","","ZX5COM","" } )
AjustaSx1( cPerg, aPergs )                        

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
cKey 	 := "P." + AllTrim( cPerg ) + "01."
aAdd( aHelpPor, 'Informe a filial                        ' )
PutSX1Help( cKey, aHelpPor, aHelpEng, aHelpSpa )

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
cKey 	 := "P." + AllTrim( cPerg ) + "02."
aAdd( aHelpPor, 'Informe o Grupo de Cotacao              ' )
PutSX1Help( cKey, aHelpPor, aHelpEng, aHelpSpa )

RestArea( aAreaAtu )

Return

//-----------------------------------------------------------------------------------------------------------------------
// Atualiza display do RodapŽ
//-----------------------------------------------------------------------------------------------------------------------
Static Function AtuDisplay

Local cProduto := GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, aHeadZ18[oListFor:nAt], aColsZ18[oListFor:nAt] )

SB1->( dbSetOrder( 1 ) )
SB1->( dbSeek( xFilial( "SB1" ) + cProduto ) )
cNome := SB1->B1_DESC
oNome:Refresh()

SB5->( dbSetOrder( 1 ) )
SB5->( dbSeek( xFilial( "SB5" ) + cProduto ) )
cDescricao := SB5->B5_CEME
oDescricao:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Funcao para Ordernar
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABOrd

Local nOpcao := 0

Local nPosIsa := GDFieldPos( 'Z18_PROISA', oGetZ18:aHeader )
Local nPosFor := GDFieldPos( 'Z18_PROFOR', oGetZ18:aHeader )

nOpcao := Aviso( "Ordenar", "Escolha a ordenacao", { "It.Isapa", "It.Forn" } )

If nOpcao == 1
	aSort( oGetZ18:aCols,,, { |x,y| x[nPosIsa] < y[nPosIsa] } )

ElseIf nOpcao == 2
	aSort( oGetZ18:aCols,,, { |x,y| x[nPosFor] < y[nPosFor] } )
	
Endif

oGetZ18:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na altera‹o do preo bruto
//-----------------------------------------------------------------------------------------------------------------------
User Function MTabPBru

Local nPrcBrut := &( ReadVar() )

Local nCustF	:= 0
Local nMargem	:= 0
Local nPVenda	:= GDFieldGet( "Z18_PVENDA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
Local nPIPI	:= GDFieldGet( "Z18_PIPI"  , oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )

Local nDescs  := 0

nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
		
For nDescs := 1 To Len( oGetZ17:aCols )
	nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, oGetZ17:aHeader, oGetZ17:aCols ) / 100 )
Next nDesc
		
For nDescs := 1 To Len( oGetZ19:aCols )
	nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, oGetZ19:aHeader, oGetZ19:aCols ) / 100 )
Next nDesc
				
GDFieldPut( "Z18_CUSTF" , nCustF, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
		
If nCustF != 0
	nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
Endif

GDFieldPut( "Z18_MARGEM" , nMargem, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
GDFieldPut( "Z18_PVENDA" , nPVenda, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )

oGetZ18:oBrowse:Refresh()

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na altera‹o dos descontos do fornecedor
//-----------------------------------------------------------------------------------------------------------------------
User Function MTabDFor

Local nDescFor := &( ReadVar() )
Local nLoopZ18 := 0

Local nCustF	 := 0
Local nMargem	 := 0
Local nPrcBrut := 0
Local nPIPI	 := 0
Local nPVenda	 := 0

Local nDescs  := 0

aHeadZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] := aClone( oGetZ19:aHeader )
aColsZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] := aClone( oGetZ19:aCols )

For nLoopZ18 := 1 To Len( oGetZ18:aCols )
	
	nPrcBrut := GDFieldGet( "Z18_PBRUTO", nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nPIPI	  := GDFieldGet( "Z18_PIPI"  , nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nPVenda  := GDFieldGet( "Z18_PVENDA", nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	
	nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
			
	For nDescs := 1 To Len( oGetZ17:aCols )
		If !GDDeleted( nDescs, oGetZ17:aHeader, oGetZ17:aCols )
			If nDescs != oGetZ17:oBrowse:nAt
				nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, oGetZ17:aHeader, oGetZ17:aCols ) / 100 )
			Else
				nCustF -= nCustF * ( nDescFor / 100 )
			Endif
		Endif
	Next nDesc

	For nDescs := 1 To Len( aColsZ19[oListFor:nAt][nLoopZ18] )
		If !GDDeleted( nDescs, aHeadZ19[oListFor:nAt][nLoopZ18], aColsZ19[oListFor:nAt][nLoopZ18] )
			nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, aHeadZ19[oListFor:nAt][nLoopZ18], aColsZ19[oListFor:nAt][nLoopZ18] ) / 100 )
		Endif
	Next nDesc
					
	GDFieldPut( "Z18_CUSTF" , nCustF, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )
			
	If nCustF != 0
		nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
	Endif
	
	GDFieldPut( "Z18_MARGEM" , nMargem, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )
	GDFieldPut( "Z18_PVENDA" , nPVenda, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )

Next nLoopZ18

oGetZ18:oBrowse:Refresh()

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na altera‹o dos descontos do produto
//-----------------------------------------------------------------------------------------------------------------------
User Function MTabDPro

Local nDescPro := &( ReadVar() )

Local nCustF	 := 0
Local nMargem	 := 0
Local nPrcBrut := 0
Local nPIPI	 := 0
Local nPVenda	 := 0

Local nDescs  := 0

nPrcBrut := GDFieldGet( "Z18_PBRUTO", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
nPIPI	  := GDFieldGet( "Z18_PIPI"  , oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
nPVenda  := GDFieldGet( "Z18_PVENDA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	
nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
			
For nDescs := 1 To Len( oGetZ17:aCols )
	If !GDDeleted( nDescs, oGetZ17:aHeader, oGetZ17:aCols )
		nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, oGetZ17:aHeader, oGetZ17:aCols ) / 100 )
	Endif
Next nDesc
			
For nDescs := 1 To Len( oGetZ19:aCols )
	If !GDDeleted( nDescs, oGetZ19:aHeader, oGetZ19:aCols )
		If nDescs != oGetZ19:oBrowse:nAt
			nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, oGetZ19:aHeader, oGetZ19:aCols ) / 100 )
		Else
			nCustF -= nCustF * ( nDescPro / 100 )
		Endif
	Endif
Next nDesc
					
GDFieldPut( "Z18_CUSTF" , nCustF, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
			
If nCustF != 0
	nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
Endif
	
GDFieldPut( "Z18_MARGEM" , nMargem, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
GDFieldPut( "Z18_PVENDA" , nPVenda, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )

oGetZ18:oBrowse:Refresh()

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na dele‹o dos descontos do fornecedor
//-----------------------------------------------------------------------------------------------------------------------
User Function MTABZ17Del

Local nLoopZ18 := 0

Local nCustF	 := 0
Local nMargem	 := 0
Local nPrcBrut := 0
Local nPIPI	 := 0
Local nPVenda	 := 0

Local nDescs  := 0

Local lConLinha := .T.

aHeadZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] := aClone( oGetZ19:aHeader )
aColsZ19[oListFor:nAt][oGetZ18:oBrowse:nAt] := aClone( oGetZ19:aCols )

For nLoopZ18 := 1 To Len( oGetZ18:aCols )
	
	nPrcBrut := GDFieldGet( "Z18_PBRUTO", nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nPIPI	  := GDFieldGet( "Z18_PIPI"  , nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nPVenda  := GDFieldGet( "Z18_PVENDA", nLoopZ18, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	
	nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
			
	For nDescs := 1 To Len( oGetZ17:aCols )
	
		lConLinha := !GDDeleted( nDescs, oGetZ17:aHeader, oGetZ17:aCols )
		
		If nDescs == oGetZ17:oBrowse:nAt
			lConLinha := GDDeleted( nDescs, oGetZ17:aHeader, oGetZ17:aCols )
		Endif
	
		If lConLinha
			nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, oGetZ17:aHeader, oGetZ17:aCols ) / 100 )
		Endif

	Next nDesc
			
	For nDescs := 1 To Len( aColsZ19[oListFor:nAt][nLoopZ18] )
		If !GDDeleted( nDescs, aHeadZ19[oListFor:nAt][nLoopZ18], aColsZ19[oListFor:nAt][nLoopZ18] )
			nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, aHeadZ19[oListFor:nAt][nLoopZ18], aColsZ19[oListFor:nAt][nLoopZ18] ) / 100 )
		Endif
	Next nDesc


	GDFieldPut( "Z18_CUSTF" , nCustF, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )
			
	If nCustF != 0
		nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
	Endif
	
	GDFieldPut( "Z18_MARGEM" , nMargem, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )
	GDFieldPut( "Z18_PVENDA" , nPVenda, nLoopZ18, oGetZ18:aHeader, oGetZ18:aCols )

Next nLoopZ18

oGetZ18:oBrowse:Refresh()

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na dele‹o dos descontos do produto
//-----------------------------------------------------------------------------------------------------------------------
User Function MTABZ19Del

Local nCustF	 := 0
Local nMargem	 := 0
Local nPrcBrut := 0
Local nPIPI	 := 0
Local nPVenda	 := 0

Local nDescs  := 0

Local lConLinha := .T.

nPrcBrut := GDFieldGet( "Z18_PBRUTO", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
nPIPI	  := GDFieldGet( "Z18_PIPI"  , oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
nPVenda  := GDFieldGet( "Z18_PVENDA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	
nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
			
For nDescs := 1 To Len( oGetZ17:aCols )
	If !GDDeleted( nDescs, oGetZ17:aHeader, oGetZ17:aCols )
		nCustF -= nCustF * ( GDFieldGet( "Z17_DESC", nDescs, Nil, oGetZ17:aHeader, oGetZ17:aCols ) / 100 )
	Endif
Next nDesc
			
For nDescs := 1 To Len( oGetZ19:aCols )

	lConLinha := !GDDeleted( nDescs, oGetZ19:aHeader, oGetZ19:aCols )
	
	If nDescs == oGetZ19:oBrowse:nAt
		lConLinha := GDDeleted( nDescs, oGetZ19:aHeader, oGetZ19:aCols )
	Endif
	
	If lConLinha
		nCustF -= nCustF * ( GDFieldGet( "Z19_DESC", nDescs, Nil, oGetZ19:aHeader, oGetZ19:aCols ) / 100 )
	Endif

Next nDesc
					
GDFieldPut( "Z18_CUSTF" , nCustF, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
			
If nCustF != 0
	nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
Endif
	
GDFieldPut( "Z18_MARGEM" , nMargem, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
GDFieldPut( "Z18_PVENDA" , nPVenda, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )

oGetZ18:oBrowse:Refresh()

Return .T.
