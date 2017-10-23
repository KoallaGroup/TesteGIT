#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*
+-----------+---------+-------+------------------------------------------+------+---------------+
| Programa  | IGENM04 | Autor | Jorge Henrique Alves - Anadi Consultoria | Data | Setembro/2014 |
+-----------+---------+-------+------------------------------------------+------+---------------+
| Descricao | Programa para atualizar alguns campos das tabelas SA1, GU9, SA3, SZJ, SZK, SF7    |
+-----------+-----------------------------------------------------------------------------------+
| Uso       | Isapa											                                    |
+-----------+-----------------------------------------------------------------------------------+
*/

User Function IGENM04()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Declaracao de Variaveis                                             ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Private oLeTxt 
Private cPerg := PADR("IGENM04",Len(SX1->X1_GRUPO))

_fVldPerg()

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Montagem da tela de processamento.                                  ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

DEFINE MSDIALOG oLeTxt TITLE "Leitura de Arquivo Texto" FROM 200,1  TO 380,380 PIXEL
@ 10,005 Say " Este programa ira ler o conteudo de um arquivo texto, para atualizar" of oLeTxt PIXEL
@ 18,005 Say " campos da tabela selecionada parametro informado pelo usuário       " of oLeTxt PIXEL

@ 70,040 BUTTON _obtn1 PROMPT "Confirmar"   Action OkLeTxt()			SIZE 040, 010 OF oLeTxt PIXEL
@ 70,090 BUTTON _obtn2 PROMPT "Sair" 	    Action oLeTxt:End()			SIZE 040, 010 OF oLeTxt PIXEL
@ 70,140 BUTTON _obtn3 PROMPT "Parametros"  Action Pergunte(cPerg,.t.)	SIZE 040, 010 OF oLeTxt PIXEL

Activate MsDialog oLeTxt Centered

Return

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³ OKLETXT  º Autor ³ AP6 IDE            º Data ³  28/06/05   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao chamada pelo botao OK na tela inicial de processamenº±±
±±º          ³ to. Executa a leitura do arquivo texto.                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function OkLeTxt()
local cFile := ""

If !(mv_par01 $ "SA4/SB1/SA1/SA2/DA1/SF7/SE1")
	MsgStop("Tabela incorreta. As tabelas válidas são SA4/SB1/SA1/SA2/DA1/SF7/SE1")
	Return
EndIf	

cFile := cGetFile("*.txt|*.txt","Selecione o Arquivo para importação de dados ",0,,.t.,GETF_LOCALHARD+GETF_LOCALFLOPPY+GETF_NETWORKDRIVE)

if Empty(cFile)
	Return
endif
	
Private nHdl    := fOpen(cFile,68)
Private cEOL    := CHR(13)+CHR(10)

If nHdl == -1
    MsgAlert("O arquivo de nome "+cFile+" nao pode ser aberto! Verifique os parametros.","Atencao!")
    Return
Endif

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Inicializa a regua de processamento                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

If mv_par01 == "SA4"
	Processa({|| RContSA4() },"Processando SA4...")
Elseif mv_par01 == "SF1"
	Processa({|| RContSF1() },"Processando SF1...")
ElseIf mv_par01 == "CVM"
	Processa({|| RContCVM() },"Processando CVM...")
ElseIf mv_par01 == "SA2"
	Processa({|| RContSA2() },"Processando SA2...")	
ElseIf mv_par01 == "SB1"
	Processa({|| RContSB1() },"Processando SB1...")	
ElseIf mv_par01 == "SA1"
	Processa({|| RContSA1() },"Processando SA1...")	
ElseIf mv_par01 == "DA1"
	Processa({|| RContDA1() },"Processando SA1...")	
ElseIf mv_par01 == "SF7"
	Processa({|| RContSF7() },"Processando SF7...")	
ElseIf mv_par01 == "SE1"
	Processa({|| RContSE1() },"Processando SE1...")	
EndIf

Return
  

/*
+-----------+----------+-------+----------------------+------+---------------+
| Programa  | RContSA4 | Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+----------+-------+----------------------+------+---------------+
| Descricao | Atualiza Tipo de frete										 |
+-----------+----------------------------------------------------------------+
| Uso       | Finder Argentina                                               |
+-----------+----------------------------------------------------------------+
*/

Static Function RCONTSA4()                                                     

Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
	
	if !lInicio
	    If aDados[1] == "TRANSP" .and. ;
		    aDados[2] == "TIPO_FRETE" .and. ;
		    aDados[3] == "CONVENIO"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
    DbSelectArea("SA4") 
    DbSetOrder(3)
    If DbSeek(xFilial("SA4") + PADR(Alltrim(aDados[1]),TamSX3("A4_CGC")[1]))
        While !Reclock("SA4",.f.)
        EndDo
        SA4->A4__TPFRET := aDados[2]
        SA4->A4__CONVEN := aDados[3]
        MsUnlock()        	
    EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return


/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTCVM| Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza CVM_SEQINI e CVM_SEQULT  									 |
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTCVM()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
	
	if !lInicio
	    If aDados[1] == "CVM_FILIAL" .and. ;
		    aDados[2] == "CVM_COD" .and. ;
		    aDados[3] == "CVM_DTINI"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("CVM") 
   DbSetOrder(1)
   If DbSeek(PADR(aDados[1],Len(CVM->CVM_FILIAL)) + PADR(aDados[2],Len(CVM->CVM_COD)) + PADR(aDados[7],Len(CVM->CVM_RAD)) ) .And.; 
   			 xFilial("CVM") == aDados[1]
   			 
   	While !RecLock("CVM",.F.)
   	EndDo
   	
   	If Upper(Alltrim(CVM->CVM_SEQINI)) != Upper(Alltrim(aDados[5]))
   		CVM->CVM_SEQINI := Alltrim(aDados[5])
   	EndIf
   	
   	If Upper(Alltrim(CVM->CVM_SEQULT)) != Upper(Alltrim(aDados[6]))
   		CVM->CVM_SEQULT := Alltrim(aDados[6])
   	EndIf
   	
   	MsUnLock()
   	nItem++
   	
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return

/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSF1| Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza F1_NUMDES					   									 |
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSF1()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
	
	if !lInicio
	    If aDados[1] == "F1_FILIAL" .and. ;
		    aDados[2] == "F1_DOC" .and. ;
		    aDados[3] == "F1_SERIE"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("SF1") 
   DbSetOrder(1)
   If DbSeek(PADR(aDados[1],Len(SF1->F1_FILIAL)) + PADR(aDados[2],Len(SF1->F1_DOC)) + PADR(aDados[3],Len(SF1->F1_SERIE)) +;
   			 PADR(aDados[4],Len(SF1->F1_FORNECE)) + PADR(aDados[5],Len(SF1->F1_LOJA)) + PADR(aDados[6],Len(SF1->F1_FORMUL)) ) .And.; 
   			 xFilial("SF1") == aDados[1]
   			 
   	If Upper(Alltrim(SF1->F1_NUMDES)) != Upper(Alltrim(aDados[7]))
	   	While !RecLock("SF1",.F.)
	   	EndDo
	   	SF1->F1_NUMDES := Alltrim(aDados[7])
	   	MsUnLock()
	   	nItem++
   	Endif
   	
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return

/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSFE| Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza FE_NROCERT														 |
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSA2()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
	
	if !lInicio
	    If aDados[1] == "CODIGO" .and. ;
		    aDados[2] == "LOJA" .and. ;
		    aDados[3] == "IPI"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])      
	
   DbSelectArea("SA2") 
   DbSetOrder(1)
   If DbSeek(xFilial("SA2") + PADR(aDados[1],Len(SA2->A2_COD)) + PADR(aDados[2],Len(SA2->A2_LOJA)) )
   			 
   	    While !RecLock("SA2",.F.)
   	    EndDo   	
		SA2->A2__IPI	    := aDados[3]
		MsUnLock()
   	    nItem++
   	
   EndIf
//   DbSelectArea("SA2") 
//   If !Empty(aDados[2] + aDados[3] + aDados[5])
   	
//   	DbSetOrder(4)
// 	   If DbSeek(PADR(aDados[7],Len(SFE->FE_FILIAL)) + PADR(aDados[2],Len(SFE->FE_FORNECE)) + PADR(aDados[3],Len(SFE->FE_LOJA)) +;
//   			 PADR(aDados[5],Len(SFE->FE_NFISCAL)) + PADR(aDados[6],Len(SFE->FE_SERIE)) + PADR(aDados[4],Len(SFE->FE_TIPO)) ) .And.; 
//   			 xFilial("SA2") == aDados[7] .And. !Empty(aDados[5])
   			 
//		   	If Upper(Alltrim(SFE->FE_NROCERT)) != Upper(Alltrim(aDados[1]))
//			   	While !RecLock("SFE",.F.)
//			   	EndDo
//			   	SFE->FE_NROCERT := Alltrim(aDados[1])
//			   	MsUnLock()
//			   	nItem++
//		   	Endif
		 
//		 EndIf  	

// 	ElseIf !Empty(aDados[9] + aDados[8] + aDados[5])
   	
//   	DbSetOrder(8)
// 	   If DbSeek(PADR(aDados[7],Len(SFE->FE_FILIAL)) + PADR(aDados[9],Len(SFE->FE_CLIENTE)) + PADR(aDados[8],Len(SFE->FE_LOJCLI)) +;
//   			 PADR(aDados[5],Len(SFE->FE_NFISCAL)) + PADR(aDados[6],Len(SFE->FE_SERIE)) ) .And.; 
//   			 xFilial("SFE") == aDados[7] .And. !Empty(aDados[5])
   			 
//		   	If Upper(Alltrim(SFE->FE_NROCERT)) != Upper(Alltrim(aDados[1]))
//			   	While !RecLock("SFE",.F.)
//			   	EndDo
//			   	SFE->FE_NROCERT := Alltrim(aDados[1])
//			   	MsUnLock()
//			   	nItem++
//		   	Endif
		 
//		 EndIf  	
   	
//   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return


/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSB1| Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza B1_DESC_P e B1_DESC_I		  			     		 |
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSB1()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
    if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	    endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	    endif
		y := ""
	endif	
	
	if !lInicio
	    If  aDados[1] == "B1_COD" .And.;   
	        aDados[2] == "B1_PESO" 	 .And.; 
		    aDados[3] == "B1_PESBRU"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
	DbSelectArea("SB1") 
   	DbSetOrder(1)
   	If DbSeek(xFilial("SB1") + PADR(aDados[1],TamSX3("B1_COD")[1]) )
		While !RecLock("SB1",.F.)
   	    EndDo   	
		SB1->B1_PESO		:= ConvNum(aDados[2],"B1_PESO")
		SB1->B1_PESBRU		:= ConvNum(aDados[3],"B1_PESBRU")
		MsUnLock()
   	    nItem += 1   	
   	EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return


/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSE1| Autor | ULISSES CARMO 		 | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza SE1		  			     	             	     	 |
+-----------+---------------------------------------------------------------+
| Uso       | ISAPA                    			                            |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSE1()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
    if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	    endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 7
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	    endif
		y := ""
	endif	
	
	if !lInicio
	    If  aDados[1] == "FILIAL" .and. ;   
	        aDados[2] == "PREFIXO" .and. ;
		    aDados[3] == "NUMERO" .and. ;   
		    aDados[4] == "PARCELA" .and. ;  
		    aDados[5] == "CLIENTE" .and. ;
		    aDados[6] == "LOJA"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("SE1") 
   DbSetOrder(2)
   If DbSeek(Strzero(Val(aDados[1]),2,0) + PADR(aDados[5],Len(SE1->E1_CLIENTE)) + PADR(aDados[6],Len(SE1->E1_LOJA)) + PADR(aDados[2],Len(SE1->E1_PREFIXO)) + PADR( aDados[3],Len(SE1->E1_NUM)) + PADR(aDados[4],Len(SE1->E1_PARCELA)))   			 
   	    While !RecLock("SE1",.F.)
   	    EndDo   	
		SE1->E1_NUMBCO	:= Alltrim(aDados[7])
		MsUnLock()
   		nItem += 1
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return

/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSA1| Autor | Jorge Henrique Alves | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza A1_DDD							  									 |
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSA1
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 3
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
    if !lInicio	
	    If 	aDados[1] == "CODIGO" .and. ;
		    aDados[2] == "LOJA" .and. ;
			aDados[3] == "LIMITE_CREDITO" .and. ;
			aDados[4] == "DATA_VENCIMENTO_CREDITO" .and. ;
			aDados[5] == "MAIOR_SALDO" .and. ;
			aDados[6] == "MAIOR_COMPRA" .and. ;
			aDados[7] == "MEDIA_ATRASO" .and. ;
			aDados[8] == "PRIMEIRA_COMPRA" .and. ;
			aDados[9] == "ULTIMA_COMPRA" .and. ;
			aDados[10] == "FREQ_VISITA" .and. ;
			aDados[11] == "DATA_ULTIMA_VISITA" .and. ;
			aDados[12] == "SALDO_TITULO" .and. ;
			aDados[13] == "ISS_RETIDO" .and. ;
			aDados[14] == "SLD_PED_LIB" .and. ;
			aDados[15] == "SUFRAMA" .and. ;
			aDados[16] == "ATRASADOS" .and. ;
			aDados[17] == "VLR_ACUMUL" .and. ;
			aDados[18] == "SALDO_PEDIDO" .and. ;
			aDados[19] == "TABELA_PRECO" .and. ;
			aDados[20] == "MSBLQL" .and. ;
			aDados[21] == "BLQ_FINANC" .and. ;
			aDados[22] == "DUVIDOSO" .and. ;
			aDados[23] == "ATIVO" 
//		    aDados[3] == "ESTADUAL" .and.;
//		    aDados[4] == "TRANSPORTE" 
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("SA1") 
   DbSetOrder(1)
   If DbSeek(xFilial("SA1") + PADR(aDados[1],TamSX3("A1_COD")[1]) + PADR(aDados[2],TamSX3("A1_LOJA")[1]))
   			 
	   	While !RecLock("SA1",.F.)
	   	EndDo
		SA1->A1_LC		:= Val(aDados[3])
		SA1->A1_VENCLC	:= cTod(aDados[4])
		SA1->A1_MSALDO	:= Val(aDados[5])
		SA1->A1_MCOMPRA	:= Val(aDados[6])
		SA1->A1_METR	:= Val(aDados[7])
		SA1->A1_PRICOM	:= cTod(aDados[8])
		SA1->A1_ULTCOM	:= cTod(aDados[9])
		SA1->A1_TEMVIS	:= ConvNum(aDados[10])
		SA1->A1_ULTVIS	:= cTod(aDados[11])
		SA1->A1_SALDUP	:= Val(aDados[12])
		SA1->A1_RECISS	:= aDados[13]
		SA1->A1_SALPEDL	:= Val(aDados[14])
		SA1->A1_SUFRAMA	:= aDados[15]
		SA1->A1_PAGATR	:= Val(aDados[16])
		SA1->A1__VALACU	:= Val(aDados[17])
		SA1->A1_SALPED	:= Val(aDados[18])
		SA1->A1_TABELA	:= aDados[19]
		SA1->A1_MSBLQL	:= aDados[20]
		SA1->A1__RESTRI	:= aDados[21]
		SA1->A1__DUVIDO	:= aDados[22]
		SA1->A1__ATIVO  := aDados[23]
//	   	SA1->A1_VEND    := StrZero(Val(aDados[3]),TamSX3("A1_VEND")[1])
//	   	SA1->A1__REGTRP := StrZero(Val(aDados[4]),TamSX3("A1__REGTRP")[1])
//	   	SA1->A1_TRANSP  := StrZero(Val(aDados[5]),TamSX3("A1_TRANSP")[1])
//	   	SA1->A1__SEGISP := Alltrim(aDados[6])
//		SA1->A1_GRPTRIB	:= StrZero(Val(aDados[3]),TamSX3("A1_GRPTRIB")[1])
//		SA1->A1_CGC	:= StrZero(Val(aDados[3]),IIF(SA1->A1_TIPO == 'F',11,14) ) 
//		SA1->A1_CGC	:= StrZero(Val(aDados[3]),11/*TamSX3("A1_CGC")[1]*/)
//		SA1->A1_INSCR	:= aDados[3]
//		SA1->A1__REGTRP	:= aDados[4]
	   	MsUnLock()
   	 	nItem++
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return           

/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTSA1| Autor | Ulisses Carmo | Data |		Fevereiro/2015  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza TES na SF7					     					|
+-----------+---------------------------------------------------------------+
| Uso       | Isapa                                             			|
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTSF7
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
   if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 5
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 5
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	endif
		y := ""
	endif	
	
	if !lInicio
	    If  aDados[1] == "FILIAL" .and. ;
		    aDados[2] == "GRUPO" .and. ;
		    aDados[3] == "ESTADO" .and.;
		    aDados[4] == "TIPO" .and. ;
		    aDados[5] == "TES" 
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("SF7") 
   DbSetOrder(1)
   If DbSeek(PADR(aDados[1],TamSX3("F7_FILIAL")[1]) + PADR(aDados[2],TamSX3("F7_GRTRIB")[1]) + PADR(aDados[3],TamSX3("F7_EST")[1]) + PADR(aDados[4],TamSX3("F7_TIPOCLI")[1]))
	   	While !RecLock("SF7",.F.)
	   	EndDo                                                                                                                                   
//	   	SA1->A1_VEND    := StrZero(Val(aDados[3]),TamSX3("A1_VEND")[1])
//	   	SA1->A1__REGTRP := StrZero(Val(aDados[4]),TamSX3("A1__REGTRP")[1])
//	   	SA1->A1_TRANSP  := StrZero(Val(aDados[5]),TamSX3("A1_TRANSP")[1])
//	   	SA1->A1__SEGISP := Alltrim(aDados[6])
//		SA1->A1_GRPTRIB	:= StrZero(Val(aDados[3]),TamSX3("A1_GRPTRIB")[1])
//		SA1->A1_CGC	:= StrZero(Val(aDados[3]),IIF(SA1->A1_TIPO == 'F',11,14) ) 
		SF7->F7__TES   := Alltrim(aDados[5])
	   	MsUnLock()
   	 	nItem++
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return     


/*
+-----------+---------+-------+----------------------+------+---------------+
| Programa  | RCONTDA1| Autor | Rubens Cruz 		 | Data |   Abril/2010  |
+-----------+---------+-------+----------------------+------+---------------+
| Descricao | Atualiza DA1_VALOR				  			     		 	|
+-----------+---------------------------------------------------------------+
| Uso       | Finder Argentina                                              |
+-----------+---------------------------------------------------------------+
*/

Static Function RCONTDA1()
Local y, x := z := nItem := 0
Local nTamFile, nTamLin,cBuffer, nBtLidos, cTab := CHR(9)
Local linicio := .f., aDados := {}

nTamFile := fSeek(nHdl,0,2)
fSeek(nHdl,0,0)
nTamLin  := 500+Len(cEOL)
cBuffer  := Space(nTamLin) // Variavel para criacao da linha do registro para leitura

nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da primeira linha do arquivo texto

ProcRegua(nTamFile/30) // Numero de registros a processar
y := cBuffer

While nBtLidos >= nTamLin .or. nBtLidos > 0
   
   //Processmessages()
    if (z := at(CHR(13)+CHR(10), y)) == 0 
	    nBtLidos := fRead(nHdl,@cBuffer,nTamLin) // Leitura da proxima linha do arquivo texto
	    y += cBuffer
	    loop
	endif  
	
	if z  > 0
		aDados := Separa(SubStr(y,1,z-1),chr(09))
		if len(aDados) < 6
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,z-1)+cEOL+;
				 		"Registro desconsiderado")
			y := substr(y, z+2, Len(y))
			loop
   	    endif
		y := substr(y, z+2, Len(y))
	else
		aDados := Separa(SubStr(y,1,Len(y)),chr(09))
		if len(aDados) < 6
			MsgAlert("Erro na sequencia dos dados."+cEOL+;
					    SubStr(y,1,Len(y))+cEOL+;
				 		"Registro desconsiderado")
			y := ""
			loop				 		
   	    endif
		y := ""
	endif	
	
	if !lInicio
	    If aDados[1] == "PRODUTO" .and. ;
		    aDados[2] == "PRECO" .and. ;
		    aDados[3] == "DATA VALIDADE"
			lInicio :=  .t.	
		EndIf
		Loop
	EndIf

	IncProc(aDados[1])
   
   DbSelectArea("DA1") 
   DbSetOrder(7)
   If DbSeek(xFilial("DA1") + PADR(aDados[1],Len(DA1->DA1_CODPRO)) + '  ' )
   			 
   	    While !RecLock("DA1",.F.)
   	    EndDo   	
		DA1->DA1_PRCVEN	    := val(StrTran(aDados[2],",","."))
		DA1->DA1_DATVIG	    := CTOD(aDados[3])
		DA1->DA1__PREC2     := val(StrTran(aDados[4],",","."))
		DA1->DA1__PREC3     := val(StrTran(aDados[5],",","."))
		DA1->DA1__PREC4     := val(StrTran(aDados[6],",","."))
		MsUnLock()
   	    nItem++
   	
   EndIf	

EndDo

MsgInfo(Alltrim(Str(nItem)) + " Registros alterados")

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ O arquivo texto deve ser fechado, bem como o dialogo criado na fun- ³
//³ cao anterior.                                                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

fClose(nHdl)
oLeTxt:End()

Return



/*
+------------+-----------+--------+----------------+-------+-----------+
| Programa:  | _fVldPerg | Autor: | Jorge H. Alves | Data: | Abril/2010|
+------------+-----------+--------+----------------+-------+-----------+
| Descrição  | Verifica se já existem as perguntas no sistema 			  |
+------------+---------------------------------------------------------+
| Uso:       | Finder Argentina      										     |
+------------+---------------------------------------------------------+
*/

Static Function _fVldPerg()

dbSelectArea("SX1")
dbSetOrder(1)

If !DbSeek(cPerg + "01")
	While !RecLock("SX1",.t.)
	Enddo
	SX1->X1_GRUPO   := cPerg
	SX1->X1_ORDEM   := "01"
	SX1->X1_PERGUNT := "Tabela  ?"
	SX1->X1_PERSPA  := "¿Tabla ?"
	SX1->X1_VARIAVL := "mv_ch1"
	SX1->X1_TIPO    := "C"
	SX1->X1_TAMANHO := 3
	SX1->X1_GSC     := "G"
	SX1->X1_VAR01   := "mv_par01"
	MsUnLock()

EndIf

Return

Static Function ConvNum(cNUM,_cField)
Local y
	while (y := At(".", cNum)) > 0
		cNum := SubStr(cNum,0,y-1)+SubStr(cNum,y+1) 
	enddo
	while (y := At(",", cNum)) > 0
		cNum := SubStr(cNum,0,y-1)+"."+SubStr(cNum,y+1) 
	enddo	                            
Return (NoRound(Val(cNum),TamSx3(_cField)[2]))


//Atualiza o numero do pedido de venda e item , na SUB
User Function IGENM04C()
Local _cSQL := _cTab := "", _nCont := 0

_cTab := GetNextAlias()
_cSQL := "Select Distinct UA_FILIAL,UA_NUM,UA_NUMSC5 from " + RetSqlName("SUA") + " UA "
_cSQL += "Inner Join " + RetSqlName("SUB") + " UB on UB_FILIAL = UA_FILIAL And UB_NUM = UA_NUM And UB.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("SC6") + " C6 on C6_FILIAL = UA_FILIAL And C6_NUM = UA_NUMSC5 And C6.D_E_L_E_T_ = ' ' "
_cSQL += "Where UA_NUMSC5 <> ' ' And UB_NUMPV = ' ' And Ua.D_E_L_E_T_ = ' ' And UA__MOTCAN = ' ' And UA.Ua_Doc = ' ' "
_cSQL += "Order By UA_FILIAL,UA_NUM "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL ), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

While !Eof()	
	DbSelectArea("SC6")
	DbSetOrder(1)
	If DbSeek((_cTab)->UA_FILIAL + (_cTab)->UA_NUMSC5)
		_nCont++
		While !Eof() .And. SC6->C6_FILIAL == (_cTab)->UA_FILIAL .And. !Empty(SC6->C6__TMKNUM) .And. !Empty(SC6->C6__TMKITE) .And.; 
							SC6->C6__TMKNUM == (_cTab)->UA_NUM .And. SC6->C6_NUM == (_cTab)->UA_NUMSC5
			DbSelectArea("SUB")
			DbSetOrder(1)
			If DbSeek((_cTab)->UA_FILIAL + SC6->C6__TMKNUM + SC6->C6__TMKITE) .And. SUB->UB_FILIAL == (_cTab)->UA_FILIAL .And. SUB->UB_NUM == (_cTab)->UA_NUM
				If Reclock("SUB",.f.)
					SUB->UB_NUMPV   := SC6->C6_NUM
					SUB->UB_ITEMPV  := SC6->C6_ITEM
					SUB->UB__COMIS1 := SC6->C6_COMIS1
					MsUnlock()
				EndIf
			EndIf
			
			DbSelectArea("SC6")
			DbSkip()
		EndDo
	EndIf
	
	DbSelectArea(_cTab)
	DbSkip()
EndDo

MsgInfo(_nCont)
Return


User Function IGENM04R()
Local _cSQL := _cTab := "", _ncount := 0

_cTab := GetNextAlias()
_cSQL := "Select distinct F2_FILIAL,F2_DOC,F2_SERIE,UA_FILIAL,UA_NUM from " + RetSqlName("SF2") + " F2 "
_cSQL += "Inner join " + RetSqlName("SD2") + " D2 on D2_FILIAL = F2_FILIAL And D2_DOC = F2_DOC And D2_SERIE = F2_SERIE And D2_CLIENTE = F2_CLIENTE And D2.D_E_L_E_T_ = ' '
_cSQL += "Inner join " + RetSqlName("SC5") + " C5 on C5_FILIAL = D2_FILIAL And C5_num = D2_PEDIDO ANd C5__NUMSUA <> ' ' And C5.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("SUA") + " UA on UA_FILIAL = C5_FILIAL And UA_NUMSC5 = C5_NUM ANd UA.D_E_L_E_T_ = ' ' "
_cSQL += "Inner Join " + RetSqlName("Z10") + " Z0 on Z10_FILIAL = UA_FILIAL ANd Z10_CODSUA = UA_NUM And Z10_QTD > 0 And Z0.D_E_L_E_T_ = ' ' "
_cSQL += "Where F2.D_E_L_E_T_ = ' ' And F2_TIPO = 'N' "
_cSQL += "Order By F2_FILIAL,F2_DOC,F2_SERIE "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL ), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

ProcRegua((_cTab)->(LastRec()))

While !Eof()
	//Mata a reserva dos itens na Z10
    U_ITMKEST1((_cTab)->UA_FILIAL,(_cTab)->UA_NUM,"","","",0,"E")
	_ncount++
	DbSelectArea(_cTab)
	DbSkip()
EndDo

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

msgalert(_ncount)

Return



User Function IGENM04V()
Local _cSQL := _cTab := "", _nCount := 0

_cTab := GetNextAlias()
_cSQL := "Select UA.* From " + RetSqlName("SUA") + " UA "
_cSQL += "Left Join " + RetSqlName("AD7") + " D7 On AD7_FILIAL = UA_FILIAL And AD7__PED = UA_NUM And D7.D_E_L_E_T_ = ' ' "
_cSQL += "Where UA_CANC <> 'S' And (UA__RESEST = 'S' Or UA_DOC <> ' ') And UA_OPER = '1' And UA.D_E_L_E_T_ = ' ' And AD7__PED Is null And UA__TIPPED <> '6' "
_cSQL += "Order By UA_FILIAL, UA_NUM"

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL ), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

While !Eof()
	cFilAnt := (_cTab)->UA_FILIAL
	
	DbSelectArea("AD7")
	DbOrderNickName("AD7NUMPED")
	If !DbSeek((_cTab)->UA_FILIAL + (_cTab)->UA_NUM)
 		If Reclock("AD7", .T.)
   			AD7->AD7_FILIAL := xFilial("AD7")
    		AD7->AD7_TOPICO	:= "VISITOU E COMPROU"
    		AD7->AD7_DATA  	:= STOD((_cTab)->UA_EMISSAO)
    		AD7->AD7_HORA1  := (_cTab)->UA_INICIO
    		AD7->AD7_HORA2  := (_cTab)->UA_FIM
   			AD7->AD7_NROPOR := "" 
   			AD7->AD7_CODCLI := (_cTab)->UA_CLIENTE
   			AD7->AD7_LOJA   := (_cTab)->UA_LOJA
   			AD7->AD7_VEND   := (_cTab)->UA_VEND
   			AD7->AD7_ORIGEM := "2"
   			AD7->AD7_PROSPE := ""
   			AD7->AD7_CONTAT := (_cTab)->UA_CODCONT
   			AD7->AD7__NUM   := GetSXENum("AD7","AD7__NUM")
   			AD7->AD7__DTPRE := STOD((_cTab)->UA_PROXLIG)
   			AD7->AD7__DTVIS := STOD((_cTab)->UA_EMISSAO)
   			AD7->AD7__DTPRX := STOD((_cTab)->UA_PROXLIG)
   			AD7->AD7__STAT  := Alltrim(GETMV("MV__MOTVIS"))
   			AD7->AD7__PREP  := ""
   			AD7->AD7__TPOPE := (_cTab)->UA_TMK
   			AD7->AD7__PED   := (_cTab)->UA_NUM
   			AD7->AD7__OPERA := (_cTab)->UA_OPERADO
   			AD7->(MsUnlock())
	 		
	 		ConfirmSX8()
	 		
	 		_nCount++
 		endif		
    EndIf

	DbSelectArea(_cTab)
	DbSkip()
EndDo

MsgInfo(_nCount)

Return


User Function IGENM04O()
Local _cSQL := _cTab := "", _nCount := 0

_cTab := GetNextAlias()
_cSQL := "Select ADE_FILIAL,ADE_CODIGO,ADE_OPERAD,ADE.R_E_C_N_O_ ADE_RECNO from " + RetSqlName("ADE") + " ADE "
_cSQL += "Where ADE_OPERAD = ' ' And D_E_L_E_T_ = ' ' "
_cSQL += "Order By ADE_CODIGO "

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

dbUseArea(.T., "TOPCONN", TCGenQry( Nil, Nil, _cSQL ), _cTab, .T., .F. )

DbSelectArea(_cTab)
DbGoTop()

While !Eof()

	DbSelectArea("ADF")
	DbSetOrder(1)
	If DbSeek((_cTab)->ADE_FILIAL + (_cTab)->ADE_CODIGO) .And. Empty((_cTab)->ADE_OPERAD)
		DbSelectArea("ADE")
		DbGoTo((_cTab)->ADE_RECNO)
		Reclock("ADE",.f.)
		ADE->ADE_OPERAD := ADF->ADF_CODSU7
		MsUnlock()
	EndIf

	DbSelectArea(_cTab)
	DbSkip()
EndDo

If Select(_cTab) > 0
	DbSelectArea(_cTab)
	DbCloseArea()
EndIf

Return