#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F040BUT				 	| 	Agosto de 2015   		  			 				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para atualização do SE1				  	  					|
|-----------------------------------------------------------------------------------------------|	
*/

User Function F040BUT()

Local _aBtn := {}

AADD(_aBtn,{"Port. Protesto"    , {|| U_IFINA18() } ,"Port. Protesto","Port. Protesto"})
AADD(_aBtn,{"Atualiza Acr/Decr.", {|| U_IFINA19() } ,"Atualiza Acr/Decr","Atualiza Acr/Decr"})

Return _aBtn

User Function IFINA18()

Private _cChave := Space(03)
Private oDlgMen := Nil

While .T.
	@ 006,042 TO 230,400 DIALOG oDlgMen TITLE OemToAnsi("Portador Protesto")
	@ 025,025 Say OemToAnsi("Portador")
	@ 025,075 Get _cChave Picture "@!" F3 "BCO"
	@ 065,065 BMPBUTTON TYPE 1 ACTION Baixar(_cChave)
	@ 065,095 BMPBUTTON TYPE 2 ACTION Close(oDlgMen)
	ACTIVATE DIALOG oDlgMen CENTERED
	Exit
End

Return

Static Function Baixar(_cChave)

RecLock("SE1",.F.)
SE1->E1__PORTAD := _cChave
MsUnLock()

Close(oDlgMen)

Return

User Function IFINA19()

Private _nAcre := SE1->E1_ACRESC
Private _nDecr := SE1->E1_DECRESC
Private oDlgMen := Nil

While .T.
	@ 006,042 TO 230,400 DIALOG oDlgMen TITLE OemToAnsi("Atualiza Acr/Decr")
	@ 025,025 Say OemToAnsi("Acrescimo")
	@ 025,075 Get _nAcre Picture "@E 999,999,999.99"
	@ 045,025 Say OemToAnsi("Decrescimo")
	@ 045,075 Get _nDecr Picture "@E 999,999,999.99"
	@ 065,065 BMPBUTTON TYPE 1 ACTION Atualiza(_nAcre,_nDecr)
	@ 065,095 BMPBUTTON TYPE 2 ACTION Close(oDlgMen)
	ACTIVATE DIALOG oDlgMen CENTERED
	Exit
End

Return

Static Function Atualiza(_nAcre,_nDecr)

RecLock("SE1",.F.)
SE1->E1_ACRESC  := _nAcre
SE1->E1_SDACRES := _nAcre
SE1->E1_DECRESC := _nDecr
SE1->E1_SDDECRE := _nDecr
MsUnLock()

Close(oDlgMen)

Return
