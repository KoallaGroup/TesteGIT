#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

#define DS_MODALFRAME   128

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  F050INC     º Autor ³ KLIAMCA            º Data ³  07/08/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ PROGRAMA PARA GERAR COMISSOES A PARTIR DO CONTAS A PAGAR   º±±
±±º          ³ ESCOLHENDO UM EVENTO DA TABELA Z24                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±


±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F050INC()

local aArea		:= GetArea()
Local oFont		:= tFont():New("Tahoma",,-14,,.t.)

_cEvento 	:= space(6)

If SE2->E2_PREFIXO <> "GPE"
	return
Endif

If !MsgYesNo("Deseja gravar na comissão?","Confirme")
	Return
Endif

DEFINE MSDIALOG oDlg TITLE "EVENTOS DE DEB/CRED RH" FROM 000, 000  TO 170, 400 PIXEL Style DS_MODALFRAME

@ 10,015 SAY "NF do Evento " SIZE 100, 10 OF oDlg PIXEL FONT oFont
@ 10,100 MsGet _cEvento Picture "@!" Size 50,10 of oDlg PIXEL FONT oFont F3 "Z24CAD"

@ 70,100 BUTTON oButton14 PROMPT "Ok" SIZE 037, 012 OF oDlg ACTION (gravaSE3(oDlg)) PIXEL
@ 70,150 BUTTON oButton14 PROMPT "Fechar"  SIZE 037,012  OF oDlg PIXEL ACTION oDlg:End()

oDlg:lEscClose := .F.
ACTIVATE MSDIALOG oDlg CENTERED

RestArea(aArea)

Return

//*******************************************************
Static Function GravaSe3(oDlg)
//*******************************************************

Local _area := GetArea()

if empty(_cEvento)
	msgAlert ("O campo evento deve ser preenchido !!")
	Return
end

_dEmissao 	:= SE2->E2_VENCTO
_nBase 		:= Iif(Z24->Z24_TIPO == "1",(SE2->E2_VALOR * -1),SE2->E2_VALOR)
_cTpLanc	:= Z24->Z24_CODIGO
_cComis		:= Z24->Z24_COMIS
_cFornece	:= SE2->E2_FORNECE
_cLoja		:= SE2->E2_LOJA

DbSelectarea("SA3")
DbOrderNickName("FORNECE")
If !DbSeek(xFilial("SA3") + _cFornece + _cLoja)
	MsgAlert("Vendedor não cadastrado para esse fornecedor...")
	SA3->(DbCloseArea())
	RestArea(_Area)
	Return
Else
	_cVend 	:= A3_COD
Endif

DbSelectarea("SE3")
Reclock("SE3", .T.)

SE3->E3_FILIAL	:= xFilial("SE3")
SE3->E3_VEND 	:= _cVend
SE3->E3_COMIS	:= _nBase
SE3->E3_VENCTO	:= _dEmissao
SE3->E3_EMISSAO	:= _dEmissao
SE3->E3_BASE	:= _nBase
SE3->E3_PORC	:= 100
SE3->E3__TPLANC	:= _cTpLanc
SE3->E3__COMIS	:= _cComis
SE3->E3_MOEDA	:= "01"
SE3->(msUnlock())

SE3->(DbCloseArea())
SA3->(DbCloseArea())

oDlg:End()

RestArea(_Area)
Return
