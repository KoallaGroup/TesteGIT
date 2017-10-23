#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA12				 	| 	Maio de 2014                                        |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta os produtos comprados por cliente                                      |
|-----------------------------------------------------------------------------------------------|
*/

user Function ITMKA12()

Local aCampos  := {}
Local aAreaATU := GetArea()
Local aButtons := {}

Private cProDesc 	:= space(TAMSX3("B1_DESC")[1])
Private nQtde 		:= 0
Private nDesc 		:= 0
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1    	:= Nil
Private oDlgTMP    	:= Nil
Private aSize      	:= MsAdvSize(.T.)
Private aEdit      	:= {}
Private aRotina    	:= .F.
Private oFont14	   	:= tFont():New("Tahoma",,-11,,.t.)

If FUNNAME() == "TMKA271"
	Private nPosProd	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
	Private cMun		:= IIf(!Empty(M->UA_CLIENTE),Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_COD_MUN"),Space(TAMSX3("A1_COD_MUN")[1]))
	Private cEst		:= IIf(!Empty(M->UA_CLIENTE),Posicione("SA1",1,xFilial("SA1")+M->UA_CLIENTE+M->UA_LOJA,"A1_EST"),Space(TAMSX3("A1_EST")[1]))
	Private cProd		:= IIf(!Empty(acols[n][nPosProd]),acols[n][nPosProd],space(TAMSX3("UB_PRODUTO")[1]))
ElseIf FUNNAME() == "MATA410"
	Private nPosProd	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO" })
	Private cMun		:= IIf(!Empty(M->C5_CLIENTE),Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_COD_MUN"),Space(TAMSX3("A1_COD_MUN")[1]))
	Private cEst		:= IIf(!Empty(M->C5_CLIENTE),Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST"),Space(TAMSX3("A1_EST")[1]))
	Private cProd		:= IIf(!Empty(acols[n][nPosProd]),acols[n][nPosProd],space(TAMSX3("C6_PRODUTO")[1]))
Else
	Private cMun		:= Space(TAMSX3("A1_COD_MUN")[1])
	Private cEst		:= Space(TAMSX3("A1_EST")[1])
	Private cProd   	:= space(TAMSX3("B1_COD")[1])
EndIf

CriaHeader()

aObjects := {}

aInfo	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }

aPosObj	:= MsObjSize( ainfo, aObjects )

DEFINE MSDIALOG oDlgTMP TITLE "Consulta QTD Produtos" FROM aSize[7]+50, 400 TO aSize[6]-200,aSize[5] PIXEL
oDlgTMP:lMaximized := .F.

@ 6,005 Say "Produto :" SIZE 30,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,035 MsGet cProd Picture "@!" F3 "SB1LIK" Size 60,10 of oDlgTMP PIXEL FONT oFont14 VALID ValDesc(cProd)

@ 6,120 Say "Descrição :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,155 MsGet cProDesc Picture "@!" Size 250,10 of oDlgTMP PIXEL FONT oFont14 When .F.

@ 6,420 Say "UF :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,435 MsGet cEst Picture "@!" F3 "12" Size 15,10 of oDlgTMP PIXEL FONT oFont14 VALID ValUf(cEst,cMun)

@ 6,480 Say "Município :" SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,515 MsGet cMun F3 "CC2A12" Size 15,10 of oDlgTMP PIXEL FONT oFont14 VALID ValMun(cEst,cMun)

oGetTM1 := MsNewGetDados():New(30, 20, 200, 555,, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

If (FUNNAME() == "TMKA271" .or. FUNNAME() == "MATA410")
	CriaCols(cProd,cEst,cMun)
Else
	if (!Empty(cProd) .AND. !Empty(cMun))
		CriaCols(cProd,cEst,cMun)
	EndIf
EndIf

ACTIVATE MSDIALOG oDlgTMP CENTERED ON INIT EnchoiceBar(oDlgTMP,{||CriaCols(cProd,cEst,cMun)},{||oDlgTMP:End()},,aButtons)

RestArea(aAreaATU)

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()

aHeaderB     := {}
aCpoHeader   := {"UA_EMISSAO","A1_NOME","UA_CLIENTE","UA_LOJA","UB_QUANT" }

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
	Endif
Next _nElemHead

dbSelectArea("SX3")
dbSetOrder(1)

Return Nil


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaCols				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols(cProd,cEst,cMun)

Local nQtdCpo   := 0
Local nCols     := 0
Local nPosEmis  :=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_EMISSAO" })
Local nPosNome	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A1_NOME" })
Local nPosCli	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_CLIENTE" })
Local nPosLoja	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_LOJA" })
Local nPosQtd	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_QUANT" })

cProDesc := IIF(!Empty(cProd),Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),space(TAMSX3("B1_DESC")[1]))

oGetTM1:aCols := {}

nQtdCpo := Len(aHeaderB)
nn:=0

If(select("TRBSUB") > 0)
	TRBSUB->(DbCloseArea())
EndIf

_cQuery := "SELECT UB_PRODUTO, UB_QUANT, A1_NOME, "
_cQuery += "UA_CLIENTE, UA_LOJA, UA_EMISSAO "
_cQuery += "FROM " + RetSqlName("SUB") + " SUB "
_cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA ON UA_FILIAL = '" + xFilial("SUA") + "' AND UA_NUM = UB_NUM AND SUA.D_E_L_E_T_ = '' "
_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_FILIAL = '" + xFilial("SA1") + "' AND A1_COD = UA_CLIENTE AND A1_LOJA = UA_LOJA AND SA1.D_E_L_E_T_ = '' "
_cQuery += "WHERE SUB.D_E_L_E_T_ = '' "
_cQuery += "AND UA_OPER = '1' "
If !Empty(cProd)
	_cQuery += "AND UB_PRODUTO = '" + cProd + "' "
EndIf
If !Empty(cEst)
	_cQuery += "AND UA_ESTE = '" + cEst + "' "
EndIf
If !Empty(cMun)
	_cQuery += "AND A1_COD_MUN = '" + cMun + "' "
EndIf
_cQuery += "ORDER BY UA_EMISSAO "

_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias "TRBSUB"

DbSelectArea("TRBSUB")
DbGoTop()

while !TRBSUB->(eof())
	AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
	nn++
	
	oGetTM1:Acols[nn][nPosEmis]			:= STOD(TRBSUB->UA_EMISSAO)
	oGetTM1:Acols[nn][nPosNome]			:= TRBSUB->A1_NOME
	oGetTM1:Acols[nn][nPosCli]			:= TRBSUB->UA_CLIENTE
	oGetTM1:Acols[nn][nPosLoja]			:= TRBSUB->UA_LOJA
	oGetTM1:Acols[nn][nPosQtd]			:= TRBSUB->UB_QUANT
	oGetTM1:Acols[nn][Len(aHeaderB)+1] 	:= .F.
	
	TRBSUB->(DbSkip())
enddo

oGetTM1:nat:=len(oGetTM1:Acols)

TRBSUB->(dbCloseArea())

oGetTM1:Refresh()

return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValDesc				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validação do Produto														  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValDesc(cProd)

Local lOk := .T.

If !Empty(cProd)
	dbSelectArea("SB1")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SB1")+cProd))
		Alert("Produto Inexistente")
		cProd := space(TAMSX3("B1_COD")[1])
		cProDesc := ""
		lOk := .F.
	EndIf
EndIf

cProDesc := IIF(!Empty(cProd),Posicione("SB1",1,xFilial("SB1")+cProd,"B1_DESC"),space(TAMSX3("B1_DESC")[1]))

oGetTM1:Refresh()

Return lOk


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValUf				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validação do Estado														  	|
|-----------------------------------------------------------------------------------------------|
*/


Static Function ValUf(cEst,cMun)

Local lOk := .T.

If !Empty(cEst)
	dbSelectArea("SX5")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SX5")+"12"+cEst))
		Alert("Sigla do Estado Inexistente")
		cEst := space(TAMSX3("A1_EST")[1])
		lOk := .F.
	EndIf
EndIf

If (!Empty(cMun) .and. !Empty(cEst))
	dbSelectArea("CC2")
	dbSetOrder(1)
	If !(dbSeek(xFilial("CC2")+cEst+cMun))
		Alert("Código de Município Inexistente para este Estado")
		cMun := space(TAMSX3("A1_COD_MUN")[1])
		lOk := .F.
	EndIf
EndIf

oGetTM1:Refresh()

Return 	lOk

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValMun				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi                                             |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Validação do Município														  	|
|-----------------------------------------------------------------------------------------------|
*/


Static Function ValMun(cEst,cMun)

Local lOk := .T.

If !Empty(cMun)
	dbSelectArea("CC2")
	dbSetOrder(3)
	If !(dbSeek(xFilial("CC2")+cMun))
		Alert("Código de Município Inexistente")
		cMun := space(TAMSX3("A1_COD_MUN")[1])
		lOk := .F.
	EndIf
EndIf

If (!Empty(cMun) .and. !Empty(cEst))
	dbSelectArea("CC2")
	dbSetOrder(1)
	If !(dbSeek(xFilial("CC2")+cEst+cMun))
		Alert("Código de Município Inexistente para este Estado")
		cMun := space(TAMSX3("A1_COD_MUN")[1])
		lOk := .F.
	EndIf
EndIf

oGetTM1:Refresh()

Return 	lOk
