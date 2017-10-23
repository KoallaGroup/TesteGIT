#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR16				 	| 	Julho de 2015                                       |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de clientes não visitados                                             |
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR16()

Local oButton1
Local oButton2
Local oGroup1
Local oSay1
Local nRet 		:= 0
Local oFont 	:= tFont():New("Tahoma",,12,,.t.)
Local _nLin		:= 0
Local aPergs	:= {}

Static oDlg

Private oGet1
Private oGet2
Private dDataRef	:= ddatabase
Private _cLocal		:= space(TAMSX3("ZE_CODFIL")[1])
Private _cDescLoc	:= space(TAMSX3("ZE_FILIAL")[1])
Private cRepresDe	:= space(TAMSX3("A3_COD")[1])
Private cDescRepDe	:= space(TAMSX3("A3_NOME")[1])
Private cRepresAte	:= space(TAMSX3("A3_COD")[1])
Private cDescRepAte	:= space(TAMSX3("A3_NOME")[1])
Private _cSeg		:= space(TAMSX3("Z7_CODIGO")[1])
Private _cDescSeg	:= space(TAMSX3("Z7_DESCRIC")[1])
Private cOrigem		:= 1
Private _lOk		:= .T.
Private oRadSub
Private cPerg		:= PADR("IFATR16",Len(SX1->X1_GRUPO))
Private aSx1		:= {}

Aadd(aPergs,{"Local						","","","mv_ch1","C",TamSx3("UA_FILIAL")[1]	,0,0,"G","","MV_PAR01",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Segmento					","","","mv_ch2","C",TamSx3("A1__SEGISP")[1],0,0,"G","","MV_PAR02",""	,"","","","" 	  ,"","","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"A Partir do Representante	","","","mv_ch3","C",TamSx3("A1_VEND")[1]	,0,0,"G","","MV_PAR03",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Até o Representante       ","","","mv_ch4","C",TamSx3("A1_VEND")[1]	,0,0,"G","","MV_PAR04",""	,"","","","999999","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Até a Visita				","","","mv_ch5","D",08						,0,0,"G","","MV_PAR05",""	,"","","",""	  ,"","","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

Pergunte (cPerg,.f.)

_cLocal		:= MV_PAR01
_cSeg	 	:= MV_PAR02
cRepresDe	:= MV_PAR03
cRepresAte	:= MV_PAR04
dDataRef	:= MV_PAR05

DEFINE MSDIALOG oDlg TITLE "Relatório de clientes não visitados" FROM 000, 000  TO 280, 530 COLORS 0, 16777215 PIXEL

_nLin := 15

@ _nLin,015 SAY "Local" SIZE 20, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet _cLocal 	when .T. Picture PesqPict("SZE","ZE_CODFIL") 	Size 010, 010 	of oDlg PIXEL FONT oFont F3 "SM0" VALID(AtuLoc(_cLocal))
@ _nLin-1,125 MSGET _cDescLoc	When .F. Picture PesqPict("SZE","ZE_FILIAL")	SIZE 130, 010	OF oDlg COLORS 0, 16777215 PIXEL

_nLin := _nLin + 15

@ _nLin,015 SAY "Origem" SIZE 20, 10 OF oDlg PIXEL //FONT oFont
_nLin := _nLin + 2
@ _nLin-1,080 RADIO	oRadSub 	  VAR cOrigem   When .F. Prompt OemToAnsi("CAC")/*, OemToAnsi("FAT")*/ Size 080,008 of oDlg PIXEL

_nLin := _nLin + 15

@ _nLin,015 SAY "Segmento" SIZE 30, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet _cSeg 		when .T. Picture PesqPict("SZ7","Z7_CODIGO") 	Size 020, 010 	of oDlg PIXEL FONT oFont F3 "SZ72" VALID(AtuSeg(_cSeg))
@ _nLin-1,125 MSGET _cDescSeg	When .F. Picture PesqPict("SZ7","Z7_DESCRIC")	SIZE 130, 010	OF oDlg COLORS 0, 16777215 PIXEL

_nLin := _nLin + 15

@ _nLin,015 SAY "Representante De" SIZE 65, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet cRepresDe when .T. Picture PesqPict("SA3","A3_COD") Size 040,10 of oDlg PIXEL FONT oFont F3 "SA3" VALID(buscaRep(cRepresDe,.T.))

_nLin := _nLin + 15

@ _nLin,015 SAY "Representante Até" SIZE 65, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet cRepresAte when .T. Picture PesqPict("SA3","A3_COD") Size 040,10 of oDlg PIXEL FONT oFont F3 "SA3" VALID(buscaRep(cRepresAte,.F.))

_nLin := _nLin + 15

@ _nLin,015 SAY "Data de Referência" SIZE 65, 10 OF oDlg PIXEL //FONT oFont
@ _nLin-1,080 MsGet dDataRef when .T. Picture "@D" Size 050,10 of oDlg PIXEL FONT oFont

_nLin := _nLin + 25

@ _nLin,080 BUTTON oButton1 PROMPT "Processar" SIZE 040, 012 OF oDlg PIXEL ACTION (MsAguarde({|| U_IFATR16A()},"Gerando Relatório..."),oDlg:End())
@ _nLin,145 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

oRadSub:lHoriz 	:= .T.
oRadSub:bChange	:= {|| AtuOri(cOrigem) }

ACTIVATE MSDIALOG oDlg CENTERED

Return


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR16A			 	| 	Julho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Chamada do relatório Crystal        		     							  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR16A()

Local aArea   	:= GetArea()
Local cOptions 	:= ""
Local cParams	:= ""
Local cRepTran	:= ""
Local cLocalDe	:= ""
Local cLocalAte	:= ""
Local cSegDe	:= ""
Local cSegAte	:= ""

AADD(aSx1,;
	{	_cLocal			,;
		_cSeg			,;
		cRepresDe		,;
		cRepresAte		,;
		DTOS(dDataRef)	})
GravaSx1()

If Empty(_cLocal)
	cLocalDe	:= "  "
	cLocalAte	:= "ZZ"
Else
	cLocalDe	:= _cLocal
	cLocalAte	:= _cLocal
EndIf

If Empty(_cSeg)
	cSegDe	:= "  "
	cSegAte	:= "ZZ"
Else
	cSegDe	:= _cSeg
	cSegAte	:= _cSeg
EndIf

If Empty(cRepresDe)
	cRepresDe := "1"
EndIf

If "Z" $ UPPER(cRepresAte)
	cRepresAte := "999999"
EndIf

cRepTran := cRepresDe

If SUBSTR(cRepresDe,1,1) > SUBSTR(cRepresAte,1,1)
	cRepresDe 	:= cRepresAte
	cRepresAte	:= cRepTran
EndIf

cOptions 	:= "1;0;1;Relatório de clientes não visitados" // 1(visualiza tela) 2 (direto impressora) 6(pdf) ; 0 (atualiza dados) ; 1 (número de cópias)

cParams := cLocalDe			+ ";"		//Local De
cParams += cLocalAte		+ ";"		//Local Ate
cParams += cSegDe			+ ";"		//Segmento De
cParams += cSegAte			+ ";"		//Segmento Ate
cParams += cRepresDe 		+ ";"		//Representante De
cParams += cRepresAte 	 	+ ";"		//Representante Ate
cParams += DTOS(dDataRef) 		 		//Data Referência

CallCrys("IFATCR16",cParams,cOptions)

RestArea(aArea)

Return Nil



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : buscaRep			 	| 	Julho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para validar o Representante        									  	|
|-----------------------------------------------------------------------------------------------|
*/


static function buscaRep(cRepres,cTpRep)

Local aArea := getArea()
Local lOk	:= .T.

If !((upper(Alltrim(cRepres)) == "ZZZZZZ") .or. (upper(Alltrim(cRepres)) == "999999"))
	
	dbSelectArea("SA3")
	dbSetOrder(1)
	
	If cTpRep .and. !Empty(cRepres)
		if !dbSeek(xFilial("SA3")+cRepres)
			msgAlert ("Representante não encontrado !!")
			lOk	:= .F.
		EndIf
	ElseIf !(cTpRep)
		If (upper(Alltrim(cRepres)) $ "ZZZZZZ")
			cRepresAte := "999999"
		ElseIf !dbSeek(xFilial("SA3")+cRepres)
			msgAlert ("Representante não encontrado !!")
			lOk	:= .F.
		EndIf
	endif
	
EndIf
restarea(aArea)

return lOk


Static Function AtuOri()

oRadSub:Refresh()
oDlg:Refresh()

Return(.t.)


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuSeg			 	| 	Junho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Segmento                                                                 |
|-----------------------------------------------------------------------------------------------|
*/

Static Function AtuSeg(PSeg)

Local _aArea 	:= GetArea()
Local lRet	:= .T.

SZ7->(dbSetOrder(1))

IF !(SZ7->( dbSeek(xFilial("SZ7")+Alltrim(PSeg)) ) .and. Alltrim(PSeg) != "0")
	MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
	lRet	:= .F.
Else
	If !Empty(PSeg)
		_cDescSeg := SZ7->Z7_DESCRIC
	Else
		_cDescSeg := space(TAMSX3("Z7_DESCRIC")[1])
	EndIf
EndIf

RestArea (_aArea)

Return(lRet)



/*
|-----------------------------------------------------------------------------------------------|
|	Programa : AtuLoc			 	| 	Junho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Valida Local                                                                    |
|-----------------------------------------------------------------------------------------------|
*/

Static Function AtuLoc(_cLoc)

Local _aArea 	:= GetArea()
Local lRet		:= .T.

dbSelectArea("SZE")
dbSetOrder(1)

If  !Empty(Alltrim(_cLoc))
	IF !(dbSeek(cEmpAnt + Alltrim(_cLoc)))
		MsgAlert("Favor utilizar Segmento contido no help de campo","PARÂMETROS INVÁLIDOS")
		lRet	:= .F.
	Else
		_cDescLoc := SZE->ZE_FILIAL
	EndIf
	
Else
	_cDescLoc := space(TAMSX3("ZE_FILIAL")[1])
EndIf

RestArea (_aArea)

Return(lRet)


/*
+-----------+----------+-------+---------------------------------------+------+------------+
| Programa  | GravaSX1 | Autor | Rogério Alves - Anadi Soluções 	   | Data | Julho/2015 |
+-----------+----------+-------+---------------------------------------+------+------------+
| Descricao | Grava valores na SX1														   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA		  																   |
+-----------+------------------------------------------------------------------------------+
*/

Static Function GravaSx1()

Local nX := 1

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
