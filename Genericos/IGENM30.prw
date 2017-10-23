#include "protheus.ch" 
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM30	 		  		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Rotina criada para ajustar as movimentacoes de transferencia com custo gerado   |
|-----------------------------------------------------------------------------------------------|	
*/          
User Function IGENM30()

	Processa({|| IGENM30A() },"Ajustando campo D3_CUSTO1",,.T.)

	MsgInfo("Registros processados com sucesso")

Return


Static Function IGENM30A()
Local _cQuery	:= ""
Local _cTab		:= 	GetNextAlias()

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf	

_cQuery := "SELECT SD3.D3_FILIAL,											" + Chr(13)
_cQuery += "       SD3.D3_COD,                                              " + Chr(13)
_cQuery += "       SD3.D3_EMISSAO,                                          " + Chr(13)
_cQuery += "       SD3.D3_QUANT,                                            " + Chr(13)
_cQuery += "       MAX(SD3.D3_CUSTO1) AS CUSTO,                             " + Chr(13)
_cQuery += "       MIN(CASE WHEN SD3.D3_CUSTO1 = 0                          " + Chr(13)
_cQuery += "                     THEN SD3.R_E_C_N_O_ END) AS RECSD3,        " + Chr(13)
_cQuery += "       COUNT(SD3.R_E_C_N_O_) AS CONTAR                          " + Chr(13)
_cQuery += "FROM " + RetSqlName("SD3") + " SD3                              " + Chr(13)
_cQuery += "WHERE SD3.D_E_L_E_T_ = ' '                                      " + Chr(13)
_cQuery += "      AND SD3.D3_USUARIO = ' '                                  " + Chr(13)
_cQuery += "GROUP BY SD3.D3_FILIAL,                                         " + Chr(13)
_cQuery += "         SD3.D3_COD,                                            " + Chr(13)
_cQuery += "         SD3.D3_EMISSAO,                                        " + Chr(13)
_cQuery += "         SD3.D3_QUANT                                           " + Chr(13)
_cQuery += "HAVING COUNT(SD3.R_E_C_N_O_) > 1 AND MIN(SD3.D3_CUSTO1) = 0     " + Chr(13)
_cQuery += "ORDER BY CONTAR DESC                                            "
TcQuery _cQuery New Alias (_cTab)
        
ProcRegua(RecCount())

DbSelectArea("SD3")
If(_cTab)->(!Eof())
	While (_cTab)->(!Eof())
		IncProc()
		SD3->(DbGoTo((_cTab)->RECSD3))
		Reclock("SD3",.F.)
			SD3->D3_CUSTO1 := (_cTab)->CUSTO
			SD3->D3_TM := '003'
			SD3->D3_CF := 'DE6'
		SD3->(MsUnlock())         
		(_cTab)->(DbSkip())
	EndDo
EndIf

(_cTab)->(DbCloseArea())

Return