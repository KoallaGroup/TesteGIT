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
User Function VLDTBPRECO()       
             
Local cProduto	:= aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})]  
 
Local cTabela	:= M->C5_TABELA
Local lRetorno 	:= .T.   //Inicia com verdadeiro.
Local _cParam := ""

DbSelectArea("DA1")
DbSetOrder(2)
DbSeek(xFilial("DA1")+ cProduto + cTabela)

 IF (DA1->(!Found())) .and. (M->C5_TIPO = "N") .and. (Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRTRIB") <> "039") .and.;
 	 (Posicione("SB1",1,xFilial("SB1")+cProduto,"B1_GRTRIB") <> "040")  .and. aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL"})] = '01'
 	aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})] := 0
 	aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRUNIT"})] := 0
    lRetorno := .F.
    MsgAlert("O PRODUTO NAO POSSUI TABELA DE PRECO, FAVOR VERIFICAR O CODIGO DO PRODUTO!")
/*    
 ElseIf DA1->DA1_PRCVEN < aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRCVEN"})]
 	MsgAlert("Valor informado � superior ao valor constante na tabela de pre�o. Favor verificar.")
 	lRetorno := .F. */  
 	

 	
 ENDIF    
//U_FCLOSEAREA("DA1") 
//DA1->(DbCloseArea())
//Alert(cValtoChar(DA1->DA1_PRCVEN))  






Return(lRetorno)