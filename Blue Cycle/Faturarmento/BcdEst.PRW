#include "protheus.ch"  
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  BcTesInt �Autor  � VALDEMIR DO CARMO    � Data �  10/08/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de entrada da inclusao do item do pedido venda para  ���
���          � para retornar a TES automaticamente    					  ���
���          � que controla lote 										   ��
�������������������������������������������������������������������������͹��
���Uso       � PEDIDO DE VENDAS                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/            
User Function BcdEst(cOper)       
             
Local cProduto	:= ""
Local cLocProd  := ""
Local cSaldoEst := 0


If cOper = "1"  
	cProduto	:= ACOLS[LEN(ACOLS)][ASCAN(AHEADER,{|X|ALLTRIM(X[2])=='C6_PRODUTO'})] 
	cLocProd  	:= ACOLS[LEN(ACOLS)][ASCAN(AHEADER,{|X|ALLTRIM(X[2])=='C6_LOCAL'})]
Else
	cProduto	:= aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})] 
	cLocProd  := aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_LOCAL"})] 
EndIf


    cSaldoEst := Posicione("SB2",1,xFilial("SB2")+cProduto+cLocProd,"B2_QATU-B2_RESERVA")      
    


Return(cSaldoEst)   

                                 
User Function PosEst()
Local _cRet := "" 


_cRet := 'POSICIONE("SB2",1,XFILIAL("SB2")+ACOLS[LEN(ACOLS)][ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="C6_PRODUTO"})]+ACOLS[LEN(ACOLS)][ASCAN(AHEADER,{|X|ALLTRIM(X[2])=="C6_LOCAL"})],"B2_QATU-B2_RESERVA")'  



Return(_cRet)
