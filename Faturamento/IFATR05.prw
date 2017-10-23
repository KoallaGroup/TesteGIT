#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | IFATR05 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de vendas por UF - Sem filtro de Marca             |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function IFATR05()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local aSM0 		:= FWLoadSM0()
Local aCGC		:= ""
Local dMesDe	:= ""
Local dMesAte	:= ""
Local dAnoDe	:= ""
Local dAnoAte	:= ""

Private cPerg 	:= PADR("IFATR05",Len(SX1->X1_GRUPO))

For x:=1 to Len(aSM0)
	aCGC := aCGC + aSM0[x][18]
	If x != Len(aSM0)
		aCGC := aCGC + ","
	EndIf
Next
	
aCGC := FormatIn(aCGC,",")
	              
dbSelectArea("SD2")

Aadd(aPergs,{"Local De"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Local Até"		,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Segmento De"		,"","","mv_ch3","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Segmento Até"		,"","","mv_ch4","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Mês"				,"","","mv_ch5","C",02						,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ano"				,"","","mv_ch6","C",04						,0,0,"G","","MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo Relatório"	,"","","mv_ch7","C",01						,0,0,"C","","MV_PAR07","Por Local","","",""	  ,"","Por Empresa","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

dMesDe 	:= Alltrim(MV_PAR06)+Alltrim(MV_PAR05)+"01"
dMesAte := Alltrim(MV_PAR06)+Alltrim(MV_PAR05)+"31"
dAnoDe	:= Alltrim(MV_PAR06)+"0101"
dAnoAte	:= Alltrim(MV_PAR06)+"1231"

cParams += MV_PAR01 		+ ";"	//01
cParams += MV_PAR02 		+ ";"	//02
cParams += MV_PAR03 		+ ";"	//05
cParams += MV_PAR04 		+ ";"	//06
cParams += dMesDe	 		+ ";"	//07	
cParams += dMesAte	 		+ ";" 	//08
cParams += dAnoDe	 		+ ";"	//09
cParams += dAnoAte	 		+ ";"	//10
cParams += aCGC						//11

cOptions := "1;0;1;Relatório de vendas por UF"

If MV_PAR07 = 1
	CallCrys('IFATCR05A',cParams,cOptions)	//Por Local
ElseIf MV_PAR07 = 2
	CallCrys('IFATCR05B',cParams,cOptions)	//Por Empresa
Else
	MsgAlert("Tipo Relatório não selecionado.")	
EndIf	

Return .T. 