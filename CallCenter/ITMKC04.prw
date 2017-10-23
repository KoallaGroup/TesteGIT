#Include "PROTHEUS.CH"

//--------------------------------------------------------------
/*{Protheus.doc} ITMKC04
Description : Gera tela de consulta de recados por representante

@param xParam Parameter Description
@return xRet Return Description
@author  -  Rogério Alves - Anadi
@since 16/09/2014
/*/
//--------------------------------------------------------------

User Function ITMKC04()

Local oButton1
Local oButton2
Local oGroup1
Local oGroup2
Local oGroup3
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
   
Static oDlg 

Private cArea 		:= space(TAMSX3("ZX5_CODIGO")[1])
Private cGrpRep 	:= space(TAMSX3("ACA_GRPREP")[1])
Private cRepre 	:= space(TAMSX3("A3_COD")[1])
Private cSegmento := space(TAMSX3("Z7_CODIGO")[1])
Private cSuper 	:= space(TAMSX3("A3_COD")[1])
Private cRecado 	:= space(TAMSX3("AD8_MEMO")[1])
Private cData 		:= ctod("  /  /  ")
Private cDescSeg	:= ""
Private cDescArea	:= ""
Private cDescGrp 	:= ""
Private cDescRepr := ""
Private cDescSup 	:= ""

DEFINE MSDIALOG oDlg TITLE "Gera Recados para os Representantes" FROM 000, 000  TO 400, 600 COLORS 0, 12632256 PIXEL

@ 166, 008 GROUP oGroup3 TO 191, 290 OF oDlg COLOR 0, 16777215 PIXEL
@ 087, 007 GROUP oGroup2 TO 158, 289 PROMPT "Recado " OF oDlg COLOR 0, 16777215 PIXEL
@ 007, 007 GROUP oGroup1 TO 079, 290 OF oDlg COLOR 0, 16777215 PIXEL
@ 017, 050 SAY oSay1 PROMPT "Segmento" SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 027, 062 SAY oSay2 PROMPT "Area" SIZE 013, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 037, 014 SAY oSay3 PROMPT "Equipe de Representante" SIZE 064, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 047, 039 SAY oSay4 PROMPT "Representante" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 057, 048 SAY oSay5 PROMPT "Supervisor" SIZE 028, 007 OF oDlg COLORS 0, 16777215 PIXEL
@ 067, 061 SAY oSay6 PROMPT "Data" SIZE 014, 007 OF oDlg COLORS 0, 16777215 PIXEL

@ 015, 082 MSGET oGet1 VAR cSegmento 	SIZE 040, 010 OF oDlg COLORS 0, 16777215 F3 "SZ7" PIXEL Valid ValSeg(cSegmento)
@ 016, 135 MSGET oGet1 VAR cDescSeg 	SIZE 150, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
@ 026, 092 MSGET oGet2 VAR cArea 		SIZE 040, 010 OF oDlg COLORS 0, 16777215 F3 "ZX5COM" PIXEL Valid ValArea(cArea)
@ 027, 135 MSGET oGet2 VAR cDescArea 	SIZE 150, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
@ 036, 082 MSGET oGet3 VAR cGrpRep 		SIZE 040, 010 OF oDlg COLORS 0, 16777215 F3 "ACA" PIXEL Valid ValGrpRep(cGrpRep)
@ 037, 135 MSGET oGet3 VAR cDescGrp 	SIZE 150, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
@ 046, 082 MSGET oGet4 VAR cRepre 		SIZE 040, 010 OF oDlg COLORS 0, 16777215 F3 "SA31" PIXEL Valid ValRepre(cRepre)
@ 047, 135 MSGET oGet4 VAR cDescRepr 	SIZE 150, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
@ 056, 082 MSGET oGet5 VAR cSuper 		SIZE 040, 010 OF oDlg COLORS 0, 16777215 F3 "SA31" PIXEL Valid ValSuper(cSuper)
@ 057, 135 MSGET oGet5 VAR cDescSup 	SIZE 150, 009 OF oDlg COLORS 0, 16777215 PIXEL	WHEN .F.
@ 066, 082 MSGET oGet6 VAR cData 		SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL

@ 095, 012 MSGET oGet6 VAR cRecado SIZE 271, 057 OF oDlg COLORS 0, 16777215 PIXEL

@ 173, 170 BUTTON oButton1 PROMPT "Processa" SIZE 040, 012 OF oDlg PIXEL ACTION U_ITMKC04A()
@ 173, 217 BUTTON oButton2 PROMPT "Cancela" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED

Return


user Function ITMKC04A()

While !RecLock("AD8",.T.)
EndDo

//	AD8->AD8__DTINC	:= date()
//	AD8->AD8__HRINC	:= time()

MsUnlock()

return


////////////////////////////////////////////////
//VALIDA SEGMENTO
////////////////////////////////////////////////

Static Function ValSeg(cSegmento)

local _aArea := getArea()
local _lRet  := .T.

dbSelectArea("SZ7")
dbSetOrder(1)
if !dbSeek(xFilial("SZ7")+cSegmento)
	msgAlert("Segmento não cadastrado !!")
	_lRet := .F.
else
	cDescSeg := SZ7->Z7_DESCRIC
endif

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA AREA
////////////////////////////////////////////////

Static Function ValArea(cArea)

local _aArea := getArea()
local _lRet  := .T.

dbSelectArea("ZX5")
dbSetOrder(1)		//ZX5_FILIAL+ZX5_FILISA+ZX5_GRUPO+ZX5_CODIGO
if !dbSeek(xFilial("ZX5")+"  "+"000001"+cArea)
	msgAlert("Área não cadastrado !!")
	_lRet := .F.
else
	cDescArea := ZX5->ZX5_DSCITE
endif

restarea(_aArea)

return _lRet


////////////////////////////////////////////////
//VALIDA GRUPO
////////////////////////////////////////////////

Static Function ValGrpRep(cGrpRep)

local _aArea := getArea()
local _lRet  := .T.

dbSelectArea("ACA")
dbSetOrder(1)		//ZX5_FILIAL+ZX5_FILISA+ZX5_GRUPO+ZX5_CODIGO
if !dbSeek(xFilial("ACA")+cGrpRep)
	msgAlert("Grupo não cadastrado !!")
	_lRet := .F.
else
	cDescGrp := ACA->ACA_DESCRI
endif

restarea(_aArea)

return _lRet


////////////////////////////////////////////////
//VALIDA REPRESENTANTE
////////////////////////////////////////////////

Static Function ValRepre(cRepre)

local _aArea := getArea()
local _lRet  := .T.

dbSelectArea("SA3")
dbSetOrder(1)
if !dbSeek(xFilial("SA3")+cRepre)
	msgAlert("Representante não cadastrado !!")
	_lRet := .F.
else
	cDescRepr := SA3->A3_NOME
endif

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA SUPERVISOR
////////////////////////////////////////////////

Static Function ValSuper(cSuper)

local _aArea := getArea()
local _lRet  := .T.

dbSelectArea("SA3")
dbSetOrder(1)
if !dbSeek(xFilial("SA3")+cSuper)
	msgAlert("Representante não cadastrado !!")
	_lRet := .F.
else
	cDescSup := SA3->A3_NOME
endif

restarea(_aArea)

return _lRet
