#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | IFATA13 | Autor | Rubens Cruz	- Anadi Soluções   	 | Data | Agosto/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Criticas Comerciais/Financeiras											     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
| Parametros | cFilial  = Filial do pedido de venda do CallCenter                            |
|			 | cPedido  = Pedido de venda                                                    |
|			 | cCliente = Código do Cliente                                                  |
|			 | cLoja    = Loja do Cliente                                                    |
|			 | cTipo    = Tipo de Consulta / C - Criticas Comerciais                         |
|			 |								 F - Criticas Financeiras                        |
|			 |								 T - Ambas as Criticas                           |
+------------+-------------------------------------------------------------------------------+
*/

//u_ifata13("03","000461","3795        ","191","C") 

User Function IFATA13(_cFilial,_cPedido,_cCliente,_cLoja,_cTipo) 
	Local _aArea		:= GetArea()
	Local _aAreaSUA		:= SUA->(GetArea())
	Local aButtons		:= {} 
	Local cTitulo		:= ""  
    Local _lRet			:= .F.
    Local cObsCom
    Local cObsFin          
	Local cObs   
	Local dAprCom		:= CTOD("  /  /    ")
	Local dAprFin		:= CTOD("  /  /    ")
	Local cHorCom		:= "  :  :  "
	Local cHorFin		:= "  :  :  "
	Local cSitCom		:= space(TAMSX3("UA__SITCOM")[1])
	Local cSitFin		:= space(TAMSX3("UA__SITFIN")[1])    
	Local cPedSC5		:= SUA->UA_NUMSC5
	Local aCabec		:= {{030,045},;
							{015,080},;
							{139,194},;
							{259,278}}
	Local _aItens		:= {"E=Em Analise",;
							"A=Aprovado"}
							
	Private cComAux		:= ""
	Private cFinAux		:= ""
	Private aButtons   	:= {}
	Private oDlg		:= nil
	Private oGetTM1		:= nil
	Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
	Private oFont24		:= tFont():New("Tahoma",,-24,,.t.)
	
	DbSelectArea("SUA")
	DbSetOrder(12)
	If (MsSeek(xFilial("SUA")+_cFilial+_cPedido))

		//Preenche campos da janela com informações do Pedido
		cObsCom := SUA->UA__OBSCOM
		cObsFin := SUA->UA__OBSFIN
		cObs    := MSMM(SUA->UA_CODOBS)
		cSitCom := cComAux := SUA->UA__SITCOM
		cSitFin	:= cFinAux := SUA->UA__SITFIN
		dAprCom := SUA->UA__DTAPCO
		dAprFin := SUA->UA__DTAPFI 
		cHorCom := SUA->UA__HRCOM
		cHorFin := SUA->UA__HRFIN 
	
		DEFINE MSDIALOG oDlg TITLE OemToAnsi("Situacao de pedido - Call Center") From 000,000 To 480,680 OF oMainWnd PIXEL
		                                           
		@ 056,008 TO 108,330
		@ 007,008 TO 210,330   
		@ 007,008 TO 157,330   
	
		@ 010,aCabec[1][1] Say OemToAnsi("Observação Comercial")   	SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 020,aCabec[1][2] SCROLLBOX oScrollB1 HORIZONTAL VERTICAL SIZE 030, 250 OF oDlg BORDER
		@ 000,000 Get cObsCom MEMO 						SIZE 240,100 of oScrollB1 MULTILINE WHEN .F. PIXEL
	
		@ 060,aCabec[1][1] Say OemToAnsi("Observação Financeira")  	SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 070,aCabec[1][2] SCROLLBOX oScrollB2 HORIZONTAL VERTICAL SIZE 030, 250 OF oDlg BORDER
		@ 000,000 Get cObsFin MEMO 						SIZE 240,100 of oScrollB2 MULTILINE WHEN .F. PIXEL
	
		@ 110,aCabec[1][1] Say OemToAnsi("Observação Pedido")  		SIZE 80,10 OF oDlg PIXEL FONT oFont     
		@ 120,aCabec[1][2] SCROLLBOX oScrollB3 HORIZONTAL VERTICAL SIZE 030, 250 OF oDlg BORDER
		@ 000,000 Get cObs MEMO 			  			SIZE 240,100 of oScrollB3 MULTILINE WHEN .F. PIXEL
	
		@ 160,aCabec[1][1] Say OemToAnsi("Indica Situação")  		SIZE 80,10 OF oDlg PIXEL FONT oFont 
		
		@ 175,aCabec[2][1] Say OemToAnsi("Situação Comercial:") 	SIZE 80,10 OF oDlg PIXEL FONT oFont 
	 	@ 175,aCabec[2][2] COMBOBOX oSegto VAR cSitCom ITEMS _aItens 	SIZE 50,10 Of oDlg PIXEL WHEN (_cTipo $ "C;T" .AND. alltrim(cSitCom) = 'E') 
	
		@ 190,aCabec[2][1] Say OemToAnsi("Situação Financeira:")	SIZE 80,10 OF oDlg PIXEL FONT oFont 
	 	@ 190,aCabec[2][2] COMBOBOX oSegto VAR cSitFin ITEMS _aItens 	SIZE 50,10 Of oDlg PIXEL WHEN (_cTipo $ "F;T" .AND. alltrim(cSitFin) = 'E') 
		
		@ 175,aCabec[3][1] Say OemToAnsi("Data Aprovação:") 		SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 175,aCabec[3][2] Get dAprCom						 		SIZE 55,10 OF oDlg PIXEL FONT oFont WHEN .F.
		@ 190,aCabec[3][1] Say OemToAnsi("Data Aprovação:")			SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 190,aCabec[3][2] Get dAprFin						 		SIZE 55,10 OF oDlg PIXEL FONT oFont WHEN .F.
		
		@ 175,aCabec[4][1] Say OemToAnsi("Hora:")		 			SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 175,aCabec[4][2] Get cHorCom						 		SIZE 30,10 OF oDlg PIXEL FONT oFont WHEN .F.
		@ 190,aCabec[4][1] Say OemToAnsi("Hora:")					SIZE 80,10 OF oDlg PIXEL FONT oFont 
		@ 190,aCabec[4][2] Get cHorFin						 		SIZE 30,10 OF oDlg PIXEL FONT oFont WHEN .F.
	
	    @ 215,235 Button oButton PROMPT "Confirmar"  SIZE 40,15   OF oDlg PIXEL ACTION (_lRet := .T.,IFATA13G(cSitCom,cSitFin,_cTipo))
	    @ 215,285 Button oButton PROMPT "Fechar"  	 SIZE 40,15   OF oDlg PIXEL ACTION oDlg:End()
		
		ACTIVATE MSDIALOG oDlg CENTERED                                                                                
	
	Else
		alert("Pedido não encontrado")
		return
	EndIf			

	restarea(_aAreaSUA)
	restArea(_aArea)

Return _lRet 

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | IFATA13G | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Agosto/2014	  |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Grava aprovação Comercial/Financeira											  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function IFATA13G(cSitCom,cSitFin,_cTipo)
Local cStatus	:= "", _aResult := {}, cFilBkp := cFilAnt
Local cPedSC5	:= SUA->UA_NUMSC5, _lAlt := !Empty(SUA->UA__TPREAB) .And. !Empty(SUA->UA__ENVWMS) 
Local _lWms		:= .T.

If(_cTipo $ 'C;T')
	If(alltrim(SUA->UA__SITCOM) == 'A')
		MsgInfo("Pedido já aprovado")
		Return
	EndIf
EndIf         
If(_cTipo $ 'F;T')
	If(alltrim(SUA->UA__SITFIN) == 'A')
		MsgInfo("Pedido já aprovado")
		Return
	EndIf
EndIf


If(_cTipo $ 'C;T')
	If(cSitCom != SUA->UA__SITCOM .AND. alltrim(cSitCom) == 'A')
	    DbSelectArea("SUA")
		While !RecLock("SUA",.F.)
		EndDo
	    SUA->UA__SITCOM := cSitCom
	    SUA->UA__HRCOM	:= Time()
	    SUA->UA__DTAPCO := Date() 
	    SUA->UA__USAPCO	:= cUsername
		SUA->(MsUnlock()) 
		
		DbSelectArea("Z22")
		While !RecLock("Z22",.T.)
		EndDo
	    Z22->Z22_FILIAL := SUA->UA__FILIAL
	    Z22->Z22_NUM   	:= SUA->UA_NUM
	    Z22->Z22_IDUSER := __cUserID
	    Z22->Z22_NMEUSR	:= cUsername
	    Z22->Z22_NOME  	:= UsrFullName(__cUserID)
	    Z22->Z22_DATA  	:= Date()
	    Z22->Z22_HORA  	:= Time()
	    Z22->Z22_TIPOAP	:= "C"
		Z22->(MsUnlock()) 		
		   
	EndIf
EndIf

If(_cTipo $ 'F;T')
	If(cSitFin != SUA->UA__SITFIN .AND. alltrim(cSitFin) == 'A')
		While !RecLock("SUA",.F.)
		EndDo
	    SUA->UA__SITFIN := cSitFin
	    SUA->UA__HRFIN	:= Time()
	    SUA->UA__DTAPFI := Date()
	    SUA->UA__USAPFI	:= cUsername
		SUA->(MsUnlock())   
		
		While !RecLock("Z22",.T.)
		EndDo
	    Z22->Z22_FILIAL := SUA->UA__FILIAL
	    Z22->Z22_NUM   	:= SUA->UA_NUM
	    Z22->Z22_IDUSER := __cUserID
	    Z22->Z22_NMEUSR	:= cUsername
	    Z22->Z22_NOME  	:= UsrFullName(__cUserID)
	    Z22->Z22_DATA  	:= Date()
	    Z22->Z22_HORA  	:= Time()
	    Z22->Z22_TIPOAP	:= "F"
		SUA->(MsUnlock()) 		
		
	EndIf
EndIf

//Atualiza status do pedido com base no bloqueio financeiro e comercial e faz liberação na SC9 se não tiver bloqueio
Do Case
	Case (alltrim(SUA->UA__SITCOM) == 'E' .AND. alltrim(SUA->UA__SITFIN) == 'E')
		While !Reclock("SUA",.F.)
		EndDo
			SUA->UA__STATUS := '4'
		SUA->(MsUnlock())
	Case (alltrim(SUA->UA__SITCOM) == 'E' .AND. alltrim(SUA->UA__SITFIN) == 'A')
		While !Reclock("SUA",.F.)
		EndDo
			SUA->UA__STATUS := '2'
		SUA->(MsUnlock())
	Case (alltrim(SUA->UA__SITCOM) == 'A' .AND. alltrim(SUA->UA__SITFIN) == 'E')
		While !Reclock("SUA",.F.)
		EndDo
			SUA->UA__STATUS := '3'
		SUA->(MsUnlock())
	Case (alltrim(SUA->UA__SITCOM) == 'A' .AND. alltrim(SUA->UA__SITFIN) == 'A')
		While !Reclock("SUA",.F.)
		EndDo
			SUA->UA__STATUS := '5'
		SUA->(MsUnlock())
		
		cFilAnt := SUA->UA__FILIAL
		
		//Verifica se foi gerado pedido de venda para o pedido do callcenter
		If( !Empty(SUA->UA_NUMSC5) )
			DbSelectArea("SC5")
			DbSetOrder(1)
			If(!DbSeek(SUA->UA_FILIAL+SUA->UA_NUMSC5))
				_lWms := .F.		
			EndIf		
		Else
			_lWms := .F.		
		EndIf

		//Faz envio do pedido ao WMS se encontrar o pedido de venda
		If _lWms
			_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",cFilAnt,SUA->UA__SEGISP,cPedSC5,SUA->UA_NUM,"",IIF(_lAlt,"ALT","INC"),"","")
    	Else
    		_aResult := {"S",;
    					 "Pedido de venda não localizado,necessario reabrir o pedido antes de aprová-lo"}

		    Reclock("SUA",.F.)
		    	SUA->UA_NUMSC5 := ""
			SUA->(MsUnlock())
    	EndIf

		If !Empty(_aResult)
			If _aResult[1] == "S"
				Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
				_lRet := .f. 

			    Reclock("SUA",.F.)
			    SUA->UA__SITFIN := cFinAux
			    SUA->UA__SITCOM := cComAux
			    If(alltrim(cFinAux) == "E")
			    	SUA->UA__DTAPFI := CTOD("  /  /    ")
					SUA->UA__HRFIN	:= ""
					SUA->UA__STATUS := "3"
			    EndIf
			    If(alltrim(cComAux) == "E")
			    	SUA->UA__DTAPCO := CTOD("  /  /    ")
					SUA->UA__HRCOM	:= ""
					SUA->UA__STATUS := "2"
			    EndIf
                SUA->(MsUnlock())    
                
                Alert("Pedido permanece em analise")
            Else
				DbSelectArea("SC6")
				DbSetOrder(1)
				MsSeek(SUA->UA_FILIAL+cPedSC5)
				
				Do While((!EOF()) .AND. SUA->UA__FILIAL+cPedSC5 == SC6->C6_FILIAL+SC6->C6_NUM)
                    dbSelectArea("SB2")
                    dbSetOrder(1)
                    MsSeek(xFilial("SB2")+SC6->C6_PRODUTO+SC6->C6_LOCAL)
                    
                    DbSelectArea("SC6")
					Reclock("SC6",.F.)
					Begin Transaction
					   MaLibDoFat(0, SC6->C6_QTDVEN, /*@lBlqCrd*/, /*@lBlqEst*/, .F., .F. )
					End Transaction
			 		SC6->(MsUnlock())
			 		
			 		//Mata a reserva do item
			 		DbSelectArea("SUB")
			 		DbOrderNickName("SUBSC6")
			 		If DbSeek(xFilial("SUB") + SC6->C6_FILIAL + SC6->C6_NUM + SC6->C6_ITEM)
			 			U_ITMKEST1(SC6->C6_FILIAL,SUB->UB_NUM,SUB->UB_ITEM,"","",0,"E")
			 		EndIf
		
					DbSelectArea("SC6")
					DbSkip()
				EndDo
				
				DbSelectArea("SUA")
				While !Reclock("SUA",.f.)
				EndDo
				SUA->UA__ENVWMS := "S"
				SUA->(MsUnlock())
				
				DbSelectArea("SC5")
				DbSetOrder(1)
				If MsSeek(SUA->UA_FILIAL+cPedSC5)
				    While !Reclock("SC5",.f.)
				    EndDo
				    SC5->C5__STATUS := "5"
				    SC5->(MsUnlock())
				EndIf              
			EndIf
		Else
			Help( Nil, Nil, "ENVPEDVEN", Nil, "Erro ao enviar o pedido para o WMS", 1, 0 ) 
			_lRet := .f.
		EndIf
		
		cFilAnt := cFilBkp
EndCase           
                    

oDlg:End()

Return                   
