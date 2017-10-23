#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+-----------+--------+----------------------+-------+------------------+
| Programa:  | TK510ABTN | Autor: |    Rubens Cuz        | Data: |   Janeiro/2015   |
+------------+-----------+--------+----------------------+-------+------------------+
| Descrição: | Ponto de entrada para remover os botoes do acoes relacionadas do     |
|			 | Service Desk					      									|
+------------+----------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+----------------------------------------------------------------------+
*/

User Function TK510ABTN()   
Local _aBotoes  := {}
Local _cSac		:= GetMV("MV__CODSAC")
Local _aExcl	:= {"Incluir"    			,;  // <-- Define quais opção não serão incluidas nas acoes relacionadas
					"Parametros" 			,;
					"Associar"   			,;
					"Alterar"   			,;
					"Visualizar"   			,;
					"Assumir"    			,;
					"Encerrar"   			,;
					"Transferir" 			,;
					"Duplicar"   			,;
					"Recorrência"			,;
					"Gerar Planilha Excel"	,;
					"Configurar atalhos"	,;
					"Config"				}
Local _nCod		:= ASCAN(oTk510Tela:oGetDados:aHeader, { |x| AllTrim(x[2]) == "ADE_CODIGO" })
Local _nStat	:= ASCAN(oTk510Tela:oGetDados:aHeader, { |x| AllTrim(x[2]) == "ADE__STAT"  })
Local _nGrup	:= ASCAN(oTk510Tela:oGetDados:aHeader, { |x| AllTrim(x[2]) == "ADE_GRUPO"  })
Local _nDel		:= Len(oTk510Tela:oGetDados:aHeader)+1
Local _cDepto	:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")

For nX := 1 To Len(ParamIXB[1])
	If(ASCAN(_aExcl, { |x| AllTrim(x) == Alltrim(ParamIXB[1][nX][4]) }) = 0)
		Aadd(_aBotoes,{ParamIXB[1][nX][1],ParamIXB[1][nX][2],ParamIXB[1][nX][4]})
	EndIf
Next nX  	        

//Altera o Status dos chamados para "Recebidos" ao abrir a rotina do operador
/*If (Len(oTk510Tela:oGetDados:aCols) > 0)  
	DbSelectArea("ADE")
	DbSetOrder(1)
	For nX := 1 To Len(oTk510Tela:oGetDados:aCols)
		If (Alltrim(_cDepto) != Alltrim(_cSac) ;
			.AND. oTk510Tela:oGetDados:aCols[nX][_nStat] == 'Abertura' ;
			.AND. oTk510Tela:oGetDados:aCols[nX][_nGrup] == _cDepto ;
			.AND. !oTk510Tela:oGetDados:aCols[nx][_nDel])

			DbSeek(xFilial("ADE")+oTk510Tela:oGetDados:aCols[nX][_nCod])
			Reclock("ADE",.F.)
				ADE->ADE__STAT := "R"			
			MsUnlock()
			oTk510Tela:oGetDados:aCols[nX][_nStat] := "Recebido"
	    EndIf
	Next nX          
EndIf  */

//Forçado refresh na janela para atualizar a cor da legenda quando mudar status para Recebido
//oTk510Tela:Refresh()

//Completa o block de marcacao do chamado para tratar o status como recebido
oTk510Tela:oGetDados:oBrowse:bLdblclick := {||ValTrans() }

Return _aBotoes  

/*
+------------+-----------+--------+----------------------+-------+------------------+
| Programa:  | ValTrans  | Autor: |    Rubens Cuz        | Data: |   Abril/2015     |
+------------+-----------+--------+----------------------+-------+------------------+
| Descrição: | Funcao para validar se o usuario pode efetuar a transferencia para   |
|			 | para outro grupo e trocar o status da manifestacao					|
+------------+----------------------------------------------------------------------+
| Uso:       | ISAPA                                                                |
+------------+----------------------------------------------------------------------+
*/

Static Function ValTrans()
Local _aArea	:= GetArea()
Local _aAreaSU7	:= SU7->(GetArea())
Local _nLin 	:= oTk510Tela:oGetDados:nAt
Local _nPosGrp	:= ASCAN(oTk510Tela:oGetDados:aHeader, { |x| AllTrim(x[2]) == "ADE_GRUPO" })
Local _cDepto	:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")
                  
If(Alltrim(_cDepto) == Alltrim(oTk510Tela:oGetDados:aCols[_nLin][_nPosGrp]) )          
	oTk510Tela:Tk503ChkBox()
	U_ETMK012()  
Else
	MsgInfo("Chamado não pertence ao grupo do operador")
EndIf

RestArea(_aAreaSU7)
RestArea(_aArea)

Return .T.