
#INCLUDE "PROTHEUS.CH"
  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITMKA33   �Autor  �Roberto Marques-Anadi�Data �  11/05/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION ITMKA33()
	Local mSQL  := "" 
	local iRet  := .T.
	Local _aArea := getArea()

	DbSelectArea("SA1") 
   	DbSetOrder(1)
   	DbSeek(xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,.T.)
	   
	mSQL := " SELECT * "
	mSQL += " FROM "+RetSqlName("SZJ")+" SZJ "
	mSQL += " WHERE ZJ_TRANSP='"+M->UA_TRANSP+"' AND ZJ_REGIAO ='"+SA1->A1__REGTRP+"' "
		
	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif
		
		
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() ) 	
	If TMP->(!Eof())
		iRet := .T.
		M->UA__FTCONV :="1"
		M->UA_TPFRETE :="F" 
	Else
		M->UA_TPFRETE := posicione("SA4",1,xFilial("SA4")+M->UA_TRANSP,"A4__TPFRET")    	
	Endif	

	restarea(_aArea)

Return()