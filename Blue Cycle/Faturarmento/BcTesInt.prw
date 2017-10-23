#include "protheus.ch"  
#INCLUDE "RWMAKE.CH" 
#INCLUDE "TBICONN.CH"  
#INCLUDE 'TOPCONN.CH'  

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  BcTesInt ºAutor  ³ VALDEMIR DO CARMO    º Data ³  10/08/2016 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Ponto de entrada da inclusao do item do pedido venda para  º±±
±±º          ³ para retornar a TES automaticamente    					  º±±
±±º          ³ que controla lote 										   ±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ PEDIDO DE VENDAS                                           º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/            
User Function BcTesInt(cOper)       
             
Local cProduto	:= aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})] 
Local cGrpProd	:= Posicione("SB1",1,xFilial("SB1")+aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})] ,"B1_GRTRIB")
Local cGrCli 	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_GRPTRIB")
//Local cOper		:= aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6__ITCROS"})] //M->C6__ITCROS //M->C6_OPER   ---ALTERAR APÓS VALIDAÇÃO
Local cUfCli	:= Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_EST")  
Local cTipoCF 	:= ""
Local cAliasQry	:= GetNextAlias()
Local cTesRet 	:= ""
Local cCst 		:= ""
Local cCfop 	:= ""


If M->C5_TIPO $ "DB"
	cTipoCF := "F"
Else
	cTipoCF := "C"
EndIf              


If cTipoCF = "C"


	cQuery := " SELECT FM_TS FROM SFM010 WHERE FM_TIPO = '"+cOper+"' AND FM_GRTRIB = '"+cGrCli+"' AND FM_EST = '"+cUFCli+"' AND FM_GRPROD = '"+cGrpProd+"' AND D_E_L_E_T_ = ' ' " 
	cQuery := ChangeQuery(cQuery)
	dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAliasQry,.F.,.T.)
	    

//	TCQUERY cQuery ALIAS "_SFM" NEW 
//	DbSelectArea("_SFM")
	cTesRet := (cAliasQry)->FM_TS

    cCst := Posicione("SB1",1,xFilial("SB1")+aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_PRODUTO"})] ,"B1_ORIGEM")+Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->FM_TS ,"F4_SITTRIB")
    
    If Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->FM_TS ,"F4_CF") = "6108" 
        cCfop := IF(cUfCli = "SC","5102",Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->FM_TS ,"F4_CF"))
    Else
    	cCfop := IF(cUfCli = "SC","5","6")+SUBSTR(Posicione("SF4",1,xFilial("SF4")+(cAliasQry)->FM_TS ,"F4_CF"),2,3)
    EndIf
    
	aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_CLASFIS"})] 	:= cCst
	aCols[n, aScan(aHeader, {|x| Upper(AllTrim(x[2])) == "C6_CF"})] 		:= cCfop    
	
	
//	(cAliasQry)->(DbCloseArea())
	
EndIf



Return(cTesRet)