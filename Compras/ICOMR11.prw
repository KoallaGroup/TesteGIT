#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMR11 | Autor: | Rubens Cruz        | Data: | Mar�o/2015   |
+------------+---------+--------+--------------------+-------+--------------+
| Descri��o: | Relat�rio de Planilha de Embarque                            |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMR11()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""

Private cPerg 	:= PADR("ICOMR11",Len(SX1->X1_GRUPO))
              
Aadd(aPergs,{"Filial"			,"","","mv_ch1","C",TamSx3("Z2_FILIAL")[1]	,0,0,"G","Empty(MV_PAR01) .OR. existCpo('SM0',cEmpAnt+MV_PAR01)","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"		,"","","",""})
Aadd(aPergs,{"Fornecedor De"	,"","","mv_ch2","C",TamSx3("A2_COD")[1]		,0,0,"G",""														,"MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA2"		,"","","",""})
Aadd(aPergs,{"Fornecedor At�"	,"","","mv_ch3","C",TamSx3("A2_COD")[1]		,0,0,"G",""														,"MV_PAR03","","","","ZZZZZZZZZZZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SA2"		,"","","",""})
Aadd(aPergs,{"Loja De"			,"","","mv_ch4","C",TamSx3("A2_LOJA")[1]	,0,0,"G",""														,"MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA2LJA"	,"","","",""})
Aadd(aPergs,{"Loja At�"	 		,"","","mv_ch5","C",TamSx3("A2_LOJA")[1]	,0,0,"G",""														,"MV_PAR05","","","","ZZZZ"				,"","","","","","","","","","","","","","","","","","","","","SA2LJA"	,"","","",""})
Aadd(aPergs,{"Produto De"		,"","","mv_ch6","C",TamSx3("B1_COD")[1]		,0,0,"G",""														,"MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","","SB1"		,"","","",""})
Aadd(aPergs,{"Produto At�"		,"","","mv_ch7","C",TamSx3("B1_COD")[1]		,0,0,"G",""														,"MV_PAR07","","","","ZZZZZZZZZZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SB1"		,"","","",""})
Aadd(aPergs,{"Dt. Pedido De"	,"","","mv_ch8","D",08						,0,0,"G",""														,"MV_PAR08","","","",""					,"","","","","","","","","","","","","","","","","","","","",""			,"","","",""})
Aadd(aPergs,{"Dt. Pedido At�"	,"","","mv_ch9","D",08						,0,0,"G",""														,"MV_PAR09","","","",""					,"","","","","","","","","","","","","","","","","","","","",""			,"","","",""})
Aadd(aPergs,{"Pedido De"		,"","","mv_cha","C",TamSx3("Z2_CODIGO")[1]	,0,0,"G",""														,"MV_PAR10","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ2"		,"","","",""})
Aadd(aPergs,{"Pedido At�"		,"","","mv_chb","C",TamSx3("Z2_CODIGO")[1]	,0,0,"G",""														,"MV_PAR11","","","","ZZZZZZ"			,"","","","","","","","","","","","","","","","","","","","","SZ2"		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

cParams += MV_PAR01 		+ ";"
cParams += MV_PAR02 		+ ";"
cParams += MV_PAR03 		+ ";"
cParams += MV_PAR04 		+ ";"
cParams += MV_PAR05 		+ ";"
cParams += MV_PAR06 		+ ";"
cParams += MV_PAR07 		+ ";"
cParams += DTOS(MV_PAR08)	+ ";"
cParams += DTOS(MV_PAR09) 	+ ";"
cParams += MV_PAR10		 	+ ";"
cParams += MV_PAR11 		+ ";"

cOptions := "1;0;1;Relat�rio De Planilha De Embarque"

CallCrys('ICOMCR11',cParams,cOptions)

Return 