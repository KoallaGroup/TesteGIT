#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ o array aValores ir permitir ³
//³ que qualquer exce‡„o ou neces-³
//³ sidade seja tratado no ponto ³
//³ de entrada em PARAMIXB ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
// Estrutura de aValores                      
// Numero do T¡tulo - 01
// data da Baixa - 02                   
// Tipo do T¡tulo - 03
// Nosso Numero - 04
// Valor da Despesa - 05
// Valor do Desconto - 06
// Valor do Abatiment- 07
// Valor Recebido - 08
// Juros - 09
// Multa - 10
// Outras Despesas - 11
// Valor do Credito - 12
// Data Credito - 13
// Ocorrencia - 14
// Motivo da Baixa - 15
// Linha Inteira - 16
// Data de Vencto - 17

User Function F200VAR()
                              


Local _aValores := ParamIxb[01]
Local _nTamParc := TAMSX3("E1_PARCELA")[1]
Local _nTamBco := TAMSX3("E1_NUMBCO")[1]
Local aRecno := SE1->(GetArea())         
LOCAL aArray := {}           
Local cHist := ""
Local _lAlt := .F.   

 
PRIVATE lMsErroAuto := .F.



DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5")+AllTrim(cNumTit)) .and. !Empty(cNumTit) .and. SC5->C5__STATUS = '14' 
	
	If SC5->C5_NUM = ALLTRIM(cNumTit)
		//BEGIN TRANSACTION
		RecLock("SC5",.F.)
		SC5->C5_RETBCO := Posicione("SEB",1,xFilial("SEB")+"341"+_aValores[14]+"R","EB_DESCRI")
		MsUnlock()
	    
	    
	    If nValRec > 0  
	    
			RecLock("SC5",.F.)
			SC5->C5_VLPGANT := SC5->C5_VLPGANT + nValRec
			SC5->C5_VLCNAB 	:= SC5->C5_VLCNAB - nValRec   
		
			MsUnlock()
		
		
			cHist := "Pedido antecipado: "+SC5->C5_NUM+"."
		    
		    
		 
			aArray := { { "E1_PREFIXO"  , "RA"             , NIL },;
			            { "E1_NUM"      , cNumTit            , NIL },; 
			            { "E1_PARCELA"      ,cValToChar(StrZero(Val(FtParcela()),3)) , NIL },;       //
			            { "E1_TIPO"     , "RA"              , NIL },;		            
			            { "E1_NATUREZ"  , "112001"             , NIL },;
			            { "E1_CLIENTE"  , SC5->C5_CLIENTE       , NIL },;
			            { "E1_LOJA"  , SC5->C5_LOJACLI       , NIL },;
			            { "E1_EMISSAO"  , Date(), NIL },;
			            { "E1_VENCTO"   , Date(), NIL },;
			            { "E1_VENCREA"  , Date(), NIL },;
			            { "E1_VALOR"    , nValRec              , NIL },;  
			            { "E1_PEDIDO"    , cNumTit              , NIL },;
			            { "cBancoAdt"     , "341"              , .F. },;
			            { "cAgenciaAdt"     , "1403 "              , .F. },;
			            { "cNumCon"     , "19363     "              , .F. },;
			            { "E1_HIST"    , cHist              , NIL }   }       
			                                                              
	                                                          
	
			 
			MsExecAuto( { |x,y| FINA040(x,y)} , aArray, 3)  // 3 - Inclusao, 4 - Alteração, 5 - Exclusão
		 
		 
			If lMsErroAuto
			    MostraErro()
			Else
			    //Alert("Título do pedido antecipado "+cNumTit+" incluido com sucesso!")
				
				If SC5->C5_YTPED = "02" 
					_lAlt	:= .T. 
				EndIf	
				
				cPedido := SC5->C5_NUM
		
				If SC5->C5__STATUS = '14' 
						//If VldEnv(SC5->C5_NUM) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.
				
							If SC5->C5_CONDPAG = '001' .and. (SC5->C5_VLPGANT+SC5->C5_CREDNCC) < ROUND(u_fTotPed(SC5->C5_NUM),2)
								Aviso("ATENCAO","O valor pago antecipadamente pelo cliente é menor que o valor do pedido: "+cPedido+". Pedido retido, aguardando pagamento.",{"OK"},3)
							   	If SC5->(! Eof())
									RecLock("SC5",.F.)
									//SC5->C5_LIBEROK := "S"
									SC5->C5__STATUS := "14" 
									MsUnlock()
								EndIf  				
								//U_AlertPed(cPedido)
							Else		   
								   If SC5->(! Eof())
										RecLock("SC5",.F.)
										SC5->C5_LIBEROK := "S"
										SC5->C5__STATUS := "4" 
										MsUnlock()
									EndIf  								
	
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
											
											//Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido enviada com sucesso. - " + _aResult[2], 1, 0 ) 
				
							                
							            EndIf		
				
				                    Else
				                    	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar pedido para arMHAzena", 1, 0 )     
				                    	U_AlertPed(cPedido)
				        
						            EndIf
							
							EndIf
							
						//EndIf 
						
				EndIf	 
				   
			Endif
			
		EndIF
		//END TRANSACTION
	EndIf	
EndIf

 
Return      


Static Function FtParcela
 

		
cAlias := GetNextAlias()
cQuery := " SELECT MAX(E1_PARCELA) PARC FROM SE1010"

cQuery += " WHERE E1_FILIAL = '"+xFilial("SE1")+"' AND E1_PREFIXO = 'RA' AND E1_NUM = '"+SC5->C5_NUM+"'AND E1_CLIENTE = '"+SC5->C5_CLIENTE+"' AND E1_LOJA = '"+SC5->C5_LOJACLI+"'" 
cQuery += " AND D_E_L_E_T_ = ' ' "

cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  

nParcela := Val((cAlias)->PARC)

cParcela := cValtoChar(nParcela+1)



Return(cParcela)                                          