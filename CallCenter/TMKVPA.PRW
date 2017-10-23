#Include "PROTHEUS.CH"
#INCLUDE "TMKDEF.CH" 

/*
+------------+--------+--------+------------------------------------------+-------+---------------+
| Programa:  | TMKVPA | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Novembro/2014 |
+------------+--------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para substituir a tela de pagamento do Call Center                |
+-------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                              |
+------------+------------------------------------------------------------------------------------+
*/

User Function TMKVPA(aValores,aObj,aItens,cCodPagto,oCodPagto,cDescPagto,oDescPagto,cCodTransp,;
                     oCodTransp,cTransp,oTransp,cCob,oCob,cEnt,oEnt,cCidadeC,oCidadeC,cCepC,;
                     oCepC,cUfC,oUfC,cBairroE,oBairroE,cBairroC,oBairroC,cCidadeE,oCidadeE,;
                     cCepE,oCepE,cUfE,oUfE,nLiquido,oLiquido,nTxJuros,oTxJuros,nTxDescon,;
                     oTxDescon,aParcelas,oParcelas,nEntrada,oEntrada,nFinanciado,oFinanciado,nNumParcelas,;
                     oNumParcelas,nVlJur,nOpc,cNumTlv,cCliente,cLoja,cCodCont,cCodOper,cCliAnt,lTLVReg)

Local lRet      := .T., _cRedesp := ""
Local _aArea	:= GetArea()
Local _aAreaSC6 := SC6->(GetArea())

lRet := U_ITMKVLTRP(@_cRedesp)
If !lRet 
    Return lRet
Else
    ITMKPAG(aValores,cCodPagto,@aParcelas)
    nNumParcelas    := Len(aParcelas)
    cCodPagto       := M->UA_CONDPG
    cCodTransp      := M->UA_TRANSP
    M->UA__REDESP   := _cRedesp 
EndIf

If(M->UA_OPER == "1")
    U_ITMKC09(M->UA_CLIENTE,M->UA_LOJA,M->UA_NUM,.f.)
EndIf

If( M->UA_OPER == "1" .AND. !(M->UA__TPREAB == "2" .AND. alltrim(M->UA__SITFIN) == "A" .AND. alltrim(M->UA__SITCOM) == "A") )
    lRet := U_IFATA14(M->UA_NUM)
EndIf   

RestArea(_aArea)
RestArea(_aAreaSC6)
Return lRet


Static Function ITMKPAG(aValores,cCodPagto,aParcelas)
Local aAux := {}, nCont := 0
Local nLiquido := aValores[BASEDUP] - aValores[ACRESCIMO], nVlJur := Tk273RecCpg(cCodPagto)
Local cForma1 := SPACE(2), cForma2 := SPACE(2), cForma3 := "CH"
 
aAux := {}
aAux := Condicao(   (nLiquido + nVlJur)     , cCodPagto , MaFisRet(,"NF_VALIPI")    , M->UA_EMISSAO ,;
                    MaFisRet(,"NF_VALSOL")  , Nil       , Nil                       , nVlJur        )
                    
nParcelas := Len(aAux)

If nCont == 1
    cForma3 := cForma1
Else
    cForma3 := cForma2
EndIf
If Empty(cForma3)
    cForma3 := "CH"
EndIf
           
aParcelas := {}

For nCont := 1 To nParcelas
    Aadd(aParcelas,{ aAux[nCont][1], aAux[nCont][2], cForma3, Space(80),   0, space(1)  })      
Next nCont

Return