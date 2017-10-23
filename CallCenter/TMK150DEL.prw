#include "protheus.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : TMK150DEL			  		| 	Abril de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi     	 														|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada para informar motivo de cancelamento do Pedido do Call Center	 		|
|-------------------------------------------------------------------------------------------------------|
*/

User Function TMK150DEL() 
Local aArea		:= GetArea()
Local aAreaSZP	:= SZP->(GetArea())
Local aAreaSZO	:= SZO->(GetArea())

	dbSelectArea("SZP")
	dbSetOrder(3)
	
    IF ( DBSEEK(xFilial("SZP") + M->UA_NUM + M->UA__FILIAL + M->UA_CLIENTE + M->UA_LOJA) ) 

		if reclock("SZP", .F.)
	    	SZP->ZP_PEDIDO := ""
		    SZP->ZP_FILPED := ""
	    	SZP->ZP_UTILIZ := "2"
			MsUnlock()
		endif 
		
		dbSelectArea("SZO")
		dbSetOrder(1) 
		dbseek(xfilial("SZO")+SZP->ZP_CODIGO+SZP->ZP_CODCLI+SZP->ZP_LOJA)

		do while .not. eof() .and. SZO->ZO_filial+SZO->ZO_CODIGO+SZO->ZO_CODCLI+SZO->ZO_LOJA ==	xfilial("SZP")+SZP->ZP_CODIGO+SZP->ZP_CODCLI+SZP->ZP_LOJA
			if reclock("SZO", .F.)
		    	SZO->ZO_PEDIDO := ""
			    SZO->ZO_FILPED := ""
		    	SZO->ZO_UTILIZ := '2'
				MsUnlock()
			endif 
			SZO->(dbSkip())
		enddo
    EndIf
  
RestArea(aArea)
RestArea(aAreaSZP)
RestArea(aAreaSZO)

Return
