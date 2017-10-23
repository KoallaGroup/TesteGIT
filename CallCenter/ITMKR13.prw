#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+----------------+
| Programa:  | ITMKR13 | Autor: | Rogério Alves      | Data: |   Março/2015   |
+------------+---------+--------+--------------------+-------+----------------+
| Descrição: | Relatório de Clientes que não realizaram Compra                |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/

User Function ITMKR13()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9
Local aPergs	:= {}

Private oGroup1, oGroup2, oGroup3
Private lQuebra := .f.
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}
Private cSegIni		:= Space( avSx3("B1__SEGISP",3) )
Private cSegFim		:= Space( avSx3("B1__SEGISP",3) )
Private cReprIni	:= Space( avSx3("UA_VEND" 	,3) )
Private cReprFim 	:= Space( avSx3("UA_VEND" 	,3) )
Private nQtdDia		:= 0
Private dDtIni	 	:= Space(8)
Private dDtFim	 	:= Space(8)
Private nMotNC		:= 2
Private nAtivo		:= 1
Private nCredito	:= 1
Private oSegIni, oSegFim, oReprIni, oReprFim, oDtFim, oQtdDia, oMotNC
Private oRadio, oRadSub1, oRadSub2, oButProc

Private cPerg		:= PADR("ITMKR13",Len(SX1->X1_GRUPO))
Private aSx1		:= {}
Private oButSub

aSize 				:= MsAdvSize()

aObjects 			:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo				:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj 			:= MsObjSize(aInfo, aObjects)
nLinSay 			:= aPosObj[1,1] + 10
nLinGet 			:= aPosObj[1,1] + 7
aPosGet 			:= MsObjGetPos(aSize[3]-aSize[1],315,{{008,025,060,73,137}})

Aadd(aPergs,{"A Partir do Segmento     ","","","mv_ch1","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR01",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"Até o Segmento           ","","","mv_ch2","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR02",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"A Partir do Representante","","","mv_ch3","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR03",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Até o Representante      ","","","mv_ch4","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR04",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Quantidade de Dias       ","","","mv_ch5","N",04	                    ,0,1,"C","","MV_PAR05",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"A Partir Data Base       ","","","mv_ch6","D",08						,0,0,"G","","MV_PAR06",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Motivo não Compra        ","","","mv_ch7","N",01	                    ,0,1,"C","","MV_PAR07","Sim","","","","","Não"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

cSegIni		:= MV_PAR01
cSegFim		:= MV_PAR02
cReprIni	:= MV_PAR03
cReprFim 	:= MV_PAR04
nQtdDia		:= 0//MV_PAR05
dDtFim	 	:= MV_PAR06
cMotNC		:= MV_PAR07
_lWhen 		:= .T.

AtuSeg(cSegIni,1)
AtuSeg(cSegFim,2)

DEFINE MSDIALOG oDlg TITLE "Relatório de Clientes que não realizaram Compra" FROM 000, 000  TO 350, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.


_cSegto := Posicione("SZ1",1,xFilial("SZ1") + __cUserId,"Z1_SEGISP")

If Val(_cSegto) > 0
	_lWhen 		:= .F.
	cSegIni		:= _cSegto
	cSegFim		:= _cSegto
EndIf


@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+140,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
//@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+150,aPosGet[1,04]+135 PROMPT ""   						OF oDlg COLOR  0, 16777215 Pixel
@ nLinSay, aPosGet[1,01] 	SAY     oSay1       PROMPT "A Partir do Segmento"     					SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oSegIni    VAR cSegIni       			When _lWhen				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SZ72"		Valid AtuSeg(cSegIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay2       PROMPT "Até o Segmento" 							SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oSegFim    VAR cSegFim       			When _lWhen				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SZ72"		Valid AtuSeg(cSegFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay3       PROMPT "A Partir do Representante"	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oReprIni    VAR cReprIni	Picture PesqPict("SUA","UA_VEND")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA3" 		Valid ValRepr(cReprIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay4       PROMPT "Até o Representante"         				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oReprFim    VAR cReprFim	Picture PesqPict("SUA","UA_VEND")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA3" 		Valid ValRepr(cReprFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay5     	PROMPT "Quantidade de Dias"    						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oQtdDia   	VAR nQtdDia	Picture "9999"							SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay6      	PROMPT "A Partir da Data Base"         				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay-3, aPosGet[1,02]+30 MSGET	oDtFim 	   	VAR dDtFim											SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay7      	PROMPT "Motivo não Compra?"    						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay, aPosGet[1,02]+30 RADIO	oMotNC 		VAR nMotNC Prompt OemToAnsi("Sim"),OemToAnsi("Não") SIZE 050, 025 	OF oDlg Pixel
nLinSay += 13
nLinGet += 13
@ nLinSay,aPosGet[1,01]+65    GROUP   	oGroup2 TO nLinSay+45,aPosGet[1,01]+105 PROMPT "Ativo?"   					OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,02]+30 RADIO oRadSub1 	VAR nAtivo Prompt OemToAnsi("Sim"),OemToAnsi("Não"),OemToAnsi("Ambos") SIZE 50, 025 OF oDlg Pixel

@ nLinSay,aPosGet[1,01]+115    GROUP   	oGroup3 TO nLinSay+45,aPosGet[1,01]+155 PROMPT "Crédito?"   				OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,02]+80 RADIO oRadSub2 	VAR nCredito Prompt OemToAnsi("Sim"),OemToAnsi("Não"),OemToAnsi("Ambos") SIZE 50, 025 OF oDlg Pixel

oMotNC:lHoriz := .T.
oRadSub1:lHoriz := .F.
oRadSub2:lHoriz := .F.
	
nLinSay += 52
nLinGet += 52
@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action (GeraRel())	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+73  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraRel			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina para verificação dos filtros de tela e geração do relatório em crystal   |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GeraRel()

Local _cRelato	:= ""
Local _cParams	:= ""
Local _cOptions := "1;0;1;Relatório de Clientes Inativos" 
Local _nAti1	:= ""
Local _nAti2	:= "" 
Local _nAti3	:= "" 
Local _cCredIni := "0"
Local _cCredFim := "99999999999999"

GravaSx1()

If nMotNC == 2
	_cRelato	:= "ITMKCR13A"
ElseIf nMotNC == 1	
	_cRelato	:= "ITMKCR13B"
EndIf

dDtIni := dDtFim - nQtdDia

If nAtivo == 1
	_nAti1 := " "
	_nAti2 := "1"
	_nAti3 := "1"	
ElseIf nAtivo = 2
	_nAti1 := "2"
	_nAti2 := "2"
	_nAti3 := "2"
ElseIf nAtivo = 3
	_nAti1 := " "
	_nAti2 := "1"
	_nAti3 := "2"		
EndIf

If nCredito == 1 
	_cCredIni := "0,000000000001"
	_cCredFim := "99999999999999"
ElseIf nCredito == 2
	_cCredIni := "0"
	_cCredFim := "0"
EndIf	

If Empty(cReprIni) .or. Type(cReprIni) != 'N'
	cReprIni := '1'
EndIf

If Type(cReprFim) != 'N'
	cReprFim := '999999'
EndIf

_cParams := cSegIni 				+ ";"
_cParams += cSegFim 				+ ";"
_cParams += cReprIni				+ ";"
_cParams += cReprFim	 			+ ";"
_cParams += DTOS(dDtIni)	 		+ ";"
_cParams += DTOS(dDtFim)	 		+ ";"
_cParams += _nAti1   				+ ";"
_cParams += _nAti2	 				+ ";"
_cParams += _nAti3	 				+ ";"
_cParams += _cCredIni				+ ";"
_cParams += _cCredFim				+ ";"
_cParams += Alltrim(Str(nQtdDia))
  
CallCrys(_cRelato,_cParams,_cOptions)

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaSX1			 	| 	Março de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Grava valores na SX1                                                            |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GravaSx1()

Local nX := 1

aAdd( aSx1, {cSegIni, cSegFim, cReprIni, cReprFim, alltrim(str(nQtdDia)), DTOS(dDtFim), alltrim(str(cMotNC)) } )

Dbselectarea("SX1")
DbsetOrder(1)
If Dbseek(cPerg+"01")
	Do While ( !(Eof()) .AND. SX1->X1_GRUPO == cPerg )
		Reclock("SX1",.F.)
		SX1->X1_CNT01:= aSX1[1][nX]
		SX1->(MsUnlock())
		nX++
		DbSkip()
	EndDo
EndIf

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValRepr			 	| 	Março de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência do Representante                                              |
|-----------------------------------------------------------------------------------------------|
*/


static function ValRepr(_cRepr,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cRepr) .and. _nSt == 2
	
	cReprFim := "ZZZZZZ"
	oReprFim:Refresh()
	
Else
	
	dbSelectArea("SA3")
	dbSetOrder(1)
	if !dbSeek(xFilial("SA3")+_cRepr) .and. !empty(_cRepr)
		msgAlert ("Representante não cadastrado !!")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Março de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Segmento                                                                 |
|-----------------------------------------------------------------------------------------------|
*/

Static Function AtuSeg(PSeg,nSta)

Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF !(SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) ) .and. Alltrim(PSeg) != "0")
	If !(nSta == 2 .and. Upper(PSeg) == "ZZ")
		MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
		lRet	:= .F.
	EndIf
EndIf

Return(lRet)
