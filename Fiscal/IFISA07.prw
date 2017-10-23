#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IFISA07			  		| 	Marco de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto Ferraraz Pereira Alves - Anadi										|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Programa para gravacao de aliquotas por UF utilizados no calculo do IVA					|
|-------------------------------------------------------------------------------------------------------|
*/

user Function IFISA07()

Local _aArea   	  := getArea()   
Local cFiltro     := ""


private cCadastro	:= "Cadastro de % Aliquota"
private aRotina		:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","axInclui",0,3},;
						{"Excluir","axDeleta",0,5},;
						{"Alterar","axAltera",0,4}} 
						
		dbSelectArea("Z29")
		dbSetOrder(1)
		mBrowse( ,,,,"Z29",,,,,,,,,,,,,,cFiltro)
									
restArea(_aArea)

return