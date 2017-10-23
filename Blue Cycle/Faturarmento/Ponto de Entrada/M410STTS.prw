#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/**
Alteracoes: Rodrigo Prates (DSM) - 11/01/11-->
-->Retirando linha que passada "" para variavel publica "cStatus"
-->Inserindo validacao de filial em todas as querys
-->Inserindo chamada do metodo generico "U_FCLOSEAREA" que apaga tabela e/ou arquivo aberto
-->Retirada da validacao "ElseIf AllTrim(SC5->C5_TIPO) <> 'D' .Or. AllTrim(SC5->C5_TIPO) <> 'B'", pois no contexto e inutil
-->Retirada do "dbSelectArea("SC5")" pois o mesmo estava causando desposicionamento
**/
User Function M410STTS()

//Local lLibCreAut := .F.
Local cQuery
Local aAreTela := {SC9->(GetArea()),SC6->(GetArea()),SC5->(GetArea()),GetArea()}
Local nTotPagar	 := 0
Local lPedTrans := .F.
Local cCFTrans := ""//SuperGetMV("MC_CFTRANS", ,"5152")
Local cStatPed := SC5->C5__STATUS          
Local _nposprod:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_PRODUTO"})
Local _nPosCf:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_CF"})
Local _nPosVlr:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_VALOR"})
Local _nPosNota:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_NOTA"}) 
Local _nPosQuant:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_QTDVEN"})  
Local _nTes:=aScan(aHeader,{|x| AllTrim(x[2])=="C6_TES"})
Local cValorPed := 0 
Local cValFret := 0

/*If SC5->C5_YIMPRES == "X"
	aEval(aAreTela, {|xAux| RestArea(xAux)})
	Return(.T.)
EndIf */

//FVldLibPV()

//Verifica se o Pedido e de Transferência se for não processa o Ponto de Entrada.
For nXX := 1 To Len(aCols)
	If ! GDDeleted(nXX,aHeader,aCols)
		If AllTrim(GDFieldGet("C6_CF",nXX)) $ cCFTrans
			lPedTrans := .T.
			EXIT
		EndIf
	EndIf
Next nXX

/*If lPedTrans
	aEval(aAreTela, {|xAux| RestArea(xAux)})
	Return(.T.)
EndIf */




//ATUALIZA FLAG DE ENVIO DE PEDIDO E CHAMA FUNÇÃO DE ENVIO DE E-MAIL


If IsInCallStack( " A410Deleta " )
//ApMsgInfo( " Delecao " )
ElseIf IsInCallStack( " A410Copia " )

								IF LEN(ACOLS) > 0 .and. !empty(acols[1,_nposprod])
								                         
									FOR I:=1 TO LEN(ACOLS) 
							
										If !aCols[I][Len(aCols[I])]//identifica se o item não foi deletado			
							
											If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_DUPLIC") = "S" .And. Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_ESTOQUE") = "S"
												If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_IPI") = "S"
													cValorIPI := (ACOLS[I,_nposVlr] / 100) * Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_IPI")
												Else
													cValorIPI := 0
												EndIf
												cGrpCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_GRPTRIB")
												cGrpProd := Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_GRTRIB")    
												cEst := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")
												
												cAlias := GetNextAlias()
												cQuery := " SELECT F7_MARGEM, F7_ALIQINT, F7_ALIQEXT FROM SF7010 WHERE F7_GRTRIB = '"+cGrpProd+"' AND F7_GRPCLI = '"+cGrpCli+"' AND D_E_L_E_T_ = ' ' "
												cQuery += " AND F7_FILIAL = '"+xFilial("SF7")+"' AND F7_EST = '"+cESt+"' "					
												cQuery := ChangeQuery(cQuery)
												DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  					
												
										
												cValorPed += cValorIPI + ACOLS[I,_nposVlr]
												cValProd := ACOLS[I,_nposVlr]
					
												If (cAlias)->F7_MARGEM > 0 
													cBaseSt = cValProd + (cValProd/100)* F7_MARGEM
																			
													If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") = "RJ"
														nAliqInt := 20
													Else
														nAliqInt := (cAlias)->F7_ALIQINT
													EndIf
													
													nValSt := (cBaseSt/100)*nAliqInt - (ACOLS[I,_nposVlr]/100)*(cAlias)->F7_ALIQEXT	  
												Else
													nValSt := 0
																	
												EndIf                                                                         
												
							
												
												
												cValorPed += nValSt
											EndIf
											                                 
										Endif
									next i   
									
								Endif     
								
								If SC5->C5_TRANSP $ AllTrim(GetMv("MV_TRFTAE"))
								    //Validar valor fixo do frete aereo para pedidos inferiores a R$ 1.500,00 (Amanda)
								    If cValorPed > 1500
								    	cValFret := (cValorPed/100)*6
								    Else 
								    	If cValorPed > 0  .And.  cValorPed <= 1500
								    		cValFret := 200
								    	EndIf
								    EndIf 
							    	   
							 	Else
							 		If cValorPed < 1500 .And. cValorPed > 0
										If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "RS|SC|PR"
											cValFret := 40
										ElseIf Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "SP"
											cValFret := 50										
										Else
											cValFret := 60
										EndIf  
									EndIf
								EndIf 		

								iF SC5->C5_TIPO = "N" .and. SC5->C5__STATUS <> "1" .and. C5_CLIENTE < "900000"
									u_emailped(SC5->C5_NUM)
								EndIf


                               DbSelectArea("SC5")
                               Reclock("SC5",.F.) 
                                                                                                                
                               

                               SC5->C5_MAILSEP := ''
                               SC5->C5_MAILEXP := ''
                               SC5->C5_CNAB := ''
                               SC5->C5_VLCNAB := 0  
                               SC5->C5_CREDNCC := 0 
                               SC5->C5_VLPGANT := 0
                               SC5->C5_RETBCO := ''
                               SC5->C5__PEDMEX := '' 
                               SC5->C5_INTERAC := ''
                               SC5->C5_FRETE := cValFret
                               Msunlock("SC5")                        

ElseIf IsInCallStack( " A410ProcDv " ) 
//ApMsgInfo( " Liberacao " )
ElseIf IsInCallStack( " A410Altera " ) 


								IF LEN(ACOLS) > 0 .and. !empty(acols[1,_nposprod])
								                         
									FOR I:=1 TO LEN(ACOLS) 
							
										If !aCols[I][Len(aCols[I])]//identifica se o item não foi deletado			
							
											If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_DUPLIC") = "S" .And. Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_ESTOQUE") = "S"
												If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_IPI") = "S"
													cValorIPI := (ACOLS[I,_nposVlr] / 100) * Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_IPI")
												Else
													cValorIPI := 0
												EndIf
												cGrpCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_GRPTRIB")
												cGrpProd := Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_GRTRIB")    
												cEst := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")
												
												cAlias := GetNextAlias()
												cQuery := " SELECT F7_MARGEM, F7_ALIQINT, F7_ALIQEXT FROM SF7010 WHERE F7_GRTRIB = '"+cGrpProd+"' AND F7_GRPCLI = '"+cGrpCli+"' AND D_E_L_E_T_ = ' ' "
												cQuery += " AND F7_FILIAL = '"+xFilial("SF7")+"' AND F7_EST = '"+cESt+"' "					
												cQuery := ChangeQuery(cQuery)
												DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  					
												
										
												cValorPed += cValorIPI + ACOLS[I,_nposVlr]
												cValProd := ACOLS[I,_nposVlr]
					
												If (cAlias)->F7_MARGEM > 0 
													cBaseSt = cValProd + (cValProd/100)* F7_MARGEM
																			
													If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") = "RJ"
														nAliqInt := 20
													Else
														nAliqInt := (cAlias)->F7_ALIQINT
													EndIf
													
													nValSt := (cBaseSt/100)*nAliqInt - (ACOLS[I,_nposVlr]/100)*(cAlias)->F7_ALIQEXT	  
												Else
													nValSt := 0
																	
												EndIf                                                                         
												
							
												
												
												cValorPed += nValSt
											EndIf
											                                 
										Endif
									next i   
									
								Endif     
								
								If SC5->C5_TRANSP $ AllTrim(GetMv("MV_TRFTAE"))
								    //Validar valor fixo do frete aereo para pedidos inferiores a R$ 1.500,00 (Amanda)
								    If cValorPed > 1500
								    	cValFret := (cValorPed/100)*6
								    Else 
								    	If cValorPed > 0  .And.  cValorPed <= 1500
								    		cValFret := 200
								    	EndIf
								    EndIf 
							    	   
							 	Else
							 		If cValorPed < 1500 .And. cValorPed > 0
										If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "RS|SC|PR"
											cValFret := 40
										ElseIf Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "SP"
											cValFret := 50										
										Else
											cValFret := 60
										EndIf  
									EndIf
								EndIf 		




                               DbSelectArea("SC5")
                               Reclock("SC5",.F.) 
                                                                                                                
                               

                               SC5->C5_MAILSEP := ''
                               SC5->C5_MAILEXP := ''
                               SC5->C5_CNAB := ''
                               SC5_C5_VLCNAB := 0 
                               SC5->C5_RETBCO := ''  
                               SC5->C5_CREDNCC := 0
                               SC5->C5_INTERAC := ''
                               SC5->C5_FRETE := cValFret
                               Msunlock("SC5")                        
                               

                               

ElseIf IsInCallStack( " A410Inclui " ) 

								IF LEN(ACOLS) > 0 .and. !empty(acols[1,_nposprod])
								                         
									FOR I:=1 TO LEN(ACOLS) 
							
										If !aCols[I][Len(aCols[I])]//identifica se o item não foi deletado			
							
											If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_DUPLIC") = "S" .And. Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_ESTOQUE") = "S"
												If Posicione("SF4",1,xFilial("SF4")+ACOLS[I,_nTes],"F4_IPI") = "S"
													cValorIPI := (ACOLS[I,_nposVlr] / 100) * Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_IPI")
												Else
													cValorIPI := 0
												EndIf
												cGrpCli := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_GRPTRIB")
												cGrpProd := Posicione("SB1",1,xFilial("SB1")+ACOLS[I,_nposProd], "B1_GRTRIB")    
												cEst := Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI, "A1_EST")
												
												cAlias := GetNextAlias()
												cQuery := " SELECT F7_MARGEM, F7_ALIQINT, F7_ALIQEXT FROM SF7010 WHERE F7_GRTRIB = '"+cGrpProd+"' AND F7_GRPCLI = '"+cGrpCli+"' AND D_E_L_E_T_ = ' ' "
												cQuery += " AND F7_FILIAL = '"+xFilial("SF7")+"' AND F7_EST = '"+cESt+"' "					
												cQuery := ChangeQuery(cQuery)
												DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  					
												
										
												cValorPed += cValorIPI + ACOLS[I,_nposVlr]
												cValProd := ACOLS[I,_nposVlr]
					
												If (cAlias)->F7_MARGEM > 0 
													cBaseSt = cValProd + (cValProd/100)* F7_MARGEM
																			
													If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") = "RJ"
														nAliqInt := 20
													Else
														nAliqInt := (cAlias)->F7_ALIQINT
													EndIf
													
													nValSt := (cBaseSt/100)*nAliqInt - (ACOLS[I,_nposVlr]/100)*(cAlias)->F7_ALIQEXT	  
												Else
													nValSt := 0
																	
												EndIf                                                                         
												
							
												
												
												cValorPed += nValSt
											EndIf
											                                 
										Endif
									next i   
									
								Endif     
								
								If SC5->C5_TRANSP $ AllTrim(GetMv("MV_TRFTAE"))
								    //Validar valor fixo do frete aereo para pedidos inferiores a R$ 1.500,00 (Amanda)
								    If cValorPed > 1500
								    	cValFret := (cValorPed/100)*6
								    Else 
									    If cValorPed > 1500
									    	cValFret := (cValorPed/100)*6
									    Else 
									    	If cValorPed > 0  .And.  cValorPed <= 1500
									    		cValFret := 200
									    	EndIf
									    EndIf 
								    EndIf 
							    	   
							 	Else
							 		If cValorPed < 1500 .And. cValorPed > 0
										If Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "RS|SC|PR"
											cValFret := 40
										ElseIf Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_EST") $ "SP"
											cValFret := 50										
										Else
											cValFret := 60
										EndIf  
									EndIf
								EndIf 		

                               
                               DbSelectArea("SC5")
                               Reclock("SC5",.F.) 
                               SC5->C5_FRETE := cValFret
                               Msunlock("SC5")                        

								iF SC5->C5_TIPO = "N" .and. SC5->C5__STATUS <> "1"
								   	u_emailped(SC5->C5_NUM)
								EndIf

                               
//ApMsgInfo( " Inclusao " )
EndIF

If (cEmpAnt <> "06")

	If (FunName() != "MATA410" .OR. FunName() != "MATA415")

		_aRetUser := {}
		_NomeUser := SubStr(cUsuario,7,15)

		//FSCIFFOB() 

		If RecLock("SC5",.F.)
/*
			If FSVERDES(SC5->C5_NUM)
				If AllTrim(cStatus) <> "" 
					SC5->C5__STATUS := "20"
				Else
					SC5->C5__STATUS := "02"
					U_M410BB(SC5->C5_NUM)

					cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5__STATUS = '02' "
					cQuery += "WHERE D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
					TcSqlExec(cQuery)  

					cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_USUALCA = 'AUTOMATICO' "
					cQuery += "WHERE D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
					TcSqlExec(cQuery) 

					dbSelectArea("SC9")
					dbSetOrder(1)   
					cQuery1 := "UPDATE " + RetSqlName("SC9") + " SET C9_BLEST = ' ' "
					cQuery1 += "WHERE D_E_L_E_T_ = '' AND C9_FILIAL = '" + xFilial("SC9") + "' "
					cQuery1 += "AND C9_PEDIDO = '" + SC5->C5_NUM + "' "
					TcSqlExec(cQuery1)

					cQuery2 := "UPDATE " + RetSqlName("SC9") + " SET C9_BLCRED = '02' "
					cQuery2 += "WHERE D_E_L_E_T_ = '' AND C9_FILIAL = '" + xFilial("SC9") + "' "
					cQuery2 += "AND C9_PEDIDO = '" + SC5->C5_NUM + "' "
					TcSqlExec(cQuery2)                

					lLibCreAut:= .T.  

				EndIf
			Else
*/
// Alisson, validar variavel CStatus
			If FunName() <> "MVC002"
				If AllTrim(cStatPed) == "01" .Or. FunName() == "LMG415"
					cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5__STATUS = '1'  "   
					cQuery += "WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
					Begin Transaction
					TcSqlExec(cQuery)
					End Transaction
				Else
					cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5__STATUS = '2', C5_HISSTAT = RTRIM(C5_HISSTAT)||'#M410STTS' "
					cQuery += "WHERE D_E_L_E_T_ = ' ' AND C5__STATUS <> '12' AND C5_FILIAL = '" + xFilial("SC5") + "' "
					cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
					Begin transaction
					TcSqlExec(cQuery)
					End Transaction
				EndIf
				
	//			EndIf
				cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_YUSU = '" + AllTrim(_NomeUser) + "',C5_USUCRED = ' ', C5_CREDAUT = ' ',"
				cQuery += "C5_DATCRED = ' ', C5_HORCRED = ' ', C5_DATCOLC = '" + DtoS(dDataBase) + "',C5_HORACOL = '" + Left(Time(),5) + "'  "
				cQuery += "WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '" + xFilial("SC5") + "' "
				cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "	
				Begin Transaction
				TcSqlExec(cQuery)
				End Transaction      	
			EndIf	
			/*cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_DATCOLC = '" + DtoS(dDataBase) + "' "
			cQuery += "WHERE D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5") + "' "
			cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
			TcSqlExec(cQuery)
			cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_HORACOL = '" + Left(Time(),5) + "' "
			cQuery += "WHERE D_E_L_E_T_ = '' AND C5_FILIAL = '" + xFilial("SC5") + "' "
			cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
			TcSqlExec(cQuery) */

			MsUnlock()

		EndIf

		//*****************************************************************************************************************
		//Gera o TXT para representante com status do pedido
		//****************************************************************************************************************
	/*	If GetNewPar("NM_USAPPC",.F.)
		   U_LMG410Status()
		EndIf */  

		//MsgStop("Pedido foi pro Credito")
/*
		If lLibCreAut //Libera credito automaticamente
			dbSelectArea("SC9")
			dbSetOrder(1)
			IF dbSeek(xFilial("SC9") + SC5->C5_NUM)
				cQuery := "SELECT SUM(C6_VALOR) TOTALPED FROM " + RetSqlName("SC6") + " "
				cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND D_E_L_E_T_ <> '*' "
				cQuery += "AND C6_NUM = '" + SC5->C5_NUM + "'"
				cQuery := ChangeQuery(cQuery)	     
				//memowrite("C:\cquery.sql",cquery) 
				dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"QC6",.F.,.T.)
				dbSelectArea("QC6")
				dbGoTop()	 
				nTotPagar := nTotPagar + QC6->TOTALPED + SC5->C5_SEGURO + SC5->C5_FRETE + SC5->C5_DESPESA
				dbSelectArea("QC6")
				dbCloseArea()	
				//MsAguarde({|| U_fLibC(nTotPagar)},"Aguarde...",OemToAnsi("Verificando liberação de crédito"),.T.)	
				U_LMG410Status()
			EndIf
		EndIf
*/
	Endif

EndIf

//aEval(aAreTela, {|xAux| RestArea(xAux)})

Return(.T.)


/*
Static Function FSVERDES(cNum)
*****************************************************************************************************************
Verifica se possui Desconto
*********

U_FCLOSEAREA("QSC5")   

cQuery := "SELECT SUM(C6_YDESCON)C6_YDESCON FROM " + RetSqlName("SC6") + " "
cQuery += "WHERE C6_FILIAL = '" + xFilial("SC6") + "' AND D_E_L_E_T_ = '' "
cQuery += "AND C6_NUM = '" + cNum + "' "
TCQUERY cQuery ALIAS "QSC5" NEW     

If QSC5->C6_YDESCON == 0
	//lT := .t.
	lT := .F.
Else
	lT := .F.
EndIf

Return(lT)  
*/



Static Function FSCIFFOB()
//****************************************************************************************************************************************************
// Ponto de Entrada para Marcar se é CIB ou FOB, conforme parametros inseridos.
//********************

//Local cCliebol := AllTrim(GetMv("MV_CLIBOL"))
Local cClieFob := AllTrim(C5_CLIENTE)

If (AllTrim(SC5->C5_TIPO) = "N" .And. (SM0->M0_CODIGO $ "01_04_05_08"))
	If (!cClieFob $ cCliebol)
		cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_TPFRETE = 'C' "
		cQuery += "WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '" + xFilial("SC5") + "' "
		cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
		TcSqlExec(cQuery)
	ELSE
		If (cClieFob $ cCliebol .And. Posicione("SA1",1,xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI,"A1_CGC")<> '14309301000106')
			cQuery := "UPDATE " + RetSqlName("SC5") + " SET C5_TPFRETE = 'F' "
			cQuery += "WHERE D_E_L_E_T_ = ' ' AND C5_FILIAL = '" + xFilial("SC5") + "' "
			cQuery += "AND C5_NUM = '" + SC5->C5_NUM + "' "
			TcSqlExec(cQuery)
		EndIf
	EndIf
EndIf

Return(Nil)


User Function LMG410Status()

	Local cArqSC5	:= "" 
	Local cLinha 	:= "",cCpo
	Local nArqSC5	:= nArqSC6 := 0
	Local cLinhaSC5,cLinhaSC6                                 
	Local nSeqSC5	:= nSeqSC6 := 0
	Local aHeadSC5	:= ""
	Local aHeadSC6	:= ""               
	Local cData		:= DtoC(dDataBase)
	Local cDia		:= SubStr(cData,1,2)
	Local cMes		:= SubStr(cData,4,2)
	Local cAno		:= SubStr(cData,7,4)
	Local cTempo	:= Time()
	Local cHora		:= SubStr(cTempo,1,2)
	Local cMin		:= SubStr(cTempo,4,2)
	Local cSeg		:= SubStr(cTempo,7,2)
	Local cLote		:= "WSP " + cDia + cMes + cAno + cHora + cMin + cSeg
	Local cVend		:= AllTrim(SC5->C5_VEND1)
	Local cPath		:= "" 
	Local cFile		:= " P " 
	Local cPedido	:= SC5->C5_NUM
	Local cNomeTrb	:= CriaTrab(,.F.), cQuery
	
	IF Empty(SC5->C5_VEND2)
	   cVend		:= AllTrim(SC5->C5_VEND1)
	
	Else
	   cVend		:= AllTrim(SC5->C5_VEND2)	
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre arquivo DICIONARIO POCKET                               ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ    
    dbUseArea(.T.,"DBFCDX","K23E01","K23",.T.,.F.)
    Index On K23_ARQ + K23_ORDEM To &cNomeTrb
	//MsgStop("entrei 1")
	dbSelectArea("SA3")
	dbSetOrder(1)
	If dbSeek(xFilial("SA3") + cVend)
		cPath := ALLTRIM(SA3->A3_YPATH) + cVend + "\remessa\"
		dbSelectArea("SC5")
		cArqSC5 := cPath + "SC5" + "-" + AllTrim(cVend) + cFile + cPedido + ".PPC"
		//MsgStop(cArqSC5 ,"entrei 2")
		aHeadSC5 := RetK23PPC("SC5")
		//MsgStop(cArqSC5 ,"entrei 2a")
	    nArqSC5 := Fcreate(cArqSC5)
		//MsgStop(cArqSC5 ,"entrei 2b")
	    nSeqSC5 := 1
	    cLinhaSC5 := ""
	    cLinhaSC5 := "SC5" + StrZero(nSeqSC5,8) + cLote + Chr(13)+Chr(10)
	    FWrite(nArqSC5,cLinhaSC5)
		//MsgStop(cArqSC5 ,"entrei 2c")
		nSeqSC5++ 				
	    cLinhaSC5 := "DET" + StrZero(nSeqSC5,8)
		//MsgStop(cArqSC5 ,"entrei 2d")
		cLinhaSC5 := cLinhaSC5 + RetK23Det(aHeadSC5,"SC5")
		//MsgStop(cArqSC5 ,"entrei 2e")
		cLinhaSC5 := cLinhaSC5 + Chr(13) + Chr(10)
	    FWrite(nArqSC5,cLinhaSC5)
		//MsgStop( cLinhaSC5 ,"entrei 3")
		If ALLTRIM(SC5->C5__STATUS) = "4" .Or. ALLTRIM(SC5->C5__STATUS) = "5"
			U_FCLOSEAREA("KSC6")
			cQuery := "SELECT C6_PRODUTO,C6_NUM,C6_QTDVEN "
			cQuery += "FROM " + RetSqlName("SC6") + " SC6 "
			cQuery += "WHERE SC6.D_E_L_E_T_ = '' AND C6_FILIAL = '" + xFilial("SC6") + "' "
			cQuery += "AND C6_NUM = '" + SC5->C5_NUM + "' "
			cQuery += "ORDER BY 1"
			TcQuery cQuery Alias "KSC6" NEW
			KSC6->(dbGoTop())
			While !KSC6->(EoF())
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   				//³ Verifica o cancelamento pelo usuario...                             ³
   				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				nSeqSC5++ 				
				cLinhaSC5 := "SC6" + StrZero(nSeqSC5,8)
				cLinhaSC5 := cLinhaSC5 + KSC6->C6_NUM + KSC6->C6_PRODUTO + StrZero(KSC6->C6_QTDVEN * 100,9) 
				cLinhaSC5 := cLinhaSC5 + Chr(13) + Chr(10)
				FWrite(nArqSC5,cLinhaSC5)
				KSC6->(dbSkip()) // Avanca o ponteiro do registro no arquivo
			EndDo
			dbSelectArea("KSC6")
			dbCloseArea()
		EndIf
		If (nArqSC5) > 0
			nSeqSC5++
			cLinhaSC5 := "FIM" + StrZero(nSeqSC5,8) + Chr(13) + Chr(10)
			FWrite(nArqSC5,cLinhaSC5)
			FClose(nArqSC5)
			//MsgStop( cLinhaSC5 ,"entrei 4 fim")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Recupera a Integridade dos dados                             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	EndIf
	U_FCLOSEAREA("K23")	// Retirado de dentro desse ultimo EndIf e passado para fora - Luciano Emilio - Squadra
Return(.T.)

Static Function RetK23PPC(cAlias)
	Local aHeader :={}
	dbSelectArea("K23")
	dbSetOrder(1)
	dbSeek(cAlias)
	While !Eof() .and. K23_ARQ == cAlias
		If Empty(K23_EXPORT)
			dbSelectArea("K23")
			dbSkip()
			Loop
		EndIf
		AADD(aHeader,{K23->K23_TITULO,; //1
					  K23->K23_CAMPO ,; //2
					  K23->K23_TIPO  ,; //3
					  K23->K23_TAM   ,; //4
					  K23->K23_DEC   ,; //5
					  K23->K23_RETCPO}) //6
		dbSelectArea("K23")
		dbSkip()
     EndDo
Return(aHeader)

Static Function RetK23Det(aHeader,cAlias)
	Local yy		:= 0
	Local nTam		:= 0
	Local cLinha	:= ""
	Local cConteudo := ""
	For yy := 1 To Len(aHeader)
		cConteudo := ""
		nTam := aHeader[yy][4]  // + aHeader[yy][5]
		If Empty(aHeader[yy][6])    
			cConteudo :=  &(cAlias + "->" + AllTrim(aHeader[yy][2]))
		Else 
			cConteudo :=  &(AllTrim(aHeader[yy][6]))     
		EndIf
		If aHeader[yy][3] == "N"
			cConteudo := StrZero(cConteudo * 100,nTam)
		ElseIf aHeader[yy][3] == "D"
			cConteudo := GravaData(cConteudo,.F.,0)
		ElseIf aHeader[yy][3] == "C"
			cConteudo := N001Space(cConteudo,nTam)
		EndIf 
		cLinha := cLinha + SubStr(cConteudo,1,nTam)
	Next yy
Return(cLinha)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A940Fill     ³Autor ³ Juan Jos‚ Pereira   ³ Data ³ 30/01/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Encaixa conteudo em espaco especificado                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function N001Space(cConteudo,nTam)
	cConteudo := IIF(cConteudo == Nil,"",cConteudo)
	If Len(cConteudo) > nTam
		cRetorno := SubStr(cConteudo,1,nTam)
	Else
		cRetorno := cConteudo + Space(nTam - Len(cConteudo))
	EndIf
Return (cRetorno)



//-------------------------------------------------------------------
/*/{Protheus.doc} FVldLibPV()
Valida se Existe todos os itens no arquivo de Liberacao do Pedido SC9

@author	Ederson Colen
@since	06/09/2013
@param	

@return	

/*/
//-------------------------------------------------------------------
Static Function FVldLibPV()

Local aAreTela := {SC9->(GetArea()),SC6->(GetArea()),SC5->(GetArea()),GetArea()}
Local lRetVld	:= .T.

/*
Local lCredito := .F.
Local lEstoque := .F.
Local nQtdLib  := 0
Local nQtdLib2 := 0
Local lLiberOk := .T.
Local lLiber := MV_PAR02 == 1
Local lTransf:= MV_PAR01 == 1
*/

SC6->(dbSetOrder(1)) //C6_FILIAL+C6_NUM+C6_ITEM+C6_PRODUTO
SC6->(dbSeek(xFilial("SC6")+SC5->C5_NUM))

While SC6->(! Eof()) .And. ;
	SC6->C6_NUM == SC5->C5_NUM

	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))
	
	If SC9->(Eof())
		//Function A440Grava(lLiber,lTransf)

/*
		If (SC5->C5_TIPLIB<>"2" )
			nQtdLib := SC6->C6_QTDLIB
			nQtdLib2:= If( Empty( SC6->C6_QTDLIB2 ), NIL, SC6->C6_QTDLIB2)
			nQtdLib := MaLibDoFat(SC6->(RecNo()),nQtdLib,@lCredito,@lEstoque,.T.,.T.,lLiber,lTransf,NIL,NIL,NIL,NIL,NIL,NIL,nQtdLib2)
		EndIf

		SC9->(dbSetOrder(1))
		SC9->(dbSeek(xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM))     
	
		If SC9->(Eof())
		EndIf
*/
     	Aviso("ATENCAO","O ITEM "+SC6->C6_ITEM+" DO PEDIDO "+SC5->C5_NUM+" NAO FOI LIBERADO. ENTRAR EM CONTATO COM A TI.",{"Ok"}) 
		lRetVld := .F.
		EXIT

	EndIf
	
	SC6->(dbSkip())

EndDo

aEval(aAreTela, {|xAux| RestArea(xAux)})

Return(lRetVld)