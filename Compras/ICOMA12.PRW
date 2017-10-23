#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ICOMA12   ºAutor  ³Roberto Marques	 º Data ³  10/10/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Geração de Pedido                                          º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ICOMA12(_ccodfor,_cforloj,_ddat01I,_ddat01F,_ddat02I,_ddat02F)
Private _lLimpa := .t.
Default _ccodfor := Space(TamSX3("A2_COD")[1])
Default _cforloj := Space(TamSX3("A2_LOJA")[1])
Default _ddat01I := CTOD("  /  /  ")
Default _ddat01F := CTOD("  /  /  ")
Default _ddat02I := CTOD("  /  /  ")
Default _ddat02F := CTOD("  /  /  ")

dbSelectArea("SZ1")
dbSetOrder(1)
If !DbSeek(xFilial("SZ1")+__cUserId)
	MsgStop("Usuário não cadastrado em um segmento. Favor contatar o departamento de TI","ATENCAO")
	Return
EndIf

While _lLimpa
	ICOMA12A(_ccodfor,_cforloj,_ddat01I,_ddat01F,_ddat02I,_ddat02F)
EndDo

Return


Static Function ICOMA12A(_ccodfor,_cforloj,_ddat01I,_ddat01F,_ddat02I,_ddat02F)

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de cVariable dos componentes                                 ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
local _aArea	:= getArea(), _cSegto := "0", _cFilSA2 := ""
Private cFL        := SM0->M0_CODFIL, _cGerPed := _cFilPed := ""
Private cLcDesc    := SM0->M0_FILIAL
Private cComp      := Posicione("SY1",3,xFilial("SY1") + __cUserId,"Y1_COD")
Private cComDesc   := SY1->Y1_NOME
Private cForn      := Space(TamSX3("A2_COD")[1])
Private cLJ        := Space(TamSX3("A2_LOJA")[1])
Private cRazao     := Space(TamSX3("A2_NOME")[1])
Private cEntrega   := 0
Private cCodEnd    := Space(4)
Private cTPEnd     := Space(3)
Private cEnd       := Space(TamSX3("A2_END")[1])
Private cEndNum    := Space(6)
Private cSubGrp    := Space(6)
Private cSubDesc   := Space(100)
Private cGrupo     := Space(6)
Private cGrpDesc   := Space(1)
Private cProced    := Space(3)
Private cPlano     := Space(TamSX3("E4_COND")[1])
Private cPlaDesc   := Space(TamSX3("E4_DESCRI")[1])
Private cAna11     := Ctod("  /  /  ")
Private cAna12     := Ctod("  /  /  ")
Private cAna21     := Ctod("  /  /  ")
Private cAna22     := Ctod("  /  /  ")
Private cContato   := Space(1)
//Private cEntrega   := Space(1)
Private cProced    := Space(3)
Private cDetPro	   := Space(300)
Private cOBS	   := Space(250)
Private lCBForn    := .F.
Private lCBNome    := .F.
Private lCBProd    := .F.
Private nOpc       := 1
Private aButtons   := {}
Private oGetTM1	   := nil
Private aHeader1   := {}
Private aCols	   := {}
Private aEdit	:= {}
Private oLJ

If Empty(cComp)
	Help( Nil, Nil, "CADCOMP", Nil, "Acesso negado. Usuario não está cadastrado como comprador.", 1, 0 )
	_lLimpa := .f.
	Return
EndIf

dbSelectArea("DA1")

cForn 	:= _ccodfor
cLJ   	:= _cforloj
cRazao	:= Posicione("SA2",1,XFILIAL("SA2")+cForn+cLJ,"A2_NOME")
cEnd	:= Posicione("SA2",1,XFILIAL("SA2")+cForn+cLJ,"A2_END")
cEndNum	:= Posicione("SA2",1,XFILIAL("SA2")+cForn+cLJ,"A2_NR_END")
cContato:= Posicione("SA2",1,xFilial("SA2")+cForn+cLJ,"A2_CONTATO")
IF type("M->CCONDICAO") != "U" .And.  M->CCONDICAO <> ""
	cPlano   := M->CCONDICAO
	cPlaDesc := Posicione("SE4",1,xFilial("SE4")+cPlano,"E4_DESCRI")
Endif

cGrupo 	 := Posicione("SAD",1,xFilial("SAD")+cForn+cLJ,"AD_GRUPO")
cGRPDESC := Posicione("SAD",1,xFilial("SAD")+cForn+cLJ,"AD_NOMGRUP")

cAna11  := _ddat01I
cAna12  := _ddat01F
cAna21  := _ddat02I
cAna22  := _ddat02F

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

dbSelectArea("SZ1")
dbSetOrder(1)
if dbSeek(xFilial("SZ1")+__cUserId)
	_cSegto := SZ1->Z1_SEGISP
else
	_cSegto := '0'
endif

if _cSegto <> '0'
	_cFilSA2 := ' SA2->A2__SEGISP == "' + _cSegto + '" .Or. Alltrim(SA2->A2__SEGISP) == "0" .Or. Empty(SA2->A2__SEGISP) '
	DbSelectArea("SA2")
	Set Filter To &_cFilSA2
endif

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlg1","oGrpSel","oSay12","oSay11","oSay10","oSay9","oSay8","oSay7","oSay6","oSay5","oSay4")
SetPrvt("oSay2","oSay1","oContato","oPlaDesc","oPlano","oAna22","oAna21","oAna12","oAna11","oGrpDesc")
SetPrvt("oProced","oSubDesc","oSubGrp","oEndNum","oEnd","oTPEnd","oCodEnd","oEntrega","oRazao","oForn")
SetPrvt("oComp","oLcDesc","oLocal","oGrp1","oBtnObs","oBtnGerar","oBtnPrn","oBtnPed","oGrp2","oCBProd")
SetPrvt("oCBNome","oBtnPro","oDetPro","oButton")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
DEFINE MSDIALOG oDlg1 TITLE "Geração Pedidos" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
oGrpSel    := TGroup():New( 004,004,135,396,"Seleção",oDlg1,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay12     := TSay():New( 096,260,{||"Contato"}				,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oSay11     := TSay():New( 096,008,{||"Plano de Pagamento"}	,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay10     := TSay():New( 084,230,{||"Análise Vendas (2)"}	,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay9      := TSay():New( 084,008,{||"Análise Vendas (1)"}	,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay8      := TSay():New( 072,328,{||"Procedência"}			,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 072,008,{||"Sub-Grupo"}			,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay6      := TSay():New( 060,008,{||"Endereço"}			,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay5      := TSay():New( 048,324,{||"Dias Entrega"}		,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay4      := TSay():New( 048,008,{||"Fornecedor"}			,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay3      := TSay():New( 036,008,{||"Grupo Cotação"}		,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oSay2      := TSay():New( 024,008,{||"Comprador"}			,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay1      := TSay():New( 012,008,{||"Filial"}				,oGrpSel,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,016,008)

oLocal     := TGet():New( 012,064,{|u| If(PCount()>0,cFL:=u,cFL)}			,oGrpSel,024,008,'@!',{||fPsqFL()}  ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"XM0","cFL",,)
oLcDesc    := TGet():New( 012,092,{|u| If(PCount()>0,cLcDesc:=u,cLcDesc)}	,oGrpSel,192,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLcDesc",,)
oComp      := TGet():New( 024,064,{|u| If(PCount()>0,cComp:=u,cComp)}		,oGrpSel,044,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SY1","cComp",,)
oComDesc   := TGet():New( 024,112,{|u| If(PCount()>0,cComDesc:=u,cComDesc)}	,oGrpSel,172,008,'@!',{||fPsqSY1()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cComDesc",,)

oGrupo     := TGet():New( 036,064,{|u| If(PCount()>0,cGrupo:=u,cGrupo)}		,oGrpSel,044,008,'@!',{||Vazio() .Or. fPsqZX5()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"ZX5COM","cGrupo",,)
oGrpDesc   := TGet():New( 036,112,{|u| If(PCount()>0,cGrpDesc:=u,cGrpDesc)}	,oGrpSel,172,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGrpDesc",,)

oForn      := TGet():New( 048,064,{|u| If(PCount()>0,cForn:=u,cForn)}		,oGrpSel,044,008,'@!'		,{||fPsqSA2()}	 ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SA2","cForn",,)
oLJ		   := TGet():New( 048,112,{|u| If(PCount()>0,cLJ:=u,cLJ)}			,oGrpSel,030,008,'@!'		,{||fPsqSA2("L")},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cLJ",,)
oRazao     := TGet():New( 048,145,{|u| If(PCount()>0,cRazao:=u,cRazao)}		,oGrpSel,172,008,'@!'		,				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cRazao",,)
oEntrega   := TGet():New( 048,360,{|u| If(PCount()>0,cEntrega:=u,cEntrega)}	,oGrpSel,020,008,'@R 999'	,				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEntrega",,)

//	oCodEnd    := TGet():New( 048,064,{|u| If(PCount()>0,cCodEnd:=u,cCodEnd)}	,oGrpSel,020,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodEnd",,)
//	oTPEnd     := TGet():New( 048,088,{|u| If(PCount()>0,cTPEnd:=u,cTPEnd)}		,oGrpSel,020,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTPEnd",,)
oEnd       := TGet():New( 060,064,{|u| If(PCount()>0,cEnd:=u,cEnd)}			,oGrpSel,212,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEnd",,)
oEndNum    := TGet():New( 060,288,{|u| If(PCount()>0,cEndNum:=u,cEndNum)}	,oGrpSel,036,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cEndNum",,)
oSubGrp    := TGet():New( 072,064,{|u| If(PCount()>0,cSubGrp:=u,cSubGrp)}	,oGrpSel,044,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ4","cSubGrp",,)
oSubDesc   := TGet():New( 072,112,{|u| If(PCount()>0,cSubDesc:=u,cSubDesc)}	,oGrpSel,172,008,'@!',{||fPsqSZ4()}	,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cSubDesc",,)
oProced    := TGet():New( 072,360,{|u| If(PCount()>0,cProced:=u,cProced)}	,oGrpSel,020,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cProced",,)
//oGrupo     := TGet():New( 072,064,{|u| If(PCount()>0,cGrupo:=u,cGrupo)}		,oGrpSel,024,008,'@!',{||fPsqSAJ()} ,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SAJ","cGrupo",,)
//oGrpDesc   := TGet():New( 072,092,{|u| If(PCount()>0,cGrpDesc:=u,cGrpDesc)}	,oGrpSel,232,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGrpDesc",,)
oAna11     := TGet():New( 084,064,{|u| If(PCount()>0,cAna11:=u,cAna11)}		,oGrpSel,040,008,'@D',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAna11",,)
oAna12     := TGet():New( 084,112,{|u| If(PCount()>0,cAna12:=u,cAna12)}		,oGrpSel,040,008,'@D',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAna12",,)
oAna21     := TGet():New( 084,284,{|u| If(PCount()>0,cAna21:=u,cAna21)}		,oGrpSel,040,008,'@D',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAna21",,)
oAna22     := TGet():New( 084,340,{|u| If(PCount()>0,cAna22:=u,cAna22)}		,oGrpSel,040,008,'@D',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cAna22",,)
oPlano     := TGet():New( 096,064,{|u| If(PCount()>0,cPlano:=u,cPlano)}		,oGrpSel,024,008,'@!',{||fPsqSE4()}	,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SE4","cPlano",,)
oPlaDesc   := TGet():New( 096,092,{|u| If(PCount()>0,cPlaDesc:=u,cPlaDesc)}	,oGrpSel,140,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPlaDesc",,)
oContato   := TGet():New( 096,284,{|u| If(PCount()>0,cContato:=u,cContato)}	,oGrpSel,096,008,'@!',				,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cContato",,)
oGrp1      := TGroup():New( 110,012,130,240,"",oGrpSel,CLR_BLACK,CLR_WHITE,.T.,.F. )
oBtnObs    := TButton():New( 114,016,"Observação"		,oDlg1,{||fObs() }		,052,012,,,,.T.,,"",,,,.F. )
oBtnGerar  := TButton():New( 114,072,"Gerar Pedido"		,oDlg1,{||Processa({|| fGeraPed() },"Aguarde! Processando...",,.T.)}	,052,012,,,,.T.,,"",,,,.F. )
oBtnPrn    := TButton():New( 114,128,"Imprimir Pedido"	,oDlg1,{||U_ICOMR09(_cGerPed,_cFilPed)},052,012,,,,.T.,,"",,,,.F. )
oBtnPed    := TButton():New( 114,184,"Novo Pedido"		,oDlg1,{||_lLimpa := .t.,oDlg1:End()},052,012,,,,.T.,,"",,,,.F. )
oBtnPro    := TButton():New( 114,444,"Processar"		,oDlg1,{||fPesq()},052,012,,,,.T.,,"",,,,.F. )
oGrp2      := TGroup():New( 108,244,130,392,"Ordenar Por:",oGrpSel,CLR_BLACK,CLR_WHITE,.T.,.F. )
oCBProd    := TCheckBox():New( 116,248,"Produto Isapa"	,{|u| If(PCount()>0,lCBProd:=u,lCBProd)}	,oGrp2,044,008,,{|| fOrder() },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBForn    := TCheckBox():New( 116,296,"Fornecedor"		,{|u| If(PCount()>0,lCBForn:=u,lCBForn)}	,oGrp2,048,008,,{|| fOrder() },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )
oCBNome    := TCheckBox():New( 116,352,"Nome"			,{|u| If(PCount()>0,lCBNome:=u,lCBNome)}	,oGrp2,036,008,,{|| fOrder() },,,CLR_BLACK,CLR_WHITE,,.T.,"",, )

lOk := .F.

oSay1      := TSay():New( 235,008,{||"Descrição.:"}						 ,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,044,008)
oDetPro    := TGet():New( 235,064,{|u| If(PCount()>0,cDetPro:=u,cDetPro)},oDlg1,376,026,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDetPro",,)

montaAcols()

_cGds := GD_INSERT + GD_UPDATE + GD_DELETE

oGetTM1 := MsNewGetDados():New(138, 0, 228, 650, _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , ,, oDlg1, aHeader1, aCols)
oGetTM1:bChange := {|| u_ICOMA12P() }
oGetTM1:Refresh()

@ 240,500 Button oButton PROMPT "Fechar"  	 SIZE 40,15   OF oDlg1 PIXEL ACTION {|| _lLimpa := .f., oDlg1:End() }

ACTIVATE MSDIALOG oDlg1 CENTERED

restArea(_aArea)
Return

Static Function fPsqSA2(_cOri)
Local iRet := .T.
Default _cOri := ""
dbSelectArea("SA2")
dbSetOrder(1)
If dbSeek(xFilial("SA2")+cForn + IIF(Empty(_cOri),"",cLJ) )
	cLJ		:= SA2->A2_LOJA
	cRazao	:= SA2->A2_NOME
	cEnd	:= SA2->A2_END
	cEndNum	:= SA2->A2_NR_END
	cContato:= SA2->A2_CONTATO
ElseIf !Empty(cForn)
	Alert("Fornecedor não encontrado....,verifique.")
	iRet:= .F.
Endif
//cEntrega := ""
//cCodEnd  := ""
//cTPEnd   := ""
//cEndNum

Return(iRet)


Static Function fPsqZX5()
Local _cFil := ""
cGrpDesc := Posicione("ZX5",1,xFilial("ZX5") + "  000001" + cGrupo,"ZX5_DSCITE")
oGrpDesc:Refresh()

If Empty(cGrpDesc)
	MsgStop("Grupo de cotação não cadastrado")
	Return .f.
Else
	DbSelectArea("Z02")
	_cFil := "Alltrim(Z02_GRUPO) == '" + Alltrim(cGrupo) + "' "
	Set Filter To &_cFil
EndIf
Return

Static Function fPsqSZ4()
cSubDesc  := Posicione("SZ4",1,xFilial("SZ4")+cSubGrp,"Z4_DESC")
oSubDesc:Refresh()
Return
Static Function fPsqSY1()
cComDesc := Posicione("SY1",1,xFilial("SY1")+cComp,"Y1_NOME")
oComDesc:Refresh()
Return

Static Function fPsqSE4()
Local _lRet := .t.
cPlaDesc := Posicione("SE4",1,xFilial("SE4")+cPlano,"E4_DESCRI")
oPlaDesc:Refresh()
_lRet := U_IGENG01("ICOMA12")
Return _lRet


Static Function fPsqFL()

Local aSM0 		:= FWLoadSM0()

For x:=1 to Len(aSM0)
	If cFL == aSM0[x][2]
		cLcDesc := aSM0[x][7]
		Exit
	EndIf
Next

/*
IF SELECT("TSZE") > 0
dbSelectArea("TSZE")
TSZE->(dbCloseArea())
Endif

mSQL := "SELECT ZE_FILIAL FROM SZE010 WHERE  D_E_L_E_T_ <>'*' "
mSQL += "AND ZE_CODIGO='"+SM0->M0_CODIGO+"' AND ZE_CODFIL='"+cFL+"'"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TSZE",.F.,.T.)
TSZE->( DbGoTop() )
If TSZE->(!Eof())
cLcDesc := TSZE->ZE_FILIAL

Endif
TSZE->(dbCloseArea())
*/

Return


Static Function montaAcols()

aEdit	:= {"QUANT","VLRNF"}

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("C7_PRODUTO")
	aadd(aHeader1, { Trim(SX3->X3_Titulo),;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     ,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when })
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("A5_CODPRF")
	aadd(aHeader1, {Trim(SX3->X3_Titulo) ,;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("B1_DESC")
	aadd(aHeader1, {Trim(SX3->X3_Titulo) ,;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("B1_UM")
	aadd(aHeader1, {"UV" ,;
	"UV"       			,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("A5__UNFOR")
	aadd(aHeader1, {"UC" ,;
	"UC"       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("UB__CXMAST")
	aadd(aHeader1, {Trim(SX3->X3_Titulo) ,;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("AIB_PRCCOM")
	aadd(aHeader1, {"Preço Tab." ,;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("D1_VUNIT")
	aadd(aHeader1, {"Preço NF." ,;
	"VLRNF"       		,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("C7_QUANT")
	aadd(aHeader1, {"Comprar" 			,;
	"QUANT"       		,;
	"@E 9,999,999"      ,;
	SX3->X3_Tamanho     ,;
	0	     			,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif



return

User Function ICOMA12P()
Local nPosProd  :=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "C7_PRODUTO" 	})
cDetPro := Posicione("SB1",1,xFilial("SB1")+oGetTM1:aCols[oGetTM1:nAt][nPosProd],"B1__DESCP")
oDetPro:Refresh()

Return(.t.)


Static Function fPesq()
Local nPosProd  :=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "C7_PRODUTO" 	})
Local nPosPRF	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "A5_CODPRF" 	})
Local nPosDESC	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "B1_DESC" 	})
Local nPosUV	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UV" 	})
Local nPosUC	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UC" 	})
Local nPosQE	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UB__CXMAST" 	})
Local nPosVCOM	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "AIB_PRCCOM" 	})
Local nPosNF	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "VLRNF" 	})
Local nPosQUANT :=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "QUANT" 	})
Local _nLin
Local mSQL := ""
Local nValor := 0
Local nQtdCpo   := 0
Local nCols     := 0  
Local nValNf    := 0

oGetTM1:aCols := {}
nQtdCpo := Len(aHeader1)
nn:=0


IF SELECT("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
Endif

//mSQL := "SELECT A5_PRODUTO,B1_DESC,A5_CODPRF,A5_NOMPROD,B1_UM,A5__UNFOR,B1__EMBMAS,AIB_PRCCOM,A5_FORNECE,MAX(D1_VUNIT)VLRNF,B1__DESCP,AIB__CTFIM "
mSQL := "SELECT MAX(SD1.R_E_C_N_O_) AS RECSD1, A5_PRODUTO,B1_DESC,A5_CODPRF,A5_NOMPROD,B1_UM,A5__UNFOR,B1__EMBMAS,AIB_PRCCOM,A5_FORNECE,B1__DESCP,AIB__CTFIM "
mSQL += " FROM "+RetSqlName("SB1")+" SB1 "
mSQL += " LEFT JOIN "+RetSqlName("SA5")+" SA5 ON B1_COD=A5_PRODUTO AND SA5.A5_FILIAL<>'*' "
mSQL += " AND SB1.D_E_L_E_T_<>'*' AND SA5.D_E_L_E_T_<>'*' "
mSQL += " AND SB1.B1_FILIAL='"+xFILIAL('SB1')+"' "
mSQL += " LEFT JOIN "+RetSqlName("AIB")+" AIB ON A5_FORNECE=AIB_CODFOR AND AIB_LOJFOR='" + cLj + "' "
mSQL += " AND AIB_FILIAL='" + cFL + "' AND AIB.D_E_L_E_T_<>'*' AND SA5.A5_PRODUTO=AIB_CODPRO "
mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+cFL+"' AND SD1.D_E_L_E_T_ <>'*' AND D1_FORNECE='"+cForn+"' AND D1_LOJA = '" + cLJ + "' " 
//		mSQL += " WHERE A5_PRODUTO='"+100+"' AND A5_FORNECE='"+1010398+"' "
mSQL += " WHERE A5_FORNECE='"+cForn+"' AND A5_LOJA = '" + cLJ + "'"
mSQL += " GROUP BY A5_PRODUTO,B1_DESC,A5_CODPRF,A5_NOMPROD,B1_UM,A5__UNFOR,B1__EMBMAS,AIB_PRCCOM,A5_FORNECE,B1__DESCP,AIB__CTFIM "

if lCBForn    == .T.
	mSQL += " ORDER BY A5_CODPRF "
Elseif lCBNome == .T.
	mSQL += " ORDER BY B1_DESC "
Else
	mSQL += " ORDER BY A5_PRODUTO"
Endif


DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
TMP->( DbGoTop() )

If TMP->(!Eof())
	
	While TMP->(!EOF())
		
		AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
		nn++
		
		oGetTM1:Acols[nn][nPosProd]			:= Alltrim(TMP->A5_PRODUTO)
		oGetTM1:Acols[nn][nPosPRF]			:= TMP->A5_CODPRF
		oGetTM1:Acols[nn][nPosDESC]			:= TMP->B1_DESC
		oGetTM1:Acols[nn][nPosUV]			:= TMP->B1_UM
		oGetTM1:Acols[nn][nPosUC]			:= TMP->A5__UNFOR
		oGetTM1:Acols[nn][nPosQE]			:= TMP->B1__EMBMAS 
		
		nValNf := TMP->AIB_PRCCOM
	    DbSelectArea("Z17")
		Z17->( dbSetOrder( 1 ) )
		If Z17->( dbSeek( cFL + cForn + cLJ) )  
			While Z17->( ! Eof() ) .and. Z17->( Z17_FILIAL + Z17_FORNEC + Z17_LOJA ) == cFL + cForn + cLJ   
				nValNf -= nValNf * ( Z17->Z17_DESC / 100 )
				Z17->( dbSkip() )
			End
		EndIf         
		
		DbSelectArea("Z19")
		Z19->( dbSetOrder( 1 ) )
		If Z19->( dbSeek( xFilial("Z19") + cForn + cLJ + TMP->A5_PRODUTO ) )
			While Z19->( ! Eof() ) .and. Z19->( Z19_FILIAL + Z19_FORNEC + Z19_LOJA + Z19_PRODUT ) == xFilial("Z19") + cForn + cLJ + TMP->A5_PRODUTO 
				nValNf -= nValNf * ( Z19->Z19_DESC / 100 )
				Z19->( dbSkip() )
			End
		EndIf	
		
		oGetTM1:Acols[nn][nPosVCOM]	:= nValNf
			
		If !Empty(TMP->RECSD1)
			DbSelectArea("SD1")
			SD1->( dbGoTo( TMP->RECSD1 ) )    	
			oGetTM1:Acols[nn][nPosNF] := SD1->D1_VUNIT
		Else      
			oGetTM1:Acols[nn][nPosNF] := nValNf
		EndIf
		//oGetTM1:Acols[nn][nPosNF]			:= IIF(TMP->VLRNF>0 ,TMP->VLRNF ,TMP->AIB__CTFIM)
	   
		oGetTM1:Acols[nn][nPosQUANT]		:= 0
		oGetTM1:Acols[nn][Len(aHeader1)+1] 	:= .F.
		
		TMP->(DbSkip())
		
	Enddo
	
	oGetTM1:nat:=len(oGetTM1:Acols)
	
Else
	MsgInfo(OemToAnsi("Nenhum Produto Encontrado na Tabela dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
Endif
TMP->(dbCloseArea())

oGetTM1:Refresh()



Return
Static Function fOrder()
if lCBProd == .T.
	lCBForn := .F.
	oCBForn:Refresh()
	lCBNome := .F.
	oCBNome:Refresh()
Elseif lCBForn == .T.
	lCBProd == .F.
	oCBProd:Refresh()
	lCBNome := .F.
	oCBNome:Refresh()
Elseif lCBNome == .T.
	lCBForn == .F.
	oCBForn:Refresh()
	lCBProd == .F.
	oCBProd:Refresh()
Endif

Return

Static Function fObs()

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgObs","oGetObs","oBtn1")

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
oDlgObs    := MSDialog():New( 143,397,344,987,"Observações",,,.F.,,,,,,.T.,,,.T. )
@ 008, 012 GET oGetObs VAR cObs OF oDlgObs MULTILINE SIZE 268, 062 HSCROLL PIXEL
oGetObs:lWordWrap := .T.
oBtn1      := TButton():New( 076,228,"OK",oDlgObs,{||oDlgObs:End() },053,012,,,,.T.,,"",,,,.F. )

oDlgObs:Activate(,,,.T.)

Return

Static Function fGeraPed()


Local cNumPed	:= ""
Local _aCab  := {}
Local _aItem := {}
Local nItem	 := 0
Local nPosProd  :=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "C7_PRODUTO" 	})
Local nPosPRF	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "A5_CODPRF" 	})
Local nPosDESC	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "B1_DESC" 	})
Local nPosUV	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UV" 	})
Local nPosUC	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UC" 	})
Local nPosQE	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "UB__CXMAST" 	})
Local nPosVCOM	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "AIB_PRCCOM" 	})
Local nPosNF	:=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "VLRNF" 	})
Local nPosQUANT :=  ASCAN(aHeader1, { |x| AllTrim(x[2]) == "QUANT" 	})
Local _cFilAtu  := cFilAnt
dbSelectArea("SC7")
dbSetOrder(1)

If Empty(cForn)
	Alert("Favor Informar o Fornecedor.")
	Return .f.
Endif

If Empty(cPlano)
	Alert("Favor Informar a Condição de Pagamento.")
	Return .f.
Endif

cFilAnt := cFL
//		cNumPed := GetSXENum( "SC7", "C7_NUM" )

Aadd(_aCab,{"C7_FILIAL" , 	cFL					, Nil})
Aadd(_aCab,{"C7_EMISSAO", 	dDatabase			, Nil})
Aadd(_aCab,{"C7_FORNECE", 	cForn				, Nil})
Aadd(_aCab,{"C7_LOJA"	,	cLJ					, Nil})
//		Aadd(_aCab,{"C7_NUM"	,	cNumPed	    		, NIL})
Aadd(_aCab,{"C7_COND"	,	cPlano   			, NIL})
Aadd(_aCab,{"C7_CONTATO",	cContato			, NIL})
Aadd(_aCab,{"C7_OBS" 	,	cOBS				, NIL})
Aadd(_aCab,{"C7_MOEDA"  ,   1	      			, NIL})
Aadd(_aCab,{"C7_TXMOEDA",   0      				, NIL})
Aadd(_aCab,{"C7_FILENT" ,	cFL 				, NIL})


_aItens := {}
nItem := 0

for x:=1 to len(oGetTM1:Acols)
	
	If oGetTM1:Acols[x][nPosQUANT] > 0 .And. oGetTM1:Acols[x][nPosNF] > 0
		nItem ++
		_aItem := {}
		aAdd(_aItem,{"C7_ITEM"			, strZero(nItem,4)   			,NIL})
		aAdd(_aItem,{"C7_PRODUTO"		, oGetTM1:Acols[x][nPosProd]	,Nil})
		//                  aAdd(_aItem,{"C7_DESCRI"    	, oGetTM1:Acols[x][nPosDESC]    ,NIL})
		aAdd(_aItem,{"C7_QUANT"			, oGetTM1:Acols[x][nPosQUANT]	,NIL})
		//				    aAdd(_aItem,{"C7_UM"   			, oGetTM1:Acols[x][nPosUV] 		,NIL})
		aAdd(_aItem,{"C7_PRECO"			, oGetTM1:Acols[x][nPosNF]		,Nil})
		aAdd(_aItem,{"C7_TOTAL"			, oGetTM1:Acols[x][nPosNF]	* oGetTM1:Acols[x][nPosQUANT],Nil})
		aAdd(_aItem,{"C7_LOCAL"			, Posicione("SB1",1,xFilial("SB1") + oGetTM1:Acols[x][nPosProd],"B1_LOCPAD")	,NIL})
		aAdd(_aItem,{"C7_DATPRF"		, dDatabase+cEntrega			,NIL})
		aAdd(_aItem,{"C7__SEGISP"		, SB1->B1__SEGISP 				,NIL})
		
		aadd(_aItens,_aItem)
	Endif
	
next x

IF nItem > 0
	
	lMsErroAuto := .F.
	
	MSExecAuto({|v,x,y,z,w| MATA120(v,x,y,z,w)},1,_aCab,_aItens,3)
	//
	///MATA120(1,_aCab,_aItens,3)
	
	If !lMsErroAuto
		MsgInfo("Pedido Nº: " + SC7->C7_NUM + " gerado com sucesso !!!")
		_cGerPed := SC7->C7_NUM
		_cFilPed := SC7->C7_FILIAL
		//					ConfirmSX8()
		//					fPesq()
		oGetTM1:aCols := {}
		AAdd(oGetTM1:aCols, Array(Len(oGetTM1:aHeader) + 1))
		oGetTM1:Acols[1][Len(oGetTM1:aHeader)+1] 	:= .F.
		oGetTM1:nat:=len(oGetTM1:Acols)
		oGetTM1:Refresh()
		cDetPro := ""
		oDetPro:Refresh()
	Else
		MostraErro()
		_cGerPed := ""
		_cFilPed := ""
		//Alert("Erro ao gerar Pedido. ")
		//fPesq()
	EndIf
	
	/*
	if lMsErroAuto
	Alert("Erro ao gerar Pedido. ")
	fPesq()
	Else
	Alert("Pedido Nº: "+cNumPed+" gerado com sucesso !!!")
	ConfirmSX8()
	fPesq()
	
	endif
	*/
Else
	fPesq()
Endif
cFilAnt := _cFilAtu
	Return
