#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | A410CONS | Autor |  Rogério Alves  - Anadi  | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Ponto de entrada para consultar Previsao de Chegada compras      |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function A410CONS()

Local _aButtons := {}

AAdd(_aButtons,{"RELATORIO"	,{|| U_ITMKA12()}					, "Itens Regiao"	 , "Itens Regiao"     })
AAdd(_aButtons,{"RELATORIO"	,{|| Execblock("ICOMA04",.F.,.F.)}	, "Previsao Entrega" , "Previsao Entrega" })

If AtIsRotina("A410INCLUI")
	AADD(_aButtons,{"RELATORIO", { || U_CrossDPed() }, "Imp. Crossdocking", "Imp. Crossdocking" })
EndIf
                                                                   	
Return(_aButtons)
