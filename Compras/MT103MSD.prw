#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103MSD	 		  		| 	Abril de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		  												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de Entrada utilizado para zerar os campos do IVA quando estornar  		|
|				classificacao de NF															  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT103MSD()
Local _aArea := GetArea()
Local _aAreaSF1 := SF1->(GetArea())
Local _aAreaSB1 := SB1->(GetArea())

If AtIsRotina("A140ESTCLA")	
	//Jorge H - Anadi - Maio/2015
	DbSelectArea("SF1")
	While !Reclock("SF1",.f.)
	EndDo
	SF1->F1__WMSENV := "E"
	MsUnlock()
	
	MsAguarde({|| IMT103ATUPR()},"Processando","Atualizando IVA e Saldo Disponivel...")
EndIf

RestArea(_aAreaSF1)
RestArea(_aAreaSB1)
RestArea(_aArea)

Return .t.


Static Function IMT103ATUPR()
Local _cChave := SF1->(F1_FILIAL + F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA), _nx := 0
Local _nPCod  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_COD"}), _nPItem  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_ITEM"})
Local _nPLoc  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_LOCAL"}), _nPWms := aScan(aHeader, {|x| AllTrim(x[2]) == "D1__WMSQTD"})
Local _nPTes  := aScan(aHeader, {|x| AllTrim(x[2]) == "D1_TES"})
Local _aArea := GetArea(), _lAtu := .f.
Local _aSB2 := SB2->(GetArea())           
Local _aSD3	:= SD3->(GetArea())
Private _aProd := {}, lMsErroAuto := .f.

DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(_cChave)
	Do While (_cChave = SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) .AND. !SD1->(Eof()) )
		While !Reclock("SD1",.F.)
		EndDo
		SD1->D1__CUSST  := 0
		SD1->D1__BICMST := 0
		SD1->D1__AJIVA  := 0
		SD1->D1__ALQPAD := 0
		SD1->D1__VLAGRE := 0
		SD1->D1__NFIVA	:= ""
		SD1->D1__SERIVA	:= ""
		SD1->D1__DTNOTA	:= CTOD("  /  /  ")
		SD1->D1__FORIVA	:= ""
		SD1->D1__LOJIVA	:= ""
		SD1->D1__ITEIVA	:= ""
		SD1->(MsUnlock())
		
		SD1->(DbSkip())
	EndDo
EndIf

//Apaga SD3 quando estornar classificacao da nota
DbSelectArea("SD3")
DbOrderNickName("SD3NF")	//D3_FILIAL+D3__DOC+D3__SERIE+D3__FORNEC+D3__LOJA+D3_COD+D3__ITEM
If DbSeek(_cChave)
	While !(eof()) .and. SD3->D3_FILIAL + SD3->D3__DOC  + SD3->D3__SERIE  + SD3->D3__FORNEC  + SD3->D3__LOJA == _cChave
		
		If SD3->D3_ESTORNO == "S"
			DbSkip()
			Loop
		EndIf

		_aSD3 := SD3->(GetArea())		
		
        _aProd := {}
        lMsErroAuto := .F.
		aAdd(_aProd,{{"D3_FILIAL"	,SD3->D3_FILIAL , NIL},;
					 {"D3_COD"		,SD3->D3_COD	, NIL},;
					 {"D3_LOCAL"	,SD3->D3_LOCAL	, NIL},;
					 {"D3_NUMSEQ"	,SD3->D3_NUMSEQ , NIL},;
					 {"D3_CF"		,SD3->D3_CF     , NIL},;
					 {"D3_TM"		,SD3->D3_TM     , NIL},;
					 {"INDEX"		,3				, NIL} })
		
		MSExecAuto({|x,y| MATA240(x,y)}, _aProd[1], 5) // Operacao de estorno do movimento interno (SD3)
		
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
		EndIf            
		
		RestArea(_aSD3)
	
		/*		
		Reclock("SD3",.F.)
			DbDelete()
		Msunlock()

		dbSelectArea("SX1")
		dbSetOrder(1)
		If dbSeek(PADR("MTA300",Len(SX1->X1_GRUPO)))
			While alltrim(SX1->X1_GRUPO) == 'MTA300'
				While !reclock("SX1", .F.)
				EndDo
				if SX1->X1_ORDEM == "01"
					SX1->X1_CNT01 := SD3->D3_LOCAL
				elseif SX1->X1_ORDEM == "02"
					SX1->X1_CNT01 := SD3->D3_LOCAL
				elseif SX1->X1_ORDEM == "03"
					SX1->X1_CNT01 := SD3->D3_COD
				elseif SX1->X1_ORDEM == "04"
					SX1->X1_CNT01 := SD3->D3_COD
				elseif SX1->X1_ORDEM == "05"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "06"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "07"
					SX1->X1_PRESEL := 2
				elseif SX1->X1_ORDEM == "08"
					SX1->X1_PRESEL := 2
				endif		
			
				SX1->(dbSkip())
			EndDo
		EndIf
		
		pergunte("MTA300", .F.)    		
		mv_par01 := SD3->D3_LOCAL
		mv_par02 := SD3->D3_LOCAL
		mv_par03 := SD3->D3_COD
		mv_par04 := SD3->D3_COD
		mv_par05 := 2
		mv_par06 := 2
		mv_par07 := 2
		mv_par08 := 2

		_aFil := {}
		aadd(_aFil, {.T., xFilial("SD3")})
		
		MATA300 (.T., _aFil)
		*/
		
		DbSelectArea("SD3")
		DbSkip()
	enddo
	
EndIf	

//Jorge H. - Anadi - Maio/2015
//No estorno de classificação, atualiza a quantidade em processamento
For _nx := 1 To Len(aCols)

	DbSelectArea("SF4")
	DbSetOrder(1)
	If DbSeek(xFilial("SF4") + aCols[_nx][_nPTes]) .And. SF4->F4_ESTOQUE == "S"
	
		DbSelectArea("SB2")
		DbSetOrder(1)
		If DbSeek(xFilial("SB2") + aCols[_nx][_nPCod] + aCols[_nx][_nPLoc])
			While !Reclock("SB2",.f.)
			EndDo		
			SB2->B2__ENTPRC := SB2->B2__ENTPRC + aCols[_nx][_nPWms]
			MsUnLock()
		EndIf
	
	EndIf
	
Next _nx

RestArea(_aSB2)
RestArea(_aArea)

Return