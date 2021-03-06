#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �IFATG02   � Autor � Anderson Goncalves � Data �  08/05/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Retorno da CFOP                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Isapa                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IFATG02()

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//����������������������������������������������������������������������� 
Local cRet		:= ""
Local aArea		:= GetArea()
Local aAreaA1	:= SA1->(GetArea())
Local aAreaC5	:= SC5->(GetArea())
Local aAreaC6	:= SC6->(GetArea()) 
Local aDadCfo	:= {} 
Local cCFPO		:= ""

//���������������������������������������������������������������������Ŀ
//� Posiciona os registros                                              �
//����������������������������������������������������������������������� 
dbSelectArea("SF4")
SF4->(dbSetOrder(1))
SF4->(dbSeek(xFilial("SF4")+M->C6_TES)) 

dbSelectArea("SA1")
SA1->(dbSetOrder(1))
SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+C5_LOJACLI ))

aAdd( aDadCfo, { "OPERNF", If(M->C5_TIPO $ "NCIP","S","N") })	// Tipo de Opera��o (E=Entrada, S=Sa�da)
aAdd( aDadCfo, { "TPCLIFOR", SA1->A1_TIPO })					// Tipo de Cliente (RSPX)
aAdd( aDadCfo, { "UFORIGEM", SuperGetMV("MV_ESTADO") })			// Estado do emissor da nota
aAdd( aDadCfo, { "UFDEST", SA1->A1_EST })						// Estado de Destino
aAdd( aDadCfo, { "TPCOMP", "F" })								// Tipo de Complemento (F=Frete, D=Despesa Importa��o)
aAdd( aDadCfo, { "INSCR", SA1->A1_INSCR })						// Inscri��o Estadual
cCFOP	:= MaFisCfo(,SF4->F4_CF,aDadCfo)   

RestArea(aArea)
RestArea(aAreaA1)
RestArea(aAreaC5)
RestArea(aAreaC6)

Return(cCFPO)
