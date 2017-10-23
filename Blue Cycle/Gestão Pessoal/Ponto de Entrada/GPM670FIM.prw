#Include "Protheus.ch"   

User Function MT103FIM()    
	Local aAreaSE2 := SE2->(GetArea())
	Local cTitulo, cE2_NUM

	If INCLUI
		DbSelectArea("SE2")
		SE2->(DbSetOrder(1)) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA                                                                                                
					     		         
		cTitulo := xFilial("SE2")+SF1->F1_SERIE+cNFiscal+"   "+PADR(cEspecie,3)+cA100For+cLoja
		
		SE2->(dbSeek(cTitulo))
		
		If SE2->(Eof()) 
			cTitulo := xFilial("SE2")+SF1->F1_SERIE+cNFiscal+"001"+PADR(cEspecie,3)+cA100For+cLoja
			
			SE2->(dbSeek(cTitulo))
		Endif
		
		SE2->(DbSetOrder(0))
		
		cE2_NUM := SE2->(E2_FILIAL+E2_NUM)                                    
		
		While !SE2->(Eof()) .And. SE2->(E2_FILIAL+E2_NUM)  == cE2_NUM  
	                          	
			If !(SE2->E2_TIPO $ "NF /PA /") .AND. Empty(SE2->E2_DATALIB) .And. Alltrim(SE2->E2_TITPAI) == Alltrim(Subst(cTitulo,3))
				RecLock("SE2",.F.)  
				SE2->E2_DATALIB := SE2->E2_EMISSAO
				SE2->(MsUnlock())
			Endif                  
			
			SE2->(dbSkip())
		Enddo
	Endif	
	
	RestArea(aAreaSE2)			
   //	AxCadastro("SE2", "SE2")
Return .T.