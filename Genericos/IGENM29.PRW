#include "protheus.ch" 
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM29	 		  		| 	Julho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Rotina criada para remover duplicidades na SD3								    |
|-----------------------------------------------------------------------------------------------|	
*/          

User Function IGENM29()                          

	Processa({|| IGENM29A() },"Removendo duplicidades da SD3",,.T.)
	
	MsgInfo("Registros processados com sucesso")

Return  
               

Static Function IGENM29A()
Local _cQuery	:= ""
Local _cTab		:= 	GetNextAlias()

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf	

//Query para apagar duplicados
_cQuery := "SELECT SD3.D3_FILIAL,																				" + Chr(13)
_cQuery += "       SD3.D3_TM,                                                                                   " + Chr(13)
_cQuery += "       SD3.D3_COD,                                                                                  " + Chr(13)
_cQuery += "       SD3.D3_LOCAL,                                                                                " + Chr(13)
_cQuery += "       SD3.D3__DOC,                                                                                 " + Chr(13)
_cQuery += "       SD3.D3__SERIE,                                                                               " + Chr(13)
_cQuery += "       SD3.D3__ITEM,                                                                                " + Chr(13)
_cQuery += "       SD3.D3__FORNEC,                                                                              " + Chr(13)
_cQuery += "       SD3.D3__LOJA,                                                                                " + Chr(13)
_cQuery += "       SD3.R_E_C_N_O_ AS SD3REC,                                                                    " + Chr(13)
_cQuery += "       SD3A.RECSD3 AS SD3AREC                                                                       " + Chr(13)
_cQuery += "FROM " + RetSqlName("SD3") + " SD3                                                                  " + Chr(13)
_cQuery += "INNER JOIN (SELECT SD3.D3_FILIAL,                                                                   " + Chr(13)
_cQuery += "                     D3_TM,                                                                         " + Chr(13)
_cQuery += "                       D3_COD,                                                                      " + Chr(13)
_cQuery += "                       D3_LOCAL,                                                                    " + Chr(13)
_cQuery += "                       D3__DOC,                                                                     " + Chr(13)
_cQuery += "                       D3__SERIE,                                                                   " + Chr(13)
_cQuery += "                       D3__ITEM,                                                                    " + Chr(13)
_cQuery += "                       D3__FORNEC,                                                                  " + Chr(13)
_cQuery += "                       D3__LOJA,                                                                    " + Chr(13)
_cQuery += "                       MAX(SD3.R_E_C_N_O_) AS RECSD3                                                " + Chr(13)
_cQuery += "              FROM " + RetSqlName("SD3") + " SD3                                                    " + Chr(13)
_cQuery += "              WHERE SD3.D_E_L_E_T_ = ' '                                                            " + Chr(13)
_cQuery += "                    AND SD3.D3__DOC != ' '                                                          " + Chr(13)
_cQuery += "                    AND SD3.D3__SERIE != ' '                                                        " + Chr(13)
_cQuery += "                    AND SD3.D3__FORNEC != ' '                                                       " + Chr(13)
_cQuery += "                    AND SD3.D3__LOJA != ' '                                                         " + Chr(13)
_cQuery += "                    AND SD3.D3_ESTORNO = ' '                                                        " + Chr(13)
_cQuery += "              GROUP BY SD3.D3_FILIAL,                                                               " + Chr(13)
_cQuery += "                       D3_TM,                                                                       " + Chr(13)
_cQuery += "                       D3_COD,                                                                      " + Chr(13)
_cQuery += "                       D3_LOCAL,                                                                    " + Chr(13)
_cQuery += "                       D3__DOC,                                                                     " + Chr(13)
_cQuery += "                       D3__SERIE,                                                                   " + Chr(13)
_cQuery += "                       D3__ITEM,                                                                    " + Chr(13)
_cQuery += "                       D3__FORNEC,                                                                  " + Chr(13)
_cQuery += "                       D3__LOJA                                                                     " + Chr(13)
_cQuery += "              HAVING COUNT(SD3.R_E_C_N_O_) > 1) SD3A ON SD3A.D3_FILIAL = SD3.D3_FILIAL              " + Chr(13)
_cQuery += "                                                            AND SD3A.D3_TM = SD3.D3_TM              " + Chr(13)
_cQuery += "                                                            AND SD3A.D3_COD = SD3.D3_COD            " + Chr(13)
_cQuery += "                                                            AND SD3A.D3_LOCAL = SD3.D3_LOCAL        " + Chr(13)
_cQuery += "                                                            AND SD3A.D3__DOC = SD3.D3__DOC          " + Chr(13)
_cQuery += "                                                            AND SD3A.D3__SERIE = SD3.D3__SERIE      " + Chr(13)
_cQuery += "                                                            AND SD3A.D3__ITEM = SD3.D3__ITEM        " + Chr(13)
_cQuery += "                                                            AND SD3A.D3__FORNEC = SD3.D3__FORNEC    " + Chr(13)
_cQuery += "                                                            AND SD3A.D3__LOJA = SD3.D3__LOJA        " + Chr(13)
_cQuery += "WHERE SD3.D_E_L_E_T_ = ' '                                                                          " + Chr(13)
_cQuery += "      AND SD3.R_E_C_N_O_ != SD3A.RECSD3                                                             "
TcQuery _cQuery New Alias (_cTab)
        
ProcRegua(RecCount())

DbSelectArea("SD3")
If(_cTab)->(!Eof())
	While (_cTab)->(!Eof())
		IncProc()
		SD3->(DbGoTo((_cTab)->SD3REC))
		Reclock("SD3",.F.)
			Delete
		SD3->(MsUnlock())         
		(_cTab)->(DbSkip())
	EndDo
EndIf

(_cTab)->(DbCloseArea())

Return