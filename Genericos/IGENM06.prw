#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | IGENM06  | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Exibe a foto do produto                                                             |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/


User Function IGENM06(_cProduto)
Local oBitmap1, oButton1, _oDlgBmp, _cFolder := Alltrim(GetMv("MV__BMPSIS")), _cFile := _cFolder
Default _cProduto := ""

If Empty(_cProduto)
	MsgAlert("Produto nao informado","FIGURA DO PRODUTO")
	Return
EndIf

If Alltrim(Posicione("SB1",1,xFilial("SB1") + _cProduto,"B1__SEGISP")) == "1"
	_cFile += "\Bike\" + Alltrim(SB1->B1__FOTO)
ElseIf Alltrim(SB1->B1__SEGISP) == "2"
	_cFile += "\Auto\" + Alltrim(SB1->B1__FOTO)
Else
	MsgAlert("Segmento do produto nao especificado","FIGURA DO PRODUTO")
	Return
EndIf

If !File(_cFile)
	_cFile := _cFolder + "\indisponivel.jpg"
EndIf

DEFINE MSDIALOG _oDlgBmp TITLE "FOTO DO PRODUTO" FROM 000, 000  TO 540, 700 COLORS 0, 16777215 PIXEL

    @ 001, 001 BITMAP oBitmap1 SIZE 347, 244 OF _oDlgBmp FILENAME _cFile NOBORDER PIXEL
    @ 252, 308 BUTTON oButton1 PROMPT "Retornar" SIZE 037, 012 OF _oDlgBmp ACTION {|| _oDlgBmp:End()} PIXEL

ACTIVATE MSDIALOG _oDlgBmp CENTERED

Return