#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TK510GRV			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi									 		|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada antes da gravacao do teleatendimento - Call Center				|
|-----------------------------------------------------------------------------------------------|
*/

User Function TK510GRV                            
Local _aArea 	:= getArea()
Local cNumYP 	:= "" 

Public lValTMK := .F. 
Public cNumYY := ""

	If INCLUI
		DbSelectArea("SU9")
		SU9->(dbSetOrder(2))
		If DbSeek(xFilial("SU9")+M->ADE_CODSU9)
			If M->ADE_GRUPO <> SU9->U9__GRPATE 
				M->ADE_GRUPO  := SU9->U9__GRPATE 
				M->ADE_DESCGP := posicione("SU0",1,xFilial("SU0")+SU9->U9__GRPATE,"U0_NOME")	
				
			    DbSelectArea("SYP")
			    If Reclock("SYP", .T.)
			    	cNumYP 			:= GetSX8Num( "SYP", "YP_CHAVE" )
					SYP->YP_FILIAL	:= xFILIAL("SYP")
					SYP->YP_CHAVE 	:= cNumYP
					SYP->YP_SEQ		:= "001"
					SYP->YP_TEXTO   := "Transferencia entre equipes do chamado. Equipe transferida: "+SU9->U9__GRPATE+"\13\10"            
					SYP->YP_CAMPO	:= "ADF_CODOBS"
					SYP->(MsUnLock())
				EndIf
				lValTMK := .T.
				cNumYY  := cNumYP
				/*If Reclock("SYP", .T.)
					SYP->YP_FILIAL	:= xFILIAL("SYP")
					SYP->YP_CHAVE 	:= cNumYP
					SYP->YP_SEQ		:= "002"
					SYP->YP_TEXTO   := "XYZ"            
					SYP->YP_CAMPO	:= "ADF_CODOBS"
					SYP->(MsUnLock())
				EndIf*/  
			EndIf
		EndIf
	EndiF                                                                           	

restarea(_aArea) 
return