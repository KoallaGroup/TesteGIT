 #Include "protheus.ch"
 
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA05			  		| 	Abril de 2014		 			  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cadastro de Conversão de Unidades de Medidas								  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IESTA05()

	axCadastro("SZQ", "Cadastro de Tabela de Conversao", ".T.", "U_IESTA05B()")

return                 


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA05A		  		| 	Abril de 2014				  		   					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Busca de Descrição das Unidades de Medidas									  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IESTA05A(_cCampo)
	_aArea := getArea()
	
	dbSelectArea("SAH")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SAH")+&("M->ZQ_UM"+_cCampo))
		msgAlert ("Unidade de Medida não Encontrada !!")
		return .F.
	endif                      
	&("M->ZQ_DESC"+_cCampo) := SAH->AH_DESCPO
	
	restArea(_aArea)
return .T.
                                                                           

user Function IESTA05B()

	_lRet := .T.              

	_nRecAtual := SZQ->(RECNO())
	            
	dbSelectArea("SZQ")
	dbSetOrder(1)
	if dbSeek(xFilial("SZQ")+M->ZQ_UM1+M->ZQ_UM2)      
		if Inclui
			_lRet := .F.
		endif
		if Altera .and. _nRecAtual != SZQ->(RECNO())
			_lRet := .F.
		endif
	endif                      
	
	if ! _lRet
		msgAlert ("Conversão entre essas unidades já cadastradas !!")
	endif

return _lRet