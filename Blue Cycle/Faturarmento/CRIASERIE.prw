#INCLUDE "rwmake.ch"



User Function CRIASERIE


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZX"

dbSelectArea("SZX")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de S�ries",cVldExc,cVldAlt)

Return
