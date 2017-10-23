#Include "Protheus.ch"
       
/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MTA140MNU | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para incluir rotina na pre-nota										 |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function MTA140MNU()
aAdd(aRotina,{ "Envio WMS"		,"U_IRECWMS('SF1')"	, 0 , 2, 0, nil})
aAdd(aRotina,{ "Import. XML"	,"U_IESTA15()"		, 0 , 3, 0, nil})
aAdd(aRotina,{ "Libera Classif.","U_ILIBCLAS()"		, 0 , 4, 0, nil})
Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MTA103MNU | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para incluir rotina no documento de entrada							 |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function MTA103MNU()
aAdd(aRotina,{ "Envio WMS" 		,"U_IRECWMS('SF1')" , 0 , 2, 0, nil})
aAdd(aRotina,{ "Libera Classif.","U_ILIBCLAS()"		, 0 , 3, 0, nil})
Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MTA240MNU | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para incluir rotina na movimentação interna							 |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function MTA240MNU()
aAdd(aRotina,{ "Envio WMS"	,"U_IRECWMS('SD3')", 0 , 2, 0, nil})
Return

/*
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MTA241MNU | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+-----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para incluir rotina na movimentação interna 2						 |
+----------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	 |
+------------+---------------------------------------------------------------------------------------+
*/

User Function MTA241MNU()
aAdd(aRotina,{ "Envio WMS"	,"U_IRECWMS('SD3')", 0 , 2, 0, nil})
Return


/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | IRECWMS | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina para integração com WMS													   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			   |
+------------+-------------------------------------------------------------------------------------+
*/

User Function IRECWMS(_cOri)
Local _aResult := {}, _cSQL := _cTab := _cFilDest := _cProc := _cEmpDest := ""
Local _aArea := GetArea(), _lCont := .t., _lRet := .t., _lAltera := .f.

If _cOri == "SF1"
	_aResult := TCSPEXEC("PROC_PMHA_INTER_RECEBIMENTO",RECNO(),"INC")
	
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, "ENVREC", Nil, _aResult[2], 1, 0 ) 
			_lRet := .f.
		Else
			MsgInfo("Envio concluido com sucesso","Integracao ArMHAzena")
            While !Reclock("SF1",.f.)
            EndDo
            SF1->F1__WMSINT := "1"
            MsUnlock()
		EndIf
	Else
		Help( Nil, Nil, "ENVRECERR", Nil, "Erro ao enviar o documento para o WMS", 1, 0 )
		_lRet := .f. 
	EndIf
	
ElseIf _cOri == "SF1LIB" //Liberação de NF bloqueada
    _cDoc := Alltrim(SF1->F1_DOC) + AllTrim(SF1->F1_SERIE) + AllTrim(SF1->F1_FORNECE) + StrZero(Val(SF1->F1_LOJA),TamSX3("A2_LOJA")[1])
    _aResult := TCSPEXEC("PROC_PMHA_INTER_REC_APROVADO",cEmpAnt,SF1->F1_FILIAL,SF1->F1__SEGISP,_cDoc,"INC")
        
    If !Empty(_aResult)
        If _aResult[1] == "S"
            Help( Nil, Nil, "ENVLIBREC", Nil, _aResult[2], 1, 0 ) 
        Else
            //MsgInfo("Envio concluido com sucesso","Integracao ArMHAzena")
        EndIf
    Else
        Help( Nil, Nil, "ENVLIBREC", Nil, "Erro ao comunicar liberacao para o WMS.", 1, 0 )
        _lRet := .f. 
    EndIf
    
ElseIf _cOri == "SD3"
	
	If SD3->D3_ESTORNO == "S" .Or. SD3->D3_QUANT <= 0	
		Help( Nil, Nil, "ENVESTOR", Nil, "Nao permitido envio deste registro ao WMS", 1, 0 )
		_lRet := .f. 
	ElseIf MsgYesno("Confirma o envio do Documento " + Alltrim(SD3->D3_DOC) + " ao WMS?","ATENCAO")

		_cFilDest := SD3->D3_FILIAL
		_cProc	  := SD3->D3_DOC
		
		MsgRun( "Enviando Documento " + Alltrim(SD3->D3_DOC) + " ao WMS" , "Por favor, aguarde" , { || IRECWMSA(_cFilDest,_cProc)} )
	EndIf

ElseIf _cOri == "SC5"
    
	//Verifica se não é pedido do call center
	DbSelectArea("SUA")
	DbSetOrder(8)
	If DbSeek(xFilial("SUA") + SC5->C5_NUM)
		While !Eof() .And. SUA->UA_NUMSC5 == SC5->C5_NUM
			If SUA->UA_FILIAL == SC5->C5_FILIAL
				_lCont := .f.
				_lRet := .f.
				Exit
			EndIf
				
			DbSelectArea("SUA")
			DbSkip()
		EndDo
	EndIf

	If !_lCont
		Return
	EndIf

	If !(SC5->C5_TIPO $ "D/B")
		//Verifica se existe processo de importação e busca filial destino
		_cTab := GetNextAlias()
		_cSQL := "Select C6__PROIMP,C6__CROSSD,C6__ITCROS From " + RetSqlName("SC6") + " C6 "
		_cSQL += "Where C6_FILIAL = '" + SC5->C5_FILIAL + "' And C6_NUM = '" + SC5->C5_NUM + "' And C6__PROIMP <> ' ' And C6.D_E_L_E_T_ = ' ' And ROWNUM = 1 "
		_cSQL := ChangeQuery(_cSQL)
		
		If Select(_cTab) > 0
			DbSelectArea(_cTab)
			DbCloseArea()
		EndIf
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
		
		DbSelectArea(_cTab)
		DbGoTop()
		
		If !Eof()
			_cProc := (_cTab)->C6__PROIMP
			
			//Filial origem e destino
			DbSelectArea("SZX")
			DbSetOrder(1)
			If DbSeek(SC5->C5_FILIAL + (_cTab)->C6__CROSSD + (_cTab)->C6__PROIMP + (_cTab)->C6__ITCROS)
				_cFilDest := SZX->ZX_FILDES
				_cEmpDest := cEmpAnt
			EndIf
		EndIf
		
		If Select(_cTab) > 0
			DbSelectArea(_cTab)
			DbCloseArea()
		EndIf
			
		If Empty(_cFilDest)
			Posicione("SA1",1,xFilial("SA1") + SC5->C5_CLIENTE + SC5->C5_LOJACLI,"A1_CGC")
			
			_cSQL := "Select ZE_CODFIL From " + RetSqlName("SZE") + " ZE "
			_cSQL += "Where ZE_CGC = '" + SA1->A1_CGC + "' And ZE.D_E_L_E_T_ = ' ' "
			_cSQL := ChangeQuery(_cSQL)
			
			If Select(_cTab) > 0
				DbSelectArea(_cTab)
				DbCloseArea()
			EndIf
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
			
			DbSelectArea(_cTab)
			DbGoTop()
			
			If !Eof()
				_cFilDest := (_cTab)->ZE_CODFIL
				_cEmpDest := cEmpAnt
			EndIf
			
		EndIf
	
		If Select(_cTab) > 0
			DbSelectArea(_cTab)
			DbCloseArea()
		EndIf
	
		DbSelectArea("SC5")
	EndIf
	
	_lAltera := !Empty(SC5->C5__ENVWMS)	.And. Val(SC5->C5__STATUS) > 5	
	_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,SC5->C5__SEGISP,SC5->C5_NUM,"",_cProc,IIF(_lAltera,"ALT","INC"),_cEmpDest,_cFilDest)
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
			_lRet := .f. 
		Else
			MsgInfo("Envio concluido com sucesso para separacao","Integracao ArMHAzena")
			DbSelectArea("SC5")
			Reclock("SC5",.f.)
			SC5->C5__STATUS := "5"
			SC5->C5__ENVWMS := "S"
			MsUnlock()
		EndIf
	Else
		Help( Nil, Nil, "ENVPEDVEN", Nil, "Erro ao enviar o pedido para o WMS", 1, 0 ) 
		_lRet := .f.
	EndIf	
EndIf

RestArea(_aArea)
Return


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ILIBCLAS | Autor: | Jose Augusto F. P. Alves - Anadi         | Data: | Fevereiro/2015|
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina para alterar campos de integracao com o WMS								    |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			    |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ILIBCLAS()

If SF1->F1__WMSINT = '1'
	Alert("Documento ja integrado com o WMS.")
Else
	
	IF RecLock("SF1",.F.)
		SF1->F1__WMSINT := "1"
		SF1->F1__WMSRET := "1"
		SF1->F1__WMSENV := "L" //indica liberação manual para classificar
		SF1->(MsUnlock())
	EndIf
	
	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA)
		do while !Eof() .And. SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC == SF1->F1_DOC .and. SD1->D1_SERIE == SF1->F1_SERIE .and. SD1->D1_FORNECE == SF1->F1_FORNECE .and. SD1->D1_LOJA == SF1->F1_LOJA
			If reclock("SD1", .F.)
				SD1->D1__WMSQTD := SD1->D1_QUANT
		   		SD1->(msUnlock())
		   		
		   		//Atualiza a entrada em processamento
				DbSelectArea("SB2")
				DbSetOrder(1)
				If DbSeek(SD1->D1_FILIAL + SD1->D1_COD + SD1->D1_LOCAL)
					While !Reclock("SB2",.f.)
					EndDo
					If SD1->D1__TRANSF == "S"
						SB2->B2__QTDTRA := SB2->B2__QTDTRA - SD1->D1_QUANT
					EndIf										
					SB2->B2__ENTPRC := SB2->B2__ENTPRC + SD1->D1__WMSQTD
					MsUnlock()
				EndIf
			EndIf
			
			DbSelectArea("SD1")
			SD1->(dbSkip())
		enddo
	EndIf   
	
EndIf      

Return

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | MT240EST | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para no estorno de movimentação interna								|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	|
+------------+--------------------------------------------------------------------------------------+
*/

User Function MT240EST()
Local _aRet := GetArea(), _lRet := .t.

If SD3->D3_QUANT > 0 .And. SD3->D3__ENVWMS == "1"

	_cTM := Posicione("SF5",1,xFilial("SF5") + SD3->D3_TM,"F5_TEXTO")
	_cSg := Posicione("SB1",1,xFilial("SB1") + SD3->D3_COD,"B1__SEGISP")
	
	_aResult := TCSPEXEC("PROC_PMHA_INTER_REQUISICAO",RECNO(),IIF(SD3->D3_TM < "500","ENTRADA","SAIDA"),_cTM,_cSg,"EXC")
	
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, "ESTORNO", Nil, _aResult[2], 1, 0 ) 
			_lRet := .f. 
//		Else
//			MsgInfo("Envio concluido com sucesso","Integracao ArMHAzena")
		EndIf
	Else
		Help( Nil, Nil, "ESTORNO", Nil, "Erro ao enviar estorno da requisicao, para o WMS", 1, 0 ) 
		_lRet := .f.
	EndIf

EndIf

Return _lRet


Static Function IRECWMSA(_cFil,_cProc)
Local _cTM := _cSg := _aResult := "", _aArea := GetArea(), _nD3 := 0

DbSelectArea("SD3")
DbSetOrder(2)
DbGoTop()
DbSeek(_cFil + _cProc)

While !Eof() .And. (SD3->D3_FILIAL + SD3->D3_DOC) == (_cFil + _cProc)

	If SD3->D3_ESTORNO == "S" .Or. SD3->D3_QUANT <= 0 .Or. SD3->D3__ENVWMS == "1"
		DbSkip()
		Loop
	EndIf
	
	_cTM := Posicione("SF5",1,xFilial("SF5") + SD3->D3_TM,"F5_TEXTO")
	_cSg := Posicione("SB1",1,xFilial("SB1") + SD3->D3_COD,"B1__SEGISP")
	
	_aResult := TCSPEXEC("PROC_PMHA_INTER_REQUISICAO",RECNO(),IIF(SD3->D3_TM < "500","ENTRADA","SAIDA"),_cTM,_cSg,"INC")
	
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, Alltrim(SD3->D3_COD), Nil, _aResult[2], 1, 0 )  
		Else
			While !Reclock("SD3",.f.)
			EndDo
			SD3->D3__ENVWMS := "1"
			MsUnlock()
			_nD3++
		EndIf
//	Else
//		Help( Nil, Nil, "ENVREQUIS", Nil, "Erro ao enviar o requisicao para o WMS", 1, 0 ) 
	EndIf	
	
	DbSelectArea("SD3")
	DbSkip()
EndDo

If _nD3 > 0
	MsgInfo("Enviados " + Alltrim(Str(_nD3)) + " registros para o WMS")
Else
	MsgAlert("Nao foi encontrado nenhum registro pendente para envio ao WMS")
EndIf

RestArea(_aArea)
Return