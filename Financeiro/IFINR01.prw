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

/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | IFINR01 | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Dezembro/2013 |
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Impressão do boleto Itaú													   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/

User Function IFINR01(_cPref,_cParce,_cNum,_cCli,_cLoja,cPasta,_cAgen,_cConta)

LOCAL	aPergs	:= {} 
PRIVATE lExec	:= .F., cIndexName := '', cIndexKey  := '', cFilter := '', cMarca := GetMark(), lInverte := .f.
Private titulo	:= "Impressao de Boleto com Codigo de Barras", cPerg := PADR("IFINR01",Len(SX1->X1_GRUPO))
PRIVATE cTitaux	:= ""
Private lArq 	:= .F.

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
	Aadd(aPergs,{"% Juros ao Dia"	,"","","mv_chj","N",06					,3,0,"G","","MV_PAR19","","","",""		,"","","","","","","","","","","","","","","","","","","","",""		,"","","",""})
	
	AjustaSx1(PADR("IFINR01",Len(SX1->X1_GRUPO)),aPergs)
	
	If !Pergunte (cPerg,.t.)
		Return
	EndIf

Else //Geração automatica do boleto

	DbSelectArea("SA6")
	DbSetOrder(1)  //Codigo + Nro Agencia + Nro Conta                                      
	If !(DbSeek(xFilial("SA6") + '341' + _cAgen + _cConta))
		Alert("Banco não localizado")
		Return
	EndIf	
	
	Pergunte(cPerg,.f.)
	mv_par01 := _cPref          		                                     // de Prefixo
	mv_par02 := _cPref			                                             // ate Prefixo
	mv_par03 := _cNum		                                                 // de Numero
	mv_par04 := _cNum		                                                 // ate Numero
	mv_par05 := _cParce                               						 // de Parcela
	mv_par06 := _cParce								                         // ate Parcela
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
		
	DEFINE SBUTTON OBJECT oBtn0 FROM 157,220 TYPE 1  ENABLE OF oDlg ACTION (IFINR01I("T")) 
	DEFINE SBUTTON OBJECT oBtn1 FROM 157,260 TYPE 1  ENABLE OF oDlg ACTION (IFINR01I("I"))
	DEFINE SBUTTON OBJECT oBtn2 FROM 157,300 TYPE 1  ENABLE OF oDlg ACTION (IFINR01M())
	DEFINE SBUTTON OBJECT oBtn3 FROM 157,340 TYPE 2  ENABLE OF oDlg ACTION (Close(oDlg))
		
	oBtn0:cCaption	:= "Sel.Todos"
	oBtn0:cToolTip	:= "Selecionar todos os títulos"
		
	oBtn1:cCaption	:= "Inverter"
	oBtn1:cToolTip	:= "Inverte a marcação dos títulos"
		
	//Exibe a Dialog
	ACTIVATE MSDIALOG oDlg CENTERED 
	
	dbGoTop()
	
Else //Criacao automatica de boleto	 
	IFINR01M(_cPref,cPasta)
EndIf
              
SE1->(DbCloseArea())

Return Nil


/*
+-----------+----------+-------+--------------------------------------+------+---------------+
| Programa  | IFINR01I | Autor | Rubens Cruz	- Anadi Soluções 	  | Data | Dezembro/2013 |
+-----------+----------+-------+--------------------------------------+------+---------------+
| Descricao | Inverte a marcação dos títulos exibidos										|
+-----------+-------------------------------------------------------------------------------+
| Uso       | ISAPA																		    |
+-----------+-------------------------------------------------------------------------------+
*/

Static Function IFINR01I(_cBtn)
Local _aArea := GetArea()

DbSelectArea("SE1")
DbGoTop()
While !Eof()
    
	If _cBtn == "I" //Inverter

		If Marked("E1_OK")
			While !Reclock("SE1",.f.)
			EndDo
			SE1->E1_OK := Space(TamSX3("E1_OK")[1])
			MsUnlock()
		Else
			While !Reclock("SE1",.f.)
			EndDo
			SE1->E1_OK := cMarca
			MsUnlock()
		EndIf
		
	ElseIf _cBtn == "T" //Marcar todos
		If !Marked("E1_OK")
			While !Reclock("SE1",.f.)
			EndDo
			SE1->E1_OK := cMarca
			MsUnlock()
		EndIf
	EndIf

	DbSkip()
EndDo

RestArea(_aArea)
Return

/*
+-----------+----------+-------+--------------------------------------+------+---------------+
| Programa  | IFINR01M | Autor | Rubens Cruz	- Anadi Soluções 	  | Data | Dezembro/2013 |
+-----------+----------+-------+--------------------------------------+------+---------------+
| Descricao | Exibe a tela para seleção dos títulos e faz a chamada da impressão		     |
+-----------+--------------------------------------------------------------------------------+
| Uso       | ISAPA																		     |
+-----------+--------------------------------------------------------------------------------+
*/

Static Function IFINR01M(_cPref,cPasta)
LOCAL oPrint                                                
Local cCamBol	:= Alltrim(GETMV("MV__CAMBOL")) 
Local _lOk		:= .F.
LOCAL nX 		:= 0
Local cNroDoc 	:=  " "    
LOCAL cCart		:= "112"  
Local _cSeqNum 	:= _cDigNum	:= " "
LOCAL aDadosEmp := {	SM0->M0_NOMECOM                                    ,; //[1]Nome da Empresa
						SM0->M0_ENDCOB                                     ,; //[2]Endereço
						AllTrim(SM0->M0_BAIRCOB)+", "+AllTrim(SM0->M0_CIDCOB)+", "+SM0->M0_ESTCOB ,; //[3]Complemento
						"CEP: "+Subs(SM0->M0_CEPCOB,1,5)+"-"+Subs(SM0->M0_CEPCOB,6,3)             ,; //[4]CEP
						"PABX/FAX: "+SM0->M0_TEL                                                  ,; //[5]Telefones
						"CNPJ: "+Subs(SM0->M0_CGC,1,2)+"."+Subs(SM0->M0_CGC,3,3)+"."+        	   ; //[6]
						Subs(SM0->M0_CGC,6,3)+"/"+Subs(SM0->M0_CGC,9,4)+"-"+                       ; //[6]
						Subs(SM0->M0_CGC,13,2)                                                    ,; //[6]CGC
						"I.E.: "+Subs(SM0->M0_INSC,1,3)+"."+Subs(SM0->M0_INSC,4,3)+"."+            ; //[7]
						Subs(SM0->M0_INSC,7,3)+"."+Subs(SM0->M0_INSC,10,3)                        }  //[7]I.E

LOCAL aDadosTit
LOCAL aDadosBanco
LOCAL aDatSacado
LOCAL aBolText     := {	"APÓS O VENCIMENTO, COBRAR MORA DE......R$ ",;
						" AO DIA",;
						"PROTESTAR APOS 05 DIAS UTEIS DO VENCIMENTO",;
						"COBRANCA ESCRITURAL"}

LOCAL nI           	:= 1
LOCAL aCB_RN_NN    	:= {}
LOCAL _cCodBarra	:= {}
LOCAL _cCodBar		:= _cLinhaDig := ''
LOCAL nVlrAbat		:= 0
default _cPref 		:= "" 
default cPasta		:= ""

If Empty(cPasta)
	cCamBol := cGetFile( , 'Salvar Boleto', 1, 'C:\', .F., nOR( GETF_LOCALHARD, GETF_RETDIRECTORY ),.F., .T. )
EndIf                                       

DbSelectArea("SE1")
dbGoTop()
ProcRegua(RecCount())
	
Do While !EOF()
	//Posiciona o SA6 (Bancos)
	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+MV_PAR07+MV_PAR08+MV_PAR09,.T.)
	
	//Posiciona o SA1 (Cliente)
	DbSelectArea("SA1")
	DbSetOrder(1)
	DbSeek(xFilial("SA1")+SE1->E1_CLIENTE+SE1->E1_LOJA,.T.)
		
	DbSelectArea("SE1")
	aDadosBanco  := {SA6->A6_COD                    ,; 	// [1]Numero do Banco
                      SA6->A6_NOME      	        ,; 	// [2]Nome do Banco
	                  alltrim(SA6->A6_AGENCIA)	    ,;	// [3]Agência
                      alltrim(SA6->A6_NUMCON)		,; 	// [4]Conta Corrente
                      alltrim(SA6->A6_DVCTA)		,; 	// [5]Dígito da conta corrente
                      cCart                         ,;  // [6]Codigo da Carteira
                      alltrim(SA6->A6_DVAGE)		,;	// [7]Digito da agencia
                      SA6->A6__JUROS				}	// [8]Juros de mora	

	If Empty(SA1->A1_ENDCOB)
		aDatSacado   := {AllTrim(SA1->A1_NOME)           ,;      	// [1]Razão Social
		AllTrim(SA1->A1_COD )+" - "+SA1->A1_LOJA           ,;      	// [2]Código
		AllTrim(SA1->A1_END )+" - "+AllTrim(SA1->A1_BAIRRO),;      	// [3]Endereço
		AllTrim(SA1->A1_MUN )                            ,;  		// [4]Cidade
		SA1->A1_EST                                       ,;     	// [5]Estado
		Transform(SA1->A1_CEP,"@R 99999-999")            ,;      	// [6]CEP
		SA1->A1_CGC										          ,;// [7]CGC
		SA1->A1_PESSOA										}       // [8]PESSOA
	Else
		aDatSacado   := {AllTrim(SA1->A1_NOME)            	 ,;   	// [1]Razão Social
		AllTrim(SA1->A1_COD )+"-"+SA1->A1_LOJA              ,;   	// [2]Código
		AllTrim(SA1->A1_ENDCOB)+"-"+AllTrim(SA1->A1_BAIRROC),;   	// [3]Endereço
		AllTrim(SA1->A1_MUNC)	                             ,;   	// [4]Cidade
		SA1->A1_ESTC	                                     ,;   	// [5]Estado
		Transform(SA1->A1_CEPC,"@R 99999-999")               ,;   	// [6]CEP
		SA1->A1_CGC												 		 ,;		// [7]CGC
		SA1->A1_PESSOA												 }				// [8]PESSOA
	Endif
	
	nVlrAbat   :=  SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA)

	DO CASE
		CASE SE1->E1_PARCELA == "A"
			cParcela := "1"
		CASE SE1->E1_PARCELA == "B"
			cParcela := "2"
		CASE SE1->E1_PARCELA == "C"
			cParcela := "3"
		CASE SE1->E1_PARCELA == "D"
			cParcela := "4"
		CASE SE1->E1_PARCELA == "E"
			cParcela := "5"
		CASE SE1->E1_PARCELA == "F"
			cParcela := "6"
		CASE SE1->E1_PARCELA == "G"
			cParcela := "7"
		CASE SE1->E1_PARCELA == "H"
			cParcela := "8"
		CASE SE1->E1_PARCELA == "I"
			cParcela := "9"
		OTHERWISE
			cParcela := "0"
	ENDCASE
	//
	_cNossoNum := cFilant + substr((strzero(Val(Alltrim(SE1->E1_NUM)),6)),2,5) + cParcela //Composicao Filial + Titulo + Parcela
	IF EMPTY(SE1->E1_NUMBCO)
		_cSeqNum := Posicione("SX5", 1, xFilial("SX5")+"_2"+"ITAU", "X5_DESCRI")
		_cSeqNum := AllTrim(Strzero(Val(_cSeqNum)+1,8))
	Else
		_cSeqNum := ALLTRIM(SE1->E1_NUMBCO)	
	Endif                                 
	
	
	//Monta codigo de barras
	_cCodBarra    	:= Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],AllTrim(_cSeqNum),(E1_VALOR-nVlrAbat),E1_VENCREA)//Datavalida(E1_VENCREA,.T.))

//	_NumBco			:= IIF(EMPTY(E1_NUMBCO),(_cSeqNum +"-"+ _cDigNum),subst(alltrim(E1_NUMBCO),1,len(alltrim(E1_NUMBCO))-1)+"-"+subst(alltrim(E1_NUMBCO),len(alltrim(E1_NUMBCO)),1))
	aDadosTit		:= {AllTrim(E1_NUM)+IIF(Empty(E1_PARCELA),"","-"+AllTrim(E1_PARCELA))	,;  // [1] Número do título
						E1_EMISSAO                      										,;  // [2] Data da emissão do título
						dDataBase                    											,;  // [3] Data da emissão do boleto
						E1_VENCREA                      										,;  // [4] Data do vencimento
						(E1_SALDO - nVlrAbat)          											,;  // [5] Valor do título
						_cCodBarra[3]	             												,;  // [6] Nosso número (Ver fórmula para calculo)
						Alltrim(E1_PREFIXO)                     								,;  // [7] Prefixo da NF
						E1_TIPO	                     										,;  // [8] Tipo do Titulo
						E1_NFELETR																	}	// [9] Numero NF Eletronica
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a linha de digitacao												³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//    _NossoNumero 	:= IIF(EMPTY(SE1->E1_NUMBCO),(_cSeqNum + _cDigNum),SE1->E1_NUMBCO)
    _cCodBar		:= _cCodBarra[1]
	_cLinhaDig 		:= _cCodBarra[2]
    
	_lOk := .F. 
	
	If Empty(_cPref)
		_lOK 	:= Marked("E1_OK")
	Else
		_lOK 	:= .t.
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
			
			oPrint:lViewPDF := .F. //temporario para gerar PDF
			
			oPrint:cPathPDF := cCamBol
			MakeDir(cCamBol)
			oPrint:SetDevice(IMP_PDF)
			cTitAux := SE1->E1_NUM
			lArq := .T.
		EndIf

		oPrint:StartPage()   // Inicia uma nova página
		
		
		IFINR01P(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,_cCodBar,_cLinhaDig) //aCB_RN_NN)
		nX := nX + 1    
		
		oPrint:EndPage() // Finaliza a página
		
		if(SE1->E1_NUM != cTitAux)
			If File(oPrint:cFilePrint)
				fErase(oPrint:cFilePrint)
			EndIf    
		EndIf

	EndIf

	DbSelectArea("SE1")
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
 

/*
+-----------+----------+-------+-------------------------------------+------+---------------+
| Programa  | IFINR01P | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Dezembro/2013 |
+-----------+----------+-------+-------------------------------------+------+---------------+
| Descricao | Rotina de Impressão do boleto Itaú										   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA																		   |
+-----------+------------------------------------------------------------------------------+
*/
Static Function IFINR01P(oPrint,aDadosEmp,aDadosTit,aDadosBanco,aDatSacado,aBolText,_cCodBar,_cLinhaDig)
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
LOCAL _cBanco	:= " "

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

oPrint:SayBitmap(nRow2 - 0010,0100,"Itau.bmp",100,100)
oPrint:Say  (nRow2 + 0080,0215,"Banco Itaú S.A.",oFont14)
oPrint:Say  (nRow2 + 0080,0503,aDadosBanco[1]+"-7",oFont24)
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
oPrint:Say  (nRow2+0170,105 ,"Pagável em Qualquer Banco Até o Vencimento",oFont13n)			

oPrint:Say  (nRow2+0120,1690,"Vencimento",oFont11)
cString := StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol 	:= 1685+(384-(len(cString)*22))
oPrint:Say  (nRow2+160,nCol,cString ,oFont13n)

oPrint:Say  (nRow2+0205,105 ,"Cedente",oFont11)
oPrint:Say  (nRow2+0250,105 ,Upper(aDadosEmp[1])+" - "+aDadosEmp[6],oFont13n)				//Nome + CNPJ
                                
oPrint:Say  (nRow2+0205,1690,"Agência/Código Cedente",oFont11)
cString := Alltrim(aDadosBanco[3])+Alltrim(aDadosBanco[7])+"/"+aDadosBanco[4]+IIF(Empty(aDadosBanco[5]),"","-"+aDadosBanco[5])
nCol 	:= 1700+(223-(len(cString)*11))
oPrint:Say  (nRow2+0250,nCol,cString,oFont13n)

oPrint:Say  (nRow2+0285,105 ,"Data do Documento",oFont11)
oPrint:Say  (nRow2+0330,115, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont13n)

oPrint:Say  (nRow2+0285,480 ,"Número do Documento",oFont11)
oPrint:Say  (nRow2+0330,500 ,/*aDadosTit[7]+*/aDadosTit[1],oFont13n) //Prefixo +Numero+Parcela

oPrint:Say  (nRow2+0285,950,"Espécie Doc.",oFont11)
oPrint:Say  (nRow2+0330,980,"DMI",oFont13n) 

oPrint:Say  (nRow2+0285,1230,"Aceite",oFont11)
oPrint:Say  (nRow2+0330,1240,"N",oFont13n)

oPrint:Say  (nRow2+0285,1360,"Data do Processamento"                ,oFont11)
oPrint:Say  (nRow2+0330,1400, DTOC(Date()), oFont13n)

oPrint:Say  (nRow2+0285,1690,"Nosso Número"                                   ,oFont11)
cString  := Alltrim(aDadosTit[6])
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow2+0330,nCol,cString,oFont13n) 

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

oPrint:Say  (nRow2+0490,105 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont11)
oPrint:Say  (nRow2+0530,105 ,aBolText[1] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[8]/100),"@E 99,999,999.99")) + aBolText[2],oFont13n)
oPrint:Say  (nRow2+0570,105 ,aBolText[3]										,oFont13n)
oPrint:Say  (nRow2+0620,105 ,aBolText[4]										,oFont13n)


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
	oPrint:Say  (nRow2 + 0760,1690,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont13n) // CGC
Else
	oPrint:Say  (nRow2 + 0760,1690,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont13n) 	// CPF
EndIf

oPrint:Say  (nRow2 + 0795,0105,"Endereço",oFont11)
oPrint:Say  (nRow2 + 0795,0240,aDatSacado[3] + " - " + aDatSacado[4] + " - " + aDatSacado[5],oFont13n)
oPrint:Say  (nRow2 + 0835,0240,aDatSacado[6],oFont13n)
oPrint:Say  (nRow2 + 0895,1400,"Código de Baixa",oFont11)

If !Empty(aDadosTit[9])
	oPrint:Say  (nRow2+0870,105 ,"- BOLETO REFERENTE A NOTA FISCAL DE SERVIÇOS (NFS-e) " + StrZero(Val(aDadosTit[9]),TamSX3("E1_NUM")[1],0),oFont9)
EndIf

oPrint:Say  (nRow2+1150,1800,"Autenticação Mecânica",oFont10)

/******************/
/* SEGUNDA  PARTE */
/******************/

nRow3 := -300 
                                                                                               
For nI := 100 to 2150 step 50
	oPrint:Line(nRow3+1550, nI, nRow3+1550, nI+30)
Next nI

oPrint:Say  (nRow3+1600,1850 ,"Corte Aqui",oFont10)
oPrint:Line (nRow3+1700,100,nRow3+1700,2150)    
oPrint:Line (nRow3+1640,500,nRow3+1700, 500)
oPrint:Line (nRow3+1640,710,nRow3+1700, 710)

oPrint:SayBitmap(nRow3 + 1590,100,"Itau.bmp",100,100) //  [2]Nome do Banco
oPrint:Say  (nRow3+1685,215,"Banco Itaú S.A.",oFont14 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1685,513,aDadosBanco[1]+"-7",oFont24 )	// 	[1]Numero do Banco
oPrint:Say  (nRow3+1685,800,_cLinhaDig,oFont16n)			//		Linha Digitavel do Codigo de Barras

oPrint:Line (nRow3+1790,100,nRow3+1790,2150 )
oPrint:Line (nRow3+1880,100,nRow3+1880,2150 )
oPrint:Line (nRow3+1940,100,nRow3+1940,2150 )
oPrint:Line (nRow3+2000,100,nRow3+2000,2150 )

oPrint:Line (nRow3+1880,470 ,nRow3+2000,470 )
oPrint:Line (nRow3+1940,790 ,nRow3+2000,790 )
oPrint:Line (nRow3+1880,940 ,nRow3+1940,940 )
oPrint:Line (nRow3+1940,1060,nRow3+2000,1060)
oPrint:Line (nRow3+1880,1220,nRow3+1940,1220)
oPrint:Line (nRow3+1880,1360,nRow3+2000,1360)

oPrint:Say  (nRow3+1725,105 ,"Local de Pagamento",oFont11)
oPrint:Say  (nRow3+1770,105 ,"ATÉ O VENCIMENTO, PREFERENCIALMENTE NO ITAÚ. APÓS O VENCIMENTO, SOMENTE NO ITAÚ.",oFont13n)
           
oPrint:Say  (nRow3+1725,1690,"Vencimento",oFont11)
cString 	:= StrZero(Day(aDadosTit[4]),2) +"/"+ StrZero(Month(aDadosTit[4]),2) +"/"+ Right(Str(Year(aDadosTit[4])),4)
nCol	 	:= 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1770,nCol,cString,oFont13n)

oPrint:Say  (nRow3+1815,105 ,"Cedente",oFont11)
oPrint:Say  (nRow3+1860,105 ,Upper(aDadosEmp[1]) + " - " + aDadosEmp[6]	,oFont13n) //Nome + CNPJ

oPrint:Say  (nRow3+1815,1690,"Agência/Código Cedente",oFont11)
cString  := Alltrim(aDadosBanco[3]+aDadosBanco[7]+"/"+aDadosBanco[4]+IIF(Empty(aDadosBanco[5]),"","-"+aDadosBanco[5]) )
nCol 	 := 1700+(223-(len(cString)*11))
oPrint:Say  (nRow3+1860,nCol,cString ,oFont13n)

oPrint:Say  (nRow3+1905,105 ,"Data do Documento",oFont11)
oPrint:Say  (nRow3+1935,115, StrZero(Day(aDadosTit[2]),2) +"/"+ StrZero(Month(aDadosTit[2]),2) +"/"+ Right(Str(Year(aDadosTit[2])),4), oFont13n)

oPrint:Say  (nRow3+1905,480 ,"Número do Documento",oFont11)
oPrint:Say  (nRow3+1935,500 ,/*aDadosTit[7]+*/aDadosTit[1],oFont13n) //Prefixo +Numero+Parcela

oPrint:Say  (nRow3+1905,950,"Espécie Doc.",oFont11)
oPrint:Say  (nRow3+1935,980,"DMI",oFont13n) 

oPrint:Say  (nRow3+1905,1230,"Aceite",oFont11)
oPrint:Say  (nRow3+1935,1240,"N",oFont13n)

oPrint:Say  (nRow3+1905,1360,"Data do Processamento"                ,oFont11)
oPrint:Say  (nRow3+1935,1400, DTOC(Date()), oFont13n)

oPrint:Say  (nRow3+1905,1690,"Nosso Número"                                   ,oFont11)
cString  := Alltrim(aDadosTit[6])
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1935,nCol,cString,oFont13n) 

oPrint:Say  (nRow3+1965,105 ,"Uso do Banco"                                       ,oFont11)

oPrint:Say  (nRow3+1965,480 ,"Carteira"                                       ,oFont11)
oPrint:Say  (nRow3+1995,500 ,aDadosBanco[6]                                  	,oFont13n)

oPrint:Say  (nRow3+1965,800 ,"Espécie"                                        ,oFont11)
oPrint:Say  (nRow3+1995,830 ,"R$"                                             ,oFont13n)

oPrint:Say  (nRow3+1965,1065,"Quantidade"                                     ,oFont11)
oPrint:Say  (nRow3+1965,1370,"(x) Valor"                                          ,oFont11)
	
oPrint:Say  (nRow3+1965,1690,"(=) Valor do Documento"                          	,oFont11)
cString  := Transform(aDadosTit[5],"@E 99,999,999.99")
nCol 	 := 1690+(374-(len(cString)*22))
oPrint:Say  (nRow3+1995,nCol,cString,oFont13n)

oPrint:Say  (nRow3+2040,105 ,"Instruções (Todas informações deste bloqueto são de exclusiva responsabilidade do cedente)",oFont11)
oPrint:Say  (nRow3+2080,105 ,aBolText[1] + AllTrim(Transform( aDadosTit[5] * (aDadosBanco[8]/100),"@E 99,999,999.99")) + aBolText[2],oFont13n)
oPrint:Say  (nRow3+2120,105 ,aBolText[3],oFont13n)
oPrint:Say  (nRow3+2160,105 ,aBolText[4]										,oFont13n)

oPrint:Say  (nRow3+2025,1690,"(-)Desconto/Abatimento"                         ,oFont11)
oPrint:Say  (nRow3+2085,1690,"(-)Outras Deduções"                             ,oFont11)
oPrint:Say  (nRow3+2145,1690,"(+)Mora/Multa"                                  ,oFont11)
oPrint:Say  (nRow3+2205,1690,"(+)Outros Acréscimos"                           ,oFont11)
oPrint:Say  (nRow3+2265,1690,"(=)Valor Cobrado"                               ,oFont11)

oPrint:Say  (nRow3+2330,0105,"Sacado"                                         ,oFont11)
oPrint:Say  (nRow3+2330,0240,Upper(Alltrim(aDatSacado[1]))                    ,oFont13n)

if aDatSacado[8] = "J"
	oPrint:Say  (nRow3 + 2330,1690,"CNPJ: "+TRANSFORM(aDatSacado[7],"@R 99.999.999/9999-99"),oFont13n) // CGC
Else
	oPrint:Say  (nRow3 + 2330,1690,"CPF: "+TRANSFORM(aDatSacado[7],"@R 999.999.999-99"),oFont13n) 	// CPF
EndIf


oPrint:Say  (nRow3 + 2365,0105,"Endereço"										,oFont11)
oPrint:Say  (nRow3 + 2365,0240,aDatSacado[3] + aDatSacado[4] - aDatSacado[5]	,oFont13n)
oPrint:Say  (nRow3 + 2405,0240,aDatSacado[6]									,oFont13n)

oPrint:Say  (nRow3 + 2480,105 ,"Uso do Banco",oFont11)
oPrint:Say  (nRow3 + 2490,1400,"Código de Baixa",oFont11)

oPrint:Line (nRow3+1700,1680,nRow3+2300,1680 )
oPrint:Line (nRow3+2060,1685,nRow3+2060,2150 ) //Desconto/Abatimento
oPrint:Line (nRow3+2120,1685,nRow3+2120,2150 )
oPrint:Line (nRow3+2180,1685,nRow3+2180,2150 )
oPrint:Line (nRow3+2240,1685,nRow3+2240,2150 )
oPrint:Line (nRow3+2300,0100,nRow3+2300,2150 )
oPrint:Line (nRow3+2500,0100,nRow3+2500,2150 )
oPrint:Line (nRow3+1700,0100,nRow3+2500,0100 )
oPrint:Line (nRow3+1700,2150,nRow3+2500,2150 )


oPrint:FwMsBar("INT25",52.5,4,_cCodBar,oPrint,.F.,,.T.,0.020,1.01,NIL,NIL,NIL,.F.) 

//oPrint:Code128C(nRow3+2710,0150,_cCodBar, 48)

IF EMPTY(SE1->E1_NUMBCO) .AND. alltrim(aDadosBanco[1])=='341'
	DbSelectArea("SX5")
	dbSetOrder(1)
	dbSeek(xFilial("SX5")+"_2"+"ITAU")
	While !RecLock("SX5",.F.)
	Enddo
	SX5->X5_DESCRI 	:=	Alltrim(substr(aDadosTit[6],5,8))   // sequencia do Nosso número 
	MsUnlock()
ENDIF

DbSelectArea("SE1")
IF EMPTY(SE1->E1_NUMBCO)
	While !RecLock("SE1",.f.)
	EndDo
	SE1->E1_NUMBCO 	:=	Alltrim(substr(aDadosTit[6],5,8))   // Nosso número (Ver fórmula para calculo)
	MsUnlock()
ENDIF

Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo10    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 10.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ Modulo11    ³Descri‡ão³Faz a verificacao e geracao do digi-³±±
±±³          ³             ³         ³to Verificador no Modulo 11.        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
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
//
//Retorna os strings para inpressão do Boleto
//CB = String para o cód.barras, RN = String com o número digitável
//Cobrança não identificada, número do boleto = Título + Parcela
//
//mj Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cCarteira,cNroDoc,nValor)
//
//					    		   Codigo Banco            Agencia		  C.Corrente     Digito C/C
//					               1-cBancoc               2-Agencia      3-cConta       4-cDacCC       5-cNroDoc              6-nValor
//	CB_RN_NN    := Ret_cBarra(Subs(aDadosBanco[1],1,3)+"9",aDadosBanco[3],aDadosBanco[4],aDadosBanco[5],"175"+AllTrim(E1_NUM),(E1_VALOR-_nVlrAbat) )
//
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Ret_cBarra   ³Descri‡ão³Gera a codificacao da Linha digitav.³±±
±±³          ³             ³         ³gerando o codigo de barras.         ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Ret_cBarra(cBanco,cAgencia,cConta,cDacCC,cNroDoc,nValor,dVencto)
//
LOCAL bldocnufinal := strzero(val(cNroDoc),8)
LOCAL blvalorfinal := strzero(int(nValor*100),10)
LOCAL dvnn         := 0
LOCAL dvcb         := 0
LOCAL dv           := 0
LOCAL NN           := ''
LOCAL RN           := ''
LOCAL CB           := ''
LOCAL s            := ''
LOCAL _cfator      := strzero(dVencto - ctod("07/10/97"),4)
LOCAL _cCart	   := "112"//"109" //carteira de cobranca
//
//-------- Definicao do NOSSO NUMERO
s    :=  cNroDoc //cAgencia + cConta + _cCart + bldocnufinal
dvnn := modulo10(_cCart + s) // digito verifacador Agencia + Conta + Carteira + Nosso Num
NN   := _cCart +"/"+ s + "-" + Alltrim(Str(dvnn))
//
//	-------- Definicao do CODIGO DE BARRAS
s    := cBanco + _cfator + blvalorfinal + _cCart + cNroDoc + Alltrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000' //cBanco + _cfator + blvalorfinal + _cCart + cNroDoc + AllTrim(Str(dvnn)) + cAgencia + cConta + cDacCC + '000'
dvcb := modulo11(s)
CB   := SubStr(s, 1, 4) + AllTrim(Str(dvcb)) + SubStr(s,5)
//
//-------- Definicao da LINHA DIGITAVEL (Representacao Numerica)
//	Campo 1			Campo 2			Campo 3			Campo 4		Campo 5
//	AAABC.CCDDX		DDDDD.DEFFFY	FGGGG.GGHHHZ	K			UUUUVVVVVVVVVV
//
// 	CAMPO 1:
//	AAA	= Codigo do banco na Camara de Compensacao
//	  B = Codigo da moeda, sempre 9
//	CCC = Codigo da Carteira de Cobranca
//	 DD = Dois primeiros digitos no nosso numero
//	  X = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := cBanco + _cCart + SubStr(cNroDoc,1,2)
dv   := modulo10(s)
RN   := SubStr(s, 1, 5) + '.' + SubStr(s, 6, 4) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 2:
//	DDDDDD = Restante do Nosso Numero
//	     E = DAC do campo Agencia/Conta/Carteira/Nosso Numero
//	   FFF = Tres primeiros numeros que identificam a agencia
//	     Y = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
//
s    := SubStr(cNroDoc, 3, 8) + Alltrim(Str(dvnn)) + SubStr(cAgencia, 1, 3)
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 3:
//	     F = Restante do numero que identifica a agencia
//	GGGGGG = Numero da Conta + DAC da mesma
//	   HHH = Zeros (Nao utilizado)
//	     Z = DAC que amarra o campo, calculado pelo Modulo 10 da String do campo
s    := SubStr(cAgencia, 4, 1) + cConta + cDacCC + '000'
dv   := modulo10(s)
RN   := RN + SubStr(s, 1, 5) + '.' + SubStr(s, 6, 5) + AllTrim(Str(dv)) + '  '
//
// 	CAMPO 4:
//	     K = DAC do Codigo de Barras
RN   := RN + AllTrim(Str(dvcb)) + '  '
//
// 	CAMPO 5:
//	      UUUU = Fator de Vencimento
//	VVVVVVVVVV = Valor do Titulo
RN   := RN + _cfator + StrZero(Int(nValor * 100),14-Len(_cfator))
//
Return({CB,RN,NN})


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
               
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NWDVMOD10 ºAutor  ³ Rafael Strozi      º Data ³ 28/10/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito verificador cod. barras.                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ APx                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NWDVMOD10(nTemp10)
              
Local nResult := 0  
Local nFator  := 2
Local nTemp   := 0
Local nPos	  := Len(nTemp10)	
Local nCont   := 0

For nCont:=1 to nPos
	nMultip:= val(substr(nTemp10,nPos,1))*nFator      
	If nMultip > 9
		nTemp  += (nMultip - 9)
	Else 
		nTemp  += nMultip
	EndIf 
    nPos:=nPos-1
	If nFator == 2
		nFator := 1
	Else
		nFator := 2
	Endif
Next nCont

nResult:= nTemp%10
If nResult == 0
	nResult := 0
Else
	nResult := 10 - nResult
EndIf 
	
Return(AllTrim(str(nResult)))
                                
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NWDVMOD11 ºAutor  ³ Rafael Strozi	     º Data ³ 28/11/2008  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Calculo do digito verificador do codigo de Nosso Número.   º±±
±±º          ³ para os boletos do Santander Banespa                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ APx                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NWDVMOD11(nTemp11,_cTp)

Local cResult := ""
Local nValor  := 0
Local nFator  := 2
Local nPos    := Len(nTemp11)
Local nCont   := 0

For nCont:=1 to nPos
nValor += val(substr(nTemp11,nPos,1))*nFator
nPos   := nPos -1
nFator := nFator + 1
If nFator > 9
	nFator := 2
Else
	nFator
Endif
Next nCont

nValor := nValor%11

If	_cTp == "NN"
	If nValor == 0 .OR. nValor == 1 
		cResult = "0"
	ElseIf nValor == 10
		cResult = "1"		
	Else
		cResult = ALLTRIM(STR(11 - nValor))
	Endif
ElseIf _cTp == "CODBAR"
	If nValor == 0 .OR. nValor == 1 .OR. nValor == 10
		cResult = "1"
	Else
		cResult = ALLTRIM(STR(11 - nValor))
	Endif
Endif

Return(cResult)
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NWMNTLIN  º Autor ³ Rafael Strozi      º Data ³ 16/04/04    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Monta a linha de digitacao.					              º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ APx                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
Static Function NWMNTLIN(_NossoNumero)
             
Local cCampo1  := ""
Local cCampo2  := ""
Local cCampo3  := ""
Local cCampo4  := ""
Local cCampo5  := ""
Local cCampos  := ""
Local nTemp10  := 0   
Local nSaldo   := Strzero(Round(SE1->E1_SALDO,2)*100,10)

cCampo1 := "033" 		 				     	//Codigo do banco na camara de compensacao
cCampo1 += "9"									//Cod. Moeda 
cCampo1 += "9"									//Fixo "9" conforme manual Santander
cCampo1 += "."  								//"."
cCampo1 += "0935"								//Código do Cedente (Posição 1 a 4)
//cCampo1 += "."  								//"."
nTemp10 := Substr(cCampo1,1,5)+Substr(cCampo1,7,4) //Pega variavel sem o '.'
cCampo1 += NWDVMOD10(nTemp10)				  	//Digito verificador do campo

cCampo2 := "484"								//Código do Cedente (Posição 5 a 7)
cCampo2 += 	Alltrim(substr(_NossoNumero,1,2))	//Nosso Numero (Posição 1 a 2)	
cCampo2 += "." 									//"."
cCampo2 += Alltrim(substr(_NossoNumero,3,5))			//Nosso Numero (Posição 1 a 7)	
//cCampo2 += "." 									//"."
nTemp10 := Substr(cCampo2,1,5)+Substr(cCampo2,7,5)	// Pega variavel sem o '.'
cCampo2 += NWDVMOD10(nTemp10)					//Digito verificador do campo

cCampo3 := Alltrim(substr(_NossoNumero,8,5))	//Nosso Numero (Posição 8 a 13)
cCampo3 += "." 									//"."
cCampo3 += Alltrim(SubStr(_NossoNumero,13,1))	//Nosso Numero (Posição 8 a 13)
cCampo3 +="0"									//IOS (Fixo "0")
cCampo3 +="101"									//Tipo Cobrança (101-Cobrança Simples Rápida Com Registro)
//cCampo3 += "." 									//"."
nTemp10 := Substr(cCampo3,1,5)+Substr(cCampo3,7,5) 					//Pega variavel sem o '.'
cCampo3 += NWDVMOD10(nTemp10)					//Digito verificador do campo

cCampo4 := SubStr(_cCodBarras,5,1)				//Digito Verificador do Código de Barras

cCampo5 := _cFatorVenc							//Fator de vencimento
cCampo5 += nSaldo								//Valor do titulo (Saldo no E1) 

cCampos := cCampo1 +"  "+ cCampo2 + "  " + cCampo3 + "  " + cCampo4 + "  " + cCampo5

Return(cCampos)