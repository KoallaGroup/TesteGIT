#Include "Protheus.ch"   
#INCLUDE "TOPCONN.CH"


User Function SF2460I() 
                                         
Local cNota		:= SF2->F2_DOC
Local cSerie	:= SF2->F2_SERIE
Local _aArea:=GetArea()

Private xDescr, xVenc, xMensagem, xObs, xPedido
Private oDescr	:= ""
Private infVenc := ""


If SF2->F2_TIPO <> "N"
	Return()
EndIf



If SFT->(dbSetOrder( 1 ), dbSeek(xFilial("SFT")+"S"+SF2->F2_SERIE+SF2->F2_DOC+SF2->F2_CLIENTE+SF2->F2_LOJA))
	While SFT->(!Eof()) .And. SFT->FT_FILIAL == xFilial("SFT") .And. SFT->FT_NFISCAL == SF2->F2_DOC
	
		If RecLock("SFT",.f.)
			SFT->FT_TOTAL = SFT->FT_TOTAL - SFT->FT_DESCONT 
			SFT->FT_DESCONT  := 0
			MsUnlock()
		Endif
		
		SFT->(dbSkip(1))
	Enddo
Endif




If RecLock("SF2",.f.)
	SF2->F2_DESCONT = 0
	MsUnlock()
Endif

If SD2->(dbSetOrder( 8 ), dbSeek(xFilial("SD2")+SC5->C5_NUM))
	While SD2->(!Eof()) .And. SD2->D2_FILIAL == xFilial("SD2") .And. SD2->D2_PEDIDO == SC5->C5_NUM
	
	
	
	
		If SF3->(dbSetOrder( 4 ), dbSeek(xFilial("SF3")+SD2->D2_CLIENTE+SD2->D2_LOJA+SD2->D2_DOC+SD2->D2_SERIE))
			While SF3->(!Eof()) .And. SF3->F3_FILIAL == xFilial("SF3") .And. SF3->F3_NFISCAL == SD2->D2_DOC ;
			.And. SF3->F3_CLIEFOR = SD2->D2_CLIENTE .And. SF3->F3_LOJA = SD2->D2_LOJA
			
				If SF3->F3_CFO = SD2->D2_CF
					If RecLock("SF3",.f.)
						SF3->F3_VALOBSE = SF3->F3_VALOBSE - SD2->D2_DESCON 
						MsUnlock()
					Endif
				
				EndIf
			SF3->(dbSkip(1))
			Enddo
		Endif
		
		
		If RecLock("SD2",.f.)
			SD2->D2_PRUNIT = SD2->D2_PRCVEN
			SD2->D2_DESCON = 0
			MsUnlock()
		Endif
		
	
	
	
	
	
	
	
	SD2->(dbSkip(1))
	Enddo
Endif





RestArea(_aArea)






Return
