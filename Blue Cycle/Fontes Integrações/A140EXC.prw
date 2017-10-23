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

User Function A140EXC

Local aArea		:= GetArea()
Local aAreaSB2	:= SB2->(GetArea())
Local aAreaSM0	:= SM0->(GetArea())
Local cLocal	:= "", _lRet := .t., _aResult := {}
Local cCgcCli	:= Posicione("SA2",1,xFilial("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA,"A2_CGC")
Local cFilDest	:= ""

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
    EndIf[
    If !_lRet
         Return .f.
    EndIf
EndIf


dbSelectArea("Z05")
dbSetOrder(5)
if dbSeek(xFilial("Z05")+SF1->F1_DOC+SF1->F1_SERIE) 
	do while Z05->Z05_DOC == SF1->F1_DOC .and. Z05->Z05_SERIE == SF1->F1_SERIE
	 	if reclock("Z05",.F.)
	 		delete 	
	 	endif
	 	msUnlock()
	 	Z05->(dbSkip())
 	enddo
endif


If SF1->F1_TIPO == "N" .and. Empty(SF1->F1_STATUS)
	
	DbSelectArea("SM0")
	DbGoTop()
	
	While !EOf()
		
		IF cCgcCli == SM0->M0_CGC
			cFilDest := SM0->M0_CODFIL
			Exit
		ENDIF
		
		DbSkip()
		
	EndDo
	
	RestArea(aAreaSM0)
	
	If Empty(cFilDest)
		RestArea(aAreaSB2)
		RestArea(aArea)
		Return .T.
	EndIf
	
	DbSelectArea("SD2")
	DbSetOrder(3) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	If DbSeek(cFilDest+ SF1->F1_DOC + SF1->F1_SERIE)
		
		While ! Eof() .AND. SD2->D2_FILIAL == cFilDest .AND. SD2->D2_DOC == SF1->F1_DOC .AND. SD2->D2_SERIE == SF1->F1_SERIE
			
			cLocal	:= Posicione("SB1",1,xFilial("SB1")+SD2->D2_COD,"B1_LOCPAD")

			DbSelectArea("SF4")
			DbSetOrder(1)
			If DbSeek(SF4->(xFilial("SF4")+SD2->D2_TES))
				If SF4->F4_ESTOQUE != "S"
					DbSelectArea("SD2")
					DbSkip()
					Loop			
				EndIf
			EndIf
						
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2")+SD2->D2_COD+cLocal)
				Do While !reclock("SB2", .F.)
				EndDo
				SB2->B2__QTDTRA := SB2->B2__QTDTRA + SD2->D2_QUANT
				msUnlock()
			EndIf
			
			DbSelectArea("SD2")
			DbSkip()
			
		EndDo
		
	EndIf
	
EndIf      
         

      

            

RestArea(aAreaSB2)
RestArea(aArea)

Return .T.   