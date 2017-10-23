#Include 'Protheus.ch' 

//-------------------------------------------------------------------
/*/{Protheus.doc} ETMK010
Função para replicar a ocorrencia da ADE para ADF

@author Ivan Morelatto Toré
@since 03/09/2014
@version P11

/*/
//-------------------------------------------------------------------
User Function ETMK010

Local aAreaAtu := GetArea()
Local aAreaSU9 := SU9->( GetArea() )
Local cOcorren := &( ReadVar() )
Local nCntFor  := 0, _cIncid := ""
Local lRetFun  := .T.

If(Type("oGetD:aCols") == "A".AND. Len(oGetD:aCols) > 0)

	&( "M->ADF_CODSU9" ) := cOcorren 
	lRetFun := TK510OcoTmk()
	
	If lRetFun 
	
		SU9->( dbSetOrder( 2 ) )
		SU9->( dbSeek( xFilial( "SU9" ) + cOcorren ) )
		
		For nCntFor := 1 To Len( oGetD:aCols )
			GDFieldPut( "ADF_CODSU9", cOcorren    , nCntFor, oGetD:aHeader, oGetD:aCols )
			GDFieldPut( "ADF_CODSU9", cOcorren    , nCntFor, aHeader, aCols )
			
			GDFieldPut( "ADF_NMSU9" , SU9->U9_DESC, nCntFor, oGetD:aHeader, oGetD:aCols )
			GDFieldPut( "ADF_NMSU9" , SU9->U9_DESC, nCntFor, aHeader, aCols )
			
			If nCntFor == 1
                GDFieldPut( "ADF_OBS" , M->ADE_INCIDE, nCntFor, oGetD:aHeader, oGetD:aCols )
                GDFieldPut( "ADF_OBS" , M->ADE_INCIDE, nCntFor, aHeader, aCols )			
			EndIf
			
		Next nCntFor
		
	Endif
	
	oGetD:oBrowse:Refresh()
EndIf


RestArea( aAreaSU9 )
RestArea( aAreaAtu )

Return lRetFun