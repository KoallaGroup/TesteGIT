
#include "Protheus.ch"
#include "Topconn.ch"

/*
|-------------------------------------------------------------------------------------------------------|	
|	Programa : F040BROW			  		| 		Junho de 2015				  							|
|-------------------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi													|
|-------------------------------------------------------------------------------------------------------|	
|	Descrição : Ponto de entrada para filtrar dados na funcao contas a receber.										|
|-------------------------------------------------------------------------------------------------------|	
*/

User Function F040BROW()     

Local cObsCred	:= GetMV("MV__OBSCRE")  
Local _cUsuario := Substr(cUsuario,7,15)
Local _cGrupo := ""      
Local _aUserGRP := UsrRetGrp(__cUserId) 
local _aArea 	:= getArea()
Local _cSegto 	:= ""

dbSelectArea("SZ1")
dbSetOrder(1)
if dbSeek(xFilial("SZ1")+__cUserId)
	_cSegto := SZ1->Z1_SEGISP
else
	_cSegto := '0'
endif

     cSetFilter := "E1_TIPO == 'NCC' .And. E1_SALDO > 0 .And. E1_CLIENTE+E1_LOJA = Posicione('SA1',10,xFilial('SA1')+E1_CLIENTE+E1_LOJA+'"+_cSegto+"','A1_COD+A1_LOJA')"
     If Alltrim(_cSegto) == '1' 
    	 bSetFilter := {||E1_TIPO == 'NCC' .And. E1_SALDO > 0 .And. E1_CLIENTE+E1_LOJA = Posicione('SA1',10,xFilial('SA1')+E1_CLIENTE+E1_LOJA+'1','A1_COD+A1_LOJA') } 
    	 //FILTRO CRIADO PARA VISUALIZACAO APENAS DAS NCC's
		 For i:=1 To Len(_aUserGRP)
		 	_cGrupo := _aUserGRP[i] 
			If _cGrupo $ cObsCred	
		  		DbSelectArea("SE1") 
		  		DbSetOrder(1)
		  		SE1->(dbSetFilter( bSetFilter , cSetFilter ))
	    	 EndIf
		 Next
	 ElseIf Alltrim(_cSegto) == "2"   
	     bSetFilter := {||E1_TIPO == 'NCC' .And. E1_SALDO > 0 .And. E1_CLIENTE+E1_LOJA = Posicione('SA1',10,xFilial('SA1')+E1_CLIENTE+E1_LOJA+'2','A1_COD+A1_LOJA') } 
	     //FILTRO CRIADO PARA VISUALIZACAO APENAS DAS NCC's
		 For i:=1 To Len(_aUserGRP)
		 	_cGrupo := _aUserGRP[i] 
			If _cGrupo $ cObsCred	
		  		DbSelectArea("SE1") 
		  		DbSetOrder(1)
		  		SE1->(dbSetFilter( bSetFilter , cSetFilter ))
	    	 EndIf
		 Next
     EndIf

	 //-------------------------------------------------
	 
	    
restarea(_aArea)
return                     

