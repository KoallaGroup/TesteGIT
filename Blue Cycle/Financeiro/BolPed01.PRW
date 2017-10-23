#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"    
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"

//------------------------------------------------------------------- 
/*/{Protheus.doc} SIBOLR01
Rotina de Impressão da Boleta.
       
@author	Ederson Colen                    t
@since	08/01/2013
@version P11                                                     
@param	
@return	Nil

@obs	       
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       Programador     Motivo 
/*/ 
//------------------------------------------------------------------ 
User Function BolPed01(cImp)

/*Do Case
   Case AllTrim(Upper(FunName())) == "SIBOLR02"

        FGerArq(cPrefFat,cNumDupl,cNParcIn,cNParcFi,cCliente,cLojaCli)

        If (Select("QSE1") <> 0)
           dbSelectArea("QSE1")
           dbGoTop()
           If ! Eof()
              Processa({|| FImpBol("I","QSE1")})
           Else
              Aviso("A T E N C A O","Nao foram encontrados registros para Impressao da Boleta. Favor verificar os parametros informados !",{"OK"})
           EndIf
        Else
           Aviso("A T E N C A O","Nao foi possivel criar o Arquio Temporario para Impressao da Boleto. Favor verificar os parametros informados !",{"OK"})
        EndIf

        If (Select("QSE1") <> 0)
           dbSelectArea("QSE1")
           dbCloseArea()
        EndIf

   Case AllTrim(Upper(FunName())) == "SIBOLR03"

        Processa({|| FImpBol("D","TRE1")})

EndCase */
//If SC5->C5__STATUS =  "13" .AND. SC5->C5_CNAB = "S"           //retornar validação do status do pedido após entrada em produção

	//If SC5->C5_VLPGANT >= ROUND(U_FTotPed(SC5->C5_NUM),2)
	//	Processa({|| FImpBol("D","TRE1")})
	//Else
	//	Aviso("ATENCAO","Pagamento antecipado já realizado.",{"OK"},3)	
	//EndIf	
	
//Else
//	Aviso("ATENCAO","Pedido não liberado para emissão do boleto. Favor contatar o departamento financeiro",{"OK"},3)
//EndIf
If SC5->C5_VLCNAB <= 0  
	Aviso("A T E N C A O","Pedido não liberado para geração do boleto, favor contatar o depatarmento financeiro !",{"OK"})
	
Else
	Processa({|| FImpBol(cImp,"TRE1")})
    
EndIf
Return()
               


//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FGerArq
Função de Geração do Arquivo para Impressão do Boleto.

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
Static Function FGerArq(cPrefFat,cNumDupl,cNParcIn,cNParcFi,cCliente,cLojaCli)

Local cQuery := ""

If (Select("QSE1") <> 0)
   dbSelectArea("QSE1")
   dbCloseArea()
EndIf

cQuery := " SELECT * "
cQuery += " FROM "+RetSqlName("SE1")+" E1 "
cQuery += " WHERE D_E_L_E_T_ <> '*' "
cQuery += " AND E1_FILIAL = '"+xFilial("SE1")+"' "
cQuery += " AND E1_PREFIXO = '"+cPrefFat+"' "
cQuery += " AND E1_NUM = '"+cNumDupl+"' "
cQuery += " AND E1_PARCELA BETWEEN '"+cNParcIn+"' AND '"+cNParcFi+"' "
cQuery += " AND E1_CLIENTE = '"+cCliente+"' "
cQuery += " AND E1_LOJA = '"+cLojaCli+"' "
cQuery += " AND E1_TIPO NOT LIKE '%-%' "
cQuery += " AND E1_SALDO > 0.00 "
cQuery += " ORDER BY E1_PREFIXO, E1_NUM, E1_PARCELA "

TCQUERY cQuery ALIAS "QSE1" NEW

dbSelectArea("QSE1")
dbGoTop()

Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FImpBol
Função de impressão da Boleta.

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
Static Function FImpBol(cImp,cAliArq)


Private oPrint
Private aDadosEmp := {Alltrim(SM0->M0_NOMECOM)+" "                                                           ,; //[1]Nome da Empresa
							 AllTrim(SM0->M0_ENDCOB)+" "+AllTrim(SM0->M0_COMPCOB)                     ,; //[2]Endereço
							 AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
							 "CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999")					            ,; //[4]CEP
							 "PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
							 "C.N.P.J.: "+Transform(SM0->M0_CGC,"@R 99.999.999/9999-99")               ,; //[6]CGC
							 "I.E.: "+Transform(SM0->M0_INSC,"@R 999.999.999.999")                      } //[7]I.E

Private aDadosTit
Private aDadosBanco
Private aDatSacado
Private aBolText 

Private cCB_RN_NN    := {}
Private nRec         := 0
Private _nVlrAbat    := 0
Private cDigCon      := ""

oPrint := TMSPrinter():New("Boleto Laser")
oPrint:SetPortrait() // ou SetLandscape()
oPrint:StartPage()   // Inicia uma nova página

/*If cTipArq == "I"

   dbSelectArea(cAliArq)
   dbGoTop()

   While ! Eof()
      nRec := nRec + 1
      dbSkip()
   EndDo

   dbSelectArea(cAliArq)
   dbGoTop()

   ProcRegua(nRec)

   While ! Eof()

		FCarVar(cAliArq)

      dbSelectArea(cAliArq)
      dbSkip()

      IncProc()

   EndDo

Else

   dbSelectArea(cAliArq)
   dbGoTop()

   While ! Eof()

      If ! Marked("E1_OK")
         dbSelectArea(cAliArq)
         dbSkip()
         Loop
      EndIf

      nRec := nRec + 1
      dbSkip()

   EndDo

   dbSelectArea(cAliArq)
   dbGoTop()

   ProcRegua(nRec)

   While ! Eof()

      If ! Marked("E1_OK")
         dbSelectArea(cAliArq)
         dbSkip()
         Loop
      EndIf

      dbSelectArea("SE1")
      dbSetOrder(2) //E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO
      dbSeek(xFilial("SE1")+(cAliArq)->(E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO))

		FCarVar("SE1")

      dbSelectArea(cAliArq)
      dbSkip()

      IncProc()

   EndDo

EndIf      */
 
FCarVar(cImp,"SE1")

oPrint:EndPage()
oPrint:Preview()

Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FImprBol
Função de impressão do Boleto

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
Static Function FCarVar(cImp,cAliArq)

Local cConCor		:= ""
Local aImpBoleto	:= {}
Local nVlAbaRec	:= 0.00  
Local _TOTABAT 	:= 0

//Posiciona o SA6 (Bancos)
dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6")+"341"+"2938 "+"28591")

//Posiciona na Arq de Parametros CNAB
dbSelectArea("SEE")
dbSetOrder(1)
dbSeek(xFilial("SEE")+"341"+"2938 "+"28591")   //+SA6->A6_SEQBANC

/*If (SEE->(Eof())) .Or. (SEE->(! Eof()) .And. SEE->(EE_CODIGO+EE_AGENCIA+EE_CONTA) <> (cAliArq)->(E1_PORTADO+E1_AGEDEP+E1_CONTA))
   Aviso("A T E N C A O","Nao foram encontrados registros para Impressao da Boleta. Favor verificar os parametros informados !",{"OK"})
	Return()
EndIf */                                       

//cNossoNum	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"0"+cValtoChar(StrZero(Val(SC5->C5_NUM),9))                                      
//-------------------TRATAMENTO PARA BOLETO DO BANCO DO BRASIL
//cNossoNum := AllTrim(SubStr(SEE->EE_CODEMP,6,7)) + "9"+cValtoChar(StrZero(Val(SC5->C5_NUM),7))+cValtoChar(StrZero(SC5->C5_PARCELA,2))
//-------------------TRATAMENTO PARA BOLETO DO ITAU

			cParcela := cValtoChar(SC5->C5_PARCELA)
			If Val(cParcela) > 0
				cParcela := StrZero(Val(cParcela),2)
			Else
				If Empty(cParcela)
					cParcela := "00"
				Else
					If Len(AllTrim(cParcela)) >= 2
						//FAZER O TRATAMENTO PARA CASO SEJA TEXTO COM 2 CARACTERES.
					Else
						cParcela := ASC(Upper(SC5->C5_PARCELA)) - 64
						cParcela := StrZero(IIF(cParcela >= 0,cParcela,0),2)
					EndIf
				EndIf
			EndIf
			//cNossoNum := Right(AllTrim(SE1->E1_NUM),9)+cParcela
			cNossoNum := "9"+cValtoChar(StrZero(Val(SUBSTR(SC5->C5_NUM,2,5)),5))+cParcela
			//cNossoNum := "90002350501"
			//cNossNume := Right(AllTrim(SE1->E1_NUM),9)+cParcela
			//cDigito := U_SIDigitNN(cNossNume,cCodiBanc,cCarteira)  
//StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)

//"9"+cValtoChar(StrZero(Val(SC5->C5_NUM),9))

//If Empty((cAliArq)->(E1_NOSSNUM))

//	Do Case 
//		Case cCodiBanc == "001"
/*
			Do Case
				Case SE1->E1_TIPO == "NF "
					cNossoNum	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
				Case SE1->E1_TIPO == "DP "
					cNossoNum	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
				OtherWise
					cNossoNum	:= AllTrim(SubStr(SEE->EE_NOSSNUM,3,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
			EndCase
*/
/*			Do Case
				Case SE1->E1_TIPO == "NF "
					//cNossoNum	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"0"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					cNossoNum	:= Right(Alltrim(SE1->E1_NUM),7)+StrZero(Val(SE1->E1_PARCELA),3)
				Case SE1->E1_TIPO == "DP "
					//cNossoNum	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"1"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					cNossoNum	:= Right(Alltrim(SE1->E1_NUM),7)+StrZero(Val(SE1->E1_PARCELA),3)
				OtherWise
					//cNossoNum	:= AllTrim(SubStr(SEE->EE_CODEMP,6,7))+"2"+StrZero(Val(Right(Alltrim(SE1->E1_NUM),6)),6)+StrZero(Val(SE1->E1_PARCELA),3)
					cNossoNum	:= Right(Alltrim(SE1->E1_NUM),7)+StrZero(Val(SE1->E1_PARCELA),3)
			EndCase
	  
		Case cCodiBanc == '341'

			cParcela := AllTrim(SE1->E1_PARCELA)
			If Val(cParcela) > 0
				cParcela := StrZero(Val(cParcela),2)
			Else
				If Empty(cParcela)
					cParcela := "01"
				Else
					If Len(AllTrim(cParcela)) >= 2
						//FAZER O TRATAMENTO PARA CASO SEJA TEXTO COM 2 CARACTERES.
					Else
						cParcela := ASC(Upper(SE1->E1_PARCELA)) - 64
						cParcela := StrZero(IIF(cParcela >= 0,cParcela,0),2)
					EndIf
				EndIf
			EndIf
			cNossoNum := Right(AllTrim(SE1->E1_NUM),9)+cParcela

		Case cCodiBanc == '033'

			cNossoNum := "0"+StrZero(Val(SE1->E1_NUM),9)+StrZero(Val(SE1->E1_PARCELA),3)
	      cCarNossn := AllTrim(SEE->EE_NUNCART)

		OtherWise

			cCarNossn := AllTrim(SEE->EE_NUNCART)
			cNossoNum := StrZero((Val(Alltrim(SEE->EE_NOSSNUM))+1),5)
			RecLock("SEE",.F.)
			Replace EE_NOSSNUM  With Soma1(cNossoNum,Len(Alltrim(cNossoNum)))
			MsUnLock()

	EndCase
Else
	If SA6->A6_COD $ "356_001_"       
	    If SA6->A6_COD = '001' 	    	
			cNossoNum := AllTrim(SubStr(SEE->EE_CODEMP,6,7)) + AllTrim((cAliArq)->(E1_NOSSNUM))
		Else
			cNossoNum := AllTrim((cAliArq)->(E1_NOSSNUM))
		EndIf
	Else
		cNossoNum := Left(AllTrim((cAliArq)->(E1_NOSSNUM)),Len(AllTrim((cAliArq)->(E1_NOSSNUM)))-1)   //NOSSNUM
	EndIf
Endif*/

If SA6->A6_COD == "356"
	T := Right(cNossoNum,7)+SubStr(SA6->A6_AGENCIA,1,4)+Substr(SA6->A6_NUMCON,1,7)
	cDigCon := StrZero(Modulo10(T),1)
Else
	
	cDigCon := SA6->A6_DVCTA
	
EndIf   

//Posiciona o SA1 (Cliente)
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+SC5->C5_CLIENTE+SC5->C5_LOJACLI)

dbSelectArea(cAliArq)

If SA6->A6_COD $ "001_341_"
	cConCor := SA6->A6_NUMCON   //Left(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON))-1)
	cConCor := StrZero(Val(Subs(cConCor,1,Iif(AT('-',cConCor)<>0,(AT("-",cConCor)-1),Len(AllTrim(cConCor))))),7)
ElseIf SA6->A6_COD == "033"
	cConCor := SA6->A6_NUMCON   //Left(SA6->A6_NUMCON,Len(AllTrim(SA6->A6_NUMCON))-1)
	cConCor := StrZero(Val(Subs(cConCor,1,Iif(AT('-',cConCor)<>0,(AT("-",cConCor)-1),Len(AllTrim(cConCor))))),7)
//	cConCor := Left(AllTrim(SA6->A6_ZCEDENT),Len(AllTrim(SA6->A6_ZCEDENT))-2)
//	cDigCon := Right(AllTrim(SA6->A6_ZCEDENT),1)
Else
	cConCor := StrZero(Val(Subs(SA6->A6_NUMCON,1,Iif(AT('-',SA6->A6_NUMCON)<>0,(AT("-",SA6->A6_NUMCON)-1),Len(AllTrim(SA6->A6_NUMCON))))),7)
EndIf

aDadosBanco  := {SA6->A6_COD                                          ,; // [1]Numero do Banco
                 SA6->A6_NOME                                         ,; // [2]Nome do Banco
                 AllTrim(SubStr(SA6->A6_AGENCIA, 1, 4))               ,; // [3]Agência
                 cConCor											 ,; // [4]Conta Corrente
                 cDigCon                                              ,; // [5]Dígito da conta corrente
                 AllTrim(SEE->EE_NUNCART)                             ,; // [6]Codigo da Carteira 
                 AllTrim(SA6->A6_DVAGE)                               ,; // [7]Digito da Agencia
                 AllTrim("")  } // [8]Codigo Cedente   //SA6->A6_ZCEDENT



If (SA1->A1_ENDCOB == SA1->A1_END) .Or. Empty(AllTrim(SA1->A1_ENDCOB))
	aDatSacado := {AllTrim(left(SA1->A1_NOME,40))													,;// [1]Razão Social
						AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA		 						,;// [2]Código
						AllTrim(SA1->A1_END)+"-"+AllTrim(SA1->A1_BAIRRO)				,;// [3]Endereço
						AllTrim(SA1->A1_MUN)														,;// [4]Cidade
						SA1->A1_EST																	,;// [5]Estado
						Transform(SA1->A1_CEP,"@R 99999-999")								,;// [6]CEP
						AllTrim(SA1->A1_NREDUZ)													,;// [7]Nome Reduzido
						Iif(Len(Alltrim(SA1->A1_CGC)) == 14									,;
							"CNPJ: "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")	,;
							"CPF: "+Transform(SA1->A1_CGC,"@R 999.999.999-99"))		,;// [8]CNPJ
						" "  }// [9]Pedido Venda// PEDIDO: "+SE1->E1_PEDIDO												 
Else
	aDatSacado := {AllTrim(left(SA1->A1_NOME,40))													,;// [1]Razão Social
						AllTrim(SA1->A1_COD)+"-"+SA1->A1_LOJA								,;// [2]Código
						AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC)			,;// [3]Endereço
						AllTrim(SA1->A1_MUNC)													,;// [4]Cidade
						SA1->A1_ESTC																,;// [5]Estado
						Transform(SA1->A1_CEP,"@R 99999-999")								,;// [6]CEP
						AllTrim(SA1->A1_NREDUZ)													,;// [7]Nome Reduzido
						Iif(Len(Alltrim(SA1->A1_CGC)) == 14									,;
				   		"CNPJ: "+Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")	,;
				   		"CPF: "+Transform(SA1->A1_CGC,"@R 999.999.999-99"))		,;// [8]CNPJ
						" "												 }// [9]Pedido Venda   //PEDIDO: "+SE1->E1_PEDIDO												 
EndIf

//nVlAbaRec := SumAbatRec((cAliArq)->(E1_PREFIXO),(cAliArq)->(E1_NUM),(cAliArq)->(E1_PARCELA),(cAliArq)->(E1_MOEDA),"V",(cAliArq)->(E1_VENCTO))
//_nTotEnc  := (cAliArq)->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)+nVlAbaRec
_TOTABAT  := (cAliArq)->(E1_IRRF/*+E1_ISS*/+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)
_nVlrAbat := 0

//cCB_RN_NN  := U_SIReCBBo(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(cNossoNum),((cAliArq)->(E1_SALDO)+(cAliArq)->(E1_SDACRES))-_TOTABAT,Iif(cAliArq=="SE1",(cAliArq)->(E1_VENCTO),(SToD((cAliArq)->(E1_VENCTO)))),aDadosBanco[6])
  cCB_RN_NN  := U_SIReCBBo(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(cNossoNum),SC5->C5_VLCNAB,U_SOMDIAUT(Date(),3),aDadosBanco[6]) 
  //U_FTotPed()-SC5->C5_VLPGANT valor total do pedido
//Parametros da função SIReCBBo SIReCBBo(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto,cCodCart)
aImpBoleto := {0	,;  // [1] IRRF
					0		,;  // [2] ISS
					0	,;  // [3] INSS
					0		,;  // [4] PIS
					0	,;  // [5] COFINS
					0	,;  // [6] CSLL
					0					 }  // [7] Outros

aDadosTit    := {cValtoChar(StrZero(Val(SC5->C5_NUM),7))+cValtoChar(StrZero(SC5->C5_PARCELA,2))				 		,;  // [01] Número do título
						Date()	,;  // [02] Data da emissão do título
						Date()	,;  // [03] Data da emissão do boleto
						If (cImp = '1', SC5->C5_VENCBOL,U_SOMDIAUT(Date(),3))		,;  // [04] Data do vencimento
						SC5->C5_VLCNAB ,; //U_FTotPed()-SC5->C5_VLPGANT			,;  // [05] Valor do título
						cCB_RN_NN[3]																						,;  // [06] Nosso número (Ver fórmula para calculo)
						"9"																		,;  // [07] Prefixo da NF
						"0"																			,;  // [08] Tipo do Titulo
						_nVlrAbat																							,;  // [09] Abatimento
						aImpBoleto																							 }  // [10] Impostos

aBolText    := FTabAlt(AllTrim(aDadosBanco[01]),aDadosTit[05],aDadosTit[04],aDadosTit[09],aImpBoleto,(cAliArq)->(E1_PORCJUR))
_nValJurDia := aDadosTit[5] * 0.10 / 30 
aBolText	:= {"PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO. ","","","","VALOR DO JUROS: R$ "+Transform(_nValJurDia,"@E 999,999,999.99" )+" AO DIA.","",IIF ((cAliArq)->E1_PREFIXO <> 'N',"O TITULO SERA NEGATIVADO NO SERASA APÓS 10 DIAS DO VENCIMENTO. NAO RECEBER APOS O VENCIMENTO.","")} 

RecLock("SC5",.F.)  
	If cImp != '1'
		SC5->C5_VENCBOL := U_SOMDIAUT(Date(),3)
	EndIf
MsUnlock()


FImprBol(cImp,oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,cCB_RN_NN)

Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FImprBol
Função de impressão do Boleto

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
Static Function FImprBol(cImp)

Local oFont2n
Local oFont08
Local oFont09
Local oFont10
Local oFont15n
Local oFont16
Local oFont16n
Local oFont14n
Local oFont24

Local i := 0
Local cTypeBar   := "INT25"
Local nRow       := 65
Local nCol       := 1.5
Local lCheck     := .F.
Local lHorz      := .T.
Local nWidth     := 0.023
Local nHeigth    := 1.21
Local lBanner    := .F.
Local cFont      := "A"
Local lPrint     := .F.
Local nPFWidth   := 1
Local nPFHeigth  := 1   
Local cLocal          := "\SYSTEM\ANTECIPADOS\"
Local lAdjustToLegacy := .T.
Local lDisableSetup  := .T.
Local cFilePrint := "" 
Local lImpServ := .T.
Local lImpTela := .F.

If cImp = '1'        
	lImpServ = .F.
	lImpTela = .T.
    cLocal := "C:\CNABPED\"
EndIf

oPrint := FWMSPrinter():New(SC5->C5_NUM, IMP_PDF, lAdjustToLegacy,cLocal, lDisableSetup, , , ,lImpServ , , .F.,lImpTela )

    
Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        aBmp := "LOGOITAU.BMP"
   Case AllTrim(aDadosBanco[1]) == "356"
        aBmp := "LOGOREAL.BMP"
   Case AllTrim(aDadosBanco[1]) == "001"
        aBmp := "LOGOBB.BMP"
   Case AllTrim(aDadosBanco[1]) == "237"
        aBmp := "LOGOBRA.BMP"
   Case AllTrim(aDadosBanco[1]) == "033"
        aBmp := "LOG033.BMP"
   OtherWise
EndCase

//Parâmetros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)    

oFont2n  := TFont():New("Times New Roman",,10,,.T.,,,,,.F. )
oFont08  := TFont():New("Arial",09,08,.T.,.F.,5,.T.,5,.T.,.F.)
oFont09  := TFont():New("Arial",09,09,.T.,.F.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",09,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",09,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",09,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16  := TFont():New("Arial",09,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",09,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",09,24,.T.,.T.,5,.T.,5,.T.,.F.)

oPrint:StartPage()   // Inicia uma nova página



//#####################################################
//#####################################################
//PARTE INICIAL DA BOLETA
//#####################################################
//#####################################################

// Inicia aqui a alteracao para novo layout - RAI
oPrint:Line (0130,550,0050, 550)
oPrint:Line (0130,800,0050, 800)      

// Logotipo
If File(aBmp)
   aPosLogo := {0040,0100,0400,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(0084,100,aDadosBanco[2],oFont15n) //[2]Nome do Banco
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (0100,0567,"341-7",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (0100,0567,"356-5",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (0100,0567,"001-9",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (0100,0567,"237-2",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (0100,0567,"033-7",oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (0100,0567,aDadosBanco[1],oFont24) // [1]Numero do Banco
EndCase                    

oPrint:Say(0100,1900,"Comprovante de Entrega"                            ,oFont10)
oPrint:Line(0130,0100,0130,2300)
oPrint:Say(0150,0100,"Beneficiário"                                           ,oFont08)
oPrint:Say(0200,0100,aDadosEmp[1]                                     ,oFont10) //Nome + CNPJ
oPrint:Say(0150,1060,"Agência/Código Beneficiário"                            ,oFont08)
Do Case
   Case AllTrim(aDadosBanco[1]) $ "001_237_"
       oPrint:Say(0200,1060,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
   OtherWise
       oPrint:Say(0200,1060,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndCase
oPrint:Say(0150,1510,"Nro.Documento"                                     ,oFont08)
oPrint:Say(0200,1510,aDadosTit[7]+aDadosTit[1]                           ,oFont10) //Prefixo +Numero+Parcela
oPrint:Say(0250,0100,"Pagador"                                            ,oFont08)
oPrint:Say(0300,0100,aDatSacado[1]                                       ,oFont10) //Nome
oPrint:Say(0250,1060,"Vencimento"                                        ,oFont08)
oPrint:Say(0300,1060,LEFT(DTOC(aDadosTit[4]),5)+"/20"+RIGHT(DTOC(aDadosTit[4]),2),oFont10)
oPrint:Say(0250,1510,"Valor do Documento"                                ,oFont08)
oPrint:Say(0300,1550,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)
oPrint:Say(0400,0100,"Recebi(emos) o bloqueto/título"                    ,oFont10)
oPrint:Say(0450,0100,"com as características acima."                     ,oFont10)
oPrint:Say(0350,1060,"Data"                                              ,oFont08)
oPrint:Say(0350,1410,"Assinatura"                                        ,oFont08)
oPrint:Say(0450,1060,"Data"                                              ,oFont08)
oPrint:Say(0450,1410,"Entregador"                                        ,oFont08)

oPrint:Line (0230,0100,0230,1900)
oPrint:Line (0330,0100,0330,1900)
oPrint:Line (0430,1050,0430,1900)
oPrint:Line (0530,0100,0530,2300)

oPrint:Line (0530,1050,0130,1050)
oPrint:Line (0530,1400,0330,1400)
oPrint:Line (0330,1500,0130,1500)
oPrint:Line (0530,1900,0130,1900)

oPrint:Say(0150,1910,"(  )Mudou-se"               ,oFont08)
oPrint:Say(0190,1910,"(  )Ausente"                ,oFont08)
oPrint:Say(0230,1910,"(  )Não existe nº indicado" ,oFont08)
oPrint:Say(0270,1910,"(  )Recusado"               ,oFont08)
oPrint:Say(0310,1910,"(  )Não procurado"          ,oFont08)
oPrint:Say(0350,1910,"(  )Endereço insuficiente"  ,oFont08)
oPrint:Say(0390,1910,"(  )Desconhecido"           ,oFont08)
oPrint:Say(0430,1910,"(  )Falecido"               ,oFont08)
oPrint:Say(0470,1910,"(  )Outros(anotar no verso)",oFont08)

For i := 100 to 2300 step 50
    oPrint:Line( 0570, i, 0570, i+30)
Next i

//#####################################################
//#####################################################
//SERGUNDA PARTE DA BOLETA
//#####################################################
//#####################################################

oPrint:Line(0690,0100,0690,2300)
oPrint:Line(0690,0550,0590,0550)
oPrint:Line(0690,0800,0590,0800)

If File(aBmp)
   aPosLogo := {0580,0100,0380,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(0644,0100,aDadosBanco[2],oFont15n) // [2]Nome do Banco
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (0660,0567,"341-7",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (0660,0567,"356-5",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (0660,0567,"001-9",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (0660,0567,"237-2",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (0660,0567,"033-7",oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (0660,0567,aDadosBanco[1],oFont24) // [1]Numero do Banco
EndCase

oPrint:Say(0660,1900,"Recibo do Pagador",oFont10)

oPrint:Line(0760,0100,0760,2300) //ok
oPrint:Line(0850,0100,0850,2300) //ok
oPrint:Line(0930,0100,0930,2300) //ok
oPrint:Line(0990,0100,0990,2300) //ok

oPrint:Line(0850,0500,0990,0500)
oPrint:Line(0850,0750,0990,0750)
oPrint:Line(0850,1000,0990,1000)
oPrint:Line(0850,1350,0930,1350)
oPrint:Line(0850,1550,0990,1550)

oPrint:Say(0710,0100,"Local de Pagamento"                                         ,oFont08)
oPrint:Say(0730,0400,Iif(Len(aBolText)>=1,aBolText[1],"") ,oFont09)
oPrint:Say(0770,0400,Iif(Len(aBolText)>=2,aBolText[2],"") ,oFont09)

oPrint:Say(0710,1910,"Vencimento"                                                 ,oFont08)
oPrint:Say(0750,2010,LEFT(DTOC(aDadosTit[4]),5)+"/20"+RIGHT(DTOC(aDadosTit[4]),2),oFont10)

oPrint:Say(0790,0100,"Beneficiário"                                            ,oFont08)
oPrint:Say(0790,0250,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ
oPrint:Say(0830,0100,"Endereço"                                            ,oFont08)
oPrint:Say(0830,0250,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4] ,oFont09) //Nome + CNPJ

oPrint:Say(0790,1910,"Agência/Código Beneficiário"                                    ,oFont08)
Do Case
   Case AllTrim(aDadosBanco[1]) $ "001_237_"
       oPrint:Say(0830,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
   OtherWise
       oPrint:Say(0830,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndCase

oPrint:Say(0880,0100,"Data do Documento"                                         ,oFont08)
oPrint:Say(0910,0100,LEFT(DTOC(aDadosTit[2]),5)+"/20"+RIGHT(DTOC(aDadosTit[2]),2),oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say(0880,0505,"Nro.Documento"                                             ,oFont08)
oPrint:Say(0910,0605,aDadosTit[7]+aDadosTit[1]                                   ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say(0880,1005,"Espécie Doc."                                              ,oFont08)
oPrint:Say(0910,1050,"DM "                                                                             ,oFont10) //Tipo do Titulo

oPrint:Say(0880,1355,"Aceite"                                         ,oFont08)
oPrint:Say(0910,1455,"N"                                             ,oFont10)

oPrint:Say(0880,1555,"Data do Processamento"                          ,oFont08)
Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(0910,1655,""                                               ,oFont10) // Data impressao
        oPrint:Say(0880,1910,"Nosso Número"                                   ,oFont08)
        oPrint:Say(0910,2010,aDadosTit[6]                                     ,oFont10)
   OtherWise
        oPrint:Say(0910,1655,LEFT(DTOC(aDadosTit[3]),5)+"/20"+RIGHT(DTOC(aDadosTit[3]),2),oFont10) // Data impressao
        oPrint:Say(0880,1910,"Nosso Número"                                   ,oFont08)
        Do case
            Case AllTrim(aDadosBanco[1]) == "001"
                 oPrint:Say(0910,1915,LEFT(aDadosTit[6],17),oFont10) //De acordo com o Banco do brasil, nao pode aparecer o digito na impressao do boleto
            Case AllTrim(aDadosBanco[1]) == "356"
                 oPrint:Say(0910,1915,RIGHT(aDadosTit[6],7),oFont10) //De acordo com o Banco Real, somente 7 digitos devem ser impressos
            OtherWise
                 oPrint:Say(0910,1915,aDadosTit[6],oFont10)
        EndCase     
EndCase

oPrint:Say(0950,0100,"Uso do Banco"                                   ,oFont08)

oPrint:Say(0950,0505,"Carteira"                                       ,oFont08)
Do Case
	Case AllTrim(aDadosBanco[1]) == "001"
		oPrint:Say(0980,0555,"17"                                   ,oFont10)
	Case AllTrim(aDadosBanco[1]) == "033"
		oPrint:Say(0980,0555,"RCR"                                   ,oFont10)
	OtherWise 
		oPrint:Say(0980,0555,aDadosBanco[6]                                   ,oFont10)
EndCase

oPrint:Say(0950,0755,"Espécie"                                        ,oFont08)
oPrint:Say(0980,0805,"R$"                                             ,oFont10)

oPrint:Say(0959,1005,"Quantidade"                                     ,oFont08)
oPrint:Say(0950,1555,"Valor"                                          ,oFont08)

oPrint:Say(0950,1910,"Valor do Documento"                             ,oFont08)
oPrint:Say(0980,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say(1020,0100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont08)

oPrint:Say(1060,0100,Iif(Len(aBolText)>=3,aBolText[3],""),oFont09)
oPrint:Say(1100,0100,Iif(Len(aBolText)>=4,aBolText[4],""),oFont09)
oPrint:Say(1140,0100,Iif(Len(aBolText)>=5,aBolText[5],""),oFont09)
oPrint:Say(1180,0100,Iif(Len(aBolText)>=6,aBolText[6],""),oFont09)
oPrint:Say(1220,0100,Iif(Len(aBolText)>=7,aBolText[7],""),oFont09)
oPrint:Say(1260,0100,Iif(Len(aBolText)>=8,aBolText[8],""),oFont09)
oPrint:Say(1300,0100,Iif(Len(aBolText)>=9,aBolText[9],""),oFont09)

oPrint:Say(1020,1910,"(-)Desconto/Abatimento"                         ,oFont08)
oPrint:Say(1090,1910,"(-)Outras Deduções"                             ,oFont08)
oPrint:Say(1160,1910,"(+)Mora/Multa"                                  ,oFont08)
oPrint:Say(1230,1910,"(+)Outros Acréscimos"                           ,oFont08)
oPrint:Say(1300,1910,"(=)Valor Cobrado"                               ,oFont08)

oPrint:Say(1370,0100,"Pagador"																	,oFont08)
oPrint:Say(1390,0200,aDatSacado[1]+" - "+aDatSacado[8]+" ("+aDatSacado[2]+")"	,oFont10)
//oPrint:Say(1460,0200,aDatSacado[9]								,oFont10)
oPrint:Say(1430,0200,aDatSacado[3]															,oFont10)
oPrint:Say(1470,0200,aDatSacado[4]+" - "+aDatSacado[5]+" - "+aDatSacado[6]	,oFont10)

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(1510,1500,"Codigo de Baixa"                                ,oFont08)
        oPrint:Say(1510,1850,aDadosTit[6]                                     ,oFont10)
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say(1510,1500,"Codigo de Baixa"                                ,oFont08)
EndCase

If ! (aDadosBanco[1] == "341" .And. aDadosBanco[3] == "1248")
   oPrint:Say(1530,0100,"Pagador/Avalista"                               ,oFont08)
Else
   oPrint:Say(1530,0100,"Pagador/Avalista: "+AllTrim(aDadosEmp[1])+"  - "+aDadosEmp[6] ,oFont10)
EndIf

oPrint:Say(1550,1500,"Autenticação Mecânica"                          ,oFont08)

oPrint:Line(0690,1900,1350,1900)
oPrint:Line(1070,1900,1070,2300)
oPrint:Line(1140,1900,1140,2300)
oPrint:Line(1210,1900,1210,2300)
oPrint:Line(1280,1900,1280,2300)
oPrint:Line(1350,0100,1350,2300)
oPrint:Line(1540,0100,1540,2300)

For i := 100 to 2300 step 50
     oPrint:Line(1712,i,1712,i+30) // 1850
Next i

//#####################################################
//#####################################################
//TERCEIRA PARTE DA BOLETA
//#####################################################
//#####################################################

oPrint:Line(1840,0100,1840,2300) // 2000
oPrint:Line(1840,0550,1770,0550) // 2000 - 1900
oPrint:Line(1840,0800,1770,0800) // 2000 - 1900

// Logotipo
If File(aBmp)
   aPosLogo := {1730,0100,0400,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(1730,100,aDadosBanco[2],oFont15n) // [2]Nome do Banco 1934
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (1810,0567,"341-7"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (1810,0567,"356-5"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (1810,0567,"001-9"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (1810,0567,"237-2"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (1810,0567,"033-7"                                             ,oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (1810,0567,aDadosBanco[1]                                      ,oFont24) // [1]Numero do Banco
EndCase
oPrint:Say  (1810,820,cCB_RN_NN[2],oFont14n)             //Linha Digitavel do Codigo de ras   1934

oPrint:Line (1900,100,1900,2300 )    //   2100   ok
oPrint:Line (1970,100,1970,2300 )    //   2200 ok
oPrint:Line (2030,100,2030,2300 )    //   2270  OK
oPrint:Line (2090,100,2090,2300 )    //   2340  ok
//oPrint:Line (2490,100,2490,2300 )    //   2390

oPrint:Line (1970,0500,2090,500)      //   2200 - 2340  2490
oPrint:Line (2030,0750,2090,750)      //   2270 - 2340 2350
oPrint:Line (1970,1000,2090,1000)    //   2200 - 2340
oPrint:Line (1970,1350,2090,1350)    //   2200 - 2270
oPrint:Line (1970,1550,2090,1550)    //   2200 - 2340

oPrint:Say  (1855,100 ,"Local de Pagamento"                                         ,oFont08)  
oPrint:Say  (1890,400 ,Iif(Len(aBolText)>=1,aBolText[1],""),oFont09)
oPrint:Say  (1910,400 ,Iif(Len(aBolText)>=2,aBolText[2],""),oFont09)

oPrint:Say  (1855,1910,"Vencimento"                                     ,oFont08)                  // 2000
oPrint:Say  (1890,2010,LEFT(DTOC(aDadosTit[4]),5)+"/20"+RIGHT(DTOC(aDadosTit[4]),2),oFont10)

//oPrint:Say  (2180,100 ,"Beneficiário"                                        ,oFont08)                      // 2100
//oPrint:Say  (2220,100 ,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ      2140   


oPrint:Say(1920,0100,"Beneficiário"                                            ,oFont08)
oPrint:Say(1920,0250,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ
oPrint:Say(1960,0100,"Endereço"                                            ,oFont08)
oPrint:Say(1960,0250,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4] ,oFont09) //Nome + CNPJ


oPrint:Say  (1920,1910,"Agência/Código Beneficiário"                         ,oFont08)                        // 2100

//oPrint:Say  (2280,100 ,"Endereço Beneficiário"                                        ,oFont08)                      // 2100
//oPrint:Say  (2314,100 ,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4]    ,oFont09) //Nome + CNPJ      2140

Do Case
   Case AllTrim(aDadosBanco[1]) $ "001_237_"
       oPrint:Say(1955,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
   OtherWise
       oPrint:Say(1955,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndCase

oPrint:Say  (1985,100 ,"Data do Docto"                              ,oFont08)                                   // 2200
oPrint:Say  (2015,100 ,LEFT(DTOC(aDadosTit[2]),5)+"/20"+RIGHT(DTOC(aDadosTit[2]),2),oFont10) // Emissao do Titulo (E1_EMISSAO)    2230

oPrint:Say  (1985,505 ,"Nro.Documento"                                  ,oFont08)                           // 2200
oPrint:Say  (2015,605 ,aDadosTit[7]+aDadosTit[1]                                                ,oFont10) //Prefixo +Numero+Parcela  2230

oPrint:Say  (1985,1005,"Espécie Doc."                                   ,oFont08)                 // 2200
oPrint:Say  (2015,1220,"DM "                                                                             ,oFont10) //Tipo do Titulo  2230

oPrint:Say  (1985,1355,"Aceite"                                         ,oFont08)  // 2200
oPrint:Say  (2015,1455,"N"                                             ,oFont10)  // 2230

oPrint:Say  (2015,1555,"Data do Processamento"                          ,oFont08)       // 2200
Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(2085,1655,""                                               ,oFont10) // Data impressao
        oPrint:Say(1985,1910,"Nosso Número"                                   ,oFont08)       // 2200
        oPrint:Say(2015,2010,aDadosTit[6]                                     ,oFont10)  // 2230
   OtherWise
        oPrint:Say(2015,1655,LEFT(DTOC(aDadosTit[3]),5)+"/20"+RIGHT(DTOC(aDadosTit[3]),2),oFont10) // Data impressao
        oPrint:Say(1985,1910,"Nosso Número"                                 ,oFont08)
        Do case
            Case AllTrim(aDadosBanco[1]) == "001"
                 oPrint:Say(2015,1970,LEFT(aDadosTit[6],17),oFont10) //De acordo com o Banco do brasil, nao pode aparecer o digito na impressao do boleto
            Case AllTrim(aDadosBanco[1]) == "356"
                 oPrint:Say(2015,1970,RIGHT(aDadosTit[6],7),oFont10) //De acordo com o Banco Real, somente 7 digitos devem ser impressos
            OtherWise
                 oPrint:Say(2015,1970,aDadosTit[6],oFont10)
        EndCase     
EndCase

oPrint:Say(2045,100 ,"Uso do Banco"                                   ,oFont08)       // 2270

oPrint:Say(2045,505 ,"Carteira"                                       ,oFont08)       // 2270

Do Case
	Case AllTrim(aDadosBanco[1]) == "001"
		oPrint:Say(2045,605 ,"17"                                   ,oFont10)      //  2300
	Case AllTrim(aDadosBanco[1]) == "033"
		oPrint:Say(2045,605 ,"RCR"                                   ,oFont10)      //  2300
	OtherWise 
		oPrint:Say(2045,605 ,aDadosBanco[6]                                   ,oFont10)      //  2300
EndCase

oPrint:Say(2045,755 ,"Espécie"                                        ,oFont08)       //  2270
oPrint:Say(2045,0900,"R$"                                             ,oFont10)      //  2300

oPrint:Say(2045,1005,"Quantidade"                                     ,oFont08)       //  2270
oPrint:Say(2045,1555,"Valor"                                          ,oFont08)       //  2270

oPrint:Say(2045,1910,"Valor do Documento"                             ,oFont08)        //  2270
oPrint:Say(2075,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300

oPrint:Say(2210,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont08) // 2340

oPrint:Say(2250,0100,Iif(Len(aBolText)>=3,aBolText[3],""),oFont09)
oPrint:Say(2290,0100,Iif(Len(aBolText)>=4,aBolText[4],""),oFont09)
oPrint:Say(2330,0100,Iif(Len(aBolText)>=5,aBolText[5],""),oFont09)
oPrint:Say(2370,0100,Iif(Len(aBolText)>=6,aBolText[6],""),oFont09)
oPrint:Say(2410,0100,Iif(Len(aBolText)>=7,aBolText[7],""),oFont09)
oPrint:Say(2450,0100,Iif(Len(aBolText)>=8,aBolText[8],""),oFont09)
oPrint:Say(2490,0100,Iif(Len(aBolText)>=9,aBolText[9],""),oFont09)

oPrint:Say  (2105,1910,"(-)Desconto/Abatimento"                         ,oFont08)      //  2340
oPrint:Say  (2185,1910,"(-)Outras Deduções"                             ,oFont08)      //  3410
oPrint:Say  (2245,1910,"(+)Mora/Multa"                                  ,oFont08)      //  2480
oPrint:Say  (2315,1910,"(+)Outros Acréscimos"                           ,oFont08)      //  2550
oPrint:Say  (2385,1910,"(=)Valor Cobrado"                               ,oFont08)      //  2620

oPrint:Say  (2455,100 ,"Pagador"                                        				,oFont08)
oPrint:Say  (2475,200 ,aDatSacado[1]+" - "+aDatSacado[8]+" ("+aDatSacado[2]+")"	,oFont10)
//oPrint:Say  (2830,200 ,aDatSacado[9]									,oFont10)
oPrint:Say  (2515,200 ,aDatSacado[3]													 		,oFont10)
oPrint:Say  (2555,200 ,aDatSacado[4]+" - "+aDatSacado[5]+" - "+aDatSacado[6]		,oFont10)
               
If ! (aDadosBanco[1] == "341" .And. aDadosBanco[3] == "1248")
   oPrint:Say  (2655,100 ,"Pagador/Avalista"                               ,oFont08)       //2895
Else
   oPrint:Say  (2655,100 ,"Pagador/Avalista: "+AllTrim(aDadosEmp[1])+"  - "+aDadosEmp[6] ,oFont10)
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341" 
        oPrint:Say  (2624,1500,"Codigo de Baixa"                                    ,oFont08)
        oPrint:Say  (2624,1850,aDadosTit[6]                                         ,oFont10) 
   Case AllTrim(aDadosBanco[1]) == "001" 
        oPrint:Say  (2624,1500,"Codigo de Baixa"                                ,oFont08)
EndCase

oPrint:Say  (2710,1500,"Autenticação Mecânica /"                        ,oFont08)
oPrint:Say  (2710,1800,"Ficha de Compensação"                           ,oFont08)   

oPrint:Line (1840,1900,2440,1900 )         // 2000 - 2690       -
oPrint:Line (2170,1900,2170,2300 )         // 2410        - outras deducoes
oPrint:Line (2230,1900,2230,2300 )         // 2480        - ok
oPrint:Line (2300,1900,2300,2300 )         // 2550        -   ok
oPrint:Line (2370,1900,2370,2300 )         // 2620        -
oPrint:Line (2440,100 ,2440,2300 )         // 2690        -

oPrint:Line (2690,100 ,2690,2300 )         // 2930

oPrint:FWMSBAR(cTypeBar,nRow,nCol,cCB_RN_NN[1],oPrint,lCheck,,lHorz,nWidth,nHeigth,lBanner,,cFont,lPrint,nPFWidth,nPFHeigth)

//MsBar3("INT25" ,27  ,1.5 ,cBarra      ,oPrint,.F.   ,,     ,0.0230,1.21   ,       ,,"A"  ,.F.)

For i := 100 to 2300 step 50
    oPrint:Line(3115, i, 3115, i+30)
Next i

//File2Printer( cFilePrint, "PDF") 
oPrint:cPathPDF:= cLocal      


oPrint:EndPage() // Finaliza a página


Return()



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FTabAlt
Função Busca do Texto para impressão do Boleto

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
Static Function FTabAlt(cDadTab,nVlrTit,dDtVen,nVlAbatB,aImpBol,nPerJur)

Local cRetFunc := ""
Local nVlrAux  := 0
Local cTXTAux  := ""
Local nTxPerm	:= SuperGetMv("SI_TAXAPER",,0.00)
Local aRetTxt	:= {}

Local cCodAnt	:= "01"

dbSelectArea("SX5")
dbSeek(xFilial("SX5")+"Z0"+cDadTab)

While ! Eof() .And. Left(SX5->X5_CHAVE,3) == cDadTab

   If cCodAnt == "01" .And. SubStr(SX5->X5_CHAVE,4,2) == "11"
		AADD(aRetTxt,"")
   EndIf

	cCodAnt := SubStr(SX5->X5_CHAVE,4,2)

   cRetFunc := AllTrim(SX5->X5_DESCRI)
   
   Do Case
      Case AT("$$$",cRetFunc) <> 0
			  If nPerJur > 0
	           nVlrAux  := ((nVlrTit*nPerJur)/100)
           Else
	           nVlrAux  := ((nVlrTit*nTxPerm)/30)
           EndIf
           cTXTAux  := AllTrim(TransForm(nVlrAux,"@E 999,999,999.99"))
           cRetFunc := StrTran(cRetFunc,"$$$",cTXTAux)
      Case AT("###",cRetFunc) <> 0
           cTXTAux  := DToC(dDtVen)
           cRetFunc := StrTran(cRetFunc,"###",cTXTAux)
      Case AT("@1@",cRetFunc) <> 0
           cRetFunc := "DADOS BENEFICIÁRIO"
      Case AT("@2@",cRetFunc) <> 0
           cRetFunc := "ENDERECO:"+Alltrim(SM0->M0_ENDCOB)+" - BAIRRO: "+AllTrim(SM0->M0_BAIRCOB)
      Case AT("@3@",cRetFunc) <> 0
           cRetFunc := "MUNICIPIO:"+AllTrim(SM0->M0_CIDCOB)+" - UF: "+SM0->M0_ESTCOB +" - CEP: "+Transform(SM0->M0_CEPCOB,"@R 99999-999")
   EndCase

	AADD(aRetTxt,cRetFunc)

   dbSelectArea("SX5")
   dbSkip()

EndDo

cVlrImp1 := ""
cVlrImp2 := ""
nVlrImp := 0

For nXX := 1 To Len(aImpBol)

	Do Case
		Case aImpBol[nXX] > 0.00 .And. nXX == 1
			cVlrImp1 += "(IRRF R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		//Case aImpBol[nXX] > 0.00 .And. nXX == 2
		//	cVlrImp1 += "(ISS R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		Case aImpBol[nXX] > 0.00 .And. nXX == 3
			cVlrImp1 += "(INSS R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		Case aImpBol[nXX] > 0.00 .And. nXX == 4
			cVlrImp1 += "(PIS R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		Case aImpBol[nXX] > 0.00 .And. nXX == 5
			cVlrImp2 += "(COFINS R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		Case aImpBol[nXX] > 0.00 .And. nXX == 6
			cVlrImp2 += "(CSLL R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) "+iif(nXX == (len(aImpBol)-1),"","+")+" "
		//Case aImpBol[nXX] > 0.00 .And. nXX == 7
			//cVlrImp2 += "(OUTROS R$"+Transform(aImpBol[nXX],"@E 99,999.99")+" ) + "
	EndCase

	nVlrImp += aImpBol[nXX]

Next

If nVlrImp > 0.00
	If Len(aRetTxt) > 5
      Aviso("A T E N C A O","Favor verificar as Instruções, Este Boleto tem Impostos e a Linha de impressão esta sendo utilizada por outra instrução.",{"OK"})
	Else
		AADD(aRetTxt,"O valor constante no campo Desconto/Abatimento se refere a:")
		If ! Empty(cVlrImp1)
			AADD(aRetTxt,cVlrImp1)
      EndIf
		If ! Empty(cVlrImp2)
			AADD(aRetTxt,cVlrImp2)
      EndIf
	EndIf
EndIf

Return(aRetTxt) 




User Function FTotPed(cPedido,cOrig)
//Static Function TotPed(cFilial, cPedido)
Local cPedTot := "" 
Local cAlias

If cOrig = '1'    
	cPedTot := cPedido
Else
	cPedTot := SC5->C5_NUM
EndIf
	




cAlias := GetNextAlias()
cQuery := " SELECT SUM((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+ "
//cQuery += " (CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(cPedTot))+") END)+ "
cQuery += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+ "
cQuery += " (CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(cPedTot))+" ) END)+ "

cQuery += " ((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(cPedTot))+" ) END)"
cQuery += " +(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM))/100)*(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN (((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*C6_PRCVEN*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI(cPedTot))+" ) END))/100)*F7_ALIQEXT ELSE 0 END)" 
cQuery += " ELSE 0 END)) + C5_FRETE AS TotPed, A1_GRPTRIB "


cQuery += " FROM "+ RetSqlName("SC6") +" SC6"
cQuery += "	JOIN "+ RetSqlName("SC5") +" SC5 ON (SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM)"
cQuery += " JOIN "+ RetSqlName("SB1") +" SB1 ON (SB1.B1_FILIAL = '"+xFilial("SB1")+"' AND SB1.B1_COD = SC6.C6_PRODUTO)" 
cQuery += " JOIN "+ RetSqlName("SF4") +" SF4 ON (SF4.F4_FILIAL = '"+xFilial("SF4")+"' AND SF4.F4_CODIGO = SC6.C6_TES)" 
cQuery += " JOIN "+ RetSqlName("SA1") +" SA1 ON SA1.A1_FILIAL = '"+xFilial("SA1")+"' AND A1_COD = C6_CLI AND A1_LOJA = C6_LOJA"
cQuery += " LEFT JOIN SF7010 SF7 ON F7_FILIAL = C6_FILIAL AND F7_GRTRIB = B1_GRTRIB AND F7_GRPCLI = A1_GRPTRIB AND F7_EST = A1_EST "		        
cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SC6.C6_NUM = '"+cPedTot+"' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*' AND SC5.D_E_L_E_T_ <> '*'  AND SC6.D_E_L_E_T_ = ' '"
cQuery += " AND SA1.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S'"
cQuery += " GROUP BY C6_NUM, C5_FRETE, A1_GRPTRIB"

//cQuery += " ORDER BY SC6.C6_ITEM,SC6.C6_PRODUTO "       


cQuery := ChangeQuery(cQuery)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  

nValPed := (cAlias)->TotPed 

If (cAlias)->A1_GRPTRIB = "SUF"
	nValPed := nValPed * 0.9075
EndIf

DbCloseArea(cAlias)

        
Return(nValPed)      


                     


User Function FProdIPI(cPedido)



cAliasT := GetNextAlias()
cQueryT := " SELECT SUM(C6_QTDVEN*C6_PRCVEN) ProdIPI FROM SC6010,SB1010, SF4010  "
cQueryT += " WHERE C6_NUM = '"+cPedido+"' AND SB1010.D_E_L_E_T_ = ' ' "
cQueryT += " AND SC6010.D_E_L_E_T_ = ' ' AND C6_PRODUTO = B1_COD AND F4_CODIGO = C6_TES AND SF4010.D_E_L_E_T_ = ' ' AND C6_FILIAL = '"+XFilial("SC6")+"' "
  
cQueryT := ChangeQuery(cQueryT)
DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQueryT),cAliasT,.T.,.T.)  

nValPedIPI := (cAliasT)->ProdIPI     

DbCloseArea(cAliasT)

        
Return(nValPedIPI)      



User Function TstDialog()
  
  //-------------------------------------
  // A opção nOR(WS_VISIBLE,WS_POPUP) é a 
  // responsável pela janela sem borda
  //-------------------------------------
  DEFINE MSDIALOG oDlg TITLE "" PIXEL FROM 180,180 TO 550,700 STYLE nOR(WS_VISIBLE,WS_POPUP)

    cTGet1 := "Teste TGet 01"
    oTGet1 := TGet():New( 01,01,{||cTGet1},oDlg,096,009,;
              "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet1,,,, )

    cTGet2 := "Teste TGet 02"
    oTGet2 := TGet():New( 14,01,{||cTGet2},oDlg,096,009,;
              "@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,,cTGet2,,,, )

  ACTIVATE DIALOG oDlg CENTERED 

Return


              