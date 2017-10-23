#Include "Protheus.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA26 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Cadastro de Assuntos (SAC)                                   					   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa												  							   |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKA26()       
Private cCadastro := "Grupo Reg. Fiscal"

Private aCampos	:=	{	{"Codigo"		,"X5_CHAVE"		,TamSx3("X5_CHAVE")[3]	,TamSx3("X5_CHAVE")[1]	,TamSx3("X5_CHAVE")[2]	,"@!"},;						
						{"Descricao"	,"X5_DESCRI"	,TamSx3("X5_DESCRI")[3]	,TamSx3("X5_DESCRI")[1]	,TamSx3("X5_DESCRI")[2]	,"@!"}}
						
Private aRotina   := {		{"Pesquisar"	,"AxPesqui"     ,0,1},;
							{"Visualizar"	,"AxVisual"		,0,2},;
							{"Incluir"		,"U_ITMKA26I()"	,0,3},;
							{"Alterar"		,"U_ITMKA26A()"	,0,4},;
							{"Excluir"		,"U_ITMKA26E()"	,0,5}}
							

DbSelectArea("SX5")
Set Filter To X5_TABELA == 'T1' .And. X5_FILIAL == cFilAnt

mBrowse(6,1,22,75,"SX5",aCampos)

Return


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA26I | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina de inclusao																	|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa												  							    |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKA26I()
Local _cCodigo := _cProx := "", _cDescri := Space(TamSx3("X5_DESCRI")[1]), _nReg := SX5->(Recno()), _cFil := SX5->(DbFilter())
Local _aSM0 := SM0->(GetArea())

DbSelectArea("SX5")
Set Filter To
_cCodigo := Alltrim(Posicione("ZX5",1,xFilial("ZX5") + "  000012000001","ZX5_DSCITE")) //Controle de numeracao
_cCodigo := PADR(_cCodigo,TamSx3("X5_CHAVE")[1])

If Empty(_cCodigo)
	_cCodigo := "000001"
EndIf

//Dialogo para usuario cadastrar a opcao escolhida
If NewDlg2(_cCodigo,@_cDescri) .And. !Empty(_cDescri)
	DbSelectArea("SX5")
	DbSetOrder(1)
	While DbSeek(xFilial("SX5") + "T1" + _cCodigo)
		_cCodigo := SomaIt(_cCodigo)
	EndDo
	
	//Inclui o registro na SX5
	While !Reclock("SX5",.t.)
	EndDo
	SX5->X5_FILIAL		:= xFilial("SX5")
	SX5->X5_TABELA		:= "T1"
	SX5->X5_CHAVE		:= _cCodigo
	SX5->X5_DESCRI		:= _cDescri
	SX5->X5_DESCSPA   	:= _cDescri
	SX5->X5_DESCENG		:= _cDescri
	MsUnlock()
	_nReg := SX5->(Recno())
	
	//Atualiza o controle de numeração
	_cProx := SomaIt(_cCodigo)
	DbSelectArea("ZX5")
	DbSetOrder(1)
	If DbSeek(xFilial("ZX5") + "  000012000001")
		While !Reclock("SX5",.f.)
		EndDo
		ZX5->ZX5_DSCITE	:= _cProx
		MsUnlock()
	Else
		While !Reclock("SX5",.t.)
		EndDo
		ZX5->ZX5_FILIAL		:= xFilial("ZX5")
		ZX5->ZX5_GRUPO		:= "000012"
		ZX5->ZX5_DSCGRP		:= "SEQUENCIAL ASSUNTO SAC"
		ZX5->ZX5_CODIGO		:= "000001"
		ZX5->ZX5_DSCITE 	:= _cProx
		MsUnlock()			
	EndIf
	
	
	//Faz a inclusão nas demais filiais caso o SX5 seja de uso exclusivo
	DbSelectArea("SX2")
	DbSeek("SX5")
	
	If SX2->X2_MODO == "E"
		DbSelectArea("SM0")
		DbGoTop()
		SM0->(MsSeek(cEmpAnt))
		
		While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
		
			If SM0->M0_CODFIL == cFilAnt
				DbSkip()
				Loop
			EndIf
			
			//Inclui o registro na SX5
			While !Reclock("SX5",.t.)
			EndDo
			SX5->X5_FILIAL		:= SM0->M0_CODFIL
			SX5->X5_TABELA		:= "T1"
			SX5->X5_CHAVE	    := _cCodigo
			SX5->X5_DESCRI		:= _cDescri
			SX5->X5_DESCSPA   	:= _cDescri
			SX5->X5_DESCENG		:= _cDescri
			MsUnlock()
			
			DbSelectArea("SM0")
			DbSkip()
		
		EndDo
	EndIf
	
EndIf

RestArea(_aSM0)

DbSelectArea("SX5")
Set Filter To &_cFil
DbGoTo(_nReg)

Return



/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA26A | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina de alteração																	|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa												  							    |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKA26A()
Local _nReg := SX5->(Recno()), _cCodigo := SX5->X5_CHAVE, _cDescri := SX5->X5_DESCRI, _aSM0 := SM0->(GetArea()), _cFil := SX5->(DbFilter())

If NewDlg2(_cCodigo,@_cDescri) .And. !Empty(_cDescri)
	DbSelectArea("SX5")
	DbGoTo(_nReg)
	
	While !Reclock("SX5",.f.)
	EndDo
	SX5->X5_DESCRI	:= _cDescri
	SX5->X5_DESCSPA	:= _cDescri
	SX5->X5_DESCENG	:= _cDescri
	MsUnlock()
	
	Set Filter To
	
	//Faz a alteração nas demais filiais caso o SX5 seja de uso exclusivo
	DbSelectArea("SX2")
	DbSeek("SX5")
	
	If SX2->X2_MODO == "E"
		DbSelectArea("SM0")
		DbGoTop()
		SM0->(MsSeek(cEmpAnt))
		
		While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
		
			If SM0->M0_CODFIL == cFilAnt
				DbSkip()
				Loop
			EndIf
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			If DbSeek(SM0->M0_CODFIL + "T1" + _cCodigo)
				While !Reclock("SX5",.f.)
				EndDo
				SX5->X5_DESCRI		:= _cDescri
				SX5->X5_DESCSPA   	:= _cDescri
				SX5->X5_DESCENG		:= _cDescri
				MsUnlock()
			EndIf
				
			DbSelectArea("SM0")
			DbSkip()
		
		EndDo
	EndIf
	
EndIf

RestArea(_aSM0)
DbSelectArea("SX5")
Set Filter To &_cFil

Return


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA26E | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Rotina de exclusao																	|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa												  							    |
+------------+--------------------------------------------------------------------------------------+
*/

User Function ITMKA26E()
Local _nReg := SX5->(Recno()), _cSQL := _cTab := "", _lExcl := .t., _aSM0 := SM0->(GetArea()), _cCodigo := SX5->X5_CHAVE
Local _cFil := SX5->(DbFilter())

_cTab := GetNextAlias()

//Valida se o código não está em uso no cadastro de produtos
_cSQL := "Select Top 1 KK_CODSKQ From " + RetSqlName("SKK") + " KK "
_cSQL += "Where KK_FILIAL = '" + xFilial("SKK") + "' And KK_CODSKQ = '" + SX5->X5_CHAVE + "' And KK.D_E_L_E_T_ = ' ' "
_cSQL := ChangeQuery(_cSQL)

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf 

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
	If Alltrim((_cTab)->KK_CODSKQ) == Alltrim(SX5->X5_CHAVE)
		_lExcl := .f.
	EndIf
EndIf

If !_lExcl	
	Help( Nil, Nil, "REGUSO", Nil, "Este codigo ja foi utilizado em cadastros do SAC e nao sera possivel exclui-lo", 1, 0 )
ElseIf NewDlg2(SX5->X5_CHAVE,SX5->X5_DESCRI)
	DbSelectArea("SX5")
	DbGoTo(_nReg)
	If SX5->(Recno()) == _nReg
		While !Reclock("SX5",.f.)
		EndDo
		DbDelete()
		MsUnlock()
	EndIf
	
	Set Filter To
	
	//Faz a exclusão nas demais filiais caso o SX5 seja de uso exclusivo
	DbSelectArea("SX2")
	DbSeek("SX5")
	
	If SX2->X2_MODO == "E"
		DbSelectArea("SM0")
		DbGoTop()
		SM0->(MsSeek(cEmpAnt))
		
		While !Eof() .And. SM0->M0_CODIGO == cEmpAnt
		
			If SM0->M0_CODFIL == cFilAnt
				DbSkip()
				Loop
			EndIf
			
			DbSelectArea("SX5")
			DbSetOrder(1)
			If DbSeek(SM0->M0_CODFIL + "T1" + _cCodigo)
				While !Reclock("SX5",.f.)
				EndDo
				DbDelete()
				MsUnlock()
			EndIf
				
			DbSelectArea("SM0")
			DbSkip()
		
		EndDo
	EndIf
	
EndIf

RestArea(_aSM0)
DbSelectArea("SX5")
Set Filter To &_cFil

Return



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
oNewDlg2:cCaption := "Cadastro de Assuntos SAC"
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
oGet2:lReadOnly := .T.
oGet2:Align := 0
oGet2:cVariable := "_cCodigo"
oGet2:bSetGet := {|u| If(PCount()>0,_cCodigo:=u,_cCodigo) }
oGet2:lVisibleControl := .T.
oGet2:lPassword := .F.
oGet2:lHasButton := .F.

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