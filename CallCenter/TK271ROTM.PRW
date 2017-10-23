#INCLUDE 'PROTHEUS.CH'

User Function TK271ROTM()

local aRotina := {}

//Adiciona Rotina Customizada aos botoes do Browsea

if TkGetTipoAte() == '2' //Televendas
	Aadd( aRotina, { 'Reabertura Ped' ,'U_ITMKA08(SUA->UA_NUM)', 0 , 7 })
	//   Aadd( aRotina, { 'Log Reabertura' ,"U_ITMKA13('" + SUA->UA_NUM + "')", 0 , 7 })
EndIf

Return aRotina
