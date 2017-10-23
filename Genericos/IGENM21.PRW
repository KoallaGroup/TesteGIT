#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
+------------+---------+--------+------------------------------------------+-------+----------------+
| Programa:  | IGENM21 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Fevereiro/2015 |
+------------+---------+--------+------------------------------------------+-------+----------------+
| Descrição: | Consulta padrão de Regiões de venda                                                  |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function IGENM21()
	Local nX           	:= 0, _nAcao := 0
	Local aButtons     	:= {}
	Local aCpoEnch     	:= { 'NOUSER' }
	Local nStyle	   	:= GD_INSERT + GD_DELETE + GD_UPDATE
	Local cLinOk       	:= "AllwaysTrue"
	Local cTudoOk      	:= "AllwaysTrue"
	Local cIniCpos     	:= "ZX5_CODIGO"
	Local nFreeze      	:= 000
	Local nMax         	:= 99999
	Local cFieldOk     	:= "AllwaysTrue"
	Local cSuperDel    	:= ""
	Local cDelOk       	:= "AllwaysFalse"
	Local aAlterGDa    	:= {}
	Local cAliasOrg		:= GetArea()
	Local aFieldTit 	:= {}
	Local aAlterFields  := {}
	Local _aFields 		:= {}
	Local _cFilter		:= Space(30)
	Static cCodigo		:= ""
	
	Private nUsado     	:= 0
	Private _aHeader   	:= {}
	Private _aCols     	:= {}
	Private oDlgPgt1
	Private oDlg
	Private oGetD
	Private oEnch
	Private aTELA[0][0]
	Private aGETS[0]
	
	aFieldTit 		:= 				{"Codigo"       ,"Descrição"}
	aAlterFields  	:= _aFields := 	{"ZX5_CODIGO"	,"ZX5_DSCITE"}
	
	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd( aObjects, { 100,  15, .t., .f. } )
	AAdd( aObjects, { 100, 100, .t., .t. } )
	
	aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
	
	aPosObj := MsObjSize(aInfo, aObjects)	
	
	nUsado:=0
	
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(_aFields)
		If SX3->(DbSeek(_aFields[nX]))
			Aadd(_aHeader, {aFieldTit[nx],aAlterFields[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R" /*SX3->X3_CONTEXT*/})
			nUsado:=nUsado+1
		Endif
	Next nX
	           
	//Insere produtos caso exista
	/*
	AADD(_aCols,{space(TamSX3("ZX5_CODIGO")[1]) 	,;
				space(TamSX3("ZX5_DSCITE")[1])		,;
				.F.									})
	*/
	
	
	DEFINE MSDIALOG oDlg TITLE "Regioes de Venda" From 0,0 To 400,700 OF oMainWnd PIXEL
	
	oSayD := TSay():New( 009,004,{||"Buscar:"}    ,/*oGrp1*/,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,,)
	
	@ 007,052 MsGet _cFilter Size 150,010 of ODlg PIXEL VALID (CriaCols(upper(alltrim(_cFilter))))

	oFilD := TButton():New( 007, 242, "Filtrar",oDlg,{||CriaCols(upper(alltrim(_cFilter)))},40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	oGetD:= MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,cTudoOk, cIniCpos, aAlterGDa, nFreeze, nMax,cFieldOk,cSuperDel,cDelOk, oDLG, _aHeader, _aCols)
	CriaCols(upper(alltrim(_cFilter)), '')
    
	If FunName() == "IFATA30" .Or. FunName() == "MATA040"
	    @ 188,010 Button oButton1 PROMPT "Nova Regiao"    SIZE 40,10   OF oDlg PIXEL ACTION {|| IGENM21I(_cFilter)} 
	EndIf
    @ 188,210 Button oButton2 PROMPT "Confirmar"  SIZE 40,10   OF oDlg PIXEL ACTION {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()} 
    @ 188,280 Button oButton3 PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oGetD:oBrowse:BldBlClick := {|| _nAcao := 1, cCodigo := _acols[oGetD:nAt][1],oDlg:End()}
	oDlg:lCentered := .T.
	oDlg:Activate() 
	
	If(_nAcao != 1)
		cCodigo := space(TAMSX3("ZX5_CODIGO")[1])	
	EndIf
	
	RestArea(cAliasOrg)
	
Return cCodigo

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM20B			  		| 	Fevereiro/2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Popula variavel Global para retorno da consulta específica					  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static function IGENM20B()
	cCodigo := _acols[oGetD:nAt][1]
	oDlg:End()
return cCodigo

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : CriaCols			  		| 	Fevereiro/2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Cria aCols da tela de referencias											  	|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function CriaCols(_cFilter)
Local _cSQL := _cTab := ""
	
_cTab := GetNextAlias()
_cSQL := "Select Distinct ZX5_CODIGO,ZX5_DSCITE From " + RetSqlName("ZX5") + " X5 "
_cSQL += "Where ZX5_GRUPO = '000006' And "
_cSQL +=    "(ZX5_CODIGO Like '%" + _cFilter + "%' Or ZX5_DSCITE Like '%" + _cFilter + "%') And X5.D_E_L_E_T_ = ' ' " 
_cSQL += "Order By ZX5_DSCITE"

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
	
_aCols :={}

DbSelectArea(_cTab)
DbGoTop()

While (!Eof())
	AADD(_aCols,{(_cTab)->ZX5_CODIGO 		,;
				 (_cTab)->ZX5_DSCITE		,;
				 .F.})
	dbSkip()
EndDo

if  ((_cTab)->(BOF()) .AND. (_cTab)->(EOF()))
    AADD(_aCols,{space(TamSX3("ZX5_CODIGO")[1])     ,;
                space(TamSX3("ZX5_DSCITE")[1])      ,;
                .F.                                 })
EndIf

oGetD:aCols := _aCols
oGetD:nAt := Len(_aCols)

oDlg:Refresh()

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf
	                              
Return


Static Function IGENM21I(_cFilter)
Local _cCodReg := Space(TamSX3("ZX5_CODIGO")[1]),_cDescReg := Space(TamSX3("ZX5_DSCITE")[1])

If NewDlg2(@_cCodReg,@_cDescReg)
	
	If Empty(_cCodReg) .Or. Empty(_cDescReg)
		MsgStop("Os 2 campos devem ser preenchidos","ATENCAO")
		Return
	EndIf
	
	Reclock("ZX5",.t.)
	ZX5->ZX5_FILIAL := xFilial("ZX5")
	ZX5->ZX5_GRUPO  := "000006"
	ZX5->ZX5_DSCGRP := "REGIOES DE VENDA"
	ZX5->ZX5_CODIGO := _cCodReg
	ZX5->ZX5_DSCITE := _cDescReg
	ZX5->(MsUnlock())
	
	CriaCols(upper(alltrim(_cFilter)), '')
EndIf

Return
         

Static Function IGENM21V(_cCodReg)
DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5") + "  000006" + _cCodReg)
	MsgAlert("Regiao já cadastrada","Atencao")
	Return .f.
EndIf

Return .t.

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | NewDlg2 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Diálogo onde o usuário fará a inclusão, alteração ou exclusão dos registros         |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa																               |
+------------+-------------------------------------------------------------------------------------+
*/

Static Function NewDlg2(_cCodigo,_cDescri)
Local oNewDlg2,oSay1,oGet2,oSay3,oGet4,oSBtn5,oSBtn6, _lRet := .f.

oNewDlg2 := MSDIALOG():Create()
oNewDlg2:cName := "oNewDlg2"
oNewDlg2:cCaption := "Cadastro Regiao de Transporte"
oNewDlg2:nLeft := 0
oNewDlg2:nTop := 0
oNewDlg2:nWidth := 536
oNewDlg2:nHeight := 144
oNewDlg2:lShowHint := .F.
oNewDlg2:lCentered := .T.

oSay1 := TSAY():Create(oNewDlg2)
oSay1:cName := "oSay1"
oSay1:cCaption := "Codigo"
oSay1:nLeft := 8
oSay1:nTop := 9
oSay1:nWidth := 42
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGet2 := TGET():Create(oNewDlg2)
oGet2:cName := "oGet2"
oGet2:cCaption := "oGet2"
oGet2:nLeft := 65
oGet2:nTop := 9
oGet2:nWidth := 97
oGet2:nHeight := 21
oGet2:lShowHint := .F.
oGet2:lReadOnly := .F.
oGet2:Align := 0
oGet2:cVariable := "_cCodigo"
oGet2:bSetGet := {|u| If(PCount()>0,_cCodigo:=u,_cCodigo) }
oGet2:lVisibleControl := .T.
oGet2:lPassword := .F.
oGet2:lHasButton := .F.
oGet2:bValid := {|| IGENM21V(_cCodigo) }

oSay3 := TSAY():Create(oNewDlg2)
oSay3:cName := "oSay3"
oSay3:cCaption := "Descricao"
oSay3:nLeft := 8
oSay3:nTop := 44
oSay3:nWidth := 54
oSay3:nHeight := 17
oSay3:lShowHint := .F.
oSay3:lReadOnly := .F.
oSay3:Align := 0
oSay3:lVisibleControl := .T.
oSay3:lWordWrap := .F.
oSay3:lTransparent := .F.

oGet4 := TGET():Create(oNewDlg2)
oGet4:cName := "oGet4"
oGet4:cCaption := "oGet4"
oGet4:nLeft := 65
oGet4:nTop := 44
oGet4:nWidth := 443
oGet4:nHeight := 21
oGet4:lShowHint := .F.
oGet4:lReadOnly := .F.
oGet4:Align := 0
oGet4:cVariable := "_cDescri"
oGet4:bSetGet := {|u| If(PCount()>0,_cDescri:=u,_cDescri) }
oGet4:lVisibleControl := .T.
oGet4:lPassword := .F.
oGet4:Picture := "@!"
oGet4:lHasButton := .F.

oSBtn5 := SBUTTON():Create(oNewDlg2)
oSBtn5:cName := "oSBtn5"
oSBtn5:cCaption := "&OK"
oSBtn5:nLeft := 141
oSBtn5:nTop := 75
oSBtn5:nWidth := 52
oSBtn5:nHeight := 22
oSBtn5:lShowHint := .F.
oSBtn5:lReadOnly := .F.
oSBtn5:Align := 0
oSBtn5:lVisibleControl := .T.
oSBtn5:nType := 1
oSBtn5:bAction := {|| _lRet := .t.,oNewDlg2:End() }

oSBtn6 := SBUTTON():Create(oNewDlg2)
oSBtn6:cName := "oSBtn6"
oSBtn6:cCaption := "oSBtn6"
oSBtn6:nLeft := 320
oSBtn6:nTop := 75
oSBtn6:nWidth := 52
oSBtn6:nHeight := 22
oSBtn6:lShowHint := .F.
oSBtn6:lReadOnly := .F.
oSBtn6:Align := 0
oSBtn6:lVisibleControl := .T.
oSBtn6:nType := 2
oSBtn6:bAction := {|| oNewDlg2:End() }

oNewDlg2:Activate()

Return _lRet