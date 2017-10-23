#INCLUDE "PROTHEUS.CH"

User Function LP650DEB()

_cPref  := POSICIONE("SF1",1,XFILIAL("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA,"F1_PREFIXO")
_cNat   := POSICIONE("SE2",6,XFILIAL("SE2")+SD1->D1_FORNECE+SD1->D1_LOJA+_cPref+SD1->D1_DOC,"E2_NATUREZ")

IF EMPTY(SB1->B1_CONTA)    
  	_cConta := POSICIONE("SED",1,XFILIAL("SED")+_cNat,"ED_CONTA")
else
	_cConta := SB1->B1_CONTA
Endif  

If Alltrim(_cNat) = "212010" 
	If LEFT(SDE->DE_CC,1) = "3"
		_cConta := "51103010"
	Else
		_cConta := "51102010"
	EndIf
EndIf

If Empty(_cConta) 
	If SD1->D1_LOCAL = "04"
		_cConta := "11601004"
    ElseIf SD1->D1_LOCAL = "05"
    	_cConta := "11601005"
    ElseIf SD1->D1_LOCAL = "07"
    	_cConta := "11601006"
    EndIf
EndIF 

Return(_cConta)
