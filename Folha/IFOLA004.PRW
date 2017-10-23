#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFOLA004				| 	Janeiro de 2015										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Geração de IR nas Comissões dos Vendedores										|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFOLA004()

local _aArea := GetArea()
local _cPerg := "IFOLR004"
local _nPerIR:= 1.5
local _cCodIR:= "999999"

AjustSX1(_cPerg)

if !pergunte(_cPerg)
	return
endif

dbSelectArea("Z24")
dbSetOrder(1)
if ! dbSeek(xFilial("Z24")+_cCodIR)
	reclock("Z24", .T.)
	
	Z24->Z24_FILIAL := xFilial("Z24")
	Z24->Z24_CODIGO	:= _cCodIR
	Z24->Z24_DESC	:= "IMPOSTO DE RENDA"
	Z24->Z24_TIPO	:= "1"
	Z24->Z24_INCIR	:= "1"
	
	Z24->(msUnlock())
endif


_cQuery := "SELECT  MAX(E3_VEND) E3_VEND, "
_cQuery += "		SUM(E3_COMIS) TOT_COMIS "
_cQuery += "FROM " + retSqlName("SE3") + " SE3 "
_cQuery += "INNER JOIN " + retSqlName("SA3") + " SA3 ON A3_COD = E3_VEND "
_cQuery += "  										AND SA3.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN " + retSqlName("SA2") + " SA2 ON A2_COD = A3_FORNECE "
_cQuery += "  										AND A2_LOJA = A3_LOJA "
_cQuery += "  										AND A2_SIMPNAC <> '1' "
_cQuery += "  										AND SA2.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SE3.D_E_L_E_T_ = ' ' "
_cQuery += "  AND SE3.E3_VEND >= '" + mv_par05 + "'"
_cQuery += "  AND SE3.E3_VEND <= '" + mv_par06 + "'"
_cQuery += "  AND SE3.E3_EMISSAO >= '" + dtos(mv_par02) + "'"
_cQuery += "  AND SE3.E3_EMISSAO <= '" + dtos(mv_par03) + "'"
_cQuery += "  AND (SE3.E3__TPLANC = ' ' OR SE3.E3__COMIS = '1')"
_cQuery += "GROUP BY SE3.E3_VEND "

TCQUERY _cQuery NEW ALIAS "TMPSE3"

do while ! TMPSE3->(eof())
	
	_cQuery := "DELETE FROM " + retSqlName("SE3") + " "
	_cQuery += "WHERE E3_VEND = '" + TMPSE3->E3_VEND + "' "
	_cQuery += "  AND E3_EMISSAO >= '" + dtos(mv_par02) + "'"
	_cQuery += "  AND E3_EMISSAO <= '" + dtos(mv_par03) + "'"
	_cQuery += "  AND E3__TPLANC = '" + _cCodIR + "' "
	_cQuery += "  AND E3_DATA = '        '"	
	_cQuery += "  AND D_E_L_E_T_ = ' ' "
   
	TCSQLExec(_cQuery)

	_cQuery := "SELECT  SUM(E3_COMIS) TOT_DEBCRE "
	_cQuery += "FROM " + retSqlName("SE3") + " SE3 "
	_cQuery += "INNER JOIN " + retSqlName("Z24") + " Z24 ON Z24_CODIGO = E3__TPLANC "
	_cQuery += "										AND Z24_INCIR = '1' "
	_cQuery += "										AND Z24_COMIS = '2' "
	_cQuery += "										AND Z24.D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE SE3.D_E_L_E_T_ = ' ' "
	_cQuery += "  AND SE3.E3_VEND = '" + TMPSE3->E3_VEND + "'"
	_cQuery += "  AND SE3.E3_EMISSAO >= '" + dtos(mv_par02) + "'"
	_cQuery += "  AND SE3.E3_EMISSAO <= '" + dtos(mv_par03) + "'"
	
	TCQUERY _cQuery NEW ALIAS "TMPDC"
	
	_cQuery := "SELECT  SUM(E3_COMIS) TOT_DEBCRE "
	_cQuery += "FROM " + retSqlName("SE3") + " SE3 "
	_cQuery += "INNER JOIN " + retSqlName("Z24") + " Z24 ON Z24_CODIGO = E3__TPLANC 	 "
	_cQuery += "										AND Z24.D_E_L_E_T_ = ' ' "
	_cQuery += "WHERE SE3.D_E_L_E_T_ = ' ' "
	_cQuery += "  AND SE3.E3_VEND = '" + TMPSE3->E3_VEND + "'"
	_cQuery += "  AND SE3.E3_EMISSAO >= '" + dtos(mv_par02) + "'"
	_cQuery += "  AND SE3.E3_EMISSAO <= '" + dtos(mv_par03) + "'"
	_cQuery += "  AND Z24_INCIR = '2' "
	_cQuery += "  AND Z24_COMIS = '2'"
	_cQuery += "  AND Z24_CODIGO NOT IN ('999999') "
	
	TCQUERY _cQuery NEW ALIAS "TMPDC1"
	
	_nBaseIR:= round(TMPSE3->TOT_COMIS,2) + round(TMPDC->TOT_DEBCRE,2) + round(TMPDC1->TOT_DEBCRE,2)
	_nValIR	:= round(_nBaseIR * _nPerIR / 100,2)
	
	dbSelectArea("SE3")
	
	If _nValIR > 10.00
		
		reclock("SE3", .T.)
		
		SE3->E3_FILIAL	:= mv_par01
		SE3->E3_VEND 	:= TMPSE3->E3_VEND
		SE3->E3_COMIS	:= _nValIR * -1
		SE3->E3_VENCTO	:= mv_par04
		SE3->E3_EMISSAO	:= mv_par04
		SE3->E3_BASE	:= _nValIR * -1
		SE3->E3_PORC	:= 100
		SE3->E3__TPLANC	:= _cCodIR
		
		SE3->(msUnlock())
		
	EndIf
	
	TMPDC->(dbCloseArea())
	TMPDC1->(dbCloseArea())
	
	TMPSE3->(dbSkip())
enddo
TMPSE3->(dbCloseArea())

MsgStop("Processo finalizado...")

restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

local _aArea := GetArea()
local aPergs := {}

Aadd(aPergs,{"Local"				,"","","mv_ch1","C",02,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SM0" 	,"","","",""})
Aadd(aPergs,{"Vendas de"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Vendas até"			,"","","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Data de Lançamento"	,"","","mv_ch4","D",08,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Representante de"		,"","","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Representante até"	,"","","mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})

AjustaSx1(_cPerg,aPergs)

RestArea (_aArea)

Return(_cPerg)
