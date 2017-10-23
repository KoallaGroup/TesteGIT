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
±±³Fun‡…o ³ IFATA015³ Autor ³ Roberto Marques           ³ Data ³ 19/08/14 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Programa para Alterações de Preços  - Nacional             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Objetivo  ³ Alteração de Preço para Produto Nacional 				  ´±±
±±³  																	  ³±±
±±³ 								                                      ´±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function IFATA15()
local _aArea := getArea()
Local aItems  	   := {'Por Cód.Produto','Por Descrição','Por Marca','Por Identificação' }
Local aItems2 	   := {'Ativo','Inativo', 'Ambos'}
Private aEdit	   := {"VLNOVO", "DTNOVO"}
Private cCodDe     := Space(TamSX3("B1_COD")[1])
Private cCodAte    := Replicate("Z",TamSX3("B1_COD")[1])
Private _nAno      := Year(Date())
Private cDtDe      := Ctod("01/01/" + Alltrim(Str(_nAno)))
Private cDtAte     := Ctod("01/01/" + Alltrim(Str(_nAno + 1)))
Private cDescr     := Space(60)
Private cDescr2    := Space(60)
Private cGrpDe     := Space(TamSX3("BM_GRUPO")[1])
Private cGrpAte    := Replicate("Z",TamSX3("BM_GRUPO")[1])
Private cIdDe      := Replicate(" ",4) //Space(TamSX3("Z8_COD")[1]) --Solicitado pelo Sérgio (Compras) para deixar fixo 4 posições
Private cIdAte     := Replicate("Z",4) //Replicate("Z",TamSX3("Z8_COD")[1]) --Solicitado pelo Sérgio (Compras) para deixar fixo 4 posições
Private cMarcDe    := Space(TamSX3("Z5_CODIGO")[1])
Private cMarcAte   := Replicate("Z",TamSX3("Z5_CODIGO")[1])
Private cCodPro	   := Space(15)	

Private cCombo  := aItems[1]
Private cCombo2 := aItems[1]

Private cPorc      := 0.00
Private cPrcAte    := 0.00 //99.999,99
Private cPrcDe     := 0
Private aHeadsc := {}
Private aColssc := {}

aColssc := {} // Inicializa o ACOLS da Sugestão de Compra

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Declaração de Variaveis Private dos Objetos                             ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
SetPrvt("oDlgTbPrc","oGrp1","oSay1","oSay2","oSay3","oSay4","oSay5","oSay6","oSay7","oSay8","oSay9","oSay10")
SetPrvt("oSay12","oSay13","oSay14","oSay15","oIdDE","oIdAte","oGrpDe","oGrpAte","oCodDe","oCodAte","oDescr")
SetPrvt("oBtnPsq","oMarcDe","oMarcAte","oDtDe","oDtAte","oPrcDe","oPrcAte","oCBOrd","oCBSta","oBrw1")
SetPrvt("oSay16","oBtnImpr","oBtnImAlt","oBtnTodo","oPorc","oBtnAltPrc","oBtnDsc","oBtnProc","oBtnSair")

// Inicialização do Vetores da Getdados
aAdd(aHeadsc,{"Produto"             , "PROD"     	, ""  		    ,10,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Descrição"           , "DESC"     	, ""  		    ,35,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Marca"               , "MARCA"   	, ""  		    ,12,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Dt Reposição"   		, "DTREP"    	, ""  		    ,10,0,"" , "" ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"FOB (US$)"    		, "FOB"  		,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Valor Reposição"   	, "VLREP"  		,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Custo"       		, "CUSTO"    	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Preço Tabela"        , "PRTAB"    	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Dt Validade"    		, "DTVAL"    	,""			    ,10,0,"" ,""  ,"C" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Preço Novo"     	 	, "VLNOVO"   	,"@E 999,999.99",10,2,"" ,""  ,"N" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Dt Nova Validade"   	, "DTNOVO"    	, "" 		    ,10,0,"" ,""  ,"C" , "" ,"","","","","",".T."})
aAdd(aHeadsc,{"Preço Desconto"      , "VLDESC"   	,"@E 99,999.99" ,10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})
aAdd(aHeadsc,{"Multiplicador"  		, "MARGEM"		,"@E 99,999.99" ,10,2,"" ,""  ,"N" , "" ,"","","","","",".F."})

/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±± Definicao do Dialog e todos os seus componentes.                        ±±
Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

aSize := MsAdvSize(.T.)
aObjects := {}

AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 100, .t., .t. } )
AAdd( aObjects, { 100, 020, .t., .f. } )
aInfo := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
aPosObj := MsObjSize( aInfo, aObjects )


oDlgTbPrc  := MSDialog():New( aSize[7],0,aSize[6],aSize[5],"Acesso às Alterações de Preços - Bicicletas",,,.F.,,,,,,.T.,,,.T. ) 


oGrp1      := TGroup():New( 004,004,084,aPosObj[2,4],"Seleção",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay1      := TSay():New( 016,008,{||"A Partir Identificação"}	,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay2      := TSay():New( 028,008,{||"      Até Identificação"}	,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay3      := TSay():New( 016,108,{||"A Partir Grupo"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay4      := TSay():New( 028,108,{||"      Até Grupo"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay5      := TSay():New( 016,184,{||"A Partir Item"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay6      := TSay():New( 028,184,{||"      Até Item"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay7      := TSay():New( 016,288,{||"Por Item"}   				,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
oSay8      := TSay():New( 048,016,{||"A Partir Marca"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay9      := TSay():New( 060,016,{||"      Até Marca "}		,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
oSay10     := TSay():New( 048,124,{||"A Partir Data Reposição"}	,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
oSay11     := TSay():New( 060,132,{||" Até Data Reposição"}		,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
oSay12     := TSay():New( 048,260,{||"A Partir Preço"}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oSay13     := TSay():New( 060,268,{||"Até Preço"}				,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
oSay14     := TSay():New( 048,352,{||"Ordenar por "}			,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
oSay15     := TSay():New( 060,364,{||" Status"}					,oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
oIdDE      := TGet():New( 016,060,{|u| If(PCount()>0,cIdDe:=u,cIdDe)}		,oDlgTbPrc,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdDe",,)
oIdAte     := TGet():New( 028,060,{|u| If(PCount()>0,cIdAte:=u,cIdAte)}		,oDlgTbPrc,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdAte",,)
oGrpDe     := TGet():New( 016,152,{|u| If(PCount()>0,cGrpDe:=u,cGrpDe)}		,oDlgTbPrc,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBM","cGrpDe",,)
oGrpAte    := TGet():New( 028,152,{|u| If(PCount()>0,cGrpAte:=u,cGrpAte)}	,oDlgTbPrc,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBM","cGrpAte",,)
oCodDe     := TGet():New( 016,220,{|u| If(PCount()>0,cCodDe:=u,cCodDe)}		,oDlgTbPrc,060,008,'',{||fPsqSB1A()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodDe",,)
oCodAte    := TGet():New( 028,220,{|u| If(PCount()>0,cCodAte:=u,cCodAte)}	,oDlgTbPrc,060,008,'',{||fPsqSB1B()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodAte",,)
oDescr     := TGet():New( 016,320,{|u| If(PCount()>0,cDescr:=u,cDescr)}		,oDlgTbPrc,136,008,'',/*{||fPsqSB1C()}*/,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescr",,)

oBtnLmp    := TButton():New( 016,480,"Limpar"	,oDlgTbPrc,{||fuLimpar()} ,037,012,,,,.T.,,"",,,,.F. )
oBtnPsq    := TButton():New( 048,480,"Filtrar"	,oDlgTbPrc,{||Processa({|| fuPesqTAB() },"Buscando os registros...",,.T.)},037,012,,,,.T.,,"",,,,.F. )

oMarcDe    := TGet():New( 048,060,{|u| If(PCount()>0,cMarcDe:=u,cMarcDe)}	,oDlgTbPrc,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ5","cMarcDe",,)
oMarcAte   := TGet():New( 060,060,{|u| If(PCount()>0,cMarcAte:=u,cMarcAte)}	,oDlgTbPrc,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ5","cMarcAte",,)
oDtDe      := TGet():New( 048,188,{|u| If(PCount()>0,cDtDe:=u,cDtDe)}		,oDlgTbPrc,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtDe",,)
oDtAte     := TGet():New( 060,188,{|u| If(PCount()>0,cDtAte:=u,cDtAte)}		,oDlgTbPrc,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtAte",,)
oPrcDe     := TGet():New( 048,300,{|u| If(PCount()>0,cPrcDe:=u,cPrcDe)}		,oDlgTbPrc,044,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcDe",,)
oPrcAte    := TGet():New( 060,300,{|u| If(PCount()>0,cPrcAte:=u,cPrcAte)}	,oDlgTbPrc,044,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcAte",,)

oCBOrd     := TComboBox():New( 048,388,{|u| If(PCount()>0,cCombo:=u,cCombo)}  ,aItems ,072,010,oDlgTbPrc,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo  )
oCBSta     := TComboBox():New( 060,388,{|u| If(PCount()>0,cCombo2:=u,cCombo2)},aItems2,072,010,oDlgTbPrc,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo2 )

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
                                    "U_fValOr()"	,;	//12 -> cFieldOK:	?
                                    NIL				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
                                    				,;  //{ || .F. }		,;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
                                    oDlgTbPrc		,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
                                    aHeadsc			,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
                                    aColssc			 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
                                    ) //...


oBrw1:aCols := {}
//oBrw1:bChange := {|| fPegaCod(oGetTM1:aCols[oGetTM1:nat,1]) }
oBrw1:oBrowse:Refresh()

oGrp2      := TGroup():New( aPosObj[2,3]+5,004,aPosObj[2,3]+30,aPosObj[2,4],"",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )
oSay16     := TSay():New( aPosObj[2,3]+13,192,{||"% Preço Novo"},oDlgTbPrc,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
oBtnImpr   := TButton():New( aPosObj[2,3]+10,012,"Imprimir"             ,oDlgTbPrc,{||U_IFATR10b()      },052,012,,,,.T.,,"",,,,.F. )
oBtnImAlt  := TButton():New( aPosObj[2,3]+10,068,"Imprimir Alterações"	,oDlgTbPrc,{||U_IFATR10()		},052,012,,,,.T.,,"",,,,.F. )
oBtnTodo   := TButton():New( aPosObj[2,3]+10,132,"Marcar Todos"			,oDlgTbPrc,{||fMarcaTds()		},052,012,,,,.T.,,"",,,,.F. )
oPorc      := TGet():New( aPosObj[2,3]+13,232,{|u| If(PCount()>0,cPorc:=u,cPorc)},oDlgTbPrc,044,008,'@E 999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPorc",,)
oBtnAltPrc := TButton():New( aPosObj[2,3]+10,316,"Alterar Preço"		,oDlgTbPrc,{||U_iFata15A()		},037,012,,,,.T.,,"",,,,.F. )
oBtnDsc    := TButton():New( aPosObj[2,3]+10,360,"Desconto" 			,oDlgTbPrc,{||fDescont() },037,012,,,,.T.,,"",,,,.F. )
oBtnProc   := TButton():New( aPosObj[2,3]+10,404,"Processar"			,oDlgTbPrc,{||fProc()			},037,012,,,,.T.,,"",,,,.F. )
oBtnSair   := TButton():New( aPosObj[2,3]+10,488,"Sair"					,oDlgTbPrc,{||oDlgTbPrc:End()	},037,012,,,,.T.,,"",,,,.F. )  

oDlgTbPrc:Activate(,,,.T.)

restarea(_aArea)

Return


Static Function fDescont() 
	Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
	Local lRet := .T. 
	Local _cOrigem	:= ""   
	
	If Len(oBrw1:Acols) != 0 
	
		_cOrigem := Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[oBrw1:nat][nPosProd],"B1_ORIGEM")
	
		If  _cOrigem == "0"
	
			MsgInfo(OemToAnsi("Produto de origem nacional. Preço não pode ser alterado !!"))
			lRet := .F.
		Else
			U_iFata19(oBrw1:aCols[oBrw1:nat,1])	    
	
		EndIf
	else
	
		U_iFata19()	    
	
	Endif	
Return lRet


Static Function  fuPesqTAB()

Local _nLin
Local mSQL := ""
local nFOB := 0
LOcal nMag := 0
Local nMargem := 0
Local nValor := 0
Local cData  := Ctod("  /  /  ")
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosMarc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARCA" 	})
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
    
mSQL := "SELECT max(B1_COD) B1_COD,max(B1_DESC) B1_DESC,max(Z5_DESC) Z5_DESC,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, max(Z8_ORDEM) Z8_ORDEM, Z9_SEQ," + Chr(13)
mSQL += " DA1_PRCVEN ,MAX(SC7.C7_EMISSAO)DTPED,DA1_DATVIG " + Chr(13)
mSQL += " FROM "+RetSqlName("SB1")+" SB1 " + Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("DA1")+" DA1 ON DA1_FILIAL='" + xFilial("DA1") + "' AND DA1_CODTAB ='" + Alltrim(getMV("MV__TABBRA")) + "' AND " + Chr(13)
mSQL += " DA1_CODPRO=B1_COD AND DA1_ESTADO='  ' AND DA1.D_E_L_E_T_ = ' ' "  + Chr(13)
If 	cPrcAte > 0 
	mSQL += " AND DA1_PRCVEN >="+Str(cPrcDe)+" AND DA1_PRCVEN <="+Str(cPrcAte)
Endif
mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_COD=B1_COD AND D1_EMISSAO >='"+DtoS(cDtDe)+"' AND D1_EMISSAO <='"+DtoS(cDtAte)+"' And SD1.D_E_L_E_T_ = ' ' " + Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND D1_PEDIDO=SC7.C7_NUM AND SC7.D_E_L_E_T_ = ' ' " + Chr(13)
mSQL += " LEFT JOIN "+RetSqlName("SZ5")+" SZ5 ON Z5_CODIGO=B1__MARCA And SZ5.D_E_L_E_T_ = ' ' " + Chr(13)

If Empty(cCodDe) 
    mSQL += " INNER JOIN " + RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND Z9_PRODUTO=B1_COD AND " + Chr(13)
    mSQL += " Z9_COD Between '" + cIdDe + "' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' " + Chr(13)

    mSQL += " INNER JOIN " + RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL=Z9_FILIAL AND Z9_COD=Z8_COD And SZ8.D_E_L_E_T_ = ' ' " + Chr(13)
Else
    mSQL += " LEFT  JOIN " + RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND Z9_PRODUTO=B1_COD AND " + Chr(13)
    mSQL += " Z9_COD Between '" + cIdDe + "' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' " + Chr(13)

    mSQL += " LEFT  JOIN " + RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL=Z9_FILIAL AND Z9_COD=Z8_COD And SZ8.D_E_L_E_T_ = ' ' "     + Chr(13)
EndIf
    
    mSQL += " INNER JOIN (SELECT DA1_CODPRO, " + Chr(13)
    mSQL += "       MAX(DA1.R_E_C_N_O_) RECNO " + Chr(13)
    mSQL += " FROM "+RetSqlName("DA1")+" DA1 " + Chr(13)
    mSQL += " WHERE DA1_ESTADO='  ' AND D_E_L_E_T_=' ' AND DA1_FILIAL='"+xFilial("DA1")+"'" + Chr(13)
    mSQL += " GROUP BY DA1_CODPRO) TMP ON TMP.RECNO = DA1.R_E_C_N_O_ " + Chr(13)
    
mSQL += " WHERE B1_FILIAL='"+xFilial("SB1")+"' " + Chr(13)

If !Empty(cCodDe)
    mSQL += " And B1_COD >= '"+cCodDe+"' AND B1_COD<='"+cCodAte+"' " + Chr(13)
EndIf

If !Empty(cMarcDe)
    mSQL += " And B1__MARCA >='"+cMarcDe+"' AND B1__MARCA <='"+cMarcAte+"' " + Chr(13)
EndIf

If !Empty(cGrpDe)
    mSQL += " And B1_GRUPO >='"+cGrpDe+"' AND B1_GRUPO <='"+cGrpAte+"' " + Chr(13)
EndIf

mSQL += " AND SB1.D_E_L_E_T_ = ' ' " + Chr(13)

If Val(cSegto) > 0
	mSQL += " And B1__SEGISP = '" + cSegto + "' " + Chr(13)
EndIf

If !Empty(cDescr)
    mSQL += " And B1__DESCP Like '%"+Alltrim(cDescr)+"%' " + Chr(13)
EndIf

if cCombo2 == 'Ativo'
    mSQL += " And B1_ATIVO <> 'N' " + Chr(13)
elseif cCombo2 == 'Inativo'
    mSQL += " And B1_ATIVO = 'N' " + Chr(13)
endif

mSQL += " GROUP BY B1_COD,B1_DESC,Z5_DESC,DA1_PRCVEN,DA1_DATVIG, Z8_SEQUEN, Z9_SEQ " + Chr(13)

If cCombo == "Por Cód.Produto"
	mSQL += " ORDER BY B1_COD,B1_DESC,Z5_DESC " 
ElseIf cCombo == "Por Descrição"
	mSQL += " ORDER BY B1_DESC,Z5_DESC "
ElseIf cCombo == "Por Marca"
	mSQL += " ORDER BY Z5_DESC,B1_DESC "       
else
	mSQL += " ORDER BY Z8_SEQUEN ASC, Z9_SEQ ASC " //Z8_COD, B1_DESC "       
Endif

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
		
		/*ACSJ - 14 de Novembro de 2014
		         Alteração de formula solicitada pelo Marcelo(ISAPA)
		         Preço com Desconto / nFOB [preço com desconto fixo 0]
		nMargem	:= TDA1->DA1_PRCVEN / TDA1->VLRREP                    */
		
		
		nPrcDesc	:= TDA1->DA1_PRCVEN - (TDA1->DA1_PRCVEN * fPERDES(TDA1->B1_COD) /100) //TDA1->ACP_PERDES
		
		nMargem	:= nPrcDesc / nFob
		
		AAdd(oBrw1:aCols, Array(nQtdCpo+1))
		nn++
				
		oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
		oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
		oBrw1:Acols[nn][nPosMarc]			:= TDA1->Z5_DESC
		oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
		oBrw1:Acols[nn][nPosFOB]			:= nFOB
		oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
		oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO
		oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN //PRCVEN
		oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DA1_DATVIG) //STOD(TDA1->DTPED)
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
Local nPosMarc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARCA" 	})
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

If cPorc <> 0.00
	for x:=1 to len(oBrw1:Acols)
		oBrw1:Acols[x][nPosVlNv]	:= oBrw1:Acols[x][nPosPrTab]+(oBrw1:Acols[x][nPosPrTab]*cPorc /100)
		if oBrw1:Acols[x][nPosDtNv] = Ctod("  /  /  ")
			oBrw1:Acols[x][nPosDtNv]	:= dDataNw //oBrw1:Acols[1][nPosDtNv]
		Endif
	next x
Else
	for x:=1 to len(oBrw1:Acols)
		IF	oBrw1:Acols[1][nPosVlNv] <> 0.00
			oBrw1:Acols[x][nPosVlNv] := oBrw1:Acols[1][nPosVlNv]
		Endif
		IF	oBrw1:Acols[1][nPosDtNv] <> Ctod("  /  /  ")
			//oBrw1:Acols[x][nPosDtNv] := oBrw1:Acols[1][nPosDtNv]
			oBrw1:Acols[x][nPosDtNv]	:= dDataNw			
		Endif
		
	next x
Endif


Return

Static Function fProc()
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
Local nPosMarc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARCA" 	})
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
	    			DA1->DA1_ITEM	:= Soma1(xContDA1()) //Strzero(i,4)
	    			DA1->DA1_CODTAB	:= Alltrim(getMV("MV__TABBRA"))
	    			DA1->DA1_CODPRO	:= oBrw1:Acols[X][nPosProd] //cCodPro
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
	            
				GeraTbUF(oBrw1:Acols[X][nPosProd],cSeg,cGrupo,cSubGrp,oBrw1:Acols[x][nPosVlNv],oBrw1:Acols[x][nPosDtNv],nIPI)
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

if oBrw1:aCols[n][nPosVlNv] == 0 .AND. 	oBrw1:aCols[n][nPosDtNv] <> Ctod("  /  /  ")
	msgAlert ("O Valor tem que ser superior a zero. Favor verificar !!")
	lRet := .F.
endif

if oBrw1:aCols[n][nPosVlNv] > 0 .AND. 	oBrw1:aCols[n][nPosDtNv] == Ctod("  /  /  ")
	msgAlert ("A Nova data de Validade deve ser informada. Favor verificar !!")
	lRet := .F.
endif


Return lRet

Static Function GeraTbUF(cCodPro,cSeg,cGrupo,cSubGrp,nPreco,cData,nIPI)
Local mSQL := ""
Local cTabBra := Alltrim(getMV("MV__TABBRA"))
Local cUF 	  := Alltrim(getMV("MV__TABPUF"))
Local aUF 	  := {}
Local nPrcTab := 0
Local iCt	  := .F., _nRecDA1 := 0

//cPrcTab := fReajt(aUF[i],cSeg,cGrupo,cSubGrp,nPreco)

aUF	:= Separa(cUF, ',')

For i:=1 to Len(aUF)
	
	nPrcTab := fReajt(aUF[i],cSeg,cGrupo,cSubGrp,nPreco,nIPI,cCodPro)
	
	IF SELECT("TDA1") > 0
		dbSelectArea("TDA1")
		TDA1->(dbCloseArea())
	Endif
	/*
	mSQL := "SELECT * FROM "+RetSqlName("DA1")+" DA1 "
	mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND D_E_L_E_T_ = ' ' AND DA1_CODPRO='"+cCodPro+"'"
	mSQL += " AND DA1_CODTAB ='" + cTabBra + "' AND DA1_ESTADO='"+aUF[i]+"'"
	mSQL += " AND DA1_DATVIG='"+DtoS(cData)+"' "
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
	TDA1->( DbGoTop() )
	
	IF TDA1->(!Eof())
		iCt	:= .T.
	ENDIF
	TDA1->(dbCloseArea())
	*/
	
	_nRecDA1 := IFindRec(Alltrim(GetMv("MV__TABBRA")),aUF[i],cCodPro,cData)
	
    _PrAV    := nPrcTab+(nPrcTab * fFator("AV")) 
    _Pr2     := nPrcTab+(nPrcTab * fFator("30"))
    _Pr3     := nPrcTab+(nPrcTab * fFator("3060"))
    _Pr4     := nPrcTab+(nPrcTab * fFator("306090"))
	
	//IF iCt == .T.
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
		/*
		mSQL :="UPDATE "+RetSqlName("DA1")+" SET DA1_PRCVEN="+Alltrim(Str(_PrAV))+",DA1_PREC2="+Str(_Pr2)
		mSQL += ",DA1_PREC3="+Str(_Pr2)+",DA1_PREC4="+Str(_Pr4)
		mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND D_E_L_E_T_ = ' ' AND DA1_CODPRO='"+cCodPro+"'"
		mSQL += " AND DA1_CODTAB ='" + cTabBra + "' AND DA1_ESTADO='"+aUF[i]+"'"
		mSQL += " AND DA1_DATVIG ='"+DtoS(cData)+"' "
		
		Begin Transaction
		TCSQLExec(mSQL)
		End Transaction
		*/
	Else
        DbSelectArea("DA1")
        Reclock("DA1", .T.)
		DA1->DA1_FILIAL	:= xFILIAL("DA1")
		DA1->DA1_ITEM	:= Soma1(xContDA1()) //Strzero(i,4)
		DA1->DA1_CODTAB	:= cTabBra
		DA1->DA1_CODPRO	:= cCodPro
		DA1->DA1_MOEDA	:= 1
		/*
		DA1->DA1_PRCVEN	:= nPrcTab+(nPrcTab * fFator("AV"))
		DA1->DA1__PREC2	:= nPrcTab+(nPrcTab * fFator("30"))
		DA1->DA1__PREC3	:= nPrcTab+(nPrcTab * fFator("3060"))
		DA1->DA1__PREC4	:= nPrcTab+(nPrcTab * fFator("306090"))
		*/
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
//
IF SELECT("TMP") > 0
	dbSelectArea("TMP")
	TMP->(dbCloseArea())
Endif

if cFator == "AV"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='001' AND ZX5_SEGISP='1 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "30"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='002' AND ZX5_SEGISP='1 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "3060"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='003' AND ZX5_SEGISP='1 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Elseif cFator == "306090"
	mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 "
	mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='004' AND ZX5_SEGISP='1 ' AND "
	mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_ = ' ' "
Endif

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
TMP->( DbGoTop() )

IF TMP->(!Eof())
	//nFT := Val(TMP->ZX5_DSCITE) /100
	nFT := Val(TMP->ZX5_DSCITE)
Endif

TMP->(dbCloseArea())

Return(nFT)


// Rotina de Reajuste dentro da Regra de Reajustes da Tabela
Static Function fReajt(cUF,cSeg,cGrupo,cSubGrp,nPreco,nIPI,cCodPro)
Local nRejt  := 0
Local nValor := 0 

nRejt := fCalcRjt(cUF,cSeg,cGrupo,cSubGrp,nIPI,cCodPro)

//nValor	:= nPreco //+ (nPreco * (nIPI / 100))
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

/*IF SELECT("TM1") > 0
	dbSelectArea("TM1")
	TM1->(dbCloseArea())
Endif

//PESQ. POR : SEGMENTO + UF + SUBGRUPO + ALIQ
mSQL := "SELECT Z13_REAJUS "
mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"' AND Z13_SUBGRP='"+cSUBGRP+"' AND Z13_IPI="+Str(nIPI)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
TM1->( DbGoTop() )

IF TM1->(!Eof())
	nRejt := TM1->Z13_REAJUS
Else
	//PESQ. POR : SEGMENTO + UF + GRUPO + ALIQ
	IF SELECT("TM1") > 0
		dbSelectArea("TM1")
		TM1->(dbCloseArea())
	Endif
	mSQL := "SELECT Z13_REAJUS "
	mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
	mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
	mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"' AND Z13_GRUPO='"+cGrupo+"' AND Z13_IPI="+Str(nIPI)
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
	TM1->( DbGoTop() )
	
	IF TM1->(!Eof())
		nRejt := TM1->Z13_REAJUS
	Else
		//PESQ. POR :  SEGMENTO + UF + ALIQ
		IF SELECT("TM1") > 0
			dbSelectArea("TM1")
			TM1->(dbCloseArea())
		Endif
		
		mSQL := "SELECT Z13_REAJUS "
		mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
		mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
		mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"' AND Z13_IPI="+Str(nIPI)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
		TM1->( DbGoTop() )
		
		IF TM1->(!Eof())
			nRejt := TM1->Z13_REAJUS
		Else
			//PESQ. POR : SEGMENTO + UF + SUBGRUPO
			IF SELECT("TM1") > 0
				dbSelectArea("TM1")
				TM1->(dbCloseArea())
			Endif
			
			mSQL := "SELECT Z13_REAJUS "
			mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
			mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
			mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"'AND Z13_SUBGRP='"+cSUBGRP+"'"
			DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
			TM1->( DbGoTop() )
			
			IF TM1->(!Eof())
				nRejt := TM1->Z13_REAJUS
			Else
				//PESQ. POR : SEGMENTO + UF + GRUPO
				IF SELECT("TM1") > 0
					dbSelectArea("TM1")
					TM1->(dbCloseArea())
				Endif
				
				
				mSQL := "SELECT Z13_REAJUS "
				mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
				mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
				mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"' AND Z13_GRUPO='"+cGrupo+"'"
				DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
				TM1->( DbGoTop() )
				
				IF TM1->(!Eof())
					nRejt := TM1->Z13_REAJUS
				Else
					//PESQ. POR : SEGMENTO + UF
					IF SELECT("TM1") > 0
						dbSelectArea("TM1")
						TM1->(dbCloseArea())
					Endif
					
					mSQL := "SELECT Z13_REAJUS "
					mSQL += " FROM "+RetSqlName("Z13")+" Z13 "
					mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_ = ' ' AND "
					mSQL += " Z13_UF='"+cUF+"' AND Z13_SEGMET='"+cSEG+"'"
					DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TM1",.F.,.T.)
					TM1->( DbGoTop() )
					
					IF TM1->(!Eof())
						nRejt := TM1->Z13_REAJUS
					Endif
					TM1->(dbCloseArea())
					//
				Endif
				//
			Endif
		Endif
	Endif
	
	TM1->(dbCloseArea())
Endif
Return(nRejt * -1)    */


	/*/
	ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
	±±³Fun‡…o ³ fTabLote³ Autor ³ Roberto Marques           ³ Data ³ 25/08/14 ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Descri‡…o ³ Programa para Alterações de Preços  - Nacional -Lote       ³±±
	±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
	±±³Objetivo  ³ Alteração de Preço para Produto Nacional em Lote			  ´±±
	±±³  																	  ³±±
	±±³ 								                                      ´±±
	±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
	ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
	/*/
	
	User Function iFata15A()
	
		local _aArea	    := getArea()
		Private nOpc        := 1	
		private aButtons   	:= {}
		private _dData	 	:= ctod("  /  /  ")
		private oDlg		:= nil
		private oGetTM1		:= nil
		
		oFont := tFont():New("Tahoma",,-12,,.t.)
		
		Aadd( aButtons, {"Excluir Todos", {|| fLtExcTd() }, "Excluir Todos", "Excluir Todos" , {|| .T.}} )     	
		/*
		if ! INCLUI
		_dData	:= DA1->Z02_GRUPO
		_cDesc	:= Z02->Z02_DSCGRP
		_cSegto	:= posicione("ZX5",1,xFilial("ZX5")+space(2)+"000001"+Z02->Z02_GRUPO,"ZX5_SEGISP")
		endif
		*/
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
		
		
		//if ! alltrim(str(nOpc)) $ '1/4'
		aEdit	:= {"DA1_CODPRO","PRCNV","PORC"}
		//endif
		
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek("DA1_CODPRO")
			aadd(aHeader, {Trim(SX3->X3_Titulo),;
			SX3->X3_Campo       ,;
			SX3->X3_Picture     ,;
			SX3->X3_Tamanho     ,;
			SX3->X3_Decimal     ,;
			"u_IFATA15B()"     ,;
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
		"U_IFATA15pv()"			,;
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
		"U_IFT15P()"			,;
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
	

	User function IFATA15B()
		local _lVal := .T.
		
		local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
		local _cDescri	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_DESC" })
		local _RECNO		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "RECNO" })
		
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
    	mSQL += "    				AND DA1_CODTAB ='" + getMV("MV__TABBRA") + "' 				" + Chr(13)
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
	
User Function IFATA15pv()
	Local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
	Local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
	Local _lVal     := .T.
	
	oGetTM1:Acols[oGetTM1:nat][_PORC] := ((M->PRCNV * 100) / oGetTM1:Acols[oGetTM1:nat][_PrcVend]) - 100

Return _lVal

User Function IFT15P()

	local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
	local _NV	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PRCNV" })
	local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
	local _lVal := .T.
	Local nValor
	
	aCols[n][_NV] := (aCols[n][_PrcVend] * M->PORC) / 100
	
Return _lVal


static function validar(nOpc)
	lOk := .T.
	
	if empty(_dData)
		msgAlert ("Data deve ser preenchido. Favor verificar !!")
		lOk := .F.
	endif
	
	/*
	if empty(M->DA1_CODPRO)
		msgAlert ("O código do Grupo deve ser preenchido. Favor verificar !!")
		lOk := .F.
	endif
	
	if empty(M->PRCNV)                                                                            
		msgAlert ("O Preco Novo deve ser preenchido . Favor verificar !!")
		lOk := .F.
	endif
	
	if empty(M->PORC)
		msgAlert ("O Porcentagem deve ser preenchido . Favor verificar !!")
		lOk := .F.
	endif
	*/

	if len(oGetTM1:Acols) == 0
		Alert ("Nenhum produto lançado !!")
		lOk := .F.
	endif
	
	if lOk
		IFATA15C()
		oDlg:End()
	endif
return lOk
	
	
	Static function IFATA15C()
	//"PRCNV","PORC","DA1_CODPRO","B1_DESC","DA1_PRCVEN"
	local _CodPro	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_CODPRO" })
	local _nPRCNV	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PRCNV" })
	local _nPORC	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })
	Local cSeg		:= ""
	Local cGrupo	:= ""
	Local cSubGrp 	:= ""
	Local lRet	:= .F.
	
	
	
	for x:=1 to len(oGetTM1:Acols)
		
		If oGetTM1:Acols[x][Len(oGetTM1:aHeader) + 1]
            Loop
		EndIf
				
		dbSelectArea( "DA1" )
		DA1->( dbSetOrder( 1 ) )
	//	If DA1->( dbSeek( xFilial( "DA1" ) + getMV("MV__TABBRA") + oGetTM1:Acols[X][_CodPro] ) )
			
			
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
			GeraTbUF(oGetTM1:Acols[X][_CodPro],cSeg,cGrupo,cSubGrp,oGetTM1:Acols[x][_nPrcNV],_dData,nIPI)
			lRet := .T.
			
	  //	Endif
		
	next x
	
	if lRet == .T.
		MsgInfo(OemToAnsi("Alterações realizada com sucesso."))
	Else
		MsgInfo(OemToAnsi("Não foi processado nenhuma alteração na tabela de preço."),OemToAnsi("Atencao"))
	Endif
	
	Return
	
	Static Function fLtExcTd()

		local _nRECNO	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "RECNO" })
		Local lRet	:= .F.
	
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
	
	mSQL := "SELECT MAX(DA1_ITEM)QUANT FROM "+RetSqlName("DA1")+" WHERE DA1_CODTAB='001'"
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"XX1",.F.,.T.)
	XX1->( DbGoTop() )
	If XX1->(!Eof())
		nRet := XX1->QUANT
	Endif
	XX1->(dbCloseArea())
	
	Return (nRet)
	
	
Static Function fPsqSB1A()
	Local lRet := .T.
   /*
	if Alltrim(cCodDe) =""
		Return .T.
	Endif


	dbSelectArea("SB1")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SB1")+cCodDe) 
	     Alert("Verifique o codigo do produto ")
	     lRet := .F.
	Endif
	
/*
cDescr  := Posicione("SB1",1,xFilial("SB1")+cCodDe,"B1_DESC")
oDescr:Refresh()
*/   

Return lRet
	
Static Function fPsqSB1B()
	Local lRet := .T.
/*
	if Alltrim(cCodAte) =""
		Return .T.
	Endif
	
	dbSelectArea("SB1")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SB1")+cCodAte) 
	     Alert("Verifique o codigo do produto ")
	     lRet := .F.
	Endif
/*
cDescr2  := Posicione("SB1",1,xFilial("SB1")+cCodAte,"B1_DESC")
oDescr2:Refresh()
*/
Return lRet

	
Static Function fPsqSB1C()
	Local lRet := .T.
	Local _nLin
	Local mSQL := ""
	local nFOB := 0
	LOcal nMag := 0
	Local nMargem := 0
	Local nValor := 0
	Local cData  := Ctod("  /  /  ")
	Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
	Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
	Local nPosMarc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "MARCA" 	})
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
	
	mSQL := "SELECT max(B1_COD) B1_COD,max(B1_DESC) B1_DESC,max(Z5_DESC) Z5_DESC,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, max(Z8_ORDEM) Z8_ORDEM, Z9_SEQ,"
	mSQL += " DA1_PRCVEN,MAX(SC7.C7_EMISSAO)DTPED,DA1_DATVIG "
	mSQL += " FROM "+RetSqlName("SB1")+" SB1 "
	mSQL += " LEFT JOIN "+RetSqlName("DA1")+" DA1 ON DA1_FILIAL='" + xFilial("DA1") + "' AND DA1_CODTAB ='" + Alltrim(getMV("MV__TABBRA")) + "' AND "
	mSQL += " DA1_CODPRO=B1_COD AND DA1_ESTADO='  ' AND DA1.D_E_L_E_T_ = ' ' " 
	If 	cPrcAte > 0
		mSQL += " AND DA1_PRCVEN >="+Str(cPrcDe)+" AND DA1_PRCVEN <="+Str(cPrcAte)
	Endif
	mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON SD1.D1_COD=B1_COD AND D1_EMISSAO >='"+DtoS(cDtDe)+"' AND D1_EMISSAO <='"+DtoS(cDtAte)+"' And SD1.D_E_L_E_T_ = ' ' "
	mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND D1_PEDIDO=SC7.C7_NUM AND SC7.D_E_L_E_T_ = ' ' "
	mSQL += " LEFT JOIN "+RetSqlName("SZ5")+" SZ5 ON Z5_CODIGO=B1__MARCA And SZ5.D_E_L_E_T_ = ' ' "

//	If !Empty(cIdAte)
	    mSQL += " INNER JOIN " + RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND Z9_PRODUTO=B1_COD AND "
	    mSQL += " Z9_COD Between '" + cIdDe + "' AND '"+cIdAte+"' And SZ9.D_E_L_E_T_ = ' ' "

	    mSQL += " INNER JOIN " + RetSqlName("SZ8")+" SZ8 ON Z8_FILIAL=Z9_FILIAL AND Z9_COD=Z8_COD And SZ8.D_E_L_E_T_ = ' ' "
//	EndIf    
	mSQL += " WHERE B1_FILIAL='"+xFilial("SB1")+"' "
	
	If !Empty(cCodDe)
	    mSQL += " And B1_COD >= '"+cCodDe+"' AND B1_COD<='"+cCodAte+"' "
	EndIf
	
	If !Empty(cMarcDe)
	    mSQL += " And Z5_DESC >='"+cMarcDe+"' AND Z5_DESC <='"+cMarcAte+"' "
	EndIf
	
	If !Empty(cGrpDe)
	    mSQL += " And B1_GRUPO >='"+cGrpDe+"' AND B1_GRUPO <='"+cGrpAte+"' "
	EndIf
	
	mSQL += " AND SB1.D_E_L_E_T_ = ' ' "
	
	If Val(cSegto) > 0
		mSQL += " And B1__SEGISP = '" + cSegto + "' "
	EndIf
	If !Empty(cDescr)
	    mSQL += " And B1__DESCP Like '%"+cDescr+"%' "
	EndIf

	if cCombo2 == 'Ativo'
	    mSQL += " And B1_ATIVO <> 'N' "
	elseif cCombo2 == 'Inativo'
	    mSQL += " And B1_ATIVO = 'N' "
	endif
		
	mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,Z5_DESC,DA1_DATVIG,Z8_SEQUEN, Z9_SEQ "
	
	If cCombo == "Por Cód.Produto"                                   
		mSQL += " ORDER BY B1_COD,B1_DESC,Z5_DESC "
	ElseIf cCombo == "Por Descrição"
		mSQL += " ORDER BY B1_DESC,Z5_DESC "
	ElseIf cCombo == "Por Marca"
		mSQL += " ORDER BY Z5_DESC,B1_DESC "       
	else
		mSQL += " ORDER BY Z8_ORDEM, Z9_SEQ "       
	Endif
	
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
			
			/*ACSJ - 14 de Novembro de 2014
			         Alteração de formula solicitada pelo Marcelo(ISAPA)
			         Preço com Desconto / nFOB [preço com desconto fixo 0]
			nMargem	:= TDA1->DA1_PRCVEN / TDA1->VLRREP                    */
			
			nPrcDesc	:= 0
			
			nMargem	:= nPrcDesc / nFob
			
			AAdd(oBrw1:aCols, Array(nQtdCpo+1))
			nn++
					
			oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
			oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
			oBrw1:Acols[nn][nPosMarc]			:= TDA1->Z5_DESC
			oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
			oBrw1:Acols[nn][nPosFOB]			:= nFOB
			oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
			oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO
			oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN
			oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DA1_DATVIG) //STOD(TDA1->DTPED)
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
cDtDe      := Ctod("01/01/" + Alltrim(Str(_nAno)))
cDtAte     := Ctod("01/01/" + Alltrim(Str(_nAno + 1)))
cMarcDe    	:= Space(04)
cMarcAte   	:= "ZZZZ"
//cPorc      	:= 0.00
cPrcAte    	:= 0.00
cPrcDe     	:= 0
oBrw1:aCols	:= {}
oBrw1:oBrowse:Refresh()

Return



User Function fValOr()

Local nPosVlNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLNOVO" 	})
Local nPosDtNv	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DTNOVO" 	})
Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
Local lRet := .T. 
Local _cOrigem	:= ""

if oBrw1:aCols[n][nPosVlNv] == 0 .AND. 	oBrw1:aCols[n][nPosDtNv] == Ctod("  /  /  ")

	_cOrigem := Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[n][nPosProd],"B1_ORIGEM")

	If  _cOrigem == "0"
		MsgInfo(OemToAnsi("Produto de origem nacional. Preço não pode ser alterado !!"))

		lRet := .F.

	EndIf
endif

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