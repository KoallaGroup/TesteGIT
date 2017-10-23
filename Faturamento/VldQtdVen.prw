#Include 'Protheus.ch'

/*
+------------+-----------+--------+--------------------+-------+----------------+
| Programa:  | VldQtdVen | Autor: | Rogério Alves      | Data: | Fevereiro/2015 |
+------------+-----------+--------+--------------------+-------+----------------+
| Descrição: | Valida Saldo em estoque                                          |
+------------+------------------------------------------------------------------+
| Uso:       | Isapa                                                            |
+------------+------------------------------------------------------------------+
*/

User Function VldQtdVen()
Local _lRet 	:= .T., _aArea := GetArea()
Local _nSaldo	:= 0, _nQtdCross := 0
Local _cFil 	:= ""
Local _cProd 	:= ""
Local _cLocal	:= ""
Local _nQtdVen	:= 0
Local _nPosProd	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_PRODUTO" })
Local _nPosLoc	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_LOCAL" 	 })
Local _nPosTES	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_TES" 	 })
Local _nPCross  := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6__CROSSD" })
Local _nPProcI  := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6__PROIMP" })
Local _nPItCro  := aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6__ITCROS" })
Local _nPosIte	:= aScan(aHeader,{|x| UPPER(AllTrim(x[2]))=="C6_ITEM" 	 })

Private cEOL    := CHR(13)+ CHR(10) //Final de Linha

If funname() == 'MATA410'

	if empty(aCols[n][_nPosTES])
	                                                          
	    M->C6_QTDVEN := 0
		msgAlert ("Preencha primeiro a TES para esse item !!")
		_lRet := .F.
	
	else                            

		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial("SF4") + aCols[n][_nPosTES])
		
		if SF4->F4_ESTOQUE == "S"
			
			_cFil 		:= cFilAnt
			_cProd 		:= aCols[n][_nPosProd]
			_cLocal		:= aCols[n][_nPosLoc]
			_nQtdVen	:= M->C6_QTDVEN
			
			_nSaldo	:= U_xSldProd(_cFil,_cProd, _cLocal,,,M->C5_NUM,aCols[n][_nPosIte]) 			
			
			//Se for um pedido de cross, a quantidade do cross compõe o saldo disponível do item
			If !Empty(aCols[n][_nPCross]) .And. !Empty(aCols[n][_nPProcI]) .And. !Empty(aCols[n][_nPItCro])
				DbSelectArea("SZX")
				DbSetOrder(1)
				If DbSeek(xFilial("SZX") + aCols[n][_nPCross] + aCols[n][_nPProcI] + aCols[n][_nPItCro])
					_nQtdCross := SZX->ZX_SALDO
				EndIf
			EndIf
			
			_nSaldo += _nQtdCross
			
			If _nQtdVen > _nSaldo
				_lRet := .F.
				MsgAlert(	"Produto " + _cProd + cEOL +;
							"Saldo Insuficiente  " + cEOL +;
							"Saldo disponível : " + Alltrim( Str( _nSaldo ) ) )
			Endif
	
		endif		

	endif		
EndIf

RestArea(_aArea)
Return _lRet