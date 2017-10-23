#Include "Protheus.ch"

User Function FALTCADCL()
Local oButton1, oButton2, oMaster, oMultpl, oPesBru,oPesliq, oProd, oQEmb, _lOK := .f.
Local nPesliq := Space(45)
Local nMaster := " ", nMultpl := SB1->B1__QTDMTP, nPesBru := SPACE(50), nQEmb := SPACE(14), nDDD := SPACE(3), nTel := SPACE(15)
Local cCodCli := M->C5_CLIENTE
Local cNomCli := M->C5_NOMECLI
Local oSay1, oSay2, oSay3, oSay4, oSay5, oSay6, oDlg
Local aArea	:= GetArea()
Local aAreaSA1	:= SA1->(GetArea())

If Alltrim(M->C5_CLIENTE) <= '900000' .Or. Alltrim(M->C5_CLIENTE) >= '900501'  
	MsgAlert("Não foi possível atualizar as informações do cliente pois está fora da faixa:  '900000' Até '900101' ")
	Return
Endif
                                                                                                                            
DEFINE MSDIALOG oDlg TITLE "ALTERA DADOS CLIENTE" FROM 000, 000  TO 300, 500 COLORS 0, 16777215 PIXEL
    
    @ 007, 070 SAY oSay1 PROMPT "Alteracao dos dados do Cliente" SIZE 112, 007 OF oDlg COLORS 0, 16777215 PIXEL
	@ 021, 006 MSGET oProd VAR cCodCli SIZE 008, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL 
	@ 021, 035 MSGET oProd VAR cNomCli SIZE 200, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
    @ 042, 008 SAY oSay2 PROMPT "Nome" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 041, 035 MSGET oPesliq VAR nPesliq SIZE 200, 010 OF oDlg PICTURE "@! " COLORS 0, 16777215 PIXEL
    
    @ 062, 008 SAY oSay3 PROMPT "E-mail" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 061, 035 MSGET oPesBru VAR nPesBru SIZE 200, 010 OF oDlg PICTURE "@!"  COLORS 0, 16777215 PIXEL 
       
    @ 082, 008 SAY oSay3 PROMPT "CPF" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 081, 035 MSGET oPesBru VAR nQEmb SIZE 100, 010 OF oDlg PICTURE "@!"   COLORS 0, 16777215 PIXEL

    @ 102, 008 SAY oSay3 PROMPT "DDD" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 101, 035 MSGET oPesBru VAR nDDD SIZE 003, 003 OF oDlg PICTURE "@!"   COLORS 0, 16777215 PIXEL        
    
    @ 102, 060 SAY oSay3 PROMPT "Telefone" SIZE 029, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 101, 087 MSGET oPesBru VAR nTel SIZE 060, 010 OF oDlg PICTURE "@!"   COLORS 0, 16777215 PIXEL      
    
    /*@ 061, 008 SAY oSay4 PROMPT "Qtde Master" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 041 MSGET oMaster VAR nMaster SIZE 033, 010 OF oDlg PICTURE "@E 99999" VALID nMaster >= 0 COLORS 0, 16777215 PIXEL when .F.
    @ 061, 088 SAY oSay5 PROMPT "Qtd. Indiv." SIZE 027, 007 OF oDlg COLORS 0, 16777215 PIXEL 
    @ 060, 117 MSGET oQEmb VAR nQEmb SIZE 035, 010 OF oDlg PICTURE "@E 999999999" VALID nQEmb >= 0 COLORS 0, 16777215 PIXEL when .F.
    @ 061, 167 SAY oSay6 PROMPT "Qtd. Venda" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
    @ 060, 201 MSGET oMultpl VAR nMultpl SIZE 038, 010 OF oDlg PICTURE "@E 99999" VALID nMultpl >= 0 COLORS 0, 16777215 PIXEL when .F.
    */
    @ 130, 051 BUTTON oButton1 PROMPT "Confirmar" SIZE 037, 012 OF oDlg ACTION {|| _lOK := .t.,oDlg:End()} PIXEL
    @ 130, 147 BUTTON oButton2 PROMPT "Cancelar" SIZE 037, 012 OF oDlg ACTION oDlg:End() PIXEL
      

ACTIVATE MSDIALOG oDlg CENTERED

If Alltrim(M->C5_CLIENTE) >= '900000' .And. Alltrim(M->C5_CLIENTE) <= '900501'  
	If _lOK
		DbSelectArea("SA1")
		DbSetOrder(1)
		If DbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI) 
			If Reclock("SA1",.f.)                 
				SA1->A1_NOME 	:= nPesLiq 
				SA1->A1_NREDUZ 	:= LEFT(nPesLiq,20)
				SA1->A1_EMAIL	:= nPesBru
				SA1->A1_CGC 	:= nQEMB
				SA1->A1_DDD 	:= nDDD
				SA1->A1_TEL		:= nTel  
				M->C5_NOMECLI		:= nPesLiq
				MsUnlock()
			Else
				MsgAlert("Não foi possível atualizar as informações do cliente, tente novamente")
			EndIf
		EndIf
	Endif
EndIf

RestArea(aAreaSA1)
RestArea(aArea)

Return