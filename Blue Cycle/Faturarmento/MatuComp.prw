#INCLUDE "RWMAKE.CH"  
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

User Function Matucomp()
Local lExiste := .F.

//CD6_FILIAL+CD6_TPMOV+CD6_SERIE+CD6_DOC+CD6_CLIFOR+CD6_LOJA+CD6_ITEM+CD6_COD+CD6_PLACA+CD6_TANQUE                                                                

//dbSelectArea("CD6")
//CD6->(dbSetOrder(1))             
//lExiste := CD6->(dbSeek(xFilial("CD6")+ParamIXB[1]+ParamIXB[2]+ParamIXB[3]+ParamIXB[4]+ParamIXB[5]))
If ParamIXB[1] = "S" 


	cQuery := "SELECT D2_ITEM, D2_SERIE, D2_DOC, D2_COD, B1_CDANP "
	cQuery += "FROM " + RetSqlName("SD2") + " D2 "
	cQuery += "INNER JOIN " + RetSqlName("SB1") + " B1 "
	cQuery += " ON B1_COD = D2_COD AND D2_SERIE = '"+ParamIXB[2]+"' AND D2_DOC = '"+ParamIXB[3]+"'"	
	cQuery += " WHERE B1.D_E_L_E_T_ <> '*' AND D2.D_E_L_E_T_ <> '*' AND B1_GRUPO = '32'"


	dbUseArea(.T.,"TOPCONN",TCGenQry(,,cQuery),"QSD2",.F.,.T.)   
	
	QSD2->(dbGoTop())

	//cContIt := 	StrZero(1,(TamSX3("DA1_ITEM")[01]))



	While QSD2->(! EoF()) 
		dbSelectArea("CD6")
		RecLock("CD6",.T.)
		CD6->CD6_FILIAL :=  xFilial("CD6")
		CD6->CD6_TPMOV  :=  ParamIXB[1] 
		CD6->CD6_DOC	:= 	ParamIXB[3]
		CD6->CD6_SERIE	:=  ParamIXB[2]
		CD6->CD6_CLIFOR	:=  ParamIXB[4]
		CD6->CD6_LOJA	:=  ParamIXB[5]
		CD6->CD6_ITEM	:=  QSD2->D2_ITEM
		CD6->CD6_COD 	:=	QSD2->D2_COD
		CD6->CD6_CODANP	:=  QSD2->B1_CDANP	
		CD6->CD6_UFCONS	:=  Posicione("SA1",1,xFilial("SA1")+ParamIXB[4]+ParamIXB[5],"A1_EST")
		MsUnlock("CD6")   	
	
	
	 	QSD2->(dbSkip())

	EndDo
    
	QSD2->(dbCloseArea())

/*DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)


If !Empty(SB1->B1_CDANP) .and. Alltrim(SB1->B1_GRUPO) $ AllTrim(GetMv("MV_COMBUS"))
	dbSelectArea("CD6")
	RecLock("CD6",.T.)
	CD6->CD6_FILIAL :=  xFilial("CD6")
	CD6->CD6_TPMOV  :=  ParamIXB[1]             
	CD6->CD6_DOC	:= 	ParamIXB[3]
	CD6->CD6_SERIE	:=  ParamIXB[2]
	CD6->CD6_CLIFOR	:=  ParamIXB[4]
	CD6->CD6_LOJA	:=  ParamIXB[5]
	CD6->CD6_ITEM	:=  SD2->D2_ITEM
	CD6->CD6_COD 	:=	SD2->D2_COD
	CD6->CD6_CODANP	:=  SB1->B1_CDANP	
	CD6->CD6_UFCONS	:=  Posicione("SA1",1,xFilial("SA1")+ParamIXB[4]+ParamIXB[5],"A1_EST")
	MsUnlock("CD6")   
	DbCloseArea("SB1")
EndIf*/
                    
EndIf 
Return