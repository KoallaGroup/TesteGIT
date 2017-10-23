#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+----------------+
| Programa:  | ITMKR15 | Autor: | Rog�rio Alves      | Data: |   Mar�o/2015   |
+------------+---------+--------+--------------------+-------+----------------+
| Descri��o: | Relat�rio de clientes por zona                                 |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/

User Function ITMKR15()

Local _aArea 	:= GetArea()
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oSay7, oSay8, oSay9
Local aPergs	:= {}

Private oGroup1, oGroup2, oGroup3
Private aSize := {}, aPosObj := {}, aInfo := {}, aObjects := {}

Private dDtRef	 	:= dDataBase
Private cZonaIni	:= Space( avSx3("A1__REGVEN",3) )
Private cZonaFim 	:= Space( avSx3("A1__REGVEN",3) )
Private cSegisp		:= Space( avSx3("A1__SEGISP",3) )
Private cDescSeg	:= Space( avSx3("Z7_DESCRIC",3) )
Private cUF			:= Space( avSx3("A1_EST"	,3) )
Private nAtivo		:= 1
Private nSelMan		:= 1
Private nModelo		:= 1
Private nTipo		:= 1
Private lCheckBo1 	:= .F.
Private _cCNPJ		:= ""

Private oSegisp, oZonaIni, oZonaFim, oDtRef, oAtivo, oSelMan, oModelo, oTipo, oUF
Private oRadSub1, oRadSub2, oRadSub3, oButProc, oButProc1, oCheckBo1, oDescSeg

Private cPerg		:= PADR("ITMKR15",Len(SX1->X1_GRUPO))
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

Aadd(aPergs,{"Data de Refer�ncia       ","","","mv_ch1","D",08						,0,0,"G","","MV_PAR01",""	,"","","","dDtRef",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"A Partir da Zona         ","","","mv_ch2","C",TamSx3("A1__REGVEN")[1]	,0,0,"G","","MV_PAR02",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","ZX5REG"	,"","","",""})
Aadd(aPergs,{"At� a Zona               ","","","mv_ch3","C",TamSx3("A1__REGVEN")[1]	,0,0,"G","","MV_PAR03",""	,"","","","ZZZZ",""		,"","","","","","","","","","","","","","","","","","","ZX5REG"	,"","","",""})
Aadd(aPergs,{"Segmento                 ","","","mv_ch4","C",TamSx3("A1__SEGISP")[1]	,0,0,"G","","MV_PAR04",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"Clientes ?               ","","","mv_ch5","C",01	                    ,0,1,"C","","MV_PAR05","Ativo","","","","","Inativo"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Sele��o Manual ?         ","","","mv_ch6","C",01	                    ,0,1,"C","","MV_PAR06","Sim","","","","","N�o"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Modelo ?                 ","","","mv_ch7","C",01	                    ,0,1,"C","","MV_PAR07","Queb/Sim","","","","","Queb/UF"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo ?                   ","","","mv_ch8","C",01	                    ,0,1,"C","","MV_PAR08","Cli/Rep","","","","","Sup"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.F.)


dDtRef	 	:= dDataBase //MV_PAR01
cZonaIni	:= MV_PAR02
cZonaFim 	:= MV_PAR03
cSegisp		:= MV_PAR04
nAtivo		:= MV_PAR05
nSelMan		:= MV_PAR06
nModelo		:= MV_PAR07
nTipo		:= MV_PAR08

SegUser()
AtuSeg(cSegisp)
//U_AtuMod(1)

DEFINE MSDIALOG oDlg TITLE "Rela��o de Clientes por Zona" FROM 000, 000  TO 400, 640 COLORS 0, 16777215 PIXEL
oDlg:lMaximized := .f.

@ nLinSay-8, aPosGet[1,01]-9 GROUP   oGroup1 TO nLinSay+160,aPosGet[1,04]+135 PROMPT ""   							OF oDlg COLOR  0, 16777215 Pixel

@ nLinSay, aPosGet[1,01] 	SAY     oSay1     	PROMPT "Data de Refer�ncia"    						SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30	MSGET   oDtRef   	VAR dDtRef	Picture "@D"							SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay2       PROMPT "A Partir da Zona"	                SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oZonaIni    VAR cZonaIni	Picture PesqPict("SA1","A1__REGVEN")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "ZX5REG" 		Valid ValZona(cZonaIni,1)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] SAY      	oSay3       PROMPT "At� a Zona"         				SIZE 070, 008	OF oDlg COLORS 0, 16777215 PIXEL
@ nLinGet, aPosGet[1,02]+30 MSGET   oZonaFim    VAR cZonaFim	Picture PesqPict("SA1","A1__REGVEN")	SIZE 040, 008	OF oDlg COLORS 0, 16777215 PIXEL   	F3 "ZX5REG" 		Valid ValZona(cZonaFim,2)
nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,01] 	SAY     oSay4       PROMPT "Segmento"     					SIZE 070, 008   OF oDlg COLORS 0, 16777215 PIXEL
If SegUser()
	@ nLinGet, aPosGet[1,02]+30	MSGET   oSegisp    VAR cSegisp       		  	When .T.				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SZ72"		Valid AtuSeg(cSegisp)
Else
	@ nLinGet, aPosGet[1,02]+30	MSGET   oSegisp    VAR cSegisp       		  	When .F.				SIZE 010, 008   OF oDlg COLORS 0, 16777215 PIXEL 	F3	"SZ72"		Valid AtuSeg(cSegisp)
EndIf
@ nLinGet, aPosGet[1,02]+60 MSGET   oDescSeg    VAR cDescSeg	When .F.  Picture PesqPict("SZ7","Z7_DESCRIC")	SIZE 050, 008	OF oDlg COLORS 0, 16777215 PIXEL

nLinSay += 13
nLinGet += 13

@ nLinSay,aPosGet[1,01]    GROUP   	oGroup2 TO nLinSay+45,aPosGet[1,01]+195 PROMPT "Clientes"   					OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,01]+20 RADIO oRadSub1 	VAR nAtivo Prompt OemToAnsi("Ativos  ?"),OemToAnsi("Inativos ?"),OemToAnsi("Ambos  ?") SIZE 50, 025 OF oDlg Pixel
@ nLinSay+22, aPosGet[1,01]+75 	SAY     oSay5       PROMPT "ou"     					SIZE 020, 008   OF oDlg COLORS 255, 16777215 PIXEL

nLinSay += 13
nLinGet += 13
@ nLinSay, aPosGet[1,02]+60  CHECKBOX oCheckBo1 VAR lCheckBo1 PROMPT "Selecionar" 	SIZE 040, 013 OF oDlg COLORS 0, 16777215 PIXEL

oCheckBo1:bChange := {|| U_BotSel(lCheckBo1)}

nLinSay += 13
nLinGet += 13

@ nLinSay, aPosGet[1,02]+60  BUTTON   oButProc1   PROMPT "Sele��o Manual" Action (RelCli()/*,oDlg:end()*/)	SIZE 050, 010 	OF oDlg Pixel

nLinSay += 23
nLinGet += 23

@ nLinSay,aPosGet[1,01]    GROUP   	oGroup3 TO nLinSay+50,aPosGet[1,01]+195 PROMPT "Modelo"   				OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,01]+20 RADIO oRadSub2 	VAR nModelo Prompt OemToAnsi("Quebra Simples"),OemToAnsi("Quebra por Uf") SIZE 50, 025 OF oDlg Pixel

@ nLinGet+35, aPosGet[1,01]+20 MSGET   oUf    VAR cUf Picture PesqPict("SA1","A1_EST")	SIZE 015, 006	OF oDlg COLORS 0, 16777215 PIXEL    Valid ValUf(cUF)

oRadSub2:bChange := {|| U_AtuMod(nModelo)}

nLinSay += 6
nLinGet += 6


@ nLinSay,aPosGet[1,02]+60    GROUP   	oGroup3 TO nLinSay+38,aPosGet[1,01]+190 PROMPT "Tipo"   				OF oDlg COLOR 255, 16777215 Pixel
@ nLinSay+12, aPosGet[1,02]+70 RADIO oRadSub3 	VAR nTipo Prompt OemToAnsi("Cliente por Representante"),OemToAnsi("Supervisor") SIZE 75, 025 OF oDlg Pixel

oRadSub1:lHoriz := .F.
oRadSub2:lHoriz := .F.
oRadSub3:lHoriz := .F.

nLinSay += 60
nLinGet += 60
@ nLinSay, aPosGet[1,04]+31  BUTTON   oButProc     PROMPT "Processar"	Action (GeraRel())	SIZE 040, 016 	OF oDlg Pixel
@ nLinSay, aPosGet[1,04]+73  BUTTON   oButProc     PROMPT "Cancelar "	Action oDlg:end()  				SIZE 040, 016 	OF oDlg Pixel

U_AtuMod(nModelo)
U_BotSel(lCheckBo1)

ACTIVATE MSDIALOG oDlg CENTERED

RestArea (_aArea)

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraRel			 	| 	Janeiro de 2015                                         |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Rotina para verifica��o dos filtros de tela e gera��o do relat�rio em crystal   |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GeraRel()

Local _cRelato	:= ""
Local _cParams	:= ""
Local _cOptions := "1;0;1;Rela��o de Clientes por Zona"
Local _nAti1	:= ""
Local _nAti2	:= ""
Local _nAti3	:= ""
Local _cUfDe	:= ""
Local _cUfAte	:= ""
Local _cSelMan	:= ""

GravaSx1()

If nTipo == 1
	_cRelato	:= "ITMKCR15A"
ElseIf nTipo == 2
	_cRelato	:= "ITMKCR15B"
EndIf

If nAtivo == 1
	_nAti1 := "1"
	_nAti2 := " "
	_nAti3 := " "
ElseIf nAtivo = 2
	_nAti1 := "2"
	_nAti2 := " "
	_nAti3 := " "
ElseIf nAtivo = 3
	_nAti1 := "1"
	_nAti2 := "2"
	_nAti3 := " "
EndIf

If nModelo == 1
	_cUfDe 	:= "  "
	_cUfAte := "ZZ"
ElseIf nModelo == 2
	_cUfDe 	:= cUf
	_cUfAte := cUf
EndIf

If !lCheckBo1
	_cCNPJ := "1"
	_cSelMan	:= "A"
Else
	_cSelMan	:= "B"
EndIf


_cParams := cSegisp 				+ ";"
_cParams += cSegisp 				+ ";"
_cParams += cZonaIni				+ ";"
_cParams += cZonaFim	 			+ ";"
_cParams += _cUfDe			   		+ ";"
_cParams += _cUfAte					+ ";"
_cParams += _nAti1   				+ ";"
_cParams += _nAti2	 				+ ";"
_cParams += _nAti3	 				+ ";"
_cParams += _cSelMan 				+ ";"
_cParams += _cCNPJ	 				+ ";"
_cParams += Alltrim(DTOS(dDtRef))

CallCrys(_cRelato,_cParams,_cOptions)

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GravaSX1			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Grava valores na SX1                                                            |
|-----------------------------------------------------------------------------------------------|
*/


Static Function GravaSx1()

Local nX := 1

aAdd( aSx1, {DTOS(dDtRef), cZonaIni, cZonaFim, cSegisp, alltrim(str(nAtivo)), alltrim(str(nSelMan)), alltrim(str(nModelo)), alltrim(str(nTipo)) } )

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
|	Programa : ValZona			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Valida exist�ncia da Zona(Regi�o) do Representante                              |
|-----------------------------------------------------------------------------------------------|
*/


static function ValZona(_cZona,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cZona) .and. _nSt == 2
	
	cZonaFim := "ZZZZZZ"
	oZonaFim:Refresh()
	
Else
	
	dbSelectArea("ZX5")
	dbSetOrder(1)
	if !dbSeek(xFilial("ZX5")+ "  " + "000006" + _cZona) .and. !empty(_cZona)
		msgAlert ("Zona n�o cadastrada !!","PAR�METROS INV�LIDOS")
		lRet := .F.
	endif
	
EndIf

return lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Valida Segmento                                                                 |
|-----------------------------------------------------------------------------------------------|
*/

Static Function AtuSeg(PSeg)

Local _aArea 	:= GetArea()
Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF !(SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) ) .and. Alltrim(PSeg) != "0")
	MsgAlert("Favor utilizar Segmento contido no help de campo","PAR�METROS INV�LIDOS")
	lRet	:= .F.
Else
	cDescSeg := SZ7->Z7_DESCRIC
EndIf

RestArea (_aArea)

Return(lRet)



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Fun��o para verificar o segmento do usu�rio									  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function SegUser()

Local _aArea 	:= getArea()
Local _lRet		:= .F.

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	If Alltrim(SZ1->Z1_SEGISP) == "0"
		_lRet := .T.
	Else
		cSegisp := SZ1->Z1_SEGISP
	Endif
Else
	MsgAlert("Segmento n�o cadastrado para o usu�rio","Aten��o")
EndIf

restarea(_aArea)

return _lRet



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuMod			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Habilita campo de uf                                                            |
|-----------------------------------------------------------------------------------------------|
*/


User Function AtuMod(nMod)

cUF	:= Space( avSx3("A1_EST",3) )

if nMod == 1
	
	oUf:lActive	:= .f.
	
Elseif nMod == 2
	
	oUf:lActive	:= .t.
	
Endif

oUf:Refresh()
oDlg:Refresh()

Return(.t.)



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuMod			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Habilita campo de uf                                                            |
|-----------------------------------------------------------------------------------------------|
*/


User Function BotSel(nMod)

if nMod
	
	oButProc1:lActive	:= .t.
	oRadSub1:lActive	:= .f.
	
Else
	
	oButProc1:lActive	:= .f.
	oRadSub1:lActive	:= .t.
	
Endif

oButProc1:Refresh()
oRadSub1:Refresh()
oDlg:Refresh()

Return(.t.)



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValUf			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Fun��o para validar o Estado             									  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValUf(_cUf)

Local _aArea 	:= getArea()
Local _lRet		:= .T.

DbSelectArea("SX5")
DbSetOrder(1)
If !(DbSeek(cFilAnt + "12" + _cUf,.f.))
	MsgAlert("UF Incorreta","Aten��o")
	_lRet := .F.
EndIf

restarea(_aArea)

return _lRet


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : RelCli			 	| 	Mar�o de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Abre tela para digita��o dos CNPJ`s                                             |
|-----------------------------------------------------------------------------------------------|
*/

Static Function RelCli()

Local aCampos  	:= {}
Local aButtons 	:= {}
Local cProdAlt 	:= ""
Local cNmCli   	:= ""
Local nQtdCpo   := 0
Local nCols     := 0
Local cCod		:= ""
Local _nCount 	:= 0
Local _nAlt		:= 0
Local _Larg		:= 0

Private nQtde 		:= 0
Private nDesc 		:= 0
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oDlgTMP     := Nil
Private oButton		:= NIL
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {}
Private aRotina     := .F.
Private cLoja       := ""
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)
Private oGroup4

aObjects := {}
aInfo	 := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 := MsObjSize( ainfo, aObjects )

aadd(aEdit, "A1_CGC")

//Cria janela
CriaHeader()
CriaCols()

DEFINE MSDIALOG oDlgTMP TITLE "Rela��o de Clientes por Zona" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5]-125 PIXEL
oDlgTMP:lMaximized := .F.
_nLarg 	:= oDlgTmp:nWidth/2-5
_nAlt	:=oDlgTmp:nHeight/2-30

@ 6,05 Say "Sele��o de Clientes" SIZE 70,100 OF oDlgTMP COLOR 255, 16777215 PIXEL FONT oFont12

oGetTM1 := MsNewGetDados():New(20, 05, _nAlt, _nLarg, GD_INSERT+GD_DELETE+GD_UPDATE , "AllwaysTrue", "AllwaysTrue","", aEdit, , , "U_ITMKR15A()" , , , oDlgTMP, aHeaderB, aColsB)

ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{||cCod:=oGetTM1:aCols[oGetTM1:nAt][1],oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)

_nCount := Len(aColsB)

If Empty(aColsB[_nCount][1])
	_nCount := _nCount - 1
EndIf           

_cCNPJ := ""

For i:= 1 to _nCount
	If !(aColsB[i][3]) .and. !Empty(aColsB[i][1])
		If i == _nCount
			_cCNPJ += aColsB[i][1]
		Else
			_cCNPJ += aColsB[i][1] + ","
		EndIf
	EndIf
Next 

//_cCNPJ += ")"

     
If !Empty(_cCNPJ)
	_cCNPJ := FormatIn(_cCNPJ,",")
EndIf


Return .T.

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Marco de 2015					  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Cria��o do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()

aHeaderB      := {}
aCpoHeader   := {"A1_CGC","A1_NOME"}

For _nElemHead 	:= 1 To Len(aCpoHeader)
	_cCpoHead 	:= aCpoHeader[_nElemHead]
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(	SX3->X3_Titulo)		,;
								SX3->X3_Campo       ,;
								SX3->X3_Picture     ,;
								SX3->X3_Tamanho     ,;
								SX3->X3_Decimal     ,;
								""      			,;
								SX3->X3_Usado       ,;
								SX3->X3_Tipo        ,;
								"SA1CGC"		    ,;
								SX3->X3_Context})
	Endif
Next _nElemHead

dbSelectArea("SX3")
dbSetOrder(1)

Return Nil




/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Mar�o de 2015	     			  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Cria��o do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols()

Local   n			:= 0
Local	nPos_Cnpj 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A1_CGC"	})
Local	nPos_Nome 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A1_NOME"	})
Local	nQtdCpo 	:= Len(aHeaderB)

aColsB := {}

n++
AAdd(aColsB, Array(nQtdCpo+1))

aColsB[n][nQtdCpo+1]  	 	:= .F.
aColsB[n][nPos_Cnpj] 	 	:= space(TamSx3("A1_CGC")[1])
aColsB[n][nPos_Nome] 	 	:= space(TamSx3("A1_NOME")[1])
aColsB[n][Len(aHeaderB)+1]	:= .F.

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKR15A				 			| 	Mar�o de 2015				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Preenche nome do produto do acols ap�s digitar o codigo						  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function ITMKR15A()


Local _aArea	:= GetArea()
Local _aAreaSA1	:= SA1->(GetArea())
Local lRet := .T.

If(ASCAN(oGetTM1:aCols, { |n| AllTrim(n[1]) == alltrim(M->A1_CGC) }) > 0 )
	alert("Cnpj j� incluso")
	lRet := .F.
EndIf

If lRet
	DbSelectArea("SA1")
	DbSetOrder(3)
	If DbSeek(xFilial("SA1")+M->A1_CGC)
		oGetTM1:Acols[oGetTM1:nAt][2] := SA1->A1_NOME
		aColsB := oGetTM1:Acols
	Else
		alert("Cnpj Inexistente")
		lRet := .F.
	EndIf
EndIf

RestArea(_aAreaSA1)
RestArea(_aArea)


Return lRet

