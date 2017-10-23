/*/
// comentado por Elpídio Lima em 15/07/2015 08:39
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function F200Var(_uPar1)

Local _aArea := GetArea()

Private _uPar := _uPar1

If Val(Substr(Paramixb[1][16],38,10)) == 0 .or. Empty(Val(Substr(Paramixb[1][16],38,10)))
	
	Paramixb[1][01] := Substr(Paramixb[1][16],53,10)
	cNumTit			:= Substr(Paramixb[1][16],53,10)
	
EndIf

RestArea(_aArea)

Return
/*/

#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

User Function F200Var(_uPar1)

Local _aArea := GetArea()

Private _uPar := _uPar1

If Val(Substr(Paramixb[1][16],38,10)) == 0 .or. Empty(Val(Substr(Paramixb[1][16],38,10)))
	
	Paramixb[1][01] := Substr(Paramixb[1][16],53,10)
	cNumTit			:= Substr(Paramixb[1][16],53,10)
	
EndIf

DbSelectArea("SE1")
DbSetOrder(19)
If DbSeek(Paramixb[1][01])
	If Empty(SE1->E1__HPORTA) .or. Empty(SE1->E1__HNUMBC)
		RecLock("SE1",.F.)
		SE1->E1__HPORTA := SE1->E1_PORTADO
		//SE1->E1__HNUMBC := SE1->E1_NUMBCO
		SE1->E1__HNUMBC := Paramixb[1][04]
		MsUnLock()
	EndIf
EndIf

RestArea(_aArea)

Return