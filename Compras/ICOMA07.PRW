#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMA07			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Cadastro de Relacionamento de Fornecedores x Grupos							  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMA07()

Private aRotina  := {{"Visualizacao",	"U_TELAZ02",0,2},;
{"Inclusao",		"U_TELAZ02",0,3} ,;
{"Alteracao",		"U_TELAZ02",0,4} ,;
{"Exclusao",		"U_TELAZ02",0,5}}

dbSelectArea("Z02")

MBrowse( 6,1,22,75,'Z02',,,,,,)

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Função : TELASZ2			 		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Tela de Cadastro															  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function TELAZ02(cAlias, nReg, nOpc)

local _aArea	:= getArea()

private aButtons   	:= {}
private _cGrupo 	:= criaVar("ZX5_CODIGO")
private _cDesc 		:= criaVar("ZX5_DSCITE")
private _cSegto		:= criaVar("ZX5_SEGISP")
private oDlg		:= nil
private oGetTM1		:= nil, aPosObj := {}

oFont := tFont():New("Tahoma",,-12,,.t.)

if ! INCLUI
	_cGrupo	:= Z02->Z02_GRUPO
	_cDesc	:= Z02->Z02_DSCGRP
	_cSegto	:= posicione("ZX5",1,xFilial("ZX5")+space(2)+"000001"+Z02->Z02_GRUPO,"ZX5_SEGISP")
endif

aSize := MsAdvSize()

aObjects := {}
//AAdd(aObjects,{100,030,.t.,.f.})
//AAdd(aObjects,{400,400,.t.,.t.})
AAdd(aObjects, { 100, 100, .t., .t. } )

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE "Cadastro de Relacionamento entre Grupos x Fornecedores" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

@ 10,10  Say "Grupo :"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 10,160 Say "Descricao :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 10,500 Say "Segmento :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL

@ 10,50  MsGet _cGrupo when INCLUI  Size 50,10 of oDlg PIXEL FONT oFont 	Picture "@!" Valid Empty(_cGrupo) .Or. ICOMA07G()
@ 10,210 MsGet _cDesc  when INCLUI	Size 200,10 of oDlg PIXEL FONT oFont 	Picture "@!"
@ 10,550 MsGet _cSegto when INCLUI	Size 10,10 of oDlg PIXEL FONT oFont 	F3 "SZ7" Valid Valid Empty(_cSegto) .Or. ExistCpo("SZ7",_cSegto)

lOk := .F.

montaAcols(nOpc)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=validar(nOpc)},{||oDlg:End()},,aButtons) })

restArea(_aArea)

Return


static function montaAcols(nOpc)

private aHeader	:= {}
private aCols	:= {}
private aEdit	:= {}

if ! alltrim(str(nOpc)) $ '1/4'
	aEdit	:= {"Z02_CODFOR","Z02_LOJA"}
endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("Z02_CODFOR")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	"u_ICOMA07B()"     ,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("Z02_LOJA")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	"u_ICOMA07L()"     ,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3          ,;
	SX3->X3_Context     ,;
	SX3->X3_Cbox        ,;
	SX3->X3_relacao     ,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("Z02_DSCFOR")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	SX3->X3_VALID     	,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

aadd( aHeader, {"Recno WT", "Z02_REC_WT", "", 09, 0,,, "N", "Z02", "V"} )

if ! INCLUI
	_cQuery := "SELECT Z02_CODFOR, Z02_LOJA,A2_NOME, Z02.R_E_C_N_O_ R_E_C_N_O_  FROM "	+ retSqlName("Z02") + " Z02 "
	_cQuery += "INNER JOIN " + retSqlName("SA2") + " SA2 ON A2_COD = Z02_CODFOR And A2_LOJA = Z02_LOJA "
	_cQuery += "  										AND SA2.D_E_L_E_T_ <> '*' "
	_cQuery += "WHERE Z02_GRUPO = '" + Z02->Z02_GRUPO + "' "
	_cQuery += "  AND Z02.D_E_L_E_T_ <> '*' "
	
	TcQuery _cQuery New Alias "TRB_Z02"
	
	do while ! TRB_Z02->(eof())
		aadd (aCols, { TRB_Z02->Z02_CODFOR, TRB_Z02->Z02_LOJA, TRB_Z02->A2_NOME, TRB_Z02->R_E_C_N_O_, .F.})
		
		TRB_Z02->(dbSkip())
	enddo
	TRB_Z02->(dbCloseArea())
endif

if nOpc == 1 .or. nOpc == 5
	_cGds := nil
else
	_cGds := GD_INSERT + GD_UPDATE + GD_DELETE
endif

//oGetTM1 := MsNewGetDados():New(40, 0, 270, 650, _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)
oGetTM1 := MsNewGetDados():New(40,aPosObj[1,2], aPosObj[1,3]-12, aPosObj[1,4], _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)

return


user function ICOMA07B()

local _lVal := .T.
local _nZ02_CodFor  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_CODFOR" })
local _nZ02_LojFor  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_LOJA" })
local _nZ02_DSCFOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_DSCFOR" })

dbSelectArea("SA2")
dbSetOrder(1)
if dbSeek(xFilial("SA2")+ M->Z02_CODFOR + GDFIELDGET("Z02_LOJA"))
	aCols[n][_nZ02_CodFor] := SA2->A2_COD
	aCols[n][_nZ02_LojFOR] := SA2->A2_LOJA
	aCols[n][_nZ02_DSCFOR] := SA2->A2_NOME
else
	msgAlert ("Fornecedor não encontrado. Favor verificar !!")
	_lVal := .F.
endif
return _lVal


user function ICOMA07L()

local _lVal := .T.
local _nZ02_DSCFOR  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_DSCFOR" })
local _nZ02_CodFor  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_CODFOR" })

dbSelectArea("SA2")
dbSetOrder(1)
if dbSeek(xFilial("SA2")+aCols[n][_nZ02_CodFor] + M->Z02_LOJA)
	aCols[n][_nZ02_DSCFOR] := SA2->A2_NOME
else
	msgAlert ("Fornecedor não encontrado. Favor verificar !!")
	_lVal := .F.
endif
return _lVal


static function validar(nOpc)

lOk := .T.

if Inclui .or. Altera
	if empty(M->_cGrupo)
		msgAlert ("O código do Grupo deve ser preenchido. Favor verificar !!")
		lOk := .F.
	endif
	if empty(M->_cDesc)
		msgAlert ("A descrição do Grupo deve ser preenchida. Favor verificar !!")
		lOk := .F.
	endif
	if empty(M->_cSegto)
		lOk := msgYesNo("O segmento não foi informado, deseja prosseguir?")
	endif
	
	if len(oGetTM1:Acols) == 0
		msgAlert ("Nenhum relacionamento lançado !!")
		lOk := .F.
	endif
endif

if lOk
	ICOMA07C(nOpc)
	oDlg:End()
endif
return lOk


static function ICOMA07C(nOpc)

local _nZ02_CODFOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_CODFOR" })
local _nZ02_LOJFOR  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_LOJA" })
local _nZ02_DSCFOR	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_DSCFOR" })
local _nZ02_REC_WT	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "Z02_REC_WT" }), nx := 0

For nx := 1 To Len(oGetTM1:aCols)
	If (oGetTM1:aCols[nx][Len(oGetTM1:aHeader) + 1] .Or. nOpc == 5) .And. nOpc >= 3
		DbSelectArea("Z02")
		DbGoTo(oGetTM1:aCols[nx][_nZ02_REC_WT])
		If (oGetTM1:aCols[nx][_nZ02_REC_WT]) > 0  // Incluido situacao caso a exclusao do registro for no momento da inclusao. Rogerio 30/12/14
			While !Reclock("Z02",.f.)
			EndDo
			DbDelete()
			MsUnlock()
		EndIf
		
		//Exclui o Grupo da ZX5
		If nOpc == 5
			dbSelectArea("ZX5")
			dbSetOrder(1)
			If DbSeek(xFilial("ZX5")+space(TamSX3("ZX5_FILIAL")[1])+"000001"+_cGrupo)
				Reclock("ZX5", .F.)
				DbDelete()
				ZX5->(MsUnlock())
			EndIf
		EndIf
	ElseIf nOpc == 4
		If oGetTM1:aCols[nx][_nZ02_REC_WT] > 0
			DbSelectArea("Z02")
			DbGoTo(oGetTM1:aCols[nx][_nZ02_REC_WT])
			While !Reclock("Z02",.f.)
			EndDo
			Z02->(dbDelete())
			MsUnlock()
		EndIf
	Else
		If !Empty(oGetTM1:aCols[nx][1])
			If oGetTM1:aCols[nx][_nZ02_REC_WT] > 0
				DbSelectArea("Z02")
				DbGoTo(oGetTM1:aCols[nx][_nZ02_REC_WT])
				While !Reclock("Z02",.f.)
				EndDo
			Else
				While !Reclock("Z02",.t.)
				EndDo
				Z02->Z02_FILIAL := xFilial("Z02")
				Z02->Z02_GRUPO  := _cGrupo
				Z02->Z02_DSCGRP := _cDesc
			EndIf
			For ny := 1 To Len(oGetTM1:aHeader)
				FieldPut(FieldPos(oGetTM1:aHeader[ny][2]), oGetTM1:aCols[nx][ny])
			Next ny
			MsUnlock()
			
			dbSelectArea("ZX5")
			dbSetOrder(1)
			if !DbSeek(xFilial("ZX5")+space(TamSX3("ZX5_FILIAL")[1])+"000001"+_cGrupo)
				Reclock("ZX5", .T.)
				ZX5->ZX5_GRUPO  := "000001"
				ZX5->ZX5_DSCGRP := "Grupos p/o Relac. de GruposxFornecedores"
				ZX5->ZX5_CODIGO := _cGrupo
				ZX5->ZX5_DSCITE := _cDesc
				ZX5->ZX5_SEGISP := _cSegto
				ZX5->(msUnlock())
			EndIf
		EndIf
	EndIf
Next nx

if nOpc == 4
	dbSelectArea("ZX5")
	dbSetOrder(1)
	if dbSeek(xFilial("ZX5")+space(2)+"000001"+M->_cGrupo+M->_cSegto)
		reclock("ZX5", .F.)
		ZX5->(dbDelete())
		ZX5->(msUnlock())
	endif
endif


/*
dbSelectArea("ZX5")
dbSetOrder(1)
if ! dbSeek(xFilial("ZX5")+space(2)+"000001"+M->_cGrupo)
reclock("ZX5", .T.)
ZX5->ZX5_GRUPO 	:= "000001"
ZX5->ZX5_DSCGRP	:= "Grupos p/o Relac. de GruposxFornecedores"
ZX5->ZX5_CODIGO	:= M->_cGrupo
ZX5->ZX5_DSCITE	:= M->_cDesc
ZX5->ZX5_SEGISP	:= M->_cSegto

ZX5->(msUnlock())
else
if nOpc == 4
reclock("ZX5", .F.)
ZX5->(dbDelete())
ZX5->(msUnlock())
endif
endif

dbSelectArea("Z02")

if alltrim(str(nOpc)) $ '3/4'
for x:=1 to len(oGetTM1:Acols)

if ! oGetTM1:aCols[x][len(oGetTM1:aHeader)+1]
if oGetTM1:aCols[x][_nZ02_REC_WT] == 0
reclock("Z02", .T.)

Z02->Z02_FILIAL	:= xFilial("Z02")
Z02->Z02_GRUPO 	:= M->_cGrupo
Z02->Z02_DSCGRP	:= M->_cDesc
Z02->Z02_CODFOR	:= oGetTM1:aCols[x][_nZ02_CODFOR]

Z02->(msUnlock())
endif
else

if oGetTM1:aCols[x][_nZ02_REC_WT] > 0

dbSelectArea("Z02")
dbSetOrder(1)
if dbSeek(xFilial("Z02")+M->_cGrupo+oGetTM1:aCols[x][_nZ02_CODFOR])
reclock("Z02", .F.)
Z02->(dbDelete())
Z02->(msUnlock())
endif

endif
endif

next x
elseif nOpc == 4

for x:=1 to len(oGetTM1:Acols)

if oGetTM1:aCols[x][_nZ02_REC_WT] > 0

dbSelectArea("Z02")
dbSetOrder(1)
if dbSeek(xFilial("Z02")+M->_cGrupo+oGetTM1:aCols[x][_nZ02_CODFOR])
reclock("Z02", .F.)
Z02->(dbDelete())
Z02->(msUnlock())
endif

endif

next x

endif
*/
return

//Valida o grupo digitado
Static Function ICOMA07G()

Local _lRet := .t.

If Inclui
	DbSelectArea("Z02")
	DbSetOrder(1)
	If DbSeek(xFilial("Z02") + _cGrupo)
		MsgStop("O código informado já existe, favor verificar.","GRUPO JA CADASTRADO")
		_lRet := .f.
	EndIf
EndIf

Return _lRet
