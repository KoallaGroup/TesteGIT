#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ICON01			  		| 	Setembro de 2015				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior - Anadi										|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Utiliado em LP para comissões												  	|
|-----------------------------------------------------------------------------------------------|	
*/

user Function ICON01(_opcCALC)

	local _aArea	:= GetArea()
	local _aReturn	:= {}
	local _opcCALC
	local _cQuery 	:= ""    
	local _nTotal	:= 0

	if _opcCALC == 'PRE'  // PRÊMIO
	
		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000035','000034','000032','000033','000031','000030','000098','000040','000024','000025','000026',"
		_cQuery += "					 '000027','000029','000028','000077','000086','000087','000088','000089','000090','000091','000078',"
		_cQuery += "					 '000079','000080','000081','000082','000083','000084','000085','000051','000043','000045','000047',"
		_cQuery += "					 '000050','000049','000097','000095','000062','000038','000096') "	

	elseif _opcCALC == 'EST' // ESTORNO
	
		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000076','000058','000100','000007','000099','000048','000012','000011','000060') "

	elseif _opcCALC == 'RDV' // REEMB DUP VENC
	
		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000044','000066','000013','000101','000008','000069') "

	elseif _opcCALC == 'IRF' // IR	
	
		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000005','999999') "
	    
	elseif _opcCALC == 'BNP' // BAIXA NP

		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000042','000073','000018','000072','000057','000055','000071','000016','000020','000021','000054',"
		_cQuery += "					 '000019','000056','000053','000070','000017') "

	
	elseif _opcCALC == 'CSC' // Comissao sob. Consultoria

		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and E3__TPLANC IN ('000074') "
				
	
	elseif _opcCALC == 'CMP' // COMISSÃO

		_cQuery := "select SUM(E3_COMIS) TOTAL "
		_cQuery += "from SE3010 
		_cQuery += "where E3_PROCCOM = ('" + SE2->E2_FILIAL + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "') "
		_cQuery += "  and D_E_L_E_T_ = ' ' "
		_cQuery += "  and trim(E3__TPLANC) is null "	

	endif

	if _cQuery <> ''	    
		TCQUERY _cQuery NEW ALIAS "TMPTOTAL"
		_nTotal := TMPTOTAL->TOTAL
		TMPTOTAL->(dbCloseArea())
	endif
	
	if _nTotal < 0
		_nTotal := _nTotal * -1
	endif
		
	RestArea(_aArea)

return _nTotal
