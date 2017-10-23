#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o ³ IFATA012³ Autor ³ Roberto Marques           ³ Data ³ 25/08/14 ³±±
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

User Function IFATA15()

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
	Private bValProduto := {|| fValid(“PRODUTO”)}
	Private aEdit	:= {"PROD", "PRCNV","PORC"}
	Private aHeadsc := {}
	Private aColssc := {}    

	Private cTData     := dDatabase
	Private noBrw  := 0

	// Inicialização do Vetores da Getdados
	aAdd(aHeadsc,{"Produto"             , "PROD"     	,"@!"   	   ,15,0,"Eval(bValProduto)" , "" ,"C" ,"SB1","","","","","",".F."})
	aAdd(aHeadsc,{"Descrição"           , "DESC"     	,"@!" 		   ,40,0,""                  , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Preço Tabela"   		, "VLTAB"    	,"@E 99,999.99",09,2,""                  , "" ,"N" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Preço Novo"    		, "PRCNV"  		,"@E 99,999.99",09,2,""                  , "" ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Percentual"   		, "PORC"  		,"@E 999.99"   ,09,2,""                  , "" ,"N" , "" ,"","","","","",".F."}) 

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlgLote","oSay1","oTData","oBrw","oGrp1","oBtnExc","oBtnProc","oBtnSair")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgLote   := MSDialog():New( 095,438,591,1220,"Alteração de Produtos por Lote",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 008,008,{||"Data Base."},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTData     := TGet():New( 016,008,{|u| If(PCount()>0,cTData:=u,cTData)},oDlgLote,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTData",,)

	oBrw		:= MsNewGetDados():New(	032	,;	//01 -> nTop		Linha Inicial
										008	,;	//02 -> nLelft		Coluna Inicial
										200	,;	//03 -> nBottom		Linha Final	
										376	,;	//04 -> nRight      Coluna Final
										nOpc,;	//05 -> nStyle:		Controle do que podera ser realizado na GetDado
										{ || fValid() }	,;	//06 -> ulinhaOK:	Funcao ou CodeBlock para validar a edicao da linha
										{ || .T. }		,;	//07 -> uTudoOK: 	Funcao ou CodeBlock para validar todas os registros da GetDados
										NIL				,;	//08 -> cIniCpos:	Campo para Numeracao Automatica
										aEdit			,;	//09 -> aAlter: 	Array unidimensional com os campos Alteraveis
										0				,;	//10 -> nfreeze:	Numero de Colunas para o Freeze
										Len( aColssc )	,; 	//11 -> nMax:		Numero Maximo de Registros na GetDados	
										NIL				,;	//12 -> cFieldOK:	?
										NIL				,;	//13 -> usuperdel:	Funcao ou CodeBlock para executar SuperDel na GetDados
										{ || .F. }		,;	//14 -> udelOK:		Funcao, Logico ou CodeBlock para Verificar se Determinada Linha da GetDados pode ser Deletada
										oDlgLote		,;	//15 -> oWnd:		Objeto Dialog onde a GetDados sera Desenhada
										aHeadsc			,;	//16 -> aParHeader:	Array com as Informacoes de Cabecalho
										aColssc			 ;	//17 -> aParCols:	Array com as Informacoes de Detalhes
									 	)//...
	 								 	
							 	

    oBrw:aCols := {}
	oBrw:oBrowse:Refresh()
	
	
	//oBrw       := MsNewGetDados():New(032,008,200,376,nOpc,'AllwaysTrue()','AllwaysTrue()','',,0,99,'AllwaysTrue()','','AllwaysTrue()',oDlgLote,aHoBrw,aCoBrw )
	oGrp1      := TGroup():New( 208,008,236,376,"",oDlgLote,CLR_BLACK,CLR_WHITE,.T.,.F. )
	oBtnExc    := TButton():New( 216,012,"Excluir",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
	oBtnProc   := TButton():New( 216,292,"Processar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
	oBtnSair   := TButton():New( 216,332,"Retornar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
	
	oDlgLote:Activate(,,,.T.)
	
	Return
	
Static Function fValid(cCampo)

	Local lRet := .T.
	Local nY

	lRet := fValCampo(cCampo,oBrw:nAt,.T.)


Return (lRet)

 

Static Function fValCampo(cCampo,nY,lDigitado)

	Local cAlias
	Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
	Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
	Local nPosVlTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLTAB" 	})
	Local nPosPrcNV	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRCNV" 	})
	Local nPosPorc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PORC" 	})


	If cCampo == "PRODUTO"
		
		IF SELECT("TDA1") > 0
			dbSelectArea("TDA1")
			TDA1->(dbCloseArea())
		Endif        

		mSQL :="SELECT B1_COD,B1_DESC,DA1_PRCVEN "
		mSQL +=" FROM "+RetSqlName("DA1")+" DA1 INNER JOIN "+RetSqlName("SB1")+" SB1 "
		mSQL +=" ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
		mSQL +=" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
	  	mSQL +=" DA1_CODPRO ='"+oBrw1:aCols[nY][nPosProd]+"' AND DA1_CODTAB ='001' "  
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
		TDA1->( DbGoTop() )
	
		If TDA1->(!Eof())
			oBrw:aCols[nY][nPosDesc] := TDA1->B1_DESC
			oBrw:aCols[nY][nPosVlTab] := TDA1->DA1_PRCVEN
		Else
			Aviso("Atenção!","Produto inválido ou bloqueado!",{"OK"})
			Return(.F.)

		EndIf

		If Empty(If(lDigitado,TDA1->B1_COD,oBrw1:aCols[nY][nPosProduto]))
			Aviso("Atenção!","Preencha o código do produto.",{"OK"})
			Return(.F.)
   		EndIf
   	Endif	

    /*
	If cCampo == “QUANT”

	If If(lDigitado,M->QUANT,oBrw1:aCols[nY][nPosQuant]) <= 0
		
	Aviso(“Atenção!”,”Preencha a quantidade a ser ajustada.”,{“OK”})
	Return(.F.)
		
	EndIf
		
	If SB1->B1_LOCALIZ == “S” .And. SB1->B1_XXCSER == “S” .And. If(lDigitado,M->QUANT,oBrw1:aCols[nY][nPosQuant]) > 1
		
	Aviso(“Atenção!”,”Produto controla número de série. A quantidade não pode ser diferente de 1.”,{“OK”})
	Return(.F.)
		
	EndIf
		
	EndIf
	*/
	Return 	