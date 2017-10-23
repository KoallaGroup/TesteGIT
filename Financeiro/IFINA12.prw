#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Fun��o : IFINA12			 		| 	Fevereiro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi						                				|
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Tela de inclus�o dos tipos de Cobran�a										  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFINA12()

dbSelectArea("ZX5")
dbSetOrder(1)

Set Filter to ZX5->ZX5_GRUPO == "000010"

AXCADASTRO("ZX5")

Return
