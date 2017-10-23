#include "topconn.ch"

#define CRLF Chr(13)+Chr(10)

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFISA02			  		| 	Agosto de 2014									  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : REOA - Exportação de TXT para Notas de Entrada		  							|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFISA02()
	    
	local _aArea 		:= GetArea()
 	local _cPerg 		:= "IFISA02"
	local _cEstadoFilial:= ""
   	local _cOrigens		:= formatIn(getMV("MV__ORIREO"),',')	// parâmetro exclusivo
   	local _cSegtos		:= formatIn(getMV("MV__SEGREO"),',')	// parâmetro exclusivo
	Local cOptions 		:= "1;0;1;Relatório Analitico REOA"
	Local cParams 		:= ""

	AjustSX1(_cPerg)

	If !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
		Return
	EndIf

	dbSelectArea("SM0")
	_nRecSM0 := SM0->(recno())
	               
	SM0->(dbGotop())
	Do While ! Eof()                                                     
		if SM0->M0_CODFIL == mv_par01
			_cEstadoFilial := SM0->M0_ESTENT
			exit
		endif
		dbSkip()
	EndDo
   	go _nRecSM0 

	If(mv_par07 < 4) 
		_cQuery := "SELECT DISTINCT	D1__BSREOA, "
		_cQuery += "		D1__VLREOA, "
		_cQuery += "		Z12_RECSD1, " 
		_cQuery += "		Z12.R_E_C_N_O_ RECZ12, "   
		_cQuery += "		Z12_SERIE, "
		_cQuery += "		D1_FILIAL FILIAL, "
		_cQuery += "		D1_ITEM, "
		_cQuery += "		B1_COD, "
		_cQuery += "		A2_CGC, " 
		_cQuery += "		B1_DESC, " 
		_cQuery += "		A2_EST, " 
		_cQuery += "		D1_DOC, " 
		_cQuery += "		D1_SERIE, " 
		_cQuery += "		D1_EMISSAO, "  
		_cQuery += "		D1_FORNECE, "  
		_cQuery += "		D1_LOJA, "  
		_cQuery += "		D1_QUANT, " 
		_cQuery += "		B1_UM, "
		_cQuery += "		D1_BASEICM, "
		_cQuery += "		D1_QUANT, "
		_cQuery += "		D1_PICM, "
		_cQuery += "		D1_VALICM, "
		_cQuery += "		D1_IPI, "
		_cQuery += "		D1_VALIPI, "
		_cQuery += "		D1_DESPESA, "
		_cQuery += "		D1_VALFRE "
		_cQuery += "FROM " + retSqlname("Z11") + " Z11 "

		_cQuery += "INNER JOIN " + retSqlname("SB1") + " SB1 ON B1_COD = Z11_CODPRO "
		_cQuery += " 										AND SB1.D_E_L_E_T_ <> '*' "

		_cQuery += "INNER JOIN " + retSqlname("SD2") + " SD2 ON Z11_DOCSAI = D2_DOC "
		_cQuery += " 										AND Z11_SERSAI = D2_SERIE "
		_cQuery += " 										AND Z11_FILIAL = D2_FILIAL "
		_cQuery += " 										AND Z11_ITEMSA = D2_ITEM "
		_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' "

		_cQuery += "INNER JOIN " + retSqlname("Z12") + " Z12 ON Z12_DOC = Z11_DOCENT "
		_cQuery += " 										AND Z12_SERIE = Z11_SERENT "
		_cQuery += " 										AND Z12_FILIAL = Z11_FILIAL "
		_cQuery += " 										AND Z12_ITEM = Z11_ITEMEN "
		_cQuery += " 										AND Z12_FORNEC = Z11_FORNEC "
		_cQuery += " 										AND Z12_LOJA = Z11_LOJA "
		_cQuery += " 										AND Z12.D_E_L_E_T_ <> '*' "

		_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON Z11_DOCENT = D1_DOC "
		_cQuery += " 										AND Z11_SERENT = D1_SERIE "
		_cQuery += " 										AND Z11_FILIAL = D1_FILIAL "
		_cQuery += " 										AND Z11_ITEMEN = D1_ITEM "
		_cQuery += " 										AND Z11_FORNEC = D1_FORNECE "
		_cQuery += " 										AND Z11_LOJA = D1_LOJA "
		_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' " 
		
		_cQuery += "INNER JOIN " + retSqlname("SA2") + " SA2 ON A2_COD = D1_FORNECE "
		_cQuery += " 										AND A2_LOJA = D1_LOJA "
		_cQuery += " 										AND SA2.D_E_L_E_T_ <> '*' "
		
		_cQuery += "WHERE D2_EMISSAO >= '" + dtos(mv_par02)  + "' "
		_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' "
		_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' "
		_cQuery += "  AND D2_COD >= '" + mv_par04  + "' "
		_cQuery += "  AND D2_COD <= '" + mv_par05  + "' "
		_cQuery += "  AND B1__SEGISP IN " + _cSegtos  + " "
		_cQuery += "  AND SD2.D_E_L_E_T_ = ' ' "
	
		If(select("TMPENTRADA") > 0)
			TMPENTRADA->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPENTRADA" 
		TCSetField("TMPENTRADA","D1_EMISSAO","D")
	endif
		
	If(mv_par07 < 3) //Rubens Cruz - Geração de relatorio Analitico em Crystal
		do while ! TMPENTRADA->(eof())
		
		    if TMPENTRADA->Z12_SERIE <> 'SD3'                      

				_nBaseReoa	:= TMPENTRADA->D1__BSREOA
				_nValorReoa	:= TMPENTRADA->D1__VLREOA
				
			    if _nBaseReoa == 0           
			    	dbSelectArea("SD1")
			    	go TMPENTRADA->Z12_RECSD1
			    
					_nValReoa 	:= U_IFISA03A("E")
		
					if len(_nValReoa) > 2
						_nBaseReoa	:= _nValReoa[1]
						_nValorReoa	:= _nValReoa[2]
		
					   	dbSelectArea("SD1")
				    	go TMPENTRADA->Z12_RECSD1
						if reclock("SD1", .F.)							
							SD1->D1__BSREOA	:= _nBaseReoa
							SD1->D1__VLREOA	:= _nValorReoa 
						endif
						msUnlock()					
					endif
			    endif
			endif
				
			TMPENTRADA->(dbSkip())
		enddo                    

		cParams := Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC")) + ";" //CNPJ ISAPA
		cParams += SM0->M0_INSC + 		";" //Inscrição Estadual ISAPA
		cParams += MV_PAR01 + 			";" //Filial
		cParams += MV_PAR04 + 			";" //Produto De
		cParams += MV_PAR05 + 			";" //Produto Ate
		cParams += DTOS(MV_PAR02) +	    ";" //Emissao De        	
		cParams += DTOS(MV_PAR03)	+   ";" //Emissao Ate   
		cParams += MV_PAR06 + 			";" //Segmento
		cParams += _cEstadoFilial			 //Estado ISAPA
		
		If(MV_PAR07 == 1)
			CallCrys("IFISCR03",cParams,cOptions)
		Else
			CallCrys("IFISCR04",cParams,cOptions)
      	EndIf
      
	Elseif MV_PAR07 == 3
		// ARQUIVO COM NOTAS DE ENTRADA
	    
		 cPath	:= AllTrim(cGetFile( , 'Diretório Destinos', 1, 'C:\', .F., nOR(GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. ))

		_cArqTmp:= cPath + "\entrada_" + _cEstadoFilial + ".csv"
	
		nHandle := MsfCreate(_cArqTmp,0)
	
		if _cEstadoFilial == "SC"
			_linha := "MES_REF.;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;BASE ICMS;ALIQ. ICMS;VLR ICMS;ALIQ. IPI; VLR IPI;DESPESAS;FRETE"
        else
			_linha := "MES_REF.;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;UNIDADE;BASE;ICMS;BCR;ICMSR;BCR UNIT;ICMSR UNIT"
		endif
		fWrite(nHandle, _linha + CRLF) 
	
		do while ! TMPENTRADA->(eof())
			if _cEstadoFilial == "SC"

				_linha := substr(dtoc(TMPENTRADA->D1_EMISSAO), 4,2) + "/" + substr(dtoc(TMPENTRADA->D1_EMISSAO), 7,4) + ";"
				_linha += TMPENTRADA->B1_COD + ";"
				_linha += TMPENTRADA->B1_DESC + ";"
				_linha += TMPENTRADA->A2_CGC + ";"
				_linha += TMPENTRADA->A2_EST + ";"
				_linha += TMPENTRADA->D1_DOC + ";"
				_linha += dtoc(TMPENTRADA->D1_EMISSAO) + ";"
				_linha += str(TMPENTRADA->D1_QUANT) + ";"
				_linha += strTran(str(TMPENTRADA->D1_BASEICM),'.',',') + ";" 
				_linha += strTran(str(TMPENTRADA->D1_VALICM),'.',',') + ";"
				_linha += strTran(str(TMPENTRADA->D1_PICM),'.',',') + ";" 
				_linha += strTran(str(TMPENTRADA->D1_VALIPI),'.',',') + ";"
				_linha += strTran(str(TMPENTRADA->D1_IPI),'.',',') + ";"
				_linha += strTran(str(TMPENTRADA->D1_DESPESA),'.',',') + ";"
				_linha += strTran(str(TMPENTRADA->D1_VALFRE),'.',',') + ";"

				fWrite(nHandle, _linha + CRLF) 
    
			else

		    	dbSelectArea("SB1")
		    	dbSetOrder(1)
		    	dbSeek(xFilial("SB1")+TMPENTRADA->B1_COD)

		    	dbSelectArea("SD1")
		    	dbSetOrder(1)
		    	dbSeek(TMPENTRADA->FILIAL+TMPENTRADA->D1_DOC+TMPENTRADA->D1_SERIE+TMPENTRADA->D1_FORNECE+TMPENTRADA->D1_LOJA+TMPENTRADA->B1_COD+TMPENTRADA->D1_ITEM)
		    
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(TMPENTRADA->FILIAL+SD1->D1_TES)

				_nBaseReoa	:= TMPENTRADA->D1__BSREOA
				_nValorReoa	:= TMPENTRADA->D1__VLREOA

			    if _nBaseReoa == 0           
				    if TMPENTRADA->Z12_SERIE <> 'SD3'                      
				    	dbSelectArea("SD1")
				    	go TMPENTRADA->Z12_RECSD1
				    
						_nValReoa 	:= U_IFISA03A("E")
			
						_nBaseReoa	:= _nValReoa[1]
						_nValorReoa	:= _nValReoa[2]
	
					   	dbSelectArea("SD1")
				    	go TMPENTRADA->Z12_RECSD1
						if reclock("SD1", .F.)							
							SD1->D1__BSREOA	:= _nBaseReoa
							SD1->D1__VLREOA	:= _nValorReoa 
						endif
						msUnlock()					
	
					   	dbSelectArea("Z12")
				    	go TMPENTRADA->RECZ12
						if reclock("Z12", .F.)							
	//						Z12->Z12_MVA	:= _nValReoa[4]
	//						Z12->Z12_ALQINT	:= _nValReoa[6]
						endif
						msUnlock()					
					endif
			    endif
				
			    if _nBaseReoa > 0           
					_linha := substr(dtoc(TMPENTRADA->D1_EMISSAO), 4,2) + "/" + substr(dtoc(TMPENTRADA->D1_EMISSAO), 7,4) + ";"
					_linha += TMPENTRADA->B1_COD + ";"
					_linha += TMPENTRADA->B1_DESC + ";"
					_linha += TMPENTRADA->A2_CGC + ";"
					_linha += TMPENTRADA->A2_EST + ";"
					_linha += TMPENTRADA->D1_DOC + ";"
					_linha += dtoc(TMPENTRADA->D1_EMISSAO) + ";"
					_linha += str(TMPENTRADA->D1_QUANT) + ";"
					_linha += TMPENTRADA->B1_UM + ";"
					_linha += strTran(str(TMPENTRADA->D1_BASEICM),'.',',') + ";"
					_linha += strTran(str(TMPENTRADA->D1_VALICM),'.',',') + ";"
					_linha += strTran(str(_nBaseReoa),'.',',') + ";"
					_linha += strTran(str(_nValorReoa),'.',',') + ";"
					_linha += strTran(str(round(_nBaseReoa / TMPENTRADA->D1_QUANT,2)),'.',',') + ";"
					_linha += strTran(str(round(_nValorReoa / TMPENTRADA->D1_QUANT,2)),'.',',') + ";"
			
					fWrite(nHandle, _linha + CRLF) 
				endif
						     
			endif

			TMPENTRADA->(dbSkip())
		enddo
		fClose(nHandle)                                                  
	        
		// ARQUIVO COM NOTAS DE SAIDA INTERNA
	
		_cArqTmp:= cPath + "\nfsaida_interna_" + _cEstadoFilial + ".csv"
	
		nHandle := MsfCreate(_cArqTmp,0)
	    
		_cQuery := "SELECT 	SUM (D1__BSREOA) D1__BSREOA, " + Chr(13)
		_cQuery += "		SUM (D1__VLREOA) D1__VLREOA, " + Chr(13)
		_cQuery += "		SUM (Z11_BSREOA) Z11_BSREOA, " + Chr(13)
		_cQuery += "		SUM (Z11_VLREOA) Z11_VLREOA, "		 + Chr(13)
		_cQuery += "		MAX (Z11_DOCENT) Z11_DOCENT, " + Chr(13)
		_cQuery += "		MAX (Z11_SERENT) Z11_SERENT, " + Chr(13)
		_cQuery += "		MAX (Z11_FORNEC) Z11_FORNEC, " + Chr(13)
		_cQuery += "		MAX (Z11_LOJA) Z11_LOJA, " + Chr(13)
		_cQuery += "		MAX (Z11_DOCSAI) Z11_DOCSAI, " + Chr(13)
		_cQuery += "		MAX (Z11_SERSAI) Z11_SERSAI, " + Chr(13)
		_cQuery += "		MAX (Z11_CLIENT) Z11_CLIENT, " + Chr(13)
		_cQuery += "		MAX (Z11_LOJACL) Z11_LOJACL, " + Chr(13)
		_cQuery += "		MAX (Z11_CODPRO) Z11_CODPRO, " + Chr(13)
		_cQuery += "		MAX (Z11_ITEMEN) Z11_ITEMEN, " + Chr(13)
		_cQuery += "		MAX (Z11_ITEMSA) Z11_ITEMSA, " + Chr(13)
		_cQuery += "		SUM (Z11_ICMENT) Z11_ICMENT, " + Chr(13)
		_cQuery += "		MAX (Z11.R_E_C_N_O_) RECZ11, " + Chr(13)
		_cQuery += " 		MAX (D2_EMISSAO) D2_EMISSAO, " + Chr(13)
		_cQuery += "		MAX (D2_FILIAL) FILIAL, " + Chr(13)
		_cQuery += "		MAX (B1_COD) B1_COD, " + Chr(13)
		_cQuery += "		MAX (B1_POSIPI) B1_POSIPI, " + Chr(13)
		_cQuery += "		MAX (B1_DESC) B1_DESC, " + Chr(13)
		_cQuery += "		MAX (B1_GRUPO) B1_GRUPO, " + Chr(13)
		_cQuery += "		MAX (B1__SEGISP) B1__SEGISP, " + Chr(13)
		_cQuery += "		MAX (D2_CF) D2_CF, " + Chr(13)
		_cQuery += "		MAX (A1_CGC) A1_CGC, " + Chr(13)
		_cQuery += "		MAX (A1_EST) A1_EST, " + Chr(13)
		_cQuery += "		MAX (D2_DOC) D2_DOC, " + Chr(13)
		_cQuery += "		MAX (D2_QUANT) D2_QUANT, " + Chr(13)
		_cQuery += "		MAX (B1_UM) B1_UM, " + Chr(13)
		_cQuery += "		MAX (D2_BASEICM) D2_BASEICM, " + Chr(13)
		_cQuery += "		MAX (D2_VALICM) D2_VALICM, " + Chr(13)
		_cQuery += "		MAX (D2_PICM) D2_PICM, " + Chr(13)
		_cQuery += "		MAX (D2_VALIPI) D2_VALIPI, " + Chr(13)
		_cQuery += "		MAX (D2_TOTAL) D2_TOTAL, " + Chr(13)
		_cQuery += "		MAX (D2_VALFRE) D2_VALFRE, " + Chr(13)
		_cQuery += "		MAX (D2_DESPESA) D2_DESPESA, " + Chr(13)
		_cQuery += "		MAX (D1_QUANT) D1_QUANT " + Chr(13)
		_cQuery += "FROM " + retSqlname("SD2") + " SD2 " + Chr(13)
 		_cQuery += "INNER JOIN " + retSqlname("SF2") + " SF2 ON F2_DOC = D2_DOC " + Chr(13)
		_cQuery += " 										AND F2_SERIE = D2_SERIE " + Chr(13)
		_cQuery += " 										AND SF2.D_E_L_E_T_ <> '*' " + Chr(13)
		_cQuery += "INNER JOIN " + retSqlname("Z11") + " Z11 ON Z11_DOCSAI = D2_DOC " + Chr(13)
		_cQuery += " 										AND Z11_SERSAI = D2_SERIE " + Chr(13)
		_cQuery += " 										AND Z11_FILIAL = D2_FILIAL " + Chr(13)
		_cQuery += " 										AND Z11_ITEMSA = D2_ITEM " + Chr(13)
		_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' " + Chr(13)
		_cQuery += "INNER JOIN " + retSqlname("SB1") + " SB1 ON B1_COD = D2_COD " + Chr(13)
		_cQuery += " 										AND SB1.D_E_L_E_T_ <> '*' " + Chr(13)
		_cQuery += "INNER JOIN " + retSqlname("SA1") + " SA1 ON A1_COD = Z11_CLIENT " + Chr(13)
		_cQuery += " 										AND A1_LOJA = Z11_LOJACL " + Chr(13)
		_cQuery += " 										AND SA1.D_E_L_E_T_ <> '*' " + Chr(13)
		_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON D1_DOC = Z11_DOCENT " + Chr(13)
		_cQuery += " 										AND D1_SERIE = Z11_SERENT " + Chr(13)
		_cQuery += " 										AND D1_FORNECE = Z11_FORNEC " + Chr(13)
		_cQuery += " 										AND D1_LOJA = Z11_LOJA " + Chr(13)
		_cQuery += " 										AND D1_ITEM = Z11_ITEMEN " + Chr(13)
		_cQuery += " 										AND D1_FILIAL = Z11_FILIAL " + Chr(13)
		_cQuery += " 										AND SD1.D_E_L_E_T_ <> '*' " + Chr(13)
		_cQuery += "WHERE D2_EMISSAO >= '" + dtos(mv_par02)  + "' " + Chr(13)
		_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' " + Chr(13)
		_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' " + Chr(13)
		_cQuery += "  AND D2_COD >= '" + mv_par04  + "' " + Chr(13)
		_cQuery += "  AND D2_COD <= '" + mv_par05  + "' " + Chr(13)
		_cQuery += "  AND F2_EST = '" + _cEstadoFilial + "' " + Chr(13)
		_cQuery += "  AND SD2.D_E_L_E_T_ = ' ' " + Chr(13)
		_cQuery += "  AND B1__SEGISP IN " + _cSegtos  + " "
//		_cQuery += "GROUP BY D2_DOC, B1_COD"
		_cQuery += "GROUP BY D2_DOC, B1_COD, D1_DOC, D1_ITEM"
		
		If(select("TMPSAIDA") > 0)
			TMPSAIDA->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPSAIDA" 
		TCSetField("TMPSAIDA","D2_EMISSAO","D")

		if _cEstadoFilial == "SC"
			_linha := "MES_REF.;CFOP;SEGMENTO;GRUPO;NCM;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;BASE;% ICMS;ICMS;VLR IPI;ICMS PROP.;BSR;ICMSR"
        else
			_linha := "MES_REF.;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;UNIDADE;BASE;ICMS;BCR;ICMSR"
		endif		
		fWrite(nHandle, _linha + CRLF) 
	
		do while ! TMPSAIDA->(eof())
//			if _cEstadoFilial == "SC"
				_nBaseReoa	:= TMPSAIDA->Z11_BSREOA
				_nValorReoa	:= TMPSAIDA->Z11_VLREOA
				_nIcmProp	:= TMPSAIDA->Z11_ICMENT
//			else
//				_nBaseReoa	:= 0 // TMPSAIDA->D1__BSREOA
//				_nValorReoa	:= 0 // TMPSAIDA->D1__VLREOA
//			endif
			
		    if _nBaseReoa >= 0           

		    	dbSelectArea("Z12")
		    	dbSetOrder(1)
		    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCENT+TMPSAIDA->Z11_SERENT+TMPSAIDA->Z11_FORNEC+TMPSAIDA->Z11_LOJA+TMPSAIDA->Z11_CODPRO)
		    
			    if Z12->Z12_SERIE <> 'SD3'                      
	    
			    	dbSelectArea("SB1")
			    	dbSetOrder(1)
			    	dbSeek(xFilial("SB1")+TMPSAIDA->Z11_CODPRO)
	
			    	dbSelectArea("SD1")
			    	dbSetOrder(1)
			    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCENT+TMPSAIDA->Z11_SERENT+TMPSAIDA->Z11_FORNEC+TMPSAIDA->Z11_LOJA+TMPSAIDA->Z11_CODPRO+TMPSAIDA->Z11_ITEMEN)
			    
			    	dbSelectArea("SD2")
			    	dbSetOrder(3)
			    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCSAI+TMPSAIDA->Z11_SERSAI+TMPSAIDA->Z11_CLIENT+TMPSAIDA->Z11_LOJACL+TMPSAIDA->Z11_CODPRO+TMPSAIDA->Z11_ITEMSA)
	
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(TMPSAIDA->FILIAL+SD2->D2_TES)
	
					dbSelectArea("SA1")
					dbSetOrder(1)
					dbSeek(xFilial("SA1")+TMPSAIDA->Z11_CLIENT+TMPSAIDA->Z11_LOJACL)
			    	
					dbSelectArea("SM0")		    	
					_nRecSM0 := SM0->(recno())
					SM0->(dbGotop())
					do while ! SM0->(eof())
						if SM0->M0_CODFIL == TMPSAIDA->FILIAL
							exit
						endif			
						SM0->(dbSkip())
					enddo				

					dbSelectArea("Z11")
					go TMPSAIDA->RECZ11                 
		    
	   				_nValReoa := U_IFISA03A("S")
					
					dbSelectArea("SM0")		    	
					go _nRecSM0 
		            
					if len(_nValReoa) > 2
						_nBaseReoa	:= _nValReoa[1]
						_nValorReoa	:= _nValReoa[2]
						_nIcmProp	:= _nValReoa[3]
	
						dbSelectArea("Z11")
						go TMPSAIDA->RECZ11                 
						if reclock("Z11", .F.)
							Z11->Z11_VLREOA	:= _nValReoa[2]
							Z11->Z11_BSREOA	:= _nValReoa[1]
							Z11->Z11_ICMENT	:= _nValReoa[3]
							Z11->Z11_MVA	:= _nValReoa[4]
							Z11->Z11_VA		:= _nValReoa[5]
							Z11->Z11_ALQINT	:= _nValReoa[6]
							msUnlock()
						endif		
					endif
				endif
		    endif
			
			if _nBaseReoa > 0           
				if _cEstadoFilial == 'SC'
					_linha := substr(dtoc(TMPSAIDA->D2_EMISSAO), 4,2) + "/" + substr(dtoc(TMPSAIDA->D2_EMISSAO), 7,4) + ";"
					_linha += TMPSAIDA->D2_CF + ";"
					_linha += TMPSAIDA->B1__SEGISP + ";"
					_linha += TMPSAIDA->B1_GRUPO + ";"
					_linha += TMPSAIDA->B1_POSIPI + ";"
					_linha += TMPSAIDA->B1_COD + ";"
					_linha += TMPSAIDA->B1_DESC + ";"
					_linha += TMPSAIDA->A1_CGC + ";"
					_linha += TMPSAIDA->A1_EST + ";"
					_linha += TMPSAIDA->D2_DOC + ";"
					_linha += dtoc(TMPSAIDA->D2_EMISSAO) + ";"
					_linha += strTran(str(TMPSAIDA->D2_QUANT),'.',',') + ";"
					if TMPSAIDA->D2_BASEICM > 0
						_linha += strTran(str(TMPSAIDA->D2_BASEICM),'.',',') + ";"
						_linha += strTran(str(TMPSAIDA->D2_PICM),'.',',') + ";"
						_linha += strTran(str(TMPSAIDA->D2_VALICM),'.',',') + ";"
					else
					    _nBaseICM 	:= TMPSAIDA->D2_TOTAL + TMPSAIDA->D2_VALFRE + TMPSAIDA->D2_DESPESA
					    _nValICM	:= _nBaseICM * getMV("MV_ICMPAD") / 100				

						_linha += strTran(str(_nBaseICM),'.',',') + ";"
						_linha += strTran(str(getMV("MV_ICMPAD")),'.',',') + ";"
						_linha += strTran(str(_nValICM),'.',',') + ";"
					endif 
					_linha += strTran(str(TMPSAIDA->D2_VALIPI),'.',',') + ";"					
					_linha += strTran(str(_nIcmProp),'.',',') + ";"
					_linha += strTran(str(_nBaseReoa),'.',',') + ";"
					_linha += strTran(str(_nValorReoa),'.',',') + ";"
				else
					_linha := substr(dtoc(TMPSAIDA->D2_EMISSAO), 4,2) + "/" + substr(dtoc(TMPSAIDA->D2_EMISSAO), 7,4) + ";"
					_linha += TMPSAIDA->B1_COD + ";"
					_linha += TMPSAIDA->B1_DESC + ";"
					_linha += TMPSAIDA->A1_CGC + ";"
					_linha += TMPSAIDA->A1_EST + ";"
					_linha += TMPSAIDA->D2_DOC + ";"
					_linha += dtoc(TMPSAIDA->D2_EMISSAO) + ";"
					_linha += strTran(str(TMPSAIDA->D2_QUANT),'.',',') + ";"
					_linha += TMPSAIDA->B1_UM + ";"           
					if TMPSAIDA->D2_BASEICM > 0
						_linha += strTran(str(TMPSAIDA->D2_BASEICM),'.',',') + ";"
						_linha += strTran(str(TMPSAIDA->D2_VALICM),'.',',') + ";"
					else
					    _nBaseICM 	:= TMPSAIDA->D2_TOTAL + TMPSAIDA->D2_VALFRE + TMPSAIDA->D2_DESPESA
					    _nValICM	:= _nBaseICM * getMV("MV_ICMPAD") / 100				
					    
						_linha += strTran(str(_nBaseICM),'.',',') + ";"
						_linha += strTran(str(_nValICM),'.',',') + ";"
					endif
//					_linha += strTran(str(round((_nBaseReoa / TMPSAIDA->D1_QUANT) * TMPSAIDA->D2_QUANT,2)),'.',',') + ";"
//					_linha += strTran(str(round((_nValorReoa / TMPSAIDA->D1_QUANT) * TMPSAIDA->D2_QUANT,2)),'.',',') + ";"

					_linha += strTran(str(round(_nBaseReoa,2)),'.',',') + ";"
					_linha += strTran(str(round(_nValorReoa,2)),'.',',') + ";"
				endif
							
				fWrite(nHandle, _linha + CRLF) 
			endif
					     
			TMPSAIDA->(dbSkip())
		enddo	
		fClose(nHandle)
	
		// ARQUIVO COM NOTAS DE SAIDA EXTERNA
	
		_cArqTmp:= cPath + "\nfsaida_" + _cEstadoFilial + ".csv"
	
		nHandle := MsfCreate(_cArqTmp,0)
	    
		_cQuery := "SELECT 	SUM (D1__BSREOA) D1__BSREOA, "
		_cQuery += "		SUM (D1__VLREOA) D1__VLREOA, "
		_cQuery += "		SUM (Z11_BSREOA) Z11_BSREOA, "
		_cQuery += "		SUM (Z11_VLREOA) Z11_VLREOA, "		
		_cQuery += "		MAX (Z11_DOCENT) Z11_DOCENT, "
		_cQuery += "		MAX (Z11_SERENT) Z11_SERENT, "
		_cQuery += "		MAX (Z11_FORNEC) Z11_FORNEC, "
		_cQuery += "		MAX (Z11_LOJA) Z11_LOJA, "
		_cQuery += "		MAX (Z11_DOCSAI) Z11_DOCSAI, "
		_cQuery += "		MAX (Z11_SERSAI) Z11_SERSAI, "
		_cQuery += "		MAX (Z11_CLIENT) Z11_CLIENT, "
		_cQuery += "		MAX (Z11_LOJACL) Z11_LOJACL, "
		_cQuery += "		MAX (Z11_CODPRO) Z11_CODPRO, "
		_cQuery += "		MAX (Z11_ITEMEN) Z11_ITEMEN, "
		_cQuery += "		MAX (Z11_ITEMSA) Z11_ITEMSA, "
		_cQuery += "		SUM (Z11_ICMENT) Z11_ICMENT, "
		_cQuery += "		MAX (Z11.R_E_C_N_O_) RECZ11, "
		_cQuery += " 		MAX (D2_EMISSAO) D2_EMISSAO, "
		_cQuery += "		MAX (D2_FILIAL) FILIAL, "
		_cQuery += "		MAX (B1_COD) B1_COD, "
		_cQuery += "		MAX (B1_POSIPI) B1_POSIPI, "
		_cQuery += "		MAX (B1_DESC) B1_DESC, "
		_cQuery += "		MAX (B1_GRUPO) B1_GRUPO, "
		_cQuery += "		MAX (B1__SEGISP) B1__SEGISP, "
		_cQuery += "		MAX (D2_CF) D2_CF, "
		_cQuery += "		MAX (A1_CGC) A1_CGC, "
		_cQuery += "		MAX (A1_EST) A1_EST, "
		_cQuery += "		MAX (D2_DOC) D2_DOC, "
		_cQuery += "		MAX (D2_QUANT) D2_QUANT, "
		_cQuery += "		MAX (B1_UM) B1_UM, "
		_cQuery += "		MAX (D2_BASEICM) D2_BASEICM, "
		_cQuery += "		MAX (D2_VALICM) D2_VALICM, "
		_cQuery += "		MAX (D2_TOTAL) D2_TOTAL, "
		_cQuery += "		MAX (D2_VALFRE) D2_VALFRE, "
		_cQuery += "		MAX (D2_DESPESA) D2_DESPESA, "
		_cQuery += "		MAX (D1_QUANT) D1_QUANT, "
		_cQuery += "		MAX (A2_EST) A2_EST "
		_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
		_cQuery += "INNER JOIN " + retSqlname("SF2") + " SF2 ON F2_DOC = D2_DOC "
		_cQuery += " 										AND F2_SERIE = D2_SERIE "
		_cQuery += " 										AND SF2.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("Z11") + " Z11 ON Z11_DOCSAI = D2_DOC "
		_cQuery += " 										AND Z11_SERSAI = D2_SERIE "
		_cQuery += " 										AND Z11_FILIAL = D2_FILIAL "
		_cQuery += " 										AND Z11_ITEMSA = D2_ITEM "
		_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("SB1") + " SB1 ON B1_COD = D2_COD "
		_cQuery += " 										AND SB1.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("SA1") + " SA1 ON A1_COD = Z11_CLIENT "
		_cQuery += " 										AND A1_LOJA = Z11_LOJACL "
		_cQuery += " 										AND SA1.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON D1_DOC = Z11_DOCENT "
		_cQuery += " 										AND D1_SERIE = Z11_SERENT "
		_cQuery += " 										AND D1_FORNECE = Z11_FORNEC "
		_cQuery += " 										AND D1_LOJA = Z11_LOJA "
		_cQuery += " 										AND D1_ITEM = Z11_ITEMEN "
		_cQuery += " 										AND D1_FILIAL = Z11_FILIAL "
		_cQuery += " 										AND SD1.D_E_L_E_T_ <> '*' "
		_cQuery += "INNER JOIN " + retSqlname("SA2") + " SA2 ON A2_COD = D1_FORNECE "
		_cQuery += " 										AND A2_LOJA = D1_LOJA "
		_cQuery += " 										AND SA2.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D2_EMISSAO >= '" + dtos(mv_par02)  + "' "
		_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' "
		_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' "
		_cQuery += "  AND D2_COD >= '" + mv_par04  + "' "
		_cQuery += "  AND D2_COD <= '" + mv_par05  + "' "
		_cQuery += "  AND F2_EST <> '" + _cEstadoFilial + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND B1__SEGISP IN " + _cSegtos  + " "
		if _cEstadoFilial == "SC"
			_cQuery += "  AND B1_GRUPO <> '7' "
		endif
//		_cQuery += "GROUP BY D2_DOC, B1_COD"
		_cQuery += "GROUP BY D2_DOC, B1_COD, D1_DOC, D1_ITEM"
	
		If(select("TMPSAIDA") > 0)
			TMPSAIDA->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPSAIDA" 
		TCSetField("TMPSAIDA","D2_EMISSAO","D")                                                  
		
		if _cEstadoFilial == "SC"
			_linha := "MES_REF.;CFOP;SEGMENTO;GRUPO;NCM;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;BASE;ICMS;ICMS PROP.;BSR;ICMSR"
        else
			_linha := "MES_REF.;CODIGO_PROD;DESCRICAO_PROD;CNPJ;UF;NF;DATA;QUANTIDADE;UNIDADE;BASE;ICMS 12%;ICMS 1%;"
		endif
		fWrite(nHandle, _linha + CRLF) 
	
		do while ! TMPSAIDA->(eof())
//			if _cEstadoFilial == "SC"
				_nBaseReoa	:= TMPSAIDA->Z11_BSREOA
				_nValorReoa	:= TMPSAIDA->Z11_VLREOA
				_nIcmProp	:= TMPSAIDA->Z11_ICMENT
//			else
//				_nBaseReoa	:= 0 // TMPSAIDA->D1__BSREOA
//				_nValorReoa	:= 0 // TMPSAIDA->D1__VLREOA
//			endif

		    if _nBaseReoa >= 0           
		    	dbSelectArea("Z12")
		    	dbSetOrder(1)
		    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCENT+TMPSAIDA->Z11_SERENT+TMPSAIDA->Z11_FORNEC+TMPSAIDA->Z11_LOJA+TMPSAIDA->Z11_CODPRO)
		    
			    if Z12->Z12_SERIE <> 'SD3'                      
			    	dbSelectArea("SD1")
			    	dbSetOrder(1)
			    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCENT+TMPSAIDA->Z11_SERENT+TMPSAIDA->Z11_FORNEC+TMPSAIDA->Z11_LOJA+TMPSAIDA->Z11_CODPRO+TMPSAIDA->Z11_ITEMEN)
			    
			    	dbSelectArea("SD2")
			    	dbSetOrder(3)
			    	dbSeek(TMPSAIDA->FILIAL+TMPSAIDA->Z11_DOCSAI+TMPSAIDA->Z11_SERSAI+TMPSAIDA->Z11_CLIENT+TMPSAIDA->Z11_LOJACL+TMPSAIDA->Z11_CODPRO+TMPSAIDA->Z11_ITEMSA)
	
					dbSelectArea("SF4")
					dbSetOrder(1)
					dbSeek(TMPSAIDA->FILIAL+SD2->D2_TES)
	
					dbSelectArea("SA1")
					dbSetOrder(1)
					dbSeek(xFilial("SA1")+TMPSAIDA->Z11_CLIENT+TMPSAIDA->Z11_LOJACL)
			    	
					dbSelectArea("SM0")		    	
					_nRecSM0 := SM0->(recno())
					SM0->(dbGotop())
					do while ! SM0->(eof())
						if SM0->M0_CODFIL == TMPSAIDA->FILIAL
							exit
						endif			
						SM0->(dbSkip())
					enddo				
			    

					dbSelectArea("Z11")
					go TMPSAIDA->RECZ11                 

	 				_nValReoa := U_IFISA03A("S")
					
					dbSelectArea("SM0")		    	
					go _nRecSM0 
		            
					if len(_nValReoa) > 2
						_nBaseReoa	:= _nValReoa[1]
						_nValorReoa	:= _nValReoa[2]
						_nIcmProp	:= _nValReoa[3]
	
						dbSelectArea("Z11")
						go TMPSAIDA->RECZ11
						if reclock("Z11", .F.)
							Z11->Z11_VLREOA	:= _nValReoa[2]
							Z11->Z11_BSREOA	:= _nValReoa[1]
							Z11->Z11_ICMENT	:= _nValReoa[3]
							Z11->Z11_MVA	:= _nValReoa[4]
							Z11->Z11_VA		:= _nValReoa[5]
							Z11->Z11_ALQINT	:= _nValReoa[6]
							msUnlock()
						endif		
					endif      
				endif
		    endif
			      
			if _nBaseReoa > 0           
				if _cEstadoFilial == 'SC'
					_linha := substr(dtoc(TMPSAIDA->D2_EMISSAO), 4,2) + "/" + substr(dtoc(TMPSAIDA->D2_EMISSAO), 7,4) + ";"
					_linha += TMPSAIDA->D2_CF + ";"
					_linha += TMPSAIDA->B1__SEGISP + ";"
					_linha += TMPSAIDA->B1_GRUPO + ";"
					_linha += TMPSAIDA->B1_POSIPI + ";"
					_linha += TMPSAIDA->B1_COD + ";"
					_linha += TMPSAIDA->B1_DESC + ";'"
					_linha += TMPSAIDA->A1_CGC + ";"
					_linha += TMPSAIDA->A1_EST + ";"
					_linha += TMPSAIDA->D2_DOC + ";"
					_linha += dtoc(TMPSAIDA->D2_EMISSAO) + ";"
					_linha += strTran(str(TMPSAIDA->D2_QUANT),'.',',') + ";"
					if TMPSAIDA->D2_BASEICM > 0
						_linha += strTran(str(TMPSAIDA->D2_BASEICM),'.',',') + ";"
						_linha += strTran(str(TMPSAIDA->D2_VALICM),'.',',') + ";"
					else
					    _nBaseICM 	:= TMPSAIDA->D2_TOTAL + TMPSAIDA->D2_VALFRE + TMPSAIDA->D2_DESPESA
					    _nValICM	:= _nBaseICM * getMV("MV_ICMPAD") / 100				
					    
						_linha += strTran(str(_nBaseICM),'.',',') + ";"
						_linha += strTran(str(_nValICM),'.',',') + ";"
					endif               
					_linha += strTran(str(_nIcmProp),'.',',') + ";"
					_linha += strTran(str(_nBaseReoa),'.',',') + ";"
					_linha += strTran(str(_nValorReoa),'.',',') + ";"
				else
	 				_linha := substr(dtoc(TMPSAIDA->D2_EMISSAO), 4,2) + "/" + substr(dtoc(TMPSAIDA->D2_EMISSAO), 7,4) + ";"
					_linha += TMPSAIDA->B1_COD + ";"
					_linha += TMPSAIDA->B1_DESC + ";"
					_linha += TMPSAIDA->A1_CGC + ";"
					_linha += TMPSAIDA->A1_EST + ";"
					_linha += TMPSAIDA->D2_DOC + ";"
					_linha += dtoc(TMPSAIDA->D2_EMISSAO) + ";"
					_linha += strTran(str(TMPSAIDA->D2_QUANT),'.',',') + ";"
					_linha += TMPSAIDA->B1_UM + ";"
					_linha += strTran(str(TMPSAIDA->D2_BASEICM),'.',',') + ";"
					_linha += strTran(str(TMPSAIDA->D2_VALICM),'.',',') + ";"
					
					_nPercCalc := 0			
					if trim(TMPSAIDA->B1__SEGISP) $ _cSegtos
						if trim(TMPSAIDA->B1_GRUPO) == '7'
							if _cEstadoFilial != TMPSAIDA->A2_EST .and. _cEstadoFilial != TMPSAIDA->A1_EST
								_nPercCalc := 1					
							endif
						else
							if _cEstadoFilial != TMPSAIDA->A1_EST
								_nPercCalc := 1					
							endif
						endif
					endif

					_linha += strTran(str(round((TMPSAIDA->D2_BASEICM / 100) * _nPercCalc,2)),'.',',') + ";"			
					
				endif
				fWrite(nHandle, _linha + CRLF) 
			endif
					     
			TMPSAIDA->(dbSkip())
		enddo	
		fClose(nHandle)

		if _cEstadoFilial == 'ES'

			_cArqTmp:= cPath + "\somatorio_" + _cEstadoFilial + ".csv"
		
			nHandle := MsfCreate(_cArqTmp,0)
		
			// ARQUIVO COM SOMATÓRIO
		
			_cQuery := "SELECT 	B1_COD, "
			_cQuery += "		B1_DESC, "
			_cQuery += "		SAIDA.TOTAL, "
			_cQuery += "		SAIDAI.TOTALREOA "
			_cQuery += "FROM " + retSqlname("SB1") + " SB1_1 "
	
			_cQuery += "INNER JOIN ( "
			_cQuery += "SELECT MAX(B1_FILIAL) B1_FILIAL, MAX(D2_COD) D2_COD, SUM(D2_TOTAL) TOTAL "
			_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
			_cQuery += "INNER JOIN " + retSqlname("SF2") + " SF2 ON F2_DOC = D2_DOC "
			_cQuery += " 										AND F2_SERIE = D2_SERIE "
			_cQuery += " 										AND SF2.D_E_L_E_T_ <> '*' "
			_cQuery += "INNER JOIN " + retSqlname("Z11") + " Z11 ON Z11_DOCSAI = D2_DOC "
			_cQuery += " 										AND Z11_SERSAI = D2_SERIE "
			_cQuery += " 										AND Z11_FILIAL = D2_FILIAL "
			_cQuery += " 										AND Z11.D_E_L_E_T_ <> '*' "
			_cQuery += " 										AND Z11_ITEMSA = D2_ITEM "
			_cQuery += "INNER JOIN " + retSqlname("SB1") + " SB1 ON B1_COD = D2_COD "
			_cQuery += " 										AND SB1.D_E_L_E_T_ <> '*' "
			_cQuery += "INNER JOIN " + retSqlname("SA1") + " SA1 ON A1_COD = Z11_CLIENT "
			_cQuery += " 										AND A1_LOJA = Z11_LOJACL "
			_cQuery += " 										AND SA1.D_E_L_E_T_ <> '*' "
			_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON D1_DOC = Z11_DOCENT "
			_cQuery += " 										AND D1_SERIE = Z11_SERENT "
			_cQuery += " 										AND D1_FORNECE = Z11_FORNEC "
			_cQuery += " 										AND D1_LOJA = Z11_LOJA "
			_cQuery += " 										AND D1_ITEM = Z11_ITEMEN "
			_cQuery += " 										AND D1_FILIAL = Z11_FILIAL "
			_cQuery += " 										AND SD1.D_E_L_E_T_ <> '*' "
			_cQuery += "WHERE D2_EMISSAO >= '" + dtos(mv_par02)  + "' "
			_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' "
			_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' "
			_cQuery += "  AND F2_EST <> '" + _cEstadoFilial + "' "
			_cQuery += "  AND B1__SEGISP IN " + _cSegtos + " "
			_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
			_cQuery += "GROUP BY D1_COD) SAIDA ON SB1_1.B1_COD = SAIDA.D2_COD AND SB1_1.B1_FILIAL  = SAIDA.B1_FILIAL "
			
			_cQuery += "LEFT JOIN ( "
			_cQuery += "SELECT MAX(B1_FILIAL) B1_FILIAL, "
			_cQuery += "       MAX(D2_COD)  D2_COD, "
			_cQuery += "       SUM(D1__BSREOA  / D1_QUANT) TOTALBASEREOA, "
			_cQuery += "       SUM((D1__VLREOA / D1_QUANT)*Z11_QTDEUT) TOTALREOA, "
			_cQuery += "       MAX(Z11_QTDEUT),"
			_cQuery += "       MAX(Z11_DOCSAI) "
			_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
			_cQuery += "INNER JOIN Z11010 Z11 ON Z11_DOCSAI = D2_DOC "
			_cQuery += "      AND Z11_SERSAI = D2_SERIE "
			_cQuery += "      AND Z11_FILIAL = D2_FILIAL "                      
			_cQuery += "      AND Z11_ITEMSA = D2_ITEM "                     
			_cQuery += "      AND Z11.D_E_L_E_T_ <> '*' "
			_cQuery += "INNER JOIN " + retSqlname("SD1") + " SD1 ON Z11_DOCENT = D1_DOC "                     
			_cQuery += "      AND Z11_SERENT = D1_SERIE "                     
			_cQuery += "      AND Z11_FILIAL = D1_FILIAL "                     
			_cQuery += "      AND Z11_ITEMEN = D1_ITEM "                     
			_cQuery += "      AND SD1.D_E_L_E_T_ <> '*' "
			_cQuery += "LEFT JOIN " + retSqlname("Z12") + " Z12 ON Z11_DOCENT = Z12_DOC "                     
			_cQuery += "      AND Z11_SERENT = D2_SERIE "      
			_cQuery += "      AND Z11_FORNEC = Z12_FORNEC "
			_cQuery += "      AND Z11_LOJA = Z12_LOJA "
			_cQuery += "      AND Z11_FILIAL = D2_FILIAL "                     
			_cQuery += "      AND Z11.D_E_L_E_T_ <> '*' "
			_cQuery += "LEFT JOIN " + retSqlname("SB1") + " SB1 ON B1_COD = D2_COD "                     
			_cQuery += "      AND SB1.D_E_L_E_T_ <> '*' "
			_cQuery += "INNER JOIN " + retSqlname("SA2") + " SA2 ON A2_COD = Z11_FORNEC "
			_cQuery += "      AND A2_LOJA = Z11_LOJA "                     
			_cQuery += "      AND SA2.D_E_L_E_T_ <> '*' "      
			_cQuery += "WHERE D2_EMISSAO >= '" + dtos(mv_par02)  + "' "
			_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' "
			_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' "
			_cQuery += "  AND D2_EST = '" + _cEstadoFilial + "' "
			_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
			_cQuery += "GROUP BY D2_COD) SAIDAI ON SB1_1.B1_COD = SAIDAI.D2_COD AND SB1_1.B1_FILIAL  = SAIDAI.B1_FILIAL "		
			_cQuery += "WHERE SB1_1.D_E_L_E_T_ <> '*' "
			_cQuery += "  AND B1_COD >= '" + mv_par04  + "' "
			_cQuery += "  AND B1_COD <= '" + mv_par05  + "' "
			_cQuery += "  AND B1_ORIGEM IN " + _cOrigens + " "
		
			If(select("TMPRESUMO") > 0)
				TMPRESUMO->(dbCloseArea())
			endif
			TCQUERY _cQuery NEW ALIAS "TMPRESUMO" 
		
			_linha := "MES_REF.;CODIGO_PROD;DESCRICAO_PROD;TOTAL A;TOTAL B;TOTAL C;"
			fWrite(nHandle, _linha + CRLF) 
			do while ! TMPRESUMO->(eof())
		
				_linha := substr(dtoc(mv_par03), 4,2) + "/" + substr(dtoc(mv_par03), 7,4) + ";"
				_linha += TMPRESUMO->B1_COD + ";"
				_linha += TMPRESUMO->B1_DESC + ";"
				_linha += strTran(str(round(TMPRESUMO->TOTALREOA,2)),'.',',') + ";"
				_linha += strTran(str(round(((TMPRESUMO->TOTAL / 100) * 1),2)),'.',',') + ";"    
				_linha += strTran(str(round(TMPRESUMO->TOTALREOA + ((TMPRESUMO->TOTAL /100) * 1),2)),'.',',') + ";"
				fWrite(nHandle, _linha + CRLF) 
						     
				TMPRESUMO->(dbSkip())
			enddo	
			fClose(nHandle)
		endif
		                   
		msgAlert ("Arquivos gerados com sucesso !!")  

	elseIf (mv_par07 == 4) //Planilha de conferencia
		
		_cQuery := "select  Z11_FILIAL, "
		_cQuery += "        B1__SEGISP, "
		_cQuery += "        D1_DTDIGIT, "
		_cQuery += "        Z11_DOCENT, "
		_cQuery += "        D1_CF, "
		_cQuery += "        (Z11_FORNEC || ' - ' || A2_NREDUZ) FORNECEDOR, "
		_cQuery += "        A2_EST, "
		_cQuery += "        D1_BASEICM, "
		_cQuery += "        D1_PICM, "
		_cQuery += "        D1_VALICM, "
		_cQuery += "        D1_IPI, "
		_cQuery += "        D1_VALIPI, "
		_cQuery += "        Z11_ICMENT, "
		_cQuery += "        D1_TOTAL, "
		_cQuery += "        D1_VALFRE, "
		_cQuery += "        D1_DESPESA, "

		_cQuery += "        B1_COD, "
		_cQuery += "        B1_ORIGEM, "
		_cQuery += "        B1_POSIPI, "
		_cQuery += "        B1_GRTRIB, "
		         
		_cQuery += "        D2_EMISSAO, "
		_cQuery += "        Z11_DOCSAI, "
		_cQuery += "        D2_CF, "
		_cQuery += "        (Z11_CLIENT || ' - ' || A1_NREDUZ) CLIENTE, "
		_cQuery += "        A1_EST, "
		_cQuery += "        Z11_QTDEUT, "
		_cQuery += "        D2_PRCVEN, "
		_cQuery += "        D2_TOTAL, "
		_cQuery += "        D2_BASEICM, "
		_cQuery += "        D2_PICM, "
		_cQuery += "        D2_VALICM, "
		_cQuery += "        D2_IPI, "
		_cQuery += "        D2_VALIPI, "		         
		_cQuery += "        Z11_MVA, "
		_cQuery += "        Z11_VA, "
		_cQuery += "        Z11_BSREOA, "
		_cQuery += "        Z11_VLREOA, "
		_cQuery += "        Z11_ALQINT "

		_cQuery += "from " + retSqlName("Z11") + " Z11 "
		
		_cQuery += "inner join " + retSqlName("SD1") + " SD1 ON D1_DOC = Z11_DOCENT "
		_cQuery += "                      and D1_SERIE = Z11_SERENT "
		_cQuery += "                      and D1_FORNECE = Z11_FORNEC "
		_cQuery += "                      and D1_LOJA = Z11_LOJA "
		_cQuery += "                      and D1_ITEM = Z11_ITEMEN "
		_cQuery += "                      and D1_FILIAL = Z11_FILIAL "
		_cQuery += "                      and SD1.D_E_L_E_T_ = ' ' "
		                      
		_cQuery += "inner join " + retSqlName("SD2") + " SD2 ON D2_DOC = Z11_DOCSAI "
		_cQuery += "                      and D2_SERIE = Z11_SERSAI "
		_cQuery += "                      and D2_ITEM = Z11_ITEMSA "
		_cQuery += "                      and D2_FILIAL = Z11_FILIAL "
		_cQuery += "                      and SD2.D_E_L_E_T_ = ' '   "
		
		_cQuery += "inner join " + retSqlName("SB1") + " SB1 ON B1_COD = Z11_CODPRO "
		_cQuery += "                      and SB1.D_E_L_E_T_ = ' ' "
		
		_cQuery += "inner join " + retSqlName("SA1") + " SA1 ON A1_COD = Z11_CLIENT "
		_cQuery += "                      and A1_LOJA = Z11_LOJACL "
		_cQuery += "                      and SA1.D_E_L_E_T_ = ' ' "
		 
		_cQuery += "inner join " + retSqlName("SA2") + " SA2 ON A2_COD = Z11_FORNEC "
		_cQuery += "                      and A2_LOJA = Z11_LOJA "
		_cQuery += "                      and SA2.D_E_L_E_T_ = ' ' "
		                      
		_cQuery += "where Z11.D_E_L_E_T_ = ' ' "
		_cQuery += "  AND D2_EMISSAO >= '" + dtos(mv_par02)  + "' "
		_cQuery += "  AND D2_EMISSAO <= '" + dtos(mv_par03)  + "' "
		_cQuery += "  AND D2_FILIAL = '" + mv_par01  + "' "
//		_cQuery += "  AND B1_ORIGEM IN " + _cOrigens + " "
		_cQuery += "  AND B1_COD >= '" + mv_par04  + "' "
		_cQuery += "  AND B1_COD <= '" + mv_par05  + "' "  
		if val(mv_par06) > 0
			_cQuery += "  AND B1__SEGISP IN " + _cSegtos  + " "
		endif
		_cQuery += "order by D2_EMISSAO "
		
		TCQUERY _cQuery NEW ALIAS "TMPCONF" 
		TCSetField("TMPCONF","D2_EMISSAO","D")                                                  
		TCSetField("TMPCONF","D1_DTDIGIT","D")

		 cPath	:= AllTrim(cGetFile( , 'Diretório Destinos', 1, 'C:\', .F., nOR(GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. ))

		_cArqTmp:= cPath + "\conferencia_" + _cEstadoFilial + ".csv"
	
		nHandle := MsfCreate(_cArqTmp,0)

		_cLinha := "FILIAL;"
		_cLinha += "SEGMENTO;"
		_cLinha += "DATA ENTRADA;"
		_cLinha += "NF ENTRADA;"
		_cLinha += "CFOP ENTRADA;"
		_cLinha += "FORNECEDOR;"
		_cLinha += "UF FORNECEDOR;"
		_cLinha += "BASE ICMS ENT;"
		_cLinha += "% ICMS ENT;"
		_cLinha += "VLR ICMS ENT;"
		_cLinha += "% IPI ENT;"
		_cLinha += "VLR IPI ENT;"
		_cLinha += "ICMS PROP. ENT;"		        
		_cLinha += "ITEM;"
		_cLinha += "CST;"		         
		_cLinha += "NCM;"
		_cLinha += "GRUPO TRIBUTARIO;"
		_cLinha += "NF SAIDA;"
		_cLinha += "EMISSAO;"
		_cLinha += "CFOP SAIDA;"
		_cLinha += "CLIENTE;"
		_cLinha += "UF CLIENTE;"
		_cLinha += "QTDADE;"
		_cLinha += "PREÇO VENDA;"
		_cLinha += "VLR TOTAL;"
		_cLinha += "BASE ICMS SAIDA;"
		_cLinha += "% ICMS SAIDA;"
		_cLinha += "VLR ICMS SAIDA;"
		_cLinha += "% IPI SAIDA;"
		_cLinha += "VLR IPI SAIDA;"		         
		_cLinha += "% MVA;"
		_cLinha += "VA;"
		_cLinha += "BCR;"
		_cLinha += "ICMS-R;"
		_cLinha += "% ALIQ. INTERNA;"
		fWrite(nHandle, _cLinha + CRLF) 	    

	    do while ! TMPCONF->(eof())	        
	    
			_cLinha := TMPCONF->Z11_FILIAL + "; "
			_cLinha += TMPCONF->B1__SEGISP + "; "
			_cLinha += dtoc(TMPCONF->D1_DTDIGIT) + "; "
			_cLinha += TMPCONF->Z11_DOCENT + "; "
			_cLinha += TMPCONF->D1_CF + "; "
			_cLinha += TMPCONF->FORNECEDOR + "; "
			_cLinha += TMPCONF->A2_EST + "; "
                          

			if TMPCONF->D1_BASEICM > 0
				_cLinha += strTran(str(TMPCONF->D1_BASEICM),'.',',') + ";"
				_cLinha += strTran(str(TMPCONF->D1_PICM),'.',',') + "; "
				_cLinha += strTran(str(TMPCONF->D1_VALICM),'.',',') + ";"
			else
			    _nBaseICM 	:= round(TMPCONF->D1_TOTAL + TMPCONF->D1_VALFRE + TMPCONF->D1_DESPESA,2)
			    _nValICM	:= round(_nBaseICM * getMV("MV_ICMPAD") / 100 ,2)
			    
				_cLinha += strTran(str(_nBaseICM),'.',',') + ";"
				_cLinha += strTran(str(getMV("MV_ICMPAD")),'.',',') + ";"
				_cLinha += strTran(str(_nValICM),'.',',') + ";"
			endif               
	
			_cLinha += strTran(str(round(TMPCONF->D1_IPI,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D1_VALIPI,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_ICMENT,2)),'.',',') + "; "
			        
			_cLinha += TMPCONF->B1_COD + "; "
			_cLinha += TMPCONF->B1_ORIGEM + "; "
			_cLinha += TMPCONF->B1_POSIPI + "; "
			_cLinha += TMPCONF->B1_GRTRIB + "; "
			         
			_cLinha += TMPCONF->Z11_DOCSAI + "; "
			_cLinha += dtoc(TMPCONF->D2_EMISSAO) + "; "
			_cLinha += TMPCONF->D2_CF + "; "
			_cLinha += TMPCONF->CLIENTE + "; "
			_cLinha += TMPCONF->A1_EST + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_QTDEUT,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_PRCVEN,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_TOTAL,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_BASEICM,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_PICM,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_VALICM,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_IPI,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->D2_VALIPI,2)),'.',',') + "; "
			         
			_cLinha += strTran(str(round(TMPCONF->Z11_MVA,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_VA,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_BSREOA,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_VLREOA,2)),'.',',') + "; "
			_cLinha += strTran(str(round(TMPCONF->Z11_ALQINT,2)),'.',',') "
		    
			fWrite(nHandle, _cLinha + CRLF) 	    
	    
	    	TMPCONF->(dbSkip())
	    enddo
	
		fClose(nHandle)

		TMPCONF->(dbCloseArea())

	EndIf
	restArea (_aArea)
return


Static Function AjustSX1(_cPerg)

	Local _aArea := GetArea()
	
	PutSx1(_cPerg,"01","Filial :"					," "," ","mv_ch1","C",02,0,0,"G","" ,"SM0","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"02","a Partir Data de Movimento"	," "," ","mv_ch2","D",08,0,0,"G","" ,"","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"03","ate a Data de Movimento"	," "," ","mv_ch3","D",08,0,0,"G","" ,"","","","mv_par03","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"04","a Partir do Item"			," "," ","mv_ch4","C",15,0,0,"G","" ,"SB1","","","mv_par04","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"05","ate o Item"					," "," ","mv_ch5","C",15,0,0,"G","" ,"SB1","","","mv_par05","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"06","Segmento"					," "," ","mv_ch6","C",02,0,0,"G","" ,"SZ7","","","mv_par06","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSX1(_cPerg,"07","Tipo Relatorio"			," "," ","mv_ch7","C",99,0,1,"C","","","","","mv_par07","Sintetico","Sintetico","Sintetico","","Analitico","Analitico","Analitico","Exportar TXT","Exportar TXT","Exportar TXT","Conferencia","Conferencia","Conferencia","","","","")

	RestArea (_aArea)

Return(_cPerg)