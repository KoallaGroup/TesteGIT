#Include "Protheus.ch"

/*
+------------+---------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA35 | Autor: | Rubens Cruz - Anadi Consultoria 		   | Data: | Novembro/2014 |
+------------+---------+--------+------------------------------------------+-------+---------------+
| Descrição: | Tela de atendimento do Call Center												   |
+--------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                               |
+------------+-------------------------------------------------------------------------------------+
*/

User Function ITMKA35(_cPedido,_cTipo)
Local aObjeto 		:= {}
Local aTamAut 		:= MsAdvSize()
Local aPosObj		:= {}      

Private _oDlgPA4 	:= Nil
Private _oEncPA4 	:= Nil       
Private aGets2		:= {}
Private nRet		:= 0
Private _cPedAux	:= ""

Default _cPedido 	:= ""

_cPedAux := _cPedido

AAdd( aObjeto, { 100, 100, .T., .T. } )
aInfo := { aTamAut[ 1 ], aTamAut[ 2 ], aTamAut[ 3 ], aTamAut[ 4 ], 3, 3 } 
aPosObj := MsObjSize( aInfo, aObjeto, .f. ) 
aPosEnch := {aPosObj[1,1],aPosObj[1,2],aPosObj[1,3]-10,aPosObj[1,4]}

DbSelectArea("PA4")                                                                         
RegToMemory("PA4",.T.)

                                                           
DEFINE MSDIALOG _oDlgPA4 TITLE "Aprovação - ISAPA" From aTamAut[7],0 to aTamAut[6],aTamAut[5] of oMainWnd PIXEL
_oEncPA4 := MsMGet():New("PA4",0,3,,,,,aPosEnch,,,,,_oDlgPA4)

If(!Empty(_cPedido))
    M->PA4_PEDIDO := _cPedido
    RunTrigger(3,,,,"PA4_PEDIDO")
EndIf

_oEncPA4:Refresh()

If(FunName() == "IFATA21")
    @aPosObj[1,3]-5,aPosObj[1,4]-350 BUTTON "Comissões"            SIZE 50,14 ACTION ITMKA35A()				OF _oDlgPA4 PIXEL
    @aPosObj[1,3]-5,aPosObj[1,4]-300 BUTTON "Criticas Ped"         SIZE 50,14 ACTION acionaFuncao(1,_cTipo) OF _oDlgPA4 PIXEL
	@aPosObj[1,3]-5,aPosObj[1,4]-250 BUTTON "Itens Pedido"         SIZE 50,14 ACTION acionaFuncao(2,_cTipo) OF _oDlgPA4 PIXEL
	@aPosObj[1,3]-5,aPosObj[1,4]-200 BUTTON "Histórico Aprov."     SIZE 50,14 ACTION acionaFuncao(4,_cTipo) OF _oDlgPA4 PIXEL
Else
    @aPosObj[1,3]-5,aPosObj[1,4]-300 BUTTON "Criticas Ped"         SIZE 50,14 ACTION acionaFuncao(1,_cTipo) OF _oDlgPA4 PIXEL
    @aPosObj[1,3]-5,aPosObj[1,4]-250 BUTTON "Posicao Cliente"      SIZE 50,14 ACTION U_ITMKPOSCLI(M->PA4_CLIENT,M->PA4_LOJA) OF _oDlgPA4 PIXEL
    @aPosObj[1,3]-5,aPosObj[1,4]-200 BUTTON "Histórico Aprov."     SIZE 50,14 ACTION acionaFuncao(4,_cTipo) OF _oDlgPA4 PIXEL
EndIf

@aPosObj[1,3]-5,aPosObj[1,4]-150 BUTTON "Indica Sit."   SIZE 50,14 ACTION acionaFuncao(3,_cTipo) OF _oDlgPA4 PIXEL
@aPosObj[1,3]-5,aPosObj[1,4]-100 BUTTON "Retornar"          SIZE 40,14 ACTION _oDlgPA4:End()  OF _oDlgPA4 PIXEL

ACTIVATE MSDIALOG _oDlgPA4 CENTER

Return nRet 

static function acionaFuncao(_nFunc,_cTipo)
	local _aAreaATU	:= getArea()

	if _nFunc == 1
    	U_ITMKA24(SUA->UA_FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,_cTipo)
 	elseif _nFunc == 2
    	U_ITMKA21(SUA->UA_NUM)
 	elseif _nFunc == 3
    	If U_IFATA13(SUA->UA_FILIAL,SUA->UA_NUM,SUA->UA_CLIENTE,SUA->UA_LOJA,_cTipo)
    		nRet := 3
    		_oDlgPA4:End()
    	EndIf
 	elseif _nFunc == 4
		U_IFATA23(SUA->UA_FILIAL,SUA->UA_NUM, _cTipo)
	endif

	restArea(_aAreaATU)
return     

/*
+------------+----------+--------+------------------------------------------+-------+---------------+
| Programa:  | ITMKA35A | Autor: | Rubens Cruz - Anadi Consultoria 		    | Data: | Dezembro/2014 |
+------------+----------+--------+------------------------------------------+-------+---------------+
| Descrição: | Tela de Consulta para exibir as comissões do representante no pedido				    |
+---------------------------------------------------------------------------------------------------+
| Uso        | Isapa                                                                                |
+------------+--------------------------------------------------------------------------------------+
*/

Static Function ITMKA35A()  
Local _aArea	:= GetArea()
Local _aAreaSA3	:= SA3->(GetArea())
Local nLinha	:= 10
Local aCabec	:= {010,065}
Local nJanTam	:= 0, _nPerCom := 0
Local cVend		:= ""
Local oDlgRep 

cVend := Posicione("SA3",1,xFilial("SA3")+SUA->UA_VEND,"A3_NOME")
DbSelectArea("SC5")
DbSetOrder(1)
If DbSeek(xFilial("SC5") + SUA->UA_NUMSC5)
    If SC5->C5_COMIS1 > 0
        _nPerCom := SC5->C5_COMIS1
    EndIf 
EndIf

DEFINE MSDIALOG oDlgRep TITLE OemToAnsi("Consulta Comissões") From 000,000 To 170,400 OF oMainWnd PIXEL
	nJanTam := (oDlgRep:nClientWidth / 2) -60
		                                           
	@ nLinha,aCabec[1] Say "Representante :"	SIZE 080,10 OF oDlgRep PIXEL FONT oFont 
	@ nLinha,aCabec[2] Say SUA->UA_VEND 		SIZE 080,10 OF oDlgRep PIXEL FONT oFont 
	nLinha += 16

	@ nLinha,aCabec[1] Say "Nome :" 			SIZE 080,10 OF oDlgRep PIXEL FONT oFont 
	@ nLinha,aCabec[2] Say cVend				SIZE 120,10 OF oDlgRep PIXEL FONT oFont 
	nLinha += 16

	@ nLinha,aCabec[1] Say "Comissão (%) :"		SIZE 080,10 OF oDlgRep PIXEL FONT oFont 
	//@ nLinha,aCabec[2] Say SUA->UA_COMIS      SIZE 080,10 OF oDlgRep PIXEL FONT oFont PICTURE "@E 999.99"
	@ nLinha,aCabec[2] Say _nPerCom             SIZE 080,10 OF oDlgRep PIXEL FONT oFont PICTURE "@E 999.99"	
	nLinha += 16
		
	@ nLinha,nJanTam Button oButton PROMPT "Retornar"  SIZE 40,15   OF oDlgRep PIXEL ACTION oDlgRep:End()
ACTIVATE MSDIALOG oDlgRep CENTERED                                                                                 

RestArea(_aArea)
RestArea(_aAreaSA3)

Return