#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ TESTETELº Autor ³Juscelino Alves dos Santosº Data ³18/07/14º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Rotina para gerar uma tela de consulta e sugestaão do pedidoº±±
±±º          ³de compra                                                   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ISAPA                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/


User Function TESTETEL()

Local aSizeAut  	:= MsAdvSize()
Local nPosPro		:= 0
Local _cped         :=Space(6)

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
Private aHeadC6 	:= {}
Private cont
Private cDescPI		:= SPACE(40)

oDesc 		:= nil
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
            
/*
cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7") + "' AND SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
cQuery += " (SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) > 0 "
cQuery += " AND SC7.C7_RESIDUO = ' ' And SC7.D_E_L_E_T_ = '' "
cQuery += " ORDER BY SC7.C7_DATPRF "


cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' " 
cQuery += " SC7.D_E_L_E_T_ = '' "
//cQuery += " ORDER BY SC7.C7_DATPRF "

//cQuery := ChangeQuery(cQuery)

If Select("QSC7") <> 0
	QSC7->(dbCloseArea())
Endif
                    
DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QSC7",.T.,.T.)
//TcQuery cQuery New Alias "QSC7"
TCSetField("QSC7","C7_DATPRF","D")

DbSelectArea("QSC7")
QSC7->(dbGoTop())
*/
      /*
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
*/

_flagex:=.F.
Flag:=.t.
AADD(aObjects,{0,41,.T.,.F.,.F.})
AADD(aObjects,{100,100,.T.,.T.,.F.})
aPosObj:=MsObjSize(aInfo,aObjects)

DEFINE MSDIALOG oDlgDsp TITLE "Consulta Pedidos" FROM 0,0 TO 400,840 OF oMainWnd PIXEL
@ 020,010 Say  "Pedido" Size 050,050 OF oDlgDsp PIXEL
@ 019,035 MSGET _cped F3 "SC7" SIZE 060,010 OF oDlgDsp     PIXEL PICTURE "@!" Valid Valida_Tela(_cped)

@ 020,110 Say  "Descrição" Size 050,050 OF oDlgDsp PIXEL
@ 020,140 Get odesc Var cDescPI Picture "@!" WHEN .F. OF oDlgDsp PIXEL



oGet := MSGetDados():New(050,001,175,420,2,"AllWaysTrue","AllWaysTrue",,.T.   ,      ,       ,.T.   ,   ,        ,                   ,        ,                ,    )
oGetTM1 := MsNewGetDados():New(105, 0, 270, 650, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)
Valida_Tela(" ")
//_flagex:=.F.


ACTIVATE MSDIALOG oDlgDsp ON INIT EnchoiceBar(oDlgDsp,{||nOpcA:=1,If(oGet:TudoOk(),oDlgDsp:End(),nOpcA:=0)},{||oDlgDsp:End()})
          
/*
If nOpcA = 1
	fFecha()
Else
	fFecha()
Endif
  */
  
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


Static Function Valida_Tela(_cped)

/*
Dbselectarea("SB1")
Dbsetorder(1)

If Dbseek(xFilial("SB1")+alltrim(cProdSC6))
	
	cDescPI := SB1->B1_DESC
	*/
	aCols := {}
	
	oGet:ForceRefresh()
	
	
	cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
    cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7")+"' AND C7_NUM = '"+_cped+"' " 
    cQuery += " SC7.D_E_L_E_T_ = '' "

/*	
	cQuery := " SELECT C7_NUM,C7_ITEM,C7_QUANT,C7_DATPRF,C7_QUJE,C7_QTDACLA FROM " + RetSqlName("SC7")	+ " SC7 "
	cQuery += " WHERE C7_FILIAL = '"+xFilial("SC7") + "' AND SC7.C7_PRODUTO = '" + cProdSC6 + "' And "
	cQuery += " (SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) > 0 "
	cQuery += " AND SC7.C7_RESIDUO = ' ' And SC7.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY SC7.C7_DATPRF "
	
	cQuery := ChangeQuery(cQuery)
	*/         
	
	If Select("QSC7") <> 0
		QSC7->(dbCloseArea())
	Endif
	
	//TcQuery cQuery New Alias "QSC7"
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cQuery),"QSC7",.T.,.T.)
	TCSetField("QSC7","C7_DATPRF","D")
	
	dbSelectArea("QSC7")
	QSC7->(dbGoTop())
	
	If Eof()
		
		AADD(aCols,Array(Len(aHeader)+1))

/*		
		For _ni := 1 to Len(aHeader)
			
			if cfunction == "TMKA271"
				
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			else
				
				aCols[Len(aCols),_ni] := FieldGet(FieldPos(aHeader[_ni,2]))
			endif
			
		Next
		*/
		aCols[Len(aCols),Len(aHeader)+1] := .f.
		
	EndIf
	
	While !eof()
		
		AADD(aCols,Array(Len(aHeader)+1))
		
		aCols[Len(aCols)] := {QSC7->C7_NUM,QSC7->C7_ITEM,QSC7->C7_QUANT - QSC7->C7_QUJE - QSC7->C7_QTDACLA,QSC7->C7_DATPRF,.f.}
		
		
		Dbselectarea("QSC7")
		dbSkip()
	EndDo
	
	
	oGet:ForceRefresh()
	
//Endif

Return .t.
