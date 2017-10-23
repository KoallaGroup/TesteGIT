#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "TBICONN.CH"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA10 | Autor: |    Rogério Alves     | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Schedule para apontamento dos produtos com saldo zero no dia e que |
|            | não teve nenhuma movimentação no dia                               |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA10(aEmp)// U_ICOMA10({cEmpAnt,cFilAnt})

Local cEmp 		:= aEmp[1]
Local cFilOri 	:= aEmp[2]
Local lMenu 	:= ( IsBlind() .or. ( Select( "SM0" ) == 0 ) )
Local lOk		:= .T.
Local cCount	:= 0

//If lMenu
	RpcClearEnv()
	RpcSetType(3)
	RpcSetEnv( cEmp ,cFilOri,,,"COM",GetEnvServer())
	ConOut("_________________Inicio do Processo: "+Time())
//EndIf

DbSelectArea("SB1")
DbSetOrder(1)
dbGoTop()

While !EOF("SB1")
	
	lOk := .T.
/*	
	If !(ALLTRIM(SB1->B1_COD) == "9093")
		DbSelectArea("SB1")
		DbSkip()
		cCount += 1
		Loop
	EndIf
*/	
	////////////////////////////////////////////////////////////////
	//     VERIFICA SALDOS ZERADOS
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SB2")
	DbSetOrder(1)
	If SB2->(MsSeek(cFilOri+SB1->B1_COD))
		While !EOF("SB2") .AND. cFilOri == SB2->B2_FILIAL .AND. SB1->B1_COD == SB2->B2_COD
			If !(SB2->B2_QATU <= 0)
				lOk := .F.
				DbSelectArea("SB1")
				DbSkip()
				Exit
			EndIf
			DbSelectArea("SB2")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA MOVIMENTAÇÕES INTERNAS E TRANSFERÊNCIAS
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SD3")
	DbSetOrder(6)
	If SD3->(MsSeek(cFilOri+DTOS(DDATABASE)))
		While !EOF("SD3") .AND. cFilOri == SD3->D3_FILIAL .AND. SD3->D3_EMISSAO == DDATABASE
			If SB1->B1_COD == SD3->D3_COD .AND. SD3->D3_QUANT != 0
				lOk := .F.
				DbSelectArea("SB1")
				DbSkip()
				Exit
			EndIf
			DbSelectArea("SD3")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA NOTAS DE SAÍDA
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SD2")
	DbSetOrder(5)
	If SD2->(MsSeek(cFilOri+DTOS(DDATABASE)))
		While !EOF("SD2") .AND. SD2->D2_EMISSAO == DDATABASE
			If SB1->B1_COD == SD2->D2_COD
				If Posicione("SF4",1,cFilOri+SD2->D2_TES,"F4_ESTOQUE") == "S"
					lOk := .F.
					DbSelectArea("SB1")
					DbSkip()
					Exit
				EndIf
			EndIf
			DbSelectArea("SD2")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA NOTAS DE ENTRADA
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SD1")
	DbSetOrder(6)
	If SD1->(MsSeek(cFilOri+DTOS(DDATABASE)))
		While !EOF("SD1") .AND. SD1->D1_DTDIGIT == DDATABASE
			If SB1->B1_COD == SD1->D1_COD
				If Posicione("SF4",1,cFilOri+SD1->D1_TES,"F4_ESTOQUE") == "S"
					lOk := .F.
					DbSelectArea("SB1")
					DbSkip()
					Exit
				EndIf
			EndIf
			DbSelectArea("SD1")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA OS PEDIDOS FATURADOS DO CALL CENTER
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SUA")
	DbSetOrder(4)
	If SUA->(MsSeek(xFilial("SUA")+DTOS(DDATABASE)))
		While !EOF("SUA") .AND. SUA->UA_EMISSAO == DDATABASE
			If SUA->UA_STATUS == "NF."
				DbSelectArea("SUB")
				DbSetOrder(1)
				If SUB->(MsSeek(xFilial("SUB")+SUA->UA_NUM))
					While !EOF("SUB") .AND. SUA->UA_NUM == SUB->UB_NUM
						If SB1->B1_COD == SUB->UB_PRODUTO
							If Posicione("SF4",1,cFilOri+SUB->UB_TES,"F4_ESTOQUE") == "S"
								lOk := .F.
								DbSelectArea("SB1")
								DbSkip()
								Exit
							EndIf
						EndIf
						DbSelectArea("SUB")
						DbSkip()
					EndDo
				EndIf
			EndIf
			DbSelectArea("SUA")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA OS PEDIDOS DE VENDA ABERTOS
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SC5")
	DbSetOrder(2)
	If SC5->(MsSeek(cFilOri+DTOS(DDATABASE)))
		While !EOF("SC5") .AND. SC5->C5_EMISSAO == DDATABASE
			DbSelectArea("SC6")
			DbSetOrder(1)
			If SC6->(MsSeek(cFilOri+SC5->C5_NUM))
				While !EOF("SC6") .AND. SC5->C5_NUM == SC6->C6_NUM
					If SB1->B1_COD == SC6->C6_PRODUTO
						If Posicione("SF4",1,cFilOri+SUB->UB_TES,"F4_ESTOQUE") == "S"
							lOk := .F.
							DbSelectArea("SB1")
							DbSkip()
							Exit
						EndIf
					EndIf
					DbSelectArea("SC6")
					DbSkip()
				EndDo
			EndIf
			DbSelectArea("SC5")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA OS PEDIDOS LIBERADOS
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("SC9")
	DbSetOrder(7)
	If SC9->(MsSeek(cFilOri+SB1->B1_COD))
		While !EOF("SC9") .AND. SC9->C9_PRODUTO == SB1->B1_COD
			If SC9->C9_DATALIB == DDATABASE
				lOk := .F.
				DbSelectArea("SB1")
				DbSkip()
				Exit
			EndIf
			DbSelectArea("SC9")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf		
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     VERIFICA RESERVA DE ESTOQUE
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("Z10")
	If Z10->(MsSeek(cFilOri+SB1->B1_COD))
		While !EOF("Z10") .AND. cFilOri == Z10->Z10_FILIAL .AND. SB1->B1_COD == Z10->Z10_PROD
			If SB1->B1_COD == Z10->Z10_PROD .AND. Z10->Z10_DATA == DDATABASE .AND. Z10_QTD > 0
				lOk := .F.
				DbSelectArea("SB1")
				DbSkip()
				Exit
			EndIf
			DbSelectArea("Z10")
			DbSkip()
		EndDo
		If !lOk
			Loop
		EndIf
	EndIf
	
	////////////////////////////////////////////////////////////////
	//     GRAVA OS REGISTROS COM SALDO ZERADO NA Z03
	////////////////////////////////////////////////////////////////
	
	DbSelectArea("Z03")
	DbSetOrder(1) //Z03_FILIAL+Z03_COD+Z03_LOCAL+DTOS(Z03_DATA)
	If !Z03->(DbSeek(cFilOri+SB1->B1_COD+SB1->B1_LOCPAD+DTOS(DDATABASE)))
		While !RecLock("Z03",.T.)
		EndDo
		Z03->Z03_FILIAL	:= cFilOri
		Z03->Z03_COD  	:= SB1->B1_COD
		Z03->Z03_LOCAL  := SB1->B1_LOCPAD
		Z03->Z03_DATA  	:= DDATABASE
		MsUnlock()
	EndIf
	
	DbSelectArea("SB1")
	DbSkip()
	
EndDo

//If lMenu
	Reset Environment
	ConOut("_________________Fim do Processo  "+Time())
//Else
//	msgalert(cCount)
//EndIf

Return