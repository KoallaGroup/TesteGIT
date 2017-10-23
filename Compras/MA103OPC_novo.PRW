#Include "Protheus.ch"
#include "Rwmake.ch"
/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MA103OPC			  		| 		Agosto de 2014				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Marcelo Haro Sanches - Anadi														|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Inclusão de Ação Relacionada aos dados complementares de importação na Nota de Entrada	|
|-------------------------------------------------------------------------------------------------------|	
*/

/***********************/
User Function MA103OPC()
/***********************/
Local aRet := {}

aAdd(aRet,{'Nota Fiscal Imporação','ExecBlock("NFEImpAuto",.F.,.F.)', 0, 3})	

Return(aRet)
                                               
/*************************/
User Function NFEImpAuto()
/*************************/
Local cQry:=""
Local cCodExt:=Space(10)
local _aArea := getArea()
Private aCD5:={}
Private c_CodForn		:= Space(09)
Private c_Document	 	:= Space(10)
Private c_Filial	 	:= Space(02)
Private c_FilNome	 	:= Space(30)
Private c_ForNome	 	:= Space(30)
Private c_ForLoja	 	:= Space(2)
Private c_Local	 		:= Space(03)
Private c_LocalDes 		:= Space(30)
Private c_loja	 		:= Space(02)
Private c_Processo	 	:= Space(17)
Private c_RefExt	 	:= Space(15)
Private d_DtEmis	 	:= Space(08)
Private c_Fornec	 	:= Space(09)
Private c_ForNome	 	:= Space(30)
Private c_ForLoja	 	:= Space(2)
Private c_Endereco 		:= Space(2)
Private c_EndNome	 	:= Space(30)
Private c_Operacao 		:= Space(04)
Private c_OpeNome	 	:= Space(30)
Private c_Segmento 		:= Space(04)
Private c_SegNome	 	:= Space(30)
Private c_Transp		:= Space(09)
Private c_TraNome	 	:= Space(30)
Private c_TpFre			:= Space(09)
Private c_TpfNome	 	:= Space(30)
Private c_Proces		:= Space(17)
Private c_NumDI	 		:= Space(11)
Private d_DtDI	 		:= ctod("  /  /  ")
Private c_LocDes		:= Space(03)
Private c_LocDNome		:= Space(30)
Private c_ObsComp		:= Space(250)
Private c_UFDesem		:= Space(2)
Private c_UFDNome		:= Space(30)
Private d_DtDesem		:=ctod("  /  /  ")
Private n_PesoL			:=0
Private n_PesoB			:=0
Private oDlgIMPNF
Private _cSerie := ""
ChkFile("SZ3")
ChkFile("SZ2")
cNumero:=""
aHeader:={}
aCols:={}
aItens:={}
nOpcc:=0
aHeader:={}
Aadd(aHeader, { "Processo    ",	"PROCESSO",		"@!",	10,	00,	"1==1",	"€€€€€0",	"C",	"",, } )
Aadd(aHeader, { "Documento   ",	"DOC_COD",		"@!",	10,	00,	"1==1", "€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "Ref. Externa",	"REFEXT",		"@!",	10,	00,	"1==1",	"€€€€€0",	"C",	"",, } )
Aadd(aHeader, { "Data Emissao",	"DTEMISSAO",	"@D",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "Fornecedor  ",	"FORNOME",		"@S20",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "FIL_COD     ",	"FIL_COD",		"@!",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )
Aadd(aHeader, { "DOC_TIP     ",	"DOC_TIP",		"@!",	20,	00,	"1==1",	"€€€€€€",	"C",	"",, } )

Define MsDialog oDlgIMPNF From c(000),c(000) To c(210),c(560) Title "Importação de Notas Fiscais de Entrada (Despachante)" Pixel Style DS_MODALFRAME 
	@ c(005),c(005) Say "ID Externo"									SIZE c(035),c(10) Pixel 	Of oDlgIMPNF
	@ c(005),c(035) Get cCodExt	Picture "@!"	Valid ChkExt(cCodExt)	SIZE c(030),c(08) Pixel 	Of oDlgIMPNF
	@ c(010),c(150) Say "Notas Fiscais para o Processo"				SIZE c(150),c(08) Pixel 	Of oDlgIMPNF

	@ c(020),c(005) TO c(090),c(360) MULTILINE Object oMULTI
	@ c(095),c(30) BmpButton Type 1 Action Eval({||If(SelectNF(n), nOpcc:=1, nOpcc:=2)}) //, Close(oDlgIMPNF)}) 
	@ c(095),c(80) BmpButton Type 2 Action Eval({||nOpcc:=2, Close(oDlgIMPNF)}) 
	oMULTI:ReFresh()

Activate Dialog oDlgIMPNF  CENTERED		

If nOpcc==1 .And. DAdicImp()
	cA100For	:= c_Fornec
	cLoja		:= c_ForLoja
	Sa2->(DbSetOrder(1))
	cTipo		:= "N"
	cFormul		:= "S"
	dDEmissao	:= NFD->DTEMISSAO
	cEspecie	:= "SPED "
	cUfOrig		:= NFD->UF_FILIAL
	cTpNrNfs:="1"
	IF EMPTY(cNumero)
		If cTpNrNfs <> "3"
			DO WHILE .T.
				IF !SX5NumNota(.F.,cTpNrNfs)
					RETURN .F.
	
				ELSE
					EXIT
	
				ENDIF
	
			ENDDO
	
			cNumero := NxTSx5Nota(_cSerie,.T.,cTpNrNfs)+Space(Len(Sd1->D1_Doc)-Len(cNumero))
			_cserie:=Sx5->X5_Chave
			nOrderSF1 := SF1->(IndexOrd())
			SF1->(DBSetOrder(1))        
			If SF1->(DbSeek(xFilial("SF1")+cNumero+_cSerie+cA100For+cLoja))
				Do While SF1->(DBSeek(xFilial("SF1")+cNumero+_cSerie+cA100For+cLoja))
					cNumero := NxTSx5Nota(_cSerie,.T.,cTpNrNfs)+Space(Len(Sd1->D1_Doc)-Len(cNumero))
					_cserie:=Sx5->X5_Chave

				EndDo
	
			Endif
	
		EndIf
	
		SF1->(DBSetOrder(nOrderSF1))
	
	ENDIF

	nTotSeg:=0
	nTotII:=0
	nTotDes:=0
	nTotBCII:=0
	While !NFI->(Eof())
		DetNfImp()
		nTotSeg+=NFI->MNY_SEGURO
		nTotII+=NFI->MNY_II
		nTotDes+=NFI->MNY_DESPESA
		nTotBCII+=NFI->MNY_BC_II

		NFI->(DbSkip())

	EndDo

	aCab := {}
	AADD(aCab,{"F1_DOC",		cNumero,			NIL})   // NUMERO DA NOTA
	AADD(aCab,{"F1_SERIE",		_cSerie,			NIL})   // SERIE DA NOTA
	AADD(aCab,{"F1_FORNECE",	Sa2->A2_Cod,		NIL})   // FORNECEDOR  
	AADD(aCab,{"F1_LOJA",		Sa2->A2_Loja,		NIL})   // LOJA DO FORNECEDOR 
	AADD(aCab,{"F1_TIPO",		"N",				NIL})   // TIPO DA NF
	AADD(aCab,{"F1_FORMUL",		"S",				NIL})   // FORMULARIO PROPRIO SIM OU NAO, CONF.OPCAO DO USUARIO
	AADD(aCab,{"F1_EMISSAO",	NFD->DtEmissao,		NIL})   // DATA DA EMISSAO DA NOTA                                 
	AADD(aCab,{"F1_ESPECIE",	"SPED",				NIL})   
	AADD(aCab,{"F1_DTDIGIT",	dDataBase,			NIL})
	AADD(aCab,{"F1_EST",		SA2->A2_EST,		NIL}) 
	AADD(aCab,{"F1_TIPODOC",	"10",				NIL}) 
	AADD(aCab,{"F1_TIPO_NF",	"1",				NIL})
	AADD(aCab,{"F1_PESOL",		n_PesoL,			NIL})
	AADD(aCab,{"F1_FOB_R",		NFD->VLR_MERC,		NIL})
	AADD(aCab,{"F1_FRETE",		NFD->VLR_FRETE,		NIL})
	AADD(aCab,{"F1_SEGURO",		nTotSeg,			NIL})
	AADD(aCab,{"F1_CIF",		NFD->VLR_CONT,		NIL})
	AADD(aCab,{"F1_II",			nTotII,				NIL})
	AADD(aCab,{"F1_IPI",		NFD->VLR_IPI,		NIL})
	AADD(aCab,{"F1_ICMS",		NFD->VLR_ICMS,		NIL})
	AADD(aCab,{"F1_DESPESA",	nTotDes,			NIL})
	AADD(aCab,{"F1_CTR_NFC",	cNumero+_cSerie,	Nil})
	AADD(aCab,{"F1_PLIQUI",		n_PesoL,			Nil})//Peso Liquido
	AADD(aCab,{"F1_PBRUTO",		n_PesoB,			Nil})//Peso Bruto 
	AADD(aCab,{"F1_MENNOTA",	c_ObsComp,			Nil})//Peso Bruto 
	AADD(aCab,{"F1__PROIMP",	AllTrim(Str(NFD->Processo)),	Nil})//Processo de importação
	AADD(aCab,{"F1_TRANSP",		c_Transp,			Nil})//Transportadora
	AADD(aCab,{"F1__DOCCOD",	AllTrim(STR(NFD->DOC_COD)),		Nil})
	AADD(aCab,{"F1__REFEXT",	NFD->REFEXT,					Nil})
	lMSErroAuto:=.f.
	Processa({||MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens)})
	DbCommitAll()
	IF lMSErroAuto           
		MostraErro()
	
	Else
		l103Class	:= .T.
		l103TolRec  := .T.
		INCLUI := .F.
		ALTERA := .F.
		Sd1->(DbSeek(xFilial("SD1")+cNumero+SubStr(_cSerie,1,Len(Sd1->D1_Serie))))
		While !Sd1->(Eof()) .And. Sd1->(D1_Doc+D1_Serie)=cNumero+SubStr(_cSerie,1,Len(Sd1->D1_Serie))
			RecLock("SD1", .f.)
				Sd1->D1_TESACLA:=c_OpeNome

			MsUnLock()

			Sd1->(DbSkip())

		EndDo

		A103NFiscal("SF1", Sf1->(RecNo()), 4, .t., .f.)

	ENDIF

EndIf

If EMPTY(Posicione("SD1", 1, xfilial("SD1")+Sf1->F1_Doc, "D1_TES")) // nao foi confirmada a gravação, então, precisa ser estornado o documento fiscal
	lMSErroAuto:=.f.
	Processa({||MSExecAuto({|x,y,z| MATA140(x,y,z)},aCab,aItens,5, .f., .f.)})
	DbCommitAll()
	IF lMSErroAuto           
		MostraErro()
	
	EndIf

Else
	Sd1->(DbSeek(xFilial("SD1")+Sf1->F1_Doc+SubStr(_cSerie,1,Len(Sd1->D1_Serie))))
	While !Sd1->(Eof()) .And. Sd1->(D1_Doc+D1_Serie)=Sf1->F1_Doc+SubStr(_cSerie,1,Len(Sd1->D1_Serie))
		If (nPosi:=aScan( aCD5, {|z|z[1]=Sd1->D1_Doc .And. z[2]=Sd1->D1_Serie .And. z[3]=Sd1->D1_Cod }))<>0
			RecLock("CD5", .t.)
				Cd5->Cd5_Filial	:=	xFilial("CD5")
				Cd5->Cd5_Doc	:=	Sf1->F1_Doc
				Cd5->Cd5_Serie	:=	_cSerie
				Cd5->Cd5_Espec	:=	"SPED"
				Cd5->Cd5_Fornec	:=	CA100For
				Cd5->Cd5_Loja	:=	CLoja
				Cd5->Cd5_TpImp	:=	"0"
				Cd5->Cd5_DocImp	:=	c_Processo
				Cd5->Cd5_BsPis	:=	Sd1->D1_BasImp6
				Cd5->Cd5_AlPis	:=	If(Sd1->D1_ValImp6=0, 0, Sd1->D1_AlqImp6)
				Cd5->Cd5_VlPis	:=	Sd1->D1_ValImp6
				Cd5->Cd5_BsCof	:=	Sd1->D1_BasImp5
				Cd5->Cd5_AlCof	:=	If(Sd1->D1_ValImp5=0, 0, Sd1->D1_AlqImp5)
				Cd5->Cd5_VlCof	:=	Sd1->D1_ValImp5
				Cd5->Cd5_Local	:=	Sd1->D1_Local
				Cd5->Cd5_DtPCof	:=	d_DtDI
				Cd5->Cd5_DtPPis	:=	d_DtDI
				Cd5->Cd5_NDI	:=	c_NumDI
				Cd5->Cd5_DtDI	:=	d_DtDI
				Cd5->Cd5_LocDes	:=	c_LocDes
				Cd5->Cd5_UFDes	:=	c_UFDesem
				Cd5->Cd5_DtDes	:=	d_DtDesem
				Cd5->Cd5_CodExp	:=	CA100For
				Cd5->Cd5_Nadic	:=	StrZero(aCD5[nPosi][6], Len(Cd5->Cd5_Nadic)) //NFI->ADI_COD
				Cd5->Cd5_SqAdic	:=	StrZero(aCD5[nPosi][7], Len(Cd5->Cd5_SqAdic)) //NFI->IDI_COD
				Cd5->Cd5_CodFab	:=	CA100For
				Cd5->Cd5_BCImp	:=	aCD5[nPosi][8] 
				Cd5->Cd5_DsPad	:=	Sd1->D1_Despesa
				Cd5->Cd5_VDESDI	:=	0
				Cd5->Cd5_VlrII	:=	aCD5[nPosi][9] 
				Cd5->Cd5_VlrIOF	:=	0
				Cd5->Cd5_AcDraw	:=	""
				Cd5->Cd5_LojExp	:=	cLoja
				Cd5->Cd5_LojFab	:=	cLoja
				Cd5->Cd5_Item	:=	Sd1->D1_Item
				Cd5->Cd5_VTrans	:=	"1"
				Cd5->Cd5_VAFRMM	:=	0
				Cd5->Cd5_INTERM	:=	""
				Cd5->Cd5_CNPJAE	:=	""
				Cd5->Cd5_UFTERC	:=	""

        	MsUnLock()

		EndIf
	
		Sd1->(DbSkip())
	
	EndDo


Endif

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
cQry+="	CFOP,	"+Chr(13)
cQry+="	UF_FILIAL,	"+Chr(13)
cQry+="	FIS_FLT_PESO_LIQUIDO PESOL,	"+Chr(13)
cQry+="	FIS_FLT_PESO_BRUTO PESOB,	"+Chr(13)
cQry+="	MNY_VLR_CONTABIL VLR_CONT,	"+Chr(13)
cQry+="	MNY_VLR_MERC VLR_MERC,	"+Chr(13)
cQry+="	MNY_FRETE VLR_FRETE,	"+Chr(13)
cQry+="	MNY_BC_ICMS	BC_ICMS,	"+Chr(13)
cQry+="	MNY_ICMS VLR_ICMS,	"+Chr(13)
cQry+="	PCT_ICMS ALI_ICMS,	"+Chr(13)
cQry+="	MNY_BC_IPI BC_IPI,	"+Chr(13)
cQry+="	MNY_IPI VLR_IPI,	"+Chr(13)
cQry+="	DATA_REGDI,	"+Chr(13)
cQry+="	LOCAL_DESEMBARACO LOCDES,	"+Chr(13)
cQry+="	UF_LOCAL_DESEMBARACO UFDES,	"+Chr(13)
cQry+="	DATA_DESEMBARACO DTDES,	"+Chr(13)
cQry+="	FIS_FLT_PESO_LIQUIDO PESOLT,	"+Chr(13)
cQry+="	FIS_FLT_PESO_BRUTO PESOBT,	"+Chr(13)
cQry+="	ESP_SERIE	"+Chr(13)
cQry+="FROM  "+Chr(13)
cQry+="	conexos.view_int_nfe@msvsim_conexos CB "+Chr(13)
cQry+="WHERE pri_esp_refcliente = '"+AllTrim(_P)+"' "+Chr(13)
cQry+="	AND NOT EXISTS(SELECT 1 FROM SF1010 F1 WHERE LTRIM(RTRIM(F1.F1__DOCCOD))=LTRIM(RTRIM(CB.DOC_COD)) AND F1.D_E_L_E_T_=' ') "+Chr(13)

If Select("NFD")<>0;NFD->(DbCloseArea());EndIf
If TcSqlExec(cQry)=0
	DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "NFD" )
	aCols:={}
	While !NFD->(Eof())
		Aadd(aCols, {AllTrim(Str(NFD->Processo)), STR(NFD->DOC_COD), NFD->REFEXT, NFD->DTEMISSAO, NFD->FORNOME, FIL_COD, DOC_TIP, .F.})
		NFD->(DbSkip())

	EndDo

EndIF

If Len(aCols)=0
	MsgInfo("Não existe notas para o processo informado. Verifique !!!", "Dados Incorretos")
	lRet:=.f.

EndIf

oMULTI:Refresh()
Return lRet


/***********************************/
Static Function SelectNF(_P,_P1,_P2)
/***********************************/
Local lRet:=.t.
Local cQry:=""
NFD->(DbGoTop())
While _P>1
	NFD->(DbSkip())
	--_P

EndDo

CQRY+="SELECT "
CQRY+="	* "
CQRY+="FROM  "
CQRY+="	CONEXOS.VIEW_INT_NFE_ITENS@MSVSIM_CONEXOS IT "
CQRY+="WHERE DOC_COD = "+AllTrim(STR(NFD->DOC_COD))+" "
CQRY+="	AND FIL_COD = "+AllTrim(STR(NFD->FIL_COD))+" "
CQRY+="	AND DOC_TIP = "+AllTrim(STR(NFD->DOC_TIP))+" "
cQry+="	AND NOT EXISTS(SELECT 1 FROM SF1010 F1 WHERE LTRIM(RTRIM(F1.F1__DOCCOD))=LTRIM(RTRIM(IT.DOC_COD)) AND F1.D_E_L_E_T_=' ') "+Chr(13)
If Select("NFI")<>0; NFI->(DbCloseArea()); EndIf 
If TcSqlExec(cQry)=0
	DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "NFI" )

Else
	MsgStop("Não foi possível executar query: "+cqry+".", "VERIFIQUE")
	lRet:=.f.

EndIf

Return lRet

/************************/
Static Function DetNFImp()
/************************/
SB1->(DbSeek(xFilial()+NFI->PRD_ESP_COD_EXTERNO))
If (c_Z2Cod:=Posicione("SZ2", 3, xFilial("SZ2")+AllTrim(Str(NFD->Processo)), "Z2_CODIGO",""))<>" "
	c_Pedido:=Posicione("SZ3", 1, xFilial("SZ3")+c_Z2Cod+NFI->PRD_ESP_COD_EXTERNO, "Z3_PEDIDO" )
	c_Item:=Sz3->Z3_ItPedCo

Else
	c_Z2Cod:=""
	c_Pedido:=""
	c_Item:=""

EndIf
	
aItem:={}
AADD(aItem,{"D1_COD",		NFI->PRD_ESP_COD_EXTERNO,							".T."})// codigo do produto
AADD(aItem,{"D1_UM"	,		Sb1->B1_UM,											".T."}) // unidade do produto
AADD(aItem,{"D1_QUANT",		NFI->DPR_QTD_QUANTIDADE,							".T."}) // quantidade do produto
AADD(aItem,{"D1_VUNIT",		Val(NFI->DPR_PRE_VALORUN)/NFI->DPR_QTD_QUANTIDADE,	".T."}) // valor unitario do item
AADD(aItem,{"D1_VALIPI",	NFI->MNY_VLR_IPI,									".T."})  // Vlr do IPI 
AADD(aItem,{"D1_VALICM",	NFI->MNY_VLR_ICMS,									".T."})  // Vlr do ICMS
AADD(aItem,{"D1_CF",		NFD->CFOP,											".T."})  // Classificacao Fiscal                                                
AADD(aItem,{"D1_IPI",		NFI->PCT_IPI,										".T."})
AADD(aItem,{"D1_PICM",		NFI->PCT_ICMS,										".T."})
AADD(aItem,{"D1_PESO",		Sb1->B1_Peso,										".T."})  // Peso Total do Item
AADD(aItem,{"D1_FORNECE",	Sa2->A2_Cod,										".T."})
AADD(aItem,{"D1_LOJA",		Sa2->A2_Loja,										".T."})
AADD(aItem,{"D1_LOCAL",		Sb1->B1_LocPad,										".T."})
AADD(aItem,{"D1_DOC",		cNumero,											NIL})
AADD(aItem,{"D1_SERIE",		_cSerie,											NIL})
AADD(aItem,{"D1_EMISSAO",	NFD->DTEMISSAO,										NIL})
AADD(aItem,{"D1_DTDIGIT",	dDataBase,											".T."})               
AADD(aItem,{"D1_TIPO",		"N",												NIL})   //nTipoNF=NFE_COMPLEMEN   Bete 24/11 - Trevo
AADD(aItem,{"D1_TIPODOC",	"10",												NIL})   //nTipoNF=NFE_COMPLEMEN   Bete 24/11 - Trevo
AADD(aItem,{"D1_TP",		SB1->B1_TIPO,										".T."})
AADD(aItem,{"D1_TOTAL",		NFI->(Val(DPR_PRE_VALORUN)),						".T."})  // valor total do item (quantidade * preco)
AADD(aItem,{"D1_BASEICM",	NFI->MNY_BC_ICMS,									".T."})
AADD(aItem,{"D1_BASEIPI",	NFI->MNY_BC_IPI,									".T."})
AADD(aItem,{"D1_FORMUL",	"S",												".T."})
AADD(aItem,{"D1_TEC",		Sb1->B1_PosIpi,										".T."})
AADD(aItem,{"D1_DESPESA",	NFI->MNY_DESPESAS,									".T."})
AADD(aItem,{"D1_SEGURO",	NFI->MNY_SEGURO,									".T."})
AADD(aItem,{"D1_BASIMP6",	NFI->MNY_BC_PIS,									".T."})
AADD(aItem,{"D1_VALIMP6",	NFI->MNY_VLR_PIS,									".T."})
AADD(aItem,{"D1_ALQIMP6",	NFI->PCT_PIS,										".T."})
AADD(aItem,{"D1_BASIMP5",	NFI->MNY_BC_COFINS,									".T."})
AADD(aItem,{"D1_VALIMP5",	NFI->MNY_VLR_COFINS,								".T."})
AADD(aItem,{"D1_ALQIMP5",	NFI->PCT_COFINS,									".T."})
AADD(aItem,{"D1_ALIQII",	NFI->PCT_II,										".T."})
AADD(aItem,{"D1_II",		NFI->MNY_II,										".T."})
AADD(aItem,{"D1_VALFRE",	NFI->MNY_FRETE,										".T."})
AADD(aItem,{"D1_PEDIDO",	c_Pedido,											".T."})
AADD(aItem,{"D1_ITEMPC",	c_Item,												".T."})
AADD(aItens,ACLONE(aItem))
Aadd(aCD5, {cNumero, _cSerie, NFI->PRD_ESP_COD_EXTERNO, c_Pedido, c_Item, NFI->ADI_COD, NFI->IDI_COD, NFI->MNY_BC_II, NFI->MNY_II})

RETURN .T.


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³DAdicImp  ³ Autor ³ Marcelo H. Sanches    ³ Data ³23/08/2014³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function DAdicImp()
// Variaveis Locais da Funcao
Local o_CodForn
Local o_Document
Local o_DtEmis
Local o_Filial
Local o_FilNome
Local o_ForNome
Local o_Local
Local o_LocalDes
Local o_loja
Local o_Processo
Local o_RefExt
Local o_Fornec
Local o_ForNome
Local o_ForLoja
Local o_Endereco
Local o_EndNome
Local o_Operacao
Local o_OpeNome
Local o_Segmento
Local o_SegNome
Local o_Transp
Local o_TraNome
Local o_TpFre
Local o_TpfNome
Local o_Proces
Local o_NumDI
Local o_DtDI
Local o_LocDes
Local o_LocDNome
Local o_ObsComp
Local o_UFDesem
Local o_UFDNome
Local o_PesoL
Local o_PesoB
Local nOpcc
Local _aArea   		:= {}
Local _aAlias  		:= {}
Private oDAdic
Private VISUAL := .F.                        
Private INCLUI := .F.                        
Private ALTERA := .F.                        
Private DELETA := .F.                        
c_CodForn	:= POSICIONE("SA2", 3, XFILIAL("SA2")+NFD->CNPJ, "A2_COD")
cLoja		:= Sa2->A2_Loja
Sa2->(DbSetOrder(1))
DEFINE MSDIALOG oDAdic TITLE "Parametros para Importação/Geração NFE" FROM C(263),C(662) TO C(676),C(1278) PIXEL
	CtrlArea(1,@_aArea,@_aAlias,{"SA1", "SA2", "SF2", "SD2", "SF4", "SD3", "SB1", "SE2"}) // GetArea
		@ C(002),C(010) Say "Processo: " Size C(020),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(010),C(000) MsGet o_Processo Var c_Processo Size C(025),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Processo:bWhen	:= {||c_Processo:=AllTrim(Str(NFD->Processo)), .F. }

		@ C(002),C(050) Say "Documento: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		c_Document:=STR(NFD->DOC_COD)
		@ C(010),C(042) MsGet o_Document Var c_Document Size C(035),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Document:bWhen	:= {|| .F. }

		@ C(002),C(090) Say "Ref. Externa: " Size C(025),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		c_RefExt:=NFD->REFEXT
		@ C(010),C(090) MsGet o_RefExt Var c_RefExt Size C(040),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_RefExt:bWhen	:= {|| .F. }

		@ C(002),C(135) Say "Dt. Emissão: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(010),C(135) MsGet o_DtEmis Var d_DtEmis Size C(025),C(009) COLOR CLR_BLACK Picture "@E" PIXEL OF oDAdic
		o_DtEmis:bWhen	:= {|| .F. }

		@ C(002),C(170) Say "Fornecedor: " Size C(030),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		c_CodForn	:=	Sa2->A2_Cod
		@ C(010),C(170) MsGet o_CodForn Var c_CodForn F3 "SA2" Size C(030),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic

		c_Loja		:=	Sa2->A2_Loja
		@ C(010),C(200) MsGet o_loja Var c_loja Size C(010),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic

		c_ForNome	:=	Sa2->A2_Nome
		@ C(010),C(210) MsGet o_ForNome Var c_ForNome Size C(100),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_ForNome:bWhen	:= {|| .F. }

		@ C(025),C(022) Say "Local: " Size C(015),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(025),C(040) MsGet o_Local Var c_Local Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		@ C(025),C(065) MsGet o_LocalDes Var c_LocalDes Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic

		@ C(035),C(002) Say "Ponto Emissor: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(035),C(040) MsGet o_Filial Var c_Filial Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		@ C(035),C(065) MsGet o_FilNome Var c_FilNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic

		@ C(045),C(002) Say "Fornecedor: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		c_Fornec	:=	ForImp()
		c_ForNome:=	Space(Len(Sa2->A2_Nome))
		@ C(045),C(040) MsGet o_Fornec Var c_Fornec Size C(020),C(009) F3 "SA2" COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Fornec:bValid:={||!Empty(c_Fornec).And.ChkForn(c_Fornec)}

		@ C(045),C(070) MsGet o_ForLoja Var c_ForLoja Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_ForLoja:bValid:={||!Empty(c_ForLoja).And.ChkForn(c_ForLoja)}

		@ C(045),C(080) MsGet o_ForNome Var c_ForNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_ForNome:bWhen:={||c_ForNome:=Posicione("SA2", 1, xFilial("SA2")+c_Fornec+c_ForLoja, "A2_NOME"), .f.}

		@ C(055),C(002) Say "Endereço: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(055),C(040) MsGet o_Endereco Var c_Endereco Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Endereco:bWhen:={||c_Endereco:=Posicione("SA2", 1, xFilial("SA2")+c_Fornec+c_ForLoja, "A2_END"), .f.}

		@ C(055),C(065) MsGet o_EndNome Var c_EndNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Endereco:bWhen:={||c_EndNome:=Posicione("SA2", 1, xFilial("SA2")+c_Fornec+c_ForLoja, "A2_COMPL"), .f.}

		@ C(065),C(002) Say "Operação: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(065),C(040) MsGet o_Operacao Var c_Operacao F3 "DJ" Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		@ C(065),C(065) MsGet o_OpeNome Var c_OpeNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Operacao:bValid:={||ExistCpo("SX5","DJ"+M->c_Operacao) .And. ChkOpera(c_Operacao)}
		o_OpeNome:bWhen:={||ChkOpera(c_OpeNome)}
		@ C(075),C(002) Say "Segmento: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(075),C(040) MsGet o_Segmento Var c_Segmento F3 Posicione("SX3",2,"F1__SEGISP", "X3_F3") Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Segmento:bValid:=&("{||("+StrTran((Posicione("SX3",2,"F1__SEGISP", "X3_VALID")), "F1__SEGISP", "C_SEGMENTO")+")}")
		@ C(075),C(065) MsGet o_SegNome Var c_SegNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic

		@ C(085),C(002) Say "Transportadora: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(085),C(040) MsGet o_Transp Var c_Transp F3 Posicione("SX3",2,"F1_TRANSP", "X3_F3") Size C(025),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Transp:bValid:=&("{||("+StrTran((Posicione("SX3",2,"F1_TRANSP", "X3_VALID")), "F1_TRANSP", "C_TRANSP")+") }")
		@ C(085),C(070) MsGet o_TraNome Var c_TraNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_TraNome:bWhen:={||c_TraNome:=Posicione("SA4",1,xFilial("SA4")+c_Transp, "A4_NOME"), .f.}

		@ C(095),C(002) Say "Tipo de Frete:" Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(095),C(040) MsGet o_TpFre Var c_TpFre F3 "SYJ" Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_TpFre:bValid:={||Vazio() .OR. ExistCpo("SYJ",M->c_TpFre) }
		@ C(095),C(065) MsGet o_TpfNome Var c_TpfNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_TpfNome:bWhen:={||cTpfNome:=Posicione("SYJ", 1, xFilial("SYJ")+c_TpFre, "YJ_DESCR" ) }

		@ C(105),C(002) Say "Processo: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(105),C(040) MsGet o_Proces Var c_Proces Size C(060),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_Proces:bWhen	:= {||c_Proces:=AllTrim(Str(NFD->Processo)), .F. }

		@ C(105),C(120) Say "Numero DI: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(105),C(140) MsGet o_NumDI Var c_NumDI Size C(040),C(009) COLOR CLR_BLACK Picture "@R 99.99999999-99" PIXEL OF oDAdic
		o_NumDI:bWhen:={||c_NumDI:=AllTrim(Str(NFI->CDI_COD)), .f.}

		@ C(105),C(200) Say "Data DI: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(105),C(220) MsGet o_DtDI Var d_DtDI Size C(020),C(009) COLOR CLR_BLACK Picture "@D" PIXEL OF oDAdic
		o_DtDI:bWhen:={||d_DtDI:=NFD->DATA_REGDI, .f.}

		@ C(115),C(002) Say "Local Desembaraço: " Size C(065),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(115),C(040) MsGet o_LocDes Var c_LocDes Size C(010),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_LocDes:bWhen:={||c_LocDes:=Transform(NFD->UFDes, "@!"), .f.}
		@ C(115),C(065) MsGet o_LocDNome Var c_LocDNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_LocDNome:bWhen:={||c_LocDNome:=Transform(NFD->LocDes, "@!"), .f.}

		@ C(125),C(002) Say "Obs. Compl.: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(125),C(040) MsGet o_ObsComp Var c_ObsComp Size C(120),C(009) COLOR CLR_BLACK Picture "@s100" PIXEL OF oDAdic

		@ C(135),C(002) Say "UF Desembaraço: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(135),C(040) MsGet o_UFDesem Var c_UFDesem F3 "12" Size C(020),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_UFDesem:bWhen:={||c_UFDesem:=Transform(NFD->UFDES, "!!"), .f.}
		
		o_UFDesem:bValid:={||Vazio() .OR. ExistCpo("SX5","12"+M->c_UFDESEM) } 
		@ C(135),C(065) MsGet o_UFDNome Var c_UFDNome Size C(125),C(009) COLOR CLR_BLACK Picture "@!" PIXEL OF oDAdic
		o_UFDNome:bWhen:={||ChkUFDes(c_UFDesem), .f.}

		@ C(135),C(190) Say "Data Desembaraço" Size C(055),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		d_DtDesem:=NFD->DTDES
		@ C(135),C(230) MsGet o_DtDesem Var d_DtDesem Size C(020),C(009) COLOR CLR_BLACK Picture "@D" PIXEL OF oDAdic
		o_DtDesem:bWhen:={||d_DtDesem:=NFD->DTDES, .f.}
//Pesos são sugeridos autmaticamente do arquivo de cabeçalho do despachante, porem, são editáveis, para possiveis correções.		
		@ C(145),C(002) Say "Peso Liquido: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(145),C(040) MsGet o_PesoL Var n_PesoL Size C(050),C(009) COLOR CLR_BLACK Picture "@e 99,999,999.9999" PIXEL OF oDAdic
		o_PesoL:bWhen:={||n_PesoL:=NFD->PESOLT, .t.}
		o_PesoL:bValid:={||n_PesoL>0}

		@ C(145),C(100) Say "Peso Bruto: " Size C(035),C(008) COLOR CLR_BLACK PIXEL OF oDAdic
		@ C(145),C(120) MsGet o_PesoB Var n_PesoB Size C(050),C(009) COLOR CLR_BLACK Picture "@e 99,999,999.9999" PIXEL OF oDAdic
		o_PesoB:bWhen:={||n_PesoB:=NFD->PESOBT, .t.}
		o_PesoB:bValid:={||n_PesoB>0}
//Botões de opções da rotina Ok - Confirma a execução <> Cancel - Cancela e retorna para o menu de documentos de entrada
		@ c(170),c(30) BmpButton Type 1 Action Eval({||nOpcc:=1, If(VldAdImp(), Close(oDAdic), MsgInfo("Dados Incompletos ou incorretos!", "Problema nos dados") ) })
		@ c(170),c(80) BmpButton Type 2 Action Eval({||nOpcc:=2, Close(oDAdic)})

	CtrlArea(2,_aArea,_aAlias) 

ACTIVATE MSDIALOG oDAdic CENTERED 

Return(If(nOpcc==2, .f., .T.))

/*********************/
Static Function C(nTam)                                                         
/*********************/
Local nHRes	:=	oMainWnd:nClientWidth	// Resolucao horizontal do monitor     
	If nHRes == 640	// Resolucao 640x480 (soh o Ocean e o Classic aceitam 640)  
		nTam *= 0.8                                                                
	ElseIf (nHRes == 798).Or.(nHRes == 800)	// Resolucao 800x600                
		nTam *= 1                                                                  
	Else	// Resolucao 1024x768 e acima                                           
		nTam *= 1.28                                                               
	EndIf                                                                         
                                                                                
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿                                               
	//³Tratamento para tema "Flat"³                                               
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ                                               
	If "MP8" $ oApp:cVersion                                                      
		If (Alltrim(GetTheme()) == "FLAT") .Or. SetMdiChild()                      
			nTam *= 0.90                                                            
		EndIf                                                                      
	EndIf                                                                         
Return Int(nTam)                                                                

/*****************************************************/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)                       
/*****************************************************/
Local _nN                                                                    
	// Tipo 1 = GetArea()                                                      
	If _nTipo == 1                                                             
		_aArea   := GetArea()                                                    
		For _nN  := 1 To Len(_aArqs)                                             
			DbSelectArea(_aArqs[_nN])                                              
			AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})                          
		Next                                                                     
	// Tipo 2 = RestArea()                                                     
	Else                                                                       
		For _nN := 1 To Len(_aAlias)                                             
			DbSelectArea(_aAlias[_nN,1])                                           
			DbSetOrder(_aAlias[_nN,2])                                             
			DbGoto(_aAlias[_nN,3])                                                 
		Next                                                                     
		RestArea(_aArea)                                                         
	Endif                                                                      
Return Nil                                                                   
/************************/
Static Function VldAdImp()
/************************/
Local lRet:=.t.

Return lRet


/**************************/
Static Function ChkForn(_P)
/**************************/
Local lRet:=.t.
If AllTrim(Upper(ReadVar()))=="C_FORLOJA"
	If !Sa2->(DbSeek( xFilial("SA2")+c_Fornec+_P ))
		MsgStop("Codigo inválido !","Loja Inválido")
		lRet:=.f.
	
	EndIf
ElseIf AllTrim(Upper(ReadVar()))=="C_FORNEC"
	If !Sa2->(DbSeek( xFilial("SA2")+_P ))
		MsgStop("Codigo inválido !","Fornecedor Inválido")
		lRet:=.f.
	
	EndIf

EndIf

Return lRet

/***********************/
Static Function ChkDI(_P)
/***********************/
Local lRet:=.t.
Local cQry:=""
cQry+="SELECT "+Chr(13)
cQry+="	COUNT(*) QTDS "+Chr(13)
cQry+="FROM "+Chr(13)
cQry+="	"+RetSqlName("CD5")+" "+Chr(13)
cQry+="WHERE "+Chr(13)
cQry+="	CD5_NDI='"+AllTrim(_P)+"' "+Chr(13)
cQry+="	AND D_E_L_E_T_=' ' "+Chr(13)
If TcSqlExec(cQry)=0
	DbUseArea(.t., "TOPCONN", TcGenQry(,, cQry), "CONTADOR" )
	nQtds:=CONTADOR->QTDS
	CONTADOR->(DbCloseArea())

Else
	MsgStop("Não foi possível executar query: "+cqry+".", "VERIFIQUE")
	lRet:=.f.

EndIf

If nQTDS>0
		MsgStop("Codigo inválido !","DI ja utilizada em outra nota ")
		lRet:=.f.
	
EndIf

Return lRet
/**************************/
Static Function ChkUFDes(_P)
/**************************/
Local lRet:=.t.
Local aEstados := {}
Local aRet     := {}
Local cUfs     := ""
Local lCkb
Local lInv     := .F.
Local nX
Local nQt      := 0
Local lRet     := .T.
Local cQry:=""
cQry+="SELECT "+Chr(13)
cQry+="	X5_CHAVE "+Chr(13)
cQry+="	, X5_DESCRI "+Chr(13)
cQry+="FROM "+Chr(13)
cQry+="	"+RetSqlName("SX5")+" "+Chr(13)
cQry+="WHERE "+Chr(13)
cQry+="	X5_TABELA='12' "+Chr(13)
cQry+="	AND LTRIM(RTRIM(X5_CHAVE)) = '"+AllTrim(_P)+"' "+Chr(13)
cQry+="	AND D_E_L_E_T_=' ' "+Chr(13)
If TcSqlExec(cQry)=0
	DbUseArea( .t., "TOPCONN", TcGenQry(,,cQry), "Estados" )
	c_UFDNome:=Estados->X5_Descri
	If Estados->(Eof())
		c_UFDNome:=Space(30)
		lRet:=.f.
		MsgStop("Estado informado inválido !", "Verifique dado informado")

	EndIf

	Estados->(DbCloseArea())

Else
	MsgStop("Não foi possível executar query: "+cqry+".", "VERIFIQUE")
	lRet:=.f.

EndIf

Return lRet

/**********************/
Static Function ForImp()
/**********************/
Local cRet
Local cQry:=""
cQry+="SELECT A2_COD, A2_LOJA FROM "+RetSqlName("SA2")+" WHERE A2_NOME LIKE '"+SubStr(NFD->FORNOME,1,30)+"%' AND D_E_L_E_T_=' ' "
If TcSqlExec(cQry)=0
	DbUseArea( .t., "TOPCONN", TcGenQry(,, cQry), "TMPFOR" )
	cRet:=TMPFor->A2_Cod
	c_ForLoja:=TMPFor->A2_Loja
	TMPFor->(DbCloseArea())

Else
	MsgStop("Não foi possível executar query: "+cqry+".", "VERIFIQUE")

EndIf

Return cRet

/*************************/
Static Function ChkOpera()
/*************************/
Local lRet:=.t.
ChkFile("SFM")
If Upper(ReadVar())="C_OPERACAO"
	If Empty(c_OpeNome:=Posicione("SFM", 1, xFilial("SFM")+c_Operacao, "FM_TE"))
		MsgStop("Operação Não Cadastrada", "Verifique informação")
		lRet:=.f.

ElseIf Upper(ReadVar())="C_OPENOME"
	If Empty(c_OpeNome:=Posicione("SFM", 1, xFilial("SFM")+c_Operacao, "FM_TE"))
		MsgStop("Operação Sem TES Cadastrada", "Verifique informação")
		lRet:=.f.

EndIf

Return lRet
/*
SELECT 
   * 
FROM 
   CONEXOS.VIEW_INT_NFE_ITENS@MSVSIM_CONEXOS DET LEFT OUTER JOIN  
   CONEXOS.VIEW_INT_NFE@MSVSIM_CONEXOS CAB ON DET.FIL_COD=CAB.FIL_COD AND DET.DOC_TIP=CAB.DOC_TIP AND DET.DOC_COD=CAB.DOC_COD
WHERE DET.DOC_COD = '58530';




f1__proimp


sz2 - CAB Z2_CODPROC = F1__PROIMP == Z2_CODIGO
sz3 - ITEM = Z3_CODIGO=Z2_CODIGO E Z3_PRODUTO=NFI->NFI->PRD_ESP_COD_EXTERNO >> Z3_PEIDO Z3_ITPEDCO

*/
