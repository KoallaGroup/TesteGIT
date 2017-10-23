#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOPCONN.CH"

#DEFINE ENTER CHR(13)+CHR(10)

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFATR17			  		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de Faturamento Mensal 											  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFATR17()

Private aArray := {}, aNotas := {}
Private cNf    := cVend  := ""
Private nAux   := nCont  := nContT := nRep := nRepSt := nTot := nTotSt := nTotT := nTotTSt := 0
Private oReport
Private aArrax := {}
Private nSubAux := 31

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : REPORTDEF		 		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Relatório de Faturamento Mensal 											  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ReportDef()

Local cReport 	:= "IFATR17"
Local cDescri 	:= "Este programa tem como objetivo imprimir Relação Faturamento Mensal"
Local cTitulo 	:= "Relação Faturamento Mensal"
Local cPerg		:= "IFATR17"

ValidPerg(cPerg)
Pergunte(cPerg,.T.)

oReport := TReport():New(cReport, cTitulo, cPerg, {|oReport| ReportPrint(oReport)}, cDescri)
oReport:nfontbody:=8
oReport:cfontbody:="Courier New"
//oReport:SetPortrait()
oReport:SetLandscape()
  
oSection1 := TRSection():New(oReport)
TRCell():New(oSection1, "A"	,"" ,"Local" 				,"@!" 							,TamSx3("F2_FILIAL")[1]  ,,{|| aArray[i][1]})
TRCell():New(oSection1, "B"	,"" ,"Segmento" 			,"@!" 							,TamSx3("A3__SEGISP")[1] ,,{|| aArray[i][2]})
TRCell():New(oSection1, "C"	,"" ,"Repres." 				,"@!" 							,TamSx3("A3_COD")[1]     ,,{|| aArray[i][3]})
TRCell():New(oSection1, "D"	,"" ,"Cliente" 				,"@!" 							,TamSx3("A1_COD")[1]+10     ,,{|| aArray[i][4]})
TRCell():New(oSection1, "E"	,"" ,"Nome" 				,"@!" 							,TamSx3("A1_NOME")[1]    ,,{|| aArray[i][5]})
TRCell():New(oSection1, "F"	,"" ,"Numero Notas Fiscais" ,"@!" 							,TamSx3("F2_DOC")[1]+60  ,,{|| aArray[i][6]})
TRCell():New(oSection1, "G"	,"" ,"Total Faturado" 		,PesqPict("SF2","F2_VALMERC") 	,TamSx3("F2_VALMERC")[1]+20 ,,{|| aArray[i][7]})
If MV_PAR09 == 1
	TRCell():New(oSection1, "H"	,"" ,"Total s/ St." 	,PesqPict("SF2","F2_VALBRUT") 	,TamSx3("F2_VALBRUT")[1]+20 ,,{|| aArray[i][8]})
EndIf

//SECAO 2 - TOTALIZADOR
oSection2 := TRSection():New(oReport)
TRCell():New(oSection2, "A"	,"" ,"" ,"@!" ,TamSx3("F2_FILIAL")[1]  ,,{||})
TRCell():New(oSection2, "B"	,"" ,"" ,"@!" ,TamSx3("A3__SEGISP")[1] ,,{||})
TRCell():New(oSection2, "C"	,"" ,"" ,"@!" ,TamSx3("A3_COD")[1]     ,,{||})
TRCell():New(oSection2, "D"	,"" ,"" ,"@!" ,TamSx3("A1_COD")[1]+10     ,,{||})
TRCell():New(oSection2, "E"	,"" ,"" ,"@!" ,TamSx3("A1_NOME")[1]    ,,{||})
TRCell():New(oSection2, "F"	,"" ,"Total do Representante" ,"@!" 							,TamSx3("F2_DOC")[1]+60  ,,{|| AllTrim(Str(nCont))})
TRCell():New(oSection2, "G"	,"" ,"Total do Segmento" 		,PesqPict("SF2","F2_VALMERC") 	,TamSx3("F2_VALMERC")[1]+20 ,,{|| nTot})
If MV_PAR09 == 1
	TRCell():New(oSection2, "H"	,"" ,"Total s/ St." 		,PesqPict("SF2","F2_VALBRUT") 	,TamSx3("F2_VALBRUT")[1]+20 ,,{|| nTotSt})
EndIf

//SECAO 3 - TOTAL GERAL
oSection3 := TRSection():New(oReport)
TRCell():New(oSection3, "A"	,"" ,"" ,"@!" ,TamSx3("F2_FILIAL")[1]  ,,{|| })
TRCell():New(oSection3, "B"	,"" ,"" ,"@!" ,TamSx3("A3__SEGISP")[1] ,,{|| })
TRCell():New(oSection3, "C"	,"" ,"" ,"@!" ,TamSx3("A3_COD")[1]    ,,{|| })
TRCell():New(oSection3, "D"	,"" ,"" ,"@!" ,TamSx3("A1_COD")[1]+10     ,,{||})
TRCell():New(oSection3, "E"	,"" ,"" ,"@!" ,TamSx3("A1_NOME")[1]    ,,{||})
TRCell():New(oSection3, "F"	,"" ,"Total Geral" ,"@!" 							,TamSx3("F2_DOC")[1]+60  ,,{|| AllTrim(Str(nContT))})
TRCell():New(oSection3, "G"	,"" ,"Total Geral Faturado" 		,PesqPict("SF2","F2_VALMERC") 	,TamSx3("F2_VALMERC")[1]+20 ,,{|| nTotT})
If MV_PAR09 == 1
	TRCell():New(oSection3, "H"	,"" ,"Total Geral s/ St." 		,PesqPict("SF2","F2_VALBRUT") 	,TamSx3("F2_VALBRUT")[1]+20 ,,{|| nTotTSt})
EndIf

Return oReport

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ReportPrint		  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para importar o arquivo GNRE para a SE5								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ReportPrint(oReport)

Local oReport

cQuery1 := " SELECT F2_FILIAL, A3__SEGISP, A3_COD FROM "
cQuery1 += RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4 "
cQuery1 += " WHERE SF2.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' "
cQuery1 += " AND F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CHVNFE <> ' ' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA  "
cQuery1 += " AND F2_TIPO NOT IN ('B','D') AND F2_VEND1 = A3_COD AND D2_TES = F4_CODIGO AND F4_FILIAL = D2_FILIAL AND F4_DUPLIC = 'S' "
cQuery1 += " AND F2_FILIAL BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' AND A3_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' "
cQuery1 += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"' AND A3__SEGISP BETWEEN '"+MV_PAR07+"' AND '"+MV_PAR08+"' "
cQuery1 += " GROUP BY F2_FILIAL, A3__SEGISP, A3_COD ORDER BY F2_FILIAL, A3__SEGISP, A3_COD "
cQuery1 := ChangeQuery(cQuery1)
DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery1), 'TMPA', .F., .T.)

DbSelectArea("TMPA")
DbGoTop()
While !Eof()
	
	cQuery2 := " SELECT A1_COD, A1_LOJA, A1_NOME FROM "
	cQuery2 += RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4 "
	cQuery2 += " WHERE SF2.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' "
	cQuery2 += " AND F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CHVNFE <> ' ' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
	cQuery2 += " AND F2_TIPO NOT IN ('B','D') AND F2_VEND1 = A3_COD AND D2_TES = F4_CODIGO AND F4_FILIAL = D2_FILIAL AND F4_DUPLIC = 'S' "
	cQuery2 += " AND F2_FILIAL = '"+TMPA->F2_FILIAL+"' AND A3_COD = '"+TMPA->A3_COD+"' AND A3__SEGISP = '"+TMPA->A3__SEGISP+"' "
	cQuery2 += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"' "
	cQuery2 += " GROUP BY A1_COD, A1_LOJA, A1_NOME ORDER BY A1_COD "
	cQuery2 := ChangeQuery(cQuery2)
	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery2), 'TMPB', .F., .T.)
	
	DbSelectArea("TMPB")
	DbGoTop()
	While !Eof()
		
		cQuery3 := " SELECT F2_DOC, F2_VALBRUT, F2_FRETE, F2_ICMSRET FROM "
		cQuery3 += RetSqlName("SF2")+" SF2, "+RetSqlName("SD2")+" SD2, "+RetSqlName("SA1")+" SA1, "+RetSqlName("SA3")+" SA3, "+RetSqlName("SF4")+" SF4 "
		cQuery3 += " WHERE SF2.D_E_L_E_T_ = ' ' AND SD2.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND SA3.D_E_L_E_T_ = ' ' AND SF4.D_E_L_E_T_ = ' ' "
		cQuery3 += " AND F2_FILIAL = D2_FILIAL AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE AND F2_CHVNFE <> ' ' AND F2_CLIENTE = A1_COD AND F2_LOJA = A1_LOJA "
		cQuery3 += " AND F2_TIPO NOT IN ('B','D') AND F2_VEND1 = A3_COD AND D2_TES = F4_CODIGO AND F4_FILIAL = D2_FILIAL AND F4_DUPLIC = 'S' "
		cQuery3 += " AND F2_FILIAL = '"+TMPA->F2_FILIAL+"' AND A3_COD = '"+TMPA->A3_COD+"' "
		cQuery3 += " AND A3__SEGISP = '"+TMPA->A3__SEGISP+"' AND A1_COD = '"+TMPB->A1_COD+"' AND A1_LOJA = '"+TMPB->A1_LOJA+"' "
		cQuery3 += " AND F2_EMISSAO BETWEEN '"+DtoS(MV_PAR05)+"' AND '"+DtoS(MV_PAR06)+"' "
		cQuery3 += " GROUP BY F2_DOC, F2_VALBRUT, F2_FRETE, F2_ICMSRET ORDER BY F2_DOC "
		cQuery3 := ChangeQuery(cQuery3)
		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery3), 'TMPC', .F., .T.)
		TcSetField("TMPC","F2_VALMERC","N",12,2)
		TcSetField("TMPC","F2_VALBRUT","N",12,2)
		
		DbSelectArea("TMPC")
		DbGoTop()
		While !Eof()
			
			aAdd(aNotas,{AllTrim(TMPC->F2_DOC), TMPC->F2_VALBRUT - TMPC->F2_FRETE, TMPC->F2_VALBRUT - TMPC->F2_FRETE - TMPC->F2_ICMSRET})
			nCont++
			nRep   += TMPC->F2_VALBRUT - TMPC->F2_FRETE
			nRepSt += TMPC->F2_VALBRUT - TMPC->F2_FRETE - TMPC->F2_ICMSRET
			nContT++
			nTot   += TMPC->F2_VALBRUT - TMPC->F2_FRETE
			nTotSt += TMPC->F2_VALBRUT - TMPC->F2_FRETE - TMPC->F2_ICMSRET
			nTotT  += TMPC->F2_VALBRUT - TMPC->F2_FRETE
			nTotTSt+= TMPC->F2_VALBRUT - TMPC->F2_FRETE - TMPC->F2_ICMSRET
			
			DbSelectArea("TMPC")
			DbSkip()
			
		End
		
		For i := 1 to Len(aNotas)
		
			If nAux == 0
				cNf += aNotas[i][1]+" "
				nAux++
			ElseIf nAux == 1
				cNf := cNf+aNotas[i][1]+" "
				nAux++
			ElseIf nAux >= 2
				cNf := cNf+aNotas[i][1]+" "
				nAux++
			EndIf
			
			If nAux == 3
				nAux := 0
			EndIf
			
		Next
		
		nAux := 0
		
		If cVend <> TMPA->A3_COD
			aAdd(aArray,{TMPA->F2_FILIAL, TMPA->A3__SEGISP, TMPA->A3_COD, TMPB->A1_COD, TMPB->A1_NOME, cNf, nRep, nRepSt})
			cVend := TMPA->A3_COD
		Else
			aAdd(aArray,{"", "", "", TMPB->A1_COD, TMPB->A1_NOME, cNf, nRep, nRepSt})
		EndIf
		
		cNf    := ""
		nRep   := 0
		nRepSt := 0
		aNotas := {}
		
		DbSelectArea("TMPC")
		DbCloseArea()
		
		DbSelectArea("TMPB")
		DbSkip()
		
	End
	
	DbSelectArea("TMPB")
	DbCloseArea()
		
	oReport:Section(1):Init()
	
	For i := 1 To Len(aArray)
		For j := 1 To (Len(aArray[i][6])/10)
			If j == 1
				If MV_PAR09 == 1
					aAdd(aArrax,{aArray[i][1], aArray[i][2], aArray[i][3], aArray[i][4], aArray[i][5], Substr(aArray[i][6],j,30), aArray[i][7], aArray[i][8]})
				Else
					aAdd(aArrax,{aArray[i][1], aArray[i][2], aArray[i][3], aArray[i][4], aArray[i][5], Substr(aArray[i][6],j,30), aArray[i][7]})
				EndIf				
			Else
				If MV_PAR09 == 1
					aAdd(aArrax,{"", "", "", "", "", Substr(aArray[i][6],nSubAux,30), 0, 0})
				Else
					aAdd(aArrax,{"", "", "", "", "", Substr(aArray[i][6],nSubAux,30), 0})
				EndIf
				nSubAux += 30				
			EndIf
			j += 3
		Next j
		nSubAux := 31
	Next i
	
	aArray  := ACLONE(aArrax)	
	aArrax  := {}
	nSubAux := 31
	
	For i := 1 To Len(aArray)
		
		If oReport:Cancel()
			Exit
		EndIf
				
		oReport:Section(1):PrintLine()
		oReport:SkipLine()
		oReport:IncMeter()
		
	Next
	
	oReport:Section(1):Finish()
	
	oReport:Section(2):Init()
	oReport:Section(2):PrintLine()
	oReport:IncMeter()
	oReport:Section(2):Finish()
	
	nTot   := 0
	nTotSt := 0
	nCont  := 0
	nRep   := 0
	nRepSt := 0
	
	aArray := {}
	
	DbSelectArea("TMPA")
	DbSkip()
	
	If !Eof()
		oReport:EndPage(.T.)
		oReport:SetStartPage(.T.)
	Else
		oReport:Section(3):Init()
		oReport:Section(3):PrintLine()
		oReport:IncMeter()
		oReport:Section(3):Finish()
	EndIf
	
End

DbSelectArea("TMPA")
DbCloseArea()

Return(oReport)

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ValidPerg		  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para importar o arquivo GNRE para a SE5								  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ValidPerg(cPerg)

Local aRegs := {}
Local i,j

dbSelectArea("SX1")
dbSetOrder(1)
cPerg := PADR(cPerg,len(SX1->X1_GRUPO))

// Grupo/Ordem/Pergunta/Perg.Spa/Perg.Eng/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/DefSpa01/DefEng01/Cnt01/Var02/Def02/DefSpa02/DefEng02/Cnt02/Var03/Def03/DefSpa03/DefEng03/Cnt03/Var04/Def04/DefSpa04/DefEng04/Cnt04/Var05/Def05/DefSpa05/DefEng05/Cnt05/F3/PYME/GRPSXG/HELP/PICTURE/IDFIL
AADD(aRegs,{cPerg,"01","Filial de?"         ,"","","mv_ch1","C",02,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
AADD(aRegs,{cPerg,"02","Filial ate?"        ,"","","mv_ch2","C",02,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SM0","","","","",""})
AADD(aRegs,{cPerg,"03","Representante de?"  ,"","","mv_ch3","C",06,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})
AADD(aRegs,{cPerg,"04","Representante ate?" ,"","","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","SA3","","","","",""})
AADD(aRegs,{cPerg,"05","Emissao NF de?"     ,"","","mv_ch5","D",08,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Emissao NF ate?"    ,"","","mv_ch6","D",08,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Segmento de?"       ,"","","mv_ch7","C",02,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SZ7","","","","",""})
AADD(aRegs,{cPerg,"08","Segmento ate?"      ,"","","mv_ch8","C",02,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","SZ7","","","","",""})
AADD(aRegs,{cPerg,"09","Imprime ST?"        ,"","","mv_ch9","N",01,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next

Return
