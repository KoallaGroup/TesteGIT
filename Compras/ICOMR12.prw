#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'
#include "topconn.ch"

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMR12 | Autor: | Rubens Cruz        | Data: | Abril/2015   |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de venda média por Pneu e Camara                   |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMR12()
Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local _cQuery	:= ""
Local _aResul	:= {}
Local _aBloc	:= {}
Local _cFil		:= ""

Private cPerg 	:= PADR("ICOMR12",Len(SX1->X1_GRUPO))
              
Aadd(aPergs,{"Filial"	,"","","mv_ch1","C",TamSx3("Z2_FILIAL")[1]	,0,0,"G","Empty(MV_PAR01) .OR. existCpo('SM0',cEmpAnt+MV_PAR01)","MV_PAR01",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Ano De"	,"","","mv_ch2","C",04						,0,0,"G",""														,"MV_PAR02",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ano Até"	,"","","mv_ch3","C",04						,0,0,"G",""														,"MV_PAR03",""			,"","","","",""			,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo"		,"","","mv_ch4","N",01						,0,0,"C",""														,"MV_PAR04","Sintetico"	,"","","","","Analitico","","","","","","","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

If Empty(MV_PAR01)
	_cFil := "Todos"
Else
	_cFil := MV_PAR01
EndIf	

For nY := 1 To 2
	For nX := Val(MV_PAR03) To Val(MV_PAR02) Step -1
		If MV_PAR04 == 2
			_cQuery := "SELECT '" + IIF(nY = 1,'Pneus ','Camaras ') + " " + Alltrim(Str(nX)) + "' AS GRUP,	" + Chr(13)
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
	   		_cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_CODIGO = SD2.D2_TES  " + Chr(13)
	  		_cQuery += "                         AND  SF4.F4_ESTOQUE = 'S'  					" + Chr(13)	
	  		_cQuery += "                         AND  SF4.D_E_L_E_T_ = ' '						" + Chr(13)
			_cQuery += "                         AND SF4.F4_FILIAL = SD2.D2_FILIAL		   		" + Chr(13) 
	  		_cQuery += "                         AND  SF4.F4_DUPLIC = 'S'  				   		" + Chr(13)	
			_cQuery += "WHERE SD2.D_E_L_E_T_ = ' '                                          " + Chr(13)
//			_cQuery += "      AND SB1.B1_GRUPO IN ('8','18')                                " + Chr(13)
			_cQuery += "      AND SB1.B1_TIPO = '" + IIF(nY = 1,'PN','CA') + "'   			" + Chr(13)
			_cQuery += "      AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + Alltrim(Str(nX)) + "'   " + Chr(13)
			If(!Empty(MV_PAR01))
				_cQuery += "      AND SD2.D2_FILIAL = '" + MV_PAR01 + "'   					" + Chr(13)
			EndIf
			_cQuery += "GROUP BY NVL2(Z16.Z16_MARCA,SZ5A.Z5_DESC,SZ5B.Z5_DESC),             " + Chr(13)
			_cQuery += "         SUBSTR(SD2.D2_EMISSAO,5,2)                                 " + Chr(13)
			_cQuery += "ORDER BY MARCA ASC,                                                 " + Chr(13)
			_cQuery += "         MES ASC                                                    "
		Else
			_cQuery := "SELECT '" + IIF(nY = 1,'Pneus ','Camaras ') + "' AS GRUP,			" + Chr(13)
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
	   		_cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON SF4.F4_CODIGO = SD2.D2_TES  " + Chr(13)
	  		_cQuery += "                         AND  SF4.F4_ESTOQUE = 'S'  					" + Chr(13)	
	  		_cQuery += "                         AND  SF4.D_E_L_E_T_ = ' '						" + Chr(13)
			_cQuery += "                         AND SF4.F4_FILIAL = SD2.D2_FILIAL		   		" + Chr(13) 
	  		_cQuery += "                         AND  SF4.F4_DUPLIC = 'S'  				   		" + Chr(13)				
			_cQuery += "WHERE SD2.D_E_L_E_T_ = ' '                                          " + Chr(13)
//			_cQuery += "      AND SB1.B1_GRUPO IN ('8','18')                                " + Chr(13)
			_cQuery += "      AND SB1.B1_TIPO = '" + IIF(nY = 1,'PN','CA') + "'   			" + Chr(13)
			_cQuery += "      AND SUBSTR(SD2.D2_EMISSAO,1,4) = '" + Alltrim(Str(nX)) + "'   " + Chr(13)
			If(!Empty(MV_PAR01))
				_cQuery += "      AND SD2.D2_FILIAL = '" + MV_PAR01 + "'   					" + Chr(13)
			EndIf
			_cQuery += "GROUP BY SUBSTR(SD2.D2_EMISSAO,1,4),             					" + Chr(13)
			_cQuery += "         SUBSTR(SD2.D2_EMISSAO,5,2)                                 " + Chr(13)
			_cQuery += "ORDER BY MARCA ASC,                                                 " + Chr(13)
			_cQuery += "         MES ASC                                                    "
		EndIf
		TcQuery _cQuery New Alias "TRB_SD2"
		                                                                                                        
		If !Eof() 
			_aBloc := {}
			While !Eof()
		    	If(ASCAN(_aBloc, { |x| AllTrim(x[2]) == Alltrim(TRB_SD2->MARCA) })) = 0
					AADD(_aBloc,{TRB_SD2->GRUP,;
								 TRB_SD2->MARCA,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0,;
								 0})	
				EndIf
			    TRB_SD2->(DbSkip())
		    EndDo
		
			TRB_SD2->(DbGoTop())
		
			While !Eof()
		       	_aBloc[ASCAN(_aBloc, { |x| AllTrim(x[2]) == Alltrim(TRB_SD2->MARCA) })][Val(TRB_SD2->MES)+2] := TRB_SD2->QUANT
			    TRB_SD2->(DbSkip())
		    EndDo
		    
			For nZ := 1 To Len(_aBloc)
		    	AADD(_aResul,_aBloc[nZ])
			Next nZ
					    
		EndIf              
	    
		TRB_SD2->(DbCloseArea())
	
	Next nX
Next nY

DbSelectArea("PAA")    

//Apaga registros antigos da tabela PA2
_cQuery := "DELETE FROM " + RetSqlName("PAA") + " WHERE PAA_USER = '" + __cUserId + "' "
Begin Transaction
TCSQLExec(_cQuery)
End Transaction

For nX := 1 To Len(_aResul)
	RecLock("PAA",.T.)
		PAA_USER 	:= __cUserId
		PAA_DESC1	:= _aResul[nX][01] 
		PAA_DESC2	:= _aResul[nX][02] 
		PAA_JAN   	:= _aResul[nX][03] 
		PAA_FEV   	:= _aResul[nX][04] 
		PAA_MAR   	:= _aResul[nX][05] 
		PAA_ABR   	:= _aResul[nX][06] 
		PAA_MAI   	:= _aResul[nX][07] 
		PAA_JUN   	:= _aResul[nX][08] 
		PAA_JUL   	:= _aResul[nX][09] 
		PAA_AGO   	:= _aResul[nX][10] 
		PAA_SET   	:= _aResul[nX][11] 
		PAA_OUT   	:= _aResul[nX][12] 
		PAA_NOV   	:= _aResul[nX][13] 
		PAA_DEZ   	:= _aResul[nX][14] 
	PAA->(MsUnlock())
Next nX

//------------------------------------------------------------------------------------------------------

cOptions := "1;0;1;Relatório de venda média por Pneu e Camara"

cParams := __cUserID + ";"  		
cParams += Alltrim(Str(MV_PAR04)) + ";" 
cParams += _cFil


CallCrys('ICOMCR12',cParams,cOptions)

Return