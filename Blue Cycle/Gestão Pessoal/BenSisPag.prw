#Include 'Protheus.ch'

Static cSequencia := '00'
Static cMatricula := ""

#DEFINE ORDEM '01'

//-------------------------------------------------------------------
/*/{Protheus.doc} BenSisPag
Função utilizada pelo layout do SISPAG para obter o banco, conta e nome dos beneficiários do funcionario.
A função é baseada na tabela SRQ de acordo com o funcionário, da tabela SRA.
Os dados do beneficiario é obtido somente se a pergunta 28 do grupo de perguntas GPM450 estiver configurada
como '2', que significa que a geração é feita por beneficiarios, caso contrario a função retorna sempre
o nome do funcionário.

@author Juliane Venteu
@since 28/07/2015
/*/
//-------------------------------------------------------------------
User Function BenSisPag(cTipo)
Local cValue := ""
Local aArea
	
	//-----------------------------------------------------------------------
	// Tratamento para o parametro "Gerar" quando está configurado como beneficiário
	//-----------------------------------------------------------------------
	If MV_PAR24 == 2 // Correção para a P12 MV_PAR28 == 2
		
		aArea := SRQ->(GetArea())
		
		If Empty(cMatricula)
			cMatricula := SRA->RA_MAT
		ElseIf cMatricula != SRA->RA_MAT
			//-----------------------------------------------------------------------
			// Quando muda o funcionario, reinicia a sequencia dos beneficiarios
			//-----------------------------------------------------------------------
			cMatricula := SRA->RA_MAT
			cSequencia := "00"
		EndIf
		
		//-----------------------------------------------------------------------
		// Controla a mudança de sequencia de acordo com o tipo de informação solicitada
		// No caso, "BANCO" é a primeira informação de cada beneficiario
		//-----------------------------------------------------------------------
		If cTipo == "BANCO"
			cSequencia := Soma1(cSequencia)
		EndIf
		
		SRQ->(DbSetOrder(1))
		If SRQ->(DBSeek(SRA->RA_FILIAL + cMatricula + "01" + "01"))
			
			Do Case
				Case cTipo == "BANCO"
					cValue := SUBSTR(SRQ->RQ_BCDEPBE,1,3)                                 
				Case cTipo == "CONTA"
					cValue := SUBSTR(SRQ->RQ_CTDEPBE,1,11) 
				Case cTipo == "NOME"
					cValue := SUBS(SRQ->RQ_NOME,1,30)
				Case cTipo == "AGENCIA"
					cValue := SUBSTR(SRQ->RQ_BCDEPBE,4,5) 
				Case cTipo == "DIGITO"
					cValue := SUBSTR(SRQ->RQ_CTDEPBE,12,1)					
					
			EndCase	
						
		EndIf
		
		RestArea(aArea)
		
	Else
		Do Case
			Case cTipo == "BANCO"
				cValue := SUBSTR(SRA->RA_BCDEPSA,1,3)
			Case cTipo == "CONTA"
				cValue := SUBSTR(SRA->RA_CTDEPSA,1,11) 
			Case cTipo == "NOME"
				cValue := SUBS(SRA->RA_NOME,1,30)
			Case cTipo == "AGENCIA"
				cValue := SUBSTR(SRA->RA_BCDEPSA,4,5)  
			Case cTipo == "DIGITO"
				cValue := SUBSTR(SRA->RA_CTDEPSA,12,1)   
		EndCase	
	EndIf

Return cValue

