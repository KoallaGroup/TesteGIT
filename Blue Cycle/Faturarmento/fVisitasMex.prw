#include "protheus.ch"
#include "rwmake.ch" 
#include "COLORS.CH"

//-----------------------------------------------------------------------------------
/*/{Protheus.doc} fVisMEX
Visita dos VDE
@author Sigfrido Eduardo Solórzano Rodriguez
@since 01/08/2017
@version P11/P12
/*/
//-----------------------------------------------------------------------------------
User Function fVisMEX(cOp, cCodCli, cCliLoja, cDescCli, cVenEx, cNomVenEx)	
							
	Private VISWindow := VisMEXWin():New(cOp, cCodCli, cCliLoja, cDescCli, cVenEx, cNomVenEx)	
	
	VISWindow:Init()
	VISWindow:Show()

Return .T.