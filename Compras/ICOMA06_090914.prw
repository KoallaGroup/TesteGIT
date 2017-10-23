#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#Include "TopConn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06 | Autor: |    Rogério Alves     | Data: |    Julho/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Acionado pelo ponto de entrada SF1100I para movimentação de        |
|            | valorização para os documentos de entrada                          |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06(cNota,cSerie,cProd,cItem,cArm,cUm,cForn,cLoja,cTes,nQuant,nVlUnit,nCusto,nValIcm,nValIpi,nValPis,nValCof,nValFre,nIcmInter)

Local aArea    	:= GetArea()
Local aAreaSM0	:= SM0->(GetArea())
Local cTmEnt	:= GetMv("MV__TMVAL")	//TES DE VALORIZAÇÃO
Local cDoc	    := ""
Local aItem		:= aCab := {}
Local nOpcAuto	:= 3 // Indica qual tipo de ação será tomada (Inclusão/Exclusão)
Local nCusto	:= 0
Local lTransf	:= .F.
Local lNcm		:= .F.
Local nMargem	:= 0
Local nAlInt	:= 0
Local nAlExt	:= 0
Local cNcm		:= ""
Local cGrTrib	:= ""
Local nConFrete	:= 0

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

dbSelectArea("SA2")
dbSetOrder(1)
If dbSeek(xFilial("SA2")+cForn+cLoja)
	cTipo	:= SA2->A2_TIPO
	cUf		:= SA2->A2_EST
	
	DbSelectArea("SM0")
	DbGoTop()
	
	While !EOf()
		IF Alltrim(SA2->A2_CGC) == Alltrim(SM0->M0_CGC)
			lTransf := .T.
			Exit
		ENDIF
		DbSkip()
	EndDo
	
	RestArea(aAreaSM0)
	
EndIf

dbSelectArea("SB1")
dbSetOrder(1)
If dbSeek(xFilial("SB1")+cProd)
	cNcm	:= SB1->B1_POSIPI
	cGrTrib	:= SB1->B1_GRTRIB
EndIf

dbSelectArea("SYD")
dbSetOrder(1)
If dbSeek(xFilial("SYD")+cNcm) //VERIFICAR CST
	IF SYD->YD__ICMSST == "1"
		lNcm := .T.
	EndIf
ENDIF

If !Empty(cGrTrib)
	dbSelectArea("SF7")
	dbSetOrder(1)
	If dbSeek(xFilial("SF7")+cGrTrib)
		While !EOf("SF7") .and. SF7->F7_GRTRIB == cGrTrib
			IF SF7->F7_EST == cUf
				nMargem := SF7->F7__MVA
			   //	nAlInt	:= SF7->F7_ALIQINT
				//nAlExt	:= SF7->F7_ALIQEXT
				Exit
			ENDIF
			DbSkip()
		EndDo
	EndIf
EndIf
  


nConFrete	:= U_ICOMA06B(cNota,cSerie,cForn,cItem)

If lTransf .and. lNcm	//Operação de Transferência
	nCusto := U_ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nAlInt,nAlExt,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja)
Elseif !(lTransf) .and. lNcm	//Operação de compra
	nCusto := U_ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nAlInt,nAlExt,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja)
EndIf

If nCusto != 0
	
	Begin Transaction
	
	cDoc	:= GetSxENum("SD3","D3_DOC",1)
	aCab 	:= {}
	aItem 	:= {}
	
	lMsErroAuto := .F.
	
	aCab := {	{"D3_DOC"    	, cDoc    	,  	Nil},;
				{"D3_TM"     	, cTmEnt    ,  	Nil},;
				{"D3_EMISSAO"	, dDataBase	,  	Nil}}
	
	aadd(aItem,{{"D3_TM"      	, cTmEnt    ,  	Nil},;
				{"D3_COD"      	, cProd     ,  	Nil},;
				{"D3_UM"        , cUm       ,  	Nil},;
				{"D3_QUANT"     , 0		    ,  	Nil},;
				{"D3_LOCAL"     , cArm		,  	Nil},;
				{"D3_EMISSAO"	, dDataBase	,  	NIL},;
				{"D3_CUSTO1"	, nCusto	,  	NIL},;
				{"D3__DOC"     	, cNota	    ,  	Nil},;
				{"D3__SERIE"    , cSerie	,  	Nil},;
				{"D3__FORNEC"  	, cForn	    ,  	Nil},;
				{"D3__LOJA"	    , cLoja		,  	Nil},;
				{"D3__ITEM"		, cItem		,  	NIL}})
	
	MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)
	
	If lMsErroAuto
		MostraErro()
		DisarmTransaction()
		Break
	EndIf
	
	End Transaction
	
EndIf

RestArea(aArea)

Return


/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06A| Autor: |    Rogério Alves     | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Calcula o ICMS de Substituição Tributária                          |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06A(cProd,nQuant,nMargem,nValFre,nVlUnit,lTransf,nAlInt,nAlExt,nIcmInter,cTes,nConFrete,cNota,cSerie,cForn,cLoja)

Local aArea    	:= GetArea()
Local cQUERY	:= ""
Local aSM0 		:= FWLoadSM0()
Local xTEMP		:= {}
Local aCGC		:= ""
Local cCusto	:= 0
Local nIcmMint	:= GETMV("MV_ICMPAD")//ALT INTERNA
//Local nValMint	:= 0
//Local nValInter	:= 0
Local cFundap	:= IIf(Posicione("SF4",1,xFilial("SF4")+cTes,"F4__FUNDAP")=="1",.T.,.F.)

For x:=1 to Len(aSM0)
	aCGC := aCGC + aSM0[x][18]
	If x != Len(aSM0)
		aCGC := aCGC + ","
	EndIf
Next

aCGC := FormatIn(aCGC,",")

cQUERY := "SELECT D1_COD COD, D1_QUANT QUANT, D1_VUNIT VLUNIT, D1_CUSTO/D1_QUANT CUSTO, D1_VALIPI/D1_QUANT IPI, D1_VALICM/D1_QUANT ICMS, "
cQUERY += "D1_VALIMP6/D1_QUANT PIS, D1_VALIMP5/D1_QUANT COFINS "
cQUERY += "FROM " + RetSqlName("SD1") + " SD1 "
cQuery += "INNER JOIN " + RetSqlName("SF4") + " SF4 ON F4_FILIAL = '" + xFilial("SF4") + "' AND F4_CODIGO = D1_TES AND SF4.D_E_L_E_T_ = ' '  "
cQuery += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON A2_FILIAL = '" + xFilial("SA2") + "' AND A2_COD = D1_FORNECE AND A2_LOJA = D1_LOJA AND SA2.D_E_L_E_T_ = ' '  "
cQUERY += "WHERE D1_TIPO = 'N' "
cQUERY += "AND SD1.D_E_L_E_T_ = ' ' "
cQUERY += "AND D1_FILIAL = '" + xFilial("SD1") + "' "  // FILIAL ORIGEM
cQUERY += "AND D1_COD = '" + cProd + "' "
cQUERY += "AND F4_DUPLIC = 'S' "
cQUERY += "AND F4_ESTOQUE = 'S' "
cQUERY += "AND F4_ATUATF <> 'S' "
cQUERY += "AND F4_PODER3 = 'N' "
cQUERY += "AND A2_CGC NOT IN " +aCGC+ " "

cQUERY += "AND (D1_DOC <> '" +cNota+ "' "
cQUERY += "OR  D1_SERIE <> '" +cSerie+ "' "
cQUERY += "OR  D1_FORNECE <> '" +cForn+ "' "
cQUERY += "OR  D1_LOJA <> '" +cLoja+ "') "

cQUERY += "ORDER BY D1_EMISSAO DESC "

If Select("xTEMP") > 0
	xTEMP->(dbCloseArea())
EndIf

cQUERY := ChangeQuery(cQUERY)

TcQuery cQUERY New Alias "xTEMP"

cQUERY	:= ""

dbSelectArea("xTEMP")
dbGoTop()


If lTransf


cCusto := xTEMP->IPI + xTEMP->ICMS + xTEMP->PIS + xTEMP->COFINS

	//Transferência de produto com substituição Tributária

nValFTOTAL := NVALFRE/xTEMP->QUANT +   	nConFrete/xTEMP->QUANT 
			
XXX := ((nValFTOTAL * nQuant) + nQuant*nVlUnit  + cCusto)      
YYY := XXX * (MVA/100)
CUSTO = XXX+YYY

		   //	cCusto := ((nValFTOTAL * nQuant) + nVlUnit  + cCusto) * nMargem
                                                
Else

	//Compra de produtos
	XXX :=  nQuant*nVlUnit
	YYY 	:=  ((nQuant * nVlUnit) * (nMargem/100)))
CUSTO = XXX+YYY

	
EndIf
     

INTRA=CUSTO * (nIcmMint/100)  //INTERNA

INTER=(nQuant * nVlUnit) * (ALIQINTERESTADUAL/100)

VL AJUSTE == INTRA- INTER

	//	If cFundap
	VL AJUSTE  + INTER
	//	EndIf
	
RestArea(aArea)

Return(cCusto)


/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ICOMA06B| Autor: |    Rogério Alves     | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Busca o valor do Frete do Conhecimento                             |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ICOMA06B(cNota,cSerie,cForn,cItem)

Local cQuery 	:= ""
Local TMPSD1	:= {}

cQuery := "SELECT SUM(D1_TOTAL) VALFRETE, SUM(D1_VALICM) ICMFRETE "
cQuery += "FROM " + retSqlname("SD1") + " SD1 "
cQuery += "WHERE D1__NFORIG = '" + cNota  + "' "
cQuery += "AND D1__SERORI = '" + cSerie  + "' "
cQuery += "AND D1__FORORI = '" + cForn  + "' "
cQuery += "AND D1__ITEMOR = '" + cItem + "' "
cQuery += "AND D1_FILIAL = '" + xFilial("SD1") + "' "
cQuery += "AND D1_TIPO = 'C' "
cQuery += "AND SD1.D_E_L_E_T_ = ' ' "

If(select("TMPSD1") > 0)
	TMPSD1->(dbCloseArea())
endif

TCQUERY cQuery NEW ALIAS "TMPSD1"

dbSelectArea("TMPSD1")
dbGoTop()

Return(TMPSD1->VALFRETE)
