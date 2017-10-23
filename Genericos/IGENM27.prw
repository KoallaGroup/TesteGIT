#include "protheus.ch" 
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : IGENM27	 		  		| 	Maio de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Rotina criada para incluir o codigo do usuario que criou ou alterou o item no   |
|				call center no campo UB__CODUSR			  										|
|-----------------------------------------------------------------------------------------------|	
*/          
User Function IGENM27()

	Processa({|| IGENM27A() },"Ajustando campo UB__CODUSR",,.T.)

	MsgInfo("Registros processados com sucesso")

Return


Static Function IGENM27A()
Local _cQuery	:= ""
Local _cTab		:= 	GetNextAlias()

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf	

_cQuery := "SELECT SUB.UB_FILIAL,															" + Chr(13)
_cQuery += "       SUB.UB_NUM,                                                              " + Chr(13)
_cQuery += "       SUB.UB_ITEM,                                                             " + Chr(13)
_cQuery += "       SUB.UB_PRODUTO,                                                          " + Chr(13)
_cQuery += "       SUB.UB__USEINC,                                                          " + Chr(13)
_cQuery += "       SU7INC.U7_CODUSU,                                                        " + Chr(13)
_cQuery += "       SUB.UB__USEALT,                                                          " + Chr(13)
_cQuery += "       SU7ALT.U7_CODUSU,                                                        " + Chr(13)
_cQuery += "       SUB.UB__CODUSR,                                                          " + Chr(13)
_cQuery += "       CASE WHEN SU7INC.U7_CODUSU != ' '                                        " + Chr(13)
_cQuery += "            THEN SU7INC.U7_CODUSU                                               " + Chr(13)
_cQuery += "       ELSE SU7ALT.U7_CODUSU END AS CODUSER,                                    " + Chr(13)
_cQuery += "       SUB.R_E_C_N_O_ AS SUBRECNO           		                            " + Chr(13)
_cQuery += "FROM " + RetSqlName("SUB") + " SUB                                              " + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SUA") + " SUA    ON SUA.UA_FILIAL = SUB.UB_FILIAL    " + Chr(13)
_cQuery += "                            AND SUA.UA_NUM = SUB.UB_NUM                         " + Chr(13)
_cQuery += "                            AND SUA.D_E_L_E_T_ = ' '                            " + Chr(13)
_cQuery += "LEFT JOIN " + RetSqlName("SU7") + " SU7INC ON SU7INC.U7_FILIAL = '  '           " + Chr(13)
_cQuery += "                            AND SU7INC.U7_NOME = SUB.UB__USEINC                 " + Chr(13)
_cQuery += "                            AND SU7INC.D_E_L_E_T_ = ' '                         " + Chr(13)
_cQuery += "LEFT JOIN " + RetSqlName("SU7") + " SU7ALT ON SU7ALT.U7_FILIAL = '  '           " + Chr(13)
_cQuery += "                            AND SU7ALT.U7_NOME = SUB.UB__USEALT                 " + Chr(13)
_cQuery += "                            AND SU7ALT.D_E_L_E_T_ = ' '                         " + Chr(13)
_cQuery += "WHERE SUB.D_E_L_E_T_ = ' '                                                      " + Chr(13)
_cQuery += "      AND SUB.UB__CODUSR = ' '                                                  "
TcQuery _cQuery New Alias (_cTab)
        
ProcRegua(RecCount())

DbSelectArea("SUB")
If(_cTab)->(!Eof())
	While (_cTab)->(!Eof())
		IncProc()
		SUB->(DbGoTo((_cTab)->SUBRECNO))
		Reclock("SUB",.F.)
			SUB->UB__CODUSR := (_cTab)->CODUSER
		SUB->(MsUnlock())         
		(_cTab)->(DbSkip())
	EndDo
EndIf

(_cTab)->(DbCloseArea())

Return