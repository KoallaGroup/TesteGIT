#Include "Protheus.ch"

//Validador do produto no call center
User Function ITMKP01()
Local _aArea	:= GetArea()
Local _aAreaSUB	:= SUB->(GetArea())
Local lRet   	:= .T.
Local nCont  	:= 0
Local _nPItem   := aScan(aHeader,{ |x|Alltrim(x[2]) == "UB_ITEM"})
Local nPos		:= aScan(aHeader,{ |x|Alltrim(x[2]) == "UB_PRODUTO"})
Local nRecno	:= aScan(aHeader,{ |x|Alltrim(x[2]) == "UB_REC_WT"})
Local nDesc		:= aScan(aHeader,{ |x|Alltrim(x[2]) == "UB_DESCRI"})
Local nQuant	:= aScan(aHeader,{ |x|Alltrim(x[2]) == "UB__QTDSOL"})

If lTk271Auto
    Return .t.
EndIf

//----------------------------------------------------------//
// VERIFICACAO DE DUPLICIDADE DE PRODUTOS NO CALL CENTER    //
//----------------------------------------------------------//

If( "UB_PRODUTO" $ ReadVar() )
/*
	If Posicione("SB1",1,xFilial("SB1") + M->UB_PRODUTO,"B1__SEGISP") != M->UA__SEGISP
		Help( Nil, Nil, "PRODSEGTO", Nil, "Este produto não pertence ao seu segmento.", 1, 0 )
		lRet := .F.
	EndIf
*/
	For nX := 1 To Len(aCols)
		IF M->UB_PRODUTO == aCols[nX,nPos] .and. !(aCols[nX][len(aheader)+1]) .And. nx != n
			nCont++
			Exit
		Endif
	Next nX
	
	If nCont > 0
		Help( Nil, Nil, "PRODEXIST", Nil, "Este produto já se encontra no item " + aCols[nX,nCont] + " do pedido/cotação", 1, 0 )
		lRet	:= .F.
	EndIf
	
	/*
	+----------+----------+-------+--------------------------+------+-----------------+
	|Programa  | ITMKP01  | Autor |  Rubens Cruz  - Anadi    | Data |  Novembro/2014  |
	+----------+----------+-------+--------------------------+------+-----------------+
	|Descricao | Valida se poderá ser incluso ou alterado o produto na reabertura     |
	|          | do pedido 															  |
	+----------+----------------------------------------------------------------------+
	*/
	
	If(M->UA__TPREAB == "2")
		If(aCols[n,nRecno] = 0)
			Alert("Não é permitida a inclusão de novos itens")
			aCols[n,nDesc] := ""
			lRet := .F.
		EndIf
	EndIf
ElseIf( "UB__QTDSOL" $ ReadVar() )

	/*
	+----------+----------+-------+--------------------------+------+-----------------+
	|Programa  | ITMKP01  | Autor |  Rubens Cruz  - Anadi    | Data |  Novembro/2014  |
	+----------+----------+-------+--------------------------+------+-----------------+
	|Descricao | Não permit aumento da quantidade do produto no caso de reativacao    |
	|          | do tipo alteração													  |
	+----------+----------------------------------------------------------------------+
	*/
	If(M->UA__TPREAB == "2")
		If(aCols[n][nRecno] > 0)
			DbSelectArea("SUB")
			DbGoTo(aCols[n][nRecno]) //Precisa buscar da SUB para o caso do usuario querer voltar a quantidade original do pedido
			
			If(M->UB__QTDSOL > SUB->UB__QTDSOL)	
				Alert("Não é permitido aumentar a quantidade dos itens no pedido")
				lRet := .F.
			EndIf
		EndIf
	EndIf
EndIf

RestArea(_aAreaSUB)
RestArea(_aArea)

Return (lRet)