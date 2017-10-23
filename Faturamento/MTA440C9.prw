#INCLUDE "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | MTA440C9 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de entrada executado após gerar SC9 na liberação do pedido de venda           |  
+--------------------------------------------------------------------------------------------------+
| Uso:       | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function MTA440C9
Local aArea := GetArea()

If FunName() $ "MATA520/MATA521/MATA521A"
    If mv_par04 == 2
    	//Quando a NF for excluída, deve ficar com situação de apto a faturar
        SC9->C9__QTDMHA := SC9->C9_QTDLIB
    EndIf
EndIf

RestArea(aArea)
Return 