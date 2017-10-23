/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT241GRV	 		  		| 	Fevereiro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para gravar dados do FUNDAP								  	|
|-----------------------------------------------------------------------------------------------|	
*/


user function MT241GRV()
	_nDoc	:= SD3->D3_DOC

	dbSelectArea("SD3")
	dbSetOrder(2)
	
	if Inclui
		if dbSeek(xFilial("SD3")+SD3->D3_DOC)
			do while SD3->D3_DOC == _nDoc
				U_MT240INC()    	// Rotina que faz gravação do Fundap e REOA	
				SD3->(dbSkip())
			enddo		
		endif
		
	endif
	
return