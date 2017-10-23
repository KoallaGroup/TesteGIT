#INCLUDE "protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ-ÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³GH999999  ³ Autor ³ MICROSIGA             ³ Data ³ 31/08/2013 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄ-ÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao Principal                                           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Gestao Hospitalar                                          ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ-ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
USER Function IUPDSZ10()

cArqEmp 					:= "SigaMat.Emp"
__cInterNet 	:= Nil

PRIVATE cMessage
PRIVATE aArqUpd	 := {}
PRIVATE aREOPEN	 := {}
PRIVATE oMainWnd
Private nModulo 	:= 51 // modulo SIGAHSP

Set Dele On

lEmpenho				:= .F.
lAtuMnu					:= .F.

Processa({|| ProcATU()},"Processando [IUPDSZ10]","Aguarde , processando preparação dos arquivos")

Return()


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ProcATU   ³ Autor ³                       ³ Data ³  /  /    ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Funcao de processamento da gravacao dos arquivos           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Baseado na funcao criada por Eduardo Riera em 01/02/2002   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function ProcATU()
Local cTexto    	:= ""
Local cFile     	:= ""
Local cMask     	:= "Arquivos Texto (*.TXT) |*.txt|"
Local nRecno    	:= 0
Local nI        	:= 0
Local nX        	:= 0
Local aRecnoSM0 	:= {}
Local lOpen     	:= .F.

ProcRegua(1)
IncProc("Verificando integridade dos dicionários....")
If (lOpen := IIF(Alias() <> "SM0", MyOpenSm0Ex(), .T. ))

	dbSelectArea("SM0")
	dbGotop()
	While !Eof()
  		If Ascan(aRecnoSM0,{ |x| x[2] == M0_CODIGO}) == 0
			Aadd(aRecnoSM0,{Recno(),M0_CODIGO})
		EndIf			
		dbSkip()
	EndDo	

	If lOpen
		For nI := 1 To Len(aRecnoSM0)
			SM0->(dbGoto(aRecnoSM0[nI,1]))
			RpcSetType(2)
			RpcSetEnv(SM0->M0_CODIGO, SM0->M0_CODFIL)
 		nModulo := 51 // modulo SIGAHSP
			lMsFinalAuto := .F.
			cTexto += Replicate("-",128)+CHR(13)+CHR(10)
			cTexto += "Empresa : "+SM0->M0_CODIGO+SM0->M0_NOME+CHR(13)+CHR(10)

			ProcRegua(8)

			Begin Transaction

			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de arquivos.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Arquivos...")
			cTexto += GeraSX2()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza o dicionario de dados.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando Dicionario de Dados...")
			cTexto += GeraSX3()
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³Atualiza os indices.³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			IncProc("Analisando arquivos de índices. "+"Empresa : "+SM0->M0_CODIGO+" Filial : "+SM0->M0_CODFIL+"-"+SM0->M0_NOME)
			cTexto += GeraSIX()

			End Transaction
	
			__SetX31Mode(.F.)
			For nX := 1 To Len(aArqUpd)
				IncProc("Atualizando estruturas. Aguarde... ["+aArqUpd[nx]+"]")
				If Select(aArqUpd[nx])>0
					dbSelecTArea(aArqUpd[nx])
					dbCloseArea()
				EndIf
				X31UpdTable(aArqUpd[nx])
				If __GetX31Error()
					Alert(__GetX31Trace())
					Aviso("Atencao!","Ocorreu um erro desconhecido durante a atualizacao da tabela : "+ aArqUpd[nx] + ". Verifique a integridade do dicionario e da tabela.",{"Continuar"},2)
					cTexto += "Ocorreu um erro desconhecido durante a atualizacao da estrutura da tabela : "+aArqUpd[nx] +CHR(13)+CHR(10)
				EndIf
				dbSelectArea(aArqUpd[nx])
			Next nX		

			RpcClearEnv()
			If !( lOpen := MyOpenSm0Ex() )
				Exit
		 EndIf
		Next nI
		
		If lOpen
			
			cTexto 				:= "Log da atualizacao " + CHR(13) + CHR(10) + cTexto
			__cFileLog := MemoWrite(Criatrab(,.f.) + ".LOG", cTexto)
			
			DEFINE FONT oFont NAME "Mono AS" SIZE 5,12
			DEFINE MSDIALOG oDlg TITLE "Atualizador [GH999999] - Atualizacao concluida." From 3,0 to 340,417 PIXEL
				@ 5,5 GET oMemo  VAR cTexto MEMO SIZE 200,145 OF oDlg PIXEL
				oMemo:bRClicked := {||AllwaysTrue()}
				oMemo:oFont:=oFont
				DEFINE SBUTTON  FROM 153,175 TYPE 1 ACTION oDlg:End() ENABLE OF oDlg PIXEL //Apaga
				DEFINE SBUTTON  FROM 153,145 TYPE 13 ACTION (cFile:=cGetFile(cMask,""),If(cFile="",.t.,MemoWrite(cFile,cTexto))) ENABLE OF oDlg PIXEL //Salva e Apaga //"Salvar Como..."
			ACTIVATE MSDIALOG oDlg CENTER
	
		EndIf
		
	EndIf
		
EndIf 	

Return(Nil)


/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³MyOpenSM0Ex³ Autor ³Sergio Silveira       ³ Data ³07/01/2003³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Efetua a abertura do SM0 exclusivo                         ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ Atualizacao FIS                                            ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
Static Function MyOpenSM0Ex()

Local lOpen := .F.
Local nLoop := 0

For nLoop := 1 To 20
	dbUseArea( .T.,, "SIGAMAT.EMP", "SM0", .F., .F. )
	If !Empty( Select( "SM0" ) )
		lOpen := .T.
		dbSetIndex("SIGAMAT.IND")
		Exit	
	EndIf
	Sleep( 500 )
Next nLoop

If !lOpen
	Aviso( "Atencao !", "Nao foi possivel a abertura da tabela de empresas de forma exclusiva !", { "Ok" }, 2 )
EndIf

Return( lOpen )




/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX2  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX2()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z10","\DATA\                                  ","Z10010  ","RESERVA ONLINE                ","RESERVA ONLINE                ","RESERVA ONLINE                ","                                        ","C","C","C",00," ","                                                                                                                                                                                                                                                          "," ",00,"                                                                                                                                                                                                                                                              ","                              ","                              "})

dbSelectArea("SX2")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX2", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX2 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSX3  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSX3()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z10","01","Z10_FILIAL","C",02,00,"Filial      ","Sucursal    ","Branch      ","Filial do Sistema        ","Sucursal                 ","Branch of the System     ","@!                                           ","                                                                                                                                ","€€€€€€€€€€€€€€€","                                                                                                                                ","      ",01,"þÀ"," "," ","U","N"," "," "," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","033"," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," "," "," ","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","02","Z10_CODSUA","C",06,00,"Cod Orc     ","Cod Orc     ","Cod Orc     ","Cod Orc                  ","Cod Orc                  ","Cod Orc                  ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","03","Z10_ITEM  ","C",02,00,"Item        ","Item        ","Item        ","                         ","                         ","                         ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","S","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","04","Z10_PROD  ","C",15,00,"Produto     ","Produto     ","Produto     ","                         ","                         ","                         ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","SB1   ",00,"þÀ"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","05","Z10_LOCAL ","C",02,00,"LOCAL       ","LOCAL       ","LOCAL       ","                         ","                         ","                         ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","06","Z10_QTD   ","N",17,02,"Qtdade      ","Qtdade      ","Qtdade      ","                         ","                         ","                         ","@E 99,999,999,999,999.99                     ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","07","Z10_DATA  ","D",08,00,"Data        ","Data        ","Data        ","                         ","                         ","                         ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","A","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})
AADD(aRegs,{"Z10","08","Z10_HORA  ","C",05,00,"HORA        ","HORA        ","HORA        ","                         ","                         ","                         ","                                             ","                                                                                                                                ","€€€€€€€€€€€€€€ ","                                                                                                                                ","      ",00,"þÀ"," "," ","U","N","V","R"," ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                                                                                                                                ","                    ","                                                            ","                                                                                ","   "," "," ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "," ","N","N","               ","   ","N","N","N"})

dbSelectArea("SX3")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(2)
 lInclui := !DbSeek(aRegs[i, 3])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SX3", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SX3 : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSIX  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSIX()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"Z10","1","Z10_FILIAL+Z10_CODSUA+Z10_ITEM                                                                                                                                  ","Cod Orc+Item                                                          ","Cod Orc+Item                                                          ","Cod Orc+Item                                                          ","U","                                                                                                                                                                ","          ","S"})
AADD(aRegs,{"Z10","2","Z10_FILIAL+Z10_PROD+Z10_LOCAL                                                                                                                                   ","Produto+LOCAL                                                         ","Produto+LOCAL                                                         ","Produto+LOCAL                                                         ","U","                                                                                                                                                                ","          ","S"})

dbSelectArea("SIX")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 If(Ascan(aArqUpd, aRegs[i,1]) == 0)
 	aAdd(aArqUpd, aRegs[i,1])
 EndIf

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2])
 If !lInclui
  TcInternal(60,RetSqlName(aRegs[i, 1]) + "|" + RetSqlName(aRegs[i, 1]) + aRegs[i, 2])
 Endif

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SIX", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SIX : ' + cTexto  + CHR(13) + CHR(10))
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡ao    ³ GeraSXB  ³ Autor ³ MICROSIGA             ³ Data ³   /  /   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡ao ³ Funcao generica para copia de dicionarios                  ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Uso       ³ Generico                                                   ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/
Static Function GeraSXB()
Local aArea 			:= GetArea()
Local i      		:= 0
Local j      		:= 0
Local aRegs  		:= {}
Local cTexto 		:= ''
Local lInclui		:= .F.

aRegs  := {}
AADD(aRegs,{"      "," ","  ","  ","Nome                ","Nombre              ","Name                ","                                                                                                                                                                                                                                                          ","                                                                                                                                                                                                                                                          "})

dbSelectArea("SXB")
dbSetOrder(1)

For i := 1 To Len(aRegs)

 dbSetOrder(1)
 lInclui := !DbSeek(aRegs[i, 1] + aRegs[i, 2] + aRegs[i, 3] + aRegs[i, 4])

 cTexto += IIf( aRegs[i,1] $ cTexto, "", aRegs[i,1] + "\")

 RecLock("SXB", lInclui)
  For j := 1 to FCount()
   If j <= Len(aRegs[i])
   	If allTrim(Field(j)) == "X2_ARQUIVO"
   		aRegs[i,j] := SubStr(aRegs[i,j], 1, 3) + SM0->M0_CODIGO + "0"
   	EndIf
    If !lInclui .AND. AllTrim(Field(j)) == "X3_ORDEM"
     Loop
    Else
     FieldPut(j,aRegs[i,j])
    EndIf
   Endif
  Next
 MsUnlock()
Next i


RestArea(aArea)
Return('SXB : ' + cTexto  + CHR(13) + CHR(10))
