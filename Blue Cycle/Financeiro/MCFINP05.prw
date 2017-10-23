#INCLUDE "PROTHEUS.CH"
#INCLUDE "FILEIO.CH"

#Define CRLF CHR(13)+CHR(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} MCFINP05
Integracao de Beneficios com empresas de servicos.

@author Ederson Colen
@since 22/04/2013
@version 1.0

/*/
//-------------------------------------------------------------------
User Function MCFINP05()

Private cVBPerg := "MCFINP05"

//Funcao para criar/ajustar o grupo de perguntas da SX1
//FSAjuSX1(cVBPerg)

Pergunte(cVBPerg,.F.)

TNewProcess():New("MCFINP05","Exportacao dos Clientes para Arquivos TXT", {|oSelf| FProcesRot(oSelf)},"Esta rotina processa e gera arquivo de Clientes.","MCFINP05",NIL,NIL,NIL,NIL,.T.,.F.)

Return


//-------------------------------------------------------------------
/*/{Protheus.doc} Processa a Rotina. /*/
//-------------------------------------------------------------------
Static Function FProcesRot(oProcess)

Local nOldSet	:= SetVarNameLen(255)
Local aArea		:= GetArea()
Local aItems	:= {}
Local cCodUsr	:= AllTrim(GetMv("MC_CODUSBV"))

Private cCliInic := MV_PAR01
Private cLojInic := MV_PAR02
Private cCliFina := MV_PAR03
Private cLojFina := MV_PAR04
Private dDtUltCo := (dDataBase - Iif(MV_PAR05==1,90,180))
Private cLocGrv  := AllTrim(MV_PAR06)+"\"

Private nHdl		:= 0
Private cArqOut	:= cLocGrv+"GC_20008277499.TXT"	//retirado: cLocGrv+"GC_"+cCodUsr+".TXT"
Private lErrorImp	:= .F.

Private nLin		:= 0

Private cAliTA1	:= "TRA1"

If Empty(cCodUsr)
	Aviso("ATENCAO","Parâmetro com o Código do Usuário Boa Vista está vazio ou Não foi criado. Favor solicitar a TI para criação e preenchimento do mesmo.",{"OK"})
	oProcess:SaveLog("Parâmetro com o Código do Usuário Boa Vista está vazio ou Não foi criado. Favor solicitar a TI para criação e preenchimento do mesmo.")
	Return NIL	
EndIf

AAdd(aItems, {"Lendo dados ",{|| FConsDad(oProcess) } })
AAdd(aItems, {"Gravando dados ",{|| FProcArq(oProcess,cCodUsr) } })
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
If !oProcess:lEnd

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
/*/{Protheus.doc} FConsDad - Consulta Banco Dados /*/
//-------------------------------------------------------------------
Static Function FConsDad(oProcess)

Local cQryRel := ""

//Fecha o arquivo caso esteja aberto                                                                           
If Select(cAliTA1) <> 0
	cAliTA1->(dbCloseArea())
EndIf

cQryRel += Chr(13) + " SELECT * "
cQryRel += Chr(13) + " FROM (SELECT * FROM " + RetSqlName("SA1") + " A1 WHERE A1.D_E_L_E_T_ = ' ' AND A1.A1_MSBLQL <> '1' AND A1__REGTRP = '1' ORDER BY A1_SALDUP DESC)"
//cQryRel += Chr(13) + " WHERE ROWNUM <= 1999 " //A1.D_E_L_E_T_ <> '*' "
//cQryRel += Chr(13) + " AND A1.A1_MSBLQL <> '1' "                    
//cQryRel += Chr(13) + " AND A1.A1_COD BETWEEN '"+cCliInic+"' AND '"+cCliFina+"' "
//cQryRel += Chr(13) + " AND A1.A1_LOJA BETWEEN '"+cLojInic+"' AND '"+cLojFina+"' "
//cQryRel += Chr(13) + " AND ((A1.A1_ULTCOM >= '"+DToS(dDtUltCo)+"' AND A1.A1_DTENVBV = ' ') OR (A1.A1_DTENVBV < '"+DToS((dDataBase - 90))+"' AND A1.A1_ULTCOM <= '"+DToS(dDtUltCo)+"' AND A1.A1_DTENVBV <> ' ')) "
//cQryRel += Chr(13) + " AND A1.A1_PESSOA = 'J' "
//cQryRel += Chr(13) + " AND A1.A1_ULTCOM <> ' ' "

//Atualiza regua
oProcess:SetRegua2(1)
oProcess:IncRegua2("")

If TcSqlExec(cQryRel) <> 0
	FVBValida(oProcess,"ERRO SQL "+TCSqlError())
	oProcess:lEnd := .F.
Else
	//Cria o arquivo de trabalho da query posicionada
	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQryRel),cAliTA1,.F.,.T.)
	(cAliTA1)->(dbGoTop())
	//Valida se exitem informacoes no arquivo gerado.
	If (cAliTA1)->(! Eof())
		oProcess:IncRegua2("Encontrado Registros...")
	Else
		FVBValida(oProcess,"Não foram encontrados registros com os parâmetros informados")
		oProcess:lEnd := .F.
	EndIf
EndIf
		
Return Nil



//-------------------------------------------------------------------
/*/{Protheus.doc} FProcArq - Gravação do Arquivo /*/
//-------------------------------------------------------------------
Static Function FProcArq(oProcess,cCodUsr)

Local nCont			:= 0
Local cLinHeader	:= ""
Local cLinDet		:= ""
Local cLinRodPe	:= ""

//Atualiza regua
oProcess:SetRegua2(nCont)
oProcess:IncRegua2("")

If File(cArqOut)
   If Aviso("ATENCAO",cArqOut +" - " +"Arquivo Já Existe. Sobrepor?",{"Não","Sim"}) == 1
		FVBValida(oProcess,"Usuario optou por nao sobrepor arquivo ja existente")
		oProcess:lEnd := .F.
		Return
   EndIf
EndIf       

//Cria Arquivo de saida
nHdl := FCreate(cArqOut)
If nHdl == -1
	FVBValida(oProcess,'O arquivo não pode ser criado! Verifique os parametros.')
	oProcess:lEnd := .F.
	Return
Endif

cLinHeader := "0" //Tipo de Registro
cLinHeader += "GC00002"//Código do Layout
cLinHeader += "20008277499" //Código do Clientes (Matriz) retirado--cCodUsr

FWrite(nHdl,cLinHeader+Chr(13)+Chr(10))

(cAliTA1)->(dbGoTop())
While (cAliTA1)->(! Eof())
	nCont ++
	(cAliTA1)->(dbSkip())
EndDo

(cAliTA1)->(dbGoTop())

While (cAliTA1)->(! Eof())

	cNomeCli := AllTrim(Left((cAliTA1)->A1_NOME,55))
	If Len(cNomeCli) < 55
		cNomeCli += Replicate(" ",55-Len(cNomeCli))
	EndIf
	cCodInt := AllTrim((cAliTA1)->A1_COD+(cAliTA1)->A1_LOJA)
	If Len(cCodInt) < 15
		cCodInt += Replicate(" ",15-Len(cCodInt))
	EndIf

	cLinDet := "1" //Tipo de Registro
	cLinDet += Iif(! Empty((cAliTA1)->A1_DTENVBV),"C","I") //Operação
	cLinDet += cCodUsr //Codigo da Carteira     Alterado de "XXXXXXXXXXX" para cCodUsr
	cLinDet += (cAliTA1)->A1_CGC //CNPJ
	cLinDet += cNomeCli //RAZÃO SOCIAL
	cLinDet += cCodInt //CODIGO INTERNO
	cLinDet += Space(15) //SEGMENTAÇÃO
	cLinDet += "S" //Rating
	cLinDet += "S" //Restrições
	cLinDet += "S" //Cadastral

	FWrite(nHdl,cLinDet+Chr(13)+Chr(10))

	SA1->(dbSetOrder(1))
	SA1->(dbSeek(xFilial("SA1")+(cAliTA1)->A1_COD+(cAliTA1)->A1_LOJA))
	
	If SA1->(! Eof())
		RecLock("SA1",.F.)
		If ! Empty((cAliTA1)->A1_DTENVBV)
			SA1->A1_DTENVBV := CToD("")
		Else
			SA1->A1_DTENVBV := dDataBase
		EndIf
		MsUnLock()
	EndIf

	nLin += 1

	oProcess:IncRegua2(AllTrim((cAliTA1)->A1_NOME))

	(cAliTA1)->(dbSkip())

EndDo

cLinRodPe := "9"
cLinRodPe += StrZero(nLin,9)

FWrite(nHdl,cLinRodPe+Chr(13)+Chr(10))

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
Aadd(aPergAux,{"Do Cliente"       	,TamSx3("A1_COD")[3],TamSx3("A1_COD")[1],TamSx3("A1_COD")[2],"G","SA1","","","","","","","Informe o Codigo do Cliente"})
Aadd(aPergAux,{"Da Loja"	      	,TamSx3("A1_LOJA")[3],TamSx3("A1_LOJA")[1],TamSx3("A1_LOJA")[2],"G","","","","","","","","Informe o Codigo da Loja"})
Aadd(aPergAux,{"Ate o Cliente"    	,TamSx3("A1_COD")[3],TamSx3("A1_COD")[1],TamSx3("A1_COD")[2],"G","SA1","","","","","","","Informe o Codigo do Cliente"})
Aadd(aPergAux,{"Da Loja"	       	,TamSx3("A1_LOJA")[3],TamSx3("A1_LOJA")[1],TamSx3("A1_LOJA")[2],"G","","","","","","","","Informe o Codigo da Loja"})
Aadd(aPergAux,{"Num.Dias Envio"    	,"N"						,1							,00						,"C","","","90 Dias","180 Dias","","","","Informe o Num.Dias Envio"})
Aadd(aPergAux,{"Local Grv.Arquivo"	,"C"                 ,60                  ,00                  ,"G","DIRTXT","","","","","","","Informe Local Arquivo"})

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