/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  VLDTBPRECO �Autor  � ALEXANDRE J. PASCO � Data �  15/02/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da inclusao do item do pedido venda para  ���
���          � validar se esta sendo informar o campo ID e Lote do produto���
���          � que controla lote 										   ��
�������������������������������������������������������������������������͹��
���Uso       � PEDIDO DE VENDAS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/            
User Function VLDVDI()       
             

Local lRetorno 	:= .T.   //Inicia com verdadeiro.


If (!Empty(M->C5_VEND2)) .and. (M->C5_VEND2 <> Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND2")) .and. !RetCodUsr() $ AllTrim(GetMv("MV_ALTVEND"))

    
    
    MsgAlert("Usu�rio sem permiss�o para alterar o c�digo do VDI!")
/*    
 ElseIf DA1->DA1_PRCVEN < aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})]
 	MsgAlert("Valor informado � superior ao valor constante na tabela de pre�o. Favor verificar.")
 	*/
 	lRetorno := .F. 
 	
ENDIF


Return(lRetorno)    





User Function VLDVDE()       
             

Local lRetorno 	:= .T.   //Inicia com verdadeiro.


If (!Empty(M->C5_VEND1)) .and. (M->C5_VEND1 <> Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND")) .and. !RetCodUsr() $ AllTrim(GetMv("MV_ALTVEND"))

    
    
    MsgAlert("Usu�rio sem permiss�o para alterar o c�digo do VDE!")
/*    
 ElseIf DA1->DA1_PRCVEN < aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})]
 	MsgAlert("Valor informado � superior ao valor constante na tabela de pre�o. Favor verificar.")
 	*/
 	lRetorno := .F. 
 	
ENDIF


Return(lRetorno)



User Function VLDPRC()       
             

Local lRetorno 	:= .T.   //Inicia com verdadeiro.


//If ( aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})] <> Posicione("DA1",1,xFilial("DA1")+M->C5_TABELA+aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})],"DA1_PRCVEN") and. !RetCodUsr() $ AllTrim(GetMv("MV_ALTVEND"))

    
    
    MsgAlert("Usu�rio sem permiss�o para alterar o valor do produto!")
/*    
 ElseIf DA1->DA1_PRCVEN < aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})]
 	MsgAlert("Valor informado � superior ao valor constante na tabela de pre�o. Favor verificar.")
 	*/
 	lRetorno := .F. 
 	
//ENDIF


Return(lRetorno)




User Function VLDFRET()       
             

Local lRetorno 	:= .T.   //Inicia com verdadeiro.




If M->C5_TRANSP $ AllTrim(GetMv("MV_TRFTAE")) .And. ! Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST") $ AllTrim(GetMv("MV_ESTFRET"))

    
    
    MsgAlert("Cliente localizado em um Estado onde o frete a�reo n�o est� autorizado. Favor trocar a transportadora!")
/*    
 ElseIf DA1->DA1_PRCVEN < aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})]
 	MsgAlert("Valor informado � superior ao valor constante na tabela de pre�o. Favor verificar.")
 	*/
 	lRetorno := .F. 
 	
ENDIF


Return(lRetorno) 