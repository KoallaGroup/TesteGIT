#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC06 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+---------+--------+------------------------------------------+-------+--------------+
| Descrição: | Verifica se o produto possui regra de desconto                                     |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function ITMKC06(_cProd)
Local _aArea  := GetArea(), _cSQL := _cTab := "", _cRegra := Alltrim(GetMv("MV__DSCCBR")), _oGet := Nil, _oDlg1 := {}
Local _cGrupo := Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_GRUPO"), _aHead := {}, _aFill := {}, _aCol := {}, _ny := _nz := 1
Local _aStru  := {"ACP__SEQIT", "ACP_PERDES", "ACP_FAIXA"}, _aTitulo := {"Faixa","Desconto","Quantidade"},_lok := .f.
Local _nPDesc := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP" }), _nPArmz := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL" })
Local _nPQSol := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__QTDSOL" }), _nPQPed := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT" })
Local _nPItem := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" })

If ( Type("lTk271Auto") <> "U" .AND. lTk271Auto )
    Return _cProd
EndIf

//Verifica as regras de desconto do produto
_cTab := GetNextAlias()
_cSQL := "Select Distinct ACP_PERDES, ACP_FAIXA, ACP__SEQIT From " + RetSqlName("ACP") + " ACP "
_cSQL += "Where ACP_FILIAL = '" + xFilial("ACP") + "' And ACP_CODREG = '" +  _cRegra + "' And ACP_CODPRO = '" + _cProd + "' And ACP.D_E_L_E_T_ = ' ' "

/*
_cSQL += 	"(ACP_CODPRO = '" + _cProd + "' Or ACP_GRUPO = '" + _cGrupo + "' Or "
_cSQL +=	"ACP__IDENT In (" 
_cSQL +=		"Select Distinct Z9_COD From " + RetSqlName("SZ9") + " Z9 Where Z9_PRODUTO = '" + _cProd + "' And Z9.D_E_L_E_T_ = ' ') ) And "
_cSQL +=		"ACP.D_E_L_E_T_ = ' ' "
*/
_cSQL += "Order By ACP__SEQIT,ACP_FAIXA,ACP_PERDES "
_cSQL := ChangeQuery(_cSQL)

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
	
	DbSelectArea("SX3")
	DbSetOrder(2)
	For _ny := 1 to Len(_aStru)
		If DbSeek(_aStru[_ny])
			Aadd(_aHead, {_aTitulo[_ny],SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,".T." /*SX3->X3_VALID*/,;
							SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R" /*SX3->X3_CONTEXT*/,SX3->X3_CBOX,"" /*SX3->X3_RELACAO*/})
	                       	                       
		Endif
	Next _ny	

	DbSelectArea("SX3")
	DbSetOrder(2)
	For _ny := 1 to Len(_aStru)
		If DbSeek(_aStru[_ny])
			Aadd(_aFill, CriaVar(SX3->X3_CAMPO))
		Endif
	Next _ny
	Aadd(_aFill, .F.)
	Aadd(_aCol, _aFill)
	
	DEFINE MSDIALOG _oDlg1 TITLE "Desconto Promocional" FROM 000,000 TO 350,450 PIXEL	
	_oGet := MsNewGetDados():New(300,300,300,300,/*GD_INSERT+GD_DELETE+GD_UPDATE*/,,,,,,9999,,,,_oDlg1,_aHead,_aCol)
	_ny := 1

	DbSelectArea(_cTab)
	While !Eof()
	
		If _ny != 1
			AADD(_oGet:aCols, Array(Len(_oGet:aHeader) + 1))
			_oGet:nAt := Len(_oGet:aCols)            

			DbSelectArea("SX3")
			DbSetOrder(2)
			For _nz := 1 to Len(_aStru)
				If DbSeek(_aStru[_nz])
					_oGet:aCols[_oGet:nAt][_nz] := CriaVar(SX3->X3_CAMPO)
				Endif
			Next _nz
			_oGet:aCols[_oGet:nAt][_nz] := .f.
		EndIf
	
		_oGet:aCols[_ny][1] := (_cTab)->ACP__SEQIT
		_oGet:aCols[_ny][2] := (_cTab)->ACP_PERDES
		_oGet:aCols[_ny][3] := (_cTab)->ACP_FAIXA
		_ny++
		
		DbSelectArea(_cTab)
		DbSkip()
	EndDo
	
	AlignObject( _oDlg1 ,{ _oGet:oBrowse }, 1, 1, { 500 } )
	_oGet:oBrowse:BldBlClick := {|| If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil)}
	ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT ( EnchoiceBar( _oDlg1, { || If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil ) }, { || _oDlg1:End() } ) )
	
EndIf

If _lOK
	aCols[n][_nPDesc] := _oGet:aCols[_oGet:nAt][2]
	aCols[n][_nPQSol] := _oGet:aCols[_oGet:nAt][3]
	M->UB__QTDSOL := _oGet:aCols[_oGet:nAt][3]
	RunTrigger(2,Len(aCols),,"UB__QTDSOL")  
	//aCols[n][_nPQPed] := U_ITMKA09(_cProd, aCols[n][_nPArmz], aCols[n][_nPItem], _oGet:aCols[_oGet:nAt][3],.t.)
EndIf

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

RestArea(_aArea)
Return _cProd



//Pergunta ao usuário se deseja manter o desconto, quando alterar a quantidade digitada
User Function ITMKC06Q(_cRet)
Local _nPDesc := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP" }), _nx := n

If ( Type("lTk271Auto") <> "U" .AND. lTk271Auto )
    Return _cRet
EndIf

If !(aCols[n][Len(aHeader) + 1]) .And. _nPDesc > 0
    If aCols[n][_nPDesc] > 0
        If !MsgYesNo("Deseja aplicar o desconto promocional?","Atencao")
            aCols[n][_nPDesc] := 0
            U_ITMKC05P("")
            n := _nx
            U_ITMKC07I("")
            n := _nx
        EndIf
    EndIf
EndIf

Return _cRet