#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR16 | Autor: | Rubens Cruz        | Data: | Abril/2015 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Resumo da Movimentacao do Contas a Receber   |
|			 | Contabil										             |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------------------------------------------+
*/
                           
User Function IFINR16() 
Local cPerg		:= PADR("IFINR16",Len(SX1->X1_GRUPO))  
Local aPergs 	:= {}
Local cOptions 	:= "1;0;1;Relatório de Resumo da Movimentacao do Contas a Receber Contabil"
Local cParams	:= ""

Aadd(aPergs,{"Data De "		,"","","mv_ch1","D",08	,0,0,"G",""	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
Aadd(aPergs,{"Data Ate "	,"","","mv_ch2","D",08	,0,0,"G",""	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.T.)
	Return
EndIf    

cParams := DTOS(MV_PAR01) + ";"
cParams += DTOS(MV_PAR02) + ";"

CallCrys('IFINCR16', cParams,cOptions)

Return