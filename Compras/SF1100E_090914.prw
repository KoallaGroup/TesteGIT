/*
|-----------------------------------------------------------------------------------------------|
|	Programa : SF1100E			  		| 	Julho de 2014					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Rogério Alves Oliveira - Anadi					        					|
|-----------------------------------------------------------------------------------------------|
|	Descrição : Ponto de Entrada na exclusão da NF Entrada	    							  	|
|-----------------------------------------------------------------------------------------------|
*/

User Function SF1100E()

local _aArea := getArea()
local _cNota
local _cSerie
local _cForn
local _cLoja

PRIVATE lMsHelpAuto := .T.
PRIVATE lMsErroAuto := .F.
PRIVATE aProd	:= {}

_cNota 	:= SF1->F1_DOC
_cSerie	:= SF1->F1_SERIE
_cForn	:= SF1->F1_FORNECE
_cLoja	:= SF1->F1_LOJA

DbSelectArea("SD3")
DbOrderNickName("SD3NF")	//D3_FILIAL+D3__DOC+D3__SERIE+D3__FORNEC+D3__LOJA+D3_COD+D3__ITEM
If DbSeek(xFiliaL("SD3") + _cNota + _cSerie + _cForn + _cLoja)

	Begin Transaction
	
	While !(eof()) .and. SD3->D3__DOC == _cNota .and. SD3->D3__SERIE == _cSerie .and. SD3->D3__FORNEC == _cForn .and. SD3->D3__LOJA == _cLoja

		aAdd(aProd, {"D3_NUMSEQ" , SD3->D3_NUMSEQ   , Nil})
		aAdd(aProd, {"INDEX"     , 4        		, Nil})
		     
		MSExecAuto({|x,y| MATA240(x,y)}, aProd, 5) // 5-Estorno
				
		If lMsErroAuto
			MostraErro()
			DisarmTransaction()
			Break
		EndIf

		DbSelectArea("SD3")
		DbSkip()
		
	enddo
	
	End Transaction
	
EndIf

If !Empty(Sf1->F1__DocCod)
	TcSqlExec("UPDATE "+RetSqlName("CD5")+" SET D_E_L_E_T_='*' WHERE CD5_DOC='"+AllTrim(Sf1->F1_Doc)+"' AND CD5_SERIE='"+AllTrim(Sf1->F1_Serie)+"' AND CD5_DOCIMP='"+AllTrim(Sf1->F1__PROIMP)+"' ")
	
EndIf

RestArea(_aArea)

return
