#include "PROTHEUS.CH"
#include "TopConn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFOLA003			  		| 	Janeiro de 2015							  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Programa para lançamento de eventos nas comissões								 		|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function IFOLA003()
	Local oButton1, oButton2, oGet1
	Local _cRefExt := Space(TamSX3("Z2_CODPROC")[1]), _oFont := tFont():New("Tahoma",,-14,,.t.), _oFont2 := tFont():New("Tahoma",,-12,,.t.)   
	Private _oIFOLA003, _oGetProc
	
	DEFINE MSDIALOG _oIFOLA003 TITLE "" FROM 000, 000  TO 500, 1150 PIXEL
	
	    @ 005, 220 SAY "Lançamento de Eventos nas Comissões" SIZE 150, 010 OF _oIFOLA003 PIXEL FONT _oFont
	    fMSNewGe1()
	    @ 235, 450 BUTTON oButton1 PROMPT "Gravar" 	SIZE 037, 012 OF _oIFOLA003 PIXEL ACTION IFOLA03G()
	    @ 235, 500 BUTTON oButton2 PROMPT "Sair" 	SIZE 037, 012 OF _oIFOLA003 PIXEL ACTION _oIFOLA003:End()
	
	ACTIVATE MSDIALOG _oIFOLA003 CENTERED
	
Return


Static Function fMSNewGe1()
	Local nX := 0, aHeaderEx := {}, aColsEx := {}, aFieldFill := {}                                           
	local _aAlter := {"E3_VEND", "E3_COMIS", "Z24_CODIGO", "E3_VENCTO", "E3__OBS"}
	Local aFields := {"E3_VEND", "A3_NREDUZ", "Z24_CODIGO", "Z24_DESC", "Z24_TIPO", "E3_COMIS", "E3_VENCTO", "E3__OBS"}
	Local aValids := {"U_IFOLA03V()", ".T.", "U_IFOLA03T()", ".T.", ".T.", ".T.", ".T.", ".T."}
	
	//aHeader
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	For nX := 1 to Len(aFields)
	    If SX3->(DbSeek(aFields[nX]))
	      Aadd(aHeaderEx, { alltrim(iif (aFields[nX] == "E3_COMIS", "Valor", SX3->X3_TITULO)),;
	      					SX3->X3_CAMPO, ;
	      					SX3->X3_PICTURE, ;
	      					SX3->X3_TAMANHO, ;
	      					SX3->X3_DECIMAL, ;
	      					aValids[nX],;
	                       	SX3->X3_USADO, ;
	                       	SX3->X3_TIPO, ;
	                       	SX3->X3_F3, ;
	                       	SX3->X3_CONTEXT, ;
	                       	SX3->X3_CBOX, ;
	                       	SX3->X3_RELACAO,;
	                       	".T.", ;
	                       	SX3->X3_VISUAL, ;
	                       	".T.",;
	                       	,;
	                       	iif (aFields[nX] == "E3_COMIS", .F., SX3->X3_TITULO)})
	    Endif
	Next nX
	
	aadd( aHeaderEx, {"Recno WT", "SE3_REC_WT", "", 09, 0,,, "N", "SE3", "V"} )	
	                                                  
	_cGds := GD_INSERT+GD_UPDATE+GD_DELETE
	
	_oGetProc := MsNewGetDados():New(26, 3, 227, 575, _cGds, "U_IFOLA03L()", "AllwaysTrue", "", _aAlter, , , , , , _oIFOLA003, aHeaderEx, aColsEx)
	
Return                          


user function IFOLA03V()
	local _lRet 		:= .T.
	local nPosA3_NREDUZ	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "A3_NREDUZ"})
	
    dbSelectArea("SA3")
    dbSetOrder(1)
    if dbSeek(xFilial("SA3")+M->E3_VEND)
       	_oGetProc:aCols[n][nPosA3_NREDUZ] := SA3->A3_NREDUZ    
    else
    	msgAlert("Vendedor não encontrado. Favor verificar !!")
		_lRet := .F.
    endif
return _lRet


user function IFOLA03T()
	local _lRet 		:= .T.
	local nPosZ24_DESC	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_DESC"})
	local nPosZ24_TIPO	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_TIPO"})
	
    dbSelectArea("Z24")
    dbSetOrder(1)
    if dbSeek(xFilial("Z24")+M->Z24_CODIGO)
       	_oGetProc:aCols[n][nPosZ24_DESC] := Z24->Z24_DESC
       	_oGetProc:aCols[n][nPosZ24_TIPO] := Z24->Z24_TIPO
       	
    else
    	msgAlert("Tipo de lançamento não encontrado. Favor verificar !!")
		_lRet := .F.
    endif
return _lRet     


user function IFOLA03L()
	local _lRet 		:= .T.
	local nPosE3_V		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VEND"})
	local nPosZ24_CODIGO:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_CODIGO"})
	local nPosE3_COMIS	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_COMIS"})
	local nPosE3_VENCTO	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VENCTO"})
	local n_E3_OBS		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3__OBS"})
	local cLancZero		:=  superGetMV("MV__LANRHZR",,"000030")
    
	if empty(_oGetProc:aCols[n][nPosE3_V])
		_lRet := .F.
	endif
	if empty(_oGetProc:aCols[n][nPosZ24_CODIGO])
		_lRet := .F.
	endif                                            
	if ! _oGetProc:aCols[n][nPosZ24_CODIGO] $ cLancZero
		if _oGetProc:aCols[n][nPosE3_COMIS] == 0
			_lRet := .F.
		endif
	endif
	if empty(_oGetProc:aCols[n][nPosE3_VENCTO])
		_lRet := .F.
	endif
	
	if ! _lRet
		if ! _oGetProc:aCols[n][nPosZ24_CODIGO] $ cLancZero
			msgAlert("Os campos Vendedor, Comissão, Vencimento, Valor e Tipo de Lançamento" + chr(13) + "devem ser preenchidos. Favor verificar !!")	
		else
			msgAlert("Os campos Vendedor, Comissão, Vencimento e Tipo de Lançamento" + chr(13) + "devem ser preenchidos. Favor verificar !!")	
		endif
	endif    	

return _lRet     
       

static function IFOLA03Z()
	local _lRet 		:= .T.
	local nPosE3_V		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VEND"})
	local nPosZ24_CODIGO:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_CODIGO"})
	local nPosE3_COMIS	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_COMIS"})
	local nPosE3_VENCTO	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VENCTO"})
	local n_E3_OBS		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3__OBS"})
	local cLancZero		:=  superGetMV("MV__LANRHZR",,"000030")

	for x := 1 to len(_oGetProc:aCols)

		if empty(_oGetProc:aCols[x][nPosE3_V])
			_lRet := .F.
		endif
		if empty(_oGetProc:aCols[x][nPosZ24_CODIGO])
			_lRet := .F.
		endif                                            
		if ! _oGetProc:aCols[x][nPosZ24_CODIGO] $ cLancZero
			if _oGetProc:aCols[x][nPosE3_COMIS] == 0
				_lRet := .F. 
			endif
		endif
		if empty(_oGetProc:aCols[x][nPosE3_VENCTO])
			_lRet := .F.
		endif
		
		if ! _lRet
			msgAlert("Os campos Vendedor, Comissão, Vencimento, Tipo de Lançamento e/ou Valor" + chr(13) + "devem ser preenchidos. Favor verificar !!")	
		endif    	
	
	next x
return _lRet     


static function IFOLA03G()
	local n_E3_VEND		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VEND"})
	local n_Z24_CODIGO	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_CODIGO"})
	local n_E3_COMIS	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_COMIS"})
	local n_E3_VENCTO	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3_VENCTO"})
	local n_E3_OBS		:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "E3__OBS"})
	local n_Z24_COMIS	:=  ASCAN(_oGetProc:aHeader, { |x| AllTrim(x[2]) == "Z24_COMIS"})
    
	if IFOLA03Z()

		for x := 1 to len(_oGetProc:aCols)
		    
			if ! _oGetProc:aCols[x][len(_oGetProc:aHeader)+1]
				_cTipo := posicione("Z24", 1, xFilial("Z24")+_oGetProc:aCols[x][n_Z24_CODIGO], "Z24_TIPO")
			    _cComis:= posicione("Z24", 1, xFilial("Z24")+_oGetProc:aCols[x][n_Z24_CODIGO], "Z24_COMIS")
				reclock("SE3", .T.)
		
				SE3->E3_FILIAL	:= xFilial("SE3")
				SE3->E3_VEND 	:= _oGetProc:aCols[x][n_E3_VEND]
				SE3->E3_COMIS	:= iif(_cTipo == '1', _oGetProc:aCols[x][n_E3_COMIS] * -1, _oGetProc:aCols[x][n_E3_COMIS])
				SE3->E3_VENCTO	:= _oGetProc:aCols[x][n_E3_VENCTO]
				SE3->E3_EMISSAO	:= _oGetProc:aCols[x][n_E3_VENCTO]
				SE3->E3_BASE	:= iif(_cTipo == '1', _oGetProc:aCols[x][n_E3_COMIS] * -1, _oGetProc:aCols[x][n_E3_COMIS])
				SE3->E3_PORC	:= 100
				SE3->E3__TPLANC	:= _oGetProc:aCols[x][n_Z24_CODIGO]
				SE3->E3__OBS	:= _oGetProc:aCols[x][n_E3_OBS]                                          
				SE3->E3__COMIS 	:= _cComis
		        SE3->(msUnlock())
			endif
						
		next x
	
		_oIFOLA003:End()
		
	endif		
return

