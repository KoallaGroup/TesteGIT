#include "topconn.ch"

#define CRLF Chr(13)+Chr(10)

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFISR05			  		| 	Julho de 2015									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Relatório em CSV de DCIP							  							|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFISR05()

	local _aArea 	:= GetArea()
 	local _cPerg 	:= "IFISR005"
	local cOptions	:= "1;0;1;Relatório DCIP"

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
		Return
	EndIf

	If(mv_par07 == 1) 
		                                     
	    MsAguarde({|| U_IFISR05A()}, "Processando..","Recuperando informações...")
	    
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

		CallCrys("IFISCR005",cParams,cOptions)
	
	endif

	restArea (_aArea)
return


user function IFISR05A()

	_cQuery := "select 	FT_ENTRADA, "
	_cQuery += "		FT_NFISCAL, "
	_cQuery += "		FT_EMISSAO, "
	_cQuery += "		A2_CGC, "
	_cQuery += "       	A2_INSCR, "
	_cQuery += "       	A2_EST, "
	_cQuery += "       	FT_TIPO, "
	_cQuery += "       	FT_CFOP, "
	_cQuery += "       	FT_VALCONT, "
	_cQuery += "       	D1_BASEICM, "
	_cQuery += "       	D1_PICM, "
	_cQuery += "       	D1_VALICM "
	_cQuery += "from " + retSqlName("SFT") + " SFT "
	_cQuery += "inner join SD1010 SD1 on D1_DOC = FT_NFISCAL "
    _cQuery += "	                 and D1_SERIE = FT_SERIE "
    _cQuery += "	                 and D1_FORNECE = FT_CLIEFOR "
    _cQuery += "	                 and D1_LOJA = FT_LOJA "
    _cQuery += "	                 and D1_ITEM = FT_ITEM "
    _cQuery += "	                 and SD1.D_E_L_E_T_ = ' ' "
	_cQuery += "inner join " + retSqlName("SA2") + " SA2 on A2_COD = FT_CLIEFOR "
	_cQuery += "                     and A2_LOJA = FT_LOJA "
	_cQuery += "                     and SA2.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and A2_SIMPNAC = '1' "
	_cQuery += "inner join " + retSqlName("SB1") + " SB1 ON B1_COD = FT_PRODUTO "
	_cQuery += "                 AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += "where SFT.D_E_L_E_T_ = ' ' "
	_cQuery += "  and FT_FILIAL = '" + mv_par01 + "' "
	_cQuery += "  and FT_ENTRADA >= '" + dtos(mv_par02) +"' "
	_cQuery += "  and FT_ENTRADA <= '" + dtos(mv_par03) +"' "
	_cQuery += "  and B1_COD >= '" + mv_par04 +"' "
	_cQuery += "  and B1_COD <= '" + mv_par05 +"' "
	_cQuery += "  and FT_DTCANC = ' ' "
	_cQuery += "  and FT_TIPOMOV = 'E' "
	if mv_par06 <> '0'
		_cQuery += "  and B1__SEGISP = '" + mv_par06 +"' "
	endif
	
	_cQuery += "UNION ALL "  + CRLF
	
	_cQuery += "select 	FT_ENTRADA, "
	_cQuery += "		FT_NFISCAL, "
	_cQuery += "		FT_EMISSAO, "
	_cQuery += "		A1_CGC as A2_CGC, "
	_cQuery += "       	A1_INSCR as A2_INSCR, "
	_cQuery += "       	A1_EST as A2_EST, "
	_cQuery += "       	FT_TIPO, "
	_cQuery += "       	FT_CFOP, "
	_cQuery += "       	FT_VALCONT, "
	_cQuery += "       	D1_BASEICM, "
	_cQuery += "       	D1_PICM, "
	_cQuery += "       	D1_VALICM "
	_cQuery += "from " + retSqlName("SFT") + " SFT "
	_cQuery += "inner join SD1010 SD1 on D1_DOC = FT_NFISCAL "
    _cQuery += "	                 and D1_SERIE = FT_SERIE "
    _cQuery += "	                 and D1_FORNECE = FT_CLIEFOR "
    _cQuery += "	                 and D1_LOJA = FT_LOJA "
    _cQuery += "	                 and D1_ITEM = FT_ITEM "
    _cQuery += "	                 and SD1.D_E_L_E_T_ = ' ' "
	_cQuery += "inner join " + retSqlName("SA1") + " SA1 on A1_COD = FT_CLIEFOR "
	_cQuery += "                     and A1_LOJA = FT_LOJA "
	_cQuery += "                     and SA1.D_E_L_E_T_ = ' ' "
	_cQuery += "                     and A1_SIMPNAC = '1' "
	_cQuery += "inner join " + retSqlName("SB1") + " SB1 ON B1_COD = FT_PRODUTO "
	_cQuery += "                 AND SB1.D_E_L_E_T_ = ' ' "
	_cQuery += "where SFT.D_E_L_E_T_ = ' ' "
	_cQuery += "  and FT_FILIAL = '" + mv_par01 + "' "
	_cQuery += "  and FT_ENTRADA >= '" + dtos(mv_par02) +"' "
	_cQuery += "  and FT_ENTRADA <= '" + dtos(mv_par03) +"' "
	_cQuery += "  and B1_COD >= '" + mv_par04 +"' "
	_cQuery += "  and B1_COD <= '" + mv_par05 +"' "
	_cQuery += "  and FT_DTCANC = ' ' "
	_cQuery += "  and FT_TIPOMOV = 'E' "
	_cQuery += "  and FT_TIPO = 'D' "
	if mv_par06 <> '0'
		_cQuery += "  and B1__SEGISP = '" + mv_par06 +"' "
	endif
	
	_cQuery += "order by FT_ENTRADA "

	If(select("TMPENTRADA") > 0)
		TMPENTRADA->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPENTRADA" 
	TCSetField("TMPENTRADA","FT_ENTRADA","D")
	TCSetField("TMPENTRADA","FT_EMISSAO","D")
    
	cPath	:= AllTrim(cGetFile( , 'Diretório Destino', 1, 'C:\', .F., nOR(GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. ))

	_cArqTmp:= cPath + "\DCIP_" + mv_par01 + "_" + dtos(mv_par02) + "_" + dtos(mv_par03) + ".csv"

	nHandle := MsfCreate(_cArqTmp,0)

	_linha := "DT entrada;"
	_linha += "NF;"
	_linha += "DT emissão;"
	_linha += "CNPJ;"
	_linha += "I.E;"
	_linha += "UF fornecedor;"
	_linha += "Tipo NF;"
	_linha += "CFOP;"
	_linha += "Valor contábil;"
	_linha += "Base de cálculo;"
	_linha += "Percentual ICMS;"
	_linha += "Valor de ICMS;"

    fWrite(nHandle, _linha + CRLF) 

	do while ! TMPENTRADA->(eof())
		_linha := dtoc(TMPENTRADA->FT_ENTRADA) + ";"
		_linha += TMPENTRADA->FT_NFISCAL + ";"
		_linha += dtoc(TMPENTRADA->FT_EMISSAO) + ";"
		_linha += TMPENTRADA->A2_CGC + ";"
		_linha += TMPENTRADA->A2_INSCR + ";"
		_linha += TMPENTRADA->A2_EST + ";"
		_linha += TMPENTRADA->FT_TIPO + ";"
		_linha += TMPENTRADA->FT_CFOP + ";"
		_linha += strTran(str(TMPENTRADA->FT_VALCONT),'.',',') + ";" 
		_linha += strTran(str(TMPENTRADA->D1_BASEICM),'.',',') + ";"
		_linha += strTran(str(TMPENTRADA->D1_PICM),'.',',') + ";"
		_linha += strTran(str(TMPENTRADA->D1_VALICM),'.',',') + ";"

		fWrite(nHandle, _linha + CRLF) 

		TMPENTRADA->(dbSkip())
	enddo
	fClose(nHandle)                                                  
	
	msgAlert("Relatório " + cPath + "DCIP_" + mv_par01 + "_" + dtos(mv_par02) + "_" + dtos(mv_par03) +  ".csv, gerado com sucesso !!")
        
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