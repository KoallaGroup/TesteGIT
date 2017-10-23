#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR14 | Autor: | Rubens Cruz        | Data: | Março/2015 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Depósito a classificar			             |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------------------------------------------+
*/

User Function IFINR14() 
Local cPerg		:= PADR("IFINR14",Len(SX1->X1_GRUPO))  
Local aPergs 	:= {}
Local cOptions 	:= "1;0;1;Relatório de Depósito a classificar"
Local cParams	:= ""
Local cCliente	:= GetMV("MV__CLIDEP")

Aadd(aPergs,{"Data De "		,"","","mv_ch1","D",08						,0,0,"G",""												,"MV_PAR01",""			,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","",""     	,"","","",""})
Aadd(aPergs,{"Data Ate "	,"","","mv_ch2","D",08						,0,0,"G",""												,"MV_PAR02",""			,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","",""     	,"","","",""})
Aadd(aPergs,{"Filial "		,"","","mv_ch3","C",TamSx3("A1_FILIAL")[1]	,0,0,"G","Vazio() .OR. ExistCpo('SM0',cEmpAnt+MV_PAR03)","MV_PAR03",""			,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Banco "		,"","","mv_ch4","C",TamSx3("A6_COD")[1]		,0,0,"G","Vazio() .OR. ExistCpo('SA6')"					,"MV_PAR04",""			,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","","SA6BCO","","","",""})
Aadd(aPergs,{"Modelo " 		,"","","mv_ch5","N",01 						,0,0,"C",""												,"MV_PAR05","Analitico"	,"","","","","Sintético"	,"","","","",""			,"","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo"			,"","","mv_ch6","N",01						,0,0,"C",""												,"MV_PAR06","Em Aberto"	,"","","","","Encerrados"	,"","","","","Ambos"	,"","","","","","","","","","","","","",""		,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.T.)
	Return
EndIf    

cParams := cCliente + ";"
cParams += DTOS(MV_PAR01) + ";"
cParams += DTOS(MV_PAR02) + ";"
cParams += MV_PAR03 + ";"
cParams += MV_PAR04 + ";"
cParams += Alltrim(Str(MV_PAR06)) + ";"

If(MV_PAR05 = 1)
	CallCrys('IFINCR11A', cParams,cOptions)
Else
	CallCrys('IFINCR11B', cParams,cOptions)
EndIf

Return