#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMR12 | Autor: | Rubens Cruz        | Data: | Abril/2015   |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de venda média por Pneus e Camara                  |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMR12()
Local aPergs	:= {}
Local cParams	:= ""
Local cOptions	:= ""
Local _cQuery	:= ""

Private cPerg 	:= PADR("ICOMR12",Len(SX1->X1_GRUPO))

Aadd(aPergs,{"Filial"	,"","","mv_ch1","C",TamSx3("Z2_FILIAL")[1]	,0,0,"G","Empty(MV_PAR01) .OR. existCpo('SM0',cEmpAnt+MV_PAR01)","MV_PAR01",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Ano De"	,"","","mv_ch2","C",04						,0,0,"G",""														,"MV_PAR02",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ano Até"	,"","","mv_ch3","C",04						,0,0,"G",""														,"MV_PAR03",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo"		,"","","mv_ch4","N",01						,0,0,"C",""														,"MV_PAR04","Sintetico"	,"","","","","Analitico","","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

//Apaga registros antigos da tabela PA2
DbSelectArea("PAA")
_cQuery := "DELETE FROM " + RetSqlName("PAA") + " WHERE PAA_USER = '" + __cUserId + "' "
Begin Transaction
TCSQLExec(_cQuery)
End Transaction


For nY := 1 To 2
	For nX := Val(MV_PAR03) To Val(MV_PAR02) Step -1
		If MV_PAR04 == 2
			_cQuery := "SELECT D2_FILIAL AS FILIAL , '" + IIF(nY = 1,'Pneus ','Camaras ') + " " + Alltrim(Str(nX)) + "' AS GRUP,	" + Chr(13)
			_cQuery += "		'" + IIF(nY = 1,'Pneus ','Camaras ') + " ' || NVL2(Z16.Z16_MARCA,SZ5A.Z5_DESC,SZ5B.Z5_DESC) AS MARCA,   	" + Chr(13)
			_cQuery += "       SUBSTR(SD2.D2_EMISSAO,5,2) AS MES,                           " + Chr(13)
			_cQuery += "       SUM(SD2.D2_QUANT) AS QUANT                                   " + Chr(13)
			_cQuery += "FROM " + RetSqlName("SD2") + " SD2                                  " + Chr(13)
			_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '    " + Chr(13)
			_cQuery += "                         AND SB1.B1_COD = SD2.D2_COD                " + Chr(13)
			_cQuery += "                         AND SB1.D_E_L_E_T_ = ' '                   " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("Z16") + " Z16 ON Z16.Z16_FILIAL = '  '    " + Chr(13)
			_cQuery += "                         AND Z16.Z16_PROD = SB1.B1_COD              " + Chr(13)
			_cQuery += "                         AND Z16.D_E_L_E_T_ = ' '                   " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("SZ5") + " SZ5A ON SZ5A.Z5_FILIAL = '  '   " + Chr(13)
			_cQuery += "                         AND SZ5A.Z5_CODIGO = Z16.Z16_MARCA         " + Chr(13)
			_cQuery += "                         AND SZ5A.D_E_L_E_T_ = ' '                  " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("SZ5") + " SZ5B ON SZ5B.Z5_FILIAL = '  '   " + Chr(13)
			_cQuery += "                         AND SZ5B.Z5_CODIGO = SB1.B1__MARCA         " + Chr(13)
			_cQuery += "                         AND SZ5B.D_E_L_E_T_ = ' '                  " + Chr(13)
			_cQuery += "WHERE SD2.D_E_L_E_T_ = ' '                                          " + Chr(13)
			_cQuery += "      AND SB1.B1_GRUPO IN ('8','18')                                " + Chr(13)
			_cQuery += "      AND SB1.B1_TIPO = '" + IIF(nY = 1,'PN','CA') + "'   			" + Chr(13)
			_cQuery += "      AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + Alltrim(Str(nX)) + "'   " + Chr(13)
			If(!Empty(MV_PAR01))
				_cQuery += "      AND SD2.D2_FILIAL = '" + MV_PAR01 + "'   					" + Chr(13)
			EndIf
			_cQuery += "GROUP BY D2_FILIAL , NVL2(Z16.Z16_MARCA,SZ5A.Z5_DESC,SZ5B.Z5_DESC), " + Chr(13)
			_cQuery += "         SUBSTR(SD2.D2_EMISSAO,5,2)                                 " + Chr(13)
			_cQuery += "ORDER BY D2_FILIAL, MARCA ASC,                                      " + Chr(13)
			_cQuery += "         MES ASC                                                    "
		Else
			_cQuery := "SELECT D2_FILIAL AS FILIAL , '" + IIF(nY = 1,'Pneus ','Camaras ') + "' AS GRUP,			" + Chr(13)
			_cQuery += "		SUBSTR(SD2.D2_EMISSAO,1,4) AS MARCA,   						" + Chr(13)
			_cQuery += "       SUBSTR(SD2.D2_EMISSAO,5,2) AS MES,                           " + Chr(13)
			_cQuery += "       SUM(SD2.D2_QUANT) AS QUANT                                   " + Chr(13)
			_cQuery += "FROM " + RetSqlName("SD2") + " SD2                                  " + Chr(13)
			_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '  '    " + Chr(13)
			_cQuery += "                         AND SB1.B1_COD = SD2.D2_COD                " + Chr(13)
			_cQuery += "                         AND SB1.D_E_L_E_T_ = ' '                   " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("Z16") + " Z16 ON Z16.Z16_FILIAL = '  '    " + Chr(13)
			_cQuery += "                         AND Z16.Z16_PROD = SB1.B1_COD              " + Chr(13)
			_cQuery += "                         AND Z16.D_E_L_E_T_ = ' '                   " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("SZ5") + " SZ5A ON SZ5A.Z5_FILIAL = '  '   " + Chr(13)
			_cQuery += "                         AND SZ5A.Z5_CODIGO = Z16.Z16_MARCA         " + Chr(13)
			_cQuery += "                         AND SZ5A.D_E_L_E_T_ = ' '                  " + Chr(13)
			_cQuery += "LEFT JOIN " + RetSqlName("SZ5") + " SZ5B ON SZ5B.Z5_FILIAL = '  '   " + Chr(13)
			_cQuery += "                         AND SZ5B.Z5_CODIGO = SB1.B1__MARCA         " + Chr(13)
			_cQuery += "                         AND SZ5B.D_E_L_E_T_ = ' '                  " + Chr(13)
			_cQuery += "WHERE SD2.D_E_L_E_T_ = ' '                                          " + Chr(13)
			_cQuery += "      AND SB1.B1_GRUPO IN ('8','18')                                " + Chr(13)
			_cQuery += "      AND SB1.B1_TIPO = '" + IIF(nY = 1,'PN','CA') + "'   			" + Chr(13)
			_cQuery += "      AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + Alltrim(Str(nX)) + "'   " + Chr(13)
			If(!Empty(MV_PAR01))
				_cQuery += "      AND SD2.D2_FILIAL = '" + MV_PAR01 + "'   					" + Chr(13)
			EndIf
			_cQuery += "GROUP BY D2_FILIAL, SUBSTR(SD2.D2_EMISSAO,1,4),    					" + Chr(13)
			_cQuery += "         SUBSTR(SD2.D2_EMISSAO,5,2)                                 " + Chr(13)
			_cQuery += "ORDER BY D2_FILIAL, MARCA ASC,                                      " + Chr(13)
			_cQuery += "         MES ASC                                                    "
		EndIf
		
		If Select("TRB_SD2") <> 0
			TRB_SD2->(dbCloseArea())
		Endif
		
		TcQuery _cQuery New Alias "TRB_SD2"
		
		TRB_SD2->(DbGoTop())
		
		While !Eof("TRB_SD2")
			
			If Eof("TRB_SD2")
				Exit
			EndIf
			
			dbSelectArea("PAA")
			dbSetOrder(1)
			if dbSeek( PADR(TRB_SD2->FILIAL,TamSX3("PAA_FILIAL")[1]) + __cUserId + PADR(TRB_SD2->GRUP,TamSX3("PAA_DESC1")[1]) + PADR(TRB_SD2->MARCA,TamSX3("PAA_DESC2")[1]) )
				
				RecLock("PAA",.F.)
				If TRB_SD2->MES == "01"
					PAA_JAN   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "02"
					PAA_FEV   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "03"
					PAA_MAR   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "04"
					PAA_ABR   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "05"
					PAA_MAI   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "06"
					PAA_JUN   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "07"
					PAA_JUL   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "08"
					PAA_AGO   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "09"
					PAA_SET   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "10"
					PAA_OUT   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "11"
					PAA_NOV   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "12"
					PAA_DEZ   	:= TRB_SD2->QUANT
				EndIf
				PAA->(MsUnlock())
				
			Else
				
				RecLock("PAA",.T.)
				PAA_FILIAL	:= TRB_SD2->FILIAL
				PAA_USER 	:= __cUserId
				PAA_DESC1	:= TRB_SD2->GRUP
				PAA_DESC2	:= TRB_SD2->MARCA
				If TRB_SD2->MES == "01"
					PAA_JAN   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "02"
					PAA_FEV   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "03"
					PAA_MAR   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "04"
					PAA_ABR   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "05"
					PAA_MAI   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "06"
					PAA_JUN   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "07"
					PAA_JUL   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "08"
					PAA_AGO   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "09"
					PAA_SET   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "10"
					PAA_OUT   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "11"
					PAA_NOV   	:= TRB_SD2->QUANT
				ElseIf TRB_SD2->MES == "12"
					PAA_DEZ   	:= TRB_SD2->QUANT
				EndIf
				PAA->(MsUnlock())
				
			EndIf
			
			dbSelectArea("TRB_SD2")
			DbSkip()
			
		EndDo
		
		TRB_SD2->(DbCloseArea())
		
	Next nX
	
Next nY


//------------------------------------------------------------------------------------------------------

cOptions := "1;0;1;Relatório de venda média por Pneu e Camara"

cParams := __cUserID + ";"
cParams += Alltrim(Str(MV_PAR04)) + ";"

CallCrys('ICOMCR12',cParams,cOptions)

Return
