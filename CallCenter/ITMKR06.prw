#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR06 | Autor: | Rog�rio Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descri��o: | Relat�rio de Manifesta��o por Tempo M�dio                    |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKR06()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""

Private cPerg 	:= PADR("ITMKR06",Len(SX1->X1_GRUPO))
              
dbSelectArea("ADE")

Aadd(aPergs,{"Filial"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Per�odo De"		,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Per�odo At�"		,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Refer�ncia De"	,"","","mv_ch4","C",TamSx3("U9_CODIGO")[1]	,0,0,"G","","MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SU9"	,"","","",""})
Aadd(aPergs,{"Refer�ncia At�"	,"","","mv_ch5","C",TamSx3("U9_CODIGO")[1]	,0,0,"G","","MV_PAR05","","","","ZZZZZZ"			,"","","","","","","","","","","","","","","","","","","","","SU9"	,"","","",""})
Aadd(aPergs,{"Anal�tico ?"		,"","","mv_ch6","C",01						,0,0,"C","","MV_PAR06","SIM","","",""				,"","N�O","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

cParams += MV_PAR01 		+ ";"
cParams += DTOS(MV_PAR02) 	+ ";"
cParams += DTOS(MV_PAR03) 	+ ";"
cParams += MV_PAR04 		+ ";"
cParams += MV_PAR05

cOptions := "1;0;1;Relat�rio de Manifesta��o por Tempo M�dio"

If MV_PAR06 == 1
	CallCrys('ITMKCR06A',cParams,cOptions)
Else
	CallCrys('ITMKCR06B',cParams,cOptions)
EndIf

Return .T. 