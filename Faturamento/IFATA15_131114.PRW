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

	Local aItems  	   := {'Por Cód.Produto','Por Descrição','Por Marca' }  
	Local aItems2 	   := {'Ativo','Inativo' }  
	Private aEdit	   := {"VLNOVO", "DTNOVO"}
    Private cCodDe     := Space(15)
	Private cCodAte    := "ZZZZZZZZZZZZZZZ"
	Private cDtDe      := Ctod("01/01/2014")
	Private cDtAte     := Ctod("01/01/2015")
	Private cDescr     := Space(60)
	Private cGrpDe     := Space(04)
	Private cGrpAte    := "ZZZZ"
	Private cIdDe      := Space(06)
	Private cIdAte     := "ZZZZZZ"
	Private cMarcDe    := Space(04) 
	Private cMarcAte   := "ZZZZ"
	

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
	aAdd(aHeadsc,{"Margem"  			, "MARGEM"		,"@E 99,999.99" ,10,2,"" ,""  ,"N" , "" ,"","","","","",".F."}) 

	
	
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgTbPrc  := MSDialog():New( 138,208,666,1304,"Acesso às Alterações de Preços - Bicicletas",,,.F.,,,,,,.T.,,,.T. )
	oGrp1      := TGroup():New( 004,004,084,532,"Seleção",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay1      := TSay():New( 016,008,{||"A Partir Identificação"}	,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay2      := TSay():New( 028,008,{||"      Até Identificação"}	,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay3      := TSay():New( 016,108,{||"A Partir Grupo"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oSay4      := TSay():New( 028,108,{||"      Até Grupo"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oSay5      := TSay():New( 016,184,{||"A Partir Item"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay6      := TSay():New( 028,184,{||"      Até Item"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay7      := TSay():New( 016,288,{||"Nome Item"}				,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,028,008)
	oSay8      := TSay():New( 048,016,{||"A Partir Marca"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oSay9      := TSay():New( 060,016,{||"      Até Marca "}		,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,036,008)
	oSay10     := TSay():New( 048,124,{||"A Partir Data Reposição"}	,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,060,008)
	oSay11     := TSay():New( 060,132,{||" Até Data Reposição"}		,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,052,008)
	oSay12     := TSay():New( 048,260,{||"A Partir Preço"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oSay13     := TSay():New( 060,268,{||"Até Preço"}				,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oSay14     := TSay():New( 048,352,{||"Ordenar por "}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay15     := TSay():New( 060,364,{||" Status"}					,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oIdDE      := TGet():New( 016,060,{|u| If(PCount()>0,cIdDe:=u,cIdDe)}		,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdDe",,)
	oIdAte     := TGet():New( 028,060,{|u| If(PCount()>0,cIdAte:=u,cIdAte)}		,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ8","cIdAte",,)
	oGrpDe     := TGet():New( 016,152,{|u| If(PCount()>0,cGrpDe:=u,cGrpDe)}		,oGrp1,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBM","cGrpDe",,)
	oGrpAte    := TGet():New( 028,152,{|u| If(PCount()>0,cGrpAte:=u,cGrpAte)}	,oGrp1,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SBM","cGrpAte",,)
	oCodDe     := TGet():New( 016,220,{|u| If(PCount()>0,cCodDe:=u,cCodDe)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodDe",,)
	oCodAte    := TGet():New( 028,220,{|u| If(PCount()>0,cCodAte:=u,cCodAte)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SB1","cCodAte",,)
	oDescr     := TGet():New( 016,320,{|u| If(PCount()>0,cDescr:=u,cDescr)}		,oGrp1,136,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescr",,)
	
	oBtnLmp    := TButton():New( 016,480,"Limpar"	,oGrp1,					,037,012,,,,.T.,,"",,,,.F. )
	oBtnPsq    := TButton():New( 048,480,"Filtrar"	,oGrp1,{||fuPesqTAB()  },037,012,,,,.T.,,"",,,,.F. )
	
	oMarcDe    := TGet():New( 048,060,{|u| If(PCount()>0,cMarcDe:=u,cMarcDe)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ5","cMarcDe",,)
	oMarcAte   := TGet():New( 060,060,{|u| If(PCount()>0,cMarcAte:=u,cMarcAte)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"SZ5","cMarcAte",,)
	oDtDe      := TGet():New( 048,188,{|u| If(PCount()>0,cDtDe:=u,cDtDe)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtDe",,)
	oDtAte     := TGet():New( 060,188,{|u| If(PCount()>0,cDtAte:=u,cDtAte)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtAte",,)
	oPrcDe     := TGet():New( 048,300,{|u| If(PCount()>0,cPrcDe:=u,cPrcDe)}		,oGrp1,044,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcDe",,)
	oPrcAte    := TGet():New( 060,300,{|u| If(PCount()>0,cPrcAte:=u,cPrcAte)}	,oGrp1,044,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcAte",,)

	oCBOrd     := TComboBox():New( 048,388,{|u| If(PCount()>0,cCombo:=u,cCombo)}  ,aItems ,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo  )
	oCBSta     := TComboBox():New( 060,388,{|u| If(PCount()>0,cCombo2:=u,cCombo2)},aItems2,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo2 )
	
 	oBrw1		:= MsNewGetDados():New(	092	,;	//01 -> nTop		Linha Inicial
										004	,;	//02 -> nLelft		Coluna Inicial
										212	,;	//03 -> nBottom		Linha Final	
										532	,;	//04 -> nRight      Coluna Final
										GD_UPDATE	,;	//05 -> nStyle:		Controle do que podera ser realizado na GetDado
										{ || fValid() }	,;	//06 -> ulinhaOK:	Funcao ou CodeBlock para validar a edicao da linha
										{ || .T. }		,;	//07 -> uTudoOK: 	Funcao ou CodeBlock para validar todas os registros da GetDados
										NIL				,;	//08 -> cIniCpos:	Campo para Numeracao Automatica
										aEdit			,;	//09 -> aAlter: 	Array unidimensional com os campos Alteraveis
										0				,;	//10 -> nfreeze:	Numero de Colunas para o Freeze
										Len( aColssc )	,; 	//11 -> nMax:		Numero Maximo de Registros na GetDados	
										NIL				,;	//12 -> cFieldOK:	?
										NIL				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
										{ || .F. }		,;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
										oDlgTbPrc		,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
										aHeadsc			,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
										aColssc			 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
									 	)//...
	 								 	
							 	

    oBrw1:aCols := {}
	oBrw1:oBrowse:Refresh()


	oGrp2      := TGroup():New( 220,004,252,532,"",oDlgTbPrc,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oSay16     := TSay():New( 232,192,{||"% Preço Novo"},oGrp2,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,040,008)
	oBtnImpr   := TButton():New( 232,012,"Imprimir",oGrp2,,052,012,,,,.T.,,"",,,,.F. )
	oBtnImAlt  := TButton():New( 232,068,"Imprimir Alterações"	,oGrp2,,052,012,,,,.T.,,"",,,,.F. )
	oBtnTodo   := TButton():New( 232,132,"Marcar Todos"			,oGrp2,{||fMarcaTds()		},052,012,,,,.T.,,"",,,,.F. )
	oPorc      := TGet():New( 232,232,{|u| If(PCount()>0,cPorc:=u,cPorc)},oGrp2,044,008,'@E 99.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPorc",,)
	oBtnAltPrc := TButton():New( 232,316,"Alterar Preço"		,oGrp2,{||U_iFata15A()		},037,012,,,,.T.,,"",,,,.F. )
	oBtnDsc    := TButton():New( 232,360,"Desconto" 			,oGrp2,						 ,037,012,,,,.T.,,"",,,,.F. )
	oBtnProc   := TButton():New( 232,404,"Processar"			,oGrp2,{||fProc()			},037,012,,,,.T.,,"",,,,.F. )
	oBtnSair   := TButton():New( 232,488,"Sair"					,oGrp2,{||oDlgTbPrc:End()	},037,012,,,,.T.,,"",,,,.F. )
	
	oDlgTbPrc:Activate(,,,.T.)
	


	
Return

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
		
	mSQL := "SELECT B1_COD,B1_DESC,B1__MARCA,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, "
	mSQL += " DA1_PRCVEN,MAX(SC7.C7_EMISSAO)DTPED,Z9_COD,DA1_DATVIG "
	mSQL += " FROM "+RetSqlName("DA1")+" DA1 "
	mSQL += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
//	mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ <>'*' "
	mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND SD1.D_E_L_E_T_ <>'*' "
	mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ <>'*' AND D1_PEDIDO=SC7.C7_NUM "
	mSQL += " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_ <>'*' AND Z9_PRODUTO=DA1_CODPRO "
	
	mSQL += " WHERE DA1_FILIAL='  ' AND DA1.D_E_L_E_T_ = ' ' AND "
	mSQL += " D1_EMISSAO >='"+DtoS(cDtDe)+"' AND D1_EMISSAO <='"+DtoS(cDtAte)+"' AND "
	mSQL += " B1__MARCA >='"+cMarcDe+"' AND B1__MARCA <='"+cMarcAte+"' AND "
	mSQL += " B1_GRUPO >='"+cGrpDe+"' AND B1_GRUPO <='"+cGrpAte+"' AND "
	mSQL += " DA1_CODPRO >='"+cCodDE+"' AND DA1_CODPRO <='"+cCodAte+"' AND "  
	mSQL += " DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='  ' AND "	
	mSQL += " Z9_COD >='"+cIdDe+"' AND Z9_COD<='"+cIdAte+"' "
	
	If 	Val(cSegto) > 0
		mSQL += " And B1__SEGISP = '" + cSegto + "' "
	EndIf
	
	
	If 	cPrcAte > 0
		mSQL += " AND DA1_PRCVEN >="+Str(cPrcDe)+" AND DA1_PRCVEN <="+Str(cPrcAte) 
    Endif
    
	mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,B1__MARCA,Z9_COD,DA1_DATVIG "
	
	If cCombo == "Por Cód.Produto"
		mSQL += " ORDER BY B1_COD,B1_DESC,B1__MARCA "
	ElseIf cCombo == "Por Descrição"
		mSQL += " ORDER BY B1_DESC,B1__MARCA "
	Else
		mSQL += " ORDER BY B1__MARCA,B1_DESC "
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
	  
	        
	        nMargem	:= TDA1->DA1_PRCVEN / TDA1->VLRREP

			AAdd(oBrw1:aCols, Array(nQtdCpo+1))
			nn++

			oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
			oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
			oBrw1:Acols[nn][nPosMarc]			:= TDA1->B1__MARCA
			oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
			oBrw1:Acols[nn][nPosFOB]			:= nFOB
			oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
			oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO		
			oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN
			oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DA1_DATVIG) //STOD(TDA1->DTPED)
			oBrw1:Acols[nn][nPosVlNv]			:= nValor
			oBrw1:Acols[nn][nPosDtNv]			:= cData
			oBrw1:Acols[nn][nPosVlDsc]			:= 0
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
	

		If cPorc <> 0.00
			for x:=1 to len(oBrw1:Acols)
				oBrw1:Acols[x][nPosVlNv]	:= oBrw1:Acols[x][nPosPrTab]+(oBrw1:Acols[x][nPosPrTab]*cPorc /100)
				if oBrw1:Acols[1][nPosDtNv] <> Ctod("  /  /  ")
					oBrw1:Acols[x][nPosDtNv]	:= oBrw1:Acols[1][nPosDtNv]			
				Endif
			next x
		Else
			for x:=1 to len(oBrw1:Acols)
	            IF	oBrw1:Acols[1][nPosVlNv] <> 0.00
					oBrw1:Acols[x][nPosVlNv] := oBrw1:Acols[1][nPosVlNv]
				Endif
				IF	oBrw1:Acols[1][nPosDtNv] <> Ctod("  /  /  ")
					oBrw1:Acols[x][nPosDtNv] := oBrw1:Acols[1][nPosDtNv]			
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
	Local cSeg		:= ""
	Local cGrupo	:= ""
	Local cSubGrp 	:= ""
    Local nIPI		:= 0
	Local lRet	:= .F.
			for x:=1 to len(oBrw1:Acols)
       		
	   			dbSelectArea( "DA1" )
				DA1->( dbSetOrder( 1 ) )
				If DA1->( dbSeek( xFilial( "DA1" ) + getMV("MV__TABBRA") + oBrw1:Acols[X][nPosProd] ) )
       			
	       			IF	oBrw1:Acols[x][nPosVlNv] <> 0.00 .AND. oBrw1:Acols[x][nPosDtNv] <> Ctod("  /  /  ")
	       				
	       				cSeg   	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1__SEGISP")
	       				cGrupo 	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1_GRUPO")
	       				cSubGrp	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1__SUBGRP")   
	       				nIPI 	:= Posicione("SB1",1,xFilial("SB1")+ oBrw1:Acols[X][nPosProd],"B1_IPI")   
	       				Reclock("DA1", .F.)
						DA1->DA1_PRCVEN	:= oBrw1:Acols[x][nPosVlNv]
						DA1->DA1_DATVIG	:= oBrw1:Acols[x][nPosDtNv]
						MsUnLock()
						GeraTbUF(oBrw1:Acols[X][nPosProd],cSeg,cGrupo,cSubGrp,oBrw1:Acols[x][nPosVlNv],oBrw1:Acols[x][nPosDtNv],nIPI)
						lRet := .T.
	     			ENDIF
                Endif
                
			next x
			
       if lRet == .T. 
		   MsgInfo(OemToAnsi("Alterações realizada com sucesso."),OemToAnsi("Atencao"))
       Else
	       MsgInfo(OemToAnsi("Não foi processado nenhuma alteração na tabela de preço."),OemToAnsi("Atencao"))
       Endif		
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
	Local cTabBra := getMV("MV__TABBRA")
	Local cUF 	  := getMV("MV__TABPUF")
 	Local aUF 	  := {}
    Local nPrcTab := 0
    Local iCt	  := .F.
    
    //cPrcTab := fReajt(aUF[i],cSeg,cGrupo,cSubGrp,nPreco)
    
    aUF	:= strtokarr(cUF, ',')    
    
    For i:=1 to Len(aUF)
	   
	   nPrcTab := fReajt(aUF[i],cSeg,cGrupo,cSubGrp,nPreco,nIPI)     

	  IF SELECT("TDA1") > 0
		dbSelectArea("TDA1")
		TDA1->(dbCloseArea())
	  Endif

	  mSQL := "SELECT * FROM "+RetSqlName("DA1")+" DA1 "
	  mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND D_E_L_E_T_ <>'*' AND DA1_CODPRO='"+cCodPro+"'" 
	  mSQL += " AND DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='"+aUF[i]+"'"	
	  mSQL += " AND DA1_DATVIG='"+DtoS(cData)+"' "
      
	  DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
	  TDA1->( DbGoTop() )
	
	  IF TDA1->(!Eof())
		iCt	:= .T.
	  ENDIF
      TDA1->(dbCloseArea())
      
      IF iCt == .T.
      	  _PrAV	 := nPrcTab+(nPrcTab * fFator("AV"))
		  _Pr2	 := nPrcTab+(nPrcTab * fFator("30"))
		  _Pr3	 := nPrcTab+(nPrcTab * fFator("3060"))
		  _Pr4 	 := nPrcTab+(nPrcTab * fFator("306090"))

	      mSQL :="UPDATE "+RetSqlName("DA1")+"SET DA1_PRCVEN="+Str(_PrAV)+",DA1_PREC2="+Str(_Pr2)
	      mSQL += ",DA1_PREC3="+Str(_Pr2)+",DA1_PREC4="+Str(_Pr4)
	      mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND D_E_L_E_T_ <>'*' AND DA1_CODPRO='"+cCodPro+"'" 
	   	  mSQL += " AND DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='"+aUF[i]+"'"	
		  mSQL += " AND DA1_DATVIG ='"+DtoS(cData)+"' "
		  Begin Transaction
			TCSQLExec(mSQL)
          End Transaction
	   Else
			Reclock("DA1", .T.)
			DA1->DA1_FILIAL	:= xFILIAL("DA1")
			DA1->DA1_ITEM	:= Soma1(xContDA1()) //Strzero(i,4) 
			DA1->DA1_CODTAB	:= cTabBra
			DA1->DA1_CODPRO	:= cCodPro
			DA1->DA1_GRUPO	:= cGrupo
			DA1->DA1_REFGRD	:= ""                 
			DA1->DA1_PRCVEN	:= nPrcTab+(nPrcTab * fFator("AV"))
			DA1->DA1__PREC2	:= nPrcTab+(nPrcTab * fFator("30"))
			DA1->DA1__PREC3	:= nPrcTab+(nPrcTab * fFator("3060"))
			DA1->DA1__PREC4	:= nPrcTab+(nPrcTab * fFator("306090"))
			DA1->DA1_ESTADO	:= aUF[i]
			DA1->DA1_INDLOT	:= "00000000000999999.99"
			DA1->DA1_ATIVO	:= '1'
			DA1->DA1_DATVIG	:= cData
			DA1_QTDLOT		:= 999999.99
			DA1_TPOPER		:= '4'
			MsUnLock()
	   Endif 
	
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
		mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='001' AND "
		mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_<>'*' "
	 Elseif cFator == "30"
		mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 " 
		mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='002' AND "
		mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_<>'*' "
    Elseif cFator == "3060"
		mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 " 
		mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='003' AND "
		mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_<>'*' "
	Elseif cFator == "306090"
		mSQL := "SELECT ZX5_DSCITE FROM "+RetSqlName("ZX5")+" ZX5 " 
		mSQL += " WHERE ZX5_GRUPO='000007' AND ZX5_CODIGO='004' AND "
		mSQL += " ZX5_FILIAL='"+xFILIAL("ZX5")+"' AND D_E_L_E_T_<>'*' "
    Endif 
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
	
	IF TMP->(!Eof())
		nFT := Val(TMP->ZX5_DSCITE) /100
	Endif
	
   TMP->(dbCloseArea())
	
	Return(nFT)               


// Rotina de Reajuste dentro da Regra de Reajustes da Tabela
Static Function fReajt(cUF,cSeg,cGrupo,cSubGrp,nPreco,nIPI)
	Local nRejt  := 0
	Local nValor := 0

	nRejt := fCalcRjt(cUF,cSeg,cGrupo,cSubGrp,nIPI)
    
    nValor	:= nPreco + (nPreco * nIPI / 100)  
    nValor 	:= nValor + (nValor * nRejt / 100)  

Return(nValor) 

Static Function fCalcRjt(cUF,cSeg,cGrupo,cSubGrp,nIPI)
	Local nRejt  := 0
	// REGRAS PARA CALCULOS 
	// SEGMENTO + UF + SUBGRUPO + ALIQ
	// SEGMENTO + UF + GRUPO + ALIQ
	// SEGMENTO + UF + ALIQ
	// SEGMENTO + UF + SUBGRUPO
	// SEGMENTO + UF + GRUPO
	// SEGMENTO + UF

 	IF SELECT("TM1") > 0
		dbSelectArea("TM1")
		TM1->(dbCloseArea())
	Endif
	  
	//PESQ. POR : SEGMENTO + UF + SUBGRUPO + ALIQ
	mSQL := "SELECT Z13_REAJUS "  
	mSQL += " FROM "+RetSqlName("Z13")+" Z13 " 
	mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
		mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
			mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
				mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
					mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
						mSQL += " WHERE Z13_FILIAL='"+xFilial("Z13")+"' AND D_E_L_E_T_<>'*' AND "	  
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
Return(nRejt)


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

	local _aArea	:= getArea()
	Private nOpc      := 1
	dbSelectArea("DA1")

	
	private aButtons   	:= {}
	private _dData	 	:= ctod("  /  /  ")
	private oDlg		:= nil
	private oGetTM1		:= nil
	
	oFont := tFont():New("Tahoma",,-12,,.t.)
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
	               "@E 99.99"     	,;
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



		_cGds := GD_INSERT + GD_UPDATE + GD_DELETE
	
    	oGetTM1 := MsNewGetDados():New(40, 0, 270, 650, _cGds, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)

	return


	User function IFATA15B()
		local _lVal := .T.
	                      
		local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
		local _cDescri	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_DESC" })	     
		
		IF SELECT("TDA1") > 0
			dbSelectArea("TDA1")
			TDA1->(dbCloseArea())
		Endif        
	
		mSQL :="SELECT B1_COD,B1_DESC,DA1_PRCVEN "
		mSQL +=" FROM "+RetSqlName("DA1")+" DA1 INNER JOIN "+RetSqlName("SB1")+" SB1 "
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
	
	User Function IFATA15pv()
		local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
		local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })	     
		local _lVal := .T.		
		
		aCols[n][_PORC] := M->PRCNV / aCols[n][_PrcVend] 
		
	Return _lVal
	
	User Function IFT15P()

		local _PrcVend	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "DA1_PRCVEN" })
		local _NV	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PRCNV" })	     
		local _PORC		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PORC" })	     
		local _lVal := .T.
		Local nValor
		

		aCols[n][_NV] := aCols[n][_PrcVend] * M->PORC

	Return _lVal


	static function validar(nOpc)
		lOk := .T.		
	    
	    if empty(_dData_)
			msgAlert ("Data deve ser preenchido. Favor verificar !!")
			lOk := .F.		
		endif
	    
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
			msgAlert ("Nenhum produto lançado !!")
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
       		
	   			dbSelectArea( "DA1" )
				DA1->( dbSetOrder( 1 ) )
				If DA1->( dbSeek( xFilial( "DA1" ) + getMV("MV__TABBRA") + oGetTM1:Acols[X][_CodPro] ) )
       			
	       				
	       				cSeg    := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1__SEGISP")
	       				cGrupo  := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1_GRUPO")
	       				cSubGrp := Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1__SUBGRP")   
	       				nIPI	:= Posicione("SB1",1,xFilial("SB1")+ oGetTM1:Acols[X][_CodPro],"B1_IPI")   
	       				
	       				Reclock("DA1", .F.)
						DA1->DA1_PRCVEN	:= oGetTM1:Acols[x][_nPrcNV]
						DA1->DA1_DATVIG	:= oGetTM1:Acols[x][_nPorc]
						MsUnLock()
						GeraTbUF(oGetTM1:Acols[X][_CodPro],cSeg,cGrupo,cSubGrp,oGetTM1:Acols[x][_nPrcNV],_dData,nIPI)
						lRet := .T.
	     			
                Endif
                
			next x
			
       if lRet == .T. 
		   MsgInfo(OemToAnsi("Alterações realizada com sucesso."),OemToAnsi("Atencao"))
       Else
	       MsgInfo(OemToAnsi("Não foi processado nenhuma alteração na tabela de preço."),OemToAnsi("Atencao"))
       Endif		

	Return



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

