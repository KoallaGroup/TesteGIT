#include 'protheus.ch'
#include 'parmtype.ch'


user Function TstWeb( oPrc, lJob )

Local aAreaAtu 	:= GetArea()
Local aAreaSC5	:= SC5->( GetArea() )
Local cQuery 	:= "", _aSZN := {}, _aTES := {}, _aKit := {}, _aCorte := {}, _aInat := {}, _aSld := {}
Local nTotRegs	:= 0

Local _cUFTab := _cTimeIni := "", _lItemOK := .t., _aErroKit := {}

Local cPara		:= "vitor.lopes@qsdobrasil.com;valdemir.carmo@bluecycle.com.br"
Local cAssunto  := "Erro Integração WebLine"

Local nOperPed	:= nz := _nSZBLc01 := _nSZBLc02 := _nQtSaldo := _nSequen := 0
Local cCodAte	:= "", _cItem := _cItemAlt :=  ""
Local _cArmz    := "01"
Local aCabec 	:= {} 
Local aItens 	:= {}
Local aLinha 	:= {}, _aTmpSZA := {}
Local cLogExec	:= "", _cTes := ""

Private lMsErroAuto := .F., _nSldDsp := _nQLoc01 := _nQLoc02 := 0

// Legenda ZA_FLAGIMP
// 1 = Disponivel para integração
// 2 = Em processo de integração
// 3 = Integrado OK
// 4 = Problemas na Integração 


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
	
    	// Alimenta cabeçalho SC5
    	aAdd( aCabec, { "C5_TIPO"   	, 'N'  									, Nil } ) //Tipo de pedido
		aAdd( aCabec, { "C5_NUM"		, 'TESTE2'											, Nil } ) //Número do pedido Protheus
    	aAdd( aCabec, { "C5_CLIENTE"	, '000001'									, Nil } ) //Cliente
    	aAdd( aCabec, { "C5_LOJACLI"	, '01'										, Nil } ) //Loja
//    	aAdd( aCabec, { "C5_FILIAL" 	, '01'									, Nil } ) //Filial        
		aAdd( aCabec, { "C5_TIPOCLI"   	, 'R'  									, Nil } ) //Tipo de pedido
    	aAdd( aCabec, { "C5__SEGISP"	, '01' 									, Nil } ) //Segmento
    	aAdd( aCabec, { "C5_CONDPAG"	, '001'  									, Nil } ) //Condição de pagamento
    	aAdd( aCabec, { "C5_TABELA"		, ''									, Nil } ) //Tabela de preço
   	    aAdd( aCabec, { "C5_EMISSAO"    , DATE()                                   , Nil } ) //Data da emissão do pedido de venda
   	    aAdd( aCabec, { "C5_VEND1"		, ''   									, Nil } ) //Vendedor 	
    	aAdd( aCabec, { "C5__STATUS"	, "5"			  									, Nil } ) //O pedido sempre nasce como bloqueado.  	
    	aAdd( aCabec, { "C5_TRANSP"		, '000001' 									, Nil } ) //Código da transportadora
    	aAdd( aCabec, { "C5_TPFRETE"	, 'C'   , Nil } ) //Tipo do frete     	    	
    	aAdd( aCabec, { "C5__PEDMEX"	, ''									, Nil } ) //Número do pedido no Mex3000
    	aAdd( aCabec, { "C5_PRIOR"      , "3"                                               , Nil } ) //Prioridade do pedido
    	aAdd( aCabec, { "C5_REDESP"	    , ''									, Nil } ) //Código da transportadora do redespacho   			
//    	aAdd( aCabec, { "C5_ACRSFIN"    , SZA->ZA_ACRESCI									, Nil } ) //Acrescimo financeiro
//    	aAdd( aCabec, { "C5__OBSCOM"    , SZA->ZA_OBSCOM									, Nil } ) //Observação Comercial
 //   	aAdd( aCabec, { "C5_YOBS"       , SZA->ZA_OBSPED									, Nil } ) //Observação Pedido
//    	aAdd( aCabec, { "C5__OBSFIN"    , SZA->ZA_OBSFIN									, Nil } ) //Observação financeira	
    	
       	    	   		  
       	    	
        	    				aAdd( aLinha, { "C6_ITEM"		, '01'                                                    , Nil } )	   
			                    aAdd( aLinha, { "C6_PRODUTO"	, '1010008'											, Nil } ) //Produto
			                    aAdd( aLinha, { "C6__PEDMEX"    , ''                                               , Nil } ) //Número do pedido no Mex
			                    aAdd( aLinha, { "C6__ITEMEX"    , ''                                             , Nil } ) //Item no Mex
			        	    	aAdd( aLinha, { "C6__CODKIT"	, '' 											, Nil } ) //Item do kit		        	    	
			        	    	aAdd( aLinha, { "C6__CODACE"	, '' 											, Nil } ) //Código do Kit
			                    //aAdd( aLinha, { "C6_DESC3"      , ''                                             , Nil } ) //Desconto Promocional
			                    //aAdd( aLinha, { "C6_DESC1"      , ''                                             , Nil } ) //Desconto   	    	                    
			                    aAdd( aLinha, { "C6_QTDVEN"  	, 1                                             , Nil } ) //Quantidade vendida
			                    aAdd( aLinha, { "C6_PRCVEN"     , 10                                            , Nil } ) // Valor Unitario 
			                    //aAdd( aLinha, { "C6_OPER"       , SZB->ZB_VRUNIT                                            , Nil } ) // Valor Unitario
			                    aAdd( aLinha, { "C6_TES"        , "501"  			                                        , Nil } ) // Valor Unitario
			                    aAdd( aLinha, { "C6_VALOR"      , 10                            , Nil } ) //Valor ---Verificar o desconto
			                    aAdd( aLinha, { "C6_QTDLIB"  	, 1                                             , Nil } ) //Quantidade LIBERADA
			                    aAdd( aLinha, { "C6_LOCAL"      , "01"		                                                , Nil } ) //Local                
			        	    	//aAdd( aLinha, { "C6_DESC2"		, ''											, Nil } ) //Desconto 2
			        	    	aAdd( aLinha, { "C6_QTDKIT"     , 0											, Nil } ) //Quantidade de Kit

			        	    
			        	    	aAdd( aItens, aLinha )
    	
	    	
	    	msExecAuto({|x,y,z|mata410(x,y,z)},aCabec,aItens,3)
/*	    	
if lMsErroAuto 
    mostraerro() 
    lMsErroAuto := .F. 
endif */	    	
If lMsErroAuto // se ocorrer um erro, avisa e mostra o erro na tela 
     Alert("Erro na inclusao!") 
     MostraErro() 
Else      
     Alert("Incluido com sucesso! ") 
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