#include "protheus.ch"
#include "topconn.ch"

Static cEol := Chr( 13 ) + Chr( 10 )

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : A100DEL	 		  		| 	Agosto de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para verificar se é possível a exclusão de NF de Entrada	  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function A100DEL()

	local _aArea 	:= getArea()
	local _cNumero 	:= SF1->F1_DOC
	local _cSerie   := SF1->F1_SERIE                         
	local _cFornece := SF1->F1_FORNECE
	local _cLoja    := SF1->F1_LOJA
	local _lValid 	:= .T.

	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlname("SD1") + " SD1 "
	_cQuery += "WHERE D1_FILIAL = '" + SF1->F1_FILIAL  + "' "
	_cQuery += "  AND D1_DOC = '" + SF1->F1_DOC +  "' "
	_cQuery += "  AND D1_SERIE = '" + SF1->F1_SERIE +  "' "
	_cQuery += "  AND D1_FORNECE = '" + SF1->F1_FORNECE +  "' "
	_cQuery += "  AND D1_LOJA = '" + SF1->F1_LOJA +  "' "
	_cQuery += "  AND D_E_L_E_T_ = ' ' "

	if(select("TMPSD1") > 0)
		TMPSD1->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPSD1"

	do while ! TMPSD1->(eof())

		_cCod := TMPSD1->D1_COD

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + SD1->D1_TES)
		
		if SF4->F4_ESTOQUE == "S"
			   	
			dbSelectArea("Z12")  
			dbSetOrder(1)
			
			if dbSeek(xFilial("Z12")+_cNumero+_cSerie+_cFornece+_cLoja+_cCod)
				if Z12->Z12_SALDO <> Z12->Z12_QUANT
					msgAlert ("Esta nota deverá ser relançada por que já possui ítens movimentados no Controle de PEPS !!")
					exit
				endif
			endif
		endif        
		
		TMPSD1->(dbSkip())
	enddo
					
	if !AtIsRotina("A140ESTCLA") //Se estorno de classificação, permite processamento - Jorge H - Maio/2015
        
		// validação de Ivan Morelato		
		cQuery := "SELECT COUNT(*) QTDSZW " + cEol
		cQuery += "  FROM " + RetSQLName( "SZW" ) + cEol
		cQuery += " WHERE ZW_FILIAL  = '" + xFilial( "SZW" ) + "' " + cEol
		cQuery += "   AND ZW_PROIMP  = '" + SF1->F1__PROIMP + "' " + cEol
		cQuery += "   AND D_E_L_E_T_ = ' ' " + cEol
		
		If Select( "TMP_SZW" ) > 0
			TMP_SZW->( dbCloseArea() )
		EndIf
		
		dbUseArea( .T., "TOPCONN", TCGenQry( Nil, Nil, cQuery ), "TMP_SZW", .T., .F. )
		
		lRetFun := TMP_SZW->QTDSZW == 0
		
		TMP_SZW->( dbCloseArea() ) 
		 
		If !lRetFun
			Help( Nil, Nil, "Help", Nil, "Não é possivel excluir essa nota pois o processo de importação " + AllTrim( SF1->F1__PROIMP ) + " está em Crossdocking.", 1, 0 )
			_lValid := .F.
		Endif                        
		
		// fim de validação do Ivan Morelato		
	endif
				
	restarea(_aArea)
	
return _lValid