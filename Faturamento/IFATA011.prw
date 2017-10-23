#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o ³ IFATA011³ Autor ³ Roberto Marques           ³ Data ³ 19/08/14 ³±±
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

User Function IFATA011()

	Local aItems  	   := {'Por Cód.Produto','Por Descrição','Por Marca' }  
	Local aItems2 	   := {'Ativo','Inativo' }  
	Private aEdit	   := {"VLNOVO", "DTNOVO"}
    Private cCodDe     := Space(15)
	Private cCodAte    := "ZZZZZZZZZZZZZZZ"
	Private cDtDe      := Ctod("01/07/2014")
	Private cDtAte     := Ctod("15/07/2014")
	Private cDescr     := Space(60)
	Private cGrpAte    := "ZZZZ"
	Private cGrpDe     := Space(04)
	Private cIdDe      := Space(06)
	Private cIdAte     := Space(06)
	Private cMarcAte   := "ZZZZ"
	Private cMarcDe    := Space(04) 

	
	/*
	Private cCodAte    := Space(15)
	Private cCodDe     := Space(15)
	Private cDtDe      := Ctod("  /  /  ")
	Private cDtAte     := Ctod("  /  /  ")
	Private cDescr     := Space(60)
	Private cGrpAte    := Space(04)
	Private cGrpDe     := Space(04)
	Private cIdAte     := Space(06)
	Private cIdDE      := Space(06)
	Private cMarcAte   := Space(04)
	Private cMarcDe    := Space(04)
	  */
	Private cCombo  := aItems[1]
	Private cCombo2 := aItems[1]

	
	Private cPorc      := 0.00
	Private cPrcAte    //:= Space(1)
	Private cPrcDe     //:= Space(1)
//	Private nCBOrd    
//	Private nCBSta
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
	aAdd(aHeadsc,{"Produto"             , "PROD"     	, ""  		   ,15,0,"" , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Descrição"           , "DESC"     	, ""  		   ,40,0,"" , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Marca"               , "MARCA"   	, ""  		   ,20,0,"" , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Dt Reposição"   		, "DTREP"    	, ""  		   ,10,0,"" , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"FOB (US$)"    		, "FOB"  		,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Valor Reposição"   	, "VLREP"  		,"@E 99,999.99",09,2,"" ,""  ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Custo"       		, "CUSTO"    	,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Preço Tabela"        , "PRTAB"    	,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Dt Validade"    		, "DTVAL"    	,""			   ,10,0,"" ,""	 ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Preço Novo"     	 	, "VLNOVO"   	,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".T."})  
	aAdd(aHeadsc,{"Dt Nova Validade"   	, "DTNOVO"    	, "" 		   ,10,0,"" ,""	 ,"C" , "" ,"","","","","",".T."})	
	aAdd(aHeadsc,{"Preço Desconto"      , "VLDESC"   	,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Margem"  			, "MARGEM"		,"@E 99,999.99",09,2,"" ,""	 ,"N" , "" ,"","","","","",".F."}) 

	
	
	
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
	oSay12     := TSay():New( 048,260,{||"A Partir Preço"}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay13     := TSay():New( 060,268,{||"Até Preço"}				,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,024,008)
	oSay14     := TSay():New( 048,352,{||"Ordenar por "}			,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oSay15     := TSay():New( 060,364,{||" Status"}					,oGrp1,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,020,008)
	oIdDE      := TGet():New( 016,060,{|u| If(PCount()>0,cIdDe:=u,cIdDe)}		,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cIdDe",,)
	oIdAte     := TGet():New( 028,060,{|u| If(PCount()>0,cIdAte:=u,cIdAte)}		,oGrp1,040,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cIdAte",,)
	oGrpDe     := TGet():New( 016,152,{|u| If(PCount()>0,cGrpDe:=u,cGrpDe)}		,oGrp1,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGrpDe",,)
	oGrpAte    := TGet():New( 028,152,{|u| If(PCount()>0,cGrpAte:=u,cGrpAte)}	,oGrp1,028,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cGrpAte",,)
	oCodDe     := TGet():New( 016,220,{|u| If(PCount()>0,cCodDe:=u,cCodDe)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodDe",,)
	oCodAte    := TGet():New( 028,220,{|u| If(PCount()>0,cCodAte:=u,cCodAte)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cCodAte",,)
	oDescr     := TGet():New( 016,320,{|u| If(PCount()>0,cDescr:=u,cDescr)}		,oGrp1,136,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDescr",,)
	
	oBtnLmp    := TButton():New( 016,480,"Limpar"	,oGrp1,					,037,012,,,,.T.,,"",,,,.F. )
	oBtnPsq    := TButton():New( 048,480,"Filtrar"	,oGrp1,{||fuPesqTAB()  },037,012,,,,.T.,,"",,,,.F. )
	
	oMarcDe    := TGet():New( 048,060,{|u| If(PCount()>0,cMarcDe:=u,cMarcDe)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMarcDe",,)
	oMarcAte   := TGet():New( 060,060,{|u| If(PCount()>0,cMarcAte:=u,cMarcAte)}	,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cMarcAte",,)
	oDtDe      := TGet():New( 048,188,{|u| If(PCount()>0,cDtDe:=u,cDtDe)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtDe",,)
	oDtAte     := TGet():New( 060,188,{|u| If(PCount()>0,cDtAte:=u,cDtAte)}		,oGrp1,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cDtAte",,)
	oPrcDe     := TGet():New( 048,300,{|u| If(PCount()>0,cPrcDe:=u,cPrcDe)}		,oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcDe",,)
	oPrcAte    := TGet():New( 060,300,{|u| If(PCount()>0,cPrcAte:=u,cPrcAte)}	,oGrp1,044,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cPrcAte",,)
	oCBOrd     := TComboBox():New( 048,388,{|u| If(PCount()>0,cCombo:=u,cCombo)}  ,,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo  )
	oCBSta     := TComboBox():New( 060,388,{|u| If(PCount()>0,cCombo2:=u,cCombo2)},,072,010,oGrp1,,,,CLR_BLACK,CLR_WHITE,.T.,,"",,,,,,,cCombo2 )
	
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
	oBtnAltPrc := TButton():New( 232,316,"Alterar Preço"		,oGrp2, 					,037,012,,,,.T.,,"",,,,.F. )
	oBtnDsc    := TButton():New( 232,360,"Desconto" 			,oGrp2,						 ,037,012,,,,.T.,,"",,,,.F. )
	oBtnProc   := TButton():New( 232,404,"Processar"			,oGrp2,{||fProc()		},037,012,,,,.T.,,"",,,,.F. )
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
	Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]9) == "DESC" 	})
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

	
	mSQL := "SELECT B1_COD,B1_DESC,B1__MARCA,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, "
	mSQL += " DA1_PRCVEN,MAX(SC7.C7_EMISSAO)DTPED,Z9_COD "
	mSQL += " FROM "+RetSqlName("DA1")+" DA1 "
	mSQL += " INNER JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
	mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ <>'*' "
	mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ <>'*' AND D1_PEDIDO=SC7.C7_NUM "
	mSQL += " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_ <>'*' AND Z9_PRODUTO=DA1_CODPRO "
	//mSQL += " LEFT JOIN SZ90101 SZ9 ON Z9_FILIAL='  ' AND SZ9.D_E_L_E_T_ <>'*' AND Z9_PRODUTO=DA1_CODPRO "
	mSQL += " WHERE B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND "
	mSQL += " DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
	mSQL += " D1_EMISSAO >='"+DtoS(cDtDe)+"' AND D1_EMISSAO <='"+DtoS(cDtAte)+"' AND "
	mSQL += " B1__MARCA >='"+cMarcDe+"' AND B1__MARCA <='"+cMarcAte+"' AND "
	mSQL += " B1_GRUPO >='"+cGrpDe+"' AND B1_GRUPO <='"+cGrpAte+"' AND "
	mSQL += " DA1_CODPRO >='"+cCodDE+"' AND DA1_CODPRO <='"+cCodAte+"' AND "  
	mSQL += " DA1_CODTAB ='"+getMV("MV__TABBRA")+"' "	
	mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,B1__MARCA,Z9_COD "
	If cCombo == "Por Cód.Produto"
		mSQL += " ORDER BY B1_COD,B1_DESC,B1__MARCA "
	ElseIf cCombo == "Por Descrição"
		mSQL += " GROUP BY B1_DESC,B1__MARCA "
	Else
		mSQL += " GROUP BY B1__MARCA,B1_DESC "
	Endif
	
	//Local aItems2 := {'Ativo','Inativo' }  
		

	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
	TDA1->( DbGoTop() )
	
	If TDA1->(!Eof())

		While TDA1->(!EOF()) 
		

          
		    mSQL := " SELECT C7_PRODUTO,C7_NUM,C7_EMISSAO,C7_PRECO "
	    	mSQL += " FROM "+RetSqlName("SC7")+" SC7 "
	    	mSQL += " WHERE C7_PRODUTO='"+TDA1->B1_COD+"' AND C7_EMISSAO <'"+TDA1->DTPED+"' AND ROWNUM =1 "
	    	//mSQL += " GROUP BY C7_PRODUTO,C7_NUM,C7_PRECO "	
		
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
			oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DTPED)
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
	
	        /*
			oBrw1:Acols[nn][nPosProd]			:= TDA1->B1_COD
			oBrw1:Acols[nn][nPosDesc]			:= TDA1->B1_DESC
			oBrw1:Acols[nn][nPosMarc]			:= TDA1->B1__MARCA
			oBrw1:Acols[nn][nPosDtRep]			:= STOD(TDA1->DTREP)
			oBrw1:Acols[nn][nPosFOB]			:= nFOB
			oBrw1:Acols[nn][nPosVlRep]			:= TDA1->VLRREP
			oBrw1:Acols[nn][nPosCusto]			:= TDA1->CUSTO		
			oBrw1:Acols[nn][nPosPrTab]			:= TDA1->DA1_PRCVEN
			oBrw1:Acols[nn][nPosDTVAL]			:= STOD(TDA1->DTPED)
			oBrw1:Acols[nn][nPosVlNv]			:= nValor
			oBrw1:Acols[nn][nPosDtNv]			:= cData
			oBrw1:Acols[nn][nPosVlDsc]			:= 0
			oBrw1:Acols[nn][nPosMarge]			:= nMargem
			oBrw1:Acols[nn][Len(aHeadsc)+1] 	:= .F.
	        */
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

Static Function fuProc()
	Local lRet	:= .F.
			for x:=1 to len(oBrw1:Acols)
       		
	   			dbSelectArea( "DA1" )
				DA1->( dbSetOrder( 1 ) )
				If DA1->( dbSeek( xFilial( "DA1" ) + getMV("MV__TABBRA") + oBrw1:Acols[X][nPosProd] ) )
       			
	       			IF	oBrw1:Acols[x][nPosVlNv] <> 0.00 .AND. oBrw1:Acols[x][nPosDtNv] <> Ctod("  /  /  ")
	       				Reclock("DA1", .F.)
						DA1->DA1_PRCVEN	:= oBrw1:Acols[1][nPosVlNv]
						DA1->DA1_DATVIG	:= oBrw1:Acols[1][nPosDtNv]
						MsUnLock()
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
