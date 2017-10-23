USER FUNCTION MT103FIM()

Local nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
Local nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE
Local cQuery

     DbselectArea("SE2")
     DbSetOrder(6)
     Dbseek(E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM)
     While !SE2->(EOF()) .AND.;
           SE2->E2_FILIAL+SE2->E2_FORNECE+SE2->E2_LOJA+SE2->E2_PREFIXO+SE2->E2_NUM==SF1->F1_FILIAL+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
          If RecLock("SE2",.F.)
               //SE2->E2_HIST := _cHist //Grava historico do contas a pagar
               If nOpcao==3 .And. nConfirma==1 
                    //_CFLAG := .F.
                    SE2->E2_HIST := SUBSTR(U_HISTCOM(SE2->E2_FILIAL,SE2->E2_NUM, SE2->E2_PREFIXO,SE2->E2_FORNECE,SE2->E2_LOJA),1,80)
                    SE2->E2_DATALIB := DDATABASE
                    SE2->E2_USUALIB := cUserName
               EndIf
               MSUnlock()
          EndIf
          SE2->(DBSKIP())
     EndDo              
 
	
	
	If INCLUI  
	
		cQuery := " UPDATE "+RetSqlName("SE2")+" SET E2_DATALIB = E2_EMISSAO"
		cQuery += " WHERE E2_FILIAL = '" + xFilial("SE2") + "'  AND E2_NUM = '" + cNFiscal + "'"                       
		cQuery += " AND E2_TIPO NOT IN('NF ', 'PA ') AND E2_DATALIB = ' ' AND E2_TITPAI LIKE '" + SF1->F1_SERIE + cNFiscal + "%'"
		cQuery += " AND E2_TITPAI LIKE '%" + cA100For + cLoja + "%' AND D_E_L_E_T_ = ' '"
		
		TcSqlExec(cQuery)                                           
	Endif	                		 
     
RETURN