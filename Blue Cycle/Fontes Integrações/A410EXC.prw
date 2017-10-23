#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | A140EXC  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Adiciona a quantidade de Material em transito entre as filiais   |
|          | na exclusão da Pré-nota na filial de destino.                    |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function A410EXC

Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local cLocal	:= "", _lRet := .t., _aResult := {}
Local cCgcCli	:= Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
Local cFilDest	:= ""



If SC5->C5__STATUS >= "6" //ALTERAR PARA O STATUS CORRETO!!!!!!!

		_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","","EXC","","")

        If !Empty(_aResult)
            If _aResult[1] == "S"
                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
                _lRet := .f.
            Else 
		    	MsgInfo("Envio de exclusao concluido com sucesso","Integracao ArMHAzena")
			EndIf  
        Else
        		Help( Nil, Nil, "EXCRECERR", Nil, "Erro ao enviar exclusao de documento para o WMS", 1, 0 ) 
        		_lRet := .f.
        	
                
		EndIf		    
EndIf


        

            

RestArea(aAreaSB2)
RestArea(aArea)

Return _lRet   