#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o 	 ³ IFATA015 ³ Autor ³ Roberto Marques       ³ Data ³ 19/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para Alterações de Preços  - Nacional             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Alteração de Preço para Produto Nacional 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IFATA38()

Local _aArea       := getArea()

Private aEdit	   := {"VLNOVO", "DTNOVO"}
Private cIdDe      := Replicate(" ",4)
Private cIdAte     := Replicate("Z",4)
Private cGrpDe     := Space(TamSX3("Z4_CODIGO")[1])
Private cGrpAte    := Replicate("Z",TamSX3("Z4_CODIGO")[1])
Private cCodDe     := Space(TamSX3("B1_COD")[1])
Private cCodAte    := Replicate("Z",TamSX3("B1_COD")[1])
Private cDescr     := Space(60)
Private cCodPro	   := Space(15)

Private cPorc      := 0.00
Private cPrcAte    := 0.00
Private cPrcDe     := 0
Private aHeadsc    := {}
Private aColssc    := {}

aColssc := {} // Inicializa o ACOLS da Sugestão de Compra

SetPrvt("oDlgTbPrc","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oSay12","oSay13","oSay14","oSay15","oIdDE","oIdAte","oGrpDe","oGrpAte","oCodDe","oCodAte","oDescr")
SetPrvt("oBtnPsq","oMarcDe","oMarcAte","oDtDe","oDtAte","oPrcDe","oPrcAte","oCBOrd","oCBSta","oBrw1")
SetPrvt("oSay16","oBtnImpr","oBtnImAlt","oBtnTodo","oPorc","oBtnAltPrc","oBtnDsc","oBtnProc","oBtnSair")

// Inicialização do Vetores da Getdados
aAdd(aHeadsc,{"Produto"             , "PROD"     	, ""  		    ,10,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Descrição"           , "DESC"     	, ""  		    ,35,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Dt Reposição"   		, "DTREP"    	, ""  		    ,10,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"FOB (US$)"    		, "FOB"  		,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Valor Reposição"   	, "VLREP"  		,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Cus to"       		, "CUSTO"    	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Preço Tabela"        , "PRTAB"    	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Dt Validade"    		, "DTVAL"    	,""			    ,10,0,"" ,""  ,"D" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Preço Novo"     	 	, "VLNOVO"   	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Dt Nova Validade"   	, "DTNOVO"    	, "" 		    ,10,0,"" ,""  ,"D" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Preço Desconto"      , "VLDESC"   	,"@E 99,999.99" ,10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Multiplicador"  		, "MARGEM"		,"@E 99,999.99" ,10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})

aSize := MsAdvSize(.T.)
aObjects := {}

AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )

oDlgTbPrc  := MSDialog():New( aSize[7],0,aSize[6],aSize[5],"Alterações de Preços por Sub Grupo",,,.F.,,,,,,.T.,,,.T. )

oGrp1      := TGroup():New( 004,004,084,aPosObj[2,4],"Seleção",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )

oSay1      := TSay():New( 016,008,{||"Identificação De"}	,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oIdDE      := TGet():New( 016,060,{|u| If(PCount()>0,cIdDe:=u,cIdDe)}		,oDlgTbPrc,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdDe",,)

oSay2      := TSay():New( 028,008,{||"Identificação Até"}	,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oIdAte     := TGet():New( 028,060,{|u| If(PCount()>0,cIdAte:=u,cIdAte)}		,oDlgTbPrc,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdAte",,)

oSay3      := TSay():New( 016,108,{||"Sub Grupo De"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGrpDe     := TGet():New( 016,152,{|u| If(PCount()>0,cGrpDe:=u,cGrpDe)}		,oDlgTbPrc,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ4","cGrpDe",,)

oSay4      := TSay():New( 028,108,{||"Sub Grupo Até"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oGrpAte    := TGet():New( 028,152,{|u| If(PCount()>0,cGrpAte:=u,cGrpAte)}	,oDlgTbPrc,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ4","cGrpAte",,)

oSay5      := TSay():New( 016,184,{||"Produto De"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oCodDe     := TGet():New( 016,220,{|u| If(PCount()>0,cCodDe:=u,cCodDe)}		,oDlgTbPrc,060,008,'',{||fPsqSB1A()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodDe",,)

oSay6      := TSay():New( 028,184,{||"Produto Até"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oCodAte    := TGet():New( 028,220,{|u| If(PCount()>0,cCodAte:=u,cCodAte)}	,oDlgTbPrc,060,008,'',{||fPsqSB1B()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodAte",,)

oSay7      := TSay():New( 016,288,{||"Por Item"}   				,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oDescr     := TGet():New( 016,320,{|u| If(PCount()>0,cDescr:=u,cDescr)}		,oDlgTbPrc,136,008,'',/*{||fPsqSB1C()}*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescr",,)

oBtnLmp    := TButton():New( 016,480,"Limpar"	,oDlgTbPrc,{||fuLimpar()} ,037,012,,,,.T.,,"",,,,.F. )
oBtnPsq    := TButton():New( 048,480,"Filtrar"	,oDlgTbPrc,{||Processa({|| fuPesqTAB() },"Buscando os registros...",,.T.)},037,012,,,,.T.,,"",,,,.F. )

oBrw1		:= MsNewGetDados():New(	092	,;	//01 -> nTop		Linha Inicial
									004	,;	//02 -> nLelft		Coluna Inicial
									aPosObj[2,3],;	//03 -> nBottom		Linha Final
									aPosObj[2,4],;	//04 -> nRight      Coluna Final
									GD_DELETE+GD_UPDATE	,;	//05 -> nStyle:		Controle do que podera ser realizado na GetDado
									{ || fValid() }	,;	//06 -> ulinhaOK:	Funcao ou CodeBlock para validar a edicao da linha
									{ || .T. }		,;	//07 -> uTudoOK: 	Funcao ou CodeBlock para validar todas os registros da GetDados
									NIL				,;	//08 -> cIniCpos:	Campo para Numeracao Automatica
									aEdit			,;	//09 -> aAlter: 	Array unidimensional com os campos Alteraveis
									0				,;	//10 -> nfreeze:	Numero de Colunas para o Freeze
									Len( aColssc )	,; 	//11 -> nMax:		Numero Maximo de Registros na GetDados
									"U_fValOrA()"	,;	//12 -> cFieldOK:	?
									NIL				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
									,;  //{ || .F. },;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
									oDlgTbPrc		,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
									aHeadsc			,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
									aColssc			 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
									)

oBrw1:aCols := {}
oBrw1:oBrowse:Refresh()

oGrp2      := TGroup():New( aPosObj[2,3]+5,004,aPosObj[2,3]+30,aPosObj[2,4],"",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay16     := TSay():New( aPosObj[2,3]+13,192,{||"% Preço Novo"},oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oBtnTodo   := TButton():New( aPosObj[2,3]+10,132,"Marcar Todos"			,oDlgTbPrc,{||fMarcaTds()		},052,012,,,,.T.,,"",,,,.F. )
oPorc      := TGet():New( aPosObj[2,3]+13,232,{|u| If(PCount()>0,cPorc:=u,cPorc)},oDlgTbPrc,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPorc",,)
//oBtnAltPrc := TButton():New( aPosObj[2,3]+10,316,"Alterar Preço"		,oDlgTbPrc,{||U_iFata38A()		},037,012,,,,.T.,,"",,,,.F. )
//oBtnDsc    := TButton():New( aPosObj[2,3]+10,360,"Desconto" 			,oDlgTbPrc,{||fDescont() },037,012,,,,.T.,,"",,,,.F. )
oBtnProc   := TButton():New( aPosObj[2,3]+10,404,"Processar"			,oDlgTbPrc,{||fProc()			},037,012,,,,.T.,,"",,,,.F. )
oBtnSair   := TButton():New( aPosObj[2,3]+10,488,"Sair"					,oDlgTbPrc,{||oDlgTbPrc:End()	},037,012,,,,.T.,,"",,,,.F. )

oDlgTbPrc:Activate(,,,.T.)

restarea(_aArea)

Return

Static Function fDescont()

Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local lRet      := .T.
Local _cOrigem	:= ""

If Len(oBrw1:Acols) != 0
	
	_cOrigem := Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[oBrw1:nat][nPosProd],"B1_ORIGEM")
	
	If  _cOrigem == "0"                              
		
		MsgInfo(OemToAnsi("Produto de origem nacional. Preço não pode ser alterado !!"))
		lRet := .F.
	Else
		U_iFata38E(oBrw1:aCols[oBrw1:nat,1])
		
	EndIf
Else
	
	U_iFata38E()
	
Endif

Return lRet

Static Function  fuPesqTAB()

Local _nLin
Local mSQL      := ""
local nFOB      := 0
LOcal nMag      := 0
Local nMargem   := 0
Local nValor    := 0
Local cData     := Ctod("  /  /  ")
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosDtRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTREP" 	})
Local nPosFOB	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "FOB" 	})
Local nPosVlRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLREP" 	})
Local nPosCusto	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "CUSTO" 	})
Local nPosPrTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRTAB" 	})
Local nPosDTVAL	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTVAL" 	})
Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosVlDsc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLDESC" 	})
Local nPosMarge	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARGEM" 	})
Local nQtdCpo   := 0
Local nCols     := 0

oBrw1:aCols := {}
nQtdCpo := Len(aHeadsc)
nn:=0

IF SELECT("TDA1") > 0
	dbSelectArea("TDA1")
	TDA1->(dbCloseArea())
Endif

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	cSegto := SZ1->Z1_SEGISP
Else
	cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])
Endif

mSQL := " SELECT B1_COD,MAX(B1_DESC) B1_DESC, MAX(DA1_DATVIG) DA1_DATVIG, MAX(Z8_ORDEM) Z8_ORDEM, MAX(DA1_PRCVEN) DA1_PRCVEN, " +Chr(13)
mSQL += " MAX(Z9_SEQ) Z9_SEQ,MAX(D1_EMISSAO) DTREP,MAX(D1_VUNIT) VLRREP, MAX(C7_PRECO) CUSTO, MAX(C7_EMISSAO) DTPED " +Chr(13)
mSQL += " FROM "+RetSqlName("SB1")+" SB1 " +Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("DA1")+" DA1 ON DA1_FILIAL = '"+xFilial("DA1")+"' AND DA1_CODTAB = '"+Alltrim(GetMv("MV__TABBRA"))+"' AND " +Chr(13)
mSQL += " DA1_CODPRO = B1_COD AND DA1_ESTADO = '  ' AND DA1.D_E_L_E_T_ = ' ' "  +Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_COD = B1_COD AND SD1.D_E_L_E_T_ = ' ' " +Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL = '"+xFilial("SC7")+"' AND D1_PEDIDO = C7_NUM AND SC7.D_E_L_E_T_ = ' ' " +Chr(13)
mSQL += " INNER JOIN "+RetSqlName("SZ4")+" SZ4 ON Z4_CODIGO = B1__SUBGRP AND SZ4.D_E_L_E_T_ = ' ' " +Chr(13)
mSQL += " LEFT JOIN " +RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL = '"+xFilial("SZ9")+"' AND Z9_PRODUTO = B1_COD AND " +Chr(13)
mSQL += " Z9_COD Between '"+cIdDe+"' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' " +Chr(13)
mSQL += " LEFT  JOIN "+RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL = Z9_FILIAL AND Z9_COD = Z8_COD And SZ8.D_E_L_E_T_ = ' ' " +Chr(13)  

mSQL += " INNER JOIN (SELECT DA1_CODPRO, " + Chr(13)
mSQL += "       MAX(DA1.R_E_C_N_O_) RECNO " + Chr(13)
mSQL += " FROM "+RetSqlName("DA1")+" DA1 " + Chr(13)
mSQL += " WHERE DA1_ESTADO='  ' AND D_E_L_E_T_=' ' AND DA1_FILIAL='"+xFilial("DA1")+"'" + Chr(13)
mSQL += " GROUP BY DA1_CODPRO) TMP ON TMP.RECNO = DA1.R_E_C_N_O_ " + Chr(13)

mSQL += " WHERE B1_FILIAL = '"+xFilial("SB1")+"' " +Chr(13)

If !Empty(cCodDe)
	mSQL += " And B1_COD BETWEEN '"+cCodDe+"' AND '"+cCodAte+"' " +Chr(13)
EndIf

If !Empty(cGrpDe)  
	mSQL += " AND TO_NUMBER(NVL(TRIM(B1__SUBGRP),'0')) BETWEEN TO_NUMBER('"+cGrpDe+"')  AND TO_NUMBER('"+cGrpAte+"')
	//mSQL += " And B1__SUBGRP BETWEEN '"+cGrpDe+"' AND '"+cGrpAte+"' " +Chr(13)
EndIf

mSQL += " AND SB1.D_E_L_E_T_ = ' ' " +Chr(13)

If Val(cSegto) > 0
	mSQL += " And B1__SEGISP = '"+cSegto+"' " +Chr(13)
EndIf

If !Empty(cDescr)
	mSQL += " And B1__DESCP Like '%"+Alltrim(cDescr)+"%' " +Chr(13)
EndIf

mSQL += " GROUP BY B1_COD " +Chr(13)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
TDA1->( DbGoTop() )

If TDA1->(!Eof())
	
	While TDA1->(!EOF())
		
		mSQL := " SELECT C7_PRODUTO,C7_NUM,C7_EMISSAO,C7_PRECO "
		mSQL += " FROM "+RetSqlName("SC7")+" SC7 "
		mSQL += " WHERE C7_PRODUTO='"+TDA1->B1_COD+"' AND C7_EMISSAO <'"+TDA1->DTPED+"' AND ROWNUM =1 "
		
		IF SELECT("TMP") > 0
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		Endif
		
		nFOB := 0
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
		TMP->( DbGoTop() )
		nFOB := TMP->C7_PRECO
		TMP->(dbCloseArea())
		
		nPrcDesc := TDA1->DA1_PRCVEN - (TDA1->DA1_PRCVEN * fPERDES(TDA1->B1_COD) /100)
		nMargem	 := nPrcDesc / nFob
		
		AAdd(oBrw1:aCols, Array(nQtdCpo+1))
		nn++
		
		oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
		oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
		oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
		oBrw1:Acols[nn][nPosFOB]			:= nFOB
		oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
		oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO
		oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN
		oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DA1_DATVIG)
		oBrw1:Acols[nn][nPosVlNv]			:= nValor
		oBrw1:Acols[nn][nPosDtNv]			:= cData
		oBrw1:Acols[nn][nPosVlDsc]			:= nPrcDesc
		oBrw1:Acols[nn][nPosMarge]			:= nMargem
		oBrw1:Acols[nn][Len(aHeadsc)+1] 	:= .F.
		
		TDA1->(DbSkip())
		
	Enddo
	
	oBrw1:nat:=len(oBrw1:Acols)
	
Else
	MsgInfo(OemToAnsi("Nenhum Produto Encontrado na Tabela de Preço dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
Endif
TDA1->(dbCloseArea())

oBrw1:Refresh()

Return

Static Function fPERDES(cCodP)

Local mSQL := ""
Local nValor := 0

mSQL += "SELECT ACP_PERDES FROM " + RetSqlName("ACP")+" ACP
mSQL += " WHERE  ACP_FILIAL='"+xFILIAL("ACP")+"' AND ACP.D_E_L_E_T_ = ' ' "
mSQL += " AND ACP_CODREG ='"+ Alltrim(getMV("MV__DSCCBR")) +"' AND ACP_CODPRO='"+cCodP+"' AND ROWNUM = 1 "

IF SELECT("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
Endif

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
TMP->( DbGoTop() )
nValor	:= ACP_PERDES
TMP->(dbCloseArea())

Return nValor

Static Function fMarcaTds()

Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosDtRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTREP" 	})
Local nPosFOB	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "FOB" 	})
Local nPosVlRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLREP" 	})
Local nPosCusto	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "CUSTO" 	})
Local nPosPrTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRTAB" 	})
Local nPosDTVAL	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTVAL" 	})
Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosVlDsc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLDESC" 	})
Local nPosMarge	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARGEM" 	})
Local nQtdCpo   := 0
Local nCols     := 0
Local dDataNw

dDataNw := oBrw1:Acols[oBrw1:nAt][nPosDtNv]
nVlrnW  := oBrw1:Acols[oBrw1:nAt][nPosVlNv]

If cPorc <> 0.00
	for x:=1 to len(oBrw1:Acols)
		oBrw1:Acols[x][nPosVlNv]	:= oBrw1:Acols[x][nPosPrTab]+(oBrw1:Acols[x][nPosPrTab]*cPorc /100)
		if oBrw1:Acols[x][nPosDtNv] = Ctod("  /  /  ")
			oBrw1:Acols[x][nPosDtNv]	:= dDataNw
		Endif
	next x
Else
	for x:=1 to len(oBrw1:Acols)
		IF	oBrw1:Acols[x][nPosVlNv] == 0.00
			oBrw1:Acols[x][nPosVlNv] := nVlrnW
		Endif
		IF	oBrw1:Acols[1][nPosDtNv] <> Ctod("  /  /  ")
			oBrw1:Acols[x][nPosDtNv]	:= dDataNw
		Endif
	next x
Endif

Return

Static Function fProc()

Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosDtRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTREP" 	})
Local nPosFOB	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "FOB" 	})
Local nPosVlRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLREP" 	})
Local nPosCusto	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "CUSTO" 	})
Local nPosPrTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRTAB" 	})
Local nPosDTVAL	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTVAL" 	})
Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosVlDsc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLDESC" 	})
Local nPosMarge	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARGEM" 	})
Local cSeg		:= "", _nRecDA1 := 0
Local cGrupo	:= ""
Local cSubGrp 	:= ""
Local nIPI		:= 0
Local lRet	:= .F.

if msgYesNo("Confirma o Processamento ?","Confirme")
	
	for x:=1 to len(oBrw1:Acols)
		
		if ! oBrw1:Acols[x][len(aHeadsc)+1]
			
			dbSelectArea( "DA1" )
			DA1->( dbSetOrder( 1 ) )
			
			IF	oBrw1:Acols[x][nPosVlNv] <> 0.00 .AND. oBrw1:Acols[x][nPosDtNv] <> Ctod("  /  /  ")
				
				cSeg   	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1__SEGISP")
				cGrupo 	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1_GRUPO")
				cSubGrp	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1__SUBGRP")
				nIPI 	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1_IPI")
				
				_nRecDA1 := IFindRec(Alltrim(GetMv("MV__TABBRA")),"  ",oBrw1:Acols[X][nPosProd],oBrw1:Acols[x][nPosDtNv])
				
				If _nRecDA1 > 0
					DbSelectArea("DA1")
					DbGoTo(_nRecDA1)
					While !Reclock("DA1",.f.)
					EndDo
					DA1->DA1_PRCVEN := oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("AV"))
					DA1->DA1__PREC2 := oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("30"))
					DA1->DA1__PREC3 := oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("3060"))
					DA1->DA1__PREC4 := oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("306090"))
					DA1->(MsUnlock())
				Else
					DbSelectArea("DA1")
					Reclock("DA1", .T.)
					DA1->DA1_FILIAL	:= xFILIAL("DA1")
					DA1->DA1_ITEM	:= Soma1(xContDA1())
					DA1->DA1_CODTAB	:= Alltrim(getMV("MV__TABBRA"))
					DA1->DA1_CODPRO	:= oBrw1:Acols[X][nPosProd]
					DA1->DA1_MOEDA	:= 1
					DA1->DA1_PRCVEN	:= oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("AV"))
					DA1->DA1__PREC2	:= oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("30"))
					DA1->DA1__PREC3	:= oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("3060"))
					DA1->DA1__PREC4	:= oBrw1:Acols[x][nPosVlNv]+(oBrw1:Acols[x][nPosVlNv] * fFator("306090"))
					DA1->DA1_ESTADO	:= "  "
					DA1->DA1_INDLOT	:= "00000000000999999.99"
					DA1->DA1_ATIVO	:= '1'
					DA1->DA1_DATVIG	:= oBrw1:Acols[x][nPosDtNv]
					DA1->DA1_QTDLOT	:= 999999.99
					DA1->DA1_TPOPER	:= '4'
					DA1->(MsUnLock())
					
				EndIf
				
				//GeraTbUF(oBrw1:Acols[X][nPosProd],cSeg,cGrupo,cSubGrp,oBrw1:Acols[x][nPosVlNv],oBrw1:Acols[x][nPosDtNv],nIPI)
				lRet := .T.
			ENDIF
		Endif
		
	next x
	
	if lRet == .T.
		MsgInfo(OemToAnsi("Alterações realizada com sucesso."))
	Else
		MsgInfo(OemToAnsi("Não foi processado nenhuma alteração na tabela de preço."),OemToAnsi("Atencao"))
	Endif
endif
Return

Static Function fValid()

Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})

lRet := .T.

if oBrw1:aCols[n][nPosVlNv] == 0 .AND. oBrw1:aCols[n][nPosDtNv] <> Ctod("  /  /  ")
	msgAlert ("O Valor tem que ser superior a zero. Favor verificar !!")
	lRet := .F.
endif

if oBrw1:aCols[n][nPosVlNv] > 0 .AND. oBrw1:aCols[n][nPosDtNv] == Ctod("  /  /  ")
	msgAlert ("A Nova data de Validade deve ser informada. Favor verificar !!")
	lRet := .F.
endif


Return lRet

Static Function GeraTbUF(cCodPro,cSeg,cGrupo,cSubGrp,nPreco,cData,nIPI)

Local mSQL    := ""
Local cTabBra := Alltrim(getMV("MV__TABBRA"))
Local cUF 	  := Alltrim(getMV("MV__TABPUF"))
Local aUF 	  := {}
Local nPrcTab := 0
Local iCt	  := .F., _nRecDA1 := 0

aUF	:= Separa(cUF, ',')

For i:=1 to Len(aUF)
	
	nPrcTab := fReajt(aUF[i],cSeg,cGrupo,cSubGrp,nPreco,nIPI,cCodPro)
	
	IF SELECT("TDA1") > 0
		dbSelectArea("TDA1")
		TDA1->(dbCloseArea())
	Endif
	
	_nRecDA1 := IFindRec(Alltrim(GetMv("MV__TABBRA")),aUF[i],cCodPro,cData)
	
	_PrAV    := nPrcTab+(nPrcTab * fFator("AV"))
	_Pr2     := nPrcTab+(nPrcTab * fFator("30"))
	_Pr3     := nPrcTab+(nPrcTab * fFator("3060"))
	_Pr4     := nPrcTab+(nPrcTab * fFator("306090"))
	
	If _nRecDA1 > 0
		
		DbSelectArea("DA1")
		DbGoTo(_nRecDA1)
		While !Reclock("DA1",.f.)
		EndDo
		DA1->DA1_PRCVEN := _PrAV
		DA1->DA1__PREC2 := _Pr2
		DA1->DA1__PREC3 := _Pr3
		DA1->DA1__PREC4 := _Pr4
		DA1->(MsUnlock())
		
	Else
		
		DbSelectArea("DA1")
		Reclock("DA1", .T.)
		DA1->DA1_FILIAL	:= xFILIAL("DA1")
		DA1->DA1_ITEM	:= Soma1(xContDA1())
		DA1->DA1_CODTAB	:= cTabBra
		DA1->DA1_CODPRO	:= cCodPro
		DA1->DA1_MOEDA	:= 1
		DA1->DA1_PRCVEN := _PrAV
		DA1->DA1__PREC2 := _Pr2
		DA1->DA1__PREC3 := _Pr3
		DA1->DA1__PREC4 := _Pr4
		DA1->DA1_ESTADO	:= aUF[i]
		DA1->DA1_INDLOT	:= "00000000000999999.99"
		DA1->DA1_ATIVO	:= '1'
		DA1->DA1_DATVIG	:= cData
		DA1->DA1_QTDLOT	:= 999999.99
		DA1->DA1_TPOPER	:= '4'
		DA1->(MsUnLock())
	EndIf
Next

Return

// Rotina para pegar o Fator de Prazo de Pagamento
Static Function fFator(cFator)

Local mSQL :=""
Local nFT  := 0.0000

IF SELECT("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
Endif

if cFator == "AV"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='001' AND ZX5_SEGISP='2 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "30"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='002' AND ZX5_SEGISP='2 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "3060"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='003' AND ZX5_SEGISP='2 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "306090"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='004' AND ZX5_SEGISP='2 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Endif

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
TMP->( DbGoTop() )

IF TMP->(!Eof())
	nFT := Val(TMP->ZX5_DSCITE)
Endif

TMP->(dbCloseArea())

Return(nFT)

// Rotina de Reajuste dentro da Regra de Reajustes da Tabela
Static Function fReajt(cUF,cSeg,cGrupo,cSubGrp,nPreco,nIPI,cCodPro)
Local nRejt  := 0
Local nValor := 0

nRejt := fCalcRjt(cUF,cSeg,cGrupo,cSubGrp,nIPI,cCodPro)

nValor 	:= nPreco + (nPreco * (nRejt / 100))

Return(nValor)

Static Function fCalcRjt(cUF,cSeg,cGrupo,cSubGrp,nIPI,cCodPro)
Local nRejt  := _nAlqIPI := 0
// REGRAS PARA CALCULOS
// SEGMENTO + UF + SUBGRUPO + ALIQ
// SEGMENTO + UF + GRUPO + ALIQ
// SEGMENTO + UF + ALIQ
// SEGMENTO + UF + SUBGRUPO
// SEGMENTO + UF + GRUPO
// SEGMENTO + UF

//Verifica se existe regra de desconto ou acrescimo para a UF
DbSelectArea("SB1")
DbSetOrder(1)
MsSeek(xFilial("SB1") + cCodPro)

_nAlqIPI := IIF(Posicione("SYD",1,xFilial("SYD") + SB1->B1_POSIPI,"YD__ICMSST") == "1", SB1->B1_IPI, 0 )

DbSelectArea("Z13")
DbSetOrder(2)
If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + cUF + SB1->B1__SUBGRP + StrZero(_nAlqIPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2]))
	
	nRejt := Z13->Z13_REAJUS
	
Else
	DbSetOrder(3)
	If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + cUF + SB1->B1_GRUPO + StrZero(_nAlqIPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2]))
		
		nRejt := Z13->Z13_REAJUS
		
	Else
		DbSetOrder(4)
		If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + cUF + StrZero(_nAlqIPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2])) .And. Empty(Z13->Z13_GRUPO) .And. Empty(Z13->Z13_SUBGRP)
			
			nRejt := Z13->Z13_REAJUS
			
		Else
			DbSetOrder(5)
			If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + cUF + SB1->B1__SUBGRP)
				
				nRejt := Z13->Z13_REAJUS
				
			Else
				DbSetOrder(6)
				If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + cUF + SB1->B1_GRUPO)
					
					nRejt := Z13->Z13_REAJUS
					
				Else
					DbSetOrder(1)
					If MsSeek(xFilial("Z13") + cUF + SB1->B1__SEGISP + Space(TamSX3("B1_GRUPO")[1]) + Space(TamSX3("B1__SUBGRP")[1]))
						
						nRejt := Z13->Z13_REAJUS
						
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return(nRejt * -1)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o 	 ³ fTabLote ³ Autor ³ Roberto Marques       ³ Data ³ 25/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para Alterações de Preços  - Nacional -Lote       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Alteração de Preço para Produto Nacional em Lote			  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function iFata38A()

Local _aArea	    := getArea()
Private nOpc        := 1
private aButtons   	:= {}
private _dData	 	:= ctod("  /  /  ")
private oDlg		:= nil
private oGetTM1		:= nil

oFont := tFont():New("Tahoma",,-12,,.t.)

Aadd( aButtons, {"Excluir Todos", {|| fLtExcTd() }, "Excluir Todos", "Excluir Todos" , {|| .T.}} )

aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE "Alteração de Tabela de Preco por Lote" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

@ 10,10  Say "Data :"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 10,50  MsGet _dData  Size 50,10 of oDlg PIXEL FONT oFont 	Picture "@D"

lOk := .F.

montaAcols(nOpc)

ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=validar(nOpc)},{||oDlg:End()},,aButtons) })

restArea(_aArea)

Return

Static Function montaAcols(nOpc)

private aHeader	:= {}
private aCols	:= {}
private aEdit	:= {}

aEdit	:= {"DA1_CODPRO","PRCNV","PORC"}

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("DA1_CODPRO")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
						SX3->X3_Campo       ,;
						SX3->X3_Picture     ,;
						SX3->X3_Tamanho     ,;
						SX3->X3_Decimal     ,;
						"u_IFATA38B()"     ,;
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
If DbSeek("B1_DESC")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
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
If DbSeek("DA1_PRCVEN")
	aadd(aHeader, {Trim(SX3->X3_Titulo),;
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
aadd(aHeader, {"Preco Novo"			,;
				"PRCNV"     		,;
				"@E 999,999.99"     	,;
				9     		   	,;
				2     			,;
				"U_IFATA38pv()"			,;
				"€€€€€€€€€€€€€€",;
				"N"        		,;
				""	    	 	,;
				"R"				,;
				""		,;
				""		,;
				""})

aadd(aHeader, {"Porcen"			,;
				"PORC"      		,;
				"@E 999.99"     	,;
				6     		   	,;
				2     			,;
				"U_IFT38P()"			,;
				"€€€€€€€€€€€€€€",;
				"N"        		,;
				""	    	 	,;
				"R"				,;
				""		,;
				""		,;
				""})

Aadd(aHeader, {"Recno"		,"RECNO"	,"999999"		,6,0 ,".T.",,"N",,,,})

_cGds := GD_INSERT + GD_UPDATE + GD_DELETE

oGetTM1 := MsNewGetDados():New(40, 0, 270, 650, _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, ,9999, , , , oDlg, aHeader, aCols)

return

User function IFATA38B()

local _lVal := .T.
local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
local _cDescri	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_DESC" })
local _RECNO	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "RECNO" })

IF SELECT("TDA1") > 0
	dbSelectArea("TDA1")
	TDA1->(dbCloseArea())
Endif

mSQL := "SELECT B1_COD,         														" + Chr(13)
mSQL += "		B1_DESC,       															" + Chr(13)
mSQL += "		DA1_PRCVEN,    															" + Chr(13)
mSQL += "		DA1.R_E_C_N_O_ 															" + Chr(13)
mSQL += "FROM " + RetSqlName("SB1") + " SB1 											" + Chr(13)
mSQL += "LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1_FILIAL='" + xFilial("DA1") + "' " + Chr(13)
mSQL += "											AND DA1.D_E_L_E_T_ = ' '            " + Chr(13)
mSQL += "											AND B1_COD = DA1_CODPRO 			" + Chr(13)
mSQL += "LEFT JOIN (SELECT DA1_CODPRO, 													" + Chr(13)
mSQL += "       	 		MAX(DA1.R_E_C_N_O_) RECNO 									" + Chr(13)
mSQL += "			  FROM " + RetSqlName("DA1") + " DA1 								" + Chr(13)
mSQL += "			  WHERE DA1_ESTADO = '  '                                           " + Chr(13)
mSQL += "    				AND D_E_L_E_T_=' '                                          " + Chr(13)
mSQL += "    				AND DA1_FILIAL='" + xFilial("DA1") + "'						" + Chr(13)
mSQL += "    				AND DA1_CODTAB ='" + GetMv("MV__TABBRA") + "' 				" + Chr(13)
mSQL += "			  GROUP BY DA1_CODPRO) TMP ON TMP.RECNO = DA1.R_E_C_N_O_ 			" + Chr(13)
mSQL += "WHERE B1_FILIAL='"+xFilial("SB1")+"'                                           " + Chr(13)
mSQL += "		AND SB1.D_E_L_E_T_ =' '                                                 " + Chr(13)
mSQL += "    	AND SB1.B1_COD ='" + M->DA1_CODPRO + "'                             	"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
TDA1->( DbGoTop() )

If TDA1->(!Eof())
	aCols[n][_cDescri] 	:= TDA1->B1_DESC
	aCols[n][_PrcVend] 	:= TDA1->DA1_PRCVEN
	aCols[n][_RECNO] 	:= TDA1->R_E_C_N_O_
Else
	Aviso("Atenção!","Produto inválido ou bloqueado!",{"OK"})
	_lVal := .F.
EndIf

return _lVal

User Function IFATA38pv()

Local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
Local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
Local _lVal     := .T.

oGetTM1:Acols[oGetTM1:nat][_PORC] := ((M->PRCNV * 100) / oGetTM1:Acols[oGetTM1:nat][_PrcVend]) - 100

Return _lVal

User Function IFT38P()

local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
local _NV		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PRCNV" })
local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
local _lVal 	:= .T.
Local nValor

aCols[n][_NV] := aCols[n][_PrcVend] + (aCols[n][_PrcVend] * M->PORC) / 100

Return _lVal

static function validar(nOpc)
lOk := .T.

if empty(_dData)
	msgAlert ("Data deve ser preenchido. Favor verificar !!")
	lOk := .F.
endif

if len(oGetTM1:Acols) == 0
	Alert ("Nenhum produto lançado !!")
	lOk := .F.
endif

if lOk
	IFATA38C()
	oDlg:End()
endif
	
return lOk
	
Static function IFATA38C()

Local _CodPro	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_CODPRO" })
Local _nPRCNV	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PRCNV" })
Local _nPORC	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
Local cSeg		:= ""
Local cGrupo	:= ""
Local cSubGrp 	:= ""
Local lRet	    := .F.

for x:=1 to len(oGetTM1:Acols)
	
	If oGetTM1:Acols[x][Len(oGetTM1:aHeader) + 1]
		Loop
	EndIf
	
	dbSelectArea( "DA1" )
	DA1->( dbSetOrder( 1 ) )
	
	cSeg    := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1__SEGISP")
	cGrupo  := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1_GRUPO")
	cSubGrp := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1__SUBGRP")
	nIPI	:= Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1_IPI")
	
	_nRecDA1 := IFindRec(Alltrim(GetMv("MV__TABBRA")),"  ",oGetTM1:Acols[X][_CodPro],_dData)
	
	If _nRecDA1 > 0
		DbSelectArea("DA1")
		DbGoTo(_nRecDA1)
		While !Reclock("DA1",.f.)
		EndDo
		DA1->DA1_PRCVEN := oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("AV"))
		DA1->DA1__PREC2 := oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("30"))
		DA1->DA1__PREC3 := oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("3060"))
		DA1->DA1__PREC4 := oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("306090"))
		DA1->(MsUnlock())
	Else
		
		DbSelectArea("DA1")
		Reclock("DA1", .T.)
		DA1->DA1_FILIAL	:= xFILIAL("DA1")
		DA1->DA1_ITEM	:= Soma1(xContDA1()) //Strzero(i,4)
		DA1->DA1_CODTAB	:= Alltrim(getMV("MV__TABBRA"))
		DA1->DA1_CODPRO	:= oGetTM1:Acols[x][_CodPro] //cCodPro
		DA1->DA1_MOEDA	:= 1
		DA1->DA1_REFGRD	:= ""
		DA1->DA1_PRCVEN	:= oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("AV"))
		DA1->DA1__PREC2	:= oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("30"))
		DA1->DA1__PREC3	:= oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("3060"))
		DA1->DA1__PREC4	:= oGetTM1:Acols[x][_nPrcNV]+(oGetTM1:Acols[x][_nPrcNV] * fFator("306090"))
		DA1->DA1_ESTADO	:= "  "
		DA1->DA1_INDLOT	:= "00000000000999999.99"
		DA1->DA1_ATIVO	:= '1'
		DA1->DA1_DATVIG	:= _dData
		DA1->DA1_QTDLOT	:= 999999.99
		DA1->DA1_TPOPER	:= '4'
		DA1->(MsUnLock())
	EndIf
	//GeraTbUF(oGetTM1:Acols[X][_CodPro],cSeg,cGrupo,cSubGrp,oGetTM1:Acols[x][_nPrcNV],_dData,nIPI)
	lRet := .T.
	
next x

if lRet == .T.
	MsgInfo(OemToAnsi("Alterações realizada com sucesso."))
Else
	MsgInfo(OemToAnsi("Não foi processado nenhuma alteração na tabela de preço."),OemToAnsi("Atencao"))
Endif

Return
	
Static Function fLtExcTd()

Local _nRECNO  := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "RECNO" })
Local lRet	   := .F.

If MsgYesNo("TODOS os registros informados serão DELETADOS da lista de preço, Deseja prosseguir??","ATENCAO")
	for x:=1 to len(oGetTM1:Acols)
		
		DbSelectArea("DA1")
		DbGoTo(oGetTM1:Acols[x][_nRECNO])
		do while !reclock("DA1", .F.)
		enddo
		delete
		msUnlock()
		
		lRet := .T.
		
	next x
	
	if lRet == .T.
		MsgInfo(OemToAnsi("Exclusão realizada com sucesso."))
		oDlg:End()
	Else
		MsgInfo(OemToAnsi("Não foi processado nenhuma exclusão na tabela de preço."),OemToAnsi("Atencao"))
	Endif
	
EndIf

Return lRet
	
Static Function xContDA1()

Local nRet	:= 0

IF SELECT("XX1") > 0
	dbSelectArea("XX1")
	XX1->(dbCloseArea())
Endif

mSQL := " SELECT MAX(DA1_ITEM)QUANT FROM "+RetSqlName("DA1")+" WHERE DA1_CODTAB='001' "
DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"XX1",.F.,.T.)
XX1->( DbGoTop() )
If XX1->(!Eof())
	nRet := XX1->QUANT
Endif
XX1->(dbCloseArea())

Return (nRet)
		
Static Function fPsqSB1A()
Local lRet := .T.
Return lRet
	
Static Function fPsqSB1B()
Local lRet := .T.
Return lRet
		
Static Function fPsqSB1C()

Local _nLin
Local lRet      := .T.
Local mSQL      := ""
local nFOB      := 0
LOcal nMag      := 0
Local nMargem   := 0
Local nValor    := 0
Local cData     := Ctod("  /  /  ")
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosDtRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTREP" 	})
Local nPosFOB	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "FOB" 	})
Local nPosVlRep	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLREP" 	})
Local nPosCusto	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "CUSTO" 	})
Local nPosPrTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRTAB" 	})
Local nPosDTVAL	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTVAL" 	})
Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosVlDsc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLDESC" 	})
Local nPosMarge	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARGEM" 	})

Local nQtdCpo   := 0
Local nCols     := 0

oBrw1:aCols := {}
nQtdCpo := Len(aHeadsc)
nn:=0

IF SELECT("TDA1") > 0
	dbSelectArea("TDA1")
	TDA1->(dbCloseArea())
Endif

dbSelectArea("SZ1")
dbSetOrder(1)
If dbSeek(xFilial("SZ1")+__cUserId)
	cSegto := SZ1->Z1_SEGISP
Else
	cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])
Endif

mSQL := " SELECT max(B1_COD) B1_COD,max(B1_DESC) B1_DESC,MAX(D1_EMISSAO) DTREP,MAX(D1_VUNIT) VLRREP,MAX(SC7.C7_PRECO) CUSTO, max(Z8_ORDEM) Z8_ORDEM, Z9_SEQ, " + Chr(13)
mSQL += " DA1_PRCVEN ,MAX(SC7.C7_EMISSAO)DTPED, MAX(DA1_DATVIG) DA1_DATVIG " + Chr(13)
mSQL += " FROM "+RetSqlName("SB1")+" SB1 " + Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("DA1")+" DA1 ON DA1_FILIAL='" + xFilial("DA1") + "' AND DA1_CODTAB ='" + Alltrim(GetMv("MV__TABBRA")) + "' AND " + Chr(13)
mSQL += " DA1_CODPRO=B1_COD AND DA1_ESTADO='  ' AND DA1.D_E_L_E_T_ = ' ' "  + Chr(13)

mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_COD=B1_COD And SD1.D_E_L_E_T_ = ' ' " + Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND D1_PEDIDO=SC7.C7_NUM AND SC7.D_E_L_E_T_ = ' ' " + Chr(13)

mSQL += " INNER JOIN " + RetSqlName("SZ4")+" SZ4 ON Z4_CODIGO=B1__SUBGRP " + Chr(13)

If Empty(cCodDe)
	mSQL += " INNER JOIN " + RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND Z9_PRODUTO=B1_COD AND " + Chr(13)
	mSQL += " Z9_COD Between '" + cIdDe + "' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' " + Chr(13)
	
	mSQL += " INNER JOIN " + RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL=Z9_FILIAL AND Z9_COD=Z8_COD And SZ8.D_E_L_E_T_ = ' ' " + Chr(13)
Else
	mSQL += " LEFT  JOIN " + RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND Z9_PRODUTO=B1_COD AND " + Chr(13)
	mSQL += " Z9_COD Between '" + cIdDe + "' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' " + Chr(13)
	
	mSQL += " LEFT  JOIN " + RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL=Z9_FILIAL AND Z9_COD=Z8_COD And SZ8.D_E_L_E_T_ = ' ' "     + Chr(13)
EndIf

mSQL += " WHERE B1_FILIAL='"+xFilial("SB1")+"' " + Chr(13)

If !Empty(cCodDe)
	mSQL += " And B1_COD BETWEEN '"+cCodDe+"' AND '"+cCodAte+"' " + Chr(13)
EndIf

If !Empty(cGrpDe)
	mSQL += " And B1__SUBGRP BETWEEN '"+cGrpDe+"' AND '"+cGrpAte+"' " + Chr(13)
EndIf

mSQL += " AND SB1.D_E_L_E_T_ = ' ' " + Chr(13)

If Val(cSegto) > 0
	mSQL += " And B1__SEGISP = '" + cSegto + "' " + Chr(13)
EndIf

If !Empty(cDescr)
	mSQL += " And B1__DESCP Like '%"+Alltrim(cDescr)+"%' " + Chr(13)
EndIf

mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,DA1_DATVIG, Z8_SEQUEN, Z9_SEQ, Z9_COD " + Chr(13)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
TDA1->( DbGoTop() )

If TDA1->(!Eof())
	
	While TDA1->(!EOF())
		
		mSQL := " SELECT C7_PRODUTO,C7_NUM,C7_EMISSAO,C7_PRECO "
		mSQL += " FROM "+RetSqlName("SC7")+" SC7 "
		mSQL += " WHERE C7_PRODUTO='"+TDA1->B1_COD+"' AND C7_EMISSAO <'"+TDA1->DTPED+"' AND ROWNUM =1 "
		
		IF SELECT("TMP") > 0
			dbSelectArea("TMP")
			TMP->(dbCloseArea())
		Endif
		
		nFOB := 0
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
		TMP->( DbGoTop() )
		nFOB := TMP->C7_PRECO
		TMP->(dbCloseArea())
		
		nPrcDesc	:= 0
		
		nMargem	:= nPrcDesc / nFob
		
		AAdd(oBrw1:aCols, Array(nQtdCpo+1))
		nn++
		
		oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
		oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
		oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
		oBrw1:Acols[nn][nPosFOB]			:= nFOB
		oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
		oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO
		oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN
		oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DA1_DATVIG)
		oBrw1:Acols[nn][nPosVlNv]			:= nValor
		oBrw1:Acols[nn][nPosDtNv]			:= cData
		oBrw1:Acols[nn][nPosVlDsc]			:= nPrcDesc
		oBrw1:Acols[nn][nPosMarge]			:= nMargem
		oBrw1:Acols[nn][Len(aHeadsc)+1] 	:= .F.
		
		TDA1->(DbSkip())
		
	Enddo
	
	oBrw1:nat:=len(oBrw1:Acols)
	
Else
	MsgInfo(OemToAnsi("Nenhum Produto Encontrado na Tabela de Preço dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
Endif
TDA1->(dbCloseArea())

oBrw1:Refresh()

Return lRet

Static Function fuLimpar()

cIdDe      	:= Space(06)
cIdAte     	:= "ZZZZZZ"
cGrpDe     	:= Space(04)
cGrpAte    	:= "ZZZZ"
cCodDe     	:= Space(15)
cCodAte    	:= "ZZZZZZZZZZZZZZZ"
cDescr     	:= Space(60)
cDescr2    	:= Space(60)
oBrw1:aCols	:= {}
oBrw1:oBrowse:Refresh()

Return
		
User Function fValOrA()

Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local lRet := .T.
Local _cOrigem	:= ""

If oBrw1:aCols[n][nPosVlNv] == 0 .AND. 	oBrw1:aCols[n][nPosDtNv] == Ctod("  /  /  ")
	
	_cOrigem := Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[n][nPosProd],"B1_ORIGEM")
	
	If  _cOrigem == "0"
		MsgInfo(OemToAnsi("Produto de origem nacional. Preço não pode ser alterado !!"))
		
		lRet := .F.
		
	EndIf
EndIf

Return lRet
	
Static Function IFindRec(_cTab,_cUf,_cProd,_dVig)
Local _nRegDA1 := 0, _cSQL := _cTrb := "", _aArea := GetArea()

_cTrb := GetNextAlias()
_cSQL := "Select DA1.R_E_C_N_O_ DA1RECNO From " + RetSqlName("DA1") + " DA1 "
_cSQL += "Where DA1_FILIAL = '" + xFilial("DA1") + "' And DA1_CODTAB = '" + _cTab + "' And DA1_CODPRO = '" + _cProd + "' And "
_cSQL +=    "DA1_ESTADO = '" + _cUF + "' And DA1_DATVIG = '" + DTOS(_dVig) + "' And DA1.D_E_L_E_T_ = ' ' "

If Select(_cTrb) > 0
	DbSelectArea(_cTrb)
	DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTrb,.F.,.T.)

DbSelectArea(_cTrb)
DbGoTop()

If !Eof()
	_nRegDA1 := (_cTrb)->DA1RECNO
EndIf

If Select(_cTrb) > 0
	DbSelectArea(_cTrb)
	DbCloseArea()
EndIf

RestArea(_aArea)
Return _nRegDA1


//////////////////////////////////////////////////////////////////
//Rotina auxiliar do fonte IFATA38 - Tabela de preço de Venda - Bike Importado
//Roberto Marques
User Function iFATA38E(cCod)
	Local nX
	Local aColsEx := {}
	Local aColsE1 := {}
	Local aFields := {"ITEM","FAIXA","VALOR","PERC","IDENT","RVALOR","RPERC","DESC"}
	Local aAlterFields := {"FAIXA","VALOR","PERC","IDENT"} 
	local _aArea := getArea()
	
	Private aHeaderEx := {}
	Private aHeaderE1 := {}
	Private oBrw
	Private oBrwID	
	Private nOpc      := 1
	dbSelectArea("DA1")
	dbSelectArea("ACP")
	
	Private cCodPro    := Space(15)
	Private cDescr     := Space(100)
	Private cMarca     := Space(60)
	Private cDtRep     := Space(10)
	Private cDtValid   := Space(10)
	Private cCusto     := 0
	Private cFOB       := 0
	Private cPrcTab    := 0
	Private cVlrRep    := 0
	
	private aButtons   	:= {}
	private _dData	 	:= ctod("  /  /  ")
	private oDlg		:= nil
	private oGetTM1		:= nil

	private cFaixa		:= criavar("ACP__SEQIT")
	Private cID         := Space(6)
	Private cIDDesc     := Space(120)
	Private cIDQnt		:= 0
	Private cIDPerc     := 0
	                               
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlg1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oCodPro","oDescr")
	SetPrvt("oDtRep","oFOB","oVlrRep","oCusto","oPrcTab","oDtValid","oBtnOK1","oBtnOK2","oBtnEx","oBtnEx1","oBtnSair")
	SetPrvt("oID","oIDDesc","oIDQnt","oIDPerc")
		
	oFont := tFont():New("Tahoma",,-12,,.t.)

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})

	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)
	Aadd(aHeaderEx, {"Faixa"	    	,"ITEM"  ,"@!"				    ,03,0,".T.",,"C",,,,"" })
	Aadd(aHeaderEx, {"Quantidade"    	,"FAIXA" ,"@R 999999"			,06,0,".T.",,"N",,,,})
	Aadd(aHeaderEx, {"Altera %"      	,"PERC"  ,"@E 99.99"			,05,2,"U_IFATA38F()",,"N",,,,})
	Aadd(aHeaderEx, {"Altera Valor"     ,"VALOR" ,"@E 9,999,999.99"		,12,2,"U_IFATA38G()",,"N",,,,})
	Aadd(aHeaderEx, {"Percentual"    	,"RPERC" ,"@E 99.99"			,05,2,"",,"N",,,,})
	Aadd(aHeaderEx, {"Valor c/ Desconto","RVALOR","@E 9,999,999.99"		,12,2,"",,"N",,,,})
	Aadd(aHeaderEx, {"Identificação" 	,"IDENT" ,"@!"					,06,0,".T.",,"C","SZ8",,,})
	Aadd(aHeaderEx, {"Descrição"     	,"DESC"  ,"@!"					,60,0,".T.",,"C",,,,})

	if Alltrim(cCod) <>""
		cCodPro := cCod
	Endif 

	DEFINE MSDIALOG oDlg1 TITLE "Tabela de Desconto" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
                                           
    /*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

	oSay1      := TSay():New( 012,004,{||"Produto"}			,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 012,048,{||"Descrição"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 012,204,{||"Marca"}			,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay4      := TSay():New( 012,285,{||"Dt Reposição"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay5      := TSay():New( 012,334,{||"FOB(US$)"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay6      := TSay():New( 012,375,{||"Vlr Reposição"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oSay7      := TSay():New( 012,420,{||"Custo(US$)"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay8      := TSay():New( 012,465,{||"Preço Tabela"}	,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay9      := TSay():New( 012,510,{||"Dt Validade"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	
	oCodPro    := TGet():New( 020,004,{|u| If(PCount()>0,cCodPro:=u,cCodPro)}	,oDlg1,040,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodPro",,)
	oDescr     := TGet():New( 020,048,{|u| If(PCount()>0,cDescr:=u,cDescr)}		,oDlg1,152,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescr",,)
	oMarca     := TGet():New( 020,204,{|u| If(PCount()>0,cMarca:=u,cMarca)}		,oDlg1,076,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMarca",,)
	oDtRep     := TGet():New( 020,285,{|u| If(PCount()>0,cDtRep:=u,cDtRep)}		,oDlg1,045,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtRep",,)
	oFOB       := TGet():New( 020,334,{|u| If(PCount()>0,cFOB:=u,cFOB)}			,oDlg1,045,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cFOB",,)
	oVlrRep    := TGet():New( 020,375,{|u| If(PCount()>0,cVlrRep:=u,cVlrRep)}	,oDlg1,045,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cVlrRep",,)
	oCusto     := TGet():New( 020,420,{|u| If(PCount()>0,cCusto:=u,cCusto)}		,oDlg1,045,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCusto",,)
	oPrcTab    := TGet():New( 020,465,{|u| If(PCount()>0,cPrcTab:=u,cPrcTab)}	,oDlg1,045,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcTab",,)
	oDtValid   := TGet():New( 020,510,{|u| If(PCount()>0,cDtValid:=u,cDtValid)}	,oDlg1,045,008,'@D',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtValid",,)
	
	oBrw := MsNewGetDados():New( 040, 04,150,487,GD_INSERT+GD_UPDATE          , /*"U_IFATA38F()"*/, "AllwaysTrue","+ITEM", aAlterFields,,   ,,,, oDlg1, aHeaderEx, aColsEx)

	oBtnOK1   := TButton():New( 080,495,"Processar"	,oDlg1,{||fGrvACP1()}					,037,012,,,,.T.,,"",,,,.F. )
	oBtnEx1   := TButton():New( 100,495,"Excluir"	,oDlg1,{||fExcACP1()}					,037,012,,,,.T.,,"",,,,.F. ) 	
 	
 	oSay9      := TSay():New( 160,004,{||"Geração de Desconto por Identificação"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,100,008)
                         
	oSay1      := TSay():New( 170,004,{||"Faixa"}				,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay1      := TSay():New( 170,034,{||"Identificação"}		,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 170,085,{||"Descrição"}			,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay2      := TSay():New( 170,190,{||"Quantidade"}			,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay3      := TSay():New( 170,240,{||"Percentual"}			,oDlg1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)

	@ 180,004 msGet cFaixa 	picture "999" when .T. size 20,5 of oDlg pixel 
	@ 180,034 msGet cID 	when ! empty(cFaixa) size 45,5 of oDlg pixel F3 "SZ8" valid fDescID()
	@ 180,085 msGet cIDDesc when .F. size 100,5 of oDlg pixel 
	@ 180,190 msGet cIDQnt 	picture "999999" when ! empty(cFaixa).and. ! empty(cID) size 45,5 of oDlg pixel 
	@ 180,240 msGet cIDPerc picture "99.99" when ! empty(cFaixa) .and. ! empty(cID) size 45,5 of oDlg pixel 
	
	oBtnOK2   := TButton():New( 180,350,"Processar"	,oDlg1,{||Processa({|| fGrvACP2() },"Processando os registros...",,.T.)} ,037,012,,,,.T.,,"",,,,.F. )
	oBtnEx    := TButton():New( 200,350,"Excluir"	,oDlg1,{||Processa({|| fExcACP2() },"Excluindo os registros..."  ,,.T.)} ,037,012,,,,.T.,,"",,,,.F. )
	oBtnSair  := TButton():New( 240,495,"Sair"		,oDlg1,{||oDlg1:End() },037,012,,,,.T.,,"",,,,.F. )
	if Alltrim(cCod) <>""
		fPsqProd()
	Endif
	oDlg1:Activate(,,,.T.)
                                                                                                 
	lOk := .F.	

  	restArea(_aArea)
		
Return

Static Function fPsqProd()
	Local aFields := {"ITEM","FAIXA","VALOR","PERC","IDENT","RVALOR","RPERC","DESC"}
	Local aAlterFields := {"FAIXA","VALOR","PERC","IDENT"} 

	If Alltrim(cCodPro) ==""
		Return   
	Endif
	                      
	aColsEx := {}
	aColsE1 := {}

	
	IF SELECT("TDA1") > 0
		dbSelectArea("TDA1")
		TDA1->(dbCloseArea())
	Endif
	
	mSQL := "SELECT B1_COD,B1_DESC,B1__MARCA,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, "
	mSQL += " DA1_PRCVEN,MAX(SC7.C7_EMISSAO)DTPED,Z9_COD,MAX(DA1_DATVIG)DTVAL "
	mSQL += " FROM "+RetSqlName("SB1")+" SB1 "
	mSQL += " LEFT JOIN "+RetSqlName("DA1")+" DA1 ON DA1_FILIAL='"+xFilial("SB1")+"' AND DA1.D_E_L_E_T_ =' ' AND B1_COD=DA1_CODPRO "
	mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ =' ' "
	mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ =' ' AND D1_PEDIDO=SC7.C7_NUM "
	mSQL += " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_ =' ' AND Z9_PRODUTO=DA1_CODPRO "
	mSQL += " WHERE DA1_FILIAL='  ' AND DA1.D_E_L_E_T_ =' ' AND "
	mSQL += " B1_COD ='"+cCodPro+"' AND "  
	mSQL += " DA1_CODTAB ='"+GetMv("MV__TABBRA")+"' AND DA1_ESTADO='  ' "	
	mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,B1__MARCA,Z9_COD "

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
	TDA1->( DbGoTop() )
	
	If TDA1->(!Eof())

		    mSQL := " SELECT C7_PRODUTO,C7_NUM,C7_EMISSAO,C7_PRECO "
	    	mSQL += " FROM "+RetSqlName("SC7")+" SC7 "
	    	mSQL += " WHERE C7_PRODUTO='"+TDA1->B1_COD+"' AND C7_EMISSAO <'"+TDA1->DTPED+"' AND ROWNUM =1 "

			IF SELECT("TMP") > 0
				dbSelectArea("TMP")
				TMP->(dbCloseArea())
			Endif
		
			nFOB := 0
			
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
			TMP->( DbGoTop() ) 	
			nFOB := TMP->C7_PRECO
			TMP->(dbCloseArea())
	       		   
			cCodPro    := TDA1->B1_COD
			cDescr     := TDA1->B1_DESC
			cMarca     := TDA1->B1__MARCA
			cDtRep     := STOD(TDA1->DTREP)
			cFOB       := nFOB
			cVlrRep    := TDA1->VLRREP
			cCusto     := TDA1->CUSTO
			cPrcTab    := TDA1->DA1_PRCVEN
			cDtValid   := STOD(TDA1->DTVAL)
		    
			fPesqDsc(cCodPro)
		
			TDA1->(dbCloseArea())
		
		Endif	
		
Return

Static Function fNvCols1()
	
Local nn		:= 0 
Local nQtdCpo 	:= Len(aHeaderEx)
Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})
Local nPosQtd   :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "FAIXA" 	})
Local nPosPerc	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "PERC" 		})
Local nPosVlr	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "VALOR" 	})
Local nPosRP	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RPERC" 	})
Local nPosRV	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RVALOR" 	})
Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
Local nPosIDD	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "DESC" 		})

oBrw:aCols := {}
nQtdCpo :=  Len(aHeaderEx)
nn:=0

AAdd(oBrw:Acols, Array(nQtdCpo+1))
nn++

oBrw:Acols[nn][nQtdCpo+1]  	     := .F.
oBrw:Acols[nn][nPosITEM]		 := "001"
oBrw:Acols[nn][nPosQtd]			 := 0
oBrw:Acols[nn][nPosPerc]		 := 0.00
oBrw:Acols[nn][nPosVlr]			 := 0.00
oBrw:Acols[nn][nPosRP]			 := 0.00
oBrw:Acols[nn][nPosRV]			 := 0.00
oBrw:Acols[nn][nPosID]			 := ""
oBrw:Acols[nn][nPosIDD]			 := ""
oBrw:Acols[nn][Len(aHeaderEx)+1] := .F.
oBrw:nat:=len(oBrw:Acols)
oBrw:Refresh()

Return

User Function IFATA38F()

Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})		
Local nPosQtd   :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "FAIXA" 	})
Local nPosPerc	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "PERC" 		})
Local nPosVlr	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "VALOR" 	})
Local nPosRP	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RPERC" 	})
Local nPosRV	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RVALOR" 	})
Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
Local nPosIDD	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "DESC" 		})
Local nValor	:= 0
Local nPorc     := 0

if M->PERC > 0
	nValor :=  cPrcTab - (cPrcTab * M->PERC /100)
	oBrw:aCols[oBrw:nAt][nPosRV] := nValor
	oBrw:aCols[oBrw:nAt][nPosRP] := M->PERC
Endif

GETDREFRESH(oDlg1)
	      
oBrw:nat:=len(oBrw:Acols)
oBrw:Refresh()

Return .T.

Static Function IFT19A()

Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})		
Local cRet

oBrw:aCols[oBrw:nAt][nPosITEM] := Soma1(oBrw:aCols[oBrw:nAt][nPosITEM])

Return 

User Function IFATA38G()

		Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})		
		Local nPosQtd   :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "FAIXA" 	})
		Local nPosPerc	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "PERC" 		})
		Local nPosVlr	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "VALOR" 	})
		Local nPosRP	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RPERC" 	})
		Local nPosRV	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RVALOR" 	})
		Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
		Local nPosIDD	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "DESC" 		})
        Local nValor	:= 0
        Local nPorc     := 0
		
		if M->VALOR > 0
			nValor := cPrcTab - (cPrcTab *  M->VALOR /cPrcTab)
			oBrw:aCols[oBrw:nAt][nPosRV] := nValor 		
			oBrw:aCols[oBrw:nAt][nPosRP] := M->VALOR / cPrcTab 
		Endif
	
		GETDREFRESH(oDlg1)   
		
		oBrw:nat:=len(oBrw:Acols)
		oBrw:Refresh()

Return .T.            

Static Function fGrvACP1()
			
		Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})
		Local nPosQtd   :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "FAIXA" 	})
		Local nPosPerc	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "PERC" 		})
		Local nPosVlr	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "VALOR" 	})
		Local nPosRP	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RPERC" 	})
		Local nPosRV	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RVALOR" 	})
		Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
		Local nPosIDD	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "DESC" 		})
		Local cTabDesc	:= getMV("MV__DSCCBR")
	    Local nItem		:= 0
        Local _cQuery 	:= ""
        
		if empty(cCodPro) 
			alert ("Nenhum produto selecionado para processar os descontos !!")		
		else
		    
				for x:=1 to len(oBrw:Acols)
				
					If oBrw:Acols[x][nPosQtd] > 0 .And. oBrw:Acols[x][nPosRP] > 0 .And. oBrw:Acols[x][nPosRV] > 0
						nItem ++
				  		//ACP_FILIAL+ACP_CODREG+ACP_ITEM
				   		dbSelectArea("ACP")
						dbSetOrder(5) 
						if dbSeek(xFilial("ACP")+cTabDesc+oBrw:Acols[x][nPosITEM]+cCodPro)
							Reclock("ACP", .F.)
							ACP->ACP_PERDES	:= oBrw:Acols[x][nPosRP]
							ACP->ACP_FAIXA	:= oBrw:Acols[x][nPosQtd]
							ACP->ACP_CFAIXA	:= STRZERO(oBrw:Acols[x][nPosQtd],TAMSX3("ACP_CFAIXA")[1])  
							ACP->ACP_PERDES	:= oBrw:Acols[x][nPosRP]
							ACP->ACP__IDENT	:= oBrw:Acols[x][nPosID]
							msUnlock()
				   		Else		   
			   			 	Reclock("ACP", .T.)
							ACP->ACP_FILIAL	:= xFilial("ACP")
							ACP->ACP_CODREG	:= cTabDesc
							ACP->ACP_ITEM	:= GETSXENUM("ACP","ACP_ITEM")
							ACP->ACP__SEQIT	:= oBrw:Acols[x][nPosITEM]
						   	ACP->ACP_CODPRO := cCodPro
							ACP->ACP_PERDES	:= oBrw:Acols[x][nPosRP]
							ACP->ACP_FAIXA	:= oBrw:Acols[x][nPosQtd]
							ACP->ACP_CFAIXA	:= STRZERO(oBrw:Acols[x][nPosQtd],TAMSX3("ACP_CFAIXA")[1])  
							ACP->ACP_TPDESC	:= "1"
							ACP->ACP__IDENT	:= oBrw:Acols[x][nPosID]
							msUnlock()
							ConfirmSX8()

			   			Endif

					Endif
		   			                
				Next x        

       	      MsgInfo(OemToAnsi("Tabela de Descontos processada com sucesso !!"))
              fPesqDsc(cCodPro)
        endif      
Return

Static Function fExcACP1()
		Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})
		Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
		Local cTabDesc	:= getMV("MV__DSCCBR")					
		
		If msgYesNo("Deseja excluir desconto para este produto ?","Confirme")
			dbSelectArea("ACP")
	 		DbOrderNickName("ACPCODPRO")
			if dbSeek(xFilial("ACP")+cTabDesc+cCodPro+oBrw:aCols[oBrw:nAt][nPosID])
				Reclock("ACP", .F.)
				Delete
				msUnlock()
				MsgInfo(OemToAnsi("O desconto foi excluídos com sucesso !!"))
				fPesqDsc(cCodPro)
		   	Endif
		Endif   
Return                                               

Static Function fGrvACP2()  
	local _cTabDesc	:= getMV("MV__DSCCBR")

	if empty(cFaixa) .or. cIDQnt == 0 .or. cIDPerc == 0 .or. empty(cID)
		msgAlert ("Os campos do grupo Desconto por Identificação devem ser Preenchidos. Favor verificar !!")
		return
	else
	
		_cQuery := "DELETE "
		_cQuery += "FROM " + retSqlName("ACP") + " ACP "
		_cQuery += "WHERE ACP__IDENT = '" + cID +  "' "
		_cQuery += "  and ACP__SEQIT = '" + cFaixa + "' "
		tcSQLexec(_cQuery)

		_cQuery := "SELECT MAX(ACP_ITEM) ACP_ITEM  "
		_cQuery += "FROM " + retSqlName("ACP") + " ACP "
		_cQuery += "WHERE ACP.ACP_CODREG = '" + _cTabDesc +  "'"
		_cQuery += "  AND ACP.D_E_L_E_T_ = ' ' "
	
		TcQuery _cQuery New Alias "TRB1"
		_cItem := TRB1->ACP_ITEM
		TRB1->(dbCloseArea())

		_cQuery := "SELECT * "
		_cQuery += "FROM " + retSqlName("SZ9") + " SZ9 "
		_cQuery += "WHERE Z9_COD = '" + cID +  "' "
		_cQuery += "  AND SZ9.D_E_L_E_T_ = ' '"

		TcQuery _cQuery New Alias "TRBSZ9"

		dbSelectArea("ACP")		
		do while ! TRBSZ9->(eof())
		
			if reclock("ACP", .T.)
				_cItem := soma1(_cItem, len(_cItem))
				ACP->ACP_FILIAL	:= xFilial("ACP")
				ACP->ACP_CODREG	:= _cTabDesc
				ACP->ACP_CODPRO	:= TRBSZ9->Z9_PRODUTO
				ACP->ACP_ITEM	:= _cItem
				ACP->ACP_PERDES	:= cIDPerc
				ACP->ACP_FAIXA	:= cIDQnt
				ACP->ACP_CFAIXA	:= STRZERO(cIDQnt,TAMSX3("ACP_CFAIXA")[1]) 
				ACP->ACP_TPDESC	:= "1"
				ACP->ACP__IDENT	:= cID
				ACP->ACP__SEQIT	:= cFaixa
				msUnlock()
			endif  
		
			TRBSZ9->(dbSkip())
		enddo
		TRBSZ9->(dbCloseArea())

       	msgInfo ("Registros gravados com sucesso na Tabela de Desconto !!")

	endif	

	cFaixa		:= criavar("ACP__SEQIT")
	cID         := Space(6)
	cIDDesc     := Space(120)
	cIDQnt		:= 0
	cIDPerc     := 0

	fPesqDsc(cCodPro)  
Return .t.


Static Function fExcACP2()

		Local cTabDesc	:= getMV("MV__DSCCBR")
	    Local nItem		:= 0
        Local _cQuery 	:= ""

		dbSelectArea("ACP")
		dbSetOrder(3) 
		If dbSeek(xFilial("ACP")+cID)
			Do While ACP->ACP__IDENT == cID
				Reclock("ACP", .F.)
				Delete
				msUnlock()
				ACP->(dbSkip())
			Enddo	
		Endif	
		
		cFaixa		:= criavar("ACP__SEQIT")
		cID         := Space(6)
		cIDDesc  := ""
		cIDQnt   := 0
		cIDPerc  := 0
			   			                
              
		MsgInfo(OemToAnsi("Os descontos com essas identificações foram excluídos com sucesso !!"))
		fPesqDsc(cCodPro)
Return .T.


Static function fPsqProd1()
		local _lVal := .T.
	                      
		
		IF SELECT("TDA1") > 0
			dbSelectArea("TDA1")
			TDA1->(dbCloseArea())
		Endif
	
		mSQL := " SELECT B1_COD,B1_DESC,B1__MARCA,MAX(D1_EMISSAO) DTREP,MAX(D1_VUNIT) VLRREP,MAX(SC7.C7_PRECO) CUSTO, DA1_PRCVEN,MAX(SC7.C7_EMISSAO) DTPED,Z9_COD "
		mSQL += " FROM "+RetSqlName("DA1")+" DA1 "
		mSQL += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
		mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ <>'*' "
		mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ <>'*' AND D1_PEDIDO=SC7.C7_NUM "
		mSQL += " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_ <>'*' AND Z9_PRODUTO=DA1_CODPRO "
		mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
		mSQL += " DA1_CODPRO ='"+cCodPro+"' AND "  
		mSQL += " DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='  ' "	
		mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,B1__MARCA,Z9_COD "
		mSQL += " ORDER BY B1_COD,B1_DESC,B1__MARCA "
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
		TDA1->( DbGoTop() )

			While TDA1->(!EOF()) 
			
				mSQL := " SELECT C7_PRODUTO,C7_NUM,C7_EMISSAO,C7_PRECO "
		    	mSQL += " FROM "+RetSqlName("SC7")+" SC7 "
		    	mSQL += " WHERE C7_PRODUTO='"+TDA1->B1_COD+"' AND C7_EMISSAO <'"+TDA1->DTPED+"' AND ROWNUM =1 "

				IF SELECT("TMP") > 0
					dbSelectArea("TMP")
					TMP->(dbCloseArea())
				Endif

				nFOB := 0
				
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
				TMP->( DbGoTop() ) 	
				nFOB := TMP->C7_PRECO
				TMP->(dbCloseArea())
      
		        nMargem	:= TDA1->DA1_PRCVEN / TDA1->VLRREP

				cDescr     := TDA1->B1_DESC
				cMarca     := TDA1->B1__MARCA
				cDtRep     := STOD(TDA1->DTREP)
				cDtValid   := STOD(TDA1->DTPED)
				cCusto     := TDA1->CUSTO
				cFOB       := nFOB
				cPrcTab    := TDA1->DA1_PRCVEN
				cVlrRep    := TDA1->VLRREP

				TDA1->(DbSkip())             
		    
			Enddo

		IF SELECT("TDA1") > 0
			dbSelectArea("TDA1")
			TDA1->(dbCloseArea())
		Endif        
	
		mSQL :="SELECT B1_COD,B1_DESC,DA1_PRCVEN "
		mSQL +=" FROM "+RetSqlName("DA1")+" DA1 LEFT JOIN "+RetSqlName("SB1")+" SB1 "
		mSQL +=" ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
		mSQL +=" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
		mSQL +=" DA1_CODPRO ='"+M->DA1_CODPRO+"' AND DA1_CODTAB ='"+getMV("MV__TABBRA")+"' "  
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
		TDA1->( DbGoTop() )
		                                                                   	
		If TDA1->(!Eof())
			aCols[n][_cDescri] := TDA1->B1_DESC	
			aCols[n][_PrcVend] := TDA1->DA1_PRCVEN	
		Else
			Aviso("Atenção!","Produto inválido ou bloqueado!",{"OK"})
			_lVal := .F.	
		EndIf
	
	return _lVal 
    
Static Function  fPesqDsc(cCodP)

	Local _nLin
	Local mSQL := ""
	local nFOB := 0
	Local nMag := 0
	Local nMargem := 0
	Local nValor := 0
	Local cData  := Ctod("  /  /  ")
	Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})	
	Local nPosQtd   :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "FAIXA" 	})
	Local nPosPerc	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "PERC" 		})
	Local nPosVlr	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "VALOR" 	})
	Local nPosRP	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RPERC" 	})
	Local nPosRV	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "RVALOR" 	})
	Local nPosID	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "IDENT" 	})
	Local nPosIDD	:=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "DESC" 		})

	Local nQtdCpo   := 0
	Local nCols     := 0
		
	if ! empty(cCodP)	
	
		IF SELECT("TACP") > 0
			dbSelectArea("TACP")
			TACP->(dbCloseArea())
		Endif
		
		dbSelectArea("SZ1")
		dbSetOrder(1)
		If dbSeek(xFilial("SZ1")+__cUserId)
			cSegto := SZ1->Z1_SEGISP
		Else
			cSegto := PADR('0',TamSX3("Z1_SEGISP")[1])
		Endif

		mSQL := "SELECT ACP_FILIAL,ACP_CODREG,ACP_ITEM,ACP_CODPRO,ACP_PERDES,ACP_FAIXA,ACP_CFAIXA,ACP_VLRDES,ACP_TPDESC,ACP__IDENT,ACP__SEQIT "
		mSQL += " FROM "+RetSqlName("ACP")+" ACP "
		mSQL += " WHERE ACP_FILIAL='"+xFILIAL("ACP")+"' AND ACP.D_E_L_E_T_<>'*' AND "
		mSQL += " ACP_CODREG ='"+GetMv("MV__DSCCBR")+"' AND ACP_CODPRO ='"+cCodP+"' "
				
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TACP",.F.,.T.)
		TACP->( DbGoTop() )
		IF TACP->(!EOF())
			oBrw:aCols := {}
			nQtdCpo := Len(aHeaderEx)
			nn:=0		
		
			While TACP->(!EOF())		
					
					AAdd(oBrw:aCols, Array(nQtdCpo+1))
					nn++
					oBrw:Acols[nn][nPosITEM]		:= IF(AllTrim(TACP->ACP__SEQIT)=="",StrZero(Len(oBrw:aCols),3),TACP->ACP__SEQIT)
					oBrw:Acols[nn][nPosQtd]			:= TACP->ACP_FAIXA
					oBrw:Acols[nn][nPosPerc]		:= 0.00
					oBrw:Acols[nn][nPosVlr]			:= 0.00
					oBrw:Acols[nn][nPosRP]			:= TACP->ACP_PERDES
					oBrw:Acols[nn][nPosRV]			:= cPrcTab - (cPrcTab * TACP->ACP_PERDES /100)  //TACP->ACP_VLRDES
					oBrw:Acols[nn][nPosID]			:= TACP->ACP__IDENT
					oBrw:Acols[nn][nPosIDD]			:= Posicione("SZ8",1,xFilial("SZ8")+TACP->ACP__IDENT,"Z8_DESCRI")
					oBrw:Acols[nn][Len(aHeaderEx)+1] 	:= .F.							
					
					TACP->(DbSkip())
					
				Enddo

        Else
	        fNvCols1()
		Endif	
		oBrw:nat:=len(oBrw:Acols)
		aSort( oBrw:aCols,,, { |x,y| x[nPosITEM] < y[nPosITEM] } )				
		oBrw:Refresh()
			
		IF SELECT("TACP") > 0
			dbSelectArea("TACP")
			TACP->(dbCloseArea())
		Endif

    endif
Return

User Function FT38SEQ()
	Local nPosITEM  :=  ASCAN(aHeaderEx, { |x| AllTrim(x[2]) == "ITEM" 		})	
	Local cRet := ""		
	if Len(Len(aColsEx)) > 0 
	cRet := StrZero(Val(Soma1(oBrw:Acols[Len(oBrw:Acols)-1][nPosITEM])),3)
	Else
		cRet := "001"
	endif
Return cRet
       

Static Function fDescID()
	local _cRet := .T.
	local _cTabDesc	:= getMV("MV__DSCCBR")

	if ! empty(cID)
		dbSelectArea("SZ8")
		dbSetOrder(1)
		if ! dbSeek(xFilial("SZ8")+cID) 
			msgAlert ("Identificação não cadastrada. Favor verificar !!")
			_cRet := .F.	
		else     
			cIDDesc := SZ8->Z8_ABREV
			
			_cQuery := "select distinct ACP_PERDES, ACP_FAIXA, ACP__IDENT "
			_cQuery += "from " + retSqlName("ACP") + " ACP "
			_cQuery += "where ACP__IDENT = '" + cID + "' "
			_cQuery += "  and ACP__SEQIT = '" + cFaixa + "' "
			_cQuery += "  and ACP_CODREG = '" + _cTabDesc + "' "
			_cQuery += "  and D_E_L_E_T_ = ' ' "
			
			TcQuery _cQuery New Alias "TRBACP"
			
			if empty(TRBACP->ACP__IDENT)
				if msgYesNo("A Faixa não existe para essa identificação. Deseja criar uma nova ?","Confirme")				

					_cQuery := "select max(ACP__SEQIT) ACP__SEQIT "
					_cQuery += "from " + retSqlName("ACP") + " ACP "
					_cQuery += "inner join " + retSqlName("SZ9") + " SZ9 ON Z9_PRODUTO = ACP_CODPRO
					_cQuery += "        								AND Z9_COD = '" + cID + "' "
					_cQuery += "  										AND SZ9.D_E_L_E_T_ = ' ' "
					_cQuery += "where ACP_CODREG = '" + _cTabDesc + "' "
					_cQuery += "  and ACP.D_E_L_E_T_ = ' ' "

					TcQuery _cQuery New Alias "TRBACP1"
					
					cFaixa := soma1(TRBACP1->ACP__SEQIT, TAMSX3("ACP_CFAIXA")[1])
					TRBACP1->(dbCloseArea())								        
				     
				 	_nQtde := 0				
				 	_nPerc := 0
				else
					_cRet := .F.	
				endif
			else
			 	cIDQnt 	:= TRBACP->ACP_FAIXA				
			 	cIDPerc := TRBACP->ACP_PERDES							
			endif		
			
			TRBACP->(dbCloseArea())			
		endif
	endif	
	
Return               
