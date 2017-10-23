#include "protheus.ch"       
#INCLUDE "topconn.ch"

/*
+-------------+----------+-------+--------------------------------------+------+---------------+
| Programa    | TKGRPED  | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Abril/2014    |
+-------------+----------+-------+--------------------------------------+------+---------------+
| Descricao   | Consulta Padrão de motivo de contato									   	   |
+-------------+--------------------------------------------------------------------------------+
| Uso         | ISAPA													 					   |
+-------------+--------------------------------------------------------------------------------+
*/  

User Function TKGRPED()
Local lRet 		:= .F.
Local cCodRet 	:= ""
Local _aArea 	:= getArea()


if(M->UA_OPER != '1')   
	do while !lRet
		lRet := ConPad1(,,,"SZD_MC",cCodRet,, .F.)
	EndDo
	
	DbSelectArea("AD7")           
	if reclock("AD7", .T.)
		AD7->AD7_FILIAL := xFilial("AD7")
		AD7->AD7_TOPICO	:= Posicione("SU9",1,xFilial("SU9") + SUA->UA_CODLIG, "U9_DESC")
		AD7->AD7_DATA  	:= Date()
		AD7->AD7_HORA1  := Time()	
		AD7->AD7_NROPOR := "" 
		AD7->AD7_CODCLI := SUA->UA_CLIENTE
		AD7->AD7_LOJA   := SUA->UA_LOJA
		AD7->AD7_VEND   := SUA->UA_VEND
		AD7->AD7_ORIGEM := "2"
		AD7->AD7_PROSPE := ""
		AD7->AD7_CONTAT := SUA->UA_CODCONT
		AD7->AD7__NUM   := GetSXENum("AD7","AD7_NUM")
		AD7->AD7__DTPRE := SUA->UA_PROXLIG
		AD7->AD7__DTVIS := Date()	
		AD7->AD7__DTPRX := SUA->UA_PROXLIG
		AD7->AD7__STAT  := SZD->ZD_COD
		AD7->AD7__PREP  := ""
		AD7->AD7__TPOPE := ""
		AD7->AD7__PED   := SUA->UA_NUM
		MsUnlock() 
	endif

	
EndIf           

restarea(_aArea)
	
Return lRet