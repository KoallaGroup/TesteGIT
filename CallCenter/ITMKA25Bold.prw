#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKA25B | Autor: |    Rogério Alves     | Data: |  Novembro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Pedido na data de previsão de Faturamento por status (ITMKA25)     |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKA25B(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)

Local _aArea 		:= GetArea()
Local oTot
Local oTot1
Local oTot2
Local oTot3
Local oTot4
Local oTot5

Private aHeaderPed	:= {}
Private aColsB      := {}
Private oDlgTMP     := Nil
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {}
Private oFont14     := tFont():New("Tahoma",,-11,,.t.)
Private lRet		:= .F.
Private aButtons 	:= {}
Private cFat 		:= Posicione("SZM",1,xFilial("SZM")+cSit,"ZM_EXIFAT")              

//Public oTot6
//Public oTot7

HdPed()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj  := MsObjSize( ainfo, aObjects )       

// ACSJ - 24-11-2014

                                  	
oGetPD1 := MsNewGetDados():New(aPosObj[1,1]+5, aPosObj[1,2]+3, aPosObj[1,1]+147, aPosObj[1,4]-10,,"AllwaysTrue","AllwaysTrue", "", aEdit, , , , , , oFolder1:aDialogs[2], aHeaderPed, aColsB)
oGetPD1:bChange := {|| U_RODAPE() }	

@ aPosObj[1,1]+150, aPosObj[1,2]+003  	GROUP	oTotais TO aPosObj[1,1]+187, aPosObj[1,4]-100 PROMPT "Totais"	OF oFolder1:aDialogs[2] COLOR 0, 16777215 PIXEL

@ aPosObj[1,1]+157, aPosObj[1,2]+006 	SAY 	oTot1 	PROMPT "Quantidade" 	SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+006 	MSGET 	oTot1 	VAR 	cTotP1 		    Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.


@ aPosObj[1,1]+157, aPosObj[1,2]+075 	SAY	 	oTot2 	PROMPT 	"Total Peça" 	SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+075 	MSGET 	oTot2 	VAR 	cTotP2 		    Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[2] COLORS 0,	16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+140 	SAY 	oTot3 	PROMPT 	"Total Pneu" 	SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+140 	MSGET 	oTot3 	VAR 	cTotP3 		    Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+205 	SAY 	oTot5 	PROMPT 	"Total Frete" 	SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+205 	MSGET 	oTot5 	VAR 	cTotP5 		    Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+270 	SAY 	oTot4 	PROMPT 	"Total Pedidos" SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+270 	MSGET	oTot4 	VAR 	cTotP4 		    Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  
                                   	
@ aPosObj[1,1]+153,aPosObj[1,4]-90 Button oButton PROMPT "Visualizar" 			SIZE 80,34    OF oFolder1:aDialogs[2]  	PIXEL ACTION (lRet := .T.,VisPed((oGetPD1:aCols[oGetPD1:nat][1]), (oGetPD1:aCols[oGetPD1:nat][2])))

@ aPosObj[1,1]+195, aPosObj[1,2]+003 	SAY 	oTot6 	PROMPT "Transp" 		SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+195, aPosObj[1,2]+030 	MSGET	oTot6 	VAR 	cTransp 		SIZE 150, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

@ aPosObj[1,1]+195, aPosObj[1,2]+205 	SAY 	oTot7 	PROMPT "Redesp" 		SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+195, aPosObj[1,2]+235 	MSGET	oTot7 	VAR 	cRedesp 		SIZE 150, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

@ aPosObj[1,1]+209, aPosObj[1,2]+003 	SAY 	oTot8 	PROMPT "Cliente" 		SIZE 084, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+209, aPosObj[1,2]+030 	MSGET	oTot8 	VAR 	cNReduz 		SIZE 150, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

@ aPosObj[1,1]+209, aPosObj[1,2]+205 	SAY 	oTot9 	PROMPT "Município"  	SIZE 024, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+209, aPosObj[1,2]+235 	MSGET	oTot9 	VAR 	cMun			SIZE 150, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

@ aPosObj[1,1]+209, aPosObj[1,2]+387 	SAY 	oTotA 	PROMPT "UF"   	   		SIZE 010, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+209, aPosObj[1,2]+399 	MSGET	oTotA 	VAR 	cEst 			SIZE 010, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

@ aPosObj[1,1]+209, aPosObj[1,2]+417 	SAY 	oTotB 	PROMPT "Fone"   		SIZE 020, 007 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+209, aPosObj[1,2]+439	MSGET	oTotB 	VAR 	cTel 			SIZE 050, 010 OF oFolder1:aDialogs[2] COLORS 0, 16777215 PIXEL When .F.  

U_ColsPed(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)

RestArea(_aArea)

Return                                                                     


/////////////////////////////////////////////////////////
//	Cria Header
/////////////////////////////////////////////////////////

Static Function HdPed()

Local nRedesp	:= ""
Local nTel   	:= ""
Local nPosCli	:= ""
Local nPosMun	:= ""
Local nPosTra	:= ""
 
aHeaderPed 	:= {}
aCpoHeader  := {"UA_FILIAL","UA_NUM","UA_EMISSAO","UA__PRVFAT","UA__STATUS","UA_VEND","UA_TMK","UA__RESEST","UA_VLRLIQ","UA_VLRLIQ","UA_FRETE","UA_VALBRUT"/*,"A4_NREDUZ","UA__REDESP","A1_NREDUZ","A1_MUN","A1_EST","A1_DDD","A1_TEL"*/} 
aCpoTitulo	:= {"Fil","Pedido","Dt.Pedido","Dt.Pev.Fat","Sit","Rp","Op","Est","Vlr. Peça","Vlr. Pneu","Frete","Valor Pedido"/*,"Transp","Redesp","Cliente","Mun","UF","DDD","Tel"*/ }

For nElemPed 	:= 1 To Len(aCpoHeader)
	_cCpoHead 	:= aCpoHeader[nElemPed]
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	If DbSeek(_cCpoHead)
		AAdd(aHeaderPed, {aCpoTitulo[nElemPed],;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
	Endif
Next nElemPed

dbSelectArea("SX3")
dbSetOrder(1)

Return Nil

/////////////////////////////////////////////////////////
//	CRIA ACOLS
/////////////////////////////////////////////////////////

User Function ColsPed(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)	//U_ColsPed("0 ","20140101","20141231","01","","")

Local TRBSUA	:= ""
Local _cQuery	:= ""
Local nQtdCpo  	:= 0
Local nCols     := 0
Local nPosFil	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_FILIAL" })
Local nPosPed	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_NUM" })
Local nPosEmis  := ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_EMISSAO" })
Local nPosPreFa := ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA__PRVFAT" })
Local nPosSit   := ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA__STATUS" })
Local nPosRep	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_VEND" })
Local nPosOper  := ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_TMK" })
Local nPosReses	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA__RESEST" })
Local nPosVlPec	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_VLRLIQ" })
Local nPosVlPne := ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_VLRLIQ" })+1
Local nPosVlFre	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_FRETE" })
Local nPosVlPed	:= ASCAN(aHeaderPed, { |x| AllTrim(x[2]) == "UA_VALBRUT" })
Local nQuant 	:= 0
Local nPeca		:= 0
Local nPneu		:= 0
Local nTotPec	:= 0
Local nFrete	:= 0

oGetPD1:aCols := {}

nQtdCpo := Len(aHeaderPed)
nn:=0

If(select("TRBSUA") > 0)
	TRBSUA->(DbCloseArea())
EndIf

_cQuery := "SELECT DISTINCT UA_FILIAL, UA_NUM, UA_EMISSAO, UA__PRVFAT, UA__STATUS, UA_VEND, UA_TMK, UA__RESEST, A1_NREDUZ, A1_MUN, A1_EST, A1_DDD, A1_TEL, "           + CHR(10) + CHR(13)
_cQuery += "SUM(CASE WHEN SB1.B1_TIPO = 'PC'                       THEN SUB.UB_VLRITEM END) AS PECA, "          + CHR(10) + CHR(13)
_cQuery += "SUM(CASE WHEN SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA' THEN SUB.UB_VLRITEM END) AS PNEU, "          + CHR(10) + CHR(13)
_cQuery += "UA_FRETE, " + Chr(13)
_cQuery += "SUM(SUB.UB_VLRITEM) AS UA_VALBRUT, " + Chr(13)
_cQuery += "SA4.A4_NREDUZ TRANSP, SA4A.A4_NREDUZ REDESP "            + CHR(10) + CHR(13) 
_cQuery += "FROM " + RetSqlName("SUA") + " SUA "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SZM") + " SZM ON ZM_COD = UA__STATUS AND SZM.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SUB") + " SUB ON UA_NUM = UB_NUM AND UA_FILIAL = UB_FILIAL AND SUB.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = UB_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SZF") + " SZF ON ZF_COD = UA__TIPPED AND SZF.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = UA_CLIENTE AND A1_LOJA = UA_LOJA AND SA1.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "INNER JOIN " + RetSqlName("SA4") + " SA4 ON A4_COD = UA_TRANSP AND SA4.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
_cQuery += "LEFT  JOIN " + RetSqlName("SA4") + " SA4A ON UA__REDESP = SA4A.A4_COD "          + CHR(10) + CHR(13)

If (cFat == '1')
	_cQuery += "INNER JOIN " + RetSQLName("SC6") + " SC6 ON SC6.C6_FILIAL = SUB.UB_FILIAL " + CHR(13)
	_cQuery += "                         AND SC6.C6_NUM = SUB.UB_NUMPV                    " + CHR(13)
	_cQuery += "                         AND SC6.C6_ITEM = SUB.UB_ITEMPV                  " + CHR(13)
	_cQuery += "                         AND SC6.C6_PRODUTO = SUB.UB_PRODUTO              " + CHR(13)
	_cQuery += "                         AND SC6.D_E_L_E_T_ = ' '                         " + CHR(13)
	_cQuery += "INNER JOIN " + RetSQLName("SD2") + " SD2 ON SD2.D2_FILIAL = SC6.C6_FILIAL " + CHR(13)
	_cQuery += "                         AND SD2.D2_DOC = SC6.C6_NOTA                     " + CHR(13)
	_cQuery += "                         AND SD2.D2_SERIE = SC6.C6_SERIE                  " + CHR(13)
	_cQuery += "                         AND SD2.D2_CLIENTE = SC6.C6_CLI                  " + CHR(13)
	_cQuery += "                         AND SD2.D2_LOJA = SC6.C6_LOJA                    " + CHR(13)
	_cQuery += "                         AND SD2.D2_COD = SC6.C6_PRODUTO                  " + CHR(13)
	_cQuery += "                         AND SD2.D2_ITEMPV = SC6.C6_ITEM                  " + CHR(13)
	_cQuery += "                         AND SD2.D_E_L_E_T_ = ' '                         " + CHR(13)
	

/*    _cQuery += "INNER JOIN " + RetSQLName("SD2") + " SD2 ON D2_FILIAL = UA_FILIAL And D2_CLIENTE = UA_CLIENTE And D2_LOJA = UA_LOJA    " 
    _cQuery += "                         AND D2_PEDIDO = UA_NUMSC5                        " 
    _cQuery += "                         AND SD2.D_E_L_E_T_ = ' '                         " 
    
    _cQuery += "INNER JOIN " + RetSQLName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL " 
    _cQuery += "                         AND SF2.F2_DOC = SD2.D2_DOC                      " 
    _cQuery += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                  " 
    _cQuery += "                         AND SF2.F2_TIPO  = SD2.D2_TIPO                   " 
    _cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                         " */ 
EndIf

If(cFat == '2')
	_cQuery += "WHERE SUA.UA__PRVFAT BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "' "          + CHR(10) + CHR(13)
Else
	_cQuery += "WHERE SD2.D2_EMISSAO = '" + DTOS(Date()) + "' "          + CHR(10) + CHR(13)
EndIf
//_cQuery += "AND SUA.UA__STATUS NOT IN ('10','11') "      + CHR(10) + CHR(13)
_cQuery += "      AND TRIM(SUA.UA__TIPPED) NOT IN ('4','3') " + CHR(13)
_cQuery += " AND SUA.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)

If !Empty(cSit)
	_cQuery += "AND SUA.UA__STATUS = '" + cSit + "' "          + CHR(10) + CHR(13)
EndIf
If !Empty(cSeg)
	if (Alltrim(cSeg) <> "0")
		_cQuery += "AND SUA.UA__SEGISP = '" + cSeg + "' "          + CHR(10) + CHR(13)
	endif
EndIf
If !Empty(cLocal)
	_cQuery += "AND SUA.UA_FILIAL = '" + cLocal + "' "          + CHR(10) + CHR(13)
EndIf
If !Empty(cTip)
	_cQuery += "AND SUA.UA__TIPPED = '" + cTip + "' "        + CHR(10) + CHR(13)
EndIf
_cQuery += "GROUP BY UA_FILIAL, UA_NUM, UA_EMISSAO, UA__PRVFAT, UA__STATUS, UA_VEND, UA_TMK, UA__RESEST, A1_NREDUZ, A1_MUN, A1_EST, A1_DDD, A1_TEL, "         + CHR(10) + CHR(13)
_cQuery += "UA_FRETE, UA_VALBRUT, SA4.A4_NREDUZ, SA4A.A4_NREDUZ "          + CHR(10) + CHR(13)
_cQuery += "ORDER BY UA_NUM "        + CHR(10) + CHR(13)

_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias "TRBSUA"

DbSelectArea("TRBSUA")
DbGoTop()

while !TRBSUA->(eof())
	AAdd(oGetPD1:aCols, Array(nQtdCpo+1))
	nn++
	                                                 
	oGetPD1:Acols[nn][nPosFil]		:= TRBSUA->UA_FILIAL
	oGetPD1:Acols[nn][nPosPed]		:= TRBSUA->UA_NUM
	oGetPD1:Acols[nn][nPosEmis] 	:= STOD(TRBSUA->UA_EMISSAO)
	oGetPD1:Acols[nn][nPosPreFa]  	:= STOD(TRBSUA->UA__PRVFAT)
	oGetPD1:Acols[nn][nPosSit]      := TRBSUA->UA__STATUS
	oGetPD1:Acols[nn][nPosRep]  	:= TRBSUA->UA_VEND
	oGetPD1:Acols[nn][nPosOper]     := TRBSUA->UA_TMK
	oGetPD1:Acols[nn][nPosReses]  	:= TRBSUA->UA__RESEST		
	oGetPD1:Acols[nn][nPosVlPec]  	:= TRBSUA->PECA
	oGetPD1:Acols[nn][nPosVlPne]    := TRBSUA->PNEU 		
	oGetPD1:Acols[nn][nPosVlFre]  	:= TRBSUA->UA_FRETE
	oGetPD1:Acols[nn][nPosVlPed]    := TRBSUA->UA_VALBRUT  	
				
	oGetPD1:Acols[nn][Len(aHeaderPed)+1]  := .F.

	nQuant 	+= 1 
	nPeca	+= TRBSUA->PECA
	nPneu	+= TRBSUA->PNEU
	nTotPec	+= TRBSUA->PNEU + TRBSUA->PECA + TRBSUA->UA_FRETE
	nFrete	+= TRBSUA->UA_FRETE

	TRBSUA->(DbSkip())
enddo

cTotP1 := nQuant
cTotP2 := nPeca
cTotP3 := nPneu
cTotP4 := nTotPec
cTotP5 := nFrete

oGetPD1:nat:=len(oGetPD1:Acols)
TRBSUA->(dbCloseArea())

U_Rodape()
oGetPD1:Refresh()

return



/////////////////////////////////////////////////////////
//	ATUALIZA TOTAIS
/////////////////////////////////////////////////////////


Static Function AtuTot(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)

Local lOk 		:= .T.
Local _cQuery	:= ""
Local TRSUB		:= {}
	cTotP1 := 0
	cTotP2 := 0
	cTotP3 := 0
	cTotP4 := 0
	cTotP5 := 0

	_cQuery := " SELECT  DISTINCT SZM.ZM_INDICE, SZM.ZM_DESC AS SITUACAO, COUNT(DISTINCT UB_NUM  ) AS NUM, "           + CHR(10) + CHR(13)
	_cQuery += " SUM(CASE WHEN SB1.B1_TIPO = 'PC'                       THEN SUB.UB_VLRITEM END) AS PECA, "        + CHR(10) + CHR(13)
	_cQuery += " SUM(CASE WHEN SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA' THEN SUB.UB_VLRITEM END) AS PNEU, "        + CHR(10) + CHR(13)
	_cQuery += " SUM(SUA.UA_FRETE) AS FRETE "        + CHR(10) + CHR(13)
	_cQuery += " FROM " + RetSqlName("SUA") + " SUA "        + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SZM") + " SZM ON ZM_COD = UA__STATUS AND SZM.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SUB") + " SUB ON UA_NUM = UB_NUM AND UA_FILIAL = UB_FILIAL AND SUB.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SB1") + " SB1 ON B1_COD = UB_PRODUTO AND SB1.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SZF") + " SZF ON ZF_COD = UA__TIPPED AND SZF.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SA1") + " SA1 ON A1_COD = UA_CLIENTE AND A1_LOJA = UA_LOJA AND SA1.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " INNER JOIN " + RetSqlName("SA4") + " SA4 ON A4_COD = UA_TRANSP AND SA4.D_E_L_E_T_ = ' ' "          + CHR(10) + CHR(13)
	_cQuery += " LEFT JOIN  " + RetSqlName("SA4") + " SA4A ON UA__REDESP = SA4A.A4_COD "          + CHR(10) + CHR(13)
	_cQuery += " WHERE SUA.D_E_L_E_T_ = ' ' "        + CHR(10) + CHR(13)
	_cQuery += " AND SUA.UA__PRVFAT BETWEEN '" + DtoS(dDataIni) + "' AND '" + DtoS(dDataFim) + "'"         + CHR(10) + CHR(13)
	_cQuery += "AND SUA.UA__STATUS NOT IN ('9','10','11') "      + CHR(10) + CHR(13)
	If !Empty(cSeg)
		if (cSeg <> "0")
			_cQuery += " AND SUA.UA__SEGISP = '" + cSeg + "' "            + CHR(10) + CHR(13)
		endif
	EndIf
	If !Empty(cLocal)
		_cQuery += " AND SUA.UA_FILIAL = '" + cLocal + "' "           + CHR(10) + CHR(13)
	EndIf
	If !Empty(cSit)
		_cQuery += " AND SUA.UA__STATUS = '" + cSit + "' "           + CHR(10) + CHR(13)
	EndIf
	If !Empty(cTip)
		_cQuery += " AND SUA.UA__TIPPED = '" + cTip + "' "           + CHR(10) + CHR(13)
	EndIf

	_cQuery += " GROUP BY SZM.ZM_INDICE, SZM.ZM_DESC "
	_cQuery += " ORDER BY SZM.ZM_INDICE "
 
_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias "TRBSUB"

DbSelectArea("TRBSUB")
DbGoTop()

while !eof()
	cTotP1 := TRBSUB->NUM
	cTotP2 := TRBSUB->PECA
	cTotP3 := TRBSUB->PNEU
	cTotP4 := TRBSUB->PNEU + TRBSUB->PECA + TRBSUB->FRETE
	cTotP5 := TRBSUB->FRETE
	DbSkip()                                   	
enddo

TRBSUB->(dbCloseArea())

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ITMKA25B  ºAutor  ³Microsiga           º Data ³  12/04/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VisPed(_cFil,_cNumPed)

Local _aArea 	:= GetArea()
Local cFilAtu   := SM0->M0_CODFIL

PRIVATE aRotina := {    { "STR0002"  ,"AxPesqui"        ,0,1 },;  // "Pesquisar"
                { "STR0007"  ,"TK271CallCenter" ,0,2 },;  // "Visualizar"
                { "STR0003"  ,"TK271CallCenter" ,0,3 },;  // "Incluir"
                { "STR0004  ","TK271CallCenter" ,0,4 },;  // "Alterar"
                { "STR0064"  ,"TK271Legenda"    ,0,2 },;  // "Legenda"
                { "STR0008"  ,"TK271Copia"      ,0,6 } }  // "Copiar"

cFilAnt := _cFil 

INCLUI 	:= .f.
ALTERA 	:= .f.
nOpc    := 2
	
dbSelectArea("SUA")
dbSetOrder(1)
If dbSeek(cFilAnt + _cNumPed)
	
    TK271CallCenter("SUA",SUA->(Recno()),nOpc)

EndIf                         

// Retorna Filial do sistema       
cFilAnt := cFilAtu          
//--------------------------------

RestArea(_aArea)

Return .T.



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³Rodape    ºAutor  ³Alexandre Caetano   º Data ³  02/Dez/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Mostra dados do pedido no rodapé                           º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Local ISAPA                                                º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function RODAPE()

if oGetPD1:nat > 0   
	_cFil		:= cLocal             
	_cNumPed	:= oGetPD1:aCols[oGetPD1:nat][2]
	
	dbSelectArea("SUA")
	dbSetOrder(1)
	If dbSeek(_cFil+_cNumPed)
	
		cTransp := posicione("SA4",1, xFilial("SA4") + SUA->UA_TRANSP                , "A4_NOME"  )
		cRedesp	:= posicione("SA4",1, xFilial("SA4") + SUA->UA__REDESP               , "A4_NOME"  )
		cNReduz := posicione("SA1",1, xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA, "A1_NREDUZ")
		cMun	:= posicione("SA1",1, xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA, "A1_MUN")
		cEst	:= posicione("SA1",1, xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA, "A1_EST")
		cDDD	:= posicione("SA1",1, xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA, "A1_DDD")
		cTEL	:= posicione("SA1",1, xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA, "A1_TEL")
	
	EndIf
	
	oTot6:Refresh()
	oTot7:Refresh()
	oTot8:Refresh()
	oTot9:Refresh()
	oTotA:Refresh()
	oTotB:Refresh()
Endif

Return .T.