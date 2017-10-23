#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICOMA11				 	| 	Setembro de 2014		  			 				|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Alteração Tabela de Preços por Ítem						  	  					|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ICOMA11()                        
	Local oSay1
	local _nRet := 0

	Static oDlg, _cItemAt

	_cTabBra	:= getMV("MV__TABBRA")
	
	oFont 	:= tFont():New("Tahoma",,-10,,.t.)
	oFont1 	:= tFont():New("Tahoma",,-10,,.F.)

	_cSegto		:= "2"
	_cDescSegto	:= space(40)
	_cDescTab1	:= "A VISTA"
	_cDescTab2	:= "30 DD"
	_cDescTab3	:= "30/60 DD"
	_cDescTab4	:= "30/60/90 DD"
    
	dbSelectArea("ZX5")
	dbSetOrder(1)
	_cFatTab2	:= posicione("ZX5",1,space(2)+space(2)+"000007"+PadR("002",TamSx3("ZX5_CODIGO")[1])+"2 ", "ZX5_DSCITE")
	_cFatTab3	:= posicione("ZX5",1,space(2)+space(2)+"000007"+PadR("003",TamSx3("ZX5_CODIGO")[1])+"2 ", "ZX5_DSCITE")
	_cFatTab4	:= posicione("ZX5",1,space(2)+space(2)+"000007"+PadR("004",TamSx3("ZX5_CODIGO")[1])+"2 ", "ZX5_DSCITE")

	DEFINE MSDIALOG oDlg TITLE "Alteração de Tabela de Preços por Item" FROM 000, 000  TO 540, 1000 PIXEL
	
	_lGet1 := .T.
	_lGet2 := .T.

   	@ 8,013 SAY "Segmento" SIZE 35, 7 OF oDlg PIXEL FONT oFont 
   	@ 5,055 MsGet oGet1 var _cSegto when _lGet1 Picture "@!" Size 8,5 of oDlg PIXEL FONT oFont1 F3 "SZ7" valid buscaSegto()
   	@ 8,083 SAY "-" SIZE 5, 7 OF oDlg PIXEL FONT oFont 
   	@ 5,090 MsGet _cDescSegto when .F. Picture "@!" Size 150,5 of oDlg PIXEL FONT oFont1 

   	@ 20,006 GROUP oGroup1 TO 70, 495 PROMPT "Taxa Financeira" OF oDlg PIXEL
	@ 30,13 say "Tabela Base " 	size 40,10 of oDlg pixel FONT oFont
	@ 40,13 say "Tabela 02 " 	size 40,10 of oDlg pixel FONT oFont
	@ 50,13 say "Tabela 03 "	size 40,10 of oDlg pixel FONT oFont
	@ 60,13 say "Tabela 04 "	size 40,10 of oDlg pixel FONT oFont
	
	@ 27,53 msGet _cDescTab1 when .F. size 150,5 of oDlg pixel font oFont1
	@ 37,53 msGet _cDescTab2 when .F. size 150,5 of oDlg pixel font oFont1
	@ 47,53 msGet _cDescTab3 when .F. size 150,5 of oDlg pixel font oFont1
	@ 57,53 msGet _cDescTab4 when .F. size 150,5 of oDlg pixel font oFont1

	@ 37,250 msGet _cFatTab2 when .F. size 150,5 of oDlg pixel font oFont1
	@ 47,250 msGet _cFatTab3 when .F. size 150,5 of oDlg pixel font oFont1
	@ 57,250 msGet _cFatTab4 when .F. size 150,5 of oDlg pixel font oFont1

	_cProd := space(TamSx3("B1_COD")[1])  
	_cDescProd	:= space(TamSx3("B1_DESC")[1])
	_dUltAlt := space(10)
	_nLista := 0
	_cProc := space(3)

	@ 75,13 say "Item " 	size 30,10 of oDlg pixel FONT oFont
	@ 72,40 msGet _oGet2 var _cProd when _lGet2 Picture "@!" size 130,7 of oDlg pixel font oFont1 F3 "SB1LIK" valid buscaProduto()
	@ 75,200 say "Nome " 	size 30,10 of oDlg pixel FONT oFont
	@ 72,227 msGet _cDescProd when .F. size 250,7 of oDlg pixel font oFont1 
	@ 85,13 say "Ult. Alt. " 	size 30,10 of oDlg pixel FONT oFont
	@ 82,50 msGet _dUltAlt when .F. size 50,7 of oDlg pixel font oFont1
	@ 85,150 say "Lista de Preco " 	size 40,10 of oDlg pixel FONT oFont
	@ 82,197 msGet _nLista when .F. picture "@E 99,999.99" size 50,7 of oDlg pixel font oFont1
	@ 85,270 say "Proc " 	size 30,10 of oDlg pixel FONT oFont
	@ 82,290 msGet _cProc when .F. size 50,7 of oDlg pixel font oFont1

	_dDataBase	:= ctod("  /  /  ")
	_nPreco1	:= 0
	_nPreco2	:= 0
	_nPreco3	:= 0
	_nPreco4	:= 0
	
   	@ 095,006 GROUP oGroup1 TO 130, 495 PROMPT "Preços" OF oDlg PIXEL
	@ 105,30 say "Data Base " 	size 40,10 of oDlg pixel FONT oFont
	@ 105,120 say trim(_cDescTab1)	size 40,10 of oDlg pixel FONT oFont
	@ 105,200 say trim(_cDescTab2) 	size 40,10 of oDlg pixel FONT oFont
	@ 105,280 say trim(_cDescTab3)	size 40,10 of oDlg pixel FONT oFont
	@ 105,355 say trim(_cDescTab4)	size 40,10 of oDlg pixel FONT oFont

	@ 115,13  msGet _dDataBase when .T. size 70,5 of oDlg pixel font oFont1 valid valData()
	@ 115,100 msGet _nPreco1 picture "@E 99,999.99" when .T. size 70,5 of oDlg pixel font oFont1 valid fatores()
	@ 115,180 msGet _nPreco2 picture "@E 99,999.99" when .F. size 70,5 of oDlg pixel font oFont1
	@ 115,260 msGet _nPreco3 picture "@E 99,999.99" when .F. size 70,5 of oDlg pixel font oFont1
	@ 115,340 msGet _nPreco4 picture "@E 99,999.99" when .F. size 70,5 of oDlg pixel font oFont1

	@ 100,450 button oButton1 prompt "Processar" size 37,12 of oDlg action {procProd()} pixel
	@ 115,450 button oButton2 prompt "Limpar" size 37,12 of oDlg action {limpar()} pixel
	
   	@ 135,006 GROUP oGroup1 TO 210, 495 PROMPT "Desconto por Quantidade" OF oDlg PIXEL
   	fMSNewGe()
	@ 195,450 button oButton4 prompt "Processar" size 40,12 of oDlg action {prodAcols()} pixel

   	@ 215,006 GROUP oGroup1 TO 250, 495 PROMPT "Desconto por Identificação" OF oDlg PIXEL
	@ 225,025 say "Faixa " size 40,10 of oDlg pixel FONT oFont
	@ 225,070 say "Identificações " size 40,10 of oDlg pixel FONT oFont
	@ 225,315 say "Quantidade " size 40,10 of oDlg pixel FONT oFont
	@ 225,370 say "Percentual "	size 40,10 of oDlg pixel FONT oFont
     
	_cFaixa		:= criavar("ACP__SEQIT")
   	_nQtde 		:= 0
   	_nPerc 		:= 0
   	_cIdent		:= criavar("Z8_COD")
   	_cDescIdent	:= criavar("Z8_ABREV")

	@ 235,013 msGet _cFaixa picture "999" when .T. size 30,5 of oDlg pixel font oFont1 
	@ 235,053 msGet _cIdent when ! empty(_cFaixa) size 30,5 of oDlg pixel font oFont1 F3 "SZ8" valid buscaIdent()
	@ 235,088 msGet _cDescIdent when .F. size 200,5 of oDlg pixel font oFont1
	@ 235,310 msGet _nQtde picture "999999" when ! empty(_cFaixa).and. ! empty(_cIdent) size 40,5 of oDlg pixel font oFont1 
	@ 235,365 msGet _nPerc picture "99.99" when ! empty(_cFaixa) .and. ! empty(_cIdent) size 40,5 of oDlg pixel font oFont1

	@ 220,420 button oButton3 prompt "Incluir nova faixa" size 70,12 of oDlg action {incFaixas()} pixel
	@ 236,420 button oButton4 prompt "Excluir todas as faixas" size 70,12 of oDlg action {excFaixas()} pixel
	@ 255,220 BUTTON oButton5 PROMPT "Fechar" 	SIZE 40, 12 OF oDlg ACTION {|| limpaFilter(), oDlg:End()} PIXEL	
   
	buscaSegto()	
	ACTIVATE MSDIALOG oDlg CENTERED
	                                              
Return

                     
static function filtrar()
	dbSelectArea("SB1")
	set filter to B1__SEGISP = _cSegto
	
	dbSelectArea("SZ8")
	set filter to Z8_SEGISP = _cSegto
return
        

static function limpaFilter()
	dbSelectArea("SB1")
	set filter to 
	
	dbSelectArea("SZ8")
	set filter to 
return 


static function valData()
	local _cRet := .T. 
	if month(_dDataBase) <> 0
		if _dDataBase < dDataBase
			msgAlert ("Não podem ser criadas ou alteradas tabelas com Data de vigência retroativa !!")
			_cRet := .F.
		endif
	endif
return _cRet        
  

static function fatores()
	_nPreco2 := _nPreco1 + (_nPreco1 * val(_cFatTab2))
	_nPreco3 := _nPreco1 + (_nPreco1 * val(_cFatTab3))
	_nPreco4 := _nPreco1 + (_nPreco1 * val(_cFatTab4))
return
    
    
static function limpar()
	_lGet1 := .T.
	_lGet2 := .T.
	_cSegto		:= "2"
	_cProd := space(15)  
	_cDescProd	:= space(40)
	_cDescSegto	:= space(40)
	_dDataBase	:= ctod("  /  /  ")
	_nPreco1	:= 0
	_nPreco2	:= 0
	_nPreco3	:= 0
	_nPreco4	:= 0
	_dUltAlt := space(10)
	_nLista := 0
	_cProc := space(3)
   	_nQtde 		:= 0
   	_nPerc 		:= 0
	_cFaixa		:= criavar("ACP__SEQIT")
   	_cIdent		:= criavar("Z8_COD")
   	_cDescIdent	:= criavar("Z8_ABREV")
	oMSNewGe2:Acols := {}
	oMSNewGe2:nat:=len(oMSNewGe2:Acols)
	oMSNewGe2:Refresh()
	buscaSegto()	
return


static function buscaIdent()
	local _cRet := .T.

	local _cTabDesc	:= getMV("MV__DSCCBR")

	if ! empty(_cIdent)
		dbSelectArea("SZ8")
		dbSetOrder(1)
		if ! dbSeek(xFilial("SZ8")+_cIdent) 
			msgAlert ("Identificação não cadastrada. Favor verificar !!")
			_cRet := .F.	
		else     
			_cDescIdent := SZ8->Z8_ABREV
			
			_cQuery := "select distinct ACP_PERDES, ACP_FAIXA, ACP__IDENT "
			_cQuery += "from " + retSqlName("ACP") + " ACP "
			_cQuery += "where ACP__IDENT = '" + _cIdent + "' "
			_cQuery += "  and ACP__SEQIT = '" + _cFaixa + "' "
			_cQuery += "  and ACP_CODREG = '" + _cTabDesc + "' "
			_cQuery += "  and D_E_L_E_T_ = ' ' "
			
			TcQuery _cQuery New Alias "TRBACP"
			
			if empty(TRBACP->ACP__IDENT)
				if msgYesNo("A Faixa não existe para esta identificação. Deseja criar uma nova ?","Confirme")				

					_cQuery := "select max(ACP__SEQIT) ACP__SEQIT "
					_cQuery += "from " + retSqlName("ACP") + " ACP "
					_cQuery += "inner join " + retSqlName("SZ9") + " SZ9 ON Z9_PRODUTO = ACP_CODPRO
					_cQuery += "        								AND Z9_COD = '" + _cIdent + "' "
					_cQuery += "  										AND SZ9.D_E_L_E_T_ = ' ' "
					_cQuery += "where ACP_CODREG = '" + _cTabDesc + "' "
					_cQuery += "  and ACP.D_E_L_E_T_ = ' ' "

					TcQuery _cQuery New Alias "TRBACP1"
					
					_cFaixa := soma1(TRBACP1->ACP__SEQIT, TAMSX3("ACP_CFAIXA")[1])
					TRBACP1->(dbCloseArea())								        
				     
				 	_nQtde := 0				
				 	_nPerc := 0
				else
					_cRet := .F.	
				endif
			else
			 	_nQtde := TRBACP->ACP_FAIXA				
			 	_nPerc := TRBACP->ACP_PERDES							
			endif		
			
			TRBACP->(dbCloseArea())			
		endif
	endif	
return _cRet    


user function ICOMA11A()
	local _cRet := .T.
	if ! empty(M->IDENT)
		dbSelectArea("SZ8")
		dbSetOrder(1)
		if ! dbSeek(xFilial("SZ8")+M->IDENT) 
			msgAlert ("Identificação não cadastrada. Favor verificar !!")
			_cRet := .F.	
		else     
			oMSNewGe2:aCols[n][6] := SZ8->Z8_ABREV
			oMSNewGe2:refresh()
		endif
	endif	
return _cRet    



static function buscaSegto()
	local _cRet := .T.
	
	if ! empty(_cSegto)
		dbSelectArea("SZ7")
		dbSetOrder(1)
		if ! dbSeek(xFilial("SZ7")+_cSegto) .or. _cSegto == "0"
			msgAlert ("Segmento não cadastrado. Favor verificar !!")
			_cRet := .F.	
		else          
			_lGet1 := .F.
			oGet1:refresh()
			_cDescSegto := SZ7->Z7_DESCRIC

			filtrar()
		endif
	endif	
return _cRet


static function buscaProduto()
	local _cRet := .T.
	local _cTabDesc	:= getMV("MV__DSCCBR")
	local nQtdCpo2	:= Len(oMSNewGe2:aHeader)
	
	if ! empty(_cProd)
		dbSelectArea("SB1")
		dbSetOrder(1)
		if ! dbSeek(xFilial("SB1")+_cProd)
			msgAlert ("Produto não cadastrado. Favor verificar !!")
			_cRet := .F.	
		else
			_cDescProd := SB1->B1_DESC
			_cProc := SB1->B1__PROC

			_cQuery := "SELECT DA1_DATVIG, DA1_PRCVEN, DA1_ITEM  "
			_cQuery += "FROM " + retSqlName("DA1") + " DA1 "
			_cQuery += "WHERE DA1.DA1_CODPRO = '" + _cProd +  "'"
			_cQuery += "  AND DA1.D_E_L_E_T_ = ' ' "
			_cQuery += "  AND DA1.DA1_CODTAB = '" + _cTabBra + "' "
			_cQuery += "ORDER BY DA1_DATVIG DESC "
		
			TcQuery _cQuery New Alias "TRB1"
			TcSetField("TRB1", "DA1_DATVIG", "D")

			_dUltAlt:= TRB1->DA1_DATVIG
			_nLista := TRB1->DA1_PRCVEN
			_cItemAt:= TRB1->DA1_ITEM

			TRB1->(dbCloseArea())
            
			_cQuery := "SELECT Z8_COD, Z8_ABREV, ACP_FAIXA, ACP_PERDES, ACP_VLRDES, ACP.R_E_C_N_O_ RECNO, ACP__SEQIT  "
			_cQuery += "FROM " + retSqlName("ACP") + " ACP "
			_cQuery += "LEFT JOIN " + retSqlName("SZ8") + " SZ8 ON Z8_COD = ACP__IDENT "
			_cQuery += "  										 AND SZ8.D_E_L_E_T_ <> '*'"
			_cQuery += "WHERE ACP_CODPRO = '" + _cProd +  "'"
			_cQuery += "  AND ACP.D_E_L_E_T_ <> '*' "
			_cQuery += "ORDER BY ACP__SEQIT "
	
			TcQuery _cQuery New Alias "TRB1"
			            
			oMSNewGe2:Acols := {}
			n := 0
			do while ! TRB1->(eof())
				n++
				AAdd(oMSNewGe2:Acols, Array(nQtdCpo2+1))
			
				oMSNewGe2:acols[n][nQtdCpo2+1] := .F.
				oMSNewGe2:aCols[n][1] := TRB1->ACP__SEQIT
				oMSNewGe2:aCols[n][2] := TRB1->ACP_FAIXA
				oMSNewGe2:aCols[n][3] := 0
				oMSNewGe2:aCols[n][4] := TRB1->ACP_PERDES
				oMSNewGe2:aCols[n][5] := TRB1->Z8_COD
				oMSNewGe2:aCols[n][6] := TRB1->Z8_ABREV		
				oMSNewGe2:aCols[n][7] := TRB1->RECNO
			
				TRB1->(dbSkip())
			enddo	

			if n == 0
				n++
				AAdd(oMSNewGe2:Acols, Array(nQtdCpo2+1))
				oMSNewGe2:acols[n][nQtdCpo2+1] := .F.
				oMSNewGe2:aCols[n][1] := "001"
				oMSNewGe2:aCols[n][2] := 0
				oMSNewGe2:aCols[n][3] := 0
				oMSNewGe2:aCols[n][4] := 0
				oMSNewGe2:aCols[n][5] := criavar("Z8_COD")
				oMSNewGe2:aCols[n][6] := criavar("Z8_ABREV")
				oMSNewGe2:aCols[n][7] := 0
			endif

			oMSNewGe2:nat:=len(oMSNewGe2:Acols)
			oMSNewGe2:Refresh()
		
			TRB1->(dbCloseArea())           
			
			oGet1:refresh()
			_lGet2 := .F.
			
		endif
	endif	
return _cRet


Static Function fMSNewGe()
	Local nX
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFields := {"ITEM","FAIXA","VALOR","PERC","IDENT","Z8_ABREV","RECNO"}
	Local aAlterFields := {"FAIXA","VALOR","PERC","IDENT"} 
	Static oMSNewGe2
	Aadd(aHeaderEx, {"Faixa"			,"ITEM"		,"@!"			,3,0 ,".T.",,"C",,,,})
	Aadd(aHeaderEx, {"Quantidade"	,"FAIXA"	,"999999"		,6,0 ,".T.",,"N",,,,})
	Aadd(aHeaderEx, {"Valor"		,"VALOR"	,"9,999,999.99"	,12,2,"U_ICOMA11B()",,"N",,,,})
	Aadd(aHeaderEx, {"Percentual"	,"PERC"		,"99.99"		,5,2 ,"U_ICOMA11C()",,"N",,,,})
	Aadd(aHeaderEx, {"Identificação","IDENT"	,"@!"			,6,0 ,"U_ICOMA11A()",,"C","SZ8",,,})
	Aadd(aHeaderEx, {"Descrição"	,"DESC"		,"@!"			,60,0,".T.",,"C",,,,})
	Aadd(aHeaderEx, {"Recno"		,"RECNO"	,"999999"		,6,0 ,".T.",,"N",,,,})

  	oMSNewGe2 := MsNewGetDados():New( 145, 13, 190, 487, GD_INSERT+GD_DELETE+GD_UPDATE , "U_ICOMA11D()", "AllwaysTrue","+ITEM", aAlterFields,,,,,, oDlg, aHeaderEx, aColsEx)
Return                                                                                      


user function ICOMA11B()
	if M->VALOR > 0 	
		oMSNewGe2:aCols[n][4] := M->VALOR / _nLista * 100	
	endif
return .T.


user function ICOMA11C()
/*
	if M->PERC > 0 	
		oMSNewGe2:aCols[n][3] := _nLista * M->PERC / 100	
	endif
*/	
return .T.


user function ICOMA11D()
	local _cRet := .T.

	if oMSNewGe2:aCols[n][2] == 0 .or. empty(oMSNewGe2:aCols[n][4]) // .or. oMSNewGe2:aCols[n][5] == 0 
		msgAlert ("O percentual e a quantidade devem ser Preenchidos. Favor verificar !!")
		_cRet := .F.
	endif
return _cRet 


static function incFaixas()
	local _cTabDesc	:= getMV("MV__DSCCBR")

	if empty(_cFaixa) .or. _nQtde == 0 .or. _nPerc == 0 .or. empty(_cIdent)
		msgAlert ("Os campos do grupo Desconto por Identificação devem ser Preenchidos. Favor verificar !!")
		return
	else
	
		_cQuery := "DELETE "
		_cQuery += "FROM " + retSqlName("ACP") + " ACP "
		_cQuery += "WHERE ACP__IDENT = '" + _cIdent +  "' "
		_cQuery += "  and ACP__SEQIT = '" + _cFaixa + "' "
		_cQuery += "  and ACP_CODPRO <> ' ' "
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
		_cQuery += "WHERE Z9_COD = '" + _cIdent +  "' "
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
				ACP->ACP_PERDES	:= _nPerc
				ACP->ACP_FAIXA	:= _nQtde
				ACP->ACP_CFAIXA	:= STRZERO(_nQtde,TAMSX3("ACP_CFAIXA")[1]) 
				ACP->ACP_TPDESC	:= "1"
				ACP->ACP__IDENT	:= _cIdent
				ACP->ACP__SEQIT	:= _cFaixa
				msUnlock()
			endif  
		
			TRBSZ9->(dbSkip())
		enddo
		TRBSZ9->(dbCloseArea())

       	msgAlert ("Registros gravados com sucesso na Tabela de Desconto !!")
		_nQtde := 0 
		_nPerc := 0 
		_cIdent:= criavar("Z8_COD") 
	   	_cDescIdent	:= criavar("Z8_ABREV")
		_cFaixa		:= criavar("ACP__SEQIT")

	endif	
return


static function excFaixas()
	if _nQtde == 0 .or. _nPerc == 0 .or. empty(_cIdent)
		msgAlert ("Os campos do grupo Desconto por Identificação devem ser Preenchidos. Favor verificar !!")
	else
	    _lExc := .F.
		dbSelectArea("ACP")
		dbSetOrder(3) 
		if dbSeek(xFilial("ACP")+_cIdent)
			do while ACP->ACP__IDENT == _cIdent
				if ACP->ACP_FAIXA == _nQtde .and. ACP->ACP_PERDES == _nPerc
				    _lExc := .T.
					reclock("ACP", .F.)
					delete
					msUnlock()
				endif			
				ACP->(dbSkip())
			enddo	
		endif	

		if ! _lExc 
			msgAlert ("Não foram encontrados registros com essas informações. Favor verificar !!")
		else
			msgAlert ("Os descontos com essas identificações foram excluídos com sucesso !!")
			_nQtde := 0 
			_nPerc := 0 
			_cIdent:= criavar("Z8_COD") 
		   	_cDescIdent	:= criavar("Z8_ABREV")
			_cFaixa		:= criavar("ACP__SEQIT")
		endif
	endif
return


static function procProd()                                                          

Local lAchou := .F.

	if month(_dDataBase) == 0 .or. _nPreco1 == 0
		msgAlert ("A Data Base e o Preço devem ser preenchidos. Favor verificar !!")
		return
	else
	
		_cQuery := " SELECT DA1_ITEM FROM "+RetSqlName("DA1")+ " WHERE D_E_L_E_T_ = ' ' "
		_cQuery += " AND DA1_CODPRO = '"+_cProd+"' AND DA1_CODTAB = '"+_cTabBra+"' AND DA1_DATVIG = '"+DtoS(_dDataBase)+"' "
		TcQuery _cQuery New Alias "TMP"
		
		DbSelectArea("TMP")
		DbGoTop()

		If !Empty(TMP->DA1_ITEM)
			lAchou := .T.
			_cItemAt := DA1_ITEM
		EndIf
		
		DbSelectArea("TMP")
		DbCloseArea()
                          
		_cQuery := "SELECT MAX(DA1_ITEM) DA_ITEM  "
		_cQuery += "FROM " + retSqlName("DA1") + " DA1 "
		_cQuery += "WHERE DA1.DA1_CODTAB = '" + _cTabBra +  "'"
		_cQuery += "  AND DA1.D_E_L_E_T_ = ' ' "
	
		TcQuery _cQuery New Alias "TRB1"
		_cItem := TRB1->DA_ITEM
		TRB1->(dbCloseArea())
		
		dbSelectArea("DA1")
		//if _dUltAlt == _dDataBase
		If lAchou
			dbSetOrder(3)	
			if dbSeek(xFilial("DA1")+_cTabBra+_cItemAt)
				reclock("DA1", .F.)
				DA1->DA1_PRCVEN	:= _nPreco1
				DA1->DA1__PREC2	:= _nPreco2
				DA1->DA1__PREC3	:= _nPreco3
				DA1->DA1__PREC4	:= _nPreco4
				msUnlock()
			endif			
		else
			if reclock("DA1", .T.)
				DA1->DA1_FILIAL	:= xFilial("DA1")
				DA1->DA1_CODTAB	:= _cTabBra
				DA1->DA1_CODPRO	:= _cProd
				DA1->DA1_PRCVEN	:= _nPreco1
				DA1->DA1_ATIVO	:= "1"
				DA1->DA1_TPOPER	:= "4"
				DA1->DA1_MOEDA	:= 1
				DA1->DA1_QTDLOT	:= 999999.99
				DA1->DA1_INDLOT := STRZERO (DA1->DA1_QTDLOT,TAMSX3("DA1_INDLOT")[1])
				DA1->DA1_DATVIG	:= _dDataBase
				DA1->DA1_ITEM	:= soma1(_cItem)
				DA1->DA1__PREC2	:= _nPreco2
				DA1->DA1__PREC3	:= _nPreco3
				DA1->DA1__PREC4	:= _nPreco4
//				DA1->DA1__DTALT := Date()
				msUnlock()
			endif         
		endif
			
		msgAlert("Tabela de Preço processada com sucesso !!")
		limpar()
	endif
return


static function prodAcols()

	local aCols 	:= oMSNewGe2:aCols  
	local nQtdeCampos 	:= len(oMSNewGe2:aHeader)
	local _cTabDesc	:= getMV("MV__DSCCBR")
	local nITEM		:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "ITEM"  })
	local nFAIXA	:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "FAIXA" })
	local nVALOR	:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "VALOR" })
	local nPERC		:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "PERC"  })
	local nIDENT	:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "IDENT" })
	local nDESC		:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "DESC"  })
	local nRECNO	:= ascan(oMSNewGe2:aHeader, { |x| AllTrim(x[2]) == "RECNO" })

	_cQuery := "SELECT MAX(ACP_ITEM) ACP_ITEM  "
	_cQuery += "FROM " + retSqlName("ACP") + " ACP "
	_cQuery += "WHERE ACP.ACP_CODREG = '" + _cTabDesc +  "'"
	_cQuery += "  AND ACP.D_E_L_E_T_ <> '*' "

	TcQuery _cQuery New Alias "TRB1"
	_cItem := TRB1->ACP_ITEM
	TRB1->(dbCloseArea())

	for x := 1 to len(aCols)

		if aCols[x][nRECNO] == 0
			if ! aCols[x][nQtdeCampos+1]
			
				if reclock("ACP", .T.)
					ACP->ACP_FILIAL	:= xFilial("ACP")
					ACP->ACP_CODREG	:= _cTabDesc
					ACP->ACP__SEQIT	:= Acols[x][nITEM]
					ACP->ACP_ITEM	:= soma1(_cItem)
					ACP->ACP_CODPRO	:= _cProd
					ACP->ACP_PERDES	:= aCols[x][nPERC]
					ACP->ACP_FAIXA	:= aCols[x][nFAIXA]
					ACP->ACP_CFAIXA	:= padl(alltrim(str(aCols[x][nFAIXA])),18,"0")
					ACP->ACP_TPDESC	:= "1"
					ACP->ACP__IDENT	:= aCols[x][nIDENT]
					msUnlock()
				endif         
				
			endif		
		else
			dbSelectArea("ACP")
			go aCols[x][nRECNO]

			if reclock("ACP", .F.)
				if ! aCols[x][nQtdeCampos+1]
					ACP->ACP_PERDES	:= aCols[x][nPERC]
					ACP->ACP_FAIXA	:= aCols[x][nFAIXA]
					ACP->ACP_CFAIXA	:= padl(alltrim(str(aCols[x][nFAIXA])),18,"0")
					ACP->ACP__IDENT	:= aCols[x][nIDENT]
				else
					delete				
				endif
			endif		

			msUnlock()
				
		endif

	next x

	msgInfo("Tabela de Descontos processada com sucesso !!")
	limpar()

return