#INCLUDE "MATR770.CH"
#INCLUDE "FIVEWIN.CH"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ MATR770  ³ Autor ³ Marco Bianchi         ³ Data ³ 18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da rela‡„o das Devolucoes.                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ SIGAFAT                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
User Function MTBCD770()                                   		

Local oReport

If FindFunction("TRepInUse") .And. TRepInUse()
	//-- Interface de impressao
	oReport := ReportDef()
	oReport:PrintDialog()
Else
	MATR770R3()
EndIf

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportDef ³ Autor ³ Marco Bianchi         ³ Data ³ 18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ExpO1: Objeto do relatório                                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³Nenhum                                                      ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportDef()

Local oReport
Local oNotaDev
Local oTitulos   
Local oCellCod

Local aTam	:= TamSX3("F4_CF")
#IFDEF TOP
	Local cAliasSF1 := cAliasSD1 := cAliasSA1 := cAliasSB1 := cAliasSZT := GetNextAlias()
	Local cAliasSE1 := GetNextAlias()
#ELSE
	Local cAliasSF1 := "SF1"
	Local cAliasSD1 := "SD1"
	Local cAliasSA1 := "SA1"
	Local cAliasSB1 := "SB1"
	Local cAliasSE1 := "SE1"
	Local cAliasSZT := "SZT"
#ENDIF

Local nIPI     := 0
Local nDecs    := 0
Local nTamData := Len(DTOC(MsDate()))

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao do componente de impressao                                      ³
//³                                                                        ³
//³TReport():New                                                           ³
//³ExpC1 : Nome do relatorio                                               ³
//³ExpC2 : Titulo                                                          ³
//³ExpC3 : Pergunte                                                        ³
//³ExpB4 : Bloco de codigo que sera executado na confirmacao da impressao  ³
//³ExpC5 : Descricao                                                       ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport := TReport():New("MATR770",STR0014,"MTR770", {|oReport| ReportPrint(oReport,oNotaDev,cAliasSF1,cAliasSD1,cAliasSA1,cAliasSB1,cAliasSE1,cAliasSZT,oTitulos,nDecs)},STR0015 + " " + STR0016)	// "Relacao das Devolucoes de Vendas"###"Este relatório irá imprimir a relaçäo de itens"###"referentes as devoluçóes de vendas."
oReport:SetLandscape() 
oReport:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                         		       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Pergunte(oReport:uParam,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         		   ³
//³ mv_par01             // Data digitacao De         	         		   ³
//³ mv_par02             // Data digitacao Ate                   		   ³
//³ mv_par03             // Fornec. de                           		   ³
//³ mv_par04             // Fornec. Ate                          		   ³
//³ mv_par05             // Loja de                              		   ³
//³ mv_par06             // Loja Ate                             		   ³
//³ mv_par07             // CFO de                               		   ³
//³ mv_par08             // CFO Ate                              		   ³
//³ mv_par09             // Qual moeda                           		   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da secao utilizada pelo relatorio                               ³
//³                                                                        ³
//³TRSection():New                                                         ³
//³ExpO1 : Objeto TReport que a secao pertence                             ³
//³ExpC2 : Descricao da seçao                                              ³
//³ExpA3 : Array com as tabelas utilizadas pela secao. A primeira tabela   ³
//³        sera considerada como principal para a seção.                   ³
//³ExpA4 : Array com as Ordens do relatório                                ³
//³ExpL5 : Carrega campos do SX3 como celulas                              ³
//³        Default : False                                                 ³
//³ExpL6 : Carrega ordens do Sindex                                        ³
//³        Default : False                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Criacao da celulas da secao do relatorio                                ³
//³                                                                        ³
//³TRCell():New                                                            ³
//³ExpO1 : Objeto TSection que a secao pertence                            ³
//³ExpC2 : Nome da celula do relatório. O SX3 será consultado              ³
//³ExpC3 : Nome da tabela de referencia da celula                          ³
//³ExpC4 : Titulo da celula                                                ³
//³        Default : X3Titulo()                                            ³
//³ExpC5 : Picture                                                         ³
//³        Default : X3_PICTURE                                            ³
//³ExpC6 : Tamanho                                                         ³
//³        Default : X3_TAMANHO                                            ³
//³ExpL7 : Informe se o tamanho esta em pixel                              ³
//³        Default : False                                                 ³
//³ExpB8 : Bloco de código para impressao.                                 ³
//³        Default : ExpC2                                                 ³
//³                                                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao da Secao 1 - Notas de Devolucao                 			   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oNotaDev := TRSection():New(oReport,STR0021,{"SF1","SD1","SB1","SA1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/,,,,,,.T. )	// "Relacao das Devolucoes de Vendas"
oNotaDev:SetTotalInLine(.F.)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao das Celulas da Secao 1 - Notas de Devolucao                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
TRCell():New(oNotaDev,"D1_DOC"		,"SD1"		,RetTitle("D1_DOC"		),PesqPict("SD1","D1_DOC"				),TamSx3("D1_DOC"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_DOC 	},,,,,,.F.)
oCellCod := TRCell():New(oNotaDev,"D1_COD"		,"SD1"		,RetTitle("D1_COD"		),PesqPict("SD1","D1_COD"	),TamSx3("D1_COD"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_COD 		},,,,,,.F.)
TRCell():New(oNotaDev,"B1_DESC"		,"SB1"		,RetTitle("B1_DESC"		),PesqPict("SB1","B1_DESC"				),TamSx3("B1_DESC"		)[1],/*lPixel*/,{|| (cAliasSB1)->B1_DESC	},,.T.,,,,.T.)
TRCell():New(oNotaDev,"D1_QUANT"	,"SD1"		,RetTitle("D1_QUANT"	),PesqPict("SD1","D1_QUANT"				),TamSx3("D1_QUANT"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_QUANT 	},,,"RIGHT",,,.T.)
TRCell():New(oNotaDev,"B1_UM"		,"SB1"		,RetTitle("B1_UM"		),PesqPict("SB1","B1_UM"				),TamSx3("B1_UM"		)[1],/*lPixel*/,{|| (cAliasSB1)->B1_UM },,,,,,.T.)
TRCell():New(oNotaDev,"D1_VUNIT"	,"SD1"		,RetTitle("D1_VUNIT"	),PesqPict("SD1","D1_VUNIT",14,mv_par09),TamSx3("D1_VUNIT"		)[1],/*lPixel*/,{|| xMoeda((cAliasSD1)->D1_VUNIT,(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSD1)->D1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA) 	},,,"RIGHT",,,.T.)
TRCell():New(oNotaDev,"NIPI"		,/*Tabela*/	,RetTitle("D1_IPI"		),PesqPict("SD1","D1_IPI"				),TamSx3("D1_IPI"		)[1],/*lPixel*/,{|| nIPI	},,,"RIGHT",,,.F.)
TRCell():New(oNotaDev,"D1_TOTAL"	,"SD1"		,RetTitle("D1_TOTAL"	),PesqPict("SD1","D1_TOTAL",16,mv_par09),TamSx3("D1_TOTAL"		)[1],/*lPixel*/,{|| xMoeda(((cAliasSD1)->D1_TOTAL-(cAliasSD1)->D1_VALDESC),(cAliasSF1)->F1_MOEDA,mv_par09,(cAliasSD1)->D1_DTDIGIT,nDecs+1,(cAliasSF1)->F1_TXMOEDA)	},,,"RIGHT",,,.T.)
If ( cPaisLoc=="BRA" )
	TRCell():New(oNotaDev,"D1_PICM"	,"SD1"		,RetTitle("D1_PICM"		),PesqPict("SD1","D1_PICM"				),TamSx3("D1_PICM"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_PICM },,,"RIGHT",,,.F.)
EndIf	
TRCell():New(oNotaDev,"D1_FORNECE"	,"SD1"		,RetTitle("D1_FORNECE"	),PesqPict("SD1","D1_FORNECE"			),TamSx3("D1_FORNECE"	)[1],/*lPixel*/,{|| (cAliasSD1)->D1_FORNECE 	},,,,,,.T.)
TRCell():New(oNotaDev,"A1_NOME"		,"SA1"		,RetTitle("A1_NOME"		),PesqPict("SA1","A1_NOME"				),TamSx3("A1_NOME"		)[1],/*lPixel*/,{|| (cAliasSA1)->A1_NOME },,.T.,,,,.T.)
TRCell():New(oNotaDev,"F1_CODTKT"		,"SF1"		,'Ticket' ,PesqPict("SF1","F1_CODTKT"				),TamSx3("F1_CODTKT"		)[1],/*lPixel*/,{|| (cAliasSF1)->F1_CODTKT },,,,,,.T.)
//TRCell():New(oNotaDev,"D1_TES"		,"SD1"		,RetTitle("D1_TES"		),PesqPict("SD1","D1_TES"				),TamSx3("D1_TES"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_TES 			},,,,,,.T.)
//TRCell():New(oNotaDev,"D1_TP"		,"SD1"		,RetTitle("D1_TP"		),PesqPict("SD1","D1_TP"				),TamSx3("D1_TP"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_TP 		},,,,,,.T.)
//TRCell():New(oNotaDev,"D1_GRUPO"	,"SD1"		,RetTitle("D1_GRUPO"	),PesqPict("SD1","D1_GRUPO"				),TamSx3("D1_GRUPO"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_GRUPO},,,,,,.T.)
TRCell():New(oNotaDev,"ZT_DESC"		,"SZT"		,'Motivo' ,PesqPict("SZT","ZT_DESC"				),TamSx3("ZT_DESC"		)[1],/*lPixel*/,{|| (cAliasSZT)->ZT_DESC},,,,,,.T.)
TRCell():New(oNotaDev,"ZT_DEPTO"	,"SZT"		,'Depto.' ,PesqPict("SZT","ZT_DEPTO"				),TamSx3("ZT_DEPTO"	)[1],/*lPixel*/,{|| (cAliasSZT)->ZT_DEPTO},,,,,,.T.)
TRCell():New(oNotaDev,"D1_DTDIGIT"	,"SD1"		,RetTitle("D1_DTDIGIT"	),PesqPict("SD1","D1_DTDIGIT"			),nTamData					 ,/*lPixel*/,{|| (cAliasSD1)->D1_DTDIGIT },,,,,,.T.)
TRCell():New(oNotaDev,"NCUSTO"		,/*Tabela*/	,RetTitle("D1_CUSTO"	),PesqPict("SD1","D1_CUSTO",14,mv_par09),TamSx3("D1_CUSTO"		)[1],/*lPixel*/,{|| If(mv_par09==1,(cAliasSD1)->D1_CUSTO,&("D1_CUSTO"+Str(mv_par09,1)))},,,"RIGHT",,,.T.)
TRCell():New(oNotaDev,"D1_NFORI"	,"SD1"		,RetTitle("D1_NFORI"	),PesqPict("SD1","D1_NFORI"				),TamSx3("D1_NFORI"		)[1],/*lPixel*/,{|| (cAliasSD1)->D1_NFORI	},,,,,,.F.)
TRCell():New(oNotaDev,"D1_SERIORI"	,"SD1"		,RetTitle("D1_SERIORI"	),PesqPict("SD1","D1_SERIORI"			),TamSx3("D1_SERIORI"	)[1],/*lPixel*/,{|| (cAliasSD1)->D1_SERIORI	},,,,,,.F.)
                      
oReport:Section(1):SetHeaderPage()		// Cabecalho da secao no topo da pegina 
oCellCod:nHeaderSize := TamSx3( "D1_COD" )[1]

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Definicao das Celulas dsa Secao 2 - Titulos da Nota de Saida           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oTitulos := TRSection():New(oReport,STR0022,{"SE1"},/*{Array com as ordens do relatório}*/,/*Campos do SX3*/,/*Campos do SIX*/)	// "Relacao das Devolucoes de Vendas"
oTitulos:SetTotalInLine(.F.)

TRCell():New(oTitulos,"E1_PREFIXO"	,"SE1",RetTitle("E1_PREFIXO"	),PesqPict("SE1","E1_PREFIXO"			),TamSx3("E1_PREFIXO"	)[1],/*lPixel*/,{|| (cAliasSE1)->E1_PREFIXO 																})
TRCell():New(oTitulos,"E1_NUM"		,"SE1",RetTitle("E1_NUM"		),PesqPict("SE1","E1_NUM"				),TamSx3("E1_NUM"		)[1],/*lPixel*/,{|| (cAliasSE1)->E1_NUM 																	})
TRCell():New(oTitulos,"E1_PARCELA"	,"SE1",RetTitle("E1_PARCELA"	),PesqPict("SE1","E1_PARCELA"			),TamSx3("E1_PARCELA"	)[1],/*lPixel*/,{|| (cAliasSE1)->E1_PARCELA 																})
TRCell():New(oTitulos,"E1_VENCTO"	,"SE1",RetTitle("E1_VENCTO"		),PesqPict("SE1","E1_VENCTO"			),TamSx3("E1_VENCTO"	)[1],/*lPixel*/,{|| (cAliasSE1)->E1_VENCTO 																})
TRCell():New(oTitulos,"E1_SALDO"		,"SE1",RetTitle("E1_SALDO"		),PesqPict("SE1","E1_SALDO",14,mv_par09	),TamSx3("E1_SALDO"		)[1],/*lPixel*/,{|| xMoeda((cAliasSE1)->E1_SALDO,(cAliasSE1)->E1_MOEDA,mv_par09,(cAliasSE1)->E1_EMISSAO)	})


Return(oReport)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Programa  ³ReportPrin³ Autor ³ Marco Bianchi         ³ Data ³ 18/07/06 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³A funcao estatica ReportDef devera ser criada para todos os ³±±
±±³          ³relatorios que poderao ser agendados pelo usuario.          ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³Nenhum                                                      ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpO1: Objeto Report do Relatório                           ³±±
±±³          ³                                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³   DATA   ³ Programador   ³Manutencao efetuada                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³          ³               ³                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function ReportPrint(oReport,oNotaDev,cAliasSF1,cAliasSD1,cAliasSA1,cAliasSB1,cAliasSE1,cAliasSZT,oTitulos,nDecs)

Local nX 	  	:= 0
Local nImpInc 	:= 0
Local nValMerc	:= 0
Local nFrete	:= 0
Local nDespesa	:= 0
Local nValIPI	:= 0
Local nICMSRet	:= 0
Local nDescont	:= 0
Local nMoeda	:= 0
Local dDtDigit	:= ctod("  /  /  ")
Local nTxMoeda	:= 0
Local lDevolucao:= .F.
Local cQuebra   := ""
Local cNFOri	:= ""
Local cSeriOri	:= ""
Local nTotNota  := 0
Local nTotal    := 0
Local cSCpo		:= ""
Local cCpo		:= ""
Local cCamposD1 := ""

#IFNDEF TOP
	Local cCondicao := ""
#ELSE	
	Local cWhere := ""
#ENDIF

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Transforma parametros Range em expressao SQL                            ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
MakeSqlExpr(oReport:uParam)

oReport:Section(1):Cell("NIPI"):SetBlock({|| nIPI })
nIPI := 0
nDecs := msdecimais(mv_par09)

                                   
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Altera titulo do relatorio de acordo com parametros                    ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetTitle(oReport:Title() + " - " + GetMv("MV_MOEDA"+STR(mv_par09,1)))		// 	"Relacao das Devolucoes de Vendas"

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Filtragem do relatório                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
#IFDEF TOP
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Campos dos impostos variaveis                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cSCpo:="1"
	cCpo:="D1_VALIMP"+cSCpo
	cCamposD1 := "%"
	While SD1->(FieldPos(cCpo))>0
		cCamposD1 += ","+cCpo //+ " " + Substr(cCpo,4)
		cSCpo:=Soma1(cSCpo)
		cCpo:="D1_VALIMP"+cSCpo
	Enddo
	cCamposD1 += "%"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Query do relatório da secao 1                                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cWhere := "% NOT ("+IsRemito(2,"F1_TIPODOC")+")%"
	oReport:Section(1):BeginQuery()	
	BeginSql Alias cAliasSF1
	SELECT F1_FILIAL,F1_DTDIGIT,F1_TIPO,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_MOEDA,F1_TXMOEDA,F1_VALMERC,
	F1_FRETE,F1_DESPESA,F1_VALIPI,F1_ICMSRET,F1_DESCONT,D1_FILIAL,D1_DOC,D1_SERIE,D1_COD,D1_QUANT,D1_VUNIT,ZT_DEPTO,F1_CODTKT,
	D1_TOTAL,D1_FORNECE,D1_LOJA,D1_TIPO,D1_TES,D1_TP,D1_GRUPO,D1_DTDIGIT,D1_NFORI,D1_SERIORI,D1_ALQIMP1,D1_IPI,ZT_DESC,F1_MOTDEV,
	D1_CUSTO,D1_CUSTO2,D1_CUSTO3,D1_CUSTO4,D1_CUSTO5,D1_VALDESC,D1_PICM,B1_DESC,B1_UM,A1_NOME %Exp:cCamposD1%
	FROM %Table:SF1% SF1
	LEFT JOIN %Table:SZT% SZT 
	ON SF1.F1_MOTDEV = SZT.ZT_CODIGO AND SZT.%NotDel%,
	%Table:SD1% SD1,%Table:SB1% SB1,%Table:SA1% SA1
	
	WHERE F1_FILIAL = %xFilial:SF1% AND 
		F1_TIPO = "D" AND 
		F1_DTDIGIT >= %Exp:DtoS(mv_par01)% AND F1_DTDIGIT <= %Exp:DtoS(mv_par02)% AND
		F1_FORNECE >= %Exp:mv_par03% AND F1_FORNECE <= %Exp:mv_par04% AND
		F1_LOJA >= %Exp:mv_par05% AND F1_LOJA <= %Exp:mv_par06% AND
		%Exp:cWhere% AND
		SF1.%NotDel% AND 
		D1_FILIAL = %xFilial:SD1% AND 
		D1_DOC = F1_DOC AND D1_SERIE = F1_SERIE AND D1_FORNECE = F1_FORNECE AND D1_LOJA = F1_LOJA AND
		D1_CF >= %Exp:mv_par07% AND D1_CF <= %Exp:mv_par08% AND
		SD1.%NotDel% AND
		B1_FILIAL = %xFilial:SB1% AND 
		B1_COD = D1_COD AND
		SB1.%NotDel% AND 
		A1_FILIAL = %xFilial:SA1% AND 
		A1_COD = F1_FORNECE AND A1_LOJA = F1_LOJA AND
		SA1.%NotDel%
	ORDER BY F1_FILIAL,F1_DOC,F1_SERIE,F1_FORNECE,F1_LOJA,F1_TIPO
	EndSql 
	oReport:Section(1):EndQuery(/*Array com os parametros do tipo Range*/)
		
#ELSE

	dbSelectArea(cAliasSF1)
	dbSetOrder(1)
		
	cCondicao := dbFilter()
	cCondicao += If(!Empty(cCondicao),".And.","")
	cCondicao += "F1_FILIAL=='"+xFilial("SF1")+"'"
	cCondicao += ".And.F1_TIPO=='D'.And.dtos(F1_DTDIGIT)>='"+dtos(mv_par01)+"'.And.dtos(F1_DTDIGIT)<='"+dtos(mv_par02)+"'"
	cCondicao += ".And.F1_FORNECE>='"+mv_par03+"'.And.F1_FORNECE<='"+mv_par04+"'"
	cCondicao += ".And.F1_LOJA>='"+mv_par05+"'.And.F1_LOJA<='"+mv_par06+"'"
	cCondicao += ".And. !("+IsRemito(2,"SF1->F1_TIPODOC")+")"
	oReport:Section(1):SetFilter(cCondicao,IndexKey())
	
	dbSelectArea(cAliasSF1)
	
	// Posiciona Cadastro de Clientes e Produtos antes da impressao de cada linha
	TRPosition():New(oReport:Section(1),"SA1",1,{|| xFilial("SA1")+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA })
	TRPosition():New(oReport:Section(1),"SB1",1,{|| xFilial("SB1")+(cAliasSD1)->D1_COD })
	
#ENDIF		


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Inicio da impressao do fluxo do relatório                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
oReport:SetMeter((cAliasSF1)->(LastRec()))
oReport:Section(1):Init()
dbSelectArea(cAliasSF1)
dbGoTop()
While !oReport:Cancel() .And. !(cAliasSF1)->(Eof()) .And. (cAliasSF1)->F1_FILIAL == xFilial("SF1")
	
	#IFNDEF TOP
		dbSelectArea(cAliasSD1)
		dbSetOrder(1)
		dbSeek(xFilial()+(cAliasSF1)->F1_DOC+(cAliasSF1)->F1_SERIE+(cAliasSF1)->F1_FORNECE+(cAliasSF1)->F1_LOJA)
	#ENDIF
	
	nValMerc	:= (cAliasSF1)->F1_VALMERC
	nFrete		:= (cAliasSF1)->F1_FRETE 
	nDespesa	:= (cAliasSF1)->F1_DESPESA 
	nValIPI		:= (cAliasSF1)->F1_VALIPI 
	nICMSRet	:= (cAliasSF1)->F1_ICMSRET 
	nDescont	:= (cAliasSF1)->F1_DESCONT
	nMoeda		:= (cAliasSF1)->F1_MOEDA
	dDtDigit	:= (cAliasSF1)->F1_DTDIGIT
	nTxMoeda	:= (cAliasSF1)->F1_TXMOEDA
	cNFOri		:= (cAliasSD1)->D1_NFORI
	cSeriOri	:= BuscaPref(cNFOri,(cAliasSD1)->D1_SERIORI)
	
	nImpInc    := 0
	lDevolucao := .F.
	cQuebra    := (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA
	dbSelectArea(cAliasSD1)
	While !oReport:Cancel() .And. !Eof() .And. (cAliasSD1)->D1_FILIAL+(cAliasSD1)->D1_DOC+(cAliasSD1)->D1_SERIE+(cAliasSD1)->D1_FORNECE+(cAliasSD1)->D1_LOJA == cQuebra
		
		#IFNDEF TOP
			If D1_TIPO != "D" .Or. D1_CF < mv_par07 .Or. D1_CF > mv_par08
				dbSkip()
				Loop
			Endif   
		#ENDIF
		
		lDevolucao := .T.
		dbSelectArea(cAliasSD1)
		If ( cPaisLoc#"BRA" )
			aImpostos:=TesImpInf(D1_TES)
			For nX:=1 to len(aImpostos)
				If ( aImpostos[nX][3]=="1")
					cCampoImp:=aImpostos[nX][2]
					nImpInc	+=	&cCampoImp
				EndIf
			Next
		EndIf
		If (cPaisLoc<>"BRA")
			nIpi:=(cAliasSD1)->D1_ALQIMP1
		Else
			nIpi:=(cAliasSD1)->D1_IPI
		EndIf
		dbSelectArea(cAliasSD1)
		
		// Impressao da nota
		oReport:Section(1):PrintLine()		
		
		dbSelectArea(cAliasSD1)
		dbSkip()

	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Quebra de Nota: Imprime Totais da Nota e Duplicata                     ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If lDevolucao
		nTotNota:=0
		If ( cPaisLoc=="BRA" )
			nTotNota:= nValMerc + nFrete + nDespesa + nValIPI + nICMSRet - nDescont
		Else
			nTotNota:= nValMerc + nFrete + nDespesa + nImpInc - nDescont
		EndIf
		nTotNota:=xMoeda(nTotNota,nMoeda,mv_par09,dDtDigit,nDecs+1,nTXMoeda)
		nTotal  += nTotNota
		
		// Impressao dos totais
		oReport:SkipLine()
		oReport:PrintText(STR0017 + Transform(xMoeda(nDescont,nMoeda,mv_par09,dDtDigit,nDecs+1,nTXMoeda),PesqPict("SF1","F1_DESCONT",14,mv_par09)),oReport:Row(),500)	// "TOTAL DESCONTOS --> "
		oReport:Printtext(STR0018 + Transform(nTotNota,Pesqpict("SF1","F1_VALMERC",14,mv_par09)),oReport:Row(),1200)	// "TOTAL NOTA FISCAL --> "
		oReport:SkipLine()
		oReport:Printtext(STR0019)	// "Duplicatas da Nota Fiscal de Saida"
		oReport:SkipLine()
	
		// Impressao das Duplicatas
		dbSelectArea("SE1")			// Contas a Receber
		dbSetOrder(1)		  		// Prefixo,Numero,Parcela,Tipo
		#IFDEF TOP
			oReport:Section(2):BeginQuery()
			BeginSql Alias cAliasSE1
			SELECT E1_FILIAL,E1_PREFIXO,E1_NUM,E1_PARCELA,E1_VENCTO,E1_SALDO,E1_MOEDA,E1_EMISSAO
			FROM %Table:SE1% SE1
			WHERE E1_FILIAL = %xFilial:SE1% AND E1_NUM = %Exp:cNFOri% AND E1_PREFIXO = %Exp:cSeriOri% AND
				SE1.%Notdel%
			EndSql
			oReport:Section(2):EndQuery()
		#ELSE
			dbSeek(xFilial("SE1")+cSeriOri+cNFOri)
		#ENDIF
		dbSelectArea(cAliasSE1)
		If !Eof()
			oReport:Section(2):Init()
			While !oReport:Cancel() .And. !Eof() .And. E1_FILIAL+E1_PREFIXO+E1_NUM == xFilial("SE1")+cSeriOri+cNFOri
			    oReport:Section(2):PrintLine() 
				dbSkip()
			EndDo
			oReport:Section(2):Finish()
		Else
			oReport:PrintText(STR0020)		// "Nao houve titulos gerados na saida"
		EndIf
		oReport:SkipLine()
		oReport:FatLine()    
	Endif
	
	#IFNDEF TOP
		dbSelectArea(cAliasSF1)
		dbSkip()  
	#ENDIF	
	oReport:IncMeter()

EndDo
If nTotal > 0
	oReport:SkipLine()
	oReport:PrintText(STR0023 + Transform(xMoeda(nTotal,nMoeda,mv_par09,dDtDigit,nDecs+1,nTXMoeda),Pesqpict("SF1","F1_VALMERC",14,mv_par09)),oReport:Row(),1200)	// "TOTAL GERAL       --> "
EndIf
oReport:Section(1):Finish()
oReport:Section(1):SetPageBreak(.T.)

Return


/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ MATR770R3³ Autor ³ Paulo Boschetti       ³ Data ³ 28.12.92 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Emiss„o da rela‡„o das Devolucoes                          ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe e ³ MATR770R3(void)                                            ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Generico                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ PROGRAMADOR  ³ DATA   ³ BOPS ³  MOTIVO DA ALTERACAO                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Marcello     ³29/08/00³oooooo³Impressao de casas decimais de acordo   ³±±
±±³              ³        ³      ³com a moeda selecionada e conversao     ³±±
±±³              ³        ³      ³(xmoeda)baseada na moeda gravada na nota³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Matr770R3()
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL wnrel
LOCAL titulo :=OemToAnsi(STR0001)	//"Relacao das Devolucoes de Vendas"
LOCAL cDesc1 :=OemToAnsi(STR0002)	//"Este relat¢rio ir  imprimir a rela‡„o de itens"
LOCAL cDesc2 :=OemToAnsi(STR0003)	//"referentes as devolu‡¢es de vendas."
LOCAL cDesc3 :=""
LOCAL cString:="SF1", OldAlias := alias()

PRIVATE tamanho :="G"
PRIVATE cPerg   := "MTR770"
PRIVATE aReturn := { STR0004, 1,STR0005, 1, 2, 1, "",1 }			//"Zebrado"###"Administracao"
PRIVATE nomeprog:= "MATR770",nLastKey := 0
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel := "MATR770"
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Verifica as perguntas selecionadas                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
pergunte(cPerg,.F.)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para parametros                         ³
//³ mv_par01             // Data digitacao De         	        ³
//³ mv_par02             // Data digitacao Ate                   ³
//³ mv_par03             // Fornec. de                           ³
//³ mv_par04             // Fornec. Ate                          ³
//³ mv_par05             // Loja de                              ³
//³ mv_par06             // Loja Ate                             ³
//³ mv_par07             // CFO de                               ³
//³ mv_par08             // CFO Ate                              ³
//³ mv_par09             // Qual moeda                           ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea(OldAlias)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Envia controle para a funcao SETPRINT                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
wnrel:=SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.F.,"",.F.,Tamanho)

If nLastKey==27
	dbClearFilter()
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey==27
	dbClearFilter()
	Return
Endif

RptStatus({|lEnd| C770Imp(@lEnd,wnRel,cString)},Titulo)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ C770IMP  ³ Autor ³ Rosane Luciane Chene  ³ Data ³ 09.11.95 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Chamada do Relatorio                                       ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ MATR770			                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function C770Imp(lEnd,WnRel,cString)
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
LOCAL CbTxt
LOCAL CbCont
LOCAL limite :=220
LOCAL titulo :=OemToAnsi(STR0001)	//"Relacao das Devolucoes de Vendas"
LOCAL cDesc1 :=OemToAnsi(STR0002)	//"Este relat¢rio ir  imprimir a rela‡„o de itens"
LOCAL cDesc2 :=OemToAnsi(STR0003)	//"referentes as devolu‡¢es de vendas."
LOCAL cDesc3 :=""
LOCAL nTotal := 0 ,nIpi
LOCAL cTipAnt,cChave,condicao,condicao1
LOCAL cTipGrp
LOCAL cProdAnt
LOCAL cQuebra
LOCAL cNomArq, lDevolucao
LOCAL aImpostos :={}
Local nCusto:=0
Local nX := 0
Local nI := 0
Local aColuna  := {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}
Local aCampos  := {}
Local aCabec   := {} 
Local aQuebra  := {}
Local nPosI    := 0
Local cPicture := ""
Local cCampo   := "" 
Local nLen     := 0

PRIVATE nImpInc,cCampoImp
PRIVATE nDecs:=msdecimais(mv_par09)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Variaveis utilizadas para Imporessao do Cabecalho e Rodape   ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
titulo:= STR0001 + " - " + GetMv( "MV_MOEDA" + STR(mv_par09,1) )

//Monta array com campos usados no relatório de acordo com exemplo abaixo: 
//{ cNomeCampo, cTituloColuna, nEspaços, lLarguraFixa, nTamanho, cAlinhamento }
//Detalhes sobre os campos no cabeçalho da função MontaCabec()
aCampos := {}
aAdd( aCampos, { "D1_DOC" } )
aAdd( aCampos, { "D1_COD" } )
aAdd( aCampos, { "B1_DESC",,, .T., 18 } )
aAdd( aCampos, { "D1_QUANT",,,,, "D" } )
aAdd( aCampos, { "B1_UM" } )
aAdd( aCampos, { "D1_VUNIT",,,,, "D" } )
aAdd( aCampos, { "D1_IPI", STR0025,,,, "D" } )	//IPI
aAdd( aCampos, { "D1_TOTAL",,,,, "D" } )
If cPaisLoc <> "MEX"
	aAdd( aCampos, { "D1_PICM", STR0026,,,, "D" } )	//ICMS 
EndIf
aAdd( aCampos, { "D1_FORNECE" } )
aAdd( aCampos, { "A1_NOME",,, .T., 18 } )
aAdd( aCampos, { "D1_TIPO",,, .T., 8 } )
aAdd( aCampos, { "D1_TES",,, .T., 8 } )
aAdd( aCampos, { "D1_TP",,, .T., 8 } )
aAdd( aCampos, { "D1_DTDIGIT",,, .T., 10 } )
aAdd( aCampos, { "D1_CUSTO",,,,, "D" } )  
aAdd( aCampos, { "D1_NFORI" } )
aAdd( aCampos, { "D1_SERIORI",,, .T. } )

aCabec := MontaCabec( @aCampos )
cabec1  := aCabec[1]
aColuna := aCabec[2]

cabec2:= ""
cbtxt := SPACE(10)
cbcont:= 00
Li    := 80
m_pag := 01

nTipo := IIF(aReturn[04]==1,GetMv("MV_COMP"),GetMv("MV_NORM"))

cNomArq := Criatrab(NIL,.F.)

cFiltro := dbFilter()
cFiltro += If(!Empty(cFiltro),".And.","")
cFiltro += "F1_FILIAL=='"+xFilial("SF1")+"'"
cFiltro += ".And.F1_TIPO=='D'.And.dtos(F1_DTDIGIT)>='"+dtos(mv_par01)+"'.And.dtos(F1_DTDIGIT)<='"+dtos(mv_par02)+"'"
cFiltro += ".And.F1_FORNECE>='"+mv_par03+"'.And.F1_FORNECE<='"+mv_par04+"'"
cFiltro += ".And.F1_LOJA>='"+mv_par05+"'.And.F1_LOJA<='"+mv_par06+"'"
cFiltro += ".And. !("+IsRemito(2,"SF1->F1_TIPODOC")+")"		

dbSelectArea("SF1")
IndRegua("SF1",cNomArq,IndexKey(),,cFiltro,STR0007)			//"Selecionando Registros ... "
dbGotop()

SetRegua(RecCount())		// Total de Elementos da regua

While !Eof()
	nImpInc:=0
	
	IF lEnd
		Exit
	Endif
	
	IncRegua()
	
	If F1_DTDIGIT < mv_par01 .Or. F1_DTDIGIT > mv_par02 .Or. F1_TIPO != "D"
		dbSkip()
		Loop
	Endif
	
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	cNFOri:= D1_NFORI
	cSerie:= D1_SERIORI
	lDevolucao := .F.
	
	While !Eof() .And. ;
		D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == ;
		xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA
		
		aQuebra := {}		
		nPosI   := 1
		
		If lEnd
			Exit
		Endif
		
		If D1_TIPO != "D" .Or. D1_CF < mv_par07 .Or. D1_CF > mv_par08
			dbSkip()
			Loop
		Endif
		
		lDevolucao := .T.
		
		If Li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		
		dbSelectArea("SB1")
		SB1->(dbSetOrder(1))
		SB1->(dbSeek( xFilial() + SD1->D1_COD )) 
		
		dbSelectArea("SA1")
		SA1->( dbSetOrder(1) )
		SA1->( dbSeek( xFilial() + SD1->D1_FORNECE + SD1->D1_LOJA ) )
		
		dbSelectArea("SD1")
		If ( cPaisLoc # "BRA" )
			aImpostos := TesImpInf(SD1->D1_TES)
			For nX := 1 to len(aImpostos)
				If ( aImpostos[nX][3] == "1" )
					cCampoImp := aImpostos[nX][2]
					nImpInc	+= &cCampoImp
				EndIf
			Next
		EndIf
		
		//Imprime as linhas do relatório
		For nX := 1 To Len(aCampos)
				    
			cPicture := AllTrim(X3Picture(aCampos[nX,1]))
			cCampo   := X3Arquivo(aCampos[nX,1]) + "->" + aCampos[nX,1]
			
			//Verifica se campo é numérico para não permitir quebra
			If ValType(&(cCampo)) == "C"
				nLen := Len( AllTrim( &( cCampo ) ) )
			Else
				nLen := 0
			EndIf
			
			//Trata campos específicos		
			If cCampo == "SD1->D1_CUSTO"
				xValor := IIf( mv_par09 == 1, SD1->D1_CUSTO, &( "SD1->D1_CUSTO" + Str( mv_par09, 1 ) ) )
			ElseIf cCampo == "SD1->D1_VUNIT"
				xValor := xMoeda( SD1->D1_VUNIT, SF1->F1_MOEDA, mv_par09, SD1->D1_DTDIGIT, nDecs+1, SF1->F1_TXMOEDA )
			ElseIf cCampo == "D1_IPI"
				If cPaisLoc != "BRA"
					xValor := SD1->D1_ALQIMP1
				Else
					xValor := SD1->D1_IPI
				EndIf
			Else
				xValor := &( cCampo )
			EndIf
			
			//Verifica se há quebra de linha para armazenar em um array para impressão posterior
			If nLen > aCampos[nX,5]
				xValor := SubStr( &(cCampo), 1, aCampos[nX,5] )
				nPosI := 1 + aCampos[nX,5]
				If nPosI < Len(&(cCampo))					
					aAdd( aQuebra, { aColuna[nX], SubStr( &(cCampo), nPosI, aCampos[nX,5] ) } )				
				EndIf
			EndIf
			
			//Imprime campo
			@Li, aColuna[nX] PSAY IIf( ValType(xValor) == "C" .And. Len(AllTrim(xValor)) > 0, AllTrim(xValor), xValor ) PICTURE cPicture			
		
		Next     
		
		//Se houve quebra de texto na célula, imprime a quebra
		If Len(aQuebra) > 0
			Li++
			For nI := 1 To Len(aQuebra)
				@ Li, aQuebra[nI,1] PSAY AllTrim(aQuebra[nI,2])
			Next
		EndIf
	
		Li++
		
		SD1->(dbSkip())
	
	EndDo
	
	If lDevolucao
		nTotal += ImpTotN(titulo)
		ImpDupl(cNFOri,cSerie)
		@ Li,00 PSAY __PrtThinLine()
		Li++
	Endif
	
	dbSelectArea("SF1")
	dbSkip()
	
EndDo

If Li != 80
	If nTotal != 0
		If Li > 55
			cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
		Endif
		Li++
		@ Li,170  PSAY STR0023 //"TOTAL GERAL       --> "
		@ Li,198  PSAY nTotal	Picture PesqPict("SF1","F1_VALMERC",16,mv_par09)
		Li++
		If lEnd
			@ Li+1,000  PSAY STR0008	//"CANCELADO PELO OPERADOR"
		Endif
		roda(CbCont,"NOTAS","G")
	Endif
EndIf

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Restaura a Integridade dos dados                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
dbSelectArea("SD1")
dbSetOrder(1)

dbSelectArea("SF1")
RetIndex("SF1")
dbClearFilter()
dbSetOrder(1)

If File(cNomArq+OrdBagExt())
	Ferase(cNomArq+OrdBagExt())
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se em disco, desvia para Spool                               ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If aReturn[5] == 1
	Set Printer To
	dbCommitAll()
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Total Da Nota Fiscal                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ImpTotN(titulo)
LOCAL nTotNota:=0
If Li > 55
	cabec(titulo,cabec1,cabec2,nomeprog,tamanho,nTipo)
Endif
If ( cPaisLoc=="BRA" )
	nTotNota:= SF1->F1_VALMERC + SF1->F1_FRETE + SF1->F1_DESPESA + SF1->F1_VALIPI + SF1->F1_ICMSRET - SF1->F1_DESCONT
Else
	nTotNota:= SF1->F1_VALMERC + SF1->F1_FRETE + SF1->F1_DESPESA + nImpInc - SF1->F1_DESCONT
EndIf

nTotNota:=xMoeda(nTotNota,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,SF1->F1_TXMOEDA)

@ Li,120 PSAY STR0009	//"TOTAL DESCONTOS --> "
@ Li,150 PSAY xMoeda(SF1->F1_DESCONT,SF1->F1_MOEDA,mv_par09,SF1->F1_DTDIGIT,nDecs+1,Sf1->F1_TXMOEDA) picture PesqPict("SF1","F1_DESCONT",14,mv_par09)

@ Li,170 PSAY STR0010	//"TOTAL NOTA FISCAL --> "
@ Li,200 PSAY nTotNota picture Pesqpict("SF1","F1_VALMERC",14,mv_par09)
Li+=1

//Return xMoeda(nTotNota,1,mv_par09,SF1->F1_DTDIGIT)
Return nTotNota



//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Imprime Todas duplicatas da nota fiscal de Saida             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function ImpDupl(cNFOri,cSerie)
LOCAL cSeek, i        
Local cPrefixo := ""         

cPrefixo := BuscaPref(cNFOri,cSerie)

dbSelectArea("SE1")
dbSetOrder(1)
cSeek:=xFilial("SE1")+cPrefixo+cNFOri
If dbSeek(cSeek,.F.)
	@ Li,53 PSAY STR0011
	Li++		//"Duplicatas da Nota Fiscal de Saida"
	For i := 1 To 121 Step 60
			@ Li,i PSAY STR0013 // "Prf Numero               Parc.    Venc.              Saldo"
	Next i
	Li++
	While !Eof() .And. cSeek==E1_FILIAL+E1_PREFIXO+E1_NUM
		For i := 1 To 121 Step 60
			@ Li,i    PSAY E1_PREFIXO
			@ Li,i+4  PSAY E1_NUM
			@ Li,i+25 PSAY E1_PARCELA
			@ Li,i+34 PSAY E1_VENCTO
		  	@ Li,i+44 PSAY xMoeda(E1_SALDO,E1_MOEDA,mv_par09,SE1->E1_EMISSAO) picture PesqPict("SE1","E1_SALDO",14,mv_par09)			  

			dbSkip()
			IF cSeek!=E1_FILIAL+E1_PREFIXO+E1_NUM
				Exit
			Endif
		Next i
		Li++
	EndDo
Else
	@ Li,53 PSAY STR0012	//"Nao houve titulos gerados na saida"
EndIf
Li++

Return

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Retorna prefixo utilizado no titulo a pagar                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
Static Function BuscaPref(cNFOri,cSerieOri)

Local cPrefixo := ""

dbSelectArea("SF2")
dbSetOrder(1)
dbSeek(xFilial()+cNFOri+cSerieOri)
If Empty(SF2->F2_PREFIXO)
	cPrefixo := Alltrim(Posicione("SX6",1,xFilial()+"MV_1DUPREF","X6_CONTEUD"))
	If Empty(cPrefixo) //Caso não exista o parametro na filial posicionada, pega o coteudo (GetMv)
		cPrefixo := &(GetMV("MV_1DUPREF"))
	EndIf
Else
	cPrefixo := SF2->F2_PREFIXO
EndIf

Return(cPrefixo)


/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Função   ³ MontaCabec º Autor ³ Danilo Dias      º Data ³ 11/08/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÊÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÊÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descr.   ³ Monta cabeçalho para relatórios sem TReport de forma       º±±
±±º          ³ dinâmica, levando em consideração o tamanho do campo no X3 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Param.   ³ aCampo - Array com os campos do relatório.                 º±±
±±º          ³  [1] C - Nome do campo.                                    º±±
±±º          ³  [2] C - Título da coluna, se não informar pega do SX3.    º±±
±±º          ³  [3] N - Quantidade de espaços entre a próxima coluna.     º±±
±±º          ³  [4] L - Indica se a largura da coluna deve ser fixa.      º±±
±±º          ³  [5] N - Tamanho do campo quando este for fixo.            º±±
±±º          ³  [6] C - Alinhamento da coluna. ( D=Direita | E=Esquerda ) º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ cCabecalho - String com o cabeçalho do relatório.          º±±
±±º          ³ aColunas - Array com as posições das colunas do relatório. º±±
±±º          ³  [1] N - Posição onde cada coluna deve iniciar.            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Uso      ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function MontaCabec( aCampos )
             
Local cCabecalho := ""
Local cCampo     := ""
Local cAlinha    := ""
Local aColunas   := {}
Local aRetorno   := {} 
Local nColuna    := 0
Local nTamanho   := 0
Local nEspaco    := 0
Local nI         := 0 
Local nJ         := 0

              
If ValType(aCampos) == "A" .And. Len(aCampos) > 0
    
	//Completa array com nulo nos parâmetros não informados
	For nI := 1 To Len(aCampos)
		For nJ := Len(aCampos[nI])+1 To 6
			aAdd( aCampos[nI], Nil )
		Next
	Next
	              
	For nI := 1 To Len(aCampos)
	
		//Verifica se o tamanho do campo é fixo ou não
		lFixo := aCampos[nI,4]
		
		//Pega o tamanho do campo no SX3 ou a posição 5 do array caso
		//o parâmetro de valor fixo seja True.
		If !lFixo
			nTamanho := TamSX3( aCampos[nI,1] )[1]
			aCampos[nI,5] := nTamanho
		Else
			If !Empty(aCampos[nI,5]) .And. aCampos[nI,5] > 0
				nTamanho := aCampos[nI,5]
			Else
				nTamanho := Len( RetTitle( aCampos[nI,1] ) )
				aCampos[nI,5] := nTamanho
			EndIf
		EndIf
		
		//Alinhamento do título
		cAlinha  := aCampos[nI,6]
		//Define espaço em branco entre a próxima coluna
		nEspaco  := IIf( Empty(aCampos[nI,3]) .Or. aCampos[nI,3] <= 0, nEspaco := 1, nEspaco := aCampos[nI,3] )
		
		//Alinha título do campo de acordo com parâmetro 6, adicionando espaços
		//em branco de acordo com o tamanho do campo
		If cAlinha == "D"	//Alinha à direita
			If Empty(aCampos[nI,2])
				//Pega o título do SX3
				cCampo := PadL( AllTrim( RetTitle( aCampos[nI,1] ) ), nTamanho )
				aCampos[nI,2] := cCampo
			Else  
				//Pega o campo do parâmetro 2, se for informado um título fixo
			    cCampo := PadL( AllTrim( aCampos[nI,2] ), nTamanho )
			EndIf
		Else	//Alinha à esquerda
			If Empty(aCampos[nI,2]) 
				cCampo := PadR( AllTrim( RetTitle( aCampos[nI,1] ) ), nTamanho )
				aCampos[nI,2] := cCampo
			Else
			    cCampo := PadR( AllTrim( aCampos[nI,2] ), nTamanho )
			EndIf
		EndIf	
		
		//Corta o título se for maior que o tamanho do campo ou o tamanho for fixo
		IIf( Len(cCampo) > nTamanho .And. !lFixo, cCampo := SubStr( cCampo, 1, nTamanho ), cCampo )
		
		//Monta o texto do cabeçalho	
		cCabecalho += PadR( cCampo, Len(cCampo) + nEspaco )
		
		//Monta array com posição das colunas e atualiza para próxima coluna
		aAdd( aColunas, nColuna )                                                                                        
		nColuna := nColuna + Len(cCampo) + nEspaco
	Next 
	
	//Monta retorno
	aRetorno := { cCabecalho, aColunas }

EndIf
	             
Return aRetorno 



/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±º Função   ³ X3Arquivo º Autor ³ Danilo Dias       º Data ³ 12/08/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Descr.   ³ Retorna o Alias do campo informado.                        º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±± 
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Param.   ³ cCampo - Nome do campo que se deseja retornar o Alias.     º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º Retorno  ³ cAlias - Alias do campo informado.                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Geral                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function X3Arquivo( cCampo )

Local aArea    := GetArea()
Local aAreaSX3 := SX3->(GetArea())
Local cAlias   := ""

dbSelectArea("SX3")
SX3->(dbSetOrder(2))	//X3_CAMPO

If SX3->(dbSeek( cCampo ))
	cAlias := SX3->X3_ARQUIVO
EndIf

RestArea(aAreaSX3)
RestArea(aArea)

Return cAlias