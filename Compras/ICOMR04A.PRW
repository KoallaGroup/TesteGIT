#INCLUDE "PROTHEUS.CH"
#INCLUDE "SHELL.CH"
#INCLUDE "TOPCONN.CH"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณICOMR04  บ Autor ณ Silverio Bastos    บ Data ณ  20/09/2014 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Rotina para geracao de arquivo em excel - Compras	     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                 				      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/

User Function ICOMR04A()
//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ Declaracao de Variaveis                                             ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

Local cDesc1		:= "Este programa tem como objetivo gerar arquivo excel "
Local cDesc2   		:= "de acordo com os parametros informados pelo usuario."
Local cDesc3   		:= ""
Local cPict    		:= ""
Local titulo  		:= ""
Local _cDest		:= _cDrive := ""

Private _cArq1    	:= ""
Private _cInd1    	:= ""
Private _aStru1   	:= {}
Private nomeprog  	:= "ICOMR04"
Private cPerg     	:= "ICOMR04001"
Private wnrel     	:= "ICOMR04"
Private cString 	:= "SB1"
Private _cDest 		:= cGetFile("Arquivos xls|*.XLS","Selecione o Diretorio onde o arquivo ICOMR04 sera salvo",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)
Private aUserFl     := PswRet(1)
Private cGrupUsr	:= aUserFl[1][10][1] // Grupo Que o usuario Pertence
Private lImpTudo	:= .F.
Private _cSegUsr	:= ""
Private _lOK		:= .F.
Private _oButton1, _oComboBo1, _oSay1, _oDlg, _nComboBo1 := 1

dbSelectArea("SZ1")
dbSetOrder(1)
if MsSeek(xFilial("SZ1")+__cUserId)
	
	_cSegUsr := SZ1->Z1_SEGISP
	
	If Val(_cSegUsr) == 0
		
		DbSelectArea("SX3")
		DbSetOrder(2)
		If MsSeek("C5__SEGISP")
			DEFINE MSDIALOG _oDlg TITLE "Crossdocking" FROM 000, 000  TO 120, 195 COLORS 0, 16777215 PIXEL
			@ 005, 006 SAY _oSay1 PROMPT "Selecione o segmento a ser exibido" SIZE 088, 007 OF _oDlg COLORS 0, 16777215 PIXEL
			@ 021, 007 MSCOMBOBOX _oComboBo1 VAR _nComboBo1 ITEMS Separa(Alltrim(SX3->X3_CBOX),";") SIZE 083, 010 OF _oDlg COLORS 0, 16777215 PIXEL
			@ 039, 029 BUTTON _oButton1 PROMPT "Avan็ar" SIZE 037, 012 OF _oDlg PIXEL ACTION {|| _lOK := .t.,_oDlg:End()}
			ACTIVATE MSDIALOG _oDlg CENTERED
			
			If _lOK
				_cSegUsr := _nComboBo1
			EndIf
			
		EndIf
		
	EndIf
	
else
	ApMsgAlert("Usuแrio nใo cadastrado na tabela de Segmento.","Aten็ใo!!!")
endif

If cGrupUsr $ GETMV("MV__ICOMR4")
	lImpTudo := .T.
Endif

dbSelectArea("SB1")
dbSetOrder(1)

// +--------------------------------+
// | Valida Parโmetros do Relat๓rio |
// +--------------------------------+

_fValPerg()

If Pergunte(cPerg,.T.)
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Monta a interface padrao com o usuario...                           ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Inicializa a regua de processamento                                 ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	
	Processa({|| CriaPlan() },"Gerando Arquivo de crossdocking.XLS...",,.T.)
	
EndIf

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบFuno    ณMontaQry  บ Autor ณ Silverio Bastos    บ Data ณ  19/06/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescrio ณ Query de selecao                                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ ISAPA                                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function MontaQry()

Local _cQrySB1 		:= ""
Local _cGrpIni 		:= ""
Local _cGrpFim		:= ""
Local _cSubGrpIni 	:= ""
Local _cSubGrpFim	:= ""
Local _cProdIni 	:= ""
Local _cProdFim		:= ""
Local _aProd		:= ""
Local _lExec		:= .F.

//Private _cArq1    	:= ""
//Private _cInd1    	:= ""
//Private _aStru1   	:= {}
Private SB2Q		:= {}
Private SD2Q		:= {}
Private _cLocal		:= GetMv("MV__CROSLO")

// +-------------------------------------------------------------+
// | Gera็ใo de Tabela Temporแria com os Dados a Serem Impressos |
// +-------------------------------------------------------------+

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
	DbSelectArea("SB1")
EndIf

AADD(_aStru1,{"ITEM"		,"C",TamSX3("B1_COD")[1],TamSX3("B1_COD")[2]})
AADD(_aStru1,{"DESC"	  	,"C",TamSX3("B1_DESC")[1],TamSX3("B1_DESC")[2]})
AADD(_aStru1,{"MARCA"		,"C",TamSX3("Z5_DESC")[1],TamSX3("Z5_DESC")[2]})
AADD(_aStru1,{"PARTNUMBER"	,"C",TamSX3("A5_CODPRF")[1],TamSX3("A5_CODPRF")[2]})
AADD(_aStru1,{"KIT"   		,"C",TamSX3("U1_ACESSOR")[1],TamSX3("U1_ACESSOR")[2]})
AADD(_aStru1,{"QTKIT"   	,"N",TamSX3("U1_QTD")[1],TamSX3("U1_QTD")[2]})
AADD(_aStru1,{"QTMASTER"	,"N",TamSX3("B1__EMBMAS")[1],TamSX3("B1__EMBMAS")[2]})
AADD(_aStru1,{"UNIDADE"		,"C",TamSX3("B1_UM")[1],TamSX3("B1_UM")[2]})
AADD(_aStru1,{"PESOLIQ" 	,"N",TamSX3("B1_PESO")[1],TamSX3("B1_PESO")[2]})
AADD(_aStru1,{"ESTOQSP"  	,"N",20,2})
AADD(_aStru1,{"ARMZESSP"  	,"N",20,2})
AADD(_aStru1,{"TRFESTSP"  	,"N",TamSX3("B2__QTDTRA")[1],TamSX3("B2__QTDTRA")[2]})
AADD(_aStru1,{"VDAMESSP"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"VDAANOSP"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"RESERVSP"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"PVDMESSP"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"PVDANOSP"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"DIAESTSP"  	,"N",TamSX3("A1_MATR")[1],TamSX3("A1_MATR")[2]})
AADD(_aStru1,{"PRETRFSP"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"TRANSFSP"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"ESTOQSC"  	,"N",20,2})
AADD(_aStru1,{"ARMZESSC"  	,"N",20,2})
AADD(_aStru1,{"TRFESTSC"  	,"N",TamSX3("B2__QTDTRA")[1],TamSX3("B2__QTDTRA")[2]})
AADD(_aStru1,{"VDAMESSC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"VDAANOSC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"RESERVSC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"PVDMESSC"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"PVDANOSC"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"DTULTESC"  	,"D",TamSX3("D2_EMISSAO")[1],TamSX3("D2_EMISSAO")[2]})
AADD(_aStru1,{"QTULTESC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"EMBARCSC"  	,"N",20,2})
AADD(_aStru1,{"EMBCDOSC"  	,"N",20,2})
AADD(_aStru1,{"DIAESTSC"  	,"N",TamSX3("A1_MATR")[1],TamSX3("A1_MATR")[2]})
AADD(_aStru1,{"PRETRFSC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"TRANSFSC"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"ESTOQES"  	,"N",20,2})
AADD(_aStru1,{"TRFESTES"  	,"N",TamSX3("B2__QTDTRA")[1],TamSX3("B2__QTDTRA")[2]})
AADD(_aStru1,{"ESTOQVAL"  	,"N",20,2})
AADD(_aStru1,{"ESTOQCOM"  	,"N",20,2})
AADD(_aStru1,{"ESTOQLIS"  	,"N",20,2})
AADD(_aStru1,{"ESTOQLIN"  	,"N",20,2})
AADD(_aStru1,{"ESTOQGER"  	,"N",20,2})
AADD(_aStru1,{"ESTOQSHI"  	,"N",20,2})
AADD(_aStru1,{"VDAMESES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"VDAANOES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"RESERVES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"PVDMESES"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"PVDANOES"  	,"N",TamSX3("B1_PERGART")[1],TamSX3("B1_PERGART")[2]})
AADD(_aStru1,{"DTULTEES"  	,"D",TamSX3("D2_EMISSAO")[1],TamSX3("D2_EMISSAO")[2]})
AADD(_aStru1,{"QTULTEES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"EMBARCES"  	,"N",20,2})
AADD(_aStru1,{"EMBCDOES"  	,"N",20,2})
AADD(_aStru1,{"DIAESTES"  	,"N",TamSX3("A1_MATR")[1],TamSX3("A1_MATR")[2]})
AADD(_aStru1,{"PRETRFES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"TRANSFES"  	,"N",TamSX3("D2_QUANT")[1],TamSX3("D2_QUANT")[2]})
AADD(_aStru1,{"DTULCPES"  	,"D",TamSX3("D1_DTDIGIT")[1],TamSX3("D1_DTDIGIT")[2]})
AADD(_aStru1,{"VLUNCPES"  	,"N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2]})
AADD(_aStru1,{"DTULCPSC"  	,"D",TamSX3("D1_DTDIGIT")[1],TamSX3("D1_DTDIGIT")[2]})
AADD(_aStru1,{"VLUNCPSC"  	,"N",TamSX3("D1_VUNIT")[1],TamSX3("D1_VUNIT")[2]})
AADD(_aStru1,{"DTULTLPR"  	,"D",TamSX3("D1_DTDIGIT")[1],TamSX3("D1_DTDIGIT")[2]})
AADD(_aStru1,{"IDENTIFI"  	,"C",TamSX3("ACP__IDENT")[1],TamSX3("ACP__IDENT")[2]})
AADD(_aStru1,{"LISTAPRC"  	,"N",TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]})
AADD(_aStru1,{"PERCTDSC"  	,"N",TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]})	//AADD(_aStru1,{"PERCTDSC"  	,"N",TamSX3("ACP_PERDES")[1],TamSX3("ACP_PERDES")[2]})
AADD(_aStru1,{"MULTIPLI"  	,"N",TamSX3("DA1_PRCVEN")[1],TamSX3("DA1_PRCVEN")[2]})
AADD(_aStru1,{"STATUSX"  	,"C",7/*TamSX3("B1_MSBLQL")[1]*/,0 /*TamSX3("B1_MSBLQL")[2]*/})
AADD(_aStru1,{"CODFOR"  	,"C",TamSX3("B1_PROC")[1],TamSX3("B1_PROC")[2]})
AADD(_aStru1,{"DSCFOR"  	,"C",TamSX3("A2_NOME")[1],TamSX3("A2_NOME")[2]})

_cArq1 := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,_cArq1,"TRB1",.t.)
_cInd1 := CriaTrab(Nil,.f.)
IndRegua("TRB1",_cInd1,"ITEM ",,,"Selecionando Registros...")

// +--------------------------------------------------------+
// | Monta Query para Filtragem dos Dados a serem Impressos |
// +--------------------------------------------------------+

// NF VENDA

If Empty(Alltrim(MV_PAR01))
	_cGrpIni := '0'
Else
	_cGrpIni := MV_PAR01
EndIf

If SUBSTR(Alltrim(UPPER(MV_PAR02)),1,1) = 'Z'
	_cGrpFim := '999'
Else
	_cGrpFim := MV_PAR02
EndIf

If Empty(Alltrim(MV_PAR03))
	_cSubGrpIni := '0'
Else
	_cSubGrpIni := MV_PAR03
EndIf

If SUBSTR(Alltrim(UPPER(MV_PAR04)),1,1) = 'Z'
	_cSubGrpFim := '999'
Else
	_cSubGrpFim := MV_PAR04
EndIf

If SUBSTR(MV_PAR05,1,1) > SUBSTR(MV_PAR06,1,1)
	_cProdIni 	:= MV_PAR06
	_cProdFim	:= MV_PAR05
Else
	_cProdIni 	:= MV_PAR05
	_cProdFim	:= MV_PAR06
EndIf

_cQrySB1 := "SELECT B1_FILIAL FILIAL, " + Chr(13)
_cQrySB1 += "		B1_COD ITEM, " + Chr(13)
_cQrySB1 += "		B1_UM UNID, " + Chr(13)
_cQrySB1 += "		B1_DESC DESCRI, " + Chr(13)
_cQrySB1 += "		B1_PESO AS PESOLIQ, " + Chr(13)
_cQrySB1 += "		CASE WHEN B1_ATIVO = 'N'" + Chr(13)
_cQrySB1 += "					THEN 'Inativo' " + Chr(13)
_cQrySB1 += "		ELSE 'Ativo' END AS STATUSX, " + Chr(13)
_cQrySB1 += "		B1__EMBMAS QTDMASTER, " + Chr(13)
_cQrySB1 += "		DA1_DATVIG DTULTLPR, " + Chr(13)
_cQrySB1 += "		DA1_PRCVEN LISTAPRC, " + Chr(13)
_cQrySB1 += "		(DA1_PRCVEN - (DA1_PRCVEN * ACP.ACP_PERDES / 100)) PERCTDSC, " + Chr(13)
_cQrySB1 += "		A5_CODPRF PARTNUMBER, " + Chr(13)
_cQrySB1 += "		A5_FORNECE CODFOR, " + Chr(13)
_cQrySB1 += "		A5_NOMEFOR DSCFOR, " + Chr(13)
_cQrySB1 += "		U1_QTD QTDKIT, " + Chr(13)
_cQrySB1 += "		UG_PRODUTO KIT, " + Chr(13)
_cQrySB1 += "		Z5_DESC MARCA, " + Chr(13)
_cQrySB1 += "		SZ9.Z9_COD IDENTIFI, " + Chr(13)
_cQrySB1 += "		0 QTDESTSP, " + Chr(13)
_cQrySB1 += "		0 ARMZESSP, " + Chr(13)
_cQrySB1 += "		0 TRFESTSP, " + Chr(13)
_cQrySB1 += "		0 VDAMESSP, " + Chr(13)
_cQrySB1 += "		0 VDAANOSP, " + Chr(13)
_cQrySB1 += "		0 RESERVASP, " + Chr(13)
_cQrySB1 += "		0 PERCMESSP, " + Chr(13)
_cQrySB1 += "		0 PERCANOSP, " + Chr(13)
_cQrySB1 += "		0 DIASESTSP, " + Chr(13)
_cQrySB1 += "		0 PREVTRSP, " + Chr(13)
_cQrySB1 += "		0 TRANSFSP, " + Chr(13)
_cQrySB1 += "		0 QTDESTSC, " + Chr(13)
_cQrySB1 += "		0 ARMZESSC, " + Chr(13)
_cQrySB1 += "		0 TRFESTSC, " + Chr(13)
_cQrySB1 += "		0 VDAMESSC, " + Chr(13)
_cQrySB1 += "		0 VDAANOSC, " + Chr(13)
_cQrySB1 += "		0 RESERVASC, " + Chr(13)
_cQrySB1 += "		0 PERCMESSC, " + Chr(13)
_cQrySB1 += "		0 PERCANOSC, " + Chr(13)
_cQrySB1 += "		' ' DTULTESC, " + Chr(13)
_cQrySB1 += "		0 QTULTESC, " + Chr(13)
_cQrySB1 += "		0 EMBARCSC, " + Chr(13)
_cQrySB1 += "		0 EMBCDOSC, " + Chr(13)
_cQrySB1 += "		0 DIASESTSC, " + Chr(13)
_cQrySB1 += "		0 PREVTRSC, " + Chr(13)
_cQrySB1 += "		0 TRANSFSC, " + Chr(13)
_cQrySB1 += "		0 QTDESTVI, " + Chr(13)
_cQrySB1 += "		0 TRANSFVI, " + Chr(13)
_cQrySB1 += "		0 QTDESTVL, " + Chr(13)
_cQrySB1 += "		0 QTDEB6COM, " + Chr(13)
_cQrySB1 += "		0 QTDEB6LIS, " + Chr(13)
_cQrySB1 += "		0 QTDEB6LIN, " + Chr(13)
_cQrySB1 += "		0 ARMZB6, " + Chr(13)
_cQrySB1 += "		0 LOCSHIM, " + Chr(13)
_cQrySB1 += "		0 VDAMESES, " + Chr(13)
_cQrySB1 += "		0 VDAANOES, " + Chr(13)
_cQrySB1 += "		0 RESERVAES, " + Chr(13)
_cQrySB1 += "		0 PERCMESES, " + Chr(13)
_cQrySB1 += "		0 PERCANOES, " + Chr(13)
_cQrySB1 += "		' ' DTULTEES, " + Chr(13)
_cQrySB1 += "		0 QTULTEES, " + Chr(13)
_cQrySB1 += "		0 EMBARCES, " + Chr(13)
_cQrySB1 += "		0 EMBCDOES, " + Chr(13)
_cQrySB1 += "		0 DIAESTES, " + Chr(13)
_cQrySB1 += "		0 PRETRFES, " + Chr(13)
_cQrySB1 += "		0 TRANSFES, " + Chr(13)
_cQrySB1 += "		' ' DTULCPES, " + Chr(13)
_cQrySB1 += "		0 VLUNCPES, " + Chr(13)
_cQrySB1 += "		' ' DTULCPSC, " + Chr(13)
_cQrySB1 += "		0 VLUNCPSC, " + Chr(13)
_cQrySB1 += "		0 MULTIPLI " + Chr(13)
_cQrySB1 += "FROM " + RetSqlName("SB1") + " SB1 " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("DA1") + " DA1 ON DA1.DA1_FILIAL = '" + xFilial("DA1") + "' " + Chr(13)
_cQrySB1 += "                        AND DA1_CODPRO = B1_COD                                      " + Chr(13)
_cQrySB1 += "                        AND DA1.DA1_ESTADO = '  '                                    " + Chr(13)
_cQrySB1 += "                        AND DA1.DA1_DATVIG <= TO_CHAR(SYSDATE,'RRRRMMDD')            " + Chr(13)
_cQrySB1 += "                        AND DA1.D_E_L_E_T_ = ' '                                     " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("SA5") + " SA5 ON A5_FILIAL = '" + xFilial("SA5") + "' AND A5_PRODUTO = B1_COD AND SA5.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("SU1") + " SU1 ON U1_FILIAL = '" + xFilial("SU1") + "' AND U1_ACESSOR = B1_COD AND SU1.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("SUG") + " SUG ON UG_FILIAL = '" + xFilial("SUG") + "' AND UG_CODACE = U1_CODACE AND SUG.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("SZ5") + " SZ5 ON Z5_FILIAL = '" + xFilial("SZ5") + "' AND Z5_CODIGO = B1__MARCA AND SZ5.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("SZ9") + " SZ9 ON Z9_FILIAL = '" + xFilial("SZ9") + "' AND Z9_PRODUTO = B1_COD AND SZ9.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "LEFT JOIN " + RetSqlName("ACP") + " ACP ON ACP_FILIAL = '" + xFilial("ACP") + "' AND ACP_CODPRO = Z9_PRODUTO AND ACP.D_E_L_E_T_ = ' ' AND ACP.ACP__IDENT = SZ9.Z9_COD " + Chr(13)
_cQrySB1 += "WHERE B1_FILIAL = '" + xFilial("SB1") + "' AND SB1.D_E_L_E_T_ = ' ' " + Chr(13)
_cQrySB1 += "AND B1__SEGISP = '" + _cSegUsr + "' AND B1_COD BETWEEN '" + _cProdIni + "' AND '" + _cProdFim + "' " + Chr(13)
_cQrySB1 += "AND B1_GRUPO BETWEEN TO_NUMBER('" + _cGrpIni + "') AND TO_NUMBER('" + _cGrpFim + "') AND B1__SUBGRP BETWEEN TO_NUMBER('" + _cSubGrpIni + "') AND TO_NUMBER('" + _cSubGrpFim + "') " + Chr(13)
_cQrySB1 += "AND (DA1.DA1_DATVIG = (SELECT MAX(D.DA1_DATVIG) AS DTVIG FROM DA1010 D WHERE D.DA1_CODPRO = B1_COD AND D.DA1_ESTADO = '  ' AND D.DA1_DATVIG <= TO_CHAR(SYSDATE,'RRRRMMDD') AND D.D_E_L_E_T_ = ' ') or DA1.DA1_DATVIG is null ) "  + Chr(13)
_cQrySB1 += "ORDER BY B1_COD, SZ9.Z9_COD "

If Select("SB1Q") > 0                                                           ฆ
	DbSelectArea("SB1Q")
	DbCloseArea()
	DbSelectArea("SB1")
EndIf

TcQuery _cQrySB1 New Alias "SB1Q"
TcSetField("SB1Q", "DTULTLPR"   , "D", 08, 0)

DbSelectArea("SB1Q")
DbGoTop()
ProcRegua(RecCount())

While !Eof()
	
	IncProc()
	
	If SB1Q->ITEM $ _aProd
		_lExec := .F.
	Else
		_lExec := .T.
		_aProd += SB1Q->ITEM + "/"
	EndIf
	
	DbSelectArea("TRB1")
	While!RecLock("TRB1",.T.)
	Enddo
	TRB1->ITEM 		:= SB1Q->ITEM
	TRB1->DESC 		:= SB1Q->DESCRI
	TRB1->MARCA		:= SB1Q->MARCA
	TRB1->PARTNUMBER:= SB1Q->PARTNUMBER
	TRB1->KIT		:= SB1Q->KIT
	TRB1->QTKIT		:= SB1Q->QTDKIT
	TRB1->QTMASTER	:= SB1Q->QTDMASTER
	TRB1->UNIDADE	:= SB1Q->UNID
	
	// Estoque Filial 04 - SP
	__Filial := '04'
	
	If _lExec
		__EstoqSP:= 0
		__ReserSP:= 0
		__TransSP:= 0
		
		FunSB2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SB2Q")
		DbGotop()
	EndIf
	
	If !Eof("SB2Q") .and. _lExec
		__EstoqSP	:= U_xSldPrd2( SB2Q->FILIAL,SB2Q->ITEMX)
		__ReserSP	:= SB2Q->RESERVX
		__TransSP	:= SB2Q->TRANSITO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->ESTOQSP	:= __EstoqSP
	TRB1->ARMZESSP	:= SB1Q->ARMZESSP
	TRB1->TRFESTSP	:= __TransSP
	TRB1->RESERVSP	:= __ReserSP
	
	// Venda Filial 04  - 10/10/2014
	
	If _lExec
		__PesolSP:= 0
		__VDMesSP:= 0
		__VDAnoSP:= 0
		
		FunSD2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SD2Q")
		DbGotop()
	EndIf
	
	If !Eof("SD2Q") .and. _lExec
		__VDMesSP := SD2Q->QTVENDAMES
		__VDAnoSP := SD2Q->QTVENDAANO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->PESOLIQ	:= SB1Q->PESOLIQ //__PesolSP
	TRB1->VDAMESSP	:= __VDMesSP
	TRB1->VDAANOSP	:= __VDAnoSP
	TRB1->PVDMESSP	:= 0
	TRB1->PVDANOSP	:= 0
	
	// Dias em Estoque - Filial 04
	
	If _lExec
		__DiasEstSP := 0
		
		FunZ03Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("Z03Q")
		DbGotop()
	EndIf
	
	If !Eof("Z03Q") .and. _lExec
		__DiasEstSP	:= Z03Q->DIASZ03
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DIAESTSP	:= __DiasEstSP
	TRB1->PRETRFSP	:= 0
	TRB1->TRANSFSP	:= SB1Q->TRANSFSP
	
	//__________________________________________________________________________________________________________________________________________________________
	
	// Estoque Filial 06 - SC
	
	__Filial := '06'
	
	If _lExec
		__EstoqSC:= 0
		__ReserSC:= 0
		__TransSC:= 0
		
		FunSB2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SB2Q")
		DbGotop()
	EndIf
	
	If !Eof("SB2Q") .and. _lExec
		__EstoqSC	:= U_xSldPrd2( SB2Q->FILIAL,SB2Q->ITEMX)
		__ReserSC	:= SB2Q->RESERVX
		__TransSC	:= SB2Q->TRANSITO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->ESTOQSC	:= __EstoqSC
	TRB1->ARMZESSC	:= SB1Q->ARMZESSC
	TRB1->TRFESTSC	:= __TransSC
	TRB1->RESERVSC	:= __ReserSC
	
	// Nf Venda
	// Venda Filial 06  - 10/10/2014
	
	If _lExec
		__VDMesSC:= 0
		__VDAnoSC:= 0
		
		FunSD2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SD2Q")
		DbGotop()
	EndIf
	
	If !Eof("SD2Q") .and. _lExec
		__VDMesSC := SD2Q->QTVENDAMES
		__VDAnoSC := SD2Q->QTVENDAANO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->VDAMESSC	:= __VDMesSC
	TRB1->VDAANOSC	:= __VDAnoSC
	TRB1->PVDMESSC	:= 0
	TRB1->PVDANOSC	:= 0
	
	// Dias em Estoque - Filial 06
	
	If _lExec
		__DiasEstSC := 0
		
		FunZ03Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("Z03Q")
		DbGotop()
	EndIf
	
	If !Eof("Z03Q") .and. _lExec
		__DiasEstSC	:= Z03Q->DIASZ03
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DIAESTSC	:= __DiasEstSC
	TRB1->PRETRFSC	:= 0
	TRB1->TRANSFSC	:= SB1Q->TRANSFSC
	
	// Data Ultima Entrada / Qt. Ultim. Entrada / Embarcado / Embarcar
	
	If _lExec
		__DtUlteSC := Ctod(space(08))
		__QtUlteSC := 0
		__VrUnitSC := 0
		
		FunSD1Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SD1Q")
		DbGotop()
	EndIf
	
	If !Eof("SD1Q") .and. _lExec
		__DtUlteSC := stod(SD1Q->ENTRADA)
		__QtUlteSC := SD1Q->QTDE
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DTULTESC	:= __DtUlteSC
	TRB1->QTULTESC	:= __QtUlteSC
	
	//SOMA PEDIDO EMBARCADO E EM ABERTO NA FILIAL 06
	
	If _lExec
		__EmbCdoSc	:= 0
		
		FunSC7Q1(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SC7Q1")
		DbGotop()
	EndIf
	
	If !Eof("SC7Q1") .and. _lExec
		__EmbCdoSc	:= SC7Q1->EMBCDO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->EMBCDOSC	:= __EmbCdoSc
	
	//SOMA PEDIDO A EMBARCAR E EM ABERTO NA FILIAL 06
	
	If _lExec
		__EmbArcSc	:= 0
		
		FunSC7Q2(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SC7Q2")
		DbGotop()
	EndIf
	
	If !Eof("SC7Q2") .and. _lExec
		__EmbArcSc	:= SC7Q2->EMBARC
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->EMBARCSC	:= __EmbArcSc
	
	//EMISSAO E PREวO UNITมRIO DO ULTIMO PEDIDO A EMBARCAR NA FILIAL 06
	
	If _lExec
		__DtUlcpSc	:= Ctod(space(08))
		__VlUncpSc	:= 0
		
		FunSZ3Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SZ3Q")
		DbGotop()
	EndIf
	
	If !Eof("SZ3Q") .and. _lExec
		__DtUlcpSc	:= STOD(SZ3Q->DTULCP)
		__VlUncpSc	:= SZ3Q->VLUNCP
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DTULCPSC	:= __DtUlcpSc
	TRB1->VLUNCPSC	:= __VlUncpSc
	
	//__________________________________________________________________________________________________________________________________________________________
	
	// Estoque Filial 03 - ES
    
	__Filial := '03'
			
	If _lExec
		__EstoqES:= 0
		__ReserES:= 0
		__TransES:= 0
		__EstShim:= 0
		__LocShim:= GETMV("MV__ARMSHI")	//08
		
		FunSB2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SB2Q")
		DbGotop()
	EndIf
	
	If !Eof("SB2Q") .and. _lExec
		__EstoqES	:= U_xSldPrd2(SB2Q->FILIAL,SB2Q->ITEMX)
		__ReserES	:= SB2Q->RESERVX
		__TransES	:= SB2Q->TRANSITO
		__EstShim	:= U_xSldProd(SB2Q->FILIAL,SB2Q->ITEMX,__LocShim)
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->ESTOQES	:= __EstoqES
	TRB1->TRFESTES	:= __TransES
	TRB1->RESERVES	:= __ReserES
	
	// Nf Venda
	// Venda Filial 03 ou 05

	If _cSegUsr == '1 '		
		__Filial := '03'
	ElseIf _cSegUsr == '2 '		
		__Filial := '05'
	EndIf	
	
	If _lExec
		__VDMesES:= 0
		__VDAnoES:= 0
		
		FunSD2Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SD2Q")
		DbGotop()
	EndIf
	
	If !Eof("SD2Q") .and. _lExec
		__VDMesES := SD2Q->QTVENDAMES
		__VDAnoES := SD2Q->QTVENDAANO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->VDAMESES	:= __VDMesES
	TRB1->VDAANOES	:= __VDAnoES
	TRB1->PVDMESES	:= 0
	TRB1->PVDANOES	:= 0
	
	// Dias em Estoque - Filial 03
	
	If _lExec
		__DiasEstES := 0
		
		FunZ03Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("Z03Q")
		DbGotop()
	EndIf
	
	If !Eof("Z03Q") .and. _lExec
		__DiasEstES	:= Z03Q->DIASZ03
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DIAESTES	:= __DiasEstES
	TRB1->PRETRFES	:= 0
	TRB1->TRANSFES	:= SB1Q->TRANSFES
	
	// Data Ultima Entrada / Qt. Ultim. Entrada / Embarcado / Embarcar
	
	If _lExec
		__DtUlteES := Ctod(space(08))
		__QtUlteES := 0
		__VrUnitES := 0
		
		FunSD1Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SD1Q")
		DbGotop()
	EndIf
	
	If !Eof("SD1Q") .and. _lExec
		__DtUlteES := stod(SD1Q->ENTRADA)
		__QtUlteES := SD1Q->QTDE
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DTULTEES	:= __DtUlteES
	TRB1->QTULTEES	:= __QtUlteES
	
	//SOMA PEDIDO EMBARCADO E EM ABERTO NA FILIAL 03
	
	If _lExec
		__EmbCdoEs := 0
		
		FunSC7Q1(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SC7Q1")
		DbGotop()
	EndIf
	
	If !Eof("SC7Q1") .and. _lExec
		__EmbCdoEs := SC7Q1->EMBCDO
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->EMBCDOES	:= __EmbCdoEs
	
	//SOMA PEDIDO A EMBARCAR E EM ABERTO NA FILIAL 03
	
	If _lExec
		__EmbArcEs := 0
		
		FunSC7Q2(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SC7Q2")
		DbGotop()
	EndIf
	
	If !Eof("SC7Q2") .and. _lExec
		__EmbArcEs := SC7Q2->EMBARC
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->EMBARCES	:= __EmbArcEs
	
	//EMISSAO E PREวO UNITมRIO DO ULTIMO PEDIDO A EMBARCAR NA FILIAL 03
	
	If _lExec
		__DtUlcpEs	:= Ctod(space(08))
		__VlUncpEs	:= 0
		
		FunSZ3Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SZ3Q")
		DbGotop()
	EndIf
	
	If !Eof("SZ3Q") .and. _lExec
		__DtUlcpEs	:= STOD(SZ3Q->DTULCP)
		__VlUncpEs	:= SZ3Q->VLUNCP
	EndIf
	
	DbSelectArea("TRB1")
	TRB1->DTULCPES	:= __DtUlcpEs
	TRB1->VLUNCPES	:= __VlUncpEs


	// Estoque Filial 05 - Vitoria

	__Filial := '05'
					
	If _lExec
	__EstoqVI:= 0
	
	FunSB2Q(__Filial, SB1Q->ITEM)
	
	DbSelectArea("SB2Q")
	DbGotop()
	EndIf
	
	If !Eof("SB2Q") .and. _lExec
	__EstoqVI	:= U_xSldPrd2(SB2Q->FILIAL,SB2Q->ITEMX)
	EndIf

	
	// Poder de terceiros - 13/10/2014

	__Filial := '03,05'
			
	If _lExec
		__QtdeB6Com := 0
		__QtdeB6Lis := 0
		__QtdeB6Lin := 0
		
		FunSB6Q(__Filial, SB1Q->ITEM)
		
		DbSelectArea("SB6Q")
		DbGotop()
	EndIf
	
	If !Eof() .and. _lExec
		__CFLCOM := GETMV("MV__CFLCOM")
		__CFLLIS := GETMV("MV__CFLLIS")
		__CFLLIN := GETMV("MV__CFLLIN")
	EndIf
	
	While !Eof("SB6Q") .and. _lExec
		If ALLTRIM(SB6Q->CLIFOR)+ALLTRIM(SB6Q->LOJA) $ __CFLCOM
			__QtdeB6Com += SB6Q->SALDO
		ElseIF ALLTRIM(SB6Q->CLIFOR)+ALLTRIM(SB6Q->LOJA) $ __CFLLIS
			__QtdeB6Lis += SB6Q->SALDO
		ElseIF ALLTRIM(SB6Q->CLIFOR)+ALLTRIM(SB6Q->LOJA) $ __CFLLIN
			__QtdeB6Lin += SB6Q->SALDO
		Endif
		DbSelectArea("SB6Q")
		dbSkip()
	Enddo
	
	DbSelectArea("TRB1")
	TRB1->ESTOQCOM	:= __QtdeB6Com
	TRB1->ESTOQLIS	:= __QtdeB6Lis
	TRB1->ESTOQLIN	:= __QtdeB6Lin
	TRB1->ESTOQGER	:= __QtdeB6Com + __QtdeB6Lis + __QtdeB6Lin
	TRB1->ESTOQSHI	:= __EstShim
	TRB1->ESTOQVAL	:= __EstoqVI
	TRB1->IDENTIFI	:= SB1Q->IDENTIFI
	TRB1->STATUSX	:= SB1Q->STATUSX
	TRB1->CODFOR	:= SB1Q->CODFOR
	TRB1->DSCFOR	:= SB1Q->DSCFOR
	TRB1->DTULTLPR	:= SB1Q->DTULTLPR //__DtultLpr
	TRB1->LISTAPRC	:= SB1Q->LISTAPRC //__ListaPrc
	TRB1->PERCTDSC	:= SB1Q->PERCTDSC //__PerctDsc
	TRB1->MULTIPLI	:= SB1Q->MULTIPLI
	MsUnLock()
	
	DbSelectArea("SB1Q")
	DbSkip()
	
Enddo

DbSelectArea("TRB1")
Dbgotop()

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAbreHtml  บAutor  ณSilverio Bastos     บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Funcoes para Integracao com o Excel                        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Isapa                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function AbreHtml()
Local cCabHtml 		:= ""
Local cFileCont 	:= ""
//monta cabe็alho de pagina HTML para posterior utiliza็ใo
cCabHtml := "<!-- Created with AEdiX by Kirys Tech 2000,http://www.kt2k.com --> " + CRLF
cCabHtml += "<!DOCTYPE html PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>" + CRLF
cCabHtml += "<html>" + CRLF
cCabHtml += "<head>" + CRLF
cCabHtml += "  <title>teste</title>" + CRLF
cCabHtml += "  <meta name='GENERATOR' content='AEdiX by Kirys Tech 2000,http://www.kt2k.com'>" + CRLF
cCabHtml += "</head>" + CRLF
cCabHtml += "<body bgcolor='#FFFFFF'>" + CRLF
cCabHtml += "" + CRLF
cFileCont := cCabHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif
Return nil

Static Function fecHtml()
Local cRodHtml 	:= ""
Local cFileCont	:= ""
// Monta Rodape Html para posterior utiliza็ao
cRodHtml := "</body>" + CRLF
cRodHtml += "</html>" + CRLF
cFileCont := cRodHtml

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return nil

Static Function PutHtml(aConteudo, nTipo, nBold)
Local cLinFile 	:= ""
Local cFileCont := ""
Local nXb 		:= 0
Default nBold 	:= 0
Default nTipo	:= 2

//Aqui come็a a montagem da pagina html propriamente dita
// acrescenta o cabe็alho
If nTipo == 1
	cLinFile += "<Table style='background: #FFFFFF; width: 100%;' border='1' cellpadding='2' cellspacing='2'>"
EndIf

cLinFile += "<TR>"

For nXb := 1 to Len(aConteudo)
	cLinFile += "<TD style='Background: #FFFFC0; font-style: Bold;'>"
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += Alltrim(aConteudo[nXb])
	if nBold == 1
		cLinFile += "<b>"
	Endif
	cLinFile += "</TD>"
next nXb
cLinFile += "</TR>" + CRLF

If nTipo == 3
	cLinFile += "</Table>"
EndIf

cFileCont := cLinFile

If fWrite(nHdl1,cFileCont,Len(cFileCont)) <> Len(cFileCont)
	apMsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
Endif

Return nil


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCriaPlan  บAutor  ณSilverio Bastos     บ Data ณ  13/10/14   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria Planilha Excel com Base na Query                       บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Isapa                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaPlan()

Local nPrcUnit	:= 0
Local nVlrEmb	:= 0
Local nComissao := 0
Local aAreaSB1	:= 0
Local aEstru	:= {}
Local _i
Local cArq		:= "ICOMR04"
Private nHdl1    := 0

If Empty(_cDest)
	_cDest  := "C:\ICOMR04_" + Substr(DTOS(Date()),7,2) + "_" + Substr(DTOS(Date()),5,2) + "_" + Substr(DTOS(Date()),1,4) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
	_cDrive := "C:\"
Else
	_cDrive := _cDest
	_cDest  += Substr(DTOS(Date()),7,2) + "_" + Substr(DTOS(Date()),5,2) + "_" + Substr(DTOS(Date()),1,4) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
	//	_cDest  += "ICOMR04_" + DTOS(Date()) + "_" + SubStr(Time(),1,2) + SubStr(Time(),4,2) + SubStr(Time(),7,2) + ".xls"
EndIf

//nhdl1 := fCreate( _cDest,0)

If nHdl1 == -1
	ApMsgAlert("O arquivo nao pode ser executado! Verifique os parametros.","Atencao!")
	Return NIL
Endif

/*
AbreHtml()
// Calculo Periodo em dias uteis
_Periodo1	:= _DUteisA(MV_PAR07,MV_PAR08)
_Periodo2	:= _DUteisA(MV_PAR09,MV_PAR10)
_dtHoje		:= dDatabase
_dt1ANO		:= dDatabase - 365
_dt2ANO		:= _dt1ANO - 365

PutHtml({"Periodo 1",Subst(dtos(MV_PAR07),7,2)+"/"+Subst(dtos(MV_PAR07),5,2)+"/"+Subst(dtos(MV_PAR07),1,4),Subst(dtos(MV_PAR08),7,2)+"/"+Subst(dtos(MV_PAR08),5,2)+"/"+Subst(dtos(MV_PAR08),1,4),;
Transform(_Periodo1,"@E 999"),"Dias","","Hoje:",Subst(dtos(_dtHoje),7,2)+"/"+Subst(dtos(_dtHoje),5,2)+"/"+Subst(dtos(_dtHoje),1,4)},1,1)
PutHtml({"Periodo 2",Subst(dtos(MV_PAR09),7,2)+"/"+Subst(dtos(MV_PAR09),5,2)+"/"+Subst(dtos(MV_PAR09),1,4),Subst(dtos(MV_PAR10),7,2)+"/"+Subst(dtos(MV_PAR10),5,2)+"/"+Subst(dtos(MV_PAR10),1,4),;
Transform(_Periodo2,"@E 999"),"Dias","","1 Ano",Subst(dtos(_dt1ANO),7,2)+"/"+Subst(dtos(_dt1ANO),5,2)+"/"+Subst(dtos(_dt1ANO),1,4)},1,1)
PutHtml({"Previsใo de Estoque","","","","Dias","","2 Ano",Subst(dtos(_dt2ANO),7,2)+"/"+Subst(dtos(_dt2ANO),5,2)+"/"+Subst(dtos(_dt2ANO),1,4)},1,1)
PutHtml({""},1,1)

If lImpTudo
	PutHtml({"Item","Descri็ใo","Marca","Part Number","Kit","Qtd no Kit","Master","Un.","Peso Liquido", "Estoque","Armazem ES > SP","Transf. Estoque",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Dias Estoque","Previsใo Transf.","Transf.","Estoque","Armazem ES > SC","Transf. Estoque",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Ultima Entrada","Qtd.Ultima Entrada","Embarcado","Embarcar","Dias Estoque","Previsใo Transf.",;
	"Transf.","Estoque","Transf.Estoque","Estoque Local 5","Cometa","Lisa","Lisa Novo","Armazem","Montagem Shimano",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Ultima Entrada","Qtd.Ultima Entrada","Embarcado","Embarcar","Dias Estoque","Previsใo Transf.",;
	"Transf.","Ultima ES Compra","FOB ES","Ultima SC Compra","FOB SC","Ultima Altera็ใo","Tabela Pre็o","Lista Pre็o","Pre็o c/Desconto","Multip.","Status",;
	"Cod.Exp.","Exportador","SP","SC","ES","Comprado","Comprar","Total Estoque" },1,1)
Else
	PutHtml({"Item","Descri็ใo","Marca","Part Number","Kit","Qtd no Kit","Master","Un.","Peso Liquido", "Estoque","Armazem ES > SP","Transf. Estoque",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Dias Estoque","Previsใo Transf.","Transf.","Estoque","Armazem ES > SC","Transf. Estoque",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Ultima Entrada","Qtd.Ultima Entrada","Embarcado","Embarcar","Dias Estoque","Previsใo Transf.",;
	"Transf.","Estoque","Transf.Estoque","Estoque Local 5","Cometa","Lisa","Lisa Novo","Armazem","Montagem Shimano",;
	"Venda P1","Venda P2","Reserva","% P1 Venda","% P2 Venda","Ultima Entrada","Qtd.Ultima Entrada","Embarcado","Embarcar","Dias Estoque","Previsใo Transf.",;
	"Transf."},1,1)
	
EndIf
*/

MontaQry()

dbSelectArea("TRB1")
dbGotop()
            

//If MsgYesNo("Gera o Arquivo para Planilha Excel ?")

//	_cDest 		:= cGetFile("Arquivos xls|*.XLS","Selecione o Diretorio onde o arquivo ICOMR04 sera salvo",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)	
	
	if Empty(_cDest)
		Return
	EndIf
	
	While !__CopyFile(_cArq1 + GetDBExtension(),_cDest)
		
		If !MsgYesNo("Erro na C๓pia do Arquivo. Tenta novamente?")
			Exit
		EndIf
		_cDest 		:= cGetFile("Arquivos xls|*.XLS","Selecione o Diretorio onde o arquivo ICOMR04 sera salvo",0,"C:\",.F.,GETF_LOCALFLOPPY+GETF_NETWORKDRIVE+GETF_LOCALHARD+GETF_RETDIRECTORY)
	Enddo

//EndIf

/*
While !TRB1->(EOF())
	
	__ItEstq1	:= TRB1->ITEM
	__ItEstq2 	:= TRB1->DESC
	__ItEstq3 	:= TRB1->MARCA
	__ItEstq4 	:= TRB1->PARTNUMBER
	__ItEstq5 	:= TRB1->KIT
	__ItEstq6 	:= TRB1->QTKIT
	__ItEstq7 	:= TRB1->QTMASTER
	__ItEstq8 	:= TRB1->UNIDADE
	__ItEstq9 	:= TRB1->PESOLIQ
	__ItEstq10 	:= TRB1->ESTOQSP
	__ItEstq11 	:= TRB1->ARMZESSP
	__ItEstq12 	:= TRB1->TRFESTSP
	__ItEstq13 	:= TRB1->VDAMESSP
	__ItEstq14 	:= TRB1->VDAANOSP
	__ItEstq15 	:= TRB1->RESERVSP
	__ItEstq16 	:= TRB1->PVDMESSP
	__ItEstq17 	:= TRB1->PVDANOSP
	__ItEstq18 	:= TRB1->DIAESTSP
	__ItEstq19 	:= TRB1->PRETRFSP
	__ItEstq20 	:= TRB1->TRANSFSP
	__ItEstq21 	:= TRB1->ESTOQSC
	__ItEstq22 	:= TRB1->ARMZESSC
	__ItEstq23 	:= TRB1->TRFESTSC
	__ItEstq24 	:= TRB1->VDAMESSC
	__ItEstq25	:= TRB1->VDAANOSC
	__ItEstq26	:= TRB1->RESERVSC
	__ItEstq27	:= TRB1->PVDMESSC
	__ItEstq28	:= TRB1->PVDANOSC
	__ItEstq29	:= TRB1->DTULTESC
	__ItEstq30	:= TRB1->QTULTESC
	__ItEstq31	:= TRB1->EMBCDOSC
	__ItEstq32	:= TRB1->EMBARCSC
	__ItEstq33	:= TRB1->DIAESTSC
	__ItEstq34	:= TRB1->PRETRFSC
	__ItEstq35	:= TRB1->TRANSFSC
	__ItEstq36	:= TRB1->ESTOQES
	__ItEstq37	:= TRB1->TRFESTES
	__ItEstq38	:= TRB1->ESTOQVAL	//Estoque Local 5
	__ItEstq39	:= TRB1->ESTOQCOM	//Cometa
	__ItEstq40	:= TRB1->ESTOQLIS	//Lisa
	__ItEstq41	:= TRB1->ESTOQLIN	//Lisa Novo
	__ItEstq42	:= TRB1->ESTOQGER	//Armazem
	__ItEstq43	:= TRB1->ESTOQSHI	//Montagem Shimano            ?
	__ItEstq44	:= TRB1->VDAMESES	//Venda P1
	__ItEstq45	:= TRB1->VDAANOES	//Venda P2
	__ItEstq46	:= TRB1->RESERVES	//Reserva
	__ItEstq47	:= TRB1->PVDMESES	//% P1 Venda 	//ESTA JOGANDO 0
	__ItEstq48	:= TRB1->PVDANOES	//% P2 Venda 	//ESTA JOGANDO 0
	__ItEstq49	:= TRB1->DTULTEES	//Ultima Entrada
	__ItEstq50	:= TRB1->QTULTEES	//Qtd.Ultima Entrada
	__ItEstq51	:= TRB1->EMBCDOES	//Embarcado
	__ItEstq52	:= TRB1->EMBARCES	//Embarcar
	__ItEstq53	:= TRB1->DIAESTES	//Dias Estoque
	__ItEstq54	:= TRB1->PRETRFES	//Previsใo Transf. 	//ESTA JOGANDO 0
	__ItEstq55	:= TRB1->TRANSFES	//Transf.
	//RESTRINGIR A PARTIR DAQUI
	If lImpTudo
		__ItEstq56	:= TRB1->DTULCPES
		__ItEstq57	:= TRB1->VLUNCPES	//FOB ES
		__ItEstq58	:= TRB1->DTULCPSC
		__ItEstq59	:= TRB1->VLUNCPSC	//FOB SC
		__ItEstq60	:= TRB1->DTULTLPR
		__ItEstq61	:= TRB1->IDENTIFI
		__ItEstq62	:= TRB1->LISTAPRC
		__ItEstq63	:= TRB1->PERCTDSC
		__ItEstq64	:= TRB1->MULTIPLI
		__ItEstq65	:= TRB1->STATUSX
		__ItEstq66	:= TRB1->CODFOR
		__ItEstq67	:= TRB1->DSCFOR
		__ItEstq68	:= 0
		__ItEstq69	:= 0
		__ItEstq70	:= 0
		__ItEstq71	:= 0
		__ItEstq72	:= 0
		__ItEstq73	:= 0
	EndIf
	
	
	If lImpTudo
		PutHtml({__ItEstq1,;
		__ItEstq2,;
		__ItEstq3,;
		__ItEstq4,;
		__ItEstq5,;
		Transform(__ItEstq6,"@E 999"),;
		Transform(__ItEstq7,"@E 99999"),;
		__ItEstq8,;
		Transform(__ItEstq9,"@E 999999.999"),;
		Transform(__ItEstq10,"@E 9999999999999999.999"),;
		Transform(__ItEstq11,"@E 999999.999"),;
		Transform(__ItEstq12,"@E 999999.999"),;
		Transform(__ItEstq13,"@E 999999.999"),;
		Transform(__ItEstq14,"@E 999999.999"),;
		Transform(__ItEstq15,"@E 999999.999"),;
		Transform(__ItEstq16,"@E 99.99"),;
		Transform(__ItEstq17,"@E 99.99"),;
		Transform(__ItEstq18,"@E 9999"),;
		Transform(__ItEstq19,"@E 999999.999"),;
		Transform(__ItEstq20,"@E 999999.999"),;
		Transform(__ItEstq21,"@E 9999999999999999.999"),;
		Transform(__ItEstq22,"@E 999999.999"),;
		Transform(__ItEstq23,"@E 999999.999"),;
		Transform(__ItEstq24,"@E 999999.999"),;
		Transform(__ItEstq25,"@E 999999.999"),;
		Transform(__ItEstq26,"@E 999999.999"),;
		Transform(__ItEstq27,"@E 99.99"),;
		Transform(__ItEstq28,"@E 99.99"),;
		Transform(IIf(!Empty(__ItEstq29),__ItEstq29,""),"@E 999999.999"),;
		Transform(__ItEstq30,"@E 999999.999"),;
		Transform(__ItEstq31,"@E 9999999999999999.999"),;
		Transform(__ItEstq32,"@E 9999999999999999.999"),;
		Transform(__ItEstq33,"@E 9999"),;
		Transform(__ItEstq34,"@E 999999.999"),;
		Transform(__ItEstq35,"@E 999999.999"),;
		Transform(__ItEstq36,"@E 9999999999999999.999"),;
		Transform(__ItEstq37,"@E 999999.999"),;
		Transform(__ItEstq38,"@E 9999999999999999.999"),;
		Transform(__ItEstq39,"@E 9999999999999999.999"),;
		Transform(__ItEstq40,"@E 9999999999999999.999"),;
		Transform(__ItEstq41,"@E 9999999999999999.999"),;
		Transform(__ItEstq42,"@E 9999999999999999.999"),;
		Transform(__ItEstq43,"@E 9999999999999999.999"),;
		Transform(__ItEstq44,"@E 999999.999"),;
		Transform(__ItEstq45,"@E 999999.999"),;
		Transform(__ItEstq46,"@E 999999.999"),;
		Transform(__ItEstq47,"@E 99.99"),;
		Transform(__ItEstq48,"@E 99.99"),;
		Transform(IIf(!Empty(__ItEstq49),__ItEstq49,""),"@E 999999.999"),;
		Transform(__ItEstq50,"@E 999999.999"),;
		Transform(__ItEstq51,"@E 9999999999999999.999"),;
		Transform(__ItEstq52,"@E 9999999999999999.999"),;
		Transform(__ItEstq53,"@E 9999"),;
		Transform(__ItEstq54,"@E 999999.999"),;
		Transform(__ItEstq55,"@E 999999.999"),;
		Transform(IIf(!Empty(__ItEstq56),__ItEstq56,""),"@E 999999.999"),;
		Transform(__ItEstq57,PesqPict("SD1","D1_VUNIT")),;
		Transform(IIf(!Empty(__ItEstq58),__ItEstq58,""),"@E 999999.999"),;
		Transform(__ItEstq59,PesqPict("SD1","D1_VUNIT")),;
		Transform(IIf(!Empty(__ItEstq60),__ItEstq60,""),"@E 999999.999"),;
		__ItEstq61,;
		Transform(__ItEstq62,"@E 999999.99"),;
		Transform(__ItEstq63,"@E 999999.99"),;
		Transform(__ItEstq64,"@E 999999.999"),;
		__ItEstq65,;
		__ItEstq66,;
		__ItEstq67,;
		Transform(__ItEstq68,"@E 999999.999"),;
		Transform(__ItEstq69,"@E 999999.999"),;
		Transform(__ItEstq70,"@E 999999.999"),;
		Transform(__ItEstq71,"@E 999999.999"),;
		Transform(__ItEstq72,"@E 999999.999"),;
		Transform(__ItEstq73,"@E 999999.999")})
	Else
		PutHtml({__ItEstq1,;
		__ItEstq2,;
		__ItEstq3,;
		__ItEstq4,;
		__ItEstq5,;
		Transform(__ItEstq6,"@E 999"),;
		Transform(__ItEstq7,"@E 999"),;
		__ItEstq8,;
		Transform(__ItEstq9,"@E 999999.999"),;
		Transform(__ItEstq10,"@E 9999999999999999.999"),;
		Transform(__ItEstq11,"@E 999999.999"),;
		Transform(__ItEstq12,"@E 999999.999"),;
		Transform(__ItEstq13,"@E 999999.999"),;
		Transform(__ItEstq14,"@E 999999.999"),;
		Transform(__ItEstq15,"@E 999999.999"),;
		Transform(__ItEstq16,"@E 99.99"),;
		Transform(__ItEstq17,"@E 99.99"),;
		Transform(__ItEstq18,"@E 9999"),;
		Transform(__ItEstq19,"@E 999999.999"),;
		Transform(__ItEstq20,"@E 999999.999"),;
		Transform(__ItEstq21,"@E 9999999999999999.999"),;
		Transform(__ItEstq22,"@E 999999.999"),;
		Transform(__ItEstq23,"@E 999999.999"),;
		Transform(__ItEstq24,"@E 999999.999"),;
		Transform(__ItEstq25,"@E 999999.999"),;
		Transform(__ItEstq26,"@E 999999.999"),;
		Transform(__ItEstq27,"@E 99.99"),;
		Transform(__ItEstq28,"@E 99.99"),;
		Transform(IIf(!Empty(__ItEstq29),__ItEstq29,""),"@E 999999.999"),;
		Transform(__ItEstq30,"@E 999999.999"),;
		Transform(__ItEstq31,"@E 9999999999999999.999"),;
		Transform(__ItEstq32,"@E 9999999999999999.999"),;
		Transform(__ItEstq33,"@E 9999"),;
		Transform(__ItEstq34,"@E 999999.999"),;
		Transform(__ItEstq35,"@E 999999.999"),;
		Transform(__ItEstq36,"@E 9999999999999999.999"),;
		Transform(__ItEstq37,"@E 999999.999"),;
		Transform(__ItEstq38,"@E 9999999999999999.999"),;
		Transform(__ItEstq39,"@E 999999.999"),;
		Transform(__ItEstq40,"@E 9999999999999999.999"),;
		Transform(__ItEstq41,"@E 9999999999999999.999"),;
		Transform(__ItEstq42,"@E 9999999999999999.999"),;
		Transform(__ItEstq43,"@E 9999999999999999.999"),;
		Transform(__ItEstq44,"@E 999999.999"),;
		Transform(__ItEstq45,"@E 999999.999"),;
		Transform(__ItEstq46,"@E 999999.999"),;
		Transform(__ItEstq47,"@E 99.99"),;
		Transform(__ItEstq48,"@E 99.99"),;
		Transform(IIf(!Empty(__ItEstq49),__ItEstq49,""),"@E 999999.999"),;
		Transform(__ItEstq50,"@E 999999.999"),;
		Transform(__ItEstq51,"@E 9999999999999999.999"),;
		Transform(__ItEstq52,"@E 9999999999999999.999"),;
		Transform(__ItEstq53,"@E 9999"),;
		Transform(__ItEstq54,"@E 999999.999"),;
		Transform(__ItEstq55,"@E 999999.999")})
	EndIf
	TRB1->(dbSkip())
	
Enddo
*/

If Select("TRB1") > 0
	DbSelectArea("TRB1")
	DbCloseArea()
EndIf

If Select("SC7Q1") > 0
	DbSelectArea("SC7Q1")
	DbCloseArea()
EndIf

If Select("SC7Q2") > 0
	DbSelectArea("SC7Q2")
	DbCloseArea()
EndIf

If Select("SZ3Q") > 0
	DbSelectArea("SZ3Q")
	DbCloseArea()
EndIf

If Select("SB6Q") > 0
	DbSelectArea("SB6Q")
	DbCloseArea()
EndIf

If Select("SB2Q") > 0
	DbSelectArea("SB2Q")
	DbCloseArea()
EndIf

If Select("SB1Q") > 0
	DbSelectArea("SB1Q")
	DbCloseArea()
EndIf

If Select("SD2Q") > 0
	DbSelectArea("SD2Q")
	DbCloseArea()
EndIf

If Select("SD1Q") > 0
	DbSelectArea("SD1Q")
	DbCloseArea()
EndIf

If Select("Z03Q") > 0
	DbSelectArea("Z03Q")
	DbCloseArea()
EndIf

//TRB1->(dbCloseArea()) //fecha o SD2Q da query
//PutHtml({" ", " ", " "," ", " "," "," "," ", " "," ", " "," ", " "," "," "," "," "," " },3,0)
//FecHtml()
fClose(nHdl1)

If File(_cDest)
	MsgInfo("Arquivo de ESTOQUE ISAPA gerado com sucesso em " + _cDest)
	shellExecute("Open", _cDest, "", "C:\", 1 )
Else
	MsgStop("Nใo foi possํvel gravar o arquivo ESTOQUE ISAPA.")
EndIf


//MsgInfo("Termino de Processamento !!!")

Return

/*
+------------+-----------+--------+----------------+------+---------------+
| Fun็ใo:    | _fValPerg | Autor: | Silverio Bastos| Data:|Fevereiro/2014 |
+------------+-----------+--------+----------------+------+---------------+
| Descri็ใo: | Grava Perguntas para o Relat๓rio                           |
+------------+------------------------------------------------------------+
*/

Static Function _fValPerg()

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg + "01",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "A Partir do Grupo "
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 04
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_F3      := "SBMGSE"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "02",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Ate o Grupo ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 04
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_F3      := "SBMGSE"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "03",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "A Partir do Sub-Grupo "
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 04
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3      := "SZ4SEG"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "04",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Ate o Sub-Grupo "
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 04
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3      := "SZ4SEG"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "05",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "A Partir do Item "
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par05"
	SX1->X1_F3      := "SB1LIK"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "06",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Ate o Item "
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 15
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par06"
	SX1->X1_F3      := "SB1LIK"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "07",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Periodo Vda Mes de ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par07"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "08",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Periodo Vda Mes ate ?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par08"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "09",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Periodo Vda Ano de ?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par09"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "10",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Periodo Vda Ano ate ?"
	SX1->X1_VARIAVL := "mv_cha"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par10"
	MsUnLock()
	
EndIf

Return

/*
+------------+-----------+--------+----------------+------+-------------+
| Fun็ใo:    | _DUteisA  | Autor: | Silverio Bastos| Data:|Outubro/2014 |
+------------+-----------+--------+----------------+------+-------------+
| Descri็ใo: | Gera o numero de dias uteis de um periodo                |
+------------+----------------------------------------------------------+
*/

Static Function _DUteisA(dtINI, dtFIM)

_dtIni  := dtINI
_dtFim  := dtFIM
dDTMov  := _dtIni
nDUtil  := 0

For ix:= 1 to _dtFim - _dtIni
	
	If DataValida(dDTMov) == dDTMov
		nDUtil := nDUtil + 1
	Endif
	dDTMov := dDTMov + 1
	
Next ix

Return(nDUtil)

*------------------------------------------------------------------------------
Static function fAtuSx1A(cPerg,aRegs)
*------------------------------------------------------------------------------
local _nOrdSx1:=sx1->(indexord()),;
_nRecSx1:=sx1->(recno()),_nVez,_lApaga:=.f.,_nPergs:=0

sx1->(dbsetorder(1))
// Verifica se o formato solicitado ainda e o mesmo, caso contrario,
// apaga e inclui tudo novamente
For _nVez:=1 to Len(aRegs)
	If sx1->(DbSeek(cPerg+aRegs[_nVez,2],.f.))
		_nPergs++
		if alltrim(sx1->x1_pergunt)<>alltrim(aRegs[_nVez,3])
			_lApaga:=.t.
			exit
		endif
	endif
next
if _nPergs<>len(aRegs).or._lApaga
	sx1->(DbSeek(cPerg,.f.))
	do while sx1->(!eof().and.x1_grupo==aRegs[1,1])
		if sx1->(reclock(alias(),.f.))
			sx1->(dbdelete())
			sx1->(msunlock())
		endif
		sx1->(dbskip(1))
	enddo
endif

For _nVez:=1 to Len(aRegs)
	If !sx1->(DbSeek(cPerg+aRegs[_nVez,2],.f.))
		sx1->(RecLock(alias(),.T.))
		sx1->X1_GRUPO  :=aRegs[_nVez,01]
		sx1->X1_ORDEM  :=aRegs[_nVez,02]
		sx1->X1_PERGUNT:=aRegs[_nVez,03]
		sx1->X1_VARIAVL:=aRegs[_nVez,04]
		sx1->X1_TIPO   :=aRegs[_nVez,05]
		sx1->X1_TAMANHO:=aRegs[_nVez,06]
		sx1->X1_DECIMAL:=aRegs[_nVez,07]
		sx1->X1_PRESEL :=aRegs[_nVez,08]
		sx1->X1_GSC    :=aRegs[_nVez,09]
		sx1->X1_VALID  :=aRegs[_nVez,10]
		sx1->X1_VAR01  :=aRegs[_nVez,11]
		sx1->X1_DEF01  :=aRegs[_nVez,12]
		sx1->X1_CNT01  :=aRegs[_nVez,13]
		sx1->X1_VAR02  :=aRegs[_nVez,14]
		sx1->X1_DEF02  :=aRegs[_nVez,15]
		sx1->X1_CNT02  :=aRegs[_nVez,16]
		sx1->X1_VAR03  :=aRegs[_nVez,17]
		sx1->X1_DEF03  :=aRegs[_nVez,18]
		sx1->X1_CNT03  :=aRegs[_nVez,19]
		sx1->X1_VAR04  :=aRegs[_nVez,20]
		sx1->X1_DEF04  :=aRegs[_nVez,21]
		sx1->X1_CNT04  :=aRegs[_nVez,22]
		sx1->X1_VAR05  :=aRegs[_nVez,23]
		sx1->X1_DEF05  :=aRegs[_nVez,24]
		sx1->X1_CNT05  :=aRegs[_nVez,25]
		sx1->X1_F3     :=aRegs[_nVez,26]
		sx1->(MsUnlock())
	Endif
Next
sx1->(dbgoto(_nRecSx1))
sx1->(dbsetorder(_nOrdSx1))
Return


Static Function FunSB2Q(_cFilial, _cCodPro)

Local _cQrySB2 := ""

_cQrySB2 := "SELECT B2_FILIAL FILIAL, B2_COD ITEMX, SUM(B2_RESERVA) RESERVX, SUM(B2__QTDTRA) TRANSITO "
_cQrySB2 += "FROM " + RetSqlName("SB2") + " SB2 "
_cQrySB2 += "WHERE "
_cQrySB2 += "B2_FILIAL = '" + _cFilial + "' "
_cQrySB2 += "AND B2_COD = '" + _cCodPro + "' "
_cQrySB2 += "AND B2_LOCAL IN (" + _cLocal + ") "
_cQrySB2 += "AND SB2.D_E_L_E_T_ = ' ' "
_cQrySB2 += "GROUP BY B2_FILIAL, B2_COD "
_cQrySB2 += "ORDER BY B2_FILIAL, B2_COD "

If Select("SB2Q") > 0
	DbSelectArea("SB2Q")
	DbCloseArea()
EndIf

TcQuery _cQrySB2 New Alias "SB2Q"

Return



Static Function FunSD2Q(_cFilial, _cCodPro)

Local _cQrySD2 := ""

_cQrySD2 := "SELECT DISTINCT D2_FILIAL FILIAL, D2_COD ITEMX, "
_cQrySD2 += "(SELECT SUM(D2_QUANT) "
_cQrySD2 += "FROM " + RetSQLName("SD2") + " SD2 "
_cQrySD2 += "INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND  F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' ' "
_cQrySD2 += "INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' "
_cQrySD2 += "WHERE D2_FILIAL = '" + _cFilial  + "' "
_cQrySD2 += "AND D2_COD = '" + _cCodPro  + "' "
_cQrySD2 += "AND D2_LOCAL IN (" + _cLocal + ") "
_cQrySD2 += "AND D2_TIPO = 'N' "
_cQrySD2 += "AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
_cQrySD2 += "AND SD2.D_E_L_E_T_ = ' ' ) QTVENDAMES, "
_cQrySD2 += "(SELECT SUM(D2_QUANT) "
_cQrySD2 += "FROM " + RetSQLName("SD2") + " SD2 "
_cQrySD2 += "INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND  F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' ' "
_cQrySD2 += "INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' "
_cQrySD2 += "WHERE D2_FILIAL = '" + _cFilial  + "' "
_cQrySD2 += "AND D2_COD = '" + _cCodPro  + "' "
_cQrySD2 += "AND D2_LOCAL IN (" + _cLocal + ") "
_cQrySD2 += "AND D2_TIPO = 'N' "
_cQrySD2 += "AND D2_EMISSAO BETWEEN '" + DTOS(MV_PAR09) + "' AND '" + DTOS(MV_PAR10) + "' "
_cQrySD2 += "AND SD2.D_E_L_E_T_ = ' ' ) QTVENDAANO "
_cQrySD2 += "FROM " + RetSQLName("SD2") + " SD2 "
_cQrySD2 += "INNER JOIN " + RetSQLName("SF4") + " F4 ON F4_FILIAL = D2_FILIAL AND F4_CODIGO = D2_TES AND  F4_ESTOQUE = 'S' AND F4_DUPLIC = 'S' AND F4.D_E_L_E_T_ = ' ' "
_cQrySD2 += "INNER JOIN " + RetSQLName("SA1") + " A1 ON A1_FILIAL = '" +xFilial("SA1")+ "' AND A1_COD = D2_CLIENTE AND A1_LOJA = D2_LOJA AND A1.D_E_L_E_T_ = ' ' "
_cQrySD2 += "WHERE D2_FILIAL = '" + _cFilial  + "' "
_cQrySD2 += "AND D2_COD = '" + _cCodPro  + "' "
_cQrySD2 += "AND D2_LOCAL IN (" + _cLocal + ") "
_cQrySD2 += "AND D2_TIPO = 'N' "
_cQrySD2 += "AND SD2.D_E_L_E_T_ = ' ' "
_cQrySD2 += "ORDER BY D2_FILIAL, D2_COD "

If Select("SD2Q") > 0
	DbSelectArea("SD2Q")
	DbCloseArea()
EndIf

TcQuery _cQrySD2 New Alias "SD2Q"

Return



///////////////////////////////
// ESTOQUE ZERADO
///////////////////////////////

Static Function FunZ03Q(_cFilial, _cCodPro)

Local _cQryZ03 := ""

_cQryZ03 := "SELECT Z03_FILIAL, Z03_COD, COUNT(*) DIASZ03 "
_cQryZ03 += "FROM " + RetSqlName("Z03") + " Z03 "
_cQryZ03 += "WHERE Z03_FILIAL = '" + _cFilial  + "' "
_cQryZ03 += "AND Z03_COD = '" + _cCodPro + "' "
_cQryZ03 += "AND Z03_LOCAL IN (" + _cLocal + ") "
_cQryZ03 += "AND Z03_DATA BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
_cQryZ03 += "AND Z03.D_E_L_E_T_ = ' ' "
_cQryZ03 += "GROUP BY Z03_FILIAL, Z03_COD "
_cQryZ03 += "ORDER BY Z03_FILIAL, Z03_COD "

If Select("Z03Q") > 0
	DbSelectArea("Z03Q")
	DbCloseArea()
EndIf

TcQuery _cQryZ03 New Alias "Z03Q"

Return



Static Function FunSD1Q(_cFilial, _cCodPro)

Local _cQrySD1 := ""

_cQrySD1 := "SELECT D1_FILIAL FILIAL, D1_COD PRODCOD, D1_DTDIGIT ENTRADA, D1_VUNIT VUNIT, SUM(D1_QUANT) QTDE FROM "+ RetSqlName("SD1") + " SD1 "
_cQrySD1 += "INNER JOIN "+ RetSqlName("SF4") + " SF4 ON F4_FILIAL = D1_FILIAL AND F4_CODIGO = D1_TES  AND F4_ESTOQUE = 'S' AND SF4.D_E_L_E_T_ = ' ' "
_cQrySD1 += "WHERE D1_FILIAL = '" + _cFilial  + "' "
_cQrySD1 += "AND D1_COD = '" + _cCodPro + "' "
_cQrySD1 += "AND D1_LOCAL IN (" + _cLocal + ") "
_cQrySD1 += "AND D1_DTDIGIT BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
_cQrySD1 += "AND SD1.D_E_L_E_T_ = ' ' "
_cQrySD1 += "GROUP BY D1_FILIAL, D1_COD, D1_DTDIGIT, D1_VUNIT "
_cQrySD1 += "ORDER BY D1_FILIAL, D1_COD, D1_DTDIGIT DESC, D1_VUNIT "

If Select("SD1Q") > 0
	DbSelectArea("SD1Q")
	DbCloseArea()
EndIf

TcQuery _cQrySD1 New Alias "SD1Q"

Return



Static Function FunSC7Q1(_cFilial, _cCodPro)

Local _cQrySC71 := ""

_cQrySC71 := "SELECT SUM(SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) EMBCDO "
_cQrySC71 += "FROM " + RetSqlName("SC7") + " SC7 "
_cQrySC71 += "INNER JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = SC7.C7_FILIAL  AND SC7.C7_NUM = SZ3.Z3_PEDIDO AND "
_cQrySC71 += "SC7.C7_ITEM = SZ3.Z3_ITEM AND SZ3.Z3_PRODUTO = SC7.C7_PRODUTO AND SZ3.D_E_L_E_T_ = ' ' "
_cQrySC71 += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.D_E_L_E_T_ = ' ' "
_cQrySC71 += "WHERE SC7.C7_FILIAL = '" + _cFilial  + "' "
_cQrySC71 += "AND SC7.C7_PRODUTO = '" + _cCodPro + "' "
_cQrySC71 += "AND SC7.C7_LOCAL IN (" + _cLocal + ") "
_cQrySC71 += "AND SC7.C7_ENCER <> 'E' "
_cQrySC71 += "AND SC7.D_E_L_E_T_ = ' ' "
_cQrySC71 += "AND SA2.A2_EST = 'EX' "

If Select("SC7Q1") > 0
	DbSelectArea("SC7Q1")
	DbCloseArea()
EndIf

TcQuery _cQrySC71 New Alias "SC7Q1"

Return



Static Function FunSC7Q2(_cFilial, _cCodPro)

Local _cQrySC72 := ""

_cQrySC72 := "SELECT SUM(SC7.C7_QUANT - SC7.C7_QUJE - SC7.C7_QTDACLA) EMBARC "
_cQrySC72 += "FROM " + RetSqlName("SC7") + " SC7 "
_cQrySC72 += "LEFT JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = SC7.C7_FILIAL AND SZ3.Z3_PRODUTO = SC7.C7_PRODUTO AND "
_cQrySC72 += "SC7.C7_ITEM = SZ3.Z3_ITEM AND SC7.C7_NUM = SZ3.Z3_PEDIDO AND SZ3.D_E_L_E_T_ = ' ' "
_cQrySC72 += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.D_E_L_E_T_ = ' ' "
_cQrySC72 += "WHERE SC7.C7_FILIAL = '" + _cFilial  + "' "
_cQrySC72 += "AND SC7.C7_PRODUTO = '" + _cCodPro + "' "
_cQrySC72 += "AND SC7.C7_LOCAL IN (" + _cLocal + ") "
_cQrySC72 += "AND SC7.C7_ENCER <> 'E' "
_cQrySC72 += "AND SC7.D_E_L_E_T_ = ' ' "
_cQrySC72 += "AND SZ3.Z3_CODIGO IS NULL "
_cQrySC72 += "AND SA2.A2_EST = 'EX' "

If Select("SC7Q2") > 0
	DbSelectArea("SC7Q2")
	DbCloseArea()
EndIf

TcQuery _cQrySC72 New Alias "SC7Q2"

Return


Static Function FunSZ3Q(_cFilial, _cCodPro)

Local _cQrySZ3 := ""

_cQrySZ3 := "SELECT SC7.C7_EMISSAO DTULCP, SC7.C7_PRECO VLUNCP, SC7.R_E_C_N_O_  "
_cQrySZ3 += "FROM " + RetSqlName("SC7") + " SC7 "
_cQrySZ3 += "LEFT JOIN " + RetSqlName("SZ3") + " SZ3 ON SZ3.Z3_FILIAL = SC7.C7_FILIAL AND SC7.C7_NUM = SZ3.Z3_PEDIDO AND "
_cQrySZ3 += "SC7.C7_ITEM = SZ3.Z3_ITEM AND SZ3.Z3_PRODUTO = SC7.C7_PRODUTO AND SZ3.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "INNER JOIN " + RetSqlName("SA2") + " SA2 ON SA2.A2_COD = SC7.C7_FORNECE AND SA2.A2_LOJA = SC7.C7_LOJA AND SA2.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "WHERE SC7.C7_FILIAL = '" + _cFilial  + "' "
_cQrySZ3 += "AND SC7.C7_PRODUTO = '" + _cCodPro + "' "
_cQrySZ3 += "AND SC7.C7_LOCAL IN (" + _cLocal + ") "
_cQrySZ3 += "AND SC7.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "AND SC7.R_E_C_N_O_ = ( "
_cQrySZ3 += "SELECT MAX(SC7A.R_E_C_N_O_) "
_cQrySZ3 += "FROM " + RetSqlName("SC7") + " SC7A "
_cQrySZ3 += "LEFT JOIN " + RetSqlName("SZ3") + " SZ3A ON SZ3A.Z3_FILIAL = SC7A.C7_FILIAL AND SC7A.C7_NUM = SZ3A.Z3_PEDIDO AND "
_cQrySZ3 += "SC7A.C7_ITEM = SZ3A.Z3_ITEM AND SZ3A.Z3_PRODUTO = SC7A.C7_PRODUTO AND SZ3A.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "INNER JOIN " + RetSqlName("SA2") + " SA2A ON SA2A.A2_COD = SC7A.C7_FORNECE AND SA2A.A2_LOJA = SC7A.C7_LOJA AND SA2A.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "WHERE SC7A.C7_FILIAL = '" + _cFilial  + "' "
_cQrySZ3 += "AND SC7A.C7_PRODUTO = '" + _cCodPro + "' "
_cQrySZ3 += "AND SC7A.C7_LOCAL IN (" + _cLocal + ") "
_cQrySZ3 += "AND SC7A.D_E_L_E_T_ = ' ' "
_cQrySZ3 += "AND SA2A.A2_EST = 'EX' "
_cQrySZ3 += "AND SZ3A.Z3_CODIGO IS NULL )"
_cQrySZ3 += "AND SA2.A2_EST = 'EX' "
_cQrySZ3 += "AND SZ3.Z3_CODIGO IS NULL "

If Select("SZ3Q") > 0
	DbSelectArea("SZ3Q")
	DbCloseArea()
EndIf

TcQuery _cQrySZ3 New Alias "SZ3Q"

Return

Static Function FunSB6Q(_cFilial, _cCodPro)

Local _cQrySB6 := ""

_cQrySB6 := "SELECT B6_FILIAL FILIAL, B6_PRODUTO PRODCOD, B6_CLIFOR CLIFOR, B6_LOJA LOJA, SUM(B6_SALDO) SALDO "
_cQrySB6 += "FROM "+ RetSqlName("SB6") + " SB6 "
_cQrySB6 += "WHERE B6_FILIAL IN (" + _cFilial + ") "
_cQrySB6 += "AND B6_PRODUTO = '" + _cCodPro + "' "
_cQrySB6 += "AND B6_LOCAL IN (" + _cLocal + ") "
_cQrySB6 += "AND B6_DTDIGIT BETWEEN '" + DTOS(MV_PAR07) + "' AND '" + DTOS(MV_PAR08) + "' "
_cQrySB6 += "AND SB6.D_E_L_E_T_ = ' ' "
_cQrySB6 += "GROUP BY B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO "
_cQrySB6 += "ORDER BY B6_FILIAL, B6_CLIFOR, B6_LOJA, B6_PRODUTO "

If Select("SB6Q") > 0
	DbSelectArea("SB6Q")
	DbCloseArea()
EndIf

TcQuery _cQrySB6 New Alias "SB6Q"

Return
