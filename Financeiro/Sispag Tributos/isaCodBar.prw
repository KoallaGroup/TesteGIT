User Function IsaCodBar()
Local cRet

If SEA->EA_MODELO == "13" .AND. SE2->E2__GPS01 == "99"

cRet := SUBSTR(SE2->E2__FGTS03,1,11) + SUBSTR(SE2->E2__FGTS03,13,11) + SUBSTR(SE2->E2__FGTS03,25,11) + SUBSTR(SE2->E2__FGTS03,37,11) + SPACE(4)
              
ElseIf(Empty(SE2->E2__FGTS03))

cRet := SE2->E2__FGTS03

Else

cRet := SE2->E2__FGTS03

EndIf

Return(cRet)