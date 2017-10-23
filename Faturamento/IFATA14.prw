#INCLUDE "PROTHEUS.CH"
#include "topconn.ch"
#Include "TMKDEF.CH"
#DEFINE CRLF Chr(13) + Chr(10)                                                                                           

/*
+-------------+-----------+--------+------------------------------+-------+-----------+
| Programa:   | IFATA14   | Autor: | Rubens Cruz - Anadi		  | Data: | Ago/2014  |
+-------------+-----------+--------+------------------------------+-------+-----------+
| Descrição:  | Rotina para Gravacao de Criticas Comercial/Financeira no pedido		  |
+-------------+-----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			          |
+-------------+-----------------------------------------------------------------------+
| Parametros: | _cNum := Numero do pedido de venda do CallCenter					  |
+-------------+-----------------------------------------------------------------------+
*/

User Function IFATA14(_cNum,_lAuto)
Local lRet		:= .F.
Local _aArea	:= GetArea()
Local _aAreaZ05	:= Z05->(GetArea())
Local _aAreaSE4	:= SE4->(GetArea())
Local nMinPed	:= GetMV("MV__MINPED")
Local nMaxPed	:= GetMV("MV__MAXPED")
Local nPerPed	:= GetMV("MV__PERPED")
Local nPrazo	:= SuperGetMV("MV__MAXPRA",,30)
Local nCliInat	:= GetMV("MV__CLIINA")
Local cBlqFin	:= GetMV("MV__BLQFIN")
Local nMaxDes	:= GetMV("MV__MAXDES")
//Local cConApres	:= GetMV("MV__CONAPR")
Local _lCredLoj	:= (GetMV("MV_CREDCLI") == 'L')

Local lCom		:= .F.
Local lFin		:= .F.
Local _cQuery	:= ""
Local _aParcela	:={}
Local nOpcao	:= 0
Local NI 		:= 0
Local nTOTDIA 	:= 0
Local nTOTPRA 	:= 0
Local nDMaxAti	:= 0
Local nDMinAti	:= 0
Local nCMaxAti	:= 0
Local nCMinAti	:= 0
Local nPrecPor	:= 0
Local nPrazomed	:= posicione("SE4",1,xFilial("SE4")+M->UA_CONDPG,"E4__PRAZOM")
Local cItem		:= space(TAMSX3("Z05_ITEM")[1])
Local _nPosCod	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRODUTO" 	})
Local _nCodItem	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_ITEM" 		})
Local _nPosVlr	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM"	})
Local _nPosDes1	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_DESC" 		})
Local _nPosDes2	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC2" 	})
Local _nPosDes3	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESC3" 	})
Local _nPosProm := ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__DESCP"    })
Local _nPosCom	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__COMIS1" 	})
Local _nPosTes	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_TES" 		})
Local _nPosQt	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_QUANT"		})
Local _nPosLoc	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_LOCAL"		})
Local _nPosTab	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_PRCTAB"	})
Local _nPosDig	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__PRCDIG" 	})
Local _nPosPun	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VRUNIT" 	})
Local aBloq		:= {}, _nPerCom := 0

Local cSepNeg   := If("|"$MV_CRNEG,"|",","), cSepProv  := If("|"$MVPROVIS,"|",","), cSepRec := If("|"$MVRECANT,"|",",")

Private aCrit	:= {}              

Default _lAuto	:= .F.

DbSelectArea("SA3")
DbSetOrder(1)
DbSeek(xFilial("SA3") + M->UA_VEND)

//motivo 80 - PRAZO MEDIO ACIMA DO PERMITIDO                              
If(nPrazomed > nPrazo)
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"080",;
	posicione("Z04",1,xFilial("Z04")+"080","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf

//motivo 94 - PEDIDO CONTRA-APRESENTA€ÇO                                  
If(Alltrim(SE4->E4_COND) == '0')
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"094",;
	posicione("Z04",1,xFilial("Z04")+"094","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf

If Select("TRB_SUB") > 0
	DbSelectArea("TRB_SUB")
	DbCloseArea()
EndIf

_cQuery := "SELECT SA1.A1_TIPO,                                                               "
_cQuery += "       ZX5A.ZX5_DSCITE DESMAXATIV,                                                "
_cQuery += "       ZX5B.ZX5_DSCITE DESMINATIV,                                                "
_cQuery += "       ZX5C.ZX5_DSCITE COMMAXATIV,                                                "
_cQuery += "       ZX5D.ZX5_DSCITE COMMINATIV                                                 "
_cQuery += "FROM  " + retSqlName("SA1") + " SA1                                               "
_cQuery += "INNER JOIN " + retSqlName("ZX5") + " ZX5A ON ZX5A.ZX5_FILIAL = SA1.A1_FILIAL AND  "
_cQuery += "                          ZX5A.ZX5_GRUPO = '000002' AND                           "
_cQuery += "                          ZX5A.ZX5_CODIGO = SA1.A1_TIPO AND                       "
_cQuery += "                          ZX5A.D_E_L_E_T_ = ' '                                   "
_cQuery += "INNER JOIN " + retSqlName("ZX5") + " ZX5B ON ZX5B.ZX5_FILIAL = SA1.A1_FILIAL AND  "
_cQuery += "                          ZX5B.ZX5_GRUPO = '000003' AND                           "
_cQuery += "                          ZX5B.ZX5_CODIGO = SA1.A1_TIPO AND                       "
_cQuery += "                          ZX5B.D_E_L_E_T_ = ' '                                   "
_cQuery += "INNER JOIN " + retSqlName("ZX5") + " ZX5C ON ZX5C.ZX5_FILIAL = SA1.A1_FILIAL AND  "
_cQuery += "                          ZX5C.ZX5_GRUPO = '000004' AND                           "
_cQuery += "                          ZX5C.ZX5_CODIGO = SA1.A1_TIPO AND                       "
_cQuery += "                          ZX5C.D_E_L_E_T_ = ' '                                   "
_cQuery += "INNER JOIN " + retSqlName("ZX5") + " ZX5D ON ZX5D.ZX5_FILIAL = SA1.A1_FILIAL AND  "
_cQuery += "                          ZX5D.ZX5_GRUPO = '000005' AND                           "
_cQuery += "                          ZX5D.ZX5_CODIGO = SA1.A1_TIPO AND                       "
_cQuery += "                          ZX5D.D_E_L_E_T_ = ' '                                   "
_cQuery += "WHERE SA1.A1_COD = '" + M->UA_CLIENTE + "' AND                                    "
_cQuery += "      SA1.A1_LOJA = '" + M->UA_LOJA + "' AND                                      "
_cQuery += "      SA1.D_E_L_E_T_ = ' '                                                        "
TcQuery _cQuery New Alias "TRB_SUB"

nDMaxAti	:= val(TRB_SUB->DESMAXATIV)
nDMinAti	:= val(TRB_SUB->DESMINATIV)
nCMaxAti	:= val(TRB_SUB->COMMAXATIV)
nCMinAti	:= val(TRB_SUB->COMMINATIV)

//motivo 56 - PERC. DESCTO P/ATIVIDADE INFERIOR AO MINIMO                 
//If( (M->UA_DESC1 > 0 .OR. M->UA_DESC2 > 0 .OR. M->UA_DESC3 > 0) .AND.;
//	(M->UA_DESC1 + M->UA_DESC2 + M->UA_DESC3) < nDMinAti )
If M->UA__DESCAP > 0 .AND. M->UA__DESCAP < nDMinAti
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"056",;
	posicione("Z04",1,xFilial("Z04")+"056","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 57 - PERC. DESCTO P/ATIVIDADE SUPERIOR AO MAXIMO                 
//If( (M->UA_DESC1 > 0 .OR. M->UA_DESC2 > 0 .OR. M->UA_DESC3 > 0) .AND.;
//	(M->UA_DESC1 + M->UA_DESC2 + M->UA_DESC3) > nDMaxAti)
If M->UA__DESCAP > 0 .AND. M->UA__DESCAP > nDMaxAti
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"057",;
	posicione("Z04",1,xFilial("Z04")+"057","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 71 - PEDIDO ABAIXO DO VALOR MINIMO                               
//If(M->UA_VALBRUT < nMinPed)
If aValores[TOTAL] < nMinPed
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"071",;
	posicione("Z04",1,xFilial("Z04")+"071","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf

TRB_SUB->(dbCloseArea())

For nX := 1 To Len(aCols)
	If(!aCols[nX][Len(aHeader)+1])
	
	   DbSelectArea("SB1")
	   DbSetOrder(1)
	   DbSeek(xFilial("SB1") + aCols[nX][_nPosCod])
	
		_cQuery := "SELECT ACS.ACS_CODREG,                               "
		_cQuery += "       CASE WHEN ACN.ACN_CODPRO = ' '                "
		_cQuery += "            THEN                                     "
		_cQuery += "                 'G'                                 "
		_cQuery += "            ELSE                                     "
		_cQuery += "                 'C' END TIPO,                       "
		_cQuery += "       CASE WHEN ACN.ACN_CODPRO = ' '                "
		_cQuery += "            THEN                                     "
		_cQuery += "                 ACN.ACN_GRPPRO                      "
		_cQuery += "            ELSE                                     "
		_cQuery += "                 ACN.ACN_CODPRO END REGRA,           "
		_cQuery += "       ACN.ACN_DESCON,                               "
		_cQuery += "       ACN.ACN__DESMI,                               "
		_cQuery += "       ACN.ACN__COMMA,                               "
		_cQuery += "       ACN.ACN__COMMI                                "
		_cQuery += "FROM " + retSqlName("SB1") + " SB1 					 "
		_cQuery += "INNER JOIN " + retSqlName("ACN") + " ACN  ON (ACN.ACN_CODPRO = SB1.B1_COD OR ACN.ACN_GRPPRO = SB1.B1_GRUPO) AND 	"
		_cQuery += "                         ACN.D_E_L_E_T_ = ' '                                                                       "
		_cQuery += "INNER JOIN " + retSqlName("ACS") + " ACS ON ACS.ACS_CODREG = ACN.ACN_CODREG AND                                     "
		_cQuery += "                         ACS.ACS_DATDE <= '" + DTOS(Date()) + "' AND                                                "
		_cQuery += "                         ACS.ACS_DATATE >= '" + DTOS(Date()) + "' AND                                               "
		_cQuery += "                         ACS.D_E_L_E_T_ = ' '                                                                       "
		_cQuery += "WHERE SB1.B1_COD = '" + aCols[nX][_nPosCod] + "'     "
		_cQuery += "      AND SB1.D_E_L_E_T_ = ' '                       "
		TcQuery _cQuery New Alias "TRB_SUB"
		
		DbSelectArea("TRB_SUB")
		
		//motivo 52 - PERC. DESCTO P/ITEM INFERIOR AO MINIMO                      
		If(TRB_SUB->TIPO == 'C' .AND. (aCols[nX][_nPosDig] / aCols[nX][_nPosPun] * 100 - 100) < TRB_SUB->ACN__DESMI)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"052",;
			posicione("Z04",1,xFilial("Z04")+"052","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 53 - PERC. DESCTO P/ITEM SUPERIOR AO MAXIMO                      
		If(TRB_SUB->TIPO == 'C' .AND. (aCols[nX][_nPosDig] / aCols[nX][_nPosPun] * 100 - 100) > TRB_SUB->ACN_DESCON)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"053",;
			posicione("Z04",1,xFilial("Z04")+"053","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 54 - PERC. DESCTO P/GRUPO INFERIOR AO MINIMO                                                                
		If(TRB_SUB->TIPO == 'G' .AND. (aCols[nX][_nPosDig] / aCols[nX][_nPosPun] * 100 - 100) < TRB_SUB->ACN__DESMI)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"054",;
			posicione("Z04",1,xFilial("Z04")+"054","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 55 - PERC. DESCTO P/GRUPO SUPERIOR AO MAXIMO                     
		If(TRB_SUB->TIPO == 'G' .AND. (aCols[nX][_nPosDig] / aCols[nX][_nPosPun] * 100 - 100) > TRB_SUB->ACN_DESCON)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"055",;
			posicione("Z04",1,xFilial("Z04")+"055","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		
		_nPerCom := IIF(SA3->A3_COMIS > 0,SA3->A3_COMIS,SB1->B1_COMIS) //Verifica se a comissão virá do produto ou do vendedor
		
		//motivo 58 - PERC. COMISSAO P/ITEM INFERIOR AO MINIMO                    
		If(TRB_SUB->TIPO == 'C' .AND. ;
			(_nPerCom > 0 .AND. _nPerCom < TRB_SUB->ACN__COMMI) )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"058",;
			posicione("Z04",1,xFilial("Z04")+"058","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 59 - PERC. COMISSAO P/ITEM SUPERIOR AO MAXIMO                    
		If(TRB_SUB->TIPO == 'C' .AND. ;
			(_nPerCom   > TRB_SUB->ACN__COMMA))
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"059",;
			posicione("Z04",1,xFilial("Z04")+"059","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 60 - PERC. COMISSAO P/GRUPO INFERIOR AO MINIMO                   
		If(TRB_SUB->TIPO == 'G' .AND. ;
			(_nPerCom > 0 .AND. _nPerCom  < TRB_SUB->ACN__COMMI) )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"060",;
			posicione("Z04",1,xFilial("Z04")+"060","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 61 - PERC. COMISSAO P/GRUPO SUPERIOR AO MAXIMO                   
		If(TRB_SUB->TIPO == 'G' .AND. ;
			(_nPerCom > TRB_SUB->ACN__COMMA))
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"061",;
			posicione("Z04",1,xFilial("Z04")+"061","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 62 - PERC. COMISSAO P/ATIVIDADE INFERIOR AO MINIMO               
		If((_nPerCom > 0 .AND. _nPerCom < nCMinAti))
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"062",;
			posicione("Z04",1,xFilial("Z04")+"062","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 63 - PERC. COMISSAO P/ATIVIDADE SUPERIOR AO MAXIMO               
		If(_nPerCom > nCMaxAti .AND. nCMaxAti > 0)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"063",;
			posicione("Z04",1,xFilial("Z04")+"063","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		TRB_SUB->(dbCloseArea())
	EndIf
Next nX
       
For nX := 1 To Len(aCols)
	If(!aCols[nX][Len(aHeader)+1])
		_cQuery := "SELECT (SB2.B2_QATU - SB2.B2_RESERVA - Z10.QTD) AS SALDO,  				   " + Chr(13)
		_cQuery += "		SB2.B2__QTDTRA                                                     " + Chr(13)
		_cQuery += "FROM " + retSqlName("SB2") + " SB2                                         " + Chr(13)
		_cQuery += "LEFT JOIN (SELECT Z10.Z10_FILIAL,                                          " + Chr(13)
		_cQuery += "                 Z10.Z10_PROD,                                             " + Chr(13)
		_cQuery += "                 NVL(SUM(Z10.Z10_QTD),0) AS QTD                            " + Chr(13)
		_cQuery += "          FROM " + retSqlName("Z10") + " Z10                               " + Chr(13)
		_cQuery += "          WHERE Z10.D_E_L_E_T_ = ' '                                       " + Chr(13)
		_cQuery += "                AND Z10.Z10_FILIAL = '" + M->UA__FILIAL + "'               " + Chr(13)
		_cQuery += "                AND Z10.Z10_PROD = '" + aCols[nX][_nPosCod] + "'           " + Chr(13)
		_cQuery += "                AND Z10.Z10_CODSUA != '" + M->UA_NUM + "' 	           	   " + Chr(13)
		_cQuery += "                AND Z10.Z10_LOCAL   = '" + aCols[nX][_nPosLoc] + "'        " + Chr(13)
		_cQuery += "          GROUP BY Z10.Z10_FILIAL                                          " + Chr(13)
		_cQuery += "                   ,Z10.Z10_PROD) Z10 ON Z10.Z10_FILIAL = SB2.B2_FILIAL    " + Chr(13)
		_cQuery += "                                         AND Z10.Z10_PROD = SB2.B2_COD     " + Chr(13)
		_cQuery += "WHERE SB2.B2_FILIAL = '" + M->UA__FILIAL + "'                              " + Chr(13)
		_cQuery += "      AND SB2.B2_COD = '" + aCols[nX][_nPosCod] + "'                       " + Chr(13)
		_cQuery += "      AND SB2.B2_LOCAL = '" + aCols[nX][_nPosLoc] + "'                     " + Chr(13)
		_cQuery += "      AND SB2.D_E_L_E_T_ = ' '                                             "
		TcQuery _cQuery New Alias "TRB_SUB"
		
		DbSelectArea("TRB_SUB")
		//motivo 91 - MERCADORIA EM TRANSITO                                      
		If(TRB_SUB->SALDO < aCols[nX][_nPosQt] .AND. TRB_SUB->B2__QTDTRA > 0 .AND. (TRB_SUB->SALDO + TRB_SUB->B2__QTDTRA > aCols[nX][_nPosQt]) )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"091",;
			posicione("Z04",1,xFilial("Z04")+"091","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		TRB_SUB->(dbCloseArea())
	EndIf
Next nX

_cQuery := "SELECT SE1.E1_NUM,                        				" + CRLF
_cQuery += "       SE1.E1_VENCTO                      				" + CRLF
_cQuery += "FROM " + retSqlName("SE1") + " SE1     	  				" + CRLF
_cQuery += "WHERE SE1.E1_CLIENTE = '" + M->UA_CLIENTE + "' AND  	" + CRLF
If _lCredLoj
	_cQuery += "      SE1.E1_LOJA = '" + M->UA_LOJA + "' AND      	" + CRLF
EndIf
_cQuery += "E1_TIPO NOT IN " + FormatIn(MVABATIM,"|")      + " And "
_cQuery += "E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " And "
_cQuery += "E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " And "
_cQuery += "E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " And "
_cQuery += "      SE1.E1_SALDO > 0 AND                				" + CRLF
_cQuery += "      SE1.E1_VENCTO < '" + DTOS(Date()) + "' AND      	" + CRLF
_cQuery += "      SE1.D_E_L_E_T_ = ' '                				" + CRLF
_cQuery += "ORDER BY SE1.E1_VENCTO ASC                				" + CRLF

TcQuery _cQuery New Alias "TRB_SUB"
TcSetField("TRB_SUB", "E1_VENCTO"   , "D", 08, 0)

DbSelectArea("TRB_SUB")

If(!Empty(TRB_SUB->E1_VENCTO))
	If( Date() > TRB_SUB->E1_VENCTO )
		//motivo 94 - cliente inadimplente
		If(Date() - TRB_SUB->E1_VENCTO > nCliInat)
 /*			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"094",;
			posicione("Z04",1,xFilial("Z04")+"094","Z04_DESC"),;
			"1",;                             	
			M->UA_CLIENTE,;
			M->UA_LOJA})*/
		EndIf
		//motivo 04 - CLIENTE COM TITULOS EM ATRASO!                              
		AADD(aBloq,{M->UA__FILIAL,;
		_cNum,;
		"",;
		"",;
		"004",;
		posicione("Z04",1,xFilial("Z04")+"004","Z04_DESC"),;
		Z04->Z04_TIPO,;
		M->UA_CLIENTE,;
		M->UA_LOJA})
		If Z04->Z04_TIPO == "1"
			lCom := .T.
		ElseIf Z04->Z04_TIPO == "2"
			lFin := .t.
		ElseIf Z04->Z04_TIPO == "3"
			lCom := .T.
			lFin := .t.
		EndIf
	EndIf
EndIf
TRB_SUB->(dbCloseArea())


_cQuery := "SELECT MAX(A1_PRICOM) AS A1_PRICOM				" + Chr(13)
_cQuery += "FROM " + retSqlName("SA1") + " SA1              " + Chr(13)
_cQuery += "WHERE SA1.D_E_L_E_T_ = ' '                      " + Chr(13)
_cQuery += "      AND SA1.A1_COD = '" + M->UA_CLIENTE + "'  " + Chr(13)
If _lCredLoj
	_cQuery += "  AND SA1.A1_LOJA = '" +  M->UA_LOJA + "'   "
EndIf
TcQuery _cQuery New Alias "TRB_SUB"

DbSelectArea("TRB_SUB")


/*DbSelectArea("SA1")
DbSetOrder(1)
DbSeek(xFilial("SA1") + M->UA_CLIENTE + M->UA_LOJA)*/

//Motivo 95 - CLIENTE NOVO                                                
If (Empty(TRB_SUB->A1_PRICOM))
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"095",;
	posicione("Z04",1,xFilial("Z04")+"095","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf

TRB_SUB->(dbCloseArea())

If _lCredLoj
	_cQuery := "SELECT SA1.A1_TPFRET,                                                             " + CRLF
	_cQuery += "       SA1.A1_LC,                                                                 " + CRLF
	_cQuery += "       SA1.A1_VENCLC,                                                             " + CRLF
	_cQuery += "       SA1.A1_SALDUP,                                                             " + CRLF
	_cQuery += "       SA1.A1_SALPEDL,                                                            " + CRLF
	_cQuery += "       SA1.A1_RISCO,                                                              " + CRLF
	_cQuery += "       SA1.A1__PRZMED,                                                            " + CRLF
	_cQuery += "       SA1.A1__SERASA,                                                            " + CRLF
	_cQuery += "       SA1.A1__SPC,                                                               " + CRLF
	_cQuery += "       SA1.A1__SCI,                                                               " + CRLF
	_cQuery += "       SA1.A1__RESTRI,                                                            " + CRLF
	_cQuery += "       SA1.A1__ATIVO,                                                             " + CRLF
	_cQuery += "       SA1.A1__DUVIDO,                                                            " + CRLF
	_cQuery += "       SA1.A1__INADIM,                                                            " + CRLF
	_cQuery += "       SA1.A1__PROB,	                                                          " + CRLF
	_cQuery += "       SA3.A3__MAXRES,                                                            " + CRLF
	_cQuery += "       SZ7.Z7_PERCLI,                                                             " + CRLF
	_cQuery += "       SF2A.F2_EMISSAO,                                                           " + CRLF
	_cQuery += "       ADE.ADE_STATUS                                                             " + CRLF
	_cQuery += "FROM " + retSqlName("SA1") + " SA1                                                " + CRLF
	_cQuery += "INNER JOIN " + retSqlName("SZ7") + " SZ7 ON SZ7.Z7_FILIAL = SA1.A1_FILIAL AND     " + CRLF
	_cQuery += "                         SZ7.Z7_CODIGO = SA1.A1__SEGISP AND                       " + CRLF
	_cQuery += "                         SZ7.D_E_L_E_T_ = ' '                                     " + CRLF
	_cQuery += "INNER JOIN " + retSqlName("SA3") + " SA3 ON SA3.A3_COD = '" + M->UA_VEND + "'     " + CRLF
	_cQuery += "LEFT JOIN " + retSqlName("ADE") + " ADE ON ADE.ADE_ENTIDA = 'SA1' AND             " + CRLF
	_cQuery += "                   ADE.ADE__CLI = SA1.A1_COD And ADE.ADE__LOJA = SA1.A1_LOJA AND  " + CRLF
	_cQuery += "                   ADE.D_E_L_E_T_ = ' '                                           " + CRLF
	_cQuery += "LEFT JOIN  (SELECT  SF2.F2_CLIENT,                                                " + CRLF
	_cQuery += "                    SF2.F2_LOJA,                                                  " + CRLF
	_cQuery += "                    MAX(SF2.F2_EMISSAO) F2_EMISSAO                                " + CRLF
	_cQuery += "            FROM " + retSqlName("SF2") + " SF2                                    " + CRLF
	_cQuery += "            WHERE   SF2.F2_CLIENT = '" +  M->UA_CLIENTE + "' AND                  " + CRLF
	_cQuery += "                    SF2.F2_LOJA = '" +  M->UA_LOJA + "' AND                       " + CRLF
	_cQuery += "                    SF2.D_E_L_E_T_ = ' ' AND                                      " + CRLF
	_cQuery += "                    SF2.F2_TIPO = 'N'                                             " + CRLF
	_cQuery += "            GROUP BY SF2.F2_CLIENT,                                               " + CRLF
	_cQuery += "                     SF2.F2_LOJA ) SF2A ON SF2A.F2_CLIENT = SA1.A1_COD AND        " + CRLF
	_cQuery += "                                           SF2A.F2_LOJA = SA1.A1_LOJA             " + CRLF
	_cQuery += "WHERE SA1.D_E_L_E_T_ = ' '                                                        " + CRLF
	_cQuery += "      AND SA1.A1_COD = '" +  M->UA_CLIENTE + "'                                   " + CRLF
	_cQuery += "      AND SA1.A1_LOJA = '" +  M->UA_LOJA + "'                                     "
Else 
	_cQuery := "SELECT SA1.A1_TPFRET,                                                             " + CRLF 
	_cQuery += "       SA1A.A1_LC,                                                                " + CRLF
	_cQuery += "       SA1.A1_VENCLC,                                                             " + CRLF
	_cQuery += "       SA1.A1_SALDUP,                                                             " + CRLF
	_cQuery += "       SA1.A1_SALPEDL,                                                            " + CRLF
	_cQuery += "       SA1.A1_RISCO,                                                              " + CRLF
	_cQuery += "       SA1.A1__PRZMED,                                                            " + CRLF
	_cQuery += "       SA1.A1__SERASA,                                                            " + CRLF
	_cQuery += "       SA1.A1__SPC,                                                               " + CRLF
	_cQuery += "       SA1.A1__SCI,                                                               " + CRLF
	_cQuery += "       SA1.A1__RESTRI,                                                            " + CRLF
	_cQuery += "       SA1.A1__ATIVO,                                                             " + CRLF
	_cQuery += "       SA1.A1__DUVIDO,                                                            " + CRLF
	_cQuery += "       SA1.A1__INADIM,                                                            " + CRLF
	_cQuery += "       SA1.A1__PROB,                                                              " + CRLF
	_cQuery += "       SA3.A3__MAXRES,                                                            " + CRLF
	_cQuery += "       SZ7.Z7_PERCLI,                                                             " + CRLF
	_cQuery += "       SF2A.F2_EMISSAO,                                                           " + CRLF
	_cQuery += "       ADE.ADE_STATUS                                                             " + CRLF
	_cQuery += "FROM " + retSqlName("SA1") + " SA1                                                " + CRLF
	_cQuery += "INNER JOIN " + retSqlName("SZ7") + " SZ7 ON SZ7.Z7_FILIAL = SA1.A1_FILIAL AND     " + CRLF
	_cQuery += "                         SZ7.Z7_CODIGO = SA1.A1__SEGISP AND                       " + CRLF
	_cQuery += "                         SZ7.D_E_L_E_T_ = ' '                                     " + CRLF
	_cQuery += "INNER JOIN (SELECT A1_COD,SUM(A1_LC) A1_LC                                        " + CRLF
	_cQuery += "            FROM " + retSqlName("SA1") + " SA1                                    " + CRLF
	_cQuery += "            WHERE SA1.D_E_L_E_T_ = ' '                                            " + CRLF
	_cQuery += "                  AND A1_COD = '" +  M->UA_CLIENTE + "'                           " + CRLF
	_cQuery += "            GROUP BY A1_COD) SA1A ON SA1A.A1_COD = SA1.A1_COD                     " + CRLF      
	_cQuery += "INNER JOIN " + retSqlName("SA3") + " SA3 ON SA3.A3_COD = '" + M->UA_VEND + "'     " + CRLF
	_cQuery += "LEFT JOIN " + retSqlName("ADE") + " ADE ON ADE.ADE_ENTIDA = 'SA1' AND             " + CRLF
	_cQuery += "                        ADE.ADE__CLI = SA1.A1_COD AND                             " + CRLF
	_cQuery += "                        ADE.D_E_L_E_T_ = ' '                                      " + CRLF
	_cQuery += "LEFT JOIN  (SELECT  SF2.F2_CLIENT,                                                " + CRLF
	_cQuery += "                    SF2.F2_LOJA,                                                  " + CRLF
	_cQuery += "                    MAX(SF2.F2_EMISSAO) F2_EMISSAO                                " + CRLF
	_cQuery += "            FROM " + retSqlName("SF2") + " SF2                                    " + CRLF
	_cQuery += "            WHERE   SF2.F2_CLIENT = '" +  M->UA_CLIENTE + "' AND                  " + CRLF
	_cQuery += "                    SF2.D_E_L_E_T_ = ' ' AND                                      " + CRLF
	_cQuery += "                    SF2.F2_TIPO = 'N'                                             " + CRLF
	_cQuery += "            GROUP BY SF2.F2_CLIENT,                                               " + CRLF
	_cQuery += "                     SF2.F2_LOJA ) SF2A ON SF2A.F2_CLIENT = SA1.A1_COD            " + CRLF
	_cQuery += "WHERE SA1.D_E_L_E_T_ = ' '                                                        " + CRLF
	_cQuery += "      AND SA1.A1_COD = '" +  M->UA_CLIENTE + "'                                   " + CRLF
	//_cQuery += "      AND SA1.A1_LOJA = '" +  M->UA_LOJA + "'                                     " 
EndIf
TcQuery _cQuery New Alias "TRB_SUB"
TcSetField("TRB_SUB", "F2_EMISSAO"  , "D", 08, 0)
TcSetField("TRB_SUB", "A1_VENCLC"   , "D", 08, 0)

DbSelectArea("TRB_SUB")

//motivo 84 - BLOQUEIO PARA COMPRA A PRAZO                                                       
If( TRB_SUB->A1__PRZMED = 0 .AND. nPrazomed > 0 )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"084",;
	posicione("Z04",1,xFilial("Z04")+"084","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 07 - COMPRA ACIMA DO LIMITE DE CREDITO!                          
//If ( (TRB_SUB->A1_LC - TRB_SUB->A1_SALDUP - TRB_SUB->A1_SALPEDL) < M->UA_VALBRUT )
If ( (TRB_SUB->A1_LC - TRB_SUB->A1_SALDUP - TRB_SUB->A1_SALPEDL) < aValores[TOTAL] )

	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"007",;
	posicione("Z04",1,xFilial("Z04")+"007","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 78 - TIPO DE FRETE DO CLIENTE DIFERENTE DO FRETE DO PEDIDO       
If(M->UA_TPFRETE != TRB_SUB->A1_TPFRET)
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"078",;
	posicione("Z04",1,xFilial("Z04")+"078","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 74 - CLIENTE DUVIDOSO                                            
If(TRB_SUB->A1__DUVIDO == "1")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"074",;
	posicione("Z04",1,xFilial("Z04")+"074","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 75 - CLIENTE INATIVO                                             
If(TRB_SUB->A1__ATIVO == "2")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"075",;
	posicione("Z04",1,xFilial("Z04")+"075","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
	
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"075",;
	posicione("Z04",1,xFilial("Z04")+"075","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 02 - CLIENTE INADIMPLENTE!                                                                                    
If(TRB_SUB->A1__INADIM == "1")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"075",;
	posicione("Z04",1,xFilial("Z04")+"002","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 03 - CLIENTE COM RESTRICAO NA EMPRESA!                                                                                                             
If(TRB_SUB->A1__PROB == "1")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"003",;
	posicione("Z04",1,xFilial("Z04")+"003","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 76 - BLOQUEIO PELO OPERADOR MANIFESTACAO ABERTA                  
If(TRB_SUB->ADE_STATUS == "3")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"074",;
	posicione("Z04",1,xFilial("Z04")+"074","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 79 - DESCONTO DE PROMOCAO EM DESACORDO                           
If(M->UA__DESCAP > 0 .AND. M->UA__DESINI != M->UA__DESCAP .And. M->UA__DESINI > 0)
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"079",;
	posicione("Z04",1,xFilial("Z04")+"079","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 77 - ENDERECO DE ENTREGA DIFERENTE DO FATURAMENTO                
If( M->UA__LJAENT != M->UA__LJACOB )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"077",;
	posicione("Z04",1,xFilial("Z04")+"077","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 72 - PEDIDO ACIMA DO VALOR MAXIMO                                
//If( M->UA_VALBRUT > nMaxPed )
If aValores[TOTAL] > nMaxPed
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"072",;
	posicione("Z04",1,xFilial("Z04")+"072","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
		
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"072",;
	posicione("Z04",1,xFilial("Z04")+"072","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 73 - pedido programado com reserva de estoque
/*If((M->UA__PRVFAT - M->UA_EMISSAO) > TRB_SUB->A3__MAXRES)
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"073",;
	posicione("Z04",1,xFilial("Z04")+"073","Z04_DESC"),;
	"1",;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	lCom := .T.
EndIf */
//motivo 84 - prazo medio não permitido
If( TRB_SUB->A1__PRZMED > 0 .AND. (nTOTPRA/nTOTDIA) > 1 )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"084",;
	posicione("Z04",1,xFilial("Z04")+"084","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 08 - CLIENTE COM RESTRICÇO SERASA!                               
If( TRB_SUB->A1__SERASA == "1")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"008",;
	posicione("Z04",1,xFilial("Z04")+"008","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 11 - PROBLEMAS NO SPC!                                           
If( TRB_SUB->A1__SPC == "1" )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"011",;
	posicione("Z04",1,xFilial("Z04")+"011","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 11 - PROBLEMAS NO SPC!                                           
If( TRB_SUB->A1__SCI == "1" )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"010",;
	posicione("Z04",1,xFilial("Z04")+"010","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 12 - CLIENTE BLOQUEADO!                                          
If( TRB_SUB->A1__RESTRI == "1")
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"012",;
	posicione("Z04",1,xFilial("Z04")+"012","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 06 - CLIENTE SEM LIMITE DE CREDITO!                              
If( Empty(TRB_SUB->A1_LC) .AND. !(Empty(TRB_SUB->A1_VENCLC) .AND. Empty(TRB_SUB->A1_RISCO)) )
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"006",;
	posicione("Z04",1,xFilial("Z04")+"006","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 01 - CLIENTE SEM ANALISE CREDITO EFETUADA!                       
If( Empty(TRB_SUB->A1_LC) .AND. Empty(TRB_SUB->A1_VENCLC) .AND. Empty(TRB_SUB->A1_RISCO))
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"001",;
	posicione("Z04",1,xFilial("Z04")+"001","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 05 - DATA DO LIMITE DE CREDITO VENCIDA!                          
If( TRB_SUB->A1_VENCLC < Date())
	AADD(aBloq,{M->UA__FILIAL,;
	_cNum,;
	"",;
	"",;
	"005",;
	posicione("Z04",1,xFilial("Z04")+"005","Z04_DESC"),;
	Z04->Z04_TIPO,;
	M->UA_CLIENTE,;
	M->UA_LOJA})
	If Z04->Z04_TIPO == "1"
		lCom := .T.
	ElseIf Z04->Z04_TIPO == "2"
		lFin := .t.
	ElseIf Z04->Z04_TIPO == "3"
		lCom := .T.
		lFin := .t.
	EndIf
EndIf
//motivo 96 - PEDIDO PROGRAMADO COM RESERVA DE ESTOQUE 
If(M->UA__RESEST == "S" .AND. M->UA__TIPPED == '2' .AND. M->UA_OPER == '1')
	If( (M->UA__PRVFAT - M->UA_EMISSAO) > TRB_SUB->A3__MAXRES )
		AADD(aBloq,{M->UA__FILIAL,;
		_cNum,;
		"",;
		"",;
		"096",;
		posicione("Z04",1,xFilial("Z04")+"096","Z04_DESC"),;
		Z04->Z04_TIPO,;
		M->UA_CLIENTE,;
		M->UA_LOJA})
		If Z04->Z04_TIPO == "1"
			lCom := .T.
		ElseIf Z04->Z04_TIPO == "2"
			lFin := .t.
		ElseIf Z04->Z04_TIPO == "3"
			lCom := .T.
			lFin := .t.
		EndIf
	EndIf
EndIf

TRB_SUB->(dbCloseArea())


For nX := 1 To Len(aCols)
	If(!aCols[nX][Len(aHeader)+1])
		_cQuery := "SELECT DA1.DA1_CODPRO,           " + CRLF
		_cQuery += "       DA1.DA1_PRCVEN,           " + CRLF
		_cQuery += "       SF4.F4_DUPLIC,			 " + CRLF
		_cQuery += "       NVL(ACP.ACP_FAIXA,0) AS ACP_FAIXA,  " + CRLF
		//_cQuery += "       NVL(ADE.ADE_STATUS,' ') AS ADE_STATUS, "     + CRLF
		//_cQuery += "       ((DA1.DA1_PRCVEN - (DA1.DA1_PRCVEN * SUB.UB_DESC / 100)) - (DA1.DA1_PRCVEN - (DA1.DA1_PRCVEN * SUB.UB_DESC / 100)) *  SUB.UB__DESC2 / 100)  PRECMIN, "  + CRLF
		_cQuery += "       (DA1.DA1_PRCVEN + (DA1.DA1_PRCVEN * ACP.ACP_PERDES / 100)) PRECMAX  " + CRLF
		_cQuery += "FROM " + retSqlName("DA1") + " DA1 " + CRLF
		_cQuery += "INNER JOIN " + retSqlName("DA0") + " DA0 ON DA0.DA0_FILIAL = DA1.DA1_FILIAL AND "  + CRLF
		_cQuery += "                         DA0.DA0_CODTAB = DA1.DA1_CODTAB AND " + CRLF
		_cQuery += "                         DA0.D_E_L_E_T_ = ' ' " + CRLF
		_cQuery += "INNER JOIN " + retSqlName("SF4") + " SF4 ON SF4.F4_FILIAL = '" + M->UA__FILIAL + "' AND " + CRLF
		_cQuery += "                         SF4.F4_CODIGO = '" + aCols[nX][_nPosTes] + "' AND  " + CRLF
		_cQuery += "                         SF4.D_E_L_E_T_ = ' '            " + CRLF
		_cQuery += "INNER JOIN " + retSqlName("SB1") + " SB1 ON SB1.B1_COD = DA1.DA1_CODPRO AND " + CRLF
		_cQuery += "                         SB1.D_E_L_E_T_ = ' ' " + CRLF
		_cQuery += "LEFT JOIN " + retSqlName("ACO") + " ACO ON ACO.ACO_CODTAB = DA1.DA1_CODTAB AND " + CRLF
		_cQuery += "                        ACO.ACO_CODCLI = '" + M->UA_CLIENTE + "' AND  " + CRLF
		_cQuery += "                        ACO.ACO_LOJA = '" + M->UA_LOJA + "' AND " + CRLF
		_cQuery += "                        ACO.ACO_DATDE > '" + DTOS(Date()) + "' AND " + CRLF
		_cQuery += "                        ACO.ACO_DATATE < '" + DTOS(Date()) + "' AND        " + CRLF
		_cQuery += "                        ACO.D_E_L_E_T_ = ' '                                   " + CRLF
		_cQuery += "LEFT JOIN " + retSqlName("ACP") + " ACP ON (ACP.ACP_CODPRO = DA1.DA1_CODPRO OR ACP.ACP_GRUPO = SB1.B1_GRUPO) AND " + CRLF
		_cQuery += "                        ACP.ACP_FAIXA > " + alltrim(str(aCols[nX][_nPosQt])) + " AND " + CRLF
		_cQuery += "                        ACP.D_E_L_E_T_ = ' '             " + CRLF
		_cQuery += "WHERE DA1.DA1_CODPRO = '" + aCols[nX][_nPosCod] + "' AND " + CRLF
		_cQuery += "      DA1.DA1_ESTADO = '  ' AND " + CRLF
		_cQuery += "      DA1.D_E_L_E_T_ = ' ' AND  " + CRLF
		_cQuery += "      DA0.DA0_DATDE < '" + DTOS(Date()) + "' AND " + CRLF
		_cQuery += "      (DA0.DA0_DATATE > '" + DTOS(Date()) + "' OR DA0.DA0_DATATE = ' ')        "
		TcQuery _cQuery New Alias "TRB_SUB"
		
		nPrecPor := TRB_SUB->DA1_PRCVEN * aCols[nX][_nPosDes1] / 100		
		//motivo 50 - PRECO UNITARIO INCORRETO(MENOR)                             
		If(aCols[nX][_nPosDig] < aCols[nX][_nPosTab] )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"050",;
			posicione("Z04",1,xFilial("Z04")+"050","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 51 - PRECO UNITARIO INCORRETO (MAIOR)                            
		If( aCols[nX][_nPosDig] > aCols[nX][_nPosTab] )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"051",;
			posicione("Z04",1,xFilial("Z04")+"051","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 70 - DESCONTO NAO PERMITIDO                                      
		If((aCols[nX][_nPosDig] / aCols[nX][_nPosPun] * 100 - 100) > nMaxDes )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"070",;
			posicione("Z04",1,xFilial("Z04")+"070","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			MsUnlock()
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 81 - OPERACAO DE VENDA NAO ATUALIZA O CONTAS A RECEBER           
		If(TRB_SUB->F4_DUPLIC == "N" .And. Val(M->UA__TIPPED) != 6)
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"081",;
			posicione("Z04",1,xFilial("Z04")+"081","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 87 - PERC. DE CORTE SUPERIOR AO PERMITIDO                        
		If(TRB_SUB->ACP_FAIXA > 0 .AND. ((1-(aCols[nX][_nPosQt] / TRB_SUB->ACP_FAIXA)*100) > nPerPed) )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"087",;
			posicione("Z04",1,xFilial("Z04")+"087","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 79 - DESCONTO DE PROMOCAO EM DESACORDO                           
		If(TRB_SUB->ACP_FAIXA > 0 .AND. (aCols[nX][_nPosQt] < TRB_SUB->ACP_FAIXA .And. acols[nx][_nPosProm] > 0) )
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"079",;
			posicione("Z04",1,xFilial("Z04")+"079","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		//motivo 91 - Mercadoria em transito
		If(u_xSldProd(M->UA__FILIAL, aCols[nX][_nPosCod], aCols[nX][_nPosLoc], _cNum ) < aCols[nX][_nPosQt])
			AADD(aBloq,{M->UA__FILIAL,;
			_cNum,;
			aCols[nX][_nCodItem],;
			aCols[nX][_nPosCod],;
			"091",;
			posicione("Z04",1,xFilial("Z04")+"091","Z04_DESC"),;
			Z04->Z04_TIPO,;
			M->UA_CLIENTE,;
			M->UA_LOJA})
			If Z04->Z04_TIPO == "1"
				lCom := .T.
			ElseIf Z04->Z04_TIPO == "2"
				lFin := .t.
			ElseIf Z04->Z04_TIPO == "3"
				lCom := .T.
				lFin := .t.
			EndIf
		EndIf
		TRB_SUB->(dbCloseArea())
	EndIf
Next nX

aCrit := ExibCrit(aBloq)

If _lAuto //Se a rotina for radada por Execauto, grava automaticamente as criticas
	nOpcao := 2
Else
	nOpcao := U_ITMKA24 (M->UA__FILIAL,_cNum,M->UA_CLIENTE,M->UA_LOJA,"T",aCrit)
EndIf

If(nOpcao = 2)
	//Apaga os bloqueios antigos
	U_IFATA14B(_cNum)

/*	DbSelectArea("Z05")
	DbSetOrder(1)
	If MsSeek(xFilial("Z05")+_cNum)
		While !EOF() .AND. (Z05->Z05_FILIAL+Z05->Z05_NUM) == (xFilial("Z05")+_cNum)
            If Z05->Z05_TIPO != "4"
    			Reclock("Z05",.F.)
    			Delete
    			MsUnlock()
    		EndIf
			DbSkip()
		EndDo
	EndIf  */
	
	For nX := 1 To Len(aBloq)
		Reclock("Z05",.T.)
		Z05->Z05_FILIAL := aBloq[nX][1]
		Z05->Z05_NUM 	:= aBloq[nX][2]
		Z05->Z05_ITEM	:= aBloq[nX][3]
		Z05->Z05_PRODUT := aBloq[nX][4]
		Z05->Z05_CODIGO := aBloq[nX][5]
		Z05->Z05_DESC	:= aBloq[nX][6]
		Z05->Z05_TIPO	:= aBloq[nX][7]
		Z05->Z05_CLI	:= aBloq[nX][8]
		Z05->Z05_LOJA	:= aBloq[nX][9]
		MsUnlock()
	Next nX
	
	//Grava bloqueio no cabecalho do pedido e UA__STATUS
	If _lAuto
		Reclock("SUA",.F.)
			If (lCom .AND. lFin)
				SUA->UA__SITCOM	:= "E"
				SUA->UA__SITFIN	:= "E"
				SUA->UA__STATUS	:= "4" //COMERCIAL/FINANCEIRO
			ElseIf lCom
				SUA->UA__SITCOM	:= "E"
				SUA->UA__STATUS	:= "2" //COMERCIAL
			ElseIf lFin
				SUA->UA__SITFIN	:= "E"
				SUA->UA__STATUS	:= "3" //FINANCEIRO
			EndIf
			SUA->UA__SITCOM := IIF(!lCom,"A","E")
			SUA->UA__SITFIN := IIF(!lFin,"A","E")

			SUA->UA__USRFEC := Posicione("SU7",1,xFilial("SU7")+SUA->UA_OPERADO,"U7_CODUSU")//__cUserId
		   //	SUA->UA__USRFEC := Posicione("SU7",1,SUA->UA_OPERADO,"U7_CODUSU")//__cUserId

			SUA->UA__DTFEC  := Date()
			SUA->UA__HRFEC  := Time()
			
			//ID 201508120843392093 - Rafael Domingues - 18/08
			If AllTrim(SUA->UA__TIPPED) == "6"
				SUA->UA__SITFIN	:= "A"
				SUA->UA__STATUS	:= "2" //COMERCIAL
			EndIf
			
		SUA->(MsUnlock())
	Else
		If (lCom .AND. lFin)
			M->UA__SITCOM	:= "E"
			M->UA__SITFIN	:= "E"
			M->UA__STATUS	:= "4" //COMERCIAL/FINANCEIRO
		ElseIf lCom
			M->UA__SITCOM	:= "E"
			M->UA__STATUS	:= "2" //COMERCIAL
		ElseIf lFin
			M->UA__SITFIN	:= "E"
			M->UA__STATUS	:= "3" //FINANCEIRO
		EndIf
		M->UA__SITCOM := IIF(!lCom,"A","E")
		M->UA__SITFIN := IIF(!lFin,"A","E")
		M->UA__USRFEC := __cUserId
		M->UA__DTFEC  := Date()
		M->UA__HRFEC  := Time()
		
		//ID 201508120843392093 - Rafael Domingues - 18/08
		If AllTrim(M->UA__TIPPED) == "6"
			M->UA__SITFIN	:= "A"
			M->UA__STATUS	:= "2" //COMERCIAL
		EndIf
		
	EndIf

	lRet := .T.
ElseIf(nOpcao = 3)
	M->UA__STATUS := "1" //Não foi enviado para aprovacao
    M->UA__USRFEC := ""
    M->UA__DTFEC  := CTOD("  /  /  ")
    M->UA__HRFEC  := "  :  :  "
	lRet := .T.
EndIf

RestArea(_aAreaSE4)
RestArea(_aAreaZ05)
RestArea(_aArea)

Return lRet

/*
+-------------+-----------+--------+------------------------------+-------+-----------+
| Programa:   | ExibCrit  | Autor: | Rubens Cruz - Anadi		  | Data: | Nov/2014  |
+-------------+-----------+--------+------------------------------+-------+-----------+
| Descrição:  | Rotina para Gravacao de Criticas Comercial/Financeira no pedido		  |
+-------------+-----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			          |
+-------------+-----------------------------------------------------------------------+
| Parametros: | _cNum := Numero do pedido de venda do CallCenter					  |
+-------------+-----------------------------------------------------------------------+
*/                                                                             

Static Function ExibCrit(aCrit)
Local aNewCrit	:= {}
            
for nX = 1 to len(aCrit)
	if ascan(aNewCrit,{|x| Alltrim(x[5]) == aCrit[nX][5]}) = 0
	     aadd(aNewCrit,aCrit[nX])
	endif     
next      

Return aNewCrit
                               
               
/*
+-------------+-----------+--------+------------------------------+-------+-----------+
| Programa:   | LimpaSC9  | Autor: | Rubens Cruz - Anadi		  | Data: | Nov/2014  |
+-------------+-----------+--------+------------------------------+-------+-----------+
| Descrição:  | Rotina para Rotina para estornar liberação de pedidos com criticas	  |
|			  | comerciais/financeiras												  |
+-------------+-----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			          |
+-------------+-----------------------------------------------------------------------+
| Parametros: | _cNum := Numero do pedido de venda do CallCenter					  |
+-------------+-----------------------------------------------------------------------+
*/                                                                             

Static Function LimpaSC9()
Local _aArea 	:= GetArea()
Local _aAreaSC9	:= SC9->(GetArea())

DbSelectArea("SC9")
DbSetOrder(1)

If(DbSeek(M->UA__FILIAL+M->UA_NUMSC5))
	While(M->UA__FILIAL+M->UA_NUMSC5 = SC9->C9_FILIAL+SC9->C9_PEDIDO)
		A460Estorna()
		DbSkip()
	EndDo
EndIf           

RestArea(_aAreaSC9)
RestArea(_aArea)

Return


User Function IFATA14A()

axcadastro("Z04")

Return                 
   
/*
+-------------+-----------+--------+------------------------------+-------+-----------+
| Programa:   | IFATA14B  | Autor: | Rubens Cruz - Anadi		  | Data: | Abr/2015  |
+-------------+-----------+--------+------------------------------+-------+-----------+
| Descrição:  | Rotina para excluir pendencias de pedido da tabela Z05				  |
+-------------+-----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			          |
+-------------+-----------------------------------------------------------------------+
| Parametros: | _cNum := Numero do pedido de venda do CallCenter					  |
+-------------+-----------------------------------------------------------------------+
*/

User Function IFATA14B(_cNum)
Local _lRet := .F.

DbSelectArea("Z05")
DbSetOrder(1)
If MsSeek(xFilial("Z05")+_cNum)
	While !EOF() .AND. (Z05->Z05_FILIAL+Z05->Z05_NUM) == (xFilial("Z05")+_cNum)
            If Z05->Z05_TIPO != "4"
    			Reclock("Z05",.F.)
    			Delete
    			MsUnlock()
    		EndIf
		DbSkip()
	EndDo
	_lRet := .T.
EndIf  

Return _lRet