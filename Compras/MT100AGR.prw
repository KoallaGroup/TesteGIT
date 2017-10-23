#include "Protheus.ch"
#include "Topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MT100AGR			  		| 		Junho de 2015				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi													|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para validação da Nota de Entrada										|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function MT100AGR()          


//GRAVA INFORMACOES PARA REDESPACHO

If FunName() = "MATA103"
	If !Empty(Alltrim(SF1->F1__TRARED)) 
		lRedEnt := .T.
	EndIf

 	If lRedEnt  
  		If Empty(Alltrim(SF1->F1__TRARED))
	 		Reclock("SF1", .F.)
	  			SF1->F1__TRARED := cGetReds
	  			SF1->F1__TPFRED := cRedSpach 
	  		SF1->(MsUnlock()) 
   		EndIf 
	U_ICOMA16B()
 	End  
EndIf  

	
Return