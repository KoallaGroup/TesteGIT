#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IFINA05			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Programa para gravação de Segmentos												 		|
|-------------------------------------------------------------------------------------------------------|
*/

user Function IFINA05()
Local _aArea 	:= getArea()
Local cExprFilTop := ""

Private _cSegUsr	:= Posicione("SZ1",1,xFilial("SZ1")+__cUserId,"Z1_SEGISP")
private cCadastro	:= "Cadastro de Segmentos"
private aRotina		:= {{"Visualizar","axVisual",0,2},;
						{"Incluir","axInclui",0,3},;
						{"Excluir","axDeleta",0,5},;
						{"Alterar","axAltera",0,4},;
						{"Estab X Neg X UF","U_IFINA05F()",0,4},;
						{"Segmento x UF","U_IFINA05A()",0,4},;
						{"Fatores Tab Preço","U_IFINA05G()",0,4}}
	
Private _cCodigo	:= ""
					
cExprFilTop := "" //"Z7_CODIGO = '" + _cSegUsr + "' "

//mBrowse(6,1,22,75,"SZ7")
MBrowse( 6 , 1 , 22 , 75 , "SZ7" , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , NIL , cExprFilTop )

restArea(_aArea)

return


/*
|-----------------------------------------------------------------------------------------------|
|	Função : IFINA05A			 		| 	Março de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de inclusão dos estados												  	|
|-----------------------------------------------------------------------------------------------|
*/

user Function IFINA05A()

Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}
Local nLinha:= nLin02 	:= nOpca := 0, oDlg, oGet
Local nOpcx := 4
Local cSeek	:= SZ7->Z7_CODIGO
Local cWhile:= "SZ0->Z0_SEGISP"
Local aYesFields := {}
Local aNoFields	:= {}
//	Local cQuery	:= "Z0_SEGISP = '" + _cSegUsr + "' "

Local cCadastro	:= "Inclusão de Estados"

//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0]

aadd(aNoFields, "Z0_SEGISP")

aadd(aYesFields, "Z0_UF")
aadd(aYesFields, "Z0_DESC")

//Cria aHeader e aCols
FillGetDados(nOpcx,"SZ0",1,cSeek,{|| &cWhile },{||.T.},aNoFields,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,015,.t.,.f.})
AAdd(aObjects,{100,100,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 2
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,020,045,058,150,170,128,143,172,186,205,222,250,270} } )

@nLinha, aPosGet[1,01] Say "Segmento :"		SIZE 30,10 OF oDlg PIXEL
@nLinha, aPosGet[1,02] Say SZ7->Z7_DESCRIC 	SIZE 18,10 OF oDlg PIXEL

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_IFINA05C()","U_IFINA05D()","",.T.)
Private oGetDad := oGet

ACTIVATE MSDIALOG oDlg On Init IFINA05B(oDlg,{||if(oGet:TudoOk(),oDlg:End(),nOpcx := 0)}, {||oDlg:End()},nOpcx)

U_IFINA05E()

Return



Static Function IFINA05B(oDlg,bOk,bCancel,nOpc)
Local aButtons   := {}
Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))



user Function IFINA05C()
local _lRet := .T.
local _nZ0_UF  	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z0_UF" })
local _nZ0_DESC	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z0_DESC" })

for x:=1 to len(aCols)
	
	if ! aCols[x][len(aHeader)+1] .and. x <> n
		
		if aCols[x][_nZ0_UF] == aCols[n][_nZ0_UF]
			alert ("Já existe esse Estado relacionado com esse Segmento !!")
			_lRet := .F.
			exit
		endif
		
	endif
next x

if aCols[n][_nZ0_DESC] <= 0
	alert ("O valor do Desconto deve ser maior que Zero !!")
	_lRet := .F.
endif

return _lRet



user Function IFINA05D()
local _lRet := .T.

return _lRet


user Function IFINA05E()

local _nZ0_UF  	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z0_UF" })
local _nZ0_DESC	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z0_DESC" })
local _nRecno	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "Z0_REC_WT" })

dbSelectArea("SZ0")

for x:=1 to len(aCols)
	
	if ! aCols[x][len(aHeader)+1]
		
		if aCols[x][_nRecno] > 0
			_cGrava := .F.
			go aCols[x][_nRecno]
		else
			_cGrava := .T.
		endif
		
		do while !reclock("SZ0",_cGrava)
		enddo
		
		SZ0->Z0_FILIAL := xFilial("SZ0")
		SZ0->Z0_SEGISP := SZ7->Z7_CODIGO
		SZ0->Z0_UF     := aCols[x][_nZ0_UF]
		SZ0->Z0_DESC   := aCols[x][_nZ0_DESC]
		
		msUnlock()
		
	else
		
		if aCols[x][_nRecno] > 0
			go aCols[x][_nRecno]
			
			do while !reclock("SZ0", .F.)
			enddo
			
			delete
			
			msUnlock()
		endif
		
	endif
	
next x

return

/*
|-----------------------------------------------------------------------------------------------|
|	Função : IFINA05F			 		| 	Março de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de inclusão dos segmentos												  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFINA05F()
/* Jorge H. Alves - Out/2014
dbSelectArea("SZK")
dbSetOrder(1) //ZK_FILIAL+ZK_SEGISP
if dbSeek(xFilial("SZK")+SZ7->Z7_CODIGO)
AxAltera("SZK",SZ1->(Recno()),4)
else
AxInclui("SZK",,,,,,'lRet := .T.')
endif
*/

dbSelectArea("SZK")
dbSetOrder(1)

Set Filter to ZK_SEGISP == _cSegUsr

AXCADASTRO("SZK")

Return





/*
|-----------------------------------------------------------------------------------------------|
|	Função : IFINA05G			 		| 	Janeiro de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi     										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de inclusão dos fatores da tabela de Preço								  	|
|-----------------------------------------------------------------------------------------------|
*/

user Function IFINA05G()

Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}, aEdit := {}
Local nLinha:= nLin02 	:= nOpca := 0
Local nOpcx := 4
Local cSeek	:= ZX5->ZX5_GRUPO
Local cWhile:= "ZX5->ZX5_GRUPO"
Local aYesFields := {}
Local aNoFields	:= {}
//Local cQuery	:= "ZX5->ZX5_GRUPO == '000007' "
Local _lRet		:= .T.
Local cCadastro	:= "Inclusão dos fatores da tabela de Preço"
Local aButtons   := {}
Local lOK		:= .F.

//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0]
Private oDlg1, oGet1

aadd(aNoFields, "ZX5_SEGISP")

aadd(aYesFields, "ZX5_CODIGO")
aadd(aYesFields, "ZX5_DSCGRP")
aadd(aYesFields, "ZX5_DSCITE")

//aadd(aEdit, "ZX5_CODIGO")
aadd(aEdit, "ZX5_DSCGRP")
aadd(aEdit, "ZX5_DSCITE")

//Cria aHeader e aCols
FillGetDados(nOpcx,"ZX5",1,cSeek,{|| &cWhile },{||.T.},aNoFields,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,015,.t.,.f.})
AAdd(aObjects,{100,100,.t.,.t.})

aInfo 	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg1 TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 2
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,020,045,058,150,170,128,143,172,186,205,222,250,270} } )

@nLinha, aPosGet[1,01] Say "Segmento :"		SIZE 30,10 OF oDlg1 PIXEL
@nLinha, aPosGet[1,02] Say SZ7->Z7_DESCRIC 	SIZE 18,10 OF oDlg1 PIXEL

//oGet1 := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_IFINA05H()","U_IFINA05I()","+ZX5_CODIGO",.T.,aEdit,,,,"U_IFINA05L(SZ7->Z7_CODIGO)",) 
oGet1 := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_IFINA05H()","U_IFINA05I()",,.T.,aEdit,,,,,) 

//MsNewGetDados(): New ( [ nTop], [ nLeft], [ nBottom], [ nRight ], [ nStyle], [ cLinhaOk], [ cTudoOk], [ cIniCpos], [ aAlter], [ nFreeze], [ nMax], [ cFieldOk], [ cSuperDel], [ cDelOk], [ oWnd], [ aPartHeader], [ aParCols], [ uChange], [ cTela] )
U_IFINA05L(SZ7->Z7_CODIGO)

//ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT Eval({ || EnchoiceBar(oDlg1,{||lOk:=U_IFINA05K()},{||oDlg1:End()},,aButtons) })

ACTIVATE MSDIALOG oDlg1 CENTERED ON INIT EnchoiceBar(oDlg1,{||lOk := .T.,oDlg1:End()},{||lOk := .F.,oDlg1:End()},,aButtons)

If lOk
	
	U_IFINA05K()
	
EndIf

//U_IFINA05K()

Return



Static Function IFINA05J(oDlg1,bOk,bCancel,nOpc)
Local aButtons   := {}
Return (EnchoiceBar(oDlg1,bOK,bcancel,,aButtons))



user Function IFINA05H()

local _lRet 		:= .T.
local _nZX5_COD		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_CODIGO" }) 
Local _nTot			:= 0

for x:=1 to len(aCols)
	
	if ! aCols[x][len(aHeader)+1] .and. x <> n
		
		if aCols[x][_nZX5_COD] == aCols[n][_nZX5_COD]
			alert ("Já existe esse código relacionado com esse Segmento !!")
			_lRet := .F.
			exit
		endif
		
	endif
next x

If n == len(aCols)
	AADD(aCols,{Space(TamSX3("ZX5_DSCGRP")[1]),Soma1(aCols[n][_nZX5_COD]),Space(TamSX3("ZX5_DSCITE")[1]),"ZX5",0,.F.})
	n := Len(aCols)-1
EndIf

return _lRet



user Function IFINA05I()
local _lRet := .T.	
return _lRet


user Function IFINA05K()

local _nZX5_DSCGRP	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_DSCGRP" })
local _nZX5_DSCITE	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_DSCITE" })
local _nZX5_COD		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_CODIGO" })
local _nRecno		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_REC_WT" })
local _lRet			:= .T.

dbSelectArea("ZX5")


for x:=1 to len(aCols)
	
	If (Empty(aCols[x][_nZX5_COD]) .or. Empty(aCols[x][_nZX5_DSCGRP]) .or. Empty(aCols[x][_nZX5_DSCITE])) .and. !(aCols[x][len(aHeader)+1])
		MsgInfo(OemToAnsi("Existe campo sem preenchimento."),OemToAnsi("Atenção"))
		_lRet	:= .F.
	Else
		
		if ! aCols[x][len(aHeader)+1]
			
			if aCols[x][_nRecno] > 0
				_cGrava := .F.
				go aCols[x][_nRecno]
			else
				_cGrava := .T.
			endif
			
			do while !reclock("ZX5",_cGrava)
			enddo
			
			If !Empty(aCols[x][_nZX5_COD])
				
				ZX5->ZX5_FILIAL := xFilial("ZX5")
				ZX5->ZX5_GRUPO	:= "000007"
				ZX5->ZX5_SEGISP := SZ7->Z7_CODIGO
				ZX5->ZX5_CODIGO := aCols[x][_nZX5_COD]
				ZX5->ZX5_DSCGRP := aCols[x][_nZX5_DSCGRP]
				ZX5->ZX5_DSCITE := aCols[x][_nZX5_DSCITE]
				
				msUnlock()
				
			EndIf
			
		else
			
			if aCols[x][_nRecno] > 0
				go aCols[x][_nRecno]
				
				do while !reclock("ZX5", .F.)
				enddo
				
				delete
				
				msUnlock()
			endif
			
		endif
		
	EndIf
	
next x

return _lRet


user Function IFINA05L(_cSeg)

local _nZX5_COD	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZX5_CODIGO" })
local _cQuery	:= ""
local TMPZX5	:= {}
local _nTot		:= 0

If Empty(aCols[n][_nZX5_COD])
	
	_cQuery := "SELECT (MAX(ZX5_CODIGO) + 1) CODIGO "
	_cQuery += "FROM " + retSqlname("ZX5") + " ZX5 "
	_cQuery += "WHERE ZX5.D_E_L_E_T_ = ' ' "
	_cQuery += "AND ZX5_GRUPO = '000007' "
	_cQuery += "AND ZX5_SEGISP = '" + _cSeg + "' "
	
	_cQuery := ChangeQuery(_cQuery)
	
	TCQUERY _cQuery NEW ALIAS "TMPZX5"
	
	_nTot := (3 - LEN(Alltrim(Str(TMPZX5->CODIGO))))
	
	_cCodigo := PADR('000',_nTot) + Alltrim(Str(TMPZX5->CODIGO))
	
	aCols[n][_nZX5_COD] := _cCodigo
	
	IF SELECT("TMPZX5") > 0
		dbSelectArea("TMPZX5")
		TMPZX5->(dbCloseArea())
	Endif
	
EndIf

Return