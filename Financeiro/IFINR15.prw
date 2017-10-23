#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#INCLUDE 'FONT.CH'
#INCLUDE 'COLORS.CH'

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR15 | Autor: | Rubens Cruz        | Data: | Abril/2015 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Adiantamento aos Fornecedores	             |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------------------------------------------+
*/
                           
User Function IFINR15() 
Local cPerg		:= PADR("IFINR15",Len(SX1->X1_GRUPO))  
Local aPergs 	:= {}
Local cOptions 	:= "1;0;1;Relatório de Adiantamento aos Fornecedores"
Local cParams	:= ""
//Local cCliente	:= GetMV("MV__CLIDEP")

Aadd(aPergs,{"Filial De "		,"","","mv_ch1","C",TamSx3("E1_FILIAL")[1]	,0,0,"G",""												,"MV_PAR01",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","DLB" 		,"","","",""})
Aadd(aPergs,{"Filial Ate "		,"","","mv_ch2","C",TamSx3("E1_FILIAL")[1]	,0,0,"G",""												,"MV_PAR02",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","DLB" 		,"","","",""})
Aadd(aPergs,{"Fornecedor De "	,"","","mv_ch3","C",TamSx3("A2_COD")[1]		,0,0,"G",""		  										,"MV_PAR03",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SA2"		,"","","",""})
Aadd(aPergs,{"Fornecedor Ate "	,"","","mv_ch4","C",TamSx3("A2_COD")[1]		,0,0,"G",""												,"MV_PAR04",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SA2"		,"","","",""})
Aadd(aPergs,{"Loja De "			,"","","mv_ch5","C",TamSx3("A2_LOJA")[1]	,0,0,"G",""		  										,"MV_PAR05",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SA2LJA"	,"","","",""})
Aadd(aPergs,{"Loja Ate "		,"","","mv_ch6","C",TamSx3("A2_LOJA")[1]	,0,0,"G",""												,"MV_PAR06",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SA2LJA"	,"","","",""})
Aadd(aPergs,{"Data Referencia "	,"","","mv_ch7","D",08						,0,0,"G",""												,"MV_PAR07",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","",""			,"","","",""})
Aadd(aPergs,{"Lancamento De "	,"","","mv_ch8","D",08						,0,0,"G",""												,"MV_PAR08",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","","",""	,"",""})
Aadd(aPergs,{"Lancamento Ate "	,"","","mv_ch9","D",08						,0,0,"G",""												,"MV_PAR09",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","","",""	,"",""})
Aadd(aPergs,{"Tipo Mov. De "	,"","","mv_cha","C",TamSx3("E2_NATUREZ")[1]	,0,0,"G",""												,"MV_PAR10",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SEDISA"	,"","","",""})
Aadd(aPergs,{"Tipo Mov. Ate" 	,"","","mv_chb","C",TamSx3("E2_NATUREZ")[1]	,0,0,"G",""												,"MV_PAR11",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","",""			,"","","",""})
Aadd(aPergs,{"Codigo Processo"	,"","","mv_chc","C",TamSx3("Z2_CODIGO")[1]	,0,0,"G",""												,"MV_PAR12",""			,"","","","",""				,"","","","",""			,"","","","",""					,"","","","","","","","","SZ2"		,"","","",""})
Aadd(aPergs,{"Tipo Relatorio"	,"","","mv_chd","N",01						,0,0,"C",""												,"MV_PAR13","Entrada"	,"","","","","Baixa"		,"","","","","Saldo"	,"","","","","Baixa e Saldo"	,"","","","","","","","",""			,"","","",""})

AjustaSx1(cPerg,aPergs)

If !Pergunte (cPerg,.T.)
	Return
EndIf    

/*
tabela SZY amarra cod processo com titulo
*/



/*cParams := cCliente + ";"
cParams += DTOS(MV_PAR01) + ";"
cParams += DTOS(MV_PAR02) + ";"
cParams += MV_PAR03 + ";"
cParams += MV_PAR04 + ";"
cParams += Alltrim(Str(MV_PAR06)) + ";" */

CallCrys('IFINCR15', cParams,cOptions)

Return