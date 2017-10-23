#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+-------------+
| Programa:  | A260GRV | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Agosto/2015 |
+------------+---------+--------+------------------------------------------+-------+-------------+
| Descri��o: | Ponto de entrada para validar grava��o de transferencia simples					 |
+------------+-----------------------------------------------------------------------------------+
| Uso:       | Isapa															                 |
+------------+-----------------------------------------------------------------------------------+
*/

User Function A260GRV()
Local _aArea := GetArea(), _lRet := .t.

If cLocOrig $ Alltrim(GetMv("MV__ARMVEN")) .And. cLocDest $ Alltrim(GetMv("MV__ARMVEN"))
	MsgAlert("N�o permitida transfer�ncia entre os depositos " + cLocOrig + " e " + cLocDest,"TRANSFERENCIA NAO PERMITIDA")
	_lRet := .f.
EndIf
            
RestArea(_aArea)
Return _lRet