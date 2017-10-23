#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"

/*
+-----------+---------+-------+---------------------------------------+------+----------------+
| Programa  | IFISR03 | Autor | Rubens Cruz - Anadi Soluções 		  | Data | Fevereiro/2015 |
+-----------+---------+-------+---------------------------------------+------+----------------+
| Descricao | Relatorio de Apuração de ICMS/IPI por Grupo (Crystal)							  | 
+-----------+---------------------------------------------------------------------------------+
| Uso       | ISAPA																		      |
+-----------+---------------------------------------------------------------------------------+
*/  

User Function IFISR03()  
Local cPerg	 	:= "IFISR03"
Local aPergs	:= {}      
Local cOptions 	:= "1;0;1;Relatório de Apuração de ICMS/IPI por Segmento anual"
Local cParams	:= ""

Aadd(aPergs,{"Local De"		,"","","mv_ch1","C",TamSx3("A1_FILIAL")[1]  ,0,0,"G",""								,"MV_PAR01",""				,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","","DLB" ,"","","",""})
Aadd(aPergs,{"Local Ate"	,"","","mv_ch2","C",TamSx3("A1_FILIAL")[1]  ,0,0,"G",""								,"MV_PAR02",""				,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","","DLB" ,"","","",""})
Aadd(aPergs,{"Tipo ?"		,"","","mv_ch3","N",01						,0,0,"C",""								,"MV_PAR03","ICMS"			,"","","","","IPI"			,"","","","","Ambos"	,"","","","","","","","","","","","","","" 	 ,"","","",""})
Aadd(aPergs,{"Data De"		,"","","mv_ch4","D",08 						,0,0,"G",""								,"MV_PAR04",""				,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Data Ate"		,"","","mv_ch5","D",08						,0,0,"G",""								,"MV_PAR05",""				,"","","","",""				,"","","","",""			,"","","","","","","","","","","","","",""    ,"","","",""})

AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

If !Pergunte (cPerg,.t.)
 	Return
EndIf  

cParams := MV_PAR01 + ";"           	//Filial De
cParams += MV_PAR02 + ";"           	//Filial Ate
cParams += Alltrim(Str(MV_PAR03)) + ";"	//ICMS ou IPI
cParams += DTOS(MV_PAR04) + ";"     	//Data De
cParams += DTOS(MV_PAR05) + ";"     	//Data Ate

CallCrys('IFISCR08',cParams,cOptions)

Return