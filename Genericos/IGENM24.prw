#include "protheus.ch" 
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM24	 		  		| 	Maio de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Fonte para ajustar calculo do frete das notas que geraram IVA			  		|
|-----------------------------------------------------------------------------------------------|	
*/

User Function IGENM24()
Local _cQuery 	:= ""
Local _cTab		:= GetNextAlias()
Local _cTab2	:= GetNextAlias()
Local _nTotFret	:= 0
Local _nCont	:= 0
Local _nFator	:= 0

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf	

_cQuery := "SELECT SD1.D1_FILIAL,                                                         			" + Chr(13)
_cQuery += "       SD1.D1__NRCONH,                                                        			" + Chr(13)
_cQuery += "        MIN(SD1.D1_FILIAL || SD1.D1_DOC || SD1.D1_SERIE || SD1.D1_FORNECE || SD1.D1_LOJA) AS NOTABASE,  	" + Chr(13)
_cQuery += "      COUNT(DISTINCT SD1.D1_FILIAL || SD1.D1_DOC || SD1.D1_SERIE) AS CONTAR   			" + Chr(13)
_cQuery += "FROM " + RetSqlName("SD1") + " SD1                                            			" + Chr(13)
_cQuery += "WHERE SD1.D_E_L_E_T_ = ' '                                                    			" + Chr(13)
_cQuery += "      AND SD1.D1__NRCONH != ' '                                               			" + Chr(13)
_cQuery += "      AND SD1.D1_DTDIGIT >= '20150501'                                        			" + Chr(13)
_cQuery += "GROUP BY SD1.D1_FILIAL,SD1.D1__NRCONH                                         			" + Chr(13)
_cQuery += "HAVING COUNT(DISTINCT SD1.D1_FILIAL || SD1.D1_DOC || SD1.D1_SERIE) > 1        			" + Chr(13)
_cQuery += "       AND SD1.D1_FILIAL = '04'                                               			" + Chr(13)
//_cQuery += "       AND SD1.D1__NRCONH = '9651646'                                          			" + Chr(13)
_cQuery += "ORDER BY CONTAR DESC, SD1.D1__NRCONH ASC                                      			"
TcQuery _cQuery New Alias (_cTab)

Do While !(_cTab)->(eof())
	_nTotFret := 0

	DbSelectArea("SD1")
	DbSetOrder(1)
	If DbSeek( (_cTab)->NOTABASE )
		Do While ( !SD1->(eof()) .AND. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == (_cTab)->NOTABASE )
			_nTotFret 	+= SD1->D1__VLRFRE
			            
			SD1->(DbSkip())
		EndDo
	EndIf

	_cQuery := "SELECT SD1.D1_DOC,                                " + Chr(13)
	_cQuery += "       SD1.D1_SERIE,                              " + Chr(13)
	_cQuery += "       SD1.D1_TES,                                " + Chr(13)
	_cQuery += "       SD1.D1_TOTAL,                              " + Chr(13)
	_cQuery += "       MAX(SD1.D1_TES) OVER() AS ACLAS,           " + cHR(13)
	_cQuery += "       SD1.R_E_C_N_O_ AS SD1RECNO,                " + Chr(13)
	_cQuery += "       SUM(SD1.D1_TOTAL) OVER() AS TOTAL          " + Chr(13)
	_cQuery += "FROM " + RetSqlName("SD1") + " SD1                " + Chr(13)
	_cQuery += "WHERE SD1.D_E_L_E_T_  = ' '                       " + Chr(13)
	_cQuery += "      AND SD1.D1__NRCONH = '" + (_cTab)->D1__NRCONH + "'    " + Chr(13)
	_cQuery += "      AND SD1.D1__NRCONH != ' '    				  " + Chr(13)
	_cQuery += "ORDER BY SD1.D1_DOC ASC	                          "
	TcQuery _cQuery New Alias (_cTab2)


	_nFator := (_nTotFret/(_cTab2)->TOTAL)

	DbSelectArea("SD1")
	Do While !(_cTab2)->(eof())
//		If( Empty((_cTab2)->D1_TES) )
			DbGoTo((_cTab2)->SD1RECNO)
			RecLock("SD1",.F.)
				SD1->D1__VLRFRE := SD1->D1_TOTAL * _nFator 
			SD1->(MsUnlock())
//		EndIf
	     (_cTab2)->(DbSkip())
	EndDo
	(_cTab2)->(DbCloseArea())

	(_cTab)->(Dbskip())
EndDo

(_cTab)->(DbCloseArea()) 

MsgInfo("Finalizado!!!")

Return