#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA03			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Cadastro de Marcas															  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IESTA03()

	axCadastro("SZ5","Cadastro de Marcas")

return                 


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : VLCODMRC			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Valida��o de c�digo  de Marcas												  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function VLCODMRC()
	dbSelectArea("SZ5")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ5")+M->Z5_CODIGO)
		msgAlert ("J� existe uma Marca com esse c�digo !!")
		return .F.
	endif
return .T.
