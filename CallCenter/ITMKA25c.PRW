#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKA25C| Autor: |Alexandre Caetano     | Data: |  Novembro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descrição: | Pedido na data de previsão de Faturamento por status (ITMKA25c)    |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKA25C(PSeg,PDataIni,PDataFim,PLocal,PSit,PTip)

Local _aArea 		:= GetArea()
Local oTot
Local oTot1
Local oTot2
Local oTot3
Local oTot4
Local oTot5

Private aHeaderPed	:= {}
Private aColsC      := {}
Private oDlgTMP     := Nil
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {}
Private oFont14     := tFont():New("Tahoma",,-11,,.t.)
Private lRet		:= .F.
Private aButtons 		:= {}


HdPed()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj  := MsObjSize( ainfo, aObjects )       


oGetNF := MsNewGetDados():New(aPosObj[1,1]+5, aPosObj[1,2]+3, aPosObj[1,1]+147, aPosObj[1,4]-10,, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oFolder1:aDialogs[3], aHeaderPed, aColsC)

@ aPosObj[1,1]+150, aPosObj[1,2]+003  	GROUP	oTotais TO aPosObj[1,1]+187, aPosObj[1,4]-100 PROMPT "Totais"	OF oFolder1:aDialogs[3] COLOR 0, 16777215 PIXEL

@ aPosObj[1,1]+157, aPosObj[1,2]+006 	SAY 	oTot1 	PROMPT "Quantidade" 	SIZE 084, 007 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+006 	MSGET 	oTot1 	VAR 	cTotN1 		Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+075 	SAY	 	oTot2 	PROMPT 	"Total Peça" 	SIZE 084, 007 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+075 	MSGET 	oTot2 	VAR 	cTotN2 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+140 	SAY 	oTot3 	PROMPT 	"Total Pneu" 	SIZE 084, 007 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+140 	MSGET 	oTot3 	VAR 	cTotN3 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+205 	SAY 	oTot5 	PROMPT 	"Total Frete" 	SIZE 084, 007 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+205 	MSGET 	oTot5 	VAR 	cTotN5 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+270 	SAY 	oTot4 	PROMPT 	"Total Pedidos" SIZE 084, 007 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+270 	MSGET	oTot4 	VAR 	cTotN4 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[3] COLORS 0, 16777215 PIXEL When .F.  
                                   	
@ aPosObj[1,1]+153,aPosObj[1,4]-90 Button oButton PROMPT "Visualizar" 			SIZE 80,16    OF oFolder1:aDialogs[3] PIXEL ACTION (Processa({|| CursorWait(),VISNF(),CursorArrow()},"Gerando visualizacao, aguarde..."))    
@ aPosObj[1,1]+171,aPosObj[1,4]-90 Button oButton PROMPT "Imprimir NF" 			SIZE 80,16    OF oFolder1:aDialogs[3] PIXEL ACTION ( ImpDanfe() )    
	
U_ColsNF(PSeg,Pdataini,PDataFim,PLocal,PSit,PTip)			

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
aCpoHeader  := {"F2_FILIAL", "F2_DOC"   , "F2_SERIE", "F2_EMISSAO" , "F2_CLIENTE" , "A1_NOME", "F2_LOJA", "UA_NUM", "A1__PRZMED"}
aCpoTitulo	:= {"Local"    , "N. Fiscal", "Série"   , "Dt. Emissao", "Cod.Cliente", "Cliente", "Loja"   , "Pedido", "Seq."      }

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

User Function ColsNF(PSeg,PDataIni,PDataFim,PLocal,PSit,PTip)	//U_ColsPed("0 ","20140101","20141231","01","","")
Local cQry 		:= ""
Local aColsNF 	:= {}
	
oGetNF:aCols 	:= {}

If(select("TRBSUA") > 0)
	TRBSUA->(DbCloseArea())
EndIf

cQry := " SELECT DISTINCT F2_FILIAL, F2_DOC, F2_SERIE, F2_EMISSAO, F2_CLIENTE, A1_NOME, F2_LOJA, UA_NUM "
cQry += " FROM SUA010 SUA "
cQry += " INNER JOIN " + RetSQLName("SD2") + " SD2 ON D2_FILIAL = UA_FILIAL AND D2_PEDIDO = UA_NUMSC5 And D2_CLIENTE = UA_CLIENTE " 
cQry += "                         AND D2_LOJA = UA_LOJA And SD2.D_E_L_E_T_ = ' '                         " 
cQry += " INNER JOIN " + RetSQLName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL" 
cQry += "                         AND SF2.F2_DOC = SD2.D2_DOC                      " 
cQry += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                  " 
cQry += "                         AND SF2.F2_TIPO  = SD2.D2_TIPO                   " 
cQry += "                         AND SF2.D_E_L_E_T_ = ' '                         " 
cQry += " Inner JOIN " + RetSqlName("SC5") + " SC5 ON (SUA.UA_FILIAL  = SC5.C5_FILIAL AND SUA.UA_NUMSC5 = SC5.C5_NUM)   "
cQry += " Inner JOIN " + RetSqlName("SA1") + " SA1 ON SF2.F2_CLIENTE = SA1.A1_COD And SF2.F2_LOJA = SA1.A1_LOJA  "
cQry += " WHERE SUA.D_E_L_E_T_ = ' ' "                                      
cQry += " AND   SC5.D_E_L_E_T_ = ' ' "       
cQry += " AND   SA1.D_E_L_E_T_ = ' ' "           
cQry += " AND   SF2.F2_EMISSAO = '" + DTOS(Date()) + "' "

If !Empty(PSeg)
	if (Alltrim(PSeg) <> "0")
		cQry += "AND SUA.UA__SEGISP = '" + PSeg + "' "
	endif
EndIf
If !Empty(PLocal)
	cQry += "AND SUA.UA_FILIAL = '" + PLocal + "' "
EndIf
If !Empty(PSit)
	cQry += "AND SUA.UA__STATUS = '" + PSit + "' "
EndIf
If !Empty(PTip)
	cQry += "AND SUA.UA__TIPPED = '" + PTip + "' "
EndIf             


cQry += "ORDER BY UA_NUM "
                                                                                           	
cQry := ChangeQuery(cQry)

TcQuery cQry New Alias "TRBSUA"

DbSelectArea("TRBSUA")
DbGoTop()
         
aColsNf := {}
nSeq    := 0
nNfAnt  := ""  
nSrAnt	:= ""
 
while !TRBSUA->(eof())

 	if nNfAnt == TRBSUA->F2_DOC .and. nSrAnt == TRBSUA->F2_SERIE
 		nSeq ++
 	Else                                                        
	 	nNfAnt  := TRBSUA->F2_DOC 
	 	nSrAnt  := TRBSUA->F2_SERIE
 	Endif
	 	nSeq++
 	
	aAdd( aColsNf, {TRBSUA->F2_FILIAL, TRBSUA->F2_DOC, TRBSUA->F2_SERIE, StoD(TRBSUA->F2_EMISSAO), TRBSUA->F2_CLIENTE, TRBSUA->A1_NOME, TRBSUA->F2_LOJA, TRBSUA->UA_NUM, nSeq, .F.} )

	
	TRBSUA->(DbSkip())
enddo
         
oGetNF:ACols := aColsNF
oGetNF:nat:=len(oGetNF:Acols)
TRBSUA->(dbCloseArea())

AtuTot(PSeg,dDataIni,PDataFim,PLocal,PSit,PTip)
oGetNF:Refresh()

return

/////////////////////////////////////////////////////////
//	ATUALIZA TOTAIS
/////////////////////////////////////////////////////////


Static Function AtuTot(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)

Local lOk 		:= .T.
Local _cQuery	:= ""
Local TRSUB		:= {}
	cTotN1 := 0
	cTotN2 := 0
	cTotN3 := 0
	cTotN4 := 0
	cTotN5 := 0
	
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
    _cQuery += " INNER JOIN " + RetSQLName("SD2") + " SD2 ON D2_FILIAL = UA_FILIAL And D2_CLIENTE = UA_CLIENTE And D2_LOJA = UA_LOJA        " 
    _cQuery += "                         AND D2_PEDIDO = UA_NUMSC5                        " 
    _cQuery += "                         AND SD2.D_E_L_E_T_ = ' '                         " 
    _cQuery += " INNER JOIN " + RetSQLName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL" 
    _cQuery += "                         AND SF2.F2_DOC = SD2.D2_DOC                      " 
    _cQuery += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                  " 
    _cQuery += "                         AND SF2.F2_TIPO  = SD2.D2_TIPO                   " 
    _cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                         " 

	_cQuery += " WHERE SUA.D_E_L_E_T_ = ' ' "        + CHR(10) + CHR(13)
	_cQuery += " AND SF2.F2_EMISSAO = '" + DTOS(Date()) + "'"         + CHR(10) + CHR(13)
//	_cQuery += " AND SUA.UA__STATUS IN ('9','10','11') "      + CHR(10) + CHR(13)

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

	_cQuery += " GROUP BY SZM.ZM_INDICE, SZM.ZM_DESC " + CHR(10) + CHR(13)
	_cQuery += " ORDER BY SZM.ZM_INDICE "

//    cTexto   := _cQuery
//    cArquivo := "D:\NF-TOTAIS.TXT"
//    MEMOWRITE(cArquivo , cTexto)	

_cQuery := ChangeQuery(_cQuery)

TcQuery _cQuery New Alias "TRBSUB"

DbSelectArea("TRBSUB")
DbGoTop()

while !eof()
	cTotN1 := TRBSUB->NUM
	cTotN2 := TRBSUB->PECA
	cTotN3 := TRBSUB->PNEU
	cTotN4 := TRBSUB->PNEU + TRBSUB->PECA + TRBSUB->FRETE
	cTotN5 := TRBSUB->FRETE
	DbSkip()                                   	
enddo

oFolder1:aDialogs[3]:Refresh()
TRBSUB->(dbCloseArea())

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³VisNf     ºAutor  ³Microsiga           º Data ³  25/Nov/2014º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Exclusivo ISAPA                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function VisNf()

Local _aArea 	:= GetArea()
Local cDocF2	:= oGetNF:aCols[oGetNF:nat,2]
Local cSerF2	:= oGetNF:aCols[oGetNF:nat,3]  
Local cCliF2	:= oGetNF:aCols[oGetNF:nat,5]  
Local cLojF2	:= oGetNF:aCols[oGetNF:nat,7]  
Local _nOpc		:= 2
// Altera a Filial do sistema para a filial do registro selecionado
Local cFilAtu   := SM0->M0_CODFIL
cFilAnt := oGetNF:aCols[oGetNF:nat,1]                     
//------------------------------------------------------------------


//PRIVATE aRotina     := {{"","",0,1},{"Visualizar"   , "Mc090VISUAL" , 0, 2 }}
Private aRotina := {    { "STR0001","AxPesqui"    ,0,1,0,.F.},;      	// "Pesquisar"
                        { "STR0002","MC090Visual" ,0,2,0,NIL},;       		// "Visualizar"
                        { "STR0003","MC090Legend" ,0,5,0,NIL} }      		// "Legenda"
	
dbSelectArea("SF2")
dbSetOrder(1)            
If dbSeek(cFilAnt + cDocF2 + cSerF2 + cCliF2 + cLojF2) 
	Mc090VISUAL("SF2", SF2->(Recno()), 0)
EndIf

// Retorna Filial do sistema       
cFilAnt := cFilAtu          
//--------------------------------

RestArea(_aArea)
       
Return .T.      

/*
+------------+----------+--------+----------------------+-------+------------------+
| Programa:  | ImpDanfe | Autor: |Rubens Cruz			| Data: |  Dezembro/2014   |
+------------+----------+--------+----------------------+-------+------------------+
| Descrição: | Chamada para rotina de impressão de DANFE customizada			   |
+------------+---------------------------------------------------------------------+
| Uso:       | ISAPA                                                               |
+------------+---------------------------------------------------------------------+
*/

Static Function ImpDanfe()            
Local _nPosFil	:= ASCAN(oGetNF:aHeader, { |x| AllTrim(x[2]) == "F2_FILIAL" })
Local _nPosDoc	:= ASCAN(oGetNF:aHeader, { |x| AllTrim(x[2]) == "F2_DOC" })
Local _nPosSer	:= ASCAN(oGetNF:aHeader, { |x| AllTrim(x[2]) == "F2_SERIE" })
Local _nPosCli	:= ASCAN(oGetNF:aHeader, { |x| AllTrim(x[2]) == "F2_CLIENTE" })
Local _nPosLoj	:= ASCAN(oGetNF:aHeader, { |x| AllTrim(x[2]) == "F2_LOJA" })
Local _nLinha	:= oGetNF:nAt

U_IFATP01(oGetNF:aCols[_nLinha][_nPosFil],;
			oGetNF:aCols[_nLinha][_nPosDoc],;
			oGetNF:aCols[_nLinha][_nPosSer],;
			oGetNF:aCols[_nLinha][_nPosCli],;
			oGetNF:aCols[_nLinha][_nPosLoj])

Return