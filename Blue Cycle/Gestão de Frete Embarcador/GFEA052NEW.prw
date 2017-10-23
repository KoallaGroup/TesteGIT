// #########################################################################################
// Projeto:
// Modulo :
// Fonte  : GFEA052NEW
// ---------+-------------------+-----------------------------------------------------------
// Data     | Autor             | Descricao
// ---------+-------------------+-----------------------------------------------------------
// 05/12/14 | TOTVS | Developer Studio | Gerado pelo Assistente de Código
// ---------+-------------------+-----------------------------------------------------------

#include "rwmake.ch"

User Function GFEA052N()

Local cDesc1        := "Este programa tem como objetivo imprimir relatorio "
Local cDesc2        := "de acordo com os parametros informados pelo usuario."
Local cDesc3        := "AAAAAA"
Local cPict         := ""
Local titulo       	:= "*****   ROMANEIO  DE  TRANSPORTE   *****"
Local nLin         	:= 80
Local Cabec1       	:= "BBBBB"
Local Cabec2       	:= "CCCCC"
Local imprime      	:= .T.
Local aOrd 			:= {}

Private lEnd        := .F.
Private lAbortPrint := .F.
Private CbTxt       := ""
Private limite      := 132
Private tamanho     := "M"
Private nomeprog    := "GFEA052N" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo       := 18
Private aReturn     := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey    := 0
Private cPerg       := "GFEA052N"
Private cbtxt      	:= Space(10)
Private cbcont     	:= 00
Private CONTFL     	:= 01
Private m_pag      	:= 01
Private wnrel      	:= "GFEA052N" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cFilRom
Private cRomanINI
Private cRomanFIM
Private dDataSaida
Private cHoraSaida
Private cTipoImp                    

cString := "GWN"
pergunte(cPerg,.F.)

cRomanINI      := MV_PAR02
cRomanFIM      := MV_PAR03
cTipoImp       := MV_PAR11     // Previa_Reimpressão / Oficial

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  05/12/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

if EMPTY(cRomanINI) .OR. EMPTY(cRomanFIM)
	ALERT("Obrigatório Preenchimento:  Romaneio Inicial e Final.")
	Return
Endif

cRomanINI      := MV_PAR02
cRomanFIM      := MV_PAR03
cTipoImp       := MV_PAR11     // Previa_Reimpressão / Oficial   

/*
oBrowse:AddLegend("GWN_SIT=='1'", "WHITE" , STR0036) //"Digitado"
oBrowse:AddLegend("GWN_SIT=='2'", "BLUE", "Emitido") //"Emitido"
oBrowse:AddLegend("GWN_SIT=='3'", "GREEN" , STR0038) //"Liberado"
oBrowse:AddLegend("GWN_SIT=='4'", "RED"   , STR0039) //"Encerrado"
*/

dbSelectArea("GW1")
dbSetOrder(9)   // GW1_FILIAL + GW1_NRROM

dbSelectArea("GWN")
dbSetOrder(1)   // GWN_FILIAL + GWN_NRROM
SET FILTER TO
If DBSeek( xFilial("GWN") + cRomanINI )
	While GWN->GWN_NRROM >= cRomanINI .AND. GWN->GWN_NRROM <= cRomanFIM .AND. GWN->GWN_FILIAL = xFilial("GWN") .AND. !EOF()
		// Prévia/Reimpressão.
		If cTipoImp == 1
			//Não permite impressão de romaneio inexiste
			If GWN->GWN_SIT == "4"
				Alert("VERMELHO - Romaneio " + GWN->GWN_NRROM + " ESTA ENCERRADO e não sera Impresso! ")
				DbSkip()
				LOOP
			EndIf
		EndIf
		// Oficial.
		If cTipoImp == 2
			//Só permite imprimir romaneios Digitados
			If GWN->GWN_SIT != "1"
				Alert("Impressão Oficial Somente BRANCO. Romaneio " + GWN->GWN_NRROM + " não será Impresso!")
				DbSkip()
				Loop
			EndIf
		EndIf
		If lAbortPrint
			@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		
		If ConfirmaNF( GWN->GWN_NRROM  ) = .F.
			DbSkip()
			Loop
		endif
		Transp  	:= Posicione("SA4",3,xFilial("SA4") + GWN_CDTRP ,"A4_NOME" )
		cMotor1	    := Posicione("GUU",1,xFilial("GUU") + GWN_CDMTR ,"GUU_NMMTR" )
		cMotor1RG	:= Posicione("GUU",1,xFilial("GUU") + GWN_CDMTR ,"GUU_RG" )
		
		Cabec1  	:= "Romaneio: "  + GWN->GWN_NRROM + "  -  Transportadora: "  + Transp
		Cabec2  	:= "Placa do Veículo: "  + GWN->GWN_PLACAD  + "  Motorista: " + upper(cMotor1) + " RG: " +  cMotor1RG
		cRomanAtu	:= GWN->GWN_NRROM
		zFilialAtu  := GWN->GWN_FILIAL
		nTotal := 0
		nTotVol := 0
		cHRSAI  := GWN->GWN_HRIMPL
		While GWN->GWN_NRROM = cRomanAtu .AND. GWN->GWN_FILIAL = zFilialAtu
			If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 9 
				@nLin, 00 PSAY "N.FISCAL                V  O  L  U  M  E  S                       DT.NF                VLR.NF"
				nLin := nLin + 1 // Avanca a linha de impressao
				@nLin, 00 PSAY REPLICATE ("-",132)
				nLin := nLin + 1 // Avanca a linha de impressao
			Endif
			dbSelectArea("GW1")
			DBSeek( xFilial("GW1") + cRomanAtu )
			While GW1->GW1_NRROM = cRomanAtu .AND. GW1_FILIAL = zFilialAtu .AND. !EOF()

				//         1         2         3         4         5         6         7         8         9         10        11        12        13        14				
				//123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
				//N.FISCAL                V  O  L  U  M  E  S                       DT.NF                VLR.NF"
				//XXXXXXXXX        XXXXXX     XXXXXXXXXXXXXXXXXXXXXXXXX        DD/MM/AAAA        999,999,999.99				
				
				@nLin,000         PSAY GW1->GW1_NRDC
				
				cNF := ALLTRIM(GW1->GW1_NRDC) + SPACE(9 - LEN( ALLTRIM(GW1->GW1_NRDC) ) ) + ALLTRIM(GW1->GW1_SERDC)
				
				nVol1 := Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME1" )
				nVol1 := IIF( nVol1 > 0, STR(nVol1,6,0) , SPACE(06))
				@nLin,018 PSAY nVol1
				@nLin,029 PSAY Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_ESPECI1" )

				@nLin,061 PSAY GW1->GW1_DTEMIS
				@nLin,079 PSAY Posicione("SF2",1,xFilial("GW1") + cNF ,"F2_VALBRUT" )  PICTURE PesqPict("SF2","F2_VALBRUT",TamSX3("F2_VALBRUT")[1])

				nVol2 := Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME2" )
				nVol2 := IIF( nVol2 > 0, STR(nVol2,6,0) , SPACE(06))
				If !Empty(nVol2)
					nLin := nLin + 1
				EndIf
				@nLin,018 PSAY nVol2
				@nLin,029 PSAY Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_ESPECI2" )
				
				nVol3 := Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME3" )
				nVol3 := IIF( nVol3 > 0, STR(nVol3,6,0) , SPACE(06))
				If !Empty(nVol3)
					nLin := nLin + 1
				EndIf				
				@nLin,018 PSAY  nVol3
				@nLin,029 PSAY Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_ESPECI3" )
				
				nVol4 := Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME4" )
				nVol4 := IIF( nVol4 > 0, STR(nVol4,6,0) , SPACE(06))
				If !Empty(nVol4)
					nLin := nLin + 1
				EndIf				
				@nLin,018 PSAY nVol4
				@nLin,029 PSAY Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_ESPECI4" )
				
				nTotVol := nTotVol + Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME1" )
				nTotVol := nTotVol + Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME2" )
				nTotVol := nTotVol + Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME3" )
				nTotVol := nTotVol + Posicione("SF2",1,xFilial("GW1") + cNF  ,"F2_VOLUME4" )
				
				nTotal := nTotal + Posicione("SF2",1,xFilial("GW1") + cNF ,"F2_VALBRUT" )
				
				nLin := nLin + 1 // Avanca a linha de impressao
				
				If nLin > 65 // Salto de Página. Neste caso o formulario tem 55 linhas...
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9
					@nLin, 00 PSAY "N.FISCAL                V  O  L  U  M  E  S                       DT.NF                VLR.NF"
					nLin := nLin + 1 // Avanca a linha de impressao
					@nLin, 00 PSAY REPLICATE ("-",132)
					nLin := nLin + 1 // Avanca a linha de impressao
				Endif
				dbSelectArea("GW1")
				DbSkip()
			Enddo
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,00     PSAY "Total Geral Faturado:.................... " + STR(nTotal,13,2)
			nLin := nLin + 1 // Avanca a linha de impressao
			@nLin,00     PSAY "Total Volumes       :.................... " + STR(nTotVol,13,2)
			nLin := nLin + 3 // Avanca a linha de impressao
			@nLin,00     PSAY "Ass. do Motorista   :_______________________________________ Hora Entrada: " +  cHRSAI + " Hora Saida : ____:____"
			nLin := nLin + 1 // Avanca a linha de impressao
			
			nLin := 80
			
			// Impressão Oficial
			If cTipoImp == 2
				lSitGW1 := GfeVerCmpo({"GW1_SITFT"})
				RecLock("GWN",.F.)
				If !Empty(dDataSaida) .And. !Empty(cHoraSaida)
					GWN->GWN_SIT    := "3"
					GWN->GWN_DTSAI  := Date()
					GWN->GWN_HRSAI  := TIME()
					
					// Preenche a data de saída dos documentos de carga associados ao romaneio.
					dbSelectArea("GW1")
					dbSetOrder(9)
					dbSeek(xFilial("GW1")+GWN->GWN_NRROM)
					While !Eof() .And. xFilial("GW1") + GWN->GWN_NRROM == GW1->GW1_FILIAL + GW1->GW1_NRROM
						
						RecLock("GW1",.F.)
						GW1->GW1_DTSAI  := DATE()
						GW1->GW1_HRSAI  := TIME()
						
						If lSitGW1
							dbSelectArea("GV5")
							dbSetorder(1)
							If (dbSeek(xFilial("GV5")+GW1->GW1_CDTPDC) .AND. GV5->GV5_SENTID == '1') .OR. SuperGetMV('MV_GFEI20',,'2') != '1'
								RecLock('GW1', .F.)
								GW1->GW1_SITFT := "6"
								GW1->( MsUnLock() )
							Else
								RecLock('GW1', .F.)
								GW1->GW1_SITFT := "2"
								GW1->( MsUnLock() )
							EndIf
						EndIf
						MsUnlock("GW1")
						
						dbSelectArea("GW1")
						GW1->( dbSkip() )
					EndDo
					
				Else
					GWN->GWN_SIT    := "2"
					
				EndIf
				MsUnlocK("GWN")
				
				aVinc := {}
				
				AAdd(aVinc, {GWN->GWN_CDMTR , "1"})
				AAdd(aVinc, {GWN->GWN_CDMTR2, "1"})
				AAdd(aVinc, {GWN->GWN_PLACAD, "2"})
				AAdd(aVinc, {GWN->GWN_PLACAM, "2"})
				AAdd(aVinc, {GWN->GWN_PLACAT, "2"})
				
				GFEA050VIN(aVinc, GWN->GWN_CDTRP)
			EndIf
			
			dbSelectArea("GWN")
			dbSkip() // Avanca o ponteiro do registro no arquivo
		EndDO
		
	EndDo
Endif
//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Finaliza a execucao do relatorio...                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

SET DEVICE TO SCREEN

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Se impressao em disco, chama o gerenciador de impressao...          ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()

Return

/****************************/  

Static Function ConfirmaNF(NumRom)

cCond := .F.
dbSelectArea("GW1")
If DBSeek( xFilial("GW1") + NumRom )
	cNF := ALLTRIM(GW1->GW1_NRDC) + SPACE(9 - LEN( ALLTRIM(GW1->GW1_NRDC) ) ) + ALLTRIM(GW1->GW1_SERDC)
	dbSelectArea("SF2")
	If DBSeek(xFilial("SF2") + cNF )
		cCond := .T.
	Endif
Endif
dbSelectArea("GWN")
Return (cCond)
