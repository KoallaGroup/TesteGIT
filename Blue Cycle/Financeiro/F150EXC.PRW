#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function F150EXC
                
_lRet := .t.
If Empty(SE1->E1_NOSSNUM)
	MsgInfo("Atenção, o título: " +  SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_NOMCLI)+" não foi impresso boleto, não será considerado no Bordero!")
	_lRet := .f.
Endif
     
Return(_lRet)