#include "topconn.ch"
#include "tbiconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKA22				| 	Junho de 2014										  	|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Luis Carlos - Anadi														|
|-----------------------------------------------------------------------------------------------|	
|	Descri��o : Consulta de Clientes															|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ITMKA22()    
	local _aArea := GetArea()
	    
	aPar := U_ITMKA22A(.F.)
	
	exibeRel(aPar)
	
	restArea (_aArea)
return


static function exibeRel(aPar)
	
	SelRegs(aPar)

	Private aRotina   := {{"Parametros",'U_ITMKA22A(.T.)',0,1},;
	     				  {"Visualizar",'U_ITMKA22B(TMPSUAB->RECNO)',0, 2}}
	
	Private aCampos   := {{	"PEDIDO"  			,"PEDIDO"   	,"C",06,0,"@!"},;
						 {	"TIPO PEDIDO"  		,"TIPOPED"  	,"C",15,0,"@!"},;
						 {	"STATUS"		  	,"STATUS"  		,"C",15,0,"@!"},;
						 {	"DATA"  			,"EMISSAO" 	 	,"D",08,0,"@D"},;
						 {	"COD. CLIENTE"  	,"COD_CLI"  	,"C",06,0,"@!"},;
						 {	"CLIENTE"  			,"CLIENTE"		,"C",TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2],Posicione("SX3",2,"A1_NOME","X3_PICTURE")},;
						 {	"TOTAL DOS ITENS"	,"VLR_ITENS"  	,"N",TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2],Posicione("SX3",2,"C6_PRCVEN","X3_PICTURE")},;
						 {	"RECNO"  			,"RECNO" 	 	,"N",08,0,"99999999"}}

	Private cCampo    := "PEDIDO"
	Private cCadastro := "PEDIDO"
	
	DbSelectArea("TMPSUAB")
	DbSetOrder(1)
	
	DbSelectArea("TMPSUAB")
	mBrowse(6,1,22,75,"TMPSUAB",aCampos,cCampo)
	
	TMPSUAB->(dbCloseArea())
	
return


static function SelRegs(aPar)
                              
	Private aArqTmp   := {{"PEDIDO"  	,"C",06,0},;
						 {"TIPOPED"  	,"C",20,0},;
						 {"STATUS"  	,"C",30,0},;
						 {"EMISSAO"  	,"D",08,0},;
						 {"COD_CLI"  	,"C",06,0},;
						 {"RECNO"  		,"N",08,0},;
						 {"CLIENTE"  	,"C",TamSX3("A1_NOME")[1],TamSX3("A1_NOME")[2]},;
						 {"VLR_ITENS" 	,"N",TamSX3("C6_PRCVEN")[1],TamSX3("C6_PRCVEN")[2]}}

	_cQuery := "SELECT  MAX(UA_NUM) PEDIDO, "
	_cQuery += " 		MAX(UA_CLIENTE) COD_CLI, " 
	_cQuery += " 		MAX(A1_NOME) CLIENTE, " 
	_cQuery += "		MAX(UA_EMISSAO) EMISSAO, "
	_cQuery += "		MAX(UA__STATUS || ' - ' || ZM_DESC) STATUS, "
	_cQuery += "		MAX(UA__TIPPED || ' - ' || ZF_DESC) TIPOPED, "
	_cQuery += "		MAX(SUA.R_E_C_N_O_) RECNO, "
	_cQuery += "		SUM(UB_VRUNIT) VLR_ITENS " 
	_cQuery += "FROM " + retSqlName("SUA") + " SUA "
	_cQuery += "INNER JOIN " + retSqlName("SUB") + " SUB ON UB_NUM = UA_NUM "
	_cQuery += "										AND UB_FILIAL = UA_FILIAL "
	_cQuery += "										AND SUB.D_E_L_E_T_ <> '*' "
	_cQuery += "INNER JOIN " + retSqlName("SA1") + " SA1 ON A1_COD = UA_CLIENTE "
	_cQuery += "										AND A1_LOJA = UA_LOJA "
	_cQuery += "										AND SUB.D_E_L_E_T_ <> '*' "
	_cQuery += "LEFT JOIN " + retSqlName("SZM") + " SZM ON ZM_COD = UA__STATUS "
	_cQuery += "										AND SZM.D_E_L_E_T_ <> '*' "
	_cQuery += "LEFT JOIN " + retSqlName("SZF") + " SZF ON ZF_COD = UA__TIPPED "
	_cQuery += "										AND SZF.D_E_L_E_T_ <> '*' "
	_cQuery += "WHERE UA_FILIAL = '" + xFilial("SUA") + "' And UA_NUM >= '" + aPar[1] + "' "
	_cQuery += "  AND UA_NUM <= '" + aPar[2] + "' "
	_cQuery += "  AND UA_EMISSAO >= '" + dtos(aPar[3]) + "' "
	_cQuery += "  AND UA_EMISSAO <= '" + dtos(aPar[4]) + "' "
	_cQuery += "  AND SUA.D_E_L_E_T_ <> '*' "
	_cQuery += "GROUP BY UA_NUM "
	_cQuery += "ORDER BY UA_NUM "
         
 	cArquivo := CriaTrab(aArqTmp,.T.)
    dbUseArea(.T.,,cArquivo,"TMPSUAB",.F.,.F.)
    
    SQLToTrb(_cQuery,aArqTmp,"TMPSUAB")  
    
    Index on TMPSUAB->PEDIDO To &cArquivo
    dbGoTop()
     
return


user function ITMKA22A(_lRefresh)
    local _cPerg:= "ITMKA22"   
    local aMV	:= {}
	local oObj  := GetObjBrow()
	     
	AjustSX1(_cPerg)

	if !Pergunte(_cPerg,.T.) // Carrega as Perguntas do SX1
		return
	endif
         
	aadd(aMV, mv_par01)
	aadd(aMV, mv_par02)
	aadd(aMV, mv_par03)
	aadd(aMV, mv_par04)
	
	if _lRefresh
		TMPSUAB->(dbCloseArea())
		SelRegs(aMV)
		TMPSUAB->(dbGoTop())
	endif

return aMV


Static Function AjustSX1(_cPerg)
	
	PutSx1(_cPerg,"01","UF" 			," "," ","mv_ch1","C",02,0,0,"G","" ,"12","","","mv_par01","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"02","Cod. Municipio de"	," "," ","mv_ch2","C",05,0,0,"G","" ,"CC2ISA","","","mv_par02","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"03","Cod. Municipio ate"	," "," ","mv_ch3","C",05,0,0,"G","" ,"CC2ISA","","","mv_par03","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"04","Cliente de"		," "," ","mv_ch4","C",06,0,0,"G","" ,"SA1","","","mv_par04","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"05","Loja de"		," "," ","mv_ch4","C",04,0,0,"G","" ,"","","","mv_par05","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	

	PutSx1(_cPerg,"06","Cliente ate"	," "," ","mv_ch5","C",06,0,0,"G","" ,"SA1","","","mv_par06","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	PutSx1(_cPerg,"07","Loja ate"		," "," ","mv_ch5","C",04,0,0,"G","" ,"","","","mv_par07","" ,"" ,"" ,"","" ,"" ,"" ,"" ,"","","","","","","","","","","","")	
	
Return(_cPerg)                                                                                                     


                 
user Function ITMKA22B(rec)     
	local _aAreaATU	:= getArea()
	dbSelectArea("SUA")
	go rec

	TK271CallCenter("SUA",0,2)  
	
	restArea(_aAreaATU)
return