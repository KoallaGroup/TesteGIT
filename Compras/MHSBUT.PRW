/**************************/
Static Function NFEImport()
/**************************/
Local Sv_aCols:=aClone(aCols)
Local Sv_aHeader:=aClone(aHeader)
Local nXx:=n
Local cQry:=""
Local cCodExt:=Space(10)
lOCAL aDePara:={}
local _aArea := getArea()
// cria as variaveis necessarias para o sf1


//aNFEletr  := {CriaVar("F1_NFELETR"),CriaVar("F1_CODNFE"),CriaVar("F1_EMINFE"),CriaVar("F1_HORNFE"),CriaVar("F1_CREDNFE"),CriaVar("F1_NUMRPS"),;
//			    	  Iif(SF1->(FieldPos("F1_MENNOTA")) > 0,CriaVar("F1_MENNOTA"),Nil),;
//			    	  Iif(SF1->(FieldPos("F1_MENPAD")) > 0,CriaVar("F1_MENPAD"),Nil)}
//aNFEDanfe := {CriaVar("F1_TRANSP"),CriaVar("F1_PLIQUI"),CriaVar("F1_PBRUTO"),CriaVar("F1_ESPECI1"),CriaVar("F1_VOLUME1"),CriaVar("F1_ESPECI2"),CriaVar("F1_VOLUME2"),CriaVar("F1_ESPECI3"),CriaVar("F1_VOLUME3"),CriaVar("F1_ESPECI4"),CriaVar("F1_VOLUME4"),Iif(SF1->(FieldPos("F1_PLACA")) > 0,CriaVar("F1_PLACA"),Nil),CriaVar("F1_CHVNFE")}
//
//FillGetDados(nOpcX,"SD1",1,/*cSeek*/,/*{|| &cWhile }*/,{||.T.},aNoFields,/*aYesFields*/,/*lOnlyYes*/,cQuery,{|| MontaaCols(bWhileSD1,lQuery,l103Class,lClassOrd,lNfeOrd,aRecClasSD1,@nCounterSD1,cAliasSD1,cAliasSB1,@aRecSD1,@aRateio,cCpBasePIS,cCpValPIS,cCpAlqPIS,cCpBaseCOF,cCpValCOF,cCpAlqCOF,@aHeader,@aCols,l103Inclui,aHeadSDE,aColsSDE,@lContinua) },Inclui,/*aHeaderAux*/,/*aColsAux*/,/*bAfterCols*/,/*bbeforeCols*/,/*bAfterHeader*/,/*cAliasQry*/)
//
//
//Aadd(aDePara, {"DPR_COD_SEQ",		"D1_ITEM"	})
Aadd(aDePara, {"PRD_ESP_COD_EXTERNO","D1_COD"	})
Aadd(aDePara, {"DPR_QTD_QUANTIDADE","D1_QUANT"	})
Aadd(aDePara, {"DPR_PRE_VALORUN",	"D1_VUNIT"	})
Aadd(aDePara, {"CST_ICMS",			"D1_CLASFIS"})
Aadd(aDePara, {"MNY_VLR_IPI",		"D1_VALIPI"	})
Aadd(aDePara, {"MNY_FOB", 			"D1_FOB"	})
Aadd(aDePara, {"MNY_FRETE", 		"D1_VALFRE"	})
Aadd(aDePara, {"MNY_SEGURO",		"D1_SEGURO"	})
Aadd(aDePara, {"MNY_II", 			"D1_II"		})
Aadd(aDePara, {"PCT_II",			"D1_ALIQII"	})
Aadd(aDePara, {"MNY_DESPESAS",		"D1_DESPESA"})
Aadd(aDePara, {"PCT_IPI", 			"D1_IPI"	})
Aadd(aDePara, {"MNY_BC_ICMS",		"D1_BASEICM"})
Aadd(aDePara, {"MNY_BC_PIS",		"D1_BASIMP6"})
Aadd(aDePara, {"MNY_VLR_PIS",		"D1_VALIMP6"})
Aadd(aDePara, {"PCT_PIS", 			"D1_ALQIMP6"})
Aadd(aDePara, {"MNY_BC_COFINS",		"D1_BASIMP5"})
Aadd(aDePara, {"MNY_VLR_COFINS",	"D1_VALIMP5"})
Aadd(aDePara, {"PCT_COFINS",		"D1_ALQIMP5"})
Aadd(aDePara, {"MNY_VLR_ICMS",		"D1_VALICM"	})
Aadd(aDePara, {"PCT_ICMS",			"D1_ALIQICM"})
aHeader:={}
aCols:={}
nOpcc:=0
Aadd(aHeader, { "Processo    ",	"PROCESSO",		"@!",	10,	00,	"1==1",	"€€€€€0",	"C",	"",, } )
Aadd(aHeader, { "Documento   ",	"DOC_COD",		"@!",	10,	00,	"1==1", "€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "Ref. Externa",	"REFEXT",		"@!",	10,	00,	"1==1",	"€€€€€0",	"C",	"",, } )
Aadd(aHeader, { "Data Emissao",	"DTEMISSAO",	"@D",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "Fornecedor  ",	"FORNOME",		"@S20",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "FIL_COD     ",	"FIL_COD",		"@!",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "DOC_TIP     ",	"DOC_TIP",		"@!",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )

Define MsDialog oDlgCli From 000,000 To 210,750 Title "Histório Nota Fiscal de Entrada" Pixel Style DS_MODALFRAME //DS_SYSMODAL // // ou           
	@ 005,005 Say "ID Externo"									SIZE 035,10
	@ 005,035 Get cCodExt	Picture "@!"	Valid ChkExt(cCodExt)	SIZE 030,08
	@ 010,150 Say "Notas Fiscais para o Processo"				SIZE 150,08

	@ 020,005 TO 090,360 MULTILINE Object oMULTI
	@ 095,30 BmpButton Type 1 Action Eval({||SelectNF(aCols[n][2],aCols[n][6],aCols[n][7]), nOpcc:=1, Close(oDlgCli)})
	@ 095,80 BmpButton Type 2 Action Eval({||nOpcc:=2, Close(oDlgCli)})

Activate Dialog oDlgCli  CENTERED		

aCols:=aClone(Sv_aCols)
aHeader:=aClone(Sv_aHeader)
n:=nXx
cpyacols:=aClone(aCols[1])
aLinha:=aClone(cpyacols)
If nOpcc==1
	cTipo		:= "N"
	cFormul		:= "S"
//	cNFiscal	:= NFD->SF1->F1_DOC)
	cSerie		:= NFD->ESP_SERIE
	dDEmissao	:= NFD->DTEMISSAO
	cA100For	:= POSICIONE("SA2", 3, XFILIAL("SA2")+NFD->CNPJ, "A2_COD")
	cLoja		:= Sa2->A2_Loja
	cEspecie	:= "SPED "
	cUfOrig		:= NFD->UF_FILIAL


	nN:=0
	aCols:={}
	nColH:=0
	While !NFI->(Eof())
		For NNXX:=1 To Len( aDePara )    
		    If (nColH:=aScan(aHeader, {|z|AllTrim(z[2])==AllTrim(aDePara[nnxx][2]) })) =0
		       Loop

		    EndIf

			If TamSx3(aDePara[nnxx][2])[3]="N"
				If ValType(NFI->(FieldGet(NFI->(FieldPos(aDepara[nnxx][1])))))<>"N"
					aLinha[aScan(aHeader, {|z|AllTrim(z[2])==AllTrim(aDePara[nnxx][2]) })]:=Val( NFI->(FieldGet(NFI->(FieldPos(aDepara[nnxx][1])))) )

				Else
					aLinha[aScan(aHeader, {|z|AllTrim(z[2])==AllTrim(aDePara[nnxx][2]) })]:=NFI->(FieldGet(NFI->(FieldPos(aDepara[nnxx][1]))))

				EndIf

			ElseIf TamSx3(aDePara[nnxx][2])[3]="D"
				aLinha[aScan(aHeader, {|z|AllTrim(z[2])==AllTrim(aDePara[nnxx][2]) })]:=Ctod( NFI->(FieldGet(NFI->(FieldPos(aDepara[nnxx][1])))) )

			Else
				aLinha[aScan(aHeader, {|z|AllTrim(z[2])==AllTrim(aDePara[nnxx][2]) })]:= Transform(NFI->(FieldGet(NFI->(FieldPos(aDepara[nnxx][1])))), aHeader[nColH][3])

			EndIf

		Next

		m->B1_Cod:=Posicione("SB1", 1, xFilial("SB1")+NFI->PRD_ESP_COD_EXTERNO, "B1_COD")
		aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_TOTAL" })]:=aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_VUNIT" })]*aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_QUANT" })]
		aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_UM" })]:=Sb1->B1_UM
		aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_OPER" })]:="51"
		aLinha[aScan(aHeader, {|z|AllTrim(z[2])=="D1_TES" })]:="050"
		aLinha[1]:=StrZero(++nN, 4)
		m->ccc:=0
		aEval(aHeader, {|ff| &(m->ff[2]):=aLinha[++ccc]})
		n:=nn
		Aadd(aCols, aClone(aLinha))
		Eval({|| {||&(aHeader[aScan(aHeader, {|z|AllTrim(z[2])=="D1_COD" }),6])}} )
		Eval({|| {||&(aHeader[aScan(aHeader, {|z|AllTrim(z[2])=="D1_QUANT" }),6])}} )
		Eval({|| {||&(aHeader[aScan(aHeader, {|z|AllTrim(z[2])=="D1_OPER" }),6])}} )
		Eval({|| {||&(aHeader[aScan(aHeader, {|z|AllTrim(z[2])=="D1_TOTAL" }),6])}} )
		aEval(aHeader,{|zz| (lTrig:=Posicione("SX3", 2, zz[2], "X3_TRIGGER")), If(lTrig="S" .And. zz[2]<>"D1_TES", RunTrigger(1,,,,zz[2]), "") })
MaFisToCols(aHeader,aCols,,"MT100")

//MaFisAlt("NF_DESCONTO",aHeader[ProcH("D1_DESCONT"),2])
MaFisAlt("NF_VALIRR",aHeader[ProcH("D1_IRRF"),2])
MaFisAlt("NF_VALINS",aHeader[ProcH("D1_INSS"),2])
MaFisAlt("NF_DESPESA",aHeader[ProcH("F1_DESPESA"),2])
MaFisAlt("NF_FRETE",aHeader[ProcH("F1_FRETE"),2])
MaFisAlt("NF_SEGURO",aHeader[ProcH("F1_SEGURO"),2])
MaFisAlt("NF_TOTAL",aHeader[ProcH("F1_VALBRUT"),2])
MaFisAlt("NF_DESCONTO",aHeader[ProcH("F1_Desconto"),2])
MaFisAlt("NF_BASEICM",aHeader[ProcH("F1_BaeICM"),2])
MaFisAlt("NF_VALICM",aHeader[ProcH("F1_VALICM"),2])
MaFisAlt("NF_BASEIPI",aHeader[ProcH("F1_BASEIPI"),2])
MaFisAlt("NF_VALIPI",aHeader[ProcH("F1_VALIPI"),2])
MaFisAlt("NF_BASESOL",aHeader[ProcH("F1_BRICMS"),2])
MaFisAlt("NF_VALSOL",aHeader[ProcH("F1_ICMSRET"),2])
MaFisAlt("NF_RECISS",aHeader[ProcH("F1_RECISS"),2])

//		A103LinOk()

		aLinha:=aClone(cpyacols)
		NFI->(DbSkip())

	EndDo

EndIf

n:=nXx
restarea(_aarea)

Return 

/************************/
Static Function ChkExt(_P)
/************************/
Local lRet:=.t.
Local cQry:=""
cQry+="SELECT "+Chr(13)
cQry+="	pri_cod PROCESSO,"+Chr(13)
cQry+="	doc_cod ,"+Chr(13)
cQry+="	pri_esp_refcliente REFEXT,"+Chr(13)
cQry+="	doc_dta_emissao DTEMISSAO,"+Chr(13)
cQry+="	nome_pessoa FORNOME, "+Chr(13)
cQry+="	FIL_COD,	"+Chr(13)
cQry+="	DOC_TIP,	"+Chr(13)
cQry+="	CNPJ_FILIAL CNPJ,	"+Chr(13)
cQry+="	UF_FILIAL,	"+Chr(13)
cQry+="	ESP_SERIE	"+Chr(13)
cQry+="FROM  "+Chr(13)
cQry+="	conexos.view_int_nfe@msvsim_conexos "+Chr(13)
cQry+="WHERE pri_esp_refcliente = '"+AllTrim(_P)+"' "+Chr(13)
If Select("NFD")<>0;NFD->(DbCloseArea());EndIf
DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "NFD" )
aCols:={}
While !NFD->(Eof())
	Aadd(aCols, {NFD->PROCESSO, NFD->DOC_COD, NFD->REFEXT, NFD->DTEMISSAO, NFD->FORNOME, FIL_COD, DOC_TIP, .F.})
	NFD->(DbSkip())

EndDo

If Len(aCols)=0
	MsgInfo("Não existe notas para o processo informado. Verifique !!!", "Dados Incorretos")
	lRet:=.f.

ElseIf Len(aCols)=1
	lRet:=.t.
	nOpcc:=1
	SelectNF(aCols[n][2],aCols[n][6],aCols[n][7])
	Close(oDlgCli)

EndIf

oMULTI:Refresh()
Return lRet


/***********************************/
Static Function SelectNF(_P,_P1,_P2)
/***********************************/
//DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "NFD" )
Local cQry:=""
CQRY+="SELECT "
CQRY+="	* "
CQRY+="FROM  "
CQRY+="	CONEXOS.VIEW_INT_NFE_ITENS@MSVSIM_CONEXOS "
CQRY+="WHERE DOC_COD = "+STR(_P)+" "
CQRY+="	AND FIL_COD = "+STR(_P1)+" "
CQRY+="	AND DOC_TIP = "+STR(_P2)+" "

If Select("NFI")<>0; NFI->(DbCloseArea()); EndIf 
DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "NFI" )

Return Nil

Static Function ProcH(cCampo)
Return aScan(aHeader,{|x|Trim(x[1])== cCampo })





/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³A103NFORI³ Autor ³ Edson Maricate        ³ Data ³16.02.2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Faz a chamada da Tela de Consulta a NF original            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³MATA103                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NFImpOri()

Local bSavKeyF4 := SetKey(VK_F4,Nil)
Local bSavKeyF5 := SetKey(VK_F5,Nil)
Local bSavKeyF6 := SetKey(VK_F6,Nil)
Local bSavKeyF7 := SetKey(VK_F7,Nil)
Local bSavKeyF8 := SetKey(VK_F8,Nil)
Local bSavKeyF9 := SetKey(VK_F9,Nil)
Local bSavKeyF10:= SetKey(VK_F10,Nil)
Local bSavKeyF11:= SetKey(VK_F11,Nil)
Local nPosCod	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_COD'})
Local nPosLocal := aScan(aHeader,{|x| AllTrim(x[2])=='D1_LOCAL'})
Local nPosTes	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_TES'})
Local nPLocal	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_LOCAL'})
Local nPosOP 	:= aScan(aHeader,{|x| AllTrim(x[2])=='D1_OP'})
Local nRecSD1   := 0
Local nRecSD2   := 0
Local lContinua := .T.
Local nTpCtlBN  := If(FindFunction("A410CtEmpBN"), A410CtEmpBN(), If(SD4->(FieldPos("D4_NUMPVBN")) > 0, 1, 0))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Impede de executar a rotina quando a tecla F3 estiver ativa		    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Type("InConPad") == "L"
	lContinua := !InConPad
EndIf

If lContinua

	DbSelectArea("SF4")
	DbSetOrder(1)
	MsSeek(xFilial("SF4")+aCols[n][nPosTes])

	If MaFisFound("NF") .And. Empty(Readvar())
		Do Case
			Case cTipo =="D" .And. SF4->F4_PODER3=="N"
				If F4NFORI(,,"M->D1_NFORI",cA100For,cLoja,aCols[n][nPosCod],"A100",aCols[n][nPLocal],@nRecSD2) .And. nRecSD2<>0
					NfeNfs2Acols(nRecSD2,n)
				EndIf
			Case cTipo$"CPI"
				If F4COMPL(,,,cA100For,cLoja,aCols[n][nPosCod],"A100",@nRecSD1,"M->D1_NFORI") .And. nRecSD1<>0
					NfeNfe2ACols(nRecSD1,n)
				EndIf
			Case cTipo$"NB" .And. SF4->F4_PODER3=="D"
				If cPaisLoc=="BRA"
					If F4Poder3(aCols[n][nPosCod],aCols[n][nPosLocal],cTipo,"E",cA100For,cLoja,@nRecSD2,SF4->F4_ESTOQUE) .And. nRecSD2<>0
						NfeNfs2Acols(nRecSD2,n)
						If nPosOp > 0 .And. cTipo == "N" .And. (nTpCtlBN != 0)
                    	    If Empty(aCols[n][nPosOp])
								aCols[n][nPosOp] := A103OPBen(nil,nTpCtlBN)
	                        EndIf 
						EndIf
					EndIf
				Else
					If A440F4("SB6",aCols[n][nPosCod],aCols[n][nPosLocal],"B6_PRODUTO","E",cA100For,cLoja,.F.,.F.,@nRecSD2,IIF(cTipo=="N","F","C")) > 0
						NfeNfs2Acols(nRecSD2,n)
					EndIf
				EndIf		
			OtherWise
				If Empty(aCols[n][nPosCod]) .Or. Empty(aCols[n][nPosTes])
					Help('   ',1,'A103TPNFOR')
				ElseIf cTipo == "D" .And. SF4->F4_PODER3 <> "N"	
					Help('   ',1,'A103TESNFD')
				ElseIf cTipo$"NB" .And. SF4->F4_PODER3 <> "D"	
					Help('   ',1,'A103TESNFB')
				EndIf
		EndCase
	Else
		Help('   ',1,'A103CAB')
	EndIf
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ PNEUAC - Ponto de Entrada,gravar na coluna Lote o numero baseado na nf Original       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If ExistBlock("PNEU002")
		ExecBlock("PNEU002",.F.,.F.)
	EndIf
Endif

SetKey(VK_F4,bSavKeyF4)
SetKey(VK_F5,bSavKeyF5)
SetKey(VK_F6,bSavKeyF6)
SetKey(VK_F7,bSavKeyF7)
SetKey(VK_F8,bSavKeyF8)
SetKey(VK_F9,bSavKeyF9)
SetKey(VK_F10,bSavKeyF10)
SetKey(VK_F11,bSavKeyF11)
// Atualiza valores na tela
Eval(bRefresh)
Return .T.


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³NfeNfe2Aco³ Autor ³ Edson Maricate        ³ Data ³07.01.2000 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³Esta rotina atualiza o acols com base no item do documento de³±±
±±³          ³entrada                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1: Numero do registro do item do documento de entrada    ³±±
±±³          ³ExpN2: Item do acols no documento de entrada                 ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpL1: Sempre .T.                                            ³±±
±±³          ³                                                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Esta rotina tem como objetivo atualizar a funcao fiscal com  ³±±
±±³          ³base no item do documento de entrada e atualizar o acols tb. ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Materiais                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function NfI2Acols(nRecSD1,nItem)

Local aArea		:= GetArea()
Local aAreaSD1	:= SD1->(GetArea())
Local lAtualiza := .F.

dbSelectArea("SD1")
MsGoto(nRecSD1)

If MaFisRet(nItem,"IT_NFORI")<>SD1->D1_DOC
	MaFisAlt("IT_NFORI",SD1->D1_DOC,nItem)
	lAtualiza := .T.
EndIf
If MaFisRet(nItem,"IT_SERORI")<>SD1->D1_SERIE
	MaFisAlt("IT_SERORI",SD1->D1_SERIE,nItem)
	lAtualiza := .T.	
EndIf
If MaFisRet(nItem,"IT_RECORI")<>nRecSD1
	MaFisAlt("IT_RECORI",nRecSD1,nItem)
	lAtualiza := .T.
EndIf
If lAtualiza
	MaColsToFis(aHeader,aCols,nItem,"MT100",.T.)
EndIf

If bGdRefresh<>Nil
	Eval(bGDRefresh)
EndIf

RestArea(aArea)
RestArea(aAreaSD1)
Return(.T.)


//	ElseIf Inclui
//		Aadd( aButton, {"EDIT", { || NFEImport() },'Nota Fiscal Imporação' } )

