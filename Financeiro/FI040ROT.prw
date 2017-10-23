
#include "Protheus.ch"
#include "Topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : FI040ROT			  		| 		Setembro de 2015				  						|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi													|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada inserir opcnoes no acoes relacionadas contas a receber.										|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function FI040ROT()              

Local aRot := {}
Local bCondicao :={|| E1_TIPO == "NCC" .And. E1_SALDO > 0} 
Local cObsCred	:= GetMV("MV__OBSCRE")  
Local _cUsuario := Substr(cUsuario,7,15)
Local _cGrupo := ""      
Local _aUserGRP := UsrRetGrp(__cUserId)

If funname() == 'FINA040'
	aRot := ParamIxb
	For i:=1 To Len(_aUserGRP)
		_cGrupo := _aUserGRP[i] 
		If _cGrupo $ cObsCred	                                 
			aadd( aRot, { "Obs. de Credito", "U_IFINA20()", 0, 10 } )
        EndIf
	Next
Else
	return()
EndIf

	 //------------------------------------------------- 
	 
Return aRot   