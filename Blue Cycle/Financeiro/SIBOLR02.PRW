#INCLUDE "PROTHEUS.CH"

//------------------------------------------------------------------- 
/*/{Protheus.doc} SIBOLR02
Rotina de Re-Impressão da Boletas.
        
@author	Ederson Colen
@since	09/01/2013
@version P11
@param	
@return	Nil

@obs	      
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       Programador     Motivo 
/*/ 
//------------------------------------------------------------------ 
User Function SIBOLR02()

Private cCodiBanc := Space(TamSx3("A6_COD")[1])
Private cCodiAgen := Space(TamSx3("A6_AGENCIA")[1])
Private cCodiCCor := Space(TamSx3("A6_NUMCON")[1])
Private cNossNume := Space(TamSx3("EE_NOSSNUM")[1])
Private cSeqNNBan := Space(TamSx3("A6_SEQBANC")[1])
Private cCarteira := Space(TamSx3("EE_NUNCART")[1])

Private lSaiTela  := .F.
Private lDigBanc  := .T.

Private cNumDupl  := Space(TamSx3("E1_NUM")[1])
Private cPrefFat  := Space(TamSx3("E1_PREFIXO")[1])
Private cNParcIn  := Space(TamSx3("E1_PARCELA")[1])
Private cNParcFi  := Space(TamSx3("E1_PARCELA")[1])
Private cCliente  := Space(TamSx3("A1_COD")[1])
Private cLojaCli  := Replicate("0",(TamSx3("A1_LOJA")[1]-1))+"1"

Private aTamTela  := {000,000,270,450}

Private aTamTNF   := {005,005,030,225}

Private aPosGSNF  := {013,010,020,010}
Private aPosGNNF  := {013,040,040,010}
Private aPoGPNFI  := {013,090,020,010}
Private aPoGPNFF  := {013,120,020,010}
Private aPosGCli  := {013,150,030,010}
Private aPosGLoj  := {013,195,020,010}

Private aTamTBCO  := {040,005,070,225}

Private aPosGBCO  := {050,010,020,009}
Private aPosGAGE  := {050,040,030,009}
Private aPosGCON  := {050,080,040,009}
Private aPosGCar  := {050,130,010,009}

Private aTamTNNu  := {080,005,110,225}

Private aPosGNNu  := {090,010,200,010}

Private aPosBut1  := {120,160}
Private aPosBut2  := {120,190}

Private lConfirma := .F.

While ! lSaiTela

   DEFINE MSDIALOG oDlg1 FROM aTamTela[01],aTamTela[02] TO aTamTela[03],aTamTela[04] TITLE "DIGITE OS DADOS DO TITULO." PIXEL

   @ aTamTNF[01],aTamTNF[02] TO aTamTNF[03],aTamTNF[04] LABEL "Prefixo/Numero do Titulo/Parcela(Inicial/Final)/Cliente/Loja" PIXEL
   @ aPosGSNF[01],aPosGSNF[02] MSGet cPrefFat Valid FVldPrfFa() SIZE aPosGSNF[03],aPosGSNF[04] PIXEL
   @ aPosGNNF[01],aPosGNNF[02] MSGet cNumDupl Valid FVldNumNF() SIZE aPosGNNF[03],aPosGNNF[04] PIXEL

   @ aPoGPNFI[01],aPoGPNFI[02] MSGet cNParcIn Valid FVldParNF("I") SIZE aPoGPNFI[03],aPoGPNFI[04] PIXEL
   @ aPoGPNFF[01],aPoGPNFF[02] MSGet cNParcFi Valid FVldParNF("F") SIZE aPoGPNFF[03],aPoGPNFF[04] PIXEL

   @ aPosGCli[01],aPosGCli[02] MSGet cCliente Valid FVlrCliNF() F3 "SA1BOL" SIZE aPosGCli[03],aPosGCli[04] PIXEL
   @ aPosGLoj[01],aPosGLoj[02] MSGet cLojaCli SIZE aPosGLoj[03],aPosGLoj[04] PIXEL

   @ aTamTBCO[01],aTamTBCO[02] TO aTamTBCO[03],aTamTBCO[04] LABEL "Banco/Agencia/Conta Corrente/Carteira" PIXEL
   @ aPosGBCO[01],aPosGBCO[02] MSGet cCodiBanc When lDigBanc Valid FVldBanc() F3 "SA6" SIZE aPosGBCO[03],aPosGBCO[04] PIXEL
   @ aPosGAGE[01],aPosGAGE[02] MSGet cCodiAgen When lDigBanc Valid ExistCpo("SA6",cCodiBanc+cCodiAgen) SIZE aPosGAGE[03],aPosGAGE[04] PIXEL
   @ aPosGCON[01],aPosGCON[02] MSGet cCodiCCor When lDigBanc Valid ExistCpo("SA6",cCodiBanc+cCodiAgen+cCodiCCor) .And. FVldCCor() SIZE aPosGCON[03],aPosGCON[04] PIXEL
   @ aPosGCar[01],aPosGCar[02] MSGet cCarteira When lDigBanc Valid ValidaCart() SIZE aPosGCar[03],aPosGCar[04] PIXEL

   @ aTamTNNu[01],aTamTNNu[02] TO aTamTNNu[03],aTamTNNu[04]  LABEL  "Nosso Numero" PIXEL
   @ aPosGNNu[01],aPosGNNu[02] MSGet cNossNume When .F. Valid .T. SIZE aPosGNNu[03],aPosGNNu[04] PIXEL

   Define SButton From aPosBut1[01],aPosBut1[02] Type 1 Action (FConfirma(),oDlg1:End()) Enable Of Odlg1
   Define SButton From aPosBut2[01],aPosBut2[02] Type 2 Action ((lSaiTela := .T.) .And. oDlg1:End()) Enable Of Odlg1

   Activate MSDialog oDlg1 Center

   If lConfirma
      lConfirma := .F.
      dbSelectArea("SE1")
      dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
      dbSeek(xFilial("SE1")+cCliente+cLojaCli+cPrefFat+cNumDupl+cNParcIn)

      If ! Eof()
         U_SIBOLR01(cPrefFat,cNumDupl,cNParcIn,cNParcFi,cCliente,cLojaCli)
       EndIf
   EndIf

EndDo

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldBanc()
Função de Validação do Banco

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldBanc()

Local lRetVld := .T.

If ! ExistCpo("SA6",cCodiBanc)
	If Left(cCodiBanc,1) == "C"
	   AVISO("A T E N Ç Ã O","Favor informar o Código de um Banco. (FOI INFORMADO UM CAIXA)",{"OK"})
	   lRetVld := .T.
	EndIf
EndIf

SysRefresh()

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldCCor
Função de Validação da Conta Banco

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldCCor()

Local lRetVld := .T.

dbSelectArea("SA6")
dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
If ! Eof()
	dbSelectArea("SEE")
	dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+SA6->A6_SEQBANC)
	If ! Eof()
		cCarteira := SEE->EE_NUNCART
	EndIf
EndIf

SysRefresh()

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldPrfFa
Função de Validação Prefixo do Título.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldPrfFa()

Local lRetVld := .T.

If ! Empty(cPrefFat)

	SE1->(dbSetOrder(1))
	SE1->(dbSeek(xFilial("SE1")+cPrefFat))

   If  SE1->(Eof())
       AVISO("A T E N Ç Ã O","Serie/Prefixo Inválido",{"OK"})
       lRetVld := .F.
   EndIf

Else

   AVISO("A T E N Ç Ã O","Serie/Prefixo deverá ser informado.",{"OK"})
   lRetVld := .F.

EndIf

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldNumNF
Função de Validação do Numero da Nota/Titulo

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldNumNF()

Local lRetVld := .T.

If ! Empty(cNumDupl)

	SE1->(dbSetOrder(1))
   SE1->(dbSeek(xFilial("SE1")+cPrefFat+cNumDupl))

   If  SE1->(Eof())
       AVISO("A T E N Ç Ã O","Número do Titulo/Nota Fiscal Inválido",{"OK"})
       lRetVld := .F.
   EndIf

Else

   AVISO("A T E N Ç Ã O","Número do Titulo/Nota Fiscal deverá ser informado.",{"OK"})
   lRetVld := .F.

EndIf

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVldParNF
Função de Validação das Parcelas dos Titulos.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVldParNF(cCamVLD)

Local lRetVld		:= .T.
Local cGrpTipBo	:= AllTrim(SuperGetMv("SI_GRTIPBO",,"BOL#BO#DP#NF#"))

If Empty(AllTrim(cGrpTipBo))
   cGrpTipBo := AllTrim("BOL#BO#DP#NF#")
EndIf

If cCamVLD == "I"
	If ! Empty(cNParcIn)
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+cPrefFat+cNumDupl+cNParcIn))

	   If  SE1->(Eof())
	       AVISO("A T E N Ç Ã O","Parcela Inicial Inválida",{"OK"})
	       lRetVld := .F.
	   Else
	      If ! AllTrim(SE1->E1_TIPO) $ cGrpTipBo
	          AVISO("A T E N Ç Ã O","Tipo de Titulo não é BOLETA...",{"OK"})
	          lRetVld := .F.
	      EndIf
	   EndIf
	EndIf
Else

	If cNParcFi <> Replicate("Z",TamSx3("E1_PARCELA")[1])
		SE1->(dbSetOrder(1))
		SE1->(dbSeek(xFilial("SE1")+cPrefFat+cNumDupl+cNParcFi))

		If  Eof()
			AVISO("A T E N Ç Ã O","Parcela Final Inválida",{"OK"})
			lRetVld := .F.
		Else
      	If ! AllTrim(SE1->E1_TIPO) $ cGrpTipBo
          	AVISO("A T E N Ç Ã O","Tipo de Titulo não é BOLETA...",{"OK"})
          	lRetVld := .F.
      	EndIf
   	EndIf
	Else
		AVISO("A T E N Ç Ã O","Deverá ser informado o Numero da Parcela ou ZZZZ para que pegue todas as informações.",{"OK"})
		lRetVld := .F.
  	EndIf

EndIf

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FVlrCliNF
Função de Validação do Cliente Informado.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FVlrCliNF()

Local lRetVld := .T.

If Empty(cLojaCli)

	SA1->(dbSetOrder(1))
   SA1->(dbSeek(xFilial("SA1")+cCliente))
   
   If SA1->(! Eof())
      cLojaCli := SA1->A1_LOJA
   EndIf

EndIf
                    
If ! Empty(cCliente) .And. ! Empty(cLojaCli)
	
	SE1->(dbSetOrder(2))
	SE1->(dbSeek(xFilial("SE1")+cCliente+cLojaCli+cPrefFat+cNumDupl+cNParcIn))

   If  SE1->(Eof())
       AVISO("A T E N Ç Ã O","Cliente/Loja Inválido",{"OK"})
       lRetVld := .F.
   Else
      If SE1->E1_SALDO <> SE1->E1_VALOR
         AVISO("A T E N Ç Ã O","Este Titulo já foi Baixado não poderá ser Impresso.",{"OK"})
         lRetVld := .F.
      Else
	      If ! Empty(SE1->E1_NOSSNUM)
	         cCodiBanc := SE1->E1_PORTADO
	         cCodiAgen := SE1->E1_AGEDEP
	         cCodiCCor := SE1->E1_CONTA
	         cNossNume := SE1->E1_NOSSNUM
	         cCliente  := SE1->E1_CLIENTE
	         cLojaCli  := SE1->E1_LOJA
	         cCarteira := SE1->E1_NUNCART
	         lDigBanc  := .F.
	      Else

			   dbSelectArea("SA1")
			   dbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA)

			   If ! Eof() .And. ! Empty(SA1->A1_BCOBOL)

	   	      cCliente  := SE1->E1_CLIENTE
		         cLojaCli  := SE1->E1_LOJA
					cCodiBanc := SA1->A1_BCOBOL
					cCodiAgen := SA1->A1_AGENBOL
					cCodiCCor := SA1->A1_CONTBOL

					dbSelectArea("SA6")
					dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
					If ! Eof()
						dbSelectArea("SEE")
						If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+SA6->A6_SEQBANC)
				         cCarteira := SEE->EE_NUNCART
						EndIf
					EndIf

			   EndIf

		      lDigBanc  := .T.

		   EndIf

	   EndIf   

      SysRefresh()

   EndIf
Else
   AVISO("A T E N Ç Ã O","Cliente/Loja do Titulo deverá ser informado.",{"OK"})
   lRetVld := .F.
EndIf

Return(lRetVld)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} ValidaCart
Função de Validação da Carteira informada.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function ValidaCart
                 
Local lRetVal := .T.

If Empty(cCarteira)
   AVISO("A T E N Ç Ã O","Carteira deve ser informada.",{"OK"})
   lRetVal := .F.
Else

	SA6->(dbSetOrder(1))
	SA6->(dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor))
   If SA6->(! Eof())
      cSeqNNBan := SA6->A6_SEQBANC
		SEE->(dbSetOrder(1))
		SEE->(dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan))
		If SEE->(Eof()) .Or. (SEE->EE_NUNCART <> cCarteira)
			AVISO("A T E N Ç Ã O","Carteira informada não esta cadastrada.",{"OK"})
			lRetVal := .F.
      Else
			If Empty(AllTrim(cNossNume))
				cNossNume := AllTrim(SEE->EE_NOSSNUM)
			EndIf
			SysRefresh()
	   EndIf
   Else
		AVISO("A T E N Ç Ã O","Banco não Cadastrado. Favor verificar o Banco informado.",{"OK"})
		lRetVal := .F.
	EndIf

EndIf

Return(lRetVal)



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FCancela()
Função de Cancelamento da Tela.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FCancela()

lSaiTela := .T.
Close(oDlg1)

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FConfirma
Função de Confirmação da Tela.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FConfirma()

lSaiTela := .T.

SE1->(dbSetOrder(2))
SE1->(dbSeek(xFilial("SE1")+cCliente+cLojaCli+cPrefFat+cNumDupl+cNParcIn))

If SE1->(! Eof())

   If Empty(AllTrim(SE1->E1_NOSSNUM))
      FAtuaRece()
   EndIf
   
   lConfirma := .T.
EndIf

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FAtuaRece
Função para atualização dos Titulos a Receber.

@protected
@author		Ederson Colen
@since		03/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FAtuaRece()

Local cDigito   := Space(01)

Local nLenNos   := 0
Local cNossAuxi := Space(TamSx3("EE_NOSSNUM")[1])
Local cGrpTipBo := SuperGetMv("SI_GRTIPBO",,"BOL#BO#DP#NF#")

If Empty(AllTrim(cGrpTipBo))
   cGrpTipBo := AllTrim("BOL#BO#DP#NF#")
EndIf

SA6->(dbSetOrder(1))
SA6->(dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor))

dbSelectArea("SE1")
SE1->(dbSetOrder(2))
SE1->(dbSeek(xFilial("SE1")+cCliente+cLojaCli+cPrefFat+cNumDupl+cNParcIn))

While SE1->(! Eof())                      .And. ;
      SE1->E1_FILIAL   == xFilial("SE1") .And. ;
      SE1->E1_CLIENTE  == cCliente       .And. ;
      SE1->E1_LOJA     == cLojaCli       .And. ;
      SE1->E1_PREFIXO  == cPrefFat       .And. ;
      SE1->E1_NUM      == cNumDupl

   If SE1->E1_PARCELA > cNParcFi
      dbSelectArea("SE1")
      dbSkip()
      Loop
   EndIf

   If SE1->E1_SALDO <> SE1->E1_VALOR
      dbSelectArea("SE1")
      dbSkip()
      Loop
   EndIf

   If AllTrim(SE1->E1_TIPO) $ cGrpTipBo

      dbSelectArea("SA6")
      SA6->(dbSetOrder(1))
      SA6->(dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor))
      If SA6->(! Eof())
         cSeqNNBan := SA6->A6_SEQBANC
      EndIf

      dbSelectArea("SEE")
      SEE->(dbSetOrder(1))
      SEE->(dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan))
      If SEE->(! Eof())
		   Do Case 
		   	Case cCodiBanc == "001"
/*
					Do Case
						Case SE1->E1_TIPO == "NF "
							cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
						Case SE1->E1_TIPO == "DP "
							cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
						OtherWise
							cNossNume	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					EndCase
*/
					Do Case
						Case SE1->E1_TIPO == "NF "
							cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
						Case SE1->E1_TIPO == "DP "
							cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
						OtherWise
							cNossNume	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					EndCase
					cDigito := ""
   	      Case cCodiBanc == '341'

					cParcela := AllTrim(SE1->E1_PARCELA)
					If Val(cParcela) > 0
						cParcela := StrZero(Val(cParcela),2)
					Else
						If Empty(cParcela)
							cParcela := "01"
						Else
							If Len(AllTrim(cParcela)) >= 2

							Else
								cParcela := ASC(Upper(SE1->E1_PARCELA)) - 64
								cParcela := IIF(cParcela >= 0,cParcela,0)
							EndIf
						EndIf
					EndIf
					cNossNume := Right(AllTrim(SE1->E1_NUM),9)+cParcela
					cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarteira)  
				   //	cDigito := modulo10(cCodiAgen+Right(AllTrim(cCodiCCor),5)+cCarteira+strzero(val(cNossNume),8))
					//modulo10 Alltrim(cAgencia) + Right(AllTrim(cConta),5) + Alltrim(_cCart) + AllTRim(bldocnufinal)

	         Case cCodiBanc == '033'

	  				cNossNume := "0"+StrZero(Val(SE1->E1_NUM),6)+StrZero(Val(SE1->E1_PARCELA),3)
			      cCarteira := AllTrim(SEE->EE_NUNCART)
					cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarteira)

	         OtherWise

					cNossNume := AllTrim(SEE->EE_NOSSNUM)
					cCarteira := AllTrim(SEE->EE_NUNCART)
					cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarteira)

			EndCase

      Else

	      Aviso("A T E N C A O","Não foi possível atualizar os Dados do Título. Favor Informar ao Administrador do Sistema.",{"OK"})
			Return Nil

      EndIf

      RecLock("SE1",.F.)
      SE1->E1_PORTADO	:=	cCodiBanc
      SE1->E1_AGEDEP	:=	cCodiAgen
      SE1->E1_CONTA		:=	cCodiCCor
      SE1->E1_NUNCART	:=	cCarteira
      SE1->E1_NOSSNUM	:=	cNossNume+cDigito
      SE1->E1_NUMBCO	:=	cNossNume+cDigito
		SE1->E1_BCOCLI 	:=	cCodiBanc
      MsUnlock()

	   If ! cCodiBanc $ "001_341_"
			If cCodiBanc == "033"
		      cNossAuxi := Soma1(cNossNume,13)
	      Else
		      nLenNos   := Len(Alltrim(cNossNume))
				cNossAuxi := Soma1(cNossNume,nLenNos)
			EndIf
			dbSelectArea("SEE")
			dbSetOrder(1)
			If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
				RecLock("SEE",.F.)
				SEE->EE_NOSSNUM := cNossAuxi
				MsUnlock()
			EndIf
		EndIf

   EndIf

   dbSelectArea("SE1")
   dbSkip()

EndDo

Return