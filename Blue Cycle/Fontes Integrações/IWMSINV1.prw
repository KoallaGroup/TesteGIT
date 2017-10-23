#Include "Protheus.ch"

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | IWMSINV1 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Setembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Ponto de entrada para reenviar inventario ao WMS										|
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			 	|
+------------+--------------------------------------------------------------------------------------+
*/

User Function IWMSINV1()
Local _aResult := {}, _lRet := .f., _cSQL := "" 

If MsgYesNo("Fazer envio do inventario ao ArMHAzena?","ATENCAO")

	_aResult := TCSPEXEC("PROC_PMHA_INTER_INVENTARIO",SB7->B7_FILIAL,SB7->B7__SEGISP,SB7->B7_DOC,SB7->B7_LOCAL,DTOS(SB7->B7_DATA))
	If !Empty(_aResult)
		If _aResult[1] == "S"
			Help( Nil, Nil, "ENVINVENT", Nil, _aResult[2], 1, 0 ) 
			_lRet := .f. 
		Else
			MsgInfo("Envio concluido com sucesso","Integracao ArMHAzena")

			//Atualiza o flag de envio
			_cSQL := "Update " + RetSqlName("SB7") + " "
			_cSQL += "Set B7__ENVWMS = 'S' "
			_cSQL += "Where B7_FILIAL = '" + SB7->B7_FILIAL + "' And B7_DOC = '" + SB7->B7_DOC + "' And B7_LOCAL = '" + SB7->B7_LOCAL + "' And "
			_cSQL +=		"B7_DATA = '" + DTOS(SB7->B7_DATA) + "' And B7__SEGISP = '" + SB7->B7__SEGISP + "' And D_E_L_E_T_ = ' ' "
			
		   	Begin Transaction
			 	TCSQLExec(_cSQL)
		    End Transaction

		EndIf
	Else
		Help( Nil, Nil, "ERRINVENT", Nil, "Erro ao enviar o inventario para o WMS", 1, 0 ) 
		_lRet := .f.
	EndIf

EndIf

Return   



