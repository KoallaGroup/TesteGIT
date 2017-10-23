#INCLUDE "PROTHEUS.CH"
#include "rwmake.ch"
#include "topconn.ch"

user Function MS520DEL()
	local _aArea	:= GetArea()
	local _cDocto
	local _cSerie
	local _cFornecedor
	local _cLoja
	local _cItem
	local _nQtdeUtilizado
    
    SD2->(msUnlock()) 
	
	_cQuery := "SELECT * "
	_cQuery += "FROM " + retSqlname("SD2") + " SD2 "
	_cQuery += "WHERE D2_FILIAL = '" + SF2->F2_FILIAL  + "' "
	_cQuery += "  AND D2_DOC = '" + SF2->F2_DOC +  "' "
	_cQuery += "  AND D2_SERIE = '" + SF2->F2_SERIE +  "' "
	_cQuery += "  AND D_E_L_E_T_ <> '*' "

	if(select("TMPSD2") > 0)
		TMPSD2->(dbCloseArea())
	endif
	TCQUERY _cQuery NEW ALIAS "TMPSD2"

	do while ! TMPSD2->(eof())

		dbSelectArea("Z11")		
		dbSetOrder(2)
		if dbSeek(xFilial("Z11")+SF2->F2_DOC+SF2->F2_SERIE+SF2->F2_CLIENTE+SF2->F2_LOJA+TMPSD2->D2_ITEM)
			do while Z11->Z11_DOCSA==SF2->F2_DOC .and. Z11->Z11_SERSAI==SF2->F2_SERIE .and. Z11->Z11_CLIENT==SF2->F2_CLIENTE .and. Z11->Z11_LOJACL==SF2->F2_LOJA .and. Z11->Z11_ITEMSA==TMPSD2->D2_ITEM
				_cDocto			:= Z11->Z11_DOCENT
				_cSerie			:= Z11->Z11_SERENT
				_cFornecedor	:= Z11->Z11_FORNEC
				_cLoja			:= Z11->Z11_LOJA  
				_cItem			:= Z11->Z11_ITEMEN  
				_cProd			:= Z11->Z11_CODPRO
				_nQtdeUtilizado	:= Z11->Z11_QTDEUT

				if reclock("Z11", .F.)
					Z11->(dbDelete())
					msUnlock()
				endif
				
				dbSelectArea("Z12")
				dbSetOrder(1)         
				if dbSeek(xFilial("Z12")+_cDocto+_cSerie+_cFornecedor+_cLoja+_cProd)
					if reclock("Z12", .F.)
				    	Z12->Z12_SALDO	+= _nQtdeUtilizado
					endif
				endif
					

				Z11->(dbSkip())
			enddo			

       	endif
      	TMPSD2->( dbSkip() )
	enddo
	
	restarea(_aArea)

return