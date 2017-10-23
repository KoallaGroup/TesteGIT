#Include 'Protheus.ch' 

Static __aZ07 := {}

//-------------------------------------------------------------------
/*/{Protheus.doc} ETMK011
Relacionamento Itens Chamados x Produtos

@author Ivan Morelatto Toré
@since 03/09/2014
@version P11

/*/
//-------------------------------------------------------------------
User Function ETMK011

Local aAreaAtu := GetArea()

Local _oDlg
//Local _oGetZ07
Local _nGetD     := 0
Local _aColsZ07  := {}
Local _aHeadZ07  := {}
Local _aRegsZ07  := {}
Local _aCriaCols := {}
Local _lOk       := .F.

Local _cCodADE	 := M->ADE_CODIGO
Local _cItADF	 := GDFieldGet( "ADF_ITEM", oGetD:nAt, Nil, oGetD:aHeader, oGetD:aCols )

Private _oGetZ07 

If !Empty( __aZ07 )
	If Len( __aZ07 ) >= Len( oGetD:aCols ) .and. Len( __aZ07[oGetD:nAt] ) > 0
		_aHeadZ07 := aClone( __aZ07[oGetD:nAt][1] )
		_aColsZ07 := aClone( __aZ07[oGetD:nAt][2] )
		_aRegsZ07 := aClone( __aZ07[oGetD:nAt][3] )
	Else
		While Len( __aZ07 ) < Len( oGetD:aCols )
			aAdd( __aZ07, {} )
		End

		_aHeadZ07 := aClone( APBuildHeader( "Z07", { "Z07_CODIGO", "Z07_ITEM" } ) )

		dbSelectArea("Z07")
		dbSetOrder(1)
	
		If Inclui 
			_aCriaCols := aClone( A610CriaCols("Z07", _aHeadZ07, xFilial("Z07") + _cCodADE + _cItADF, { || .F. } ) )
			_aColsZ07  := aClone(_aCriaCols[1])
			_aRegsZ07  := {}
		Else
			_aCriaCols := aClone( A610CriaCols("Z07", _aHeadZ07, xFilial("Z07") + _cCodADE + _cItADF, { || Z07->( Z07_FILIAL + Z07_CODIGO + Z07_ITEM ) == xFilial("Z07") + _cCodADE + _cItADF } ) )
			_aColsZ07 := aClone(_aCriaCols[1])
			_aRegsZ07 := aClone(_aCriaCols[2])
		EndIf

	Endif
Else
	While Len( __aZ07 ) < Len( oGetD:aCols )
		aAdd( __aZ07, {} )
	End

	_aHeadZ07 := aClone( APBuildHeader( "Z07", { "Z07_CODIGO", "Z07_ITEM" } ) )

	dbSelectArea("Z07")
	dbSetOrder(1)

	If Inclui 
		_aCriaCols := aClone( A610CriaCols("Z07", _aHeadZ07, xFilial("Z07") + _cCodADE + _cItADF, { || .F. } ) )
		_aColsZ07  := aClone(_aCriaCols[1])
		_aRegsZ07  := {}
	Else
		_aCriaCols := aClone( A610CriaCols("Z07", _aHeadZ07, xFilial("Z07") + _cCodADE + _cItADF, { || Z07->( Z07_FILIAL + Z07_CODIGO + Z07_ITEM ) == xFilial("Z07") + _cCodADE + _cItADF } ) )
		_aColsZ07 := aClone(_aCriaCols[1])
		_aRegsZ07 := aClone(_aCriaCols[2])
	EndIf

Endif

DEFINE MSDIALOG _oDlg TITLE "Produtos" FROM 000,000 TO 400,600 PIXEL

If Inclui .Or. Altera
	_nGetD := GD_INSERT+GD_DELETE+GD_UPDATE
EndIf

_oGetZ07 := MsNewGetDados():New(500,500,500,500,_nGetD,,,,,,9999,,,/*"U_AC3RecSl()"*/,_oDlg,_aHeadZ07,_aColsZ07)

AlignObject( _oDlg ,{ _oGetZ07:oBrowse }, 1, 1, { 500 } )

//ACTIVATE MSDIALOG _oDlg CENTERED ON INIT ( EnchoiceBar( _oDlg, { || If( _lOk := _oGetZ07:TudoOK(), _oDlg:End(), Nil ) }, { || _oDlg:End() } ) ) 
ACTIVATE MSDIALOG _oDlg CENTERED ON INIT ( EnchoiceBar( _oDlg, { || If( _lOk := ET1AtZ07VAL("OK"), _oDlg:End(), Nil ) }, { || If( _lOk := ET1AtZ07VAL("END"), _oDlg:End(), Nil ) } ) )

If _lOk
	__aZ07[oGetD:nAt]    := Array(3)
	__aZ07[oGetD:nAt][1] := aClone( _oGetZ07:aHeader )
	__aZ07[oGetD:nAt][2] := aClone( _oGetZ07:aCols )
	__aZ07[oGetD:nAt][3] := aClone( _aRegsZ07 )
EndIf

RestArea( aAreaAtu )

Return .t.

Static Function ET1AtZ07VAL(_cTipo)
Local _lRet := .t., _lOk := .t.
Local nCntZ07  := 0
Local _nPCod  := ASCAN(_oGetZ07:aHeader, { |x| AllTrim(x[2]) == "Z07_CODSB1"})
Local _nPQtd  := ASCAN(_oGetZ07:aHeader, { |x| AllTrim(x[2]) == "Z07_QUANT" })

If (!Inclui .And. !Altera)
    Return .t.
EndIf

If _cTipo == "END" .And. Alltrim(M->ADE_CODSU9) $ Alltrim(GetMv("MV__SU9Z07"))
    Help( Nil, Nil, "Z07_OBRIGAT", Nil, "O preenchimento do produto avariado é obrigatório ", 1, 0 )
    Return .f.
EndIf

For nCntZ07 := 1 To Len(_oGetZ07:aCols)

    If !(_oGetZ07:aCols[nCntZ07][Len(_oGetZ07:aHeader) + 1])
        If (Empty(_oGetZ07:aCols[nCntZ07][_nPCod]) .And. _oGetZ07:aCols[nCntZ07][_nPQtd] > 0) .Or.; 
          (!Empty(_oGetZ07:aCols[nCntZ07][_nPCod]) .And. _oGetZ07:aCols[nCntZ07][_nPQtd] <= 0)  
            _lOK := .f.
            Exit
        ElseIf (Empty(_oGetZ07:aCols[nCntZ07][_nPCod]) .And. _oGetZ07:aCols[nCntZ07][_nPQtd] <= 0 .And.; 
                Alltrim(M->ADE_CODSU9) $ Alltrim(GetMv("MV__SU9Z07")))
            _lOK := .f.
            Exit
        EndIf
    EndIf

Next nCntZ07

If !_lOK
    Help( Nil, Nil, "DANIFICADO", Nil, "O codigo do produto e/ou quantidade devem ser informados, favor verificar.", 1, 0 )
    _lRet := .f.  
EndIf

Return _lRet


//Atualiza a variavel Z07 
User Function ET1AtZ07()
Local _cEncer	:= "" 
Local _nPosAca	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ADF_CODSUQ"	})
Local _nPosSta	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ADE__STAT"	})
Local lRetFun := TK510Fecha() 

If lRetFun
	GravaZ07()
Endif

/*If INCLUI 
	If !Empty(Alltrim(M->ADE__CLI)) 
		Alert("Cliente preenchido, favor finalizar o atendimento!") 
	    lRetFun := .F.
	EndIf  
EndIf
*/

Return lRetFun

// Grava a variavel Z07
Static Function GravaZ07()

Local aAreaAtu := GetArea()

Local nCntZ07  := 0
Local aColsZ07 := {}
Local aHeadZ07 := {}
Local aRegsZ07 := {}

Local nItem    := 0

For nCntZ07 := 1 To Len( __aZ07 )

	If Len( __aZ07[nCntZ07] ) == 3
		
		aHeadZ07 := aClone( __aZ07[nCntZ07][1] )
		aColsZ07 := aClone( __aZ07[nCntZ07][2] )
		aRegsZ07 := aClone( __aZ07[nCntZ07][3] )
		
		For nItem := 1 To Len( aRegsZ07 )
			Z07->( dbGoTo( aRegsZ07[nItem] ) )
			RecLock( "Z07", .F. )
			Z07->( dbDelete() )
			Z07->( MsUnLock() )
		Next nItem
		
		If !GDDeleted( nCntZ07, oGetD:aHeader, oGetD:aCols )

			dbSelectArea( "Z07" )
			dbSetOrder(1)
			A610GravaCol( aColsZ07, aHeadZ07, {}, "Z07", { || Z07->Z07_FILIAL := xFilial("Z07"),;
															  Z07->Z07_CODIGO := M->ADE_CODIGO,;
															  Z07->Z07_ITEM   := GDFieldGet( "ADF_ITEM", nCntZ07, Nil, oGetD:aHeader, oGetD:aCols ) } )
			
	
		Endif
	
	Endif

Next nCntZ07

__aZ07 := {}

RestArea( aAreaAtu )

Return