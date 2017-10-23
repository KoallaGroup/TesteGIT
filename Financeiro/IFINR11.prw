#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+-----------+---------+-------+---------------------------------------+------+------------+
| Programa  | IFINR11 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Julho/2014 |
+-----------+---------+-------+---------------------------------------+------+------------+
| Descricao | Relatorio de Adiantamento por Nota (Crystal e Excel)						  |
+-----------+-----------------------------------------------------------------------------+
| Uso       | ISAPA																		  |
+-----------+-----------------------------------------------------------------------------+
*/

User Function IFINR11()
Local cPerg		:= "IFINR11"
Local aPergs 	:= {}


Aadd(aPergs,{"Local"			,"","","mv_ch1","C",02						,0,0,"G","","MV_PAR01",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","","DLB","","","",""})
Aadd(aPergs,{"De Dt Lanc"		,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Ate Dt Lanc"		,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"De Nota"			,"","","mv_ch4","C",TamSx3("F1_DOC")[1]		,0,0,"G","","MV_PAR04",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Ate Nota"			,"","","mv_ch5","C",TamSx3("F1_DOC")[1]		,0,0,"G","","MV_PAR05",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"De Serie"			,"","","mv_ch6","C",TamSx3("F1_SERIE")[1]	,0,0,"G","","MV_PAR06",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Ate Serie"		,"","","mv_ch7","C",TamSx3("F1_SERIE")[1]	,0,0,"G","","MV_PAR07",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"De Fornecedor"	,"","","mv_ch8","C",TamSx3("A2_COD")[1]		,0,0,"G","","MV_PAR08",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","","FOR","","","",""})
Aadd(aPergs,{"De Loja"			,"","","mv_cha","C",TamSx3("A2_LOJA")[1]	,0,0,"G","","MV_PAR09",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Ate Fornecedor"	,"","","mv_ch9","C",TamSx3("A2_COD")[1]		,0,0,"G","","MV_PAR10",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","","FOR","","","",""})
Aadd(aPergs,{"Ate Loja"			,"","","mv_chb","C",TamSx3("A2_LOJA")[1]	,0,0,"G","","MV_PAR11",""		,"","","","","",""	,"","","","","","","","","","","","","","","","","",""	,"","","",""})
Aadd(aPergs,{"Excel ?"			,"","","mv_chc","N",01						,0,0,"C","","MV_PAR12","Sim"	,"","","","","Nao","","","","","","","","","","","","","","","","","","",""	,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.t.)
	Return
EndIf                        

If(MV_PAR12 == 1) //Exprotar Excel



Else
	/*Definição dos paramentos para o relatório com base nas perguntas da SX1.*/  
	
	cParams := MV_PAR01 + ";"
	cParams += DTOS(MV_PAR02) + ";"
	cParams += DTOS(MV_PAR03) + ";"
	cParams += MV_PAR04 + ";"
	cParams += MV_PAR05 + ";"
	cParams += MV_PAR06 + ";"
	cParams += MV_PAR07 + ";"
	cParams += MV_PAR08 + ";"
	cParams += MV_PAR10 + ";"
	cParams += MV_PAR09 + ";"
	cParams += MV_PAR11
	
	/*Definição das opções para geração do relatório.*/
	                                       
	cOptions := "1;0;2;Adiantamento por Nota"
	
	/*Chamada da função .*/
	
	CallCrys('IFINCR06', cParams,cOptions)

EndIf

Return
