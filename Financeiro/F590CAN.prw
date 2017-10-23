#include "protheus.ch"
#include "topconn.ch"

/*
|---------------------------------------------------------------------------------------------------------------|
|	Programa : F590CAN					| 	Maio de 2015		    											|
|---------------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogerio Alves       																     	|
|---------------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada para apagar o conteudo do campo E2_IDCNAB no contas a Pagar no momento da      |
|               retirada do titulo de bordero no fina 590 ( Manutencao de Bordero)                              |
|---------------------------------------------------------------------------------------------------------------|
*/

User Function F590CAN()

local _aArea	:= getArea()

If PARAMIXB[1] == "P"

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
