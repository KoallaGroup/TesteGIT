#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | TK510COR | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de Entrada para adicionar legenda na tela do ServiceDesk	                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function TK510COR()
Local _aArea		:= GetArea()
Local _aLegendas 	:= {}    
Local nX			:= 0 
Local _cQuery		:= ""
Local _aItens		:= Separa(Posicione("SX3",2,"ADE__STAT","X3_CBOX"),";")
Local _cDepto		:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")
Local _aStatus		:= {"BR_VERDE",;
						"BR_AZUL",;
						"BR_AMARELO",;
						"BR_LARANJA",;
						"BR_PRETO",;
						"BR_VERMELHO",;
						"BR_BRANCO",;
						"BR_AZUL"}
                                    
For nX := 1 To Len(_aItens)
	AADD(_aLegendas,{"ADE->ADE__STAT == '" + Substr(_aItens[nX],1,1) + "'",_aStatus[nX]})  
Next nX

     
//Ponto de entrada usado para alterar o Status do ServiceDesk para Recebido ao carregar janela
If (select("TMPADE") > 0)
	TRB_SLD->(DbCloseArea())
EndIf

_cQuery	:= "SELECT ADE_CODIGO,                          " + Chr(13)
_cQuery	+= "       ADE.R_E_C_N_O_ RECNOADE              " + Chr(13)
_cQuery	+= "FROM "  +RetSqlName("ADE") + " ADE          " + Chr(13)
_cQuery	+= "WHERE ADE.D_E_L_E_T_ = ' '                  " + Chr(13)
_cQuery	+= "      AND ADE.ADE_GRUPO = '" + _cDepto + "' " + Chr(13)
_cQuery	+= "      AND ADE.ADE__STAT = 'A'               "
TCQUERY _cQuery NEW ALIAS "TMPADE"
               
While !(eof())
	DbSelectArea("ADE")
	DbGoTo(TMPADE->RECNOADE)	
	Reclock("ADE",.F.)
//		ADE->ADE__STAT := "R"
	MsUnlock()
	DbSelectArea("TMPADE")
	DbSkip()
EndDo

TMPADE->(DbCloseArea())

RestArea(_aArea)

Return _aLegendas