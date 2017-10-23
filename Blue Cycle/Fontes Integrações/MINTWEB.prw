#include 'protheus.ch'
#include 'parmtype.ch' 
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"                                      
#INCLUDE 'TOPCONN.CH'

Static cEmpInt	:= GetJobProfString('cEmpInt', '01' ) //--> Empresa onde ocorrer� a integra��o
Static cFilInt	:= GetJobProfString('cFilInt', '01' ) //--> Filial onde ocorrer� a integra��o

//-------------------------------------------------------------------
/*{Protheus.doc} MINTWEB
Importa��o dos pedidos do site SZA/SZB para SC5/SC6

@author Vitor Lopes
@since 01/12/2015
@version P11              
*/
//-------------------------------------------------------------------
User Function MINTWEB(lJob)
Local cDescr := "Essa rotina tem como objetivo integrar os pedidos do WebLine."
Public cStatus := "2"
Default lJob := .F.

If !lJob
	tNewProcess():New( "MINTWEB", "Integra��o WebLine", { |oSelf| MIntWebProc( oSelf, lJob ) }, cDescr,,,,,,.T.,.T. )
Else
	MIntWebProc( Nil, lJob )
Endif

Return
                            
//-------------------------------------------------------------------
// Rotina para processamento da integra��o
//-------------------------------------------------------------------
Static Function MIntWebProc( oPrc, lJob )

Local aAreaAtu 	:= GetArea()
Local aAreaSC5	:= SC5->( GetArea() )
Local cQuery 	:= "", _aSZN := {}, _aTES := {}, _aKit := {}, _aCorte := {}, _aInat := {}, _aSld := {}
Local nTotRegs	:= 0

Local _cUFTab := _cTimeIni := "", _lItemOK := .t., _aErroKit := {}

Local cPara		:= "vitor.lopes@qsdobrasil.com;valdemir.carmo@bluecycle.com.br"
Local cAssunto  := "Erro Integra��o WebLine"

Local nOperPed	:= nz := _nSZBLc01 := _nSZBLc02 := _nQtSaldo := _nSequen := 0
Local cCodAte	:= "", _cItem := _cItemAlt :=  ""
Local _cArmz    := "01"
Local aCabec 	:= {} 
Local aItens 	:= {}
Local aLinha 	:= {}, _aTmpSZA := {}
Local cLogExec	:= "", _cTes := ""  
Local cObsPed 	:= ""
Local cTransp	:= ""



Private lMsErroAuto := .F., _nSldDsp := _nQLoc01 := _nQLoc02 := 0     




// Legenda ZA_FLAGIMP
// 1 = Disponivel para integra��o
// 2 = Em processo de integra��o
// 3 = Integrado OK
// 4 = Problemas na Integra��o 

// Monta query para obter os registros que ser�o importados
cQuery := "SELECT R_E_C_N_O_ RECSZA "
cQuery += "  FROM " + RetSQLName("SZA")
cQuery += "  WHERE ZA_FILIAL  = '" + xFilial("SZA") + "' "
cQuery += "   AND ZA_FLAGIMP = '1' "
cQuery += "   AND D_E_L_E_T_ = ' '  ORDER BY 1"

// Abre area tempor�ria
If Select( "TMP_SZA" ) > 0
	TMP_SZA->( dbCloseArea() )
Endif

dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZA", .T., .F. )

If Eof()
    TMP_SZA->( dbCloseArea() )
    Return
EndIf                  

// Flag registros como em processo de integra��o
TMP_SZA->( dbGoTop() )
  
_aTmpSZA := {}
While !(TMP_SZA->(Eof()))
    nTotRegs := nTotRegs + 1						
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
	
	//aRetSX3 := TamSX3("C6_ITEM")	
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
	_cItem	  := StrZero(0,TamSX3("C6_ITEM")[1])
	
	// Define a opera��o
	SC5->( dbOrderNickName( "C5_PEDMEX" ) )
	If SC5->( dbSeek( xFilial("SC5") + SZA->ZA_PEDMEX ) )
		nOperPed := 4 //Altera��o
		cCodAte  := SC5->C5_NUM
		//cTpOper := "04"
	Else 
	
		nOperPed := 3 //Inclus�o
		cCodAte  := GetSXENum("SC5","C5_NUM")//Pr�ximo n�mero do pedido de venda.     
		RollBackSxE()
		
	Endif
	
	RestArea( aAreaSC5 )    
	
	cObsPed := U_MEMOtxt("SZA","ZA_PEDMEX",SZA->ZA_PEDMEX,"ZA_OBSPED")
	
	//cValtoChar(SZA->ZA_OBSPED)
	
	//cObsPed += " ."

    DbSelectArea("SA1")
    DbSetOrder(1)
    If !DbSeek(xFilial("SA1") + ALLTRIM(SZA->ZA_CLIENTE) + ALLTRIM(SZA->ZA_LOJA))
    	    DbSelectArea("SZA")	
    		RecLock( "SZA", .F. )
    		SZA->ZA_FLAGIMP := "4"
    		SZA->ZA_ERRO := "Cliente nao cadastrado no sistema."
    		SZA->( MsUnLock() ) 		
    		Loop
	EndIf            
	
	If SA1->A1_EST $ AllTrim(GetMv("MV_UFRETAE")) .AND. SZA->ZA_TRANSP $ AllTrim(GetMv("MV_TRFTAE"))
		cTransp := SZA->ZA_TRANSP
	Else
		cTransp := SA1->A1_TRANSP
	EndIf
	    		   
  /*  If nOperPed == 3 //Inclus�o

		DbSelectArea("SZK") //Tabela Estabelecimento X Neg�cio X Estado X Municipio
		DbSetOrder(1)
		If DbSeek(xFilial("SZK") + SZA->ZA_SEGISP + SA1->A1_EST)
			_cUFTab := SZK->ZK_TABPAD
		Else
			_cUFTab := "BR"
		EndIf        
    EndIf*/
	
	If Empty(SZA->ZA_MOTCAN) .Or. nOperPed != 4  //Se n�o for altera��o
		
    	// Alimenta cabe�alho SC5 
    	aAdd( aCabec, { "C5_TIPO"   	, ALLTRIM(SZA->ZA_TIPPED)  									, Nil } ) //Tipo de pedido
		aAdd( aCabec, { "C5_NUM"		, cCodAte											, Nil } ) //N�mero do pedido Protheus
    	aAdd( aCabec, { "C5_CLIENTE"	, ALLTRIM(SZA->ZA_CLIENTE)									, Nil } ) //Cliente
    	aAdd( aCabec, { "C5_LOJACLI"	, SZA->ZA_LOJA										, Nil } ) //Loja
    	//aAdd( aCabec, { "C5_FILIAL" 	, SZA->ZA_FILIAL									, Nil } ) //Filial
    	aAdd( aCabec, { "C5__SEGISP"	, "01" 									, Nil } ) //Segmento
    	aAdd( aCabec, { "C5_CONDPAG"	, SZA->ZA_CONDPG  									, Nil } ) //Condi��o de pagamento
    	aAdd( aCabec, { "C5_TABELA"		, SZA->ZA_TABELA									, Nil } ) //Tabela de pre�o
   	    aAdd( aCabec, { "C5_EMISSAO"    , DATE()                                   , Nil } ) //Data da emiss�o do pedido de venda
   	    aAdd( aCabec, { "C5_VEND1"		, SZA->ZA_VEND   									, Nil } ) //Vendedor 	
    	aAdd( aCabec, { "C5__STATUS"	, "5"			  									, Nil } ) //O pedido sempre nasce como bloqueado.  	
    	aAdd( aCabec, { "C5_TRANSP"		, cTransp											, Nil } ) //C�digo da transportadora
    	aAdd( aCabec, { "C5_FRETE"		, SZA->ZA_FRETE 									, Nil } ) //Frete
    	aAdd( aCabec, { "C5_TPFRETE"	, IIF(SZA->ZA_TPFRETE == "T","C",SZA->ZA_TPFRETE)   , Nil } ) //Tipo do frete     	    	
    	aAdd( aCabec, { "C5__PEDMEX"	, SZA->ZA_PEDMEX									, Nil } ) //N�mero do pedido no Mex3000
    	aAdd( aCabec, { "C5_PRIOR"      , "3"                                               , Nil } ) //Prioridade do pedido
//    	aAdd( aCabec, { "C5_REDESP"	    , SZA->ZA_REDESP									, Nil } ) //C�digo da transportadora do redespacho   			
    	aAdd( aCabec, { "C5_ACRSFIN"    , SZA->ZA_ACRESCI									, Nil } ) //Acrescimo financeiro
    	aAdd( aCabec, { "C5__OBSCOM"    , SZA->ZA_OBSCOM									, Nil } ) //Observa��o Comercial
    	aAdd( aCabec, { "C5_OBSPED"     , cObsPed											, Nil } ) //Observa��o Pedido
    	aAdd( aCabec, { "C5__OBSFIN"    , SZA->ZA_OBSFIN									, Nil } ) //Observa��o financeira	
    	
       	    	   		  
    	// Alimenta Itens
    	cQuery := "SELECT R_E_C_N_O_ RECSZB
        cQuery += "  FROM " + RetSQlName( "SZB" )
        cQuery += " WHERE ZB_FILIAL  = '" + xFilial( "SZB" ) + "' "
        cQuery += "   AND ZB_NUM     = '" + SZA->ZA_PEDMEX + "' "
        cQuery += "   AND D_E_L_E_T_ = ' ' "
        cQuery += " ORDER BY ZB_ITEM "
        
        If Select( "TMP_SZB" ) > 0
        	TMP_SZB->( dbCloseArea() )
        Endif
        
        dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZB", .T., .F. )
        
        While TMP_SZB->( !Eof() )
    
    		SZB->( dbGoTo( TMP_SZB->RECSZB ) )
    		
    		aLinha := {}
        	_lItemOK := .t.
        	If nOperPed == 3 .And. !Empty(SZB->ZB_MOTCAN)
        		//N�o inclui o item cancelado no call center. Envia direto para tabela de vendas perdidas
        		AADD(_aSZN,SZB->(Recno()))
        	Else      	
        		_cTes := _cItemAlt :=  "" 
        		_cArmz := "01"
        		

        		
        		If Empty(_cItemAlt)
                    _cItem := Soma1(_cItem,TamSX3("C6_ITEM")[1])
                Else
                	_cItem := _cItemAlt
        		EndIf
        		
        	    	//Valida algumas informa��es do produto
  	        		
  	        		//Valida Kit
        	    	_lItemOK := MWEBVLPRD(ALLTRIM(SZB->ZB_PRODUTO),ALLTRIM(SZB->ZB_CODKIT),ALLTRIM(SZB->ZB_CODACE),@_aKit,@_aCorte,@_aInat,@_aErroKit)
        	    	
        	    	        	    	
        	    	If _lItemOK //Se o item n�o apresentar problema.
        	    	
        	    				aAdd( aLinha, { "C6_ITEM"		, _cItem                                                    , Nil } )	   
			                    aAdd( aLinha, { "C6_PRODUTO"	, SZB->ZB_PRODUTO											, Nil } ) //Produto
			                    aAdd( aLinha, { "C6__PEDMEX"    , SZB->ZB_NUM                                               , Nil } ) //N�mero do pedido no Mex
			                    aAdd( aLinha, { "C6__ITEMEX"    , SZB->ZB_ITEM                                              , Nil } ) //Item no Mex
			        	    	aAdd( aLinha, { "C6__CODKIT"	, SZB->ZB_CODKIT 											, Nil } ) //Item do kit		        	    	
			        	    	aAdd( aLinha, { "C6__CODACE"	, SZB->ZB_CODACE 											, Nil } ) //C�digo do Kit
			                    aAdd( aLinha, { "C6_DESC3"      , SZB->ZB_DESCP                                             , Nil } ) //Desconto Promocional
			                    aAdd( aLinha, { "C6_DESC1"      , SZB->ZB_DESC1                                             , Nil } ) //Desconto   	    	                    
			                    aAdd( aLinha, { "C6_QTDVEN"  	, SZB->ZB_QUANT                                             , Nil } ) //Quantidade vendida
			                    aAdd( aLinha, { "C6_PRCVEN"     , SZB->ZB_VRUNIT                                            , Nil } ) // Valor Unitario 
			                    aAdd( aLinha, { "C6_OPER"       , "01"			                                            , Nil } ) // Valor Unitario
			                    //aAdd( aLinha, { "C6_TES"        , "501"  			                                        , Nil } ) // Valor Unitario
			                    aAdd( aLinha, { "C6_VALOR"      , SZB->ZB_VRUNIT * SZB->ZB_QUANT                            , Nil } ) //Valor ---Verificar o desconto
			                    //aAdd( aLinha, { "C6_QTDLIB"  	, SZB->ZB_QUANT                                             , Nil } ) //Quantidade LIBERADA
			                    aAdd( aLinha, { "C6_LOCAL"      , "01"		                                                , Nil } ) //Local                
			        	    	aAdd( aLinha, { "C6_DESC2"		, SZB->ZB_DESC2												, Nil } ) //Desconto 2
			        	    	aAdd( aLinha, { "C6_QTDKIT"     , SZB->ZB_QTDKIT											, Nil } ) //Quantidade de Kit

			        	    	
			        	    	If nOperPed == 4
			        				aAdd( aLinha, {"AUTDELETA"	, IIF(!Empty(SZB->ZB_MOTCAN),"S","N")						, Nil } )
			        				
			        				//Grava o motivo do cancelamento
			                        AADD(_aSZN,SZB->(Recno()))
			        			EndIf
			        	    
			        	    	aAdd( aItens, aLinha )

	        	    EndIf  
        	EndIf
        	
        	TMP_SZB->( dbSkip() )
        EndDo
        
        TMP_SZB->( dbCloseArea() )
    	
    	// Chama execauto para integra��o
    	lMsErroAuto := .F.
		
    	n := Len( aItens )
    	
    	If n > 0
    	    //adminMATA410(aCabec,aItens,nOperPed)	
	    	
	    	msExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,nOperPed)
	    	
if lMsErroAuto 
    mostraerro() 
//    lMsErroAuto := .F. 
endif 	    	
	    	  
	    	// No caso de erro, flag registro e envia o erro por e-mail ou mostra na tela se n�o for JOB, caso contrario flag integracao OK
	    	If lMsErroAuto
	
	    		cLogExec := GetErro()
	    	       
	    	    DbSelectArea("SZA")	
	    		RecLock( "SZA", .F. )
	    		SZA->ZA_FLAGIMP := "4"
	    		SZA->ZA_ERRO := cLogExec
	    		SZA->( MsUnLock() )
	    				    

	    		
	    		If !lJob
	    			MsgStop(cLogExec)
	    		Else
	    			Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - " + cLogExec )					
	    			U_IGENM02( cPara, cAssunto, cLogExec, /*cAnexo*/, /*cServer*/, /*cAccount*/, /*cPassword*/, /*lAutentica*/ )
	    		Endif
	    	
	    	Else //Se o execauto conseguir realizar a inclusao ou altera��o.        	    
	    		ConfirmSX8()    
	    	    _cErro := ""
	    		DbSelectArea("SC5") //Cabe�alho do pedido de venda.
	    		dbSetOrder(1)
	    		If dbSeek( xFilial( "SC5" ) + cCodAte ) //Se encontrar o n�mero do pedido de venda.
		    		RecLock( "SC5", .F. )
		    		//SC5->C5__PEDMEX := SZA->ZA_PEDMEX
		    		//SC5->C5__OBSCOM := SZA->ZA_OBSCOM
		    		//SC5->C5__OBSFIN := SZA->ZA_OBSFIN
		    		//SC5->C5__DTALT  := Date()
		    		//SC5->C5__HRALT  := Time()
		    		SC5->C5__FTCONV := IIF(SZA->ZA_TPFRETE == "T","1","2")
		    		SC5->( MsUnLock() )
		
		            //Verifica se foi visita feita atrav�s do telefone
		            DbSelectArea("AD7")
		            DbOrderNickName("AD7PEDMEX")
		            If DbSeek(xFilial("AD7") + SZA->ZA_PEDMEX)
		                If Val(AD7->AD7__STAT) == 25
		                    RecLock( "SC5", .F. )
		                    SC5->C5__TEL := "S"
		                    SC5->( MsUnLock() )
		                EndIf
		            EndIf
		    		
		            If !Empty(SZA->ZA_MOTCAN) .And. nOperPed == 4
		                lMsErroAuto := MCancPed1()
		                _cErro := "Nao foi possivel efetuar o cancelamento do pedido"
		            EndIf
		
		    		//RestArea(aAreaSUA)
		    		
		    		RecLock( "SZA", .F. )
		    		SZA->ZA_FLAGIMP := IIF(lMsErroAuto,"4","3")
		    		SZA->ZA_ERRO    := IIF(lMsErroAuto,_cErro,"")
		    		SZA->(MsUnLock())
		    		    		
		    		//Gravar os itens da SZN
		    		IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)		    		
		    		
		    		Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Integra��o realizada com sucesso" + cLogExec )
		    						
		   
					
	    		EndIf 	    	
	    	Endif
	    	
    	/*ElseIf nOperPed == 3  // Se for inclus�o e o array de itens for igual a 0.  		
    		
    		
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
                IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)*/
    	EndIf
    	
    ElseIf !Empty(SZA->ZA_MOTCAN) .And. nOperPed == 4 // Se for Altera��o e o array itens for igual a 0.
    
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

//RestArea( aAreaAtu )
Return



//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//Cancela o pedido
Static Function MCancPed1()
Local _lOK := .f.

If !Empty(SZA->ZA_MOTCAN) 
    

        
        
        //��������������������������������������������Ŀ
        //�Apaga o pedido se ele ainda nao foi liberado�
        //����������������������������������������������
        DbSelectarea("SC5")
        DbSetorder(1)
        If DbSeek(xFilial("SC5")+cCodAte,.T.)
            RecLock("SC5",.F.,.T.)
            DbDelete()
            MsUnLock()
        
            DbSelectarea("SC6")
            DbSetorder(1)
            If DbSeek(xFilial("SC6")+cCodAte,.T.)
                While !Eof() .AND. (xFilial("SC6")+cCodAte == C6_FILIAL+C6_NUM)
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
            If DbSeek(xFilial("SC9")+cCodAte)
                While !Eof() .And. (xFilial("SC9") + cCodAte) == (SC9->C9_FILIAL + SC9->C9_PEDIDO)
                    If Empty(SC9->C9_NFISCAL)
                        A460Estorna()
                    EndIf
                    DbSkip()
                EndDo                 
                
            EndIf
        
        Endif
        
        //��������������������������������������������������������������Ŀ
        //�Apaga a lista de Contato Pendente gerada para esse atendimento�
        //����������������������������������������������������������������
        DbSelectArea("SU4")
        DbSetOrder(2) // Pesquisar pela descricao temporariamente
        If DbSeek(xFilial("SU4")+"Atendimento: "+cCodAte)
            
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

Return _lOK


//-------------------------------------------------------------------
// Recupera informa�oes sobre o erro no MsExecAuto
//-------------------------------------------------------------------
Static Function GetErro

Local _cErrLog 	:= ""
Local _cErrBkp  := ""
Local _cErrLogA	:= ""
Local aErros   	:= {}
Local _cFilLog 	:= NomeAutoLog()
Local nAux		:= 0
		
MostraErro(GetSrvProfString("StartPath",""), "I"+_cFilLog)
		
//�����������������������Ŀ
//� Grava o erro em disco �
//�������������������������
_cErrLog := MemoRead(GetSrvProfString("StartPath","")+"\"+"I"+_cFilLog)

fErase(GetSrvProfString("StartPath","")+"I"+_cFilLog)

Return AllTrim( _cErrLog )

//-------------------------------------------------------------------
// Job para processamento da integra��o
//-------------------------------------------------------------------
User Function MJOBWEB

Local aTables := {"SUA","SUB","SZA","SZB","SC5","SC6","SC5","SC6","SA1","SE4"}



If Empty( cEmpInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Na configuracao da JOB ajustar o parametro cEmpInt - Empresa onde ocorrer� a integra��o " )
	Return
Endif

If Empty( cFilInt )
	Conout( DtoC( Date() ) + " - " + Time() + " - Integracao WebLine - Na configuracao da JOB ajustar o parametro cFilInt - Filial onde ocorrer� a integra��o " )
	Return
Endif

RPCSetType( 3 )
RpcSetEnv ( cEmpInt, cFilInt, Nil, Nil, "FAT", Nil, aTables )

While !KillApp()
	U_MINTWEB( .T. )
	Exit
End   

/*While !KillApp()
	//U_MINTWEB( .T. )
	U_EMAILSEP( .T. )
	Exit
End*/   




Return
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


Static Function MWEBVLPRD(_cProduto, _cCodKit, _cCodAce, _aKit,	_aCorte, _aInat, _aErroKit)
Local _aZBArea := SC6->(GetArea()),_cAtivo := Posicione("SB1" , 1 , xFilial("SB1") + _cProduto, "B1_ATIVO"), _lRet := .t., _cQry := _cTby := ""
Default _cProduto := "", _cCodKit := "", _cCodAce := "", _aKit := {}, _aCorte := {}, _aInat := {}

//Produto Inativo
If _cAtivo <> 'S'
	AADD(_aInat,SC6->(Recno()))
	Return .f.
Endif                 
               
//Corte de inventario   //CORTE DE INVENTARIO DESATIVADO POR VALDEMIR DO CARMO EM 21/09/16 - ATE SEGUNDA ORDEM
/*Z15->( dbSetOrder(1) )
if Z15->( dbSeek ( xFilial("Z15") + _cProduto ) )  
	if Z15->Z15_TPINVE = "2" .And. _lRet
		AADD(_aCorte,SC6->(Recno()))
		RestArea(_aZBArea)
		Return .f.
	Endif
Endif */

//Kit incorreto
If !Empty(_cCodKit)
	If Empty(_cCodAce) .Or. _cAtivo <> 'S' .Or. Z15->Z15_TPINVE = "2"
		AADD(_aKit,SC6->(Recno()))
		
		If aScan(_aErroKit,_cCodKit) == 0
            AADD(_aErroKit,_cCodKit)
        EndIf
        
		RestArea(_aZBArea)
		Return .f.
	ElseIf aScan(_aErroKit,_cCodKit) > 0
		AADD(_aKit,SC6->(Recno()))
		
		RestArea(_aZBArea)
		Return .f.
	Else
		DbSelectArea("SU1")
		DbSetOrder(1)
		If !DbSeek(xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]) + _cProduto)
			AADD(_aKit,SC6->(Recno()))
            If aScan(_aErroKit,_cCodKit) == 0
                AADD(_aErroKit,_cCodKit)
            EndIf
			
			RestArea(_aZBArea)
			Return .f.
		EndIf
		
		//Verifica se todos os componentes do KIT est�o no pedido
		DbSelectArea("SUG")
		DbSetOrder(1)
		DbSeek(xFilial("SUG") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))
				
		_cTby := GetNextAlias()
        DbSelectArea("SU1")
        DbSetOrder(1)
        DbGoTop()
        DbSeek(xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))		
		While !Eof() .And. (SU1->U1_FILIAL + SU1->U1_ACESSOR) ==  (xFilial("SU1") + PADR(_cCodAce,TamSX3("UG_CODACE")[1]))
                             
            _cQry := "Select C6_FILIAL,C6_NUM,C6_PRODUTO,SC6.R_E_C_N_O_ C6REC From " + RetSqlName("SC6") + " SC6 "
            _cQry += "Where C6_FILIAL = '" + xFilial("SC6") + "' And C6_NUM = '" + SZB->ZB_NUM + "' And C6_CODACE = '" + SU1->U1_CODACE + "' And "
            _cQry +=    "C6_PRODUTO = '" + SU1->U1_ACESSOR + "' And C6_CODKIT = '" + SUG->UG_PRODUTO + "' And SC6.D_E_L_E_T_ = ' ' "
            
            If Select(_cTby) > 0
                DbSelectArea(_cTby)
                DbCloseArea()
            EndIf
            
            dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, _cQry ), _cTby, .T., .F. )
            
            DbSelectArea(_cTby)
            DbGoTop()
            If Eof()
                AADD(_aKit,SC6->(Recno()))
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

DbSelectArea("SC6")
RestArea(_aZBArea)
Return _lRet

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Faz a grava��o da tabela de cancelamento
Static Function IMWEBSZN(cCodAte,_aSZN, _aTES, _aKit, _aCorte, _aInat, _aSld)
Local nx := 0

If Len(_aKit) > 0 //Produto com problemas no Kit.
    For nx := 1 To Len(_aKit)
        DbSelectArea("SC6")
        DbGoTo(_aKit[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := "00000" //GetMV("MV__SZNDIG")
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



If Len(_aInat) > 0 //Produtos inativos.
    For nx := 1 To Len(_aInat)
        DbSelectArea("SC6")
        DbGoTo(_aInat[nx])
        
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo        
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := Date()
        SZN->ZN_MOTIVO  := "00000"//GetMV("MV__SZNINT") //Motivo de cancelamento para produto inativo.
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
        DbSelectArea("SC6")
        DbGoTo(_aSZN[nx])
         
        DbSelectArea("SZN")
        While !RecLock("SZN",.T.)
        EndDo       
        SZN->ZN_FILIAL  := SZB->ZB_FILIAL
        SZN->ZN_NUM     := cCodAte
        SZN->ZN_ITEM    := StrZero( Val(SZB->ZB_ITEM), TamSX3("ZN_ITEM")[1] )
        SZN->ZN_DTCAN   := SZB->ZB_DTCAN
        SZN->ZN_MOTIVO  := StrZero(Val(SZB->ZB_MOTCAN), TamSX3("ZD_COD")[1] ) //Tabela de motivos do Call Center
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
Exemplo de Configura��o no appserver.ini

[ONSTART]
JOBS=JOB_MJOBWEB
RefreshRate=60

[JOB_MJOBWEB]
Main=U_MJOBWEB
Environment=Isapa
cEmpInt=99
cFilInt=01
*/