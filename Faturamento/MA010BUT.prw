#Include "Protheus.ch"

User Function MA010BUT()
Local _aButton := {}

If !Inclui
	AAdd(_aButton,{'PRODUTO',{|| U_IGENM06(M->B1_COD) },"Figura" })
EndIf

Return _aButton