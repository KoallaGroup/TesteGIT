#include "protheus.ch"
#include "topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|
|	Programa : IFATA07			  		| 	Março de 2014							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|
|	Descrição : Amarração de Vendedor x Transportador											 		|
|-------------------------------------------------------------------------------------------------------|
*/


user Function IFATA07(cTransp)

Local aAreaVend	:= GetArea()

If Empty(cTransp)

	_cQuery := "SELECT COUNT(*) TOT "
	_cQuery += "FROM " + retSqlname("SZI") + " SZI "
	_cQuery += "WHERE SZI.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND ZI_VEND = '" + SA3->A3_COD + "' "
	_cQuery += "  AND ZI_TIPO = 'T' "
	
	TCQUERY _cQuery NEW ALIAS "TMPSZI"
	
	_nTot := TMPSZI->TOT
	
	TMPSZI->(dbCloseArea())
	
	If _nTot == 0
		
		msgAlert ("Não existe nenhuma Transportadora vinculada a esse vendedor !!")
		U_IFATA06()
		
	Else
		IFATA07A
		
	EndIf

Else
	IFATA07C(cTransp)

EndIf	

RestArea(aAreaVend)

Return()


static Function IFATA07A()

Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}
Local nLinha:= nLin02 	:= nOpca := 0, oDlg, oGet
Local nOpcx := 2
Local cSeek	:= xFilial("SZI")+SA3->A3_COD+'T'
Local cWhile:= "SZI->(ZI_FILIAL+ZI_VEND+ZI_TIPO)"
Local aYesFields:= {}
Local aNoFields	:= {}
Local cCadastro	:= "Vendedor x Transportador x Redespacho"

//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0]

oFont := tFont():New("Tahoma",,-14,,.t.)

aadd(aYesFields, "ZI_TRANSP")
aadd(aYesFields, "ZI_NMETRAN")

//Cria aHeader e aCols
FillGetDados(nOpcx,"SZI",3,cSeek,{|| &cWhile },{||.T.},aNoFields,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 20
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,020,045,058,150,170,128,143,172,186,205,222,250,270}})

@nLinha, aPosGet[1,01] Say "Codigo :"		SIZE 25,10 OF oDlg PIXEL
@nLinha, aPosGet[1,02] Say SA3->A3_COD 		SIZE 18,10 OF oDlg PIXEL

@nLinha, aPosGet[1,03] Say "Vendedor :"		SIZE 40,10 OF oDlg PIXEL
@nLinha, aPosGet[1,04] Say SA3->A3_NOME 	SIZE 180,10 OF oDlg PIXEL

@nLin02, aPosGet[1,01] say "Selecione a Transportadora e clique em confirmar" FONT oFont SIZE 200,10 OF oDlg PIXEL

oGet := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"allwaystrue","allwaystrue","",.T.)
Private oGetDad := oGet

_cTrans := ""
ACTIVATE MSDIALOG oDlg On Init IFATA07B(oDlg,{||nOpca:=1, _cTrans := aCols[n][1], oDlg:End()}, {||oDlg:End()})

if nOpca == 1
	
	IFATA07C(_cTrans)
	
endif


RestArea(aArea)
Return (nOpca)



Static Function IFATA07B(oDlg,bOk,bCancel,nOpc)

Local aButtons   := {}

Return (EnchoiceBar(oDlg,bOK,bcancel,,aButtons))



Static Function IFATA07C(_cTrans)

Local aArea	:= GetArea(), aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}, aRecno := {}
Local nLinha:= nLin02 := nOpca := 0, oDlg2, oGet2
Local nOpcx := 4
Local cSeek	:= xFilial("SZI")+SA3->A3_COD+'R'+_cTrans
Local cWhile:= "SZI->(ZI_FILIAL+ZI_VEND+ZI_TIPO+ZI_TRANSP)"
Local aYesFields:= {}
Local aNoFields	:= {}
Local cCadastro	:= "Vendedor x Transportador x Redespacho"

//Monta a entrada de dados do arquivo
Private aTela[0][0],aGets[0],aHeader[0],aCols[0]

aadd(aYesFields, "ZI_REDESP")
aadd(aYesFields, "ZI_NMEREDE")

//Cria aHeader e aCols
FillGetDados(nOpcx,"SZI",3,cSeek,{|| &cWhile },{||.T.},aNoFields,aYesFields,/*lOnlyYes*/,/*cQuery*/,/*bMontCols*/,.F.)

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{100,100,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg2 TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
nLinha  := aPosObj[1,1] + 4
nLin02  := aPosObj[1,1] + 15
aPosGet := MsObjGetPos(aSize[3]-aSize[1],315,{{004,030,045,058,150,170,128,143,172,186,205,222,250,270} } )

@nLinha, aPosGet[1,01] Say "Vendedor :"		SIZE 40,10 OF oDlg2 PIXEL
@nLinha, aPosGet[1,02] Say SA3->A3_COD + ' - ' + SA3->A3_NOME 	SIZE 300,10 OF oDlg2 PIXEL

@nLin02, aPosGet[1,01] Say "Transportadora :"		SIZE 45,10 OF oDlg2 PIXEL
@nLin02, aPosGet[1,02] Say _cTrans + ' - ' + posicione("SA4",1, xFilial("SA4")+_cTrans, "A4_NOME") 	SIZE 300,10 OF oDlg2 PIXEL

oGet2 := MSGetDados():New(aPosObj[2,1],aPosObj[2,2],aPosObj[2,3],aPosObj[2,4],nOpcx,"U_IFATA07C(_cTrans)","U_IFATA07D()","",.T.)
Private oGetDad := oGet2

ACTIVATE MSDIALOG oDlg2 On Init IFATA07B(oDlg2,{||nOpca:=1, if(oGet2:TudoOk(),oDlg2:End(),nOpca := 1)}, {||oDlg2:End()})

if nOpca == 1
	IFATA07E(_cTrans)
endif

RestArea(aArea)

return


user Function IFATA07C(_cTrans)

local _lRet := .T.
local _nZI_REDESP	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_REDESP" })

if aCols[n][_nZI_REDESP] == _cTrans
	alert ("Essa Transportadora é a que está recebendo relacionamento de Redespacho !!")
	_lRet := .F.
endif

for x:=1 to len(aCols)
	
	if ! aCols[x][len(aHeader)+1] .and. x <> n
		
		if aCols[x][_nZI_REDESP] == aCols[n][_nZI_REDESP]
			If !aCols[n][len(aHeader)+1]
				alert ("Já existe esse Redespacho relacionado com esse Vendedor e Transportadora !!")
				_lRet := .F.
				exit
			EndIf
		endif
		
	endif
next x

return _lRet



user Function IFATA07D()	// confirmar

local _lRet := .T.

return _lRet


static Function IFATA07E(_cTrans)

local _nZI_REDESP	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_REDESP" })
local _nRecno		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "ZI_REC_WT" })

dbSelectArea("SZI")

for x:=1 to len(aCols)
	
	if ! aCols[x][len(aHeader)+1]
		
		if aCols[x][_nRecno] > 0
			_cGrava := .F.
			go aCols[x][_nRecno]
		else
			_cGrava := .T.
		endif
		
		do while !reclock("SZI",_cGrava)
		enddo
		
		SZI->ZI_FILIAL := xFilial("SZI")
		SZI->ZI_VEND   := SA3->A3_COD
		SZI->ZI_TIPO   := "R"
		SZI->ZI_REDESP := aCols[x][_nZI_REDESP]
		SZI->ZI_TRANSP := _cTrans
		
		if _cGrava
//			SZI->ZI_DTINCL 	:= date()
//			SZI->ZI_HRINCL 	:= time()
		else
//			SZI->ZI_DTALT 	:= date()
//			SZI->ZI_HRALT 	:= time()
		endif
		
		msUnlock()
		
	else
		
		if aCols[x][_nRecno] > 0
			go aCols[x][_nRecno]
			
			do while !reclock("SZI", .F.)
			enddo
			
			delete
			
			msUnlock()
		endif
		
	endif
	
next x

msgAlert ("Redespacho atualizado com Sucesso !!")

return

