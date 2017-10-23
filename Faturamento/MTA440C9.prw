#INCLUDE "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | MTA440C9 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descri��o: | Ponto de entrada executado ap�s gerar SC9 na libera��o do pedido de venda           |  
+--------------------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function MTA440C9
Local aArea := GetArea()

If FunName() $ "MATA520/MATA521/MATA521A"
    If mv_par04 == 2
    	//Quando a NF for exclu�da, deve ficar com situa��o de apto a faturar
        SC9->C9__QTDMHA := SC9->C9_QTDLIB
    EndIf
EndIf

RestArea(aArea)
Return 