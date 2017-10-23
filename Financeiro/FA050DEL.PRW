#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

#define DS_MODALFRAME   128

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  FA050DEL     º Autor ³ KLIAMCA            º Data ³  28/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PROGRAMA PARA EXCLUIR COMISSOES A PARTIR DO CONTAS A PAGAR   º±±
±±º          ³ E3_PROCCOM                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±


±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
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

msgAlert ("Existem distribuições de PA para esse título. Favor verificar !!")
_lValid := .F.

endif
*/
