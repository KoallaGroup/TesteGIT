#include "protheus.ch"

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : ITMKA08				 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi	         										      		  |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para inserir motivo ao reativar pedido cancelado									  |
|---------------------------------------------------------------------------------------------------------|
*/

User Function ITMKA08(_cNum)   
Local _aArea		:= GetArea()
Local _aAreaSUA		:= SUA->(GetArea())
Local _aAreaSUB		:= SUB->(GetArea())
Local _aAreaSC6		:= SC6->(GetArea())
Local lRet			:= .F., _lReabre := .f.
Local nNivel		:= 0
Local cCodRet		:= ""           
//Local _cFilial	:= cFilAnt                                                       
Local nTela			:= 0 
Local _cNumAux		:= ""
Local cMsgReat		:= ""

Private Inclui 		:= .F.                       
Private oDlgTMP
Private oFont		:= tFont():New("Tahoma",,-12,,.t.)
Private lAltTpOper	:= .T.
Private _nReg 		:= IIF(Inclui,0,SUA->(Recno()))
Private _cFilial 	:= cFilAnt, _cFilBkp := cFilAnt 
Private _cTipo		:= ""         

Default _cNum 		:= space(TAMSX3("UA_NUM")[1])

_cNumAux := _cNum

//Verifica se o pedido passado por parametro pode ser reativado
If(!Empty(_cNum) .AND. !ValPed(_cFilial,_cNum))
	Return
EndIf

aObjeto := {}
aTamAut := MsAdvSize()
nTela	:= IIF(Empty(_cNum),15,0)

AAdd( aObjeto, { 100, 100, .T., .T. } )
aInfo := { aTamAut[ 1 ], aTamAut[ 2 ], aTamAut[ 3 ], aTamAut[ 4 ], 3, 3 } 
		
aPosObj := MsObjSize( aInfo, aObjeto, .f. ) 

aPosEnch := {aPosObj[1,1]+nTela,aPosObj[1,2],aPosObj[1,3]-12,aPosObj[1,4]}

//Cria janela com os dados do atendimento
RegToMemory("SUA", (Empty(_cNum)),.F.,.F.)

DEFINE MSDIALOG _oDlgSUA TITLE "Call Center ISAPA - Atendimento" From aTamAut[7],0 to aTamAut[6],aTamAut[5] of oMainWnd PIXEL
                                                                         	
If(Empty(_cNum))
	@ 003,005 Say "Filial: " 			SIZE 040,010 OF _oDlgSUA PIXEL FONT oFont 
	@ 003,025 MsGet _cFilial F3 "DLB" 	Size 010,010 of _oDlgSUA PIXEL FONT oFont //VALID (Vazio() .OR. ExistCpo("SZE",cEmpAnt+_cFilial))
			
	@ 003,055 Say "Pedido: " 			SIZE 040,010 OF _oDlgSUA PIXEL FONT oFont 
	@ 003,080 MsGet _cNum  		  		Size 010,010 of _oDlgSUA PIXEL FONT oFont //VALID (Vazio() .OR. ExistCpo("SUA",_cFilial+_cNum))
	
	@ 003,125 Button oButton PROMPT "Consultar"  SIZE 40,10   OF _oDlgsua PIXEL ACTION (FilSUA(_cFilial,_cNum)) 
EndIf

_oEnc01 := MsMGet():New("SUA",_nReg,3,        ,           ,          ,        ,aPosEnch,,,,,_oDlgSUA)
//_oEnc01:Hide()
_oEnc01:Disable()

@aPosObj[1,3]-5,aPosObj[1,4]-100 BUTTON "Sair" 					SIZE 70,14 ACTION (_cTipo:=" ",MsgRea()) OF _oDlgSUA PIXEL 
@aPosObj[1,3]-5,aPosObj[1,4]-200 BUTTON "Inclusão" 				SIZE 70,14 ACTION (_cTipo:="1",MsgRea()) OF _oDlgSUA PIXEL 
@aPosObj[1,3]-5,aPosObj[1,4]-300 BUTTON "Exclusão/Alteração" 	SIZE 70,14 ACTION (_cTipo:="2",MsgRea()) OF _oDlgSUA PIXEL 

ACTIVATE MSDIALOG _oDlgSUA CENTER

If(!Empty(_cTipo))     
    
	RecLock("SUA",.F.)
		SUA->UA__TPREAB := _cTipo
		//IF(Alltrim(SUA->UA__SITFIN) != "A" .AND. Alltrim(SUA->UA__SITCOM) != "A" .AND. Alltrim(_cTipo) == '2' )
        If Val(SUA->UA__STATUS) <= 5 .And. Val(SUA->UA__STAORI) <= 5 
            SUA->UA__ENVWMS := ' '
        EndIf
        If Val(SUA->UA__STATUS) > Val(SUA->UA__STAORI) 
            SUA->UA__STAORI := SUA->UA__STATUS 
        EndIf
        
        If _cTipo == "1"
        	SUA->UA__SITCOM := " "
        	SUA->UA__SITFIN := " "
        	SUA->UA__DTAPFI := CTOD("  /  /  ")
        	SUA->UA__DTAPCO := CTOD("  /  /  ")
        	SUA->UA__USAPFI := " "
        	SUA->UA__USAPCO := " "
        	SUA->UA__HRFIN  := " "
        	SUA->UA__HRCOM  := " "
        EndIf 
        
        SUA->UA__STATUS := "1"
		//EndIf
	MsUnlock()
	
	If !Empty(SUA->UA_NUMSC5)
	   DbSelectArea("SC5")
	   DbSetOrder(1)
	   If DbSeek(SUA->UA_FILIAL + SUA->UA_NUMSC5)
	       If Reclock("SC5",.f.)
	           SC5->C5__STATUS := "1"
	           MsUnlock()
	       EndIf
	   EndIf
	EndIf

//			lRet := ConPad1(,,,"SZD_RB",cCodRet,, .F.)
//			cCodRet := SZD->ZD_DESC
     
    cFilAnt := _cFilial

    DbSelectArea("SC9")
    DbSetOrder(1)
    If(DbSeek(SUA->UA_FILIAL+SUA->UA_NUMSC5))
		While !Eof() .And. (SUA->UA_FILIAL+SUA->UA_NUMSC5 = SC9->C9_FILIAL+SC9->C9_PEDIDO)
		    If Empty(SC9->C9_NFISCAL)
    		    A460Estorna()
    		EndIf
    		DbSelectArea("SC9")
    		DbSkip()
    	EndDo                 
    	
    	If(SUA->UA__RESEST == "S")
		    DbSelectArea("SUB")
		    DbSetOrder(1)
		    If(DbSeek(xFilial("SUB")+SUA->UA_NUM))
		    	Do While !(eof()) .AND. xFilial("SUB")+SUA->UA_NUM == xFilial("SUB")+SUB->UB_NUM
					U_ITMKEST1(SUA->UA_FILIAL,SUA->UA_NUM,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"I")				    	
				    DbSelectArea("SUB")
		    		DbSkip()
		    	EndDo
			EndIf		    	
    	EndIf
    	
    EndIf

    //Atualiza o status no WMS
    If Val(SUA->UA__STAORI) >= 5
        _aResult := {}
        _aResult := TCSPEXEC("PROC_PMHA_INTER_STATUS",SUA->UA_FILIAL,SUA->UA__SEGISP,SUA->UA_NUMSC5,SUA->UA_NUM,"INC","","")

        If !Empty(_aResult)
            If _aResult[1] == "S"
                Help( Nil, Nil, "ENV_REAB", Nil, "Nao foi possivel atualizar o Status no WMS (MHA). Informe a Logistica. - " + _aResult[2], 1, 0 )
            EndIf
        EndIf
    EndIf

	If(!Empty(_cNumAux))
	    SetFunName("TMKA271")
		TK271CallCenter("SUA",,4)
	Else
		MsgInfo("Pedido reaberto com sucesso")			
	EndIf
	
	REATPED()                     
	
/*			If(SUA->UA__RESEST == "S")
			    DbSelectArea("SUB")
			    DbSetOrder(4)
			    If(DbSeek(xFilial("SUB")+SUA->UA__FILIAL+SUA->UA_NUMSC5))
					While(xFilial("SUB")+SUA->UA__FILIAL+SUA->UA_NUMSC5 = xFilial("SUB")+SUB->UB__FILIAL+SUB->UB_NUMPV)
						U_ITMKEST1(SUA->UA__FILIAL,SUA->UA_NUMSC5,SUB->UB_ITEM,SUB->UB_PRODUTO,SUB->UB_LOCAL,SUB->UB_QUANT,"I")	
					    DbSelectArea("SUB")                                   
						DbSkip()
					EndDo
				EndIf
			EndIf*/

    //cFilAnt := SM0->M0_CODFIL
    cFilAnt := _cFilBkp

EndIf
		
RestArea(_aAreaSUA)
RestArea(_aAreaSUB)
RestArea(_aAreaSC6)
RestArea(_aArea)

Return


/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : REATPED				 	| 	Abril de 2014							  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi	         										      		  |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para Gravar a reativacao do pedido												  |
|---------------------------------------------------------------------------------------------------------|
*/

Static Function REATPED()
//Local _aAreaSUA := getArea()

dbSelectArea("SUA")
DbuseArea(.t., "TOPCONN", TcGenQry(,,"SELECT ZT_TOTPED FROM "+RetSqlName("SZT")+" WHERE ZT_PEDIDO='"+Sua->Ua_NumSC5+"' AND D_E_L_E_T_=' ' ORDER BY ZT_DATA, ZT_HORA DESC"), "LASTLIB")
//RecLock("SUA", .F.)
//	SUA->UA__STATUS	:= "1"
//	SUA->UA_CANC	:= " "                 
//MsUnlock()

/*If Abs((SUA->UA_ValBrut/LASTLIB->Zt_TotPed)*100)<=GetMv("MV__PERPED")
	If(SUA->UA__SITFIN != "A" .OR. SUA->UA__SITCOM != "A")
    	U_IFATA14(SUA->UA_NUM)
	Else
		RecLock("SUA", .F.)
			Sua->Ua__Status := "5"
		MsUnlock()
	EndIf		
EndIf*/


LASTLIB->(DbCloseArea())

dbSelectArea("SZT")
reclock("SZT", .T.)
SZT->ZT_FILIAL	:= xFilial("SZT")
SZT->ZT_USER   := __cUserId
SZT->ZT_NMUSR	:= cUserName
SZT->ZT_DATA   := Date()
SZT->ZT_HORA   := Time()
SZT->ZT_PEDIDO	:= SUA->UA_NUM
SZT->ZT_TOTPED	:= SUA->UA_ValBrut
//SZT->ZT_OBS		:= cCodRet

MsUnlock()

//msginfo("Pedido reaberto com sucesso")

Return

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : FilSUA				 	| 	Novembro de 2014						  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi	         										      		  |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para validar o pedido informado													  |
|---------------------------------------------------------------------------------------------------------|
*/                                                      

Static Function FilSUA(_cFilial,_cNum)
Default _cFilial := ""
Default _cNum	 := ""

If(Empty(_cFilial) .OR. Empty(_cNum) )
	Alert("Filial ou pedido não preenchido")
	Return
EndIf	

If(!ValPed(_cFilial,_cNum))
	Return
EndIf

RegToMemory("SUA", .F.)

_oEnc01 := MsMGet():New("SUA",_nReg,2,        ,           ,          ,        ,aPosEnch,,,,,_oDlgSUA)
_oEnc01:Disable()                    

_oDlgSUA:Refresh()

Return 

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : ValPed				 	| 	Novembro de 2014						  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi	         										      		  |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para validar o pedido informado													  |
|---------------------------------------------------------------------------------------------------------|
*/                                                      

Static Function ValPed(_cFilial,_cNum)
Local lRet 		:= .T.
Local cStatPed 	:= Alltrim(GETMV("MV__MOTREA")) 
Local _cGrpAte  := _cOper := "", _nNvReab := 0
	DbSelectArea("SUA")
	DbSetOrder(1)
	If DbSeek(_cFilial + _cNum)
        _cOper   := Posicione("SU7",4,xFilial("SU7") + __cUserId,"U7_COD") 
        _cGrpAte := SU7->U7_POSTO //Posicione("AG9",1,xFilial("AG9") + _cOper,"AG9_CODSU0")
        
        /*
        If SU7->U7_TIPO == "2"
            _nNvReab := Posicione("SU0",1,xFilial("SU0") + _cGrpAte,"U0__NVREA2")
        Else
            _nNvReab := Posicione("SU0",1,xFilial("SU0") + _cGrpAte,"U0__NIVREA")
        EndIf
        */
        
        _nNvReab := Posicione("SU0",1,xFilial("SU0") + _cGrpAte,"U0__NIVREA")
		DbSelectArea("SZM")
		DbSetOrder(1)
		If DbSeek(xFilial("SZM") + SUA->UA__STATUS) .And. SZM->ZM_NVREAB > 0
			//If !(alltrim(SUA->UA__STATUS) $ cStatPed)
			//	alert("Status do pedido não permite reativação")
			//	lRet := .F.
			//Elseif !(cNivel >= SZM->ZM_NVREAB .And. SZM->ZM_NVREAB > 0)- Jorge H - Anadi
			If (SZM->ZM_NVREAB > _nNvReab .And. cNivel != 9) .Or. ("LOGISTICA" $ SU0->U0_NOME .And. SZM->ZM_NVREAB <> _nNvReab .And. cNivel != 9)  
				alert("Seu usuário não possui permissão para reabrir este pedido. Pedido encontra-se com o status " + SZM->ZM_DESC)
				lRet := .F.
			EndIf
		Else
			Alert("Status do pedido não permite reativação. Pedido encontra-se com o status " + SZM->ZM_DESC)
			lRet := .F.
		EndIf   
	Else
		alert("Pedido não Encontrado")
		lRet := .F.
	EndIf

Return lRet

/*
|---------------------------------------------------------------------------------------------------------|
|	Programa : ValPed				 	| 	Novembro de 2014						  				      |
|---------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi	         										      		  |
|---------------------------------------------------------------------------------------------------------|
|	Descrição : Rotina para validar o pedido informado													  |
|---------------------------------------------------------------------------------------------------------|
*/                                                      

Static Function MsgRea()
Local lRet		:= .T.
Local cMsgReat	:= ""

IF(_cTipo == '1')
	cMsgReat := "O pedido será reaberto para inclusão." + Chr(13) + " Este sofrerá novas críticas Comer/Financ."
ElseIf(_cTipo == '2')
	cMsgReat := "O pedido será reaberto para alterações a menor." + Chr(13) + "Não sofrerá novas críticas Comer/Financ."
EndIf	

If(_cTipo != ' ')
	If !MsgYesNo(CmsgReat,"Confirma?")
		lRet := .F.
	EndIf
EndIf	  

If lRet
	_oDlgSUA:End()
EndIf

Return lRet
