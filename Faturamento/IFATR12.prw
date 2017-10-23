#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | IFATR12 | Autor: | Rogério Alves      | Data: |  Junho/2015  |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de visitas                                         |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function IFATR12()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cData		:= ""

Private cPerg 	:= PADR("IFATR12",Len(SX1->X1_GRUPO))

Aadd(aPergs,{"Segmento    	","","","mv_ch1","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR01",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SZ72"	,"","","",""})
Aadd(aPergs,{"Vendedor De 	","","","mv_ch2","C",TamSx3("A3_COD")[1]		,0,0,"G","","MV_PAR02",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Vendedor Até	","","","mv_ch3","C",TamSx3("A3_COD")[1]		,0,0,"G","","MV_PAR03",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3"	,"","","",""})
Aadd(aPergs,{"Data Até		","","","mv_ch4","D",08 						,0,0,"G","","MV_PAR04",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Por Equipe	","","","mv_ch5","C",01							,0,0,"C","","MV_PAR05","Sim","","","","","Não"	,"","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Equipe De		","","","mv_ch6","C",TamSx3("ACA_GRPREP")[1]	,0,0,"G","","MV_PAR06",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","ACA"	,"","","",""})
Aadd(aPergs,{"Equipe Até	","","","mv_ch7","C",TamSx3("ACA_GRPREP")[1]	,0,0,"G","","MV_PAR07",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","ACA"	,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

cParams += MV_PAR01 				+ ";"
cParams += MV_PAR02 				+ ";"
cParams += MV_PAR03 				+ ";"
cParams += DTOC(MV_PAR04)			+ ";"
cParams += Alltrim(STR(MV_PAR05))	+ ";"
cParams += MV_PAR06 				+ ";"
cParams += MV_PAR07

cOptions := "1;0;1;Resumo de visita"

If MV_PAR05 = 1
	CallCrys('IFATCR02',cParams,cOptions)
ElseIf MV_PAR05 = 2
	CallCrys('IFATCR02B',cParams,cOptions)
Else
	MsgAlert("Tipo Relatório não selecionado.")	
EndIf	

Return