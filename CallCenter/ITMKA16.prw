#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA16				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Funcao para aplicar desconto por UF no pedido do call center			  	  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ITMKA16(_lAtu)
Local _aArea	:= GetArea()
Local cCliente	:= M->UA_CLIENTE
Local cLoja		:= M->UA_LOJA
Local cTabela	:= M->UA_TABELA
Local _cProd		:= ""
Local nDescont	:= 0
//Local cSegment	:= Posicione("SU7",4,xFilial("SU7")+__cUserID,"U7__SEGISP")
Local cSegment	:= Posicione("SA1",1,xFilial("SA1")+cCliente+cLoja,"A1__SEGISP"), _cEst := SA1->A1_EST
Local nPosTab	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"})
Local nPosVlr	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"})
Local nPosVIt	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM"})
Local nPosDig	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG"})
Local nPosQtd	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"})
Local _nPCod    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local nTotal	:= 0

Default _lAtu := .t.

_cProd  := IIF(ReadVar() == "UB_PRODUTO", M->UB_PRODUTO,aCols[n][_nPCod])

//Verifica se existe regra de desconto ou acrescimo para a UF
DbSelectArea("SB1")
DbSetOrder(1)
MsSeek(xFilial("SB1") + _cProd)

nTotal := aCols[n][nPosTab]
cSegment := M->UA__SEGISP //Jorge - Outubro/2014

//Se achar regra na Z13, ignora a regra da SZ0
DbSelectArea("Z13")
DbSetOrder(2)
If MsSeek(xFilial("Z13") + cSegment + _cEst + SB1->B1__SUBGRP + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2]))
    RestArea(_aArea)   
    Return nTotal
Else
    DbSetOrder(3)
    If MsSeek(xFilial("Z13") + cSegment + _cEst + SB1->B1_GRUPO + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2]))
        RestArea(_aArea)
        Return nTotal
    Else
        DbSetOrder(4)
        If MsSeek(xFilial("Z13") + cSegment + _cEst + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2])) .And. Empty(Z13->Z13_GRUPO) .And. Empty(Z13->Z13_SUBGRP)
            RestArea(_aArea)
            Return nTotal
        Else
            DbSetOrder(5)
            If MsSeek(xFilial("Z13") + cSegment + _cEst + SB1->B1__SUBGRP)
                RestArea(_aArea)
                Return nTotal
            Else
                DbSetOrder(6)
                If MsSeek(xFilial("Z13") + cSegment + _cEst + SB1->B1_GRUPO)
                    RestArea(_aArea)
                    Return nTotal
                Else
                    DbSetOrder(1)
                    If MsSeek(xFilial("Z13") + _cEst + cSegment + Space(TamSX3("B1_GRUPO")[1]) + Space(TamSX3("B1__SUBGRP")[1]))
                        RestArea(_aArea)
                        Return nTotal
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf
EndIf

If Select("TMP_SZ0") > 0
	TMP_SZ0->(dbCloseArea())
EndIf

_cQuery := "SELECT SA1.A1_COD, SA1.A1_LOJA, SA1.A1_EST, SZ0.Z0_DESC                                     "
_cQuery += "FROM " + retSqlname("SA1") + " SA1                                                          "
_cQuery += "INNER JOIN " + retSqlname("SZ0") + " SZ0 ON SZ0.Z0_FILIAL = '" + xFilial("SZ0") + "' AND    "
_cQuery += "SZ0.Z0_SEGISP = '" + cSegment + "' AND                                                      "
_cQuery += "SZ0.Z0_UF = SA1.A1_EST AND                                                                  "
_cQuery += "SZ0.D_E_L_E_T_ = ' '                                                                        "
_cQuery += "WHERE SA1.D_E_L_E_T_ = ' ' AND                                                              "
_cQuery += "SA1.A1_COD = '" + cCliente + "' AND                                                         "
_cQuery += "SA1.A1_LOJA = '" + cLoja + "'                                                               "
_cQuery := ChangeQuery(_cQuery)
TCQUERY _cQuery NEW ALIAS "TMP_SZ0"  	

nTotal := aCols[n][nPosTab]
if(TMP_SZ0->Z0_DESC != NIL)
	nTotal := Round(nTotal - nTotal * (TMP_SZ0->Z0_DESC/100),2)
	If _lAtu
//		aCols[n][nPosTab] := nTotal
		aCols[n][nPosVIt] := nTotal * aCols[n][nPosQtd]
		aCols[n][nPosVlr] := nTotal
		aCols[n][nPosDig] := nTotal
	EndIf
EndIf                           

TMP_SZ0->(dbCloseArea())           

RestArea(_aArea)
	
Return nTotal