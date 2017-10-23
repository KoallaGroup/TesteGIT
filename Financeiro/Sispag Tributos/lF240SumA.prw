User function F240SUMA()

	Public nValret2

nValret:=SE2->E2_SDACRES 
If SEA->EA_MODELO$ "17" .AND. SE2->E2__VOUTRA <> 0                                                            
nValret2 := SE2->E2__VOUTRA
EndIF 
Return nValret

User Function F240GER()
 Public nValret2 := 0
return .t. 
