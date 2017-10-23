#Include 'Protheus.ch'
#include "topconn.ch"

//-------------------------------------------------------------------
/*/{Protheus.doc} ETMK012
Trocar o status do atendimento na tela do service desk

@author Ivan Morelatto Toré
@since 30/01/2015
@version P11

/*/
//-------------------------------------------------------------------
User Function ETMK012

Local nAt      := oTk510Tela:oGetDados:nAt
Local nChkBox  := aScan( oTk510Tela:oGetDados:aHeader, { |x| AllTrim( Upper( x[2] ) ) == "CHECKBOX" } )
Local nSemaf   := aScan( oTk510Tela:oGetDados:aHeader, { |x| AllTrim( Upper( x[2] ) ) == "SEMAFORO" } )
Local nCodADE  := aScan( oTk510Tela:oGetDados:aHeader, { |x| AllTrim( Upper( x[2] ) ) == "ADE_CODIGO" } )
Local nStatus  := aScan( oTk510Tela:oGetDados:aHeader, { |x| AllTrim( Upper( x[2] ) ) == "ADE__STAT" } )
Local cChkBox  := ""
Local cCodADE  := ""
Local cStatus  := ""
Local nCor     := 0
Local _cQuery  := ""
Local cSU7     := ""
Local cGrpADE  := "" 
Local cFilOrie := ""

If nAt > 0 .and. nChkBox > 0 .and. nSemaf > 0.and. nCodADE > 0 .and. nStatus > 0
	
	cChkBox := oTk510Tela:oGetDados:aCols[nAt][nChkBox]
	cCodADE := oTk510Tela:oGetDados:aCols[nAt][nCodADE]
	cStatus := oTk510Tela:oGetDados:aCols[nAt][nStatus]
	
	If AllTrim( Upper( cChkBox ) ) == "LBOK" .and. AllTrim( Upper( cStatus ) ) == "ABERTURA"
		
		 oTk510Tela:oGetDados:aCols[nAt][nStatus] := "Recebido"
		 
		 ADE->( dbSetOrder( 1 ) )
		 ADE->( dbSeek( xFilial( "ADE" ) + cCodADE ) )
		 
		//Criacao de linha na ADF para informar status recebido - Rubens Cruz (Fevereiro/2015)
		If Select("TMPADF") > 0
			DbSelectArea("TMPADF")
			DbCloseArea()
		EndIf

		_cQuery := "SELECT ADF.ADF_CODIGO,                       						" + Chr(13)
		_cQuery += "       ADF.ADF_ITEM,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU7,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU0,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_FILORI,                         						" + Chr(13)
		_cQuery += "       ADF.ADF__STATU,                       						" + Chr(13)
		_cQuery += "       ADF.R_E_C_N_O_ AS RECADF              						" + Chr(13)
		_cQuery += "FROM " + RetSqlName("ADF") + " ADF           						" + Chr(13)
		_cQuery += "WHERE ADF.D_E_L_E_T_ = ' '                   						" + Chr(13)
		_cQuery += "      AND ADF.ADF_CODIGO = '" + cCodADE + "' 						"
		TCQUERY _cQuery NEW ALIAS "TMPADF"
		
		DbSelectArea("TMPADF")

		cSU7     := TMPADF->ADF_CODSU7
		cGrpADE  := TMPADF->ADF_CODSU0 
		cFilOrie := TMPADF->ADF_FILORI
		DbSkip()

		If(eof())
			Reclock("ADF",.T.)   
				ADF_FILIAL := xFilial("ADF")	
				ADF_CODIGO := cCodADE
				ADF_ITEM   := strZero(2,TAMSX3("ADF_ITEM")[1])
				ADF_CODSU9 := "TMK001"   
				ADF_CODSU7 := cSU7
				ADF_CODSU0 := cGrpADE
				ADF_CODOBS := ""
				ADF_DATA   := dDataBase
				ADF_HORAF  := Time()
				ADF_HORA   := Time() 
				ADF_FILORI := cFilOrie  
				ADF__STATU := "R"
			MsUnlock()		
		Else
			DbSelectarea("ADF")
			DbGoTo(TMPADF->RECADF)
			Reclock("ADF",.F.)
				ADF->ADF__STATU := "R"
			MsUnlock()		
		EndIf                    
		
		TMPADF->(DbCloseArea())


		 RecLock( "ADE", .F. )
		 ADE->ADE__STAT := "R"
		 ADE->( MsUnLock() )
		 
		 nCor := aScan( oTk510Tela:aCores, { |x| Eval( & ( "{||" + x[1] + "}" ) ) } )
		 
		 If nCor > 0
		 	oTk510Tela:oGetDados:aCols[nAt][nSemaf] := oTk510Tela:aCores[nCor][2]
		 Endif	
		 	
		 oTk510Tela:oGetDados:Refresh()
	
	ElseIf (AllTrim( Upper( cChkBox ) ) == "LBOK")
		cCodADE := oTk510Tela:oGetDados:aCols[nAt][nCodADE]

		ADE->( dbSetOrder( 1 ) )
		ADE->( dbSeek( xFilial( "ADE" ) + cCodADE ) )


		//Criacao de linha na ADF para informar status recebido - Rubens Cruz (Fevereiro/2015)
		If Select("TMPADF") > 0
			DbSelectArea("TMPADF")
			DbCloseArea()
		EndIf

		_cQuery := "SELECT ADF.ADF_CODIGO,                       						" + Chr(13)
		_cQuery += "       ADF.ADF_ITEM,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU7,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_CODSU0,                         						" + Chr(13)
		_cQuery += "       ADF.ADF_FILORI,                         						" + Chr(13)
		_cQuery += "       ADF.ADF__STATU,                       						" + Chr(13)
		_cQuery += "       ADF.R_E_C_N_O_ AS RECADF              						" + Chr(13)
		_cQuery += "FROM " + RetSqlName("ADF") + " ADF           						" + Chr(13)
		_cQuery += "WHERE ADF.D_E_L_E_T_ = ' '                   						" + Chr(13)
		_cQuery += "      AND ADF.ADF__STATU = ' ' 										" + Chr(13)
		_cQuery += "      AND ADF.ADF_CODIGO = '" + cCodADE + "' 						" + Chr(13)
		_cQuery += "ORDER BY ADF.ADF_ITEM DESC											"
		TCQUERY _cQuery NEW ALIAS "TMPADF"

		If(!eof())
			DbSelectArea("ADF")
			DbGoTo(TMPADF->RECADF)
			Reclock("ADF")
				ADF->ADF__STATU := ADE->ADE__STAT
			MsUnlock()		
		EndIf 
		   
		TMPADF->(DbCloseArea())
		
	Endif
	
Endif

Return