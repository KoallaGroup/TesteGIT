#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103MSD	 		  		| 	Abril de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada utilizado para zerar os campos do IVA quando estornar  		|
|				classificacao de NF															  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT103MSD()
Local _aArea := GetArea()
Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSB1 := SB1->(GetArea())
Local _cChave	:= SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA)

DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(_cChave)
	Do While (_cChave = SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) .AND. !SD1->(Eof()) )
		Reclock("SD1",.F.)
			SD1->D1__CUSST  := 0
			SD1->D1__BICMST := 0
			SD1->D1__AJIVA  := 0
			SD1->D1__ALQPAD := 0
			SD1->D1__VLAGRE := 0
			SD1->D1__NFIVA	:= ""
			SD1->D1__SERIVA	:= ""
			SD1->D1__DTNOTA	:= CTOD("  /  /    ")
			SD1->D1__FORIVA	:= ""
			SD1->D1__LOJIVA	:= ""
			SD1->D1__ITEIVA	:= ""
		SD1->(MsUnlock())
		SD1->(DbSkip())
	EndDo
EndIf

RestArea(_aAreaSF1)
RestArea(_aAreaSB1)
RestArea(_aArea)

Return .T.