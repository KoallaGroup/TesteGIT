#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | MSD2520  | Autor |  Rogério Alves  - Anadi  | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Preenche a quantidade de Material em transito entre as filiais   |
|          | Exclusão da nota fiscal                                          |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function MSD2520

Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local cCgcCli	:= Posicione("SA1",1,xFilial("SA1")+SF2->F2_CLIENTE+SF2->F2_LOJA,"A1_CGC")
Local cFilDest	:= _cPed := _cSeg := ""
Local cAtuEst	:= ""

If SF2->F2_TIPO == "N"
	
	DbSelectArea("SM0")
	DbGoTop()
	
	While !EOf()
		
		IF cCgcCli == SM0->M0_CGC
			cFilDest := SM0->M0_CODFIL
			Exit
		ENDIF
		
		DbSkip()
		
	EndDo
	
	RestArea(aAreaSM0)
	/*
	If Empty(cFilDest)
		RestArea(aAreaSB2)
		RestArea(aArea)
		Return
	EndIf
	*/
	
	cAtuEst	:= Posicione("SF4",1,xFilial("SF4")+SD2->D2_TES,"F4_ESTOQUE")
	
	//Atualiza o status do pedido
	//Verifica se o pedido é do Call Center
	DbSelectArea("SUA")
    //DbOrderNickName("SUANF")
    //If DbSeek(xFilial("SUA") + cFilAnt + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)	
	DbSetOrder(8)
    If DbSeek(xFilial("SUA") + SD2->D2_PEDIDO) .And. Alltrim(SUA->UA__STATUS) != "8"
		_cPed := SUA->UA_NUM
		_cSeg := SUA->UA__SEGISP
		While !Reclock("SUA",.f.)
		EndDo
		SUA->UA__STATUS := "8"
		MsUnlock()
		
		//Atualiza status no SC5
		DbSelectArea("SC5")
		DbSetOrder(1)
		If DbSeek(xFilial("SC5") + SD2->D2_PEDIDO) .And. Alltrim(SC5->C5__STATUS) != "8"
			While !Reclock("SC5",.f.)
			EndDo
			SC5->C5__STATUS := "8"
			MsUnlock()		
		EndIf
		
        //Atualiza o status no WMS
        _aResult := {}
        _aResult := TCSPEXEC("PROC_PMHA_INTER_STATUS",SUA->UA_FILIAL,SUA->UA__SEGISP,SUA->UA_NUMSC5,SUA->UA_NUM,"INC","","")

        If !Empty(_aResult)
            If _aResult[1] == "S"
                Help( Nil, Nil, "ENV_STATUS", Nil, "Nao foi possivel atualizar o Status no WMS (MHA). Informe a Logistica. - " + _aResult[2], 1, 0 )
            EndIf
        EndIf
	EndIf	
	
	If Empty(_cPed)
	
		_cPed := SD2->D2_PEDIDO + "FAT" 
		_cSeg := Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO,"C5__SEGISP")
        If SC5->C5__STATUS != "8"
    		While !Reclock("SC5",.f.)
    		EndDo
    		SC5->C5__STATUS := "8"
    		MsUnlock()
    
            //Atualiza o status no WMS
            _aResult := {}
            _aResult := TCSPEXEC("PROC_PMHA_INTER_STATUS",SC5->C5_FILIAL,SC5->C5__SEGISP,SC5->C5_NUM,"","INC","","")
    
            If !Empty(_aResult)
                If _aResult[1] == "S"
                    Help( Nil, Nil, "ENV_STATUS", Nil, "Nao foi posivel atualizar o Status no WMS (MHA). Informe a Logistica. - " + _aResult[2], 1, 0 )
                EndIf
            EndIf
        EndIf		
	EndIf	
		
	If cAtuEst == "S" .And. !Empty(cFilDest) .And. cFilDest != cFilAnt
		
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(cFilDest+SD2->D2_COD+SD2->D2_LOCAL)
			Do While !reclock("SB2", .F.)
			EndDo
			SB2->B2__QTDTRA := SB2->B2__QTDTRA - SD2->D2_QUANT
			msUnlock()
		EndIf
		
	EndIf
	
EndIf

RestArea(aAreaSB2)
RestArea(aArea)

Return