#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "MATA410.CH"
#INCLUDE "ESTILOS.CH"


Static oTimer     	:= Nil  // Objeto TTimer para atualizacao da tela

//-------------------------------------------------------------------
/*/{Protheus.doc} fAtendClienteClass
Classe para Cadastro de Atendimento aos Clientes

@author Sigfrido Eduardo Solórzano Rodriguez
@since 24/05/2017
@version P11/P12
/*/
//-------------------------------------------------------------------

#define cA1_NOME 	1
#define cA1_DDD		2
#define cA1_TEL		3
#define cA1_TELEX	4
#define cA1_FAX		5
#define cA1_CONTATO	6

// identificadores de coluna
#define COL_BROWSER "column_browser"
#define COL_HISTOR  "column_histor"

// identificadores de painel
#define PANEL_BROWSER   "panel_browser"

// identificadores de janela
#define WND_TOP       "wnd_top"
#define WND_HISTOR    "wnd_histor"

Class fAtendCliente
	Data oArea As Object
	    
	// largura x altura
	Data nWidth As Object
	Data nHeight As Object
	
	// objetos auxiliares de interface
	// painel superior  
	Data oPanelBrowser As Object
	
	// painel inferior
	Data oPanelHistor As Object

	// objetos necess?ios para a interface	      
	
	Data oDlgCadAteCli As Object 	
	
	Data cCrono	As String 		// Cronometro atual
	Data oCrono	As Object 		// Objeto da tela "00:00"
	Data oBtnHist As Object		// Histórico do atendimento
	Data oBtnViMEX As Object	// Visitas MEX
	Data cTimeOut As String		// Time out do atendimento 
	Data nTimeSeg As Integer	// Segundos do cronograma
	Data nTimeMin As Integer    // Minutos do cronograma
	
	Data oTimerCro	As Object
	Data oComboTipo	As Object 
	Data oTMultiget1 As Object
	Data oComboResAte As Object 
	Data oDataRea As Object 
	Data oHoraRea As Object
	Data oCodCli As Object
	Data oVenIn As Object
	Data oVenEx As Object
	Data oPedVend As Object
	Data oCliLoja As Object
	Data oFones As Object
	Data oContat As Object
	Data oBtnPosCli As Object

	Data nIDAte As String 	// ID Atendimen
	Data cVenIn As String	// Vendedor VDI
	Data cNomVenIn  As String	// Nome Vendedor VDI  	
	Data cVenEx As String	// Vendedor VDE
	Data cNomVenEx			// Nome Vendedor VDE  	
	Data cPedVend As String	// Pedido de Vendas
	Data dDataIni As Date	// Data Inicial
	Data cHoraIni As String // Hora Inicial
	Data cCodCli As String 	// Cliente do Atendimento   
	Data cCliLoja As String // Filial do Atendimento
	Data cDescCli As String // Descrição do Atendimento 
	Data cDDD As String 	// A1_DDD
	Data cFone As String	// A1_TEL
	Data cFone2 As String	// A1_TELEX
	Data cFone3 As String	// A1_FAX
	Data cContat As String	// A1_CONTATO
	Data cFones As String
		
	Data cTipoAte As String // Tipo de Atendimento
	Data cObserv As String 	// Observação do Atendimento 
	Data cUsrAte As String 	// Usuario do Atendimento
	Data cComboTipo As String 	// Retorno Combo
	Data cComboResAte As String // Retorno Combo Resultado
	Data aItemsResAte As Array // Itens do Atendimento
	
	Data dDataRea As Date		// Data Reagendamento
	Data cHoraRea  As String 	// Hora Reagendamento
				          
    // construtor
    Method New() Constructor
    
    // constru?o de tela	
	Method CreateTopColumn()
    
	Method fIncAteClie()
	Method fCloseAteClie()	
	Method fValidRet()
	Method fBuscaClie()
	Method fTimerAtu()
	
	Method fEnableFld()
	  
	// outros
	Method Init()
	Method Show()

EndClass

/* ----------------------------------------------------------------------------

fAtendCliente:New()

Cria uma nova inst?cia da classe fAtendCliente. 

Restri?o: New() apenas inicializa os atributos. Para a constru?o de
interfaces ?necess?io a chamada do m?odo Init().

---------------------------------------------------------------------------- */
Method New() Class fAtendCliente
	Self:oArea := Nil
	Self:oDlgCadAteCli := Nil

	Self:nWidth  := GetScreenRes()[1] 
	Self:nHeight := GetScreenRes()[2]

Return Self

/* ----------------------------------------------------------------------------

fAtendCliente:Show()

Exibe a tela de transfer?cia

---------------------------------------------------------------------------- */
Method Show() Class fAtendCliente
	Self:oDlgCadAteCli:Activate()
Return

/* ----------------------------------------------------------------------------

fAtendCliente:Init()

Inicializa o objeto fAtendCliente criando a interface.

---------------------------------------------------------------------------- */
Method Init() Class fAtendCliente

	Local lCloseButt := .F. //!(oAPP:lMdi)
	Local oFnt1	 := TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro

	// a função CursorWait() altera o cursor apenas quando a rotina ?chamada
	// pela primeira vez. Nas chamadas seguintes da função, o cursor não é
	// alterado. Chamando CursorArrow() for? a CursorWait() mostrar o cursor
	// de ampulheta sempre.
	CursorArrow()
	CursorWait()

	oMainWnd:ReadClientCoors() // atualiza as propriedades relacionadas com coordenada
	
	If oMainWnd:nClientWidth <= 1024
		nTop := 40
		nLeft := 0 
		nBottom := oMainWnd:nBottom //-39
		nRight := oMainWnd:nRight-10
	Else
		nTop  := oMainWnd:nTop+125
      	nLeft := oMainWnd:nLeft+5
		nBottom := oMainWnd:nBottom //-60
		nRight := oMainWnd:nRight //-14 
  	Endif
  	
	DEFINE MSDIALOG Self:oDlgCadAteCli TITLE "Cadastro de Atendimento aos Clientes"; 
    FROM nTop,nLeft TO nBottom,nRight ;
	   		OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL          

	Self:oDlgCadAteCli:lMaximized := .T.
	Self:oDlgCadAteCli:lEscClose := .F.
		
   	Self:oArea := FWLayer():New()
	Self:oArea:Init(Self:oDlgCadAteCli, lCloseButt)
			
	If Self:oArea == Nil
		Return Nil
	EndIf

	// cria a coluna de cima
	Self:CreateTopColumn()
	
	Self:cCrono			:= "00:00"
	Self:oCrono			:= Nil
	Self:cTimeOut		:= "00:00"
	Self:nTimeSeg		:= 0
	Self:nTimeMin		:= 0                     	
	
   	oTimer := TTimer():New(1000, {|| fAtuCro(@Self:nTimeSeg, @Self:nTimeMin, @Self:cTimeOut, @Self:cCrono, @Self:oCrono) }, Self:oDlgCadAteCli )
   	oTimer:Activate()
	
	@ 237,407 SAY Self:oCrono VAR Self:cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF Self:oPanelBrowser
		
	CursorArrow()
Return

/* ----------------------------------------------------------------------------

fAtendCliente:CreateTopColumn()

---------------------------------------------------------------------------- */
Method CreateTopColumn() Class fAtendCliente
	Local oFont  := TFont():New("Courier New",,017,,.T.,,,,,.F.,.F.)
	Local oFnt1	 := TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
    Local oSay
    Local lHasButton := .T.  
    Local lReadOnly := .F.
	Local aCmpsCli

	Local aItems		:= {"Ativo","Reativo"}
	
	Self:aItemsResAte 	:= {"1-Contato","2-Reagendamento","3-Pedido","4-Orçamento"}
	
	Self:nIDAte 		:= Space(TAMSx3("ZZ0_IDATEN")[1]) 	// ID Atendimen
	Self:cVenIn 		:= Space(TAMSx3("ZZ0_VENDIN")[1]) 	// Vendedor VDI
	Self:cNomVenIn		:= Space(TAMSx3("A3_NOME")[1]) 		// Nome Vendedor VDI
	Self:cVenEx 		:= Space(TAMSx3("ZZ0_VENDEX")[1]) 	// Vendedor VDE
	Self:cNomVenEx		:= Space(TAMSx3("A3_NOME")[1]) 		// Nome Vendedor VDE
	Self:dDataIni	   	:= Date() 	 						// Data Inicial
	Self:cHoraIni  		:= Left(Time(),5)					// Hora Inicial
	Self:cCodCli		:= Space(TAMSx3("ZZ0_CLIENT")[1]) 	// Cliente do Atendimento   
	Self:cTipoAte		:= Space(TAMSx3("ZZ0_TIPO")[1]) 	// Tipo de Atendimento      
	Self:dDataRea 		:= CToD("  /  /  ")					// Data do Reagendamento
	Self:cHoraRea		:= "  :  "							// Hora do Reagendamento
	Self:cUsrAte		:= UsrRetName( cCodUser ) //Retorna o nome do usuario
    Self:cFones			:= Space(255) 
    
	Self:oArea:AddCollumn(COL_BROWSER , 777, .F.)
	
	// cria a janela de search
	Self:oArea:AddWindow(COL_BROWSER, WND_TOP, "Cadastro-Atendimento aos Clientes", 197, .T., .F.) 
	
	// cria o panel da pesquisa
	Self:oPanelBrowser := Self:oArea:GetWinPanel(COL_BROWSER, WND_TOP)   	     
	
	If !("APONTAR ATENDIMENTO " $ ProcName(4))       
    	Self:cVenIn 		:= Posicione("SA3", 7, XFilial("SA3") + cCodUser, "A3_COD")
		Self:cNomVenIn		:= Posicione("SA3", 1, XFilial("SA3") + Self:cVenIn, "A3_NOME") 		
		lReadOnly := .F.
    Else
    	Self:cVenIn  := ZZ1->ZZ1_VENINT 
    	Self:cNomVenIn	:= Posicione("SA3", 1, XFilial("SA3") + ZZ1->ZZ1_VENINT, "A3_NOME")
    	
    	Self:cVenEx  := ZZ1->ZZ1_VENEXT
    	Self:cNomVenEx	:= Posicione("SA3", 1, XFilial("SA3") + ZZ1->ZZ1_VENEXT, "A3_NOME")
    	
    	aCmpsCli 		:= GetAdvFVal("SA1", {"A1_NOME", "A1_DDD", "A1_TEL", "A1_TELEX", "A1_FAX", "A1_CONTATO"}, XFilial("SA1") + ZZ1->ZZ1_CODCLI + ZZ1->ZZ1_CLILJ, 1)
    	
    	Self:cCodCli 	:= ZZ1->ZZ1_CODCLI  
		Self:cCliLoja 	:= ZZ1->ZZ1_CLILJ
		Self:cDescCli 	:= aCmpsCli[1] 	// cA1_NOME //Posicione("SA1", 1, XFilial("SA1") + ZZ1->ZZ1_CODCLI + ZZ1->ZZ1_CLILJ, "A1_NOME")				
		Self:cDDD 		:= aCmpsCli[2] 	// cA1_DDD
		Self:cFone		:= aCmpsCli[3]	// cA1_TEL
		Self:cFone2		:= aCmpsCli[4]	// cA1_TELEX
		Self:cFone3		:= aCmpsCli[5]	// cA1_FAX
		Self:cContat	:= aCmpsCli[6]	// cA1_CONTATO
		
		lReadOnly := .T.
		
		u_fHistAteC(Self:cCodCli, Self:cCliLoja)
    Endif    
    
	@ 007, 002 SAY "ID Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 007, 060 MSGET Self:nIDAte  OF Self:oPanelBrowser READONLY PIXEL SIZE 50 ,9     

	@ 007, 117 SAY "Tipo Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oComboTipo:= tComboBox():New(007,167,{|u|if(PCount()>0,Self:cComboTipo:=u,Self:cComboTipo)},;
	aItems,40,9,Self:oPanelBrowser,,,; 
	,,,.T.,,,,,,,,,"Self:cComboTipo")

	@ 007, 217 SAY "Atendente:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14
	@ 007, 257 MSGET Self:cUsrAte  OF Self:oPanelBrowser READONLY PIXEL SIZE 77 ,9
	
	@ 027, 002 SAY "Vendedor Int.(VDI):" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oVenIn := TGet():New( 027, 060, { | u | If( PCount() == 0, Self:cVenIn, Self:cVenIn := u ) },Self:oPanelBrowser, ;
    50, 9, "999999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,"Self:cVenIn",,,,lHasButton  )
	Self:oVenIn:cF3 := "SA3" 
	
    @ 027, 117 MSGET Self:cNomVenIn OF Self:oPanelBrowser READONLY PIXEL SIZE 197 ,9
    
    @ 047, 002 SAY "Vendedor Ext.(VDE):" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oVenEx := TGet():New( 047, 060, { | u | If( PCount() == 0, Self:cVenEx, Self:cVenEx := u ) },Self:oPanelBrowser, ;
    50, 9, "999999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,"Self:cVenEx",,,,lHasButton  )
	Self:oVenEx:cF3 := "SA3" 
	
    @ 047, 117 MSGET Self:cNomVenEx OF Self:oPanelBrowser READONLY PIXEL SIZE 197 ,9
      
    @ 067, 002 SAY "Data Inicial Atend.:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 067, 060 MSGET Self:dDataIni OF Self:oPanelBrowser  READONLY PIXEL SIZE 40 ,9 
	
	@ 067, 117 SAY "Hora Inicial Atend:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 067, 177 MSGET Self:cHoraIni OF Self:oPanelBrowser READONLY PIXEL SIZE 40 ,9   
    
    @ 087, 002 SAY "Cliente/Fil. Atendimento:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	

	Self:oCodCli := TGet():New( 087, 060, { | u | If( PCount() == 0, Self:cCodCli, Self:cCodCli := u ) },Self:oPanelBrowser, ;
    50, 9, "999999",{||AtendCliWin:fBuscaClie()}, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,"Self:cCodCli",,,,lHasButton  )
    Self:oCodCli:cF3 := "SA1"    
    
	// TGet():New( [ nRow ], [ nCol ], [ bSetGet ], [ oWnd ], [ nWidth ], [ nHeight ], [ cPict ], [ bValid ], [ nClrFore ], [ nClrBack ], [ oFont ], [ uParam12 ], [ uParam13 ], [ lPixel ], [ uParam15 ], [ uParam16 ], [ bWhen ], [ uParam18 ], [ uParam19 ], [ bChange ], [ lReadOnly ], [ lPassword ], [ uParam23 ], [ cReadVar ], [ uParam25 ], [ uParam26 ], [ uParam27 ], [ lHasButton ], [ lNoButton ], [ uParam30 ], [ cLabelText ], [ nLabelPos ], [ oLabelFont ], [ nLabelColor ], [ cPlaceHold ] )
    
	Self:oCliLoja := TGet():New( 087, 117, { | u | If( PCount() == 0, Self:cCliLoja, Self:cCliLoja := u ) },Self:oPanelBrowser, ;
    15, 9, "999999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,lReadOnly,.F.,,"Self:cCliLoja",,,,lHasButton  )
    
	@ 087, 147 MSGET Self:cDescCli OF Self:oPanelBrowser READONLY PIXEL SIZE 257 ,9
	@ 087, 417 SAY oSay PROMPT "==> Selecione o Cliente do Atendimento." FONT oFont COLOR CLR_BLUE,CLR_RED OF Self:oPanelBrowser PIXEL
	
	@ 107, 002 SAY "Contato Cliente:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	//@ 107, 060 MSGET Self:cContat OF Self:oPanelBrowser READONLY PIXEL SIZE 107 ,9
	
	Self:oContat := TGet():New( 107, 060, { | u | If( PCount() == 0, Self:cContat, Self:cContat := u ) },Self:oPanelBrowser, ;
    107, 9, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"Self:cContat",,,,lHasButton  )
    Self:oContat:Disable()    
    
	@ 107, 177 SAY "DDD/Fones:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:cFones := (Self:cDDD + " " + Self:cFone + IIF(!Empty(Self:cFone2),"/" + Self:cFone2," ") + IIF(!Empty(Self:cFone3),"/" + Self:cFone3," "))
	
	//@ 107, 207 MSGET Self:cFones OF Self:oPanelBrowser READONLY PIXEL SIZE 177 ,9 //@ 107, 207 MSGET (Self:cDDD + " " + Self:cFone + IIF(!Empty(Self:cFone2),"/" + Self:cFone2," ") + IIF(!Empty(Self:cFone3),"/" + Self:cFone3," ")) OF Self:oPanelBrowser READONLY PIXEL SIZE 177 ,9
	Self:oFones := TGet():New( 107, 207, { | u | If( PCount() == 0, Self:cFones, Self:cFones := u ) },Self:oPanelBrowser, ;
    177, 9, "@!",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"Self:cFones",,,,lHasButton  )
    Self:oFones:Disable()  
    	    		
	@ 127, 002 SAY "Observações:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	Self:oTMultiget1 := tMultiget():new( 127, 060, {| u | if( pCount() > 0, Self:cObserv := u, Self:cObserv ) }, ;
    Self:oPanelBrowser, 297, 077, , , , , , .T. )
    
    @ 207, 002 SAY "Resultado Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oComboResAte := tComboBox():New(207,060,{|u|if(PCount()>0,Self:cComboResAte:=u,Self:cComboResAte)},;
	Self:aItemsResAte,77,9,Self:oPanelBrowser,,{||AtendCliWin:fEnableFld()},; 
	,,,.T.,,,,,,,,,"Self:cComboResAte")
	
	@ 207, 147 SAY "Data Reagendamento:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	Self:oDataRea := TGet():New( 207, 207, { | u | If( PCount() == 0, Self:dDataRea, Self:dDataRea := u ) },Self:oPanelBrowser, ;
    45, 9, "@D",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"Self:dDataRea",,,,lHasButton  )
    Self:oDataRea:Disable()
     			
	@ 207, 257 SAY "Hora Reagenda.:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	Self:oHoraRea := TGet():New( 207, 307, { | u | If( PCount() == 0, Self:cHoraRea, Self:cHoraRea := u ) },Self:oPanelBrowser, ;
    20, 9, "99:99",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"Self:cHoraRea",,,,lHasButton  )
    Self:oHoraRea:Disable()          
        
    @ 207, 347 SAY "Pedido Venda:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	Self:oPedVend := TGet():New( 207, 397, { | u | If( PCount() == 0, Self:cPedVend, Self:cPedVend := u ) },Self:oPanelBrowser, ;
    50, 9, "999999",, 0, 16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"Self:cPedVend",,,,lHasButton  )
    Self:oPedVend:Disable()   
    
	@ 237,003 BUTTON "&Confirmar >>" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fIncAteClie(" ")) OF Self:oPanelBrowser PIXEL
	@ 237,047 BUTTON "<< &Pedido >>" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fIncAteClie("3")) OF Self:oPanelBrowser PIXEL  
	@ 237,087 BUTTON "<< &Orçamento >>" SIZE 37 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fIncAteClie("4")) OF Self:oPanelBrowser PIXEL  
	@ 237,127 BUTTON "<< &Sair" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fCloseAteClie()) OF Self:oPanelBrowser PIXEL
 	
    Self:oBtnHist := TButton():New(107,391,"H.Atendimento", Self:oPanelBrowser,{|| u_fHistAteC(Self:cCodCli, Self:cCliLoja) },60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    Self:oBtnHist:SetCss(STYLE0003)    
    
    Self:oBtnViMEX := TButton():New(107,462,"Roteiro Mex", Self:oPanelBrowser,{|| u_fVisMEX("R", Self:cCodCli, Self:cCliLoja, Self:cDescCli, Self:cVenEx, Self:cNomVenEx)},60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    Self:oBtnViMEX:SetCss(STYLE0000)   
    
    Self:oBtnViMEX := TButton():New(107,527,"Vis.Mex", Self:oPanelBrowser,{|| u_fVisMEX("V", Self:cCodCli, Self:cCliLoja, Self:cDescCli, Self:cVenEx, Self:cNomVenEx)},60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    Self:oBtnViMEX:SetCss(STYLE0002)   
    
    Self:oBtnPosCli := TButton():New(107,597,"Pos.Cliente", Self:oPanelBrowser,{|| u_BCDConPed('3',Self:cCodCli, Self:cCliLoja) },60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
    Self:oBtnPosCli:SetCss(STYLE0003) 
     
    Self:nIDAte := GetSx8Num("ZZ0","ZZ0_IDATEN")
	
	While ZZ0->(DbSeek(xFilial("ZZ0")+Self:nIDAte,.F.))
		ConfirmSX8()
		Self:nIDAte := GetSx8Num("ZZ0","ZZ0_IDATEN")
	EndDo
    
	If ("APONTAR ATENDIMENTO " $ ProcName(4)) 
		Self:oVenIn:Disable()
		Self:oVenEx:Disable() 
		Self:oCodCli:Disable()
    Endif
Return

Method fIncAteClie(cOp) Class fAtendCliente            		
	Local aArea := GetArea()
	
	CursorWait()
				
	If Empty(Self:cCodCli) 
		Help( ,, 'HELP',, 'Selecione o Cliente do Atendimento.', 1, 0)
		Return .F.
	ElseIf Empty(Self:cUsrAte) .Or. Empty(Self:cVenIn)
		Help( ,, 'HELP',, 'O Atendimento não pode ficar sem Vendedor Interno (VDI).', 1, 0)
		Return .F.           
	ElseIf Empty(Self:cVenEx)
		Help( ,, 'HELP',, 'O Atendimento não pode ficar sem Vendedor Externo (VDE).', 1, 0)
		Return .F.           
	ElseIf Empty(Self:cObserv) 
		Help( ,, 'HELP',, 'Preencha a Observação do Atendimento.', 1, 0)
		Return .F.	
	ElseIf Left(Self:cComboResAte,1) == "3" .And. Empty(Self:cPedVend)
		Help( ,, 'HELP',, 'A opção 3-Pedido do campo Resultado de Atendimento não deve ser selecinada manualmente.', 1, 0)
		Return .F.	 
	ElseIf Left(Self:cComboResAte,1) == "2"	
		AtendCliWin:fEnableFld() 
		
		If Empty(Self:dDataRea)	      
			Help( ,, 'HELP',, 'Para resultado de Atendimento igual a 2-Reagendamento preencha a Data do Reagendamento.', 1, 0)
			Return .F.
		ElseIf Self:cHoraRea  == "  :  "
			Help( ,, 'HELP',, 'Para resultado de Atendimento igual a 2-Reagendamento preencha a Hora do Reagendamento.', 1, 0)
			Return .F.
		Endif	
	Elseif Left(Self:cComboResAte,1) $ "3/4/" .And. Empty(Self:cPedVend)
		Help( ,, 'HELP',, 'Houve tentativa de gerar Pedido/Orçamento sem ser concluído. Corrija o resultado do atendimento e confirme novamente.', 1, 0)			
		Return .F.
	Endif		
   
   DbSelectArea("SA3")
   SA3->(DbSetOrder(1))      
	
   SA3->(!DbSeek(xFilial("SA3")+ Padr(Self:cVenIn,6)))
	
	If SA3->A3_MSBLQL=="1"
		HELP("Código de VDI",1,"REGBLOQ",,"SA3-Vendedores",3,1)
		Return .F.
	Endif		  
	
   DbSelectArea("SA1")
   SA1->(DbSetOrder(1))      
	
   SA1->(!DbSeek(xFilial("SA1")+ Padr(Self:cCodCli,6)))
   
    If SA1->A1_MSBLQL=="1"
		HELP("Código de Cliente",1,"REGBLOQ",,"SA1-Clientes",3,1)
		Return .F.
	Endif		  
	
	AtendCliWin:fBuscaClie()
			        
	DbSelectArea("ZZ0")
 	ZZ0->(DbSetOrder(1))      
	
	If ZZ0->(!DbSeek(xFilial("ZZ0")+ Padr(Self:nIDAte,6))) //xFilial("ZZ0")+ Padr(Self:nIDAte,TAMSx3("ZZ0_IDATEN")[1]) 
		RecLock("ZZ0",.T.) 
		ZZ0->ZZ0_FILIAL		:=  xFilial('ZZ0')                     	
		
		ZZ0->ZZ0_IDATEN := Self:nIDAte 			// ID Atendimen
		ZZ0->ZZ0_VENDIN := Self:cVenIn 			// Vendedor VDI  
		ZZ0->ZZ0_VENDEX := Self:cVenEx 			// Vendedor VDE  
		ZZ0->ZZ0_DTINIC := Self:dDataIni		// Data Inicial
		ZZ0->ZZ0_HORAIN := Self:cHoraIni  		// Hora Inicial
		ZZ0->ZZ0_CLIENT := Self:cCodCli			// Cliente do Atendimento   
		ZZ0->ZZ0_CLILOJ := Self:cCliLoja		// Cliente Loja
		ZZ0->ZZ0_TIPO 	:= Left(Self:cComboTipo,1)	// Tipo de Atendimento  
		ZZ0->ZZ0_OBSERV	:= Self:cObserv			// Observação do Atendimento
   		ZZ0->ZZ0_USRATE	:= Self:cUsrAte			// Usuario do Atendimento
   		ZZ0->ZZ0_DATAFI	:= Date()				// Data Final
   		ZZ0->ZZ0_HORAFI	:= Left(Time(),5)		// Hora Final 
   		
   		If !(cOp$"3/4/")
   			ZZ0->ZZ0_RESATE	:= Left(Self:cComboResAte,1)	// Retorno Combo Resultado
   		Else
   			ZZ0->ZZ0_RESATE	:= cOp // Retorno Combo Resultado // {"1-Contato","2-Reagendamento","3-Pedido","4-Orçamento"}  
   			
   			If !Empty(Self:cPedVend)
	   			ZZ0->ZZ0_PEDVEN	:= SC5->C5_NUM
   			Endif
   					
   			Self:cComboResAte := IIf(cOp == "3", "3-Pedido", "4-Orçamento") 
   			
   			Self:oComboResAte:nAT := aScan(Self:oComboResAte:aItems,IIf(cOp == "3", "3-Pedido", "4-Orçamento"))		
			Self:oComboResAte:Refresh()
   		Endif
   		
		ZZ0->ZZ0_DTREAG	:= Self:dDataRea		// Data Reagendamento 
		ZZ0->ZZ0_HRREAG := Self:cHoraRea 		// Hora Reagendamento			
	  
		ZZ0->(MsUnlock())	 
		
		If cTipoAtend == "A"   
			RecLock("ZZ1",.F.) 
			ZZ1->ZZ1_DTEXAT	:= Date()				// Data do Apontamento do Atendimento
   			ZZ1->ZZ1_HREXAT	:= Left(Time(),5)		// Hora do Apontamento do Atendimento
   		
			ZZ1->(MsUnlock())
		Endif
		
		If !(cOp$"3/4/")
			Self:oDlgCadAteCli:End()
		Endif
  	Else   
 		//Help( ,, 'HELP',, 'ID já cadastrado.', 1, 0)
 		RecLock("ZZ0",.F.) 
 		ZZ0->ZZ0_OBSERV	:= Self:cObserv			// Observação do Atendimento
 		
   		If !Empty(Self:cPedVend)
   			ZZ0->ZZ0_PEDVEN	:= SC5->C5_NUM
   		Endif   
   		
   		ZZ0->ZZ0_RESATE	:= Left(Self:cComboResAte,1)
		ZZ0->ZZ0_DTREAG	:= Self:dDataRea		// Data Reagendamento 
		ZZ0->ZZ0_HRREAG := Self:cHoraRea 		// Hora Reagendamento

   		ZZ0->ZZ0_DATAFI	:= Date()				// Data Final
   		ZZ0->ZZ0_HORAFI	:= Left(Time(),5)		// Hora Final
 		ZZ0->(MsUnlock())  
 		
 		If !(cOp$"3/4/")
			Self:oDlgCadAteCli:End()
		Endif
 	EndIf    
  
	If (cOp$"3/4/") 	  	
		Private xAdtPC, xAutoCab, xAutoItens, xRatCTBPC
		Private bFiltraBrw := {|| }
		  	
		Public nAutoAdt
		Public aRatCTBPC  := IIF(xRatCTBPC <> Nil,xRatCTBPC,{})
		Public aAdtPC     := IIF(xAdtPC <> Nil,xAdtPC,{})	
		Public cStatus	 	:= IIf(cOp == "3", "2", "1")
		Private cBcis	 	:= "" 
		Private lOnUpdate	:= .T.	
		
		Private l410Auto	:= xAutoCab <> Nil .And. xAutoItens <> Nil
		Private aAutoCab	:= {}
		Private aAutoItens	:= {}      
		Private aColsCCust	:= {}                
		Private aBkpAgg	  := {} 
		Private cCadastro := OemToAnsi(STR0007) //"Atualiza‡„o de Pedidos de Venda"
		
		If cOp == "3"
			U_P410INC(Self:nIDAte,Self:cCodCli,Self:cCliLoja)    
		ElseIf cOp == "4"
			U_P415INC(Self:nIDAte,Self:cCodCli,Self:cCliLoja) 
		Endif
		  	
		Self:cPedVend := SC5->C5_NUM  
		
		nIDAtende := ""
	Endif
	
	If !Empty(Self:dDataRea)
		RecLock("ZZ1",.T.) 
			
		ZZ1->ZZ1_FILIAL	:= xFilial('ZZ1')   
		ZZ1->ZZ1_DTPROG := Date()
		ZZ1->ZZ1_VENINT := Self:cVenIn 		// Vendedor VDI  
		ZZ1->ZZ1_VENEXT := Self:cVenEx 		// Vendedor VDE  
		ZZ1->ZZ1_CODCLI := Self:cCodCli		// Cliente do Atendimento   
		ZZ1->ZZ1_CLILJ  := Self:cCliLoja	// Cliente Loja
		ZZ1->ZZ1_DTAGAT := Self:dDataRea 	// Data Reagendamento 
		ZZ1->ZZ1_ROTINA	:= "fIncAteClie"
		
		ZZ1->(MsUnlock())                
	Endif
		
  	RestArea(aArea)
	
	CursorArrow()
		  	
Return .T.                        

Static Function fAtuCro(nTimeSeg, nTimeMin, cTimeOut, cCrono, oCrono)							
	Local cTimeAtu := ""
	
	//Tempo medio de atendimento
	cTimeOut := "05:00"
		
	nTimeSeg += 1 //nTimeSeg += 10
		
	If nTimeSeg > 59
		nTimeMin ++
		nTimeSeg := 0
		If nTimeMin > 60
			nTimeMin := 0
		Endif
	Endif
	
	cTimeAtu := STRZERO(nTimeMin,2,0)+":"+STRZERO(nTimeSeg,2,0)
		
	If cTimeAtu > cTimeOut
		oCrono:nClrText := CLR_RED
		
		oCrono:Refresh()
	Endif
	
	cCrono := cTimeAtu
	oCrono:Refresh()
	
Return(.T.)

Method fBuscaClie() Class fAtendCliente 
    Local aCmpsCli := {}
    
   DbSelectArea("SA1")
   SA1->(DbSetOrder(1))      
	
   SA1->(!DbSeek(xFilial("SA1")+ Padr(Self:cCodCli,6)))
   
	//Self:cDescCli	:= Posicione("SA1", 1, XFilial("SA1") + Self:cCodCli + SA1->A1_LOJA, "A1_NOME")
	Self:cCliLoja	:= SA1->A1_LOJA
	
	Self:oTMultiget1:SetFocus()
	
	If cTipoAtend <> "A" 
		Self:cVenIn 		:= SA1->A1_VEND2
		Self:cNomVenIn		:= Posicione("SA3", 1, XFilial("SA3") + Self:cVenIn, "A3_NOME") 
		Self:oVenIn:Disable()
		
		Self:cVenEx 		:= SA1->A1_VEND
		Self:cNomVenEx		:= Posicione("SA3", 1, XFilial("SA3") + Self:cVenEx, "A3_NOME")
		Self:oVenEx:Disable() 
		
		aCmpsCli 		:= GetAdvFVal("SA1", {"A1_NOME", "A1_DDD", "A1_TEL", "A1_TELEX", "A1_FAX", "A1_CONTATO"}, XFilial("SA1") + Self:cCodCli + Self:cCliLoja, 1)
    	
		Self:cDescCli 	:= aCmpsCli[1] 	// cA1_NOME //Posicione("SA1", 1, XFilial("SA1") + ZZ1->ZZ1_CODCLI + ZZ1->ZZ1_CLILJ, "A1_NOME")				
		Self:cDDD 		:= aCmpsCli[2] 	// cA1_DDD
		Self:cFone		:= aCmpsCli[3]	// cA1_TEL
		Self:cFone2		:= aCmpsCli[4]	// cA1_TELEX
		Self:cFone3		:= aCmpsCli[5]	// cA1_FAX
		Self:cContat	:= aCmpsCli[6]	// cA1_CONTATO
		
		Self:cFones := (Self:cDDD + " " + Self:cFone + IIF(!Empty(Self:cFone2),"/" + Self:cFone2," ") + IIF(!Empty(Self:cFone3),"/" + Self:cFone3," "))
		
		Self:oCliLoja:CtrlRefresh()
		Self:oContat:CtrlRefresh() 
		
		Self:oFones:Enable()  
		Self:oFones:CtrlRefresh() 
		Self:oFones:Disable() 
	Endif 
	
Return Nil

Method fEnableFld() Class fAtendCliente 
	
	If Left(Self:cComboResAte,1) == "2"
		Self:oDataRea:Enable()
		Self:oDataRea:SetFocus()
		Self:oHoraRea:Enable()
	Else
		Self:oDataRea:Disable()
		Self:oHoraRea:Disable()
	Endif
	    
Return

Method fTimerAtu(nTimeMsg) Class fAtendCliente 
	MsgTimer(nTimeMsg,Self:oDlgCadAteCli)
Return

Method fCloseAteClie() Class fAtendCliente 
    
	If Empty(Self:cPedVend) 
		If cTipoAtend <> "A" 
			Self:oDlgCadAteCli:End()                             
		Else          
			If Empty(ZZ1->ZZ1_DTEXAT)
				Self:oDlgCadAteCli:End()                             
			ElseIf ZZ0->ZZ0_IDATEN == Self:nIDAte .And. !Empty(ZZ1->ZZ1_DTEXAT)   
				If Left(Self:cComboResAte,1) $ "3/4/"
					Help( ,, 'HELP',, 'Houve registro para este atendimento então só é pemitida a confirmação do atendimento.', 1, 0)
				Endif
			Endif
		Endif
	Elseif ZZ0->ZZ0_IDATEN == Self:nIDAte .And. !Empty(ZZ1->ZZ1_DTEXAT)
		If Left(Self:cComboResAte,1) $ "3/4/"
			Help( ,, 'HELP',, 'Houve tentativa de gerar Pedido/Orçamento para este atendimento então só é pemitida a confirmação do atendimento.', 1, 0)
		Endif
	Else
		Help( ,, 'HELP',, 'Foi gerado Pedido/Orçamento para este atendimento então só é pemitida a confirmação do atendimento. ', 1, 0)
    Endif      
    
Return .T.

User Function fHistAteC(cZZ1_CODCLI,cZZ1_CLILJ)     
	Local aMemo := {}
	Local lCloseButt := .F.
   	Local oAreaHis, oPanelHis, oScroll
   	Local nX := 0
   	Local cCodCli, cCliLoja, cDescCli 
	
	BeginSql alias 'ZZ0TMP'   
		COLUMN ZZ0_DTINIC AS DATE

		SELECT ZZ0_FILIAL,ZZ0_IDATEN,ZZ0_DTINIC,ZZ0_HORAIN,ZZ0_VENDIN,SA3.A3_NOME ZZ0_NOMVDI,ZZ0_VENDEX,SA3B.A3_NOME ZZ0_NOMVDE,ZZ0_CLIENT,ZZ0_CLILOJ,SA1.A1_NOME ZZ0_NOMCLI, utl_raw.cast_to_varchar2( ZZ0_OBSERV ) AS ZZ0_OBSERV
		FROM ZZ0010 ZZ0 
		INNER JOIN SA3010 SA3 ON ZZ0.ZZ0_VENDIN = SA3.A3_COD 
		INNER JOIN SA3010 SA3B ON ZZ0.ZZ0_VENDEX = SA3B.A3_COD 
		INNER JOIN SA1010 SA1 ON ZZ0.ZZ0_CLIENT = SA1.A1_COD AND ZZ0.ZZ0_CLILOJ = SA1.A1_LOJA
		WHERE ZZ0.ZZ0_FILIAL = %xfilial:ZZ0% AND 
		ZZ0.ZZ0_CLIENT = %Exp:cZZ1_CODCLI% AND ZZ0.ZZ0_CLILOJ = %Exp:cZZ1_CLILJ% AND
		ZZ0.D_E_L_E_T_ = ' ' AND 
		SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SA3B.D_E_L_E_T_ = ' ' AND ROWNUM <= 10
		ORDER BY  ZZ0.ZZ0_DTINIC DESC                 	
	EndSql
		
    aLastQuery := GetLastQuery()
    
	ZZ0TMP->(DbGotop())
	
	nX := 1
	
	Do While ZZ0TMP->(!EOF())				
		cAtend := "ID Atend.: " + Alltrim(ZZ0TMP->ZZ0_IDATEN) + "  |Data Atend.: " + DTOC(ZZ0TMP->ZZ0_DTINIC) + "  |Hora Atend.: " + ZZ0TMP->ZZ0_HORAIN + CRLF 
		cAtend += "VDI: " + Alltrim(ZZ0TMP->ZZ0_VENDIN) + "-" + Alltrim(ZZ0TMP->ZZ0_NOMVDI) + CRLF 
		cAtend += "VDE: " + Alltrim(ZZ0TMP->ZZ0_VENDEX) + "-" + Alltrim(ZZ0TMP->ZZ0_NOMVDE)
		
		aAdd(aMemo, {"ZZ0_OBS" + Alltrim(STR(nX)), "oZZ0_OBS" + Alltrim(STR(nX)), cAtend, "Observações: " + ZZ0TMP->ZZ0_OBSERV})
		
		ZZ0TMP->(dbSkip())
		nX++
	Enddo
    
    If Len(aMemo) == 0     
    	aAdd(aMemo, {"ZZ0_OBS" + Alltrim(STR(1)), "oZZ0_OBS" + Alltrim(STR(1)), "CLIENTE SEM HISTÓRICO DE ATENDIMENTO", ""})
    Endif
    
    cAtend := ""
    
	ZZ0TMP->(DbCloseArea())
			
    cCodCli 	:= ZZ1->ZZ1_CODCLI  
	cCliLoja 	:= ZZ1->ZZ1_CLILJ
	cDescCli 	:= Posicione("SA1", 1, XFilial("SA1") + ZZ1->ZZ1_CODCLI + ZZ1->ZZ1_CLILJ, "A1_NOME")	
	
	DEFINE MSDIALOG oDlgHis FROM 87 ,32 TO 577,1177 TITLE "Histórico de Atendimento" Of oMainWnd PIXEL 

	oAreaHis := FWLayer():New()
	oAreaHis:Init(oDlgHis, lCloseButt)
			
	If oAreaHis == Nil
		Return Nil
	EndIf

	oAreaHis:AddCollumn(COL_HISTOR, 277, .F.)
		
	// cria a janela 
	oAreaHis:AddWindow(COL_HISTOR, WND_HISTOR, "Histórico Atendimento aos Clientes", 197, .T., .F.) 
	
	// cria o panel da pesquisa
	oPanelHis := oAreaHis:GetWinPanel(COL_HISTOR, WND_HISTOR)
    
    // Usando o método New
    oScroll := TScrollBox():New(oPanelHis,00,00,217,566,.T.,.T.,.T.)
    		                   
	nLi1 := 17
	nLi2 := 87
	
	@ 001, 002 SAY "Cliente/Fil. Atendimento:" OF oScroll PIXEL SIZE 77 ,14	
    
    @ 001, 060 MSGET cCodCli OF oScroll READONLY PIXEL SIZE 50 ,9
    @ 001, 117 MSGET cCliLoja OF oScroll READONLY PIXEL SIZE 15 ,9
	@ 001, 147 MSGET cDescCli OF oScroll READONLY PIXEL SIZE 257 ,9
	
	For nCont := 1 to Len(aMemo) 		
		&(aMemo[nCont, 2]) := &("tMultiget():New("+AllTrim(str(nLi1))+","+AllTrim(str(2))+",{|u|if(Pcount()>0,M->"+aMemo[nCont, 1]+":=u,M->"+aMemo[nCont, 1]+")},oScroll,"+AllTrim(str(554))+","+AllTrim(str(nLi2))+",,,,,,.T.)")
		//&(aMemo[nCont, 2]):Align := CONTROL_ALIGN_ALLCLIENT 
		
		&("M->"+aMemo[nCont, 1]) := aMemo[nCont, 3]  + CRLF + CRLF + aMemo[nCont, 4] 
		
		nLi1 := nLi1 + 70
		nLi2 := nLi1 + 77
	Next                                   	
    
    If Len(aMemo) > 0
    	&(aMemo[1, 2]):SetFocus()
    Endif
    
    ASize(aMemo,0)
    
	ACTIVATE MSDIALOG oDlgHis CENTER
Return .T.