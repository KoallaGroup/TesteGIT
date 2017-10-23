#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : SD1100I	 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar tabelas do REOA								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function SD1100I() 
	
	local _aArea 	:= getArea()
    local _cFiliais := getMV("MV__FILREO")	// parâmetro compartilhado
    local _cSegtos	:= getMV("MV__SEGREO")	// parâmetro exclusivo
    local _cOrigens	:= getMV("MV__ORIREO")	// parâmetro exclusivo
    local _cOriFund	:= superGetMV("MV__ORIFUN",,"1/2")	// parâmetro exclusivo
    local _cFilFund	:= superGetMV("MV__FILFUN",,"03/06")	// parâmetro exclusivo
    local _nVlrReoa	:= 0
//	If !Empty(Sf1->F1_Hawb)
//		Return

//	EndIf

	dbSelectArea("SB1")
	dbSetOrder(1)
	dbSeek(xFilial("SB1")+SD1->D1_COD)

	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4") + SD1->D1_TES)
	
	if SF4->F4_ESTOQUE == "S"
		_lReoa := .T.
                           
		if SD1->D1_FILIAL $ _cFiliais 
			
			_lReoa := .F.
			if SM0->M0_ESTENT == "ES"     		// Regras para o Espirito Santo

				if trim(SB1->B1_ORIGEM) $ _cOrigens .and. trim(SB1->B1__SEGISP) $ _cSegtos
					_lReoa := .T.

/*					
					dbSelectArea("SBM")
					dbSetOrder(1)
					dbSeek (xFilial("SBM")+SB1->B1_GRUPO)
	
					if SBM->BM__REGESP <> "1"
						_lReoa := .T.
					endif
*/					
				endif
			elseif SM0->M0_ESTENT == "SC"		// Regras para Santa Catarina
/*	
				dbSelectArea("SYD")
				dbSetOrder(1)
				dbSeek (xFilial("SBY")+SB1->B1_POSIPI)
				
				if SYD->YD__ICMSST == "1"
					_lReoa := .T.
				endif            
*/				
			endif
		                     
			if _lReoa

				dbSelectArea("Z12")
			
				if reclock("Z12", .T.)
				    Z12->Z12_FILIAL	:= xFilial("Z12")
				    Z12->Z12_LOCAL 	:= SD1->D1_LOCAL
				    Z12->Z12_DOC   	:= SD1->D1_DOC
				    Z12->Z12_SERIE 	:= SD1->D1_SERIE
				    Z12->Z12_FORNEC	:= SD1->D1_FORNECE
				    Z12->Z12_LOJA  	:= SD1->D1_LOJA
				    Z12->Z12_ITEM  	:= SD1->D1_ITEM 
				    Z12->Z12_QUANT 	:= SD1->D1_QUANT
				    Z12->Z12_CODPRO	:= SD1->D1_COD
				    Z12->Z12_SALDO 	:= SD1->D1_QUANT
				    Z12->Z12_DTENTR	:= SD1->D1_DTDIGIT
				    Z12->Z12_RECSD1	:= SD1->(recno())
				
					msUnlock()
				endif
				
			endif   
			
		endif
	endif	 
		
	// Gravação de informações para controle de Fundap

	if SB1->B1_ORIGEM $ _cOriFund .and. cFilAnt $ _cFilFund

		dbSelectArea("Z25")
	
		if reclock("Z25", .T.)
		    Z25->Z25_FILIAL	:= xFilial("Z25")
		    Z25->Z25_LOCAL 	:= SD1->D1_LOCAL
		    Z25->Z25_DOC   	:= SD1->D1_DOC
		    Z25->Z25_SERIE 	:= SD1->D1_SERIE
		    Z25->Z25_FORNEC	:= SD1->D1_FORNECE
		    Z25->Z25_LOJA  	:= SD1->D1_LOJA
		    Z25->Z25_ITEM  	:= SD1->D1_ITEM 
		    Z25->Z25_QUANT 	:= SD1->D1_QUANT
		    Z25->Z25_CODPRO	:= SD1->D1_COD
		    Z25->Z25_SALDO 	:= SD1->D1_QUANT
		    Z25->Z25_DTENTR	:= SD1->D1_DTDIGIT
		    Z25->Z25_RECSD1	:= SD1->(recno())
			if SF4->F4__FUNDAP == '1'
			    Z25->Z25_FUNDAP	:= "S"
			endif		
			msUnlock()
		endif
		
	endif   		

	// Fim de Gravação de informações para controle de Fundap
					
	restarea(_aArea)
	
return 