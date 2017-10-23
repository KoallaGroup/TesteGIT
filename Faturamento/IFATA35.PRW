#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATA35			  		| 	Maio de 2015    				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi										                |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Gatilho acionado pelo inicializador padrão do campo F2__NUMSUA para tazer o  	|
|               numero do pedido da sc5                                                         |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATA35()

Local cNumPed := ""

If !(SF2->F2_TIPO $ "D/B")
	DbSelectArea("SD2")
	DbSetOrder(3)
	If DbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
		cNumPed := Posicione("SC5",1,SD2->D2_FILIAL + SD2->D2_PEDIDO + SD2->D2_ITEMPV,"C5__NUMSUA")
	EndIf
EndIf

return cNumPed
