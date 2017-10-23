
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³CtGerComp ³ Autor ³ Simone Mie Sato       ³ Data ³ 14.03.02 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Gerar Arquivo Temporario para Comparativos (6 colunas)      |±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ .T. / .F.                                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpO1 = Objeto oMeter                                      ³±±
±±³          ³ ExpO2 = Objeto oText                                       ³±±
±±³          ³ ExpO3 = Objeto oDlg                                        ³±±
±±³          ³ ExpL1 = lEnd                                               ³±±
±±³          ³ ExpD1 = Data Inicial                                       ³±±
±±³          ³ ExpD2 = Data Final                                         ³±±
±±³          ³ ExpC1 = Alias do Arquivo                                   ³±±
±±³          ³ ExpC2 = Conta Inicial                                      ³±±
±±³          ³ ExpC3 = Conta Final                                        ³±±
±±³          ³ ExpC4 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC5 = Centro de Custo Final                              ³±±
±±³          ³ ExpC6 = Centro de Custo Inicial                            ³±±
±±³          ³ ExpC7 = Centro de Custo Final                              ³±±
±±³          ³ ExpC8 = Item Inicial                                       ³±±
±±³          ³ ExpC9 = Item Final                                         ³±±
±±³          ³ ExpC10= Classe de Valor Inicial                            ³±±
±±³          ³ ExpC11= Classe de Valor Final                              ³±±
±±³          ³ ExpC12= Moeda		                                      ³±±
±±³          ³ ExpC13= Saldo	                                          ³±±
±±³          ³ ExpA1 = Set Of Book	                                      ³±±
±±³          ³ ExpC13= Ate qual segmento sera impresso (nivel)			  ³±±
±±³          ³ ExpC8 = Filtra por Segmento		                          ³±±
±±³          ³ ExpC9 = Segmento Inicial		                              ³±±
±±³          ³ ExpC10= Segmento Final  		                              ³±±
±±³          ³ ExpC11= Segmento Contido em  	                          ³±±
±±³          ³ ExpL2 = Se Imprime Entidade sem movimento                  ³±±
±±³          ³ ExpL3 = Se Imprime Conta                                   ³±±
±±³          ³ ExpN1 = Grupo                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function _CTGerComp(oMeter,oText,oDlg,lEnd,cArqtmp,;
						dDataIni,dDataFim,cAlias,cIdent,cContaIni,;
				  		cContaFim,cCCIni,cCCFim,cItemIni,cItemFim,cClvlIni,	cClVlFim,cMoeda,;
				  		cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				  		lNImpMov,lImpConta,nGrupo,cHeader,lImpAntLP,dDataLP,nDivide,cTpVlr,;
				  		lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid,lImpSint,cString,;
				  		cFilUSU,lImpTotS,lImp4Ent,c1aEnt,c2aEnt,c3aEnt,c4aEnt,lAtSlBase,lValMed,lSalAcum,aSelFil,lTodasFil)
						
Local aTamConta		:= TAMSX3("CT1_CONTA")
Local aTamCtaRes	:= TAMSX3("CT1_RES")
Local aTamCC        := TAMSX3("CTT_CUSTO")
Local aTamCCRes 	:= TAMSX3("CTT_RES")
Local aTamItem  	:= TAMSX3("CTD_ITEM")
Local aTamItRes 	:= TAMSX3("CTD_RES")    
Local aTamClVl  	:= TAMSX3("CTH_CLVL")
Local aTamCvRes 	:= TAMSX3("CTH_RES")
Local aTamVal		:= TAMSX3("CT2_VALOR")
Local aCtbMoeda		:= {}
Local aSaveArea 	:= GetArea()
Local _aCampos
Local aStruTMP		:= {}
Local cChave
Local nTamCta 		:= Len(CriaVar("CT1->CT1_DESC"+cMoeda))
Local nTamItem		:= Len(CriaVar("CTD->CTD_DESC"+cMoeda))
Local nTamCC  		:= Len(CriaVar("CTT->CTT_DESC"+cMoeda))
Local nTamClVl		:= Len(CriaVar("CTH->CTH_DESC"+cMoeda))
Local nTamGrupo		:= Len(CriaVar("CT1->CT1_GRUPO"))
Local nDecimais		:= 0
Local cEntidIni		:= ""
Local cEntidFim		:= ""           
Local cEntidIni1	:= ""
Local cEntidFim1	:= ""
Local cEntidIni2	:= ""
Local cEntidFim2	:= ""
Local cArqTmp1		:= ""
Local lCusto		:= CtbMovSaldo("CTT")//Define se utiliza C.Custo
Local lItem 		:= CtbMovSaldo("CTD")//Define se utiliza Item
Local lClVl			:= CtbMovSaldo("CTH")//Define se utiliza Cl.Valor 
Local lAtSldBase	:= Iif(GetMV("MV_ATUSAL")== "S",.T.,.F.) 
Local lAtSldCmp		:= Iif(GetMV("MV_SLDCOMP")== "S",.T.,.F.)
Local nInicio		:= Val(cMoeda)
Local nFinal		:= Val(cMoeda)
Local cFilDe		:= xFilial(cAlias)
Local cFilate		:= xFilial(cAlias)
Local cMensagem		:= ""
Local nMeter		:= 0
Local lTemQry		:= .F.							/// SE UTILIZOU AS QUERYS PARA OBTER O SALDO DAS ANALITICAS
Local nTRB			:= 1
Local nCont			:= 0 
Local dDataAnt		:= CTOD("  /  /  ")
Local cFilXAnt		:= ""
Local nTamFilial 	:= "  " //IIf( FWCodFil, FWGETTAMFILIAL, TamSx3( "CT2_FILIAL" )[1] )

#IFDEF TOP
	Local nMin	:= 0 
	Local nMax	:= 0 
#ENDIF

private aselfil := {}

cIdent		:=	Iif(cIdent == Nil,'',cIdent)
nGrupo		:=	Iif(nGrupo == Nil,2,nGrupo)                                                 
cHeader		:= Iif(cHeader == Nil,'',cHeader)

/*
DEFAULT lImpSint	:= .F.                                              
DEFAULT cMoeda		:= "01"		//// SE NAO FOR INFORMADA A MOEDA ASSUME O PADRAO 01
DEFAULT lEntid		:= .F.
DEFAULT lMeses		:= .F.
DEFAULT lImpTotS	:= .F.
DEFAULT lImp4Ent	:= .F.
DEFAULT c1aEnt		:= ""
DEFAULT c2aEnt		:= ""
DEFAULT c3aEnt		:= ""
DEFAULT c4aEnt		:= ""
DEFAULT lAtSlBase	:= .T.
DEFAULT lValMed		:= .F.
DEFAULT lSalAcum	:= .F.
DEFAULT lTodasFil   := .F.
*/

dMinData := CTOD("")

// Retorna Decimais
aCtbMoeda := CTbMoeda(cMoeda)
nDecimais := aCtbMoeda[5]

_aCampos := {{ "CONTA"		, "C", 20          	, 0 },;  			// Codigo da Conta
	 		 { "NORMAL"		, "C", 01			, 0 },;			// Situacao
			 { "CTARES"		, "C", 20           , 0 },;  			// Codigo Reduzido da Conta
			 { "DESCCTA"	, "C", 30     		, 0 },;  			// Descricao da Conta
             { "CUSTO"		, "C", 09       	, 0 },; 	 		// Codigo do Centro de Custo
			 { "CCRES"		, "C", 09          	, 0 },;  			// Codigo Reduzido do Centro de Custo
			 { "DESCCC" 	, "C", 30     		, 0 },;  			// Descricao do Centro de Custo
	         { "ITEM"		, "C", 09         	, 0 },; 	 		// Codigo do Item          
			 { "ITEMRES" 	, "C", 09          	, 0 },;  			// Codigo Reduzido do Item
			 { "DESCITEM" 	, "C", 30      		, 0 },;  			// Descricao do Item
             { "CLVL"		, "C", 09         	, 0 },; 	 		// Codigo da Classe de Valor
             { "CLVLRES"	, "C", 09          	, 0 },; 		 	// Cod. Red. Classe de Valor
			 { "DESCCLVL"   , "C", 30      		, 0 },;  			// Descricao da Classe de Valor
			 { "COLUNA1"	, "N", 15          	, 02       },; 	// Saldo Anterior
   		 	 { "COLUNA2"   	, "N", 15          	, 02       },; 	// Saldo Anterior Debito
 			 { "COLUNA3"   	, "N", 15          	, 02       },; 	// Saldo Anterior Credito
			 { "COLUNA4" 	, "N", 15          	, 02       },;  	// Debito
			 { "COLUNA5" 	, "N", 15          	, 02       },;  	// Credito
			 { "COLUNA6"  	, "N", 15          	, 02       },;  	// Saldo Atual             
			 { "COLUNA7"	, "N", 15          	, 02       },; 	// Saldo Anterior
   		 	 { "COLUNA8"   	, "N", 15          	, 02       },; 	// Saldo Anterior Debito
 			 { "COLUNA9"   	, "N", 15          	, 02       },; 	// Saldo Anterior Credito
			 { "COLUNA10" 	, "N", 15          	, 02    },;  	// Debito
			 { "COLUNA11" 	, "N", 15          	, 02	},;  	// Credito
			 { "COLUNA12"  	, "N", 15          	, 02	}      ,;  	// Saldo Atual               			   
			 { "TIPOCONTA"	, "C", 01			, 0 },;			// Conta Analitica / Sintetica           
 			 { "TIPOCC"  	, "C", 01			, 0 },;			// Centro de Custo Analitico / Sintetico
 			 { "TIPOITEM"	, "C", 01			, 0 },;			// Item Analitica / Sintetica			 
 			 { "TIPOCLVL"	, "C", 01			, 0 },;			// Classe de Valor Analitica / Sintetica			 
  			 { "CTASUP"		, "C", 20 			, 0 },;			// Codigo do Centro de Custo Superior
 			 { "CCSUP"		, "C", 20       	, 0 },;			// Codigo do Centro de Custo Superior
			 { "ITSUP"		, "C", 09         	, 0 },;			// Codigo do Item Superior
 			 { "CLSUP"	    , "C", 09          	, 0 },;			// Codigo da Classe de Valor Superior
			 { "ORDEM"		, "C", 10			, 0 },;			// Ordem
			 { "GRUPO"		, "C", 04        	, 0 },;			// Grupo Contabil
		     { "TOTVIS"		, "C", 01			, 0 },;			 
		     { "SLDENT"		, "C", 01			, 0 },;			 
		     { "FATSLD"		, "C", 01			, 0 },;			 
		     { "VISENT"		, "C", 01			, 0 },;			 
		     { "IDENTIFI"	, "C", 01			, 0 },;			 			 
		     { "ESTOUR"  	, "C", 01			, 0 },;			//Define se eh conta estourada
			 { "NIVEL1"		, "L", 01			, 0 },;				// Logico para identificar se 
			 { "COLVISAO"	, "N", 01			, 0 },;				// Logico para identificar se 																	// eh de nivel 1 -> usado como
			 { "FILIAL"		, "C", 02        	, 0 }}				// Filial
			 																	// eh de nivel 1 -> usado como

///// TRATAMENTO PARA ATUALIZAÇÃO DE SALDO BASE
//Se os saldos basicos nao foram atualizados na dig. lancamentos
If !lAtSldBase
		dIniRep := ctod("")
  	If Need2Reproc(dDataFim,cMoeda,cSaldos,@dIniRep) 
		//Chama Rotina de Atualizacao de Saldos Basicos.
		oProcess := MsNewProcess():New({|lEnd|	CTBA190(.T.,dIniRep,dDataFim,cFilAnt,cFilAnt,cSaldos,.T.,cMoeda) },"","",.F.)
		oProcess:Activate()						
	EndIf
Endif

//// TRATAMENTO PARA ATUALIZAÇÃO DE SALDOS COMPOSTOS ANTES DE EXECUTAR A QUERY DE FILTRAGEM
aFiliais    := {}
aSelFil     := {}
lFiliais    := .t.
lTodasFil   := .t.

lFiliais := .t.
If lFiliais .And. Len( aSelFil ) <= 0
	aSelFil := AdmGetFil()
	If Len( aSelFil ) <= 0
		lRet := .F.
	EndIf
Else
	aSelFil := {cFilAnt} 
	aFiliais:= aSelFil
EndIf 
         
//alert(calias)
Do Case
Case cAlias == 'CTU'
	//Verificar se tem algum saldo a ser atualizado
		//Verificar se tem algum saldo a ser atualizado por entidade
	If cIdent == "CTT"
		cOrigem := 	'CT3'
	ElseIf cIdent == "CTD"      
		cOrigem := 	'CT4'
	ElseIf cIdent == "CTH"
		cOrigem := 	'CTI'		
	Else
		cOrigem := 	'CTI'		
	Endif
	
	If lFiliais                         	
		For nCont := 1 to Len(aFiliais)
			Ct360Data(cOrigem,'CTU',@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,aFiliais[nCont],,aSelFil,lTodasFil)		
			If !Empty(dMinData) 
				If nCont	== 1 
					dDataAnt	:= dMinData
				Else 
					If dMinData	< dDataAnt			
						dDataAnt	:= dMinData				
					EndIf
				EndIf
			EndIf		
		Next	
		//Menor data de todas as filiais		
		dMinData	:= dDataAnt
	Else	
		Ct360Data(cOrigem,'CTU',@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt,,aSelFil,lTodasFil)
	Endif
Case cAlias == 'CTV'
	cOrigem := "CT4"
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTV",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt,,aSelFil,lTodasFil)
Case cAlias == 'CTW'			
	cOrigem		:= 'CTI'	/// HEADER POR CLASSE DE VALORES
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTW",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt,,aSelFil,lTodasFil)
Case cAlias == 'CTX'			
	cOrigem		:= 'CTI'		
	//Verificar se tem algum saldo a ser atualizado
	Ct360Data(cOrigem,"CTX",@dMinData,lCusto,lItem,cFilDe,cFilAte,cSaldos,cMoeda,cMoeda,,,,,,,,,,cFilAnt,,aSelFil,lTodasFil)
EndCase	

DO CASE
CASE cAlias$("CTU/CTV/CTW/CTX/CTY")
	//Se o parametro MV_SLDCOMP estiver com "S",isto e, se devera atualizar os saldos compost.
	//na emissao dos relatorios, verifica se tem algum registro desatualizado e atualiza as
	//tabelas de saldos compostos.
	If !Empty(dMinData)
		If lAtSldCmp	//Se atualiza saldos compostos
			If lFiliais
				cFilXAnt	:= cFilAnt
				
				For nCont := 1 to Len(aFiliais)
					cFilAnt	:= aFiliais[nCont] 
					cFilDe	:= cFilAnt
					cFilAte	:= cFilAnt
					oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,,aSelFil,lTodasFil)},"","",.F.)
					oProcess:Activate()	
				Next			      
				cFilAnt		:= cFilXAnt
				cFilDe		:= cFilAnt
				cFilAte		:= cFilAnt
			Else
				oProcess := MsNewProcess():New({|lEnd|	CtAtSldCmp(oProcess,cAlias,cSaldos,cMoeda,dDataIni,cOrigem,dMinData,cFilDe,cFilAte,lCusto,lItem,lClVl,lAtSldBase,,,cFilAnt,aSelFil,lTodasFil)},"","",.F.)
				oProcess:Activate()	
			EndIf
		Else		//Se nao atualiza os saldos compostos, somente da mensagem
			cMensagem	:= "STR0016"
			cMensagem	+= "STR0017"
			MsgAlert(OemToAnsi(cMensagem))	//Os saldos compostos estao desatualizados...Favor atualiza-los					
			Return							//atraves da rotina de saldos compostos	
		EndIf    
	EndIf
ENDCASE

/// TRATAMENTO PARA OBTENÇÃO DO SALDO DAS CONTAS ANALITICAS
Do Case
Case cAlias  == "CT7"            
	//Se for Comparativo de Conta por 6 meses/12 meses
	cEntidIni	:= cContaIni
	cEntidFim	:= cContaFim
	If nGrupo == 2
		cChave := "CONTA"
	Else									// Indice por Grupo -> Totaliza por grupo
		cChave := "CONTA+GRUPO"
	EndIf
	#IFDEF TOP		
		If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
			If lMeses				
				If cTpVlr == "S"			/// COMPARATIVO DE SALDO ACUMULADO
					u__CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.T.,aSelFil)                                                           							
				Else						/// COMPARATIVO DE MOVIMENTO DO PERIODO
					u__CT7CompQry(dDataIni,dDataFim,cSaldos,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,.F.,aSelFil)                                                           			
				Endif
			EndIf	
		EndIf
	#ENDIF
Case cAlias == "CTU" 
	If cIdent == "CTT"
		cEntidIni	:= cCCIni
		cEntidFim	:= cCCFim
		cChave		:= "CUSTO"
	EndIf
Case cAlias == "CT3"            

	If !Empty(aSetOfBook[5])
		cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio. ")// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgInfo(cMensagem)
		RestArea(aSaveArea)
		Return
	Endif

	If cHeader == "CTT"
		cChave		:= "CUSTO+CONTA"
		cEntidIni1	:= cCCIni
		cEntidFim1	:= cCCFim
		cEntidIni2	:= cContaIni
		cEntidFim2	:= cContaFim
	ElseIf cHeader == "CT1"
		cChave		:= "CONTA+CUSTO"
		cEntidIni1	:= cContaIni
		cEntidFim1	:= cContaFim		
		cEntidIni2	:= cCCIni
		cEntidFim2	:= cCCFim	
	EndIf
	
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CT3CompQry(dDataIni,dDataFim,cCCIni,cCCFim,cContaIni,cContaFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU,cTpVlr=="S")
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
	
Case cAlias == "CTI"
	If lImp4Ent	//Se for Comparativo de 4 entidades
		#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
			If TcSrvType() != "AS/400"                     			
				CTICmp4Ent(dDataIni,dDataFim,cContaIni,cContafim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,;
						cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,cTpVlr,aMeses,cString,cFilUSU)
				If Empty(cFilUSU)
					cFILUSU := ".T."
				Endif
			EndIf
		#ENDIF
	EndIf		
	cChave	:= c1aEnt+"+"+c2aEnt+"+"+c3aEnt+"+"+c4aEnt	
Case cAlias == "CTV"	
	
	If !Empty(aSetOfBook[5])
		cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio. ")// O plano gerencial ainda nao esta disponivel nesse relatorio. 
		MsgInfo(cMensagem)
		RestArea(aSaveArea)
		Return
	Endif
              
	If cHeader == "CTT"
		cChave	:=	"CUSTO+ITEM"	
		cEntidIni1	:=	cCCIni
		cEntidFim1	:=	cCCFim
		cEntidIni2	:=	cItemIni
		cEntidFim2	:=	cItemFim	         	
	ElseIf cHeader == "CTD"        
		cChave	:=	"ITEM+CUSTO"	
		cEntidIni1	:=	cItemIni
		cEntidFim1	:=	cItemFim
		cEntidIni2	:=	cCCIni 
		cEntidFim2	:=	cCCFim		         	
	EndIf
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CTVCompQry(dDataIni,dDataFim,cCCIni,cCCFim,cItemIni,cItemFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
Case cAlias == "CTX"
	If cHeader == "CTH"    
		cChave		:= "CLVL+ITEM"
		cEntidIni1	:=	cClVlIni
		cEntidFim1	:=	cClVlFim
		cEntidIni2	:=	cItemIni
		cEntidFim2	:= cItemFim	
	ElseIf cHeader == "CTD"
		cChave		:= "ITEM+CLVL"
		cEntidIni1	:=	cItemIni
		cEntidFim1	:=	cItemFim	
		cEntidIni2	:=	cClVlIni
		cEntidFim2	:= 	cClVlFim	
	EndIf	
	#IFDEF TOP	//// MONTA A QUERY E O ARQUIVO TEMPORÁRIO TRBTMP JÁ COM OS SALDOS
		If TcSrvType() != "AS/400"                     			
			CTXCompQry(dDataIni,dDataFim,cItemIni,cItemFim,cClVlIni,cClVlFim,cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,lMeses,aMeses,lVlrZerado,lEntid,aEntid,cHeader,cString,cFILUSU,lImpAntLP,dDataLP)
			If Empty(cFilUSU)
				cFILUSU := ".T."
			Endif
		EndIf
	#ENDIF
EndCase

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
   cChave	:= "CONTA"
Endif

cArqTmp := CriaTrab(_aCampos, .T.)

	If ( Select ( "cArqTmp" ) <> 0 )
		dbSelectArea ( "cArqTmp" )
		dbCloseArea ()
	Endif
dbUseArea( .T.,, cArqTmp, "cArqTmp", .F., .F. )
	dbSelectArea("cArqTmp")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria Indice Temporario do Arquivo de Trabalho 1.             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqInd	:= CriaTrab(Nil, .F.)

IndRegua("cArqTmp",cArqInd,cChave,,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	cArqTmp1 := CriaTrab(, .F.)
	IndRegua("cArqTmp",cArqTmp1,"ORDEM",,,OemToAnsi("Selecionando Registros..."))  //"Selecionando Registros..."
Endif	

dbSelectArea("cArqTmp")
DbClearIndex()
dbSetIndex(cArqInd+OrdBagExt())

If !Empty(aSetOfBook[5])				// Indica qual o Plano Gerencial Anexado
	dbSetIndex(cArqTmp1+OrdBagExt())
Endif

#IFDEF TOP  
	If TcSrvType() != "AS/400" .and. Empty(aSetOfBook[5])				/// SÓ HÁ QUERY SEM O PLANO GERENCIAL
		//// SE FOR DEFINIÇÃO TOP 
		If Select("TRBTMP") > 0		/// E O ALIAS TRBTMP ESTIVER ABERTO (INDICANDO QUE A QUERY FOI EXECUTADA)
  			dbSelectArea("TRBTMP")
			aStruTMP := dbStruct()			/// OBTEM A ESTRUTURA DO TMP
	
			dbSelectArea("TRBTMP")
			If ValType(oMeter) == "O"			
				oMeter:SetTotal((cAlias)->(RecCount()))
				oMeter:Set(0)
			EndIf
			dbGoTop()						/// POSICIONA NO 1º REGISTRO DO TMP
	
			While TRBTMP->(!Eof())			/// REPLICA OS DADOS DA QUERY (TRBTMP) PARA P/ O TEMPORARIO EM DISCO
				nMeter++
				If nMeter%1000 = 0
					If ValType(oMeter) == "O"
			    		oMeter:Set(nMeter)				
			   		EndIf	    		
				EndIf

				If &("TRBTMP->("+cFILUSU+")")
					RecLock("cArqTMP",.T.)
					For nTRB := 1 to Len(aStruTMP)
						If Subs(aStruTmp[nTRB][1],1,6) == "COLUNA" .And. nDivide > 1 
							Field->&(aStruTMP[nTRB,1])	:=((TRBTMP->&(aStruTMP[nTRB,1])))/ndivide
						Else
							Field->&(aStruTMP[nTRB,1]) := TRBTMP->&(aStruTMP[nTRB,1])
						EndIf					
					Next 
					cArqTMP->FILIAL	:= cFilAnt
					cArqTMP->(MsUnlock())
				Endif

				TRBTMP->(dbSkip())
			Enddo

			dbSelectArea("TRBTMP")
			dbCloseArea()					/// FECHA O TRBTMP (RETORNADO DA QUERY)
			lTemQry := .T.
		Endif
	EndIf		
#ENDIF

dbSelectArea("cArqTmp")
dbSetOrder(1)

If !Empty(aSetOfBook[5])				// Se houve Indicacao de Plano Gerencial Anexado
	// Monta Arquivo Lendo Plano Gerencial                                   
	// Neste caso a filtragem de entidades contabeis é desprezada!
	// Por enquanto a opcao de emitir o relatorio com Plano Gerencial ainda 
	// nao esta disponivel para esse relatorio. 
	If cAlias $ "CT7"					// Se for Entidade x Conta
		CtbPlGerCm(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cMoeda,aSetOfBook,;
					cAlias,cIdent,lImpAntLP,dDataLP,lVlrZerado,.t.,aSelFil,lMeses,aMeses,lImpSint,cTpVlr,,,cSaldos,lValMed,lSalAcum)
		dbSetOrder(2)
	Else
		cMensagem	:= OemToAnsi("O plano gerencial ainda nao esta disponivel nesse relatorio. ")
		MsgInfo(cMensagem)	
	EndIf	
Else
	If cAlias $ 'CT7/CTU'		//So Imprime Entidade                                
//		alert("linha 509")
//		alert(str(len(aselfil)))
		#IFDEF TOP
			If lMeses .And. TcSrvType() != "AS/400"
				//So ira gravar as contas sinteticas se mandar imprimir as contas sinteticas ou ambas.
				If lImpSint
					//Gravacao das contas superiores.
					SupCompCt7(oMeter,lMeses,aMeses,cMoeda,cTpVlr)
				Endif
			Else		
		#ENDIF
		CtCmpSoEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni,cEntidFim,cMoeda,;
		cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,lNImpMov,cAlias,cIdent,;
		lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,lImpAntLP,dDataLP,nDivide,;
		cTpVlr,.t.,aSelFil,lMeses,aMeses,cFilUsu)
		#IFDEF TOP
			Endif
		#ENDIF		        
		
	ElseIf cAlias == "CT3"			
	
		If lMeses
			#IFNDEF TOP			
				/// SE FOR CODEBASE OU TOP SEM TER PASSADO PELAS QUERYS
				CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,aSelFil,lTodasFil)					
			#ELSE
				If TcSrvType() == "AS/400"                     		  					
					CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,aSelFil,lTodasFil)					
				EndIf	
			#ENDIF        
			
			If lImpSint .Or. lImpTotS
				SupCompMes(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
			EndIf			
			
		EndIf			
	ElseIf cAlias == "CTI"
		If lImp4Ent // Se fro comparativo de 4 entidades		
			#IFNDEF TOP					                
				/// SE FOR CODEBASE OU TOP SEM TER PASSADO PELAS QUERYS
				CtCmp4Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,cContafim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,;
						cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,cTpVlr,aMeses,cString,cFilUSU,lAtSlBase,c1aEnt,c2aEnt,c3aEnt,c4aEnt,nDivide)			
			#ELSE
				If TcSrvType() == "AS/400"                     		  								
					CtCmp4Ent(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cContaIni,cContafim,cCCIni,cCCFim,cItemIni,cItemFim,cClVlIni,cClVlFim,;
							cMoeda,cSaldos,aSetOfBook,lImpAntLP,dDataLP,cTpVlr,aMeses,cString,cFilUSU,lAtSlBase,c1aEnt,c2aEnt,c3aEnt,c4aEnt,nDivide)			
				EndIf			
			#ENDIF					
		EndIf		
	ElseIf cAlias $ "CTV/CTX"				//// SE FOR ENTIDADE x ITEM CONTABIL
		If lEntid	//Relatorio Comparativo de 1 Entidade por 6 Entidades
		
			#IFNDEF TOP
				CtCmpEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,;
				cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lVlrZerado,aEntid,aSelFil,lTodasFil)							
			#ELSE
				If TcSrvType() == "AS/400"                     		  								
					CtCmpEntid(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,;
					cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lVlrZerado,aEntid,aSelFil,lTodasFil)				
				EndIf
			#ENDIF  
			
			If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
				/// Usa cHeader x cAlias invertidas para compor as entidades sintéticas (neste caso sintetica do CTD ao invés do CTT)
				SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cAlias,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cHeader,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,lEntid,aEntid)
			Endif			
		Else
		
			/// Relatórios Comparativo 2 Entidades s/ Conta
			#IFNDEF TOP 
				CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,aSelFil,lTodasFil)		
			#ELSE
				If TcSrvType() == "AS/400"                     		  					
					CtCmpComp(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
					cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
					lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
					cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado,aSelFil,lTodasFil)						
				EndIf
			#ENDIF		
			
			If lImpSint  // SE DEVE IMPRIMIR AS SINTETICAS
				SupCompEnt(oMeter,oText,oDlg,lEnd,dDataIni,dDataFim,cEntidIni1,cEntidFim1,cEntidIni2,;
				cEntidFim2,cHeader,cMoeda,cSaldos,aSetOfBook,cSegmento,cSegIni,cSegFim,cFiltSegm,;
				lNImpMov,cAlias,lCusto,lItem,lClVl,lAtSldBase,lAtSldCmp,nInicio,nFinal,;
				cFilDe,cFilAte,lImpAntLP,dDataLP,nDivide,cTpVlr,lFiliais,aFiliais,lMeses,aMeses,lVlrZerado)
			Endif

		EndIf
	Endif
EndIf

RestArea(aSaveArea)

Return cArqTmp

/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³CT7CompQry ³Autor  ³ Simone Mie Sato       ³ Data ³ 11.06.03 		     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Query para comparativo de conta x 6/12 meses                			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³CT7CompQry()                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                  			 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ oMeter	= Objeto oMeter                     	               		 ³±±
±±³          ³ oText 	= Objeto oText                      	                	 ³±±
±±³          ³ oDlg  	= Objeto oDlg                       	                	 ³±±
±±³          ³ lEnd 	 = Acao do CodeBlock                 	                	 ³±±
±±³          ³ dDataIni  = Data Inicial                      	                	 ³±±
±±³          ³ dDataFim = Data Final                     	                 		 ³±±
±±³          ³ cMoeda	= Moeda                              	              		 ³±±
±±³          ³ aSetOfBook	= Array aSetOfBook             	                 		 ³±±
±±³          ³ cAlias    	= Alias a ser utilizado        	                 		 ³±±
±±³          ³ cIdent    	= Identficador                 	                 		 ³±±
±±³          ³ lImpAntLP	= Define se ira considerar apuracao de lucros/perdas	 ³±±
±±³          ³ dDataLP  	= Data de apuracao de lucros/perdas a ser considerado 	 ³±±
±±³          ³ lVlrZerado	= Define se ira imprimir os valores zerados.           	 ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
user Function _CT7CompQry(dDataIni,dDataFim,cTpSaldo,cMoeda,cContaIni,cContaFim,aSetOfBook,lVlrZerado,lMeses,aMeses,cString,cFILUSU,lImpAntLP,dDataLP,lAcum,aSelFil)                                                           

Local aSaveArea	:= GetArea()
Local cQuery	:= ""
Local nColunas	:= 0
Local aTamVlr	:= TAMSX3("CT7_DEBITO")
Local nStr		:= 1
Local lCT1EXDTFIM := CtbExDtFim("CT1") 

lVlrZerado	:= .F.
lAcum		:= .F.

cQuery := " SELECT CT1_CONTA CONTA,CT1_NORMAL NORMAL, CT1_RES CTARES, CT1_DESC"+cMoeda+" DESCCTA,  	"
If lCT1EXDTFIM 
	cQuery += " CT1_DTEXSF CT1DTEXSF, "
EndIf
cQuery += " 	CT1_CLASSE TIPOCONTA, CT1_GRUPO GRUPO, CT1_CTASUP CTASUP, "

////////////////////////////////////////////////////////////
//// TRATAMENTO PARA O FILTRO DE USUÁRIO NO RELATORIO
////////////////////////////////////////////////////////////
cCampUSU  := ""										//// DECLARA VARIAVEL COM OS CAMPOS DO FILTRO DE USUÁRIO
If !Empty(cFILUSU)									//// SE O FILTRO DE USUÁRIO NAO ESTIVER VAZIO
	aStrSTRU := (cString)->(dbStruct())				//// OBTEM A ESTRUTURA DA TABELA USADA NA FILTRAGEM
	nStruLen := Len(aStrSTRU)						
	For nStr := 1 to nStruLen                       //// LE A ESTRUTURA DA TABELA 
		cCampUSU += aStrSTRU[nStr][1]+","			//// ADICIONANDO OS CAMPOS PARA FILTRAGEM POSTERIOR
	Next
Endif
cQuery += cCampUSU									//// ADICIONA OS CAMPOS NA QUERY
////////////////////////////////////////////////////////////

If lMeses
	For nColunas := 1 to Len(aMeses)
		cQuery += " 	(SELECT SUM(CT7_CREDIT) - SUM(CT7_DEBITO) "
		cQuery += "			 	FROM "+RetSqlName("CT7")+" CT7 "
//		alert(str(len(aselfil)))
//		alert(aselfil[1])
//		alert(aselfil[2])

		If Len(aSelFil) > 1
			cQuery += " WHERE " //CT7.CT7_FILIAL	= '"+xFilial("CT7")+"' "
		else
			cQuery += " WHERE CT7.CT7_FILIAL	= '"+aselfil[1]+"' AND "
		Endif
//		cQuery += " 			WHERE "   //CT7.CT7_FILIAL = '"+xFilial("CT7")+"' "
		cQuery += " 			ARQ.CT1_CONTA	= CT7_CONTA "
		cQuery += " 			AND CT7_MOEDA = '"+cMoeda+"' "
		cQuery += " 			AND CT7_TPSALD = '"+cTpSaldo+"' "
		If lAcum //.and. nColunas == 1/// SE FOR ACUMULADO, A PRIMEIRA COLUNA TERA O SALDO ATE O FINAL DO PERIODO
			cQuery += " 			AND CT7_DATA <= '"+DTOS(aMeses[nColunas][3])+"' "
		Else						/// AS DEMAIS COLUNAS SEMPRE SOMAM O MOVIMENTO NO PERIODO. (CALCULO NO RELATORIO)
			cQuery += " 			AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "
		Endif
		If lImpAntLP .and. dDataLP >= aMeses[nColunas][2]
			cQuery += " AND CT7_LP <> 'Z' "
		Endif
		cQuery += " 			AND CT7.D_E_L_E_T_ = ' ') COLUNA"+Str(nColunas,Iif(nColunas>9,2,1))+" "
		
		If nColunas <> Len(aMeses)
			cQuery += ", "
		EndIf		
	Next	
EndIf
	
cQuery += " 	FROM "+RetSqlName("CT1")+" ARQ "
cQuery += " 	WHERE ARQ.CT1_FILIAL = '"+xFilial("CT1")+"' "
cQuery += " 	AND ARQ.CT1_CONTA BETWEEN '"+cContaIni+"' AND '"+cContaFim+"' "
cQuery += " 	AND ARQ.CT1_CLASSE = '2' "
	
If !Empty(aSetOfBook[1])										//// SE HOUVER CODIGO DE CONFIGURAÇÃO DE LIVROS
	cQuery += " 	AND CT1_BOOK LIKE '%"+aSetOfBook[1]+"%' "  // FILTRA SOMENTE CONTAS DO MESMO SETOFBOOKS
Endif	
cQuery += " 	AND ARQ.D_E_L_E_T_ = ' ' "
  
If !lVlrZerado
	If lMeses
		cQuery += " 	AND ( "
		For nColunas := 1 to Len(aMeses)
			cQuery += "	(SELECT ROUND(SUM(CT7_CREDIT),2) - ROUND(SUM(CT7_DEBITO),2) "
//			alert(str(len(aselfil)))
			cQuery += " FROM "+RetSqlName("CT7")+" CT7 "
			If Len(aSelFil ) > 1
				cQuery += " WHERE " //CT7.CT7_FILIAL	= '"+xFilial("CT7")+"' "
			else
				cQuery += " WHERE CT7.CT7_FILIAL	= '"+aselfil[1]+"' AND "
			Endif
			cQuery += " ARQ.CT1_CONTA	= CT7_CONTA "
			cQuery += " AND CT7_MOEDA = '"+cMoeda+"' "
			cQuery += " AND CT7_TPSALD = '"+cTpSaldo+"' "
			If lAcum 
				cQuery += " AND CT7_DATA <= '"+DTOS(aMeses[nColunas][3])+"' "			
			Else
				cQuery += " AND CT7_DATA BETWEEN '"+DTOS(aMeses[nColunas][2])+"' AND '"+DTOS(aMeses[nColunas][3])+"' "
			EndIf
			If lImpAntLP .and. dDataLP >= aMeses[nColunas][2]
				cQuery += " AND CT7_LP <> 'Z' "
			Endif
			cQuery += " 	AND CT7.D_E_L_E_T_ = ' ') <> 0 "
			If nColunas <> Len(aMeses)
				cQuery += " 	OR "
			EndIf
		Next
		cQuery += " ) "
	EndIf
Endif
cQuery := ChangeQuery(cQuery)		   

If Select("TRBTMP") > 0
	dbSelectArea("TRBTMP")
	dbCloseArea()
Endif	

dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TRBTMP",.T.,.F.)
If lMeses
	For nColunas := 1 to Len(aMeses)
		TcSetField("TRBTMP","COLUNA"+Str(nColunas,Iif(nColunas>9,2,1)),"N",aTamVlr[1],aTamVlr[2])
	Next                                                                                           
	If lCT1EXDTFIM 
		TcSetField("TRBTMP","CT1DTEXSF","D",8,0)	
		TCSetField("TRBTMP","CT1_DTEXSF","D",8,0)	
 		TCSetField("TRBTMP","CT1_DTEXIS","D",8,0)
		TCSetField("TRBTMP","CT1_DTBLIN","D",8,0)
		TCSetField("TRBTMP","CT1_DTBLFI","D",8,0)
	EndIf
EndIf


RestArea(aSaveArea)

Return
