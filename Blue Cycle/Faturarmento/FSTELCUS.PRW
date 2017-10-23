#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"

/*
Programa .: TelaFor
Funçao ...: Criação do ListBox, com marcas e produtos
Feito por : Breno Menezes
Data .....: 06/10/2009

Alteracoes Realizadas desde a Estruturacao Inicial
Programador     Data       Motivo
*/
User Function FSTELCUS()

Private oDlg8

@0,0 TO 100,300 DIALOG oDlg8 TITLE "Cadastro de Produto"
@01,03 BUTTON "IMPORTA" size 35,15 Action FImpAtuB1() 	// Botão Importar
@01,13 BUTTON "EXPORTA" size 35,15 Action FExpCust()	// Botão exportar
@01,23 BUTTON "CANCELA" size 35,15 Action oDlg8:End() // Botão Cancelar
Activate Dialog oDlg8 Centered 
	
Return(Nil)



//-------------------------------------------------------------------
/*/{Protheus.doc} FImpAtuB1
Importação Arquivo CSV atualizando o Cadastro de Produtos.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FImpAtuB1()
   
Private oDlg

Private cArq := Space(300) 
	
Define MsDialog oDlg Title "Importacao de Arquivo Excel CSV" From 0,0 to 120,400 Pixel   		// Titulo no cabeçalho da tela

@008,005 say "Nome Arquivo" pixel                                                        	// Título do campo 
@015,005 MsGet oNomArq var cArq Size 165,07 Pixel
@015,170 BMPBUTTON TYPE 14 ACTION (cArq := cGetFile("Importação de Produto (*.CSV) |*.CSV| ","Arquivos Excel",0,Alltrim("C:\"),.T.,GETF_LOCALHARD+GETF_LOCALFLOPPY))
@040,050 BMPBUTTON TYPE 01 ACTION FSEXPFTCS()			// Botão ok busca arquivo e fecha a tela
@040,130 BMPBUTTON TYPE 02 ACTION oDlg:End()

ACTIVATE MSDIALOG oDlg CENTER 
	
Return Nil 



//-------------------------------------------------------------------
/*/{Protheus.doc} FSEXPFTCS
Função que faz a leitura do arquivo .csv e importa fator e custo dos produtos

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FSEXPFTCS() 

FCrTrbIm()

MsgRun("Processando Dados....","Por favor, aguarde",{|| FGrTrbIm()})

FTelGrIm()

oDlg:End()

Return()



//-------------------------------------------------------------------
/*/{Protheus.doc} FCrTrbIm
Funcao para Criacao do Arquivo de Trabalho.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FCrTrbIm()

Local cIndeTRB := ""

Private aStruTRB  := {}
Private cArqTrTRB := ""

If Select("TRB") <> 0
   dbSelectArea("TRB")
   dbCloseArea()
EndIf

aStruTRB := {}
Aadd(aStruTRB,{"B1_COD"	 ,TAMSX3("B1_COD")[03],TAMSX3("B1_COD")[01],TAMSX3("B1_COD")[02]})
Aadd(aStruTRB,{"B1_DESC" ,TAMSX3("B1_DESC")[03],TAMSX3("B1_DESC")[01],TAMSX3("B1_DESC")[02]})
Aadd(aStruTRB,{"B1_CUSTD",TAMSX3("B1_CUSTD")[03],TAMSX3("B1_CUSTD")[01],TAMSX3("B1_CUSTD")[02]})
Aadd(aStruTRB,{"B1_CUSDEXE",TAMSX3("B1_CUSDEXE")[03],TAMSX3("B1_CUSDEXE")[01],TAMSX3("B1_CUSDEXE")[02]})      
Aadd(aStruTRB,{"B1_YFATOR",TAMSX3("B1_YFATOR")[03],TAMSX3("B1_YFATOR")[01],TAMSX3("B1_YFATOR")[02]})
Aadd(aStruTRB,{"B1_FATEXCE",TAMSX3("B1_FATEXCE")[03],TAMSX3("B1_FATEXCE")[01],TAMSX3("B1_FATEXCE")[02]})      
Aadd(aStruTRB,{"B1_GRUPO"	,TAMSX3("B1_GRUPO")[03],TAMSX3("B1_GRUPO")[01],TAMSX3("B1_GRUPO")[02]})
//Aadd(aStruTRB,{"B1_DESCGRU",TAMSX3("B1_DESCGRU")[03],TAMSX3("B1_DESCGRU")[01],TAMSX3("B1_DESCGRU")[02]})      
//Aadd(aStruTRB,{"B1_YREF",TAMSX3("B1_YREF")[03],TAMSX3("B1_YREF")[01],TAMSX3("B1_YREF")[02]})      
Aadd(aStruTRB,{"B1_YFATOR2",TAMSX3("B1_YFATOR2")[03],TAMSX3("B1_YFATOR2")[01],TAMSX3("B1_YFATOR2")[02]})      
Aadd(aStruTRB,{"B1_YFATOR3",TAMSX3("B1_YFATOR3")[03],TAMSX3("B1_YFATOR3")[01],TAMSX3("B1_YFATOR3")[02]})
Aadd(aStruTRB,{"B1_ZFINTER",TAMSX3("B1_ZFINTER")[03],TAMSX3("B1_ZFINTER")[01],TAMSX3("B1_ZFINTER")[02]})      
//Aadd(aStruTRB,{"B1_YUSU",TAMSX3("B1_YUSU")[03],TAMSX3("B1_YUSU")[01],TAMSX3("B1_YUSU")[02]})      

cIndeTRB  := "B1_GRUPO+B1_COD"
cArqTrTRB := CriaTrab(aStruTRB,.T.)

dbUseArea(.T.,,cArqTrTRB,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrTRB,cIndeTRB,,,"Selecionando registros...")

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FGrTrbIm
Grava o Arquivo de Trabalho de Importação.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FGrTrbIm()

Local pUsaCab		:= .F.
Local cLinha		:= {}
Local aCSV			:= {}
Local cCab			:= ""
Local cCodInv		:= ""
Local cTeste		:= ""
Local cNewCod		:= ""   
Local cCodProd 	:= ""
Local i				:= 0
Local nPos			:= 0
Local nCols			:= 0
Local nCustNew		:= 0
Local nFIntraNew	:= 0
Local nFInterNew	:= 0 

Default pUsaCab	:= .F.  

_NomeUser := AllTrim(SubStr(cUsuario,7,15))
pMatriz	 := {}
   
If (!File(cArq))
	ApMsgInfo("Arquivo em Branco, Favor Verificar.")
	Return(Nil)
EndIf
	
FT_FUse(cArq)	//Abrindo o arquivo quando passando como parâmetro
FT_FGoTop() 	//Vai para o primeiro registro do arquivo
   
//Capturando as linhas do arquivo
While (!FT_FEoF())

	If (Empty(cCab))
		cCab := FT_FREADLN()
	EndIf
		
	If (pUsaCab)
		AADD(aCSV,FT_FREADLN())
	ElseIf (!pUsaCab) .And. (i > 2)
		AADD(aCSV,FT_FREADLN())     
	EndIf

	I++

	FT_FSkip()

EndDo
	
FT_FUSE() 			// Libera arquivo quando não passado nenhum prâmetro
	
//Pegando o numero de colunas com base no cabecalho
For xI := 1 To Len(cCab)
	nPos := At(";",cCab)
	If (nPos > 0)
		nCols += 1
		cCab := SubStr(cCab,nPos + 1,Len(cCab) - nPos)
	EndIf
Next xI 
	
//Definindo o tamanho da Matriz que recebera os dados
pMatriz := Array(Len(aCSV),nCols + 1)
	
//Carregando os dados
For xI := 1 To Len(aCSV)
	cLinha := aCSV   // Fazendo referência ao array aCSV
	For xJ := 1 To nCols + 1
		nPos := At(";",cLinha[xI])
		If (nPos > 0)
			pMatriz[xI,xJ] := AllTrim(SubStr(cLinha[xI],1,nPos - 1))   			// Pega o código e a descrição do array cLinha
			cLinha[xI] := SubStr(cLinha[xI],nPos + 1,Len(cLinha[xI]) - nPos)  	// recebe o conteúdo menos a parte do código
		Else
			pMatriz[xI,xJ] := AllTrim(cLinha[xI])
		Endif
	Next xJ
Next xI 
	
dbSelectArea("TRB")
	
For xI := 1 to Len(pMatriz)

	IncProc("Processando Custo Fator: " + AllTrim(pMatriz[xI,01]))

	For xJ := 1 To Len(pMatriz[xI,01])
		If LetterOrNum(SubStr(pMatriz[xI,01],xJ,1))			// Verifica se os caracteres sao Letras ou Numeros (codigo sendo gravado com espaco que AllTim() nao eliminava)
			cNewCod += SubStr(pMatriz[xI,01],xJ,1)  		// Pega o código do produto
		EndIf
	Next xJ
   //	pMatriz[xI,01] := AllTrim(StrZero(Val(cNewCod),8)) 		// Verifica se o codigo possui 6 caracteres, completa com zero a esquerda caso nao possua e retorna para pMatriz[xI,01]
	cNewCod := ""

	If ! dbSeek(xFilial("TRB")+pMatriz[xI,07]+pMatriz[xI,01]) 

	   nCustNew		:=	Val(strtran(strtran(pMatriz[xI,04],'"',""),",","."))	// 04 -> CUSTO DO PRODUTO -- Tratamento para retirar aspas duplas e substituir virgula por ponto
	   nFIntraNew	:= Val(strtran(strtran(pMatriz[xI,06],'"',""),",","."))	// 06 -> FATOR DO PRODUTO  -- Tratamento para retirar aspas duplas e substituir virgula por ponto
	   nFInterNew	:= Val(strtran(strtran(pMatriz[xI,09],'"',""),",","."))	// 10 -> FATOR INTERMUNICIPAL	"Outro Estado" -- Tratamento para retirar aspas duplas e substituir virgula por ponto

	   If nCustNew <> 0
     
			If nCustNew > 9999999.99 .Or. nFIntraNew > 99.99 .Or. nFInterNew > 99.99
				cCodProd += pMatriz[xI,01] + " <-> " 				
				nCustNew	:= 0
				nFIntraNew	:= 0
				nFInterNew	:= 0   
			EndIf			
//            Alert(pMatriz[xI,01])
			RecLock("TRB",.T.)
			TRB->B1_COD := pMatriz[xI,01]
			TRB->B1_DESC := pMatriz[xI,02]
			TRB->B1_CUSTD := Val(strtran(strtran(pMatriz[xI,03],'"',""),",","."))
			TRB->B1_CUSDEXE := nCustNew
			TRB->B1_YFATOR := Val(strtran(strtran(pMatriz[xI,05],'"',""),",","."))
			TRB->B1_FATEXCE := nFIntraNew
			TRB->B1_GRUPO := pMatriz[xI,07]
			//TRB->B1_DESCGRU := pMatriz[xI,08]
			//TRB->B1_YREF := pMatriz[xI,09]
			TRB->B1_YFATOR2 := Val(strtran(strtran(pMatriz[xI,08],'"',""),",","."))
			TRB->B1_YFATOR3 := Val(strtran(strtran(pMatriz[xI,10],'"',""),",","."))
			TRB->B1_ZFINTER := nFInterNew
			//TRB->B1_YUSU := _NomeUser
			MsUnLock() 	

		EndIf

	Else
		cCodInv += pMatriz[xI,01] + " <-> "   // Códigos não encontrados
	EndIf

Next xI   

If ! Empty(cCodProd)     
	MSGInfo(	"Os Valores de 'Custo Novo' e/ou 'Fator Intra Novo' e/ou 'Fator Inter Novo' " + Chr(13) + Chr(10) + ;						 
				"para o(s) produto(s): " + cCodProd + Chr(13) + Chr(10) + ;
				" Estão acima do permitido e foram gravados com o valor => 0 'Zero'")
EndIf
	
If cCodInv <> ""
	cCodInv := AllTrim(SubStr(cCodInv,1,(Len(cCodInv) - 1)))
	ApMsgInfo("Os seguintes produtos nao existiam na tabela:" + Chr(13) + Chr(10) + AllTrim(cCodInv),"Produtos nao localizados")
EndIf
	
Return(Nil)



//-------------------------------------------------------------------
/*/{Protheus.doc} FTelGrIm
Tela de Importação com os produtos que seram atualizados.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FTelGrIm()

Local lInvLib     := .F.
Local cMarcAlt    := GetMark()

Private lSaiTela    := .T.

Private oDlgMark,oBtn,cIndSA3,cFiltro,oGrpArqs,oListArq

Private oBTn1,oBTn2,oBTn3,oGrpMark

Private aTamTela  := {001,001,550,1100}

Private aTGrArqs  := {001,005,250,550}
Private aTLBxArq  := {010,010,245,545}

Private aPosBTn1	:= {255,480}
Private aPosBTn2	:= {255,510}

Private aCampTRB1 := {}

AADD(aCampTRB1,{"B1_GRUPO"		,,AllTrim(RetTitle("B1_GRUPO"))		,PesqPict("SB1","B1_GRUPO")})
//AADD(aCampTRB1,{"B1_DESCGRU"	,,AllTrim(RetTitle("B1_DESCGRU"))	,PesqPict("SB1","B1_DESCGRU")})
AADD(aCampTRB1,{"B1_COD"		,,AllTrim(RetTitle("B1_COD"))			,PesqPict("SB1","B1_COD")})
AADD(aCampTRB1,{"B1_DESC"		,,AllTrim(RetTitle("B1_DESC"))		,PesqPict("SB1","B1_DESC")})
AADD(aCampTRB1,{"B1_CUSTD"		,,AllTrim(RetTitle("B1_CUSTD"))		,PesqPict("SB1","B1_CUSTD")})
AADD(aCampTRB1,{"B1_CUSDEXE"	,,AllTrim(RetTitle("B1_CUSDEXE"))	,PesqPict("SB1","B1_CUSDEXE")})
AADD(aCampTRB1,{"B1_YFATOR"	,,AllTrim(RetTitle("B1_YFATOR"))		,PesqPict("SB1","B1_YFATOR")})
AADD(aCampTRB1,{"B1_FATEXCE"	,,AllTrim(RetTitle("B1_FATEXCE"))	,PesqPict("SB1","B1_FATEXCE")})
//AADD(aCampTRB1,{"B1_YREF"		,,AllTrim(RetTitle("B1_YREF"))		,PesqPict("SB1","B1_YREF")})
AADD(aCampTRB1,{"B1_YFATOR2"	,,AllTrim(RetTitle("B1_YFATOR2"))	,PesqPict("SB1","B1_YFATOR2")})
AADD(aCampTRB1,{"B1_YFATOR3"	,,AllTrim(RetTitle("B1_YFATOR3"))	,PesqPict("SB1","B1_YFATOR3")})
AADD(aCampTRB1,{"B1_ZFINTER"	,,AllTrim(RetTitle("B1_ZFINTER"))	,PesqPict("SB1","B1_ZFINTER")})

TRB->(dbGoTop())    


While lSaiTela

   Define MSDialog oDlgMark Title OemToAnsi("Selecao de Produtos") From aTamTela[01],aTamTela[02] TO aTamTela[03],aTamTela[04] Pixel

   oGrpArqs := TGroup():New(aTGrArqs[01],aTGrArqs[02],aTGrArqs[03],aTGrArqs[04],OemToAnsi("Produtos para Importar"),,CLR_HBLUE,,.T.)

   oMarkArq := MsSelect():New("TRB",,,aCampTRB1,lInvLib,cMarcAlt,aTLBxArq)
   oMarkArq:oBrowse:lCanAllMark := .T.
   oMarkArq:oBrowse:lHasMark    := .T.
   oMarkArq:oBrowse:bChange     := {|| }
   oMarkArq:bMark               := {|| }
   oMarkArq:oBrowse:bAllMark    := {|| }

   Define SButton oBTn1 From aPosBTn1[01],aPosBTn1[02] Type 01 Action Processa({|| FGrvProd(), FCancela()}) Enable Of oDlgMark
   Define SButton oBTn2 From aPosBTn2[01],aPosBTn2[02] Type 02 Action FCancela()  Enable Of oDlgMark

   oMarkArq:oBrowse:Refresh()
   oDlgMark:Refresh()

   Activate MSDialog oDlgMark Centered

EndDo

If Select("TRB") > 0
   dbselectArea("TRB")
   dbCloseArea()
EndIf

Return()



//-------------------------------------------------------------------
/*/{Protheus.doc} FGrvProd
Grava o Cadastro de Produto.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FGrvProd()

dbSelectArea("TRB")
dbGoTop()

ProcRegua(RecCount())

While TRB->(! Eof())

	IncProc()
//Alert('|'+ALLTRIM(TRB->B1_COD)+'|')
	DbSelectArea("SB1")
	DbSetOrder(1)
	If DbSeek(xFilial("SB1")+SUBSTR(ALLTRIM(TRB->B1_COD),2,14))
		If	Reclock("SB1",.F.)
			SB1->B1_CUSDEXE	:= TRB->B1_CUSDEXE
			SB1->B1_FATEXCE	:= TRB->B1_FATEXCE
 			SB1->B1_ZFINTER	:= TRB->B1_ZFINTER
			SB1->B1_CUSTD 	:=	TRB->B1_CUSDEXE
			SB1->B1_YFATOR	:=	TRB->B1_FATEXCE
			SB1->B1_YFATOR2	:=	TRB->B1_ZFINTER
			SB1->B1_YFATOR3	:=	TRB->B1_YFATOR3
			//SB1->B1_YUSU		:=	TRB->B1_YUSU
			SB1->(MsUnlock())
		EndIf
	EndIf

	dbSelectArea("TRB")
   TRB->(dbSkip())

EndDo

Return Nil



//-------------------------------------------------------------------
/*/{Protheus.doc} FExpCust
Função para Exportação dos Dados.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FExpCust()

Local lInvLib     := .F.
Local cMarcAlt    := GetMark()

Private lSaiTela    := .T.

Private oDlgMark,oBtn,cIndSA3,cFiltro,oGrpArqs,oListArq

Private oBTn1,oBTn2,oBTn3,oGrpMark

Private aTamTela  := {001,001,550,1100}

Private aTGrMark  := {001,005,250,150}
Private aTamMBro  := {010,010,245,145}

Private aTGrArqs  := {001,155,250,550}
Private aTLBxArq  := {010,160,245,545}

Private aPosBTn1	:= {255,480}
Private aPosBTn2	:= {255,510}

Private aCampTRBM := {}
Private aCampTRB1 := {}

AADD(aCampTRBM,{"BM_OK"   ,,"OK"                         ,PesqPict("SE1","E1_OK")})
AADD(aCampTRBM,{"BM_GRUPO",,AllTrim(RetTitle("BM_GRUPO")),PesqPict("SBM","BM_GRUPO")})
AADD(aCampTRBM,{"BM_DESC" ,,AllTrim(RetTitle("BM_DESC")) ,PesqPict("SBM","BM_DESC")})

AADD(aCampTRB1,{"B1_OK"			,,"OK"								,PesqPict("SE1","E1_OK")})
AADD(aCampTRB1,{"B1_COD"		,,AllTrim(RetTitle("B1_COD"))		,PesqPict("SB1","B1_COD")})
AADD(aCampTRB1,{"B1_DESC"		,,AllTrim(RetTitle("B1_DESC"))		,PesqPict("SB1","B1_DESC")})
AADD(aCampTRB1,{"B1_CUSTD"		,,AllTrim(RetTitle("B1_CUSTD"))		,PesqPict("SB1","B1_CUSTD")})
AADD(aCampTRB1,{"B1_CUSDEXE"	,,AllTrim(RetTitle("B1_CUSDEXE"))	,PesqPict("SB1","B1_CUSDEXE")})
AADD(aCampTRB1,{"B1_YFATOR"		,,AllTrim(RetTitle("B1_YFATOR"))	,PesqPict("SB1","B1_YFATOR")})
AADD(aCampTRB1,{"B1_FATEXCE"	,,AllTrim(RetTitle("B1_FATEXCE"))	,PesqPict("SB1","B1_FATEXCE")})
AADD(aCampTRB1,{"B1_GRUPO"		,,AllTrim(RetTitle("B1_GRUPO"))		,PesqPict("SB1","B1_GRUPO")})
//AADD(aCampTRB1,{"B1_DESCGRU"	,,AllTrim(RetTitle("B1_DESCGRU"))	,PesqPict("SB1","B1_DESCGRU")})
//AADD(aCampTRB1,{"B1_YREF"		,,AllTrim(RetTitle("B1_YREF"))		,PesqPict("SB1","B1_YREF")})
AADD(aCampTRB1,{"B1_YFATOR2"	,,AllTrim(RetTitle("B1_YFATOR2"))	,PesqPict("SB1","B1_YFATOR2")})
AADD(aCampTRB1,{"B1_YFATOR3"	,,AllTrim(RetTitle("B1_YFATOR3"))	,PesqPict("SB1","B1_YFATOR3")})
AADD(aCampTRB1,{"B1_ZFINTER"	,,AllTrim(RetTitle("B1_ZFINTER"))	,PesqPict("SB1","B1_ZFINTER")})
AADD(aCampTRB1,{"B1_OKK"		,,AllTrim(RetTitle("B1_OKK"))		,PesqPict("SB1","B1_OKK")})

FCrTrbA3()

MsgRun("Selecionando Dados....","Por favor, aguarde",{|| FQryCon()})

TRBM->(dbGoTop())

While lSaiTela

   Define MSDialog oDlgMark Title OemToAnsi("Selecao de Produtos") From aTamTela[01],aTamTela[02] TO aTamTela[03],aTamTela[04] Pixel

   oGrpMark := TGroup():New(aTGrMark[01],aTGrMark[02],aTGrMark[03],aTGrMark[04],OemToAnsi("Marque os Grupos."),,CLR_HBLUE,,.T.)

   oMarkAlt := MsSelect():New("TRBM","BM_OK",,aCampTRBM,lInvLib,cMarcAlt,aTamMBro)
   oMarkAlt:oBrowse:lCanAllMark := .T.
   oMarkAlt:oBrowse:lHasMark    := .T.
   oMarkAlt:oBrowse:bChange     := {|| FAltArqs("T",cMarcAlt,lInvLib,oDlgMark)}
   oMarkAlt:bMark               := {|| FAltEsco(cMarcAlt,lInvLib,oDlgMark)}
   oMarkAlt:oBrowse:bAllMark    := {|| FAltMarkAll(cMarcAlt,lInvLib,oDlgMark)}

   oGrpArqs := TGroup():New(aTGrArqs[01],aTGrArqs[02],aTGrArqs[03],aTGrArqs[04],OemToAnsi("Marque os Produtos para Importar"),,CLR_HBLUE,,.T.)

   oMarkArq := MsSelect():New("TRB1","B1_OK",,aCampTRB1,lInvLib,cMarcAlt,aTLBxArq)
   oMarkArq:oBrowse:lCanAllMark := .T.
   oMarkArq:oBrowse:lHasMark    := .T.
   oMarkArq:bMark               := {|| FAlEsArq(cMarcAlt,lInvLib,oDlgMark)}
   oMarkArq:oBrowse:bAllMark    := {|| FAlMarAlArq(cMarcAlt,oDlgMark,cMarcAlt)}

   Define SButton oBTn1 From aPosBTn1[01],aPosBTn1[02] Type 01 Action Processa({|| FSEXP(), FCancela()}) Enable Of oDlgMark
   Define SButton oBTn2 From aPosBTn2[01],aPosBTn2[02] Type 02 Action FCancela()  Enable Of oDlgMark

   oMarkAlt:oBrowse:Refresh()
   oMarkArq:oBrowse:Refresh()
   oDlgMark:Refresh()

   Activate MSDialog oDlgMark Centered

EndDo

If Select("TRBM") > 0
   dbselectArea("TRBM")
   dbCloseArea()
EndIf

If Select("TRB1") > 0
   dbselectArea("TRB1")
   dbCloseArea()
EndIf

If Select("TRB") > 0
   dbselectArea("TRB")
   dbCloseArea()
EndIf

Return()



//-------------------------------------------------------------------
/*/{Protheus.doc} FQryCon
Função para Consulta ao Banco de Dados.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FQryCon()

U_FCloseArea("QSBM") 
	
cQuery1 := "SELECT BM_FILIAL, BM_GRUPO, BM_DESC FROM " + RetSqlName("SBM") + " SBM "
cQuery1 += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON (SB1.D_E_L_E_T_ = ' ' AND B1_FILIAL = '" + xFilial("SB1")+"' AND B1_GRUPO = BM_GRUPO AND B1_MSBLQL <> '1') "
cQuery1 += "WHERE SBM.D_E_L_E_T_ = ' ' AND BM_FILIAL = '" + xFilial("SBM") + "' "
cQuery1 += "GROUP BY BM_FILIAL, BM_GRUPO, BM_DESC "
cQuery1 += "ORDER BY 1"
TCQUERY cQuery1 ALIAS "QSBM" NEW 
	
dbSelectArea("QSBM")
QSBM->(dbGoTop())

If ! QSBM->(Eof())	

	U_FCloseArea("QSB1") 

	cQuery := "SELECT B1_COD,B1_DESC,B1_CUSTD,B1_CUSDEXE,B1_YFATOR,B1_FATEXCE,B1_YFATOR2,B1_YFATOR3,B1_ZFINTER,B1_GRUPO,B1_OKK "
	cQuery += "FROM " + RetSqlName("SB1") + " SB1 " 
	cQuery += "WHERE SB1.D_E_L_E_T_ =  ' '  AND B1_FILIAL = '" + xFilial("SB1") + "' AND "  
	cQuery += " SB1.B1_GRUPO = '"+QSBM->BM_GRUPO+"'  AND SB1.B1_MSBLQL <> '1' " 
	cQuery += "ORDER BY B1_COD "

	TCQUERY cQuery ALIAS "QSB1" NEW
	
	dbSelectArea("QSB1")
	QSB1->(dbGoTop())
   
	If ! QSB1->(Eof())
		FGrDadTR()
	EndIf
	
EndIf

U_FCloseArea("QSBM") 

U_FCloseArea("QSB1") 

Return Nil



//-------------------------------------------------------------------
/*/{Protheus.doc} FGrDadTR
Função para Gravação dos Dados nos arquivos da Tela de seleção.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FGrDadTR()

QSBM->(dbGoTop())

While QSBM->(! Eof())

	dbSelectArea("TRBM")
	dbSeek(QSBM->BM_GRUPO)
	If TRBM->(Eof())
		RecLock("TRBM",.T.)
	Else
		RecLock("TRBM",.F.)
	EndIf
	TRBM->BM_GRUPO	:= QSBM->BM_GRUPO
	TRBM->BM_DESC	:= QSBM->BM_DESC
	MsUnlock()

	dbSelectArea("QSBM")
	QSBM->(dbSkip())
	
EndDo

dbSelectArea("QSB1")
QSB1->(dbGoTop())

While QSB1->(! Eof())

	dbSelectArea("TRB1")
	dbSeek(QSB1->B1_COD)
	If TRB1->(Eof())
		RecLock("TRB1",.T.)
	Else
		RecLock("TRB1",.F.)
	EndIf
	TRB1->B1_COD		:= QSB1->B1_COD
	TRB1->B1_DESC		:= QSB1->B1_DESC
	TRB1->B1_CUSTD		:= QSB1->B1_CUSTD
	TRB1->B1_CUSDEXE	:= QSB1->B1_CUSDEXE
	TRB1->B1_YFATOR	:= QSB1->B1_YFATOR
	TRB1->B1_FATEXCE	:= QSB1->B1_FATEXCE
	TRB1->B1_GRUPO		:= QSB1->B1_GRUPO
//	TRB1->B1_DESCGRU	:= QSB1->B1_DESCGRU
//	TRB1->B1_YREF		:= QSB1->B1_YREF
	TRB1->B1_YFATOR2	:= QSB1->B1_YFATOR2
	TRB1->B1_YFATOR3	:= QSB1->B1_YFATOR3
	TRB1->B1_ZFINTER	:= QSB1->B1_ZFINTER
	TRB1->B1_OKK		:= Iif(QSB1->B1_OKK=="F",.F.,.T.)
	MsUnlock()

	dbSelectArea("QSB1")
	QSB1->(dbSkip())

EndDo

Return 



//-------------------------------------------------------------------
/*/{Protheus.doc} FCancela
Função para Cancelamento da Tela de Exportação.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FCancela()

lSaiTela := .F.
oDlgMark:End()
oDlg8:End()

Return()



//-------------------------------------------------------------------
/*/{Protheus.doc} FCrTrbA3
Funcao para Criacao do Arquivo de Trabalho.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FCrTrbA3()

Local cIndeSBM := ""
Local cIndeTRB := ""
Local cIndeSB1 := ""

Private aStruSB1  := {}
Private aStruSBM  := {}
Private aStruTRB  := {}

Private cArqTrbBM := ""
Private cArqTrSB1 := ""
Private cArqTrTRB := ""

If Select("TRBM") <> 0
   dbSelectArea("TRBM")
   dbCloseArea()
EndIf

aStruSBM := {}
Aadd(aStruSBM,{"BM_OK"		,TAMSX3("E1_OK")[03]			,TAMSX3("E1_OK")[01]			,TAMSX3("E1_OK")[02]})
Aadd(aStruSBM,{"BM_GRUPO"	,TAMSX3("BM_GRUPO")[03]		,TAMSX3("BM_GRUPO")[01]		,TAMSX3("BM_GRUPO")[02]})
Aadd(aStruSBM,{"BM_DESC"	,TAMSX3("BM_DESC")[03]		,TAMSX3("BM_DESC")[01]		,TAMSX3("BM_DESC")[02]})

cIndeSBM  := "BM_GRUPO"
cArqTrbBM := CriaTrab(aStruSBM,.T.)

dbUseArea(.T.,,cArqTrbBM,"TRBM",.F.,.F.)
IndRegua("TRBM",cArqTrbBM,cIndeSBM,,,"Selecionando registros...")

If Select("TRB1") <> 0
   dbSelectArea("TRB1")
   dbCloseArea()
EndIf

aStruSB1 := {}
Aadd(aStruSB1,{"B1_OK"			,TAMSX3("E1_OK")[03]			,TAMSX3("E1_OK")[01]			,TAMSX3("E1_OK")[02]})
Aadd(aStruSB1,{"B1_COD"			,TAMSX3("B1_COD")[03]		,TAMSX3("B1_COD")[01]		,TAMSX3("B1_COD")[02]})
Aadd(aStruSB1,{"B1_DESC"		,TAMSX3("B1_DESC")[03]		,TAMSX3("B1_DESC")[01]		,TAMSX3("B1_DESC")[02]})
Aadd(aStruSB1,{"B1_CUSTD"		,TAMSX3("B1_CUSTD")[03]		,TAMSX3("B1_CUSTD")[01]		,TAMSX3("B1_CUSTD")[02]})
Aadd(aStruSB1,{"B1_CUSDEXE"	,TAMSX3("B1_CUSDEXE")[03]	,TAMSX3("B1_CUSDEXE")[01]	,TAMSX3("B1_CUSDEXE")[02]})
Aadd(aStruSB1,{"B1_YFATOR"		,TAMSX3("B1_YFATOR")[03]	,TAMSX3("B1_YFATOR")[01]	,TAMSX3("B1_YFATOR")[02]})
Aadd(aStruSB1,{"B1_FATEXCE"	,TAMSX3("B1_FATEXCE")[03]	,TAMSX3("B1_FATEXCE")[01]	,TAMSX3("B1_FATEXCE")[02]})
Aadd(aStruSB1,{"B1_GRUPO"		,TAMSX3("B1_GRUPO")[03]		,TAMSX3("B1_GRUPO")[01]		,TAMSX3("B1_GRUPO")[02]})
//Aadd(aStruSB1,{"B1_DESCGRU"	,TAMSX3("B1_DESCGRU")[03]	,TAMSX3("B1_DESCGRU")[01]	,TAMSX3("B1_DESCGRU")[02]})
//Aadd(aStruSB1,{"B1_YREF"		,TAMSX3("B1_YREF")[03]		,TAMSX3("B1_YREF")[01]		,TAMSX3("B1_YREF")[02]})
Aadd(aStruSB1,{"B1_YFATOR2"	,TAMSX3("B1_YFATOR2")[03]	,TAMSX3("B1_YFATOR2")[01]	,TAMSX3("B1_YFATOR2")[02]})
Aadd(aStruSB1,{"B1_YFATOR3"	,TAMSX3("B1_YFATOR3")[03]	,TAMSX3("B1_YFATOR3")[01]	,TAMSX3("B1_YFATOR3")[02]})
Aadd(aStruSB1,{"B1_ZFINTER"	,TAMSX3("B1_ZFINTER")[03]	,TAMSX3("B1_ZFINTER")[01]	,TAMSX3("B1_ZFINTER")[02]})
Aadd(aStruSB1,{"B1_OKK"			,TAMSX3("B1_OKK")[03]		,TAMSX3("B1_OKK")[01]		,TAMSX3("B1_OKK")[02]})

cIndeSB1  := "B1_COD"
cArqTrSB1 := CriaTrab(aStruSB1,.T.)

dbUseArea(.T.,,cArqTrSB1,"TRB1",.F.,.F.)
IndRegua("TRB1",cArqTrSB1,cIndeSB1,,,"Selecionando registros...")

If Select("TRB") <> 0
   dbSelectArea("TRB")
   dbCloseArea()
EndIf

aStruTRB := {}
Aadd(aStruTRB,{"BM_GRUPO",TAMSX3("BM_GRUPO")[03],TAMSX3("BM_GRUPO")[01],TAMSX3("BM_GRUPO")[02]})
Aadd(aStruTRB,{"B1_COD"	 ,TAMSX3("B1_COD")[03],TAMSX3("B1_COD")[01],TAMSX3("B1_COD")[02]})
Aadd(aStruTRB,{"B1_DESC" ,TAMSX3("B1_DESC")[03],TAMSX3("B1_DESC")[01],TAMSX3("B1_DESC")[02]})
Aadd(aStruTRB,{"B1_CUSTD",TAMSX3("B1_CUSTD")[03],TAMSX3("B1_CUSTD")[01],TAMSX3("B1_CUSTD")[02]})
Aadd(aStruTRB,{"B1_YFATOR",TAMSX3("B1_YFATOR")[03],TAMSX3("B1_YFATOR")[01],TAMSX3("B1_YFATOR")[02]})
//Aadd(aStruTRB,{"B1_DESCGRU",TAMSX3("B1_DESCGRU")[03],TAMSX3("B1_DESCGRU")[01],TAMSX3("B1_DESCGRU")[02]})      
//Aadd(aStruTRB,{"B1_YREF",TAMSX3("B1_YREF")[03],TAMSX3("B1_YREF")[01],TAMSX3("B1_YREF")[02]})      
Aadd(aStruTRB,{"B1_YFATOR2",TAMSX3("B1_YFATOR2")[03],TAMSX3("B1_YFATOR2")[01],TAMSX3("B1_YFATOR2")[02]})      
Aadd(aStruTRB,{"B1_YFATOR3",TAMSX3("B1_YFATOR3")[03],TAMSX3("B1_YFATOR3")[01],TAMSX3("B1_YFATOR3")[02]})      

cIndeTRB  := "BM_GRUPO+B1_COD"
cArqTrTRB := CriaTrab(aStruTRB,.T.)

dbUseArea(.T.,,cArqTrTRB,"TRB",.F.,.F.)
IndRegua("TRB",cArqTrTRB,cIndeTRB,,,"Selecionando registros...")

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FAltArqs
Funcao para tratamento da Seleção produtos na movimentação dos grupos..

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		cTipPar1
				cMarcAlt
				lInvLib
				oDlgMark
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FAltArqs(cTipPar1,cMarcAlt,lInvLib,oDlgMark)

dbSelectArea("TRB1")
dbGoTop()
If ! Eof()
   ZAP
EndIf

U_FCloseArea("QSB1") 

cQuery := "SELECT B1_COD,B1_DESC,B1_CUSTD,B1_CUSDEXE,B1_YFATOR,B1_FATEXCE,B1_YFATOR2,B1_YFATOR3,B1_ZFINTER,B1_GRUPO,B1_OKK "
cQuery += "FROM " + RetSqlName("SB1") + " SB1 " 
cQuery += "WHERE SB1.D_E_L_E_T_ =  ' '  AND B1_FILIAL = '" + xFilial("SB1") + "' AND "  
cQuery += " SB1.B1_GRUPO = '"+TRBM->BM_GRUPO+"'  AND SB1.B1_MSBLQL <> '1' " 
cQuery += "ORDER BY B1_COD "

TCQUERY cQuery ALIAS "QSB1" NEW

dbSelectArea("QSB1")
QSB1->(dbGoTop())

While QSB1->(! Eof())

	dbSelectArea("TRB")
   dbSeek(QSB1->B1_GRUPO+QSB1->B1_COD)

	dbSelectArea("TRB1")
	dbSeek(QSB1->B1_COD)
	If TRB1->(Eof())
		RecLock("TRB1",.T.)
	Else
		RecLock("TRB1",.F.)
	EndIf
	TRB1->B1_COD		:= QSB1->B1_COD
	TRB1->B1_DESC		:= QSB1->B1_DESC
	TRB1->B1_CUSTD		:= QSB1->B1_CUSTD
	TRB1->B1_CUSDEXE	:= QSB1->B1_CUSDEXE
	TRB1->B1_YFATOR	:= QSB1->B1_YFATOR
	TRB1->B1_FATEXCE	:= QSB1->B1_FATEXCE
	TRB1->B1_GRUPO		:= QSB1->B1_GRUPO
 //	TRB1->B1_DESCGRU	:= QSB1->B1_DESCGRU
 //	TRB1->B1_YREF		:= QSB1->B1_YREF
	TRB1->B1_YFATOR2	:= QSB1->B1_YFATOR2
	TRB1->B1_YFATOR3	:= QSB1->B1_YFATOR3
	TRB1->B1_ZFINTER	:= QSB1->B1_ZFINTER
	TRB1->B1_OKK		:= Iif(QSB1->B1_OKK=="F",.F.,.T.)
	If TRB->(! Eof())
		TRB1->B1_OK		:= cMarcAlt
	EndIf
	MsUnlock()

	dbSelectArea("QSB1")
	QSB1->(dbSkip())

EndDo

U_FCloseArea("QSB1") 

dbSelectArea("TRB1")
dbGoTop()

If cTipPar1 == "T"
   oMarkAlt:oBrowse:Refresh()
   oMarkArq:oBrowse:Refresh()
   oDlgMark:Refresh()
EndIf

Return()

      

//-------------------------------------------------------------------
/*/{Protheus.doc} FAltEsco
Funcao para tratamento da alteração da seleção de apenas um registro do Grupo

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		cMarcAlt - 
				lInvLib  - 
				oDlgMark - 
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FAltEsco(cMarcAlt,lInvLib,oDlgMark)

Local lRetFunc := .T.

If ! Empty(TRBM->BM_OK)
   RecLock("TRBM",.F.)
   If ! lInvLib
      Replace BM_OK With cMarcAlt
   Else
      Replace BM_OK With "  "
   Endif
   MsUnlock()
Else
   RecLock("TRBM",.F.)
   If ! lInvLib
      Replace BM_OK With "  "
   Else
      Replace BM_OK With cMarcAlt
   Endif
   MsUnlock()
EndIf

dbSelectArea("TRB1")
TRB1->(dbGoTop())

While TRB1->(! Eof())

   RecLock("TRB1",.F.)
   Replace TRB1->B1_OK  With TRBM->BM_OK
   MsUnlock()

	dbSelectArea("TRB")
	dbSeek(TRBM->BM_GRUPO+TRB1->B1_COD)

	If Empty(TRBM->BM_OK) .And. TRB->(! Eof())
		RecLock("TRB",.F.)
		dbDelete()
		MsUnLock() 	
	ElseIf ! Empty(TRBM->BM_OK) .And. TRB->(Eof()) 
		RecLock("TRB",.T.)
      TRB->BM_GRUPO := TRBM->BM_GRUPO
      TRB->B1_COD := TRB1->B1_COD
      TRB->B1_DESC := TRB1->B1_DESC
      TRB->B1_CUSTD := TRB1->B1_CUSTD
      TRB->B1_YFATOR := TRB1->B1_YFATOR
    //  TRB->B1_DESCGRU := TRB1->B1_DESCGRU
     // TRB->B1_YREF := TRB1->B1_YREF
      TRB->B1_YFATOR2 := TRB1->B1_YFATOR2
      TRB->B1_YFATOR3 := TRB1->B1_YFATOR3
		MsUnLock() 	
	EndIf

   dbSelectArea("TRB1")
   dbSkip()

EndDo

dbSelectArea("TRB1")
dbGoTop()

dbSelectArea("TRBM")
oMarkAlt:oBrowse:Refresh()
oMarkArq:oBrowse:Refresh()
oDlgMark:Refresh()

Return(lRetFunc)



//-------------------------------------------------------------------
/*/{Protheus.doc} FAltMarkAll
Funcao para tratativa de seleção de todos os registros do Grupo

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		cMarcAlt - 
				lInvLib  - 
				oDlgMark - 
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FAltMarkAll(cMarcAlt,lInvLib,oDlgMark)

Local lRetFunc := .T.
Local nRecno   := 0
Local cGrpMar  := "'"
Local aGrpDMa	:= {}

dbSelectArea("TRBM")
nRecno := Recno()
dbGotop()

While ! Eof()

   RecLock("TRBM",.F.)
   If ! Marked("BM_OK")
      Replace BM_OK With cMarcAlt
		cGrpMar += TRBM->BM_GRUPO+"','"
   Else
      Replace BM_OK With "  "
		aadd(aGrpDMa,TRBM->BM_GRUPO)
   Endif
   MsUnlock()

   dbSelectArea("TRBM")
   dbSkip()

EndDo

dbSelectArea("TRBM")
dbGoto(nRecno)

cGrpMar := AllTrim(cGrpMar)

If Len(cGrpMar) > 1

	If Right(cGrpMar,2) == ",'"
		cGrpMar := Left(cGrpMar,Len(cGrpMar)-2)
	EndIf

	U_FCloseArea("QSB1") 

	cQuery := "SELECT B1_COD,B1_DESC,B1_CUSTD,B1_CUSDEXE,B1_YFATOR,B1_FATEXCE,B1_YFATOR2,B1_YFATOR3,B1_ZFINTER,B1_GRUPO,B1_OKK "
	cQuery += "FROM " + RetSqlName("SB1") + " SB1 " 
	cQuery += "WHERE SB1.D_E_L_E_T_ =  ' '  AND B1_FILIAL = '" + xFilial("SB1") + "' AND "  
	cQuery += " SB1.B1_GRUPO IN("+cGrpMar+") AND SB1.B1_MSBLQL <> '1' " 
	cQuery += "ORDER BY B1_COD "

	TCQUERY cQuery ALIAS "QSB1" NEW

	dbSelectArea("QSB1")
	QSB1->(dbGoTop())

	While QSB1->(! Eof())

		dbSelectArea("TRB")
	   dbSeek(QSB1->B1_GRUPO+QSB1->B1_COD)

	   If TRB->(Eof())
		   RecLock("TRB",.T.)
		   TRB->BM_GRUPO := QSB1->B1_GRUPO
		   TRB->B1_COD	 := QSB1->B1_COD
	      TRB->B1_DESC := QSB1->B1_DESC
  		   TRB->B1_CUSTD := QSB1->B1_CUSTD
  	  	   TRB->B1_YFATOR := QSB1->B1_YFATOR
  	 	  // TRB->B1_DESCGRU := QSB1->B1_DESCGRU
   	   //TRB->B1_YREF := QSB1->B1_YREF
   	   TRB->B1_YFATOR2 := QSB1->B1_YFATOR2
   	   TRB->B1_YFATOR3 := QSB1->B1_YFATOR3
		   MsUnlock()
	   EndIf

		dbSelectArea("QSB1")
	   QSB1->(dbSkip())

	EndDo

EndIf

If Len(aGrpDMa) >= 1

	For nXXT := 1 To Len(aGrpDMa)
		dbSelectArea("TRB")
		TRB->(dbSeek(aGrpDMa[nXXT]))
	   While TRB->(! Eof()) .And. TRB->BM_GRUPO == aGrpDMa[nXXT]
			RecLock("TRB",.F.)	
			dbDelete()
			MsUnLock() 	
			dbSelectArea("TRB")
	      TRB->(dbSkip())
      EndDo
	Next nXXT

EndIf

dbSelectArea("TRB1")
dbGoTop()

While ! Eof()

   RecLock("TRB1",.F.)
   TRB1->B1_OK := TRBM->BM_OK
   MsUnlock()

   dbSelectArea("TRB1")
   dbSkip()

EndDo

dbSelectArea("TRB1")
dbGoTop()

dbSelectArea("TRBM")

oMarkAlt:oBrowse:Refresh()
oMarkArq:oBrowse:Refresh()
oDlgMark:Refresh()

Return(lRetFunc)



//-------------------------------------------------------------------
/*/{Protheus.doc} FAlEsArq
Função pra tratativa da seleção dos produtos apenas um registro.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		cMarcAlt - 
				lInvLib  - 
				oDlgMark - 
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FAlEsArq(cMarcAlt,lInvLib,oDlgMark)

Local lRetFunc := .T.
Local lTudVaz  := .T.
Local nRecArq  := TRB1->(RecNo())
Local lExisVaz := .F.

If IsMark("B1_OK",cMarcAlt,lInvLib)
   RecLock("TRB1",.F.)
   If ! lInvLib
      Replace B1_OK With cMarcAlt
   Else
      Replace B1_OK With "  "
   Endif
   MsUnlock()
Else
   RecLock("TRB1",.F.)
   If ! lInvLib
      Replace B1_OK With "  "
   Else
      Replace B1_OK With cMarcAlt
   Endif
   MsUnlock()
EndIf

dbSelectArea("TRB")
dbSeek(TRBM->BM_GRUPO+TRB1->B1_COD)

If Empty(TRB1->B1_OK) .And. TRB->(! Eof())
	RecLock("TRB",.F.)	
	dbDelete()
	MsUnLock() 	
ElseIf ! Empty(TRB1->B1_OK) .And. TRB->(Eof()) 
	RecLock("TRB",.T.)
   TRB->BM_GRUPO := TRBM->BM_GRUPO
   TRB->B1_COD := TRB1->B1_COD
   TRB->B1_DESC := TRB1->B1_DESC
   TRB->B1_CUSTD := TRB1->B1_CUSTD
   TRB->B1_YFATOR := TRB1->B1_YFATOR
   //TRB->B1_DESCGRU := TRB1->B1_DESCGRU
   //TRB->B1_YREF := TRB1->B1_YREF
   TRB->B1_YFATOR2 := TRB1->B1_YFATOR2
   TRB->B1_YFATOR3 := TRB1->B1_YFATOR3
	MsUnLock() 	
EndIf

dbSelectArea("TRB1")

lExisVaz := .F.
TRB1->(dbGoTop())

While TRB1->(! Eof())

	If Empty(TRB1->B1_OK)
		lExisVaz := .T.
	EndIf

	dbSelectArea("TRB1")
   TRB1->(dbSkip())
EndDo

If lExisVaz
	If ! Empty(TRBM->BM_OK)
		RecLock("TRBM",.F.)
		TRBM->BM_OK := ""
		MsUnLock() 	
	EndIf
Else
	If Empty(TRBM->BM_OK)
		RecLock("TRBM",.F.)
		TRBM->BM_OK := cMarcAlt
		MsUnLock() 	
	EndIf
EndIf

dbSelectArea("TRB1")
dbGoTo(nRecArq)

oMarkAlt:oBrowse:Refresh()
oMarkArq:oBrowse:Refresh()
oDlgMark:Refresh()

Return(lRetFunc)



//-------------------------------------------------------------------
/*/{Protheus.doc} FAlMarAlArq
Função pra tratativa da seleção de todos os produtos.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		cMarcAlt - 
				oDlgMark - 
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FAlMarAlArq(cMarcAlt,oDlgMark)

Local lRetFunc := .T.
Local nRecno   := 0
Local lTudVaz  := .T.

dbSelectArea("TRB1")
nRecno := Recno()
dbGotop()

While ! Eof()

   RecLock("TRB1",.F.)
   If ! Marked("B1_OK")
      Replace B1_OK With cMarcAlt
   Else
      Replace B1_OK With "  "
   Endif
   MsUnlock()

	dbSelectArea("TRB")
	dbSeek(TRBM->BM_GRUPO+TRB1->B1_COD)

	If Empty(TRB1->B1_OK) .And. TRB->(! Eof())
		RecLock("TRB",.F.)
		dbDelete()
		MsUnLock() 	
	ElseIf ! Empty(TRB1->B1_OK) .And. TRB->(Eof()) 
		RecLock("TRB",.T.)
      TRB->BM_GRUPO := TRBM->BM_GRUPO
      TRB->B1_COD := TRB1->B1_COD
      TRB->B1_DESC := TRB1->B1_DESC
      TRB->B1_CUSTD := TRB1->B1_CUSTD
      TRB->B1_YFATOR := TRB1->B1_YFATOR
     // TRB->B1_DESCGRU := TRB1->B1_DESCGRU
     // TRB->B1_YREF := TRB1->B1_YREF
      TRB->B1_YFATOR2 := TRB1->B1_YFATOR2
      TRB->B1_YFATOR3 := TRB1->B1_YFATOR3
		MsUnLock() 	
	EndIf
   
   dbSelectArea("TRB1")
   dbSkip()

EndDo

dbSelectArea("TRB1")

lExisVaz := .F.
TRB1->(dbGoTop())

While TRB1->(! Eof())

	If Empty(TRB1->B1_OK)
		lExisVaz := .T.
	EndIf

	dbSelectArea("TRB1")
   TRB1->(dbSkip())
EndDo

If lExisVaz
	If ! Empty(TRBM->BM_OK)
		RecLock("TRBM",.F.)
		TRBM->BM_OK := ""
		MsUnLock() 	
	EndIf
Else
	If Empty(TRBM->BM_OK)
		RecLock("TRBM",.F.)
		TRBM->BM_OK := cMarcAlt
		MsUnLock() 	
	EndIf
EndIf

dbSelectArea("TRB1")
dbGoto(nRecno)

oMarkAlt:oBrowse:Refresh()
oMarkArq:oBrowse:Refresh()
oDlgMark:Refresh()

Return(lRetFunc)



//-------------------------------------------------------------------
/*/{Protheus.doc} FSEXP
Função para exportar arquivos em excel.

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FSEXP()

Local aCabExcel   := {}
Local aItensExcel := {} 

AADD(aCabExcel,{"Codigo Produto		",TAMSX3("B1_COD")[03],TAMSX3("B1_COD")[01],TAMSX3("B1_COD")[02]})
AADD(aCabExcel,{"Descrição Produto	",TAMSX3("B1_DESC")[03],TAMSX3("B1_DESC")[01],TAMSX3("B1_DESC")[02]})
AADD(aCabExcel,{"Custo Atual		","N",012,2})
AADD(aCabExcel,{"Custo Novo			","N",012,0}) 
AADD(aCabExcel,{"Fator Intra Atual	","N",012,2}) 
AADD(aCabExcel,{"Fator Intra Novo	","N",012,0})
AADD(aCabExcel,{"Codigo da Marca	",TAMSX3("BM_GRUPO")[03],TAMSX3("BM_GRUPO")[01],TAMSX3("BM_GRUPO")[02]})
//AADD(aCabExcel,{"Descricao Marca	",TAMSX3("B1_DESCGRU")[03],TAMSX3("B1_DESCGRU")[01],TAMSX3("B1_DESCGRU")[02]})
//AADD(aCabExcel,{"Referencia			",TAMSX3("B1_YREF")[03],TAMSX3("B1_YREF")[01],TAMSX3("B1_YREF")[02]})
AADD(aCabExcel,{"Fator Inter Atual	","N",012,2})  
AADD(aCabExcel,{"Fator Inter Novo	","N",012,2})
AADD(aCabExcel,{"Fator Transf			","N",012,2})
AADD(aCabExcel,{".				  	   ","C",006,0})

MsgRun("Favor Aguardar...","Selecionando os Registros",{|| FSPROITN(aCabExcel,@aItensExcel)})

MsgRun("Favor Aguardar...","Exportando os Registros para o Excel",;
		{||DlgToExcel ({{"GETDADOS","Cadastro de produtos;;;;;;;;;;",aCabExcel,aItensExcel}})})
	
Return(Nil) 



//-------------------------------------------------------------------
/*/{Protheus.doc} FSPROITN
Gera Itens Para Exportar Para Excel

@protected
@author		Ederson Colen
@since		27/02/2013
@obs			Referente atendimento pontual
@param		aHeader
				aCols
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FSPROITN(aHeader,aCols)

Local lVerifi   := .T.
Local aItem
Local nX  
Local nTes      := .F.
Local nVerifi   := .F. 
Local nVerif    := .F.
Local aBrowse1	 := {}

dbSelectArea("TRB")
TRB->(dbGoTop())

While TRB->(! Eof())

	AADD(aBrowse1,{TRB->B1_COD,TRB->B1_DESC,TRB->B1_CUSTD,0,TRB->B1_YFATOR,0,TRB->BM_GRUPO,TRB->B1_YFATOR2,TRB->B1_YFATOR3,0,""})

	dbSelectArea("TRB")
	TRB->(dbSkip())
	
EndDo

For xI := 1 To Len(aBrowse1)
	aItem := Array(Len(aHeader))
	For xJ := 1 To Len(aHeader)
		If aHeader[xJ][2] == "C"
			aItem[xJ] := Chr(160) + aBrowse1[xI,xJ]
		Else
			aItem[xJ] := aBrowse1[xI,xJ] 
		EndIf
	Next xJ
	AADD(aCols,aItem)
Next xI
	
Return(Nil)