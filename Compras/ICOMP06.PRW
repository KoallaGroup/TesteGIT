/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMP06			  		| 	Julho de 2014					  		            |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi					        	                |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Acionado pelo Ponto de Entrada A100DEL na exclusão da NF Entrada	            |
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMP06()
	local _aArea 	:= getArea()
	Local _aSD3		:= SD3->(GetArea())
	local _cNota	:= ""
	local _cSerie	:= ""
	local _cForn	:= ""
	local _cLoja	:= ""
	Local _cPedido	:= ""
	Local _cItPed	:= ""
	Local _nQtde	:= ""
	Local _nValor	:= ""
	Local _lValid	:= .T.
	
	PRIVATE lMsHelpAuto := .T.
	PRIVATE lMsErroAuto := .F.
	PRIVATE _aProd	  	:= {}
	
	_cNota 	:= SF1->F1_DOC
	_cSerie	:= SF1->F1_SERIE
	_cForn	:= SF1->F1_FORNECE
	_cLoja	:= SF1->F1_LOJA
	
	DbSelectArea("SD3")
	DbOrderNickName("SD3NF")	//D3_FILIAL+D3__DOC+D3__SERIE+D3__FORNEC+D3__LOJA+D3_COD+D3__ITEM
	If DbSeek(xFiliaL("SD3") + _cNota + _cSerie + _cForn + _cLoja)
		
		//Begin Transaction
		
		While !(eof()) .and. SD3->D3_FILIAL == xFilial("SD3") + SD3->D3__DOC == _cNota .and. SD3->D3__SERIE == _cSerie .and.; 
							 SD3->D3__FORNEC == _cForn .and. SD3->D3__LOJA == _cLoja
            /*
			Reclock("SD3",.F.)
			DbDelete()
			Msunlock()
		    */
            _aProd := {} 
			_aSD3 := SD3->(GetArea())
            
            lMsErroAuto := .F.
			aAdd(_aProd,{{"D3_FILIAL"	,SD3->D3_FILIAL , NIL},;
						 {"D3_COD"		,SD3->D3_COD	, NIL},;
						 {"D3_LOCAL"	,SD3->D3_LOCAL	, NIL},;
						 {"D3_NUMSEQ"	,SD3->D3_NUMSEQ , NIL},;
						 {"D3_CF"		,SD3->D3_CF     , NIL},;
						 {"D3_TM"		,SD3->D3_TM     , NIL},;
						 {"INDEX"		,3				, NIL} })
			
			MSExecAuto({|x,y| MATA240(x,y)}, _aProd[1], 5) // Operacao de estorno do movimento interno (SD3)
			
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
			EndIf                       
			
            RestArea(_aSD3)
			
			DbSelectArea("SD3")
			DbSkip()
			
		enddo
		
		//End Transaction
		
	EndIf

	RestArea(_aArea)
	
return _lValid
