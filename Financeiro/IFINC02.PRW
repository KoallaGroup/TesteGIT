#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � IFINC02  � Autor � Rafael Domingues - ANADI � Data � 31/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Tela de Observacao na Consulta de Cliente                     ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFINC02()                                                     ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

User Function IFINC02(CodCli,LojCl)

Private _cCodCli	:= CodCli
Private _cLojCli	:= LojCl
Private _cNomeCli	:= ""
Private _cSequen	:= ""
Private _cObserv	:= ""

DbSelectArea("Z31")
DbSetOrder(1)
If DbSeek(xFilial("Z31")+_cCodCli+_cLojCli)
	
	_cCodCli	:= Z31->Z31_CODCLI
	_cLojCli	:= Z31->Z31_LOJCLI
	_cNomeCli	:= Z31->Z31_NOMECL
	_cSequen	:= Z31->Z31_SEQUEN
	_cObserv	:= Z31->Z31_OBSERV
	
Else
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+_cCodCli+_cLojCli)
	
	_cCodCli	:= SA1->A1_COD
	_cLojCli	:= SA1->A1_LOJA
	_cNomeCli	:= SA1->A1_NOME
	_cSequen	:= "0001"
	_cObserv	:= ""
	
EndIf


SetKey(VK_F4, {|| IFINC02A() })
SetKey(VK_F5, {|| IFINC02B() })

While .T.
	@ 006,042 TO 500,600 DIALOG oDlgMen TITLE OemToAnsi("Observa��o An�lise de Cr�dito")
	
	@ 010,010 Say OemToAnsi("Cliente")
	@ 010,042 Get _cCodCli  Picture PESQPICT("Z31","Z31_CODCLI") Size 050,050 When .F.
	@ 010,100 Get _cNomeCli Picture PESQPICT("Z31","Z31_NOMECL") Size 100,100 When .F.
	
	@ 030,010 Say OemToAnsi("Sequ�ncia")
	@ 030,042 Get _cSequen  Picture PESQPICT("Z31","Z31_SEQUEN") Size 050,050 When .F.
	@ 030,100 Say OemToAnsi("F4-Anterior / F5-Pr�ximo")
	
	@ 050,010 Say OemToAnsi("Observa��o")
	@ 050,042 Get _cObserv Size 200,170  MEMO Object oMemo When .F.
	
	@ 230,100 BUTTON "Incluir" SIZE 35,15 ACTION IFINC02C()
	@ 230,150 BUTTON "Fechar" SIZE 35,15 ACTION Close(oDlgMen)
	
	ACTIVATE DIALOG oDlgMen CENTERED
	Exit
End

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � IFINC02A � Autor � Rafael Domingues - ANADI � Data � 31/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Tecla F4 - Visualiza observacao anterior                      ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFINC02A()                                                    ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

Static Function IFINC02A()

_cSequen := AllTrim( Str( Val( _cSequen ) - 1 ) )
_cSequen := PadL( _cSequen, 4 , "0" )

DbSelectArea("Z31")
DbSetOrder(1)
If DbSeek(xFilial("Z31")+_cCodCli+_cLojCli+_cSequen)
	
	_cCodCli	:= Z31->Z31_CODCLI
	_cLojCli	:= Z31->Z31_LOJCLI
	_cNomeCli	:= Z31->Z31_NOMECL
	_cSequen	:= Z31->Z31_SEQUEN
	_cObserv	:= Z31->Z31_OBSERV
	
	oDlgMen:Refresh()
	
Else
	
	_cSequen := AllTrim( Str( Val( _cSequen ) + 1 ) )
	_cSequen := PadL( _cSequen, 4 , "0" )
	
EndIf

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � IFINC02B � Autor � Rafael Domingues - ANADI � Data � 31/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Tecla F5 - Visualiza proxima observacao                       ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFINC02B()                                                    ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

Static Function IFINC02B()

_cSequen := AllTrim( Str( Val( _cSequen ) + 1 ) )
_cSequen := PadL( _cSequen, 4 , "0" )

DbSelectArea("Z31")
DbSetOrder(1)
If DbSeek(xFilial("Z31")+_cCodCli+_cLojCli+_cSequen)
	
	_cCodCli	:= Z31->Z31_CODCLI
	_cLojCli	:= Z31->Z31_LOJCLI
	_cNomeCli	:= Z31->Z31_NOMECL
	_cSequen	:= Z31->Z31_SEQUEN
	_cObserv	:= Z31->Z31_OBSERV
	
	oDlgMen:Refresh()
	
Else
	
	_cSequen := AllTrim( Str( Val( _cSequen ) - 1 ) )
	_cSequen := PadL( _cSequen, 4 , "0" )
	
EndIf

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � IFINC02C � Autor � Rafael Domingues - ANADI � Data � 31/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Inclusao da observacao                                        ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFINC02C()                                                    ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

Static Function IFINC02C()

DbSelectArea("Z31")
DbSetOrder(1)
If DbSeek(xFilial("Z31")+_cCodCli+_cLojCli+_cSequen)
	
	_cCodCli	:= Z31->Z31_CODCLI
	_cLojCli	:= Z31->Z31_LOJCLI
	_cNomeCli	:= Z31->Z31_NOMECL
	_cObserv	:= ""
	
Else
	
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+_cCodCli+_cLojCli)
	
	_cCodCli	:= SA1->A1_COD
	_cLojCli	:= SA1->A1_LOJA
	_cNomeCli	:= SA1->A1_NOME
	_cObserv	:= ""
	
EndIf

cQuery := " SELECT MAX(Z31_SEQUEN) SEQ FROM "+RetSqlName("Z31")
cQuery += " WHERE Z31_CODCLI = '"+_cCodCli+"' AND Z31_LOJCLI = '"+_cLojCli+"' "
cQuery := ChangeQuery(cQuery)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)

DbSelectArea("TMP")
DbGoTop()

_cSequen	:= PadL(AllTrim(Str( Val(TMP->SEQ ) + 1 ) ), 4 , "0" )

DbSelectArea("TMP")
DbCloseArea()

While .T.
	@ 006,042 TO 500,600 DIALOG oDlgMen1 TITLE OemToAnsi("Observa��o An�lise de Cr�dito")
	
	@ 010,010 Say OemToAnsi("Cliente")
	@ 010,042 Get _cCodCli  Picture PESQPICT("Z31","Z31_CODCLI") Size 050,050 When .F.
	@ 010,100 Get _cNomeCli Picture PESQPICT("Z31","Z31_NOMECL") Size 100,100 When .F.
	
	@ 030,010 Say OemToAnsi("Sequ�ncia")
	@ 030,042 Get _cSequen  Picture PESQPICT("Z31","Z31_SEQUEN") Size 050,050 When .F.
	
	@ 050,010 Say OemToAnsi("Observa��o")
	@ 050,042 Get _cObserv Size 200,170  MEMO Object oMemo
	
	@ 230,100 BUTTON "OK" SIZE 35,15 ACTION IFINC02D()
	@ 230,150 BUTTON "Fechar" SIZE 35,15 ACTION Close(oDlgMen1)
	
	ACTIVATE DIALOG oDlgMen1 CENTERED
	Exit
End

Return

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � IFINC02D � Autor � Rafael Domingues - ANADI � Data � 31/03/15 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Efetua a grava��o na tabela Z31 - inclusao da observacao      ���
����������������������������������������������������������������������������Ĵ��
���Sintaxe   � IFINC02D()                                                    ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Isapa                                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

Static Function IFINC02D()

DbSelectArea("Z31")
RecLock("Z31",.T.)
Z31->Z31_CODCLI := _cCodCli
Z31->Z31_LOJCLI := _cLojCli
Z31->Z31_NOMECL := _cNomeCli
Z31->Z31_SEQUEN := _cSequen
Z31->Z31_OBSERV := _cObserv
MsUnLock()
Close(oDlgMen1)

Return

