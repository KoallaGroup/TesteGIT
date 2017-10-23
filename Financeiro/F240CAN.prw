#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|
|	Programa : F240CAN					| 	Maio de 2015		    											|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogerio Alves       																     	|
|---------------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada para apagar o conteudo do campo E2_IDCNAB no contas a Pagar no momento da      |
|               exclusao do bordero no fina240 ( Bordero de Pagamentos )                                        |
|---------------------------------------------------------------------------------------------------------------|
*/

User Function F240CAN()

local _aArea	:= getArea()

If SEA->EA_CART == "P"

	dbSelectArea("SE2")
	dbSetOrder(1)
	If DbSeek(SE2->E2_FILIAL+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCELA)	
		recLock("SE2",.F.)
		SE2->E2_IDCNAB := ""
		SE2->(msUnlock())
	EndIf
	
EndIf

restArea(_aArea)

Return .t.