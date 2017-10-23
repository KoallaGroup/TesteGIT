#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"

User Function IFINC05(nRecno)

Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local cFilBkp  := cFilAnt 

Private oDlg, oButton, oCombo, cCombo, _cObserv
Private aItems := {'','Não negociado','Negociado','Inegociável','Cobr.ABE','Cobr.Merchant'}
Private cLocCob := SM0->M0_CODIGO
Private cLocEm := Space(TamSX3("E1_FILIAL")[1])
Private cFat := Space(TamSX3("E1_NUM")[1])
Private cTal := Space(TamSX3("E1_TIPO")[1])
Private cDup := Space(TamSX3("E1_PARCELA")[1])
Private dDat := dDatabase

cCombo := aItems[1]

SE1->(MsGoto(nRecno))

cLocEm   := SE1->E1_FILIAL
cFat     := SE1->E1_NUM
cTal     := SE1->E1_TIPO
cDup     := SE1->E1_PARCELA
dDat     := dDatabase
cCombo   := SE1->E1__NEGOC
dDat     := SE1->E1__DTNEGO
_cObserv := SE1->E1__OBNEGO

While .T.
	@ 006,042 TO 500,600 DIALOG oDlg TITLE OemToAnsi("Negociação")
	
	@ 010,010 Say OemToAnsi("Local Cobrança")
	@ 010,052 Get cLocCob Size 030,030 When .F.
	
	@ 010,100 Say OemToAnsi("Local Emissão")
	@ 010,142 Get cLocEm Size 030,030 When .F.
	
	@ 010,190 Say OemToAnsi("Fatura")
	@ 010,212 Get cFat Size 050,050 When .F.
	
	@ 025,010 Say OemToAnsi("Talonário")
	@ 025,052 Get cTal Size 030,030 When .F.
	
	@ 025,100 Say OemToAnsi("Duplicata")
	@ 025,142 Get cDup Size 030,030 When .F.
	
	@ 040,010 Say OemToAnsi("Negociado")
	oCombo:= tComboBox():New(40,50,{|u|if(PCount()>0,cCombo:=u,cCombo)},aItems,100,20,oDlg,,,,,,.T.,,,,,,,,,) 
	
	@ 055,010 Say OemToAnsi("Data Negociação")
	@ 055,052 Get dDat Size 050,050 When .T.
	
	@ 070,010 Say OemToAnsi("Historico")
	@ 070,052 Get _cObserv Size 170,140  MEMO Object oMemo When .T.
	
	@ 230,100 BUTTON "Incluir" SIZE 35,15 ACTION IFINC05A()
	@ 230,150 BUTTON "Fechar" SIZE 35,15 ACTION Close(oDlg)
	
	ACTIVATE DIALOG oDlg CENTERED
	Exit
End

RestArea(aAreaSE1)
RestArea(aArea)

Return

Static Function IFINC05A()

RecLock("SE1",.F.)
SE1->E1__NEGOC  := cCombo
SE1->E1__DTNEGO := dDat
SE1->E1__OBNEGO := _cObserv

MsUnLock()
Close(oDlg)

Return

