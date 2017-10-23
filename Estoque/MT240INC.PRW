#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT240INC	 		  		| 	Fevereiro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar dados do FUNDAP								  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function MT240INC()

	local cTm  	:= SD3->D3_TM
	local nQtde := SD3->D3_QUANT
	local cProd	:= SD3->D3_COD
    local _cOriFund	:= getMV("MV__ORIFUN")
    local _cFilFund	:= getMV("MV__FILFUN")
    local _cSegtos	:= getMV("MV__SEGREO")	// parâmetro exclusivo
    local _cOrigens	:= getMV("MV__ORIREO")	// parâmetro exclusivo    

    _cOrigem := posicione("SB1",1,xFilial("SB1")+cProd,"B1_ORIGEM")
    
    if _cOrigem $ _cOriFund .and. cFilAnt $ _cFilFund .and. nQtde > 0
    
    	movPEPS(cTM)
    
    endif

	_lReoa := .F.
	if SM0->M0_ESTENT == "ES"     		// Regras para o Espirito Santo

		if trim(SB1->B1_ORIGEM) $ _cOrigens .and. trim(SB1->B1__SEGISP) $ _cSegtos
			_lReoa := .T.
		endif

	elseif SM0->M0_ESTENT == "SC"		// Regras para Santa Catarina

		dbSelectArea("SYD")
		dbSetOrder(1)
		dbSeek (xFilial("SYD")+SB1->B1_POSIPI)
		
		if SYD->YD__CTREOA == "1"
			_lReoa := .T.
		endif            
		
	endif
                     
	if _lReoa
    	movREOA(cTM)
	endif            

return


static function movPEPS(cTM)   

	if val(cTM) < 500

		dbSelectArea("Z25")	
		if reclock("Z25", .T.)
		    Z25->Z25_FILIAL	:= xFilial("Z25")
		    Z25->Z25_LOCAL 	:= SD3->D3_LOCAL
		    Z25->Z25_DOC   	:= SD3->D3_DOC
		    Z25->Z25_SERIE 	:= "SD3"
		    Z25->Z25_QUANT 	:= SD3->D3_QUANT
		    Z25->Z25_CODPRO	:= SD3->D3_COD
		    Z25->Z25_SALDO 	:= SD3->D3_QUANT
		    Z25->Z25_DTENTR	:= SD3->D3_EMISSAO
		    Z25->Z25_RECSD1	:= 0
			msUnlock()
		endif

    else    

	    _nQtde  := SD3->D3_QUANT
	
		_cQuery := "SELECT * "
		_cQuery += "FROM " + retSqlname("Z25") + " Z25 "
		_cQuery += "WHERE Z25_CODPRO = '" + SD3->D3_COD  + "' "
		_cQuery += "  AND Z25.Z25_FILIAL = '" + xFilial("Z25") + "' "
		_cQuery += "  AND Z25.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND Z25_SALDO > 0 "
//		_cQuery += "  AND Z25_FUNDAP <> 'S' "
		_cQuery += "ORDER BY R_E_C_N_O_ "

		If(select("TMPZ25") > 0)
			TMPZ25->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPZ25"  	

	    do while ! TMPZ25->(eof())

			_nQtdeUtilizado := 0
			if _nQtde < TMPZ25->Z25_SALDO
				_nQtdeUtilizado := _nQtde
			else
				_nQtdeUtilizado := TMPZ25->Z25_SALDO
			endif     
			_nQtde -= _nQtdeUtilizado
            
			dbSelectArea("Z26")		
			if reclock("Z26", .T.)
				
				Z26->Z26_FILIAL	:= xFilial("Z26") 
				Z26->Z26_DOCENT := TMPZ25->Z25_DOC
				Z26->Z26_SERENT	:= TMPZ25->Z25_SERIE
				Z26->Z26_FORNEC	:= TMPZ25->Z25_FORNEC
				Z26->Z26_LOJA  	:= TMPZ25->Z25_LOJA
				Z26->Z26_ITEMEN := TMPZ25->Z25_ITEM
				Z26->Z26_DOCSAI	:= SD3->D3_DOC
				Z26->Z26_SERSAI	:= "SD3"  
//				Z26->Z26_NUMSEQ	:= SD3->D3_NUMSEQ
				Z26->Z26_CODPRO	:= SD3->D3_COD
				Z26->Z26_QTDEUT	:= _nQtdeUtilizado  
				msUnlock()
											
            endif

			dbSelectArea("Z25")
			dbSetOrder(1) 
			if dbSeek(xFilial("Z25")+TMPZ25->Z25_DOC+TMPZ25->Z25_SERIE+TMPZ25->Z25_FORNEC+TMPZ25->Z25_LOJA+TMPZ25->Z25_CODPRO)
				if reclock("Z25", .F.)
			    	Z25->Z25_SALDO -= _nQtdeUtilizado
					msUnlock()
				endif
			endif
             	
           	if _nQtde == 0
           		exit             	
           	endif
            
          	TMPZ25->(dbSkip())
       	enddo

	endif

return





static function movREOA(cTM)   

	if val(cTM) < 500

		dbSelectArea("Z12")
	
		if reclock("Z12", .T.)
		    Z12->Z12_FILIAL	:= xFilial("Z12")
		    Z12->Z12_LOCAL 	:= SD3->D3_LOCAL
		    Z12->Z12_DOC   	:= SD3->D3_DOC
		    Z12->Z12_SERIE 	:= "SD3"
		    Z12->Z12_QUANT 	:= SD3->D3_QUANT
		    Z12->Z12_CODPRO	:= SD3->D3_COD
		    Z12->Z12_SALDO 	:= SD3->D3_QUANT
		    Z12->Z12_DTENTR	:= SD3->D3_EMISSAO
		    Z12->Z12_RECSD1	:= 0
		
			msUnlock()
		endif

	else
	
	    _nQtde  := SD3->D3_QUANT
	
		_cQuery := "SELECT * "
		_cQuery += "FROM " + retSqlname("Z12") + " Z12 "
		_cQuery += "WHERE Z12_CODPRO = '" + SD3->D3_COD + "' "
		_cQuery += "  AND Z12.Z12_FILIAL = '" + xFilial("Z12") + "' "
		_cQuery += "  AND Z12.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND Z12_SALDO > 0 "
		_cQuery += "ORDER BY R_E_C_N_O_ "

		If(select("TMPZ12") > 0)
			TMPZ12->(dbCloseArea())
		endif
		TCQUERY _cQuery NEW ALIAS "TMPZ12"  	

	    do while ! TMPZ12->(eof())

			_nQtdeUtilizado := 0
			if _nQtde < TMPZ12->Z12_SALDO
				_nQtdeUtilizado := _nQtde
			else
				_nQtdeUtilizado := TMPZ12->Z12_SALDO
			endif     
			_nQtde -= _nQtdeUtilizado

            dbSelectArea("Z11")		
			if reclock("Z11", .T.)

				Z11->Z11_FILIAL	:= xFilial("Z26") 
				Z11->Z11_DOCENT := TMPZ12->Z12_DOC
				Z11->Z11_SERENT	:= TMPZ12->Z12_SERIE
				Z11->Z11_FORNEC	:= TMPZ12->Z12_FORNEC
				Z11->Z11_LOJA  	:= TMPZ12->Z12_LOJA
				Z11->Z11_ITEMEN := TMPZ12->Z12_ITEM
				Z11->Z11_DOCSAI	:= SD3->D3_DOC
				Z11->Z11_SERSAI	:= "SD3"
				Z11->Z11_CODPRO	:= SD3->D3_COD
				Z11->Z11_QTDEUT	:= _nQtdeUtilizado  
				Z11->Z11_DATA	:= dDataBase
		
            endif

			dbSelectArea("Z12")
			dbSetOrder(1) 
			if dbSeek(xFilial("Z12")+TMPZ12->Z12_DOC+TMPZ12->Z12_SERIE+TMPZ12->Z12_FORNEC+TMPZ12->Z12_LOJA+TMPZ12->Z12_CODPRO)
				if reclock("Z12", .F.)
			    	Z12->Z12_SALDO	-= _nQtdeUtilizado
				endif
			endif
             	
           	if _nQtde == 0
           		exit             	
          	endif

		 	TMPZ12->(dbSkip())
		enddo		
	
	endif
	
return


