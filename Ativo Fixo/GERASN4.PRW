#INCLUDE 'RWMAKE.CH'
#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'TOPCONN.CH'


/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : GERASN4			  		| 	Outubro de 2013					  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos dos Santos Junior												|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Geração de Dados da SN4 a partir da SN1 e SN3								  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function GERASN4()
    
	_cQuery := 	"SELECT N3_CBASE, "
	_cQuery += 	"		N3_ITEM, "
	_cQuery += 	"		N3_TIPO, "
	_cQuery += 	"		N3_FILIAL, "
	_cQuery += 	"		N3_CCONTAB, "
	_cQuery += 	"		N1_QUANTD, "
	_cQuery += 	"		N3_VORIG1, "
	_cQuery += 	"		N3_VORIG2, "
	_cQuery += 	"		N3_VORIG3, "
	_cQuery += 	"		N3_VORIG4, "
	_cQuery += 	"		N3_VORIG5, "
	_cQuery += 	"		N1_NSERIE, "
	_cQuery += 	"		N1_NFISCAL, "
	_cQuery += 	"		N3_TXDEPR1, "
	_cQuery += 	"		N3_CCUSTO, "
	_cQuery += 	"		N1_LOCAL, "
	_cQuery += 	"		N1_DIACTB, "
	_cQuery += 	"		N1_NODIA, "
	_cQuery += 	"		N1_CALCPIS  "
	_cQuery += 	"FROM " + retSqlName("SN1") + " SN1 "
	_cQuery += 	"INNER JOIN " + retSqlName("SN3") + "  SN3 ON N1_FILIAL = N3_FILIAL "
	_cQuery += 	"											AND N1_CBASE = N3_CBASE "
	_cQuery += 	"											AND N1_ITEM = N3_ITEM "
	_cQuery += 	"											AND SN3.D_E_L_E_T_ <> '*' "
	_cQuery += 	"WHERE SN1.D_E_L_E_T_ <> '*' "
	
	TCQUERY _cQuery NEW ALIAS "TMPQRY"  
	
	_cSeq := "0000000000"
	
	do while ! TMPQRY->(eof())
		                        
		_cSeq := soma1(_cSeq)
		
		dbSelectArea("SN4")
		
		reclock("SN4", .T.)

		SN4->N4_FILIAL	:= TMPQRY->N3_FILIAL
		SN4->N4_CBASE 	:= TMPQRY->N3_CBASE	
		SN4->N4_ITEM	:= TMPQRY->N3_ITEM
		SN4->N4_TIPO	:= TMPQRY->N3_TIPO
		SN4->N4_OCORR 	:= '05'
		SN4->N4_MOTIVO	:= ''
		SN4->N4_TIPOCNT := '1'
		SN4->N4_CONTA 	:= TMPQRY->N3_CCONTAB
		SN4->N4_DATA	:= date()
		SN4->N4_QUANTD 	:= TMPQRY->N1_QUANTD
		SN4->N4_VLROC1 	:= TMPQRY->N3_VORIG1
		SN4->N4_VLROC2 	:= TMPQRY->N3_VORIG2
		SN4->N4_VLROC3 	:= TMPQRY->N3_VORIG3
		SN4->N4_VLROC4 	:= TMPQRY->N3_VORIG4
		SN4->N4_VLROC5 	:= TMPQRY->N3_VORIG5
		SN4->N4_SERIE 	:= TMPQRY->N1_NSERIE
		SN4->N4_NOTA	:= TMPQRY->N1_NFISCAL
		SN4->N4_TXDEPR 	:= TMPQRY->N3_TXDEPR1
		SN4->N4_CCUSTO 	:= TMPQRY->N3_CCUSTO
		SN4->N4_LOCAL 	:= TMPQRY->N1_LOCAL
		SN4->N4_SEQ 	:= '001'
		SN4->N4_IDMOV 	:= _cSeq
		SN4->N4_DIACTB 	:= TMPQRY->N1_DIACTB 
		SN4->N4_NODIA 	:= TMPQRY->N1_NODIA 
//		SN4->N4_CALCPIS := TMPQRY->N1_CALCPIS 
						
	    SN4->(msUnlock())
	                         
		TMPQRY->(dbSkip())
	enddo            
	
//	alert ("Criação de dados na Tabela SN4 criados com Sucesso !!")
	
return  


