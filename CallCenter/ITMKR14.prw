#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | ITMKR14 | Autor: | Rubens Cruz      	 | Data: | Marco/2015   |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de vendas por Tipo de Operação/Operador            |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function ITMKR14()
Local aPergs	:= {}
Local cPerg		:= PADR("ITMKR14",Len(SX1->X1_GRUPO))

Aadd(aPergs,{"Filial De"		,"","","mv_ch1","C",TamSx3("UA_FILIAL")[1]	,0,0,"G","","MV_PAR01",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","","DLB","","","",""})
Aadd(aPergs,{"Filial Ate"		,"","","mv_ch2","C",TamSx3("UA_FILIAL")[1]	,0,0,"G","","MV_PAR02",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","","DLB","","","",""})
Aadd(aPergs,{"Data De"			,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Data Ate"			,"","","mv_ch4","D",08						,0,0,"G","","MV_PAR04",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Tipo"				,"","","mv_ch5","N",04	                    ,0,1,"C","","MV_PAR05","Operador"	,"","","","","Representante"	,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Detalhamento"		,"","","mv_ch6","N",08						,0,0,"C","","MV_PAR06","Sintetico"	,"","","","","Analitico"		,"","","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Representante De"	,"","","mv_ch7","C",TamSx3("UA_VEND")[1]  	,0,1,"G","","MV_PAR07",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","","SA3","","","",""})
Aadd(aPergs,{"Representante Ate","","","mv_ch8","C",TamSx3("UA_VEND")[1]    ,0,1,"G","","MV_PAR08",""			,"","","","",""					,"","","","","","","","","","","","","","","","","","","SA3","","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.T.)
	Return
EndIf

cOptions := "1;0;1;Relatório de vendas por Tipo de Operação/Operador"

cParams := DTOS(MV_PAR03)	+ ";"	//Data De
cParams += DTOS(MV_PAR04)	+ ";"	//Data Ate
cParams += MV_PAR01 		+ ";"	//Filial De
cParams += MV_PAR02 		+ ";"	//Filial Ate
cParams += U_SETSEGTO()		+ ";"	//Segmento 
If(MV_PAR05 = 2)
	cParams += MV_PAR07		+ ";" 	//Representante De
	cParams += MV_PAR08		+ ";"	//Representante Ate
EndIf    

Do Case
	Case MV_PAR05 = 1 .AND. MV_PAR06 = 1 //Operador Sintetico
		CallCrys('ITMKR14A',cParams,cOptions)	
	Case MV_PAR05 = 1 .AND. MV_PAR06 = 2 //Operador Analitico
		CallCrys('ITMKR14E',cParams,cOptions)	
	Case MV_PAR05 = 2 .AND. MV_PAR06 = 1 //Representante Sintetico
		CallCrys('ITMKR14C',cParams,cOptions)	
	Case MV_PAR05 = 2 .AND. MV_PAR06 = 2 //Representante Analitico
		CallCrys('ITMKR14D',cParams,cOptions)	
EndCase


Return