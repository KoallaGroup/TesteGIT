User Function FA050FIN
Local cQuery

	cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_DATALIB = E2_EMISSAO"
	cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  AND E2_NUM = '" + M->E2_NUM + "'"
	cQuery += " AND E2_TIPO NOT IN('NF ', 'PA ') AND E2_DATALIB = ' ' AND E2_TITPAI LIKE '" + M->E2_PREFIXO + M->E2_NUM + "%'"
	cQuery += " AND E2_TITPAI LIKE '%" + M->E2_FORNECE + M->E2_LOJA + "%' AND D_E_L_E_T_ = ' '"
		
	TcSqlExec(cQuery)                                            
	
	//If FUNNAME() $ "GFEA070/GPEM670/" 
		cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_DATALIB = E2_EMISSAO"
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  AND E2_NUM = '" + M->E2_NUM + "'"
		cQuery += " AND E2_TIPO NOT IN('NF ', 'PA ') AND E2_DATALIB = ' '"
		cQuery += " AND E2_ORIGEM IN('TOTVSGFE','GPEM670','SIGAEIC') AND D_E_L_E_T_ = ' '"   
		
		TcSqlExec(cQuery) 
	//Endif

If SE2->E2_TIPO = "RC" 
	RecLock("SE2",.F.) 
	SE2->E2_DATALIB := Date()
	MsUnlock("SE2")
EndIf



Return