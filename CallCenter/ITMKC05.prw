#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC05  | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Retorna o preço de tabela do produto                                                |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/
		
User Function ITMKC05(_cProd,_cEst,_cCodTab,_cTipo,_cEstTab,lHelp)
Local _cSQL := _cTab := "", _nPreco := _nDesc := 0, _aArea := GetArea(), _lAchou := .f.
Default _cEstTab := " "
Default lHelp	:= .T.

_cTab := GetNextAlias()
_cSQL := "Select DA1_PRCVEN,DA1__PREC2,DA1__PREC3,DA1__PREC4 From " + RetSqlName("DA1") + " A1 "
_cSQL += "Where DA1_FILIAL = '" + xFilial("DA1") + "' And DA1_CODPRO = '" + _cProd + "' And "
If GetMv("MV__TMKREV") //Indica se a regra de preço para revendedor está ativa
	If _cEstTab $ Alltrim(GetMv("MV__TABPUF")) .And. _cTipo != "R" .And. !Empty(_cEstTab) .And. Val(U_SETSEGTO()) == 1
		_cSQL += "DA1_ESTADO = '" + _cEstTab + "' And "
		//_cEstTab := _cEst
	Else
		_cSQL += "DA1_ESTADO = ' ' And "
		_cEstTab := " "
	EndIf
Else
	If _cEstTab $ Alltrim(GetMv("MV__TABPUF")) .And. !Empty(_cEstTab) .And. Val(U_SETSEGTO()) == 1
		_cSQL += "DA1_ESTADO = '" + _cEstTab + "' And "
	Else
		_cSQL += "DA1_ESTADO = ' ' And "
		_cEstTab := " "
	EndIf
EndIf
_cSQL += "DA1_DATVIG = "
_cSQL +=	"(Select MAX(DA1A.DA1_DATVIG) From " + RetSqlName("DA1") + " DA1A "
_cSQL += 		"Where DA1A.DA1_FILIAL = '" + xFilial("DA1") + "' And DA1A.DA1_CODPRO = '" + _cProd + "' And "
_cSQL +=				"DA1A.DA1_DATVIG <= '" + DTOS(Date()) + "' And "
_cSQL +=				IIF(_cEstTab $ Alltrim(GetMv("MV__TABPUF")) .And. !Empty(_cEstTab) ,"DA1A.DA1_ESTADO = '" + _cEstTab + "' ","DA1A.DA1_ESTADO = ' ' ")
_cSQL +=				 " And DA1A.D_E_L_E_T_ = ' ' )"
_cSQL += " And A1.D_E_L_E_T_ = ' ' "
_cSQL := ChangeQuery(_cSQL)
 
If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)

DbSelectArea(_cTab)
DbGoTop()

If !Eof()
	If _cCodTab == "001"
		_nPreco := (_cTab)->DA1_PRCVEN
	ElseIf _cCodTab == "002"
		_nPreco := (_cTab)->DA1__PREC2
	ElseIf _cCodTab == "003"
		_nPreco := (_cTab)->DA1__PREC3
	ElseIf _cCodTab == "004"
		_nPreco := (_cTab)->DA1__PREC4		
	EndIf
EndIf

DbSelectArea(_cTab)
DbCloseArea()

RestArea(_aArea)

If _nPreco <= 0
	_nPreco := 0
	If lHelp
		Help( Nil, Nil, "PRCITEM", Nil, "Preco nao localizado para este produto", 1, 0 )
    EndIf
//ElseIf (!(_cEst $ Alltrim(GetMv("MV__TABPUF")))  .And. _cTipo != "R") .Or. (!(_cEst $ Alltrim(GetMv("MV__ESTFAB"))) .And. _cTipo != "R")
ElseIf !(_cEst $ Alltrim(GetMv("MV__TABPUF")))
	//Verifica se existe regra de desconto ou acrescimo para a UF
	DbSelectArea("SB1")
	DbSetOrder(1)
	MsSeek(xFilial("SB1") + _cProd)
	
	DbSelectArea("Z13")
	DbSetOrder(2)
	If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + _cEst + SB1->B1__SUBGRP + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2])) 	
		_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
		
		//Valor negativo, indica reajuste
		If Z13->Z13_REAJUS < 0
			_nPreco := _nPreco + (_nPreco * (_nDesc/100))
		Else
			//Desconto
			_nPreco := _nPreco - (_nPreco * (_nDesc/100))
		EndIf
	Else
		DbSetOrder(3)
		If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + _cEst + SB1->B1_GRUPO + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2]))
			_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
			
			//Valor negativo, indica reajuste
			If Z13->Z13_REAJUS < 0
				_nPreco := _nPreco + (_nPreco * (_nDesc/100))
			Else
				//Desconto
				_nPreco := _nPreco - (_nPreco * (_nDesc/100))
			EndIf
		Else
			DbSetOrder(4)
			If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + _cEst + StrZero(SB1->B1_IPI,TamSX3("Z13_INDALQ")[1],TamSX3("Z13_IPI")[2])) .And. Empty(Z13->Z13_GRUPO) .And. Empty(Z13->Z13_SUBGRP)
				_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
				
				//Valor negativo, indica reajuste
				If Z13->Z13_REAJUS < 0
					_nPreco := _nPreco + (_nPreco * (_nDesc/100))
				Else
					//Desconto
					_nPreco := _nPreco - (_nPreco * (_nDesc/100))
				EndIf
			Else
				DbSetOrder(5)
				If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + _cEst + SB1->B1__SUBGRP)
					_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
					
					//Valor negativo, indica reajuste
					If Z13->Z13_REAJUS < 0
						_nPreco := _nPreco + (_nPreco * (_nDesc/100))
					Else
						//Desconto
						_nPreco := _nPreco - (_nPreco * (_nDesc/100))
					EndIf
				Else
					DbSetOrder(6)
					If MsSeek(xFilial("Z13") + SB1->B1__SEGISP + _cEst + SB1->B1_GRUPO)
						_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
						
						//Valor negativo, indica reajuste
						If Z13->Z13_REAJUS < 0
							_nPreco := _nPreco + (_nPreco * (_nDesc/100))
						Else
							//Desconto
							_nPreco := _nPreco - (_nPreco * (_nDesc/100))
						EndIf
					Else
						DbSetOrder(1)
						If MsSeek(xFilial("Z13") + _cEst + SB1->B1__SEGISP + Space(TamSX3("B1_GRUPO")[1]) + Space(TamSX3("B1__SUBGRP")[1]))
							_nDesc := IIF(Z13->Z13_REAJUS < 0, Z13->Z13_REAJUS * -1,Z13->Z13_REAJUS)
							
							//Valor negativo, indica reajuste
							If Z13->Z13_REAJUS < 0
								_nPreco := _nPreco + (_nPreco * (_nDesc/100))
							Else
								//Desconto
								_nPreco := _nPreco - (_nPreco * (_nDesc/100))
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
EndIf

Return Round(_nPreco,2)

/*
+------------+----------+--------+------------------------------------------+-------+--------------+
| Programa:  | ITMKC05P | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Outubro/2014 |
+------------+----------+--------+------------------------------------------+-------+--------------+
| Descrição: | Calcula a deflação do item                                                          |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKC05P(_nRet)
Local _aArea := GetArea(), _nValor := 0, _nIPI := 0, _cTab := "", _lMVA := .f.
Local _nPrcDig := _nPrcTab := _nDesc1 := _nDesc2 := _nDescV := _nDescP := _nDescV := _nAlqExt := _nAlqInt := 0, _cProd := _cTes := ""
Local _nPTab := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"  }), _nVal1 := _nVal2 := _nVal3 := _nVal4 := _nFator := _nAIpi := 0
Local _nPDig := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" })
Local _nPDs2 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2"  })
Local _nPDs3 := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3"  })
Local _nPDsV := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCCP" })
Local _nPDsP := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP"  })
Local _nPUni := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT"  })
Local _nPTot := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local _nPTes := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_TES" 	   })
Local _nPCod := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" })
Local _nPQtd := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"   })
Local _nPPMx := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PEDMEX" })
Local _nPPIx := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__ITEMEX" })

//Força preço de tabela e digitado, para manter sempre o que for enviado pelo Webline
If (Type("lTk271Auto") <> "U" .AND. lTk271Auto)    
    If _nPTab > 0 .And. _nPDig > 0 .And. _nPPMx > 0 .And. _nPPIx > 0
        DbSelectArea("SZB")
        DbSetOrder(1)
        If !Empty(aCols[n][_nPPMx]) .And. !Empty(aCols[n][_nPPIx]) .And. DbSeek(xFilial("SZB") + aCols[n][_nPPMx] + aCols[n][_nPPIx])
            aCols[n][_nPTab] := SZB->ZB_PRCTAB
            If Type("M->UB_PRCTAB") <> "U"
                M->UB_PRCTAB := SZB->ZB_PRCTAB 
            EndIf
            
            aCols[n][_nPDig] := SZB->ZB_PRCDIG
            If Type("M->UB__PRCDIG") <> "U"
                M->UB__PRCDIG := SZB->ZB_PRCDIG 
            EndIf
        EndIf
    EndIf  
EndIf

_cProd	 := IIF("UB_PRODUTO" $ ReadVar(), M->UB_PRODUTO,aCols[n][_nPCod])
_cTes	 := IIF("UB_TES"     $ ReadVar(), M->UB_TES	   ,aCols[n][_nPTES])
_nPrcDig := IIF("UB__PRCDIG" $ ReadVar(), M->UB__PRCDIG,aCols[n][_nPDig])
_nPrcTab := IIF("UB_PRCTAB"  $ ReadVar(), M->UB_PRCTAB ,aCols[n][_nPTab])
_nDesc1  := IIF("UB__DESC2"  $ ReadVar(), M->UB__DESC2 ,aCols[n][_nPDs2])
_nDesc2  := IIF("UB__DESC3"  $ ReadVar(), M->UB__DESC3 ,aCols[n][_nPDs3])
_nDescP	 := IIF("UB__DESCP"  $ ReadVar(), M->UB__DESCP ,aCols[n][_nPDsP])
_nDescV  := aCols[n][_nPDsV]

//Rotina para calcular o preço unitário final
If _nPrcDig > _nPrcTab 
	_nValor := _nPrcDig
Else
	_nValor := _nPrcTab
EndIf

If _nDesc1 > 0
	_nValor := (_nValor - (_nValor  * (_nDesc1/100))) //Desconto 1
EndIf
If _nDesc2 > 0
	_nValor := (_nValor - (_nValor  * (_nDesc2/100))) //Desconto 2
EndIf

If _nDescP > 0
	_nValor := (_nValor - (_nValor  * (_nDescP/100))) //Desconto Promocional
EndIf

If _nDescV > 0
	_nValor := (_nValor - (_nValor  * (_nDescV/100))) //Desconto Vendedor (Capa)
EndIf

aCols[n][_nPUni] := Round(_nValor,2)

DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)

//Busca a aliquota de IPI que será aplicada
MaFisSave()
MaFisEnd()
MaFisIni(M->UA_CLIENTE,;                // 1-Codigo Cliente/Fornecedor
         M->UA_LOJA,;                   // 2-Loja do Cliente/Fornecedor
         "C",;                          // 3-C:Cliente , F:Fornecedor
         "N",;                          // 4-Tipo da NF
         M->UA_TIPOCLI,;                // 5-Tipo do Cliente/Fornecedor
         Nil,;
         Nil,;
         Nil,;
         Nil,;
         "MATA461")

MaFisAdd(_cProd,;                       // 1-Codigo do Produto ( Obrigatorio )
         _cTes,;                        // 2-Codigo do TES ( Opcional )
         aCols[n][_nPQtd],;             // 3-Quantidade ( Obrigatorio )
         aCols[n][_nPUni],;             // 4-Preco Unitario ( Obrigatorio )
         0,;                            // 5-Valor do Desconto ( Opcional )
         "",;                           // 6-Numero da NF Original ( Devolucao/Benef )
         "",;                           // 7-Serie da NF Original ( Devolucao/Benef )
         0,;                            // 8-RecNo da NF Original no arq SD1/SD2
         0,;                            // 9-Valor do Frete do Item ( Opcional )
         0,;                            // 10-Valor da Despesa do item ( Opcional )
         0,;                            // 11-Valor do Seguro do item ( Opcional )
         0,;                            // 12-Valor do Frete Autonomo ( Opcional )
         aCols[n][_nPTot],;             // 13-Valor da Mercadoria ( Obrigatorio )
         0)                             // 14-Valor da Embalagem ( Opcional )
        
_nItem := 1

_nAIpi := MaFisRet(_nItem,"IT_ALIQIPI")

MaFisEnd()
MaFisRestore()


//Calculo da deflação
If M->UA_TIPOCLI $ Alltrim(GetMv("MV_TPSOLCF")) .And. (SA1->A1_EST $ Alltrim(GetMv("MV__DEFEST"))) .And. (Alltrim(M->UA__SEGISP) $ Alltrim(GetMv("MV__DEFSEG"))) .And. M->UA__RESEST == "S" .And. SA1->A1__DESSUF != "1" //!(SA1->A1_CALCSUF $ "SI")

	//Busca MVA
	_cTab := GetNextAlias()
	_cSQL := "Select F7_FILIAL, F7_ALIQINT, F7_ALIQEXT, F7_ALIQDST, F7_MARGEM From " + RetSqlName("SF7") + " F7 "
	_cSQL += "Where F7_FILIAL = '" + M->UA__FILIAL + "' And F7_GRTRIB = '" + SB1->B1_GRTRIB + "' And F7_EST = '" + SA1->A1_EST + "' And "
	_cSQL +=	"F7_TIPOCLI = '" + M->UA_TIPOCLI + "' And F7_GRPCLI = '" + SA1->A1_GRPTRIB + "' And F7_MARGEM > 0 And F7.D_E_L_E_T_ = ' ' "
	_cSQL := ChangeQuery(_cSQL)
 
	If Select(_cTab) > 0
		DbSelectArea(_cTab)
		DbCloseArea()
	EndIf
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)
	
	DbSelectArea(_cTab)
	DbGoTop()
	
	If Eof()
		_cSQL := "Select F7_FILIAL, F7_ALIQINT, F7_ALIQEXT, F7_ALIQDST, F7_MARGEM From " + RetSqlName("SF7") + " F7 "
		_cSQL += "Where F7_FILIAL = '" + M->UA__FILIAL + "' And F7_GRTRIB = '" + SB1->B1_GRTRIB + "' And F7_EST = '" + SA1->A1_EST + "' And "
		_cSQL +=	"F7_TIPOCLI = '*' And F7_GRPCLI = '" + SA1->A1_GRPTRIB + "' And F7_MARGEM > 0 And F7.D_E_L_E_T_ = ' ' "
		_cSQL := ChangeQuery(_cSQL)
		
		If Select(_cTab) > 0
			DbSelectArea(_cTab)
			DbCloseArea()
		EndIf
		
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,_cSQL),_cTab,.T.,.T.)		
		
	EndIf
	
	DbSelectArea(_cTab)
	DbGoTop()
	
	//Calcula a deflação
	If !Eof()
		
		//Aliquota Externa
		If (_cTab)->F7_ALIQEXT > 0
			_nAlqExt := (_cTab)->F7_ALIQEXT
		Else
			If Empty(SA1->A1_INSCR) .Or. ("ISENT" $ SA1->A1_INSCR)
				_nAlqExt := GetMv("MV_ICMPAD")
			ElseIf SB1->B1_ORIGEM $ "1,2,3"
				_nAlqExt := 4
			ElseIf SA1->A1_EST $ GetMv("MV_NORTE")
				_nAlqExt := 7
			Else
				_nAlqExt := 12
			EndIf
		EndIf
		
		//Aliquota Interna
		If (_cTab)->F7_ALIQINT > 0
			_nAlqInt := (_cTab)->F7_ALIQINT
		Else
			If SB1->B1_PICM > 0
				_nAlqInt := SB1->B1_PICM
			Else
				_nAlqInt := GetMv("MV_ICMPAD")
			EndIf
		EndIf
		
		_nVal1 	:= (100 + _nAIpi) * (_cTab)->F7_MARGEM/100
		_nVal2 	:= 100 + _nAIpi + _nVal1
		_nVal3 	:= (_nVal2 * IIF((_cTab)->F7_ALIQDST > 0,(_cTab)->F7_ALIQDST,_nAlqInt)/100) - _nAlqExt
		_nVal4	:= 100 + _nAIpi + _nVal3
		_nFator := (100 + _nAIpi)/_nVal4
		_nValor := Round(_nValor,2)
		_nValor := IIF(_nAIpi = 0,_nValor * _nFator,(_nValor * _nFator)/((_nAIpi/100)+1))
		
		aCols[n][_nPUni] := Round(_nValor,4)
		_lMVA := .t.
	EndIf
	
	If Select(_cTab) > 0
		DbSelectArea(_cTab)
		DbCloseArea()
	EndIf

EndIf

//Retira o IPI do preço
//If !_lMVA .And. M->UA__RESEST == "S" .And. !(SA1->A1_CALCSUF $ "SI")
If !_lMVA .And. M->UA__RESEST == "S" .And. SA1->A1__DESSUF != "1"
	//Verifica se deve retirar IPI
	If Posicione("SF4",1,xFilial("SF4") + _cTes,"F4_IPI") == "S" .And. Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_IPI") > 0 .And. Alltrim(SB1->B1_ORIGEM) $ Alltrim(GetMv("MV__IPIORI"))
		_nIPI := 1 + (SB1->B1_IPI/100)
		_nValor := (_nValor /_nIpi) //Desconto IPI
		aCols[n][_nPUni] := Round(_nValor,2) //Round(_nValor,4)
	EndIf
ElseIf SA1->A1__DESSUF == "1" .And. Posicione("SB1",1,xFilial("SB1") + _cProd,"B1_IPI") > 0 .And. ("UB__QTDSOL" $ ReadVar()) .And. Alltrim(SB1->B1_ORIGEM) $ Alltrim(GetMv("MV__IPIORI")) .And. SubStr(SB1->B1_GRTRIB,5,1) == "1" /*.And. (SA1->A1_CALCSUF $ "SI")*/
    MsgInfo("Cliente possui desconto SUFRAMA. Aliquota de IPI do produto " + Alltrim(Str(SB1->B1_IPI)) + "%"," ")
EndIf

aCols[n][_nPTot] := Round((aCols[n][_nPUni] * aCols[n][_nPQtd]),2)
Eval(bGDRefresh)
Eval(bRefresh)

MaFisRef("IT_VALMERC","TK273",aCols[n][_nPTot])
Eval(bGDRefresh)
Eval(bRefresh)

RestArea(_aArea)
Return _nRet