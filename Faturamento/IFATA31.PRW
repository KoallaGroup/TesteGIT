#include "protheus.ch" 

/*
+----------+---------+-------+-------------------------------------+------+----------------+
|Programa  | IFATA31 | Autor | Jose Augusto F. P. Alves - Anadi    | Data | Fevereiro/2015 |
+----------+---------+-------+-------------------------------------+------+----------------+
|Descricao | Liberação de Pedido para faturamento										   |
+----------+-------------------------------------------------------------------------------+
|Uso       | Isapa                                                                         |
+----------+-------------------------------------------------------------------------------+
*/

User Function IFATA31()
Local _cNum := IIF(!Empty(SC5->C5__NUMSUA),"Pedido Call Center " + SC5->C5__NUMSUA,"Pedido " + SC5->C5_NUM)
Local _aArea := GetArea()

If SC5->C5__ENVWMS == "S"
	Alert("Pedido ja enviado ao WMS. Liberacao nao permitida!")
ElseIf !Empty(Alltrim(SC5->C5__NUMSUA))
	Alert("Pedido proveniente do CallCenter. Liberacao nao permitida!")	
ElseIf MsgYesNo("Confirma liberação do " + SC5->C5_NUM + " para faturamento?","Atenção")
	DbSelectArea("SC9")
	SC9->(DbSetOrder(1)) 
	dbGoTop()
	If !DbSeek(xFilial("SC9")+SC5->C5_NUM)
		Alert("Pedido ainda nao liberado. acao nao permitida!")			
	Else 
	    Do While(!eof()) .AND. xFilial("SC9")+SC5->C5_NUM == xFilial("SC9")+SC9->C9_PEDIDO
	        If Reclock("SC9",.F.)
		    	SC9->C9__QTDMHA := SC9->C9_QTDLIB
		    	msunlock()
		    EndIf          
		    DbSkip()
	    EndDo  
		If DbSeek(SC5->C5_FILIAL + SC5->C5_NUM)
			If Reclock("SC5",.F.)
				SC5->C5__STATUS := "8"
		   		SC5->(MsUnlock())
			EndIf
		EndIf
	EndIf
EndIf

Return