#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

#Define CRLF CHR(13)+CHR(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MCFINP07
Integracao de Beneficios com empresas de servicos.

@author Ederson Colen
@since 22/04/2013
@version 1.0

/*/
//-------------------------------------------------------------------
User Function MCFINP07()

Private cVBPerg := "MCFINP07"

//Funcao para criar/ajustar o grupo de perguntas da SX1
//FSAjuSX1(cVBPerg)

Pergunte(cVBPerg,.F.)

TNewProcess():New("MCFINP07","Importação do Arquivo de Retorno dos Clientes", {|oSelf| FProcesRot(oSelf)},"Esta rotina processa a importação do retorno de processamento do arquivo de Clientes.","MCFINP07",NIL,NIL,NIL,NIL,.T.,.F.)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} Processa a Rotina. /*/
//-------------------------------------------------------------------
Static Function FProcesRot(oProcess)

Local nOldSet	:= SetVarNameLen(255)
Local aArea		:= GetArea()
Local aItems	:= {}

Private nHdl		:= 0
Private cArqOut	:= AllTrim(MV_PAR01)
Private lErrorImp	:= .F.

Private nLin		:= 0

Private cAliTA1	:= "TRA1"

AAdd(aItems, {"Gravando dados ",{|| FProcArq(oProcess) } })
oProcess:SetRegua1(Len(aItems)) //Total de elementos da regua
oProcess:SaveLog("Inicio de processamento")

For nCount:= 1 to Len(aItems)

	If (oProcess:lEnd)
		Break
	EndIf
	
	oProcess:IncRegua1(aItems[nCount, 1])

	Eval(aItems[nCount, 2])

Next

SetVarNameLen(nOldSet)

//Fecha Arquivo
If nHdl > 0

	If !fClose(nHdl)
		MsgAlert('Ocorreram problemas no fechamento do arquivo.')
	EndIf

EndIf

//Encerra o processamento
If ! oProcess:lEnd

	oProcess:SaveLog("Fim do processamento")
	
	If lErrorImp

		FErase(cArqOut)

		Aviso("ATENCAO","Existe dados inválidos. Verifique o Log de Processos desta rotina!", {"OK"})
		
	ElseIf nLin > 0

		Aviso("Exportacao de arquivos de Pagamento", "Fim do processamento", {"OK"})

	Else

		Aviso("Aviso","Não existem registros a serem gravados.",{"Ok"})

	EndIf

Else

	nLin := 0

	Aviso("Exportacao de arquivos de Pagamento", "Processamento cancelado pelo usuario!",{"OK"})

	oProcess:SaveLog("Processamento cancelado pelo usuario!")

EndIf

If Select(cAliTA1) <> 0
	(cAliTA1)->(dbCloseArea())
EndIf

RestArea(aArea)

Return .T.



//-------------------------------------------------------------------
/*/{Protheus.doc} FProcArq - Gravação do Arquivo /*/
//-------------------------------------------------------------------
Static Function FProcArq(oProcess)

Local cLinha  := ""

Local lRetArq := .F.

Local aCampArq := {}
Local aAuxLin	:= {}

Local aCabExcA := {"TP REG","OPER","COD CARTEIRA","CNPJ","RAZAO SOCIAL","COD INTERNO","SEGMENTO","RATING",;
						"RESTRICOES","CADASTRAL","COD RETORNO","DESCRICAO RETORNO","."}

Local aItmExcA := {}

nHandle := FT_FUse(cArqOut)

If nHandle = -1
   Aviso("",OemToAnsi("Não foi possível abrir o Arquivo: "+cFile),{"OK"})
	lRetTXT := .F.
   Return(lRetTXT)
EndIf

FT_FGoTop()

nLast := FT_FLastRec()

//Atualiza regua
oProcess:SetRegua2(nLast)
oProcess:IncRegua2("")

While ! FT_FEof()

	cLinha  := FT_FReadLn()

	If Left(cLinha,1) == "1"

  		aAdd(aItmExcA,{Left(cLinha,1),;			//Tipor Registro
							SubStr(cLinha,2,1),;		//Operação
							SubStr(cLinha,3,11),;	//Codigo Carteira
							SubStr(cLinha,14,14),;	//CNPJ
							SubStr(cLinha,28,55),;	//Razao Social
							SubStr(cLinha,83,15),;	//Codigo Interno
							SubStr(cLinha,98,15),;	//Segmentação
							SubStr(cLinha,113,1),;	//Rating
							SubStr(cLinha,114,1),;	//Restricoes
							SubStr(cLinha,115,1),;	//Cadastral
							SubStr(cLinha,116,2),;	//Retorno
							AllTrim(POSICIONE("SX5",1,xFilial("SX5")+"Z5"+SubStr(cLinha,116,2),"X5_DESCRI")),;
							""})

		oProcess:IncRegua2(AllTrim(SubStr(cLinha,28,55)))
		nLin += 1

		If ! SubStr(cLinha,116,2) $ "00_"
			SA1->(dbSetOrder(1))
			SA1->(dbSeek(xFilial("SA1")+AllTrim(SubStr(cLinha,83,15))))
			If SA1->(! Eof()) .And. (! Empty(SA1->A1_DTENVBV))
				RecLock("SA1",.F.)
				SA1->A1_DTENVBV := CToD("")
				MsUnLock()
			EndIf
		EndIf

	EndIf

	FT_FSkip()
  
EndDo

FT_FUse()

//Executa a função para criar o arquivo no Excel    
MsgRun("Gerando arquivo no Excel","Por favor, aguarde...",{||ShellExecute("Open",U_FExpExcel(aCabExcA,aItmExcA)   , "","C:\", 1)})

oProcess:lEnd := .F.

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FSAjuSX1
Ajusta as Perguntas utilizadas no programa princial.

@author	  Ederson Colen
@since	  16/05/2012
@version   P11.5
@obs	     Referente ao Projeto FS006443
@param     cPerg      - Nome do Grupo de Perguntas

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------                          
Static Function FSAjuSX1(cPerg)

Local aPergs   := {}
Local aPergAux := {}
Local aHelpPor := {}
Local nXX      := 0

// 1 - Texto Pergunta
// 2 - Tipo Campo (C,N,D,etc)
// 3 - Tamanho Campo
// 4 - Tamanho Decimal
// 5 - Tipo Get (G) ou (C) Choice
// 6 - F3
// 7 - Validação Campo
// 8 a 12 Opções.
// 13 - Texto do Help Tamanho Linha                                       '1234567890123456789012345678901234567890' )
//             1                   2   3  4  5   6  7  8  9  10 11 12  13
Aadd(aPergAux,{"Local Arquivo"	,"C"                 ,60                  ,00                  ,"G","ARQTXT","","","","","","","Informe Local Arquivo"})

//Alimenta os arreys de Pergunta e Help.
For nXT := 1 To Len(aPergAux)
	 Aadd(aPergs,{aPergAux[nXT,01],aPergAux[nXT,01],aPergAux[nXT,01],"mv_ch"+AllTrim(Str(nXT)),;
					aPergAux[nXT,02],aPergAux[nXT,03],aPergAux[nXT,04],0,aPergAux[nXT,05],;
					aPergAux[nXT,07],"MV_PAR"+StrZero(nXT,2),;
					aPergAux[nXT,08],aPergAux[nXT,08],aPergAux[nXT,08],"","",;
					aPergAux[nXT,09],aPergAux[nXT,09],aPergAux[nXT,09],"","",;
					aPergAux[nXT,10],aPergAux[nXT,10],aPergAux[nXT,10],"","",;
					aPergAux[nXT,11],aPergAux[nXT,11],aPergAux[nXT,11],"","",;
					aPergAux[nXT,12],aPergAux[nXT,12],aPergAux[nXT,12],"",aPergAux[nXT,06],"","",""})
	 Aadd(aHelpPor,{aPergAux[nXT,13]})
Next nXT

//Cria perguntas (padrao)
AjustaSx1(cPerg,aPergs)

//Help das perguntas
For nXX := 1 To Len(aHelpPor)
    PutSX1Help("P."+cPerg+StrZero(nXX,2),aHelpPor[nXX],aHelpPor[nXX],aHelpPor[nXX])
Next nXX

Return Nil



//-------------------------------------------------------------------
/*/{Protheus.doc} Funcao de Validacao dos Funcionarios            /*/
//-------------------------------------------------------------------
Static Function FVBValida(oProcess,cDescErr)

oProcess:SaveLog(cDescErr)
lErrorImp := .T.

Return