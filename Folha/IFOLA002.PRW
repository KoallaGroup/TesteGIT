/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFOLA002			  		| 	Janeiro de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para gravação dos tipos de lançamentos das comissões					 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function IFOLA002()

	local cFiltro		:= ""
	private cAlias   	:= "Z24"
	private cCadastro	:= "Tipos de Lançamentos de Comissões"
	private aRotina  	:= {{"Pesquisar" 	, "AxPesqui" 	, 0, 1 },;
	                        {"Visualizar" 	, "axVisual"   	, 0, 2 },;
	                        {"Incluir"    	, "axInclui"   	, 0, 3 },;
	                        {"Alterar"      , "axAltera"   	, 0, 4 },;
	                        {"Excluir"      , "axDeleta"   	, 0, 5 }}
	
	dbSelectArea("Z24")
	dbSetOrder(1)
	
	mBrowse( ,,,,"Z24",,,,,,,,,,,,,,cFiltro)

Return    

