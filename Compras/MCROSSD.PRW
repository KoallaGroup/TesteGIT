#Include 'Protheus.ch' 
#include "fwbrowse.ch"
#include "parmtype.ch"
#include "colors.ch"
#include "fwmvcdef.ch"

#DEFINE _LIDLG	aCoors[1]
#DEFINE _CIDLG	aCoors[2]
#DEFINE _LFDLG	aCoors[3]
#DEFINE _CFDLG	aCoors[4]

Static oOk := LoadBitmap( GetResources(), "ENABLE" )
Static oNo := LoadBitmap( GetResources(), "DISABLE" )

//-----------------------------------------------------------------------------------------------------------------------
/*/{Protheus.doc} MCROSSD
Inclusao do Crossdoking
@author Ivan Morelatto Tore
@since 20/11/2014
@version MP10.8, MP11.5

/*/
//-----------------------------------------------------------------------------------------------------------------------
User Function MCROSSD

Local aAreaAtu := GetArea()
Local aAreaSM0 := SM0->( GetArea() )
Local cFilBkp  := cFilAnt

Local nOpcA 	 := 0
Local cTitulo	 := "Crossdocking"

Local oCodFil
Local cCodFil  := Space( Len( SM0->M0_CODFIL ) )
Local cNomFil	 := ""
Local oNomFil

Local cDocDe	 := Space( TamSX3( "F1_DOC" )[1] )
Local oDocDe 

Local cDocAte	 := Space( TamSX3( "F1_DOC" )[1] )
Local oDocAte

Local dDataDe	 := Ctod( "//" ) 
Local oDataDe 

Local dDataAte := Ctod( "//" ) 
Local oDataAte

Local oLayer
Local oDlgNF
Local oPanelPar
Local oPanelNF

Local aButtons := {}

Private aCoors     := FWGetDialogSize( oMainWnd )
Private oFontArial := TFont():New( "Arial", Nil, 18, , .F. )

Private aListNF := { { .F., "", "", "", "", 0 } } 
Private oListNF

Private bF6 := { || MsgRun( "Selecionando Notas", "Selecionando", { || MCROSProc( cDocDe, cDocAte, dDataDe, dDataAte ) } ) }
Private bF7 := { || MsgRun( "Selecionando Itens", "Selecionando", { || MCROSItem() } ) }

INCLUI := .T.

aAdd( aButtons, { "RELATORIO", bF6 ,"Processar","Processar" } )
SetKey( VK_F6, bF6 )

aAdd( aButtons, { "RELATORIO", bF7 ,"Itens","Itens" } )
SetKey( VK_F7, bF7 )

DEFINE MSDIALOG oDlgNF TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL
 
oLayer := FWLayer():New()
			
oLayer:Init( oDlgNF, .F. )
			
// Parametros
oLayer:AddLine('LinePar',30,.F.)
oLayer:AddColumn('ColPar',100,.T.,'LinePar')
oLayer:AddWindow('ColPar','WinPar','Parametros',100,.F.,.F.,,'LinePar')
oPanelPar := oLayer:GetWinPanel('ColPar','WinPar','LinePar')

// Filial
@ 007, 010 SAY 'Filial:' FONT oFontArial SIZE 40,20 OF oPanelPar PIXEL
@ 006, 080 MSGET oCodFil VAR cCodFil PICTURE "@!" F3 'XM0' ;
	VALID VldFil( cCodFil, @oNomFil, @cNomFil ) ;
	WHEN .T. SIZE 50,10 FONT oFontArial OF oPanelPar PIXEL
@ 007, 140 SAY oNomFil VAR cNomFil FONT oFontArial SIZE 120,20 OF oPanelPar PIXEL
			
// Documento
@ 027, 010 SAY 'Documento De:' FONT oFontArial SIZE 50,20 OF oPanelPar PIXEL
@ 026, 080 MSGET oDocDe VAR cDocDe PICTURE "@!";
	WHEN .T. SIZE 50,10 FONT oFontArial OF oPanelPar PIXEL

@ 027, 140 SAY 'Ate' FONT oFontArial SIZE 10,20 OF oPanelPar PIXEL
@ 026, 160 MSGET oDocAte VAR cDocAte PICTURE "@!";
	WHEN .T. SIZE 50,10 FONT oFontArial OF oPanelPar PIXEL

// Data
@ 047, 010 SAY 'Data De:' FONT oFontArial SIZE 50,20 OF oPanelPar PIXEL
@ 046, 080 MSGET oDataDe VAR dDataDe PICTURE "@!";
	WHEN .T. SIZE 50,10 FONT oFontArial OF oPanelPar PIXEL

@ 047, 140 SAY 'Ate' FONT oFontArial SIZE 10,20 OF oPanelPar PIXEL
@ 046, 160 MSGET oDataAte VAR dDataAte PICTURE "@!";
	WHEN .T. SIZE 50,10 FONT oFontArial OF oPanelPar PIXEL

@ 35,235 Button oButton PROMPT "Processar"  SIZE 40,15   OF oPanelPar PIXEL ACTION (MCROSProc( cDocDe, cDocAte, dDataDe, dDataAte ))


// Notas Fiscais
oLayer:AddLine('LineNF',70,.F.)
oLayer:AddColumn('ColNF',100,.T.,'LineNF')
oLayer:AddWindow('ColNF','WinNF','Notas Fiscais',100,.F.,.F.,,'LineNF')

oPanelNF := oLayer:GetWinPanel('ColNF','WinNF','LineNF')
@ 01,01 LISTBOX oListNF FIELDS HEADER "", "Nota Fiscal", "Data Nota", "Cod. Processo", "Ref. Externa", "ID" SIZE ((oPanelNF:nRight/2)-5),((oPanelNF:nBottom/2)-30) OF oPanelNF PIXEL
oListNF:SetArray( aListNF )
oListNF:bLine    := {|| { If( aListNF[oListNF:nAt,1], oOk, oNo ), aListNF[oListNF:nAt,2], aListNF[oListNF:nAt,3], aListNF[oListNF:nAt,4], aListNF[oListNF:nAt,5], aListNF[oListNF:nAt,6] } }
oListNF:Refresh()

ACTIVATE MSDIALOG oDlgNF ON INIT EnchoiceBar( oDlgNF, { || nOpcA := 1, oDlgNF:End() }, { || oDlgNF:End() }, , aButtons )

SetKey( VK_F6, Nil )
SetKey( VK_F7, Nil ) 

cFilAnt := cFilBkp

RestArea( aAreaSM0 )
RestArea( aAreaAtu ) 

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
// Funcao para preencher o listbox de notas fiscais
//-----------------------------------------------------------------------------------------------------------------------
Static Function MCROSProc( cDocDe, cDocAte, dDataDe, dDataAte )

Local aAreaAtu := GetArea()
Local cQuery   := ""
Local lFound   := .T.

aListNF := {}

cQuery := "SELECT R_E_C_N_O_ RECSF1 "
cQuery += "  FROM " + RetSQLName( "SF1" ) 
cQuery += " WHERE F1_FILIAL   = '" + xFilial( "SF1" ) + "' "
cQuery += "   AND F1_DOC      BETWEEN '" + cDocDe + "' AND '" + cDocAte + "' "
cQuery += "   AND F1_DTDIGIT  BETWEEN '" + DtoS( dDataDe ) + "' AND '" + DtoS( dDataAte ) + "' "
cQuery += "   AND F1__PROIMP != '" + Space( TamSX3( "F1__PROIMP" )[1] ) + "' "
cQuery += "   AND F1__REFEXT != '" + Space( TamSX3( "F1__REFEXT" )[1] ) + "' "
//cQuery += "   AND F1__WMSENV  = '" + Space( TamSX3( "F1__WMSENV" )[1] ) + "' "  - Jorge H.
cQuery += "   AND F1__WMSINT  = '" + Space( TamSX3( "F1__WMSINT" )[1] ) + "' " 
cQuery += "   AND D_E_L_E_T_  = ' ' "

If Select( "TMP_SF1" ) > 0
	TMP_SF1->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SF1", .T., .F. )

While TMP_SF1->( ! Eof() )

	SF1->( dbGoTo( TMP_SF1->RECSF1 ) )
	
	SZX->( dbSetOrder( 2 ) )
	lFound := SZX->( dbSeek( xFilial( "SZX" ) + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA + F1_FORMUL ) ) )
	
	aAdd( aListNF, { !lFound, SF1->F1_DOC, SF1->F1_DTDIGIT, SF1->F1__PROIMP, SF1->F1__REFEXT, SF1->( RecNo() ) } )
	
	TMP_SF1->( dbSkip() )
End

If Empty( aListNF )
	aListNF := { { .F., "", "", "", "", 0 } } 
	Help( Nil, Nil, "Help", Nil, "Nao existem notas para os parametros informados", 1, 0 )
Endif

oListNF:SetArray( aListNF )
oListNF:bLine    := {|| { If( aListNF[oListNF:nAt,1], oOk, oNo ), aListNF[oListNF:nAt,2], aListNF[oListNF:nAt,3], aListNF[oListNF:nAt,4], aListNF[oListNF:nAt,5], aListNF[oListNF:nAt,6] } }
oListNF:Refresh()

TMP_SF1->( dbCloseArea() )

RestArea( aAreaAtu )

Return

//-----------------------------------------------------------------------------------------------------------------------
// Tela com os Itens
//-----------------------------------------------------------------------------------------------------------------------
Static Function MCROSItem

Local aAreaAtu := GetArea()
Local cQuery   := ""

Local nOpcA 	 := 0
Local cTitulo	 := "Itens Nota Fiscal"

Local oLayer
Local oDlgItens
Local oPanelNota
Local oPanelItem
Local oPanelDist

Local nLoop   := 0
Local nCntFor := 0
Local nAux    := 0
Local nOpcGet := 3

Local nSaveSX8  := GetSX8Len()

Local lGrvItem := .F.

Local cFilSZV := ""
Local nQtdSZV := 0

Local cNumCros := ""
Local nItem    := 0

Private aListIt := {}
Private oListIt

Private oGetSZV
Private aColsSZV := {}
Private aRecsSZV := {}
Private aHeadSZV := {}

Private __nItemAtu__ := 1

If ! aListNF[oListNF:nAt,1]
	Help( Nil, Nil, "Help", Nil, "Nao e permitido utilizar notas ja distribuidas", 1, 0 )
	Return
Endif

SetKey( VK_F6, Nil )
SetKey( VK_F7, Nil )

SF1->( dbGoTo( aListNF[oListNF:nAt,6] ) )

SD1->( dbSetOrder( 1 ) )
SD1->( dbSeek( xFilial( "SD1" ) + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA ) ) )
While SD1->( ! Eof() ) .and. SD1->( D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA ) == xFilial( "SD1" ) + SF1->( F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA )
	/*
	aAdd( aListIt, { 	SD1->D1_ITEM,;
						SD1->D1_COD,;
						Posicione( "SB1", 1, xFilial( "SB1" ) + SD1->D1_COD, "B1_DESC" ),;
						TransForm( SD1->D1_QUANT, PesqPict( "SD1", "D1_QUANT" ) ),;
						"Pendente",;
						SD1->( RecNo() ) } )
						*/
    aAdd( aListIt, {    SD1->D1_ITEM,;
                        SD1->D1_COD,;
                        Posicione( "SB1", 1, xFilial( "SB1" ) + SD1->D1_COD, "B1_DESC" ),;
                        SD1->D1_QUANT,;
                        "Pendente",;
                        SD1->( RecNo() ) } )
						
	SD1->( dbSkip() )
End	

aColsSZV := Array( Len( aListIt ) )
aFill( aColsSZV, {} ) 

aRecsSZV := Array( Len( aListIt ) )

aHeadSZV := Array( Len( aListIt ) )
aFill( aHeadSZV, {} ) 

For nLoop := 1 To Len( aListIt )

	FillGetDados( nOpcGet,;
					"SZV",;
					1,;
					xFilial( "SZV" ) + SD1->( D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA + D1_ITEM ),;
					{ || SZV->( ZV_FILIAL + ZV_DOC + ZV_SERIE + ZV_FORNECE + ZV_LOJA + ZV_ITEM ) },;
					Nil,;
					{ "ZV_DOC", "ZV_SERIE", "ZV_FORNECE", "ZV_LOJA", "ZV_ITEM" },;
					Nil,;
					Nil,;
					Nil,;
					Nil,;
					nOpcGet == 3,;
					aHeadSZV[nLoop],;
					aColsSZV[nLoop] )
	
	If ( nAux := GDFieldPos( 'ZV_REC_WT', aHeadSZV[nLoop] ) ) > 0
		aRecsSZV[nLoop] := {}
		For nCntFor := 1 To Len( aColsSZV[nLoop] )
			aAdd( aRecsSZV[nLoop], aColsSZV[nLoop][nCntFor][nAux] )
		Next nCntFor
	Endif

Next nLoop

DEFINE MSDIALOG oDlgItens TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL
 
oLayer := FWLayer():New()
			
oLayer:Init( oDlgItens, .F. )
			
// Nota Fiscal
oLayer:AddLine('LineNota',15,.F.)
oLayer:AddColumn('ColNota',100,.T.,'LineNota')
oLayer:AddWindow('ColNota','WinNota','Nota Fiscal',100,.F.,.F.,,'LineNota')

oPanelNota := oLayer:GetWinPanel('ColNota','WinNota','LineNota')

@ 007, 010 SAY 'Nota Fiscal: ' + aListNF[oListNF:nAt,2] + Space( 10 ) + ;
			    'Data NF: ' + DtoC( aListNF[oListNF:nAt,3] ) + Space( 10 ) + ;  
			    'Cod. Processo: ' + aListNF[oListNF:nAt,4] FONT oFontArial SIZE 400,20 OF oPanelNota PIXEL

// Itens
oLayer:AddLine('LineItem',55,.F.)
oLayer:AddColumn('ColItem',100,.T.,'LineItem')
oLayer:AddWindow('ColItem','WinItem','Itens da Nota Fiscal',100,.F.,.F.,,'LineItem')

oPanelItem := oLayer:GetWinPanel('ColItem','WinItem','LineItem')

@ 01,01 LISTBOX oListIt FIELDS HEADER "Item", "Produto", "Descricao", "Quantidade", "Status", "ID" SIZE ((oPanelItem:nRight/2)-5),((oPanelItem:nBottom/2)-20) OF oPanelItem PIXEL
oListIt:SetArray( aListIt )
oListIt:bLine    := {|| { aListIt[oListIt:nAt,1], aListIt[oListIt:nAt,2], aListIt[oListIt:nAt,3], aListIt[oListIt:nAt,4], aListIt[oListIt:nAt,5], aListIt[oListIt:nAt,6] } }
oListIt:bChange  := {|| ChangeIt() }
oListIt:Refresh()

// Distribuicao
oLayer:AddLine('LineDist',30,.F.)
oLayer:AddColumn('ColDist',100,.T.,'LineDist')
oLayer:AddWindow('ColDist','WinDist','Distribuicao',100,.F.,.F.,,'LineDist')

oPanelDist := oLayer:GetWinPanel('ColDist','WinDist','LineDist')

For nLoop := 1 To Len( aColsSZV )
	oGetSZV := MsNewGetDados():New( 0, 0, oPanelDist:nBottom/2, oPanelDist:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,,,, 9999,,,"U_MCrosDel()", oPanelDist, aHeadSZV[nLoop], aColsSZV[nLoop] )	

	aHeadSZV[nLoop] := oGetSZV:aHeader
	aColsSZV[nLoop] := oGetSZV:aCols
Next nLoop

oGetSZV := MsNewGetDados():New( 0, 0, oPanelDist:nBottom/2, oPanelDist:nRight/2, GD_INSERT + GD_DELETE + GD_UPDATE,,,,,, 9999,,,"U_MCrosDel()", oPanelDist, aHeadSZV[oListIt:nAt], aColsSZV[oListIt:nAt] )

ACTIVATE MSDIALOG oDlgItens ON INIT EnchoiceBar( oDlgItens, { || If( MsgYesNo( "Confirma Gravacao?") , ( nOpcA := 1, oDlgItens:End() ), Nil ) }, { || oDlgItens:End() }, , /*aButtons*/ )

If nOpcA == 1

	SF1->( dbGoTo( aListNF[oListNF:nAt,6] ) )
	
	lGrvItem := .F.
	cNumCros := CriaVar( "ZW_NUMERO" )
	nItem    := 0
	
	aHeadSZV[__nItemAtu__] := aClone( oGetSZV:aHeader )
	aColsSZV[__nItemAtu__] := aClone( oGetSZV:aCols )
	
	For nCntFor := 1 To Len( aListIt )
	
		SD1->( dbGoTo( aListIt[nCntFor,6] ) )
	
		For nLoop := 1 To Len( aColsSZV[nCntFor] )
			
			If !GDDeleted( nLoop, aHeadSZV[nCntFor], aColsSZV[nCntFor] )
				
				cFilSZV := GDFieldGet( "ZV_CODFIL", nLoop, Nil, aHeadSZV[nCntFor], aColsSZV[nCntFor] )
				nQtdSZV := GDFieldGet( "ZV_QUANT" , nLoop, Nil, aHeadSZV[nCntFor], aColsSZV[nCntFor] )
				
				If ! Empty( cFilSZV ) .and. ! Empty( nQtdSZV )
				
					nItem++ 
					
					RecLock( "SZX", .T. )
					SZX->ZX_FILIAL  := xFilial( "SZX" )
					SZX->ZX_NUMERO  := cNumCros
					SZX->ZX_PROIMP  := SF1->F1__PROIMP
					SZX->ZX_FORMUL  := SF1->F1_FORMUL
					SZX->ZX_SEGISP  := SF1->F1__SEGISP
					SZX->ZX_ITEM    := StrZero( nItem, TamSX3( "ZX_ITEM" )[1] )
					SZX->ZX_DOC     := SD1->D1_DOC
					SZX->ZX_SERIE   := SD1->D1_SERIE
					SZX->ZX_FORNECE := SD1->D1_FORNECE
					SZX->ZX_LOJA    := SD1->D1_LOJA
					SZX->ZX_ITEMNF  := SD1->D1_ITEM
					SZX->ZX_PRODUTO := SD1->D1_COD
					SZX->ZX_QTDNF   := SD1->D1_QUANT
					SZX->ZX_FILDES  := cFilSZV
					SZX->ZX_QUANT   := nQtdSZV
					SZX->ZX_SALDO   := nQtdSZV
					SZX->( MsUnLock() ) 
					
					lGrvItem := .T.	
				
				Endif
				
			Endif
			
		Next nLoop
	
	Next nCntFor

	If lGrvItem
		RecLock( "SZW", .T. )
		SZW->ZW_FILIAL := xFilial( "SZW" )
		SZW->ZW_NUMERO := cNumCros
		SZW->ZW_PROIMP := SF1->F1__PROIMP
		SZW->ZW_DATA   := dDataBase
		SZW->( MsUnLock() )

		aListNF[oListNF:nAt][1] := .F.
		oListNF:Refresh()

		While GetSX8Len() > nSaveSx8
			ConfirmSX8()
		EndDo	

	Else
		While GetSX8Len() > nSaveSx8
			RollBackSX8()
		EndDo
	Endif
	
Else

	While GetSX8Len() > nSaveSx8
		RollBackSX8()
	EndDo		

Endif

SetKey( VK_F6, bF6 )
SetKey( VK_F7, bF7 )

RestArea( aAreaAtu )

Return

//-----------------------------------------------------------------------------------------------------------------------
// Troca de Item
//-----------------------------------------------------------------------------------------------------------------------
Static Function ChangeIt

If __nItemAtu__ != oListIt:nAt
	aHeadSZV[__nItemAtu__] := aClone( oGetSZV:aHeader )
	aColsSZV[__nItemAtu__] := aClone( oGetSZV:aCols )
Endif

oGetSZV:aHeader	:= aClone( aHeadSZV[oListIt:nAt] )
oGetSZV:aCols 	:= aClone( aColsSZV[oListIt:nAt] )

__nItemAtu__ := oListIt:nAt

oGetSZV:Refresh()

Return

//-----------------------------------------------------------------------------------------------------------------------
// Valida Filial
//-----------------------------------------------------------------------------------------------------------------------
User Function MCrosFil

Local aAreaAtu := GetArea()
Local aAreaSM0 := SM0->( GetArea() )
Local lRetFun  := ExistCpo("SM0", cEmpAnt + M->ZV_CODFIL )

If lRetFun
	lRetFun := M->ZV_CODFIL != cFilAnt
Endif

If !lRetFun
	Help( Nil, Nil, "Help", Nil, "Nao e permitido distribuir para mesma filial", 1, 0 )
Else
	SM0->( dbSetOrder( 1 ) )
	SM0->( dbSeek( cEmpAnt + M->ZV_CODFIL ) )
	
	GDFieldPut( "ZV_DESCFIL", AllTrim( SM0->M0_NOME ) + " / " + AllTrim( SM0->M0_FILIAL ), oGetSZV:oBrowse:nAt, oGetSZV:aHeader, oGetSZV:aCols )
Endif

RestArea( aAreaSM0 )
RestArea( aAreaAtu )

Return lRetFun

//-----------------------------------------------------------------------------------------------------------------------
// Valida Quantidade
//-----------------------------------------------------------------------------------------------------------------------
User Function MCrosQtd

Local lRetFun := .T.
Local nQtdDig := 0
Local nCntFor := 0

For nCntFor := 1 To Len( oGetSZV:aCols )

	If !GDDeleted( nCntFor, oGetSZV:aHeader, oGetSZV:aCols )	
		
		If nCntFor == oGetSZV:oBrowse:nAt
			If IsInCallStack( "U_MCrosDel" )
				nQtdDig += GDFieldGet( "ZV_QUANT", nCntFor, Nil, oGetSZV:aHeader, oGetSZV:aCols ) 
			Else
				nQtdDig += &( ReadVar() )
			Endif
		Else
			nQtdDig += GDFieldGet( "ZV_QUANT", nCntFor, Nil, oGetSZV:aHeader, oGetSZV:aCols ) 
		Endif
	
	Endif

Next nCntFor

If IsInCallStack( "U_MCrosDel" )
	If !GDDeleted( oGetSZV:oBrowse:nAt, oGetSZV:aHeader, oGetSZV:aCols ) 
		nQtdDig -= GDFieldGet( "ZV_QUANT", oGetSZV:oBrowse:nAt, Nil, oGetSZV:aHeader, oGetSZV:aCols ) 
	Else
		nQtdDig += GDFieldGet( "ZV_QUANT", oGetSZV:oBrowse:nAt, Nil, oGetSZV:aHeader, oGetSZV:aCols )
	Endif
Endif

If nQtdDig > aListIt[oListIt:nAt,4]
	Help( Nil, Nil, "Help", Nil, "Quantidade digitada supera a quantidade da nota", 1, 0 )
	lRetFun := .F.
Endif

If lRetFun
	If nQtdDig > 0
		aListIt[oListIt:nAt,5] := "Importado"
	Else
		aListIt[oListIt:nAt,5] := "Pendente"
	Endif
	oListIt:Refresh()
Endif

Return lRetFun                                      

//-----------------------------------------------------------------------------------------------------------------------
// Valida Delecao
//-----------------------------------------------------------------------------------------------------------------------
User Function MCrosDel
Return U_MCrosQtd()