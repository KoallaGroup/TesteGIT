#include "topconn.ch"

#define CRLF Chr(13)+Chr(10)

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFISR04			  		| 	Julho de 2015									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório em CSV de Fretes							  							|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFISR04()

	local _aArea 	:= GetArea()
 	local _cPerg 	:= "IFISR004"
	local cOptions	:= "1;0;1;ICMS sobre Frete de Importados"

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
		Return
	EndIf
    
	if mv_par07 == 1
	
	    MsAguarde({|| U_IFISR04A()}, "Processando..","Recuperando informações...")
	    
	else

		cParams := MV_PAR01 + 			";" //Filial
		cParams += DTOS(MV_PAR02) +	    ";" //Entrada De        	
		cParams += DTOS(MV_PAR03)	+   ";" //Saída Ate   
		cParams += MV_PAR04 + 			";" //Produto De
		cParams += MV_PAR05 + 			";" //Produto Ate
		if trim(MV_PAR06) == '0'
			cParams += "('1','2')" +	";" //Segmento
		else			
			cParams += "('" + trim(MV_PAR06) + "')" + ";" //Segmento
		endif	

		CallCrys("IFISCR004",cParams,cOptions)
	
	endif

	restArea (_aArea)
return


user function IFISR04A()

	cPath	:= AllTrim(cGetFile( , 'Diretório Destino', 1, 'C:\', .F., nOR(GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. ))

	_cArqTmp:= cPath + "\fretes_" + mv_par01 + ".csv"

	nHandle := MsfCreate(_cArqTmp,0)

	_cQuery := "select GWM_SEQGW8, "
	_cQuery += "       FT_NFISCAL, "
	_cQuery += "       FT_SERIE, "
	_cQuery += "       SA2.A2_NOME, "
	_cQuery += "       SA2.A2_INSCR, "
	_cQuery += "       SA2.A2_CGC, "
	_cQuery += "       GWM_DTEMIS, "
	_cQuery += "       FT_ENTRADA, "
	_cQuery += "       GWM_VLFRE1 * (Z11_QTDEUT / D2_QUANT * 100) / 100 AS GWM_VLFRET,"
	_cQuery += "       GWM_VLICM1 * (Z11_QTDEUT / D2_QUANT * 100) / 100 AS GWM_VLICMS,"
	_cQuery += "       GWM_NRDC, "
	_cQuery += "       FT_EMISSAO, "
	_cQuery += "       (B1_POSIPI || YD_DESC_P) DESCITEM, "
	_cQuery += "        B1_ORIGEM,"
	_cQuery += "       ZE_NOMECOM, "
	_cQuery += "       (ZE_INSC || ZE_CGC) INSC_GCG, "
	_cQuery += "       SA2_1.A2_EST "
	
	_cQuery += "from SFT010 SFT "
	
	_cQuery += "inner join SZE010 SZE on ZE_CODFIL = FT_FILIAL "
	_cQuery += "                     and SZE.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SA2010 SA2 ON SA2.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and A2_COD = FT_CLIEFOR "
	_cQuery += "                     and A2_LOJA = FT_LOJA "
	
	_cQuery += "inner join GWM010 GWM ON FT_FILIAL = GWM_FILIAL "
	_cQuery += "                     AND FT_NFISCAL = GWM_NRDOC "
	_cQuery += "                     AND FT_SERIE = GWM_SERDOC "
	_cQuery += "                     AND GWM.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SB1010 SB1 ON B1_COD = GWM_ITEM "
	_cQuery += "                 AND SB1.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SYD010 SYD ON YD_TEC = B1_POSIPI "
	_cQuery += "                 AND SYD.D_E_L_E_T_ = ' ' "

	_cQuery += " join Z11010 Z11 ON Z11_FILIAL = GWM_FILIAL "
	_cQuery += "                     and Z11_DOCSAI = GWM_NRDC "
	_cQuery += "                     and Z11_SERSAI = GWM_SERDC "
	_cQuery += "                     and Z11_CODPRO = GWM_ITEM "
	_cQuery += "                     and Z11.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and Z11.Z11_ITEMSA = GWM_SEQGW8 "

	_cQuery += " join SF1010 SF1 ON  Z11_DOCENT = F1_DOC "
	_cQuery += "                     and Z11_SERENT = F1_SERIE "
	_cQuery += "                     and Z11_FORNEC = F1_FORNECE "
	_cQuery += "                     and Z11_LOJA = F1_LOJA "
	_cQuery += "                     and Z11_FILIAL = F1_FILIAL "
	_cQuery += "                     and SF1.D_E_L_E_T_ = ' ' "
	                     
	_cQuery += " join SD2010 SD2 ON D2_FILIAL = Z11_FILIAL "
	_cQuery += "                     and D2_DOC = Z11_DOCSAI "
	_cQuery += "                     and D2_SERIE = Z11_SERSAI "
	_cQuery += "                     and D2_CLIENTE = Z11_CLIENT "
	_cQuery += "                     and D2_ITEM = Z11_ITEMSA "
	_cQuery += "                     and SD2.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SA2010 SA2_1 ON SA2_1.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and SA2_1.A2_COD = F1_FORNECE "
	_cQuery += "                     and SA2_1.A2_LOJA = F1_LOJA "

	_cQuery += "where SFT.D_E_L_E_T_ = ' ' "
	_cQuery += "  and FT_FILIAL = '" + mv_par01 + "' "
	_cQuery += "  and FT_CFOP IN ('1353', '2353') "
	_cQuery += "  and FT_ENTRADA >= '" + dtos(mv_par02) +"' "
	_cQuery += "  and FT_ENTRADA <= '" + dtos(mv_par03) +"' "
	_cQuery += "  and B1_COD >= '" + mv_par04 +"' "
	_cQuery += "  and B1_COD <= '" + mv_par05 +"' "
	_cQuery += "  and FT_DTCANC = ' ' "
	_cQuery += "  and SA2_1.A2_EST is not null "
	if mv_par06 <> '0'
		_cQuery += "  and B1__SEGISP = '" + mv_par06 +"' "
	endif                            
	
	_cQuery	+= "UNION ALL "
	
	_cQuery += "select GWM_SEQGW8, "
	_cQuery += "       FT_NFISCAL, "
	_cQuery += "       FT_SERIE, "
	_cQuery += "       SA2.A2_NOME, "
	_cQuery += "       SA2.A2_INSCR, "
	_cQuery += "       SA2.A2_CGC, "
	_cQuery += "       GWM_DTEMIS, "
	_cQuery += "       FT_ENTRADA, "
	_cQuery += "       GWM_VLFRE1, "
	_cQuery += "       GWM_VLICM1, "
	_cQuery += "       GWM_NRDC, "
	_cQuery += "       FT_EMISSAO, "
	_cQuery += "       (B1_POSIPI || YD_DESC_P) DESCITEM, "
	_cQuery += "        B1_ORIGEM,"
	_cQuery += "       ZE_NOMECOM, "
	_cQuery += "       (ZE_INSC || ZE_CGC) INSC_GCG, "
	_cQuery += "       SA2_1.A2_EST "
	
	_cQuery += "from SFT010 SFT "
	
	_cQuery += "inner join SZE010 SZE on ZE_CODFIL = FT_FILIAL "
	_cQuery += "                     and SZE.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SA2010 SA2 ON SA2.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and A2_COD = FT_CLIEFOR "
	_cQuery += "                     and A2_LOJA = FT_LOJA "
	
	_cQuery += "inner join GWM010 GWM ON FT_FILIAL = GWM_FILIAL "
	_cQuery += "                     AND FT_NFISCAL = GWM_NRDOC "
	_cQuery += "                     AND FT_SERIE = GWM_SERDOC "
	_cQuery += "                     AND GWM.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SB1010 SB1 ON B1_COD = GWM_ITEM "
	_cQuery += "                 AND SB1.D_E_L_E_T_ = ' ' "
	
	_cQuery += "inner join SYD010 SYD ON YD_TEC = B1_POSIPI "
	_cQuery += "                 AND SYD.D_E_L_E_T_ = ' ' "

	_cQuery += "left join Z11010 Z11 ON Z11_FILIAL = GWM_FILIAL "
	_cQuery += "                     and Z11_DOCSAI = GWM_NRDC "
	_cQuery += "                     and Z11_SERSAI = GWM_SERDC "
	_cQuery += "                     and Z11_CODPRO = GWM_ITEM "
	_cQuery += "                     and Z11.D_E_L_E_T_ = ' ' "         
	_cQuery += "                     and Z11.Z11_ITEMSA = GWM_SEQGW8 "

	_cQuery += "left join SF1010 SF1 ON  Z11_DOCENT = F1_DOC "
	_cQuery += "                     and Z11_SERENT = F1_SERIE "
	_cQuery += "                     and Z11_FORNEC = F1_FORNECE "
	_cQuery += "                     and Z11_LOJA = F1_LOJA "
	_cQuery += "                     and Z11_FILIAL = F1_FILIAL "
	_cQuery += "                     and SF1.D_E_L_E_T_ = ' ' "
	                     
	_cQuery += "left join SD2010 SD2 ON D2_FILIAL = Z11_FILIAL "
	_cQuery += "                     and D2_DOC = Z11_DOCSAI "
	_cQuery += "                     and D2_SERIE = Z11_SERSAI "
	_cQuery += "                     and D2_CLIENTE = Z11_CLIENT "
	_cQuery += "                     and D2_ITEM = Z11_ITEMSA "
	_cQuery += "                     and SD2.D_E_L_E_T_ = ' ' "
	
	_cQuery += "left join SA2010 SA2_1 ON SA2_1.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and SA2_1.A2_COD = F1_FORNECE "
	_cQuery += "                     and SA2_1.A2_LOJA = F1_LOJA "

	_cQuery += "where SFT.D_E_L_E_T_ = ' ' "
	_cQuery += "  and FT_FILIAL = '" + mv_par01 + "' "
	_cQuery += "  and FT_CFOP IN ('1353', '2353') "
	_cQuery += "  and FT_ENTRADA >= '" + dtos(mv_par02) +"' "
	_cQuery += "  and FT_ENTRADA <= '" + dtos(mv_par03) +"' "
	_cQuery += "  and B1_COD >= '" + mv_par04 +"' "
	_cQuery += "  and B1_COD <= '" + mv_par05 +"' "
	_cQuery += "  and FT_DTCANC = ' ' "
	_cQuery += "  and SA2_1.A2_EST is null "
	if mv_par06 <> '0'
		_cQuery += "  and B1__SEGISP = '" + mv_par06 +"' "
	endif	
	
	_cQuery += "order by FT_ENTRADA "

	If(select("TMPENTRADA") > 0)
		TMPENTRADA->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPENTRADA" 
	TCSetField("TMPENTRADA","GWM_DTEMIS","D")
	TCSetField("TMPENTRADA","FT_ENTRADA","D")
	TCSetField("TMPENTRADA","FT_EMISSAO","D")
		                                     
	_linha := "Nr. Conhecimento;"
	_linha += "Série;
	_linha += "Razão Social do Emitente;"
	_linha += "Insc. Est. Emitente;"
	_linha += "CNPJ do Emitente;"
	_linha += "Data Emissão;"
	_linha += "Data Escrituração;"
	_linha += "Base de ICMS;"
	_linha += "Valor de ICMS;"
	_linha += "Nota Fiscal Referenciada;"
	_linha += "Data Emissão;"
	_linha += "Mercadoria (NCM);"
	_linha += "Origem;"
	_linha += "Fornecedor;"
	_linha += "Inscr. Estadual e CNPJ;"
	_linha += "Estado"

    fWrite(nHandle, _linha + CRLF) 
	
	do while ! TMPENTRADA->(eof())

		_linha := TMPENTRADA->FT_NFISCAL + ";"
		_linha += TMPENTRADA->FT_SERIE + ";"
		_linha += TMPENTRADA->A2_NOME + ";"
		_linha += TMPENTRADA->A2_INSCR + ";"
		_linha += TMPENTRADA->A2_CGC + ";"
		_linha += dtoc(TMPENTRADA->GWM_DTEMIS) + ";"
		_linha += dtoc(TMPENTRADA->FT_ENTRADA) + ";"
		_linha += strTran(str(TMPENTRADA->GWM_VLFRET),'.',',') + ";" 
		_linha += strTran(str(TMPENTRADA->GWM_VLICMS),'.',',') + ";"
		_linha += TMPENTRADA->GWM_NRDC + ";" 
		_linha += dtoc(TMPENTRADA->FT_EMISSAO) + ";"
		_linha += TMPENTRADA->DESCITEM + ";"
		_linha += TMPENTRADA->B1_ORIGEM + ";"
		_linha += TMPENTRADA->ZE_NOMECOM + ";"
		_linha += TMPENTRADA->INSC_GCG + ";"
		_linha += TMPENTRADA->A2_EST 

		fWrite(nHandle, _linha + CRLF) 

		TMPENTRADA->(dbSkip())
	enddo
	fClose(nHandle)                                                  
	
	msgAlert("Relatório " + cPath + "fretes_" + mv_par01 + ".csv, gerado com sucesso !!")
        
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	
	PutSx1(_cPerg,"01","Filial :"					," "," ","mv_ch1","C",02,0,0,"G","" ,"SM0","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"02","a Partir Data de Movimento"	," "," ","mv_ch2","D",08,0,0,"G","" ,"","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"03","ate a Data de Movimento"	," "," ","mv_ch3","D",08,0,0,"G","" ,"","","","mv_par03","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"04","a Partir do Item"			," "," ","mv_ch4","C",15,0,0,"G","" ,"SB1","","","mv_par04","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"05","ate o Item"					," "," ","mv_ch5","C",15,0,0,"G","" ,"SB1","","","mv_par05","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"06","Segmento"					," "," ","mv_ch6","C",02,0,0,"G","" ,"SZ7","","","mv_par06","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSX1(_cPerg,"07","Tipo Relatorio"				," "," ","mv_ch7","C",99,0,1,"C","","","","","mv_par07","Planilha CSV","Planilha CSV","Planilha CSV","","Crystal Reports","Crystal Reports","Crystal Reports","","","","","","","","","","")

	RestArea (_aArea)

Return(_cPerg)