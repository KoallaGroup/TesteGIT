/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT240INC	 		  		| 	Fevereiro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para excluir dados do FUNDAP e REOA						  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function MT241EST()
	_nDoc	:= SD3->D3_DOC
	_cSerie	:= 'SD3'

	dbSelectArea("Z25")
	dbSetOrder(1)
	
	if dbSeek(xFilial("Z25")+_nDoc+_cSerie)
		do while Z25->Z25_DOC == _nDoc .and. Z25->Z25_SERIE == _cSerie
			if reclock("Z25", .F.)
				delete
				msUnlock()				
			endif
			Z25->(dbSkip())
		enddo		
	endif
	
return