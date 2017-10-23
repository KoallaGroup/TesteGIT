#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKA29 | Autor: |    Rubens Cruz       | Data: |   Outubro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Função para validar o Tipo de pedido no call center      	      |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKA29()
Local _aArea	:= GetArea()
Local lRet		:= .T.                    
Local _nQatu	:= 0
Local nMaxRes	:= Posicione("SA3",1,xFilial("SA3")+M->UA_VEND,"A3__MAXRES") 
Local nSemRes	:= SA3->A3__SEMRES 
Local _nAt		:= n
Local _nPosPrd  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_PRODUTO"})
Local _nPosLoc  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_LOCAL"})
Local _nPosIte  := aScan(aHeader,{|x| AllTrim(x[2])=="UB_ITEM"})
Local _nPosQt   := aScan(aHeader,{|x| AllTrim(x[2])=="UB_QUANT"})

If M->UA__PRVFAT > M->UA_EMISSAO .And. Val(M->UA__TIPPED) != 2 .And. Val(M->UA__TIPPED) != 3 
    Help( Nil, Nil, "DTPRVFAT", Nil, "Tipo de pedido nao pode ser utilizado em data de faturamento programada", 1, 0 )
    Return .f.
ElseIf M->UA__PRVFAT == M->UA_EMISSAO .And. (Val(M->UA__TIPPED) == 2 .Or. Val(M->UA__TIPPED) == 3) 
    Help( Nil, Nil, "DTPRVFAT", Nil, "Tipo de pedido nao pode ser utilizado para data de faturamento nao programada", 1, 0 )
    Return .f.
EndIf

/*Mudança das regras - Jorge H.
If(M->UA__PRVFAT > M->UA_EMISSAO)
	M->UA__TIPPED := "2"
ElseIf(alltrim(M->UA__TIPPED) $ '24' .AND. (M->UA__PRVFAT > M->UA_EMISSAO)) //(M->UA__PRVFAT - Date() > nSemRes) )
	M->UA__TIPPED := "1"
EndIf

//	lRet := .F.
//	alert("Pedido sem reserva maior que o permitido")

If (alltrim(M->UA__TIPPED) $ '2') 
	If (M->UA__PRVFAT - M->UA_EMISSAO < nMaxRes .AND. M->UA__PRVFAT > M->UA_EMISSAO )   
		M->UA__RESEST := "S"
		
		For nx := 1 To Len(aCols)
			If (!aCols[nx][Len(aHeader) + 1] .AND. !Vazio(aCols[nX][_nPosPrd]) )
				n := nx
				U_ITMKA09(aCols[nX][_nPosPrd],aCols[nX][_nPosLoc],aCols[nX][_nPosIte],aCols[nX][_nPosQt],.F.)
			EndIf
		Next nx
		n := _nAt
		
	Else
		M->UA__RESEST := "N"
	EndIf
EndIf
*/

RestArea(_aArea)

Return lRet