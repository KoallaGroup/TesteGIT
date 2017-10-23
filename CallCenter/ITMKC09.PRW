#Include "Protheus.ch"
#include "topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : ITMKC09			  		| 	Novembro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Funcao para exibir a observacao e gravar pendencia de pedido 							|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function ITMKC09(_cCLiente,_cLoja,_cPedSUA,_lExecAuto) 
Local lRet		:= .F., _aArea := GetArea()
Local nLinha 	:= 11
Local _aCodPend := {}
Local aStru		:= {010,050,185}
Local _cQuery	:= ""
Default _lExecAuto := .f.

Private cObsCom	:= ""

//Verifica se o pedido já possui vínculo com alguma pendência
//Cabeçalho
DbselectArea("SZP")
DbSetOrder(4)
If DbSeek(xFilial("SZP") + xFilial("SUA") + _cPedSUA)
    RestArea(_aArea)
    Return
EndIf

//Itens
DbselectArea("SZO")
DbSetOrder(3)
If DbSeek(xFilial("SZO") + xFilial("SUA") + _cPedSUA)
    RestArea(_aArea)
    Return
EndIf

Private cObsCom	:= "", _oDlgTMP, oFont := tFont():New("Tahoma",,-12,,.t.)

If Select("TRB_SZP") > 0
	DbSelectArea("TRB_SZP")
	DbCloseArea()
EndIf	

/*_cQuery := "SELECT UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZP_OBS)) MEMO,              " + Chr(13)
_cQuery += "        SZP.R_E_C_N_O_ RECNO,                                               " + Chr(13)
_cQuery += "		'SZP' ALIAS,                                                        " + Chr(13)
_cQuery += "		ZP_CODIGO CODPEND													" + Chr(13)
_cQuery += "FROM " + RetSqlName("SZP") + " SZP                                          " + Chr(13)
_cQuery += "WHERE SZP.ZP_CODCLI = '" + _cCLiente + "'                                   " + Chr(13)
_cQuery += "      AND SZP.ZP_LOJA = '" + _cLoja + "'                                    " + Chr(13)
_cQuery += "      AND SZP.ZP_UTILIZ = '2'                                               " + Chr(13)
_cQuery += "      AND SZP.D_E_L_E_T_ = ' '                                              " + Chr(13)

_cQuery += "UNION                                                                       " + Chr(13)

_cQuery += "SELECT UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZP_OBS)) MEMO,  			" + Chr(13)
_cQuery += "        SZO.R_E_C_N_O_ RECNO,												" + Chr(13)
_cQuery += "		'SZO' ALIAS,                                                        " + Chr(13)
_cQuery += "		ZO_CODIGO CODPEND													" + Chr(13)
_cQuery += "FROM " + RetSqlName("SZP") + " SZP 											" + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SZO") + " SZO ON SZO.ZO_FILIAL = SZP.ZP_FILIAL 	" + Chr(13)
_cQuery += "                         AND SZO.ZO_CODIGO = SZP.ZP_CODIGO      			" + Chr(13)
_cQuery += "                         AND SZO.ZO_CODCLI = SZP.ZP_CODCLI      			" + Chr(13)
_cQuery += "                         AND SZO.ZO_LOJA = SZP.ZP_LOJA          			" + Chr(13)
_cQuery += "                         AND SZO.ZO_UTILIZ = '2'                			" + Chr(13)
_cQuery += "                         AND SZO.D_E_L_E_T_ = ' '               			" + Chr(13)
_cQuery += "WHERE SZP.ZP_CODCLI = '" + _cCLiente + "' 									" + Chr(13)
_cQuery += "      AND SZP.ZP_LOJA = '" + _cLoja + "' 									" + Chr(13)
_cQuery += "      AND SZP.ZP_FILPED = '" + xFilial("SUA") + "' 							" + Chr(13)
_cQuery += "      AND SZP.D_E_L_E_T_ = ' '  											"
_cQuery += "ORDER BY SEQ DESC,															" + Chr(13)
_cQuery += "		 RECNO DESC 														"*/

_cQuery += "SELECT TRIM(UTL_RAW.CAST_TO_VARCHAR2(DBMS_LOB.SUBSTR(ZP_OBS,2000,1))) MEMO, " + Chr(13)
_cQuery += "        SZP.R_E_C_N_O_ RECNO												" + Chr(13)
_cQuery += "FROM " + RetSqlName("SZP") + " SZP 											" + Chr(13)
_cQuery += "WHERE SZP.ZP_CODCLI = '" + _cCLiente + "' 									" + Chr(13)
_cQuery += "      AND SZP.ZP_LOJA = '" + _cLoja + "' 									" + Chr(13)
_cQuery += "      AND SZP.ZP_UTILIZ = '2'                                               " + Chr(13)
_cQuery += "      AND SZP.D_E_L_E_T_ = ' '  											"
TcQuery _cQuery New Alias "TRB_SZP"             

DbSelectArea("TRB_SZP")
If !(eof())   
	While !(eof())
		cObsCom	  += TRB_SZP->MEMO + Chr(10) + Chr(13)
		AADD(_aCodPend,TRB_SZP->RECNO)
		DbSkip()
	EndDo
Else
	TRB_SZP->(DbCloseArea())
	RestArea(_aArea)
	Return lRet
EndIf

If !_lExecAuto
    //Monta janela para exibir observacao da pendencia
    DEFINE MSDIALOG _oDlgTMP TITLE "Pendencia de Pedido" FROM 000,000 To 240,540 of oMainWnd PIXEL
    
    @ nLinha,aStru[1] Say OemToAnsi("Observação da Pendência")   	SIZE 80,10 OF _oDlgTMP PIXEL FONT oFont 
    nLinha += 15
    
    @ nLinha,aStru[1] Get cObsCom MEMO 							SIZE 250,050 of _oDlgTMP WHEN .F. PIXEL
    nLinha += 56
    
    @ nLinha,aStru[1] Say OemToAnsi("Deseja vincular estas pendencias ao pedido gerado ?")   	SIZE 250,10 OF _oDlgTMP PIXEL FONT oFont 
    nLinha += 16
    
    @ nLinha,aStru[2] Button "Sim " Size 40,13 ACTION (ITMKC09A(_cCLiente,_cLoja,_cPedSUA,xFilial("SUA"),_aCodPend,_lExecAuto),lRet := .T.,_oDlgTMP:End()) PIXEL
    @ nLinha,aStru[3] Button "Não " Size 40,13 ACTION (_oDlgTMP:End()) PIXEL
    	
    ACTIVATE MSDIALOG _oDlgTMP CENTERED
Else
    ITMKC09A(_cCLiente,_cLoja,_cPedSUA,xFilial("SUA"),_aCodPend,_lExecAuto)
EndIf

TRB_SZP->(DbCloseArea())

RestArea(_aArea)
Return lRet                                                

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : ITMKC09A			  		| 	Novembro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Funcao para exibir a observacao e gravar pendencia de pedido 							|
|-------------------------------------------------------------------------------------------------------|	
*/

Static Function ITMKC09A(_cCLiente,_cLoja,_cPedido,_cFilial,_aCodPend,_lExec)
Local _aArea	:= GetArea()
Local _aAreaSZP	:= SZP->(GetArea())
Local _aAreaSZO	:= SZO->(GetArea())
Local nRecnoSZP := 0
Local _cQuery 	:= ""
Local nX		:= 0


//Grava observacao da pendencia no pedido
If !_lExec
	M->UA__OBSCOM := M->UA__OBSCOM + cObsCom
Else
	Reclock("SUA",.F.)
    SUA->UA__OBSCOM := SUA->UA__OBSCOM + cObsCom
    SUA->(MsUnlock())
EndIf

For nX := 1 To Len(_aCodPend)

	//Grava no cabeçalho que foi utilizado
	DbSelectArea("SZP")
	DbGoTo(_aCodPend[nX])

	RecLock("SZP",.F.)
		SZP->ZP_UTILIZ := '1'
	    SZP->ZP_PEDIDO := _cPedido
	    SZP->ZP_FILPED := _cFilial
	SZP->(MsUnlock())

	DbSelectArea("SZO")
	DbSetOrder(1)
	If DbSeek( SZP->(ZP_FILIAL+ZP_CODIGO+ZP_CODCLI+ZP_LOJA) )
		While(!Eof() .And. SZP->(ZP_FILIAL+ZP_CODIGO+ZP_CODCLI+ZP_LOJA) == SZO->(ZO_FILIAL+ZO_CODIGO+ZO_CODCLI+ZO_LOJA))
			
			//Verifico se o código do produto está preenchido
			RecLock("SZO",.F.)	
			If(!Empty(SZO->ZO_CODPROD))
				SZO->ZO_UTILIZ := '1'
				SZO->ZO_PEDIDO := _cPedido
				SZO->ZO_FILPED := _cFilial
			Else //Se não esta preencheido, não era pra esta linha estar aí, então deleto
			    Delete
			EndIf
			SZO->(MsUnlock()) 
			SZO->(DbSkip())
		EndDo
	EndIf
Next nX


//Se o cabeçalho não foi utilizado, grava a informação nas observações comercial do pedido
/*DbSelectArea("SZP")
DbSetOrder(1)
If DbSeek(xFilial("SZP") + _cCodPend + _cCliente + _cLoja) .And. SZP->ZP_UTILIZ == "2"
    If !_lExec
        M->UA__OBSCOM := M->UA__OBSCOM + cObsCom
    Else
        Reclock("SUA",.f.)
        SUA->UA__OBSCOM := SUA->UA__OBSCOM + cObsCom
        SUA->(MsUnlock())
    EndIf

    While !Reclock("SZP",.f.)
    EndDo
    SZP->ZP_UTILIZ := "1"
    SZP->ZP_PEDIDO := _cPedido
    SZP->ZP_FILPED := _cFilial
    SZP->(MsUnlock())
EndIf

//Atualiza os itens da pendencia que não foram utilizados
DbSelectArea("SZO")
DbSetOrder(1)
DbSeek(xFilial("SZO") + _cCodPend + _cCliente + _cLoja)

While !Eof() .And. SZO->ZO_FILIAL == xFilial("SZO") .And. SZO->ZO_CODIGO == _cCodPend .And. SZO->ZO_CODCLI == _cCliente .And. SZO->ZO_LOJA == _cLoja 

    If SZO->ZO_UTILIZ == "1"
        DbSkip()
        Loop
    EndIf

    While !Reclock("SZO",.f.)
    EndDo
    SZO->ZO_UTILIZ := "1"
    SZO->ZO_PEDIDO := _cPedido
    SZO->ZO_FILPED := _cFilial
    SZO->(MsUnlock())
    
    DbSelectArea("SZO")
    DbSkip()
EndDo*/


If !_lExec
    //Atualiza a gravação online
    U_ITMKGRON("SUA","")                                                                     	
EndIf

RestArea(_aAreaSZO)
RestArea(_aAreaSZP)
RestArea(_aArea)

Return