#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|
|	Programa : PE01NFESEFAZ				| 	Agosto de 2014														|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi																		|
|---------------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada para manipular informações do XML sem alterar o fonte original XMLNFESEFAZ		|
|---------------------------------------------------------------------------------------------------------------|
*/


// aRetorno[1] -> aProd
// aRetorno[2] -> cMensCli
// aRetorno[3] -> cMensFis
// aRetorno[4] -> aDest
// aRetorno[5] -> aNota
// aRetorno[6] -> aInfoItem
// aRetorno[7] -> aDupl
// aRetorno[8] -> aTransp
// aRetorno[9] -> aEntrega
// aRetorno[10] -> aRetirada
// aRetorno[11] -> aVeiculo
// aRetorno[11] -> aReboque


User FUNCTION PE01NFESEFAZ()

local aNfe 		:= PARAMIXB
local lNfEntrada:=.F.
local lNfSaida	:=.F.

local aPROD 	:= 1 //-> aProd
local cMENSCLI 	:= 2 //-> cMensCli
local cMENSFIS 	:= 3 //-> cMensFis
local aDEST 	:= 4 //-> aDest
local aNOTA 	:= 5 //-> aNota
local aINFOITEM := 6 //-> aInfoItem
local aDUPL 	:= 7 //-> aDupl
local aTRANSP 	:= 8 //-> aTransp
local aENTREGA 	:= 9 //-> aEntrega
local aRETIRADA := 10 //-> aRetirada
local aVEICULO 	:= 11 //-> aVeiculo
local aREBOQUE 	:= 12 //-> aReboque

lNfEntrada		:=(aNfe[aNOTA,4]=="0")
lNfSaida		:=(aNfe[aNOTA,4]=="1")

IF lNfSaida
	
	//----------------- MENSCLI
	
	_cQuery := "SELECT
	
	_cQuery := "select distinct C5_NUM, C5__NUMSUA, "
	_cQuery += "                A3_NOME, "
	_cQuery += "                E4_CODIGO, "
	_cQuery += "                SA1E.A1_END as ENDERECO_ENTREGA, "
	_cQuery += "                SA1E.A1_BAIRRO as BAIRRO_ENTREGA, "
	_cQuery += "                SA1E.A1_MUN as CIDADE_ENTREGA, "
	_cQuery += "                SA1E.A1_EST as ESTADO_ENTREGA, "
	_cQuery += "                SA1E.A1_CEP as CEP_ENTREGA, "
	_cQuery += "                SA1C.A1_END as ENDERECO_COBRANCA, "
	_cQuery += "                SA1C.A1_BAIRRO as BAIRRO_COBRANCA, "
	_cQuery += "                SA1C.A1_MUN as CIDADE_COBRANCA, "
	_cQuery += "                SA1C.A1_EST as ESTADO_COBRANCA, "
	_cQuery += "                SA1C.A1_CEP as CEP_COBRANCA, "
	_cQuery += "                SA1D.A1_END as ENDERECO_C5, "
	_cQuery += "                SA1D.A1_BAIRRO as BAIRRO_C5, "
	_cQuery += "                SA1D.A1_MUN as CIDADE_C5, "
	_cQuery += "                SA1D.A1_EST as ESTADO_C5, "
	_cQuery += "                SA1D.A1_CEP as CEP_C5, "
	_cQuery += "                Z211.Z21_TEXTO1 as TXTNF1_1, "
	_cQuery += "                Z211.Z21_TEXTO2 as TXTNF1_2, "
	_cQuery += "                Z211.Z21_TEXTO3 as TXTNF1_3, "
	_cQuery += "                Z211.Z21_TEXTO4 as TXTNF1_4, "
	_cQuery += "                Z211.Z21_TEXTO5 as TXTNF1_5, "
	_cQuery += "                UA__LJACOB, "
	_cQuery += "                UA__LJAENT "
	
	_cQuery += "from " + retSqlName("SD2") + " SD2 "
	
	_cQuery += "inner join " + retSqlName("SF2") + " SF2 ON F2_DOC = D2_DOC "
	_cQuery += "                     AND F2_FILIAL = D2_FILIAL "
	_cQuery += "                     AND SF2.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join " + retSqlName("SC5") + " SC5 ON C5_NUM = D2_PEDIDO "
	_cQuery += "                     AND C5_FILIAL = D2_FILIAL "
	_cQuery += "                     AND SC5.D_E_L_E_T_ = ' ' "
	
	_cQuery += "left join " + retSqlName("SUA") + " SUA ON UA_NUM = C5__NUMSUA "
	_cQuery += "                     AND UA__FILIAL = C5_FILIAL "
	_cQuery += "                     AND SUA.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join " + retSqlName("SA3") + " SA3 ON A3_COD = F2_VEND1 "
	_cQuery += "                     AND SA3.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join " + retSqlName("SE4") + " SE4 ON E4_CODIGO = F2_COND "
	_cQuery += "                     AND SE4.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join " + retSqlName("SA1") + " SA1D ON SA1D.A1_COD = C5_CLIENTE "
	_cQuery += "                      AND SA1D.A1_LOJA = C5_LOJACLI "
	_cQuery += "                      AND SA1D.D_E_L_E_T_ = ' ' "
	
	_cQuery += "left join " + retSqlName("SA1") + " SA1E ON SA1E.A1_COD = UA_CLIENTE "
	_cQuery += "                      AND SA1E.A1_LOJA = UA__LJAENT "
	_cQuery += "                      AND SA1E.D_E_L_E_T_ = ' ' "
	
	_cQuery += "left join " + retSqlName("SA1") + " SA1C ON SA1C.A1_COD = UA_CLIENTE "
	_cQuery += "                      AND SA1C.A1_LOJA = UA__LJACOB "
	_cQuery += "                      AND SA1C.D_E_L_E_T_ = ' ' "
	
	_cQuery += "left join " + retSqlName("Z21") + " Z211 ON Z211.Z21_CODIGO = C5__TXTNF2 "
	_cQuery += "                     AND Z211.D_E_L_E_T_ = ' ' "
	
	_cQuery += "where D2_DOC = '" + SF2->F2_DOC  + "' "
	_cQuery += "  and D2_SERIE = '" + SF2->F2_SERIE  + "' "
	_cQuery += "  and D2_FILIAL = '" + xFilial("SD2")  + "' "
	_cQuery += "  and SD2.D_E_L_E_T_ = ' ' "
	
	If(select("TMPMSC") > 0)
		TMPMSC->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPMSC"
	
	//		cMensImp := superGetMV("MV__MSGNFE", .F., "IMPOSTO RETIDO POR SUBSTITUICAO TRIBUTARIA ARTIGO 313 Z-5 RICMS/00")
	
	_cMens 	:= ""
	
	_cMens 	:= U_MenPad(TMPMSC->C5_NUM)
	
	_cMens 	+= " PEDIDO " + IIF(Empty(TMPMSC->C5__NUMSUA),alltrim(TMPMSC->C5_NUM),alltrim(TMPMSC->C5__NUMSUA))
	_cMens 	+= " - REPRESENTANTE " + alltrim(SF2->F2_VEND1) + " " + alltrim(TMPMSC->A3_NOME)
	_cMens 	+= " - COND PAGTO " + alltrim(TMPMSC->E4_CODIGO)
	
	if ! empty(TMPMSC->ENDERECO_ENTREGA)
		_cMens 	+= " - ENDERECO ENTREGA " + alltrim(TMPMSC->ENDERECO_ENTREGA)
		_cMens 	+= " BAIRRO " + alltrim(TMPMSC->BAIRRO_ENTREGA)
		_cMens 	+= " MUNICIPIO " + alltrim(TMPMSC->CIDADE_ENTREGA) + "/" + alltrim(TMPMSC->ESTADO_ENTREGA)
		_cMens 	+= " CEP " + alltrim(TMPMSC->CEP_ENTREGA)
	else
		_cMens 	+= " - ENDERECO ENTREGA " + alltrim(TMPMSC->ENDERECO_C5)
		_cMens 	+= " BAIRRO " + alltrim(TMPMSC->BAIRRO_C5)
		_cMens 	+= " MUNICIPIO " + alltrim(TMPMSC->CIDADE_C5) + "/" + alltrim(TMPMSC->ESTADO_C5)
		_cMens 	+= " CEP " + alltrim(TMPMSC->CEP_C5)
	endif
	
	_cMens 	+= " - ENDERECO COBRANÇA " + alltrim(TMPMSC->ENDERECO_COBRANCA)
	if ! empty(TMPMSC->UA__LJAENT)
		if TMPMSC->UA__LJAENT <> TMPMSC->UA__LJACOB
			_cMens 	+= " BAIRRO " + alltrim(TMPMSC->BAIRRO_COBRANCA)
			_cMens 	+= " MUNICIPIO " + alltrim(TMPMSC->CIDADE_COBRANCA) + "/" + alltrim(TMPMSC->ESTADO_COBRANCA)
			_cMens 	+= " CEP " + alltrim(TMPMSC->CEP_COBRANCA)
		else
			_cMens 	+= "A MESMA"
		endif
	else
		_cMens 	+= "A MESMA"
	endif
	
	If !Empty(SF2->F2_REDESP)
		_cMens += " - Redespacho: " + Alltrim(Posicione("SA4",1,xFilial("SA4") + SF2->F2_REDESP,"A4_NOME"))
		_cMens += IIF(!Empty(SA4->A4_CGC)," CNPJ: " + Transform(SA4->A4_CGC,"@R 99.999.999/9999-99"),"")
		_cMens += IIF(!Empty(SA4->A4_END), "-" + Alltrim(SA4->A4_END),"")
		_cMens += IIF(!Empty(SA4->A4_MUN), "-" + Alltrim(SA4->A4_MUN),"")
		_cMens += IIF(!Empty(SA4->A4_BAIRRO), "-" + Alltrim(SA4->A4_BAIRRO),"")
		_cMens += IIF(!Empty(SA4->A4_EST), "-" + Alltrim(SA4->A4_EST),"")
		_cMens += IIF(!Empty(SA4->A4_CEP), "-" + Transform(SA4->A4_CEP,"@R 99999-999"),"")
		_cMens += IIF(!Empty(SA4->A4_TEL), "-" + Alltrim(SA4->A4_DDD) + Alltrim(SA4->A4_TEL),"") 
		_cMens += IIF(SA4->A4__TPFRET == 'C', "- FRETE PAGO PELA EMPRESA", "- FRETE PAGO PELO CLIENTE") 
	EndIf
	
	_cMens 	+= " - " + alltrim(TMPMSC->TXTNF1_1) + " " + alltrim(TMPMSC->TXTNF1_2) + " " + alltrim(TMPMSC->TXTNF1_3) + " " + alltrim(TMPMSC->TXTNF1_4) + " " + alltrim(TMPMSC->TXTNF1_5)
	
	TMPMSC->(dbCloseArea())
	
	aNfe[cMENSCLI] += _cMens
	
	//----------------- MENFIS
	
	if SM0->M0_ESTENT == SF2->F2_EST
		
		_cQuery := "SELECT SUM((D1__VLREOA / D1_QUANT)*Z11_QTDEUT) TOTALREOA "
		_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
		_cQuery += "INNER JOIN " + retSqlname("Z11") + " Z11 ON Z11_DOCSAI = D2_DOC "
		_cQuery += " 										AND Z11_SERSAI = D2_SERIE "
		_cQuery += " 										AND Z11_FILIAL = D2_FILIAL "
		_cQuery += " 										AND Z11_ITEMSA = D2_ITEM "
		_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON Z11_DOCENT = D1_DOC "
		_cQuery += " 										AND Z11_SERENT = D1_SERIE "
		_cQuery += " 										AND Z11_FILIAL = D1_FILIAL "
		_cQuery += " 										AND Z11_ITEMEN = D1_ITEM "
		_cQuery += " 										AND SD1.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D2_DOC = '" + SF2->F2_DOC  + "' "
		_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE  + "' "
		_cQuery += "  AND D2_FILIAL = '" + xFilial("SD2")  + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
		
		If(select("TMPSD2Z11") > 0)
			TMPSD2Z11->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPSD2Z11"
		
		_cQuery := "SELECT SUM(D2_TOTAL) TOTALPRODS "
		_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
		_cQuery += "WHERE D2_DOC = '" + SF2->F2_DOC  + "' "
		_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE  + "' "
		_cQuery += "  AND D2_FILIAL = '" + xFilial("SD2")  + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
		
		If(select("TMPSD2") > 0)
			TMPSD2->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPSD2"
		
		if TMPSD2Z11->TOTALREOA > 0
			_cMensagem := "   BC-ICMS " + transform(TMPSD2->TOTALPRODS, "@E 99,999,999.99")
			_cMensagem += "   ICMS NORMAL "  + transform(TMPSD2Z11->TOTALREOA, "@E 99,999,999.99")
			_cMensagem += "   " + getMV("MV__MSGREO")
			
			aNfe[cMensFis] += _cMensagem
		endif
	endif
	
	/*
	ADICIONADO POR RAFAEL DOMINGUES EM 22/05/15
	TRATAMENTO PARA ALTERAR O PESO NO DOCUMENTO DE CARGA DO GFE - TABELA GW8
	*/
	//***********************************************************************
	_cQuery := " SELECT * FROM "+RetSqlName("GW8")
	_cQuery += " WHERE D_E_L_E_T_ = ' ' "
	_cQuery += " AND GW8_NRDC = '"+SF2->F2_DOC+"' "
	_cQuery += " AND GW8_SERDC = '"+SF2->F2_SERIE+"' "
	_cQuery += " AND GW8_FILIAL = '"+SF2->F2_FILIAL+"' "
	_cQuery := ChangeQuery(_cQuery)
	dbUseArea(.T., "TOPCONN", TCGenQry(,,_cQuery), 'TMP', .F., .T.)
	
	DbSelectArea("TMP")
	DbGoTop()
	
	If !Empty(TMP->GW8_NRDC)
		
		_cQuery1 := " UPDATE "+RetSqlName("GW8")
		_cQuery1 += " SET GW8_PESOR = 0 WHERE D_E_L_E_T_ = ' ' "
		_cQuery1 += " AND GW8_NRDC = '"+SF2->F2_DOC+"' "
		_cQuery1 += " AND GW8_SERDC = '"+SF2->F2_SERIE+"' "
		_cQuery1 += " AND GW8_FILIAL = '"+SF2->F2_FILIAL+"' "
		TCSQLExec(_cQuery1)
		
		GW8->(DbGoto(TMP->R_E_C_N_O_))
		RecLock("GW8",.F.)
		GW8_PESOR := SF2->F2_PBRUTO
		MsUnLock()
		
	EndIf
	
	DbSelectArea("TMP")
	DbCloseArea()
	//***********************************************************************
		
else     //NF de entrada
	
	
	//----------------- MENFIS
	
	if SF1->F1_EST == 'EX'
		
		_cMensagem := " PROC NR : " + SF1->F1__REFEXT
		
		_cQuery := "SELECT DISTINCT D1__NDI, D1__DTDI, F4_FORMULA "
		_cQuery += "FROM " + retSqlname("SD1") + " SD1 "
		_cQuery += "INNER JOIN " + retSqlname("SF4") + " SF4 ON F4_CODIGO = D1_TES "
		_cQuery += " 										AND F4_FILIAL = D1_FILIAL "
		_cQuery += " 										AND nvl(F4_FORMULA, ' ') <> ' ' "
		_cQuery += " 										AND SF4.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D1_DOC = '" + SF1->F1_DOC  + "' "
		_cQuery += "  AND D1_SERIE = '" + SF1->F1_SERIE  + "' "
		_cQuery += "  AND D1_FORNECE = '" + SF1->F1_FORNECE  + "' "
		_cQuery += "  AND D1_LOJA = '" + SF1->F1_LOJA  + "' "
		_cQuery += "  AND D1_FILIAL = '" + xFilial("SD2")  + "' "
		_cQuery += "  AND SD1.D_E_L_E_T_ <> '*' "
		
		If(select("TMPSD1") > 0)
			TMPSD1->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPSD1"
		TcSetField("TMPSD1", "E1_VENCTO"   , "D", 08, 0)
		
		_cNumDI	:= ""
		_dDtDI	:= ctod("  /  /  ")
		do while ! TMPSD1->(eof())
			if ! empty(TMPSD1->F4_FORMULA)
				_cMensagem += trim(formula(TMPSD1->F4_FORMULA)) + ". "
			endif
			_cNumDI	:= TMPSD1->D1__NDI
			_dDtDI	:= TMPSD1->D1__DTDI
			TMPSD1->(dbSkip())
		enddo
		TMPSD1->(dbCloseArea())
		
		_cMensagem += " DESEMB. MERC. " + trim(posicione("Z21",1,xFilial("Z21")+SF1->F1__MSGIMP,"Z21_TEXTO1")) + ". "
		/*
		dbSelectArea("SF1")
		dbSetOrder(1)
		dbSeek(xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
		*/
		_cMensagem += " CF DI No. " + trim(SF1->F1__NUMDI) + " DE " + dtoc(SF1->F1__DTDI) + trim(Z21->Z21_TEXTO2) + ". "
		
		_cMensagem += " VALOR DA MERCADORIA : " + Alltrim(transform(SF1->F1_VALMERC,PesqPict("SF1","F1_VALMERC")))
		_cMensagem += " IPI : " + Alltrim(transform(SF1->F1_VALIPI,PesqPict("SF1","F1_VALIPI")))
		_cMensagem += " PIS/PASEP : " + Alltrim(transform(SF1->F1_VALIMP6,PesqPict("SF1","F1_VALIMP6")))
		_cMensagem += " COFINS : " + Alltrim(transform(SF1->F1_VALIMP5,PesqPict("SF1","F1_VALIMP5")))
		_cMensagem += " DESP.ADUANEIRAS : " + Alltrim(transform(SF1->F1_DESPESA,PesqPict("SF1","F1_DESPESA")))
		_cMensagem += " TOTAL : " + Alltrim(transform(SF1->F1_VALBRUT,PesqPict("SF1","F1_VALBRUT")))
		
		aNfe[cMensFis] += _cMensagem
	endif
	
endif

RETURN aNfe

/*
|-----------------------------------------------------------------------------------------------|
|	Função : MenPad				 		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi     										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : mensagem padrão do campo customizado f4__msgnf								  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function MenPad(_cNumPed)

Local _cQry 	:= ""
Local TMPSF4	:= {}
Local _cMenF4	:= ""

_cQry := "SELECT DISTINCT F4__MSGNF "
_cQry += "FROM " + RetSqlName("SD2") + " SD2 "
_cQry += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_CODIGO = D2_TES AND SF4.D_E_L_E_T_ = ' ' "
/*Mudança na forma de consultar as mensagens - Jorge H. - Fev/2015
_cQry += "INNER JOIN " + RetSqlName("SM4") + " SM4 ON F4__MSGNF = M4_CODIGO AND SM4.D_E_L_E_T_ = ' ' "
_cQry += "Where D2_PEDIDO = '" + _cNumPed + "' "
_cQry += "and D2_FILIAL = '" + xFilial("SD2")  + "' "
_cQry += "and SD2.D_E_L_E_T_ = ' ' And F4__MSGNF <> ' ' "
*/
_cQry += "where D2_FILIAL = '" + xFilial("SD2")  + "' "
_cQry += "  and D2_DOC = '" + SF2->F2_DOC  + "' "
_cQry += "  and D2_SERIE = '" + SF2->F2_SERIE  + "' "
_cQry += "  and SD2.D_E_L_E_T_ = ' ' "

If(select("TMPSF4") > 0)
	TMPSF4->(dbCloseArea())
endif

TCQUERY _cQry NEW ALIAS "TMPSF4"

DbSelectArea("TMPSF4")
DbGoTop()

While !Eof()
	
	If !Empty(TMPSF4->F4__MSGNF)
		If !(AllTrim(TMPSF4->F4__MSGNF) $ _cMenF4)
			_cMenF4	+= AllTrim(TMPSF4->F4__MSGNF) + " - "
		EndIf
	EndIf
	
	DbSelectArea("TMPSF4")
	DbSkip()
	
EndDo

Return _cMenF4
