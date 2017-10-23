#Include "Protheus.ch"

User Function IESTA13()
Local oButton1, oButton2, oMaster, oMultpl, oPesBru, oPesliq, oProd, oQEmb, _lOK := .f.
Local nMaster := SB1->B1__EMBMAS, nMultpl := SB1->B1__QTDMTP, nPesBru := SB1->B1_PESBRU, nPesliq := SB1->B1_PESO, nQEmb := SB1->B1_QE
Local cProd := Alltrim(SB1->B1_COD) + " - " + Alltrim(SB1->B1_DESC)
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oDlg


DEFINE MSDIALOG oDlg TITLE "PESO / EMBALAGEM" FROM 000, 000  TO 200, 500 COLORS 0, 16777215 PIXEL

    @ 007, 070 SAY oSay1 PROMPT "Alteracao de Peso e Embalagens do produto" SIZE 112, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 040, 008 SAY oSay2 PROMPT "Peso Liquido" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 039, 043 MSGET oPesliq VAR nPesliq SIZE 060, 010 OF oDlg PICTURE "@E 999,999.9999" VALID nPesliq >= 0 COLORS 0, 16777215 PIXEL
    @ 040, 135 SAY oSay3 PROMPT "Peso Bruto" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 039, 168 MSGET oPesBru VAR nPesBru SIZE 060, 010 OF oDlg PICTURE "@E 999,999.9999" VALID nPesBru >= 0 COLORS 0, 16777215 PIXEL
    @ 061, 008 SAY oSay4 PROMPT "Qtde Master" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 041 MSGET oMaster VAR nMaster SIZE 033, 010 OF oDlg PICTURE "@E 99999" VALID nMaster >= 0 COLORS 0, 16777215 PIXEL when .F.
    @ 061, 088 SAY oSay5 PROMPT "Qtd. Indiv." SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 060, 117 MSGET oQEmb VAR nQEmb SIZE 035, 010 OF oDlg PICTURE "@E 999999999" VALID nQEmb >= 0 COLORS 0, 16777215 PIXEL when .F.
    @ 061, 167 SAY oSay6 PROMPT "Qtd. Venda" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 201 MSGET oMultpl VAR nMultpl SIZE 038, 010 OF oDlg PICTURE "@E 99999" VALID nMultpl >= 0 COLORS 0, 16777215 PIXEL when .F.
    @ 080, 051 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {|| _lOK := .t.,oDlg:End()} PIXEL
    @ 080, 147 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
    @ 021, 006 MSGET oProd VAR cProd SIZE 238, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL

ACTIVATE MSDIALOG oDlg CENTERED
  
If _lOK
	If Reclock("SB1",.f.)                 
		SB1->B1_PESO 	:= nPesLiq
		SB1->B1_PESBRU	:= nPesBru
		SB1->B1__QTDMTP := nMultpl
		SB1->B1__EMBMAS := nMaster
		SB1->B1_QE		:= nQEmb 
		MsUnlock()
	Else
		MsgAlert("Não foi possível atualizar as informações do produto, tente novamente")
	EndIf
EndIf

Return