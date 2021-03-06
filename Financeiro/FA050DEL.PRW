#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

#define DS_MODALFRAME   128

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  FA050DEL     � Autor � KLIAMCA            � Data �  28/08/15   ���
�������������������������������������������������������������������������͹��
���Descricao � PROGRAMA PARA EXCLUIR COMISSOES A PARTIR DO CONTAS A PAGAR   ���
���          � E3_PROCCOM                         ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��


�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA050DEL()

local _aArea	:= GetArea()
Local oFont		:= tFont():New("Tahoma",,-14,,.t.)

_cEvento 	:= space(6)

If SE2->E2_PREFIXO <> "COM"
	return(.t.)
Endif

_cProccom := xFilial("SE2")+"COM"+SE2->E2_NUM+SE2->E2_PARCELA

DbSelectArea("SE3")
DbOrderNickName("PROCCOM")

While !eof()

	IF DbSeek(_cProccom)
	
		RecLock("SE3",.F.)
		SE3->E3_PROCCOM := ""
		SE3->E3_DATA	:= ctod("  /  /  ")
		MsUnlock()
		
	End
	dBSkip()
	Loop
End

restArea(_aArea)

return(.t.)

/*

local _cPrefixo	:= SE2->E2_PREFIXO
local _cNum 	:= SE2->E2_NUM
local _cParcela	:= SE2->E2_PARCELA
local _cTipo 	:= SE2->E2_TIPO
local _cFornece	:= SE2->E2_FORNECE
local _cloja	:= SE2->E2_LOJA

_lValid := .T.

dbSelectArea("SZY")
dbSetOrder(1)
if dbSeek(xFilial("SZY")+_cPrefixo+_cNum+_cParcela+_cTipo+_cFornece+_cloja)

msgAlert ("Existem distribui��es de PA para esse t�tulo. Favor verificar !!")
_lValid := .F.

endif
*/
