#INCLUDE "Protheus.ch"

/*
+-----------+---------+-------+------------------------------------------+------+---------------+
| Programa  | IGENM05 | Autor | Jorge Henrique Alves - Anadi Consultoria | Data | Outubro/2014  |
+-----------+---------+-------+------------------------------------------+------+---------------+
| Descricao | Validador de código para ZX5														|
+-----------+-----------------------------------------------------------------------------------+
| Uso       | Isapa											                                    |
+-----------+-----------------------------------------------------------------------------------+
*/                                        

User Function IGENM05(_cFilIsa,_cGrupo,_cCod)
Local _lRet := .f.

Default _cFilIsa := Space(TamSX3("ZX5_FILISA")[1]), _cGrupo := "", _cCod := ""

If !Empty(_cGrupo) .And. !Empty(_cCod)
	DbSelectArea("ZX5")
	DbSetOrder(1)
	If DbSeek(xFilial("ZX5") + _cFilIsa + _cGrupo + _cCod)
	     _lRet := .t.
	Else
		Help( Nil, Nil, "CODINVALIDO", Nil, "Nao localizado registro com o codigo informado.", 1, 0 )
	EndIf
EndIf

Return _lRet	