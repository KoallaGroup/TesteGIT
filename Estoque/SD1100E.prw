#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | SD1100E  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Adiciona a quantidade de Material em transito entre as filiais   |
|          | na exclusão da Nota na filial de destino.                        |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function SD1100E()

Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSD1	:= SD1->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local cLocal	:= ""
Local cAtuEst	:= ""
Local cCgcCli	:= Posicione("SA2",1,xFilial("SA2")+SD1->D1_FORNECE+SD1->D1_LOJA,"A2_CGC")
Local cFilDest	:= ""

If SF1->F1_TIPO == "N" .and. !Empty(SF1->F1_STATUS)
	
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
	
	If Empty(cFilDest)
		RestArea(aAreaSD1)
		RestArea(aAreaSB2)
		RestArea(aArea)
		Return
	EndIf
	
	cLocal	:= Posicione("SB1",1,xFilial("SB1")+SD1->D1_COD,"B1_LOCPAD")
	cAtuEst	:= Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ESTOQUE")
	
	If cAtuEst == "S"
		
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2")+SD1->D1_COD+cLocal)
			Do While !reclock("SB2", .F.)
			EndDo
			SB2->B2__QTDTRA := SB2->B2__QTDTRA + SD1->D1_QUANT
			msUnlock()
		EndIf
	EndIf
	
EndIf

RestArea(aAreaSD1)
RestArea(aAreaSB2)
RestArea(aArea)

Return