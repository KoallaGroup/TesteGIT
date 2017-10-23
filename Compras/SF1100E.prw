/*
|-----------------------------------------------------------------------------------------------|
|	Programa : SF1100E			  		| 	Julho de 2014					  					               |
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi					        					            |
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada na exclusão da NF Entrada	    							  	         |
|-----------------------------------------------------------------------------------------------|
*/

User Function SF1100E()

	local _aArea 	:= getArea()
	Local _aSD3		:= SD3->(GetArea())
	local _cNota	:= "", _lAtu := .f., _cDocCod := ""
	local _cSerie	:= "", _cPA9 := "", _nExc := 0
	local _cForn	:= ""
	local _cLoja	:= ""
	Local _cPedido	:= ""
	Local _cItPed	:= ""
	Local _nQtde	:= ""
	Local _nValor	:= ""
//	Local _lValid	:= .T.

	If AtIsRotina("A140ESTCLA")	
		//Jorge H - Anadi - Maio/2015
		Return
	EndIf
	
	PRIVATE lMsErroAuto := .F.
	PRIVATE _aProd	  	:= {}
	
	_cNota 	:= SF1->F1_DOC
	_cSerie	:= SF1->F1_SERIE
	_cForn	:= SF1->F1_FORNECE
	_cLoja	:= SF1->F1_LOJA

    //Exclui dados das tabelas PA8 e PA9 (integração com a Capri)
    If !Empty(SF1->F1__REFEXT) .And. !Empty(SF1->F1__DOCCOD)
        DbSelectArea("PA8")
        DbSetOrder(2)
        If DbSeek(xFilial("PA8") + PADR(SF1->F1__REFEXT,TamSX3("PA8_ESPREF")[1]))
            While !Eof() .And. Alltrim(PA8->PA8_ESPREF) == Alltrim(SF1->F1__REFEXT)                
                
                //Apaga a PA9
                _cPA9 := "Update " + RetSqlName("PA9")
                _cPA9 += " Set D_E_L_E_T_ = '*' "
                _cPA9 += "Where PA9_FILCOD = " + Alltrim(Str(PA8->PA8_FILCOD)) + " And "
                _cPA9 +=    "PA9_DOCTIP = " + Alltrim(Str(PA8->PA8_DOCTIP)) + " And "
                _cPA9 +=    "PA9_DOCCOD = " + Alltrim(Str(PA8->PA8_DOCCOD)) + " And D_E_L_E_T_ = ' ' "
                _nExc := TCSQLExec(_cPA9)
                
                If _nExc < 0
                    DbSelectArea("PA9")
                    DbSetOrder(1)
                    DbGoTop()                    
                    If MsSeek(xFilial("PA9") + Str(PA8->PA8_FILCOD,10,0) + Str(PA8->PA8_DOCCOD,10,0))
                        While !Eof() .And. PA9->PA9_FILIAL == xFilial("PA9") .And. PA8->PA8_FILCOD == PA9->PA9_FILCOD .And. PA8->PA8_DOCCOD == PA9->PA9_DOCCOD
                            
                            While !Reclock("PA9",.F.)
                            EndDo
                            DbDelete()
                            MsUnlock()
                            
                            DbSkip()
                        EndDo
                    EndIf                    
                Else
                    TCRefresh("PA9")
                EndIf
                
                //Apaga a PA8
                DbSelectArea("PA8")
                While !Reclock("PA8",.f.)
                EndDo
                DbDelete()
                MsUnlock()
                
                DbSkip()
            EndDo
        EndIf
    EndIf

	DbSelectArea("SD3")
	DbOrderNickName("SD3NF")	//D3_FILIAL+D3__DOC+D3__SERIE+D3__FORNEC+D3__LOJA+D3_COD+D3__ITEM
	If DbSeek(xFiliaL("SD3") + _cNota + _cSerie + _cForn + _cLoja)
		
		//Begin Transaction
		
		While !(eof()) .and. SD3->D3_FILIAL == xFilial("SD3") .And. SD3->D3__DOC == _cNota .and. SD3->D3__SERIE == _cSerie .and.; 
							 SD3->D3__FORNEC == _cForn .and. SD3->D3__LOJA == _cLoja

			If SD3->D3_ESTORNO == "S"
				DbSkip()
				Loop
			EndIf

            /*
			dbSelectArea("SX1")
			dbSetOrder(1)
			If dbSeek(PADR("MTA300",Len(SX1->X1_GRUPO)))
				While alltrim(SX1->X1_GRUPO) == 'MTA300'
					While !reclock("SX1", .F.)
					EndDo
					if SX1->X1_ORDEM == "01"
						SX1->X1_CNT01 := SD3->D3_LOCAL
					elseif SX1->X1_ORDEM == "02"
						SX1->X1_CNT01 := SD3->D3_LOCAL
					elseif SX1->X1_ORDEM == "03"
						SX1->X1_CNT01 := SD3->D3_COD
					elseif SX1->X1_ORDEM == "04"
						SX1->X1_CNT01 := SD3->D3_COD
					elseif SX1->X1_ORDEM == "05"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "06"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "07"
						SX1->X1_PRESEL := 2
					elseif SX1->X1_ORDEM == "08"
						SX1->X1_PRESEL := 2
					endif		
				
					SX1->(dbSkip())
				EndDo
			EndIf
            			
			Reclock("SD3",.F.)
			DbDelete()
			SD3->(Msunlock())
		            
    		pergunte("MTA300", .f.)    			
			mv_par01 := SD3->D3_LOCAL
			mv_par02 := SD3->D3_LOCAL
			mv_par03 := SD3->D3_COD
			mv_par04 := SD3->D3_COD
			mv_par05 := 2
			mv_par06 := 2
			mv_par07 := 2
			mv_par08 := 2
	        
			_aFil := {}
			aadd(_aFil, {.T., xFilial("SD3")})
			
			MATA300 (.T., _aFil)
            */
            
            _aProd := {}
			_aSD3 := SD3->(GetArea())

            lMsErroAuto := .F.
			aAdd(_aProd,{{"D3_FILIAL"	,SD3->D3_FILIAL , NIL},;
						 {"D3_COD"		,SD3->D3_COD	, NIL},;
						 {"D3_LOCAL"	,SD3->D3_LOCAL	, NIL},;
						 {"D3_NUMSEQ"	,SD3->D3_NUMSEQ , NIL},;
						 {"D3_CF"		,SD3->D3_CF     , NIL},;
						 {"D3_TM"		,SD3->D3_TM     , NIL},;
						 {"INDEX"		,3				, NIL} })
			
			MSExecAuto({|x,y| MATA240(x,y)}, _aProd[1], 5) // Operacao de estorno do movimento interno (SD3)
			
			If lMsErroAuto
				MostraErro()
				DisarmTransaction()
			EndIf

            RestArea(_aSD3)

			DbSelectArea("SD3")
			DbSkip()			
		enddo
		
//		End Transaction

	EndIf

	RestArea(_aArea)
	
return //_lValid
