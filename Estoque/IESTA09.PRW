#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IESTA09			  		| 	Junho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Sugestão de Inventário														  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function IESTA09()

	private aButtons   	:= {}
	private _cLocal 	:= space(2)
	private _cDeposito 	:= space(2)          
	private _cGrupoDE	:= space(4)          
	private _cGrupoATE 	:= space(4)          
	private _cItemDE 	:= space(15)          
	private _cItemATE	:= space(15)          
	private _dDtInvent	:= ctod("")
	private _cDocto		:= space(TamSX3("B7_DOC")[1])          
	private _aCurvaABC	:= {}
	private _aSegto		:= {}
	private _aTipo		:= {}
	private oGetTM1    	:= Nil
	private _nCurvaA	:= 0
	private _nCurvaB	:= 0
	private _cClasse
	private _cLoc 		:= space(2)
	private _cDep		:= space(2)          
	
	private _oTipo 	:= cTipo := ""
	private _oSegto := cSegto := ""
	private _oArq 	:= cArq := ""
	
	private aTela[0][0],aGets[0],aHeader[0]

	aadd(aButtons,{"Edit"	,{|| U_IESTA09B()}, "Todos"			, "Todos" 		, {|| .T.}} )    
	aadd(aButtons,{"Edit"	,{|| U_IESTA09A()}, "Incluir Item"	, "Incluir Item", {|| .T.}} )    

	ajustaSX6() 
	
	dbSelectArea("SZ7")
	dbGoTop()
	while ! SZ7->(eof())
		aadd(_aSegto, SZ7->Z7_CODIGO + " - " + SZ7->Z7_DESCRIC)
		SZ7->(dbSkip())
	enddo

	_aCurvaABC	:= strToKarr(getMV("MV__PERABC"),";")

	_nCurvaA	:= val(_aCurvaABC[1])
	_nCurvaB	:= val(_aCurvaABC[2])
	
	aadd(_aTipo, "1 - Quantidade de Saída")
	aadd(_aTipo, "2 - Quantidade em Estoque")
	aadd(_aTipo, "3 - Valor em Estoque")

	oFont := tFont():New("Tahoma",,-14,,.t.)

	aSize := MsAdvSize()
	
	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{400,400,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

	DEFINE MSDIALOG oDlg TITLE "Sugestão de Inventário" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
                                           
	@  10,10 Say "Local :" 				   	FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  10,300 Say "Depósito :" 				FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  25,10 Say "A partir do Grupo :" 		FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  25,300 Say "Até o Grupo :" 			FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  40,10 Say "A partir do ítem :" 		FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  40,300 Say "Até o ítem :" 			FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  55,10 Say "Data do inventário :" 	FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  55,300 Say "Documento :" 			FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  70,10 Say "Tipo classe ABC :" 		FONT oFont SIZE 100,10 OF oDlg PIXEL
	@  70,300 Say "Segmento :" 				FONT oFont SIZE 100,10 OF oDlg PIXEL

    @ 10,120 MsGet _cLocal 		Picture "@!" 	Size 07,10 of oDlg PIXEL FONT oFont F3 "SM0" Valid ExistCpo("SM0",cEmpAnt + _cLocal) 
    @ 10,420 MsGet _cDeposito 	Picture "@!" 	Size 07,10 of oDlg PIXEL FONT oFont 
    @ 25,120 MsGet _cGrupoDE 	Picture "@!" 	Size 30,10 of oDlg PIXEL FONT oFont 
    @ 25,420 MsGet _cGrupoATE	Picture "@!" 	Size 30,10 of oDlg PIXEL FONT oFont 
    @ 40,120 MsGet _cItemDE	 	Picture "@!" 	Size 90,10 of oDlg PIXEL FONT oFont 
    @ 40,420 MsGet _cItemATE 	Picture "@!" 	Size 90,10 of oDlg PIXEL FONT oFont 
    @ 55,120 MsGet _dDtInvent 	Picture "@D" 	Size 55,10 of oDlg PIXEL FONT oFont 
    @ 55,420 MsGet _cDocto	 	Picture "@!" 	Size 50,10 of oDlg PIXEL FONT oFont 

 	@ 70,120 COMBOBOX oTipo 	VAR cTipo 	ITEMS _aTipo 	SIZE 130,10	Of oDlg PIXEL FONT oFont
 	@ 70,420 COMBOBOX oSegto 	VAR cSegto 	ITEMS _aSegto 	SIZE 100,10 Of oDlg PIXEL FONT oFont
 	
 	@ 90,250 BUTTON "Pesquisar"	SIZE 100,10 Of oDlg PIXEL FONT oFont ACTION Processa({|| buscaRegs() },"Aguarde! Processando...",,.T.)

	criaHeader() 

    oGetTM1 := MsNewGetDados():New(105, 0, 270, 650, GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader, aCols)

	SetKey( VK_F12 , { || U_IESTA09A() } )

	lOk := .F.	
	ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=validar()},{||oDlg:End()},,aButtons) }) 

return                 


static function criaHeader()     
	static aHeader	:= {}
	static aCols	:= {}
	static aEdit	:= {"INDICADA", "INVENTARIA", "MOTIVO"}
	
	aCpoHeader   := {"B1_COD", "B1_DESC"}

	AAdd(aHeader, {"Classe ABC",;
					"CLASSE",;
					"@!"     ,;
					1     ,;
					0     ,;
					".T."       ,;
					"€€€€€€€€€€€€€€" ,;
					"C",;
					"",;
					"R",;
					""})

	For _nElemHead := 1 To Len(aCpoHeader)
		_cCpoHead := aCpoHeader[_nElemHead]
		dbSelectArea("SX3")
		dbSetOrder(2)
		If DbSeek(_cCpoHead)
			AAdd(aHeader, {Trim(SX3->X3_Titulo),;
							SX3->X3_Campo       ,;
							SX3->X3_Picture     ,;
							SX3->X3_Tamanho     ,;
							SX3->X3_Decimal     ,;
							SX3->X3_Valid       ,;
							SX3->X3_Usado       ,;
							SX3->X3_Tipo        ,;
							SX3->X3_F3    	 	,;
							SX3->X3_Context		,;
							SX3->X3_Cbox		,;
							SX3->X3_RELACAO		,;
							SX3->X3_WHEN		,;
							SX3->X3_VISUAL})

		Endif
	Next _nElemHead	
                       
	AAdd(aHeader, {"Venda Indicada?",;
					"INDICADA",;
					""     ,;
					3     ,;
					0     ,;
					".T." ,;
					"€€€€€€€€€€€€€€" ,;
					"C",;
					"",;
					"R",;
					"",;
					"",;
					"",;
					"V"})

	AAdd(aHeader, {"Inventaria?",;
					"INVENTARIA",;
					"9"     ,;
					1     ,;
					0     ,;
					".T."       ,;
					"€€€€€€€€€€€€€€" ,;
					"C",;
					"",;
					"R",;
					"1=Sim;2=Nao",;
					"",;
					"",;
					"A"})

	AAdd(aHeader, {"Motivo",;
					"MOTIVO",;
					"9"     ,;
					1     ,;
					0     ,;
					"U_IESTA09D()"       ,;
					"€€€€€€€€€€€€€€" ,;
					"C",;
					"",;
					"R",;
					"2=Corte;3=Rotativo",;
					"",;
					"",;
					"A"})

	AAdd(aHeader, {"Saldo Disponivel",;
					"SALDO",;
					"@E 9999999999999.99"     ,;
					15     ,;
					2     ,;
					".T."       ,;
					"€€€€€€€€€€€€€€" ,;
					"N",;
					"",;
					"R",;
					"",;  
					"",;
					"",;
					"V"})
					
return


static function buscaRegs()     

	recPosicao()

	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlName("SB2") + " SB2 "
	_cQuery	+= "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = B2_COD "
	_cQuery += "										AND SB1.D_E_L_E_T_ <> '*' "
	_cQuery += "WHERE B2_LOCAL = '" + _cDeposito +  "' "
	_cQuery += "  AND B2_COD >= '" + _cItemDE + "' "
	_cQuery += "  AND B2_COD <= '" + _cItemATE + "' "
	_cQuery += "  AND SB2.D_E_L_E_T_ <> '*' "
	_cQuery += "  AND B1_GRUPO >= '" + _cGrupoDE + "' "
	_cQuery += "  AND B1_GRUPO <= '" + _cGrupoATE + "' "
	_cQuery += "  AND B2_FILIAL = '" + _cLocal + "' "   
	if substr(cSegto,1,1) <> "0"	
		_cQuery += "  AND B1__SEGISP = '" + substr(cSegto,1,1) + "' "
	endif
               
	TcQuery _cQuery New Alias "TRB_INV"

	if substr(cTipo ,1,1) == '1'
        
		nSaidatot := 0
		_cQuery := "SELECT SUM(D2_QUANT) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SD2") + " SD2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SF4") + " SF4 ON F4_CODIGO = D2_TES "
		_cQuery += "										AND F4_ESTOQUE = 'S' "
		_cQuery += "										AND SF4.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D2_FILIAL = '" + _cLocal + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "

		TcQuery _cQuery New Alias "TRB_TOT"
		nSaidatot := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	elseif substr(cTipo ,1,1) == '2'

		_cQuery := "SELECT SUM(B2_QATU) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SB2") + " SB2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = B2_COD "
		_cQuery += "										AND SB1.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE B2_LOCAL = '" + _cDeposito +  "' "
		_cQuery += "  AND SB2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND B2_FILIAL = '" + _cLocal + "' "
	               
		TcQuery _cQuery New Alias "TRB_TOT"
		nSaldotot := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	elseif substr(cTipo ,1,1) == '3'

		_cQuery := "SELECT SUM(B2_QATU * B2_CM1) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SB2") + " SB2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = B2_COD "
		_cQuery += "										AND SB1.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE B2_LOCAL = '" + _cDeposito +  "' "
		_cQuery += "  AND SB2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND B2_FILIAL = '" + _cLocal + "' "
	               
		TcQuery _cQuery New Alias "TRB_TOT"
		nCusto := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	endif

	nn := len(oGetTM1:aCols)
	nQtdCpo := Len(oGetTM1:aHeader)

	do while ! TRB_INV->(eof())
		if len(oGetTM1:aCols) == 1 .and. empty(oGetTM1:acols[oGetTM1:NAT][nPos_B1_COD])
			nn := oGetTM1:NAT
		else
			nn := len(oGetTM1:aCols) + 1
			oGetTM1:NAT := nn
		   	aadd(oGetTM1:aCols, Array(nQtdCpo+1))
		endif
	
		_cQuery := "SELECT COUNT(*) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SC6") + " SC6 "
		_cQuery += "WHERE C6_LOCAL = '" + _cDeposito +  "' "
		_cQuery += "  AND C6_PRODUTO = '" + TRB_INV->B2_COD + "' "
		_cQuery += "  AND C6_FILIAL = '" + _cLocal + "' "
		_cQuery += "  AND (C6_QTDVEN - C6_QTDENT - C6_QTDEMP) > 0 "
		_cQuery += "  AND C6_BLQ <> 'R' "
		_cQuery += "  AND SC6.D_E_L_E_T_ <> '*' "

		TcQuery _cQuery New Alias "TRB_SC6"
		
		_cVendaIndicada := ""
       	if TRB_SC6->TOTAL == 0
			_cVendaIndicada := "Nao"
		else
			_cVendaIndicada := "Sim"
        endif
			
		TRB_SC6->(dbCloseArea())

		_cClasse  := ""
		if substr(cTipo ,1,1) == '1'

			_cQuery := "SELECT SUM(D2_QUANT) AS TOTAL "
			_cQuery += "FROM " + retSqlName("SD2") + " SD2 "
			_cQuery	+= "INNER JOIN " + retSqlName("SF4") + " SF4 ON F4_CODIGO = D2_TES "
			_cQuery += "										AND F4_ESTOQUE = 'S' "
			_cQuery += "										AND SF4.D_E_L_E_T_ <> '*' "
			_cQuery += "WHERE D2_LOCAL = '" + _cDeposito +  "' "
			_cQuery += "  AND D2_COD = '" + TRB_INV->B2_COD + "' "
			_cQuery += "  AND D2_FILIAL = '" + _cLocal + "' "
			_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
			_cQuery += "  AND D2_EMISSAO > '" + dtos(dDatabase - getMV("MV__DIASABC")) + "' "
	
			TcQuery _cQuery New Alias "TRB_SD2"

			_nPercent := TRB_SD2->TOTAL / nSaidatot * 100
			if _nPercent >= _nCurvaA
				_cClasse := "A"
			elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
				_cClasse := "B"
			else
				_cClasse := "C"
			endif			
	                               
			TRB_SD2->(dbCloseArea())
		elseif substr(cTipo ,1,1) == '2'
			_nPercent := TRB_INV->B2_QATU / nSaldotot * 100
			if _nPercent >= _nCurvaA
				_cClasse := "A"
			elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
				_cClasse := "B"
			else
				_cClasse := "C"
			endif			
		elseif substr(cTipo ,1,1) == '3'
			_nPercent := (TRB_INV->B2_QATU * TRB_INV->B2_CM1) / nCusto * 100
			if _nPercent >= _nCurvaA
				_cClasse := "A"
			elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
				_cClasse := "B"
			else
				_cClasse := "C"
			endif			
		endif

	    oGetTM1:acols[nn][nPos_CLASSE]		:= _cClasse
		oGetTM1:acols[nn][nPos_B1_COD]		:= TRB_INV->B1_COD
	    oGetTM1:acols[nn][nPos_B1_DESC]		:= TRB_INV->B1_DESC
	    oGetTM1:acols[nn][nPos_INVENTARIA]	:= '2'
	    oGetTM1:acols[nn][nPos_INDICADA]	:= _cVendaIndicada
	    oGetTM1:acols[nn][nPos_MOTIVO]		:= space(1)
	    oGetTM1:acols[nn][nPos_SALDO]		:= U_xSldProd(_cLocal,TRB_INV->B2_COD, _cDeposito,"")

	    oGetTM1:acols[nn][Len(aHeader)+1] 	:= .F.
	
		TRB_INV->(dbSkip())
	enddo
	
	oGetTM1:NAT := nn

	ASORT(oGetTM1:acols, , , { | x,y | x[1] < y[1] } )
	
	TRB_INV->(dbCloseArea())
	
return




user function IESTA09B()

	recPosicao()

	for x:=1 to len(oGetTM1:Acols)	
		oGetTM1:Acols[x][nPos_INVENTARIA]	:= iif(oGetTM1:Acols[x][nPos_INVENTARIA] == "1", "2", "1")	
	next x

return


static function validar()
	lOk := .T.		

	if len(alltrim(_cDocto)) == 0
		msgAlert ("O número do documento deve ser preenchido !!")
		lOk := .F.		
	endif
	if month(_dDtInvent) == 0
		msgAlert ("A data do inventário deve ser preenchida !!")
		lOk := .F.		
	endif

	tot := 0
	totMot := 0
	if valtype(oGetTM1) == "O"

		recPosicao()
	                                  
		for x:=1 to len(oGetTM1:Acols)
		    if oGetTM1:Acols[x][nPos_INVENTARIA] == '1'
		    	tot++
		    	exit
		    endif
		next x            
		for x:=1 to len(oGetTM1:Acols)
		    if oGetTM1:Acols[x][nPos_INVENTARIA] == '1' .and. empty(oGetTM1:Acols[x][nPos_MOTIVO])
		    	totMot++
		    	exit
		    endif
		next x            
	endif
	
	if tot == 0
		msgAlert ("Nenhum ítem a inventariar !!")
		lOk := .F.		
	endif
	if totMot > 0
		msgAlert ("os ítens a inventariar precisar ter o campo Motivo preenchido !!")
		lOk := .F.		
	endif

	if lOk        
		IESTA09C()
		oDlg:End()    
	endif
return lOk


static function IESTA09C()
	Local _aResult := {}

	recPosicao()

	for x:=1 to len(oGetTM1:Acols)

	    if oGetTM1:Acols[x][nPos_INVENTARIA] == '1'
			dbSelectArea("SB7")
			reclock("SB7", .T.)
			SB7->B7_FILIAL	 := _cLocal
			SB7->B7_COD		 := oGetTM1:Acols[x][nPos_B1_COD]
			SB7->B7_LOCAL	 := _cDeposito
			SB7->B7_DOC		 := _cDocto
			SB7->B7_QUANT	 := 0
			SB7->B7_DATA	 := _dDtInvent
			SB7->B7_STATUS   := "1"
			SB7->B7_ORIGEM	 := "MATA270"
			SB7->B7__SEGISP	 := Posicione("SB1",1,xFilial("SB1") + oGetTM1:Acols[x][nPos_B1_COD], "B1__SEGISP")
			SB7->B7_TIPO	 := SB1->B1_TIPO
	        SB7->B7__TPINVE	:= oGetTM1:Acols[x][nPos_MOTIVO]
	        SB7->(msUnlock())  
	        
	        dbSelectArea("Z15")
	        dbSetOrder(1)
	        if dbSeek(_cLocal+oGetTM1:Acols[x][nPos_B1_COD])
				reclock("Z15", .F.)
	        else
				reclock("Z15", .T.)
	        endif
	        Z15->Z15_FILIAL	:= _cLocal
	        Z15->Z15_COD	:= oGetTM1:Acols[x][nPos_B1_COD]
	        Z15->Z15_TPINVE	:= oGetTM1:Acols[x][nPos_MOTIVO]
	        
	        Z15->(msUnlock())  
		endif
	
	next x
	
	If Len(oGetTM1:Acols) > 0
		If MsgYesNo("Fazer envio do inventario ao ArMHAzena?","ATENCAO")
		
			_aResult := TCSPEXEC("PROC_PMHA_INTER_INVENTARIO",_cLocal,SubStr(cSegto,1,2),_cDocto,_cDeposito,DTOS(_dDtInvent))
			If !Empty(_aResult)
				If _aResult[1] == "S"
					Help( Nil, Nil, "ENVINVENT", Nil, _aResult[2], 1, 0 ) 
					_lRet := .f. 
				Else
					MsgInfo("Envio concluido com sucesso","Integracao ArMHAzena")
				EndIf
			Else
				Help( Nil, Nil, "ERRINVENT", Nil, "Erro ao enviar o inventario para o WMS", 1, 0 ) 
				_lRet := .f.
			EndIf			 
		
		EndIf
	EndIf	

return


                          
static function ajustaSX6(mv)
	dbSelectArea("SX6")
	dbSetOrder(1)
	if ! dbSeek(space(2)+"MV__PERABC")
		reclock("SX6", .T.)
		SX6->X6_VAR		:= "MV__PERABC"
		SX6->X6_TIPO	:= "C"
		SX6->X6_DESCRIC	:= "PERCENTUAL DE CURVA ABC PARA INVENTARIO"
		SX6->X6_CONTEUD	:= "70;20"
		SX6->X6_CONTSPA	:= "70;20"
		SX6->X6_CONTENG	:= "70;20"
	    msUnlock()
	endif
	if ! dbSeek(space(2)+"MV__DIASABC")
		reclock("SX6", .T.)
		SX6->X6_VAR		:= "MV__DIASABC"
		SX6->X6_TIPO	:= "N"
		SX6->X6_DESCRIC	:= "DIAS CONSIDERADOS NA BUSCA DE VENDAS PARA INVENTARIO"
		SX6->X6_CONTEUD	:= "90"
		SX6->X6_CONTSPA	:= "90"
		SX6->X6_CONTENG	:= "90"
	    msUnlock()
	endif
return


user function IESTA09A()
    local aObjects
    local aInfo
    local aPosObj
    local aButtons := {}

	private _cItem 	:= space(15)          

	if ! empty(_cLocal)
		_cLoc := _cLocal
	endif
	if ! empty(_cDeposito)
		_cDep := _cDeposito
	endif
	
	aObjects := {}
	AAdd(aObjects,{100,030,.t.,.f.})
	AAdd(aObjects,{100,100,.t.,.t.})
	
	aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
	aPosObj := MsObjSize(aInfo, aObjects)

	DEFINE MSDIALOG oDlg1 TITLE "Inclusão de Ítens" From 100,400 to 290,800 OF oMainWnd PIXEL

	@ 10,10 Say "Local :" 		FONT oFont SIZE 100,10 OF oDlg1 PIXEL
	@ 30,10 Say "Depósito :" 	FONT oFont SIZE 100,10 OF oDlg1 PIXEL
	@ 50,10 Say "ítem :" 		FONT oFont SIZE 100,10 OF oDlg1 PIXEL 

    @ 10,40 MsGet _cLoc		when empty(_cLocal)		Picture "@!" 	Size 07,10 of oDlg1 PIXEL FONT oFont F3 "SM0" 
    @ 30,50 MsGet _cDep		when empty(_cDeposito)	Picture "@!" 	Size 07,10 of oDlg1 PIXEL FONT oFont 
    @ 50,35 MsGet _cItem							Picture "@!" 	Size 90,10 of oDlg1 PIXEL FONT oFont F3 "SB1LIK" valid buscaProd()
                
	@ 80,020 BUTTON "Incluir"	SIZE 70,10 Of oDlg1 PIXEL FONT oFont ACTION Processa({|| valInc() },,,.T.)
	@ 80,110 BUTTON "Cancelar"	SIZE 70,10 Of oDlg1 PIXEL FONT oFont ACTION Processa({|| oDlg1:End() },,,.T.)

	ACTIVATE MSDIALOG oDlg1 CENTERED 

	_cLocal		:= _cLoc
	_cDeposito 	:= _cDep 

return


static function buscaProd()
	dbSelectArea("SB1")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SB1")+_cItem) .and. !empty(_cItem)
		msgAlert ("Ítem não encontrado no cadastro de Produtos !!")
		return .F.	
	endif
return .T.


static function valInc()
	_lRet := .T.

	recPosicao()

	if empty(_cLoc) .or. empty(_cDep) .or. empty(_cItem)
		msgAlert ("Todos os Campos devem ser preenchidos !!")
		return .F.
	endif

	nQtdCpo := len(oGetTM1:aHeader)

	if len(oGetTM1:aCols) == 1 .and. empty(oGetTM1:acols[oGetTM1:NAT][nPos_B1_COD])
		n := oGetTM1:NAT
	else
		n := len(oGetTM1:aCols) + 1
		oGetTM1:NAT := n
	   	aadd(oGetTM1:aCols, Array(nQtdCpo+1))
	endif
			
	_cQuery := "SELECT COUNT(*) AS TOTAL "
	_cQuery += "FROM " + retSqlName("SC6") + " SC6 "
	_cQuery += "WHERE C6_LOCAL = '" + _cDep +  "' "
	_cQuery += "  AND C6_PRODUTO = '" + SB1->B1_COD + "' "
	_cQuery += "  AND C6_FILIAL = '" + _cLoc + "' "
	_cQuery += "  AND (C6_QTDVEN - C6_QTDENT - C6_QTDEMP) > 0 "
	_cQuery += "  AND C6_BLQ <> 'R' "
	_cQuery += "  AND SC6.D_E_L_E_T_ <> '*' "

	TcQuery _cQuery New Alias "TRB_SC6"
	
	_cVendaIndicada := ""
    if TRB_SC6->TOTAL == 0
		_cVendaIndicada := "Nao"
	else
		_cVendaIndicada := "Sim"
  	endif
		
	TRB_SC6->(dbCloseArea())


	if substr(cTipo ,1,1) == '1'
        
		nSaidatot := 0
		_cQuery := "SELECT SUM(D2_QUANT) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SD2") + " SD2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SF4") + " SF4 ON F4_CODIGO = D2_TES "
		_cQuery += "										AND F4_ESTOQUE = 'S' "
		_cQuery += "										AND SF4.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D2_FILIAL = '" + _cLoc + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "

		TcQuery _cQuery New Alias "TRB_TOT"
		nSaidatot := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	elseif substr(cTipo ,1,1) == '2'

		_cQuery := "SELECT SUM(B2_QATU) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SB2") + " SB2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = B2_COD "
		_cQuery += "										AND SB1.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE B2_LOCAL = '" + _cDep +  "' "
		_cQuery += "  AND SB2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND B2_FILIAL = '" + _cLoc + "' "
	               
		TcQuery _cQuery New Alias "TRB_TOT"
		nSaldotot := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	elseif substr(cTipo ,1,1) == '3'

		_cQuery := "SELECT SUM(B2_QATU * B2_CM1) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SB2") + " SB2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SB1") + " SB1 ON B1_COD = B2_COD "
		_cQuery += "										AND SB1.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE B2_LOCAL = '" + _cDep +  "' "
		_cQuery += "  AND SB2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND B2_FILIAL = '" + _cLoc + "' "
	               
		TcQuery _cQuery New Alias "TRB_TOT"
		nCusto := TRB_TOT->TOTAL
		TRB_TOT->(dbCloseArea())

	endif


	_cClasse  := ""
	if substr(cTipo ,1,1) == '1'

		_cQuery := "SELECT SUM(D2_QUANT) AS TOTAL "
		_cQuery += "FROM " + retSqlName("SD2") + " SD2 "
		_cQuery	+= "INNER JOIN " + retSqlName("SF4") + " SF4 ON F4_CODIGO = D2_TES "
		_cQuery += "										AND F4_ESTOQUE = 'S' "
		_cQuery += "										AND SF4.D_E_L_E_T_ <> '*' "
		_cQuery += "WHERE D2_LOCAL = '" + _cDep +  "' "
		_cQuery += "  AND D2_COD = '" + SB1->B1_COD + "' "
		_cQuery += "  AND D2_FILIAL = '" + _cLoc + "' "
		_cQuery += "  AND SD2.D_E_L_E_T_ <> '*' "
		_cQuery += "  AND D2_EMISSAO > '" + dtos(dDatabase - getMV("MV__DIASABC")) + "' "

		TcQuery _cQuery New Alias "TRB_SD2"

		_nPercent := TRB_SD2->TOTAL / nSaidatot * 100
		if _nPercent >= _nCurvaA
			_cClasse := "A"
		elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
			_cClasse := "B"
		else
			_cClasse := "C"
		endif			
                               
		TRB_SD2->(dbCloseArea())
	elseif substr(cTipo ,1,1) == '2'
		_nPercent := TRB_INV->B2_QATU / nSaldotot * 100
		if _nPercent >= _nCurvaA
			_cClasse := "A"
		elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
			_cClasse := "B"
		else
			_cClasse := "C"
		endif			
	elseif substr(cTipo ,1,1) == '3'
		_nPercent := (TRB_INV->B2_QATU * TRB_INV->B2_CM1) / nCusto * 100
		if _nPercent >= _nCurvaA
			_cClasse := "A"
		elseif _nPercent < _nCurvaA .and. _nPercent >= _nCurvaB
			_cClasse := "B"
		else
			_cClasse := "C"
		endif			
	endif

    oGetTM1:acols[n][nPos_CLASSE]		:= _cClasse
	oGetTM1:acols[n][nPos_B1_COD]		:= SB1->B1_COD
    oGetTM1:acols[n][nPos_B1_DESC]		:= SB1->B1_DESC
    oGetTM1:acols[n][nPos_INVENTARIA]	:= '2'
    oGetTM1:acols[n][nPos_INDICADA]		:= _cVendaIndicada
    oGetTM1:acols[n][nPos_MOTIVO]		:= space(1)
    oGetTM1:acols[n][nPos_SALDO]		:= U_xSldProd(_cLoc,SB1->B1_COD, _cDep,"")

    oGetTM1:acols[n][Len(aHeader)+1] 	:= .F.

	oDlg1:End()
	
	oGetTM1:refresh()
return _lRet


static function recPosicao() 
	static nPos_B1_COD		:= 0
	static nPos_B1_DESC		:= 0
	static nPos_INVENTARIA	:= 0
	static nPos_MOTIVO		:= 0
	static nPos_INDICADA	:= 0
	static nPos_CLASSE		:= 0
	static nPos_SALDO		:= 0
	
	nPos_B1_COD  	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_COD" }) 
    nPos_B1_DESC	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_DESC" })
    nPos_INVENTARIA	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "INVENTARIA" })
    nPos_MOTIVO		:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "MOTIVO" })
    nPos_INDICADA	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "INDICADA" })
	nPos_CLASSE    	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "CLASSE" })
	nPos_SALDO    	:=  ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "SALDO" })
return


user function IESTA09D()
	_lRet := .T.   

	recPosicao()
	
	if oGetTM1:acols[n][nPos_INDICADA] == "Sim" .and. M->MOTIVO == "3"
	
		alert ("Para produtos com venda indicada o motivo deve ser Corte !!")
		_lRet := .F.   
	
	endif		

return _lRet


User Function IESTA09T()

AxCadastro("Z15")

Return