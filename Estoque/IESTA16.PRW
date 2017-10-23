#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
                                            
/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | IESTA16 | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Dezembro/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Funcao para retornar saldo de determinado produto exceto da filial recebida   |
|			 | por parametro																 |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
| Parametros | _cFilial  = Filial que não será utilizada para o calculo do saldo             |
|			 | _cProduto = Produto usado para calcular o estoque disponivel                  |
|			 | _cLocal   = Local informado para calculo do estoque							 |
+------------+-------------------------------------------------------------------------------+
*/   

User Function IESTA16(_cFilial,_cProd,_cLocal)
Local _aArea    := GetArea()
Local _cQuery	:= _cLocAte := ""
Local _aFil		:= {}
Local _nSaldo	:= 0

If _cLocal $ GetMv("MV__ARMVEN")
	_cLocal  := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
	_cLocAte := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
Else 
	_cLocAte := _cLocal 
EndIf

_nSaldo := U_xSldPrd4(_cFilial,_cProd,_cLocal," "," "," "," ",_cLocAte)

If _nSaldo < 0
    _nSaldo := 0
EndIf

RestArea(_aArea)
Return _nSaldo