/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VisMEXWin º Autor ³ Eduardo Solorzano  º Data ³  15/02/12   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Fluxo de Caixa das Empresas	- Classe                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³Diretoria/Gerencial                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

#include "protheus.ch"
#INCLUDE "COLORS.CH"

// identificadores de layout
#define LAYOUT_AR "layout_ar"

// identificadores de coluna
#define COL_RIGHT   "column_right"
#define COL_CENTER  "column_center"
#define COL_LEFT    "column_left"
#define COL_RIGHTCH "col_rightch"

// identificadores de painel
#define PANEL_SEARCH    "panel_search"
#define PANEL_BROWSE    "panel_browse"

// identificadores de janela
#define WND_BROWSE    "wnd_browse"
#define WND_FLUX01    "wnd_flux01"
#define WND_FLUX02    "wnd_flux02"
#define WND_FLUX03    "wnd_flux03"
#define WND_FLUX04    "wnd_flux04"
#define WND_FLUX05    "wnd_flux05"
#define WND_FLUX06    "wnd_flux06"
#define WND_FLUX07    "wnd_flux07"
#define WND_FLUX08    "wnd_flux08"
#define WND_FLUX09    "wnd_flux09"
#define WND_FLUX10    "wnd_flux10"
#define WND_FLUX11    "wnd_flux11"
#define WND_FLUX12    "wnd_flux12"
#define WND_SEARCH    "wnd_search"
#define WND_REPORTS   "wnd_reports"

#define WND_CHART_DISP "wnd_chart01"

Static lFWCodFil := FindFunction("FWCodFil")

Class VisMEXWin

	Data oArea As Object

	// largura x altura
	Data nWidth As Object
	Data nHeight As Object

	// objetos auxiliares de interface
	// painéis esquerdos
	Data oPanelSearch As Object
	
	// painéis centrais
	Data oPanelBrowse As Object
	
	// objetos necessários para a interface	
	Data oDlgCl As Object
	Data oDlgFlux As Object 
	Data oScr As Object 
	Data oLayer As Object

   // 14-11-11
	Data pMovDataDe As Date
   	Data lPedVenda As Integer
	Data lPedCompra As Integer 
  	Data lSaldos As Integer 
  
 	Data oListFlux01 As Object
 	Data oListFlux02 As Object
 	Data oListFlux03 As Object
 	Data oListFlux04 As Object
 	Data oListFlux05 As Object
 	Data oListFlux06 As Object
 	Data oListFlux07 As Object
 	Data oListFlux08 As Object
 	Data oListFlux09 As Object
 	Data oListFlux10 As Object
 	Data oListFlux11 As Object
 	Data oListFlux12 As Object

	Data oGet01 As Object
	Data oGet02 As Object
	Data oGet03 As Object

	Data oPanelCh1 As Object
	Data oChart1 As Object
	Data oFWLayer As Object
	Data oFWChart01 As Object
		 	 	 		                                                                                                
	Data aListaFlux01 As Array
	Data aListaFlux02 As Array
	Data aListaFlux03 As Array
	Data aListaFlux04 As Array
	Data aListaFlux05 As Array
	Data aListaFlux06 As Array
	Data aListaFlux07 As Array
	Data aListaFlux08 As Array
	Data aListaFlux09 As Array
	Data aListaFlux10 As Array
	Data aListaFlux11 As Array
	Data aListaFlux12 As Array
	Data aInfo As Array
	
	Data oVER As Object
	Data oAZU As Object
	Data oVermelho As Object	
	
	// construtor
	Method New() Constructor

	// construção de tela	
	Method CreateLeftColumn()
	Method CreateRightColumn()
	Method CreateCenterColumn()

	// Atualizar Fluxo
	Method fListFlx()
	Method fFluxEmp()
	Method fFluxCh1()
	Method PcoGrafPer()
	
	// atualização
	Method Refresh()	
	Method RefreshSearch()
	Method RefreshCh1()
	
	Method GetVisPanel()
	
	// outros
	Method Init()
	Method Show()

EndClass

/* ----------------------------------------------------------------------------

VisMEXWin:New()

Cria uma nova instância da classe VisMEXWin. 

Restrição: New() apenas inicializa os atributos. Para a construção de
interfaces é necessário a chamada do método Init().

---------------------------------------------------------------------------- */
Method New(cAliasFile) Class VisMEXWin
	Self:oDlgCl := Nil
	Self:oArea := Nil

	Self:nWidth  := GetScreenRes()[1] // 16-02-12 - 40
	Self:nHeight := GetScreenRes()[2]// 16-02-12 - 200

Return Self

/* ----------------------------------------------------------------------------

VisMEXWin:Show()

Exibe a tela do gestor.

---------------------------------------------------------------------------- */
Method Show() Class VisMEXWin
	Self:oDlgCl:Activate()
Return

/* ----------------------------------------------------------------------------

VisMEXWin:CreateLeftColumn()

Cria os painéis do lado esquerdo, de acordo com o gestor utilizado:
Contas a Receber, Contas a Pagar ou Tesouraria:

---------------------------------------------------------------------------- */
Method CreateLeftColumn() Class VisMEXWin
	Local aSearch := {}
	Local nLinIni := 3
	Local nI := 0

	Local cProtSearch := "Protheus Search"
	Local oVISWindow := Self
   Local MovDataDe //Local oGet01, oGet02, oGet03, MovDataDe
	Local lPedVenda := lPedCompra := .F.
	Local oFont  := TFont():New("ARIAL",,018,,.T.,,,,,.F.,.F.)
	
	Private cCadastro := "Fluxo de Caixa das Empresas" //STR0004 //"Financeiro"

	Self:oArea:AddCollumn(COL_LEFT , 20, .T.)
	Self:oArea:SetColSplit(COL_LEFT, CONTROL_ALIGN_RIGHT)
	
	// cria a janela de search
	Self:oArea:AddWindow(COL_LEFT, WND_SEARCH, "Considerar os ultimos 30 dias:", 50, .T., .F.) //Self:oArea:AddWindow(COL_LEFT, WND_SEARCH, STR0005, 40, .T., .F.) //"Pesquisa"
	
	// cria o panel da pesquisa
	Self:oPanelSearch := Self:oArea:GetWinPanel(COL_LEFT, WND_SEARCH)
   
	MovDataDe := Self:pMovDataDe
	
	cUsersFlx := "" //GetMv("MV_IBFIN06")

	If Valtype(cUsersFlx) <> "C"
			cUsersFlx := ""
	Endif
	
	//Self:lSaldos := .T.

	@ 07, 03 MSGET Self:pMovDataDe Valid VISWindow:fListFlx(.F.) OF Self:oPanelSearch PIXEL SIZE 60 ,9 //@ 17, 05 MSGET Self:pMovDataDe  Valid u_fListFlx(.F.) OF Self:oPanelSearch PIXEL SIZE 60 ,9

	@ 27, 03 CHECKBOX Self:oGet01 VAR Self:lPedVenda PROMPT "Pedido de Venda" PIXEL OF Self:oPanelSearch SIZE 80,9 ON CLICK (VISWindow:fListFlx(.F.)) 
	
	@ 47, 03 CHECKBOX Self:oGet02 VAR Self:lPedCompra PROMPT "Pedido de Compra" PIXEL OF Self:oPanelSearch SIZE 80,9 ON CLICK (VISWindow:fListFlx(.F.)) 
	
	@ 67, 03 CHECKBOX Self:oGet03 VAR Self:lSaldos PROMPT "Saldos Bancários+Títulos Carteira?" PIXEL OF Self:oPanelSearch SIZE 97,9 ON CLICK (VISWindow:fListFlx(.F.)) // 29-10-12 @ 67, 03 CHECKBOX Self:oGet03 VAR Self:lSaldos PROMPT "Considerar Saldos Bancários?" PIXEL OF Self:oPanelSearch SIZE 87,9 ON CLICK (VISWindow:fListFlx(.F.)) 
	
	If (Alltrim(GetComputerName())$cUsersFlx) //If (Alltrim(GetComputerName())$"EDUARDO-PC/")
		oBtnFlx := TButton():New(87,03,"G R A F I C O",Self:oPanelSearch,			{|| VISWindow:fFluxCh1(Self:pMovDataDe,'0101',"Fluxo de Caixa IBAR Poá/Suzano","1",CLR_HBLUE, CLR_WHITE) },;
	               70,28,,oFont,.F.,.T.,.F.,,.F.,,,.F. )  
	Endif	          
	
	@ 127, 03 SAY "* - Click 2 vezes na tabela para visualizar 30 dias." OF Self:oPanelSearch PIXEL SIZE 77 ,14
	     
	/*Pergunte(Self:GetPerg(), .T., , , Self:oPanelSearch, , @Self:aPergunte, .T., .F.)	

	IBFaMyBar(Self:oPanelSearch, , , , ;
          {{"Pesquisar O.S.", "Pesquisar O.S.", {|| Self:FilterFile()}}}, .F., .F.)    */

Return

/* ----------------------------------------------------------------------------

VisMEXWin:CreateCenterColumn()

Cria os painéis centrais, de acordo com o gestor utilizado: Contas a Receber,
Contas a Pagar ou Tesouraria:

---------------------------------------------------------------------------- */
Method CreateCenterColumn() Class VisMEXWin
	Local oColumn := Nil
	Local cTitle := "Fluxo de Caixa IBAR PoÃ¡/Suzano" 
	//Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)

	//Variaveis necessarias para criacao da ButtonBar
	Local aButtonBar := {}
	Local aButtonTxt := {}	
	
	Private cCadastro := "Fluxo de Caixa IBAR PoÃ¡/Suzano"  
	Private oArea := Self:oArea
	Private lInverte := .F.

	Private aList := {}
   
	Self:oVER  := LoadBitmap( GetResources(), "BR_VERDE")
	Self:oAZU  := LoadBitmap( GetResources(), "BR_AZUL")
	Self:oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
	
	Self:pMovDataDe := Date() //DToS(Date())
				
	// cria a coluna do meio	
	Self:oArea:AddCollumn(COL_CENTER, 79, .F.)    // 60

	cTitle := "Fluxo de Caixa" 
	
	If oMainWnd:nClientWidth <= 1024
		Self:oScr:= TScrollBox():New(Self:oPanelBrowse,10,105,330,400,.T.,.T.,.T.) // cria controles dentro do scrollbox
	Else                                                                                                                 
		Self:oScr:= TScrollBox():New(Self:oPanelBrowse,10,195,330,400,.T.,.T.,.T.) // cria controles dentro do scrollbox
	Endif
	
	VISWindow:fListFlx(.T.,.F.,.F.)
	 
Return

/* ----------------------------------------------------------------------------

VisMEXWin:Init()

Inicializa o objeto VISWindow criando a interface gráfica para o gestor.

---------------------------------------------------------------------------- */
Method Init() Class VisMEXWin

	Local lCloseButt := !(oAPP:lMdi)

	// a função CursorWait() altera o cursor apenas quando a rotina é chamada
	// pela primeira vez. Nas chamadas seguintes da função, o cursor não é
	// alterado. Chamando CursorArrow() força a CursorWait() mostrar o cursor
	// de ampulheta sempre.
	CursorArrow()
	CursorWait()

	oMainWnd:ReadClientCoors() // atualiza as propriedades relacionadas com coordenada
	
	If oMainWnd:nClientWidth <= 1024
		nTop := 40
		nLeft := 0 
		nBottom := oMainWnd:nBottom-39//+ 10
		nRight := oMainWnd:nRight-10
	Else
		nTop  := oMainWnd:nTop+125
      nLeft := oMainWnd:nLeft+5
		nBottom := oMainWnd:nBottom-60
		nRight := oMainWnd:nRight-13 
  	Endif
  	
	DEFINE MSDIALOG Self:oDlgCl TITLE "Fluxo de Caixa" ; 
   FROM nTop,nLeft TO nBottom,nRight ;
          OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL

	Self:oDlgCl:lMaximized := .T.
		
	Self:oArea := FWLayer():New()
	Self:oArea:Init(Self:oDlgCl, lCloseButt)
			
	If Self:oArea == Nil
		Return Nil
	EndIf

	// cria a coluna da esquerda
	Self:CreateLeftColumn()
		
	// cria a coluna do meio
	Self:CreateCenterColumn()
	
	CursorArrow()
Return

Static Function fFluxPer(pMovDataDe,cEmpFil,cTipoFlx)
	Local aListFx := aLastQuery := {}
	Local cAlias, cQuery
	
   /*cQuery := "SELECT * FROM ROTEIRO@MEX
	cQuery += " WHERE DATAROT between to_date('01/07/17') and to_date('31/07/17') "
	cQuery += " ORDER BY DATAROT "
	
	dbUseArea(.T.,"TOPCONN", cQuery,'TRBFlux',.T.,.T.)  //dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),'TRBFlux',.T.,.T.) */
	
	BeginSql alias 'TRBFlux'
		%noparser%
		SELECT COD_ROTEIRO, COD_USUARIO, SEQUENCIA, COD_CLI, to_char(DATAROT, 'YYYYMMDD') DATAROT, COD_VISITA 
		FROM ROTEIRO@MEX
		WHERE to_char(DATAROT, 'YYYYMMDD') between '20170701' and '20170731'
		ORDER BY DATAROT
	EndSql  
	
	aLastQuery := GetLastQuery()
	  
	TRBFlux->(DbGoTop())    
	
	Do While !TRBFlux->(Eof()) 
		AADD(aListFx,{.F., SToD(TRBFlux->DATAROT), TRBFlux->COD_ROTEIRO, "1", TRBFlux->SEQUENCIA, TRBFlux->COD_VISITA, "0","" })

		TRBFlux->(DbSkip())  
	Enddo
	
	TRBFlux->(dbCloseArea())              
	
	/* AADD(aListFx,{.F., Date(), "1", "0", "0", "0", "0", "0","" })
	AADD(aListFx,{.F., Date(), "1"	, "1", "1", "1", "1", "1","" })
	AADD(aListFx,{.F., Date(), "1", "2", "2", "2", "2", "2","" }) */
Return aListFx

Method fFluxEmp(xpMovDataDeF,xcEmpFilF,xcTitle,xcTipoFlx,xcColorF,xcColorB) Class VisMEXWin 
	Local cTitle
	Local oAzu := LoadBitmap( GetResources(), "BR_AZUL")
	Local oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)
	Local oListFluxo
	Local aListaFluxo := {}
	Local lCloseButt := !(oAPP:lMdi)
	Local	bTimer		:=	{||}
	
	//xcTitle := "Fluxo de Caixa (Detalhado) - " + xcEmpFilF
	//Alert("Teste Fluxo")
		
	// Fluxo de Caixa (Detalhado)
	aListaFluxo := fFluxPer(xpMovDataDeF,xcEmpFilF,xcTipoFlx)
	
	DEFINE DIALOG oDlgFlux TITLE xcTitle FROM 000,000 TO 620,800 PIXEL    		
	@ 001,001 MSPANEL oPnF01 PROMPT xcTitle SIZE 400, 07  Font oFtTit OF oDlgFlux COLORS xcColorF,xcColorB CENTERED RAISED		 	 	
  					                  	
  	@008,001 LISTBOX oListFluxo FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			   PIXEL SIZE 400,300 OF oDlgFlux
	    		         
	oListFluxo:SetArray(aListaFluxo)         
  	
  	oListFluxo:bLine := {|| { IIF(Val(aListaFluxo[oListFluxo:nAt,4])>=0,oAzu,oVermelho),; 
  	aListaFluxo[oListFluxo:nAt,2],aListaFluxo[oListFluxo:nAt,3],;
  	aListaFluxo[oListFluxo:nAt,4],aListaFluxo[oListFluxo:nAt,5],;
  	aListaFluxo[oListFluxo:nAt,6],aListaFluxo[oListFluxo:nAt,7],;  
   }}
	
	//Self:aInfo := {1,2,3,4,5,6,7}
	//VISWindow:RefreshCh1()
  	
	ACTIVATE DIALOG oDlgFlux CENTERED    
	
Return Nil

Method fListFlx(lFirst,lPedVenda,lPedCompra) Class VisMEXWin
   Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)
   Local cTipoFlx, cColorB, cColorF
   
   If !Self:lPedVenda .And. Self:lPedCompra .And. !Self:lSaldos
	   	cTipoFlx := '1'
	   	cColorB := CLR_HGREEN
	   	cColorF := CLR_HRED   
	   	
	   	/*02-11-12 If Self:lSaldos
	   		Alert("Opção de Fluxo de Caixa somente com Pedido de Compras e Saldos Bancários inexistente. Será considerada a opção com Pedido de Compra e sem Pedido de Venda.")
	   		Self:lSaldos := .F.
	   	Endif   */
   ElseIf !Self:lPedVenda .And. !Self:lPedCompra
	   	cTipoFlx := '2'     
	   	cColorB := CLR_HGRAY
	   	cColorF := CLR_HRED       
	   	
	   	If Self:lSaldos
	   		Alert("Opção de Fluxo de Caixa sem Pedido Vendas e Compras e considerando Saldos Bancários inexistente. Será considerada a opção sem Pedido Vendas e Compras.")
	   		Self:lSaldos := .F.
	   	Endif 
   ElseIf Self:lPedVenda .And. Self:lPedCompra .And. !Self:lSaldos
	   	cTipoFlx := '3'     
	   	cColorB := CLR_HBLUE
	   	cColorF := CLR_WHITE   
	   	
	   	/*If Self:lSaldos
	   		Alert("Opção de Fluxo de Caixa com Pedido Vendas e Compras e considerando Saldos Bancários em desenvolvimento. Será considerada a opção com Pedido de Vendas e Compras.")
	   		Self:lSaldos := .F.
	   	Endif */
   ElseIf Self:lPedVenda .And. !Self:lPedCompra .And. !Self:lSaldos
	   	cTipoFlx := '4'     
	   	cColorB := CLR_HMAGENTA
	   	cColorF := CLR_WHITE   
	   	Self:lPedVenda := .T.//Self:lPedVenda := .F.
	   	
	   	/*If Self:lSaldos
	   		Alert("Opção de Fluxo de Caixa somente com Pedido de Venda e Saldos Bancários em desenvolvimento. Será considerada a opção com Pedido de Venda e sem Pedido de Compra.")
	   		Self:lSaldos := .F.
	   	Endif   */
   ElseIf Self:lPedVenda .And. Self:lPedCompra .And. Self:lSaldos
	  	cTipoFlx := '5'     
	   	cColorB := CLR_BROWN
	   	cColorF := CLR_WHITE   
	   	   	
   		//Alert("Opção de Fluxo de Caixa com Pedido Vendas e Compras e considerando Saldos Bancários Automático está em desenvolvimento. OS SALDOS BANCÁRIOS DEVERÃO SER ANALIZADOS!!!")
	ElseIf !Self:lPedVenda .And. Self:lPedCompra .And. Self:lSaldos
	   	cTipoFlx := '8' 
	   	cColorB := CLR_HRED //CLR_HGRAY
	   	cColorF := CLR_BLACK
   ElseIf Self:lPedVenda .And. !Self:lPedCompra .And. Self:lSaldos
	   	cTipoFlx := '9' // 02-11-12 '6'     
	   	cColorB := CLR_YELLOW
	   	cColorF := CLR_BLACK
	      	
		//Alert("Opção de Fluxo de Caixa somente com Pedido de Venda e considerando Saldos Bancários Automático está em desenvolvimento. OS SALDOS BANCÁRIOS DEVERÃO SER ANALIZADOS!!!")
   Endif
    
    Self:oGet01:Refresh()
    Self:oGet02:Refresh()
    Self:oGet03:Refresh()
    
	// Fluxo de Caixa IBAR Poá/Suzano
	aList := fFluxPer(Self:pMovDataDe,'0101',cTipoFlx) 	 
	Self:aListaFlux01 := aList	
	
	@ 001,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Poá/Suzano" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED	 //@ 001,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Poá/Suzano" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, IIF(cTipoFlx == '2',CLR_HGRAY,CLR_HGREEN) CENTERED RAISED			                  	
	
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX01, "Fluxo de Caixa IBAR Poá/Suzano" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX01)                                                                   		
	
		//@ 001,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Poá/Suzano" SIZE 380, 07  Font oFtTit OF oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED			                  	
	 	@008,001 LISTBOX Self:oListFlux01 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
		    		         
	Self:oListFlux01:SetArray(Self:aListaFlux01)         

	Self:oListFlux01:bLine := {|| { IIF(Val(Self:aListaFlux01[Self:oListFlux01:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux01[Self:oListFlux01:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux01[Self:oListFlux01:nAt,2],Self:aListaFlux01[Self:oListFlux01:nAt,3],;
		                     Self:aListaFlux01[Self:oListFlux01:nAt,4],Self:aListaFlux01[Self:oListFlux01:nAt,5],;
		                     Self:aListaFlux01[Self:oListFlux01:nAt,6],Self:aListaFlux01[Self:oListFlux01:nAt,7],;
		                     }}      		                     
   Self:oListFlux01:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'0101',"Fluxo de Caixa IBAR Poá/Suzano",cTipoFlx,cColorF, cColorB)}
   
   Self:oListFlux01:Refresh()
   
   ////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa IBAR Poá/Suzano
   
	// Fluxo de Caixa IBAR Nordeste/Jucás
	aList := fFluxPer(Self:pMovDataDe,'3601',cTipoFlx)
	Self:aListaFlux02 := aList	

	@ 029,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Nordeste/Jucás" SIZE 380, 07  Font oFtTit OF  Self:oScr COLORS cColorF, cColorB CENTERED RAISED		                  	
			
	If lFirst                                                                                                                                           
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX02, "Fluxo de Caixa IBAR Nordeste/Jucás" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX02)                                                                   
	
		//@ 029,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Nordeste/Jucás" SIZE 380, 07  Font oFtTit OF  Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED		                  	
	 	@036,001 LISTBOX Self:oListFlux02 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif		         
	
	Self:oListFlux02:SetArray(Self:aListaFlux02)         

	Self:oListFlux02:bLine := {|| { IIF(Val(Self:aListaFlux02[Self:oListFlux02:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux02[Self:oListFlux02:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux02[Self:oListFlux02:nAt,2],Self:aListaFlux02[Self:oListFlux02:nAt,3],;
		                     Self:aListaFlux02[Self:oListFlux02:nAt,4],Self:aListaFlux02[Self:oListFlux02:nAt,5],;
		                     Self:aListaFlux02[Self:oListFlux02:nAt,6],Self:aListaFlux02[Self:oListFlux02:nAt,7],;
		                     }}
	Self:oListFlux02:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'3601',"Fluxo de Caixa IBAR Nordeste/Jucás",cTipoFlx,cColorF, cColorB)}

	Self:oListFlux02:Refresh()

   ////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa IBAR Nordeste/Jucás
   
	// Fluxo de Caixa NUTEC IBAR
	aList := fFluxPer(Self:pMovDataDe,'7001',cTipoFlx)
	Self:aListaFlux03 := aList	
	
	@ 057,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa NUTEC IBAR" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED			                  	
	
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX03, "Fluxo de Caixa NUTEC IBAR" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX03)                                                                   
		
		//@ 057,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa NUTEC IBAR" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED			                  	
	 	@064,001 LISTBOX Self:oListFlux03 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux03:SetArray(Self:aListaFlux03)         

	Self:oListFlux03:bLine := {|| { IIF(Val(Self:aListaFlux03[Self:oListFlux03:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux03[Self:oListFlux03:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux03[Self:oListFlux03:nAt,2],Self:aListaFlux03[Self:oListFlux03:nAt,3],;
		                     Self:aListaFlux03[Self:oListFlux03:nAt,4],Self:aListaFlux03[Self:oListFlux03:nAt,5],;
		                     Self:aListaFlux03[Self:oListFlux03:nAt,6],Self:aListaFlux03[Self:oListFlux03:nAt,7],;		
		                     }}
	Self:oListFlux03:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'7001',"Fluxo de Caixa NUTEC IBAR",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux03:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa NUTEC IBAR
	   
	// Fluxo de Caixa IBAR Service
	aList := fFluxPer(Self:pMovDataDe,'1201',cTipoFlx)
	Self:aListaFlux04 := aList	
	
	@ 85,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Service" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED			                  	
			
	If lFirst 	 		
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX04, "Fluxo de Caixa IBAR Service" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX04)                                                                   	
		
		//@ 85,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Service" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED			                  	
	 	@94,001 LISTBOX Self:oListFlux04 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux04:SetArray(Self:aListaFlux04)         

	Self:oListFlux04:bLine := {|| { IIF(Val(Self:aListaFlux04[Self:oListFlux04:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux04[Self:oListFlux04:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux04[Self:oListFlux04:nAt,2],Self:aListaFlux04[Self:oListFlux04:nAt,3],;
		                     Self:aListaFlux04[Self:oListFlux04:nAt,4],Self:aListaFlux04[Self:oListFlux04:nAt,5],;
		                     Self:aListaFlux04[Self:oListFlux04:nAt,6],Self:aListaFlux04[Self:oListFlux04:nAt,7],;	                     
		                     }}         	                     
	Self:oListFlux04:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1201',"Fluxo de Caixa IBAR Service",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux04:Refresh()
	
	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa IBAR Service
	   
	// Fluxo de Caixa Biritiba Mirim Mineração
	aList := fFluxPer(Self:pMovDataDe,'1501',cTipoFlx)
	Self:aListaFlux05 := aList	
	
	@ 115,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Biritiba Mirim Mineração" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED	                  	
		
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX05, "Fluxo de Caixa Biritiba Mirim Mineração" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX05)                                                                   
	
		//@ 115,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Biritiba Mirim Mineração" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED	                  	
	 	@122,001 LISTBOX Self:oListFlux05 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
   Endif
    		         
	Self:oListFlux05:SetArray(Self:aListaFlux05)         

	Self:oListFlux05:bLine := {|| { IIF(Val(Self:aListaFlux05[Self:oListFlux05:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux05[Self:oListFlux05:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux05[Self:oListFlux05:nAt,2],Self:aListaFlux05[Self:oListFlux05:nAt,3],;
		                     Self:aListaFlux05[Self:oListFlux05:nAt,4],Self:aListaFlux05[Self:oListFlux05:nAt,5],;
		                     Self:aListaFlux05[Self:oListFlux05:nAt,6],Self:aListaFlux05[Self:oListFlux05:nAt,7],;	                     
		                     }}         
	Self:oListFlux05:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1501',"Fluxo de Caixa Biritiba Mirim Mineração",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux05:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Biritiba Mirim Mineração
	   	                     
	// Fluxo de Caixa Clam
	aList := fFluxPer(Self:pMovDataDe,'1601',cTipoFlx)
	Self:aListaFlux06 := aList	
	
	@ 143,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Clam" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED                  	
	
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX06, "Fluxo de Caixa Clam" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX06)                                                                   
	
		//@ 143,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Clam" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED                  	
	 	@152,001 LISTBOX Self:oListFlux06 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
   Endif
    		         
	Self:oListFlux06:SetArray(Self:aListaFlux01)         

	Self:oListFlux06:bLine := {|| { IIF(Val(Self:aListaFlux06[Self:oListFlux06:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux06[Self:oListFlux06:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux06[Self:oListFlux06:nAt,2],Self:aListaFlux06[Self:oListFlux06:nAt,3],;
		                     Self:aListaFlux06[Self:oListFlux06:nAt,4],Self:aListaFlux06[Self:oListFlux06:nAt,5],;
		                     Self:aListaFlux06[Self:oListFlux06:nAt,6],Self:aListaFlux06[Self:oListFlux06:nAt,7],;	                     
		                     }}
	Self:oListFlux06:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1601',"Fluxo de Caixa Clam",cTipoFlx,cColorF,cColorB)} 
	Self:oListFlux06:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Clam

	// Fluxo de Caixa Clam
/*	aList := fFluxPer(Self:pMovDataDe,'1601',cTipoFlx)
	Self:aListaFlux07 := aList	
	
	@ 209,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Columbus" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED		                  	
	
	If lFirst	                                                                                                                          
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX07, "Fluxo de Caixa Columbus" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX07)                                                                   
	
		//@ 209,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Columbus" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED		                  	
	 	@216,001 LISTBOX Self:oListFlux07 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux07:SetArray(Self:aListaFlux07)         

	Self:oListFlux07:bLine := {|| { IIF(Self:aListaFlux07[Self:oListFlux07:nAt,1],Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux07[Self:oListFlux07:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux07[Self:oListFlux07:nAt,2],Self:aListaFlux07[Self:oListFlux07:nAt,3],;
		                     Self:aListaFlux07[Self:oListFlux07:nAt,4],Self:aListaFlux07[Self:oListFlux07:nAt,5],;
		                     Self:aListaFlux07[Self:oListFlux07:nAt,6],Self:aListaFlux07[Self:oListFlux07:nAt,7],;	                     
		                     }}
	Self:oListFlux07:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1601',"Fluxo de Caixa Columbus",cTipoFlx,cColorF,cColorB)}  
	Self:oListFlux07:Refresh()

	*/////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Clam

	// Fluxo de Caixa Columbus
	aList := fFluxPer(Self:pMovDataDe,'1401',cTipoFlx)
	Self:aListaFlux08 := aList	

	@ 173,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Columbus" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED // @ 245,001 	                  	
	
	If lFirst                                                                                                                                              
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX08, "Fluxo de Caixa Columbus" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX08)                                                                   
		
		//@ 173,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Columbus" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED // @ 245,001 	                  	
	 	@180,001 LISTBOX Self:oListFlux08 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos"; //@252,001 
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif    		         
	Self:oListFlux08:SetArray(Self:aListaFlux08)         

	Self:oListFlux08:bLine := {|| { IIF(Val(Self:aListaFlux08[Self:oListFlux08:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux08[Self:oListFlux08:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux08[Self:oListFlux08:nAt,2],Self:aListaFlux08[Self:oListFlux08:nAt,3],;
		                     Self:aListaFlux08[Self:oListFlux08:nAt,4],Self:aListaFlux08[Self:oListFlux08:nAt,5],;
		                     Self:aListaFlux08[Self:oListFlux08:nAt,6],Self:aListaFlux08[Self:oListFlux08:nAt,7],;	                     
		                     }}
	Self:oListFlux08:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1401',"Fluxo de Caixa Columbus",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux08:Refresh()
	
	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Columbus
	   
	// Fluxo de Caixa Construtora Silva Ferreira Ltda.
	aList := fFluxPer(Self:pMovDataDe,'0301',cTipoFlx)
	Self:aListaFlux09 := aList	
	
	@ 201,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Construtora Silva Ferreira Ltda." SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED //@ 281,001 
	
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX09, "Fluxo de Caixa Construtora Silva Ferreira Ltda." , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX09)                                                                   
		
		//@ 201,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Construtora Silva Ferreira Ltda." SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED//@ 281,001 
	 	@208,001 LISTBOX Self:oListFlux09 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos"; // @288,001 
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux09:SetArray(Self:aListaFlux09)         

	Self:oListFlux09:bLine := {|| { IIF(Val(Self:aListaFlux09[Self:oListFlux09:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux09[Self:oListFlux07:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux09[Self:oListFlux09:nAt,2],Self:aListaFlux09[Self:oListFlux09:nAt,3],;
		                     Self:aListaFlux09[Self:oListFlux09:nAt,4],Self:aListaFlux09[Self:oListFlux09:nAt,5],;
		                     Self:aListaFlux09[Self:oListFlux09:nAt,6],Self:aListaFlux09[Self:oListFlux09:nAt,7],;	                     
		                     }}
	Self:oListFlux09:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'0301',"Fluxo de Caixa Construtora Silva Ferreira Ltda.",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux09:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Construtora Silva Ferreira Ltda.	   

	// Fluxo de Caixa CHI
	aList := fFluxPer(Self:pMovDataDe,'1001',cTipoFlx)
	Self:aListaFlux10 := aList	
	
	@ 229,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa CHI Representação Comercial Ltda." SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED // @ 295,001
		
	If lFirst                                                                                                                                                                   
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX10, "Fluxo de Caixa CHI Representação Comercial Ltda." , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX10)                                                                   
		
		//@ 229,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa CHI Representação Comercial Ltda." SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED // @ 295,001
	 	@236,001 LISTBOX Self:oListFlux10 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos"; // @302,001 
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux10:SetArray(Self:aListaFlux10)         

	Self:oListFlux10:bLine := {|| { IIF(Val(Self:aListaFlux10[Self:oListFlux10:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux10[Self:oListFlux07:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux10[Self:oListFlux10:nAt,2],Self:aListaFlux10[Self:oListFlux10:nAt,3],;
		                     Self:aListaFlux10[Self:oListFlux10:nAt,4],Self:aListaFlux10[Self:oListFlux10:nAt,5],;
		                     Self:aListaFlux10[Self:oListFlux10:nAt,6],Self:aListaFlux10[Self:oListFlux10:nAt,7],;	                     
		                     }}
	Self:oListFlux10:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'1001',"Fluxo de Caixa CHI Representação Comercial Ltda.",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux10:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa CHI
	   
	// Fluxo de Caixa Global Heat
	aList := fFluxPer(Self:pMovDataDe,'2001',cTipoFlx)
	Self:aListaFlux11 := aList	
	
	@ 257,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Global Heat" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED // @ 331,001 	 	                  	
	
	If lFirst
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX11, "Fluxo de Caixa Global Heat" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX11)                                                                   
		
		//@ 257,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Global Heat" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED // @ 331,001 	 	                  	
	 	@264,001 LISTBOX Self:oListFlux11 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos"; // @338,001 
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
   Endif
    		         
	Self:oListFlux11:SetArray(Self:aListaFlux11)         

	Self:oListFlux11:bLine := {|| { IIF(Val(Self:aListaFlux11[Self:oListFlux11:nAt,4])>=0,Self:oAzu,Self:oVermelho),; // IIF(Self:aListaFlux11[Self:oListFlux11:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux11[Self:oListFlux11:nAt,2],Self:aListaFlux11[Self:oListFlux11:nAt,3],;
		                     Self:aListaFlux11[Self:oListFlux11:nAt,4],Self:aListaFlux11[Self:oListFlux11:nAt,5],;
		                     Self:aListaFlux11[Self:oListFlux11:nAt,6],Self:aListaFlux11[Self:oListFlux11:nAt,7],;	                     
		                     }}
	Self:oListFlux11:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'2001',"Fluxo de Caixa Global Heat",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux11:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Global Heat
	   
	// Fluxo de Caixa Magari
	aList := fFluxPer(Self:pMovDataDe,'7101',cTipoFlx)
	Self:aListaFlux12 := aList	
	
	@ 285,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Magari" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS cColorF, cColorB CENTERED RAISED  // @ 367,001 	                  	
	
	If lFirst                                                                                                                                          
		//Self:oArea:AddWindow(COL_CENTER, WND_FLUX12, "Fluxo de Caixa Magari" , 15, .T., .F.)
		//Self:oPanelBrowse := Self:oArea:GetWinPanel(COL_CENTER, WND_FLUX12)                                                                   
		
		//@ 285,001 MSPANEL oPnF01 PROMPT "Fluxo de Caixa Magari" SIZE 380, 07  Font oFtTit OF Self:oScr COLORS CLR_HRED, CLR_HGRAY CENTERED RAISED  // @ 367,001 	                  	
	 	@292,001 LISTBOX Self:oListFlux12 FIELDS HEADER "","Data","Tipo","Atual","30 Dias","60 Dias","90 Dias","Bancos";  // @374,001 
			         PIXEL SIZE 380,29 OF Self:oScr // Self:oPanelBrowse
	Endif
	    		         
	Self:oListFlux12:SetArray(Self:aListaFlux12)         

	Self:oListFlux12:bLine := {|| { IIF(Val(Self:aListaFlux12[Self:oListFlux12:nAt,4])>=0,Self:oAzu,Self:oVermelho),; //  IIF(Self:aListaFlux12[Self:oListFlux12:nAt,1],Self:oOK,Self:oNo),;
		                     Self:aListaFlux12[Self:oListFlux12:nAt,2],Self:aListaFlux12[Self:oListFlux12:nAt,3],;
		                     Self:aListaFlux12[Self:oListFlux12:nAt,4],Self:aListaFlux12[Self:oListFlux12:nAt,5],;
		                     Self:aListaFlux12[Self:oListFlux12:nAt,6],Self:aListaFlux12[Self:oListFlux12:nAt,7],;	                     
		                     }}
	Self:oListFlux12:blDblClick := {|| VISWindow:fFluxEmp(Self:pMovDataDe,'7101',"Fluxo de Caixa Magari",cTipoFlx,cColorF,cColorB)}
	Self:oListFlux12:Refresh()

	////////////////////////////////////////////////////////////////////////////////// (FIM) Fluxo de Caixa Magari
	   	   
Return

Method PcoGrafPer(aValues,aPeriodo,nNivel,cChave,oMain,nTpGrafico,aSeries,oLayer,oChart,lCNiv)  Class VisMEXWin
Local aLinha := {}
Local nx,ny,nZ
Local nSaltCol

Default oLayer 	:= nil
Default oChart 	:= nil
Default lCNiv	:= .F.

nSaltCol := 1 //If(lCNiv,1,2)
If Valtype(oLayer)<>"O"
	oLayer := FWLayer():New()
	oLayer:Init(oDlgFlux, .T.)
	oLayer:addCollumn( 'Col02', 100, .T. )
	oLayer:addWindow( 'Col02', 'Win02', "Grafico",100, .F., .T. )
Endif

If Valtype(oChart)=="O"
	FreeObj(@oChart)
Endif
oChart := FWChartFactory():New()
oChart := oChart:getInstance( If(nTpGrafico == 1, LINECHART, BARCOMPCHART ) )
oChart:init( oLayer:getWinPanel( 'Col02', 'Win02' ) )
oChart:SetLegend( CONTROL_ALIGN_RIGHT )
oChart:SetMask( "R$ *@*")
oChart:SetPicture("@E 999,999,999,999.99")

For nx := 1 TO Len(aSeries)
	aAdd( alinha, {nil,{}})
Next

For nX := 1 TO Len(aSeries)
	aAdd( alinha, {nil,{}})
	alinha[nX,1] := aSeries[nX]
	nZ := 1
	For nY := nX to Len(aValues)-nSaltCol Step Len(aPeriodo)
		aAdd( alinha[nX,2],{aPeriodo[nZ] ,aValues[nY+nSaltCol]})
		nZ++
	Next
Next

nPeriodo := 1
For nZ := nSaltCol+1 To Len(aValues) Step Len(aSeries)
	For ny := 1 TO Len(aSeries)
		alinha[ny,1] := aSeries[ny]
		aAdd( alinha[ny,2],{aPeriodo[nPeriodo], aValues[nZ+ny-1] })
	Next
	nPeriodo++
Next

For nx := 1 TO Len(aSeries)
	oChart:AddSerie(alinha[nx,1], aLinha[nx,2] )
Next
	
oChart:build()
Return

Method fFluxCh1(xpMovDataDeF,xcEmpFilF,xcTitle,xcTipoFlx,xcColorF,xcColorB) Class VisMEXWin 
	Local cTitle
	Local oAzu := LoadBitmap( GetResources(), "BR_AZUL")
	Local oVermelho := LoadBitmap( GetResources(), "BR_VERMELHO" )
	Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)    
	Local oListFluxo
	Local aListaFluxo := {}
	Local lCloseButt := !(oAPP:lMdi)
	Local	bTimer		:=	{||}
			
	// Fluxo de Caixa (Detalhado)
	//aListaFluxo := fFluxPer(xpMovDataDeF,xcEmpFilF,xcTipoFlx)
	 If !Self:lPedVenda .And. Self:lPedCompra 
   	xcColorB := CLR_HGREEN
   	xcColorF := CLR_HRED   
   	
   ElseIf !Self:lPedVenda .And. !Self:lPedCompra
   	xcColorB := CLR_HGRAY
   	xcColorF := CLR_HRED       
   	
   ElseIf Self:lPedVenda .And. Self:lPedCompra .And. !Self:lSaldos
   	xcColorB := CLR_HBLUE
   	xcColorF := CLR_WHITE   
   	
   ElseIf Self:lPedVenda .And. !Self:lPedCompra .And. !Self:lSaldos
   	xcColorB := CLR_HMAGENTA
   	xcColorF := CLR_WHITE   
   	
   ElseIf Self:lPedVenda .And. Self:lPedCompra .And. Self:lSaldos
   	xcColorB := CLR_BROWN
   	xcColorF := CLR_WHITE   
   	   	
    ElseIf Self:lPedVenda .And. !Self:lPedCompra .And. Self:lSaldos
   	xcColorB := CLR_YELLOW
   	xcColorF := CLR_BLACK      	
   Endif                                                            
   
	DEFINE DIALOG Self:oDlgFlux TITLE (xcTitle + " (Gráfico Saldo Atual)") FROM 000,000 TO 620,1000 PIXEL    		
	@ 001,001 MSPANEL oPnF01 PROMPT (xcTitle + " (Gráfico Saldo Atual)") SIZE 490, 07  Font oFtTit OF Self:oDlgFlux COLORS xcColorF,xcColorB CENTERED RAISED		 	 	
  					                  	
	//VISWindow:PcoGrafPer()
	
	//Self:aInfo := {1,2,3,4,5,6,7} // Self:aInfo := {}
  	
  	VISWindow:RefreshCh1()
  	
	ACTIVATE DIALOG Self:oDlgFlux CENTERED    
	
	
	
Return Nil

/* ----------------------------------------------------------------------------

FinManWindow:RefreshCh1()

---------------------------------------------------------------------------- */
Method RefreshCh1() Class VisMEXWin
	 Local nContFor, nTpGrafico
	 
	// no gestor de Tesouraria não é exibido o painel
	// de gráficos, deste modo, o mesmo não é criado
	//If Self:oPanelCh1 # Nil

	   Self:oDlgFlux:FreeChildren()
	   nTpGrafico := 0
	   
		Self:oLayer := FWLayer():New()
		Self:oLayer:Init(Self:oDlgFlux, .T.)
		Self:oLayer:addCollumn( 'Col02', 100, .T. )
		Self:oLayer:addWindow( 'Col02', 'Win02', "Grafico",100, .F., .T. )		 //Self:oLayer:addWindow("Col02","Win02","Grafico",100,,,.F.,"Superior") //Self:oLayer:addWindow( 'Col02', 'Win02', "Grafico",100, .F., .T. )		
		
		Self:oChart1 := FWChartFactory():New()

		// retorna a instância do gráfico desejado
		//
		// BARCHART(0) para barras
		// LINECHART(1) para linhas
		// PIECHART(2) para pizza.
		                            
		Self:oChart1 := Self:oChart1:GetInstance(nTpGrafico) //Self:oChart1 := Self:oChart1:GetInstance(( If(nTpGrafico == 1, LINECHART, BARCOMPCHART ) )) //
		Self:oChart1:Init(Self:oDlgFlux, .T.)
		//Self:oChart1:SetTitle("Despesas financeiras", CONTROL_ALIGN_LEFT)
		//Self:oChart1:SetLegend(CONTROL_ALIGN_RIGHT)
		Self:oChart1:SetMask("R$ *@*")
		Self:oChart1:SetPicture("@E 999,999,999,999.99")
		
		For nContFor := Len(Self:aListaFlux01) To 1 Step -1//For nContFor := 1 To Len(Self:aListaFlux01) 
			Self:oChart1:AddSerie(Dtoc(Self:aListaFlux01[nContFor][2]), Val(fAcerDec(Self:aListaFlux01[nContFor][4]))) //Self:oChart1:AddSerie(Dtoc(Self:aListaFlux01[1][2]), Self:aListaFlux01[1][4])
		Next	   			
			
	  	Self:oChart1:Build()
	//EndIf
Return

Static Function fAcerDec(cVal)	
	Local nPos
	
	While (nPos := At(".",cVal) ) > 0
		cVal := Stuff(cVal,nPos,1,"") //Stuff(Self:aListaFlux01[1][4],At(".",Self:aListaFlux01[1][4]),1,"")
	End      
	
Return cVal