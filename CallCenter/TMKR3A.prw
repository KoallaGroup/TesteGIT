#include 'rwmake.ch'
#include 'apwebex.ch'
#include 'TOPCONN.ch'
#include 'TbiConn.ch'
#include 'TbiCode.ch'
#include 'ap5mail.ch'
#include "Protheus.Ch"

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | TMKR3A  | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Ponto de entrada para chamada do relatório ITMKR01           |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function TMKR3A(cPedido)

Local aArea 	:= getArea(), _aLog := {}
Local cOptions 	:= "6;0;1;Cotacao_" + cPedido
Local cAnexo	:= "\Relatorios\Cotacao_" + cPedido + ".pdf"
Local cAssunto	:= "Cotação Cliente: " + Alltrim(SUA->UA_CLIENTE)
Local cPara		:= space(TAMSX3("A1_EMAIL")[1])
Local cCC		:= space(TAMSX3("A1_EMAIL")[1])
Local cCorpo	:= "Prezado cliente, Segue sua cotação."
Local oFont		:= tFont():New("Tahoma",,14,,.t.)
Local _cParam   := cPedido + ";" + SUA->UA_FILIAL, _cMsg := ""

Private oDlg
Private aButtons
Private lOk	:= .F.

DbSelectArea("SU5")
DbSetOrder(1)
If DbSeek(xFilial("SU5") + SUA->UA_CODCONT)
	cPara := Lower(SU5->U5_EMAIL)
Else
	DbSelectArea("SA1")
	DbSetOrder(1)
	If DbSeek(xFilial("SA1") + SUA->UA_CLIENTE + SUA->UA_LOJA)
		cPara := Lower(SA1->A1_EMAIL)
	EndIf
EndIf

CallCrys('ITMKCR10',_cParam,cOptions)
	
DEFINE MSDIALOG oDlg TITLE "Confirma e-mail do Cliente ?" FROM 000, 000  TO 150, 500 PIXEL

@ 11,010 SAY "E-mail : " SIZE 100, 10 OF oDlg PIXEL FONT oFont
@ 10,040 MsGet cPara Size 200,10 of oDlg PIXEL FONT oFont

@ 31,010 SAY "C.Cópia : " SIZE 100, 10 OF oDlg PIXEL FONT oFont
@ 30,040 MsGet cCC Size 200,10 of oDlg PIXEL FONT oFont

ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||lOk := .T.,oDlg:End()},{||lOk := .F.,oDlg:End()},,aButtons)

If lOk
	
	cPara 	:= Alltrim(Lower(cPara))
	
	cCC 	:= Alltrim(Lower(cCC))

    //U_ITMKR01(cPedido)	
	//U_EnvEmail(cPara,cCC,cAssunto,cCorpo,cAnexo)
	_cFrom := _cReply := IIF(Val(SUA->UA__SEGISP) = 2,"pgodoy@isapa.com.br","sfbueno@isapa.com.br")
	
	If Empty(cCC)
	   cCC := _cFrom
	Else
	   cCC += IIF(!(_cFrom $ cCC), ";" + Alltrim(_cFrom),"")
	EndIf
	
	//_cFrom := _cReply := IIF(Val(SUA->UA__SEGISP) = 2,"errao@ig.com.br","errao@ig.com.br")
		
	AADD(_aLog,U_IGENENV2(getmv("MV_RELSERV"),getmv("MV_RELACNT"),getmv("MV_RELAPSW"),0,getmv("MV_RELAUTH"),cAssunto,cCorpo,_cReply,_cFrom,cPara,cCC,,"text/html",cAnexo))
	
    If _aLog[Len(_aLog)][1] != 0 .And. !Empty(_aLog[Len(_aLog)][2])
        MsgAlert("Nao foi possivel enviar e-mail ao cliente" + CHR(13)+ CHR(10) + CHR(13)+ CHR(10) + _aLog[Len(_aLog)][2],"FALHA - ENVIO COTACAO")
    EndIf
	
EndIf

RestArea(aArea)

Return

/*
+------------+---------+--------+--------------------+-------+--------------+
| Programa:  | TMKR3A  | Autor: | Rogério Alves      | Data: | Outubro/2014 |
+------------+---------+--------+--------------------+-------+--------------+
| Descrição: | Chama rotina de envio de e-mail                              |
+------------+--------------------------------------------------------------+
| Uso:       | Isapa                                                        |
+------------+--------------------------------------------------------------+
*/

User Function EnvEmail(cPara,cCC,cAssunto,cCorpo,cAnexo)


Local aArea  := GetArea()

Local cServer 	:= getmv("MV_RELSERV")	//Nome do Servidor de Envio de E-mail
Local cConta  	:= getmv("MV_RELACNT")	//Conta a ser utilizada no envio de E-Mail para os  relatórios
Local cFrom 	:= getmv("MV_RELACNT")
Local cPass   	:= getmv("MV_RELAPSW")	//Senha para autenticacäo no servidor de e-mail

Local lExc 	:= lMail := .F.
Local nTry 	:= 1


CONNECT SMTP SERVER AllTrim(cServer) ACCOUNT AllTrim(cConta) PASSWORD cPass RESULT lExc

MailAuth(AllTrim(cConta), cPass)  // força a autenticação em provedores que necessitam disso...

SEND MAIL FROM AllTrim(cFrom) TO AllTrim(cPara) CC AllTrim(cCC) SUBJECT AllTrim(cAssunto) BODY cCorpo RESULT lMail ATTACHMENT cAnexo

If !lMail
	While !lMail .And. nTry <= 120
		SEND MAIL FROM AllTrim(cFrom) TO AllTrim(cPara) CC AllTrim(cCC) SUBJECT AllTrim(cAssunto) BODY cCorpo RESULT lMail ATTACHMENT cAnexo
		nTry ++
	EndDo
EndIf

DISCONNECT SMTP SERVER

RestArea(aArea)

Return