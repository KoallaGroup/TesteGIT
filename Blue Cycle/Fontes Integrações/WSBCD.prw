#include "protheus.ch" 
/* -------------------------------------------------------------------
Função U_MOEDAS
Autor Júlio Wittwer
Data 28/03/2015
Descrição Fonte de exemplo consumingo um Web Service publico
 de fator de conversão de moedas, utilizando a 
 geração de classe Client de Web Services do AdvPL
Url http://www.webservicex.net/CurrencyConvertor.asmx?WSDL
------------------------------------------------------------------- */
User Function WSBCD(cCodTicket)
Local oWS   
Local SenhaSer
Local aDados := {} 

SenhaSer := Md5("blueafa29f11b476e62e28e2624e3cf47bef"+DtoS(Date()))
// Cria a instância da classe client
oWs := WSHelpDeskService():New()
//oWs2 := HelpDeskService_ObterRequestDados():New()
// Alimenta as propriedades de envio 
oWS:oWSObterRequest:cservicekey := SenhaSer //'4f37592dde24496a11a7fd479bdaf8b1'   
aAdd(aDados,{"codticket",cCodTicket})								   //	afa29f11b476e62e28e2624e3cf47bef     
aAdd(aDados,{"IncluiPrivadas",""})								   
//Alert(senhaser)								   
oWS:oWSObterRequest:csigla := 'blue'    
oWS:oWSObterRequest:OWSDados := HelpDeskService_ObterRequestDados():New() //aDados
oWS:oWSObterRequest:OWSDados:cIncluiPrivadas := ''
oWS:oWSObterRequest:OWSDados:nCodTicket := Val(cCodTicket) //2877 


//oWS:oWSObterRequestDados:ncodticket := 10283
//oWS:codticket:Value := '' // Real ( Brasil )
//oWS:incluiprivadas:Value := '' // United States Dollar
// Habilita informações de debug no log de console

WSDLDbgLevel(3)
// Chama o método do Web Service
If oWs:Obter()  
 // Retorno .T. , solicitação enviada e recebida com sucesso
 //MsgStop("Retorno WebService: "+oWs:oWSobterreturn:CSTATUSRETORNO,"Requisição Ok")
 //MsgStop("Por exemplo, 100 reais compram "+cValToChar(100 * oWS:nConversionRateResult )+" Dólares Americanos.")  
 If oWs:oWSobterreturn:CSTATUSRETORNO = 'ok'
 	aDados := oWs:oWSobterreturn:OWSDados:OWSInteracoes:OWSObterResultDadosInteracao
 EndIf
 //MsgStop("Requisição Ok")
Else
 // Retorno .F., recupera e mostra string com detalhes do erro 
 MsgStop(GetWSCError(),"Erro de Processamento")
Endif
Return(aDados)
      



User Function WSBCDLis(cTpCh,CliAtend, LojaAtend)
Local oWS   
Local SenhaSer
Local aDados := {}
Local CDataUx := CTod("01/12/1970") 
Local lRet := .T.
SenhaSer := Md5("blueafa29f11b476e62e28e2624e3cf47bef"+DtoS(Date()))
// Cria a instância da classe client  HelpDeskService_ObterListaRequest
oWs := WSFormularioHelpDeskService():New()
//oWs2 := HelpDeskService_ObterRequestDados():New()
// Alimenta as propriedades de envio 
oWS:oWSObterListaRequest:cservicekey := SenhaSer //'4f37592dde24496a11a7fd479bdaf8b1'   
//Alert(cTpCh)
If cTpCh == '1'
	cCliente	:= SC5->C5_CLIENTE
	cLoja		:= SC5->C5_LOJACLI  
ElseIf cTpCh == '3'
	cCliente	:= CliAtend
	cLoja		:= LojaAtend 
Else	
	cCliente	:= M->C5_CLIENTE
	cLoja		:= M->C5_LOJACLI	                              
EndIf	
cCnpj := Posicione("SA1",1,XFILIAL("SA1")+cCliente+cLoja, SA1->A1_CGC)
//FormularioHelpDeskService_ObterListaRequestDados
oWS:oWSObterListaRequest:csigla := 'blue'    
oWS:oWSObterListaRequest:OWSOPCOESCLIENTES 	:= FormularioHelpDeskService_OpcoesClientes():New() //aDados
oWS:oWSObterListaRequest:OWSDADOS 			:= FormularioHelpDeskService_ObterRequestDados():New() //aDados
oWS:oWSObterListaRequest:OWSDados:cDTABERTURA := '2016/01/01 00:00:00;2040/12/21 23:59:59'
oWS:oWSObterListaRequest:OWSOPCOESCLIENTES:CCNPJ := Transform(cValtoChar(cCnpj),"@R 99.999.999/9999-99")
//oWS:oWSObterListaRequest:OWSOPCOESCLIENTES:CRAZAOSOCIAL := 'BRUNO LEONARDO RESENDE OLIVEIRA 01623239648'                 


//oWS:oWSObterRequestDados:ncodticket := 170283
//oWS:codticket:Value := '' // Real ( Brasil )
//oWS:incluiprivadas:Value := '' // United States Dollar
// Habilita informações de debug no log de console

WSDLDbgLevel(3)
// Chama o método do Web Service
If oWs:ObterLista()  
 // Retorno .T. , solicitação enviada e recebida com sucesso
 //MsgStop("Retorno WebService: "+oWs:oWSobterListareturn:CSTATUSRETORNO,"Requisição Ok")   
 If oWs:oWSobterListareturn:CSTATUSRETORNO = 'ok'
 	aDados := oWs:oWSobterListareturn:OWSDados:OWSObterListaResultDados
 Else
	oWS:oWSObterListaRequest:csigla := 'blue'    
	oWS:oWSObterListaRequest:cservicekey := SenhaSer
	oWS:oWSObterListaRequest:OWSOPCOESCLIENTES 	:= FormularioHelpDeskService_OpcoesClientes():New() //aDados
	oWS:oWSObterListaRequest:OWSDADOS 			:= FormularioHelpDeskService_ObterRequestDados():New() //aDados
	oWS:oWSObterListaRequest:OWSDados:cDTABERTURA := '2016/01/01 00:00:00;2040/12/21 23:59:59'
	oWS:oWSObterListaRequest:OWSOPCOESCLIENTES:CCNPJ := cValtoChar(cCnpj)

	If oWs:ObterLista()  

		 If oWs:oWSobterListareturn:CSTATUSRETORNO = 'ok'
		 	aDados := oWs:oWSobterListareturn:OWSDados:OWSObterListaResultDados
		 Endif	
	EndIf
 		
 EndIf
 
 //MsgStop("Por exemplo, 100 reais compram "+cValToChar(100 * oWS:nConversionRateResult )+" Dólares Americanos.")
 //MsgStop("Requisição Ok")
Else
 // Retorno .F., recupera e mostra string com detalhes do erro 
 MsgStop(GetWSCError(),"Erro de Processamento")
Endif 


Return(aDados)  



User Function BCDInt(cCodTicket)

Local oBtn
Local oDlg,oListBox
Local nDescont := 0
Local nOpcLib                  := 0
Local nFrete := 0
Local nSegFret := 0
Local nTotLiqPed := 0
Local nTotalList               := 0
Local nOpca					   := 0
Local aTotal	:= {0,0}
Local aTamGrpC := {001,001,255,423}
Local aPosTMem := {001,001,410,100} //240
Local oMemo
Local oFntUFCl1
Local oFntUFCl2  
Local cObsComp := "Teste" //U_WSBCD()   

Local Int01 := ""
Local Int02 := ""
Local Int03 := ""
Local Int04 := ""
Local Int05 := ""
Local Int06 := ""
Local Int07 := ""
Local Int08 := ""
Local Int09 := ""
Local Int10 := ""
Local Int11 := ""
Local Int12 := ""
Local Int13 := ""
Local Int14 := ""
Local Int15 := ""
Local Int16 := ""
Local Int17 := ""
Local Int18 := ""
Local Int19 := ""
Local Int20 := ""
Local Int21 := ""
Local Int22 := ""
Local Int23 := ""
Local Int24 := ""
Local Int25 := ""
Local Int26 := ""
Local Int27 := ""
Local Int28 := ""
Local Int29 := ""
Local Int30 := ""
Local Int31 := ""
Local Int32 := ""
Local Int33 := ""
Local Int34 := ""
Local Int35 := ""
Local Int36 := ""
Local Int37 := ""
Local Int38 := ""
Local Int39 := ""
Local Int40 := ""
Local Int41 := ""
Local Int42 := ""
Local Int43 := ""
Local Int44 := ""
Local Int45 := ""
Local Int46 := ""
Local Int47 := ""
Local Int48 := ""
Local Int49 := ""
Local Int50 := ""


Local cObsComp1 := "Teste 2" //U_WSBCD()   
Local cObsComp2 := "Teste 3" //U_WSBCD()
Local aDados := U_WSBCD(cCodTicket) 
Local aDados2 := {}

Private nTotPagar :=0
Private nSeguro := 0
Private nTotalPrec  := 0
Private aString := {}


	For nx := 1 to Len(aDados)                                                             
		
		aAdd(aDados2,{StrTran(aDados[nX]:cDescricao,"<br>",+chr(13)+chr(10))})
		
	Next 	


//	Define Dialog oDlg Title OemToAnsi("Libera‡„o por Al‡adas: Pedido: ") + SC5->C5_NUM + "  " + AllTrim(SA1->A1_NOME) + "  " + AllTrim(POSICIONE("SE4",1,xFilial("SE4")+SC5->C5_CONDPAG,"E4_COND")) + " DIAS" From 31,2 To 580,830 Pixel

	Define FONT oFntUFCl1 NAME "Arial" Size 000,018 BOLD
	Define FONT oFntUFCl2 NAME "Arial" Size 000,025 BOLD
    //oWindow:= TWindow():New(10, 10, 580, 830, "Exemplo TWindow", NIL, NIL, NIL, NIL, NIL, NIL, NIL,CLR_BLACK, CLR_WHITE, NIL, NIL, NIL, NIL, NIL, NIL, .T. )

 

    
	DEFINE MSDIALOG oDlg FROM 031,002 To 580,853 PIXEL TITLE OemToAnsi("Interações Ticket")   
	oScr:= TScrollBox():New(oDlg,aTamGrpC[01],aTamGrpC[02],aTamGrpC[03],aTamGrpC[04],.T.,.T.,.T.)


		 
		
	If Len(aDados2) >= 1 
		oMemo   := tMultiget():New(aPosTMem[01],aPosTMem[02],{|u|if(Pcount()>0,aDados2[1][1]:=u,aDados2[1][1])},oSCR  ,aPosTMem[03],aPosTMem[04],,,,,,.T.,,,{|| .T.})
    EndIf
    
    If Len(aDados2) >= 2 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[2][1] := u, aDados2[2][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
			
    If Len(aDados2) >= 3 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[3][1] := u, aDados2[3][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF			
    If Len(aDados2) >= 4 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[4][1] := u, aDados2[4][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
    If Len(aDados2) >= 5 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[5][1] := u, aDados2[5][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF                      
	If Len(aDados2) >= 6 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[6][1] := u, aDados2[6][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 7 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[7][1] := u, aDados2[7][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 8 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[8][1] := u, aDados2[8][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 9 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[9][1] := u, aDados2[9][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 10 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[10][1] := u, aDados2[10][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 11 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[11][1] := u, aDados2[11][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 12 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[12][1] := u, aDados2[12][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 13 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[13][1] := u, aDados2[13][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 14 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[14][1] := u, aDados2[14][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 15 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[15][1] := u, aDados2[15][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 16 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[16][1] := u, aDados2[16][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 17 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[17][1] := u, aDados2[17][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 18 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[18][1] := u, aDados2[18][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 19
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[19][1] := u, aDados2[19][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 20 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[20][1] := u, aDados2[20][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 21 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[21][1] := u, aDados2[21][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 22 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[22][1] := u, aDados2[22][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 23 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[23][1] := u, aDados2[23][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 24 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[24][1] := u, aDados2[24][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 25 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[25][1] := u, aDados2[25][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 26 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[26][1] := u, aDados2[26][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 27 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[27][1] := u, aDados2[27][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 28 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[28][1] := u, aDados2[28][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 29 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[29][1] := u, aDados2[29][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 30 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[30][1] := u, aDados2[30][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 31 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[31][1] := u, aDados2[31][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 32 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[32][1] := u, aDados2[32][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 33 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[33][1] := u, aDados2[33][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 34 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[34][1] := u, aDados2[34][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 35 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[35][1] := u, aDados2[35][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 36 
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[36][1] := u, aDados2[36][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 37
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[37][1] := u, aDados2[37][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 38
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[38][1] := u, aDados2[38][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 39
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[39][1] := u, aDados2[39][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 40
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[40][1] := u, aDados2[40][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 41
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[41][1] := u, aDados2[41][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF                                                                      
	If Len(aDados2) >= 42
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[42][1] := u, aDados2[42][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 43
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[43][1] := u, aDados2[43][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 44
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[44][1] := u, aDados2[44][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 45
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[45][1] := u, aDados2[45][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 46
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[46][1] := u, aDados2[46][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 47
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[47][1] := u, aDados2[47][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 48
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[48][1] := u, aDados2[48][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 49
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[49][1] := u, aDados2[49][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF
	If Len(aDados2) >= 50
		aPosTMem[01] := aPosTMem[01] +100
		oMemo 	:= tMultiget():create( oScr, {| u | if( pCount() > 0, aDados2[50][1] := u, aDados2[50][1] ) }, aPosTMem[01], aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T.,,,{|| .T.} )
	EndIF	
	

	
	//Next 	
	//oMemo   := tMultiget():New(aPosTMem[01],aPosTMem[02],{|u|if(Pcount()>0,cObsComp:=u,cObsComp)},oSCR  ,aPosTMem[03],aPosTMem[04],,,,,,.T.,,,{|| .T.})
	
   //	oMemo   := tMultiget():Create(oDlg,{|u|if(Pcount()>0,cObsComp1:=u,cObsComp1)},oDlg  ,aPosTMem[03],aPosTMem[04],,,,,,.T.,,,{|| .T.}) 
	//oMemo   := tMultiget():create( oScr, {| u | if( pCount() > 0, cObsComp1 := u, cObsComp1 ) }, aPosTMem[04]+1, aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T. )
   //	oMemo   := tMultiget():create( oScr, {| u | if( pCount() > 0, cObsComp2 := u, cObsComp2 ) }, aPosTMem[04]+aPosTMem[04]+10, aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T. )
//	oMemo   := tMultiget():create( oScr, {| u | if( pCount() > 0, cObsComp2 := u, cObsComp2 ) }, aPosTMem[04]+aPosTMem[04]+aPosTMem[04]+10, aPosTMem[02],aPosTMem[03],aPosTMem[04], , , , , , .T. )
	
   //	tButton():New(260,190,OemToAnsi("Frete" ),oDlg,{|| nOpca := 4,InfFrete()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
//	oBtn := tButton():New(260,235,OemToAnsi("Liberar" ),oDlg,{|| nOpca := 1,nOpcLib := 1,oDlg:End()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
//	oBtn := tButton():New(260,280,OemToAnsi("Cancelar"),oDlg,{|| nOpca := 0,nOpcLib := 0,oDlg:End()  },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
//	oBtn := tButton():New(260,325,OemToAnsi("Posicao" ),oDlg,{|| nOpca := 2,nOpcLib := 0,U_P460POS() },35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)
//	oBtn := tButton():New(260,370,OemToAnsi("Rel Ped" ),oDlg,{|| nOpca := 3,nOpcLib := 0,U_FSPEDBTN()},35,12,,oDlg:oFont,.F.,.T.,.F.,,.F.,,)

//oWindow:Activate()
	Activate MsDialog oDlg Center




Return(nOpcLib)