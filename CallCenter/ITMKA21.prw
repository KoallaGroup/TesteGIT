#include "protheus.ch"
#INCLUDE "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA21				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Consulta para alterar as comissões do pedido de venda					  	  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function ITMKA21(cPedido)      
Local _aArea	:= GetArea()
Local _aAreaSC5	:= SC5->(GetArea())
Local _aAreaSC6	:= SC6->(GetArea())
Local _aAreaSUA	:= SUA->(GetArea())
Local _aAreaSUB	:= SC5->(GetArea())
Local aCampos  	:= {}               
Local aButtons 	:= {{"EDIT", { || ITMKA21C()  },"Definir comissoes" } }
Local cTipo		:= ""
Local cCliente	:= ""
Local cLoja		:= ""
Local cCliDes	:= ""
Local cEnd		:= ""
Local nQtdCpo   := 0
Local nCols     := 0
Local nComis	:= 0
Local n			:= 0
Local nStyle    := /*GD_INSERT+GD_DELETE+*/GD_UPDATE
Local nPos_Doc	:= 0
Local nPos_Seri := 0
Local nPos_Emis	:= 0
Local nPos_Tipo	:= 0
Local nPos_ValB	:= 0

Private nQtde 		:= 0
Private nDesc 		:= 0
Private aHeaderB    := {}
Private aColsB      := {}
Private oGetTM1     := Nil
Private oDlgTMP     := Nil
Private aSize       := MsAdvSize(.T.)
Private aEdit       := {"UB__COMIS1"}
Private aRotina     := .F.
Private cLoja       := ""
Private oFont14	    := tFont():New("Tahoma",,-14,,.t.)
Private oFont12	    := tFont():New("Tahoma",,-12,,.t.)

default	cPedido		:= ""

If(Empty(cPedido))
	alert("Codigo do pedido não informado")
	return
EndIf

//Preenche cabeçalho da MSDIALOG
DbSelectArea("SUA")
DbSetOrder(1) //UA_FILIAL+UA_NUM
dbSeek(xFilial("SUA") + cPedido)

dData  		:= DTOC(SUA->UA_EMISSAO)
cTipo  		:= SUA->UA_OPER
cCliente   	:= SUA->UA_CLIENTE
cLoja		:= SUA->UA_LOJA

DbSelectArea("SA1")
DbSetOrder(1)
dbSeek(xFilial("SA1") + cCliente + cLoja)

cCliDes		:= SA1->A1_NREDUZ
cEnd		:= alltrim(SA1->A1_END) + " - " + alltrim(SA1->A1_BAIRRO) + " - " + SA1->A1_EST

aObjects 	:= {}
AAdd(aObjects,{100,030,.t.,.f.})
AAdd(aObjects,{400,400,.t.,.t.})

aInfo	 	:= { aSize[1], aSize[2], aSize[3], aSize[4], 3, 3 }
aPosObj	 	:= MsObjSize( ainfo, aObjects )

CriaHeader()
CriaCols(cPedido)

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

@ aPosObj[2,3]-003,aPosObj[2,2]+002 MsGet  nComis Picture "@E 99.99" Size 40,10 of oDlgTMP PIXEL 
@ aPosObj[2,3]-003,aPosObj[2,2]+060 Button oButton PROMPT "Alterar comissões"  	 SIZE 60,13   OF oDlgTMP PIXEL ACTION ITMKA21C(nComis)

@ aPosObj[2,3]-3,aPosObj[2,4]-160 Button oButton PROMPT "Confirmar"  			 SIZE 60,13   OF oDlgTMP PIXEL ACTION (ITMKA21G(),oDlgTMP:End())
@ aPosObj[2,3]-3,aPosObj[2,4]-080 Button oButton PROMPT "Fechar"  	 			 SIZE 60,13   OF oDlgTMP PIXEL ACTION oDlgTMP:End()

ACTIVATE MSDIALOG oDlgTMP CENTERED //ON INIT EnchoiceBar(oDlgTMP,{||ITMKA21G(),oDlgTMP:End()},{||oDlgTMP:End()},,aButtons)   

RestArea(_aAreaSC5)
RestArea(_aAreaSC6)
RestArea(_aAreaSUA)
RestArea(_aAreaSUB)
RestArea(_aArea)

Return .T.

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaHeader			 			| 	Maio de 2014					  			|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aHeader															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaHeader()
aHeaderB      := {}
/*
aCpoHeader   := {"UB_ITEM",;
				 "UB_PRODUTO",;
				 "B1_DESC",;
				 "UA__PREPOS",; //Campo usado apenas para pegar as caracteristicas da SX3
				 "UB_QUANT",;
				 "UB_VALDESC",;
				 "UB__DESC2",; //Desc1
				 "UB__DESC3",; //Desc2
				 "UB__DESCP ",; //Desc Promo
				 "UB__DESCCP",; //Desc Vend
				 "UB_VRUNIT",;
				 "UB__COMIS1",; //Comissao
				 "UB__ALQIPI",;
				 "B1__SUBGRP"}
*/

aCpoHeader   := {"UB_ITEM",;
                 "UB_PRODUTO",;
                 "B1_DESC",;
                 "UA__PREPOS",; //Campo usado apenas para pegar as caracteristicas da SX3
                 "UB_QUANT",;
                 "UB__DESC2",; //Desc1
                 "UB__DESC3",; //Desc2
                 "UB__DESCP ",; //Desc Promo
                 "UB__DESCCP",; //Desc Vend
                 "UB_VRUNIT",;
                 "UB__COMIS1",; //Comissao
                 "UB__ALQIPI",;
                 "B1__SUBGRP"}                 
				 
For _nElemHead := 1 To Len(aCpoHeader)
	_cCpoHead := aCpoHeader[_nElemHead]
	dbSelectArea("SX3")
	dbSetOrder(2)
	If DbSeek(_cCpoHead) .And. !("UB_VRUNIT" $ _cCpoHead) .And. !("UB_PRODUTO" $ _cCpoHead)
		AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
		SX3->X3_Campo       ,;
		SX3->X3_Picture     ,;
		SX3->X3_Tamanho     ,;
		SX3->X3_Decimal     ,;
		SX3->X3_Valid       ,;
		SX3->X3_Usado       ,;
		SX3->X3_Tipo        ,;
		SX3->X3_F3		    ,;
		SX3->X3_Context		,;
		SX3->X3_Cbox		,;
		SX3->X3_RELACAO		,;
		SX3->X3_WHEN		,;
		SX3->X3_VISUAL})
    ElseIf DbSeek(_cCpoHead) .And. ("UB_VRUNIT" $ _cCpoHead)
        AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
        SX3->X3_Campo       ,;
        SX3->X3_Picture     ,;
        SX3->X3_Tamanho-3   ,;
        SX3->X3_Decimal     ,;
        SX3->X3_Valid       ,;
        SX3->X3_Usado       ,;
        SX3->X3_Tipo        ,;
        SX3->X3_F3          ,;
        SX3->X3_Context     ,;
        SX3->X3_Cbox        ,;
        SX3->X3_RELACAO     ,;
        SX3->X3_WHEN        ,;
        SX3->X3_VISUAL})
    ElseIf DbSeek(_cCpoHead) .And. ("UB_PRODUTO" $ _cCpoHead)
        AAdd(aHeaderB, {Trim(SX3->X3_Titulo),;
        SX3->X3_Campo       ,;
        "@S10"              ,;
        SX3->X3_Tamanho     ,;
        SX3->X3_Decimal     ,;
        SX3->X3_Valid       ,;
        SX3->X3_Usado       ,;
        SX3->X3_Tipo        ,;
        SX3->X3_F3          ,;
        SX3->X3_Context     ,;
        SX3->X3_Cbox        ,;
        SX3->X3_RELACAO     ,;
        SX3->X3_WHEN        ,;
        SX3->X3_VISUAL})        
	EndIf
Next _nElemHead

dbSelectArea("SX3")
dbSetOrder(1)

AADD( aHeaderB, { "Recno WT", "UA_REC_WT", "", 09, 0,,, "N", "SUA", "V"} )

//Ajusta formato de campos

nPos_COMIS1  	:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__COMIS1" }) 
nPos_Promo 		:=  ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA__PREPOS" }) 

aHeaderB[nPos_COMIS1][14]	:= "A"
aHeaderB[nPos_Promo] [01]	:= "Promo"

Return Nil 

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA21C				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Altea todas as comissoe para um valor definido pelo usuario				  	  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ITMKA21C(nComis)
Local nX		:= 0
Local nPosComis := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UB__COMIS1"	})
Local lRet 		:= .F.

Private oDlgCom
                               

/*DEFINE MSDIALOG oDlgCom TITLE "Nova comissao" FROM 0,0 TO 100,250 OF oMainWnd PIXEL
@ 015,010 Say  "Comissao" Size 050,010 OF oDlgCom PIXEL
@ 014,035 MSGET nComiss SIZE 060,010 OF oDlgCom     PIXEL PICTURE "@E 99.99" 

oSBtn1  := SButton():New( 030,012,1,{|| lRet := .T.,oDlgCom:End()}	,oDlgCom,,"", ) //OK
oSBtn2  := SButton():New( 030,070,2,{|| oDlgCom:End()}				,oDlgCom,,"", ) //Cancelar

ACTIVATE MSDIALOG oDlgCom
*/

If nComis > 0
	For nX := 1 To Len(oGetTM1:aCols)	
		oGetTM1:aCols[nX][nPosComis] := nComis
	Next nX
EndIf    

oGetTM1:Refresh()

Return

/*
|-----------------------------------------------------------------------------------------------|
|	Programa : CriaCols				 	| 	Maio de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi		 												|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Criação do aCols															  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function CriaCols(cPedido)
Local   n			:= 0 
Local 	nPos_Seq 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_ITEM"		})
Local	nPos_Cod 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_PRODUTO"	})
Local	nPos_Desc 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1_DESC"		})
Local	nPos_SGrp 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "B1__SUBGRP" 	})
Local	nPos_Promo 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UA__PREPOS" }) 
Local	nPos_Quan	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_QUANT" 	})
Local	nPos_Des1	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VALDESC" 	})
Local   nPos_DesCP	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__DESCCP"	})
Local   nPos_DesP	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__DESCP"	})
Local   nPos_Alpi	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__ALQIPI"	})
Local   nPos_Des2	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__DESC2"	})
Local   nPos_Des3	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__DESC3"   })
Local   nPos_Com	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB__COMIS1"  })
Local	nPos_Vlr 	:= ASCAN(aHeaderB, { |x| AllTrim(x[2]) == "UB_VRUNIT" 	})
Local	nQtdCpo 	:= Len(aHeaderB), _nPerCom := 0

If(select("TRB_SUB") > 0)
	TRB_SUB->(DbCloseArea())
EndIf
             

_cQuery := "SELECT SUB.UB_PRODUTO,                                                             "
_cQuery += "SUB.UB_ITEM,                                                                       "
_cQuery += "SB1.B1_DESC,                                                                       "
_cQuery += "SB1.B1__SUBGRP,                                                                    "
_cQuery += "SUB.UB_QUANT,                                                                      "
_cQuery += "SUB.UB_VALDESC,                                                                    "
_cQuery += "SUB.UB__DESCCP,																	   "
_cQuery += "SUB.UB__DESCP, 																	   "
_cQuery += "SUB.UB__ALQIPI,																	   "
_cQuery += "SUB.UB__DESC2,                                                                     "
_cQuery += "SUB.UB__DESC3,                                                                     "
_cQuery += "SUB.UB__COMIS1,                                                                    "
_cQuery += "SUB.UB_VRUNIT,                                                                     "
_cQuery += "SUB.UB_NUMPV,                                                                      "
_cQuery += "SUB.UB_ITEMPV,                                                        			   "
_cQuery += "SUB.R_E_C_N_O_ RECNO															   "
_cQuery += "FROM " + RetSqlName("SUB") + " SUB                                                 "
_cQuery += "INNER JOIN " + RetSqlName("SB1") + " SB1 ON SB1.B1_FILIAL = '" + xFilial("SB1") + "'  AND      "
_cQuery += "SB1.B1_COD = SUB.UB_PRODUTO AND                                                    "
_cQuery += "SB1.D_E_L_E_T_ = ' '                                                               "
_cQuery += "WHERE SUB.UB_FILIAL = '" + xFilial("SUB") + "' And SUB.UB_NUM = '" + cPedido + "' And SUB.D_E_L_E_T_ = ' ' "
_cQuery := ChangeQuery(_cQuery)
TcQuery _cQuery New Alias "TRB_SUB"

AcolsB := {}

If(Empty(TRB_SUB->UB_PRODUTO))
	n++
	AAdd(AcolsB, Array(nQtdCpo+1))
	
	AcolsB[n][nQtdCpo+1]  	 	:= .F.
	AcolsB[n][nPos_Seq]		   	:= "0001"
	AcolsB[n][nPos_Cod]	 	 	:= space(TamSx3("UB_PRODUTO")[1])
	AcolsB[n][nPos_Desc] 		:= space(TamSx3("B1_DESC")[1])
	AcolsB[n][nPos_Promo] 		:= " "
	AcolsB[n][nPos_Quan] 	 	:= 0
	AcolsB[n][nPos_DesCP]		:= 0
	AcolsB[n][nPos_DesP]		:= 0
	AcolsB[n][nPos_Alpi]		:= 0
	AcolsB[n][nPos_SGrp]		:= space(TamSx3("B1__SUBGRP")[1])
	//AcolsB[n][nPos_Des1] 	 	:= 0
	AcolsB[n][nPos_Des2] 	 	:= 0
	AcolsB[n][nPos_Des3] 	 	:= 0
	AcolsB[n][nPos_Com] 	 	:= 0
	AcolsB[n][nPos_Vlr] 	 	:= 0
	AcolsB[n][Len(aHeaderB)] 	:= 0
	AcolsB[n][Len(aHeaderB)+1]	:= .F.
EndIf

DbSelectArea("TRB_SUB")
While !TRB_SUB->(eof())
	n++
	AAdd(AcolsB, Array(nQtdCpo+1))

    dbSelectArea("SUB")
    dbGoTo(TRB_SUB->RECNO)
    cChave := xFilial("SC6")+TRB_SUB->UB_NUMPV+TRB_SUB->UB_ITEMPV+TRB_SUB->UB_PRODUTO 

    dbSelectArea("SC6")
    DbSetOrder(1)
    DbGoTop()
    DbSeek(cChave)

    DbSelectArea("SC5")
	DbSetOrder(1)
	DbSeek(xFilial("SC5") + TRB_SUB->UB_NUMPV)
	
	_nPerCom := IIF(SC5->C5_COMIS1 > 0, 0, SC6->C6_COMIS1) //Verifica se a comissão é por pedido ou por item
	
	If _nPercom == 0
		_nPercom := TRB_SUB->UB__COMIS1
	EndIf
	
	AcolsB[n][nPos_Seq]	  	 	:= TRB_SUB->UB_ITEM
	AcolsB[n][nPos_Cod]	 	 	:= TRB_SUB->UB_PRODUTO
	AcolsB[n][nPos_Desc] 		:= TRB_SUB->B1_DESC
	AcolsB[n][nPos_Promo] 		:= IIF(TRB_SUB->UB__DESCP > 0,"P"," ")
	AcolsB[n][nPos_SGrp]		:= TRB_SUB->B1__SUBGRP
	AcolsB[n][nPos_Quan] 	 	:= TRB_SUB->UB_QUANT
	AcolsB[n][nPos_DesCP]		:= TRB_SUB->UB__DESCCP
	AcolsB[n][nPos_DesP]		:= TRB_SUB->UB__DESCP 
	AcolsB[n][nPos_Alpi]		:= TRB_SUB->UB__ALQIPI
	//AcolsB[n][nPos_Des1] 	 	:= TRB_SUB->UB_VALDESC
	AcolsB[n][nPos_Des2] 	 	:= TRB_SUB->UB__DESC2
	AcolsB[n][nPos_Des3] 	 	:= TRB_SUB->UB__DESC3
	AcolsB[n][nPos_Com] 	 	:= _nPerCom //TRB_SUB->UB__COMIS1
	AcolsB[n][nPos_Vlr] 	 	:= TRB_SUB->UB_VRUNIT
	AcolsB[n][Len(aHeaderB)] 	:= TRB_SUB->RECNO
	AcolsB[n][Len(aHeaderB)+1]	:= .F.
	
	TRB_SUB->(DbSkip())
EndDo

TRB_SUB->(dbCloseArea())

Return       
                                                       
/*
|-----------------------------------------------------------------------------------------------|
|	Programa : ITMKA21G				 	| 	Maio de 2014		  		         			 	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rubens Cruz - Anadi														|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Grava as comissoes na SUB												  	  	|
|-----------------------------------------------------------------------------------------------|
*/

Static Function ITMKA21G()
Local nPosRec	:= len(oGetTM1:aHeader)     
Local nPosComis := ASCAN(oGetTM1:aHeader, { |x| AllTrim(x[2]) == "UB__COMIS1"	})
Local cNumPV	:= ""
Local cChave	:= ""

For nX := 1 To Len(oGetTM1:aCols)
	dbSelectArea("SUB")
	dbGoTo(oGetTM1:aCols[nX][nPosRec])
	cChave := xFilial("SC6")+SUB->UB_NUMPV+SUB->UB_ITEMPV+SUB->UB_PRODUTO 

	If Reclock("SUB",.F.)
		SUB->UB__COMIS1 := oGetTM1:aCols[nX][nPosComis]
		MsUnlock()
	EndIf       

	dbSelectArea("SC6")
	DbSetOrder(1)
	DbGoTop()
	if DbSeek(cChave)
		If Reclock("SC6",.F.)
			SC6->C6_COMIS1 := oGetTM1:aCols[nX][nPosComis] 
			MsUnlock()
		EndIf
	EndIf
	     
Next nX                

Return