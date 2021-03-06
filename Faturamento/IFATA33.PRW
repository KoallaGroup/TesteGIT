#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | IFATA33  | Autor: | Rog�rio Alves - Anadi Consultoria        | Data: |  Abril/2014  |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descri��o: | Verifica��o do preenchimento de algum produto no pedido de venda, para bloqueio ou  |
|            | n�o do campo c5__remdiv para produtos com remessas diversas                         |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function IFATA33()

Local _lRet := .t.

If(Inclui .Or. Altera)
	For nx := 1 To Len(aCols)
		If !Empty(aCols[nx][2])
			_lRet := .f.
			Exit
		EndIf
	Next nx
EndIf

Return _lRet