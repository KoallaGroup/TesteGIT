/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F050ROT			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para inclusão de opções em Ações Relacionadas				  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function F050ROT()  
	local aRot := {}
    if funname() == 'FINA050'
		aRot := ParamIxb
		
		aadd( aRot, { "Distribuição", "U_IFINA09()", 0, 8 } )
	Else
		  return()
	endif
Return aRot    