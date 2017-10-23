#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o ³ IFATA016³ Autor ³ Roberto Marques           ³ Data ³ 25/08/14 ³±±
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

User Function IFATA16()

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de cVariable dos componentes                                 ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	Local nOpc := GD_INSERT+GD_DELETE+GD_UPDATE
	Local cFieldOk      :="U_fFata16()"
	Private bValCodP 
	//Private bValProduto := {|| fValid("PRODUTO")}
	Private aEdit	:= {"PROD", "PRCNV","PORC"}
	Private aHeadsc := {}
	Private aColssc := {}    
    
    Private	oSay2,oTCod,oSay3,oTDesc,oSay4,oTVlTab,oSay5,oTVlNv,oSay6,oTPorc
	Private	cTCod   := Space(15)
	Private cTDesc  := Space(16)
	Private cTVlTab := 0
	Private cTVlNv  := 0
	Private cTPorc  := 0
    
    
    
	Private cTData     := dDatabase
	Private noBrw  := 0
                     	
	// Inicialização do Vetores da Getdados
	aAdd(aHeadsc,{"Produto"             , "PROD"     	,"@!"   	   ,15,0,"" 				 , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Descrição"           , "DESC"     	,"@!" 		   ,60,0,""                  , "" ,"C" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Preço Tabela"   		, "VLTAB"    	,"@E 99,999.99",09,2,""                  , "" ,"N" , "" ,"","","","","",".F."})
	aAdd(aHeadsc,{"Preço Novo"    		, "PRCNV"  		,"@E 99,999.99",09,2,""                  , "" ,"N" , "" ,"","","","","",".F."}) 
	aAdd(aHeadsc,{"Percentual"   		, "PORC"  		,"@E 999.99"   ,09,2,""                  , "" ,"N" , "" ,"","","","","",".F."})
	
	oBrw := Len(aHeadsc) 
	//aadd(aColssc, Array(noBrw+1))
	
	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Declaração de Variaveis Private dos Objetos                             ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	SetPrvt("oDlgLote","oSay1","oTData","oBrw","oGrp1","oBtnExc","oBtnProc","oBtnSair","oBtnOK")

	/*ÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
	±± Definicao do Dialog e todos os seus componentes.                        ±±
	Ù±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/
	oDlgLote   := MSDialog():New( 095,438,610,1320,"Alteração de Produtos por Lote",,,.F.,,,,,,.T.,,,.T. )
	oSay1      := TSay():New( 008,008,{||"Data Base."},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTData     := TGet():New( 016,008,{|u| If(PCount()>0,cTData:=u,cTData)},oDlgLote,060,008,'',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTData",,)
	//oBrw := MsGetDados():New(032,008,200,aPosObj[2,4]+2,4,"AlterLinOK",/*TudoOk*/,"",.T.,,1,,999,"A010FldOk")
	oSay2     := TSay():New( 026,008,{||"Produto"},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTCod     := TGet():New( 034,008,{|u| If(PCount()>0,cTCod:=u,cTCod)},oDlgLote,060,008,'@!',{||fValProd(cTCod)},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTCod",,)

	oSay3     := TSay():New( 026,070,{||"Decrição"},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTDesc    := TGet():New( 034,070,{|u| If(PCount()>0,cTDesc:=u,cTDesc)},oDlgLote,140,008,'@!',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTDesc",,)

	oSay4     := TSay():New( 026,220,{||"Preço Tabela"},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTVlTab   := TGet():New( 034,220,{|u| If(PCount()>0,cTVlTab:=u,cTVlTab)},oDlgLote,050,008,'@E 99,999.99',,CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTVlTab",,)

	oSay5     := TSay():New( 026,275,{||"Preço Novo"},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTVlNv    := TGet():New( 034,275,{|u| If(PCount()>0,cTVlNv:=u,cTVlNv)},oDlgLote,050,008 ,'@E 99,999.99' ,{||fPrNV()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTVlNv",,)

	oSay6     := TSay():New( 026,325,{||"Percentual"},oDlgLote,,,.F.,.F.,.F.,.T.,CLR_BLACK,CLR_WHITE,032,008)
	oTPorc    := TGet():New( 034,325,{|u| If(PCount()>0,cTPorc:=u,cTPorc)},oDlgLote,050,008,'@E 999.99'		,{||fPorc()},CLR_BLACK,CLR_WHITE,,,,.T.,"",,,.F.,.F.,,.F.,.F.,"","cTPorc",,)
	oBtnOK    := TButton():New( 034,390,"OK",oDlgLote,{||fGrvItem()},020,012,,,,.T.,,"",,,,.F. )	
	oBrw := MsNewGetDados():New(050,008,200,376,nOpc,"AllwaysTrue","AllwaysTrue",,aEdit,,Len( aColssc ),,,,oDlgLote,aHeadsc,aColssc)	
	oBrw:lInsert := .T.
	oBrw:lDelete := .T.
	oBrw:lUpdate := .T.
	fNvCols()
	
	oGrp1      := TGroup():New( 208,008,236,376,"",oDlgLote,CLR_BLACK,CLR_WHITE,.T.,.F. )
	//oBtnExc    := TButton():New( 216,012,"Excluir",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
	oBtnProc   := TButton():New( 216,292,"Processar",oGrp1,,037,012,,,,.T.,,"",,,,.F. )
	oBtnSair   := TButton():New( 216,332,"Retornar",oGrp1,{||oDlgLote:End()},037,012,,,,.T.,,"",,,,.F. )
	oTCod:Setfocus()
	oDlgLote:Activate(,,,.T.)
	
	Return
	
Static Function fValid(cCampo)

	Local lRet := .T.
	Local nY

	lRet := fValCampo(cCampo,oBrw:nAt,.T.)


Return (lRet)

User Function fFata16()

 		LOCAL cVar   := READVAR()          // Obtém o nome da variável
		LOCAL cCont := &(READVAR())     // Obtém o conteúdo da variável
		LOCAL lRet   := .F.

 

		IF cVar == 'M->PROD'

          	lRet := fValProd( &(READVAR()) )

		ELSEIF cVar == 'M->PRCNV'

			lRet := ValidCNPJ( &(READVAR()) )

		ELSEIF cVar == 'M->PORC'

			lRet := ValidCNPJ( &(READVAR()) )

//		ELSE

//          MsgAlert('Campo sem validação disponível! Entre em contato com o administrador do sistema.')

//          MsgAlert('Campo: ' + cVar + ' / Conteúdo: ' + cCont)

		ENDIF

 

RETURN (lRet)

 

Static Function fValProd(cCodPro)
    LOcal mSQL		:= ""
	Local cAlias
	Local nPosProd  :=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
	Local nPosDesc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
	Local nPosVlTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLTAB" 	})
	Local nPosPrcNV	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRCNV" 	})
	Local nPosPorc	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PORC" 	})
    Local iRet		:= .T.
	
	Local nQtdCpo := 0
	Local i       := 0
	Local nCols   := 0                                             

		
		IF ValidCod(cCodPro) 
		
		IF SELECT("TDA1") > 0
			dbSelectArea("TDA1")
			TDA1->(dbCloseArea())
		Endif        

		mSQL :="SELECT B1_COD,B1_DESC,DA1_PRCVEN "
		mSQL +=" FROM "+RetSqlName("DA1")+" DA1 INNER JOIN "+RetSqlName("SB1")+" SB1 "
		mSQL +=" ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
		mSQL +=" WHERE B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
	  	mSQL +=" DA1_CODPRO ='"+cCodPro+"' AND DA1_CODTAB ='"+getMV("MV__TABBRA")+"' "  
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
		TDA1->( DbGoTop() )
	                                                                   	
		If TDA1->(!Eof())
			
			//NwFieldPut(oGet1,"A1_COD",nLinha,"Novo Valor")
			//oBrw:aCols[oBrw:nAt][nPosDesc] 	:= TDA1->B1_COD 
			//oBrw:aCols[oBrw:nAt][nPosDesc] 	:= TDA1->B1_DESC    //NwFieldPut(oBrw,"DESC" ,oBrw:nAt,TDA1->B1_DESC) 
			//oBrw:aCols[oBrw:nAt][nPosVlTab] := TDA1->DA1_PRCVEN //NwFieldPut(oBrw,"VLTAB",oBrw:nAt,TDA1->DA1_PRCVEN)
			cTDesc 	:= TDA1->B1_DESC
			cTVlTab := TDA1->DA1_PRCVEN 
			oTVlNv:Setfocus() 
		Else
			Aviso("Atenção!","Produto inválido ou bloqueado!",{"OK"})
			Return(.F.)

		EndIf
		
		ENDIF
		//oBrw:nat:=len(oBrw:Acols)
   		//oBrw:Refresh()
   		//oBrw:ForceRefresh()
   		//fNvCols()
        /*
		If Em
		pty(If(lDigitado,TDA1->B1_COD,oBrw:aCols[oBrw:nAt][nPosProduto]))
			Aviso("Atenção!","Preencha o código do produto.",{"OK"})
			Return(.F.)
   		EndIf
          */
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
	Return(.T.)
	Static Function fPrNV()
			cTPorc  := cTVlNv /cTVlTab
	Return
	Static Function fPorc()
			cTVlNv  := cTVlTab * cTPorc
	Return
	
	Static Function fGrvItem()
		Local nn			:= 0 
		Local	nQtdCpo 		:= Len(aHeadsc)
		Local nPosProd  	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
		Local nPosDesc		:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
		Local nPosVlTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLTAB" 	})
		Local nPosPrcNV	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRCNV" 	})
		Local nPosPorc	  	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PORC" 	})
	
	if msgYesNo("Deseja adicionar este produto ?","Confirme")

			AAdd(oBrw:Acols, Array(nQtdCpo+1))
			nn++
		
			oBrw:Acols[nn][nQtdCpo+1]  	 	:= .F.
			oBrw:Acols[nn][nPosProd]		:= cTCod
			oBrw:Acols[nn][nPosDesc]		:= cTDesc
			oBrw:Acols[nn][nPosVlTab]	 	:= cTVlTab
			oBrw:Acols[nn][nPosPrcNv]	 	:= cTVlNv			
			oBrw:Acols[nn][nPosPorc]	 	:= cTPorc
			oBrw:Acols[nn][Len(aHeadsc)+1]	:= .F.
         			
			oBrw:nat:=len(oBrw:Acols)
			oBrw:Refresh()
			fNvCols()
		Endif	

	Return
	
	Static Function fNvCols()
		Local   nn			:= 0 
		Local	nQtdCpo 		:= Len(aHeadsc)
		Local nPosProd  	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PROD" 	})
		Local nPosDesc		:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "DESC" 	})
		Local nPosVlTab	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "VLTAB" 	})
		Local nPosPrcNV	:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PRCNV" 	})
		Local nPosPorc		:=  ASCAN(aHeadsc, { |x| AllTrim(x[2]) == "PORC" 	})
		oBrw:aCols := {}
		nQtdCpo :=  Len(aHeadsc)
		nn:=0

		AAdd(oBrw:Acols, Array(nQtdCpo+1))
		nn++
		
			oBrw:Acols[nn][nQtdCpo+1]  	:= .F.
			oBrw:Acols[nn][nPosProd]		:= space(15)
			oBrw:Acols[nn][nPosDesc]		:= space(40)
			oBrw:Acols[nn][nPosVlTab]	 	:= 0
			oBrw:Acols[nn][nPosPrcNv]	 	:= 0			
			oBrw:Acols[nn][nPosPorc]	 	:= 0			
			oBrw:Acols[nn][Len(aHeadsc)+1]:= .F.



		oBrw:nat:=len(oBrw:Acols)
		oBrw:Refresh()
	Return
	
	Static Function ValidCod(cCod)

		Local _CodPro	:= aScan(aHeadsc,{|x| UPPER(Alltrim(x[2])) == "PROD"})
	   Local nCont := len(oBrw:Acols)
	   Local lRet := .T.
	   
	for x:=1 to len(oBrw:Acols) 
		If oBrw:aCols[x,_CodPro] == cCod
			alert("Produto ja informado para alteração.")
			lRet := .F.	
		Endif
			
	Next x
	
RETURN(lRet)	