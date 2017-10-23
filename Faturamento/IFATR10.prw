#INCLUDE "PROTHEUS.CH"

/*
+-------------+----------+--------+------------------------------+-------+-----------+
| Programa:   | IFATR10  | Autor: | Rubens Cruz - Anadi			 | Data: | Dez/2014  |
+-------------+----------+--------+------------------------------+-------+-----------+
| Descrição:  | Relatório de Relação de Alterações de Preços						 |
+-------------+----------------------------------------------------------------------+
| Uso:        | Isapa				    	                    			         |
+-------------+----------------------------------------------------------------------+
| Parametros: |                                                                      |
+-------------+----------------------------------------------------------------------+
*/

User Function IFATR10(_dDataDe,_dDataAte,_cSeg,_cEst)
Local aPergs 	:= {}
Local cPerg	 	:= "IFATR10"
Local lParam	:= .T.
Local c30d		:= ""
Local c60d		:= ""
Local c90d		:= ""

Default _dDataDe	:= CTOD("  /  /    ")
Default _dDataAte	:= CTOD("  /  /    ")
Default _cSeg		:= ""
Default _cEst		:= ""

Aadd(aPergs,{"Data De"	,"","","mv_ch1","D",08 						,0,0,"G",""										,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""	  ,"","","",""})
Aadd(aPergs,{"Data Ate"	,"","","mv_ch2","D",08						,0,0,"G",""										,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""    ,"","","",""})
Aadd(aPergs,{"Segmento"	,"","","mv_ch3","C",TamSx3("Z7_CODIGO")[1]	,0,0,"G","Vazio() .OR. ExistCpo('SZ7',MV_PAR03)","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","SZ7" ,"","","",""})
Aadd(aPergs,{"Estado"	,"","","mv_ch4","C",TamSx3("DA1_ESTADO")[1]	,0,0,"G",""										,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","12"  ,"","","",""})

AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

lParam	:= ( Empty(_dDataDe) .OR. Empty(_dDataAte) .OR. Empty(_cSeg) .OR. Empty(_cEst) )

If(!Pergunte (cPerg,lParam) .AND. lParam)
	Return
EndIf

DbSelectArea("ZX5")
DbSeek(xFilial("ZX5")+Space(TamSx3("ZX5_FILISA")[1])+'000007'+PadR("002",TamSx3("ZX5_CODIGO")[1])+_cSeg)
c30d := ZX5_DSCITE

DbSkip()
c60d := ZX5_DSCITE
DbSkip()
c90d := ZX5_DSCITE

If !lParam
	MV_PAR01 := _dDataDe
	MV_PAR02 := _dDataAte
	MV_PAR03 := _cSeg
	MV_PAR04 := _cEst
EndIf

cParms := DTOS(MV_PAR01) + ";"
cParms += DTOS(MV_PAR02) + ";"
cParms += MV_PAR03 + ";"
cParms += MV_PAR04 + ";"
cParms += c30d + ";"
cParms += c60d + ";"
cParms += c90d

x:="1;0;1;IFATCR10" 


CallCrys("IFATCR10",cParms, x)

Return