#INCLUDE "PROTHEUS.CH"

/*
+-------------+----------+--------+------------------------------+-------+-----------+
| Programa:   | IFATR08  | Autor: | Rubens Cruz - Anadi			 | Data: | Dez/2014  |
+-------------+----------+--------+------------------------------+-------+-----------+
| Descrição:  | Relatorio de visitas por representante								 |
+-------------+----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         |
+-------------+----------------------------------------------------------------------+
| Parametros: |                                                                      |
+-------------+----------------------------------------------------------------------+
*/

User Function IFATR08(_cVend,_dDataDe,_dDataAte, cComboOP)               
Local aPergs 	:= {}
Local cPerg	 	:= "IFATR08"
Local lParam	:= .T.

Default _cVend		:= ""
Default _dDataDe	:= CTOD("  /  /  ")
Default _dDataAte	:= CTOD("  /  /  ")
Default cComboOP 	:= ""

Aadd(aPergs,{"Representante"	,"","","mv_ch1","C",TamSx3("UA_VEND")[1]	,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","SA3" ,"","","",""})
Aadd(aPergs,{"Data De"			,"","","mv_ch2","D",08 						,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Data Ate"			,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""    ,"","","",""})
	
AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

lParam	:= ( Empty(_cVend) .OR. Empty(_dDataDe) .OR. Empty(_dDataAte) )

Pergunte (cPerg,lParam)
   
If !lParam
	MV_PAR01 := _cVend
	MV_PAR02 := _dDataDe
	MV_PAR03 := _dDataAte
EndIf

if cComboOP == ""
	cComboOP := "'1','2','3','4','5'" 
else                                  
	cComboOP := "'" + cComboOP + "'"
endif

cParms := MV_PAR01+";"+DTOS(MV_PAR02)+";"+DTOS(MV_PAR03)+";"+IIF(cComboOP == "","  ",cComboOP)+";"
x:="1;0;1;IFATCR08" 


CallCrys("IFATCR08",cParms, x)
	
Return
