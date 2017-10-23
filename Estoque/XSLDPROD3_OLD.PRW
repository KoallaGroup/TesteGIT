#Include 'Protheus.ch' 

/*
+-------------+-----------+--------+------------------------------------------+-------+------------+
| Programa:   | XSLDPROD3 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Julho/2015 |
+-------------+-----------+--------+------------------------------------------+-------+------------+
| Descrição:  | Retorna o calculo do saldo do produto especifico Isapa para um RANGE de armazém    |
+-------------+------------------------------------------------------------------------------------+
| Parametros  | _cFilial   -> Filial para calculo do saldo										   |
|			  | _cProduto  -> Código do produto para calculo do saldo							   |
|			  | _cLocDe    -> Código do local DE (armazém para calculo do saldo)				   |
|			  | _cCodSUA   -> Código do pedido na SUA para analisar o estoque online			   |
|			  |	_cOriExec  -> Origem da execução												   |
|			  | _cNumSC5   -> Pedido SC5														   |
|			  | _cItmSC6   -> Item pedido SC6													   |
|			  |	_cLocAte   -> Código do local ATE (armazém para calculo do saldo)				   |
+-------------+------------------------------------------------------------------------------------+
| Retorno     | _nSaldo -> Saldo do produto na filial e local informado					   		   |
+-------------+------------------------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         	   		   |
+-------------+------------------------------------------------------------------------------------+
*/

User Function xSldPrd3(_cFilial,_cProduto,_cLocDe,_cCodSUA,_cOriExec,_cNumSC5,_cItmSC6,_cLocAte)

Local _aAreaAtu  := GetArea()
Local _aAreaSB1  := SB1->( GetArea() )
Local _cSegmento := Posicione( "SB1", 1, xFilial( "SB1" ) + _cProduto, "B1__SEGISP" )
Local _nSaldo	 := 0, _lErroSP := .f.
Local _aResult	 := {}

Default _cCodSUA := Replicate("Z", TamSX3( "Z10_CODSUA" )[1]), _cOriExec := "", _cNumSC5 := "", _cItmSC6 := "", _cLocAte := "" 
DbSelectArea("Z10")

If Empty(_cLocAte)
	_cLocAte := _cLocDe
EndIf

_aResult := TCSPExec( "SPSLDPRD3",;
					 _cFilial,;
					 _cProduto,;
					 _cLocDe,;
					 _cCodSUA,;
					 _cNumSC5,;
					 _cItmSC6,; 
					 _cLocAte )

If Empty( _aResult )
	MsgStop( "Problema com a SP: " + TCSQLError() ) 
	_lErroSP := .t.
Else
	_nSaldo := _aResult[1]
Endif

//If !Empty( _aResult[1] ) .and. _cFilial == "03" .and. Val(_cSegmento) == 1 .And. Empty(_cOriExec)
If !_lErroSP .and. _cFilial == "03" .and. Val(_cSegmento) == 1 .And. Empty(_cOriExec)
	_aResult := TCSPExec( "SPSLDPRD3",;
						  "05",;
						  _cProduto,;
						  _cLocDe,;
						  _cCodSUA,;
						  _cNumSC5,;
						  _cItmSC6,; 
						  _cLocAte )
						 
	If Empty( _aResult )
		MsgStop( "Problema com a SP: " + TCSQLError() )
		_lErroSP := .t.
	Else
		_nSaldo += _aResult[1]
	Endif
				 
Endif

RestArea( _aAreaSB1 )
RestArea( _aAreaAtu )

Return _nSaldo


/*
+------------+----------+--------+------------------------------------------+-------+------------+
| Programa:  | xSldKit3 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Julho/2015 |
+------------+----------+--------+------------------------------------------+-------+------------+
| Descrição: | Retorna a quantidade disponivel do KIT para um RANGE de armazém	                 |
+------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                             |
+------------+-----------------------------------------------------------------------------------+
*/

User Function xSldKit3(_cFilial,_cProd,_cLocDe,_cCodSUA,_cLocAte)
Local _cSQL := _cTab := "", _nQtdKit := 0, _nQtdComp := 0
Default _cFilial := "", _cProd := "", _cLocDe := "", _cCodSUA := "", _cLocAte := ""

DbSelectArea("SUG")
SUG->(DbSetOrder(2))
If !DbSeek(xFilial("SUG") + _cProd)
    MsgStop("KIT Não localizado")
    Return _nQtdKit
EndIf

If Empty(_cLocAte)
	_cLocAte := _cLocDe
EndIf

_cTab := GetNextAlias()
_cSQL := "Select U1_ACESSOR,U1_QTD From " + RetSqlName("SU1") + " U1 "
_cSQL += "Inner Join " + RetSqlName("SB1") + " B1 On B1_COD = U1_ACESSOR And B1.D_E_L_E_T_ = ' ' "
_cSQL += "Where U1_FILIAL = '" + xFilial("SU1") + "' And U1_CODACE = '" + SUG->UG_CODACE + "' And U1_QTD > 0 And U1.D_E_L_E_T_ = ' ' "  

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If Eof()
    MsgStop("KIT Não localizado")
    Return _nQtdKit
Else
    While !Eof()
    
        _nQtdComp := U_xSldPrd3(_cFilial,(_cTab)->U1_ACESSOR,_cLocDe,_cCodSUA," "," "," ",_cLocAte)
        
        If _nQtdComp <= 0
            _nQtdKit := 0
            Exit
        Else
            _nQtdComp := Int(_nQtdComp/(_cTab)->U1_QTD)
            
            If _nQtdComp <= 0
                _nQtdKit := 0
                Exit
            ElseIf _nQtdKit == 0 .Or. _nQtdKit > _nQtdComp
                _nQtdKit := _nQtdComp  
            EndIf
        EndIf
            
        DbSelectArea(_cTab)
        DbSkip()
    EndDo
EndIf

Return _nQtdKit



User Function xSldVend3()
Local _nSaldo := 0, _nPCod := aScan(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local _cProd := IIF("UB_PRODUTO" $ ReadVar(),M->UB_PRODUTO,aCols[n][_nPCod])

If GDFIELDGET("UB_LOCAL") $ GetMv("MV__ARMVEN")
	_nSaldo := U_xSldPrd3(M->UA__FILIAL,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),"ZZZ"," "," "," ",Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]))
Else
	_nSaldo := U_xSldProd(M->UA__FILIAL,_cProd,GDFIELDGET("UB_LOCAL"))
EndIf

If _nSaldo < 0
    _nSaldo := 0
EndIf

Return _nSaldo