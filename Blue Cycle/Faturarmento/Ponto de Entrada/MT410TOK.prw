

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �MT410TOK        �Autor �Rafael Strozi     � Data � 28/12/11 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E. para valida��o do pedido antes da Inclus�o, Altera��o ���
���          � ou Csncelamento                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/                                                        


User Function MT410TOK()

     Local lRetorno := .T.
     Local aProd          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_PRODUTO"})
     Local aTES          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_TES"})
     Local aCST          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_CLASFIS"})
     Local aItem          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_ITEM"})
     Local aQtdLib          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDLIB"})
     Local aQtdVen          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDVEN"})
     Local aQtdEmp          := aScan(aHeader,{|x| AllTrim(x[2]) == "C6_QTDEMP"})
     Local cProduto     := ""
     Local cTES          := ""
     Local cCSTAtual     := ""     
     Local cItem          := ""     
     Local nX          := 0
     Local cOrigem     := ""
     Local cST          := ""     
     Local cCSTOk     := ""
     Local nCont          := 0
     Local nQtdVen := 0
     Local nQtdEmp := 0
     
	 M->C5__STATUS := cStatus     

     For nX := 1 to Len(aCols)
          nQtdVen := aCols[nX][aQtdVen]
          //nQtdEmp := aCols[nX][aQtdEmp]  ALTERADO POR VALDEMIR DO CARMO EM 08/02/16
          aCols[nX][aQtdLib] := 0 //nQtdVen//-nQtdLib
//          sc6->c6_qtdkit := 1
          
          /*cProduto     := aCols[nX][aProd]
          cTES          := aCols[nX][aTES]
          cCSTAtual     := aCols[nX][aCST]     
          cItem          := aCols[nX][aItem]
          cOrigem          := Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_ORIGEM")
          cST               := Posicione("SF4",1,xFilial("SF4")+cTES,"F4_SITTRIB")     
          cCSTOk          := Alltrim(cOrigem)+Alltrim(cST)
          
          
          If cCSTAtual <> cCSTOk
               Aviso("Aten��o","Campo aspassimplesSit.Trib.aspassimples do item "+cItem+" - "+cProduto+" inconsistente! Est� "+cCSTAtual+" e deveria ser "+cCSTOK+" . D� <ENTER> no campo TES para corrigir!",{"Ok"})
               nCont++          
          EndIf */
     
     Next
     /*
     If nCont > 0
          lRetorno := .F.
     EndIf  */
     
Return(lRetorno)