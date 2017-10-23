User Function FA050FIN



If SE2->E2_TIPO = "RC" 
	RecLock("SE2",.F.) 
	SE2->E2_DATALIB := Date()
	MsUnlock("SE2")
EndIf



Return