#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+---------+--------+------------------------------------------+-------+--------------+
| Descrição: | Consulta tabela de preço x UF no call center                                       |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function ITMKC07(_cTab)
Local _aArea := GetArea(), _oGet := Nil, _oDlg1 := {}
Local _aHead := {}, _aFill := {}, _aCol := {}, _ny := _nz := 1, _lOK := .f., _nAt := n
Local _aStru := {"DA1_ESTADO", "X5_DESCRI"}, _cUFTab := "", _aSM0 := SM0->(GetArea())
Local _nPTab := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
Local _nPDig := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local _nPUni := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local _nPTot := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local _nPCod := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local _nPQtd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local _nPDs2 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
Local _nPDs3 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
Local _nPDsV := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCCP" })
Local _nPDsP := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP"  }),_lPrcDig := .f.
Default _cTab := ""

If lTk271Auto
    DbSelectArea("SA1")
    DbSetOrder(1)
    DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)
    If SA1->A1_EST $ Alltrim(GetMv("MV__TABPUF")) .And. Val(M->UA__SEGISP) != 2
        _cTab := SA1->A1_EST
    Else
        _cTab := "BR"
    EndIf
EndIf

If Empty(_cTab)
	DbSelectArea("SX3")
	DbSetOrder(2)
	For _ny := 1 to Len(_aStru)
		If DbSeek(_aStru[_ny])
			Aadd(_aHead, {SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,".T." /*SX3->X3_VALID*/,;
							SX3->X3_USADO,SX3->X3_TIPO,"","R" /*SX3->X3_CONTEXT*/,SX3->X3_CBOX,"" /*SX3->X3_RELACAO*/})
	                       	                       
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
	
	DEFINE MSDIALOG _oDlg1 TITLE "Tabela De Preco x UF" FROM 000,000 TO 350,450 PIXEL
	_oGet := MsNewGetDados():New(300,300,300,300,/*GD_INSERT+GD_DELETE+GD_UPDATE*/,,,,,,9999,,,,_oDlg1,_aHead,_aCol)
	_ny := 1
	
	If !(M->UA_TIPOCLI $ Alltrim(GetMv("MV_TPSOLCF")))
		_oGet:aCols[_ny][1] := "BR"
		_oGet:aCols[_ny][2] := "BRASIL"
	EndIf
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA) .And. !(SA1->A1_EST $ _cUFTab) .And. SA1->A1_EST $ Alltrim(GetMv("MV__TABPUF"))
		
		If !Empty(_oGet:aCols[_ny][1])
			AADD(_oGet:aCols, Array(Len(_oGet:aHeader) + 1))
			_ny++
		EndIf
		_oGet:aCols[_ny][1] := SA1->A1_EST
		_oGet:aCols[_ny][2] := Posicione("SX5",1,xFilial("SX5") + "12" + SA1->A1_EST,"X5_DESCRI")
		_oGet:aCols[_ny][3] := .f.
		_cUFTab += "/" + SA1->A1_EST + "/"
	EndIf
	
	DbSelectArea("SM0")
	If DbSeek(cEmpAnt + M->UA__FILIAL) .And. !(SM0->M0_ESTCOB $ _cUFTab) .And. SM0->M0_ESTCOB $ Alltrim(GetMv("MV__TABPUF"))
		If !Empty(_oGet:aCols[_ny][1])
			AADD(_oGet:aCols, Array(Len(_oGet:aHeader) + 1))
			_ny++
		EndIf
		_oGet:aCols[_ny][1] := SM0->M0_ESTCOB
		_oGet:aCols[_ny][2] := Posicione("SX5",1,xFilial("SX5") + "12" + SM0->M0_ESTCOB,"X5_DESCRI")
		_oGet:aCols[_ny][3] := .f.
	EndIf
	
	If Empty(_oGet:aCols[_ny][1])
		_oGet:aCols[_ny][1] := "BR"
		_oGet:aCols[_ny][2] := "BRASIL"
	EndIf
	
	RestArea(_aSM0)
	
	AlignObject( _oDlg1 ,{ _oGet:oBrowse }, 1, 1, { 500 } )
	_oGet:oBrowse:BldBlClick := {|| If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil)}
	ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT ( EnchoiceBar( _oDlg1, { || If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil ) }, { || _oDlg1:End() } ) ) 

Else
	_lOk := .t.
EndIf

If _lOK

	If Empty(_cTab)
		_cTab := _oGet:aCols[_oGet:nAt][1]
	EndIf
	
	//Atualiza o preço de todos os itens
	For nx := 1 To Len(aCols)
		If !aCols[nx][Len(aHeader) + 1] .And. !Empty(aCols[nx][_nPCod])
			n := nx
			_lPrcDig := (aCols[nx][_nPTab] != aCols[nx][_nPDig])
			aCols[nx][_nPTab] := U_ITMKC05(aCols[nx][_nPCod],SA1->A1_EST,M->UA__TABPRC,M->UA_TIPOCLI,_cTab)
			aCols[nx][_nPTab] := U_ITMKA16(.f.) //verifica desconto por UF
			//Mantém o preço digitado e recalcula o desconto 1
			If _lPrcDig .And. !("UA_" $ ReadVar()) 
				aCols[nx][_nPDs2] := Round((1-(aCols[nx][_nPDig]/aCols[nx][_nPTab])) * 100,2)
				//IIF(aCols[nx][_nPDs2] < 0, 0,aCols[nx][_nPDs2])
			Else //Mantém o percentual de desconto e calcula o preço digitado
				aCols[nx][_nPDig] := Round((aCols[nx][_nPTab] - (aCols[nx][_nPTab]  * (aCols[nx][_nPDs2]/100))),2)
			EndIf
			
			n := nx
			U_ITMKC05P("")
			n := nx
			U_ITMKC07I("")
//			MAFISREF("IT_VALMERC","TK273",aCols[nx][_nPTot])
//			Eval(bGDRefresh)
//			Eval(bRefresh)
		EndIf
	Next nx
EndIf

n := _nAt
RestArea(_aArea)
Return _cTab


/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07V | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Valida a tabela de preço selecionada                                                |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07V()
Local _cUFTab := "", _aSM0 := SM0->(GetArea()), _aArea := GetArea()

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA) .And. !(SA1->A1_EST $ _cUFTab) .And. SA1->A1_EST $ Alltrim(GetMv("MV__TABPUF"))
	_cUFTab += "/" + SA1->A1_EST
EndIf

DbSelectArea("SM0")
If DbSeek(cEmpAnt + M->UA__FILIAL) .And. !(SM0->M0_ESTCOB $ _cUFTab) .And. SM0->M0_ESTCOB $ Alltrim(GetMv("MV__TABPUF"))
	_cUFTab += "/" + SM0->M0_ESTCOB + "/"
EndIf

If !(M->UA_TIPOCLI $ Alltrim(GetMv("MV_TPSOLCF"))) .Or. Empty(_cUFTab)
	_cUFTab += "BR"
EndIf

RestArea(_aSM0)

If !(M->UA__UFTAB $ _cUFTab)
	Help( Nil, Nil, "TABPRC", Nil, "Tabela de preço inválida", 1, 0 )
	Return .f.
EndIf

U_ITMKC07(M->UA__UFTAB) //Atualização do preço

RestArea(_aArea)
Return .t.

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07F | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Valida a Filial selecionada                                                         |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07F()
Local _lRet := .t.

For nx := 1 To Len(aCols)
	If !Empty(aCols[nx][2])
		_lRet := .f.
		Exit
	EndIf
Next nx

If !_lRet
	Help( Nil, Nil, "LOCFAT", Nil, "Nao é permitida alteração do local de faturamento.", 1, 0 )
	M->UA__FILIAL := cFilAnt
ElseIf MsgYesNo("Confirma a troca do local de faturamento?","ATENCAO")
	cFilAnt := M->UA__FILIAL
EndIf

Return .t.


/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07T | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Atualiza as funções fiscais e faz refresh dos objetos do call center                |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07T(_nRet)
Local _nPTot := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM"})
                                 
MaFisRef("IT_VALMERC","TK273",aCols[n][_nPTot])

Eval(bGDRefresh)
Eval(bRefresh)

Return _nRet

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07L | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Valida o modo de edição do cliente                                                  |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07L()
Local _lRet := .t.

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    Return _lRet
EndIf  

If(Inclui .Or. Altera)
	For nx := 1 To Len(aCols)
		If !Empty(aCols[nx][2])
			_lRet := .f.
			Exit
		EndIf
	Next nx
EndIf

If "UA__TIPPED" $ ReadVar()
    _lRet := U_ITMKVLSA1(M->UA_CLIENTE,M->UA_LOJA)
EndIf

Return _lRet

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07O | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Determina o tipo de operação a ser utilizado na venda                               |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07O()
Local _cOper := ""

//É brinde
If Posicione("SZF",1,xFilial("SZF") + M->UA__TIPPED,"ZF_BRINDE") == "1"
	_cOper := Separa(Alltrim(GetMV("MV__TPOPER")),"/")[2]
Else
	_cOper := Separa(Alltrim(GetMV("MV__TPOPER")),"/")[1]
EndIf

Return _cOper


/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07I | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Calcula o IPI/ST do Item                                                            |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07I(_nRet)
Local _nPAlq := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__ALQIPI" })
Local _nPIPI := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__VALIPI" })
Local _nPIST := aScan(aHeader, { |x| AllTrim(x[2]) == "UB__VALIST" })
Local _nPTab := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  })
Local _nPDig := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local _nPUni := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local _nPTot := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local _nPTes := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_TES" 	   })
Local _nPCod := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local _nPQtd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local _nPMIP := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCIPI" })

_cProd	 := IIF("UB_PRODUTO" $ ReadVar(), M->UB_PRODUTO,aCols[n][_nPCod])
_cTes	 := IIF("UB_TES"     $ ReadVar(), M->UB_TES	   ,aCols[n][_nPTES])
_nPrcDig := IIF("UB__PRCDIG" $ ReadVar(), M->UB__PRCDIG,aCols[n][_nPDig])
_nPrcTab := IIF("UB_PRCTAB"  $ ReadVar(), M->UB_PRCTAB ,aCols[n][_nPTab])

MaFisSave()
MaFisEnd()
MaFisIni(M->UA_CLIENTE,;  				// 1-Codigo Cliente/Fornecedor
		 M->UA_LOJA,;           		// 2-Loja do Cliente/Fornecedor
		 "C",;                  		// 3-C:Cliente , F:Fornecedor
		 "N",;                  		// 4-Tipo da NF
		 M->UA_TIPOCLI,;        		// 5-Tipo do Cliente/Fornecedor
		 Nil,;
		 Nil,;
	 	 Nil,;
		 Nil,;
		 "MATA461")

MaFisAdd(_cProd,; 						// 1-Codigo do Produto ( Obrigatorio )
		 _cTes,; 						// 2-Codigo do TES ( Opcional )
		 aCols[n][_nPQtd],; 			// 3-Quantidade ( Obrigatorio )
		 aCols[n][_nPUni],;				// 4-Preco Unitario ( Obrigatorio )
		 0,; 							// 5-Valor do Desconto ( Opcional )
		 "",; 							// 6-Numero da NF Original ( Devolucao/Benef )
		 "",; 							// 7-Serie da NF Original ( Devolucao/Benef )
		 0,; 							// 8-RecNo da NF Original no arq SD1/SD2
		 0,; 							// 9-Valor do Frete do Item ( Opcional )
		 0,; 							// 10-Valor da Despesa do item ( Opcional )
		 0,; 							// 11-Valor do Seguro do item ( Opcional )
		 0,; 							// 12-Valor do Frete Autonomo ( Opcional )
		 aCols[n][_nPTot],;				// 13-Valor da Mercadoria ( Obrigatorio )
		 0) 							// 14-Valor da Embalagem ( Opcional )
    	
_nItem := 1
    	
aCols[n][_nPAlq] := MaFisRet(_nItem,"IT_ALIQIPI")
aCols[n][_nPIPI] := MaFisRet(_nItem,"IT_VALIPI")
aCols[n][_nPIST] := MaFisRet(_nItem,"IT_VALSOL")
aCols[n][_nPMIP] := aCols[n][_nPTot] + aCols[n][_nPIPI]

MaFisEnd()
MaFisRestore()

Return _nRet

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07P | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Atualiza o preço quando a UF da tabela de preço for alterada                        |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07P(_nRet)

U_ITMKC07(M->UA__UFTAB)

Return _nRet

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07Q | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Verifica a quantidade de lojas do cliente                                           |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07Q(_cCli)
Local _nQtd := 0, _aArea := SA1->(GetArea())

DbSelectArea("SA1")
DbSetOrder(1)
If DbSeek(xFilial("SA1") + _cCli)
	While !Eof() .And. (SA1->A1_FILIAL + SA1->A1_COD) == (xFilial("SA1") + _cCli)
		_nQtd++
		DbSkip()
	EndDo
EndIf

RestArea(_aArea)	
Return _nQtd

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07Z | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Enchoice do call center espandida                                                   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07Z()
Local _nReg := IIF(Inclui,0,SUA->(Recno())), _nOpc := IIF(Inclui,3,4)

If Inclui .Or. Altera
	aObjeto := {}
	aTamAut 		:= MsAdvSize()
	
	AAdd( aObjeto, { 100, 100, .T., .T. } )
	aInfo := { aTamAut[ 1 ], aTamAut[ 2 ], aTamAut[ 3 ], aTamAut[ 4 ], 3, 3 } 
	
	aPosObj := MsObjSize( aInfo, aObjeto, .f. ) 

	aPosEnch := {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-12,aPosObj[1,4]}
	DEFINE MSDIALOG _oDlgSUA TITLE "Call Center ISAPA - Atendimento" From aTamAut[7],0 to aTamAut[6],aTamAut[5] of oMainWnd PIXEL
	_oEnc01 := MsMGet():New("SUA",_nReg,_nOpc,        ,           ,          ,        ,aPosEnch,,,,,_oDlgSUA)
	@aPosObj[1,3]-5,aPosObj[1,4]-100 BUTTON "OK" SIZE 30,14 ACTION _oDlgSUA:End() OF _oDlgSUA PIXEL 
	ACTIVATE MSDIALOG _oDlgSUA CENTER
EndIf

Return ""


/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC07K | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Validação edição de campo na SUB quando utilizado KIT                               |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC07K()
Local _lEdita := .t.
Local _nPKit := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__CODKIT" })
Local _nPAce := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__CODACE" })
Local _nPQKt := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__QTDKIT" })

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
    Return _lEdita
EndIf

If _nPKit > 0
    If !Empty(aCols[n][_nPKit])
        _lEdita := .f.
    EndIf
EndIf

If _nPAce > 0 .And. _lEdita
    If !Empty(aCols[n][_nPAce])
        _lEdita := .f.
    EndIf
EndIf

If _nPQKt > 0 .And. _lEdita
    If aCols[n][_nPQKt] > 0
        _lEdita := .f.
    EndIf
EndIf

Return _lEdita