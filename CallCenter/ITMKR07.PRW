#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR07 | Autor: | Rogério Alves      | Data: | Janeiro/2015 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relação de vendas por SubGrupo                               |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/


User Function ITMKR07()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9, oSay10, oSay11, oSay12, oSay13, oSay14
Local aPergs	:= {}

Private oTp1, oTp2, oTp3, oTp4, oTp5, oGroup1
Private nTpRel 	:= 1
Private nIdSg	:= 1
Private lQuebra := .f.
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}
Private cEmprIni	:= Space( avSx3("ZE_CODFIL" 	,3) )
Private cEmprDesc 	:= Space( avSx3("ZE_NOMECOM"	,3) )
Private cEmprFim	:= Space( avSx3("ZE_CODFIL" 	,3) )
Private cEmprDesc1 	:= Space( avSx3("ZE_NOMECOM"	,3) ) 
Private cReprIni	:= Space( avSx3("UA_VEND"		,3) )
Private cReprFim 	:= Space( avSx3("UA_VEND"		,3) )
Private dDtIni		:= Space(8)
Private dDtFim	 	:= Space(8)
Private cMarca		:= Space( avSx3("Z5_CODIGO" 	,3) )
Private cMarcaDesc	:= Space( avSx3("Z5_DESC" 		,3) )
Private cSubGIni	:= Space( avSx3("B1__SUBGRP" 	,3) )
Private cSubGFim 	:= Space( avSx3("B1__SUBGRP" 	,3) )
Private cIdenIni	:= Space( avSx3("Z9_COD"    	,3) )
Private cIdenFim 	:= Space( avSx3("Z9_COD"    	,3) )
Private cSegmento	:= Space( avSx3("B1__SEGISP",3) )
Private cSegDesc	:= Space( avSx3("Z7_DESCRIC",3) )
Private cTp1		:= Space(1)
Private cTp2		:= Space(1)
Private cTp3		:= Space(1)
Private cTp4		:= Space(1)
Private cTp5		:= Space(1)
Private oEmprIni, oEmprDesc, oEmprFim, oEmprDesc1, oReprIni, oReprFim, oDtIni, oDtFim, oMarca, oMarcaDesc, oSubGIni, oSubGFim
Private oIdenIni, oIdenFim, oSegmento, oSegDesc, oRadSub, oRadSub2, oButProc
Private cPerg		:= PADR("ITMKR07",Len(SX1->X1_GRUPO))
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
/*
Aadd(aPergs,{"Filial De"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Filial Até"			,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Representante De"		,"","","mv_ch3","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Representante Até"	,"","","mv_ch4","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Data De"				,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Data Até"				,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Sub-Grupo De"			,"","","mv_ch7","C",TamSx3("B1__SUBGRP")[1]	,0,0,"G","","MV_PAR07","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ4"	,"","","",""})
Aadd(aPergs,{"Sub-Grupo Até"		,"","","mv_ch8","C",TamSx3("B1__SUBGRP")[1]	,0,0,"G","","MV_PAR08","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ4"	,"","","",""})
Aadd(aPergs,{"Identificação De"		,"","","mv_ch9","C",TamSx3("Z8_COD")[1]		,0,0,"G","","MV_PAR09","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ8"	,"","","",""})
Aadd(aPergs,{"Identificação Até"	,"","","mv_chA","C",TamSx3("Z8_COD")[1]		,0,0,"G","","MV_PAR10","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ8"	,"","","",""})
Aadd(aPergs,{"Marca"				,"","","mv_chB","C",TamSx3("B1__MARCA")[1]	,0,0,"G","","MV_PAR11","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ5"	,"","","",""})
Aadd(aPergs,{"Tp.Op. 1"				,"","","mv_chC","C",01						,0,0,"G","","MV_PAR12","","","",""					,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. 2"				,"","","mv_chD","C",01						,0,0,"G","","MV_PAR13","","","",""					,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. 3"				,"","","mv_chE","C",01						,0,0,"G","","MV_PAR14","","","",""					,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. 4"				,"","","mv_chF","C",01						,0,0,"G","","MV_PAR15","","","",""					,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. 5"				,"","","mv_chG","C",01						,0,0,"G","","MV_PAR16","","","",""					,"","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Segmento"				,"","","mv_chH","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR17","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)


cEmprIni	:= MV_PAR01
cEmprFim	:= MV_PAR02
cReprIni	:= MV_PAR03
cReprFim 	:= MV_PAR04
dDtIni		:= MV_PAR05
dDtFim	 	:= MV_PAR06
cMarca		:= MV_PAR11
cSubGIni	:= MV_PAR07
cSubGFim 	:= MV_PAR08
cIdenIni	:= MV_PAR09
cIdenFim 	:= MV_PAR10
cSegmento	:= MV_PAR17
cTp1		:= MV_PAR12
cTp2		:= MV_PAR13
cTp3		:= MV_PAR14
cTp4		:= MV_PAR15
cTp5		:= MV_PAR16
*/

AtuFil(cEmprIni,.f.,1)
AtuFil(cEmprFim,.f.,2)
AtuSeg(cSegmento,.f.)
ValMarca(cMarca)

if Empty(dDtIni)
	dDtIni 	:= ctod("01/01/1900")//FirstDay( dDataBase )
Endif

dDtFim   := ctod("31/12/2100")//dDataBase

DEFINE MSDIALOG oDlg TITLE "Relação de Vendas por Sub-Grupo" FROM 000, 000  TO 530, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+215,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
@ nLinSay, aPosGet[1,01] 	SAY     oSay1       PROMPT "A Partir do Local"     						SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oEmprIni    VAR cEmprIni       			When .t.   				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"DLB"		Valid AtuFil(cEmprIni,.f.,1)
@ nLinGet, aPosGet[1,02]+80 MSGET   oEmprDesc   VAR cEmprDesc   			When .f.   				SIZE 150, 008   OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay2       PROMPT "Até o Local" 								SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oEmprFim    VAR cEmprFim       			When .t.   				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"DLB"		Valid AtuFil(cEmprFim,.f.,2)
@ nLinGet, aPosGet[1,02]+80 MSGET   oEmprDesc1  VAR cEmprDesc1   			When .f.   				SIZE 150, 008   OF oDlg COLORS 0, 16777215 PIXEL
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
@ nLinSay, aPosGet[1,01] SAY      	oSay5       PROMPT "A Partir da Data"         					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay-3, aPosGet[1,02]+30 MSGET	oDtIni 	  	VAR dDtIni											SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay6       PROMPT "Até a Data" 	       						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay-3, aPosGet[1,02]+30 MSGET	oDtFim 	  	VAR dDtFim											SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay7       PROMPT "Marca"     	  								SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oMarca  	VAR cMarca		Picture PesqPict("SZ5","Z5_CODIGO")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ5" 	Valid ValMarca(cMarca)
@ nLinGet, aPosGet[1,02]+80 MSGET   oMarcaDesc  VAR cMarcaDesc 			When .f.   					SIZE 150, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay+13, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+13.5,aPosGet[1,04]+135 PROMPT ""   						OF oDlg COLOR  0, 16777215 Pixel
nLinSay += 23
nLinGet += 23
@ nLinSay, aPosGet[1,01] SAY      	oSay8       PROMPT "A Partir do Sub-Grupo"                  	SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oSubGIni    VAR cSubGIni	Picture PesqPict("SB1","B1__SUBGRP")SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ4" 	Valid ValSubG(cSubGIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay9       PROMPT "Até o Sub-Grupo"             				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oSubGFim    VAR cSubGFim	Picture PesqPict("SB1","B1__SUBGRP")SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ4" 	Valid ValSubG(cSubGFim,2)
@ nLinSay, aPosGet[1,04] RADIO	oRadSub 	  VAR nIdSg   Prompt OemToAnsi("Sub Grupo"), OemToAnsi("Identificação") SIZE 080, 008 OF oDlg Pixel
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay10      PROMPT "A Partir da Identificação"                  SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oIdenIni    VAR cIdenIni	Picture PesqPict("SZ9","Z9_COD")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ8001" 	Valid ValIdent(cIdenIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay11     	PROMPT "Até a Identificação"                  		SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oIdenFim   	VAR cIdenFim	Picture PesqPict("SZ9","Z9_COD")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ8001" 	Valid ValIdent(cIdenFim,2)
@ nLinSay+13, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+13.5,aPosGet[1,04]+135 PROMPT ""   						OF oDlg COLOR  0, 16777215 Pixel
nLinSay += 23
nLinGet += 23
@ nLinSay, aPosGet[1,01] 	SAY      oSay12     PROMPT "Segmento"             						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET    oSegmento   VAR cSegmento	Picture PesqPict("SB1","B1__SEGISP")SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ72" 	Valid AtuSeg(cSegmento)
@ nLinGet, aPosGet[1,02]+80 MSGET    oSegDesc    VAR cSegDesc		When .f.    			 		SIZE 150, 008   OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 		SAY     oSay13      PROMPT "Tipo Operação"         					SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30		MSGET   oTp1    VAR cTp1     Picture "A!"  			When .t.   		SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL		Valid ValTipOper(cTp1,1)
@ nLinGet, aPosGet[1,02]+50		MSGET   oTp2    VAR cTp2     Picture "A!"  			When .t.   		SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL		Valid ValTipOper(cTp2,2)
@ nLinGet, aPosGet[1,02]+70		MSGET   oTp3    VAR cTp3     Picture "A!"  			When .t.   		SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL		Valid ValTipOper(cTp3,3)
@ nLinGet, aPosGet[1,02]+90		MSGET   oTp4    VAR cTp4     Picture "A!"  			When .t.   		SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL		Valid ValTipOper(cTp4,4)
@ nLinGet, aPosGet[1,02]+110 	MSGET   oTp5   	VAR cTp5     Picture "A!"  			When .t.   		SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL		Valid ValTipOper(cTp5,5)
@ nLinSay+13, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+13.5,aPosGet[1,04]+135 PROMPT ""   						OF oDlg COLOR  0, 16777215 Pixel
nLinSay += 23
nLinGet += 23
@ nLinSay, aPosGet[1,01] 	SAY      oSay14     PROMPT "Tipo Relatório"              				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay, aPosGet[1,02]+30 RADIO	oRadSub2 	  VAR nTpRel   Prompt OemToAnsi("Operador"), OemToAnsi("Tipo Operação"), OemToAnsi("Representante"), OemToAnsi("Geral") 	SIZE 200, 025 OF oDlg Pixel
oRadSub:bChange := {|| U_AtuIdSg( nIdSg,2 ) }
oRadSub2:bChange := {|| ValTpRel() }              
oRadSub2:lHoriz := .T.
	
nLinSay += 25
nLinGet += 25
@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action (GeraRel()/*,oDlg:end()*/)	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+73  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

U_AtuIdSg( nIdSg,1)

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

Local cTpOper	:= ""
Local _cRelato	:= ""
Local cMarcaDe 	:= ""
Local cMarcaAte	:= ""
Local cParams	:= ""
Local cOptions	:= ""
Local _cTpOp	:= ""

GravaSx1()

For i:=1 to 5
	If !Empty(&("cTp"+cValToChar(i))) .and. !Empty(cTpOper)
		cTpOper := cTpOper + ","
	EndIf
	If !Empty(&("cTp"+cValToChar(i)))
		cTpOper := cTpOper + TipOper(&("cTp"+cValToChar(i)))
	EndIf  
	_cTpOp := Alltrim(_cTpOp + &("cTp"+cValToChar(i)))
Next

If Empty(cTpOper)
	cTpOper := "1,2,4,5"
	_cTpOp	:= "ACDR"
EndIf

cTpOper := FormatIn(cTpOper,",")

If Empty(cMarca)
	cMarcaDe 	:= "    "
	cMarcaAte 	:= "ZZZZ"
Else
	cMarcaDe 	:= cMarca
	cMarcaAte 	:= cMarca
EndIf

If nIdSg == 1 	//Sub-Grupo
	
	cIdenIni := "    "
	cIdenFim := "ZZZZ"
	
Else			//Identificação
	
	cSubGIni := "    "
	cSubGFim := "ZZZZ"

EndIf	
	
Do Case
	
	Case nTpRel == 1
		//_cRelato := "ITMKCR07A"
		If nIdSg = 1
			_cRelato := "ITMKCR07A"
		Else
			_cRelato := "ITMKCR07A2"
		EndIf		
	Case nTpRel == 2                                   
		If nIdSg = 1
			_cRelato := "ITMKCR07B"
		Else
			_cRelato := "ITMKCR07B2"
		EndIf
	Case nTpRel == 3
		//_cRelato := "ITMKCR07C"
		If nIdSg = 1
			_cRelato := "ITMKCR07C"
		Else
			_cRelato := "ITMKCR07C2"
		EndIf
	Case nTpRel == 4
		//_cRelato := "ITMKCR07D"
		If nIdSg = 1
			_cRelato := "ITMKCR07D"
		Else
			_cRelato := "ITMKCR07D2"
		EndIf
EndCase
	       
cParams := Alltrim(cEmprIni)	+ ";"
cParams += Alltrim(cEmprFim)	+ ";"
cParams += cReprIni 			+ ";"
cParams += cReprFim 			+ ";"
cParams += DTOS(dDtIni) 		+ ";"
cParams += DTOS(dDtFim) 		+ ";"
cParams += cSubGIni 			+ ";"
cParams += cSubGFim 			+ ";"
cParams += cIdenIni 			+ ";"
cParams += cIdenFim 			+ ";"
cParams += cMarcaDe 			+ ";"
cParams += cMarcaAte 			+ ";"
cParams += cTpOper				+ ";"
cParams += cSegmento			+ ";"
cParams += Alltrim(Str(nIdSg))	+ ";"
cParams += _cTpOp//+ ";" //alterado aqui para não aparecer mais a chamada do campo para digitar

cOptions := "1;0;1;Relação de Vendas por SubGrupo"

CallCrys(_cRelato,cParams,cOptions)

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaSX1			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Grava valores na SX1                                                            |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GravaSx1()

Local nX := 1

aAdd( aSx1, {cEmprIni, cEmprFim, cReprIni, cReprFim, DTOS(dDtIni), DTOS(dDtFim), cSubGIni, cSubGFim, cIdenIni, cIdenFim, cMarca, cTp1, cTp2, cTp3, cTp4, cTp5, cSegmento } )

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
|	Programa : ValRepr			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência do Representante                                              |
|-----------------------------------------------------------------------------------------------|
*/


static function ValRepr(_cRepr,_nSt)

Local lRet	:= .T.

If ("Z" $ Upper(_cRepr) .or. _cRepr == "999999") .and. _nSt == 2
	
	cReprFim := "999999"
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
|	Programa : ValIdent			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência da identificação                                              |
|-----------------------------------------------------------------------------------------------|
*/


static function ValIdent(_cIdent,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cIdent) .and. _nSt == 2
	
	cIdenFim := "ZZZZZZ"
	oIdenFim:Refresh()
	
Else
	
	dbSelectArea("SZ8")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ8")+_cIdent) .and. !empty(_cIdent)
		msgAlert ("Identificação Inválida !!")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValMarca			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência da Marca                                                      |
|-----------------------------------------------------------------------------------------------|
*/


static function ValMarca(_cMarca)

Local lRet	:= .T.

dbSelectArea("SZ5")
dbSetOrder(1)
if ! dbSeek(xFilial("SZ5")+_cMarca) .and. !empty(_cMarca)
	msgAlert ("Marca Inválida !!")
	lRet	:= .F.
ElseIf empty(_cMarca)
	cMarcaDesc := "Todas"
Else
	cMarcaDesc := SZ5->Z5_DESC
endif

return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuIdSg			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Bloqueio dos campos de Sub-Grupo ou identificação                               |
|-----------------------------------------------------------------------------------------------|
*/

User Function AtuIdSg(PTipo,_cSt)

if PTipo == 1 //Sub-Grupo
	
	oIdenIni:lActive	:= .f.
	oIdenFim:lActive	:= .f.
	
	oSubGIni:lActive	:= .t.
	oSubGFim:lActive	:= .t.
	
	//	cSubGIni	:= Space( avSx3("B1__SUBGRP" ,3) )
	//	cSubGFim 	:= Space( avSx3("B1__SUBGRP" ,3) )
	
	oSubGIni:Refresh()
	oSubGFim:Refresh()
	
	oSubGIni:Setfocus()
	
Elseif PTipo == 2 //Identificação
	
	If nTpRel == 1
		ValTpRel()
	EndIf
	
	oIdenIni:lActive	:= .t.
	oIdenFim:lActive	:= .t.
	
	oSubGIni:lActive	:= .f.
	oSubGFim:lActive	:= .f.
	
	//	cIdenIni	:= Space( avSx3("Z9_COD"    ,3) )
	//	cIdenFim	:= Space( avSx3("Z9_COD"    ,3) )
	
	oIdenIni:Refresh()
	oIdenFim:Refresh()
	
	oIdenIni:Setfocus()
	
Endif

If _cSt == 1
	oEmprIni:Setfocus()
EndIf

oDlg:Refresh()

Return(.t.)

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuFil			 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Atualiza descrição da Filial                                                |
|-----------------------------------------------------------------------------------------------|
*/


Static Function AtuFil(PFilial, PlAtuTela, _cSt)

Local lRet	:= .T.

if SM0->( dbSeek( cEmpAnt + PFilial ) )
	If _cSt == 1
		cEmprDesc	:= SM0->M0_FILIAL
	Else
		cEmprDesc1 	:= SM0->M0_FILIAL
	EndIf
Else
	If !(Empty(PFilial))
		MsgAlert("Filial inválida","PARAMETROS INVALIDOS")
		lRet	:= .F.
	Else
		If _cSt == 1
			cEmprDesc := Space( avSx3("ZE_NOMECOM",3) )
		Else
			cEmprDesc1 := Space( avSx3("ZE_NOMECOM",3) )
		EndIf
	EndIf
Endif

if PlAtuTela
	oEmprDesc:cCaption 	:= cEmprDesc
	oEmprDesc:Refresh()
Endif

Return(lRet)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Atualiza descrição do Segmento                                                |
|-----------------------------------------------------------------------------------------------|
*/


Static Function AtuSeg(PSeg, PlAtuTela)

Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) )
	If !(Empty(PSeg))
		cSegDesc := SZ7->Z7_DESCRIC
	Else
		cSegDesc := Space( avSx3("B1__SEGISP",3) )
	EndIf
Else
	MsgAlert("Segmento inválido","PARAMETROS INVALIDOS")
	lRet	:= .F.
EndIf

if PlAtuTela
	oSegDesc:cCaption := cSegDesc
	oSegDesc:Refresh()
Endif

Return(lRet)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValSubG			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida existência do Sub-Grupo                                                  |
|-----------------------------------------------------------------------------------------------|
*/


static function ValSubG(_cSubG,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cSubG) .and. _nSt == 2
	
	cSubGFim := "ZZZZ"
	oSubGFim:Refresh()
	
Else
	
	dbSelectArea("SZ4")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ4")+_cSubG) .and. !empty(_cSubG)
		msgAlert ("Sub-Grupo Inválido !!")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValTipOper			 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Tipo de Operação                                                         |
|-----------------------------------------------------------------------------------------------|
*/


static function ValTipOper(_cTp,_nTp)

Local lRet	:= .T.

If !Empty(_cTp)
	
	_cTP := Upper(_cTp)
	
	&("cTp"+cValToChar(_nTp)) := _cTp
	
	For x:=1 to 5
		If !lRet
			exit
		EndIf
		If x != _nTp
			For xi:=1 to 5
				If xi != _nTp
					If 	_cTp == &("cTp"+cValToChar(xi))
						msgAlert("Parâmetro Duplicado !!")
						lRet := .F.
						exit
					EndIf
				EndIf
			Next
		EndIf
	Next
	
	If !(_cTp $ "ACDR") .and. !Empty(_cTp) .and. lRet
		msgAlert("Tipo de Operação inválido !!")
		lRet := .F.
	EndIf
	
EndIf

ValTpRel()

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : TipOper		    	 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Transforma as letras do tipo de operação em números                             |
|-----------------------------------------------------------------------------------------------|
*/


static function TipOper(cTp)

Local _cTp := ""

Do Case
	Case cTp == "C"
		_cTp := "1"
	Case cTp == "A"
		_cTp := "2"
		//	Case cTp == "F"
		//		_cTp := "3"
	Case cTp == "R"
		_cTp := "4"
	Case cTp == "D"
		_cTp := "5"
EndCase

return _cTp



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValTpRel		    	 	| 	Janeiro de 2015                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Limpa o tipo de operação caso seja identificação e tipo de relatório Operador   |
|-----------------------------------------------------------------------------------------------|
*/


static function ValTpRel()

If nIdSg == 2 .and. nTpRel == 1
	
	If !Empty(cTp1) .or. !Empty(cTp2) .or. !Empty(cTp3) .or. !Empty(cTp4) .or. !Empty(cTp5)
		
		msgAlert ("Não Tem Tipo de Operação !!")
		
		cTp1 := Space(1)
		oTp1:Refresh()
		cTp2 := Space(1)
		oTp2:Refresh()
		cTp3 := Space(1)
		oTp3:Refresh()
		cTp4 := Space(1)
		oTp4:Refresh()
		cTp5 := Space(1)
		oTp5:Refresh()
		
	EndIf
	
EndIf

Return
