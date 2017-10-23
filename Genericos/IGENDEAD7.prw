
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
_cQuery += "WHERE AD7.D_E_L_E_T_ = ' '								   		" + Chr(13)				
_cQuery += "AND AD7__STAT IN ('00001','1') 									" + Chr(13)
_cQuery += "AND SUA.UA_NUM IS NULL               							" + Chr(13)			
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

TRB_AD7->(DbCloseArea())

//Rubens Cruz - 04/09/2015 - Alterar AD7 com pedidos preenchidos

_cQuery := "SELECT   AD7.AD7_FILIAL,								" + Char(13)
_cQuery += "         AD7.AD7__PED,                                  " + Char(13)
_cQuery += "         SUA.UA_NUM,                                    " + Char(13)
_cQuery += "         AD7.AD7_CODCLI,                                " + Char(13)
_cQuery += "         AD7.AD7_LOJA,                                  " + Char(13)
_cQuery += "         AD7.AD7_TOPICO,                                " + Char(13)
_cQuery += "         AD7.R_E_C_N_O_ AS RECNOAD7,                    " + Char(13)
_cQuery += "         CASE WHEN TO_NUMBER(AD7__STAT) = 1             " + Char(13)
_cQuery += "              THEN '1'                                  " + Char(13)
_cQuery += "         ELSE '2' END AS TIPO                           " + Char(13)
_cQuery += "FROM " + RetSqlName("AD7") + " AD7                      " + Char(13)
_cQuery += "LEFT JOIN " + RetSqlName("SUA") + " SUA ON SUA.UA_FILIAL = AD7.AD7_FILIAL  " + Char(13)    
_cQuery += "             AND SUA.UA_NUM = AD7.AD7__PED              " + Char(13)    
_cQuery += "             AND SUA.UA_CLIENTE = AD7.AD7_CODCLI        " + Char(13)     
_cQuery += "             AND SUA.UA_LOJA = AD7.AD7_LOJA             " + Char(13)   
_cQuery += "             AND SUA.D_E_L_E_T_ = ' '                   " + Char(13)
_cQuery += "WHERE AD7.D_E_L_E_T_ = ' '                              " + Char(13)
_cQuery += "AND AD7__PED != ' '                                     " + Char(13)
_cQuery += "AND SUA.UA_NUM IS NULL                                  "
TcQuery _cQuery New Alias "TRB_AD7"      

DbSelectArea("TRB_AD7")
DbGoTop() 
While TRB_AD7->(!Eof()) 
	DbSelectArea("AD7")
	DbGoTo(TRB_AD7->RECNOAD7)
	Reclock("AD7",.F.)  
		If(TRB_AD7->TIPO == '1')
			dbDelete() 
		Else
			AD7->AD7__PED := ' ' 
		EndIf
	AD7->( MsUnLock() )
    TRB_AD7->(DbSkip())
EndDo			    

TRB_AD7->(DbCloseArea())   

//Rubens Cruz - 04/09/2015 - Grava visita dos pedidos do callcenter sem visita
_cQuery := "SELECT SUA.UA_FILIAL,											" + Char(13)
_cQuery += "       SUA.UA_EMISSAO,                                          " + Char(13)
_cQuery += "       SUA.UA_INICIO,                                           " + Char(13)
_cQuery += "       SUA.UA_FIM,                                              " + Char(13)
_cQuery += "       SUA.UA_CLIENTE,                                          " + Char(13)
_cQuery += "       SUA.UA_LOJA,                                             " + Char(13)
_cQuery += "       SUA.UA_VEND,                                             " + Char(13)
_cQuery += "       SUA.UA_CODCONT,                                          " + Char(13)
_cQuery += "       SUA.UA_PROXLIG,                                          " + Char(13)
_cQuery += "       SUA.UA_TMK,                                              " + Char(13)
_cQuery += "       SUA.UA_NUM,                                              " + Char(13)
_cQuery += "       SUA.UA_OPERADO,                                          " + Char(13)
_cQuery += "       SUA.R_E_C_N_O_                                           " + Char(13)
_cQuery += "FROM " + RetSqlName("SUA") + " SUA                              " + Char(13)
_cQuery += "LEFT JOIN " + RetSqlName("AD7") + " AD7 ON AD7.AD7_FILIAL = SUA.UA_FILIAL " + Char(13)
_cQuery += "                        AND AD7.AD7__PED = SUA.UA_NUM           " + Char(13)
_cQuery += "                        AND AD7.AD7_CODCLI = SUA.UA_CLIENTE     " + Char(13)
_cQuery += "                        AND AD7.AD7_LOJA = SUA.UA_LOJA          " + Char(13)
_cQuery += "                        AND AD7.D_E_L_E_T_ = ' '                " + Char(13)
_cQuery += "WHERE SUA.D_E_L_E_T_ = ' '                                      " + Char(13)
_cQuery += "      AND SUA.UA__TIPPED NOT IN ('4','6')                       " + Char(13)
_cQuery += "      AND SUA.UA__RESEST = 'S'                                  " + Char(13)
_cQuery += "      AND SUA.UA_CANC != 'S'                                    " + Char(13)
_cQuery += "     AND AD7.R_E_C_N_O_ IS NULL                                 "
TcQuery _cQuery New Alias "TRB_AD7"      
TcSetField("TRB_AD7", "UA_EMISSAO"   , "D", 08, 0)
TcSetField("TRB_AD7", "UA_PROXLIG"   , "D", 08, 0)

DbSelectArea("TRB_AD7")
DbGoTop() 
While TRB_AD7->(!Eof()) 
	Reclock("AD7",.T.)  
		AD7->AD7_FILIAL := TRB_AD7->UA_FILIAL
    	AD7->AD7_TOPICO	:= "VISITOU E COMPROU"
    	AD7->AD7_DATA  	:= TRB_AD7->UA_EMISSAO
    	AD7->AD7_HORA1  := TRB_AD7->UA_INICIO
    	AD7->AD7_HORA2  := TRB_AD7->UA_FIM
   		AD7->AD7_CODCLI := TRB_AD7->UA_CLIENTE
   		AD7->AD7_LOJA   := TRB_AD7->UA_LOJA
   		AD7->AD7_VEND   := TRB_AD7->UA_VEND
   		AD7->AD7_ORIGEM := "2"
   		AD7->AD7_CONTAT := TRB_AD7->UA_CODCONT
   		AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
   		AD7->AD7__DTPRE := TRB_AD7->UA_PROXLIG
   		AD7->AD7__DTVIS := TRB_AD7->UA_EMISSAO
   		AD7->AD7__DTPRX := TRB_AD7->UA_PROXLIG
   		AD7->AD7__STAT  := Alltrim(GETMV("MV__MOTVIS"))
   		AD7->AD7__TPOPE := TRB_AD7->UA_TMK
   		AD7->AD7__PED   := TRB_AD7->UA_NUM
   		AD7->AD7__OPERA := TRB_AD7->UA_OPERADO
	AD7->( MsUnLock() )

	ConfirmSX8()

    TRB_AD7->(DbSkip())
EndDo			    

TRB_AD7->(DbCloseArea())   

MsgInfo(Str(_NumP++) + " Registros Deletados!")

Return