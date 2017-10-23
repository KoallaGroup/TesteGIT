#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+----------------+
| Programa:  | ITMKR12 | Autor: | Rogério Alves      | Data: | Fevereiro/2015 |
+------------+---------+--------+--------------------+-------+----------------+
| Descrição: | Relação de vendas por Representante                            |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/


User Function ITMKR12()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay12, oSay14
Local aPergs	:= {}

Private oGroup1
Private nSubTr 	:= 1
Private nIdSg	:= 1
Private lQuebra := .f.
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}
Private cEmprIni	:= Space( avSx3("ZE_CODFIL" 	,3) )
Private cEmprDesc 	:= Space( avSx3("ZE_NOMECOM"	,3) )
Private cEmprFim	:= Space( avSx3("ZE_CODFIL" 	,3) )
Private cEmprDesc1 	:= Space( avSx3("ZE_NOMECOM"	,3) )
Private cReprIni	:= Space( avSx3("UA_VEND" 		,3) )
Private cReprFim 	:= Space( avSx3("UA_VEND" 		,3) )
Private dDtIni		:= Space(8)
Private dDtFim	 	:= Space(8)
Private cImpSt		:= Space(1)
Private cSegmento	:= Space( avSx3("B1__SEGISP",3) )
Private cSegDesc	:= Space( avSx3("Z7_DESCRIC",3) )
Private oEmprIni, oEmprDesc, oEmprFim, oEmprDesc1, oReprIni, oReprFim, oDtIni, oDtFim
Private oSegmento, oSegDesc, oRadSub2, oButProc
Private cPerg		:= PADR("ITMKR12",Len(SX1->X1_GRUPO))
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

Aadd(aPergs,{"A Partir do Local"		,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Até o Local"				,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Segmento"					,"","","mv_ch3","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR03",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"A Partir Data"			,"","","mv_ch4","D",08						,0,0,"G","","MV_PAR04",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até Data"					,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"A Partir do Representante","","","mv_ch6","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR06",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Até o Representante"		,"","","mv_ch7","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR07",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Impressão ST"				,"","","mv_ch8","C",01	                    ,0,1,"C","","MV_PAR08","Sim","","","","","Não"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)

cEmprIni	:= MV_PAR01
cEmprFim	:= MV_PAR02
cSegmento	:= MV_PAR03
dDtIni		:= MV_PAR04
dDtFim	 	:= MV_PAR05
cReprIni	:= MV_PAR06
cReprFim 	:= MV_PAR07
nSubTr		:= MV_PAR08

AtuFil(cEmprIni,.f.,1)
AtuFil(cEmprFim,.f.,2)
AtuSeg(cSegmento,.f.)

DEFINE MSDIALOG oDlg TITLE "Relatório de Vendas por Representante" FROM 000, 000  TO 340, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+115,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+150,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel
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
@ nLinSay, aPosGet[1,01] 	SAY      oSay12     PROMPT "Segmento"             						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET    oSegmento   VAR cSegmento	Picture PesqPict("SB1","B1__SEGISP")SIZE 010, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 	"SZ72" 		Valid AtuSeg(cSegmento)
@ nLinGet, aPosGet[1,02]+80 MSGET    oSegDesc    VAR cSegDesc				When .f.  		 		SIZE 150, 008   OF oDlg COLORS 0, 16777215 PIXEL
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
@ nLinSay, aPosGet[1,01] SAY      	oSay3       PROMPT "A Partir do Representante"	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oReprIni    VAR cReprIni	Picture PesqPict("SUA","UA_VEND")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA3" 		Valid ValRepr(cReprIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay4       PROMPT "Até o Representante"         				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oReprFim    VAR cReprFim	Picture PesqPict("SUA","UA_VEND")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "SA3" 		Valid ValRepr(cReprFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY      oSay14     PROMPT "Imprime Subst. Trib. ?"              			SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinSay, aPosGet[1,02]+30 RADIO	oRadSub2 	VAR nSubTr Prompt OemToAnsi("Sim"),OemToAnsi("Não") SIZE 200, 025 OF oDlg Pixel

oRadSub2:lHoriz := .F.
	
nLinSay += 32
nLinGet += 32
@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action (GeraRel(),oDlg:end())	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+73  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

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

Local _cRelato	:= "ITMKCR12"
Local _cParams	:= ""
Local _cOptions := "1;0;1;Relatório de Vendas por Representante"

GravaSx1()

If nSubTr == 1
	cImpSt := "B"
ElseIf nSubTr == 2	
	cImpSt := "A"       
EndIf
	
_cParams := cEmprIni 		+ ";"
_cParams += cEmprFim 		+ ";"
_cParams += trim(cSegmento) + ";"
_cParams += DTOS(dDtIni) 	+ ";"
_cParams += DTOS(dDtFim) 	+ ";"
_cParams += cReprIni 		+ ";"
_cParams += cReprFim 		+ ";"
_cParams += cImpSt

CallCrys(_cRelato,_cParams,_cOptions)

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

aAdd( aSx1, {cEmprIni, cEmprFim, cSegmento, DTOS(dDtIni), DTOS(dDtFim), cReprIni, cReprFim,  Alltrim(cImpSt) } )

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

If "Z" $ Upper(_cRepr) .and. _nSt == 2
	
	cReprFim := "ZZZZZZ"
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
	If !(Empty(PFilial)) .and. !("Z" $ Upper(PFilial))
		MsgAlert("Filial inválida","PARAMETROS INVALIDOS")
		lRet	:= .F.
	Else
		If _cSt == 1
			cEmprDesc := Space( avSx3("ZE_NOMECOM",3) )
		Else		
			If "Z" $ Upper(PFilial)	
				cEmprFim := "ZZ"
				//oEmprFim:Refresh()		
		    EndIf		
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

IF SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) ) .and. Alltrim(PSeg) != "0"
	If !(Empty(PSeg))
		cSegDesc := SZ7->Z7_DESCRIC
	Else
		cSegDesc := Space( avSx3("B1__SEGISP",3) )
	EndIf
Else
	MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
	lRet	:= .F.
EndIf

if PlAtuTela
	oSegDesc:cCaption := cSegDesc
	oSegDesc:Refresh()
Endif

Return(lRet)
