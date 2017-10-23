#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "TbiConn.ch"

#define DS_MODALFRAME   128

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  | MT103FIM | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Realiza a movimentação interna do Saldo do produto, caso o campo |
|          | SD1->D1_QUANT > SD1->D1__WMSQTD e SD1->D1__WMSQTD > 0 na rotina  |
|          | de classificação do documento de entrada                         |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/

User Function MT103FIM

local aArea	:= GetArea()
local nQtd 	:= 0
local	nOpcao    := PARAMIXB[1]   // Opção Escolhida pelo usuario no aRotina
local	nConfirma := PARAMIXB[2]   // Se o usuario confirmou a operação de gravação da NFE  
Local cObs := ""

Private lRelIVA		:= .F.

//Static _nCount := 0
Private _nCount := 0

If /*l103Class .And.*/ SF1->F1__WMSRET == '1' .And. nConfirma == 1
	
	DbSelectArea("SD1")
	DbSetOrder(1) //D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
	if DbSeek(xFilial("SD1")+ SF1->F1_DOC + SF1->F1_SERIE)
	
		if SD1->D1__TRANSF == "S"
			if reclock("SF1", .F.)
				SF1->F1__TRANSF	:= "S"
				SF1->(msUnlock())
			endif
		endif
		
		dbSelectArea("SD1")
		
		While ! Eof() .AND. SD1->D1_FILIAL == xFilial("SD1") .AND. SD1->D1_DOC == SF1->F1_DOC .AND. SD1->D1_SERIE == SF1->F1_SERIE
			
			DbSelectArea("SF4")
			DbSetOrder(1)
			If DbSeek(SF4->(xFilial("SF4")+SD1->D1_TES))
				If SF4->F4_ESTOQUE != "S"
					DbSelectArea("SD1")
					DbSkip()
					Loop
				EndIf
			EndIf
			
			If SD1->D1_QUANT > SD1->D1__WMSQTD
				
				nQtd := SD1->D1_QUANT - SD1->D1__WMSQTD
				cObs := "AJUSTE QUANTIDADE WMS"				
				MovInt(SD1->D1_COD, nQtd, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA, cObs )
				
			EndIf
			
			//Atualiza a quantidade disponivel porque a quantidade agora foi para o saldo em estoque (saldo real)
			//Jorge Alves
			DbSelectArea("SB2")
			DbSetOrder(1)
			If DbSeek(xFilial("SB2") + SD1->D1_COD + SD1->D1_LOCAL)
				While !Reclock("SB2",.f.)
				EndDo
				If SB2->B2__ENTPRC >= SD1->D1__WMSQTD
					SB2->B2__ENTPRC := SB2->B2__ENTPRC - SD1->D1__WMSQTD
				Else
					SB2->B2__ENTPRC := 0
				EndIf
				MsUnlock()
			EndIf
			
			//Atualização de custo - Rogerio Alves 
			If SD1->D1_TIPO == "N" .and. SD1->D1_DTDIGIT > CTOD("01/05/15") .And. !AtIsRotina("A140ESTCLA")
				U_ICOMA06(  SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_COD,SD1->D1_ITEM,SD1->D1_LOCAL,SD1->D1_UM,SD1->D1_FORNECE,SD1->D1_LOJA,SD1->D1_TES,;
				SD1->D1_QUANT,SD1->D1_VUNIT,SD1->D1_CUSTO,SD1->D1_VALICM,SD1->D1_VALIPI,SD1->D1_VALIMP6,SD1->D1_VALIMP5,SD1->D1_VALFRE,;
				SD1->D1_PICM,SD1->D1_FILIAL,SD1->D1__VLRFRE)
			EndIf
				
			DbSelectArea("SD1")
			DbSkip()
     
		EndDo
		
		If lRelIva
			U_IFISR01( SF1->(RECNO()) )
		EndIf

	EndIf
	
EndIf

/*
Trecho de código para criar novo documento de entrada em caso do fornecedor
ser optante do Simples Nacional - Luis Carlos - Anadi
*/

if nOpcao == 3 .and. _nCount == 0 .ANd. SF1->F1_TIPO == "D"		// inclusão
	_nCount 	:= 1
	_cNota		:= criavar("F1_DOC")
	_cSerie		:= criavar("F1_SERIE")
	_dEmissao	:= criavar("D1_EMISSAO")
	
	if nConfirma == 1
		oFont	:= tFont():New("Tahoma",,-14,,.t.)
		dbSelectArea("SA1")
		dbSetOrder(1)
		dbSeek(xFilial("SA1")+SF1->F1_FORNECE+SF1->F1_LOJA)
		if SA1->A1_SIMPNAC == '1'
			
			DEFINE MSDIALOG oDlg TITLE "Dados de Nota do Cliente" FROM 000, 000  TO 170, 400 PIXEL Style DS_MODALFRAME
			
			@ 10,015 SAY "NF do Cliente " SIZE 100, 10 OF oDlg PIXEL FONT oFont
			@ 10,100 MsGet _cNota Picture "@!" Size 50,10 of oDlg PIXEL FONT oFont
			@ 30,015 SAY "Serie da NF " SIZE 100, 10 OF oDlg PIXEL FONT oFont
			@ 30,100 MsGet _cSerie Picture "@!" Size 15,10 of oDlg PIXEL FONT oFont
			@ 50,015 SAY "Data de Emissao " SIZE 100, 10 OF oDlg PIXEL FONT oFont
			@ 50,100 MsGet _dEmissao Size 60,10 of oDlg PIXEL FONT oFont
			
			@ 70,150 BUTTON oButton14 PROMPT "Ok" SIZE 037, 012 OF oDlg ACTION (gravaDados(oDlg)) PIXEL
			
			oDlg:lEscClose := .F.
			ACTIVATE MSDIALOG oDlg CENTERED
			
		endif
	endif
endif

if nOpcao == 5				// exclusão
	_cNota 	:= SF1->F1_DOC
	_cSerie	:= SF1->F1_SERIE
	_cForn	:= SF1->F1_FORNECE
	_cLoja	:= SF1->F1_LOJA
	
	dbSelectArea("SF1")
	dbSetOrder(9)
	if dbSeek(xFilial("SF1")+_cNota+_cSerie+_cForn+_cLoja)
		_cNota 	:= SF1->F1_DOC
		_cSerie	:= SF1->F1_SERIE
		_cForn	:= SF1->F1_FORNECE
		_cLoja	:= SF1->F1_LOJA
		
		if reclock("SF1", .F.)
			delete
			msUnlock()
		endif
		
		dbSelectArea("SD1")
		dbSetOrder(1)
		
		if dbSeek(xFilial("SF1")+_cNota+_cSerie+_cForn+_cLoja)
			do while SD1->D1_DOC == _cNota .and. SD1->D1_SERIE == _cSerie .and. SD1->D1_FORNECE == _cForn .and. SD1->D1_LOJA == _cLoja
				if reclock("SF1", .F.)
					delete
					msUnlock()
				endif
				SD1->(dbSkip())
			enddo
		endif
	endif
endif

// Fim de trecho para o caso de fornecedor optante pelo simples

RestArea(aArea)

Return


static Function gravaDados(oDlg)
Local _aSF1 := SF1->(GetArea()), _aSD1 := SD1->(GetArea())
if empty(_cNota) .or. empty(_cSerie) .or. empty(_dEmissao)
	msgAlert ("Todos os campos da NF do cliente devem ser preenchidos !!")
else
	_cTES		:= getMV("MV__TESNFP")
	
	_aCab := {	{"F1_TIPO"		,'D'				,NIL},;
				{"F1_FORMUL"	,'N'	    		,NIL},;
				{"F1_FILIAL"	,xFilial("SF1")		,NIL},;
				{"F1_DOC"		,_cNota		  		,NIL},;
				{"F1_SERIE"		,_cSerie			,NIL},;
				{"F1_EMISSAO"	,SF1->F1_EMISSAO	,NIL},;
				{"F1_RECBMTO"	,SF1->F1_RECBMTO 	,NIL},;
				{"F1_DTDIGIT"	,SF1->F1_DTDIGIT	,NIL},;
				{"F1_FORNECE"	,SA1->A1_COD 		,NIL},;
				{"F1_LOJA"	    ,SA1->A1_LOJA 		,NIL},;
				{"F1_EST" 		,SA1->A1_EST		,NIL},;
				{"F1_COND" 		,SF1->F1_COND		,NIL},;
				{"F1_COND" 		,SF1->F1_COND		,NIL},;
				{"F1__NFFP" 	,SF1->F1_DOC		,NIL},;
				{"F1__SRFP" 	,SF1->F1_SERIE		,NIL},;
				{"F1_ESPECIE"	,SF1->F1_ESPECIE  	,NIL}}
	
	_nPosD1_COD		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_COD" })
	_nPosD1_LOCAL	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_LOCAL" })
	_nPosD1_UM		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_UM" })
	_nPosD1_DTDIGIT := ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_DTDIGIT" })
	_nPosD1_QUANT	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_QUANT" })
	_nPosD1_VUNIT	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_VUNIT" })
	_nPosD1_TOTAL	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_TOTAL" })
	_nPosD1_TES		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_TES" })
	_nPosD1_CF		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_CF" })
	_nPosD1_CC		:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "D1_CC" })
	
	_aItens := {}
	for x :=1 to len(aCols)
		_aLinha := {}
		AADD(_aLinha,{"D1_COD"	    		,aCols[x][_nPosD1_COD]		,NIL})
		AADD(_aLinha,{"D1_LOCAL"	    	,aCols[x][_nPosD1_LOCAL]   ,NIL})
		AADD(_aLinha,{"D1_FILIAL"			,xFilial("SD1")			  	,NIL})
		AADD(_aLinha,{"D1_UM"				,aCols[x][_nPosD1_UM]   	,NIL})
		AADD(_aLinha,{"D1_DTDIGIT"			,aCols[x][_nPosD1_DTDIGIT]	,NIL})
		AADD(_aLinha,{"D1_QUANT"  			,aCols[x][_nPosD1_QUANT]	,NIL})
		AADD(_aLinha,{"D1_VUNIT"	    	,aCols[x][_nPosD1_VUNIT] 	,NIL})
		AADD(_aLinha,{"D1_TOTAL"	    	,aCols[x][_nPosD1_TOTAL]	,NIL})
		AADD(_aLinha,{"D1_TES"	    		,_cTES							,NIL})
		AADD(_aLinha,{"D1_CF"	    		,aCols[x][_nPosD1_CF]		,NIL})
		
		AADD(_aItens,_aLinha)
	next x
	
	_cParChave	:= getMV("MV_CHVNFE")
	PUTMV("MV_CHVNFE",.F.) //Desativa a verificação
	MSExecAuto({|x,y| mata103(x,y)},_aCab, _aItens)
	PUTMV("MV_CHVNFE", _cParChave) //Volta o parâmetro após o execauto, não impactando nos demais usuários.
	
	oDlg:End()
endif

RestArea(_aSD1)
RestArea(_aSF1)
return

/*
+----------+----------+-------+--------------------------+------+-------------+
|Programa  |  MovInt  | Autor |  Rogério Alves  - Anadi  | Data |  Maio/2014  |
+----------+----------+-------+--------------------------+------+-------------+
|Descricao | Realiza a movimentação interna                                   |
+----------+------------------------------------------------------------------+
|Uso       | Isapa                                                            |
+----------+------------------------------------------------------------------+
*/


Static Function MovInt(cCod, nQtd, cNota, cSerie,cForn,cLoja, cObs )

Local aCab			:= {}
Local aItem 		:= {}
Local cTM 			:= GetMv("MV__TPMOV")
Local nOpcAuto		:= 3
Local cDoc			:= ""
Local cArm			:= Posicione("SB1",1,xFilial("SB1")+cCod,"B1_LOCPAD")
Local cUm			:= Posicione("SB1",1,xFilial("SB1")+cCod,"B1_UM")

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.

DbSelectArea("SB2")
DbSetOrder(1)

If !SB2->(MsSeek(xFilial("SB2")+cCod+cArm))
	CriaSB2(cCod,cArm)
EndIf


cDoc	:= GetSxENum("SD3","D3_DOC",1)

Begin Transaction

aCab 	:= {}
aItem 	:= {}

aCab := {	{"D3_DOC"    	, cDoc    				,  	Nil},;
			{"D3_TM"     	, cTM	    			,  	Nil},;
			{"D3_CC"     	, " "       			,  	Nil},;
			{"D3_EMISSAO"	, SF1->F1_DTDIGIT	 	,  	Nil}}
			
aadd(aItem,{{"D3_TM"      	, cTM     				,  	Nil},;
			{"D3_COD"      	, cCod   				,  	Nil},;
			{"D3_UM"        , cUm		       		,  	Nil},;
			{"D3_QUANT"     , nQtd   				,  	Nil},;
			{"D3_LOCAL"     , cArm    				,  	Nil},;
			{"D3_EMISSAO"	, ddatabase 			,  	NIL},;
			{"D3__DOC"     	, cNota	   				,  	Nil},;
			{"D3__SERIE"   	, cSerie				,  	Nil},;
			{"D3__FORNEC"  	, cForn	   				,  	Nil},;
			{"D3__LOJA"	   	, cLoja					,  	Nil},;
			{"D3__OBS"	   	, cObs					,  	Nil}})


MSExecAuto({|x,y,z| MATA241(x,y,z)},aCab,aItem,nOpcAuto)

If lMsErroAuto
	DisarmTransaction()
	MostraErro()
EndIf

End Transaction

Return