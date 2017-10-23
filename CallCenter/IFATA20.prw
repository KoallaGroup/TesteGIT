#Include "PROTHEUS.CH"

User Function IFATA20(cCli)
	Local mSQL	:= ""
	Local iRet  := .T.
	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif

	mSQL := "SELECT COUNT(A1_COD)QUANT FROM "+RetSqlName("SA1")+" SA1 "
	mSQL += " WHERE  A1_FILIAL='"+xFILIAL("SA1")+"' AND D_E_L_E_T_<>'*' "
	mSQL += " A1_COD='"+cCLI+"'"	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
	
	IF TMP->(!Eof())
		IF  TMP->QUANT > 1
			iRet := .F.
			Alert("TEM + 1")
		Else
			iRet := .T.
			Alert("TEM 1")
		Endif
	Endif
	
    TMP->(dbCloseArea())

	

Return (iRet)