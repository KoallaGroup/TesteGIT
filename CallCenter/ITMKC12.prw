#INCLUDE "PROTHEUS.CH"
#INCLUDE "rwmake.ch"
#INCLUDE "TopConn.ch"
                                            
/*
+------------+---------+-------+-------------------------------------+------+----------------+
| Programa   | ITMKC12 | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Dezembro/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Consulta para informar valor total do pedido com e sem IPI					 |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
*/   

User Function ITMKC12()
Local _nPosVlr 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB_VLRITEM" })
Local _nPosIpi 	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__VALIPI" })
Local _nPosST  	:= ASCAN(aHeader, { |x| AllTrim(x[2]) == "UB__VALIST" })
Local _nPosDel	:= Len(aHeader) + 1
Local nMargDir	:= 0
Local aStru		:= {010,70}
Local nLinha	:= 10
Local nvlrTot	:= 0
Local nTotIpi	:= 0
Local nTotSt	:= 0

Private oFontn 	:= tFont():New("Tahoma",,-11,,.T.)
Private oDlgTMP


For nX := 1 To Len(aCols) 
	If(!aCols[nX][_nPosDel])
		nvlrTot += aCols[nX][_nPosVlr]
		nTotIpi += aCols[nX][_nPosIpi]
		nTotSt  += aCols[nX][_nPosST]
	EndIf
Next nX


DEFINE MSDIALOG oDlgTMP TITLE "Valor Total Dos Produtos" From 0,0 To 150,300 OF oMainWnd PIXEL
nMargDir := (oDlgTMP:nCLientWidth / 2) - 10

@nLinha, aStru[1] Say "Valor Total :"				SIZE 100,10 OF oDlgTMP PIXEL FONT oFontn
@nLinha, aStru[2] Say nvlrTot 						SIZE 030,10 OF oDlgTMP PIXEL PICTURE "@E 99,999,999.99"
nLinha += 16

@nLinha, aStru[1] Say "Valor Total + IPI :"			SIZE 100,10 OF oDlgTMP PIXEL FONT oFontn
@nLinha, aStru[2] Say nvlrTot + nTotIpi 			SIZE 030,10 OF oDlgTMP PIXEL PICTURE "@E 99,999,999.99"
nLinha += 16

@nLinha, aStru[1] say "Valor Total + IPI + ST :" 	SIZE 100,10 OF oDlgTMP PIXEL FONT oFontn
@nLinha, aStru[2] Say nvlrTot + nTotIpi + nTotSt	SIZE 030,10 OF oDlgTMP PIXEL PICTURE "@E 99,999,999.99"
nLinha += 16

@nLinha,nMargDir-30 Button oButton PROMPT "Fechar"  SIZE 030,10 OF oDlgTMP PIXEL ACTION (oDlgTMP:End())

ACTIVATE MSDIALOG oDlgTMP CENTERED

Return