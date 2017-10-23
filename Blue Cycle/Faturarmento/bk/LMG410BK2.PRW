#INCLUDE "MATA410.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "XMLXFUN.CH"                          
#INCLUDE "TBICONN.CH"  
#include 'topconn.ch'
#DEFINE DIRMASC "\MSXML\"
#DEFINE DIRXMLTMP "\MSXMLTMP\"
#DEFINE ITENSSC6 300
#xCommand CLOSETRANSACTION LOCKIN <aAlias,...>   => EndTran( \{ <aAlias> \}  ); End Sequence
Static __lHasWSSTART

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³ MATA410  ³ Rev.  ³ Eduardo Riera         ³ Data ³ 26.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Programa de atualizacao de Pedidos de Venda                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ Void MATA410(void)                                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³              ³        ³      ³                                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Array contendo as Rotinas a executar do programa      ³
//³ ----------- Elementos contidos por dimensao ------------     ³
//³ 1. Nome a aparecer no cabecalho                              ³
//³ 2. Nome da Rotina associada                                  ³
//³ 3. Usado pela rotina                                         ³
//³ 4. Tipo de Transa‡„o a ser efetuada                          ³
//³    1 - Pesquisa e Posiciona em um Banco de Dados             ³
//³    2 - Simplesmente Mostra os Campos                         ³
//³    3 - Inclui registros no Bancos de Dados                   ³
//³    4 - Altera o registro corrente                            ³
//³    5 - Remove o registro corrente do Banco de Dados          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

User Function LMG410(xAutoCab,xAutoItens,nOpcAuto,lSimulacao,cRotina,cCodCli,cLoja,xRatCTBPC,xAdtPC)

	Local aCores := {}
	Local cRoda	 := ""
	Local bRoda	 := {|| .T.}
	Local xRet	 := Nil
	Local cGrupo := ""
	Local cVend  := ""
	Local lAdm	 := .F.
	Public nAutoAdt
	Public aRatCTBPC  := IIF(xRatCTBPC <> Nil,xRatCTBPC,{})
	Public aAdtPC     := IIF(xAdtPC <> Nil,xAdtPC,{})
	Public cStatus	 := "2"
	Private cBcis	 	:= "" 
	Private lOnUpdate	:= .T.	
	Private l410Auto	:= xAutoCab <> Nil .And. xAutoItens <> Nil
	Private aAutoCab	:= {}
	Private aAutoItens	:= {}     
	Private aColsCCust	:= {}                
	Private aBkpAgg	  := {} 
	Private aRotina		:= {{OemToAnsi(STR0001)	   ,"AxPesqui"			,0,1   },; //"Pesquisar"
							{OemToAnsi(STR0002)	   ,"A410Visual"		,0,2   },; //"Visual"
							{OemToAnsi(STR0003)	   ,"U_P410INC"			,0,3   },; //"Incluir"
							{OemToAnsi(STR0004)	   ,"U_P410Alt"			,0,4,20},; //"Alterar"
							{OemToAnsi(STR0005)	   ,"U_P410Del"			,0,5,21},; //"Excluir" 
							{OemToAnsi("Envia WMS"),"U_EnvWMS"			,0,3,0 },; //"Envia Separação"    
							{OemToAnsi("Reab. Pedido"),"U_ReabPed"			,0,3,0 },; //"Reabertura pedido"
							{OemToAnsi("Estorna WMS"),"U_EstWMS"			,0,3,0 },; //"Estorna separacao"
							{OemToAnsi(STR0006)	   ,"A410Barra"			,0,3,0 },; //"Cod.barra" 
							{OemToAnsi("Rel Ped")  ,"U_FSPEDBTN"		,0,3,0 },; //"Estorno" 
							{OemToAnsi(STR0042)	   ,"A410PCopia"		,0,6,0 },; //"Copiar"
							{OemToAnsi("Retornar") ,"A410Devol"			,0,3,0 },; //"Retorno"
							{OemToAnsi("Parecer")  ,"U_FSBOXPAREC('V')"	,0,3,0 },; //"Parecer" -->Rodrigo Prates (DSM)
							{OemToAnsi(STR0032)	   ,"U_P410Leg"			,0,3,0 },;  //"Legenda"   
							{OemToAnsi("Enviar Email")	   ,"U_PEDVENDASEMAIL"			,0,3,0 },;  //"Legenda" 
							{OemToAnsi("Prepara Docs") ,"U_Prepara"		,0,3,0 },;  //"Rel Ped"
							{OemToAnsi("Boleto Antecipado") ,"U_P410BOL"		,0,3,0 },;  //"Rel Ped"
							{OemToAnsi("Posição Pedido") ,"U_BCDCONPED('1')",0,3,0 },;  //"Posição Pedido"
							{OemToAnsi("Alçada Comercial") ,"U_P460Man",0,3,0 },;  //"Liberação Alçada"	
							{OemToAnsi("Atendimento aos Clientes") ,"U_fAtClWin",0,3,0 },;  //"Atendimento aos Clientes"						
							{OemToAnsi("Inc/Ret Em Espera") ,"U_EspDef()",0,3,0 }}
	Private cCadastro := OemToAnsi(STR0007) //"Atualiza‡„o de Pedidos de Venda"
	If (cPaisLoc != "BRA")
		Private aArrayAE := {}
		Private lImpMsg	 := .T.                            
	EndIf
	Default nOpcAuto	:= 3
	Default lSimulacao	:= .F.
	Private	aCores	:= {{"ALlTRIM(SC5->C5__STATUS)=='2'",'BR_VERMELHO_OCEAN'},; //Alcada
 						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. EMPTY(C5_PARECER)",'BR_VERDE_OCEAN'   },; //Credito  
						{"ALlTRIM(SC5->C5__STATUS)=='3' .AND. !EMPTY(C5_PARECER)",'BR_AZUL_CLARO'   },; //Credito  Rejeitado
						{"ALLTRIM(SC5->C5__STATUS)=='4'",'BR_VIOLETA'   },; //Envio Pendente
						{"ALLTRIM(SC5->C5__STATUS)=='5'",'BR_MARROM'   },; //Aguardando Separação
						{"ALlTRIM(SC5->C5__STATUS)=='6'",'BR_LARANJA_OCEAN' },; //Separacao
						{"AlLTRIM(SC5->C5__STATUS)=='7'",'BR_CINZA_OCEAN'   },; //Conferencia
						{"AlLTRIM(SC5->C5__STATUS)=='8'",'BR_AMARELO_OCEAN' },; //Disponivel a Faturar						
						{"AlLTRIM(SC5->C5__STATUS)=='9'",'BR_PRETO_OCEAN'   },; //Faturado 
						{"AlLTRIM(SC5->C5__STATUS)=='10'",'BR_BRANCO_OCEAN'   },; //Em Expedição 
						{"AlLTRIM(SC5->C5__STATUS)=='11'",'BR_AZUL_OCEAN'    },;//Expedido
						{"AlLTRIM(SC5->C5__STATUS)=='13'",'BR_PINK'    },;//Devolvido
						{"AlLTRIM(SC5->C5__STATUS)=='12'",'BR_CANCEL'    },;//Cancelado
						{"ALLTRIM(SC5->C5__STATUS)=='14'",'BR_VERDE_ESCURO'},;//Antecipado Aguard. Crédito 
						{"ALLTRIM(SC5->C5__STATUS)=='15'",'PMSTASK1'}}
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste no pergunte MTA410				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_FSAJX1()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Ajuste no SX3                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	U_FSAJX3()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Tratamento de Rotina Automatica            ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ValType(cRotina) == "C"
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz tratamento para chamada por outra rotina             ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If !Empty(nScan := AScan(aRotina,{|x| Upper(Alltrim(x[2])) == Upper(Alltrim(cRotina))}))
			bRoda := &("{ || " + cRotina + "( 'SC5', SC5->( Recno() ), " + Str(nScan,2) + IIF(ValType(cCodCli) == "C",",nil,nil,nil,nil,nil,cCodCli,cLoja","") + ") } ")
			xRet  := Eval(bRoda)
		EndIf
	Else
		If (Type("l410Auto") <> "U" .And. l410Auto)
			lOnUpdate  := !lSimulacao
			aAutoCab   := xAutoCab
			aAutoItens := xAutoItens
			MBrowseAuto(nOpcAuto,Aclone(aAutoCab),"SC5")
			xAutoCab   := aAutoCab
			xAutoItens := aAutoItens
		Else
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Define variaveis de parametrizacao de lancamentos    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ MV_PAR01 Sugere Quantidade Liberada ? Sim/Nao        ³
			//³ MV_PAR02 Preco Venda Com Substituicao ? Sim?Nao      ³
			//³ MV_PAR03 Utiliz.Op.Triangular     ?   Sim/Nao        ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ativa tecla F-10 para parametros                     ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			SetKey(VK_F12,{|| a410Ativa()})
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Ponto de Entrada para alterar cores do Browse do Cadastro    ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MA410COR")
				aCores := ExecBlock("MA410COR",.F.,.F.,aCores)
			EndIf
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Endereca a funcao de BROWSE                          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If ExistBlock("MT410BRW")
				ExecBlock("MT410BRW",.F.,.F.)
			EndIf

	//		cBCIs := U_FGrpBCI()        Alterado por Valdemir do Carmo em 05/11/15

			dbSelectArea ("SC5")
			dbSetOrder(1)
			dbGoTop()
			
            cVend := POSICIONE("SA3",7,XFILIAL("SA3")+RetCodUsr(),"A3_COD") 
			
			If Empty(cVend)
				_cFiltro	 	:= ' SC5->C5__STATUS <> "1 " '// .AND. SC5->C5_VEND2 = "'+cVend+'"' // Alterado por Valdemir do Carmo em 08/02/16
			Else
				_cFiltro	 	:= ' SC5->C5__STATUS <> "1 " .AND. SC5->C5_VEND2 = "'+cVend+'"' // Alterado por Valdemir do Carmo em 08/02/16
			EndIf
		   
				_aIndexSC5	:= {}         													
	
	   	If	! Empty(_cFiltro)
	   		bFiltraBrw := {|| FilBrowse("SC5",@_aIndexSC5,@_cFiltro)}
				Eval(bFiltraBrw)
	   	EndIf

			mBrowse(6,1,22,75,"SC5",,,,,,aCores)

			EndFilBrw("SC5",_aIndexSC5)

		Endif
	Endif
	
	dbSelectArea("SC5")
	dbSetOrder(1)

	dbClearFilter()
	SetKey(VK_F12,Nil)

Return(.T.)
                         

User Function P410LEG()
	Local aLegenda	:= {{'BR_VERMELHO_OCEAN','Alcada'      },;
						{'BR_VERDE_OCEAN'   ,'Credito'     },;   
						{'BR_AZUL_CLARO','Credito Rejeitado'},;
						{'BR_VIOLETA' ,'Aguardando Envio Sep'},; //Envio Pendente
						{'BR_MARROM', 'Aguard. Inicio Separação'},;
						{'BR_LARANJA_OCEAN' ,'Separacao'   },;
						{'BR_CINZA_OCEAN'   ,'Conferencia' },;
						{'BR_AMARELO_OCEAN' ,'Disp Faturar'},;
						{'BR_PRETO'         ,'Faturado'    },; 
						{'BR_BRANCO'        ,'Em Expedição'},;                                    
						{'BR_AZUL_OCEAN'    ,'Expedido'  },;
						{'BR_PINK'    ,'Devolvido'  },;
						{'BR_CANCEL'    ,'Cancelado'  },;
						{'BR_VERDE_ESCURO'    ,'Aguard. Pagamento'  },;
						{'PMSTASK1'    ,'Em Espera'  }}						
						BrwLegenda(cCadastro,'Legenda',aLegenda)


Return(.T.)

User Function P410ALT()
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 4   

	nAutoAdt := nOpc 
	
	
	If ALLTRIM(SC5->C5__STATUS) = "5" .or. ALLTRIM(SC5->C5__STATUS) = "6" .or. ALLTRIM(SC5->C5__STATUS) = "7" .or. ALLTRIM(SC5->C5__STATUS) = "8" .or. ALLTRIM(SC5->C5__STATUS) = "9";
		.or. ALLTRIM(SC5->C5__STATUS) = "10" .or. ALLTRIM(SC5->C5__STATUS) = "11" .or. (ALLTRIM(SC5->C5__STATUS) = "14" .AND. U_FTotPed(SC5->C5_NUM)> (SC5->C5_VLPGANT+SC5->C5_CREDNCC) .AND. SC5->C5_VLCNAB > 0 .and. !RetCodUsr() $ AllTrim(GetMv("MV_ALTPANT")));
		.or. ALLTRIM(SC5->C5__STATUS) = "13"
		MsgStop("Pedido nao pode ser alterado!!")
		Return(.T.)
	EndIF            
	If SC5->C5__STATUS = "12" 
		cStatus := "12"
	EndIf            
	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } )
	SetKey( K_CTRL_B, 		{ || U_BCDCONPED('2')  } )
	A410Altera(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw) 
	SetKey( K_CTRL_A, 		{ || Nil } )
	SetKey( K_CTRL_B, 		{ || Nil } )
Return(.T.)

User Function P410INC(nIDAte,cCodCli,cLoja)
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 3
	SetKey( K_CTRL_A, 		{ || U_PEBCDFT()  } ) 
	SetKey( K_CTRL_B, 		{ || U_BCDCONPED('2')  } )	
	nAutoAdt := nOpc
	
	Private nIDAtende := ""
	
	If Empty(nIDAte) .Or. nIDAte == "SC5"
		A410Inclui(cAlias,nReg,nOpc,cStatus)
	Else
		//Public cStatus	 := "1"
		
		nIDAtende := nIDAte
		 
		A410Inclui(cAlias,nReg,nOpc,cStatus,,,,,cCodCli,cLoja) //FWMsgRun(, {|cAlias,nReg,nOpc,cStatus,,,,,cCodCli,cLoja| A410Inclui(cAlias,nReg,nOpc,cStatus,,,,,cCodCli,cLoja)}, 'Processando', 'Aguarde, processando a rotina' )  
	Endif
	
	Eval(bFiltraBrw)                    
	SetKey( K_CTRL_A, 		{ || Nil } )                  
	SetKey( K_CTRL_B, 		{ || Nil } )	
Return(.T.)

User Function P410Del()
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 5

	nAutoAdt := nOpc
	If ALLTRIM(SC5->C5__STATUS) = "5" .or. ALLTRIM(SC5->C5__STATUS) = "6" .or. ALLTRIM(SC5->C5__STATUS) = "7" .or. ALLTRIM(SC5->C5__STATUS) = "8" .or. ALLTRIM(SC5->C5__STATUS) = "9";
		.or. ALLTRIM(SC5->C5__STATUS) = "10" .or. ALLTRIM(SC5->C5__STATUS) = "11" .or. ALLTRIM(SC5->C5__STATUS) = "13" .or. ALLTRIM(SC5->C5__STATUS) = "14"
		MsgStop("Pedido nao pode ser excluido!!")
		Return(.T.)
	EndIF            


	If SC5->C5__STATUS >= "6" //ALTERAR PARA O STATUS CORRETO!!!!!!!
	
			_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","","EXC","","")
	
	        If !Empty(_aResult)
	            If _aResult[1] == "S"
	                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
	                _lRet := .f.
	            Else 
			    	MsgInfo("Envio de exclusao concluido com sucesso","Integracao ArMHAzena")
				EndIf  
	        Else
	        		Help( Nil, Nil, "EXCRECERR", Nil, "Erro ao enviar exclusao de documento para o WMS", 1, 0 ) 
	        		_lRet := .f.
	        	
	                
			EndIf		    
	EndIf
	
	A410Deleta(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw)
Return(.T.)   


User Function Prepara()
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 5
	Public cStatus	:= "2"
	nAutoAdt := nOpc
	If ALLTRIM(SC5->C5__STATUS) <> "8"
		MsgStop("O pedido não está pronto para faturar!!")
		Return(.T.)
	EndIF
	Ma410PvNfs(cAlias,nReg,nOpc,cStatus)
	Eval(bFiltraBrw)
Return(.T.)   

User Function EnvWMS(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local lRet 	  := .T.         
Local _aResult	:= {}, _lAlt	:= .F. 	




		If SC5->C5_YTPED = "02" 
			_lAlt	:= .T. 
		EndIf	
        //cValor := cValtoChar(ROUND(u_fTotPed(SC5->C5_NUM),2))
        //Alert(cValor)
        cPedido := SC5->C5_NUM
//////////////////////////////////////////////////////VALIDAÇÃO PARA ATIVAR INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA///////////////////////////////////////////		
//		U_LMG410Status() 
If SC5->C5__STATUS = '4' .or. SC5->C5__STATUS = '14' 
		If VldEnv(SC5->C5_NUM) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.
//		If StaticCall( LMG450, FVldPVLib, SC5->C5_NUM)
			//If lTesta
			//	Alert("Pedido sem Itens no Estoque")
			//Else
//------VALIDAÇÃO ESCRITA PARA IMPLEMENTAÇÃO DO NOVO PROCESSO PARA PEDIDO ANTECIPADO
			If SC5->C5_CONDPAG = '001' .and. (SC5->C5_VLPGANT+SC5->C5_CREDNCC) < ROUND(u_fTotPed(SC5->C5_NUM),2)
				Aviso("ATENCAO","O valor pago antecipadamente pelo cliente é menor que o valor do pedido: "+cPedido+". Pedido retido, aguardando pagamento.",{"OK"},3)
			   	If SC5->(! Eof())
					RecLock("SC5",.F.)
					SC5->C5__STATUS := "14" 
					MsUnlock()
				EndIf  				
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
	
ElseIf SC5->C5__STATUS = '2'        
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por alçada comercial.", 1, 0 )
ElseIf SC5->C5__STATUS = '3'                                                          
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por Credito.", 1, 0 )
ElseIf SC5->C5__STATUS >= '6' .AND. SC5->C5__STATUS <= '11'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido já enviado para separação.", 1, 0 )                                            
ElseIf SC5->C5__STATUS = '12'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido Cancelado, favor exclui-lo.", 1, 0 )                                            	
EndIf
	


//////////////////////////////////////////////////////VALIDAÇÃO PARA ATIVAR INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA///////////////////////////////////////////				


Return (lRet)      

                   



User Function EstWMS(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local lRet 	  := .T.         
Local _aResult	:= {}, _lAlt	:= .F. 	
        


If !RetCodUsr() $ AllTrim(GetMv("MV_ESTWMS"))
	MsgInfo("Usuário sem autorização para axecutar esta função.","Integracao ArMHAzena")
	Return()
//Else
//	Alert('Estou no parametro')
//	Return()
EndIf   

If (SC5->C5__STATUS > '4' .AND. SC5->C5__STATUS <= '8') .OR.  SC5->C5__STATUS = '2'
	DbSelectArea("SC9")
	DbSetOrder(1)
	If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		While !Eof() .And. (xFilial("SC9") + SC5->C5_NUM) == (SC9->C9_FILIAL + SC9->C9_PEDIDO)
		 	If Empty(SC9->C9_NFISCAL)
		  		A460Estorna()
		    EndIf
	     	DbSkip()
	     EndDo                 
	                
	EndIf 

                            
EndIf

DbSelectArea("SC9")
DbSetOrder(1)                       
If DbSeek(xFilial("SC9")+SC5->C5_NUM)
		MsgInfo("O pedido possui itens liberados, favor estornar a liberação antes do cancelamento.")
		Return()
EndIf

If SC5->(! Eof())
	RecLock("SC5",.F.)
	SC5->C5_LIBEROK := "N"      
	SC5->C5__STATUS := "12"
	SC5->C5_USERREA := SubStr(cUsuario,7,15)
	SC5->C5_DTREAB 	:= (dDataBase)
	SC5->C5_HRREAB 	:= (Time())						 
	SC5->C5_MAILSEP	:= ""
	SC5->C5_MAILEXP := ""								
	MsUnlock()
EndIf  			    		


                    
If ApMsgNoYes("Esta função irá executar o cancelamento do pedido no Armhazena. Deseja continuar?","Atenção")

        cPedido := SC5->C5_NUM
//////////////////////////////////////////////////////VALIDAÇÃO PARA ATIVAR INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA///////////////////////////////////////////		
//		U_LMG410Status() 
If (SC5->C5__STATUS > '4' .AND. SC5->C5__STATUS <= '8') .OR.  SC5->C5__STATUS = '2' .OR. SC5->C5__STATUS = '12'
		//If VldEnv(SC5->C5_NUM) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.
//		If StaticCall( LMG450, FVldPVLib, SC5->C5_NUM)
			//If lTesta
			//	Alert("Pedido sem Itens no Estoque")
			//Else
		        
			_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","","EXC","","")
	
	        If !Empty(_aResult)
	            If _aResult[1] == "S"
	                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
	                _lRet := .f.
	            Else 
			    	MsgInfo("Envio de exclusao concluido com sucesso","Integracao ArMHAzena")
				   SC5->(dbSetOrder(1))
				   SC5->(dbSeek(xFilial("SC5")+cPedido))
				   If SC5->(! Eof())
						RecLock("SC5",.F.)
						//SC5->C5_LIBEROK := "S"
						SC5->C5__STATUS := "12"
						SC5->C5_USERREA := SubStr(cUsuario,7,15)
						SC5->C5_DTREAB 	:= (dDataBase)
						SC5->C5_HRREAB 	:= (Time())						 
						SC5->C5_MAILSEP	:= ""
						SC5->C5_MAILEXP := ""						
						MsUnlock()
					EndIf  			    	
			    	
				EndIf  
	        Else
	        		Help( Nil, Nil, "EXCRECERR", Nil, "Erro ao enviar exclusao de documento para o WMS", 1, 0 ) 
	        		_lRet := .f.
	        	
	                
			EndIf		    
	
		
		                                                      
			
			//EndIf
			
		//EndIf 
	
//ElseIf SC5->C5__STATUS = '2'        
//	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por alçada comercial.", 1, 0 )
ElseIf SC5->C5__STATUS = '3'                                                          
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por Credito.", 1, 0 )
ElseIf SC5->C5__STATUS = '4'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido ainda não enviado para separação.", 1, 0 )                                            
EndIf

EndIf	

//////////////////////////////////////////////////////VALIDAÇÃO PARA ATIVAR INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA///////////////////////////////////////////				

                                    

Return (lRet)      








User Function ReabPed(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local lRet 	  := .T.         
Local _aResult	:= {}, _lAlt	:= .F. 	
        


If !RetCodUsr() $ AllTrim(GetMv("MV_ESTWMS"))
	MsgInfo("Usuário sem autorização para axecutar esta rotina.","Integracao ArMHAzena")
	Return()
EndIf
                  
                  
If ApMsgNoYes("Esta função irá executar a reabertura do pedido para alteração. Deseja continuar?","Atenção")                  
                  
cPedido := SC5->C5_NUM

If ALLTRIM(SC5->C5__STATUS) = "5" .or. ALLTRIM(SC5->C5__STATUS) = "6" .or. ALLTRIM(SC5->C5__STATUS) = "7" .or. ALLTRIM(SC5->C5__STATUS) = "8"
		//If VldEnv(SC5->C5_NUM) // COLEN 15102012 VALIDA SE EXISTE ALGUM ITEM SEM LIBERACAO.

		        
				   SC5->(dbSetOrder(1))
				   SC5->(dbSeek(xFilial("SC5")+cPedido))
				   If SC5->(! Eof())
						RecLock("SC5",.F.)
						If ALLTRIM(SC5->C5__STATUS) = "6" .or. ALLTRIM(SC5->C5__STATUS) = "7" .or. ALLTRIM(SC5->C5__STATUS) = "8" .or. ALLTRIM(SC5->C5__STATUS) = "9";
							.or. ALLTRIM(SC5->C5__STATUS) = "10" .or. ALLTRIM(SC5->C5__STATUS) = "11"						
							SC5->C5_YTPED := "02"
						EndIf				  

						SC5->C5__STATUS := "4" 
						SC5->C5_USERREA := SubStr(cUsuario,7,15)
						SC5->C5_DTREAB 	:= (dDataBase)
						SC5->C5_HRREAB 	:= (Time())
						SC5->C5_MAILSEP	:= ""
						SC5->C5_MAILEXP := ""
								
						MsUnlock()
				   EndIf  			    	
			    	
			   //	EndIf  
		
		//EndIf 
	
ElseIf SC5->C5__STATUS = '2'        
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por alçada comercial.", 1, 0 )
ElseIf SC5->C5__STATUS = '3'                                                          
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido bloqueado por Credito.", 1, 0 )
ElseIf SC5->C5__STATUS = '4'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido ainda não enviado para separação.", 1, 0 )                                            
ElseIf SC5->C5__STATUS = '9'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido já faturado.", 1, 0 )                      
ElseIf SC5->C5__STATUS = '10'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido já faturado e em processo de expedição.", 1, 0 )                                            
ElseIf SC5->C5__STATUS = '11'
	Help( Nil, Nil, "ENVNOTFIS", Nil, "Pedido já faturado e expedido.", 1, 0 )                                            		                      	
EndIf
	                                                                                                        
EndIf

Return (lRet) 









Static Function VldEnv(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local nContZer := 0
Local lRet 	  := .T.                    



cAlias := GetNextAlias()
cQuery := " SELECT COUNT(CASE WHEN F4_ESTOQUE = 'S' THEN C6_ITEM END) QMOVEST, "
cQuery += " COUNT(CASE WHEN C9_PRODUTO IS NULL THEN C6_ITEM END) QNLIB "
cQuery += " FROM "+    RetSqlName("SC6") + " SC6  "
cQuery += " INNER JOIN "+    RetSqlName("SF4") + " SF4 "
cQuery += " ON F4_CODIGO = C6_TES "
cQuery += " LEFT JOIN "+    RetSqlName("SC9") + " SC9 "
cQuery += " ON C9_FILIAL = C6_FILIAL AND C9_PEDIDO = C6_NUM AND C9_ITEM = C6_ITEM AND C9_PRODUTO = C6_PRODUTO AND SC9.D_E_L_E_T_ = ' '  "
cQuery += " WHERE C6_FILIAL = '"+xFilial("SC6")+"' AND C6_TES = F4_CODIGO AND SC6.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' AND C6_QTDVEN > 0 "
cQuery += " AND C6_NUM = '"+cPedido+"' "      
cQuery := ChangeQuery(cQuery)

TcQuery cQuery NEW ALIAS (cAlias)  

If (cAlias)->QNLIB > 0
	Aviso("ATENCAO","Foram encontrados itens do pedido pendentes de liberação. Favor entrar em contato com a TI informando o numero do Pedido: "+cPedido,{"OK"},3)

  /* SC5->(dbSetOrder(1))
   SC5->(dbSeek(xFilial("SC5")+cPedido))
   If SC5->(! Eof())
		RecLock("SC5",.F.)
		SC5->C5_LIBEROK := "S"
		SC5->C5__STATUS := "4" 
		MsUnlock()    
		U_AlertPed(cPedido)
	EndIf */ 
	Return(.F.)

Else

	SC9->(dbSetOrder(1))
	SC9->(dbSeek(xFilial("SC9")+cPedido))
	
	While SC9->(! Eof()) .And. SC9->C9_PEDIDO == cPedido
	
		If SC9->C9_QTDLIB > 0.00
			If Empty(SC9->C9_BLEST)
				nConLEs += 1
		   EndIf
		   If Empty(SC9->C9_BLCRED)
				nConLCr += 1
		   EndIf
	//	   If Posicione("SF4",1,xFilial("SF4")+
		   
	   	Else
			nConLEs += 1
			nConLCr += 1
			nContZer += 1
	   	EndIf
	   nContIt += 1
		SC9->(dbSkip())
	
	EndDo
	
	If nConLEs <> nContIt .Or. nConLCr <> nContIt
		Aviso("ATENCAO","Foram encontrados itens sem Liberação. Favor entrar em contato com a TI informando o numero do Pedido: "+cPedido,{"OK"},3)
		DisarmTransaction()
		lRet := .F.
	ElseIf nContZer = nContIt
		Aviso("ATENCAO","Pedido sem quantidades liberadas no estoque: "+cPedido,{"OK"},3)
		DisarmTransaction()
		lRet := .F.	                                                 
	Else
	/* VALIDAÇÃO PARA INTEGRAÇÃO DO PEDIDO DE VENDA COM MHA--------------------  
	   SC5->(dbSetOrder(1))
	   SC5->(dbSeek(xFilial("SC5")+cPedido))
	   If SC5->(! Eof())
			RecLock("SC5",.F.)
			SC5->C5_LIBEROK := "S"
			SC5->C5__STATUS := "06" 
			MsUnlock()
		EndIf      */ 

		If (cAlias)->QMOVEST = 0  
			SC5->(dbSetOrder(1))
   			SC5->(dbSeek(xFilial("SC5")+cPedido))
			If SC5->(! Eof())
				RecLock("SC5",.F.)
				SC5->C5_LIBEROK := "S"
				SC5->C5__STATUS := "8" 
				MsUnlock()
				//U_EmailApv(cPedido)
				
			EndIf
			lRet := .F.
		Else		
		   SC5->(dbSetOrder(1))
		   SC5->(dbSeek(xFilial("SC5")+cPedido))
		   If SC5->(! Eof())
				RecLock("SC5",.F.)
				SC5->C5_LIBEROK := "S"
				ALLTRIM(SC5->C5__STATUS) := "4" 
				MsUnlock()                        
			EndIf      	
			lRet := .T.
		EndIf
	EndIf

EndIf
Return (lRet)               





User Function PEBCDFT
	Local oDlg
	Local oMemo
	Local cMemo	  := ""
	Local oGet
	Local cGet1	  := ""
	Local cGet2
	Local oCombo
	Local cCombo  := ""
	Local aResumo := {"Cobranca/Mesmo","Cadastro","Cobranca","Falta Analise","Limite","Sem Item no Estoque","Serasa","Sintegra","Somente Antecipado","Outros"}
	Local _cProduto := ""
	
	_cProduto := aCols[N,aScan(aHeader, {|x| AllTrim(Upper(x[2])) = "C6_PRODUTO" })] 

	Posicione("SB1",1,xFilial("SB1")+_cProduto,"B1_BITMAP")

	Define MsDialog oDlg From 125,3 To 463,324 Title OemToAnsi("Visualização de Imagem do Produto.") Pixel
	@003,004 To 151,160 Label "Foto" Of oDlg Pixel
	

   If Empty(SB1->B1_BITMAP)
      @ 120,85 SAY "Não cadastrada." SIZE 50,8 PIXEL COLOR CLR_BLUE OF oDlg
   Else
      @ 004,005 REPOSITORY oBitPro OF oDlg NOBORDER SIZE 150,150 PIXEL
      Showbitmap(oBitPro,SB1->B1_BITMAP,"")
      oBitPro:lStretch:=.T.
      oBitPro:Refresh()
   EndIf
	


	Define sButton From 156,135 Type 2 Action oDlg:End() Enable Of oDlg
	Activate MsDialog oDlg center



Return   




User Function EspDef(cPedido)

Local nContIt := 0
Local nConLEs := 0
Local nConLCr := 0
Local lRet 	  := .T.         
Local _aResult	:= {}, _lAlt	:= .F. 	
        


If !RetCodUsr() $ AllTrim(GetMv("MV_ESTWMS"))
	MsgInfo("Usuário sem autorização para axecutar esta função.","Integracao ArMHAzena")
	Return()
//Else
//	Alert('Estou no parametro')
//	Return()
EndIf                                



If SC5->C5__STATUS <> '8' .AND. SC5->C5__STATUS <> '15'
	MsgInfo("Não é possível utilizar esta função no status de pedido atual.","Integracao ArMHAzena")
	Return()
//Else
//	Alert('Estou no parametro')
//	Return()
EndIf                                

                                        

SC5->(dbSetOrder(1))
SC5->(dbSeek(xFilial("SC5")+SC5->C5_NUM))
If SC5->(! Eof())
	RecLock("SC5",.F.)
	//SC5->C5_LIBEROK := "S"
	If SC5->C5__STATUS = '8' 
		SC5->C5__STATUS := "15"
	Else
		SC5->C5__STATUS := "8"
	EndIf
	MsUnlock()
EndIf  			    

                    

                                    

Return (lRet)  



User Function P410BOL()
	Local cAlias	:= "SC5"
	Local nReg		:= Recno()
	Local nOpc		:= 3
    

If Date() > SC5->C5_VENCBOL
	MsgInfo("não é possível a reemissão de boleto vencido.","Boleto Vencido")
	Return()       
Else
	U_BolPed01('1') 
EndIf 
	

	
	//Eval(bFiltraBrw)                    

Return(.T.)    