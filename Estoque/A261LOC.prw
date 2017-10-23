#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+-------------+
| Programa:  | A261LOC | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Agosto/2015 |
+------------+---------+--------+------------------------------------------+-------+-------------+
| Descrição: | Ponto de entrada para validar Armazem na transferencia multipla					 |
+------------+-----------------------------------------------------------------------------------+
| Uso:       | Isapa															                 |
+------------+-----------------------------------------------------------------------------------+
*/

User Function A261LOC()
Local _aArea := GetArea(), _lRet := .t.
Local _nPLocOri := Val(Separa(Alltrim(GetMv("MV__261LOC")),";")[1])
Local _nPLocDes := Val(Separa(Alltrim(GetMv("MV__261LOC")),";")[2])

If ParamIxb[3] = 2 //Armazem de Destino
	If aCols[n][_nPLocOri] $ Alltrim(GetMv("MV__ARMVEN")) .And. ParamIxb[2] $ Alltrim(GetMv("MV__ARMVEN"))
		MsgAlert("Não permitida transferência entre os depositos " + aCols[n][_nPLocOri] + " e " + ParamIxb[2],"TRANSFERENCIA NAO PERMITIDA")
		_lRet := .f.
	EndIf
Else //Armazem de origem
	If ParamIxb[2] $ Alltrim(GetMv("MV__ARMVEN")) .And. aCols[n][_nPLocDes] $ Alltrim(GetMv("MV__ARMVEN"))
		MsgAlert("Não permitida transferência entre os depositos " + ParamIxb[2] + " e " + aCols[n][_nPLocDes],"TRANSFERENCIA NAO PERMITIDA")
		_lRet := .f.
	EndIf
EndIf
            
RestArea(_aArea)
Return _lRet