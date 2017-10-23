#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKEST1 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Janeiro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | ALimenta a tabela de reserva em tempo real, de acordo com os parametros recebidos   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKEST1(_cFil,_cPed,_cItem,_cProd,_cArmz,_nQtd,_cOper)
Local _cSQL := "", _aArea := GetArea(), _nOK := 0
Default _cFil := "", _cPed := "", _cItem := "" , _cProd := "", _cArmz := "", _nQtd := 0, _cOper := ""

If _cOper == "I"
	DbSelectArea("SUA")
	DbSetOrder(1)
	If DbSeek(_cFil + _cPed)
		If (!Empty(SUA->UA_DOC) .Or. Val(SUA->UA__STATUS) >= 9)
			_cOper := "E"
			_cItem := ""
		EndIf
	EndIf
EndIf

If _cOper == "I"
	
	DbSelectArea("Z10")
	DbSetOrder(1)
	If DbSeek(_cFil + _cPed + _cItem)
		reclock("Z10",.F.)
		Z10->Z10_PROD := _cProd
		Z10->Z10_QTD  := _nQtd
		Z10->Z10_LOCAL := _cArmz
		Z10->Z10_DATA := DATE()
		Z10->Z10_HORA := SUBSTR(TIME(),1,5)
		MsUnlock()
	Else
		RECLOCK("Z10",.T.)
		Z10->Z10_FILIAL := _cFil
		Z10->Z10_CODSUA := _cPed
		Z10->Z10_PROD   := _cProd
		Z10->Z10_LOCAL  := _cArmz
		Z10->Z10_ITEM   := _cItem
		Z10->Z10_QTD    := _nQtd
		Z10->Z10_DATA   := DATE()
		Z10->Z10_HORA   := SUBSTR(TIME(),1,5)
		MSUNLOCK()
	EndIf
	
ElseIf _cOper == "E"
	
	If !Empty(_cItem)
		DbSelectArea("Z10")
		DbSetOrder(1)
		If DbSeek(_cFil + _cPed + _cItem)
			While !Eof() .And. (Z10->Z10_FILIAL + Z10->Z10_CODSUA + Z10->Z10_ITEM) == (_cFil + _cPed + _cItem)
			
				RECLOCK("Z10",.F.)
				Z10->(DBDELETE())
				Z10->(MSUNLOck())
				//COMMIT
				Z10->(DBSKIP())				
			
			EndDo
		EndIf
	Else
		
        _cSQL := "Update " + RetSqlName("Z10") 
        _cSQL += " Set D_E_L_E_T_ = '*' "
        _cSQL += "Where Z10_FILIAL = '" + _cFil + "' And Z10_CODSUA = '" + _cPed + "' And D_E_L_E_T_ = ' ' "        
        _nOK := TcSqlExec(_cSQL)
             
        If _nOK < 0
            DbSelectArea("Z10")
            DbSetOrder(1)
            If DbSeek(_cFil + _cPed)
                While !Eof() .And. (Z10->Z10_FILIAL + Z10->Z10_CODSUA) == (_cFil + _cPed)
                    While !Reclock("Z10",.F.)
                    EndDo
                    DbDelete()
                    MsUnLOck()

                    Z10->(DBSKIP())                
                EndDo
            EndIf
        Else
            TCRefresh("Z10")
        EndIf

	EndIf
EndIf

RestArea(_aArea)
Return



//Validador para não permitir alteração de alguns campos
User Function ITMKEST2()
Local _lRet := .t.

If M->UA_OPER != "1"
	DbSelectArea("Z10")
	DbSetOrder(1)
	If DbSeek(M->UA__FILIAL + M->UA_NUM)
		_lRet := .f.
		Help( Nil, Nil, "VALIDALT", Nil, "Pedido ja possui reserva. Alteração nao permitida", 1, 0 ) 
	EndIf
EndIf

Return _lRet