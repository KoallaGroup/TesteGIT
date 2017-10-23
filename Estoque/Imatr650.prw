#INCLUDE "IMATR650.CH" 
#Include "IFIVEWIN.Ch"

/*
+----------+----------+-------+--------------------------+------+---------------+
|Programa  | IMATR650 | Autor |  Rog�rio Alves  - Anadi  | Data |  Maio/2014    |
+----------+----------+-------+--------------------------+------+---------------+
|Descricao | Altera��o do fonte padr�o da Totvs do relat�rio matr650 de rela��o |
|          | de notas fiscais por transportadora.                               |
+----------+--------------------------------------------------------------------+
|Uso       | Isapa                                                              |
+----------+--------------------------------------------------------------------+
*/


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MATR650  � Autor � Marco Bianchi         � Data � 30/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Notas Fiscais por Transportadora                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � SIGAFAT - R4                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function IMATR650()

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := IReportDef()
	oReport:PrintDialog()
Else
	IMATR650R3()
EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 30/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �ExpO1: Objeto do relat�rio                                  ���
�������������������������������������������������������������������������Ĵ��
���Parametros�Nenhum                                                      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IReportDef()

Local oReport
Local nQuant    := 0
Local lValadi	:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico 

#IFDEF TOP
	Local cAliasQry := GetNextAlias()
#ELSE
	Local cAliasQry := "SF2"
#ENDIF	

//������������������������������������������������������������������������Ŀ
//�Criacao do componente de impressao                                      �
//�                                                                        �
//�TReport():New                                                           �
//�ExpC1 : Nome do relatorio                                               �
//�ExpC2 : Titulo                                                          �
//�ExpC3 : Pergunte                                                        �
//�ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  �
//�ExpC5 : Descricao                                                       �
//�                                                                        �
//��������������������������������������������������������������������������
oReport := TReport():New("IMATR650",STR0013,"IMTR650", {|oReport| IReportPrint(oReport,cAliasQry)},STR0014 + " " + STR0015)	// "Relacao das Notas Fiscais para as Transportadoras"###"Este programa ira emitir a relacao de notas fiscais por"###"ordem de Transportadora."
oReport:SetPortrait() 
oReport:SetTotalInLine(.F.)

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
Pergunte(oReport:uParam,.F.)

//��������������������������������������������������������������Ŀ
//� Definicao da Secao                                           �
//����������������������������������������������������������������
oNFTransp := TRSection():New(oReport,STR0024,{"SF2","SD2","SA4"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao das Notas Fiscais para as Transportadoras"	
oNFTransp:SetTotalInLine(.F.)

TRCell():New(oNFTransp,"CTEXTO"		,/*Tabela*/ ,STR0016				,/*Picture*/					,11							,/*lPixel*/,{|| STR0017															})	// "Data Hora"
TRCell():New(oNFTransp,"F2_DOC"		,"SF2"		,RetTitle("F2_DOC")		,PesqPict("SF2","F2_DOC")		,TamSx3("F2_DOC"		)[1],/*lPixel*/,{|| (cAliasQry)->F2_DOC 											},,,,,,.F.)	// Numero da Nota Fiscal
TRCell():New(oNFTransp,"F2_SERIE"	,"SF2"		,RetTitle("F2_SERIE")	,PesqPict("SF2","F2_SERIE")		,TamSx3("F2_SERIE"		)[1],/*lPixel*/,{|| (cAliasQry)->F2_SERIE 											})	// Serie
TRCell():New(oNFTransp,"F2_VOLUME1"	,"SF2"		,STR0023				,PesqPict("SF2","F2_VOLUME1")	,TamSx3("F2_VOLUME1"	)[1],/*lPixel*/,{|| (cAliasQry)->F2_VOLUME1 										})	// "Volume"
TRCell():New(oNFTransp,"CNOME"		,/*Tabela*/	,STR0018				,PesqPict("SA1","A1_NOME")		,TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| IIF((cAliasQry)->F2_TIPO $ "NCIP",SA1->A1_NOME,SA2->A2_NOME) 	})	// "N o m e  do  C l i e n t e"
TRCell():New(oNFTransp,"NQUANT"		,/*Tabela*/	,STR0019				,PesqPict("SD2","D2_QUANT")		,TamSx3("D2_QUANT"		)[1],/*lPixel*/,{|| nQuant 															})	// "Quantidade"
If lValadi
	TRCell():New(oNFTransp,"NVALADI",/*Tabela*/	,RetTitle("F2_VALADI")	,PesqPict("SF2","F2_VALADI")	,TamSx3("F2_VALADI"		)[1],/*lPixel*/,{|| nValadi 														})	// "Adiantamento"
EndIf
TRCell():New(oNFTransp,"F2_VALBRUT"	,"SF2"		,RetTitle("F2_VALBRUT")	,PesqPict("SF2","F2_VALBRUT")	,TamSx3("F2_VALBRUT"	)[1],/*lPixel*/,{|| xMoeda((cAliasQry)->F2_VALBRUT,1,mv_par05,(cAliasQry)->F2_EMISSAO)})	// Valor Bruto
TRCell():New(oNFTransp,"CMUN"		,/*Tabela*/ ,STR0020				,PesqPict("SA1","A1_MUN")		,TamSx3("A1_MUN"		)[1],/*lPixel*/,{|| IIF((cAliasQry)->F2_TIPO $ "NCIP",SA1->A1_MUN,SA2->A2_MUN) 		})	// "Municipio"
TRCell():New(oNFTransp,"CEST"		,/*Tabela*/	,RetTitle("A1_EST")		,PesqPict("SA1","A1_EST")		,TamSx3("A1_EST"		)[1],/*lPixel*/,{|| IIF((cAliasQry)->F2_TIPO $ "NCIP",SA1->A1_EST,SA2->A2_EST) 		})	// Estado
TRCell():New(oNFTransp,"F2_PBRUTO"	,"SF2"		,RetTitle("F2_PBRUTO")	,PesqPict("SF2","F2_PBRUTO")	,TamSx3("F2_PBRUTO"		)[1],/*lPixel*/,{|| (cAliasQry)->F2_PBRUTO 										})	// Peso Bruto

TRFunction():New(oNFTransp:Cell("F2_DOC"		),/* cID */,"COUNT"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("F2_VOLUME1"	),/* cID */,"SUM"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("NQUANT"		),/* cID */,"SUM"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
If lValadi
	TRFunction():New(oNFTransp:Cell("NVALADI"		),/* cID */,"SUM"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
EndIf
TRFunction():New(oNFTransp:Cell("F2_VALBRUT"	),/* cID */,"SUM"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
TRFunction():New(oNFTransp:Cell("F2_PBRUTO"		),/* cID */,"SUM"	,/*oBreak*/,/*cTitle*/,/*cPicture*/,/*uFormula*/,.T./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)

//������������������������������������������������������������������������Ŀ
//� Impressao do Cabecalho no top da pagina                                �
//��������������������������������������������������������������������������
oReport:Section(1):SetHeaderPage()

//������������������������������������������������������������������������Ŀ
//� Salta Pagina na Quebra da Secao                                        �
//��������������������������������������������������������������������������
oNFTransp:SetPageBreak(.T.)

//������������������������������������������������������������������������Ŀ
//� Posiciona Trsnsportadora                                               �
//��������������������������������������������������������������������������
TRPosition():New(oReport:Section(1),"SA4",1,{|| xFilial("SA4")+(cAliasQry)->F2_TRANSP})

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 30/06/06 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao estatica ReportDef devera ser criada para todos os ���
���          �relatorios que poderao ser agendados pelo usuario.          ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                      ���
�������������������������������������������������������������������������Ĵ��
���Parametros�ExpO1: Objeto Report do Relat�rio                           ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���   DATA   � Programador   �Manutencao efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IReportPrint(oReport,cAliasQry)

Local cTransp 	:= ""
Local lValadi	:= cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
Local cExpAdi	:= Iif(lValadi,"%MIN(F2_VALADI) F2_VALADI,%","%%")

#IFNDEF TOP
	Local cCondicao := ""
#ELSE
	Local cWhere    := ""
#ENDIF

//��������������������������������������������������������������Ŀ
//� SetBlock: faz com que as variaveis locais possam ser         �
//� utilizadas em outras funcoes nao precisando declara-las      �
//� como private											  	 �
//����������������������������������������������������������������
oReport:Section(1):Cell("NQUANT" 	):SetBlock({|| nQuant		})

//��������������������������������������������������������������Ŀ
//� Altera o Titulo do Relatorio de acordo com parametros	 	 �
//����������������������������������������������������������������
oReport:SetTitle(oReport:Title() + " - " + GetMv("MV_MOEDA"+STR(mv_par05,1)) )	// "Relacao das Notas Fiscais para as Transportadoras"	

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
#IFDEF TOP

	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	
	cWhere := "% AND NOT ("+IsRemito(2,'F2_TIPODOC')+")"
	If mv_par09 == 1 
		cWhere += " AND F2_TIPO <> 'D'"
	EndIf		
	If mv_par08 == 1 
		cWhere += " AND F2_TIPO <> 'B'"
	EndIf	
	cWhere += "%"
	
	dbSelectArea("SF2")				// Cabecalho da Nota de Saida
	dbSetOrder(1)					// Documento,Serie,Cliente,Loja
	
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasQry

	SELECT MIN(F2_FILIAL) F2_FILIAL, MIN(F2_TIPO) F2_TIPO, F2_DOC, F2_SERIE, MIN(F2_EMISSAO) F2_EMISSAO,
	MIN(F2_CLIENTE) F2_CLIENTE ,MIN(F2_LOJA) F2_LOJA ,MIN(F2_TRANSP) F2_TRANSP ,MIN(F2_VOLUME1) F2_VOLUME1,
	%Exp:cExpAdi%
	MIN(F2_VALBRUT) F2_VALBRUT,MIN(F2_PBRUTO) F2_PBRUTO ,MIN(A4_NOME) A4_NOME ,SUM(D2_QUANT) TOTQUANT
	
	FROM %Table:SF2% SF2
	LEFT JOIN  %Table:SA4% SA4
	ON A4_FILIAL = %xFilial:SA4%
	AND A4_COD = F2_TRANSP
	AND SA4.%notdel%, %Table:SD2% SD2
		
	WHERE F2_FILIAL = %xFilial:SF2%
		AND F2_DOC >= %Exp:mv_par03% AND F2_DOC <= %Exp:mv_par04%
		AND F2_EMISSAO >= %Exp:DTOS(mv_par06)% AND F2_EMISSAO <= %Exp:DTOS(mv_par07)%
		AND F2_TRANSP >= %Exp:mv_par01% AND F2_TRANSP <= %Exp:mv_par02%
		AND F2_DOC = D2_DOC AND F2_SERIE = D2_SERIE
		AND SF2.%NotDel%
		AND SD2.%NotDel%
		%Exp:cWhere%
	GROUP BY F2_DOC,F2_SERIE
	ORDER BY F2_FILIAL,F2_TRANSP,F2_DOC,F2_SERIE
	EndSql 
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	dbSelectArea(cAliasQry)			// Cabecalho da Nota de Saida
	dbSetOrder(1)					// Documento,Serie,Cliente,Loja
	cCondicao   := "F2_FILIAL == '"+xFilial("SF2")+"' "
	cCondicao   += " .And. F2_DOC >= '"+mv_par03+"' .And. F2_DOC <= '"+mv_par04+"'"
	cCondicao   += " .And. Dtos(F2_EMISSAO) >= '"+Dtos(mv_par06)+"' .And. Dtos(F2_EMISSAO) <= '"+Dtos(mv_par07)+"'"
	cCondicao   += " .And. F2_TRANSP >= '"+mv_par01+"' .And. F2_TRANSP <= '"+mv_par02+"'"
	If mv_par09 == 1 
		cCondicao   += " .And. F2_TIPO <> 'D'"
	EndIf
	cCondicao   += " .And. !("+IsRemito(2,'SF2->F2_TIPODOC')+")"			
	If mv_par08 == 1 
		cCondicao += " .And. F2_TIPO <> 'B'"
	EndIf	
    
	oReport:Section(1):SetFilter(cCondicao,"F2_FILIAL+F2_TRANSP+F2_DOC+F2_SERIE")

#ENDIF		


//������������������������������������������������������������������������Ŀ
//�Inicio da impressao do fluxo do relat�rio                               �
//��������������������������������������������������������������������������
oReport:SetMeter((cAliasQry)->(LastRec()))
dbSelectArea(cAliasQry)
oReport:Section(1):Init()
                          
While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2")=F2_FILIAL

	//������������������������������������������������������������������������Ŀ
	//� Posiciona Transportadora                                               �
	//��������������������������������������������������������������������������
	cTransp := (cAliasQry)->F2_TRANSP
	#IFNDEF TOP
		dbSelectArea("SA4") 
		dbSetOrder(1)
		dbSeek(xFilial("SA4")+cTransp)
	#ENDIF
	
	oReport:PrintText(STR0022 + " " + (cAliasQry)->F2_TRANSP + " - " + A4_NOME)	// "Transportadora"
	oReport:SkipLine()

	dbSelectArea(cAliasQry)	
	While !oReport:Cancel() .And. !(cAliasQry)->(Eof()) .And. xFilial("SF2") = F2_FILIAL .And. F2_TRANSP = cTransp 

		#IFNDEF TOP
			dbSelectArea("SD2")
			dbSetorder(3)
			dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
			cNota := SF2->F2_DOC+SF2->F2_SERIE
			nQuant:=0
			While cFilial=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE == cNota
				nQuant += D2_QUANT
				dbSkip()
			End
		#ELSE
			nQuant := (cAliasQry)->TOTQUANT
		#ENDIF
		
		nValadi	:= Iif(lValadi,(cAliasQry)->F2_VALADI,0)
		
		If !(cAliasQry)->F2_TIPO $ "DB"
			TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
		Else
			TRPosition():New(oReport:Section(1),"SA2",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA })
		Endif	
		oReport:Section(1):PrintLine()
		dbSelectArea(cAliasQry)
		dbSkip()
		oReport:IncMeter()
	End
	
	oReport:Section(1):SetTotalText(STR0021 + " " + cTransp)	// "Total da Transportadora"
	oReport:Section(1):Finish()

	// Forca salto de pagina no fim da secao
	oReport:nrow := 5000			
	oReport:skipLine()
	
	oReport:Section(1):Init()
	
End

oReport:Section(1):SetPageBreak(.T.)

//��������������������������������������������������������������Ŀ
//� Fecha Query/SetFilter                                        �
//����������������������������������������������������������������
(cAliasQry)->(dbCloseArea())

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR650R3� Autor � Wagner Xavier         � Data � 05.09.91 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relacao de Notas Fiscais por Transportadora                ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe e � MATR650R3(void)                                            ���
�������������������������������������������������������������������������Ĵ��
���Parametros� Verificar indexacao dentro de programa (provisoria)        ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
���Viviani       �09/11/98�Melhor�Conversao utillizando xMoeda            ���
���Viviani       �23/12/98�18923 �Acerto do calculo do valor total da nota���
���              �        �      �para aceitar produto negativo(desconto) ���
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ��� 
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IMatr650R3()
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt,titulo
LOCAL cDesc1 :=OemToAnsi(STR0001)	//"Este programa ira emitir a relacao de notas fiscais por"
LOCAL cDesc2 :=OemToAnsi(STR0002)	//"ordem de Transportadora."
LOCAL cDesc3 :=""
LOCAL CbCont,wnrel
LOCAL tamanho:="M"
LOCAL limite :=132
LOCAL cString:="SF2"

PRIVATE aReturn := { STR0003, 1,STR0004, 1, 2, 1, "",1 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="IMATR650"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="IMTR650"
PRIVATE cVolPict:=PesqPict("SF2","F2_VOLUME1",8)

//��������������������������������������������������������������Ŀ
//� Monta cabecalhos e verifica tipo de impressao                �
//����������������������������������������������������������������
titulo := OemToAnsi(STR0005)	//"Relacao das Notas Fiscais para as Transportadoras"


//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Imporessao do Cabecalho e Rodape   �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("IMTR650",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Da Transportadora                        �
//� mv_par02        	// Ate a Transportadora                     �
//� mv_par03        	// Da Nota                                  �
//� mv_par04        	// Ate a Nota                               �
//� mv_par05        	// Qual moeda                               �
//� mv_par06        	// Da Emissao                               �
//� mv_par07        	// Ate Emissao                              �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="IMATR650"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",,Tamanho)

If nLastKey==27
	dbClearFilter()
   Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
   Return
Endif

RptStatus({|lEnd| IC650Imp(@lEnd,wnRel,cString)},Titulo)

Return 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C650IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR650			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IC650Imp(lEnd,WnRel,cString)

//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt,titulo

LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:="M"
LOCAL nNumNota,nTotVol,nTotQtde,nTotPeso,nTotVal,nQuant,lContinua:=.T.
LOCAL nTamNF := TamSX3("F2_DOC")[1]
Local cCond  := ""
//��������������������������������������������������������������Ŀ
//� Monta cabecalhos e verifica tipo de impressao                �
//����������������������������������������������������������������
titulo := STR0006 + " - " + GetMv("MV_MOEDA" + STR(MV_PAR05,1))//"RELACAO DAS NOTAS FISCAIS PARA AS TRANSPORTADORAS - MOEDA"
cabec1 := IIF(mv_par08==1,STR0007,STR0012)	//"REC.DEP  |EMPRESA N.FISCAL          VOLUME  N O M E  D O  C L I E N T E    QUANTIDADE        VALOR  MUNICIPIO        UF  PESO BRUTO "
*****      				012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
*****      				0         1         2         3         4         5         6         7         8         9        10        11        12        13        14
cabec2 := STR0008	//"DATA HORA|"

nTipo  := IIF(aReturn[4]==1,15,18)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Imporessao do Cabecalho e Rodape   �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       :=80
m_pag    :=1

dbSelectArea("SF2")
cIndice := criatrab("",.f.)
cCond   := "Dtos(F2_EMISSAO)>='"+Dtos(mv_par06)+"'.And.Dtos(F2_EMISSAO)<='"+Dtos(mv_par07)+"'"
cCond   += " .And. !("+IsRemito(2,'SF2->F2_TIPODOC')+")"			

IndRegua("SF2",cIndice,"F2_FILIAL+F2_TRANSP+F2_DOC+F2_SERIE",,cCond,STR0009)		//"Selecionando Registros..."
	
dbSeek(cFilial+mv_par01,.T.)
SetRegua(RecCount())		// Total de Elementos da regua

While !Eof() .And. cFilial=F2_FILIAL .And. F2_TRANSP >= mv_par01 .And. F2_TRANSP <= mv_par02 .And. lContinua

	If F2_TIPO == "D"
		DbSkip()
		Loop
	EndIf
	
	If mv_par08 == 1 .And. F2_TIPO == "B"
		DbSkip()
		Loop
	EndIf	

	IF lEnd
		@PROW()+1,001 Psay STR0010	//"CANCELADO PELO OPERADOR"
		EXIT
	ENDIF
	IncRegua()

	IF F2_DOC < mv_par03 .OR. F2_DOC > mv_par04
		dbSkip()
		Loop
	EndIF
	li := 80
	nNumNota:=nTotVol:=nTotQtde:=nTotPeso:=nTotVal:=nQuant:=0
	cTransp := F2_TRANSP
	dbSelectArea("SA4")
	dbSeek(cFilial+cTransp)
	dbSelectArea("SF2")
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
	@ li,04 Psay '|    | ' + F2_TRANSP + ' - ' + PadR(SA4->A4_NOME,40)
	li++
	@ li,04 Psay '|    | '
	
	While !EOF() .AND. cFilial=F2_FILIAL .And. F2_TRANSP=cTransp 

		IF lEnd
			@PROW()+1,001 Psay STR0010		//"CANCELADO PELO OPERADOR"
			lContinua := .F.
			Exit
		Endif
		IncRegua()

		IF (F2_DOC < mv_par03 .OR. F2_DOC > mv_par04) 
			dbSkip()
			Loop
		EndIF
		
		If F2_TIPO == "D"
			DbSkip()
			Loop
		EndIf
	
		If mv_par08 == 1 .And. F2_TIPO == "B"
			DbSkip()
			Loop
		EndIf	
		
		dbSelectArea("SD2")
		dbSetorder(3)
		dbSeek(cFilial+SF2->F2_DOC+SF2->F2_SERIE)
		cNota := SF2->F2_DOC+SF2->F2_SERIE
		While cFilial=D2_FILIAL .And. !Eof() .And. D2_DOC+D2_SERIE == cNota
			nQuant += D2_QUANT
			dbSkip()
		End

		IF li > 53
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		EndIF
		
		li++
		@ li,004 Psay '|    | '
		@ li,018 Psay Substr(cNota,1,ntamNF) +"-"+Substr(cNota,nTamNF+1,3)
		dbSelectArea("SF2")
		@ li,035 Psay F2_VOLUME1   PicTure cVolPict 
		If F2_TIPO <> "B"
			dbSelectArea("SA1")
			dbSeek(cFilial+SF2->F2_CLIENTE+SF2->F2_LOJA)
			IF Found()
				@ li,044 Psay SUBSTR(A1_NOME,1,25)
			EndIF
		Else
			dbSelectArea("SA2")
			dbSeek(cFilial+SF2->F2_CLIENTE+SF2->F2_LOJA)
			IF Found()
				@ li,044 Psay SUBSTR(A2_NOME,1,25)
			EndIF
		Endif	
		dbSelectArea("SF2")
		@ li,071 Psay nQuant		PicTure tm(nQuant,11)
		@ li,083 Psay xMoeda(F2_VALBRUT,1,mv_par05,F2_EMISSAO) PicTure TM(F2_VALBRUT,15)
		@ li,100 Psay IIF(F2_TIPO<>"B",PadR(SA1->A1_MUN,15),PadR(SA2->A2_MUN,15))
		@ li,117 Psay IIF(F2_TIPO<>"B",SA1->A1_EST,SA2->A2_EST)
		@ li,122 Psay F2_PBRUTO	Picture TM(F2_PBRUTO,9)
		nNumNota++
		nTotVol += F2_VOLUME1
		nTotQtde+= nQuant
		nTotVal += F2_VALBRUT
		nTotPeso+= F2_PBRUTO
		nQuant := 0
		dbSkip()
	End
	li++
	@ li,04 Psay '|    |'
	li++
	@ li,00 Psay __PrtFatLine()
	li++
	@ li,002 Psay STR0011	//"TOTAL ------->"
	@ li,018 Psay nNumNota	PicTure '999'
	@ li,035 Psay nTotVol   PicTure cVolPict
	@ li,071 Psay nTotQtde	PicTure tm(nTotQtde,11)
	@ li,083 Psay xMoeda(nTotVal,1,mv_par05,F2_EMISSAO)	PicTure tm(nTotVal,15)
	@ li,122 Psay nTotPeso	PicTure tm(nTotPeso,9)
	li++
	@ li,00 Psay __PrtFatLine()
	dbSelectArea("SF2")
	nNumNota := 0
	nTotVol := 0
	nTotQtde := 0
	nTotVal := 0
	nTotPeso := 0
End

If li != 80
roda(cbcont,cbtxt)
Endif

RetIndex("SF2")
dbClearFilter()
fErase(cIndice+OrdBagExt())

dbSelectArea("SD2")
dbSetOrder(1)


If aReturn[5] = 1
	Set Printer TO 
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()
