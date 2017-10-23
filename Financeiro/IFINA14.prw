#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
#INCLUDE "COLORS.CH"
#INCLUDE "RPTDEF.CH"
#INCLUDE "FWPrintSetup.ch"
#Include "ParmType.ch"
#include "TbiConn.ch"
#include "TbiCode.ch"

/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | IFINA14 | Autor | Rubens Cruz	- Anadi Soluções   	 | Data | Fevereiro/2015 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Rotina para geracao de bordero para titulos em carteira					     |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
*/

User Function IFINA14()
Local _aStru 	:= {050,110,140,170}
Local _aStru2	:= {{015,055},;
					{115,170},;
					{230,270}}
Local _nLinha	:= _nLinAux := _nLin2 := 80 
Local cCliNP1	:= ""
Local cCliNP2	:= ""
Local aEdit		:= {}
Local aHeaderB	:= {}
Local aColsB	:= {}
Local nAlt		:= 0
Local nLarg		:= 0 

Private oDlgSA6
Private oGetTM1
Private oOcor, oCliP1, oCliP2, oProt, oDesOco, oDesP1, oDesP2, oDesCob

Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
Private dEmiDe		:= dDataBase - 7
Private dEmiAte		:= dDataBase - 7
Private dVencDe		:= dDataBase + 7
Private dVencAte	:= CTOD("31/12/" + Alltrim(Str(Year(date()) + 50)))
Private cTitDe		:= Space(TAMSX3("E1_NUM")[1])
Private nProt		:= 0
Private cOcor		:= Space(2)
Private cDesOco		:= ""
Private cCliP1		:= ""
Private cCliP2		:= ""
Private cDesP1		:= ""
Private cDesP2		:= ""
Private cTpCob		:= Space(1)
Private cDesCob		:= ""
Private cTitAte		:= Replicate("Z",TAMSX3("E1_NUM")[1])
                
aHeaderB := CriaHeader({"A6_COD","A6_NREDUZ","A6_AGENCIA","A6_NUMCON","A6__PRIORI","A6__PERC"},1)
aColsB	 := CriaCols(aHeaderB,1)

	DEFINE MSDIALOG oDlgSA6 TITLE "Geração de Remessa Bancária" From 000,000 To 450,680 OF oMainWnd PIXEL
	nAlt  := (oDlgSA6:nClientHeight / 2) - 031
	nLarg := (oDlgSA6:nClientWidth  / 2) - 010

	oGetTM1 := MsNewGetDados():New(010,010,_nLinha-5,nLarg-3, 0, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgSA6, aHeaderB, aColsB)
	oGetTM1:bChange  := {|| AtuBco() }

	_nLinha += 14
    _nLin2  += 28
    
	@ _nLinha,_aStru2[1][1] Say "Emissão De"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru2[1][2] MSGet dEmiDe	  			SIZE 055,010 of oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[1][1] Say "Emissão Ate"           SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[1][2] MSGet dEmiAte               SIZE 055,010 of oDlgSA6 PIXEL FONT oFont

	@ _nLinha,_aStru2[2][1] Say "Vencimento De"   		SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru2[2][2] MSGet dVencDe	  			SIZE 055,010 of oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[2][1] Say "Vencimento Ate"        SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[2][2] MSGet dVencAte              SIZE 055,010 of oDlgSA6 PIXEL FONT oFont

	@ _nLinha,_aStru2[3][1] Say "Título De"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru2[3][2] MSGet cTitDe	  			SIZE 040,010 of oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[3][1] Say "Título Ate"            SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
    @ _nLin2 ,_aStru2[3][2] MSGet cTitAte               SIZE 040,010 of oDlgSA6 PIXEL FONT oFont
	_nLinha += 34
 
	@ _nLinha,_aStru[1] Say "Dias para Protesto"		SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] MSGet oProt VAR nProt			SIZE 020,010 of oDlgSA6 PIXEL FONT oFont WHEN .F. PICTURE "@E 999"
	_nLinha += 14

	@ _nLinha,_aStru[1] Say "Tipo de Cobrança"	   		SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] MSGet cTpCob	  				SIZE 020,010 of oDlgSA6 PIXEL FONT oFont F3 "07D" VALID ValCob() PICTURE "@!"
	@ _nLinha,_aStru[3] MSGet oDesCob VAR cDesCob  		SIZE 140,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14

	@ _nLinha,_aStru[1] Say "Ocorrencia"		   		SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] MSGet oOcor VAR cOcor	  		SIZE 020,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	@ _nLinha,_aStru[3] MSGet oDesOco VAR cDesOco  		SIZE 140,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14
	
	@ _nLinha,_aStru[1] Say "Instrução 1"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] MSGet oCliP1 VAR cCliP1	  		SIZE 020,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	@ _nLinha,_aStru[3] MSGet oDesP1 VAR cDesP1  		SIZE 140,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 14

	@ _nLinha,_aStru[1] Say "Instrução 2"   			SIZE 080,010 OF oDlgSA6 PIXEL FONT oFont 
	@ _nLinha,_aStru[2] MSGet oCliP2 VAR cCliP2	  		SIZE 020,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	@ _nLinha,_aStru[3] MSGet oDesP2 VAR cDesP2  		SIZE 140,010 of oDlgSA6 PIXEL FONT oFont WHEN .F.
	_nLinha += 16
	
    @ _nLinAux,006 TO _nLinha, nLarg PROMPT "Seleção" OF oDlgSA6 COLOR 0, 16777215 PIXEL

	@ nAlt,nLarg-150 Button oButton PROMPT "Processar"  SIZE 040,012   OF oDlgSA6 PIXEL ACTION MsAguarde({|| GerBorde() }, "Processando","Gerando o(s) borderô(s)")
	@ nAlt,nLarg-100 Button oButton PROMPT "Consultar"  SIZE 040,012   OF oDlgSA6 PIXEL ACTION Processa({|| IFINA14A() } , "Processando","Filtrando o(s) borderô(s)")
	@ nAlt,nLarg-050 Button oButton PROMPT "Fechar"  	SIZE 040,012   OF oDlgSA6 PIXEL ACTION oDlgSA6:End()   
		
	ACTIVATE MSDIALOG oDlgSA6 CENTERED                                                                                
	
Return                       

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | IFINA14A | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Rotina para geracao do CNAB para titulos em carteira					     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function IFINA14A()
Local _aStru 	:= {050,105,210,250}
Local cOcor		:= ""
Local cCliP1	:= ""
Local cCliP2	:= ""
Local cCliNP1	:= ""
Local cCliNP2	:= ""
Local aEdit		:= {}
Local aHeaderB	:= {}
Local aColsB	:= {}
Local nProt		:= 0
Local nAlt		:= 0
Local nLarg		:= 0 

Private oDlgTM1
Private oGetTM2
Private oFont 		:= tFont():New("Tahoma",,-12,,.t.)
Private nTotCont  	:= 0 
Private nTotVal   	:= 0 
                
aHeaderB := CriaHeader({"EA_PORTADO","A6_AGENCIA","A6_NUMCON","A6_NREDUZ","EA_NUMBOR","E1_SALDO","E1_VALOR","EA_DATABOR","EA__CNAB"},2)
aColsB	 := CriaCols(aHeaderB,2)

	DEFINE MSDIALOG oDlgTM1 TITLE "Consulta de Borderos Gerados" From 000,000 To 430,850 OF oMainWnd PIXEL
	nAlt  := (oDlgTM1:nClientHeight / 2) - 031
	nLarg := (oDlgTM1:nClientWidth  / 2) - 010

	oGetTM2 := MsNewGetDados():New(005,005,nAlt-25,nLarg+2, 0, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTM1, aHeaderB, aColsB)

	@ nAlt-20,_aStru[1] Say "Total De Títulos:" 		SIZE 060,010 OF oDlgTM1 PIXEL FONT oFont 
	@ nAlt-22,_aStru[2] Get nTotCont  					SIZE 070,010 of oDlgTM1 PIXEL FONT oFont WHEN .F. PICTURE "@E 999,999,999"
	@ nAlt-20,_aStru[3] Say "Valor Total:"	 			SIZE 060,010 OF oDlgTM1 PIXEL FONT oFont 
	@ nAlt-22,_aStru[4] Get nTotVal  					SIZE 070,010 of oDlgTM1 PIXEL FONT oFont WHEN .F. PICTURE PesqPict("SE1","E1_VALOR")

	@ nAlt,015 		 Button oButton PROMPT "Imprimir"  	SIZE 040,012 OF oDlgTM1 PIXEL ACTION (ImpBord())
	@ nAlt,nLarg-150 Button oButton PROMPT "Gerar" 		SIZE 040,012 OF oDlgTM1 PIXEL ACTION (GeraCNAB())
	@ nAlt,nLarg-100 Button oButton PROMPT "Cancelar"	SIZE 040,012 OF oDlgTM1 PIXEL ACTION (CancBord())
	@ nAlt,nLarg-050 Button oButton PROMPT "Fechar"  	SIZE 040,012 OF oDlgTM1 PIXEL ACTION (oDlgTM1:End())   
		
	ACTIVATE MSDIALOG oDlgTM1 CENTERED                                                                                
	
Return                       

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | GerBorde | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Cria bordero dos titulos selecionados								     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/ 

Static Function GerBorde()
Local nEaPort 		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_COD" 		})
Local nEaAgen 		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_AGENCIA" 	})
Local nEaCon	 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_NUMCON" 	})
Local nA6Perc 		:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6__PERC" 	}) 
Local _nCont		:= 0
Local _aTitBanc		:= {}
Local _cQuery		:= "" 
Local cNumBor 		:= "" 
Local cNomeBanco 	:= "" 
Local cSepNeg   	:= If("|"$MV_CRNEG,"|",","), cSepProv  := If("|"$MVPROVIS,"|",","), cSepRec := If("|"$MVRECANT,"|",",")
Local _cInstr1		:= ""
Local _cInstr2		:= ""
Local aArea 		:= GetArea()
Local _nQtdTit		:= 0

If !MsgYesNo("Confirma geração dos borderôs, de acordo com os parametros informados?","ATENÇÃO")
    Return
EndIf

If Empty(cTpCob)
	Alert("Tipo de cobrança não informado")
	Return
EndIf

If(select("TRBSE1") > 0)
	TRBSE1->(DbCloseArea())
EndIf                     

_cQuery := "SELECT COUNT(*) AS CONTADOR                                                				" + Chr(13)
_cQuery += "FROM " + RetSqlName("SE1") + " SE1                                      				" + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SE1.E1_CLIENTE = SA1.A1_COD 				" + Chr(13)
_cQuery += "                         AND SE1.E1_LOJA = SA1.A1_LOJA                  				" + Chr(13)
_cQuery += "                         AND SA1.D_E_L_E_T_ = ' '                       				" + Chr(13)
_cQuery += "WHERE SE1.D_E_L_E_T_ = ' '                                              				" + Chr(13)
_cQuery += "      AND SA1.A1_BCO1    = ' '                                          				" + Chr(13)
_cQuery += "      AND SA1.A1__AGCLIE = ' '                                          				" + Chr(13)
_cQuery += "      AND SA1.A1__CCCLIE = ' '                                          				" + Chr(13)
_cQuery += "      AND SA1.A1__REMESS <> 'N'                                          				" + Chr(13) //ADD POR RAFAEL DOMINGUES EM 14/05
_cQuery += "      AND SE1.E1_VENCREA BETWEEN '" + DTOS(dVencDe) + "' AND '" + DTOS(dVencAte) + "' 	" + Chr(13)
_cQuery += "      AND SE1.E1_EMISSAO BETWEEN '" + DTOS(dEmiDe) + "' AND '" + DTOS(dEmiAte) + "'     " + Chr(13)
_cQuery += "      AND SE1.E1_NUM BETWEEN '" + cTitDe + "' AND '" + cTitAte + "'              		" + Chr(13)
_cQuery += "      AND SE1.E1_SALDO > 0                                              				" + Chr(13)
_cQuery += "      AND SE1.E1_NUMBOR  = ' ' And SE1.E1_NUMBCO = ' ' And SE1.E1_IDCNAB = ' ' 			" + Chr(13)
_cQuery += "      AND SE1.E1_BAIXA   = ' '                                          				" + Chr(13)
_cQuery += "      AND SE1.E1_SITUACA IN ('0','F','G')                               				" + Chr(13)
_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " 							" + Chr(13)                   
_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " 						" + Chr(13)
_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " 						" + Chr(13)
_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " 						"
TcQuery _cQuery New Alias "TRBSE1"

_nCont := TRBSE1->CONTADOR

TRBSE1->(DbCloseArea())

If(_nCont > 0)

	//Conta quantos titulos serão enviados para cada banco
	For nX := 1 To Len(oGetTM1:aCols)
    	AADD(_aTitBanc,INT(oGetTM1:aCols[nX][nA6Perc] * _nCont / 100))
    	_nQtdTit := _nQtdTit + _aTitBanc[nX]
	Next nX  

	If 	_nCont <> _nQtdTit
		_aTitBanc[1] := _aTitBanc[1] + (_nCont - _nQtdTit)
	EndIf
	
	_cQuery := "SELECT E1_FILIAL, E1_PREFIXO, E1_NUM, E1_PARCELA, E1_TIPO, A1_BCO1, A1__AGCLIE, A1__CCCLIE " + Chr(13)
	_cQuery += "FROM " + RetSqlName("SE1") + " SE1                                      				  " + Chr(13)
	_cQuery += "INNER JOIN " + RetSqlName("SA1") + " SA1 ON SE1.E1_CLIENTE = SA1.A1_COD 				  " + Chr(13)
	_cQuery += "                         AND SE1.E1_LOJA = SA1.A1_LOJA                  				  " + Chr(13)
	_cQuery += "                         AND SA1.D_E_L_E_T_ = ' '                       				  " + Chr(13)
	_cQuery += "WHERE SE1.D_E_L_E_T_ = ' '                                              				  " + Chr(13)
	_cQuery += "      AND SA1.A1_BCO1    = ' '                                          				  " + Chr(13)
	_cQuery += "      AND SA1.A1__AGCLIE = ' '                                          				  " + Chr(13)
	_cQuery += "      AND SA1.A1__REMESS <> 'N'                                          				  " + Chr(13) //ADD POR Rogerio EM 15/05	
	_cQuery += "      AND SA1.A1__CCCLIE = ' '                                          				  " + Chr(13)
	_cQuery += "      AND SE1.E1_VENCREA BETWEEN '" + DTOS(dVencDe) + "' AND '" + DTOS(dVencAte) + "' 	  " + Chr(13)
	_cQuery += "      AND SE1.E1_EMISSAO BETWEEN '" + DTOS(dEmiDe) + "' AND '" + DTOS(dEmiAte) + "'       " + Chr(13)
	_cQuery += "      AND SE1.E1_NUM BETWEEN '" + cTitDe + "' AND '" + cTitAte + "'              		  " + Chr(13)
	_cQuery += "      AND SE1.E1_SALDO > 0                                              				  " + Chr(13)
	_cQuery += "      AND SE1.E1_NUMBOR  = ' ' And SE1.E1_NUMBCO = ' ' And SE1.E1_IDCNAB = ' '            " + Chr(13)
	_cQuery += "      AND SE1.E1_BAIXA   = ' '                                          				  " + Chr(13)
	_cQuery += "      AND SE1.E1_SITUACA IN ('0','F','G')                               				  " + Chr(13)
	_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVABATIM,"|") + " 							  " + Chr(13)                   
	_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MV_CRNEG,cSepNeg)  + " 						  " + Chr(13)
	_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVPROVIS,cSepProv) + " 						  " + Chr(13)
	_cQuery += " 	  AND SE1.E1_TIPO NOT IN " + FormatIn(MVRECANT,cSepRec)  + " 						  "
	TcQuery _cQuery New Alias "TRBSE1"
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Vai pegar o ultimo N£mero de bordero utilizado 				  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
	cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
	While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
		// busca o proximo numero disponivel 
		cNumBor := Soma1(cNumBor)
	EndDo    

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
	//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	cProxNum := cNumBor
	Do While !FA060Num( cProxNum, .F. )
		cNumBor  := cProxNum
		cProxNum := Soma1( cNumBor )
	EndDo                                      

	DbSelectArea("SA6")
	DbSetOrder(1)
	DbSeek(xFilial("SA6")+oGetTM1:aCols[1][nEaPort]+oGetTM1:aCols[1][nEaAgen]+oGetTM1:aCols[1][nEaCon])

	DbSelectArea("Z27")
	DbSetOrder(2)
	If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTPR)
		_cInstr1 := Z27->Z27_INSBCO
    Else
      	alert("Instrucao bancária não localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
       	Return
    EndIf

	DbSelectArea("Z27")
	DbSetOrder(2)
	If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTSE)
		_cInstr2 := Z27->Z27_INSBCO
    Else
       	alert("Instrucao bancária não localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
       	Return
    EndIf

	nX := 1
	Do While !TRBSE1->(eof())
		If _aTitBanc[nX] <= 0	
			nX++

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Grava o N£mero do bordero atualizado						 ³
			//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			dbSelectArea("SX6")         
			PutMv("MV_NUMBORR",cNumBor) 

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Vai pegar o ultimo N£mero de bordero utilizado 				  ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cNumBor := Soma1(GetMV("MV_NUMBORR"),6)
			cNumBor := Replicate("0",6-Len(Alltrim(cNumBor)))+Alltrim(cNumBor)
			While !MayIUseCode("SE1"+xFilial("SE1")+cNumBor)  //verifica se esta na memoria, sendo usado
				// busca o proximo numero disponivel 
				cNumBor := Soma1(cNumBor)
			EndDo    

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³ Verifica se existe o mesmo numero de bordero gravado, quando ³
			//³ ocorrer geracao de bordero em usuarios simultaneos.          ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			cProxNum := cNumBor
			Do While !FA060Num( cProxNum, .F. )
				cNumBor  := cProxNum
				cProxNum := Soma1( cNumBor )
			EndDo                                      
		    
			DbSelectArea("SA6")
			DbSetOrder(1)
			DbSeek(xFilial("SA6")+oGetTM1:aCols[nX][nEaPort]+oGetTM1:aCols[nX][nEaAgen]+oGetTM1:aCols[nX][nEaCon])
			
			DbSelectArea("Z27")
			DbSetOrder(2)
			If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTPR)
				_cInstr1 := Z27->Z27_INSBCO
	        Else
	        	alert("Instrucao bancária não localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
	        	Return
	        EndIf

			DbSelectArea("Z27")
			DbSetOrder(2)
			If DbSeek(xFilial("Z27")+SA6->A6_COD+SA6->A6__INSTSE)
				_cInstr2 := Z27->Z27_INSBCO
	        Else
	        	alert("Instrucao bancária não localizada para o banco " + SA6->A6_NREDUZ + Chr(10) + Chr(13) + "Processo cancelado")
	        	Return
	        EndIf

		EndIf 
		
		RecLock("SEA",.T.)
			SEA->EA_FILIAL  := xFilial("SEA")
			SEA->EA_NUMBOR  := cNumBor
			SEA->EA_DATABOR := dDataBase
			SEA->EA_PORTADO := SA6->A6_COD
			SEA->EA_AGEDEP  := SA6->A6_AGENCIA
			SEA->EA_NUMCON  := SA6->A6_NUMCON
			SEA->EA_NUM 	:= TRBSE1->E1_NUM
			SEA->EA_PARCELA := TRBSE1->E1_PARCELA
			SEA->EA_PREFIXO := TRBSE1->E1_PREFIXO
			SEA->EA_TIPO	:= TRBSE1->E1_TIPO
			SEA->EA_CART	:= "R"
			SEA->EA_SITUACA := cTpCob
			SEA->EA_SITUANT := "0"
			SEA->EA_FILORIG := TRBSE1->E1_FILIAL
			SEA->EA__TIPGER := "2"
			SEA->EA__CNAB   := "N"
		SEA->(MsUnlock())  
	
		DbSelectArea("SE1")
		DbSetOrder(1)
		If DbSeek(  TRBSE1->E1_FILIAL + TRBSE1->E1_PREFIXO + TRBSE1->E1_NUM + TRBSE1->E1_PARCELA + TRBSE1->E1_TIPO )    
				
			RecLock("SE1",.F.)
				SE1->E1_PORTADO := SA6->A6_COD
				SE1->E1_AGEDEP  := SA6->A6_AGENCIA
				SE1->E1_CONTA	:= SA6->A6_NUMCON   
				SE1->E1_SITUACA := cTpCob
				SE1->E1_NUMBOR  := cNumBor
				SE1->E1_DATABOR := dDataBase
				SE1->E1_MOVIMEN := dDataBase
				SE1->E1_INSTR1  := _cInstr1
				SE1->E1_INSTR2  := _cInstr2
			SE1->(MsUnlock())
				
		Endif  

//		If(nX = Len(_aTitBanc) .AND. Len(_aTitBanc) > 1) //Caso total das porcentagens não chegue em 100%, sai da rotina quando distribuir todas
//			Exit
//		EndIf

		_aTitBanc[nX]--
		TRBSE1->(DbSkip())
	EndDo
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Grava o N£mero do bordero atualizado								  ³
	//³ Posicionar no sx6 sempre usando GetMv. N„o utilize Seek !!!  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	dbSelectArea("SX6")         
	PutMv("MV_NUMBORR",cNumBor) 

	TRBSE1->(DbCloseArea())
	
EndIf      

RestArea( aArea )

IFINA14A()

Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | CancBord | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Cancela bordero do titulo selecionado								     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/ 

Static Function CancBord()
Local nEaBor 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "EA_NUMBOR" 	})
Local cBordero	:= oGetTM2:aCols[oGetTM2:nAt][nEaBor]
Local _cQuery   := ""
Local _nRet		:= 0

//Confirma o cancelamento?
If(!MsgYesNo("Confirma cancelamento do Borderô " + cBordero + " ? ","ATENCAO"))
	oGetTM2:Refresh()
	oDlgTM1:Refresh()
	Return
EndIf

_cQuery := "UPDATE " + RetSqlName("SEA") + "      		" + Chr(13)
_cQuery += "SET D_E_L_E_T_ = '*'                  		" + Chr(13)
_cQuery += "    ,R_E_C_D_E_L_ = R_E_C_N_O_        		" + Chr(13)
_cQuery += "WHERE EA_NUMBOR = '" + cBordero + "'  		" + Chr(13)
_cQuery += "      AND D_E_L_E_T_ = ' '            		"
If (TCSQLExec(_cQuery) < 0)
    Return MsgStop("TCSQLError() " + TCSQLError())
EndIf

_cQuery := "UPDATE " + RetSqlName("SE1") + "           	" + Chr(13)
_cQuery += "SET E1_PORTADO  = ' '                      	" + Chr(13)
_cQuery += "    ,E1_AGEDEP  = ' '                      	" + Chr(13)
_cQuery += "    ,E1_SITUACA = '0'                      	" + Chr(13)
_cQuery += "	,E1_NUMBOR  = ' '                      	" + Chr(13)
_cQuery += "	,E1_DATABOR = ' '                      	" + Chr(13)
_cQuery += "	,E1_MOVIMEN = ' '                      	" + Chr(13)
_cQuery += "	,E1_CONTA	= ' '                      	" + Chr(13)
_cQuery += "	,E1_INSTR1	= ' '                      	" + Chr(13)
_cQuery += "	,E1_INSTR2	= ' '                      	" + Chr(13)
_cQuery += "WHERE D_E_L_E_T_ = ' '                     	" + Chr(13)
_cQuery += "      AND E1_NUMBOR = '" + cBordero + "'   	"
If (TCSQLExec(_cQuery) < 0)
    Return MsgStop("TCSQLError() " + TCSQLError())
EndIf

oGetTM2:aCols[oGetTM2:nAt][Len(oGetTM2:aHeader)+1] := .T.

oGetTM2:Refresh()
oDlgTM1:Refresh()

MsgInfo("Bordero " + cBordero + " cancelado com sucesso")

Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | GeraCNAB | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Cria CNAB do bordero selecionado 									     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/ 

Static Function GeraCNAB()                                                        
Local nA6Cod 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "EA_PORTADO"	}) 
Local nA6Nred 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "A6_NREDUZ" 	}) 
Local nA6Agenc 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "A6_AGENCIA" 	}) 
Local nA6Conta 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "A6_NUMCON" 	}) 
Local nEaBor 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "EA_NUMBOR" 	})
Local nEaCNAB 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "EA__CNAB" 	})
Local _nAt		:= oGetTM2:nAt 
Local _cPerg	:= PADR('AFI150',Len(SX1->X1_GRUPO))
Local _cSCCNAB	:= GetMV("MV__SCCNAB")
Local _cQuery	:= ""

If(oGetTM2:aCols[_nAt][nEaCNAB] = "S")
	Alert("CNAB já gerado para este bordero")
	Return
ElseIf(oGetTM2:aCols[_nAt][Len(oGetTM2:aHeader)+1])
	Alert("Bordero cancelado")
	Return
EndIf                          

DbSelectArea("SA6")
DbSetorder(1)
DbSeek(xFilial("SA6")+oGetTM2:aCols[_nAt][nA6Cod]+oGetTM2:aCols[_nAt][nA6Agenc]+oGetTM2:aCols[_nAt][nA6Conta])

DbSelectArea("SX1")
DbSetOrder(1)

If SX1->(DbSeek(_cPerg + "01"))  //Do Bordero ?   
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := oGetTM2:aCols[_nAt][nEaBor] 
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "02"))	//Ate o Bordero ?               
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := oGetTM2:aCols[_nAt][nEaBor]
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "03"))	//Arquivo de Config. ?  (RET/REM)
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6__NOMBOR
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "04"))	//Arquivo de Saida ?   
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6__CAMBOR
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "05"))	//Codigo do Banco ?    
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6_COD
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "06"))	//Codigo da Agencia ?  
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6_AGENCIA
	SX1->(MsUnLock())
Endif
If SX1->(DbSeek(_cPerg + "07")) //Codigo da Conta ?   
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6_NUMCON
	SX1->(MsUnLock())
Endif 
If SX1->(DbSeek(_cPerg + "08"))	//Codigo da Sub-Conta ?  
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := _cSCCNAB
	SX1->(MsUnLock())
Endif 
If SX1->(DbSeek(_cPerg + "09"))	//Configuracao CNAB ?  
	RecLock("SX1",.F.)
		SX1->X1_CNT01 := SA6->A6__CNFCNA
	SX1->(MsUnLock())
Endif 

//Chama Rotina para geracao do bordero
FinA150(2)

//Marca na SEA se foi gerado o CNAB corretamente
/*Jorge H - Anadi - Logica de atualização alterada
If Select("TRB_SEA") > 0
	DbSelectArea("TRB_SEA")
	DbCloseArea()
EndIf

_cQuery += "SELECT SEA.EA_NUMBOR,                                                      " + Chr(13)
_cQuery += "       SEA.EA__CNAB,                                                       " + Chr(13)
_cQuery += "       SEA.R_E_C_N_O_ AS RECSEA                                            " + Chr(13)
_cQuery += "FROM " + RetSqlName("SEA") + " SEA                                         " + Chr(13)
_cQuery += "INNER JOIN " + RetSqlName("SE1") + " SE1 ON SE1.E1_FILIAL = SEA.EA_FILIAL  " + Chr(13)
_cQuery += "                         AND SE1.E1_PREFIXO = SEA.EA_PREFIXO               " + Chr(13)
_cQuery += "                         AND SE1.E1_NUM = SEA.EA_NUM                       " + Chr(13)
_cQuery += "                         AND SE1.E1_PARCELA = SEA.EA_PARCELA               " + Chr(13)
_cQuery += "                         AND SE1.E1_TIPO = SEA.EA_TIPO                     " + Chr(13)
_cQuery += "                         AND SE1.D_E_L_E_T_ = ' '                          " + Chr(13)
_cQuery += "WHERE SEA.D_E_L_E_T_ = ' '                                                 " + Chr(13)
_cQuery += "      AND SEA.EA_CART = 'R'                                                " + Chr(13)
_cQuery += "      AND SEA.EA_NUMBOR = '" + oGetTM2:aCols[_nAt][nEaBor] + "'            " + Chr(13)
_cQuery += "      AND SE1.E1_IDCNAB != ' '                                             "
TcQuery _cQuery New Alias "TRB_SEA"


DbSelectArea("TRB_SEA")
DbGoTop()
If !(eof())
	Do While !TRB_SEA->(eof())
		DbSelectArea("SEA")
		DbGoTo(TRB_SEA->RECSEA)
		Reclock("SEA",.F.)
			SEA->EA__CNAB := "S"
		MsUnlock()     
		
		DbSelectArea("TRB_SEA")
		DbSkip()
	EndDo
	oGetTM2:aCols[_nAt][nEaCNAB] := "S"
EndIf

TRB_SEA->(MsUnlock())
*/

oGetTM2:aCols[_nAt][nEaCNAB] := "S"
_cQuery	:= "UPDATE " + RetSQLName( "SEA" ) + " "
_cQuery += "SET EA__CNAB = 'S' "
_cQuery += "WHERE EA_FILIAL  = '" + xFilial("SEA") + "' " 
_cQuery += "AND EA_NUMBOR  = '" + oGetTM2:aCols[_nAt][nEaBor] + "' "
_cQuery += "AND D_E_L_E_T_ = ' ' "
	
_nStatus := TCSQLExec(_cQuery)

If _nStatus < 0
	DbSelectArea("SEA")
	DbSetOrder(1)   
	DbGoTop()
	If DbSeek(xFilial("SEA") + oGetTM2:aCols[_nAt][nEaBor])
		While !Eof() .And. (SEA->EA_FILIAL + SEA->EA_NUMBOR) == (xFilial("SEA") + oGetTM2:aCols[_nAt][nEaBor])
			While !Reclock("SEA",.f.)
			EndDo
			SEA->EA__CNAB := "S"
			MsUnlock()
			
			DbSkip()
		EndDo
	Else
		MsgAlert("Não foi possível atualizar a tabela de borderôs, indicando que o arquivo CNAB foi gerado")
	EndIf
Else
	TCRefresh("SEA")
EndIf

Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | ImpBord  | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Chama Crystal para impressão do Bordero								     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/ 

Static Function ImpBord()  
Local x 		:= "1;0;1;CES40011"
Local cParms 	:= "'"
Local nA6Prior 	:= ASCAN(oGetTM2:aHeader, { |x| AllTrim(x[2]) == "EA_NUMBOR" 	}) 

For nX := 1 To Len(oGetTM2:aCols)
	cParms += oGetTM2:aCols[nX][nA6Prior] + "','"
Next nX

cParms := Substr(cParms,1,Len(cParms)-2)

CallCrys("CES40011", cParms, x)   

Return

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | AtuBco	| Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Carrega dados na SA6 quando trocar de linha no aCols 						  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function AtuBco()
Local _aArea 	:= GetArea()
Local _aAreaSA6 := SA6->(GetArea())
Local nPRecno 	:= ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "A6_REC_WT" 	}) 

DbSelectArea("SA6")
DbGoTo(oGetTM1:aCols[oGetTM1:nAt][nPRecno])
cOcor 		:= SA6->A6__OCORR
cCliP1 		:= SA6->A6__INSTPR
cCliP2 		:= SA6->A6__INSTSE 
nProt		:= SA6->A6__DIAPRO

DbSelectArea("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+"10"+cOcor+"E")
	cDesOco := SX5->X5_DESCRI
Else
	cDesOco := " "
EndIf

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+"  "+"000011"+cCliP1)
	cDesP1 := ZX5->ZX5_DSCITE
Else
	cDesP1 := " "
EndIf  

DbSelectArea("ZX5")
DbSetOrder(1)
If DbSeek(xFilial("ZX5")+"  "+"000011"+cCliP2)
	cDesP2 := ZX5->ZX5_DSCITE
Else
	cDesP2 := " "
EndIf

oOcor:Refresh()
oCliP1:Refresh()
oCliP2:Refresh()
oDesP1:Refresh()
oDesP2:Refresh()
oProt:Refresh()  
oDesOco:Refresh()
oDlgSA6:Refresh() 

RestArea(_aAreaSA6)
RestArea(_aArea)

Return .T.

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | ValCob  | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Chama Crystal para impressão do Bordero								     	  |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/ 

Static Function ValCob()  
Local lRet := .F.

DbSelectAreA("SX5")
DbSetOrder(1)
If DbSeek(xFilial("SX5")+"07"+cTpCob)
	cDesCob := SX5->X5_DESCRI
	lRet := .T.
ElseIf(Empty(cTpCob))
	cDesCob := ""
	lRet := .T.
EndIf   

oDesCob:Refresh()                 

Return lRet

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Fevereiro de 2015				  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader(aCpoHeader,nTipo)
Local aHeaderB      := {}
Local _nPos			:= 0

For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3		    ,;
		SX3->X3_Context})
	Endif
Next _nElemHead
dbSelectArea("SX3")
dbSetOrder(1)

If nTipo = 1
	AADD( aHeaderB, { "Recno WT", "A6_REC_WT", "", 09, 0,,, "N", "SA6", "V"} )
ElseIf nTipo = 2 
	_nPos := ASCAN(aCpoHeader, { |x| AllTrim(x) == "E1_SALDO"		}) 
	aHeaderB[_nPos][1] := "Qtde. Tit." 			//Titulo
	aHeaderB[_nPos][3] := "@E 999,999,999"		//Picture
	aHeaderB[_nPos][4] := TamSX3("E1_VALOR")[1]	//Tamanho
	aHeaderB[_nPos][5] := 0						//Decimal

	_nPos := ASCAN(aCpoHeader, { |x| AllTrim(x) == "E1_VALOR"		}) 
	aHeaderB[_nPos][3] := PesqPict("SE1","E1_VALOR")		//Picture
	aHeaderB[_nPos][4] := TamSX3("E1_VALOR")[1]					//Tamanho
	aHeaderB[_nPos][5] := TamSX3("E1_VALOR")[2]						//Decimal
EndIf

Return aHeaderB 

/*
+------------+----------+-------+-------------------------------------+------+----------------+
| Programa   | CriaCols | Autor | Rubens Cruz	- Anadi Soluções   	  | Data | Fevereiro/2015 |
+------------+----------+-------+-------------------------------------+------+----------------+
| Descricao  | Tela de cadastro de parametros para remessa bancária						      |
+------------+--------------------------------------------------------------------------------+
| Uso        | ISAPA													 					  |
+------------+--------------------------------------------------------------------------------+
*/

Static Function CriaCols(aHeaderB,nTipo)  
Local   n			:= 0                 
Local	nA6Cod 		:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_COD"		}) 
Local	nA6Nreduz 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_NREDUZ" 	}) 
Local	nA6Agenc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_AGENCIA" 	}) 
Local	nA6Conta 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_NUMCON" 	}) 
Local	nA6Prior 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6__PRIORI" 	}) 
Local	nA6Perc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6__PERC" 	}) 
Local	nPRecno 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "A6_REC_WT" 	})
Local	nEaPort 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA_PORTADO" 	})
//Local	nEaAgen 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA_AGEDEP" 	})
//Local	nEaCon	 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA_NUMCON" 	})
Local	nEaBor 		:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA_NUMBOR" 	})
Local	nEaDtBor	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA_DATABOR" 	})
Local	nEaCNAB		:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "EA__CNAB" 	})
Local	nE1Sald 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "E1_SALDO" 	})
Local	nE1Val	 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "E1_VALOR" 	})
Local	nQtdCpo 	:= Len(aHeaderB)
Local	aColsB		:= {}
             
	If(select("TRB_TMP") > 0)
		TRB_TMP->(DbCloseArea())
	EndIf     
	
		aColsB := {}

	If nTipo = 1
	    _cQuery := "SELECT SA6.A6_COD,                                                         				" + Chr(13)
	    _cQuery += "       SA6.A6_NREDUZ,                                                      				" + Chr(13)
	    _cQuery += "       SA6.A6_AGENCIA,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6_NUMCON,                                                      				" + Chr(13)
	    _cQuery += "       SA6.A6__OCORR,                                                      				" + Chr(13)
	    _cQuery += "       SA6.A6__DIAPRO,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6__INSTPR,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6__INSTSE,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6__PRIORI,                                                     				" + Chr(13)
	    _cQuery += "       SA6.A6__PERC,	                                                   				" + Chr(13)
	    _cQuery += "       NVL(ZX5A.ZX5_DSCITE,' ') AS DESCPR,                                           	" + Chr(13)
	    _cQuery += "       NVL(ZX5B.ZX5_DSCITE,' ') AS DESCSE,                                           	" + Chr(13)
	    _cQuery += "       NVL(SX5C.X5_DESCRI,' ') AS DESCOCO,                                           	" + Chr(13)
	    _cQuery += "       SA6.R_E_C_N_O_ AS RECSA6                                            				" + Chr(13)
	    _cQuery += "FROM " + RetSqlName("SA6") + " SA6                                         				" + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("ZX5") + " ZX5A ON ZX5A.ZX5_FILIAL = '" + xFilial("ZX5") + "'	" + Chr(13)
	    _cQuery += "                         AND ZX5A.ZX5_GRUPO = '000011'                 	   	            " + Chr(13)
	    _cQuery += "                         AND ZX5A.ZX5_CODIGO = SA6.A6__INSTPR         	    	        " + Chr(13)
	    _cQuery += "                         AND ZX5A.D_E_L_E_T_ = ' '                              	    " + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("ZX5") + " ZX5B ON ZX5B.ZX5_FILIAL = '" + xFilial("ZX5") + "' 	" + Chr(13)
	    _cQuery += "                         AND ZX5B.ZX5_GRUPO = '000011'                                 	" + Chr(13)
	    _cQuery += "                         AND ZX5B.ZX5_CODIGO = SA6.A6__INSTSE                         	" + Chr(13)
	    _cQuery += "                         AND ZX5B.D_E_L_E_T_ = ' '                                  	" + Chr(13)
	    _cQuery += "LEFT JOIN " + RetSqlName("SX5") + " SX5C ON SX5C.X5_FILIAL = '" + xFilial("SX5") + "'  	" + Chr(13)
	    _cQuery += "                         AND SX5C.X5_TABELA = '10'                                  	" + Chr(13)
	    _cQuery += "                         AND SX5C.X5_CHAVE = SA6.A6__OCORR || 'E'                      	" + Chr(13)
	    _cQuery += "                         AND SX5C.D_E_L_E_T_ = ' '                                  	" + Chr(13)
	    _cQuery += "WHERE SA6.D_E_L_E_T_ = ' '                                                 				" + Chr(13)
//	    _cQuery += "	  AND SA6.A6__PRIORI > 0                                               				" + Chr(13)
	    _cQuery += "	  AND SA6.A6__PERC > 0                                                 				" + Chr(13)
	    _cQuery += "      AND SA6.A6__REMESS = '1'   										   				" + Chr(13)
	    _cQuery += "ORDER BY SA6.A6__PRIORI ASC,   											   				" + Chr(13)
	    _cQuery += "		 SA6.A6__PERC ASC   											   				"
		TcQuery _cQuery New Alias "TRB_TMP"                                                          
		
		If(Empty(TRB_TMP->A6_COD))
			n++
	      	AAdd(aColsB, Array(nQtdCpo+1))
	
			aColsB[n][nA6Cod] 	 		:= " "
			aColsB[n][nA6Nreduz] 	 	:= " "
			aColsB[n][nA6Agenc] 	 	:= " "
			aColsB[n][nA6Conta] 	 	:= " "
			aColsB[n][nA6Prior] 	 	:= 0
			aColsB[n][nA6Perc]	 	 	:= 0
			aColsB[n][nPRecno]	 	 	:= 0
			aColsB[n][nQtdCpo+1]		:= .F.
		Else		
			DbSelectArea("TRB_TMP")

			nProt   := TRB_TMP->A6__DIAPRO
			cOcor   := TRB_TMP->A6__OCORR
			cCliP1  := TRB_TMP->A6__INSTPR
			cCliP2  := TRB_TMP->A6__INSTSE
			cDesOco := TRB_TMP->DESCOCO
			cDesP1  := TRB_TMP->DESCPR
			cDesP2  := TRB_TMP->DESCSE

			While !(eof())
				n++    
		      	AAdd(AcolsB, Array(nQtdCpo+1))
		
				aColsB[n][nA6Cod] 	 		:= TRB_TMP->A6_COD
				aColsB[n][nA6Nreduz] 	 	:= TRB_TMP->A6_NREDUZ
				aColsB[n][nA6Agenc] 	 	:= TRB_TMP->A6_AGENCIA
				aColsB[n][nA6Conta] 	 	:= TRB_TMP->A6_NUMCON
				aColsB[n][nA6Prior] 	 	:= TRB_TMP->A6__PRIORI
				aColsB[n][nA6Perc]	 	 	:= TRB_TMP->A6__PERC
				aColsB[n][nPRecno]	 	 	:= TRB_TMP->RECSA6
				aColsB[n][nQtdCpo+1]		:= .F.
						   	  	     
				DbSkip()
			EndDo
		EndIf
	Else     
	
	    _cQuery := "SELECT SEA.EA_PORTADO,                                                        " + Chr(13)
	    _cQuery += "       SEA.EA_AGEDEP,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_NUMCON,                                                         " + Chr(13)
	    _cQuery += "       SA6.A6_NREDUZ,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_NUMBOR,                                                         " + Chr(13)
	    _cQuery += "       COUNT(SEA.EA_NUM) AS TITULO,                                           " + Chr(13)
	    _cQuery += "       SUM(SE1.E1_VALOR) AS VALOR,                                            " + Chr(13)
	    _cQuery += "       SEA.EA_DATABOR,                                                        " + Chr(13)
	    _cQuery += "       SEA.EA__CNAB                                                           " + Chr(13)
	    _cQuery += "FROM " + RetSqlName("SEA") + " SEA                                            " + Chr(13)
	    _cQuery += "INNER JOIN " + RetSqlName("SA6") + " SA6 ON SA6.A6_FILIAL = '  '              " + Chr(13)
	    _cQuery += "                         AND SA6.A6_COD = SEA.EA_PORTADO                      " + Chr(13)
	    _cQuery += "                         AND SA6.A6_AGENCIA = SEA.EA_AGEDEP                   " + Chr(13)
	    _cQuery += "                         AND SA6.A6_NUMCON = SEA.EA_NUMCON                    " + Chr(13)
	    _cQuery += "                         AND SA6.D_E_L_E_T_ = ' '                             " + Chr(13)
	    _cQuery += "INNER JOIN " + RetSqlName("SE1") + " SE1 ON SE1.E1_FILIAL = SEA.EA_FILORIG    " + Chr(13)
	    _cQuery += "                         AND SE1.E1_PREFIXO = SEA.EA_PREFIXO                  " + Chr(13)
	    _cQuery += "                         AND SE1.E1_NUM = SEA.EA_NUM                          " + Chr(13)
	    _cQuery += "                         AND SE1.E1_PARCELA = SEA.EA_PARCELA                  " + Chr(13)
	    _cQuery += "                         AND SE1.E1_TIPO = SEA.EA_TIPO                        " + Chr(13)
	    _cQuery += "                         AND SE1.D_E_L_E_T_ = ' '                             " + Chr(13)
	    _cQuery += "WHERE SEA.D_E_L_E_T_ = ' '                                                    " + Chr(13)
	    _cQuery += "      AND SEA.EA__TIPGER = '2'                                                " + Chr(13)
	    _cQuery += "      AND SEA.EA_CART = 'R'                                                   " + Chr(13)
	    _cQuery += "      AND SEA.EA__CNAB != 'S'                                                  " + Chr(13)
	    _cQuery += "      AND SEA.EA_NUMBOR != ' '                                                " + Chr(13)
	    _cQuery += "GROUP BY SEA.EA_PORTADO,                                                      " + Chr(13)
	    _cQuery += "       SEA.EA_AGEDEP,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_NUMCON,                                                         " + Chr(13)
	    _cQuery += "       SA6.A6_NREDUZ,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_NUMBOR,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_DATABOR,                                                        " + Chr(13)
	    _cQuery += "       SEA.EA__CNAB                                                           " + Chr(13)
	    _cQuery += "ORDER BY SEA.EA_PORTADO,                                                      " + Chr(13)
	    _cQuery += "       SEA.EA_AGEDEP,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_NUMCON,                                                         " + Chr(13)
	    _cQuery += "       SA6.A6_NREDUZ,                                                         " + Chr(13)
	    _cQuery += "       SEA.EA_DATABOR,                                                        " + Chr(13)
	    _cQuery += "       SEA.EA__CNAB                                                           "
		TcQuery _cQuery New Alias "TRB_TMP"                                                          
		TcSetField("TRB_TMP", "EA_DATABOR"   , "D", 08, 0)
	
		nTotCont  	:= 0 
		nTotVal   	:= 0

		If(Empty(TRB_TMP->EA_PORTADO))                        
			n++
	      	AAdd(aColsB, Array(nQtdCpo+1))
	
			aColsB[n][nEaPort] 	 		:= " "
			aColsB[n][nA6Agenc]  		:= " "
			aColsB[n][nA6Conta] 	 	:= " "
			aColsB[n][nA6Nreduz] 	 	:= " "
			aColsB[n][nEaBor]	 	 	:= " "
			aColsB[n][nE1Sald]	 	 	:= 0
			aColsB[n][nE1Val]	 	 	:= 0
			aColsB[n][nEaDtBor]	 	 	:= CTOD("  /  /    ")
			aColsB[n][nEaCNAB]	 	 	:= " "
			aColsB[n][nQtdCpo+1]		:= .F.
		Else		
			DbSelectArea("TRB_TMP")
			While !(eof())
				n++    
		      	AAdd(AcolsB, Array(nQtdCpo+1))
		
				aColsB[n][nEaPort] 	 		:= TRB_TMP->EA_PORTADO
				aColsB[n][nA6Agenc]	 		:= TRB_TMP->EA_AGEDEP
				aColsB[n][nA6Conta]		 	:= TRB_TMP->EA_NUMCON
				aColsB[n][nA6Nreduz] 	 	:= TRB_TMP->A6_NREDUZ
				aColsB[n][nEaBor]	 	 	:= TRB_TMP->EA_NUMBOR
				aColsB[n][nE1Sald]	 	 	:= TRB_TMP->TITULO
				aColsB[n][nE1Val]	 	 	:= TRB_TMP->VALOR
				aColsB[n][nEaDtBor]	 	 	:= TRB_TMP->EA_DATABOR
				aColsB[n][nEaCNAB]	 	 	:= TRB_TMP->EA__CNAB
				aColsB[n][nQtdCpo+1]		:= .F.
				
				nTotCont  	+= TRB_TMP->TITULO
				nTotVal   	+= TRB_TMP->VALOR 
						   	  	     
				DbSkip()
			EndDo
		EndIf
	
	EndIf
	 	TRB_TMP->(dbCloseArea())

Return aColsB