#INCLUDE "rwmake.ch"              
#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"                                     
#INCLUDE 'TBICONN.CH'

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³NOVO50    º Autor ³ AP6 IDE            º Data ³  24/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Codigo gerado pelo AP6 IDE.                                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP6 IDE                                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function CnabPed()


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet := .T.
Private oGeraTxt    


//Private cString := "SC5"

//dbSelectArea("SC5")
//dbSetOrder(1)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

@ 200,1 TO 380,380 DIALOG oGeraTxt TITLE OemToAnsi("Gera‡„o de Arquivo Texto")
@ 02,10 TO 080,190
@ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
@ 26,018 Say " SC5                                                           "

@ 70,128 BMPBUTTON TYPE 01 ACTION OkGeraTxt() 
@ 70,158 BMPBUTTON TYPE 02 ACTION Close(oGeraTxt)    
                                                        



Activate Dialog oGeraTxt Centered

Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKGERATXTº Autor ³ AP5 IDE            º Data ³  24/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a geracao do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkGeraTxt

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Cria o arquivo texto                                                ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Local lRet := .T.
Private cArqTxt := "C:\CNABPED\"+SubStr( Time(), 1, 2 )+SubStr( Time(), 4, 2 )+SubStr( Time(), 7, 2 )+".REM"
Private nHdl    := fCreate(cArqTxt)

Private cEOL    := "CHR(13)+CHR(10)"
If Empty(cEOL)
    cEOL := CHR(13)+CHR(10)
Else
    cEOL := Trim(cEOL)
    cEOL := &cEOL
Endif

If nHdl == -1
    MsgAlert("O arquivo de nome "+cArqTxt+" nao pode ser executado! Verifique os parametros.","Atencao!")
    lRet := .F.
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Processa({|| RunItau() },"Processando...")
Return(lRet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ RUNCONT  º Autor ³ AP5 IDE            º Data ³  24/01/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela PROCESSA.  A funcao PROCESSA  º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunCont

Local nTamLin, cLin, cCpo, cDet
Local cCodReg := "0"
Local cCodRem := "1"
Local cLitRem := "REMESSA"
Local cCodSer := "01"
Local cLitSer := "COBRANCA"
Local CBranco := PADR(" ",7)
Local cAgen   := "3221"	
Local cDvAg   := "2"
Local cConta  := "00007136"
Local CDvCon  := "6"
Local cNConv  := "000000"
Local cNomEmp := PADR("BLUE CYCLE DISTRIBUIDORA SA",30)
Local cCodBan := "001"
Local cNomBan := PADR("BANCO DO BRASIL",15)
Local dData   := cValtoChar(Day(Date()))+cValtoChar(StrZero(Month(Date()),2))+SUBSTR(CValtoChar(Year(Date())),3,2)
Local dDataV  := cValtoChar(StrZero(Day(U_SomDiaUt(Date(),3)),2))+cValtoChar(StrZero(Month(U_SomDiaUt(Date(),3)),2))+SUBSTR(CValtoChar(Year(U_SomDiaUt(Date(),3))),3,2)
Local nInc    := cValtoChar(StrZero(1,7))
Local cBanc  := PADL(" ",22)
Local cCodLi := "2921908"
Local cBan3  := PADL(" ",258)
Local cNum	 := "000001"                  
Local IncDet := 2


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbSelectArea(cString)
//dbGoTop()

//ProcRegua(RecCount()) // Numero de registros a processar

//While !EOF()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    IncProc()
    nTamLin := 400
    //ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    //º Lay-Out do arquivo Texto gerado:                                º
    //ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
    //ºCampo           ³ Inicio ³ Tamanho                               º
    //ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
    //º ??_FILIAL     ³ 01     ³ 02                                    º
    //ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼                                        
    
     
    nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
    //³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
    //³ string dentro de outra string.                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    cCpo := cCodReg+cCodRem+cLitRem+cCodSer+cLitSer+CBranco+cAgen+cDvAg+cConta+CDvCon+cNConv+cNomEmp+cCodBan+cNomBan+cValtoChar(dData)+nInc+cBanc+cCodLi+cBan3+cNum

    cLin := Stuff(cLin,01,02,cCpo)
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
//            Exit
        Endif
    Endif


//Local aArqSE1  := {"SE1",SE1->(IndexOrd()),SE1->(Recno())}

		dbSelectArea("TRE1")
		dbGotop()
		
		While ! Eof()
		
		   	If ! Marked("C5_OK")
		      dbSelectArea("TRE1")
		      dbSkip()
		      Loop
		   	EndIf       
		                                                                                       
		    nTamLin := 400
		    nTamLin := 2
		    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao		   
		    
		   	DbSelectArea("SA1")
		   	DbSetOrder(1)
		   	DbSeek(xFilial("SA1")+TRE1->C5_CLIENTE+TRE1->C5_LOJACLI)
		    

		    DbSelectArea("SC5")
		    DbSetOrder(1)
		    DbSeek(xFilial("SC5")+TRE1->C5_NUM)
		    
			RecLock("SC5",.F.)    
			If SC5->C5_VLCNAB <> ROUND(U_FTotPed(SC5->C5_NUM) - SC5->C5_VLPGANT,2)
				SC5->C5_VLCNAB := ROUND(U_FTotPed(SC5->C5_NUM),2) - SC5->C5_VLPGANT
				SC5->C5_PARCELA := SC5->C5_PARCELA + 1
			EndIf
			SC5->C5_CNAB 	:= "S"
			MsUnlock()		    

		   
		   	cDet := "7"    
			cDet += IF (SA1->A1_PESSOA = "J","02","01")
			cDet += SM0->M0_CGC
			cDet += "3221"
			cDet += "2"
			cDEt += "00007136"
			cDet += "6"
			cDet += "2921908"
			cDet += PADR(TRE1->C5_NUM,25)
			cDet += "2921908"
			cDet += "9"+cValtoChar(StrZero(Val(TRE1->C5_NUM),7))+cValtoChar(StrZero(SC5->C5_PARCELA,2)) //corrigir considerando o numero da parcela do titulo no banco a cada envio. Corrigir também no boleto
			cDet += "0000"
			cDet += PADR(" ",7)
			cDet += "0190000000"
			cDet += PADR(" ",5)
			cDet += "1701"
			cDet += "9"+cValtoChar(StrZero(Val(TRE1->C5_NUM),7))+cValtoChar(StrZero(SC5->C5_PARCELA,2)) //corrigir considerando o numero da parcela do titulo no banco a cada envio. Corrigir também no boleto
			cDet += cValtoChar(dDataV)
			cDet += cValtoChar(StrZero((ROUND(TRE1->TotPed-SC5->C5_VLPGANT,2)*100),13))
			cDet += "0010000"
			cDet += PADR(" ",1)
			cDet += "01N"
			cDet += cValtoChar(dData)
			cDet += "0000"
			cDet += cValtoChar(StrZero(0,13))
			cDet += "0000000000000000000"
			cDet += cValtoChar(StrZero(0,26))      
			cDet += IF (RIGHT(SA1->A1_PESSOA,2) = " ","01","02")
			cDet += PADL(ALLTRIM(SA1->A1_CGC),14,"0")
			cDet += PADR(SA1->A1_NOME,37)
			cDet += PADR(" ",3)
			cDet += PADR(SA1->A1_END,37)
			cDet += PADR(" ",15)
			cDet += PADR(SA1->A1_CEP,8) 
			cDet += PADR(SA1->A1_MUN,15)
			cDet += PADR(SA1->A1_EST,2)
			cDet += PADR(" ",43)
			cDet += cValtoChar(StrZero(IncDet,6))
			
			IncDet++
			
			cLin := Stuff(cLin,01,02,cDet)



		    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		//            Exit
		        Endif
		    Endif
			
			
		   
		   	dbSelectArea("TRE1")
		   	dbSkip()
		
		EndDo
    
         
    nTamLin := 400
    nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao



    cTrai := "9"+PADR(" ",393)+cValtoChar(StrZero(IncDet,6))

    cLin := Stuff(cLin,01,02,cTrai)
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
//            Exit
        Endif
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


  //
  //  dbSkip()
//EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
//Close(oGeraTxt)

Return
              

/*
User Function IncRem()   

Local c_Ret := getmv("MV__INCREM") 
c_Ret :=c_Ret+1 
PutMv("MV__INCREM", c_Ret) 
Return(c_Ret)          
  */




User Function FTMakPed()

Local oDlgMark
Local lInvLib  := .F.
Local cMarcAlt := GetMark()

// A MsGetDados e MsMGet necessitam que estes array e variaveis estejam declarados
Private lRefresh  := .T.
Private aTELA[0][0],aGETS[0]
Private aRotina := { { "", "", 0 , 1}, { "", "", 0 , 2}, { "", "", 0 , 3}, { "", "", 0 , 4}, { "", "", 0 , 5} }

Private oMarkAlt
Private lCanAllMark	:= .T.
Private lHasMark		:= .T.

Private cCodiBanc := Space(TamSx3("A6_COD")[1])
Private cCodiAgen := Space(TamSx3("A6_AGENCIA")[1])
Private cCodiCCor := Space(TamSx3("A6_NUMCON")[1])
Private cNossNume := Space(TamSx3("EE_NOSSNUM")[1])
Private cCarteira := Space(TamSx3("EE_NUNCART")[1])

Private lSaiTela := .F.

Private cArqTrbE1 := ""
Private aStruSE1  := {}
Private cIndeSE1  := Space(10)
Private aCampoSE1 := {}

Private oGrpMark, oGrpBanc

Private oBTn1
Private oBTn2

Private aTamTela := {060,060,554,1000}
Private aTGrMark := {001,001,245,470}
Private aTGrBanc := {005,006,035,400}

Private aPosGBCO  := {017,010}
Private aPosGAGE  := {017,040}
Private aPosGCON  := {017,073}
Private aPosGCar  := {017,140}
Private aPosGNNu  := {017,170}

Private aTamLAB   := {185,005,205,100}
Private aPosChe   := {190,010,080,010}

Private aTamMBro  := {010,005,225,465}

Private aPosSVlr  := {233,180}

Private lDtVenc   := .F.

Private nTotaMark := 0.00
Private oTotaMark,oFntVlrt

Private cPerg := "JurComp"
Pergunte(cPerg,.T.)   
fCriaSx1(cPerg)


// Monta o browse de Alteracoes
AADD(aCampoSE1,{"C5_OK"     ,,"OK"                           ,PesqPict("SC5","C5_OK")})
AADD(aCampoSE1,{"C5_FILIAL",,AllTrim(RetTitle("C5_FILIAL")),PesqPict("SC5","C5_FILIAL")})
AADD(aCampoSE1,{"C5_NUM    ",,AllTrim(RetTitle("C5_NUM    ")),PesqPict("SC5","C5_NUM    ")})
AADD(aCampoSE1,{"C5_CLIENTE",,AllTrim(RetTitle("C5_CLIENTE")),PesqPict("SC5","C5_CLIENTE")})
AADD(aCampoSE1,{"C5_LOJACLI ",,AllTrim(RetTitle("C5_LOJACLI ")),PesqPict("SC5","C5_LOJACLI ")})
AADD(aCampoSE1,{"A1_NOME",,AllTrim(RetTitle("A1_NOME")),PesqPict("SA1","A1_NOME")})
AADD(aCampoSE1,{"TOTPED"	,,"Total Pedido" 						,PesqPict("SE1","E1_VALOR  ")})
AADD(aCampoSE1,{"C5_VLPGANT"	,,"Total Recebido" 						,PesqPict("SC5","C5_VLPGANT")})
AADD(aCampoSE1,{"C5_VLCNAB"	,,"Valor CNAB" 						,PesqPict("SC5","C5_VLCNAB")})
AADD(aCampoSE1,{"C5_CNAB"	,,"Gerou CNAB?" 						,PesqPict("SC5","C5_CNAB")})
//AADD(aCampoSE1,{"E1_VENCTO ",,AllTrim(RetTitle("E1_VENCTO ")),PesqPict("SE1","E1_VENCTO ")})
//AADD(aCampoSE1,{"E1_EMISSAO",,AllTrim(RetTitle("E1_EMISSAO")),PesqPict("SE1","E1_EMISSAO")})
//AADD(aCampoSE1,{"E1_VENCTO",,AllTrim(RetTitle("E1_VENCTO")),PesqPict("SE1","E1_VENCTO")})
//AADD(aCampoSE1,{"E1_PARCELA",,AllTrim(RetTitle("E1_PARCELA")),PesqPict("SE1","E1_PARCELA")})
//AADD(aCampoSE1,{"E1_TIPO   ",,AllTrim(RetTitle("E1_TIPO   ")),PesqPict("SE1","E1_TIPO   ")})
//AADD(aCampoSE1,{"E1_LOJA   ",,AllTrim(RetTitle("E1_LOJA   ")),PesqPict("SE1","E1_LOJA   ")})
//AADD(aCampoSE1,{"E1_PEDIDO ",,AllTrim(RetTitle("E1_PEDIDO ")),PesqPict("SE1","E1_PEDIDO ")})

FCrTrbE1(cMarcAlt)

While ! lSaiTela

   Define MSDialog oDlgMark Title OemToAnsi("Titulos para Impressao Boleto Bancario.") From aTamTela[01],aTamTela[02] TO aTamTela[03],aTamTela[04] Pixel
   Define FONT oFntVlrt NAME "Arial" Size 000,015 BOLD

//   oGrpBanc := TGroup():New(aTGrBanc[01],aTGrBanc[02],aTGrBanc[03],aTGrBanc[04],OemToAnsi("Informe os Dados Banco\Agencia\Conta Corrente\Carteira."),,CLR_HBLUE,,.T.)
//   @ aPosGBCO[01],aPosGBCO[02] MsGet cCodiBanc Valid ExistCpo("SA6",cCodiBanc) .And. FVldBanc() F3 "SA6BOL"  Pixel
//   @ aPosGAGE[01],aPosGAGE[02] MsGet cCodiAgen Valid ExistCpo("SA6",cCodiBanc+cCodiAgen) Pixel
//   @ aPosGCON[01],aPosGCON[02] MsGet cCodiCCor Valid ExistCpo("SA6",cCodiBanc+cCodiAgen+cCodiCCor) .And. FVldCCor() Pixel
//   @ aPosGCar[01],aPosGCar[02] MsGet cCarteira Picture "@!" Valid FVldCart() Pixel

//   @ aPosGNNu[01],aPosGNNu[02] MsGet cNossNume Valid .T. When RefrDial() SIZE 110,10 Pixel

   oGrpMark := TGroup():New(aTGrMark[01],aTGrMark[02],aTGrMark[03],aTGrMark[04],OemToAnsi("Marque os Pedidos para geração do arquivo de transmissão."),,CLR_HBLUE,,.T.)
   oMarkAlt := MsSelect():New("TRE1","C5_OK",,aCampoSE1,lInvLib,cMarcAlt,aTamMBro)
   oMarkAlt:oBrowse:lCanAllMark := .T.
   oMarkAlt:oBrowse:lHasMark    := .T.
   oMarkAlt:bMark               := {|| FAltEsco(cMarcAlt,lInvLib,oDlgMark)}
   oMarkAlt:oBrowse:bAllMark    := {|| FAltMarkAll(cMarcAlt,oDlgMark)}

   @ aPosSVlr[01],aPosSVlr[02] SAY oTotaMark Var "Valor Total Marcado"+TransForm(nTotaMark,"@E 999,999,999.99") Of oDlgMark FONT oFntVlrt PIXEL COLOR CLR_HRED

   Define SButton oBTn1 From 230,370 Type 1 Action (Iif(FFTelaOk(),OkGeraTxt() .And. oDlgMark:End(),NIL)) Enable Of oDlgMark
   Define SButton oBTn2 From 230,420 Type 2 Action (Iif(FCancel(),oDlgMark:End(),NIL)) Enable Of oDlgMark

   Activate MSDialog oDlgMark Centered

EndDo
                                                   
If (Select("TRE1") <> 0)
   dbSelectArea("TRE1")
   dbCloseArea()
EndIf

// Remove arquivos temporarios
Ferase(cArqTrbE1+GetDBExtension())
Ferase(cArqTrbE1+OrdBagExt())

Return                          








Static Function FCrTrbE1(cMarcAlt)

dbSelectArea("SC5")
dbSetOrder(1)

aStruSE1  := SC5->(dbStruct()) 

aStruSE1 := {{"C5_OK","C",02} ,; 
			{"C5_FILIAL","C",02} ,; 
			{"C5_NUM","C",06} ,;
			{"C5_CLIENTE","C",06} ,;
			{"C5_LOJACLI","C",02} ,;
			{"A1_NOME","C",40} ,;
			{"TOTPED","N",18,2},; 
			{"C5_VLPGANT","N",18,2},;
			{"C5_VLCNAB","N",18,2},;
			{"C5_CNAB","C",03}}
cIndeSE1  := SC5->(IndexKey())
cArqTrbE1 := CriaTrab(aStruSE1,.T.)

dbUseArea(.T.,,cArqTrbE1,"TRE1",.F.,.F.)
IndRegua("TRE1",cArqTrbE1,cIndeSE1,,,"Selecionando registros...")

FGrvTrbE1(cMarcAlt)

Return



//---------------------------------------------------------------------------------------
/*/{Protheus.doc} FGrvTrbE1
Função de gravação do Arquivo de Trabalho utilizado na Tela de Seleção.

@protected
@author		Ederson Colen
@since		04/12/2012
@version	P11
@param	
@return	

@obs  

Alteracoes Realizadas desde a Estruturacao Inicial 
Data       	Programador     		Motivo      
/*/
//---------------------------------------------------------------------------------------
Static Function FGrvTrbE1(cMarcAlt)

Local aArqSE1   := {"SC5",SC5->(IndexOrd()),SC5->(Recno())}
                                                                             

cAliasPed := GetNextAlias()

cQuery := " SELECT C5_FILIAL,C5_OK, C5_NUM, C5_CLIENTE, C5_LOJACLI,A1_NOME,  SUM((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+"

cQuery += " (CASE WHEN F7_MARGEM > 0 THEN ((((C6_QTDVEN*C6_PRCVEN)+(CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+ "
//cQuery += " (CASE WHEN F7_MARGEM > 0 THEN  ((C5_FRETE*B1_PESO*C6_QTDVEN)/ "+cValtoChar(U_FProdIPI("C5_NUM"))+" *100) END)+ "

cQuery += " ((((CASE WHEN F4_IPI = 'S' THEN ((C6_QTDVEN*C6_PRCVEN)/100)*B1_IPI ELSE 0 END)+(C6_QTDVEN*C6_PRCVEN))/100)*F7_MARGEM))/100)
cQuery += " *(CASE WHEN F7_EST = 'RJ' THEN 20 ELSE F7_ALIQINT END))-(CASE WHEN F4_ICM = 'S' THEN (((C6_QTDVEN*C6_PRCVEN))/100)*F7_ALIQEXT ELSE 0 END)" 
cQuery += " ELSE 0 END))+C5_FRETE AS TOTPED, C5_VLPGANT, C5_VLCNAB,CASE WHEN C5_CNAB = 'S' THEN 'Sim' ELSE 'Nao' END C5_CNAB "
cQuery += " FROM "+ RetSqlName("SC6") +" SC6"  
cQuery += " JOIN "+ RetSqlName("SC5") +" SC5 ON (C5_FILIAL = C6_FILIAL AND C5_NUM = C6_NUM)" 
cQuery += " JOIN "+ RetSqlName("SB1") +" SB1 ON (SB1.B1_COD = SC6.C6_PRODUTO)" 
cQuery += " JOIN "+ RetSqlName("SF4") +" SF4 ON (SF4.F4_CODIGO = SC6.C6_TES)" 
cQuery += " JOIN "+ RetSqlName("SA1") +" SA1 ON A1_COD = C6_CLI AND A1_LOJA = C6_LOJA"
cQuery += " LEFT JOIN SF7010 SF7 ON F7_FILIAL = C6_FILIAL AND F7_GRTRIB = B1_GRTRIB AND F7_GRPCLI = A1_GRPTRIB AND F7_EST = A1_EST "		        
cQuery += " WHERE SC6.C6_FILIAL = '"+xFilial("SC6")+"' AND SB1.D_E_L_E_T_ <> '*' AND SF4.D_E_L_E_T_ <> '*'  AND SC6.D_E_L_E_T_ = ' '"
cQuery += " AND SA1.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SF4.F4_DUPLIC = 'S' "


cQuery += " AND SC5.C5__STATUS = '14' " 

IF MV_PAR01 == 2
	//cQuery += " AND SC5.C5_VLCNAB = 0 " 
	cQuery += " AND SC5.C5_VLCNAB = 0 "
EndIf 
  
cQuery += " GROUP BY C5_FILIAL,C5_OK, C5_NUM, C5_CLIENTE, C5_LOJACLI, A1_NOME,C5_VLPGANT, C5_VLCNAB,C5_CNAB, C5_FRETE "       


cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasPed,.T.,.T.)  


DbSelectArea(cAliasPed)
DbGoTop()  		
Do While !Eof(cAliasPed)     		

   //nValPed := ROUND(U_FTotPed((cAlias)->C5_NUM),2)
   dbSelectArea("TRE1")
   RecLock("TRE1",.T.)
   For nXi := 1 To Len(aStruSE1)
       If aStruSE1[nxI,2] == "D" 
          TRE1->(FieldPut(nXi,SToD((cAliasPed)->(FieldGet(FieldPos(aStruSE1[nXi][1]))))))
       Elseif aStruSE1[nxI,1] == "TOTPED"
          TRE1->TOTPED := ROUND(U_FTotPed((cAliasPed)->C5_NUM,"1"),2)
          
          //alert((cAliasPed)->C5_NUM)
          //TRE1->(FieldPut(nXi,ROUND(U_FTotPed((cAlias)->C5_NUM),2)))
       Else
          TRE1->(FieldPut(nXi,(cAliasPed)->(FieldGet(FieldPos(aStruSE1[nXi][1])))))
          
       EndIf
   Next nXi
   MsUnLock()

   dbSelectArea(cAliasPed)
   dbSkip()

EndDo

dbSelectArea("TRE1")
dbGoTop()                                                                  

//Retorna Ambiente
dbSelectArea(aArqSE1[1])
dbSetOrder(aArqSE1[2])
dbGoTo(aArqSE1[3])

DbCloseArea(cAliasPed)

Return                    




Static Function RefrDial()

Local cSeqNNBan := ""

dbSelectArea("SA6")
dbSeek(xFilial("SA6")+cCodiBanc+cCodiAgen+cCodiCCor)
If ! Eof()
   cSeqNNBan := ""  //SA6->A6_SEQBANC
EndIf

dbSelectArea("SEE")
If dbSeek(xFilial("SEE")+cCodiBanc+cCodiAgen+cCodiCCor+cSeqNNBan)
   cNossNume := AllTrim(SEE->EE_NOSSNUM)
EndIf

SysRefresh()

Return(.F.)
                      



Static Function FAltEsco(cMarcAlt,lInvLib,oDlgMark)

Local lRetFunc := .T.

If IsMark("C5_OK",cMarcAlt,lInvLib)
  RecLock("TRE1",.F.)
  If ! lInvLib
     Replace TRE1->C5_OK With cMarcAlt
     nTotaMark += TRE1->TOTPED
  Else
     Replace TRE1->C5_OK With "  "
     nTotaMark -= TRE1->TOTPED
  Endif
  MsUnlock()
Else
  RecLock("TRE1",.F.)
  If ! lInvLib
     Replace TRE1->C5_OK With "  "
     nTotaMark -= TRE1->TOTPED
  Else
     Replace TRE1->C5_OK With cMarcAlt
     nTotaMark += TRE1->TOTPED
  Endif
  MsUnlock()
Endif
oDlgMark:Refresh()
oTotaMark:Refresh()

Return(lRetFunc)          



Static Function FFTelaOk()

Local lRetVld := .T.

lSaiTela := .T.

Return(lRetVld)    


User function SomDiaUt(dData,nDias)
For nCont:=1 to nDias
     dData += 1
     If dow(dData)== 1 //domingo
          dData += 1
     ElseIf dow(dData)== 7 //sabado
          dData += 2
     EndIf
Next

Return dData


Static Function FCancel()

Local lRetVld := .T.

lSaiTela := .T.

Return(lRetVld)            




Static Function fCriaSx1(cPerg)
	
	Local aHelpPor		:= {}
	
	aHelpPor	:= {}
	AAdd(aHelpPor ,"Pedidos" ) 
	// 																							 cGSC [ cValid ] [ cF3 ] [ cGrpSxg ] [ cPyme ] [ cVar01 ] [ cDef01 ] [ cDefSpa1 ] [ cDefEng1 ] [ cCnt01 ] [ cDef02 ] [ cDefSpa2 ] [ cDefEng2 ] [ cDef03 ] [ cDefSpa3 ] [ cDefEng3 ] [ cDef04 ] [ cDefSpa4 ] [ cDefEng4 ] [ cDef05 ] [ cDefSpa5 ] [ cDefEng5 ] [ aHelpPor ] [ aHelpEng ] [ aHelpSpa ] [ cHelp ] 
		PutSx1(cPerg,"01","Considera Pedidos?   ","Considera Pedidos?"		  ,"Considera Pedidos?"	   ,"mv_ch1","N",1,0,0,"C","","","","","MV_PAR01","Todos","","","","Não Processados","","","","","","","","","","","",aHelpPor,,)
		//PutSx1(cPerg,"02","Emissão De.:   ","Emissão De.:   ","Emissão De.:   ","mv_ch2","D",8,0,0,"G","","","","","MV_PAR02","","","","","","","","","","","","","","","","",aHelpPor,,)
		//PutSx1(cPerg,"03","Emissão Até.:  ","Emissão Até.:  ","Emissão Até.:  ","mv_ch3","D",8,0,0,"G","","","","","MV_PAR03","","","","","","","","","","","","","","","","",aHelpPor,,)
Return






Static Function RunItau

Local nTamLin, cLin, cCpo, cDet
Local cCodReg := "0"
Local cCodRem := "1"
Local cLitRem := "REMESSA"
Local cCodSer := "01"
Local cLitSer := PADR("COBRANCA",15)
Local CBranco := ""
Local cAgen   := "2938"	
Local cDvAg   := ""
Local cConta  := "0028591"
Local CDvCon  := "9"
Local cNConv  := PADL(" ",8)
Local cNomEmp := PADR("BLUE CYCLE DISTRIBUIDORA SA",30)
Local cCodBan := "341"
Local cNomBan := PADR("BANCO ITAU SA",15)
Local dData   := cValtoChar(StrZero(Day(Date()),2))+cValtoChar(StrZero(Month(Date()),2))+SUBSTR(CValtoChar(Year(Date())),3,2)
Local dDataV  := cValtoChar(StrZero(Day(U_SomDiaUt(Date(),3)),2))+cValtoChar(StrZero(Month(U_SomDiaUt(Date(),3)),2))+SUBSTR(CValtoChar(Year(U_SomDiaUt(Date(),3))),3,2)
Local nInc    := cValtoChar(StrZero(1,7))
Local cBanc  := PADL(" ",294)
Local cCodLi := "2921908"
Local cBan3  := PADL(" ",258)
Local cNum	 := "000001"                  
Local IncDet := 2 
Local nValNCC := 0
Local cMSG := ""
Local _lAlt := .F.

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posicionamento do primeiro registro e loop principal. Pode-se criar ³
//³ a logica da seguinte maneira: Posiciona-se na filial corrente e pro ³
//³ cessa enquanto a filial do registro for a filial corrente. Por exem ³
//³ plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    ³
//³                                                                     ³
//³ dbSeek(xFilial())                                                   ³
//³ While !EOF() .And. xFilial() == A1_FILIAL                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//dbSelectArea(cString)
//dbGoTop()

//ProcRegua(RecCount()) // Numero de registros a processar

//While !EOF()

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Incrementa a regua                                                  ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    IncProc()
    nTamLin := 400
    //ÉÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»
    //º Lay-Out do arquivo Texto gerado:                                º
    //ÌÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹
    //ºCampo           ³ Inicio ³ Tamanho                               º
    //ÇÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¶
    //º ??_FILIAL     ³ 01     ³ 02                                    º
    //ÈÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼                                        
    
     
    nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao

    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Substitui nas respectivas posicioes na variavel cLin pelo conteudo  ³
    //³ dos campos segundo o Lay-Out. Utiliza a funcao STUFF insere uma     ³
    //³ string dentro de outra string.                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

    cCpo := cCodReg+cCodRem+cLitRem+cCodSer+cLitSer+CBranco+cAgen+cDvAg+cConta+CDvCon+cNConv+cNomEmp+cCodBan+cNomBan+cValtoChar(dData)+cBanc+cNum

    cLin := Stuff(cLin,01,02,cCpo)
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
//            Exit
        Endif
    Endif


//Local aArqSE1  := {"SE1",SE1->(IndexOrd()),SE1->(Recno())}

		dbSelectArea("TRE1")
		dbGotop()
		
		While ! Eof()
		    
		 	nValNCC := 0
		   	If ! Marked("C5_OK")
		      dbSelectArea("TRE1")
		      dbSkip()
		      Loop
		   	EndIf       
		   	
		                                                                                       
		    nTamLin := 400
		    nTamLin := 2
		    cLin    := Space(nTamLin)+cEOL 
		    
		   	DbSelectArea("SA1")
		   	DbSetOrder(1)
		   	DbSeek(xFilial("SA1")+TRE1->C5_CLIENTE+TRE1->C5_LOJACLI)
		    

		    DbSelectArea("SC5")
		    DbSetOrder(1)
		    DbSeek(xFilial("SC5")+TRE1->C5_NUM)
		    
		    If FPesqNCC(SC5->C5_CLIENTE,SC5->C5_LOJACLI) > 0 
		    	nValNCC := ROUND(FPesqNCC(SC5->C5_CLIENTE,SC5->C5_LOJACLI),2)
		    	cMSG := "Pedido: "+SC5->C5_NUM+chr(13)+chr(10) 
		    	cMSG += "Cliente: "+SA1->A1_NOME+chr(13)+chr(10)
		    	cMSG += "Valor NCC/RA: "+cValtoChar(nValNCC)+chr(13)+chr(10) 
		    	cMSG += "NCC/RA em aberto, deseja utilizar?"+chr(13)+chr(10) 
		    	
		        If ApMsgNoYes(cMSG,"Atenção")
		        	If ApMsgNoYes("CONFIRMA A UTILIZAÇÃO DO CRÉDITO NO VALOR DE "+cValtoChar(nValNCC)+" PARA ESTE PEDIDO?","ATENÇÃO - UTILIZAÇÃO DE CRÉDITO")
		            	If nValNCC < ROUND(U_FTotPed(SC5->C5_NUM) - SC5->C5_VLPGANT,2)
							RecLock("SC5",.F.)    
							SC5->C5_CREDNCC := SC5->C5_CREDNCC + nValNCC
							MsUnlock()
						Else	    	            	
							RecLock("SC5",.F.)    
							SC5->C5_CREDNCC := SC5->C5_CREDNCC + nValNCC
							SC5->C5_RETBCO := "Crédito NCC: "+cValtoChar(nValNCC)
							MsUnlock()	                    
							
							If SC5->C5_YTPED = "02" 
								_lAlt	:= .T. 
							EndIf							
	
							cPedido := SC5->C5_NUM
					
							If SC5->C5__STATUS = '14' 
							
										If SC5->C5_CONDPAG = '001' .and. (SC5->C5_VLPGANT+SC5->C5_CREDNCC) < ROUND(u_fTotPed(SC5->C5_NUM),2)
											Aviso("ATENCAO","O valor pago antecipadamente pelo cliente é menor que o valor do pedido: "+cPedido+". Pedido retido, aguardando pagamento.",{"OK"},3)
										   	If SC5->(! Eof())
												RecLock("SC5",.F.)
												SC5->C5__STATUS := "14" 
												MsUnlock()
											EndIf  				
										Else		   
											   If SC5->(! Eof())
													RecLock("SC5",.F.)
													SC5->C5_LIBEROK := "S"
													SC5->C5__STATUS := "4" 
													MsUnlock()
												EndIf  								
				
												_aResult := TCSPEXEC("PROC_PMHA_INTER_SEPARACAO",SC5->C5_FILIAL,"1",SC5->C5_NUM,"NAO TEM NUMERO ORC","",IIF(_lAlt,"ALT","INC"),"","")
							
										        If !Empty(_aResult)
										            If _aResult[1] == "S"
										                Help( Nil, Nil, "ENVPED", Nil, _aResult[2], 1, 0 ) 
										        
										            Else 
													   SC5->(dbSetOrder(1))
													   SC5->(dbSeek(xFilial("SC5")+cPedido))
													   If SC5->(! Eof())
															RecLock("SC5",.F.)
															SC5->C5_LIBEROK := "S"
															SC5->C5__STATUS := "5" 
															MsUnlock()
														EndIf  													
										                
										            EndIf		
							
							                    Else
							                    	Help( Nil, Nil, "ENVNOTFIS", Nil, "Erro ao enviar pedido para arMHAzena", 1, 0 )     
							                    	U_AlertPed(cPedido)
							        
									            EndIf
										
										EndIf
										
								
							EndIf	 
							
							        	    
						 	dbSelectArea("TRE1")
						    dbSkip()
						    Loop	
						                	
		            	EndIf
		        	EndIf
		        Else
					RecLock("SC5",.F.)    
					SC5->C5_CREDNCC := 0
					MsUnlock()		        
		        Endif	
		    EndIf	    	
		    
		    
			RecLock("SC5",.F.)    
			If SC5->C5_VLCNAB <> ROUND(U_FTotPed(SC5->C5_NUM) - SC5->C5_VLPGANT - SC5->C5_CREDNCC,2)
				SC5->C5_VLCNAB := ROUND(U_FTotPed(SC5->C5_NUM) - SC5->C5_VLPGANT - SC5->C5_CREDNCC,2) 
				SC5->C5_PARCELA := SC5->C5_PARCELA + 1
			EndIf
			SC5->C5_CNAB 	:= "S"
			SC5->C5_DTCNAB := Date()
			MsUnlock()		    
            
            U_BOLPED01('2')
		   
		   	cDet := "1"    
			cDet += IF (SA1->A1_PESSOA = "J","02","01")
			cDet += SM0->M0_CGC
			cDet += "2938"
			cDet += "00"
			cDEt += "28591"
			cDet += "9"
			cDet += PADR(" ",4)
			cDet += "0000"
			cDet += PADR(TRE1->C5_NUM,25)
		   //	cDet += "2921908"
			cDet += "9"+cValtoChar(StrZero(Val(SUBSTR(TRE1->C5_NUM,2,5)),5))+cValtoChar(StrZero(SC5->C5_PARCELA,2)) //corrigir considerando o numero da parcela do titulo no banco a cada envio. Corrigir também no boleto
			cDet += "0000000000000"
			cDet += "109"
			cDet += PADR(" ",21)
			cDet += PADR("I",1)
			cDet += "01"
			cDet += "9"+cValtoChar(StrZero(Val(TRE1->C5_NUM),7))+cValtoChar(StrZero(SC5->C5_PARCELA,2))
			//cDet += "9"+cValtoChar(StrZero(Val(SUBSTR(TRE1->C5_NUM,2,5)),5))+cValtoChar(StrZero(SC5->C5_PARCELA,2)) //corrigir considerando o numero da parcela do titulo no banco a cada envio. Corrigir também no boleto
			cDet += cValtoChar(dDataV)
			cDet += cValtoChar(StrZero((ROUND(U_FTotPed(SC5->C5_NUM)-SC5->C5_VLPGANT-SC5->C5_CREDNCC,2)*100),13))
			cDet += "341"
			cDet += "00000"
			cDet += "01N"
			cDet += cValtoChar(dData)
			cDet += "0000"
			cDet += cValtoChar(StrZero(0,13))
			cDet += "0000000000000000000"
			cDet += cValtoChar(StrZero(0,26))      
			cDet += IF (RIGHT(SA1->A1_PESSOA,2) = " ","01","02")
			cDet += PADL(ALLTRIM(SA1->A1_CGC),14,"0")
			cDet += PADR(SA1->A1_NOME,30)
			cDet += PADR(" ",10)
			cDet += PADR(SA1->A1_END,40)
			cDet += PADR(SA1->A1_BAIRRO,12)
			cDet += PADR(SA1->A1_CEP,8) 
			cDet += PADR(SA1->A1_MUN,15)
			cDet += PADR(SA1->A1_EST,2)
			cDet += PADR(" ",34)
			cDet += cValtoChar(dDataV)
			cDet += "00"
			cDet += PADR(" ",1)
			cDet += cValtoChar(StrZero(IncDet,6))
			
			IncDet++
			
			cLin := Stuff(cLin,01,02,cDet)

                    
            
           	U_EMAILBOL(SC5->C5_NUM)
          

		    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
		        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
		//            Exit
		        Endif
		    Endif
			
			
		   
		   	dbSelectArea("TRE1")
		   	dbSkip()
		
		EndDo
    
         
    nTamLin := 400
    nTamLin := 2
    cLin    := Space(nTamLin)+cEOL // Variavel para criacao da linha do registros para gravacao



    cTrai := "9"+PADR(" ",393)+cValtoChar(StrZero(IncDet,6))

    cLin := Stuff(cLin,01,02,cTrai)
    
    If fWrite(nHdl,cLin,Len(cLin)) != Len(cLin)
        If !MsgAlert("Ocorreu um erro na gravacao do arquivo. Continua?","Atencao!")
//            Exit
        Endif
    Endif
    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
    //³ Gravacao no arquivo texto. Testa por erros durante a gravacao da    ³
    //³ linha montada.                                                      ³
    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ


  //
  //  dbSkip()
//EndDo

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
//Close(oGeraTxt)

Return                           


User Function EmailBol(cPedido)

Private nI
Private cUsrname
Private cUsrmail
Private nI
Private lRet := .T.
Private xval := 0
Private xqtd := 0
Private cFILIAL:= "" 
Private xStatus:= ""
Private xMARCA:= ""
Private _cStatus:= ""
Private xCont := 0   
Private nProvent
Private nDescont



        
/////////////////////////EXECUTAR ROTINA SOMENTE PARA PEDIDO TIPO NORMAL////////////////////////////////////////////////////

        cAlias := GetNextAlias()
  
        cQuery := " SELECT C5_NUM, A1_NOME, C5_VEND1, C5_VEND2, C5_CONDPAG, A1_END, A1_BAIRRO, A1_MUN, A1_EST, A1_CEP, E4_DESCRI, A1_EMAIL, C5_FRETE, C5_NOTA, C5_CLIENTE, C5_LOJACLI "
        cQuery += " FROM "+ RetSqlName("SC5") +" SC5"
        cQuery += " INNER JOIN "+ RetSqlName("SA1") +" SA1 ON A1_COD = C5_CLIENTE AND A1_LOJA = C5_LOJACLI " 
        cQuery += " INNER JOIN "+ RetSqlName("SE4") +" SE4 ON E4_CODIGO = C5_CONDPAG  "
        cQuery += " WHERE C5_FILIAL = '"+xFilial("SC5")+"' AND SE4.D_E_L_E_T_ = ' ' AND SC5.D_E_L_E_T_ = ' ' AND SA1.D_E_L_E_T_ = ' ' AND C5_NUM = '"+cPedido+"' AND C5_TIPO = 'N' "            
        
 		cQuery := ChangeQuery(cQuery)
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)  
              

        

                                                                           
		nValPed := 0
		nValIpi := 0
		nValSt  := 0
		nValDesc:= 0

	  //	DbSelectArea("TRB")
	//	DbGoTop()                     
		
		

		        	 
/*			 	If ! TRB->RA_SITFOLH $ MV_PAR07 
			 		DbSelectArea("TRB")
			 		DbSkip()
			 	EndIf*/
		
		

				
				nProvent := 0		
				nDescont := 0
		
				_xto:= ""
	//			_xmail1:= _EMAIL   //PEGA DO GET DA PERGUTA
				_xmail1:= (cAlias)->A1_EMAIL 				
				_xMail2 := POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_EMAIL")+';'+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_EMAIL")
				_xMail3 := 'valdemir.carmo@bluecycle.com.br'
		  //		_xnumped:= cPEDIDO  //PEGA O NUMERO DO PEDIDO BLUE CYCLE
		
		  //      _cStatus := TRB->ZM_DESC
		
		
				cMensagem := '<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">'
				cMensagem += '<html>'
				cMensagem += '<head> '
				
				
				  
				cMensagem += '<meta content="text/html; charset=ISO-8859-1" http-equiv="content-type">'
				
				  
				cMensagem += '  <title>Conf_Ped</title> '
				cMensagem += '</head>      '
				
				
				cMensagem += '<body style="margin-left: 14px; width: 1036px;">'
				
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="cabe&ccedil;alho" src="https://static.wixstatic.com/media/410f9c_7fe17f3f380647f68ddf9cc6be60eb2f~mv2.png/v1/fill/w_594,h_101,al_c/410f9c_7fe17f3f380647f68ddf9cc6be60eb2f~mv2.png"><br> '
				
				cMensagem += '<br>'
				
				cMensagem += '<span style="font-weight: bold; font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Ol&aacute;, '+(cAlias)->A1_NOME+',</span><br style="font-family: Arial;">'
				
				
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'
				
			
				cMensagem += '<table style="text-align: left; font-family: Tahoma;  height: 60px; width: 600px;" border="0" cellpadding="0" cellspacing="0">'
				
				cMensagem += '  <tbody> '

				cMensagem += '    <tr> '
				
				cMensagem += '      <td><font size ="2">'				
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; O seu pedido N&ordm; '+(cAlias)->C5_NUM+' foi aprovado! Por se tratar de um pedido de pagamento antecipado, pedimos que efetue o pagamento do boleto em anexo para que o pedido seja processado e expedido.<br>'
						
				cMensagem += '<br style="font-family: Tahoma;"><font size ="2">'
				
			
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Interno: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND2,"A3_NOME")+' </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Tahoma;"><font size ="2">&nbsp;&nbsp;&nbsp; Vendedor Externo: '+POSICIONE("SA3",1,XFILIAL("SA3")+(cAlias)->C5_VEND1,"A3_NOME")+' </span><br>'
				
				cMensagem += '<br>'    
				
				cMensagem += '  </td> '
				
				cMensagem += ' 	</tr>'          

				cMensagem += '  </tbody>'
				cMensagem += '</table>'				
				

				
				cMensagem += '<img style="width: 600px; height: 120px;" alt="pedaprov" src="https://static.wixstatic.com/media/410f9c_beb3a12b660a4ad48e35a01bd2bb8c4f~mv2.png/v1/fill/w_584,h_157,al_c/410f9c_beb3a12b660a4ad48e35a01bd2bb8c4f~mv2.png"><br>'
				
				cMensagem += '<br> '
				

				
				cMensagem += '<br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-weight: bold; font-family: Arial;">&nbsp;&nbsp;&nbsp; Duvidas? 0800 940 03 03</span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial;">&nbsp;&nbsp;&nbsp; &nbsp;&nbsp;&nbsp; </span><br style="font-family: Arial;">'
				
				cMensagem += '<span style="font-family: Arial; font-weight: bold;">&nbsp;&nbsp;&nbsp; Obrigado por comprar com a Blue Cycle!</span><br>'
				
				cMensagem += '<br>'
				
				cMensagem += '<img style="width: 600px; height: 85px;" alt="rodape" src="https://static.wixstatic.com/media/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png/v1/fill/w_570,h_41,al_c/410f9c_8c7af149934a47eea7a942a95eead654~mv2.png"><br>'
				
				
				cMensagem += '</body>'
				cMensagem += '</html> '

				
			
	 //alert(SC5->C5_NUM)	
		
				cBody := cMensagem
				cBCC:= ""
				xLocal:= "\system\antecipados\"
		        //xLocal:= "\system\PEDIDOS\"  //Localizacao do arquivo na system
				arqu:= "itemped.png;"
				//arqu:="pedido_.html" 
				MemoWrite(xLocal+arqu,cMensagem)  
				cFrom := GetMv("MV_EMAILPE")  //conta de email para envio
				cTos:= _xmail1
		        cCC := _xMail2
		        cBCC:= _xMail3   // email de copia para vendedor - copia oculta
		        
				cSubject := 'BOLETO PARA PAGAMENTO - PEDIDO '+(cAlias)->C5_NUM+' - ANTECIPADO' // _xnumped
	//			AADD(cAttachment,{"\system\imgpedidos\itemped.png;"} )
	  //			AADD(cAttachment,{"\system\imgpedidos\cabecalho.png;"} )
				//cAttachment := ''+xLocal+arqu+chr(13)+chr(10)     //atacha a imagem antes do pedido 
				//cAttachment := "\system\imgpedidos\cabecalho.png;"
				cAttachment := xLocal+(cAlias)->C5_NUM+'.pdf'
				//'' //+xLocal+"infped.png" //;itemped.png;pedaprov.png;rodape.png;separacao.png
				xmen := cMensagem
				CONNECT SMTP SERVER GetMv("MV_RELSERV") ACCOUNT GetMv("MV_EMAILPE") PASSWORD GetMv("MV_SENHAPE") RESULT lOk
				// o comando CONNECT conecta ao servidor smtp
				// atraves da conta contida em cAccount
				// repare na senha, eh como se voce utilizasse o Outlook Express
				
				If lOk    // teste se a conexao com o servidor smtp teve sucesso
					If GetMV('MV_RELAUTH')
						Mailauth(GetMv("MV_EMAILPE"),GetMv("MV_SENHAPE"))
					EndIf
					If cAttachment == ""
						SEND MAIL FROM cFrom TO cTos CC cCC  BCC cBCC SUBJECT cSubject BODY xmen RESULT lEnv
					Else
						SEND MAIL FROM cFrom TO cTos CC cCC BCC cBCC SUBJECT cSubject BODY xmen ATTACHMENT cAttachment RESULT lEnv
					Endif
					// o comando sendmail envia a mensagem pela conta cAccount,
					// utilizando a lista de destinatarios em cTos
					// com a mensagem contida em cMensagem
					
					
					DISCONNECT SMTP SERVER;
					RESULT lFim
					
					If ! (lFim)   // testa desconexao do serv. smtp
						lRet := .F.
					Endif
				Else
					lRet := .F.
		 		    //MsgAlert("OCORREU FALHA NA CONEXÃO COM O SERVIDOR DE ENVIO DO EMAIL! FAVOR CONSULTAR O ADMINISTRADOR DA CONTA  "+cFrom)
				Endif 
		//		fErase(xLocal+arqu,cMensagem)    //APAGA O ARQUIVO GERADO NO LOCAL
		
	

  
					
        
	   //	DbCloseArea("TRB")
	
		 	

Return        



Static Function FAltMarkAll(cMarcAlt,oDlgMark)

Local lRetFunc := .T.
Local nRecno   := 0

dbSelectArea("TRE1")
nRecno := Recno()
dbGotop()

Do While !Eof()
  RecLock("TRE1",.F.)
  If ! Marked("C5_OK")
     Replace TRE1->C5_OK With cMarcAlt
     nTotaMark += TRE1->TOTPED
  Else
     Replace TRE1->E1_OK With "  "
     nTotaMark -= TRE1->TOTPED
  Endif
  MsUnlock()
  dbSkip()
EndDo

dbSelectArea("TRE1")
dbGoto(nRecno)

oDlgMark:Refresh()
oTotaMark:Refresh()

Return(lRetFunc)  




Static Function FPesqNCC(cCliente, cLoja)               
Local nValNCC := 0



cAliasNCC := GetNextAlias()

cQuery := " SELECT SUM(E1_SALDO) VALNCC FROM SE1010 WHERE D_E_L_E_T_ = ' ' "
cQuery += " AND E1_CLIENTE = '"+cCliente+"' AND E1_LOJA = '"+cLoja+"' AND E1_SALDO > 0 AND E1_TIPO IN ('NCC','RA') AND E1_NUM <> '"+SC5->C5_NUM+"' "

cQuery := ChangeQuery(cQuery)

DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasNCC,.T.,.T.)  

nValNcc := (cAliasNCC)->VALNCC

DbCloseArea(cAliasNCC)


Return(nValNCC)