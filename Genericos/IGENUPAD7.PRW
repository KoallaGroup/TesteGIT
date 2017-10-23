#include "protheus.ch"
#INCLUDE "topconn.ch"                                                                                                                                                          

User Function IGENUPAD7()
                         
Local _cQuery	:= ""  
Local _NumP := 0

If(select("TRB_AD7") > 0)
	TRB_AD7->(DbCloseArea())
EndIf

_cQuery := "SELECT 	AD7.AD7__DTVIS, 								   		" + Chr(13)
_cQuery += "SUA.UA_EMISSAO, 										  		" + Chr(13)
_cQuery += "AD7.AD7__NUM, 											   		" + Chr(13)
_cQuery += "SUA.UA_NUM, 											   		" + Chr(13)
_cQuery += "SUA.UA_CLIENTE, 										   		" + Chr(13)
_cQuery += "AD7.AD7_CODCLI, 										   		" + Chr(13)
_cQuery += "SUA.UA_LOJA,													" + Chr(13)
_cQuery += "AD7.AD7_LOJA, 													" + Chr(13)
_cQuery += "AD7.AD7_FILIAL,	 												" + Chr(13)  
_cQuery += "AD7.R_E_C_N_O_ RECNOAD7											" + Chr(13)  
_cQuery += "FROM AD7010 AD7            										" + Chr(13)			 
_cQuery += "INNER JOIN SUA010 SUA ON SUA.UA_FILIAL = AD7.AD7_FILIAL   		" + Chr(13)
_cQuery += "						 AND SUA.UA_NUM = AD7.AD7__PED        	" + Chr(13)  				
_cQuery += "						 AND SUA.UA_CLIENTE = AD7.AD7_CODCLI    " + Chr(13)         		
_cQuery += "						 AND SUA.UA_LOJA = AD7.AD7_LOJA         " + Chr(13)  			
_cQuery += "						 AND SUA.D_E_L_E_T_ = ' '               " + Chr(13)  				
_cQuery += "WHERE AD7.D_E_L_E_T_ = ' '										" + Chr(13)				
//_cQuery += "	AND SUA.UA_EMISSAO >= '20150701'                            " + Chr(13)			
_cQuery += "	AND AD7.AD7__DTVIS	<> SUA.UA_EMISSAO                       " + Chr(13)
  


TcQuery _cQuery New Alias "TRB_AD7"      

DbSelectArea("TRB_AD7")
DbGoTop() 
While TRB_AD7->(!Eof()) 
	DbSelectArea("AD7")
	DbGoTo(TRB_AD7->RECNOAD7)
	Reclock("AD7",.F.)  
		AD7->AD7__DTVIS := StoD(TRB_AD7->UA_EMISSAO)  
	AD7->( MsUnLock() )
	dbselectarea("TRB_AD7")
    TRB_AD7->(DbSkip())
    _NumP++
EndDo			  

MsgInfo(Str(_NumP++) + " Registros Alterados!")

Return