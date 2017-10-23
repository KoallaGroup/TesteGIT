#INCLUDE "PROTHEUS.CH"                          
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"
#INCLUDE "Ap5Mail.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ IFINR03  ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO DO BRASIL COM CODIGO DE BARRAS   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IFINR03(_cPref,_cParce,_cNum,_cCli,_cLoja,cPasta,_cAgen,_cConta)
LOCAL aPergs	:= {} 
Local _aArea	:= GetArea()
Local _aAreaSA6	:= SA6->(GetArea())
Local _aAreaSE1	:= SE1->(GetArea())
Local _aAreaSEE	:= SEE->(GetArea())


PRIVATE lExec	:= .F., cIndexName := '', cIndexKey  := '', cFilter := '', cMarca := GetMark(), lInverte := .f.
Private titulo	:= "Impressao de Boleto com Codigo de Barras"
Private cPerg := PADR("IFINR03",Len(SX1->X1_GRUPO))  
PRIVATE cTitAux	:= ""
Private lArq := .F.

default	_cPref	:= ""
default _cParce := ""                                                     
default _cNum	:= ""
default _cCli	:= ""
default _cLoja	:= ""
default cPasta  := ""

If Empty(_cPref)  //Geração manual do boleto
	dbSelectArea("SE1")
	
	Aadd(aPergs,{"De Prefixo"		,"","","mv_ch1","C",03					,0,0,"G","","MV_PAR01","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Prefixo"		,"","","mv_ch2","C",03					,0,0,"G","","MV_PAR02","","","","ZZZ"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"De Numero"		,"","","mv_ch3","C",TamSx3("E1_NUM")[1]	,0,0,"G","","MV_PAR03","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Numero"		,"","","mv_ch4","C",TamSx3("E1_NUM")[1]	,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"De Parcela"		,"","","mv_ch5","C",01					,0,0,"G","","MV_PAR05","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Parcela"		,"","","mv_ch6","C",01					,0,0,"G","","MV_PAR06","","","","Z"		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Banco "			,"","","mv_ch7","C",03					,0,0,"G","","MV_PAR07","","","",""		,"","","","","","","","","","","","","","","","","","","","","SA6"	,"","","",""})
	Aadd(aPergs,{"Agencia"			,"","","mv_ch8","C",05					,0,0,"G","","MV_PAR08","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Num.Conta"		,"","","mv_ch9","C",10					,0,0,"G","","MV_PAR09","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"De Cliente"		,"","","mv_cha","C",06					,0,0,"G","","MV_PAR10","","","",""		,"","","","","","","","","","","","","","","","","","","","","SA1"	,"","","",""})
	Aadd(aPergs,{"Ate Cliente"		,"","","mv_chb","C",06					,0,0,"G","","MV_PAR11","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1"	,"","","",""})
	Aadd(aPergs,{"De Loja"			,"","","mv_chc","C",02					,0,0,"G","","MV_PAR12","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Loja"			,"","","mv_chd","C",02					,0,0,"G","","MV_PAR13","","","","ZZ"	,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"De Emissao"		,"","","mv_che","D",08					,0,0,"G","","MV_PAR14","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Emissao"		,"","","mv_chf","D",08					,0,0,"G","","MV_PAR15","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"De Vencimento"	,"","","mv_chg","D",08					,0,0,"G","","MV_PAR16","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"Ate Vencimento"	,"","","mv_chh","D",08					,0,0,"G","","MV_PAR17","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"% Multa"			,"","","mv_chi","N",05					,2,0,"G","","MV_PAR18","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	Aadd(aPergs,{"% Juros ao Dia"	,"","","mv_chj","N",06					,2,0,"G","","MV_PAR19","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	
	AjustaSx1(cPerg,aPergs)
	
	If !Pergunte (cPerg,.t.)
		Return
	EndIf
	
Else //Geração automatica do boleto

	DbSelectArea("SA6")
	DbSetOrder(1)  //Codigo + Nro Agencia + Nro Conta                                      
	If !(DbSeek(xFilial("SA6") + '001' + _cAgen + _cConta))
		Alert("Banco não localizado")
		Return
	EndIf	
	
	Pergunte(cPerg,.f.)
	mv_par01 := _cPref          		                                     // de Prefixo
	mv_par02 := _cPref			                                             // ate Prefixo
	mv_par03 := _cNum		                                                 // de Numero
	mv_par04 := _cNum		                                                 // ate Numero
	mv_par05 := _cParce						                                 // de Parcela
	mv_par06 := _cParce									                     // ate Parcela
	mv_par07 := SA6->A6_COD                                                  // Banco
	mv_par08 := SA6->A6_AGENCIA                                              // Agencia
	mv_par09 := SA6->A6_NUMCON                                               // Num. Conta
	mv_par10 := _cCli			                                             // de cliente
	mv_par11 := _cCli											             // ate cliente
	mv_par12 := _cLoja													     // de loja
	mv_par13 := _cLoja													     // ate loja
	mv_par14 := CTOD("01/01/" + Alltrim(Str(Year(SE1->E1_EMISSAO) - 2)))     // de emissão
	mv_par15 := CTOD("01/01/" + Alltrim(Str(Year(SE1->E1_EMISSAO) + 2)))     // ate emissão
	mv_par16 := CTOD("01/01/" + Alltrim(Str(Year(SE1->E1_VENCTO)  - 2)))     // de vencimento
	mv_par17 := CTOD("01/01/" + Alltrim(Str(Year(SE1->E1_VENCTO)  + 2)))     // ate vencimento
	mv_par18 := 0       													 // % multa
	mv_par19 := 0														     // % Juros ao Dia
	
EndIf

cIndexName	:= Criatrab(Nil,.F.)
cIndexKey	:= "E1_PORTADO+E1_CLIENTE+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+DTOS(E1_EMISSAO)"

cFilter		:= "E1_FILIAL=='"+xFilial("SE1")+"' .And. E1_SALDO>0 .And. "
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "' .And. E1_PREFIXO<='" + MV_PAR02 + "' .And. " 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "' .And. E1_NUM<='" + MV_PAR04 + "' .And. "
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "' .And. E1_PARCELA<='" + MV_PAR06 + "' .And. "
cFilter		+= "E1_CLIENTE>='" + MV_PAR10 + "' .And. E1_CLIENTE<='" + MV_PAR11 + "' .And. "
cFilter		+= "E1_LOJA>='" + MV_PAR12 + "' .And. E1_LOJA<='"+MV_PAR13+"' .And. "
cFilter		+= "E1_PORTADO =='" + MV_PAR07 + "' .And. E1_AGEDEP =='"+MV_PAR08+"' .And. "
cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par14)+"' .and. DTOS(E1_EMISSAO)<='"+DTOS(mv_par15)+"' .And. "
cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par16)+"' .and. DTOS(E1_VENCREA)<='"+DTOS(mv_par17)+"' .And. "
cFilter		+= "!(E1_TIPO$MVABATIM) "

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")                   
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()

If Empty(_cPref)  //Geração manual do boleto

	DEFINE MSDIALOG oDlg TITLE "Seleção dos títulos a serem impressos" From 0,0 To 350,800 PIXEL
	
	//Cria a MsSelect
	oMark := MsSelect():New("SE1","E1_OK","",,@lInverte,@cMarca,{0,1,150,400},,,,,)
	oMark:oBrowse:lCanAllMark := .f.
	
	//DEFINE SBUTTON OBJECT oBtn0 FROM 157,220 TYPE 1  ENABLE OF oDlg ACTION (IFINR01I("T")) 
	//DEFINE SBUTTON OBJECT oBtn1 FROM 157,260 TYPE 1  ENABLE OF oDlg ACTION (IFINR01I("I"))
	DEFINE SBUTTON OBJECT oBtn2 FROM 157,300 TYPE 1  ENABLE OF oDlg ACTION (MontaRel())
	DEFINE SBUTTON OBJECT oBtn3 FROM 157,340 TYPE 2  ENABLE OF oDlg ACTION (Close(oDlg))
	
	//oBtn0:cCaption	:= "Sel.Todos"
	//oBtn0:cToolTip	:= "Selecionar todos os títulos"
	
	//oBtn1:cCaption	:= "Inverter"
	//oBtn1:cToolTip	:= "Inverte a marcação dos títulos"
	
	//Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED 
	
		
	dbGoTop()
	
Else //Criacao automatica de boleto	 
	MontaRel(_cPref,cPasta)
EndIf
              
SE1->(DbCloseArea())

RestArea(_aAreaSA6)
RestArea(_aAreaSE1)
RestArea(_aAreaSEE)
RestArea(_aArea)


Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(_cPref,cPasta)
LOCAL oPrint
Local cCamBol	:= Alltrim(GETMV("MV__CAMBOL")) 
LOCAL nX := 0
Local cNroDoc :=  " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+          ; //[6]
								Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
								Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"JRS: Vl p/Dia Atraso - R$ "                ,;
								"///// ATENCAO ///// "                                   ,;
								"PROCEDA OS AJUSTES DE VALORES PERTINENTES"}

LOCAL nI            := 1
LOCAL aCB_RN_NN     := {}
LOCAL nVlrAbat		:= 0
default _cPref		:= ""
default cPasta		:= ""

//Montagem do PDF com FWMSPrinter 

dbGoTop()
ProcRegua(RecCount())

Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+SE1->E1_PORTADO+SE1->E1_AGEDEP+SE1->E1_CONTA,.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+SE1->(E1_PORTADO+E1_AGEDEP+E1_CONTA),.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD                        ,; 	// [1]Numero do Banco
                      SA6->A6_NOME      	            ,; 	// [2]Nome do Banco
	                  SUBSTR(SA6->A6_AGENCIA, 1, 4)     ,; 	// [3]Agência
                      alltrim(SA6->A6_NUMCON)			,; 	// [4]Conta Corrente
                      alltrim(SA6->A6_DVCTA)			,; 	// [5]Dígito da conta corrente
					"31"                                ,;	// [6]Codigo da Carteira
					alltrim(SA6->A6_DVAGE)				,;	// [7]Digito da agencia
                      SA6->A6__JUROS					,;	// [8]Juros de mora	
                      SA6->A6__MULTA					}	// [9]Multa de mora	
 	
	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+"-"+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
		SA1->A1_EST                                      ,;     		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		SA1->A1_PESSOA										}       				// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		SA1->A1_CEPC                                        ,;   	// [6]CEP
		SA1->A1_CGC												 		 ,;		// [7]CGC
		SA1->A1_PESSOA												 }				// [8]PESSOA
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao
	//	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),8)
	
	IF EMPTY(SE1->E1_NUMBCO)
		cNroDoc := Posicione("SX5", 1, xFilial("SX5")+"_2"+"BBRASI", "X5_DESCRI")
		cNroDoc := AllTrim(Strzero(Val(cNroDoc)+1,8))
	Else
		cNroDoc := ALLTRIM(SE1->E1_NUMBCO)	
	Endif                                 
	
	//Monta codigo de barras
	aCB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],cNroDoc,(E1_VALOR-nVlrAbat),E1_VENCTO)
	
	aDadosTit	:= {AllTrim(E1_NUM)+IIF(Empty(E1_PARCELA),"","-"+AllTrim(E1_PARCELA))	,;  // [1] Número do título
						E1_EMISSAO                              	,;  // [2] Data da emissão do título
						dDataBase                    					,;  // [3] Data da emissão do boleto
						E1_VENCTO                               	,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)                  	,;  // [5] Valor do título
						Substr(aCB_RN_NN[3],1,11) + "-" + Substr(aCB_RN_NN[3],12,1) ,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                               	,;  // [7] Prefixo da NF
						E1_TIPO	                           		}   // [8] Tipo do Titulo
	
	_lOk := .F. 
	
	If Empty(_cPref)
		_lOK := Marked("E1_OK")
	Else
		_lOK := .t.
		cCambol := cPasta
	EndIf
	
	If _lOK
		_cDiaAtu	:= (substr(dtoc(DATE()),7,4) + substr(dtoc(DATE()),4,2) + substr(dtoc(DATE()),1,2 ) )
        _cHoraAtu	:= (substr(Time(),1,2)		 + substr(Time(),4,2)		+ substr(Time(),7,2)	    )
//		_cBolNome := "bol_" + SE1->E1_PREFIXO + "_" + SE1->E1_NUM + "_" + SE1->E1_PARCELA + "_" + SE1->E1_TIPO           
		_cBolNome := Alltrim(SA1->A1_CGC) + "-" + Alltrim(SE1->E1_NUMBCO)      
		
		if(SE1->E1_NUM != cTitAux)
			if lArq
				oPrint:Print()
			EndIf
		
			oPrint:= FWMSPrinter():New(_cBolNome, IMP_PDF, .T., , .T.)
			oPrint:SetPortrait() // ou SetLandscape() 
			If !Empty(cPasta)
				oPrint:lViewPDF := .F.
			EndIf
			oPrint:cPathPDF := cCambol
			MakeDir(cCambol)
			oPrint:SetDevice(IMP_PDF)
			cTitAux := SE1->E1_NUM
			lArq := .T.
		EndIf

		oPrint:StartPage()   // Inicia uma nova página
		
		Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
		nX := nX + 1    
		
		oPrint:EndPage() // Finaliza a página
		
		if(SE1->E1_NUM != cTitAux)
			//Apaga arquivo .rel gerado
			If File(oPrint:cFilePrint)
				fErase(oPrint:cFilePrint)
			EndIf    
		EndIf
		
	EndIf
	dbSkip()
	IncProc()
	nI := nI + 1
EndDo     

//If(Type("oPrint") == "O")
	oPrint:Print()
//EndIf
 
If Empty(_cPref)  
	Close(oDlg)
EndIf

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASERDO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Impress(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,aCB_RN_NN)
LOCAL oFont8
LOCAL oFont11c
LOCAL oFont10
LOCAL oFont14
LOCAL oFont16n
LOCAL oFont15
LOCAL oFont14n
LOCAL oFont24
LOCAL nI := 0

//Parametros de TFont.New()
//1.Nome da Fonte (Windows)
//3.Tamanho em Pixels
//5.Bold (T/F)
oFont8   := TFont():New("Arial",9,8,.T.,.F.,5,.T.,5,.T.,.F.)
oFont8n  := TFont():New("Arial",9,8,.T.,.T.,5,.T.,5,.T.,.F.)
oFont9   := TFont():New("Arial",9,9,.T.,.T.,5,.T.,5,.T.,.F.)
oFont10  := TFont():New("Arial",9,10,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11  := TFont():New("Arial",9,11,.T.,.F.,5,.T.,5,.T.,.F.)
oFont11c := TFont():New("Courier New",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont11n := TFont():New("Arial",9,11,.T.,.T.,5,.T.,5,.T.,.F.)
oFont12  := TFont():New("Arial",9,12,.T.,.F.,5,.T.,5,.T.,.F.)
oFont12n := TFont():New("Arial",9,12,.T.,.T.,5,.T.,5,.T.,.F.)
oFont13n := TFont():New("Arial",9,13,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14  := TFont():New("Arial",9,14,.T.,.T.,5,.T.,5,.T.,.F.)
oFont14n := TFont():New("Arial",9,14,.T.,.F.,5,.T.,5,.T.,.F.)
oFont15  := TFont():New("Arial",9,15,.T.,.T.,5,.T.,5,.T.,.F.)
oFont15n := TFont():New("Arial",9,15,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16  := TFont():New("Arial",9,16,.T.,.F.,5,.T.,5,.T.,.F.)
oFont16n := TFont():New("Arial",9,16,.T.,.T.,5,.T.,5,.T.,.F.)
oFont20  := TFont():New("Arial",9,20,.T.,.T.,5,.T.,5,.T.,.F.)
oFont21  := TFont():New("Arial",9,21,.T.,.T.,5,.T.,5,.T.,.F.)
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

/******************/
/* PRIMEIRA PARTE */
/******************/

nRow2 := 50
cCliCgcCpf := "" 

if aDatSacado[8] = "J"
	cCliCgcCpf := "CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99") // CGC
Else
	cCliCgcCpf := "CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99")   	// CPF
EndIf
             

//Pontilhado para dividir recibos de sacado e entrega 
For nI := 100 to 510 step 50
	oPrint:Line(nRow2+nI, 1125, nRow2+nI+30, 1125)
Next nI


//Inicio do Recido do Sacado
oPrint:Line (nRow2+0090,0390,nRow2+0150,0390)
oPrint:Line (nRow2+0090,0580,nRow2+0150,0580) 

oPrint:Line (nRow2+0150,0100,nRow2+0510,0100)
oPrint:Line (nRow2+0150,1075,nRow2+0510,1075)
oPrint:Line (nRow2+0150,0100,nRow2+0150,1075)
oPrint:Line (nRow2+0240,0100,nRow2+0240,1075)
oPrint:Line (nRow2+0330,0100,nRow2+0330,1075)
oPrint:Line (nRow2+0420,0100,nRow2+0420,1075)
oPrint:Line (nRow2+0510,0100,nRow2+0510,1075)

oPrint:SayBitmap(nRow2 + 0045,0100,"bb.jpg",100,100)
oPrint:Say  (nRow2+0140,0410,"001-9"                                   ,oFont21)
oPrint:Say  (nRow2+0140,0590,"Recibo do Sacado"                                   ,oFont21)

oPrint:Say  (nRow2+0175,0105,"Vencimento"                                     ,oFont11)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 0105+(240-(len(cString)*22))
oPrint:Say  (nRow2+0210,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0175,0330,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3]+ "-" + aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol := 0370+(200-(len(cString)*11))
oPrint:Say  (nRow2+0210,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0175,0680,"Espécie Doc."                                   ,oFont11)
oPrint:Say  (nRow2+0210,0680,"Real"										,oFont13n) 
//oPrint:Say  (nRow2+0210,0680,aDadosTit[8]										,oFont13n) //Tipo do Titulo

oPrint:Say  (nRow2+0175,0900,"Quantidade"                                     ,oFont11)

oPrint:Say  (nRow2+0265,0105,"Valor do Documento"                          	,oFont11)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 0105+(263-(len(cString)*22))
oPrint:Say  (nRow2+0310,nCol,cString ,oFont13n)

oPrint:Say  (nRow2+0265,0415,"(-)Desconto/Abatimento"                         ,oFont11)
oPrint:Say  (nRow2+0265,0735,"(+)Mora / Juros / Multa"                                  ,oFont11)

oPrint:Say  (nRow2+0355,0105,"(=)Valor Cobrado"                               ,oFont11)

oPrint:Say  (nRow2+0355,0415,"Nosso Número"                                   ,oFont11)
cString := Substr(Alltrim(aDadosTit[6]),2) //Alltrim(/*Substr(aDadosTit[6],1,3)+"/"+*/Substr(aDadosTit[6],4))
nCol := 0375+(230-(len(cString)*11))                              
oPrint:Say  (nRow2+0400,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0355,0735,"N. do Documento"                                  ,oFont11)
oPrint:Say  (nRow2+0400,0755,aDadosTit[1]										,oFont10) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0445,0105,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow2+0475,0105,aDatSacado[1]		 				           ,oFont13n) 
oPrint:Say  (nRow2+0505,0105,cCliCgcCpf	             						,oFont13n) 

oPrint:Say  (nRow2+0535,0510,"Autenticação Mecânica"                                         ,oFont11)

oPrint:Line (nRow2+0150,0325,nRow2+0240,0325)
oPrint:Line (nRow2+0150,0675,nRow2+0240,0675)
oPrint:Line (nRow2+0150,0895,nRow2+0240,0895)
oPrint:Line (nRow2+0240,0410,nRow2+0420,0410)
oPrint:Line (nRow2+0240,0730,nRow2+0420,0730)

//Inicio do Recibo de Entrega
oPrint:Line (nRow2+0090,1465,nRow2+0150,1465)
oPrint:Line (nRow2+0090,1655,nRow2+0150,1655) 

oPrint:Line (nRow2+0150,1175,nRow2+0510,1175)
oPrint:Line (nRow2+0150,2150,nRow2+0510,2150)
oPrint:Line (nRow2+0150,1175,nRow2+0150,2150)
oPrint:Line (nRow2+0240,1175,nRow2+0240,2150)
oPrint:Line (nRow2+0330,1175,nRow2+0330,2150)
oPrint:Line (nRow2+0420,1175,nRow2+0420,2150)
oPrint:Line (nRow2+0510,1175,nRow2+0510,2150)

oPrint:SayBitmap(nRow2 + 0045,1180,"bb.jpg",100,100)
oPrint:Say  (nRow2+0140,1485,"001-9"                                   ,oFont21)
oPrint:Say  (nRow2+0140,1665,"Recibo de Entrega"                                   ,oFont21)     

oPrint:Say  (nRow2+0175,1180,"Vencimento"                                     ,oFont11)
cString	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol := 1180+(240-(len(cString)*22))
oPrint:Say  (nRow2+0210,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0175,1405,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3]+ "-" + aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])                 
nCol := 1405+(200-(len(cString)*11))
oPrint:Say  (nRow2+0210,nCol,cString,oFont13n)
  
oPrint:Say  (nRow2+0175,1755,"Espécie Doc."                                   ,oFont11)
oPrint:Say  (nRow2+0210,1755,"Real"											,oFont13n) 
//oPrint:Say  (nRow2+0210,1755,aDadosTit[8]										,oFont13n) //Tipo do Titulo

oPrint:Say  (nRow2+0175,1975,"Quantidade"                                     ,oFont11)

oPrint:Say  (nRow2+0265,1180,"Valor do Documento"                          	,oFont11)
cString := Alltrim(Transform(aDadosTit[5],"@E 99,999,999.99"))
nCol := 1180+(263-(len(cString)*22))
oPrint:Say  (nRow2+0310,nCol,cString ,oFont13n)

oPrint:Say  (nRow2+0265,1495,"Nosso Número"                                   ,oFont11)
cString := Substr(Alltrim(aDadosTit[6]),2) //Alltrim(/*Substr(aDadosTit[6],1,3)+"/"+*/Substr(aDadosTit[6],4))
nCol := 1495+(296-(len(cString)*11))
oPrint:Say  (nRow2+0310,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0355,1180,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow2+0385,1180,aDatSacado[1] 						               ,oFont13n)
oPrint:Say  (nRow2+0415,1180,cCliCgcCpf	               							,oFont13n)
                       
oPrint:Say  (nRow2+0445,1180,"Assinatura do Recebedor"                                         ,oFont11)
oPrint:Say  (nRow2+0445,1810,"Data de Entrega"                                         ,oFont11)

oPrint:Line (nRow2+0150,1400,nRow2+0240,1400) 
oPrint:Line (nRow2+0150,1750,nRow2+0240,1750) 
oPrint:Line (nRow2+0150,1970,nRow2+0240,1970) 
oPrint:Line (nRow2+0240,1485,nRow2+0330,1485) 
oPrint:Line (nRow2+0420,1805,nRow2+0510,1805) 


/******************/
/* SEGUNDA PARTE  */
/******************/

nRow3 := -900 
                                                                                               
For nI := 100 to 2150 step 50
	oPrint:Line(nRow3+1550, nI, nRow3+1550, nI+30)
Next nI

oPrint:Say  (nRow3+1600,1850 ,"Corte Aqui",oFont10)
oPrint:Line (nRow3+1700,100,nRow3+1700,2150)    
oPrint:Line (nRow3+1640,500,nRow3+1700, 500)
oPrint:Line (nRow3+1640,710,nRow3+1700, 710)

//oPrint:Say  (nRow3+1685,220,"BANCO DO BRASIL",oFont12n )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1685,500,"001-9",oFont24 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1685,800,aCB_RN_NN[2],oFont16n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1790,100,nRow3+1790,2150 )
oPrint:Line (nRow3+1880,100,nRow3+1880,2150 )
oPrint:Line (nRow3+1940,100,nRow3+1940,2150 )
oPrint:Line (nRow3+2000,100,nRow3+2000,2150 )

oPrint:Line (nRow3+1880,470 ,nRow3+2000,470 )
oPrint:Line (nRow3+1940,790 ,nRow3+2000,790 )
oPrint:Line (nRow3+1880,940 ,nRow3+2000,940 )
oPrint:Line (nRow3+1880,1220,nRow3+1940,1220)
oPrint:Line (nRow3+1880,1360,nRow3+2000,1360)

oPrint:SayBitmap(nRow3 + 1590,0105,"bb.jpg",100,100)
oPrint:Say  (nRow3+1725,105 ,"Local de Pagamento",oFont11)
oPrint:Say  (nRow3+1770,105 ,"Pagável em qualquer banco até o vencimento",oFont13n)
           
oPrint:Say  (nRow3+1725,1690,"Vencimento",oFont11)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1770,nCol,cString,oFont13n)

oPrint:Say  (nRow3+1815,105 ,"Cedente",oFont11)
oPrint:Say  (nRow3+1860,105 ,aDadosEmp[1]									,oFont13n) //Nome 

oPrint:Say  (nRow3+1815,1690,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3]+ "-" + aDadosBanco[7]+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1860,nCol,cString ,oFont13n)


oPrint:Say  (nRow3+1905,105 ,"Data do Documento"                              ,oFont11)
oPrint:Say (nRow3+1935,115, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont13n)


oPrint:Say  (nRow3+1905,480 ,"Número do Documento",oFont11)
oPrint:Say  (nRow3+1935,520 ,aDadosTit[1],oFont13n) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1905,950,"Espécie Doc.",oFont11)
oPrint:Say  (nRow3+1935,980,"DM",oFont13n) 

oPrint:Say  (nRow3+1905,1230,"Aceite",oFont11)
oPrint:Say  (nRow3+1935,1240,"N",oFont13n)

oPrint:Say  (nRow3+1905,1365,"Data do Processamento"                ,oFont11)
oPrint:Say  (nRow3+1935,1375,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)  ,oFont13n) // Data impressao

oPrint:Say  (nRow3+1905,1690,"Nosso Número"                                   ,oFont11)
cString := Substr(Alltrim(aDadosTit[6]),2) //Alltrim(/*Substr(aDadosTit[6],1,3)+"/"+*/Substr(aDadosTit[6],4))
nCol 	 := 1690+(296-(len(cString)*11))
oPrint:Say  (nRow3+1935,nCol,cString,oFont13n)


oPrint:Say  (nRow3+1965,105 ,"Nº da Conta / Respons."                                       ,oFont11)

oPrint:Say  (nRow3+1965,480 ,"Carteira"                                       ,oFont11)
oPrint:Say  (nRow3+1995,500 ,aDadosBanco[6]                                  	,oFont13n)

oPrint:Say  (nRow3+1965,800 ,"Espécie"                                        ,oFont11)
oPrint:Say  (nRow3+1995,830 ,"R$"                                             ,oFont13n)

oPrint:Say  (nRow3+1965,950,"Quantidade"                                     ,oFont11)
oPrint:Say  (nRow3+1965,1370,"(x) Valor"                                          ,oFont11)

oPrint:Say  (nRow3+1965,1690,"(=) Valor do Documento"                          	,oFont11)
cString  := Transform(aDadosTit[5],"@E 99,999,999.99")
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1995,nCol,cString,oFont13n)

oPrint:Say  (nRow3+2040,105 ,"Instruções: ",oFont11)
//oPrint:Say  (nRow3+2080,105 ,aBolText[1]+" "+AllTrim(Transform((aDadosTit[5]*0.02),"@E 99,999.99"))      ,oFont13n)
oPrint:Say  (nRow3+2080,105 ,aBolText[1]+" "+AllTrim(Transform(aDadosTit[5] * (aDadosBanco[8]/100),"@E 99,999.99"))  ,oFont13n)
oPrint:Say  (nRow3+2120,105 ,aBolText[2]+" ",oFont13n)
oPrint:Say  (nRow3+2160,105 ,aBolText[3]                                        ,oFont13n)

oPrint:Say  (nRow3+2025,1690,"(-)Desconto/Abatimento"                         ,oFont11)
oPrint:Say  (nRow3+2085,1690,"(-)Outras Deduções"                             ,oFont11)
oPrint:Say  (nRow3+2145,1690,"(+)Mora/Multa"                                  ,oFont11)
oPrint:Say  (nRow3+2205,1690,"(+)Outros Acréscimos"                           ,oFont11)
oPrint:Say  (nRow3+2265,1690,"(=)Valor Cobrado"                               ,oFont11)
cString  := Transform(aDadosTit[5],"@E 99,999,999.99")
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+2295,nCol,cString,oFont13n)

oPrint:Say  (nRow3+2330,0105 ,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow3+2330,0240 ,aDatSacado[1]						             ,oFont13n)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3 + 2330,1690,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont13n) // CGC
Else
	oPrint:Say  (nRow3 + 2330,1690,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont13n) 	// CPF
EndIf

oPrint:Say  (nRow3+2370,0105,"Endereço",oFont11)
oPrint:Say  (nRow3+2370,0240,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2410,0240,aDatSacado[6]+"    "+aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado

oPrint:Say  (nRow3+2520,105 ,"Sacador/Avalista"                               ,oFont10)
oPrint:Say  (nRow3+2520,1500,"Autenticação Mecânica - Ficha de Compensação"                        ,oFont10)

oPrint:Line (nRow3+1700,1680,nRow3+2300,1680 )
oPrint:Line (nRow3+2060,1685,nRow3+2060,2150 ) //Desconto/Abatimento
oPrint:Line (nRow3+2120,1685,nRow3+2120,2150 )
oPrint:Line (nRow3+2180,1685,nRow3+2180,2150 )
oPrint:Line (nRow3+2240,1685,nRow3+2240,2150 )
oPrint:Line (nRow3+2300,0100,nRow3+2300,2150 )
oPrint:Line (nRow3+2500,0100,nRow3+2500,2150 )
oPrint:Line (nRow3+1700,0100,nRow3+2500,0100 )
oPrint:Line (nRow3+1700,2150,nRow3+2500,2150 )

oPrint:FwMsBar("INT25",42.5,4,aCB_RN_NN[1],oPrint,.F.,,.T.,0.020,1.01,NIL,NIL,NIL,.F.) 

//oPrint:Code128C(nRow3+2710,0150,aCB_RN_NN[1], 48)

IF EMPTY(SE1->E1_NUMBCO) .AND. alltrim(aDadosBanco[1])=='001'
	DbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"_2"+"BBRASI")
	While !RecLock("SX5",.F.)
	Enddo
	SX5->X5_DESCRI 	:=	Alltrim(substr(aDadosTit[6],4,8))   // sequencia do Nosso número 
	MsUnlock()

	DbSelectArea("SE1")
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO 	:=	aCB_RN_NN[3]   // Nosso número (Ver fórmula para calculo)
	MsUnlock()  
	
ENDIF

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo10 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo10(cData)
LOCAL L,D,P := 0
LOCAL B     := .F.
L := Len(cData)
B := .T.
D := 0
While L > 0
	P := Val(SubStr(cData, L, 1))
	If (B)
		P := P * 2
		If P > 9
			P := P - 9
		End
	End
	D := D + P
	L := L - 1
	B := !B
End
D := 10 - (Mod(D,10))
If D = 10
	D := 0
End
Return(D)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ Modulo11 ³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO ITAU COM CODIGO DE BARRAS     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Modulo11(cData)
LOCAL L, D, P := 0
L := Len(cdata)
D := 0
P := 1
While L > 0
	P := P + 1
	D := D + (Val(SubStr(cData, L, 1)) * P)
	If P = 9
		P := 1
	End
	L := L - 1
End
D := 11 - (mod(D,11))
If (D == 0 .Or. D == 1 .Or. D == 10 .Or. D == 11)
	D := 1
End
Return(D)


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³Ret_cBarra³ Autor ³ Microsiga             ³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASE DO ITAU COM CODIGO DE BARRAS      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)

LOCAL cValorFinal := strzero(nValor*100,10)//strzero(int(nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator        := strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCart			:= "31"
//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------
cS    :=  IIF(Len(cNroDoc) > 9,cNroDoc,cAgencia + cConta + cCart + cNroDoc)
nDvnn := modulo10(cS) // digito verificador Agencia + Conta + Carteira + Nosso Num
cNN   := cS //cCart + cNroDoc + AllTrim(Str(nDvnn))

//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cS:= cBanco + cFator +  cValorFinal + Substr(cNN,1,Len(cNN)-1) + cAgencia + '000' + cConta + cCart
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DDFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS    := cBanco + /*cCart +*/ SubStr(cNroDoc,1,5)
nDv   := modulo10(cS)
cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      

// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS :=Subs(cNN,6,6) + /*Alltrim(Str(nDvnn))+ */Subs(cAgencia,1,4)
nDv:= modulo10(cS)
cRN := cRN /*Subs(cBanco,1,3) + "9" + Subs(cCart,1,1)+'.'+ Subs(cCart,2,3) + Subs(cNN,4,2) + SubStr(cRN,11,1)+ ' '*/ +  Subs(cNN,6,5) +'.'+ Subs(cNN,11,1) /*+ Alltrim(Str(nDvnn))*/+ Subs(cAgencia,1,4) +Alltrim(Str(nDv)) + ' ' 

// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS    := '000' + /*Subs(cAgencia,4,1) +*/ Subs(cConta,1,5) +  cCart //+'000'
nDv   := modulo10(cS)
cRN   := cRN + Substr(cS,1,5) /*Subs(cAgencia,4,1) + Subs(cConta,1,4) */+ '.' + Substr(cS,6) + Alltrim(Str(nDv))//Subs(cConta,5,1)+Alltrim(cDacCC)+'000'+ Alltrim(Str(nDv))

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN   := cRN + ' ' + AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
//cRN   := cRN + cFator + StrZero(Int(nValor * 100),14-Len(cFator))
cRN   := cRN + cFator + StrZero(nValor * 100,14-Len(cFator))

Return({cCB,cRN,cNN})


/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ AjustaSx1    ³ Autor ³ Microsiga            	³ Data ³ 13/10/03 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Verifica/cria SX1 a partir de matriz para verificacao          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Especifico para Clientes Microsiga                    	  		³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function AjustaSX1(cPerg, aPergs)

Local _sAlias	:= Alias()
Local aCposSX1	:= {}
Local nX 		:= 0
Local lAltera	:= .F.
Local nCondicao
Local cKey		:= ""
Local nJ			:= 0

aCposSX1:={"X1_PERGUNT","X1_PERSPA","X1_PERENG","X1_VARIAVL","X1_TIPO","X1_TAMANHO",;
			"X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID",;
			"X1_VAR01","X1_DEF01","X1_DEFSPA1","X1_DEFENG1","X1_CNT01",;
			"X1_VAR02","X1_DEF02","X1_DEFSPA2","X1_DEFENG2","X1_CNT02",;
			"X1_VAR03","X1_DEF03","X1_DEFSPA3","X1_DEFENG3","X1_CNT03",;
			"X1_VAR04","X1_DEF04","X1_DEFSPA4","X1_DEFENG4","X1_CNT04",;
			"X1_VAR05","X1_DEF05","X1_DEFSPA5","X1_DEFENG5","X1_CNT05",;
			"X1_F3", "X1_GRPSXG", "X1_PYME","X1_HELP" }

dbSelectArea("SX1")
dbSetOrder(1)
For nX:=1 to Len(aPergs)
	lAltera := .F.
	If MsSeek(cPerg+Right(aPergs[nX][11], 2))
		If (ValType(aPergs[nX][Len(aPergs[nx])]) = "B" .And.;
			 Eval(aPergs[nX][Len(aPergs[nx])], aPergs[nX] ))
			aPergs[nX] := ASize(aPergs[nX], Len(aPergs[nX]) - 1)
			lAltera := .T.
		Endif
	Endif
	
	If ! lAltera .And. Found() .And. X1_TIPO <> aPergs[nX][5]	
 		lAltera := .T.		// Garanto que o tipo da pergunta esteja correto
 	Endif	
	
	If ! Found() .Or. lAltera
		RecLock("SX1",If(lAltera, .F., .T.))
		Replace X1_GRUPO with cPerg
		Replace X1_ORDEM with Right(aPergs[nX][11], 2)
		For nj:=1 to Len(aCposSX1)
			If 	Len(aPergs[nX]) >= nJ .And. aPergs[nX][nJ] <> Nil .And.;
				FieldPos(AllTrim(aCposSX1[nJ])) > 0
				Replace &(AllTrim(aCposSX1[nJ])) With aPergs[nx][nj]
			Endif
		Next nj
		MsUnlock()
		cKey := "P."+AllTrim(X1_GRUPO)+AllTrim(X1_ORDEM)+"."

		If ValType(aPergs[nx][Len(aPergs[nx])]) = "A"
			aHelpSpa := aPergs[nx][Len(aPergs[nx])]
		Else
			aHelpSpa := {}
		Endif
		
		If ValType(aPergs[nx][Len(aPergs[nx])-1]) = "A"
			aHelpEng := aPergs[nx][Len(aPergs[nx])-1]
		Else
			aHelpEng := {}
		Endif

		If ValType(aPergs[nx][Len(aPergs[nx])-2]) = "A"
			aHelpPor := aPergs[nx][Len(aPergs[nx])-2]
		Else
			aHelpPor := {}
		Endif

		PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)
	Endif
Next