#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | IFATR04 | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Relatório de vendas por UF - Com filtro de Marca             |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function IFATR04()

Local aPergs	:= {}   
Local cParams	:= ""
Local cOptions	:= ""
Local cMarcaDe	:= "    "
Local cMarcaAte	:= "ZZZZ"
Local aSM0 		:= FWLoadSM0()
Local aCGC		:= ""
Local dMesDe	:= ""
Local dMesAte	:= ""
Local dAnoDe	:= ""
Local dAnoAte	:= ""

Private cPerg 	:= PADR("IFATR04",Len(SX1->X1_GRUPO))

For x:=1 to Len(aSM0)
	aCGC := aCGC + aSM0[x][18]
	If x != Len(aSM0)
		aCGC := aCGC + ","
	EndIf
Next
	
aCGC := FormatIn(aCGC,",")

//aCGC := STRTRAN(aCGC, '"', "'")

dbSelectArea("SD2")

Aadd(aPergs,{"Local De"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Local Até"		,"","","mv_ch2","C",02						,0,0,"G","","MV_PAR02","","","",""					,"","","","","","","","","","","","","","","","","","","","","DLB"	,"","","",""})
Aadd(aPergs,{"Marca"			,"","","mv_ch3","C",TamSx3("B1__MARCA")[1]	,0,0,"G","","MV_PAR03","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ5"	,"","","",""})
Aadd(aPergs,{"Segmento De"		,"","","mv_ch4","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR04","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Segmento Até"		,"","","mv_ch5","C",TamSx3("B1__SEGISP")[1]	,0,0,"G","","MV_PAR05","","","",""					,"","","","","","","","","","","","","","","","","","","","","SZ7"	,"","","",""})
Aadd(aPergs,{"Mês"				,"","","mv_ch6","C",02						,0,0,"G","","MV_PAR06","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Ano"				,"","","mv_ch7","C",04						,0,0,"G","","MV_PAR07","","","",""					,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
Aadd(aPergs,{"Tipo Relatório"	,"","","mv_ch8","C",01						,0,0,"C","","MV_PAR08","Por Local","","",""	  ,"","Por Empresa","","","","","","","","","","","","","","","","","","","","","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf

dMesDe 	:= Alltrim(MV_PAR07)+Alltrim(MV_PAR06)+"01"
dMesAte := Alltrim(MV_PAR07)+Alltrim(MV_PAR06)+"31"
dAnoDe	:= Alltrim(MV_PAR07)+"0101"
dAnoAte	:= Alltrim(MV_PAR07)+"1231"

If !Empty(MV_PAR11)
	cMarcaDe 	:= MV_PAR03
	cMarcaAte 	:= MV_PAR03
EndIf

cParams += MV_PAR01 		+ ";"	//Filial De
cParams += MV_PAR02 		+ ";"	//Filial Ate
cParams += cMarcaDe 		+ ";"	//Marca De
cParams += cMarcaAte 		+ ";"	//Marca Ate
cParams += MV_PAR04 		+ ";"	//Segmento De	
cParams += MV_PAR05 		+ ";"	//Segmento Ate
cParams += dMesDe	 		+ ";"	//Emissao1 De
cParams += dMesAte	 		+ ";" 	//Emissao1 Ate
cParams += dAnoDe	 		+ ";"	//Emissao2 De
cParams += dAnoAte	 		+ ";"	//Emissao2 Ate
cParams += aCGC						//CGC ISAPA

cOptions := "1;0;1;Relatório de vendas por UF"

If MV_PAR08 = 1
	CallCrys('IFATCR04A',cParams,cOptions)	//Por Local
ElseIf MV_PAR08 = 2
	CallCrys('IFATCR04B',cParams,cOptions)	//Por Empresa
Else
	MsgAlert("Tipo Relatório não selecionado.")	
EndIf	

Return .T. 