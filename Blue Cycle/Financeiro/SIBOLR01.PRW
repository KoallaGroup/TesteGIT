#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//------------------------------------------------------------------- 
/*/{Protheus.doc} SIBOLR01
Rotina de Impressão da Boleta.
       
@author	Ederson Colen
@since	08/01/2013
@version P11                                                     
@param	
@return	Nil

@obs	       
        
Alteracoes Realizadas desde a Estruturacao Inicial 
Data       Programador     Motivo 
/*/ 
//------------------------------------------------------------------ 
User Function SIBOLR01(cPrefFat,cNumDupl,cNParcIn,cNParcFi,cCliente,cLojaCli)

Do Case
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

EndCase

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
Static Function FImpBol(cTipArq,cAliArq)


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

If cTipArq == "I"

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

EndIf

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
Static Function FCarVar(cAliArq)

Local cConCor		:= ""
Local aImpBoleto	:= {}
Local nVlAbaRec	:= 0.00  
Local _TOTABAT 	:= 0

//Posiciona o SA6 (Bancos)
dbSelectArea("SA6")
dbSetOrder(1)
dbSeek(xFilial("SA6")+(cAliArq)->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)

//Posiciona na Arq de Parametros CNAB
dbSelectArea("SEE")
dbSetOrder(1)
dbSeek(xFilial("SEE")+(cAliArq)->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)   //+SA6->A6_SEQBANC

If (SEE->(Eof())) .Or. (SEE->(! Eof()) .And. SEE->(EE_CODIGO+EE_AGENCIA+EE_CONTA) <> (cAliArq)->(E1_PORTADO+E1_AGEDEP+E1_CONTA))
   Aviso("A T E N C A O","Nao foram encontrados registros para Impressao da Boleta. Favor verificar os parametros informados !",{"OK"})
	Return()
EndIf

If Empty((cAliArq)->(E1_NOSSNUM))

	Do Case 
		Case cCodiBanc == "001"
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
			Do Case
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
Endif

If SA6->A6_COD == "356"
	T := Right(cNossoNum,7)+SubStr(SA6->A6_AGENCIA,1,4)+Substr(SA6->A6_NUMCON,1,7)
	cDigCon := StrZero(Modulo10(T),1)
Else
	cDigCon := SA6->A6_DVCTA
EndIf   

//Posiciona o SA1 (Cliente)
dbSelectArea("SA1")
dbSetOrder(1)
dbSeek(xFilial("SA1")+(cAliArq)->E1_CLIENTE+(cAliArq)->E1_LOJA)

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

nVlAbaRec := SumAbatRec((cAliArq)->(E1_PREFIXO),(cAliArq)->(E1_NUM),(cAliArq)->(E1_PARCELA),(cAliArq)->(E1_MOEDA),"V",(cAliArq)->(E1_VENCTO))
_nTotEnc  := (cAliArq)->(E1_IRRF+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)+nVlAbaRec
_TOTABAT  := (cAliArq)->(E1_IRRF/*+E1_ISS*/+E1_INSS+E1_PIS+E1_COFINS+E1_CSLL)
_nVlrAbat := _nTotEnc

//cCB_RN_NN  := U_SIReCBBo(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(cNossoNum),((cAliArq)->(E1_SALDO)+(cAliArq)->(E1_SDACRES))-_TOTABAT,Iif(cAliArq=="SE1",(cAliArq)->(E1_VENCTO),(SToD((cAliArq)->(E1_VENCTO)))),aDadosBanco[6])
  cCB_RN_NN  := U_SIReCBBo(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(cNossoNum),(((cAliArq)->(E1_SALDO)+(cAliArq)->(E1_SDACRES))-(cAliArq)->(E1_SDDECRE))-_TOTABAT,Iif(cAliArq=="SE1",(cAliArq)->(E1_VENCTO),(SToD((cAliArq)->(E1_VENCTO)))),aDadosBanco[6])

aImpBoleto := {(cAliArq)->(E1_IRRF)	,;  // [1] IRRF
					(cAliArq)->(E1_ISS)		,;  // [2] ISS
					(cAliArq)->(E1_INSS)	,;  // [3] INSS
					(cAliArq)->(E1_PIS)		,;  // [4] PIS
					(cAliArq)->(E1_COFINS)	,;  // [5] COFINS
					(cAliArq)->(E1_CSLL)	,;  // [6] CSLL
					nVlAbaRec					 }  // [7] Outros

aDadosTit    := {AllTrim((cAliArq)->(E1_NUM))+"-"+AllTrim((cAliArq)->(E1_PARCELA))				 		,;  // [01] Número do título
						Iif(cAliArq=="SE1",(cAliArq)->(E1_EMISSAO),SToD((cAliArq)->(E1_EMISSAO)))	,;  // [02] Data da emissão do título
						Date()																								,;  // [03] Data da emissão do boleto
						Iif(cAliArq=="SE1",(cAliArq)->(E1_VENCTO),SToD((cAliArq)->(E1_VENCTO)))		,;  // [04] Data do vencimento
						Round((((cAliArq)->(E1_SALDO)+(cAliArq)->(E1_SDACRES))-(cAliArq)->(E1_SDDECRE)),2) - _TOTABAT			,;  // [05] Valor do título
						cCB_RN_NN[3]																						,;  // [06] Nosso número (Ver fórmula para calculo)
						(cAliArq)->(E1_PREFIXO)																		,;  // [07] Prefixo da NF
						(cAliArq)->(E1_TIPO)																			,;  // [08] Tipo do Titulo
						_nVlrAbat																							,;  // [09] Abatimento
						aImpBoleto																							 }  // [10] Impostos

aBolText    := FTabAlt(AllTrim(aDadosBanco[01]),aDadosTit[05],aDadosTit[04],aDadosTit[09],aImpBoleto,(cAliArq)->(E1_PORCJUR))
_nValJurDia := aDadosTit[5] * 0.10 / 30 
aBolText	:= {"PAGAVEL EM QUALQUER BANCO ATÉ O VENCIMENTO.","","","","VALOR DO JUROS: R$ "+Transform(_nValJurDia,"@E 999,999,999.99" )+" AO DIA.","",IIF ((cAliArq)->E1_PREFIXO <> 'N',"O TITULO SERÁ NEGATIVADO NO SERASA APOS 10 DIAS DO VENCIMENTO.","")} 


FImprBol(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,cCB_RN_NN)

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
Static Function FImprBol()

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
Local nRow       := 26
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
oPrint:Line (0150,550,0050, 550)
oPrint:Line (0150,800,0050, 800)      

// Logotipo
If File(aBmp)
   aPosLogo := {0040,0100,0400,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(0084,100,aDadosBanco[2],oFont15n) //[2]Nome do Banco
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (0062,0567,"341-7",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (0062,0567,"356-5",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (0062,0567,"001-9",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (0062,0567,"237-2",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (0062,0567,"033-7",oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (0062,0567,aDadosBanco[1],oFont24) // [1]Numero do Banco
EndCase

oPrint:Say(0084,1900,"Comprovante de Entrega"                            ,oFont10)
oPrint:Line(0150,0100,0150,2300)
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

oPrint:Line (0250,0100,0250,1900)
oPrint:Line (0350,0100,0350,1900)
oPrint:Line (0450,1050,0450,1900)
oPrint:Line (0550,0100,0550,2300)

oPrint:Line (0550,1050,0150,1050)
oPrint:Line (0550,1400,0350,1400)
oPrint:Line (0350,1500,0150,1500)
oPrint:Line (0550,1900,0150,1900)

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
    oPrint:Line( 0590, i, 0590, i+30)
Next i

//#####################################################
//#####################################################
//SERGUNDA PARTE DA BOLETA
//#####################################################
//#####################################################

oPrint:Line(0710,0100,0710,2300)
oPrint:Line(0710,0550,0610,0550)
oPrint:Line(0710,0800,0610,0800)

If File(aBmp)
   aPosLogo := {0600,0100,0400,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(0644,0100,aDadosBanco[2],oFont15n) // [2]Nome do Banco
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (0622,0567,"341-7",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (0622,0567,"356-5",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (0622,0567,"001-9",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (0622,0567,"237-2",oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (0622,0567,"033-7",oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (0622,0567,aDadosBanco[1],oFont24) // [1]Numero do Banco
EndCase

oPrint:Say(0644,1900,"Recibo do Pagador",oFont10)

oPrint:Line(0810,0100,0810,2300)
oPrint:Line(0910,0100,0910,2300)
oPrint:Line(0980,0100,0980,2300)
oPrint:Line(1050,0100,1050,2300)

oPrint:Line(0910,0500,1050,0500)
oPrint:Line(0980,0750,1050,0750)
oPrint:Line(0910,1000,1050,1000)
oPrint:Line(0910,1350,0980,1350)
oPrint:Line(0910,1550,1050,1550)

oPrint:Say(0710,0100,"Local de Pagamento"                                         ,oFont08)
oPrint:Say(0730,0400,Iif(Len(aBolText)>=1,aBolText[1],"") ,oFont09)
oPrint:Say(0770,0400,Iif(Len(aBolText)>=2,aBolText[2],"") ,oFont09)

oPrint:Say(0710,1910,"Vencimento"                                                 ,oFont08)
oPrint:Say(0750,2010,LEFT(DTOC(aDadosTit[4]),5)+"/20"+RIGHT(DTOC(aDadosTit[4]),2),oFont10)

oPrint:Say(0810,0100,"Beneficiário"                                            ,oFont08)
oPrint:Say(0810,0250,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ
oPrint:Say(0850,0100,"Endereço"                                            ,oFont08)
oPrint:Say(0850,0250,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4] ,oFont09) //Nome + CNPJ

oPrint:Say(0810,1910,"Agência/Código Beneficiário"                                    ,oFont08)
Do Case
   Case AllTrim(aDadosBanco[1]) $ "001_237_"
       oPrint:Say(0850,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
   OtherWise
       oPrint:Say(0850,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndCase

oPrint:Say(0910,0100,"Data do Documento"                                         ,oFont08)
oPrint:Say(0940,0100,LEFT(DTOC(aDadosTit[2]),5)+"/20"+RIGHT(DTOC(aDadosTit[2]),2),oFont10) // Emissao do Titulo (E1_EMISSAO)

oPrint:Say(0910,0505,"Nro.Documento"                                             ,oFont08)
oPrint:Say(0940,0605,aDadosTit[7]+aDadosTit[1]                                   ,oFont10) //Prefixo +Numero+Parcela

oPrint:Say(0910,1005,"Espécie Doc."                                              ,oFont08)
oPrint:Say(0940,1050,"DM "                                                                             ,oFont10) //Tipo do Titulo

oPrint:Say(0910,1355,"Aceite"                                         ,oFont08)
oPrint:Say(0940,1455,"N"                                             ,oFont10)

oPrint:Say(0910,1555,"Data do Processamento"                          ,oFont08)
Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(0940,1655,""                                               ,oFont10) // Data impressao
        oPrint:Say(0910,1910,"Nosso Número"                                   ,oFont08)
        oPrint:Say(0940,2010,aDadosTit[6]                                     ,oFont10)
   OtherWise
        oPrint:Say(0940,1655,LEFT(DTOC(aDadosTit[3]),5)+"/20"+RIGHT(DTOC(aDadosTit[3]),2),oFont10) // Data impressao
        oPrint:Say(0910,1910,"Nosso Número"                                   ,oFont08)
        Do case
            Case AllTrim(aDadosBanco[1]) == "001"
                 oPrint:Say(0940,1915,LEFT(aDadosTit[6],17),oFont10) //De acordo com o Banco do brasil, nao pode aparecer o digito na impressao do boleto
            Case AllTrim(aDadosBanco[1]) == "356"
                 oPrint:Say(0940,1915,RIGHT(aDadosTit[6],7),oFont10) //De acordo com o Banco Real, somente 7 digitos devem ser impressos
            OtherWise
                 oPrint:Say(0940,1915,aDadosTit[6],oFont10)
        EndCase     
EndCase

oPrint:Say(0980,0100,"Uso do Banco"                                   ,oFont08)

oPrint:Say(0980,0505,"Carteira"                                       ,oFont08)
Do Case
	Case AllTrim(aDadosBanco[1]) == "001"
		oPrint:Say(1010,0555,"17"                                   ,oFont10)
	Case AllTrim(aDadosBanco[1]) == "033"
		oPrint:Say(1010,0555,"RCR"                                   ,oFont10)
	OtherWise 
		oPrint:Say(1010,0555,aDadosBanco[6]                                   ,oFont10)
EndCase

oPrint:Say(0980,0755,"Espécie"                                        ,oFont08)
oPrint:Say(1010,0805,"R$"                                             ,oFont10)

oPrint:Say(0980,1005,"Quantidade"                                     ,oFont08)
oPrint:Say(0980,1555,"Valor"                                          ,oFont08)

oPrint:Say(0980,1910,"Valor do Documento"                             ,oFont08)
oPrint:Say(1010,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)

oPrint:Say(1050,0100,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont08)

oPrint:Say(1090,0100,Iif(Len(aBolText)>=3,aBolText[3],""),oFont09)
oPrint:Say(1130,0100,Iif(Len(aBolText)>=4,aBolText[4],""),oFont09)
oPrint:Say(1170,0100,Iif(Len(aBolText)>=5,aBolText[5],""),oFont09)
oPrint:Say(1210,0100,Iif(Len(aBolText)>=6,aBolText[6],""),oFont09)
oPrint:Say(1250,0100,Iif(Len(aBolText)>=7,aBolText[7],""),oFont09)
oPrint:Say(1290,0100,Iif(Len(aBolText)>=8,aBolText[8],""),oFont09)
oPrint:Say(1330,0100,Iif(Len(aBolText)>=9,aBolText[9],""),oFont09)

oPrint:Say(1050,1910,"(-)Desconto/Abatimento"                         ,oFont08)
oPrint:Say(1120,1910,"(-)Outras Deduções"                             ,oFont08)
oPrint:Say(1190,1910,"(+)Mora/Multa"                                  ,oFont08)
oPrint:Say(1260,1910,"(+)Outros Acréscimos"                           ,oFont08)
oPrint:Say(1330,1910,"(=)Valor Cobrado"                               ,oFont08)

oPrint:Say(1400,0100,"Pagador"																	,oFont08)
oPrint:Say(1420,0200,aDatSacado[1]+" - "+aDatSacado[8]+" ("+aDatSacado[2]+")"	,oFont10)
//oPrint:Say(1460,0200,aDatSacado[9]								,oFont10)
oPrint:Say(1460,0200,aDatSacado[3]															,oFont10)
oPrint:Say(1500,0200,aDatSacado[4]+" - "+aDatSacado[5]+" - "+aDatSacado[6]	,oFont10)

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(1560,1500,"Codigo de Baixa"                                ,oFont08)
        oPrint:Say(1560,1850,aDadosTit[6]                                     ,oFont10)
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say(1560,1500,"Codigo de Baixa"                                ,oFont08)
EndCase

If ! (aDadosBanco[1] == "341" .And. aDadosBanco[3] == "1248")
   oPrint:Say(1600,0100,"Pagador/Avalista"                               ,oFont08)
Else
   oPrint:Say(1600,0100,"Pagador/Avalista: "+AllTrim(aDadosEmp[1])+"  - "+aDadosEmp[6] ,oFont10)
EndIf

oPrint:Say(1645,1500,"Autenticação Mecânica"                          ,oFont08)

oPrint:Line(0710,1900,1400,1900)
oPrint:Line(1120,1900,1120,2300)
oPrint:Line(1190,1900,1190,2300)
oPrint:Line(1260,1900,1260,2300)
oPrint:Line(1330,1900,1330,2300)
oPrint:Line(1400,0100,1400,2300)
oPrint:Line(1640,0100,1640,2300)

For i := 100 to 2300 step 50
     oPrint:Line(1930,i,1930,i+30) // 1850
Next i

//#####################################################
//#####################################################
//TERCEIRA PARTE DA BOLETA
//#####################################################
//#####################################################

oPrint:Line(2080,0100,2080,2300) // 2000
oPrint:Line(2080,0550,1980,0550) // 2000 - 1900
oPrint:Line(2080,0800,1980,0800) // 2000 - 1900

// Logotipo
If File(aBmp)
   aPosLogo := {1970,0100,0400,0100}
   oPrint:SayBitmap(aPosLogo[01],aPosLogo[02],aBmp,aPosLogo[03],aPosLogo[04])
Else
   oPrint:Say(2014,100,aDadosBanco[2],oFont15n) // [2]Nome do Banco 1934
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say  (1992,0567,"341-7"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "356"
        oPrint:Say  (1992,0567,"356-5"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "001"
        oPrint:Say  (1992,0567,"001-9"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "237"
        oPrint:Say  (1992,0567,"237-2"                                             ,oFont24) // [1]Numero do Banco
   Case AllTrim(aDadosBanco[1]) == "033"
        oPrint:Say  (1992,0567,"033-7"                                             ,oFont24) // [1]Numero do Banco
   OtherWise
        oPrint:Say  (1992,0567,aDadosBanco[1]                                      ,oFont24) // [1]Numero do Banco
EndCase
oPrint:Say  (2014,820,cCB_RN_NN[2],oFont14n)             //Linha Digitavel do Codigo de Barras   1934

oPrint:Line (2180,100,2180,2300 )    //   2100
oPrint:Line (2280,100,2280,2300 )    //   2200
oPrint:Line (2350,100,2350,2300 )    //   2270
oPrint:Line (2420,100,2420,2300 )    //   2340
//oPrint:Line (2490,100,2490,2300 )    //   2390

oPrint:Line (2280,0500,2420,500)      //   2200 - 2340  2490
oPrint:Line (2350,0750,2420,750)      //   2270 - 2340 2350
oPrint:Line (2280,1000,2420,1000)    //   2200 - 2340
oPrint:Line (2280,1350,2350,1350)    //   2200 - 2270
oPrint:Line (2280,1550,2420,1550)    //   2200 - 2340

oPrint:Say  (2080,100 ,"Local de Pagamento"                                         ,oFont08)  
oPrint:Say  (2100,400 ,Iif(Len(aBolText)>=1,aBolText[1],""),oFont09)
oPrint:Say  (2140,400 ,Iif(Len(aBolText)>=2,aBolText[2],""),oFont09)

oPrint:Say  (2080,1910,"Vencimento"                                     ,oFont08)                  // 2000
oPrint:Say  (2120,2010,LEFT(DTOC(aDadosTit[4]),5)+"/20"+RIGHT(DTOC(aDadosTit[4]),2),oFont10)

//oPrint:Say  (2180,100 ,"Beneficiário"                                        ,oFont08)                      // 2100
//oPrint:Say  (2220,100 ,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ      2140   


oPrint:Say(2180,0100,"Beneficiário"                                            ,oFont08)
oPrint:Say(2180,0250,aDadosEmp[1]+"     - "+aDadosEmp[6] ,oFont09) //Nome + CNPJ
oPrint:Say(2220,0100,"Endereço"                                            ,oFont08)
oPrint:Say(2220,0250,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4] ,oFont09) //Nome + CNPJ


oPrint:Say  (2180,1910,"Agência/Código Beneficiário"                         ,oFont08)                        // 2100

//oPrint:Say  (2280,100 ,"Endereço Beneficiário"                                        ,oFont08)                      // 2100
//oPrint:Say  (2314,100 ,aDadosEmp[2]+" - "+aDadosEmp[3]+" - "+aDadosEmp[4]    ,oFont09) //Nome + CNPJ      2140

Do Case
   Case AllTrim(aDadosBanco[1]) $ "001_237_"
       oPrint:Say(2240,2010,aDadosBanco[3]+"-"+aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
   OtherWise
       oPrint:Say(2240,2010,aDadosBanco[3]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5],oFont10)
EndCase

oPrint:Say  (2280,100 ,"Data do Docto"                              ,oFont08)                                   // 2200
oPrint:Say  (2310,100 ,LEFT(DTOC(aDadosTit[2]),5)+"/20"+RIGHT(DTOC(aDadosTit[2]),2),oFont10) // Emissao do Titulo (E1_EMISSAO)    2230

oPrint:Say  (2280,505 ,"Nro.Documento"                                  ,oFont08)                           // 2200
oPrint:Say  (2310,605 ,aDadosTit[7]+aDadosTit[1]                                                ,oFont10) //Prefixo +Numero+Parcela  2230

oPrint:Say  (2280,1005,"Espécie Doc."                                   ,oFont08)                 // 2200
oPrint:Say  (2310,1220,"DM "                                                                             ,oFont10) //Tipo do Titulo  2230

oPrint:Say  (2280,1355,"Aceite"                                         ,oFont08)  // 2200
oPrint:Say  (2310,1455,"N"                                             ,oFont10)  // 2230

oPrint:Say  (2280,1555,"Data do Processamento"                          ,oFont08)       // 2200
Do Case
   Case AllTrim(aDadosBanco[1]) == "341"
        oPrint:Say(2380,1655,""                                               ,oFont10) // Data impressao
        oPrint:Say(2280,1910,"Nosso Número"                                   ,oFont08)       // 2200
        oPrint:Say(2310,2010,aDadosTit[6]                                     ,oFont10)  // 2230
   OtherWise
        oPrint:Say(2310,1655,LEFT(DTOC(aDadosTit[3]),5)+"/20"+RIGHT(DTOC(aDadosTit[3]),2),oFont10) // Data impressao
        oPrint:Say(2280,1910,"Nosso Número"                                 ,oFont08)
        Do case
            Case AllTrim(aDadosBanco[1]) == "001"
                 oPrint:Say(2310,1970,LEFT(aDadosTit[6],17),oFont10) //De acordo com o Banco do brasil, nao pode aparecer o digito na impressao do boleto
            Case AllTrim(aDadosBanco[1]) == "356"
                 oPrint:Say(2310,1970,RIGHT(aDadosTit[6],7),oFont10) //De acordo com o Banco Real, somente 7 digitos devem ser impressos
            OtherWise
                 oPrint:Say(2310,1970,aDadosTit[6],oFont10)
        EndCase     
EndCase

oPrint:Say(2350,100 ,"Uso do Banco"                                   ,oFont08)       // 2270

oPrint:Say(2350,505 ,"Carteira"                                       ,oFont08)       // 2270

Do Case
	Case AllTrim(aDadosBanco[1]) == "001"
		oPrint:Say(2350,605 ,"17"                                   ,oFont10)      //  2300
	Case AllTrim(aDadosBanco[1]) == "033"
		oPrint:Say(2350,605 ,"RCR"                                   ,oFont10)      //  2300
	OtherWise 
		oPrint:Say(2350,605 ,aDadosBanco[6]                                   ,oFont10)      //  2300
EndCase

oPrint:Say(2350,755 ,"Espécie"                                        ,oFont08)       //  2270
oPrint:Say(2350,0900,"R$"                                             ,oFont10)      //  2300

oPrint:Say(2350,1005,"Quantidade"                                     ,oFont08)       //  2270
oPrint:Say(2350,1555,"Valor"                                          ,oFont08)       //  2270

oPrint:Say(2350,1910,"Valor do Documento"                             ,oFont08)        //  2270
oPrint:Say(2380,2010,AllTrim(Transform(aDadosTit[5],"@E 999,999,999.99")),oFont10)  //   2300

oPrint:Say(2500,100 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do Beneficiário)",oFont08) // 2340

oPrint:Say(2530,0100,Iif(Len(aBolText)>=3,aBolText[3],""),oFont09)
oPrint:Say(2570,0100,Iif(Len(aBolText)>=4,aBolText[4],""),oFont09)
oPrint:Say(2610,0100,Iif(Len(aBolText)>=5,aBolText[5],""),oFont09)
oPrint:Say(2650,0100,Iif(Len(aBolText)>=6,aBolText[6],""),oFont09)
oPrint:Say(2690,0100,Iif(Len(aBolText)>=7,aBolText[7],""),oFont09)
oPrint:Say(2730,0100,Iif(Len(aBolText)>=8,aBolText[8],""),oFont09)
oPrint:Say(2770,0100,Iif(Len(aBolText)>=9,aBolText[9],""),oFont09)

oPrint:Say  (2420,1910,"(-)Desconto/Abatimento"                         ,oFont08)      //  2340
oPrint:Say  (2490,1910,"(-)Outras Deduções"                             ,oFont08)      //  3410
oPrint:Say  (2560,1910,"(+)Mora/Multa"                                  ,oFont08)      //  2480
oPrint:Say  (2630,1910,"(+)Outros Acréscimos"                           ,oFont08)      //  2550
oPrint:Say  (2700,1910,"(=)Valor Cobrado"                               ,oFont08)      //  2620

oPrint:Say  (2770,100 ,"Pagador"                                       				,oFont08)
oPrint:Say  (2790,200 ,aDatSacado[1]+" - "+aDatSacado[8]+" ("+aDatSacado[2]+")"	,oFont10)
//oPrint:Say  (2830,200 ,aDatSacado[9]									,oFont10)
oPrint:Say  (2830,200 ,aDatSacado[3]													 		,oFont10)
oPrint:Say  (2870,200 ,aDatSacado[4]+" - "+aDatSacado[5]+" - "+aDatSacado[6]		,oFont10)

If ! (aDadosBanco[1] == "341" .And. aDadosBanco[3] == "1248")
   oPrint:Say  (2970,100 ,"Pagador/Avalista"                               ,oFont08)       //2895
Else
   oPrint:Say  (2970,100 ,"Pagador/Avalista: "+AllTrim(aDadosEmp[1])+"  - "+aDadosEmp[6] ,oFont10)
EndIf

Do Case
   Case AllTrim(aDadosBanco[1]) == "341" 
        oPrint:Say  (2939,1500,"Codigo de Baixa"                                    ,oFont08)
        oPrint:Say  (2939,1850,aDadosTit[6]                                         ,oFont10) 
   Case AllTrim(aDadosBanco[1]) == "001" 
        oPrint:Say  (2939,1500,"Codigo de Baixa"                                ,oFont08)
EndCase

oPrint:Say  (3025,1500,"Autenticação Mecânica /"                        ,oFont08)
oPrint:Say  (3025,1800,"Ficha de Compensação"                           ,oFont08)   

oPrint:Line (2080,1900,2770,1900 )         // 2000 - 2690       -
oPrint:Line (2490,1900,2490,2300 )         // 2410        -
oPrint:Line (2560,1900,2560,2300 )         // 2480        -
oPrint:Line (2630,1900,2630,2300 )         // 2550        -
oPrint:Line (2700,1900,2700,2300 )         // 2620        -
oPrint:Line (2770,100 ,2770,2300 )         // 2690        -

oPrint:Line (3020,100 ,3020,2300 )         // 2930

MSBAR3(cTypeBar,nRow,nCol,cCB_RN_NN[1],oPrint,lCheck,,lHorz,nWidth,nHeigth,lBanner,,cFont,lPrint,nPFWidth,nPFHeigth)
//MsBar3("INT25" ,27  ,1.5 ,cBarra      ,oPrint,.F.   ,,     ,0.0230,1.21   ,       ,,"A"  ,.F.)

For i := 100 to 2300 step 50
    oPrint:Line(3315, i, 3315, i+30)
Next i

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