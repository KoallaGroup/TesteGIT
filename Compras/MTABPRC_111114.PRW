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
Private aHeadZ20	 := {}
Private aColsZ20	 := {}
Private aRecsZ20	 := {}

Private lAltPBru	:= .F.
Private lGrvPBru	:= .F. 

Private lAltPrec	:= .F.
Private lGrvPrec	:= .F. 

ValidSX1( cPerg )

If !Pergunte( cPerg, .T. )
	Return
Endif

aAdd( aButtons, { "RELATORIO", { || MTABOrd() } ,"Ordenar","Ordenar" } )
aAdd( aButtons, { "RELATORIO", { || MsgRun( "Atualizando Preco Bruto", "Atualizando", { || MTABBrut() } ) }, "Atu. Prc. Brut", "Atu. Prc. Brut" } )
aAdd( aButtons, { "RELATORIO", { || MsgRun( "Atualizando Lista Preco", "Atualizando", { || MTABPrec() } ) }, "Atu. Lis. Prec", "Atu. Lis. Prec" } )
aAdd( aButtons, { "RELATORIO", { || MTABMAll() } ,"Marca Todos","Marca Todos" } )

cCodFil  := mv_par01
cCodGrp  := mv_par02

DEFINE MSDIALOG oDlgTab TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL
 
oLayer := FWLayer():New()
			
oLayer:Init( oDlgTab, .F. )
			
oLayer:AddLine('LineGrp',15,.F.)

oLayer:AddColumn('ColGrp',100,.T.,'LineGrp')
oLayer:AddWindow('ColGrp','WinGrp','Filial / Grupo Cotação',100,.F.,.F.,,'LineGrp')
			
oLayer:AddLine('LineFor',25,.F.)

oLayer:AddColumn('Col001',90,.T.,'LineFor')
oLayer:AddWindow('Col001','WinFor','Fornecedores',100,.F.,.F.,,'LineFor')
		
oLayer:AddColumn('Col002',10,.T.,'LineFor')
oLayer:AddWindow('Col002','WinDescF','Descontos',100,.F.,.F.,,'LineFor')
			
oLayer:AddLine('LineProd',40,.F.)			

oLayer:AddColumn('Col003',100,.T.,'LineProd')
oLayer:AddWindow('Col003','WinProd','Produtos',100,.F.,.F.,,'LineProd')
			
	
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

// Descontos
oPanelDF := oLayer:GetWinPanel('Col002','WinDescF','LineFor')
@ 001,001 BUTTON "Fornecedor" SIZE 45,12 ACTION ( CarregaZ17() ) OF oPanelDF PIXEL
@ 020,001 BUTTON "Produto"    SIZE 45,12 ACTION ( CarregaZ19() ) OF oPanelDF PIXEL

// Produtos
oPanelPro := oLayer:GetWinPanel('Col003','WinProd','LineProd')
@001,001 FOLDER oFolder OF oPanelPro PROMPT "Tabela de Preco", "Alteracao de Preco" PIXEL SIZE oPanelPro:nRight/2,oPanelPro:nBottom/2.1

oFolder:bSetOption := { |nOption| MTABOption( nOption ) }

oGetZ18 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[1]:nBottom/2, oFolder:aDialogs[1]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[1], aHeadZ18[oListFor:nAt], aColsZ18[oListFor:nAt] )
oGetZ18:oBrowse:bChange := { || AtuDisplay( 1 ) }

AlignObject( oFolder:aDialogs[1], { oGetZ18:oBrowse }, 1, 1, { 100 } )

CarregaZ20()

oGetZ20 := MsNewGetDados():New( 0, 0, oFolder:aDialogs[2]:nBottom/2, oFolder:aDialogs[2]:nRight/2, GD_UPDATE,,,,,, 9999,,,, oFolder:aDialogs[2], aHeadZ20, aColsZ20 )
oGetZ20:oBrowse:bChange := { || AtuDisplay( 2 ) }

AlignObject( oFolder:aDialogs[2], { oGetZ20:oBrowse }, 1, 1, { 100 } )

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
	aHeadZ18[__nItemAtu__] := aClone( oGetZ18:aHeader )
	aColsZ18[__nItemAtu__] := aClone( oGetZ18:aCols )
Endif

oGetZ18:aHeader	:= aClone( aHeadZ18[oListFor:nAt] )
oGetZ18:aCols 	:= aClone( aColsZ18[oListFor:nAt] )

oGetZ18:Refresh()

__nItemAtu__ := oListFor:nAt

AtuDisplay( 1 )

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
		lRetFun := .F.
		Help( Nil, Nil, "Help", Nil, "Nao existe fornecedores x grupo de cotacao cadastrado", 1, 0 )
	Else
		MsgRun( "Aguarde, selecionando registros", "Tabela de Preco", { || CarregaZ18() } )
	Endif

	oListFor:SetArray( aListFor )
	oListFor:bLine := {|| { aListFor[oListFor:nAt,1], aListFor[oListFor:nAt,2], aListFor[oListFor:nAt,3], aListFor[oListFor:nAt,4] } }
	oListFor:bChange := {|| ChangeFor() }
	oListFor:Refresh()

Endif

RestArea( aAreaAtu )

Return lRetFun

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
			nPrcBrut := TMP_AIB->AIB_PRCCOM
		Else
			nPrcBrut := 0
		Endif
		
		TMP_AIB->( dbCloseArea() )
		
		SB1->( dbSeek( xFilial( "SB1" ) + SA5->A5_PRODUTO ) )
		
		GDFieldPut( "Z18_PROFOR", SA5->A5_CODPRF	, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		GDFieldPut( "Z18_PROISA", SA5->A5_PRODUTO	, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		GDFieldPut( "Z18_PIPI"  , SB1->B1_IPI		, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		nPIPI := SB1->B1_IPI

		cQuery := "SELECT DA1_PRCVEN, DA1_DATVIG, DA1.R_E_C_N_O_ RECDA1 "
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
			GDFieldPut( "Z18_IDDA1" , TMP_DA1->RECDA1, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
			GDFieldPut( "Z18_DTDA1" , StoD( TMP_DA1->DA1_DATVIG ), nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		Else
			nPVenda	:= 0
		Endif
		
		TMP_DA1->( dbCloseArea() )

		GDFieldPut( "Z18_PVENDA" , nPVenda , nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )

		nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
		
		Z17->( dbSetOrder( 1 ) )
		Z17->( dbSeek( xFilial( "Z17" ) + aListFor[nLoop][1] + aListFor[nLoop][2] ) )
		While Z17->( ! Eof() ) .and. Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) == xFilial( "Z17" ) + aListFor[nLoop][1] + aListFor[nLoop][2]
			nCustF -= nCustF * ( Z17->Z17_DESC / 100 )
			Z17->( dbSkip() )
		End
		
		Z19->( dbSetOrder( 1 ) )
		Z19->( dbSeek( xFilial( "Z19" ) + aListFor[nLoop][1] + aListFor[nLoop][2] + SA5->A5_PRODUTO ) )
		While Z19->( ! Eof() ) .and. Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) == xFilial( "Z19" ) + aListFor[nLoop][1] + aListFor[nLoop][2] + SA5->A5_PRODUTO
			nCustF -= nCustF * ( Z19->Z19_DESC / 100 )
			Z19->( dbSkip() )
		End		
				
		GDFieldPut( "Z18_CUSTF" , nCustF, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )
		
		If nCustF != 0
			nMargem := ( ( nPVenda / nCustF ) - 1 ) * 100
		Else
			nMargem := 0
		Endif

		GDFieldPut( "Z18_MARGEM" , nMargem, nItem, aHeadZ18[nLoop], aColsZ18[nLoop] )

		aColsZ18[nLoop][nItem][Len( aHeadZ18[nLoop] ) + 1] := .F.

		TMP_SA5->( dbSkip() )
	
	End 
	
	TMP_SA5->( dbCloseArea() )	
	
Next nLoop

RestArea( aAreaAtu )

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
Static Function AtuDisplay( nFolder )

Local cProduto := ""

If nFolder == 1
	cProduto := GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
Else
	cProduto := GDFieldGet( "Z20_PROISA", oGetZ20:oBrowse:nAt, Nil, aHeadZ20, oGetZ20:aCols )
Endif

SB1->( dbSetOrder( 1 ) )
SB1->( dbSeek( xFilial( "SB1" ) + cProduto ) )
cNome := SB1->B1_DESC
oNome:Refresh()
/*
SB5->( dbSetOrder( 1 ) )
SB5->( dbSeek( xFilial( "SB5" ) + cProduto ) )
cDescricao := SB5->B5_CEME
*/    
cDescricao := SB1->B1__DESCP
oDescricao:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Funcao para Ordernar
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABOrd

Local nOpcao := 0

Local nPosIsa := 0
Local nPosFor := 0

nOpcao := Aviso( "Ordenar", "Escolha a ordenacao", { "It.Isapa", "It.Forn" } )

If oFolder:nOption == 1

	nPosIsa := GDFieldPos( 'Z18_PROISA', oGetZ18:aHeader )
	nPosFor := GDFieldPos( 'Z18_PROFOR', oGetZ18:aHeader )
	
	If nOpcao == 1
		aSort( oGetZ18:aCols,,, { |x,y| x[nPosIsa] < y[nPosIsa] } )
	
	ElseIf nOpcao == 2
		aSort( oGetZ18:aCols,,, { |x,y| x[nPosFor] < y[nPosFor] } )
		
	Endif
	
	oGetZ18:Refresh()

Else

	nPosIsa := GDFieldPos( 'Z20_PROISA', oGetZ20:aHeader )
	nPosFor := GDFieldPos( 'Z20_PROFOR', oGetZ20:aHeader )
	
	If nOpcao == 1
		aSort( oGetZ20:aCols,,, { |x,y| x[nPosIsa] < y[nPosIsa] } )
	
	ElseIf nOpcao == 2
		aSort( oGetZ20:aCols,,, { |x,y| x[nPosFor] < y[nPosFor] } )
		
	Endif
	
	oGetZ20:Refresh()

Endif

Return

//-----------------------------------------------------------------------------------------------------------------------
// Calculo na alteracao do preco bruto
//-----------------------------------------------------------------------------------------------------------------------
User Function MTabPBru( lCpo )

Local nPrcBrut := 0 

Local nCustF	:= 0
Local nMargem	:= 0
Local nPVenda	:= GDFieldGet( "Z18_PVENDA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
Local nPIPI	:= GDFieldGet( "Z18_PIPI"  , oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
Local cProd	:= GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )

Local nDescs  := 0

Default lCpo := .T.

If lCpo .and. Empty( cProd )
	Help( Nil, Nil, "Help", Nil, "Linha em branco nao e possivel informar preco bruto", 1, 0 )
	Return .F.
Endif 

If lCpo
	nPrcBrut := &( ReadVar() )
Else
	nPrcBrut := GDFieldGet( "Z18_PBRUTO", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols )
Endif

nCustF := nPrcBrut * ( ( nPIPI / 100 ) + 1 )
		
Z17->( dbSetOrder( 1 ) )
Z17->( dbSeek( xFilial( "Z17" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] ) )
While Z17->( ! Eof() ) .and. Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) == xFilial( "Z17" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2]
	nCustF -= nCustF * ( Z17->Z17_DESC / 100 )
	Z17->( dbSkip() )
End
		
Z19->( dbSetOrder( 1 ) )
Z19->( dbSeek( xFilial( "Z19" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] + cProd ) )
While Z19->( ! Eof() ) .and. Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) == xFilial( "Z19" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] + cProd
	nCustF -= nCustF * ( Z19->Z19_DESC / 100 )
	Z19->( dbSkip() )
End		
				
GDFieldPut( "Z18_CUSTF" , nCustF, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
		
If nCustF != 0
	nMargem	:= ( ( nPVenda / nCustF ) - 1 ) * 100
Endif

GDFieldPut( "Z18_MARGEM" , nMargem, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )
GDFieldPut( "Z18_PVENDA" , nPVenda, oGetZ18:oBrowse:nAt, oGetZ18:aHeader, oGetZ18:aCols )

oGetZ18:oBrowse:Refresh()

lAltPBru := .T.

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Carrega Z17
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ17

Local nOpc  := 0
Local nOpcA := 0

Local oDlgDesc

Local bBloco := { || .T. }

Local nCntFor := 0
Local nBkpAt	:= 0

If oFolder:nOption == 2
	Help( Nil, Nil, "Help", Nil, "Opcao disponivel apenas na folder tabela de preco", 1, 0 )
	Return
Endif

Z17->( dbSetOrder( 1 ) )
If Z17->( dbSeek( xFilial( "Z17" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] ) )
	nOpc := 4
Else
	nOpc := 3
Endif

aColsZ17 := {}
aRecsZ17 := {}
aHeadZ17 := {}

FillGetDados( nOpc,;
				"Z17",;
				1,;
				xFilial( "Z17" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2],;
				{ || Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) },;
				Nil,;
				{ "Z17_FORNEC", "Z17_LOJA" },;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				nOpc == 3,;
				aHeadZ17,;
				aColsZ17 )

If ( nAux := GDFieldPos( 'Z17_REC_WT', aHeadZ17 ) ) > 0
	aRecsZ17 := {}
	For nCntFor := 1 To Len( aColsZ17 )
		aAdd( aRecsZ17, aColsZ17[nCntFor][nAux] )
	Next nCntFor
Endif
		                                   
If Empty( GDFieldGet( "Z17_ITEM", 1, Nil, aHeadZ17, aColsZ17 ) )
	GDFieldPut( "Z17_ITEM"  , StrZero( 1, TamSX3( "Z17_ITEM" )[1] ), 1, aHeadZ17, aColsZ17 )
Endif

DEFINE MSDIALOG oDlgDesc TITLE "Descontos" FROM _LIDLG/4, _CIDLG/4 TO _LFDLG/4, _CFDLG/4 of oMainWnd PIXEL

oGetZ17 := MsNewGetDados():New( 0, 0, oDlgDesc:nBottom/2, oDlgDesc:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z17_ITEM",,, 9999,,,, oDlgDesc, aHeadZ17, aColsZ17 )

AlignObject( oDlgDesc, { oGetZ17:oBrowse }, 1, 1, { 100 } )

ACTIVATE MSDIALOG oDlgDesc ON INIT EnchoiceBar( oDlgDesc, { || nOpcA := 1, oDlgDesc:End() }, { || oDlgDesc:End() } )

If nOpcA == 1
	
	bBloco := { || 	Z17->Z17_FORNEC := aListFor[oListFor:nAt][1],;
						Z17->Z17_LOJA   := aListFor[oListFor:nAt][2] } 
	
	GavGaCols( oGetZ17:aCols, oGetZ17:aHeader, aRecsZ17, "Z17", bBloco, Nil, nOpc )

	nBkpAt := oGetZ18:oBrowse:nAt
	
	For nCntFor := 1 To Len( oGetZ18:aCols )
		oGetZ18:oBrowse:nAt := nCntFor
		U_MTabPBru( .F. )
	Next nCntFor
	
	oGetZ18:oBrowse:nAt := nBkpAt

Endif

Return

//-----------------------------------------------------------------------------------------------------------------------
// Carrega Z19
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ19

Local nOpc  := 0
Local nOpcA := 0

Local oDlgDesc

Local bBloco := { || .T. }

Local nCntFor := 0

If oFolder:nOption == 2
	Help( Nil, Nil, "Help", Nil, "Opcao disponivel apenas na folder tabela de preco", 1, 0 )
	Return
Endif

Z19->( dbSetOrder( 1 ) )
If Z19->( dbSeek( xFilial( "Z19" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] + GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols ) ) )
	nOpc := 4
Else
	nOpc := 3
Endif

aColsZ19 := {}
aRecsZ19 := {}
aHeadZ19 := {}

FillGetDados( nOpc,;
				"Z19",;
				1,;
				xFilial( "Z19" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2] + GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols ),;
				{ || Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) },;
				Nil,;
				{ "Z19_FORNEC", "Z19_LOJA", "Z19_PRODUT" },;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				nOpc == 3,;
				aHeadZ19,;
				aColsZ19 )

If ( nAux := GDFieldPos( 'Z19_REC_WT', aHeadZ19 ) ) > 0
	aRecsZ19 := {}
	For nCntFor := 1 To Len( aColsZ19 )
		aAdd( aRecsZ19, aColsZ19[nCntFor][nAux] )
	Next nCntFor
Endif
		                                   
If Empty( GDFieldGet( "Z19_ITEM", 1, Nil, aHeadZ19, aColsZ19 ) )
	GDFieldPut( "Z19_ITEM"  , StrZero( 1, TamSX3( "Z19_ITEM" )[1] ), 1, aHeadZ19, aColsZ19 )
Endif

DEFINE MSDIALOG oDlgDesc TITLE "Descontos" FROM _LIDLG/4, _CIDLG/4 TO _LFDLG/4, _CFDLG/4 of oMainWnd PIXEL

oGetZ19 := MsNewGetDados():New( 0, 0, oDlgDesc:nBottom/2, oDlgDesc:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,"+Z19_ITEM",,, 9999,,,, oDlgDesc, aHeadZ19, aColsZ19 )

AlignObject( oDlgDesc, { oGetZ19:oBrowse }, 1, 1, { 100 } )

ACTIVATE MSDIALOG oDlgDesc ON INIT EnchoiceBar( oDlgDesc, { || nOpcA := 1, oDlgDesc:End() }, { || oDlgDesc:End() } )

If nOpcA == 1
	
	bBloco := { || 	Z19->Z19_FORNEC := aListFor[oListFor:nAt][1],;
						Z19->Z19_LOJA   := aListFor[oListFor:nAt][2],;
						Z19->Z19_PRODUT := GDFieldGet( "Z18_PROISA", oGetZ18:oBrowse:nAt, Nil, oGetZ18:aHeader, oGetZ18:aCols ) } 
	
	GavGaCols( oGetZ19:aCols, oGetZ19:aHeader, aRecsZ19, "Z19", bBloco, Nil, nOpc )

	U_MTabPBru( .F. )

Endif

Return

//-----------------------------------------------------------------------------------------------------------------------
// Atualiza Preco Bruto
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABBrut

Local aAreaAtu := GetArea()

Local nLoopList := 0
Local nLoopZ18  := 0

Local cProdut := ""
Local nRecAIB := 0
Local nPBruto := 0
Local cItAIB  := ""

Local cQuery  := ""

If oFolder:nOption != 1
	Help( Nil, Nil, "Help", Nil, "Opcao disponivel apenas na folder tabela de preco", 1, 0 )
	Return
Endif


If !lAltPBru
	Help( Nil, Nil, "Help", Nil, "Nao ocorreram alteracoes, dessa forma nao e necessario atualizar o preco bruto", 1, 0 )
	Return
Endif

If !MsgYesNo( "Confirma atualizacao do preco bruto?")
	Return
Endif

aHeadZ18[oListFor:nAt] := aClone( oGetZ18:aHeader )
aColsZ18[oListFor:nAt] := aClone( oGetZ18:aCols )


For nLoopList := 1 To Len( aListFor )

	For nLoopZ18 := 1 To Len( aColsZ18[nLoopList] )

		nRecAIB := GDFieldGet( "Z18_IDAIB" , nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		nPBruto := GDFieldGet( "Z18_PBRUTO", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		cProdut := GDFieldGet( "Z18_PROISA", nLoopZ18, Nil, aHeadZ18[nLoopList], aColsZ18[nLoopList] )
		
		If Empty( cProdut )
			Loop
		Endif		
		
		If nRecAIB > 0
			AIB->( dbGoTo( nRecAIB ) )
			
			RecLock( "AIB", .F. )
			AIB->AIB_PRCCOM := nPBruto
			AIB->( MsUnLock() )
		
		Else
			cQuery := "SELECT R_E_C_N_O_ RECAIA "
			cQuery += "  FROM " + RetSQLName( "AIA" )
			cQuery += " WHERE AIA_FILIAL = '" + xFilial( "AIB" ) + "' "
			cQuery += "   AND AIA_CODFOR = '" + aListFor[nLoopList][1] + "' "
			cQuery += "   AND AIA_LOJFOR = '" + aListFor[nLoopList][2] + "' "
			cQuery += "   AND '" + DtoS( dDataBase ) + "' >= AIA_DATDE "
			cQuery += "   AND ( AIA_DATATE = '" + Space( TamSX3( "AIA_DATATE" )[1] ) + "' OR '" + DtoS( dDataBase ) + "' <= AIA_DATATE ) "
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			
			If Select( "TMP_AIA" ) > 0
				TMP_AIA->( dbCloseArea() )
			Endif
			
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_AIA", .T., .F. )
			
			If TMP_AIA->( ! Eof() )
				
				AIA->( dbGoTo( TMP_AIA->RECAIA ) )
			
			Else
				
				RecLock( "AIA", .T. )
				AIA->AIA_FILIAL := xFilial( "AIA" )
				AIA->AIA_CODFOR := aListFor[nLoopList][1]
				AIA->AIA_LOJFOR := aListFor[nLoopList][2]
				AIA->AIA_CODTAB := GetSX8Num( "AIA", "AIA_CODTAB") 
				AIA->AIA_DESCRI := "FORNECEDOR"
				AIA->AIA_DATDE  := dDataBase
				AIA->AIA_DATATE := dDataBase + 365
				AIA->( MsUnLock() )
			
			Endif
			
			TMP_AIA->( dbCloseArea() )
			
			cItAIB := GetItAIB( AIA->AIA_CODFOR, AIA->AIA_LOJFOR, AIA->AIA_CODTAB )
			
			RecLock( "AIB", .T. )
			AIB->AIB_FILIAL := xFilial( "AIB" )
			AIB->AIB_CODFOR := AIA->AIA_CODFOR
			AIB->AIB_LOJFOR := AIA->AIA_LOJFOR
			AIB->AIB_CODTAB := AIA->AIA_CODTAB
			AIB->AIB_ITEM   := cItAIB
			AIB->AIB_CODPRO := cProdut
			AIB->AIB_PRCCOM := nPBruto
			AIB->AIB_QTDLOT := 999999.99
			AIB->AIB_INDLOT := "000000000999999.99"
			AIB->AIB_MOEDA  := 1  
			AIB->AIB_DATVIG := dDataBase
			AIB->AIB_FRETE  := 0
			AIB->AIB__CTFIM := 0
			AIB->( MsUnLock() )
		
		Endif

	Next nLoopZ18

Next nLoopList 

lGrvPBru := .T.

MsgInfo( "Atualizacao efetuada com sucesso!" )

RestArea( aAreaAtu )

Return

//-----------------------------------------------------------------------------------------------------------------------
// Busca ultimo item na AIB e retorna esse item + 1
//-----------------------------------------------------------------------------------------------------------------------
Static Function GetItAIB( cCodFor, cLojFor, cCodTab )

Local aAreaAtu := GetArea()

Local cRetFun := StrZero( 1, TamSX3( "AIB_ITEM" )[1] )
Local cQuery  := ""

cQuery := "SELECT MAX( AIB_ITEM ) AIB_ITEM "
cQuery += "  FROM " + RetSQLName( "AIB" )
cQuery += " WHERE AIB_FILIAL = '" + xFilial( "AIB") + "' "
cQuery += "   AND AIB_CODFOR = '" + cCodFor + "' "
cQuery += "   AND AIB_LOJFOR = '" + cLojFor + "' "
cQuery += "   AND AIB_CODTAB = '" + cCodTab + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "

If Select( "TMP_AIB" ) > 0
	TMP_AIB->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_AIB", .T., .F. )

If TMP_AIB->( ! Eof() )
	cRetFun := Soma1( TMP_AIB->AIB_ITEM )
Endif

TMP_AIB->( dbCloseArea() )
   
RestArea( aAreaAtu )

Return cRetFun

//-----------------------------------------------------------------------------------------------------------------------
// Atualiza Preco
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABPrec

Local aAreaAtu := GetArea() 
Local nLoop	 := 0

Local cAtualiz := ""
Local cProdut  := ""
Local nPrcVen  := 0
Local dNValid  := Ctod( "//" )
Local nRecDA1  := 0
Local cIdDA1	 := ""	 

If oFolder:nOption != 2
	Help( Nil, Nil, "Help", Nil, "Opcao disponivel apenas na folder alteracao de preco", 1, 0 )
	Return
Endif

If !lAltPrec
	Help( Nil, Nil, "Help", Nil, "Nao ocorreram alteracoes, dessa forma nao e necessario atualizar lista de preco", 1, 0 )
	Return
Endif

If !MsgYesNo( "Confirma atualizacao lista de preco")
	Return
Endif

For nLoop := 1 To Len( oGetZ20:aCols )

	cAtualiz := GDFieldGet( "Z20_ATUALI", nLoop, Nil, oGetZ20:aHeader, oGetZ20:aCols )
	
	IF cAtualiz == "1"

		cProdut  := GDFieldGet( "Z20_PROISA", nLoop, Nil, oGetZ20:aHeader, oGetZ20:aCols )
		nPrcVen  := GDFieldGet( "Z20_NPVEND", nLoop, Nil, oGetZ20:aHeader, oGetZ20:aCols )
		dNValid  := GDFieldGet( "Z20_NVALID", nLoop, Nil, oGetZ20:aHeader, oGetZ20:aCols )
		nRecDA1  := GDFieldGet( "Z20_IDDA1" , nLoop, Nil, oGetZ20:aHeader, oGetZ20:aCols )	 

		If Empty( cProdut )
			Loop
		Endif		
		
		If nRecDA1 > 0
			DA1->( dbGoTo( nRecDA1 ) )
			
			RecLock( "DA1", .F. )
			DA1->DA1_PRCVEN := nPrcVen
			DA1->DA1_DATVIG := dNValid
			DA1->( MsUnLock() )
		
		Else
		
			cQuery := "SELECT R_E_C_N_O_ RECDA0 "
			cQuery += "  FROM " + RetSQLName( "DA0" )
			cQuery += " WHERE DA0_FILIAL     = '" + xFilial( "DA0" ) + "' "
			cQuery += "   AND DA0_ATIVO      = '1' "
			cQuery += "   AND '" + DtoS( dDataBase ) + "' >= DA0_DATDE "
			cQuery += "   AND ( DA0_DATATE = '" + Space( TamSX3( "DA0_DATATE" )[1] ) + "' OR '" + DtoS( dDataBase ) + "' <= DA0_DATATE ) "
			cQuery += "   AND D_E_L_E_T_ = ' ' "
			
			If Select( "TMP_DA0" ) > 0
				TMP_DA0->( dbCloseArea() )
			Endif
			
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DA0", .T., .F. )
			
			If TMP_DA0->( ! Eof() )
				
				DA0->( dbGoTo( TMP_DA0->RECDA0 ) )
			
			Else
				RecLock( "DA0", .T. )
				DA0->DA0_FILIAL := xFilial( "DA0" )
				DA0->DA0_CODTAB := GetSX8Num( "DA0", "DA0_CODTAB" )
				DA0->DA0_DESCRI := "TABELA VENDA"
				DA0->DA0_HORADE := "00:00
				DA0->DA0_HORATE := "23:59"
				DA0->DA0_TPHORA := "1"
				DA0->DA0_ATIVO  := "1"
				DA0->( MsUnLock() )
			
			Endif
			
			TMP_DA0->( dbCloseArea() )
	
			cItDA1 := GetItDA1( DA0->DA0_CODTAB )
			
			RecLock( "DA1", .T. )
			DA1->DA1_FILIAL := xFilial( "DA1" )
			DA1->DA1_CODTAB := DA0->DA0_CODTAB
			DA1->DA1_ITEM   := cItDA1
			DA1->DA1_CODPRO := cProdut
			DA1->DA1_PRCVEN := nPrcVen
			DA1->DA1_ATIVO  := "1"
			
			If SM0->M0_CODFIL != "03"
				DA1->DA1_ESTADO :=  SM0->M0_ESTENT
			Endif
			
			DA1->DA1_TPOPER := "4"
			DA1->DA1_QTDLOT := 999999.99
			DA1->DA1_INDLOT := "000000000999999.99"
			DA1->DA1_MOEDA  := 1
			DA1->DA1_DATVIG := dNValid
			DA1->( MsUnLock() )
		
		Endif

	Endif

Next nLoop

MsgInfo( "Atualizacao realizada com sucesso" )

lGrvPrec	:= .T. 

Return

//-----------------------------------------------------------------------------------------------------------------------
// Busca ultimo item na DA1 e retorna esse item + 1
//-----------------------------------------------------------------------------------------------------------------------
Static Function GetItDA1( cCodTab )

Local aAreaAtu := GetArea()

Local cRetFun := StrZero( 1, TamSX3( "DA1_ITEM" )[1] )
Local cQuery  := ""

cQuery := "SELECT MAX( DA1_ITEM ) DA1_ITEM "
cQuery += "  FROM " + RetSQLName( "DA1" )
cQuery += " WHERE DA1_FILIAL = '" + xFilial( "DA1") + "' "
cQuery += "   AND DA1_CODTAB = '" + cCodTab + "' "
cQuery += "   AND D_E_L_E_T_ = ' ' "

If Select( "TMP_DA1" ) > 0
	TMP_DA1->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_DA1", .T., .F. )

If TMP_DA1->( ! Eof() )
	cRetFun := Soma1( TMP_DA1->DA1_ITEM )
Endif

TMP_DA1->( dbCloseArea() )
   
RestArea( aAreaAtu )

Return cRetFun

//-----------------------------------------------------------------------------------------------------------------------
// Troca de Folder
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABOption( nOption )

If nOption == 2 
	
	If lAltPBru .and. !lGrvPBru
	
		Help( Nil, Nil, "Help", Nil, "Antes de trocar a folder atualize o preco bruto", 1, 0 )
		Return .f.
	
	Else
		
		oListFor:disable()
		
		MsgRun( "Gerando alteracao preco", "Gerando", { || AtualizaZ20() } ) 
	
	Endif	
		
Endif

If nOption == 1

	If lAltPrec .and. !lGrvPrec
	
		If MsgYesNo( "As dados foram alterados ao mudar de folder sem gravar esses dados ser‹o perdidos. Confirma alteracao de folder?" )
			oListFor:enable()
		Else
			Return .f.
		Endif
	
	Else
		oListFor:enable()

	Endif
	
Endif

Return

//-----------------------------------------------------------------------------------------------------------------------
// Carrega Z20
//-----------------------------------------------------------------------------------------------------------------------
Static Function CarregaZ20

Local nOpc  := 3
Local nCntFor := 0

aColsZ20 := {}
aRecsZ20 := {}
aHeadZ20 := {}

FillGetDados( nOpc,;
				"Z20",;
				1,;
				xFilial( "Z20" ) + aListFor[oListFor:nAt][1] + aListFor[oListFor:nAt][2],;
				{ || Z20->( Z20_FILIAL + Z20_FORNEC + Z20_LOJA ) },;
				Nil,;
				{ "Z20_FORNEC", "Z20_LOJA", "Z20_PRODUT" },;
				Nil,;
				Nil,;
				Nil,;
				Nil,;
				nOpc == 3,;
				aHeadZ20,;
				aColsZ20 )

If ( nAux := GDFieldPos( 'Z20_REC_WT', aHeadZ20 ) ) > 0
	aRecsZ20 := {}
	For nCntFor := 1 To Len( aColsZ20 )
		aAdd( aRecsZ20, aColsZ20[nCntFor][nAux] )
	Next nCntFor
Endif
		                                   
Return

//-----------------------------------------------------------------------------------------------------------------------
// Atualiza Z20
//-----------------------------------------------------------------------------------------------------------------------
Static Function AtualizaZ20

Local nLoop   := 0
Local nCntFor := 0

Local cProFor := ""
Local cProIsa := ""
Local nCustF  := 0
Local nMargem := 0
Local nPVenda := 0
Local nIdDA1  := 0
Local dUValid := CtoD( "//" )

oGetZ20:aCols := {}

For nLoop := 1 To Len( oGetZ18:aCols )

	oGetZ20:AddLine( .F., .F. )
	
	cProFor := GDFieldGet( "Z18_PROFOR", nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	cProIsa := GDFieldGet( "Z18_PROISA", nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nCustF  := GDFieldGet( "Z18_CUSTF" , nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nMargem := GDFieldGet( "Z18_MARGEM", nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nPVenda := GDFieldGet( "Z18_PVENDA", nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	nIdDA1  := GDFieldGet( "Z18_IDDA1" , nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	dUValid := GDFieldGet( "Z18_VLDA1" , nLoop, Nil, oGetZ18:aHeader, oGetZ18:aCols )
	
	GDFieldPut( "Z20_PROFOR", cProFor, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_PROISA", cProIsa, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_CUSTF" , nCustF , nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_MARGEM", nMargem, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_PVENDA", nPVenda, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_UVALID", dUValid, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_NVALID", Ctod("//") , nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_IDDA1" , nIdDA1 , nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	
Next nCntFor

oGetZ20:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Calcula Preco atual ou margem
//-----------------------------------------------------------------------------------------------------------------------
User Function MTABCPV

Local nVarRead := &( ReadVar() )
Local cProd	 := GDFieldGet( "Z20_PROISA", oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols )
Local nCustF   := GDFieldGet( "Z20_CUSTF" , oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols )
Local nMrgAtu   := GDFieldGet( "Z20_MARGEM" , oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols )
Local nVAtu   := GDFieldGet( "Z20_PVENDA" , oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols )
Local nNMargem := 0
Local nNPVenda := 0

If Empty( cProd )
	Help( Nil, Nil, "Help", Nil, "Linha em branco nao e possivel informar o campo", 1, 0 )
	Return .F.
Endif 


If "Z20_NPVEND" $ ReadVar()
	
	nNMargem := (nVarRead - nVAtu) + nMrgAtu      
	//( ( nVarRead / nCustF ) - 1 ) * 100
	GDFieldPut( "Z20_NMARGE", nNMargem, oGetZ20:oBrowse:nAt, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_ATUALI", "1", oGetZ20:oBrowse:nAt, oGetZ20:aHeader, oGetZ20:aCols )

Endif

If "Z20_NMARGE" $ ReadVar()

	nNPVenda := nCustF + (nCustF * ( nVarRead / 100 ))
	GDFieldPut( "Z20_NPVEND", nNPVenda, oGetZ20:oBrowse:nAt, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_ATUALI", "1", oGetZ20:oBrowse:nAt, oGetZ20:aHeader, oGetZ20:aCols )

Endif

lAltPrec := .T.

Return .T.

//-----------------------------------------------------------------------------------------------------------------------
// Marcar todos os itens da lista de preco
//-----------------------------------------------------------------------------------------------------------------------
Static Function MTABMAll
Local nLoop := 0, _nPVenda := 0, _dDatVig := GDFieldGet( "Z20_NVALID", oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols )
Local _nPMargem := GDFieldGet( "Z20_NMARGE", oGetZ20:oBrowse:nAt, Nil, oGetZ20:aHeader, oGetZ20:aCols ), _nCusto := 0 
Local _nPos := aScan(oGetZ20:aHeader,{|x| AllTrim(x[2]) == "Z20_CUSTF"})
         
If oFolder:nOption != 2
	Help( Nil, Nil, "Help", Nil, "Opcao disponivel apenas na folder alteracao de preco", 1, 0 )
	Return
Endif

If !MsgYesNo( "Confirma marcacao de todos registros" )
	Return
Endif

For nLoop := 1 To Len( oGetZ20:aCols )
	GDFieldPut( "Z20_ATUALI", "1", nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	_nCusto  := oGetZ20:aCols[nLoop][_nPos]
	_nPVenda := _nCusto + (_nCusto * ( _nPMargem / 100 ))
	GDFieldPut( "Z20_NPVEND", _nPVenda, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_NVALID", _dDatVig, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
	GDFieldPut( "Z20_NMARGE", _nPMargem, nLoop, oGetZ20:aHeader, oGetZ20:aCols )
Next nLoop

lAltPrec := .T.

Return