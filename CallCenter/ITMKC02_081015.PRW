#INCLUDE "PROTHEUS.CH"            
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITMKC02   บAutor  ณAlexandre Caetano   บ Data ณ 08/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Consulta Produto (Diretoria)                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ITMKC02()

Local oArmGer
Local oArmVit
Local oConsDtEnt
Local oButtonD1
Local oButtonD2
Local oButtonD3
Local oButtonD1k
Local oCrossDock
Local oDescGrp
Local oDescMarca
Local oDescSGrp
Local oDolar
Local oDtPer1ini
Local oDtPer1Fin

Local oDtPer2Fin
Local oDtPer2ini
Local oEmprDesc
Local oEntTransf
Local oGroup1
Local oGroup2
Local oGroup3
Local oGroup4
Local oGroup5
Local oGroup6
Local oGroup7
Local oGroup8
Local oGrupo
Local oMarca
Local oMBaseCons
Local oPrecoVist
Local oPrevEntr
Local oPrecVSP
Local oProced
Local oProdDesc
Local oQtdPreVnd
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay13
Local oSay14
Local oSay15
Local oSay16
Local oSay2
Local oSay23
Local oSay24
Local oSay25
Local oSay26
Local oSay27
Local oSay28
Local oSay29
Local oSay30, oSayA1, oArm1, oSayA2, oArm2 
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Local oSldPreVnd
Local oTotDisp
Local oTotEntPro
Local oTotEstRea
Local oTotReserv
Local oTotSaiPro
Local oTotValEst
Local oSubGrupo

Local oButtonk1
Local oButtonk2
Local oButtonk3

Local oGetk01
Local oGetk02
Local oGetk03
Local oGetk04
Local oGetk06
Local oGetk10
Local oGetk11
Local oGetk12
Local oGetk13
Local oGetk14
Local oGetk15
Local oGetk16
Local oGetk17
Local oGetk18
Local oGetk19
Local oGetk20
Local oGetk21
Local oGetk22
Local oGetk23
Local oGetk24
Local oGetk25
Local oGetk26
Local oGetk27

Local cGet1 := " "
Local cGet2 := " "
Local cGet3 := " "
Local cGet4 := " "
Local cGet5 := " "
Local cGet6 := " "
Local cGet7 := " "
Local cGet8 := " "
Local cGet9 := " "
Local cGet10 := " "
Local cGet11 := " "
Local cGet12 := " "
Local cGet13 := " "
Local cGet14 := " "
Local cGet15 := " "
Local cGet16 := " "
Local cGet17 := " "
Local cGet18 := " "
Local cGet19 := " "
Local cGet20 := " "
Local cGet21 := " "
Local cGet22 := " "
Local cGet23 := " "
Local cGet24 := " "
Local cGet25 := " "
Local cGet26 := " "
Local cGet27 := " "

Local oGroupk1
Local oGroupk2
Local oGroupk3
Local oGroupk4
Local oGroupk5
Local oGroupk6
Local oGroupk7
Local oGroupk8

Local oSayk01
Local oSayk02
Local oSayk03
Local oSayk04
Local oSayk05
Local oSayk06
Local oSayk07
Local oSayk08
Local oSayk09
Local oSayk10
Local oSayk11
Local oSayk12
Local oSayk13
Local oSayk14
Local oSayk15
Local oSayk16
Local oSayk17
Local oSayk18

Private oProd


Private cPreVnd     := GetMv("MV__PREFAT",,"00004") // Codigo do pre faturamento na SUA

Private oDescCompl

Private aHeaderEx1 	:= {}
Private aColsEx1 	:= {}

Private aHeaderEx2 	:= {}
Private aColsEx2 	:= {}

Private aHeaderEx3 	:= {}
Private aColsEx3 	:= {}

Private aHeaderEk1 	:= {}
Private aColsEk1 	:= {}

Private aHeaderEk2 	:= {}
Private aColsEk2 	:= {}

Private aHeaderEk3 	:= {}
Private aColsEk3 	:= {}

Private aHeaderEk4 	:= {}
Private aColsEk4 	:= {}

Private aHeaderD1 	:= {}
Private aColsD1 	:= {}

Private aHeaderD2 	:= {}
Private aColsD2		:= {}

Private	nKitTot 	:= 0

Private oFolder1 

Private cOrig       := "", _nRecSD1 := 0 
Private cDescOrig   := ""
Private _cArmPad1   := _cArmDe := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]), _cArmPad2 := _cArmAte := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])  

Private lLimpaIt 	:= .F.
Private oFont14B	:= tFont():New("Tahoma",,-14,,.t.)
Private oSay90, oSay91, _lPromEsp := .f.

cEmpr		:= SM0->M0_CODIGO
cEmprDesc 	:= SM0->M0_NOMECOM
cCNPJ		:= Substr( SM0->M0_CGC,1,8)

cArmVit 	:= ""
cArmGer 	:= ""
cCrossDock 	:= ""
cDescGrp 	:= ""
cDescMarca 	:= ""
cDescSGrp 	:= ""
cDolar 		:= ""

dDtPer1ini 	:= CtoD( "01/" + Strzero(Month(dDataBase),2) + "/" + Strzero(Year(dDataBase),4)  )
dDtPer1Fin 	:= CtoD( "01/" + Strzero(IIF(MONTH(dDataBase)+1=13,1,MONTH(dDataBase)+1),2)+"/"+;
IIF(MONTH(dDataBase)+1=13,STRZERO(YEAR(dDataBase)+1,4),STRZERO(YEAR(dDataBase),4)))-1

dDtPer2ini 	:= CtoD( "01/01" + "/" + Str(Year(dDataBase),4) )
dDtPer2Fin 	:= CtoD( "31/12" + "/" + Str(Year(dDataBase),4) )


cEntTransf 	:= ""
cGrupo 		:= ""
cMarca 		:= ""
cMBaseCons 	:= ""
cPrecoVist 	:= ""
cPrevEntr 	:= ""
cPrecVSP 	:= ""
cProced 	:= ""
cProd 		:= Space( TamSX3("B1_COD")[1] )
cProdkit	:= Space( TamSX3("B1_COD")[1] )
cProdDesc 	:= ""
cQtdPreVnd 	:= ""
cSubGrupo 	:= ""
cSldPreVnd 	:= ""
nTotDisp 	:= 0
nTotEntPro 	:= 0
nTotSaiPro 	:= 0

nTotEstRea 	:= 0
nTotReserv 	:= 0
nTotValEst 	:= 0

cEmprk		:= cFilAnt
cEmprkDesc	:= SM0->M0_NOMECOM

cKit 		:= Space( Len( SUG->UG_CODACE ) )
cKitDesc 	:= ""

dDtPrK1ini 	:= CtoD( "01/" + Strzero(Month(dDataBase),2) + "/" + Strzero(Year(dDataBase),4)  )
dDtPrK1Fin 	:= CtoD( "01/" + Strzero(IIF(MONTH(dDataBase)+1=13,1,MONTH(dDataBase)+1),2)+"/"+;
IIF(MONTH(dDataBase)+1=13,STRZERO(YEAR(dDataBase)+1,4),STRZERO(YEAR(dDataBase),4)))-1

dDtPrk2ini 	:= CtoD( "01/01" + "/" + Str(Year(dDataBase),4) )
dDtPrk2Fin 	:= CtoD( "31/12" + "/" + Str(Year(dDataBase),4) )

cArmVitk 	:= ""
cArmGerk 	:= ""
cDolark 	:= ""

cEntTrnsfk	:= 0
cPrecoVisk	:= ""
cPrevEntrk 	:= ""
cPrecVSPk 	:= ""
cProcedk 	:= ""
cMBaseConk	:= ""

cQtdPreVdk 	:= ""
cSldPreVdk 	:= ""

cEntTrnsfk	:= 0
nTotDispk 	:= 0
nTotEntPrk 	:= 0
nTotSaiPrk 	:= 0
nTotEstRek 	:= 0
nTotResrvk 	:= 0
nTotVlEstk 	:= 0 

Static oDlg

DEFINE MSDIALOG oDlg TITLE "Consulta de Produto (Diretoria)" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .t.

@ 000, 000 FOLDER oFolder1 SIZE 684, 499 OF oDlg ITEMS "ITEM","KIT" COLORS 0, 16777215 PIXEL

// Folder 1   [ITEM]
@ 003, 004 GROUP oGroup1 TO 081, 647 PROMPT "Sele็ใo"   					OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL

@ 012, 008 SAY      oSay1       PROMPT "Empr."              SIZE 014, 007   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 010, 022 MSGET    oEmpr       VAR cEmpr       When .f.    SIZE 020, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 010, 043 MSGET    oEmprDesc   VAR cEmprDesc   When .f.    SIZE 200, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL    

@ 012, 248 SAY      oSay30       PROMPT "Origem"             SIZE 018, 009   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 010, 270 MSGET    oOrig       VAR cOrig       When .f.     SIZE 025, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 010, 295 MSGET    oDescOrig 	VAR cDescOrig   When .f.     SIZE 080, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 022, 005  SAY      oSay90      PROMPT "P" FONT oFont14B     SIZE 025, 008  OF oFolder1:aDialogs[1] COLOR CLR_RED PIXEL 
oSay90:Hide()
@ 023, 011 SAY      oSay6       PROMPT "Item"               SIZE 025, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 021, 022 MSGET    oProd       VAR cProd  Picture PesqPict("SB1","B1_COD") SIZE 041, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL   F3 "SB1LIK" Valid IIF(!Empty(cProd),U_ShowProd(),.f.)
@ 021, 065 MSGET    oProdDesc   VAR cProdDesc   When .f.    SIZE 300, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 022, 365 SAY      oSay91      PROMPT "E" FONT oFont14B    SIZE 025, 008  OF oFolder1:aDialogs[1] COLOR CLR_RED PIXEL 
oSay91:Hide()

@ 007, 378 GROUP oGroup2 TO 033, 508 PROMPT "Periodo 1" 					OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
@ 007, 512 GROUP oGroup3 TO 033, 642 PROMPT "Periodo 2" 					OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL

@ 018, 379 SAY 		oSay2 		PROMPT "Data" 				SIZE 025, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 017, 396 MSGET 	oDtPer1ini 	VAR dDtPer1ini 	When .t.	SIZE 045, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 018, 445 SAY 		oSay3 		PROMPT "At้"				SIZE 012, 008	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 017, 461 MSGET 	oDtPer1Fin 	VAR dDtPer1Fin	When .t.	SIZE 045, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 018, 514 SAY 		oSay4 		PROMPT "Data" 				SIZE 013, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 017, 532 MSGET 	oDtPer2ini 	VAR dDtPer2ini 	When .t. 	SIZE 045, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 018, 579 Say 		oSay55 		Prompt "At้" 				SIZE 012, 007 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 017, 592 MSGET 	oDtPer2Fin 	VAR dDtPer2Fin 	When .t. 	SIZE 045, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 032, 005 SAY		oSay7 	PROMPT "Descr." 				SIZE 017, 008	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 033, 022 SCROLLBOX oDescCompl HORIZONTAL VERTICAL 		SIZE 034, 320 	OF oFolder1:aDialogs[1] BORDER

@ 035, 359 SAY 		oSay8 		PROMPT "Grupo" 				SIZE 017, 007 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 034, 379 MSGET 	oGrupo 		VAR cGrupo 		When .f.	SIZE 022, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 034, 401 MSGET 	oDescGrp 	VAR cDescGrp 	When .f.	SIZE 242, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 046, 350 SAY 		oSay9 		PROMPT "Sub Grupo" 			SIZE 028, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 045, 379 MSGET 	oSubGrupo 	VAR cSubGrupo 	When .f.	SIZE 022, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 045, 401 MSGET 	oDescSGrp 	VAR cDescSGrp 	When .f.	SIZE 242, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 057, 358 SAY 		oSay10 		PROMPT "Marca" 				SIZE 018, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 056, 379 MSGET 	oMarca 		VAR cMarca 		When .f.	SIZE 022, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 056, 401 MSGET 	oDescMarca 	VAR cDescMarca 	When .f.	SIZE 242, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 070, 006 SAY 		oSay1	 	PROMPT "Meses Base Consumo"	SIZE 055, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 069, 062 MSGET 	oMBaseCons 	VAR cMBaseCons 	When .f. 	SIZE 027, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 070, 290 SAY 		oSay12 		PROMPT "Proced๊ncia" 		SIZE 034, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 069, 325 MSGET 	oProced 	VAR cProced 	When .f. 	SIZE 021, 008 	OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 070, 350 SAY      oSayA1      PROMPT "Arm. De"            SIZE 028, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 069, 379 MSGET    oArm1       VAR _cArmDe                 SIZE 022, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL F3 "NNR" Valid Empty(_cArmDe) .Or. ExistCpo("NNR",_cArmDe)

@ 070, 440	 SAY    oSayA2      PROMPT "Arm. Ate"           SIZE 022, 007   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 069, 475 MSGET    oArm2       VAR _cArmAte                SIZE 020, 008   OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL F3 "NNR" Valid Empty(_cArmAte) .Or. ExistCpo("NNR",_cArmAte)


@ 070, 548 BUTTON 	oProcessa 	PROMPT "Processar"	Action MsAguarde({|| U_ConsProd()},"Aguarde","Processando...") SIZE 040, 008 OF oFolder1:aDialogs[1] PIXEL
@ 070, 602 BUTTON 	oFigura 	PROMPT "Figura" 	Action U_IGENM06(cProd)	SIZE 040, 008 OF oFolder1:aDialogs[1] PIXEL


//----|Estoque|--------------------------------------------------------------------------------

@ 081, 004 GROUP oGroup4 TO 194, 647 PROMPT "Estoque" 					OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
fMSNewGe1() // Cria msGetDados (Estoque)


// Picture B2_QATU - para quantidades (sem decimal)
cPic 	:= Substr(  Avsx3("B2_QATU"   ,6),1,  (at(".",Avsx3("B2_QATU"   ,6)) - 1 ) )

@ 152, 006 SAY 		oSay23 		PROMPT "Totais" 											SIZE 017, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 028 MSGET 	oTotEstRea 	VAR nTotEstRea 	When .f. Picture cPic						SIZE 058, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 147 MSGET 	oTotValEst 	VAR nTotValEst 	When .f. Picture Avsx3("B2_VATU1"  ,6)		SIZE 064, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 212 MSGET 	oTotReserv 	VAR nTotReserv 	When .f. Picture cPic						SIZE 049, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 261 MSGET 	oTotEntPro 	VAR nTotEntPro 	When .f. Picture cPic						SIZE 057, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 318 MSGET 	oTotSaiPro 	VAR nTotSaiPro 	When .f. Picture cPic						SIZE 056, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 148, 374 MSGET 	oTotDisp 	VAR nTotDisp 	When .f. Picture cPic						SIZE 055, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 148, 595 BUTTON 	oButtonD1	PROMPT "Detalhes" Action U_ShowDet(oMSNewGe1:obrowse:nColPos,oMSNewGe1:obrowse:nAt) SIZE 050, 010 	OF oFolder1:aDialogs[1] PIXEL

@ 162, 006 SAY 		oSay24 		PROMPT "Pre็o a Vista" 										SIZE 035, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 160, 050 MSGET	oPrecoVist 	VAR cPrecoVist 	When .f. Picture "@E 9,999,999.99"		SIZE 046, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

//   	@ 162, 099 SAY 		oSay27 		PROMPT "Armaz้m Vit๓ria" 									SIZE 040, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
//   	@ 160, 141 MSGET 	oArmVit 	VAR cArmVit 	When .f. Picture avsx3("B2_QNPT"   ,6)		SIZE 046, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 162, 099 SAY 		oSay28 		PROMPT "Armaz้m Geral" 										SIZE 039, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 160, 141 MSGET 	oArmGer 	VAR cArmGer 	When .f. Picture avsx3("B2_QNPT"   ,6)		SIZE 046, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 161, 390 GROUP oGroup5 TO 186, 515 PROMPT "Previsใo de Entrega" 										  OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
@ 161, 517 GROUP oGroup6 TO 186, 642 PROMPT "Pr้ Venda"													  OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL

@ 173, 097 SAY		oSay29 		PROMPT "Qtde. Ent. Transf." 								SIZE 044, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 141 MSGET	oEntTransf 	VAR cEntTransf 	When .f. Picture avsx3("B2__QTDTRA",6)		SIZE 046, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 173, 521 SAY 		oSay14 		PROMPT "Qtde." 												SIZE 015, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 409 MSGET 	oPrevEntr 	VAR cPrevEntr 	When .f. Picture avsx3("C7_QUANT"  ,6)		SIZE 060, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 472 BUTTON 	oConsDtEnt 	PROMPT "Consultar" Action U_ICOMA04(cProd,Substr(oMSNewGe1:Acols[oMSNewGe1:nat][1],1,TamSX3("B1_FILIAL")[1]))            		SIZE 040, 008 OF oFolder1:aDialogs[1] PIXEL

@ 173, 394 SAY 		oSay13 		PROMPT "Qtd." 												SIZE 015, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 538 MSGET 	oQtdPreVnd 	VAR cQtdPreVnd 	When .f.									SIZE 041, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 173, 580 SAY 		oSay15 		PROMPT "Saldo" 												SIZE 016, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 597 MSGET 	oSldPreVnd 	VAR cSldPreVnd 	When .f.									SIZE 041, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 173, 006 SAY 		oSay25 		PROMPT "Pre็o a Vista SP" 									SIZE 044, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 171, 050 MSGET 	oPrecVSP 	VAR cPrecVSP 	When .f. Picture "@E 9,999,999.99"   		SIZE 046, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 184, 097 SAY 		oSay16 		PROMPT "Cross Dock" 										SIZE 031, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 182, 141 MSGET 	oCrossDock 	VAR cCrossDock 	When .f. 									SIZE 046, 008 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

@ 184, 006 SAY 		oSay26 		PROMPT "Pre็o D๓lar" 										SIZE 030, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ 182, 050 MSGET 	oDolar 		VAR cDolar 		When .f. Picture "@E 9,999.999"				SIZE 046, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL

//Consulta Vendas Perํodo 1 e 2
@ 194, 004 GROUP oGroup7 TO 268, 324 PROMPT "Perํodo 1" 										OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
@ 194, 324 GROUP oGroup8 TO 268, 647 PROMPT "Perํodo 2"											OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL
//   	@ 255, 293 BUTTON 	oButtonD2 	     PROMPT "Detalhes" Action U_ICOMA04(cProd)	SIZE 030, 008	OF oFolder1:aDialogs[1] PIXEL
//   	@ 255, 615 BUTTON 	oButtonD3 	     PROMPT "Detalhes" Action U_ICOMA04(cProd)	SIZE 030, 008	OF oFolder1:aDialogs[1] PIXEL

fMSNewGe2() // Cria msGetDados (Sele็ใo 1)
fMSNewGe3() // Cria msGetDados (Sele็ใo 2)

//-----------------------------------------------------------------------------------\
//FOLDER 2 [KIT]-------------------------------------------------------------------|||
//-----------------------------------------------------------------------------------/


@ 004, 004 GROUP oGroupk1 TO 100, 647 PROMPT "Sele็ใo"					  OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
@ 007, 378 GROUP oGroupk2 TO 033, 508 PROMPT "Perํodo 1"				  OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
@ 007, 512 GROUP oGroupk3 TO 033, 642 PROMPT "Perํodo 2"				  OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL

@ 012, 008 SAY 		oSayk01 	PROMPT "Empr." 				SIZE 014, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 010, 022 MSGET 	oGetk01 	VAR cEmprk		When .f. 	SIZE 020, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 010, 043 MSGET	oGetk02 	VAR cEmprkDesc	When .f.   	SIZE 200, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 012, 248 SAY      oSay30       PROMPT "Origem"             SIZE 018, 007   OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 010, 270 MSGET    oOrig       VAR cOrig       When .f.     SIZE 025, 008   OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 010, 295 MSGET    oDescOrig 	VAR cDescOrig   When .f.     SIZE 80, 008    OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 025, 012 SAY      oSayk06     PROMPT "Kit"                SIZE 008, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 023, 022 MSGET    oGetk03     VAR cKit        When .t.    Picture PesqPict("SB1","B1_COD") Valid IIF(!Empty(cKit),U_ShowIt(),.f.)   SIZE 041, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL  F3 "SUG_AC"
@ 023, 066 MSGET    oGetk04     VAR cKitDesc    When .f.    SIZE 310, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 018, 379 SAY 		oSayk02 	PROMPT "Data" 				SIZE 015, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 016, 396 MSGET 	oGetk05 	VAR dDtPrk1Ini 	When .t. 	SIZE 041, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 018, 445 SAY 		oSayk03 	PROMPT "At้" 				SIZE 009, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 016, 461 MSGET 	oGetk06 	VAR dDtPrk1Fin 	When .t. 	SIZE 041, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 018, 514 SAY 		oSayk04 	PROMPT "Data" 				SIZE 014, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 016, 532 MSGET 	oGetk07 	VAR dDtPrk2Ini 	When .t. 	SIZE 041, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 018, 579 SAY 		oSayk05 	PROMPT "At้" 				SIZE 013, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 016, 592 MSGET 	oGetk09 	VAR dDtPrk2Fin 	When .t. 	SIZE 041, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

fMSNewGek1()

@ 089, 007 SAY 		oSayk07 	PROMPT "Meses Base Consumo"	SIZE 055, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 088, 062 MSGET 	oGetk10 	VAR cMBaseConk 	When .f.	SIZE 023, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 089, 230 SAY 		oSayk08 	PROMPT "Proced๊ncia" 		SIZE 034, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 088, 264 MSGET 	oGetk11 	VAR cProcedk 	When .f. 	SIZE 022, 008 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 088, 494 BUTTON 	oButtonk2 	PROMPT "Processar" 			Action U_ConsKit()	    										SIZE 037, 010 OF oFolder1:aDialogs[2] PIXEL
@ 088, 549 BUTTON 	oButtonk1 	PROMPT "Figura" 			Action U_IGENM06(cKit)   					   				    SIZE 037, 010 OF oFolder1:aDialogs[2] PIXEL
@ 088, 587 BUTTON 	oButtonk3 	PROMPT "Detalhes Produto" 	Action U_ShowDetPrd(oMSNewGe1K:aCols[oMSNewGe1K:obrowse:nAt,1])	SIZE 045, 010 OF oFolder1:aDialogs[2] PIXEL



//------|Estoque|-----------------------------------------------------------
@ 100, 004 GROUP oGroupk4 TO 207, 647 PROMPT "Estoque"												OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
fMSNewGek2()


// Picture B2_QATU - para quantidades (sem decimal)
cPic 	:= Substr(  Avsx3("B2_QATU"   ,6),1,  (at(".",Avsx3("B2_QATU"   ,6)) - 1 ) )


@ 163, 007 SAY oSayk09 PROMPT "Totais" 				   								SIZE 016, 008 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 163, 595 BUTTON 	oButtonD1K	PROMPT "Detalhes" Action U_ShowDetK(oMSNewGe2K:obrowse:nColPos,oMSNewGe2K:obrowse:nAt) SIZE 050, 010 	OF oFolder1:aDialogs[2] PIXEL

@ 162, 029 MSGET	oGetk16	VAR nTotEstRek 	When .f. Picture cPic					SIZE 057, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 162, 147 MSGET	oGetk18 VAR nTotVlEstk 	When .f. Picture Avsx3("B2_VATU1"  ,6)	SIZE 057, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 162, 204 MSGET	oGetk17 VAR nTotResrvk 	When .f. Picture cPic					SIZE 049, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 162, 253 MSGET 	oGetk13 VAR nTotEntPrk 	When .f. Picture cPic					SIZE 048, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 162, 301 MSGET 	oGetk15 VAR nTotSaiPrk 	When .f. Picture cPic					SIZE 042, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 162, 343 MSGET 	oGetk12 VAR nTotDispk 	When .f. Picture cPic					SIZE 042, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 174, 016 SAY		oSayk10	PROMPT "Pre็o a Vista" 									SIZE 033, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 173, 050 MSGET 	oGetk19 VAR cPrecoVisk	When .f. Picture avsx3("DA1_PRCVEN",6)	SIZE 060, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 185, 007 SAY 		oSayk11 PROMPT "Pre็o a Vista SP"								SIZE 042, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 184, 050 MSGET	oGetk20 VAR cPrecVSPk	When .f. Picture avsx3("DA1_PRCVEN",6)	SIZE 060, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 196, 019 SAY 		oSayk12 PROMPT "Pre็o D๓lar" 									SIZE 030, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 195, 050 MSGET 	oGetk21	VAR cDolark 	When .f. 								SIZE 060, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

//   	@ 174, 115 SAY 		oSayk13 PROMPT "Armaz้m Vit๓ria" 								SIZE 050, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
//   	@ 173, 156 MSGET 	oGetk22	VAR cArmVitk 	When .f. Picture avsx3("B2_QNPT"   ,6)	SIZE 060, 006 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 174, 117 SAY 		oSayk14 PROMPT "Armaz้m Geral" 			   						SIZE 038, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 173, 156 MSGET 	oGetk23	VAR cArmGerk 	When .f. Picture avsx3("B2_QNPT"   ,6)	SIZE 060, 006	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 186, 115 SAY 		oSayk15 PROMPT "Qtd. Ent. Transf." 								SIZE 041, 007	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 184, 156 MSGET 	oGetk24	VAR cEntTrnsfk	When .f. Picture avsx3("B2__QTDTRA",6)	SIZE 060, 006	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 173, 390 GROUP 	oGroupk7 TO 206, 515 PROMPT "Previsใo de Entrega"								OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
@ 173, 517 GROUP 	oGroupk8 TO 206, 642 PROMPT "Pr้-Venda"											OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL

@ 189, 521 SAY 		oSayk16	PROMPT "Qtd." 											SIZE 012, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 188, 409 MSGET 	oGetk25 VAR cPrevEntrk 	When .f. Picture avsx3("C7_QUANT"  ,6)	SIZE 041, 008 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 189, 472 BUTTON 	oButtonk3		PROMPT "Consultar" Action U_ICOMA04(cKit) When .f. 	SIZE 037, 008 	OF oFolder1:aDialogs[2] PIXEL

@ 189, 394 SAY 		oSayk17 PROMPT "Qtd." 											SIZE 012, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 188, 538 MSGET 	oGetk26 VAR cQtdPreVdk 	When .f. 								SIZE 041, 008 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

@ 189, 580 SAY	 	oSayk18 PROMPT "Saldo" 											SIZE 017, 007 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ 188, 597 MSGET 	oGetk27 VAR cSldPreVdk 	When .f. 								SIZE 041, 008 	OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL

//Consulta Vendas Perํodo 1 e 2
@ 207, 004 GROUP oGroupk5 TO 267, 324 PROMPT "Perํodo 1" 				OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL
@ 207, 324 GROUP oGroupk6 TO 267, 647 PROMPT "Perํodo 2" 				OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL

fMSNewGek3()
fMSNewGek4()     

oFolder1:bChange := {||U_ITMKC02B()}

ACTIVATE MSDIALOG oDlg CENTERED

Return

//------------------------------------------------
Static Function fMSNewGe1()
//------------------------------------------------
Local nX
Local aFieldFill 	:= {}
//                           1           2        3         4           5            6          7           8               9            10
Local aFields	 	:= {"B2_FILIAL","B2_QATU","B2_CM1","B2_VATU1","B2_RESERVA","B2__ENTPRC","B2__SAIPRC","B2__QTDISP","D1_EMISSAO", "D1_QUANT"}
Local aAlterFields 	:= {}
Static oMSNewGe1

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		
		if aFields[nX] = "B2_QATU"
			cTitCmp	:= "Estoque Real"
		Elseif aFields[nX] = "B2_CM1"
			cTitCmp := "Custo M้dio"
		Elseif aFields[nX] = "B2__QTDISP"
			cTitCmp := "Disponivel"
		Elseif aFields[nX] = "D1_EMISSAO"
			cTitCmp := "Dt Ult Comp"
		Elseif aFields[nX] = "B2_VATU1"
			cTitCmp := "Valor Estoque"
		Elseif aFields[nX] = "D1_QUANT"
			cTitCmp := "Qtd Compr"			
		else
			cTitCmp := AllTrim(X3Titulo())
		Endif
		
		if aFields[nX] = "B2__QTDISP"
			Aadd(aHeaderEx1, {cTitCmp,"B2__QTDISP",Substr(  SX3->X3_PICTURE,1,  (at(".",SX3->X3_PICTURE) - 1 ) ),SX3->X3_TAMANHO, 0  ,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Elseif aFields[nX] = "B2_CM1" .or. aFields[nX] = "B2_VATU1"
			Aadd(aHeaderEx1, {cTitCmp,SX3->X3_CAMPO,SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Else                                                                                                                     //Decimal
			Aadd(aHeaderEx1, {cTitCmp,SX3->X3_CAMPO,Substr(  SX3->X3_PICTURE,1,  (at(".",SX3->X3_PICTURE) - 1 ) ), SX3->X3_TAMANHO, 0      ,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
		
	Endif
	
Next nX

aAdd(aHeaderEx1, {"Custo ฺlt. Entr","B2_CM1",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})
aAdd(aHeaderEx1, {"Custo Comercial  ","B2_CM1",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEx1)
	If DbSeek(aHeaderEx1[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, "F")
Aadd(aFieldFill, .F.)
Aadd(aColsEx1, aFieldFill)

aColsEx1[1,9] := CtoD(Space(8))

oMSNewGe1 := MsNewGetDados():New( 087, 006, 146, 645, /*GD_INSERT+GD_DELETE+GD_UPDATE*/, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[1], aHeaderEx1, aColsEx1)

Return

//------------------------------------------------
Static Function fMSNewGe2()
//------------------------------------------------
Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"D2_FILIAL","D2_TOTAL", "D2_CUSTO1"}
Local aAlterFields 	:= {}

Static oMSNewGe2

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	
	If SX3->(DbSeek(aFields[nX]))
		
		if nX = 2
			aAdd(aHeaderEx2, {"Vendas","B2_QATU","9999999", SX3->X3_TAMANHO, 0,,,"N"})
		Endif
		
		if aFields[nX] = "D2_TOTAL"
			cTit := "Vlr. Venda"
			cPic := "@E 99,999,999.99
		Else
			cTit := AllTrim(X3Titulo())
			cPic := SX3->X3_PICTURE
		Endif
		
		Aadd(aHeaderEx2, {cTit,SX3->X3_CAMPO,cPic,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
	
Next nX

aAdd(aHeaderEx2, {"Lucro %","D2_TOTAL",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEx2)
	If DbSeek(aHeaderEx2[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEx2, aFieldFill)

oMSNewGe2 := MsNewGetDados():New( 201, 006, 265, 322, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[1], aHeaderEx2, aColsEx2)

Return

//------------------------------------------------
Static Function fMSNewGe3()
//------------------------------------------------
Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"D2_FILIAL", "D2_TOTAL", "D2_CUSTO1"}
Local aAlterFields 	:= {}

Static oMSNewGe3

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		if nX = 2
			aAdd(aHeaderEx3, {"Vendas","B2_QATU","9999999", SX3->X3_TAMANHO, 0,,,"N"})
		Endif
		
		if aFields[nX] = "D2_TOTAL"
			cTit := "Vlr. Venda"
			cPic := "@E 99,999,999.99
		Else
			cTit := AllTrim(X3Titulo())
			cPic := SX3->X3_PICTURE
		Endif
		
		Aadd(aHeaderEx3, {cTit,SX3->X3_CAMPO,cPic,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
	
Next nX

aAdd(aHeaderEx3, {"Lucro %","D2_TOTAL",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEx3)
	If DbSeek(aHeaderEx3[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEx3, aFieldFill)

oMSNewGe3 := MsNewGetDados():New( 201, 325, 265, 645, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[1], aHeaderEx3, aColsEx3)

Return
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConsProd  บAutor  ณAlexandre Caetano   บ Data ณ  08/Set/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPreenche dados da consulta conforme produto solicitado      บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณExclusivo ISAPA                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConsProd()
Private _nQtdTra := _nEntPrc := _nSaiPrc := 0 

SB1->(dbSetOrder(1))  // Filial + C๓digo do produto

If SB1->( dbSeek( xFilial("SB1") + cProd  ) )
	
	GetGrid1() //Atualiza Getdados de Estoque
	GetGrid2() //Atualiza Getdados Perํodo 1
	GetGrid3() //Atualiza Getdadso Perํodo 2
	
	cArmVit		:= GetArz()
	cArmGer 	:= GetArz()
	
	cPrecoVist	:= GetPrc("  ")
	cPrecVSP 	:= GetPrc("SP")
	cDolar		:= GetDolar()
	
	dbSelectArea("SB2")
	SB2->( dbSetOrder(1) )
	SB2->( dbSeek( xFilial("SB2") + Alltrim(cProd) ) )

	cEntTransf	:= _nQtdTra //GetEntTra()
	cPrevEntr 	:= GetPrvEntr()
	cQtdPreVnd	:= GetPrvVnd()
	cCrossDock	:= GetCross()
	
	cSldPreVnd	:= ( cPrevEntr - ( cCrossDock + cQtdPreVnd ) ) //( ( cCrossDock + cQtdPreVnd ) - cPrevEntr )
	
Else
	if !Empty(cProd)
		MsgAlert("Produto nใo localizado.","Aten็ใo !!!")
	Endif
	Return .f.
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGrid1  บAutor  ณAlexandre Caetano   บ Data ณ 12/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza dados do AColsEx1 (estoque)                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGrid1(PTipo)
Local cQry
Local nQuantD1, _nPosFil03 := 0
Local dEmissD1, _nItEntPrc := _nItSaiPrc := _nItQtdTra := 0  
Local nReserva, _cTbl := GetNextAlias()
Local nCstUltEnt, _lSZ8 := .f.
Local cSegArm	:= GetMV("MV__SEGARM")
Local nVlrA     := 0
Default PTipo := "PRD"

If Select("TMPB2") > 0
	dbSelectArea("TMPB2")
	DbCloseArea()
EndIf

If Select("TMPZ10") > 0
	dbSelectArea("TMPZ10")
	DbCloseArea()
EndIf

nTotEstRea	:= 0
nTotValEst	:= 0
nTotReserv	:= 0
nTotEntPro 	:= 0
nTotSaiPro  := 0
nTotDisp 	:= 0

// Consulta dados da B2
//cQry := " SELECT B2_FILIAL, B2_COD, B2_QATU, B2_CM1, B2_VATU1, B2_RESERVA, (B2_NAOCLAS + B2__ENTPRC) B2__ENTPRC, B2__SAIPRC, B2__QTDISP, B2__QTDTRA"
cQry := " SELECT B2_FILIAL, B2_COD, Nvl(Sum(B2_QATU), 0) B2_QATU, Nvl(Avg(B2_CM1), 0) B2_CM1, Nvl(Sum(B2_VATU1), 0) B2_VATU1, " 
cQry +=			"Nvl(Sum(B2_RESERVA), 0) B2_RESERVA, Nvl(Sum(B2__ENTPRC), 0) B2__ENTPRC, Nvl(Sum(B2__SAIPRC), 0) B2__SAIPRC, "
cQry +=			"Nvl(Sum(B2__QTDISP), 0) B2__QTDISP, Nvl(Sum(B2__QTDTRA), 0) B2__QTDTRA"
cQry += " FROM " + RetSQLName("SB2") + " B2 "
cQry += " WHERE B2_COD    = '" + cProd + "' "
cQry += " AND   B2.D_E_L_E_T_ = ' ' "
//cQry += " AND   B2_LOCAL = '01'    "
If !Empty(_cArmAte)
	cQry += " And B2_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' "
Else
	cQry += " And B2_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' "
EndIf
cQry += " AND   B2_FILIAL <> '01'  "
cQry += " Group By B2_FILIAL, B2_COD "
CQry += " ORDER BY B2_FILIAL       "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPB2",.T.,.F. )
//---------------------

//Consulta Z10 -> Reservas
cQry := " SELECT  Z10_FILIAL, Z10_PROD, Nvl(SUM(Z10_QTD), 0) AS RESERVA "
cQry += " FROM " + RetSQLName("Z10") + " Z10 "
cQry += " Left Join " + RetSqlName ("SUB") + " SUB on UB_FILIAL = Z10_FILIAL And UB_ITEM = Z10_ITEM And "
cQry += "		UB_NUM = Z10_CODSUA AND SUB.D_E_L_E_T_ = ' ' " 
cQry += " Left Join " + RetSqlName ("ZUB") + " ZUB on ZUB_FILIAL = Z10_FILIAL And ZUB_ITEM = Z10_ITEM And ZUB_NUM = Z10_CODSUA AND "
cQry +=	"		Z10_PROD = ZUB_PROD ANd ZUB.D_E_L_E_T_ = ' ' "
cQry += " Left Join " + RetSqlName("SC9") + " SC9 on C9_FILIAL = UB_FILIAL And C9_PEDIDO = UB_NUMPV And "
cQry += "		C9_ITEM = UB_ITEMPV And C9_NFISCAL = ' ' And SC9.D_E_L_E_T_ = ' ' "
cQry += " WHERE Z10_FILIAL <> '01'								"
cQry += " AND Z10_PROD = '" + cProd + "'                        "
If !Empty(_cArmAte)
	cQry += " And Z10_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' "
Else
	cQry += " And Z10_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' "
EndIf
cQry += " And (UB_PRODUTO is not null Or ZUB_PROD is not null) "
cQry += " And Z10.D_E_L_E_T_ = ' '                                 "
cQry += " GROUP BY Z10_FILIAL, Z10_PROD                         "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPZ10",.T.,.F. )
//-----------------------------------------------------------------

//Consulta Reserva SC9
cQry := "SELECT C9_FILIAL, NVL( SUM(C9_QTDLIB), 0 ) C9_QTDLIB FROM " + RetSqlName("SC9")  + " C9 "
cQry += " Inner Join " + RetSqlName("SC6") + " C6 on C6_FILIAL = C9_FILIAL And C6_NUM = C9_PEDIDO And C6_ITEM = C9_ITEM And "
cQry += 	" C6_PRODUTO = C9_PRODUTO And C6.D_E_L_E_T_ = ' ' "
cQry += " Inner Join "  + RetSqlName("SF4") + " F4 On F4_FILIAL = C6_FILIAL And F4_CODIGO = C6_TES And F4_ESTOQUE = 'S' And F4.D_E_L_E_T_ = ' ' "                       
cQry += "WHERE C9_FILIAL   <> '01' And C9_PRODUTO  = '" + cProd + "' And " 
If !Empty(_cArmAte)
	cQry += " C9_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' And "
Else
	cQry += " C9_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' And "
EndIf
cQry +=		" C9_NFISCAL = ' ' And C9.D_E_L_E_T_ = ' ' "
cQry += "Group By C9_FILIAL "

If Select(_cTbl) > 0
	DbSelectArea(_cTbl)
	DbCloseArea()
EndIf

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),_cTbl,.T.,.F. )

TMPB2->( dbGoTop() )

aColsEx1	:= {}
aColsEk2	:= {}
_aArmazx	:= {}
_cSegxxx	:= ''

If !Empty(cSegArm)
	For ixz:= 1 to Len(cSegArm)
		
		If substr(cSegArm,ixz,1) != '/'
			_cSegxxx	+= alltrim(substr(cSegArm,ixz,1))
		Else
			aAdd( _aArmazx,{_cSegxxx})
			_cSegxxx	:= ''
		Endif
		
	Next ixz
	
	If Alltrim(SB1->B1__SEGISP) == "1"		// BIKE
		
		For ixzP:= 1 to Len(_aArmazx)     
			If substr(_aArmazx[ixzP][1],1,1) == '1'
				// Produto
				_cArmazx := alltrim(substr(_aArmazx[ixzP][1],2,2))
				If PTipo == "PRD"
					aAdd( aColsEx1,{ _cArmazx, 0, 0,0, 0, 0, 0, 0, CtoD(Space(8)), 0, 0, 0,     .f.})
				Else
					// Kit
					aAdd( aColsEk2,{ _cArmazx, 0, 0, 0, 0, 0, 0, 0, CtoD(Space(8)), 0, 0, 0,     .f.})
				Endif
			Endif
		Next ixzP
		
	Elseif Alltrim(SB1->B1__SEGISP) == "2"   // AUTO
		
		For ixzA:= 1 to Len(_aArmazx)
			If substr(_aArmazx[ixzA][1],1,1) == '2'
				// Produto
				_cArmazx := alltrim(substr(_aArmazx[ixzA][1],2,2))
				If PTipo == "PRD"
					aAdd( aColsEx1,{ _cArmazx, 0, 0,0, 0, 0, 0, 0, CtoD(Space(8)), 0, 0, 0,     .f.})
				Else
					// Kit
					aAdd( aColsEk2,{ _cArmazx, 0, 0,0, 0, 0, 0, 0, CtoD(Space(8)), 0, 0, 0,     .f.})
				Endif
			Endif
		Next ixzA
	Endif
Endif

Do While TMPB2->( !EoF() )
	
	// Encontra ultima entrada (SD1) com TES que movimenta estoque
	If Select("TMPD1") > 0
		dbSelectArea("TMPD1")
		DbCloseArea()
	EndIf
	
	cQry := " SELECT MAX(D1_DTDIGIT) D1_DTDIGIT,D1.R_E_C_N_O_ D1RECNO, D1_DOC,A2_NREDUZ,D1_QUANT,D1_VUNIT,D1_VALIPI,D1_IPI,D1_VALICM,D1_ICMSRET,D1_VALIMP5,D1_VALIMP6,
	cQry +=			"D1_SEGURO,D1_DESPESA,D1_VALFRE,D1__AJIVA,D1_FILIAL,D1_DTDIGIT,D1_CLASFIS,D1_PICM,D1_CUSTO "
	cQry += " FROM " + RetSQLName("SD1") + " D1 "
	cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON D1_FILIAL = F4_FILIAL AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' And F4.D_E_L_E_T_ = ' ' "
	cQry += " INNER JOIN " + RetSQLName("SA2") + " A2 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ' '"
	cQry += " WHERE D1_FILIAL = '" + TMPB2->B2_FILIAL + "' And D1_COD = '" + cProd  + "'And D1.D1_DTDIGIT >=  '20150501'  And D1_TIPO = 'N' And "
	If !Empty(_cArmAte)
		cQry += " D1_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' And "
	Else
		cQry += " D1_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' And "
	EndIf
	cQry += " D1.D_E_L_E_T_ = ' '  "
	cQry += "Group By D1.R_E_C_N_O_,D1_DOC,A2_NREDUZ,D1_QUANT,D1_VUNIT,D1_VALIPI,D1_IPI,D1_VALICM,D1_ICMSRET,D1_VALIMP5,"
	cQry +=			 "D1_VALIMP6,D1_SEGURO,D1_DESPESA,D1_VALFRE,D1__AJIVA,D1_FILIAL,D1_DTDIGIT,D1_CLASFIS,D1_PICM,D1_CUSTO"
	cQry += "Order By D1.R_E_C_N_O_ DESC "
	cQry := ChangeQuery(cQry)
	DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD1",.T.,.F. )
	//------------------------------------------------------------
	
	TMPD1->( dbGoTop() )
	
	nQuantD1	:= TMPD1->D1_QUANT
	dEmissD1	:= StoD(TMPD1->D1_DTDIGIT)
	nCstUltEnt  := (TMPD1->D1_CUSTO +  TMPD1->D1__AJIVA)/TMPD1->D1_QUANT //( TMPD1->D1_VUNIT + TMPD1->D1__AJIVA )
	_nRecSD1    := TMPD1->D1RECNO
	//------------------------------------------------
	
	// Localiza reserva da Z10
	// TMPZ10 terแ no Maximo 5 registros.
	TMPZ10->(dbGoTop())
	Do While TMPZ10->(!EoF())
		if TMPZ10->Z10_FILIAL = TMPB2->B2_FILIAL
			Exit
		Endif
		TMPZ10->(dbSkip())
	Enddo
	nReserva	:= TMPZ10->RESERVA //+ TMPB2->B2_RESERVA
	
	(_cTbl)->(dbGoTop())
	Do While (_cTbl)->(!EoF())
		if (_cTbl)->C9_FILIAL = TMPB2->B2_FILIAL
			Exit
		Endif
		(_cTbl)->(dbSkip())
	Enddo
	nReserva	+= (_cTbl)->C9_QTDLIB	
	
	//------------------------------------------------
	
	if PTipo == "PRD"
		
		//SB1->(DbSeek(xFilial("SB1") + TMPB2->B2_FILIAL))
		//No segmento Bike, toda a quantidade disponivel da filial 05 serแ exibida na filial 03 
		If !Empty(_cArmAte)
			If Alltrim(SB1->B1__SEGISP) == "1" .And. TMPB2->B2_FILIAL == "05"
				nQtdisp := 0
			Else 
				nQtdisp := U_xSldPrd3(TMPB2->B2_FILIAL,TMPB2->B2_COD,_cArmDe," ",IIF(TMPB2->B2_FILIAL == "03"," ","ITMKC02")," "," ",_cArmAte)
			EndIf
		Else
			If Alltrim(SB1->B1__SEGISP) == "1" .And. TMPB2->B2_FILIAL == "05"
				nQtdisp := 0
			Else
				nQtdisp := U_xSldPrd3(TMPB2->B2_FILIAL,TMPB2->B2_COD,_cArmPad1," ",IIF(TMPB2->B2_FILIAL == "03"," ","ITMKC02")," "," ",_cArmPad2)
			EndIf
		EndIf
		nCstCom := GetCstCom("PRD",TMPB2->B2_FILIAL, TMPB2->B2_COD,_nRecSD1)
		nCstUltEnt := nCstCom[11]
		nCstCom := nCstCom[1]
		nPosFil := aScan( aColsEx1, {|x| x[1] == TMPB2->B2_FILIAL} )
		_nItQtdTra := U_IESTSLDPR(TMPB2->B2_FILIAL,TMPB2->B2_COD,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),;
							    Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),"T")
							
		_nItEntPrc := U_IESTSLDPR(TMPB2->B2_FILIAL,TMPB2->B2_COD,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),;
							      Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),"E")
							    
		_nItSaiPrc := U_IESTSLDPR(TMPB2->B2_FILIAL,TMPB2->B2_COD,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),;
							      Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),"S")
		
		_nEntPrc += _nItEntPrc 
		_nSaiPrc += _nItSaiPrc 
		_nQtdTra += _nItQtdTra
		_nPosFil03 := 0
		
		if Alltrim(SB1->B1__SEGISP) == "1" // Bike
			if TMPB2->B2_FILIAL == "05"
				_nPosFil03 := aScan( aColsEx1, {|x| x[1] == "03"} )
			Endif
		Endif
		
		if nPosFil > 0
			if _nItQtdTra > 0
				aColsEx1[nPosFil,01]:=	aColsEx1[nPosFil,01] + " T"			
			endif
			aColsEx1[nPosFil,02]	+=	TMPB2->B2_QATU
			aColsEx1[nPosFil,03]	+=	TMPB2->B2_CM1
			aColsEx1[nPosFil,04]	+=	TMPB2->B2_QATU * TMPB2->B2_CM1 //TMPB2->B2_VATU1
			aColsEx1[nPosFil,05]	+=	nReserva
			aColsEx1[nPosFil,06]	+=	_nItEntPrc //TMPB2->B2__ENTPRC
			aColsEx1[nPosFil,07]	+=	_nItSaiPrc //TMPB2->B2__SAIPRC
			If _nPosFil03 > 0
				aColsEx1[_nPosFil03,08]	+=	nQtdisp
			Else
				aColsEx1[nPosFil,08]	+=	nQtdisp
			EndIf
			aColsEx1[nPosFil,09]	:=	IIF(dEmissD1 > aColsEx1[nPosFil,09], dEmissD1,aColsEx1[nPosFil,09]) 
			aColsEx1[nPosFil,10]	+=	nQuantD1
			aColsEx1[nPosFil,11]	+=	nCstUltEnt
			aColsEx1[nPosFil,12]	+=	nCstCom
			aColsEx1[nPosFil,13]	:=  .f.			
			
			nTotEstRea += TMPB2->B2_QATU
			nTotValEst += TMPB2->B2_QATU * TMPB2->B2_CM1
			nTotReserv += nReserva
			nTotEntPro += _nEntPrc
			nTotSaiPro += _nSaiPrc
			nTotDisp   += nQtdisp
		Endif
/*		
	Elseif PTipo == "KIT"
		
		nCstComKit 	:= 0
		nCstTot		:= 0
		aRetorno 	:= DetCstComk(TMPB2->B2_FILIAL, .f.)
		
		nUltEnt		:= aRetorno[01]
		nCstComKit  := aRetorno[11]
		
		nQtdisp := U_xSldKit( TMPB2->B2_FILIAL, TMPB2->B2_COD, '01',) // U_xSldProd( TMPB2->B2_FILIAL, TMPB2->B2_COD, '01',)
		
		nKitTot := nQtdisp //99999999999999999999
		
		
		TMPU1->( dbGoTop() )
		
		Do While TMPU1->( !EoF() )
			
			nQtdKit := ( TMPB2->B2_QATU / TMPU1->U1_QTD )
			if nQtdKit < nKitTot
				nKitTot := nQtdKit
			Endif
			
			TMPU1->( dbSkip() )
		Enddo
		
		if nKitTot == 99999999999999999999
			nKitTot := 0
		Endif
		
		
		nPosFil := aScan( aColsEK2, {|x| x[1] == TMPB2->B2_FILIAL} )
		
		if Alltrim(SB1->B1__SEGISP) == "1" // Bike
			if TMPB2->B2_FILIAL == "05"
				nPosFil := aScan( aColsEk2, {|x| x[1] == "03"} )
			Endif
		Endif
		
		//aColsEk2[nPosFil,02]	:=	cKit
		aColsEk2[nPosFil,02]	+= 	nKitTot
		aColsEk2[nPosFil,03]	+= 	TMPB2->B2_CM1
		aColsEk2[nPosFil,04]	+= 	TMPB2->B2_VATU1
		aColsEk2[nPosFil,05]	+= 	TMPB2->B2_RESERVA
		aColsEk2[nPosFil,06]	+= 	TMPB2->B2__ENTPRC
		aColsEk2[nPosFil,07]	+=	TMPB2->B2__SAIPRC
		aColsEk2[nPosFil,08]	+=	nQtdisp
		aColsEk2[nPosFil,09]	:= 	dEmissD1
		aColsEk2[nPosFil,10]	+= 	nQuantD1
		aColsEk2[nPosFil,11]	+= 	nUltEnt
		aColsEk2[nPosFil,12]	+= 	nCstComKit
		aColsEk2[nPosFil,13]	:=	.f.
		
		/*
		aAdd(aColsEk2,{TMPB2->B2_FILIAL  , TMPB2->B2_COD    , nKitTot          , TMPB2->B2_CM1    , TMPB2->B2_VATU1   ,;
		TMPB2->B2_RESERVA , TMPB2->B2__ENTPRC, TMPB2->B2__SAIPRC, nQtdisp          ,;                   // Deleted
		dEmissD1          , nQuantD1         , nUltEnt          , nCstComKit       ,                       .f.})
		
		*/
		/*
		nTotEstRek	+= nKitTot
		nTotResrvk	+= TMPB2->B2_RESERVA
		nTotVlEstk	+= TMPB2->B2_VATU1
		nTotEntPrk	+= TMPB2->B2__ENTPRC
		nTotSaiPrk	+= TMPB2->B2__SAIPRC
		nTotDispk	+= nQtdisp
		*/
		
	Elseif PTipo == "KIT"
		
		//nQtdisp 	:= U_xSldKit( TMPB2->B2_FILIAL, TMPB2->B2_COD, '01',) 
		nQtdisp 	:= U_xSldKit( TMPB2->B2_FILIAL, cKit, '01',)
		nCstCom 	:= GetCstCom("KIT",TMPB2->B2_FILIAL, TMPB2->B2_COD,_nRecSD1)
		nCstCom 	:= nCstCom[1]
		aRetorno 	:= DetCstComk(TMPB2->B2_FILIAL, .f.)
		nUltEnt		:= aRetorno[01]
		nCstComKit  := aRetorno[11]
		
		nPosFil := aScan( aColsEK2, {|x| x[1] == TMPB2->B2_FILIAL} )
		
		if Alltrim(SB1->B1__SEGISP) == "1" // Bike
			if TMPB2->B2_FILIAL == "05"
				nPosFil := aScan( aColsEk2, {|x| x[1] == "03"} )
			Endif
		Endif
		
		nKitTot := nQtdisp 
		//aColsEk2[nPosFil,02]	:=	cKit
		aColsEk2[nPosFil,02]	+= 	nKitTot
		aColsEk2[nPosFil,03]	+= 	IIF(nKitTot > 0, TMPB2->B2_CM1, 0)  
		                                                    
		//Valor em estoque
		nVlrA := TMPB2->B2_VATU1/TMPB2->B2_QATU  
		nVlrA := nVlrA * nKitTot
		//aColsEk2[nPosFil,04]	+= 	TMPB2->B2_VATU1
		aColsEk2[nPosFil,04]	+= 	nVlrA
		
		aColsEk2[nPosFil,05]	+= 	nReserva //TMPB2->B2_RESERVA
		aColsEk2[nPosFil,06]	+= 	_nItEntPrc //TMPB2->B2__ENTPRC
		aColsEk2[nPosFil,07]	+=	_nItSaiPrc //TMPB2->B2__SAIPRC
		aColsEk2[nPosFil,08]	+=	nQtdisp //nQtdisp - TMPB2->B2_RESERVA
		aColsEk2[nPosFil,09]	:= 	IIF(dEmissD1 > aColsEk2[nPosFil,09], dEmissD1,aColsEk2[nPosFil,09])
		aColsEk2[nPosFil,10]	+= 	nQuantD1
		aColsEk2[nPosFil,11]	+= 	nUltEnt
		aColsEk2[nPosFil,12]	+= 	nCstComKit
		aColsEk2[nPosFil,13]	:=	.f.
		
		/*
		aAdd(aColsEx1,{TMPB2->B2_FILIAL  ,TMPB2->B2_QATU   ,TMPB2->B2_CM1    ,TMPB2->B2_VATU1  , nReserva  , ;         // Deleted
		TMPB2->B2__ENTPRC,TMPB2->B2__SAIPRC ,nQtdisp          ,dEmissD1,nQuantD1, nCstUltEnt, nCstCom,     .f.})
		*/
		
		/*nTotEstRek	+= nKitTot
		nTotResrvk	+= TMPB2->B2_RESERVA
		nTotVlEstk	+= TMPB2->B2_VATU1
		nTotEntPrk	+= TMPB2->B2__ENTPRC
		nToadmin	tSaiPrk	+= TMPB2->B2__SAIPRC
		nTotDispk	+= nQtdisp*/

	Endif
	
	TMPB2->( dbSkip() )
Enddo

if PTipo == "PRD"
	oMsNewGe1:aCols := aColsEx1
	oMSNewGe1:Refresh()
ElseIf PTipo == "KIT" 
			nTotEstRek := 0
			nTotResrvk := 0
			nTotVlEstk := 0
			nTotEntPrk := 0
			nTotSaiPrk := 0
			nTotDispk  := 0
		For I:=1 To Len(aColsEk2) 
			nTotEstRek	+= aColsEk2[I][2]
			nTotResrvk	+= aColsEk2[I][5]
			nTotVlEstk	+= aColsEk2[I][4]
			nTotEntPrk	+= aColsEk2[I][6]
			nTotSaiPrk	+= aColsEk2[I][7]
			nTotDispk	+= aColsEk2[I][8]
		Next
	oMsNewGe1:aCols := aColsEk2
	oMSNewGe1:Refresh()
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGrid2  บAutor  ณAlexandre Caetano   บ Data ณ 12/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza dados AColsEx2 (Vendas Perํodo 1)                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISAPA                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGrid2()
Local cQry
Local cSegArm	:= GetMV("MV__SEGARM")

If Select("TMPD2a") > 0
	dbSelectArea("TMPD2a")
	DbCloseArea()
EndIf

cQry := " SELECT D2_FILIAL, SUM(D2_QUANT) AS VENDA, SUM(D2_TOTAL - (D2_VALIMP5 + D2_VALIMP6 + D2_VALICM)) AS VALVENDA, "
cQry += " SUM(D2_CUSTO1) AS VALCUSTO, D2_COD FROM " + RetSQLName("SD2") + " D2 "
cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' And F4.D_E_L_E_T_ = ' ' "
cQry += " INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' AND SUBSTR( A1_CGC,1,8 ) <> '" + cCNPJ + "' "
cQry += " WHERE D2_FILIAL <> '01' And D2_COD  = '" + cProd + "' And "
If !Empty(_cArmAte)
	cQry += " D2_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' And "
Else
	cQry += " D2_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' And "
EndIf
cQry += " D2_EMISSAO  >= '" + DtoS(dDtPer1ini) + "' And D2_EMISSAO  <= '" + DtoS(dDtPer1fin) + "' And D2_TIPO = 'N' And D2.D_E_L_E_T_ = ' ' "
cQry += " GROUP BY D2_FILIAL, D2_COD "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD2a",.T.,.F. )
//------------------------------------------------------------

TMPD2a->( dbGoTop() )
aColsEx2 := {}
_aArmazx	:= {}
_cSegxxx	:= ''

If !Empty(cSegArm)
	For ixz:= 1 to Len(cSegArm)
		
		If substr(cSegArm,ixz,1) != '/'
			_cSegxxx	+= alltrim(substr(cSegArm,ixz,1))
		Else
			aAdd( _aArmazx,{_cSegxxx})
			_cSegxxx	:= ''
		Endif
		
	Next ixz
	
	If Alltrim(SB1->B1__SEGISP) == "1"		// BIKE
		
		For ixzP:= 1 to Len(_aArmazx)     
			If substr(_aArmazx[ixzP][1],1,1) == '1'
				_cArmazx := alltrim(substr(_aArmazx[ixzP][1],2,2))
				aAdd( aColsEx2,{ _cArmazx, 0, 0,0, 0, .f.})
			Endif
		Next ixzP
		
	Elseif Alltrim(SB1->B1__SEGISP) == "2"   // AUTO
		
		For ixzA:= 1 to Len(_aArmazx)
			If substr(_aArmazx[ixzA][1],1,1) == '2'
				_cArmazx := alltrim(substr(_aArmazx[ixzA][1],2,2))
				aAdd( aColsEx2,{ _cArmazx, 0, 0,0, 0, .f.})
			Endif
		Next ixzA
		
	Endif
Endif

Do While TMPD2a->( !EoF() )
	nPosFil := aScan( aColsEx2, {|x| x[1] == TMPD2a->D2_FILIAL} )
		
	if Alltrim(SB1->B1__SEGISP) == "1" // Bike
		if TMPD2a->D2_FILIAL == "05"
			nPosFil := aScan( aColsEx2, {|x| x[1] == "03"} )
		Endif
	Endif
		
	aColsEx2[nPosFil,02]	+= 	TMPD2a->VENDA
	aColsEx2[nPosFil,03]	+= 	TMPD2a->VALVENDA
	aColsEx2[nPosFil,04]	+= 	TMPD2a->VALCUSTO
//	aColsEx2[nPosFil,05]	+= 	( (TMPD2a->VENDA / TMPD2a->VALCUSTO) * 100)
	aColsEx2[nPosFil,05]	+= 	(1 - (TMPD2a->VALCUSTO / TMPD2a->VALVENDA))  * 100
	aColsEx2[nPosFil,06]	:=	.f.

	//                      1                  2                3                  4                             5                       //Deleted
	//	aAdd(aColsEx2,{TMPD2a->D2_FILIAL, TMPD2a->VENDA, TMPD2a->VALVENDA, TMPD2a->VALCUSTO, ( (TMPD2a->VENDA / TMPD2a->VALCUSTO) * 100),    .f. })
	TMPD2a->( dbSkip() )
Enddo

oMsNewGe2:aCols := aColsEx2
oMSNewGe2:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGrid3  บAutor  ณAlexandre Caetano   บ Data ณ 12/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณAtualiza dados AColsEx3 (Vendas Perํodo 2 )                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISAPA                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGrid3()
Local cQry
Local cSegArm	:= GetMV("MV__SEGARM")

If Select("TMPD2b") > 0
	dbSelectArea("TMPD2b")
	DbCloseArea()
EndIf

cQry := " SELECT D2_FILIAL, SUM(D2_QUANT) AS VENDA, SUM(D2_TOTAL - (D2_VALIMP5 + D2_VALIMP6 + D2_VALICM)) AS VALVENDA, "
cQry += " SUM(D2_CUSTO1) AS VALCUSTO, D2_COD "
cQry += " FROM " + RetSQLName("SD2") + " D2 "
cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON D2_FILIAL = F4_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' '"
cQry += " INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SUBSTR( A1_CGC,1,8 ) <> '" + cCNPJ + " '"
cQry += " AND A1.D_E_L_E_T_ = ' ' "
cQry += " WHERE D2.D_E_L_E_T_ = ' ' "
cQry += " AND   D2_COD      = '" + cProd             + "' "
cQry += " AND   D2_EMISSAO  >= '" + DtoS(dDtPer2ini) + "' "
cQry += " AND   D2_EMISSAO  <= '" + DtoS(dDtPer2fin) + "' "
cQry += " AND   D2_TIPO = 'N' "
cQry += " AND   D2_FILIAL <> '01'"
cQry += " GROUP BY D2_FILIAL, D2_COD "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD2b",.T.,.F. )
//------------------------------------------------------------

TMPD2b->( dbGoTop() )
aColsEx3 := {}
_aArmazx	:= {}
_cSegxxx	:= ''

If !Empty(cSegArm)
	For ixz:= 1 to Len(cSegArm)
		
		If substr(cSegArm,ixz,1) != '/'
			_cSegxxx	+= alltrim(substr(cSegArm,ixz,1))
		Else
			aAdd( _aArmazx,{_cSegxxx})
			_cSegxxx	:= ''
		Endif
		
	Next ixz
	
	If Alltrim(SB1->B1__SEGISP) == "1"		// BIKE
		
		For ixzP:= 1 to Len(_aArmazx)     
			If substr(_aArmazx[ixzP][1],1,1) == '1'
				_cArmazx := alltrim(substr(_aArmazx[ixzP][1],2,2))
				aAdd( aColsEx3,{ _cArmazx, 0, 0,0, 0, .f.})
			Endif
		Next ixzP
		
	Elseif Alltrim(SB1->B1__SEGISP) == "2"   // AUTO
		
		For ixzA:= 1 to Len(_aArmazx)
			If substr(_aArmazx[ixzA][1],1,1) == '2'
				_cArmazx := alltrim(substr(_aArmazx[ixzA][1],2,2))
				aAdd( aColsEx3,{ _cArmazx, 0, 0,0, 0, .f.})
			Endif
		Next ixzA
		
	Endif
Endif

Do While TMPD2b->( !EoF() )
	
	nPosFil := aScan( aColsEx3, {|x| x[1] == TMPD2b->D2_FILIAL} )
		
	if Alltrim(SB1->B1__SEGISP) == "1" // Bike
		if TMPD2b->D2_FILIAL == "05"
			nPosFil := aScan( aColsEx3, {|x| x[1] == "03"} )
		Endif
	Endif
		
	aColsEx3[nPosFil,02]	+= 	TMPD2b->VENDA
	aColsEx3[nPosFil,03]	+= 	TMPD2b->VALVENDA
	aColsEx3[nPosFil,04]	+= 	TMPD2b->VALCUSTO
	aColsEx3[nPosFil,05]	+= 	(1 - (TMPD2b->VALCUSTO / TMPD2b->VALVENDA)) * 100 //( (TMPD2b->VALCUSTO / TMPD2b->VALVENDA) * 100)
//	aColsEx3[nPosFil,05]	+= 	( (TMPD2b->VENDA / TMPD2b->VALCUSTO) * 100)
	aColsEx3[nPosFil,06]	:=	.f.

	//                      1                  2                3                  4                             5                       //Deleted
//	aAdd(aColsEx3,{TMPD2b->D2_FILIAL, TMPD2b->VENDA, TMPD2b->VALVENDA, TMPD2b->VALCUSTO, ( (TMPD2b->VENDA / TMPD2b->VALCUSTO) * 100),    .f. })
	TMPD2b->( dbSkip() )
Enddo

oMsNewGe3:aCols := aColsEx3
oMSNewGe3:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetArz   บAutor  ณAlexandre Caetano    บ Data ณ 16/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca estoque do Armazem                                    บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetArz()
Local nRet	:= 0
Local cSeg
Local aArea := GetArea()

dbSelectArea("SB1")
cSeg := Val(Posicione("SB1",1,xFilial("SB1")+cProd,"B1__SEGISP"))

dbSelectArea("SB2")
SB2->( dbSetOrder(1) )

if cSeg = 1      //Bikes
	SB2->( dbSeek( "03" + Alltrim(cProd) ) )
	nRet	:= SB2->B2_QNPT
Elseif cSeg = 2 // Auto Pe็as
	SB2->( dbSeek( "05" + Alltrim(cProd) ) )
	nRet	:= SB2->B2_QNPT
Endif

RestArea(aArea)

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPrc    บAutor  ณAlexandre Caetano   บ Data ณ  16/SET/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPre็o de venda (DA1)                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณISAPA                                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPrc(PUF)
//Local cQry
Local nRet := 0

If PUF == "SP" .And. Val(Posicione("SB1",1,xFilial("SB1") + cProd,"B1__SEGISP")) == 1
	nRet := U_ITMKC05(cProd,PUF,"001","T","SP")
Else
	nRet := U_ITMKC05(cProd,PUF,"001","T",Space(2))
EndIf

/*
If Select("TMPDA1") > 0
dbSelectArea("TMPDA1")
DbCloseArea()
EndIf

cQry := " SELECT DA1_PRCVEN, DA1_DATVIG"
cQry += " FROM " + RetSqlName("DA1") + " DA1 "
cQry += " WHERE DA1_CODPRO =  '" + cProd           + "' "
cQry += " AND   DA1_DATVIG <= '" + DtoS(dDataBase) + "' "
cQry += " AND   DA1_ESTADO = '" +  PUF             + "' "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPDA1",.T.,.F. )

TMPDA1->( dbGoTop() )
nRet := iif( TMPDA1->(EoF()),0,TMPDA1->DA1_PRCVEN )
*/

Return(nRet)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPrvVnd บAutor  ณAlexandre Caetano   บ Data ณ  16/Set/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPrevisใo de Venda                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPrvVnd()
Local cQry
Local nRet := 0

If Select("TMPSUA") > 0
	dbSelectArea("TMPSUA")
	DbCloseArea()
EndIf

cQry := " SELECT UA_NUM, SUM(UB_QUANT) "
cQry += " FROM " + RetSQLName("SUA") + " SUA "
cQry += " JOIN " + RetSQLName("SUB") + " SUB ON ( UA_FILIAL = UB_FILIAL AND UA_NUM = UB_NUM) "
cQry += " WHERE UA_FILIAL Not In('01') And SUA.D_E_L_E_T_ = ' '  AND SUB.D_E_L_E_T_ = ' '  "
cQry += " AND   UA_CANC = ' ' AND   UA__TIPPED = '" + cPreVnd + "' "
cQry += " AND   UB_PRODUTO = '" + cProd +   "' "
cQry += " GROUP BY UA_NUM                      "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPSUA",.T.,.F. )

TMPSUA->( dbGoTop() )
nRet := iif( TMPSUA->(EoF()),0,TMPSUA->UB_QUANT )

Return(nRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetPrvEntrบAutor  ณAlexandre Caetano   บ Data ณ             บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Previsใo de entrega                                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetPrvEntr()
Local cQry
Local nRet	:= 0

If Select("TMPC7") > 0
	dbSelectArea("TMPC7")
	DbCloseArea()
EndIf

cQry := " SELECT SUM(C7_QUANT - C7_QUJE - C7_QTDACLA) AS PreVend     "
cQry += " FROM " + RetSqlName("SC7") + " C7   "
cQry += " WHERE C7_FILIAL Not In ('01') And C7_PRODUTO =  '" + cProd + "' AND   C7_RESIDUO <> 'S' AND C7_QUANT > (C7_QUJE + C7_QTDACLA)	And "
cQry += 	"D_E_L_E_T_ = ' ' "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPC7",.T.,.F. )

TMPC7->(dbGoTop())
nRet :=  iif( TMPC7->(EoF()), 0 , TMPC7->PreVend )

Return(nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetEntTraบAutor  ณLuis Carlos   บ Data ณ Mar็o / 2015       บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Qtde em trโnsito                                           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetEntTra()
Local cQry
Local nRet	:= 0

If Select("TMPSB2") > 0
	dbSelectArea("TMPSB2")
	DbCloseArea()
EndIf

cQry := " SELECT SUM(B2__QTDTRA) AS total     "
cQry += " FROM " + RetSqlName("SB2") + " SB2   "
cQry += " WHERE B2_COD =  '" + cProd + "' "
cQry += " AND D_E_L_E_T_ = ' '               "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPSB2",.T.,.F. )

TMPSB2->(dbGoTop())
nRet :=  iif( TMPSB2->(EoF()), 0 , TMPSB2->total )

Return(nRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetCross  บAutor  ณAlexandre Caetano   บ Data ณ 01/Out/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ CrossDock                                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCross()
Local cQry
Local nRet
Local nVal1	:= 0
Local nVal2	:= 0

If Select("TMPSZX") > 0
	dbSelectArea("TMPSZX")
	DbCloseArea()
EndIf
cQry := " SELECT Sum(ZX_SALDO) ZX_QTD From " + RetSQLName("SZX") + " SZX "
cQry += " WHERE ZX_FILIAL Not In ('01') And ZX_PRODUTO = '" + cProd + "' And "
cQry += 	"SZX.D_E_L_E_T_ = ' ' And ZX_SALDO > 0 "                 

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPSZX",.T.,.F. )
/*
If Select("TMPSC6") > 0
	dbSelectArea("TMPSC6")
	DbCloseArea()
EndIf

cQry := " SELECT Sum(C6_QTDVEN-C6_QTDENT)AS C6_QTD"
cQry += " FROM " + RetSQLName("SC6") + " SC6      "
cQry += " WHERE SC6.D_E_L_E_T_ = ' '               "
cQry += " AND   C6_PRODUTO = '" + cProd + "'      "
cQry += " AND   C6_FILIAL <> '01'                 "
cQry += " GROUP BY C6_QTDVEN,C6_QTDENT            "
cQry += " HAVING (C6_QTDVEN-C6_QTDENT) > 0        "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPSC6",.T.,.F. )
 */

TMPSZX->( dbGoTop() )
//TMPSC6->( dbGoTop() )


nVal1 := iif( TMPSZX->( EoF() ),0,TMPSZX->ZX_QTD)
/*
Do While TMPSC6->( !Eof() )
	nVal2 += TMPSC6->C6_QTD
	TMPSC6->( dbSkip())
Enddo
*/
nRet := nVal1 //( nVal1 + nVal2 )

Return(nRet)
//------------------------------------------------
Static Function fMSNewGek1()
//------------------------------------------------
Local nX
Local aFieldFill	:= {}
Local aFields 		:= {"U1_ACESSOR", "B1_DESC",  "U1_QTD"}
Local _aTitulo 		:= {"Item", "Descricao",  "Quantidade"}
Local aAlterFields 	:= {}
Static oMSNewGe1K

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		Aadd(aHeaderEk1, {_aTitulo[nx],SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEk1, aFieldFill)

oMSNewGe1K := MsNewGetDados():New( 034, 021, 087, 642, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[2], aHeaderEk1, aColsEk1)

Return

/* Monta msGetDados - Consulta por Kit
1 - Itens do Kit
2 - Estoque
3 - Perํodo 1
4 - Perํodo 2
*/
//------------------------------------------------
Static Function fMSNewGek2()
//------------------------------------------------
Local nX
Local aFieldFill := {}
//Local aFields := {"B2_FILIAL", "B2_COD", "B2_QATU", "B2_CM1", "B2_VATU1","B2_RESERVA","B2__ENTPRC", "B2__SAIPRC","B2__QTDISP", "D1_EMISSAO", "D1_QUANT"}
Local aFields := {"B2_FILIAL",  "B2_QATU", "B2_CM1", "B2_VATU1","B2_RESERVA","B2__ENTPRC", "B2__SAIPRC","B2__QTDISP", "D1_EMISSAO", "D1_QUANT"}
Local aAlterFields := {}
Static oMSNewGe2K

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		
		if aFields[nX] == "B2_QATU"
			cTitCmp	:= "Estoque Real"
		Elseif aFields[nX] == "B2_CM1"
			cTitCmp := "Custo M้dio"
		Elseif aFields[nX] == "B2__QTDISP"
			cTitCmp := "Disponivel"
		Elseif aFields[nX] == "D1_EMISSAO"
			cTitCmp := "Ult. Entrada"
		Elseif aFields[nX] == "B2_VATU1"
			CTitCmp := "Valor Estoque"
		else
			cTitCmp := AllTrim(X3Titulo())
		Endif
		
		if aFields[nX] = "B2__QTDISP" .or. aFields[nX] = "B2__ENTPRC" .or. aFields[nX] = "B2__SAIPRC"
			Aadd(aHeaderEk2, {cTitCmp,"B2_QATU","@E 99,999,999",10, 0  ,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Elseif aFields[nX] = "B2_CM1" .or. aFields[nX] = "B2_VATU1"  
			Aadd(aHeaderEk2, {cTitCmp,SX3->X3_CAMPO,SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL, SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Else                                                       	                                                              //Decimal
			Aadd(aHeaderEk2, {cTitCmp,SX3->X3_CAMPO,Substr(  SX3->X3_PICTURE,1,  (at(".",SX3->X3_PICTURE) - 1 ) ), SX3->X3_TAMANHO, 0      ,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
		
	Endif
Next nX

aAdd(aHeaderEk2, {"Cst ฺlt. Etr.","B2_CM1",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})
aAdd(aHeaderEk2, {"Cst Com."     ,"B2_CM1",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEk2)
	If DbSeek(aHeaderEk2[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEk2, aFieldFill)

aColsEk2[1,10] := CtoD(Space(8))


oMSNewGe2K := MsNewGetDados():New( 107, 006, 161, 642, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[2], aHeaderEk2, aColsEk2)

Return

//------------------------------------------------
Static Function fMSNewGek3()
//------------------------------------------------
Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"D2_FILIAL", "D2_TOTAL", "D2_CUSTO1"}
Local aAlterFields 	:= {}
Static oMSNewGe3K

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		if nX = 2
			aAdd(aHeaderEk3, {"Vendas","B2_QATU","9999999", SX3->X3_TAMANHO, 0,,,"N"})
		Endif
		
		if aFields[nX] = "D2_TOTAL"
			cTit := "Vlr. Venda"
			cPic := "@E 99,999,999.99
		Else
			cTit := AllTrim(X3Titulo())
			cPic := SX3->X3_PICTURE
		Endif
		
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeaderEk3, {cTit,SX3->X3_CAMPO,cPic,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Endif
Next nX

aAdd(aHeaderEk3, {"Lucro %","D2_TOTAL",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEk3)
	If DbSeek(aHeaderEk3[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEk3, aFieldFill)

oMSNewGe3K := MsNewGetDados():New( 213, 006, 265, 323, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[2], aHeaderEk3, aColsEk3)

Return

//------------------------------------------------
Static Function fMSNewGek4()
//------------------------------------------------
Local nX
Local aFieldFill := {}
Local aFields := {"D2_FILIAL", "D2_TOTAL", "D2_CUSTO1"}
Local aAlterFields := {}
Static oMSNewGe4K

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		if nX = 2
			aAdd(aHeaderEk4, {"Vendas","B2_QATU","9999999", SX3->X3_TAMANHO, 0,,,"N"})
		Endif
		
		if aFields[nX] = "D2_TOTAL"
			cTit := "Vlr. Venda"
			cPic := "@E 99,999,999.99
		Else
			cTit := AllTrim(X3Titulo())
			cPic := SX3->X3_PICTURE
		Endif
		
		If SX3->(DbSeek(aFields[nX]))
			Aadd(aHeaderEk4, {cTit,SX3->X3_CAMPO,cPic,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
			SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		Endif
	Endif
Next nX

aAdd(aHeaderEk4, {"Lucro %","D2_TOTAL",SX3->X3_PICTURE, SX3->X3_TAMANHO, SX3->X3_DECIMAL,,,"N"})

// Define field values
For nX := 1 to Len(aHeaderEk4)
	If DbSeek(aHeaderEk4[nX,2])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsEk4, aFieldFill)

oMSNewGe4K := MsNewGetDados():New( 213, 325, 265, 645, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oFolder1:aDialogs[2], aHeaderEk4, aColsEk4)

Return

//-----------------------


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowIt    บAutor  ณAlexandre Caetano   บ Data ณ22/Set/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche dados da consulta conforme kit solicitado         บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ShowIt()

nTotEstRek	:= 0
nTotResrvk	:= 0
nTotVlEstk	:= 0
nTotEntPrk	:= 0
nTotSaiPrk	:= 0
nTotDispk	:= 0

SUG->(dbSetOrder(2)) //
If SUG->( dbSeek( xFilial("SUG") + cKit ) )
	cCodAce := SUG->UG_CODACE
	GetGridK1() // Atualiza itens do kit / estoque
Endif

SB1->(dbSetOrder(1))  // Filial + C๓digo do produto

If SB1->( dbSeek( xFilial("SB1") + cKit  ) )   
	cMBaseConk	:= 	"1"
	cProcedK 	:=  SB1->B1__PROC           
EndIf

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowProd  บAutor  ณAlexandre Caetano   บ Data ณ28/Out/2014  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche dados do Produto                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ShowProd()
Local _cQuery  := ""
Local _cSegUsr := Val(U_SETSEGTO()) 
SB1->(dbSetOrder(1))  // Filial + C๓digo do produto

If SB1->( dbSeek( xFilial("SB1") + cProd  ) )

	/*If _cSegUsr > 0 .And. Val(SB1->B1__SEGISP) != _cSegUsr .And. Val(SB1->B1__SEGISP) > 0
		MsgStop("O produto informado nใo pertence ao seu sgmento.","Atencao")
		Return .f.
	EndIf*/
	
	cProdDesc	:=	SB1->B1_DESC
	@ 01, 001 Say Space(190)                   SIZE 190, 008 OF oDescCompl COLORS 0, 16777215 PIXEL
	@ 01, 001 SAY oSay56 PROMPT SB1->B1__DESCP SIZE 300, 030 OF oDescCompl COLORS 0, 16777215 PIXEL

	cGrupo		:=	SB1->B1_GRUPO
	SBM->( dbSetOrder(1) )	//Filial + Codigo do Grupo
	SBM->( dbSeek( xFilial("SBM") + cGrupo ) )
	cDescGrp 	:= SBM->BM_DESC
	
	cSubGrupo 	:= SB1->B1__SUBGRP
	SZ4->( dbSetOrder(1) )
	SZ4->( dbSeek( xFilial("SZ4") + cSubGrupo ) )
	cDescSGrp 	:= SZ4->Z4_DESC
	
	cMarca 		:= SB1->B1__MARCA
	SZ5->( dbSetOrder(1) )
	SZ5->( dbSeek( xFilial("SZ4") + cMarca ) )
	cDescMarca	:= SZ5->Z5_DESC
	
	cMBaseCons	:= 	"1"
	cProced 	:=  SB1->B1__PROC
	
	If Select("TMP_ACO") > 0
		DbSelectArea("TMP_ACO")
		DbCloseArea()
	EndIf	

	_cQuery := "SELECT ACP.ACP_CODPRO,                                                               " + Chr(13)
	_cQuery += "       ACP.ACP_PERDES                                                                " + Chr(13)
	_cQuery += "FROM " + RetSqlName("ACP") + " ACP                                                   " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("ACO") + " ACO ON ACO.ACO_FILIAL = ACP.ACP_FILIAL          " + Chr(13)
	_cQuery += "                         AND ACO.ACO_CODREG = ACP.ACP_CODREG                         " + Chr(13)
	_cQuery += "                         AND ACO.D_E_L_E_T_ = ' '                                    " + Chr(13)
	_cQuery += "WHERE ACP.D_E_L_E_T_ = ' '                                                           " + Chr(13)
	_cQuery += "      AND ACP.ACP_CODPRO = '" + SB1->B1_COD + "'                                     " + Chr(13)
	_cQuery += "      AND ACO.ACO_DATDE <= TO_CHAR(SYSDATE,'RRRRMMDD')                               " + Chr(13)
	_cQuery += "      AND (ACO.ACO_DATATE = ' ' OR ACO.ACO_DATATE >= TO_CHAR(SYSDATE,'RRRRMMDD'))    "
	TCQUERY _cQuery NEW ALIAS "TMP_ACO"

	If(!TMP_ACO->(Eof()) )	
		oSay90:Show()
	Else
		oSay90:Hide()
	EndIf
		
	TMP_ACO->(DbCloseArea())
	
	
	//Promo็ใo especial
	_cTb9 := GetNextAlias()
	_cQuery := "SELECT Z9_COD From " + RetSqlName("SZ9") + " Z9 "
	_cQuery += "Where Z9_FILIAL = '" + xFilial("SZ9") + "' And Z9_COD = '3037' And Z9_PRODUTO = '" + SB1->B1_COD + " ' And " 
	_cQuery +=	"Z9_MSBLQL = '2' And Z9.D_E_L_E_T_ = ' ' "
	
	If Select(_cTb9) > 0
		DbSelectArea(_cTb9)
		DbCloseArea()
	EndIf	
	
	DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,_cQuery ),_cTb9,.T.,.F. )

	If(!(_cTb9)->(Eof()) )	
		oSay91:Show()
	Else
		oSay91:Hide()
	EndIf
		
	If Select(_cTb9) > 0
		DbSelectArea(_cTb9)
		DbCloseArea()
	EndIf	
	
	DbSelectArea("SB1")
Else
	MsgAlert("Produto nใo localizado","Atencao")
	@ 01, 001 Say Space(190)                   SIZE 190, 008 OF oDescCompl COLORS 0, 16777215 PIXEL
	@ 01, 001 SAY oSay56 PROMPT "" SIZE 190, 008 OF oDescCompl COLORS 0, 16777215 PIXEL
	Return .f.
EndIf	


Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณConskit   บAutor  ณAlexandre Caetano   บ Data ณ  25/Set/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Traz dados do kit na tela                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ConsKit()

cArmVitk	:= GetArz()
cArmGerk 	:= GetArz()

cPrecoVisk	:= GetPrc("  ")
cPrecVSPk 	:= GetPrc("SP")

dbSelectArea("SB2")
SB2->( dbSetOrder(1) )
SB2->( dbSeek( xFilial("SB2") + Alltrim(cProd) ) )
cEntTrnsfk	:=	SB2->B2__QTDTRA

cPrevEntrk 	:= GetPrvEntr()
cQtdPreVdk	:= GetPrvVnd()
cSldPreVdk	:= ( cQtdPreVdk  - cPrevEntrk )

GetGridK3() // Atualiza Periodo 1 kit
GetGridK4() // Atualiza Periodo 2 kit

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGridK1 บAutor  ณAlexandre Caetano   บ Data ณ  22/Set/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche Getdados de Itens do Kit                          บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGridK1()
Local cQry := ""

If Select("TMPU1") > 0
	dbSelectArea("TMPU1")
	DbCloseArea()
EndIf

If Select("TMPU1b") > 0
	dbSelectArea("TMPU1b")
	DbCloseArea()
EndIf

cQry := " SELECT U1_ACESSOR, B1_DESC, U1_QTD           "
cQry += " FROM " + RetSQLName("SU1") + " SU1           "
cQry += " INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_FILIAL = U1_FILIAL AND B1_COD = U1_ACESSOR "
cQry += " AND   SB1.D_E_L_E_T_ = ' '                        "
cQry += " WHERE SU1.D_E_L_E_T_ = ' '                        "
//cQry += " AND   U1_CODACE = '" + cKit + " '             "
cQry += " AND   U1_CODACE = '" + cCodAce + " '             "
cQry += " AND   U1_FILIAL <> '01'                          "
cQry += " ORDER BY U1_ACESSOR "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPU1",.T.,.F. )
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPU1b",.T.,.F. )

aColsEk1 := {}

TMPU1b->( dbGoTop() )
Do While TMPU1b->( !EoF() )
	// Deleted
	aAdd(aColsEk1,{TMPU1b->U1_ACESSOR, TMPU1b->B1_DESC, TMPU1b->U1_QTD,     .f. })
	
	cProd  := TMPU1b->U1_ACESSOR   
	
	SB1->( dbSeek( xFilial("SB1") + cProd  ) )
	
	GetGrid1("KIT") // Monta o estoque
	
	TMPU1b->( dbSkip() )
Enddo 



oMsNewGe1K:aCols := aColsEk1
oMSNewGe1K:Refresh()

oMsNewGe2K:aCols := aColsEk2
oMSNewGe2K:Refresh()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGridK3 บAutor  ณAlexandre Caetano   บ Data ณ 24/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche dados de Vendas de Kitดs Periodo 1                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGridK3()
Local cQry
Local cSegArm	:= GetMV("MV__SEGARM")

//aColsEk3 := {}

If Select("TMPD2a") > 0
	dbSelectArea("TMPD2a")
	DbCloseArea()
EndIf                                                     
           
__cItKit := "("
For ixc := 1 to len(aColsEk1)
   	__cItKit += "'" + alltrim(aColsEk1[ixc][1])+"',"
Next ixc
__cItKit := left(__cItKit,len(__cItKit)-1) + ")"
		
cQry := " SELECT D2_FILIAL, D2_SERIE, D2_DOC, SUM(D2_TOTAL - (D2_VALIMP5 + D2_VALIMP6 + D2_VALICM) ) AS VALVENDA,SUM(D2_CUSTO1) AS D2_CUSTO1"
cQry += " FROM " + RetSQLName("SD2") + " D2 "
cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' '"
cQry += " INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND   SUBSTR( A1_CGC,1,8 ) <> '" + cCNPJ + " '"
cQry += " AND A1.D_E_L_E_T_ = ' ' "
//cQry += " INNER JOIN " + RetSQLName("SUA") + " UA ON UA_FILIAL = D2_FILIAL AND D2_DOC = UA_DOC AND D2_SERIE = UA_SERIE AND UA_DOC <> ' ' AND UA.D_E_L_E_T_ = ' '"
cQry += " WHERE D2.D_E_L_E_T_ = ' ' "
cQry += " AND   D2_EMISSAO  >= '" + DtoS(dDtPrk1Ini) + "'                               "
cQry += " AND   D2_EMISSAO  <= '" + DtoS(dDtPrk1Fin) + "'                               "
cQry += " AND   D2_TIPO = 'N'                                                           "
cQry += " AND   D2_FILIAL <> '01' AND D2_COD IN " + __cItKit
cQry += " GROUP BY D2_FILIAL, D2_SERIE, D2_DOC "
cQry += " ORDER BY D2_FILIAL, D2_SERIE, D2_DOC "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD2a",.T.,.F. )
//------------------------------------------------------------

//Or็amento televendas
SUA->( dbSetOrder(2) ) //Filial + Serie    + Doc
//Itens Or็amento
SUB->( dbSetOrder(1) ) //Filial + Num      + Item        + Produto
//Itens nota fiscal de saํda
SD2->( dbSetOrder(3) ) //Filial + Doc      + Serie       + Cliente + Loja + Produto + Item
//Cadastro de acessorio (KIT)
SUG->( dbSetOrder(2) ) //Filial + Produto
//Itens dos acessorios (KIT)
SU1->( dbSetOrder(1) ) //Filial + CodAce   + Acessorio

aColsEk3 := {}
_aArmazk	:= {}
_cSegxxk	:= ''

If !Empty(cSegArm)
	For ixz:= 1 to Len(cSegArm)
		
		If substr(cSegArm,ixz,1) != '/'
			_cSegxxk	+= alltrim(substr(cSegArm,ixz,1))
		Else
			aAdd( _aArmazk,{_cSegxxk})
			_cSegxxk	:= ''
		Endif
		
	Next ixz
	
	If Alltrim(SB1->B1__SEGISP) == "1"		// BIKE
		
		For ixzP:= 1 to Len(_aArmazk)     
			If substr(_aArmazk[ixzP][1],1,1) == '1'
				_cArmazk := alltrim(substr(_aArmazk[ixzP][1],2,2))
				aAdd( aColsEk3,{ _cArmazk, 0, 0,0, 0, .f.})
			Endif
		Next ixzP
		
	Elseif Alltrim(SB1->B1__SEGISP) == "2"   // AUTO
		
		For ixzA:= 1 to Len(_aArmazk)
			If substr(_aArmazk[ixzA][1],1,1) == '2'
				_cArmazk := alltrim(substr(_aArmazk[ixzA][1],2,2))
				aAdd( aColsEk3,{ _cArmazk, 0, 0,0, 0, .f.})
			Endif
		Next ixzA
		
	Endif
Endif

TMPD2a->( dbGoTop() )
Do While TMPD2a->( !EoF() )
	
//	If SUA->( dbSeek( ( xFilial("SUA") + TMPD2a->D2_SERIE + TMPD2a->D2_DOC ) ) )
//		if SUB->( dbSeek( xFilial("SUB") + SUA->UA_NUM + Strzero(Val(TMPD2a->D2_ITEM),4,0) + TMPD2a->D2_COD ) )
			//if	SUB->UB__CODKIT == cKit
			
			nPos := aScan( aColsEk3, {|x| x[1] == TMPD2a->D2_FILIAL} )
			
			if Alltrim(SB1->B1__SEGISP) == "1" // Bike
				if TMPD2a->D2_FILIAL == "05"
					nPos := aScan( aColsEk3, {|x| x[1] == "03"} )
				Endif
			Endif

			If nPos = 0 //Adiciona no Array
				//        Filial          Vendas  Pre็o de venda       Preco de custo        Lucro                                   Deleted
				aAdd( aColsEk3, {TMPD2a->D2_FILIAL,  1,    TMPD2a->VALVENDA,   TMPD2a->D2_CUSTO1, ((TMPD2a->D2_CUSTO1/TMPD2a->VALVENDA)*100),      .f.} )
			Else
				aColsEk3[nPos,2]++
				aColsEk3[nPos,3]+= TMPD2a->VALVENDA
				aColsEk3[nPos,4]+= TMPD2a->D2_CUSTO1
				aColsEK3[nPos,5]+= ((TMPD2a->D2_CUSTO1/TMPD2a->VALVENDA) * 100)
			Endif
			
			//Endif
//		Endif
//	Endif
	
	TMPD2a->( dbSkip() )
Enddo

oMsNewGe3k:aCols := aColsEk3
oMSNewGe3k:Refresh()

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetGridK4 บAutor  ณAlexandre Caetano   บ Data ณ 26/Set/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Preenche dados de Vendas de Kitดs Periodo 2                บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetGridK4()
Local cQry
Local cSegArm	:= GetMV("MV__SEGARM")

//aColsEk4 := {}

If Select("TMPD2b") > 0
	dbSelectArea("TMPD2b")
	DbCloseArea()
EndIf

__cItKit := "("
For ixc := 1 to len(aColsEk1)
   	__cItKit += "'" + alltrim(aColsEk1[ixc][1])+"',"
Next ixc
__cItKit := left(__cItKit,len(__cItKit)-1) + ")"

cQry := " SELECT D2_FILIAL, D2_SERIE, D2_DOC, SUM(D2_TOTAL - (D2_VALIMP5 + D2_VALIMP6 + D2_VALICM) ) AS VALVENDA, SUM(D2_CUSTO1) AS D2_CUSTO1"
cQry += " FROM " + RetSQLName("SD2") + " D2 "
cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND D2_TES = F4_CODIGO AND F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S'"
cQry += " AND F4.D_E_L_E_T_ = ' ' "
cQry += " INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND SUBSTR( A1_CGC,1,8 ) <> '" + cCNPJ + " '"
cQry += " AND A1.D_E_L_E_T_ = ' ' "
//cQry += " INNER JOIN " + RetSQLName("SUA") + " UA ON UA_FILIAL = D2_FILIAL AND D2_DOC = UA_DOC AND D2_SERIE = UA_SERIE AND UA_DOC <> ' ' AND UA.D_E_L_E_T_ = ' '"
cQry += " WHERE D2.D_E_L_E_T_ = ' ' "
cQry += " AND   D2_EMISSAO  >= '" + DtoS(dDtPrk2Ini) + "'                               "
cQry += " AND   D2_EMISSAO  <= '" + DtoS(dDtPrk2Fin) + "'                               "
cQry += " AND   D2_TIPO = 'N'                                                           "
cQry += " AND   D2_FILIAL <> '01' AND D2_COD IN " + __cItKit
cQry += " GROUP BY D2_FILIAL, D2_SERIE, D2_DOC  "
cQry += " ORDER BY D2_FILIAL, D2_SERIE, D2_DOC  "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD2b",.T.,.F. )
//------------------------------------------------------------

//Or็amento televendas
SUA->( dbSetOrder(2) ) //Filial + Serie    + Doc
//Itens Or็amento
SUB->( dbSetOrder(1) ) //Filial + Num      + Item        + Produto
//Itens nota fiscal de saํda
SD2->( dbSetOrder(3) ) //Filial + Doc      + Serie       + Cliente + Loja + Produto + Item
//Cadastro de acessorio (KIT)
SUG->( dbSetOrder(2) ) //Filial + Produto
//Itens dos acessorios (KIT)
SU1->( dbSetOrder(1) ) //Filial + CodAce   + Acessorio

aColsEk4 := {}
_aArmazk	:= {}
_cSegxxk	:= ''

If !Empty(cSegArm)
	For ixz:= 1 to Len(cSegArm)
		
		If substr(cSegArm,ixz,1) != '/'
			_cSegxxk	+= alltrim(substr(cSegArm,ixz,1))
		Else
			aAdd( _aArmazk,{_cSegxxk})
			_cSegxxk	:= ''
		Endif
		
	Next ixz
	
	If Alltrim(SB1->B1__SEGISP) == "1"		// BIKE
		
		For ixzP:= 1 to Len(_aArmazk)     
			If substr(_aArmazk[ixzP][1],1,1) == '1'
				_cArmazk := alltrim(substr(_aArmazk[ixzP][1],2,2))
				aAdd( aColsEk4,{ _cArmazk, 0, 0,0, 0, .f.})
			Endif
		Next ixzP
		
	Elseif Alltrim(SB1->B1__SEGISP) == "2"   // AUTO
		
		For ixzA:= 1 to Len(_aArmazk)
			If substr(_aArmazk[ixzA][1],1,1) == '2'
				_cArmazk := alltrim(substr(_aArmazk[ixzA][1],2,2))
				aAdd( aColsEk4,{ _cArmazk, 0, 0,0, 0, .f.})
			Endif
		Next ixzA
		
	Endif
Endif

TMPD2b->( dbGoTop() )
Do While TMPD2b->( !EoF() )
	
//	If SUA->( dbSeek( ( xFilial("SUA") + TMPD2b->D2_SERIE + TMPD2b->D2_DOC ) ) )
//		if SUB->( dbSeek( xFilial("SUB") + SUA->UA_NUM + Strzero(Val(TMPD2b->D2_ITEM),4,0) + TMPD2b->D2_COD ) )
			//if	SUB->UB__CODKIT == cKit
			
			nPos := aScan( aColsEk4, {|x| x[1] == TMPD2b->D2_FILIAL} )
			
			if Alltrim(SB1->B1__SEGISP) == "1" // Bike
				if TMPD2b->D2_FILIAL == "05"
					nPos := aScan( aColsEk4, {|x| x[1] == "03"} )
				Endif
			Endif

			If nPos = 0 //Adiciona no Array
				//        Filial          Vendas  Pre็o de venda       Preco de custo        Lucro                                   Deleted
				aAdd( aColsEk4, {TMPD2b->D2_FILIAL,  1,    TMPD2b->VALVENDA,   TMPD2b->D2_CUSTO1, ((TMPD2b->D2_CUSTO1/TMPD2b->VALVENDA)*100),      .f.} )
			Else
				aColsEk4[nPos,2]++
				aColsEk4[nPos,3]+= TMPD2b->VALVENDA
				aColsEk4[nPos,4]+= TMPD2b->D2_CUSTO1
				aColsEK4[nPos,5]+= ((TMPD2b->D2_CUSTO1/TMPD2b->VALVENDA) * 100)
			Endif
			
			//Endif
//		Endif
//	Endif
	
	TMPD2b->( dbSkip() )
Enddo

oMsNewGe4k:aCols := aColsEk4

oMSNewGe4k:Refresh()

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetDolar  บAutor  ณAlexandre Caetano   บ Data ณ  30/Set/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณBusca dolar da ultima importa็ใo                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetDolar()
Local _cSQL := _cTab := "", _nValor := 0

//Exibe o ultimo pre็o de compra do produto, apenas quando for importado.
//Nใo precisa ser feita conversใo de moeda
_cTab := GetNextAlias()
_cSQL := "Select C7.R_E_C_N_O_,C7_PRECO From " + RetSqlName("SC7") + " C7 "
_cSQL += 	"Inner Join " + RetSqlName("SA2") + " A2 On A2_COD = C7_FORNECE And A2_LOJA = C7_LOJA And A2_EST = 'EX' And A2.D_E_L_E_T_ = ' ' "
_cSQL += "Where C7_PRODUTO = '" + SB1->B1_COD + "' And C7.D_E_L_E_T_ = ' ' And RowNum = 1 "
_cSQL += "Order By C7.R_E_C_N_O_ DESC "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,_cSQL ),_cTab,.T.,.F. )

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
	_nValor := (_cTab)->C7_PRECO
EndIf

Return _nValor

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowDet   บAutor  ณAlexandre Caetano   บ Data ณ 02/Out/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra detalhes                                            บฑฑ
ฑฑบ          ณ                A - Ultima Compra                           บฑฑ
ฑฑบ          ณ                B - Custo Comercial                         บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ShowDet(PCol, PLin)

//Filial da linha selecionada
cFilSel := oMSNewGe1:acols[PLin,1]

If PCol	 == 11 //Ultima Entrada
	DetUltCmp(cFilSel)
Elseif PCol == 12 //Custo Comercial
	DetCstCom(cFilSel)
Endif

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetUltCmp บAutor  ณAlexandre Caetano   บ Data ณ  02/Out/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra detalhes das ultimas compras                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DetUltCmp(PFilial)
Local nX
Local aFieldFill 	:= {}
Local aFields 		:= {"D1_DOC"    , "A2_NREDUZ"    , "D1_QUANT"   , "D1_TOTAL" , "D1_VALIPI"  , "D1_IPI"   , "D1_VALICM", ;
"D1_ICMSRET", "D1_VALIMP5" , "D1_VALIMP6" , "D1_SEGURO", "D1_DESPESA" , "D1_VALFRE", "D1__AJIVA"  }
Local aAlterFields 	:= {}
Local cQry
Local oRetorna

Static oMSNewGe1D

aHeaderD1			:= {}

// Define field properties
DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
	If SX3->(DbSeek(aFields[nX]))
		
		If aFields[nX] = "D1_DOC"
			
			cTit	:= "DOC"
			cPic 	:= SX3->X3_PICTURE
			nTam  	:= SX3->X3_TAMANHO
			nDec	:= SX3->X3_DECIMAL
			
		Elseif aFields[nX] = "A2_NREDUZ"
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= SX3->X3_PICTURE
			nTam  	:= 20
			nDec	:= SX3->X3_DECIMAL
			
		Elseif aFields[nX] = "D1_QUANT"
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= Substr(  SX3->X3_PICTURE,1,  (at(".",SX3->X3_PICTURE) - 1 ) )
			nTam  	:= SX3->X3_TAMANHO
			nDec	:= 0
			
		Elseif aFields[nX] = "D1_VALIMP5"
			
			cTit	:= "PIS"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_VALIMP6"
			
			cTit	:= "COFINS"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_SEGURO"
			
			cTit	:= "Seguro"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_DESPESA"
			
			cTit	:= "Despesa"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_VALFRE"
			
			cTit	:= "Frete"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1__AJIVA"
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_ICMSRET"
			
			cTit	:= "ICMS-ST"
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_VALIPI"
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Elseif aFields[nX] = "D1_VALICM"
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= "@E 999,999.99"
			nTam  	:= 10
			nDec	:= 2
			
		Else
			
			cTit	:= AllTrim(X3Titulo())
			cPic 	:= SX3->X3_PICTURE
			nTam  	:= SX3->X3_TAMANHO
			nDec	:= SX3->X3_DECIMAL
			
		Endif
		
		Aadd(aHeaderD1, {cTit,SX3->X3_CAMPO,cPic,nTam,nDec,SX3->X3_VALID,;
		SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
		
	Endif
Next nX

// Define field values
For nX := 1 to Len(aFields)
	If DbSeek(aFields[nX])
		Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	Endif
Next nX
Aadd(aFieldFill, .F.)
Aadd(aColsD1, aFieldFill)

// Preenche dados do aCols

If Select("TMPD1d") > 0
	dbSelectArea("TMPD1d")
	DbCloseArea()
EndIf

cQry := " SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,A2_NREDUZ, D1_QUANT, D1_VUNIT, D1_VALIPI, D1_IPI, D1_VALICM, "
cQry +=		" D1_ICMSRET, D1_VALIMP5, D1_VALIMP6, D1_SEGURO, D1_DESPESA, D1_VALFRE, D1__AJIVA,D1_DTDIGIT, D1_TOTAL "
cQry += " FROM " + RetSQLName("SD1") + " SD1 "
cQry += " INNER JOIN " + RetSQLName("SA2") + " SA2 ON A2_FILIAL = '" +xFilial("SA2")+ "' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2.D_E_L_E_T_ = ' '"
cQry += " Inner Join " + RetSqlName("SF4") + " SF4 On F4_FILIAL = D1_FILIAL And F4_CODIGO = D1_TES And F4_ESTOQUE = 'S' And SF4.D_E_L_E_T_ = ' ' "
cQry += " WHERE D1_COD  = '" + cProd   + "' AND D1_FILIAL = '" + PFilial + "' AND SD1.D_E_L_E_T_ = ' ' And D1_TIPO = 'N' "
//cQry += " GROUP BY D1_DOC,A2_NREDUZ ,D1_QUANT ,D1_VUNIT ,D1_VALIPI,D1_IPI,D1_VALICM,D1_ICMSRET,D1_VALIMP5,D1_VALIMP6,D1_SEGURO,D1_DESPESA,D1_VALFRE,D1__AJIVA, D1_EMISSAO "
cQry += " ORDER BY D1_DTDIGIT DESC "

cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD1d",.T.,.F. )

AColsD1 := {}

DbSelectArea("TMPD1d")
TMPD1d->( dbGoTop() )
For  i := 1 to 3
	If !Eof()
		aAdd( aColsD1, {TMPD1d->D1_DOC, TMPD1d->A2_NREDUZ, TMPD1d->D1_QUANT, TMPD1d->D1_TOTAL, TMPD1d->D1_VALIPI  ,;
		TMPD1d->D1_IPI   , TMPD1d->D1_VALICM, TMPD1d->D1_ICMSRET, TMPD1d->D1_VALIMP5, TMPD1d->D1_VALIMP6,;  //Deleted
		TMPD1d->D1_SEGURO, TMPD1d->D1_DESPESA, TMPD1d->D1_VALFRE, TMPD1d->D1__AJIVA,                         .f. } )
		TMPD1d->( dbSkip() )
	EndIf
Next i

// --------------------------------------------


DEFINE MSDIALOG oDlgDet1 TITLE "Detalhes Ultimas Compras" FROM 000, 000  TO 190, 1290 COLORS 0, 16777215 PIXEL

oMSNewGe1D := MsNewGetDados():New( 003, 003, 060, 644, , "AllwaysTrue", "AllwaysTrue", "+Field1+Field2", aAlterFields,, 999, "AllwaysTrue", "", "AllwaysTrue", oDlgDet1, aHeaderD1, aColsD1)
@ 065, 596 BUTTON oRetorna 		PROMPT "Retornar" Action {|| oDlgDet1:end()}			SIZE 040, 020 OF oDlgDet1 PIXEL

ACTIVATE MSDIALOG oDlgDet1 CENTERED

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณGetCstCom บAutor  ณAlexandre Caetano   บ Data ณ  07/Out/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Encontra o custo comercial                                 บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function GetCstCom(PTipo, PFilial, PProd, _nRecSD1)
Local nRet 		:= 0, _nCstCom := 0
Local cB1Orig	:= ""
Local cQry		:= ""
Local nVlUltCmp := 0

Default PTipo := "PRD"

//o custo comercial e custo da ultima entrada podem ser resultado de transferencia
If Select("TMPD1x") > 0
	dbSelectArea("TMPD1x")
	DbCloseArea()
EndIf

cQry := " SELECT MAX(D1_DTDIGIT), D1.R_E_C_N_O_ D1RECNO FROM " + RetSQLName("SD1") + " D1 "
cQry += " INNER JOIN " + RetSQLName("SF4") + " F4 ON D1_FILIAL = F4_FILIAL AND D1_TES = F4_CODIGO AND F4_ESTOQUE = 'S' And F4.D_E_L_E_T_ = ' ' "
cQry += " INNER JOIN " + RetSQLName("SA2") + " A2 ON D1_FORNECE = A2_COD AND D1_LOJA = A2_LOJA AND A2.D_E_L_E_T_ = ' '"
cQry += " WHERE D1_FILIAL = '" + PFilial + "' And D1_COD = '" + cProd  + "'And D1.D1_DTDIGIT >=  '20150501'  And D1_TIPO = 'N' And "
If !Empty(_cArmAte)
	cQry += " D1_LOCAL Between '" + _cArmDe + "' And '" + _cArmAte + "' And "
Else
	cQry += " D1_LOCAL Between '" + _cArmPad1 + "' And '" + _cArmPad2 + "' And "
EndIf
cQry += " D1.D_E_L_E_T_ = ' ' "
cQry += "Group by D1.R_E_C_N_O_ "
cQry += "Order By D1.R_E_C_N_O_ DESC "
cQry := ChangeQuery(cQry)
DbUseArea( .T.,"TOPCONN", TCGENQRY( ,,cQry ),"TMPD1x",.T.,.F. )

TMPD1x->( dbGoTop() )

_nRecSD1 := TMPD1x->D1RECNO	

If _nRecSD1 > 0
	DbSelectArea("SD1")
	DbGoTo(_nRecSD1)
Else
	Return {0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0}
EndIf

nVlUltCmp := (SD1->D1_CUSTO + SD1->D1__AJIVA)/SD1->D1_QUANT
nD1Quant  := SD1->D1_QUANT

if PTipo == "PRD"
	
	nPIS		:= 0
	nPPIS		:= 0
	nCOFINS		:= 0
	nPCOFINS	:= 0
	nICMS		:= 0
	nPICMS		:= 0
	nIPI		:= 0
	nPIPI		:= 0
	nICMSST		:= 0
	
	Posicione("SB1",1, xFilial("SB1") + cProd, "B1_ORIGEM")
	cB1Orig	:= 	SubStr(SD1->D1_CLASFIS,1,1) 
	if cB1Orig != "1"
		if PFilial == "03"
			
			if SD1->D1_VALIMP6 > 0
				nPIS	:= nVlUltCmp /((100 - SD1->D1_ALQIMP6) / 100)
				nPPIS   := SD1->D1_ALQIMP6
			Endif
			
			If SD1->D1_VALIMP5 > 0
				nCOFINS		:= nVlUltCmp /((100 - SD1->D1_ALQIMP5) / 100)
				nPCOFINS    := SD1->D1_ALQIMP5
			Endif
			
			If SD1->D1_VALICM > 0
				nICMS	:= nVlUltCmp /((100 - SD1->D1_PICM) / 100)
				nPICMS  := SD1->D1_PICM
			Endif
			
		Else
			
			if SD1->D1_VALIMP6 > 0
				nPIS	:= nVlUltCmp /((100 - SD1->D1_ALQIMP6) / 100)
				nPPIS   := SD1->D1_ALQIMP6
			Endif
			
			If SD1->D1_VALIMP5 > 0
				nCOFINS		:= nVlUltCmp /((100 - SD1->D1_ALQIMP5) / 100)
				nPCOFINS    := SD1->D1_ALQIMP5
			Endif
			
		Endif
	Elseif cB1Orig == "1"		
		
		if PFilial == "03" .or. PFilial == "05"

			if SD1->D1_VALIMP6 > 0
				nPIS	:= nVlUltCmp /((100 - SD1->D1_ALQIMP6) / 100)
				nPPIS   := SD1->D1_ALQIMP6
			Endif
			
			If SD1->D1_VALIMP5 > 0
				nCOFINS		:= nVlUltCmp /((100 - SD1->D1_ALQIMP5) / 100)
				nPCOFINS    := SD1->D1_ALQIMP5
			Endif			
			
			if SB1->B1_IPI > 0
				nIPI	:= nVlUltCmp /((100 - SB1->B1_IPI) / 100)
				nPIPI   := SB1->B1_IPI
			Endif
			
			If SD1->D1_EMISSAO <= CTOD("01/01/2013")
				nICMS	:= nVlUltCmp /((100 - 12) / 100)
				nPICMS  := 12
			Else
				nICMS	:= nVlUltCmp /((100 - 4) / 100)
				nPICMS  := 4
			Endif			
			
		Else
			if SD1->D1_VALIMP6 > 0
				nPIS	:= nVlUltCmp /((100 - SD1->D1_ALQIMP6) / 100)
				nPPIS   := SD1->D1_ALQIMP6
			Endif
			
			If SD1->D1_VALIMP5 > 0
				nCOFINS		:= nVlUltCmp /((100 - SD1->D1_ALQIMP5) / 100)
				nPCOFINS    := SD1->D1_ALQIMP5
			Endif			
			
			if SB1->B1_IPI > 0
				nIPI	:= nVlUltCmp /((100 - SB1->B1_IPI) / 100)
				nPIPI   := SB1->B1_IPI
			Endif
			
			If PFilial == "04"
				If SD1->D1_VALICM > 0
					nICMS	:= nVlUltCmp /((100 - SD1->D1_PICM) / 100)
					nPICMS  := SD1->D1_PICM
				Endif
			EndIf
						
		Endif		
	EndIf
	
	nCst := (nPIS + nCOFINS + nICMS + nIPI ) //(nVlUltCmp + nPIS + nCOFINS + nICMS + nIPI )
	nCst := IIF(nCst == 0,nVlUltCmp,nCst)
	nRet := {nCst, nPIS, nPPIS, nCOFINS, nPCOFINS, nICMS, nPICMS, nIPI, nPIPI, nICMSST,nVlUltCmp}
	
Elseif PTipo == "KIT"
	
	//	nVlUltCmp := nVlUltCmp	+ MV__MRGCST necessแrio criar no SX6
	
	//----------------
	// Valor do ICMS
	nPICMS	:= Posicione("SB1",1,xFilial("SB1")+PProd,"B1_PICM")
	nICMS	:= ( nVlUltCmp * (nPICMS/100) )
	//----------------
	// Valor ST
	nICMRET	:= Posicione("SB1",1,xFilial("SB1")+PProd,"B1_PICMRET")
	nICMSST	:= ( nVlUltCmp * (nICMRET/100) )
	//----------------
	// Valor IPI
	nPIPI	:= Posicione("SB1",1,xFilial("SB1")+PProd,"B1_IPI")
	nIPI	:= ( nVlUltCmp * (nPIPI/100) )
	//----------------
	// Valor do PIS
	nPPIS	:= Posicione("SB1",1,xFilial("SB1")+PProd,"B1_PPIS")
	nPIS	:= ( nVlUltCmp * (nPPIS/100) )
	//----------------
	// Valor do COFINS
	nPCOFINS:= Posicione("SB1",1,xFilial("SB1")+PProd,"B1_PCOFINS")
	nCOFINS	:= ( nVlUltCmp * (nPCOFINS/100) )
	//----------------
	
	nCst	:= ( (nVlUltCmp + nICMS  + nICMSST  + nIPI  + nPIS  + nCOFINS) * SU1->U1_QTD )
	nRet 	:= {nCst, nPIS, nPPIS, nCOFINS, nPCOFINS, nICMS, nPICMS, nIPI, nPIPI, nICMSST,nVlUltCmp}
	
Endif

Return(nRet)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetCstCom บAutor  ณAlexandre Caetano   บ Data ณ 10/Out/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDetalhe do Custo Comercial                                  บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DetCstCom(PFilial,PTipo)
Local aDados := {}

Local oSayD1
Local oCstUlt
Local cCstUlt
Local oSayD2
Local oICMSST
Local cICMSST
Local oSayD3
Local oPICMS
Local cPICMS
Local oSayD4
Local oICMS
Local cICMS
Local oSayD5
Local oPIPI
Local cPIPI
Local oSayD6
Local oIPI
Local cIPI
Local oSayD7
Local oPPIS
Local cPPIS
Local oSayD8
Local oPIS
Local cPIS
Local SayD9
Local oPCOFINS
Local cPCOFINS
Local oSayD10
Local oCOFINS
Local cCOFINS
Local oSayD11
Local oCstCom
Local cCstCom
Local oRetorna

Default PTipo := "PRD"

aDados := GetCstCom("PRD",PFILIAL, cProd)

//  1      2      3      4       5         6      7      8     9       10      11
//nCst, nPIS, nPPIS, nCOFINS, nPCOFINS, nICMS, nPICMS, nIPI, nPIPI, cICMSST,nVlUltCmp}

cCstUlt 	:= aDados[11]
cICMSST 	:= aDados[10]
cPICMS		:= aDados[07]
cICMS  		:= IIF(aDados[06] > 0, aDados[06] - aDados[11],0)
cPIPI       := aDados[09]
cIPI        := IIF(aDados[08] > 0, aDados[08] - aDados[11],0)
cPPIS		:= aDados[03]
cPIS		:= IIF(aDados[02] > 0, aDados[02] - aDados[11],0)
cPCOFINS	:= aDados[05]
cCOFINS		:= IIF(aDados[04] > 0, aDados[04] - aDados[11],0)
cCstCom		:= aDados[01]

DEFINE MSDIALOG oDlgDet2 TITLE "Detalhes Custo Comercial" FROM 000, 000  TO 140, 950 COLORS 0, 16777215 PIXEL

@ 012, 008 SAY 		oSayD1 		PROMPT "Custo ฺlt. Entrada"								SIZE 040, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 008 MSGET 	oCstUlt 	VAR cCstUlt 	When .f.	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 058 SAY 		oSayD2 		PROMPT "ICMS ST" 										SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 058 MSGET 	oICMSST 	VAR cICMSST		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 108 SAY 		oSayD3 		PROMPT "%ICMS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 108 MSGET 	oPICMS 		VAR cPICMS 		When .f. 	Picture	"@E 99,99"			SIZE 020, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 138 SAY 		oSayD4 		PROMPT "ICMS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 138 MSGET 	oICMS 		VAR cICMS 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 188 SAY 		oSayD5 		PROMPT "%IPI" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 188 MSGET 	oPIPI 		VAR cPIPI 		When .f. 	Picture	"@E 99,99"			SIZE 020, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 218 SAY 		oSayD6		PROMPT "IPI" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 218 MSGET 	oIPI 		VAR cIPI 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 268 SAY 		oSayD7 		PROMPT "%PIS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 268 MSGET 	oPPIS		VAR cPPIS 		When .f. 	Picture	"@E 99,99"			SIZE 020, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 298 SAY 		oSayD8  	PROMPT "PIS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 298 MSGET 	oPIS 		VAR cPIS 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 348 SAY 		oSayD9 		PROMPT "%COFINS" 										SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 348 MSGET 	oPCOFINS 	VAR cPCOFINS 	When .f. 	Picture	"@E 99,99"			SIZE 020, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 378 SAY 		oSayD10 	PROMPT "COFINS" 										SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 378 MSGET 	oCOFINS 	VAR cCOFINS		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 012, 428 SAY 		oSayD11		PROMPT "Custo Comercial" 								SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
@ 019, 428 MSGET 	oCstCom		VAR cCstCom		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL

@ 036, 428 BUTTON oRetorna 		PROMPT "Retornar" Action {|| oDlgDet2:end()}			SIZE 040, 020 OF oDlgDet2 PIXEL

ACTIVATE MSDIALOG oDlgDet2 CENTERED

Return(.t.)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowDetK บAutor  ณAlexandre Caetano    บ Data ณ  13/Out/14  บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Exibe detalhes do Kit                                      บฑฑ
ฑฑบ          ณ                       1 - Ultimas compras                  บฑฑ
ฑฑบ          ณ                       2 - Custo comercial                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ShowDetK(PCol, PLin)

//Filial da linha selecionada
cFilSel := oMSNewGe2K:acols[PLin,1]

cCodAce := Posicione("SUG",2, xFilial("SUG") + cKit,"UG_CODACE")
Posicione("SU1",1, xFilial("SU1") + cCodAce,"U1_CODACE")

If PCol	 == 12 //Ultima Entrada
	DetUltCmp(cFilSel,SU1->U1_ACESSOR) // OS ITENS DOS KITดS SEMPRE ESTรO NA MESMA NOTA FISCAL DE ENTRADA.
Elseif PCol == 13 //Custo Comercial
	DetCstComk(cFilSel,.t.)
Endif

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณDetCstComKบAutor  ณAlexandre Caetano   บ Data ณ  13/Out/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Detalhes custo comercial kit                               บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑบUso       ณ Exclusivo ISAPA                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function DetCstComK(PFilial,PTela)

// Encontra custo comercial
cCodAce := Posicione("SUG",2, xFilial("SUG") + cKit,"UG_CODACE")
Posicione("SU1",1, xFilial("SU1") + cCodAce,"U1_CODACE")

nCstTot    	:= 0
nUltEnt	    := 0
nCstComKit 	:= 0
nCstComPIS 	:= 0
nCstComCOF 	:= 0
nCstComICM 	:= 0
nCstComIPI 	:= 0
nCstComST  	:= 0
nCstComVlU 	:= 0
nQtdite		:= 0

Do While SU1->( !EoF() ) .and.;
	SU1->U1_CODACE = cCodAce
	
	aRetorno := GetCstCom("PRD",PFilial,SU1->U1_ACESSOR)
	nCstTot  += aRetorno[11]
	nUltEnt  += aRetorno[01]
	
	//  1      2      3      4       5         6      7      8     9       10      11
	//nCst, nPIS, nPPIS, nCOFINS, nPCOFINS, nICMS, nPICMS, nIPI, nPIPI, cICMSST,nVlUl
	nCstComKit += aRetorno[01]
	nCstComPIS += aRetorno[02]
	nCstComCOF += aRetorno[04]
	nCstComICM += aRetorno[06]
	nCstComIPI += aRetorno[08]
	nCstComST  += aRetorno[10]
	
	nQtdite++
	
	SU1->( dbSkip() )
Enddo

cCstUlt 	:= (nUltEnt    / nQtdite)
cICMSST 	:= (nCstComST  / nQtdite)
cICMS  		:= (nCstComICM / nQtdite)
cIPI        := (nCstComIPI / nQtdite)
cPIS		:= (nCstComPIS / nQtdite)
cCOFINS		:= (nCstComCOF / nQtdite)
cCstCom		:= (nCstTot    / nQtdite)

if PTela
	DEFINE MSDIALOG oDlgDet2 TITLE "Detalhes Custo Comercial" FROM 000, 000  TO 140, 800 COLORS 0, 16777215 PIXEL
	
	@ 012, 008 SAY 		oSayD1 		PROMPT "Custo ฺlt. Entrada"								SIZE 040, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 008 MSGET 	oCstCom 	VAR cCstCom 	When .f.	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 058 SAY 		oSayD2 		PROMPT "ICMS ST" 										SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 058 MSGET 	oICMSST 	VAR cICMSST		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 138 SAY 		oSayD4 		PROMPT "ICMS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 138 MSGET 	oICMS 		VAR cICMS 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 188 SAY 		oSayD6		PROMPT "IPI" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 188 MSGET 	oIPI 		VAR cIPI 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 238 SAY 		oSayD8  	PROMPT "PIS" 											SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 238 MSGET 	oPIS 		VAR cPIS 		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 288 SAY 		oSayD10 	PROMPT "COFINS" 										SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 288 MSGET 	oCOFINS 	VAR cCOFINS		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 012, 338 SAY 		oSayD11		PROMPT "Custo Comercial" 								SIZE 020, 007 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	@ 019, 338 MSGET 	oCstUlt		VAR cCstUlt		When .f. 	Picture	"@E 999,999.9999"	SIZE 040, 008 	OF oDlgDet2 COLORS 0, 16777215 PIXEL
	
	@ 036, 338 BUTTON oRetorna 		PROMPT "Retornar" Action {|| oDlgDet2:end()}			SIZE 040, 020 OF oDlgDet2 PIXEL
	
	ACTIVATE MSDIALOG oDlgDet2 CENTERED
	
Endif

//    1      2      3      4       5         6      7      8     9       10       11
//   nCst, nPIS, nPPIS, nCOFINS, nPCOFINS, nICMS, nPICMS, nIPI, nPIPI, cICMSST, nVlUl
aRet := {cCstCom,cPIS,    0 , cCOFINS,    0    , cICMS,    0  , cIPI,  0   , cICMSST, cCstUlt}

cICMSST 	:= (nCstComST  / nQtdite)
cICMS  		:= (nCstComICM / nQtdite)
cIPI        := (nCstComIPI / nQtdite)
cPIS		:= (nCstComPIS / nQtdite)
cCOFINS		:= (nCstComCOF / nQtdite)
cCstCom		:= (nCstTot    / nQtdite)

Return(aRet)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณShowDetPrdบAutor  ณAlexandre Caetano   บ Data ณ  29/Out/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Mostra dados do produto - Selecionado na Aba Kit           บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

User Function ShowDetPrd(PProd)

cProd		:= PProd

dDtPer1ini 	:= dDtPrk1ini
dDtPer1Fin	:= dDtPrk1Fin
dDtPer2ini 	:= dDtPrk2ini
dDtPer2Fin 	:= dDtPrk2Fin

U_ShowProd()
U_ConsProd()

lLimpaIt := .T.

oFolder1:nOption := 1
oDlg:Refresh()

Return(.t.)     

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณITMKC02B บAutor  ณJose Augusto        บ Data ณ  27/Jan/2015บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Limpa Aba Item quando se detalha um produto pela Aba Kit   บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function ITMKC02B()

If oFolder1:nOption == 2
	If lLimpaIt
		cProd 		:= Space( TamSX3("B1_COD")[1] )
		cProdDesc 	:= ""
		cGrupo		:= ""
		cDescGrp	:= ""
		cSubGrupo   := ""
		cDescSGrp   := ""
		cMarca		:= ""
		cDescMarca	:= ""
		cMBaseCons	:= ""
		cProced		:= "" 
		
		nTotEstRea	:= 0		
		nTotValEst	:= 0
		nTotReserv	:= 0
		nTotEntPro	:= 0
		nTotSaiPro	:= 0
		nTotDisp	:= 0
		
		cPrecoVist	:= ""
		cArmGer		:= ""
		cEntTransf	:= ""
		cPrevEntr	:= ""
		cQtdPreVnd	:= ""
		cSldPreVnd	:= ""
		cPrecVSP	:= ""
		cCrossDock	:= ""
		cDolar 		:= ""    
		
		aColsEx1 	:= {}                            
		aAdd( aColsEx1,{ "", 0, 0,0, 0, 0, 0, 0, CtoD(Space(8)), 0, 0, 0,     .f.})
		oMsNewGe1:aCols := aColsEx1
		oMSNewGe1:Refresh()
		 
		aColsEx3 	:= {}
		aAdd( aColsEx3,{ "", 0, 0,0, 0, .f.})  
		oMsNewGe3:aCols := aColsEx3
		oMSNewGe3:Refresh()  
		
		aColsEx2 	:= {}
		aAdd( aColsEx2,{ "", 0, 0,0, 0, .f.})
		oMsNewGe2:aCols := aColsEx2
		oMSNewGe2:Refresh()
		
		U_ShowProd() 
		
		oDlg:Refresh()
	EndIf

lLimpaIt := .F.

EndIf  

Return                                           
