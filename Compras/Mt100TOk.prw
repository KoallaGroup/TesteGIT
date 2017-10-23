#include "Protheus.ch"
#include "Topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : MT100TOK			  		| 		Janeiro de 2015				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi																|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para validação da Nota de Entrada										|
|-------------------------------------------------------------------------------------------------------|	
*/

user function MT100TOK()

	local _lRet			:=	.T.
	local _aPedidos		:= {}
	local _cPosProc		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1__CODPRO" })
	local _cPosProd		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_COD" })
	local _cPosQuant	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_QUANT" })
	local _cPosPedido	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_PEDIDO" })
	local _cPosItemPC	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_ITEMPC" })
	Local _nPBI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASIMP5"}), _nPBCF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASCOF"})
	Local _nPAI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_ALQIMP5"}), _nPACF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQCOF"})
	Local _nPVI5 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALIMP5"}), _nPVCF := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VALCOF"})
	Local _nPBI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_BASIMP6"}), _nPBPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__BASPIS"})
	Local _nPAI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_ALQIMP6"}), _nPAPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__ALQPIS"})
	Local _nPVI6 := aScan(aHeader, { |x| AllTrim(x[2]) == "D1_VALIMP6"}), _nPVPS := aScan(aHeader, { |x| AllTrim(x[2]) == "D1__VALPIS"}) 	


    If _cPosProc == 0
        Return _lRet
    EndIf
 	
    for x:=1 to len(aCols)

		_cCodProc := aCols[x][_cPosProc]

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
		    	Exit
		    			    
//		    	aadd(_aPedidos, TRB_SZ3->Z3_PEDIDO)
		    endif
		
			TRB_SZ3->(dbSkip())
		enddo		
		
		TRB_SZ3->(dbCloseArea())

	next x	

Return _lRet
