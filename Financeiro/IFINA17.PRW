#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : IFINA17			  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rafael Domingues - Anadi													|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Função para importar o arquivo GNRE para a SE5								  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function IFINA17()

Local cArquivo  := cGetFile()
Local aLinha    := {}
Local aConteudo := {}
Local cComp     := ""
Local _cEOL     := ""
Local i

If Empty(cArquivo)
	MsgAlert("Atenção, informe um arquivo válido antes de prosseguir com a importação.")
	Return(Nil)
EndIf

FT_FUse(cArquivo)
ProcRegua(FT_FLastRec())
FT_FGoTop()

While !FT_FEof()
	aLinha := {}
	aLinha := FT_FReadLn()
	
	AAdd(aConteudo,aLinha)
	
	FT_FSkip()
Enddo

DbSelectArea("SE5")

For i := 2 To (Len(aConteudo)-1)
	
	DbSelectArea("SA1")
	DbSetOrder(3)
	DbSeek(xFilial("SA1")+Substr(aConteudo[i],37,14))
	
	RecLock("SE5",.T.)
	SE5->E5_FILIAL	  :="01"
	SE5->E5_DATA      := StoD(Substr(aConteudo[i],333,8))
	SE5->E5_TIPO      := "GNR"
	SE5->E5_MOEDA     := "M1"
	SE5->E5_VALOR     := Val(Substr(aConteudo[i],269,19))/100
	SE5->E5_BANCO     := "001"
	SE5->E5_AGENCIA   := "3221"
	SE5->E5_CONTA     := "35031"
	SE5->E5_NATUREZ   := "310010"
	SE5->E5_DOCUMEN   := Substr(aConteudo[i],51,15)
	SE5->E5_RECPAG    := "P"
	SE5->E5_BENEF     := "SEFAZ"
	SE5->E5_HISTOR    := Substr(aConteudo[i],51,15)	
	SE5->E5_VENCTO    := StoD(Substr(aConteudo[i],333,8))	
	SE5->E5_TIPODOC   := ""
	SE5->E5_NUMERO    := ""
	SE5->E5_CLIFOR    := ""
	SE5->E5_LOJA      := ""
	SE5->E5_DTDIGIT   := StoD(Substr(aConteudo[i],333,8))
	SE5->E5_FILORIG   := "01"
	SE5->E5_CLIENTE   := ""
	SE5->E5_DTDISPO   := StoD(Substr(aConteudo[i],333,8))
	SE5->E5_MODSPB    := "1"
	MsUnLock()
	
	FT_FSkip()
	
Next i

Return
