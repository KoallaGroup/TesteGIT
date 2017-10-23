#include "protheus.ch"
//#include "acadef.ch"
#include "rwmake.ch" 
#INCLUDE "COLORS.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณIBFluxoCX บ Autor ณ Eduardo Solorzano  บ Data ณ  15/02/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณFluxo de Caixa das Empresas					              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณDiretoria/Gerencial                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function fVisMEX()	

	Private cRotinaExec := "" // Guarda a ultima rotina executada								
	Private VISWindow := VisMEXWin():New()	

	Private aRotina := MenuDef()
	
	lPanelFin := .T.

	VISWindow:Init()
	VISWindow:Show()

Return .T.

/* ----------------------------------------------------------------------------

MenuDef()

---------------------------------------------------------------------------- */
Static Function MenuDef()
Return {{"Fluxo de Caixa", "Fina702", 0, 2}} 




User Function ProcMen2()
	
	Local oDlg, oScr, oGet1, oGet2, oGet3
	Local cGet1, cGet2, cGet3
	Local oPnF01 
	Local oFtTit := TFont():New("ARIAL",,017,,.T.,,,,,.F.,.F.)   
	
	cGet1:= Space(10)
	cGet2:= Space(10)
	cGet3:= Space(10)
	
	//U_TestCal()
	
	DEFINE MSDIALOG oDlg FROM 0 ,0  TO 500,500 TITLE "My teste" Of oMainWnd PIXEL 
	
	oScr:= TScrollBox():New(oDlg,10,10,200,200,.T.,.T.,.T.) // cria controles dentro do scrollbox
	
	//@ 001, 10 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Poแ/Suzano" SIZE 120, 07  Font oFtTit OF oScr COLORS 0, 8092262 CENTERED RAISED
	@ 004, 10 MSPANEL oPnF01 PROMPT "Fluxo de Caixa IBAR Poแ/Suzano" SIZE 320, 07  Font oFtTit OF oScr COLORS CLR_HRED, CLR_HCYAN CENTERED RAISED
	 
		
/*	@ 10,10 MSGET oGet1 VAR cGet1 SIZE 100,10 OF oScr PIXEL
	@ 50,10 MSGET oGet2 VAR cGet2 SIZE 100,10 OF oScr PIXEL
	@ 150,100 MSGET oGet3 VAR cGet3 SIZE 100,10 OF oScr PIXEL
	@ 250,100 MSGET oGet3 VAR cGet3 SIZE 100,10 OF oScr PIXEL
	@ 500,100 MSGET oGet3 VAR cGet3 SIZE 100,10 OF oScr PIXEL */
	
	ACTIVATE MSDIALOG oDlg CENTERED    
	
Return

User Function IoDlgx()
Local oGrp1,oGrp2,oGrp3
Local oPn1
Local oFont  := TFont():New("ARIAL",,018,,.T.,,,,,.F.,.F.)

Private oDlgx := NIL

DEFINE MSDIALOG oDlgx TITLE "Janela" FROM 0,0 TO 375,586 OF oDlgx PIXEL

@ 005,033 TO 144,570 LABEL "Exemplo de Campos1" OF oDlgx PIXEL
@ 005,180 TO 350,162 LABEL "Exemplo de Campos2" OF oDlgx PIXEL
@ 360,180 TO 214,162 LABEL "Exemplo de Campos3" OF oDlgx PIXEL

ACTIVATE MSDIALOG oDlgx

oDlgx := MSDIALOG():Create()
oDlgx:cName := "oDlgx"
oDlgx:cCaption := "Diแlogo"
oDlgx:nLeft := 0
oDlgx:nTop := 0
oDlgx:nWidth := 586
oDlgx:nHeight := 375
oDlgx:lShowHint := .F.
oDlgx:lCentered := .F.

oGrp1 := TGROUP():Create(oDlgx)
oGrp1:cName := "oGrp1"
oGrp1:cCaption := " Dados do Parcelamento"
oGrp1:nLeft := 5
oGrp1:nTop := 33
oGrp1:nWidth := 570
oGrp1:nHeight := 144
oGrp1:lShowHint := .F.
oGrp1:lReadOnly := .F.
oGrp1:Align := 0
oGrp1:lVisibleControl := .T.

oGrp2 := TGROUP():Create(oDlgx)
oGrp2:cName := "oGrp2"
oGrp2:cCaption := "Dados dos Tํtulos"
oGrp2:nLeft := 5
oGrp2:nTop := 180
oGrp2:nWidth := 350
oGrp2:nHeight := 162
oGrp2:lShowHint := .F.
oGrp2:lReadOnly := .F.
oGrp2:Align := 0
oGrp2:lVisibleControl := .T.

oGrp3 := TGROUP():Create(oDlgx)
oGrp3:cName := "oGrp3"
oGrp3:cCaption := "Dados dos AIIPM"
oGrp3:nLeft := 360
oGrp3:nTop := 180
oGrp3:nWidth := 214
oGrp3:nHeight := 162
oGrp3:lShowHint := .F.
oGrp3:lReadOnly := .F.
oGrp3:Align := 0
oGrp3:lVisibleControl := .T.

oBtn := TButton():New(05,15,"      Teste",oPn1,			{|| fAlert()},;
               90,28,,oFont,.F.,.T.,.F.,,.F.,,,.F. )  
               
oDlgx:Activate()

Return

Static Function fAlert()

		oDlgx:lVisible := .F.
		oDlgx:lActive := .F.
		oDlgx:Refresh()
		
       Alert("XXXXX")
       
  		oDlgx:lVisible := .T.
  		oDlgx:lActive := .T.
		oDlgx:Refresh()
Return 