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
| Programa   | ITMKC13 | Autor | Rubens Cruz	- Anadi Soluções 	 | Data | Dezembro/2014	 |
+------------+---------+-------+-------------------------------------+------+----------------+
| Descricao  | Funcao para exibir os itens dos pedido 										 |
+------------+-------------------------------------------------------------------------------+
| Uso        | ISAPA													 					 |
+------------+-------------------------------------------------------------------------------+
| Parametros | _cFilial  = Filial que não será utilizada para o calculo do saldo             |
|			 | _cProduto = Produto usado para calcular o estoque disponivel                  |
|			 | _cLocal   = Local informado para calculo do estoque							 |
+------------+-------------------------------------------------------------------------------+
*/   

User Function ITMKC13()  

Private aSize       := MsAdvSize(.T.)

aObjects 	:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )


//Cria janela

DEFINE MSDIALOG oDlgTMP TITLE "Consulta de comissão" FROM aSize[7],0 To aSize[6],aSize[5] /*aSize[7]-50, 400 TO aSize[6]-200,aSize[5]*/ PIXEL
oDlgTMP:lMaximized := .F.

@ 5,005 Say "Pedido: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,035 MsGet cPedido Picture "@!" Size 40,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

@ 5,080 Say "Cliente: " SIZE 30,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,110 MsGet cCliente Picture "@!" Size 40,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

@ 5,155 Say "Loja: " SIZE 20,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,175 MsGet cLoja Picture "@!" Size 25,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

@ 5,215 Say "Descrição: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 5,255 MsGet cCliDes Picture "@!" Size 150,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

@ 25,005 Say "Endereço: " SIZE 40,10 OF oDlgTMP PIXEL FONT oFont14
@ 25,045 MsGet cEnd Picture "@!" Size 250,10 of oDlgTMP PIXEL FONT oFont14 WHEN .F.

oGetTM1 := MsNewGetDados():New(aPosObj[2,1]+8,aPosObj[2,2],aPosObj[2,3]-8,aPosObj[2,4]/*40, 0, 190, 450*/, nStyle, "AllwaysTrue", "AllwaysTrue", "", aEdit, , , , , , oDlgTMP, aHeaderB, aColsB)

@ aPosObj[2,3]-3,aPosObj[2,4]-080 Button oButton PROMPT "Fechar"  	 			 SIZE 60,13   OF oDlgTMP PIXEL ACTION oDlgTMP:End()

ACTIVATE MSDIALOG oDlgTMP CENTERED 

Return