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
±±³Programa  ³ IFINR02 ³ Autor ³ Rubens Cruz       ³ Data ³ 12/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO BANCO BRADESCO COM CODIGO DE BARRAS    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ ISAPA							                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function IFINR02(_cPref,_cParce,_cNum,_cCli,_cLoja,cPasta,_cAgen,_cConta)

LOCAL	aPergs 		:= {} 
PRIVATE lExec    	:= .F., cIndexName := '', cIndexKey  := '', cFilter := '', cMarca := GetMark(), lInverte := .f.
PRIVATE cIndexName 	:= ''
PRIVATE cIndexKey  	:= ''
PRIVATE cFilter    	:= ''
cPerg     			:= "BLTBAR    "
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
	
	Aadd(aPergs,{"De Prefixo","","","mv_ch1","C",3,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Prefixo","","","mv_ch2","C",3,0,0,"G","","MV_PAR02","","","","ZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Numero","","","mv_ch3","C",6,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Numero","","","mv_ch4","C",6,0,0,"G","","MV_PAR04","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Parcela","","","mv_ch5","C",1,0,0,"G","","MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Parcela","","","mv_ch6","C",1,0,0,"G","","MV_PAR06","","","","Z","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Banco ","","","mv_ch7","C",3,0,0,"G","","MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","SA6","","","",""})
	Aadd(aPergs,{"Agencia","","","mv_ch8","C",5,0,0,"G","","MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Num.Conta","","","mv_ch9","C",10,0,0,"G","","MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Cliente","","","mv_cha","C",6,0,0,"G","","MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	Aadd(aPergs,{"Ate Cliente","","","mv_chb","C",6,0,0,"G","","MV_PAR11","","","","ZZZZZZ","","","","","","","","","","","","","","","","","","","","","SA1","","","",""})
	Aadd(aPergs,{"De Loja","","","mv_chc","C",2,0,0,"G","","MV_PAR12","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Loja","","","mv_chd","C",2,0,0,"G","","MV_PAR13","","","","ZZ","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Emissao","","","mv_che","D",8,0,0,"G","","MV_PAR14","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Emissao","","","mv_chf","D",8,0,0,"G","","MV_PAR15","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"De Vencimento","","","mv_chg","D",8,0,0,"G","","MV_PAR16","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"Ate Vencimento","","","mv_chh","D",8,0,0,"G","","MV_PAR17","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"% Multa","","","mv_chi","N",5,2,0,"G","","MV_PAR18","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	Aadd(aPergs,{"% Juros ao Dia","","","mv_chj","N",5,2,0,"G","","MV_PAR19","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
	
	AjustaSx1(cPerg,aPergs)
	
	Pergunte (cPerg,.T.)
	                     
Else //Geração automatica do boleto

	DbSelectArea("SA6")
	DbSetOrder(1)  //Codigo + Nro Agencia + Nro Conta                                      
	If !(DbSeek(xFilial("SA6") + '237' + _cAgen + _cConta))
		Alert("Banco não localizado")
		Return
	EndIf	
	
	Pergunte(cPerg,.f.)
	mv_par01 := _cPref          		                                     // de Prefixo
	mv_par02 := _cPref			                                             // ate Prefixo
	mv_par03 := _cNum		                                                 // de Numero
	mv_par04 := _cNum		                                                 // ate Numero
	mv_par05 := _cParce                               						 // de Parcela
	mv_par06 := _cParce                    					   				 // ate Parcela
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

cFilter		+= "E1_FILIAL=='"+xFilial("SE1")+"' .And. E1_SALDO>0 .And. "
cFilter		+= "E1_PORTADO == '" + MV_PAR07 + "' .And. "
cFilter		+= "E1_AGEDEP == '" + MV_PAR08 + "' .And. "
cFilter		+= "E1_CONTA == '" + MV_PAR09 + "' .And. "
cFilter		+= "E1_PREFIXO>='" + MV_PAR01 + "' .And. E1_PREFIXO<='" + MV_PAR02 + "' .And. " 
cFilter		+= "E1_NUM>='" + MV_PAR03 + "' .And. E1_NUM<='" + MV_PAR04 + "' .And. "
cFilter		+= "E1_PARCELA>='" + MV_PAR05 + "' .And. E1_PARCELA<='" + MV_PAR06 + "' .And. "
cFilter		+= "E1_CLIENTE>='" + MV_PAR10 + "' .And. E1_CLIENTE<='" + MV_PAR11 + "' .And. "
cFilter		+= "E1_LOJA>='" + MV_PAR12 + "' .And. E1_LOJA<='"+MV_PAR13+"' .And. "
//cFilter		+= "DTOS(E1_EMISSAO)>='"+DTOS(mv_par14)+"' .and. DTOS(E1_EMISSAO)<='"+DTOS(mv_par15)+"' .And. "
//cFilter		+= "DTOS(E1_VENCREA)>='"+DTOS(mv_par16)+"' .and. DTOS(E1_VENCREA)<='"+DTOS(mv_par17)+"' .And. "
cFilter		+= "!(E1_TIPO$MVABATIM) "

IndRegua("SE1", cIndexName, cIndexKey,, cFilter, "Aguarde selecionando registros....")
DbSelectArea("SE1")                   
#IFNDEF TOP
	DbSetIndex(cIndexName + OrdBagExt())
#ENDIF
dbGoTop()                 
           
If Empty(_cPref)  //Geração manual do boleto

	DEFINE MSDIALOG oDlg TITLE "Seleção dos títulos a serem impressos" From 0,0 To 350,800 PIXEL
	
	oMark := MsSelect():New("SE1","E1_OK","",,@lInverte,@cMarca,{0,1,150,400},,,,,)
	oMark:oBrowse:lCanAllMark := .f.
	
	DEFINE SBUTTON OBJECT oBtn2 FROM 157,300 TYPE 1  ENABLE OF oDlg ACTION (MontaRel())
	DEFINE SBUTTON OBJECT oBtn3 FROM 157,340 TYPE 2  ENABLE OF oDlg ACTION (Close(oDlg))
	
	ACTIVATE MSDIALOG oDlg CENTERED 
		
	dbGoTop()
	           
Else //Criacao automatica de boleto	 
	montarel(_cPref,cPasta)
EndIf
              
SE1->(DbCloseArea())

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  MontaRel³ Autor ³ Silverio Bastos       ³ Data ³ 07/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BRADESCO COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Isapa    							                      ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function MontaRel(_cPref,cPasta)
LOCAL oPrint
LOCAL nX := 0
Local cNroDoc :=  " "    
Local cCamBol	:= Alltrim(GETMV("MV__CAMBOL")) 
LOCAL cCart		:= "02"
Local _cSeqNum := _cDigNum	:= " "
LOCAL aDadosEmp    := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
								SM0->M0_ENDCOB                                     ,; //[2]Endereço
								AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
								"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
								"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
								"CNPJ: "+ Transform(SM0->M0_CGC,PesqPict("SA2","A2_CGC"))                 ,; //[6]
								Subs(SM0->M0_CGC,14,2)                                                    ,; //[6]CGC
								"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
								Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {"Após o Vencimento Cobrar Multa de R$ "                	,;
								""			                                   	,;
								"MORA DIA COM PERMANENC. "                    	,;
								"APÓS 7 DIAS, SERÁ ENVIADO PARA CARTÓRIO"		,;
								"PROTESTAR NO DÉCIMO DIA"						,;
								"TITULO NEGOCIADO PAGAVEL SOMENTE EM BANCO OU REDE DE CORRESPONTES"}

LOCAL nI           	:= 1
LOCAL aCB_RN_NN  	:= {}
LOCAL nVlrAbat		:= 0
default	_cPref		:= ""
default cPasta		:= "" 

dbGoTop()
ProcRegua(RecCount())
Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+MV_PAR07+MV_PAR08+MV_PAR09,.T.)
	
	//Posiciona na Arq de Parametros CNAB
	DbSelectArea("SEE")
	DbSetOrder(1)
	DbSeek(xFilial("SEE")+MV_PAR07+MV_PAR08+MV_PAR09,.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial()+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
	
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD                        ,; 	// [1]Numero do Banco
                      SA6->A6_NOME      	            ,; 	// [2]Nome do Banco
	                  SUBSTR(SA6->A6_AGENCIA, 1, 4)		,;	// [3]Agência
                      AllTrim(SA6->A6_NUMCON)			,; 	// [4]Conta Corrente
                      SA6->A6_DVCTA  					,; 	// [5]Dígito da conta corrente
                      cCart                            	,;  // [6]Codigo da Carteira
                      SA6->A6_DVAGE   					,;	// [7]Digito da agencia
                      SA6->A6__JUROS					,;	// [8]Juros de mora	
                      SA6->A6__MULTA					}	// [9]Multa de mora	

	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)        ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
   		AllTrim(SA1->A1_END )/*+"-"+AllTrim(SA1->A1_BAIRRO)*/,;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  			// [4]Cidade
		SA1->A1_EST                                      ,;     		// [5]Estado
		SA1->A1_CEP                                      ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		SA1->A1_PESSOA										}       				// [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)         ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA           ,;      	// [2]Código
   		AllTrim(SA1->A1_ENDCOB)/*+"-"+AllTrim(SA1->A1_BAIRROC)*/,;      	// [3]Endereço
		AllTrim(SA1->A1_MUNC)                            ,;  			// [4]Cidade
		SA1->A1_ESTC                                     ,;     		// [5]Estado
		SA1->A1_CEPC                                     ,;      	// [6]CEP
		SA1->A1_CGC										          ,;  			// [7]CGC
		SA1->A1_PESSOA										}       				// [8]PESSOA
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	//Aqui defino parte do nosso numero. Sao 8 digitos para identificar o titulo. 
	//Abaixo apenas uma sugestao
	cNroDoc	:= StrZero(	Val(Alltrim(SE1->E1_NUM)+Alltrim(SE1->E1_PARCELA)),9)
	
	IF EMPTY(SE1->E1_NUMBCO)
		_cSeqNum := Posicione("SX5", 1, xFilial("SX5")+"_2"+"BRADES", "X5_DESCRI")
		_cSeqNum := AllTrim(Strzero(Val(_cSeqNum)+1,11))
	Else
		_cSeqNum := ALLTRIM(SE1->E1_NUMBCO)
	Endif
	//Monta codigo de barras
	aCB_RN_NN   := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],_cSeqNum,(E1_VALOR-nVlrAbat),E1_VENCTO)
    cCodBar237	:= aCB_RN_NN[1] //MtCodBar(aDadosBanco[3],aDadosBanco[7],aDadosBanco[4],aDadosBanco[6],aDadosBanco[5],_cSeqNum,(E1_VALOR-nVlrAbat),E1_VENCTO)
    cLinDig237	:= MtLinDig(cCodBar237)

	aDadosTit	:= {AllTrim(E1_NUM)+IIF(Empty(E1_PARCELA),"","-"+AllTrim(E1_PARCELA))	,;  // [1] Número do título
						E1_EMISSAO                              	,;  // [2] Data da emissão do título
						dDataBase                    					,;  // [3] Data da emissão do boleto
						E1_VENCTO                               	,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)                  	,;  // [5] Valor do título
						aCB_RN_NN[3]              	,;  // [6] Nosso número (Ver fórmula para calculo)
						E1_PREFIXO                               	,;  // [7] Prefixo da NF
						E1_TIPO	                           		}   // [8] Tipo do Titulo
	
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
			oPrint:cPathPDF := cCamBol
			MakeDir(cCamBol)
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

//If Valtype("oPrint") == "O"
    oPrint:EndPage()     // Finaliza a página
    oPrint:Preview()     // Visualiza antes de imprimir
//EndIf

If Empty(_cPref)  
	Close(oDlg)
EndIf

Return nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³  Impress ³ Autor ³ Silverio Bastos       ³ Data ³ 07/07/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ IMPRESSAO DO BOLETO LASER DO BRADESCO COM CODIGO DE BARRAS ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ MultiGlass							                      ³±±
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
LOCAL oFont12
LOCAL nI := 0
//LOCAL _cBanco	:= "8650"

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
oFont24  := TFont():New("Arial",9,24,.T.,.T.,5,.T.,5,.T.,.F.)

/*****************/
/* PRIMEIRA PARTE */
/*****************/

nRow2 := 50

oPrint:SayBitmap(nRow2 + 0000,0100,"logo_bradesco.jpg",330,120)
oPrint:Say  (nRow2 + 0080,0503,aDadosBanco[1]+"-2",oFont24)
oPrint:Say  (nRow2 + 0080,1780,"Recibo do Sacado",oFont14)
oPrint:Line (nRow2 + 0040,500 ,nRow2 + 0100,500) //Vertical
oPrint:Line (nRow2 + 0040,680 ,nRow2 + 0100,680) //Vertical

oPrint:Line (nRow2+0100,0100,nRow2+0100,2150) //Horizontal - Bloco Geral
oPrint:Line (nRow2+0180,0100,nRow2+0180,2150) //Horizontal - Bloco Geral
oPrint:Line (nRow2+0260,0100,nRow2+0260,2150) //Horizontal - Bloco Geral
oPrint:Line (nRow2+0340,0100,nRow2+0340,2150) //Horizontal - Bloco Geral

oPrint:Line (nRow2+0100,0100,nRow2+0970,0100) //Vertical
oPrint:Line (nRow2+0100,2150,nRow2+0970,2150) //Vertical
oPrint:Line (nRow2+0100,1680,nRow2+0720,1680) //Vertical

oPrint:Line (nRow2+0260,470 ,nRow2+0420,0470)
oPrint:Line (nRow2+0340,790 ,nRow2+0420,0790)
oPrint:Line (nRow2+0260,940 ,nRow2+0340,0940)
oPrint:Line (nRow2+0340,1060,nRow2+0420,1060)
oPrint:Line (nRow2+0260,1220,nRow2+0340,1220)
oPrint:Line (nRow2+0260,1360,nRow2+0420,1360)

oPrint:Say  (nRow2+0125,105 ,"Local de Pagamento",oFont11)
oPrint:Say  (nRow2+0170,105 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont13n)			

oPrint:Say  (nRow2+0120,1690,"Vencimento",oFont11)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol 	:= 1685+(384-(len(cString)*22))
oPrint:Say  (nRow2+160,nCol,cString ,oFont13n)

oPrint:Say  (nRow2+0205,105 ,"Cedente",oFont11)
oPrint:Say  (nRow2+0250,105 ,Upper(aDadosEmp[1])+" - "+aDadosEmp[6],oFont13n)				//Nome + CNPJ
                                
oPrint:Say  (nRow2+0205,1690,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3])+IIF(!Empty(aDadosBanco[7]),"-"+Alltrim(aDadosBanco[7]),"")+"/"+aDadosBanco[4]+"-"+aDadosBanco[5]
nCol 	:= 1685+(330-(len(cString)*22))
oPrint:Say  (nRow2+0250,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0285,105 ,"Data do Documento",oFont11)
oPrint:Say  (nRow2+0330,115, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont13n)

oPrint:Say  (nRow2+0285,480 ,"Número do Documento",oFont11)
oPrint:Say  (nRow2+0330,500 ,/*aDadosTit[7]+*/aDadosTit[1],oFont13n) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0285,950,"Espécie Doc.",oFont11)
oPrint:Say  (nRow2+0330,980,"DM",oFont13n) 

oPrint:Say  (nRow2+0285,1230,"Aceite",oFont11)
oPrint:Say  (nRow2+0330,1240,"N",oFont13n)

oPrint:Say  (nRow2+0285,1360,"Data do Processamento"                ,oFont11)
oPrint:Say  (nRow2+0330,1400, StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4), oFont13n)
                            

oPrint:Say  (nRow2+0285,1690,"Nosso Número"                                   ,oFont11)
cString := Alltrim(aDadosTit[6])
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow2+0330,nCol,cString,oFont13n) //Nosso numero

oPrint:Say  (nRow2+0365,105 ,"Uso do Banco"                                       ,oFont11)

oPrint:Say  (nRow2+0365,480 ,"Carteira"                                       ,oFont11)
oPrint:Say  (nRow2+0410,500 ,aDadosBanco[6]                                  	,oFont13n)

oPrint:Say  (nRow2+0365,800 ,"Espécie da Moeda"                                        ,oFont11)
oPrint:Say  (nRow2+0410,830 ,"REAL"                                             ,oFont13n)

oPrint:Say  (nRow2+0365,1065,"Quantidade"                                     ,oFont11)
oPrint:Say  (nRow2+0365,1370,"(x) Valor"                                          ,oFont11)
	
oPrint:Say  (nRow2+0365,1690,"(=) Valor do Documento"                          	,oFont11)
cString  := Transform(aDadosTit[5],"@E 99,999,999.99")
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow2+0410,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0470,105 ,"Instruções: (Texto de responsabilidade do cedente)",oFont11)
oPrint:Say  (nRow2+0510,105 ,aBolText[3] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[8]/100),"@E 99,999,999.99")),oFont13n)
oPrint:Say  (nRow2+0550,105 ,aBolText[5] ,oFont13n)
oPrint:Say  (nRow2+0590,105 ,aBolText[6] ,oFont13n)
//oPrint:Say  (nRow2+0550,105 ,aBolText[1] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[9]/100),"@E 99,999,999.99")) + aBolText[2],oFont13n)

oPrint:Line (nRow2+0480,1685,nRow2+0480,2150 )
oPrint:Line (nRow2+0540,1685,nRow2+0540,2150 )
oPrint:Line (nRow2+0600,1685,nRow2+0600,2150 )
oPrint:Line (nRow2+0660,1685,nRow2+0660,2150 )
oPrint:Line (nRow2+0720,0100,nRow2+0720,2150 )
oPrint:Line (nRow2+0780,0100,nRow2+0780,0100 )

oPrint:Say  (nRow2+0445,1690,"(-)Desconto/Abatimento"                         ,oFont11)
oPrint:Say  (nRow2+0505,1690,"(-)Outras Deduções"                             ,oFont11)
oPrint:Say  (nRow2+0565,1690,"(+)Mora/Multa"                                  ,oFont11)
oPrint:Say  (nRow2+0625,1690,"(+)Outros Acréscimos"                           ,oFont11)
oPrint:Say  (nRow2+0685,1690,"(=)Valor Cobrado"                               ,oFont11)

oPrint:Line (nRow2+0420,100,nRow2+0420,2150) 
oPrint:Line (nRow2+0970,100,nRow2+0970,2150)                                              

oPrint:Say  (nRow2+0760,0105,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow2+0760,0240,Upper(Alltrim(aDatSacado[1]))                    ,oFont13n)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow2 + 0760,1690,"CNPJ: "+Transform(aDatSacado[7],PesqPict("SA2","A2_CGC")),oFont13n) // CGC
Else
	oPrint:Say  (nRow2 + 0760,1690,"CPF: "+TRANSFORM(aDatSacado[7],PesqPict("SA2","A2_CGC")),oFont13n) 	// CPF
EndIf


oPrint:Say  (nRow2 + 0805,105 ,"Endereço",oFont11)
oPrint:Say  (nRow2 + 0805,0240,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow2 + 0850,240 ,Alltrim(SA1->A1_BAIRROC) + " - " + Alltrim(SA1->A1_MUNC) + " - " + SA1->A1_ESTC,oFont10)
oPrint:Say  (nRow2 + 0895,240 ,Transform(SA1->A1_CEPC,"@R 99999-999"),oFont10)

oPrint:Say  (nRow2 + 0950,1400,"Código de Baixa",oFont11)

oPrint:Say  (nRow2+1050,1800,"Autenticação Mecânica",oFont10)

/******************/
/* SEGUNDA  PARTE */
/******************/

nRow3 := -400

For nI := 100 to 2150 step 50
	oPrint:Line(nRow3+1550, nI, nRow3+1550, nI+30)
Next nI

oPrint:Say  (nRow3+1600,1850 ,"Corte Aqui",oFont10)

oPrint:SayBitmap(nRow3 + 1595,0110,"logo_bradesco.jpg",330,120)
oPrint:Say  (nRow3+1685,500,aDadosBanco[1]+"-2",oFont24 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1685,800,aCB_RN_NN[2],oFont16n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1700,100,nRow3+1700,2150)    
oPrint:Line (nRow3+1640,500,nRow3+1700, 500)
oPrint:Line (nRow3+1640,710,nRow3+1700, 710)

oPrint:Line (nRow3+1790,100,nRow3+1790,2150 )
oPrint:Line (nRow3+1880,100,nRow3+1880,2150 )
oPrint:Line (nRow3+1940,100,nRow3+1940,2150 )
oPrint:Line (nRow3+2000,100,nRow3+2000,2150 )

oPrint:Line (nRow3+1880,470 ,nRow3+2000,470 )
oPrint:Line (nRow3+1940,790 ,nRow3+2000,790 )
oPrint:Line (nRow3+1880,940 ,nRow3+2000,940 )
oPrint:Line (nRow3+1880,1220,nRow3+1940,1220)
oPrint:Line (nRow3+1880,1360,nRow3+2000,1360)

oPrint:Say  (nRow3+1725,105 ,"Local de Pagamento",oFont11)
oPrint:Say  (nRow3+1770,105 ,"Pagável preferencialmente na Rede Bradesco ou Bradesco Expresso",oFont13n)
           
oPrint:Say  (nRow3+1725,1690,"Vencimento",oFont11)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1770,nCol,cString,oFont13n)

oPrint:Say  (nRow3+1815,105 ,"Cedente",oFont11)
oPrint:Say  (nRow3+1860,105 ,aDadosEmp[1]									,oFont13n) //Nome 

oPrint:Say  (nRow3+1815,1690,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3]+IIF(!Empty(aDadosBanco[7]),"-"+Alltrim(aDadosBanco[7]),"")+"/"+aDadosBanco[4]+"-"+aDadosBanco[5])
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1860,nCol,cString ,oFont13n)

oPrint:Say  (nRow3+1905,105 ,"Data do Documento"                              ,oFont11)
oPrint:Say (nRow3+1935,115, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont13n)

oPrint:Say  (nRow3+1905,480 ,"Número do Documento",oFont11)
oPrint:Say  (nRow3+1935,500 ,/*aDadosTit[7]+*/aDadosTit[1],oFont13n) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1905,950,"Espécie Doc.",oFont11)
oPrint:Say  (nRow3+1935,980,"DM",oFont13n) 

oPrint:Say  (nRow3+1905,1230,"Aceite",oFont11)
oPrint:Say  (nRow3+1935,1240,"N",oFont13n)

oPrint:Say  (nRow3+1905,1365,"Data do Processamento"                ,oFont11)
oPrint:Say  (nRow3+1935,1375,StrZero(Day(aDadosTit[3]),2) +"/"+ StrZero(Month(aDadosTit[3]),2) +"/"+ Right(Str(Year(aDadosTit[3])),4)                               ,oFont10) // Data impressao


oPrint:Say  (nRow3+1905,1690,"Nosso Número"                                   ,oFont11)
cString := Alltrim(aDadosTit[6])
nCol 	 := 1690+(374-(len(cString)*22))
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

oPrint:Say  (nRow3+2040,105 ,"Instruções (Texto responsabilidade do cedente) ",oFont11)
oPrint:Say  (nRow3+2080,105 ,aBolText[3] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[8]/100),"@E 99,999,999.99")) ,oFont13n)
oPrint:Say  (nRow3+2120,105 ,aBolText[5] ,oFont13n)
oPrint:Say  (nRow3+2160,105 ,aBolText[6] ,oFont13n)
//oPrint:Say  (nRow3+2120,105 ,aBolText[1] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[9]/100),"@E 99,999,999.99")) + aBolText[2],oFont13n)

oPrint:Say  (nRow3+2025,1690,"(-)Desconto/Abatimento"                         ,oFont11)
oPrint:Say  (nRow3+2085,1690,"(-)Outras Deduções"                             ,oFont11)
oPrint:Say  (nRow3+2145,1690,"(+)Mora/Multa"                                  ,oFont11)
oPrint:Say  (nRow3+2205,1690,"(+)Outros Acréscimos"                           ,oFont11)
oPrint:Say  (nRow3+2265,1690,"(=)Valor Cobrado"                               ,oFont11)

oPrint:Say  (nRow3+2330,0105 ,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow3+2330,0240 ,aDatSacado[1]						             ,oFont13n)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3 + 2330,1690,"CNPJ: "+TRANSFORM(aDatSacado[7],PesqPict("SA2","A2_CGC")),oFont13n) // CGC
Else
	oPrint:Say  (nRow3 + 2330,1690,"CPF: "+TRANSFORM(aDatSacado[7],PesqPict("SA2","A2_CGC")),oFont13n) 	// CPF
EndIf

oPrint:Say  (nRow3+2370,0105,"Endereço",oFont11)
oPrint:Say  (nRow3+2370,0240,aDatSacado[3]                                    ,oFont10)
oPrint:Say  (nRow3+2410,0240,Alltrim(SA1->A1_BAIRROC) + " - " + aDatSacado[4]+" - "+aDatSacado[5],oFont10) // CEP+Cidade+Estado
oPrint:Say  (nRow3+2450,0240,Transform(SA1->A1_CEPC,"@R 99999-999"),oFont10)

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

oPrint:FwMsBar("INT25",52.5,4,cCodBar237,oPrint,.F.,,.T.,0.020,1.01,NIL,NIL,NIL,.F.) 

//oPrint:Code128C(nRow3+2710,0150,cCodBar237, 48)

DbSelectArea("SX5")
dbSetOrder(1)
dbSeek(xFilial("SX5")+"_2"+"BRADES")
IF EMPTY(SE1->E1_NUMBCO) .AND. alltrim(aDadosBanco[1])=='237'
	RecLock("SX5",.f.)
	SX5->X5_DESCRI 	:=	alltrim(substr(aCB_RN_NN[3],1,11))   // sequencia do Nosso número 
	MsUnlock()
ENDIF

DbSelectArea("SE1")
IF EMPTY(SE1->E1_NUMBCO)
	RecLock("SE1",.f.)
	SE1->E1_NUMBCO 	:=	alltrim(substr(aCB_RN_NN[3],1,11))+alltrim(substr(aCB_RN_NN[3],13,1))   // Nosso número (Ver fórmula para calculo)
	MsUnlock()
ENDIF

Return Nil

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
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,_cSeqNum,nValor,dVencto)

LOCAL cValorFinal := strzero((nValor*100),10)
LOCAL nDvnn			:= 0
LOCAL nDvcb			:= 0
LOCAL nDv			:= 0
LOCAL cNN			:= ''
LOCAL cRN			:= ''
LOCAL cCB			:= ''
LOCAL cS			:= ''
LOCAL cFator      	:= strzero(dVencto - ctod("07/10/97"),4)
LOCAL cCart			:= "02"
//-----------------------------
// Definicao do NOSSO NUMERO
// ----------------------------

cS    :=  cCart + _cSeqNum //19 001000012 + cCart
nDvnn := modulo111(cS) // digito verifacador 
cNNSD := Substr(cS,1,Len(cS)-1) //Nosso Numero sem digito
cNN   := cCart + "/" + Substr(_cSeqNum,1,Len(_cSeqNum)-1) + "-" + Substr(_cSeqNum,Len(_cSeqNum))
//----------------------------------
//	 Definicao do CODIGO DE BARRAS
//----------------------------------
cLivre := Strzero(Val(cAgencia),4)+ cNNSD + Strzero(Val(cConta),7) + "0" 

cS:= cBanco + cFator +  cValorFinal + cLivre // + Subs(cNN,1,11) + Subs(cNN,13,1) + cAgencia + cConta + cDacCC + '000'
nDvcb := modulo11(cS)
cCB   := SubStr(cS, 1, 4) + AllTrim(Str(nDvcb)) + SubStr(cS,5)// + SubStr(cS,31)

//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCCCX		DDDDD.DDDDDY	FFFFF.FFFFFZ	K			UUUUVVVVVVVVVV

// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	B     = Codigo da moeda, sempre 9                          		
//	CCCCC = 5 primeiros digidos do cLivre
//	X     = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS    := cBanco + Substr(cLivre,1,5)
nDv   := modulo10(cS)  //DAC
cRN   := SubStr(cS, 1, 5) + '.' + SubStr(cS, 6, 4) + AllTrim(Str(nDv)) + '  '      

// 	CAMPO 2:
//	DDDDDDDDDD = Posição 6 a 15 do Nosso Numero 
//	Y          = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo

cS :=Subs(cLivre,6,10)
nDv:= modulo10(cS)
cRN += Subs(cS,1,5) +'.'+ Subs(cS,6,5) + Alltrim(Str(nDv)) + ' ' 

// 	CAMPO 3:
//	FFFFFFFFFF = Posição 16 a 25 do Nosso Numero 
//	Z          = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
cS :=Subs(cLivre,16,10)
nDv:= modulo10(cS)
cRN += Subs(cS,1,5) +'.'+ Subs(cS,6,5) + Alltrim(Str(nDv)) + ' ' 

//	CAMPO 4:
//	     K = DAC do Codigo de Barras
cRN   += AllTrim(Str(nDvcb)) + '  '

// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
cRN   += cFator + StrZero((nValor * 100),14-Len(cFator))

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
                                  
/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºFuncao    ³ MtCodBar º Autor ³                    º Data ³  11/05/03   º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºDescricao ³ Monta codigo de barras que sera impresso.                  º
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
ºUso       ³                                                            º
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼
/*/
Static Function MtCodBar(_nAgen,_dAgen,_nConta,_cCart,_dConta,_cSeqNum,_nValor,_dVencto)
       Local nAgen   :=  _nAgen
       Local nCntCor :=  _nConta
       Local nI      := 0
       /*
       - Posicoes fixas padrao Banco Central
       Posicao  Tam       Descricao
       01 a 03   03   Codigo de Compensacao do Banco (237)
       04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
       05 a 05   01   Digito verificador do codigo de barras
       06 a 19   14   Valor Nominal do Documento sem ponto
       - Campo Livre Padrao Bradesco
       Posicao  Tam       Descricao
       20 a 23   03   Agencia Cedente sem digito verificador
       24 a 25   02   Carteira
       25 A 36   11   Nosso Numero sem digito verificador
       37 A 43   07   Conta Cedente sem digiro verificador
       44 A 44   01   Zero
       */
       // Monta numero da Agencia sem dv e com 4 caracteres
       // Retira separador de digito se houver
//	   nAgen :=  aDadosBanco[3]
       // Monta numero da Conta Corrente sem dv e com 7 caracteres
       // Retira separador de digito se houver
//       nCntCor :=  aDadosBanco[5]
       cCampo := ""
       // Pos 01 a 03 - Identificacao do Banco
       cCampo += "237"
       // Pos 04 a 04 - Moeda
       cCampo += "9"
       // Pos 06 a 09 - Fator de vencimento
       cCampo += strzero(_dVencto - ctod("07/10/97"),4) // Str((aTitulos[nCont][02] - dFator),4)
       // Pos 10 a 19 - Valor
       cCampo += StrZero(_nValor*100,10)//StrZero(Int(_nValor*100),10)
       // Pos 20 a 23 - Agencia
       cCampo += nAgen
       //Pos 24 a 25 - Carteira
       cCampo += _cCart
       // Pos 26 a 36 - Nosso Numero
       cCampo += _cSeqNum
       // Pos 37 a 43 - Conta do Cedente
       cCampo += padl(nCntCor,7,"0")
       // Pos 44 a 44 - Zero
       cCampo += "0"
       cDigitbar := CalcDig()
       // Monta codigo de barras com digito verificador
       cBarra := Subs(cCampo,1,4)+cDigitbar+Subs(cCampo,5,43)
Return(cBarra)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»
ºFuncao    ³ CalcDig  º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Calculo do Digito Verificador Codigo de Barras - MOD(11)   º 
º          ³ Pesos (2 a 9)                                              º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static Function CalcDig()
       Local nCnt   := 0
       Local nPeso  := 2
       Local nJ     := 1
       Local nResto := 0
       For nJ := Len(cCampo) To 1 Step -1
	       nCnt:= nCnt + Val(SUBSTR(cCampo,nJ,1))*nPeso
	       nPeso :=nPeso+1
	       if nPeso > 9
		      nPeso := 2
	       endif
       Next nJ
       nResto:=(ncnt%11)
       nResto:=11 - nResto
       if nResto == 0 .or. nResto==1 .or. nResto > 9
	      nDigBar:='1'
          else
	        nDigBar:=Str(nResto,1)
       endif
Return(nDigBar)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» 
ºFuncao    ³ MtLinDig º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Monta da Linha Digitavel                                   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static FUNCTION MtLinDig(cBarra)
       Local nI   := 1
       Local nAux := 0
       cLinha     := ""
       nDigito    := 0
       cCampo     := ""
       /*
       Primeiro Campo
       Posicao  Tam       Descricao
       01 a 03   03   Codigo de Compensacao do Banco (237)
       04 a 04   01   Codigo da Moeda (Real => 9, Outras => 0)
       05 a 09   05   Pos 1 a 5 do campo Livre(Pos 1 a 4 Dig Agencia + Pos 1 Dig Carteira)
       10 a 10   01   Digito Auto Correcao (DAC) do primeiro campo
       Segundo Campo
       11 a 20   10   Pos 6 a 15 do campo Livre(Pos 2 Dig Carteira + Pos 1 a 9 Nosso Num)
       21 a 21   01   Digito Auto Correcao (DAC) do segundo campo
       Terceiro Campo
       22 a 31   10   Pos 16 a 25 do campo Livre(Pos 10 a 11 Nosso Num + Pos 1 a 8 Conta Corrente + "0")
       32 a 32   01   Digito Auto Correcao (DAC) do terceiro campo
       Quarto Campo
       33 a 33   01   Digito Verificador do codigo de barras
       Quinto Campo
       34 a 37   04   Fator de Vencimento
       38 a 47   10   Valor
       */
       // Calculo do Primeiro Campo
       cCampo := ""
       cCampo := Subs(cBarra,1,4)+Subs(cBarra,20,5)
       // Calculo do digito do Primeiro Campo
       CalDig1(2)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,4)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Segundo Campo
       cCampo := ""
       cCampo := Subs(cBarra,25,10)
       // Calculo do digito do Segundo Campo
       CalDig1(1)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,5)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Terceiro Campo
       cCampo := ""
       cCampo := Subs(cBarra,35,10)
       // Calculo do digito do Terceiro Campo
       CalDig1(1)
       cLinha += Subs(cCampo,1,5)+"."+Subs(cCampo,6,5)+Alltrim(Str(nDigito))
       // Insere espaco
       cLinha += " "
       // Calculo do Quarto Campo
       cCampo := ""
       cCampo := Subs(cBarra,5,1)
       cLinha += cCampo
       // Insere espaco
       cLinha += " "
       // Calculo do Quinto Campo
       cCampo := ""
       cCampo := Subs(cBarra,6,4)+Subs(cBarra,10,10)
       cLinha += cCampo
Return(cLinha)

/*/
ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ» 
ºFuncao    ³ CISTF07E º Autor ³                    º Data ³  11/05/03   º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºDescricao ³ Calculo do Digito Verificador da Linha Digitavel - Mod(10) º 
º          ³ Pesos (1 e 2)                                              º 
ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹ 
ºUso       ³                                                            º 
ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼ 
/*/
Static Function CalDig1 (nCnt)
       Local nI   := 1
       Local nAux := 0
       Local nInt := 0
       nDigito    := 0
       For nI := 1 to Len(cCampo)
	       nAux := Val(Substr(cCampo,nI,1)) * nCnt
	       If nAux >= 10
		      nAux:= (Val(Substr(Str(nAux,2),1,1))+Val(Substr(Str(nAux,2),2,1)))
	       Endif
	       nCnt += 1
	       If nCnt > 2
		      nCnt := 1
	       Endif
	       nDigito += nAux
       Next nI
       If (nDigito%10) > 0
	      nInt    := Int(nDigito/10) + 1
          Else
	       nInt    := Int(nDigito/10)
       Endif
       nInt    := nInt * 10
       nDigito := nInt - nDigito
Return()


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

Static Function Modulo111(cData)
       LOCAL L, D, P := 0
       L := Len(cdata)
       D := 0
       P := 1
       While L > 0
	         P := P + 1
	         D := D + (Val(SubStr(cData, L, 1)) * P)
	         If P = 7
		        P := 1
	         End
	         L := L - 1
       End
       If 	(mod(D,11)) >= 0 .and. (mod(D,11)) <= 1
       	   	D:= (mod(D,11))
       		If 	D == 1 
	      		D := 'P'
			Else
	       	   	D:= alltrim(str(D))
	      	Endif	
       Else		
       	   	D:= 11 - (mod(D,11))
       	   	D:= alltrim(str(D))
       End
Return(D)


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


                 	