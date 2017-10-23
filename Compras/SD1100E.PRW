#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : SD1100E	 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar tabelas do REOA na exclusão de NF de Entrada	  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function SD1100E()
	
	local _aAreaSZ3 := SZ3->(getArea())
	local _aArea 	:= getArea()
	local _cNumero 	:= SD1->D1_DOC
	local _cSerie   := SD1->D1_SERIE                         
	local _cFornece := SD1->D1_FORNECE
	local _cLoja    := SD1->D1_LOJA
	local _cCod     := SD1->D1_COD
	Local _cItem	:= SD1->D1_ITEM
	Local _nQtde	:= SD1->D1_QUANT
	Local _nValor	:= SD1->D1_TOTAL
	Local _cCodImp	:= Posicione("SZ3",2,xFilial("SZ3")+SD1->D1_PEDIDO+SD1->D1_FORNECE+SD1->D1_LOJA,"Z3_CODIGO")

	dbSelectArea("SF4")
	dbSetOrder(1)
	dbSeek(xFilial("SF4") + SD1->D1_TES)
	
	if SF4->F4_ESTOQUE == "S"
		   	
		dbSelectArea("Z12")  
		dbSetOrder(1)
		
		if dbSeek(xFilial("Z12")+_cNumero+_cSerie+_cFornece+_cLoja+_cCod)
			if Z12->Z12_SALDO == Z12->Z12_QUANT
				if reclock("Z12", .F.)
				    delete					
					msUnlock()
				endif
			endif
		endif
	endif


	// Exclusão da Nota da tabela de controle Fundap
	dbSelectArea("Z25")  
	dbSetOrder(1)
	if dbSeek(xFilial("Z25")+_cNumero+_cSerie+_cFornece+_cLoja+_cCod)
		if reclock("Z25", .F.)
		    delete					
			msUnlock()
		endif
	endif

				
//Rubens Cruz - Jan/2015 > Criada rotina para excluir quantidade da SZ3 ao excluir a nota
	dbSelectArea("SZ3")
	dbSetOrder(5)
	if DbSeek(xFilial("SZ3") + SD1->D1__CODPRO + SD1->D1_PEDIDO + SD1->D1_ITEMPC + SD1->D1_FORNECE + SD1->D1_LOJA)
		if reclock("SZ3", .F.)
			SZ3->Z3_QTDESEM	:= SZ3->Z3_QTDESEM - SD1->D1_QUANT
			SZ3->Z3_VLDESEM := SZ3->Z3_VLDESEM - SD1->D1_TOTAL
			msUnlock()
		endif
	endif
    
    //Exclui o complemento de importação
    DbSelectArea("CD5")
    DbSetOrder(4)
    If DbSeek(xFilial("CD5") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM)
		Reclock("CD5",.F.)
        Delete
        MsUnlock()
    EndIf
	
	restarea(_aAreaSZ3)
	restarea(_aArea)	
return 	