#Include "protheus.ch"

//Inclusão de botões no call center
User Function TMKCBPRO()                                            
	Local _cTipo	:= IIF(FunName() == "IFATA11","C","F")
	Local nPos_Item	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" })
	Local nPos_Codigo 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	Local nPos_Descricao:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DESCRI" })
	Local nPos_Qtde		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
	Local nPos_QtdeKit	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDKIT" })
	Local nPos_CodKit	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__CODKIT" })
	Local aButtons := {}  

    AAdd(aButtons ,{ "EDIT"		,{|| U_ICOMA04()}												, "Previsao"	, "Previsao"	})  // Adcionado linha por Rogério Alves em 24/04/14
    AAdd(aButtons ,{ "EDIT"		,{|| U_IESTA07(aCols[n][nPos_Codigo],M->UA_TABELA,2,3)}			, "Similar"		, "Similar"		})  // Adcionado linha por Rubens Cruz em 05/05/14
    AAdd(aButtons ,{ "EDIT"	    ,{|| U_ITMKC12(aCols[n][nPos_Codigo],M->UA_TABELA,2,3)}			, "Tot. com IPI", "Tot. com IPI"})  // Adcionado linha por Rubens Cruz em 23/12/14
	if altera .or. inclui
	    AAdd(aButtons ,{ "EDIT"    ,{|| U_ITMKA06(nPos_Item, nPos_Codigo, nPos_Descricao, nPos_Qtde, nPos_QtdeKit, nPos_CodKit)} , "Gera Kit"	, "Gera Kit"	})
	    AAdd(aButtons ,{ "EDIT"    ,{|| U_ITMKA14()}											, "Mix Usual"	, "Mix Usual"	})  // Adcionado linha por Luis Carlos em 06/05/14  
		AAdd(aButtons ,{ "EDIT"	   ,{|| U_ITMKC08() },"Observações","Observações" })
		AAdd(aButtons ,{ "EDIT"	   ,{|| U_ITMKC10(M->UA__FILIAL, M->UA_CLIENTE, M->UA_LOJA, aCols[n][2]) },"Ultimo Preço" })
	endif
    AAdd(aButtons ,{"EDIT"		   ,{|| U_ITMKA12()}											, "Itens Regiao", "Itens Regiao"})  // Adcionado linha por Rogério Alves em 08/05/14    
	AAdd(aButtons ,{"EDIT"		   ,{|| U_IGENM06(aCols[n][nPos_Codigo]) }                      ,"Figura","Figura" })
	if ! inclui
		AAdd(aButtons ,{"EDIT"	   ,{|| U_ITMKA31() },"Itens Cancelados","Itens Cancelados" })
	endif
     
/*	If(FunName() $ "IFATA11;IFINA10") //Adicionado linha por Rubens Cruz em 25/08/2014
    	AAdd(aButtons ,{ "Criticas Ped.",{|| U_ITMKA24(M->UA__FILIAL,M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,_cTipo)}	, "Criticas Ped.", "Criticas Ped."}) 
    	AAdd(aButtons ,{ "Comissões",{|| U_ITMKA21(M->UA_NUM)}														, "Comissões", "Comissões"}) 
    	AAdd(aButtons ,{ "Indica Sit.",{|| U_IFATA13(M->UA__FILIAL,M->UA_NUM,M->UA_CLIENTE,M->UA_LOJA,_cTipo)}		, "Indica Sit.", "Indica Sit."}) 
	EndIf
*/

Return(aButtons)