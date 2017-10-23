#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : MA035VLD 			 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         										      |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Ponto de entrada para alterar o segmento dos produtos, caso haja alteração no segmento    |
|---------------------------------------------------------------------------------------------------------|
*/

User Function MA035VLD

If PARAMIXB[1] == 4
	
	If M->BM__SEGISP != SBM->BM__SEGISP
		
		DbSelectArea("SB1")
		DbSetOrder(4)
		DbSeek(xFilial("SB1")+SBM->BM_GRUPO)
		
		While ! Eof() .and. SB1->B1_GRUPO = SBM->BM_GRUPO
			
			Do While !reclock("SB1", .F.)
			EndDo
			SB1->B1__SEGISP := M->BM__SEGISP
			msUnlock()
						
			DbSelectArea("SB1")
			DbSkip()
			
		EndDo
		
	EndIf
	
EndIf

Return
