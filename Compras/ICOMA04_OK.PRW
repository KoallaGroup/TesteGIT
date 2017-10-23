#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | ICOMA04  | Autor |  Rogério Alves  - Anadi  | Data | Abril/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Rotina para consultar Previsao de Chegada compras                |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function ICOMA04(_cProd)

Local aSizeAut  	:= MsAdvSize()
Local nPosPro		:= 0

Private aArea		:= GetArea()
PRIVATE OdlgDsp
PRIVATE odlg1
Private oInf
Private nOpca		:= 0
Private nopc 		:= 0
Private aObjects  	:= {},aPosObj := {}
Private aSize     	:= MsAdvSize()
Private aInfo     	:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
Private cProdSC6  	:= Space(15)
Private aColsC6 	:= {}
Private aHeadC6 	:= {}, nPosC6 := 0
Private cont
Private cDescPI		:= SPACE(40)

Default _cProd := Space(TamSX3("UB_PRODUTO")[1])

oDesc 		:= nil
cFunction 	:= FUNNAME()

If Type("aRotina") != "A"
 aRotina:= { { " " ," " , 0 , 2} }
EndIf

if cfunction == "TMKA271"
	
	nPosPro  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	cProdSC6 := substr(Acols[n,nPosPro],1,TamSX3("UB_PRODUTO")[1])
	
	aColsC6  := aClone(aCols)
	aHeadC6  := aClone(aHeader)
	nPosC6   := n
	
ElseIf cfunction == "MATA410"
	
	nPosPro  := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO" })
	cProdSC6 := substr(Acols[n,nPosPro],1,TamSX3("C6_PRODUTO")[1])
	
	aColsC6  := aClone(aCols)
	aHeadC6  := aClone(aHeader)
	nPosC6   := n
Else
	cProdSC6 := _cProd
	nPosC6 := 1
EndIf

aHeader := {}
aCols 	:= {}
aCols2 	:= {}
n := 1

dbSelectArea("SX3")
dbSetOrder(2)

dbSeek("C7_NUM")
AADD(AHEADER,{"Numero",X3_CAMPO, X3_PICTURE,;
X3_TAMANHO, X3_DECIMAL, X3_VALID,;
X3_USADO, X3_TIPO, X3_ARQUIVO } )

dbSeek("C7_ITEM")
AADD(AHEADER,{"Item",X3_CAMPO, X3_PICTURE,;
X3_TAMANHO, X3_DECIMAL, X3_VALID,;
X3_USADO, X3_TIPO, X3_ARQUIVO } )

dbSeek("C7_Quant")
AADD(AHEADER,{"Quant",X3_CAMPO, X3_PICTURE,;
X3_TAMANHO, X3_DECIMAL, X3_VALID,;
X3_USADO, X3_TIPO, X3_ARQUIVO } )


dbSeek("C7_DATPRF")
AADD(AHEADER,{"Data_Entrega",X3_CAMPO, X3_PICTURE,;
X3_TAMANHO, X3_DECIMAL, X3_VALID,;
X3_USADO, X3_TIPO, X3_ARQUIVO } )

Dbselectarea("SB1")
Dbsetorder(1)
IF Dbseek(xFilial("SB1")+cProdSC6)
	
	cDescPI := SB1->B1_DESC
	
Endif

cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
//cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7") + "' AND SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
cQuery += " WHERE SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
cQuery += " (SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) > 0 "
cQuery += " AND SC7.C7_RESIDUO = ' ' And SC7.D_E_L_E_T_ = '' "
cQuery += " AND SC7.C7_DATPRF <> '' "
cQuery += " ORDER BY SC7.C7_DATPRF "

cQuery := ChangeQuery(cQuery)

If Select("QSC7") <> 0
	QSC7->(dbCloseArea())
Endif

TcQuery cQuery New Alias "QSC7"
TCSetField("QSC7","C7_DATPRF","D")

dbSelectArea("QSC7")
QSC7->(dbGoTop())

If Eof()
	
	AADD(aCols,Array(Len(aHeader)+1))
	
	For _ni := 1 to Len(aHeader)
		
		if cfunction == "TMKA271"
			aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
		else
			aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
		endif
		
	Next
	
	aCols[Len(aCols),Len(aHeader)+1] := .f.
	
EndIf

While !EOF("QSC7")
	
	AADD(aCols,Array(Len(aHeader)+1))
	
	aCols[Len(aCols)] := {QSC7->C7_NUM,QSC7->C7_ITEM,QSC7->C7_QUANT - QSC7->C7_QUJE - QSC7->C7_QTDACLA,QSC7->C7_DATPRF,.f.}
	
	Dbselectarea("QSC7")
	dbSkip()
EndDo

Flag:=.t.
AADD(aObjects,{0,41,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlgDsp TITLE "Consulta Previsão" FROM 0,0 TO 400,840 OF oMainWnd PIXEL
@ 020,010 Say  "Produto" Size 050,050 OF oDlgDsp PIXEL
@ 019,035 MSGET cProdSC6 F3 "SB1LIK" SIZE 060,010 OF oDlgDsp     PIXEL PICTURE "@!" Valid Valida_Tela()

@ 020,110 Say  "Descrição" Size 050,050 OF oDlgDsp PIXEL
@ 020,140 Get odesc Var cDescPI Picture "@!" WHEN .F. OF oDlgDsp PIXEL

oGet := MSGetDados():New(050,001,175,420,2,"AllWaysTrue","AllWaysTrue",,.T.   ,      ,       ,.T.   ,   ,        ,                   ,        ,                ,    )

ACTIVATE MSDIALOG oDlgDsp ON INIT EnchoiceBar(oDlgDsp,{||nOpcA:=1,If(oGet:TudoOk(),oDlgDsp:End(),nOpcA:=0)},{||oDlgDsp:End()})

If nOpcA = 1
	fFecha()
Else
	fFecha()
Endif

If Select("QSC7") <> 0
	QSC7->(dbCloseArea())
Endif

RestArea(aArea)

Return

/*
*****************************************************************************************************
*****************************************************************************************************
&&& fFecha - Retorna o aCols do Item do Pedido de Venda ao Cancelar a Tela
*****************************************************************************************************
*****************************************************************************************************
*/

Static Function fFecha()

aHeader := {}
aCols   := {}

aCols   := aClone(aColsC6)
aHeader := aClone(aHeadC6)
n:=nPosC6

Return()

/*
*****************************************************************************************************
*****************************************************************************************************
&&& Valida_Tela
*****************************************************************************************************
*****************************************************************************************************
*/


Static Function Valida_Tela ()

Dbselectarea("SB1")
Dbsetorder(1)

If Dbseek(xFilial("SB1")+alltrim(cProdSC6))
	
	cDescPI := SB1->B1_DESC
	
	aCols := {}
	
	oGet:ForceRefresh()
	
	cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
	//cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7") + "' AND SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
	cQuery += " WHERE SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
	cQuery += " (SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) > 0 "
	cQuery += " AND SC7.C7_RESIDUO = ' ' And SC7.D_E_L_E_T_ = '' " 
	cQuery += " AND SC7.C7_DATPRF <> '' "
	cQuery += " ORDER BY SC7.C7_DATPRF "
	
	cQuery := ChangeQuery(cQuery)
	
	If Select("QSC7") <> 0
		QSC7->(dbCloseArea())
	Endif
	
	TcQuery cQuery New Alias "QSC7"
	TCSetField("QSC7","C7_DATPRF","D")
	
	dbSelectArea("QSC7")
	QSC7->(dbGoTop())
	
	If Eof()
		
		AADD(aCols,Array(Len(aHeader)+1))
		
		For _ni := 1 to Len(aHeader)
			
			if cfunction == "TMKA271"
				
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			else
				
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			endif
			
		Next
		
		aCols[Len(aCols),Len(aHeader)+1] := .f.
		
	EndIf
	
	While !eof()
		
		AADD(aCols,Array(Len(aHeader)+1))
		
		aCols[Len(aCols)] := {QSC7->C7_NUM,QSC7->C7_ITEM,QSC7->C7_QUANT - QSC7->C7_QUJE - QSC7->C7_QTDACLA,QSC7->C7_DATPRF,.f.}
		
		
		Dbselectarea("QSC7")
		dbSkip()
	EndDo
	
	
	oGet:ForceRefresh()
	
Endif

Return .t.
