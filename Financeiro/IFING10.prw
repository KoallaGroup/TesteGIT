#INCLUDE "RWMAKE.CH"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � IFING10  � Autor � Rafael Domingues - ANADI � Data � 26/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Desabilita alteracao E2_PREFIXO para usuarios do parametro    ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � U_IFING10()                                                   ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

User Function IFING10()

Local lRet  := .F.

If RetCodUsr() $ GetMv("MV__USRGPE")
	lRet := .F.
Else
	lRet := .T.
EndIf

Return(lRet)