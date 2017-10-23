#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA02			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cadastro de SubGrupos														  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IESTA02()

	axCadastro("SZ4","Cadasto de SubGrupos")

return                 


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : VLCODSUBG		  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Validação de código  de SubGrupos											  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function VLCODSUBG()
	dbSelectArea("SZ4")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ4")+M->Z4_CODIGO)
		msgAlert ("Já existe um Subgrupo com esse código !!")
		return .F.
	endif
return .T.
