#include "protheus.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : MTA035MNU			  		| 	Fevereiro de 2014								|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Programa criado para filtrar de acordo com o segmento	   					  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function MTA035MNU()

    local _cSegto := ""                        
     
    if funname() == 'MATA035'              
		dbSelectArea("SZ1")
		dbSetOrder(1)
		if dbSeek(xFilial("SZ1")+__cUserId)
			_cSegto := SZ1->Z1_SEGISP
		else
			_cSegto := '0'
		endif	
	
		if _cSegto <> '0'
		    dbSelectArea("SBM")     
		    set filter to &("BM__SEGISP == '" + _cSegto + "'")
		endif    
	endif
	    
return