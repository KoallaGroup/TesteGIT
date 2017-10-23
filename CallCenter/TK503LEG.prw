#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | TK503LEG | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de Entrada para adicionar legenda na tela					                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function TK503LEG()  
Local _aLegendas := {}
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
	AADD(_aLegendas,{"ADE->ADE__STAT == '" + Substr(_aItens[nX],1,1) + "'",_aStatus[nX],Substr(_aItens[nX],3)})
Next nX

SetKey( K_CTRL_Q , { || TK503COR() } )
	
Return _aLegendas  


/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | TK503LEG | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de Entrada para adicionar legenda na tela					                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function TK503COR()  
Local _aItens		:= Separa(Posicione("SX3",2,"ADE__STAT","X3_CBOX"),";")
Local _aCores  		:= {}
Local _aStatus		:= {"BR_VERDE",;
						"BR_AZUL",;
						"BR_AMARELO",;
						"BR_LARANJA",;
						"BR_PRETO",;
						"BR_VERMELHO",;
						"BR_BRANCO",;
						"BR_AZUL"}
     
For nX := 1 To Len(_aItens)
	AADD(_aCores,{_aStatus[nX],Substr(_aItens[nX],3)})
Next nX

BrwLegenda(OemToAnsi("Legenda"),OemToAnsi("Status"),_aCores)

Return