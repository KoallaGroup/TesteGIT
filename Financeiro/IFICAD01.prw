#INCLUDE "RWMAKE.CH"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � IFICAD01 � Autor � Rafael Domingues - ANADI � Data � 24/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de amarracao natureza banco x natureza financeira    ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFICAD01()                                                    ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/

User Function IFICAD01()


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "Z28"

dbSelectArea("Z28")
dbSetOrder(1)

AxCadastro(cString,"Amarracao Natureza Banco x Natureza Financeira",cVldExc,cVldAlt)

Return
