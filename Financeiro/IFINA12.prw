#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Função : IFINA12			 		| 	Fevereiro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi						                				|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de inclusão dos tipos de Cobrança										  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFINA12()

dbSelectArea("ZX5")
dbSetOrder(1)

Set Filter to ZX5->ZX5_GRUPO == "000010"

AXCADASTRO("ZX5")

Return
