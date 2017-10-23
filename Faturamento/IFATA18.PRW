#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IFATA18				 	| 	Setembro de 2014		  		         			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Tabela de Preços por Ítem						  	  					|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IFATA18()                        
	Local oGroup1
	Local oSay1
	local _nRet := 0
	local _aUF	:= {}
	Static _cUF
	Static oDlg

	_cEstado := getMV("MV__TABPUF")
	_cTabBra := getMV("MV__TABBRA")
	
	_aUF 		:= strtokarr(_cEstado, ',')
	aadd(_aUF, "")
		
	oFont 	:= tFont():New("Tahoma",,-14,,.t.)
	_cItem	:= space(15)
	_cProd	:= space(80) 
	_cUF		:= space(1)

	DEFINE MSDIALOG oDlg TITLE "Consulta Tabela de Preços por Item" FROM 000, 000  TO 500, 1000 COLORS 0, 16777215 PIXEL

    @ 11,006 GROUP oGroup1 TO 65, 495 PROMPT "Seleção" OF oDlg COLOR 0, 16777215 PIXEL
    @ 23,013 SAY "Ítem" SIZE 30, 10 OF oDlg PIXEL FONT oFont 
    @ 23,040 MsGet _cItem when .T. Picture "@!" Size 100,10 of oDlg PIXEL FONT oFont F3 "SB1LIK" valid buscaItem()
    @ 23,147 SAY "-" SIZE 30, 10 OF oDlg PIXEL FONT oFont
    @ 23,160 MsGet _cProd when .F. Picture "@!" Size 300,10 of oDlg PIXEL FONT oFont 

    @ 45,013 SAY "Tabela UF" SIZE 40, 10 OF oDlg PIXEL FONT oFont 
    @ 45,055 ComboBox _cUF Items _aUF Size 72,10 PIXEL OF oDlg valid buscaItem()
  
    @ 235,450 BUTTON oButton14 PROMPT "Fechar" 	SIZE 037, 012 OF oDlg ACTION {|| _nRet := 0,oDlg:End()} PIXEL	
   
    fMSNewGe1()
    fMSNewGe2()

	ACTIVATE MSDIALOG oDlg CENTERED
	                                              
Return


static function buscaItem()
	local _cRet := .T.
	local	nQtdCpo1	:= Len(oMSNewGe1:aHeader)
	local	nQtdCpo2	:= Len(oMSNewGe2:aHeader)
   
	if ! empty(_cItem)
		dbSelectArea("SB1")
		dbSetOrder(1)
		if dbSeek(xFilial("SB1")+_cItem)
			_cProd := SB1->B1_DESC
		else
			msgAlert("Produto não encontrado. Favor verificar !!")
			_cRet := .F.
		endif
		
		if _cRet
		
			_cQuery := "SELECT Z8_COD, Z8_DESCRI "
			_cQuery += "FROM " + retSqlName("SZ9") + " SZ9 "
			_cQuery += "INNER JOIN " + retSqlName("SZ8") + " SZ8 ON Z9_COD = Z8_COD "
			_cQuery += "  													 AND SZ8.D_E_L_E_T_ <> '*'"
			_cQuery += "WHERE Z9_PRODUTO = '" + _cItem +  "'"
			_cQuery += "  AND SZ9.D_E_L_E_T_ <> '*'"
	
			TcQuery _cQuery New Alias "TRB1"
			            
			oMSNewGe2:Acols := {}
			n := 0
			do while ! TRB1->(eof())
				n++
				AAdd(oMSNewGe2:Acols, Array(nQtdCpo2+1))
			
				oMSNewGe2:acols[n][nQtdCpo2+1] := .F.
				oMSNewGe2:aCols[n][1] := TRB1->Z8_COD
				oMSNewGe2:aCols[n][2] := TRB1->Z8_DESCRI		
			
				TRB1->(dbSkip())
			enddo	
			oMSNewGe2:nat:=len(oMSNewGe2:Acols)
			oMSNewGe2:Refresh()
		
			TRB1->(dbCloseArea())	
			
			_cQuery := "SELECT DA1_DATVIG, DA1_PRCVEN, DA1__PREC2,DA1__PREC3, DA1__PREC4 "
			_cQuery += "FROM " + retSqlName("DA1") + " DA1 "
			_cQuery += "INNER JOIN " + retSqlName("DA0") + " DA0 ON DA1_CODTAB = DA0_CODTAB And DA0.D_E_L_E_T_ = ' ' "
			_cQuery += "WHERE DA1_CODTAB = '" + _cTabBra + "' And DA1.DA1_CODPRO = '" + _cItem +  "'"
			_cQuery += "  AND DA1.D_E_L_E_T_ = ' ' "
			if !Empty(_cUF)
				_cQuery += "  AND DA1.DA1_ESTADO = '" + _cUF + "' "
			else
				_cQuery += "  AND DA1.DA1_ESTADO = ' ' "
			endif			
			//_cQuery += "ORDER BY DA1_DATVIG DESC"  
	   		_cQuery += "ORDER BY DA1_DATVIG DESC, DA1.R_E_C_N_O_ DESC" 
		
			TcQuery _cQuery New Alias "TRB1"
			TcSetField("TRB1", "DA1_DATVIG", "D")
			
			oMSNewGe1:Acols := {}
			n := 0
			do while ! TRB1->(eof())
				n++
				AAdd(oMSNewGe1:Acols, Array(nQtdCpo1+1))
	
				oMSNewGe1:acols[n][nQtdCpo1+1] := .F.
				oMSNewGe1:aCols[n][1] := TRB1->DA1_DATVIG
				oMSNewGe1:aCols[n][2] := TRB1->DA1_PRCVEN
				oMSNewGe1:aCols[n][3] := TRB1->DA1__PREC2
				oMSNewGe1:aCols[n][4] := TRB1->DA1__PREC3
				oMSNewGe1:aCols[n][5] := TRB1->DA1__PREC4
			
				TRB1->(dbSkip())
			enddo	
			oMSNewGe1:nat:=len(oMSNewGe1:Acols)
			oMSNewGe1:Refresh()
		
			TRB1->(dbCloseArea())
			
		endif
	endif		
return _cRet


Static Function fMSNewGe1()
	Local nX
	Local aHeaderEx := {}
	Local aColsEx := {}
	Local aFieldFill := {}
	Local aFields := {"DA1_DATVIG","DA1_PRCVEN","DA1__PREC2","DA1__PREC3","DA1__PREC4"}
	Local aAlterFields := {}
	Static oMSNewGe1
	
  	DbSelectArea("SX3")
  	SX3->(DbSetOrder(2))
  	For nX := 1 to Len(aFields)
	    If SX3->(DbSeek(aFields[nX]))
	      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
	                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
	    Endif
	Next nX
	
  	For nX := 1 to Len(aFields)
	    If DbSeek(aFields[nX])
	      Aadd(aFieldFill, CriaVar(SX3->X3_CAMPO))
	    Endif
  	Next nX
  	Aadd(aFieldFill, .F.)
  	Aadd(aColsEx, aFieldFill)

	oMSNewGe1 := MsNewGetDados():New( 70, 006, 230, 285, GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aAlterFields,, Len( aColsEx ),,,, oDlg, aHeaderEx, aColsEx)

Return


Static Function fMSNewGe2()
Local nX
Local aHeaderEx := {}
Local aColsEx := {}
Local aFields := {"Z8_COD","Z8_DESCRI"}
Local aAlterFields := {}
Static oMSNewGe2

  // Define field properties
  DbSelectArea("SX3")
  SX3->(DbSetOrder(2))
  For nX := 1 to Len(aFields)
    If SX3->(DbSeek(aFields[nX]))
      Aadd(aHeaderEx, {AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,SX3->X3_CONTEXT,SX3->X3_CBOX,SX3->X3_RELACAO})
    Endif
  Next nX

  oMSNewGe2 := MsNewGetDados():New( 70, 295, 230, 495, GD_UPDATE, "AllwaysTrue", "AllwaysTrue",, aAlterFields,, Len( aColsEx ),,,, oDlg, aHeaderEx, aColsEx)

Return