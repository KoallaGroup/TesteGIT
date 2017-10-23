#Include "PROTHEUS.CH"

Static cEmpInt	:= GetJobProfString('cEmpInt', '' ) //--> Empresa onde ocorrerá a integração
Static cFilInt	:= GetJobProfString('cFilInt', '' ) //--> Filial onde ocorrerá a integração

//-------------------------------------------------------------------
/*{Protheus.doc} MINTWEB
Importação dos pedidos do site SZA/SZB para SUA/SUB

@author Ivan Morelatto Toré
@since 16/07/2014
@version P11
*/
//-------------------------------------------------------------------
User Function MINTWEB(lJob)
Local cDescr := "Essa rotina tem como objetivo integrar os pedidos do WebLine."

Default lJob := .F.

If !lJob
	tNewProcess():New( "MINTWEB", "Integração WebLine", { |oSelf| MIntWebProc( oSelf, lJob ) }, cDescr,,,,,,.T.,.T. )
Else
	MIntWebProc( Nil, lJob )
Endif

Return

//-------------------------------------------------------------------
// Rotina para processamento da integração
//-------------------------------------------------------------------
Static Function MIntWebProc( oPrc, lJob )

Local aAreaAtu 	:= GetArea()
Local aAreaSUA	:= SUA->( GetArea() )
Local cQuery 	:= "", _aSZN := {}, _aTES := {}, _aKit := {}, _aCorte := {}, _aInat := {}, _aSld := {}
Local nTotRegs	:= _cUFTab := _cTimeIni := "", _lItemOK := .t., _aErroKit := {}
Local cRotina	:= "2" //Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca

Local cPara		:= ""
Local cAssunto  := "Erro Integração WebLine"

Local nOperPed	:= nz := _nSZBLc01 := _nSZBLc02 := _nQtSaldo := _nSequen := 0
Local cCodAte	:= "", _cItem := _cItemAlt := _cArmz := ""
Local aCabec 	:= {} 
Local aItens 	:= {}, _lQuebra := .f.
Local aLinha 	:= {}, _aTmpSZA := {}
Local cLogExec	:= "", _cTes := ""

Private lMsErroAuto := .F., _nSldDsp := _nQLoc01 := _nQLoc02 := 0

// Legenda ZA_FLAGIMP
// 1 = Disponivel para integração
// 2 = Em processo de integração
// 3 = Integrado OK
// 4 = Problemas na Integração 

// Monta query para obter os registros que serão importados
cQuery := "SELECT R_E_C_N_O_ RECSZA "
cQuery += "  FROM " + RetSQLName( "SZA" )
cQuery += " WHERE ZA_FILIAL  = '" + xFilial( "SZA" ) + "' "
cQuery += "   AND ZA_FLAGIMP = '1' "
cQuery += "   AND D_E_L_E_T_ = ' ' "

// Abre area temporária
If Select( "TMP_SZA" ) > 0
	TMP_SZA->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZA", .T., .F. )

If Eof()
    TMP_SZA->( dbCloseArea() )
    Return
EndIf

// Flag registros como em processo de integração
TMP_SZA->( dbGoTop() )
  
_aTmpSZA := {}
While !(TMP_SZA->(Eof()))
    nTotRegs++						
    DbselectArea("SZA")
    DbGoTo(TMP_SZA->RECSZA)
    RecLock("SZA", .F.)
    SZA->ZA_FLAGIMP := "2"
    SZA->(MsUnLock())
    
    AADD(_aTmpSZA,TMP_SZA->RECSZA)
    
    DbSelectArea("TMP_SZA")
    DbSkip()
EndDo

// Caso tenha tela montagem da regua de processamento
If !lJob
	oPrc:SetRegua1( nTotRegs )
Endif

For nz := 1 To Len(_aTmpSZA)
	
	// Incrementa Regua
	If !lJob
		oPrc:IncRegua1( "Integrando Pedidos" )
	Endif

	// Posiciona Registro
	SZA->( dbGoTo( _aTmpSZA[nz] ) )
	
		
	// Zera Variaveis
	aCabec 	  := {}
	aItens 	  := {}
	aLinha 	  := {}
	nOperPed  := 0
	_aSZN     := {}
	_aTES     := {}
	_aKit 	  := {}
	_aCorte   := {}
	_aInat    := {}
	_aErroKit := {}
	_aSld     := {}
	_cItem	  := StrZero(0,TamSX3("UB_ITEM")[1])
	
	// Define a operação
	SUA->( dbOrderNickName( "UA_PEDMEX" ) )
	If SUA->( dbSeek( xFilial("SUA") + SZA->ZA_FILIAL + SZA->ZA_PEDMEX ) )
		nOperPed := 4
		cCodAte  := SUA->UA_NUM
	Else
		nOperPed := 3
		cCodAte  := U_ITMKNSUA() //TkNumero("SUA","UA_NUM")
	Endif
	//RestArea( aAreaSUA ) 

    DbSelectArea("SA1")
    DbSetOrder(1)
    If !DbSeek(xFilial("SA1") + SZA->ZA_CLIENTE + SZA->ZA_LOJA)
    	    DbSelectArea("SZA")	
    		RecLock( "SZA", .F. )
    		SZA->ZA_FLAGIMP := "4"
    		SZA->ZA_ERRO := "Cliente nao cadastrado no sistema."
    		SZA->( MsUnLock() ) 		
    		Loop
	EndIf
	    		   
    If nOperPed == 3

		DbSelectArea("SZK")
		DbSetOrder(1)
		If DbSeek(xFilial("SZK") + SZA->ZA_SEGISP + SA1->A1_EST)
			_cUFTab := SZK->ZK_TABPAD
		Else
			_cUFTab := "BR"
		EndIf        
    EndIf
	
	If Empty(SZA->ZA_MOTCAN) .Or. nOperPed != 4 
		
    	// Alimenta cabeçalho
		aAdd( aCabec, { "UA_NUM"		, cCodAte											, Nil } )
    	aAdd( aCabec, { "UA_CLIENTE"	, SZA->ZA_CLIENTE									, Nil } )
    	aAdd( aCabec, { "UA_LOJA"		, SZA->ZA_LOJA										, Nil } )
    	aAdd( aCabec, { "UA__TIPPED"	, SZA->ZA_TIPPED 									, Nil } )
    	aAdd( aCabec, { "UA__FILIAL"	, SZA->ZA_FILIAL									, Nil } )
    	aAdd( aCabec, { "UA__SEGISP"	, SZA->ZA_SEGISP 									, Nil } )
    	aAdd( aCabec, { "UA_OPERADO"	, Alltrim(GetMv("MV__WEBOPE"))						, Nil } )
    	aAdd( aCabec, { "UA_CONDPG"		, SZA->ZA_CONDPG  									, Nil } )
    	aAdd( aCabec, { "UA_TABELA"		, Alltrim(GetMv("MV__TABBRA"))						, Nil } )
   		aAdd( aCabec, { "UA_OPER"		, "1"   											, Nil } )
    	If nOperPed == 3
    	   aAdd( aCabec, { "UA__UFTAB"      , _cUFTab                                       , Nil } )
    	   aAdd( aCabec, { "UA__PRVFAT"     , SZA->ZA_PREVFAT                               , Nil } )
    	   aAdd( aCabec, { "UA_EMISSAO"     , SZA->ZA_EMISSAO                               , Nil } )
    	EndIf
    	aAdd( aCabec, { "UA__TIPPED"	, SZA->ZA_TIPPED 									, Nil } )
    	aAdd( aCabec, { "UA__TABPRC"	, SZA->ZA_TABELA 									, Nil } )
    	aAdd( aCabec, { "UA_VEND"		, SZA->ZA_VEND   									, Nil } )
    	aAdd( aCabec, { "UA_TMK"		, "4"    											, Nil } )    	
    	aAdd( aCabec, { "UA_FRETE"		, SZA->ZA_FRETE  									, Nil } )
    	aAdd( aCabec, { "UA__STATUS"	, SZA->ZA_STATUS  									, Nil } )
    	aAdd( aCabec, { "UA_TRANSP"		, SZA->ZA_TRANSP 									, Nil } )
    	aAdd( aCabec, { "UA_TPFRETE"	, IIF(SZA->ZA_TPFRETE == "T","C",SZA->ZA_TPFRETE)	, Nil } )  
    	aAdd( aCabec, { "UA__DESCAP"	, SZA->ZA_DESC1										, Nil } )
    	aAdd( aCabec, { "UA__LJAENT"	, SZA->ZA_LJAENT 									, Nil } )
    	aAdd( aCabec, { "UA__LJACOB"	, SZA->ZA_LJACOB 									, Nil } )
    	aAdd( aCabec, { "UA__TPORI"		, SZA->ZA_TPORI										, Nil } )  
    	aAdd( aCabec, { "UA__TPOPE"		, SZA->ZA_TPOPE  									, Nil } )
    	aAdd( aCabec, { "UA__PREPOS"	, SZA->ZA_PREPOS 									, Nil } )
    	aAdd( aCabec, { "UA__PEDMEX"	, SZA->ZA_PEDMEX									, Nil } ) 
    	aAdd( aCabec, { "UA__PRIORI"    , "0"                                               , Nil } )
    	aAdd( aCabec, { "UA__SEGISP"	, SZA->ZA_SEGISP									, Nil } )
    	aAdd( aCabec, { "UA__REDESP"	, SZA->ZA_REDESP									, Nil } )
    	aAdd( aCabec, { "UA__RESEST"	, IIF(!Empty(SZA->ZA_MOTCAN),"N",SZA->ZA_RESERV)	, Nil } )
    	aAdd( aCabec, { "UA__MOTCAN"	, SZA->ZA_MOTCAN									, Nil } )
    	aAdd( aCabec, { "UA__OBSPED"	, SZA->ZA_OBSPED									, Nil } )
    		  
    	// Alimenta Itens
    	cQuery := "SELECT R_E_C_N_O_ RECSZB
        cQuery += "  FROM " + RetSQlName( "SZB" )
        cQuery += " WHERE ZB_FILIAL  = '" + xFilial( "SZB" ) + "' "
        cQuery += "   AND ZB_NUM     = '" + SZA->ZA_PEDMEX + "' "
        cQuery += "   AND D_E_L_E_T_ = ' ' "
        cQuery += " ORDER BY To_Number(ZB_ITEM) "
        
        If Select( "TMP_SZB" ) > 0
        	TMP_SZB->( dbCloseArea() )
        Endif
        
        dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZB", .T., .F. )
        
        While TMP_SZB->( !Eof() )
    
    		SZB->( dbGoTo( TMP_SZB->RECSZB ) )
    		
    		aLinha := {}
        	_lItemOK := .t.
        	If nOperPed == 3 .And. !Empty(SZB->ZB_MOTCAN)
        		//Não inclui o item cancelado no call center. Envia direto para tabela de vendas perdidas
        		AADD(_aSZN,SZB->(Recno()))
        	Else      	
        		_cTes := _cItemAlt := _cArmz := _cItePai := _cItFilh := ""
        		_lQuebra := .f.
        		
        		If nOperPed == 4 //verifica se o item já existe na SUB 
            		_cTes  	  := IMWEBITE(SZB->ZB_FILIAL,cCodAte,SZB->ZB_NUM,SZB->ZB_ITEM,"T")
            		_cItemAlt := IMWEBITE(SZB->ZB_FILIAL,cCodAte,SZB->ZB_NUM,SZB->ZB_ITEM,"I")
            	EndIf
            	
            	If Empty(_cTes)
                    _cTes := U_IFISA04(xFilial("SUA"),SZB->ZB_PRODUTO,SZA->ZA_CLIENTE,SZA->ZA_LOJA,SA1->A1_TIPO,"C",SZA->ZA_TIPPED,.t.)
        		EndIf
        		
        		If Empty(_cItemAlt)
                    _cItem := Soma1(_cItem,TamSX3("UB_ITEM")[1])
                Else
                	_cItem := _cItemAlt
        		EndIf
        		
        	    If !Empty(_cTes)
  	        		//Valida algumas informações do produto
        	    	_lItemOK := MWEBVLPRD(SZB->ZB_PRODUTO,SZB->ZB_CODKIT,SZB->ZB_CODACE,@_aKit,@_aCorte,@_aInat,@_aErroKit)
        	    	_nSldDsp := _nQLoc01 := _nQLoc02 := _nSZBLc01 := _nSZBLc02 := _nQtSaldo := 0
        	    	        	    	
        	    	If _lItemOK
        	    		If MWEBVLSLD(cCodAte,@_aSld)
        	    			
        	    			If SZA->ZA_RESERV == "S" .And. Alltrim(SZA->ZA_SEGISP) $ GetMv("MV__ARMSEG")
	        	    			If _nQLoc01 > 0 .And. _nQLoc01 >= SZB->ZB_QUANT //Armazém 01 Atende toda demanda
	        	    				_nSZBLc01 := SZB->ZB_QUANT
	        	    				_cArmz := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
	        	    				_nSequen := 1
	        	    			ElseIf _nQLoc01 > 0 .And. _nQLoc01 < SZB->ZB_QUANT //Armazém 01 atende parte da quantidade
	        	    				_nSZBLc01 := _nQLoc01
	        	    				_nQtSaldo := SZB->ZB_QUANT - _nSZBLc01 //Quantidade que falta ser atendida para o item 
	        	    				_nSequen := 1
	        	    				
	        	    				If _nQLoc02 > 0 //Verifico quanto do armazém 02 será utilizado para compor o item
	        	    					_lQuebra := .t.
	        	    					If _nQLoc02 >= _nQtSaldo
	        	    						_nSZBLc02 := _nQtSaldo
	        	    					Else 
	        	    						_nSZBLc02 := _nQLoc02
	        	    					EndIf
	        	    					_nSequen := 2
	        	    				EndIf
	        	    			ElseIf _nQLoc02 > 0 .And. _nQLoc01 <= 0 //Quantidad eserá atendida apenas pelo armazém 02
        	    					If _nQLoc02 >= SZB->ZB_QUANT
        	    						_nSZBLc02 := SZB->ZB_QUANT
        	    					Else 
        	    						_nSZBLc02 := _nQLoc02
        	    					EndIf
        	    					_cArmz := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
        	    					_nSequen := 1
	        	    			EndIf
	        	    		ElseIf SZA->ZA_RESERV == "S"
	        	    			If _nQLoc01 > 0 .And. _nQLoc01 >= SZB->ZB_QUANT
	        	    				_nSZBLc01 := SZB->ZB_QUANT
	        	    			Else
	        	    				_nSZBLc01 := _nQLoc01 
	        	    			EndIf
        	    				_cArmz := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
        	    				_nSequen := 1
        	    			Else //Pedido sem reserva
        	    				_nSZBLc01 := SZB->ZB_QUANT
        	    				_cArmz := SZB->ZB_LOCAL
        	    				_nSequen := 1
	        	    		EndIf
	        	    		
	        	    		For _nx := 1 To _nSequen
	        	    		
	        	    			If _nSequen == 1
	        	    				_nSldDsp := IIF(_nSZBLc01 > 0,_nSZBLc01,_nSZBLc02)
	        	    				If Empty(_cArmz)
	        	    					_cArmz := IIF(_nSZBLc01 > 0,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]))
	        	    				EndIf
	        	    			Else
	        	    				If _nx == 1
	        	    					_nSldDsp := _nSZBLc01
	        	    					_cArmz := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
	        	    					
	        	    					//Busca a sequencia do proximo item
					                    If nOperPed == 3
					                    	_cItFilh := Soma1(_cItem,TamSX3("UB_ITEM")[1])
					                    	_cItePai := ""
					                    EndIf
	        	    				Else
	        	    					aLinha := {}
	        	    					_nSldDsp := _nSZBLc02
	        	    					_cArmz 	 := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
	        	    					_cItePai := _cItem
	        	    					_cItem 	 := _cItFilh
	        	    				EndIf
	        	    			EndIf
	        	    			
			        	    	aAdd( aLinha, { "UB_ITEM"		, _cItem                                                    , Nil } )	   
			                    aAdd( aLinha, { "UB__PEDMEX"    , SZB->ZB_NUM                                               , Nil } )
			                    aAdd( aLinha, { "UB__ITEMEX"    , SZB->ZB_ITEM                                              , Nil } )
			        	    	aAdd( aLinha, { "UB__CODKIT"	, SZB->ZB_CODKIT 											, Nil } )
			        	    	aAdd( aLinha, { "UB__CODACE"	, SZB->ZB_CODACE 											, Nil } )
			                    aAdd( aLinha, { "UB__DESCP"     , SZB->ZB_DESCP                                             , Nil } )
			                    aAdd( aLinha, { "UB__DESCCP"    , SZA->ZA_DESC1                                             , Nil } )        	    	                    
			                    aAdd( aLinha, { "UB_PRCTAB"     , SZB->ZB_PRCTAB                                            , Nil } )
			        	    	aAdd( aLinha, { "UB_PRODUTO"	, SZB->ZB_PRODUTO											, Nil } )
			        	    	aAdd( aLinha, { "UB__ITEPAI"	, IIF(_nx == 2,_cItePai,"")									, Nil } )
			        	    	aAdd( aLinha, { "UB__ITFILH"	, IIF(_nx == 1 .And. _nSequen == 2,_cItFilh,"") 			, Nil } )
			        	    	aAdd( aLinha, { "UB_QUANT"  	, _nSldDsp                                                  , Nil } )
	                            aAdd( aLinha, { "UB__QTDSOL"    , IIF(_nx == 1,SZB->ZB_QUANT,_nSldDsp)                      , Nil } )
			                    aAdd( aLinha, { "UB_VRUNIT"     , SZB->ZB_VRUNIT                                            , Nil } )
			                    aAdd( aLinha, { "UB_VLRITEM"    , SZB->ZB_VRUNIT * _nSldDsp		                            , Nil } )
			                    aAdd( aLinha, { "UB__PRCDIG"    , SZB->ZB_PRCDIG                                            , Nil } ) 
			                    aAdd( aLinha, { "UB_TES"        , _cTes                                                     , Nil } )
			                    aAdd( aLinha, { "UB_LOCAL"      , _cArmz	                                                , Nil } )                    
			        	    	aAdd( aLinha, { "UB__DESC2"		, SZB->ZB_DESC1												, Nil } )  
			        	    	aAdd( aLinha, { "UB__DESC3"		, SZB->ZB_DESC2  											, Nil } )
			        	    	aAdd( aLinha, { "UB__MOTCAN"	, SZB->ZB_MOTCAN 											, Nil } )
			        	    	aAdd( aLinha, { "UB__USRCAN"	, SZB->ZB_USRCAN 											, Nil } )
			        	    	aAdd( aLinha, { "UB__DTCAN"		, SZB->ZB_DTCAN  											, Nil } )
			        	    	aAdd( aLinha, { "UB__HRCAN"		, SZB->ZB_HRCAN  											, Nil } )
			        	    	aAdd( aLinha, { "UB__ITORI"		, SZB->ZB_ITORI  											, Nil } )
			        	    	aAdd( aLinha, { "UB__TPOPE"		, SZB->ZB_TPOPE  											, Nil } )
			        	    	
			        	    	If nOperPed == 4
			        				aAdd( aLinha, {"AUTDELETA"	, IIF(!Empty(SZB->ZB_MOTCAN),"S","N")						, Nil } )
			        				
			        				//Grava o motivo do cancelamento
			                        AADD(_aSZN,SZB->(Recno()))
			        			EndIf
			        	    
			        	    	aAdd( aItens, aLinha )
			        	    Next _nx
		        	    EndIf
	        	    EndIf
    	    	Else
    	    	    AADD(_aTES,SZB->(Recno()))
    	    	EndIf
        	EndIf
        	
        	TMP_SZB->( dbSkip() )
        EndDo
        
        TMP_SZB->( dbCloseArea() )
    	
    	// Chama execauto para integração
    	lMsErroAuto := .F.
		
    	n := Len( aItens )
    	
    	If n > 0
    	    	
	    	SetModulo("SIGATMK","TMK") 
	    	MSExecAuto({|x,y,z,w| TMKA271(x,y,z,w)},aCabec,aItens,nOperPed,cRotina) 	
	    	  
	    	// No caso de erro, flag registro e envia o erro por e-mail ou mostra na tela se não for JOB, caso contrario flag integracao OK
	    	If lMsErroAuto
	
	    		cLogExec := GetErro()
	    	       
	    	    DbSelectArea("SZA")	
	    		RecLock( "SZA", .F. )
	    		SZA->ZA_FLAGIMP := "4"
	    		SZA->ZA_ERRO := cLogExec
	    		SZA->( MsUnLock() )
	    		
				//Apaga a reserva de estoque de todos os itens do pedido
			    U_ITMKEST1(cFilAnt,cCodAte,"","","",0,"E")
			    
			    //Refaz a reserva de estoque
			    If nOperPed == 4
			    	DbSelectArea("SUA")
			    	DbSetOrder(1)
			    	If DbSeek(xFilial("SUA") + cCodAte)
			    
				        DbSelectArea("SUB")
				        DbSetOrder(1)
				        dbgotop()
				        If dbseek(xFilial("SUB") + cCodAte)			        
					        While SUB->(!Eof()) .And. (SUB->UB_FILIAL + SUB->UB_NUM) == (xFilial("SUB") + cCodAte) 
					            //Mantém na Z10 apenas o que estava na SUB
					            If SUA->UA__RESEST == "S"		
					                U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"I")
					            EndIf
					            
					            //Atualiza a gravação online    			
								U_ITMKGRON("SUB","",0,.f.,SUA->(Recno()),SUB->(Recno()),.t.)
								
								SUB->(DBSKIP())
							EndDo
						EndIf
					EndIf
	    		EndIf
	    		
	    		If !lJob
	    			MsgStop(cLogExec)
	    		Else
	    			Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - " + cLogExec )					
//	    			U_IGENM02( cPara, cAssunto, cLogExec, /*cAnexo*/, /*cServer*/, /*cAccount*/, /*cPassword*/, /*lAutentica*/ )
	    		Endif
	    	
	    	Else        	    
	    	    
	    	    _cErro := ""
	    		DbSelectArea("SUA")
	    		dbSetOrder(1)
	    		If dbSeek( xFilial( "SUA" ) + cCodAte ) 
		    		RecLock( "SUA", .F. )
		    		SUA->UA__PEDMEX := SZA->ZA_PEDMEX
		    		SUA->UA__OBSCOM := SUA->UA__OBSCOM + " " + SZA->ZA_OBSCOM
		    		SUA->UA__OBSFIN := SZA->ZA_OBSFIN
		    		SUA->UA__DTALT  := Date()
		    		SUA->UA__HRALT  := Time()
		    		SUA->UA__FTCONV := IIF(SZA->ZA_TPFRETE == "T","1","2")
		    		SUA->( MsUnLock() )
		
		            //Verifica se foi visita feita através do telefone
		            DbSelectArea("AD7")
		            DbOrderNickName("AD7PEDMEX")
		            If DbSeek(xFilial("AD7") + SUA->UA__PEDMEX)
		                If Val(AD7->AD7__STAT) == 25
		                    RecLock( "SUA", .F. )
		                    SUA->UA__TEL := "S"
		                    SUA->( MsUnLock() )
		                EndIf
		            EndIf
		    		
		            If !Empty(SZA->ZA_MOTCAN) .And. nOperPed == 4
		                lMsErroAuto := MCancPed1()
		                _cErro := "Nao foi possivel efetuar o cancelamento do pedido"
		            EndIf
		
		    		RestArea(aAreaSUA)
		    		
		    		RecLock( "SZA", .F. )
		    		SZA->ZA_FLAGIMP := IIF(lMsErroAuto,"4","3")
		    		SZA->ZA_ERRO    := IIF(lMsErroAuto,_cErro,"")
		    		SZA->(MsUnLock())
		    		    		
		    		//Gravar os itens da SZN
		    		IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)		    		
		    		
		    		Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Integração realizada com sucesso" + cLogExec )
				Else
					
					If nOperPed == 3
					    _cTimeIni := Time()
                        Reclock("SUA",.t.)
                        SUA->UA_FILIAL := xFilial("SUA")
    					For _nx := 1 To Len(aCabec)
                            FieldPut(FieldPos(aCabec[_nx][1]), aCabec[_nx][2])
    					Next _nx
    					SUA->UA_OPER := "3"
    					SUA->UA__DSCTIP := Posicione("SZF",1,xFilial("SZF") + SUA->UA__TIPPED,"ZF_DESC")
    					SUA->UA__DESCCP := Posicione("SE4",1,xFilial("SE4") + SUA->UA_CONDPG,"E4_DESCRI")
    					SUA->UA_TIPOCLI := SA1->A1_TIPO
    					SUA->UA_FORMPG  := "R$"
    					SUA->UA_INICIO   := _cTimeIni
    					SUA->UA_FIM     := Time()
    					SUA->UA_STATUS  := "SUP"
    					SUA->UA_MOEDA   := 1
    					SUA->UA_DIASDAT := (CTOD("01/01/45") - Date())
    					SUA->UA_HORADAT := 86400 - ( (VAL(Substr(_cTimeIni,1,2))*3600) + ( VAL(Substr(_cTimeIni,4,2))*60) + VAL(Substr(_cTimeIni,7,2)) )
    					SUA->UA_TPCARGA := "2"
    					SUA->UA__PEDORI := "4"
    					SUA->UA__FTCONV := "2"
    					SUA->(MsUnlock())
    					ConfirmSX8()
    					
                        RecLock("SZA",.F.)
                        SZA->ZA_FLAGIMP := "3"
                        SZA->ZA_ERRO    := " "
                        SZA->(MsUnLock())
                        
                        //Grava os itens cancelados na SZN
                        IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)
                        U_ITMKEST1(SZA->ZA_FILIAL,cCodAte,"","","",0,"E")
    				Else
                        RecLock("SZA",.F.)
                        SZA->ZA_FLAGIMP := "4"
                        SZA->ZA_ERRO    := "Não foi possível alterar o Pedido"
                        SZA->(MsUnLock())
                    EndIf
					
	    		EndIf	    	
	    	Endif
    	ElseIf nOperPed == 3    		
    		
    		If Len(_aTES) > 0
   				_cErro := "Não foi localizada Regra Fiscal para este pedido."            
	            RecLock( "SZA", .F. )
	            SZA->ZA_FLAGIMP := "4"
	            SZA->ZA_ERRO    := _cErro
	            SZA->(MsUnLock())
	        Else
                _cTimeIni := Time()
                Reclock("SUA",.t.)
                SUA->UA_FILIAL := xFilial("SUA")
                For _nx := 1 To Len(aCabec)
                    FieldPut(FieldPos(aCabec[_nx][1]), aCabec[_nx][2])
                Next _nx
                SUA->UA_OPER := "3"
                SUA->UA__DSCTIP := Posicione("SZF",1,xFilial("SZF") + SUA->UA__TIPPED,"ZF_DESC")
                SUA->UA__DESCCP := Posicione("SE4",1,xFilial("SE4") + SUA->UA_CONDPG,"E4_DESCRI")
                SUA->UA_TIPOCLI := SA1->A1_TIPO
                SUA->UA_FORMPG  := "R$"
                SUA->UA_INICIO   := _cTimeIni
                SUA->UA_FIM     := Time()
                SUA->UA_STATUS  := "SUP"
                SUA->UA_MOEDA   := 1
                SUA->UA_DIASDAT := (CTOD("01/01/45") - Date())
                SUA->UA_HORADAT := 86400 - ( (VAL(Substr(_cTimeIni,1,2))*3600) + ( VAL(Substr(_cTimeIni,4,2))*60) + VAL(Substr(_cTimeIni,7,2)) )
                SUA->UA_TPCARGA := "2"
                SUA->UA__PEDORI := "4"
                SUA->UA__FTCONV := "2"
                SUA->(MsUnlock())
                ConfirmSX8()
                
                RecLock("SZA",.F.)
                SZA->ZA_FLAGIMP := "3"
                SZA->ZA_ERRO    := " "
                SZA->(MsUnLock())
                
                //Grava os itens cancelados na SZN
                IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)
                U_ITMKEST1(SZA->ZA_FILIAL,cCodAte,"","","",0,"E")
    		EndIf
    	EndIf
    ElseIf !Empty(SZA->ZA_MOTCAN) .And. nOperPed == 4
        If Empty(SUA->UA_DOC)          
            lMsErroAuto := MCancPed1()
            _cErro := "Nao foi possivel efetuar o cancelamento do pedido"            
            
            RecLock( "SZA", .F. )
            SZA->ZA_FLAGIMP := IIF(lMsErroAuto,"4","3")
            SZA->ZA_ERRO    := IIF(lMsErroAuto,_cErro,"")
            SZA->(MsUnLock())
        EndIf
    EndIf
    
Next nz

TMP_SZA->( dbCloseArea() )

RestArea( aAreaAtu )
Return


//Cancela o pedido
Static Function MCancPed1()
Local _lOK := .f.

If !Empty(SZA->ZA_MOTCAN) 
    
    DbSelectArea("SUA")
    If RecLock("SUA",.F.)
        SUA->UA_CANC    := "S"
        SUA->UA_STATUS  := "CAN"
        SUA->UA__MOTCAN := SZA->ZA_MOTCAN
        MsUnlock()
        
        _lOK := .t.
        //Estorna as reservas
        If(SUA->UA__RESEST == "S")
            DbSelectArea("SUB")
            DbSetOrder(1)
            If(DbSeek(xFilial("SUB")+SUA->UA_NUM))
                While !Eof() .AND. (xFilial("SUB")+SUB->UB_NUM) .And. (SUA->UA_FILIAL+SUA->UA_NUM) 
                    U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"E")                        
                    DbSelectArea("SUB")
                    DbSkip()
                EndDo
            EndIf               
        EndIf
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Apaga o pedido se ele ainda nao foi liberado³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        DbSelectarea("SC5")
        DbSetorder(1)
        If DbSeek(xFilial("SC5")+SUA->UA_NUMSC5,.T.)
            RecLock("SC5",.F.,.T.)
            DbDelete()
            MsUnLock()
        
            DbSelectarea("SC6")
            DbSetorder(1)
            If DbSeek(xFilial("SC6")+SUA->UA_NUMSC5,.T.)
                While !Eof() .AND. (xFilial("SC6")+SUA->UA_NUMSC5 == C6_FILIAL+C6_NUM)
                    Reclock( "SC6" ,.F.,.T.)
                    DbDelete()
    
                    MaAvalSC6("SC6",2,"SC5")
    
                    SC6->(MsUnLock())
    
                    DbSkip()
                End
                MsUnLockAll()
            Endif
    
            DbSelectArea("SC9")
            DbSetOrder(1)
            If DbSeek(xFilial("SC9")+SUA->UA_NUMSC5)
                While !Eof() .And. (xFilial("SC9") + SUA->UA_NUMSC5) == (SC9->C9_FILIAL + SC9->C9_PEDIDO)
                    If Empty(SC9->C9_NFISCAL)
                        A460Estorna()
                    EndIf
                    DbSkip()
                EndDo                 
                
            EndIf
        
        Endif
        
        //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
        //³Apaga a lista de Contato Pendente gerada para esse atendimento³
        //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
        DbSelectArea("SU4")
        DbSetOrder(2) // Pesquisar pela descricao temporariamente
        If DbSeek(xFilial("SU4")+"Atendimento: "+SUA->UA_NUM)
            
            DbSelectarea("SU6")
            DbSetorder(1)
            If DbSeek(xFilial("SU6")+SU4->U4_LISTA)
                Reclock("SU6",.F.)
                DbDelete()
                MsUnlock()
    
                DbSelectarea("SU4")
                Reclock("SU4",.F.)
                DbDelete()
                MsUnlock()
            EndIf
        EndIf
     EndIf
EndIf

Return _lOK

//-------------------------------------------------------------------
// Recupera informaçoes sobre o erro no MsExecAuto
//-------------------------------------------------------------------
Static Function GetErro

Local _cErrLog 	:= ""
Local _cErrBkp  := ""
Local _cErrLogA	:= ""
Local aErros   	:= {}
Local _cFilLog 	:= NomeAutoLog()
Local nAux		:= 0
		
MostraErro(GetSrvProfString("StartPath",""), "I"+_cFilLog)
		
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava o erro em disco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
_cErrLog := MemoRead(GetSrvProfString("StartPath","")+"\"+"I"+_cFilLog)
/* Gravar log na integra
_cErrLogA:= ""
For nAux := 1 to Len(_cErrLog)
	If (SubStr(_cErrLog,nAux,1) == Chr(10) .or. SubStr(_cErrLog,nAux,1) == Chr(13)) .and. !Empty(_cErrLogA)
		_cErrLogA := StrTran( _cErrLogA, Chr(10), "")
		_cErrLogA := StrTran( _cErrLogA, Chr(13), "")
		aAdd(aErros, _cErrLogA)
		_cErrLogA := ""
	Else
		_cErrLogA += SubStr(_cErrLog,nAux,1)
	EndIf
Next nAux

If !Empty(_cErrLogA)
	aAdd(aErros, _cErrLogA)
	_cErrLogA := ""
EndIf

_cErrBkp := _cErrLog 
_cErrLog := ""
For nAux := 1 to Len(aErros)
	If "Invalido" $ aErros[nAux]
		_cErrLog += AllTrim(aErros[nAux])+", "
	EndIf
Next nAux

If Empty(_cErrLog)
	_cErrLog := _cErrBkp
	_cErrLog := StrTran( _cErrLog, Chr(13)+Chr(10), " " )
Endif

_cErrLog := Left(_cErrLog, Len(_cErrLog) - 2)
*/
fErase(GetSrvProfString("StartPath","")+"I"+_cFilLog)

Return AllTrim( _cErrLog )

//-------------------------------------------------------------------
// Job para processamento da integração
//-------------------------------------------------------------------
User Function MJOBWEB

Local aTables := {"SUA","SUB","SZA","SZB","SC5","SC6"}

If Empty( cEmpInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrerá a integração " )
	Return
Endif

If Empty( cFilInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Na configuracao da JOB ajustar o parametro cFilInt - Filial onde ocorrerá a integração " )
	Return
Endif

RPCSetType( 3 )
RpcSetEnv ( cEmpInt, cFilInt, Nil, Nil, "TMK", Nil, aTables )

While !KillApp()
	U_MINTWEB( .T. )
	Exit
End

Return

//Retorna o TES e ITEM do Registro que está sendo alterado
Static Function IMWEBITE(_cCodFil,_cNumTmk,_cNumMex,_cIteMex,_cOrigem)
Local _cInfo := _cSQL := _cTab := "", _aArea := GetArea()

_cTab := GetNextAlias()
_cSQL := "Select UB_TES,UB_ITEM from " + RetSqlName("SUB") + " UB "
_cSQL += "Where UB_FILIAL = '" + _cCodFil + "' And UB_NUM = '" + _cNumTmk + "' And " 
_cSQL += "UB__PEDMEX = '" + _cNumMex + "' And UB__ITEMEX = '" + _cIteMex + "' And UB.D_E_L_E_T_ = ' ' " 

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
Endif

DbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    _cInfo := IIF(_cOrigem == "T",(_cTab)->UB_TES,(_cTab)->UB_ITEM)
	DbSelectarea("SUB")
	DbSetOrder(1)
	DbSeek(xFilial("SUB") + _cNumTmk + (_cTab)->UB_ITEM)
EndIf

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
Endif

RestArea(_aArea)
Return _cInfo


Static Function MWEBVLPRD(_cProduto, _cCodKit, _cCodAce, _aKit,	_aCorte, _aInat, _aErroKit)
Local _aZBArea := SZB->(GetArea()),_cAtivo := Posicione("SB1" , 1 , xFilial("SB1") + _cProduto, "B1_ATIVO"), _lRet := .t., _cQry := _cTby := ""
Default _cProduto := "", _cCodKit := "", _cCodAce := "", _aKit := {}, _aCorte := {}, _aInat := {}

//Produto Inativo
If _cAtivo <> 'S'
	AADD(_aInat,SZB->(Recno()))
	Return .f.
Endif                 
               
//Corte de inventario
Z15->( dbSetOrder(1) )
if Z15->( dbSeek ( xFilial("Z15") + _cProduto ) )  
	if Z15->Z15_TPINVE = "2" .And. _lRet
		AADD(_aCorte,SZB->(Recno()))
		RestArea(_aZBArea)
		Return .f.
	Endif
Endif 

//Kit incorreto
If !Empty(_cCodKit)
	If Empty(_cCodAce) .Or. _cAtivo <> 'S' .Or. Z15->Z15_TPINVE = "2"
		AADD(_aKit,SZB->(Recno()))
		
		If aScan(_aErroKit,_cCodKit) == 0
            AADD(_aErroKit,_cCodKit)
        EndIf
        
		RestArea(_aZBArea)
		Return .f.
	ElseIf aScan(_aErroKit,_cCodKit) > 0
		AADD(_aKit,SZB->(Recno()))
		
		RestArea(_aZBArea)
		Return .f.
	Else
		DbSelectArea("SU1")
		DbSetOrder(1)
		If !DbSeek(xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]) + _cProduto)
			AADD(_aKit,SZB->(Recno()))
            If aScan(_aErroKit,_cCodKit) == 0
                AADD(_aErroKit,_cCodKit)
            EndIf
			
			RestArea(_aZBArea)
			Return .f.
		EndIf
		
		//Verifica se todos os componentes do KIT estão no pedido
		DbSelectArea("SUG")
		DbSetOrder(1)
		DbSeek(xFilial("SUG") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))
				
		_cTby := GetNextAlias()
        DbSelectArea("SU1")
        DbSetOrder(1)
        DbGoTop()
        DbSeek(xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))		
		While !Eof() .And. (SU1->U1_FILIAL + SU1->U1_ACESSOR) ==  (xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))
                             
            _cQry := "Select ZB_FILIAL,ZB_NUM,ZB_PRODUTO,ZB.R_E_C_N_O_ ZBREC From " + RetSqlName("SZB") + " ZB "
            _cQry += "Where ZB_FILIAL = '" + xFilial("SZB") + "' And ZB_NUM = '" + SZB->ZB_NUM + "' And ZB_CODACE = '" + SU1->U1_CODACE + "' And "
            _cQry +=    "ZB_PRODUTO = '" + SU1->U1_ACESSOR + "' And ZB_CODKIT = '" + SUG->UG_PRODUTO + "' And ZB.D_E_L_E_T_ = ' ' "
            
            If Select(_cTby) > 0
                DbSelectArea(_cTby)
                DbCloseArea()
            EndIf
            
            dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQry ), _cTby, .T., .F. )
            
            DbSelectArea(_cTby)
            DbGoTop()
            If Eof()
                AADD(_aKit,SZB->(Recno()))
                If aScan(_aErroKit,_cCodKit) == 0
                    AADD(_aErroKit,_cCodKit)
                EndIf
                _lRet := .f.
            EndIf
            
            If Select(_cTby) > 0
                DbSelectArea(_cTby)
                DbCloseArea()
            EndIf
            
            If !_lRet
                Exit
            EndIf            
            
            DbSelectArea("SU1")
            DbSkip()
		EndDo
	EndIf
	
EndIf

DbSelectArea("SZB")
RestArea(_aZBArea)
Return _lRet

//Valida a quantidade disponível
Static Function MWEBVLSLD(cCodAte,_aSld)
Local _aZBArea := SZB->(GetArea()), _lRet := .t.

If !Empty(SZB->ZB_CODKIT) .And. (Empty(SZA->ZA_MOTCAN) .And. SZA->ZA_RESERV == "S")
    _nSldDsp := U_xSldKit(SZA->ZA_FILIAL,SZB->ZB_CODKIT,SZB->ZB_LOCAL,cCodAte,SZB->ZB_PRODUTO)
    _nQLoc01 := _nSldDsp
ElseIf (Empty(SZA->ZA_MOTCAN) .And. SZA->ZA_RESERV == "S")
    //_nSldDsp := U_xSldProd(SZA->ZA_FILIAL,SZB->ZB_PRODUTO,SZB->ZB_LOCAL,cCodAte)
	If SZB->ZB_LOCAL $ GetMv("MV__ARMVEN") .And. Alltrim(SZA->ZA_SEGISP) $ GetMv("MV__ARMSEG")
		_nQLoc01 := U_xSldProd(SZA->ZA_FILIAL,SZB->ZB_PRODUTO,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),cCodAte) 
		_nQLoc02 := U_xSldProd(SZA->ZA_FILIAL,SZB->ZB_PRODUTO,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),cCodAte)
		
		_nSldDsp := _nQLoc01 + _nQLoc02
	Else
		_nSldDsp := U_xSldProd(SZA->ZA_FILIAL,SZB->ZB_PRODUTO,SZB->ZB_LOCAL,cCodAte)
	    _nQLoc01 := _nSldDsp
	EndIf		    
EndIf  

If _nSldDsp <= 0 .And. (Empty(SZA->ZA_MOTCAN) .And. SZA->ZA_RESERV == "S")
    _lRet := .f.
    AADD(_aSld,SZB->(Recno()))
EndIf

RestArea(_aZBArea)
Return _lRet

//Faz a gravação da tabela de cancelamento
Static Function IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)
Local nx := 0

If Len(_aKit) > 0
    For nx := 1 To Len(_aKit)
        DbSelectArea("SZB")
        DbGoTo(_aKit[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := GetMV("MV__SZNDIG")
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next nx
EndIf

If Len(_aCorte) > 0
    For nx := 1 To Len(_aCorte)
        DbSelectArea("SZB")
        DbGoTo(_aCorte[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := GetMV("MV__SZNCOR")
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next nx
EndIf

If Len(_aInat) > 0
    For nx := 1 To Len(_aInat)
        DbSelectArea("SZB")
        DbGoTo(_aInat[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := GetMV("MV__SZNINT")
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next nx
EndIf

//Item cancelado por TES não localizada
If Len(_aTES) > 0
    For nx := 1 To Len(_aTES)
        DbSelectArea("SZB")
        DbGoTo(_aTES[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := GetMV("MV__SZNTES")
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next nx
EndIf

//Gravar itens cancelados
If Len(_aSZN) > 0
    For nx := 1 To Len(_aSZN)                   
        DbSelectArea("SZB")
        DbGoTo(_aSZN[nx])
         
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo       
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := SZB->ZB_DTCAN
        SZN->ZN_MOTIVO  := StrZero(Val(SZB->ZB_MOTCAN), TamSX3("ZD_COD")[1] )
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next
EndIf

If Len(_aSld) > 0
    For nx := 1 To Len(_aSld)
        DbSelectArea("SZB")
        DbGoTo(_aSld[nx])
         
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo       
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := "00001"
        SZN->ZN_QUANT   := SZB->ZB_QUANT
        SZN->ZN_PRODUTO := SZB->ZB_PRODUTO
        SZN->ZN_HRCAN   := SubStr(Time(),1,5)
        SZN->ZN_UM      := Posicione("SB1",1,xFilial("SB1") + SZB->ZB_PRODUTO,"B1_UM")
        SZN->ZN_VLRUNIT := SZB->ZB_VLRITEM
        SZN->ZN_PRCLIST := SZB->ZB_PRCTAB
        SZN->ZN_DESC1   := SZB->ZB_DESC1
        SZN->ZN_DESC2   := SZB->ZB_DESC2
        SZN->ZN_TPOPE   := SZB->ZB_TPOPE
        SZN->(MsUnlock())
    Next
EndIf

Return

/*
Exemplo de Configuração no appserver.ini

[ONSTART]
JOBS=JOB_MJOBWEB
RefreshRate=60

[JOB_MJOBWEB]
Main=U_MJOBWEB
Environment=Isapa
cEmpInt=99
cFilInt=01
*/