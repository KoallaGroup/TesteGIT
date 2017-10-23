#Include "Protheus.ch"

/*
+------------+-----------+--------+------------------------------------------+-------+-------------+
| Programa:  | IWEBEST01 | Autor: | Jorge Henrique Alves - Anadi Consultoria | Data: | Agosto/2014 |
+------------+-----------+--------+------------------------------------------+-------+-------------+
| Descrição: | Schedule para popular tabela de estoque disponivel a ser usada pelo Webline		   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa																			   |
+------------+-------------------------------------------------------------------------------------+
*/

User Function IWEBEST01()
Local _nQuant := 0, _lRec := .f.
RpcSetEnv( "01" ,"01",,,"EST",GetEnvServer())
RpcSetType(3) 

If (Date() > GetMv("MV__WEBDIA")) .Or. (ElapTime(Alltrim(GetMv("MV__WEBHRA")),Time()) >= Alltrim(GetMv("MV__WEBINT")))

	dbSelectArea("SX6")
	PutMv("MV__WEBDIA",Date())
	
	dbSelectArea("SX6")
	PutMv("MV__WEBHRA",Time())
	
	DbSelectArea("SM0")
	dbSetOrder(1)
	DbGoTop()
	
	While !Eof()
		
		DbSelectArea("SB2")
		DbSetOrder(1)
		DbGoTop()
		DbSeek(SM0->M0_CODFIL)
		
		While !Eof() .And. SB2->B2_FILIAL == SM0->M0_CODFIL
		
			If !(SB2->B2_LOCAL $ Alltrim(GetMV("MV__LOCPAD")))
				DbSelectArea("SB2")
				DbSkip()
				Loop
			EndIf
		
			_nQuant := U_xSldPrd3(SB2->B2_FILIAL,SB2->B2_COD,Alltrim(Separa(GetMv("MV__ARMVEN"),";")[1]),"ZZZ"," "," "," ",Alltrim(Separa(GetMv("MV__ARMVEN"),";")[2]))   
			//U_xSldProd(SB2->B2_FILIAL,SB2->B2_COD,SB2->B2_LOCAL)
			
			DbSelectArea("Z09")
			DbSetOrder(1)
			If DbSeek(SB2->B2_FILIAL + SB2->B2_COD + SB2->B2_LOCAL)
			
				While !Reclock("Z09",.f.)
				EndDo		   
				Z09->Z09_QUANT	 := IIF(_nQuant <= 0, 0, _nQuant)
				MsUnlock()
			Else
				While !Reclock("Z09",.t.)
				EndDo
				Z09->Z09_FILIAL  := SB2->B2_FILIAL
				Z09->Z09_PROD	 := SB2->B2_COD
				Z09->Z09_LOCAL	 := SB2->B2_LOCAL
				Z09->Z09_QUANT	 := IIF(_nQuant <= 0, 0, _nQuant)
				MsUnlock()
			
			EndIf
	
			DbSelectArea("SB2")
			DbSkip()
		EndDo
		
		DbSelectArea("SM0")
		DbSkip()
	EndDo
	
EndIf
	
RpcClearEnv()
Return