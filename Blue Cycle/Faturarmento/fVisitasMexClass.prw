#include "protheus.ch"
#include "COLORS.CH"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} VisMEXWin
Visita/Roteiros dos VDE's - Classe
@author Sigfrido Eduardo Solórzano Rodriguez
@since 01/08/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------

// identificadores de coluna

#define COL_CENTER  "column_center"
#define COL_LEFT    "column_left"

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

	Data oPanelCh1 As Object
	Data oChart1 As Object
	Data oFWLayer As Object
		 
	Data cOpCL As String	 
	Data cCliCL As String
	Data cCliLojaCL As String
	Data cDescCliCL As String
	Data cVenExCL As String
	Data cNomVenExCL As String
			 	 		                                                                                                
	Data aListaVisit01 As Array
	
	Data oListVisit01 As Object
	 	
	Data oVER As Object
	Data oAZU As Object
	Data oVermelho As Object	
	
	// construtor
	Method New() Constructor

	// construção de tela	

	Method CreateCenterColumn() 

	// Atualizar Viso
	Method fListVis()
	//Method fVisEmp()
	Method fVisPer()
	
	// atualização
	Method Refresh()	
	
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
Method New(cOp, cCodCliAs, cCliLoja, cDescCli, cVenEx, cNomVenEx) Class VisMEXWin
	Self:oDlgCl := Nil
	Self:oArea := Nil

	Self:nWidth  := GetScreenRes()[1]
	Self:nHeight := GetScreenRes()[2]
    
	Self:cOpCL 			:= cOp
	Self:cCliCL			:= cCodCliAs
	Self:cCliLojaCL 	:= cCliLoja
	Self:cDescCliCL		:= cDescCli
	Self:cVenExCL 		:= cVenEx	
	Self:cNomVenExCL 	:= cNomVenEx
Return Self

/* ----------------------------------------------------------------------------

VisMEXWin:Show()

Exibe a tela do gestor.

---------------------------------------------------------------------------- */
Method Show() Class VisMEXWin
	Self:oDlgCl:Activate()
Return

/* ----------------------------------------------------------------------------

VisMEXWin:CreateCenterColumn()

Cria os painéis centrais, de acordo com o gestor utilizado: Contas a Receber,
Contas a Pagar ou Tesouraria:

---------------------------------------------------------------------------- */
Method CreateCenterColumn() Class VisMEXWin
	Local oColumn := Nil
	Local cTitle := "Visita dos VDE's"

	//Variaveis necessarias para criacao da ButtonBar
	Local aButtonBar := {}
	Local aButtonTxt := {}	
	
	Private cCadastro := "Visita dos VDE's"  
	Private oArea := Self:oArea
	Private lInverte := .F.

	Private aList := {}
   
	Self:oVER  := LoadBitmap( GetResources(), "BR_VERDE")
	Self:oAZU  := LoadBitmap( GetResources(), "BR_AZUL")
	Self:oVermelho	:= LoadBitmap( GetResources(), "BR_VERMELHO" )
			
	// cria a coluna do meio	
	Self:oArea:AddCollumn(COL_CENTER, 79, .F.)  
                                                                                                              
	//Self:oScr:= TScrollBox():New(Self:oPanelBrowse,1,1,330,400,.T.,.T.,.T.) // cria controles dentro do scrollbox	

	VISWindow:fListVis(.T.,.F.,.F.)
	 
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
		nBottom := oMainWnd:nBottom-100
		nRight := oMainWnd:nRight-100
	Else
		nTop  := oMainWnd:nTop+125
      	nLeft := oMainWnd:nLeft+5
		nBottom := oMainWnd:nBottom-100
		nRight := oMainWnd:nRight-100
  	Endif
  	
   /*DEFINE MSDIALOG Self:oDlgCl TITLE "Visita dos VDE's" ; 
   FROM nTop,nLeft TO nBottom,nRight ;
          OF oMainWnd COLOR "W+/W" STYLE nOR(WS_VISIBLE,WS_POPUP) PIXEL 	*/
	
	DEFINE DIALOG Self:oDlgCl TITLE "Visita dos VDE's" FROM 000,000 TO 577,800 PIXEL  

		
	Self:oArea := FWLayer():New()
	Self:oArea:Init(Self:oDlgCl, lCloseButt)
			
	If Self:oArea == Nil
		Return Nil
	EndIf

	// cria a coluna do meio
	Self:CreateCenterColumn()
	
	CursorArrow()
Return

Method fVisPer() Class VisMEXWin
	Local aListVs := aLastQuery := {}
	Local cAlias, cQuery
	
	If Self:cOpCL == "R"
		BeginSql alias 'TRBVis'
			%noparser%
			SELECT COD_ROTEIRO, COD_USUARIO, SEQUENCIA, COD_CLI, to_char(DATAROT, 'YYYYMMDD') DATAROT, COD_VISITA 
			FROM ROTEIRO@MEX
			WHERE to_char(DATAROT, 'YYYYMMDD') >= %Exp:DTOS(Date()-365)% AND COD_CLI = %Exp:(Alltrim(STR(Val(Self:cCliCL)))+Self:cCliLojaCL)%   
			//WHERE to_char(DATAROT, 'YYYYMMDD') >= %Exp:DTOS(Date()-365)% AND COD_USUARIO = %Exp:Alltrim(STR(Val(Self:cVenExCL)))% AND COD_CLI = %Exp:(Alltrim(STR(Val(Self:cCliCL)))+Self:cCliLojaCL)%
			ORDER BY DATAROT
		EndSql  
	ElseIf Self:cOpCL == "V"
		BeginSql alias 'TRBVis'
			%noparser%
			SELECT COD_VISITA,to_char(COD_USUARIO,'000000') COD_USUARIO, to_char(COD_CLI,'00000000') COD_CLI,to_char(DATAVISITA, 'YYYYMMDD') DATAVISITA,HORA_INIC,HORA_FIM,COD_MOTIVO,OBS_VISITA,ALTERACAO,INATIVO,DURACAO,OBS
			FROM VISITAS@MEX
			WHERE to_char(DATAVISITA, 'YYYYMMDD') >= %Exp:DTOS(Date()-365)% AND COD_CLI = %Exp:(Alltrim(STR(Val(Self:cCliCL)))+Self:cCliLojaCL)%  
			//WHERE to_char(DATAVISITA, 'YYYYMMDD') >= %Exp:DTOS(Date()-365)% AND COD_USUARIO = %Exp:Alltrim(STR(Val(Self:cVenExCL)))% AND COD_CLI = %Exp:(Alltrim(STR(Val(Self:cCliCL)))+Self:cCliLojaCL)%
			ORDER BY  DATAVISITA, HORA_INIC
		EndSql 
	Endif
	
	aLastQuery := GetLastQuery()
	  
	TRBVis->(DbGoTop())    
	
	Do While !TRBVis->(Eof()) 
		
		If Self:cOpCL == "R"
			AADD(aListVs,{.F., SToD(TRBVis->DATAROT), TRBVis->COD_ROTEIRO, TRBVis->COD_VISITA, TRBVis->SEQUENCIA, TRBVis->COD_CLI, "" })
   		ElseIf Self:cOpCL == "V"  
   			AADD(aListVs,{.F., SToD(TRBVis->DATAVISITA), TRBVis->HORA_INIC, TRBVis->HORA_FIM, TRBVis->DURACAO, TRBVis->COD_CLI, TRBVis->COD_MOTIVO, TRBVis->OBS, "" })
   		Endif
   		
		TRBVis->(DbSkip())  
	Enddo
	
	TRBVis->(dbCloseArea())              
	
	If Len(aListVs) == 0
		If Self:cOpCL == "R"
			AADD(aListVs,{.F., SToD("  /  /  "), "", "", "", "", "" })
   		ElseIf Self:cOpCL == "V"  
   			AADD(aListVs,{.F., SToD("  /  /  "), "", "", "", "", "", "", "" })
   		Endif
	Endif
	
Return aListVs

Method fListVis() Class VisMEXWin
   Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)
   Local cColorB, cColorF
   
   cColorB := CLR_HBLUE
   cColorF := CLR_WHITE  
   	
	aList := VISWindow:fVisPer()
	
	Self:aListaVisit01 := aList	

	@001, 002 SAY "Cliente/Fil.:" OF Self:oDlgCl PIXEL SIZE 77 ,14	
    @001, 037 MSGET Self:cCliCL OF Self:oDlgCl READONLY PIXEL SIZE 15 ,9
    @001, 067 MSGET Self:cCliLojaCL OF Self:oDlgCl READONLY PIXEL SIZE 15 ,9
	@001, 090 MSGET Self:cDescCliCL OF Self:oDlgCl READONLY PIXEL SIZE 257 ,9 
	
	@014, 002 SAY "Vendedor Ext.(VDE):" OF Self:oDlgCl PIXEL SIZE 77 ,14	
	@014, 064 MSGET Self:cVenExCL OF Self:oDlgCl READONLY PIXEL SIZE 15 ,9
    @014, 090 MSGET Self:cNomVenExCL OF Self:oDlgCl READONLY PIXEL SIZE 197 ,9
    
	If Self:cOpCL == "R"     
	
		@028,002 MSPANEL oPnF01 PROMPT "Roteiro dos VDE's" SIZE 396, 07  Font oFtTit OF Self:oDlgCl COLORS cColorF, cColorB CENTERED RAISED	 
	
	   	@037,001 LISTBOX Self:oListVisit01 FIELDS HEADER "","Data Roteiro","Cod.Roteiro","Cod.Visita","Seq.","Cod.Cliente";
	   			 PIXEL SIZE 403,246 OF Self:oDlgCl 
			     //PIXEL SIZE 397,287 OF Self:oPanelBrowse 
	ElseIf Self:cOpCL == "V"      
	    		
		@028,002 MSPANEL oPnF01 	PROMPT "Visita dos VDE's" SIZE 396, 07  Font oFtTit OF Self:oDlgCl COLORS cColorF, cColorB CENTERED RAISED	 
	
		@037,001 LISTBOX Self:oListVisit01 FIELDS HEADER "","Data Visita","Hora Inicial","Hora Final","Duração","Cod.Cliente","Cod.Motivo","Observação";
			         PIXEL SIZE 403,246 OF Self:oDlgCl 			         
	Endif
	
	Self:oListVisit01:SetArray(Self:aListaVisit01)         
    
	If Self:cOpCL == "R"
		Self:oListVisit01:bLine := {|| { IIF(!Empty(Self:aListaVisit01[Self:oListVisit01:nAt,4]),Self:oAzu,Self:oVermelho),; 
			                     Self:aListaVisit01[Self:oListVisit01:nAt,2],Self:aListaVisit01[Self:oListVisit01:nAt,3],;
			                     Self:aListaVisit01[Self:oListVisit01:nAt,4],Self:aListaVisit01[Self:oListVisit01:nAt,5],;
			                     Self:aListaVisit01[Self:oListVisit01:nAt,6],Self:aListaVisit01[Self:oListVisit01:nAt,7],;
			                     }}
	ElseIf Self:cOpCL == "V" 
			Self:oListVisit01:bLine := {|| { IIF(!Empty(Self:aListaVisit01[Self:oListVisit01:nAt,4]),Self:oAzu,Self:oVermelho),; 
			                     Self:aListaVisit01[Self:oListVisit01:nAt,2],Self:aListaVisit01[Self:oListVisit01:nAt,3],;
			                     Self:aListaVisit01[Self:oListVisit01:nAt,4],Self:aListaVisit01[Self:oListVisit01:nAt,5],;
			                     Self:aListaVisit01[Self:oListVisit01:nAt,6],Self:aListaVisit01[Self:oListVisit01:nAt,7],;
			                     Self:aListaVisit01[Self:oListVisit01:nAt,8],;
			                     }}
	Endif

   	Self:oListVisit01:Refresh()
    Self:oListVisit01:SetFocus()  			   	   
Return