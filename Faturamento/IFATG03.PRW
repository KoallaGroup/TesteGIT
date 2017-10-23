#Include "rwmake.ch"
#Include "Protheus.ch"

/*
+----------+---------+-------+-------------------------------------------+------+------------+
|Programa  | IFATG03 | Autor | Jorge Henrique Alves - Anadi Consultoria  | Data | Julho/2015 |
+----------+---------+-------+-------------------------------------------+------+------------+
|Descricao | Gatilhos utilizados no pedido de venda, para transferencia entre filiais        |
+----------+---------------------------------------------------------------------------------+
|Uso       | Isapa                                                                           |
+----------+---------------------------------------------------------------------------------+
*/

//Determina o armazém para pedidos de transferência e devolução de compras
User Function IFATG03()
Local _nPPrd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO" }), _lZ08 := .f., _cArm := "" 
Local _cProd := IIF("C6_PRODUTO" $ ReadVar(),M->C6_PRODUTO,aCols[n][_nPPrd]), _nQLoc01 := _nQLoc02 := 0
Local _nPItm := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_ITEM" })

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1") + _cProd)

_cArm := SB1->B1_LOCPAD

If Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG")
    If M->C5_TIPO == "N"
                
        DbselectArea("Z08")
        DbSetOrder(1)
        If DbSeek(xFilial("Z08") + _cProd)
            _lZ08 := .t.
        Else
            DbSetOrder(2)
            If DbSeek(xFilial("Z08") + SB1->B1_GRUPO)
                _lZ08 := .t.
            EndIf
        EndIf
        
        //If (_lZ08 .Or. Alltrim(SB1->B1_ORIGEM) $ Alltrim(GetMv("MV__ARMORI"))) .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG")        	
        If _lZ08 .And. Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG")        	
		    DbSelectArea("SA1")
		    DbSetOrder(1)
		    DbSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI)

			_nQLoc01 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),,M->C5_NUM,aCols[n][_nPItm])
			_nQLoc02 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),,M->C5_NUM,aCols[n][_nPItm])
			
			If _nQLoc02 > 0
				_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
			ElseIf _nQLoc01 > 0
				_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
			EndIf 
		    
		    //Se destino for filial informada no MV__ARMSAI, prioriza a saída sempre do armazém 02
		    /*
		    DbSelectArea("SZE")
		    DbSetOrder(2)
		    If DbSeek(SA1->A1_CGC) .And. Alltrim(SZE->ZE_CODFIL) $ Alltrim(GetMv("MV__ARMSAI"))        	
				_nQLoc01 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),,M->C5_NUM,aCols[n][_nPItm])
				_nQLoc02 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),,M->C5_NUM,aCols[n][_nPItm])
				
				If _nQLoc02 > 0
					_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
				ElseIf _nQLoc01 > 0
					_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
				EndIf 
			Else
				_nQLoc01 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),,M->C5_NUM,aCols[n][_nPItm])
				_nQLoc02 := U_xSldProd(cFilAnt,_cProd,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]),,M->C5_NUM,aCols[n][_nPItm])
				
				If _nQLoc01 > 0
					_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
				ElseIf _nQLoc02 > 0
					_cArm := Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
				EndIf
			EndIf
			*/
        EndIf
        
    EndIf
EndIf

Return _cArm


//Determina a CST, de acordo com a origem do produto
User Function IFATG03C()
Local _nPPrd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_PRODUTO" })
Local _nPTES := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_TES" })
Local _nPArm := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_LOCAL" })
Local _nPCST := ASCAN(aHeader, { |x| AllTrim(x[2]) == "C6_CLASFIS" })
Local _lZ08  := .f., _cArm := aCols[n][_nPArm], _cSit := aCols[n][_nPCST], _lZ08 := .f. 
Local _cProd := IIF("C6_PRODUTO" $ ReadVar(),M->C6_PRODUTO,aCols[n][_nPPrd]), _cTes := IIF("C6_TES" $ ReadVar(),M->C6_TES,aCols[n][_nPTES]) 

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1") + _cProd)

If Alltrim(SB1->B1__SEGISP) $ GetMv("MV__ARMSEG")
    If M->C5_TIPO == "N"

        DbselectArea("Z08")
        DbSetOrder(1)
        If DbSeek(xFilial("Z08") + _cProd)
            _lZ08 := .t.
        Else
            DbSetOrder(2)
            If DbSeek(xFilial("Z08") + SB1->B1_GRUPO)
                _lZ08 := .t.
            EndIf
        EndIf
        
        DbSelectArea("SF4")
        DbSetOrder(1)
        DbSeek(xFilial("SF4") + _cTes)
        
	    DbSelectArea("SA1")
	    DbSetOrder(1)
	    DbSeek(xFilial("SA1") + M->C5_CLIENTE + M->C5_LOJACLI)
	    
	    //Se destino for filial informada no MV__ARMSAI e Filial Origem está no parametro MV__ARMTRN
	    //A regra de CST é diferente
	    DbSelectArea("SZE")
	    DbSetOrder(2)
	    If DbSeek(SA1->A1_CGC) .And. Alltrim(SZE->ZE_CODFIL) $ Alltrim(GetMv("MV__ARMSAI")) .And. _lZ08 .And. cFilAnt $ Alltrim("MV__ARMTRN")
	    	_cSit := Alltrim(GetMv("MV__ARMCST")) + SF4->F4_SITTRIB
	    ElseIf _lZ08
        	If _cArm == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
        		_cSit := "1" + SF4->F4_SITTRIB  
        	ElseIf _cArm == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
        		_cSit := "2" + SF4->F4_SITTRIB
        	Else
        		_cSit := Alltrim(SB1->B1_ORIGEM) + SF4->F4_SITTRIB
        	EndIf
	    EndIf
        /*
        If _cArm $ Alltrim(GetMv("MV__ARMCOD")) .And. _lZ08
            _cSit := Alltrim(GetMv("MV__ARMCST")) + SF4->F4_SITTRIB
        ElseIf _lZ08
        	If _cArm == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1])
        		_cSit := "1" + SF4->F4_SITTRIB  
        	ElseIf _cArm == Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2])
        		_cSit := "2" + SF4->F4_SITTRIB
        	Else
        		_cSit := Alltrim(SB1->B1_ORIGEM) + SF4->F4_SITTRIB
        	EndIf              
        EndIf
        */
    EndIf
EndIf

Return _cSit