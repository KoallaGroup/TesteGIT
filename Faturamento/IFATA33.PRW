#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | IFATA33  | Autor: | Rogério Alves - Anadi Consultoria        | Data: |  Abril/2014  |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Verificação do preenchimento de algum produto no pedido de venda, para bloqueio ou  |
|            | não do campo c5__remdiv para produtos com remessas diversas                         |
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