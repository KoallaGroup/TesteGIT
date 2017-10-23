#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA03			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cadastro de Marcas															  	|
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
|	Descrição : Validação de código  de Marcas												  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function VLCODMRC()
	dbSelectArea("SZ5")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ5")+M->Z5_CODIGO)
		msgAlert ("Já existe uma Marca com esse código !!")
		return .F.
	endif
return .T.
