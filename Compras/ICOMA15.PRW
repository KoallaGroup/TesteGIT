#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"


//Seleção de chave NF-e das notas emitidas no MSV
//Rafael Domingues - Anadi - Maio/2015
User Function ICOMA15()

Local cQuery := ""

Private cNfMsv  := "SELEÇÃO DE NF SAIDA MSV"
Private oOk := LoadBitmap(GetResources(),"LBOK")
Private oNo := LoadBitmap(GetResources(),"LBNO")
Private cVar
Private oDlg
Private oChk
Private oLbx
Private lChk := .F.
Private lMark := .F.
Private aChave := {}

cQuery := " SELECT * FROM "+RetSqlName("Z32")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND Z32_CLIENT = '"+CA100FOR+"' "
cQuery += " AND Z32_LOJA = '"+CLOJA+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)

DbSelectArea("TMP")
DbGoTop()

While !Eof()

	aAdd(aChave, { lMark, TMP->Z32_DOC, TMP->Z32_SERIE, TMP->Z32_CLIENT, TMP->Z32_LOJA, TMP->Z32_CHAVNF })
	
	DbSelectArea("TMP")
	DbSkip()
End

DbSelectArea("TMP")
DbCloseArea()

If Len(aChave) == 0
	MsgAlert("Não foi Selecionado nenhuma NF MSV",cNfMsv)
	Return
EndIf

DEFINE MSDIALOG oDlg TITLE cNfMsv FROM 0,0 To 511,0900 PIXEL // 511,1292    // 630,230

@010,010 LISTBOX oLbx VAR cVar FIELDS Header " ", "Documento", "Série", "Cliente", "Loja", "Chave NF" SIZE 430,230 Of oDlg PIXEL ON dblClick(aChave[oLbx:nAt,1] := !aChave[oLbx:nAt,1],oLbx:Refresh())
oLbx:SetArray(aChave)
oLbx:bLine := {|| { Iif(aChave[oLbx:nAt,1],oOk,oNo), aChave[oLbx:nAt,2], aChave[oLbx:nAt,3], aChave[oLbx:nAt,4], aChave[oLbx:nAt,5], aChave[oLbx:nAt,6] }}

//If oChk <> Nil
	//@245,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 PIXEL Of oDlg On Click(Iif(lChk,Marca(lChk),Marca(lChk)))
//EndIf

@243,280 BUTTON "Confirmar" SIZE 050, 011 Font oDlg:oFont ACTION U_ICOMA15A(aChave) Of oDlg PIXEL
@243,335 BUTTON "Filtrar"  SIZE 050, 011 Font oDlg:oFont ACTION U_ICOMA15B(aChave) OF oDlg PIXEL
@243,390 BUTTON "Cancela"   SIZE 050, 011 Font oDlg:oFont ACTION oDlg:End() OF oDlg PIXEL

ACTIVATE MSDIALOG oDlg CENTER

Return

User Function ICOMA15A(aChave)

For i := 1 To Len(aChave)
	If aChave[i][1] == .T.
		_cChavnfe := aChave[i][6]
	EndIf
Next

oDlg:End()

Return

User Function ICOMA15B(aChave)

Private _cDoc := Space(09)
Private oDlgMen := Nil

DEFINE MSDIALOG oDlgMen TITLE "Filtra Documento de Saída" FROM 006,042 To 230,400 PIXEL

	@ 025,025 Say OemToAnsi("Documento")Of oDlgMen PIXEL
	@ 025,075 Get _cDoc Picture "@!" Of oDlgMen PIXEL
	@ 065,065 BMPBUTTON TYPE 1 ACTION Filtrar(aChave,_cDoc)
	@ 065,095 BMPBUTTON TYPE 2 ACTION Close(oDlgMen)
	ACTIVATE DIALOG oDlgMen CENTERED
		
Return

Static Function Filtrar(aChave,_cDoc)

Local cQuery  := ""

aChave := {}

cQuery := " SELECT * FROM "+RetSqlName("Z32")
cQuery += " WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND Z32_DOC = '"+_cDoc+"' "
cQuery += " AND Z32_FILIAL = '"+xFilial("Z32")+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)

DbSelectArea("TMP")
DbGoTop()

While !Eof()

	aAdd(aChave, { lMark, TMP->Z32_DOC, TMP->Z32_SERIE, TMP->Z32_CLIENT, TMP->Z32_LOJA, TMP->Z32_CHAVNF })
	
	DbSelectArea("TMP")
	DbSkip()
End

DbSelectArea("TMP")
DbCloseArea()

If Len(aChave) == 0
	MsgAlert("Não foi Selecionado nenhuma NF MSV",cNfMsv)
	Return
EndIf

oLbx:SetArray(aChave)
oLbx:bLine := {|| { Iif(aChave[oLbx:nAt,1],oOk,oNo), aChave[oLbx:nAt,2], aChave[oLbx:nAt,3], aChave[oLbx:nAt,4], aChave[oLbx:nAt,5], aChave[oLbx:nAt,6] }}

oLbx:Refresh()
Close(oDlgMen)
	
Return(Nil)