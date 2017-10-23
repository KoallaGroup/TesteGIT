#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

//-------------------------------------------------------------------
/*/{Protheus.doc} FSTBPRE
Gatilho que retorna o valor standard do produto, multiplicado pelo fator

@author	Ederson Colen
@since	        

@param	cCod		Codigo do produto

@return QSB1->CUSTO	Custo standard * fator
/*/
//-------------------------------------------------------------------
User Function FSTBPRE(cCod)

Local aArea		:= GetArea()
Local nPrcVend	:= 0.00

cMsg := "Qual Fator deverá ser utilizado ? "

nOpcA := Aviso("PRECO DE VENDA",cMsg,{"Dentro","Fora"},1)

SB1->(dbSetOrder(1))
SB1->(dbSeek(xFilial("SB1")+M->DA1_CODPRO))

If nOpca == 1
	If SB1->(! Eof())
		nPrcVend := SB1->B1_CUSTD * SB1->B1_YFATOR
	EndIf
Else
	If SB1->(! Eof())
		nPrcVend := SB1->B1_CUSTD * SB1->B1_YFATOR2
	EndIf
EndIf

Restarea(aArea)

Return(nPrcVend)