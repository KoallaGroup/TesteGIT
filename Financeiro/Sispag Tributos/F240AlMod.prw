#INCLUDE "rwmake.ch"
#include "fileio.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³F240AlMod º Autor ³ Henrique Martins   º Data ³  16/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Troca de codigo para GNRE                                  º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Isapa                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function F240TGRV()

Local cPath := MV_PAR04
Local cArq
Local nHdl

If SE2->E2__GPS01 == "99"

// Se for especificado o drive no caminho do arquivo, sera criado no
// Client, caso contrario sera criado no Server, no diretorio RooPath.
cArq := "C:\TEMP\teste.rem"
nHdl := FCreate(cArq)

If nHdl == -1
    MsgAlert("O arquivo " + cArq + " nao pode ser criado!", "Atencao!")
    Return Nil
Endif

FClose(nHdl)

//MsgInfo("Arquivo TXT gerado!")


// Abrir o arquivo error.log para escrita e gravação compartilhada.
nHandle := fopen( cPath , FO_READWRITE + FO_SHARED )
If nHandle == -1
      MsgStop('Erro de abertura : FERROR '+str(ferror(),4))
Else

// Caracteres de final de linha.
cEOL := Chr(13)+Chr(10)

nTamArq := FSeek(nHandle, 0, 2)                  // Posiciona o ponteiro no final do arquivo.
FSeek(nHandle, 0, 0)                             // Volta o ponteiro para o inicio do arquivo.
nTamLin     := 240 + Len(cEOL)                             // Tamanho da linha = 43 + 2 ref. ao Chr(13)+Chr(10)
cLinha      := Space(nTamLin)                 // Variavel que contera a linha lida.
nBytesLidos := FRead(nHandle, @cLinha, nTamLin)  // Le uma linha.
cTexto      := ""

nHdl := fopen( cArq , FO_READWRITE + FO_SHARED )
If nHdl == -1
    MsgAlert("O arquivo " + cArq + " nao pode ser criado!", "Atencao!")
    Return Nil
Endif

While nBytesLidos >= nTamLin

   /*
   SZ1NNNNNNNNNNNNNNNNNNNN99999999999            Conta.....: Arq(3), Nome(20), Saldo(11), Espaços(9)
   SZ299/99/99THHHHHHHHHHHHHHHHHHHH99999999999   Transacoes: Arq(3), Data(8), Tipo(1), Historico(20), Valor(11)
   */

   If Substr(cLinha, 12,2) == "13"                // Conta.
   
   cLinha := Substr(cLinha, 1,11) + "91" + Substr(cLinha, 14,242)
      
   EndIf
   
   FWrite(nHdl, cLinha)
   
   nBytesLidos := FRead(nHandle, @cLinha, nTamLin)

End
	
     // MsgStop('Arquivo aberto com sucesso.')
      fclose(nHandle) // Fecha arquivo
      //FErase(cPath)   // Deleta Arquivo 
      If FERASE(cPath) == -1      
      MsgStop('Falha na deleção do Arquivo')
      Else      
      //MsgStop('Arquivo deletado com sucesso.')
      Endif
      FClose(nHdl)    //fecha Arquivo
      __CopyFile( cArq, cPath )
      
Endif

EndIf

Return .T.
