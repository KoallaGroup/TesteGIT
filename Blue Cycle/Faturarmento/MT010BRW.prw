#INCLUDE "RWMAKE.CH" 
#Include 'Protheus.ch'
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'


User Function MT010BRW()
Local cFiltro:= Space(58)    
Local _aButton := {}


AAdd(_aButton, {"Altera Peso", "U_IEsta13", 0 , 3, 0, Nil})          



Return(_aButton)





/*User Function AltPeso()
Local cFiltro:= Space(58)    
Local _aButton := {}

DEFINE MSDIALOG oDlg FROM 0,0 TO 210,780 PIXEL TITLE " E N V I A   O   P E D I D O   P O R   E M A I L ? " 
@ 22,15 Say OemToAnsi("EMAIL: ") Of oDlg Pixel
@ 22,36 MsGet oFiltro Var cFiltro Picture "@" of oDlg Pixel Valid (cFiltro)
@ 67,48 BUTTON oButton  PROMPT  " ENVIA "  SIZE 73,11   OF oDlg PIXEL ACTION ENVIEMAIL2(cFiltro) 
@ 67,124 BUTTON oButton2 PROMPT " CANCELA " SIZE 73,11   OF oDlg PIXEL ACTION oDlg:End() 
ACTIVATE MSDIALOG oDlg CENTERED 

Return() */