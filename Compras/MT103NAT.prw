#Include "Rwmake.ch"
#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+------------+
| Programa:  | MT103NAT | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Julho/2015 |
+------------+----------+--------+------------------------------------------+-------+------------+
| Descrição: | P.E. para validar a natureza financeira no documento de entrada                   |
+------------+-----------------------------------------------------------------------------------+
| Uso:       | Isapa														  					 |
+------------+-----------------------------------------------------------------------------------+
*/

User Function MT103NAT()
Local _aArea := GetArea(), _lRet := .t., _nPCST := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_CLASFIS" }), nx := 0

If (Alltrim(cA100For) $ GetMv("MV__ARMFOR") .Or. Alltrim(cA100For) $ SM0->M0_CGC) .And. _nPCST > 0
	For nx := 1 To Len(aCols)
		If !aCols[nx][Len(aHeader)+1]
			aCols[nx][_nPCST] := U_ICOMG01O(nx)
			MaFisAlt("IT_CLASFIS",aCols[nx][_nPCST],nx, .T.)			
		EndIf
	Next nx
EndIf

RestArea(_aArea)
Return _lRet