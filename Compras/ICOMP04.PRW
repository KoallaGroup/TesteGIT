#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ICOMP04   �Autor  �Alexandre Caetano   � Data �  17/Nov/2014���
�������������������������������������������������������������������������͹��
���Desc.     � N�o permite entrada de codigos de produtos de fornecedores ���
���          � iguais, independente do fornecedor/loja                    ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ICOMP04()
Local lRet	:= .t.
Local aArea	:= GetArea()

//SA5->( dbSetOrder(5) )                             
//if SA5->( dbSeek( xFilial("SA5") + M->A5_CODPRF ) ) .And. SA5->A5_FORNECE != GDFIELDGET("A5_FORNECE")  

SA5->( dbSetOrder(14) )                             
if SA5->( dbSeek( xFilial("SA5") + GDFIELDGET("A5_FORNECE") + GDFIELDGET("A5_LOJA") + M->A5_CODPRF ) ) .And. SA5->A5_PRODUTO != M->A5_PRODUTO  
	Help(Nil,Nil,"ATENCAO", Nil,"C�digo j� cadastrado para o produto " + Alltrim(SA5->A5_PRODUTO) + "-" + Alltrim(SA5->A5_NOMPROD),1,0)	
	lRet	:= .f.
Endif

RestArea(aArea)
Return(lRet)