User Function AVFLUXO()
	Local cQuery
	
	IF PARAMIXB = "VALOR_TIT_PRE_POS"   
		cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_DATALIB = E2_EMISSAO"		
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'"
		cQuery += " AND E2_TIPO NOT IN('NF ', 'PA ', 'PR ') AND E2_DATALIB = ' '
		cQuery += " AND E2_PREFIXO = 'EIC' AND D_E_L_E_T_ = ' '  
	
		TcSqlExec(cQuery)
	ENDIF

Return .T.