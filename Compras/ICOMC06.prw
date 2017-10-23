#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMC06			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta padrão para pedidos de Importação          						  	|
|-----------------------------------------------------------------------------------------------|
*/


User Function ICOMC06()

Local cAlias		:= GetArea()
Local nX           	:= 0
Local aButtons     	:= {}
Local cLinOk       	:= "AllwaysTrue"
Local cTudoOk      	:= "AllwaysTrue"
Local cIniCpos     	:= "C7_NUM"
Local nFreeze      	:= 000
Local nMax         	:= 99999
Local cFieldOk     	:= "AllwaysTrue"
Local cSuperDel    	:= ""
Local cDelOk       	:= "AllwaysFalse"
Local aAlterGDa    	:= {}
Local aFieldTit 	:= {}
Local aAlterFields  := {}
Local _aFields 		:= {}

Static cCodigo		:= ""

Private nUsado     	:= 0
Private _aHeader   	:= {}
Private _aCols     	:= {}
Private oDlg1		:= Nil
Private oGetD		:= Nil

aFieldTit 		:= 	{"Número Pedido" 	,"Data Emissão"}
aAlterFields  	:=  {"C7_NUM" 			,"C7_EMISSAO"}
_aFields 		:= 	{"C7_NUM" 			,"C7_EMISSAO"}

aSize := MsAdvSize()

aObjects := {}
AAdd( aObjects, { 100,  15, .t., .f. } )
AAdd( aObjects, { 100, 100, .t., .t. } )

aInfo := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }

aPosObj := MsObjSize(aInfo, aObjects)

nUsado:=0

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(_aFields)
	If SX3->(DbSeek(_aFields[nX]))
		Aadd(_aHeader, {aFieldTit[nx],aAlterFields[nx],SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R"})
		nUsado:=nUsado+1
	Endif
Next nX

DEFINE MSDIALOG oDlg1 TITLE "Número do Pedido" From 0,0 To 400,700 OF oMainWnd PIXEL

CriaCols(M->Z2_PEDIDO, M->Z2_CODFOR, M->Z2_LOJAFOR)

oGetD:=MsNewGetDados():New(21,3,186,350,/*nStyle*/,cLinOk,"AllwaysTrue", cIniCpos, aAlterFields, nFreeze, nMax,cFieldOk,cSuperDel,cDelOk, oDLG1, _aHeader, _aCols)

@ 188,210 Button oButton PROMPT "Confirmar"  SIZE 40,10   OF oDlg1 PIXEL ACTION U_ICOMC06A()
@ 188,280 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg1 PIXEL ACTION oDlg1:End()

oGetD:oBrowse:BldBlClick := {|| cCodigo := _acols[oGetD:nAt][1],oDlg1:End()}
oDlg1:lCentered := .T.
oDlg1:Activate()

RestArea(cAlias)

Return cCodigo

user function ICOMC06A()

cCodigo := _acols[oGetD:nAt][1]
oDlg1:End()

return cCodigo


Static Function CriaCols(cNumPed, cFornece, cLoja)

Local cQuery	:= ""
Local TRBSC7	:= {}

cQuery := "SELECT  C7_NUM, C7_EMISSAO "
cQuery += "FROM " + retSqlName("SC7") + "  SC7 "
cQuery += "WHERE SC7.D_E_L_E_T_ = ' ' "
cQuery += "AND C7_FILIAL = '" + cFilAnt + "' "
cQuery += "AND C7_NUM <> '" + cNumPed + "' "
cQuery += "AND C7_FORNECE = '" + cFornece + "' "
cQuery += "AND C7_LOJA = '" + cloja + "' "
cQuery += "AND C7_RESIDUO <> 'S' "
cQuery += "GROUP BY C7_NUM, C7_EMISSAO "
cQuery += "HAVING SUM(C7_QUANT - C7_QUJE - C7__QTEMBA) > 0 "
cQuery += "ORDER BY C7_NUM "

If Select("TRBSC7") > 0
	DbSelectArea("TRBSC7")
	DbCloseArea()
EndIf

TCQUERY cQuery NEW ALIAS "TRBSC7"

_aCols :={}

dbSelectArea("TRBSC7")
dbGoTop()

If Empty(TRBSC7->C7_NUM)
	AADD(_aCols,{TRBSC7->C7_NUM,stod(TRBSC7->C7_EMISSAO),"",.F.})
Else
	While (!EOF())
		AADD(_aCols,{TRBSC7->C7_NUM,stod(TRBSC7->C7_EMISSAO),"",.F.})
		dbSkip()
	EndDo
EndIf

oDlg1:Refresh()

If Select("TRBSC7") > 0
	DbSelectArea("TRBSC7")
	DbCloseArea()
EndIf

return
