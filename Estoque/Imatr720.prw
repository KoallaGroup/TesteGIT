#INCLUDE "IMATR720.CH"
#Include "IFIVEWIN.Ch" 
#include "protheus.ch"
#include "rwmake.ch" 

/*
+------------+----------+--------+--------------------+-------+---------------+
| Programa:  | IMATR720 | Autor: | Rog�rio Alves      | Data: |   Junho/2014  |
+------------+----------+--------+--------------------+-------+---------------+
| Descri��o: | Relatorio com alteracoes do original da minuta de despacho     |
+------------+----------------------------------------------------------------+
| Uso:       | Isapa                                                          |
+------------+----------------------------------------------------------------+
*/

USER Function IMATR720()

Local oReport

//If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
//	oReport := IReportDef() //PERSONALIZADO SIM
//	oReport:PrintDialog()
//Else
	IMATR720R3()//PERSONALIZADO NAO
//EndIf

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportDef � Autor � Marco Bianchi         � Data � 12/07/06 ���
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
Static Function IReportDef()	//PERSONALIZADO SIM

Local oReport
Local lValadi  := cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
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
oReport := TReport():New("IMATR720",STR0024,"IMTR720", {|oReport| IReportPrint(oReport,cAliasQry)},STR0022 + " " + STR0023)	// "RECIBO PARA DESPACHO"###"Este relatorio ira emitir a relacao de Recibos"###"de Despacho para as transportadoras."
oReport:SetPortrait()
oReport:SetTotalInLine(.F.)

Pergunte(oReport:uParam,.F.)
//������������������������������������������������������������������������Ŀ
//�Criacao da secao utilizada pelo relatorio                               �
//�                                                                        �
//�TRSection():New                                                         �
//�ExpO1 : Objeto TReport que a secao pertence                             �
//�ExpC2 : Descricao da se�ao                                              �
//�ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   �
//�        sera considerada como principal para a se��o.                   �
//�ExpA4 : Array com as Ordens do relat�rio                                �
//�ExpL5 : Carrega campos do SX3 como celulas                              �
//�        Default : False                                                 �
//�ExpL6 : Carrega ordens do Sindex                                        �
//�        Default : False                                                 �
//�                                                                        �
//��������������������������������������������������������������������������
oRecDesp := TRSection():New(oReport,STR0021,{"SF2"},/*{Array com as ordens do relat�rio}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "RECIBO PARA DESPACHO"
oReport:Section(1):SetLineStyle()
oReport:Section(1):SetCols(1)

TRCell():New(oRecDesp,"F2_DOC","SF2",RetTitle("F2_DOC"),PesqPict("SF2","F2_DOC"),TamSx3("F2_DOC")[1],/*lPixel*/,{|| (cAliasQry)->F2_DOC  }	)
TRCell():New(oRecDesp,"F2_VALBRUT","SF2",RetTitle("F2_VALBRUT"),PesqPict("SF2","F2_VALBRUT"),TamSx3("F2_VALBRUT")[1],/*lPixel*/,{|| (cAliasQry)->F2_VALMERC+(cAliasQry)->F2_VALIPI+(cAliasQry)->F2_FRETE+(cAliasQry)->F2_SEGURO+(cAliasQry)->F2_ICMSRET  }	)
If lValadi
	TRCell():New(oRecDesp,"F2_VALADI","SF2",RetTitle("F2_VALADI"),PesqPict("SF2","F2_VALADI"),TamSx3("F2_VALADI")[1],/*lPixel*/,{|| (cAliasQry)->F2_VALADI  }	)
EndIf

TRCell():New(oRecDesp,"A1_NOME","SA1",RetTitle("A1_NOME"),PesqPict("SA1","A1_NOME"),TamSx3("A1_NOME")[1],/*lPixel*/,{|| SA1->A1_NOME  }	)
TRCell():New(oRecDesp,"A1_END","SA1",RetTitle("A1_END"),PesqPict("SA1","A1_END"),TamSx3("A1_END")[1],/*lPixel*/,{|| SA1->A1_END  }	)
TRCell():New(oRecDesp,"A1_ENDENT","SA1",RetTitle("A1_ENDENT"),PesqPict("SA1","A1_ENDENT"),TamSx3("A1_ENDENT")[1],/*lPixel*/,{|| SA1->A1_ENDENT  }	)
TRCell():New(oRecDesp,"A1_BAIRRO","SA1",RetTitle("A1_BAIRRO"),PesqPict("SA1","A1_BAIRRO"),TamSx3("A1_BAIRRO")[1],/*lPixel*/,{|| SA1->A1_BAIRRO  }	)
TRCell():New(oRecDesp,"A1_MUN","SA1",RetTitle("A1_MUN"),PesqPict("SA1","A1_MUN"),TamSx3("A1_MUN")[1],/*lPixel*/,{|| SA1->A1_MUN  }	)
TRCell():New(oRecDesp,"A1_EST","SA1",RetTitle("A1_EST"),PesqPict("SA1","A1_EST"),TamSx3("A1_EST")[1],/*lPixel*/,{|| SA1->A1_EST  }	)

TRCell():New(oRecDesp,"A2_NOME","SA2",RetTitle("A2_NOME"),PesqPict("SA2","A2_NOME"),TamSx3("A2_NOME")[1],/*lPixel*/,{|| SA2->A2_NOME  }	)
TRCell():New(oRecDesp,"A2_END","SA2",RetTitle("A2_END"),PesqPict("SA2","A2_END"),TamSx3("A2_END")[1],/*lPixel*/,{|| SA2->A2_END  }	)
TRCell():New(oRecDesp,"A2_BAIRRO","SA2",RetTitle("A2_BAIRRO"),PesqPict("SA2","A2_BAIRRO"),TamSx3("A2_BAIRRO")[1],/*lPixel*/,{|| SA2->A2_BAIRRO  }	)
TRCell():New(oRecDesp,"A2_MUN","SA2",RetTitle("A2_MUN"),PesqPict("SA2","A2_MUN"),TamSx3("A2_MUN")[1],/*lPixel*/,{|| SA2->A2_MUN  }	)
TRCell():New(oRecDesp,"A2_EST","SA2",RetTitle("A2_EST"),PesqPict("SA2","A2_EST"),TamSx3("A2_EST")[1],/*lPixel*/,{|| SA2->A2_EST  }	)

TRCell():New(oRecDesp,"A4_NOME","SA4",RetTitle("A4_NOME"),PesqPict("SA4","A4_NOME"),TamSx3("A4_NOME")[1],/*lPixel*/,{|| SA4->A4_NOME  }	)
TRCell():New(oRecDesp,"A4_END","SA4",RetTitle("A4_END"),PesqPict("SA4","A4_END"),TamSx3("A4_END")[1],/*lPixel*/,{|| SA4->A4_END  }	)
TRCell():New(oRecDesp,"F2_PBRUTO","SF2",RetTitle("F2_PBRUTO"),PesqPict("SF2","F2_PBRUTO"),TamSx3("F2_PBRUTO")[1],/*lPixel*/,{|| (cAliasQry)->F2_PBRUTO  }	)
TRCell():New(oRecDesp,"F2_PLIQUI","SF2",RetTitle("F2_PLIQUI"),PesqPict("SF2","F2_PLIQUI"),TamSx3("F2_PLIQUI")[1],/*lPixel*/,{|| (cAliasQry)->F2_PLIQUI  }	)
TRCell():New(oRecDesp,"F2_ESPECI1","SF2",RetTitle("F2_ESPECI1"),PesqPict("SF2","F2_ESPECI1"),TamSx3("F2_ESPECI1")[1],/*lPixel*/,{|| (cAliasQry)->F2_ESPECI1  }	)
TRCell():New(oRecDesp,"F2_VOLUME1","SF2",RetTitle("F2_VOLUME1"),PesqPict("SF2","F2_VOLUME1"),TamSx3("F2_VOLUME1")[1],/*lPixel*/,{|| (cAliasQry)->F2_VOLUME1  }	)
TRCell():New(oRecDesp,"F2_ESPECI2","SF2",RetTitle("F2_ESPECI2"),PesqPict("SF2","F2_ESPECI2"),TamSx3("F2_ESPECI2")[1],/*lPixel*/,{|| (cAliasQry)->F2_ESPECI2  }	)
TRCell():New(oRecDesp,"F2_VOLUME2","SF2",RetTitle("F2_VOLUME2"),PesqPict("SF2","F2_VOLUME2"),TamSx3("F2_VOLUME2")[1],/*lPixel*/,{|| (cAliasQry)->F2_VOLUME2  }	)
TRCell():New(oRecDesp,"F2_ESPECI3","SF2",RetTitle("F2_ESPECI3"),PesqPict("SF2","F2_ESPECI3"),TamSx3("F2_ESPECI3")[1],/*lPixel*/,{|| (cAliasQry)->F2_ESPECI3  }	)
TRCell():New(oRecDesp,"F2_VOLUME3","SF2",RetTitle("F2_VOLUME3"),PesqPict("SF2","F2_VOLUME3"),TamSx3("F2_VOLUME3")[1],/*lPixel*/,{|| (cAliasQry)->F2_VOLUME3  }	)
TRCell():New(oRecDesp,"F2_ESPECI4","SF2",RetTitle("F2_ESPECI4"),PesqPict("SF2","F2_ESPECI4"),TamSx3("F2_ESPECI4")[1],/*lPixel*/,{|| (cAliasQry)->F2_ESPECI4  }	)
TRCell():New(oRecDesp,"F2_VOLUME4","SF2",RetTitle("F2_VOLUME4"),PesqPict("SF2","F2_VOLUME4"),TamSx3("F2_VOLUME4")[1],/*lPixel*/,{|| (cAliasQry)->F2_VOLUME4  }	)

Return(oReport)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrin� Autor � Marco Bianchi         � Data � 12/07/06 ���
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
Static Function IReportPrint(oReport,cAliasQry)	//PERSONALIZADO SIM

Local nI 		:= 0
Local cEspecie  := ""
Local cVolume   := ""
Local lValadi   := cPaisLoc == "MEX" .AND. SD2->(FieldPos("D2_VALADI")) > 0 //  Adiantamentos Mexico
Local cExpAdi	:= Iif(lValadi,"% ,F2_VALADI %","%%")

LOCAL xFone
LOCAL xFax
LOCAL xRazSoc
LOCAL xEnder
LOCAL xCompl
LOCAL xFone
LOCAL xCnpj
LOCAL xIE
Local nCount	:= 0

#IFNDEF TOP
	Local cCondicao := ""
#ENDIF

//������������������������������������������������������������������������Ŀ
//�Transforma parametros Range em expressao SQL                            �
//��������������������������������������������������������������������������
MakeSqlExpr(oReport:uParam)

//������������������������������������������������������������������������Ŀ
//�Filtragem do relat�rio                                                  �
//��������������������������������������������������������������������������
dbSelectArea("SF2")		// Cabecalho da Nota Fiscal de Saida
dbSetOrder(1)			// Doc,Serie,Cliente,Loja
#IFDEF TOP
	//������������������������������������������������������������������������Ŀ
	//�Query do relat�rio da secao 1                                           �
	//��������������������������������������������������������������������������
	lQuery := .T.
	oReport:Section(1):BeginQuery()
	BeginSql Alias cAliasQry
		SELECT F2_FILIAL,F2_DOC,F2_CLIENTE,F2_LOJA,F2_VALBRUT,F2_PBRUTO,F2_PLIQUI,F2_VALMERC,F2_VALIPI,F2_FRETE,;
		F2_SEGURO,F2_ICMSRET,F2_ESPECI1,F2_ESPECI2,F2_ESPECI3,F2_ESPECI4,F2_VOLUME1,F2_VOLUME2,F2_VOLUME3,F2_VOLUME4,;
		F2_TIPO,F2_TRANSP,F2_SERIE %Exp:cExpAdi%
		FROM %Table:SF2% SF2
		WHERE F2_FILIAL = %xFilial:SF2% AND
		F2_SERIE = %Exp:mv_par01%	AND
		F2_DOC >= %Exp:mv_par02% AND F2_DOC <= %Exp:mv_par03% AND
		SF2.%NotDel%
		ORDER BY F2_DOC,F2_SERIE,F2_CLIENTE,F2_LOJA
	EndSql
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
	
#ELSE
	dbSelectArea(cAliasQry)
	
	cCondicao  := "F2_FILIAL=='"+xFilial("SF2")+"'.And."
	cCondicao  += "F2_SERIE == '"+MV_PAR01+"' .And. F2_DOC >= '"+MV_PAR02+"'.And."
	cCondicao  += "F2_DOC <='" + MV_PAR03+"'"
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
#ENDIF


//������������������������������������������������������������������������Ŀ
//�Metodo TrPosition()                                                     �
//�                                                                        �
//�Posiciona em um registro de uma outra tabela. O posicionamento ser�     �
//�realizado antes da impressao de cada linha do relat�rio.                �
//�                                                                        �
//�                                                                        �
//�ExpO1 : Objeto Report da Secao                                          �
//�ExpC2 : Alias da Tabela                                                 �
//�ExpX3 : Ordem ou NickName de pesquisa                                   �
//�ExpX4 : String ou Bloco de c�digo para pesquisa. A string ser� macroexe-�
//�        cutada.                                                         �
//�                                                                        �
//��������������������������������������������������������������������������

xFone := RTRIM(SM0->M0_TEL)
xFone := STRTRAN(xFone,"(","")
xFone := STRTRAN(xFone,")","")
xFone := STRTRAN(xFone,"-","")
xFone := STRTRAN(xFone," ","")

xFax := RTRIM(SM0->M0_FAX)
xFax := STRTRAN(xFax,"(","")
xFax := STRTRAN(xFax,")","")
xFax := STRTRAN(xFax,"-","")
xFax := STRTRAN(xFax," ","")

xRazSoc := "Remetente :" + RTRIM(SM0->M0_NOMECOM)
xEnder  := "Endereco :" + RTRIM(SM0->M0_ENDENT) + " - " + RTRIM(SM0->M0_BAIRENT)
xCompl  := "Cidade :" + RTRIM(SM0->M0_CIDENT) + "     Estado: " + SM0->M0_ESTENT
xFone   := "Fone / Fax: " + TRANSF(xFone,"@R 9999-9999") + IIF(!EMPTY(SM0->M0_FAX) , " / (11) " + TRANSF(xFax,"@R 9999-9999") , "" )
xCnpj   := "C.N.P.J.: " + TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
xIE     := "Inscr.Estadual: " + SM0->M0_INSC

//oReport:PrintText("_________________________ TRANSPORTADORA _________________________",350,010)

TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA})
TRPosition():New(oReport:Section(1),"SA2",1,{|| xFilial("SA2")+(cAliasQry)->F2_CLIENTE+(cAliasQry)->F2_LOJA})
TRPosition():New(oReport:Section(1),"SA4",1,{|| xFilial("SA4")+(cAliasQry)->F2_TRANSP})

//������������������������������������������������������������������������Ŀ
//�Impressao do Relat�rio                               				   �
//��������������������������������������������������������������������������

dbSelectArea(cAliasQry)
dbGoTop()
oReport:SetMeter((cAliasQry)->(LastRec()))
oReport:Section(1):Init()
Do While !oReport:Cancel() .And. !Eof() .and. F2_FILIAL == xFilial("SF2")
	
	nCount += 1
	
	oReport:Section(1):Init()
	
	//oReport:PrintText("___________________________ REMETENTE ____________________________",250,010)
	oReport:PrintText(xRazSoc,250,010)
	oReport:PrintText(xEnder,280,010)
	oReport:PrintText(xCompl,310,010)
	oReport:PrintText(xFone,340,010)
	//oReport:PrintText("__________________________ DESTINATARIO __________________________",400,010)
	
	If nCount != 1
		oReport:PrintText("",370,010)
	EndIf
	
	If !((cAliasQry)->F2_TIPO $ "DB")
		oReport:Section(1):Cell("A1_NOME"):Enable()
		oReport:Section(1):Cell("A1_END"):Enable()
		oReport:Section(1):Cell("A1_ENDENT"):Enable()
		oReport:Section(1):Cell("A1_BAIRRO"):Enable()
		oReport:Section(1):Cell("A1_MUN"):Enable()
		oReport:Section(1):Cell("A1_EST"):Enable()
		oReport:Section(1):Cell("A2_NOME"):Disable()
		oReport:Section(1):Cell("A2_END"):Disable()
		oReport:Section(1):Cell("A2_BAIRRO"):Disable()
		oReport:Section(1):Cell("A2_MUN"):Disable()
		oReport:Section(1):Cell("A2_EST"):Disable()
	Else
		oReport:Section(1):Cell("A1_NOME"):Disable()
		oReport:Section(1):Cell("A1_END"):Disable()
		oReport:Section(1):Cell("A1_ENDENT"):Disable()
		oReport:Section(1):Cell("A1_BAIRRO"):Disable()
		oReport:Section(1):Cell("A1_MUN"):Disable()
		oReport:Section(1):Cell("A1_EST"):Disable()
		oReport:Section(1):Cell("A2_NOME"):Enable()
		oReport:Section(1):Cell("A2_END"):Enable()
		oReport:Section(1):Cell("A2_BAIRRO"):Enable()
		oReport:Section(1):Cell("A2_MUN"):Enable()
		oReport:Section(1):Cell("A2_EST"):Enable()
	EndIf
	
	For nI := 1 to 4
		cEspecie := "F2_ESPECI" + AllTrim(Str(nI))
		cVolume  := "F2_VOLUME" + AllTrim(Str(nI))
		If !Empty(&cEspecie)
			oReport:Section(1):Cell(cEspecie):Enable()
			oReport:Section(1):Cell(cVolume):Enable()
		Else
			oReport:Section(1):Cell(cEspecie):Disable()
			oReport:Section(1):Cell(cVolume):Disable()
		EndIf
	Next
	
	oReport:Section(1):PrintLine()
	
	oReport:PrintText(STR0036,2500,500)		   												// "Data: ___/___/___"
	oReport:Line(2500,1800,2500,2300)  														// Linha para Assinatura
	oReport:PrintText(STR0037,2530,1900)													// "CARIMBO E ASSINATURA"
	
	oReport:PrintText("Carro Num.____________",2800,500)		   								// "Carro Num.       "
	oReport:Line(2800,1800,2800,2300)  														// Linha para Assinatura
	oReport:PrintText("Ass. do Motorista",2830,1900)										// "Ass. do Motorista"
	
	oReport:EndPage(.T.)
	
	dbSelectArea(cAliasQry)
	dbSKip()
	oReport:IncMeter()
EndDo

oReport:Section(1):Finish()


Return



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR720  � Autor � Paulo Boschetti       � Data � 12.05.92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Minuta de Despacho                                         ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � MATR720(void)                                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Edson   M.   �29/06/98�XXXXXX�Correcao para Argentina.                ���
��� Edson   M.   �02/07/98�XXXXXX�Inclusao do Peso Liquido.               ���
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
STATIC Function IMatr720R3() //PERSONALIZADO NAO
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL titulo := OemToAnsi(STR0001)	//"Minuta de Despacho"
LOCAL cDesc1 := OemToAnsi(STR0002)	//"Este relatorio ira emitir a relacao de Recibos"
LOCAL cDesc2 := OemToAnsi(STR0003)	//"de Despacho para as transportadoras."
LOCAL cDesc3 := ""
LOCAL CbCont,cabec1,cabec2,wnrel
LOCAL tamanho:= "P"
LOCAL cString:= "SF2"

PRIVATE m_pag      := 01 
PRIVATE imprime    := .T. 
Private _cPed := _cSeg := _cSUA := _cSC5 := "", _lWMS := .f. //Jorge H.

PRIVATE limite := 80
PRIVATE aReturn := {STR0004,1,STR0005, 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nomeprog:="IMATR720"
PRIVATE aLinha  := { },nLastKey := 0
PRIVATE cPerg   :="IMTR720"

PutSx1( cPerg,"01","S�rie da Nota ","S�rie da Nota ","S�rie da Nota ","mv_ch1","C", 09,0,0,"G","",""   ,"","mv_par01","","","","","","","")
PutSx1( cPerg,"02","De Nota Fiscal ","De Nota Fiscal ","De Nota Fiscal ","mv_ch2","C", 09,0,0,"G","",""   ,"","mv_par02","","","","","","","")
PutSx1( cPerg,"03","Ate Nota Fiscal ","Ate Nota Fiscal ","Ate Nota Fiscal ","mv_ch3","C", 03,0,0,"G","",""   ,"","mv_par03","","","","","","","")

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("IMTR720",.F.)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        	// Qual Serie De Nota Fiscal ?              �
//� mv_par02        	// Da Nota Fiscal ?                         �
//� mv_par03        	// Ate a Nota Fiscal ?                      �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="IMATR720"            //Nome Default do relatorio em Disco

wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.t.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| IC720Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � C720IMP  � Autor � Rosane Luciane Chene  � Data � 09.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR720			                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function IC720Imp(lEnd,WnRel,cString) //PERSONALIZADO NAO
//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL CbTxt
LOCAL titulo := OemToAnsi(STR0001)	//"Minuta de Despacho"
LOCAL CbCont,cabec1,cabec2
LOCAL tamanho:= "P"
LOCAL lContinua := lCab := .T.

//��������������������������������������������������������������Ŀ
//� Definicao do cabecalho e tipo de impressao do relatorio      �
//����������������������������������������������������������������
titulo := STR0006		//"RECIBO PARA DESPACHO"
cabec1 := ""
cabec2 := ""

nTipo  := IIF(aReturn[4]=1,15,18)
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape    �
//����������������������������������������������������������������
cbtxt    := SPACE(10)
cbcont   := 0
li       := 80
//��������������������������������������������������������������Ŀ
//� Acesso nota fiscal informada pelo usuario                    �
//����������������������������������������������������������������

dbSelectArea("SF2")
dbSetOrder(1)
Set SoftSeek On
dbSeek(cFilant+mv_par02+mv_par01)
Set SoftSeek Off

SetRegua(RecCount())		// Total de Elementos da regua

Private lImpCabec	:= .t. // ACSJ - 13-12-2014 - Controla impress�o do cabe�alho (somente a cada 2 impress�es)

m_pag := 0
IListaMin(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,cbcont,cbtxt)

//m_pag := 0
//IListaMin(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,cbcont,cbtxt)

//roda(cbcont,cbtxt,tamanho)

dbSelectArea("SF2")
dbClearFilter()
dbSetOrder(1)
Set device to screen

If aReturn[5] = 1
	Set Printer TO
	dbCommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

//��������������������������������������������������������������Ŀ
//�                                                              �
//����������������������������������������������������������������
STATIC FuncTion IListaMin(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo,cbcont,cbtxt) //PERSONALIZADO NAO

LOCAL lImpr:=.T.
Local lNormal := .F.
LOCAL cX := " "
LOCAL I  := 1
LOCAL xFone
LOCAL xFax
LOCAL xRazSoc
LOCAL xEnder
LOCAL xCompl
LOCAL xCnpj
LOCAL xIE
LOCAL nPula	:= 1
//Local aDriver := ReadDriver()

m_pag := 0
//Li := 40

Li := 0
//FmtLin(,AvalImp(limite),,,@Li)

DbSelectArea("SF2")
dbSetOrder(1)
dbSeek(cFilant+mv_par02+mv_par01)

Do While !Eof() .and. F2_FILIAL == cFilant .And. SF2->F2_DOC >= mv_par02 .And. SF2->F2_DOC <= mv_par03

	If SF2->F2_SERIE != mv_par01 .Or. SF2->F2_FILIAL != cFilant .Or. SF2->F2_DOC < mv_par02 .Or. SF2->F2_DOC > mv_par03
		lImpr:=.F.
	EndIf
	
	lNormal := !(SF2->F2_TIPO $ "DB")
	
	IncRegua()
	                 
	If lImpr

		for xxx := 1 to 2	
            
			
			if m_pag == 2
				Li := 0
				//FmtLin(,AvalImp(limite),,,@Li)
				m_pag := 0
		  	endif
		    
		    
		    Li++
//			@ 0,0 PSAY AvalImp(limite)
			@Li,30 pSay  "MINUTA DE TRANSPORTE" + Space(11) + "Emiss�o: " + DTOC(Date())	
			Li++
			
			@Li ,00 psay REPLICATE("-",((limite-LEN(" REMETENTE "))/2)) + " REMETENTE -" + REPLICATE("-",((limite-LEN(" REMETENTE "))/2))
			Li += nPula
		
			xFone := "(" + Alltrim(Substr(SM0->M0_TEL,1,3)) + ")" +  Alltrim(Substr(SM0->M0_TEL,4,10))
			
			xFax := RTRIM(SM0->M0_FAX)
			xFax := STRTRAN(xFax,"(","")
			xFax := STRTRAN(xFax,")","")
			xFax := STRTRAN(xFax,"-","")
			xFax := STRTRAN(xFax," ","")
			
			xRazSoc := RTRIM(SM0->M0_NOMECOM)
			xEnder  := RTRIM(SM0->M0_ENDENT) + " - " + RTRIM(SM0->M0_BAIRENT)
			xCompl  := RTRIM(SM0->M0_CIDENT) + " / " + SM0->M0_ESTENT
			xFone   := "Fone/Fax: " + xFone + IIF(!EMPTY(SM0->M0_FAX) , " / " + TRANSF(xFax,"@R 9999-9999") , "" )
			xCnpj   := "C.N.P.J.: " + TRANSF(SM0->M0_CGC,"@R 99.999.999/9999-99")
			xIE     := "Inscr.Estadual: "+SM0->M0_INSC
			
			@ Li,00 psay xRazSoc
			@ Li,51 psay "Representante : " + SF2->F2_VEND1
			Li += nPula
			@ Li,00 psay xEnder
			Li += nPula
			@ Li,00 psay xCompl
		//	Li += nPula
			@ Li,48 psay xFone
			Li += nPula
		
		
		    DbSelectArea("SD2")
		    DbSetOrder(3)
		    DbSeek(SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
		    
		    DbSelectArea("SC5")
		    DbSetOrder(1)
		    DbSeek(SD2->D2_FILIAL + SD2->D2_PEDIDO)
		    
		    _cPed := IIF(!Empty(SC5->C5__NUMSUA),SC5->C5__NUMSUA,SC5->C5_NUM)

			dbSelectArea("SF2")
				
			@Li ,00 psay REPLICATE("-",((limite-LEN(" DESTINATARIO "))/2)) + " DESTINATARIO " + REPLICATE("-",((limite-LEN(" DESTINATARIO "))/2))
			Li += nPula
			@ Li,00 psay STR0007+SF2->F2_DOC		//"Nota Fiscal : " 
			If !Empty(_cPed)
				@ Li,27 psay "Pedido : " + _cPed //Posicione("SUA",2, cFilAnt + F2_SERIE + F2_DOC ,"UA_NUM")
			EndIf
			@ Li,51 psay STR0008		//"Valor : "
			@ Li,59 psay (SF2->F2_VALMERC + SF2->F2_VALIPI + SF2->F2_FRETE + SF2->F2_SEGURO + SF2->F2_ICMSRET) PICTURE PesqPict("SF2","F2_VALBRUT")
			
			dbSelectArea( If( lNormal,"SA1","SA2" ) )
			dbSeek(xFilial(If( lNormal,"SA1","SA2" ))+SF2->F2_CLIENTE+SF2->F2_LOJA)
			Li += nPula
			@ Li,00 psay STR0009+If( lNormal,Alltrim(SA1->A1_NOME),Alltrim(SA2->A2_NOME) )			//"Cliente     : "
			Li += nPula
			If lNormal
		//		If empty( SA1->A1_ENDENT )
					@ Li,00 psay STR0010+Alltrim(SA1->A1_END)				//"Endereco    : "
		//		Else
		//			@ Li,00 psay STR0010+SA1->A1_ENDENT			//"Endereco    : "
		//		EndIf
			Else
				@ Li,00 psay STR0010+Alltrim(SA2->A2_END)					//"Endereco    : "
			EndIf
			Li += nPula
			@ Li,00 psay STR0011+If( lNormal,Alltrim(SA1->A1_BAIRRO),Alltrim(SA2->A2_BAIRRO) )			//"Bairro      : "
			@ Li,35 psay STR0012+If( lNormal,Alltrim(SA1->A1_MUN),Alltrim(SA2->A2_MUN) )					//"Cidade : "
			@ Li,72 psay STR0013+If( lNormal,Alltrim(SA1->A1_EST),Alltrim(SA2->A2_EST) )					//"UF : "
			Li += nPula
			@Li ,00 psay REPLICATE("-",((limite-LEN(" TRANSPORTADORA "))/2)) + " TRANSPORTADORA " + REPLICATE("-",((limite-LEN(" TRANSPORTADORA "))/2))
			Li += nPula
		
			dbSelectArea("SA4")
			dbSeek(xFilial("SA4")+SF2->F2_TRANSP)
			//	Li += nPula
			@ Li,00 psay "Transp.     : " + Alltrim(A4_COD) + "  " + Alltrim(A4_NOME) //STR0014+A4_NOME		//"Transportad.: "
			Li += nPula
			@ Li,00 psay "Endere�o    : " + Alltrim(A4_END) //STR0010+A4_END		//"Endereco    : "
			Li += nPula
			@ Li,00 psay "Peso Bruto  : " + Transform(SF2->F2_PBRUTO,PesqPict("SF2","F2_PBRUTO"))		//"Peso Bruto  : "
		//	Li += nPula
			@ Li,40 psay "Peso L�quido : " + Transform(SF2->F2_PLIQUI,PesqPict("SF2","F2_PLIQUI"))		//"Peso Liquido : "
			Li += nPula
				
			dbSelectArea("SF2")
			Li += nPula
			//	Li   := 26
			lCab := .T.
			
			FOR I:=1 TO 4
				cX := Str(I,1)
				
				If !empty(F2_ESPECI&cX)
					If lCab
						//@Li ,15 psay REPLICATE("-",47)
						//Li++
						@Li ,00 psay "  Qtde" 
						@Li ,08 psay "Especie "
		                @Li ,35 psay "  Qtde" 
		                @Li ,43 psay "Especie "				
						//Li++
						//@Li ,15 psay REPLICATE("-",47)
		//				Li++
						lCab := .F.
						Li++
					EndIf
					If I % 2 > 0
						@Li ,00 psay F2_VOLUME&cX PICTURE "999999"
						@Li ,08 psay CapitalAce(Alltrim(LTrim(F2_ESPECI&cX)))
					Else
		                @Li ,35 psay F2_VOLUME&cX PICTURE "999999
		                @Li ,43 psay CapitalAce(Alltrim(LTrim(F2_ESPECI&cX)))
		                Li++ 			
					EndIf		
				EndIf
			NEXT I
			
			Li += 2
			
			@ Li,00 psay STR0018//+SPACE(32)+"----------------------------"			//"Data: ___/___/___"
			//	@ Li,53 psay STR0019		//"CARIMBO E ASSINATURA"
		//	Li += nPula
			@ Li,33 psay "Ass. do Conferente : ________________________"
			Li += 2
			@ Li,00 psay "Carro Num: ____________"//+SPACE(27)+"________________________"
		//	Li += nPula
			@ Li,33 psay "Ass. do Motorista  : ________________________"
			
			// ACSJ - 13-12-2014 - Imprime linha indicando final da impress�o da minuta.	
			Li += 2
		            
		    m_pag++
			
			if m_pag == 1
				@Li ,00 psay REPLICATE("-",limite)                                          
				Li += 2
			endif
		    
		next xxx
	
	
	    _cSUA := _cPed := _cSC5 := ""
	    _lWMS := .f.
		
		If !Empty(SC5->C5__NUMSUA)
			DbSelectArea("SUA")
			DbSetOrder(1)
			DbSeek(SC5->C5_FILIAL + SC5->C5__NUMSUA)
	
	        _cPed := SUA->UA_NUM
	        _cSeg := SUA->UA__SEGISP
	        //If Val(SUA->UA__STATUS) <= 9
	        If Alltrim(SUA->UA__STATUS) $ "8/9"
		        _cSUA := SUA->UA_NUM
		        _lWMS := .t.
			EndIf
		EndIf
		/*
	    //Atualiza o status do pedido   
	    DbSelectArea("SUA")
	    DbOrderNickName("SUANF")
	    If DbSeek(xFilial("SUA") + SF2->F2_FILIAL + SF2->F2_DOC + SF2->F2_SERIE + SF2->F2_CLIENTE + SF2->F2_LOJA)
	        _cPed := SUA->UA_NUM
	        _cSeg := SUA->UA__SEGISP
	        If Val(SUA->UA__STATUS) <= 9
		        _cSUA := SUA->UA_NUM
		        _lWMS := .t.
			EndIf
	    EndIf
	    */
	    If Empty(_cPed)
	        _cPed := SD2->D2_PEDIDO + "FAT" 
	        _cSeg := Posicione("SC5",1,xFilial("SC5") + SD2->D2_PEDIDO,"C5__SEGISP")
	        //If Val(SC5->C5__STATUS) <= 9
	        If Alltrim(SC5->C5__STATUS) $ "8/9"
	            _cSC5 := SC5->C5_NUM 
	            _lWMS := .t.
	        Else
	            _cPed := ""
	        EndIf
	    EndIf
	    
	    
	//    _lWMS := .t.
	    
	    If !Empty(_cPed) .And. _lWMS
	        _aResult := TCSPEXEC("PROC_PMHA_INTER_LIBERAR_EXP",cEmpAnt,SF2->F2_FILIAL,_cSeg,_cPed,SF2->F2_DOC,SF2->F2_SERIE,"INC")
	        If !Empty(_aResult)
	            If _aResult[1] == "S"
	                Help( Nil, Nil, "ENVMINUTA", Nil, _aResult[2], 1, 0 ) 
	                _lWMS := .f. 
	            EndIf
	        Else
	            Help( Nil, Nil, "ENVMINUTA", Nil, "Erro ao enviar minuta da NF " + SF2->F2_DOC, 1, 0 ) 
	            _lWMS := .f.
	        EndIf
	        
	        //Atualiza o status do pedido        
	        If _lWMS
	            If !Empty(_cSUA)
	                DbSelectArea("SUA")
	                While !Reclock("SUA",.f.)
	                EndDo
	                SUA->UA__STATUS := "10"
	                MsUnlock()
	 
	                DbSelectArea("SC5")
	                DbSetOrder(1)
	                If DbSeek(SUA->UA__FILIAL + SUA->UA_NUMSC5)
	                    While !Reclock("SC5",.f.)
	                    EndDo
	                    SC5->C5__STATUS := "10"
	                    MsUnlock()
	                EndIf               
	            ElseIf !Empty(_cSC5)
	                DbSelectArea("SC5")
	                While !Reclock("SC5",.f.)
	                EndDo
	                SC5->C5__STATUS := "10"
	                MsUnlock()
	            EndIf
	        EndIf
	    EndIf	
	
	    DbSelectArea("SF2")
			    
	    if lImpCabec // ACSJ - Controle de impress�o de 2 minutas por folha
			lImpCabec	:= .f.
		Else
			lImpCabec	:= .T.
		Endif
		
	EndIf
	
	SF2->(dbSkip())
enddo

Return (.T.)