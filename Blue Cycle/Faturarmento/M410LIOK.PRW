/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  M410LIOK   �Autor  � ALEXANDRE J. PASCO � Data �  15/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da inclusao do item do pedido venda para  ���a
���          � validar se esta sendo informar o campo ID e Lote do produto���
���          � que controla lote 										   ��
�������������������������������������������������������������������������͹��
���Uso       � PEDIDO DE VENDAS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/            
User function M410LIOK()
Local cLocal    := aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL"})] 


lRetorno := U_VLDTBPRECO()

_cParam := "MV_REST"+cLocal 

If RetCodUsr() $ AllTrim(GetMv(_cParam))
   
    MsgAlert("Usu�rio sem permiss�o para movimentar este armaz�m!")

 	lRetorno := .F. 
 	
EndIf              


Return(lRetorno)