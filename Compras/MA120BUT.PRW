#include "rwmake.ch"        
#Include "Protheus.ch"
#define CRLF Chr(13)+Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA120BUT  �Autor  �Juscelino Alves dos Santos�Data �24/07/14���
�������������������������������������������������������������������������͹��
���Desc.     � Adicionar Butao p/ Pedido de Compra                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Compras                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function MA120BUT()
Local _aBut	:= {}
       
SetKey( VK_F9 , { || U_ICOMC05() } )

aAdd(_aBut, {"NOTE", {|| U_ICOMA09()}, "Sugest�o de Compra"  })
aAdd(_aBut, {"NOTE", {|| U_ICOMC05()}, "Forn. X Grp. Cota��o"}) 

Return _aBut