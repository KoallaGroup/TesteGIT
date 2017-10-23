#INCLUDE "IFINA470.CH"
#INCLUDE "FILEIO.CH"
#INCLUDE "PROTHEUS.CH"

Static __lDefTop := NIL

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ IFINA16  ³ Autor ³ Rafael Domingues - ANADI ³ Data ³ 24/03/15 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconcilia‡„o Banc ria Autom tica                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ IFINA16()                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Especifico Isapa                                              ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFINA16()

AjustaSx1()

Pergunte("AFI470",.F.)

Private aRotina:= {	{ STR0001 , "fA470Par" , 0 , 1},;  // "Parƒmetros"
					{ STR0002 , "AxVisual" , 0 , 2},;  // "Visualizar"
					{ STR0003 , "U_IFIN01" , 0 , 3} }  // "Reconcilia‡„o"

Private cCadastro	:= STR0006  //"Reconcilia‡„o Banc ria Autom tica"
Private cFiltro		:= ""
Private nPosArotina := 0

mBrowse( 6, 1,22,75,"SE5")

Return()

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA470Ger ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconcilia‡„o Banc ria Autom tica                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA470Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINA470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFIN01(cAlias)

Local lGestao		:= FWSizeFilial() > 2	// Indica se usa Gestao Corporativa
Local lCompExcl		:= .F.        			// Controle de compartilhamento (tudo exclusivo ou tudo compartilhado
Local nj			:= 0
Local aSelFil		:= {}
Local aTmpFil		:= {}
Local lRet			:= .T.
Local nOpca			:= 0
Local aButtons		:= {}
Local aSays			:= {}

Private nHdlPrv		:= 0
Private lDigita  	:= Iif(mv_par07 == 1,.T.,.F.)
Private lAglutina	:= Iif(mv_par06 == 1,.T.,.F.)
Private lGeraLanc	:= Iif(mv_par08 == 1,.T.,.F.)
Private cArquivo
Private nTotal		:= 0
Private cLote		:= ""
Private aFlagCTB	:= {}
Private lUsaFlag	:= SuperGetMV( "MV_CTBFLAG", .T., .F.)

If lRet
	
	nOpcA := 0
	aSays := {}
	
	AADD(aSays, "Este programa tem como objetivo possibilitar a conciliação dos")
	AADD(aSays, "movimentos bancários do sistema através da leitura do arquivo")
	AADD(aSays, "de extrato bancário.")
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Inicializa o log de processamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ProcLogIni( aButtons )
	
	AADD(aButtons, { 5,.T.,{|| Pergunte("AFI470",.T. ) } } )
	AADD(aButtons, { 1,.T.,{|o| (nOpca:= 1,o:oWnd:End())}} )
	AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }} )
	FormBatch( cCadastro, aSays, aButtons ,,,390)
	
	If nOpcA == 1
		
		//Gestao
		If __lDefTop == NIL
			__lDefTop 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
		Endif
		
		If lGestao
			lCompExcl := (FWModeAccess("SE5",1) == "C" .and. FWModeAccess("SA6",1) == "C") .or. ;
			(FWModeAccess("SE5",3) == "3" .and. FWModeAccess("SA6",3) == "E")
		Endif
		
		//Gestao
		//Selecao de filiais
		If lGestao .and. __lDefTop .and. mv_par11 == 1 .And. Len( aSelFil ) <= 0 .and. !lCompExcl
			aSelFil := AdmGetFil(.F.,.T.,"SE5")
			If Len( aSelFil ) <= 0
				lRet := .F.
			EndIf
		Else
			aSelFil := { cFilAnt }
		EndIf
		
		If lRet
			
			Processa({|lEnd| U_IFIN02(cAlias,aSelFil,aTmpFil)})  // Chamada com regua
			
			// Contabilizacao
			If nHdlPrv > 0 .And. nTotal > 0
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Efetiva Lan‡amento Contabil ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				RodaProva( nHdlPrv,nTotal)
				cA100Incl( cArquivo,nHdlPrv,3,cLote,lDigita,lAglutina,,,,@aFlagCTB,,)
				aFlagCTB := {}  // Limpa o coteudo apos a efetivacao do lancamento
			EndIf
			
			//Gestao
			For nJ := 1 TO Len(aTmpFil)
				CtbTmpErase(aTmpFil[nJ])
			Next
		Endif
	Endif
Endif

Return lRet

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ fA470Gera³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Reconciliacao Bancaria Automatica                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe   ³ fA470Ger()                                                 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FinA470                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function IFIN02(cAlias,aSelFil,aTmpFil)

Local cPosNum	:= ""
Local cPosData	:= ""
Local cPosValor	:= ""
Local cPosOcor	:= ""
Local cPosDescr	:= ""
Local cPosDif	:= ""
Local cColorAnt	:= ""
Local cData		:= ""
Local cDebCred	:= ""
Local cRecTRB	:= ""
Local cArqConf	:= ""
Local cArqEnt	:= ""
Local cIndex	:= " "
Local cMotSist	:= Space(3)				// motivo da ocorrencia no sistema
Local cMotBan	:= Space(3)				// motivo da ocorrencia no banco
Local cBanco	:= Space(TamSX3("E5_BANCO")[1])
Local cAgencia	:= Space(TamSX3("E5_AGENCIA")[1])
Local cConta	:= Space(TamSX3("E5_CONTA")[1])
Local cDifer	:= ""
Local cVarQ   	:= "  "
Local cPosVSI	:= ""
Local cPosDSI	:= ""
Local cPosDCI	:= ""
Local cReconAnt := ""
Local cQuery	:= ""
Local cAliasTrb	:= ""
Local cCampos	:= ""
Local xBuffer	:= ""
Local cTmpSE5Fil:= ""
Local nLidos	:= 0
Local nLenNum	:= 0
Local nLenData	:= 0
Local nLenValor	:= 0
Local nLenDescr	:= 0
Local nLenOcor	:= 0
Local nLenDif	:= 0
Local nLenBco	:= 0
Local nLenAge	:= 0
Local nLenCta	:= 0
Local nTamConta := TamSX3("E5_CONTA")[1]  			// Tamanho do campo de C.Corrente no sistema
Local nSavRecno	:= Recno()
Local nPos		:= 0
Local nSeq		:= 0						// controle sequencial de lancto do Banco
Local nValBco	:= 0
Local nOpca		:= 0
Local nCont		:= 0
Local li		:= 0
Local nHdlBco	:= 0
Local nLenVSI	:= 0
Local nLenDSI	:= 0
Local nLenDCI	:= 0
Local nT 		:= 0
Local nX		:= 0
Local nReconc	:= 0
Local nTipoDat	:= 1
Local lSaida	:= .F.
Local lReconc	:= .F.
Local lPosNum	:= .F.
Local lPosData  := .F.
Local lPosValor := .F.
Local lPosOcor	:= .F.
Local lPosDescr := .F.
Local lPosDif   := .F.
Local lPosBco	:= .F.
Local lPosAge   := .F.
Local lPosNat   := .F.
Local lPosCta   := .f.
Local lPosVSI	:= .F.
Local lPosDSI	:= .F.
Local lPosDCI	:= .F.
Local lFebraban := .F.
Local lAtSalRec1:= .F.
Local lAtSalRec2:= .F.
Local lAtuDtDisp:= .T.
Local lIndice13	:= .F.
Local lReproc	:= .F.
Local lGestao	:= FWSizeFilial() > 2	// Indica se usa Gestao Corporativa
Local aTabela 	:= {}
Local aConta	:= {}
Local aCtas470  := {}
Local aAreaAtu	:= {}
Local aButtons	:= {}
Local aButtonTxt:= {}

Private oOk		:= LoadBitmap( GetResources(), "BR_VERDE" )
Private oNo		:= LoadBitmap( GetResources(), "DISABLE" )
Private oParc	:= LoadBitmap( GetResources(), "BR_AMARELO" )
Private oJaRec	:= LoadBitmap( GetResources(), "BR_CINZA" )
Private oTitulo
Private oBtn
Private oDlg
Private dDtaCred := CRIAVAR("E5_DTDISPO")
Private dDtIniA	 := CRIAVAR("E5_DTDISPO")
Private dDtFinA	 := CRIAVAR("E5_DTDISPO")
Private aCores 	 := {}

Private oYes := LoadBitmap(GetResources(),"LBOK")
Private oNot := LoadBitmap(GetResources(),"LBNO")
Private oChk
Private oLbx
Private lChk   := .F.
Private lMark  := .F.
Private aVetor := {}

Private cArqRec1  := ""
Private cArqRec2  := ""
Private cArqRec3  := ""
Private cArqRec4  := ""
Private lMarca	  := 1
Private dDtIni	  := CTOD("01/01/2099","ddmmyy")
Private dDtFin	  := CTOD("01/01/1980","ddmmyy")
Private	dDataInic := dDataBase
Private	dDataFim  := dDataBase
Private dOldDispo := Ctod("//")

Aadd(aCores,oOk)
Aadd(aCores,oNo)
Aadd(aCores,oParc)
Aadd(aCores,oJaRec)

//Gestao
If __lDefTop == NIL
	__lDefTop 	:= IfDefTopCTB() // verificar se pode executar query (TOPCONN)
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona no Banco indicado ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SEE")
dbSetOrder(1)
If dbSeek(xFilial("SEE")+mv_par03)
	lFebraban := IIF(SEE->EE_BYTESXT > 200 , .t., .f.)
	nTamDet	 := IIF(SEE->EE_BYTESXT > 0, SEE->EE_BYTESXT + 2, 202 )
Else
	Help(" ",1,"PAR150")
	Return .F.
Endif

nTipoDat := IIF(nTamDet > 202, 4,1)		//1 = ddmmaa		4= ddmmaaaa

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo de configuracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqConf := mv_par02

IF !FILE(cArqConf)
	Help(" ",1,"A470NOPAR")
	Return .F.
Else
	nHdlConf:=FOPEN(cArqConf,0+64)
EndIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo de configuracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos 	:= 0
FSEEK(nHdlConf,0,0)
nTamArq := FSEEK(nHdlConf,0,2)
FSEEK(nHdlConf,0,0)

While nLidos <= nTamArq
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o tipo de qual registro foi lido ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer:=Space(85)
	FREAD(nHdlConf,@xBuffer,85)
	IF SubStr(xBuffer,1,1) == CHR(1)  // Header
		nLidos+=85
		Loop
	EndIF
	
	IF SubStr(xBuffer,1,1) == CHR(4) // Saldo Final
		nLidos+=85
		Loop
	EndIF
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados do Saldo Inicial (Bco/Ag/Cta)       ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !lPosBco  //Nro do Banco
		cPosBco:=Substr(xBuffer,17,10)
		nLenBco:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosBco:=.T.
		nLidos+=85
		Loop
	EndIF
	IF !lPosAge  //Agencia
		cPosAge :=Substr(xBuffer,17,10)
		nLenAge :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosAge :=.T.
		nLidos+=85
		Loop
	EndIF
	IF !lPosCta  //Nro Cta Corrente
		cPosCta=Substr(xBuffer,17,10)
		nLenCta=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosCta=.T.
		nLidos+=85
		Loop
	Endif
	IF !lPosDif   // Diferencial de Lancamento
		cPosDif  :=Substr(xBuffer,17,10)
		nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosDif  :=.t.
		nLidos+=85
		Loop
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Os dados abaixo nÆo sÆo utilizados na reconcilia‡Æo. ³
	//³ EstÆo ai apenas p/leitura do arquivo de configura‡Æo.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !lPosVSI   // Valor Saldo Inicial
		cPosVSI  :=Substr(xBuffer,17,10)
		nLenVSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosVSI  :=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosDSI   // Data Saldo Inicial
		cPosDSI  :=Substr(xBuffer,17,10)
		nLenDSI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosDSI  :=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosDCI   // Identificador Deb/Cred do Saldo Inicial
		cPosDCI  :=Substr(xBuffer,17,10)
		nLenDCI  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosDCI  :=.t.
		nLidos+=85
		Loop
	EndIF
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Dados dos Movimentos                      ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF !lPosNum  // Nro do Lancamento no Extrato
		cPosNum:=Substr(xBuffer,17,10)
		nLenNum:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosNum:=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosData  // Data da Movimentacao
		cPosData:=Substr(xBuffer,17,10)
		nLenData:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosData:=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosValor  // Valor Movimentado
		cPosValor=Substr(xBuffer,17,10)
		nLenValor=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosValor=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosOcor // Ocorrencia do Banco
		cPosOcor	:=Substr(xBuffer,17,10)
		nLenOcor :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosOcor	:=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosNat  // Descricao do Lancamento
		cPosNat:=Substr(xBuffer,17,10)
		nLenNat:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosNat:=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosDescr  // Descricao do Lancamento
		cPosDescr:=Substr(xBuffer,17,10)
		nLenDescr:=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosDescr:=.t.
		nLidos+=85
		Loop
	EndIF
	IF !lPosDif   // Diferencial de Lancamento
		cPosDif  :=Substr(xBuffer,17,10)
		nLenDif  :=1+Int(Val(Substr(xBuffer,20,3)))-Int(Val(Substr(xBuffer,17,3)))
		lPosDif  :=.t.
		nLidos+=85
		Loop
	EndIF
	Exit
EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ fecha arquivo de configuracao ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Fclose(nHdlConf)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica se constam dados banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If Empty(cPosBco) .or. Empty(cPosAge) .or. Empty(cPosCta) .or. Empty(cPosDif) .or. Empty(cPosValor) .or. Empty(cPosOcor) .or. Empty(cPosData)
	Help(" ",1,"A470NOCFG")
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Abre arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cArqEnt := mv_par01
IF !FILE(cArqEnt)
	Help(" ",1,"A470NOBCO")
	Return .F.
Else
	nHdlBco:=FOPEN(cArqEnt,0+64)
EndIF

//Verifica se o arquivo de retorno bancafio ja foi processado
If !(Chk470File(@lReproc))
	If nHdlBco > 0
		FClose(nHdlBco)
	Endif
	Return .F.
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria arquivo de trabalho ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
F470CRIARQ()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Lˆ arquivo enviado pelo banco ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
nLidos := 0
FSEEK(nHdlBco,0,0)
nTamArq := FSEEK(nHdlBco,0,2)
FSEEK(nHdlBco,0,0)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Desenha o cursor e o salva para poder moviment -lo ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
ProcRegua( nTamArq / nTamDet , 24 )
nLidos := 0
While nLidos <= nTamArq
	IncProc()
	nValor  :=0
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tipo qual registro foi lido ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	xBuffer:=Space(nTamDet)
	FREAD(nHdlBco,@xBuffer,nTamDet)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica o diferencial do registro de Lancamento ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If !lFebraban  // 200 posicoes
		cDifer :=Substr(xBuffer,Int(Val(Substr(cPosDif, 1,3))),nLenDif )
	Else
		cDifer := "xx"  // 240 posicoes
	Endif
	
	// Header do arquivo  // 200 posicoes or // 240 posicoes
	IF (SubStr(xBuffer,1,1) == "0" .and. !lFebraban) .or. (Substr(xBuffer,8,1) == "0" .and. lFebraban)
		nLidos+=nTamDet
		Loop
	EndIF
	
	//Trailer do arquivo  // 200 posicoes or // 240 posicoes
	IF (SubStr(xBuffer,1,1) == "9" .and. !lFebraban) .or. (Substr(xBuffer,8,1) == "9" .and. lFebraban)
		nLidos+=nTamDet
		dbSelectArea("TRB")
		dbGoTop()
		IF BOF() .and. EOF()
			lSaida := .T.
		Endif
		Exit
	EndIF
	
	// Saldo Inicial
	IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "0" .and. !lFebraban) .or. (SubStr(xBuffer,8,1) == "1" .and. lFebraban)		
		cBanco   :=Substr(xBuffer,Int(Val(Substr(cPosBco, 1,3))),nLenBco )
		cAgencia :=Substr(xBuffer,Int(Val(Substr(cPosAge, 1,3))),nLenAge )
		cConta   :=Substr(xBuffer,Int(Val(Substr(cPosCta, 1,3))),nLenCta )
		
		//Valida e retirar os zeros a esquerda se necessario
		A470VldBco( MV_PAR03 , @cAgencia , @cConta )
		
		If AllTrim(cBanco)!= AllTrim(mv_par03)
			Help(" ",1,"FA470CONTA")
			lSaida := .T.
			Exit
		Endif
		
		//Monto array com as contas contidas no arquivo de retorno,
		//para posterior validacao dos movimentos contidos no SE5
		If nT := ascan(aCtas470,{|x| x = cAgencia+cConta }) == 0
			Aadd(aCtas470,cAgencia+cConta)
		Endif
		
		nLidos+=nTamDet
		Loop
	EndIF
	
	// Saldo Final
	IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "2" .and. !lFebraban) .or. (Substr(xBuffer,8,1) == "5" .and. lFebraban)
		nLidos+=nTamDet
		Loop
	EndIF
	
	// Lancamentos
	IF (SubStr(xBuffer,1,1) == "1" .and. cDifer == "1" .and. !lFebraban) .or. (Substr(xBuffer,8,1) == "3" .and. lFebraban)

		cNumMov   := Substr(xBuffer,Int(Val(Substr(cPosNum,1,3))),nLenNum)
		cDataBco  := Substr(xBuffer,Int(Val(Substr(cPosData,1,3))),nLenData)
		cDataBco  := ChangDate(cDataBco,nTipoDat)
		dDataMov  := Ctod(Substr(cDataBco,1,2)+"/"+Substr(cDataBco,3,2)+"/"+Substr(cDataBco,5,2),"ddmmyy")
		cDataMov  := dToc(dDataMov)
		dDtIni 	  := MIN(dDtIni,dDataMov)
		dDtFin 	  := MAX(dDtFin,dDataMov)
		cValorMov := Transform(Round(Val(Substr(xBuffer,Int(Val(Substr(cPosValor,1,3))),nLenValor))/100,2),"@E 999,999,999,999.99")
		cCodMov	  := Substr(xBuffer,Int(Val(Substr(cPosOcor,1,3))),nLenOcor)
		cDescrMov := Substr(xBuffer,Int(Val(Substr(cPosDescr,1,3))),nLenDescr)
		cNat      := Substr(xBuffer,Int(Val(Substr(cPosNat,1,3))),nLenNat)
		
		dbSelectArea("SEJ")
		If dbSeek(xFilial("SEJ")+cBanco+cCodMov)
			cTipoMov := SEJ->EJ_OCORSIS
			cDescMov := SEJ->EJ_DESCR
			cDebCred := SEJ->EJ_DEBCRE
		Else
			Help(" ",1,"FA470OCOR")
			lSaida := .T.
			Exit
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Grava dados no arquivo de trabalho³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		DbSelectArea("TRB")
		DbAppend()
		cRecTRB := STR(TRB->(Recno()))
		TRB->SEQMOV 	:= SUBSTR(cRecTRB,-4)
		TRB->DATAMOV  	:= cDataMov
		TRB->NUMMOV   	:= cNumMov
		TRB->VALORMOV 	:= cValorMov
		TRB->TIPOMOV	:= cTipoMov
		TRB->DESCMOV	:= cDescMov
		TRB->DEBCRED	:= cDebCred
		TRB->DESCRMOV	:= cDescrMov
		TRB->AGEMOV		:= cAgencia
		TRB->CTAMOV		:= cConta
		TRB->OK     	:= 2		// N„O RECONCILIADO
		
		DbSelectArea("Z28")
		DbSetOrder(1)
		If DbSeek(xFilial("Z28")+cBanco+cNat)
			TRB->NATUREZ    := Z28->Z28_NATURE
		Else
			MsgInfo("Banco: "+AllTrim(cBanco)+" Natureza: "+AllTrim(cNat)+ " - "+AllTrim(cDescrMov)+" não possui amarração, cadastre para prosseguir!","Amarracao Natureza")
			U_IFICAD01()
			DbSelectArea("Z28")
			DbSetOrder(1)
			DbSeek(xFilial("Z28")+cBanco+cNat)
				TRB->NATUREZ    := Z28->Z28_NATURE
		EndIf
		
	Endif
	nLidos += nTamDet
Enddo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Fecha arquivo do Banco        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Fclose(nHdlBco)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processa dados, caso tudo Ok      ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("TRB")
dbGoTop()
If BOf() .and. EOF() .and. !lSaida
	Help(" ",1,"ERROCONF")
	lSaida := .T.
Endif

dDtIniA := dDtIni           	// Armazeno data inicial e final contido no arquivo
dDtFinA := dDtFin
dDtIni  := dDtIni - mv_par05	// Acrescento/diminuo das variaveis para abrir periodo
dDtFin  := dDtFin + mv_par04	// E5_DTDISPO

If !lSaida
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Abre o SE5 com outro alias para ser filtrado porque a funcao³
	//³ TemBxCanc() utilizara o SE5 sem filtro.						³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dDataInic := Min(dDtIni,Iif(Empty(mv_par09),dDtIni,mv_par09) )
	dDataFim  := Max(dDtFin,Iif(Empty(mv_par10),dDtFin,mv_par10))
	
	If ( ChkFile("SE5",.F.,"NEWSE5") )
		
		If __lDefTop .and. Len(aSelFil) > 1
			cChave  := "E5_BANCO+E5_AGENCIA+E5_CONTA+DTOS(E5_DTDISPO)"
		Else
			cChave  := "E5_FILIAL+E5_BANCO+E5_AGENCIA+E5_CONTA+DTOS(E5_DTDISPO)"
		Endif
		
		If __lDefTop
			cTipoCH:=IF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE)
			
			cAliasTrb := GetNextAlias()
			aStru  := SE5->(dbStruct())
			cCampos := ""
			aEval(aStru,{|x| cCampos += ","+AllTrim(x[1])})
			cQuery := "SELECT "+SubStr(cCampos,2) + ", R_E_C_N_O_ RECNOSE5 "
			cQuery += "FROM " + RetSqlName("SE5") + " SE5 "
			cQuery += "WHERE "
			
			//Gestao
			If lGestao .and. Len(aSelFil) > 1
				cQuery += "E5_FILIAL " + GetRngFil( aSelFil, "SE5", .T., @cTmpSE5Fil ) + " AND "
				aAdd(aTmpFil, cTmpSE5Fil)
			Else
				cQuery += "E5_FILIAL = '" + xFilial("SE5")+"' AND "
			Endif
			cQuery +=	"E5_DTDISPO >= '" + DTOS(dDataInic) + "' AND "
			cQuery +=	"E5_DTDISPO <= '" + DTOS(dDataFim) + "' AND "
			cQuery +=	"E5_BANCO = '" + mv_par03 + "' AND "
			cQuery +=	"E5_SITUACA <> 'C' AND "
			cQuery +=	"E5_TIPODOC NOT IN " + FormatIn("BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL","/") + " AND "
			cQuery +=	"E5_VALOR > 0 AND "
			cQuery +=	"(E5_MOEDA NOT IN " + FormatIn("C1/C2/C3/C4/C5/CH","/") + " OR (E5_MOEDA IN " + FormatIn("C1/C2/C3/C4/C5/CH","/") + " AND E5_NUMCHEQ <> ' ')) AND "
			cQuery +=	"(E5_NUMCHEQ <> '*' OR (E5_NUMCHEQ = '*' AND E5_RECPAG <> 'P')) AND "
			cQuery +=	"((E5_TIPODOC  IN "+ FormatIn(cTipoCH,"|") + "AND  E5_DTDISPO BETWEEN  '" + DTOS(mv_par09)+ "' AND '"  + DTOS(mv_par10) +"' ) OR "
			cQuery +=	"(E5_TIPODOC   NOT IN "+ FormatIn(cTipoCH,"|") + "AND  E5_DTDISPO BETWEEN  '" + DTOS(dDtIni)+ "' AND '"  + DTOS(dDtFin) +"' )) AND "
			cQuery +=	"(E5_NUMCHEQ <> '*' OR (E5_NUMCHEQ = '*' AND E5_RECPAG <> 'P')) AND "
			cQuery +=	"D_E_L_E_T_ = ' ' "
			cQuery += 	"ORDER BY " + SqlOrder(cChave)
			dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasTrb,.T.,.T.)
			For nX :=  1 To Len(aStru)
				If aStru[nX][2] <> "C" .And. FieldPos(aStru[nX][1]) > 0
					TcSetField(cAliasTrb,aStru[nX][1],aStru[nX][2],aStru[nX][3],aStru[nX][4])
				EndIf
			Next nX
		Else
			
			aAreaAtu := GetArea()
			dbSelectArea("SIX")
			lIndice13:= dbSeek("SE5"+"D")
			RestArea(aAreaAtu)
			
			If lIndice13
				cAliasTrb:="SE5"
				DbSelectArea(cAliasTrb)
				DbSetOrder(13)
				DbSeek(xFilial("SE5")+mv_par03+Dtos(dDataInic),.T.)
				
			Else
				cAliasTrb := "NEWSE5"
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Filtra o SE5 por Banco/Ag./Cta                               ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				dbSelectArea("NEWSE5")
				cIndex	:= CriaTrab(nil,.f.)
				IndRegua("NEWSE5",cIndex,cChave,,Fa470ChecF(), STR0009)  //"Selecionando Registros..."
				DbSelectArea("NEWSE5")
				dbSetIndex(cIndex+OrdBagExt())
				dbGoTop()
			EndIf
			
		Endif
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Inicia a leitura do arquivo   ³
		//³ de movimentacao do SE5        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		While (cAliasTrb)->(!(Eof())) .And. Iif(!lIndice13,.T.,(cAliasTrb)->(E5_BANCO)==mv_par03 .And. (cAliasTrb)->(E5_DTDISPO)<= dDataFim)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ registros a serem ignorados   ³
			//³ pela movimentacao do SE5      ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			//Movimentos do banco mas de contas que nao constem do arquivo de retorno dever ser desprezadas.
			If nT := Ascan(aCtas470,{|x| AllTrim( x ) == ALLTRIM((cAliasTrb)->E5_AGENCIA+(cAliasTrb)->E5_CONTA)}) == 0
				(cAliasTrb)->(dbSkip())
				Loop
			EndIF
			
			If !Empty( (cAliasTrb)->E5_MOTBX ) .and. !MovBcoBx((cAliasTrb)->E5_MOTBX)
				(cAliasTrb)->(dbSkip())
				Loop
			EndIF
			
			If !__lDefTop
				IF (cAliasTrb)->E5_TIPODOC $ "BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL"  //Valores de Baixas
					(cAliasTrb)->( dbSkip())
					Loop
				EndIF
				
				IF (cAliasTrb)->(E5_BANCO)!= mv_par03
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF
				
				IF (cAliasTrb)->(E5_TIPODOC) $ IIF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE) .And.  (cAliasTrb)->(E5_DTDISPO)> MV_PAR10 .And. (cAliasTrb)->(E5_DTDISPO)< MV_PAR09
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF
				
				IF !((cAliasTrb)->(E5_TIPODOC) $ IIF(Type("MVCHEQUES")=="C",MVCHEQUES,MVCHEQUE)) .And.  (cAliasTrb)->(E5_DTDISPO)> dDtFin .And. (cAliasTrb)->(E5_DTDISPO)< dDtIni
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF
				
				
				IF (cAliasTrb)->E5_SITUACA = "C"    //Cancelado
					(cAliasTrb)->( dbSkip())
					Loop
				EndIF
				
				IF (cAliasTrb)->E5_VALOR = 0
					(cAliasTrb)->(dbSkip())
					LOOP
				EndIF
				
				IF (cAliasTrb)->E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .and. Empty((cAliasTrb)->E5_NUMCHEQ)
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF
				
				If SubStr((cAliasTrb)->E5_NUMCHEQ,1,1)=="*"  .AND. (cAliasTrb)->E5_RECPAG=="P"    //cheque para juntar (PA)
					(cAliasTrb)->(dbSkip())
					Loop
				EndIF
				
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Verifica se existe estorno para esta baixa                       ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If !lIndice13
					SE5->(MsGoto(NEWSE5->(RECNO())))
				EndIf
			Else
				SE5->(MsGoto((cAliasTrb)->RECNOSE5))
			Endif
			
			If TemBxCanc((cAliasTrb)->E5_PREFIXO+(cAliasTrb)->E5_NUMERO+(cAliasTrb)->E5_PARCELA+(cAliasTrb)->E5_TIPO+(cAliasTrb)->E5_CLIFOR+(cAliasTrb)->E5_LOJA+(cAliasTrb)->E5_SEQ)
				(cAliasTrb)->( dbskip())
				loop
			EndIf
			
			IF (cAliasTrb)->E5_TIPODOC = "CH"    //Emiss„o de Cheque
				If SEF->(dbSeek(xFilial("SEF")+(cAliasTrb)->E5_BANCO+(cAliasTrb)->E5_AGENCIA+(cAliasTrb)->E5_CONTA+(cAliasTrb)->E5_NUMCHEQ))
					If SEF->EF_IMPRESS = "C"
						(cAliasTrb)->(dbSkip())
						Loop
					EndIF
				EndIF
			EndIF
			
			//Grava Registro no TRB
			DbSelectArea("TRB")
			DbAppend()
			cRecTRB 		:= STR(TRB->(Recno()))
			TRB->SEQMOV 	:= SUBSTR(cRecTRB,-4)
			TRB->DATAMOV	:= DTOC((cAliasTrb)->E5_DTDISPO)
			TRB->NUMSE5		:= (cAliasTrb)->E5_NUMCHEQ
			TRB->VALORSE5	:= Transform((cAliasTrb)->E5_VALOR,"@E 999,999,999,999.99")
			TRB->DEBCRED	:= IIF((cAliasTrb)->E5_RECPAG == "R", "C","D")
			TRB->RECSE5		:= If(__lDefTop,(cAliasTrb)->RECNOSE5,(cAliasTrb)->(Recno()))
			TRB->RECONSE5	:= (cAliasTrb)->E5_RECONC
			TRB->AGESE5		:= (cAliasTrb)->E5_AGENCIA
			TRB->CTASE5		:= (cAliasTrb)->E5_CONTA
			TRB->OK			:= IIF (!Empty(TRB->RECONSE5),4,2)  // 2 = N„o Reconciliado, 4 = Reconciado anteriormente (SE5)
			
			cDataMov  := TRB->DATAMOV
			cNumMov   := TRB->NUMSE5
			cValorMov := TRB->VALORSE5
			nRecSe5   := TRB->RECSE5
			cSeqSe5   := TRB->SEQMOV
			cDebCred  := TRB->DEBCRED
			cCtaMov   := TRB->CTASE5
			cAgeMov   := TRB->AGESE5
			lReconc   := IIF(!EMPTY(TRB->RECONSE5),.T.,.F.)
			nRecTrb   := TRB->(Recno())
			DbSelectArea("TRB")
			DbSetOrder(2)
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tento pre-reconciliacao dentro da Data + Agencia + Conta + Numero + Valor + Tipo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nRecno := Recno()
			If DbSeek(cAgeMov + cCtaMov + cNumMov + cDataMov +  cValorMov + cDebCred)
				nRecno := Recno()
				
				DbGoTo(nRecTrb)
				dbDelete()
				dbGoto(nRecno)
				TRB->VALORSE5 	:= cValorMov
				TRB->NUMSE5	  	:= cNumMov
				TRB->RECSE5		:= nRecSE5
				TRB->CTASE5		:= cCtaMov
				TRB->AGESE5		:= cAgeMov
				TRB->SEQRECON	:= cSeqSE5
				TRB->OK			:= IIf (lReconc,4,1)  	// 1 => Reconc. totalmente, 4 => Reconc. Anteriomente no SE5
			Else
				dbGoto(nRecno)
			Endif
			
			DbSetOrder(1)
			
			If (mv_par04 # 0 .Or. mv_par05 # 0) .And. !Str(TRB->OK,1) $ "1#3#4"
				DbSelectArea("TRB")
				DbSetOrder(4)
				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
				//³ Tento pre-reconcilizacao por numero + valor + tipo ³
				//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
				If DbSeek( cAgeMov + cCtaMov +cNumMov + cValorMov + cDebCred) .And. !Str(TRB->OK,1) $ "1#3#4"
					nRecno := Recno()
					
					DbGoTo(nRecTrb)
					dbDelete()
					dbGoto(nRecno)
					TRB->VALORSE5 	:= cValorMov
					TRB->NUMSE5	  	:= cNumMov
					TRB->RECSE5		:= nRecSE5
					TRB->SEQRECON	:= cSeqSE5
					TRB->CTASE5		:= cCtaMov
					TRB->AGESE5		:= cAgeMov
					TRB->OK			:= IIf (lReconc,4,3)  	// 3 => Reconc. Chave parcial, 4 => Reconc. Anteriomente no SE5
				Else
					dbGoto(nRecno)
				Endif
				DbSetOrder(1)
			Endif
			
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Tento pre-reconcilizacao dentro da data + valor + tipo ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			DbSelectArea("TRB")
			DbSetOrder(3)
			If !Str(TRB->OK,1) $ "1#3#4" .or. lReproc
				If DbSeek(cAgeMov + cCtaMov + cDataMov +  cValorMov + cDebCred)
					While !EOF() .And. (cAgeMov + cCtaMov + cDataMov +  cValorMov + cDebCred) ==;
						TRB->AGEMOV + TRB->CTAMOV + TRB->DATAMOV + TRB->VALORMOV + TRB->DEBCRED
						If !Str(TRB->OK,1) $ "1#3#4"
							nRecno := Recno()
							DbGoTo(nRecTrb)
							dbDelete()
							dbGoto(nRecno)
							TRB->VALORSE5 	:= cValorMov
							TRB->NUMSE5	  	:= cNumMov
							TRB->RECSE5		:= nRecSE5
							TRB->SEQRECON	:= cSeqSE5
							TRB->CTASE5		:= cCtaMov
							TRB->AGESE5		:= cAgeMov
							TRB->OK			:= IIf (lReconc,4,3)  	// 3 => Reconc. Chave parcial ou 4 => Reconc. Anteriomente no SE5
							Exit
						Endif
						DbSkip()
					Enddo
				Else
					dbGoto(nRecno)
				Endif
			Endif
			DbSetOrder(1)
			
			dbSelectArea(cAliasTrb)
			dbSkip()
		Enddo
		If __lDefTop
			(cAliasTrb)->(DbCloseArea())
		Endif
		
		dbSelectArea("TRB")
		dbGoTop()
		While TRB->(!Eof())
			aAdd(aVetor, { 	aCores[TRB->OK],;			//1 - LEGENDA
							lMark,;						//2 - MARCA/DESMARCA
							TRB->SEQMOV,;				//3 - SEQUENCIA
							TRB->DATAMOV,;				//4 - DATA
							TRB->AGEMOV,;				//5 - AG BCO
							TRB->CTAMOV,;				//6 - CONTA BCO
							TRB->NUMMOV,;				//7 - DOCTO BCO
							PADR(TRB->VALORMOV,18),;	//8 - VALOR EXTRATO
							TRB->TIPOMOV,;				//9 - TIPO
							TRB->DESCMOV,;				//10 - DESCRICAO
							PADC(TRB->DEBCRED,3),;		//11 - D/C
							TRB->AGESE5,;				//12 - AGENC SE5
							TRB->CTASE5,;				//13 - CONTA SE5
							TRB->NUMSE5,;				//14 - DOCTO SE5
							PADR(TRB->VALORSE5,18),;	//15 - VALOR SE5
							TRB->DESCRMOV,;				//16 - HISTORICO EXTRATO
							TRB->SEQRECON,;				//17 - SEQ RECONCILIACAO
							TRB->RECSE5,;				//18 - RECNO SE5
							TRB->OK,;					//19 - OK
							TRB->RECONSE5,;				//20 - RECON. SE5
							TRB->NATUREZ})				//21 - NATUREZA
							TRB->(DbSkip())
		End
		
		//ASORT(aVetor, , , { | x,y | x[4] < y[4] } )		
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Faz o calculo automatico de dimensoes de objetos     ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aSize := MSADVSIZE()
		
		DEFINE MSDIALOG oDlg TITLE cCadastro From aSize[7],0 To aSize[6],aSize[5] OF oMainWnd PIXEL
		oDlg:lMaximized := .T.
		
		oPanel := TPanel():New(0,0,'',oDlg,, .T., .T.,, ,30,30,.T.,.T. )
		
		DEFINE SBUTTON FROM 10,250 TYPE 1 ACTION (nOpca := 1,oDlg:End()) ENABLE OF oPanel
		DEFINE SBUTTON FROM 10,280 TYPE 2 ACTION (nOpca := 0,oDlg:End()) ENABLE OF oPanel
		DEFINE SBUTTON oBtn FROM 10,310 TYPE 4 ACTION (FA470EFET(aVetor)) ENABLE PIXEL OF oPanel
		oBtn:cToolTip := STR0036 //"Efetiva Lancto."
		oBtn:cCaption := Substr(STR0036,1,7) //"Efetiva Lancto."
		DEFINE SBUTTON oBtn FROM 10,340 TYPE 11 ACTION (FA470LEG()) ENABLE PIXEL OF oPanel
		oBtn:cToolTip := STR0019  //"Legenda"
		oBtn:cCaption := STR0019  //"Legenda"
		
		@10,370 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" SIZE 60,007 PIXEL OF oDlg ON Click(aEval(aVetor,{|x| x[2] := lChk}),oTitulo:Refresh())
		oPanel:Align := CONTROL_ALIGN_BOTTOM
		
		@ 01.0,.5 	LISTBOX oTitulo VAR cVarQ FIELDS ;
		HEADER " "," ", STR0010,;  //"Seq."
						STR0011,;  //"Data"
						STR0045,;	//"Agenc.Bco"
						STR0046,; 	//"Conta Bco"
						STR0012,;  //"Docto.Bco."
						STR0013,;  //"Valor Extrato"
						STR0014,;  //"Tipo"
						STR0054,;  //"Descrição"
						STR0015,;  //"D/C"
						STR0047,;  //"Agenc.SE5"
						STR0048,;	//"Conta SE5"
						STR0016,;  //"Docto.SE5"
						STR0017,;   //"Valor SE5"
						STR0053,;	//"Historico Extrato"
						"Natureza"; //"Natureza"
		SIZE 630,230 Of oDlg PIXEL ON dblClick(aVetor[oTitulo:nAt,2] := !aVetor[oTitulo:nAt,2],oTitulo:Refresh())
		oTitulo:SetArray(aVetor)
		
		oTitulo:bLine := {|| { aVetor[oTitulo:nAt,1],Iif(aVetor[oTitulo:nAt,2],oYes,oNot), aVetor[oTitulo:nAt,3], aVetor[oTitulo:nAt,4], aVetor[oTitulo:nAt,5], aVetor[oTitulo:nAt,6], aVetor[oTitulo:nAt,7],;
		aVetor[oTitulo:nAt,8], aVetor[oTitulo:nAt,9], aVetor[oTitulo:nAt,10], aVetor[oTitulo:nAt,11], aVetor[oTitulo:nAt,12], aVetor[oTitulo:nAt,13], aVetor[oTitulo:nAt,14], aVetor[oTitulo:nAt,15], aVetor[oTitulo:nAt,16], aVetor[oTitulo:nAt,21] }}
		
		If oChk <> Nil
			@245,010 CHECKBOX oChk VAR lChk Prompt "Marca/Desmarca" Size 60,007 PIXEL Of oDlg On Click(Iif(lChk,Marca(lChk),Marca(lChk)))
		EndIf
		
		ACTIVATE MSDIALOG oDlg
		
		If nOpca == 1
			For i := 1 To Len(aVetor)
				nRecSE5 := aVetor[i][18]
				If nRecSe5 > 0
					dbSelectArea("NEWSE5")
					dbGoto(nRecSE5)
					RecLock("NEWSE5")
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Caso j  tenha sido reconciliado no SE5, e tenha sido optado  ³
					//³ por se desreconciliar, grava branco no SE5->E5_RECONC        ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If aVetor[i][19] == 2 .and. !Empty(NEWSE5->E5_RECONC)
						Replace NEWSE5->E5_RECONC  With " "
					Endif
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Grava as reconciliacoes totais ou por chave parcial no SE5.    ³
					//³ e caso por chave parcial gravo a possivel nova data E5_DTDISPO ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If STR(aVetor[i][19],1) $ "1#3"
						cReconAnt := NEWSE5->E5_RECONC
						Replace NEWSE5->E5_RECONC  With "x"
						
						//Verifico atualizacao do saldo conciliado
						DO CASE
							CASE Empty(cReconAnt) .and. !Empty(NEWSE5->E5_RECONC)
								nReconc := 1 	//Se foi reconciliado agora 			
							CASE !Empty(cReconAnt) .and. Empty(NEWSE5->E5_RECONC)
								nReconc := 2 	//Se foi desconciliado agora
							CASE !Empty(cReconAnt) .and. !Empty(NEWSE5->E5_RECONC)
				            nReconc := 3	//Nao foi alterada a situacao anterior, mas ja estava conciliado
			   			CASE Empty(cReconAnt) .and. Empty(NEWSE5->E5_RECONC)		
				            nReconc := 3	//Nao foi alterada a situacao anterior, mas nao estava conciliado
						END CASE		
												
						//Atualiza saldo conciliado na data antiga
						lAtSalRec1 := IIF(nReconc == 2 .or. nReconc == 3, .T., .F.)
						//Atualiza saldo conciliado na data nova
						lAtSalRec2 := IIF(nReconc != 4, .T., .F.)
						
						//Ponto de entrada para que não se atulize a data de disponibilidade
						//do movimento bancario no sistema.
						If (Ctod(aVetor[i][4]) # NEWSE5->E5_DTDISPO) .and. lAtuDtDisp
							dOldDispo := NEWSE5->E5_DTDISPO
							
							Replace NEWSE5->E5_DTDISPO With Ctod(aVetor[i][4])
							If NEWSE5->E5_RECPAG == "P"
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,dOldDispo,NEWSE5->E5_VALOR,"+",lAtSalRec1)
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,"-",lAtSalRec2)
							Else
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,dOldDispo,NEWSE5->E5_VALOR,"-",lAtSalRec1)
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,"+",lAtSalRec2)
							Endif
						Else
							//Atualiza apenas o saldo reconciliado
							If nReconc == 2	//Desconciliou
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,IIF(NEWSE5->E5_RECPAG == "P","+","-"),.T.,.F.)
							Endif
							If nReconc == 1	//Conciliou
								AtuSalBco(NEWSE5->E5_BANCO,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DTDISPO,NEWSE5->E5_VALOR,IIF(NEWSE5->E5_RECPAG == "P","-","+"),.T.,.F.)
							Endif
						Endif
					Endif
					MsUnlock()
				EndIf
			Next
		EndIf
	Endif
Endif

dbSelectArea("TRB")
Set Filter To
dbCloseArea()
Ferase(cArqRec1+ GetDBExtension())
Ferase(cArqRec1+OrdBagExt())
Ferase(cArqRec2+OrdBagExt())
Ferase(cArqRec3+OrdBagExt())
Ferase(cArqRec4+OrdBagExt())
IF SELECT("NEWSE5") != 0
	dbSelectArea( "NEWSE5" )
	dbCloseArea()
	If !Empty(cIndex)
		FErase (cIndex+OrdBagExt())
	Endif
ENDIF
dbSelectArea("SE5")
dbSetOrder(1)

Return .F.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470ChecF³ Autor ³ Mauricio Pequim Jr.   ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Retorna Expresao para Indice Condicional					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fa470ChecF() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA470ChecF()

Local cFiltro := ""

cFiltro := 'NEWSE5->E5_FILIAL == "'+xFilial("SE5")+'" .And. ((DTOS(E5_DTDISPO) >= "'+DTOS(dDtIni)	+'" .And. DTOS(E5_DTDISPO) <= "'+DTOS(dDtFin)+ '") .Or. '
cFiltro += '(DTOS(E5_DTDISPO) <= "'+DTOS(mv_par09)+'" .And. DTOS(E5_DTDISPO) <= "'+DTOS(mv_par10)	+'" .And. '
cFiltro += 'E5_TIPODOC $ IIF(Type("MVCHEQUES") == "C",MVCHEQUES,MVCHEQUE))) .And. E5_BANCO == "'+mv_par03+'" .And. '
cFiltro += '!E5_TIPODOC $ "BA/DC/JR/MT/CM/D2/J2/M2/C2/V2/CP/TL" .And. E5_SITUACA <> "C" .And. E5_VALOR <> 0 .And. '
cFiltro += '(!E5_MOEDA $ "C1/C2/C3/C4/C5/CH" .Or. (E5_MOEDA $ "C1/C2/C3/C4/C5/CH"  .AND. E5_NUMCHEQ <> " ")) .And. '
cFiltro += '(E5_NUMCHEQ <> "*" .Or. (E5_NUMCHEQ = "*" .AND. E5_RECPAG <> "P"))'

Return cFiltro

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³F470CriArq³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 04/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Cria Estrutura do arquivo de trabalho   					  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³F470CriArq() 												  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Generico													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function F470CriArq()

Local aDbStru := aTamSX3 := {}

//Arquivo de reconciliacao
aadd(aDbStru,{"SEQMOV    ","C",04,0})
aadd(aDbStru,{"SEQRECON  ","C",04,0})
aadd(aDbStru,{"DATAMOV   ","C",10,0})
aadd(aDbStru,{"AGEMOV    ","C",TamSX3("A6_AGENCIA")[1],0})
aadd(aDbStru,{"CTAMOV    ","C",TamSX3("A6_NUMCON")[1],0})
aadd(aDbStru,{"NUMMOV    ","C",15,0})
aadd(aDbStru,{"VALORMOV  ","C",18,0})
aadd(aDbStru,{"TIPOMOV   ","C",03,0})
aadd(aDbStru,{"DESCMOV   ","C",LEN(SEJ->EJ_DESCR),0})
aadd(aDbStru,{"DEBCRED   ","C",01,0})
aadd(aDbStru,{"DESCRMOV  ","C",TamSX3("E5_HISTOR")[1],0})
aadd(aDbStru,{"AGESE5    ","C",TamSX3("A6_AGENCIA")[1],0})
aadd(aDbStru,{"CTASE5    ","C",TamSX3("A6_NUMCON")[1],0})
aadd(aDbStru,{"NUMSE5    ","C",15,0})
aadd(aDbStru,{"VALORSE5  ","C",18,0})
aadd(aDbStru,{"RECSE5    ","N",09,0})
aadd(aDbStru,{"OK        ","N",01,0})
aadd(aDbStru,{"RECONSE5  ","C",01,0})
aadd(aDbStru,{"NATUREZ   ","C",10,0})

cArqRec1 := CriaTrab(aDbStru, .T. )
cArqRec2 := Left(CriaTrab(Nil, .F. ),7)+"A"
cArqRec3 := Left(CriaTrab(Nil, .F. ),7)+"B"
cArqRec4 := Left(CriaTrab(Nil, .F. ),7)+"C"
dbUseArea(.T.,,cArqRec1,"TRB",.F.,.F.)
IndRegua("TRB",cArqRec1,"SEQMOV+DATAMOV",,,STR0007)  //"Selecionando Registros..."
IndRegua("TRB",cArqRec2,"AGEMOV+CTAMOV+NUMMOV+DATAMOV+VALORMOV+DEBCRED",,,STR0007)  //"Selecionando Registros..."
IndRegua("TRB",cArqRec3,"AGEMOV+CTAMOV+DATAMOV+VALORMOV+DEBCRED",,,STR0007)  //"Selecionando Registros..."
If mv_par04 # 0 .Or. mv_par05 # 0
	IndRegua("TRB",cArqRec4,"AGEMOV+CTAMOV+NUMMOV+VALORMOV+DEBCRED",,,STR0007)  //"Selecionando Registros..."
	DbClearIndex()
	DbSetIndex(cArqRec1 + OrdBagExt())
	DbSetIndex(cArqRec2 + OrdBagExt())
	DbSetIndex(cArqRec3 + OrdBagExt())
	DbSetIndex(cArqRec4 + OrdBagExt())
Else
	DbClearIndex()
	DbSetIndex(cArqRec1 + OrdBagExt())
	DbSetIndex(cArqRec2 + OrdBagExt())
	DbSetIndex(cArqRec3 + OrdBagExt())
Endif

Return

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470Leg	³ Autor ³ Mauricio Pequim Jr	³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Mostra Legenda da Reconciliacao                 			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470Leg 												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA470Leg()

Local oDlg2
Local nOpca2 := 0
Local lRet   := .T.

DEFINE MSDIALOG oDlg2 FROM  69,70 TO 165,331 TITLE  STR0026 PIXEL  //"Legenda - Reconcilia‡„o Autom tica"
@ 05 , 5 BITMAP NAME "BR_VERDE" 	SIZE 8,8 of Odlg2 PIXEL
@ 15 , 5 BITMAP NAME "BR_AMARELO" 	SIZE 8,8 of Odlg2 PIXEL
@ 25 , 5 BITMAP NAME "BR_CINZA" 	SIZE 8,8 of Odlg2 PIXEL
@ 35 , 5 BITMAP NAME "DISABLE" 		SIZE 8,8 of Odlg2 PIXEL
@ 05 , 19 SAY  STR0023  	SIZE 115, 7 OF oDlg2 PIXEL  //"  Reconciliado"
@ 15 , 19 SAY  STR0024  	SIZE 100, 7 OF oDlg2 PIXEL  //"  Reconciliado Parcial"
@ 25 , 19 SAY  STR0035  	SIZE 100, 7 OF oDlg2 PIXEL  //"  Reconciliado Anteriormente"
@ 35 , 19 SAY  STR0025  	SIZE 100, 7 OF oDlg2 PIXEL  //"  N„o Reconciliado"
DEFINE SBUTTON FROM 20, 100 TYPE 1 ENABLE ACTION (oDlg2:End()) OF oDlg2
ACTIVATE MSDIALOG oDlg2 CENTERED

Return lRet

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470EFET	³ Autor ³ Mauricio Pequim Jr	³ Data ³ 07/10/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Efetiva lancamento do extrato no SE5            			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470Efet												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA470Efet(aVetor)

Local cRecPagE5
Local oDlg3
Local oDlg4
Local nOpcaE 		:= 0
Local nOpcaN		:= 0
Local lAchou		:= .F.
Local cValorSE5		:= ""
Local cNaturEfet	:= CRIAVAR("ED_CODIGO")
Local cCCD			:= CRIAVAR("E5_CCD")	// Centro Custo Debito
Local cCCC			:= CRIAVAR("E5_CCC") // Centro Custo Credito
Local cItemD		:= CRIAVAR("E5_ITEMD")  //Item contabil Debito
Local cItemC		:= CRIAVAR("E5_ITEMC")  //Item contabil Credito
Local cClVlDb		:= CRIAVAR("E5_CLVLDB")  //Classe de Valor Debito
Local cClVlCr		:= CRIAVAR("E5_CLVLCR")  //Classe de Valor Credito
Local cCDeb			:= CRIAVAR("E5_DEBITO")	// Conta Contábil Debito
Local cCCrd			:= CRIAVAR("E5_CREDITO") // Conta Contábil Credito
Local cHistor		:= TRB->DESCRMOV // Historico do movimento
Local lIsCTB		:= IIF(CtbInUse(),.T.,.F.)
Local lConsulta 	:= IIF(CtbInUse(),"CTT","SI3")
Local lConsult2 	:= IIF(CtbInUse(),"CT1","SI1")
Local oBtn			:= Nil
Local lPmsInt		:=(Iif( FindFunction("IsIntegTop"),IsIntegTop(,.T.),GetNewPar("MV_RMCOLIG",0) > 0))

Private bPMSDlgMB	:= {||PmsDlgMB(3, NEWSE5->E5_PROJPMS, NEWSE5->E5_HISTOR, NEWSE5->E5_RECPAG)}
Private aRatAJE		:= {}

If IntePms().AND. !lPmsInt
	_SetOwnerPrvt("E5_VALOR", Val(StrTran(StrTran(TRB->VALORMOV, ",", ""), ".", "")) / 100)
EndIf

For i := 1 To Len(aVetor)
	If aVetor[i][2] == .T.
		cHistor	:= aVetor[i][16] // Historico do movimento
		If !(STR(aVetor[i][19],1) $ "1#3#4") .and. !Empty(aVetor[i][8])
			dbSelectArea("NEWSE5")
			IF	dbSeek (xFilial("SE5")+DTOS(CTOD(aVetor[i][4],"ddmmyy")))
				While !EOF() .and. DTOS(NEWSE5->E5_DTDISPO) == DTOS(CTOD(aVetor[i][4],"ddmmyy"))
					cRecPagE5 := IIF(NEWSE5->E5_RECPAG == "R", "C","D")
					//************************************************************
					// Esta validação estava impedindo a conciliação             *
					// quando o lançamento tinha na mesma data uma movimentaçao  *
					// de cheque. A validação foi alterada para so bloqueio se o *
					// Tipo do movimento for de cheque tambem.                   *
					//************************************************************
					IF !Empty(aVetor[i][7]) .and. aVetor[i][9] $ "CHQ" .and. NEWSE5->E5_NUMCHEQ == aVetor[i][7] .and. AllTrim(cRecPagE5) == AllTrim(aVetor[i][11])
						Help(" ",1,"A470EXIST")
						lAchou := .T.
						Exit
					Endif
					cValorSE5 := Transform(NEWSE5->E5_VALOR,"@E 999,999,999,999.99")
					If cValorSE5 == aVetor[i][8] .and. Empty(NEWSE5->E5_NUMCHEQ) .and. AllTrim(cRecPagE5) == AllTrim(aVetor[i][11])
						
						DEFINE MSDIALOG oDlg3 FROM  69,90 TO 220,400 TITLE  STR0027 PIXEL  //"Efetiva‡„o de Lan‡amento no SE5"
						@ 00 , 03 TO 55, 152 OF oDlg4 PIXEL
						@ 10 , 10 SAY  STR0028  SIZE 140, 7 OF oDlg3 PIXEL  //"Existe lan‡amento semelhante em Data, Valor e Carteira."
						@ 20 , 10 SAY  STR0029  SIZE 140, 7 OF oDlg3 PIXEL  //"no seu arquivo de movimentos banc rios.	Em caso de     "
						@ 30 , 10 SAY  STR0030  SIZE 140, 7 OF oDlg3 PIXEL  //"d£vida, n„o efetive o lan‡amento, pois poder  gerar    "
						@ 40 , 10 SAY  STR0031  SIZE 140, 7 OF oDlg3 PIXEL  //"duplicidade. Deseja efetivar este lan‡amento ?			"
						DEFINE SBUTTON FROM 60, 50 TYPE 1 ENABLE ACTION (nOpcaE:=1,oDlg3:End()) OF oDlg3
						DEFINE SBUTTON FROM 60, 80 TYPE 2 ENABLE ACTION (nOpcaE:=2,oDlg3:End()) OF oDlg3
						
						ACTIVATE MSDIALOG oDlg3 CENTERED
						
						If nOpcaE == 1
							lAchou := .F.
						Else
							lAchou := .T.
						Endif
						Exit
					Endif
					NEWSE5->(dbSkip())
				Enddo
			Endif
			If !lAchou
				FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)
				If IntePMS()
					PmsWriteMB(1, "SE5")
				EndIf
				oTitulo:Refresh()
			Endif
		Else
			Help(" ",1,"A470JA_REC")
		Endif
	EndIf
Next

Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Fa470GrvEf³ Autor ³ Mauricio Pequim Jr	³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³ Grava Efetivacao                                			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ Fa470GrvEf()												  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function FA470GrvEf(cNaturEfet,cCCC,cCCD,cItemD,cItemC,cClVlDb,cClVlCr,cCCrd,cCDeb,cHistor)

Local cValorMov	:= ""
Local aAreaSE5	:= {}
Local lContab	:= .F.
Local nRecno	:= 0
Local aArea		:= {}
Local lRet		:= .T.
Local lAtuSldNat := FindFunction("AtuSldNat") .AND. AliasInDic("FIV") .AND. AliasInDic("FIW")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Transforma TRB->VALORMOV (em formato europeu) para formato Americano  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cValorMov := ConValor(aVetor[i][8],18)

//Valida se existe Banco Agencia e Conta
//Posiciono o Banco para a contabilizacao
SA6->(DBSetOrder(1))
If !SA6->(MsSeek(xFilial("SA6")+mv_par03+aVetor[i][5]+aVetor[i][6]))
	IF !MsgYesNo(STR0055+mv_par03+"-"+aVetor[i][5]+"-"+aVetor[i][6]+") "+; //"A conta corrente da efetivação ("
		STR0056+chr(10)+;  //"não existe no seu cadastro de bancos. Caso prossiga a conta será criada no cadastro de bancos. "
		STR0057,STR0034) //" Prosseguir?"###"Atenção"
		lRet := .F.
	Endif
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Grava Movimentacao da efetivacao no SE5 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If lRet
	RecLock("NEWSE5",.T.)
	NEWSE5->E5_FILIAL	:= xFilial("SE5")
	NEWSE5->E5_BANCO	:= mv_par03
	NEWSE5->E5_AGENCIA	:= aVetor[i][5]
	NEWSE5->E5_CONTA	:= aVetor[i][6]
	NEWSE5->E5_DATA		:= CTOD(aVetor[i][4],"ddmmyy")
	NEWSE5->E5_DTDISPO	:= CTOD(aVetor[i][4],"ddmmyy")
	NEWSE5->E5_VENCTO	:= CTOD(aVetor[i][4],"ddmmyy")
	NEWSE5->E5_DTDIGIT	:= CTOD(aVetor[i][4],"ddmmyy")
	NEWSE5->E5_HISTOR 	:= IIF(Empty(cHistor),aVetor[i][16],cHistor)
	NEWSE5->E5_VALOR	:= Val(cValorMov)
	NEWSE5->E5_NATUREZ	:= aVetor[i][21]
	NEWSE5->E5_MOEDA  	:= IIF(aVetor[i][9]=="CHQ","C1","M1")
	NEWSE5->E5_RECPAG 	:= IIF(AllTrim(aVetor[i][11])=="D","P","R")
	NEWSE5->E5_CCC		:= cCCC
	NEWSE5->E5_CCD		:= cCCD
	NEWSE5->E5_CREDITO	:= cCCrd
	NEWSE5->E5_DEBITO	:= cCDeb
	If CtbInUse()
		NEWSE5->E5_ITEMD	:= cItemD
		NEWSE5->E5_ITEMC	:= cItemC
		NEWSE5->E5_CLVLDB	:= cClVlDb
		NEWSE5->E5_CLVLCR	:= cClVlCr
	Endif
	nRecno:=NEWSE5->(Recno())
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se o movimento ‚ referente a um cheque e grava nro do cheque.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	IF AllTrim(aVetor[i][9]) $ "CHQ"
		NEWSE5->E5_NUMCHEQ	:= aVetor[i][7]
	Endif
	MsUnlock()
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Atualiza saldo bancario quando da efetivação de movimento             ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	AtuSalBco(mv_par03,NEWSE5->E5_AGENCIA,NEWSE5->E5_CONTA,NEWSE5->E5_DATA,NEWSE5->E5_VALOR,iif(NEWSE5->E5_RECPAG == "R","+","-"))
	
	If lAtuSldNat
		If lAtuSldNat
			AtuSldNat(NEWSE5->E5_NATUREZ, NEWSE5->E5_DATA, "01", "3", NEWSE5->E5_RECPAG, NEWSE5->E5_VALOR, 0, "+",,FunName(),"NEWSE5", NEWSE5->(Recno()),0)
		Endif
	Endif
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava dados da Reconciliacao no Array ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	aVetor[i][2]  := .F.
	aVetor[i][18] := NEWSE5->(RECNO())
	aVetor[i][19] := 1
	aVetor[i][1]  := aCores[aVetor[i][19]]
	aVetor[i][15] := Transform(NEWSE5->E5_VALOR,"@E 999,999,999,999.99")
	aVetor[i][14] := NEWSE5->E5_NUMCHEQ
	aVetor[i][12] := NEWSE5->E5_AGENCIA
	aVetor[i][13] := NEWSE5->E5_CONTA
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se gera lancamento na contabilidade.³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If AllTrim(NEWSE5->E5_RECPAG) == "R"
		cPadrao:= "563"
		If VerPadrao(cPadrao)
			lContab:=.T.
		EndIf
	Else
		cPadrao:= "562"
		If VerPadrao(cPadrao)
			lContab:=.T.
		EndIf
	EndIf
	
	If lContab .and. lGeraLanc
		//Posiciono o Banco para a contabilizacao
		SA6->(DBSetOrder(1))
		SA6->(MSSeek(xFilial("SA6")+mv_par03+NEWSE5->E5_AGENCIA+NEWSE5->E5_CONTA))
		
		aAreaSE5:=SE5->(GetArea())
		aArea:=GetArea()
		DbSelectArea("SE5")
		DbGoTo(nRecno)
		If nHdlPrv <= 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Inicializa Lancamento Contabil                                   ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			nHdlPrv := HeadProva( cLote,"FINA470",Substr( cUsuario, 7, 6 ),@cArquivo )
			LoteCont("FIN")
		Endif
		
		If nHdlPrv > 0
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Prepara Lancamento Contabil ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			If lUsaFlag  // Armazena em aFlagCTB para atualizar no modulo Contabil
				aAdd( aFlagCTB, {"E5_LA", "S", "NEWSE5", NEWSE5->( Recno() ), 0, 0, 0} )
			Endif
			nTotal += DetProva( nHdlPrv,cPadrao,"FINA470",cLote,,,,,,,,@aFlagCTB,,)
		Endif
		
		SE5->(RestArea(aAreaSE5))
		RestArea(aArea)
		If !lUsaFlag
			RecLock("NEWSE5",.F.)
			NEWSE5->E5_LA := "S"
			MsUnlock()
		Endif
	EndIf
	
Endif
Return .T.

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³Chk470File³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 24/11/97 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Checa se arquivo de TB j  foi processado anteriormente	  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Chk470File()  											  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³Fina470													  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Chk470File(lReproc)

Local cFile := "CB"+cNumEmp+".VRF"
Local lRet	:= .F.
Local aFiles:= {}
Local cString
Local nTam
Local nHdlFile

If !FILE(cFile)
	nHdlFile := fCreate(cFile)
Else
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Tenta abrir o arquivo em modo exclusivo e Leitura/Gravacao ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	While (nHdlFile := fOpen(cFile,FO_READWRITE+FO_EXCLUSIVE)) == -1 .And. ;
		MsgYesNo( STR0050+cNumEmp+STR0051, STR0034 )
	End
Endif

If nHdlFile > 0
	
	nTam := TamSx1("AFI470","01")[1] // Tamanho do parametro
	xBuffer := SPACE(nTam)
	
	// Le o arquivo e adiciona na matriz
	While fReadLn(nHdlFile,@xBuffer,nTam)
		Aadd(aFiles, Trim(xBuffer))
	Enddo
	
	If ASCAN(aFiles,Trim(MV_PAR01)) > 0
		lRet := MSGYESNO(STR0049,STR0034)		//"Arquivo de Conciliação já processado anteriormente. Deseja proseguir ?"###"Atenção"
		If lRet
			lReproc := .T.
		Endif
	Else
		fSeek(nHdlFile,0,2) // Posiciona no final do arquivo
		cString := Alltrim(mv_par01)+Chr(13)+Chr(10)
		fWrite(nHdlFile,cString)	// Grava nome do arquivo a ser processado
		lRet := .T.
	endif
	fClose (nHdlFile)
Else
	Help(" ", 1, "CHK200ERRO") // Erro na leitura do arquivo de entrada
EndIf

Return lRet

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³A910VLDBCO ºAutor  ³ Totvs S/A	 	  º Data ³  01/09/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Valida o banco, agencia e conta                              º±±
±±º          ³Funcao retirada do FINA910A                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                          º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function A470VldBco( cBanco , cAgencia , cConta )

Local aAreaATU := GetArea()
Local cFilSA6  := xFilial( 'SA6' )
Local nSubAge  := 0
Local nSubCon  := 0
Local lStop    := .F.

If !SA6->( MsSeek( cFilSA6 + cBanco + cAgencia + cConta ) )
	SA6->( MsSeek( cFilSA6 + cBanco ) )
	
	While !SA6->( Eof() ) .And. cFilSA6 == SA6->A6_FILIAL .And. cBanco == SA6->A6_COD .And. !lStop
		nSubAge := At( Alltrim( SA6->A6_AGENCIA ) , cAgencia )
		nSubCon := At( Alltrim( SA6->A6_NUMCON  ) , cConta   )
		If nSubAge > 0 .And. nSubCon > 0
			If ( SubStr( cAgencia , 1 , nSubAge-1 ) == StrZero( 0 , nSubAge-1 ) .Or. ;// Valida 0 a esquerda: Agencia
				Alltrim( SA6->A6_AGENCIA ) == AllTrim( cAgencia ) ) ;
				.And. ;
				( SubStr( cConta   , 1 , nSubCon-1 ) == StrZero( 0 , nSubCon-1 ) .Or. ;// Valida 0 a esquerda: Conta Corrente
				Alltrim( SA6->A6_NUMCON  ) == AllTrim( cConta   ) )
				cAgencia := SA6->A6_AGENCIA
				cConta   := SA6->A6_NUMCON
				lStop    := .T.
			EndIf
		EndIf
		SA6->( DbSkip() )
	EndDo
EndIf

RestArea( aAreaATU )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Programa ³ Marca     º Autor ³ Rafael Domingues   º Data ³  18/03/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Desc.    ³ Funcao para marcar/desmarcar titulos para conciliacao       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ Isapa                                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function Marca(lMarca)

For i := 1 To Len(aVetor)
	aVetor[i][2] := lMarca
Next

oTitulo:Refresh()

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³fA470Par  ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 03/08/98 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Aciona parametros do Programa                               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function fA470Par()

Pergunte("AFI470")

Return .T.

/*
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Mauricio Pequim Jr    ³ Data ³ 20/08/13 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Insere novas perguntas ao SX1 								  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ FINA460                                                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function AjustaSX1()

Local aArea		:= GetArea()
Local aHelpPor	:= {}
Local aHelpSpa	:= {}
Local aHelpEng	:= {}

DbSelectArea("SX1")
DbSetOrder(1)

If MsSeek(PadR("AFI470",Len(SX1->X1_GRUPO)) + "06")
	RecLock("SX1",.F.)
	Replace X1_DEF02 With "Não"
	Replace X1_DEFSPA2 With "No"
	Replace X1_DEFENG2 With "No"
	SX1->(MsUnLock())
Endif

If MsSeek(PadR("AFI470",Len(SX1->X1_GRUPO)) + "07")
	RecLock("SX1",.F.)
	Replace X1_DEF02 With "Não"
	Replace X1_DEFSPA2 With "No"
	Replace X1_DEFENG2 With "No"
	SX1->(MsUnLock())
Endif

If MsSeek(PadR("AFI470",Len(SX1->X1_GRUPO)) + "08")
	RecLock("SX1",.F.)
	Replace X1_DEF02 With "Não"
	Replace X1_DEFSPA2 With "No"
	Replace X1_DEFENG2 With "No"
	SX1->(MsUnLock())
Endif

//Gestao
If !MsSeek(PadR("AFI470",Len(SX1->X1_GRUPO))+"11")
	
	//Pergunta 11 - Seleciona Filiais
	aHelpPor := {"Escolha Sim se deseja selecionar ","as filiais. ","Esta pergunta somente terá efeito em","ambiente TOPCONNECT / TOTVSDBACCESS."}
	aHelpEng := {"Enter Yes if you want to select ","the branches.","This question affects TOPCONNECT / ","TOTVSDBACCESS environment only."}
	aHelpSpa := {"La opción Sí, permite seleccionar ","las sucursales","Esta pregunta solo tendra efecto en el ","entorno TOPCONNECT / TOTVSDBACCESS."}
	
	PutSx1( "AFI470", "11", "Seleciona Filiais?" ,"¿Selecciona sucursales?" ,"Select Branches?","mv_chc","N",1,0,2,"C","","","","S","mv_par11","Sim","Si ","Yes","","Nao","No","No","","","","","","","","","",aHelpPor,aHelpEng,aHelpSpa)
	
	PutSX1Help("P.AFI47012.",aHelpPor,aHelpEng,aHelpSpa,.T.)
Endif

RestArea(aArea)

Return .T.
