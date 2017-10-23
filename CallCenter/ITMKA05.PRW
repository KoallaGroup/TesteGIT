/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA05				 	| 	Abril de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para validação do produto do pedido da Call Center		  	  	|
|-----------------------------------------------------------------------------------------------|
*/

user Function ITMKA05()

local _lRet	:= .T.
local aArea	:= GetArea()

if (SB1->B1__BLQKIT == '1') .And. !lTk271Auto
	msgAlert ("Esse Produto deve não pode ser vendido separadamente. Somente com o kit !!")
	_lRet := .F.
endif

If _lRet 
    _lRet := ITMKA05A()
EndIf

restArea(aArea)

return _lRet


/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ITMKA05A | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Rotina acionada pelo validador do campo para verificar se o      |
|          | pedido for de Brinde, para colocar apenas os produtos que estão  |
|          | no grupo de Brinde                                               |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/


Static Function ITMKA05A()

Local cTpPedido := Posicione("SZF",1,xFilial("SZF")+M->UA__TIPPED,"ZF_BRINDE")
Local cGrupo	:= ""
Local cProd		:= ""
Local cDesc		:= ""
Local nPosProd	:= ""
Local cGrupoPar	:= ""

If cTpPedido == "1"
	
	//cGrupoPar	:= U_IESTA08()
	nPosProd	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	cProd		:= aCols[n][nPosProd]
	cGrupo		:= Posicione("SBM",1,xFilial("SBM") + Posicione("SB1",1,xFilial("SB1")+cProd,"B1_GRUPO"),"BM__BRINDE")
	
	If cGrupo != "1"
		Alert("Produto não pertence ao grupo de Brinde")
		//Acols[n][Len(aHeader)+1]   := .T.
		Return .F.
	EndIf
	
EndIf

Return .T.