#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function F150EXC
                
_lRet := .t.
If Empty(SE1->E1_NOSSNUM)
	MsgInfo("Aten��o, o t�tulo: " +  SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_NOMCLI)+" n�o foi impresso boleto, n�o ser� considerado no Bordero!")
	_lRet := .f.
Endif
     
Return(_lRet)