User function ValidQt()

Local lRet := .T.

If  (SB1->B1_SOMULT > 0 )
 IF (MOD( m->c6_qtdven,  SB1->b1_SOMULT) <> 0)
  lRet := .F.
  Alert('A Quantida informada n�o � m�ltipla de ' + cValToChar(SB1->b1_SOMULT))
 EndIf
EndIf

Return(lRet)