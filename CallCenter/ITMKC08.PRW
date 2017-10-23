#Include "Protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKC08			  		| 	Novembro de 2014			  						|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Tela para facilitar o preenchimento de observações do pedido				  	|
|-----------------------------------------------------------------------------------------------|	
*/


User Function ITMKC08()
	Local cAliasOrg	:= GetArea()
	Private oDlg

	oFont := tFont():New("Tahoma",,-14,,.F.)

	_mObsCom := M->UA__OBSCOM
	_mObsFin := M->UA__OBSFIN
	_cObs    := M->UA_OBS //MSMM(M->UA_CODOBS)
	
	DEFINE MSDIALOG oDlg TITLE "Observações" From 0,0 To 450,825 OF oMainWnd PIXEL

   	@ 2,15 SAY "Observação Pedido" SIZE 200, 10 OF oDlg PIXEL FONT oFont 
	@ 01,2 get _cObs MEMO	size 380,050 of oDlg

   	@ 67,15 SAY "Observação Comercial" SIZE 200, 10 OF oDlg PIXEL FONT oFont 
	@ 06,2 get _mObsCom MEMO	size 380,050 of oDlg

   	@ 132,15 SAY "Observação Financeira" SIZE 200, 10 OF oDlg PIXEL FONT oFont 
	@ 11,2 get _mObsFin MEMO	size 380,050 of oDlg	

    @ 210,200 Button oButton PROMPT "Gravar"  	 SIZE 40,10   OF oDlg PIXEL ACTION atualiza()
    @ 210,300 Button oButton PROMPT "Fechar"  	 SIZE 40,10   OF oDlg PIXEL ACTION oDlg:End()

	oDlg:lCentered := .T.
	oDlg:Activate()
	
	RestArea(cAliasOrg)
	
Return 


static function atualiza()
	
	M->UA__OBSFIN := _mObsFin
	M->UA__OBSCOM := _mObsCom 	
	M->UA_OBS 	  := _cObs 	

	oDlg:End()
	
	//Atualiza a gravação online
	U_ITMKGRON("SUA","")                                                                     

return
