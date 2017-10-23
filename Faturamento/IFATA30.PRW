#include "protheus.ch" 

/*
+----------+----------+-------+-------------------------------------+------+----------------+
|Programa  | IFATA30  | Autor | Jorge Henrique - Anadi Consultoria  | Data | Fevereiro/2015 |
+----------+----------+-------+-------------------------------------+------+----------------+
|Descricao | Cadastro de convênio de fretes													|
+----------+--------------------------------------------------------------------------------+
|Uso       | Isapa                                                                          |
+----------+--------------------------------------------------------------------------------+
*/

User Function IFATA30()

AxCadastro("SZJ","Convenio de fretes")

Return

/*
+----------+----------+-------+-------------------------------------+------+----------------+
|Programa  | IFATA30V | Autor | Jorge Henrique - Anadi Consultoria  | Data | Fevereiro/2015 |
+----------+----------+-------+-------------------------------------+------+----------------+
|Descricao | Valida a região selecionada no convenio de fretes								|
+----------+--------------------------------------------------------------------------------+
|Uso       | Isapa                                                                          |
+----------+--------------------------------------------------------------------------------+
*/

User Function IFATA30V()
Local _lRet := .t.

If Empty(Posicione("ZX5",1,xFilial("ZX5") + "  000006" + M->ZJ_REGIAO,"ZX5_CODIGO"))
    _lRet := .f.
    Help( Nil, Nil, "COD_REG", Nil, "Região não localizada, favor verificar.", 1, 0 )  
EndIf

Return _lRet


/*
+----------+----------+-------+-------------------------------------+------+----------------+
|Programa  | IFATA30C | Autor | Jorge Henrique - Anadi Consultoria  | Data | Fevereiro/2015 |
+----------+----------+-------+-------------------------------------+------+----------------+
|Descricao | Valida a região selecionada no cadastro do cliente								|
+----------+--------------------------------------------------------------------------------+
|Uso       | Isapa                                                                          |
+----------+--------------------------------------------------------------------------------+
*/

User Function IFATA30C(_cField)
Local _lRet := .t.

If _cField == "1" //A1__REGVEN
	If Empty(Posicione("ZX5",1,xFilial("ZX5") + "  000006" + M->A1__REGVEN,"ZX5_CODIGO"))
		_lRet := .f.
		Help( Nil, Nil, "COD_REG", Nil, "Região de venda não localizada, favor verificar.", 1, 0 )  
	EndIf
ElseIf _cField == "2" //A1__REGTRP
	If Empty(Posicione("ZX5",1,xFilial("ZX5") + "  000006" + M->A1__REGTRP,"ZX5_CODIGO"))
		_lRet := .f.
		Help( Nil, Nil, "COD_REG", Nil, "Região de transporte não localizada, favor verificar.", 1, 0 )
	EndIf
EndIf

Return _lRet