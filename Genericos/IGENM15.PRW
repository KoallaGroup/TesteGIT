#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGENM15 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Tela de consulta composto de produtos                                               |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/


User Function IGENM15()
Local _oButton1, _oButton2, _oButton3, _oButton4, _oDescri, _oSegto, _oGroup1, _oGroup2, _oGrupo, _oIdent, _oMarca
Local _oNome, _oProd, _oSay1, _oSay2, _oSay3, _oSay4, _oSay5, _oSay6, _oSay7, _nPProd := 0, _cRet := Space(TamSX3("B1_COD")[1])
Local _cDescri := Space(TamSX3("B1__DESCP")[1]), _oCompleta, _cCompleta := Space(TamSx3("B1__DESCP")[1]), _oFont1
Local _cSegto  := U_SETSEGTO(), _cGrupo := Space(TamSX3("B1_GRUPO")[1]), _cIdent := Space(TamSX3("Z8_DESCRI")[1]),_nVar := 0
Local _cMarca  := Space(TamSX3("Z4_DESC")[1]), _cNome := Space(TamSX3("B1_DESC")[1]), _cProd := Space(TamSX3("B1_DESC")[1])
Private _oDlg1, _oGetD1

If Type("Inclui") != "L"
    Inclui := .f.
EndIf

If Type("Altera") != "L"
    Altera := .f.
EndIf

DEFINE FONT _oFont1 Name "Tahoma" Size 0 , -11 BOLD

DEFINE MSDIALOG _oDlg1 TITLE "Pesquisa De Produto" FROM 000, 000  TO 550, 700   PIXEL

    @ 003, 000 GROUP _oGroup1 TO 092, 350 PROMPT "Modulo De Pesquisa"           OF _oDlg1 PIXEL
    @ 215, 000 GROUP _oGroup2 TO 254, 350 PROMPT "Descricao Completa"           OF _oDlg1 PIXEL
    @ 015, 210 SAY oSay8 PROMPT "Separe as palavras por percentual (%) para pesquisar por mais de uma palavra no mesmo campo." SIZE 135, 025 OF _oDlg1 COLORS 255, 16777215 FONT _oFont1 PIXEL
    @ 040, 210 SAY oSay9 PROMPT "Exemplo: PALAVRA1%PALAVRA2%PALAVRA3"           OF _oDlg1 COLORS 255, 16777215 PIXEL SIZE 135, 020 FONT _oFont1
    @ 015, 004 SAY _oSay1 PROMPT "Nome" SIZE 020, 007                           OF _oDlg1 PIXEL
    @ 014, 050 MSGET _oNome VAR _cNome SIZE 157, 010                            OF _oDlg1 PIXEL PICTURE "@!"
    @ 030, 004 SAY _oSay2 PROMPT "Descricao Marca" SIZE 044, 007                OF _oDlg1 PIXEL 
    @ 029, 050 MSGET _oMarca VAR _cMarca SIZE 157, 010                          OF _oDlg1 PIXEL PICTURE "@!"
    @ 045, 004 SAY _oSay3 PROMPT "Identificacao" SIZE 035, 007                  OF _oDlg1 PIXEL
    @ 044, 050 MSGET _oIdent VAR _cIdent SIZE 157, 010                          OF _oDlg1 PIXEL PICTURE "@!"
    @ 060, 004 SAY _oSay4 PROMPT "Descricao Prod" SIZE 040, 007                 OF _oDlg1 PIXEL
    @ 059, 050 MSGET _oDescri VAR _cDescri SIZE 157, 010                        OF _oDlg1 PIXEL PICTURE "@!"
    @ 060, 278 SAY _oSay5 PROMPT "Segmento" SIZE 025, 010                       OF _oDlg1 PIXEL
    @ 059, 310 MSGET _oSegto VAR _cSegto SIZE 020, 010                          OF _oDlg1 PIXEL READONLY    
    @ 075, 004 SAY _oSay6 PROMPT "Codigo Produto" SIZE 042, 007                 OF _oDlg1 PIXEL
    @ 074, 049 MSGET _oProd VAR _cProd SIZE 060, 010                            OF _oDlg1 PIXEL PICTURE "@!"
    @ 075, 121 SAY _oSay7 PROMPT "Codigo Grupo" SIZE 036, 007                   OF _oDlg1 PIXEL
    @ 074, 165 MSGET _oGrupo VAR _cGrupo SIZE 042, 010                          OF _oDlg1 PIXEL PICTURE "@!"
    @ 075, 295 BUTTON _oButton4 PROMPT "Pesquisar" SIZE 037, 012                OF _oDlg1 PIXEL ACTION {|| Processa({|| CursorWait(),IGENM15PESQ(_cNome,_cMarca,_cIdent,_cDescri,_cSegto,_cProd,_cGrupo,@_cCompleta,_oCompleta,_nPProd),CursorArrow()},"Buscando Produtos, aguarde...") }
    If Inclui .Or. Altera        
        @ 260, 180 BUTTON _oButton1 PROMPT "Incluir no Pedido" SIZE 047, 012    OF _oDlg1 PIXEL ACTION {|| _nVar := 1,_oDlg1:End()}
    EndIf
    @ 260, 250 BUTTON _oButton2 PROMPT "Visualizar" SIZE 037, 012               OF _oDlg1 PIXEL ACTION {|| IIF(_nPProd > 0,IGENM15VIS(_oGetD1:aCols[_oGetD1:nAt][_nPProd]),MsgAlert("Nenhum produto a ser visualizado"))}
    @ 260, 310 BUTTON _oButton3 PROMPT "Retornar" SIZE 037, 012                 OF _oDlg1 PIXEL ACTION {|| _nVar := 0,_oDlg1:End()}
    @ 224, 003 GET _oCompleta VAR _cCompleta MULTILINE SIZE 345, 027 HSCROLL    OF _oDlg1 PIXEL READONLY
    IGENM15GET()
    _nPProd := aScan(_oGetD1:aHeader,{|x| AllTrim(x[2]) == "B1_COD" })
    _oGetD1:bChange := {|| _cCompleta := Posicione("SB1",1,xFilial("SB1") + _oGetD1:aCols[_oGetD1:nAt][_nPProd],"B1__DESCP"),_oCompleta:Refresh() } 
ACTIVATE MSDIALOG _oDlg1 CENTERED

If _nVar > 0
    If _nVar == 1
        _cRet := _oGetD1:aCols[_oGetD1:nAt][_nPProd]
    EndIf
EndIf

Return _cRet


Static Function IGENM15GET()
Local _aCpo := {"B1_DESC","Z5_DESC","B1_COD"}
Local _aTitulo := {"Produto","Marca","Codigo Produto"}
Local nx := 0, _aFill := {}, _aHead := {}, _aCol := {}, _nTam := 0

DbSelectArea("SX3")
SX3->(DbSetOrder(2))
For nX := 1 to Len(_aCpo)
    If SX3->(DbSeek(_aCpo[nx]))
        If _aCpo[nx] == "Z5_DESC"
            _nTam := Int(SX3->X3_TAMANHO/2)
        Else
            _nTam := SX3->X3_TAMANHO
        EndIf
        Aadd(_aHead, {_aTitulo[nx],_aCpo[nx],SX3->X3_PICTURE,_nTam,SX3->X3_DECIMAL,SX3->X3_VALID,;
                       SX3->X3_USADO,SX3->X3_TIPO,"",SX3->X3_CONTEXT,SX3->X3_CBOX,""})
    Endif
Next nX

For nX := 1 to Len(_aCpo)
    If DbSeek(_aCpo[nX])
        Aadd(_aFill, CriaVar(SX3->X3_CAMPO))
    Endif
Next nX
Aadd(_aFill, .F.)
Aadd(_aCol, _aFill)

_oGetD1 := MsNewGetDados():New( 092, 000, 212, 350, , "AllwaysTrue", "AllwaysTrue", "", ,, 9999, "AllwaysTrue", "", "AllwaysTrue", _oDlg1, _aHead, _aCol)

Return

Static Function IGENM15PESQ(_cNome,_cMarca,_cIdent,_cDescri,_cSegto,_cProd,_cGrupo,_cCompleta,_oCompleta,_nPProd)
Local _cSQL := _cTab := "", _aFill := {}
Default _cNome := "", _cMarca := "", _cIdent := "", _cDescri := "", _cSegto := "", _cProd := "", _cGrupo := ""

If Empty(_cNome + _cMarca + _cIdent + _cDescri + _cSegto + _cProd + _cGrupo)
    MsgAlert("Dados não informados","PARAMETROS INVALIDOS")
    Return
EndIf

_cTab := GetNextAlias()
_cSQL := "Select Distinct B1_COD,B1_DESC,B1__DESCP,Z5_DESC From " + RetSqlName("SB1") + " B1 "
_cSQL += "Inner Join " + RetSqlName("SZ5") + " Z5 On Z5_FILIAL = '" + xFilial("SZ5") + "' And Z5_CODIGO = B1__MARCA And Z5.D_E_L_E_T_ = ' ' "
If Val(_cSegto) > 0
    _cSQL += " And (Z5_SEGISP = '" + _cSegto + "' Or Z5_SEGISP = '0') "
EndIf
If !Empty(_cMarca)
    _cMarca := Separa(Alltrim(_cMarca),"%")
    For nx := 1 To Len(_cMarca)
       _cSQL += " And Upper(Z5_DESC) Like '%" + Upper(_cMarca[nx]) + "%' "
    Next
EndIf

If !Empty(_cIdent)
    _cSQL += "Inner Join " + RetSqlName("SZ8") + " Z8 On Z8_FILIAL = '" + xFilial("SZ8") + "' And Z8_MSBLQL <> '1' And Z8.D_E_L_E_T_ = ' ' "
    If Val(_cSegto) > 0
        _cSQL += " And (Z8_SEGISP = '" + _cSegto + "' Or Z8_SEGISP = '0') "
    EndIf
    _cIdent := Separa(Alltrim(_cIdent),"%")
    For nx := 1 To Len(_cIdent)
       _cSQL += " And Upper(Z8_DESCRI) Like '%" + Upper(_cIdent[nx]) + "%' "
    Next
    _cSQL += "Inner Join " + RetSqlName("SZ9") + " Z9 On Z9_FILIAL = '" + xFilial("SZ9") + "' And Z9_COD = Z8_COD And Z9_PRODUTO = B1_COD And "
    _cSQL +=    "Z9_MSBLQL <> '1' "
EndIf
_cSQL += "WHERE B1.D_E_L_E_T_ = ' ' And B1_MSBLQL <> '1' And B1_ATIVO = 'S' "

If Val(_cSegto) > 0
    _cSQL += " And (B1__SEGISP = '" + _cSegto + "' Or B1__SEGISP = '0') "
EndIf

If !Empty(_cNome)
    _cNome := Separa(Alltrim(_cNome),"%")
    For nx := 1 To Len(_cNome)
       _cSQL += " And Upper(B1_DESC) Like '%" + Upper(_cNome[nx]) + "%' "
    Next
EndIf

If !Empty(_cDescri)
    _cDescri := Separa(Alltrim(_cDescri),"%")
    For nx := 1 To Len(_cDescri)
       _cSQL += " And Upper(B1__DESCP) Like '%" + Upper(_cDescri[nx]) + "%' "
    Next
EndIf

If !Empty(_cProd)
       _cSQL += " And Upper(B1_COD) = '" + Upper(_cProd) + "' "
EndIf

If !Empty(_cGrupo)
    _cSQL += " And Upper(B1_GRUPO) = '" + Upper(_cGrupo) + "' "
EndIf

_cSQL += "Order By B1_DESC,Z5_DESC,B1_COD "

If Select(_cTab) > 0
    DbSelectArea(_cTab)
    DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
    While !Eof()
        AADD(_aFill,{(_cTab)->B1_DESC, (_cTab)->Z5_DESC, (_cTab)->B1_COD, .f.})
        
        DbSelectArea(_cTab)
        DbSkip()
    EndDo
Else
    MsgAlert("Nenhum registro encontrado, por favor, revise os parametros")
EndIf  

If Len(_aFill) > 0
    _oGetD1:aCols := _aFill
    _oGetD1:Refresh()
    _cCompleta := Posicione("SB1",1,xFilial("SB1") + _oGetD1:aCols[_oGetD1:nAt][_nPProd],"B1__DESCP")
    _oCompleta:Refresh()
EndIf

DbSelectArea(_cTab)
DbCloseArea()

Return

Static Function IGENM15VIS(_cProd)

cCadastro := "Cadastro de Produtos"
Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_COD")
MsAguarde({|| A010Visul("SB1",SB1->(Recno()),2)},"Processando","Gerando visualização")

Return