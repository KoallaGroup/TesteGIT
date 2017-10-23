#include "topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFISA03			  		| 	Agosto de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para recuperar valor de REOA na saída do produto						 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user function IFISA03(_cTipo)
    local _cSegtos	:= getMV("MV__SEGREO")	// parâmetro exclusivo
    local _cOrigens	:= getMV("MV__ORIREO")	// parâmetro exclusivo
    local _cTipo 	:= _cTipo   // S = Nota de Saída; E = Nota de Entrada 
    local _aResult	:= {}
    Local _aArea    := GetArea(), _aSDx := {}
   
	if _cTipo == "S"		 // nota de saída
		dbSelectArea("SD2")
		_aSDx := SD2->(GetArea())
		dbSetOrder(3) 
		if SD2->(dbSeek(xFilial("SD2") + SF2->F2_DOC + SF2->F2_SERIE ) )
			do while ! SD2->( eof() ) .and. SD2->D2_FILIAL + SD2->D2_DOC + SD2->D2_SERIE == SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE
		
				dbSelectArea("SF4")
				dbSetOrder(1)
				dbSeek(xFilial("SF4") + SD2->D2_TES)
				
				if SF4->F4_ESTOQUE == "S"
				
					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1")+SD2->D2_COD)
					
					_lReoa := .F.
					if SM0->M0_ESTENT == "ES"			// Regras para o Espirito Santo
		
						if trim(SB1->B1_ORIGEM) $ _cOrigens .and. trim(SB1->B1__SEGISP) $ _cSegtos
							_lReoa := .T.
						endif
							
					elseif SM0->M0_ESTENT == "SC"		// Regras para Santa Catarina

						_lReoa := .T.
						
					endif
				                     
					if _lReoa
		
	    	            _nMVA   := posicione("SF7",1,xFilial("SF7")+SB1->B1_GRTRIB+"REO","F7__MVA")
					   
						if _nMVA > 0  
						  	    
						    _nQtde  := SD2->D2_QUANT
						
							_cQuery := "SELECT * "
							_cQuery += "FROM " + retSqlname("Z12") + " Z12 "
							_cQuery += "WHERE Z12_CODPRO = '" + SD2->D2_COD  + "' "
							_cQuery += "  AND Z12.Z12_FILIAL = '" + xFilial("Z12") + "' "
							_cQuery += "  AND Z12.D_E_L_E_T_ <> '*' "
							_cQuery += "  AND Z12_SALDO > 0 "
							_cQuery += "ORDER BY R_E_C_N_O_ "
					
							If(select("TMPZ12") > 0)
								TMPZ12->(dbCloseArea())
							endif
							TCQUERY _cQuery NEW ALIAS "TMPZ12"  	
					
 						    do while ! TMPZ12->(eof())
			
							   	dbSelectArea("SD1")
							   	go TMPZ12->Z12_RECSD1
							    
							    if TMPZ12->Z12_SERIE <> 'SD3'                      
//								    if SD1->D1__BSREOA == 0  	// se já tiver cálculo feito, não refaz o mesmo.

//										_aValores := U_IFISA03A("S")	// executa o cálculo
/*							
									    // buscando Notas de Frete dentro do mês da nota de entrada  
										
										_cQuery := "SELECT SUM(D1_TOTAL) TOTALFRETE, SUM(D1_VALICM) ICMSFRETE "
										_cQuery += "FROM " + retSqlname("SD1") + " SD1 "
										_cQuery += "WHERE D1__NFORIG = '" + SD1->D1_DOC  + "' "
										_cQuery += "  AND D1__SERORI = '" + SD1->D1_SERIE  + "' "
										_cQuery += "  AND D1__FORORI = '" + SD1->D1_FORNECE  + "' "
										_cQuery += "  AND D1__ITEMOR = '" + SD1->D1_ITEM + "' "
										_cQuery += "  AND D1_FILIAL = '" + xFilial("SD1") + "' "
										_cQuery += "  AND SUBSTR(D1_EMISSAO,1,6) = '" + substr(dtos(SD1->D1_EMISSAO),1,6) + "' "
										_cQuery += "  AND D1_TIPO = 'C' "
										_cQuery += "  AND SD1.D_E_L_E_T_ <> '*' "
										
										If(select("TMPSD1F") > 0)
											TMPSD1F->(dbCloseArea())
										endif
										TCQUERY _cQuery NEW ALIAS "TMPSD1F"  	
										
									    _nValFrete	:= TMPSD1F->TOTALFRETE
									    _nIcmsFrete := TMPSD1F->ICMSFRETE 
									    
									    if SD1->D1__VLRFRE > 0
										    _nValFrete	+= SD1->D1_TOTAL
										    _nIcmsFrete += SD1->D1_VALICM
									    endif								    
									
									    _nIcmsEntrada := getMV("MV_ICMPAD")
									
									   	dbSelectArea("SF1")
									   	dbSetOrder(1)
									   	dbSeek(xFilial("SF1")+TMPZ12->Z12_DOC+TMPZ12->Z12_SERIE+TMPZ12->Z12_FORNEC+TMPZ12->Z12_LOJA)
									
									    _nValIcmsFrete := round((((((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))) * _nIcmsEntrada / 100) - (_nIcmsFrete * (_nValItem / SF1->F1_VALMERC)),2)
										
										_nVlrBaseReoa += (((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))
										
									   	_nValorReoa := _nIcmsItemReoa - (SD1->D1_VALICM - _nValIcmsFrete)				
*/
										             
										if SM0->M0_ESTENT != "SC"
										   	dbSelectArea("SD1")
											if reclock("SD1", .F.)							
												SD1->D1__BSREOA	:= _aValores[1]
											endif
											msUnlock()					
										endif
//						            endif 	
								endif
	
								_nQtdeUtilizado := 0
								if _nQtde < TMPZ12->Z12_SALDO
									_nQtdeUtilizado := _nQtde
								else
									_nQtdeUtilizado := TMPZ12->Z12_SALDO
								endif     
								_nQtde -= _nQtdeUtilizado
	
					            dbSelectArea("Z11")		
								if reclock("Z11", .T.)
									
									Z11->Z11_FILIAL	:= xFilial("Z11") 
									Z11->Z11_DOCENT := TMPZ12->Z12_DOC
									Z11->Z11_SERENT	:= TMPZ12->Z12_SERIE
									Z11->Z11_FORNEC	:= TMPZ12->Z12_FORNEC
									Z11->Z11_LOJA  	:= TMPZ12->Z12_LOJA
									Z11->Z11_ITEMEN := TMPZ12->Z12_ITEM
									Z11->Z11_DOCSAI	:= SF2->F2_DOC
									Z11->Z11_SERSAI	:= SF2->F2_SERIE
									Z11->Z11_ITEMSA	:= SD2->D2_ITEM
									Z11->Z11_CLIENT	:= SD2->D2_CLIENTE
									Z11->Z11_LOJACL	:= SD2->D2_LOJA
									Z11->Z11_CODPRO	:= SD2->D2_COD
									Z11->Z11_DATA	:= dDataBase
									Z11->Z11_QTDEUT	:= _nQtdeUtilizado  
									
								    if TMPZ12->Z12_SERIE <> 'SD3'                      
										Z11->Z11_VLREOA	:= _aValores[2]
										Z11->Z11_BSREOA	:= _aValores[1]
										Z11->Z11_ICMENT	:= _aValores[3]
										Z11->Z11_MVA	:= _aValores[4]
										Z11->Z11_VA		:= _aValores[5]
										Z11->Z11_ALQINT	:= _aValores[6]
									endif
									
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
			    	endif
				endif
	       		SD2->( dbSkip() )
	 		enddo
		endif
		
	else       // nota de entrada
	
		dbSelectArea("SD1")
		_aSDx := SD1->(GetArea())
		
		if SD1->D1_TIPO == "N"
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial("SF4") + SD1->D1_TES)
			
			if SF4->F4_ESTOQUE == "S"
			
				dbSelectArea("SB1")
				dbSetOrder(1)
				dbSeek(xFilial("SB1")+SD1->D1_COD)
				
				_lReoa := .F.
				if SM0->M0_ESTENT == "ES"			// Regras para o Espirito Santo
	
					if trim(SB1->B1_ORIGEM) $ _cOrigens .and. trim(SB1->B1__SEGISP) $ _cSegtos
						_lReoa := .T.
					endif
						
				elseif SM0->M0_ESTENT == "SC"		// Regras para Santa Catarina
			
					_lReoa := .T.
					
				endif
			                     
				if _lReoa
/*	
    	            _nMVA := posicione("SF7",1,xFilial("SF7")+SB1->B1_GRTRIB,"F7__MVA")

                    //Verifica se existe regra MVA para UF do Fornecedor
                    DbSelectArea("SA2")
                    DbSetOrder(1)
                    If DbSeek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA)
                        If posicione("SF7",,xFilial("SF7")+SB1->B1_GRTRIB+PADR("REO",TamSX3("F7_GRPCLI")[1])+SA2->A2_EST,"F7__MVA","F7ESTADO") > 0
                            _nMVA := SF7->F7__MVA
                        EndIf
                    EndIf
*/					    
				   	dbSelectArea("SD1")

				    if SD1->D1__BSREOA == 0   	// se já tiver cálculo feito, não refaz o mesmo.

//						_aValores := U_IFISA03A("E")	// executa o cálculo
/*
						_nVlrBaseReoa 	:= SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA
						_nValItem := _nVlrBaseReoa
						if SF4->F4_INCIDE == "S"
							_nVlrBaseReoa += TMPSD1->D1_VALIPI 
						endif         
						_nValorBase 	:= round((_nVlrBaseReoa * _nMVA)/100,2)				
						_nVlrBaseReoa 	+= _nValorBase			                
						_nIcmsItemReoa	:= round(_nVlrBaseReoa * getMV("MV_ICMPAD") / 100,2)
						                                               
					    // buscando Notas de Frete dentro do mês da nota de entrada  
						
						_cQuery := "SELECT SUM(D1_TOTAL) TOTALFRETE, SUM(D1_VALICM) ICMSFRETE "
						_cQuery += "FROM " + retSqlname("SD1") + " SD1 "
						_cQuery += "WHERE D1__NFORIG = '" + SD1->D1_DOC  + "' "
						_cQuery += "  AND D1__SERORI = '" + SD1->D1_SERIE  + "' "
						_cQuery += "  AND D1__FORORI = '" + SD1->D1_FORNECE  + "' "
						_cQuery += "  AND D1__ITEMOR = '" + SD1->D1_ITEM + "' "
						_cQuery += "  AND D1_FILIAL = '" + xFilial("SD1") + "' "
						_cQuery += "  AND SUBSTR(D1_EMISSAO,1,6) = '" + substr(dtos(SD1->D1_EMISSAO),1,6) + "' "
						_cQuery += "  AND D1_TIPO = 'C' "
						_cQuery += "  AND SD1.D_E_L_E_T_ <> '*' "
						
						If(select("TMPSD1F") > 0)
							TMPSD1F->(dbCloseArea())
						endif
						TCQUERY _cQuery NEW ALIAS "TMPSD1F"  	
						
					    _nValFrete	:= TMPSD1F->TOTALFRETE       
					    _nIcmsFrete := TMPSD1F->ICMSFRETE

					    if SD1->D1__VLRFRE > 0
						    _nValFrete	+= SD1->D1_TOTAL
						    _nIcmsFrete += SD1->D1_VALICM
					    endif								    
		
					    _nIcmsEntrada := getMV("MV_ICMPAD")
					
					   	dbSelectArea("SF1")
					   	dbSetOrder(1)
  					   	dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
					
					    _nValIcmsFrete := round((((((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))) * _nIcmsEntrada / 100) - (_nIcmsFrete * (_nValItem / SF1->F1_VALMERC)),2)
						
						_nVlrBaseReoa += (((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))
						
					   	_nValorReoa := _nIcmsItemReoa - (SD1->D1_VALICM - _nValIcmsFrete)				
*/						
//					   	dbSelectArea("SD1")
//						if reclock("SD1", .F.)							
//							SD1->D1__BSREOA	:= _nVlrBaseReoa
//							SD1->D1__VLREOA	:= _nValorReoa 
//						endif
//						msUnlock()					
		            endif 	
		    	endif
			endif
		endif
	
	endif
	   
	aadd(_aResult, SD1->D1__BSREOA)  // base do reoa
	aadd(_aResult, SD1->D1__VLREOA)  // valor do reoa
	
	RestArea(_aSDx)
	RestArea(_aArea)
return _aResult



user function IFISA03A(_cTipo)
    local _aResult		:= {}
    local _nVlrBaseReoa	:= 0
    local _nValorReoa	:= 0
    local _nMVA			:= 0

   	//Verifica se existe regra MVA para UF do Fornecedor
    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2") + SD1->D1_FORNECE + SD1->D1_LOJA) 

	if SA2->A2_EST == SM0->M0_ESTENT .or. SA2->A2_EST == 'EX'
		_cQrySF7 := "SELECT F7__MVA " 
		_cQrySF7 += "FROM " + RetSqlName("SF7") + " SF7 " 
		_cQrySF7 += "WHERE F7_FILIAL = '" + xFilial("SF7") +"' AND F7_GRPCLI = 'REO'  "
		_cQrySF7 += "  AND F7_EST = '" + SM0->M0_ESTENT + "'"
		_cQrySF7 += "  AND F7_GRTRIB = '" + SB1->B1_GRTRIB +"'  AND SF7.D_E_L_E_T_ = ' ' "
		_cQrySF7 += "ORDER BY F7_FILIAL,F7_GRTRIB,F7_GRPCLI,F7_SEQUEN " 
	else
		_cQrySF7 := "SELECT F7__MVA " 
		_cQrySF7 += "FROM " + RetSqlName("SF7") + " SF7 " 
		_cQrySF7 += "WHERE F7_FILIAL = '" + xFilial("SF7") +"' AND F7_GRPCLI = 'REO'  "
		_cQrySF7 += "  AND F7_EST = '**'"
		_cQrySF7 += "  AND F7_GRTRIB = '" + SB1->B1_GRTRIB +"'  AND SF7.D_E_L_E_T_ = ' ' "
		_cQrySF7 += "ORDER BY F7_FILIAL,F7_GRTRIB,F7_GRPCLI,F7_SEQUEN " 
	endif                                                                                                                        
	TCQUERY _cQrySF7 NEW ALIAS "TMPMVA" 

  	_nMVA   := TMPMVA->F7__MVA
  	
  	TMPMVA->(dbCloseArea())
     
    if _nMVA > 0    
		_nVlrBaseReoa := SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA + SD1->D1_VALIPI 

		_nVlrItem 	  := (SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA) / SD1->D1_QUANT

		_nIcmProp := Round((_nVlrItem * SD1->D1_PICM) / 100,2)
	
		_nVlrBaseReoa := _nVlrBaseReoa / SD1->D1_QUANT

		_nValItem := _nVlrBaseReoa
  
		_nVA := 0
		_nMVAUtil := _nMVA 
		_nAliqInt := 0

		if _cTipo = 'S'        // SAIDA
		
		    if SM0->M0_ESTENT == "SC" .and. SA1->A1_EST == "SC" .and. SD1->D1_DTDIGIT >= ctod("01/08/2014") .and. SA2->A2_EST == 'EX'
		
		    	if alltrim(SB1->B1__SEGISP) == '1' .and. SA1->A1_SIMPNAC == '1'
		                                 	
				    _nVlrBaseReoa := Round((_nVlrBaseReoa * (1+(Round((SD2->D2_PRCVEN + (SD2->D2_VALIPI / SD2->D2_QUANT)) / (SD1->D1_VUNIT + (SD1->D1_DESPESA / SD1->D1_QUANT) + (SD1->D1_VALIPI / SD1->D1_QUANT)) ,2) + ((Round(0.30 * _nMVA,2)) / 100)))),2)
				    
					_nVA := Round((SD2->D2_PRCVEN + (SD2->D2_VALIPI / SD2->D2_QUANT)) / (SD1->D1_VUNIT + (SD1->D1_DESPESA / SD1->D1_QUANT) + (SD1->D1_VALIPI / SD1->D1_QUANT)) ,2)	
					_nMVAUtil := Round(0.30 * _nMVA,2)
					
					_nIcm := Round((_nVlrBaseReoa * getMV("MV_ICMPAD")) / 100,2)
					_nIcmProp := Round(_nIcm * SD2->D2_QUANT,2)
				                                                           
					if SD2->D2_BASEICM > 0
					    _nBaseICM 	:= SD2->D2_BASEICM
					    _nIcmsItemReoa := _nIcm - (getMV("MV_ICMPAD") * (SD2->D2_BASEICM / SD2->D2_QUANT) / 100)
					else
					    _nBaseICM 	:= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_DESPESA
					    _nIcmsItemReoa := _nIcm - (getMV("MV_ICMPAD") * (_nBaseICM / SD2->D2_QUANT) / 100)
					endif
	                             
					if SD2->D2_EMISSAO >= ctod("01/07/2015")
						_nAliqInt := 10
					else
						_nAliqInt := getMV("MV_ICMPAD")
					endif
	
				else                                                                                                                  
				
				    _nVlrBaseReoa := Round(_nVlrBaseReoa * (1+(Round((SD2->D2_PRCVEN  + (SD2->D2_VALIPI / SD2->D2_QUANT)) / (SD1->D1_VUNIT + (SD1->D1_DESPESA / SD1->D1_QUANT) + (SD1->D1_VALIPI / SD1->D1_QUANT)),2) + (_nMVA / 100))),2)
		
					_nVA := Round((SD2->D2_PRCVEN + (SD2->D2_VALIPI / SD2->D2_QUANT)) / (SD1->D1_VUNIT + (SD1->D1_DESPESA / SD1->D1_QUANT) + (SD1->D1_VALIPI / SD1->D1_QUANT)) ,2)	
					_nMVAUtil := _nMVA
					
					_nIcm := Round((_nVlrBaseReoa * getMV("MV_ICMPAD")) / 100,2)
					_nIcmProp := Round(_nIcm * SD2->D2_QUANT,2)
		
					if SD1->D1_BASEICM > 0
					    _nBaseICM 	:= SD1->D1_BASEICM 
					    _nIcmsItemReoa := _nIcm - (10 * (SD1->D1_BASEICM / SD1->D1_QUANT) / 100)
					else
					    _nBaseICM 	:= SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA
					    _nIcmsItemReoa := _nIcm - (10 * (_nBaseICM / SD1->D1_QUANT) / 100)
					endif
	
					_nAliqInt := 10
	
				endif									
			    _nVlrBaseReoa	:= Round((_nVlrBaseReoa * Z11->Z11_QTDEUT),2)
				_nIcmsItemReoa  := Round((_nIcmsItemReoa * Z11->Z11_QTDEUT),2)
	        
			
		    elseif SM0->M0_ESTENT == "SC" .and. SA1->A1_EST == "SC" .and. SD1->D1_DTDIGIT < ctod("01/08/2014") .and. SA2->A2_EST == 'EX'
	
		    	if alltrim(SB1->B1__SEGISP) == '1' .and. SA1->A1_SIMPNAC == '1'
		                                 	
				    _nVlrBaseReoa := Round((_nVlrBaseReoa * (1+( + ((Round(0.30 * _nMVA,4)) / 100)))),2)
		
					_nVA := Round((SD2->D2_PRCVEN + (SD2->D2_VALIPI / SD2->D2_QUANT)) / (SD1->D1_VUNIT + (SD1->D1_DESPESA / SD1->D1_QUANT) + (SD1->D1_VALIPI / SD1->D1_QUANT)) ,2)	
					_nMVAUtil := _nMVA
					
					_nIcm := Round((_nVlrBaseReoa * getMV("MV_ICMPAD")) / 100,2)
					_nIcmProp := Round(_nIcm * SD2->D2_QUANT,2)
				                                                           
					if SD2->D2_BASEICM > 0
					    _nBaseICM 	:= SD2->D2_BASEICM
					    _nIcmsItemReoa := _nIcm - (getMV("MV_ICMPAD") * (SD2->D2_BASEICM / SD2->D2_QUANT) / 100)
					else
					    _nBaseICM 	:= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_DESPESA
					    _nIcmsItemReoa := _nIcm - (getMV("MV_ICMPAD") * (_nBaseICM / SD2->D2_QUANT) / 100) 
					endif
	
					if SD2->D2_EMISSAO >= ctod("01/07/2015")
						_nAliqInt := 10
					else
						_nAliqInt := getMV("MV_ICMPAD")
					endif

				else                                                                                                                  
				
				    _nVlrBaseReoa := Round(_nVlrBaseReoa * (1+(_nMVA / 100)),2)
		
					_nIcm := Round((_nVlrBaseReoa * getMV("MV_ICMPAD")) / 100,2)
					_nIcmProp := Round(_nIcm * SD2->D2_QUANT,2)
		
					if SD2->D2_BASEICM > 0
					    _nBaseICM 	:= SD2->D2_BASEICM 
					    _nIcmsItemReoa := _nIcm - (0.10 * (SD2->D2_BASEICM / SD2->D2_QUANT) / 100)
					else
					    _nBaseICM 	:= SD2->D2_TOTAL + SD2->D2_VALFRE + SD2->D2_DESPESA
					    _nIcmsItemReoa := _nIcm - (0.10 * (_nBaseICM / SD2->D2_QUANT) / 100)
					endif
	
					_nAliqInt := 10
				endif									
			    _nVlrBaseReoa	:= Round((_nVlrBaseReoa * Z11->Z11_QTDEUT),2)
				_nIcmsItemReoa  := Round((_nIcmsItemReoa * Z11->Z11_QTDEUT),2)
							                                                                 
			else 
	
		    	if alltrim(SB1->B1__SEGISP) == '1' .and. SA1->A1_SIMPNAC == '1'
				    _nVlrBaseReoa := _nVlrBaseReoa + Round((_nVlrBaseReoa * (Round(0.30 * _nMVA,4))) / 100,2)
				else
					_nVlrBaseReoa := _nVlrBaseReoa + round((_nVlrBaseReoa * _nMVA)/100,2)	  
				endif
							
				_nIcmsItemReoa	:= round(_nVlrBaseReoa * getMV("MV_ICMPAD") / 100,2)
	
//			    _nIcmProp	:= Round((_nIcmProp * SD2->D2_QUANT),2)

				_nIcmsItemReoa	-= _nIcmProp
	
			    _nVlrBaseReoa	:= Round((_nVlrBaseReoa * Z11->Z11_QTDEUT),2)
				_nIcmsItemReoa  := Round((_nIcmsItemReoa * Z11->Z11_QTDEUT),2)

				_nAliqInt := getMV("MV_ICMPAD")
			endif     

		else		// ENTRADA
		
			_nValFrete := 0		      
			_nIcmsFrete:= 0
			
			_nVlrBaseReoa 	:= SD1->D1_TOTAL + SD1->D1_VALFRE + SD1->D1_DESPESA
			_nValItem := _nVlrBaseReoa
			if SF4->F4_IPI == "S"
				_nVlrBaseReoa += SD1->D1_VALIPI 
			endif         
			_nValorBase 	:= round((_nVlrBaseReoa * _nMVA)/100,2)				
			_nVlrBaseReoa 	+= _nValorBase			                
			_nIcmsItemReoa	:= round(_nVlrBaseReoa * getMV("MV_ICMPAD") / 100,2)
			                                               
		    if SD1->D1__VLRFRE > 0
			    _nValFrete	+= SD1->D1_TOTAL
			    _nIcmsFrete += SD1->D1_VALICM
		    endif								    

		    _nIcmsEntrada := getMV("MV_ICMPAD")
			_nAliqInt := getMV("MV_ICMPAD")
		
		   	dbSelectArea("SF1")
		   	dbSetOrder(1)
	   		dbSeek(xFilial("SF1")+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA)
		
		    _nValIcmsFrete := round((((((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))) * _nIcmsEntrada / 100) - (_nIcmsFrete * (_nValItem / SF1->F1_VALMERC)),2)
			
			_nVlrBaseReoa += (((_nValFrete * (_nValItem / SF1->F1_VALMERC)) * _nMVA) / 100) + (_nValFrete * (_nValItem / SF1->F1_VALMERC))
			
		   	_nValorReoa := _nIcmsItemReoa - (SD1->D1_VALICM - _nValIcmsFrete)				
		
		endif
			                                         
		if SM0->M0_ESTENT == 'SC' .and. SA1->A1_TIPO $ 'R,S' .and. SA1->A1_GRPTRIB == 'ESP'
			aadd(_aResult, 0)  	// base do reoa
			aadd(_aResult, 0)  	// valor do reoa
			aadd(_aResult, 0)  	// valor proporcional do icms da entrada
			       
			aadd(_aResult, 0)  	// percentual do MVA
			aadd(_aResult, 0)  	// valor do VA
			aadd(_aResult, 0)  	// percentual da Aliq. Interna
		else
			_nValorReoa 	:= _nIcmsItemReoa 
		       
			aadd(_aResult, _nVlrBaseReoa)  	// base do reoa
			aadd(_aResult, _nValorReoa)  	// valor do reoa
			aadd(_aResult, _nIcmProp)  		// valor proporcional do icms da entrada
			       
			aadd(_aResult, _nMVAUtil)  		// percentual do MVA
			aadd(_aResult, _nVA)   			// valor do VA
			aadd(_aResult, _nAliqInt)  		// percentual da Aliq. Interna
		endif
	endif	    
return _aResult