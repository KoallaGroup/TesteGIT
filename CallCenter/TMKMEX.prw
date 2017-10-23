#include "protheus.ch"   
#include "topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : TMKVEX			  		| 	Abril de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi     												|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para informar motivo de cancelamento do Pedido do Call Center	 		|
|-------------------------------------------------------------------------------------------------------|
*/

User Function TMKVEX()

Local aArea		:= GetArea()
Local aAreaSZP	:= SZP->(GetArea())
Local aAreaSZO	:= SZO->(GetArea())
Local lRet		:= .T.
Local cCodRet	:= ""
Local _cQuery	:= ""
Local _lEfetiva := (Type("_lITMKCAL") <> "U" .And. _lITMKCAL)

If Inclui .Or. _lEfetiva 
    MsgAlert("Nao é permitido cancelar um atendimento durante a inclusão de pedido/cotação.","ATENCAO")
    Return .f.
EndIf

If Altera //.Or. Inclui
	
	DbSelectArea("SZD")
	DbGoTop()	
	lRet := ConPad1(,,,"SZD_PE",cCodRet,, .F.)

	cCodRet := SZD->ZD_COD            
	
	If lRet		
		M->UA__MOTCAN := cCodRet
		M->UA__STATUS := "12"
		M->UA__SITFIN := ""
		M->UA__DTAPFI := CTOD("  /  /    ")
		M->UA__USAPFI := ""
		M->UA__SITCOM := ""
		M->UA__DTAPCO := CTOD("  /  /    ")
		M->UA__USAPCO := ""
        M->UA__USRCLD := __cUserId
        M->UA__DTCLD  := Date()
        M->UA__HRCLD  := Time() 
        
        //Apaga bloqueios comerciais/financeiros do pedido na Z05 - Rubens Cruz > 27/04/15
        U_IFATA14B(M->UA_NUM)
	Else
		Alert("Opção do motivo de Cancelamento não informado")
		lRet := .F.
	EndIf                             
	
	//Rubens Cruz - Novembro/2014
	//Incluida rotina para excluir pendencias após cancelar o pedido no callcenter
	If lRet
		/*dbSelectArea("SZP")
		dbSetOrder(4)
	    IF ( DBSEEK(xFilial("SZP") + M->UA_FILIAL + M->UA_NUM) ) 
			Do While(SZP->(!EOF()) .AND.  xFilial("SZP") + M->UA_FILIAL + M->UA_NUM == SZP->(ZP_FILIAL+ZP_FILPED+ZP_PEDIDO) )
				if reclock("SZP", .F.)
			    	SZP->ZP_PEDIDO := ""
				    SZP->ZP_FILPED := ""
			    	SZP->ZP_UTILIZ := "2"
					MsUnlock()
				endif 
				
				dbSelectArea("SZO")
				dbSetOrder(2)
				If DBSEEK(xFilial("SZO")+SZP->ZP_CODIGO + M->UA_CLIENTE + M->UA_LOJA)
					do while SZO->(!EOF()) .AND. SZO->ZO_CODIGO+SZO->ZO_CODCLI+SZO->ZO_LOJA == SZP->ZP_CODIGO + M->UA_CLIENTE + M->UA_LOJA
						if reclock("SZO", .F.)
					    	SZO->ZO_PEDIDO := ""
						    SZO->ZO_FILPED := ""
					    	SZO->ZO_UTILIZ := '2'
							MsUnlock()
						endif 
						SZO->(dbSkip())
					EndDo
		    	EndIf
		    	SZP->(DbSkip())
		    EndDo
	    EndIf*/  

		If(select("TMP_PED") > 0)
			TMP_PED->(DbCloseArea())
		EndIf
			    
	    _cQuery := "SELECT SZP.R_E_C_N_O_ AS RECSZP		" + Chr(13)
		_cQuery += "FROM " + RetSqlName("SZP") + " SZP  " + Chr(13)
		_cQuery += "WHERE SZP.D_E_L_E_T_ = ' '          " + Chr(13)
		_cQuery += "      AND SZP.ZP_UTILIZ = '1'       " + Chr(13)
		_cQuery += "      AND SZP.ZP_FILPED = '" + M->UA_FILIAL + "' " + Chr(13)
		_cQuery += "      AND SZP.ZP_PEDIDO = '" + M->UA_NUM + "'  " 
		TCQUERY _cQuery NEW ALIAS "TMP_PED"
                             
		DbSelectArea("SZP")
		If(TMP_PED->(!Eof()))
			Do While (TMP_PED->(!Eof()))
				SZP->(DbGoTo(TMP_PED->RECSZP))
				RecLock("SZP",.F.)				
			    	SZP->ZP_PEDIDO := ""
				    SZP->ZP_FILPED := ""
			    	SZP->ZP_UTILIZ := '2'
				SZP->(MsUnlock())
				TMP_PED->(DbSkip())
			EndDo
		EndIf	

		TMP_PED->(DbCloseArea())
													   
		_cQuery := "SELECT SZO.R_E_C_N_O_ AS RECSZO     " + Chr(13)
		_cQuery += "FROM " + RetSqlName("SZO") + " SZO  " + Chr(13)
		_cQuery += "WHERE SZO.D_E_L_E_T_ = ' '          " + Chr(13)
		_cQuery += "      AND SZO.ZO_UTILIZ = '1'       " + Chr(13)
		_cQuery += "      AND SZO.ZO_FILPED = '" + M->UA_FILIAL + "' " + Chr(13)
		_cQuery += "      AND SZO.ZO_PEDIDO = '" + M->UA_NUM + "'  "  
		TCQUERY _cQuery NEW ALIAS "TMP_PED"

		DbSelectArea("SZO")
		If(TMP_PED->(!Eof()))
			Do While (TMP_PED->(!Eof()))
				SZO->(DbGoTo(TMP_PED->RECSZO))
				RecLock("SZO",.F.)				
			    	SZO->ZO_PEDIDO := ""
				    SZO->ZO_FILPED := ""
			    	SZO->ZO_UTILIZ := '2'
				SZO->(MsUnlock())
				TMP_PED->(DbSkip())
			EndDo
		EndIf	
	    
		TMP_PED->(DbCloseArea())
	    
	EndIf
	
EndIf

RestArea(aAreaSZP)
RestArea(aAreaSZO)
RestArea(aArea)

If lRet
	U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,"","","",0,"E")
EndIf

Return lRet


/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : TMKVDC			  		| 	Abril de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi     												|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para gravar a opção selecionado caso tenha sido confirmado  	 		|
|-------------------------------------------------------------------------------------------------------|
*/

User Function TMKVDC(nOpca, cAtend)
Local lRet		:= .T., _cSQL := "", _nOK := 0 , _aArea := GetArea()

If Altera
	//Atualiza alguns campos da SUA e SUB - Jorge H.
	If SUA->UA_STATUS == "CAN"
		
		While !RecLock("SUA",.F.)
		EndDo
        SUA->UA__USRCLD := __cUserId
        SUA->UA__DTCLD  := Date()
        SUA->UA__HRCLD  := Time() 
		SUA->UA__MOTCAN := M->UA__MOTCAN
		SUA->UA__STATUS := "12"
		SUA->UA__SITFIN := ""
		SUA->UA__DTAPFI := CTOD("  /  /    ")
		SUA->UA__USAPFI := ""
		SUA->UA__SITCOM := ""
		SUA->UA__DTAPCO := CTOD("  /  /    ")
		SUA->UA__USAPCO := ""
		SUA->UA_NUMSC5  := Space(TamSX3("UA_NUMSC5")[1])
		MsUnlock()
		
		_cSQL := "Update " + RetSqlName("SUB")
		_cSQL += " Set UB_NUMPV = ' ', UB_ITEMPV = ' ' "
		_cSQL += "Where UB_FILIAL = '" + SUA->UA_FILIAL + "' And UB_NUM = '" + SUA->UA_NUM + "' And D_E_L_E_T_ = ' ' "		
        _nOK  := TCSQLExec(_cSQL)
    
        If _nOK < 0
            DbSelectArea("SUB")
            DbSetOrder(1)
            If MsSeek(xFilial("SUB") + SUA->UA_NUM)
                While !Eof() .And. (SUB->UB_FILIAL + SUB->UB_NUM) == (xFilial("SUB") + SUA->UA_NUM) 
                    While !Reclock("SUB",.F.)
                    EndDo
                    SUB->UB_NUMPV  := Space(TamSX3("UB_NUMPV")[1])
                    SUB->UB_ITEMPV := Space(TamSX3("UB_ITEMPV")[1])
                    MsUnlock()
                    
                    DbSkip()
                EndDo
            EndIf
        Else
            TCRefresh("SUB")
        EndIf
        
	EndIf
	
EndIf                                       

//Rubens Cruz

If (nOpca == 1)
	dbSelectArea("SZP")
	dbSetOrder(3) //ZP_FILIAL+ZP_PEDIDO
	
	
    IF (DBSEEK(xFilial("SZP") + SUA->UA_NUM + SUA->UA_FILIAL + SUA->UA_CLIENTE + SUA->UA_LOJA)) 
		if reclock("SZP", .F.)
	    	SZP->ZP_PEDIDO := ""
			MsUnlock()
		endif 
			
		dbSelectArea("SZO")
		dbSetOrder(2) //ZO_FILIAL+ZO_CODIGO                                                                                                                                    
		DBSEEK(xfilial("SZO")+SZP->ZP_CODIGO,.T.)
		
		do while !EOF() .AND. xFilial("SZP")+SZP->ZP_CODIGO == xFilial("SZO")+SZO->ZO_CODIGO
			if reclock("SZO", .F.)
		    	SZO->ZO_PEDIDO := ""
		    	SZO->ZO_UTILIZ := '2'
				MsUnlock()
			endif 
			SZO->(dbSkip())
		enddo
	EndIf                                       
	
	dbSelectArea("AD7")
	dbSetOrder(11) //AD7_FILIAL+AD7__PED
    If (DBSEEK(xfilial("AD7")+cAtend,.T.))
		if reclock("AD7", .F.)
			delete
		EndIf		
	EndIf
	
	//Exclui a reserva se existir
	U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,"","","",0,"E") 
	
    //Atualiza a gravação online
    U_ITMKGRON("SUA","",0,.f.,SUA->(Recno()),0,.t.)
   
    //Estorna os itens da grav online, para posterior atualização de acordo com a SUB
    U_ITMKGRDL("SUB",M->UA_NUM)
                    
    DbSelectArea("SUB")
    DbSetOrder(1)
    dbgotop()
    dbseek(xFilial("SUB") + M->UA_NUM)
    
    While SUB->(!EOF()) .AND. SUB->UB_FILIAL + SUB->UB_NUM == M->UA__FILIAL + M->UA_NUM
        
        //Atualiza a gravação online                
        U_ITMKGRON("SUB","",0,.f.,SUA->(Recno()),SUB->(Recno()),.t.)
        
        SUB->(DBSKIP())
    EndDo
    
    //Atualiza o status no WMS
    If Val(SUA->UA__STAORI) >= 5
        _aResult := {}
        _aResult := TCSPEXEC("PROC_PMHA_INTER_STATUS",SUA->UA_FILIAL,SUA->UA__SEGISP,SUA->UA_NUMSC5,SUA->UA_NUM,"INC","","")

        If !Empty(_aResult)
            If _aResult[1] == "S"
                Help( Nil, Nil, "ENV_REAB", Nil, "Nao foi possivel atualizar o Status no WMS (MHA). Informe a Logistica. - " + _aResult[2], 1, 0 )
            EndIf
        EndIf
    EndIf    

EndIf
RestArea(_aArea)    
Return lRet