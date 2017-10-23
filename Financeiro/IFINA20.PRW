
#include "Protheus.ch"
#include "Topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFINA20			  		| 		Setembro de 2015				  						|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi													|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Rotina para inserir observacao de credito no titulo NCC.								|
|-------------------------------------------------------------------------------------------------------|	
*/                                          

User Function IFINA20()


Local oButton1
Local oButton2
Local oGet1                                                                              		
Local oSay1   
Private cGet1 := ""
Static oDlg  
                  

  If !Empty(Alltrim(SE1->E1__OBSCRED)) 
  	cGet1 := SE1->E1__OBSCRED
  EndIf

  DEFINE MSDIALOG oDlg TITLE "Obs. de Credito" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL  
  
  	@ 014,012 SCROLLBOX oScrollB1 VERTICAL SIZE 042, 227 OF oDlg BORDER
	@ 000,000 Get cGet1  MEMO	SIZE 227,100 of oScrollB1 MULTILINE PIXEL

    @ 059, 157 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION (oDlg:End())
    @ 059, 201 BUTTON oButton2 PROMPT "Gravar" SIZE 037, 012 OF oDlg PIXEL ACTION GravaObs()
    @ 004, 012 SAY oSay1 PROMPT "Observacao de Credito" SIZE 079, 007 OF oDlg COLORS 0, 16777215 PIXEL

  ACTIVATE MSDIALOG oDlg CENTERED


Return


Static Function GravaObs()

	Reclock("SE1",.F.)
		SE1->E1__OBSCRED := cGet1
	MsUnlock()  
	
	oDlg:End() 

Return