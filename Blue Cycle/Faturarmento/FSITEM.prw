#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FSITEM
Gatilho que retorna o numero do ultimo item da tabela de preco

@author	
@since	
@param	cTab	Codigo da tabela
@return cCod	Codigo do prduto
/*/
//-------------------------------------------------------------------
/**********************************************************
*	Campo(s) que utiliza(m) esse fonte					  *
*	DA1_CODTAB - Ordem: 001 - Campo Afetado: DA1_ITEM	  *
**********************************************************/
/**
-->Alteracoes: Rodrigo Prates (DSM) - 25/01/11
-->Substituição da verificação da existencia de tabela temporaria por metodo generico (U_FCLOSEAREA(<"tabela">)).
-->Inserindo no cabeçalho, informação correta sobre o fonte.
-->Informando através de comentario, o(s) campo(s) que utiliza(m) o fonte.
-->Inserindo "AllTrim" nas variaveis.
-->Inserindo validacao de filial
-->Alteracao na logida do preenchimento da variavel de retorno
**/
User Function FSITEM(cTab)
	Local aArea := GetArea()
	U_FCLOSEAREA("QDA1")
	cQuery := "SELECT DA1_ITEM FROM " + RetSqlName("DA1") + " "
	cQuery += "WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND D_E_L_E_T_ = ' ' AND ROWNUM = 1"
	cQuery += "AND DA1_CODTAB = '" + AllTrim(cTab) + "' "
	cQuery += "ORDER BY DA1_ITEM DESC"
	TCQUERY cQuery ALIAS "QDA1" NEW
	cItem := StrZero((Val(QDA1->DA1_ITEM) + 1),4)
	//cItem := Val(QDA1->DA1_ITEM) + 1
	//cItem1 := StrZero(cItem,4)
//Return(cItem1)
Return(cItem)