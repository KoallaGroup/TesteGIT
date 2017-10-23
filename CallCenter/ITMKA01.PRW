#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA01			  		| 	Fevereiro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Programa criado para filtrar de acordo com o segmento	   					  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function ITMKA01()

    local _cSegto := ""   
     
	dbSelectArea("SZ1")
	dbSetOrder(1)
	if dbSeek(xFilial("SZ1")+__cUserId)
		_cSegto := SZ1->Z1_SEGISP
	else
		_cSegto := '0'
	endif	

	if _cSegto <> '0'
	    dbSelectArea("SU7")     
	    set filter to &("U7__SEGISP == '" + _cSegto + "'")
	endif    

	TMKA090()
	
	set filter to
	    
return