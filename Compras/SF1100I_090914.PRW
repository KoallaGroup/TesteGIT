/*
|-----------------------------------------------------------------------------------------------|
|	Programa : SF1100I			  		| 	Março de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada após a gravação da NF Entrada								  	|
|-----------------------------------------------------------------------------------------------|
*/
User Function SF1100I()

local _aArea := getArea()
local _cNota
local _cSerie
local _cForn
local _cLoja
Local nPosWMSINT	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1__WMSINT"})
Local lOk	:= .F.
Local cTipo	:= ""
//If !Empty(Sf1->F1_Hawb)
//	Return

//EndIf

For x:=1 To Len(aCols)
	If !(aCols[x][Len(aCols[x])])
		_nD1__WMSINT := aCols[x][nPosWMSINT]
		exit
	EndIf
Next x

dbSelectArea("SF1")
if reclock("SF1", .F.)
	F1__WMSINT := _nD1__WMSINT
	msUnlock()
endif

_cNota 	:= SF1->F1_DOC
_cSerie	:= SF1->F1_SERIE
_cForn	:= SF1->F1_FORNECE
_cLoja	:= SF1->F1_LOJA

dbSelectArea("SD1")
dbSetOrder(1)
If dbSeek(xFilial("SD1")+_cNota+_cSerie+_cForn+_cLoja)
	
	while SD1->D1_DOC == _cNota .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cForn .and. SD1->D1_LOJA == _cLoja
		    /*
			U_ICOMA06(	SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_COD,SD1->D1_ITEM,SD1->D1_LOCAL,SD1->D1_UM,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_TES,;
						SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_CUSTO,SD1->D1_VALICM,SD1->D1_VALIPI,SD1->D1_VALPIS,SD1->D1_VALCOF,SD1->D1_VALFRE,;
						SD1->D1_PICM)
		     */
		_cPedido:= SD1->D1_PEDIDO
		_cItPed	:= SD1->D1_ITEMPC
		_nQtde	:= SD1->D1_QUANT
		_nValor	:= SD1->D1_TOTAL
		
		if !empty(_cPedido)
			dbSelectArea("SZ3")
			dbSetOrder(2)
			if dbSeek(xFilial("SZ3")+_cPedido)
				do while SZ3->Z3_PEDIDO == _cPedido
					
					if SZ3->Z3_ITPEDCO == _cItPed
						
						if reclock("SZ3", .F.)
							SZ3->Z3_QTDESEM	+= _nQtde
							SZ3->Z3_VLDESEM += _nValor
							msUnlock()
						endif
						
					endif
					
					SZ3->(dbSkip())
				enddo
			endif
			
		endif
		
		SD1->(dbSkip())
	enddo
	
EndIf

restArea (_aArea)
return
