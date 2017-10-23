#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} fAtClient
Classe para Cadastro de Atendimento aos Clientes

@author Sigfrido Eduardo Solórzano Rodriguez
@since 24/05/2017
@version P11/P12
/*/
//-------------------------------------------------------------------
	
User Function fAtClWin(cTpAt)	
                                 			
	Private AtendCliWin := fAtendCliente():New()
	Private aRotina := MenuDef()

	Default cTpAt := " "     
		
	Private cTipoAtend := cTpAt  
                                 
	If cTpAt =="A"
		If !Empty(ZZ1->ZZ1_DTEXAT) 
			Help( ,, 'HELP',, 'Atendimento de Cliente já Apontado.', 1, 0)
			Return .T.
		Endif
	Endif	
		
	AtendCliWin:Init()
	AtendCliWin:Show()
Return .T.