#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+-----------+---------+-------+---------------------------------------+------+--------------+
| Programa  | IFISR02 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Janeiro/2015 |
+-----------+---------+-------+---------------------------------------+------+--------------+
| Descricao | Relatorio de Apuração de ICMS/IPI por Grupo (Crystal)							| 
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/  

User Function IFISR02()  
Local cPerg	 	:= "IFISR02"
Local aPergs	:= {}      
Local cOptions 	:= "1;0;1;Relatório de Apuração de ICMS por Segmento"
Local cParams	:= ""

DbSelectArea("SX1")
DbSetOrder(1)
//If !DbSeek(PADR(cPerg,Len(SX1->X1_GRUPO)))
	Aadd(aPergs,{"Local De"		,"","","mv_ch1","C",TamSx3("A1_FILIAL")[1]  ,0,0,"G",""								,"MV_PAR01",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","DLB" ,"","","",""})
	Aadd(aPergs,{"Local Ate"	,"","","mv_ch2","C",TamSx3("A1_FILIAL")[1]  ,0,0,"G",""								,"MV_PAR02",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","DLB" ,"","","",""})
	Aadd(aPergs,{"Data De"		,"","","mv_ch3","D",08 						,0,0,"G",""								,"MV_PAR03",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
	Aadd(aPergs,{"Data Ate"		,"","","mv_ch4","D",08						,0,0,"G",""								,"MV_PAR04",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","",""    ,"","","",""})
	Aadd(aPergs,{"Segmento"		,"","","mv_ch5","C",TamSx3("Z7_CODIGO")[1]  ,0,0,"G","Vazio() .OR. ExistCpo('SZ7')"	,"MV_PAR05",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","SZ7" ,"","","",""})
	Aadd(aPergs,{"CFOP De"		,"","","mv_ch6","C",04  					,0,0,"G",""								,"MV_PAR06",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","13"  ,"","","",""})
	Aadd(aPergs,{"CFOP Ate"		,"","","mv_ch7","C",04  					,0,0,"G",""								,"MV_PAR07",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","13"  ,"","","",""})
	Aadd(aPergs,{"Por Grupo ?"	,"","","mv_ch8","N",01  					,0,0,"C",""								,"MV_PAR08","Sim"			,"","","","","Não"			,"","","","","","","","","","","","","","","","","","","" 	 ,"","","",""})
	Aadd(aPergs,{"Grupo"		,"","","mv_ch9","C",TamSx3("BM_GRUPO")[1]  	,0,0,"G","Vazio() .OR. ExistCpo('SBM')"	,"MV_PAR09",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","SBM" ,"","","",""})
	Aadd(aPergs,{"Fundap ?"		,"","","mv_cha","N",01						,0,0,"C",""								,"MV_PAR10","Sim"			,"","","","","Não"			,"","","","","","","","","","","","","","","","","","","" 	 ,"","","",""})
	Aadd(aPergs,{"Tipo "		,"","","mv_chb","N",01						,0,0,"C",""								,"MV_PAR11","ICMS"			,"","","","","IPI"			,"","","","","","","","","","","","","","","","","","","" 	 ,"","","",""})
	Aadd(aPergs,{"Detalhamento"	,"","","mv_chc","N",01						,0,0,"C",""								,"MV_PAR12","Sintetico"		,"","","","","Analitico"	,"","","","","","","","","","","","","","","","","","","" 	 ,"","","",""})
	Aadd(aPergs,{"Armazem De"	,"","","mv_chd","C",TamSx3("B1_LOCPAD")[1]  ,0,0,"G",""								,"MV_PAR13",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","NNR" ,"","","",""})
	Aadd(aPergs,{"Armazem Ate"	,"","","mv_che","C",TamSx3("B1_LOCPAD")[1]  ,0,0,"G",""								,"MV_PAR14",""				,"","","","",""				,"","","","","","","","","","","","","","","","","","","NNR" ,"","","",""})
		
	AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)
//EndIf

If !Pergunte (cPerg,.t.)
 	Return
EndIf  

cParams := MV_PAR01 + ";"           	//Filial De
cParams += MV_PAR02 + ";"           	//Filial Ate
cParams += DTOS(MV_PAR03) + ";"     	//Data De
cParams += DTOS(MV_PAR04) + ";"     	//Data Ate
cParams += MV_PAR05 + ";"           	//Segmento
cParams += Alltrim(MV_PAR06) + ";"  	//CFOP De
cParams += Alltrim(MV_PAR07) + ";"  	//CFOP Ate
cParams += Alltrim(MV_PAR09) + ";"  	//Grupo
cParams += Alltrim(Str(MV_PAR12)) + ";"	//Sintetico/Analitico
//cParams += Alltrim(Str(MV_PAR10)) 	//Fundap ?
cParams += MV_PAR13 + ";"           	//Armazém De
cParams += MV_PAR14 		           	//Armazém Ate

Do Case
	Case (MV_PAR11 = 1 .AND. MV_PAR10 = 1)// ICMS Com Fundap
		CallCrys('IFISCR05A',cParams,cOptions)
	Case (MV_PAR11 = 1 .AND. MV_PAR10 = 2)// ICMS Sem Fundap
		CallCrys('IFISCR05B',cParams,cOptions)
	Case (MV_PAR11 = 2 .AND. MV_PAR10 = 1)// IPI Com Fundap
		CallCrys('IFISCR05C',cParams,cOptions)
	Case (MV_PAR11 = 2 .AND. MV_PAR10 = 2)// IPI Sem Fundap
		CallCrys('IFISCR05D',cParams,cOptions) 
EndCase

Return