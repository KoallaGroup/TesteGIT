#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+----------------+
| Programa:  | ITMKR16 | Autor: | Rogério Alves      | Data: |   Abril/2015   |
+------------+---------+--------+--------------------+-------+----------------+
| Descrição: | Relatório de Vendas Perdidas                                   |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/

User Function ITMKR16()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12
Local aPergs	:= {}

Private oGroup1, oGroup2, oGroup3
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private dDtIni	 	:= Space( 08 )
Private dDtFim	 	:= Space( 08 )
Private cLocIni		:= Space( avSx3("UA_FILIAL"	,3) )
Private cLocFim 	:= Space( avSx3("UA_FILIAL"	,3) )
Private cSegIni		:= Space( avSx3("A1__SEGISP",3) )
Private cSegFim		:= Space( avSx3("A1__SEGISP",3) )
Private cMotIni		:= Space( avSx3("ZN_MOTIVO"	,3) )
Private cMotFim 	:= Space( avSx3("ZN_MOTIVO"	,3) )
Private cCliIni		:= Space( avSx3("A1_COD"	,3) )
Private cCliFim		:= Space( avSx3("A1_COD"	,3) )
Private cLjIni		:= Space( avSx3("A1_LOJA"	,3) )
Private cLjFim		:= Space( avSx3("A1_LOJA"	,3) )
Private cProdIni	:= Space( avSx3("B1_COD"	,3) )
Private cProdFim	:= Space( avSx3("B1_COD"	,3) )

Private nTpRel		:= 1
Private nTpOri		:= 1

Private oDtIni, oDtFim, oLocIni, oLocFim, oSegIni, oSegFim, oMotIni, oMotFim, oCliIni, oCliFim, oLjIni, oLjFim, oProdIni, oProdFim
Private oRadSub1, oRadSub2, oRadSub3, oButProc, oButProc1, oCheckBo1, oDescSeg

Private cPerg		:= PADR("ITMKR16",Len(SX1->X1_GRUPO))
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

Aadd(aPergs,{"A Partir do Local        ","","","mv_ch1","C",TamSx3("UA_FILIAL")[1]	,0,0,"G","","MV_PAR01",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Até o Local              ","","","mv_ch2","C",TamSx3("UA_FILIAL")[1]	,0,0,"G","","MV_PAR02",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"A Partir do Segmento     ","","","mv_ch3","C",TamSx3("A1__SEGISP")[1]	,0,0,"G","","MV_PAR03",""	,"","","","" 	  ,"","","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"Até o Segmento           ","","","mv_ch4","C",TamSx3("A1__SEGISP")[1]	,0,0,"G","","MV_PAR04",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"A Partir do Motivo       ","","","mv_ch5","C",TamSx3("UA__MOTCAN")[1]	,0,0,"G","","MV_PAR05",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","SZDTA"	,"","","",""})
Aadd(aPergs,{"Até o Motivo             ","","","mv_ch6","C",TamSx3("UA__MOTCAN")[1]	,0,0,"G","","MV_PAR06",""	,"","","","ZZZZZ" ,"","","","","","","","","","","","","","","","","","","","SZDTA"	,"","","",""})
Aadd(aPergs,{"A Partir Data do Pedido  ","","","mv_ch7","D",08						,0,0,"G","","MV_PAR07",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até Data do Pedido       ","","","mv_ch8","D",08						,0,0,"G","","MV_PAR08",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"A Partir do Produto      ","","","mv_ch9","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR09",""	,"","","","" 	  ,"","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
Aadd(aPergs,{"Até o Produto            ","","","mv_chA","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR10",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
Aadd(aPergs,{"A Partir da Entidade     ","","","mv_chB","C",TamSx3("A1_COD")[1]		,0,0,"G","","MV_PAR11",""	,"","","","" 	  ,"","","","","","","","","","","","","","","","","","","","SA1"	,"","","",""})
Aadd(aPergs,{"Até a Entidade           ","","","mv_chC","C",TamSx3("A1_COD")[1]		,0,0,"G","","MV_PAR12",""	,"","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","SA1"	,"","","",""})
Aadd(aPergs,{"A Partir da Loja         ","","","mv_chD","C",TamSx3("A1_LOJA")[1]	,0,0,"G","","MV_PAR13",""	,"","","","" 	 ,"","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até a Loja               ","","","mv_chE","C",TamSx3("A1_LOJA")[1]	,0,0,"G","","MV_PAR14",""	,"","","","ZZ"	 ,"","","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

cLocIni		:= MV_PAR01
cLocFim 	:= MV_PAR02
cSegIni		:= MV_PAR03
cSegFim		:= MV_PAR04
cMotIni		:= MV_PAR05
cMotFim 	:= MV_PAR06
dDtIni	 	:= MV_PAR07
dDtFim	 	:= MV_PAR08
cProdIni	:= MV_PAR09
cProdFim	:= MV_PAR10
cCliIni		:= MV_PAR11
cCliFim		:= MV_PAR12
cLjIni		:= MV_PAR13
cLjFim		:= MV_PAR14

DEFINE MSDIALOG oDlg TITLE "Relação de Vendas Perdidas" FROM 000, 000  TO 473, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+195,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel

@ nLinSay,aPosGet[1,01]    GROUP   	oGroup2 TO nLinSay+30,aPosGet[1,01]+285 PROMPT "Tipo de Relatório"   					OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,01]+20 RADIO oRadSub1 	VAR nTpRel Prompt OemToAnsi("Cliente"),OemToAnsi("Produto"),OemToAnsi("Motivo") SIZE 100, 045 OF oDlg Pixel
nLinSay += 38
nLinGet += 38

@ nLinSay+06, aPosGet[1,01]+120 RADIO oRadSub2 	VAR nTpOri Prompt OemToAnsi("CAC"),OemToAnsi("LFI") SIZE 60, 045 OF oDlg Pixel

@ nLinSay, aPosGet[1,01] SAY      	oSay1       PROMPT "A Partir do Local / Origem "	        SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oLocIni   	VAR cLocIni	Picture PesqPict("SUA","UA_FILIAL")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "DLB" 	Valid ValLocal(cLocIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay2       PROMPT "Até o Local / Origem "	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oLocFim   	VAR cLocFim	Picture PesqPict("SUA","UA_FILIAL")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "DLB" 	Valid ValLocal(cLocFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay3       PROMPT "A Partir do Segmento "	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oSegIni   	VAR cSegIni	Picture PesqPict("SA1","A1__SEGISP")SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SZ72" 	Valid ValSeg(cSegIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay4       PROMPT "Até o Segmento "	                	SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oSegFim   	VAR cSegFim	Picture PesqPict("SA1","A1__SEGISP")SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SZ72" 	Valid ValSeg(cSegFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay5       PROMPT "A Partir do Motivo "	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oMotIni   	VAR cMotIni	Picture PesqPict("SUA","UA__MOTCAN")SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SZD_IT" 	Valid ValMotivo(cMotIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay6       PROMPT "Até o Motivo "         					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oMotFim   	VAR cMotFim	Picture PesqPict("SUA","UA__MOTCAN")SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SZD_IT" 	Valid ValMotivo(cMotFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay7     	PROMPT "A Partir da Data do Pedido"    			SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oDtIni   	VAR dDtIni	Picture "@D"						SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay8     	PROMPT "Até a Data do Pedido"    				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oDtFim   	VAR dDtFim	Picture "@D"						SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay9       PROMPT "A Partir da Entidade / Loja "	        SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oCliIni    	VAR cCliIni	Picture PesqPict("SA1","A1_COD")	SIZE 060, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA1" 	Valid ValCliente(cCliIni,1)
@ nLinGet, aPosGet[1,02]+95 MSGET   oLjIni    	VAR cLjIni	Picture PesqPict("SA1","A1_LOJA")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay10      PROMPT "Até a Entidade / Loja "         		SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oCliFim    	VAR cCliFim	Picture PesqPict("SA1","A1_COD")	SIZE 060, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA1" 	Valid ValCliente(cCliFim,2)
@ nLinGet, aPosGet[1,02]+95 MSGET   oLjFim    	VAR cLjFim	Picture PesqPict("SA1","A1_LOJA")	SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      	oSay11       PROMPT "A Partir do Produto "	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oProdIni   	VAR cProdIni Picture PesqPict("SB1","B1_COD")	SIZE 060, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SB1" 	Valid ValProd(cProdIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay12       PROMPT "Até o Produto "         					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oProdFim   	VAR cProdFim Picture PesqPict("SUA","UA__MOTCAN")SIZE 060, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SB1" 	Valid ValProd(cProdFim,2)

nLinSay += 23
nLinGet += 23

oRadSub1:bChange := {|| U_AtuTpRel(nTpRel)}

oRadSub1:lHoriz := .T.
oRadSub2:lHoriz := .T.

@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action (GeraRel(),oDlg:end())	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+78  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

U_AtuTpRel(nTpRel)


ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraRel			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina para verificação dos filtros de tela e geração do relatório em crystal   |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GeraRel()

Local _cRelato	:= ""
Local _cParams	:= ""
Local _cOptions := ""
Local _TpOri	:= ""

GravaSx1()

If nTpOri == 1
	_TpOri := "A"
ElseIf nTpOri == 2
	_TpOri := "B"
EndIf
		
If nTpRel == 1
	
	_cRelato	:= "ITMKCR16A"
	_cOptions	:= "1;0;1;Relação de Vendas Perdidas por Cliente"
	
	_cParams 	:= cLocIni 					+ ";"
	_cParams 	+= cLocFim 					+ ";"	
	_cParams 	+= cSegIni					+ ";"
	_cParams 	+= cSegFim	 				+ ";"	
	_cParams 	+= cMotIni			   		+ ";"
	_cParams 	+= cMotFim					+ ";"	
	_cParams 	+= cCliIni   				+ ";"
	_cParams 	+= cCliFim	 				+ ";"	
	_cParams 	+= cLjIni	 				+ ";"
	_cParams	+= cLjFim	 				+ ";"
	_cParams 	+= Alltrim(DTOS(dDtIni))	+ ";"	
	_cParams 	+= Alltrim(DTOS(dDtFim))	+ ";"	
	_cParams 	+= _TpOri
	
ElseIf nTpRel == 2
	
	_cRelato	:= "ITMKCR16B"
	_cOptions 	:= "1;0;1;Relação de Vendas Perdidas por Produto"
	
	_cParams 	:= cLocIni 					+ ";"
	_cParams 	+= cLocFim 					+ ";"	
	_cParams 	+= cSegIni					+ ";"
	_cParams 	+= cSegFim	 				+ ";"	
	_cParams 	+= cMotIni			   		+ ";"
	_cParams 	+= cMotFim					+ ";"		
	_cParams 	+= Alltrim(DTOS(dDtIni))	+ ";"	
	_cParams 	+= Alltrim(DTOS(dDtFim))	+ ";"	
	_cParams 	+= cProdIni   				+ ";"
	_cParams 	+= cProdFim	 				+ ";"	
	_cParams 	+= _TpOri
	
ElseIf nTpRel == 3
	
	_cRelato	:= "ITMKCR16C"
	_cOptions 	:= "1;0;1;Relação de Vendas Perdidas por Motivo" 
	
	_cParams 	:= cLocIni 					+ ";"
	_cParams 	+= cLocFim 					+ ";"	
	_cParams 	+= cSegIni					+ ";"
	_cParams 	+= cSegFim	 				+ ";"	
	_cParams 	+= cMotIni			   		+ ";"
	_cParams 	+= cMotFim					+ ";"		
	_cParams 	+= Alltrim(DTOS(dDtIni))	+ ";"	
	_cParams 	+= Alltrim(DTOS(dDtFim))	+ ";"		
	_cParams 	+= _TpOri
		
EndIf

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

aAdd( aSx1, {cLocIni, cLocFim, cSegIni, cSegFim, cMotIni, cMotFim, dtos(dDtIni), dtos(dDtFim), cProdIni, cProdFim, cCliIni, cCliFim, cLjIni, cLjFim} )

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
|	Descrição : Valida Local                                                                    |
|-----------------------------------------------------------------------------------------------|
*/


static function ValLocal(_cLoc,_nSt)

Local _aArea	:= GetArea()
Local _aAreaSZE	:= SZE->(GetArea())
Local _lRet		:= .T.

If "Z" $ Upper(_cLoc) .and. _nSt == 2
	cLocFim := "ZZ"
	oLocFim:Refresh()
Else
	If !Empty(_cLoc)
		dbSelectArea("SZE")
		dbSetOrder(1)
		if !dbSeek(cEmpAnt+_cLoc)
			msgAlert("Local não cadastrado !!")
			_lRet := .F.
		EndIf
	EndIf
	
EndIf

RestArea(_aAreaSZE)
RestArea(_aArea)

return _lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValSeg			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o segmento do usuário									  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValSeg(cSegmento,_nSt)

local _aArea := getArea()
local _lRet  := .T.

If "Z" $ Upper(cSegmento) .and. _nSt == 2
	cSegFim := "ZZ"
	oSegFim:Refresh()
Else
	If !Empty(cSegmento)
		
		dbSelectArea("SZ7")
		dbSetOrder(1)
		if !dbSeek(xFilial("SZ7")+cSegmento)
			msgAlert("Segmento não cadastrado !!")
			_lRet := .F.
		else
			cDesSeg := SZ7->Z7_DESCRIC
		endif
		
	EndIf
EndIf

restarea(_aArea)

return _lRet




/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValMotivo			 	| 	Abril de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Motivo do cancelamento								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValMotivo(_cMot,_nSt)

Local _aArea 	:= getArea()
Local _lRet		:= .T.

If "Z" $ Upper(_cMot) .and. _nSt == 2
	cMotFim := "ZZZZZ"
	oMotFim:Refresh()
Else
	If !Empty(_cMot)
		DbSelectArea("SZD")
		DbSetOrder(1)
		If !(DbSeek(xFilial("SZD") + _cMot,.f.))
			MsgAlert("Motivo de Cancelamento não cadastrado","Atenção")
			_lRet := .F.
		EndIf
	EndIf
EndIf

restarea(_aArea)

return _lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValCliente			 	| 	Abril de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Cliente 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValCliente(_cCli,_nSt)

Local _aArea 	:= getArea()
Local _lRet		:= .T.

If "Z" $ Upper(_cCli) .and. _nSt == 2  

	cCliFim := "ZZZZZZZZZZZZZZ"
	oCliFim:Refresh()
	cLjFim := "ZZZZ"
	OLjFim:Refresh()

Else
	If !Empty(_cCli)
		DbSelectArea("SA1")
		DbSetOrder(1)
		If !(DbSeek(xFilial("SA1") + _cCli,.f.))
			MsgAlert("Cliente não cadastrado","Atenção")
			_lRet := .F.
		EndIf
	EndIf
EndIf

restarea(_aArea)

return _lRet




/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValProd  			 	| 	Abril de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Produto 												  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValProd(_cProd,_nSt)

Local _aArea 	:= getArea()
Local _lRet		:= .T.

If "Z" $ Upper(_cProd) .and. _nSt == 2
	cProdFim := "ZZZZZZZZZZZZZZZ"
	oProdFim:Refresh()
Else
	If !Empty(_cProd)
		DbSelectArea("SB1")
		DbSetOrder(1)
		If !(DbSeek(xFilial("SB1") + _cProd,.f.))
			MsgAlert("Produto não cadastrado","Atenção")
			_lRet := .F.
		EndIf
	EndIf
EndIf

restarea(_aArea)

return _lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuMod			 	| 	Abril de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Verifica tipo de relatório para habilitar campos                                |
|-----------------------------------------------------------------------------------------------|
*/


User Function AtuTpRel(nTpRel)

if nTpRel == 1

	cProdIni	:= Space( avSx3("B1_COD"	,3) )
	cProdFim	:= Space( avSx3("B1_COD"	,3) )
		
	oProdIni:lActive	:= .f.
	oProdFim:lActive	:= .f.
	oCliIni:lActive		:= .t.
	oCliFim:lActive		:= .t.
	oLjIni:lActive		:= .t.
	oLjFim:lActive		:= .t.
	
Elseif nTpRel == 2

	cCliIni		:= Space( avSx3("A1_COD"	,3) )
	cCliFim		:= Space( avSx3("A1_COD"	,3) )
	cLjIni		:= Space( avSx3("A1_LOJA"	,3) )
	cLjFim		:= Space( avSx3("A1_LOJA"	,3) )
		
	oProdIni:lActive	:= .t.
	oProdFim:lActive	:= .t.
	oCliIni:lActive		:= .f.
	oCliFim:lActive		:= .f.
	oLjIni:lActive		:= .f.
	oLjFim:lActive		:= .f.
	
Elseif nTpRel == 3

	cProdIni	:= Space( avSx3("B1_COD"	,3) )
	cProdFim	:= Space( avSx3("B1_COD"	,3) )
	cCliIni		:= Space( avSx3("A1_COD"	,3) )
	cCliFim		:= Space( avSx3("A1_COD"	,3) )
	cLjIni		:= Space( avSx3("A1_LOJA"	,3) )
	cLjFim		:= Space( avSx3("A1_LOJA"	,3) )
		
	oProdIni:lActive	:= .f.
	oProdFim:lActive	:= .f.
	oCliIni:lActive		:= .f.
	oCliFim:lActive		:= .f.
	oLjIni:lActive		:= .f.
	oLjFim:lActive		:= .f.
	
Endif

oProdIni:Refresh()
oProdFim:Refresh()
oCliIni:Refresh()
oCliFim:Refresh()
oLjIni:Refresh()
oLjFim:Refresh()
oDlg:Refresh()

Return(.t.)
