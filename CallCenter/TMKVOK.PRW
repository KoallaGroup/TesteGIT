/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : TMKVOK			  		| 	Abril de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada chamado após gravações do Pedido de Call Center				 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function TMKVOK(_cNum)                   
    Local _aArea 		:= getArea()
	Local _aAreaSUB		:= SUB->(GetArea())
	Local _aAreaSZP		:= SZP->(GetArea())
	Local _aAreaSZO		:= SZO->(GetArea())
	Local _aAreaAD7		:= AD7->(GetArea())
	local _cNumAtend 	:= _cNum    
	Local _lAlt 		:= .F.
	Local _aResult		:= {}  
    local _nUB__MOTCAN	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__MOTCAN" })  
    local _nUB_ITEM		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM"    })  
    local _nUB_QUANT	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })  
    local _nUB_PRODUTO	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })  
    local _nPUM         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_UM"      })
    local _nPVU         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
    local _nPVL         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
    local _nPD1         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
    local _nPD2         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
    local _nPTP         := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__TPOPE"  })
	Local _cFilial		:= SUA->UA__FILIAL //Rubens Cruz
    Local _lRet   := .F.
	Local cCodRet := ""
	Local mSQL	  := ""
	
	for x:=1 to len(aCols)
	
    	if aCols[x][len(aHeader)+1]   
    		DbSelectArea("SZN")
    		DbSetOrder(2)
    		If !DbSeek(xFilial("SZN") + M->UA_NUM + aCols[x][_nUB_ITEM] + aCols[x][_nUB_PRODUTO])				
    			While !RecLock("SZN",.T.)
    			EndDo
    			SZN->ZN_FILIAL  := xFilial("SZN")
    			SZN->ZN_NUM     := _cNumAtend
    			SZN->ZN_ITEM    := aCols[x][_nUB_ITEM]
    			SZN->ZN_DTCAN   := date()
    			SZN->ZN_MOTIVO  := aCols[x][_nUB__MOTCAN]
    			SZN->ZN_QUANT   := aCols[x][_nUB_QUANT]
    			SZN->ZN_PRODUTO := aCols[x][_nUB_PRODUTO]
    			SZN->ZN_HRCAN   := substr(time(),1,5)
    			SZN->ZN_UM      := aCols[x][_nPUM]
    			SZN->ZN_VLRUNIT := aCols[x][_nPVU]
                SZN->ZN_PRCLIST := aCols[x][_nPVL]
                SZN->ZN_DESC1   := aCols[x][_nPD1]
                SZN->ZN_DESC2   := aCols[x][_nPD2]
                SZN->ZN_TPOPE   := aCols[x][_nPTP]
    			msUnlock()				
    		endif
    	endif          
		
	next x
	
	/*
	|-------------------------------------------------------------------------------------------------------|	
	|	Programa : TMKVOK			  		| 	Abril de 2014							  					|
	|-------------------------------------------------------------------------------------------------------|
	|	Desenvolvido por Rubens Cruz - Anadi																|
	|-------------------------------------------------------------------------------------------------------|	
	|	Descrição : Ponto de Entrada usado para gravar pendencias de cliente no pedido				 		|
	|-------------------------------------------------------------------------------------------------------|	
	*/                                       
	
/*	If( M->UA_OPER == '1')
		U_ITMKC09(M->UA_CLIENTE,M->UA_LOJA)
	EndIf */

/*		dbSelectArea("SZP")
		dbSetOrder(2)
	    IF ( DBSEEK(M->UA__FILIAL+M->UA_CLIENTE+M->UA_LOJA+"2",.T.) /*.AND. !vazio(SZP->ZP_PEDIDO) )
	    	if MsgYesNo("Deseja vincular estas pendencias ao pedido gerado ?","Pendencias do Pedido")
	   			if reclock("SZP", .F.)
			    	SZP->ZP_PEDIDO := _cNum
			    	SZP->ZP_UTILIZ := "1"
					MsUnlock()
				endif 
				
				dbSelectArea("SZO")
				dbSetOrder(2) //ZO_FILIAL+ZO_CODIGO                                                                                                                                    
				DbGoTop()                                         
				DBSEEK(M->UA__FILIAL+SZP->ZP_CODIGO,.T.)
				do while !EOF() .AND. M->UA__FILIAL+SZP->ZP_CODIGO == M->UA__FILIAL+SZO->ZO_CODIGO
					if reclock("SZO", .F.)
				    	SZO->ZO_PEDIDO := _cNum
				    	//SZO->ZO_FILPED := M->UA__FILIAL
				    	SZO->ZO_UTILIZ := '1'
						MsUnlock()
					endif 
					SZO->(dbSkip())
				enddo
		    EndIf 
	    EndIf 
    EndIf
*/


	/*
	|-------------------------------------------------------------------------------------------------------|	
	|	Programa : TMKVOK			  		| 	Abril de 2014							  					|
	|-------------------------------------------------------------------------------------------------------|
	|	Desenvolvido por Rubens Cruz - Anadi																|
	|-------------------------------------------------------------------------------------------------------|	
	|	Descrição : Ponto de Entrada usado para gravar o agendamento de ligacao na AD7				 		|
	|-------------------------------------------------------------------------------------------------------|	
	*/                                       
    
    /*Movido para o fonte TMKVPED
	if( INCLUI .AND. Val(M->UA__TIPPED) == 1)
		DbSelectArea("AD7")
		DbOrderNickName("AD7NUMPED ")
		If !DbSeek(SUA->UA_FILIAL + SUA->UA_NUM)           
    		if reclock("AD7", .T.)
    			AD7->AD7_FILIAL := xFilial("AD7")
    			AD7->AD7_TOPICO	:= "VISITOU E COMPROU"
    			AD7->AD7_DATA  	:= Date()
    			AD7->AD7_HORA1  := SUA->UA_INICIO
    			AD7->AD7_HORA2  := SUA->UA_FIM
    			AD7->AD7_NROPOR := "" 
    			AD7->AD7_CODCLI := SUA->UA_CLIENTE
    			AD7->AD7_LOJA   := SUA->UA_LOJA
    			AD7->AD7_VEND   := SUA->UA_VEND
    			AD7->AD7_ORIGEM := "2"
    			AD7->AD7_PROSPE := ""
    			AD7->AD7_CONTAT := SUA->UA_CODCONT
    			AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
    			AD7->AD7__DTPRE := SUA->UA_PROXLIG
    			AD7->AD7__DTVIS := Date()	
    			AD7->AD7__DTPRX := SUA->UA_PROXLIG
    			AD7->AD7__STAT  := Alltrim(GETMV("MV__MOTVIS"))
    			AD7->AD7__PREP  := ""
    			AD7->AD7__TPOPE := SUA->UA_TMK
    			AD7->AD7__PED   := SUA->UA_NUM
    			AD7->AD7__OPERA := SUA->UA_OPERADO
    			MsUnlock() 
    		endif
    		ConfirmSX8()
        EndIf
	EndIf	
    */
    
	// ROBERTO MARQUES - 04/11/2014     
    // CONSULTA PADRAO DO MOTIVO DO VISITA //
    /* Motivo de visita migrado para outra rotina - Jorge H.
	if SUA->UA_OPER == '3'
	
		DbSelectArea("SZD")
		DbGoTop()	
		_lRet := ConPad1(,,,"SZD_VE",cCodRet,, .F.)

		cCodRet := SZD->ZD_COD            
	
		If _lRet		
			DbSelectArea("AD7")           
			if reclock("AD7", .T.)
				AD7->AD7_FILIAL := xFilial("AD7")
				AD7->AD7_TOPICO	:= "VISITOU E COMPROU"
				AD7->AD7_DATA  	:= Date()
				AD7->AD7_HORA1  := SUA->UA_INICIO
				AD7->AD7_HORA2  := SUA->UA_FIM
				AD7->AD7_NROPOR := "" 
				AD7->AD7_CODCLI := SUA->UA_CLIENTE
				AD7->AD7_LOJA   := SUA->UA_LOJA
				AD7->AD7_VEND   := SUA->UA_VEND
				AD7->AD7_ORIGEM := "2"
				AD7->AD7_PROSPE := ""
				AD7->AD7_CONTAT := SUA->UA_CODCONT
				AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
				AD7->AD7__DTPRE := SUA->UA_PROXLIG
				AD7->AD7__DTVIS := Date()	
				AD7->AD7__DTPRX := SUA->UA_PROXLIG
				AD7->AD7__STAT  := cCodRet
				AD7->AD7__PREP  := ""
				AD7->AD7__TPOPE := SUA->UA_TMK
				AD7->AD7__PED   := SUA->UA_NUM
				MsUnlock() 
			endif
			ConfirmSX8()
		Else
			Alert("Opção do motivo de Cancelamento não informado")
			_lRet := .F.
		EndIf	
	Endif
	*/	

	/*
	|-------------------------------------------------------------------------------------------------------|	
	|	Programa : TMKVOK			  		| 	Março de 2015							  					|
	|-------------------------------------------------------------------------------------------------------|
	|	Desenvolvido por Rubens Cruz - Anadi																|
	|-------------------------------------------------------------------------------------------------------|	
	|	Descrição : Ponto de Entrada usado para enviar o pedido reaberto como alteração para o WMS e 		|
	|				atualizar o status do pedido com base no retorno do WMS							 		|
	|-------------------------------------------------------------------------------------------------------|	
	*/                                       

	If( ALTERA .AND. Alltrim(M->UA__SITFIN) == "A" .AND. Alltrim(M->UA__SITCOM) == "A" .AND. Alltrim(M->UA__TPREAB) == '2')
        /*
		If(Val(M->UA__STATUS) <= 5)
			M->UA__ENVWMS := ' '
			Reclock("SUA",.F.)
				SUA->UA__ENVWMS := ' '
			SUA->(MsUnlock())
		EndIf            
		*/

		/*_lAlt := (!Empty(M->UA__TPREAB) .And. !Empty(M->UA__ENVWMS)) 
		
		_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",M->UA_FILIAL,M->UA__SEGISP,M->UA_NUMSC5,M->UA_NUM,"",IIF(_lAlt,"ALT","INC"),"","")
		If !Empty(_aResult)
			If _aResult[1] == "S"
				Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 

				Reclock("SUA",.F.)
					SUA->UA__STATUS := '1'
				SUA->(MsUnlock())
                Alert("Pedido permanece em Atendimento")
            Else 
				Reclock("SUA",.F.)
					SUA->UA__STATUS := '5'
				SUA->(MsUnlock())
            EndIf
		EndIf*/
	EndIf

	/*
	|-------------------------------------------------------------------------------------------------------|	
	|	Programa : TMKVOK			  		| 	Abril de 2014							  					|
	|-------------------------------------------------------------------------------------------------------|
	|	Desenvolvido por Rubens Cruz - Anadi																|
	|-------------------------------------------------------------------------------------------------------|	
	|	Descrição : Ponto de entrada para gravar o campo UA__Filial nos itens do pedido				 		|
	|-------------------------------------------------------------------------------------------------------|	
	*/                                       
    
	if(INCLUI .OR. ALTERA)

		DbSelectArea("SUA")
		Reclock("SUA",.f.)        
		If Inclui
			SUA->UA__DTINCL := Date()
			SUA->UA__HRINCL := Time()
		EndIf
		SUA->UA__DTALT := Date()
		SUA->UA__HRALT := Time()
		MsUnlock()
		
   		dbSelectArea("SUB")
		dbSetOrder(1) //UB_FILIAL+UB_NUM+UB_ITEM+UB_PRODUTO
		DbGoTop()
		If DbSeek(xFilial("SUB")+_cNum)

			If SUA->UA_OPER != "1"
		        //Estorna os itens da grav online, para posterior atualização de acordo com a SUB
		        U_ITMKGRDL("SUB",SUA->UA_NUM)		
			EndIf

			while ! eof() .and. (xFilial("SUB")+_cNum == xFilial("SUB")+SUB->UB_NUM)
				if Reclock("SUB",.f.)
					SUB->UB__FILIAL := _cFilial
					MsUnlock()
					
					If SUA->UA_OPER != "1"
	                    //Atualiza a gravação online                
	                    U_ITMKGRON("SUB","",0,.f.,SUA->(Recno()),SUB->(Recno()),.t.)
	    			EndIf
				Endif
				
				DbSelectArea("SUB")
				dbskip()
			enddo
			
			If SUA->UA_OPER != "1"
		        //Atualiza o cabeçalho gravação online
		        U_ITMKGRON("SUA","",0,.f.,SUA->(Recno()),0,.t.)
			EndIf
			
		EndIf
	EndIf 

	RestArea(_aAreaAD7)
	RestArea(_aAreaSZO)
	RestArea(_aAreaSZP)
	RestArea(_aAreaSUB)
	restArea(_aArea)

Return       