#Include "Protheus.ch"       
#Include "TopConn.ch"       



User function MA461ROT()
Local aRetorno := {}

//AAdd( aRetorno, { "Env. WMS", "u_M460FIM()", 2, 0 } )

AAdd( aRetorno, { "Env. WMS", "u_envNF()", 2, 0 } )



Return( aRetorno )  







User Function EnvNF()
Local _aArea := GetArea(), _aResult := {}, _cTab := _cSQL := _cPed := _cSeg := ""  
Local _lRet := .T.

If !Empty(SC9->C9_NFISCAL)
	
	DbSelectArea("SD2")
	DbSetOrder(3)
	DbSeek(xFilial("SD2") + SC9->C9_NFISCAL + SC9->C9_SERIENF + SC9->C9_CLIENTE + SC9->C9_LOJA)
	 
	//Verifica se o pedido é do Call Center
	DbSelectArea("SUA")
	//DbOrderNickName("SUANF")
	//If DbSeek(xFilial("SUA") + SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	DbSetOrder(8)
	If DbSeek(xFilial("SUA") + SD2->D2_PEDIDO)
		_cPed := SUA->UA_NUM
		_cSeg := SUA->UA__SEGISP
		While !Reclock("SUA",.f.)
		EndDo
		SUA->UA__STATUS := "9"
		MsUnlock()
		
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5") +SD2->D2_PEDIDO)
			While !Reclock("SC5",.f.)
			EndDo
			SC5->C5__STATUS := "9"
			MsUnlock()
		EndIf
	EndIf
	
	If Empty(_cPed)
	
	    _cPed := SD2->D2_PEDIDO + "FAT" 
	    _cSeg := Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO,"C5__SEGISP")
	    While !Reclock("SC5",.f.)
	    EndDo
	    SC5->C5__STATUS := "9"
	    MsUnlock()
		
	EndIf
	
	//Faz envio da NF para o ArMHAzena                                                       
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2") + SC9->C9_NFISCAL + SC9->C9_SERIENF + SC9->C9_CLIENTE + SC9->C9_LOJA)
	
	_aResult := TCSPEXEC("PROC_PMHA_INTER_NOTAFISCAL",cEmpant,cFilAnt,_cSeg,_cPed,SF2->F2_DOC,SF2->F2_SERIE,"INC",IIf(!Empty(SF2->F2__TRAFIL),cFilAnt,""),Alltrim(SF2->F2__TRAFIL))
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, "ENVNOTFIS", Nil, _aResult[2], 1, 0 ) 
			_lRet := .f. 
		Else
			Help( Nil, Nil, "ENVNOTFIS", Nil, "Nota Fiscal enviada com sucesso. - " + _aResult[2], 1, 0 ) 
		EndIf
	Else
		Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar Documento de saida para arMHAzena", 1, 0 )
	
		_lRet := .f.
	EndIf
Else
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido não faturado", 1, 0 )
EndIf

Return _lret