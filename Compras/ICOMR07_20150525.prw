#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMR07				 	| 	Outubro de 2014                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Etiquetas para importação                                                       |
|-----------------------------------------------------------------------------------------------|
*/

User Function ICOMR07()

Local oButton1
Local oButton2
Local oButton3
Local oGroup1
Local oSay1
Local nRet 		:= 0
Local oFont1 	:= tFont():New("Tahoma",,14,,.t.)
Local oFont 	:= tFont():New("Tahoma",,12,,.t.)
Local oFont2 	:= tFont():New("Tahoma",,12,,.t.)
Local aSM0 		:= FWLoadSM0()
Local cFil		:= Space(2) 
Local _nOpcoes 	:= GETF_NETWORKDRIVE + GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_RETDIRECTORY

Static oDlg

Private cArrayProd := ""
Private cProc 	:= space(10)
Private cProd1 	:= cProd2 := cProd3 := cProd4 := cProd5 := cProd6 := cProd7 := cProd8 := cProd9 := cProd10 := cProd11 := cProd12 := cProd13 := cProd14 := space(TAMSX3("B1_COD")[1])
Private cDesc1 	:= cDesc2 := cDesc3 := cDesc4 := cDesc5 := cDesc6 := cDesc7 := cDesc8 := cDesc9 := cDesc10 := cDesc11 := cDesc12 := cDesc13 := cDesc14 := space(TAMSX3("B1_DESC")[1])
Private cQtde1 	:= cQtde2 := cQtde3 := cQtde4 := cQtde5 := cQtde6 := cQtde7 := cQtde8 := cQtde9 := cQtde10 := cQtde11 := cQtde12 := cQtde13 := cQtde14 := space(4)
Private cForn 	:= space(TAMSX3("A2_COD")[1])
Private cLoja 	:= space(TAMSX3("A2_LOJA")[1])
Private cNomFor	:= ""
Private oGetp1,oGetp2,oGetp3,oGetp4,oGetp5,oGetp6,oGetp7,oGetp8,oGetp9,oGetp10,oGetp11,oGetp12,oGetp13,oGetp14
Private oGetd1,oGetd2,oGetd3,oGetd4,oGetd5,oGetd6,oGetd7,oGetd8,oGetd9,oGetd10,oGetd11,oGetd12,oGetd13,oGetd14
Private oGetq1,oGetq2,oGetq3,oGetq4,oGetq5,oGetq6,oGetq7,oGetq8,oGetq9,oGetq10,oGetq11,oGetq12,oGetq13,oGetq14
Private oGetf1,oGetf2
Private oGetFil
Private oGetPath
Private aDesEmp	:= ""
Private aCGC	:= space(TAMSX3("A2_CGC")[1])
Private cPath	:= space(100)

DEFINE MSDIALOG oDlg TITLE "Etiquetas para importação" FROM 000, 000  TO 500, 600 COLORS 0, 16777215 PIXEL

@ 006,035 SAY "Empresa" 			SIZE 30, 10 OF oDlg PIXEL FONT oFont1
@ 006,065 MsGet oGetFil VAR cFil when .T. Picture "@!" Size 010,8 of oDlg PIXEL FONT oFont1 F3 "ZM0" valid ValidaFil(cFil)
@ 007,090 SAY aDesEmp Picture "@!" 	SIZE 130, 10 OF oDlg PIXEL FONT oFont2

@ 006,205 SAY "Cnpj" 				SIZE 20, 10 OF oDlg PIXEL FONT oFont1 
@ 006,225 MsGet aCGC when .T. Picture PesqPict("SA2","A2_CGC") SIZE 70, 10 OF oDlg PIXEL FONT oFont1 valid ValidaCNPJ(aCGC)

@ 019,015 SAY "Cnpj Importador" 	SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 019,065 MsGet oGetf1 VAR cForn when .T. Picture PesqPict("SA2","A2_CGC") Size 070,8 of oDlg PIXEL FONT oFont1 F3 "SA2B" valid ValidaForn(cForn)
@ 019,185 SAY "Procedência" 		SIZE 40, 10 OF oDlg PIXEL FONT oFont1
@ 019,225 MsGet cProc 				SIZE 40, 8 OF oDlg PIXEL FONT oFont1

@ 032,025 SAY "Razão Social" 		SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 033,065 SAY cNomFor 				SIZE 220, 10 OF oDlg PIXEL FONT oFont2

@ 045,035 SAY "Caminho" 			SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 045,065 MsGet oGetPath VAR cPath 	Size 150,008 Of oDlg PIXEL FONT oFont1 WHEN .F.

@ 060,006 GROUP oGroup1 TO 230, 298 PROMPT "Relação de Stickers" OF oDlg COLOR 0, 16777215 PIXEL

@ 070,015 SAY "Código" SIZE 30, 10 OF oDlg PIXEL
@ 070,076 SAY "Descrição" SIZE 50, 10 OF oDlg PIXEL
@ 070,245 SAY "Qtde. Emb. Master" SIZE 60, 10 OF oDlg PIXEL

@ 080,015 MsGet oGetp1 VAR cProd1 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd1,1)
@ 080,076 MsGet oGetd1 VAR cDesc1 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 080,265 MsGet oGetq1 VAR cQtde1 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde1,1)

@ 090,015 MsGet oGetp2 VAR cProd2 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd2,2)
@ 090,076 MsGet oGetd2 VAR cDesc2 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 090,265 MsGet oGetq2 VAR cQtde2 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde2,2)

@ 100,015 MsGet oGetp3 VAR cProd3 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd3,3)
@ 100,076 MsGet oGetd3 VAR cDesc3 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 100,265 MsGet oGetq3 VAR cQtde3 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde3,3)

@ 110,015 MsGet oGetp4 VAR cProd4 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd4,4)
@ 110,076 MsGet oGetd4 VAR cDesc4 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 110,265 MsGet oGetq4 VAR cQtde4 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde4,4)

@ 120,015 MsGet oGetp5 VAR cProd5 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd5,5)
@ 120,076 MsGet oGetd5 VAR cDesc5 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 120,265 MsGet oGetq5 VAR cQtde5 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde5,5)

@ 130,015 MsGet oGetp6 VAR cProd6 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd6,6)
@ 130,076 MsGet oGetd6 VAR cDesc6 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 130,265 MsGet oGetq6 VAR cQtde6 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde6,6)

@ 140,015 MsGet oGetp7 VAR cProd7 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd7,7)
@ 140,076 MsGet oGetd7 VAR cDesc7 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 140,265 MsGet oGetq7 VAR cQtde7 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde7,7)

@ 150,015 MsGet oGetp8 VAR cProd8 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd8,8)
@ 150,076 MsGet oGetd8 VAR cDesc8 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 150,265 MsGet oGetq8 VAR cQtde8 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde8,8)

@ 160,015 MsGet oGetp9 VAR cProd9 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd9,9)
@ 160,076 MsGet oGetd9 VAR cDesc9 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 160,265 MsGet oGetq9 VAR cQtde9 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde9,9)

@ 170,015 MsGet oGetp10 VAR cProd10 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd10,10)
@ 170,076 MsGet oGetd10 VAR cDesc10 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 170,265 MsGet oGetq10 VAR cQtde10 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde10,10)

@ 180,015 MsGet oGetp11 VAR cProd11 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd11,11)
@ 180,076 MsGet oGetd11 VAR cDesc11 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 180,265 MsGet oGetq11 VAR cQtde11 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde11,11)

@ 190,015 MsGet oGetp12 VAR cProd12 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd12,12)
@ 190,076 MsGet oGetd12 VAR cDesc12 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 190,265 MsGet oGetq12 VAR cQtde12 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde12,12)

@ 200,015 MsGet oGetp13 VAR cProd13 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd13,13)
@ 200,076 MsGet oGetd13 VAR cDesc13 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 200,265 MsGet oGetq13 VAR cQtde13 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde13,13)

@ 210,015 MsGet oGetp14 VAR cProd14 when .T. Picture "@!" Size 060,8 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid ValidaItem(cProd14,14)
@ 210,076 MsGet oGetd14 VAR cDesc14 when .F. Picture "@!" Size 170,8 of oDlg PIXEL FONT oFont
@ 210,265 MsGet oGetq14 VAR cQtde14 when .F. Picture "9999" Size 020,8 of oDlg PIXEL FONT oFont valid ValidaQtd(cQtde14,14)

@ 235,050 BUTTON oButton1 PROMPT "Caminho" 					SIZE 040, 012 OF oDlg PIXEL ACTION (cPath := PadR(cGetFile( , 'Salvar Boleto', 1, 'C:\', .F., _nOpcoes,.F., .T. ),150))
@ 235,100 BUTTON oButton1 PROMPT "Gerar Etiqueta" 			SIZE 040, 012 OF oDlg PIXEL ACTION MsAguarde( {|| ICOMR07A(.F.)},"Processando...") 
@ 235,150 BUTTON oButton2 PROMPT "Etiqueta Qtde. Master " 	SIZE 060, 012 OF oDlg PIXEL ACTION MsAguarde( {|| ICOMR07A(.T.)},"Processando...") 
@ 235,220 BUTTON oButton3 PROMPT "Cancelar" 				SIZE 037, 012 OF oDlg PIXEL ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTERED                                                                             

Return

////////////////////////////////////////////////
//Chama rotina do Crystall Reports
////////////////////////////////////////////////

Static Function ICOMR07A(cMaster)

Local aArea   	:= GetArea()
Local _cNome	:= "Sticker_" + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2)
Local cOptions 	:= "6;0;1;" + _cNome
Local cParams	:= ""
Local cUseId	:= __cUserId
Local nVezes	:= 30
Local nEmaster	:= ""
Local cProd		:= ""
Local cDesc		:= ""  
Local lSucess	:= .T.

_lGera := .F.     

If(Empty(cPath))
	alert("Caminho não preenchido")
	Return
EndIf         

For x:=1 to 14
	
	If !Empty(&("cProd" + Alltrim(Str(x))))
		_lGera := .T.
		exit	
	endif
		
next x

if ! _lGera
	alert ("Nenhum ítem para gerar etiqueta. Favor verificar !!")
	return
endif


If TcCanOpen(RetSqlName("PA1"))
	cQuery := " DELETE "+RetSqlName("PA1")
	cQuery += " WHERE PA1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND PA1_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
EndIf

For x:=1 to 14
	
	If !Empty(&("cProd" + Alltrim(Str(x))))	.and.!Empty(&("cDesc" + Alltrim(Str(x)))) .and. !Empty(&("cQtde" + Alltrim(Str(x))))
		
		nEmaster	:= &("cQtde" + Alltrim(Str(x)))
		cProdx		:= &("cProd" + Alltrim(Str(x)))
		cDesc		:= &("cDesc" + Alltrim(Str(x)))
		
		dbSelectArea("SB1")
		dbSetOrder(1)
		if dbSeek(xFilial("SB1")+cProdx)
			
			For y:=1 to nVezes
				While !RecLock("PA1",.t.)
				Enddo
				PA1_USER	:= cUseId
				PA1_COD		:= SB1->B1_COD
				If !cMaster
					PA1_DESC	:= Alltrim("*" + Alltrim(SB1->B1_COD) + "*")	//TAMANHO 16
				Else
					PA1_DESC	:= "*" + PadL(nEmaster,4, "0") + Alltrim(SB1->B1_COD) + "*"
				EndIf
				
				If !cMaster
					PA1_DESC1 	:= Alltrim(SB1->B1_COD) + " UNI: " + Alltrim(STR(SB1->B1_QE)) + " " + SB1->B1_UM //Arial 8
				Else
					PA1_DESC1 	:= PadL(nEmaster,4, "0") + " " + Alltrim(SB1->B1_COD)
				EndIf
				//Arial tamanho 7 NEGRITO
				PA1_DESC2  	:= Alltrim(SB1->B1_DESC)
				
				If Alltrim(SB1->B1__SEGISP) == "1"
					PA1_DESCI  	:= Iif(Empty(PA1_DESCI),"",(Alltrim(PA1_DESCI) + "-Para Bicicleta "))
				EndIf
				/*
				If !Empty(Posicione("SB5",1, xFilial("SB5")+SB1->B1_COD, "B5_CEME"))
				PA1_DESCI  	:= Alltrim(PA1_DESCI) + "/ Comp: " + Alltrim(Posicione("SB5",1, xFilial("SB5")+SB1->B1_COD, "B5_CEME"))
				EndIf
				*/
				If !Empty(SB1->B1__DESCET)
					PA1_DESCI  	:= Alltrim(PA1_DESCI) + "/ Comp: " + Alltrim(SB1->B1__DESCET)
				EndIf
				If SB1->B1_ORIGEM != "0"
					PA1_DESC3 	:= 	Iif(Empty(cNomFor),"","IMPORT.: " + UPPER(Alltrim(cNomFor)))
				Else
					PA1_DESC3 	:= Iif(Empty(cNomFor),"","FORNEC.: " + UPPER(Alltrim(cNomFor)))
				EndIf
				PA1_DESC4 	:= Iif(Empty(cForn),"","CNPJ.: " + Transform( cForn, PesqPict( "SA2", "A2_CGC" ) ))
				PA1_DESC5 	:= Iif(Empty(cProc),"","PROC: " + upper(Alltrim(cProc)))
				If !cMaster
					If SB1->B1_TIPO $ "CA/PN"
						PA1_DESC6 	:= "Validade 5 anos              Garantia: 90 dias"
					Else
						PA1_DESC6 	:= "Validade Indeterminada       Garantia: 90 dias"
					EndIf
				EndIf
				
				MsUnLock()
			Next
			
		EndIf
		
		cParams := cUseId //+ ";" //Usuário
		//cParams += SB1->B1_COD 	//Produto
		
	EndIf
Next

CallCrys("ICOMCR07",cParams,cOptions)

//Copia arquivo para a estação do usuario 
//lSucess := CpyT2S(GetSrvProfString ("ROOTPATH","") + "\Relatorios\" + _cNome + ".pdf",cPath,.T.)
Sleep(5000)

lSucess := CpyS2T("\Relatorios\" + _cNome + ".pdf",cPath,.T.)

if !lSucess
  Alert("Não foi possivel copiar arquivo para a estação")
endif

If (FErase("\Relatorios\" + _cNome + ".pdf",,.F.) != 0)
	Alert("Não foi possível apagar arquivo: " + FError())
EndIf   

MsgInfo ("Processo Finalizado !!")

//oDlg:End()

RestArea(aArea)

Return .T.


////////////////////////////////////////////////
//VALIDA Quantidade
////////////////////////////////////////////////

Static Function ValidaQtd(Qtd,n)

local _aArea := getArea()
local _lRet  := .T.

If Empty(Qtd)
	If !Empty(&("cProd" + Alltrim(Str(n))))
		msgAlert("Quantidade Nula !!")
		&("oGetp" + Alltrim(Str(n))):SetFocus()
	EndIf
EndIf

restarea(_aArea)

return _lRet


////////////////////////////////////////////////
//VALIDA PRODUTO
////////////////////////////////////////////////

Static Function ValidaItem(cProdVal,n)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cProdVal)
	dbSelectArea("SB1")
	dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+cProdVal)
		msgAlert("Produto não cadastrado !!")
		_lRet := .F.
	Else
		cArrayProd := ""
		For x:=1 to 14
			If !Empty(&("cProd" + Alltrim(Str(x))))
				If &("cProd" + Alltrim(Str(x))) $ cArrayProd
					msgAlert("Produto já indicado !!")
					&("cProd" + Alltrim(Str(x))) := space(TAMSX3("B1_COD")[1])
					&("cDesc" + Alltrim(Str(x))) := space(TAMSX3("B1_DESC")[1])
					&("cQtde" + Alltrim(Str(x))) := space(4)
					&("oGetp" + Alltrim(Str(x))):SetFocus()
				Else
					cArrayProd := cArrayProd  + IIf(!Empty(cArrayProd),"/","") + &("cProd" + Alltrim(Str(x)))
					&("cDesc" + Alltrim(Str(x))) := Posicione("SB1",1, xFilial("SB1")+&("cProd" + Alltrim(Str(x))), "B1_DESC")
					&("cQtde" + Alltrim(Str(x))) := Posicione("SB1",1, xFilial("SB1")+&("cProd" + Alltrim(Str(x))), "B1__EMBMAS")
					&("oGetq" + Alltrim(Str(x))):SetFocus()
				EndIf
			EndIf
		Next
	EndIf
Else
	&("cDesc" + Alltrim(Str(n))) := space(TAMSX3("B1_DESC")[1])
	&("cQtde" + Alltrim(Str(n))) := space(4)
EndIf

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA FORNECEDOR
////////////////////////////////////////////////

Static Function ValidaForn(cForn)

local _aArea := getArea()
local _lRet  := .T.

If !Empty(cForn)
	dbSelectArea("SA2")
	dbSetOrder(3)
	if !dbSeek(xFilial("SA2")+cForn)
		msgAlert("Fornecedor não cadastrado !!")
		_lRet := .F.
	Else
		cNomFor := UPPER(Alltrim(A2_NOME))
	EndIf
EndIf

restarea(_aArea)

return _lRet

////////////////////////////////////////////////
//VALIDA FILIAL
////////////////////////////////////////////////

Static Function ValidaFil(cFil)

local _aArea := getArea()
local _lRet  := .T.

aDesEmp	:= ""

If !Empty(cFil)	
	DbSelectArea("SM0")
	DbGoTop()
	While !EOf()
		IF Alltrim(cFil) == Alltrim(SM0->M0_CODIGO)
			aDesEmp	:= SM0->M0_NOMECOM
			Exit
		ENDIF
		DbSkip()
	EndDo
	If Empty(aDesEmp)		
		msgAlert("Empresa não cadastrado !!")
		aDesEmp	:= ""
		cFil	:= Space(2)
		_lRet := .F.
	EndIf
EndIf

oGetFil:Refresh()

restarea(_aArea)

return _lRet



Static Function ValidaCNPJ(cCnpj)

	local _aArea := getArea()
	local _lRet  := .F.         
	local cCnpj  := cCnpj
	
	If !Empty(cCnpj)	
		DbSelectArea("SM0")
		DbGoTop()
		While !EOf()
			IF Alltrim(cCnpj) == Alltrim(SM0->M0_CGC)
				_lRet  := .T.			
				Exit
			ENDIF
			DbSkip()
		EndDo
		If ! _lRet
			msgAlert("CNPJ não cadastrado !!")
		EndIf
	else
		_lRet  := .T.			
	EndIf
	
	restarea(_aArea)
	
return _lRet
