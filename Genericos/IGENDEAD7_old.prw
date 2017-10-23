
#include "protheus.ch"
#INCLUDE "topconn.ch"                                                                                                                                                          

User Function IGENDEAD7()
                         
Local _cQuery	:= ""  
Local _NumP := 0

If(select("TRB_AD7") > 0)
	TRB_AD7->(DbCloseArea())
EndIf

_cQuery := "SELECT 	AD7.R_E_C_N_O_ AS RECNOAD7								" + Chr(13)		 
_cQuery += "FROM AD7010 AD7            										" + Chr(13)			 
_cQuery += "LEFT JOIN SUA010 SUA ON SUA.UA_FILIAL = AD7.AD7_FILIAL   		" + Chr(13)
_cQuery += "						 AND SUA.UA_NUM = AD7.AD7__PED        	" + Chr(13) 				
_cQuery += "						 AND SUA.UA_CLIENTE = AD7.AD7_CODCLI    " + Chr(13)      		
_cQuery += "						 AND SUA.UA_LOJA = AD7.AD7_LOJA         " + Chr(13) 			
_cQuery += "						 AND SUA.D_E_L_E_T_ = ' ' 				" + Chr(13)
_cQuery += "						 AND SUA.UA_NUM IS NULL               	" + Chr(13)			
_cQuery += "WHERE AD7.D_E_L_E_T_ = ' '								   		" + Chr(13)				
_cQuery += "AND AD7__STAT IN ('00001','1') 									" + Chr(13)
_cQuery += "AND AD7__PED = ' '   											" + Chr(13)

TcQuery _cQuery New Alias "TRB_AD7"      

DbSelectArea("TRB_AD7")
DbGoTop() 
While TRB_AD7->(!Eof()) 
	DbSelectArea("AD7")
	DbGoTo(TRB_AD7->RECNOAD7)
	Reclock("AD7",.F.)  
		dbDelete() 
	AD7->( MsUnLock() )
    TRB_AD7->(DbSkip())
    _NumP++
EndDo			  

MsgInfo(Str(_NumP++) + " Registros Deletados!")

Return