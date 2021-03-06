#Include 'Protheus.ch'
#INCLUDE 'TOPCONN.CH' 
/*
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
北篊onsultoria:                Q S   d o   B R A S I L                     罕�
北掏屯屯屯屯屯送屯屯屯屯退屯屯屯退屯屯屯屯屯屯屯屯屯屯送屯屯退屯屯屯屯屯屯突北
北篜rograma   � xctb03  篈utor  � Thiago Nascimento  � Data �  03/03/16   罕�
北掏屯屯屯屯屯瓮屯屯屯屯褪屯屯屯褪屯屯屯屯屯屯屯屯屯屯释屯屯褪屯屯屯屯屯屯凸北
北篋escricao  � Fun玢o para calcular os valores para contabiliza玢o da     罕�
北�           �	nf de importa玢o.										   罕�
北�           �															   罕�
北掏屯屯屯屯屯瓮屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北� Uso       � MP11 - Cliente: BlueCycle								   罕�
北掏屯屯屯屯屯瓮屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北篠olicitante� 				   		        						   罕�
北掏屯屯屯屯屯瓮屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯凸北
北篈lteracoes � Descricao....: 											   罕�
北�           � o Excel.												   罕�
北�           � Solicitante..: 								        	   罕�
北�           � Data.........: 											   罕�
北�           � Consultor....: 											   罕�
北韧屯屯屯屯屯释屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯图北
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
*/


User Function xctb03(cTIPO)

Local cQuery	 := ""
Local cRetConta  := ""
Local nRetVlr	 := 0             			
Local cHawb		 := SD1->D1_CONHEC
Local nRateio	 := 0
Local CALIASQRY	 := GetNextAlias() 
Local aAreaSD1	 := SD1->(GETAREA())
local aAreaSWD	 := SWD->(GETAREA())
local aAreaCTK	 := CTK->(GETAREA())
local aAreaCT2	 := CT2->(GETAREA())
local aAreaCT5	 := CT5->(GETAREA())
local aAreaCT1	 := CT1->(GETAREA())
local aAreaCV3	 := CV3->(GETAREA())


	cQuery := " SELECT WN_TEC, WN_HAWB, WN_PRODUTO, WN_VALOR, WN_IIVAL, WN_SEGURO, WN_FRETE, " 
	cQuery += " WN_FOB_R,WN_DESPADU,WN_DESPICM, W9_INCOTER,WN_RATEIO  " 
	cQuery += " FROM SWN010 SWN  " 
	cQuery += " JOIN SW9010 SW9 ON (SW9.W9_HAWB =SWN.WN_HAWB AND SW9.W9_FILIAL= SWN.WN_FILIAL AND SW9.D_E_L_E_T_ = ' ' ) " 
	cQuery += "  WHERE WN_HAWB = '"+cHawb+"' AND SWN.D_E_L_E_T_ = ' ' " 
	cQuery += "  AND WN_FILIAL = '"+xFilial("SWN")+"'" 
	cQuery += "  AND WN_PRODUTO = '"+SD1->D1_COD+"'" 
	cQuery += "  AND WN_ITEM = '"+SD1->D1_ITEM+"'"  
	
 
	cQuery := ChangeQuery(cQuery)
		
	dbUseArea( .T., "TOPCONN", TCGENQRY(,, cQuery), cAliasQry, .F., .T.)
	//Rateio	   
   	nRateio	:= (cAliasQry)->WN_RATEIO //pegando valor do rateio para ratear o valor da despesa capatazia.  	

   //Tratando o valor FOB para Contabilizar Estoque x Fornecedor   
	IF cTipo == 'VR'
		nRetVlr:= (cAliasQry)->WN_FOB_R
		RESTAREA(aAreaSD1) 	
		RESTAREA(aAreaSWD)
		RESTAREA(aAreaCT5)
		RESTAREA(aAreaCT1)
		RESTAREA(aAreaCT2)		
		RESTAREA(aAreaCV3)		
		Return nRetVlr
    ENDIF                                                          
    //Tratando o valor II para Contabilizar Estoque x Fornecedor   
	IF cTipo == 'VII'
		nRetVlr:= (cAliasQry)->WN_IIVAL
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
   
			dBSelectArea("SWD")
	    	dBSetOrder(1)//	WD_FILIAL+WD_HAWB+WD_DESPESA+DTOS(WD_DES_ADI)
	    	IF DbSeek(xFilial("SWD")+cHawb+"405")
			    nRetVlr := SWD->WD_VALOR_R*nRateio    
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
			    nRetVlr := SWD->WD_VALOR_R*nRateio
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
	    IF cTipo == 'VCP'         //Valor Capatazias
	    	dBSelectArea("SWD")
	    	dBSetOrder(1)//	WD_FILIAL+WD_HAWB+WD_DESPESA+DTOS(WD_DES_ADI)
	    	IF DbSeek(xFilial("SWD")+cHawb+"415")
			    nRetVlr := SWD->WD_VALOR_R*nRateio 
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