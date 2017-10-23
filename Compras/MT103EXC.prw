#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103EXC	 		  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada executado na validação	da exclusao da nota de entrada			|
|-----------------------------------------------------------------------------------------------|	
|	Uso: Usado para reprocessar livro fiscal antes da exclusão									|
|-----------------------------------------------------------------------------------------------|	
*/

User Function MT103EXC()  
Local _aArea	:= GetArea()

/* Comentado trecho abaixo para localização de outro ponto de entrada
If(SF1->F1_FORMUL == 'S')
	MsAguarde({|| RepNota()}, "Reprocessando Notas")                 
EndIf
*/

RestArea(_aArea)

Return .T.

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MT103EXC	 		  		| 	Junho de 2015					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada executado na validação	da exclusao da nota de entrada			|
|-----------------------------------------------------------------------------------------------|	
|	Uso: Usado para reprocessar livro fiscal antes da exclusão									|
|-----------------------------------------------------------------------------------------------|	
*/

Static Function RepNota()      

Local aPergA930 := {} 

	aPergA930 := {}	
	aadd(aPergA930, dtoc(SF1->F1_DTDIGIT))
	aadd(aPergA930, dtoc(SF1->F1_DTDIGIT))
	aadd(aPergA930, 1)
	aadd(aPergA930, SF1->F1_DOC)
	aadd(aPergA930, SF1->F1_DOC)
	aadd(aPergA930, SF1->F1_SERIE)
	aadd(aPergA930, SF1->F1_SERIE)
	aadd(aPergA930, SF1->F1_FORNECE)
	aadd(aPergA930, SF1->F1_FORNECE)
	aadd(aPergA930, SF1->F1_LOJA)
	aadd(aPergA930, SF1->F1_LOJA)
/*	
    aadd(aPergA930, SF1->F1_FILIAL)
    aadd(aPergA930, SF1->F1_FILIAL)
    aadd(aPergA930, 1)	
	aadd(aPergA930, 2)
*/	
	Pergunte("MTA930",.F.)
		
	mv_par01 := SF1->F1_DTDIGIT
	mv_par02 := SF1->F1_DTDIGIT
	mv_par03 := 1
	mv_par04 := SF1->F1_DOC
	mv_par05 := SF1->F1_DOC
	mv_par06 := SF1->F1_SERIE
	mv_par07 := SF1->F1_SERIE
	mv_par08 := SF1->F1_FORNECE
	mv_par09 := SF1->F1_FORNECE
	mv_par10 := SF1->F1_LOJA
	mv_par11 := SF1->F1_LOJA
	mv_par12 := SF1->F1_FILIAL
	mv_par13 := SF1->F1_FILIAL
	mv_par14 := 2
	mv_par15 := 2          

	dbSelectArea("SX1")
	dbSetOrder(1)
	if dbSeek("MTA930    ")
		do while alltrim(SX1->X1_GRUPO) == 'MTA930'
			reclock("SX1", .F.)
			if SX1->X1_ORDEM == "01"
				SX1->X1_CNT01 := DTOS(mv_par01)
			elseif SX1->X1_ORDEM == "02"
				SX1->X1_CNT01 := DTOS(mv_par02)
			elseif SX1->X1_ORDEM == "03"
				SX1->X1_PRESEL := mv_par03
			elseif SX1->X1_ORDEM == "04"
				SX1->X1_CNT01 := mv_par04
			elseif SX1->X1_ORDEM == "05"
				SX1->X1_CNT01 := mv_par05
			elseif SX1->X1_ORDEM == "06"
				SX1->X1_CNT01 := mv_par06
			elseif SX1->X1_ORDEM == "07"
				SX1->X1_CNT01 := mv_par07
			elseif SX1->X1_ORDEM == "08"
				SX1->X1_CNT01 := mv_par08
			elseif SX1->X1_ORDEM == "09"
				SX1->X1_CNT01 := mv_par09
			elseif SX1->X1_ORDEM == "10"
				SX1->X1_CNT01 := mv_par10
			elseif SX1->X1_ORDEM == "11"
				SX1->X1_CNT01 := mv_par11
			elseif SX1->X1_ORDEM == "12"
				SX1->X1_CNT01 := mv_par12
			elseif SX1->X1_ORDEM == "13"
				SX1->X1_CNT01 := mv_par13
			elseif SX1->X1_ORDEM == "14"
				SX1->X1_PRESEL := mv_par14			
			elseif SX1->X1_ORDEM == "15"
				SX1->X1_PRESEL := mv_par15			
			endif		
			MsUnlock()
			
			SX1->(dbSkip())
		enddo
	endif

	_aSF1A := SF1->(GetArea())

	MATA930(.F., aPergA930)

	RestArea(_aSF1A)
	cFilAnt := SF1->F1_FILIAL //Em algumas situações estava trocando a filial do cFilAnt

Return 