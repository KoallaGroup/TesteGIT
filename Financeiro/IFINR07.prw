#Include "Rwmake.ch"
#Include "TOPCONN.ch"

/*
+------------+--------+--------+--------------------+-------+------------+
| Programa:  |IFINR07 | Autor: | Rogério Alves      | Data: | Junho/2014 |
+------------+--------+--------+--------------------+-------+------------+
| Descrição: | Relatório de Resumo de Pagamento                          |
+------------+-----------------------------------------------------------+
| Uso:       | Isapa                                                     |
+------------+-----------------------+-----------------------------------+
| Variáveis Utilizadas em Parâmetros |
+----------+-------------------------+
| mv_par01 | Filial De          ?    |
| mv_par02 | Filial Até	        ?    |
| mv_par03 | Banco De           ?    |
| mv_par04 | Banco Até	        ?    |
| mv_par05 | Vencimento De      ?    |
| mv_par06 | Vencimento Até     ?    |
| mv_par07 | Tipo Pagamento De  ?    |
| mv_par08 | Tipo Pagamento Até ?    |
| mv_par09 | Bordero De         ?    |
| mv_par10 | Bordero Até        ?    |
+----------+-------------------------+
*/

User Function IFINR07()

Local Titulo     	:= "Relatório de Resumo de Pagamento"
Local cDesc1     	:= "O objetivo deste relatório é exibir os Borderós"
Local cDesc2     	:= "separados pelo tipo de pagamento"
Local cPict         := " "
Local _nLin         := 100
Local cabec1   		:= "Resumo de pagamentos Indicados - Data "
Local cabec2   		:= "Banco                                  Bord/Che    Tipo de Pagamento                                   Mês             Valor a Pagar"
Local Imprime       := .t.
Local aOrd          := {}

Private lEnd        := .f.
Private lAbortPrint := .f.
Private Limite      := 132
Private Tamanho     := "M"
Private NomeProg    := "IFINR07"
Private aReturn     := {"Zebrado",1,"Administração",2,2,1,"",1}
Private nLastKey    := 0
Private CbTxt       := Space(10)
Private CbCont      := 0
Private ContFl      := 1
Private m_pag       := 1
Private wnrel       := "IFINR07"
Private cString    	:= "SEA"
Private cPerg      	:= "IFINR07"
Private nTipo      	:= 15
Private lOk			:= .F.

cPerg := PADR(cPerg, LEN(SX1->X1_GRUPO))

ValidPerg()

Pergunte(cPerg,.F.)

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,,.F.,,.t.,Tamanho,,.F.)

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

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,_nLin) },Titulo)
Return

Static Function RunReport(Cabec1,Cabec2,Titulo,_nLin)

// +-------------------------+
// | Declaração de Variáveis |
// +-------------------------+

Local cSEA 		:= ""
Local TMPSEA 	:= {}
Local nTotBco	:= 0
Local nTotGeral	:= 0
Local cBco		:= ""
Local cAgen		:= ""
Local cNomBco	:= ""
Local dVenc		:= ""
Local _TMP		:= {}
Local _TMP2		:= {}
Local _aStru1	:= {}
Local _cInd1	:= ""
Local cArqTrab 	:= ""
Local _nDif		:= 0

aTam := TamSX3("E2__DTPAG")
AADD(_aStru1,{"VENC"     ,"C",8,0})
aTam := TamSX3("EA_PORTADO")
AADD(_aStru1,{"BANCO"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("EA_AGEDEP")
AADD(_aStru1,{"AGENCIA"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("EA_NUMBOR")
AADD(_aStru1,{"NUM"     	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("EA_MODELO")
AADD(_aStru1,{"MODELO"    	,aTam[3],aTam[1],aTam[2]})
aTam := TamSX3("E2_VALOR")
AADD(_aStru1,{"VALOR"     	,aTam[3],aTam[1],aTam[2]})

cArqTrab := CriaTrab(_aStru1,.t.)
DbUseArea(.t.,,cArqTrab,"TMPSEA",.t.)
_cInd1 := CriaTrab(Nil,.f.)

cSEA	:= "SELECT DISTINCT E2__DTPAG VENC, EA_PORTADO BANCO,EA_AGEDEP AGENCIA,EA_NUMBOR NUM,EA_MODELO MODELO, SUM(E2_SALDO + E2_ACRESC - E2_DECRESC) VALOR "
cSEA	+= "FROM " + RetSqlName("SEA") + " SEA "
cSEA	+= "INNER JOIN  " + RetSqlName("SE2") + " SE2 ON EA_NUMBOR = E2_NUMBOR AND EA_NUM = E2_NUM AND EA_PARCELA = E2_PARCELA "
cSEA	+= "AND EA_FORNECE = E2_FORNECE AND E2_LOJA = EA_LOJA AND SE2.D_E_L_E_T_ = ' ' "
cSEA	+= "AND SEA.EA_FILORIG = SE2.E2_FILORIG "
cSEA	+= "WHERE SEA.D_E_L_E_T_  = ' ' "
cSEA	+= "AND EA_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
cSEA 	+= "AND E2_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
cSEA 	+= "AND EA_NUMBOR BETWEEN '" + mv_par09 + "' AND '" + mv_par10 + "' "
cSEA 	+= "AND EA_PORTADO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
cSEA	+= "AND E2__DTPAG  BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "
cSEA 	+= "AND EA_MODELO BETWEEN '" + mv_par07 + "' AND '" + mv_par08 + "' "
cSEA 	+= "GROUP BY E2__DTPAG, EA_PORTADO, EA_AGEDEP, EA_NUMBOR, EA_MODELO "
If !(mv_par11 == 2)
	cSEA	+= "UNION ALL "
	cSEA	+= "SELECT EF_DATA VENC,EF_BANCO BANCO,EF_AGENCIA AGENCIA,EF_NUM NUM,'02' MODELO,SUM(EF_VALOR) E2_VALOR "
	cSEA	+= "FROM " + RetSqlName("SEF") + " SEF "
	cSEA	+= "WHERE SEF.D_E_L_E_T_ = ' ' "
	cSEA	+= "AND EF_NUM <> '               ' "
	cSEA	+= "AND EF_TITULO = '         ' "
	cSEA	+= "AND EF_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cSEA 	+= "AND EF_BANCO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cSEA	+= "AND EF_DATA  BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "
	cSEA 	+= "GROUP BY EF_DATA,EF_BANCO,EF_AGENCIA,EF_NUM, '02' "
EndIf
If !(mv_par12 == 2)
	cSEA	+= "UNION ALL "
	cSEA	+= "SELECT E2_VENCREA VENC,E5_BANCO BANCO,'' AGENCIA,'' NUM,'00' MODELO,SUM(E2_VALOR) VALOR "
	cSEA	+= "FROM " + RetSqlName("SE2") + " SE2 "
	cSEA	+= "INNER JOIN  " + RetSqlName("SE5") + " SE5 ON E5_FILORIG = E2_FILIAL AND E5_PREFIXO = E2_PREFIXO AND E5_NUMERO = E2_NUM AND E5_PARCELA = E2_PARCELA "
	cSEA	+= "AND E5_CLIFOR = E2_FORNECE AND E5_LOJA = E2_LOJA AND SE5.D_E_L_E_T_ = ' ' "
	cSEA	+= "WHERE  SE2.D_E_L_E_T_ = ' ' "
	cSEA 	+= "AND E2_FILIAL BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "
	cSEA 	+= "AND E2_TIPO = 'PA' "
	cSEA 	+= "AND E2__TIPBOR = '00' "
	cSEA 	+= "AND E5_BANCO BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "
	cSEA	+= "AND E2_VENCREA  BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "
	cSEA	+= "AND E5_RECPAG = 'P' "
	cSEA	+= "GROUP BY E2_VENCREA,E5_BANCO,'','','00' "
EndIf
cSEA 	+= "ORDER BY VENC, BANCO, AGENCIA, NUM, MODELO "

If Select("_TMP") > 0
	DbSelectArea("_TMP")
	DbCloseArea()
EndIf

TcQuery cSEA New Alias "_TMP"

cSEA	:= ""

dbSelectArea("_TMP")
_TMP->(dbGoTop())

While !Eof("_TMP")
	
	While !RecLock("TMPSEA",.T.)
	Enddo
	TMPSEA->VENC	:= _TMP->VENC
	TMPSEA->BANCO	:= _TMP->BANCO
	TMPSEA->AGENCIA	:= _TMP->AGENCIA
	TMPSEA->NUM 	:= _TMP->NUM
	TMPSEA->MODELO	:= _TMP->MODELO
	TMPSEA->VALOR	:= _TMP->VALOR
	MsUnLock()
	
	DbSelectArea("_TMP")
	DbSkip()
	
EndDo

dbSelectArea("TMPSEA")
TMPSEA->(dbGoTop())


While !Eof("TMPSEA")
	
	If TMPSEA->MODELO != "00"
		
		cSEA	:= "SELECT E5_FILORIG FILORI, E5_PREFIXO PREFIXO, E5_NUMERO NUMERO, E5_PARCELA PARCELA, E5_CLIFOR CLIFOR, E5_LOJA LOJA, SUM(E5_VALOR) VALE5 "
		cSEA	+= "FROM " + RetSqlName("SE5") + " SE5 "
		cSEA	+= "WHERE  SE5.D_E_L_E_T_ = ' ' "
		cSEA	+= "AND E5_BANCO = '" + TMPSEA->BANCO + "' "
		cSEA	+= "AND E5_DTDIGIT = '" + TMPSEA->VENC + "' "
		cSEA	+= "AND E5_DOCUMEN  = '" + TMPSEA->NUM + "' "
		cSEA	+= "AND E5_RECPAG = 'P' "
		cSEA	+= "AND E5_SEQ <> '01' "
		cSEA	+= "AND SE5.D_E_L_E_T_ = ' ' "
		cSEA	+= "GROUP BY E5_FILORIG, E5_PREFIXO , E5_NUMERO , E5_PARCELA , E5_CLIFOR , E5_LOJA "
		
		If Select("_TMP2") > 0
			DbSelectArea("_TMP2")
			DbCloseArea()
		EndIf
		
		TcQuery cSEA New Alias "_TMP2"
		
		If !Empty(_TMP2->VALE5)
			
			_nDif	:= Posicione("SE2",6,PadR(_TMP2->FILORI,TamSx3("E2_FILIAL")[1])+PadR(_TMP2->CLIFOR,TamSx3("E2_FORNECE")[1])+PadR(_TMP2->LOJA,TamSx3("E2_LOJA")[1])+PadR(_TMP2->PREFIXO,TamSx3("E2_PREFIXO")[1])+PadR(_TMP2->NUMERO,TamSx3("E2_NUM")[1])+PadR(_TMP2->PARCELA,TamSx3("E2_PARCELA")[1]),"E2_VALOR")
			_nDif	:= _nDif - _TMP2->VALE5
			
			While !RecLock("TMPSEA",.F.)
			Enddo
			TMPSEA->VALOR := TMPSEA->VALOR - _nDif
			MsUnLock()
			
		EndIf
		
	EndIf
	
	DbSelectArea("TMPSEA")
	DbSkip()
	
EndDo

dbSelectArea("TMPSEA")
TMPSEA->(dbGoTop())

dVenc 	:= TMPSEA->VENC
cBco 	:= TMPSEA->BANCO
cAgen	:= TMPSEA->AGENCIA
cabec1 	:= cabec1 + Transform(STOD(dVenc),"@D")

While TMPSEA->(!Eof())
	
	lOk	:= .T.
	
	If lAbortPrint
		@ _nLin , 000 Psay "*** CANCELADO PELO OPERADOR ***"
		Exit
	EndIf
	
	// +-------------------------------------+
	// | Impressão do Cabeçalho do Relatório |
	// +-------------------------------------+
	
	If _nLin > 75
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		_nLin := 9
		cNomBco	:= TMPSEA->BANCO + " - " + Alltrim(Posicione("SA6",1,xFILIAL("SA6")+TMPSEA->BANCO+TMPSEA->AGENCIA,"A6_NOME"))
		dVenc 	:= TMPSEA->VENC
	EndIf
	
	//          1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23        24
	//0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012   345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890
	//Banco                                  Bord/Che    Tipo de Pagamento                                   Mês              Valor a Pagar
	//XXX - BANCO VOTORANTIM - VINCULADA     XXXXXXX     XX - OP A DISPOSICAO COM AVISO PARA O FAVORECIDO    XXX     999,999,999,999,999.99
	//                                                        Total do Banco: BANCO VOTORANTIM - VINCULADA           999,999,999,999,999.99
	//                                                        Total Geral                                            999,999,999,999,999.99
	
	If !Empty(Alltrim(TMPSEA->BANCO))
		@ _nLin , 000 Psay Alltrim(cNomBco)
	Else
		@ _nLin , 000 Psay "    - BANCO NÃO INFORMADO"
	EndIf
	@ _nLin , 039 Psay TMPSEA->NUM
	If TMPSEA->MODELO == "00"
		@ _nLin , 051 Psay TMPSEA->MODELO + " - " + Alltrim(Posicione("SX5",1,xFILIAL("SX5")+"59"+TMPSEA->MODELO,"X5_DESCRI"))
	Else
		@ _nLin , 051 Psay TMPSEA->MODELO + " - " + Alltrim(Posicione("SX5",1,xFILIAL("SX5")+"58"+TMPSEA->MODELO,"X5_DESCRI"))
	EndIf
	@ _nLin , 103 Psay PegaMes(Month(stod(dVenc)))
	@ _nLin , 110 Psay TMPSEA->VALOR 		Picture "@E 999,999,999,999,999.99"
	_nLin := _nLin + 1
	
	nTotBco		:= nTotBco + TMPSEA->VALOR
	nTotGeral	:= nTotGeral + TMPSEA->VALOR
	
	DbSelectArea("TMPSEA")
	DbSkip()
	
	If cBco != TMPSEA->BANCO .or. dVenc != TMPSEA->VENC
		
		cNomBco	:= Posicione("SA6",1,xFILIAL("SA6")+cBco+cAgen,"A6_NOME")
		_nLin := _nLin + 1
		@ _nLin , 056 Psay "Total do Banco: " + Alltrim(cNomBco)
		@ _nLin , 110 Psay nTotBco 			Picture "@E 999,999,999,999,999.99"
		_nLin := _nLin + 1
		@ _nLin , 000 Psay Replicate('_',limite)
		_nLin := _nLin + 2
		nTotBco := 0
		cBco 	:= TMPSEA->BANCO
		cAgen	:= TMPSEA->AGENCIA
		cNomBco	:= TMPSEA->BANCO + " - " + Alltrim(Posicione("SA6",1,xFILIAL("SA6")+TMPSEA->BANCO+TMPSEA->AGENCIA,"A6_NOME"))
		cabec1 	:= Substr(cabec1,1,38) + Transform(STOD(TMPSEA->VENC),"@D")
		
	Else
		cNomBco	:= ""
	EndIf
	
	If _nLin >= 65 .or. !TMPSEA->(!Eof()) .or. dVenc != TMPSEA->VENC
		If dVenc != TMPSEA->VENC
			@ _nLin , 056 Psay "TOTAL "
			@ _nLin , 110 Psay nTotGeral 			Picture "@E 999,999,999,999,999.99"
			nTotGeral := 0
		EndIf
		
		@ 070 , 020 Psay "----------------------------                                      ----------------------------"
		@ 071 , 020 Psay "      Conferência                                                          Aprovação"
		_nLin := 100
		dVenc := TMPSEA->VENC
	EndIf
	
ENDDO

If !lOk
	Cabec(Titulo,"*** NÃO HÁ DADOS PARA IMPRESSÃO ***","*** NÃO HÁ DADOS PARA IMPRESSÃO ***",NomeProg,Tamanho,nTipo)
EndIf

If Select("TMPSEA") > 0
	DbSelectArea("TMPSEA")
	DbCloseArea()
EndIf

If Select("_TMP2") > 0
	DbSelectArea("_TMP2")
	DbCloseArea()
EndIf

If Select("_TMP") > 0
	DbSelectArea("_TMP")
	DbCloseArea()
EndIf

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

/*
+---------+-----------+
| Funcao: | ValidPerg |
+---------+-----------+
*/

Static Function ValidPerg

DbSelectArea("SX1")
DbSetOrder(1)

If !DbSeek(cPerg + "01",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Filial De          ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_GSC     := "G"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par01"
	SX1->X1_F3     	:= "SM0"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "02",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "02"
	SX1->X1_PERGUNT := "Filial Até	       ?"
	SX1->X1_VARIAVL := "mv_ch2"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 02
	SX1->X1_GSC     := "G"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par02"
	SX1->X1_F3     	:= "SM0"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "03",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "03"
	SX1->X1_PERGUNT := "Banco De           ?"
	SX1->X1_VARIAVL := "mv_ch3"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 03
	SX1->X1_GSC     := "G"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par03"
	SX1->X1_F3     	:= "SA6BCO"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "04",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "04"
	SX1->X1_PERGUNT := "Banco Até          ?"
	SX1->X1_VARIAVL := "mv_ch4"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 03
	SX1->X1_GSC     := "G"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par04"
	SX1->X1_F3     	:= "SA6BCO"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "05",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "05"
	SX1->X1_PERGUNT := "Vencimento De      ?"
	SX1->X1_VARIAVL := "mv_ch5"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par05"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "06",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "06"
	SX1->X1_PERGUNT := "Vencimento Até     ?"
	SX1->X1_VARIAVL := "mv_ch6"
	SX1->X1_TIPO    := "D"
	SX1->X1_TAMANHO := 8
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par06"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "07",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "07"
	SX1->X1_PERGUNT := "Tipo Pagamento De  ?"
	SX1->X1_VARIAVL := "mv_ch7"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_F3     	:= "58"
	SX1->X1_VAR01   := "mv_par07"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "08",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "08"
	SX1->X1_PERGUNT := "Tipo Pagamento Até ?"
	SX1->X1_VARIAVL := "mv_ch8"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_F3     	:= "58"
	SX1->X1_VAR01   := "mv_par08"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "09",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "09"
	SX1->X1_PERGUNT := "Bordero De         ?"
	SX1->X1_VARIAVL := "mv_ch9"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_GSC     := "G"
	SX1->X1_F3     	:= ""
	SX1->X1_VAR01   := "mv_par09"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "10",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "10"
	SX1->X1_PERGUNT := "Bordero Até        ?"
	SX1->X1_VARIAVL := "mv_chA"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 6
	SX1->X1_GSC     := "G"
	SX1->X1_F3     	:= ""
	SX1->X1_VAR01   := "mv_par10"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "11",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "11"
	SX1->X1_PERGUNT := "Imprime Cheque     ?"
	SX1->X1_VARIAVL := "mv_chB"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 01
	SX1->X1_GSC     := "C"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par11"
	SX1->X1_DEF01	:= "SIM"
	SX1->X1_DEF02	:= "NÃO"
	MsUnLock()
	
EndIf

If !DbSeek(cPerg + "12",.f.)
	
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "12"
	SX1->X1_PERGUNT := "Imp. Déb. de Imp.  ?"
	SX1->X1_VARIAVL := "mv_chC"
	SX1->X1_TIPO    := "N"
	SX1->X1_TAMANHO := 01
	SX1->X1_GSC     := "C"
	SX1->X1_PRESEL  := 1
	SX1->X1_VAR01   := "mv_par12"
	SX1->X1_DEF01	:= "SIM"
	SX1->X1_DEF02	:= "NÃO"
	MsUnLock()
	
EndIf

Return

STATIC FUNCTION PegaMes(MesVenc)

Local cMes := ""

Do Case
	Case MesVenc == 1
		cMes	:= "JAN"
	Case MesVenc == 2
		cMes	:= "FEV"
	Case MesVenc == 3
		cMes	:= "MAR"
	Case MesVenc == 4
		cMes	:= "ABR"
	Case MesVenc == 5
		cMes	:= "MAI"
	Case MesVenc == 6
		cMes	:= "JUN"
	Case MesVenc == 7
		cMes	:= "JUL"
	Case MesVenc == 8
		cMes	:= "AGO"
	Case MesVenc == 9
		cMes	:= "SET"
	Case MesVenc == 10
		cMes	:= "OUT"
	Case MesVenc == 11
		cMes	:= "NOV"
	Case MesVenc == 12
		cMes	:= "DEZ"
EndCase

Return cMes
