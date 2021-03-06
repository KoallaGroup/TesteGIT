#Include 'Protheus.ch' 
#include "fwbrowse.ch"
#include "parmtype.ch"
#include "colors.ch"
#include "fwmvcdef.ch"

#DEFINE _LIDLG	aCoors[1]
#DEFINE _CIDLG	aCoors[2]
#DEFINE _LFDLG	aCoors[3]
#DEFINE _CFDLG	aCoors[4]

Static cEol := Chr( 13 ) + Chr( 10 )

//-------------------------------------------------------------------
/*/{Protheus.doc} CROSSD_MVC
Cadastro de Crossdocking

@author Ivan Morelatto Tor�
@since 14/06/2014
@version P11
/*/
//-------------------------------------------------------------------
User Function CROSSD_MVC()

Local oBrowse

Local bMenuDef    := {|| MenuDef() }	//Apenas para nao entrar em Warning de Compilacao
Local bModelDef   := {|| ModelDef() }	//Apenas para nao entrar em Warning de Compilacao
Local bViewDef    := {|| ViewDef() }	//Apenas para nao entrar em Warning de Compilacao

oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'SZW' )
oBrowse:SetDescription( 'Crossdocking' )

oBrowse:Activate()

Return Nil

//-------------------------------------------------------------------
// Montagem do aRotina
//-------------------------------------------------------------------
Static Function MenuDef()

Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.CROSSD_MVC' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.CROSSD_MVC' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.CROSSD_MVC' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.CROSSD_MVC' OPERATION 5 ACCESS 0
ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.CROSSD_MVC' OPERATION 8 ACCESS 0

Return aRotina

//-------------------------------------------------------------------
// Montagem ModelDef
//-------------------------------------------------------------------
Static Function ModelDef()

// Cria a estrutura a ser usada no Modelo de Dados
Local oStruSZW := FWFormStruct( 1, 'SZW', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruSZX := FWFormStruct( 1, 'SZX', /*bAvalCampo*/, /*lViewUsado*/ )
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'CROSSDM', /*bPreValidacao*/, { |oModel| CrossDOk( oModel ) } /*bPosValidacao*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formul�rio de edi��o por campo
oModel:AddFields( 'SZWMASTER', /*cOwner*/, oStruSZW )

// Adiciona ao modelo uma estrutura de formul�rio de edi��o por grid
oModel:AddGrid( 'SZXDETAIL', 'SZWMASTER', oStruSZX, { |oModelGrid, nLine, cAction, cField| CrossDPre( oModelGrid, nLine, cAction, cField ) } /*bLinePre*/, /*bLinePost*/, /*bPreVal*/, /*bPosVal*/, /*BLoad*/ )

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation( 'SZXDETAIL', { { 'ZX_FILIAL', 'xFilial( "SZX" )' }, { 'ZX_NUMERO', 'ZW_NUMERO' }, { 'ZX_PROIMP', 'ZW_PROIMP' }  }, SZX->( IndexKey( 1 ) ) )

// Liga o controle de nao repeticao de linha
oModel:GetModel( 'SZXDETAIL' ):SetUniqueLine( { 'ZX_ITEM' } )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Crossdocking' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'SZWMASTER' ):SetDescription( 'Cabe�alho Crossdocking' )
oModel:GetModel( 'SZXDETAIL' ):SetDescription( 'Itens Crossdocking'  )

oModel:SetPrimaryKey( { "ZW_FILIAL", "ZW_NUMERO", "ZW_PROIMP" } )

Return oModel

//-------------------------------------------------------------------
// Montagem ViewDef
//-------------------------------------------------------------------
Static Function ViewDef()

// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruSZW := FWFormStruct( 2, 'SZW' )
Local oStruSZX := FWFormStruct( 2, 'SZX' )

// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'CROSSD_MVC' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados ser� utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_SZW', oStruSZW, 'SZWMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid( 'VIEW_SZX', oStruSZX, 'SZXDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 30 )
oView:CreateHorizontalBox( 'INFERIOR', 70 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_SZW', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_SZX', 'INFERIOR' )

// Liga a identificacao do componente
oView:EnableTitleView('VIEW_SZW','Cabe�alho Crossdocking')
oView:EnableTitleView('VIEW_SZX','Itens Crossdocking')

// Campo de Incremental
oView:AddIncrementField( 'VIEW_SZX', 'ZX_ITEM' )

Return oView

//-------------------------------------------------------------------
// Tela F3 para sele��o dos itens da NF
//-------------------------------------------------------------------
User Function CrossDNF

Local lOK  		:= .F.
Local cVar 		:= Upper( Alltrim( ReadVar() ) )
Local cConteudo	:= &( ReadVar() )
Local cDoc		:= ""
Local aNotas	:= {}
Local cQuery	:= ""
Local nPosItem	:= 0

Local oModel    := FWModelActive()
Local oModelSZW := oModel:GetModel( "SZWMASTER" )
Local oModelSZX := oModel:GetModel( "SZXDETAIL" )

Local oView		:= FWViewActive()

If Empty( oModelSZW:GetValue( "ZW_PROIMP" ) )
	Help( Nil, Nil, "Help", Nil, "Favor preencher o numero do processo de importa��o", 1, 0 ) 
	M->ZX_DOC := cConteudo
	Return lOk
Endif

If cVar == "M->ZX_DOC"

	cQuery := "SELECT F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_FORMUL, D1_ITEM, D1_COD, D1_QUANT " + cEol
	cQuery += "  FROM " + RetSQLName( "SF1" ) + " SF1 " + cEol
	cQuery += "  JOIN " + RetSQLName( "SD1" ) + " SD1 " + cEol 
	cQuery += "    ON D1_FILIAL      = '" + xFilial( "SD1" ) + "' " + cEol
	cQuery += "   AND D1_DOC         = F1_DOC " + cEol
	cQuery += "   AND D1_SERIE       = F1_SERIE " + cEol
	cQuery += "   AND D1_FORNECE     = F1_FORNECE " + cEol
	cQuery += "   AND D1_LOJA        = D1_LOJA " + cEol
	//cQuery += "   AND D1_FORMUL      = F1_FORMUL " + cEol
	cQuery += "   AND SD1.D_E_L_E_T_ = ' ' " + cEol
	cQuery += " WHERE F1_FILIAL      = '" + xFilial( "SF1" ) + "' " + cEol
	cQuery += "   AND F1__PROIMP     = '" + oModelSZW:GetValue( "ZW_PROIMP" ) + "' " + cEol
	cQuery += "   AND F1_TIPO        = 'N' " + cEol
	cQuery += "   AND SF1.D_E_L_E_T_ = ' '" + cEol  
	cQuery += "   AND SF1.F1__WMSINT = ' '" + cEol
	
	If Select( "TMP_SF1" ) > 0
		TMP_SF1->( dbCloseArea() )
	Endif

	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SF1", .T., .F. )

	While TMP_SF1->( !Eof() )
	
		aAdd( aNotas, { .F.,;
						TMP_SF1->F1_DOC,;
						TMP_SF1->F1_SERIE,;
						TMP_SF1->F1_FORNECE,;
						TMP_SF1->F1_LOJA,;
						Posicione( "SA2", 1, xFilial( "SA2" ) + TMP_SF1->(F1_FORNECE + F1_LOJA), "A2_NOME" ),;    
						TMP_SF1->F1_FORMUL,;
						TMP_SF1->D1_ITEM,;
						TMP_SF1->D1_COD,;
						Posicione( "SB1", 1, xFilial( "SB1" ) + TMP_SF1->D1_COD, "B1_DESC" ),;
						TMP_SF1->D1_QUANT,;
						SB1->B1__SEGISP } )						
	
		TMP_SF1->( dbSkip() )	
	End
	
	If Empty( aNotas )
		Help( Nil, Nil, "Help", Nil, "N�o foram encontradas notas para o processo de importa��o informado", 1, 0 )
		M->ZX_DOC := cConteudo
		Return lOk
	Endif
	
	lOk := ExibeNotas( @aNotas, @cDoc )
	
	If lOk 
		M->ZX_DOC := cDoc
		
		nPosItem := aScan( aNotas, { |x| x[1] == .T. } )
		
		If nPosItem > 0
	
			oModelSZX:SetValue( "ZX_SERIE"  , aNotas[nPosItem][03] )
			oModelSZX:SetValue( "ZX_FORNECE", aNotas[nPosItem][04] )
			oModelSZX:SetValue( "ZX_LOJA"   , aNotas[nPosItem][05] )
			oModelSZX:SetValue( "ZX_NOMFOR" , aNotas[nPosItem][06] )
			oModelSZX:SetValue( "ZX_FORMUL" , aNotas[nPosItem][07] )
			oModelSZX:SetValue( "ZX_ITEMNF" , aNotas[nPosItem][08] )
			oModelSZX:SetValue( "ZX_PRODUTO", aNotas[nPosItem][09] )
			oModelSZX:SetValue( "ZX_DESPROD", aNotas[nPosItem][10] )
			oModelSZX:SetValue( "ZX_QTDNF"  , aNotas[nPosItem][11] )
			oModelSZX:SetValue( "ZX_SEGISP" , aNotas[nPosItem][12] )
			
			oView:Refresh()
	
		Endif		
	
	Else
		M->ZX_DOC := cConteudo
	EndIf

Endif

Return lOk

//-------------------------------------------------------------------
// Exibe Tela F3 para sele��o dos itens da NF
//-------------------------------------------------------------------
Static Function ExibeNotas( aRegs, cDoc )

Local cTitulo	:= "Documento de Entrada"
Local aCoors	:= FWGetDialogSize( oMainWnd )

Local oDlg
Local oPanelLst
Local oListRegs
Local oOk 		:= LoadBitmap(GetResources(), "LBOK")
Local oNo 		:= LoadBitmap(GetResources(), "LBNO")

Local lRetFun := .F.

Local aButtons := {}

// Montagem da Tela
DEFINE MSDIALOG oDlg TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL

// Cria��o da Layer
oLayer := FWLayer():New()
oLayer:Init( oDlg, .F. )

// Linha com os registros
oLayer:AddLine( 'LineLst', 100, .F. )

// Coluna e Janela dos registros
oLayer:AddColumn( 'ColLst' , 100, .T., 'LineLst' )
oLayer:AddWindow( 'ColLst', 'WinLst', 'Marque o item desejado', 100, .F., .F., , 'LineLst' )

// Montagem do listbox dos Registros
oPanelLst := oLayer:GetWinPanel('ColLst','WinLst','LineLst')

@ 01,01 LISTBOX oListRegs FIELDS HEADER "",;
									"Notas Fiscal",;
							  	    "Serie",;
						  	    	"Fornecedor",;
						  	    	"Loja",;
						  	    	"Raz�o Social",;
						  	    	"Formulario",;
									"Item NF",;
									"C�digo",;
									"Descri��o",;
									"Quantidade",;
									"Segmento";
									SIZE oPanelLst:nRight / 2.02, oPanelLst:nBottom / 2.25;
									OF oPanelLst PIXEL

oListRegs:SetArray( aRegs )

oListRegs:bLine := { || { If( aRegs[oListRegs:nAt,01], oOk, oNo ),;
						  aRegs[oListRegs:nAt,02],;
						  aRegs[oListRegs:nAt,03],;
						  aRegs[oListRegs:nAt,04],;
						  aRegs[oListRegs:nAt,05],;
						  aRegs[oListRegs:nAt,06],;
						  aRegs[oListRegs:nAt,07],;
						  aRegs[oListRegs:nAt,08],;
						  aRegs[oListRegs:nAt,09],;
						  aRegs[oListRegs:nAt,10],;
						  Transform( aRegs[oListRegs:nAt,11], PesqPict( "SZX", "ZX_QTDNF" ) ),;
						  aRegs[oListRegs:nAt,12]  } }

oListRegs:bLdbLClick := { || ( 	aEval( aRegs, { |x| x[1] := .F. } ),;
								aRegs[oListRegs:nAt,1] := If( !Empty( aRegs[oListRegs:nAt,2]), !aRegs[oListRegs:nAt,1], aRegs[oListRegs:nAt,1]),;
								cDoc := aRegs[oListRegs:nAt,2],;
								oListRegs:Refresh() ) }

						  
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || lRetFun := .T., oDlg:End() }, { || oDlg:End() }, , aButtons )

Return lRetFun

//-------------------------------------------------------------------
// Valida��o da quantidade
//-------------------------------------------------------------------
User Function CrossDQt

Local oModel    := FWModelActive()
Local oModelSZX := oModel:GetModel( "SZXDETAIL" )
Local lRetFun	:= .T.

If oModelSZX:GetValue( "ZX_PEDVEN" ) > 0
	lRetFun := .F.
	Help( Nil, Nil, "Help", Nil, "N�o � permitido alterar a quantidade pois j� existem pedidos de venda", 1, 0 )
Endif

If M->ZX_QUANT > oModelSZX:GetValue( "ZX_QTDNF" )
	lRetFun := .F.
	Help( Nil, Nil, "Help", Nil, "Quantidade informada maior que quantidade da nota", 1, 0 )
Endif

Return lRetFun

//-------------------------------------------------------------------
// Valida��o total da tela
//-------------------------------------------------------------------
Static Function CrossDOk( oModel )

Local aAreaAtu   := GetArea()
Local lRetFun    := .T.
Local nCntFor    := 0
Local oModelSZW  := oModel:GetModel( "SZWMASTER" )
Local oModelSZX  := oModel:GetModel( "SZXDETAIL" )
Local nOperation := oModel:GetOperation()
Local aSaveLines := FWSaveRows()
Local nPos		 := 0
Local aTotais    := {}
Local cMens		 := ""
Local cQuery	 := ""

// Inclus�o ou Altera��o
If nOperation == 3 .or. nOperation == 4

	// Analisa a Tela
	For nCntFor := 1 To oModelSZX:Length()
		
		oModelSZX:GoLine( nCntFor )
		
		If !oModelSZX:IsDeleted()
		
			nPos := aScan( aTotais, { |x| x[1] + x[2] + x[3] + x[4] + x[6] + x[7] == oModelSZX:GetValue( "ZX_DOC" )     + ;
																			  	     oModelSZX:GetValue( "ZX_SERIE" )   + ;
																			  		 oModelSZX:GetValue( "ZX_FORNECE" ) + ;
																			  		 oModelSZX:GetValue( "ZX_LOJA" )    + ;
																			  	     oModelSZX:GetValue( "ZX_FORMUL" )  + ;
																			  		 oModelSZX:GetValue( "ZX_ITEMNF" ) } )
			
			If nPos == 0
				
				aAdd( aTotais, { oModelSZX:GetValue( "ZX_DOC" ),;
								 oModelSZX:GetValue( "ZX_SERIE" ),;
								 oModelSZX:GetValue( "ZX_FORNECE" ),;
								 oModelSZX:GetValue( "ZX_LOJA" ),;
								 oModelSZX:GetValue( "ZX_NOMFOR" ),;
								 oModelSZX:GetValue( "ZX_FORMUL" ),;
								 oModelSZX:GetValue( "ZX_ITEMNF" ),;
								 oModelSZX:GetValue( "ZX_PRODUTO" ),;
								 oModelSZX:GetValue( "ZX_DESPROD" ),;
								 oModelSZX:GetValue( "ZX_QTDNF" ),;
								 oModelSZX:GetValue( "ZX_QUANT" ) } )
								 
			Else
			
				aTotais[nPos][11] += oModelSZX:GetValue( "ZX_QUANT" )
			
			Endif
		
		Endif
	
	Next nCntFor
	
	nPos := aScan( aTotais, { |x| x[11] > x[10] } )
	
	If nPos > 0
		lRetFun := .F.
		cMens := "NF: " + aTotais[nPos][1] + " Serie: " + aTotais[nPos][2] + cEol
		cMens += "Fornecedor: " + aTotais[nPos][3] + " Loja: " + aTotais[nPos][4] + cEol
		cMens += "Produto: " + aTotais[nPos][8] + " esta com a quantidade " + cEol
		cMens += "informada " + AllTrim( Str( aTotais[nPos][11] ) ) + " maior que a " + cEol
		cMens += "quantidade da nota fiscal " + AllTrim( Str( aTotais[nPos][10] ) )     	   
		Help( Nil, Nil, "Help", Nil, cMens, 1, 0 )
	Endif
	
	// Se na tela o valor n�o est� maior verifica nas SZX j� gravadas
	If lRetFun
	
		// Analisa outros Crossdockings
		For nCntFor := 1 To Len( aTotais )
		
			cQuery := "SELECT ISNULL( SUM( ZX_QUANT ), 0 ) QUANT " + cEol
			cQuery += "  FROM " + RetSQLName( "SZX" ) + cEol
			cQuery += " WHERE ZX_FILIAL  = '" + xFilial( "SZX" ) + "' " + cEol
			cQuery += "   AND ZX_DOC     = '" + aTotais[nCntFor][1] + "' " + cEol
			cQuery += "   AND ZX_SERIE   = '" + aTotais[nCntFor][2] + "' " + cEol
			cQuery += "   AND ZX_FORNECE = '" + aTotais[nCntFor][3] + "' " + cEol
			cQuery += "   AND ZX_LOJA    = '" + aTotais[nCntFor][4] + "' " + cEol
			cQuery += "   AND ZX_FORMUL  = '" + aTotais[nCntFor][6] + "' " + cEol
			cQuery += "   AND ZX_ITEMNF  = '" + aTotais[nCntFor][7] + "' " + cEol
			cQuery += "   AND D_E_L_E_T_ = ' ' And ZX_NUMERO <> '" + M->ZW_NUMERO + "' " + cEol
			cQuery := ChangeQuery(cQuery)
			
			If Select( "TMP_SZX" ) > 0
				TMP_SZX->( dbCloseArea() )
			EndIf
			
			dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZX", .T., .F. )
			aTotais[nCntFor][11] += TMP_SZX->QUANT
			TMP_SZX->( dbCloseArea() )
			
		Next nCntFor
		
		nPos := aScan( aTotais, { |x| x[11] > x[10] } )
		
		If nPos > 0
			lRetFun := .F.
			cMens := "NF: " + aTotais[nPos][1] + " Serie: " + aTotais[nPos][2] + cEol
			cMens += "Fornecedor: " + aTotais[nPos][3] + " Loja: " + aTotais[nPos][4] + cEol
			cMens += "Produto: " + aTotais[nPos][8] + " esta com a quantidade " + cEol
			cMens += "informada + Quantidade em outro Crossdocking " + AllTrim( Str( aTotais[nPos][11] ) ) + " maior que a " + cEol
			cMens += "quantidade da nota fiscal " + AllTrim( Str( aTotais[nPos][10] ) )     	   
			Help( Nil, Nil, "Help", Nil, cMens, 1, 0 )
		Endif
		
	EndIf

EndIf

// Exclus�o validar pedido de venda
If nOperation == 5
	
	cQuery := "SELECT COUNT(*) QTDPED "
	cQuery += "  FROM " + RetSQLName( "SC6" ) + cEol
	cQuery += " WHERE C6_FILIAL  = '" + xFilial( "SC6" ) + "' " + cEol
	cQuery += "   AND C6__CROSSD  = '" + oModelSZW:GetValue( "ZW_NUMERO" ) + "' " + cEol
	cQuery += "   AND C6__PROIMP  = '" + oModelSZW:GetValue( "ZW_PROIMP" ) + "' " + cEol
	cQuery += "   AND D_E_L_E_T_ = ' '" + cEol

	If Select( "TMP_SC6" ) > 0
		TMP_SC6->( dbCloseArea() )
	EndIf
			
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC6", .T., .F. )
	lRetFun := TMP_SC6->QTDPED == 0
	TMP_SC6->( dbCloseArea() )
	
	If !lRetFun
		Help( Nil, Nil, "Help", Nil, "N�o � possivel realizar a exclus�o pois existem pedidos vinculados a esse Crossdocking", 1, 0 )
	Endif

EndIf

FWRestRows( aSaveLines )

RestArea( aAreaAtu ) 

Return lRetFun

//-------------------------------------------------------------------
// Valida��o da exclus�o da linha na altera��o
//-------------------------------------------------------------------
Static Function CrossDPre( oModelGrid, nLinha, cAcao, cCampo )

Local lRetFun 	 := .T.
Local oModel     := FWModelActive()
Local oModelSZW  := oModel:GetModel( "SZWMASTER" )
Local oModelSZX  := oModel:GetModel( "SZXDETAIL" )
Local nOperation := oModelSZW:GetOperation()
Local cQuery	 := ""

// Valida se pode ou n�o apagar uma linha do Grid
If cAcao == "DELETE" .and. nOperation == 4

	cQuery := "SELECT COUNT(*) QTDPED " + cEol
	cQuery += "  FROM " + RetSQLName( "SC6" ) + cEol
	cQuery += " WHERE C6_FILIAL  = '" + xFilial( "SC6" ) + "' " + cEol
	cQuery += "   AND C6__CROSSD  = '" + oModelSZW:GetValue( "ZW_NUMERO" ) + "' " + cEol
	cQuery += "   AND C6__PROIMP  = '" + oModelSZW:GetValue( "ZW_PROIMP" ) + "' " + cEol
	cQuery += "   AND C6__ITCROS = '" + oModelSZX:GetValue( "ZX_ITEM" ) + "' " + cEol
	cQuery += "   AND D_E_L_E_T_ = ' '" + cEol

	If Select( "TMP_SC6" ) > 0
		TMP_SC6->( dbCloseArea() )
	EndIf
			
	dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC6", .T., .F. )
	lRetFun := TMP_SC6->QTDPED == 0
	TMP_SC6->( dbCloseArea() )
	
	If !lRetFun
		Help( Nil, Nil, "Help", Nil, "N�o � possivel realizar a exclus�o pois existem pedidos vinculados a esse Crossdocking", 1, 0 )
	Endif

EndIf

Return lRetFun


//-------------------------------------------------------------------
// Rotina para relacionar o crossdocking com o pedido de venda
//-------------------------------------------------------------------
User Function CrossDPed

Local aAreaAtu 	:= GetArea()
Local aAreaSA1	:= SA1->( GetArea() )
Local aAreaSM0	:= SM0->( GetArea() )
Local aGetMVs	:= SaveMVs()
Local cPerg		:= "CROSSDPED"
Local cProImp	:= ""
Local cQuery	:= ""
Local aCrossDoc := {}
Local lOk		:= .F.

If M->C5_TIPO != "N"
	Help( Nil, Nil, "Help", Nil, "Op��o v�lida apenas para pedidos normais", 1, 0 )
	Return
EndIf

If Empty( M->C5_CLIENTE ) .or. Empty( M->C5_LOJACLI )
	Help( Nil, Nil, "Help", Nil, "Informe o cliente e loja antes de abrir o Crossdocking", 1, 0 )
	Return
EndIf

SA1->( dbSetOrder( 1 ) )
If SA1->( ! dbSeek( xFilial( "SA1" ) + M->C5_CLIENTE + M->C5_LOJACLI ) )
	Help( Nil, Nil, "Help", Nil, "Informe um cliente e loja v�lido", 1, 0 )
	Return
EndIf

ValidSX1( cPerg )

If !Pergunte( cPerg, .T. )
	RestMVs( aGetMVs )
	Return
Endif

cProImp := MV_PAR01

cQuery := "SELECT R_E_C_N_O_ RECSZX " + cEol
cQuery += "  FROM " + RetSQLName( "SZX" )  + cEol
cQuery += " WHERE ZX_FILIAL  = '" + xFilial( "SZX" ) + "' "
cQuery += "   AND ZX_PROIMP  = '" + cProImp + "' "
cQuery += "   AND ZX_SALDO   > 0 "
cQuery += "   AND D_E_L_E_T_ = ' ' "

If Select( "TMP_SZX" ) > 0
	TMP_SZX->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZX", .T., .F. )

While TMP_SZX->( !Eof() )

	SZX->( dbGoTo( TMP_SZX->RECSZX ) ) 
	
	SM0->( dbSeek( cEmpAnt + SZX->ZX_FILDES ) )
	
	If SM0->M0_CGC == SA1->A1_CGC 
		
		SZX->( aAdd( aCrossDoc, {	.T.,;
									ZX_NUMERO ,;
									ZX_PROIMP ,;
									ZX_ITEM   ,;
									ZX_DOC    ,;
									ZX_SERIE  ,;
									ZX_FORNECE,;
									ZX_LOJA   ,;
									Posicione( "SA2", 1, xFilial( "SA2" ) + ZX_FORNECE + ZX_LOJA, "A2_NOME" ),;
									ZX_FORMUL ,;
									ZX_ITEMNF ,;
									ZX_PRODUTO,;
									Posicione( "SB1", 1, xFilial( "SB1" ) + ZX_PRODUTO, "B1_DESC" ),;
									ZX_QTDNF  ,;
									ZX_FILDES ,;
									ZX_QUANT  ,;
									ZX_PEDVEN ,;
									ZX_SALDO } ) ) 
	
	Endif

	TMP_SZX->( dbSkip() )
End

TMP_SZX->( dbCloseArea() ) 

If Empty( aCrossDoc )
	Help( Nil, Nil, "Help", Nil, "N�o foram encontrados Crossdocking para o cliente informado", 1, 0 )

Else
	lOk := ExibeCross( @aCrossDoc )
Endif

RestMVs( aGetMVs )
RestArea( aAreaSA1 )
RestArea( aAreaSM0 )
RestArea( aAreaAtu )

Return

//-------------------------------------------------------------------
// Salva os MV_PAR?? da rotina
//-------------------------------------------------------------------
Static Function SaveMVs

Local aRetFun := {}
Local nCntFor := 0

For nCntFor := 1 To 99
	If Type( "MV_PAR" + StrZero( nCntFor, 2 ) ) != "U"
		aAdd( aRetFun, { "MV_PAR" + StrZero( nCntFor, 2 ), &( "MV_PAR" + StrZero( nCntFor, 2 ) ) } )
	Endif
Next nCntFor

Return aRetFun

//-------------------------------------------------------------------
// Restaura os MV_PAR?? da rotina
//-------------------------------------------------------------------
Static Function RestMVs( aMVs )

Local nCntFor := 0

For nCntFor := 1 To Len( aMVs )
	&( aMVs[nCntFor][1] ) := aMVs[nCntFor][2]
Next nCntFor

Return

//-------------------------------------------------------------------
// Cria grupo de perguntas
//-------------------------------------------------------------------
Static Function ValidSX1( cPerg )

Local aAreaAtu  := GetArea()
Local aPergs  	:= {}
Local aHelpPor	:= {}
Local aHelpEng	:= {}
Local aHelpSpa	:= {}
Local cKey    	:= ""
             
aAdd( aPergs, { "Processo Importa��o " ,"Processo Importa��o      ", "Processo Importa��o    ","mv_ch1","C",TamSX3("F1__PROIMP")[1],0,0,"G","","mv_par01","","","","","","","","","","","","","","","","","","","","","","","","","SZW","" } )

AjustaSx1( cPerg, aPergs )                        

aHelpPor := {}
aHelpEng := {}
aHelpSpa := {}
cKey 	 := "P." + AllTrim( cPerg ) + "01."
aAdd( aHelpPor, 'Informe o Processo de Importa��o do     ' )
aAdd( aHelpPor, 'Crossdocking.' )
PutSX1Help( cKey, aHelpPor, aHelpEng, aHelpSpa )

RestArea( aAreaAtu )

Return

//-------------------------------------------------------------------
// Exibe Crossdocking
//-------------------------------------------------------------------
Static Function ExibeCross( aRegs )

Local cTitulo	:= "Crossdocking"
Local aCoors	:= FWGetDialogSize( oMainWnd )

Local oDlg
Local oPanelLst
Local oListRegs
Local oOk 		:= LoadBitmap(GetResources(), "LBOK")
Local oNo 		:= LoadBitmap(GetResources(), "LBNO")

Local lRetFun := .F.

Local aButtons := {}

// Montagem da Tela
DEFINE MSDIALOG oDlg TITLE cTitulo FROM _LIDLG, _CIDLG TO _LFDLG, _CFDLG of oMainWnd PIXEL

// Cria��o da Layer
oLayer := FWLayer():New()
oLayer:Init( oDlg, .F. )

// Linha com os registros
oLayer:AddLine( 'LineLst', 100, .F. )

// Coluna e Janela dos registros
oLayer:AddColumn( 'ColLst' , 100, .T., 'LineLst' )
oLayer:AddWindow( 'ColLst', 'WinLst', 'Marque os itens desejados', 100, .F., .F., , 'LineLst' )

// Montagem do listbox dos Registros
oPanelLst := oLayer:GetWinPanel('ColLst','WinLst','LineLst')

@ 01,01 LISTBOX oListRegs FIELDS HEADER "",;
										"Crossdocking",;
							  	    	"Proc. Import.",;
						  	    		"Item",;
						  	    		"Nota Fiscal",;
						  	    		"Serie",;
							  	    	"Fornecedor",;
										"Loja",;
										"Nome",;
										"Formulario",;
										"Item NF",;
										"Produto",;
										"Descri��o",;
										"Qtd NF",;
										"Fil. Des.",;
										"Quantidade",;
										"Qtd.Ped.Ven.",;
										"Saldo";
										SIZE oPanelLst:nRight / 2.02, oPanelLst:nBottom / 2.25;
										OF oPanelLst PIXEL

oListRegs:SetArray( aRegs )

oListRegs:bLine := { || { If( 	aRegs[oListRegs:nAt,01], oOk, oNo ),;
								aRegs[oListRegs:nAt,02],;
						  		aRegs[oListRegs:nAt,03],;
								aRegs[oListRegs:nAt,04],;
								aRegs[oListRegs:nAt,05],;
								aRegs[oListRegs:nAt,06],;
								aRegs[oListRegs:nAt,07],;
								aRegs[oListRegs:nAt,08],;
								aRegs[oListRegs:nAt,09],;
								aRegs[oListRegs:nAt,10],;
								aRegs[oListRegs:nAt,11],;
								aRegs[oListRegs:nAt,12],;
								aRegs[oListRegs:nAt,13],;
								Transform( aRegs[oListRegs:nAt,14], PesqPict( "SZX", "ZX_QTDNF" ) ),;
								aRegs[oListRegs:nAt,15],;
								Transform( aRegs[oListRegs:nAt,16], PesqPict( "SZX", "ZX_QUANT" ) ),;
								Transform( aRegs[oListRegs:nAt,17], PesqPict( "SZX", "ZX_PEDVEN" ) ),;
								Transform( aRegs[oListRegs:nAt,18], PesqPict( "SZX", "ZX_SALDO" ) ) } }

oListRegs:bLdbLClick := { || ( 	aRegs[oListRegs:nAt,1] := If( !Empty( aRegs[oListRegs:nAt,2]), !aRegs[oListRegs:nAt,1], aRegs[oListRegs:nAt,1]),;
								cDoc := aRegs[oListRegs:nAt,2],;
								oListRegs:Refresh() ) }
						  
ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar( oDlg, { || lRetFun := GravaCols( aRegs ), oDlg:End() }, { || oDlg:End() }, , aButtons )

Return lRetFun

//-------------------------------------------------------------------
// Alimenta aCols
//-------------------------------------------------------------------
Static Function GravaCols( aCrossDoc )

Local aAreaSX3	:= GetArea()
Local lRet		:= .T.
Local aColsAux	:= aClone( aCols[1] )
Local cItem		:= Replicate( "0", TamSX3( "C6_ITEM" )[1] )
Local aColsBkp	:= aClone( aCols )
Local nCntFor   := 0
Local nCntCpo	:= 0
Local nCusto	:= 0
Local cTESPad	:= GetNewPar( "ES_TESCROS", "501" )

// Atualiza aColsAux para linha em branco
aEval( aHeader, { | _aH, _nInd | If( ! "_WT" $ _aH[2], aColsAux[_nInd] := CriaVar( aHeader[_nInd][2] ), Nil ) } )
aColsAux[Len( aColsAux )] := .F.

// Limpa aCols do Pedido de Venda
aCols := {}

// Preenche aCols
For nCntFor := 1 To Len( aCrossDoc )

	If aCrossDoc[nCntFor][1]
		
		nCusto := Posicione( "SB2", 1, xFilial( "SB2" ) + aCrossDoc[nCntFor][12], "B2_CM1" )
		
		If nCusto <= 0
			nCusto := 1
		Endif 
		
		cItem := Soma1( cItem )
		
		aAdd( aCols, aClone( aColsAux ) )
		
		DbSelectArea("SD1")
		DbSetOrder(1)
		DbSeek(xFilial("SD1") + aCrossDoc[nCntFor][5] + aCrossDoc[nCntFor][6] + aCrossDoc[nCntFor][7] + aCrossDoc[nCntFor][8] + aCrossDoc[nCntFor][12] + aCrossDoc[nCntFor][11])
		
		n := Len( aCols )
		
		aCols[n][GDFieldPos( "C6_ITEM" )] := cItem
		
		M->C6_QTDVEN := aCrossDoc[nCntFor][18]
		
		A410Produto( aCrossDoc[nCntFor][12], .F. )
		A410MultT( "C6_PRODUTO", aCrossDoc[nCntFor][12] )
		aCols[n][GDFieldPos( "C6_PRODUTO" )] := aCrossDoc[nCntFor][12]
		M->C6_PRODUTO := aCrossDoc[nCntFor][12]
		
		If ExistTrigger( "C6_PRODUTO" )				
			RunTrigger( 2, n, Nil, Nil, "C6_PRODUTO" )		
		Endif
		
		A410MultT( "C6_QTDVEN", aCrossDoc[nCntFor][18] )
		aCols[n][GDFieldPos( "C6_QTDVEN" )] := aCrossDoc[nCntFor][18]
		
        A410MultT( "C6_LOCAL", SD1->D1_LOCAL )
        aCols[n][GDFieldPos( "C6_LOCAL" )] := SD1->D1_LOCAL
		
		A410MultT( "C6_PRCVEN", nCusto )
		aCols[n][GDFieldPos( "C6_PRCVEN" )] := nCusto
		
//		A410MultT( "C6_TES", cTESPad )
//		aCols[n][GDFieldPos( "C6_TES" )] := cTESPad

		aCols[n][GDFieldPos( "C6__CROSSD" )]  := aCrossDoc[nCntFor][02]
		aCols[n][GDFieldPos( "C6__PROIMP" )]  := aCrossDoc[nCntFor][03]
		aCols[n][GDFieldPos( "C6__ITCROS" )]  := aCrossDoc[nCntFor][04]

	Endif
	
Next nCntFor

// Dispara valida��es e gatilhos
SX3->( dbSetOrder( 2 ) )

For nCntFor := 1 To Len( aCols )

	n:= nCntFor
	
	For nCntCpo := 1 to Len( aCols[nCntFor] ) - 1
		
		If !Empty( aCols[nCntFor][nCntCpo] ) .And. SX3->( dbSeek( aHeader[nCntCpo][2] ) ) .And. !("C6_PRODUTO" $ aHeader[nCntCpo][2])
			
			M->&( aHeader[nCntCpo][2] ) := aCols[nCntFor][nCntCpo]
			__ReadVar := 'M->' + aHeader[nCntCpo][2]
			
			cCampo := GDFieldGet( "C6_QTDVEN" )
			
			If !Empty( SX3->X3_VALID )
				
				If !( lRet := &( SX3->X3_VALID ) ) 
					Exit
				EndIf
					
			EndIf
				
			If !Empty( SX3->X3_VLDUSER )
				
				If !( lRet := &( SX3->X3_VLDUSER ) )
					Exit
				EndIf

			EndIf
			
			If ExistTrigger( aHeader[nCntCpo][2] )
				
				RunTrigger( 2, n, Nil, Nil, aHeader[nCntCpo][2] )
		
			Endif
			
		Endif
	
	Next nCntCpo

	If !lRet
		
		Exit
			
	EndIf


Next nCntFor

If !lRet .or. Empty( aCols )
	
	n := 1
	aCols := aColsBkp
		
EndIf

oGetDad:oBrowse:Refresh()

RestArea( aAreaSX3 )

Return lRet

//-------------------------------------------------------------------
// PE no pedido de venda para atualizar o saldo do Crossdocking
//-------------------------------------------------------------------
User Function M410STTS

Local nCntFor  := 0
Local cCrossD  := ""
Local cProImp  := ""
Local cItCross := ""

For nCntFor := 1 To Len( aCols )

	cCrossD  := GDFieldGet( "C6__CROSSD" , nCntFor )
	cProImp  := GDFieldGet( "C6__PROIMP" , nCntFor )
	cItCross := GDFieldGet( "C6__ITCROS", nCntFor )
	
	If !Empty( cCrossD )
	
		CrossDSld( cCrossD, cProImp, cItCross )
		
	EndIf 

Next nCntFor

Return

//-------------------------------------------------------------------
// Fun��o para Atualizar o saldo
//-------------------------------------------------------------------
Static Function CrossDSld( cCrossD, cProImp, cItCross )

Local aAreaAtu 	:= GetArea()
Local cQuery	:= ""
Local nQtdPed	:= 0
Local nStatus	:= 0

cQuery := "SELECT ISNULL( SUM( C6_QTDVEN ), 0 ) QTDPED " + cEol 
cQuery += "  FROM " + RetSQLName( "SC6" ) + cEol 
cQuery += " WHERE C6_FILIAL  = '" + xFilial( "SC6" ) + "' " + cEol
cQuery += "   AND C6__CROSSD  = '" + cCrossD  + "' " + cEol
cQuery += "   AND C6__PROIMP  = '" + cProImp  + "' " + cEol
cQuery += "   AND C6__ITCROS = '" + cItCross + "' " + cEol
cQuery += "   AND D_E_L_E_T_ = ' ' "
cQuery := ChangeQuery(cQuery)

If Select( "TMP_SC6" ) > 0
	TMP_SC6->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SC6", .T., .F. )
nQtdPed	:= TMP_SC6->QTDPED
TMP_SC6->( dbCloseArea() )

cQuery := "UPDATE " + RetSQLName( "SZX" ) + cEol
cQuery += "   SET ZX_PEDVEN  = " + AllTrim( Str( nQtdPed ) ) + ", " + cEol
cQuery += "       ZX_SALDO   = ZX_QUANT - " + AllTrim( Str( nQtdPed ) ) + cEol
cQuery += " WHERE ZX_FILIAL  = '" + xFilial( "SZX" ) + "' " + cEol
cQuery += "   AND ZX_NUMERO  = '" + cCrossD  + "' " + cEol
cQuery += "   AND ZX_PROIMP  = '" + cProImp  + "' " + cEol
cQuery += "   AND ZX_ITEM    = '" + cItCross + "' " + cEol
cQuery += "   AND D_E_L_E_T_ = ' ' "

nStatus := TCSQLExec( cQuery )
	
If nStatus < 0
	MsgStop( "Problemas no saldo do Crossdocking. Erro: " + TCSQLError() )
Else
	TCRefresh( "SZX" )
Endif
    
RestArea( aAreaAtu )

Return

//-------------------------------------------------------------------
// Valida��o da Pedido de Venda
//-------------------------------------------------------------------
User Function VldQtCross

Local lRetFun := .T.
Local cCrossD  := GDFieldGet( "C6__CROSSD"  )
Local cProImp  := GDFieldGet( "C6__PROIMP"  )
Local cItCross := GDFieldGet( "C6__ITCROS" )
          
lRetFun := U_VldQtdVen()

If lRetFun
	dbSelectArea("SZX")
	dbSetOrder( 1 )
	
	If dbSeek( xFilial( "SZX" ) + cCrossD + cProImp + cItCross ) 
		
		If M->C6_QTDVEN > SZX->ZX_SALDO
			lRetFun := .F.
			Help( Nil, Nil, "Help", Nil, "Valor informado " + Alltrim( Str( M->C6_QTDVEN ) ) + " maior que o saldo do Crossdocking " + Alltrim( Str( SZX->ZX_SALDO ) ), 1, 0 )
		Endif
	
	Endif
EndIf

Return lRetFun