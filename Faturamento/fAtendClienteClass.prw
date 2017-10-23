#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "FIVEWIN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} fAtendClienteClass
Classe para Cadastro de Atendimento aos Clientes

@author Sigfrido Eduardo Solórzano Rodriguez
@since 24/05/2017
@version P11/P12
/*/
//-------------------------------------------------------------------

// identificadores de coluna
#define COL_BROWSER "column_browser"
#define COL_BOTTOM  "column_bottom"

// identificadores de painel
#define PANEL_BROWSER   "panel_browser"

// identificadores de janela
#define WND_TOP       "wnd_top"
#define WND_BOTTOM    "wnd_bottom"

Class fAtendCliente
	Data oArea As Object
	    
	// largura x altura
	Data nWidth As Object
	Data nHeight As Object
	
	// objetos auxiliares de interface
	// painel superior  
	Data oPanelBrowser As Object
	
	// painel inferior
	Data oPanelBottom As Object

	// objetos necess?ios para a interface	      
	
	Data oDlgCadAteCli As Object 	
	/*
	Data cCrono	As String 		// Cronometro atual
	Data oCrono	As Object 		// Objeto da tela "00:00"
	Data cTimeOut As String		// Time out do atendimento 
	Data nTimeSeg As Integer	// Segundos do cronograma
	Data nTimeMin As Integer    // Minutos do cronograma	*/
	
	Data oTimerCro	As Object
	Data oComboTipo	As Object 
	Data oTMultiget1 As Object
	Data oComboResAte As Object 
	
	Data nIDAte As String 	// ID Atendimen
	Data cVenIn As String	// Vendedor VDI
	Data cNomVenIn  As String	// Nome Vendedor VDI
	Data dDataIni As Date	// Data Inicial
	Data cHoraIni As String // Hora Inicial
	Data cCodCli As String 	// Cliente do Atendimento   
	Data cFilCli As String 	// Filial do Atendimento
	Data cDescCli As String // Descrição do Atendimento
	Data cTipoAte As String // Tipo de Atendimento
	Data cObserv As String 	// Observação do Atendimento 
	Data cUsrAte As String 	// Usuario do Atendimento
	Data cComboTipo As String 	// Retorno Combo
	Data cComboResAte As String // Retorno Combo Resultado
	Data dDataRea As Date		// Data Reagendamento
	Data cHoraRea  As String 	// Hora Reagendamento
				          
    // construtor
    Method New() Constructor
    
    // constru?o de tela	
	Method CreateTopColumn()
    
	Method fIncAteClie()	
	Method fValidRet()
	Method fBuscaClie()
	  
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

	Local lCloseButt := .T. //!(oAPP:lMdi)

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
		nBottom := oMainWnd:nBottom-39
		nRight := oMainWnd:nRight-10
	Else
		nTop  := oMainWnd:nTop+125
      	nLeft := oMainWnd:nLeft+5
		nBottom := oMainWnd:nBottom-60
		nRight := oMainWnd:nRight-14 
  	Endif
  	
	DEFINE MSDIALOG Self:oDlgCadAteCli TITLE "Cadastro de Atendimento aos Clientes"; 
    FROM nTop,nLeft TO nBottom,nRight ;
          OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL

	Self:oDlgCadAteCli:lMaximized := .T.
		
   	Self:oArea := FWLayer():New()
	Self:oArea:Init(Self:oDlgCadAteCli, lCloseButt)
			
	If Self:oArea == Nil
		Return Nil
	EndIf

	// cria a coluna de cima
	Self:CreateTopColumn()
    
	CursorArrow()
Return

/* ----------------------------------------------------------------------------

fAtendCliente:CreateTopColumn()

---------------------------------------------------------------------------- */
Method CreateTopColumn() Class fAtendCliente
	Local oFont  := TFont():New("Courier New",,017,,.T.,,,,,.F.,.F.)
	Local oFnt1	 := TFont():New( "Times New Roman",13,26,,.T.)	// Fonte do cronometro
	Local cCodUser := RetCodUsr() //Retorna o Codigo do Usuario
	//Local cNamUser := UsrRetName( cCodUser )//Retorna o nome do usuario 
    Local oSay
    
    Local cCrono	:= "00:00"	// Cronometro atual
	Local oCrono	:= Nil 		// Objeto da tela "00:00"
	Local cTimeOut 	:= "00:00"	// Time out do atendimento 
	Local nTimeSeg 	:= 0		// Segundos do cronograma
	Local nTimeMin 	:= 0    	// Minutos do cronograma
	
	Local aItems		:= {"Ativo","Reativo"}
	Local aItemsResAte 	:= {"1-Contato","2-Reagendamento","3-Pedido"}  
	
	Self:nIDAte 		:= Space(TAMSx3("ZZ0_IDATEN")[1]) 	// ID Atendimen
	Self:cVenIn 		:= Space(TAMSx3("ZZ0_VENDIN")[1]) 	// Vendedor VDI
	Self:cNomVenIn		:= Space(TAMSx3("A3_NOME")[1]) 		// Nome Vendedor VDI
	Self:dDataIni	   	:= Date() 	 						// Data Inicial
	Self:cHoraIni  		:= Left(Time(),5)					// Hora Inicial
	Self:cCodCli		:= Space(TAMSx3("ZZ0_CLIENT")[1]) 	// Cliente do Atendimento   
	Self:cTipoAte		:= Space(TAMSx3("ZZ0_TIPO")[1]) 	// Tipo de Atendimento      
	Self:dDataRea 		:= CToD("  /  /  ")					// Data do Reagendamento
	Self:cHoraRea		:= "  :  "							// Hora do Reagendamento
	Self:cUsrAte		:= UsrRetName( cCodUser ) //Retorna o nome do usuario
	Self:cVenIn 		:= Posicione("SA3", 7, XFilial("SA3") + cCodUser, "A3_COD")
	Self:cNomVenIn		:= Posicione("SA3", 1, XFilial("SA3") + Self:cVenIn, "A3_NOME")
	
	/*Self:cCrono			:= "00:00"
	Self:oCrono			:= Nil
	Self:cTimeOut		:= "00:00"
	Self:nTimeSeg		:= 0
	Self:nTimeMin		:= 0 */
     
	Self:oArea:AddCollumn(COL_BROWSER ,1077, .F.)
	
	// cria a janela de search
	Self:oArea:AddWindow(COL_BROWSER, WND_TOP, "Cadastro-Atendimento aos Clientes", 297, .T., .F.) 
	
	// cria o panel da pesquisa
	Self:oPanelBrowser := Self:oArea:GetWinPanel(COL_BROWSER, WND_TOP)   	     
	
	@ 007, 002 SAY "ID Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 007, 060 MSGET Self:nIDAte  OF Self:oPanelBrowser READONLY PIXEL SIZE 50 ,9     

	@ 007, 117 SAY "Tipo Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oComboTipo:= tComboBox():New(007,167,{|u|if(PCount()>0,Self:cComboTipo:=u,Self:cComboTipo)},;
	aItems,40,9,Self:oPanelBrowser,,,; 
	,,,.T.,,,,,,,,,"Self:cComboTipo")

	@ 007, 217 SAY "Atendente:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14
	@ 007, 257 MSGET Self:cUsrAte  OF Self:oPanelBrowser READONLY PIXEL SIZE 77 ,9
	
	@ 027, 002 SAY "Vendedor VDI:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 027, 060 MSGET Self:cVenIn OF Self:oPanelBrowser F3 "SA3" READONLY PIXEL SIZE 40 ,9
    @ 027, 117 MSGET Self:cNomVenIn OF Self:oPanelBrowser READONLY PIXEL SIZE 197 ,9
     
    @ 047, 002 SAY "Data Inicial Atend.:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 047, 060 MSGET Self:dDataIni OF Self:oPanelBrowser  READONLY PIXEL SIZE 40 ,9 
	
	@ 047, 117 SAY " Hora Inicial Atend:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 047, 177 MSGET Self:cHoraIni OF Self:oPanelBrowser READONLY PIXEL SIZE 40 ,9   
    
    @ 067, 002 SAY "Cliente/Fil. Atendimento:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 067, 060 MSGET Self:cCodCli OF Self:oPanelBrowser  F3 "SA1" PICTURE "9999999999" PIXEL SIZE 40 ,9 VALID AtendCliWin:fBuscaClie()
	@ 067, 107 MSGET Self:cFilCli OF Self:oPanelBrowser READONLY PIXEL SIZE 017 ,9 
	@ 067, 127 MSGET Self:cDescCli OF Self:oPanelBrowser READONLY PIXEL SIZE 257 ,9
	@ 067, 407 SAY oSay PROMPT "==> Selecione o Cliente do Atendimento." FONT oFont COLOR CLR_BLUE,CLR_RED OF Self:oPanelBrowser PIXEL
	
	@ 087, 002 SAY "Observações:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	Self:oTMultiget1 := tMultiget():new( 087, 060, {| u | if( pCount() > 0, Self:cObserv := u, Self:cObserv ) }, ;
    Self:oPanelBrowser, 297, 077, , , , , , .T. )
    
    @ 177, 002 SAY "Resultado Atendimen:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	
	Self:oComboResAte:= tComboBox():New(177,060,{|u|if(PCount()>0,Self:cComboResAte:=u,Self:cComboResAte)},;
	aItemsResAte,77,9,Self:oPanelBrowser,,,; 
	,,,.T.,,,,,,,,,"Self:cComboResAte")
	
	@ 177, 147 SAY "Data Reagendamento:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 177, 207 MSGET Self:dDataRea OF Self:oPanelBrowser  READONLY PIXEL SIZE 40 ,9 
	
	@ 177, 257 SAY " Hora Reagendamento:" OF Self:oPanelBrowser PIXEL SIZE 77 ,14	
	@ 177, 317 MSGET Self:cHoraRea OF Self:oPanelBrowser READONLY PIXEL SIZE 40 ,9 
	 
	@ 197,003 BUTTON "Confirmar >>" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fIncAteClie()) OF Self:oPanelBrowser PIXEL
	@ 197,047 BUTTON "<< Pedido >>" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (AtendCliWin:fIncAteClie()) OF Self:oPanelBrowser PIXEL  
	@ 197,087 BUTTON "<< Sair" SIZE 35 ,10  FONT Self:oPanelBrowser:oFont ACTION (Self:oDlgCadAteCli:End()) OF Self:oPanelBrowser PIXEL
    
    @ 197,407 SAY oCrono VAR cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF Self:oPanelBrowser
	DEFINE TIMER Self:oTimerCro INTERVAL 100 ACTION fAtuCro(@nTimeSeg, @nTimeMin, @cTimeOutOut, @cCrono, @oCrono) OF Self:oPanelBrowser
	
    //@ 207,003 SAY Self:oCrono VAR Self:cCrono PIXEL FONT oFnt1 COLOR CLR_BLUE SIZE 55,15 PICTURE "99:99" OF Self:oPanelBrowser
	//DEFINE TIMER Self:oTimerCro INTERVAL 10000 ACTION fAtuCro(@Self:nTimeSeg, @Self:nTimeMin, @cSelf:cTimeOutOut, @Self:cCrono, @Self:oCrono) OF Self:oPanelBrowser
	
    //AtendCliWin:pRespon := cNamUser 
    //Self:oTimerCro:Activate()
    
    Self:nIDAte := GetSx8Num("ZZ0","ZZ0_IDATEN")
	
	While ZZ0->(DbSeek(xFilial("ZZ0")+Self:nIDAte,.F.))
		ConfirmSX8()
		Self:nIDAte := GetSx8Num("ZZ0","ZZ0_IDATEN")
	EndDo    
	
Return

Method fIncAteClie() Class fAtendCliente            		
				
		If Empty(Self:cCodCli) 
			Help( ,, 'HELP',, 'Selecione o Cliente do Atendimento.', 1, 0)
			Return .F.
		ElseIf Empty(Self:cUsrAte)
			Help( ,, 'HELP',, 'O Atendimento não pode ficar sem Vendedor Interno.', 1, 0)
			Return .F.
		ElseIf Empty(Self:cObserv) 
			Help( ,, 'HELP',, 'Preencha a Observação do Atendimento.', 1, 0)
			Return .F.		
		Endif		
			        
		DbSelectArea("ZZ0")
    	ZZ0->(DbSetOrder(1))  

		If ZZ0->(!DbSeek(xFilial("ZZ0")+ Padr(+Self:nIDAte,TAMSx3("ZZ0_IDATEN")[1])))  
			RecLock("ZZ0",.T.) 
			ZZ0->ZZ0_FILIAL		:=  xFilial('ZZ0')                     	
			
			ZZ0->ZZ0_IDATEN := Self:nIDAte 			// ID Atendimen
			ZZ0->ZZ0_VENDIN := Self:cVenIn 			// Vendedor VDI
			ZZ0->ZZ0_DTINIC := Self:dDataIni		// Data Inicial
			ZZ0->ZZ0_HORAIN := Self:cHoraIni  		// Hora Inicial
			ZZ0->ZZ0_CLIENT := Self:cCodCli			// Cliente do Atendimento   
			ZZ0->ZZ0_TIPO 	:= Left(Self:cComboTipo,1)	// Tipo de Atendimento  
			ZZ0->ZZ0_OBSERV	:= Self:cObserv			// Observação do Atendimento
	   		ZZ0->ZZ0_USRATE	:= Self:cUsrAte			// Usuario do Atendimento
	   		ZZ0->ZZ0_DATAFI	:= Date()				// Data Final
	   		ZZ0->ZZ0_HORAFI	:= Left(Time(),5)		// Hora Final	   		
	   		ZZ0->ZZ0_RESATE	:= Self:oComboResAte	// Retorno Combo Resultado
			ZZ0->ZZ0_DTREAG	:= Self:dDataRea		// Data Reagendamento 
			ZZ0->ZZ0_HRREAG := Self:cHoraRea 		// Hora Reagendamento			
		  
			ZZ0->(MsUnlock())	 
			
			Self:oDlgCadAteCli:End()
	  Else   
	 		Help( ,, 'HELP',, 'ID já cadastrado.', 1, 0)
 	  EndIf    
	  
	  U_P410INC()	
Return Nil


Static Function fAtuCro(nTimeSeg, nTimeMin, cTimeOut, cCrono, oCrono)							
	Local cTimeAtu := ""
	
	//Tempo medio de atendimento
	cTimeOut := "01:00"
		
	nTimeSeg += 10
		
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

	Self:cDescCli	:= Posicione("SA1", 1, XFilial("SA1") + Self:cCodCli + SA1->A1_LOJA, "A1_NOME")
	Self:cFilCli	:= SA1->A1_LOJA
	
Return Nil