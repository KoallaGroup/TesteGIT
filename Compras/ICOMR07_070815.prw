#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ICOMR07				 	| 	Outubro de 2014                                     |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rog�rio Alves - Anadi                                                      |
|-----------------------------------------------------------------------------------------------|
|	Descri��o : Etiquetas para importa��o                                                       |
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
    
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFieldFill := {}
Local aFields := {"B1_COD","B1_DESC","B1__EMBMAS"}
Local aAlterFields := {"B1_COD"}
Static oMSNewGe1


Static oDlg

//Private cArrayProd := ""
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

DEFINE MSDIALOG oDlg TITLE "Etiquetas para importa��o" FROM 000, 000  TO 500, 600 COLORS 0, 16777215 PIXEL

@ 006,035 SAY "Empresa" 			SIZE 30, 10 OF oDlg PIXEL FONT oFont1
@ 006,065 MsGet oGetFil VAR cFil when .T. Picture "@!" Size 010,8 of oDlg PIXEL FONT oFont1 F3 "ZM0" valid ValidaFil(cFil)
@ 007,090 SAY aDesEmp Picture "@!" 	SIZE 130, 10 OF oDlg PIXEL FONT oFont2

@ 006,205 SAY "Cnpj" 				SIZE 20, 10 OF oDlg PIXEL FONT oFont1 
@ 006,225 MsGet aCGC when .T. Picture PesqPict("SA2","A2_CGC") SIZE 70, 10 OF oDlg PIXEL FONT oFont1 valid ValidaCNPJ(aCGC)

@ 019,015 SAY "Cnpj Importador" 	SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 019,065 MsGet oGetf1 VAR cForn when .T. Picture PesqPict("SA2","A2_CGC") Size 070,8 of oDlg PIXEL FONT oFont1 F3 "SA2B" valid ValidaForn(cForn)
@ 019,185 SAY "Proced�ncia" 		SIZE 40, 10 OF oDlg PIXEL FONT oFont1
@ 019,225 MsGet cProc 				SIZE 40, 8 OF oDlg PIXEL FONT oFont1

@ 032,025 SAY "Raz�o Social" 		SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 033,065 SAY cNomFor 				SIZE 220, 10 OF oDlg PIXEL FONT oFont2

@ 045,035 SAY "Caminho" 			SIZE 50, 10 OF oDlg PIXEL FONT oFont1
@ 045,065 MsGet oGetPath VAR cPath 	Size 150,008 Of oDlg PIXEL FONT oFont1 

@ 060,006 GROUP oGroup1 TO 230, 298 PROMPT "Rela��o de Stickers" OF oDlg COLOR 0, 16777215 PIXEL

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO,SX3->X3_WHEN,SX3->X3_VISUAL,SX3->X3_VLDUSER})
    Endif
Next nX

aHeaderEx[1][6] := "U_ICOMR07V(M->B1_COD) "  
aHeaderEx[1][9] := "SB1LIK" 

aHeaderEx[2][1] := "Descri��o" 
aHeaderEx[3][1] := "Qtde. Emb. Master" 

oMSNewGe1 := MsNewGetDados():New( 70, 006, 230, 297, GD_INSERT+GD_DELETE+GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aAlterFields,,,,,, oDlg, aHeaderEx, aColsEx)

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
//Local _cNome	:= "Sticker_" + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2)
Local cOptions 	:= ""
Local cParams	:= ""
Local cUseId	:= __cUserId
Local nVezes	:= 30
Local nEmaster	:= ""
Local cProd		:= ""
Local cDesc		:= ""  
Local lSucess	:= .T.
                      

If(Empty(cPath))
	alert("Caminho n�o preenchido")
	Return
EndIf         

_cDir := separa(cPath, '\')
_cNome := alltrim(_cDir[len(_cDir)])
cPath := ""

for x := 1 to len(_cDir)-1
	cPath += _cDir[x] + "\"
next x

cOptions 	:= "6;0;1;" + _cNome

_lGera := .F.     

If len(oMSNewGe1:aCols) > 0 .and. !empty(oMSNewGe1:aCols[1][1])
	_lGera := .T.
endif

if ! _lGera
	alert ("Nenhum �tem para gerar etiqueta. Favor verificar !!")
	return
endif


If TcCanOpen(RetSqlName("PA1"))
	cQuery := " DELETE "+RetSqlName("PA1")
	cQuery += " WHERE PA1_FILIAL = '"+xFilial("SB1")+"' "
	cQuery += " AND PA1_USER = '"+cUseId+"' "
	TCSqlExec(cQuery)
EndIf

For x:=1 to len(oMSNewGe1:aCols)	

	If oMSNewGe1:aCols[x][len(oMSNewGe1:aHeader)+1]
		loop
	endif

	cProdx	:= oMSNewGe1:aCols[x][1]
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	if dbSeek(xFilial("SB1")+cProdx)

		cDesc 	:= SB1->B1_DESC
		nEmaster:= SB1->B1__EMBMAS
		
		For y:=1 to nVezes
			While !RecLock("PA1",.t.)
			Enddo
			PA1_USER	:= cUseId
			PA1_COD		:= SB1->B1_COD
			If !cMaster
				PA1_DESC	:= Alltrim("*" + Alltrim(SB1->B1_COD) + "*")	//TAMANHO 16
			Else
				PA1_DESC	:= Alltrim("*" + PadL(nEmaster,4, "0") + Alltrim(SB1->B1_COD) + "*")
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
	
	cParams := cUseId //+ ";" //Usu�rio
	//cParams += SB1->B1_COD 	//Produto
	
Next

CallCrys("ICOMCR07",cParams,cOptions)

//Copia arquivo para a esta��o do usuario 
//lSucess := CpyT2S(GetSrvProfString ("ROOTPATH","") + "\Relatorios\" + _cNome + ".pdf",cPath,.T.)
Sleep(5000)

lSucess := CpyS2T("\Relatorios\" + _cNome + ".pdf",cPath,.T.)

if !lSucess
  Alert("N�o foi possivel copiar arquivo para a esta��o")
endif

If (FErase("\Relatorios\" + _cNome + ".pdf",,.F.) != 0)
	Alert("N�o foi poss�vel apagar arquivo: " + FError())
EndIf   

MsgInfo ("Processo Finalizado !!")

//oDlg:End()

cPath += _cNome

RestArea(aArea)

Return .T.



////////////////////////////////////////////////
//VALIDA PRODUTO
////////////////////////////////////////////////

user Function ICOMR07V(cProdVal)

local _aArea := getArea()
local _lRet  := .T.                
local n 	 := oMSNewGe1:NAT
                          
If !Empty(cProdVal)
	dbSelectArea("SB1")
	dbSetOrder(1)
	if !dbSeek(xFilial("SB1")+cProdVal)
		msgAlert("Produto n�o cadastrado. Favor verificar !")
		_lRet := .F.
	Else
		for x:=1 to len(oMSNewGe1:aCols)
			If oMSNewGe1:aCols[x][len(oMSNewGe1:aHeader)+1]
				loop
			endif
			if oMSNewGe1:aCols[x][1] == cProdVal 
				msgAlert("Produto j� indicado !!")
				_lRet := .F.
			endif
		next x

		If _lRet
			oMSNewGe1:aCols[n][2] := Posicione("SB1",1, xFilial("SB1")+cProdVal, "B1_DESC")
			oMSNewGe1:aCols[n][3] := Posicione("SB1",1, xFilial("SB1")+cProdVal, "B1__EMBMAS")
		EndIf
	endif
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
		msgAlert("Fornecedor n�o cadastrado !!")
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
		msgAlert("Empresa n�o cadastrado !!")
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
			msgAlert("CNPJ n�o cadastrado !!")
		EndIf
	else
		_lRet  := .T.			
	EndIf
	
	restarea(_aArea)
	
return _lRet
