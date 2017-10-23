#INCLUDE "rwmake.ch"
#Include "Protheus.ch"
#Include "totvs.ch"
/*
+-----------+---------+-------+---------------------------------+------+------------+
| Programa  | IGENM01 | Autor | Jorge Henrique - Anadi Soluções | Data | Abril/2014 |
+-----------+---------+-------+---------------------------------+------+------------+
| Descricao | Rotina para execução de User Functions                                |
+-----------+-----------------------------------------------------------------------+
| Uso       | ISAPA                                                                 |
+-----------+-----------------------------------------------------------------------+
*/

User Function IGENM01()
NewDlg1()

Static Function NewDlg1()
Local cFunction := Space(30)
Local oBaca1,oSay1,oSBtn3,oSBtn4,oGet2

oBaca1 := MSDIALOG():Create()
oBaca1:cName := "oBaca1"
oBaca1:cCaption := "Desenvolvimento"
oBaca1:nLeft := 0
oBaca1:nTop := 0
oBaca1:nWidth := 252
oBaca1:nHeight := 133
oBaca1:lShowHint := .F.
oBaca1:lCentered := .T.

oSay1 := TSAY():Create(oBaca1)
oSay1:cName := "oSay1"
oSay1:cCaption := "Informe o programa a ser executado"
oSay1:nLeft := 25
oSay1:nTop := 11
oSay1:nWidth := 180
oSay1:nHeight := 17
oSay1:lShowHint := .F.
oSay1:lReadOnly := .F.
oSay1:Align := 0
oSay1:lVisibleControl := .T.
oSay1:lWordWrap := .F.
oSay1:lTransparent := .F.

oGet2 := TGET():Create(oBaca1)
oGet2:cName := "oGet2"
oGet2:cCaption := "oGet2"
oGet2:nLeft := 18
oGet2:nTop := 42
oGet2:nWidth := 202
oGet2:nHeight := 21
oGet2:lShowHint := .F.
oGet2:lReadOnly := .F.
oGet2:Align := 0
oGet2:cVariable := "cFunction"
oGet2:bSetGet := {|u| If(PCount()>0,cFunction:=u,cFunction) }
oGet2:lVisibleControl := .T.
oGet2:lPassword := .F.
oGet2:Picture := "@!S40"
oGet2:lHasButton := .F.

oSBtn3 := SBUTTON():Create(oBaca1)
oSBtn3:cName := "oSBtn3"
oSBtn3:cCaption := "OK"
oSBtn3:nLeft := 108
oSBtn3:nTop := 68
oSBtn3:nWidth := 52
oSBtn3:nHeight := 22
oSBtn3:lShowHint := .F.
oSBtn3:lReadOnly := .F.
oSBtn3:Align := 0
oSBtn3:lVisibleControl := .T.
oSBtn3:nType := 1
oSBtn3:bAction := {|| BACA11(cFunction) }

oSBtn4 := SBUTTON():Create(oBaca1)
oSBtn4:cName := "oSBtn4"
oSBtn4:cCaption := "Cancela"
oSBtn4:nLeft := 166
oSBtn4:nTop := 68
oSBtn4:nWidth := 52
oSBtn4:nHeight := 22
oSBtn4:lShowHint := .F.
oSBtn4:lReadOnly := .F.
oSBtn4:Align := 0
oSBtn4:lVisibleControl := .T.
oSBtn4:nType := 2
oSBtn4:bAction := {|| Close(obaca1) }

oBaca1:Activate()

Return 



Static Function BACA11(cFunction) 
if !Empty(cFunction)
	if ExistBlock(cFunction, .F., .t.)
		ExecBlock(cFunction, .F., .F.)
	Else
		MsgStop("Função não encontrada","ATENCAO")
	endif	
endif	

Return


User Function TESTESPORA()
Local _cVar := _cvar2 := ""
   _aResult :=	TCSPEXEC("PERP_INTER_MOVIMENTACAO", "WMS","INC",@_cvar,@_cvar2,"01","04","01",10,"000001",CTOD("08/08/14"),"04","01","10008")
Return