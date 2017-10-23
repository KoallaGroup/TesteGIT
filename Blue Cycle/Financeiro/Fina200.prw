


/* Variáveis publicas disponíveis
1. cNumTit -> Número do título
2. dBaixa -> Data da Baixa
3. cTipo -> Tipo do título
4. cNsNum -> Nosso Número
5. nDespes -> Valor da despesa
6. nDescont -> Valor do desconto
7. nAbatim -> Valor do abatimento
8. nValRec -> Valor recebidos
9. nJuros -> Juros
10. nMulta -> Multa
11. nOutrDesp -> Outras despesas
12. nValCc -> Valor do crédito
13. dDataCred -> Data do crédito
14. cOcorr -> Ocorrência
15. cMotBai -> Motivo da baixa
16. xBuffer -> Linha inteira
17. dDtVc -> Data do vencimento
                                 
*/

User Function Fina200()      

LOCAL aArray := {}           
Local cHist := ""
Local lAlt := .F.
 
PRIVATE lMsErroAuto := .F.



DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+AllTrim(cNumTit))

	RecLock("SC5",.F.)
	SC5->C5_VLPGANT := SC5->C5_VLPGANT + nValRec
	SC5->C5_VLCNAB 	:= SC5->C5_VLCNAB - nValRec   

	MsUnlock()


	cHist := "Titulo gerado`a partir do pedido antecipado: "+SC5->C5_NUM
    

 
	aArray := { { "E1_PREFIXO"  , "RA"             , NIL },;
	            { "E1_NUM"      , cNumTit            , NIL },; 
	            { "E1_PARCELA"      , cValToChar(StrZero(Val(FtParcela()),3)), NIL },;
	            { "E1_TIPO"     , "RA"              , NIL },;
	            { "E1_PORTADO"     , "001"              , NIL },;
	            { "E1_AGEDEP"     , "3221"              , NIL },;
	            { "E1_CONTA"     , "7136"              , NIL },;
	            { "E1_NATUREZ"  , "112001"             , NIL },;
	            { "E1_CLIENTE"  , SC5->C5_CLIENTE       , NIL },;
	            { "E1_LOJA"  , SC5->C5_LOJACLI       , NIL },;
	            { "E1_EMISSAO"  , Date(), NIL },;
	            { "E1_VENCTO"   , Date(), NIL },;
	            { "E1_VENCREA"  , Date(), NIL },;
	            { "E1_VALOR"    , nValRec              , NIL },;
	            { "E1_VLCRUZ"    , nValRec              , NIL },;
	            { "E1_HIST"    , cHist              , NIL }   }
	 
	MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
 
 
	If lMsErroAuto
	    MostraErro()
	Else
	    Alert("Título incluído com sucesso!")
		
		If SC5->C5_YTPED = "02" 
			_lAlt	:= .T. 
		EndIf	
		
		cPedido := SC5->C5_NUM

		If SC5->C5__STATUS = '14' 
				If VldEnv(SC5->C5_NUM) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.
		
					If SC5->C5_CONDPAG = '001' .and. (SC5->C5_VLPGANT+SC5->C5_CREDNCC) < u_fTotPed(SC5->C5_NUM)
						Aviso("ATENCAO","O valor pago antecipadamente pelo cliente é menor que o valor do pedido: "+cPedido+". Pedido retido, aguardando pagamento.",{"OK"},3)
					   	If SC5->(! Eof())
							RecLock("SC5",.F.)
							//SC5->C5_LIBEROK := "S"
							SC5->C5__STATUS := "14" 
							MsUnlock()
						EndIf  				
						//U_AlertPed(cPedido)
					Else				
				        
							_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","",IIF(_lAlt,"ALT","INC"),"","")
		
					        If !Empty(_aResult)
					            If _aResult[1] == "S"
					                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
					        
					            Else 
								   SC5->(dbSetOrder(1))
								   SC5->(dbSeek(xFilial("SC5")+cPedido))
								   If SC5->(! Eof())
										RecLock("SC5",.F.)
										SC5->C5_LIBEROK := "S"
										SC5->C5__STATUS := "5" 
										MsUnlock()
									EndIf  
									
									Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido enviada com sucesso. - " + _aResult[2], 1, 0 ) 
		
					                
					            EndIf		
		
		                    Else
		                    	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar pedido para arMHAzena", 1, 0 )
		        
				            EndIf
					
					EndIf
					
				EndIf 
				
		EndIf	 
		   
	Endif
	
EndIf

 
Return      


Static Function FtParcela
 

		
cAlias := GetNextAlias()
cQuery := " SELECT MAX(E1_PARCELA) PARC FROM SE1010"

cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_PREFIXO = 'RA' AND E1_NUM = '"+SC5->C5_NUM+"'AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+'" 
cQuery += " AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  

nParcela := Val((cAlias)->PARC)

cParcela := cValtoChar(nParcela+1)



Return(cParcela)




