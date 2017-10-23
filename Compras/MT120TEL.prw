#Include "Protheus.ch"

User Function MT120TEL()
Local _nData := aScan(aHeader, { |x| AllTrim(x[2]) == "C7_DATPRF" })

If Altera
	For nx := 1 To Len(aCols)
		If Empty(aCols[nx][_nData])
			aCols[nx][_nData] := Date()
		EndIf
	Next	
EndIf

Return