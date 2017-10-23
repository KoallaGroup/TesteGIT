#include "topconn.ch"
#Include "Protheus.ch"
#Include "Rwmake.ch"

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGENM13 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Consulta padrão filiais do usuário                                                  |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function IGENM13(_cEmpFil)
Local _aArea  := GetArea(), _oGet := Nil, _oDlg1 := {}, _aFilUsr := FwEmpLoad()
Local _aHead := {}, _aFill := {}, _aCol := {}, _ny := _nz := 1
Local _aStru  := {"ZE_CODFIL", "ZE_FILIAL"}, _lok := .f.

Default _cEmpFil := cFilAnt 

If Len(_aFilUsr) > 0
    DbSelectArea("SX3")
    DbSetOrder(2)
    For _ny := 1 to Len(_aStru)
        If DbSeek(_aStru[_ny])
            Aadd(_aHead, {SX3->X3_TITULO,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,".T." /*SX3->X3_VALID*/,;
                            SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_F3,"R" /*SX3->X3_CONTEXT*/,SX3->X3_CBOX,"" /*SX3->X3_RELACAO*/})
                                                   
        Endif
    Next _ny    

    For _ny := 1 To Len(_aFilUsr)
        If _aFilUsr[_ny][1] == cEmpAnt
            AADD(_aCol,{_aFilUsr[_ny][3],_aFilUsr[_ny][4],.f.})        
        EndIf     
    Next _ny
    
    DEFINE MSDIALOG _oDlg1 TITLE "Escolha a Filial" FROM 000,000 TO 350,450 PIXEL   
    _oGet := MsNewGetDados():New(300,300,300,300,/*GD_INSERT+GD_DELETE+GD_UPDATE*/,,,,,,999,,,,_oDlg1,_aHead,_aCol)
    AlignObject( _oDlg1 ,{ _oGet:oBrowse }, 1, 1, { 500 } )    
    _oGet:oBrowse:BldBlClick := {|| If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil)}
    ACTIVATE MSDIALOG _oDlg1 CENTERED ON INIT ( EnchoiceBar( _oDlg1, { || If( _lOk := _oGet:TudoOK(), _oDlg1:End(), Nil ) }, { || _oDlg1:End() } ) )

    If _lOK
        If MsgYesNo("Confirma a troca de filial?","ATENCAO")
            _cEmpFil := _oGet:aCols[_oGet:nAt][1]
        EndIf
    EndIf
        
EndIf

RestArea(_aArea)                            
Return _cEmpFil

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IGENM13V | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Valida a filial informada pelo usuário                                               |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

User Function IGENM13V(_cEmpFil)
Local _lRet := .f., _aFilUsr := FwEmpLoad(), nx := 0, _cChave := cEmpAnt + _cEmpFil, _lAchou := .f.

For nx := 1 To Len (_aFilUsr)
    If _aFilUsr[nx][1] + _aFilUsr[nx][3] == _cChave
        If MsgYesNo("Confirma a troca de filial?","ATENCAO")
            _lRet := .t.
            _lAchou := .t.
            Exit
        Else
            _lAchou := .t.
        EndIf
    EndIf 
Next

If !_lRet .And. !_lAchou
    MsgAlert("Filial nao localizada","ATENCAO")
EndIf

Return _lRet