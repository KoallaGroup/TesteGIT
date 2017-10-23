#INCLUDE "TBICONN.CH"
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
	
/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : TK503AFIL			| 	Maio de 2014										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada para filtrar registros no TeleAtendimento			            |
|-----------------------------------------------------------------------------------------------|	
*/

User Function TK503AFIL()
Local _aArea 	:= getArea()                                                    
Local _cFiltro 	:= ""

DbSelectArea("SU7")
DbSetOrder(4)
If DbSeek(xFilial("SU7") + __cUserId) 
    If !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
        _cFiltro := "ADE_GRUPO == '" + SU7->U7_POSTO + "' "
    EndIf
EndIf

_cSegto := Posicione("SZ1",1,xFilial("SZ1") + __cUserId,"Z1_SEGISP")

If Val(_cSegto) > 0
	if len(_cFiltro) > 0
	    _cFiltro += " .And. ADE__SEGISP == '" + _cSegto + "' "
	else
		_cFiltro += " ADE__SEGISP == '" + _cSegto + "' "
	endif
EndIf

/*
Regra de filtro alterada - Jorge H. - Dezembro/2014
_cQuery := "SELECT * FROM " + retSqlName("SU7") + " SU7 WHERE U7_CODUSU = '" + __cUserId + "' AND D_E_L_E_T_ <> '*'"
TCQUERY _cQuery NEW ALIAS "TMPSU7"  	

if ! empty(TMPSU7->U7__DEPTO)
	_cFiltro := "ADE__DEPTO == '" + TMPSU7->U7__DEPTO + "'" 	//Filtra o Browse da rotina do Teleatendimento
endif
       
TMPSU7->(dbCloseArea())
*/
   
restArea(_aArea)
Return _cFiltro


/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | TK510FIL | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Dezembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Filtro na tela do Service Desk                                                       |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function TK510FIL()
Local _aArea    := GetArea(), _cSegto := ""    
Local _aFilUsr  := FwEmpLoad(), _cAG9 := "" 
Local _oButton1, _oComboBo1, _oSay1, _oTK530, _nComboBo1 := 1, _lOk := .f.
Local _cFiltro  := "ADE__FIL $ '"
Local _aGrp		:= {}
//Local _cDepto	:= Posicione("SU7",1,xFilial("SU7")+TkOperador(),"U7_POSTO")

For nX := 1 To (Len(_aFilUsr)-1)
	_cFiltro += _aFilUsr[nX][3] + "/"
Next nX

_cFiltro += _aFilUsr[Len(_aFilUsr)][3] + "'"

DbSelectArea("SU7")
DbSetOrder(4)
If DbSeek(xFilial("SU7") + __cUserId)
    //Verifica se o usuário pertence a mais de um grupo
    DbSelectArea("AG9")
    DbSetOrder(1)
    If DbSeek(xFilial("AG9") + SU7->U7_COD) .And. !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
        While !Eof() .And. AG9->AG9_CODSU7 == SU7->U7_COD .And. AG9->AG9_FILIAL == xFilial("AG9")         
			AADD(_aGrp,AG9->AG9_CODSU0)
 //           _cAG9 += IIF(Empty(_cAG9),AG9->AG9_CODSU0,"/" + AG9->AG9_CODSU0)
            DbSkip()
        EndDo
//        _cFiltro += " .AND. ADE_GRUPO $ '" + _cAG9 + "'"
    Else //If !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
		AADD(_aGrp,SU7->U7_POSTO)
//        _cFiltro += " .And. ('" + SU7->U7_POSTO + "' $ ADE__CVGRP .OR. ADE_GRUPO == '" + SU7->U7_POSTO + "')" 
    EndIf
             
	If !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
		_cFiltro += " .And. ('" + _aGrp[1] + "' $ ADE__CVGRP "
		If Len(_aGrp) > 1
			For nX := 2 To Len(_aGrp)
				_cFiltro += " .Or. '" + _aGrp[nX] + "' $ ADE__CVGRP "
			Next nX
		EndIf
		_cFiltro += " .OR. ADE_GRUPO == '" + SU7->U7_POSTO + "')"
	EndIf
Else
    MsgAlert("Usuario não cadastrado como operador. Favor informar ao TI")
    _cFiltro += " .AND. ADE_GRUPO == '00' "
EndIf

//Verifica o segmento do usuário
_cSegto := Posicione("SZ1",1,xFilial("SZ1") + __cUserId,"Z1_SEGISP")

If Val(_cSegto) == 0
    DbSelectArea("SX3")
    DbSetOrder(2)
    DbSeek("C5__SEGISP")
    DEFINE MSDIALOG _oTK530 TITLE "Service Desk" FROM 000, 000  TO 120, 195 COLORS 0, 16777215 PIXEL
        @ 005, 006 SAY _oSay1 PROMPT "Selecione o segmento a ser exibido" SIZE 088, 007 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 021, 007 MSCOMBOBOX _oComboBo1 VAR _nComboBo1 ITEMS Separa(Alltrim(SX3->X3_CBOX),";") SIZE 083, 010 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 039, 029 BUTTON _oButton1 PROMPT "Avançar" SIZE 037, 012 OF _oTK530 PIXEL ACTION {|| _lOK := .t.,_oTK530:End()}
    ACTIVATE MSDIALOG _oTK530 CENTERED    
    
    If _lOK
        _cFiltro += " .And. ADE__SEGISP == '" + PADR(_nComboBo1,TamSX3("ADE__SEGISP")[1]) + "' "
    EndIf
Else
    _cFiltro += " .And. ADE__SEGISP == '" + _cSegto + "' "
EndIf

restArea(_aArea)
Return _cFiltro


User Function TK510GFIL()
Local _aArea    := GetArea(), _cSegto := ""    
Local _aFilUsr  := FwEmpLoad(), _cAG9 := "" 
Local _oButton1, _oComboBo1, _oSay1, _oTK530, _nComboBo1 := 1, _lOk := .f.
Local _cFiltro  := "ADE__FIL $ '"

For nX := 1 To (Len(_aFilUsr)-1)
    _cFiltro += _aFilUsr[nX][3] + "/"
Next nX

_cFiltro += _aFilUsr[Len(_aFilUsr)][3] + "'"

DbSelectArea("SU7")
DbSetOrder(4)
If DbSeek(xFilial("SU7") + __cUserId)
    //Verifica se o usuário pertence a mais de um grupo
    DbSelectArea("AG9")
    DbSetOrder(1)
    If DbSeek(xFilial("AG9") + SU7->U7_COD) .And. !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
        While !Eof() .And. AG9->AG9_CODSU7 == SU7->U7_COD .And. AG9->AG9_FILIAL == xFilial("AG9")         
            _cAG9 += IIF(Empty(_cAG9),AG9->AG9_CODSU0,"/" + AG9->AG9_CODSU0)
            DbSkip()
        EndDo
        _cFiltro += " .AND. ADE_GRUPO $ '" + _cAG9 + "'"
    ElseIf !(SU7->U7_POSTO $ Alltrim(GetMv("MV__GRPSAC")))
        _cFiltro += " .AND. ADE_GRUPO == '" + SU7->U7_POSTO + "'"
    EndIf
Else
    MsgAlert("Usuario não cadastrado como operador. Favor informar ao TI")
    _cFiltro += " .AND. ADE_GRUPO == '00' "
EndIf

//Verifica o segmento do usuário
_cSegto := Posicione("SZ1",1,xFilial("SZ1") + __cUserId,"Z1_SEGISP")

If Val(_cSegto) == 0
    DbSelectArea("SX3")
    DbSetOrder(2)
    DbSeek("C5__SEGISP")
    DEFINE MSDIALOG _oTK530 TITLE "Chamados" FROM 000, 000  TO 120, 195 COLORS 0, 16777215 PIXEL
        @ 005, 006 SAY _oSay1 PROMPT "Selecione o segmento a ser exibido" SIZE 088, 007 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 021, 007 MSCOMBOBOX _oComboBo1 VAR _nComboBo1 ITEMS Separa(Alltrim(SX3->X3_CBOX),";") SIZE 083, 010 OF _oTK530 COLORS 0, 16777215 PIXEL
        @ 039, 029 BUTTON _oButton1 PROMPT "Avançar" SIZE 037, 012 OF _oTK530 PIXEL ACTION {|| _lOK := .t.,_oTK530:End()}
    ACTIVATE MSDIALOG _oTK530 CENTERED    
    
    If _lOK
        _cFiltro += " .And. ADE__SEGISP == '" + PADR(_nComboBo1,TamSX3("ADE__SEGISP")[1]) + "' "
    EndIf
Else
    _cFiltro += " .And. ADE__SEGISP == '" + _cSegto + "' "
EndIf

restArea(_aArea)
Return _cFiltro