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

Local aTitWin	:= {"Gera��o do arquivo com SERASA Mensal."}
Local cDescr	:= "Este programa ir� realizar a Exporta��o dos dados para SERASA."
Local cFunImp	:= "FFINP02" //Fun��o que ser� chamada pelo Wizard.
Local cSemaf	:= "MCFINP02" //Sem�foro para a rotina n�o ser executada simultanamente na mesma empresa
Local aConArq	:= {{"Exporta��o",.F.,"TXT |*.txt| ","Arquivo TXT","{|| Iif(FExistFile(aFile[1],.F.,2,cGetMes,cGetAno,aDadWzd,aConArq) .Or. Empty(aFile[1]),.T.,.F.)}"}}

//Funcao para criar/ajustar o grupo de perguntas da SX1
//FSAjuSX1(cValPeg)

//Chama a funcao do apWizard
U_FSWizImp(cFunImp   ,cSemaf  ,aTitWin[1]   ,cDescr,1      ,2      ,"Exporta��o",.F.    ,"01_02_03_04_05_06_07_08_09_10_11_12_",aConArq)

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
// 7 - Valida��o Campo
// 8 a 12 Op��es.
// 13 - Texto do Help Tamanho Linha                                       '1234567890123456789012345678901234567890' )
//             1                   2   3  4  5   6  7  8  9  10 11 12  13
Aadd(aPergAux,{"Data Inicial"    	,"D",08,00,"G","","","","","","","","Informe Data Inicial"})
Aadd(aPergAux,{"Data Final"      	,"D",08,00,"G","","","","","","","","Informe Data Final"})
Aadd(aPergAux,{"Tipo Envio"       	,"N",01,00,"C","","","Producao","Homologa��o","","","","Informe Tipo de Envio"})
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
@param     dDatIniFi  - Data Inicial do Per�odo Cont�bil
			  dDatFinFi  - Data Final do Per�odo Cont�bil

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
	AADD(aRetLog,"Cancelada a Tela de Par�metros de Data.")
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
	   AADD(aRetLog,"N�o foi poss�vel localizar nenhum registro com os par�metros informados, verifique e tente novamente.")
	EndIf
Else
   AADD(aRetLog,"Favor preencher todos os campos de Data para gera��o do Arquivo TXT. Data Inicial ou Final est�o vazios.")
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

	//Monta o arquivo de trabalho com as informacoes para gera��o do arquivo texto.
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
@param     cAlias     - Nome do Arquivo de Trabalho tempor�rio criado para Gera��o do Arquivo Texto
           dDatIniFi  - Data Inicial do Per�odo Cont�bil
			  dDatFinFi  - Data Final do Per�odo Cont�bil
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
  	FWrite(nHandle, "00" +; // Identifica��o Registro Header = 00
  	                "RELATO COMP NEGOCIOS"+; //Constante = �RELATO COMP NEGOCIOS� Ajuste � esquerda com brancos � direta
  	                Iif(nTipEmpEn == 1,"70963418000180",cCNOJEmpO)+; //SM0->M0_CGC+; //CNPJ Empresa Conveniada � informar: (Nr base 8 d�gitos num�ricos + matriz/filial 4 d�gitos num�ricos + d�gito de controle 2 num�ricos).
  	                DToS(dDatIniFi)+; //Para remessa Normal Informar: Data In�cio do Per�odo Informado : AAAAMMDD Para remessa de Concilia��o Informar: Constante = �CONCILIA�
  	                DToS(dDatFinFi)+; // Data Final do Per�odo Informado : AAAAMMDD 
  	                "S"+; // Periodicidade da remessa. Indicar a constante  conforme a periodicidade D=Di�rio M=Mensal S=Semanal Q=Quinzenal 
  	                Space(15) +; // Reservado Serasa
  	                Space(03) +; // N�mero identificador do Grupo Relato Segmento ou brancos.
  	                Space(29) +; // Brancos.
  	                "V."+; // Identifica��o da Vers�o do Layout => Fixo = �V.�
  	                "01"+; // N�mero da Vers�o do Layout => Fixo = �01�.
  	                Space(26)+; // Brancos.
  	                CRLF)

	aContLin[1]  += 1

	(cAlias)->(dbGoTop())

	While (cAlias)->(! Eof())


		//Gera Registro do Tipo 2 
		FWrite(nHandle, "01" +; // Identifica��o do Registro de Dados = 01
	                   (cAlias)->A1_CGC+; // Sacado Pessoa jur�dica: CNPJ Empresa Cliente (Sacado) - informar: (Nr base 8 d�gitos num�ricos + matriz/filial 4 d�gitos num�ricos + d�gito de controle 2 num�ricos).
 	  		             "01"+; // Tipo de Dados=  01 (Tempo de Relacionamento para Sacado Pessoa Jur�dica)
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
			FWrite(nHandle, "01" +; // Identifica��o do Registro de Dados = 01
		                   (cAlias)->A1_CGC+; // Sacado Pessoa jur�dica: CNPJ Empresa Cliente (Sacado) - informar: (Nr base 8 d�gitos num�ricos + matriz/filial 4 d�gitos num�ricos + d�gito de controle 2 num�ricos).
 	  			             "05"+; //Tipo de Dados =  05 (T�tulos  �  Para Sacado  Pessoa Jur�dica)
 	  	   		          Replicate("0",10)+; // N�mero do T�tulo com at� 10 posi��es
 	  	   		          (cAlias)->E1_EMISSAO+; // Data da Emiss�o do t�tulo: AAAAMMDD 
 	  	      		       StrZero(((cAlias)->E1_VALOR*100),13)+; // Valor do T�tulo, com 2 casas  decimais. Ajuste �  direita com zeros � esquerda. Formatar 9999999999999 para exclus�o do t�tulo.
  	  		         	    (cAlias)->E1_VENCTO+; // Data de Vencimento: AAAAMMDD
  	  		         	    (cAlias)->E1_BAIXA+; // Data de Pagamento: AAAAMMDD ou Brancos No arquivo de Concilia��o enviado pela Serasa esta  informa��o estar� com o conte�do 99999999. No arquivo de Concilia��o a ser enviado para a  Serasa esta informa��o dever� ser formatada com a  Data de Pagamento do t�tulo OU com Brancos, se o  t�tulo n�o foi pago.
  	  		         	    "#D"+; // N�mero do T�tulo com mais de 10 posi��es: 
  	  		         	    cTitAux+Space(32-Len(cTitAux))+; //#D : indica n�mero do t�tulo. Obs.: O "#D" pode ser utilizado quando o n�mero do  t�tulo for maior que dez posi��es. Se for informado  "#D" nas posi��es 66 e 67, o sistema desprezar� o  conte�do das posi��es 19 a 28 (N�mero do t�tulo), e  considerar� como n�mero do t�tulo o n�mero  informado nas posi��es 68 a 99.
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

	//Gera Registro do Tipo C caso tenha sido selecionada esta op��o conforme Detalhamento Funcional.
	FWrite(nHandle,"99" +; // Identifica��o do Registro Trailler = 99
						StrZero(aContLin[2],11)+; //Quantidade de Registros 01�Tempo de Relacionamento PJ. Ajuste � direita com zeros � esquerda Para remessa de Concilia��o formatar zeros.
						Space(44) +; //Brancos.
						StrZero(aContLin[3],11)+; //Quantidade de Registros 05 � T�tulos PJ. Ajuste � direita com zeros � esquerda
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

   AADD(aRetLog,"N�o � poss�vel criar o arquivo no diretorio especificado, verifique com a TI.")
   lRetTXT := .F.

EndIf

Return(lRetTXT)