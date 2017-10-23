#Include "Protheus.ch"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+------------------------------------------+-------+------------+
| Programa:  | ICOMG01 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Julho/2015 |
+------------+---------+--------+------------------------------------------+-------+------------+
| Descrição: | Gatilho na geração do documento de entrada e Pré-nota				            |
+-----------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                            |
+------------+----------------------------------------------------------------------------------+
*/

User Function ICOMG01()
Local _aArea := GetArea(), _cArmz := SB1->B1_LOCPAD, _cChave := ""
Local _lZ08 := .f.

_lZ08 := .f.
DbselectArea("Z08")
DbSetOrder(1)
If DbSeek(xFilial("Z08") + SB1->B1_COD)
	_lZ08 := .t.
Else
	DbSetOrder(2)
	If DbSeek(xFilial("Z08") + SB1->B1_GRUPO)
		_lZ08 := .t.
	EndIf
EndIf

If Alltrim(cA100For) $ GetMv("MV__ARMFOR") .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG") .And. cTipo == "N" .And. _lZ08 .And. cFilAnt $ Alltrim(GetMv("MV__ARMFIL"))
    _cArmz := Alltrim(GetMv("MV__ARMCOD"))

ElseIf cTipo == "N" .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG") .And. Alltrim(cA100For) $ SM0->M0_CGC //Verifica se é uma entrada por transferência

    _cChave := PADR(Alltrim(SubStr(SM0->M0_CGC,1,8)),TamSX3("D2_CLIENTE")[1]) + PADR(Alltrim(Str(Val(SubStr(SM0->M0_CGC,11,4)))),TamSX3("D2_LOJA")[1]) 

    DbSelectArea("SA2")
    DbSetOrder(1)
    DbSeek(xFilial("SA2") + cA100For + cLoja)
    
    DbSelectArea("SZE")
    DbSetOrder(2)
    If DbSeek(SA2->A2_CGC)
        DbSelectArea("SD2")
        DbSetOrder(3)
        If DbSeek(PADR(SZE->ZE_CODFIL,TamSX3("D2_FILIAL")[1]) + cNFiscal + cSerie + _cChave + M->D1_COD)
            _cArmz := SD2->D2_LOCAL
        EndIf 
    EndIf

EndIf

RestArea(_aArea)
Return _cArmz

//Gatilho para atualizar a CST do item
User Function ICOMG01O(_nLinha)
Local _aArea := GetArea(), _nPCST := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_CLASFIS" }), _cOri := aCols[_nLinha][_nPCST] 
Local _nPTes := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_TES" }), _nPArm := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_LOCAL" })
Local _cTES := IIF(_nPTes > 0,IIF("D1_TES" $ ReadVar(), M->D1_TES, aCols[_nLinha][_nPTes]),"")
Local _nPPrd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_COD" })

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1") + aCols[_nLinha][_nPPrd])

If (Alltrim(cA100For) $ GetMv("MV__ARMFOR") .Or. Alltrim(cA100For) $ SM0->M0_CGC) .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG") .And. cTipo == "N"

    If aCols[_nLinha][_nPArm] $ Alltrim(GetMv("MV__ARMCOD"))
        _cOri := "2"
    Else
        _cOri := SB1->B1_ORIGEM
    EndIf
    
    If !Empty(_cTES)
        _cOri := _cOri + Posicione("SF4",1,xFilial("SF4") + _cTES,"F4_SITTRIB")
    EndIf
EndIf

RestArea(_aArea)
Return PADR(_cOri,TamSX3("D1_CLASFIS")[1])