#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ICOMR05 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de Embarque                                        |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ICOMR05()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cExcel	:= ""
Local aFil		:= ""
Local aEmp		:= ""

Private cPerg 	:= PADR("ICOMR05",Len(SX1->X1_GRUPO))
              
dbSelectArea("SZ2")

Aadd(aPergs,{"Da Filial"		,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Ate Filial"		,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","","ZZ"				,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Do Fornecedor"	,"","","mv_ch3","C",TamSx3("A2_COD")[1]		,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA2"	,"","","",""})
Aadd(aPergs,{"Até Fornecedor"	,"","","mv_ch4","C",TamSx3("A2_COD")[1]		,0,0,"G","","MV_PAR04","","","","ZZZZZZZZZZZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SA2"	,"","","",""})
Aadd(aPergs,{"Da Loja"			,"","","mv_ch5","C",TamSx3("A2_LOJA")[1]	,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até Loja"	 		,"","","mv_ch6","C",TamSx3("A2_LOJA")[1]	,0,0,"G","","MV_PAR06","","","","ZZZZ"				,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Item"			,"","","mv_ch7","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR07","","","",""					,"","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
Aadd(aPergs,{"Até Item"			,"","","mv_ch8","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR08","","","","ZZZZZZZZZZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
Aadd(aPergs,{"Da Dt. Entrega"	,"","","mv_ch9","D",08						,0,0,"G","","MV_PAR09","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até Dt. Entrega"	,"","","mv_chA","D",08						,0,0,"G","","MV_PAR10","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Pedido"		,"","","mv_chB","C",TamSx3("Z2_CODIGO")[1]	,0,0,"G","","MV_PAR11","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ2"	,"","","",""})
Aadd(aPergs,{"Até Pedido"		,"","","mv_chC","C",TamSx3("Z2_CODIGO")[1]	,0,0,"G","","MV_PAR12","","","","ZZZZZZ"			,"","","","","","","","","","","","","","","","","","","","","SZ2"	,"","","",""})

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
cParams += MV_PAR08 		+ ";"
cParams += DTOS(MV_PAR09) 	+ ";"
cParams += DTOS(MV_PAR10) 	+ ";"
cParams += MV_PAR11 		+ ";"
cParams += MV_PAR12

cOptions := "1;0;1;Relatório de Embarque"

CallCrys('ICOMCR05',cParams,cOptions)

Return .T. 