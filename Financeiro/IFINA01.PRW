#include "protheus.ch"
#include "topconn.ch"
#include "tbiconn.ch"

//Static cEmpInt	:= "01" //GetJobProfString('cEmpInt', '' ) //--> Empresa onde ocorrerА a integraГЦo
//Static cFilInt	:= "03" //GetJobProfString('cFilInt', '' ) //--> Filial onde ocorrerА a integraГЦo

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : IFINA01			  		| 	Fevereiro de 2014						  					|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi												|
|-------------------------------------------------------------------------------------------------------|	
|	DescriГЦo : Programa para geraГЦo de XML╢s a partir de Documentos de SaМda					 		|
|-------------------------------------------------------------------------------------------------------|	
*/

//-----------------------
User Function IFINA01B()
//-----------------------

U_IFINA01("01","01")

Return  

//-----------------------
User Function IFINA01C()
//-----------------------

U_IFINA01("01","03")

Return  

//-----------------------
User Function IFINA01D()
//-----------------------

U_IFINA01("01","04")

Return  

//-----------------------
User Function IFINA01E()
//-----------------------

U_IFINA01("01","05")

Return  


//-----------------------
User Function IFINA01F()
//-----------------------

U_IFINA01("01","06")

Return  

User Function IFINA01(_cEmp,_cFil)
Local aTables := {"SF2","SD2","SM0","SA1","SF3","SFT"}

RPCSetType( 3 )
RpcSetEnv (_cEmp, _cFil, Nil, Nil, "FAT", Nil, aTables)
		
//	While !Eof() .And. SM0->M0_CODIGO = cEmpAnt
		_cIdent := FGetIdEn()
	
		_cQuery := " SELECT * "
		_cQuery += " FROM " + retSqlName("SF2") + " SF2 "
	//	_cQuery += " WHERE F2_EMISSAO = '" + dtos(date()-1) + "' "
		_cQuery += " WHERE F2_FILIAL = '" + xFilial("SF2") + "' And F2_EMISSAO >= '20150601' And "
		_cQuery += "	F2__GRVXML = ' ' AND D_E_L_E_T_ = ' ' "
	
		tcQuery _cQuery new alias "TMPSF2"
		
		do while ! TMPSF2->(EOF())
		
			if !empty(TMPSF2->F2_DOC)
	
				IFINA01A(_cIdEnt,TMPSF2->F2_SERIE,TMPSF2->F2_DOC,TMPSF2->F2_DOC,"\xmls\",CtoD("  /  /  "),CtoD("  /  /  "),"","",1)
						
			endif
		
			TMPSF2->(dbSkip())
		enddo               
		
		TMPSF2->(dbCloseArea()) 
		
//		DbSelectarea("SM0")
//		DbSkip()
//	EndDo
	
RpcClearEnv()
Return



Static Function IFINA01A(cIdEnt,cSerie,cNotaIni,cNotaFim,cDirDest,dDataDe,dDataAte,cCnpjDIni,cCnpjDFim,nTipo)

	Local aDeleta  := {}
	Local nHandle  := 0
	Local cURL     := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local cChvNFe  := ""
	Local cDestino := ""
	Local cDrive   := ""
	Local cModelo  := ""
	Local cPrefixo := ""
	Local cCNPJDEST := Space(14)                
	Local cNFes     := ""
	Local cIdflush  := cSerie+cNotaIni
	Local cXmlInut  := ""
	Local cXml		:= ""
	Local cAnoInut  := ""
	Local cAnoInut1 := ""
	Local cCanc		:= ""
	Local nX        := 0 
	Local oWS
	Local oRetorno
	Local oXML
	Local lOk      := .F.
	Local lFlush   := .T.
	Local lFinal   := .F.
	Local cAliasSF2:=GetNextAlias()
	Local cWhere:=""
	Local _aFile := {}
	
	Default nTipo	:= 1
	Default cNotaIni:=""
	Default cNotaFim:=""
	Default dDataDe:=CtoD("  /  /  ")
	Default dDataAte:=CtoD("  /  /  ")
	
	ProcRegua(Val(cNotaFim)-Val(cNotaIni))
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Corrigi diretorio de destino                                           Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	SplitPath(cDirDest,@cDrive,@cDestino,"","")
	cDestino := cDrive+cDestino
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//Ё Inicia processamento                                                   Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	Do While lFlush
		If nTipo=1
			oWS:= WSNFeSBRA():New()
			oWS:cUSERTOKEN        := "TOTVS"
			oWS:cID_ENT           := cIdEnt 
			oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"
			oWS:cIdInicial        := cIdflush // cNotaIni
			oWS:cIdFinal          := cSerie+cNotaFim
			oWS:dDataDe           := dDataDe
			oWS:dDataAte          := dDataAte
			oWS:cCNPJDESTInicial  := cCnpjDIni
			oWS:cCNPJDESTFinal    := cCnpjDFim
			oWS:nDiasparaExclusao := 0
			lOk:= oWS:RETORNAFX()
			oRetorno := oWS:oWsRetornaFxResult
		
			If lOk
				ProcRegua(Len(oRetorno:OWSNOTAS:OWSNFES3))
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Exporta as notas                                                       Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
		
			    For nX := 1 To Len(oRetorno:OWSNOTAS:OWSNFES3)
			    
	                //Ponto de Entrada para permitir filtrar as NF
	                If ExistBlock("SPDNFE01")
	                   If !ExecBlock("SPDNFE01",.f.,.f.,{oRetorno:OWSNOTAS:OWSNFES3[nX]})
	                      loop
	                   Endif
	                Endif
			    
			 		oXml    := oRetorno:OWSNOTAS:OWSNFES3[nX]
					oXmlExp := XmlParser(oRetorno:OWSNOTAS:OWSNFES3[nX]:OWSNFE:CXML,"","","")
					cXML	:= "" 
					If Type("oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ")<>"U" 
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CNPJ:TEXT)
					ElseIF Type("oXmlExp:_NFE:_INFNFE:_DEST:_CPF")<>"U"
						cCNPJDEST := AllTrim(oXmlExp:_NFE:_INFNFE:_DEST:_CPF:TEXT)				
					Else
		    			cCNPJDEST := ""
	    			EndIf	
	    				cVerNfe := IIf(Type("oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT") <> "U", oXmlExp:_NFE:_INFNFE:_VERSAO:TEXT, '')                                 
		  				cVerCte := Iif(Type("oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT") <> "U", oXmlExp:_CTE:_INFCTE:_VERSAO:TEXT, '')
			 		If !Empty(oXml:oWSNFe:cProtocolo)
				    	cNotaIni := oXml:cID	 		
						cIdflush := cNotaIni
				 		cNFes := cNFes+cNotaIni+CRLF
				 		cChvNFe  := NfeIdSPED(oXml:oWSNFe:cXML,"Id")	 			
						cModelo := cChvNFe
						cModelo := StrTran(cModelo,"NFe","")
						cModelo := StrTran(cModelo,"CTe","")
						cModelo := SubStr(cModelo,21,02)
						
						Do Case
							Case cModelo == "57"
								cPrefixo := "CTe"
							OtherWise
								cPrefixo := "NFe"
						EndCase	 				
						
			 			nHandle := FCreate(cDestino+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")
			 			If nHandle > 0
			 				cCab1 := '<?xml version="1.0" encoding="UTF-8"?>'
			 				If cModelo == "57"
								cCab1  += '<cteProc xmlns="http://www.portalfiscal.inf.br/cte" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/cte procCTe_v'+cVerCte+'.xsd" versao="'+cVerCte+'">'
								cRodap := '</cteProc>'
							Else
								Do Case
									Case cVerNfe <= "1.07"
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" xmlns:ds="http://www.w3.org/2000/09/xmldsig#" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.portalfiscal.inf.br/nfe procNFe_v1.00.xsd" versao="1.00">'
									Case cVerNfe >= "2.00" .And. "cancNFe" $ oXml:oWSNFe:cXML
										cCab1 += '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
									OtherWise
										cCab1 += '<nfeProc xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">'
								EndCase
								cRodap := '</nfeProc>'
							EndIf
							FWrite(nHandle,AllTrim(cCab1))							
				 			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXML))
				 			FWrite(nHandle,AllTrim(oXml:oWSNFe:cXMLPROT))
							FWrite(nHandle,AllTrim(cRodap))	 
				 			FClose(nHandle)
				 			AADD(_aFile,cDestino+SubStr(cChvNFe,4,44)+"-"+cPrefixo+".xml")
				 			aadd(aDeleta,oXml:cID)
				 			cXML := AllTrim(cCab1)+AllTrim(oXml:oWSNFe:cXML)+AllTrim(cRodap)
				 			If !Empty(cXML)
					 			If ExistBlock("FISEXPNFE")
		                   			ExecBlock("FISEXPNFE",.f.,.f.,{cXML})			                    
		               			Endif	
				 			EndIF
				 			
				 		EndIf					
				 	EndIf
				 	
				 	If oXml:OWSNFECANCELADA <>Nil .And. !Empty(oXml:oWSNFeCancelada:cProtocolo)
					 	cChvNFe  := NfeIdSPED(oXml:oWSNFeCancelada:cXML,"Id")
					 	cNotaIni := oXml:cID	 		
						cIdflush := cNotaIni
				 		cNFes := cNFes+cNotaIni+CRLF
					 	If !"INUT"$oXml:oWSNFeCancelada:cXML
				 			nHandle := FCreate(cDestino+SubStr(cChvNFe,3,44)+"-ped-can.xml")
				 			If nHandle > 0
				 				cCanc := oXml:oWSNFeCancelada:cXML
				 				oXml:oWSNFeCancelada:cXML := '<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + oXml:oWSNFeCancelada:cXML + "</procCancNFe>"
					 			FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
					 			FClose(nHandle)
					 			AADD(_aFile,cDestino+SubStr(cChvNFe,3,44)+"-ped-can.xml")
					 			aadd(aDeleta,oXml:cID)
					 		EndIf
				 			nHandle := FCreate(cDestino+"\"+SubStr(cChvNFe,3,44)+"-can.xml")
				 			If nHandle > 0
					 			FWrite(nHandle,'<procCancNFe xmlns="http://www.portalfiscal.inf.br/nfe" versao="' + cVerNfe + '">' + cCanc + oXml:oWSNFeCancelada:cXMLPROT + "</procCancNFe>")
					 			FClose(nHandle)
					 			AADD(_aFile,cDestino+"\"+SubStr(cChvNFe,3,44)+"-can.xml")
					 		EndIf
					 	Else 
							
	//						If Type("oXml:OWSNFECANCELADA:CXML")<>"U"
						 	    cXmlInut  := oXml:OWSNFECANCELADA:CXML
						 	    cAnoInut1 := At("<ano>",cXmlInut)+5
						 	    cAnoInut  := SubStr(cXmlInut,cAnoInut1,2)
	//					 	EndIf
				 			nHandle := FCreate(cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,38)+"-ped-inu.xml")
				 			If nHandle > 0
					 			FWrite(nHandle,oXml:oWSNFeCancelada:cXML)
					 			FClose(nHandle)
					 			AADD(_aFile,cDestino+SubStr(cChvNFe,3,2)+cAnoInut+SubStr(cChvNFe,5,38)+"-ped-inu.xml")
					 			aadd(aDeleta,oXml:cID)
					 		EndIf
				 			nHandle := FCreate(cDestino + "\" + cAnoInut+SubStr(cChvNFe,5,38) + "-inu.xml")
				 			If nHandle > 0
					 			FWrite(nHandle,oXml:oWSNFeCancelada:cXMLPROT)
					 			FClose(nHandle)
					 			AADD(_aFile,cDestino + "\" + cAnoInut+SubStr(cChvNFe,5,38) + "-inu.xml")
					 		EndIf		 	
					 	EndIf
					EndIf
					IncProc()
			    Next nX
				
				/*
				//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
				//Ё Exclui as notas                                                        Ё
				//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
				If !Empty(aDeleta) .And. GetNewPar("MV_SPEDEXP",0)<>0
					oWS:= WSNFeSBRA():New()
					oWS:cUSERTOKEN        := "TOTVS"
					oWS:cID_ENT           := cIdEnt
					oWS:nDIASPARAEXCLUSAO := GetNewPar("MV_SPEDEXP",0)
					oWS:_URL              := AllTrim(cURL)+"/NFeSBRA.apw"		
					oWS:oWSNFEID          := NFESBRA_NFES2():New()
					oWS:oWSNFEID:oWSNotas := NFESBRA_ARRAYOFNFESID2():New()
				    For nX := 1 To Len(aDeleta)	    
						aadd(oWS:oWSNFEID:oWSNotas:oWSNFESID2,NFESBRA_NFESID2():New())
						Atail(oWS:oWSNFEID:oWSNotas:oWSNFESID2):cID := aDeleta[nX]
				    Next nX
					If !oWS:RETORNANOTAS()
						Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"STR0046"},3)
						lFlush := .F.	
					EndIf
				EndIf*/
				aDeleta  := {}
			    If Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .And. Empty(cNfes)
					lFlush := .F.	
			    EndIf
			Else
				lFinal := .T.
			EndIf
	
			cIdflush := AllTrim(Substr(cIdflush,1,3) + StrZero((Val( Substr(cIdflush,4,Len(AllTrim(mv_par02))))) + 1 ,Len(AllTrim(mv_par02))))
			If cIdflush <= AllTrim(cNotaIni) .Or. Len(oRetorno:OWSNOTAS:OWSNFES3) == 0 .Or. Empty(cNfes) .Or. ;
			   cIdflush <= Substr(cNotaIni,1,3)+Replicate('0',Len(AllTrim(mv_par02))-Len(Substr(Rtrim(cNotaIni),4)))+Substr(Rtrim(cNotaIni),4)// Importou o range completo
				lFlush := .F.
				If !Empty(cNfes)
				
					DbSelectArea("SF2")
					DbSetOrder(1)
					If dbSeek(xFilial("SF2") + cNotaFim + cSerie)
						While !RecLock("SF2",.f.)
						EndDo
						SF2->F2__GRVXML  := "S"
						//ConOut("_________________Gravou log: "+Time())
						MsUnlock()
					EndIf
					
	//			   	If Aviso("SPED","STR0152",{"Sim","NЦo"}) == 1	//"SolicitaГЦo processada com sucesso."
	//					Aviso("STR0126","STR0151"+" "+Upper(cDestino)+CRLF+CRLF+cNFes,{"Ok"})
	//				EndIf
				EndIf
			EndIf
		    
			If Select(cAliasSF2) > 0
				DbSelectArea(cAliasSF2)
				dbCloseArea()
			EndIf
			lFlush := .F.
		EndIF
	EndDo
	
Return




/*--------------------------*
 | Retorna do ID da Empresa |
 *--------------------------*/
Static Function FGetIdEn()

	Local aArea  := GetArea()
	Local cIdEnt := ""
	Local cURL   := PadR(GetNewPar("MV_SPEDURL","http://"),250)
	Local oWs
	Local lUsaGesEmp := IIF(FindFunction("FWFilialName") .And. FindFunction("FWSizeFilial") .And. FWSizeFilial() > 2,.T.,.F.)
	//здддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддд©
	//ЁObtem o codigo da entidade                                              Ё
	//юдддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддддды
	oWS := WsSPEDAdm():New()
	oWS:cUSERTOKEN := "TOTVS"
		
	oWS:oWSEMPRESA:cCNPJ       := IIF(SM0->M0_TPINSC==2 .Or. Empty(SM0->M0_TPINSC),SM0->M0_CGC,"")	
	oWS:oWSEMPRESA:cCPF        := IIF(SM0->M0_TPINSC==3,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cIE         := SM0->M0_INSC
	oWS:oWSEMPRESA:cIM         := SM0->M0_INSCM		
	oWS:oWSEMPRESA:cNOME       := SM0->M0_NOMECOM
	oWS:oWSEMPRESA:cFANTASIA   := IIF(lUsaGesEmp,FWFilialName(),Alltrim(SM0->M0_NOME))
	oWS:oWSEMPRESA:cENDERECO   := FisGetEnd(SM0->M0_ENDENT)[1]
	oWS:oWSEMPRESA:cNUM        := FisGetEnd(SM0->M0_ENDENT)[3]
	oWS:oWSEMPRESA:cCOMPL      := FisGetEnd(SM0->M0_ENDENT)[4]
	oWS:oWSEMPRESA:cUF         := SM0->M0_ESTENT
	oWS:oWSEMPRESA:cCEP        := SM0->M0_CEPENT
	oWS:oWSEMPRESA:cCOD_MUN    := SM0->M0_CODMUN
	oWS:oWSEMPRESA:cCOD_PAIS   := "1058"
	oWS:oWSEMPRESA:cBAIRRO     := SM0->M0_BAIRENT
	oWS:oWSEMPRESA:cMUN        := SM0->M0_CIDENT
	oWS:oWSEMPRESA:cCEP_CP     := Nil
	oWS:oWSEMPRESA:cCP         := Nil
	oWS:oWSEMPRESA:cDDD        := Str(FisGetTel(SM0->M0_TEL)[2],3)
	oWS:oWSEMPRESA:cFONE       := AllTrim(Str(FisGetTel(SM0->M0_TEL)[3],15))
	oWS:oWSEMPRESA:cFAX        := AllTrim(Str(FisGetTel(SM0->M0_FAX)[3],15))
	oWS:oWSEMPRESA:cEMAIL      := UsrRetMail(RetCodUsr())
	oWS:oWSEMPRESA:cNIRE       := SM0->M0_NIRE
	oWS:oWSEMPRESA:dDTRE       := SM0->M0_DTRE
	oWS:oWSEMPRESA:cNIT        := IIF(SM0->M0_TPINSC==1,SM0->M0_CGC,"")
	oWS:oWSEMPRESA:cINDSITESP  := ""
	oWS:oWSEMPRESA:cID_MATRIZ  := ""
	oWS:oWSOUTRASINSCRICOES:oWSInscricao := SPEDADM_ARRAYOFSPED_GENERICSTRUCT():New()
	oWS:_URL := AllTrim(cURL)+"/SPEDADM.apw"
	If oWs:ADMEMPRESAS()
		cIdEnt  := oWs:cADMEMPRESASRESULT
	Else
		Aviso("SPED",IIf(Empty(GetWscError(3)),GetWscError(1),GetWscError(3)),{"STR0114"},3)
	EndIf
	
	RestArea(aArea)
Return(cIdEnt)
