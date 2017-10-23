#include "protheus.ch" 
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM25	 		  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Fonte para ajustar as comissoes dos titulos com IPI						  		|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IGENM25()                 
Local _cQuery	:= ""
Local _aArea	:= GetArea()
Local _aAreaSe1	:= SE1->(GetArea())
Local cPerg	 	:= "IGENM25"
Local aPergs	:= {}

Aadd(aPergs,{"Data De"		,"","","mv_ch1","D",08 						,0,0,"G","","MV_PAR01",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""	 ,"","","",""})
Aadd(aPergs,{"Data Ate"		,"","","mv_ch2","D",08						,0,0,"G","","MV_PAR02",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","",""    ,"","","",""})
Aadd(aPergs,{"Vendedor De"	,"","","mv_ch3","C",TamSx3("E1_VEND1")[1]	,0,0,"G","","MV_PAR03",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3" ,"","","",""})
Aadd(aPergs,{"Vendedor Ate"	,"","","mv_ch4","C",TamSx3("E1_VEND1")[1]	,0,0,"G","","MV_PAR04",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3" ,"","","",""})
Aadd(aPergs,{"Segmento"		,"","","mv_ch5","C",TamSx3("Z7_CODIGO")[1]	,0,0,"G","","MV_PAR05",""	,"","","","",""		,"","","","","","","","","","","","","","","","","","","SA3" ,"","","",""})
Aadd(aPergs,{"Reprocessa ?"	,"","","mv_ch6","N",01						,0,0,"C","","MV_PAR06","Sim","","","","","Nao"	,"","","","","","","","","","","","","","","","","","",""    ,"","","",""})

AjustaSx1(PADR(cPerg,Len(SX1->X1_GRUPO)),aPergs)

If !Pergunte (cPerg,.t.)
 	Return
EndIf                     

If Select("TMP_SE1") > 0
	DbSelectArea("TMP_SE1")
	DbCloseArea()
EndIf

_cQuery := "select SE1.E1_FILIAL,															" + Chr(13)
_cQuery += "       SE1.E1_PREFIXO,                                                          " + Chr(13)
_cQuery += "       SE1.E1_NUM,                                                              " + Chr(13)
_cQuery += "       SE1.E1_PARCELA,                                                          " + Chr(13)
_cQuery += "       SE1.E1_TIPO,                                                             " + Chr(13)
_cQuery += "       SE1.E1_CLIENTE,                                                          " + Chr(13)
_cQuery += "       SE1.E1_LOJA,                                                             " + Chr(13)
_cQuery += "       SE1.R_E_C_N_O_ AS RECSE1,                                                " + Chr(13)
_cQuery += "       SE1.E1_BASCOM1,                                                          " + Chr(13)
_cQuery += "       SE1A.QUANT,                                                              " + Chr(13)
_cQuery += "       SF2.F2_VALIPI                                                            " + Chr(13)
_cQuery += "from " + RetSqlName("SE1") + " SE1                                              " + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SE1.E1_FILIAL       " + Chr(13)
_cQuery += "                         AND SF2.F2_DOC = SE1.E1_NUM                            " + Chr(13)
_cQuery += "                         AND SF2.F2_SERIE = SE1.E1_PREFIXO                      " + Chr(13)
_cQuery += "                         AND SF2.F2_CLIENTE = SE1.E1_CLIENTE                    " + Chr(13)
_cQuery += "                         AND SF2.F2_LOJA = SE1.E1_LOJA                          " + Chr(13)
_cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
_cQuery += "INNER JOIN (SELECT SE1.E1_FILIAL,                                               " + Chr(13)
_cQuery += "                   SE1.E1_PREFIXO,                                              " + Chr(13)
_cQuery += "                   SE1.E1_NUM,                                                  " + Chr(13)
_cQuery += "                   SE1.E1_CLIENTE,                                              " + Chr(13)
_cQuery += "                   SE1.E1_LOJA,                                                 " + Chr(13)
_cQuery += "                   COUNT(SE1.E1_PARCELA) AS QUANT                               " + Chr(13)
_cQuery += "            FROM " + RetSqlName("SE1") + " SE1                                  " + Chr(13)
_cQuery += "            WHERE SE1.D_E_L_E_T_ = ' '                                          " + Chr(13)
_cQuery += "                  AND SE1.E1_EMISSAO >= '20150501'                              " + Chr(13)
_cQuery += "                  AND SE1.E1_TIPO = 'NF'                                        " + Chr(13)
_cQuery += "            GROUP BY SE1.E1_FILIAL,                                             " + Chr(13)
_cQuery += "                     SE1.E1_PREFIXO,                                            " + Chr(13)
_cQuery += "                     SE1.E1_NUM,                                                " + Chr(13)
_cQuery += "                     SE1.E1_CLIENTE,                                            " + Chr(13)
_cQuery += "                     SE1.E1_LOJA) SE1A ON SE1A.E1_FILIAL = SE1.E1_FILIAL        " + Chr(13)
_cQuery += "                                          AND SE1A.E1_PREFIXO = SE1.E1_PREFIXO  " + Chr(13)
_cQuery += "                                          AND SE1A.E1_NUM = SE1.E1_NUM          " + Chr(13)
_cQuery += "                                          AND SE1A.E1_CLIENTE = SE1.E1_CLIENTE  " + Chr(13)
_cQuery += "                                          AND SE1A.E1_LOJA = SE1.E1_LOJA        " + Chr(13)
_cQuery += "inner join " + RetSqlName("SA3") + " SA3 ON A3_COD = E1_VEND1                   " + Chr(13)
_cQuery += "                 and SA3.D_E_L_E_T_ = ' '                                       " + Chr(13)
_cQuery += "                 and A3__SEGISP = '1'                                           " + Chr(13)
_cQuery += "where SE1.D_E_L_E_T_ = ' '                                                      " + Chr(13)
_cQuery += "  and SE1.E1_EMISSAO >= '20150501'                                              " + Chr(13)
_cQuery += "  and SE1.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + Chr(13)
_cQuery += "  and SE1.E1_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'            " + Chr(13)
_cQuery += "  and SE1.E1_TIPO = 'NF'                                                        " + Chr(13)
_cQuery += "  and SA3.A3__SEGISP = '" + MV_PAR05 + "'                                       " + Chr(13)
If MV_PAR06 = 1
	_cQuery += "  and SE1.E1__BASIPI > 0                                                    " + Chr(13)
EndIf
//_cQuery += "  AND SF2.F2_VALIPI > 0                                                         " + Chr(13)
_cQuery += "                                                                                " + Chr(13)
_cQuery += "UNION ALL                                                                       " + Chr(13)
_cQuery += "                                                                                " + Chr(13)
_cQuery += "select SE1.E1_FILIAL,                                                           " + Chr(13)
_cQuery += "       SE1.E1_PREFIXO,                                                          " + Chr(13)
_cQuery += "       SE1.E1_NUM,                                                              " + Chr(13)
_cQuery += "       SE1.E1_PARCELA,                                                          " + Chr(13)
_cQuery += "       SE1.E1_TIPO,                                                             " + Chr(13)
_cQuery += "       SE1.E1_CLIENTE,                                                          " + Chr(13)
_cQuery += "       SE1.E1_LOJA,                                                             " + Chr(13)
_cQuery += "       SE1.R_E_C_N_O_ AS RECSE1,                                                " + Chr(13)
_cQuery += "       SE1.E1_BASCOM1,                                                          " + Chr(13)
_cQuery += "       SE1A.QUANT,                                                              " + Chr(13)
_cQuery += "       0 AS F2_VALIPI                                                           " + Chr(13)
_cQuery += "from " + RetSqlName("SE1") + " SE1                                              " + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SF2") + " SF2 ON SF2.F2_FILIAL = SE1.E1_FILIAL       " + Chr(13)
_cQuery += "                         AND SF2.F2_DOC = SE1.E1_NUM                            " + Chr(13)
_cQuery += "                         AND SF2.F2_SERIE = SE1.E1_PREFIXO                      " + Chr(13)
_cQuery += "                         AND SF2.F2_CLIENTE = SE1.E1_CLIENTE                    " + Chr(13)
_cQuery += "                         AND SF2.F2_LOJA = SE1.E1_LOJA                          " + Chr(13)
_cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                               " + Chr(13)
_cQuery += "INNER JOIN (SELECT SE1.E1_FILIAL,                                               " + Chr(13)
_cQuery += "                   SE1.E1_PREFIXO,                                              " + Chr(13)
_cQuery += "                   SE1.E1_NUM,                                                  " + Chr(13)
_cQuery += "                   SE1.E1_CLIENTE,                                              " + Chr(13)
_cQuery += "                   SE1.E1_LOJA,                                                 " + Chr(13)
_cQuery += "                   COUNT(SE1.E1_PARCELA) AS QUANT                               " + Chr(13)
_cQuery += "            FROM " + RetSqlName("SE1") + " SE1                                  " + Chr(13)
_cQuery += "            WHERE SE1.D_E_L_E_T_ = ' '                                          " + Chr(13)
_cQuery += "                  AND SE1.E1_EMISSAO >= '20150501'                              " + Chr(13)
_cQuery += "                  AND SE1.E1_TIPO = 'NF'                                        " + Chr(13)
_cQuery += "            GROUP BY SE1.E1_FILIAL,                                             " + Chr(13)
_cQuery += "                     SE1.E1_PREFIXO,                                            " + Chr(13)
_cQuery += "                     SE1.E1_NUM,                                                " + Chr(13)
_cQuery += "                     SE1.E1_CLIENTE,                                            " + Chr(13)
_cQuery += "                     SE1.E1_LOJA) SE1A ON SE1A.E1_FILIAL = SE1.E1_FILIAL        " + Chr(13)
_cQuery += "                                          AND SE1A.E1_PREFIXO = SE1.E1_PREFIXO  " + Chr(13)
_cQuery += "                                          AND SE1A.E1_NUM = SE1.E1_NUM          " + Chr(13)
_cQuery += "                                          AND SE1A.E1_CLIENTE = SE1.E1_CLIENTE  " + Chr(13)
_cQuery += "                                          AND SE1A.E1_LOJA = SE1.E1_LOJA        " + Chr(13)
_cQuery += "inner join " + RetSqlName("SA3") + " SA3 ON A3_COD = E1_VEND1                   " + Chr(13)
_cQuery += "                 and SA3.D_E_L_E_T_ = ' '                                       " + Chr(13)
_cQuery += "                 and A3__SEGISP = '2'                                           " + Chr(13)
_cQuery += "where SE1.D_E_L_E_T_ = ' '                                                      " + Chr(13)
_cQuery += "  and SE1.E1_EMISSAO >= '20150501'                                              " + Chr(13)
_cQuery += "  and SE1.E1_EMISSAO BETWEEN '" + DTOS(MV_PAR01) + "' AND '" + DTOS(MV_PAR02) + "' " + Chr(13)
_cQuery += "  and SE1.E1_VEND1 BETWEEN '" + MV_PAR03 + "' AND '" + MV_PAR04 + "'            " + Chr(13)
_cQuery += "  and SE1.E1_TIPO = 'NF'                                                        " + Chr(13)
_cQuery += "  and SA3.A3__SEGISP = '" + MV_PAR05 + "'                                       " + Chr(13)
If MV_PAR06 = 1
	_cQuery += "  and SE1.E1__BASIPI > 0                                                    " + Chr(13)
EndIf
//_cQuery += "  AND SF2.F2_VALIPI > 0                                                         " + Chr(13)
_cQuery += "ORDER BY E1_FILIAL,                                                             " + Chr(13)
_cQuery += "         E1_PREFIXO,                                                            " + Chr(13)
_cQuery += "         E1_NUM,                                                                " + Chr(13)
_cQuery += "         E1_PARCELA,                                                            " + Chr(13)
_cQuery += "         E1_TIPO,                                                               " + Chr(13)
_cQuery += "         E1_CLIENTE,                                                            " + Chr(13)
_cQuery += "         E1_LOJA                                                                "
TCQUERY _cQuery NEW ALIAS "TMP_SE1"

If(!eof())
	Do While TMP_SE1->(!eof())
		SE1->(DbGoTo(TMP_SE1->RECSE1))
		Reclock("SE1",.F.)
			SE1->E1__BASIPI := IIF(TMP_SE1->F2_VALIPI = 0,;
									(TMP_SE1->E1_BASCOM1),;
									(TMP_SE1->E1_BASCOM1 + (TMP_SE1->F2_VALIPI / TMP_SE1->QUANT) ))
		SE1->(MsUnlock())
		TMP_SE1->(DbSkip())	
	EndDo
EndIf

MsgInfo("Término de processamento")

RestArea(_aAreaSE1)
RestArea(_aArea)

Return