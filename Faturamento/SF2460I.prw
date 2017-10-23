#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | SF2460I  | Autor |  Rogério Alves  - Anadi  | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Preenche a quantidade de Material em transito entre as filiais   |
|          | Geração da nota fiscal                                           |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+

*/

User Function SF2460I

	Local aArea		:= GetArea()
	Local aAreaSB2	:= SB2->(GetArea())
	Local aAreaSM0	:= SM0->(GetArea())
	Local cCgcCli	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
	Local cFilDest	:= ""
	Local cFilAtu	:= cFilAnt
    local _cFiliais := getMV("MV__FILREO")	// parâmetro compartilhado
    local _cOriFund	:= superGetMV("MV__ORIFUN",,"1/2")	// parâmetro exclusivo
    local _cFilFund	:= superGetMV("MV__FILFUN",,"03/06")	// parâmetro exclusivo

	// A partir daqui, trecho de código especifico para o REOA  -- Luis Carlos	

	if SF2->F2_FILIAL $ _cFiliais 
	
		_nValReoa := U_IFISA03("S")

	endif
           
	// FIm de bloco de código para o REOA

	
	If SF2->F2_TIPO == "N"
		
		DbSelectArea("SM0")
		DbGoTop()
		
		While !EOf()
			
			IF Alltrim(cCgcCli) == Alltrim(SM0->M0_CGC)
				cFilDest := SM0->M0_CODFIL
				Exit
			ENDIF
			
			DbSkip()
			
		EndDo
		
		RestArea(aAreaSM0)
		
		If !Empty(cFilDest) .And. cFilDest != cFilAnt
            
            If Reclock("SF2",.f.)
                SF2->F2__TRAFIL := cFilDest 
                SF2->(MsUnlock())
            EndIf
            
			DbSelectArea("SD2")
			DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
			If DbSeek(xFilial("SD2")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
				
				While ! Eof() .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE .AND. SD2->D2_CLIENTE == SF2->F2_CLIENTE .AND. SD2->D2_LOJA == SF2->F2_LOJA
		
					DbSelectArea("SF4")
					DbSetOrder(1)
					If DbSeek(SF4->(xFilial("SF4")+SD2->D2_TES))
						If SF4->F4_ESTOQUE != "S"
							DbSelectArea("SD2")
							DbSkip()
							Loop			
						EndIf
					EndIf
						
					DbSelectArea("SB2")
					DbSetOrder(1)
					If !DbSeek(SB2->(cFilDest+SD2->D2_COD+SD2->D2_LOCAL))
						cFilAnt := cFilDest
						CriaSB2(SD2->D2_COD,SD2->D2_LOCAL)
						cFilAnt := cFilAtu
					EndIf
					
					If DbSeek(cFilDest+SD2->D2_COD+SD2->D2_LOCAL)
						Do While !reclock("SB2", .F.)
						EndDo
						SB2->B2__QTDTRA := SB2->B2__QTDTRA + SD2->D2_QUANT
						msUnlock()
					EndIf
					
					DbSelectArea("SD2")
					DbSkip()
					
				Enddo
				
			EndIf
			
		Endif
		
	EndIf     
	       
	
	// Trecho para gravação das tabelas de controle do fundap
	
	DbSelectArea("SD2")
	DbSetOrder(3) //D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM
	If DbSeek(xFilial("SD2")+ SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
		
		While ! Eof() .AND. SD2->D2_DOC == SF2->F2_DOC .AND. SD2->D2_SERIE == SF2->F2_SERIE .AND. SD2->D2_CLIENTE == SF2->F2_CLIENTE .AND. SD2->D2_LOJA == SF2->F2_LOJA

			DbSelectArea("SF4")
			DbSetOrder(1)
			If DbSeek(SF4->(xFilial("SF4")+SD2->D2_TES))
				If SF4->F4_ESTOQUE != "S"
					DbSelectArea("SD2")
					DbSkip()
					Loop			
				EndIf
			EndIf
				
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1")+SD2->D2_COD)

			if SB1->B1_ORIGEM $ _cOriFund .and. cFilAnt $ _cFilFund
                
			    _nQtde  := SD2->D2_QUANT
			
				_cQuery := "SELECT * "
				_cQuery += "FROM " + retSqlname("Z25") + " Z25 "
				_cQuery += "WHERE Z25_CODPRO = '" + SD2->D2_COD  + "' "
				_cQuery += "  AND Z25.Z25_FILIAL = '" + xFilial("Z25") + "' "
				_cQuery += "  AND Z25.D_E_L_E_T_ <> '*' "
				_cQuery += "  AND Z25_SALDO > 0 "
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
						Z26->Z26_DOCSAI	:= SF2->F2_DOC
						Z26->Z26_SERSAI	:= SF2->F2_SERIE
						Z26->Z26_ITEMSA	:= SD2->D2_ITEM
						Z26->Z26_CLIENT	:= SD2->D2_CLIENTE
						Z26->Z26_LOJACL	:= SD2->D2_LOJA
						Z26->Z26_CODPRO	:= SD2->D2_COD
						Z26->Z26_QTDEUT	:= _nQtdeUtilizado  
						Z26->Z26_FUNDAP	:= TMPZ25->Z25_FUNDAP  
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
			
			DbSelectArea("SD2")
			DbSkip()
			
		Enddo
		
	EndIf


	
	// fim de trecho para gravação das tabelas do fundap
		
	
	
	RestArea(aAreaSB2)    
    restarea(aArea)
	
Return