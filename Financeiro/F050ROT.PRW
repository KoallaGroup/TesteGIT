/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : F050ROT			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Ponto de entrada para inclus�o de op��es em A��es Relacionadas				  	|
|-----------------------------------------------------------------------------------------------|	
*/

user function F050ROT()  
	local aRot := {}
    if funname() == 'FINA050'
		aRot := ParamIxb
		
		aadd( aRot, { "Distribui��o", "U_IFINA09()", 0, 8 } )
	Else
		  return()
	endif
Return aRot    