#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKR04				 	| 	Outubro de 2014                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de Avaliação de Manifestação                                          |
|-----------------------------------------------------------------------------------------------|
*/

User Function ITMKR04()

Local oButton1
Local oButton2
Local oFont1 	:= tFont():New("Tahoma",,14,,.t.)
Local oFont 	:= tFont():New("Tahoma",,12,,.t.)
Local oFont2 	:= TFont():New("Tahoma",,14,,.F.)
//oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)

Static oDlg

Private cPerAte		:= space(8)
Private cPerDe		:= space(8)
Private cFil		:= space(TAMSX3("ZE_CODFIL")[1])
Private cSeg 		:= space(TAMSX3("Z7_CODIGO")[1])
Private oGetFil
Private oGetSeg
Private cDesEmp		:= ""
Private cDesSeg		:= ""
Private cDataDe		:= CTOD("  /  /  ")
Private cDataAte	:= CTOD("  /  /  ")

DEFINE MSDIALOG oDlg TITLE "Relatório de Avaliação de Manifestação" FROM 000, 000  TO 250, 500 COLORS 0, 16777215 PIXEL

@ 010,015 SAY "Segmento" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 010,095 MsGet oGetSeg VAR cSeg when .T. Picture "@!" Size 06,8 of oDlg PIXEL FONT oFont1 F3 "SZ72" valid ValSeg(cSeg)
@ 010,145 SAY cDesSeg SIZE 60, 10 OF oDlg PIXEL FONT oFont1

@ 025,015 SAY "Período De (aaaa/mm)" SIZE 80, 10 OF oDlg PIXEL FONT oFont2
@ 025,095 MsGet cPerDe Picture "@e 9999/99" SIZE 30, 8 OF oDlg PIXEL FONT oFont1 valid ValidaData(cPerDe,.T.)

@ 040,015 SAY "Período Até (aaaa/mm)" SIZE 80, 10 OF oDlg PIXEL FONT oFont2
@ 040,095 MsGet cPerAte Picture "@e 9999/99" SIZE 30, 8 OF oDlg PIXEL FONT oFont1 valid ValidaData(cPerAte,.F.)

@ 055,015 SAY "Data De" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 055,095 SAY cDataDe Picture "@D" SIZE 40, 10 OF oDlg PIXEL FONT oFont1

@ 070,015 SAY "Data Ate" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 070,095 SAY cDataAte Picture "@D" SIZE 40, 10 OF oDlg PIXEL FONT oFont1

/*
@ 010,015 SAY "Local" SIZE 30, 10 OF oDlg PIXEL FONT oFont2
@ 010,095 MsGet oGetFil VAR cFil when .T. Picture "@!" Size 06,8 of oDlg PIXEL FONT oFont1 F3 "DLB" valid ValidaFil(cFil)
@ 010,145 SAY cDesEmp SIZE 60, 10Í OF oDlg PIXEL FONT oFont1

@ 025,015 SAY "Segmento" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 025,095 MsGet oGetSeg VAR cSeg when .T. Picture "@!" Size 06,8 of oDlg PIXEL FONT oFont1 F3 "SZ7" valid ValSeg(cSeg)
@ 025,145 SAY cDesSeg SIZE 60, 10 OF oDlg PIXEL FONT oFont1

@ 040,015 SAY "Período De (aaaa/mm)" SIZE 80, 10 OF oDlg PIXEL FONT oFont2
@ 040,095 MsGet cPerDe Picture "@e 9999/99" SIZE 30, 8 OF oDlg PIXEL FONT oFont1 valid ValidaData(cPerDe,.T.)

@ 055,015 SAY "Período Até (aaaa/mm)" SIZE 80, 10 OF oDlg PIXEL FONT oFont2
@ 055,095 MsGet cPerAte Picture "@e 9999/99" SIZE 30, 8 OF oDlg PIXEL FONT oFont1 valid ValidaData(cPerAte,.F.)

@ 070,015 SAY "Data De" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 070,095 SAY cDataDe Picture "@D" SIZE 40, 10 OF oDlg PIXEL FONT oFont1

@ 085,015 SAY "Data Ate" SIZE 50, 10 OF oDlg PIXEL FONT oFont2
@ 085,095 SAY cDataAte Picture "@D" SIZE 40, 10 OF oDlg PIXEL FONT oFont1
*/

@ 105,065 BUTTON oButton1 PROMPT "Processar" SIZE 040, 012 OF oDlg PIXEL ACTION (ITMKR04A(.T.),oDlg:End())
@ 105,130 BUTTON oButton2 PROMPT "Cancelar" SIZE 040, 012 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

Return

////////////////////////////////////////////////
//Chama rotina do Crystall Reports
////////////////////////////////////////////////

Static Function ITMKR04A(cMaster)

local aArea 	:= getArea()
Local cOptions 	:= "1;0;1;Relatório de Avaliação de Manifestação"
Local cParams	:= ""

//cParams := cFil 			+ ";"
cParams := cSeg				+ ";"
cParams += dtos(cDataDe)	+ ";"
cParams += dtos(cDataAte)

CallCrys("ITMKCR04",cParams,cOptions)

Alert ("Processo Finalizado !!")

RestArea(aArea)

Return .T.


////////////////////////////////////////////////
//VALIDA FILIAL
////////////////////////////////////////////////

Static Function ValidaFil(cFil)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cFIL)
	dbSelectArea("SZE")
	dbSetOrder(1)
	if !dbSeek("01"+cFil)
		msgAlert("Filial não cadastrado !!")
		_lRet := .F.
	Else
		cDesEmp	:= SZE->ZE_FILIAL
	EndIf
EndIf

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA SEGMENTO
////////////////////////////////////////////////

Static Function ValSeg(cSegmento)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cSegmento)
	
	If Alltrim(cSegmento) == "0"
		msgAlert("Segmento não pertencente à consulta !!")
		_lRet := .F.
	Else
		dbSelectArea("SZ7")
		dbSetOrder(1)
		if !dbSeek(xFilial("SZ7")+cSegmento)
			msgAlert("Segmento não cadastrado !!")
			_lRet := .F.
		else
			cDesSeg := SZ7->Z7_DESCRIC
		endif
	EndIf
	
EndIf

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA Data
////////////////////////////////////////////////

Static Function ValidaData(cPer,ldt)

local _aArea 	:= getArea()
local _lRet  	:= .T.
Local cMes		:= Substr(cPer,6,2)
Local cAno		:= Substr(cPer,1,4)
Local nMes		:= Val(Substr(cPer,6,2)) + 1

If Val(Substr(cPer,6,2)) > 12 .or. Val(Substr(cPer,6,2)) < 1
	msgAlert("Mês Incorreto !!")
	_lRet := .F.
Else
	If ldt
		cDataDe := ctod("01/" + cMes + "/" + cAno)
	Else
		If nMes == 13
			cDataAte := ctod("31/" + cMes + "/" + cAno)
		Else
			cDataAte := ctod(("01/" + Alltrim(Str(nMes)) + "/" + cAno)) - 1
		EndIf
	EndIf
EndIf

restarea(_aArea)

return _lRet
