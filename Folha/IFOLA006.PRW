#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFOLA006				| 	Agosto de 2015										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Kliama - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Geração de Comissões dos Vendedores em um unico titulo no SE2					|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFOLA006()

LOCAL aArray := {}
local _aArea := GetArea()
local _cPerg := "IFOLR006"

PRIVATE lMsErroAuto := .F.

AjustSX1(_cPerg)

if !pergunte(_cPerg)
	return
endif                                                                               

_cNotVend := FormatIn(IIF(Empty(MV_PAR09),MV_PAR09,Trim(MV_PAR09)),",")

_cQuery := "SELECT  SE3.E3_VEND VEND, SE3.E3_FILIAL FILIAL, SE3.E3_PREFIXO PREFIXO, SE3.E3_NUM NUM, SE3.E3_PARCELA PARCELA, SE3.E3_SEQ SEQ,  "
_cQuery += "E3_COMIS TOT_COMIS "
_cQuery += "FROM " + retSqlName("SE3") + " SE3 "
_cQuery += "INNER JOIN " + retSqlName("SA3") + " SA3 ON A3_COD = E3_VEND "
_cQuery += "  										AND SA3.A3__SEGISP >= '" + mv_par01 + "'"
_cQuery += "  										AND SA3.A3__SEGISP <= '" + mv_par02 + "'"
_cQuery += "  										AND SA3.D_E_L_E_T_ = ' ' "
_cQuery += "INNER JOIN " + retSqlName("SA2") + " SA2 ON SA2.A2_COD 	= SA3.A3_FORNECE "
_cQuery += "  										AND SA2.A2_LOJA = SA3.A3_LOJA "
_cQuery += "  										AND SA2.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SE3.D_E_L_E_T_ = ' ' "
_cQuery += "  AND SE3.E3_VEND >= '" + mv_par03 + "'"
_cQuery += "  AND SE3.E3_VEND <= '" + mv_par04 + "'"
_cQuery += "  AND SE3.E3_DATA = '        '"
_cQuery += "  AND SE3.E3_EMISSAO >= '" + dtos(mv_par05) + "'"
_cQuery += "  AND SE3.E3_EMISSAO <= '" + dtos(mv_par06) + "'"
_cQuery += "  AND TRIM(SE3.E3_VEND) NOT IN " + _cNotVend + " "
_cQuery += " GROUP BY SE3.E3_VEND, SE3.E3_FILIAL, SE3.E3_PREFIXO, SE3.E3_NUM, SE3.E3_PARCELA, SE3.E3_SEQ, SE3.E3_COMIS "
_cQuery += " ORDER BY SE3.E3_VEND "

TCQUERY _cQuery NEW ALIAS "TMPSE3"

_cVend 	:= TMPSE3->VEND
_nComis	:= 0
_lPrim	:= .t.
_lTot	:= .f.
_cParc	:= "01"
_aSe3   := {}

do while ! TMPSE3->(eof())
	
	If _lPrim
		_nComis := TMPSE3->TOT_COMIS
		_lPrim 	:= .f.
		GravaSE3()
	Elseif TMPSE3->VEND == _cVend .and. !_lPrim
		_nComis += TMPSE3->TOT_COMIS
		GravaSE3()
	Elseif TMPSE3->VEND <> _cVend
		_lTot	:= .t.
		_lPrim	:= .t.
	Endif
	
	If _lTot //gravação no contas a pagar
		If _nComis > 0
			_cNum 		:= strzero(day(mv_par07),2)+strzero(month(mv_par07),2)+Right(Str(Year(mv_par07)),2)
			_cFornece 	:= Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_FORNECE")
			_cLoja		:= Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_LOJA")
			_cPrefixo  	:= "COM"
			
			DbSelectArea("SE2")
			
			_aSe3  := { { "E2_FILIAL"   , xFilial("SE2")    , NIL },;
			{ "E2_FORNECE"  , _cFornece         , NIL },;
			{ "E2_LOJA"     , _cLoja            , NIL },;
			{ "E2_TIPO"     , "NF"              , NIL },;
			{ "E2_PREFIXO"  , "COM"             , NIL },;
			{ "E2_NUM"      , _cNum             , NIL },;
			{ "E2_PARCELA"  , _cParc            , NIL },;
			{ "E2_VALOR"    , _nComis           , NIL },;
			{ "E2_VENCTO"   , MV_PAR07			, NIL },;
			{ "E2_VENCREA"  , MV_PAR07			, NIL },;
			{ "E2_NATUREZ"  , MV_PAR08          , NIL },;
			{ "E2_EMISSAO"  , dDatabase			, NIL }}
			
			MsExecAuto( { |x,y,z| FINA050(x,y,z)}, _aSe3,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
			
			If lMsErroAuto
				MostraErro()
				Msgstop("O processo será interrompido...")
				Exit
			Endif
		Else
			Msgstop("Vendedor: " + _cVend + " está com comissão negativa ou zerada ")
		Endif
		
		_cVend 	:= TMPSE3->VEND
		_nComis	:= 0
		_lPrim	:= .t.
		_lTot	:= .f.
		_aSe3   := {}
		_cParc	:= Soma1(_cParc)
		loop
		
	endif
	DbSelectArea("TMPSE3")
	TMPSE3->(dbSkip())
	
enddo

If _nComis > 0 .and. TMPSE3->(EOF())
	_cNum 		:= strzero(day(mv_par07),2)+strzero(month(mv_par07),2)+Right(Str(Year(mv_par07)),2)
	_cFornece 	:= Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_FORNECE")
	_cLoja		:= Posicione("SA3",1,xFilial("SA3")+_cVend,"A3_LOJA")
	_cPrefixo  	:= "COM"
	
	DbSelectArea("SE2")
	
	_aSe3  := { { "E2_FILIAL"   , xFilial("SE2")    , NIL },;
	{ "E2_FORNECE"  , _cFornece         , NIL },;
	{ "E2_LOJA"     , _cLoja            , NIL },;
	{ "E2_TIPO"     , "NF"              , NIL },;
	{ "E2_PREFIXO"  , "COM"             , NIL },;
	{ "E2_NUM"      , _cNum             , NIL },;
	{ "E2_PARCELA"  , _cParc            , NIL },;
	{ "E2_VALOR"    , _nComis           , NIL },;
	{ "E2_VENCTO"   , MV_PAR07			, NIL },;
	{ "E2_VENCREA"  , MV_PAR07			, NIL },;
	{ "E2_NATUREZ"  , MV_PAR08          , NIL },;
	{ "E2_EMISSAO"  , dDatabase			, NIL }}
	
	MsExecAuto( { |x,y,z| FINA050(x,y,z)}, _aSe3,, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
	
	If lMsErroAuto
		MostraErro()
		Msgstop("O processo será interrompido...")
	Endif
Else
	Msgstop("Vendedor: " + _cVend + " está com comissão negativa ou zerada ")
Endif

TMPSE3->(dbCloseArea())

MsgStop("Processo finalizado...")

restArea (_aArea)
return

/********************************************************/
Static Function GravaSE3()
/********************************************************/

DbSelectarea("SE3")
DbSetOrder(1)

If dbSeek(TMPSE3->FILIAL + TMPSE3->PREFIXO + TMPSE3->NUM + TMPSE3->PARCELA + TMPSE3->SEQ + TMPSE3->VEND)
	While SE3->E3_FILIAL == TMPSE3->FILIAL .AND. SE3->E3_PREFIXO == TMPSE3->PREFIXO .AND. SE3->E3_NUM == TMPSE3->NUM .AND. SE3->E3_PARCELA == TMPSE3->PARCELA .AND. SE3->E3_SEQ == TMPSE3->SEQ .AND. SE3->E3_VEND == TMPSE3->VEND
		If SE3->E3_EMISSAO >= mv_par05 .AND. SE3->E3_EMISSAO <= mv_par06
			If TMPSE3->TOT_COMIS == SE3->E3_COMIS
				RecLock("SE3",.f.)
				SE3->E3_PROCCOM := xFilial("SE2")+"COM"+strzero(day(mv_par07),2)+strzero(month(mv_par07),2)+Right(Str(Year(mv_par07)),2)+space(3)+_cParc
				SE3->E3_DATA	:= MV_PAR07
				MsUnlock("SE3")
				Exit
			Endif
		Endif
		Dbskip()
		Loop
	Enddo
Endif

DbSelectarea("TMPSE3")

Return

/********************************************************/
Static Function AjustSX1(_cPerg)
/********************************************************/

local _aArea := GetArea()
local aPergs := {}

Aadd(aPergs,{"Segmento de"	        ,"","","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Segmento até"	        ,"","","mv_ch2","C",03,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Vendedor de"	        ,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Vendedor até"	        ,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Vendas de"			,"","","mv_ch5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Vendas até"			,"","","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Data de Lançamento"	,"","","mv_ch7","D",08,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Natureza"  	        ,"","","mv_ch8","C",10,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SED"	,"","","",""})
Aadd(aPergs,{"Exceto Vendedores"    ,"","","mv_ch9","C",60,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
AjustaSx1(_cPerg,aPergs)

RestArea (_aArea)

Return(_cPerg)
/*
_cQuery := "SELECT  MAX(E3_VEND) E3_VEND, "
_cQuery += "		SUM(E3_COMIS) TOT_COMIS "
_cQuery += "FROM " + retSqlName("SE3") + " SE3 "
_cQuery += "INNER JOIN " + retSqlName("SA3") + " SA3 ON A3_COD = E3_VEND "
_cQuery += "  										AND SA3.A3__SEGISP >= '" + mv_par01 + "'"
_cQuery += "  										AND SA3.A3__SEGISP <= '" + mv_par02 + "'"
_cQuery += "  										AND SA3.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE SE3.D_E_L_E_T_ = ' ' "
_cQuery += "  AND SE3.E3_VEND >= '" + mv_par03 + "'"
_cQuery += "  AND SE3.E3_VEND <= '" + mv_par04 + "'"
_cQuery += "  AND SE3.E3_DATA = '        '"
_cQuery += "  AND SE3.E3_EMISSAO >= '" + dtos(mv_par05) + "'"
_cQuery += "  AND SE3.E3_EMISSAO <= '" + dtos(mv_par06) + "'"
_cQuery += " GROUP BY SE3.E3_VEND "

TCQUERY _cQuery NEW ALIAS "TMPSE32"


*/
