#include "protheus.ch"
#INCLUDE "topconn.ch"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IFATA28   ºAutor  ³Roberto Marques     º Data ³  12/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFATA28(xFL,xPed )

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
Local _aArea	   := GetArea()
Private cFL        := xFL
Private cFlD       := Space(80)
Private cCli       := Space(TamSx3("C5_CLIENTE")[1])
Private cLJ        := Space(TamSx3("C5_LOJACLI")[1])
Private cNReduz    := Space(TamSx3("A1_NREDUZ")[1])
Private cDt        := Space(TamSx3("C5_EMISSAO")[1])
Private cEndFat    := Space(100)
Private cCapa      := Space(TamSx3("C5_MENNOTA")[1])
Private cCapaD     := Space(TamSx3("C5_MENNOTA")[1])
Private cCorpo     := Space(TamSx3("C5_MENNOTA")[1])
Private cCorpoD    := Space(TamSx3("C5_MENNOTA")[1])
Private cMensNF    := Space(TamSx3("C5_MENNOTA")[1])
Private cEsp1      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
Private cEsp2      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
Private cEsp3      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
Private cEsp4      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
Private cEspD1     := Space(TamSx3("C5_ESPECI1")[1])
Private cEspD2     := Space(TamSx3("C5_ESPECI2")[1])
Private cEspD3     := Space(TamSx3("C5_ESPECI3")[1])
Private cEspD4     := Space(TamSx3("C5_ESPECI4")[1])
Private cQtd1      := Space(TamSx3("C5_VOLUME1")[1])
Private cQtd2      := Space(TamSx3("C5_VOLUME2")[1])
Private cQtd3      := Space(TamSx3("C5_VOLUME3")[1])
Private cQtd4      := Space(TamSx3("C5_VOLUME4")[1])
Private cFreteD    := Space(1)
Private cOrig      := Space(6)
Private cOrigD     := Space(80)
Private cPed       := Space(TamSx3("C5_NUM" )[1])
Private cPesoB     := Space(TamSx3("C5_PBRUTO" )[1])
Private cPesoL     := Space(TamSx3("C5_PESOL" )[1])
Private cQtd1      := Space(TamSx3("C5_VOLUME1" )[1])
Private cQtd2      := Space(TamSx3("C5_VOLUME2" )[1])
Private cQtd3      := Space(TamSx3("C5_VOLUME3" )[1])
Private cQtd4      := Space(TamSx3("C5_VOLUME4" )[1])
Private cStatus    := Space(TamSx3("C5__STATUS" )[1])
Private cStatusD   := Space(40)
Private cTPFrete   := Space(TamSx3("C5_TPFRETE" )[1])
Private cTransp    := Space(TamSx3("C5_TRANSP" )[1])
Private cTranspD   := Space(TamSx3("A4_NOME")[1] )
Private cTranspR   := Space(TamSx3("C5_TRANSP")[1] )
Private cTranspRD  := Space(TamSx3("A4_NOME")[1] )



/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10","oSay11")
SetPrvt("oSay17","oSay16","oSay15","oSay18","oSay19","oSay20","oSay21","oSay22","oSay23","oSay24","oSay25")
SetPrvt("oFL","oFlD","oOrig","oOrigD","oPed","oDt","oStatus","oStatusD","oCli","oLJ","oNReduz","oGet12")
SetPrvt("oTransp","oTranspD","oTranspR","oTranspRD","oTPFrete","oFreteD","oGrp1","oSay13","oSay14","oPesoL")
SetPrvt("oGrp2","oCapa","oCapaD","oGrp3","oGet33","oGet37","oQtd1","oEspD1","oEsp1","oQtd2","oEspD2")
SetPrvt("oQtd3","oEspD3","oEsp3","oQtd4","oEspD4","oEsp4","oGrp4","oCorpo","oCorpoD","oGrp5","oGet40")
SetPrvt("oBtnOK","oBtnSair")

VerPed(xFL,xPed)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlg1      := MSDialog():New( 088,174,554,1224,"Dados Adicionais",,,.F.,,,,,,.T.,,,.T. )
oSay1      := TSay():New( 012,048,{||"Filial.:"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay2      := TSay():New( 012,228,{||"Origem"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay3      := TSay():New( 028,048,{||"Pedido"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay4      := TSay():New( 028,124,{||"Data"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)
oSay5      := TSay():New( 028,220,{||"Status CAC"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 044,048,{||"Cliente"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay7      := TSay():New( 044,124,{||"Loja"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,012,008)
//oSay8      := TSay():New( 024,364,{||"Seu Pedido"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay9      := TSay():New( 060,004,{||"Endereço de Faturamento"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,064,008)
oSay10     := TSay():New( 076,028,{||"Transportadora"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay11     := TSay():New( 044,352,{||"Tipo Frete"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay12     := TSay():New( 092,016,{||"Transp.Redespacho"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay17     := TSay():New( 168,204,{||"Quantidade"} ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay16     := TSay():New( 168,052,{||"Descrição 1"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 168,016,{||"Cod.Especie"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay18     := TSay():New( 188,204,{||"Quantidade"} ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay19     := TSay():New( 192,052,{||"Descrição 2"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay20     := TSay():New( 192,016,{||"Cod.Especie"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay21     := TSay():New( 164,428,{||"Quantidade"} ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay22     := TSay():New( 168,272,{||"Descrição 3"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay23     := TSay():New( 168,240,{||"Cod.Especie"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay24     := TSay():New( 188,428,{||"Quantidade"} ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay25     := TSay():New( 192,272,{||"Descrição 4"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay26     := TSay():New( 192,240,{||"Cod.Especie"},oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oFL        := TGet():New( 012,068,{|u| If(PCount()>0,cFL:=u,cFL)},oDlg1,020,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFL",,)
oFlD       := TGet():New( 012,096,{|u| If(PCount()>0,cFlD:=u,cFlD)},oDlg1,104,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFlD",,)
oOrig      := TGet():New( 012,256,{|u| If(PCount()>0,cOrig:=u,cOrig)},oDlg1,024,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cOrig",,)
oOrigD     := TGet():New( 012,284,{|u| If(PCount()>0,cOrigD:=u,cOrigD)},oDlg1,064,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cOrigD",,)
oPed       := TGet():New( 028,068,{|u| If(PCount()>0,cPed:=u,cPed)},oDlg1,032,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cPed",,)
oDt        := TGet():New( 028,144,{|u| If(PCount()>0,cDt:=u,cDt)},oDlg1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cDt",,)
oStatus    := TGet():New( 028,256,{|u| If(PCount()>0,cStatus:=u,cStatus)},oDlg1,024,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cStatus",,)
oStatusD   := TGet():New( 028,284,{|u| If(PCount()>0,cStatusD:=u,cStatusD)},oDlg1,064,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cStatusD",,)
oCli       := TGet():New( 044,068,{|u| If(PCount()>0,cCli:=u,cCli)},oDlg1,048,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cCli",,)
oLJ        := TGet():New( 044,144,{|u| If(PCount()>0,cLJ:=u,cLJ)},oDlg1,024,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cLJ",,)
oNReduz    := TGet():New( 044,176,{|u| If(PCount()>0,cNReduz:=u,cNReduz)},oDlg1,172,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cNReduz",,)
//oGet12     := TGet():New( 024,400,,oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","",,)
oEndFat    := TGet():New( 060,068,{|u| If(PCount()>0,cEndFat:=u,cEndFat)},oDlg1,224,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cEndFat",,)
oTransp    := TGet():New( 076,068,{|u| If(PCount()>0,cTransp:=u,cTransp)},oDlg1,036,008,'@!',{||VldTransp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,cOrig != "FAT",.F.,"SA4LIK","cTransp",,)
oTranspD   := TGet():New( 076,112,{|u| If(PCount()>0,cTranspD:=u,cTranspD)},oDlg1,180,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cTranspD",,)
oTranspR   := TGet():New( 092,068,{|u| If(PCount()>0,cTranspR:=u,cTranspR)},oDlg1,036,008,'@!',{||VldRedesp()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,cOrig != "FAT",.F.,"SA4LIK","cTranspR",,)
oTranspRD  := TGet():New( 092,112,{|u| If(PCount()>0,cTranspRD:=u,cTranspRD)},oDlg1,180,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cTranspRD",,)
oTPFrete   := TGet():New( 044,380,{|u| If(PCount()>0,cTPFrete:=u,cTPFrete)},oDlg1,016,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cTPFrete",,)
oFreteD    := TGet():New( 044,400,{|u| If(PCount()>0,cFreteD:=u,cFreteD)},oDlg1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"","cFreteD",,)
oGrp1      := TGroup():New( 060,300,104,460,"Peso Total dos Itens",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay13     := TSay():New( 076,304,{||"Peso Líquido"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,048,008)
oSay14     := TSay():New( 076,388,{||"Peso Bruto"},oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oPesoL     := TGet():New( 084,304,{|u| If(PCount()>0,cPesoL:=u,cPesoL)},oGrp1,064,008,PesqPict("SF2","F2_PBRUTO"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesoL",,)
oPesoB     := TGet():New( 084,388,{|u| If(PCount()>0,cPesoB:=u,cPesoB)},oGrp1,064,008,PesqPict("SF2","F2_PBRUTO"),,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPesoB",,)

oGrp2      := TGroup():New( 108,028,132,460,"Texto Capa NF.",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCapa      := TGet():New( 116,032,{|u| If(PCount()>0,cCapa:=u,cCapa)},oGrp2,025,008  ,'@!',{||VldCapa()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z21","cCapa",,)
oCapaD     := TGet():New( 116,064,{|u| If(PCount()>0,cCapaD:=u,cCapaD)},oGrp2,356,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.t.,.F.,"","cCapaD",,)


oGrp4      := TGroup():New( 137,029,161,461,"Texto Corpo NF.",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCorpo     := TGet():New( 145,033,{|u| If(PCount()>0,cCorpo:=u,cCorpo)}  ,oGrp4,025,008,'@!',{||VldCorpo()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"Z21","cCorpo",,)
oCorpoD    := TGet():New( 145,065,{|u| If(PCount()>0,cCorpoD:=u,cCorpoD)},oGrp4,356,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.t.,"",,,.F.,.F.,,.t.,.F.,"","cCorpoD",,)


cEsp1 := Space(TamSx3("ZS_EMBALAG")[1])
oEsp1      := TGet():New( 176,016,{|u| If(PCount()>0,cEsp1:=u,cEsp1)}  ,oDlg1,025,008,'@R 99999',{||VldSZS1()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"	,"cEsp1"	,,)
oEspD1     := TGet():New( 176,052,{|u| If(PCount()>0,cEspD1:=u,cEspD1)},oDlg1,152,008,'@!'		 ,			    ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	,"cEspD1"	,,)
If Empty(cEspD1)
	oQtd1      := TGet():New( 176,204,{|u| If(PCount()>0,cQtd1:=u,cQtd1)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd1,"2")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""   	,"cQtd1"	,,)
Else
	oQtd1      := TGet():New( 176,204,{|u| If(PCount()>0,cQtd1:=u,cQtd1)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd1,"2")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   	,"cQtd1"	,,)
EndIf

cEsp2 := Space(TamSx3("ZS_EMBALAG")[1])
If Empty(cQtd1)
	oEsp2      := TGet():New( 200,016,{|u| If(PCount()>0,cEsp2:=u,cEsp2)}  ,oDlg1,030,008,'@R 99999',{||VldSZS2()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"SZS"		,"cEsp2"	,,)
Else
	oEsp2      := TGet():New( 200,016,{|u| If(PCount()>0,cEsp2:=u,cEsp2)}  ,oDlg1,030,008,'@R 99999',{||VldSZS2()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"		,"cEsp2"	,,)
EndIf
oEspD2     := TGet():New( 200,052,{|u| If(PCount()>0,cEspD2:=u,cEspD2)},oDlg1,152,008,'@!'		 ,			    ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""		,"cEspD2"	,,)
If Empty(cEspD2)
	oQtd2      := TGet():New( 200,204,{|u| If(PCount()>0,cQtd2:=u,cQtd2)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd2,"3")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""		,"cQtd2"	,,)
Else
	oQtd2      := TGet():New( 200,204,{|u| If(PCount()>0,cQtd2:=u,cQtd2)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd2,"3")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""		,"cQtd2"	,,)
EndIf

cEsp3 := Space(TamSx3("ZS_EMBALAG")[1])
If Empty(cQtd2)
	oEsp3      := TGet():New( 176,240,{|u| If(PCount()>0,cEsp3:=u,cEsp3)}  ,oDlg1,030,008,'@R 99999',{||VldSZS3()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"SZS"  	,"cEsp3"	,,)
Else
	oEsp3      := TGet():New( 176,240,{|u| If(PCount()>0,cEsp3:=u,cEsp3)}  ,oDlg1,030,008,'@R 99999',{||VldSZS3()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"  	,"cEsp3"	,,)
EndIf
oEspD3     := TGet():New( 176,276,{|u| If(PCount()>0,cEspD3:=u,cEspD3)},oDlg1,152,008,'@!'		 ,   		     ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""     	,"cEspD3" 	,,)
If Empty(cEspD3)
	oQtd3      := TGet():New( 176,428,{|u| If(PCount()>0,cQtd3:=u,cQtd3)}  ,oDlg1,028,008,'@E 99999' ,{||VldQtd(cQtd3,"4")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	  	,"cQtd3"	,,)
Else
	oQtd3      := TGet():New( 176,428,{|u| If(PCount()>0,cQtd3:=u,cQtd3)}  ,oDlg1,028,008,'@E 99999' ,{||VldQtd(cQtd3,"4")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""	 	,"cQtd3"	,,)
EndIf
     
cEsp4 := Space(TamSx3("ZS_EMBALAG")[1])
If Empty(cQtd3)
	oEsp4      := TGet():New( 200,240,{|u| If(PCount()>0,cEsp4:=u,cEsp4)}  ,oDlg1,030,008,'@R 99999',{||VldSZS4()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,"SZS"	,"cEsp4"	,,)
Else
	oEsp4      := TGet():New( 200,240,{|u| If(PCount()>0,cEsp4:=u,cEsp4)}  ,oDlg1,030,008,'@R 99999',{||VldSZS4()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"	,"cEsp4"	,,)
EndIf
oEspD4     := TGet():New( 200,276,{|u| If(PCount()>0,cEspD4:=u,cEspD4)},oDlg1,152,008,'@!'		 ,	             ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	 	,"cEspD4"	,,)
If Empty(cEspD4)
	oQtd4      := TGet():New( 200,428,{|u| If(PCount()>0,cQtd4:=u,cQtd4)}  ,oDlg1,028,008,'@E 99999',{||VldQtd(cQtd4,"1")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	 	,"cQtd4"	,,)
Else
	oQtd4      := TGet():New( 200,428,{|u| If(PCount()>0,cQtd4:=u,cQtd4)}  ,oDlg1,028,008,'@E 99999',{||VldQtd(cQtd4,"1")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""	 	,"cQtd4"	,,)
EndIf

oSayNF   := TSay():New( 218,016,{||"Observ Para NF"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oObsNF   := TGet():New( 215,065,{|u| If(PCount()>0,cMensNF:=u,cMensNF)},oDlg1,370,010,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.f.,.F.,"","cMensNF",,)

oBtnOK     := TButton():New( 176,468,"Confirmar",oDlg1,{||fGravar()}   ,044,012,,,,.T.,,"",,,,.F. )
oBtnSair   := TButton():New( 196,468,"Sair"     ,oDlg1,{||oDlg1:End() },044,012,,,,.T.,,"",,,,.F. )

oDlg1:Activate(,,,.T.)

Return

Static Function VerPed(cFL,cNUM)
DbSelectArea("SC5")
DbSetOrder(1)
If MsSeek(cFL+cNUM)
	cFL        := cFL
	cPed       := cNUM
	cFlD       := IIF(!Empty(cFL),Posicione("SM0",1,"01"+cFL,"M0_FILIAL"),space(TAMSX3("M0_FILIAL")[1]))
	cCli       := SC5->C5_CLIENTE
	cLJ        := SC5->C5_LOJACLI
	cNReduz    := Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_NREDUZ')
	cDt        := SC5->C5_EMISSAO
	cEndFat    := Posicione('SA1',1,xFilial('SA1')+SC5->C5_CLIENTE+SC5->C5_LOJACLI,'A1_ENDCOB')
	cCapa      := SC5->C5__TXTNF1
	cCapaD     := Posicione('Z21',1,xFilial('Z21')+SC5->C5__TXTNF1,'Z21_DESCRI')
	cCorpo     := SC5->C5__TXTNF2
	cCorpoD    := Posicione('Z21',1,xFilial('Z21')+SC5->C5__TXTNF2,'Z21_DESCRI')
	cEsp1      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
	cEsp2      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
	cEsp3      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
	cEsp4      := Space(TamSx3("ZS_EMBALAG")[1]) //Space(5)
	cEspD1     := SC5->C5_ESPECI1
	cEspD2     := SC5->C5_ESPECI2
	cEspD3     := SC5->C5_ESPECI3
	cEspD4     := SC5->C5_ESPECI4
	cQtd1      := SC5->C5_VOLUME1
	cQtd2      := SC5->C5_VOLUME2
	cQtd3      := SC5->C5_VOLUME3
	cQtd4      := SC5->C5_VOLUME4
	cMensNF    := SC5->C5_MENNOTA
	IF AllTrim(SC5->C5__NUMSUA)==""
		cOrig      := "FAT"
		cOrigD	   := "FATURAMENTO"
	Else
		cOrig      := "CAL"
		cOrigD	   := "CALLCENTER"
	Endif
	
	cTPFrete   := SC5->C5_TPFRETE
	IF SC5->C5_TPFRETE =='C'
		cFreteD     := 'CIF'
	ELSEIF SC5->C5_TPFRETE =='F'
		cFreteD     := 'FOB'
	ELSEIF SC5->C5_TPFRETE =='T'
		cFreteD     := 'Por conta terceiros'
	ELSEIF SC5->C5_TPFRETE =='S'
		cFreteD     := 'Sem frete'
	ENDIF
	
	cPesoB     := SC5->C5_PBRUTO
	cPesoL     := SC5->C5_PESOL
	cStatus    := SC5->C5__STATUS
	cStatusD   := POSICIONE("SZM",1,XFILIAL("SZM")+SC5->C5__STATUS,"ZM_DESC")
	
	cTransp    := SC5->C5_TRANSP
	cTranspD   := posicione("SA4",1, xFilial("SA4")+SC5->C5_TRANSP, "A4_NOME")
	
	cTranspR   := SC5->C5_REDESP
	cTranspRD  := posicione("SA4",1, xFilial("SA4")+cTranspR, "A4_NOME")
EndIf

Return

Static Function VldCapa()
Local lRet := .T.

DbSelectArea("Z21")
DbSetOrder(1)
IF Alltrim(cCapa) <> ""
	If MsSeek(xFilial("Z21")+cCapa)
		cCapaD     := Z21->Z21_DESCRI
	Else
		Alert("Favor verifique o Codigo.")
		lRet := .F.
	Endif
Endif

Return lRet

Static Function VldCorpo()
Local lRet := .T.

DbSelectArea("Z21")
DbSetOrder(1)
IF Alltrim(cCorpo) <> ""
	If MsSeek(xFilial("Z21")+cCorpo)
		cCorpoD     := Z21->Z21_DESCRI
	Else
		Alert("Favor verifique o Codigo.")
		lRet := .F.
	Endif
Endif

Return lRet

Static Function VldSZS1()
lRet := .T.
DbSelectArea("SZS")
DbSetOrder(1)
IF Alltrim(cEsp1) <> ""
	If MsSeek(xFilial("SZS")+cEsp1)
		cEspD1     := SZS->ZS_DESCRIC
		oQtd1      := TGet():New( 176,204,{|u| If(PCount()>0,cQtd1:=u,cQtd1)}  ,oDlg1,028,008,'@R 9999',{||VldQtd(cQtd1,"2")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""   	,"cQtd1"	,,)
	Else
		Alert("Favor verifique o Codigo da Embalagem.")
		lRet := .F.
	Endif
Endif

If Empty(Alltrim(cEsp1))
	cEspD1  := ""
	cQtd1	:= 0
	oQtd1	:= TGet():New( 176,204,{|u| If(PCount()>0,cQtd1:=u,cQtd1)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd1,"2")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""   	,"cQtd1"	,,)
Else
	oQtd1:Setfocus()
EndIf



Return lRet

Static Function VldSZS2()
lRet := .T.
DbSelectArea("SZS")
DbSetOrder(1)
IF Alltrim(cEsp2) <> ""
	If MsSeek(xFilial("SZS")+cEsp2)
		cEspD2     := SZS->ZS_DESCRIC
		oQtd2      := TGet():New( 200,204,{|u| If(PCount()>0,cQtd2:=u,cQtd2)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd2,"3")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""		,"cQtd2"	,,)
	Else
		Alert("Favor verifique o Codigo da Embalagem.")
		lRet := .F.
	Endif
Endif

If Empty(Alltrim(cEsp2))
	cEspD2  := ""
	cQtd2	:= 0
	oQtd2   := TGet():New( 200,204,{|u| If(PCount()>0,cQtd2:=u,cQtd2)}  ,oDlg1,028,008,'@R 99999',{||VldQtd(cQtd2,"3")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""		,"cQtd2"	,,)
Else
	oQtd2:Setfocus()
EndIf

Return lRet

Static Function VldSZS3()
lRet := .T.
DbSelectArea("SZS")
DbSetOrder(1)
IF Alltrim(cEsp3) <> ""
	If MsSeek(xFilial("SZS")+cEsp3)
		cEspD3     := SZS->ZS_DESCRIC
		oQtd3      := TGet():New( 176,428,{|u| If(PCount()>0,cQtd3:=u,cQtd3)}  ,oDlg1,028,008,'@E 99999' ,{||VldQtd(cQtd3,"4")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""	  	,"cQtd3"	,,)
	Else
		Alert("Favor verifique o Codigo da Embalagem.")
		lRet := .F.
	Endif
Endif

If Empty(Alltrim(cEsp3))
	cEspD3  := ""
	cQtd3	:= 0
	oQtd3   := TGet():New( 176,428,{|u| If(PCount()>0,cQtd3:=u,cQtd3)}  ,oDlg1,028,008,'@E 99999' ,{||VldQtd(cQtd3,"4")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	  	,"cQtd3"	,,)
Else
	oQtd3:Setfocus()
EndIf

Return lRet


Static Function VldSZS4()
lRet := .T.
DbSelectArea("SZS")
DbSetOrder(1)
IF Alltrim(cEsp4) <> ""
	If MsSeek(xFilial("SZS")+cEsp4)
		cEspD4     := SZS->ZS_DESCRIC
		oQtd4      := TGet():New( 200,428,{|u| If(PCount()>0,cQtd4:=u,cQtd4)}  ,oDlg1,028,008,'@E 99999',{||VldQtd(cQtd4,"5")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,""	 	,"cQtd4"	,,)
	Else
		Alert("Favor verifique o Codigo da Embalagem.")
		lRet := .F.
	Endif
Endif

If Empty(Alltrim(cEsp4))
	cEspD4  := ""
	cQtd4	:= 0
	oQtd4   := TGet():New( 200,428,{|u| If(PCount()>0,cQtd4:=u,cQtd4)}  ,oDlg1,028,008,'@E 99999',{||VldQtd(cQtd4,"5")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.T.,.F.,""	 	,"cQtd4"	,,)
Else
	oQtd4:Setfocus()
EndIf

Return lRet

Static Function fGravar()

if cQtd1 > 0 .AND. AllTrim(cEsp1)==""
	Alert("Favor Infirmar o Cod. da Especie do volume 1.")
	Return .f.
Endif
if cQtd2 > 0 .AND. AllTrim(cEsp2)==""
	Alert("Favor Infirmar o Cod. da Especie do volume 2.")
	Return .f.
Endif
if cQtd3 > 0 .AND. AllTrim(cEsp3)==""
	Alert("Favor Infirmar o Cod. da Especie do volume 3.")
	Return .f.
Endif
if cQtd4 > 0 .AND. AllTrim(cEsp4)==""
	Alert("Favor Infirmar o Cod. da Especie do volume 4.")
	Return .f.
Endif
//- Peso bruto deve ser maior ou igual ao liquido
//- Peso Liquido deve ser maior ou igual ao bruto

IF cPesoL > cPesoB
	Alert("Favor verifique, o Peso Liquido deve ser menor ou igual ao Peso Bruto. ")
	Return .f.
Endif
IF cPesoB < cPesoL
	Alert("Favor verifique, o Peso Bruto de ser maior ou igual ao Peso Liquido. ")
	Return .f.
Endif

if cQtd1 < 0
	Alert("Favor Quantidade de Volume 1 deve ser maior ou igual que zero.")
	Return .f.
Endif
if cQtd2 < 0
	Alert("Favor Quantidade de Volume 2 deve ser maior ou igual que zero.")
	Return .f.
Endif
if cQtd3 < 0
	Alert("Favor Quantidade de Volume 3 deve ser maior ou igual que zero.")
	Return .f.
Endif
if cQtd4 < 0
	Alert("Favor Quantidade de Volume 4 deve ser maior ou igual que zero.")
	Return .f.
Endif

if msgYesNo("Deseja fazer as alterações no pedido ?","Confirme")
	If Reclock("SC5",.f.)
		SC5->C5_PBRUTO	:= cPesoB
		SC5->C5_PESOL	:= cPesoL
		SC5->C5_ESPECI1 := cEspD1
		SC5->C5_ESPECI2	:= cEspD2
		SC5->C5_ESPECI3	:= cEspD3
		SC5->C5_ESPECI4 := cEspD4
		SC5->C5_VOLUME1	:= cQtd1
		SC5->C5_VOLUME2	:= cQtd2
		SC5->C5_VOLUME3	:= cQtd3
		SC5->C5_VOLUME4	:= cQtd4
		SC5->C5__TXTNF1 := cCapa
		SC5->C5__TXTNF2 := cCorpo
		SC5->C5_MENNOTA := cMensNF
		If cOrig == "FAT"
			SC5->C5_TRANSP := cTransp
			SC5->C5_REDESP := cTranspR
		EndIf
		MsUnlock()
		MsgInfo("Gravado com sucesso....")
	Else
		MsgAlert("Não foi possível atualizar as informações do pedido...tente novamente.")
	EndIf
	oDlg1:End()
Endif

Return .t.


Static Function VldQtd(nQtd,nPos)

Local lRet := .T.

If (!Empty(nQtd) .or. nQtd == 0) .and. valtype(nQtd) == "N"
	If nQtd < 1
		Alert("Quantidade não pode ser menor ou igual a zero.")
		
		Do Case
			Case nPos == "2"
				oEsp2:Setfocus()
			Case nPos == "3"
				oEsp3:Setfocus()
			Case nPos == "4"
				oEsp4:Setfocus()
		EndCase
			
		lRet := .F.
	Else
		Do Case
			Case nPos == "2"
				oEsp2 := TGet():New( 200,016,{|u| If(PCount()>0,cEsp2:=u,cEsp2)}  ,oDlg1,030,008,'@R 99999',{||VldSZS2()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"		,"cEsp2"	,,)
				oEsp2:Setfocus()
			Case nPos == "3"
				oEsp3 := TGet():New( 176,240,{|u| If(PCount()>0,cEsp3:=u,cEsp3)}  ,oDlg1,030,008,'@R 99999',{||VldSZS3()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"  	,"cEsp3"	,,)
				oEsp3:Setfocus()
			Case nPos == "4"
				oEsp4 := TGet():New( 200,240,{|u| If(PCount()>0,cEsp4:=u,cEsp4)}  ,oDlg1,030,008,'@R 99999',{||VldSZS4()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZS"	,"cEsp4"	,,)
				oEsp4:Setfocus()
		EndCase
	Endif
EndIf
	
Return lRet
                                             	


Static Function VldTransp()

If Empty(cTransp)
	MsgStop("A transportadora não pode estar vazia","ATENCAO")
	Return .f.
EndIf

DbSelectArea("SA4")
DbSetOrder(1)
If !DbSeek(xFilial("SA4") + cTransp)
	MsgStop("A transportadora informada não cadastrada","ATENCAO")
	Return .f.
EndIf

If cTransp == cTranspR
	MsgStop("A transportadora e o Redespacho não podem ser iguais.","ATENCAO")
	Return .f.
EndIf

cTranspD := SA4->A4_NOME
Return .t.


Static Function VldRedesp()

DbSelectArea("SA4")
DbSetOrder(1)
If !DbSeek(xFilial("SA4") + cTranspR) .And. !Empty(cTranspR)
	MsgStop("A transportadora informada não cadastrada","ATENCAO")
	Return .f.
EndIf

If cTransp == cTranspR
	MsgStop("A transportadora e o Redespacho não podem ser iguais.","ATENCAO")
	Return .f.
EndIf

cTranspRD := SA4->A4_NOME
Return .t.