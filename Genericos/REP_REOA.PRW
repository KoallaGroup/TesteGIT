#include "topconn.ch"

user function REP_REOA() 


	_cQuery :=	"select D1_FILIAL, D1_LOCAL, D1_DOC, D1_SERIE, D1_FORNECE, D1_LOJA, D1_ITEM, D1_QUANT, D1_COD, D1_DTDIGIT, SD1.R_E_C_N_O_, Z12.Z12_DOC "
	
	_cQuery +=	"from SD1010 SD1 "
	
	_cQuery +=	"inner join (select F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA "
	_cQuery +=	"            from SF1010 SF1 "
	_cQuery +=	"            where SF1.D_E_L_E_T_ = ' ' "
	_cQuery +=	"              and SF1.F1_FILIAL = '06' "
	_cQuery +=	"              and SF1.F1_TIPO IN ('N', 'D')  "
	_cQuery +=	"              and F1_EMISSAO >= '20150501' "
	_cQuery +=	"            ) ON D1_DOC = F1_DOC "
	_cQuery +=	"             and D1_SERIE = F1_SERIE "
	_cQuery +=	"             and D1_FORNECE = F1_FORNECE "
	_cQuery +=	"             and D1_FILIAL = F1_FILIAL "
	
	_cQuery +=	"inner join SB1010 SB1 ON B1_COD = D1_COD "
	_cQuery +=	"                     and SB1.D_E_L_E_T_ = ' ' "
	
	_cQuery +=	"inner join SYD010 SYD ON YD_TEC = B1_POSIPI "
	_cQuery +=	"                 AND SYD.D_E_L_E_T_ = ' ' "
	_cQuery +=	"                 and YD__CTREOA = '1' "
	
	_cQuery +=	"left join Z12010 Z12 ON Z12_FILIAL = D1_FILIAL "
	_cQuery +=	"                     and Z12_FORNEC = D1_FORNECE "
	_cQuery +=	"                     and Z12_LOJA = D1_LOJA "
	_cQuery +=	"                     and Z12_DOC = D1_DOC "
	_cQuery +=	"                     and Z12_SERIE = D1_SERIE "
	_cQuery +=	"                     and Z12.D_E_L_E_T_ = ' ' "
	
	_cQuery +=	"join SF4010 SF4 ON F4_CODIGO = D1_TES "
    _cQuery +=	"           AND F4_FILIAL = D1_FILIAL "
    _cQuery +=	"           AND SF4.D_E_L_E_T_ = ' ' "
    _cQuery +=	"           and F4_ESTOQUE = 'S' "

	_cQuery +=	"where D1_FILIAL = '06' "
	_cQuery +=	"  and SD1.D_E_L_E_T_ = ' ' "
	_cQuery +=	"  and Z12_DOC is null "
	  
	_cQuery +=	"order by D1_DOC, D1_SERIE, D1_FORNECE, D1_ITEM "

	TCQUERY _cQuery NEW ALIAS "ENTREOA" 
	TCSetField("ENTREOA","D1_DTDIGIT","D")

    do while ! ENTREOA->(eof())
        
		dbSelectArea("Z12")
	
		if reclock("Z12", .T.)
		
		    Z12->Z12_FILIAL	:= "06"
		    Z12->Z12_LOCAL 	:= ENTREOA->D1_LOCAL
		    Z12->Z12_DOC   	:= ENTREOA->D1_DOC
		    Z12->Z12_SERIE 	:= ENTREOA->D1_SERIE
		    Z12->Z12_FORNEC	:= ENTREOA->D1_FORNECE
		    Z12->Z12_LOJA  	:= ENTREOA->D1_LOJA
		    Z12->Z12_ITEM  	:= ENTREOA->D1_ITEM 
		    Z12->Z12_QUANT 	:= ENTREOA->D1_QUANT
		    Z12->Z12_CODPRO	:= ENTREOA->D1_COD
		    Z12->Z12_SALDO 	:= ENTREOA->D1_QUANT
		    Z12->Z12_DTENTR	:= ENTREOA->D1_DTDIGIT
		    Z12->Z12_RECSD1	:= ENTREOA->R_E_C_N_O_
		    		
			msUnlock()
		endif


		ENTREOA->(dbSkip())
	enddo

	_cQuery :=	"select sum(Z11_QTDEUT) Z11_QTDEUT, max(D2_QUANT) D2_QTDE, max(d2_DOC) D2_DOC, max(d2_SERIE) D2_SERIE, max(D2_ITEM) D2_ITEM, max(D2_COD) D2_COD, MAX(D2_CLIENTE) D2_CLIENTE, max(D2_LOJA) D2_LOJA "
	_cQuery +=	"from SD2010 SD2 "
	_cQuery +=	"left join Z11010 Z11 ON D2_DOC = Z11_DOCSAI "
	_cQuery +=	"                     and D2_SERIE = Z11_SERSAI "
	_cQuery +=	"                     and D2_ITEM = Z11_ITEMSA "
	_cQuery +=	"                     and SD2.D2_EMISSAO >= '20150501' "
	_cQuery +=	"                     and Z11.D_E_L_E_T_ = ' ' "
	_cQuery +=	"where D2_FILIAL = '06' "
	_cQuery +=	"  and SD2.d_e_L_e_T_ = ' ' "    
//	_cQuery +=	"  and D2_COD = '29332' "    
	_cQuery +=	"group by D2_DOC, D2_ITEM "
	
	TCQUERY _cQuery NEW ALIAS "SAIREOA" 
    
    do while ! SAIREOA->(eof())
		if (SAIREOA->D2_QTDE - SAIREOA->Z11_QTDEUT) > 0

		    _nQtde  := SAIREOA->D2_QTDE - SAIREOA->Z11_QTDEUT

			_cQuery := "SELECT * "
			_cQuery += "FROM " + retSqlname("Z12") + " Z12 "
			_cQuery += "WHERE Z12_CODPRO = '" + SAIREOA->D2_COD  + "' "
			_cQuery += "  AND Z12.Z12_FILIAL = '06' "
			_cQuery += "  AND Z12.D_E_L_E_T_ <> '*' "
			_cQuery += "  AND Z12_SALDO > 0 "
			_cQuery += "ORDER BY R_E_C_N_O_ "
	
			If(select("TMPZ12") > 0)
				TMPZ12->(dbCloseArea())
			endif
			TCQUERY _cQuery NEW ALIAS "TMPZ12"  	

		    do while ! TMPZ12->(eof())

				_nQtdeUtilizado := 0
				if _nQtde < TMPZ12->Z12_SALDO
					_nQtdeUtilizado := _nQtde
				else
					_nQtdeUtilizado := TMPZ12->Z12_SALDO
				endif     
				_nQtde -= _nQtdeUtilizado

	            dbSelectArea("Z11")		
				if reclock("Z11", .T.)

					Z11->Z11_FILIAL	:= "06"
					Z11->Z11_DOCENT := TMPZ12->Z12_DOC
					Z11->Z11_SERENT	:= TMPZ12->Z12_SERIE
					Z11->Z11_FORNEC	:= TMPZ12->Z12_FORNEC
					Z11->Z11_LOJA  	:= TMPZ12->Z12_LOJA
					Z11->Z11_ITEMEN := TMPZ12->Z12_ITEM
					Z11->Z11_DOCSAI	:= SAIREOA->D2_DOC
					Z11->Z11_SERSAI	:= SAIREOA->D2_SERIE
					Z11->Z11_ITEMSA	:= SAIREOA->D2_ITEM
					Z11->Z11_CLIENT	:= SAIREOA->D2_CLIENTE
					Z11->Z11_LOJACL	:= SAIREOA->D2_LOJA    
					Z11->Z11_CODPRO	:= SAIREOA->D2_COD
					Z11->Z11_QTDEUT	:= _nQtdeUtilizado  
/*
					Z11->Z11_VLREOA	:= _aValores[2]
					Z11->Z11_BSREOA	:= _aValores[1]
					Z11->Z11_ICMENT	:= _aValores[3]
					Z11->Z11_MVA	:= _aValores[4]
					Z11->Z11_VA		:= _aValores[5]
					Z11->Z11_ALQINT	:= _aValores[6]
					
					Z11->Z11_DATA	:= dDataBase
*/
					msUnlock()					
	            endif
	
				dbSelectArea("Z12")
				dbSetOrder(1) 
				if dbSeek("06"+TMPZ12->Z12_DOC+TMPZ12->Z12_SERIE+TMPZ12->Z12_FORNEC+TMPZ12->Z12_LOJA+TMPZ12->Z12_CODPRO)
					if reclock("Z12", .F.)
				    	Z12->Z12_SALDO	-= _nQtdeUtilizado
						msUnlock()					
					endif
				endif
	             	
             	if _nQtde == 0
             		exit             	
             	endif
	            
             	TMPZ12->(dbSkip())
          	enddo
					
        endif     
		SAIREOA->(dbSkip())
	enddo
         
	ENTREOA->(dbCloseArea())
	SAIREOA->(dbCloseArea())
return