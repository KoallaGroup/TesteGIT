#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'RWMAKE.CH'
#include "topconn.ch"
#include "tbiconn.ch"


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³IFATR03   ºAutor³Roberto Marques - Anadiº Data ³  08/10/14  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Emissao de Etiqueta do Pedido do Callcenter/Faturamento    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFATR04()

Local _aArea	:= getArea()

Private nOpc      	:= 1
Private aHeader1 	:= {}
Private aButtons   	:= {}
Private _FL	 		:= Space(4)
Private _Filial	 	:= Space(80)
Private _Orig		:= Space(15)
Private _Ped        := Space(6)
Private _Porta		:= Space(4)
Private oDlg		:= nil
Private oGetTM1		:= nil
Private oComboBo1
Private oComboBo2
Private _CNPJ
Private _Imp		:= GETMV("MV__IMPSTI")
Private _aSep		:= {}

_aSep := Separa(Alltrim(_Imp),";")

oFont := tFont():New("Tahoma",,-12,,.t.)
aSize := MsAdvSize()

aObjects := {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo := {aSize[1],aSize[2],aSize[3],aSize[4],3,3}
aPosObj := MsObjSize(aInfo, aObjects)

DEFINE MSDIALOG oDlg TITLE "Sticker Por Pedido - FEIRA" From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL

@ 47,10   Say "Filial:"   	FONT oFont SIZE 60,10 OF oDlg PIXEL
@ 47,140  Say "Origem:"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 47,240  Say "Pedido:"   	FONT oFont SIZE 80,10 OF oDlg PIXEL
@ 47,330  Say "Porta Impressão:"   	FONT oFont SIZE 90,10 OF oDlg PIXEL

@ 47,25  MsGet _FL 		Picture "@!" 	Size 07,10 of oDlg PIXEL FONT oFont F3 "SM0" Valid fPsqFL()
@ 47,65  MsGet _Filial 	Picture "@!" 	Size 70,10 of oDlg PIXEL FONT oFont When .F.
@ 47,165 MSCOMBOBOX oComboBo1 VAR _Orig ITEMS {"CallCenter","Faturamento"} SIZE 060, 010 OF oDlg PIXEL FONT oFont
@ 47,265 MsGet _Ped 	Picture "@!" 	Size 60,10 of oDlg PIXEL FONT oFont Valid IfatR03A()
@ 47,385 MSCOMBOBOX oComboBo2 VAR _Porta ITEMS _aSep SIZE 115, 010 OF oDlg PIXEL FONT oFont
lOk := .F.

montaAcols()

//ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=IFATR03B()},{||oDlg:End()},,aButtons) })
ACTIVATE MSDIALOG oDlg CENTERED ON INIT Eval({ || EnchoiceBar(oDlg,{||lOk:=IFATR03B(),Close(oDlg)},{||oDlg:End()},,aButtons) })

restArea(_aArea)

Return


Static Function montaAcols()

private aCols	 := {}
private aEdit	 := {"QUANT"}

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("C6_PRODUTO")
	aadd(aHeader1, {"Produto"			,;
	"PROD"       		,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""				    ,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when })
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("B1_DESC")
	aadd(aHeader1, {Trim(SX3->X3_Titulo),;
	SX3->X3_Campo       ,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

dbSelectArea("SX3")
dbSetOrder(2)
If DbSeek("C6_QTDVEN")
	aadd(aHeader1, {"Quantidade"			,;
	"QUANT"       		,;
	SX3->X3_Picture     ,;
	SX3->X3_Tamanho     ,;
	SX3->X3_Decimal     ,;
	""     				,;
	SX3->X3_Usado       ,;
	SX3->X3_Tipo        ,;
	SX3->X3_F3    	 	,;
	SX3->X3_Context		,;
	SX3->X3_Cbox		,;
	SX3->X3_relacao		,;
	SX3->X3_when})
Endif

oGetTM1 := MsNewGetDados():New(67, 0, 250, 500,GD_UPDATE, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlg, aHeader1, aCols)

Return

Static Function IfatR03A()

Local mSQL
local _nProd	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PROD" })
local _nDesc	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "B1_DESC" })
local _nQuant	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "QUANT" })
Local nQtdCpo   := 0
Local nCols     := 0

oGetTM1:aCols := {}

nQtdCpo := Len(aHeader1)
nn:=0

If _Orig == "CallCenter"
	
	
	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif
	
	
	mSQL :="SELECT UB_PRODUTO,B1_DESC,UB_QUANT "
	mSQL +=" FROM "+RetSqlName("SUB")+" SUB,"+RetSqlName("SB1")+" SB1 "
	mSQL +=" WHERE UB_NUM ='"+_Ped+"'  AND UB_FILIAL='"+AllTrim(_FL)+"' AND SUB.D_E_L_E_T_ <>'*' "
	mSQL +=" AND B1_COD=UB_PRODUTO and B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' "
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
	
	If TMP->(!Eof())
		
		While TMP->(!EOF())
			
			AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
			nn++
			
			oGetTM1:Acols[nn][_nProd]			:= TMP->UB_PRODUTO
			oGetTM1:Acols[nn][_nDesc]			:= TMP->B1_DESC
			oGetTM1:Acols[nn][_nQuant]			:= TMP->UB_QUANT
			oGetTM1:Acols[nn][Len(aHeader1)+1] 	:= .F.
			
			TMP->(DbSkip())
			
		Enddo
		
		oGetTM1:nat:=len(oGetTM1:Acols)
		
	Else
		MsgInfo(OemToAnsi("Nenhum Pedido Encontrado dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
	Endif
	
	TMP->(dbCloseArea())
	
	oGetTM1:Refresh()
	
Else
	
	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif
	
	mSQL :="SELECT C6_PRODUTO,B1_DESC,C6_QTDVEN "
	mSQL +=" FROM "+RetSqlName("SC6")+" SC6,"+RetSqlName("SB1")+" SB1 "
	mSQL +=" WHERE C6_NUM ='"+_Ped+"'  AND C6_FILIAL='"+AllTrim(_FL)+"' AND SC6.D_E_L_E_T_ <>'*' "
	mSQL +=" AND B1_COD=C6_PRODUTO and B1_FILIAL='"+xFilial("SB1")+"' AND SB1.D_E_L_E_T_ <>'*' "
	
	
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
	
	If TMP->(!Eof())
		
		While TMP->(!EOF())
			
			AAdd(oGetTM1:aCols, Array(nQtdCpo+1))
			nn++
			
			oGetTM1:Acols[nn][_nProd]			:= TMP->C6_PRODUTO
			oGetTM1:Acols[nn][_nDesc]			:= TMP->B1_DESC
			oGetTM1:Acols[nn][_nQuant]			:= TMP->C6_QTDVEN
			oGetTM1:Acols[nn][Len(aHeader1)+1] 	:= .F.
			
			TMP->(DbSkip())
			
		Enddo
		
		oGetTM1:nat:=len(oGetTM1:Acols)
		
	Else
		MsgInfo(OemToAnsi("Nenhum Pedido Encontrado dentro dos Parametros Informado , verifique."),OemToAnsi("Atencao"))
	Endif
	
	TMP->(dbCloseArea())
	
	oGetTM1:Refresh()	
	
Endif

Return

Static Function fPsqFL()

IF SELECT("TSZE") > 0
	dbSelectArea("TSZE")
	TSZE->(dbCloseArea())
Endif

mSQL := "SELECT ZE_FILIAL,ZE_CGC FROM SZE010 WHERE  D_E_L_E_T_ <>'*' "
mSQL += "AND ZE_CODIGO='"+SM0->M0_CODIGO+"' AND ZE_CODFIL='"+_FL+"'"

DbUseArea(.T.,"TOPCONN",TcGenQry(,,mSQL),"TSZE",.F.,.T.)
TSZE->( DbGoTop() )
If TSZE->(!Eof())
	_Filial := TSZE->ZE_FILIAL
	_CNPJ	:= TSZE->ZE_CGC
Endif
TSZE->(dbCloseArea())
Return

Static Function IFATR03B()

Local mSQL
Local nQtdCpo   := 0
Local nCols     := 0

Local I, _cVolume
Local cEmp

Local cDesc1         := "Este programa tem como objetivo imprimir Etiquetas de"
Local cDesc2         := "Produtos conforme parametros informados pelo usuario."
Local cDesc3         := "O formato esta especificado no arquivo PRODUTOS.PRN  "
Local cPict          := "em sigaadv. "
Local titulo       	:= ""
Local nLin         	:= 80

Local Cabec1       	:= ""
Local Cabec2       	:= ""
Local imprime      	:= .T.
Local aOrd 			:= {}
Local cFile			:= ""
Local cPorta		:= "LPT3"
Local _cQuery		:= ""

Local _nProd	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "PROD" })
Local _nQuant	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "QUANT" })

Private cD1,cD2,cD3	 := ""
Private cCodP
Private cComp
Private cDescr
Private cUnid
Private cOrig
Private cCNPJ
Private cValid
Private cMenEt

Private _aPRODUTO 	:= {}
Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := Space(10)
Private limite      := 80
Private tamanho     := "P"
Private nomeprog    := "IFATR03" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 3, "LPT3", , 1}
Private nLastKey    := 0
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "IFATR04" // Coloque aqui o nome do arquivo usado para impressao em disco
Private aLinhas 	:= {}
Private cString 	:= "SB1"
Private cEOL    	:= &("CHR(13)+CHR(10)")
Private nQTD 		:= 0, cLote := Space(6), cTipoProd := "", nNetq := 0, cSerie := Space(8), _cBar := Space(TamSx3("B1_CODBAR")[1])

cFile := '\modelos\IFATR04.ETQ'

//Verifica se existe diretorio, senão cria
If !ExistDir("C:\Temp")
	MakeDir("C:\Temp")
	If !ExistDir("C:\Temp")
		Alert("Não foi possivel criar diretorio: C:\Temp")
		Return
	EndIf
EndIf

_cQuery := "SELECT ZE_FILIAL,                          " + Chr(13)
_cQuery += "	   ZE_NOMECOM,                         " + Chr(13)
_cQuery += "	   ZE_CGC                              " + Chr(13)
_cQuery += "FROM " + RetSqlName("SZE") + " SZE         " + Chr(13)
_cQuery += "WHERE SZE.ZE_CODIGO = '" + cEmpAnt + "'    " + Chr(13)
_cQuery += "      AND SZE.ZE_CODFIL = '" + _FL + "'    " + Chr(13)
_cQuery += "      AND SZE.D_E_L_E_T_ = ' '             "

TCQUERY _cQuery NEW ALIAS "TMPSZE"

If TMPSZE->(!Eof())
	cEmp    := TMPSZE->ZE_NOMECOM
	cCNPJ	:= "CNPJ.: " + Transform(TMPSZE->ZE_CGC,PesqPict("SA2","A2_CGC"))
Endif



For nX := 1 To Len(oGetTM1:aCols)
	If oGetTM1:aCols[nX][_nQuant] > 0
		
		_aPRODUTO 	:= {}
		                               
		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1") + oGetTM1:aCols[nX][_nProd])
		
		If SUBSTRING(SB1->B1_COD,1,1) = "2" 
			If SB1->B1_MARCA <> "005"
				cEmp  := "ISAPA IMPORTACAO E COMERCIO LTDA"
				cCNPJ := "CNPJ.: 61.327.045/0004-02"                             
			Else
				cEmp  := "OMEGA BRASIL IMP DIST DE ART ESPORT LTDA"
				cCNPJ := "CNPJ.: 03.105.808/0002-02"                             
			EndIf				
		Else
			cEmp    := TMPSZE->ZE_NOMECOM
			cCNPJ	:= "CNPJ.: " + Transform(TMPSZE->ZE_CGC,PesqPict("SA2","A2_CGC"))
		EndIf
		                               
		
		cCodP   := AllTrim(SB1->B1_COD)
		cUnid  	:= "Preco: "+Transform(SB1->B1_PRCSUG,"@E 999,999,999.99" )+"  "+cCodP //+ " 1" + POSICIONE("SAH",1,XFILIAL("SAH")+SB1->B1_UM,"AH_UMRES") 
		cDescr 	:= ALLTRIM(SB1->B1_DESC) //AllTrim(SB1->B1_DESC) + IIF(SB1->B1__SEGISP=="1","-Para Bicicleta /","" )+IIF(!Empty(SB1->B1_DESC),"/ Comp: "+AllTrim(SB1->B1_DESC),"")
		cComp	:= "Comp: "+ALLTRIM(SB1->B1_COMPOSI)
		cOrig	:= IIF(SB1->B1_ORIGEM <> "0","IMPORT.: ","FORNEC.: ") + AllTrim(cEmp)
//		If SB1->B1_TIPO $ "CA/PN"
			cValid 	:= "Val: "+ALLTRIM(SB1->B1_VALID)+" | Garantia: "+ALLTRIM(SB1->B1_GARANTI)+" | Orig: "+ALLTRIM(SB1->B1_PAIS)   
			
			//Transform(_nValJurDia,"@E 999,999,999.99" )
//		Else
//			cValid 	:= "Validade Indeterminada   Garantia: 90 dias"
//		EndIf
		cMenEt := "Este Produto nao oferece riscos a saude."
		AADD(_aPRODUTO ,{cCodP,cDescr,cUnid,cOrig,cCNPJ,cValid,oGetTM1:aCols[nX][_nQuant],cComp,cMenEt})
		
		if !LeForm(cFile, @aLinhas)
			Return
		EndIf
		
		fGeraEtq()
		
	EndIf
	

Next nX

TMPSZE->(dbCloseArea())

Return(.t.)


Static Function fGeraEtq()

Local nOrdem, x,ctexto:='', cSerieFim := "", nContProd
Local cCMD	:= ""
Private Desc, Desci, Desce, CodBar
Private cEOL := "CHR(13)+CHR(10)"
Private nCnt := 0
Private nTamLin, cLin, cCpo, vCont, vFixo, tmpCont
Private cEtiqTEMP	:= 'C:\TEMP\IFATR04.ETQ'
Private nHdl
Private _aDiretorio     := Directory( "C:\TEMP\*.ETQ" ) 


// Excluir o Arquivo Antigo
_nIndDir := 1
For _nIndDir := 1  To Len(_aDiretorio)
	Delete File ( "C:\TEMP\"+_aDiretorio[_nIndDir][01] )
Next

nHdl    := fCreate( cEtiqTEMP )

If nHdl == -1
	Alert( "ATENÇÃO !!! O arquivo "+cEtiqTEMP+" não pode ser executado !!! Verifique os parâmetros." )
	Return
EndIf

nLin	:= 1
cD1	:= SUBSTR(_aProduto[1,2],1,45)
cD2 := _aProduto[1,9] // SUBSTR(_aProduto[1,2],46,IIF(Len(_aProduto[1,2]) > 90,45,Len(_aProduto[1,2])) )
cD3 := _aProduto[1,8] //SUBSTR(_aProduto[1,2],90,Len(_aProduto[1,2]))

For x := 1 to Len(aLinhas)
	               
	if (y := at("%",aLinhas[x])) >0 //Variaveis
		z := &("'"+SubStr(aLinhas[x],1,y-1)+"'+"+ SubStr(aLinhas[x],y+1, Len(aLinhas[x])) )// +cEOL
	ElseIf (y := at('cCodBar',aLinhas[x])) > 0 	//Codigo de barras
		z := SubStr(aLinhas[x],1,15) + _aPRODUTO[1,1]+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cUnid',aLinhas[x])) > 0 	//Unid
		z := SubStr(aLinhas[x],1,23) +"   "+ _aPRODUTO[1,3]+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cD1',aLinhas[x])) > 0 	//cD1
		z := SubStr(aLinhas[x],1,23) + cD1+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cD2',aLinhas[x])) > 0 	//cD1
		z := SubStr(aLinhas[x],1,23) + cD2+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cD3',aLinhas[x])) > 0 	//cD1
		z := SubStr(aLinhas[x],1,23) + cD3+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cEmp',aLinhas[x])) > 0 	//cEmp
		z := SubStr(aLinhas[x],1,23) + _aPRODUTO[1,4]+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cOrig',aLinhas[x])) > 0 	//cOrig
		z := SubStr(aLinhas[x],1,23) + _aPRODUTO[1,5]+Chr( 13 )+Chr( 10 )
	ElseIf (y := at('cValid',aLinhas[x])) > 0 	//cValid
		z := SubStr(aLinhas[x],1,23) + _aPRODUTO[1,6]+Chr( 13 )+Chr( 10 )     					
	ElseIf (y := at('Q',aLinhas[x])) > 0 	//cValid
		z := SubStr(aLinhas[x],1,1) + PADL(_aPRODUTO[1,7],4,"0") +Chr( 13 )+Chr( 10 )
	Else
		z := aLinhas[x]+Chr( 13 )+Chr( 10 )
	EndIf
	
	If fWrite( nHdl, z, Len(z) ) != Len( z )
		Alert( "ATENÇÃO !!! Ocorreu um erro na gravação do arquivo " )
		Exit
	Endif
	
Next

fClose( nHdl )

cCMD := "cmd /c copy " + cEtiqTEMP + " " + _Porta

WaitRun(cCMD)

Return


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ LeForm   º Autor ³ Henry R.Christmann º Data ³  15/08/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Le o formato da etiqueta a ser impressa                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

static function LeForm(cFile, aLinhas)

Local cBuffer:= '' , nTamLin, nBtLidos, cLinha :='', z

Private nHdl    := fOpen(cFile,68)

If nHdl == -1
	MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
	Return .f.
Endif

nTamFile := fSeek(nHdl,0,2)

nTamLin  := 500+Len(cEOL)
fSeek(nHdl,0,0)

nBtLidos := fRead(nHdl,@cBuffer,nTamLin)
cLinha += cBuffer
aLinhas := {}
While nBtLidos >= nTamLin .or. nBtLidos > 0
	
	if (z := at(cEOL, cLinha)) == 0
		nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
		cLinha += cBuffer
		loop
	endif
	
	AADD(aLinhas, SubStr(cLinha,1,z-1))
	cLinha := SubStr(cLinha,z+2,Len(cLinha))
	
EndDo

fClose(nHdl)
Return .t.

