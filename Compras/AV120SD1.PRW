#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : AV120SD1 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar tabelas do REOA								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function AV120SD1() 
	
	local _aArea := getArea()

alert ("aquI")
                                  
	dbSelectArea("Z12")

	if reclock("Z12", .T.)
	    Z12->Z12_FILIAL	:= xFilial("Z12")
	    Z12->Z12_LOCAL 	:= SD1->D1_LOCAL
	    Z12->Z12_DOC   	:= SD1->D1_DOC
	    Z12->Z12_SERIE 	:= SD1->D1_SERIE
	    Z12->Z12_FORNEC	:= SD1->D1_FORNECE
	    Z12->Z12_LOJA  	:= SD1->D1_LOJA
	    Z12->Z12_ITEM  	:= SD1->D1_ITEM 
	    Z12->Z12_QUANT 	:= SD1->D1_QUANT
	    Z12->Z12_CODPRO	:= SD1->D1_COD
	    Z12->Z12_SALDO 	:= SD1->D1_QUANT
	    Z12->Z12_DTENTR	:= SD1->D1_DTDIGIT
	    Z12->Z12_RECSD1	:= SD1->(RECNO())
	
		msUnlock()
	endif

	restarea(_aArea)
	
return 