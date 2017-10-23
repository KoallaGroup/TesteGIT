#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

#Define CRLF CHR(13)+CHR(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} SERASA01
Geracao do Arquivo Diario Serasa.

@protected
@author    Ederson Colen
@since     13/05/2014
@obs       Referente atendimento Pontual.

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
User Function SERASA01()

Private cPergRot := "SERASA01"

//FSAjuSX1()

Pergunte(cPergRot,.F.)

TNewProcess():New("SERASA01","Importação dados SERASA", {|oSelf| FProcesRot(oSelf)},"Esta rotina processa e gera arquivo de Clientes para SERASA","SERASA01",NIL,NIL,NIL,NIL,.T.,.F.)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} Processa a Rotina. /*/
//-------------------------------------------------------------------
Static Function FProcesRot(oProcess)

Local nCount, nCount2
Local nOldSet   := SetVarNameLen(255)
Local aArea     := GetArea()
Local aItems    := {}
Local lCancel   := .F.

Private nTotal  := 0
Private nVlr    := 0
Private nTotal  := 0
Private nHdl    := 0
Private nLin    := 0

Private lErrorImp		:= .F.

Private cCliInic	:= MV_PAR01 //"Do Cliente"			,TamSx3("A1_COD")[3]		,TamSx3("A1_COD")[1]	,TamSx3("A1_COD")[2]	,"G","SA1","","","","","","","Informe Do Codigo Cliente"})
Private cCliFina	:= MV_PAR02 //"Ate o Cliente"		,TamSx3("A1_COD")[3]		,TamSx3("A1_COD")[1]	,TamSx3("A1_COD")[2]	,"G","SA1","","","","","","","Informe Ate o Codigo Cliente"})
Private cArqOut	:= MV_PAR03 //"Arq.Serasa"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Arquivo Serasa"})
Private cLocGeg	:= MV_PAR04 //"Local Geração"		,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Local de Geracao Arquivo"})
Private nTipOper	:= MV_PAR05 //"Tipo Operacao"		,"N"							,01						,0							,"C",""   ,"","Inclusao","Exclusao","","","","Informe Tipo Operacao"})
Private cNomPerf	:= MV_PAR06 //"Nome Perfil"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Nome do Perfil"})
Private nNumDias	:= MV_PAR07 //"Dias Cliente Ativos","N"							,06						,0							,"G",""   ,"","","","","","","Informe Dias Cliente Ativos"})
Private cCNPJEmp	:= MV_PAR08 //"CNPJ Empresa"			,"C"							,14						,0							,"G",""   ,"","","","","","","Informe CNPJ Empresa"})
Private cNomEmpr	:= MV_PAR09 //"Nome Empresa"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe Nome Empresa"})
Private cGrpEmai	:= MV_PAR10 //"Grupo e-mail"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe Grupo de e-mail"})

dbSelectArea("RG2")
dbSetOrder(1)

AAdd(aItems, {"Selecionando Clientes",{|| FProcCli(oProcess) } })

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
	If ! FClose(nHdl)
		MsgAlert('Ocorreram problemas no fechamento do arquivo.')
	EndIf
EndIf

//Encerra o processamento
If !oProcess:lEnd

	oProcess:SaveLog("Fim do processamento")
	
	If lErrorImp

		FErase(AllTrim(cLocGeg)+cArqOut)

		Alert("Existe dados inválidos. Verifique o Log de Processos desta rotina!")
		
	ElseIf nLin > 0

		Aviso("Exportacao dos Clientes", "Fim do processamento", {"OK"})

	Else

		Aviso("Aviso","Não existem registros a serem gravados.",{"Ok"})

	EndIf

Else

	nLin := 0

	Aviso("Exportacao dos Clientes", "Processamento cancelado pelo usuario!",{"OK"})

	oProcess:SaveLog("Processamento cancelado pelo usuario!")

EndIf

RestArea(aArea)

Return .T.



//-------------------------------------------------------------------
/*/{Protheus.doc} FProcCli - Leitura do Arquivo INI/*/
//-------------------------------------------------------------------
Static Function FProcCli(oProcess)

Local	cTime			:= Time()
Local	nNroRemes	:= VAL(GETMV("MV_SEQSERA"))

Private nSeq    := 0

If File(AllTrim(cLocGeg)+cArqOut)
   If Aviso("ATENCAO",AllTrim(cLocGeg)+cArqOut +" - " +"Arquivo Já Existe. Sobrepor?",{"Não","Sim"}) == 1
      Return
   EndIf
EndIf

If AT(".",cArqOut)>0
   cArqOut := SubStr(AllTrim(cArqOut),1,AT(".",cArqOut)-1)+".REM"
Else
   cArqOut := AllTrim(cArqOut)+".REM"
EndIf

nSeq := 1

//Fecha o arquivo caso esteja aberto
U_FCloseArea("TSA1")

cQryRel := ""
cQryRel += Chr(13) + " SELECT A1.A1_FILIAL, A1.A1_COD, A1.A1_LOJA, A1.A1_NOME, A1.A1_CGC, ((DATEDIFF(day,cast('20140513' as datetime),cast(A1.A1_ULTCOM as datetime)))*-1) AS DIAS "
cQryRel += Chr(13) + " FROM "+RetSqlName("SA1")+" A1 "
cQryRel += Chr(13) + " WHERE A1.D_E_L_E_T_ <> '*' "
cQryRel += Chr(13) + " AND A1.A1_FILIAL = '"+xFilial("SA1")+"' "
cQryRel += Chr(13) + " AND A1.A1_COD BETWEEN '"+cCliInic+"' AND '"+cCliFina+"' "
cQryRel += Chr(13) + " AND LEN(A1.A1_CGC) >= 14 "
If nTipOper == 1
	cQryRel += Chr(13) + " AND ((DATEDIFF(day,cast('20140513' as datetime),cast(A1.A1_ULTCOM as datetime)))*-1) <= "+AllTrim(Str(nNumDias))+" "
EndIf
cQryRel += Chr(13) + " AND A1.A1_CGC NOT IN('70963418000180','70963418000341','06752049000187','06752049000268','17749175000107','19246547000108','14309301000106','08111865000137','11247454000188','15096743000184') "

If TcSqlExec(cQryRel) <> 0
	Aviso(OemToAnsi("Atenção"),"ERRO SQL "+TCSqlError(),{"Ok"},2)
	Return
Else
	//Cria o arquivo de trabalho da query posicionada
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQryRel),"TSA1",.F.,.T.)
	TSA1->(dbGoTop())
	//Valida se exitem informacoes no arquivo gerado.
	If TSA1->(Eof())
		Aviso("ATENCAO","Não foram encotrados dados com os Parâmetros Informados.",{"Ok"}) 
		Return
	EndIf
EndIf

//Cria Arquivo de saida
nHdl := FCreate(AllTrim(cLocGeg)+cArqOut)
If nHdl == -1
	MsgAlert('O arquivo não pode ser criado! Verifique os parametros.','Atenção!')
	Return
Endif

cLinha := ""
cLinha += Strzero(nSeq,9)
cLinha += "0"
cLinha += PadR("GERENCIE CARTEIRA-LOTE",25)
cLinha += cCNPJEmp					// CNPJ DA EMPRESA COLIGADA
cLinha += PadR(cNomEmpr,70)		// RAZAO SOCIAL DA EMPRESA COLIGADA
cLinha += PadR(cNomPerf,20)		// PERFIL
cLinha += "0"    						// aviso                              1234
cLinha += Strzero(nNroRemes,8) 	// numero da remessa 99/99/99
cLinha += DToS(dDataBase) //Strzero(Year(dDataBase),4)+Substr(Dtoc(dDataBase),4,2)+Substr(Dtoc(dDataBase),1,2)      // data remessa
cLinha += Substr(cTime,1,2) +Substr(cTime,4,2) +Substr(cTime,7,2)  // hora da remessa
cLinha += " "           // branco
cLinha += "00000"       // cliente
cLinha += "55001430"    // logon
cLinha += PadR("" ,24)  + Chr(13)+Chr(10) // PERFIL
nSeq++

FWrite(nHdl,cLinha,Len(cLinha))

//If FWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
//	If ! MsgStop("Ocorreu um erro na gravacao do arquivo. ","Atencao!")
//		Return
//	Endif
//Endif

TSA1->(dbGoTop())

While TSA1->(! Eof())

	//Atualiza regua
	oProcess:SetRegua2(TSA1->(RecCount()))
	oProcess:IncRegua2(TSA1->A1_NOME)

	cLinha := ""
	cLinha += StrZero(nSeq,9)
	cLinha += "1"
	cLinha += PadR(TSA1->A1_CGC ,14)			// CNPJ CLIENTE
	cLinha += Iif(nTipOper==1,"I","E")			// TIPO OPERACAO
	cLinha += "180"									// PRAZO
	cLinha += PadR("",15)							// BRANCO
	cLinha += SUBSTR(cGrpEmai,1,15)				// FINANCEIRO
	cLinha += PadR("",141) + Chr(13)+Chr(10)	// BRANCO

	FWrite(nHdl,cLinha,Len(cLinha))

//	If fWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
//		If ! MsgStop("Ocorreu um erro na gravacao do arquivo. ","Atencao!")
//			Return
//		Endif
//	Endif
	    
	nSeq++

	nLin += 1	//-Indica que pode imprimir o Relatorio Final

	TSA1->(dbSkip())

EndDo

cLinha := ""
cLinha += Strzero(nSeq,9)
cLinha += "9"   
cLinha += Strzero(nSeq,6)
cLinha += PadR("",183)+Chr(13)+Chr(10)  // BRANCO

FWrite(nHdl,cLinha,Len(cLinha))

//If FWrite(nHdl,cLinha,Len(cLinha)) != Len(cLinha)
//	If !MsgStop("Ocorreu um erro na gravacao do arquivo. ","Atencao!")
//		Return
//  	Endif
//Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Atualiza Numero do ultimo Disco                              ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

dbSelectArea("SX6")
dbSetOrder(1)
dbSeek(xFilial("SX6")+"MV_SEQSERA")

If SX6->(! Eof())
	RecLock("SX6",.F.)
	SX6->X6_CONTEUD := StrZero(VAL(SX6->X6_CONTEUD)+1,8)
	MsUnLock()
EndIf

Return



//-------------------------------------------------------------------
/*/{Protheus.doc} FSAjuSX1
Ajusta as Perguntas utilizadas no programa princial.

@author	  Ederson Colen
@since	  16/05/2012
@version   P11.5
@obs	     Referente ao Projeto FS006443
@param     cPergRot      - Nome do Grupo de Perguntas

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------                          
Static Function FSAjuSX1()

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
//             1                     2   3 4 5   6     7  8  9  10 11 12  13
Aadd(aPergAux,{"Do Cliente"			,TamSx3("A1_COD")[3]		,TamSx3("A1_COD")[1]	,TamSx3("A1_COD")[2]	,"G","SA1","","","","","","","Informe Do Codigo Cliente"})
Aadd(aPergAux,{"Ate o Cliente"		,TamSx3("A1_COD")[3]		,TamSx3("A1_COD")[1]	,TamSx3("A1_COD")[2]	,"G","SA1","","","","","","","Informe Ate o Codigo Cliente"})
Aadd(aPergAux,{"Arq.Serasa"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Arquivo Serasa"})
Aadd(aPergAux,{"Local Geração"		,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Local de Geracao Arquivo"})
Aadd(aPergAux,{"Tipo Operacao"		,"N"							,01						,0							,"C",""   ,"","Inclusao","Exclusao","","","","Informe Tipo Operacao"})
Aadd(aPergAux,{"Nome Perfil"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe o Nome do Perfil"})
Aadd(aPergAux,{"Dias Cliente Ativos","N"							,06						,0							,"G",""   ,"","","","","","","Informe Dias Cliente Ativos"})
Aadd(aPergAux,{"CNPJ Empresa"			,"C"							,14						,0							,"G",""   ,"","","","","","","Informe CNPJ Empresa"})
Aadd(aPergAux,{"Nome Empresa"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe Nome Empresa"})
Aadd(aPergAux,{"Grupo e-mail"			,"C"							,50						,0							,"G",""   ,"","","","","","","Informe Grupo de e-mail"})

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
AjustaSx1(cPergRot,aPergs)

//Help das perguntas
For nXX := 1 To Len(aHelpPor)
    PutSX1Help("P."+cPergRot+StrZero(nXX,2),aHelpPor[nXX],aHelpPor[nXX],aHelpPor[nXX])
Next nXX

Return Nil



//THREAD ERROR (camila.fonseca, GLAGOAAPP01)   13/05/2014 17:39:51
//Alias does not exist TRSF2 on FPROCCLI(SERASA01.PRW) 13/05/2014 17:38:33 line : 206
//THREAD ERROR (camila.fonseca, GLAGOAAPP01)   13/05/2014 17:35:29
//variable does not exist NLINHA on FPROCCLI(SERASA01.PRW) 13/05/2014 17:28:52 line : 138
/*
Private cPathArq := Space(50)
cPathArq := AllTrim(MV_PAR11)
*/