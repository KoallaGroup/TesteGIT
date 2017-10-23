#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
+------------+---------+--------+----------------------+-------+------------------+
| Programa:  | ITMKA25 | Autor: |    Paulo Ferraz      | Data: |   Agosto/2014    |
+------------+---------+--------+----------------------+-------+------------------+
| Alterado:  |         |        |    Rog้rio Alves     | Data: |  Setembro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
|			 |		   |		|	   Rubens Cruz	   | Data: |  Dezembro/2014   |
+------------+---------+--------+----------------------+-------+------------------+
| Descri็ใo: | Tela de pesquisa de data de previsใo de Faturamento por status     |
+------------+--------------------------------------------------------------------+
| Uso:       | ISAPA                                                              |
+------------+--------------------------------------------------------------------+
*/

User Function ITMKA25()    // U_ITMKA25() 

Local aCampos  		:= {}
Local aAreaATU 		:= GetArea()
Local aButtons 		:= {}
Local oComboBo1
Local oGet1
Local cGet1 		:= ""
Local oGet3
Local cGet3 		:= ""
Local oGet4
Local oGet5

Local oGet7
Local cGet7 		:= ""
Local oGet8
Local oGet9
Local cGet9 		:= ""
Local oGet10
Local cGet10 		:= ""
Local oSay1
Local oSay2
Local oSay3
Local oSay4
Local oSay5
Local oSay6
Local oSay7
Local oTotais
Local oTot1
Local oTot2
Local oTot3
Local oTot4
Local oTot5
Local cSituacao	:= ""

Private cSegesc     := space(TAMSX3("B1_DESC")[1])
Private nQtde       := 0
Private nDesc       := 0
Private aHeaderB	:= {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oGetPD1     := Nil
Private oGetNF      := Nil
Private oDlgTMP     := Nil
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {}
Private aRotina     := .F.
Private oFont14     := tFont():New("Tahoma",,-11,,.t.)

Private cSeg 		:= ""

Private oGet6
private cGet6		:= " "
private oGet2
private cGet2		:= " "
private cGet8 		:= ""
private cGet4 		:= ""

private oTotal1
private cTotal1	 	:= ""
private oTotal2
private cTotal2 	:= ""
private oTotal3
private cTotal3 	:= ""
private oTotal4
private cTotal4 	:= ""
private oTotal5
private cTotal5 	:= ""
private oTotal6
private cTotal6 	:= ""

private oTotaln1
private cTotaln1	:= ""
private oTotaln2
private cTotaln2 	:= ""
private oTotaln3
private cTotaln3 	:= ""
private oTotaln4
private cTotaln4 	:= ""
private oTotaln5
private cTotaln5 	:= ""
private oTotaln6
private cTotaln6 	:= ""
Private oDtatual

Private oTot6,oTot7,oTot8,oTot9,oTotA,oTotB

Private cTotP1 		:= ""
Private cTotP2 		:= ""
Private cTotP3 		:= ""
Private cTotP4 		:= ""
Private cTotP5 		:= ""

Private cTotN1 		:= ""
Private cTotN2 		:= ""
Private cTotN3 		:= ""
Private cTotN4 		:= ""
Private cTotN5 		:= ""

private cTransp		:= ""
private cRedesp		:= ""
Private cNReduz 	:= ""
Private	cMun		:= ""
Private	cEst 		:= ""
Private	cTel    	:= ""

Private dDataIni 	:= ctod(Str(day(date()),2) + "/" + Str(month(date()),2) + "/" + Str((year(date())-1),4))
Private dDataFim 	:= ctod(Str(day(date()),2) + "/" + Str(month(date()),2) + "/" + Str((year(date())+1),4))
Private cSeg    	:= space(TAMSX3("Z7_CODIGO")[1])
Private cLocal		:= space(TAMSX3("UA__FILIAL")[1])
Private cSit    	:= space(TAMSX3("ZM_COD")[1])
Private cTip    	:= space(TAMSX3("ZF_COD")[1])

Private INCLUI		:= .F.
Private	ALTERA		:= .F.

CriaHeader()

aObjects := {}
AAdd( aObjects, { 100, 100, .t., .t. } )
aInfo    := { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj  := MsObjSize( ainfo, aObjects )


DEFINE MSDIALOG oDlgTMP TITLE "Consulta Pedidos por Dt. Prev. de Faturamento" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL	//Tela cheia
oDlgTMP:lMaximized := .t.

@ aSize[7]+40, 005 FOLDER oFolder1 SIZE aSize[4]+375,aSize[4]-30 OF oDlgTMP ITEMS "Situa็ใo","Pedidos","Notas Fiscais" COLORS 0, 16777215 PIXEL

oFolder1:bChange := {|| FltrDds( oGetTM1:aCols[oGetTM1:nat,1] ) }
oFolder1:aDialogs[2]:lActive := .f.
oFolder1:aDialogs[3]:lActive := .f.

@ aPosObj[1,1]+12, aPosObj[1,2]+008 SAY oSay1 PROMPT "Local" 					SIZE 084, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+026 MSGET oGet1 VAR cLocal						SIZE 020, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL F3 "XM0" VALID BuscaLocal(cLocal)
@ aPosObj[1,1]+10, aPosObj[1,2]+049 MSGET oGet2 VAR cGet2						SIZE 060, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+12, aPosObj[1,2]+113 SAY oSay3 PROMPT "Segmento"		  		 	SIZE 084, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+140 MSGET oGet5 VAR cSeg						SIZE 020, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL F3 "SZ72" VALID BuscaSeg(cSeg)
@ aPosObj[1,1]+10, aPosObj[1,2]+163 MSGET oGet6 VAR cGet6						SIZE 030, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+12, aPosObj[1,2]+198 SAY oSay4 PROMPT "Situa็ใo" 				SIZE 084, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+225 MSGET oGet7 VAR cSit						SIZE 020, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL F3 "SZM" VALID BuscaSit(cSit)
@ aPosObj[1,1]+10, aPosObj[1,2]+255 MSGET oGet8 VAR cGet8						SIZE 060, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+12, aPosObj[1,2]+320 SAY oSay5 PROMPT "Tipo Pedido" 				SIZE 084, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+352 MSGET oGet3 VAR cTip						SIZE 020, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL F3 "SZF" VALID BuscaTipo(cTip)
@ aPosObj[1,1]+10, aPosObj[1,2]+390 MSGET oGet4 VAR cGet4						SIZE 045, 010 OF oDlgTMP COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+12, aPosObj[1,2]+440 SAY oSay5 PROMPT "Periodo de" 				SIZE 084, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+470 MSGET oGet9 VAR  dDataIni 	PICTURE "@D" 	SIZE 040, 010 OF oDlgTMP PIXEL //HASBUTTON

@ aPosObj[1,1]+12, aPosObj[1,2]+512 SAY oSay5 PROMPT "de"  						SIZE 010, 007 OF oDlgTMP COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+10, aPosObj[1,2]+522 MSGET oGet10 VAR dDataFim 	PICTURE "@D" 	SIZE 040, 010 OF oDlgTMP PIXEL //HASBUTTON

@ aPosObj[1,1]+10,aPosObj[1,2]+565 Button oButton PROMPT "Processar" 			SIZE 035, 012 OF oDlgTMP  	PIXEL ACTION CriaCols(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)
@ aPosObj[1,1]+24,aPosObj[1,2]+565 Button oButton PROMPT "Fechar"  				SIZE 035 ,012 OF oDlgTMP  	PIXEL ACTION oDlgTMP:End()

//Folder[1] - ACSJ - 18-Nov
oGetTM1 := MsNewGetDados():New(aPosObj[1,1]+5, aPosObj[1,2]+3, aPosObj[1,1]+147, aPosObj[1,4]-10 ,, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oFolder1:aDialogs[1], aHeaderB, aColsB)
oGetTM1:bChange := {|| U_CtrlAba() }

@ aPosObj[1,1]+150, aPosObj[1,2]+003  	GROUP	oTotais TO aPosObj[1,1]+207, aPosObj[1,4]-10 PROMPT ""	 	      OF oFolder1:aDialogs[1] COLOR 0, 16777215 PIXEL

@ aPosObj[1,1]+169, aPosObj[1,2]+010 	SAY 	oTot1 	PROMPT "TOTAIS" 		SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+189, aPosObj[1,2]+010 	SAY 	oTot1 	PROMPT "FATURAMENTO:"  	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+187, aPosObj[1,2]+056 	MSGET 	oDtatual VAR 	dtoc(date()) 	SIZE 040, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+110 	SAY 	oTot1 	PROMPT "Quantidade" 	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+110 	MSGET 	oTotal1 VAR 	cTotal1 		Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+110 	MSGET 	oTotaln1 VAR 	cTotaln1 		Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+175 	SAY 	oTot1 	PROMPT "Qtd. Itens" 	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+175 	MSGET 	oTotal6 VAR 	cTotal6 		Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+175 	MSGET 	oTotaln6 VAR 	cTotaln6 		Picture "@E 999,999,999" SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+240 	SAY	 	oTot2 	PROMPT 	"Total Pe็a" 	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+240 	MSGET 	oTotal2 VAR 	cTotal2 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+240 	MSGET 	oTotaln2 VAR 	cTotaln2 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+305 	SAY 	oTot3 	PROMPT 	"Total Pneu" 	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+305 	MSGET 	oTotal3 VAR 	cTotal3 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+305 	MSGET 	oTotaln3 VAR 	cTotaln3 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+370 	SAY 	oTot5 	PROMPT 	"Total Frete" 	SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+370 	MSGET 	oTotal5 VAR 	cTotal5 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+370 	MSGET 	oTotaln5 VAR 	cTotaln5 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

@ aPosObj[1,1]+157, aPosObj[1,2]+435 	SAY 	oTot4 	PROMPT 	"Total Pedidos" SIZE 084, 007 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL
@ aPosObj[1,1]+167, aPosObj[1,2]+435 	MSGET	oTotal4 VAR 	cTotal4 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.
@ aPosObj[1,1]+187, aPosObj[1,2]+435 	MSGET	oTotaln4 VAR 	cTotaln4 		Picture PesqPict("SF2","F2_VALBRUT") SIZE 060, 010 OF oFolder1:aDialogs[1] COLORS 0, 16777215 PIXEL When .F.

//cSituacao := (oGetTM1:aCols[oGetTM1:nat][4])
//oFolder1:bChange := {||U_ITMKA25B(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)}
//U_ITMKA25B(cSeg,dDataIni,dDataFim,cLocal,oGetTM1:aCols[oGetTM1:nat][1],cTip) // Pedidos

//U_ITMKA25B(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Pedidos
//U_ITMKA25C(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Notas

ACTIVATE MSDIALOG oDlgTMP CENTERED// ON INIT EnchoiceBar(oDlgTMP,{||CriaCols(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)},{||oDlgTMP:End()},,aButtons)

RestArea(aAreaATU)

Return


/////////////////////////////////////////////////////////
//	Cria Header
/////////////////////////////////////////////////////////


Static Function CriaHeader()

aHeaderB 	:= {}
aCpoHeader  := {"ZM_DESC","UB_QUANT","UB__QTDSOL" ,"UB_VALDESC","UB_VALACRE","UA_FRETE"	 ,"UB_VLRITEM" 	  }
aCpoTitulo	:= {"Status" ,"Qtde"	,"Qtde Itens","Valor Pe็a","Valor Pneu","Valor Frete","Valor Pedidos" }

For _nElemHead 	:= 1 To Len(aCpoHeader)
	_cCpoHead 	:= aCpoHeader[_nElemHead]
	
	dbSelectArea("SX3")
	dbSetOrder(2)
	
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {aCpoTitulo[_nElemHead],;
		SX3->X3_Campo       ,;
		IIF(aCpoHeader[_nElemHead] == "UB_QUANT","@E 999",SX3->X3_Picture)     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_Arquivo     ,;
		SX3->X3_Context})
	Endif
Next _nElemHead

dbSelectArea("SX3")
dbSetOrder(1)

Return Nil



/////////////////////////////////////////////////////////
//	CRIA ACOLS
/////////////////////////////////////////////////////////

Static Function CriaCols(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip)

Local nQtdCpo  	:= 0
Local nCols     := 0
Local nPosEmis  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "ZM_DESC" })
Local nPosNome  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_QUANT" })
Local nPosCli   := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VALDESC" })
Local nPosCli2  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VALACRE" })
Local nPosCli3  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA_FRETE" })
Local nPosCli4  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local nPosCli5  := ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__QTDSOL" })
Local nTotal1 	:= 0
Local nTotal2 	:= 0
Local nTotal3 	:= 0
Local nTotal4 	:= 0
Local nTotal5 	:= 0
Local nTotal6 	:= 0
Local nTotaln1 	:= 0
Local nTotaln2 	:= 0
Local nTotaln3 	:= 0
Local nTotaln4 	:= 0
Local nTotaln5 	:= 0
Local nTotaln6 	:= 0

if empty(cLocal)
	alert("Filial nใo preenchida")
	Return
endif

oFolder1:nOption := 1

oGetTM1:aCols := {}

nQtdCpo := Len(aHeaderB)
nn:=0

If(select("TRBSUB") > 0)
	TRBSUB->(DbCloseArea())
EndIf

If(select("TRBSUA") > 0)
	TRBSUA->(DbCloseArea())
EndIf

_cQuery := "SELECT DISTINCT SZM.ZM_INDICE,                                            " + CHR(13)
_cQuery += "       SZM.ZM_DESC AS SITUACAO,                                           " + CHR(13)
_cQuery += "       COUNT(DISTINCT UB_NUM  ) AS NUM,                                   " + CHR(13)
_cQuery += "       COUNT(UB_VLRITEM  ) AS QTDITENS,                              	  " + CHR(13)
_cQuery += "       NVL(SUM(CASE WHEN SB1.B1_TIPO = 'PC'                               " + CHR(13)
_cQuery += "					THEN SUB.UB_VLRITEM  END),0) AS PECA,                 " + CHR(13)
_cQuery += "       NVL(SUM(CASE WHEN SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA'         " + CHR(13)
_cQuery += "					THEN SUB.UB_VLRITEM  END),0) AS PNEU,                 " + CHR(13)
_cQuery += "       NVL(SUM(SUA.UA_FRETE),0) AS FRETE,                                 " + CHR(13)
_cQuery += "		SZM.ZM_EXIFAT                                                     " + CHR(13)
_cQuery += "FROM " + RetSQLName("SUA") + " SUA                                        " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SUB") + " SUB ON UA_NUM = UB_NUM               " + CHR(13)
_cQuery += "                         AND UA_FILIAL = UB_FILIAL                        " + CHR(13)
_cQuery += "                         AND SUB.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SZM") + " SZM ON SZM.ZM_COD = SUA.UA__STATUS   " + CHR(13)
_cQuery += "                         AND SZM.ZM_EXIFAT = '2'                          " + CHR(13)
_cQuery += "                         AND SZM.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_COD = UB_PRODUTO           " + CHR(13)
_cQuery += "                         AND SB1.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SZF") + " SZF ON ZF_COD = UA__TIPPED           " + CHR(13)
_cQuery += "                         AND SZF.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_COD = UA_CLIENTE           " + CHR(13)
_cQuery += "                         AND A1_LOJA = UA_LOJA                            " + CHR(13)
_cQuery += "                         AND SA1.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SA4") + " SA4 ON A4_COD = UA_TRANSP            " + CHR(13)
_cQuery += "                         AND SA4.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "LEFT  JOIN " + RetSQLName("SA4") + " SA4A ON UA__REDESP = SA4A.A4_COD     " + CHR(13)
_cQuery += "                         AND SA4A.D_E_L_E_T_ = ' '                        " + CHR(13)
_cQuery += "WHERE SUA.D_E_L_E_T_ = ' '                                                " + CHR(13)
_cQuery += "      AND SUA.UA__PRVFAT BETWEEN '" + DTOS(dDataIni) + "' AND '" + DTOS(dDatafIM) + "'   " + CHR(13)
_cQuery += "      AND TRIM(SUA.UA__TIPPED) NOT IN ('4','3') " + CHR(13)
If !Empty(cSeg)                                                                       
	_cQuery += " AND SUA.UA__SEGISP = '" + cSeg + "' 								  " + CHR(13)
EndIf
If !Empty(cLocal)
	_cQuery += " AND SUA.UA_FILIAL = '" + cLocal + "' 								  " + CHR(13)
EndIf
If !Empty(cSit)
	_cQuery += " AND SUA.UA__STATUS = '" + cSit + "' 								  " + CHR(13)
EndIf
If !Empty(cTip)
	_cQuery += " AND SUA.UA__TIPPED = '" + cTip + "' 								  " + CHR(13)
EndIf
_cQuery += "GROUP BY SZM.ZM_INDICE, SZM.ZM_DESC, SZM.ZM_EXIFAT                        " + CHR(13)
_cQuery += "UNION                                                                     " + CHR(13)
_cQuery += "SELECT DISTINCT SZM.ZM_INDICE,                                            " + CHR(13)
_cQuery += "       SZM.ZM_DESC AS SITUACAO,                                           " + CHR(13)
_cQuery += "       COUNT(DISTINCT UB_NUM  ) AS NUM,                                   " + CHR(13)
_cQuery += "       COUNT(UB_VLRITEM  ) AS QTDITENS,                              	  " + CHR(13)
_cQuery += "       NVL(SUM(CASE WHEN SB1.B1_TIPO = 'PC'                               " + CHR(13)
_cQuery += "					THEN SUB.UB_VLRITEM  END),0) AS PECA,                 " + CHR(13)
_cQuery += "       NVL(SUM(CASE WHEN SB1.B1_TIPO = 'PN' OR SB1.B1_TIPO = 'CA'         " + CHR(13)
_cQuery += "					THEN SUB.UB_VLRITEM  END),0) AS PNEU,                 " + CHR(13)
_cQuery += "       NVL(SUM(SUA.UA_FRETE),0) AS FRETE,                                 " + CHR(13)
_cQuery += "		SZM.ZM_EXIFAT                                                     " + CHR(13)
_cQuery += "FROM " + RetSQLName("SUA") + " SUA                                        " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SUB") + " SUB ON UA_NUM = UB_NUM               " + CHR(13)
_cQuery += "                         AND UA_FILIAL = UB_FILIAL                        " + CHR(13)
_cQuery += "                         AND SUB.D_E_L_E_T_ = ' '                         " + CHR(13)

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

_cQuery += "INNER JOIN " + RetSQLName("SF2") + " SF2 ON SF2.F2_FILIAL = SD2.D2_FILIAL " + CHR(13)
_cQuery += "                         AND SF2.F2_DOC = SD2.D2_DOC                      " + CHR(13)
_cQuery += "                         AND SF2.F2_SERIE = SD2.D2_SERIE                  " + CHR(13)
_cQuery += "                         AND SF2.F2_TIPO  = SD2.D2_TIPO                   " + CHR(13)
_cQuery += "                         AND SF2.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SZM") + " SZM ON SZM.ZM_COD = SUA.UA__STATUS   " + CHR(13)
_cQuery += "                         AND SZM.ZM_EXIFAT = '1'                          " + CHR(13)
_cQuery += "                         AND SZM.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SB1") + " SB1 ON B1_COD = UB_PRODUTO           " + CHR(13)
_cQuery += "                         AND SB1.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SZF") + " SZF ON ZF_COD = UA__TIPPED           " + CHR(13)
_cQuery += "                         AND SZF.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SA1") + " SA1 ON A1_COD = UA_CLIENTE           " + CHR(13)
_cQuery += "                         AND A1_LOJA = UA_LOJA                            " + CHR(13)
_cQuery += "                         AND SA1.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "INNER JOIN " + RetSQLName("SA4") + " SA4 ON A4_COD = UA_TRANSP            " + CHR(13)
_cQuery += "                         AND SA4.D_E_L_E_T_ = ' '                         " + CHR(13)
_cQuery += "LEFT  JOIN " + RetSQLName("SA4") + " SA4A ON UA__REDESP = SA4A.A4_COD     " + CHR(13)
_cQuery += "                         AND SA4A.D_E_L_E_T_ = ' '                        " + CHR(13)
_cQuery += "WHERE SUA.D_E_L_E_T_ = ' '                                                " + CHR(13)
_cQuery += "      AND SF2.F2_EMISSAO = TO_CHAR(SYSDATE,'YYYYMMDD')                    " + CHR(13)
If !Empty(cSeg)
	_cQuery += " AND SUA.UA__SEGISP = '" + cSeg + "' 								  " + CHR(13)
EndIf
If !Empty(cLocal)
	_cQuery += " AND SUA.UA_FILIAL = '" + cLocal + "' 								  " + CHR(13)
EndIf
If !Empty(cSit)
	_cQuery += " AND SUA.UA__STATUS = '" + cSit + "' 								  " + CHR(13)
EndIf
If !Empty(cTip)
	_cQuery += " AND SUA.UA__TIPPED = '" + cTip + "' 								  " + CHR(13)
EndIf                                                                                 
_cQuery += "GROUP BY SZM.ZM_INDICE, SZM.ZM_DESC,SZM.ZM_EXIFAT                         " + CHR(13)
_cQuery += "ORDER BY ZM_INDICE                                                        "
TcQuery _cQuery New Alias "TRBSUA"

DbSelectArea("TRBSUA")
DbGoTop()

If(TRBSUA->ZM_EXIFAT == '1')
	oFolder1:aDialogs[3]:lActive := .T.
EndIf

while !TRBSUA->(eof())
	
	If(TRBSUA->ZM_EXIFAT == '1')

        AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
        nn++

        oGetTM1:Acols[nn][nPosEmis]         := TRBSUA->SITUACAO
        oGetTM1:Acols[nn][nPosNome]         := TRBSUA->NUM
        oGetTM1:Acols[nn][nPosCli]          := TRBSUA->PECA
        oGetTM1:Acols[nn][nPosCli2]         := TRBSUA->PNEU
        oGetTM1:Acols[nn][nPosCli3]         := TRBSUA->FRETE
        oGetTM1:Acols[nn][nPosCli4]         := TRBSUA->PECA + TRBSUA->PNEU + TRBSUA->FRETE
        oGetTM1:Acols[nn][nPosCli5]         := TRBSUA->QTDITENS
        
        oGetTM1:Acols[nn][Len(aHeaderB)+1]  := .F.

		nTotaln1 += TRBSUA->NUM
		nTotaln2 += TRBSUA->PECA
		nTotaln3 += TRBSUA->PNEU
		nTotaln4 += TRBSUA->PNEU + TRBSUA->PECA + TRBSUA->FRETE
		nTotaln5 += TRBSUA->FRETE
		nTotaln6 += TRBSUA->QTDITENS
	//ElseIf(TRBSUA->ZM_EXIFAT == '3')
	
	Else
		AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
		nn++

		oGetTM1:Acols[nn][nPosEmis]			:= TRBSUA->SITUACAO
		oGetTM1:Acols[nn][nPosNome] 		:= TRBSUA->NUM
		oGetTM1:Acols[nn][nPosCli]  		:= TRBSUA->PECA
		oGetTM1:Acols[nn][nPosCli2]         := TRBSUA->PNEU
		oGetTM1:Acols[nn][nPosCli3]  		:= TRBSUA->FRETE
		oGetTM1:Acols[nn][nPosCli4]         := TRBSUA->PECA + TRBSUA->PNEU + TRBSUA->FRETE
		oGetTM1:Acols[nn][nPosCli5]  		:= TRBSUA->QTDITENS
		
		oGetTM1:Acols[nn][Len(aHeaderB)+1]  := .F.

		nTotal1 += TRBSUA->NUM
		nTotal2 += TRBSUA->PECA
		nTotal3 += TRBSUA->PNEU
		nTotal4 += TRBSUA->PNEU + TRBSUA->PECA + TRBSUA->FRETE
		nTotal5 += TRBSUA->FRETE
		nTotal6 += TRBSUA->QTDITENS
	EndIf

	TRBSUA->(DbSkip())
EndDo
	   
If(Len(oGetTM1:aCols) = 0)
	oGetTM1:AddLine(.T.,.F.)
EndIf

oFolder1:aDialogs[2]:lActive := (nn > 0)

oGetTM1:nat:=len(oGetTM1:Acols)
TRBSUA->(dbCloseArea())

cTotal1 := nTotal1
cTotal2 := nTotal2
cTotal3 := nTotal3
cTotal4 := nTotal4
cTotal5 := nTotal5
cTotal6 := nTotal6

cTotaln1 := nTotaln1
cTotaln2 := nTotaln2
cTotaln3 := nTotaln3
cTotaln4 := nTotaln4
cTotaln5 := nTotaln5
cTotaln6 := nTotaln6

oGetTM1:Refresh()

//U_ITMKA25B(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Pedidos
//U_ITMKA25C(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Notas

return

/////////////////////////////////////////////////////////
//	BUSCA A SITUACAO DO PRODUTO
/////////////////////////////////////////////////////////

Static Function BuscaSit(cSit)

Local lOk 		:= .T.

If !Empty(cSit)
	dbSelectArea("SZM")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SZM")+cSit))
		Alert("Situa็ใo Inexistente")
		cSit 	:= " "
		cGet8 	:= ""
		lOk 	:= .F.
	EndIf
EndIf

cGet8 	:= IIF(!Empty(cSit),Posicione("SZM",1,xFilial("SZM")+cSit,"ZM_DESC"),space(TAMSX3("ZM_DESC")[1]))

oGetTM1:Refresh()

Return lOk



/////////////////////////////////////////////////////////
//	BUSCA O TIPO DE PEDIDO
/////////////////////////////////////////////////////////

Static Function BuscaTipo(cTip)

Local lOk 		:= .T.

If !Empty(cTip)
	dbSelectArea("SZF")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SZF")+cTip))
		Alert("Tipo Inexistente")
		cTip 	:= " "
		cGet4 	:= ""
		lOk 	:= .F.
	EndIf
EndIf

cGet4 	:= IIF(!Empty(cTip),Posicione("SZF",1,xFilial("SZF")+cTip,"ZF_DESC"),space(TAMSX3("ZF_DESC")[1]))

oGetTM1:Refresh()

Return lOk



/////////////////////////////////////////////////////////
//	BUSCA O SEGMENTO
/////////////////////////////////////////////////////////

Static Function BuscaSeg(cSeg)

Local lOk := .T.

If !Empty(cSeg)
	dbSelectArea("SZ7")
	dbSetOrder(1)
	If !(dbSeek(xFilial("SZ7")+cSeg))
		Alert("Seguimento Inexistente")
		//cSeg := space(TAMSX3("Z7_CODIGO")[1])
		cSeg := " "
		cGet6 := ""
		lOk := .F.
	EndIf
EndIf

cGet6 := IIF(!Empty(cSeg),Posicione("SZ7",1,xFilial("SZ7")+cSeg,"Z7_DESCRIC"),space(TAMSX3("Z7_DESCRIC")[1]))

oGetTM1:Refresh()

Return lOk



/////////////////////////////////////////////////////////
//	BUSCA O LOCAL
/////////////////////////////////////////////////////////

Static Function BuscaLocal(cLocal)

Local lOk := .T.

If !Empty(cLocal) .or. cLocal <> "  "
	dbSelectArea("SM0")
	dbSetOrder(1)
	If !(dbSeek("01"+cLocal))
		Alert("Filial Inexistente")
		cLocal := " "
		cGet2 := ""
		lOk := .F.
	else
		cGet2 := IIF(!Empty(cLocal),Posicione("SM0",1,"01"+cLocal,"M0_FILIAL"),space(TAMSX3("M0_FILIAL")[1]))
	EndIf
Else
	cGet2 := ""
EndIf

oGetTM1:Refresh()

Return lOk

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFltrDds   บAutor  ณAlexandre Caetano   บ Data ณ  28/Nov/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Chama fun็ใo de pedidos/notas dependendo da situa็ใo       บฑฑ
ฑฑบ          ณ selciona  (popula acols)                                   บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function FltrDds(PSituacao)
Local cSit

If Alltrim(PSituacao) == "ATENDIMENTO"
	cSit	:= "1"
Elseif Alltrim(PSituacao) == "COMERCIAL"
	cSit	:= "2"
Elseif Alltrim(PSituacao) == "FINANCEIRO"
	cSit	:= "3"
Elseif Alltrim(PSituacao) == "COMERCIAL/FINANCEIRO"
	cSit	:= "4"
Elseif Alltrim(PSituacao) == "DEPOSITO"
	cSit	:= "5"
Elseif Alltrim(PSituacao) == "EM SEPARACAO"
	cSit	:= "6"
Elseif Alltrim(PSituacao) == "EMBALADO"
	cSit	:= "7"
Elseif Alltrim(PSituacao) == "LIBERADO PARA FATURAMENTO"
	cSit	:= "8"
ElseIf Alltrim(PSituacao) == "FATURADO"
	cSit	:= "9"
Elseif Alltrim(PSituacao) == "EM EXPEDICAO"
	cSit	:= "10"
Elseif Alltrim(PSituacao) == "EXPEDIDO"
	cSit	:= "11"
Elseif Alltrim(PSituacao) == "PEDIDO CANCELADO"
	cSit	:= "12"
Endif

If(oFolder1:nOption = 2)
	U_ITMKA25b(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Pedidos
ElseIf(oFolder1:nOption = 3)
	U_ITMKA25C(cSeg,dDataIni,dDataFim,cLocal,cSit,cTip) // Notas
EndIf

Return(.t.)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCtrlAba   บAutor  ณAlexandre Caetano   บ Data ณ  28/Nov/2014บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Controla Aba quanto estar ou nใo ativa dependendo da       บฑฑ
ฑฑบ          ณ situa็ใo selecionada                                       บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Exclusivo ISAPA                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CtrlAba()

cSituacao =  oGetTM1:aCols[oGetTM1:nat,1]

If Alltrim(cSituacao) == "FATURADO"      .or.;
	Alltrim(cSituacao) == "EM EXPEDICAO"  .or.;
	Alltrim(cSituacao) == "EXPEDIDO"
	
	oFolder1:aDialogs[3]:lActive := .t.
Else
	oFolder1:aDialogs[3]:lActive := .f.
Endif

Return(.t.)
