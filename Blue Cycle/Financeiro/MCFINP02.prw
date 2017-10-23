#INCLUDE "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} MCFINP02
Geracao do Arquivo Mensal Serasa.

@protected
@author    Ederson Colen
@since     23/01/2014
@obs       Referente atendimento Pontual.

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
User Function MCFINP02()

Local cValPeg  := "MCFINP02" //Pergunta SX1

Local aTitWin	:= {"Geração do arquivo com SERASA Mensal."}
Local cDescr	:= "Este programa irá realizar a Exportação dos dados para SERASA."
Local cFunImp	:= "FFINP02" //Função que será chamada pelo Wizard.
Local cSemaf	:= "MCFINP02" //Semáforo para a rotina não ser executada simultanamente na mesma empresa
Local aConArq	:= {{"Exportação",.F.,"TXT |*.txt| ","Arquivo TXT","{|| Iif(FExistFile(aFile[1],.F.,2,cGetMes,cGetAno,aDadWzd,aConArq) .Or. Empty(aFile[1]),.T.,.F.)}"}}

//Funcao para criar/ajustar o grupo de perguntas da SX1
//FSAjuSX1(cValPeg)

//Chama a funcao do apWizard
U_FSWizImp(cFunImp   ,cSemaf  ,aTitWin[1]   ,cDescr,1      ,2      ,"Exportação",.F.    ,"01_02_03_04_05_06_07_08_09_10_11_12_",aConArq)

Return Nil  



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
Aadd(aPergAux,{"Data Inicial"    	,"D",08,00,"G","","","","","","","","Informe Data Inicial"})
Aadd(aPergAux,{"Data Final"      	,"D",08,00,"G","","","","","","","","Informe Data Final"})
Aadd(aPergAux,{"Tipo Envio"       	,"N",01,00,"C","","","Producao","Homologação","","","","Informe Tipo de Envio"})
Aadd(aPergAux,{"Tipo de Empresa"		,"N",01,00,"C","","","Serasa","Boa Vista","","","","Informe CNPJ da Empresa Origem"})
Aadd(aPergAux,{"CNPJ Empresa Origem","C",14,00,"G","","","","","","","","Informe CNPJ da Empresa Origem"})

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
/*/{Protheus.doc} FFINP02
Funcao para inciar o processo da geracao do arquivo Texto.

@protected
@author    Ederson Colen
@since     08/05/2012
@obs       Referente ao Projeto FS006407  
@param     dDatIniFi  - Data Inicial do Período Contábil
			  dDatFinFi  - Data Final do Período Contábil

Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
User Function FFINP02()

Local dDatIniFi	:= CToD("")
Local dDatFinFi	:= CToD("")
Local nTipoEnvi	:= 1
Local nTipEmpEn	:= 1
Local cCNOJEmpO	:= Space(14)
Local lRetQry		:= .T.
Local lRetTXT		:= .T.
Local cAlias		:= "TRBTXT"
Local aRetLog		:= {}
Local cArqPath		:= AllTrim(PARAMIXB[3,1])

If ! Pergunte("MCFINP02",.T.)
	AADD(aRetLog,"Cancelada a Tela de Parâmetros de Data.")
	Return (aRetLog)
EndIf

dDatIniFi := MV_PAR01
dDatFinFi := MV_PAR02
nTipoEnvi := MV_PAR03
nTipEmpEn := MV_PAR04
cCNOJEmpO := MV_PAR05

If ! Empty(dDatIniFi) .Or. ! Empty(dDatFinFi)
	MsgRun("Gerando o arquivo do TXT...","Por favor, aguarde",{|| Iif (FQryTXT(dDatIniFi,dDatFinFi,@lRetQry,cAlias),;
	                                                                		FCriTxt(cAlias,dDatIniFi,dDatFinFi,cArqPath,@lRetTXT,@aRetLog,nTipoEnvi,cCNOJEmpO,nTipEmpEn),.F.)})

	If !(lRetQry)
	   AADD(aRetLog,"Não foi possível localizar nenhum registro com os parâmetros informados, verifique e tente novamente.")
	EndIf
Else
   AADD(aRetLog,"Favor preencher todos os campos de Data para geração do Arquivo TXT. Data Inicial ou Final estão vazios.")
EndIf

Return (aRetLog)


//-------------------------------------------------------------------
/*/{Protheus.doc} FQryTXT
Funcao para executar a query para selecao dos registros na base de dados
conforme parametros passados.

@protected
@author    Ederson Colen
@since     08/05/2012
@obs       Referente ao Projeto FS006407  
@param     dDatIniFi  - Data Inicial da Contabilizacao
			  dDatFinFi  - Data Final da Contabilizacao
			  lRetFun    - Retorna se o arquivo de trabalho foi montado 
			  cAlias     - Alias do Arquivo Trabalho
			  
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FQryTXT(dDatIniFi,dDatFinFi,lRetFun,cAlias)

Local	lRetFun		:= .F.
Local nXI			:= 0
Local cQryTXT		:= ""
Local cCampAux		:= ""
Local aGrpFilEmp	:= {}

//Local cGrpFilEmp := AllTrim(SuperGetMv("MC_EMFISER",,"0102#0401#0501#0801#"))
//For nXX := 1 To Len(cGrpFilEmp)
//	cCampAux := SubStr(cGrpFilEmp,nXX,(AT("#",SubStr(cGrpFilEmp,nXX,Len(cGrpFilEmp)))-1))
//	If ! Empty(cCampAux)
//		aadd(aGrpFilEmp,cCampAux)
//   Else
//		aadd(aGrpFilEmp,SubStr(cGrpFilEmp,nXX,Len(cGrpFilEmp)))
//		EXIT
//   EndIf
//	nXX += (AT("#",SubStr(cGrpFilEmp,nXX,Len(cGrpFilEmp)))-1)
//Next nXX

//Fecha o arquivo caso esteja aberto
U_FCloseArea(cAlias)

cQryTXT := ""

//For nXT := 1 To Len(aGrpFilEmp)
//	cEmp := Left(aGrpFilEmp[nXT],2)
//	cFil := SubStr(aGrpFilEmp[nXT],3,TamSX3("E1_FILIAL")[1])

	//Monta o arquivo de trabalho com as informacoes para geração do arquivo texto.
//	cQryTXT += Chr(13) + "SELECT '"+cEmp+cFil+"' AS EMPFIL, A1.A1_CGC, A1.A1_PRICOM, "
	cQryTXT += Chr(13) + "SELECT '"+SM0->M0_CODIGO+SM0->M0_CODFIL+"' AS EMPFIL, A1.A1_CGC, A1.A1_PRICOM, "
	cQryTXT += Chr(13) + "CASE WHEN SUBSTR(A1.A1_PRICOM,1,6) < '201302' THEN '1' ELSE '2' END AS A1_TEMPO, "
	cQryTXT += Chr(13) + "E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA, E1.E1_EMISSAO, E1.E1_VALOR,  "
	cQryTXT += Chr(13) + "E1.E1_VENCTO, E1.E1_BAIXA "
//	cQryTXT += Chr(13) + "FROM SE1"+cEmp+"0 E1 "
	cQryTXT += Chr(13) + "FROM SE1"+SM0->M0_CODIGO+"0 E1 "
//	cQryTXT += Chr(13) + "INNER JOIN SA1"+cEmp+"0 A1 ON(A1.D_E_L_E_T_ <> '*' AND A1.A1_FILIAL = '  ' AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND A1.A1_PESSOA = 'J') "
	cQryTXT += Chr(13) + "INNER JOIN SA1"+SM0->M0_CODIGO+"0 A1 ON(A1.D_E_L_E_T_ <> '*' AND A1.A1_FILIAL = '  ' AND A1.A1_COD = E1.E1_CLIENTE AND A1.A1_LOJA = E1.E1_LOJA AND A1.A1_PESSOA = 'J') "
	cQryTXT += Chr(13) + "WHERE E1.D_E_L_E_T_ <> '*' "
//	cQryTXT += Chr(13) + "AND E1.E1_FILIAL = '"+cFil+"' "
	cQryTXT += Chr(13) + "AND E1.E1_FILIAL = '"+SM0->M0_CODFIL+"' "
	cQryTXT += Chr(13) + "AND (E1.E1_SALDO = 0.00 OR E1.E1_VALOR = E1.E1_SALDO) "
	cQryTXT += Chr(13) + "AND ((E1.E1_EMISSAO BETWEEN '"+DToS(dDatIniFi)+"' AND '"+DToS(dDatFinFi)+"') OR (E1.E1_BAIXA BETWEEN '"+DToS(dDatIniFi)+"' AND '"+DToS(dDatFinFi)+"')) "
	cQryTXT += Chr(13) + "AND E1.E1_TIPO IN('BOL','CH ','DP ','NF ') "

//	If (nXT + 1) <= Len(aGrpFilEmp)
//		cQryTXT += Chr(13) + "UNION ALL"
//	EndIf
//Next nXT

cQryTXT += Chr(13) + "ORDER BY EMPFIL, A1.A1_CGC, E1.E1_PREFIXO, E1.E1_NUM, E1.E1_PARCELA "

//Cria o arquivo de trabalho da query posicionada
dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQryTXT),cAlias,.F.,.T.)

dbSelectArea(cAlias)
dbGoTop()

//Valida se exitem informacoes no arquivo gerado.
If ((cAlias)->(!Eof()))
	lRetFun := .T.
EndIf

Return (lRetFun)



//-------------------------------------------------------------------
/*/{Protheus.doc} FCriTxt
Funcao para criar o arquivo txt

@protected
@author    Ederson Colen
@since     10/05/2012
@obs       Referente ao Projeto FS006407
@param     cAlias     - Nome do Arquivo de Trabalho temporário criado para Geração do Arquivo Texto
           dDatIniFi  - Data Inicial do Período Contábil
			  dDatFinFi  - Data Final do Período Contábil
			  cArqPath	 - Nome do Arquivo selecionado no Wizard
           lRetTXT    - Valida a Gravacao do Arquivo de Texto
           aRetLog	 - Arrey de Log para o Wizard
			  			 
Alteracoes Realizadas desde a Estruturacao Inicial
Data       Programador     Motivo
/*/
//-------------------------------------------------------------------  
Static Function FCriTxt(cAlias,dDatIniFi,dDatFinFi,cArqPath,lRetTXT,aRetLog,nTipoEnvi,cCNOJEmpO,nTipEmpEn)

Local lRetTXT  := .T.
Local nHandle	:= 0
Local nXI		:= 0
Local cCodVin	:= ""
Local aContLin := {0,0,0,0,0,0,0,0}

nHandle 	:= FCreate(AllTrim(cArqPath)+".TXT")

If (nHandle > -1)

   AADD(aRetLog,"Caminho e Nome do Arquivo criado: "+cArqPath)

	//Gera Registro 
  	FWrite(nHandle, "00" +; // Identificação Registro Header = 00
  	                "RELATO COMP NEGOCIOS"+; //Constante = ‘RELATO COMP NEGOCIOS’ Ajuste à esquerda com brancos à direta
  	                Iif(nTipEmpEn == 1,"70963418000180",cCNOJEmpO)+; //SM0->M0_CGC+; //CNPJ Empresa Conveniada – informar: (Nr base 8 dígitos numéricos + matriz/filial 4 dígitos numéricos + dígito de controle 2 numéricos).
  	                DToS(dDatIniFi)+; //Para remessa Normal Informar: Data Início do Período Informado : AAAAMMDD Para remessa de Conciliação Informar: Constante = ‘CONCILIA’
  	                DToS(dDatFinFi)+; // Data Final do Período Informado : AAAAMMDD 
  	                "S"+; // Periodicidade da remessa. Indicar a constante  conforme a periodicidade D=Diário M=Mensal S=Semanal Q=Quinzenal 
  	                Space(15) +; // Reservado Serasa
  	                Space(03) +; // Número identificador do Grupo Relato Segmento ou brancos.
  	                Space(29) +; // Brancos.
  	                "V."+; // Identificação da Versão do Layout => Fixo = “V.”
  	                "01"+; // Número da Versão do Layout => Fixo = “01”.
  	                Space(26)+; // Brancos.
  	                CRLF)

	aContLin[1]  += 1

	(cAlias)->(dbGoTop())

	While (cAlias)->(! Eof())


		//Gera Registro do Tipo 2 
		FWrite(nHandle, "01" +; // Identificação do Registro de Dados = 01
	                   (cAlias)->A1_CGC+; // Sacado Pessoa jurídica: CNPJ Empresa Cliente (Sacado) - informar: (Nr base 8 dígitos numéricos + matriz/filial 4 dígitos numéricos + dígito de controle 2 numéricos).
 	  		             "01"+; // Tipo de Dados=  01 (Tempo de Relacionamento para Sacado Pessoa Jurídica)
 	     		          (cAlias)->A1_PRICOM+; // Tipo de Saldo Tam 15 (Devedor ou Credor)
 	        		       (cAlias)->A1_TEMPO+; // Tipo de Conta Tam 15 (Analitica ou Sintetica)
  	  	         	    Space(38)+; // Brancos
  	  	         	    Space(34)+; // Brancos
  	  	         	    Space(01)+; // Brancos
  	  	         	    Space(30)+; // Brancos
	               	 CRLF)
		aContLin[2]  += 1

		cGCGAnt := (cAlias)->A1_CGC
		
		While (cAlias)->(! Eof()) .And. ;
				(cAlias)->A1_CGC == cGCGAnt

			cTitAux :=  (cAlias)->EMPFIL+"]"+(cAlias)->E1_PREFIXO+"/"+(cAlias)->E1_NUM+"-"+(cAlias)->E1_PARCELA

			//Gera Registro do Tipo 2 
			FWrite(nHandle, "01" +; // Identificação do Registro de Dados = 01
		                   (cAlias)->A1_CGC+; // Sacado Pessoa jurídica: CNPJ Empresa Cliente (Sacado) - informar: (Nr base 8 dígitos numéricos + matriz/filial 4 dígitos numéricos + dígito de controle 2 numéricos).
 	  			             "05"+; //Tipo de Dados =  05 (Títulos  –  Para Sacado  Pessoa Jurídica)
 	  	   		          Replicate("0",10)+; // Número do Título com até 10 posições
 	  	   		          (cAlias)->E1_EMISSAO+; // Data da Emissão do título: AAAAMMDD 
 	  	      		       StrZero(((cAlias)->E1_VALOR*100),13)+; // Valor do Título, com 2 casas  decimais. Ajuste à  direita com zeros à esquerda. Formatar 9999999999999 para exclusão do título.
  	  		         	    (cAlias)->E1_VENCTO+; // Data de Vencimento: AAAAMMDD
  	  		         	    (cAlias)->E1_BAIXA+; // Data de Pagamento: AAAAMMDD ou Brancos No arquivo de Conciliação enviado pela Serasa esta  informação estará com o conteúdo 99999999. No arquivo de Conciliação a ser enviado para a  Serasa esta informação deverá ser formatada com a  Data de Pagamento do título OU com Brancos, se o  título não foi pago.
  	  		         	    "#D"+; // Número do Título com mais de 10 posições: 
  	  		         	    cTitAux+Space(32-Len(cTitAux))+; //#D : indica número do título. Obs.: O "#D" pode ser utilizado quando o número do  título for maior que dez posições. Se for informado  "#D" nas posições 66 e 67, o sistema desprezará o  conteúdo das posições 19 a 28 (Número do título), e  considerará como número do título o número  informado nas posições 68 a 99.
  	  		         	    Space(01)+; // Brancos
  	  		         	    Space(24)+; // Reservado Serasa
  	  		         	    Space(02)+; // Reservado Serasa
  	  		         	    Space(01)+; // Reservado Serasa
  	  		         	    Space(01)+; // Reservado Serasa
  	  		         	    Space(02)+; // Reservado Serasa
		  	             	 CRLF)

			aContLin[3]  += 1

			If nTipoEnvi == 2
				If aContLin[3] == 300
					EXIT
				EndIf
			EndIf

	     	(cAlias)->(dbSkip())

		EndDo

		If nTipoEnvi == 2
			If aContLin[3] == 300
				EXIT
			EndIf
		EndIf

	EndDo

	//Gera Registro do Tipo C caso tenha sido selecionada esta opção conforme Detalhamento Funcional.
	FWrite(nHandle,"99" +; // Identificação do Registro Trailler = 99
						StrZero(aContLin[2],11)+; //Quantidade de Registros 01–Tempo de Relacionamento PJ. Ajuste à direita com zeros à esquerda Para remessa de Conciliação formatar zeros.
						Space(44) +; //Brancos.
						StrZero(aContLin[3],11)+; //Quantidade de Registros 05 – Títulos PJ. Ajuste à direita com zeros à esquerda
						Space(11) +; // Reservado Serasa
						Space(11) +; // Reservado Serasa
						Space(10) +; // Reservado Serasa
						Space(30) +; // Brancos.
						CRLF)

   //Fecha o arquivo
   FClose(nHandle)

   U_FCloseArea(cAlias)

   AADD(aRetLog,"Total de Linhas do Tipo 1 no Arquivo: "+TransForm(aContLin[1],"@E 999,999,999.999"))
   AADD(aRetLog,"Total de Linhas do Tipo 2 no Arquivo: "+TransForm(aContLin[2],"@E 999,999,999.999"))
   AADD(aRetLog,"Total de Linhas do Tipo 3 no Arquivo: "+TransForm(aContLin[3],"@E 999,999,999.999"))

Else

   AADD(aRetLog,"Não é possível criar o arquivo no diretorio especificado, verifique com a TI.")
   lRetTXT := .F.

EndIf

Return(lRetTXT)