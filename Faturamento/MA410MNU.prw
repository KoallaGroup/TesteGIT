#Include "Protheus.ch"
/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | MA410MNU | Autor |  Silverio Bastos - Anadi | Data |Novembro/2014|
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Ponto de Entrada para adicionar opçao no menu principal Pedido de|
|          | Venda					                                          |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function MA410MNU()
	aAdd( aRotina, {'Envio WMS'	   ,'U_IRECWMS("SC5")', 0, 2,0,NIL})
	aAdd( aRotina, {'Geração NF'   ,'U_IFATA26()' 	  , 0 ,2,0,NIL})   
	aAdd( aRotina, {'Lib. Faturar' ,'U_IFATA31()'     , 0 ,2,0,NIL})
Return