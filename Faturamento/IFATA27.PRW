#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATA27			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Valida o Segmento do Produto												  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function IFATA27()
	local _lRet := .T.
	Local _nPDescri := aScan(aHeader,{|x| AllTrim(x[2])=="C6_DESCRI"})                             
                                       
	if ! empty(M->C5__SEGISP)
		if Posicione("SB1",1,xFilial("SB1") + M->C6_PRODUTO,"B1__SEGISP") != M->C5__SEGISP                             
			msgAlert ("Produto com Segmento diferente do Segmento selecionado. Favor verificar !!")
			aCols[n][_nPDescri] := Space(TamSX3("C6_DESCRI")[1])
		   	_lRet := .F.
		endif   
	endif
	
return _lRet