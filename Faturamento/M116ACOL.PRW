#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : M116ACOL	 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para incluir valores em acols de campos customizados no	  	|
|				Conhecimento de Frete														  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function M116ACOL()

	local _cAlias	:= PARAMIXB[1]		//-- Alias do Arq. NF Entrada itens
	local _nLin		:= PARAMIXB[2]		//-- Número da linha do aCols correspondente
	local _aDados	:= PARAMIXB[3]		//-- Vetor contendo as informações de documento e fornecedor posicionados pelo cabeçalho da nota fiscal processada
	local _nPNF		:= aScan(aHeader,{|x|x[2] = "D1__NFORIG"})
	local _nPSer	:= aScan(aHeader,{|x|x[2] = "D1__SERORI"})
	local _nPIte	:= aScan(aHeader,{|x|x[2] = "D1__ITEMOR"})
	local _nPFor	:= aScan(aHeader,{|x|x[2] = "D1__FORORI"})
	
	If alltrim(CESPECIE) == "CTR"
		aCols[_nLin][_nPNF]		:= (_cAlias)->D1_DOC
		aCols[_nLin][_nPSer] 	:= (_cAlias)->D1_SERIE
		aCols[_nLin][_nPIte]	:= (_cAlias)->D1_ITEM
		aCols[_nLin][_nPFor]	:= (_cAlias)->D1_FORNECE
	EndIf
	
Return