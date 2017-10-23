User Function MT103EXC() 

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | A140EXC  | Autor |  QSdoBrasil              | Data |  Dez/2015   |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Envia a exclusao da Nota Fiscal de Entrada para o MHA            |
|          |                                                                  |
+----------+------------------------------------------------------------------+
|Uso       | BlueCycle                                                        |
+----------+------------------------------------------------------------------+
*/

_lRet := .T. 

If SF1->F1__WMSINT == "1" 
    _aResult := TCSPEXEC("PROC_PMHA_INTER_RECEBIMENTO",SF1->(recno()),"EXC")
    
    If !Empty(_aResult)
    	If _aResult[1] == "S"
    		Help( Nil, Nil, "EXCREC", Nil, _aResult[2], 1, 0 )  
    		_lRet := .f.
    	Else
    		MsgInfo("Envio de exclusao concluido com sucesso","Integracao ArMHAzena")
    	EndIf
    Else
    	Help( Nil, Nil, "EXCRECERR", Nil, "Erro ao enviar exclusao de documento para o WMS", 1, 0 ) 
    	_lRet := .f.
    EndIf
    If !_lRet
         Return .f.
    EndIf
EndIf

Return _lRet