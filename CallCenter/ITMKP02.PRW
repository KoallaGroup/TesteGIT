#Include 'Protheus.ch' 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ITMKP02   �Autor  �Alexandre Caetano   � Data �  17/Nov/2014���
�������������������������������������������������������������������������͹��
���Desc.     � Valida produto selecionado quanto a ser ativo              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ITMKP02()
Local lRet		:= .t.
Local aArea		:= GetArea()
Local _cAtivo	:= Posicione("SB1" , 1 , xFilial("SB1") + M->UB_PRODUTO, "B1_ATIVO")

If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)
	Return .t.
EndIf

If _cAtivo <> 'S'
	Help( Nil, Nil, "PRDINAT", Nil, "Produto selecionado n�o esta ativo !         " + Chr(13) +;
	                             "Digite um produto v�lido para continuar a opera��o.", 1, 0 )	
	lRet := .f.
Endif                 

If SB1->B1__SEGISP <> M->UA__SEGISP .and. Alltrim(SB1->B1__SEGISP) <> "0"
	Help( Nil, Nil, "PRDSEGTO", Nil, "Produto n�o pertence ao seu segmento. !" + Chr(13) +;
	                             "  Digite um produto v�lido para continuar a opera��o.   ", 1, 0 )	
	lRet := .f.
Endif
               
Z15->( dbSetOrder(1) )
if Z15->( dbSeek ( xFilial("Z15") + M->UB_PRODUTO ) )  

	if Z15->Z15_TPINVE = "2" // CORTE	
		Help( Nil, Nil, "BLQINV", Nil, "Produto n�o pode ser utilizado, bloqueio de invent�rio !" + Chr(13) +;
	                                 "  Digite um produto v�lido para continuar a opera��o.   ", 1, 0 )	
		lRet	:= .f.
	Endif
Endif 

RestArea(aArea)

Return(lRet)