#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ITMKA18  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Valida os produtos caso o tipo de produto seja brinde            |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/


User Function ITMKA18()

Local aArea		:= GetArea()
Local cTpPedido := Posicione("SZF",1,xFilial("SZF")+M->UA__TIPPED,"ZF_BRINDE")
Local nPosProd	:= 0
Local cProd		:= ""
Local cGrupoPar	:= ""
Local cGrupo	:= ""
Local lOk		:= .T.

Private cEOL    := CHR(13)+CHR(10)

If cTpPedido == "1"
	
	cGrupoPar	:= U_IESTA08()
	nPosProd 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	
	For i:=1 to Len(aCols)
		
		If !(aCols[i][len(aHeader)+1]) .And. !Empty(aCols[i][nPosProd])
			alert("OK")
			cProd 		:= aCols[i][nPosProd]
			cGrupo		:= Posicione("SB1",1,xFilial("SB1")+cProd,"B1_GRUPO")
			
			//If !(cGrupo $ cGrupoPar)
			If !(Posicione("SBM",1,xFilial("SBM") + cGrupo,"BM__BRINDE") == "1")
				lOk := .F.
				Exit
			EndIf
		EndIf
		
	Next
	
	If !lOk
		Alert("Tipo de pedido não poderá ser alterado" 	+ cEOL +;
		      "pois existem produtos que não pertencem" + cEOL +;
		      "ao grupo de brinde")
	EndIf
	
EndIf

RestArea(aArea)

Return lOk