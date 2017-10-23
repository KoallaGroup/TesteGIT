#INCLUDE "PROTHEUS.CH"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : MA040BRW			  		| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para filtrar os vendedores									  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function MA040BRW()

Local _aArea := GetArea()
Local _cRet	 := ""

DbSelectArea("SZ1")
DbSetOrder(1)
If DbSeek(xFilial("SZ1")+__cUserId)
	_cSegto := SZ1->Z1_SEGISP
Else
	_cSegto := '0'
Endif

If Val(_cSegto) > 0
	_cRet := 'A3__SEGISP = "'+_cSegto+'" '
Endif

RestArea(_aArea)

Return _cRet