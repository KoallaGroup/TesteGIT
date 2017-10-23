#include "protheus.ch"
#INCLUDE "TOPCONN.CH"
#include "Colors.ch"


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMA14			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi										|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta Especifica de Relacionamento de Fornecedores x Grupos				  	|
|-----------------------------------------------------------------------------------------------|
*/

Static _cICOMA14B := Space(10)
Static _cICOMA14C := Space(10)

User Function ICOMA14()

local _aArea	:= getArea()

private aButtons   	:= {}
private _cGrupo 	:= cGet1
private _cDesc 		:= cDesGr
private _cSegto		:= criaVar("ZX5_SEGISP")
private oDlg		:= nil
private oGetTM1		:= nil

oFont := tFont():New("Tahoma",,-12,,.t.)

DEFINE MSDIALOG oDlg TITLE "Cadastro de Relacionamento entre Grupos x Fornecedores" From 10,0 To 500,900 OF oMainWnd PIXEL

@ 12,10  Say "Grupo :"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 12,100 Say "Descricao :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL
//	@ 12,350 Say "Segmento :" 	FONT oFont SIZE 80,10 OF oDlg PIXEL

@ 10,35  MsGet _cGrupo when .F.	Size 50,10 of oDlg 	PIXEL FONT oFont //	F3 "ZX5COM" valid montaAcols()
@ 10,135 MsGet _cDesc  when .F.	Size 200,10 of oDlg PIXEL FONT oFont
//    @ 10,390 MsGet _cSegto when .F. Size 10,10 of oDlg 	PIXEL FONT oFont

montaAcols()

lOk := .F.

ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=.T.,oDlg:End()},{||oDlg:End()},,aButtons) })

_cFornece 	:= ""
_cLoja		:= ""

if lOk
	_cFornece 	:= oGetTM1:aCols[oGetTM1:nat][1]
	_cLoja		:= oGetTM1:aCols[oGetTM1:nat][2]
endif

restArea(_aArea)

_cICOMA14B := _cFornece
_cICOMA14C := _cLoja

Return .T.


static function montaAcols(nOpc)

private aHeader	:= {}
private aCols	:= {}
private aEdit	:= {}

aCpoHeader   	:= {"Z02_CODFOR", "A2_LOJA",  "A2_NREDUZ", "A2_ESTADO", "A2_MUN"}

dbSelectArea("ZX5")
dbSetOrder(1)
if dbSeek(xFilial("ZX5")+space(2)+"000001"+M->_cGrupo)
	M->_cDesc	:= ZX5->ZX5_DSCITE
	M->_cSegto	:= ZX5->ZX5_SEGISP
endif

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		aadd(aHeader, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid        ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3    	 	,;
		SX3->X3_Context		,;
		SX3->X3_Cbox		,;
		SX3->X3_relacao		,;
		SX3->X3_when})
	Endif
Next _nElemHead

_cQuery := "SELECT Z02_CODFOR, Z02_LOJA, A2_NREDUZ, A2_EST, A2_MUN "
_cQuery += "FROM " + retSqlName("Z02") + " Z02 "
_cQuery += "INNER JOIN " + retSqlName("SA2") + " SA2 ON A2_COD = Z02_CODFOR AND Z02_LOJA = A2_LOJA AND SA2.D_E_L_E_T_ = ' ' "
_cQuery += "WHERE Z02_GRUPO = '" + _cGrupo + "' "
_cQuery += "AND Z02.D_E_L_E_T_ = ' ' "
If !Empty(cForOri)
	_cQuery += "AND TRIM(Z02_CODFOR) || TRIM(Z02_LOJA) <> '" + Alltrim(cForOri) + Alltrim(cGet5) + "' "
EndIf

_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias "TRB_Z02"

do while ! TRB_Z02->(eof())
	aadd (aCols, { TRB_Z02->Z02_CODFOR, TRB_Z02->Z02_LOJA, TRB_Z02->A2_NREDUZ, TRB_Z02->A2_EST, TRB_Z02->A2_MUN, .F.})
	TRB_Z02->(dbSkip())
enddo

TRB_Z02->(dbCloseArea())

_cGds := nil

oGetTM1 := MsNewGetDados():New(30, 0, 230, 453, _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)

GETDREFRESH()

return


user function ICOM14B()

return _cICOMA14B


user function ICOM14C()

return _cICOMA14C
