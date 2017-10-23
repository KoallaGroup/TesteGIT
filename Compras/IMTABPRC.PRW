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
/*/{Protheus.doc} IMTABPRC
Rotina para atualização da tabela de preço
@author Ivan Morelatto Toré
@since 25/09/2014
@version MP10.8, MP11.5

/*/
//-----------------------------------------------------------------------------------------------------------------------
User Function IMTABPRC

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

Private oListFor
Private aListFor := { { Space( Len( SA2->A2_COD ) ), Space( Len( SA2->A2_LOJA ) ), Space( Len( SA2->A2_NOME ) ), Space( Len( SA2->A2_END ) ) } }

Private oGetZ16
Private aHeadZ16	:= {}
Private aColsZ16	:= {}
Private aRecsZ16	:= {}

Private oGetZ17
Private aHeadZ17	:= {}
Private aColsZ17	:= {}
Private aRecsZ17	:= {}

Private oGetZ18
Private aHeadZ18	:= {}
Private aColsZ18	:= {}
Private aRecsZ18	:= {}

ValidSX1( cPerg )

If !Pergunte( cPerg, .T. )
	Return
Endif

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
For nLoop := 1 To Len( aColsZ16 )
	oGetZ16 := MsNewGetDados():New( 0, 0, oPanelDF:nBottom/2, oPanelDF:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z16_ITEM",,, 9999,,,, oPanelDF, aHeadZ16[nLoop], aColsZ16[nLoop] )
	
	aHeadZ16[nLoop] := oGetZ16:aHeader
	aColsZ16[nLoop] := oGetZ16:aCols
Next nLoop

oGetZ16 := MsNewGetDados():New( 0, 0, oPanelDF:nBottom/2, oPanelDF:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z16_ITEM",,, 9999,,, /*"U_MTZ161Del()"*/, oPanelDF, aHeadZ16[oListFor:nAt], aColsZ16[oListFor:nAt] )

// Produtos
oPanelPro := oLayer:GetWinPanel('Col003','WinProd','LineProd')
@001,001 FOLDER oFolder OF oPanelPro PROMPT "Tabela de Preco", "Alteracao de Preco" PIXEL SIZE oPanelPro:nRight/2,oPanelPro:nBottom/2
For nLoop := 1 To Len( aColsZ17 )
	oGetZ17 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[1]:nBottom/2, oFolder:aDialogs[1]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[1], aHeadZ17[nLoop], aColsZ17[nLoop] )
		
	aHeadZ17[nLoop] := oGetZ17:aHeader
	aColsZ17[nLoop] := oGetZ17:aCols

	AlignObject( oFolder:aDialogs[1], { oGetZ17:oBrowse }, 1, 1, { 100 } )
Next nLoop

oGetZ17 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[1]:nBottom/2, oFolder:aDialogs[1]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[1], aHeadZ17[oListFor:nAt], aColsZ17[oListFor:nAt] )
AlignObject( oFolder:aDialogs[1], { oGetZ17:oBrowse }, 1, 1, { 100 } )

// Descontos Produtos
oPanelDP := oLayer:GetWinPanel('Col004','WinDescP','LineProd')
For nLoop := 1 To Len( aColsZ18 )
	oGetZ18 := MsNewGetDados():New( 0, 0, oPanelDP:nBottom/2, oPanelDP:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z18_ITEM",,, 9999,,,, oPanelDP, aHeadZ18[nLoop], aColsZ18[nLoop] )
	
	aHeadZ18[nLoop] := oGetZ18:aHeader
	aColsZ18[nLoop] := oGetZ18:aCols
Next nLoop

oGetZ18 := MsNewGetDados():New( 0, 0, oPanelDP:nBottom/2, oPanelDP:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z18_ITEM",,, 9999,,, /*"U_MTZ181Del()"*/, oPanelDP, aHeadZ18[oListFor:nAt], aColsZ18[oListFor:nAt] )

// Dados Adicionais
oPanelAdic := oLayer:GetWinPanel('Col005','WinAdic','LineAdic')
@ 007, 010 SAY 'Nome:' FONT oFontArial SIZE 40,20 OF oPanelAdic PIXEL
@ 007, 030 SAY oNome VAR cNome FONT oFontArial SIZE 120,20 OF oPanelAdic PIXEL

@ 007, 220 SAY 'Descricao:' FONT oFontArial SIZE 60,20 OF oPanelAdic PIXEL
@ 007, 280 SAY oDescricao VAR cDescricao FONT oFontArial SIZE 120,20 OF oPanelAdic PIXEL

ACTIVATE MSDIALOG oDlgTab ON INIT EnchoiceBar( oDlgTab, { || nOpcA := 1, oDlgTab:End() }, { || oDlgTab:End() } )

cFilAnt := cFilBkp

RestArea( aAreaSM0 )
RestArea( aAreaAtu ) 

Return

//-----------------------------------------------------------------------------------------------------------------------
// Troca de fornecedor
//-----------------------------------------------------------------------------------------------------------------------
Static Function ChangeFor

If __nItemAtu__ != oListFor:nAt
	aHeadZ16[__nItemAtu__] := aClone( oGetZ16:aHeader )
	aColsZ16[__nItemAtu__] := aClone( oGetZ16:aCols )

	aHeadZ17[__nItemAtu__] := aClone( oGetZ17:aHeader )
	aColsZ17[__nItemAtu__] := aClone( oGetZ17:aCols )
Endif

oGetZ16:aHeader	:= aClone( aHeadZ16[oListFor:nAt] )
oGetZ16:aCols 	:= aClone( aColsZ16[oListFor:nAt] )

oGetZ17:aHeader	:= aClone( aHeadZ17[oListFor:nAt] )
oGetZ17:aCols 	:= aClone( aColsZ17[oListFor:nAt] )

__nItemAtu__ := oListFor:nAt

oGetZ16:Refresh()
oGetZ17:Refresh()

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
		If SA2->( dbSeek( xFilial( "SA2" ) + TMP_Z02->Z02_CODFOR ) )
			aAdd( aListFor, { SA2->A2_COD, SA2->A2_LOJA, SA2->A2_NOME, SA2->A2_END } )
		Endif
		
		TMP_Z02->( dbSkip() )
	End
	
	TMP_Z02->( dbCloseArea() )
	
	If Empty( aListFor )
		aListFor := { { Space( Len( SA2->A2_COD ) ), Space( Len( SA2->A2_LOJA ) ), Space( Len( SA2->A2_NOME ) ), Space( Len( SA2->A2_END ) ) } }
	Else
		CarregaZ16()
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
// CarregaZ16
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ16

Local nLoop   := 0
Local nCntFor := 0
Local nOpc  := 3
Local nItem := 0

aColsZ16 := Array( Len( aListFor ) )
aFill( aColsZ16, {} )

aRecsZ16 := Array( Len( aListFor ) )

aHeadZ16 := Array( Len( aListFor ) )
aFill( aHeadZ16, {} )

For nLoop := 1 To Len( aListFor )

	FillGetDados( nOpc,; 
	   				"Z16",; 
	   				1,;
	   				xFilial( "Z16" ) + aListFor[nLoop][1] + aListFor[nLoop][2],;
	   				{ || Z16->( Z16_FILIAL + Z16_FORNEC + Z16_LOJA ) },;
	   				Nil,;
	   				{ "Z16_FORNEC", "Z16_LOJA" },; 
	   				Nil,;
	   				Nil,; 
	   				Nil,; 
	   				Nil,;
	   				nOpc == 3,;
	   				aHeadZ16[nLoop],;
	   				aColsZ16[nLoop] )

	If ( nAux := GDFieldPos( 'Z16_REC_WT', aHeadZ16[nLoop] ) ) > 0
		aRecsZ16[nLoop] := {}
		For nCntFor := 1 To Len( aColsZ16[nLoop] )
			aAdd( aRecsZ16[nLoop], aColsZ16[nLoop][nCntFor][nAux] )
		Next nCntFor
	Endif
		                                   
	nItem := 0
	Z16->( dbSetOrder( 1 ) )
	Z16->( dbSeek( xFilial( "Z16" ) + aListFor[nLoop][1] + aListFor[nLoop][2] ) )
	While Z16->( !Eof() ) .and. Z16->( Z16_FILIAL + Z16_FORNEC + Z16_LOJA ) == xFilial( "Z16" ) + aListFor[nLoop][1] + aListFor[nLoop][2]
	
		nItem++
					
		If nItem != 1
			aAdd( aColsZ16[nLoop], Array( Len( aHeadZ16[nLoop] ) + 1 ) )
			For nCntFor := 1 To Len( aHeadZ16[nLoop] )
				If !( "WT" $ aHeadZ16[nLoop][nCntFor][2] )
					aColsZ16[nLoop][nItem][nCntFor] := CriaVar( aHeadZ16[nLoop][nCntFor][2] )
				Endif
			Next nCntFor
		Endif
					
		GDFieldPut( "Z16_ITEM"  , StrZero( nItem, TamSX3( "Z16_ITEM" )[1] )						, nItem, aHeadZ16[nLoop], aColsZ16[nLoop] )
		GDFieldPut( "Z16_DESC"  , Z16->Z16_DESC														, nItem, aHeadZ16[nLoop], aColsZ16[nLoop] )
		aColsZ16[nLoop][nItem][Len( aHeadZ16[nLoop] ) + 1] := .F.
	
		Z16->( dbSkip() )
	End
		
	If Empty( GDFieldGet( "Z16_ITEM", 1, Nil, aHeadZ16[nLoop], aColsZ16[nLoop] ) )
		GDFieldPut( "Z16_ITEM"  , StrZero( 1, TamSX3( "Z16_ITEM" )[1] ), 1, aHeadZ16[nLoop], aColsZ16[nLoop] )
	Endif

Next nLoop

Return

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
					
		//GDFieldPut( "Z17_ITEM"  , StrZero( nItem, TamSX3( "Z17_ITEM" )[1] )						, nItem, aHeadZ17[nLoop], aColsZ17[nLoop] )
		//GDFieldPut( "Z17_DESC"  , Z17->Z17_DESC														, nItem, aHeadZ17[nLoop], aColsZ17[nLoop] )
		aColsZ17[nLoop][nItem][Len( aHeadZ17[nLoop] ) + 1] := .F.
	
		Z17->( dbSkip() )
	End
		
Next nLoop

Return

//-----------------------------------------------------------------------------------------------------------------------
// CarregaZ18
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ18

Local nLoop   := 0
Local nCntFor := 0
Local nOpc  := 3
Local nItem := 0

aColsZ18 := Array( Len( aListFor ) )
aFill( aColsZ18, {} )

aRecsZ18 := Array( Len( aListFor ) )

aHeadZ18 := Array( Len( aListFor ) )
aFill( aHeadZ18, {} )

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
		                                   
	nItem := 0
	Z18->( dbSetOrder( 1 ) )
	Z18->( dbSeek( xFilial( "Z18" ) + aListFor[nLoop][1] + aListFor[nLoop][2] ) )
	While Z18->( !Eof() ) .and. Z18->( Z18_FILIAL + Z18_FORNEC + Z18_LOJA ) == xFilial( "Z18" ) + aListFor[nLoop][1] + aListFor[nLoop][2]
	
		nItem++
					
		If nItem != 1
			aAdd( aColsZ18[nLoop], Array( Len( aHeadZ18[nLoop] ) + 1 ) )
			For nCntFor := 1 To Len( aHeadZ18[nLoop] )
				If !( "WT" $ aHeadZ18[nLoop][nCntFor][2] )
					aColsZ18[nLoop][nItem][nCntFor] := CriaVar( aHeadZ18[nLoop][nCntFor][2] )
				Endif
			Next nCntFor
		Endif
					
		GDFieldPut( "Z18_ITEM"  , StrZero( nItem, TamSX3( "Z18_ITEM" )[1] )						, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		GDFieldPut( "Z18_DESC"  , Z18->Z18_DESC														, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		aColsZ18[nLoop][nItem][Len( aHeadZ18[nLoop] ) + 1] := .F.
	
		Z18->( dbSkip() )
	End
		
	If Empty( GDFieldGet( "Z18_ITEM", 1, Nil, aHeadZ18[nLoop], aColsZ18[nLoop] ) )
		GDFieldPut( "Z18_ITEM"  , StrZero( 1, TamSX3( "Z18_ITEM" )[1] ), 1, aHeadZ18[nLoop], aColsZ18[nLoop] )
	Endif

Next nLoop

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
