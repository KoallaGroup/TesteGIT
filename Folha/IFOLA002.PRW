/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFOLA002			  		| 	Janeiro de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descri��o : Programa para grava��o dos tipos de lan�amentos das comiss�es					 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function IFOLA002()

	local cFiltro		:= ""
	private cAlias   	:= "Z24"
	private cCadastro	:= "Tipos de Lan�amentos de Comiss�es"
	private aRotina  	:= {{"Pesquisar" 	, "AxPesqui" 	, 0, 1 },;
	                        {"Visualizar" 	, "axVisual"   	, 0, 2 },;
	                        {"Incluir"    	, "axInclui"   	, 0, 3 },;
	                        {"Alterar"      , "axAltera"   	, 0, 4 },;
	                        {"Excluir"      , "axDeleta"   	, 0, 5 }}
	
	dbSelectArea("Z24")
	dbSetOrder(1)
	
	mBrowse( ,,,,"Z24",,,,,,,,,,,,,,cFiltro)

Return    

