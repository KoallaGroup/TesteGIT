#Include "RWMAKE.CH"
#Include "TOPCONN.CH"
#Include "Protheus.Ch"
#include "TbiConn.ch"
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³PN80GRBH  º Autor ³ Mateus Hengle      º Data ³  12/07/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³Ponto de entrada que customiza os valores do Banco de horas º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ 															  º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
User Function PN80GRBH()

Local aSaveArea := GetArea()
Local cEveProv 	:= Paramixb[1] 		//Evento de Provento do Banco de Horas
Local cEveDesc 	:= Paramixb[2]		//Evento de Desconto do Banco de Horas
Local aSPI 		:= Paramixb[3]		//Array com os Valores do Banco de Horas
Local aDelSPI 	:= Paramixb[4]		//Array com os Registros a serem Baixados
Local dDataGrv  := Paramixb[5]		//Data Para a Gravacao dos Valores nos Resultados
Local cEveResc 	:= Paramixb[6]		//Evento de Base para total de meses do B.Horass
Local cResult   := 0
Local nCont     := 1

cMat := SRA->RA_MAT

cHoras1 := 0
cHoras2 := 0 

IF Len(aSPI) == 2
	
	cQry := " SELECT * "
	cQry += " FROM "+RetSQLName("SPB")+ " SPB "
	cQry += " WHERE PB_MAT = '"+cMat+"' "
	cQry += " AND SPB.D_E_L_E_T_='' "
	cQry += " ORDER BY PB_PD "
	
	If Select("TRC") > 0
		TRC->(dbCloseArea())
	EndIf
	
	dbUseArea(.T., "TOPCONN", TCGenQry(,,cQry), "TRC", .F., .T.)
	DbSelectArea("TRC")
	TRC->(DbGotop())
	
	WHILE TRC->(!EOF())
		
		IF nCont == 1
			
			// PB_PD = 209 - PROVENTO - 701
			cFil1  := TRC->PB_FILIAL
			cMat1  := TRC->PB_MAT
			cEven1 := TRC->PB_PD
			cTip11 := TRC->PB_TIPO1
			cHoras1:= TRC->PB_HORAS
			cVal1  := TRC->PB_VALOR
			dData1 := TRC->PB_DATA
			cSem1  := TRC->PB_SEMANA
			cCC1   := TRC->PB_CC
			cParc1 := TRC->PB_PARCELA
			cTip2  := TRC->PB_TIPO2
			cProc1 := TRC->PB_PROCES
			
		ELSEIF nCont == 2
			
			// PB_PD = 432 - DESCONTO - 702
			cFil2  := TRC->PB_FILIAL
			cMat2  := TRC->PB_MAT
			cEven2 := TRC->PB_PD
			cTip12 := TRC->PB_TIPO1
			cHoras2:= TRC->PB_HORAS
			cVal2  := TRC->PB_VALOR
			dData2 := TRC->PB_DATA
			cSem2  := TRC->PB_SEMANA
			cCC2   := TRC->PB_CC
			cParc2 := TRC->PB_PARCELA
			cTip22 := TRC->PB_TIPO2
			cProc2 := TRC->PB_PROCES
		ENDIF
		
		nCont++
		
		TRC->(dbSkip())
	ENDDO
	
	cDel := " DELETE FROM " + RetSQLName("SPB") "
	cDel += " WHERE PB_MAT = '"+cMat+"' "
	TcSqlExec(cDel)
	
	IF cHoras1 < cHoras2 				// PROVENTOS MENOR QUE DESCONTOS
		
		cResult := cHoras2 - cHoras1    // DESCONTOS - PROVENTOS
		
		DBSELECTAREA("SPB")
		RecLock("SPB",.T.)
		SPB->PB_FILIAL := cFil2
		SPB->PB_MAT    := cMat2
		SPB->PB_PD	   := cEven2
		SPB->PB_TIPO1  := cTip12
		SPB->PB_HORAS  := cResult
		SPB->PB_VALOR  := cVal2
		SPB->PB_DATA   := STOD(dData2)
		SPB->PB_SEMANA := cSem2
		SPB->PB_CC     := cCC2
		SPB->PB_PARCELA:= cParc2
		SPB->PB_TIPO2  := cTip22
		SPB->PB_PROCES := cProc2
		SPB->(MsUnLock())
		
	ELSEIF cHoras1 > cHoras2     		// PROVENTOS MAIOR QUE DESCONTOS
		
		cResult := cHoras1 - cHoras2   // PROVENTOS - DESCONTOS
		
		DBSELECTAREA("SPB")
		RecLock("SPB",.T.)
		SPB->PB_FILIAL := cFil1
		SPB->PB_MAT    := cMat1
		SPB->PB_PD	   := cEven1
		SPB->PB_TIPO1  := cTip11
		SPB->PB_HORAS  := cResult
		SPB->PB_VALOR  := cVal1
		SPB->PB_DATA   := STOD(dData1)
		SPB->PB_SEMANA := cSem1
		SPB->PB_CC     := cCC1
		SPB->PB_PARCELA:= cParc1
		SPB->PB_TIPO2  := cTip2
		SPB->PB_PROCES := cProc1
		SPB->(MsUnLock())
		
	ENDIF

ELSEIF Len(aSPI) == 0

	ALERT("Nao existem lancamentos!")
	
ELSEIF Len(aSPI) == 1

	ALERT("So existe um lancamento para essa matricula!")	
	
ENDIF

Alert("Ponto de entrada")

Return
