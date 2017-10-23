#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} fAtendClienteClass
Classe para Cadastro de Atendimento aos Clientes

@author Sigfrido Eduardo Solórzano Rodriguez
@since 22/06/2017
@version P11/P12
/*/
//-------------------------------------------------------------------

User Function fAtuAgenAt()							
	Local dDataIni := CToD("01/06/17")	
	Local dDataFim := CToD("30/06/17")	
    Local nD
	Local nContAte := 0
    
	BeginSql alias 'AGETMP'   
		%noparser% 
		SELECT ROUND(COUNT(*)/22,0) NCLIEDIA, SA1.A1_VEND2 
		FROM %table:SA1% SA1
		WHERE SA1.A1_FILIAL = %xfilial:SA1%  AND 
		SA1.A1_VEND2 NOT IN ('      ','000000') AND 
		SA1.%notDel%    
		GROUP BY  SA1.A1_VEND2
		ORDER BY  SA1.A1_VEND2
	EndSql

	Do While !AGETMP->(Eof())
		BeginSql alias 'SA1TMP'   
			%noparser% 
			SELECT SA1.A1_COD, SA1.A1_LOJA
			FROM SA1010 SA1
			WHERE SA1.A1_FILIAL = ' ' AND SA1.A1_VEND2 = %Exp:AGETMP->A1_VEND2% AND SA1.D_E_L_E_T_ = ' '
		EndSql

		Do While !SA1TMP->(Eof())						
			For nD := dDataIni To dDataFim	
				nContAte := 0
												
				Do While nContAte <= AGETMP->NCLIEDIA .AND. !SA1TMP->(Eof())
					RecLock("ZZ1",.T.) 
	
					ZZ1->ZZ1_FILIAL	:= xFilial('ZZ1')   
					ZZ1->ZZ1_DTPROG := Date()
					ZZ1->ZZ1_VENINT := AGETMP->A1_VEND2
					ZZ1->ZZ1_CODCLI := SA1TMP->A1_COD  
					ZZ1->ZZ1_CLILJ  := SA1TMP->A1_LOJA
					ZZ1->ZZ1_DTAGAT := nD
			
					ZZ1->(MsUnlock())
					
					nContAte++
					SA1TMP->(dbSkip())				
				Enddo				
			Next nD
		Enddo
		
		SA1TMP->(DbCloseArea())

		AGETMP->(dbSkip())
	Enddo
	
	AGETMP->(DbCloseArea())
Return