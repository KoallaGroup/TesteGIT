#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+-----------+----------+-------+---------------------------------------+------+---------------+
| Programa  | IFATP01 | Autor | Rubens Cruz - Anadi Soluções 		   | Data | Dezembro/2014 |
+-----------+----------+-------+---------------------------------------+------+---------------+
| Descricao | Rotina para impressao do DANFE passando os dados da SF2 por parametro  	      |
+-----------+---------------------------------------------------------------------------------+
| Uso       | ISAPA																		      |
+-----------+---------------------------------------------------------------------------------+
*/

User Function IFATP01(_cFilial,_cDoc,_cSerie,_cCliente,_cLoja)
Local _aArea 			:= GetArea()
Local _aAreaSF2			:= SF2->(GetArea())
Local _cSQL 			:= ""
Local _cTab 			:= ""
Local _cIdent 			:= ""
Local _cFile 			:= ""
Local lDisableSetup  	:= .T.
Local lAdjustToLegacy 	:= .F. // Inibe legado de resolução com a TMSPrinter
Local _cFilBkp			:= cFilAnt  
Local _cIdent			:= ""
Local oSetup

Default _cFilial 	:= ""
Default _cDoc		:= ""
Default _cSerie		:= ""
Default _cCliente	:= ""
Default	_cLoja		:= ""

If !(Empty(_cFilial) .OR. Empty(_cDoc) .OR. Empty(_cSerie) .OR. Empty(_cCliente) .OR. Empty(_cLoja) )
	DbSelectArea("SF2")
	If !Dbseek(_cFilial + _cDoc + _cSerie + _cCliente + _cLoja)
		alert("Nota Fiscal não encontrada")
		Return
	EndIf
EndIf

If Select("TRB_SF2") > 0
	DbSelectArea("TRB_SF2")
	DbCloseArea()
EndIf

//Busca pelas notas não impressas e autorizadas
/*_cSQL := "SELECT F2_FILIAL,                                         "
_cSQL += "       F2_DOC,                                            "
_cSQL += "       F2_SERIE,                                          "
_cSQL += "       F2_CLIENTE,                                        "
_cSQL += "       F2_LOJA,                                           "
_cSQL += "       F2_TIPO,                                           "
_cSQL += "       ID_ENT                                             "
_cSQL += "FROM " + RetSqlName("SF2") + " SF2                        "
_cSQL += "INNER JOIN SPED050 SP ON NFE_ID = (F2_SERIE || F2_DOC)    "
_cSQL += "                         AND STATUS = 6                   "
_cSQL += "                         AND SP.D_E_L_E_T_ = ' '          "
_cSQL += "WHERE SF2.D_E_L_E_T_ = ' '                                "
_cSQL += "      AND SF2.F2_FILIAL = '" + SF2->F2_FILIAL + "'        "
_cSQL += "      AND SF2.F2_DOC = '" + SF2->F2_DOC + "'              "
_cSQL += "      AND SF2.F2_SERIE = '" + SF2->F2_SERIE + "'          "
_cSQL += "      AND SF2.F2_CLIENTE = '" + SF2->F2_CLIENTE + "'      "
_cSQL += "      AND SF2.F2_LOJA = '" + SF2->F2_LOJA + "'            "
TCQUERY _cSQL NEW ALIAS "TRB_SF2" */

/*If(Empty(TRB_SF2->ID_ENT))
	Alert("Nota Fiscal não autorizada no SEFAZ")
	Return
EndIf*/

_cIdent := FGetIdEn()


_cFile := "DANFE_"+_cIdEnt+Dtos(MSDate())+StrTran(Time(),":","")

oDanfe := FWMSPrinter():New(_cFile, IMP_PDF, lAdjustToLegacy, GetTempPath(), lDisableSetup,,,,.F.,.T.,.F.,.T.)
oDanfe:cPathPDF 	:= GetTempPath()
                                             
cFilAnt := SF2->F2_FILIAL

U_DANFE_P1(_cIdent,,,oDanfe, oSetup)

cFilAnt := _cFilBkp

//TRB_SF2->(DbCloseArea())
RestArea(_aAreaSF2)
RestArea(_aArea)

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
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Obtem o codigo da entidade                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
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