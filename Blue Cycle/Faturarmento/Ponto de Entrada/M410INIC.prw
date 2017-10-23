#Include 'Protheus.ch'

User Function M410INIC()  
	If Type("nIDAtende") <> "U"
		M->C5_TIPO 		:= "N"
		M->C5_IDATEN  	:= nIDAtende  
		M->C5__STATUS	:= cStatus
	Endif
Return

