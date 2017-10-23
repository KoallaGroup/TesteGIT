#include "protheus.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITMKR11   บAutor  ณAlexandre Caetano   บ Data ณ  04/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณExecuta relat๓rio em Crystal Report                         บฑฑ
ฑฑบ          ณRelat๓rio de Vendas por SubGrupo / Marca                    บฑฑ
ฑฑบ          ณSint้tico e Analitico                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ITMKR11()

Local _aArea := GetArea()

Local oSay1, oSay2, oSay3, oSay4

Local aPergs			:= {}

Private nTipo 			:= 1
Private nRel			:= 1
Private nPor			:= 1
Private nRelat			:= 1

Private dDt1Ini := dDt1Fim := dDt2Ini := dDt2Fim	:= CtoD(Space(8))
Private lConsol      	:= .f.
Private lLocal      	:= .t.
Private lAnalit			:= .t.
Private lSint			:= .f.
Private lQuebMar		:= .f.

Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private cEmpr		:= SM0->M0_CODIGO
Private cEmprDesc 	:= SM0->M0_FILIAL
Private cProdIni	:= Space( avSx3("B1_COD"    ,3) )
Private cProdFim 	:= Space( avSx3("B1_COD"    ,3) )
Private cSegmento	:= Space( avSx3("B1__SEGISP",3) )
Private cSegDesc	:= Space( avSx3("Z7_DESCRIC",3) )
Private cProd1Desc	:= Space( avSx3("B1_DESC"   ,3) )
Private cProd2Desc	:= Space( avSx3("B1_DESC"   ,3) )

Private oEmpr, oEmprDesc, oProdIni, oProdFim, oSegmento, oSegDesc, oProd1Desc, oProd2Desc, oRadSub, oRadRel, oRadPor
Private oDt1Ini, oDt1Fim, oDt2Ini, Dt2Fim, oChkQuebra, oChkConsol, oButProc, oChkLocal, oChkAnalit, oChkSint, oChkQuebra

Private cPerg		:= PADR("ITMKR11",Len(SX1->X1_GRUPO))
Private aSx1		:= {}

Private oButSub
Private cTitButSub	:= "SubGrupo"

aSize 				:= MsAdvSize()

aObjects 			:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo				:= {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj 			:= MsObjSize(aInfo, aObjects)

nLinSay 			:= aPosObj[1,1] + 6
nLinGet 			:= aPosObj[1,1] + 4

aPosGet 			:= MsObjGetPos(aSize[3]-aSize[1],315,{{008,025,060,73,137}})

//                  1             2  3    4      5   6 						 7 8  9  10     11     12 13 14 15 16 17 18 19 20 21 22 23 24 25        						 36
Aadd(aPergs,{"Local			"	,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Produto de    "	,"","","mv_ch2","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""   ,"","","",""})
Aadd(aPergs,{"Produto ate   "	,"","","mv_ch3","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Segmento      "  	,"","","mv_ch4","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data de       "	,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data at้      "	,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data de       "	,"","","mv_ch7","D",08						,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data at้      "	,"","","mv_ch8","D",08						,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)
cEmpr		:= MV_PAR01
cProdIni	:= MV_PAR02
cProdFim 	:= Replicate('Z',TamSX3("B1_COD")[1])//MV_PAR03
cSegmento	:= MV_PAR04
dDt1Ini		:= MV_PAR05
dDt1Fim		:= MV_PAR06
dDt2Ini		:= MV_PAR07
dDt2Fim		:= MV_PAR08

U_AtuDescFil(cEmpr,.f.)
U_AtuDescPrd(cProdIni,1,.f.)
U_AtuDescPrd(cProdFim,2,.f.)
U_AtuDescSeg(cSegmento,.f.)

/*
if Empty(dDt1Ini)
dDt1ini 	:= CtoD( "01/" + Strzero(Month(dDataBase),2,0) + "/" + Str(Year(dDataBase),4)  )
Endif

if Empty(dDt1Fim)
dDt1Fim 	:= CtoD( "31/" + Strzero(Month(dDataBase),2,0) + "/" + Str(Year(dDataBase),4)  )

if Empty(dDt1Fim)
dDt1Fim := CtoD( "30/" + Strzero(Month(dDataBase),2,0) + "/" + Str(Year(dDataBase),4) )
Endif
Endif

if Empty(dDt2Ini)
dDt2ini 	:= CtoD( "01/01" + "/" + Str(Year(dDataBase),4) )
Endif

if Empty(dDt2Fim)
dDt2Fim		:= CtoD( "31/12" + "/" + Str(Year(dDataBase),4) )
Endif
*/

dDt1ini 	:= FirstDay(dDataBase)
dDt1Fim 	:= LastDay(dDataBase)
dDt2ini 	:= CtoD( "01/01" + "/" + Str(Year(dDataBase),4) )
dDt2Fim		:= CtoD( "31/12" + "/" + Str(Year(dDataBase),4) )

DEFINE MSDIALOG oDlg TITLE "Consulta Vendas Subgrupo / Marca" FROM 000, 000  TO 400, 720 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay, aPosGet[1,01] SAY      oSay1       PROMPT "Local    "           						SIZE 030, 008   OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02] MSGET    oEmpr       VAR cEmpr       	When .t.   						SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL 				Valid U_AtuDescFil(cEmpr)
@ nLinGet, aPosGet[1,03] MSGET    oEmprDesc   VAR cEmprDesc   	When .f.   				 		SIZE 160, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay2       PROMPT "Item de  "                         		SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02] MSGET    oProdIni    VAR cProdIni	Picture PesqPict("SB1","B1_COD")	SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SB1LIK" 	Valid U_AtuDescPrd(cProdIni,1)
@ nLinGet, aPosGet[1,03] MSGET    oProd1Desc  VAR cProd1Desc	When .f.   				 		SIZE 160, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay3       PROMPT "Item at้ "                         		SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02] MSGET    oProdFim    VAR cProdFim	Picture PesqPict("SB1","B1_COD")	SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SB1LIK" 	Valid U_AtuDescPrd(cProdFim,2)
@ nLinGet, aPosGet[1,03] MSGET    oProd2Desc  VAR cProd2Desc   	When .f.   				 		SIZE 160, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,01] SAY      oSay4       PROMPT "Segmento "                          		SIZE 030, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02] MSGET    oSegmento   VAR cSegmento	Picture PesqPict("SB1","B1_COD")	SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL   F3 "SZ7" 	Valid U_AtuDescSeg(cSegmento)
@ nLinGet, aPosGet[1,03] MSGET    oSegDesc    VAR cSegDesc		When .f.    			 		SIZE 160, 008   OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay,aPosGet[1,01]    GROUP   	oGroup1 TO nLinSay+30,aPosGet[1,04] PROMPT "Perํodo 1"   					OF oDlg Pixel
@ nLinSay+12,aPosGet[1,01]+09 MSGET	oDt1Ini 	  VAR dDt1Ini									SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay+12,aPosGet[1,01]+74 MSGET	oDt2Fim 	  VAR dDt1Fim									SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL

@ nLinSay,aPosGet[1,04]+1  GROUP	oGroup1 TO nLinSay+30,aPosGet[1,05] PROMPT "Perํodo 2"   					OF oDlg Pixel
@ nLinSay+12,aPosGet[1,04]+10 MSGET  oDt2Ini 	  VAR dDt2Ini									SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay+12,aPosGet[1,04]+74 MSGET  oDt2Fim 	  VAR dDt2Fim									SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL
                                                                                                      
nLinSay += 33
nLinGet += 33

@ nLinSay,   aPosGet[1,01]   GROUP	oGroup1 TO nLinSay+40,aPosGet[1,04] PROMPT "Tipo"   					   					  OF oDlg Pixel

@ nLinSay+14, aPosGet[1,01]+4 RADIO	oRadSub 	  VAR nTipo   Prompt OemToAnsi("SubGrupo"), OemToAnsi("Marca") 		SIZE 080, 008 OF oDlg Pixel
oRadSub:bChange := {|| U_AtuDescBut( nTipo ) }

@ nLinSay+14, aPosGet[1,02]+25 BUTTON   oButSub     PROMPT cTitButSub	Action U_MarkDados(nTipo)	   			   		SIZE 040, 016 OF oDlg Pixel

@ nLinSay,   aPosGet[1,04]+1 GROUP	oGroup1 TO nLinSay+40,aPosGet[1,05] PROMPT "Relat๓rio" 										  OF oDlg Pixel
         
@ nLinSay+14, aPosGet[1,04]+4 RADIO	oRadRel 	  VAR nRelat   Prompt "Analitico", "Sintetico"/*, "Quebra por Marca"*/  SIZE 080, 008 OF oDlg Pixel
oRadRel:bChange := {|| U_AtuParDlg( nRelat , nTipo) }

nLinSay += 43
nLinGet += 43

@ nLinSay,  aPosGet[1,01]    GROUP	  oGroup1 TO nLinSay+30,aPosGet[1,05] PROMPT "Por" 	  OF oDlg Pixel

@ nLinSay+12, aPosGet[1,03] RADIO	oRadPor	  VAR nPor   Prompt "Local", "Empresa" 	SIZE 080, 008 OF oDlg Pixel
oRadPor:bChange := {|| U_AtuEmp( nPor ) }
oRadPor:lHoriz := .T.

nLinSay += 40
nLinGet += 40

@ nLinSay, aPosGet[1,04]+51  BUTTON   oButProc     PROMPT "Processar"	Action GeraRel()   			   		SIZE 040, 016 OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+93  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  			   		SIZE 040, 016 OF oDlg Pixel

U_AtuParDlg( 1 , 1)

ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)
Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuDescButบAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza descri็ใo do botใo confome tipo selecionado       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuDescBut(PTipo, PlAtuTela)

Default PlAtuTela := .t.

if PTipo = 1
	cTitButSub	:= "SubGrupo"
Else
	cTitButSub	:= "Marca"
Endif

if PlAtuTela
	oButSub:cCaption := cTitButSub
	oButSub:Refresh()
Endif

U_AtuParDlg(1,PTipo)

If Select("TMP1") > 0
	dbSelectArea("TMP1")
	DbCloseArea()
EndIf
               
If Select("TRB1") > 0
	dbSelectArea("TRB1")
	DbCloseArea()
EndIf

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuDescFilบAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza descri็ใo da Filial                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuDescFil(PFilial, PlAtuTela)

if SM0->( dbSeek( cEmpAnt + PFilial ) )
	cEmprDesc 			:= SM0->M0_FILIAL
Else
	cEmprDesc 			:= "Filial invแlida"
Endif

if PlAtuTela
	oEmprDesc:cCaption 	:= cEmprDesc
	oEmprDesc:Refresh()
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuDescPrdบAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza descri็ใo do produto                              บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuDescPrd(PProd,Pobj,PlAtuTela)

SB1->(dbSetOrder(1))

If SB1->( dbSeek( xFilial("SB1") + PProd ) )
	
	if Pobj = 1
		cProd1Desc := SB1->B1_DESC
	Else
		cProd2Desc := SB1->B1_DESC
	Endif
	
Else
	
	if Pobj = 1
		cProd1Desc := "Produto Invแlido"
	Else
		cProd2Desc := "Produto Invแlido"
	Endif
	
Endif

if PlAtuTela
	
	if PObj = 1
		oProd1Desc:cCaption := cProd1Desc
		oProd1Desc:Refresh()
	Else
		oProd2Desc:cCaption := cProd2Desc
		oProd2Desc:Refresh()
	Endif
	
Endif


Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuDescSegบAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza descri็ใo do Segmento                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuDescSeg(PSeg, PlAtuTela)

SZ7->(dbSetOrder(1))
IF SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) )
	cSegDesc := SZ7->Z7_DESCRIC
Else
	cSegDesc := "Segmento invแlido"
EndIf

if PlAtuTela
	oSegDesc:cCaption := cSegDesc
	oSegDesc:Refresh()
Endif

Return(.t.)

/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | GravaSX1 | Autor | Rubens Cruz - Anadi Solu็๕es 		   | Data | Julho/2014 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Grava valores na SX1														   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA		  																   |
+-----------+------------------------------------------------------------------------------+
*/

Static Function GravaSx1()

Local nX := 1

aAdd( aSx1, {cEmpr, cProdIni, cProdFim, cSegmento, DtoS(dDt1Ini), DtoS(dDt1Fim), DtoS(dDt2Ini), DtoS(dDt2Fim)} )

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
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMarkDados บAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Gera msSelect para marca็ใo de SubGrupo / Marcas a serem   บฑฑ
ฑฑบ          ณ impressas                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function MarkDados(PnTipo)

Local cTitWindow
Local cQry		:= ""
Private lInvert := .F.
Private cMarca	:= "XD"//GetMark()

if PnTipo = 1
	cTitWindow	:= "Sele็ใo de SubGrupos"
Else
	cTitWindow	:= "Sele็ใo de Marcas"
Endif

If Select("TMP1") > 0
	dbSelectArea("TMP1")
	DbCloseArea()
EndIf

If Select("TRB1") > 0
	dbSelectArea("TRB1")
	DbCloseArea()
EndIf  

if PnTipo  = 1 // SubGrupo
	cQry	:= " SELECT Z4_CODIGO, Z4_DESC 	"
	cQry    += " FROM " + RetSQLName("SZ4") + " SZ4      "
	cQry    += " WHERE D_E_L_E_T_ = ' '                 "
	cQry    += " AND Z4_SEGISP = '" + cSegmento + "'    "
Else
	cQry	:= " SELECT Z5_CODIGO, Z5_DESC  "
	cQry	+= " FROM " + RetSQLName("SZ5") + " SZ5     "
	cQry    += " WHERE D_E_L_E_T_ = ' '                 "
	cQry    += " AND Z5_SEGISP = '" + cSegmento + "'    "
Endif

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMP1",.T.,.F. )

IF PnTipo = 1 // SubGrupo
	
	aDBF1 := 	{{	"OK1"       ,"C",  2  					   , 0},;
	{	"Z4_CODIGO" ,"C",  LEN(SZ4->Z4_CODIGO)     , 0},;
	{  "Z4_DESC"	,"C",  LEN(SZ4->Z4_DESC)       , 0} }
	
	cArqTMP1 := CriaTrab(aDBF1)
	DbUseArea (.T.,,cArqTMP1,"TRB1")
	
	INDEX ON Z4_DESC           	TO &(cArqTMP1+"a")
	SET INDEX TO &(cArqTMP1+"a")
	
	aCpoBro1 := {}
	
	aCpoBro1 := 	{{ "OK1"       , , " "	   		,  2                   	, 0  ,"@!"	},;
	{ "Z4_CODIGO" , , "CODIGO"	 	,  LEN(TRB1->Z4_CODIGO) , 0  ,"@!"	},;
	{ "Z4_DESC"   , , "DESCRIวรO"  ,  LEN(TRB1->Z4_DESC)   , 0  ,"@!"  }  }
Else  // Marca
	
	aDBF1 := 	{{	"OK1"       ,"C",  2  					   , 0},;
	{	"Z5_CODIGO" ,"C",  LEN(SZ5->Z5_CODIGO)     , 0},;
	{  "Z5_DESC"	,"C",  LEN(SZ5->Z5_DESC)       , 0} }
	
	cArqTMP1 := CriaTrab(aDBF1)
	DbUseArea (.T.,,cArqTMP1,"TRB1")
	
	INDEX ON Z5_DESC           	TO &(cArqTMP1+"a")
	SET INDEX TO &(cArqTMP1+"a")
	
	aCpoBro1 := {}
	
	aCpoBro1 := 	{{ "OK1"       , , " "	   		,  2                   	, 0  ,"@!"	},;
	{ "Z5_CODIGO" , , "CODIGO"	 	,  LEN(TRB1->Z5_CODIGO) , 0  ,"@!"	},;
	{ "Z5_DESC"   , , "DESCRIวรO"  ,  LEN(TRB1->Z5_DESC)   , 0  ,"@!"  }  }
	
Endif

TMP1->( dbGoTop() )

Do While TMP1->( !EoF() )
	
	if PnTipo = 1
		RecLock("TRB1",.T.)
		TRB1->Z4_CODIGO	:= TMP1->Z4_CODIGO
		TRB1->Z4_DESC   := TMP1->Z4_DESC
		TRB1->(MsunLock())
	Else
		RecLock("TRB1",.T.)
		TRB1->Z5_CODIGO	:= TMP1->Z5_CODIGO
		TRB1->Z5_DESC   := TMP1->Z5_DESC
		TRB1->(MsunLock())
	Endif
	
	TMP1->(dbSkip())
Enddo

TRB1->( dbGoTop() )

DEFINE MSDIALOG oDlgDet1 TITLE cTitWindow FROM 000, 000  TO 500, 800 COLORS 0, 16777215 PIXEL
oDlgDet1:lMaximized := .f.

oMark1 						:= MsSelect():New("TRB1","OK1","",aCpoBro1,@lInvert,@cMarca,{003,003,223,400},,,oDlgDet1)
oMark1:bMark 				:= {| | MrcDados(.f.)}
oMark1:oBrowse:lhasMark 	:= .T.
oMark1:oBrowse:lCanAllmark 	:= .F.
oMark1:oBrowse:bAllMark 	:= {| | Processa({ |lEnd| MrcDados(.t.),OemToAnsi("Processando..., Aguarde...")}, OemToAnsi("Aguarde..."))}
oMark1:oBrowse:Refresh()

@ 227, 003  BUTTON   oButMarc     PROMPT "Todos "	        Action MrcTodos() 				SIZE 060, 016 OF oDlgDet1 Pixel
@ 227, 065  BUTTON   oButMarc     PROMPT "Nenhum"	        Action DesMrcTd() 				SIZE 060, 016 OF oDlgDet1 Pixel

@ 227, 318  BUTTON   oButConf     PROMPT "Confirmar"	    Action {|| oDlgDet1:end() } 				SIZE 040, 016 OF oDlgDet1 Pixel
@ 227, 360  BUTTON   oButCanc     PROMPT "Cancelar "	    Action {|| lRet := .f., oDlgDet1:end()}  	SIZE 040, 016 OF oDlgDet1 Pixel

ACTIVATE MSDIALOG oDlgDet1 CENTERED

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMRCDADOS  บAutor  ณAlexandre Caetano   บ Data ณ  12/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Inverte marca็ใo do MarkBrowse                             บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MRCDADOS(lTodos)

Local cCond
Local nRec   := 1

Default lTodos := .f.

if lTodos
	TRB1->( DbGoTop() )
	cCond := "TRB1->( !EoF() )"
Else
	nRec := TRB1->( Recno() )
	cCond := "TRB1->( Recno() ) = " + Str(nRec)
Endif

Do While &cCond
	
	RecLock("TRB1",.F.)
	
	if lTodos
		If !Marked("OK1")
			TRB1->OK1 := cMarca
		Else
			TRB1->OK1 := ""
		Endif
	Else
		
		If Marked("OK1")
			TRB1->OK1 := cMarca
		Else
			TRB1->OK1 := ""
		Endif
	Endif
	
	TRB1->( MsUnlock() )
	TRB1->( DbSkip() )
	
Enddo

if lTodos
	TRB1->( DbGotop() )
else
	TRB1->( DbGoTo( nRec ) )
endif

oMark1:oBrowse:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMrcTodos  บAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Marca todos os MarkBrowse                                   ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function MRCTodos()

TRB1->( DbGotop() )

Do While TRB1->( !EoF() )
	
		RecLock("TRB1",.F.)
		
		TRB1->OK1 := cMarca
		
	TRB1->( MsUnlock() )
	TRB1->( DbSkip() )
	
Enddo

TRB1->( DbGotop() )

oMark1:oBrowse:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDesMrcTdo บAutor  ณAlexandre Caetano   บ Data ณ  10/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ DesMarca todos os MarkBrowse                                ฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DesMrcTd()

TRB1->( DbGotop() )

Do While TRB1->( !EoF() )
	
	RecLock("TRB1",.F.)
	
	TRB1->OK1 := "  "
	
	TRB1->( MsUnlock() )
	TRB1->( DbSkip() )
	
Enddo

TRB1->( DbGotop() )

oMark1:oBrowse:Refresh()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGeraRel   บAutor  ณAlexandre Caetano   บ Data ณ  12/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia dados para a emissใo do relatorio em Crystal         บฑฑ
ฑฑบ          ณ CALLCRYS()                                                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GeraRel()

Local cIn := cInTot := ""
Local cDescFil, cFilIni, cFilFim

GravaSx1()

if nPor = 2 //lConsol
	cFilini		:= "  "
	cFilfim		:= "ZZ"
	cDescFil	:= "Por Empresa"
Else
	cFilini		:= cEmpr
	cFilfim		:= cEmpr
	cDescFil	:= "Por Local: " + cEmpr + "-" + cEmprDesc
Endif

if nTipo = 1 .and. nRel = 1   // SUBGRUPO ANALITICO
	
	If Select("TRB1") > 0
		
		TRB1->( dbGoTop() )
		Do While TRB1->( !EoF() )
			
			if !Empty(TRB1->OK1)
				cIn += TRB1->Z4_CODIGO + ","
			Endif
			
			cInTot	+= TRB1->Z4_CODIGO + ","
			TRB1->( dbSkip() )
			
		Enddo
		
		cIn 	:= Substr(cIn,1,(Len(cIn) - 1))
		cInTot 	:= Substr(cInTot,1,(Len(cInTot) - 1))
		
		If Empty(cIn)
			cIn := cInTot
		Endif
		
		cIn 	:= FormatIn(cIn,",")
		cInTot  := FormatIn(cInTot,",")
		
	Else
		msgAlert("      Nenhum Subgrupo ou Marca Selecionada.      " + chr(13) +;
		"Selecione dados clicando no botใo Subgrupo/Marca.","Aten็ใo !!!")
		Return(.f.)
	Endif

	cQbrMarca := iif( lQuebMar, "1", "0" )
	
	cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	";" + cDescFil + ";" + DtoS(dDt2Ini) + ";" + DtoS(dDt2Fim) + ";" + cProdIni + ";" + cProdFim + ";" + cQbrMarca
	
	x:="1;0;1;ITMKR11d"
	
	CallCrys("ITMKR11d",cParms, x)

Elseif nTipo = 1 .and. nRel = 2   // SUBGRUPO SINTษTICO
	
	If Select("TRB1") > 0
		
		TRB1->( dbGoTop() )
		Do While TRB1->( !EoF() )
			
			if !Empty(TRB1->OK1)
				cIn += TRB1->Z4_CODIGO + ","
			Endif
			
			cInTot	+= TRB1->Z4_CODIGO + ","
			TRB1->( dbSkip() )
			
		Enddo
		
		cIn 	:= Substr(cIn,1,(Len(cIn) - 1))
		cInTot 	:= Substr(cInTot,1,(Len(cInTot) - 1))
		
		if Empty(cIn)
			cIn := cInTot
		Endif
		
		cIn 	:= FormatIn(cIn,",")
		cInTot  := FormatIn(cInTot,",")
		
	Else
		msgAlert("      Nenhum Subgrupo ou Marca Selecionada.      " + chr(13) +;
		"Selecione dados clicando no botใo Subgrupo/Marca.","Aten็ใo !!!")
		Return(.f.)
	Endif
	
	//cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	//";" + cDescFil + ";" + DtoS(dDt2Ini) + ";" + DtoS(dDt2Fim) + ";" + cProdIni + ";" + cProdFim
	
	cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	";" + cDescFil + ";" + DtoS(dDt2Ini) + ";" + DtoS(dDt2Fim) + ";" + cProdIni + ";" + cProdFim
	
	x:="1;0;1;ITMKR11"
	
	CallCrys("ITMKR11",cParms, x)
	
Elseif nTipo = 2 .and. nRel = 2   // MARCA ANALITICO
	
	If Select("TRB1") > 0
		
		TRB1->( dbGoTop() )
		Do While TRB1->( !EoF() )
			
			if !Empty(TRB1->OK1)
				cIn += TRB1->Z5_CODIGO + ","
			Endif
			
			cInTot	+= TRB1->Z5_CODIGO + ","
			TRB1->( dbSkip() )
			
		Enddo
		
		cIn 	:= Substr(cIn,1,(Len(cIn) - 1))
		cInTot 	:= Substr(cInTot,1,(Len(cInTot) - 1))
		
		if Empty(cIn)
			cIn := cInTot
		Endif
		
		cIn 	:= FormatIn(cIn,",")
		cInTot  := FormatIn(cInTot,",")
		
		
	Else
		msgAlert("      Nenhum Subgrupo ou Marca Selecionada.      " + chr(13) +;
		"Selecione dados clicando no botใo Subgrupo/Marca.","Aten็ใo !!!")
		Return(.f.)
	Endif
	
	//	cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	//	";" + cDescFil + ";" + DtoS(dDt2Ini) + ";" + DtoS(dDt2Fim) + ";" + cProdIni + ";" + cProdFim
	
	cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	";" + cDescFil + ";" + cProdIni + ";" + cProdFim
	
	x:="1;0;1;ITMKR11b"
	                        
	//alert ("analitico")
	CallCrys("ITMKR11b",cParms, x)
	
Elseif nTipo = 2 .and. nRel = 1   // MARCA ANALITICO
	
	If Select("TRB1") > 0
		
		TRB1->( dbGoTop() )
		Do While TRB1->( !EoF() )
			
			if !Empty(TRB1->OK1)
				cIn += TRB1->Z5_CODIGO + ","
			Endif
			
			cInTot	+= TRB1->Z5_CODIGO + ","
			TRB1->( dbSkip() )
			
		Enddo
		
		cIn 	:= Substr(cIn,1,(Len(cIn) - 1))
		cInTot 	:= Substr(cInTot,1,(Len(cInTot) - 1))
		
		if Empty(cIn)
			cIn := cInTot
		Endif
		
		cIn 	:= FormatIn(cIn,",")
		cInTot  := FormatIn(cInTot,",")
		
		
	Else
		msgAlert("      Nenhum Subgrupo ou Marca Selecionada.      " + chr(13) +;
		"Selecione dados clicando no botใo Subgrupo/Marca.","Aten็ใo !!!")
		Return(.f.)
	Endif
	
	cQbrMarca := "1"
	
	cParms := cFilini + ";" + cFilFim + ";" + DtoS(dDt1Ini) + ";" + DtoS(dDt1Fim) + ";" + cSegmento + ";" + cSegDesc + ";" + cIn +;
	";" + cDescFil + ";" + DtoS(dDt2Ini) + ";" + DtoS(dDt2Fim) + ";" + cProdIni + ";" + cProdFim + ";" + cQbrMarca
	
	x:="1;0;1;ITMKR11c"
	
	//alert ("analitico")
	CallCrys("ITMKR11c",cParms, x) 
	
	lQuebMar := .F.
	
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAtuParDlg บAutor  ณAlexandre Caetano   บ Data ณ  13/Dez/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Atualiza parametros dos objetos da tela conforme sele็ใo   บฑฑ
ฑฑบ          ณ quanto a bloqueio e desbloqueio de objetos                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function AtuParDlg( PnRel , _nTipo)
             
If _nTipo = 1	//SubGrupo

	oRadRel:Enable(3)
	oRadRel:Refresh()

	if PnRel = 1 // Analํtico
              
			lSint		:= .f. 
			lQuebMar	:= .f.

			oRadPor:Enable(1)	
			oRadPor:Enable(2)	
			nPor := 1
			oRadPor:Refresh()

	Elseif PnRel = 2 // Sint้tico
               
			lAnalit 	:= .f.
			lQuebMar	:= .f.

			oRadPor:Enable(1)	
			oRadPor:Enable(2)	
			nPor := 1
			oRadPor:Refresh()

	Elseif PnRel = 3 // Quebra por marca

			lAnalit 	:= .f.
			lSint		:= .f.
			lConsol		:= .t.
			lLocal		:= .f. 

			oRadPor:Disable(1)	
			oRadPor:Enable(2)	
			nPor := 2
			oRadPor:Refresh()
		
	Endif
			
Else			//Marca

	oRadPor:Enable(1)	
	oRadPor:Enable(2)	
	oRadPor:Refresh()
                        
	nRelat:= 1
	oRadRel:Disable(3)	
	oRadRel:Enable(1)	
	oRadRel:SetOption(1) 
	oRadRel:Refresh()
	
	if PnRel = 1 // Analํtico
                             
		lQuebMar	:= .f.  
		lAnalit		:= .t. 
		lSint		:= .f. 
					
	Elseif PnRel = 2 // Sint้tico

		lSint		:= .t.
		lAnalit 	:= .f.
		lQuebMar	:= .f.        				
						
	EndIf
EndIf

nRel := PnRel
oDlg:Refresh()

Return(.t.)




User Function AtuEmp(_nLocEmp)

If _nLocEmp == 1		//Local
	lConsol	:= .f.
ElseIf _nLocEmp == 2	//Empresa
	lLocal	:= .f.
EndIf
	
oDlg:Refresh()

Return(.t.)
