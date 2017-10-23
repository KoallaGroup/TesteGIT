#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : SF1100I			  		| 	Março de 2014					  				  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada após a gravação da NF Entrada								  				|
|-----------------------------------------------------------------------------------------------|
*/

User Function SF1100I()

Local _aArea := getArea(), _aSD1 := SD1->(GetArea()), _aSC7 := SC7->(GetArea())
Local _cNota
Local _cSerie
Local _cForn
Local _cLoja
Local lOk   := .F.
//Local nPosWMSINT	:= Ascan(aHeader, {|x| AllTrim(x[2]) == "D1__WMSINT"})

//Local _cTipo	:= ""

//If !Empty(Sf1->F1_Hawb)
//	Return
//EndIf
/*Jorge Alves - Outubro/2014
For x:=1 To Len(aCols)
	If !(aCols[x][Len(aCols[x])])
		_nD1__WMSINT := aCols[x][nPosWMSINT]
		exit
	EndIf
Next x

dbSelectArea("SF1")
if reclock("SF1", .F.)
	F1__WMSINT := _nD1__WMSINT
	msUnlock()
endif
*/
_cNota 	:= SF1->F1_DOC
_cSerie	:= SF1->F1_SERIE
_cForn	:= SF1->F1_FORNECE
_cLoja	:= SF1->F1_LOJA

DbSelectArea("SD1")
DbSetOrder(1)
If DbSeek(xFilial("SD1")+_cNota+_cSerie+_cForn+_cLoja)

	//Grava o segmento do documento
	//Jorge Alves - Setembro/2014
    If Reclock("SF1",.f.)
		SF1->F1__SEGISP := Posicione("SB1",1,xFilial("SB1") + SD1->D1_COD,"B1__SEGISP")
		If Type("_lICOMP05") == "L" .And. _lICOMP05
            SF1->F1__PROIMP := _cProc
            SF1->F1_TPFRETE := _cTpFret
            SF1->F1__REFEXT := _cRef
            SF1->F1__DOCCOD := Alltrim(Str(_cDocCod))
            SF1->F1__MSGIMP := _cCodObs
            SF1->F1__NUMDI  := SD1->D1__NDI
            SF1->F1__DTDI   := SD1->D1__DTDI
//			SF1->F1_PLIQUI  := _nPesLiq
//          SF1->F1_PBRUTO  := _nPesBrut
		EndIf
	    SF1->(MsUnlock())
    EndIf

    DbSelectArea("SD1")	
	While SD1->D1_FILIAL == xFilial("SD1") .And. SD1->D1_DOC == _cNota .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cForn .and. SD1->D1_LOJA == _cLoja

/*	Trocado pelo ponto de entrada mt103fim
		
			U_ICOMA06(	SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_COD,SD1->D1_ITEM,SD1->D1_LOCAL,SD1->D1_UM,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_TES,;
							SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_CUSTO,SD1->D1_VALICM,SD1->D1_VALIPI,SD1->D1_VALPIS,SD1->D1_VALCOF,SD1->D1_VALFRE,;
							SD1->D1_PICM,SD1->D1_FILIAL)

*/
		/*ALteração na lógica (Jorge H. - Fev/2015)
		_cPedido	:= SD1->D1_PEDIDO
		_cItPed	:= SD1->D1_ITEMPC
		_nQtde	:= SD1->D1_QUANT
		_nValor	:= SD1->D1_TOTAL
		
		if !empty(_cPedido)
			dbSelectArea("SZ3")
			dbSetOrder(2)
			if dbSeek(xFilial("SZ3")+_cPedido)
				do while SZ3->Z3_PEDIDO == _cPedido
					
					if SZ3->Z3_ITPEDCO == _cItPed
						
						if reclock("SZ3", .F.)
							SZ3->Z3_QTDESEM	+= _nQtde
							SZ3->Z3_VLDESEM 	+= _nValor
							msUnlock()
						endif
						
					endif
					
					SZ3->(dbSkip())
				enddo
			endif
			
		endif
		*/
		
		If !Empty(SD1->D1__CODPRO)
			DbSelectArea("SC7")
			DbSetOrder(1)
			If DbSeek(xFilial("SC7") + SD1->D1_PEDIDO + SD1->D1_ITEMPC)
	            DbSelectArea("SZ3")
	            DbSetOrder(5)
	            If DbSeek(xFilial("SZ3") + SD1->D1__CODPRO + SD1->D1_PEDIDO + SD1->D1_ITEMPC + SC7->C7_FORNECE + SC7->C7_LOJA)
	                While !Reclock("SZ3", .F.)
	                EndDo
	                SZ3->Z3_QTDESEM := SZ3->Z3_QTDESEM + SD1->D1_QUANT
	                SZ3->Z3_VLDESEM := SZ3->Z3_VLDESEM + SD1->D1_TOTAL
	                MsUnlock()
	            EndIf
	  		EndIf
		EndIf
        
		If SF1->F1_EST == "EX" .And. !Empty(SD1->D1__NDI) .And. Type("_lICOMP05") == "L" .And. _lICOMP05
			DbSelectArea("CD5")
			DbSetOrder(4)
			If !DbSeek(xFilial("CD5") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM)
				While !Reclock("CD5",.t.)
				EndDo
				CD5->CD5_FILIAL     := xFilial("CD5")
				CD5->CD5_DOC        := SD1->D1_DOC
				CD5->CD5_SERIE      := SD1->D1_SERIE
				CD5->CD5_ESPEC      := SF1->F1_ESPECIE
				CD5->CD5_FORNEC     := SD1->D1_FORNECE
				CD5->CD5_LOJA       := SD1->D1_LOJA
				CD5->CD5_TPIMP      := _cTpImp
				CD5->CD5_DOCIMP     := SD1->D1__NDI
				CD5->CD5_BSPIS      := SD1->D1_BASIMP6
				CD5->CD5_ALPIS      := SD1->D1_ALQIMP6
				CD5->CD5_VLPIS      := SD1->D1_VALIMP6
				CD5->CD5_BSCOF      := SD1->D1_BASIMP5
				CD5->CD5_ALCOF      := SD1->D1_ALQIMP5
				CD5->CD5_VLCOF      := SD1->D1_VALIMP5
				CD5->CD5_DTPPIS     := _dDtDI
				CD5->CD5_DTPCOF     := _dDtDI
				CD5->CD5_LOCAL      := _cLocSrv
				CD5->CD5_NDI        := SD1->D1__NDI
				CD5->CD5_DTDI       := _dDtDI
				CD5->CD5_LOCDES     := _cDesem
				CD5->CD5_UFDES      := _cUFDesem
				CD5->CD5_DTDES      := _dDtDesem
				CD5->CD5_CODEXP     := SD1->D1_FORNECE
				CD5->CD5_LOJEXP     := SD1->D1_LOJA
				CD5->CD5_NADIC      := SD1->D1__NADIC
				CD5->CD5_SQADIC     := SD1->D1__SQADIC
				CD5->CD5_CODFAB     := SD1->D1_FORNECE
				CD5->CD5_LOJFAB     := SD1->D1_LOJA
				CD5->CD5_BCIMP      := SD1->D1__BCIMP
				CD5->CD5_DSPAD      := SD1->D1__DSPAD
				CD5->CD5_VLRII      := SD1->D1__VLRII
				CD5->CD5_INTERM     := SD1->D1__INTERM
				CD5->CD5_ITEM       := SD1->D1_ITEM
				CD5->CD5_VTRANS     := SD1->D1__VTRANS
				
				If Alltrim(SD1->D1__INTERM) == "3"
					CD5->CD5_CNPJAE := SM0->M0_CGC
					CD5->CD5_UFTERC := SM0->M0_ESTCOB
				EndIf
				MsUnlock()
			EndIf
        EndIf
				
		DbSelectArea("SD1")
		DbSkip()
	EndDo
	
EndIf

//ADICIONADO POR RAFAEL DOMINGUES EM 29/05/15
If SF1->F1_TIPO $ "D/B" .And. Type("_cChavnfe") == "C"          
	RecLock("SF1",.F.)
	SF1->F1__CHVMSV := _cChavnfe
	MsUnLock()
	_cChavnfe := ""
EndIf

RestArea(_aSC7)
RestArea(_aSD1)
RestArea(_aArea)

Return