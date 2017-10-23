#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFINA04			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para gravação de dados da SM0 para a SZE								 		|
|-------------------------------------------------------------------------------------------------------|	
*/

user Function IFINA04()
             
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01"

	_aArea := getArea()

	dbSelectArea("SM0")
	SM0->(dbGotop())
	do while ! SM0->(EOF())
		dbSelectArea("SZE")
		dbSetOrder(1)
		
		if ! dbSeek(SM0->(M0_CODIGO+M0_CODFIL))
		     
			While !recLock("SZE",.T.)
			EndDo
						
			SZE->ZE_CODIGO 	:= SM0->M0_CODIGO
			SZE->ZE_CODFIL 	:= SM0->M0_CODFIL
			SZE->ZE_FILIAL 	:= SM0->M0_FILIAL
			SZE->ZE_NOME   	:= SM0->M0_NOME
			SZE->ZE_NOMECOM	:= SM0->M0_NOMECOM
			SZE->ZE_ESTCOB 	:= SM0->M0_ESTCOB
			SZE->ZE_CGC    	:= SM0->M0_CGC
			SZE->ZE_CIDCOB 	:= SM0->M0_CIDCOB
			SZE->ZE_INSC   	:= SM0->M0_INSC
			msUnlock()
		
		endif	
	
		dbSelectArea("SM0")
		SM0->(dbSkip())
	enddo               
	
	restArea(_aArea)
	
reset environment



