#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"

User Function JOBM330()
	Local lCPParte := .F. //-- Define que não será processado o custo em partes
	Local lBat := .T. //-- Define que a rotina será executada em Batch
	Local aListaFil := {} //-- Carrega Lista com as Filiais a serem processadas
	Local cCodFil := '' //-- Código da Filial a ser processada
	Local cNomFil := '' //-- Nome da Filial a ser processada
	Local cCGC := '' //-- CGC da filial a ser processada
	Local aParAuto := {} //-- Carrega a lista com os 21 parâmetros   
	
	PREPARE ENVIRONMENT EMPRESA "01" FILIAL "03" MODULO "EST" USER 'admin' PASSWORD 'anadi2013' TABLES "AF9","SB1","SB2","SB3","SB8","SB9","SBD","SBF","SBJ","SBK","SC2","SC5","SC6","SD1","SD2","SD3","SD4","SD5","SD8","SDB","SDC","SF1","SF2","SF4","SF5","SG1","SI1","SI2","SI3","SI5","SI6","SI7","SM2","ZAX","SAH","SM0","STL"
	Conout("Início da execução do JOBM330")
	
	//-- Adiciona filial a ser processada
	dbSelectArea("SM0")
	dbSeek(cEmpAnt)
	Do While ! Eof() .And. SM0->M0_CODIGO == cEmpAnt
		cCodFil := SM0->M0_CODFIL
		cNomFil := SM0->M0_FILIAL
		cCGC := SM0->M0_CGC

		If cCodFil $ "01/03/04/05/06"
			//-- Adiciona a filial na lista de filiais a serem processadas
			Aadd(aListaFil,{.T.,cCodFil,cNomFil,cCGC,.F.,})
		EndIf
		dbSkip()
	EndDo

	dbSelectArea("SX1")
	dbSetOrder(1)
	if dbSeek("MTA330    " + "01")
		reclock("SX1", .F.)
		SX1->X1_CNT01 := dtos(date())
		msUnlock()
	endif
	   
	for x:=1 to len(aListaFil)	

		cFilAnt := aListaFil[x][2]

		_aFilial := array(1,5)
		_aFilial[1][1] := aListaFil[x][1]
		_aFilial[1][2] := aListaFil[x][2]
		_aFilial[1][3] := aListaFil[x][3]
		_aFilial[1][4] := aListaFil[x][4]
		_aFilial[1][5] := aListaFil[x][5]
	
		//-- Executa a rotina de recálculo do custo médio
  		MATA330(lBat,_aFilial,lCPParte, aParAuto)

	next x
	
	ConOut("Término da execução do JOBM330")
Return