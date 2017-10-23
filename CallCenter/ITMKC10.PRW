#include "protheus.ch"
#include "topconn.ch"

/*
|-----------------------------------------------------------------------------------------------|	
|	Programa : ITMKC10			  		| 	Novembro de 2014				  					|
|-----------------------------------------------------------------------------------------------|
|	Desenvolvido por Jose Augusto F. P. Alves - Anadi		   									|
|-----------------------------------------------------------------------------------------------|	
|	Descrição : Consulta Ultimo Preco - Call Center											  	|
|-----------------------------------------------------------------------------------------------|	
*/

User Function ITMKC10(_cFilial, _cCliente, _cLoja, _cProduto)
                      
Private oButton1
Private oGet1
Private cGet1 := ""
Private oGet10
Private cGet10 := ""
Private oGet11
Private cGet11 := ""
Private oGet12
Private cGet12 := ""
Private oGet13
Private cGet13 := Ctod("  /  /  ")
Private oGet14
Private cGet14 := ""
Private oGet15
Private cGet15 := ""
Private oGet16
Private cGet16 := ""
Private oGet17
Private cGet17 := ""
Private oGet18
Private cGet18 := ""
Private oGet19
Private cGet19 := ""
Private oGet2
Private cGet2 := ""
Private oGet20
Private cGet20 := ""
Private oGet21
Private cGet21 := ""
Private oGet22
Private cGet22 := ""
Private oGet23
Private cGet23 := ""
Private oGet24
Private cGet24 := ""
Private oGet3
Private cGet3 := ""
Private oGet4
Private cGet4 := Ctod("  /  /  ")
Private oGet5
Private cGet5 := ""
Private oGet6
Private cGet6 := ""
Private oGet7
Private cGet7 := Ctod("  /  /  ")
Private oGet8
Private cGet8 := ""
Private oGet9
Private cGet9 := ""
Private oGroup1
Private oSay1
Private oSay10
Private oSay11
Private oSay12
Private oSay13
Private oSay14
Private oSay15
Private oSay16
Private oSay17 
Private oSay18
Private oSay2
Private oSay3
Private oSay4
Private oSay5
Private oSay6
Private oSay7
Private oSay8
Private oSay9
Private lRet := .F.

Private cFil := _cFilial
Private cCli := _cCliente
Private cLoj := _cLoja
Private cProd:= _cProduto

Static oDlg          

lRet := MontaQuery()
 
	If lRet
	  DEFINE MSDIALOG oDlg TITLE "Consulta Ultima Compra" FROM 000, 000  TO 500, 655 COLORS 0, 16777215 PIXEL
	
	    @ 009, 004 SAY oSay1 PROMPT "Local: " SIZE 017, 006 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 007, 024 MSGET oGet1 VAR cGet1 SIZE 021, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL 
	    @ 007, 048 MSGET oGet2 VAR cGet2 SIZE 156, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 026, 004 SAY oSay2 PROMPT "Data:" SIZE 018, 007 OF oDlg COLORS 0, 16777215 PIXEL 
	    @ 025, 024 MSGET oGet4 VAR cGet4 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 009, 211 SAY oSay3 PROMPT "Pedido:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 007, 242 MSGET oGet3 VAR cGet3 SIZE 079, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL      
	    
	    @ 025, 093 SAY oSay4 PROMPT "Data Faturamento:" SIZE 046, 009 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 024, 142 MSGET oGet7 VAR cGet7 SIZE 061, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL         
	    
	    @ 025, 211 SAY oSay5 PROMPT "Tipo Pedido:" SIZE 033, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 025, 243 MSGET oGet5 VAR cGet5 SIZE 018, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 025, 267 MSGET oGet6 VAR cGet6 SIZE 054, 010 OF oDlg COLORS 0, 16777215 PIXEL
	   
	    @ 045, 005 SAY oSay6 PROMPT "Cliente:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 042, 024 MSGET oGet8 VAR cGet8 SIZE 031, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	    @ 042, 058 MSGET oGet9 VAR cGet9 SIZE 145, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL 
	    
	    @ 045, 213 SAY oSay7 PROMPT "Contato" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 042, 243 MSGET oGet10 VAR cGet10 SIZE 078, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 061, 005 SAY oSay8 PROMPT "End. Faturamento:" SIZE 045, 008 OF oDlg COLORS 0, 16777215 PIXEL
 		@ 059, 058 MSGET oGet12 VAR cGet12 SIZE 182, 010 OF oDlg COLORS 0, 16777215 PIXEL
	    
	    @ 089, 028 GROUP oGroup1 TO 223, 294 PROMPT "   Ultima Compra do Produto Pelo Cliente   " OF oDlg COLOR 0, 16777215 PIXEL     
	    
	    @ 106, 049 SAY oSay9 PROMPT "Data:" SIZE 025, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 105, 086 MSGET oGet13 VAR cGet13 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL   
	    
	    @ 123, 049 SAY oSay10 PROMPT "Cond. Pagto:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 121, 086 MSGET oGet14 VAR cGet14 SIZE 024, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	    @ 121, 113 MSGET oGet15 VAR cGet15 SIZE 091, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 139, 050 SAY oSay11 PROMPT "Valor Base:" SIZE 031, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 137, 086 MSGET oGet16 VAR cGet16 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 156, 050 SAY oSay12 PROMPT "Preco Unitario:" SIZE 039, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 153, 086 MSGET oGet17 VAR cGet17 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL 
	    
	    @ 171, 050 SAY oSay13 PROMPT "Quantidade:" SIZE 030, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 170, 086 MSGET oGet18 VAR cGet18 SIZE 060, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL
	    
	    @ 192, 051 SAY oSay14 PROMPT "Desconto 1:" SIZE 035, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 203, 051 MSGET oGet19 VAR cGet19 SIZE 049, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL   
	    
	    @ 193, 104 SAY oSay15 PROMPT "Desconto 2:" SIZE 034, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 203, 104 MSGET oGet20 VAR cGet20 SIZE 050, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL  
	    
	    @ 193, 160 SAY oSay16 PROMPT "Desconto Pedido:" SIZE 043, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 203, 160 MSGET oGet22 VAR cGet22 SIZE 050, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL    
	    
	    @ 193, 216 SAY oSay17 PROMPT "Desconto Promocional:" SIZE 060, 007 OF oDlg COLORS 0, 16777215 PIXEL
	    @ 203, 216 MSGET oGet23 VAR cGet23 SIZE 055, 010 OF oDlg COLORS 0, 16777215 READONLY PIXEL     
	    
	    @ 230, 254 BUTTON oButton1 PROMPT "Retorna" SIZE 040, 012 OF oDlg ACTION oDlg:End() PIXEL
	
	  ACTIVATE MSDIALOG oDlg CENTERED    
	
	Else
		MsgInfo("Nao existe ultimo preco para o produto selecionado!")	
	Endif
Return       


Static Function MontaQuery()

Local cQuery := ""
Local cQuery2:= ""
Local nRecnot:= ""

	IF SELECT("TMP") > 0
		dbSelectArea("TMP")
		TMP->(dbCloseArea())
	Endif        
	
	cQuery :="SELECT SUB.R_E_C_N_O_ CHAVE , SUA.*, SUB.* "
	cQuery +=" FROM "+RetSqlName("SUA")+" SUA,"+RetSqlName("SUB")+" SUB,"+RetSqlName("SD2")+" SD2,"+RetSqlName("SF4")+" SF4 "  
	cQuery +=" WHERE SUA.D_E_L_E_T_ <> '*' "
	cQuery +=" AND SUB.D_E_L_E_T_ <> '*' "   
	cQuery +=" AND SD2.D_E_L_E_T_ <> '*' "
	cQuery +=" AND SF4.D_E_L_E_T_ <> '*' "  
	cQuery +=" AND SUA.UA_NUM = SUB.UB_NUM "
	cQuery +=" AND SUA.UA_FILIAL = '"+AllTrim(cFil)+"'" 
	cQuery +=" AND SUA.UA_CLIENTE = '"+AllTrim(cCli)+"'"
	cQuery +=" AND SUA.UA_LOJA = '"+AllTrim(cLoj)+"'"
	cQuery +=" AND SUB.UB_PRODUTO = '"+cProd+"'"
	cQuery +=" AND SUA.UA__TIPPED = '1'"
	cQuery +=" AND SUB.UB_FILIAL = SD2.D2_FILIAL"
	cQuery +=" AND SUB.UB_NUMPV = SD2.D2_PEDIDO"
	cQuery +=" AND SUB.UB_ITEMPV = SD2.D2_ITEMPV"
	cQuery +=" AND SUA.UA_CLIENTE = SD2.D2_CLIENTE" 
	cQuery +=" AND SUA.UA_LOJA = SD2.D2_LOJA" 
	//cQuery +=" AND SF4.F4_FILIAL = '"+xFilial("SF4")+"'" 
	cQuery +=" AND SF4.F4_CODIGO = SD2.D2_TES"  
	cQuery +=" AND SF4.F4_ESTOQUE = 'S'" 
	cQuery +=" AND SF4.F4_DUPLIC = 'S'"	
	cQuery +=" ORDER BY SUB.R_E_C_N_O_"   	
	
	/*cQuery :="SELECT SUB.R_E_C_N_O_ CHAVE , SUA.*, SUB.* "
	cQuery +=" FROM "+RetSqlName("SUA")+" SUA,"+RetSqlName("SUB")+" SUB "  
	cQuery +=" WHERE SUA.D_E_L_E_T_ <> '*' "
	cQuery +=" AND SUB.D_E_L_E_T_ <> '*' " 
	cQuery +=" AND SUA.UA_NUM = SUB.UB_NUM "
	cQuery +=" AND SUA.UA_FILIAL = '01'" 
	cQuery +=" AND SUA.UA_CLIENTE = '10142551'"
	cQuery +=" AND SUA.UA_LOJA = '143'"
	cQuery +=" AND SUB.UB_PRODUTO = '1170'"
	cQuery +=" AND SUA.UA__TIPPED = '00001'"
	cQuery +=" ORDER BY SUB.R_E_C_N_O_"*/  	
	        
	        
	DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),"TMP",.F.,.T.)
	TMP->( DbGoTop() )
    	
 	If TMP->(!Eof())
 		cDtEmiss := TMP->UA_EMISSAO 
 		While TMP->(!EOF())
 			IF TMP->UA_EMISSAO >= cDtEmiss  
 		    	nRecnot := TMP->CHAVE
 				lRet := .T. 
 				cDtEmiss := TMP->UA_EMISSAO
 			EndIf
 			TMP->(DbSkip())
 		End
 		TMP->(dbCloseArea())
 	Else
 		lRet := .F. 
 	Endif
 	
 	If lRet 
 	
	 	IF SELECT("TMP1") > 0
			dbSelectArea("TMP1")
			TMP1->(dbCloseArea())
		Endif        
	 
		cQuery2 :=" SELECT * "
		cQuery2 +=" FROM "+RetSqlName("SUA")+" SUA,"+RetSqlName("SUB")+" SUB,"+RetSqlName("SD2")+" SD2 "  
		cQuery2 +=" WHERE SUA.D_E_L_E_T_ <> '*' "
		cQuery2 +=" AND SUB.D_E_L_E_T_ <> '*' " 
		cQuery2 +=" AND SUA.UA_NUM = SUB.UB_NUM "
		cQuery2 +=" AND SUB.UB_FILIAL = SD2.D2_FILIAL"
		cQuery2 +=" AND SUB.UB_NUMPV = SD2.D2_PEDIDO"
		cQuery2 +=" AND SUB.UB_ITEMPV = SD2.D2_ITEMPV"
		cQuery2 +=" AND SUA.UA_CLIENTE = SD2.D2_CLIENTE" 
		cQuery2 +=" AND SUA.UA_LOJA = SD2.D2_LOJA"    
		cQuery2 +=" AND SUB.R_E_C_N_O_ = '"+Alltrim(Str(nRecnot))+"' "			
	        
	        
		DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery2),"TMP1",.F.,.T.)
		TMP1->( DbGoTop() )
    	
	 	If TMP1->(!Eof()) 
	 	
	 		While TMP1->(!EOF())  
				cGet1  := TMP1->UA__FILIAL 																//"Local:
				SM0->( dbSetOrder( 1 ) )
				SM0->( dbSeek( cEmpAnt + TMP1->UA__FILIAL ) )			   													 
				cGet2  := SM0->M0_FILIAL																//"Desc Local: 	   
				cGet4  := StoD(TMP1->UA_EMISSAO)														//"Data:"	
	   			cGet3  := TMP1->UA_NUM																	//"Pedido:"
				cGet7  := StoD(TMP1->UA__PRVFAT)	   													//"Data Faturamento:"
	            cGet5  := TMP1->UA__TIPPED			   													//"Tipo Pedido:"     
	    		cGet6  := posicione("SZF",1,xFilial("SZF")+TMP1->UA__TIPPED,"ZF_DESC")					//"Tipo Pedido:" 
	    		cGet8  := TMP1->UA_CLIENTE																//"Cod. Cliente:"
	   			cGet9  := posicione("SA1",1,xFilial("SA1")+TMP1->UA_CLIENTE+TMP1->UA_LOJA,"A1_NOME") 	//"Nome Cliente:"
	   			cGet10 := TMP1->UA_DESCNT																//"Contato"
	    		cGet12 := posicione("SA1",1,xFilial("SA1")+TMP1->UA_CLIENTE+TMP1->UA_LOJA,"A1_END") 	//"End. Faturamento:"
	    
				//"   Ultima Compra do Produto Pelo Cliente   " 
				
				cGet13 := StoD(TMP1->UB_DTENTRE)										//"Data:"
	     		cGet14 := TMP1->UA_CONDPG			   									//"Cond. Pagto:"
	           	cGet15 := posicione("SE4",1,xFilial("SE4")+TMP1->UA_CONDPG,"E4_DESCRI") //"Desc Cond. Pagto:" 
	           	cGet16 := Transform(TMP1->UB_PRCTAB,"@E 99,999,999.99") 				//"Valor Base:" 
	           	cGet17 := Transform(TMP1->D2_PRCVEN,"@E 99,999,999.99")					//"Preco Unitario:"
	    		cGet18 := Transform(TMP1->UB_QUANT,"@E 99,999,999.99")					//"Quantidade:"
	   			cGet19 := Transform(TMP1->UB__DESC2,"@E 99,999,999.99")					//"Desconto 1:"
	    		cGet20 := Transform(TMP1->UB__DESC3,"@E 99,999,999.99")					//"Desconto 2:"
	    		cGet22 := Transform(TMP1->UB__DESCCP,"@E 99,999,999.99")				//"Desconto Pedido:"
	    		cGet23 := Transform(TMP1->UB__DESCP,"@E 99,999,999.99")			   		//"Desconto Promocional:"

	 			TMP1->(DbSkip())
	 		End
	 		TMP1->(dbCloseArea())
	 		
	 	Endif 
	 	
	EndiF
 
 Return lRet         