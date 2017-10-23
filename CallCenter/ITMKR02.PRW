#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR02 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de Manifestação por Item                           |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKR02()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cExcel	:= ""
Local aFil		:= ""
Local aEmp		:= ""

Private cPerg 	:= PADR("ITMKR02",Len(SX1->X1_GRUPO))
              
dbSelectArea("ADE")

Aadd(aPergs,{"Filial"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Segmento"			,"","","mv_ch2","C",TamSx3("Z7_CODIGO")[1]	,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Da Área"			,"","","mv_ch3","C",TamSx3("U0_CODIGO")[1]	,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SU0"	,"","","",""})
Aadd(aPergs,{"Até Área"			,"","","mv_ch4","C",TamSx3("U0_CODIGO")[1]	,0,0,"G","","MV_PAR04","","","","ZZ"				,"","","","","","","","","","","","","","","","","","","","","SU0"	,"","","",""})
Aadd(aPergs,{"Da Data"			,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Até Data"			,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Do Item"			,"","","mv_ch7","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR07","","","",""					,"","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})
Aadd(aPergs,{"Até Item"			,"","","mv_ch8","C",TamSx3("B1_COD")[1]		,0,0,"G","","MV_PAR08","","","","ZZZZZZZZZZZZZZZ"	,"","","","","","","","","","","","","","","","","","","","","SB1"	,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

cParams += MV_PAR01 		+ ";"
cParams += MV_PAR02 		+ ";"
cParams += MV_PAR03 		+ ";"
cParams += MV_PAR04 		+ ";"
cParams += DTOS(MV_PAR05) 	+ ";"
cParams += DTOS(MV_PAR06) 	+ ";"
cParams += MV_PAR07 		+ ";"
cParams += MV_PAR08

cOptions := "1;0;1;Pagamentos Indicados"

CallCrys('ITMKCR02',cParams,cOptions)

Return .T. 