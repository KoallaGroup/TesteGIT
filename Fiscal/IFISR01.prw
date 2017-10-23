#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+------------+---------+-------+---------------------------------------+------+------------+
| Programa   | IFISR01 | Autor | Rubens Cruz - Anadi Soluções 		   | Data | Julho/2014 |
+------------+---------+-------+---------------------------------------+------+------------+
| Descricao  | Relatorio de IVA (Crystal)								  				   |
+------------+-----------------------------------------------------------------------------+
| Uso        | ISAPA																	   |
+------------+-----------------------------------------------------------------------------+
| Parametros | _RecSF1 = RECNO da SF1 que será gerado o Relatorio                          |
+------------+-----------------------------------------------------------------------------+
*/  

User Function IFISR01(_RecSF1)
Local _aArea	:= GetArea()
Local _aAreaSF1	:= SF1->(GetArea())
LOCAL aPergs	:= {}   
Local cParams	:= ""
Local cRefIni	:= ""
Local cRefFim	:= ""
local _cQuery 	:= "" 
Local n 		:= 0
Local cOptions  := "1;0;1;Relatorio IVA"

Default _RecSF1 := 0
   
//                  1         2  3    4      5   6 						 7 8  9  10     11     12 13 14 15 16 17 18 19 20 21 22 23 24 25        						 36
Aadd(aPergs,{"Fornecedor"	,"","","mv_ch1","C",TamSx3("A2_COD")[1]	    ,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA2A","","","",""})
Aadd(aPergs,{"Loja"			,"","","mv_ch1","C",TamSx3("A2_LOJA")[1] 	,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","SA22","","","",""})
Aadd(aPergs,{"Entrada De"	,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""    ,"","","",""})
Aadd(aPergs,{"Entrada Ate"	,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Nota De"	    ,"","","mv_ch4","C",TamSx3("F1_DOC")[1]		,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Nota Ate" 	,"","","mv_ch5","C",TamSx3("F1_DOC")[1] 	,0,0,"G","","MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Serie De"	    ,"","","mv_ch4","C",TamSx3("F1_SERIE")[1]	,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Serie Ate"	,"","","mv_ch4","C",TamSx3("F1_SERIE")[1]	,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Local"		,"","","mv_ch9","C",TamSx3("F1_FILIAL")[1]	,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SM0" ,"","","",""})
	
AjustaSx1(PADR("IFISR01",Len(SX1->X1_GRUPO)),aPergs)

If (_RecSF1 > 0)
	Pergunte ("IFISR01",.F.)

	DbSelectArea("SF1")
	DbGoTo(_RecSF1)

	MV_PAR01 := SF1->F1_FORNECE
	MV_PAR02 := SF1->F1_LOJA
	MV_PAR03 := dDataBase
	MV_PAR04 := dDataBase
	MV_PAR05 := SF1->F1_DOC
	MV_PAR06 := SF1->F1_DOC
	MV_PAR07 := SF1->F1_SERIE
	MV_PAR08 := SF1->F1_SERIE
	MV_PAR09 := SF1->F1_FILIAL
Else
	If !Pergunte ("IFISR01",.T.)
	 	Return
	EndIf          
EndIf

/*Definição dos parametros para geracao do relatorio.*/
cParams := MV_PAR05 + ";"   	//Nota De
cParams += MV_PAR06 + ";"		//Nota Ate
cParams += MV_PAR07 + ";" 		//Serie De                    
cParams += MV_PAR08 + ";" 		//Serie Ate
cParams += DTOS(MV_PAR03) + ";" //Data De
cParams += DTOS(MV_PAR04) + ";"	//Data Ate
cParams += MV_PAR01 + ";"		//Fornecedor
cParams += MV_PAR02 + ";"		//Loja
cParams += MV_PAR09 + ";"		//Filial

/*Chamada da função .*/
CallCrys('IFISCR01', cParams,cOptions)

cParams := MV_PAR05 + ";"   	//Nota 
cParams += MV_PAR07 + ";" 		//Serie                     
cParams += MV_PAR01 + ";"		//Fornecedor
cParams += MV_PAR02 + ";"		//Loja
cParams += MV_PAR09 + ";"		//Filial

/*Chamada da função .*/
CallCrys('IFISCR02', cParams,cOptions)  

RestArea(_aAreaSF1)
RestArea(_aArea)
	
Return .T.