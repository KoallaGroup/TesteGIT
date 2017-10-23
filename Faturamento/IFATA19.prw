#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include 'topconn.ch'


//Rotina auxiliar do fonte IFATA15 - Tabela de preço de Venda - Bike Importado
//Roberto Marques
User Function iFATA19(cCod)
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
	Aadd(aHeaderEx, {"Faixa"	    	,"ITEM"  ,"@!"				    ,03,0,".T.",,"C",,,,"" })//U_FT19SEQ()
	Aadd(aHeaderEx, {"Quantidade"    	,"FAIXA" ,"@R 999999"			,06,0,".T.",,"N",,,,})
	Aadd(aHeaderEx, {"Altera %"      	,"PERC"  ,"@E 99.99"			,05,2,"U_IFATA19A()",,"N",,,,})
	Aadd(aHeaderEx, {"Altera Valor"     ,"VALOR" ,"@E 9,999,999.99"		,12,2,"U_IFATA19B()",,"N",,,,})
	Aadd(aHeaderEx, {"Percentual"    	,"RPERC" ,"@E 99.99"			,05,2,"",,"N",,,,})
	Aadd(aHeaderEx, {"Valor c/ Desconto","RVALOR","@E 9,999,999.99"		,12,2,"",,"N",,,,})
	Aadd(aHeaderEx, {"Identificação" 	,"IDENT" ,"@!"					,06,0,".T.",,"C","SZ8",,,})
	Aadd(aHeaderEx, {"Descrição"     	,"DESC"  ,"@!"					,60,0,".T.",,"C",,,,})
     /*
//	Aadd(aHeaderE1, {"Item"		    	,"ITEM"  ,"999"				,03,0,".T.",,"N",,,,})
	Aadd(aHeaderE1, {"Quantidade"    	,"FAIXA" ,"@E 999999"			,06,0,"U_IFATA19C()",,"N",,,,})
//	Aadd(aHeaderE1, {"Altera %"      	,"PERC"  ,"@E 99.99"			,05,2,"U_IFATA19C()",,"N",,,,})
//	Aadd(aHeaderE1, {"Altera Valor"     ,"VALOR" ,"@E 9,999,999.99"		,12,2,"U_IFATA19D()",,"N",,,,})
	Aadd(aHeaderE1, {"Percentual"    	,"RPERC" ,"@E 99.99"			,05,2,"",,"N",,,,})
	Aadd(aHeaderE1, {"Valor c/ Desconto","RVALOR","@E 9,999,999.99"		,12,2,"",,"N",,,,})
	Aadd(aHeaderE1, {"Identificação" 	,"IDENT" ,"@!"					,06,0,".T.",,"C","SZ8",,,})
	Aadd(aHeaderE1, {"Descrição"     	,"DESC"  ,"@!"					,60,0,".T.",,"C",,,,})
       */
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
	
     oBrw := MsNewGetDados():New( 040, 04,150,487,GD_INSERT+GD_UPDATE          , /*"U_IFATA19A()"*/, "AllwaysTrue","+ITEM", aAlterFields,,   ,,,, oDlg1, aHeaderEx, aColsEx)

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
		//fPesqDsc(cCodPro)
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
	mSQL += " DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='  ' "	
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
	
		oBrw:Acols[nn][nQtdCpo+1]  	:= .F.
		oBrw:Acols[nn][nPosITEM]		:= "001"
		oBrw:Acols[nn][nPosQtd]			:= 0
		oBrw:Acols[nn][nPosPerc]		:= 0.00
 			oBrw:Acols[nn][nPosVlr]			:= 0.00
		oBrw:Acols[nn][nPosRP]			:= 0.00
		oBrw:Acols[nn][nPosRV]			:= 0.00
		oBrw:Acols[nn][nPosID]			:= ""
		oBrw:Acols[nn][nPosIDD]			:= ""
		oBrw:Acols[nn][Len(aHeaderEx)+1]:= .F.
		oBrw:nat:=len(oBrw:Acols)
		oBrw:Refresh()
Return


User Function IFATA19A()

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


User Function IFATA19B()

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
        /*
       //	if oBrw:aCols[oBrw:nAt][nPosVlr] > 0 
	       	nValor :=  cPrcTab - (cPrcTab * oBrw:aCols[oBrw:nAt][nPosVlr] /cPrcTab)
			oBrw:aCols[oBrw:nAt][nPosRV] := nValor 		
			oBrw:aCols[oBrw:nAt][nPosRP] :=  oBrw:aCols[oBrw:nAt][nPosVlr] /cPrcTab
	///	Endif
        GETDREFRESH(oDlg1)
        */
       /*  
		for x:= 1 to len(oBrw:aCols)
			if ! oBrw:aCols[x][len(oBrw:aHeader)+1]
			   if oBrw:aCols[x][nPosVlr] > 0
			   		nValor :=  cPrcTab - (cPrcTab *  M->VALOR /cPrcTab)
			    Else
	       			nValor :=  cPrcTab - (cPrcTab * M->PERC /100)
				Endif
				oBrw:aCols[oBrw:nAt][nPosRV] := nValor 		
				oBrw:aCols[oBrw:nAt][nPosRP] := M->PERC
			endif
	
			GETDREFRESH(oDlg1)
	
		next x
		 */
        /*
	    if M->PERC > 0
			nValor :=  cPrcTab - (cPrcTab * M->PERC /100)
			oBrw:aCols[oBrw:nAt][nPosRV] := nValor 		
			oBrw:aCols[oBrw:nAt][nPosRP] := M->PERC
		Endif
        */
		
		if M->VALOR > 0
			//nValor := cPrcTab - M->VALOR //- (cPrcTab * M->VALOR /cPrcTab)
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
							//ACP->ACP_VLRDES := oBrw:Acols[x][nPosRV]
							ACP->ACP__IDENT	:= oBrw:Acols[x][nPosID] //_cIdent
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
							//ACP->ACP_VLRDES := oBrw:Acols[x][nPosRV]
							ACP->ACP_TPDESC	:= "1"
							ACP->ACP__IDENT	:= oBrw:Acols[x][nPosID] //_cIdent
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
		/*
		Local nPosQtd   :=  ASCAN(aHeaderE1, { |x| AllTrim(x[2]) == "FAIXA" 	})
		Local nPosRP	:=  ASCAN(aHeaderE1, { |x| AllTrim(x[2]) == "RPERC" 	})
		Local nPosRV	:=  ASCAN(aHeaderE1, { |x| AllTrim(x[2]) == "RVALOR" 	})
		Local nPosID	:=  ASCAN(aHeaderE1, { |x| AllTrim(x[2]) == "IDENT" 	})
		Local nPosIDD	:=  ASCAN(aHeaderE1, { |x| AllTrim(x[2]) == "DESC" 		})
		*/
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

	
		mSQL := "SELECT B1_COD,B1_DESC,B1__MARCA,MAX(D1_EMISSAO)DTREP,MAX(D1_VUNIT)VLRREP,MAX(SC7.C7_PRECO)CUSTO, "
		mSQL += " DA1_PRCVEN,MAX(SC7.C7_EMISSAO)DTPED,Z9_COD "
		mSQL += " FROM "+RetSqlName("DA1")+" DA1 "
		mSQL += " LEFT JOIN "+RetSqlName("SB1")+" SB1 ON B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' AND B1_COD=DA1_CODPRO "
		mSQL += " LEFT JOIN "+RetSqlName("SD1")+" SD1 ON B1_COD=SD1.D1_COD AND D1_FILIAL='"+xFilial("SD1")+"' AND SD1.D_E_L_E_T_ <>'*' "
		mSQL += " LEFT JOIN "+RetSqlName("SC7")+" SC7 ON C7_FILIAL='"+xFilial("SC7")+"' AND SC7.D_E_L_E_T_ <>'*' AND D1_PEDIDO=SC7.C7_NUM "
		mSQL += " LEFT JOIN "+RetSqlName("SZ9")+" SZ9 ON Z9_FILIAL='"+xFilial("SZ9")+"' AND SZ9.D_E_L_E_T_ <>'*' AND Z9_PRODUTO=DA1_CODPRO "
		                                     0
		mSQL += " WHERE DA1_FILIAL='"+xFilial("DA1")+"' AND DA1.D_E_L_E_T_ <>'*' AND "
		mSQL += " DA1_CODPRO ='"+cCodPro+"' AND "  
		mSQL += " DA1_CODTAB ='"+getMV("MV__TABBRA")+"' AND DA1_ESTADO='  ' "	
		mSQL += " GROUP BY B1_COD,B1_DESC,DA1_PRCVEN,B1__MARCA,Z9_COD "
		mSQL += " ORDER BY B1_COD,B1_DESC,B1__MARCA "
	
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TDA1",.F.,.T.)
		TDA1->( DbGoTop() )
		
//		If TDA1->(!Eof())
	
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
		mSQL += " ACP_CODREG ='"+getMV("MV__DSCCBR")+"' AND ACP_CODPRO ='"+cCodP+"' "
		
		
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

/*
		mSQL := "SELECT ACP_FILIAL,ACP_CODREG,ACP_ITEM,ACP_CODPRO,ACP_PERDES,ACP_FAIXA,ACP_CFAIXA,ACP_PERDES,ACP_TPDESC,ACP__IDENT,ACP__SEQIT "
		mSQL += " FROM "+RetSqlName("ACP")+" ACP "
		mSQL += " WHERE ACP_FILIAL='"+xFILIAL("ACP")+"' AND ACP.D_E_L_E_T_=' ' AND "
		mSQL += " ACP_CODREG ='"+getMV("MV__DSCCBR")+"' AND "
		mSQL += " ACP__IDENT IN( SELECT Z9_COD FROM "+RetSqlName("SZ9")+" SZ9 "
		mSQL += " WHERE Z9_PRODUTO='"+cCodP+"' AND D_E_L_E_T_=' ')
	
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TACP",.F.,.T.)
		TACP->( DbGoTop() )
		IF TACP->(!EOF())
			cID    	 := TACP->ACP__IDENT
			cIDDesc  := Posicione("SZ8",1,xFilial("SZ8")+TACP->ACP__IDENT,"Z8_DESCRI")
			cIDQnt   := TACP->ACP_FAIXA
			cIDPerc  := TACP->ACP_PERDES
		Endif
		TACP->(dbCloseArea())
*/		
    endif
Return



User Function FT19SEQ()
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
