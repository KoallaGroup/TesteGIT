#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFINR17				 	| 	   Abril de 2015                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de Títulos para Baixa no Banco                                        |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFINR17()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3
Local aPergs	:= {}

Private oGroup1
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private dDataini	:= CTOD("  \  \  ")
Private lProrVenc	:= .F.
Private cLote		:= Space( avSx3("E1_IDCNAB",3) )

Private oDataini, oProrVenc, oLote
Private oButProc

Private cPerg		:= PADR("IFINR17",Len(SX1->X1_GRUPO))
Private aSx1		:= {}

aSize 				:= MsAdvSize()

aObjects 			:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo				:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj 			:= MsObjSize(aInfo, aObjects)
nLinSay 			:= aPosObj[1,1] + 10
nLinGet 			:= aPosObj[1,1] + 7
aPosGet 			:= MsObjGetPos(aSize[3]-aSize[1],315,{{008,025,060,73,137}})

Aadd(aPergs,{"Data de Movimento        ","","","mv_ch1","D",08						,0,0,"G","","MV_PAR01",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Prorrogacao Vencimento?  ","","","mv_ch2","C",01	                    ,0,1,"C","","MV_PAR02","Sim"	,"","","",""	,"Não"			,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Lote                     ","","","mv_ch3","C",TamSx3("E1_IDCNAB")[1]	,0,0,"G","","MV_PAR03",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

dDataini	:= MV_PAR01
lProrVenc	:= .f.
cLote		:= MV_PAR03

DEFINE MSDIALOG oDlg TITLE "Relatório de Títulos Baixa para Banco" FROM 000, 000  TO 270, 540 COLORS 0, 16777215 PIXEL

oDlg:lMaximized := .f.

@ nLinSay-1, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+110,aPosGet[1,04]+85 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01]+10	SAY     oSay1     	PROMPT "Data de Movimento" 		   					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+50	MSGET   oDataini   	VAR dDataini	Picture "@D"						SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01]+10	SAY     oSay2     	PROMPT "Prorrogação de Vencimento ?"				SIZE 090, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay, aPosGet[1,02]+50	CHECKBOX oProrVenc	VAR lProrVenc PROMPT "" 							SIZE 030, 013 	OF oDlg COLORS 0, 16777215 PIXEL	on Click ValChkBox(lProrVenc)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01]+10	SAY     oSay3       PROMPT "Número Do Bordero"     						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 02
nLinGet += 02
@ nLinGet, aPosGet[1,02]+50 MSGET   oLote   	VAR cLote	Picture PesqPict("SE1","E1_IDCNAB")		SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 38
nLinGet += 38
@ nLinSay, aPosGet[1,04]-50 BUTTON   oButProc  PROMPT "Processar"	Action (GeraRel(),oDlg:end())	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]  	BUTTON   oButProc  PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraRel			 	| 	Abril de 2015 	                                        |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina para verificação dos filtros de tela e geração do relatório em crystal   |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GeraRel()

Local _cRelato	:= "IFINCR17"
Local _cParams	:= ""
Local _cOptions := "1;0;1;Relatório de Títulos para Baixa no Banco"
Local _cPror	:= ""

GravaSx1()

If !lProrVenc
	_cPror	:= "A" 
Else
	_cPror	:= "B"
EndIf

_cParams := Alltrim(DTOS(dDataini))	+ ";"
_cParams += cLote                   + ";"
_cParams += _cPror

CallCrys(_cRelato,_cParams,_cOptions)

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaSX1			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Grava valores na SX1                                                            |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GravaSx1()

Local nX := 1
Local _nProrVenc

If lProrVenc
	_nProrVenc := 1
Else
	_nProrVenc := 2
EndIf		
	
aAdd( aSx1, {DTOS(dDataini), Str(_nProrVenc), cLote } )

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
|	Programa : ValChkBox		 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Zera lote para relatório de prorrogação                                         |
|-----------------------------------------------------------------------------------------------|
*/


Static Function ValChkBox(lParam)

If lParam
	cLote := Space( avSx3("E1_IDCNAB",3) )		
	oLote:lActive	:= .f.
Else
	oLote:lActive	:= .t.	
Endif

oLote:Refresh()
oDlg:Refresh()

Return(.t.)
