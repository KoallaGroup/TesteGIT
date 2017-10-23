#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | MT140TOK | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2015 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Ponto de entrada no OK da Pre-nota                                                  |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function MT140TOK()                                                                           

    local _lRet         :=  .T.
    local _aPedidos     := {}
    local _cPosProc     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1__CODPRO" })
    local _cPosProd     := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_COD" })
    local _cPosQuant    := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_QUANT" })
    local _cPosPedido   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_PEDIDO" })
    local _cPosItemPC   := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_ITEMPC" })

    
    for x:=1 to len(aCols)                 
            
        _cCodProc := aCols[x][_cPosProc]

        If !Empty(_cCodProc)
            _cQuery := "SELECT * "
            _cQuery += "FROM " + retSqlName("SZ3") + " SZ3 "
            _cQuery += "WHERE SZ3.D_E_L_E_T_ = ' ' "
            _cQuery += "  AND Z3_CODIGO = '" + _cCodProc + "' "
            _cQuery += "  AND Z3_FILIAL = '" + cFilAnt + "' "
            _cQuery += "  AND Z3_PRODUTO = '" + aCols[x][_cPosProd] + "' "
      
            TcQuery _cQuery New Alias "TRB_SZ3"
    
            while ! TRB_SZ3->(eof())
                if TRB_SZ3->Z3_QTDEMBA - TRB_SZ3->Z3_QTDESEM  >= aCols[x][_cPosQuant] //.and. ASCAN(_aPedidos, TRB_SZ3->Z3_PEDIDO) == 0
                
                    aCols[x][_cPosPedido] := TRB_SZ3->Z3_PEDIDO
                    aCols[x][_cPosItemPC] := TRB_SZ3->Z3_ITPEDCO
                
    //              aadd(_aPedidos, TRB_SZ3->Z3_PEDIDO)
                endif
            
                TRB_SZ3->(dbSkip())
            enddo       
            
            TRB_SZ3->(dbCloseArea())
        EndIf

    next x  

Return _lRet

Return .T.