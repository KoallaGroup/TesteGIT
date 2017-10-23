#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IGENM16   �Autor  �Alexandre Caetano   � Data �  17/Nov/2014���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna a posi��o do campo no aHeader                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Exclusivo ISAPA                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IGENM16(PCampo)
Local nPosFor	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_FORNECE" })  
Local nPosLoj	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZL_LOJA"    })  
  
            
                                                                                                  
cRet := xFilial("SB1") +      avKey( GDFIELDGET("ZL_PRODFOR") ,"A5_CODPRF" )   +;
        iif( Empty(aCols[n,nPosFor]),"",avKey(aCols[n,nPosFor],"A5_FORNECE") ) +;
        iif( Empty(aCols[n,nPosLoj]),"",avKey(aCols[n,nPosLoj],"A5_LOJA"   ) )

Return(cRet)