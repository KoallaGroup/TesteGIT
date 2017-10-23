#INCLUDE "XFINC010.CH"
#INCLUDE 'PROTHEUS.CH'
#INCLUDE "RWMAKE.CH"

#DEFINE QTDETITULOS	1
#DEFINE MOEDATIT	2
#DEFINE VALORTIT	3
#DEFINE VALORREAIS	4

User Function FC010BOL(nBrowse,aAlias,aAlias1,aParam,lExibe,aGet,lRelat)

Local aArea		:= GetArea()
Local aAreaSC5	:= SC5->(GetArea())
Local aAreaSC6	:= SC6->(GetArea())
Local aAreaSC9	:= SC9->(GetArea())
Local aAreaSF4	:= SF4->(GetArea())
Local aStru		:= {}
Local aQuery	:= {}
Local aSay		:= {"","","","","","","",""}
Local oGetDb
Local oScrPanel
Local oBold
Local oDlg
Local oBtn
Local bVisual
Local bWhile
Local bFiltro
Local cAlias	:= ""
Local cAlias1	:= ""
Local cArquivo	:= ""
Local cArquivo1	:= ""
Local cCadastro	:= ""
Local oDlg
Local oButton
Local oCombo
Local cCombo := ""
#IFDEF TOP
	Local cQuery	:= ""
	Local cDbMs
#ENDIF	
Local cQry		:= ""
Local cChave	:= ""
Local lQuery	:= .F.
Local nCntFor	:= 0
Local nSalped	:= 0
Local nSalpedl	:= 0
Local nSalpedb	:= 0
Local nQtdPed	:= 0
Local nTotAbat	:= 0
Local cAnterior	:= ""
Local nTaxaM	:= 0	
Local nMoeda
Local oTipo
Local nTipo		:= 1
Local bTipo
Local oCheq
Local aTotRec	:= {{0,1,0,0}} // Totalizador de titulos a receber por por moeda
Local aTotPag	:= {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
Local nAscan
Local nTotalRec	:=0
Local aSize		:= MsAdvSize( .F. )
Local aPosObj1	:= {}                 
Local aObjects	:= {}                       
Local aCpos		:= {}
Local cCheques	:=	IIF(Type('MVCHEQUES')=='C',MVCHEQUES,MVCHEQUE)
Local nI
Local lPosClFt	:= (SuperGetMv("MV_POSCLFT",.F.,"N") == "S")
Local bCond
Local cOrdem	:= ""
Local cNumAnt	:= ""
Local cTpDocAnt	:= ""
Local cParcAnt	:= ""
Local lFC010Head := ExistBlock("FC010HEAD")
Local cSaldo := ""
Local lFC010Pedi := ExistBlock("FC010Pedi")
Local aRetAux	:= {}
Local lFC0101FAT	:= ExistBlock("FC0101FAT")
Local lFC0102FAT	:= ExistBlock("FC0102FAT")
Local lFC0103FAT	:= ExistBlock("FC0103FAT")
Local aAuxCpo		:= {}
Local aHeader1		:=	{}
Local nA				:=	0
Local nMulta		:= 0                            //Valor da Multa
Local cMvJurTipo 	:= SuperGetMv("MV_JURTIPO",,"") //Tipo de Calculo de Juros do Financeiro	
Local lLojxRMul  	:= FindFunction("LojxRMul")        //Funcao que calcula a Multa do Financeiro
Local lMvLjIntFS   := SuperGetMv("MV_LJINTFS", ,.F.) //Habilita Integração com o Financial Services
/*
GESTAO - inicio */
Local nPosAlias	:= 0
Local cCompSC5	:= ""
/* GESTAO - fim
*/
Private aHeader	:= {}
DEFAULT lRelat	:= .F.

aGet := {"","","","","","","",""}
aGet1 := {"","","","","","","",""}

Do Case
Case ( nBrowse == 1 )	
	cCadastro := STR0025
	cAlias    := "FC010QRY01"
	cAlias1   := "FC010QRY01A"
	aSay[1]   := STR0032 //"Qtd.Tit."
	aSay[2]   := STR0033 //"Principal"
	aSay[3]   := STR0120 //"Saldo a Receber"
	aSay[4]   := STR0046 //"Juros"
	aSay[5]   := STR0091 //"Acresc."
	aSay[6]   := STR0092 //"Decresc."
	aSay[7]   := STR0086 //"Abatimentos"
	aSay[8]   := STR0104 //"Tot.Geral"	
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 2 )
	cCadastro := STR0122
	cAlias    := "FC010QRY02"
	aSay[1]   := STR0036 //"Qtd.Pag."
	aSay[2]   := STR0037 //"Principal"
	aSay[3]   := STR0038 //"Vlr.Pagto"
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 3 )
	cCadastro := STR0027
	cAlias    := "FC010QRY03"
	aSay[1]   := STR0039 //"Qtd.Ped."
	aSay[2]   := STR0040 //"Tot.Pedido"
	aSay[3]   := STR0041 //"Tot.Liber."
	aSay[4]   := STR0042 //"Sld.Pedido"
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 4 )
	cCadastro := STR0028
	cAlias    := "FC010QRY04"
	aSay[1]   := STR0043 //"Qtd.Notas"
	aSay[2]   := STR0044 //"Tot.Fatur."
	bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,nBrowse) }
Case ( nBrowse == 5 )
   cCadastro := STR0061 //"Cartera de cheques"
   cAlias    := "FC010QRY05"
   aSay[1]   := STR0062 //"Pendiente"
	If cPaisLoc$"URU|BOL"
		aSay[2]   := STR0088 //"Rechazado"
	Else
	   aSay[2]   := STR0063 //"Negociado"
	Endif   
	aSay[3]   := STR0064 //"Cobrado"
	If cPaisLoc$"ARG|COS"
		aSay[4]   := STR0134 //"Em Transito"
	Endif
   bVisual   := {|| Fc010Visua((cAlias)->XX_RECNO,If( (cAlias)->XX_ESTADO == "TRAN",5,1) ) }

EndCase

Do Case
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³Titulo em Aberto                                                        ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case ( nBrowse == 1 )
		If !lRelat
			Aadd(aHeader,{"",	"XX_LEGEND","@BMP",10,0,"","","C","",""})
			Aadd(aStru,{"XX_LEGEND","C",12,0})
		Endif	
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("E1_LOJA")
		If aParam[13] == 2  //Considera loja		
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		Endif
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* 
		GESTAO - inicio */
		dbSeek("E1_FILORIG")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* GESTAO - fim
		*/
		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_TIPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_CLIENTE")
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_VENCTO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_BAIXA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				
		If !lRelat
			dbSeek("E1_MOEDA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			
			dbSeek("E1_VALOR")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			
		Endif	

		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		aadd(aHeader,{STR0086,"E1_ABT","@E 999,999,999.99",14,2,"","","N","","V" } ) //"Abatimentos"
		aadd(aStru ,{"E1_ABT","N",14,2})

		dbSeek("E1_SDACRES")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_SDDECRE")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E1_VALJUR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
		//³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
		//³ coluna com a provisao de multa de titulos em atraso.        ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		If GetNewPar( "MV_ACATIVO", .F. )
			dbSeek("E1_VLMULTA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL}) 
			
		   dbSeek("E1_MULTA")		
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Else
				//Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicio
			/*BEGINDOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Calculo de juros e multas, segundo o controle de loja³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ENDDOC*/
			If (cMVJurTipo == "L" .OR. lMvLjIntFS).AND. lLojxRMul
	 		   	dbSeek("E1_MULTA")		
				aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
				aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			EndIf  
				//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final
		Endif   
		
		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicio	
		/*BEGINDOC
		// ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		// ³Calculo de juros e multas, segundo o controle de loja³
		// ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		ENDDOC */
		If (cMVJurTipo == "L" .OR. lMvLjIntFs) .and. lLojxRMul
 		   	dbSeek("E1_ACRES")		
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			
			dbSeek("E1_JUROS")		
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		EndIf 
		//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final

		dbSeek("E1_SALDO")
		aadd(aHeader,{STR0120,SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )	//"Saldo a Receber"
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{ STR0103,"E1_SALDO2",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) // "Saldo na moeda tit"
		aadd(aStru ,{"E1_SALDO2",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_PORTADO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		

		dbSeek("E1_NUMBCO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E1_NUMLIQ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E1_HIST")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		aadd(aHeader,{STR0035,"E1_ATR","9999999999",10,0,"","","N","","V" } ) //"Atraso"
		aadd(aStru ,{"E1_ATR","N",10,0})

		If !lRelat
			dbSeek("E1_CHQDEV")
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		#ifdef SPANISH
			Aadd(aStru,{"X5_DESCSPA","C",25,0})
		#else
			#ifdef ENGLISH
				Aadd(aStru,{"X5_DESCENG","C",25,0})			
			#else
				Aadd(aStru,{"X5_DESCRI","C",25,0})
			#endif
		#endif
		
		aadd(aStru,{"XX_RECNO","N",12,0})
		aadd(aStru,{"E1_MOEDA","N",02,0})

		aadd(aQuery,{"E1_PORCJUR","N",12,4})
		aadd(aQuery,{"E1_MOEDA","N",02,0})
		aadd(aQuery,{"E1_VALOR","N",16,2})
		
		If cPaisLoc == "BRA"
			aadd(aQuery,{"E1_TXMOEDA","N",17,4})
		Endif	

		#ifdef SPANISH
			Aadd(aHeader,{STR0045,"X5_DESCSPA","@!",25,0,"","","C","SX5","" } ) //"Situacao"					
		#else
			#ifdef ENGLISH
				Aadd(aHeader,{STR0045,"X5_DESCENG","@!",25,0,"","","C","SX5","" } ) //"Situacao"								
			#else
				Aadd(aHeader,{STR0045,"X5_DESCRI","@!",25,0,"","","C","SX5","" } ) //"Situacao"
			#endif
		#endif             
		
		IF lFC010Head
			aHeader1 :=	aHeader			
			aHeader 	:=	ExecBlock("FC010HEAD",.F.,.F.,aHeader)							
						
			For nA:=1 to Len(aHeader)
				If Ascan(aHeader1,{|e| e[2] = aHeader[nA,2]}) = 0//Campo nao estava no header incluir tambem nestes vetores.         
					aadd(aStru ,{aHeader[nA,2],aHeader[nA,8],aHeader[nA,4],aHeader[nA,5]})
					aadd(aQuery,{aHeader[nA,2],aHeader[nA,8],aHeader[nA,4],aHeader[nA,5]})												
				Endif					
			Next										
		EndIf

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"E1_FILORIG+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
					
					#ifdef SPANISH
						cQuery += ",SX5.X5_DESCSPA "
					#else
						#ifdef ENGLISH
							cQuery += ",SX5.X5_DESCENG "				
						#else
							cQuery += ",SX5.X5_DESCRI "								
						#endif
					#endif
					
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SX5")+" SX5 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE1")
					cQuery += "WHERE SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					If ( aParam[5] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
					EndIf					
					If ( aParam[15] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'RA ' AND "	
					Endif
					cQuery += "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery += "SE1.E1_PREFIXO<='"+aParam[7]+"' AND " 
					If cPaisLoc != "BRA"
						cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
					Endif	
					cQuery += "SE1.E1_SALDO > 0 AND "

					If aParam[11] == 2 // Se nao considera titulos gerados pela liquidacao
						If aParam[09] == 1 
							cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						Else  
						  cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "						
						  cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						Endif	
					Else
						If aParam[09] == 2
							cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "						
						Endif	
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              		//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
	              	//³ arquivo compartilhado.  Titulos em aberto           ³
              		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (ExistBlock("FO10FILT"))    
						cQuery += ExecBlock("FO10FILT",.F.,.F.)
					Endif                    

					cQuery +=		"SE1.D_E_L_E_T_ = ' ' AND "
					cQuery +=      "SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
					cQuery +=		"SX5.X5_TABELA='07' AND "
					cQuery +=		"SX5.X5_CHAVE=SE1.E1_SITUACA AND "
					cQuery +=		"SX5.D_E_L_E_T_ = ' ' "

					cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' UNION ALL "+cQuery
					cQuery += "AND SE1.E1_TIPO LIKE '__-'"
					
					If UPPER(TcGetDb()) != "INFORMIX"
						cQuery   += " ORDER BY  " + SqlOrder("E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO")
					Endif	
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              	    //³ Ponto de entrada para alteracao da cQuery na consulta Titulos em Aberto ³
              	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (ExistBlock("F010CQTA"))    
						cQuery := ExecBlock("F010CQTA",.F.,.F.,{cQuery})
					Endif  
					
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Else
			#ENDIF
				cQry := "SE1"
			#IFDEF TOP
				EndIf
			#ENDIF
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
            	If aParam[13] == 1 //Considera loja
					dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE .And.;
												SA1->A1_LOJA   == SE1->E1_LOJA }
				Else
					dbSeek(xFilial("SE1")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE }
				Endif
				
				bFiltro:= {|| !(SE1->E1_TIPO $ MVABATIM) .And.;
									SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
									If(aParam[15]==2,!SE1->E1_TIPO$MVRECANT,.T.) .And.;
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7] .And.;
									SE1->E1_SALDO   > 0 .And.;
									IIf(cPaisLoc == "BRA",.T.,!(SE1->E1_TIPO$cCheques)) .And.;
									IIF(aParam[11] == 2, Empty(SE1->E1_NUMLIQ) .And. Empty(SE1->E1_TIPOLIQ),.T.)}
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) )
					If ( !lQuery )
						dbSelectArea("SX5")
						dbSetOrder(1)
						MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
					EndIf
					dbSelectArea(cAlias)
					dbSetOrder(1)
					cChave := (cQry)->E1_FILORIG+(cQry)->(E1_CLIENTE)+(cQry)->(E1_LOJA) +;
								 (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+;
								 (cQry)->(E1_PARCELA)
					cChave += If((cQry)->(E1_TIPO)	$ MVABATIM, "",;
					              (cQry)->(E1_TIPO))
					If ( !dbSeek(cChave) )
						RecLock(cAlias,.T.)						
					Else
						RecLock(cAlias,.F.)
					EndIf
					DbSetOrder(1)
					nTotAbat := 0
					
					//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Inicio 
					nMulta := 0 
					If (cMVJurTipo == "L" .OR. lMvLjIntFS) .AND. lLojxRMul .And. aParam[12] == 2
						nMulta := LojxRMul( , , ,(cQry)->E1_SALDO, (cQry)->E1_ACRESC, (cQry)->E1_VENCREA,  , , (cQry)->E1_MULTA, ,;
		  				 						  (cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA, (cQry)->E1_TIPO, (cQry)->E1_CLIENTE, (cQry)->E1_LOJA,  ) 
					EndIf
					//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final
					 
					For nCntFor := 1 To Len(aStru)
						Do Case
						
						#ifdef SPANISH
							Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCSPA" )
								If !( (cQry)->(E1_TIPO)	$ MVABATIM )
									If ( lQuery )
										(cAlias)->X5_DESCSPA := (cQry)->X5_DESCSPA
									Else
										(cAlias)->X5_DESCSPA := SX5->X5_DESCSPA
									EndIf
								Endif	
						#else
							#ifdef ENGLISH
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCENG" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias)->X5_DESCENG := (cQry)->X5_DESCENG
										Else
											(cAlias)->X5_DESCENG := SX5->X5_DESCENG
										EndIf
									Endif	
							#else
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias)->X5_DESCRI := (cQry)->X5_DESCRI
										Else
											(cAlias)->X5_DESCRI := SX5->X5_DESCRI
										EndIf
									Endif	
							#endif
						#endif
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VALJUR" )
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ABT" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							Endif
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->E1_ABT += (nTotAbat := xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,(cQry)->(E1_EMISSAO),,nTaxaM))
							Endif
							If ( !lQuery )
								(cAlias)->E1_ABT := (nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA))
							Endif
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							Endif	
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2	 // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias)->E1_SALDO -= nTotAbat
								Endif
							Else
								(cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias)->E1_SALDO += xMoeda((cQry)->(E1_SDACRES) - (cQry)->(E1_SDDECRE),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									(cAlias)->E1_SALDO += xMoeda(FaJuros((cQry)->E1_VALOR,(cQry)->E1_SALDO,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0),(cQry)->E1_BAIXA,(cQry)->E1_VENCREA,,(cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA,(cQry)->E1_TIPO),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0)) 	//REQ020-Calculo de Juros e Multas: SIGALOJA x SIGAFIN 
									 //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicil
									(cAlias)->E1_SALDO += xMoeda(nMulta,(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
								    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final


									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
									//³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
									//³ provisao de multa no saldo de titulos em atraso.            ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If GetNewPar( "MV_ACATIVO", .F. )									
											(cAlias)->E1_SALDO += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									Endif
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO -= nTotAbat
								Endif
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 -= nTotAbat
								Endif
							Else
								(cAlias)->E1_SALDO2 += (cQry)->(E1_SALDO)
									//Calculo de Juros e Multas: SIGALOJA x SIGAFIN   -Inicio
								(cAlias)->E1_VALJUR := xMoeda(FaJuros((cQry)->E1_VALOR,(cAlias)->E1_SALDO2,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0),(cQry)->E1_BAIXA,(cQry)->E1_VENCREA,,(cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA,(cQry)->E1_TIPO),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))										    
								/*BEGINDOC
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD¿
								//³Se o calculo de juros e multa for do controle de lojas, ³
								//³considera os juros e multas no saldo                    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÙ
								ENDDOC*/
							    If (cMVJurTipo == "L" .OR. lMvLjIntFs)  .AND. lLojxRMul							    
							    	(cAlias)->E1_MULTA := nMulta 
							    EndIf 
							    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final							   								
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 += (cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE
									(cAlias)->E1_SALDO2 += xMoeda((cAlias)->E1_VALJUR,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM) 
									If (cMVJurTipo == "L" .OR. lMvLjIntFS) .and. lLojxRMul
										(cAlias)->E1_SALDO2 += xMoeda((cAlias)->E1_MULTA,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM) 
                                    EndIf
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
									//³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
									//³ provisao de multa no saldo de titulos em atraso.            ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If GetNewPar( "MV_ACATIVO", .F. )									
											(cAlias)->E1_SALDO2 += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									Endif								
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias)->E1_SALDO2 -= nTotAbat
								Endif
							EndIf		
						Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								If ( lQuery )
									(cAlias)->XX_RECNO := (cQry)->SE1RECNO
								Else
									(cAlias)->XX_RECNO := SE1->(RecNo())
								EndIf
							Endif
						Case ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="XX_LEGEND" )
							If (cQry)->E1_CHQDEV == "1"
								(cAlias)->XX_LEGEND := 	"BR_AMARELO"
							Else
								If !((cQry)->E1_TIPO $ MVABATIM)
									(cAlias)->XX_LEGEND := If(ROUND((cQry)->E1_SALDO,2) != ROUND((cQry)->E1_VALOR,2),"BR_AZUL","BR_VERDE")
								EndIf
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="E1_TIPO" )
							If ( Empty((cAlias)->E1_TIPO) )
								(cAlias)->E1_TIPO := (cQry)->E1_TIPO
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
							//Se o título estiver atrasado, faz o calculo dos dias de atraso
							If dDataBase > (cQry)->E1_VENCREA
								If (((cAlias)->E1_TIPO) $ MVRECANT+"/"+MV_CRNEG)
									(cAlias)->E1_ATR := 0
								Else	
									(cAlias)->E1_ATR := dDataBase - (cAlias)->E1_VENCREA
								EndIf	
							Else 
	 							If MV_PAR16 == 2 //Se o título NÃO estiver atrasado, então tem ATRASO = 0
		 							(cAlias)->E1_ATR := 0
	 							Else
		 							(cAlias)->E1_ATR := dDataBase - DataValida((cAlias)->E1_VENCREA,.T.)
	 							EndIf
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
							If !((cQry)->(E1_TIPO)	$ MVABATIM)
								(cAlias)->E1_VLCRUZ := xMoeda((cQry)->(E1_VALOR),(cQry)->(E1_MOEDA),1,dDataBase,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMULTA" )
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ 11/Ago/2005 Rafael E. Rodrigues                              ³
							//³ Quando o modulo Gestao Educacional estiver em uso eh exibida ³
							//³ a provisao de multa no saldo de titulos em atraso.           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								(cAlias)->E1_VLMULTA := xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)						
						OtherWise							
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
							Endif	
						EndCase
					Next nCntFor
					dbSelectArea(cAlias)
					If nTotAbat = 0
						If ( (cAlias)->E1_SALDO <= 0 )
							dbDelete()
						EndIf
					Endif						
					MsUnLock()
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
			If ( lQuery )
				dbSelectArea(cQry)
				dbCloseArea()
			EndIf
			cOrdem := "DTOS(E1_VENCREA)"

			If (ExistBlock("F010ORD1"))    
				//Retornar chave no formato "E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO"
				cOrdem := ExecBlock("F010ORD1",.F.,.F.)
			Endif                    

			dbSelectArea(cAlias)
			IndRegua(cAlias,cArquivo,cOrdem)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totais da Consulta                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aGet[4] := 0
		aGet[5] := 0
		aGet[6] := 0
		aGet[7] := 0
		aGet[8] := 0
		aTotRec := {{0,1,0,0}} // Totalizador de titulos a receber por moeda
		dbSelectArea(cAlias)
		dbGotop()
		While !EOF()		 			 	
		 	aGet[1]++
		 	If !lRelat
			 	SE1->(DbGoto((cAlias)->XX_RECNO))	// Posiciona no arquivo original para obter os valores
		 				 										// em outras moedas e em R$
				nAscan := Ascan(aTotRec,{|e| e[MOEDATIT] == E1_MOEDA})
			Endif
			
			//Calcular o abatimento para visualização em tela
		 	If (cAlias)->E1_ABT > 0
		 		//(cAlias)->E1_SALDO -= (cAlias)->E1_ABT		 	
		 		(cAlias)->E1_SALDO2 := xMoeda((cAlias)->E1_SALDO,E1_MOEDA,1,dDataBase,,ntaxaM)
		 	Endif		 	
				
			If E1_TIPO $ "RA #"+MV_CRNEG
				aGet[2] -= E1_VLCRUZ
				aGet[3] -= E1_SALDO
				aGet[4] -= E1_VALJUR

				nAcresc := nDecres := 0
				If !lRelat
					nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet[5] -= nAcresc
					aGet[6] -= nDecres
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO*(-1),If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)*(-1)})
					Else
						aTotRec[nAscan][QTDETITULOS]--
						aTotRec[nAscan][VALORTIT]		-= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	-= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif	
				If aParam[12] == 1 //Saldo sem correcao
					aGet[8] -= E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
				Else
					aGet[8] -= E1_SALDO
				Endif
			Else	
				aGet[2] += E1_VLCRUZ
				aGet[3] += E1_SALDO
				aGet[4] += E1_VALJUR
				aGet[7] += E1_ABT
				nAcresc := nDecres := 0
				If !lRelat
					nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet[5] += nAcresc
					aGet[6] += nDecres
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO,If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)})
					Else
						aTotRec[nAscan][QTDETITULOS]++
						aTotRec[nAscan][VALORTIT]		+= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	+= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif
				If aParam[12] == 1 //Saldo sem correcao
					aGet[8] += E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
				Else
					aGet[8] += E1_SALDO
				Endif
			Endif
			dbSkip()
		Enddo
		If !lRelat
			nTotalRec:=0
			aEval(aTotRec,{|e| nTotalRec+=e[VALORREAIS]})
			Aadd(aTotRec,{"","",STR0096,nTotalRec}) //"Total ====>>"
			// Formata as colunas
			aEval(aTotRec,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
										If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
		Endif										

		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		aGet[4] := TransForm(aGet[4],Tm(aGet[4],16,nCasas))
		aGet[5] := TransForm(aGet[5],Tm(aGet[5],16,nCasas))
		aGet[6] := TransForm(aGet[6],Tm(aGet[6],16,nCasas))
		aGet[7] := TransForm(aGet[7],Tm(aGet[7],16,nCasas))		
		aGet[8] := TransForm(aGet[8],Tm(aGet[8],16,nCasas))		
		
		
		If ( Select(cAlias1) ==	0 )
			cArquivo1 := CriaTrab(,.F.)			
			aadd(aAlias1,{ cAlias1 , cArquivo1 })
			//aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo1,aStru)
			dbUseArea(.T.,,cArquivo1,cAlias1,.F.,.F.)
			IndRegua(cAlias1,cArquivo1,"E1_FILORIG+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
					
					#ifdef SPANISH
						cQuery += ",SX5.X5_DESCSPA "
					#else
						#ifdef ENGLISH
							cQuery += ",SX5.X5_DESCENG "				
						#else
							cQuery += ",SX5.X5_DESCRI "								
						#endif
					#endif
					
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SX5")+" SX5 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE1")
					cQuery += "WHERE SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					If ( aParam[5] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
					EndIf					
					If ( aParam[15] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'RA ' AND "	
					Endif
					cQuery += "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery += "SE1.E1_PREFIXO<='"+aParam[7]+"' AND " 
					If cPaisLoc != "BRA"
						cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
					Endif	
					cQuery += "SE1.E1_SALDO > 0 AND "

					If aParam[11] == 2 // Se nao considera titulos gerados pela liquidacao
						If aParam[09] == 1 
							cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						Else  
						  cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "						
						  cQuery += "SE1.E1_NUMLIQ ='"+Space(Len(SE1->E1_NUMLIQ))+"' AND "
						Endif	
					Else
						If aParam[09] == 2
							cQuery += "SE1.E1_TIPOLIQ='"+Space(Len(SE1->E1_TIPOLIQ))+"' AND "						
						Endif	
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              		//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
	              	//³ arquivo compartilhado.  Titulos em aberto           ³
              		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (ExistBlock("FO10FILT"))    
						cQuery += ExecBlock("FO10FILT",.F.,.F.)
					Endif                    

					cQuery +=		"SE1.D_E_L_E_T_ = ' ' AND "
					cQuery +=      "SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
					cQuery +=		"SX5.X5_TABELA='07' AND "
					cQuery +=		"SX5.X5_CHAVE='5' AND  SE1.E1_SITUACA='5' AND "
					cQuery +=		"SX5.D_E_L_E_T_ = ' ' "

					cQuery += "AND SE1.E1_TIPO NOT LIKE '__-' UNION ALL "+cQuery
					cQuery += "AND SE1.E1_TIPO LIKE '__-'"
					
					If UPPER(TcGetDb()) != "INFORMIX"
						cQuery   += " ORDER BY  " + SqlOrder("E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO")
					Endif	
					
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              	    //³ Ponto de entrada para alteracao da cQuery na consulta Titulos em Aberto ³
              	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (ExistBlock("F010CQTA"))    
						cQuery := ExecBlock("F010CQTA",.F.,.F.,{cQuery})
					Endif  
					
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo1+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Else
			#ENDIF
				cQry := "SE1"
			#IFDEF TOP
				EndIf
			#ENDIF
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
            	If aParam[13] == 1 //Considera loja
					dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE .And.;
												SA1->A1_LOJA   == SE1->E1_LOJA }
				Else
					dbSeek(xFilial("SE1")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE }
				Endif
				
				bFiltro:= {|| !(SE1->E1_TIPO $ MVABATIM) .And.;
									SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
									If(aParam[15]==2,!SE1->E1_TIPO$MVRECANT,.T.) .And.;
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7] .And.;
									SE1->E1_SALDO   > 0 .And.;
									IIf(cPaisLoc == "BRA",.T.,!(SE1->E1_TIPO$cCheques)) .And.;
									IIF(aParam[11] == 2, Empty(SE1->E1_NUMLIQ) .And. Empty(SE1->E1_TIPOLIQ),.T.)}
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) )
					If ( !lQuery )
						dbSelectArea("SX5")
						dbSetOrder(1)
						MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
					EndIf
					dbSelectArea(cAlias1)
					dbSetOrder(1)
					cChave := (cQry)->E1_FILORIG+(cQry)->(E1_CLIENTE)+(cQry)->(E1_LOJA) +;
								 (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+;
								 (cQry)->(E1_PARCELA)
					cChave += If((cQry)->(E1_TIPO)	$ MVABATIM, "",;
					              (cQry)->(E1_TIPO))
					If ( !dbSeek(cChave) )
						RecLock(cAlias1,.T.)						
					Else
						RecLock(cAlias1,.F.)
					EndIf
					DbSetOrder(1)
					nTotAbat := 0
					
					//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Inicio 
					nMulta := 0 
					If (cMVJurTipo == "L" .OR. lMvLjIntFS) .AND. lLojxRMul .And. aParam[12] == 2
						nMulta := LojxRMul( , , ,(cQry)->E1_SALDO, (cQry)->E1_ACRESC, (cQry)->E1_VENCREA,  , , (cQry)->E1_MULTA, ,;
		  				 						  (cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA, (cQry)->E1_TIPO, (cQry)->E1_CLIENTE, (cQry)->E1_LOJA,  ) 
					EndIf
					//Calculo de Juros e Multas: SIGALOJA x SIGAFIN - Final
					 
					For nCntFor := 1 To Len(aStru)
						Do Case
						
						#ifdef SPANISH
							Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCSPA" )
								If !( (cQry)->(E1_TIPO)	$ MVABATIM )
									If ( lQuery )
										(cAlias1)->X5_DESCSPA := (cQry)->X5_DESCSPA
									Else
										(cAlias1)->X5_DESCSPA := SX5->X5_DESCSPA
									EndIf
								Endif	
						#else
							#ifdef ENGLISH
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCENG" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias1)->X5_DESCENG := (cQry)->X5_DESCENG
										Else
											(cAlias1)->X5_DESCENG := SX5->X5_DESCENG
										EndIf
									Endif	
							#else
								Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
									If !( (cQry)->(E1_TIPO)	$ MVABATIM )
										If ( lQuery )
											(cAlias1)->X5_DESCRI := (cQry)->X5_DESCRI
										Else
											(cAlias1)->X5_DESCRI := SX5->X5_DESCRI
										EndIf
									Endif	
							#endif
						#endif
							
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VALJUR" )
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ABT" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							Endif
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias1)->E1_ABT += (nTotAbat := xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,(cQry)->(E1_EMISSAO),,nTaxaM))
							Endif
							If ( !lQuery )
								(cAlias1)->E1_ABT := (nTotAbat := SomaAbat(SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,"R",1,,SE1->E1_CLIENTE,SE1->E1_LOJA))
							Endif
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO" )
							If cPaisLoc == "BRA"
								nTaxaM := (cQry)->E1_TXMOEDA
							Else
								nTaxaM:=round((cQry)->E1_VLCRUZ / (cQry)->E1_VALOR,4)  // Pegar a taxa da moeda usada qdo da inclusão do titulo
							Endif	
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2	 // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias1)->E1_SALDO -= nTotAbat
								Endif
							Else
								(cAlias1)->E1_SALDO += xMoeda((cQry)->(E1_SALDO),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.
									(cAlias1)->E1_SALDO += xMoeda((cQry)->(E1_SDACRES) - (cQry)->(E1_SDDECRE),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									(cAlias1)->E1_SALDO += xMoeda(FaJuros((cQry)->E1_VALOR,(cQry)->E1_SALDO,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0),(cQry)->E1_BAIXA,(cQry)->E1_VENCREA,,(cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA,(cQry)->E1_TIPO),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0)) 	//REQ020-Calculo de Juros e Multas: SIGALOJA x SIGAFIN 
									 //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Inicil
									(cAlias1)->E1_SALDO += xMoeda(nMulta,(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
								    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final


									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
									//³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
									//³ provisao de multa no saldo de titulos em atraso.            ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If GetNewPar( "MV_ACATIVO", .F. )									
											(cAlias1)->E1_SALDO += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									Endif
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias1)->E1_SALDO -= nTotAbat
								Endif
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )
							If ( (cQry)->(E1_TIPO)	$ MVABATIM )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias1)->E1_SALDO2 -= nTotAbat
								Endif
							Else
								(cAlias1)->E1_SALDO2 += (cQry)->(E1_SALDO)
									//Calculo de Juros e Multas: SIGALOJA x SIGAFIN   -Inicio
								(cAlias1)->E1_VALJUR := xMoeda(FaJuros((cQry)->E1_VALOR,(cAlias1)->E1_SALDO2,(cQry)->E1_VENCTO,(cQry)->E1_VALJUR,(cQry)->E1_PORCJUR,(cQry)->E1_MOEDA,(cQry)->E1_EMISSAO,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0),(cQry)->E1_BAIXA,(cQry)->E1_VENCREA,,(cQry)->E1_PREFIXO, (cQry)->E1_NUM, (cQry)->E1_PARCELA,(cQry)->E1_TIPO),(cQry)->E1_MOEDA,1,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))										    
								/*BEGINDOC
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄD¿
								//³Se o calculo de juros e multa for do controle de lojas, ³
								//³considera os juros e multas no saldo                    ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄDÙ
								ENDDOC*/
							    If (cMVJurTipo == "L" .OR. lMvLjIntFs)  .AND. lLojxRMul							    
							    	(cAlias1)->E1_MULTA := nMulta 
							    EndIf 
							    //Calculo de Juros e Multas: SIGALOJA x SIGAFIN  - Final							   								
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias1)->E1_SALDO2 += (cAlias1)->E1_SDACRES - (cAlias1)->E1_SDDECRE
									(cAlias1)->E1_SALDO2 += xMoeda((cAlias1)->E1_VALJUR,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM) 
									If (cMVJurTipo == "L" .OR. lMvLjIntFS) .and. lLojxRMul
										(cAlias1)->E1_SALDO2 += xMoeda((cAlias1)->E1_MULTA,1,(cQry)->(E1_MOEDA),dDataBase,,ntaxaM) 
                                    EndIf
									
									//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
									//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
									//³ Quando o modulo Gestao Educacional estiver em uso, inclui a ³
									//³ provisao de multa no saldo de titulos em atraso.            ³
									//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
									If GetNewPar( "MV_ACATIVO", .F. )									
											(cAlias1)->E1_SALDO2 += xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)
									Endif								
								Endif
							EndIf
							If ( !lQuery )
								If aParam[12] == 2   // mv_par12 = 2 : Considera juros e taxa de pernamencia na visualizacao de titulos em aberto.	
									(cAlias1)->E1_SALDO2 -= nTotAbat
								Endif
							EndIf		
						Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								If ( lQuery )
									(cAlias1)->XX_RECNO := (cQry)->SE1RECNO
								Else
									(cAlias1)->XX_RECNO := SE1->(RecNo())
								EndIf
							Endif
						Case ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="XX_LEGEND" )
							If (cQry)->E1_CHQDEV == "1"
								(cAlias1)->XX_LEGEND := 	"BR_AMARELO"
							Else
								If !((cQry)->E1_TIPO $ MVABATIM)
									(cAlias1)->XX_LEGEND := If(ROUND((cQry)->E1_SALDO,2) != ROUND((cQry)->E1_VALOR,2),"BR_AZUL","BR_VERDE")
								EndIf
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="E1_TIPO" )
							If ( Empty((cAlias1)->E1_TIPO) )
								(cAlias1)->E1_TIPO := (cQry)->E1_TIPO
							EndIf
						Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
							//Se o título estiver atrasado, faz o calculo dos dias de atraso
							If dDataBase > (cQry)->E1_VENCREA
								If (((cAlias1)->E1_TIPO) $ MVRECANT+"/"+MV_CRNEG)
									(cAlias1)->E1_ATR := 0
								Else	
									(cAlias1)->E1_ATR := dDataBase - (cAlias1)->E1_VENCREA
								EndIf	
							Else 
	 							If MV_PAR16 == 2 //Se o título NÃO estiver atrasado, então tem ATRASO = 0
		 							(cAlias1)->E1_ATR := 0
	 							Else
		 							(cAlias1)->E1_ATR := dDataBase - DataValida((cAlias1)->E1_VENCREA,.T.)
	 							EndIf
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
						
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
							If !((cQry)->(E1_TIPO)	$ MVABATIM)
								(cAlias1)->E1_VLCRUZ := xMoeda((cQry)->(E1_VALOR),(cQry)->(E1_MOEDA),1,dDataBase,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
							Endif
						Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMULTA" )
							//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
							//³ 11/Ago/2005 Rafael E. Rodrigues                              ³
							//³ Quando o modulo Gestao Educacional estiver em uso eh exibida ³
							//³ a provisao de multa no saldo de titulos em atraso.           ³
							//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								(cAlias1)->E1_VLMULTA := xMoeda(If(Empty((cQry)->(E1_BAIXA)) .and. dDataBase > (cQry)->(E1_VENCREA), (cQry)->(E1_VLMULTA), (cQry)->(E1_MULTA)),(cQry)->(E1_MOEDA),1,dDataBase,,ntaxaM)						
						OtherWise							
							If !( (cQry)->(E1_TIPO)	$ MVABATIM )
								(cAlias1)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
							Endif	
						EndCase
					Next nCntFor
					dbSelectArea(cAlias1)
					If nTotAbat = 0
						If ( (cAlias1)->E1_SALDO <= 0 )
							dbDelete()
						EndIf
					Endif						
					MsUnLock()
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
			If ( lQuery )
				dbSelectArea(cQry)
				dbCloseArea()
			EndIf
			cOrdem := "DTOS(E1_VENCREA)"

			If (ExistBlock("F010ORD1"))    
				//Retornar chave no formato "E1_CLIENTE+E1_LOJA+E1_TIPO+E1_PREFIXO+E1_NUM+E1_PARCELA+SE1RECNO"
				cOrdem := ExecBlock("F010ORD1",.F.,.F.)
			Endif                    

			dbSelectArea(cAlias1)
			IndRegua(cAlias1,cArquivo1,cOrdem)
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totais da Consulta                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aGet1[1] := 0
		aGet1[2] := 0
		aGet1[3] := 0
		aGet1[4] := 0
		aGet1[5] := 0
		aGet1[6] := 0
		aGet1[7] := 0
		aGet1[8] := 0
		aTotRec := {{0,1,0,0}} // Totalizador de titulos a receber por moeda
		dbSelectArea(cAlias1)
		dbGotop()
		While !EOF()		 			 	
		 	aGet1[1]++
		 	If !lRelat
			 	SE1->(DbGoto((cAlias1)->XX_RECNO))	// Posiciona no arquivo original para obter os valores
		 				 										// em outras moedas e em R$
				nAscan := Ascan(aTotRec,{|e| e[MOEDATIT] == E1_MOEDA})
			Endif
			
			//Calcular o abatimento para visualização em tela
		 	If (cAlias1)->E1_ABT > 0
		 		//(cAlias1)->E1_SALDO -= (cAlias1)->E1_ABT		 	
		 		(cAlias1)->E1_SALDO2 := xMoeda((cAlias1)->E1_SALDO,E1_MOEDA,1,dDataBase,,ntaxaM)
		 	Endif		 	
				
			If E1_TIPO $ "RA #"+MV_CRNEG
				aGet1[2] -= E1_VLCRUZ
				aGet1[3] -= E1_SALDO
				aGet1[4] -= E1_VALJUR

				nAcresc := nDecres := 0
				If !lRelat
					nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet1[5] -= nAcresc
					aGet1[6] -= nDecres
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO*(-1),If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)*(-1)})
					Else
						aTotRec[nAscan][QTDETITULOS]--
						aTotRec[nAscan][VALORTIT]		-= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	-= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif	
				If aParam[12] == 1 //Saldo sem correcao
					aGet1[8] -= E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
				Else
					aGet1[8] -= E1_SALDO
				Endif
			Else	
				aGet1[2] += E1_VLCRUZ
				aGet1[3] += E1_SALDO
				aGet1[4] += E1_VALJUR
				aGet1[7] += E1_ABT
				nAcresc := nDecres := 0
				If !lRelat
					nAcresc := xMoeda(E1_SDACRES,E1_MOEDA,1,dDataBase,,ntaxaM)
					nDecres := xMoeda(E1_SDDECRE,E1_MOEDA,1,dDataBase,,ntaxaM)
					aGet1[5] += nAcresc
					aGet1[6] += nDecres
					If nAscan = 0
						Aadd(aTotRec,{1,E1_MOEDA,SE1->E1_SALDO,If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)})
					Else
						aTotRec[nAscan][QTDETITULOS]++
						aTotRec[nAscan][VALORTIT]		+= SE1->E1_SALDO
						aTotRec[nAscan][VALORREAIS]	+= If(E1_MOEDA>1,xMoeda(SE1->E1_SALDO,E1_MOEDA,1,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0)),SE1->E1_SALDO)
					Endif
				Endif
				If aParam[12] == 1 //Saldo sem correcao
					aGet1[8] += E1_SALDO-E1_ABT+E1_VALJUR+nAcresc-nDecres
				Else
					aGet1[8] += E1_SALDO
				Endif
			Endif
			dbSkip()
		Enddo
		If !lRelat
			nTotalRec:=0
			aEval(aTotRec,{|e| nTotalRec+=e[VALORREAIS]})
			Aadd(aTotRec,{"","",STR0096,nTotalRec}) //"Total ====>>"
			// Formata as colunas
			aEval(aTotRec,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
										If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
		Endif										

		aGet1[1] := TransForm(aGet1[1],Tm(aGet1[1],16,0))
		aGet1[2] := TransForm(aGet1[2],Tm(aGet1[2],16,nCasas))
		aGet1[3] := TransForm(aGet1[3],Tm(aGet1[3],16,nCasas))
		aGet1[4] := TransForm(aGet1[4],Tm(aGet1[4],16,nCasas))
		aGet1[5] := TransForm(aGet1[5],Tm(aGet1[5],16,nCasas))
		aGet1[6] := TransForm(aGet1[6],Tm(aGet1[6],16,nCasas))
		aGet1[7] := TransForm(aGet1[7],Tm(aGet1[7],16,nCasas))		
		aGet1[8] := TransForm(aGet1[8],Tm(aGet1[8],16,nCasas))		
				
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Titulos Recebidos                                                       ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case ( nBrowse == 2 )
		dbSelectArea("SX3")
		dbSetOrder(2)
		/* 
		GESTAO - inicio */
		dbSeek("E1_FILORIG")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* GESTAO - fim
		*/
		If aParam[13] == 2  //Considera loja
			dbSeek("E1_LOJA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_TIPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		IF !lRelat
			dbSeek("E1_MOEDA")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_VENCTO")
		If !lRelat
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_DATA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		dbSeek("E5_DTDISPO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		IF !lRelat
			dbSeek("E1_VALOR")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif	
		
		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		
		For nCntFor := 1 To 4
			dbSeek(	If(nCntFor==1,	"E5_VLJUROS",;
						If(nCntFor==2,	"E5_VLMULTA",;
						If(nCntFor==3,	"E5_VLCORRE",;
											"E5_VLDESCO"))))
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Next	
		
		dbSeek("E5_VALOR")
		aadd(aHeader,{STR0047,"E1_PAGO",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,"V" } ) //"Pago"
		aadd(aStru ,{"E1_PAGO",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				
		IF !lRelat
			dbSeek("E1_VALOR")
			aadd(aHeader,{ STR0093,"E1_VLMOED2",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Vlr pago  moeda tit."
			aadd(aStru ,{"E1_VLMOED2",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			
			dbSeek("E5_VLMOED2")
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

			If cPaisLoc == "BRA"
				dbSeek("E5_TXMOEDA")
				aadd(aHeader,{AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
				aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
				aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			Endif
		Endif	

		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E1_NUMLIQ")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E5_BANCO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_AGENCIA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_CONTA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_HISTOR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E5_MOTBX")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		If !lRelat
			dbSeek("E5_CNABOC")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif

		dbSeek("E5_TIPODOC")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})		


		aadd(aHeader,{STR0035,"E1_ATR","9999999999",10,0,"","","N","","V" } ) //"Atraso"
		aadd(aStru ,{"E1_ATR","N",10,0})

		dbSeek("E1_VALJUR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ 11/Ago/2005 Rafael E. Rodrigues                             ³
		//³ Inclui a coluna com informacao de multa paga por paramento  ³
		//³ em atraso.                                                  ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSeek("E1_MULTA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aStru,{"XX_RECNO","N",12,0})
		
		If cPaisLoc == "BRA"
			aadd(aQuery,{"E1_TXMOEDA","N",17,4})
		Endif	

		SX3->(DbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"E1_FILORIG+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)+",E1_ORIGEM,SE5.R_E_C_N_O_ SE5RECNO , SE5.E5_DOCUMEN E5_DOCUMEN "
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SE5")+" SE5 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE1")
					cQuery += "WHERE SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=       "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=       "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=       "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=       "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=       "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=       "SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					If ( aParam[5] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'PR ' AND "
					EndIf					
					If ( aParam[15] == 2 )
						cQuery +=   "SE1.E1_TIPO<>'RA ' AND "
					EndIf					
					cQuery +=       "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery +=       "SE1.E1_PREFIXO<='"+aParam[7]+"' AND "
    
    				//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
					//³ arquivo compartilhado. Titulos Recebidos            ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (ExistBlock("FO10FLTR"))    
						cQuery += ExecBlock("FO10FLTR",.F.,.F.)
					Endif                    

					If cPaisLoc != "BRA"
						cQuery += "SE1.E1_TIPO NOT IN" + FormatIn(cCheques,"|") + " AND "
					Else
						cQuery += "SE1.E1_ORIGEM <> 'FINA087A' AND "
					Endif	
					cQuery +=		"SE1.E1_TIPO NOT LIKE '__-' AND "
					cQuery +=		"SE1.E1_TIPO NOT IN ('RA ','PA ','"+MV_CRNEG+"','"+MV_CPNEG+"') AND "
					cQuery +=		"SE1.D_E_L_E_T_ = ' ' AND "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE5")
					cQuery += "SE5.E5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=		"SE5.E5_NATUREZ=SE1.E1_NATUREZ AND "
					cQuery +=		"SE5.E5_PREFIXO=SE1.E1_PREFIXO AND "
					cQuery +=		"SE5.E5_NUMERO=SE1.E1_NUM AND "
					cQuery +=		"SE5.E5_PARCELA=SE1.E1_PARCELA AND "
					cQuery +=		"SE5.E5_TIPO=SE1.E1_TIPO AND "
					cQuery +=		"SE5.E5_CLIFOR=SE1.E1_CLIENTE AND "
					cQuery +=		"SE5.E5_LOJA=SE1.E1_LOJA AND "
					cQuery +=		"SE5.E5_RECPAG='R' AND "
					cQuery +=		"SE5.E5_SITUACA<>'C' AND "
					If aParam[8] == 2
						//Titulos baixados por geracao de fatura
						cQuery += " SE5.E5_MOTBX <> 'FAT' AND "
					Endif
					If aParam[09] == 2
						//Titulos baixados por liquidacao
						cQuery += " SE5.E5_MOTBX <> 'LIQ' AND "
					Endif
					cQuery +=		"SE5.D_E_L_E_T_ = ' ' AND NOT EXISTS ("
					cQuery += "SELECT A.E5_NUMERO "
					cQuery += "FROM "+RetSqlName("SE5")+" A "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE5")
					cQuery += "WHERE A.E5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=		"A.E5_NATUREZ=SE5.E5_NATUREZ AND "
					cQuery +=		"A.E5_PREFIXO=SE5.E5_PREFIXO AND "
					cQuery +=		"A.E5_NUMERO=SE5.E5_NUMERO AND "
					cQuery +=		"A.E5_PARCELA=SE5.E5_PARCELA AND "
					cQuery +=		"A.E5_TIPO=SE5.E5_TIPO AND "
					cQuery +=		"A.E5_CLIFOR=SE5.E5_CLIFOR AND "
					cQuery +=		"A.E5_LOJA=SE5.E5_LOJA AND "
					cQuery +=		"A.E5_SEQ=SE5.E5_SEQ AND "
					cQuery +=		"A.E5_TIPODOC='ES' AND "
					cQuery +=		"A.E5_RECPAG<>'R' AND "
					cQuery +=		"A.D_E_L_E_T_= ' ')"
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              	    //³ Ponto de entrada para alteracao da cQuery na consulta Titulos Recebidos ³
              	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (ExistBlock("F010CQTR"))    
						cQuery := ExecBlock("F010CQTR",.F.,.F.,{cQuery})
					Endif

					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})

					dbSelectArea(cQry)
					bWhile := {|| !Eof() }
					bFiltro:= {|| (	(cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" .AND.;
									IIf( UPPER(SUBSTR((cQry)->E5_HISTOR,1,4)) <> "LOJ-", .T.,;
									( ( (cQry)->E1_NUM == cNumAnt .AND. (cQry)->E5_TIPODOC == cTpDocAnt ) .OR.;
									  ( (cQry)->E1_NUM == cNumAnt .AND. (cQry)->E1_PARCELA <> cParcAnt  ) .OR.;
									  (cQry)->E1_NUM <> cNumAnt ) ) ) }
					cAnterior := ""
					While ( Eval(bWhile) )				
						If ( Eval(bFiltro) )
							cNumAnt := (cQry)->E1_NUM
							cTpDocAnt := (cQry)->E5_TIPODOC
							cParcAnt := (cQry)->E1_PARCELA
							dbSelectArea(cAlias)
							dbSetOrder(1)
							RecLock(cAlias,.T.)
							For nCntFor := 1 To Len(aStru)
								Do Case
									Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_PAGO += (cQry)->E5_VALOR
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMOED2" ) .And. !lRelat
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" ) .And. (cQry)->E1_MOEDA > 1
											(cAlias)->E1_VLMOED2 := If((cQry)->E1_MOEDA > 1, (cQry)->E5_VLMOED2, (cQry)->E5_VALOR)
										EndIf	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_SALDO2" )
										If ( (cQry)->(E1_TIPO)	$ MVABATIM )
											(cAlias)->E1_SALDO2 -= nTotAbat
										Else
											(cAlias)->E1_SALDO2 += (cQry)->(E1_SALDO)
											(cAlias)->E1_SALDO2 += (cAlias)->E1_SDACRES - (cAlias)->E1_SDDECRE
										EndIf
										If ( !lQuery )
											(cAlias)->E1_SALDO2 -= nTotAbat
										EndIf	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
										If ( (cQry)->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											If cAnterior != (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
												(cAlias)->E1_VLCRUZ := (cQry)->E1_VLCRUZ
												cAnterior := (cQry)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
											Endif
										EndIf										
									Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
										If (cQry)->E5_DATA > DataValida((cQry)->E1_VENCREA,.T.)
											(cAlias)->E1_ATR := (cQry)->E5_DATA - (cQry)->E1_VENCREA
										Else
											(cAlias)->E1_ATR := (cQry)->E5_DATA - DataValida((cQry)->E1_VENCREA,.T.)
										Endif
									Case cPaisLoc=="BRA" .And. ( AllTrim(aStru[nCntFor][1])=="E5_TXMOEDA" )  .And. !lRelat
										If (cQry)->E1_MOEDA == 1
											(cAlias)->E5_TXMOEDA := 1
		                  				Else
											If (cQry)->E5_TXMOEDA == 0 
												(cAlias)->E5_TXMOEDA := ((cQry)->E5_VALOR /(cQry)->E5_VLMOED2)
											Else
												(cAlias)->E5_TXMOEDA := (cQry)->E5_TXMOEDA
											Endif
										Endif
									Case ( !lRelat .And. AllTrim(aStru[nCntFor][1])=="E1_NUMLIQ" )
										If (cQry)->E5_MOTBX == "LIQ"
											If Empty( (cQry)->E1_NUMLIQ )
												(cAlias)->E1_NUMLIQ := SUBSTR((cQry)->E5_DOCUMEN,1,TamSx3("E1_NUMLIQ")[1])
											Else
												(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))			
											Endif		
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
										(cAlias)->XX_RECNO := (cQry)->SE5RECNO

									Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
			
									OtherWise
										(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
								EndCase
							Next nCntFor
							(cAlias)->(MsUnLock())
						EndIf
						dbSelectArea(cQry)
						dbSkip()				
					EndDo
					dbSelectArea(cQry)
					dbCloseArea()
				Else
			#ENDIF
				dbSelectArea("SE1")
				dbSetOrder(2)
				If aParam[13] == 1  //Considera loja
					dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
										SA1->A1_COD    == SE1->E1_CLIENTE .And.;
										SA1->A1_LOJA   == SE1->E1_LOJA }
				Else
					dbSeek(xFilial("SE1")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
						SA1->A1_COD    == SE1->E1_CLIENTE }
				Endif
									
				bFiltro:= {|| 	SubStr(SE1->E1_TIPO,3,1)!="-" .And.;
									SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									If(aParam[5]==2,SE1->E1_TIPO!="PR ",.T.) .And.;
									If(aParam[15]==2,!SE1->E1_TIPO$MVRECANT,.T.) .And.;									
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7] .And.;
									IIf(cPaisLoc == "BRA",(SE1->E1_ORIGEM<>"FINA087A"),!(SE1->E1_TIPO$cCheques)) }
									
				While ( Eval(bWhile) )
					If ( Eval(bFiltro) )
						dbSelectArea("SE5")
						dbSetOrder(7)
						dbSeek(xFilial("SE5")+SE1->E1_PREFIXO+SE1->E1_NUM+SE1->E1_PARCELA+SE1->E1_TIPO+SE1->E1_CLIENTE+SE1->E1_LOJA)

						While ( !Eof() .And. xFilial("SE5") == SE5->E5_FILIAL .And.;
								SE1->E1_PREFIXO == SE5->E5_PREFIXO .And.;
								SE1->E1_NUM == SE5->E5_NUMERO      .And.;
								SE1->E1_PARCELA == SE5->E5_PARCELA .And.;
								SE1->E1_TIPO == SE5->E5_TIPO       .And.;
								SE1->E1_CLIENTE == SE5->E5_CLIFOR	.And.;
								SE1->E1_LOJA == SE5->E5_LOJA )
							
							// Baixas efetuadas por liquidacao ou por fatura, se nao devem ser consideradas despreza
							If (aParam[08] == 2 .And. SE5->E5_MOTBX == "FAT") .Or.;
								(aParam[09] == 2 .And. SE5->E5_MOTBX == "LIQ")
								dbSelectArea("SE5")
								dbSkip()	
								Loop
							Endif
							
							If ((!SE5->E5_TIPO $ "RA /PA /"+MV_CRNEG+"/"+MV_CPNEG) .And. !TemBxCanc() .and. ;
										SE5->E5_SITUACA <> "C" .And. SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$")
								RecLock(cAlias,.T.)
								For nCntFor := 1 To Len(aStru)
									Do Case
									Case ( AllTrim(aStru[nCntFor][1])=="E1_PAGO" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											(cAlias)->E1_PAGO += SE5->E5_VALOR
										EndIf
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLMOED2" ) .And. !lRelat
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" ) .And. SE1->E1_MOEDA > 1
											(cAlias)->E1_VLMOED2 := If(SE1->E1_MOEDA > 1, SE5->E5_VLMOED2, SE5->E5_VALOR)
										EndIf		
									Case ( AllTrim(aStru[nCntFor][1])=="E1_VLCRUZ" )
										If ( SE5->E5_TIPODOC $ "VL/BA/V2/CP/LJ/R$" )
											If cAnterior != SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
												(cAlias)->E1_VLCRUZ := SE1->E1_VLCRUZ
												cAnterior := SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
											Endif
										Endif	
									Case ( AllTrim(aStru[nCntFor][1])=="E1_ATR" )
										If SE5->E5_DATA > DataValida(SE1->E1_VENCREA,.T.)
											(cAlias)->E1_ATR := SE5->E5_DATA - SE1->E1_VENCREA
										Else
											(cAlias)->E1_ATR := SE5->E5_DATA - DataValida(SE1->E1_VENCREA,.T.)
										Endif
									Case cPaisLoc=="BRA" .And. ( AllTrim(aStru[nCntFor][1])=="E5_TXMOEDA" ) .And. !lRelat
		                     			If SE1->E1_MOEDA == 1
        		             				(cAlias)->E5_TXMOEDA := 1
            							Else
											If SE5->E5_TXMOEDA == 0 
												(cAlias)->E5_TXMOEDA := (SE5->E5_VALOR /SE5->E5_VLMOED2)
											Else
												(cAlias)->E5_TXMOEDA := SE5->E5_TXMOEDA
											Endif
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="E1_NUMLIQ" )
										If SE5->E5_MOTBX == "LIQ"
											If Empty(SE1->E1_NUMLIQ)
												(cAlias)->E1_NUMLIQ := SUBSTR(SE5->E5_DOCUMEN,1,TamSx3("E1_NUMLIQ")[1])
											Else
												(cAlias)->(FieldPut(nCntFor,SE1->(FieldGet(FieldPos(aStru[nCntFor][1])))))
											Endif
										Endif
									Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
										(cAlias)->XX_RECNO := SE5->(RecNo())
									Case ( "E5_"$AllTrim(aStru[nCntFor][1]) )
										(cAlias)->(FieldPut(nCntFor,SE5->(FieldGet(FieldPos(aStru[nCntFor][1])))))
									Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
									OtherWise
										(cAlias)->(FieldPut(nCntFor,SE1->(FieldGet(FieldPos(aStru[nCntFor][1])))))
									EndCase
								Next nCntFor
								(cAlias)->(MsUnLock())
							EndIf
							dbSelectArea("SE5")
							dbSkip()
						EndDo										
					EndIf
					dbSelectArea("SE1")
					dbSkip()					
				EndDo
				#IFDEF TOP
				EndIf					
				#ENDIF
			dbSelectArea(cAlias)
			IndRegua(cAlias,cArquivo,"DTOS(E1_VENCREA)")
		EndIf
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totais da Consulta                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aTotPag := {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
		dbSelectArea(cAlias)
		dbGotop()
		FC010TotRc(aGet,cAlias,aTotPag)  // Totais de Baixas
		If !lRelat
			nTotalRec:=0
			aEval(aTotPag,{|e| nTotalRec+=e[VALORREAIS]})
			Aadd(aTotPag,{"","",STR0094,nTotalRec}) //"Total ====>>"
			// Formata as colunas
			aEval(aTotPag,{|e|	If(ValType(e[VALORTIT]) == "N"	, e[VALORTIT]		:= Transform(e[VALORTIT],Tm(e[VALORTIT],16,nCasas)),Nil),;
										If(ValType(e[VALORREAIS]) == "N"	, e[VALORREAIS]	:= Transform(e[VALORREAIS],Tm(e[VALORREAIS],16,nCasas)),Nil)})
		Endif
		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Pedidos                                                                 ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case ( nBrowse == 3 )
		dbSelectArea("SX3")
		dbSetOrder(2)                                   	
		If aParam[13] == 1  //Considera loja
			dbSeek("C5_LOJACLI")
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
			aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Endif
		/*
		GESTAO - inicio */
		dbSeek("C5_FILIAL")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* GESTAO - fim
		*/
		dbSeek("C5_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("C5_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("C6_VALOR")
		aadd(aHeader,{STR0040,"XX_SLDTOT",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Tot.Pedido"
		aadd(aStru ,{"XX_SLDTOT",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0041,"XX_SLDLIB",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Sld.Liberado"
		aadd(aStru ,{"XX_SLDLIB",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0042,"XX_SLDPED",SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } ) //"Sld.Pedido"
		aadd(aStru ,{"XX_SLDPED",SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aStru,{"XX_RECNO","N",12,0})
		
		IF lFC010Pedi
	   		aRetAux := aClone(ExecBlock("FC010PEDI",.F.,.F.,{aClone(aHeader),aClone(aStru)}))
			If ValType(aRetAux) <> "A" .or. Len(aRetAux) <> 2
				aRetAux := {{},{}}
			Else
				aEval(aRetAux[1] , {|x| aAdd(aHeader , x ) })
				aEval(aRetAux[2] , {|x| aAdd(aStru , x ) })
			EndIf
		EndIf

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"C5_FILIAL+C5_NUM")

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					cCompSC5 := FWModeAccess("SC5",1) + FWModeAccess("SC5",2) + FWModeAccess("SC5",3)
					lQuery := .T.
					cQuery := "SELECT SC5.C5_FILIAL,SC5.C5_NUM PEDIDO,"
					cQuery += 		  "SC5.C5_EMISSAO EMISSAO," 
					//*************************************
					// Monta campos do ponro de entrada   * 
					// FC010PEDI na tabela temporaria.    *
					//*************************************
					IF lFC010Pedi
						aEval(aRetAux[2] , {|x| cQuery += x[1] + "," })
					EndIf
					cQuery +=  		  "SC5.C5_MOEDA MOEDA,"    
					cQuery +=  		  "SC5.C5_FRETE FRETE,"
					cQuery += 		  "SC5.R_E_C_N_O_ SC5RECNO,"
					cQuery += 		  "(C6_QTDVEN-C6_QTDEMP-C6_QTDENT) QTDVEN,"
					cQuery +=		  "C6_PRCVEN PRCVEN,"
					cQuery +=         "1 TIPO,"
					cQuery +=         "C5_EMISSAO DATALIB," //NAO RETIRAR - POSTGRES
					cQuery +=         "C6_BLQ BLCRED "		//NAO RETIRAR - POSTGRES
					cQuery += "FROM "+RetSqlName("SC5")+" SC5,"
					cQuery +=         RetSqlName("SC6")+" SC6,"
					cQuery +=         RetSqlName("SF4")+" SF4 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SC5")
					cQuery += "WHERE SC5.C5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery += 		"SC5.C5_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=		"SC5.C5_LOJACLI='"+SA1->A1_LOJA+"' AND "
					Endif

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
					//³ arquivo compartilhado.  Pedidos                     ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (ExistBlock("F010FLPD"))    
						cQuery += ExecBlock("F010FLPD",.F.,.F.)
					Endif                    

					cQuery +=		"SC5.C5_TIPO NOT IN('D','B') AND "
					cQuery +=		"SC5.C5_EMISSAO >='"+Dtos(aParam[1])+"' AND "
					cQuery +=		"SC5.C5_EMISSAO <='"+Dtos(aParam[2])+"' AND "	
					cQuery +=		"SC5.D_E_L_E_T_ = ' ' AND "
					/*
					GESTAO - inicio */
					If (FWModeAccess("SC6",1) + FWModeAccess("SC6",2) + FWModeAccess("SC6",3)) == cCompSC5
						cQuery += "SC6.C6_FILIAL = SC5.C5_FILIAL AND "
					Else
						nPosAlias := FC010QFil(1,"SC6")
						cQuery += "SC6.C6_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					Endif
					/* GESTAO - fim
					*/
					cQuery +=		"SC6.C6_NUM=SC5.C5_NUM AND "
					cQuery +=		"SC6.C6_BLQ NOT IN('R ') AND "
					If aParam[10] == 2 // nao considera pedidos com bloqueio
						cQuery +=		"SC6.C6_BLQ NOT IN('S ') AND "
					Endif
					cQuery +=		"(SC6.C6_QTDVEN-SC6.C6_QTDEMP-SC6.C6_QTDENT)>0 AND "
					cQuery +=		"SC6.D_E_L_E_T_ = ' ' AND "
					cQuery +=		"SF4.F4_FILIAL='"+xFilial("SF4")+"' AND "
					cQuery +=		"SF4.F4_CODIGO=SC6.C6_TES AND "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Considera sim, não ou ambos os itens com TES gerando duplicata ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If aParam[14] == 2
						cQuery +=		"SF4.F4_DUPLIC='S' AND "
					ElseIf aParam[14] == 3                   
						cQuery +=		"SF4.F4_DUPLIC='N' AND "
					Endif
					cQuery +=		"SF4.D_E_L_E_T_ = ' ' "
					cQuery += "UNION ALL "
					cQuery += "SELECT C5_FILIAL,C5_NUM PEDIDO,"
					cQuery += 		  "C5_EMISSAO EMISSAO,"
					//*************************************
					// Monta campos do ponro de entrada   * 
					// FC010PEDI na tabela temporaria.    *
					//*************************************
					IF lFC010Pedi
						aEval(aRetAux[2] , {|x| cQuery += x[1] + "," })
					EndIf
					cQuery += 		  "C5_MOEDA MOEDA,"
					cQuery +=  		  "C5_FRETE FRETE,"
					cQuery += 		  "SC5.R_E_C_N_O_ SC5RECNO,"					
					cQuery += 		  "C9_QTDLIB QTDVEN,"
					cQuery +=		  "C9_PRCVEN PRCVEN, "
					cQuery +=         "2 TIPO,"										
					cQuery +=		  "C9_DATALIB DATALIB, "
					cQuery +=		  "C9_BLCRED BLCRED "
					cQuery += "FROM "+RetSqlName("SC5")+" SC5,"+RetSqlName("SC6")+" SC6,"
					cQuery +=         RetSqlName("SF4")+" SF4,"+RetSqlName("SC9")+" SC9 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SC5")
					cQuery += "WHERE SC5.C5_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery += 		"SC5.C5_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=		"SC5.C5_LOJACLI='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=		"SC5.C5_TIPO NOT IN('D','B') AND "
					cQuery +=		"SC5.C5_EMISSAO >='"+Dtos(aParam[1])+"' AND "
					cQuery +=		"SC5.C5_EMISSAO <='"+Dtos(aParam[2])+"' AND "						
					cQuery +=		"SC5.D_E_L_E_T_ =  ' ' AND "
					/*
					GESTAO - inicio */
					If (FWModeAccess("SC6",1) + FWModeAccess("SC6",2) + FWModeAccess("SC6",3)) == cCompSC5
						cQuery += "SC6.C6_FILIAL = SC5.C5_FILIAL AND "
					Else
						nPosAlias := FC010QFil(1,"SC6")
						cQuery += "SC6.C6_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					Endif
					/* GESTAO - fim
					*/
					cQuery +=		"SC6.C6_NUM=SC5.C5_NUM AND "
					cQuery +=		"SC6.D_E_L_E_T_ = ' ' AND "
					cQuery +=		"SC6.C6_BLQ NOT IN('R ') AND "
					If aParam[10] == 2 // nao considera pedidos com bloqueio
						cQuery +=		"SC6.C6_BLQ NOT IN('S ') AND "
					Endif
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SF4")
					cQuery += "SF4.F4_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=		"SF4.F4_CODIGO=SC6.C6_TES AND "
					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Considera sim, não ou ambos os itens com TES gerando duplicata ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If aParam[14] == 2
						cQuery +=		"SF4.F4_DUPLIC='S' AND "
					ElseIf aParam[14] == 3                   
						cQuery +=		"SF4.F4_DUPLIC='N' AND "
					Endif
					cQuery +=		"SF4.D_E_L_E_T_ = ' ' AND "
					/*
					GESTAO - inicio */
					If (FWModeAccess("SC9",1) + FWModeAccess("SC9",2) + FWModeAccess("SC9",3)) == cCompSC5
						cQuery += "SC9.C9_FILIAL = SC5.C5_FILIAL AND "
					Else
						nPosAlias := FC010QFil(1,"SC9")
						cQuery += "SC9.C9_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					Endif
					/* GESTAO - fim
					*/
					cQuery +=		"SC9.C9_PEDIDO=SC5.C5_NUM AND "
					cQuery +=		"SC9.C9_ITEM=SC6.C6_ITEM AND "
					cQuery +=		"SC9.C9_PRODUTO=SC6.C6_PRODUTO AND "		
					cQuery +=		"SC9.C9_NFISCAL='"+Space(Len(SC9->C9_NFISCAL))+"' AND "
					cQuery +=		"SC9.D_E_L_E_T_ = ' '"
                    
                    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              	    //³ Ponto de entrada para alteracao da cQuery na consulta de Pedidos ³
              	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (ExistBlock("F010CQPE"))    
						cQuery := ExecBlock("F010CQPE",.F.,.F.,{cQuery})
					Endif 

					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					TcSetField(cQry,"EMISSAO","D")
					TcSetField(cQry,"DATALIB","D")
					TcSetField(cQry,"TIPO","N",1)
					TcSetField(cQry,"SC5RECNO","N",12,0) 
					TcSetField(cQry,"QTDVEN","N",TamSx3("C6_QTDVEN")[1],TamSx3("C6_QTDVEN")[2])
					TcSetField(cQry,"PRCVEN","N",TamSx3("C6_PRCVEN")[1],TamSx3("C9_PRCVEN")[2]) 
					
					//*************************************
					// Monta campos do ponro de entrada   * 
					// FC010PEDI na tabela temporaria.    *
					//*************************************
					IF lFC010Pedi
						aEval(aRetAux[2] , {|x| TcSetField(cQry,x[1],x[2],x[3],x[4]) })
					EndIf
										
					dbSelectArea(cQry)
					bWhile := {|| !Eof() }
					bFiltro:= {|| .T. }
					While ( Eval(bWhile) )				
						If ( Eval(bFiltro) )
							dbSelectArea(cAlias)
							dbSetOrder(1)
							cChave := (cQry)->(C5_FILIAL + PEDIDO)
							If ( !dbSeek(cChave) )
								RecLock(cAlias,.T.)
							Else
								RecLock(cAlias,.F.)
							EndIf
							If ( (cQry)->TIPO == 1 )
								(cAlias)->C5_FILIAL  := (cQry)->C5_FILIAL
								(cAlias)->C5_NUM     := (cQry)->PEDIDO
								(cAlias)->C5_EMISSAO := (cQry)->EMISSAO
								(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->EMISSAO)
								IF EMPTY(cSaldo) .or. cSaldo <> cChave
									(cAlias)->XX_SLDTOT  += xMoeda((cQry)->FRETE,(cQry)->MOEDA,1,(cQry)->EMISSAO)	// Adiciona frete ao total
								ENDIF	
								(cAlias)->XX_SLDLIB  := 0
								(cAlias)->XX_SLDPED  := (cAlias)->XX_SLDTOT
							Else
								(cAlias)->C5_FILIAL  := (cQry)->C5_FILIAL
								(cAlias)->C5_NUM     := (cQry)->PEDIDO
								(cAlias)->C5_EMISSAO := (cQry)->EMISSAO						
								If ( Empty((cQry)->BLCRED) )
									(cAlias)->XX_SLDLIB  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
									IF EMPTY(cSaldo) .or. cSaldo <> cChave
										(cAlias)->XX_SLDLIB  += xMoeda((cQry)->FRETE,(cQry)->MOEDA,1,(cQry)->EMISSAO)  // Adiciona frete ao total
									ENDIF
									(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
									IF EMPTY(cSaldo) .or. cSaldo <> cChave
										(cAlias)->XX_SLDTOT  += xMoeda((cQry)->FRETE,(cQry)->MOEDA,1,(cQry)->EMISSAO)  // Adiciona frete ao total
									ENDIF
								Else
									(cAlias)->XX_SLDTOT  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)
									IF EMPTY(cSaldo) .or. cSaldo <> cChave
										(cAlias)->XX_SLDTOT  += xMoeda((cQry)->FRETE,(cQry)->MOEDA,1,(cQry)->EMISSAO)  // Adiciona frete ao total
									ENDIF	
									(cAlias)->XX_SLDPED  += xMoeda((cQry)->QTDVEN*(cQry)->PRCVEN,(cQry)->MOEDA,1,(cQry)->DATALIB)           
									IF Empty (cSaldo) .or. cSaldo <> cChave          
										(cAlias)->XX_SLDPED  += xMoeda((cQry)->FRETE,(cQry)->MOEDA,1,(cQry)->EMISSAO)  // Adiciona frete ao total
									EndIf
								EndIf
							EndIf
							(cAlias)->XX_RECNO := (cQry)->SC5RECNO
							//*************************************
							// Monta campos do ponro de entrada   * 
							// FC010PEDI na tabela temporaria.    *
							//*************************************
							IF lFC010Pedi
								aEval(aRetAux[2] , {|x| (cAlias)->&(x[1]) := (cQry)->&(x[1])  })
							EndIf
							(cAlias)->(MsUnLock())
							cSaldo := cChave
						EndIf
						dbSelectArea(cQry)
						dbSkip()				
					EndDo
					dbSelectArea(cQry)
					dbCloseArea()			
				Else
			#ENDIF
				dbSelectArea("SC5")
				dbSetOrder(3)
				dbSeek(xFilial("SC5")+SA1->A1_COD)
				While ( !Eof() .And. SC5->C5_FILIAL==xFilial("SC5") .And.;
						SC5->C5_CLIENTE == SA1->A1_COD )
					nSalPed := 0
					nSalPedb:= 0
					nSalPedL:= 0
					nQtdPed := 0											
					If ( If(aParam[13] == 1,SC5->C5_LOJACLI == SA1->A1_LOJA,.T.) .And. !(SC5->C5_TIPO $ "DB") .And. SC5->C5_EMISSAO >= aParam[1] .And. C5_EMISSAO <= aParam[2] )
						dbSelectArea("SC6")
						dbSetOrder(1)
						dbSeek(xFilial("SC6")+SC5->C5_NUM)
						While ( !Eof() .And. SC6->C6_FILIAL == xFilial('SC5') .And.;
								SC6->C6_NUM == SC5->C5_NUM )
							If ( !AllTrim(SC6->C6_BLQ) $ "R"+If(aParam[10]==2,"#S",""))
								dbSelectArea("SF4")
								dbSetOrder(1)
								dbSeek(cFilial+SC6->C6_TES)
								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Buscar Qtde no arquivo SC9 (itens liberados) p/ A1_SALPEDL³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								dbSelectArea("SC9")
								dbSetOrder(2)
								dbSeek(xFilial("SC9")+SC6->C6_CLI+SC6->C6_LOJA+SC6->C6_NUM+SC6->C6_ITEM)

								//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
								//³ Considera sim, não ou ambos os itens com TES gerando duplicata ³
								//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
								If aParam[14] == 2
									bCond := { || SF4->F4_DUPLIC == "S" }
								ElseIf aParam[14] == 3
									bCond := { || SF4->F4_DUPLIC == "N" }
								Else
									bCond := { || .T.}
								Endif
									
								If Eval(bCond)
									While ( !Eof() .And. xFilial("SC9") == SC9->C9_FILIAL .And.;
											SC6->C6_CLI == SC9->C9_CLIENTE .And.;
											SC6->C6_LOJA == SC9->C9_LOJA .And.;
											SC6->C6_NUM == SC9->C9_PEDIDO .And.;
											SC6->C6_ITEM == SC9->C9_ITEM )
										If ( Empty(C9_NFISCAL) .And. SC6->C6_PRODUTO==SC9->C9_PRODUTO )
											If ( Empty(SC9->C9_BLCRED) )
												nSalpedl += xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
												nSalpedl += xMoeda( SC5->C5_FRETE , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
											Else
												nSalpedb += xMoeda( SC9->C9_QTDLIB * SC9->C9_PRCVEN , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
												nSalpedb += xMoeda( SC5->C5_FRETE , SC5->C5_MOEDA , 1 , SC9->C9_DATALIB )
											EndIf
										EndIf
										dbSelectArea("SC9")
										dbSkip()
									EndDo
								Endif
								If Eval(bCond)
									nQtdPed := SC6->C6_QTDVEN - SC6->C6_QTDEMP - SC6->C6_QTDENT
									nQtdPed := IIf( nQtdPed < 0 , 0 , nQtdPed )
									nSalped += xMoeda( nQtdPed * SC6->C6_PRCVEN , SC5->C5_MOEDA , 1 , SC5->C5_EMISSAO )
									nSalped += xMoeda( SC5->C5_FRETE , SC5->C5_MOEDA , 1 , SC5->C5_EMISSAO )
								EndIf
							EndIf
							dbSelectArea("SC6")
							dbSkip()
						EndDo
					EndIf
					If ( nSalped+nSalpedl+nSalpedb > 0 )
						RecLock(cAlias,.T.)
						(cAlias)->C5_NUM     := SC5->C5_NUM
						(cAlias)->C5_EMISSAO := SC5->C5_EMISSAO
						(cAlias)->XX_SLDTOT  := nSalPed+nSalPedL+nSalPedb
						(cAlias)->XX_SLDLIB  := nSalPedL
						(cAlias)->XX_SLDPED  := nSalPed+nSalPedb
						(cAlias)->XX_RECNO    := SC5->(RecNo())
						MsUnlock()
					EndIf
					dbSelectArea("SC5")
					dbSkip()
				EndDo
				#IFDEF TOP
				EndIf
				#ENDIF
		EndIf
		dbSelectArea(cAlias)
		dbGotop()
		aGet[1] := 0
		aGet[2] := 0
		aGet[3] := 0
		aGet[4] := 0
		dbEval({|| 	aGet[1]++,;
			aGet[2]+=XX_SLDTOT,;
			aGet[3]+=XX_SLDLIB,;
			aGet[4]+=XX_SLDPED})

		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))
		aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,nCasas))
		aGet[4] := TransForm(aGet[4],Tm(aGet[3],16,nCasas))	
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Notas Fiscais                                                           ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Case ( nBrowse == 4 )
		aCpos:={"F2_FILIAL","F2_SERIE","F2_DOC","F2_EMISSAO","F2_DUPL","F2_VALFAT","F2_FRETE",;
			    "F2_HORA","F2_TRANSP","A4_NREDUZ"}
		If cPaisLoc != "BRA"
			AAdd(aCpos,"F2_MOEDA") 
			AAdd(aCpos,"F2_TXMOEDA")
		EndIf
					
		If lFC0101FAT
			aAuxCpo := aClone(ExecBlock("FC0101FAT",.F.,.F.,{aCpos}))
			If ValType(aAuxCpo) == "A"
				aCpos := aClone(aAuxCpo)			
			EndIf
		EndIf
					
		dbSelectArea("SX3")
		dbSetOrder(2)
		For nI := 1 To Len(aCpos)
			dbSeek(aCpos[nI])
			aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
			aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		Next nI

		aadd(aStru,{"XX_RECNO","N",12,0})

		SX3->(dbSetOrder(1))

		If ( Select(cAlias) ==	0 )
			cArquivo := CriaTrab(,.F.)			
			aadd(aAlias,{ cAlias , cArquivo })
			aadd(aStru,{"FLAG","L",01,0})
			dbCreate(cArquivo,aStru)
			dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
			IndRegua(cAlias,cArquivo,"F2_FILIAL+DTOS(F2_EMISSAO)+F2_SERIE+F2_DOC")

			#IFDEF TOP
				cDbMs	 := UPPER(TcGetDb())
				If ( TcSrvType()!="AS/400" .and. cDbMs!="POSTGRES")
					lQuery := .T.

					cQuery := "SELECT SF2.F2_FILIAL,SF2.F2_DOC F2_DOC,"
					cQuery += 		"  SF2.F2_SERIE F2_SERIE,"
					cQuery += 		"  SF2.F2_EMISSAO F2_EMISSAO,"
					cQuery +=		"  SF2.F2_DUPL F2_DUPL,"
					cQuery += 		"  SF2.F2_VALFAT F2_VALFAT, "
					cQuery += 		"  SF2.F2_FRETE F2_FRETE, "
					cQuery += 		"  SF2.F2_HORA F2_HORA, "
					cQuery += 		"  SF2.F2_TRANSP F2_TRANSP, "
  					If cPaisLoc <> "BRA"                        
						cQuery +=	"  SF2.F2_MOEDA F2_MOEDA, "
						cQuery +=	"  SF2.F2_TXMOEDA F2_TXMOEDA, "
					EndIf
					/*
					GESTAO - inicio */
					cQuery += 		"  SF2.R_E_C_N_O_ SF2RECNO "
					/* GESTAO - fim
					*/
					If lFC0102FAT
						cQuery += ", " + ExecBlock("FC0102FAT",.F.,.F.) + " "					
					EndIf

					cQuery += "FROM "+RetSqlName("SF2")+" SF2 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SF2")
					cQuery += " WHERE SF2.F2_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery += 		" SF2.F2_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=		" SF2.F2_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=		" SF2.F2_TIPO NOT IN('D','B') AND "
					cQuery +=		" SF2.F2_EMISSAO>='"+DTOS(aParam[1])+"' AND "
					cQuery +=		" SF2.F2_EMISSAO<='"+DTOS(aParam[2])+"' AND "
					cQuery +=		" SF2.F2_VALFAT> 0 AND "					

					//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
					//³ Ponto de entrada para filtrar pelo MSFIL em caso de ³
					//³ arquivo compartilhado.                              ³
					//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

					If (ExistBlock("FO10FLFT"))    
						cQuery += ExecBlock("FO10FLFT",.F.,.F.)
					Endif                    
					
					If aParam[14] == 3 // TES Duplic = N
						cQuery +=		" SF2.F2_VALFAT = 0 AND "					
					ElseIf aParam[14] == 2  // TES Duplic = S
						cQuery +=		" SF2.F2_VALFAT > 0 AND "					
					Endif												
															
					cQuery += " SF2.D_E_L_E_T_ = ' '"
					/*
					GESTAO
					 */
  				    //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
              	    //³ Ponto de entrada para alteracao da cQuery na consulta Faturamento ³
              	    //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
					If (ExistBlock("F010CQFT"))
						cQuery := ExecBlock("F010CQFT",.F.,.F.,{cQuery})
					Endif
					
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"

					dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)

					TcSetField(cQry,"F2_EMISSAO","D")
					TcSetField(cQry,"F2_VALFAT","N",TamSx3("F2_VALFAT")[1],TamSx3("F2_VALFAT")[2])
					TcSetField(cQry,"F2_FRETE","N",TamSx3("F2_FRETE")[1],TamSx3("F2_FRETE")[2])
					TcSetField(cQry,"SF2RECNO","N",12,0)
					If cPaisLoc <> "BRA"
						TcSetField(cQry,"F2_MOEDA","N",TamSx3("F2_MOEDA")[1],TamSx3("F2_MOEDA")[2])
						TcSetField(cQry,"F2_TXMOEDA","N",TamSx3("F2_TXMOEDA")[1],TamSx3("F2_TXMOEDA")[2])
					EndIf                                                                                
				Else
			#ENDIF
				cQry := "SF2"

				#IFDEF TOP
				EndIf
				#ENDIF
			aGet[1] := 0
			aGet[2] := 0
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
				If aParam[13] == 1  //Considera loja
					dbSeek(xFilial("SF2")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SF2") == SF2->F2_FILIAL .And.;
						SA1->A1_COD == SF2->F2_CLIENTE .And.;
						SA1->A1_LOJA == SF2->F2_LOJA }
				Else                                
					dbSeek(xFilial("SF2")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SF2") == SF2->F2_FILIAL .And.;
						SA1->A1_COD == SF2->F2_CLIENTE}
				Endif
				If aParam[14] == 3 // TES Duplic = N
					bFiltro:= {|| !SF2->F2_TIPO$"DB" .And.;
					SF2->F2_EMISSAO >= aParam[1]     .And.;
					SF2->F2_EMISSAO <= aParam[2]	 .And.;
					SF2->F2_VALFAT  =  0}
				ElseIf aParam[14] == 2  // TES Duplic = S
					bFiltro:= {|| !SF2->F2_TIPO$"DB" .And.;
					SF2->F2_EMISSAO >= aParam[1] .And.;
					SF2->F2_EMISSAO <= aParam[2] .And.;
					SF2->F2_VALFAT  >  0}
				Else // TES Duplic = Todas
					bFiltro:= {|| !SF2->F2_TIPO$"DB" .And.;
					SF2->F2_EMISSAO >= aParam[1] .And.;
					SF2->F2_EMISSAO <= aParam[2]}				
				Endif											
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) )
					If !lQuery
						SA4->(MsSeek(xFilial("SA4")+SF2->F2_TRANSP))
					Else		/* GESTAO */
						SA4->(MsSeek(xFilial("SA4",(cQry)->F2_FILIAL) + (cQry)->F2_TRANSP))
					Endif
					RecLock(cAlias,.T.)
					(cAlias)->F2_FILIAL  := (cQry)->F2_FILIAL
					(cAlias)->F2_SERIE   := (cQry)->F2_SERIE
					(cAlias)->F2_DOC     := (cQry)->F2_DOC
					(cAlias)->F2_EMISSAO := (cQry)->F2_EMISSAO
					(cAlias)->F2_DUPL    := (cQry)->F2_DUPL
					(cAlias)->F2_VALFAT  := (cQry)->F2_VALFAT
					(cAlias)->F2_FRETE   := (cQry)->F2_FRETE
					(cAlias)->F2_HORA    := (cQry)->F2_HORA
					(cAlias)->F2_TRANSP  := (cQry)->F2_TRANSP
					If cPaisLoc != "BRA"                      
						(cAlias)->F2_MOEDA    := (cQry)->F2_MOEDA
						(cAlias)->F2_TXMOEDA  := (cQry)->F2_TXMOEDA
					EndIf
					(cAlias)->A4_NREDUZ  := SA4->A4_NREDUZ
					(cAlias)->XX_RECNO   := If(lQuery,(cQry)->SF2RECNO,SF2->(RecNo()))
					(cAlias)->(MsUnLock())
					If lFC0103FAT
						ExecBlock("FC0103FAT",.F.,.F.,{cAlias,cQry})					
					EndIf
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
			If ( lQuery )
				dbSelectArea(cQry)
				dbCloseArea()
			EndIf
		EndIf		
		aGet[1] := 0
		aGet[2] := 0
		dbSelectArea(cAlias)
		dbGotop()
		If cPaisLoc == "BRA"
			dbEval({|| aGet[1]++,aGet[2]+=F2_VALFAT})
		Else 
			dbEval({|| aGet[1]++,aGet[2]+=Iif(F2_MOEDA == 1,F2_VALFAT,xMoeda(F2_VALFAT,F2_MOEDA,1,F2_EMISSAO,MsDecimais(1),F2_TXMOEDA))})			
		EndIf
		aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,0))
		aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,nCasas))			

	//CHEQUES
	Case (nBrowse == 5)
   		DEFINE MSDIALOG oCheq FROM   15,1 TO 170,272 TITLE STR0072 PIXEL //"Seleccion de parametros"
      	@ 6 , 12 TO 65, 93 OF oCheq   LABEL STR0073 PIXEL //"Tipos de cheques a exhibir"

		If cPaisLoc$"ARG|COS"
	      	@ 13, 13 RADIO oTipo VAR nTipo ;
    	           PROMPT STR0062,STR0064,If(cPaisLoc="ARG",STR0088,STR0063),STR0134,STR0074 ;  //"Pendientes"###"Cobrados"###"Negociados"###"Transito"###"Todos"
        	       OF oCheq PIXEL SIZE 75,12
		Else
	      	@ 13, 13 RADIO oTipo VAR nTipo ;
    	           PROMPT STR0062,STR0064,If(cPaisLoc$"URU|BOL",STR0088,STR0063),STR0074 ;  //"Pendientes"###"Cobrados"###"Negociados"###"Todos"
        	       OF oCheq PIXEL SIZE 75,12
		Endif
		
      	DEFINE SBUTTON FROM 45, 100 TYPE 1 ACTION oCheq:End() ENABLE OF oCheq //11,132
	   	ACTIVATE MSDIALOG oCheq CENTERED
		
		Do case
			Case nTipo 	== 	1
				bTipo	:=	{ || (cQry)->E1_SALDO > 0 }
        	Case nTipo	==	2
				bTipo	:=	{ || !((cQry)->E1_SITUACA $ " 0FG") .And. (cQry)->E1_SALDO == 0 }
        	Case nTipo	==	3
				bTipo	:=	{ || (cQry)->E1_STATUS == "R" .And. (cQry)->E1_SITUACA $ " 0FG" .And. (cQry)->E1_SALDO == 0}
        	Case nTipo	==	4
				If cPaisLoc $ "ARG/COS"			
					bTipo	:=	{ || (cQry)->EL_TIPODOC $ cCheques .And. (cQry)->EL_TRANSIT == '1' .And. (cQry)->EL_DTENTRA == CTOD("//")}
				Else
					bTipo	:=	{ || .T. }
				Endif
			Case nTipo == 5	//Apenas ARG e COS
					bTipo	:=	{ || .T. }

		EndCase

		nMoeda := 1
		dbSelectArea("SX3")
		dbSetOrder(2)
		dbSeek("E1_STATUS")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		aadd(aHeader,{AllTrim(X3TITULO()),"XX_ESTADO","@!",04,0,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru,{"XX_ESTADO","C",04,0})
		/*
		GESTAO - inicio */
		dbSeek("E1_FILORIG")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		/* GESTAO - fim
		*/
		dbSeek("E1_PREFIXO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUM")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PARCELA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NUMNOTA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_EMISSAO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VALOR")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_SALDO")
		aadd(aHeader,{ AllTrim(X3TITULO()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_MOEDA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VLCRUZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_VENCREA")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_NATUREZ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_PORTADO")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_BCOCHQ")
		aadd(aHeader,{ AllTrim(X3Titulo()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		dbSeek("E1_HIST")
		aadd(aHeader,{ AllTrim(X3TITULO()),SX3->X3_CAMPO,SX3->X3_PICTURE,SX3->X3_TAMANHO,SX3->X3_DECIMAL,SX3->X3_VALID,SX3->X3_USADO,SX3->X3_TIPO,SX3->X3_ARQUIVO,SX3->X3_CONTEXT } )
		aadd(aStru ,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})

		dbSeek("E1_SITUACA")
		aadd(aQuery,{AllTrim(SX3->X3_CAMPO),SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL})
		aadd(aHeader,{STR0045,"X5_DESCRI","@!",25,0,"","","C","SX5","" } ) //"Situacao"
		aadd(aStru,{"X5_DESCRI","C",25,0})

		aadd(aStru,{"XX_RECNO" ,"N",12,0})
		aadd(aStru,{"XX_VALOR" ,"N",18,0})


		SX3->(dbSetOrder(1))
                        	
		cArquivo := CriaTrab(,.F.)			
		If !lExibe
			aadd(aAlias,{ cAlias , cArquivo })
	   	Endif
		aadd(aStru,{"FLAG","L",01,0})
		dbCreate(cArquivo,aStru)
		dbUseArea(.T.,,cArquivo,cAlias,.F.,.F.)
		IndRegua(cAlias,cArquivo,"E1_FILORIG,E1_PREFIXO+E1_NUM+E1_PARCELA")

		lNoChqTran := IIF(cPaisLoc $ "ARG|COS", (nTipo != 4) , .T.)
		If lnoChqTran

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
					lQuery := .T.
					cQuery := ""
					aEval(aQuery,{|x| cQuery += ","+AllTrim(x[1])})
					cQuery := "SELECT "+SubStr(cQuery,2)
					cQuery +=         ",SE1.R_E_C_N_O_ SE1RECNO"
					cQuery +=         ",SX5.X5_DESCRI "
					cQuery += "FROM "+RetSqlName("SE1")+" SE1,"
					cQuery +=         RetSqlName("SX5")+" SX5 "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SE1")
					cQuery += " WHERE SE1.E1_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery +=      "SE1.E1_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=      "SE1.E1_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=      "SE1.E1_EMISSAO>='"+Dtos(aParam[1])+"' AND "
					cQuery +=      "SE1.E1_EMISSAO<='"+Dtos(aParam[2])+"' AND "
					cQuery +=      "SE1.E1_VENCREA>='"+Dtos(aParam[3])+"' AND "
					cQuery +=		"SE1.E1_VENCREA<='"+Dtos(aParam[4])+"' AND "
					cQuery +=		"SE1.E1_TIPO IN" + FormatIn(cCheques,"|") + " AND "
					cQuery +=      "SE1.E1_PREFIXO>='"+aParam[6]+"' AND "
					cQuery +=      "SE1.E1_PREFIXO<='"+aParam[7]+"' AND "
					cQuery +=		"SE1.D_E_L_E_T_<>'*' AND "
					cQuery +=      "SX5.X5_FILIAL='"+xFilial("SX5")+"' AND "
					cQuery +=		"SX5.X5_TABELA='07' AND "
					cQuery +=		"SX5.X5_CHAVE=SE1.E1_SITUACA AND "
					cQuery +=		"SX5.D_E_L_E_T_<>'*' "                                
	
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"A"
	
					MsAguarde({ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)},STR0065) //"Seleccionado registros en el servidor"
	
					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Else
			#ENDIF
					cQry := "SE1"
			#IFDEF TOP
				EndIf
			#ENDIF
	
			dbSelectArea(cQry)
			If ( !lQuery )
				dbSetOrder(2)
	                  
				If aParam[13] == 1  //Considera loja
					dbSeek(xFilial("SE1")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE .And.;
												SA1->A1_LOJA   == SE1->E1_LOJA }
				Else
					dbSeek(xFilial("SE1")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SE1") == SE1->E1_FILIAL .And.;
												SA1->A1_COD    == SE1->E1_CLIENTE}			
				Endif
				bFiltro:= {|| 	SE1->E1_EMISSAO >= aParam[1] .And.;
									SE1->E1_EMISSAO <= aParam[2] .And.;
									SE1->E1_VENCREA >= aParam[3] .And.;
									SE1->E1_VENCREA <= aParam[4] .And.;
									SE1->E1_TIPO	 $ cCheques .And.;
									SE1->E1_PREFIXO >= aParam[6] .And.;
									SE1->E1_PREFIXO <= aParam[7]}
			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
	
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) ) .And. Eval(bTipo)
					If ( !lQuery )
						dbSelectArea("SX5")
						dbSetOrder(1)
						MsSeek(xFilial("SX5")+"07"+SE1->E1_SITUACA)
					EndIf
					dbSelectArea(cAlias)
					dbSetOrder(1)
					cChave := (cQry)->(E1_PREFIXO)+(cQry)->(E1_NUM)+(cQry)->(E1_PARCELA)
					If ( !dbSeek(cChave) )
						RecLock(cAlias,.T.)						
					Else
						RecLock(cAlias,.F.)
					EndIf
					For nCntFor := 1 To Len(aStru)
						Do Case
							Case ( AllTrim(aStru[nCntFor][1])=="X5_DESCRI" )
								If ( lQuery )
									(cAlias)->X5_DESCRI := (cQry)->X5_DESCRI
								Else
									(cAlias)->X5_DESCRI := SX5->X5_DESCRI
								EndIf
							Case ( AllTrim(aStru[nCntFor][1])=="XX_ESTADO" )
								If lQuery
									If (cQry)->E1_SALDO > 0
										(cAlias)->XX_ESTADO := STR0066 //"PEND"
									ElseIf (cQry)->E1_STATUS == "R" .And. (cQry)->E1_SITUACA $ "0FG"
										(cAlias)->XX_ESTADO := If(cPaisLoc$"URU|BOL|ARG",STR0089,STR0067) //"NEGO"
									Else									
										(cAlias)->XX_ESTADO := STR0068 //"COBR"
									Endif
								Else
									If SE1->E1_SALDO > 0
										(cAlias)->XX_ESTADO := STR0066 //"PEND"
									ElseIf SE1->E1_STATUS == "R" .And. SE1->E1_SITUACA $ "0FG"
										(cAlias)->XX_ESTADO := IIf(cPaisLoc$"URU|BOL|ARG",STR0089,STR0067) //"NEGO"
									Else									
										(cAlias)->XX_ESTADO := STR0068 //"COBR"
									Endif
								Endif
							Case ( AllTrim(aStru[nCntFor][1])=="XX_RECNO" )
								If ( lQuery )
									(cAlias)->XX_RECNO := (cQry)->SE1RECNO
								Else
									(cAlias)->XX_RECNO := SE1->(RecNo())
								EndIf
							Case ( AllTrim(aStru[nCntFor][1])=="XX_VALOR" )
								If ( lQuery )
									(cAlias)->XX_VALOR := xMoeda((cQry)->E1_VALOR,(cQry)->E1_MOEDA,nMoeda,,,If(cPaisLoc=="BRA",(cQry)->E1_TXMOEDA,0))
								Else
									(cAlias)->XX_VALOR := xMoeda(SE1->E1_VALOR,SE1->E1_MOEDA,nMoeda,,,If(cPaisLoc=="BRA",SE1->E1_TXMOEDA,0))
								EndIf
							Case ( AllTrim(aStru[nCntFor][1])=="FLAG" )
	
							OtherWise							
								(cAlias)->(FieldPut(nCntFor,(cQry)->(FieldGet(FieldPos(aStru[nCntFor][1])))))
						EndCase
					Next nCntFor
					dbSelectArea(cAlias)
					MsUnLock()
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
		Endif
		

		//Cheques em transito
		If cPaisLoc $ "ARG/COS" .and. (nTipo == 4 .or. nTipo == 5)

			#IFDEF TOP
				If ( TcSrvType()!="AS/400" )
	
					aQuery := SEL->(dbStruct())				
	
					lQuery := .T.
					cQuery := "SELECT "
					cQuery += "EL_FILIAL,EL_PREFIXO,EL_NUMERO,EL_PARCELA,EL_EMISSAO,EL_VALOR,EL_VALOR,EL_MOEDA,EL_VLMOED1,"
					cQuery += "EL_DTVCTO,EL_NATUREZ,EL_BANCO,EL_BCOCHQ,El_TXMOEDA,EL_TIPODOC,EL_TRANSIT,EL_DTENTRA,"
					cQuery += "SEL.R_E_C_N_O_ SELRECNO "
					cQuery += "FROM "+RetSqlName("SEL")+" SEL "
					/*
					GESTAO - inicio */
					nPosAlias := FC010QFil(1,"SEL")
					cQuery += " WHERE SEL.EL_FILIAL " + aTmpFil[nPosAlias,2] + " AND "
					/* GESTAO - fim
					*/
					cQuery += "SEL.EL_CLIENTE='"+SA1->A1_COD+"' AND "
					If aParam[13] == 1  //Considera loja
						cQuery +=      "SEL.EL_LOJA='"+SA1->A1_LOJA+"' AND "
					Endif
					cQuery +=  "SEL.EL_EMISSAO >= '"+Dtos(aParam[1])+"' AND "
					cQuery +=  "SEL.EL_EMISSAO <= '"+Dtos(aParam[2])+"' AND "
					cQuery +=  "SEL.EL_DTVCTO  >= '"+Dtos(aParam[3])+"' AND "
					cQuery +=  "SEL.EL_DTVCTO  <= '"+Dtos(aParam[4])+"' AND "
					cQuery +=  "SEL.EL_TIPODOC IN " + FormatIn(cCheques,"|") + " AND "
					cQuery +=  "SEL.EL_PREFIXO >= '"+aParam[6]+"' AND "
					cQuery +=  "SEL.EL_PREFIXO <= '"+aParam[7]+"' AND "
					cQuery +=  "SEL.D_E_L_E_T_ = ' ' AND "
					cQuery +=  "SEL.EL_TRANSIT = '1' AND "
					cQuery +=  "SEL.EL_DTENTRA = ' ' "				
	
					cQuery := ChangeQuery(cQuery)
					cQry   := cArquivo+"B"
	
					MsAguarde({ || dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cQry,.T.,.T.)},STR0065) //"Seleccionado registros en el servidor"
	
					aEval(aQuery,{|x| If(x[2]!="C",TcSetField(cQry,x[1],x[2],x[3],x[4]),Nil)})
				Else
			#ENDIF
				cQry := "SEL"
			#IFDEF TOP
				EndIf
			#ENDIF
	
			dbSelectArea(cQry)
			
			If ( !lQuery )
				SEL->(dbSetOrder(7))
	                  
				If aParam[13] == 1  //Considera loja
					dbSeek(xFilial("SEL")+SA1->A1_COD+SA1->A1_LOJA)
					bWhile := {|| !Eof() .And. xFilial("SEL") == SEL->EL_FILIAL .And.;
												SA1->A1_COD    == SEL->EL_CLIENTE .And.;
												SA1->A1_LOJA   == SEL->EL_LOJA }
				Else
					dbSeek(xFilial("SEL")+SA1->A1_COD)
					bWhile := {|| !Eof() .And. xFilial("SEL") == SEL->EL_FILIAL .And.;
												SA1->A1_COD    == SE1->EL_CLIENTE}			
				Endif
				bFiltro:= {|| 	SEL->EL_EMISSAO >= aParam[1] .And.;
								SEL->EL_EMISSAO <= aParam[2] .And.;
								SEL->EL_DTVCTO  >= aParam[3] .And.;
								SEL->EL_DTVCTO <= aParam[4] .And.;
								SEL->EL_TIPODOC	 $ cCheques .And.;
								SEL->EL_PREFIXO >= aParam[6] .And.;
								SEL->EL_PREFIXO <= aParam[7] .And.;
								SEL->EL_TRANSIT == '1' }

			Else
				bWhile := {|| !Eof() }
				bFiltro:= {|| .T. }
			EndIf			
	
			While ( Eval(bWhile) )				
				If ( Eval(bFiltro) ) .And. Eval(bTipo)
					dbSelectArea(cAlias)
					dbSetOrder(1)
									
					RecLock(cAlias,.T.)						
					(cAlias)->XX_ESTADO  := "TRAN" 
					(cAlias)->E1_FILORIG := (cQry)->EL_FILIAL 
					(cAlias)->E1_PREFIXO := (cQry)->EL_PREFIXO
					(cAlias)->E1_NUM 	 := (cQry)->EL_NUMERO
					(cAlias)->E1_PARCELA := (cQry)->EL_PARCELA
					(cAlias)->E1_NUMNOTA := ""
					(cAlias)->E1_EMISSAO := (cQry)->EL_EMISSAO
					(cAlias)->E1_VALOR   := (cQry)->EL_VALOR
					(cAlias)->E1_SALDO   := (cQry)->EL_VALOR
					(cAlias)->E1_MOEDA   := Val((cQry)->EL_MOEDA)
					(cAlias)->E1_VLCRUZ  := (cQry)->EL_VLMOED1
					(cAlias)->E1_VENCREA := (cQry)->EL_DTVCTO
					(cAlias)->E1_NATUREZ := (cQry)->EL_NATUREZ
					(cAlias)->E1_PORTADO := (cQry)->EL_BANCO
					(cAlias)->E1_BCOCHQ  := (cQry)->EL_BCOCHQ
					(cAlias)->E1_HIST    := "CHQ EM TRANSITO" 

					If ( lQuery )
						(cAlias)->XX_RECNO   := (cQry)->SELRECNO
						(cAlias)->XX_VALOR   := xMoeda((cQry)->EL_VALOR,VAL((cQry)->EL_MOEDA),nMoeda )
        			Else
						(cAlias)->XX_RECNO := SEL->(RecNo())
						(cAlias)->XX_VALOR := xMoeda(SEL->EL_VALOR,Val(SEL->EL_MOEDA),nMoeda)
                    Endif
				
					(cAlias)->(MsUnLock())
					
				EndIf
				dbSelectArea(cQry)
				dbSkip()				
			EndDo
		Endif	
		

		If ( lQuery )
			dbSelectArea(cQry)
			dbCloseArea()
		EndIf                                              
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³Totais da Consulta                                                      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
		dbSelectArea(cAlias)
		dbGotop()
		aGet	:=	{0,0,0,0,0,0,0,0}
		While !EOF()
			DO CASE
				CASE XX_ESTADO	==	STR0066 //"PEND"
				 	aGet[1]	+=	(cAlias)->E1_SALDO
				 	aGet[4]++
				CASE XX_ESTADO	==	If(cPaisLoc$"URU|BOL|ARG",STR0089,STR0067) //"NEGO"
				 	aGet[2]	+=	(cAlias)->XX_VALOR
				 	aGet[5]++
				CASE XX_ESTADO	==	STR0068 //"COBR"
				 	aGet[3]	+=	(cAlias)->XX_VALOR
				 	aGet[6]++
				CASE XX_ESTADO	==	STR0135 //"TRAN"
				 	aGet[7]	+=	(cAlias)->XX_VALOR
				 	aGet[8]++

			EndCase				 	
			dbSkip()
		Enddo
		If lExibe
 		    aGet[1] := TransForm(aGet[1],Tm(aGet[1],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[4]))+")"
			aGet[2] := TransForm(aGet[2],Tm(aGet[2],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[5]))+")"
			aGet[3] := TransForm(aGet[3],Tm(aGet[3],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[6]))+")"
 		    aGet[4] := TransForm(aGet[7],Tm(aGet[7],16,MsDecimais(nMoeda))) + " (" +Alltrim(STR(aGet[8]))+")"
			aGet[5] := STR0069+GetMv("MV_MOEDA1") //"Valores en "  
			aGet[6] := ""
		EndIf
	Otherwise
		Alert(STR0060)		//Não Implementado
		lExibe := .f.
EndCase	

If nBrowse == 1
	_nVencer := 0
	_nVencid := 0
	_nVencer1 := 0
	_nVencid2 := 0

	//Rubens Cruz  - 21/07/2015
	//Calcula totais de acordo com o aCols Gerado
	TotTits(cAlias)

//TITULOS A VENCER - RAFAEL
/*cQuery := " SELECT SUM(E1_VALOR) VALOR FROM " +RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "
cQuery += " AND E1_BAIXA = '' "
cQuery += " AND E1_VENCTO >= '"+DtoS(dDataBase)+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","VALOR","N",12,2)

DbSelectArea("TMP")
DbGoTop()
_nVencer := TMP->VALOR

DbSelectArea("TMP")
DbCloseArea()

//TITULOS VENCIDOS - RAFAEL
cQuery := " SELECT SUM(E1_VALOR) VALOR FROM " +RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "
cQuery += " AND E1_BAIXA = '' "
cQuery += " AND E1_TIPO NOT IN ('AB-') "
cQuery += " AND E1_VENCTO < '"+DtoS(dDataBase)+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","VALOR","N",12,2)

DbSelectArea("TMP")
DbGoTop()
_nVencid := TMP->VALOR

DbSelectArea("TMP")
DbCloseArea()

//TITULOS A VENCER - RAFAEL
cQuery := " SELECT SUM(E1_VALOR) VALOR FROM " +RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "
cQuery += " AND E1_BAIXA = '' AND E1_SITUACA = '5' "
cQuery += " AND E1_VENCTO >= '"+DtoS(dDataBase)+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","VALOR","N",12,2)

DbSelectArea("TMP")
DbGoTop()
_nVencer1 := TMP->VALOR

DbSelectArea("TMP")
DbCloseArea()

//TITULOS VENCIDOS - RAFAEL
cQuery := " SELECT SUM(E1_VALOR) VALOR FROM " +RetSqlName("SE1")
cQuery += " WHERE D_E_L_E_T_ = '' "
cQuery += " AND E1_CLIENTE = '"+SA1->A1_COD+"' AND E1_LOJA = '"+SA1->A1_LOJA+"' "
cQuery += " AND E1_BAIXA = ''  AND E1_SITUACA = '5' "
cQuery += " AND E1_VENCTO < '"+DtoS(dDataBase)+"' "
cQuery := ChangeQuery(cQuery)
dbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), 'TMP', .F., .T.)
TcSetField("TMP","VALOR","N",12,2)

DbSelectArea("TMP")
DbGoTop()
_nVencid1 := TMP->VALOR

DbSelectArea("TMP")
DbCloseArea()*/

EndIf


//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Exibe os dados Gerados                                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
If ( lExibe )
	dbSelectArea(cAlias)
	dbGotop()
	If ( !Eof() )
		
		aObjects := {} 
		AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
		AAdd( aObjects, { 100, 100 , .t., .t. } )
		AAdd( aObjects, { 100, 50 , .t., .f. } )
		
		aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj1 := MsObjSize( aInfo, aObjects) 
		
		DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

		DEFINE MSDIALOG oDlg FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE cCadastro OF oMainWnd PIXEL
		@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oScrPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlg LOWERED

		@ 04,004 SAY OemToAnsi(STR0006) SIZE 025,07          OF oScrPanel PIXEL //"Codigo"
		@ 12,004 SAY SA1->A1_COD  SIZE 060,09  OF oScrPanel PIXEL FONT oBold
		      
	   If aParam[13] == 1  //Considera loja		
			@ 04,067 SAY OemToAnsi(STR0007) SIZE 020,07          OF oScrPanel PIXEL //"Loja"
			@ 12,067 SAY SA1->A1_LOJA SIZE 021,09 OF oScrPanel PIXEL FONT oBold
		Endif

		@ 04,090 SAY OemToAnsi(STR0008) SIZE 025,07 OF oScrPanel PIXEL //"Nome"
		@ 12,090 SAY SA1->A1_NOME SIZE 165,09 OF oScrPanel PIXEL FONT oBold

		oGetDb:=MsGetDB():New(aPosObj1[2,1],aPosObj1[2,2],aPosObj1[2,3],aPosObj1[2,4],2,"",,,.F.,,,.F.,,cAlias,,,,,,.T.)
		oGetdb:lDeleta:=NIL
		dbSelectArea(cAlias)
		dbGotop()

		@ aPosObj1[3,1]+04,005 SAY aSay[1] SIZE 045,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+04,175 SAY aSay[2] SIZE 045,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,005 SAY aSay[3] SIZE 045,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,175 SAY aSay[4] SIZE 045,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,005 SAY aSay[5] SIZE 045,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,175 SAY aSay[6] SIZE 045,07 OF oDlg PIXEL

		@ aPosObj1[3,1]+04,060 SAY aGet[1] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+04,215 SAY aGet[2] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,060 SAY aGet[3] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+15,215 SAY aGet[4] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,060 SAY aGet[5] SIZE 060,07 OF oDlg PIXEL
		@ aPosObj1[3,1]+26,215 SAY aGet[6] SIZE 060,07 OF oDlg PIXEL
		
		/*
		If nBrowse == 1
			aItems:= {'Lucros e Perdas','Ambos'}
			cCombo:= aItems[2] 

			oCombo:= tComboBox():New(06,400,{|u|if(PCount()>0,cCombo:=u,cCombo)},;
			aItems,100,20,oDlg,,{||Fc010LucPer(cAlias1,aSay,aGet1,cCombo),cCombo:= aItems[2],oDlg:Refresh(),oGetDb:Refresh()},,,,.T.,,,,,,,,,'cCombo') // Botão para fechar a janela
		EndIf
		*/
		
		
		//adicionado rafael
		If nBrowse == 1
			@ aPosObj1[3,1]+4, 410 SAY "Titulos a Vencer" OF oDlg PIXEL
			@ aPosObj1[3,1]+3, 450 MsGet _nVencer Picture PesqPict("SE1","E1_VALOR") OF oDlg PIXEL SIZE 060,009 When .F.
			@ aPosObj1[3,1]+25, 410 SAY "Titulos Vencidos" OF oDlg PIXEL
			@ aPosObj1[3,1]+24, 450 MsGet _nVencid Picture PesqPict("SE1","E1_VALOR") OF oDlg PIXEL SIZE 060,009 When .F.
			
			//@ aPosObj1[3,1]+36, 410 BUTTON "Negociação" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC05((cAlias)->XX_RECNO)  OF oDlg PIXEL //"Negociação"(cAlias)->XX_RECNO
			@ 06, 300 BUTTON "Negociação" SIZE 60,12 FONT oDlg:oFont ACTION U_IFINC05((cAlias)->XX_RECNO)  OF oDlg PIXEL //"Negociação"(cAlias)->XX_RECNO
		EndIf
		
		If ( nBrowse == 1 ) // Para titulos em aberto, mostra legenda.
			Fc010Legenda(oDlg,aPosObj1,aSay,aGet)
		Endif
		
		DEFINE SBUTTON 		FROM 04,aPosObj1[1,3]-If(nBrowse <= 2,60,30) TYPE  1  ENABLE OF oScrPanel ACTION ( oDlg:End() )
		// Exibe o botao de distribuicao por moedas, apenas na consulta de titulos
		// em aberto e recebidos
		If nBrowse <= 2
			SButton():New(04, aPosObj1[1,3]-30, 18,{||Fc010Moeda(If(nBrowse==1,aTotRec,aTotPag),oScrPanel)},oScrPanel,.T.,STR0097) //"Consulta distribuição por moedas"
			TButton():New(19, aPosObj1[1,3]-60,'Excel',oScrPanel,{||Fc010Excel(cAlias,aHeader,aParam,nBrowse),oDlg:Refresh(),oGetDb:Refresh()},26,10,,,,.T.) 			
		Endif	

		DEFINE SBUTTON oBtn 	FROM 19,aPosObj1[1,3]-30 TYPE 15 ENABLE OF oScrPanel

		oBtn:lAutDisable := .F.
		If ( bVisual != Nil )
			oBtn:bAction := bVisual
		Else
			oBtn:SetDisable(.T.)
		EndIf
		ACTIVATE MSDIALOG oDlg
	Else
		Help(" ",1,"REGNOIS")	
	EndIf
	If nBrowse == 5
		(cAlias)->(dbCloseArea()) ;Ferase(cArquivo+GetDBExtension());Ferase(cArquivo+OrdBagExt())
	Endif
EndIf
RestArea(aAreaSC5)
RestArea(aAreaSC6)
RestArea(aAreaSC9)
RestArea(aAreaSF4)
RestArea(aArea)
Return(aHeader)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Fc010Legen³ Autor ³ Claudio Donizete Souza³ Data ³13.11.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe legenda de titulos baixados parcial ou totalmente     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
static Function Fc010Legenda(oDlg,aPosObj1,aSay,aGet)
	@ aPosObj1[3,1]+37,005 SAY aSay[7] SIZE 035,07 OF oDlg PIXEL  //Total Geral
	@ aPosObj1[3,1]+37,060 SAY aGet[7] SIZE 060,07 OF oDlg PIXEL

	@ aPosObj1[3,1]+4, 300 BITMAP oBmp RESNAME "BR_AZUL" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+4, 310 SAY STR0121 OF oDlg PIXEL // "Baixado parcial"
			
	@ aPosObj1[3,1]+20.5, 300 BITMAP oBmp1 RESNAME "BR_VERDE" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+20.5, 310 SAY STR0094 OF oDlg PIXEL // "Sem baixas"

	@ aPosObj1[3,1]+37, 300 BITMAP oBmp RESNAME "BR_AMARELO" SIZE 16,16 NOBORDER OF oDlg PIXEL
	@ aPosObj1[3,1]+37, 310 SAY STR0113 OF oDlg PIXEL   //"Titulo c/ Cheque Devolvido"

Return Nil
               
/*/
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³Fc010Excel ³ Autor ³ Mauricio Pequim Jr   ³ Data ³ 31.03.08 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Rotina para exportatacao de dados para Excel               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Retorno   ³ Nenhum                                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ ExpC1 : Alias                                              ³±±
±±³          ³ ExpA2 : Array com as Descricoes do Cabecalho               ³±±
±±³          ³ ExpA3 : Array com os parametros (perguntes) da rotina      ³±±
±±³          ³ ExpN4 : Opcao executada                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ FINC010                                                    ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fc010Excel(cAlias,aHeader,aParam,nBrowse)

LOCAL aItem			:= {}
LOCAL aItenXCel	:= {}
Local aStruD		:= {}
Local aStruX		:= {}
Local aArea			:= (cAlias)->(GetArea())
Local lLoja			:= .T.
Local nDel			:= 0
Local nX				:= 0
Local cTexto		:= ""

DEFAULT cAlias	:= "SE1"
DEFAULT aHeader:= {}
DEFAULT aParam	:= {}
DEFAULT nBrowse 	:= 0

If Len(aHeader) > 0 .and. Len(aParam) > 0

	//aParam[13] == 1 -> considera lojas
	If aParam[13] == 1
		cCliente := SA1->A1_COD + " - " + SA1->A1_LOJA + " - " + SA1->A1_NREDUZ
	Else
		cCliente := SA1->A1_COD + " - " + SA1->A1_NREDUZ
		lLoja := .F.
	Endif
	
	If ! ApOleClient( 'MsExcel' ) 
		MsgAlert( STR0133)  //'MsExcel nao instalado'
	Else
		DbSelectArea(cAlias)
		DbGotop()
	
		//Montagem dos dados a serem exportados para Excel
		For nX := 1 to Len(aHeader)
			//------------------------------------
			//aHeader
			//01 AllTrim(X3Titulo())
			//02 SX3->X3_CAMPO
			//03 SX3->X3_PICTURE
			//04 SX3->X3_TAMANHO
			//05 SX3->X3_DECIMAL
			//06 SX3->X3_VALID
			//07 SX3->X3_USADO
			//08 SX3->X3_TIPO
			//09 SX3->X3_ARQUIVO
			//10 SX3->X3_CONTEXT
			//------------------------------------
	
			If !("XX_" $ aHeader[nX][2]) .and. !(If(lLoja,("_LOJA" $ aHeader[nX][2]),.F.))
				aADD(aStruD,{aHeader[nX][1],aHeader[nX][8],aHeader[nX][4],aHeader[nX][5]})
				aADD(aStruX,{aHeader[nX][2],aHeader[nX][8],aHeader[nX][4],aHeader[nX][5]})
			Endif
		Next
	
		AADD(aStruD,{"","C",1,0})
		AADD(aStruX,{"","C",1,0})
	
	
		WHILE (cAlias)->(!EOF())
	 						
			aItem := Array(Len(aStruX))
			For nX := 1 to Len(aStruX)
				IF nX == Len(aStruX)  // Coluna de compatibilizacao com a abertura no EXCEL
					aItem[nX] := CHR(160)
				ELSEIF aStruX[nX][2] == "C"
					aItem[nX] := CHR(160)+(cAlias)->&(aStruX[nX][1])
				ELSE
					aItem[nX] := (cAlias)->&(aStruX[nX][1])
				ENDIF
			Next nX 
			AADD(aItenXcel,aItem)
			aItem := {}
			(cAlias)->(dbSkip())
		Enddo
	
		If nBrowse == 1
			cTexto := STR0128 +cCLiente //"Consulta Titulos em Aberto do Cliente - "
		Else		
			cTexto := STR0129 +cCLiente //"Consulta Titulos Baixados do Cliente - "
		Endif
	
		MsgRun(STR0130, STR0131,{||DlgToExcel({{"GETDADOS",cTexto,aStruD,aItenXcel}})}) //"Favor Aguardar....."###"Exportando os Registros para o Excel"
	
	EndIf

Endif

RestArea(aArea)

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³Fc010Moeda³ Autor ³ Claudio Donizete Souza³ Data ³13.11.2002³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Exibe os totais a pagar a recebidos por moeda               ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aTotais- Matriz de totais por moeda								  ³±±
±±³          ³oDlg   - Objeto dialog que sera exibida a tela da consulta  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fc010Moeda(aTotais,oDlg)
Local	aCab := { STR0098	,; //"Qtde. Titulos"
					 STR0099	,; //"Moeda"
					 STR0100	,; //"Valor na moeda"
					 STR0101} 	//"Valor em R$"
Local oLbx					 
	DEFINE DIALOG oDlg FROM 0,0 TO 20,70 TITLE STR0102 OF oDlg //"Distribuição por moeda"
	oLbx := RDListBox(.5, .4, 270, 130, aTotais, aCab)
	oLbx:LNOHSCROLL := .T.
	oLbx:LHSCROLL := .F.
	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Program   ³FC010TotRc³ Autor ³ Mauricio Pequim Jr    ³ Data ³30.08.2001³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³Somat¢ria dos titulos recebidos                             ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³aGet - Array que guardar  o nro de titulos, valores princi- ³±±
±±³          ³       pais e valor da baixa                                ³±±
±±³          ³cAlias - Alias do arquivo tempor rio                        ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function FC010TotRc(aGet,cAlias,aTotPag)
Local cTitAnt := ""
Local nAscan

While !Eof()
	aGet[1]++
	// Impressao do relatorio nao existe E1_MOEDA no temporario
	If FieldPos("E1_MOEDA") > 0
		nAscan := Ascan(aTotPag,{|e| e[MOEDATIT] == E1_MOEDA})
		If nAscan = 0
			Aadd(aTotPag,{1,E1_MOEDA,If(E1_MOEDA>1,E1_VLMOED2,E1_PAGO),E1_PAGO})
		Else
			aTotPag[nAscan][QTDETITULOS]++
			aTotPag[nAscan][VALORTIT]		+= If(E1_MOEDA>1,E1_VLMOED2,E1_PAGO)
			aTotPag[nAscan][VALORREAIS]	+= E1_PAGO
		Endif
	Endif
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Somo o valor do titulo apenas uma vez em caso de baixa parcial ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	If (cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO) != cTitAnt
		aGet[2]+= E1_VLCRUZ
		cTitAnt := (cAlias)->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)
	Endif
	aGet[3] += E1_PAGO
	dbSkip()
Enddo
Return (aGet)

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o	 ³fc010Visua³ Autor ³Eduardo Riera  		³ Data ³04/01/2000³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡„o ³Funcao de Visualizacao dos Itens individuais da Posicao de  ³±±
±±³          ³Cliente.                                                    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Sintaxe	 ³Fc010Visua()        						     			  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Parametros³ExpN1		: Recno do Arquivo principal                      ³±±
±±³          ³ExpN2		: nBrowse                                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso		 ³ FINC010													 				  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function Fc010Visua(nRecno,nBrowse)

Local aArea := GetArea()
Local aAreaSE1 := SE1->(GetArea())
Local aAreaSE5 := SE5->(GetArea())
Local aAreaSC5 := SC5->(GetArea())
Local aSavAhead:= If(Type("aHeader")=="A",aHeader,{})
Local aSavAcol := If(Type("aCols")=="A",aCols,{})
Local nSavN    := If(Type("N")=="N",N,0)
Local cFilBkp  := cFilAnt 

Do Case
Case ( nBrowse == 1 )
	SE1->(MsGoto(nRecno))
	// Modifica a filial para visualizacao atraves da funcao AxVisual
	cFilAnt := IIf(cFilAnt <> SE1->E1_FILIAL .And. !Empty(cFilAnt),SE1->E1_FILIAL,cFilAnt)	
	SE1->(AxVisual("SE1",nRecNo,2))

Case ( nBrowse == 2 )
	SE5->(MsGoto(nRecno))
	// Modifica a filial para visualizacao atraves da funcao AxVisual
	cFilAnt := IIf(cFilAnt <> SE5->E5_FILIAL .And. !Empty(cFilAnt),SE5->E5_FILIAL,cFilAnt)
	SE5->(AxVisual("SE5",nRecNo,2))

Case ( nBrowse == 3 )
	SC5->(MsGoto(nRecno))		
	// Modifica a filial para visualizacao atraves da funcao AxVisual
	cFilAnt := IIf(cFilAnt <> SC5->C5_FILIAL .And. !Empty(cFilAnt),SC5->C5_FILIAL,cFilAnt)
	SC5->(a410Visual("SC5",nRecNo,2))

Case ( nBrowse == 4 )
	SF2->(MsGoto(nRecno))
	// Modifica a filial para visualizacao atraves da funcao AxVisual
	cFilAnt := IIf(cFilAnt <> SF2->F2_FILIAL .And. !Empty(cFilAnt),SF2->F2_FILIAL,cFilAnt)
	SF2->(Mc090Visual("SF2",nRecNo,2))
Case ( nBrowse == 5 )
	SEL->(MsGoto(nRecno))
	// Modifica a filial para visualizacao atraves da funcao AxVisual
	cFilAnt := IIf(cFilAnt <> SEL->EL_FILIAL .And. !Empty(cFilAnt),SEL->EL_FILIAL,cFilAnt)	
	SEL->(AxVisual("SEL",nRecNo,2))
EndCase
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³Restaura a Integridade dos Dados                                        ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
cFilAnt := cFilBkp
aHeader := aSavAHead
aCols   := aSavACol
N       := nSavN

RestArea(aAreaSC5)
RestArea(aAreaSE5)
RestArea(aAreaSE1)
RestArea(aArea)
Return(.T.)

Static Function Fc010LucPer(cAlias1,aSay,aGet1,cCombo)

Local oGetDb1
Local oScrPanel1
Local oBold1
Local oDlg1
Local oBtn1
Local bVisual1
Local bWhile
Local bFiltro
Local cArquivo	:= ""
Local cArquivo1	:= ""
Local cCadastro	:= ""
Local oDlg
Local oButton
Local oCombo
Local nCntFor	:= 0
Local nSalped	:= 0
Local nSalpedl	:= 0
Local nSalpedb	:= 0
Local nQtdPed	:= 0
Local nTotAbat	:= 0
Local cAnterior	:= ""
Local nTaxaM	:= 0	
Local nMoeda
Local oTipo
Local nTipo		:= 1
Local bTipo
Local oCheq
Local aTotRec	:= {{0,1,0,0}} // Totalizador de titulos a receber por por moeda
Local aTotPag	:= {{0,1,0,0}} // Totalizador de titulos recebidos por por moeda
Local nAscan
Local nTotalRec	:=0
Local aSize		:= MsAdvSize( .F. )
Local aPosObj1	:= {}                 
Local aObjects	:= {}                       
Local aCpos		:= {}

If cCombo == "Ambos"
	Return
EndIf

	dbSelectArea(cAlias1)
	dbGotop()
	If ( !Eof() )
		
		aObjects := {} 
		AAdd( aObjects, { 100, 35,  .t., .f., .t. } )
		AAdd( aObjects, { 100, 100 , .t., .t. } )
		AAdd( aObjects, { 100, 50 , .t., .f. } )
		
		aInfo    := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 } 
		aPosObj1 := MsObjSize( aInfo, aObjects) 
		
		DEFINE FONT oBold    NAME "Arial" SIZE 0, -12 BOLD

		DEFINE MSDIALOG oDlg1 FROM	aSize[7],0 TO aSize[6],aSize[5] TITLE cCadastro OF oMainWnd PIXEL
		@ aPosObj1[1,1], aPosObj1[1,2] MSPANEL oScrPanel PROMPT "" SIZE aPosObj1[1,3],aPosObj1[1,4] OF oDlg1 LOWERED

		@ 04,004 SAY OemToAnsi(STR0006) SIZE 025,07          OF oScrPanel PIXEL //"Codigo"
		@ 12,004 SAY SA1->A1_COD  SIZE 060,09  OF oScrPanel PIXEL FONT oBold
		      
	   If aParam[13] == 1  //Considera loja		
			@ 04,067 SAY OemToAnsi(STR0007) SIZE 020,07          OF oScrPanel PIXEL //"Loja"
			@ 12,067 SAY SA1->A1_LOJA SIZE 021,09 OF oScrPanel PIXEL FONT oBold
		Endif

		@ 04,090 SAY OemToAnsi(STR0008) SIZE 025,07 OF oScrPanel PIXEL //"Nome"
		@ 12,090 SAY SA1->A1_NOME SIZE 165,09 OF oScrPanel PIXEL FONT oBold

		oGetDb1:=MsGetDB():New(aPosObj1[2,1],aPosObj1[2,2],aPosObj1[2,3],aPosObj1[2,4],2,"",,,.F.,,,.F.,,cAlias1,,,,,,.T.)
		oGetdb1:lDeleta:=NIL
		dbSelectArea(cAlias1)
		dbGotop()

		@ aPosObj1[3,1]+04,005 SAY aSay[1] SIZE 045,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+04,175 SAY aSay[2] SIZE 045,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+15,005 SAY aSay[3] SIZE 045,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+15,175 SAY aSay[4] SIZE 045,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+26,005 SAY aSay[5] SIZE 045,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+26,175 SAY aSay[6] SIZE 045,07 OF oDlg1 PIXEL

		@ aPosObj1[3,1]+04,060 SAY aGet1[1] SIZE 060,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+04,215 SAY aGet1[2] SIZE 060,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+15,060 SAY aGet1[3] SIZE 060,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+15,215 SAY aGet1[4] SIZE 060,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+26,060 SAY aGet1[5] SIZE 060,07 OF oDlg1 PIXEL
		@ aPosObj1[3,1]+26,215 SAY aGet1[6] SIZE 060,07 OF oDlg1 PIXEL
			
			@ aPosObj1[3,1]+4, 410 SAY "Titulos a Vencer" OF oDlg1 PIXEL
			@ aPosObj1[3,1]+3, 450 MsGet _nVencer1 Picture PesqPict("SE1","E1_VALOR") OF oDlg1 PIXEL SIZE 060,009 When .F.
			@ aPosObj1[3,1]+25, 410 SAY "Titulos Vencidos" OF oDlg1 PIXEL
			@ aPosObj1[3,1]+24, 450 MsGet _nVencid1 Picture PesqPict("SE1","E1_VALOR") OF oDlg1 PIXEL SIZE 060,009 When .F.
			
			@ 06, 300 BUTTON "Negociação" SIZE 60,12 FONT oDlg1:oFont ACTION U_IFINC05((cAlias1)->XX_RECNO)  OF oDlg1 PIXEL //"Negociação"(cAlias)->XX_RECNO
			
		
			Fc010Legenda(oDlg1,aPosObj1,aSay,aGet1)
		
		DEFINE SBUTTON 		FROM 04,aPosObj1[1,3]-30 TYPE  1  ENABLE OF oScrPanel ACTION ( oDlg1:End() )
		// Exibe o botao de distribuicao por moedas, apenas na consulta de titulos
		// em aberto e recebidos

		DEFINE SBUTTON oBtn 	FROM 19,aPosObj1[1,3]-30 TYPE 15 ENABLE OF oScrPanel
		
		bVisual   := {|| Fc010Visua((cAlias1)->XX_RECNO,1) }

		oBtn:lAutDisable := .F.
		If ( bVisual != Nil )
			oBtn:bAction := bVisual
		Else
			oBtn:SetDisable(.T.)
		EndIf
		ACTIVATE MSDIALOG oDlg1
	Else
		Help(" ",1,"REGNOIS")	
	EndIf

Return

/*
+-----------+---------+-------+-------------------------------------+------+---------------+
| Programa  | TotTits | Autor | Rubens Cruz	- Anadi Soluções 		| Data | Julho/2015    |
+-----------+---------+-------+-------------------------------------+------+---------------+
| Descricao | Calcula o total de titulos vencidos e a vencer do grid gerado				   |
+-----------+------------------------------------------------------------------------------+
| Uso       | ISAPA													 					   |
+-----------+------------------------------------------------------------------------------+
*/

Static Function TotTits(cAlias)
Local _aArea 	:= GetArea() 
Local _aArea1	:= (cAlias)->(GetArea())

DbSelectArea(cAlias)
DbGoTop()

While !eof()
    If((cAlias)->E1_VENCREA < dDataBase)
    	_nVencid += E1_SALDO
	Else
		_nVencer += E1_SALDO
	EndIf
	DbSkip()
EndDo

RestArea(_aArea1)
RestArea(_aArea)

Return
