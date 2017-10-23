/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xctb03	ºAutor  ³Thiago Nascimento   º Data ³  22/02/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Contabilizar nota de entrada, separando os valores de      º±±
±±º          ³ Frete Internacional, Seguro do vlr da mercadoria.          º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Blue Cycle                                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/     

User Function xctb03(cTIPO)

Local cQuery	 := ""
Local cRetConta  := ""
Local nRetVlr	 := 0             			
Local cHawb		 := SD1->D1_CONHEC
Local CALIASQRY	 := GetNextAlias() 
//Local aAreaant	 := GETAREA() 
Local aAreaSD1	 := SD1->(GETAREA())
local aAreaSWD	 := SWD->(GETAREA())
local aAreaCTK	 := CTK->(GETAREA())
local aAreaCT2	 := CT2->(GETAREA())
local aAreaCT5	 := CT5->(GETAREA())
local aAreaCT1	 := CT1->(GETAREA())
local aAreaCV3	 := CV3->(GETAREA())


	cQuery := " SELECT WN_TEC, WN_HAWB, WN_PRODUTO, WN_VALOR, WN_IIVAL, WN_SEGURO, WN_FRETE, " +CHR(13) 
	cQuery += " WN_FOB_R,WN_DESPADU,WN_DESPICM, W9_INCOTER  " +CHR(13)
	cQuery += " FROM SWN010 SWN  " +CHR(13)
	cQuery += " JOIN SW9010 SW9 ON (SW9.W9_HAWB =SWN.WN_HAWB AND SW9.W9_FILIAL= SWN.WN_FILIAL AND SW9.D_E_L_E_T_ = '' ) " +CHR(13)
	cQuery += "  WHERE WN_HAWB = '"+cHawb+"' AND SWN.D_E_L_E_T_ = '' " +CHR(13)
	cQuery += "  AND WN_FILIAL = '"+xFilial("SWN")+"'" +CHR(13)
	cQuery += "  AND WN_PRODUTO = '"+SD1->D1_COD+"'"  +CHR(13)
	cQuery += "  AND WN_ITEM = '"+SD1->D1_ITEM+"'"  +CHR(13)
	
 
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea( .T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .F., .T.)
	   
	   	
  //	dbSelectArea(cAliasQry)
//	(cAliasQry)->(dbGoTop())
	
	//Tratando o Incoterm para definir a contrapartida da conta de estoque. na contabilização das Despesas FRETE e SEGURO.
	IF cTipo == 'C' 
	
		IF (cAliasQry)->W9_INCOTER $ "EXW/FCA/FAZ/FOB"
		    cRetConta:= '2110105'//DESPACHANTE A PAGAR 		 		 
		Else				 
			cRetConta:= SA2->A2_CONTA//busca A CONTA DO FORNECEDOR
		ENDIF
		
	//	dbCloseArea(cAliasQry)	 
		RESTAREA(aAreaSD1) 	
		RESTAREA(aAreaSWD)
		RESTAREA(aAreaCT5)
		RESTAREA(aAreaCT1)
		RESTAREA(aAreaCT2)
		RESTAREA(aAreaCV3)
		Return cRetConta	
			
	ENDIF
   //Tratando o valor FOB para Contabilizar Estoque x Fornecedor   
	IF cTipo == 'VR'
		nRetVlr:= (cAliasQry)->WN_FOB_R
	  //	dbCloseArea(cAliasQry)	
		RESTAREA(aAreaSD1) 	
		RESTAREA(aAreaSWD)
		RESTAREA(aAreaCT5)
		RESTAREA(aAreaCT1)
		RESTAREA(aAreaCT2)		
		RESTAREA(aAreaCV3)		
		Return nRetVlr
    ENDIF
  //Tratando o valor FRETE internacional     
    IF cTipo == 'VF'
		nRetVlr:= (cAliasQry)->WN_FRETE
		//dbCloseArea(cAliasQry) 
		RESTAREA(aAreaSD1) 	
		RESTAREA(aAreaSWD)
		RESTAREA(aAreaCT5)
		RESTAREA(aAreaCT1)
		RESTAREA(aAreaCT2)
		RESTAREA(aAreaCV3)		
		Return nRetVlr
    ENDIF
    
  //Tratando o valor FRETE internacional     
    IF cTipo == 'VS'
		nRetVlr:= (cAliasQry)->WN_SEGURO
		//dbCloseArea(cAliasQry)		
		RESTAREA(aAreaSD1) 	
		RESTAREA(aAreaSWD)
		RESTAREA(aAreaCT5)
		RESTAREA(aAreaCT1)
		RESTAREA(aAreaCT2)
		RESTAREA(aAreaCV3)		
		Return nRetVlr
    ENDIF    

   
	  //Tratando o valor Marinha Mercante
	    IF cTipo == 'VM' 
   /*	cAliasQry:= GetNew    
	cQuery1 := " SELECT WD_HAWB, WD_DESPESA, WD_VALOR_R " +CHR(13) 
	cQuery1 += " FROM SWD010 " +CHR(13)
	cQuery1 += "  WHERE WD_HAWB = '"+cHawb+"' AND SWD.D_E_L_E_T_ = '' " +CHR(13)
	cQuery1 += "  AND WD_FILIAL = '"+cFilAnt+"'" +CHR(13)
	cQuery1 += "  AND WD_DESPESA = '405'" +CHR(13)
 
	cQuery1 := ChangeQuery(cQuery)
		
	dbUseArea( .T., "TOPCONN", TCGENQRY(,, cQuery1), cAliasQry, .F., .T.)
	
	 */   
	    
			dBSelectArea("SWD")
	    	dBSetOrder(1)//	WD_FILIAL+WD_HAWB+WD_DESPESA+DTOS(WD_DES_ADI)
	    	IF DbSeek(xFilial("SWD")+cHawb+"405")
			    nRetVlr := SWD->WD_VALOR_R    
			   	RESTAREA(aAreaSD1) 	
				RESTAREA(aAreaSWD)
				RESTAREA(aAreaCT5)
				RESTAREA(aAreaCT1)
				RESTAREA(aAreaCT2)
				RESTAREA(aAreaCV3)
				Return nRetVlr
			ENDIF
		   Return 0
	    ENDIF    
	      //Tratando o valor tx siscomex
	    IF cTipo == 'VX'
	    	dBSelectArea("SWD")
	    	dBSetOrder(1)//	WD_FILIAL+WD_HAWB+WD_DESPESA+DTOS(WD_DES_ADI)
	    	IF DbSeek(xFilial("SWD")+cHawb+"420")
			    nRetVlr := SWD->WD_VALOR_R 
			 	RESTAREA(aAreaSD1) 	
				RESTAREA(aAreaSWD)
				RESTAREA(aAreaCT5)
				RESTAREA(aAreaCT1)
				RESTAREA(aAreaCT2)
				RESTAREA(aAreaCV3)
				Return nRetVlr
			ENDIF
				RESTAREA(aAreaSD1) 	
				RESTAREA(aAreaSWD)
				RESTAREA(aAreaCT5)
				RESTAREA(aAreaCT1)
				RESTAREA(aAreaCT2)
				RESTAREA(aAreaCV3)
		   Return 0
	    ENDIF   
 	RESTAREA(aAreaSD1) 	
	RESTAREA(aAreaSWD)
	RESTAREA(aAreaCT5)
	RESTAREA(aAreaCT1)
	RESTAREA(aAreaCT2)
	RESTAREA(aAreaCV3)
Return 0 