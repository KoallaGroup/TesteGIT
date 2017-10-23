#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : ITMKA03			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi	         											|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : ExecAuto para Incluir Pedidos de Venda pelo Call Center                                 |
|-------------------------------------------------------------------------------------------------------|
*/

User Function ITMKA03()

Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local nX     	:= 0
Local nY     	:= 0
Local lOk    	:= .T.
Local cEndc		:= ""
Local cEnde		:= ""
Local cBairroc	:= ""
Local cBairroe	:= ""
Local cMunc		:= ""
Local cMune		:= ""
Local cCepc		:= ""
Local cCepe		:= ""
Local cEstc		:= ""
Local cEste     := ""
Local cCod		:= ""
Local cLoja		:= ""
Local cAtend	:= ""
Local nDesconto	:= 0
Local nFrete	:= 0
Local nDespesa	:= 0
Local lAlterar	:= .T.
Local cRotina	:= "2" 	//Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca

PRIVATE lMsErroAuto := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//| Abertura do ambiente                                         |
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de Atendimento "	,80))

//PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "TMK" TABLES "SUA","SUB","SA1"
	
//"Teste de Inclusao de Atendimento "

dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1") + "10142551        " + "143 " ) //BRASIL A.PARTS SERV.E PCS.AUTOMOT.LTDA EPP

cCod		:= SA1->A1_COD
cLoja		:= SA1->A1_LOJA
cEndc		:= SA1->A1_ENDCOB
cBairroc	:= SA1->A1_BAIRROC
cMunc		:= SA1->A1_MUNC
cCepc		:= SA1->A1_CEPC
cEstc		:= SA1->A1_ESTC
cEnde		:= SA1->A1_ENDENT
cBairroe	:= SA1->A1_BAIRROE
cMune		:= SA1->A1_MUNE
cEste		:= SA1->A1_ESTE
nDesconto	:= 10
nFrete		:= 20
nDespesa	:= 30


ConOut("Inicio: " +Time())

For nY := 1 To 1

	aCabec := {}
	aItens := {}
                       	
	AADD(aCabec,{"UA_NUM"  		,"000085" 	   	,Nil})			
	
	AADD(aCabec,{"UA_CLIENTE"	,cCod       	,Nil})
	AADD(aCabec,{"UA_LOJA"		,cLoja      	,Nil})
	AADD(aCabec,{"UA_OPERADO"	,"000001"		,Nil})	//Codigo do Operador
	AADD(aCabec,{"UA_OPER"		,"2"			,Nil})	//1-Faturamento 2-Orcamento 3-Atendimento
	AADD(aCabec,{"UA_TMK"		,"2"			,Nil})	//1-Receptivo 2-Ativo 3-Fax 4-Representante
	AADD(aCabec,{"UA_CONDPG"	,"001"			,Nil})	//Condicao de Pagamento
	AADD(aCabec,{"UA_TABELA"  	,"001"	 	    ,Nil})	
	AADD(aCabec,{"UA_VEND"  	,"000001"       ,Nil})		
	AADD(aCabec,{"UA_TIPOCLI"  	,"F"		    ,Nil})				
//	AADD(aCabec,{"UA__LJAENT"  	,"143"		    ,Nil})			
//	AADD(aCabec,{"UA__LJCOB"  	,"143"		    ,Nil})					

/*
	AADD(aCabec,{"UA_TRANSP"	,"000002"		,Nil})	//Transportadora
	AADD(aCabec,{"UA_ENDCOB"  	,cEndc       	,Nil})
	AADD(aCabec,{"UA_BAIRROC"	,cBairroc      	,Nil})
	AADD(aCabec,{"UA_MUNC"		,cMunc       	,Nil})
	AADD(aCabec,{"UA_CEPC"  	,cCepc       	,Nil})
	AADD(aCabec,{"UA_ESTC"  	,cEstc       	,Nil})
	AADD(aCabec,{"UA_ENDENT"   	,cEnde         	,Nil})
	AADD(aCabec,{"UA_BAIRROE"	,cBairroe       ,Nil})
	AADD(aCabec,{"UA_MUNE"		,cMune       	,Nil})
	AADD(aCabec,{"UA_CEPE"  	,cCepe       	,Nil})
	AADD(aCabec,{"UA_ESTE"   	,cEste       	,Nil})
	AADD(aCabec,{"UA_PROSPEC"	,.F.	     	,Nil})
	AADD(aCabec,{"UA_DESCONT"  	,nDesconto     	,Nil})
	AADD(aCabec,{"UA_FRETE"   	,nFrete       	,Nil})
	AADD(aCabec,{"UA_DESPESA"  	,nDespesa       ,Nil})
*/
	
	For nX := 1 To 3
		aLinha := {}

		aadd(aLinha,{"UB_ITEM"		,StrZero(nX,2)	,Nil})
		aadd(aLinha,{"UB_PRODUTO"	,"10015          "	,Nil})
		aadd(aLinha,{"UB_QUANT"		,2				,Nil})
		aadd(aLinha,{"UB_VRUNIT"	,50 			,Nil})
		aadd(aLinha,{"UB_VLRITEM"	,100			,Nil})
		aadd(aLinha,{"UB_TES"		,"501"			,Nil})
		aadd(aItens,aLinha)
	Next nX
	
Next nY


ConOut("Inicio: " +Time())



TMKA271(aCabec,aItens,3,cRotina)

If !lMsErroAuto	
	alert("Incluído com sucesso! ")
Else
	ConOut("Erro na Inclusao!")
	Mostraerro()
	DisarmTransaction()
	Break
Endif

ConOut("Fim  : "+Time())
ConOut(Repl("-",80))

//RESET ENVIRONMENT

Return(.T.)


/*
User Function T271INC()


Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local nX     	:= 0
Local nY     	:= 0
Local lOk    	:= .T.
  
Local cRotina		:= "2" //Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca


PRIVATE lMsErroAuto := .F.                                       

ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de Televendas P11 "	,80))  
ConOut(Repl("-",80))

PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "TMK"  USER "TesteTMK" PASSWORD '1234' TABLES "SUA","SUB","SUC","SUD","SB1","SA1","SUS","SE4","AC8","SA4","SU7" 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		
	//³Inclusao atendimentos do televendas   ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	
	ConOut("Inicio: " +Time())	
	//dbselectarea("SA1")
	//DbsetOrder(1)	
	//dbgotop()  
	//dbskip(2)
	//"Inicio: "		
	//For nY := 1 To 1			
	
	aCabec := {}			
	aItens := {}
	AADD(aCabec,{"UA_NUM"  		,"000003" 	   ,Nil})			
	AADD(aCabec,{"UA_CLIENTE"	,"000000"     ,Nil})			
	AADD(aCabec,{"UA_LOJA"		,"01"      	,Nil})			
	AADD(aCabec,{"UA_OPERADO"	,"000001"		,Nil})	//Codigo do Operador			
   	AADD(aCabec,{"UA_OPER"		,"1"			,Nil})	//1-Faturamento 2-Orcamento 3-Atendimento			
   	AADD(aCabec,{"UA_TMK"		,"1"			,Nil})	//1-Ativo 2-Receptivo			
	AADD(aCabec,{"UA_CONDPG"	,"004"			,Nil})	//Condicao de Pagamento			
	/*AADD(aCabec,{"UA_TRANSP"	,"000001"		,Nil})	//Transportadora			
	AADD(aCabec,{"UA_ENDCOB"  	,cEndc       	,Nil})			
	AADD(aCabec,{"UA_BAIRROC"	,cBairroc      	,Nil})			
	AADD(aCabec,{"UA_MUNC"		,cMunc       	,Nil})			
	AADD(aCabec,{"UA_CEPC"  	,cCepc       	,Nil})			
	AADD(aCabec,{"UA_ESTC"  	,cEstc       	,Nil})			
	AADD(aCabec,{"UA_ENDENT"   	,cEnde         	,Nil})			
	AADD(aCabec,{"UA_BAIRROE"	,cBairroe       ,Nil})			
	AADD(aCabec,{"UA_MUNE"		,cMune       	,Nil})			
	AADD(aCabec,{"UA_CEPE"  	,cCepe       	,Nil})			
	AADD(aCabec,{"UA_ESTE"   	,cEste       	,Nil})			
	AADD(aCabec,{"UA_PROSPEC"	,.F.	     	,Nil})			
	AADD(aCabec,{"UA_DESCONT"  	,nDesconto     	,Nil})			
	AADD(aCabec,{"UA_FRETE"   	,nFrete       	,Nil})			
	AADD(aCabec,{"UA_DESPESA"  	,nDespesa       ,Nil})*/					
	//For nX := 1 To 1				

/*	
	aLinha := {}				
	aadd(aLinha,{"UB_ITEM"		,StrZero(nX,2)						,Nil})				
	aadd(aLinha,{"UB_PRODUTO"	,"000000000000006"	,Nil})				
	aadd(aLinha,{"UB_QUANT"		,1									,Nil})				
	aadd(aLinha,{"UB_VRUNIT"	,100 								,Nil})				
	aadd(aLinha,{"UB_VLRITEM"	,100								,Nil})				
	aadd(aLinha,{"UB_TES"		,"501"			,Nil})				
	aadd(aItens,aLinha)			
	
	//Next nX		
	//Next nY		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Executa a chamada da rotina de atendimento CALL CENTER       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	TMKA271(aCabec,aItens,3,cRotina)       //inclusao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exibe se foi feita a inclusao ou se retornou erro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !lMsErroAuto	
		ConOut("Atendimento Incluido com sucesso! ")
	Else	
		ConOut("Erro na inclusao!")		//"Erro na inclusao!"	
		Mostraerro()	
		DisarmTransaction()	
		Break
	Endif
	
	ConOut("Fim  : "+Time())
	ConOut(Repl("-",80))		

RESET ENVIRONMENT


Return(.T.)



User Function T271INC() 



Local aCabec 	:= {}
Local aItens 	:= {}
Local aLinha 	:= {}
Local nX     	:= 0
Local nY     	:= 0
Local lOk    	:= .T.
  
Local cRotina		:= "2" //Indica as rotinas de atendimento. 1-Telemarketing 2- Televendas 3-Telecobranca


PRIVATE lMsErroAuto := .F.                                       

ConOut(Repl("-",80))
ConOut(PadC("Teste de Inclusao de Televendas P11 "	,80))  
ConOut(Repl("-",80))

PREPARE ENVIRONMENT EMPRESA "99" FILIAL "01" MODULO "TMK"  USER "TesteTMK" PASSWORD '1234' TABLES "SUA","SUB","SUC","SUD","SB1","SA1","SUS","SE4","AC8","SA4","SU7" 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿		
	//³Inclusao atendimentos do televendas   ³		
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ		
	
	ConOut("Inicio: " +Time())	
	//dbselectarea("SA1")
	//DbsetOrder(1)	
	//dbgotop()  
	//dbskip(2)
	//"Inicio: "		
	//For nY := 1 To 1			
	
	aCabec := {}			
	aItens := {}
	AADD(aCabec,{"UA_NUM"  		,"000003" 	   ,Nil})			
	AADD(aCabec,{"UA_CLIENTE"	,"000000"     ,Nil})			
	AADD(aCabec,{"UA_LOJA"		,"01"      	,Nil})			
	AADD(aCabec,{"UA_OPERADO"	,"000001"		,Nil})	//Codigo do Operador			
   	AADD(aCabec,{"UA_OPER"		,"1"			,Nil})	//1-Faturamento 2-Orcamento 3-Atendimento			
   	AADD(aCabec,{"UA_TMK"		,"1"			,Nil})	//1-Ativo 2-Receptivo			
	AADD(aCabec,{"UA_CONDPG"	,"004"			,Nil})	//Condicao de Pagamento			
	/*AADD(aCabec,{"UA_TRANSP"	,"000001"		,Nil})	//Transportadora			
	AADD(aCabec,{"UA_ENDCOB"  	,cEndc       	,Nil})			
	AADD(aCabec,{"UA_BAIRROC"	,cBairroc      	,Nil})			
	AADD(aCabec,{"UA_MUNC"		,cMunc       	,Nil})			
	AADD(aCabec,{"UA_CEPC"  	,cCepc       	,Nil})			
	AADD(aCabec,{"UA_ESTC"  	,cEstc       	,Nil})			
	AADD(aCabec,{"UA_ENDENT"   	,cEnde         	,Nil})			
	AADD(aCabec,{"UA_BAIRROE"	,cBairroe       ,Nil})			
	AADD(aCabec,{"UA_MUNE"		,cMune       	,Nil})			
	AADD(aCabec,{"UA_CEPE"  	,cCepe       	,Nil})			
	AADD(aCabec,{"UA_ESTE"   	,cEste       	,Nil})			
	AADD(aCabec,{"UA_PROSPEC"	,.F.	     	,Nil})			
	AADD(aCabec,{"UA_DESCONT"  	,nDesconto     	,Nil})			
	AADD(aCabec,{"UA_FRETE"   	,nFrete       	,Nil})			
	AADD(aCabec,{"UA_DESPESA"  	,nDespesa       ,Nil})*/					
	//For nX := 1 To 1				
/*	
	aLinha := {}				
	aadd(aLinha,{"UB_ITEM"		,StrZero(nX,2)						,Nil})				
	aadd(aLinha,{"UB_PRODUTO"	,"000000000000006"	,Nil})				
	aadd(aLinha,{"UB_QUANT"		,1									,Nil})				
	aadd(aLinha,{"UB_VRUNIT"	,100 								,Nil})				
	aadd(aLinha,{"UB_VLRITEM"	,100								,Nil})				
	aadd(aLinha,{"UB_TES"		,"501"			,Nil})				
	aadd(aItens,aLinha)			
	
	//Next nX		
	//Next nY		
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//| Executa a chamada da rotina de atendimento CALL CENTER       |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	TMKA271(aCabec,aItens,3,cRotina)       //inclusao
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Exibe se foi feita a inclusao ou se retornou erro³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If !lMsErroAuto	
		ConOut("Atendimento Incluido com sucesso! ")
	Else	
		ConOut("Erro na inclusao!")		//"Erro na inclusao!"	
		Mostraerro()	
		DisarmTransaction()	
		Break
	Endif
	
	ConOut("Fim  : "+Time())
	ConOut(Repl("-",80))		

RESET ENVIRONMENT


Return(.T.)
*/