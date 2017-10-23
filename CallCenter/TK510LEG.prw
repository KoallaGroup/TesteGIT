#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | TK510LEG | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de Entrada para adicionar legenda na tela do ServiceDesk	                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function TK510LEG()  
Local _aLegendas 	:= {}    
Local nX			:= 0
Local _aItens		:= Separa(Posicione("SX3",2,"ADE__STAT","X3_CBOX"),";")
Local _aStatus		:= {"BR_VERDE",;
						"BR_AZUL",;
						"BR_AMARELO",;
						"BR_LARANJA",;
						"BR_PRETO",;
						"BR_VERMELHO",;
						"BR_BRANCO",;
						"BR_AZUL"}
                                    
For nX := 1 To Len(_aItens)
	AADD(_aLegendas,{_aStatus[nX],Substr(_aItens[nX],3)})
Next nX
  

Return _aLegendas