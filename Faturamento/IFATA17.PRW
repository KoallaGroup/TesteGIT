#INCLUDE "PROTHEUS.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � Ifata17 |Autor  � Roberto Marques  	 � Data � 09/09/2014  ���
�������������������������������������������������������������������������͹��
���Desc.     � TABELA DE Regra de Tabela de preco 		  			  			  ���
���          � seguindo as regras da tabela de pre�o					        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ISAPA                                                  	  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function IFATA17()

dbSelectArea("Z13")
dbSetOrder(1)

Set Filter to Z13_SEGMET == Posicione("SZ1",1,xFilial("SZ1")+__cUserId,"Z1_SEGISP")

	axCadastro("Z13")

Return

// DATA DE ALTERA��O
User Function 	IFATA17A()                                                                                                                     
	If lAltera 
		M->Z13_DTALT := dDatabase
 	Endif	
Return  