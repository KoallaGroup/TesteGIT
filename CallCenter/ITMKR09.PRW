#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR09 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de vendas por Representante/SubGrupo               |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKR09()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cTpOper	:= ""

Private cPerg 	:= PADR("ITMKR09",Len(SX1->X1_GRUPO))
              
dbSelectArea("SAU")

Aadd(aPergs,{"Filial De"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Filial Até"			,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Representante De"		,"","","mv_ch3","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Representante Até"	,"","","mv_ch4","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Data De"				,"","","mv_ch5","D",08						,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Data Até"				,"","","mv_ch6","D",08						,0,0,"G","","MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Sub-Grupo De"			,"","","mv_ch7","C",TamSx3("B1__SUBGRP")[1]	,0,0,"G","","MV_PAR07","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ4"	,"","","",""})
Aadd(aPergs,{"Sub-Grupo Até"		,"","","mv_ch8","C",TamSx3("B1__SUBGRP")[1]	,0,0,"G","","MV_PAR08","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ4"	,"","","",""})
Aadd(aPergs,{"Identificação De"		,"","","mv_ch9","C",TamSx3("Z8_COD")[1]		,0,0,"G","","MV_PAR09","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ8"	,"","","",""})
Aadd(aPergs,{"Identificação Até"	,"","","mv_chA","C",TamSx3("Z8_COD")[1]		,0,0,"G","","MV_PAR10","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ8"	,"","","",""})
Aadd(aPergs,{"Tp.Op. Ativo"			,"","","mv_chB","C",01						,0,0,"C","","MV_PAR11","SIM","","",""				,"","NAO","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. Receptivo"		,"","","mv_chC","C",01						,0,0,"C","","MV_PAR12","SIM","","",""				,"","NAO","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. Fax"			,"","","mv_chD","C",01						,0,0,"C","","MV_PAR13","SIM","","",""				,"","NAO","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. Representante"	,"","","mv_chE","C",01						,0,0,"C","","MV_PAR14","SIM","","",""				,"","NAO","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Tp.Op. Direto"		,"","","mv_chF","C",01						,0,0,"C","","MV_PAR15","SIM","","",""				,"","NAO","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

If MV_PAR11 = 1
	cTpOper 	:= cTpOper + "1,"
EndIf
If MV_PAR12 = 1
	cTpOper 	:= cTpOper + "2,"
EndIf
If MV_PAR13 = 1
	cTpOper 	:= cTpOper + "3,"
EndIf
If MV_PAR14 = 1
	cTpOper 	:= cTpOper + "4,"
EndIf
If MV_PAR15 = 1
	cTpOper 	:= cTpOper + "5,"
EndIf

cTpOper := FormatIn(cTpOper,",")

cParams += MV_PAR01 		+ ";"
cParams += MV_PAR02 		+ ";"
cParams += MV_PAR03 		+ ";"
cParams += MV_PAR04 		+ ";"
cParams += DTOS(MV_PAR05) 	+ ";"
cParams += DTOS(MV_PAR06) 	+ ";"
cParams += MV_PAR07 		+ ";"
cParams += MV_PAR08 		+ ";"
cParams += MV_PAR09 		+ ";"
cParams += MV_PAR10 		+ ";"
cParams += cTpOper

cOptions := "1;0;1;Relatório de Vendas por SubGrupo"

CallCrys('ITMKCR09',cParams,cOptions)

Return .T. 