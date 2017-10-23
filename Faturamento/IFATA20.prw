#Include "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IFATA20  �Autor  �Roberto Marques-Anadi� Data �  11/04/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �   Rotina verifica a quantidade de lojas de um cliente      ���
���          �   se for maior que 1 retorna falso ou 1 retorna verdadeiro ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IFATA20(cCli)
	Local mSQL	:= ""
	Local iRet  := .T.
	Local _aArea := getArea()

	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif

	mSQL := "SELECT COUNT(A1_COD)AS QUANT FROM "+RetSqlName("SA1")+" SA1 "
	mSQL += " WHERE  A1_FILIAL='"+xFILIAL("SA1")+"' AND D_E_L_E_T_<>'*' "
	mSQL += " AND A1_COD='"+cCLI+"'"	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
	
	IF TMP->(!Eof())
		IF  TMP->QUANT > 1
			iRet := .F.
			
		Else
			iRet := .T.
		Endif
	Endif
	
    TMP->(dbCloseArea())

	restarea(_aArea)

Return (iRet)