#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFOLA005				| 	Agosto de 2015										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por kliamca - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Geração de Comissoes no SE3 a partir da query   								|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFOLA005()

local _aArea := GetArea()
local _cPerg := "IFOLA005"

AjustSX1(_cPerg)

if !pergunte(_cPerg)
	return
endif

_cQuery := "DELETE FROM " + retSqlName("SE3") + " "
_cQuery += "WHERE E3_VENCTO >= '" + dtos(mv_par01) + "' "
_cQuery += "  AND E3_VENCTO <= '" + dtos(mv_par02) + "' "
_cQuery += "  AND E3__ROT = '" + _cPerg + "' "
TCSQLExec(_cQuery)

_cQuery := "Select E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_VEND1, "
_cQuery += "E1_EMISSAO,E1_VALOR,E1_BAIXA, E1_MULTA, E1_JUROS, E1_DESCONT, E1_BASCOM1, E1_PEDIDO, "
_cQuery += "SUM(case when SE5R.E5_RECPAG = 'R' then SE5R.E5_VALOR - SE5R.E5_VLMULTA - SE5R.E5_Vljuros else 0 end) RECEBER, "
_cQuery += "SUM(case when SE5R.E5_RECPAG = 'P' then SE5R.E5_VALOR else 0 End) PAGAR, "
_cQuery += "(E1_VALOR - SUM(case when SE5R.E5_RECPAG = 'R' then SE5R.E5_VALOR- SE5R.E5_VLMULTA - SE5R.E5_Vljuros else 0 end) + "
_cQuery += "SUM(case when SE5R.E5_RECPAG = 'P' then SE5R.E5_VALOR else 0 End)) DIF, "
_cQuery += "((E1_VALOR - SUM(case when SE5R.E5_RECPAG = 'R' then SE5R.E5_VALOR- SE5R.E5_VLMULTA - SE5R.E5_Vljuros else 0 end) + "
_cQuery += "SUM(case when SE5R.E5_RECPAG = 'P' then SE5R.E5_VALOR else 0 End)) * E1_BASCOM1)/E1_VALOR BASE_COMIS,E1_COMIS1, "
_cQuery += "(E1_PREFIXO||E1_NUM||E1_PARCELA||E1_CLIENTE||E1_LOJA||E1_VEND1) CHAVE "
_cQuery += "From " + retSqlName("SE1") + " E1 "
_cQuery += "Inner Join " + retSqlName("SE5") + " SE5R on SE5R.E5_FILORIG = E1_FILIAL And SE5R.E5_PREFIXO = E1_PREFIXO And SE5R.E5_NUMERO = E1_NUM ANd "
_cQuery += " SE5R.E5_PARCELA = E1_PARCELA And "
_cQuery += " SE5R.E5_TIPO = E1_TIPO And SE5R.E5_CLIFOR = E1_CLIENTE And SE5R.E5_LOJA = E1_LOJA ANd SE5R.D_E_L_E_T_ = ' ' "
_cQuery += " Where E1_SALDO = 0 and E1.D_E_L_E_T_ = ' ' ANd SE5R.E5_SITUACA not in ('C','X','E') And SE5R.E5_TIPODOC not in ('JR','MT') "
_cQuery += " And E1_TIPO = 'NF' "
_cQuery += " AND E5_DATA >= '" + dtos(mv_par01) + "'"
_cQuery += " ANd E5_DATA <= '" + dtos(mv_par02) + "'"
_cQuery += " And E1_BAIXA <= '" + dtos(mv_par02) + "'"
_cQuery += " And E1_EMISSAO < '20150501' "
_cQuery += " And E1_VEND1 <> ' ' "
_cQuery += " Group by E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_CLIENTE,E1_LOJA,E1_VEND1,E1_EMISSAO, "
_cQuery += " E1_VALOR,E1_BAIXA,E1.E1_MULTA,E1.E1_JUROS, "
_cQuery += " E1.E1_DESCONT,E1_BASCOM1,E1_COMIS1,(E1_PREFIXO||E1_NUM||E1_PARCELA||E1_CLIENTE||E1_LOJA||E1_VEND1), E1.E1_PEDIDO "
_cQuery += " Having (SUM(case when SE5R.E5_RECPAG = 'R' then SE5R.E5_VALOR else 0 end) - "
_cQuery += " SUM(case when SE5R.E5_RECPAG = 'P' then SE5R.E5_VALOR else 0 End)) < E1_VALOR "

TCQUERY _cQuery NEW ALIAS "TMPSE5"

DbSelectArea("TMPSE5")

do while ! TMPSE5->(eof())
	
	_nBaseComis := round(TMPSE5->BASE_COMIS * (TMPSE5->E1_COMIS1 / 100),2)
	
	If _nBaseComis > 0
		
		dbSelectArea("SE3")
		
		reclock("SE3", .T.)
		SE3->E3_FILIAL	:= TMPSE5->E1_FILIAL
		SE3->E3_VEND 	:= TMPSE5->E1_VEND1
		SE3->E3_NUM		:= TMPSE5->E1_NUM
		SE3->E3_EMISSAO	:= MV_PAR03
		SE3->E3_SERIE	:= TMPSE5->E1_PREFIXO
		SE3->E3_CODCLI	:= TMPSE5->E1_CLIENTE
		SE3->E3_LOJA	:= TMPSE5->E1_LOJA
		SE3->E3_BASE	:= TMPSE5->BASE_COMIS
		SE3->E3_PORC	:= TMPSE5->E1_COMIS1
		SE3->E3_COMIS	:= _nBaseComis
		SE3->E3_PREFIXO	:= TMPSE5->E1_PREFIXO
		SE3->E3_PARCELA	:= TMPSE5->E1_PARCELA
		SE3->E3_TIPO	:= "NF"
		SE3->E3_BAIEMI	:= "B"
		SE3->E3_PEDIDO	:= TMPSE5->E1_PEDIDO
		SE3->E3_ORIGEM	:= "B"
		SE3->E3_VENCTO	:= MV_PAR03
		SE3->E3_MOEDA	:= "01"
		SE3->E3__ROT	:= _cPerg
		
		SE3->(msUnlock())
		
	EndIf
	
	DbSelectArea("TMPSE5")
	TMPSE5->(dbSkip())
	Loop

enddo
TMPSE5->(dbCloseArea())

MsgStop("Processo finalizado...")

restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

local _aArea := GetArea()
local aPergs := {}

Aadd(aPergs,{"Vendas de"			,"","","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Vendas até"			,"","","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Data de Lançamento"	,"","","mv_ch3","D",08,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
AjustaSx1(_cPerg,aPergs)

RestArea (_aArea)

Return(_cPerg)
