#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IESTR06				 	| 	   Abril de 2015                                    |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Itens Expedido                                                                  |
|-----------------------------------------------------------------------------------------------|
*/

User Function IESTR06()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7
Local aPergs	:= {}

Private oGroup1
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private cLocalDe	:= space(TAMSX3("ZE_CODFIL")[1])
Private cLocalAte	:= Replicate('Z',TAMSX3("ZE_CODFIL")[1])
Private dDataini	:= CTOD("  \  \  ")
Private dDataFim	:= CTOD("  \  \  ")
Private cUF			:= Space( avSx3("A1_EST",3) )
Private cSegisp		:= Space( avSx3("Z7_CODIGO",3) )
Private cDescSeg	:= Space( avSx3("Z7_DESCRIC",3) )
Private cRepres		:= space(TAMSX3("A3_COD")[1])
Private cDescRep	:= space(TAMSX3("A3_NOME")[1])
Private cOperacao	:= "                           "            
Private cDescOper	:= space(50)            
Private lIcmsSt		:= .F.

Private oLocalDe, oLocalAte, oDataini, oDataFim, oUF, oSegisp, oDescSeg, oRepres, oDescRep, oOperacao, oDescOper//, oIcmsSt
Private oButProc, oCheckBo1

Private cPerg		:= PADR("IESTR06",Len(SX1->X1_GRUPO))
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

Aadd(aPergs,{"A Partir do Local        ","","","mv_ch1","C",TamSx3("ZE_CODFIL")[1]	,0,0,"G","","MV_PAR01",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Até o Local              ","","","mv_ch2","C",TamSx3("ZE_CODFIL")[1]	,0,0,"G","","MV_PAR02",""		,"","","","ZZ"	,""				,"","","","","",""	,"","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"A Partir da Data         ","","","mv_ch3","D",08						,0,0,"G","","MV_PAR03",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até a Data               ","","","mv_ch4","D",08						,0,0,"G","","MV_PAR04",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"UF                       ","","","mv_ch5","C",TamSx3("A1_EST")[1]		,0,0,"G","","MV_PAR05",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","","12"	,"","","",""})
Aadd(aPergs,{"Segmento                 ","","","mv_ch6","C",TamSx3("A1__SEGISP")[1]	,0,0,"G","","MV_PAR06",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"Representante            ","","","mv_ch7","C",TamSx3("A1_VEND")[1]	,0,0,"G","","MV_PAR07",""		,"","","",""	,""				,"","","","","",""	,"","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Operação                 ","","","mv_ch8","C",15						,0,0,"C","","MV_PAR08","Venda"	,"","","",""	,"Transferência","","","","","Ambos","","","","","","","","","","","","","",""  ,"","","",""})
Aadd(aPergs,{"Inclui Icms ST ?         ","","","mv_ch9","C",01	                    ,0,1,"C","","MV_PAR09","Sim"	,"","","",""	,"Não"			,"","","","","",""	,"","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

cLocalDe	:= MV_PAR01
cLocalAte	:= MV_PAR02
dDataini	:= MV_PAR03
dDataFim	:= MV_PAR04
cUF			:= MV_PAR05
cSegisp		:= MV_PAR06
cRepres		:= MV_PAR07
//cOperacao	:= MV_PAR08
lIcmsSt		:= MV_PAR09

AtuSeg(cSegisp)
ValRep(cRepres)

DEFINE MSDIALOG oDlg TITLE "Estatística Logística (Itens Expedidos)" FROM 000, 000  TO 380, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay-1, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+160,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay1       PROMPT "A Partir do Local"	            		    SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oLocalDe    VAR cLocalDe	Picture PesqPict("SZE","ZE_CODFIL")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "DLB" 		Valid ValLocal(cLocalDe,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay2       PROMPT "Até o Local"         						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oLocalAte    VAR cLocalAte	Picture PesqPict("SZE","ZE_CODFIL")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "DLB" 		Valid ValLocal(cLocalAte,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay3     	PROMPT "A Partir da Data" 		   					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oDataini   	VAR dDataini	Picture "@D"						SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay4     	PROMPT "Até a Data"			    					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oDataFim   	VAR dDataFim	Picture "@D"						SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay5       PROMPT "UF"					         				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oUF		    VAR cUF			Picture PesqPict("SA1","A1_EST")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "12" 		Valid ValUf(cUF)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay5       PROMPT "Segmento"     								SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oSegisp    	VAR cSegisp      Picture PesqPict("SZ7","Z7_CODIGO")SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SZ72"		Valid AtuSeg(cSegisp)
@ nLinGet, aPosGet[1,02]+70 MSGET   oDescSeg    VAR cDescSeg	When .F.  Picture PesqPict("SZ7","Z7_DESCRIC")	SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay6       PROMPT "Representante" 								SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oRepres    	VAR cRepres      Picture PesqPict("SA3","A3_COD")	SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SA3"		Valid ValRep(cRepres)
@ nLinGet, aPosGet[1,02]+70 MSGET   oDescRep    VAR cDescRep	When .F.  Picture PesqPict("SA3","A3_NOME")	SIZE 150, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay7       PROMPT "Operação" 									SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSCOMBOBOX oOperacao VAR cOperacao ITEMS{"Venda","Transferencia","Todas"} SIZE 050, 008 OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,02]+30	CHECKBOX oCheckBo1 	VAR lIcmsSt PROMPT "      Incluir Icms ST?" 		SIZE 070, 013 	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 18
nLinGet += 18
@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action GeraRel()				SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+73  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

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

Local _cRelato	:= "IESTCR06"
Local _cParams	:= ""
Local _cOptions := "1;0;1;Itens Expedidos"
Local _cVendIni	:= ""
Local _cVendAte	:= ""
Local _cIcmsSt	:= ""
Local _cOper	:= ""
Local _cDescOp	:= ""
//Local aSM0 		:= FWLoadSM0()
//Local _aCGC		:= ""

GravaSx1()
	
If Empty(cRepres)	//REPRESENTANTE DIFERENTE
	//_cRelato	:= "IESTCR06B"
	_cVendIni	:= Space(TAMSX3("A3_COD")[1])
	_cVendAte	:= Replicate('Z',TAMSX3("A3_COD")[1])
Else				//REPRESENTANTE ESPECIFICO
	//_cRelato	:= "IESTCR06A"
	_cVendIni	:= cRepres
	_cVendAte	:= cRepres
EndIf

If lIcmsSt
	_cIcmsSt	:= "A"
Else
	_cIcmsSt	:= "B"
EndIf

If Alltrim(Upper(cOperacao)) == "VENDA" 
	_cOper		:= "V"
	_cDescOp	:= "VENDA"
ElseIf Alltrim(Upper(cOperacao)) == "TRANSFERENCIA" 
	_cOper		:= "T"
	_cDescOp	:= "TRANSFERÊNCIA" 
ElseIf Alltrim(Upper(cOperacao)) == "TODAS" 
	_cOper		:= "A" 
	_cDescOp	:= "TODAS" 
EndIf

/*
For x:=1 to Len(aSM0)
	_aCGC := _aCGC + aSM0[x][18]
	If x != Len(aSM0)
		_aCGC := _aCGC + ","
	EndIf
Next

_aCGC := FormatIn(_aCGC,",")
*/    
     
_cParams := Alltrim(cLocalDe)		+ ";"
_cParams += Alltrim(cLocalAte)		+ ";"
_cParams += Alltrim(DTOS(dDataini))	+ ";"
_cParams += Alltrim(DTOS(dDataFim))	+ ";"
_cParams += cSegisp					+ ";"
_cParams += cSegisp					+ ";"
_cParams += _cVendIni  				+ ";"
_cParams += _cVendAte  				+ ";"
_cParams += cUF				   		+ ";"
_cParams += _cOper					+ ";"
_cParams += _cIcmsSt				+ ";"
//_cParams += _aCGC					+ ";"
_cParams += Alltrim(UPPER(_cDescOp))

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
Local _cIcmsSt

If lIcmsSt
	_cIcmsSt := 1
Else
	_cIcmsSt := 2
EndIf		
	
aAdd( aSx1, {cLocalDe, cLocalAte, DTOS(dDataini), DTOS(dDataFim), cUF, cSegisp, cRepres, Alltrim(Upper(cOperacao)), Alltrim(Str(_cIcmsSt)) } )

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
|	Programa : ValLocal			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência do Local                                                      |
|-----------------------------------------------------------------------------------------------|
*/

static function ValLocal(_cLoc,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cLoc) .and. _nSt == 2
	
	cLocalAte := "ZZ"
	oLocalAte:Refresh()
	
Else
	
	dbSelectArea("SZE")
	dbSetOrder(1)
	if !dbSeek("01" + _cLoc) .and. !empty(_cLoc)
		msgAlert ("Local não cadastrada !!","PARÂMETROS INVÁLIDOS")
		lRet := .F.
	endif
	
EndIf

return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Segmento                                                                 |
|-----------------------------------------------------------------------------------------------|
*/

Static Function AtuSeg(PSeg)

Local _aArea 	:= GetArea()
Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF !(SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) ) .and. Alltrim(PSeg) != "0") 
	MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
	lRet	:= .F.
Else
	If Empty(PSeg)
		MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
		lRet	:= .F.	
	Else
		cDescSeg := SZ7->Z7_DESCRIC
	EndIf
EndIf

RestArea (_aArea)

Return(lRet)

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValUf			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Estado             									  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValUf(_cUf)

Local _aArea 	:= getArea()
Local _lRet		:= .T.

DbSelectArea("SX5")
DbSetOrder(1)
If !Empty(_cUf) .AND. !(DbSeek(cFilAnt + "12" + _cUf,.f.))
	MsgAlert("UF Incorreta","Atenção")
	_lRet := .F.
EndIf

restarea(_aArea)

return _lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValRep			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Representante        									  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValRep(_cRep)

Local _aArea 	:= getArea()
Local _lRet		:= .T.
    
If !Empty(_cRep)
	DbSelectArea("SA3")
	DbSetOrder(1)
	IF !(dbSeek(xFilial("SA3")+_cRep))
		MsgAlert("Representante Incorreta","Atenção")
		_lRet := .F.
	Else
		cDescRep := Alltrim(SA3->A3_NOME)
	EndIf
Else
	cDescRep := "Todos"	
EndIf
	
restarea(_aArea)

return _lRet
