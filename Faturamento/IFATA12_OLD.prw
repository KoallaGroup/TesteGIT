#INCLUDE "PROTHEUS.CH"

/*
+-------------+----------+--------+------------------------------+-------+-----------+
| Programa:   | IFATA12  | Autor: | Rubens Cruz - Anadi			 | Data: | Ago/2014  |
+-------------+----------+--------+------------------------------+-------+-----------+
| Descrição:  | Aprovacao Comercial/Financeira										 |
+-------------+----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         |
+-------------+----------------------------------------------------------------------+
| Parametros: | _cTipo := Tipo da aprovação / C = Comercial							 |
|			  |								  F = Financeira						 |
+-------------+----------------------------------------------------------------------+
*/

User Function IFATA12(_cTipo)
Local cFilAux		:= "AND UA__FILIAL = '" + cFilAnt + "' "

Private cFiltro   	:= IIF(_cTipo == "C","UA__SITCOM","UA__SITFIN") + " = 'E' " 
PRIVATE cAlias   	:= 'SUA'
PRIVATE cCadastro 	:= "Aprovacao " + IIF(_cTipo == "C","Comercial","Financeira")
PRIVATE aRotina     := {{"Criticas Ped"	, "U_ITMKA24(SUA->UA__FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,'" + _cTipo + "')", 0, 4},;
						{"Comissões"	, "U_ITMKA21(SUA->UA_NUM)", 0, 4},;
						{"Indica Sit."	, "U_IFATA13(SUA->UA__FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,'" + _cTipo + "')", 0, 4}}
                                
If(_cTipo == "C")
	AADD(aRotina,{"Visualizar"   , "TK271CallCenter" , 0, 2 })
EndIf

SetKey( VK_F12 , { || IFATA12A() } )

dbSelectArea("SUA")
dbSetOrder(1)

mBrowse(,,,,"SUA",,,,,,,,,,,,,,cFiltro + cFilAux)

Return                           	

/*
+------------+----------+--------+------------------------------+-------+-----------+
| Programa:  | IFATA12  | Autor: | Rubens Cruz - Anadi			| Data: | Ago/2014  |
+------------+----------+--------+------------------------------+-------+-----------+
| Descrição: | Filtro da janela de aprovacao										|
+------------+----------------------------------------------------------------------+
| Uso:       | Isapa				    	                    			        |
+------------+----------------------------------------------------------------------+
*/

Static Function IFATA12A()               
Local aPergs 	:= {}
Local cPerg	 	:= "IFATA12"
Local cFilAux	:= ""
Local _oBrowse  := GetObjBrow()

Aadd(aPergs,{"Local"	,"","","mv_ch1","C",TamSx3("UA_FILIAL")[1]  ,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","DLB" ,"","","",""})
Aadd(aPergs,{"Data De"	,"","","mv_ch2","D",08 						,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Data Ate"	,"","","mv_ch3","D",08						,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""    ,"","","",""})
	
AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

If !Pergunte (cPerg,.t.)
 	Return
EndIf                     

cFilAux := cFiltro + ".AND. UA__FILIAL = '" + MV_PAR01 + "'"
cFilAux += " .AND. DTOS(UA_EMISSAO) >= '" + DTOS(MV_PAR02) + "'"
cFilAux += " .AND. DTOS(UA_EMISSAO) <= '" + DTOS(MV_PAR03) + "'"         

SET FILTER TO &(cFilAux)

_oBrowse:Refresh()

Return