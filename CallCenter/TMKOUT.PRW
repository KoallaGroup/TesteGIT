
/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : TMKOUT			  		| 	Abril de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada chamado no fechamento de tela do Pedido de Call Center			 		|
|-------------------------------------------------------------------------------------------------------|	
*/


user Function TMKOUT(_lMsg,_nOpc)

	local _lRet := .T., _aArea := GetArea()
	Local cCodRet := "" 
	Local _lEfetiva := (Type("_lITMKCAL") <> "U" .And. _lITMKCAL)
	
	If(Empty(M->UA_CLIENTE))
		Return _lRet
	EndIf
	
	If (!Empty(M->UA_NUM) .And. (_nOpc == 3 .Or. Altera)) .Or. _lEfetiva
	//If !Empty(M->UA_NUM .And. (_nOpc == 3 .Or. _nOpc == 4)) .Or. _lEfetiva
	   //MsgAlert("Não é permitido sair do pedido sem CONFIRMAR a gravação. Confirme a operação e na sequencia cancele o pedido, se necessário.")
	   MsgAlert("Não é permitido sair do pedido sem CONFIRMAR a gravação.")
	   Return .f.
    EndIf
	
	//_lMsg --> Se exibe a mensagem: "Abandona o atendimento ?"
	//_nOpc --> Opção da rotina: 2- Visualização, 3- Inclusão e 4- Alteração
	

	if _nOpc == 3
	    _lRet := TMKOUTA(_nOpc)
		if ! _lRet
		    _lMsg := .F.    //.T.-Exibe a mensagem e .F.-Não exibe a mensagem
		endif
	endif
	
	If _lRet 
		//Apaga a reserva de estoque de todos os itens do pedido
	    U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,"","","",0,"E")

        If _lEfetiva
            M->UA__RESEST := "N"
        EndIf   
        
        //Deixa informações da gravação online igual ao que já estava gravado no banco
        U_ITMKGRON("SUA","",0,.f.,SUA->(Recno()),0,.t.)
        				
        DBSELECTAREA("SUB")
        DbSetOrder(1)
        //DbOrderNickName("SUBNUM")
        //dbseek(xFilial("SUB") + M->UA__FILIAL + M->UA_NUM)
        dbgotop()
        dbseek(xFilial("SUB") + M->UA_NUM) 
        
        WHILE SUB->(!EOF()) .AND. SUB->UB_FILIAL + SUB->UB_NUM == M->UA__FILIAL + M->UA_NUM
            //Mantém na Z10 apenas o que estava na SUB
            If M->UA__RESEST == "S"		
                U_ITMKEST1(M->UA__FILIAL,M->UA_NUM,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"I")
            EndIf
            
            //Atualiza a gravação online    			
			U_ITMKGRON("SUB","",0,.f.,SUA->(Recno()),SUB->(Recno()),.t.)
			
			SUB->(DBSKIP())
		ENDDO
	
	EndIf

/*	If(_nOpc == 3 .AND. _lRet)
		//Apaga os registros gerados na inclusão caso o usuario cancele após enviar para aprovação - Rubens Cruz 
		DbSelectArea("Z05")
		DbSetOrder(1)
		If MsSeek(xFilial("Z05")+M->UA_NUM)
			While (!EOF() .AND. Z05->Z05_FILIAL+Z05->Z05_NUM == xFilial("Z05")+M->UA_NUM)
				Reclock("Z05",.F.)
				Delete
				MsUnlock()
				DbSkip()
			EndDo
		EndIf
	EndIf*/
	                                             
	/*
	if Inclui .or. Altera
		// ROBERTO MARQUES - 04/11/2014     
	    // CONSULTA PADRAO DO MOTIVO DO CANCELAMENTO //
		DbSelectArea("SZD")
		DbGoTop()	
		//_lRet := ConPad1(,,,"SZD_VE",cCodRet,, .F.)
	
		//cCodRet := SZD->ZD_COD            
		
		If _lRet		
			DbSelectArea("AD7")           
			if reclock("AD7", .T.)
				AD7->AD7_FILIAL := xFilial("AD7")
				AD7->AD7_TOPICO	:= "MOTIVO VISITA"
				AD7->AD7_DATA  	:= Date()
				AD7->AD7_HORA1  := Time()	
				AD7->AD7_HORA2  := Time()	
				AD7->AD7_NROPOR := "" 
				AD7->AD7_CODCLI := M->UA_CLIENTE
				AD7->AD7_LOJA   := M->UA_LOJA
				AD7->AD7_VEND   := M->UA_VEND
				AD7->AD7_ORIGEM := "2"
				AD7->AD7_PROSPE := ""
				AD7->AD7_CONTAT := M->UA_CODCONT
				AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
				AD7->AD7__DTPRE := M->UA_PROXLIG
				AD7->AD7__DTVIS := Date()	
				AD7->AD7__DTPRX := M->UA_PROXLIG
				AD7->AD7__STAT  := cCodRet
				AD7->AD7__PREP  := ""
				AD7->AD7__TPOPE := M->UA_TMK
			   	IF ALTERA
			   		AD7->AD7__PED   := M->UA_NUM
			   	Else
			   		AD7->AD7__PED   := ""
			   	Endif
				MsUnlock() 
			endif
			ConfirmSX8()		
		Else
			Alert("Opção do motivo de Cancelamento não informado")
			_lRet := .F.
		EndIf
    endif
	*/
RestArea(_aArea)
Return _lRet


static Function TMKOUTA(_nOpc)
	local _lRet 		:= .T.
	local _lDel			:= .F.
    local _nUB_PRODUTO	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })  

	for x:=1 to len(aCols)
		if ! empty(aCols[x][_nUB_PRODUTO])
			if ! aCols[x][len(aHeader)+1]   
				_lRet := .F.			
				exit	   
			else
				_lDel := .T.
			endif          
		endif			
	next x      
	              
	if ! _lRet .or. (_lDel .and. M->UA_OPER <> '3')
		msgStop("Para abandonar o pedido os ítens precisam ser deletados e o Tipo de Operação ser alterado para Atendimento !!")
		_lRet := .F.			
	endif

return _lRet