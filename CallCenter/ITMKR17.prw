#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR17 | Autor: | Jose Alves         | Data: | Julho/2015   |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatorio de vendas por Representante/SubGrupo               |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKR17()

Local oButton1
Local oButton2
Local oSay1
Local oSay10
Local oSay11
Local oSay12
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oSay8
Local oSay9
Private oGet1
Private cGet1 := space(2)  
Private oGet2
Private cGet2 := Replicate('Z',TAMSX3("Z7_CODIGO")[1])
Private oGet10
Private cGet10 := Space( avSx3("Z9_COD"    	,3) )
Private oGet11
Private cGet11 := Space(1)
Private oGet12
Private cGet12 := Space(1)
Private oGet13
Private cGet13 := Space(1)
Private oGet14
Private cGet14 := Space(1)
Private oGet15
Private cGet15 := Space(1)
Private oGet3
Private cGet3 := PADR('1',TAMSX3("A3_COD")[1])
Private oGet4
Private cGet4 := Replicate('9',TAMSX3("A3_COD")[1])
Private oGet5
Private cGet5 := CTOD("  /  /    ")
Private oGet6
Private cGet6 := CTOD("  /  /    ")
Private oGet7
Private cGet7 := Space( avSx3("B1__SUBGRP" 	,3) )
Private oGet8
Private cGet8 := Replicate('Z',TAMSX3("B1__SUBGRP")[1])
Private oGet9
Private cGet9 := Space( avSx3("Z9_COD"    	,3) )
Private oRadMenu1
Private nRadMenu1 := 1

Static oDlg

  DEFINE MSDIALOG oDlg TITLE "Relacao de Vendas por Representante/SubGrupo" FROM 000, 000  TO 500, 600 COLORS 0, 16777215 PIXEL

    @ 020, 033 SAY oSay1 PROMPT "A Partir do Local:" SIZE 045, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 019, 079 MSGET oGet1 VAR cGet1 SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SM0" VALID(iif (empty(cGet1), .T., existCpo("SM0",cEmpAnt+cGet1)))
    @ 033, 045 SAY oSay2 PROMPT "Ate o Local:" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 032, 079 MSGET oGet2 VAR cGet2 SIZE 015, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SM0" VALID(iif (empty(cGet2) .or. upper(cGet2) == "ZZ", .T., existCpo("SM0",cEmpAnt+cGet2))) 
    
    @ 051, 011 SAY oSay3 PROMPT "A Partir do Representante:" SIZE 065, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 050, 079 MSGET oGet3 VAR cGet3 SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SA3" VALID(buscaRep(cGet3))  
    @ 065, 023 SAY oSay4 PROMPT "Ate o Representante:" SIZE 053, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 064, 079 MSGET oGet4 VAR cGet4 SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SA3" VALID(buscaRep(cGet4))  
    
    @ 083, 034 SAY oSay5 PROMPT "A Partir da Data:" SIZE 042, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 082, 079 MSGET oGet5 VAR cGet5 SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 096, 047 SAY oSay6 PROMPT "Ate a Data:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 095, 079 MSGET oGet6 VAR cGet6 SIZE 040, 010 OF oDlg COLORS 0, 16777215 PIXEL 
    
    @ 115, 021 SAY oSay7 PROMPT "A Partir do Sub-Grupo:" SIZE 056, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 114, 079 MSGET oGet7 VAR cGet7 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SZ4" 	Valid ValSubG(cGet7,1)
    @ 129, 033 SAY oSay8 PROMPT "Ate o Sub-Grupo:" SIZE 044, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 128, 079 MSGET oGet8 VAR cGet8 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL  F3 "SZ4" 	Valid ValSubG(cGet8,2)
    
    @ 115, 143 SAY oSay9 PROMPT "A Partir da Identificacao:" SIZE 061, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 114, 206 MSGET oGet9 VAR cGet9 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SZ8001" 	Valid ValIdent(cGet9,1)
    @ 129, 155 SAY oSay10 PROMPT "Ate a Identificacao:" SIZE 049, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 128, 206 MSGET oGet10 VAR cGet10 SIZE 025, 010 OF oDlg COLORS 0, 16777215 PIXEL F3 "SZ8001" 	Valid ValIdent(cGet10,2)     
    
    @ 158, 037 SAY oSay11 PROMPT "Tipo Operacao:" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 157, 079 MSGET oGet11 VAR cGet11 Picture "A!" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL Valid ValTipOper(cGet11,11)
    @ 157, 100 MSGET oGet12 VAR cGet12 Picture "A!" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL Valid ValTipOper(cGet12,12)
    @ 157, 121 MSGET oGet13 VAR cGet13 Picture "A!" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL Valid ValTipOper(cGet13,13)
    @ 157, 142 MSGET oGet14 VAR cGet14 Picture "A!" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL Valid ValTipOper(cGet14,14)
    @ 157, 163 MSGET oGet15 VAR cGet15 Picture "A!" SIZE 012, 010 OF oDlg COLORS 0, 16777215 PIXEL Valid ValTipOper(cGet15,15) 
   
    @ 184, 039 SAY oSay12 PROMPT "Tipo Relatorio:" SIZE 038, 007 OF oDlg COLORS 0, 16777215 PIXEL    
    @ 184, 079 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Sintetico","Analitico","Analitico Item","Representante/Item" SIZE 0200, 052 OF oDlg COLOR 0, 16777215 PIXEL
   
    @ 218, 218 BUTTON oButton1 PROMPT "Cancelar" SIZE 037, 012 OF oDlg PIXEL Action oDlg:end()
    @ 218, 172 BUTTON oButton2 PROMPT "Processar" SIZE 037, 012 OF oDlg PIXEL Action GeraRel()                  
     
    oRadMenu1:lHoriz 	:= .T.

  ACTIVATE MSDIALOG oDlg CENTERED

Return 


/*
|-----------------------------------------------------------------------------------------------|
|	Programa : GeraRel			 	| 	Julho de 2015                                           |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Alves - Anadi                                                         |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Rotina para verificação dos filtros de tela e geração do relatório em crystal   |
|-----------------------------------------------------------------------------------------------|
*/

Static Function GeraRel()

Local cTpOper	:= ""
Local cRelGer	:= ""
Local cMarcaDe 	:= ""
Local cMarcaAte	:= ""
Local cParams	:= ""
Local cOptions	:= ""
Local _cTpOp	:= ""

For i:=11 to 15
	If !Empty(&("cGet"+cValToChar(i))) .and. !Empty(cTpOper)
		cTpOper := cTpOper + ","
	EndIf
	If !Empty(&("cGet"+cValToChar(i)))
		cTpOper := cTpOper + TipOper(&("cGet"+cValToChar(i)))
	EndIf  
	_cTpOp := Alltrim(_cTpOp + &("cGet"+cValToChar(i)))
Next

If Empty(cTpOper)
	cTpOper := "1,2,3,4,5"
EndIf

cTpOper := FormatIn(cTpOper,",")
	
Do Case
	
	Case nRadMenu1 == 1
		cRelGer := "ITMKCR17A"	
	Case nRadMenu1 == 2                                   
		cRelGer := "ITMKCR17B"	
	Case nRadMenu1 == 3
		cRelGer := "ITMKCR17C"	
	Case nRadMenu1 == 4
		cRelGer := "ITMKCR17D"	
EndCase

cParams += cGet1 		+ ";"
cParams += cGet2 		+ ";"
cParams += cGet3 		+ ";"
cParams += cGet4 		+ ";"
cParams += DTOS(cGet5) 	+ ";"
cParams += DTOS(cGet6) 	+ ";"
cParams += cGet7		+ ";"
cParams += cGet8 		+ ";"
cParams += cGet9 		+ ";"
cParams += cGet10 		+ ";"
cParams += cTpOper

cOptions := "1;0;1;Relatorio de vendas por Representante/SubGrupo"

CallCrys(cRelGer,cParams,cOptions)

Return     



////////////////////////////////////////////////
//Representante
////////////////////////////////////////////////

static function buscaRep(cRepres)

Local aArea 	:= getArea()

dbSelectArea("SA3")
dbSetOrder(1)

if !dbSeek(xFilial("SA3")+cRepres) .and. !empty(cRepres) .and. !(upper(cRepres) $ "ZZZZZZ") .and. !(cRepres $ '99999999')
	msgAlert ("Representante não encontrado !!")
	return .F.
endif

restarea(aArea)

return .T. 


////////////////////////////////////////////////
//Identificacao
////////////////////////////////////////////////

static function ValIdent(_cIdent,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cIdent) .and. _nSt == 2
	
	cGet10 := "ZZZZZZ"
	oGet10:Refresh()
	
Else
	
	dbSelectArea("SZ8")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ8")+_cIdent) .and. !empty(_cIdent)
		msgAlert ("Identificação Inválida !!")
		lRet := .F.
	endif
	
EndIf

return lRet   


////////////////////////////////////////////////
//SubGrupo
////////////////////////////////////////////////

static function ValSubG(_cSubG,_nSt)

Local lRet	:= .T.

If "Z" $ Upper(_cSubG) .and. _nSt == 2
	
	cGet8 := "ZZZZ"
	oGet8:Refresh()
	
Else
	
	dbSelectArea("SZ4")
	dbSetOrder(1)
	if ! dbSeek(xFilial("SZ4")+_cSubG) .and. !empty(_cSubG)
		msgAlert ("Sub-Grupo Inválido !!")
		lRet := .F.
	endif
	
EndIf

return lRet   


////////////////////////////////////////////////
//Tipo Operacao
////////////////////////////////////////////////

static function ValTipOper(_cTp,_nTp)

Local lRet	:= .T.

If !Empty(_cTp)
	
	_cTP := Upper(_cTp)
	
	&("cGet"+cValToChar(_nTp)) := _cTp
	
	For x:=11 to 15
		If !lRet
			exit
		EndIf
		If x != _nTp
			For xi:=11 to 15
				If xi != _nTp
					If 	_cTp == &("cGet"+cValToChar(xi))
						msgAlert("Parâmetro Duplicado !!")
						lRet := .F.
						exit
					EndIf
				EndIf
			Next
		EndIf
	Next
	
	If !(_cTp $ "ACDR") .and. !Empty(_cTp) .and. lRet
		msgAlert("Tipo de Operação inválido !!")
		lRet := .F.
	EndIf
	
EndIf

return lRet      


static function TipOper(cTp)

Local _cTp := ""

Do Case
	Case cTp == "C"
		_cTp := "1"
	Case cTp == "A"
		_cTp := "2"
	Case cTp == "R"
		_cTp := "4"
	Case cTp == "D"
		_cTp := "5"
EndCase

return _cTp