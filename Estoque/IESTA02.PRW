#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA02			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Cadastro de SubGrupos														  	|
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
|	Descri��o : Valida��o de c�digo  de SubGrupos											  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function VLCODSUBG()
	dbSelectArea("SZ4")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ4")+M->Z4_CODIGO)
		msgAlert ("J� existe um Subgrupo com esse c�digo !!")
		return .F.
	endif
return .T.
